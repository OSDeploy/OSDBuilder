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
    Param (
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
        [ValidateSet (1909,1903,1809,1803,1709,1703,1607,1511,1507,7601,7603)]
        [string]$OSReleaseId,
        
        #Filter the OSMedia by Image Revision
        [ValidateSet('OK','Superseded')]
        [string]$Revision,

        #Filter the OSMedia by Update status
        [ValidateSet('OK','Update')]
        [string]$Updates
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
        $AllOSDUpdates = Get-OSDUpdates -Silent
        #===================================================================================================
        #   Get-OSMedia
        #   19.10.17 Require CurrentVersion.xml
        #===================================================================================================
        $AllOSMedia = @()
        $AllOSMedia = Get-ChildItem -Path "$SetOSDBuilderPathOSImport","$SetOSDBuilderPathOSMedia" -Directory | Select-Object -Property * | `
        Where-Object {Test-Path $(Join-Path $_.FullName "info\xml\CurrentVersion.xml")} | `
        Where-Object {Test-Path $(Join-Path $_.FullName "info\xml\Get-WindowsImage.xml")} | `
        Where-Object {Test-Path $(Join-Path $_.FullName "info\xml\Sessions.xml")}
        #===================================================================================================
    }

    Process {
        $OSMedia = foreach ($Item in $AllOSMedia) {
            #===================================================================================================
            #   Get-FullName
            #===================================================================================================
            $OSMediaPath = $($Item.FullName)
            Write-Verbose "OSMedia Full Path: $OSMediaPath"
            #===================================================================================================
            #   Import XML
            #===================================================================================================
            $XmlWindowsImage = @()
            $XmlWindowsImage = Import-Clixml -Path "$OSMediaPath\info\xml\Get-WindowsImage.xml"

            $XmlRegistry = @()
            $XmlRegistry = Import-Clixml -Path "$OSMediaPath\info\xml\CurrentVersion.xml"

            $OSMPackage = @()
            $OSMPackage = Import-Clixml -Path "$OSMediaPath\info\xml\Get-WindowsPackage.xml"

            $OSMSessions = @()
            $OSMSessions = Import-Clixml -Path "$OSMediaPath\info\xml\Sessions.xml" | Where-Object {$_.targetState -eq 'Installed'} | Sort-Object id
            #===================================================================================================
            #   MediaType
            #===================================================================================================
            if ($OSMediaPath -match '\\OSImport\\') {$MediaType = 'OSImport'}
            else {$MediaType = 'OSMedia'}
            Write-Verbose "MediaType: $MediaType"
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
            #   Guid
            #===================================================================================================
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
                MediaType           = $MediaType
                ModifiedTime        = [datetime]$XmlWindowsImage.ModifiedTime
                Name                = $Item.Name
                Revision            = 'Superseded'
                Updates             = $OSMUpdateStatus
                OSMFamily           = $OSMFamily
                ImageName           = $($XmlWindowsImage.ImageName)

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
                OSMGuid             = $OSMGuid
            }
            New-Object -TypeName PSObject -Property $ObjectProperties
            Write-Verbose ""
            #===================================================================================================
            #   Corrections
            #===================================================================================================
            Repair-GetOSMediaWinSE
            if (Get-IsTemplatesEnabled) {Repair-GetOSDMediaTemplateDirectories}
        }
        #===================================================================================================
        #   Revision
        #===================================================================================================
        $OSMedia | Sort-Object OSMFamily, MediaType, ModifiedTime, UBR -Descending | Group-Object OSMFamily | ForEach-Object {$_.Group | Select-Object -First 1} | foreach {$_.Revision = 'OK'}
        #===================================================================================================
        #   Filters
        #===================================================================================================
        if ($OSArch) {$OSMedia = $OSMedia | Where-Object {$_.Arch -eq $OSArch}}
        if ($OSReleaseId) {$OSMedia = $OSMedia | Where-Object {$_.ReleaseId-eq $OSReleaseId}}
        if ($OSInstallationType -eq 'Client') {$OSMedia = $OSMedia | Where-Object {$_.InstallationType -notlike "*Server*"}}
        if ($OSInstallationType -eq 'Server') {$OSMedia = $OSMedia | Where-Object {$_.InstallationType -like "*Server*"}}
        if ($OSMajorVersion) {$OSMedia = $OSMedia | Where-Object {$_.MajorVersion -eq $OSMajorVersion}}
        if ($Revision) {$OSMedia = $OSMedia | Where-Object {$_.Revision -eq $Revision}}
        if ($Updates) {$OSMedia = $OSMedia | Where-Object {$_.Updates -eq $Updates}}
        if ($Newest.IsPresent) {$OSMedia = $OSMedia | Sort-Object ModifiedTime -Descending | Select-Object -First 1}
        #===================================================================================================
        #   Results
        #===================================================================================================
        if ($GridView.IsPresent) {
            $OSMedia = $OSMedia | Select-Object MediaType,ModifiedTime,`
            Revision,Updates,`
            Name,OperatingSystem,Arch,`
            ReleaseId,RegBuild,UBR,`
            Version,MajorVersion,MinorVersion,Build,`
            Languages,EditionId,InstallationType,`
            ImageName,OSMFamily,`
            FullName,CreatedTime,OSMGuid | `
            Sort-Object Name | Out-GridView -PassThru -Title 'OSMedia'
        } else {
            $OSMedia = $OSMedia | Select-Object MediaType,ModifiedTime,`
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
        #===================================================================================================
    }

    END {}
}

