<#
.SYNOPSIS
Returns all Operating Systems in OSDBuilder\OSMedia

.DESCRIPTION
Returns all Operating Systems in OSDBuilder\OSMedia as a PowerShell Custom Object

.LINK
https://osdbuilder.osdeploy.com/module/functions/get-osmedia
#>
function Get-OSMedia {
    [CmdletBinding()]
    param (
        #Displays results in GridView with PassThru
        [switch]$GridView,
        
        #Filter the OSMedia by OS Architecture
        [ValidateSet('x64','x86')]
        [string]$OSArch,
        
        #Returns the latest OSMedia
        [switch]$Newest,

        #Filter the OSMedia by OS Installation Type
        [ValidateSet('Client','Server')]
        [string]$OSInstallationType,

        #Filter the OSMedia by OS Major Version
        [ValidateSet(6,10)]
        [string]$OSMajorVersion,

        #Filter the OSMedia by OS Release Id
        [ValidateSet ('21H2','21H1','20H2',2004,1909,1903,1809)]
        [string]$OSReleaseId,
        
        #Filter the OSMedia by Image Revision
        [ValidateSet('OK','Superseded')]
        [string]$Revision,

        #Filter the OSMedia by Update status
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
        #   Get-OSMedia
        #   19.10.17 Require CurrentVersion.xml
        #=================================================
        $AllOSMedia = @()
        $AllOSMedia = Get-ChildItem -Path "$SetOSDBuilderPathOSImport","$SetOSDBuilderPathOSMedia" -Directory | Select-Object -Property * | `
        Where-Object {Test-Path $(Join-Path $_.FullName "info\xml\CurrentVersion.xml")} | `
        Where-Object {Test-Path $(Join-Path $_.FullName "info\xml\Get-WindowsImage.xml")} | `
        Where-Object {Test-Path $(Join-Path $_.FullName "info\xml\Sessions.xml")}
        #=================================================
    }

    Process {
        $OSMedia = foreach ($Item in $AllOSMedia) {
            #=================================================
            #   Get-FullName
            #=================================================
            $OSMediaPath = $($Item.FullName)
            Write-Verbose "OSMedia Full Path: $OSMediaPath"
            #=================================================
            #   Import XML
            #=================================================
            $XmlWindowsImage = @()
            $XmlWindowsImage = Import-Clixml -Path "$OSMediaPath\info\xml\Get-WindowsImage.xml"

            $RegKeyCurrentVersion = @()
            $RegKeyCurrentVersion = Import-Clixml -Path "$OSMediaPath\info\xml\CurrentVersion.xml"

            $OSMPackage = @()
            $OSMPackage = Import-Clixml -Path "$OSMediaPath\info\xml\Get-WindowsPackage.xml"

            $OSMSessions = @()
            $OSMSessions = Import-Clixml -Path "$OSMediaPath\info\xml\Sessions.xml" | Where-Object {$_.targetState -eq 'Installed'} | Sort-Object id
            #=================================================
            #   MediaType
            #=================================================
            if ($OSMediaPath -match '\\OSImport\\') {$MediaType = 'OSImport'}
            else {$MediaType = 'OSMedia'}
            Write-Verbose "MediaType: $MediaType"
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
                Write-Warning "$OSMediaPath is no longer supported by OSDBuilder"
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
            $ReleaseId = $null
            [string]$RegValueCurrentBuild = ($RegKeyCurrentVersion).CurrentBuild
            [string]$RegValueDisplayVersion = ($RegKeyCurrentVersion).DisplayVersion
            [string]$ReleaseId = ($RegKeyCurrentVersion).ReleaseId
            if ($RegValueDisplayVersion) {$ReleaseId = $RegValueDisplayVersion}

            if ($OSMBuild -eq 7600) {$ReleaseId = 7600}
            if ($OSMBuild -eq 7601) {$ReleaseId = 7601}
            if ($OSMBuild -eq 9600) {$ReleaseId = 9600}
            if ($OSMBuild -eq 10240) {$ReleaseId = 1507}
            if ($OSMBuild -eq 14393) {$ReleaseId = 1607}
            if ($OSMBuild -eq 15063) {$ReleaseId = 1703}
            if ($OSMBuild -eq 16299) {$ReleaseId = 1709}
            if ($OSMBuild -eq 17134) {$ReleaseId = 1803}
            if ($OSMBuild -eq 17763) {$ReleaseId = 1809}
            if ($RegValueCurrentBuild -eq 18362) {$ReleaseId = 1903}
            if ($RegValueCurrentBuild -eq 18363) {$ReleaseId = 1909}
            if ($RegValueCurrentBuild -eq 19041) {$ReleaseId = 2004}
            if ($RegValueCurrentBuild -eq 19042) {$ReleaseId = '20H2'}
            if ($RegValueCurrentBuild -eq 19043) {$ReleaseId = '21H1'}
            if ($RegValueCurrentBuild -eq 19044) {$ReleaseId = '21H2'} #Windows
            if ($RegValueCurrentBuild -eq 22000) {$ReleaseId = '21H2'} #Windows 11
            if ($RegValueCurrentBuild -eq 20348) {$ReleaseId = '21H2'} #Server 2022  

            Write-Verbose "ReleaseId: $ReleaseId"
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
            #   Guid
            #=================================================
            #   $XmlWindowsImage | ForEach {$_.PSObject.Properties.Remove('Guid')}
            $OSMGuid = $($XmlWindowsImage.OSMGuid)
            if (-not ($OSMGuid)) {
                $OSMGuid = $(New-Guid)
                $XmlWindowsImage | Add-Member -Type NoteProperty -Name "OSMGuid" -Value $OSMGuid
                $XmlWindowsImage | Out-File "$OSMediaPath\WindowsImage.txt"
                $XmlWindowsImage | Out-File "$OSMediaPath\info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsImage.txt"
                $XmlWindowsImage | Export-Clixml -Path "$OSMediaPath\info\xml\Get-WindowsImage.xml"
                $XmlWindowsImage | Export-Clixml -Path "$OSMediaPath\info\xml\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsImage.xml"
                $XmlWindowsImage | ConvertTo-Json | Out-File "$OSMediaPath\info\json\Get-WindowsImage.json"
                $XmlWindowsImage | ConvertTo-Json | Out-File "$OSMediaPath\info\json\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsImage.json"
                (Get-Content "$OSMediaPath\WindowsImage.txt") | Where-Object {$_.Trim(" `t")} | Set-Content "$OSMediaPath\WindowsImage.txt"
                Write-Verbose "Guid (New): $OSMGuid"
            } else {
                Write-Verbose "Guid: $OSMGuid"
            }
            #=================================================
            #   Verify Updates
            #=================================================
            $VerifyUpdates = @()
            $VerifyUpdates = $AllOSDUpdates | Sort-Object -Property CreationDate | `
            Where-Object {$_.UpdateOS -match $UpdateOS} | `
            Where-Object {$_.UpdateBuild -match $ReleaseId} | `
            Where-Object {$_.UpdateArch -match $OSMArch} | `
            Where-Object {$_.UpdateGroup -notmatch 'Setup'} | `
            Where-Object {$_.UpdateGroup -ne ''} | `
            Where-Object {$_.UpdateGroup -ne 'Optional'} | `
            Sort-Object -Property FileName -Unique | Sort-Object -Property CreationDate
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
                MediaType           = $MediaType
                ModifiedTime        = [datetime]$XmlWindowsImage.ModifiedTime
                Name                = $Item.Name
                Superseded          = $true
                NeedsUpdate         = $false
                Revision            = 'Superseded'
                Updates             = $OSMUpdateStatus
                OSMFamily           = $OSMFamily
                ImageName           = $($XmlWindowsImage.ImageName)

                OperatingSystem     = $UpdateOS
                Arch                = $OSMArch

                ReleaseId           = $ReleaseId
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
                OSMGuid             = $OSMGuid
            }
            New-Object -TypeName PSObject -Property $ObjectProperties
            Write-Verbose ""
            #=================================================
            #   Corrections
            #=================================================
            if (Get-IsTemplatesEnabled) {Repair-GetOSDMediaTemplateDirectories}
        }
        #=================================================
        #   Revision
        #=================================================
        $OSMedia | Sort-Object OSMFamily, MediaType, ModifiedTime, UBR -Descending | Group-Object OSMFamily | ForEach-Object {$_.Group | Select-Object -First 1} | foreach {$_.Revision = 'OK'}
        $OSMedia | Where-Object {$_.Revision -eq 'OK'} | foreach {$_.Superseded = $false}
        $OSMedia | Where-Object {$_.Updates -eq 'Update'} | foreach {$_.NeedsUpdate = $true}
        #=================================================
        #   Filters
        #=================================================
        if ($OSArch) {$OSMedia = $OSMedia | Where-Object {$_.Arch -eq $OSArch}}
        if ($OSReleaseId) {$OSMedia = $OSMedia | Where-Object {$_.ReleaseId -eq $OSReleaseId}}
        if ($OSInstallationType -eq 'Client') {$OSMedia = $OSMedia | Where-Object {$_.InstallationType -notlike "*Server*"}}
        if ($OSInstallationType -eq 'Server') {$OSMedia = $OSMedia | Where-Object {$_.InstallationType -like "*Server*"}}
        if ($OSMajorVersion) {$OSMedia = $OSMedia | Where-Object {$_.MajorVersion -eq $OSMajorVersion}}
        if ($Revision) {$OSMedia = $OSMedia | Where-Object {$_.Revision -eq $Revision}}
        if ($Updates) {$OSMedia = $OSMedia | Where-Object {$_.Updates -eq $Updates}}
        if ($Newest.IsPresent) {$OSMedia = $OSMedia | Sort-Object ModifiedTime -Descending | Select-Object -First 1}
        #=================================================
        #   Results
        #=================================================
        if ($GridView.IsPresent) {
            $OSMedia = $OSMedia | Select-Object MediaType,ModifiedTime,`
            Superseded,NeedsUpdate,`
            Revision,Updates,`
            Name,OperatingSystem,Arch,`
            ReleaseId,RegBuild,UBR,`
            Version,MajorVersion,MinorVersion,Build,`
            Languages,EditionId,InstallationType,`
            ImageName,OSMFamily,`
            FullName,CreatedTime,OSMGuid | `
            Sort-Object -Property Name | Out-GridView -PassThru -Title 'OSMedia'
        } else {
            $OSMedia = $OSMedia | Select-Object MediaType,ModifiedTime,`
            Superseded,NeedsUpdate,`
            Revision,Updates,`
            Name,OperatingSystem,Arch,`
            ReleaseId,RegBuild,UBR,`
            Version,MajorVersion,MinorVersion,Build,`
            Languages,EditionId,InstallationType,`
            ImageName,OSMFamily,`
            FullName,CreatedTime,OSMGuid,OSMFamilyV1 | `
            Sort-Object -Property Name
        }
        Return $OSMedia
        #=================================================
    }

    END {}
}
function Repair-GetOSDMediaTemplateDirectories {
    #=================================================
    #   Template Drivers
    #=================================================
    if (!(Test-Path "$SetOSDBuilderPathTemplates\Drivers\AutoApply\Global")) {New-Item -Path "$SetOSDBuilderPathTemplates\Drivers\AutoApply\Global" -ItemType Directory -Force | Out-Null}
    if (!(Test-Path "$SetOSDBuilderPathTemplates\Drivers\AutoApply\Global $OSMArch")) {New-Item -Path "$SetOSDBuilderPathTemplates\Drivers\AutoApply\Global $OSMArch" -ItemType Directory -Force | Out-Null}
    if (!(Test-Path "$SetOSDBuilderPathTemplates\Drivers\AutoApply\$UpdateOS")) {New-Item -Path "$SetOSDBuilderPathTemplates\Drivers\AutoApply\$UpdateOS" -ItemType Directory -Force | Out-Null}
    if ($OSMInstallationType -notlike "*Server*") {
        if (!(Test-Path "$SetOSDBuilderPathTemplates\Drivers\AutoApply\$UpdateOS $OSMArch")) {New-Item -Path "$SetOSDBuilderPathTemplates\Drivers\AutoApply\$UpdateOS $OSMArch" -ItemType Directory -Force | Out-Null}
    }
    if ($OSMInstallationType -notlike "*Server*" -and $OSMMajorVersion -eq 10) {
        if (!(Test-Path "$SetOSDBuilderPathTemplates\Drivers\AutoApply\$UpdateOS $OSMArch $ReleaseId")) {New-Item -Path "$SetOSDBuilderPathTemplates\Drivers\AutoApply\$UpdateOS $OSMArch $ReleaseId" -ItemType Directory -Force | Out-Null}
    }
    #=================================================
    #   Template ExtraFiles
    #=================================================
    if (!(Test-Path "$SetOSDBuilderPathTemplates\ExtraFiles\AutoApply\Global")) {New-Item -Path "$SetOSDBuilderPathTemplates\ExtraFiles\AutoApply\Global" -ItemType Directory -Force | Out-Null}
    if (!(Test-Path "$SetOSDBuilderPathTemplates\ExtraFiles\AutoApply\Global $OSMArch")) {New-Item -Path "$SetOSDBuilderPathTemplates\ExtraFiles\AutoApply\Global $OSMArch" -ItemType Directory -Force | Out-Null}
    if (!(Test-Path "$SetOSDBuilderPathTemplates\ExtraFiles\AutoApply\$UpdateOS")) {New-Item -Path "$SetOSDBuilderPathTemplates\ExtraFiles\AutoApply\$UpdateOS" -ItemType Directory -Force | Out-Null}
    if ($OSMInstallationType -notlike "*Server*") {
        if (!(Test-Path "$SetOSDBuilderPathTemplates\ExtraFiles\AutoApply\$UpdateOS $OSMArch")) {New-Item -Path "$SetOSDBuilderPathTemplates\ExtraFiles\AutoApply\$UpdateOS $OSMArch" -ItemType Directory -Force | Out-Null}
    }
    if ($OSMInstallationType -notlike "*Server*" -and $OSMMajorVersion -eq 10) {
        if (!(Test-Path "$SetOSDBuilderPathTemplates\ExtraFiles\AutoApply\$UpdateOS $OSMArch $ReleaseId")) {New-Item -Path "$SetOSDBuilderPathTemplates\ExtraFiles\AutoApply\$UpdateOS $OSMArch $ReleaseId" -ItemType Directory -Force | Out-Null}
    }
    #=================================================
    #   Template Registry
    #=================================================
    if (!(Test-Path "$SetOSDBuilderPathTemplates\Registry\AutoApply\Global")) {New-Item -Path "$SetOSDBuilderPathTemplates\Registry\AutoApply\Global" -ItemType Directory -Force | Out-Null}
    if (!(Test-Path "$SetOSDBuilderPathTemplates\Registry\AutoApply\Global $OSMArch")) {New-Item -Path "$SetOSDBuilderPathTemplates\Registry\AutoApply\Global $OSMArch" -ItemType Directory -Force | Out-Null}
    if (!(Test-Path "$SetOSDBuilderPathTemplates\Registry\AutoApply\$UpdateOS")) {New-Item -Path "$SetOSDBuilderPathTemplates\Registry\AutoApply\$UpdateOS" -ItemType Directory -Force | Out-Null}
    if ($OSMInstallationType -notlike "*Server*") {
        if (!(Test-Path "$SetOSDBuilderPathTemplates\Registry\AutoApply\$UpdateOS $OSMArch")) {New-Item -Path "$SetOSDBuilderPathTemplates\Registry\AutoApply\$UpdateOS $OSMArch" -ItemType Directory -Force | Out-Null}
    }
    if ($OSMInstallationType -notlike "*Server*" -and $OSMMajorVersion -eq 10) {
        if (!(Test-Path "$SetOSDBuilderPathTemplates\Registry\AutoApply\$UpdateOS $OSMArch $ReleaseId")) {New-Item -Path "$SetOSDBuilderPathTemplates\Registry\AutoApply\$UpdateOS $OSMArch $ReleaseId" -ItemType Directory -Force | Out-Null}
    }
    #=================================================
    #   Template Scripts
    #=================================================
    if (!(Test-Path "$SetOSDBuilderPathTemplates\Scripts\AutoApply\Global")) {New-Item -Path "$SetOSDBuilderPathTemplates\Scripts\AutoApply\Global" -ItemType Directory -Force | Out-Null}
    if (!(Test-Path "$SetOSDBuilderPathTemplates\Scripts\AutoApply\Global $OSMArch")) {New-Item -Path "$SetOSDBuilderPathTemplates\Scripts\AutoApply\Global $OSMArch" -ItemType Directory -Force | Out-Null}
    if (!(Test-Path "$SetOSDBuilderPathTemplates\Scripts\AutoApply\$UpdateOS")) {New-Item -Path "$SetOSDBuilderPathTemplates\Scripts\AutoApply\$UpdateOS" -ItemType Directory -Force | Out-Null}
    if ($OSMInstallationType -notlike "*Server*") {
        if (!(Test-Path "$SetOSDBuilderPathTemplates\Scripts\AutoApply\$UpdateOS $OSMArch")) {New-Item -Path "$SetOSDBuilderPathTemplates\Scripts\AutoApply\$UpdateOS $OSMArch" -ItemType Directory -Force | Out-Null}
    }
    if ($OSMInstallationType -notlike "*Server*" -and $OSMMajorVersion -eq 10) {
        if (!(Test-Path "$SetOSDBuilderPathTemplates\Scripts\AutoApply\$UpdateOS $OSMArch $ReleaseId")) {New-Item -Path "$SetOSDBuilderPathTemplates\Scripts\AutoApply\$UpdateOS $OSMArch $ReleaseId" -ItemType Directory -Force | Out-Null}
    }
}