<#
.SYNOPSIS
Downloads Microsoft Updates for use in OSDBuilder

.DESCRIPTION
Downloads Microsoft Updates for use in OSDBuilder

.LINK
https://osdbuilder.osdeploy.com
#>
function Save-OSDBuilderDownload {
    [CmdletBinding(DefaultParameterSetName='OSDUpdate')]
    param (

        #Download OneDrive Sync Client
        [Parameter(ParameterSetName='Content')]
        [ValidateSet(
            'OneDriveSetup Production',
            'OneDriveSetup Enterprise')]
        [string]$ContentDownload,
        
        #Download the selected Microsoft Updates
        #By default, updates are not downloaded
        [Parameter(ParameterSetName='OSDUpdate')]
        [switch]$Download,

        #Skip Feature Updates GridView
        #Be careful as this will automatically download
        [Parameter(ParameterSetName='FeatureUpdates')]
        [switch]$SkipGridView,

        #Downloads Feature Updates
        [Parameter(ParameterSetName='FeatureUpdates',Mandatory = $True)]
        [switch]$FeatureUpdates,

        #Feature Update Architecture
        [Parameter(ParameterSetName = 'FeatureUpdates')]
        [ValidateSet ('Windows 10','Windows 11')]
        [string]$FeatureOS,

        #Feature Update Architecture
        [Parameter(ParameterSetName = 'FeatureUpdates')]
        [ValidateSet ('x64','x86')]
        [string]$FeatureArch,

        #Feature Update Build
        [Parameter(ParameterSetName = 'FeatureUpdates')]
        [ValidateSet ('22H2','21H2','21H1','20H2',2004,1909,1903,1809)]
        [string]$FeatureBuild,

        #Feature Update Edition
        [Parameter(ParameterSetName = 'FeatureUpdates')]
        [ValidateSet ('Business','Consumer')]
        [string]$FeatureEdition,

        #Feature Update Language
        [Parameter(ParameterSetName = 'FeatureUpdates')]
        [ValidateSet (
            'ar-sa','bg-bg','cs-cz','da-dk','de-de','el-gr',
            'en-gb','en-us','es-es','es-mx','et-ee','fi-fi',
            'fr-ca','fr-fr','he-il','hr-hr','hu-hu','it-it',
            'ja-jp','ko-kr','lt-lt','lv-lv','nb-no','nl-nl',
            'pl-pl','pt-br','pt-pt','ro-ro','ru-ru','sk-sk',
            'sl-si','sr-latn-rs','sv-se','th-th','tr-tr',
            'uk-ua','zh-cn','zh-tw'
        )]
        [string[]]$FeatureLang,

        #Display the results in a GridView with PassThru enabled
        [Parameter(ParameterSetName='OSDUpdate')]
        [switch]$GridView,
        
        #Remove Superseded Updates that are no longer needed
        [Parameter(ParameterSetName = 'OSDUpdateSuperseded', Mandatory = $True)]
        [ValidateSet ('List','Remove')]
        [string]$Superseded,

        #Filter Microsoft Updates for a specific OS Architecture
        [Parameter(ParameterSetName = 'OSDUpdate')]
        [ValidateSet ('x64','x86')]
        [string]$UpdateArch,

        #Filter Microsoft Updates for a specific ReleaseId
        [Parameter(ParameterSetName='OSDUpdate')]
        [ValidateSet ('22H2','21H2','21H1','20H2',2004,1909,1903,1809,1803,1709,1703,1607,1511,1507,7601,7603)]
        [Alias('ReleaseId')]
        [string]$UpdateBuild,

        #Filter Microsoft Updates for a specific Update type
        [Parameter(ParameterSetName='OSDUpdate')]
        [ValidateSet(
            'SSU Servicing Stack Update',
            'LCU Latest Cumulative Update',
            'DUSU Setup Dynamic Update',
            'DUCU Component Dynamic Update',
            'Adobe Flash Player',
            'DotNet Framework',
            'Optional')]
        [string]$UpdateGroup,
        
        #Filter Microsoft Updates for a specific OS
        [Parameter(ParameterSetName='OSDUpdate')]
        [ValidateSet(
            'Windows 10',
            'Windows 11',
            'Windows Server 2019',
            'Windows Server 2022',
            'Windows Server')]
        [string]$UpdateOS,

        #Download updates using Webclient instead of BITS
        [Parameter(ParameterSetName='OSDUpdate')]
        [switch]$WebClient,

        [Parameter(ParameterSetName='OSDUpdate')]
        [switch]$CheckFileHash

    )

    Begin {
        Get-OSDBuilder -CreatePaths -HideDetails
        Block-StandardUser
    }

    Process {
        #=================================================
        #   Test WebClient
        #=================================================
        $UseWebClient = $false
        $UseWebRequest = $false
        $UseCurl = $false

        if ($WebClient.IsPresent) {$UseWebClient = $true}
        if (([System.Net.WebRequest]::DefaultWebProxy).Address) {$UseWebClient = $true}
        if (Get-Command 'curl.exe' -ErrorAction SilentlyContinue) {
            $UseCurl = $true
        }
        else {
            $UseWebClient = $true
        }
        if ($UseWebClient -eq $true) {
            [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls1
            $WebClientObj = New-Object System.Net.WebClient
        }
        #=================================================
        #   FeatureUpdates
        #=================================================
        if ($FeatureUpdates.IsPresent) {
            #Write-Warning "FeatureUpdates are downloaded using BITS Transfer"
            Write-Warning "Windows Server 2016 (1607) does not support decompressing ESD Files"
            #=================================================
            #   Get FeatureUpdateDownloads
            #=================================================
            $FeatureUpdateDownloads = @()
            $FeatureUpdateDownloads = Get-FeatureUpdateDownloads
            #=================================================
            #   Filters
            #=================================================
            if ($FeatureOS) {$FeatureUpdateDownloads = $FeatureUpdateDownloads | Where-Object {$_.UpdateOS -eq $FeatureOS}}
            if ($FeatureArch) {$FeatureUpdateDownloads = $FeatureUpdateDownloads | Where-Object {$_.UpdateArch -eq $FeatureArch}}
            if ($FeatureBuild) {$FeatureUpdateDownloads = $FeatureUpdateDownloads | Where-Object {$_.UpdateBuild -eq $FeatureBuild}}
            if ($FeatureEdition) {$FeatureUpdateDownloads = $FeatureUpdateDownloads | Where-Object {$_.Title -match $FeatureEdition}}
            if ($FeatureLang) {
                $regex = $FeatureLang.ForEach({ [RegEx]::Escape($_) }) -join '|'
                $FeatureUpdateDownloads = $FeatureUpdateDownloads | Where-Object {$_.Title -match $regex}
            }
            #=================================================
            #   Select-Object
            #=================================================
            $FeatureUpdateDownloads = $FeatureUpdateDownloads | Select-Object -Property OSDStatus, Title, UpdateOS,`
            UpdateBuild, UpdateArch, CreationDate, KBNumber, FileName, Size, OriginUri, Hash, AdditionalHash
            #=================================================
            #   Sorting
            #=================================================
            $FeatureUpdateDownloads = $FeatureUpdateDownloads | Sort-Object -Property Title
            #=================================================
            #   Select Updates with GridView
            #=================================================
            if (! ($SkipGridView.IsPresent)) {
                $FeatureUpdateDownloads = $FeatureUpdateDownloads | Out-GridView -PassThru -Title 'Select ESD Files to Download and Build and press OK'
            }
            #=================================================
            #   Download
            #=================================================
            foreach ($Item in $FeatureUpdateDownloads) {
                $DownloadFullPath = Join-Path $SetOSDBuilderPathFeatureUpdates $Item.FileName

                if (!(Test-Path $SetOSDBuilderPathFeatureUpdates)) {
                    New-Item -Path $SetOSDBuilderPathFeatureUpdates -ItemType Directory -Force | Out-Null
                }
                Write-Host "$DownloadFullPath" -ForegroundColor Cyan
                Write-Host "$($Item.OriginUri)" -ForegroundColor DarkGray
                if (!(Test-Path $DownloadFullPath)) {
                    #=================================================
                    #   Download File
                    #=================================================
                    if ($UseWebClient -eq $true) {
                        $WebClientObj.DownloadFile("$($Item.OriginUri)","$DownloadFullPath")
                    }
                    elseif ($UseCurl -eq $true) {
                        if ($host.name -match 'ConsoleHost') {
                            Invoke-Expression "& curl.exe --insecure --location --output `"$DownloadFullPath`" --url `"$($Item.OriginUri)`""
                        }
                        else {
                            #PowerShell ISE will display a NativeCommandError, so progress will not be displayed
                            $Quiet = Invoke-Expression "& curl.exe --insecure --location --output `"$DownloadFullPath`" --url `"$($Item.OriginUri)`" 2>&1"
                        }
                    }
                    else {
                        Start-BitsTransfer -Source $Item.OriginUri -Destination $DownloadFullPath -ErrorAction Stop
                    }
                }
                #=================================================
                #   Verify Download
                #=================================================
                if (! (Test-Path $DownloadFullPath)) {
                    Write-Warning "Could not complete download of $DownloadFullPath"
                    Break
                }

                $esdbasename = (Get-Item "$DownloadFullPath").Basename
                $esddirectory = Join-Path $SetOSDBuilderPathFeatureUpdates $esdbasename

                if (Test-Path "$esddirectory\Sources\Install.wim") {
                    Write-Verbose "Image already exists at $esddirectory\Sources\Install.wim" -Verbose
                } else {
                    Try {$esdinfo = Get-WindowsImage -ImagePath "$DownloadFullPath"}
                    Catch {
                        Write-Warning "Could not get ESD information"
                        Break
                    }
                    Write-Host "Creating $esddirectory" -ForegroundColor Cyan
                    New-Item -Path "$esddirectory" -Force -ItemType Directory | Out-Null
                    
                    foreach ($image in $esdinfo) {
                        if ($image.ImageName -eq 'Windows Setup Media') {
                            Write-Host "Expanding Index $($image.ImageIndex) $($image.ImageName) ..." -ForegroundColor Cyan
                            Expand-WindowsImage -ImagePath "$($image.ImagePath)" -ApplyPath "$esddirectory" -Index "$($image.ImageIndex)" -ErrorAction SilentlyContinue | Out-Null
                        } elseif ($image.ImageName -like "*Windows PE*") {
                            Write-Host "Exporting Index $($image.ImageIndex) $($image.ImageName) ..." -ForegroundColor Cyan
                            Export-WindowsImage -SourceImagePath "$($image.ImagePath)" -SourceIndex $($image.ImageIndex) -DestinationImagePath "$esddirectory\sources\boot.wim" -CompressionType Max -ErrorAction SilentlyContinue | Out-Null
                        } elseif ($image.ImageName -like "*Windows Setup*") {
                            Write-Host "Exporting Index $($image.ImageIndex) $($image.ImageName) ..." -ForegroundColor Cyan
                            Export-WindowsImage -SourceImagePath "$($image.ImagePath)" -SourceIndex $($image.ImageIndex) -DestinationImagePath "$esddirectory\sources\boot.wim" -CompressionType Max -Setbootable -ErrorAction SilentlyContinue | Out-Null
                        } else {
                            Write-Host "Exporting Index $($image.ImageIndex) $($image.ImageName) ..." -ForegroundColor Cyan
                            Export-WindowsImage -SourceImagePath "$($image.ImagePath)" -SourceIndex $($image.ImageIndex) -DestinationImagePath "$esddirectory\sources\install.wim" -CompressionType Max -ErrorAction SilentlyContinue | Out-Null
                        }
                    }
                }
            }
            Write-Warning "Use Import-OSMedia to import this Feature Update to OSMedia"
        }

        if ($PSCmdlet.ParameterSetName -eq 'Content') {
            #=================================================
            #   Database
            #=================================================
            if ($ContentDownload -eq 'OneDriveSetup Production') {
                $DownloadUrl = 'https://go.microsoft.com/fwlink/?linkid=844652'
                $DownloadPath = $GetOSDBuilderPathContentOneDrive
                $DownloadFile = 'OneDriveSetup.exe'
            }
            if ($ContentDownload -eq 'OneDriveSetup Enterprise') {
                $DownloadUrl = 'https://go.microsoft.com/fwlink/p/?linkid=860987'
                $DownloadPath = $GetOSDBuilderPathContentOneDrive
                $DownloadFile = 'OneDriveSetup.exe'
            }
            #=================================================
            #   Download
            #=================================================
            if (!(Test-Path "$DownloadPath")) {New-Item -Path $DownloadPath -ItemType Directory -Force | Out-Null}
            Write-Verbose "DownloadUrl: $DownloadUrl" -Verbose
            Write-Verbose "DownloadPath: $DownloadPath" -Verbose
            Write-Verbose "DownloadFile: $DownloadFile" -Verbose
            #=================================================
            #   Download File
            #=================================================
            if ($UseWebClient -eq $true) {
                $WebClientObj.DownloadFile("$DownloadUrl","$DownloadPath\$DownloadFile")
            }
            elseif ($UseWebRequest -eq $true) {
                Invoke-WebRequest -Uri $DownloadUrl -OutFile "$DownloadPath\$DownloadFile"
            }
            elseif ($UseCurl -eq $true) {
                if ($host.name -match 'ConsoleHost') {
                    #Invoke-Expression "& curl.exe --insecure --location --output `"$DownloadFullPath`" --url `"$($Item.OriginUri)`""
                    Invoke-Expression "& curl.exe --insecure --location --output `"$DownloadPath\$DownloadFile`" --url `"$DownloadUrl`""
                }
                else {
                    #PowerShell ISE will display a NativeCommandError, so progress will not be displayed
                    #$Quiet = Invoke-Expression "& curl.exe --insecure --location --output `"$DownloadFullPath`" --url `"$($Item.OriginUri)`" 2>&1"
                    $Quiet = Invoke-Expression "& curl.exe --insecure --location --output `"$DownloadPath\$DownloadFile`" --url `"$DownloadUrl`" 2>&1"
                }
            }
            else {
                #Start-BitsTransfer -Source $Item.OriginUri -Destination $DownloadFullPath -ErrorAction Stop
            }

            if (Test-Path "$DownloadPath\$DownloadFile") {
                $OneDriveSetupInfo = Get-Item -Path "$DownloadPath\$DownloadFile" | Select-Object -Property *
                Write-Verbose "DownloadVersion: $($($OneDriveSetupInfo).VersionInfo.ProductVersion)" -Verbose
                Write-Verbose 'Complete' -Verbose
            } else {
                Write-Warning 'Content could not be downloaded'
            }
        }

        if (($PSCmdlet.ParameterSetName -eq 'OSDUpdate') -or ($PSCmdlet.ParameterSetName -eq 'OSDUpdateSuperseded')) {
            #=================================================
            #   Information
            #=================================================
            if ($WebClient.IsPresent) {
                Write-Verbose "Downloading OSDUpdates using System.Net.WebClient" -Verbose
            } else {
                Write-Verbose "Downloading OSDUpdates using BITS-Transfer" -Verbose
                Write-Verbose "To use System.Net.WebClient, use the -WebClient Parameter" -Verbose
            }
            #=================================================
            #   Get OSDUpdates
            #=================================================
            $OSDUpdates = @()
            $OSDUpdates = Get-OSDUpdates | Sort-Object CreationDate -Descending
            #=================================================
            #   Superseded Updates
            #=================================================
            if ($Superseded) {
                $ExistingUpdates = @()
                if (!(Test-Path $SetOSDBuilderPathUpdates)) {New-Item $SetOSDBuilderPathUpdates -ItemType Directory -Force | Out-Null}
                $ExistingUpdates = Get-ChildItem -Path "$SetOSDBuilderPathUpdates\*\*" -Directory

                $SupersededUpdates = @()
                foreach ($Update in $ExistingUpdates) {
                    if ($OSDUpdates.Title -NotContains $Update.Name) {$SupersededUpdates += $Update.FullName}
                }
            
                if ($Superseded -eq 'List') {
                    Write-Warning 'Superseded Updates:'
                    foreach ($Update in $SupersededUpdates) {
                        Write-Host "$Update" -ForegroundColor Gray
                    }
                }
                if ($Superseded -eq 'Remove') {
                    Write-Warning 'Superseded Updates:'
                    foreach ($Update in $SupersededUpdates) {
                        Write-Warning "Deleting $Update"
                        Remove-Item $Update -Recurse -Force | Out-Null
                    }
                }
                Break
            }
            #=================================================
            #   Filters
            #=================================================
            if ($UpdateOS) {$OSDUpdates = $OSDUpdates | Where-Object {$_.UpdateOS -eq $UpdateOS}}
            if ($UpdateArch) {$OSDUpdates = $OSDUpdates | Where-Object {$_.UpdateArch -eq $UpdateArch}}
            if ($UpdateBuild) {$OSDUpdates = $OSDUpdates | Where-Object {$_.UpdateBuild -eq $UpdateBuild}}
            #=================================================
            #   UpdateGroup
            #=================================================
            if ($UpdateGroup -like "*Adobe*") {$OSDUpdates = $OSDUpdates | Where-Object {$_.UpdateGroup -eq 'AdobeSU'}}
            if ($UpdateGroup -like "*DotNet*") {$OSDUpdates = $OSDUpdates | Where-Object {$_.UpdateGroup -like "DotNet*"}}
            if ($UpdateGroup -like "*DUCU*") {$OSDUpdates = $OSDUpdates | Where-Object {$_.UpdateGroup -like "ComponentDU*"}}
            if ($UpdateGroup -like "*DUSU*") {$OSDUpdates = $OSDUpdates | Where-Object {$_.UpdateGroup -eq 'SetupDU'}}
            if ($UpdateGroup -like "*LCU*") {$OSDUpdates = $OSDUpdates | Where-Object {$_.UpdateGroup -eq 'LCU'}}
            if ($UpdateGroup -like "*SSU*") {$OSDUpdates = $OSDUpdates | Where-Object {$_.UpdateGroup -eq 'SSU'}}
            if ($UpdateGroup -eq 'Optional') {$OSDUpdates = $OSDUpdates | Where-Object {[String]::IsNullOrWhiteSpace($_.UpdateGroup) -or $_.UpdateGroup -eq 'Optional'}}
            #=================================================
            #   Sorting
            #=================================================
            $OSDUpdates = $OSDUpdates | Sort-Object -Property CreationDate -Descending
            #=================================================
            #   Select Updates with GridView
            #=================================================
            if ($GridView.IsPresent) {$OSDUpdates = $OSDUpdates | Out-GridView -PassThru -Title 'Select Updates to Download and press OK'}
            #=================================================
            #   Download Updates
            #=================================================
            if ($Download.IsPresent) {
				if ($WebClient.IsPresent) {
                    [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls1
                    $WebClientObj = New-Object System.Net.WebClient
                }
                foreach ($Update in $OSDUpdates) {
                    $DownloadPath = "$SetOSDBuilderPathUpdates"
                    $DownloadFullPath = Join-Path $DownloadPath $(Split-Path $Update.OriginUri -Leaf)

                    if (!(Test-Path $DownloadPath)) {New-Item -Path "$DownloadPath" -ItemType Directory -Force | Out-Null}
                    if (!(Test-Path $DownloadFullPath)) {
                        Write-Host "$DownloadFullPath" -ForegroundColor Cyan
                        Write-Host "$($Update.OriginUri)" -ForegroundColor DarkGray
                        #=================================================
                        #   Download File
                        #=================================================
                        if ($UseWebClient -eq $true) {
                            $WebClientObj.DownloadFile("$($Update.OriginUri)","$DownloadFullPath")
                        }
                        elseif ($UseCurl -eq $true) {
                            if ($host.name -match 'ConsoleHost') {
                                Invoke-Expression "& curl.exe --insecure --location --output `"$DownloadFullPath`" --url `"$($Update.OriginUri)`""
                            }
                            else {
                                #PowerShell ISE will display a NativeCommandError, so progress will not be displayed
                                $Quiet = Invoke-Expression "& curl.exe --insecure --location --output `"$DownloadFullPath`" --url `"$($Update.OriginUri)`" 2>&1"
                            }
                        }
                        else {
                            Start-BitsTransfer -Source $Update.OriginUri -Destination $DownloadFullPath
                        }
                        if ($CheckFileHash.IsPresent -and ($Update.Hash -ne "")) {
                            $ActualHash = $null
                            $ActualHash = (Get-FileHash -Path $DownloadFullPath -Algorithm SHA1).Hash.ToLower()
                            $DeriredHash = Convert-ByteArrayToHex -Bytes $($update.Hash -split " ")
                            Write-Verbose "Desired SHA1 Hash: [$DeriredHash], Actual Hash [$ActualHash]"
                            if ($ActualHash -ne $DeriredHash) {
                                Write-Error -Exception "Hashes don't match - please investigate!" 
                            }
                            else {
                                Write-Verbose -Message "Hashes match."
                            }
                        }
                    } else {
                        #Write-Warning "Exists: $($Update.Title)"
                    }
                }
            } else {
                Return $OSDUpdates | Select-Object -Property Catalog, OSDVersion, OSDStatus, UpdateOS, UpdateBuild, UpdateArch, UpdateGroup, CreationDate, KBNumber, Title
            }
        }
    }

    End {
    }
}
