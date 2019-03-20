<#
.SYNOPSIS
Returns all Operating Systems in OSDBuilder\PEBuilds

.DESCRIPTION
Returns all Operating Systems in OSDBuilder\PEBuilds as a PowerShell Custom Object

.LINK
https://www.osdeploy.com/osdbuilder/docs/functions/pebuild/get-pebuilds

.PARAMETER GridView
Displays results in PowerShell ISE GridView with an added PassThru Parameter.  This can also be displayed with the following command
Get-PEBuilds | Out-GridView
#>
function Get-PEBuilds {
    [CmdletBinding()]
    PARAM (
        [switch]$GridView
    )

    BEGIN {
    #===================================================================================================
    #   Initialize OSDBuilder
        Get-OSDBuilder -CreatePaths -HideDetails
    #===================================================================================================
    #   Get OSDUpdates
        $OSDUpdates = @()
        $OSDUpdates = OSD-Update-GetOSDUpdates
    #===================================================================================================
    #   Get PEBuilds
        $AllPEBuilds = @()
        $AllPEBuilds = Get-ChildItem -Path "$OSDBuilderPEBuilds" -Directory | Select-Object -Property * | `
        Where-Object {Test-Path $(Join-Path $_.FullName "info\xml\Get-WindowsImage.xml")}
    #===================================================================================================
    }

    PROCESS {
        $PEBuilds = foreach ($Item in $AllPEBuilds) {
        #===================================================================================================
        #   Get Windows Image Information
            $PEBuildPath = $($Item.FullName)
            Write-Verbose "OSMedia Full Path: $PEBuildPath"
            
            $OSMWindowsImage = @()
            $OSMWindowsImage = Import-Clixml -Path "$PEBuildPath\info\xml\Get-WindowsImage.xml"
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
            $OSMLanguages = $($OSMWindowsImage.Languages)
            Write-Verbose "Languages: $OSMLanguages"
        #===================================================================================================
        #   OSMFamily
            $OSMFamilyV1 = $(Get-Date -Date $($OSMWindowsImage.CreatedTime)).ToString("yyyyMMddHHmmss") + $OSMEditionID
            $OSMFamily = $OSMInstallationType + " " + $OSMEditionId + " " + $OSMArch + " " + [string]$OSMBuild + " " + $OSMLanguages
            Write-Verbose "OSMFamily: $OSMFamily"
        #===================================================================================================
        #   Registry ReleaseId
            $OSMRegistry = @()
            if (Test-Path "$PEBuildPath\info\xml\CurrentVersion.xml") {
                Write-Verbose "Registry: $PEBuildPath\info\xml\CurrentVersion.xml"
                $OSMRegistry = Import-Clixml -Path "$PEBuildPath\info\xml\CurrentVersion.xml"
            } else {
                Write-Verbose "Registry: $PEBuildPath\info\xml\CurrentVersion.xml (Not Found)"
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

            Write-Verbose "ReleaseId: $OSMReleaseId"
        #===================================================================================================
        #   Correct WindowsPackage.txt
            if (Test-Path "$PEBuildPath\info\WindowsPackage.txt") {Rename-Item "$PEBuildPath\info\WindowsPackage.txt" 'Get-WindowsPackage.txt' -Force | Out-Null}
        #===================================================================================================
        #   Create Object
            $ObjectProperties = @{
                MediaType           = 'PEBuild'

                ModifiedTime        = [datetime]$OSMWindowsImage.ModifiedTime
                Name                = $Item.Name
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
                FullName            = $Item.FullName
                CreatedTime         = [datetime]$OSMWindowsImage.CreatedTime

                OSMFamilyV1         = $OSMFamilyV1
            }
            New-Object -TypeName PSObject -Property $ObjectProperties
            Write-Verbose ""
        }
    #===================================================================================================
    #   Output
        if ($GridView.IsPresent) {
            $PEBuilds | Select-Object MediaType,`
            ModifiedTime,Name,OSMFamily,ImageName,`
            OperatingSystem,Arch,ReleaseId,`
            Version,MajorVersion,MinorVersion,Build,UBR,`
            Languages,`
            EditionId,InstallationType,FullName,CreatedTime | `
            Sort-Object -Property Name | Out-GridView -PassThru -Title 'PEBuilds'
        } else {
            $PEBuilds | Select-Object MediaType,`
            ModifiedTime,Name,OSMFamily,ImageName,`
            OperatingSystem,Arch,ReleaseId,`
            Version,MajorVersion,MinorVersion,Build,UBR,`
            Languages,`
            EditionId,InstallationType,FullName,CreatedTime | `
            Sort-Object -Property Name
        }
    }

    END {}
}