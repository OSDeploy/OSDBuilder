function New-OSDCloudOSMedia {
    [CmdletBinding()]
    param (
        #Pauses the function the Install.wim is dismounted
        #Useful for Testing
        [Alias('PauseOS','PauseDismount')]
        [switch]$PauseDismountOS,

        #Pauses the function before WinPE is dismounted
        #Useful for Testing
        [Alias('PausePE')]
        [switch]$PauseDismountPE
    )

    Begin {
        #=======================================================================
        #   Get-OSDBuilder
        #=======================================================================
        Get-OSDBuilder -CreatePaths -HideDetails
        #=======================================================================
        #   Block
        #=======================================================================
        Block-WinPE
        Block-StandardUser
        Block-WindowsVersionNe10
        Block-PowerShellVersionLt5
        Block-NoCurl
        #=======================================================================
    }

    Process {
        Write-Host '========================================================================================' -ForegroundColor DarkGray
        Write-Host -ForegroundColor Green "$($MyInvocation.MyCommand.Name) PROCESS"
        Write-Verbose "MyInvocation.MyCommand.Name: $($MyInvocation.MyCommand.Name)"
        Write-Verbose "PSCmdlet.ParameterSetName: $($PSCmdlet.ParameterSetName)"
        #=======================================================================
        #   OSDCloud
        #=======================================================================
        $BirdBox = @()
        $BirdBox = Get-OSMedia -OSMajorVersion 10 | Where-Object {$_.MediaType -eq 'OSImport'} | Where-Object {$_.RegBuild -ge 19041}

        $BirdBox = $BirdBox | Out-GridView -PassThru -Title "Select one or more OSImport to Build (Cancel to Exit) and press OK"

        if ($null -eq $BirdBox) {
            Write-Warning "Could not find a matching OSImport . . . Exiting!"
            Return
        }

        foreach ($Bird in $BirdBox) {
            #=======================================================================
            #   Set Paths
            #=======================================================================
            if (Test-Path "$SetOSDBuilderPathOSImport\$($Bird.Name)") {$OSMediaPath = "$SetOSDBuilderPathOSImport\$($Bird.Name)"}
            $OSImagePath = "$OSMediaPath\OS\sources\install.wim"

            if (!(Test-Path "$OSMediaPath\WindowsImage.txt")) {
                Write-Host '========================================================================================' -ForegroundColor DarkGray
                if ($null -eq $OSMediaPath) {
                    Write-Warning "Unable to find an OSMedia to use"
                } else {
                    Write-Warning "$OSMediaPath is not a valid OSMedia Directory"
                }
                Return
            }

            if (!(Test-Path "$OSImagePath")) {
                Write-Host '========================================================================================' -ForegroundColor DarkGray
                Write-Warning "$OSImagePath is not a valid Windows Image"
                Return
            }
            #=======================================================================
            #   Get Windows Image Information
            #=======================================================================
            $OSImageIndex = 1
            $WindowsImage = Get-WindowsImage -ImagePath "$OSImagePath" -Index $OSImageIndex | Select-Object -Property *

            $OSImageName = ($WindowsImage).ImageName
            $OSImageName = $OSImageName -replace '\(', ''
            $OSImageName = $OSImageName -replace '\)', ''

            $OSImageDescription = ($WindowsImage).ImageDescription

            $OSArchitecture = $($WindowsImage.Architecture)
            if ($OSArchitecture -eq '0') {$OSArchitecture = 'x86'}
            if ($OSArchitecture -eq '6') {$OSArchitecture = 'ia64'}
            if ($OSArchitecture -eq '9') {$OSArchitecture = 'x64'}
            if ($OSArchitecture -eq '12') {$OSArchitecture = 'x64 ARM'}

            $OSEditionID =          $($WindowsImage.EditionId)
            $OSInstallationType =   $($WindowsImage.InstallationType)
            $OSLanguages =          $($WindowsImage.Languages)
            $OSVersion =            $($WindowsImage.Version)
            $OSMajorVersion =       $($WindowsImage.MajorVersion)
            $OSMinorVersion =       $($WindowsImage.MinorVersion)
            $OSBuild =              $($WindowsImage.Build)
            $OSSPBuild =            $($WindowsImage.SPBuild)
            $OSSPLevel =            $($WindowsImage.SPLevel)
            $OSImageBootable =      $($WindowsImage.ImageBootable)
            $OSWIMBoot =            $($WindowsImage.WIMBoot)
            $OSCreatedTime =        $($WindowsImage.CreatedTime)
            $OSModifiedTime =       $($WindowsImage.ModifiedTime)

            Show-MediaImageInfoOS
            #=======================================================================
            #   Get Adk Paths
            #=======================================================================
            if ($OSArchitecture -eq 'x64') {
                $AdkPaths = Get-AdkPaths -Arch 'amd64'
            }
            else {
                $AdkPaths = Get-AdkPaths -Arch 'x86'
            }
    
            if ($null -eq $AdkPaths) {
                Write-Host -ForegroundColor DarkGray "========================================================================="
                Write-Warning "Could not get ADK going, sorry"
                Write-Host -ForegroundColor DarkGray "========================================================================="
                Break
            }
            #=======================================================================
            #   ADK Packages
            #=======================================================================
            $ErrorActionPreference = 'Ignore'
            $WinPEOCs = $AdkPaths.WinPEOCs
    
            $OCPackages = @(
                'WMI'
                'HTA'
                'NetFx'
                'Scripting'
                'PowerShell'
                'SecureStartup'
                'DismCmdlets'
                'Dot3Svc'
                'EnhancedStorage'
                'FMAPI'
                'GamingPeripherals'
                'PPPoE'
                'PlatformId'
                'PmemCmdlets'
                'RNDIS'
                'SecureBootCmdlets'
                'StorageWMI'
                'WDS-Tools'
            )
            #=======================================================================
            #   Validate Registry CurrentVersion.xml'
            #=======================================================================
            $RegValueCurrentBuild = $null
            if (Test-Path "$OSMediaPath\info\xml\CurrentVersion.xml") {
                $RegKeyCurrentVersion = Import-Clixml -Path "$OSMediaPath\info\xml\CurrentVersion.xml"
                
                [string]$RegValueCurrentBuild = ($RegKeyCurrentVersion).CurrentBuild
                [string]$RegValueDisplayVersion = ($RegKeyCurrentVersion).DisplayVersion
                [string]$ReleaseId = ($RegKeyCurrentVersion).ReleaseId
                if ($RegValueDisplayVersion) {$ReleaseId = $RegValueDisplayVersion}
            }
            #=======================================================================
            Write-Verbose '19.1.1 Set ReleaseId'
            #=======================================================================
            if ($null -ne $RegValueCurrentBuild) {$OSBuild = $RegValueCurrentBuild}
            if ($null -eq $ReleaseId) {
                if ($OSBuild -eq 7600) {$ReleaseId = 7600}
                if ($OSBuild -eq 7601) {$ReleaseId = 7601}
                if ($OSBuild -eq 9600) {$ReleaseId = 9600}
                if ($OSBuild -eq 10240) {$ReleaseId = 1507}
                if ($OSBuild -eq 14393) {$ReleaseId = 1607}
                if ($OSBuild -eq 15063) {$ReleaseId = 1703}
                if ($OSBuild -eq 16299) {$ReleaseId = 1709}
                if ($OSBuild -eq 17134) {$ReleaseId = 1803}
                if ($OSBuild -eq 17763) {$ReleaseId = 1809}
                #if ($OSBuild -eq 18362) {$ReleaseId = 1903}
                #if ($OSBuild -eq 18363) {$ReleaseId = 1909}
                #if ($OSBuild -eq 19041) {$ReleaseId = 2004}
                #if ($OSBuild -eq 19042) {$ReleaseId = '20H2'}
                #if ($OSBuild -eq 19043) {$ReleaseId = '21H1'}
                #if ($OSBuild -eq 19044) {$ReleaseId = '21H2'}
            }

            Write-Verbose "ReleaseId: $ReleaseId"
            Write-Verbose "CurrentBuild: $RegValueCurrentBuild"
            #=================================================
            #   Operating System
            #=================================================
            $UpdateOS = ''
            if ($OSMajorVersion -eq 10) {
                if ($OSInstallationType -match 'Server') {
                    $UpdateOS = 'Windows Server'
                }
                else {
                    if ($OSImageName -match ' 11 ') {
                        $UpdateOS = 'Windows 11'
                    }
                    else {
                        $UpdateOS = 'Windows 10'
                    }
                }
            }
            #=======================================================================
            #WorkingName and WorkingPath'
            #=======================================================================
            if ($Bird.Name -match 'OSDCloud') {
                $WorkingName = $Bird.Name
            }
            else {
                $WorkingName = "$($Bird.Name) OSDCloud"
            }
            $WorkingPath = "$SetOSDBuilderPathOSMedia\$WorkingName"
            #=======================================================================
            Write-Verbose '19.1.1 Remove Existing OSMedia'
            #=======================================================================
            if (Test-Path $WorkingPath) {
                Write-Host '========================================================================================' -ForegroundColor DarkGray
                Write-Warning "$WorkingPath will be replaced!"
            }
            #=======================================================================
            Write-Verbose '19.1.25 Remove Existing WorkingPath'
            #=======================================================================
            if (Test-Path $WorkingPath) {
                Write-Host '========================================================================================' -ForegroundColor DarkGray
                Remove-Item -Path "$WorkingPath" -Force -Recurse
            }
            #=======================================================================
            Write-Verbose '19.2.25 Set Variables'
            #=======================================================================
            $MountDirectory = Join-Path $SetOSDBuilderPathMount "os$((Get-Date).ToString('yyMMddhhmm'))"
            $MountWinPE = Join-Path $SetOSDBuilderPathMount "winpe$((Get-Date).ToString('yyMMddhhmm'))"
            $MountWinRE = Join-Path $SetOSDBuilderPathMount "winre$((Get-Date).ToString('yyMMddhhmm'))"
            $MountWinSE = Join-Path $SetOSDBuilderPathMount "setup$((Get-Date).ToString('yyMMddhhmm'))"
            $Info = Join-Path $WorkingPath 'info'
                $Logs = Join-Path $Info 'logs'
            $OS = Join-Path $WorkingPath 'OS'
            $WimTemp = Join-Path $WorkingPath "WimTemp"
            $WinPE = Join-Path $WorkingPath 'WinPE'
                $PEInfo = Join-Path $WinPE 'info'
                $PELogs = Join-Path $PEInfo 'logs'
            #=======================================================================
            #   Start Transcript
            #=======================================================================
            Write-Host '========================================================================================' -ForegroundColor DarkGray
            $ScriptName = $($MyInvocation.MyCommand.Name)
            $LogName = "$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-$ScriptName.log"
            Start-Transcript -Path (Join-Path "$Info\logs" $LogName) | Out-Null
            #=======================================================================
            #   Update-OSMedia and New-OSBuild
            #=======================================================================
            New-DirectoriesOSMedia
            Show-WorkingInfoOS
            Copy-MediaOperatingSystem
            #=======================================================================
            #   Mount WinPE
            #=======================================================================
            Mount-WinPEwim -OSMediaPath "$WorkingPath"
            Mount-WinREwim -OSMediaPath "$WorkingPath"
            Mount-WinSEwim -OSMediaPath "$WorkingPath"
            #=======================================================================
            #   WinPE ADK
            #=======================================================================
            $TemplateLogs = $Logs

            Write-Host -ForegroundColor DarkGray "========================================================================="
            Write-Host -ForegroundColor Cyan "$((Get-Date).ToString('yyyy-MM-dd-HHmmss')) Adding default en-US ADK Packages"
            Write-Host -ForegroundColor Yellow "Dism Function: Add-WindowsPackage"
            $Lang = 'en-us'

            foreach ($Package in $OCPackages) {
                $SourceFile = "$WinPEOCs\WinPE-$Package.cab"
                if (Test-Path $SourceFile) {
                    Write-Host -ForegroundColor DarkGray "$SourceFile"
                    $PackageName = "Add-WindowsPackage-WinPE-$Package"

                    $CurrentLog = "$TemplateLogs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-$PackageName WinPE.log"
                    Try {Add-WindowsPackage -Path $MountWinPE -PackagePath $SourceFile -LogPath "$CurrentLog" | Out-Null}
                    Catch {Write-Host -ForegroundColor Red $CurrentLog}
                    
                    $CurrentLog = "$TemplateLogs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-$PackageName WinRE.log"
                    Try {Add-WindowsPackage -Path $MountWinRE -PackagePath $SourceFile -LogPath "$CurrentLog" | Out-Null}
                    Catch {Write-Host -ForegroundColor Red $CurrentLog}
                    
                    $CurrentLog = "$TemplateLogs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-$PackageName WinSE.log"
                    Try {Add-WindowsPackage -Path $MountWinSE -PackagePath $SourceFile -LogPath "$CurrentLog" | Out-Null}
                    Catch {Write-Host -ForegroundColor Red $CurrentLog}
                }
            }

            $SourceFile = "$WinPEOCs\$Lang\lp.cab"
            if (Test-Path $SourceFile) {
                Write-Host -ForegroundColor DarkGray "$SourceFile"
                $PackageName = "Add-WindowsPackage-WinPE-lp_$Lang"

                $CurrentLog = "$TemplateLogs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-$PackageName WinPE.log"
                Try {Add-WindowsPackage -Path $MountWinPE -PackagePath $SourceFile -LogPath "$CurrentLog" | Out-Null}
                Catch {Write-Host -ForegroundColor Red $CurrentLog}

                $CurrentLog = "$TemplateLogs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-$PackageName WinRE.log"
                Try {Add-WindowsPackage -Path $MountWinRE -PackagePath $SourceFile -LogPath "$CurrentLog" | Out-Null}
                Catch {Write-Host -ForegroundColor Red $CurrentLog}

                $CurrentLog = "$TemplateLogs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-$PackageName WinSE.log"
                Try {Add-WindowsPackage -Path $MountWinSE -PackagePath $SourceFile -LogPath "$CurrentLog" | Out-Null}
                Catch {Write-Host -ForegroundColor Red $CurrentLog}
            }
            else {
                Write-Warning "Could not find $SourceFile"
            }

            foreach ($Package in $OCPackages) {
                $SourceFile = "$WinPEOCs\$Lang\WinPE-$Package`_$Lang.cab"
                if (Test-Path $SourceFile) {
                    Write-Host -ForegroundColor DarkGray "$SourceFile"
                    $PackageName = "Add-WindowsPackage-WinPE-$Package`_$Lang"
                    $CurrentLog = "$TemplateLogs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-$PackageName WinPE.log"
                    Try {Add-WindowsPackage -Path $MountWinPE -PackagePath $SourceFile -LogPath "$CurrentLog" | Out-Null}
                    Catch {Write-Host -ForegroundColor Red $CurrentLog}

                    $CurrentLog = "$TemplateLogs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-$PackageName WinRE.log"
                    Try {Add-WindowsPackage -Path $MountWinRE -PackagePath $SourceFile -LogPath "$CurrentLog" | Out-Null}
                    Catch {Write-Host -ForegroundColor Red $CurrentLog}

                    $CurrentLog = "$TemplateLogs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-$PackageName WinSE.log"
                    Try {Add-WindowsPackage -Path $MountWinSE -PackagePath $SourceFile -LogPath "$CurrentLog" | Out-Null}
                    Catch {Write-Host -ForegroundColor Red $CurrentLog}
                }
            }
            #=======================================================================
            #   Save-WindowsImage
            #=======================================================================
            Write-Host -ForegroundColor DarkGray "========================================================================="
            Write-Host -ForegroundColor Cyan "$((Get-Date).ToString('yyyy-MM-dd-HHmmss')) Save Windows Image"
            Write-Host -ForegroundColor Yellow "Dism Function: Save-WindowsImage"

            $CurrentLog = "$TemplateLogs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Save-WindowsImage.log"
            Save-WindowsImage -Path $MountWinPE -LogPath $CurrentLog | Out-Null

            $CurrentLog = "$TemplateLogs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Save-WindowsImage.log"
            Save-WindowsImage -Path $MountWinRE -LogPath $CurrentLog | Out-Null

            $CurrentLog = "$TemplateLogs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Save-WindowsImage.log"
            Save-WindowsImage -Path $MountWinSE -LogPath $CurrentLog | Out-Null
            #=======================================================================
            #   WinPE DaRT
            #=======================================================================
            Write-Host -ForegroundColor DarkGray "========================================================================="
            Write-Host -ForegroundColor Cyan "$((Get-Date).ToString('yyyy-MM-dd-HHmmss')) Microsoft DaRT"
            $SourceFile = "C:\Program Files\Microsoft DaRT\v10\Tools$OSArchitecture.cab"
            if (Test-Path $SourceFile) {
                Write-Host -ForegroundColor DarkGray $SourceFile
                expand.exe "$SourceFile" -F:*.* "$MountWinPE" | Out-Null
                expand.exe "$SourceFile" -F:*.* "$MountWinRE" | Out-Null
                expand.exe "$SourceFile" -F:*.* "$MountWinSE" | Out-Null

                $SourceFile = "C:\Program Files\Microsoft Deployment Toolkit\Templates\DartConfig8.dat"
                if (Test-Path $SourceFile) {
                    Write-Host -ForegroundColor DarkGray $SourceFile
                    Copy-Item -Path $SourceFile -Destination "$MountWinPE\Windows\System32\DartConfig.dat" -Force
                    Copy-Item -Path $SourceFile -Destination "$MountWinRE\Windows\System32\DartConfig.dat" -Force
                    Copy-Item -Path $SourceFile -Destination "$MountWinSE\Windows\System32\DartConfig.dat" -Force
                }
                else {
                    Write-Warning "Could not find $SourceFile"
                }
            }
            else {
                Write-Warning "Could not find $SourceFile"
            }

            if (Test-Path "$MountWinPE\Windows\System32\winpeshl.ini") {Remove-Item -Path "$MountWinPE\Windows\System32\winpeshl.ini" -Force}
            (Get-Content "$MountWinRE\Windows\System32\winpeshl.ini") | ForEach-Object {$_ -replace '-prompt','-network'} | Out-File "$MountWinRE\Windows\System32\winpeshl.ini"
            if (Test-Path "$MountWinSE\Windows\System32\winpeshl.ini") {Remove-Item -Path "$MountWinSE\Windows\System32\winpeshl.ini" -Force}
            #=======================================================================
            #   WinPE Content
            #=======================================================================
            $WinPEAutoExtraFiles = $true
            Import-AutoExtraFilesPE

            $WinPEOSDCloud = $true
            Enable-WinPEOSDCloud
            
            $WinREWiFi = $true
            Enable-WinREWiFi
            #=======================================================================
            #   Update-OSMedia and New-OSBuild
            #=======================================================================
            Save-PackageInventoryPE -OSMediaPath "$WorkingPath"
            if ($PauseDismountPE.IsPresent){[void](Read-Host 'Press Enter to Continue')}
            Dismount-WimsPE -OSMediaPath "$WorkingPath"
            Export-PEWims -OSMediaPath "$WorkingPath"
            Export-PEBootWim -OSMediaPath "$WorkingPath"
            Save-InventoryPE -OSMediaPath "$WorkingPath"
            #=======================================================================
            #   Install.wim
            #=======================================================================
            $global:ReapplyLCU = $false
            Mount-InstallwimOS
            Set-WinREWimOS
            #=======================================================================
            #   Install.wim UBR Pre-Update
            #=======================================================================
            Show-ActionTime
            Write-Host -ForegroundColor Green "OS: Mount Registry for UBR Information"
            $RegKeyCurrentVersion = Get-RegCurrentVersion -Path $MountDirectory

            $RegValueDisplayVersion = ($RegKeyCurrentVersion).DisplayVersion
            $ReleaseId = ($RegKeyCurrentVersion).ReleaseId
            if ($RegValueDisplayVersion) {$ReleaseId = $RegValueDisplayVersion}

            if ($($RegKeyCurrentVersion.CurrentBuild)) {$RegValueCurrentBuild = $($RegKeyCurrentVersion.CurrentBuild)}
            else {$RegValueCurrentBuild = $OSSPBuild}
            if ($($RegKeyCurrentVersion.UBR)) {$RegValueUbr = $($RegKeyCurrentVersion.UBR)}
            else {$RegValueUbr = $OSSPBuild}
            $UBR = "$RegValueCurrentBuild.$RegValueUbr"
            Save-RegistryCurrentVersionOS
            $UBRPre = $UBR
            #=======================================================================
            #   Optional Content
            #=======================================================================
            Add-ContentPack -PackType OSCapability
            Add-ContentPack -PackType OSPackages
            Add-WindowsPackageOS
            Add-FeaturesOnDemandOS
            #=======================================================================
            #   Install.wim UBR Post-Update
            #=======================================================================
            $RegKeyCurrentVersion = Get-RegCurrentVersion -Path $MountDirectory

            $RegValueDisplayVersion = ($RegKeyCurrentVersion).DisplayVersion
            $ReleaseId = ($RegKeyCurrentVersion).ReleaseId
            if ($RegValueDisplayVersion) {$ReleaseId = $RegValueDisplayVersion}

            if ($($RegKeyCurrentVersion.CurrentBuild)) {$RegValueCurrentBuild = $($RegKeyCurrentVersion.CurrentBuild)}
            else {$RegValueCurrentBuild = $OSSPBuild}
            if ($($RegKeyCurrentVersion.UBR)) {$RegValueUbr = $($RegKeyCurrentVersion.UBR)}
            else {$RegValueUbr = $OSSPBuild}
            $UBR = "$RegValueCurrentBuild.$RegValueUbr"
            Save-RegistryCurrentVersionOS
            Show-ActionTime
            Write-Host -ForegroundColor Green "OS: Update Build Revision $UBR (Post-LCU)"
            #=======================================================================
            #   OneDriveSetup
            #=======================================================================
            if ($OSMajorVersion -eq 10 -and $OSInstallationType -eq 'Client') {
                Show-ActionTime
                Write-Host -ForegroundColor Green "OS: Update OneDriveSetup.exe"
                $OneDriveSetupDownload = $false
                $OneDriveSetup = Join-Path $GetOSDBuilderPathContentOneDrive 'OneDriveSetup.exe'
                if (!(Test-Path $OneDriveSetup)) {$OneDriveSetupDownload = $true}

                if (Test-Path $OneDriveSetup) {
                    if (!(([System.Io.fileinfo]$OneDriveSetup).LastWriteTime.Date -ge [datetime]::Today )) {
                        $OneDriveSetupDownload = $true
                    }
                }
<#                     if ($OneDriveSetupDownload -eq $true) {
                    $WebClient = New-Object System.Net.WebClient
                    Write-Host "Downloading to $OneDriveSetup" -ForegroundColor Gray
                    $WebClient.DownloadFile('https://go.microsoft.com/fwlink/p/?LinkId=248256',"$OneDriveSetup")
                } #>

                if ($OSArchitecture -eq 'x86') {
                    $OneDriveSetupInfo = Get-Item -Path "$MountDirectory\Windows\System32\OneDriveSetup.exe" | Select-Object -Property *
                    Write-Host -ForegroundColor Gray "                  Existing Image Version $($($OneDriveSetupInfo).VersionInfo.ProductVersion)"
                    if (Test-Path $OneDriveSetup) {
                        robocopy "$GetOSDBuilderPathContentOneDrive" "$MountDirectory\Windows\System32" OneDriveSetup.exe /ndl /xx /b /np /ts /tee /r:0 /w:0 /Log+:"$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Update-OneDriveSetup.log" | Out-Null
                        $OneDriveSetupInfo = Get-Item -Path "$MountDirectory\Windows\System32\OneDriveSetup.exe" | Select-Object -Property *
                        Write-Host -ForegroundColor Gray "                  Updating with Version $($($OneDriveSetupInfo).VersionInfo.ProductVersion)"
                    }
                } else {
                    $OneDriveSetupInfo = Get-Item -Path "$MountDirectory\Windows\SysWOW64\OneDriveSetup.exe" | Select-Object -Property *
                    Write-Host -ForegroundColor Gray "                  Existing Image Version $($($OneDriveSetupInfo).VersionInfo.ProductVersion)"
                    if (Test-Path $OneDriveSetup) {
                        robocopy "$GetOSDBuilderPathContentOneDrive" "$MountDirectory\Windows\SysWOW64" OneDriveSetup.exe /ndl /xx /b /np /ts /tee /r:0 /w:0 /Log+:"$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Update-OneDriveSetup.log" | Out-Null
                        $OneDriveSetupInfo = Get-Item -Path "$MountDirectory\Windows\SysWOW64\OneDriveSetup.exe" | Select-Object -Property *
                        Write-Host -ForegroundColor Gray "                  Updating with Version $($($OneDriveSetupInfo).VersionInfo.ProductVersion)"
                    }
                }
                Write-Host -ForegroundColor Cyan "                  To update OneDriveSetup.exe use one of the following commands:"
                Write-Host -ForegroundColor Cyan "                  Save-OSDBuilderDownload -ContentDownload 'OneDriveSetup Enterprise'"
                Write-Host -ForegroundColor Cyan "                  Save-OSDBuilderDownload -ContentDownload 'OneDriveSetup Production'"
            }
            #=======================================================================
            #   Content
            #=======================================================================
            Enable-WindowsOptionalFeatureOS
            Enable-NetFXOS
            Remove-AppxProvisionedPackageOS
            Remove-WindowsPackageOS
            Remove-WindowsCapabilityOS
            Disable-WindowsOptionalFeatureOS
            Add-ContentDriversOS
            Add-ContentExtraFilesOS
            Add-ContentStartLayout
            Add-ContentUnattend
            Add-ContentScriptsOS
            Import-RegistryRegOS
            Import-RegistryXmlOS
            Add-ContentPack -PackType OSDrivers
            Add-ContentPack -PackType OSExtraFiles
            Add-ContentPack -PackType OSPoshMods
            Add-ContentPack -PackType OSRegistry
            Add-ContentPack -PackType OSScripts
            Add-ContentPack -PackType OSStartLayout
            #=======================================================================
            #	Mirror OSMedia and OSBuild
            #=======================================================================
            Save-AutoExtraFilesOS -OSMediaPath "$WorkingPath"
            Save-SessionsXmlOS -OSMediaPath "$WorkingPath"
            Save-InventoryOS -OSMediaPath "$WorkingPath"
            #=======================================================================
            #   Dismount
            #=======================================================================
            if ($PauseDismountOS.IsPresent){[void](Read-Host 'Press Enter to Continue')}
            Dismount-InstallwimOS
            Export-InstallwimOS
            #=======================================================================
            Write-Verbose '19.1.1 OS: Export Configuration'
            #=======================================================================
            Show-ActionTime
            Write-Host -ForegroundColor Green "OS: Export Configuration to $WorkingPath\WindowsImage.txt"
            $GetWindowsImage = @()
            $GetWindowsImage = Get-WindowsImage -ImagePath "$OS\sources\install.wim" -Index 1 | Select-Object -Property *

            Write-Verbose "========== SPBuild: $($GetWindowsImage.Build).$($GetWindowsImage.SPBuild)"
            if ($OSVersion -like "6.*") {
                Write-Verbose '========== Windows 6.x'
                $UBR = "$($GetWindowsImage.Build).$($GetWindowsImage.SPBuild)"
            }
            Write-Verbose "========== UBR: $UBR"

            $GetWindowsImage | Add-Member -Type NoteProperty -Name "UBR" -Value $UBR
            $GetWindowsImage | Out-File "$WorkingPath\WindowsImage.txt"
            $GetWindowsImage | Out-File "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsImage.txt"
            $GetWindowsImage | Export-Clixml -Path "$Info\xml\Get-WindowsImage.xml"
            $GetWindowsImage | Export-Clixml -Path "$Info\xml\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsImage.xml"
            $GetWindowsImage | ConvertTo-Json | Out-File "$Info\json\Get-WindowsImage.json"
            $GetWindowsImage | ConvertTo-Json | Out-File "$Info\json\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsImage.json"
            (Get-Content "$WorkingPath\WindowsImage.txt") | Where-Object {$_.Trim(" `t")} | Set-Content "$WorkingPath\WindowsImage.txt"
            #=======================================================================
            #    OSD-Export
            #=======================================================================
            #Save-WindowsImageContentPE
            #=======================================================================
            Write-Verbose '19.3.17 UBR Validation'
            #=======================================================================
            if ($MyInvocation.MyCommand.Name -eq 'Update-OSMedia') {
                if ($UBRPre -eq $UBR) {
                    Write-Host '========================================================================================' -ForegroundColor DarkGray
                    Write-Warning 'The Update Build Revision did not change after Windows Updates'
                    Write-Warning 'There may have been an issue applying the Latest Cumulative Update if this was not expected'
                }
            }
            if (!($UBR)) {
                Write-Host '========================================================================================' -ForegroundColor DarkGray
                $UBR = $((Get-Date).ToString('yyMMddhhmm'))
                Write-Warning 'Could not determine a UBR'
            }

            #=======================================================================
            #   Remove Temporary Files
            #=======================================================================
            if (Test-Path "$WimTemp") {Remove-Item -Path "$WimTemp" -Force -Recurse | Out-Null}
            if (Test-Path "$MountDirectory") {Remove-Item -Path "$MountDirectory" -Force -Recurse | Out-Null}
            if (Test-Path "$MountWinRE") {Remove-Item -Path "$MountWinRE" -Force -Recurse | Out-Null}
            if (Test-Path "$MountWinPE") {Remove-Item -Path "$MountWinPE" -Force -Recurse | Out-Null}
            if (Test-Path "$MountWinSE") {Remove-Item -Path "$MountWinSE" -Force -Recurse | Out-Null}
            #=======================================================================
            #   OSD-Export
            #=======================================================================
            Save-WindowsImageContentOS
            Save-VariablesOSD
            #=======================================================================
            #   Create ISO
            #=======================================================================
            New-OSDBuilderISO -FullName "$WorkingPath"
            #=======================================================================
            #   Complete Build
            #=======================================================================
            Stop-Transcript | Out-Null
        }
    }

    END {}
}