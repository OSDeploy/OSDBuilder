<#
.SYNOPSIS
Returns all Operating Systems in OSDBuilder\OSBuilds

.DESCRIPTION
Returns all Operating Systems in OSDBuilder\OSBuilds as a PowerShell Custom Object

.LINK
https://osdbuilder.osdeploy.com/module/functions/osbuild/get-osbuilds

.PARAMETER GridView
Displays results in PowerShell ISE GridView with an added PassThru Parameter.  This can also be displayed with the following command
Get-OSBuilds | Out-GridView
#>
function Get-OSBuilds {
    [CmdletBinding()]
    PARAM (
        #===================================================================================================
        #   Basic
        #===================================================================================================
        [switch]$GridView
        #===================================================================================================
    )

    BEGIN {
        #===================================================================================================
        #   Initialize OSDBuilder
        #===================================================================================================
        Get-OSDBuilder -CreatePaths -HideDetails
        #===================================================================================================
        #   Get OSDUpdates
        #===================================================================================================
        $OSDUpdates = @()
        $OSDUpdates = Get-OSDUpdates
        #===================================================================================================
        #   Get OSBuilds
        #===================================================================================================
        $AllOSBuilds = @()
        $AllOSBuilds = Get-ChildItem -Path "$OSDBuilderOSBuilds" -Directory | Select-Object -Property * | `
        Where-Object {Test-Path $(Join-Path $_.FullName "info\xml\Get-WindowsImage.xml")}
        #===================================================================================================
    }

    PROCESS {
        $OSBuilds = foreach ($Item in $AllOSBuilds) {
            #===================================================================================================
            #   Get Windows Image Information
            #===================================================================================================
            $OSBuildPath = $($Item.FullName)
            Write-Verbose "OSBuild Full Path: $OSBuildPath"
            
            $OSMWindowsImage = @()
            $OSMWindowsImage = Import-Clixml -Path "$OSBuildPath\info\xml\Get-WindowsImage.xml"
            $OSMImageName = $($OSMWindowsImage.ImageName)
            Write-Verbose "ImageName: $OSMImageName"

            $OSMArch = $OSMWindowsImage.Architecture
            if ($OSMArch -eq '0') {$OSMArch = 'x86'}
            if ($OSMArch -eq '6') {$OSMArch = 'ia64'}
            if ($OSMArch -eq '9') {$OSMArch = 'x64'}
            if ($OSMArch -eq '12') {$OSMArch = 'x64 ARM'}
            Write-Verbose "Arch: $OSMArch"

            $OSMEditionId = $($OSMWindowsImage.EditionId)
            Write-Verbose "EditionId: $OSMEditionId"

            $OSMInstallationType = $($OSMWindowsImage.InstallationType)
            Write-Verbose "InstallationType: $OSMInstallationType"
            #===================================================================================================
            #   Version Information
            #===================================================================================================
            $OSMVersion = $($OSMWindowsImage.Version)
            Write-Verbose "Version: $OSMVersion"

            $OSMMajorVersion = $($OSMWindowsImage.MajorVersion)
            Write-Verbose "MajorVersion: $OSMMajorVersion"

            $OSMMinorVersion = $($OSMWindowsImage.MinorVersion)
            Write-Verbose "MinorVersion: $OSMMinorVersion"

            $OSMBuild = $($OSMWindowsImage.Build)
            Write-Verbose "Build: $OSMBuild"

            $OSMUBR = $($OSMWindowsImage.UBR)
            Write-Verbose "UBR: $OSMUBR"
            #===================================================================================================
            #   UpdateOS
            #===================================================================================================
            $UpdateOS = ''
            if ($OSMMajorVersion -eq 10) {
                if ($OSMInstallationType -notlike "*Server*") {$UpdateOS = 'Windows 10'}
                elseif ($OSMBuild -ge 17763) {$UpdateOS = 'Windows Server 2019'}
                else {$UpdateOS = 'Windows Server 2016'}
            } elseif ($OSMMajorVersion -eq 6) {
                if ($OSMInstallationType -like "*Server*") {
                    if ($OSMVersion -like "6.3*") {$UpdateOS = 'Windows Server 2012 R2'}
                    elseif ($OSMVersion -like "6.2*") {$UpdateOS = 'Windows Server 2012'}
                    elseif ($OSMVersion -like "6.1*") {$UpdateOS = 'Windows Server 2008 R2'}
                    else {Write-Warning "This Operating System is not supported"}
                } else {
                    if ($OSMVersion -like "6.3*") {$UpdateOS = 'Windows 8.1'}
                    elseif ($OSMVersion -like "6.2*") {$UpdateOS = 'Windows 8'}
                    elseif ($OSMVersion -like "6.1*") {$UpdateOS = 'Windows 7'}
                    else {Write-Warning "This Operating System is not supported"}
                }
            }
            Write-Verbose "UpdateOS: $UpdateOS"
            #===================================================================================================
            #   Language
            #===================================================================================================
            $OSMLanguages = $($OSMWindowsImage.Languages)
            Write-Verbose "Languages: $OSMLanguages"
            #===================================================================================================
            #   OSMFamily
            #===================================================================================================
            $OSMFamilyV1 = $(Get-Date -Date $($OSMWindowsImage.CreatedTime)).ToString("yyyyMMddHHmmss") + $OSMEditionID
            $OSMFamily = $OSMInstallationType + " " + $OSMEditionId + " " + $OSMArch + " " + [string]$OSMBuild + " " + $OSMLanguages
            Write-Verbose "OSMFamily: $OSMFamily"
            #===================================================================================================
            #   Registry ReleaseId
            #===================================================================================================
            $OSMRegistry = @()
            if (Test-Path "$OSBuildPath\info\xml\CurrentVersion.xml") {
                Write-Verbose "Registry: $OSBuildPath\info\xml\CurrentVersion.xml"
                $OSMRegistry = Import-Clixml -Path "$OSBuildPath\info\xml\CurrentVersion.xml"
            } else {
                Write-Verbose "Registry: $OSBuildPath\info\xml\CurrentVersion.xml (Not Found)"
            }
            [string]$OSMReleaseId = $($OSMRegistry.ReleaseId)

            if ($OSMBuild -eq 7600) {$OSMReleaseId = 7600}
            if ($OSMBuild -eq 7601) {$OSMReleaseId = 7601}
            if ($OSMBuild -eq 9600) {$OSMReleaseId = 9600}
            if ($OSMBuild -eq 10240) {$OSMReleaseId = 1507}
            if ($OSMBuild -eq 14393) {$OSMReleaseId = 1607}
            if ($OSMBuild -eq 15063) {$OSMReleaseId = 1703}
            if ($OSMBuild -eq 16299) {$OSMReleaseId = 1709}
            if ($OSMBuild -eq 17134) {$OSMReleaseId = 1803}
            if ($OSMBuild -eq 17763) {$OSMReleaseId = 1809}
            if ($OSMBuild -eq 18362) {$OSMReleaseId = 1903}

            Write-Verbose "ReleaseId: $OSMReleaseId"
            #===================================================================================================
            #   Get-WindowsPackage
            #===================================================================================================
            $OSMPackage = @()
            if (Test-Path "$OSBuildPath\info\xml\Get-WindowsPackage.xml") {
                Write-Verbose "Packages: $OSBuildPath\info\xml\Get-WindowsPackage.xml"
                $OSMPackage = Import-Clixml -Path "$OSBuildPath\info\xml\Get-WindowsPackage.xml"
            } else {
                Write-Verbose "Packages: $OSBuildPath\info\xml\Get-WindowsPackage.xml (Not Found)"
            }
            #===================================================================================================
            #   Sessions.xml
            #===================================================================================================
            $OSMSessions = @()
            if (Test-Path "$OSBuildPath\Sessions.xml") {
                Export-SessionsXmlOS -OSMediaPath "$OSBuildPath"
            }

            if (Test-Path "$OSBuildPath\info\xml\Sessions.xml") {
                $OSMSessions = Import-Clixml -Path "$OSBuildPath\info\xml\Sessions.xml" | Where-Object {$_.targetState -eq 'Installed'} | Sort-Object id
            } else {
                Write-Verbose "Sessions: $OSBuildPath\info\xml\Sessions.xml (Not Found)"
            }
            #===================================================================================================
            #   Verify Updates
            #===================================================================================================
            $VerifyUpdates = @()
            $VerifyUpdates = $OSDUpdates | Sort-Object -Property CreationDate | `
            Where-Object {$_.UpdateOS -like "*$UpdateOS*"} | Where-Object {$_.UpdateBuild -like "*$OSMReleaseId*"} | `
            Where-Object {$_.UpdateArch -like "*$($OSMArch)*"} | Where-Object {$_.UpdateGroup -notlike "*Setup*"} | `
            Where-Object {$_.UpdateGroup -ne ''} | Where-Object {$_.UpdateGroup -ne 'Optional'}

            $OSMUpdateStatus = 'OK'
            foreach ($OSMUpdate in $VerifyUpdates) {
                if ($OSMSessions | Where-Object {$_.KBNumber -like "*$($OSMUpdate.KBNumber)*"}) {
                    Write-Verbose "Installed: $($OSMUpdate.Title)"
                } else {
                    Write-Verbose "Not Installed: $($OSMUpdate.Title)"
                    $OSMUpdateStatus = 'Update'
                }
            }
            #===================================================================================================
            #   Correct WinSE
            #===================================================================================================
            if (Test-Path "$OSBuildPath\WinPE\setup.wim") {Rename-Item "$OSBuildPath\WinPE\setup.wim" 'winse.wim' -Force | Out-Null}

            if (Test-Path "$OSBuildPath\WinPE\info\boot.txt") {Rename-Item "$OSBuildPath\WinPE\info\boot.txt" 'Get-WindowsImage-Boot.txt' -Force | Out-Null}
            if (Test-Path "$OSBuildPath\WinPE\info\winpe.txt") {Rename-Item "$OSBuildPath\WinPE\info\winpe.txt" 'Get-WindowsImage-WinPE.txt' -Force | Out-Null}
            if (Test-Path "$OSBuildPath\WinPE\info\winre.txt") {Rename-Item "$OSBuildPath\WinPE\info\winre.txt" 'Get-WindowsImage-WinRE.txt' -Force | Out-Null}
            if (Test-Path "$OSBuildPath\WinPE\info\setup.txt") {Rename-Item "$OSBuildPath\WinPE\info\setup.txt" 'Get-WindowsImage-WinSE.txt' -Force | Out-Null}
            
            if (Test-Path "$OSBuildPath\WinPE\info\winpe-WindowsPackage.txt") {Rename-Item "$OSBuildPath\WinPE\info\winpe-WindowsPackage.txt" 'Get-WindowsPackage-WinPE.txt' -Force | Out-Null}
            if (Test-Path "$OSBuildPath\WinPE\info\winre-WindowsPackage.txt") {Rename-Item "$OSBuildPath\WinPE\info\winre-WindowsPackage.txt" 'Get-WindowsPackage-WinRE.txt' -Force | Out-Null}
            if (Test-Path "$OSBuildPath\WinPE\info\setup-WindowsPackage.txt") {Rename-Item "$OSBuildPath\WinPE\info\setup-WindowsPackage.txt" 'Get-WindowsPackage-WinSE.txt' -Force | Out-Null}

            if (Test-Path "$OSBuildPath\WinPE\info\json\Get-WindowsImage-boot.wim.json") {Rename-Item "$OSBuildPath\WinPE\info\json\Get-WindowsImage-boot.wim.json" 'Get-WindowsImage-Boot.json' -Force | Out-Null}
            if (Test-Path "$OSBuildPath\WinPE\info\json\Get-WindowsImage-winpe.wim.json") {Rename-Item "$OSBuildPath\WinPE\info\json\Get-WindowsImage-winpe.wim.json" 'Get-WindowsImage-WinPE.json' -Force | Out-Null}
            if (Test-Path "$OSBuildPath\WinPE\info\json\Get-WindowsImage-winre.wim.json") {Rename-Item "$OSBuildPath\WinPE\info\json\Get-WindowsImage-winre.wim.json" 'Get-WindowsImage-WinRE.json' -Force | Out-Null}
            if (Test-Path "$OSBuildPath\WinPE\info\json\Get-WindowsImage-setup.wim.json") {Rename-Item "$OSBuildPath\WinPE\info\json\Get-WindowsImage-setup.wim.json" 'Get-WindowsImage-WinSE.json' -Force | Out-Null}

            if (Test-Path "$OSBuildPath\WinPE\info\json\Get-WindowsPackage-boot.wim.json") {Rename-Item "$OSBuildPath\WinPE\info\json\Get-WindowsPackage-boot.wim.json" 'Get-WindowsPackage-Boot.json' -Force | Out-Null}
            if (Test-Path "$OSBuildPath\WinPE\info\json\Get-WindowsPackage-winpe.wim.json") {Rename-Item "$OSBuildPath\WinPE\info\json\Get-WindowsPackage-winpe.wim.json" 'Get-WindowsPackage-WinPE.json' -Force | Out-Null}
            if (Test-Path "$OSBuildPath\WinPE\info\json\Get-WindowsPackage-winre.wim.json") {Rename-Item "$OSBuildPath\WinPE\info\json\Get-WindowsPackage-winre.wim.json" 'Get-WindowsPackage-WinRE.json' -Force | Out-Null}
            if (Test-Path "$OSBuildPath\WinPE\info\json\Get-WindowsPackage-setup.wim.json") {Rename-Item "$OSBuildPath\WinPE\info\json\Get-WindowsPackage-setup.wim.json" 'Get-WindowsPackage-WinSE.json' -Force | Out-Null}
            
            if (Test-Path "$OSBuildPath\WinPE\info\xml\Get-WindowsImage-boot.wim.xml") {Rename-Item "$OSBuildPath\WinPE\info\xml\Get-WindowsImage-boot.wim.xml" 'Get-WindowsImage-Boot.xml' -Force | Out-Null}
            if (Test-Path "$OSBuildPath\WinPE\info\xml\Get-WindowsImage-winpe.wim.xml") {Rename-Item "$OSBuildPath\WinPE\info\xml\Get-WindowsImage-winpe.wim.xml" 'Get-WindowsImage-WinPE.xml' -Force | Out-Null}
            if (Test-Path "$OSBuildPath\WinPE\info\xml\Get-WindowsImage-winre.wim.xml") {Rename-Item "$OSBuildPath\WinPE\info\xml\Get-WindowsImage-winre.wim.xml" 'Get-WindowsImage-WinRE.xml' -Force | Out-Null}
            if (Test-Path "$OSBuildPath\WinPE\info\xml\Get-WindowsImage-setup.wim.xml") {Rename-Item "$OSBuildPath\WinPE\info\xml\Get-WindowsImage-setup.wim.xml" 'Get-WindowsImage-WinSE.xml' -Force | Out-Null}
            
            if (Test-Path "$OSBuildPath\WinPE\info\xml\Get-WindowsPackage-boot.wim.xml") {Rename-Item "$OSBuildPath\WinPE\info\xml\Get-WindowsPackage-boot.wim.xml" 'Get-WindowsPackage-Boot.xml' -Force | Out-Null}
            if (Test-Path "$OSBuildPath\WinPE\info\xml\Get-WindowsPackage-winpe.wim.xml") {Rename-Item "$OSBuildPath\WinPE\info\xml\Get-WindowsPackage-winpe.wim.xml" 'Get-WindowsPackage-WinPE.xml' -Force | Out-Null}
            if (Test-Path "$OSBuildPath\WinPE\info\xml\Get-WindowsPackage-winre.wim.xml") {Rename-Item "$OSBuildPath\WinPE\info\xml\Get-WindowsPackage-winre.wim.xml" 'Get-WindowsPackage-WinRE.xml' -Force | Out-Null}
            if (Test-Path "$OSBuildPath\WinPE\info\xml\Get-WindowsPackage-setup.wim.xml") {Rename-Item "$OSBuildPath\WinPE\info\xml\Get-WindowsPackage-setup.wim.xml" 'Get-WindowsPackage-WinSE.xml' -Force | Out-Null}
            #===================================================================================================
            #   Create Object
            #===================================================================================================
            $ObjectProperties = @{
                MediaType           = 'OSBuild'

                ModifiedTime        = [datetime]$OSMWindowsImage.ModifiedTime
                Name                = $Item.Name

                Updates             = $OSMUpdateStatus

                OSMFamily           = $OSMFamily
                ImageName           = $OSMImageName

                OperatingSystem     = $UpdateOS
                Arch                = $OSMArch
                ReleaseId           = $OSMReleaseId

                Version             = [version]$OSMVersion
                MajorVersion        = $OSMMajorVersion
                MinorVersion        = $OSMMinorVersion
                Build               = [string]$OSMBuild
                UBR                 = [version]$OSMUBR

                Languages           = $OSMWindowsImage.Languages

                EditionId           = $OSMEditionId
                InstallationType    = $OSMInstallationType
                Servicing           = $LatestSSU
                Cumulative          = $LatestLCU
                Adobe               = $LatestAdobe
                FullName            = $Item.FullName
                CreatedTime         = [datetime]$OSMWindowsImage.CreatedTime

                OSMFamilyV1         = $OSMFamilyV1
            }
            New-Object -TypeName PSObject -Property $ObjectProperties
            Write-Verbose ""
        }
        #===================================================================================================
        #   Results
        #===================================================================================================
        if ($GridView.IsPresent) {
            $OSBuilds | Select-Object MediaType,ModifiedTime,`
            Updates,`
            Name,OperatingSystem,Arch,ReleaseId,`
            Version,MajorVersion,MinorVersion,Build,UBR,`
            Languages,EditionId,InstallationType,`
            ImageName,OSMFamily,
            FullName,CreatedTime | `
            Sort-Object -Property Name | Out-GridView -PassThru -Title 'OSBuilds'
        } else {
            $OSBuilds | Select-Object MediaType,ModifiedTime,`
            Updates,`
            Name,OperatingSystem,Arch,ReleaseId,`
            Version,MajorVersion,MinorVersion,Build,UBR,`
            Languages,EditionId,InstallationType,`
            ImageName,OSMFamily,
            FullName,CreatedTime | `
            Sort-Object -Property Name
        }
        #===================================================================================================
    }

    END {}
}
