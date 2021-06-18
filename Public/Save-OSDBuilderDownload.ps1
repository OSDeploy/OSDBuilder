<#
.SYNOPSIS
Downloads Microsoft Updates for use in OSDBuilder

.DESCRIPTION
Downloads Microsoft Updates for use in OSDBuilder

.LINK
https://osdbuilder.osdeploy.com/module/functions/Save-OSDBuilderDownload
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
        [ValidateSet ('x64','x86')]
        [string]$FeatureArch,

        #Feature Update Build
        [Parameter(ParameterSetName = 'FeatureUpdates')]
        [ValidateSet ('21H1','20H2',2004,1909,1903,1809)]
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
        [ValidateSet ('21H1','20H2',2004,1909,1903,1809,1803,1709,1703,1607,1511,1507,7601,7603)]
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
            'Windows 7',
            'Windows 10',
            'Windows Server 2012 R2',
            'Windows Server 2016',
            'Windows Server 2019',
            'Windows Server')]
        [string]$UpdateOS,

        #Download updates using Webclient instead of BITS
        [Parameter(ParameterSetName='OSDUpdate')]
        [switch]$WebClient,

        [Parameter(ParameterSetName='OSDUpdate')]
        [switch]$CheckFileHash

    )

    Begin {
        #===================================================================================================
        #   Get-OSDBuilder
        #===================================================================================================
        Get-OSDBuilder -CreatePaths -HideDetails
        #===================================================================================================
        #   Block
        #===================================================================================================
        Block-StandardUser
        #===================================================================================================
    }

    PROCESS {
        #Write-Host '========================================================================================' -ForegroundColor DarkGray
        #Write-Host -ForegroundColor Green "$($MyInvocation.MyCommand.Name) PROCESS"

        #===================================================================================================
        #   FeatureUpdates
        #===================================================================================================
        if ($FeatureUpdates.IsPresent) {
            Write-Warning "FeatureUpdates are downloaded using BITS Transfer"
            Write-Warning "Windows Server 2016 (1607) does not support decompressing ESD Files"
            #===================================================================================================
            #   Get FeatureUpdateDownloads
            #===================================================================================================
            $FeatureUpdateDownloads = @()
            $FeatureUpdateDownloads = Get-FeatureUpdateDownloads
            #===================================================================================================
            #   Filters
            #===================================================================================================
            if ($FeatureArch) {$FeatureUpdateDownloads = $FeatureUpdateDownloads | Where-Object {$_.UpdateArch -eq $FeatureArch}}
            if ($FeatureBuild) {$FeatureUpdateDownloads = $FeatureUpdateDownloads | Where-Object {$_.UpdateBuild -eq $FeatureBuild}}
            if ($FeatureEdition) {$FeatureUpdateDownloads = $FeatureUpdateDownloads | Where-Object {$_.Title -match $FeatureEdition}}
            if ($FeatureLang) {
                $regex = $FeatureLang.ForEach({ [RegEx]::Escape($_) }) -join '|'
                $FeatureUpdateDownloads = $FeatureUpdateDownloads | Where-Object {$_.Title -match $regex}
            }
            #===================================================================================================
            #   Select-Object
            #===================================================================================================
            $FeatureUpdateDownloads = $FeatureUpdateDownloads | Select-Object -Property OSDStatus, Title, UpdateOS,`
            UpdateBuild, UpdateArch, CreationDate, KBNumber, FileName, Size, OriginUri, Hash, AdditionalHash
            #===================================================================================================
            #   Sorting
            #===================================================================================================
            $FeatureUpdateDownloads = $FeatureUpdateDownloads | Sort-Object -Property Title
            #===================================================================================================
            #   Select Updates with GridView
            #===================================================================================================
            if (! ($SkipGridView.IsPresent)) {
                $FeatureUpdateDownloads = $FeatureUpdateDownloads | Out-GridView -PassThru -Title 'Select ESD Files to Download and Build and press OK'
            }
            #===================================================================================================
            #   Download Updates
            #===================================================================================================
            if ($WebClient.IsPresent) {$WebClientObj = New-Object System.Net.WebClient}
            foreach ($Item in $FeatureUpdateDownloads) {
                $DownloadFullPath = Join-Path $SetOSDBuilderPathFeatureUpdates $Item.FileName

                if (!(Test-Path $SetOSDBuilderPathFeatureUpdates)) {New-Item -Path $SetOSDBuilderPathFeatureUpdates -ItemType Directory -Force | Out-Null}
                Write-Host "$DownloadFullPath" -ForegroundColor Cyan
                Write-Host "$($Item.OriginUri)" -ForegroundColor DarkGray
                if (!(Test-Path $DownloadFullPath)) {
                    if ($WebClient.IsPresent) {							
                        $WebClientObj.DownloadFile("$($Item.OriginUri)","$DownloadFullPath")
                    } else {
                        Start-BitsTransfer -Source $Item.OriginUri -Destination $DownloadFullPath -ErrorAction Stop
                    }
                }

                if (!(Test-Path $DownloadFullPath)) {
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
            function Save-OneDriveSetup {
                [CmdletBinding()]
                param (
                    # THE NAME OF THE FILE (ONEDRIVESETUP.EXE)    
                    [Parameter(Mandatory = $true)]
                    [String]
                    $Name,

                    # THE PATH WHERE THE FILE IS SAVED (C:\OSDBuilder\Content\OneDrive)
                    [Parameter(Mandatory = $true)]
                    [System.IO.FileInfo]
                    $Path
                )

                $filePath = "$Path\$Name"
            
                $iwrParams = @{
                    OutFile = "$filePath"
                    Uri = ''
                }
                
                # SET THE DOWNLOAD URL BASED ON ONEDRIVE SETUP TYPE
                switch ($ContentDownload) {
                    'OneDriveSetup Production' {
                        # LINK FOR THE PRODUCTION RING, LATEST RELEASE BUILD
                        $iwrParams.Uri = 'https://go.microsoft.com/fwlink/?linkid=844652'
                    }
            
                    'OneDriveSetup Enterprise' {
                        # LINK FOR THE DEFERRED RING, LATEST RELEASE BUILD
                        $iwrParams.Uri = 'https://go.microsoft.com/fwlink/?linkid=860987'
                    }
            
                    Default {}
                }

                # CHECK THE RELEASE NOTES PAGE FOR ONEDRIVE AND PARSE OUT THE LATEST VERSION NUMBER
                $releaseNotes = 'https://go.microsoft.com/fwlink/?linkid=2159953'
                $latestVersion = Invoke-WebRequest -Uri $releaseNotes -UseBasicParsing | 
                    Select-Object -ExpandProperty Links | 
                    Where-Object -Property 'href' -like -Value $iwrParams.uri | 
                    Select-Object -Last 1 -ExpandProperty 'outerHTML'
                $latestVersion = $latestVersion.Split('<>')[2]
            
                # CHECK IF THE ONEDRIVESETUP.EXE FILE ALREADY EXISTS
                if ((Test-Path -Path "$filePath") -eq $false) {
                    Write-Verbose -Message "$Name not found at $Path..." -Verbose
                    $exeExists = $false
                } else {
                    $exeExists = $true
                    $exeOutdated = $false
            
                    # GET THE VERSION NUMBER OF ONEDRIVESETUP.EXE
                    $exeVersion = (Get-ItemProperty -Path "$filePath" -Name VersionInfo | Select-Object -ExpandProperty VersionInfo).ProductVersion
            
                    # COMPARE THE VERSION OF ONEDRIVESETUP.EXE WITH WHAT'S LISTED ONLINE
                    if ($exeVersion -lt $latestVersion) {
                        Write-Verbose -Message "$Name $exeVersion is out of date. The latest version is $latestVersion..." -Verbose
                        $exeOutdated = $true
                    }
                }
                
                # DOWNLOAD ONEDRIVESETUP.EXE IF IT DOESN'T EXIST OR IS OUTDATED
                if (($exeExists -eq $false) -or ($exeOutdated -eq $true)) {
                    Write-Verbose -Message "DownloadUrl: $($iwrParams.Uri)" -Verbose
                    Write-Verbose -Message "DownloadPath: $Path" -Verbose
                    Write-Verbose -Message "DownloadFile: $Name" -Verbose
                    
                    try {
                        Write-Verbose -Message "Downloading $Name $latestVersion" -Verbose
                        Invoke-WebRequest @iwrParams -ErrorAction Stop
                    } catch {
                        Write-Warning -Message 'Content could not be downloaded'
                    }
                } else {
                    Write-Verbose -Message "OneDriveSetup.exe Version: $exeVersion" -Verbose
                    Write-Verbose -Message "Latest Version: $latestVersion" -Verbose
                    Write-Verbose -Message "$Name does not need to be updated. Skipping download" -Verbose
                }
            }
            #===================================================================================================
            #   Download
            #===================================================================================================
            $DownloadPath = $GetOSDBuilderPathContentOneDrive
            $DownloadFile = 'OneDriveSetup.exe'
            
            if (!(Test-Path "$DownloadPath")) {New-Item -Path $DownloadPath -ItemType Directory -Force | Out-Null}
            
            Save-OneDriveSetup -Path $DownloadPath -Name $DownloadFile
        }

        if (($PSCmdlet.ParameterSetName -eq 'OSDUpdate') -or ($PSCmdlet.ParameterSetName -eq 'OSDUpdateSuperseded')) {
            #===================================================================================================
            #   Information
            #===================================================================================================
            if ($WebClient.IsPresent) {
                Write-Verbose "Downloading OSDUpdates using System.Net.WebClient" -Verbose
            } else {
                Write-Verbose "Downloading OSDUpdates using BITS-Transfer" -Verbose
                Write-Verbose "To use System.Net.WebClient, use the -WebClient Parameter" -Verbose
            }
            #===================================================================================================
            #   Get OSDUpdates
            #===================================================================================================
            $OSDUpdates = @()
            $OSDUpdates = Get-OSDUpdates | Sort-Object CreationDate -Descending
            #===================================================================================================
            #   Superseded Updates
            #===================================================================================================
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
            #===================================================================================================
            #   Filters
            #===================================================================================================
            if ($UpdateOS) {$OSDUpdates = $OSDUpdates | Where-Object {$_.UpdateOS -eq $UpdateOS}}
            if ($UpdateArch) {$OSDUpdates = $OSDUpdates | Where-Object {$_.UpdateArch -eq $UpdateArch}}
            if ($UpdateBuild) {$OSDUpdates = $OSDUpdates | Where-Object {$_.UpdateBuild -eq $UpdateBuild}}
            #===================================================================================================
            #   UpdateGroup
            #===================================================================================================
            if ($UpdateGroup -like "*Adobe*") {$OSDUpdates = $OSDUpdates | Where-Object {$_.UpdateGroup -eq 'AdobeSU'}}
            if ($UpdateGroup -like "*DotNet*") {$OSDUpdates = $OSDUpdates | Where-Object {$_.UpdateGroup -like "DotNet*"}}
            if ($UpdateGroup -like "*DUCU*") {$OSDUpdates = $OSDUpdates | Where-Object {$_.UpdateGroup -like "ComponentDU*"}}
            if ($UpdateGroup -like "*DUSU*") {$OSDUpdates = $OSDUpdates | Where-Object {$_.UpdateGroup -eq 'SetupDU'}}
            if ($UpdateGroup -like "*LCU*") {$OSDUpdates = $OSDUpdates | Where-Object {$_.UpdateGroup -eq 'LCU'}}
            if ($UpdateGroup -like "*SSU*") {$OSDUpdates = $OSDUpdates | Where-Object {$_.UpdateGroup -eq 'SSU'}}
            if ($UpdateGroup -eq 'Optional') {$OSDUpdates = $OSDUpdates | Where-Object {[String]::IsNullOrWhiteSpace($_.UpdateGroup) -or $_.UpdateGroup -eq 'Optional'}}
            #===================================================================================================
            #   Sorting
            #===================================================================================================
            $OSDUpdates = $OSDUpdates | Sort-Object -Property CreationDate -Descending
            #===================================================================================================
            #   Select Updates with GridView
            #===================================================================================================
            if ($GridView.IsPresent) {$OSDUpdates = $OSDUpdates | Out-GridView -PassThru -Title 'Select Updates to Download and press OK'}
            #===================================================================================================
            #   Download Updates
            #   21.5.21 Downloads are now stored in the Updates root
            #===================================================================================================
            if ($Download.IsPresent) {
				if ($WebClient.IsPresent) {$WebClientObj = New-Object System.Net.WebClient}
                foreach ($Update in $OSDUpdates) {
                    #$DownloadPath = "$SetOSDBuilderPathUpdates\$($Update.Catalog)\$($Update.Title)"
                    $DownloadPath = "$SetOSDBuilderPathUpdates"
                    
                    #$DownloadFullPath = "$DownloadPath\$($Update.FileName)"
                    $DownloadFullPath = Join-Path $DownloadPath $(Split-Path $Update.OriginUri -Leaf)

                    if (!(Test-Path $DownloadPath)) {New-Item -Path "$DownloadPath" -ItemType Directory -Force | Out-Null}
                    if (!(Test-Path $DownloadFullPath)) {
                        Write-Host "$DownloadFullPath" -ForegroundColor Cyan
                        Write-Host "$($Update.OriginUri)" -ForegroundColor DarkGray
                        if ($WebClient.IsPresent) {							
                            $WebClientObj.DownloadFile("$($Update.OriginUri)","$DownloadFullPath")
                        } else {
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

    END {
        #Write-Host '========================================================================================' -ForegroundColor DarkGray
        #Write-Host -ForegroundColor Green "$($MyInvocation.MyCommand.Name) END"
    }
}
