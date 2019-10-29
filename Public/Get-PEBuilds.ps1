<#
.SYNOPSIS
Returns all Operating Systems in OSDBuilder\PEBuilds

.DESCRIPTION
Returns all Operating Systems in OSDBuilder\PEBuilds as a PowerShell Custom Object

.LINK
https://osdbuilder.osdeploy.com/module/functions/pebuild/get-pebuilds

.PARAMETER GridView
Displays results in PowerShell ISE GridView with an added PassThru Parameter.  This can also be displayed with the following command
Get-PEBuilds | Out-GridView
#>
function Get-PEBuilds {
    [CmdletBinding()]
    Param (
        #===================================================================================================
        #   Basic
        #===================================================================================================
        [switch]$GridView
        #===================================================================================================
    )

    Begin {
        #===================================================================================================
        #   Initialize OSDBuilder
        #===================================================================================================
        Get-OSDBuilder -CreatePaths -HideDetails
        #===================================================================================================
        #   Get PEBuilds
        #===================================================================================================
        $AllPEBuilds = @()
        $AllPEBuilds = Get-ChildItem -Path "$GetOSDBuilderPathPEBuilds" -Directory | Select-Object -Property * | `
        Where-Object {Test-Path $(Join-Path $_.FullName "info\xml\CurrentVersion.xml")} | `
        Where-Object {Test-Path $(Join-Path $_.FullName "info\xml\Get-WindowsImage.xml")}
        #===================================================================================================
    }

    Process {
        $PEBuilds = foreach ($Item in $AllPEBuilds) {
            #===================================================================================================
            #   Get-FullName
            #===================================================================================================
            $PEBuildPath = $($Item.FullName)
            Write-Verbose "PEBuild Full Path: $PEBuildPath"
            #===================================================================================================
            #   Import XML
            #===================================================================================================
            $XmlWindowsImage = @()
            $XmlWindowsImage = Import-Clixml -Path "$PEBuildPath\info\xml\Get-WindowsImage.xml"

            $XmlRegistry = @()
            $XmlRegistry = Import-Clixml -Path "$PEBuildPath\info\xml\CurrentVersion.xml"

            $OSMPackage = @()
            $OSMPackage = Import-Clixml -Path "$PEBuildPath\info\xml\Get-WindowsPackage.xml"
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
            #   Create Object
            #===================================================================================================
            $ObjectProperties = @{
                MediaType           = 'PEBuild'
                ModifiedTime        = [datetime]$XmlWindowsImage.ModifiedTime
                Name                = $Item.Name

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
        }
        #===================================================================================================
        #   Results
        #===================================================================================================
        if ($GridView.IsPresent) {
            $PEBuilds = $PEBuilds | Select-Object MediaType,ModifiedTime,`
            Name,OperatingSystem,Arch,`
            ReleaseId,RegBuild,UBR,`
            Version,MajorVersion,MinorVersion,Build,`
            Languages,EditionId,InstallationType,`
            ImageName,OSMFamily,
            FullName,CreatedTime | `
            Sort-Object -Property Name | Out-GridView -PassThru -Title 'PEBuilds'
        } else {
            $PEBuilds = $PEBuilds | Select-Object MediaType,ModifiedTime,`
            Name,OperatingSystem,Arch,`
            ReleaseId,RegBuild,UBR,`
            Version,MajorVersion,MinorVersion,Build,`
            Languages,EditionId,InstallationType,`
            ImageName,OSMFamily,
            FullName,CreatedTime | `
            Sort-Object -Property Name
        }
        Return $PEBuilds
        #===================================================================================================
    }

    END {}
}