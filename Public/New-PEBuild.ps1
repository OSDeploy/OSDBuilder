<#
.SYNOPSIS
Creates a new PEBuild from an PEBuild Task

.DESCRIPTION
Creates a new PEBuild from an PEBuild Task created with New-PEBuildTask

.LINK
https://osdbuilder.osdeploy.com/module/functions/new-pebuild
#>
function New-PEBuild {
    [CmdletBinding(DefaultParameterSetName='Basic')]
    param (
        #Creates an ISO of the Updated Media
        #oscdimg.exe from Windows ADK is required
        [Alias('ISO','OSDISO')]
        [switch]$CreateISO = $global:SetOSDBuilder.NewPEBuildCreateISO,

        #Executes the PEBuild
        [switch]$Execute = $global:SetOSDBuilder.NewPEBuildExecute,

        #Adds a 'Press Enter to Continue' prompt before WinPE is dismounted
        [Parameter(ParameterSetName='Advanced')]
        [switch]$PauseDismount = $global:SetOSDBuilder.NewPEBuildPauseDismount,

        #Adds a 'Press Enter to Continue' prompt after WinPE is mounted
        [Parameter(ParameterSetName='Advanced')]
        [switch]$PauseMount = $global:SetOSDBuilder.NewPEBuildPauseMount
    )

    Begin {
        #=================================================
        #   Get-OSDBuilder
        #=================================================
        Get-OSDBuilder -CreatePaths -HideDetails
        #=================================================
        #   Block
        #=================================================
        Block-StandardUser
        #=================================================

#=================================================
Write-Verbose 'MDT Files'
#=================================================
$MDTwinpeshl = @'
[LaunchApps]
%SYSTEMROOT%\System32\bddrun.exe,/bootstrap
'@

$DaRTwinpeshl = @'
[LaunchApps]
%windir%\system32\netstart.exe,-network
%SYSTEMDRIVE%\sources\recovery\recenv.exe
'@

$MDTUnattendPEx64 = @'
<?xml version="1.0" encoding="utf-8"?>
<unattend xmlns="urn:schemas-microsoft-com:unattend">
    <settings pass="windowsPE">
        <component name="Microsoft-Windows-Setup" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State">
            <Display>
                <ColorDepth>32</ColorDepth>
                <HorizontalResolution>1024</HorizontalResolution>
                <RefreshRate>60</RefreshRate>
                <VerticalResolution>768</VerticalResolution>
            </Display>
            <RunSynchronous>
                <RunSynchronousCommand wcm:action="add">
                    <Description>Lite Touch PE</Description>
                    <Order>1</Order>
                    <Path>wscript.exe X:\Deploy\Scripts\LiteTouch.wsf</Path>
                </RunSynchronousCommand>
            </RunSynchronous>
        </component>
    </settings>
</unattend>
'@

$MDTUnattendPEx86 = @'
<?xml version="1.0" encoding="utf-8"?>
<unattend xmlns="urn:schemas-microsoft-com:unattend">
    <settings pass="windowsPE">
        <component name="Microsoft-Windows-Setup" processorArchitecture="x86" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State">
            <Display>
                <ColorDepth>32</ColorDepth>
                <HorizontalResolution>1024</HorizontalResolution>
                <RefreshRate>60</RefreshRate>
                <VerticalResolution>768</VerticalResolution>
            </Display>
            <RunSynchronous>
                <RunSynchronousCommand wcm:action="add">
                    <Description>Lite Touch PE</Description>
                    <Order>1</Order>
                    <Path>wscript.exe X:\Deploy\Scripts\LiteTouch.wsf</Path>
                </RunSynchronousCommand>
            </RunSynchronous>
        </component>
    </settings>
</unattend>
'@

    }

    Process {
        Write-Host '========================================================================================' -ForegroundColor DarkGray
        Write-Host -ForegroundColor Green "$($MyInvocation.MyCommand.Name) PROCESS"
        Write-Verbose "MyInvocation.MyCommand.Name: $($MyInvocation.MyCommand.Name)"
        Write-Verbose "PSCmdlet.ParameterSetName: $($PSCmdlet.ParameterSetName)"
        #=================================================
        #   PEBuild
        #=================================================
        $GetPEBuildTask = @()
        #$GetPEBuildTask = Get-ChildItem -Path $SetOSDBuilderPathTasks *.json -File | Select-Object -Property BaseName, FullName, Length, CreationTime, LastWriteTime | Sort-Object -Property BaseName
        #$GetPEBuildTask = $GetPEBuildTask | Where-Object {$_.BaseName -like "MDT*" -or $_.BaseName -like "Recovery*" -or $_.BaseName -like "WinPE*"}
        #$GetPEBuildTask = $GetPEBuildTask | Out-GridView -Title "OSDBuilder Tasks: Select one or more Tasks to execute and press OK (Cancel to Exit)" -Passthru
        $GetPEBuildTask = Get-PEBuildTask | Out-GridView -PassThru -Title "PEBuild Tasks: Select one or more Tasks to execute and press OK (Cancel to Exit)"

        if($null -eq $GetPEBuildTask) {
            Write-Warning "PEBuild Task was not selected or found . . . Exiting!"
            Return
        }

        foreach ($Item in $GetPEBuildTask) {
            #=================================================
            Write-Verbose '19.1.1 PEBuild Task Contents'
            #=================================================
            $Task = Get-Content "$($Item.FullName)" | ConvertFrom-Json
            $TaskType = $($Task.TaskType)
            $TaskName = $($Task.TaskName)
            $TaskVersion = $($Task.TaskVersion)

            $WinPEOutput = $($Task.WinPEOutput)
            $CustomName = $($Task.CustomName)
            if ((Get-IsContentPacksEnabled) -and (!($SkipContentPacks.IsPresent))) {
                if ($null -eq $Task.ContentPacks) {
                    $ContentPacks = @('_Global')
                } else {
                    $ContentPacks = @('_Global')
                    $ContentPacks = ($ContentPacks += $Task.ContentPacks)
                }
            }

            $TaskOSMFamily = $($Task.OSMFamily)
            $TaskOSMGuid = $($Task.OSMGuid)
            $OSMediaName = $($Task.Name)
            $OSMediaPath = "$SetOSDBuilderPathOSMedia\$OSMediaName"

            $WinPEAutoExtraFiles = $($Task.WinPEAutoExtraFiles)
            $WinPEOSDCloud = $Task.WinPEOSDCloud
            $WinREWiFi = $Task.WinREWiFi

            $MDTDeploymentShare = $($Task.MDTDeploymentShare)
            $ScratchSpace = $($Task.ScratchSpace)
            $SourceWim = $($Task.SourceWim)
            $WinPEADK = $($Task.WinPEADK)
            $WinPEDaRT = $($Task.WinPEDaRT)
            $WinPEDrivers = $($Task.WinPEDrivers)
            $WinPEExtraFiles = $($Task.WinPEExtraFiles)
            $WinPEScripts = $($Task.WinPEScripts)

            #=================================================
            Write-Verbose '19.1.1 PEBuild Task Information'
            #=================================================
            Write-Host '========================================================================================' -ForegroundColor DarkGray
            Write-Host "PEBuild Task Information" -ForegroundColor Green
            Write-Host "-TaskName:                      $TaskName"
            Write-Host "-TaskVersion:                   $TaskVersion"
            Write-Host "-TaskType:                      $TaskType"
            #Write-Host "-OSMediaName:                   $OSMediaName"
            #Write-Host "-OSMediaPath:                   $OSMediaPath"
            Write-Host "-WinPE Output:                  $WinPEOutput"
            Write-Host "-Custom Name:                   $CustomName"

            if (Get-IsContentPacksEnabled) {
                Write-Host "-ContentPacks:" -ForegroundColor Cyan
                foreach ($item in $ContentPacks)       {Write-Host "   $SetOSDBuilderPathTemplates\$item" -ForegroundColor Cyan}}
    
            Write-Host "-MDT Deployment Share:          $MDTDeploymentShare"
            Write-Host "-WinPE Auto ExtraFiles:         $WinPEAutoExtraFiles"
            Write-Host "-WinPE OSDCloud:                $WinPEOSDCloud"
            Write-Host "-WinRE WiFi                     $WinREWiFi"
            Write-Host "-WinPE DaRT:                    $WinPEDaRT"
            Write-Host "-WinPE Scratch Space:           $ScratchSpace"
            Write-Host "-WinPE Source Wim:              $SourceWim"
            Write-Host "-WinPE Drivers:"
            if ($WinPEDrivers) {foreach ($item in $WinPEDrivers) {Write-Host $item -ForegroundColor DarkGray}}
            Write-Host "-WinPE Extra Files:"
            if ($WinPEExtraFiles) {foreach ($item in $WinPEExtraFiles) {Write-Host $item -ForegroundColor DarkGray}}
            Write-Host "-WinPE Scripts:"
            if ($WinPEScripts) {foreach ($item in $WinPEScripts) {Write-Host $item -ForegroundColor DarkGray}}
            Write-Host "-WinPE ADK Pkgs:"
            if ($WinPEADK) {foreach ($item in $WinPEADK) {Write-Host $item -ForegroundColor DarkGray}}

<#             #=================================================
            Write-Verbose '19.1.1 Validate Proper TaskVersion'
            #=================================================
            if ([System.Version]$TaskVersion -lt [System.Version]"18.10.10") {
                Write-Host '========================================================================================' -ForegroundColor DarkGray
                Write-Warning "PEBuild Tasks need to be version 18.10.10 or newer"
                Write-Warning "Recreate this Task using New-PEBuildTask"
                Return
            } #>

            #=================================================
            Write-Verbose '19.1.1 Validate Proper TaskVersion'
            #=================================================
            if ([System.Version]$TaskVersion -lt [System.Version]"19.1.4.0") {
                Write-Host '========================================================================================' -ForegroundColor DarkGray
                Write-Warning "PEBuild Tasks need to be version 19.1.4.0 or newer"
                Write-Warning "Recreate this Task using New-PEBuildTask or Repair-PEBuildTask"
                Return
            }
            
            #=================================================
            Write-Verbose '19.3.22 Select Latest OSMedia'
            #=================================================
            $TaskOSMedia = Get-OSMedia | Where-Object {$_.OSMGuid -eq $TaskOSMGuid}
            if ($TaskOSMedia) {
                $OSMediaName = $TaskOSMedia.Name
                $OSMediaPath = $TaskOSMedia.FullName
                Write-Host '========================================================================================' -ForegroundColor DarkGray
                Write-Host "Task Source OSMedia" -ForegroundColor Green
                Write-Host "-OSMedia Name:                  $OSMediaName"
                Write-Host "-OSMedia Path:                  $OSMediaPath"
                Write-Host "-OSMedia Family:                $TaskOSMFamily"
                Write-Host "-OSMedia Guid:                  $TaskOSMGuid"
            }
            $LatestOSMedia = Get-OSMedia -Revision OK | Where-Object {$_.OSMFamily -eq $TaskOSMFamily}
            if ($LatestOSMedia) {
                $OSMediaName = $LatestOSMedia.Name
                $OSMediaPath = $LatestOSMedia.FullName
                Write-Host '========================================================================================' -ForegroundColor DarkGray
                Write-Host "Latest Source OSMedia" -ForegroundColor Green
                Write-Host "-OSMedia Name:                  $OSMediaName"
                Write-Host "-OSMedia Path:                  $OSMediaPath"
                Write-Host "-OSMedia Family:                $($LatestOSMedia.OSMFamily)"
                Write-Host "-OSMedia Guid:                  $($LatestOSMedia.OSMGuid)"
            } else {
                Write-Warning "Unable to find a matching OSMFamily $TaskOSMFamily"
                Return
            }
            
            #=================================================
            Write-Verbose '19.1.1 Set Proper Paths'
            #=================================================
            $OSSourcePath = $OSMediaPath
            $OSImagePath = "$OSSourcePath\OS\sources\install.wim"

            #=================================================
            Write-Verbose '19.1.1 Get Windows Image Information'
            #=================================================
            $OSImageIndex = 1
            $WindowsImage = Get-WindowsImage -ImagePath "$OSImagePath" -Index $OSImageIndex | Select-Object -Property *

            $OSImageName = $($WindowsImage.ImageName)
            $OSImageName = $OSImageName -replace '\(', ''
            $OSImageName = $OSImageName -replace '\)', ''

            $OSImageDescription = $($WindowsImage.ImageDescription)

            $OSArchitecture = $($WindowsImage.Architecture)
            if ($OSArchitecture -eq '0') {$OSArchitecture = 'x86'}
            if ($OSArchitecture -eq '6') {$OSArchitecture = 'ia64'}
            if ($OSArchitecture -eq '9') {$OSArchitecture = 'x64'}
            if ($OSArchitecture -eq '12') {$OSArchitecture = 'x64 ARM'}

            $OSEditionID =          $($WindowsImage.EditionId)
            $OSInstallationType =   $($WindowsImage.InstallationType)
            $OSLanguages =          $($WindowsImage.Languages)
            $OSMajorVersion =       $($WindowsImage.MajorVersion)
            $OSBuild =              $($WindowsImage.Build)
            $OSVersion =            $($WindowsImage.Version)
            $OSSPBuild =            $($WindowsImage.SPBuild)
            $OSSPLevel =            $($WindowsImage.SPLevel)
            $OSImageBootable =      $($WindowsImage.ImageBootable)
            $OSWIMBoot =            $($WindowsImage.WIMBoot)
            $OSCreatedTime =        $($WindowsImage.CreatedTime)
            $OSModifiedTime =       $($WindowsImage.ModifiedTime)

            #=================================================
            Write-Verbose '19.1.1 Source OSMedia Windows Image Information'
            #=================================================
            Write-Host '========================================================================================' -ForegroundColor DarkGray
            Write-Host "Source OSMedia Windows Image Information" -ForegroundColor Green
            Write-Host "-Source Path:                   $OSSourcePath"
            Write-Host "-Image File:                    $OSImagePath"
            Write-Host "-Image Index:                   $OSImageIndex"
            Write-Host "-Image Name:                    $OSImageName"
            Write-Host "-Description:                   $OSImageDescription"
            Write-Host "-Architecture:                  $OSArchitecture"
            Write-Host "-Edition:                       $OSEditionID"
            Write-Host "-Type:                          $OSInstallationType"
            Write-Host "-Languages:                     $OSLanguages"
            Write-Host "-Major Version:                 $OSMajorVersion"
            Write-Host "-Build:                         $OSBuild"
            Write-Host "-Version:                       $OSVersion"
            Write-Host "-SPBuild:                       $OSSPBuild"
            Write-Host "-SPLevel:                       $OSSPLevel"
            Write-Host "-Bootable:                      $OSImageBootable"
            Write-Host "-WimBoot:                       $OSWIMBoot"
            Write-Host "-Created Time:                  $OSCreatedTime"
            Write-Host "-Modified Time:                 $OSModifiedTime"
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
            #=================================================
            Write-Verbose '19.1.1 Set DestinationName'
            #=================================================
            if ($WinPEOutput -eq 'Recovery') {
                $DestinationName = "Microsoft Windows Recovery Environment ($OSArchitecture)"
            } else {
                $DestinationName = "Microsoft Windows PE ($OSArchitecture)"
            }
            Write-Host "-Destination Name:              $DestinationName"

            #=================================================
            Write-Verbose '19.1.1 Validate Registry CurrentVersion.xml'
            #=================================================
            if (Test-Path "$OSSourcePath\info\xml\CurrentVersion.xml") {
                $RegKeyCurrentVersion = Import-Clixml -Path "$OSSourcePath\info\xml\CurrentVersion.xml"
                $ReleaseId = $($RegKeyCurrentVersion.ReleaseId)
            }

            #=================================================
            # Set ReleaseID
            #=================================================
            if ($OSBuild -eq 7600) {$ReleaseId = 7600}
            if ($OSBuild -eq 7601) {$ReleaseId = 7601}
            if ($OSBuild -eq 10240) {$ReleaseId = 1507}
            if ($OSBuild -eq 14393) {$ReleaseId = 1607}
            if ($OSBuild -eq 15063) {$ReleaseId = 1703}
            if ($OSBuild -eq 16299) {$ReleaseId = 1709}
            if ($OSBuild -eq 17134) {$ReleaseId = 1803}
            if ($OSBuild -eq 17763) {$ReleaseId = 1809}
            if ($OSBuild -eq 18362) {$ReleaseId = 1903}
            if ($OSBuild -eq 18363) {$ReleaseId = 1909}
            if ($OSBuild -eq 19041) {$ReleaseId = 2004}
            if ($OSBuild -eq 19042) {$ReleaseId = '20H2'}
            if ($OSBuild -eq 19043) {$ReleaseId = '21H1'}
            if ($OSBuild -eq 19044) {$ReleaseId = '21H2'}
            if ($OSBuild -eq 22000) {$ReleaseId = '21H2'}
            if ($OSBuild -eq 20348) {$ReleaseId = '21H2'}
            #=================================================
            Write-Verbose '19.1.1 Set Working Path'
            #=================================================
            #$BuildName = "build$((Get-Date).ToString('mmss'))"
            $WorkingPath = "$SetOSDBuilderPathPEBuilds\$Taskname $($LatestOSMedia.UBR)"
            if ($CustomName) {
                $WorkingPath = "$SetOSDBuilderPathPEBuilds\$CustomName"
            }

            #=================================================
            Write-Verbose '19.1.1 Validate DeploymentShare'
            #=================================================
            if ($MDTDeploymentShare) {
                if (!(Test-Path "$MDTDeploymentShare")) {
                    Write-Warning "MDT Deployment Share not found ... Exiting!"
                    Return
                }
            }

            #=================================================
            Write-Verbose '19.1.1 Execute'
            #=================================================
            if ($Execute.IsPresent) {

                #=================================================
                Write-Verbose '19.1.1 Remove Existing OSMedia'
                #=================================================
                if (Test-Path $WorkingPath) {
                    Write-Host '========================================================================================' -ForegroundColor DarkGray
                    Write-Warning "$WorkingPath exists.  Contents will be replaced"
                    Remove-Item -Path "$WorkingPath\*" -Force -Recurse | Out-Null
                }

                #=================================================
                Write-Verbose '19.3.21 Set Working Directories'
                #=================================================
                $Info = Join-Path $WorkingPath 'info'
                if (!(Test-Path "$Info"))           {New-Item "$Info" -ItemType Directory -Force | Out-Null}
                if (!(Test-Path "$Info\json"))      {New-Item "$Info\json" -ItemType Directory -Force | Out-Null}
                if (!(Test-Path "$Info\logs"))      {New-Item "$Info\logs" -ItemType Directory -Force | Out-Null}
                if (!(Test-Path "$Info\xml"))       {New-Item "$Info\xml" -ItemType Directory -Force | Out-Null}
                $OS = Join-Path $WorkingPath 'OS'
                if (!(Test-Path "$OS"))             {New-Item "$OS" -ItemType Directory -Force | Out-Null}

                $Sources = "$OS\sources"
                if (!(Test-Path "$Sources")) {New-Item "$Sources" -ItemType Directory -Force | Out-Null}

                $Logs = Join-Path $Info 'logs'
                $PEInfo = $Info
                $PELogs = $Logs
                #=================================================
                Write-Verbose '19.1.1 Set WimTemp'
                #=================================================
                $WimTemp = Join-Path $WorkingPath "WimTemp"
                if (!(Test-Path "$WimTemp")) {New-Item "$WimTemp" -ItemType Directory -Force | Out-Null}

                $WorkingWim = "$WorkingPath\WimTemp\boot.wim"

                #=================================================
                Write-Verbose '19.1.1 Start Transcript'
                #=================================================
                Write-Host '========================================================================================' -ForegroundColor DarkGray
                $ScriptName = $($MyInvocation.MyCommand.Name)
                $LogName = "$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-$ScriptName.log"
                Start-Transcript -Path (Join-Path "$Info\logs" $LogName)

                #=================================================
                Write-Verbose '19.1.1 WinPE Information'
                #=================================================
                Write-Host '========================================================================================' -ForegroundColor DarkGray
                Write-Host "WinPE Information" -ForegroundColor Green
                Write-Host "-WorkingName:   $TaskName" -ForegroundColor Yellow
                Write-Host "-WorkingPath:   $WorkingPath" -ForegroundColor Yellow
                Write-Host "-OS:            $OS"
                Write-Host "-Info:          $Info"
                Write-Host "-Logs:          $Info\logs"

                #=================================================
                Write-Verbose '19.1.1 Create Mount Directories'
                #=================================================
                $MountDirectory = Join-Path $SetOSDBuilderPathMount "pebuild$((Get-Date).ToString('mmss'))"
                $MountWinPE = $MountDirectory
                $MountWinRE = $null
                $MountWinSE = $null
                if ( ! (Test-Path "$MountDirectory")) {New-Item "$MountDirectory" -ItemType Directory -Force | Out-Null}

                #=================================================
                #   Copy Media
                #=================================================
                Write-Host '========================================================================================' -ForegroundColor DarkGray
                Show-ActionTime; Write-Host "Copying $OSSourcePath\OS to $OS" -ForegroundColor Green
                Copy-Item -Path "$OSSourcePath\OS\bootmgr" -Destination "$OS\bootmgr" -Force | Out-Null
                Copy-Item -Path "$OSSourcePath\OS\bootmgr.efi" -Destination "$OS\bootmgr.efi" -Force | Out-Null
                Copy-Item -Path "$OSSourcePath\OS\boot\" -Destination "$OS\boot\" -Recurse -Force | Out-Null
                Copy-Item -Path "$OSSourcePath\OS\efi\" -Destination "$OS\efi\" -Recurse -Force | Out-Null
                Dism /Export-Image /SourceImageFile:"$OSSourcePath\WinPE\$SourceWim.wim" /SourceIndex:1 /DestinationImageFile:"$WorkingWim" /DestinationName:"$DestinationName" /Bootable /CheckIntegrity | Out-Null
                #Copy-Item -Path "$OSSourcePath\WinPE\$SourceWim.wim" -Destination "$WorkingWim" -Force | Out-Null
                if (!(Test-Path "$Sources")) {New-Item "$Sources" -ItemType Directory -Force | Out-Null}
                
                #=================================================
                #   Mount-WindowsImage
                #=================================================
                Mount-PEBuild -MountDirectory $MountDirectory -WorkingWim $WorkingWim
                #=================================================
                #   PauseMount
                #=================================================
                if ($PauseMount.IsPresent){[void](Read-Host 'Press Enter to Continue')}
                #=================================================
                #   Get-RegCurrentVersion
                #=================================================
                $RegKeyCurrentVersion = Get-RegCurrentVersion -Path $MountDirectory

                $RegValueDisplayVersion = ($RegKeyCurrentVersion).DisplayVersion
                #$ReleaseId = ($RegKeyCurrentVersion).ReleaseId
                #if ($RegValueDisplayVersion) {$ReleaseId = $RegValueDisplayVersion}
                #=================================================
                #   Get Registry and UBR
                #=================================================
                $RegKeyCurrentVersionUBR = $($RegKeyCurrentVersion.UBR)
                $UBR = "$OSBuild.$RegKeyCurrentVersionUBR"

                $RegKeyCurrentVersion | Out-File "$Info\CurrentVersion.txt"
                $RegKeyCurrentVersion | Out-File "$WorkingPath\CurrentVersion.txt"
                $RegKeyCurrentVersion | Out-File "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-CurrentVersion.txt"
                $RegKeyCurrentVersion | Export-Clixml -Path "$Info\xml\CurrentVersion.xml"
                $RegKeyCurrentVersion | Export-Clixml -Path "$Info\xml\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-CurrentVersion.xml"
                $RegKeyCurrentVersion | ConvertTo-Json | Out-File "$Info\json\CurrentVersion.json"
                $RegKeyCurrentVersion | ConvertTo-Json | Out-File "$Info\json\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-CurrentVersion.json"
                #=================================================
                #   Set-PEBuildScratchSpace Set-PEBuildTargetPath
                #=================================================
                Set-PEBuildScratchSpace -MountDirectory $MountDirectory -ScratchSpace $ScratchSpace
                Set-PEBuildTargetPath -MountDirectory $MountDirectory
                #=================================================
                #   WinPE ContentPacks
                #=================================================
                if (Get-IsContentPacksEnabled) {
                    Add-ContentPack -PackType PEDaRT
                    Add-ContentPack -PackType PEADK
                    #Add-ContentPack -PackType PEADK -WinPEOutput $WinPEOutput -SourceWim $SourceWim
                    #Add-ContentPack -PackType PEDrivers
                    #Add-ContentPack -PackType PEExtraFiles
                    #Add-ContentPack -PackType PEPoshMods
                    #Add-ContentPack -PackType PERegistry
                    #Add-ContentPack -PackType PEScripts
                }
                $WinPEADKPE = $WinPEADK
                Add-ContentADKWinPE
                Expand-DaRTPE
                #=================================================
                Write-Verbose '19.1.1 WinPE: ADK Optional Components'
                #=================================================
<#                 Write-Host '========================================================================================' -ForegroundColor DarkGray
                Write-Host "WinPE: ADK Optional Components" -ForegroundColor Green
                if ([string]::IsNullOrEmpty($WinPEADK) -or [string]::IsNullOrWhiteSpace($WinPEADK)) {
                    # Do Nothing
                } else {
                    foreach ($PackagePath in $WinPEADK) {
                        if ($PackagePath -like "*NetFx*") {
                            Write-Host "$SetOSDBuilderPathContent\$PackagePath" -ForegroundColor Green
                            Add-WindowsPackage -PackagePath "$SetOSDBuilderPathContent\$PackagePath" -Path "$MountDirectory" -LogPath "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Add-WindowsPackage.log" | Out-Null
                        }
                    }
                    $WinPEADK = $WinPEADK | Where-Object {$_ -notlike "*NetFx*"}
                    foreach ($PackagePath in $WinPEADK) {
                        if ($PackagePath -like "*WinPE-PowerShell*") {
                            Write-Host "$SetOSDBuilderPathContent\$PackagePath" -ForegroundColor Green
                            Add-WindowsPackage -PackagePath "$SetOSDBuilderPathContent\$PackagePath" -Path "$MountDirectory" -LogPath "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Add-WindowsPackage.log" | Out-Null
                        }
                    }
                    $WinPEADK = $WinPEADK | Where-Object {$_ -notlike "*PowerShell*"}
                    foreach ($PackagePath in $WinPEADK) {
                        Write-Host "$SetOSDBuilderPathContent\$PackagePath" -ForegroundColor Green
                        Add-WindowsPackage -PackagePath "$SetOSDBuilderPathContent\$PackagePath" -Path "$MountDirectory" -LogPath "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Add-WindowsPackage.log" | Out-Null
                    }
                } #>

<#                 #=================================================
                Write-Verbose '19.1.1 WinPE: WinPE DaRT'
                #=================================================
                Write-Host '========================================================================================' -ForegroundColor DarkGray
                Write-Host "WinPE: Microsoft DaRT" -ForegroundColor Green
                if ($WinPEDaRT) {
                    if ([string]::IsNullOrEmpty($WinPEDaRT) -or [string]::IsNullOrWhiteSpace($WinPEDaRT)) {Write-Warning "Skipping WinPE DaRT"}
                    elseif (Test-Path "$SetOSDBuilderPathContent\$WinPEDaRT") {
                        #=================================================
                        if (Test-Path $(Join-Path $(Split-Path "$SetOSDBuilderPathContent\$WinPEDart") 'DartConfig.dat')) {
                            Write-Host "$SetOSDBuilderPathContent\$WinPEDaRT"
                            expand.exe "$SetOSDBuilderPathContent\$WinPEDaRT" -F:*.* "$MountDirectory"
                            #if (Test-Path "$MountDirectory\Windows\System32\winpeshl.ini") {Remove-Item -Path "$MountDirectory\Windows\System32\winpeshl.ini" -Force}
                            #=================================================
                            Write-Host "Copying DartConfig.dat to $MountDirectory\Windows\System32\DartConfig.dat"
                            Copy-Item -Path $(Join-Path $(Split-Path "$SetOSDBuilderPathContent\$WinPEDart") 'DartConfig.dat') -Destination "$MountDirectory\Windows\System32\DartConfig.dat" -Force | Out-Null
                            #=================================================
                        } elseif (Test-Path $(Join-Path $(Split-Path $SetOSDBuilderPathContent\$WinPEDart) 'DartConfig8.dat')) {
                            Write-Host "$SetOSDBuilderPathContent\$WinPEDaRT"
                            expand.exe "$SetOSDBuilderPathContent\$WinPEDaRT" -F:*.* "$MountDirectory"
                            #if (Test-Path "$MountDirectory\Windows\System32\winpeshl.ini") {Remove-Item -Path "$MountDirectory\Windows\System32\winpeshl.ini" -Force}
                            #=================================================
                            Write-Host "Copying DartConfig8.dat to $MountDirectory\Windows\System32\DartConfig.dat"
                            Copy-Item -Path $(Join-Path $(Split-Path "$SetOSDBuilderPathContent\$WinPEDart") 'DartConfig8.dat') -Destination "$MountDirectory\Windows\System32\DartConfig.dat" -Force | Out-Null
                            #=================================================
                        } else {
                            Write-Warning "DartConfig.dat or DartConfig8.dat were not found. Unable to integrate"
                        }
                        #=================================================
                        Write-Verbose '19.1.1 WinPE Edit winpeshl.ini'
                        #=================================================
                        if ($WinPEOutput -eq 'Recovery') {
                            Write-Host '========================================================================================' -ForegroundColor DarkGray
                            Write-Host "WinPE: Edit winpeshl.ini" -ForegroundColor Green
                            if (Test-Path "$MountDirectory\Windows\System32\winpeshl.ini") {
                                Remove-Item -Path "$MountDirectory\Windows\System32\winpeshl.ini" -Force | Out-Null
                            }
                            $DaRTwinpeshl | Out-File "$MountDirectory\Windows\System32\winpeshl.ini" -Force
                        }
                        #=================================================
                    } else {Write-Warning "WinPE DaRT do not exist in $SetOSDBuilderPathContent\$WinPEDart"}
                } #>
<#                 #=================================================
                Write-Verbose '19.1.1 WinPE Remove winpeshl.ini'
                #=================================================
                if ($WinPEOutput -ne 'Recovery') {
                    Write-Host '========================================================================================' -ForegroundColor DarkGray
                    Write-Host "WinPE: Remove winpeshl.ini" -ForegroundColor Green
                    if (Test-Path "$MountDirectory\Windows\System32\winpeshl.ini") {
                        Remove-Item -Path "$MountDirectory\Windows\System32\winpeshl.ini" -Force | Out-Null
                    }
                } #>
                
                #=================================================
                Write-Verbose '19.1.1 Copy MDT'
                #=================================================
                if ($MDTDeploymentShare) {
                    Write-Host '========================================================================================' -ForegroundColor DarkGray
                    Write-Host "WinPE: Copy MDT Deployment Share from $MDTDeploymentShare" -ForegroundColor Green
                    $MDTwinpeshl | Out-File "$MountDirectory\Windows\System32\winpeshl.ini" -Force

                    if ($OSArchitecture -eq 'x86') {$MDTUnattendPEx86 | Out-File "$MountDirectory\Unattend.xml" -Encoding utf8 -Force}
                    if ($OSArchitecture -eq 'x64') {$MDTUnattendPEx64 | Out-File "$MountDirectory\Unattend.xml" -Encoding utf8 -Force}

                    New-Item -Path "$MountDirectory\Deploy\Scripts" -ItemType Directory -Force | Out-Null
                    New-Item -Path "$MountDirectory\Deploy\Tools\$OSArchitecture\00000409" -ItemType Directory -Force | Out-Null

                    Copy-Item -Path "$MDTDeploymentShare\Control\Bootstrap.ini" -Destination "$MountDirectory\Deploy\Scripts\Bootstrap.ini" -Force -ErrorAction SilentlyContinue | Out-Null
                    Copy-Item -Path "$MDTDeploymentShare\Control\LocationServer.xml" -Destination "$MountDirectory\Deploy\Scripts\LocationServer.xml" -Force -ErrorAction SilentlyContinue | Out-Null
                    Copy-Item -Path "$MDTDeploymentShare\Scripts\BDD_Welcome_ENU.xml" -Destination "$MountDirectory\Deploy\Scripts\BDD_Welcome_ENU.xml" -Force -ErrorAction SilentlyContinue | Out-Null
                    Copy-Item -Path "$MDTDeploymentShare\Scripts\BackButton.jpg" -Destination "$MountDirectory\Deploy\Scripts\BackButton.jpg" -Force -ErrorAction SilentlyContinue | Out-Null
                    Copy-Item -Path "$MDTDeploymentShare\Scripts\BackButton.png" -Destination "$MountDirectory\Deploy\Scripts\BackButton.png" -Force -ErrorAction SilentlyContinue | Out-Null
                    Copy-Item -Path "$MDTDeploymentShare\Scripts\Computer.png" -Destination "$MountDirectory\Deploy\Scripts\Computer.png" -Force -ErrorAction SilentlyContinue | Out-Null
                    Copy-Item -Path "$MDTDeploymentShare\Scripts\Credentials_ENU.xml" -Destination "$MountDirectory\Deploy\Scripts\Credentials_ENU.xml" -Force -ErrorAction SilentlyContinue | Out-Null
                    Copy-Item -Path "$MDTDeploymentShare\Scripts\Credentials_scripts.vbs" -Destination "$MountDirectory\Deploy\Scripts\Credentials_scripts.vbs" -Force -ErrorAction SilentlyContinue | Out-Null
                    Copy-Item -Path "$MDTDeploymentShare\Scripts\DeployWiz_Administrator.png" -Destination "$MountDirectory\Deploy\Scripts\DeployWiz_Administrator.png" -Force -ErrorAction SilentlyContinue | Out-Null
                    Copy-Item -Path "$MDTDeploymentShare\Scripts\FolderIcon.png" -Destination "$MountDirectory\Deploy\Scripts\FolderIcon.png" -Force -ErrorAction SilentlyContinue | Out-Null
                    Copy-Item -Path "$MDTDeploymentShare\Scripts\ItemIcon1.png" -Destination "$MountDirectory\Deploy\Scripts\ItemIcon1.png" -Force -ErrorAction SilentlyContinue | Out-Null
                    Copy-Item -Path "$MDTDeploymentShare\Scripts\LTICleanup.wsf" -Destination "$MountDirectory\Deploy\Scripts\LTICleanup.wsf" -Force -ErrorAction SilentlyContinue | Out-Null
                    Copy-Item -Path "$MDTDeploymentShare\Scripts\LTIGetFolder.wsf" -Destination "$MountDirectory\Deploy\Scripts\LTIGetFolder.wsf" -Force -ErrorAction SilentlyContinue | Out-Null
                    Copy-Item -Path "$MDTDeploymentShare\Scripts\LiteTouch.wsf" -Destination "$MountDirectory\Deploy\Scripts\LiteTouch.wsf" -Force -ErrorAction SilentlyContinue | Out-Null
                    Copy-Item -Path "$MDTDeploymentShare\Scripts\MinusIcon1.png" -Destination "$MountDirectory\Deploy\Scripts\MinusIcon1.png" -Force -ErrorAction SilentlyContinue | Out-Null
                    Copy-Item -Path "$MDTDeploymentShare\Scripts\NICSettings_Definition_ENU.xml" -Destination "$MountDirectory\Deploy\Scripts\NICSettings_Definition_ENU.xml" -Force -ErrorAction SilentlyContinue | Out-Null
                    Copy-Item -Path "$MDTDeploymentShare\Scripts\NavBar.png" -Destination "$MountDirectory\Deploy\Scripts\NavBar.png" -Force -ErrorAction SilentlyContinue | Out-Null
                    Copy-Item -Path "$MDTDeploymentShare\Scripts\PlusIcon1.png" -Destination "$MountDirectory\Deploy\Scripts\PlusIcon1.png" -Force -ErrorAction SilentlyContinue | Out-Null
                    Copy-Item -Path "$MDTDeploymentShare\Scripts\SelectItem.jpg" -Destination "$MountDirectory\Deploy\Scripts\SelectItem.jpg" -Force -ErrorAction SilentlyContinue | Out-Null
                    Copy-Item -Path "$MDTDeploymentShare\Scripts\SelectItem.png" -Destination "$MountDirectory\Deploy\Scripts\SelectItem.png" -Force -ErrorAction SilentlyContinue | Out-Null
                    Copy-Item -Path "$MDTDeploymentShare\Scripts\Summary_Definition_ENU.xml" -Destination "$MountDirectory\Deploy\Scripts\Summary_Definition_ENU.xml" -Force -ErrorAction SilentlyContinue | Out-Null
                    Copy-Item -Path "$MDTDeploymentShare\Scripts\Summary_scripts.vbs" -Destination "$MountDirectory\Deploy\Scripts\Summary_scripts.vbs" -Force -ErrorAction SilentlyContinue | Out-Null
                    Copy-Item -Path "$MDTDeploymentShare\Scripts\WelcomeBanner.jpg" -Destination "$MountDirectory\Deploy\Scripts\WelcomeBanner.jpg" -Force -ErrorAction SilentlyContinue | Out-Null
                    Copy-Item -Path "$MDTDeploymentShare\Scripts\WelcomeWiz_Background.jpg" -Destination "$MountDirectory\Deploy\Scripts\WelcomeWiz_Background.jpg" -Force -ErrorAction SilentlyContinue | Out-Null
                    Copy-Item -Path "$MDTDeploymentShare\Scripts\WelcomeWiz_Choice.vbs" -Destination "$MountDirectory\Deploy\Scripts\WelcomeWiz_Choice.vbs" -Force -ErrorAction SilentlyContinue | Out-Null
                    Copy-Item -Path "$MDTDeploymentShare\Scripts\WelcomeWiz_Choice.xml" -Destination "$MountDirectory\Deploy\Scripts\WelcomeWiz_Choice.xml" -Force -ErrorAction SilentlyContinue | Out-Null
                    Copy-Item -Path "$MDTDeploymentShare\Scripts\WelcomeWiz_DeployRoot.vbs" -Destination "$MountDirectory\Deploy\Scripts\WelcomeWiz_DeployRoot.vbs" -Force -ErrorAction SilentlyContinue | Out-Null
                    Copy-Item -Path "$MDTDeploymentShare\Scripts\WelcomeWiz_DeployRoot.xml" -Destination "$MountDirectory\Deploy\Scripts\WelcomeWiz_DeployRoot.xml" -Force -ErrorAction SilentlyContinue | Out-Null
                    Copy-Item -Path "$MDTDeploymentShare\Scripts\WelcomeWiz_Initialize.vbs" -Destination "$MountDirectory\Deploy\Scripts\WelcomeWiz_Initialize.vbs" -Force -ErrorAction SilentlyContinue | Out-Null
                    Copy-Item -Path "$MDTDeploymentShare\Scripts\WelcomeWiz_Initialize.xml" -Destination "$MountDirectory\Deploy\Scripts\WelcomeWiz_Initialize.xml" -Force -ErrorAction SilentlyContinue | Out-Null
                    Copy-Item -Path "$MDTDeploymentShare\Scripts\WizUtility.vbs" -Destination "$MountDirectory\Deploy\Scripts\WizUtility.vbs" -Force -ErrorAction SilentlyContinue | Out-Null
                    Copy-Item -Path "$MDTDeploymentShare\Scripts\Wizard.css" -Destination "$MountDirectory\Deploy\Scripts\Wizard.css" -Force -ErrorAction SilentlyContinue | Out-Null
                    Copy-Item -Path "$MDTDeploymentShare\Scripts\Wizard.hta" -Destination "$MountDirectory\Deploy\Scripts\Wizard.hta" -Force -ErrorAction SilentlyContinue | Out-Null
                    Copy-Item -Path "$MDTDeploymentShare\Scripts\Wizard.ico" -Destination "$MountDirectory\Deploy\Scripts\Wizard.ico" -Force -ErrorAction SilentlyContinue | Out-Null
                    Copy-Item -Path "$MDTDeploymentShare\Scripts\ZTIBCDUtility.vbs" -Destination "$MountDirectory\Deploy\Scripts\ZTIBCDUtility.vbs" -Force -ErrorAction SilentlyContinue | Out-Null
                    Copy-Item -Path "$MDTDeploymentShare\Scripts\ZTIConfigFile.vbs" -Destination "$MountDirectory\Deploy\Scripts\ZTIConfigFile.vbs" -Force -ErrorAction SilentlyContinue | Out-Null
                    Copy-Item -Path "$MDTDeploymentShare\Scripts\ZTIDataAccess.vbs" -Destination "$MountDirectory\Deploy\Scripts\ZTIDataAccess.vbs" -Force -ErrorAction SilentlyContinue | Out-Null
                    Copy-Item -Path "$MDTDeploymentShare\Scripts\ZTIDiskUtility.vbs" -Destination "$MountDirectory\Deploy\Scripts\ZTIDiskUtility.vbs" -Force -ErrorAction SilentlyContinue | Out-Null
                    Copy-Item -Path "$MDTDeploymentShare\Scripts\ZTIGather.wsf" -Destination "$MountDirectory\Deploy\Scripts\ZTIGather.wsf" -Force -ErrorAction SilentlyContinue | Out-Null
                    Copy-Item -Path "$MDTDeploymentShare\Scripts\ZTIGather.xml" -Destination "$MountDirectory\Deploy\Scripts\ZTIGather.xml" -Force -ErrorAction SilentlyContinue | Out-Null
                    Copy-Item -Path "$MDTDeploymentShare\Scripts\ZTINicConfig.wsf" -Destination "$MountDirectory\Deploy\Scripts\ZTINicConfig.wsf" -Force -ErrorAction SilentlyContinue | Out-Null
                    Copy-Item -Path "$MDTDeploymentShare\Scripts\ZTINicUtility.vbs" -Destination "$MountDirectory\Deploy\Scripts\ZTINicUtility.vbs" -Force -ErrorAction SilentlyContinue | Out-Null
                    Copy-Item -Path "$MDTDeploymentShare\Scripts\ZTIUtility.vbs" -Destination "$MountDirectory\Deploy\Scripts\ZTIUtility.vbs" -Force -ErrorAction SilentlyContinue | Out-Null
                    Copy-Item -Path "$MDTDeploymentShare\Scripts\btnout.png" -Destination "$MountDirectory\Deploy\Scripts\btnout.png" -Force -ErrorAction SilentlyContinue | Out-Null
                    Copy-Item -Path "$MDTDeploymentShare\Scripts\btnover.png" -Destination "$MountDirectory\Deploy\Scripts\btnover.png" -Force -ErrorAction SilentlyContinue | Out-Null
                    Copy-Item -Path "$MDTDeploymentShare\Scripts\btnsel.png" -Destination "$MountDirectory\Deploy\Scripts\btnsel.png" -Force -ErrorAction SilentlyContinue | Out-Null
                    Copy-Item -Path "$MDTDeploymentShare\Scripts\header-image.png" -Destination "$MountDirectory\Deploy\Scripts\header-image.png" -Force -ErrorAction SilentlyContinue | Out-Null
                    Copy-Item -Path "$MDTDeploymentShare\Scripts\minusico.gif" -Destination "$MountDirectory\Deploy\Scripts\minusico.gif" -Force -ErrorAction SilentlyContinue | Out-Null
                    Copy-Item -Path "$MDTDeploymentShare\Scripts\plusicon.gif" -Destination "$MountDirectory\Deploy\Scripts\plusicon.gif" -Force -ErrorAction SilentlyContinue | Out-Null

                    Copy-Item -Path "$MDTDeploymentShare\Tools\$OSArchitecture\00000409\tsres.dll" -Destination "$MountDirectory\Deploy\Tools\$OSArchitecture\00000409\tsres.dll" -Force -ErrorAction SilentlyContinue | Out-Null
                    Copy-Item -Path "$MDTDeploymentShare\Tools\$OSArchitecture\BDDRUN.exe" -Destination "$MountDirectory\Windows\system32\BDDRUN.exe" -Force -ErrorAction SilentlyContinue | Out-Null
                    Copy-Item -Path "$MDTDeploymentShare\Tools\$OSArchitecture\BGInfo.exe" -Destination "$MountDirectory\Windows\system32\BGInfo.exe" -Force -ErrorAction SilentlyContinue | Out-Null
                    Copy-Item -Path "$MDTDeploymentShare\Tools\$OSArchitecture\BGInfo64.exe" -Destination "$MountDirectory\Windows\system32\BGInfo64.exe" -Force -ErrorAction SilentlyContinue | Out-Null
                    Copy-Item -Path "$MDTDeploymentShare\Tools\$OSArchitecture\CcmCore.dll" -Destination "$MountDirectory\Deploy\Tools\$OSArchitecture\CcmCore.dll" -Force -ErrorAction SilentlyContinue | Out-Null
                    Copy-Item -Path "$MDTDeploymentShare\Tools\$OSArchitecture\CcmUtilLib.dll" -Destination "$MountDirectory\Deploy\Tools\$OSArchitecture\CcmUtilLib.dll" -Force -ErrorAction SilentlyContinue | Out-Null
                    Copy-Item -Path "$MDTDeploymentShare\Tools\$OSArchitecture\Microsoft.BDD.Utility.dll" -Destination "$MountDirectory\Deploy\Tools\$OSArchitecture\Microsoft.BDD.Utility.dll" -Force -ErrorAction SilentlyContinue | Out-Null
                    Copy-Item -Path "$MDTDeploymentShare\Tools\$OSArchitecture\SmsCore.dll" -Destination "$MountDirectory\Deploy\Tools\$OSArchitecture\SmsCore.dll" -Force -ErrorAction SilentlyContinue | Out-Null
                    Copy-Item -Path "$MDTDeploymentShare\Tools\$OSArchitecture\Smsboot.exe" -Destination "$MountDirectory\Deploy\Tools\$OSArchitecture\Smsboot.exe" -Force -ErrorAction SilentlyContinue | Out-Null
                    Copy-Item -Path "$MDTDeploymentShare\Tools\$OSArchitecture\TSEnv.exe" -Destination "$MountDirectory\Deploy\Tools\$OSArchitecture\TSEnv.exe" -Force -ErrorAction SilentlyContinue | Out-Null
                    Copy-Item -Path "$MDTDeploymentShare\Tools\$OSArchitecture\TSResNlc.dll" -Destination "$MountDirectory\Deploy\Tools\$OSArchitecture\TSResNlc.dll" -Force -ErrorAction SilentlyContinue | Out-Null
                    Copy-Item -Path "$MDTDeploymentShare\Tools\$OSArchitecture\TsCore.dll" -Destination "$MountDirectory\Deploy\Tools\$OSArchitecture\TsCore.dll" -Force -ErrorAction SilentlyContinue | Out-Null
                    Copy-Item -Path "$MDTDeploymentShare\Tools\$OSArchitecture\TsManager.exe" -Destination "$MountDirectory\Deploy\Tools\$OSArchitecture\TsManager.exe" -Force -ErrorAction SilentlyContinue | Out-Null
                    Copy-Item -Path "$MDTDeploymentShare\Tools\$OSArchitecture\TsMessaging.dll" -Destination "$MountDirectory\Deploy\Tools\$OSArchitecture\TsMessaging.dll" -Force -ErrorAction SilentlyContinue | Out-Null
                    Copy-Item -Path "$MDTDeploymentShare\Tools\$OSArchitecture\TsProgressUI.exe" -Destination "$MountDirectory\Deploy\Tools\$OSArchitecture\TsProgressUI.exe" -Force -ErrorAction SilentlyContinue | Out-Null
                    Copy-Item -Path "$MDTDeploymentShare\Tools\$OSArchitecture\TsmBootstrap.exe" -Destination "$MountDirectory\Deploy\Tools\$OSArchitecture\TsmBootstrap.exe" -Force -ErrorAction SilentlyContinue | Out-Null
                    Copy-Item -Path "$MDTDeploymentShare\Tools\$OSArchitecture\WinRERUN.exe" -Destination "$MountDirectory\Deploy\Tools\$OSArchitecture\WinRERUN.exe" -Force -ErrorAction SilentlyContinue | Out-Null

                    Copy-Item -Path "$MDTDeploymentShare\Tools\$OSArchitecture\xprslib.dll" -Destination "$MountDirectory\Deploy\Tools\$OSArchitecture\xprslib.dll" -Force -ErrorAction SilentlyContinue | Out-Null

                    Copy-Item -Path "$MDTDeploymentShare\Tools\$OSArchitecture\CommonUtils.dll" -Destination "$MountDirectory\Deploy\Tools\$OSArchitecture\CommonUtils.dll" -Force -ErrorAction SilentlyContinue | Out-Null
                    Copy-Item -Path "$MDTDeploymentShare\Tools\$OSArchitecture\ccmgencert.dll" -Destination "$MountDirectory\Deploy\Tools\$OSArchitecture\ccmgencert.dll" -Force -ErrorAction SilentlyContinue | Out-Null
                    Copy-Item -Path "$MDTDeploymentShare\Tools\$OSArchitecture\msvcp120.dll" -Destination "$MountDirectory\Deploy\Tools\$OSArchitecture\msvcp120.dll" -Force -ErrorAction SilentlyContinue | Out-Null
                    Copy-Item -Path "$MDTDeploymentShare\Tools\$OSArchitecture\msvcr120.dll" -Destination "$MountDirectory\Deploy\Tools\$OSArchitecture\msvcr120.dll" -Force -ErrorAction SilentlyContinue | Out-Null
                    #[void](Read-Host 'Press Enter to Continue')
                }
                #=================================================
                #   Auto ExtraFiles
                #=================================================
                if ($WinPEAutoExtraFiles -eq $true) {
                    Show-ActionTime; Write-Host -ForegroundColor Green "WinPE: Copy Auto ExtraFiles from $OSSourcePath\WinPE\AutoExtraFiles"
                    #robocopy "$OSSourcePath\WinPE\AutoExtraFiles" "$MountDirectory" *.* /s /ndl /xf bcp47*.dll /xx /b /np /ts /tee /r:0 /w:0 /Log+:"$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-AutoExtraFiles.log" | Out-Null
                }
                #=================================================
                #   Enable-WinPEOSDCloud
                #=================================================
                if ($WinPEOSDCloud -eq $true) {Enable-WinPEOSDCloud}
                #=================================================
                #   Enable-WinREWiFi
                #=================================================
                if ($WinREWiFi -eq $true) {Enable-WinREWiFi}
                #=================================================
                #   PEExtraFiles
                #=================================================
                if ($WinPEExtraFiles) {
                    Show-ActionTime; Write-Host -ForegroundColor Green "WinPE: Task PEExtraFiles"
                    foreach ($ExtraFile in $WinPEExtraFiles) {
                        Write-Host "Source: $SetOSDBuilderPathContent\$ExtraFile" -ForegroundColor DarkGray
                        #robocopy "$SetOSDBuilderPathContent\$ExtraFile" "$MountDirectory" *.* /s /ndl /xx /b /np /ts /tee /r:0 /w:0 /Log+:"$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-ExtraFiles.log" | Out-Null
                        #robocopy "$SetOSDBuilderPathContent\$ExtraFile" "$MountDirectory" *.* /XD "WindowsPowerShell" /S /ZB /COPY:D /NODCOPY /XJ /NDL /NP /TEE /TS /XX /R:0 /W:0 /LOG+:"$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-ExtraFiles.log" | Out-Null
                    }
                }
                if (Get-IsContentPacksEnabled) {
                    Add-ContentPack -PackType PEExtraFiles
                }
                #=================================================
                #   PEDrivers
                #=================================================
                if ($WinPEDrivers) {
                    Show-ActionTime; Write-Host -ForegroundColor Green "WinPE: Task Drivers"
                    foreach ($WinPEDriver in $WinPEDrivers) {
                        Write-Host "$SetOSDBuilderPathContent\$WinPEDriver" -ForegroundColor Green
                        Add-WindowsDriver -Path "$MountDirectory" -Driver "$SetOSDBuilderPathContent\$WinPEDriver" -Recurse -ForceUnsigned -LogPath "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Add-WindowsDriver.log" | Out-Null
                    }
                }
                if (Get-IsContentPacksEnabled) {
                    Add-ContentPack -PackType PEDrivers
                }
                #=================================================
                #   Scripts
                #=================================================
                if ($WinPEScripts) {
                    Show-ActionTime; Write-Host -ForegroundColor Green "WinPE: Task PowerShell Scripts"
                    foreach ($PSWimScript in $WinPEScripts) {
                        if (Test-Path "$SetOSDBuilderPathContent\$PSWimScript") {
                            Write-Host "$SetOSDBuilderPathContent\$PSWimScript" -ForegroundColor Green
                            Invoke-Expression "& '$SetOSDBuilderPathContent\$PSWimScript'"
                        }
                    }
                }
                if (Get-IsContentPacksEnabled) {
                    Add-ContentPack -PackType PEScripts
                }
                #=================================================
                #   PEPoshMods
                #=================================================
                if (Get-IsContentPacksEnabled) {
                    Add-ContentPack -PackType PEPoshMods
                }
                #=================================================
                #   Registry
                #=================================================
                if (Get-IsContentPacksEnabled) {
                    Add-ContentPack -PackType PERegistry
                }
                #=================================================
                Write-Verbose '19.1.1 WinPE Mounted Package Inventory'
                #=================================================
                Write-Host '========================================================================================' -ForegroundColor DarkGray
                Write-Host "WinPE: Export Package Inventory" -ForegroundColor Green
                Write-Host "$Info\WindowsPackage.txt"
                $GetWindowsPackage = Get-WindowsPackage -Path "$MountDirectory"
                $GetWindowsPackage | Out-File "$Info\WindowsPackage.txt"
                $GetWindowsPackage | Out-File "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsPackage.txt"
                $GetWindowsPackage | Export-Clixml -Path "$Info\xml\Get-WindowsPackage.xml"
                $GetWindowsPackage | Export-Clixml -Path "$Info\xml\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsPackage.xml"
                $GetWindowsPackage | ConvertTo-Json | Out-File "$Info\json\Get-WindowsPackage.json"
                $GetWindowsPackage | ConvertTo-Json | Out-File "$Info\json\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsPackage.json"
                #=================================================
                Write-Verbose '19.1.1 WinPE Dismount and Save'
                #=================================================
                Write-Host '========================================================================================' -ForegroundColor DarkGray
                Write-Host "WinPE: Dismount and Save" -ForegroundColor Green
                if ($PauseDismount.IsPresent){[void](Read-Host 'Press Enter to Continue')}
                Dismount-WindowsImage -Path "$MountDirectory" -Save -LogPath "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Dismount-WindowsImage.log" | Out-Null
                #=================================================
                Write-Verbose '19.1.1 Export WinPE'
                #=================================================
                Write-Host '========================================================================================' -ForegroundColor DarkGray
                Write-Host "Export Boot.wim to $OS\sources\boot.wim" -ForegroundColor Green
                Export-WindowsImage -SourceImagePath "$WimTemp\boot.wim" -SourceIndex 1 -DestinationImagePath "$OS\sources\boot.wim" -Setbootable -DestinationName "$TaskName" -LogPath "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Export-WindowsImage.log" | Out-Null
                
                if ($WinPEOutput -eq 'MDT') {
                    Export-WindowsImage -SourceImagePath "$WimTemp\boot.wim" -SourceIndex 1 -DestinationImagePath "$WorkingPath\LiteTouchPE_$OSArchitecture.wim" -Setbootable -DestinationName "$TaskName" -LogPath "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Export-WindowsImage.log" | Out-Null
                }
                if ($WinPEOutput -eq 'Recovery') {
                    Export-WindowsImage -SourceImagePath "$WimTemp\boot.wim" -SourceIndex 1 -DestinationImagePath "$WorkingPath\WinRE.wim" -Setbootable -DestinationName "$TaskName" -LogPath "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Export-WindowsImage.log" | Out-Null
                }
                if ($WinPEOutput -eq 'WinPE') {
                    Export-WindowsImage -SourceImagePath "$WimTemp\boot.wim" -SourceIndex 1 -DestinationImagePath "$WorkingPath\WinPE.wim" -Setbootable -DestinationName "$TaskName" -LogPath "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Export-WindowsImage.log" | Out-Null
                }
                #=================================================
                Write-Verbose '19.1.1 Export Boot.wim Configuration'
                #=================================================
                Write-Host '========================================================================================' -ForegroundColor DarkGray
                Write-Host "Export Boot.wim Configuration to $WorkingPath\WindowsImage.txt" -ForegroundColor Green
                $GetWindowsImage = @()
                $GetWindowsImage = Get-WindowsImage -ImagePath "$OS\sources\boot.wim" -Index 1 | Select-Object -Property *

                Write-Verbose "========== SPBuild: $($GetWindowsImage.Build).$($GetWindowsImage.SPBuild)"
                if ($OSVersion -like "6.1*") {
                    Write-Verbose '========== Windows 6.1'
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

                #=================================================
                #    OSD-Export
                #=================================================
                Save-WindowsImageContentPE
                Save-VariablesOSD

                #=================================================
                Write-Verbose '19.1.1 Remove Temporary Files'
                #=================================================
                if (Test-Path "$WimTemp") {Remove-Item -Path "$WimTemp" -Force -Recurse | Out-Null}
                if (Test-Path "$MountDirectory") {Remove-Item -Path "$MountDirectory" -Force -Recurse | Out-Null}
                
                #=================================================
                Write-Verbose '19.1.1 New-OSDBuilderISO'
                #=================================================
                if ($CreateISO.IsPresent) {
                    Write-Host '========================================================================================' -ForegroundColor DarkGray
                    New-OSDBuilderISO -FullName "$WorkingPath"
                }
                
                #=================================================
                Write-Verbose '19.1.1 Show-OSDBuilderInfo'
                #=================================================
                if ($OSDInfo.IsPresent) {
                    Write-Host '========================================================================================' -ForegroundColor DarkGray
                    Show-OSDBuilderInfo -FullName $WorkingPath
                }

                #=================================================
                Write-Verbose '19.1.1 Stop Transcript'
                #=================================================
                Write-Host '========================================================================================' -ForegroundColor DarkGray
                Stop-Transcript
            }
        }
    }

    END {
        #Write-Host '========================================================================================' -ForegroundColor DarkGray
        #Write-Host -ForegroundColor Green "$($MyInvocation.MyCommand.Name) END"
    }
}