<#
.SYNOPSIS
Creates a new PEBuild from an PEBuild Task

.DESCRIPTION
Creates a new PEBuild from an PEBuild Task created with New-PEBuildTask

.LINK
http://osdbuilder.com/docs/functions/pebuild/new-pebuild

.PARAMETER Execute
Creates the PEBuild

.PARAMETER OSDISO
Creates an ISO
New-OSDBuilderISO -FullName $FullName

.PARAMETER WaitMount
Adds a 'Press Enter to Continue' prompt after WinPE is mounted

.PARAMETER WaitDismount
Adds a 'Press Enter to Continue' prompt before WinPE is dismounted
#>
function New-PEBuild {
    [CmdletBinding(DefaultParameterSetName='Basic')]
    PARAM (
        #==========================================================
        [switch]$Execute,
        [switch]$OSDISO,
        #==========================================================
        [Parameter(ParameterSetName='Advanced')]
        [switch]$WaitDismount,
        [Parameter(ParameterSetName='Advanced')]
        [switch]$WaitMount
        #==========================================================
    )

    BEGIN {
        #Write-Host '========================================================================================' -ForegroundColor DarkGray
        #Write-Host -ForegroundColor Green "$($MyInvocation.MyCommand.Name) BEGIN"

        #===================================================================================================
        Write-Verbose '19.1.1 Validate Administrator Rights'
        #===================================================================================================
        if (!([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
            Write-Warning 'OSDBuilder: This function needs to be run as Administrator'
            Pause
			Exit
        }

        #===================================================================================================
        Write-Verbose '19.1.1 Initialize OSDBuilder'
        #===================================================================================================
        Get-OSDBuilder -CreatePaths -HideDetails

#===================================================================================================
Write-Verbose 'MDT Files'
#===================================================================================================
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

    PROCESS {
        Write-Host '========================================================================================' -ForegroundColor DarkGray
        Write-Host -ForegroundColor Green "$($MyInvocation.MyCommand.Name) PROCESS"
    
        #===================================================================================================
        Write-Verbose '19.1.1 Select Task'
        #===================================================================================================
        $PEBuildTask = @()
        #$PEBuildTask = Get-ChildItem -Path $OSDBuilderTasks *.json -File | Select-Object -Property BaseName, FullName, Length, CreationTime, LastWriteTime | Sort-Object -Property BaseName
        #$PEBuildTask = $PEBuildTask | Where-Object {$_.BaseName -like "MDT*" -or $_.BaseName -like "Recovery*" -or $_.BaseName -like "WinPE*"}
        #$PEBuildTask = $PEBuildTask | Out-GridView -Title "OSDBuilder Tasks: Select one or more Tasks to execute and press OK (Cancel to Exit)" -Passthru
        $PEBuildTask = Get-PEBuildTask | Out-GridView -PassThru -Title "PEBuild Tasks: Select one or more Tasks to execute and press OK (Cancel to Exit)"

        if($null -eq $PEBuildTask) {
            Write-Warning "PEBuild Task was not selected or found . . . Exiting!"
            Return
        }

        foreach ($Item in $PEBuildTask) {
            #===================================================================================================
            Write-Verbose '19.1.1 PEBuild Task Contents'
            #===================================================================================================
            $Task = Get-Content "$($Item.FullName)" | ConvertFrom-Json
            $TaskType = $($Task.TaskType)
            $TaskName = $($Task.TaskName)
            $TaskVersion = $($Task.TaskVersion)

            $WinPEOutput = $($Task.WinPEOutput)
            $CustomName = $($Task.CustomName)

            $TaskOSMFamily = $($Task.OSMFamily)
            $TaskOSMGuid = $($Task.OSMGuid)
            $OSMediaName = $($Task.Name)
            $OSMediaPath = "$OSDBuilderOSMedia\$OSMediaName"

            $WinPEAutoExtraFiles = $($Task.WinPEAutoExtraFiles)

            $MDTDeploymentShare = $($Task.MDTDeploymentShare)
            $ScratchSpace = $($Task.ScratchSpace)
            $SourceWim = $($Task.SourceWim)
            $WinPEADK = $($Task.WinPEADK)
            $WinPEDaRT = $($Task.WinPEDaRT)
            $WinPEDrivers = $($Task.WinPEDrivers)
            $WinPEExtraFiles = $($Task.WinPEExtraFiles)
            $WinPEScripts = $($Task.WinPEScripts)

            #===================================================================================================
            Write-Verbose '19.1.1 PEBuild Task Information'
            #===================================================================================================
            Write-Host '========================================================================================' -ForegroundColor DarkGray
            Write-Host "PEBuild Task Information" -ForegroundColor Green
            Write-Host "-TaskName:                      $TaskName"
            Write-Host "-TaskVersion:                   $TaskVersion"
            Write-Host "-TaskType:                      $TaskType"
            #Write-Host "-OSMediaName:                   $OSMediaName"
            #Write-Host "-OSMediaPath:                   $OSMediaPath"
            Write-Host "-WinPE Output:                  $WinPEOutput"
            Write-Host "-Custom Name:                   $CustomName"
            Write-Host "-MDT Deployment Share:          $MDTDeploymentShare"
            Write-Host "-WinPE Auto ExtraFiles:         $WinPEAutoExtraFiles"
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

<#             #===================================================================================================
            Write-Verbose '19.1.1 Validate Proper TaskVersion'
            #===================================================================================================
            if ([System.Version]$TaskVersion -lt [System.Version]"18.10.10") {
                Write-Host '========================================================================================' -ForegroundColor DarkGray
                Write-Warning "PEBuild Tasks need to be version 18.10.10 or newer"
                Write-Warning "Recreate this Task using New-PEBuildTask"
                Return
            } #>

            #===================================================================================================
            Write-Verbose '19.1.1 Validate Proper TaskVersion'
            #===================================================================================================
            if ([System.Version]$TaskVersion -lt [System.Version]"19.1.4.0") {
                Write-Host '========================================================================================' -ForegroundColor DarkGray
                Write-Warning "PEBuild Tasks need to be version 19.1.4.0 or newer"
                Write-Warning "Recreate this Task using New-PEBuildTask or Repair-PEBuildTask"
                Return
            }
            
            #===================================================================================================
            Write-Verbose '19.3.22 Select Latest OSMedia'
            #===================================================================================================
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
            
            #===================================================================================================
            Write-Verbose '19.1.1 Set Proper Paths'
            #===================================================================================================
            $OSSourcePath = $OSMediaPath
            $OSImagePath = "$OSSourcePath\OS\sources\install.wim"

            #===================================================================================================
            Write-Verbose '19.1.1 Get Windows Image Information'
            #===================================================================================================
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

            #===================================================================================================
            Write-Verbose '19.1.1 Source OSMedia Windows Image Information'
            #===================================================================================================
            Write-Host '========================================================================================' -ForegroundColor DarkGray
            Write-Host "Source OSMedia Windows Image Information" -ForegroundColor Green
            Write-Host "-Source Path:                   $OSSourcePath"
            Write-Host "-Image File:                    $OSImagePath"
            Write-Host "-Image Index:                   $OSImageIndex"
            Write-Host "-Name:                          $OSImageName"
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

            #===================================================================================================
            Write-Verbose '19.1.1 Set DestionationName'
            #===================================================================================================
            if ($WinPEOutput -eq 'Recovery') {
                $DestinationName = "Microsoft Windows Recovery Environment ($OSArchitecture)"
            } else {
                $DestinationName = "Microsoft Windows PE ($OSArchitecture)"
            }
            Write-Host "-Destination Name:              $DestinationName"

            #===================================================================================================
            Write-Verbose '19.1.1 Validate Registry CurrentVersion.xml'
            #===================================================================================================
            if (Test-Path "$OSSourcePath\info\xml\CurrentVersion.xml") {
                $RegCurrentVersion = Import-Clixml -Path "$OSSourcePath\info\xml\CurrentVersion.xml"
                $ReleaseId = $($RegCurrentVersion.ReleaseId)
                if ($ReleaseId -gt 1903) {
                    Write-Host '========================================================================================' -ForegroundColor DarkGray
                    Write-Warning "OSDBuilder does not currently support this version of Windows ... Check for an updated version"
                }
            }

            #===================================================================================================
            Write-Verbose '19.1.1 Set ReleaseId'
            #===================================================================================================
            if ($null -eq $ReleaseId) {
                if ($OSBuild -eq 7601) {$ReleaseId = 7601}
                if ($OSBuild -eq 10240) {$ReleaseId = 1507}
                if ($OSBuild -eq 14393) {$ReleaseId = 1607}
                if ($OSBuild -eq 15063) {$ReleaseId = 1703}
                if ($OSBuild -eq 16299) {$ReleaseId = 1709}
                if ($OSBuild -eq 17134) {$ReleaseId = 1803}
                if ($OSBuild -eq 17763) {$ReleaseId = 1809}
                if ($OSBuild -eq 18362) {$ReleaseId = 1903}
            }

            #===================================================================================================
            Write-Verbose '19.1.1 Set Working Path'
            #===================================================================================================
            #$BuildName = "build$((Get-Date).ToString('mmss'))"
            $WorkingPath = "$OSDBuilderPEBuilds\$Taskname $($LatestOSMedia.UBR)"
            if ($CustomName) {
                $WorkingPath = "$OSDBuilderPEBuilds\$CustomName"
            }

            #===================================================================================================
            Write-Verbose '19.1.1 Validate DeploymentShare'
            #===================================================================================================
            if ($MDTDeploymentShare) {
                if (!(Test-Path "$MDTDeploymentShare")) {
                    Write-Warning "MDT Deployment Share not found ... Exiting!"
                    Return
                }
            }

            #===================================================================================================
            Write-Verbose '19.1.1 Execute'
            #===================================================================================================
            if ($Execute.IsPresent) {

                #===================================================================================================
                Write-Verbose '19.1.1 Remove Existing OSMedia'
                #===================================================================================================
                if (Test-Path $WorkingPath) {
                    Write-Host '========================================================================================' -ForegroundColor DarkGray
                    Write-Warning "$WorkingPath exists.  Contents will be replaced"
                    Remove-Item -Path "$WorkingPath\*" -Force -Recurse | Out-Null
                }

                #===================================================================================================
                Write-Verbose '19.3.21 Set Working Directories'
                #===================================================================================================
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
                #===================================================================================================
                Write-Verbose '19.1.1 Set WimTemp'
                #===================================================================================================
                $WimTemp = Join-Path $WorkingPath "WimTemp"
                if (!(Test-Path "$WimTemp")) {New-Item "$WimTemp" -ItemType Directory -Force | Out-Null}

                $WorkingWim = "$WorkingPath\WimTemp\boot.wim"

                #===================================================================================================
                Write-Verbose '19.1.1 Start Transcript'
                #===================================================================================================
                Write-Host '========================================================================================' -ForegroundColor DarkGray
                $ScriptName = $($MyInvocation.MyCommand.Name)
                $LogName = "$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-$ScriptName.log"
                Start-Transcript -Path (Join-Path "$Info\logs" $LogName)

                #===================================================================================================
                Write-Verbose '19.1.1 WinPE Information'
                #===================================================================================================
                Write-Host '========================================================================================' -ForegroundColor DarkGray
                Write-Host "WinPE Information" -ForegroundColor Green
                Write-Host "-WorkingName:   $TaskName" -ForegroundColor Yellow
                Write-Host "-WorkingPath:   $WorkingPath" -ForegroundColor Yellow
                Write-Host "-OS:            $OS"
                Write-Host "-Info:          $Info"
                Write-Host "-Logs:          $Info\logs"

                #===================================================================================================
                Write-Verbose '19.1.1 Create Mount Directories'
                #===================================================================================================
                $MountDirectory = Join-Path $OSDBuilderContent\Mount "pebuild$((Get-Date).ToString('mmss'))"
                if ( ! (Test-Path "$MountDirectory")) {New-Item "$MountDirectory" -ItemType Directory -Force | Out-Null}

                #===================================================================================================
                Write-Verbose '19.1.1 Copy OS'
                #===================================================================================================
                Write-Host '========================================================================================' -ForegroundColor DarkGray
                Write-Host "Copying $OSSourcePath\OS to $OS" -ForegroundColor Green
                Copy-Item -Path "$OSSourcePath\OS\bootmgr" -Destination "$OS\bootmgr" -Force | Out-Null
                Copy-Item -Path "$OSSourcePath\OS\bootmgr.efi" -Destination "$OS\bootmgr.efi" -Force | Out-Null
                Copy-Item -Path "$OSSourcePath\OS\boot\" -Destination "$OS\boot\" -Recurse -Force | Out-Null
                Copy-Item -Path "$OSSourcePath\OS\efi\" -Destination "$OS\efi\" -Recurse -Force | Out-Null
                Dism /Export-Image /SourceImageFile:"$OSSourcePath\WinPE\$SourceWim.wim" /SourceIndex:1 /DestinationImageFile:"$WorkingWim" /DestinationName:"$DestinationName" /Bootable /CheckIntegrity
                #Copy-Item -Path "$OSSourcePath\WinPE\$SourceWim.wim" -Destination "$WorkingWim" -Force | Out-Null
                if (!(Test-Path "$Sources")) {New-Item "$Sources" -ItemType Directory -Force | Out-Null}
                
                #===================================================================================================
                Write-Verbose '19.1.1 WinPE: Mount'
                #===================================================================================================
                Write-Host '========================================================================================' -ForegroundColor DarkGray
                Write-Host "WinPE: Mount WinPE WIM" -ForegroundColor Green
                Mount-WindowsImage -ImagePath "$WorkingWim" -Index 1 -Path "$MountDirectory" -LogPath "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Mount-WindowsImage.log"
                if ($WaitMount.IsPresent){[void](Read-Host 'Press Enter to Continue')}
                
                #===================================================================================================
                Write-Verbose '19.1.1 Get Registry and UBR'
                #===================================================================================================
                reg LOAD 'HKLM\OSMedia' "$MountDirectory\Windows\System32\Config\SOFTWARE"
                $RegCurrentVersion = Get-ItemProperty -Path 'HKLM:\OSMedia\Microsoft\Windows NT\CurrentVersion'
                reg UNLOAD 'HKLM\OSMedia'

                $ReleaseId = $null
                $ReleaseId = $($RegCurrentVersion.ReleaseId)
                $RegCurrentVersionUBR = $($RegCurrentVersion.UBR)
                $UBR = "$OSBuild.$RegCurrentVersionUBR"

                $RegCurrentVersion | Out-File "$Info\CurrentVersion.txt"
                $RegCurrentVersion | Out-File "$WorkingPath\CurrentVersion.txt"
                $RegCurrentVersion | Out-File "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-CurrentVersion.txt"
                $RegCurrentVersion | Export-Clixml -Path "$Info\xml\CurrentVersion.xml"
                $RegCurrentVersion | Export-Clixml -Path "$Info\xml\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-CurrentVersion.xml"
                $RegCurrentVersion | ConvertTo-Json | Out-File "$Info\json\CurrentVersion.json"
                $RegCurrentVersion | ConvertTo-Json | Out-File "$Info\json\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-CurrentVersion.json"
                
                #===================================================================================================
                Write-Verbose '19.1.1 Set-ScratchSpace'
                #===================================================================================================
                Write-Host '========================================================================================' -ForegroundColor DarkGray
                Write-Host "WinPE: Set-ScratchSpace" -ForegroundColor Green
                Dism /Image:"$MountDirectory" /Set-ScratchSpace:$ScratchSpace
                
                #===================================================================================================
                Write-Verbose '19.1.1 Set-TargetPath'
                #===================================================================================================
                Write-Host '========================================================================================' -ForegroundColor DarkGray
                Write-Host "WinPE: Set-TargetPath" -ForegroundColor Green
                Dism /Image:"$MountDirectory" /Set-TargetPath:"X:\"
                
                #===================================================================================================
                Write-Verbose '19.1.1 WinPE: ADK Optional Components'
                #===================================================================================================
                Write-Host '========================================================================================' -ForegroundColor DarkGray
                Write-Host "WinPE: ADK Optional Components" -ForegroundColor Green
                if ([string]::IsNullOrEmpty($WinPEADK) -or [string]::IsNullOrWhiteSpace($WinPEADK)) {
                    # Do Nothing
                } else {
                    foreach ($PackagePath in $WinPEADK) {
                        if ($PackagePath -like "*NetFx*") {
                            Write-Host "$OSDBuilderContent\$PackagePath" -ForegroundColor Green
                            Add-WindowsPackage -PackagePath "$OSDBuilderContent\$PackagePath" -Path "$MountDirectory" -LogPath "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Add-WindowsPackage.log" | Out-Null
                        }
                    }
                    $WinPEADK = $WinPEADK | Where-Object {$_ -notlike "*NetFx*"}
                    foreach ($PackagePath in $WinPEADK) {
                        if ($PackagePath -like "*WinPE-PowerShell*") {
                            Write-Host "$OSDBuilderContent\$PackagePath" -ForegroundColor Green
                            Add-WindowsPackage -PackagePath "$OSDBuilderContent\$PackagePath" -Path "$MountDirectory" -LogPath "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Add-WindowsPackage.log" | Out-Null
                        }
                    }
                    $WinPEADK = $WinPEADK | Where-Object {$_ -notlike "*PowerShell*"}
                    foreach ($PackagePath in $WinPEADK) {
                        Write-Host "$OSDBuilderContent\$PackagePath" -ForegroundColor Green
                        Add-WindowsPackage -PackagePath "$OSDBuilderContent\$PackagePath" -Path "$MountDirectory" -LogPath "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Add-WindowsPackage.log" | Out-Null
                    }
                }

                #===================================================================================================
                Write-Verbose '19.1.1 WinPE: WinPE DaRT'
                #===================================================================================================
                Write-Host '========================================================================================' -ForegroundColor DarkGray
                Write-Host "WinPE: Microsoft DaRT" -ForegroundColor Green
                if ($WinPEDaRT) {
                    if ([string]::IsNullOrEmpty($WinPEDaRT) -or [string]::IsNullOrWhiteSpace($WinPEDaRT)) {Write-Warning "Skipping WinPE DaRT"}
                    elseif (Test-Path "$OSDBuilderContent\$WinPEDaRT") {
                        #===================================================================================================
                        if (Test-Path $(Join-Path $(Split-Path "$OSDBuilderContent\$WinPEDart") 'DartConfig.dat')) {
                            Write-Host "$OSDBuilderContent\$WinPEDaRT"
                            expand.exe "$OSDBuilderContent\$WinPEDaRT" -F:*.* "$MountDirectory"
                            #if (Test-Path "$MountDirectory\Windows\System32\winpeshl.ini") {Remove-Item -Path "$MountDirectory\Windows\System32\winpeshl.ini" -Force}
                            #===================================================================================================
                            Write-Host "Copying DartConfig.dat to $MountDirectory\Windows\System32\DartConfig.dat"
                            Copy-Item -Path $(Join-Path $(Split-Path "$OSDBuilderContent\$WinPEDart") 'DartConfig.dat') -Destination "$MountDirectory\Windows\System32\DartConfig.dat" -Force | Out-Null
                            #===================================================================================================
                        } elseif (Test-Path $(Join-Path $(Split-Path $WinPEDart) 'DartConfig8.dat')) {
                            Write-Host "$OSDBuilderContent\$WinPEDaRT"
                            expand.exe "$OSDBuilderContent\$WinPEDaRT" -F:*.* "$MountDirectory"
                            #if (Test-Path "$MountDirectory\Windows\System32\winpeshl.ini") {Remove-Item -Path "$MountDirectory\Windows\System32\winpeshl.ini" -Force}
                            #===================================================================================================
                            Write-Host "Copying DartConfig8.dat to $MountDirectory\Windows\System32\DartConfig.dat"
                            Copy-Item -Path $(Join-Path $(Split-Path "$OSDBuilderContent\$WinPEDart") 'DartConfig8.dat') -Destination "$MountDirectory\Windows\System32\DartConfig.dat" -Force | Out-Null
                            #===================================================================================================
                        }
                        #===================================================================================================
                        Write-Verbose '19.1.1 WinPE Edit winpeshl.ini'
                        #===================================================================================================
                        if ($WinPEOutput -eq 'Recovery') {
                            Write-Host '========================================================================================' -ForegroundColor DarkGray
                            Write-Host "WinPE: Edit winpeshl.ini" -ForegroundColor Green
                            if (Test-Path "$MountDirectory\Windows\System32\winpeshl.ini") {
                                Remove-Item -Path "$MountDirectory\Windows\System32\winpeshl.ini" -Force | Out-Null
                            }
                            $DaRTwinpeshl | Out-File "$MountDirectory\Windows\System32\winpeshl.ini" -Force
                        }
                        #===================================================================================================
                    } else {Write-Warning "WinPE DaRT do not exist in $OSDBuilderContent\$WinPEDart"}
                }
                #===================================================================================================
                Write-Verbose '19.1.1 WinPE Remove winpeshl.ini'
                #===================================================================================================
                if ($WinPEOutput -ne 'Recovery') {
                    Write-Host '========================================================================================' -ForegroundColor DarkGray
                    Write-Host "WinPE: Remove winpeshl.ini" -ForegroundColor Green
                    if (Test-Path "$MountDirectory\Windows\System32\winpeshl.ini") {
                        Remove-Item -Path "$MountDirectory\Windows\System32\winpeshl.ini" -Force | Out-Null
                    }
                }
                
                #===================================================================================================
                Write-Verbose '19.1.1 Copy MDT'
                #===================================================================================================
                if ($MDTDeploymentShare) {
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
                
                #===================================================================================================
                Write-Verbose '19.1.1 WinPE: Auto Extra Files'
                #===================================================================================================
                if ($WinPEAutoExtraFiles -eq $true) {
                    Write-Host '========================================================================================' -ForegroundColor DarkGray
                    Write-Host "WinPE: Auto ExtraFiles" -ForegroundColor Green
                    robocopy "$OSSourcePath\WinPE\AutoExtraFiles" "$MountDirectory" *.* /e /ndl /xf bcp47*.dll /xx /b /np /ts /tee /r:0 /w:0 /Log+:"$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-AutoExtraFiles.log" | Out-Null
                }
                
                #===================================================================================================
                Write-Verbose '19.1.1 WinPE: Extra Files'
                #===================================================================================================
                Write-Host '========================================================================================' -ForegroundColor DarkGray
                Write-Host "WinPE: Extra Files" -ForegroundColor Green
                foreach ($ExtraFile in $WinPEExtraFiles) {robocopy "$OSDBuilderContent\$ExtraFile" "$MountDirectory" *.* /e /ndl /xx /b /np /ts /tee /r:0 /w:0 /Log+:"$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-ExtraFiles.log" | Out-Null}
                
                #===================================================================================================
                Write-Verbose '19.1.1 WinPE: Drivers'
                #===================================================================================================
                Write-Host '========================================================================================' -ForegroundColor DarkGray
                Write-Host "WinPE: Drivers" -ForegroundColor Green
                foreach ($WinPEDriver in $WinPEDrivers) {
                    Write-Host "$OSDBuilderContent\$WinPEDriver" -ForegroundColor Green
                    Add-WindowsDriver -Path "$MountDirectory" -Driver "$OSDBuilderContent\$WinPEDriver" -Recurse -ForceUnsigned -LogPath "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Add-WindowsDriver.log" | Out-Null
                }

                #===================================================================================================
                Write-Verbose '19.1.1 WinPE: PowerShell Scripts'
                #===================================================================================================
                Write-Host '========================================================================================' -ForegroundColor DarkGray
                Write-Host "WinPE: PowerShell Scripts" -ForegroundColor Green
                foreach ($PSWimScript in $WinPEScripts) {
                    if (Test-Path "$OSDBuilderContent\$PSWimScript") {
                        Write-Host "$OSDBuilderContent\$PSWimScript" -ForegroundColor Green
                        Invoke-Expression "& '$OSDBuilderContent\$PSWimScript'"
                    }
                }

                #===================================================================================================
                Write-Verbose '19.1.1 WinPE Mounted Package Inventory'
                #===================================================================================================
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
                
                #===================================================================================================
                Write-Verbose '19.1.1 WinPE Dismount and Save'
                #===================================================================================================
                Write-Host '========================================================================================' -ForegroundColor DarkGray
                Write-Host "WinPE: Dismount and Save" -ForegroundColor Green
                if ($WaitDismount.IsPresent){[void](Read-Host 'Press Enter to Continue')}
                Dismount-WindowsImage -Path "$MountDirectory" -Save -LogPath "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Dismount-WindowsImage.log" | Out-Null
                
                #===================================================================================================
                Write-Verbose '19.1.1 Export WinPE'
                #===================================================================================================
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
                
                #===================================================================================================
                Write-Verbose '19.1.1 Export Boot.wim Configuration'
                #===================================================================================================
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

                #===================================================================================================
                #    OSD-Export
                #===================================================================================================
                Save-OSDWindowsImageContentPE
                Save-OSDVariables

                #===================================================================================================
                Write-Verbose '19.1.1 Remove Temporary Files'
                #===================================================================================================
                if (Test-Path "$WimTemp") {Remove-Item -Path "$WimTemp" -Force -Recurse | Out-Null}
                if (Test-Path "$MountDirectory") {Remove-Item -Path "$MountDirectory" -Force -Recurse | Out-Null}
                
                #===================================================================================================
                Write-Verbose '19.1.1 New-OSDBuilderISO'
                #===================================================================================================
                if ($OSDISO.IsPresent) {
                    Write-Host '========================================================================================' -ForegroundColor DarkGray
                    New-OSDBuilderISO -FullName "$WorkingPath"
                }
                
                #===================================================================================================
                Write-Verbose '19.1.1 Show-OSDBuilderInfo'
                #===================================================================================================
                if ($OSDInfo.IsPresent) {
                    Write-Host '========================================================================================' -ForegroundColor DarkGray
                    Show-OSDBuilderInfo -FullName $WorkingPath
                }

                #===================================================================================================
                Write-Verbose '19.1.1 Stop Transcript'
                #===================================================================================================
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