function Repair-GetOSMediaWinSE {
    if (Test-Path "$OSMediaPath\WinPE\setup.wim") {Rename-Item "$OSMediaPath\WinPE\setup.wim" 'winse.wim' -Force | Out-Null}

    if (Test-Path "$OSMediaPath\WinPE\info\boot.txt") {Rename-Item "$OSMediaPath\WinPE\info\boot.txt" 'Get-WindowsImage-Boot.txt' -Force | Out-Null}
    if (Test-Path "$OSMediaPath\WinPE\info\winpe.txt") {Rename-Item "$OSMediaPath\WinPE\info\winpe.txt" 'Get-WindowsImage-WinPE.txt' -Force | Out-Null}
    if (Test-Path "$OSMediaPath\WinPE\info\winre.txt") {Rename-Item "$OSMediaPath\WinPE\info\winre.txt" 'Get-WindowsImage-WinRE.txt' -Force | Out-Null}
    if (Test-Path "$OSMediaPath\WinPE\info\setup.txt") {Rename-Item "$OSMediaPath\WinPE\info\setup.txt" 'Get-WindowsImage-WinSE.txt' -Force | Out-Null}
    
    if (Test-Path "$OSMediaPath\WinPE\info\winpe-WindowsPackage.txt") {Rename-Item "$OSMediaPath\WinPE\info\winpe-WindowsPackage.txt" 'Get-WindowsPackage-WinPE.txt' -Force | Out-Null}
    if (Test-Path "$OSMediaPath\WinPE\info\winre-WindowsPackage.txt") {Rename-Item "$OSMediaPath\WinPE\info\winre-WindowsPackage.txt" 'Get-WindowsPackage-WinRE.txt' -Force | Out-Null}
    if (Test-Path "$OSMediaPath\WinPE\info\setup-WindowsPackage.txt") {Rename-Item "$OSMediaPath\WinPE\info\setup-WindowsPackage.txt" 'Get-WindowsPackage-WinSE.txt' -Force | Out-Null}

    if (Test-Path "$OSMediaPath\WinPE\info\json\Get-WindowsImage-boot.wim.json") {Rename-Item "$OSMediaPath\WinPE\info\json\Get-WindowsImage-boot.wim.json" 'Get-WindowsImage-Boot.json' -Force | Out-Null}
    if (Test-Path "$OSMediaPath\WinPE\info\json\Get-WindowsImage-winpe.wim.json") {Rename-Item "$OSMediaPath\WinPE\info\json\Get-WindowsImage-winpe.wim.json" 'Get-WindowsImage-WinPE.json' -Force | Out-Null}
    if (Test-Path "$OSMediaPath\WinPE\info\json\Get-WindowsImage-winre.wim.json") {Rename-Item "$OSMediaPath\WinPE\info\json\Get-WindowsImage-winre.wim.json" 'Get-WindowsImage-WinRE.json' -Force | Out-Null}
    if (Test-Path "$OSMediaPath\WinPE\info\json\Get-WindowsImage-setup.wim.json") {Rename-Item "$OSMediaPath\WinPE\info\json\Get-WindowsImage-setup.wim.json" 'Get-WindowsImage-WinSE.json' -Force | Out-Null}

    if (Test-Path "$OSMediaPath\WinPE\info\json\Get-WindowsPackage-boot.wim.json") {Rename-Item "$OSMediaPath\WinPE\info\json\Get-WindowsPackage-boot.wim.json" 'Get-WindowsPackage-Boot.json' -Force | Out-Null}
    if (Test-Path "$OSMediaPath\WinPE\info\json\Get-WindowsPackage-winpe.wim.json") {Rename-Item "$OSMediaPath\WinPE\info\json\Get-WindowsPackage-winpe.wim.json" 'Get-WindowsPackage-WinPE.json' -Force | Out-Null}
    if (Test-Path "$OSMediaPath\WinPE\info\json\Get-WindowsPackage-winre.wim.json") {Rename-Item "$OSMediaPath\WinPE\info\json\Get-WindowsPackage-winre.wim.json" 'Get-WindowsPackage-WinRE.json' -Force | Out-Null}
    if (Test-Path "$OSMediaPath\WinPE\info\json\Get-WindowsPackage-setup.wim.json") {Rename-Item "$OSMediaPath\WinPE\info\json\Get-WindowsPackage-setup.wim.json" 'Get-WindowsPackage-WinSE.json' -Force | Out-Null}
    
    if (Test-Path "$OSMediaPath\WinPE\info\xml\Get-WindowsImage-boot.wim.xml") {Rename-Item "$OSMediaPath\WinPE\info\xml\Get-WindowsImage-boot.wim.xml" 'Get-WindowsImage-Boot.xml' -Force | Out-Null}
    if (Test-Path "$OSMediaPath\WinPE\info\xml\Get-WindowsImage-winpe.wim.xml") {Rename-Item "$OSMediaPath\WinPE\info\xml\Get-WindowsImage-winpe.wim.xml" 'Get-WindowsImage-WinPE.xml' -Force | Out-Null}
    if (Test-Path "$OSMediaPath\WinPE\info\xml\Get-WindowsImage-winre.wim.xml") {Rename-Item "$OSMediaPath\WinPE\info\xml\Get-WindowsImage-winre.wim.xml" 'Get-WindowsImage-WinRE.xml' -Force | Out-Null}
    if (Test-Path "$OSMediaPath\WinPE\info\xml\Get-WindowsImage-setup.wim.xml") {Rename-Item "$OSMediaPath\WinPE\info\xml\Get-WindowsImage-setup.wim.xml" 'Get-WindowsImage-WinSE.xml' -Force | Out-Null}
    
    if (Test-Path "$OSMediaPath\WinPE\info\xml\Get-WindowsPackage-boot.wim.xml") {Rename-Item "$OSMediaPath\WinPE\info\xml\Get-WindowsPackage-boot.wim.xml" 'Get-WindowsPackage-Boot.xml' -Force | Out-Null}
    if (Test-Path "$OSMediaPath\WinPE\info\xml\Get-WindowsPackage-winpe.wim.xml") {Rename-Item "$OSMediaPath\WinPE\info\xml\Get-WindowsPackage-winpe.wim.xml" 'Get-WindowsPackage-WinPE.xml' -Force | Out-Null}
    if (Test-Path "$OSMediaPath\WinPE\info\xml\Get-WindowsPackage-winre.wim.xml") {Rename-Item "$OSMediaPath\WinPE\info\xml\Get-WindowsPackage-winre.wim.xml" 'Get-WindowsPackage-WinRE.xml' -Force | Out-Null}
    if (Test-Path "$OSMediaPath\WinPE\info\xml\Get-WindowsPackage-setup.wim.xml") {Rename-Item "$OSMediaPath\WinPE\info\xml\Get-WindowsPackage-setup.wim.xml" 'Get-WindowsPackage-WinSE.xml' -Force | Out-Null}
}

