<#
.SYNOPSIS
Returns all Operating Systems in OSDBuilder\OSMedia

.DESCRIPTION
Returns all Operating Systems in OSDBuilder\OSMedia as a PowerShell Custom Object

.LINK
https://osdbuilder.osdeploy.com/module/functions/osmedia/get-osmedia

.PARAMETER GridView
Displays results in PowerShell ISE GridView with an added PassThru Parameter.  This can also be displayed with the following command
Get-OSMedia -Passthru | Out-GridView

.PARAMETER OSArch
OSMedia Architecture

.PARAMETER OSInstallationType
OSMedia InstallationType

.PARAMETER OSMajorVersion
OSMedia MajorVersion

.PARAMETER OSReleaseId
OSMedia ReleaseId

.PARAMETER Revision
OK (Latest) or Superseded

.PARAMETER Updates
OK (Current) or Update (needs updates)
#>
function Get-OSMedia {
    [CmdletBinding()]
    PARAM (
        #===================================================================================================
        #   Basic
        #===================================================================================================
        [switch]$GridView,
        #===================================================================================================
        #   Filters
        #===================================================================================================
        [ValidateSet('x64','x86')]
        [string]$OSArch,
        [ValidateSet('Client','Server')]
        [string]$OSInstallationType,
        [ValidateSet(6,10)]
        [string]$OSMajorVersion,
        [ValidateSet (1903,1809,1803,1709,1703,1607,1511,1507,7601,7603)]
        [string]$OSReleaseId,
        #===================================================================================================
        #   Status
        #===================================================================================================
        [ValidateSet('OK','Superseded')]
        [string]$Revision,
        [ValidateSet('OK','Update')]
        [string]$Updates
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
        #   Get OSMedia
        #===================================================================================================
        $AllOSMedia = @()
        $AllOSMedia = Get-ChildItem -Path "$OSDBuilderOSImport","$OSDBuilderOSMedia" -Directory | Select-Object -Property * | `
        Where-Object {Test-Path $(Join-Path $_.FullName "info\xml\Get-WindowsImage.xml")}
        #===================================================================================================
    }

    PROCESS {
        $OSMedia = foreach ($Item in $AllOSMedia) {
            #===================================================================================================
            #   Get Windows Image Information
            #===================================================================================================
            $OSMediaPath = $($Item.FullName)
            Write-Verbose "OSMedia Full Path: $OSMediaPath"

            if ($OSMediaPath -match '\\OSImport\\') {$MediaType = 'OSImport'}
            else {$MediaType = 'OSMedia'}
            
            $OSMWindowsImage = @()
            $OSMWindowsImage = Import-Clixml -Path "$OSMediaPath\info\xml\Get-WindowsImage.xml"
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
            #   Guid
            #===================================================================================================
            #   $OSMWindowsImage | ForEach {$_.PSObject.Properties.Remove('Guid')}
            $OSMGuid = $($OSMWindowsImage.OSMGuid)
            if (-not ($OSMGuid)) {
                $OSMGuid = $(New-Guid)
                $OSMWindowsImage | Add-Member -Type NoteProperty -Name "OSMGuid" -Value $OSMGuid
                $OSMWindowsImage | Out-File "$OSMediaPath\WindowsImage.txt"
                $OSMWindowsImage | Out-File "$OSMediaPath\info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsImage.txt"
                $OSMWindowsImage | Export-Clixml -Path "$OSMediaPath\info\xml\Get-WindowsImage.xml"
                $OSMWindowsImage | Export-Clixml -Path "$OSMediaPath\info\xml\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsImage.xml"
                $OSMWindowsImage | ConvertTo-Json | Out-File "$OSMediaPath\info\json\Get-WindowsImage.json"
                $OSMWindowsImage | ConvertTo-Json | Out-File "$OSMediaPath\info\json\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsImage.json"
                (Get-Content "$OSMediaPath\WindowsImage.txt") | Where-Object {$_.Trim(" `t")} | Set-Content "$OSMediaPath\WindowsImage.txt"
                Write-Verbose "Guid (New): $OSMGuid"
            } else {
                Write-Verbose "Guid: $OSMGuid"
            }
            #===================================================================================================
            #   Registry ReleaseId
            #===================================================================================================
            $OSMRegistry = @()
            if (Test-Path "$OSMediaPath\info\xml\CurrentVersion.xml") {
                Write-Verbose "Registry: $OSMediaPath\info\xml\CurrentVersion.xml"
                $OSMRegistry = Import-Clixml -Path "$OSMediaPath\info\xml\CurrentVersion.xml"
            } else {
                Write-Verbose "Registry: $OSMediaPath\info\xml\CurrentVersion.xml (Not Found)"
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
            #   Template Drivers
            #===================================================================================================
            if (!(Test-Path "$OSDBuilderTemplates\Drivers\AutoApply\Global")) {New-Item -Path "$OSDBuilderTemplates\Drivers\AutoApply\Global" -ItemType Directory -Force | Out-Null}
            if (!(Test-Path "$OSDBuilderTemplates\Drivers\AutoApply\Global $OSMArch")) {New-Item -Path "$OSDBuilderTemplates\Drivers\AutoApply\Global $OSMArch" -ItemType Directory -Force | Out-Null}
            if (!(Test-Path "$OSDBuilderTemplates\Drivers\AutoApply\$UpdateOS")) {New-Item -Path "$OSDBuilderTemplates\Drivers\AutoApply\$UpdateOS" -ItemType Directory -Force | Out-Null}
            if ($OSMInstallationType -notlike "*Server*") {
                if (!(Test-Path "$OSDBuilderTemplates\Drivers\AutoApply\$UpdateOS $OSMArch")) {New-Item -Path "$OSDBuilderTemplates\Drivers\AutoApply\$UpdateOS $OSMArch" -ItemType Directory -Force | Out-Null}
            }
            if ($OSMInstallationType -notlike "*Server*" -and $OSMMajorVersion -eq 10) {
                if (!(Test-Path "$OSDBuilderTemplates\Drivers\AutoApply\$UpdateOS $OSMArch $OSMReleaseId")) {New-Item -Path "$OSDBuilderTemplates\Drivers\AutoApply\$UpdateOS $OSMArch $OSMReleaseId" -ItemType Directory -Force | Out-Null}
            }
            #===================================================================================================
            #   Template ExtraFiles
            #===================================================================================================
            if (!(Test-Path "$OSDBuilderTemplates\ExtraFiles\AutoApply\Global")) {New-Item -Path "$OSDBuilderTemplates\ExtraFiles\AutoApply\Global" -ItemType Directory -Force | Out-Null}
            if (!(Test-Path "$OSDBuilderTemplates\ExtraFiles\AutoApply\Global $OSMArch")) {New-Item -Path "$OSDBuilderTemplates\ExtraFiles\AutoApply\Global $OSMArch" -ItemType Directory -Force | Out-Null}
            if (!(Test-Path "$OSDBuilderTemplates\ExtraFiles\AutoApply\$UpdateOS")) {New-Item -Path "$OSDBuilderTemplates\ExtraFiles\AutoApply\$UpdateOS" -ItemType Directory -Force | Out-Null}
            if ($OSMInstallationType -notlike "*Server*") {
                if (!(Test-Path "$OSDBuilderTemplates\ExtraFiles\AutoApply\$UpdateOS $OSMArch")) {New-Item -Path "$OSDBuilderTemplates\ExtraFiles\AutoApply\$UpdateOS $OSMArch" -ItemType Directory -Force | Out-Null}
            }
            if ($OSMInstallationType -notlike "*Server*" -and $OSMMajorVersion -eq 10) {
                if (!(Test-Path "$OSDBuilderTemplates\ExtraFiles\AutoApply\$UpdateOS $OSMArch $OSMReleaseId")) {New-Item -Path "$OSDBuilderTemplates\ExtraFiles\AutoApply\$UpdateOS $OSMArch $OSMReleaseId" -ItemType Directory -Force | Out-Null}
            }
            #===================================================================================================
            #   Template Registry
            #===================================================================================================
            if (!(Test-Path "$OSDBuilderTemplates\Registry\AutoApply\Global")) {New-Item -Path "$OSDBuilderTemplates\Registry\AutoApply\Global" -ItemType Directory -Force | Out-Null}
            if (!(Test-Path "$OSDBuilderTemplates\Registry\AutoApply\Global $OSMArch")) {New-Item -Path "$OSDBuilderTemplates\Registry\AutoApply\Global $OSMArch" -ItemType Directory -Force | Out-Null}
            if (!(Test-Path "$OSDBuilderTemplates\Registry\AutoApply\$UpdateOS")) {New-Item -Path "$OSDBuilderTemplates\Registry\AutoApply\$UpdateOS" -ItemType Directory -Force | Out-Null}
            if ($OSMInstallationType -notlike "*Server*") {
                if (!(Test-Path "$OSDBuilderTemplates\Registry\AutoApply\$UpdateOS $OSMArch")) {New-Item -Path "$OSDBuilderTemplates\Registry\AutoApply\$UpdateOS $OSMArch" -ItemType Directory -Force | Out-Null}
            }
            if ($OSMInstallationType -notlike "*Server*" -and $OSMMajorVersion -eq 10) {
                if (!(Test-Path "$OSDBuilderTemplates\Registry\AutoApply\$UpdateOS $OSMArch $OSMReleaseId")) {New-Item -Path "$OSDBuilderTemplates\Registry\AutoApply\$UpdateOS $OSMArch $OSMReleaseId" -ItemType Directory -Force | Out-Null}
            }
            #===================================================================================================
            #   Template Scripts
            #===================================================================================================
            if (!(Test-Path "$OSDBuilderTemplates\Scripts\AutoApply\Global")) {New-Item -Path "$OSDBuilderTemplates\Scripts\AutoApply\Global" -ItemType Directory -Force | Out-Null}
            if (!(Test-Path "$OSDBuilderTemplates\Scripts\AutoApply\Global $OSMArch")) {New-Item -Path "$OSDBuilderTemplates\Scripts\AutoApply\Global $OSMArch" -ItemType Directory -Force | Out-Null}
            if (!(Test-Path "$OSDBuilderTemplates\Scripts\AutoApply\$UpdateOS")) {New-Item -Path "$OSDBuilderTemplates\Scripts\AutoApply\$UpdateOS" -ItemType Directory -Force | Out-Null}
            if ($OSMInstallationType -notlike "*Server*") {
                if (!(Test-Path "$OSDBuilderTemplates\Scripts\AutoApply\$UpdateOS $OSMArch")) {New-Item -Path "$OSDBuilderTemplates\Scripts\AutoApply\$UpdateOS $OSMArch" -ItemType Directory -Force | Out-Null}
            }
            if ($OSMInstallationType -notlike "*Server*" -and $OSMMajorVersion -eq 10) {
                if (!(Test-Path "$OSDBuilderTemplates\Scripts\AutoApply\$UpdateOS $OSMArch $OSMReleaseId")) {New-Item -Path "$OSDBuilderTemplates\Scripts\AutoApply\$UpdateOS $OSMArch $OSMReleaseId" -ItemType Directory -Force | Out-Null}
            }
            #===================================================================================================
            #   Get-WindowsPackage
            #===================================================================================================
            $OSMPackage = @()
            if (Test-Path "$OSMediaPath\info\xml\Get-WindowsPackage.xml") {
                Write-Verbose "Packages: $OSMediaPath\info\xml\Get-WindowsPackage.xml"
                $OSMPackage = Import-Clixml -Path "$OSMediaPath\info\xml\Get-WindowsPackage.xml"
            } else {
                Write-Verbose "Packages: $OSMediaPath\info\xml\Get-WindowsPackage.xml (Not Found)"
            }
            #===================================================================================================
            #   Sessions.xml
            #===================================================================================================
            $OSMSessions = @()
            if (Test-Path "$OSMediaPath\Sessions.xml") {
                Export-SessionsXmlOS -OSMediaPath "$OSMediaPath"
            }

            if (Test-Path "$OSMediaPath\info\xml\Sessions.xml") {
                $OSMSessions = Import-Clixml -Path "$OSMediaPath\info\xml\Sessions.xml" | Where-Object {$_.targetState -eq 'Installed'} | Sort-Object id
            } else {
                Write-Verbose "Sessions: $OSMediaPath\info\xml\Sessions.xml (Not Found)"
            }
            #===================================================================================================
            #   Verify Updates
            #===================================================================================================
            $VerifyUpdates = @()
            $VerifyUpdates = $OSDUpdates | Sort-Object -Property CreationDate | `
            Where-Object {$_.UpdateOS -like "*$UpdateOS*"} | Where-Object {$_.UpdateBuild -like "*$OSMReleaseId*"} | `
            Where-Object {$_.UpdateArch -like "*$($OSMArch)*"} | Where-Object {$_.UpdateGroup -notlike "*Setup*"} | `
            Where-Object {$_.UpdateGroup -ne ''} | Where-Object {$_.UpdateGroup -ne 'Optional'}

            $KBPattern = '(\d{4,7})'
            
            $OSMUpdateStatus = 'OK'
            foreach ($OSMUpdate in $VerifyUpdates) {

                #Write-Verbose "FileName: $($OSMUpdate.FileName)"
                #$FileKBNumber = [regex]::matches($OSMUpdate.FileName, $KBPattern).Value
                #Write-Verbose "FileKBNumber: $($FileKBNumber)"

                #if ($OSMSessions | Where-Object {$_.KBNumber -match "$FileKBNumber"}) {
                if ($OSMSessions | Where-Object {$_.KBNumber -match "$($OSMUpdate.FileKBNumber)"}) {
                    Write-Verbose "Installed: $($OSMUpdate.Title) $($OSMUpdate.FileName)"
                } else {
                    Write-Verbose "Not Installed: $($OSMUpdate.Title) $($OSMUpdate.FileName)"
                    $OSMUpdateStatus = 'Update'
                }
            }
            #===================================================================================================
            #   Correct WinSE
            #===================================================================================================
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
            #===================================================================================================
            #   Create Object
            #===================================================================================================
            $ObjectProperties = @{
                MediaType           = $MediaType

                ModifiedTime        = [datetime]$OSMWindowsImage.ModifiedTime
                Name                = $Item.Name

                Revision            = 'Superseded'
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
                FullName            = $Item.FullName
                CreatedTime         = [datetime]$OSMWindowsImage.CreatedTime

                OSMFamilyV1         = $OSMFamilyV1
                OSMGuid             = $OSMGuid
            }
            New-Object -TypeName PSObject -Property $ObjectProperties
            Write-Verbose ""
        }
        #===================================================================================================
        #   Revision
        #===================================================================================================
        $OSMedia | Sort-Object OSMFamily, UBR -Descending | Group-Object OSMFamily | ForEach-Object {$_.Group | Select-Object -First 1} | foreach {$_.Revision = 'OK'}
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
        #===================================================================================================
        #   Results
        #===================================================================================================
        if ($GridView.IsPresent) {
            $OSMedia | Select-Object MediaType,ModifiedTime,`
            Revision,Updates,`
            Name,OperatingSystem,Arch,ReleaseId,`
            Version,MajorVersion,MinorVersion,Build,UBR,`
            Languages,EditionId,InstallationType,`
            ImageName,OSMFamily,`
            FullName,CreatedTime,OSMGuid | `
            Sort-Object Name | Out-GridView -PassThru -Title 'OSMedia'
        } else {
            $OSMedia | Select-Object MediaType,ModifiedTime,`
            Revision,Updates,`
            Name,OperatingSystem,Arch,ReleaseId,`
            Version,MajorVersion,MinorVersion,Build,UBR,`
            Languages,EditionId,InstallationType,`
            ImageName,OSMFamily,`
            FullName,CreatedTime,OSMGuid,OSMFamilyV1 | `
            Sort-Object Name
        }
        #===================================================================================================
    }

    END {}
}