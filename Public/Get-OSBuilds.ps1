<#
.SYNOPSIS
Returns all Operating Systems in OSDBuilder\OSBuilds

.DESCRIPTION
Returns all Operating Systems in OSDBuilder\OSBuilds as a PowerShell Custom Object

.LINK
https://osdbuilder.osdeploy.com/module/functions/get-osbuilds
#>
function Get-OSBuilds {
    [CmdletBinding()]
    param (
        #Displays results in GridView with PassThru
        [switch]$GridView,
        
        #Filter the OSBuild by OS Architecture
        [ValidateSet('x64','x86')]
        [string]$OSArch,
        
        #Returns the latest OSBuild
        [switch]$Newest,

        #Filter the OSBuild by OS Installation Type
        [ValidateSet('Client','Server')]
        [string]$OSInstallationType,

        #Filter the OSBuild by OS Major Version
        [ValidateSet(10)]
        [string]$OSMajorVersion,

        #Filter the OSBuild by OS Release Id
        [ValidateSet ('21H2','21H1','20H2',2004,1909,1903,1809)]
        [string]$OSReleaseId,
        
        #Filter the OSBuild by Image Revision
        [ValidateSet('OK','Superseded')]
        [string]$Revision,

        #Filter the OSBuild by Update status
        [ValidateSet('OK','Update')]
        [string]$Updates
    )

    Begin {
        #=================================================
        #   Get-OSDBuilder
        #=================================================
        Get-OSDBuilder -CreatePaths -HideDetails
        #=================================================
        #   Get-OSDUpdates
        #=================================================
        $AllOSDUpdates = @()
        $AllOSDUpdates = Get-OSDUpdates -Silent
        #=================================================
        #   Get-OSBuilds
        #   19.10.17 Require CurrentVersion.xml
        #=================================================
        $AllOSBuilds = @()
        $AllOSBuilds = Get-ChildItem -Path "$SetOSDBuilderPathOSBuilds" -Directory | Select-Object -Property * | `
        Where-Object {Test-Path $(Join-Path $_.FullName "info\xml\CurrentVersion.xml")} | `
        Where-Object {Test-Path $(Join-Path $_.FullName "info\xml\Get-WindowsImage.xml")} | `
        Where-Object {Test-Path $(Join-Path $_.FullName "info\xml\Sessions.xml")}
        #=================================================
    }

    Process {
        $OSBuilds = foreach ($Item in $AllOSBuilds) {
            #=================================================
            #   Get-FullName
            #=================================================
            $OSBuildPath = $($Item.FullName)
            Write-Verbose "OSBuild Full Path: $OSBuildPath"
            #=================================================
            #   Import XML
            #=================================================
            $XmlWindowsImage = @()
            $XmlWindowsImage = Import-Clixml -Path "$OSBuildPath\info\xml\Get-WindowsImage.xml"

            $RegKeyCurrentVersion = @()
            $RegKeyCurrentVersion = Import-Clixml -Path "$OSBuildPath\info\xml\CurrentVersion.xml"

            $OSMPackage = @()
            $OSMPackage = Import-Clixml -Path "$OSBuildPath\info\xml\Get-WindowsPackage.xml"

            $OSMSessions = @()
            $OSMSessions = Import-Clixml -Path "$OSBuildPath\info\xml\Sessions.xml" | Where-Object {$_.targetState -eq 'Installed'} | Sort-Object id
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
            #   Operating System
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
                Write-Warning "$OSBuildPath is no longer supported by OSDBuilder"
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
            #   Verify Updates
            #=================================================
            $VerifyUpdates = @()
            $VerifyUpdates = $AllOSDUpdates | Sort-Object -Property CreationDate | `
            Where-Object {$_.UpdateOS -like "*$UpdateOS*"} | Where-Object {$_.UpdateBuild -like "*$RegValueReleaseId*"} | `
            Where-Object {$_.UpdateArch -like "*$($OSMArch)*"} | Where-Object {$_.UpdateGroup -notlike "*Setup*"} | `
            Where-Object {$_.UpdateGroup -ne ''} | Where-Object {$_.UpdateGroup -ne 'Optional'} | Sort-Object -Property FileName -Unique | Sort-Object -Property CreationDate
            #=================================================
            #   Server Core
            #=================================================
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
            #=================================================
            #   Create Object
            #=================================================
            $ObjectProperties = @{
                MediaType           = 'OSBuild'
                ModifiedTime        = [datetime]$XmlWindowsImage.ModifiedTime
                Name                = $Item.Name
                Revision            = 'Superseded'
                Updates             = $OSMUpdateStatus
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
            #=================================================
            #   Corrections
            #=================================================				
        }
        #=================================================
        #   Revision
        #=================================================
        $OSBuilds | Sort-Object OSMFamily, MediaType, ModifiedTime, UBR -Descending | Group-Object OSMFamily | ForEach-Object {$_.Group | Select-Object -First 1} | foreach {$_.Revision = 'OK'}
        #=================================================
        #   Filters
        #=================================================
        if ($OSArch) {$OSBuilds = $OSBuilds | Where-Object {$_.Arch -eq $OSArch}}
        if ($OSReleaseId) {$OSBuilds = $OSBuilds | Where-Object {$_.ReleaseId-eq $OSReleaseId}}
        if ($OSInstallationType -eq 'Client') {$OSBuilds = $OSBuilds | Where-Object {$_.InstallationType -notlike "*Server*"}}
        if ($OSInstallationType -eq 'Server') {$OSBuilds = $OSBuilds | Where-Object {$_.InstallationType -like "*Server*"}}
        if ($OSMajorVersion) {$OSBuilds = $OSBuilds | Where-Object {$_.MajorVersion -eq $OSMajorVersion}}
        if ($Revision) {$OSBuilds = $OSBuilds | Where-Object {$_.Revision -eq $Revision}}
        if ($Updates) {$OSBuilds = $OSBuilds | Where-Object {$_.Updates -eq $Updates}}
        if ($Newest.IsPresent) {$OSBuilds = $OSBuilds | Sort-Object ModifiedTime -Descending | Select-Object -First 1}
        #=================================================
        #   Results
        #=================================================
        if ($GridView.IsPresent) {
            $OSBuilds = $OSBuilds | Select-Object MediaType,ModifiedTime,`
            Revision,Updates,`
            Name,OperatingSystem,Arch,`
            ReleaseId,RegBuild,UBR,`
            Version,MajorVersion,MinorVersion,Build,`
            Languages,EditionId,InstallationType,`
            ImageName,OSMFamily,`
            FullName,CreatedTime | `
            Sort-Object -Property Name | Out-GridView -PassThru -Title 'OSBuilds'
        } else {
            $OSBuilds = $OSBuilds | Select-Object MediaType,ModifiedTime,`
            Revision,Updates,`
            Name,OperatingSystem,Arch,`
            ReleaseId,RegBuild,UBR,`
            Version,MajorVersion,MinorVersion,Build,`
            Languages,EditionId,InstallationType,`
            ImageName,OSMFamily,`
            FullName,CreatedTime | `
            Sort-Object -Property Name
        }
        Return $OSBuilds
        #=================================================
    }

    END {}
}