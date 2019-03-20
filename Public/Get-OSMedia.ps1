<#
.SYNOPSIS
Returns all Operating Systems in OSDBuilder\OSMedia

.DESCRIPTION
Returns all Operating Systems in OSDBuilder\OSMedia as a PowerShell Custom Object

.LINK
https://www.osdeploy.com/osdbuilder/docs/functions/osmedia/get-osmedia

.PARAMETER GridView
Displays results in PowerShell ISE GridView with an added PassThru Parameter.  This can also be displayed with the following command
Get-OSMedia | Out-GridView
#>
function Get-OSMedia {
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
    #   Get OSMedia
        $AllOSMedia = @()
        $AllOSMedia = Get-ChildItem -Path "$OSDBuilderOSMedia" -Directory | Select-Object -Property * | `
        Where-Object {Test-Path $(Join-Path $_.FullName "info\xml\Get-WindowsImage.xml")}
    #===================================================================================================
    }

    PROCESS {
        $OSMedia = foreach ($Item in $AllOSMedia) {
        #===================================================================================================
        #   Get Windows Image Information
            $OSMediaPath = $($Item.FullName)
            Write-Verbose "OSMedia Full Path: $OSMediaPath"
            
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
        #   Guid
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

            Write-Verbose "ReleaseId: $OSMReleaseId"
        #===================================================================================================
        #   Template Drivers
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
            $OSMPackage = @()
            if (Test-Path "$OSMediaPath\info\xml\Get-WindowsPackage.xml") {
                Write-Verbose "Packages: $OSMediaPath\info\xml\Get-WindowsPackage.xml"
                $OSMPackage = Import-Clixml -Path "$OSMediaPath\info\xml\Get-WindowsPackage.xml"
            } else {
                Write-Verbose "Packages: $OSMediaPath\info\xml\Get-WindowsPackage.xml (Not Found)"
            }
        #===================================================================================================
        #   Sessions.xml
            $OSMSessions = @()
            if (Test-Path "$OSMediaPath\Sessions.xml") {
                OSD-SessionsConvert -OSMediaPath "$OSMediaPath"
            }

            if (Test-Path "$OSMediaPath\info\xml\Sessions.xml") {
                $OSMSessions = Import-Clixml -Path "$OSMediaPath\info\xml\Sessions.xml" | Where-Object {$_.targetState -eq 'Installed'} | Sort-Object id
            } else {
                Write-Verbose "Sessions: $OSMediaPath\info\xml\Sessions.xml (Not Found)"
            }
            
        #===================================================================================================
        #   Adobe
            $LatestAdobe = @()
            $LatestAdobe = $OSDUpdates | Sort-Object -Property CreationDate -Descending | `
            Where-Object {$_.UpdateOS -like "*$UpdateOS*"} | Where-Object {$_.UpdateBuild -like "*$OSMReleaseId*"} | `
            Where-Object {$_.UpdateArch -like "*$($Arch)*"} | Where-Object {$_.UpdateGroup -like "*Adobe*"} | `
            Select-Object -First 1

            $InstalledAdobe = $OSMPackage | Where-Object {$_.PackageName -like "*$($LatestAdobe.KBNumber)*"}
            if ($null -eq $LatestAdobe) {$LatestAdobe = 'Not Applicable'}
            elseif ($null -eq $InstalledAdobe) {
                Write-Verbose "LatestAdobe: $($LatestAdobe.Title) (Not Installed)"
                #$LatestAdobe = "KB$($LatestAdobe.KBNumber)"
                $LatestAdobe = ''
            } else {
                Write-Verbose "LatestAdobe: $($LatestAdobe.Title) (Installed)"
                $LatestAdobe = 'Latest'
            }
        #===================================================================================================
        #   SSU Servicing Stack
            $LatestSSU = @()
            $LatestSSU = $OSDUpdates | Sort-Object -Property CreationDate -Descending | `
            Where-Object {$_.UpdateOS -like "*$UpdateOS*"} | Where-Object {$_.UpdateBuild -like "*$OSMReleaseId*"} | `
            Where-Object {$_.UpdateArch -like "*$($Arch)*"} | Where-Object {$_.UpdateGroup -like "*SSU*"} | `
            Select-Object -First 1

            $InstalledSSU = $OSMPackage | Where-Object {$_.PackageName -like "*$($LatestSSU.KBNumber)*"}
            if ($null -eq $InstalledSSU) {
                Write-Verbose "LatestSSU: $($LatestSSU.Title) (Not Installed)"
            # $LatestSSU = "KB$($LatestSSU.KBNumber)"
                $LatestSSU = ''
            } else {
                Write-Verbose "LatestSSU: $($LatestSSU.Title) (Installed)"
                $LatestSSU = 'Latest'
            }
        #===================================================================================================
        #   LCU Cumulative Update
            $LatestLCU = @()
            $LatestLCU = $OSDUpdates | Sort-Object -Property CreationDate -Descending | `
            Where-Object {$_.UpdateOS -like "*$UpdateOS*"} | Where-Object {$_.UpdateBuild -like "*$OSMReleaseId*"} | `
            Where-Object {$_.UpdateArch -like "*$($Arch)*"} | Where-Object {$_.UpdateGroup -like "*LCU*"} | `
            Select-Object -First 1

            $InstalledLCU = $OSMSessions | Where-Object {$_.KBNumber -like "*$($LatestLCU.KBNumber)*"}

            if (!(Test-Path "$OSMediaPath\info\Sessions.xml")) {
                Write-Verbose "LatestLCU: Sessions.xml required for validation"
                $LatestLCU = 'Repair'
            } elseif ($null -eq $InstalledLCU) {
                Write-Verbose "LatestLCU: $($LatestLCU.Title) (Not Installed)"
                $LatestLCU = ''
            } else {
                Write-Verbose "LatestLCU: $($LatestLCU.Title) (Installed)"
                $LatestLCU = 'Latest'
            }
        #===================================================================================================
        #   Correct WinSE
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
            $ObjectProperties = @{
                MediaType           = 'OSMedia'

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
                Servicing           = $LatestSSU
                Cumulative          = $LatestLCU
                Adobe               = $LatestAdobe
                FullName            = $Item.FullName
                CreatedTime         = [datetime]$OSMWindowsImage.CreatedTime

                OSMFamilyV1         = $OSMFamilyV1
                OSMGuid             = $OSMGuid
            }
            New-Object -TypeName PSObject -Property $ObjectProperties
            Write-Verbose ""
        }
    #===================================================================================================
    #   Output
        if ($GridView.IsPresent) {
            $OSMedia | Select-Object MediaType,`
            ModifiedTime,Name,OSMFamily,ImageName,`
            OperatingSystem,Arch,ReleaseId,`
            Version,MajorVersion,MinorVersion,Build,UBR,`
            Languages,`
            EditionId,InstallationType,Servicing,Cumulative,Adobe,FullName,CreatedTime,OSMGuid | `
            Sort-Object -Property Name | Out-GridView -PassThru -Title 'OSMedia'
        } else {
            $OSMedia | Select-Object MediaType,`
            ModifiedTime,Name,OSMFamily,ImageName,`
            OperatingSystem,Arch,ReleaseId,`
            Version,MajorVersion,MinorVersion,Build,UBR,`
            Languages,`
            EditionId,InstallationType,Servicing,Cumulative,Adobe,FullName,CreatedTime,OSMGuid,OSMFamilyV1 | `
            Sort-Object -Property Name
        }
    }

    END {}
}