function Repair-GetOSDMediaTemplateDirectories {
    #===================================================================================================
    #   Template Drivers
    #===================================================================================================
    if (!(Test-Path "$SetOSDBuilderPathTemplates\Drivers\AutoApply\Global")) {New-Item -Path "$SetOSDBuilderPathTemplates\Drivers\AutoApply\Global" -ItemType Directory -Force | Out-Null}
    if (!(Test-Path "$SetOSDBuilderPathTemplates\Drivers\AutoApply\Global $OSMArch")) {New-Item -Path "$SetOSDBuilderPathTemplates\Drivers\AutoApply\Global $OSMArch" -ItemType Directory -Force | Out-Null}
    if (!(Test-Path "$SetOSDBuilderPathTemplates\Drivers\AutoApply\$UpdateOS")) {New-Item -Path "$SetOSDBuilderPathTemplates\Drivers\AutoApply\$UpdateOS" -ItemType Directory -Force | Out-Null}
    if ($OSMInstallationType -notlike "*Server*") {
        if (!(Test-Path "$SetOSDBuilderPathTemplates\Drivers\AutoApply\$UpdateOS $OSMArch")) {New-Item -Path "$SetOSDBuilderPathTemplates\Drivers\AutoApply\$UpdateOS $OSMArch" -ItemType Directory -Force | Out-Null}
    }
    if ($OSMInstallationType -notlike "*Server*" -and $OSMMajorVersion -eq 10) {
        if (!(Test-Path "$SetOSDBuilderPathTemplates\Drivers\AutoApply\$UpdateOS $OSMArch $RegReleaseId")) {New-Item -Path "$SetOSDBuilderPathTemplates\Drivers\AutoApply\$UpdateOS $OSMArch $RegReleaseId" -ItemType Directory -Force | Out-Null}
    }
    #===================================================================================================
    #   Template ExtraFiles
    #===================================================================================================
    if (!(Test-Path "$SetOSDBuilderPathTemplates\ExtraFiles\AutoApply\Global")) {New-Item -Path "$SetOSDBuilderPathTemplates\ExtraFiles\AutoApply\Global" -ItemType Directory -Force | Out-Null}
    if (!(Test-Path "$SetOSDBuilderPathTemplates\ExtraFiles\AutoApply\Global $OSMArch")) {New-Item -Path "$SetOSDBuilderPathTemplates\ExtraFiles\AutoApply\Global $OSMArch" -ItemType Directory -Force | Out-Null}
    if (!(Test-Path "$SetOSDBuilderPathTemplates\ExtraFiles\AutoApply\$UpdateOS")) {New-Item -Path "$SetOSDBuilderPathTemplates\ExtraFiles\AutoApply\$UpdateOS" -ItemType Directory -Force | Out-Null}
    if ($OSMInstallationType -notlike "*Server*") {
        if (!(Test-Path "$SetOSDBuilderPathTemplates\ExtraFiles\AutoApply\$UpdateOS $OSMArch")) {New-Item -Path "$SetOSDBuilderPathTemplates\ExtraFiles\AutoApply\$UpdateOS $OSMArch" -ItemType Directory -Force | Out-Null}
    }
    if ($OSMInstallationType -notlike "*Server*" -and $OSMMajorVersion -eq 10) {
        if (!(Test-Path "$SetOSDBuilderPathTemplates\ExtraFiles\AutoApply\$UpdateOS $OSMArch $RegReleaseId")) {New-Item -Path "$SetOSDBuilderPathTemplates\ExtraFiles\AutoApply\$UpdateOS $OSMArch $RegReleaseId" -ItemType Directory -Force | Out-Null}
    }
    #===================================================================================================
    #   Template Registry
    #===================================================================================================
    if (!(Test-Path "$SetOSDBuilderPathTemplates\Registry\AutoApply\Global")) {New-Item -Path "$SetOSDBuilderPathTemplates\Registry\AutoApply\Global" -ItemType Directory -Force | Out-Null}
    if (!(Test-Path "$SetOSDBuilderPathTemplates\Registry\AutoApply\Global $OSMArch")) {New-Item -Path "$SetOSDBuilderPathTemplates\Registry\AutoApply\Global $OSMArch" -ItemType Directory -Force | Out-Null}
    if (!(Test-Path "$SetOSDBuilderPathTemplates\Registry\AutoApply\$UpdateOS")) {New-Item -Path "$SetOSDBuilderPathTemplates\Registry\AutoApply\$UpdateOS" -ItemType Directory -Force | Out-Null}
    if ($OSMInstallationType -notlike "*Server*") {
        if (!(Test-Path "$SetOSDBuilderPathTemplates\Registry\AutoApply\$UpdateOS $OSMArch")) {New-Item -Path "$SetOSDBuilderPathTemplates\Registry\AutoApply\$UpdateOS $OSMArch" -ItemType Directory -Force | Out-Null}
    }
    if ($OSMInstallationType -notlike "*Server*" -and $OSMMajorVersion -eq 10) {
        if (!(Test-Path "$SetOSDBuilderPathTemplates\Registry\AutoApply\$UpdateOS $OSMArch $RegReleaseId")) {New-Item -Path "$SetOSDBuilderPathTemplates\Registry\AutoApply\$UpdateOS $OSMArch $RegReleaseId" -ItemType Directory -Force | Out-Null}
    }
    #===================================================================================================
    #   Template Scripts
    #===================================================================================================
    if (!(Test-Path "$SetOSDBuilderPathTemplates\Scripts\AutoApply\Global")) {New-Item -Path "$SetOSDBuilderPathTemplates\Scripts\AutoApply\Global" -ItemType Directory -Force | Out-Null}
    if (!(Test-Path "$SetOSDBuilderPathTemplates\Scripts\AutoApply\Global $OSMArch")) {New-Item -Path "$SetOSDBuilderPathTemplates\Scripts\AutoApply\Global $OSMArch" -ItemType Directory -Force | Out-Null}
    if (!(Test-Path "$SetOSDBuilderPathTemplates\Scripts\AutoApply\$UpdateOS")) {New-Item -Path "$SetOSDBuilderPathTemplates\Scripts\AutoApply\$UpdateOS" -ItemType Directory -Force | Out-Null}
    if ($OSMInstallationType -notlike "*Server*") {
        if (!(Test-Path "$SetOSDBuilderPathTemplates\Scripts\AutoApply\$UpdateOS $OSMArch")) {New-Item -Path "$SetOSDBuilderPathTemplates\Scripts\AutoApply\$UpdateOS $OSMArch" -ItemType Directory -Force | Out-Null}
    }
    if ($OSMInstallationType -notlike "*Server*" -and $OSMMajorVersion -eq 10) {
        if (!(Test-Path "$SetOSDBuilderPathTemplates\Scripts\AutoApply\$UpdateOS $OSMArch $RegReleaseId")) {New-Item -Path "$SetOSDBuilderPathTemplates\Scripts\AutoApply\$UpdateOS $OSMArch $RegReleaseId" -ItemType Directory -Force | Out-Null}
    }
}