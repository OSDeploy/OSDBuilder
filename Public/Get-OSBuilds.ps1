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
    Param (
        [switch]$GridView
    )

    Begin {
        #===================================================================================================
        #   Get-OSDBuilder
        #===================================================================================================
        Get-OSDBuilder -CreatePaths -HideDetails
        #===================================================================================================
        #   Get-OSDUpdates
        #===================================================================================================
        $AllOSDUpdates = @()
        $AllOSDUpdates = Get-OSDUpdates
        #===================================================================================================
        #   Get-OSBuilds
        #   19.10.17 Require CurrentVersion.xml
        #===================================================================================================
        $AllOSBuilds = @()
        $AllOSBuilds = Get-ChildItem -Path "$OSDBuilderOSBuilds" -Directory | Select-Object -Property * | `
        Where-Object {Test-Path $(Join-Path $_.FullName "info\xml\CurrentVersion.xml")} | `
        Where-Object {Test-Path $(Join-Path $_.FullName "info\xml\Get-WindowsImage.xml")} | `
        Where-Object {Test-Path $(Join-Path $_.FullName "info\xml\Sessions.xml")}
        #===================================================================================================
    }

    Process {
        $OSBuilds = foreach ($Item in $AllOSBuilds) {
            #===================================================================================================
            #   Get-FullName
            #===================================================================================================
            $OSBuildPath = $($Item.FullName)
            Write-Verbose "OSBuild Full Path: $OSBuildPath"
            #===================================================================================================
            #   Import XML
            #===================================================================================================
            $XmlWindowsImage = @()
            $XmlWindowsImage = Import-Clixml -Path "$OSBuildPath\info\xml\Get-WindowsImage.xml"

            $XmlRegistry = @()
            $XmlRegistry = Import-Clixml -Path "$OSBuildPath\info\xml\CurrentVersion.xml"

            $OSMPackage = @()
            $OSMPackage = Import-Clixml -Path "$OSBuildPath\info\xml\Get-WindowsPackage.xml"

            $OSMSessions = @()
            $OSMSessions = Import-Clixml -Path "$OSBuildPath\info\xml\Sessions.xml" | Where-Object {$_.targetState -eq 'Installed'} | Sort-Object id
            #===================================================================================================
            #   XmlWindowsImage
            #===================================================================================================
            $OSMImageName = $($XmlWindowsImage.ImageName)
            Write-Verbose "ImageName: $OSMImageName"

            $OSMArch = $XmlWindowsImage.Architecture
            if ($OSMArch -eq '0') {$OSMArch = 'x86'}
            if ($OSMArch -eq '6') {$OSMArch = 'ia64'}
            if ($OSMArch -eq '9') {$OSMArch = 'x64'}
            if ($OSMArch -eq '12') {$OSMArch = 'x64 ARM'}
            Write-Verbose "Arch: $OSMArch"

            $OSMEditionId = $($XmlWindowsImage.EditionId)
            Write-Verbose "EditionId: $OSMEditionId"

            $OSMInstallationType = $($XmlWindowsImage.InstallationType)
            Write-Verbose "InstallationType: $OSMInstallationType"
            #===================================================================================================
            #   Version Information
            #===================================================================================================
            $OSMVersion = $($XmlWindowsImage.Version)
            Write-Verbose "Version: $OSMVersion"

            $OSMMajorVersion = $($XmlWindowsImage.MajorVersion)
            Write-Verbose "MajorVersion: $OSMMajorVersion"

            $OSMMinorVersion = $($XmlWindowsImage.MinorVersion)
            Write-Verbose "MinorVersion: $OSMMinorVersion"

            $OSMBuild = $($XmlWindowsImage.Build)
            Write-Verbose "Build: $OSMBuild"

            $OSMUBR = $($XmlWindowsImage.UBR)
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
            $OSMLanguages = $($XmlWindowsImage.Languages)
            Write-Verbose "Languages: $OSMLanguages"
            #===================================================================================================
            #   Registry
            #===================================================================================================
            $RegReleaseId = $null
            [string]$RegReleaseId = $($XmlRegistry.ReleaseId)
            [string]$RegCurrentBuild = $($XmlRegistry.CurrentBuild)

            if ($OSMBuild -eq 7600) {$RegReleaseId = 7600}
            if ($OSMBuild -eq 7601) {$RegReleaseId = 7601}
            if ($OSMBuild -eq 9600) {$RegReleaseId = 9600}
            if ($OSMBuild -eq 10240) {$RegReleaseId = 1507}
            if ($OSMBuild -eq 14393) {$RegReleaseId = 1607}
            if ($OSMBuild -eq 15063) {$RegReleaseId = 1703}
            if ($OSMBuild -eq 16299) {$RegReleaseId = 1709}
            if ($OSMBuild -eq 17134) {$RegReleaseId = 1803}
            if ($OSMBuild -eq 17763) {$RegReleaseId = 1809}
            #if ($OSMBuild -eq 18362) {$RegReleaseId = 1903}
            #if ($OSMBuild -eq 18363) {$RegReleaseId = 1909}
            #if ($OSMBuild -eq 18990) {$RegReleaseId = 2001}

            Write-Verbose "ReleaseId: $RegReleaseId"
            Write-Verbose "CurrentBuild: $RegCurrentBuild"
            #===================================================================================================
            #   OSMFamily
            #===================================================================================================
            $OSMFamilyV1 = $(Get-Date -Date $($XmlWindowsImage.CreatedTime)).ToString("yyyyMMddHHmmss") + $OSMEditionID
            if ($null -eq $RegCurrentBuild) {
                $OSMFamily = $OSMInstallationType + " " + $OSMEditionId + " " + $OSMArch + " " + [string]$OSMBuild + " " + $OSMLanguages
            } else {
                $OSMFamily = $OSMInstallationType + " " + $OSMEditionId + " " + $OSMArch + " " + [string]$RegCurrentBuild + " " + $OSMLanguages
            }
            Write-Verbose "OSMFamily: $OSMFamily"
            #===================================================================================================
            #   Verify Updates
            #===================================================================================================
            $VerifyUpdates = @()
            $VerifyUpdates = $AllOSDUpdates | Sort-Object -Property CreationDate | `
            Where-Object {$_.UpdateOS -like "*$UpdateOS*"} | Where-Object {$_.UpdateBuild -like "*$RegReleaseId*"} | `
            Where-Object {$_.UpdateArch -like "*$($OSMArch)*"} | Where-Object {$_.UpdateGroup -notlike "*Setup*"} | `
            Where-Object {$_.UpdateGroup -ne ''} | Where-Object {$_.UpdateGroup -ne 'Optional'} | Sort-Object -Property FileName -Unique | Sort-Object -Property CreationDate
            #===================================================================================================
            #   Server Core
            #===================================================================================================
            if ($OSMInstallationType -match 'Core'){$VerifyUpdates = $VerifyUpdates | Where-Object {$_.UpdateGroup -ne 'AdobeSU'}}
            $OSMUpdateStatus = 'OK'
            foreach ($OSMUpdate in $VerifyUpdates) {
                if ($OSMSessions | Where-Object {$_.KBNumber -match "$($OSMUpdate.FileKBNumber)"}) {
                    Write-Verbose "Installed: $($OSMUpdate.Title) $($OSMUpdate.FileName)"
                } else {
                    Write-Verbose "Not Installed: $($OSMUpdate.Title) $($OSMUpdate.FileName)"
                    $OSMUpdateStatus = 'Update'
                }
            }
            #===================================================================================================
            #   Create Object
            #===================================================================================================
            $ObjectProperties = @{
                MediaType           = 'OSBuild'
                ModifiedTime        = [datetime]$XmlWindowsImage.ModifiedTime
                Name                = $Item.Name

                Updates             = $OSMUpdateStatus
                OSMFamily           = $OSMFamily
                ImageName           = $OSMImageName

                OperatingSystem     = $UpdateOS
                Arch                = $OSMArch

                ReleaseId           = $RegReleaseId
                RegBuild            = $($XmlRegistry.CurrentBuild)
                UBR                 = [version]$OSMUBR

                Version             = [version]$OSMVersion
                MajorVersion        = $OSMMajorVersion
                MinorVersion        = $OSMMinorVersion
                Build               = [string]$OSMBuild

                Languages           = $XmlWindowsImage.Languages
                EditionId           = $OSMEditionId
                InstallationType    = $OSMInstallationType
                FullName            = $Item.FullName
                CreatedTime         = [datetime]$XmlWindowsImage.CreatedTime

                OSMFamilyV1         = $OSMFamilyV1
            }
            New-Object -TypeName PSObject -Property $ObjectProperties
            Write-Verbose ""
            #===================================================================================================
            #   Corrections
            #===================================================================================================
            Repair-GetOSBuildsWinSE						
        }
        #===================================================================================================
        #   Results
        #===================================================================================================
        if ($GridView.IsPresent) {
            $OSBuilds = $OSBuilds | Select-Object MediaType,ModifiedTime,`
            Updates,`
            Name,OperatingSystem,Arch,`
            ReleaseId,RegBuild,UBR,`
            Version,MajorVersion,MinorVersion,Build,`
            Languages,EditionId,InstallationType,`
            ImageName,OSMFamily,`
            FullName,CreatedTime | `
            Sort-Object -Property Name | Out-GridView -PassThru -Title 'OSBuilds'
        } else {
            $OSBuilds = $OSBuilds | Select-Object MediaType,ModifiedTime,`
            Updates,`
            Name,OperatingSystem,Arch,`
            ReleaseId,RegBuild,UBR,`
            Version,MajorVersion,MinorVersion,Build,`
            Languages,EditionId,InstallationType,`
            ImageName,OSMFamily,`
            FullName,CreatedTime | `
            Sort-Object -Property Name
        }
        Return $OSBuilds
        #===================================================================================================
    }

    END {}
}

function Repair-GetOSBuildsWinSE {
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
}