<#
.SYNOPSIS
Returns all Operating Systems in OSDBuilder\PEBuilds

.DESCRIPTION
Returns all Operating Systems in OSDBuilder\PEBuilds as a PowerShell Custom Object

.LINK
https://osdbuilder.osdeploy.com/module/functions/get-pebuilds
#>
function Get-PEBuilds {
    [CmdletBinding()]
    param (
        #Displays results in GridView with PassThru
        [switch]$GridView
    )

    Begin {
        #=================================================
        #   Initialize OSDBuilder
        #=================================================
        Get-OSDBuilder -CreatePaths -HideDetails
        #=================================================
        #   Get PEBuilds
        #=================================================
        $AllPEBuilds = @()
        $AllPEBuilds = Get-ChildItem -Path "$SetOSDBuilderPathPEBuilds" -Directory | Select-Object -Property * | `
        Where-Object {Test-Path $(Join-Path $_.FullName "info\xml\CurrentVersion.xml")} | `
        Where-Object {Test-Path $(Join-Path $_.FullName "info\xml\Get-WindowsImage.xml")}
        #=================================================
    }

    Process {
        $PEBuilds = foreach ($Item in $AllPEBuilds) {
            #=================================================
            #   Get-FullName
            #=================================================
            $PEBuildPath = $($Item.FullName)
            Write-Verbose "PEBuild Full Path: $PEBuildPath"
            #=================================================
            #   Import XML
            #=================================================
            $XmlWindowsImage = @()
            $XmlWindowsImage = Import-Clixml -Path "$PEBuildPath\info\xml\Get-WindowsImage.xml"

            $RegKeyCurrentVersion = @()
            $RegKeyCurrentVersion = Import-Clixml -Path "$PEBuildPath\info\xml\CurrentVersion.xml"

            $OSMPackage = @()
            $OSMPackage = Import-Clixml -Path "$PEBuildPath\info\xml\Get-WindowsPackage.xml"
            #=================================================
            #   XmlWindowsImage
            #=================================================
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
            #=================================================
            #   Version Information
            #=================================================
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
            #=================================================
            #   UpdateOS
            #=================================================
            $UpdateOS = ''
            if ($OSMMajorVersion -eq 10) {
                if ($OSMInstallationType -match 'Server') {
                    $UpdateOS = 'Windows Server'
                }
                else {
                    if ($OSMImageName -match ' 11 ') {
                        $UpdateOS = 'Windows 11'
                    }
                    else {
                        $UpdateOS = 'Windows 10'
                    }
                }
            }
            else {
                Write-Warning "$PEBuildPath is no longer supported by OSDBuilder"
                Continue
            }
            Write-Verbose "UpdateOS: $UpdateOS"
            #=================================================
            #   Language
            #=================================================
            $OSMLanguages = $($XmlWindowsImage.Languages)
            Write-Verbose "Languages: $OSMLanguages"
            #=================================================
            #   Registry
            #=================================================
            $RegValueReleaseId = $null
            [string]$RegValueCurrentBuild = ($RegKeyCurrentVersion).CurrentBuild
            [string]$RegValueDisplayVersion = ($RegKeyCurrentVersion).DisplayVersion
            [string]$RegValueReleaseId = ($RegKeyCurrentVersion).ReleaseId
            if ($RegValueDisplayVersion) {$RegValueReleaseId = $RegValueDisplayVersion}

            if ($OSMBuild -eq 7600) {$RegValueReleaseId = 7600}
            if ($OSMBuild -eq 7601) {$RegValueReleaseId = 7601}
            if ($OSMBuild -eq 9600) {$RegValueReleaseId = 9600}
            if ($OSMBuild -eq 10240) {$RegValueReleaseId = 1507}
            if ($OSMBuild -eq 14393) {$RegValueReleaseId = 1607}
            if ($OSMBuild -eq 15063) {$RegValueReleaseId = 1703}
            if ($OSMBuild -eq 16299) {$RegValueReleaseId = 1709}
            if ($OSMBuild -eq 17134) {$RegValueReleaseId = 1803}
            if ($OSMBuild -eq 17763) {$RegValueReleaseId = 1809}
            #if ($OSMBuild -eq 18362) {$RegValueReleaseId = 1903}
            #if ($OSMBuild -eq 18363) {$RegValueReleaseId = 1909}
            #if ($OSMBuild -eq 19041) {$RegValueReleaseId = 2004}
            #if ($OSMBuild -eq 19042) {$RegValueReleaseId = '20H2'}
            #if ($OSMBuild -eq 19043) {$RegValueReleaseId = '21H1'}
            #if ($OSMBuild -eq 19044) {$RegValueReleaseId = '21H2'}

            Write-Verbose "ReleaseId: $RegValueReleaseId"
            Write-Verbose "CurrentBuild: $RegValueCurrentBuild"
            #=================================================
            #   OSMFamily
            #=================================================
            $OSMFamilyV1 = $(Get-Date -Date $($XmlWindowsImage.CreatedTime)).ToString("yyyyMMddHHmmss") + $OSMEditionID
            if ($null -eq $RegValueCurrentBuild) {
                $OSMFamily = $OSMInstallationType + " " + $OSMEditionId + " " + $OSMArch + " " + [string]$OSMBuild + " " + $OSMLanguages
            } else {
                $OSMFamily = $OSMInstallationType + " " + $OSMEditionId + " " + $OSMArch + " " + [string]$RegValueCurrentBuild + " " + $OSMLanguages
            }
            Write-Verbose "OSMFamily: $OSMFamily"
            #=================================================
            #   Create Object
            #=================================================
            $ObjectProperties = @{
                MediaType           = 'PEBuild'
                ModifiedTime        = [datetime]$XmlWindowsImage.ModifiedTime
                Name                = $Item.Name

                OSMFamily           = $OSMFamily
                ImageName           = $OSMImageName

                OperatingSystem     = $UpdateOS
                Arch                = $OSMArch

                ReleaseId           = $RegValueReleaseId
                RegBuild            = $($RegKeyCurrentVersion.CurrentBuild)
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
        #=================================================
        #   Results
        #=================================================
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
        #=================================================
    }

    END {}
}