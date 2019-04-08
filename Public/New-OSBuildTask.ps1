<#
.SYNOPSIS
Creates a JSON Task for use with New-OSBuild

.DESCRIPTION
Creates a JSON Task for use with New-OSBuild

.LINK
http://osdbuilder.com/docs/functions/osbuild/new-osbuildtask

.PARAMETER TaskName
Name of the Task to create

.PARAMETER CustomName
Custom Name of the OSBuild

.PARAMETER DisableFeature
Disables an Enabled Windows Optional Feature

.PARAMETER EnableNetFX3
Enables NetFX3 in the OSBuild

.PARAMETER EnableFeature
Enables a Disabled Windows Optional Feature

.PARAMETER RemoveAppx
Displays a GridView to select Appx Provisioned Packages to Remove

.PARAMETER RemoveCapability
Displays a GridView to select Windows Capabilities to Remove

.PARAMETER RemovePackage
Displays a GridView to select Windows Packages to Remove

.PARAMETER WinPEAutoExtraFiles
Adds WinPE Auto Extra Files

#>
function New-OSBuildTask {
    [CmdletBinding(DefaultParameterSetName='Basic')]
    PARAM (
        [Parameter(Mandatory)]
        [ValidateSet('Task','Template')]
        [string]$Kind,
        [Parameter(Mandatory)]
        [string]$TaskName,
        #===================================================================================================
        #   Basic
        #===================================================================================================
        [string]$CustomName,
        [switch]$EnableNetFX3,
        [switch]$WinPEAutoExtraFiles,
        [switch]$RemoveAppx,
        [switch]$RemoveCapability,
        [switch]$RemovePackage,
        [switch]$DisableFeature,
        [switch]$EnableFeature,
        #===================================================================================================
        #   Content
        #===================================================================================================
        [Parameter(ParameterSetName='All')]
        [switch]$ContentDrivers,

        [Parameter(ParameterSetName='All')]
        [switch]$ContentExtraFiles,

        [Parameter(ParameterSetName='All')]
        [switch]$ContentFeaturesOnDemand,

        [Parameter(ParameterSetName='All')]
        [switch]$ContentPackages,
        
        [Parameter(ParameterSetName='All')]
        [switch]$ContentScripts,
        
        [Parameter(ParameterSetName='All')]
        [switch]$ContentStartLayout,
        
        [Parameter(ParameterSetName='All')]
        [switch]$ContentUnattend,
        #===================================================================================================
        #   WinPE
        #===================================================================================================
        [Parameter(ParameterSetName='All')]
        [switch]$ContentWinPEADK,
        [Parameter(ParameterSetName='All')]
        [switch]$ContentWinPEDart,
        [Parameter(ParameterSetName='All')]
        [switch]$ContentWinPEDrivers,
        [Parameter(ParameterSetName='All')]
        [switch]$ContentWinPEExtraFiles,
        [Parameter(ParameterSetName='All')]
        [switch]$ContentWinPEScripts,
        #===================================================================================================
        #   Language
        #===================================================================================================
        [Parameter(ParameterSetName='All')]
        [switch]$ContentLanguagePackages,

        #[ValidateSet('ar-SA','bg-BG','zh-CN','zh-TW','hr-HR','cs-CZ','da-DK','nl-NL','en-US','en-GB','et-EE','fi-FI','fr-CA','fr-FR','de-DE','el-GR','he-IL','hu-HU','it-IT','ja-JP','ko-KR','lv-LV','lt-LT','nb-NO','pl-PL','pt-BR','pt-PT','ro-RO','ru-RU','sr-Latn-RS','sk-SK','sl-SI','es-MX','es-ES','sv-SE','th-TH','tr-TR','uk-UA')]
        #[ValidateSet('af-ZA','am-ET','as-IN','az-Latn-AZ','be-BY','bn-BD','bn-IN','bs-Latn-BA','ca-ES','ca-ES-valencia','chr-CHER-US','cy-GB','eu-ES','fa-IR','fil-PH','ga-IE','gd-GB','gl-ES','gu-IN','ha-Latn-NG','hi-IN','hy-AM','id-ID','ig-NG','is-IS','ka-GE','kk-KZ','km-KH','kn-IN','kok-IN','ku-ARAB-IQ','ky-KG','lb-LU','lo-LA','mi-NZ','mk-MK','ml-IN','mn-MN','mr-IN','ms-MY','mt-MT','ne-NP','nn-NO','nso-ZA','or-IN','pa-Arab-PK','pa-IN','prs-AF','quc-Latn-GT','quz-PE','rw-RW','sd-Arab-PK','si-LK','sq-AL','sr-Cyrl-BA','sr-Cyrl-RS','sw-KE','ta-IN','te-IN','tg-Cyrl-TJ','ti-ET','tk-TM','tn-ZA','tt-RU','ug-CN','ur-PK','uz-Latn-UZ','vi-VN','wo-SN','xh-ZA','yo-NG','zu-ZA')]
        [Parameter(ParameterSetName='All')]
        [ValidateSet('ar-SA','bg-BG','zh-CN','zh-TW','hr-HR','cs-CZ','da-DK','nl-NL','en-US','en-GB','et-EE','fi-FI','fr-CA','fr-FR','de-DE','el-GR','he-IL','hu-HU','it-IT','ja-JP','ko-KR','lv-LV','lt-LT','nb-NO','pl-PL','pt-BR','pt-PT','ro-RO','ru-RU','sr-Latn-RS','sk-SK','sl-SI','es-MX','es-ES','sv-SE','th-TH','tr-TR','uk-UA','af-ZA','am-ET','as-IN','az-Latn-AZ','be-BY','bn-BD','bn-IN','bs-Latn-BA','ca-ES','ca-ES-valencia','chr-CHER-US','cy-GB','eu-ES','fa-IR','fil-PH','ga-IE','gd-GB','gl-ES','gu-IN','ha-Latn-NG','hi-IN','hy-AM','id-ID','ig-NG','is-IS','ka-GE','kk-KZ','km-KH','kn-IN','kok-IN','ku-ARAB-IQ','ky-KG','lb-LU','lo-LA','mi-NZ','mk-MK','ml-IN','mn-MN','mr-IN','ms-MY','mt-MT','ne-NP','nn-NO','nso-ZA','or-IN','pa-Arab-PK','pa-IN','prs-AF','quc-Latn-GT','quz-PE','rw-RW','sd-Arab-PK','si-LK','sq-AL','sr-Cyrl-BA','sr-Cyrl-RS','sw-KE','ta-IN','te-IN','tg-Cyrl-TJ','ti-ET','tk-TM','tn-ZA','tt-RU','ug-CN','ur-PK','uz-Latn-UZ','vi-VN','wo-SN','xh-ZA','yo-NG','zu-ZA')]
        [string]$SetAllIntl,

        [Parameter(ParameterSetName='All')]
        [string]$SetInputLocale,

        [Parameter(ParameterSetName='All')]
        [ValidateSet('ar-SA','bg-BG','zh-CN','zh-TW','hr-HR','cs-CZ','da-DK','nl-NL','en-US','en-GB','et-EE','fi-FI','fr-CA','fr-FR','de-DE','el-GR','he-IL','hu-HU','it-IT','ja-JP','ko-KR','lv-LV','lt-LT','nb-NO','pl-PL','pt-BR','pt-PT','ro-RO','ru-RU','sr-Latn-RS','sk-SK','sl-SI','es-MX','es-ES','sv-SE','th-TH','tr-TR','uk-UA','af-ZA','am-ET','as-IN','az-Latn-AZ','be-BY','bn-BD','bn-IN','bs-Latn-BA','ca-ES','ca-ES-valencia','chr-CHER-US','cy-GB','eu-ES','fa-IR','fil-PH','ga-IE','gd-GB','gl-ES','gu-IN','ha-Latn-NG','hi-IN','hy-AM','id-ID','ig-NG','is-IS','ka-GE','kk-KZ','km-KH','kn-IN','kok-IN','ku-ARAB-IQ','ky-KG','lb-LU','lo-LA','mi-NZ','mk-MK','ml-IN','mn-MN','mr-IN','ms-MY','mt-MT','ne-NP','nn-NO','nso-ZA','or-IN','pa-Arab-PK','pa-IN','prs-AF','quc-Latn-GT','quz-PE','rw-RW','sd-Arab-PK','si-LK','sq-AL','sr-Cyrl-BA','sr-Cyrl-RS','sw-KE','ta-IN','te-IN','tg-Cyrl-TJ','ti-ET','tk-TM','tn-ZA','tt-RU','ug-CN','ur-PK','uz-Latn-UZ','vi-VN','wo-SN','xh-ZA','yo-NG','zu-ZA')]
        [string]$SetSKUIntlDefaults,

        [Parameter(ParameterSetName='All')]
        [ValidateSet('ar-SA','bg-BG','zh-CN','zh-TW','hr-HR','cs-CZ','da-DK','nl-NL','en-US','en-GB','et-EE','fi-FI','fr-CA','fr-FR','de-DE','el-GR','he-IL','hu-HU','it-IT','ja-JP','ko-KR','lv-LV','lt-LT','nb-NO','pl-PL','pt-BR','pt-PT','ro-RO','ru-RU','sr-Latn-RS','sk-SK','sl-SI','es-MX','es-ES','sv-SE','th-TH','tr-TR','uk-UA','af-ZA','am-ET','as-IN','az-Latn-AZ','be-BY','bn-BD','bn-IN','bs-Latn-BA','ca-ES','ca-ES-valencia','chr-CHER-US','cy-GB','eu-ES','fa-IR','fil-PH','ga-IE','gd-GB','gl-ES','gu-IN','ha-Latn-NG','hi-IN','hy-AM','id-ID','ig-NG','is-IS','ka-GE','kk-KZ','km-KH','kn-IN','kok-IN','ku-ARAB-IQ','ky-KG','lb-LU','lo-LA','mi-NZ','mk-MK','ml-IN','mn-MN','mr-IN','ms-MY','mt-MT','ne-NP','nn-NO','nso-ZA','or-IN','pa-Arab-PK','pa-IN','prs-AF','quc-Latn-GT','quz-PE','rw-RW','sd-Arab-PK','si-LK','sq-AL','sr-Cyrl-BA','sr-Cyrl-RS','sw-KE','ta-IN','te-IN','tg-Cyrl-TJ','ti-ET','tk-TM','tn-ZA','tt-RU','ug-CN','ur-PK','uz-Latn-UZ','vi-VN','wo-SN','xh-ZA','yo-NG','zu-ZA')]
        [string]$SetSetupUILang,

        [Parameter(ParameterSetName='All')]
        [string]$SetSysLocale,

        [Parameter(ParameterSetName='All')]
        [ValidateSet('ar-SA','bg-BG','zh-CN','zh-TW','hr-HR','cs-CZ','da-DK','nl-NL','en-US','en-GB','et-EE','fi-FI','fr-CA','fr-FR','de-DE','el-GR','he-IL','hu-HU','it-IT','ja-JP','ko-KR','lv-LV','lt-LT','nb-NO','pl-PL','pt-BR','pt-PT','ro-RO','ru-RU','sr-Latn-RS','sk-SK','sl-SI','es-MX','es-ES','sv-SE','th-TH','tr-TR','uk-UA','af-ZA','am-ET','as-IN','az-Latn-AZ','be-BY','bn-BD','bn-IN','bs-Latn-BA','ca-ES','ca-ES-valencia','chr-CHER-US','cy-GB','eu-ES','fa-IR','fil-PH','ga-IE','gd-GB','gl-ES','gu-IN','ha-Latn-NG','hi-IN','hy-AM','id-ID','ig-NG','is-IS','ka-GE','kk-KZ','km-KH','kn-IN','kok-IN','ku-ARAB-IQ','ky-KG','lb-LU','lo-LA','mi-NZ','mk-MK','ml-IN','mn-MN','mr-IN','ms-MY','mt-MT','ne-NP','nn-NO','nso-ZA','or-IN','pa-Arab-PK','pa-IN','prs-AF','quc-Latn-GT','quz-PE','rw-RW','sd-Arab-PK','si-LK','sq-AL','sr-Cyrl-BA','sr-Cyrl-RS','sw-KE','ta-IN','te-IN','tg-Cyrl-TJ','ti-ET','tk-TM','tn-ZA','tt-RU','ug-CN','ur-PK','uz-Latn-UZ','vi-VN','wo-SN','xh-ZA','yo-NG','zu-ZA')]
        [string]$SetUILang,

        [Parameter(ParameterSetName='All')]
        [ValidateSet('ar-SA','bg-BG','zh-CN','zh-TW','hr-HR','cs-CZ','da-DK','nl-NL','en-US','en-GB','et-EE','fi-FI','fr-CA','fr-FR','de-DE','el-GR','he-IL','hu-HU','it-IT','ja-JP','ko-KR','lv-LV','lt-LT','nb-NO','pl-PL','pt-BR','pt-PT','ro-RO','ru-RU','sr-Latn-RS','sk-SK','sl-SI','es-MX','es-ES','sv-SE','th-TH','tr-TR','uk-UA','af-ZA','am-ET','as-IN','az-Latn-AZ','be-BY','bn-BD','bn-IN','bs-Latn-BA','ca-ES','ca-ES-valencia','chr-CHER-US','cy-GB','eu-ES','fa-IR','fil-PH','ga-IE','gd-GB','gl-ES','gu-IN','ha-Latn-NG','hi-IN','hy-AM','id-ID','ig-NG','is-IS','ka-GE','kk-KZ','km-KH','kn-IN','kok-IN','ku-ARAB-IQ','ky-KG','lb-LU','lo-LA','mi-NZ','mk-MK','ml-IN','mn-MN','mr-IN','ms-MY','mt-MT','ne-NP','nn-NO','nso-ZA','or-IN','pa-Arab-PK','pa-IN','prs-AF','quc-Latn-GT','quz-PE','rw-RW','sd-Arab-PK','si-LK','sq-AL','sr-Cyrl-BA','sr-Cyrl-RS','sw-KE','ta-IN','te-IN','tg-Cyrl-TJ','ti-ET','tk-TM','tn-ZA','tt-RU','ug-CN','ur-PK','uz-Latn-UZ','vi-VN','wo-SN','xh-ZA','yo-NG','zu-ZA')]
        [string]$SetUILangFallback,

        [Parameter(ParameterSetName='All')]
        [string]$SetUserLocale,

        [Parameter(ParameterSetName='All')]
        [switch]$SourcesLanguageCopy
        #===================================================================================================
    )

    BEGIN {
        #Write-Host '========================================================================================' -ForegroundColor DarkGray
        #Write-Host "$($MyInvocation.MyCommand.Name) BEGIN" -ForegroundColor Green

        #===================================================================================================
        Write-Verbose '19.1.1 Initialize OSDBuilder'
        #===================================================================================================
        Get-OSDBuilder -CreatePaths -HideDetails
    }
    
    PROCESS {
        Write-Host '========================================================================================' -ForegroundColor DarkGray
        Write-Host "$($MyInvocation.MyCommand.Name) PROCESS" -ForegroundColor Green
        
        #===================================================================================================
        #   19.1.1 Validate Administrator Rights
        #===================================================================================================
        if (!([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
            Write-Warning 'OSDBuilder: This function needs to be run as Administrator'
            Pause
			Exit
        }
        #===================================================================================================
        #   Set Task Name
        #===================================================================================================
        $Task = @()
        $ExistingTask = @()
        $TaskName = "$TaskName"
        if ($Kind -eq 'Task') {
            $TaskPath = "$OSDBuilderTasks\OSBuild $TaskName.json"
            if (Test-Path "$TaskPath") {$ExistingTask = Get-Content "$TaskPath" | ConvertFrom-Json}
        }
        if ($Kind -eq 'Template') {
            $TaskPath = "$OSDBuilderTemplates\OSBuild $TaskName.json"
        }
        #===================================================================================================
        #   Set Task Name
        #===================================================================================================
        Write-Host '========================================================================================' -ForegroundColor DarkGray
        Write-Host "New-OSBuild $Kind Information" -ForegroundColor Green
        Write-Host "-$Kind Name:                    $TaskName"
        Write-Host "-$Kind Path:                    $TaskPath"
        Write-Host "-Custom Name:                   $CustomName"
        Write-Host "-DotNet 3.5:                    $EnableNetFX3"
        Write-Host "-SetAllIntl:                    $SetAllIntl"
        Write-Host "-SetInputLocale:                $SetInputLocale"
        Write-Host "-SetSKUIntlDefaults:            $SetSKUIntlDefaults"
        Write-Host "-SetSetupUILang:                $SetSetupUILang"
        Write-Host "-SetSysLocale:                  $SetSysLocale"
        Write-Host "-SetUILang:                     $SetUILang"
        Write-Host "-SetUILangFallback:             $SetUILangFallback"
        Write-Host "-SetUserLocale:                 $SetUserLocale"
        Write-Host "-WinPEAutoExtraFiles:           $WinPEAutoExtraFiles"

        #===================================================================================================
        Write-Verbose '19.1.1 Validate Task'
        #===================================================================================================
        if (Test-Path $TaskPath) {
            Write-Host '========================================================================================' -ForegroundColor DarkGray
            Write-Warning "Task already exists at $TaskPath"
            Write-Warning "Content will be updated!"
        }

        #===================================================================================================
        Write-Verbose '19.3.26 Get-OSMedia'
        #===================================================================================================
        $OSMedia = @()
        $OSMedia = Get-OSMedia -Revision OK -OSMajorVersion 10

        if ($TaskName -like "*x64*") {$OSMedia = $OSMedia | Where-Object {$_.Arch -eq 'x64'}}
        if ($TaskName -like "*x86*") {$OSMedia = $OSMedia | Where-Object {$_.Arch -eq 'x86'}}
        if ($TaskName -like "*1511*") {$OSMedia = $OSMedia | Where-Object {$_.ReleaseId -eq '1511'}}
        if ($TaskName -like "*1607*") {$OSMedia = $OSMedia | Where-Object {$_.ReleaseId -eq '1607'}}
        if ($TaskName -like "*1703*") {$OSMedia = $OSMedia | Where-Object {$_.ReleaseId -eq '1703'}}
        if ($TaskName -like "*1709*") {$OSMedia = $OSMedia | Where-Object {$_.ReleaseId -eq '1709'}}
        if ($TaskName -like "*1803*") {$OSMedia = $OSMedia | Where-Object {$_.ReleaseId -eq '1803'}}
        if ($TaskName -like "*1809*") {$OSMedia = $OSMedia | Where-Object {$_.ReleaseId -eq '1809'}}

        $OSMedia = $OSMedia | Out-GridView -OutputMode Single -Title "Select a Source OSMedia to use for this Task (Cancel to Exit)"
        if ($null -eq $OSMedia) {
            Write-Warning "Source OSMedia was not selected . . . Exiting!"
            Return
        }

        #===================================================================================================
        Write-Verbose '19.1.7 Get Windows Image Information'
        #===================================================================================================
        $WindowsImage = Get-WindowsImage -ImagePath "$($OSMedia.FullName)\OS\sources\install.wim" -Index 1 | Select-Object -Property *

        #===================================================================================================
        Write-Verbose '19.1.7 Source OSMedia Windows Image Information'
        #===================================================================================================
        Write-Host '========================================================================================' -ForegroundColor DarkGray
        Write-Host "Source OSMedia Windows Image Information" -ForegroundColor Green
        Write-Host "-OSMedia Family:                $($OSMedia.OSMFamily)"
        Write-Host "-OSMedia Guid:                  $($OSMedia.OSMGuid)"
        Write-Host "-OSMedia Name:                  $($OSMedia.Name)"
        Write-Host "-OSMedia FullName:              $($OSMedia.FullName)"
        Write-Host "-Image File:                    $($OSMedia.FullName)\OS\sources\install.wim"
        Write-Host "-Image Index:                   1"
        Write-Host "-Image Name:                    $($OSMedia.ImageName)"
        Write-Host "-Architecture:                  $($OSMedia.Arch)"
        Write-Host "-ReleaseId:                     $($OSMedia.ReleaseId)"
        Write-Host "-UBR:                           $($OSMedia.UBR)"
        Write-Host "-Edition:                       $($OSMedia.EditionId)"
        Write-Host "-InstallationType:              $($OSMedia.InstallationType)"
        Write-Host "-Languages:                     $($OSMedia.Languages)"
        Write-Host "-Version:                       $($WindowsImage.Version)"
        Write-Host "-Major Version:                 $($OSMedia.MajorVersion)"
        Write-Host "-Minor Version:                 $($WindowsImage.MinorVersion)"
        Write-Host "-Build:                         $($OSMedia.Build)"
        Write-Host "-SPBuild:                       $($WindowsImage.SPBuild)"
        Write-Host "-SPLevel:                       $($WindowsImage.SPLevel)"
        Write-Host "-Bootable:                      $($WindowsImage.ImageBootable)"
        Write-Host "-WimBoot:                       $($WindowsImage.WIMBoot)"
        Write-Host "-Created Time:                  $($OSMedia.CreatedTime)"
        Write-Host "-Modified Time:                 $($OSMedia.ModifiedTime)"
        
        #===================================================================================================
        Write-Verbose '19.1.1 Validate Registry CurrentVersion.xml'
        #===================================================================================================
        if ($null -eq $($OSMedia.ReleaseId)) {
            if (Test-Path "$($OSMedia.FullName)\info\xml\CurrentVersion.xml") {
                $RegCurrentVersion = Import-Clixml -Path "$($OSMedia.FullName)\info\xml\CurrentVersion.xml"
                $OSMedia.ReleaseId = $($RegCurrentVersion.ReleaseId)
                if ($($OSMedia.ReleaseId) -gt 1809) {
                    Write-Warning "OSDBuilder does not currently support this version of Windows ... Check for an updated version"
                }
            }
        }

        #===================================================================================================
        Write-Verbose '19.1.1 Set OSMedia.ReleaseId'
        #===================================================================================================
        if ($null -eq $($OSMedia.ReleaseId)) {
            if ($($OSMedia.Build) -eq 7601) {$OSMedia.ReleaseId = 7601}
            if ($($OSMedia.Build) -eq 10240) {$OSMedia.ReleaseId = 1507}
            if ($($OSMedia.Build) -eq 14393) {$OSMedia.ReleaseId = 1607}
            if ($($OSMedia.Build) -eq 15063) {$OSMedia.ReleaseId = 1703}
            if ($($OSMedia.Build) -eq 16299) {$OSMedia.ReleaseId = 1709}
            if ($($OSMedia.Build) -eq 17134) {$OSMedia.ReleaseId = 1803}
            if ($($OSMedia.Build) -eq 17763) {$OSMedia.ReleaseId = 1809}
        }
        #===================================================================================================
        Write-Host '========================================================================================' -ForegroundColor DarkGray
        #===================================================================================================
        #   Basic
        #===================================================================================================
        #===================================================================================================
        #   CustomName
        #===================================================================================================
        if ($ExistingTask.CustomName) {$CustomName = $ExistingTask.CustomName}
        #===================================================================================================
        #   EnableNetFX3
        #===================================================================================================
        if ($ExistingTask.EnableNetFX3 -eq $true) {$EnableNetFX3 = $true}
        #===================================================================================================
        #   WinPEAutoExtraFiles
        #===================================================================================================
        if ($ExistingTask.WinPEAutoExtraFiles -eq $true) {$WinPEAutoExtraFiles = $true}
        #===================================================================================================
        #   RemoveAppx
        #===================================================================================================
        Write-Host "RemoveAppx" -ForegroundColor Green
        if ($ExistingTask.RemoveAppxProvisionedPackage) {
            foreach ($Item in $ExistingTask.RemoveAppxProvisionedPackage) {
                Write-Host "$Item" -ForegroundColor DarkGray
            }
        }
        $RemoveAppxProvisionedPackage = $null
        if ($RemoveAppx.IsPresent) {
            $RemoveAppxProvisionedPackage = (Get-TaskRemoveAppxProvisionedPackage).PackageName
            $RemoveAppxProvisionedPackage = [array]$RemoveAppxProvisionedPackage + [array]$ExistingTask.RemoveAppxProvisionedPackage
            $RemoveAppxProvisionedPackage = $RemoveAppxProvisionedPackage | Sort-Object -Unique
        } else {
            if ($ExistingTask.RemoveAppxProvisionedPackage) {$RemoveAppxProvisionedPackage = $ExistingTask.RemoveAppxProvisionedPackage}
            #Write-Host "RemoveAppx: Select Appx Provisioned Packages to remove using Remove-AppxProvisionedPackage" -ForegroundColor Gray
        }
        #===================================================================================================
        #   RemoveCapability
        #===================================================================================================
        Write-Host "RemoveCapability" -ForegroundColor Green
        if ($ExistingTask.RemoveWindowsCapability) {
            foreach ($Item in $ExistingTask.RemoveWindowsCapability) {
                Write-Host "$Item" -ForegroundColor DarkGray
            }
        }
        $RemoveWindowsCapability = $null
        if ($RemoveCapability.IsPresent) {
            $RemoveWindowsCapability = (Get-TaskRemoveWindowsCapability).Name
            $RemoveWindowsCapability = [array]$RemoveWindowsCapability + [array]$ExistingTask.RemoveWindowsCapability
            $RemoveWindowsCapability = $RemoveWindowsCapability | Sort-Object -Unique
        } else {
            if ($ExistingTask.RemoveWindowsCapability) {$RemoveWindowsCapability = $ExistingTask.RemoveWindowsCapability}
            #Write-Host "RemoveCapability: Select Windows Capabilities to remove using Remove-WindowsCapability" -ForegroundColor Gray
        }
        #===================================================================================================
        #   RemovePackage
        #===================================================================================================
        Write-Host "RemovePackage" -ForegroundColor Green
        if ($ExistingTask.RemoveWindowsPackage) {
            foreach ($Item in $ExistingTask.RemoveWindowsPackage) {
                Write-Host "$Item" -ForegroundColor DarkGray
            }
        }
        $RemoveWindowsPackage = $null
        if ($RemovePackage.IsPresent) {
            $RemoveWindowsPackage = (Get-TaskRemoveWindowsPackage).PackageName
            $RemoveWindowsPackage = [array]$RemoveWindowsPackage + [array]$ExistingTask.RemoveWindowsPackage
            $RemoveWindowsPackage = $RemoveWindowsPackage | Sort-Object -Unique
        } else {
            if ($ExistingTask.RemoveWindowsPackage) {$RemoveWindowsPackage = $ExistingTask.RemoveWindowsPackage}
            #Write-Host "RemovePackage: Select Windows Packages to remove using Remove-WindowsPackage" -ForegroundColor Gray
        }
        #===================================================================================================
        #   DisableFeature
        #===================================================================================================
        Write-Host "DisableFeature" -ForegroundColor Green
        if ($ExistingTask.DisableWindowsOptionalFeature) {
            foreach ($Item in $ExistingTask.DisableWindowsOptionalFeature) {
                Write-Host "$Item" -ForegroundColor DarkGray
            }
        }
        $DisableWindowsOptionalFeature = $null
        if ($DisableFeature.IsPresent) {
            $DisableWindowsOptionalFeature = (Get-TaskDisableWindowsOptionalFeature).FeatureName
            $DisableWindowsOptionalFeature = [array]$DisableWindowsOptionalFeature + [array]$ExistingTask.DisableWindowsOptionalFeature
            $DisableWindowsOptionalFeature = $DisableWindowsOptionalFeature | Sort-Object -Unique
        } else {
            if ($ExistingTask.DisableWindowsOptionalFeature) {$DisableWindowsOptionalFeature = $ExistingTask.DisableWindowsOptionalFeature}
            #Write-Host "DisableFeature: Select Windows Optional Features to disable using Disable-WindowsOptionalFeature" -ForegroundColor Gray
        }
        #===================================================================================================
        #   EnableFeature
        #===================================================================================================
        Write-Host "EnableFeature" -ForegroundColor Green
        if ($ExistingTask.EnableWindowsOptionalFeature) {
            foreach ($Item in $ExistingTask.EnableWindowsOptionalFeature) {
                Write-Host "$Item" -ForegroundColor DarkGray
            }
        }
        $EnableWindowsOptionalFeature = $null
        if ($EnableFeature.IsPresent) {
            [array]$EnableWindowsOptionalFeature = (Get-TaskEnableWindowsOptionalFeature).FeatureName
            
            $EnableWindowsOptionalFeature = [array]$EnableWindowsOptionalFeature + [array]$ExistingTask.EnableWindowsOptionalFeature
            $EnableWindowsOptionalFeature = $EnableWindowsOptionalFeature | Sort-Object -Unique
        } else {
            if ($ExistingTask.EnableWindowsOptionalFeature) {$EnableWindowsOptionalFeature = $ExistingTask.EnableWindowsOptionalFeature}
            #Write-Host "EnableFeature: Select Windows Optional Features to enable using Enable-WindowsOptionalFeature" -ForegroundColor Gray
        }
        #===================================================================================================
        #   Content
        #===================================================================================================
        #===================================================================================================
        #   Content Drivers
        #===================================================================================================
        Write-Host "Drivers" -ForegroundColor Green
        if ($ExistingTask.Drivers) {
            foreach ($Item in $ExistingTask.Drivers) {
                Write-Host "$Item" -ForegroundColor DarkGray
            }
        }
        $Drivers = $null
        if ($ContentDrivers.IsPresent) {
            [array]$Drivers = (Get-TaskContentDrivers).FullName
            
            $Drivers = [array]$Drivers + [array]$ExistingTask.Drivers
            $Drivers = $Drivers | Sort-Object -Unique
        } else {
            if ($ExistingTask.Drivers) {$Drivers = $ExistingTask.Drivers}
        }
        #===================================================================================================
        #   Content ExtraFiles
        #===================================================================================================
        Write-Host "ExtraFiles" -ForegroundColor Green
        if ($ExistingTask.ExtraFiles) {
            foreach ($Item in $ExistingTask.ExtraFiles) {
                Write-Host "$Item" -ForegroundColor DarkGray
            }
        }
        $ExtraFiles = $null
        if ($ContentExtraFiles.IsPresent) {
            [array]$ExtraFiles = (Get-TaskContentExtraFiles).FullName
            
            $ExtraFiles = [array]$ExtraFiles + [array]$ExistingTask.ExtraFiles
            $ExtraFiles = $ExtraFiles | Sort-Object -Unique
        } else {
            if ($ExistingTask.ExtraFiles) {$ExtraFiles = $ExistingTask.ExtraFiles}
        }
        #===================================================================================================
        #   Content Scripts
        #===================================================================================================
        Write-Host "Scripts" -ForegroundColor Green
        if ($ExistingTask.Scripts) {
            foreach ($Item in $ExistingTask.Scripts) {
                Write-Host "$Item" -ForegroundColor DarkGray
            }
        }
        $Scripts = $null
        if ($ContentScripts.IsPresent) {
            [array]$Scripts = (Get-TaskContentScripts).FullName
            
            $Scripts = [array]$Scripts + [array]$ExistingTask.Scripts
            $Scripts = $Scripts | Sort-Object -Unique
        } else {
            if ($ExistingTask.Scripts) {$Scripts = $ExistingTask.Scripts}
        }
        #===================================================================================================
        #   Content StartLayout
        #===================================================================================================
        Write-Host "StartLayout" -ForegroundColor Green
        if ($ExistingTask.StartLayoutXML) {
            foreach ($Item in $ExistingTask.StartLayoutXML) {
                Write-Host "$Item" -ForegroundColor DarkGray
            }
        }
        $StartLayoutXML = $null
        if ($ContentStartLayout.IsPresent) {
            if ($OSMedia.MajorVersion -eq 10) {$StartLayoutXML = (Get-TaskContentStartLayoutXML).FullName}
        } else {
            if ($ExistingTask.StartLayoutXML) {$StartLayoutXML = $ExistingTask.StartLayoutXML}
        }
        if (!($StartLayoutXML)) {if ($ExistingTask.StartLayoutXML) {$StartLayoutXML = $ExistingTask.StartLayoutXML}}
        #===================================================================================================
        #   Content Unattend
        #===================================================================================================
        Write-Host "Unattend" -ForegroundColor Green
        if ($ExistingTask.UnattendXML) {
            foreach ($Item in $ExistingTask.UnattendXML) {
                Write-Host "$Item" -ForegroundColor DarkGray
            }
        }
        $UnattendXML = $null
        if ($ContentUnattend.IsPresent) {
            if ($OSMedia.MajorVersion -eq 10) {[string]$UnattendXML = (Get-TaskContentUnattendXML).FullName}
        } else {
            if ($ExistingTask.UnattendXML) {$UnattendXML = $ExistingTask.UnattendXML}
        }
        if (!($UnattendXML)) {if ($ExistingTask.UnattendXML) {$UnattendXML = $ExistingTask.UnattendXML}}
        #===================================================================================================
        #   Content Packages
        #===================================================================================================
        Write-Host "Packages" -ForegroundColor Green
        if ($ExistingTask.AddWindowsPackage) {
            foreach ($Item in $ExistingTask.AddWindowsPackage) {
                Write-Host "$Item" -ForegroundColor DarkGray
            }
        }
        $AddWindowsPackage = $null
        if ($ContentPackages.IsPresent) {
            [array]$AddWindowsPackage = (Get-TaskContentAddWindowsPackage).FullName
            
            $AddWindowsPackage = [array]$AddWindowsPackage + [array]$ExistingTask.AddWindowsPackage
            $AddWindowsPackage = $AddWindowsPackage | Sort-Object -Unique
        } else {
            if ($ExistingTask.AddWindowsPackage) {$AddWindowsPackage = $ExistingTask.AddWindowsPackage}
        }
        #===================================================================================================
        #   IsoExtract
        #===================================================================================================
        if ($OSMedia.MajorVersion -eq 10) {
            #if ($ContentFeaturesOnDemand.IsPresent -or $ContentLanguagePackages.IsPresent) {
            #===================================================================================================
            #   ContentIsoExtract
            #===================================================================================================
            Write-Warning "Generating IsoExtract Content ... This may take a while"
            $ContentIsoExtract = @()
            [array]$ContentIsoExtract = Get-TaskContentIsoExtract

            $ContentIsoExtractWinPE = @()
            $ContentIsoExtractWinPE = $ContentIsoExtract | Where-Object {$_.FullName -like "*Windows Preinstallation Environment*"}

            $ContentIsoExtract = $ContentIsoExtract | Where-Object {$_.FullName -notlike "*Windows Preinstallation Environment*"}
            if ($OSMedia.InstallationType -eq 'Client') {$ContentIsoExtract = $ContentIsoExtract | Where-Object {$_.FullName -notlike "*Windows Server*"}}
            if ($OSMedia.InstallationType -like "*Server*") {$ContentIsoExtract = $ContentIsoExtract | Where-Object {$_.FullName -like "*Windows Server*"}}
            #===================================================================================================
            #   AddFeatureOnDemand
            #===================================================================================================
            Write-Host "FeatureOnDemand" -ForegroundColor Green
            if ($ExistingTask.AddFeatureOnDemand) {
                foreach ($Item in $ExistingTask.AddFeatureOnDemand) {
                    Write-Host "$Item" -ForegroundColor DarkGray
                }
            }
            $AddFeatureOnDemand = $null
            if ($ContentFeaturesOnDemand.IsPresent) {
                [array]$AddFeatureOnDemand = (Get-TaskContentAddFeatureOnDemand).FullName
                
                $AddFeatureOnDemand = [array]$AddFeatureOnDemand + [array]$ExistingTask.AddFeatureOnDemand
                $AddFeatureOnDemand = $AddFeatureOnDemand | Sort-Object -Unique
            } else {
                if ($ExistingTask.AddFeatureOnDemand) {$AddFeatureOnDemand = $ExistingTask.AddFeatureOnDemand}
            }
            #===================================================================================================
            #   LanguagePack
            #===================================================================================================
            Write-Host "LanguagePack" -ForegroundColor Green
            if ($ExistingTask.LanguagePack) {
                foreach ($Item in $ExistingTask.LanguagePack) {
                    Write-Host "$Item" -ForegroundColor DarkGray
                }
            }
            $LanguagePack = $null
            if ($ContentLanguagePackages.IsPresent) {
                [array]$LanguagePack = (Get-TaskContentLanguagePack).FullName
                
                $LanguagePack = [array]$LanguagePack + [array]$ExistingTask.LanguagePack
                $LanguagePack = $LanguagePack | Sort-Object -Unique
            } else {
                if ($ExistingTask.LanguagePack) {$LanguagePack = $ExistingTask.LanguagePack}
            }
            #===================================================================================================
            #   LanguageFeature
            #===================================================================================================
            Write-Host "LanguageFeature" -ForegroundColor Green
            if ($ExistingTask.LanguageFeature) {
                foreach ($Item in $ExistingTask.LanguageFeature) {
                    Write-Host "$Item" -ForegroundColor DarkGray
                }
            }
            $LanguageFeature = $null
            if ($ContentLanguagePackages.IsPresent) {
                [array]$LanguageFeature = (Get-TaskContentLanguageFeature).FullName
                
                $LanguageFeature = [array]$LanguageFeature + [array]$ExistingTask.LanguageFeature
                $LanguageFeature = $LanguageFeature | Sort-Object -Unique
            } else {
                if ($ExistingTask.LanguageFeature) {$LanguageFeature = $ExistingTask.LanguageFeature}
            }
            #===================================================================================================
            #   LanguageInterfacePack
            #===================================================================================================
            Write-Host "LanguageInterfacePack" -ForegroundColor Green
            if ($ExistingTask.LanguageInterfacePack) {
                foreach ($Item in $ExistingTask.LanguageInterfacePack) {
                    Write-Host "$Item" -ForegroundColor DarkGray
                }
            }
            $LanguageInterfacePack = $null
            if ($ContentLanguagePackages.IsPresent) {
                [array]$LanguageInterfacePack = (Get-TaskContentLanguageInterfacePack).FullName
                
                $LanguageInterfacePack = [array]$LanguageInterfacePack + [array]$ExistingTask.LanguageInterfacePack
                $LanguageInterfacePack = $LanguageInterfacePack | Sort-Object -Unique
            } else {
                if ($ExistingTask.LanguageInterfacePack) {$LanguageInterfacePack = $ExistingTask.LanguageInterfacePack}
            }
            #===================================================================================================
            #   LocalExperiencePacks
            #===================================================================================================
            Write-Host "LocalExperiencePacks" -ForegroundColor Green
            if ($ExistingTask.LocalExperiencePacks) {
                foreach ($Item in $ExistingTask.LocalExperiencePacks) {
                    Write-Host "$Item" -ForegroundColor DarkGray
                }
            }
            $LocalExperiencePacks = $null
            if ($ContentLanguagePackages.IsPresent) {
                [array]$LocalExperiencePacks = (Get-TaskContentLocalExperiencePacks).FullName
                
                $LocalExperiencePacks = [array]$LocalExperiencePacks + [array]$ExistingTask.LocalExperiencePacks
                $LocalExperiencePacks = $LocalExperiencePacks | Sort-Object -Unique
            } else {
                if ($ExistingTask.LocalExperiencePacks) {$LocalExperiencePacks = $ExistingTask.LocalExperiencePacks}
            }
            #===================================================================================================
            #}
        }
        #===================================================================================================
        #   SourcesLanguageCopy
        #===================================================================================================
        Write-Host "SourcesLanguageCopy" -ForegroundColor Green
        if ($ExistingTask.LanguageCopySources) {
            foreach ($Item in $ExistingTask.LanguageCopySources) {
                Write-Host "$Item" -ForegroundColor DarkGray
            }
        }
        $LanguageCopySources = $null
        if ($SourcesLanguageCopy.IsPresent) {
            [array]$LanguageCopySources = (Get-TaskContentLanguageCopySources).OSMFamily
            
            $LanguageCopySources = [array]$LanguageCopySources + [array]$ExistingTask.LanguageCopySources
            $LanguageCopySources = $LanguageCopySources | Sort-Object -Unique
        } else {
            if ($ExistingTask.LanguageCopySources) {$LanguageCopySources = $ExistingTask.LanguageCopySources}
        }
        #===================================================================================================
        #   WinPE Configuration
        #===================================================================================================
        #   Content WinPEDaRT
        #===================================================================================================
        Write-Host "WinPEDaRT" -ForegroundColor Green
        if ($ExistingTask.WinPEDaRT) {
            foreach ($Item in $ExistingTask.WinPEDaRT) {
                Write-Host "$Item" -ForegroundColor DarkGray
            }
        }
        $WinPEDaRT = $null
        if ($ContentWinPEDaRT.IsPresent) {
            if ($OSMedia.MajorVersion -eq 10) {
                [string]$WinPEDaRT = (Get-TaskWinPEDaRT).FullName
            }
        }
        if ($null -eq $WinPEDaRT) {if ($ExistingTask.WinPEDaRT) {$WinPEDaRT = $ExistingTask.WinPEDaRT}}
        #===================================================================================================
        #   WinPEADKPE
        #===================================================================================================
        Write-Host "WinPEADKPE" -ForegroundColor Green
        if ($ExistingTask.WinPEADKPE) {
            foreach ($Item in $ExistingTask.WinPEADKPE) {
                Write-Host "$Item" -ForegroundColor DarkGray
            }
        }
        $WinPEADKPE = $null
        if ($ContentWinPEADK.IsPresent) {
            [array]$WinPEADKPE = (Get-TaskWinPEADKPE).FullName
            
            $WinPEADKPE = [array]$WinPEADKPE + [array]$ExistingTask.WinPEADKPE
            $WinPEADKPE = $WinPEADKPE | Sort-Object -Unique | Sort-Object Length
        } else {
            if ($ExistingTask.WinPEADKPE) {$WinPEADKPE = $ExistingTask.WinPEADKPE | Sort-Object Length}
        }
        #===================================================================================================
        #   WinPEADKRE
        #===================================================================================================
        Write-Host "WinPEADKRE" -ForegroundColor Green
        if ($ExistingTask.WinPEADKRE) {
            foreach ($Item in $ExistingTask.WinPEADKRE) {
                Write-Host "$Item" -ForegroundColor DarkGray
            }
        }
        $WinPEADKRE = $null
        if ($ContentWinPEADK.IsPresent) {
            [array]$WinPEADKRE = (Get-TaskWinPEADKRE).FullName
            
            $WinPEADKRE = [array]$WinPEADKRE + [array]$ExistingTask.WinPEADKRE
            $WinPEADKRE = $WinPEADKRE | Sort-Object -Unique | Sort-Object Length
        } else {
            if ($ExistingTask.WinPEADKRE) {$WinPEADKRE = $ExistingTask.WinPEADKRE | Sort-Object Length}
        }
        #===================================================================================================
        #   WinPEADKSE
        #===================================================================================================
        Write-Host "WinPEADKSE" -ForegroundColor Green
        if ($ExistingTask.WinPEADKSE) {
            foreach ($Item in $ExistingTask.WinPEADKSE) {
                Write-Host "$Item" -ForegroundColor DarkGray
            }
        }
        $WinPEADKSE = $null
        if ($ContentWinPEADK.IsPresent) {
            [array]$WinPEADKSE = (Get-TaskWinPEADKSE).FullName
            
            $WinPEADKSE = [array]$WinPEADKSE + [array]$ExistingTask.WinPEADKSE
            $WinPEADKSE = $WinPEADKSE | Sort-Object -Unique | Sort-Object Length
        } else {
            if ($ExistingTask.WinPEADKSE) {$WinPEADKSE = $ExistingTask.WinPEADKSE | Sort-Object Length}
        }
        #===================================================================================================
        #   WinPEDrivers
        #===================================================================================================
        Write-Host "WinPEDrivers" -ForegroundColor Green
        if ($ExistingTask.WinPEDrivers) {
            foreach ($Item in $ExistingTask.WinPEDrivers) {
                Write-Host "$Item" -ForegroundColor DarkGray
            }
        }
        $WinPEDrivers = $null
        if ($ContentWinPEDrivers.IsPresent) {
            [array]$WinPEDrivers = (Get-TaskWinPEDrivers).FullName
            
            $WinPEDrivers = [array]$WinPEDrivers + [array]$ExistingTask.WinPEDrivers
            $WinPEDrivers = $WinPEDrivers | Sort-Object -Unique
        } else {
            if ($ExistingTask.WinPEDrivers) {$WinPEDrivers = $ExistingTask.WinPEDrivers}
        }
        #===================================================================================================
        #   WinPEExtraFilesPE
        #===================================================================================================
        Write-Host "WinPEExtraFilesPE" -ForegroundColor Green
        if ($ExistingTask.WinPEExtraFilesPE) {
            foreach ($Item in $ExistingTask.WinPEExtraFilesPE) {
                Write-Host "$Item" -ForegroundColor DarkGray
            }
        }
        $WinPEExtraFilesPE = $null
        if ($ContentWinPEExtraFiles.IsPresent) {
            [array]$WinPEExtraFilesPE = (Get-TaskWinPEExtraFilesPE).FullName
            
            $WinPEExtraFilesPE = [array]$WinPEExtraFilesPE + [array]$ExistingTask.WinPEExtraFilesPE
            $WinPEExtraFilesPE = $WinPEExtraFilesPE | Sort-Object -Unique
        } else {
            if ($ExistingTask.WinPEExtraFilesPE) {$WinPEExtraFilesPE = $ExistingTask.WinPEExtraFilesPE}
        }
        #===================================================================================================
        #   WinPEExtraFilesRE
        #===================================================================================================
        Write-Host "WinPEExtraFilesRE" -ForegroundColor Green
        if ($ExistingTask.WinPEExtraFilesRE) {
            foreach ($Item in $ExistingTask.WinPEExtraFilesRE) {
                Write-Host "$Item" -ForegroundColor DarkGray
            }
        }
        $WinPEExtraFilesRE = $null
        if ($ContentWinPEExtraFiles.IsPresent) {
            [array]$WinPEExtraFilesRE = (Get-TaskWinPEExtraFilesRE).FullName
            
            $WinPEExtraFilesRE = [array]$WinPEExtraFilesRE + [array]$ExistingTask.WinPEExtraFilesRE
            $WinPEExtraFilesRE = $WinPEExtraFilesRE | Sort-Object -Unique
        } else {
            if ($ExistingTask.WinPEExtraFilesRE) {$WinPEExtraFilesRE = $ExistingTask.WinPEExtraFilesRE}
        }
        #===================================================================================================
        #   WinPEExtraFilesSE
        #===================================================================================================
        Write-Host "WinPEExtraFilesSE" -ForegroundColor Green
        if ($ExistingTask.WinPEExtraFilesSE) {
            foreach ($Item in $ExistingTask.WinPEExtraFilesSE) {
                Write-Host "$Item" -ForegroundColor DarkGray
            }
        }
        $WinPEExtraFilesSE = $null
        if ($ContentWinPEExtraFiles.IsPresent) {
            [array]$WinPEExtraFilesSE = (Get-TaskWinPEExtraFilesSE).FullName
            
            $WinPEExtraFilesSE = [array]$WinPEExtraFilesSE + [array]$ExistingTask.WinPEExtraFilesSE
            $WinPEExtraFilesSE = $WinPEExtraFilesSE | Sort-Object -Unique
        } else {
            if ($ExistingTask.WinPEExtraFilesSE) {$WinPEExtraFilesSE = $ExistingTask.WinPEExtraFilesSE}
        }
        #===================================================================================================
        #   WinPEScriptsPE
        #===================================================================================================
        Write-Host "WinPEScriptsPE" -ForegroundColor Green
        if ($ExistingTask.WinPEScriptsPE) {
            foreach ($Item in $ExistingTask.WinPEScriptsPE) {
                Write-Host "$Item" -ForegroundColor DarkGray
            }
        }
        $WinPEScriptsPE = $null
        if ($ContentWinPEScripts.IsPresent) {
            [array]$WinPEScriptsPE = (Get-TaskWinPEScriptsPE).FullName
            
            $WinPEScriptsPE = [array]$WinPEScriptsPE + [array]$ExistingTask.WinPEScriptsPE
            $WinPEScriptsPE = $WinPEScriptsPE | Sort-Object -Unique
        } else {
            if ($ExistingTask.WinPEScriptsPE) {$WinPEScriptsPE = $ExistingTask.WinPEScriptsPE}
        }
        #===================================================================================================
        #   WinPEScriptsRE
        #===================================================================================================
        Write-Host "WinPEScriptsRE" -ForegroundColor Green
        if ($ExistingTask.WinPEScriptsRE) {
            foreach ($Item in $ExistingTask.WinPEScriptsRE) {
                Write-Host "$Item" -ForegroundColor DarkGray
            }
        }
        $WinPEScriptsRE = $null
        if ($ContentWinPEScripts.IsPresent) {
            [array]$WinPEScriptsRE = (Get-TaskWinPEScriptsRE).FullName
            
            $WinPEScriptsRE = [array]$WinPEScriptsRE + [array]$ExistingTask.WinPEScriptsRE
            $WinPEScriptsRE = $WinPEScriptsRE | Sort-Object -Unique
        } else {
            if ($ExistingTask.WinPEScriptsRE) {$WinPEScriptsRE = $ExistingTask.$WinPEScriptsRE}
        }
        #===================================================================================================
        #   WinPEScriptsSE
        #===================================================================================================
        Write-Host "WinPEScriptsSE" -ForegroundColor Green
        if ($ExistingTask.WinPEScriptsSE) {
            foreach ($Item in $ExistingTask.WinPEScriptsSE) {
                Write-Host "$Item" -ForegroundColor DarkGray
            }
        }
        $WinPEScriptsSE = $null
        if ($ContentWinPEScripts.IsPresent) {
            [array]$WinPEScriptsSE = (Get-TaskWinPEScriptsSE).FullName
            
            $WinPEScriptsSE = [array]$WinPEScriptsSE + [array]$ExistingTask.WinPEScriptsSE
            $WinPEScriptsSE = $WinPEScriptsSE | Sort-Object -Unique
        } else {
            if ($ExistingTask.WinPEScriptsSE) {$WinPEScriptsSE = $ExistingTask.WinPEScriptsSE}
        }
        #===================================================================================================
        #   Corrections
        #===================================================================================================
        if ($OSMedia.MajorVersion -eq 6) {$EnableNetFX3 = $false}
        if ($null -eq $SetAllIntl) {if ($ExistingTask.SetAllIntl) {$SetAllIntl = $ExistingTask.SetAllIntl}}
        if ($null -eq $SetInputLocale) {if ($ExistingTask.SetInputLocale) {$SetInputLocale = $ExistingTask.SetInputLocale}}
        if ($null -eq $SetSKUIntlDefaults) {if ($ExistingTask.SetSKUIntlDefaults) {$SetSKUIntlDefaults = $ExistingTask.SetSKUIntlDefaults}}
        if ($null -eq $SetSetupUILang) {if ($ExistingTask.SetSetupUILang) {$SetSetupUILang = $ExistingTask.SetSetupUILang}}
        if ($null -eq $SetSysLocale) {if ($ExistingTask.SetSysLocale) {$SetSysLocale = $ExistingTask.SetSysLocale}}
        if ($null -eq $SetUILang) {if ($ExistingTask.SetUILang) {$SetUILang = $ExistingTask.SetUILang}}
        if ($null -eq $SetUILangFallback) {if ($ExistingTask.SetUILangFallback) {$SetUILang = $ExistingTask.SetUILangFallback}}
        if ($null -eq $SetUserLocale) {if ($ExistingTask.SetUserLocale) {$SetUserLocale = $ExistingTask.SetUserLocale}}
        #===================================================================================================
        Write-Verbose '19.2.12 Build Task'
        #===================================================================================================
        $Task = [ordered]@{
            "TaskType" = [string]"OSBuild";
            "TaskName" = [string]$TaskName;
            "TaskVersion" = [string]$OSDBuilderVersion;
            "TaskGuid" = [string]$(New-Guid);
            
            "CustomName" = [string]$CustomName;

            "OSMFamily" = [string]$OSMedia.OSMFamily;
            "OSMGuid" = [string]$OSMedia.OSMGuid;
            "Name" = [string]$OSMedia.Name;
            "ImageName" = [string]$OSMedia.ImageName;
            "Arch" = [string]$OSMedia.Arch;
            "ReleaseId" = [string]$($OSMedia.ReleaseId);
            "UBR" = [string]$OSMedia.UBR;
            "Languages" = [string[]]$OSMedia.Languages;
            "EditionId" = [string]$OSMedia.EditionId;
            "InstallationType" = [string]$OSMedia.InstallationType;
            "MajorVersion" = [string]$OSMedia.MajorVersion;
            "Build" = [string]$OSMedia.Build;
            "CreatedTime" = [datetime]$OSMedia.CreatedTime;
            "ModifiedTime" = [datetime]$OSMedia.ModifiedTime;
            #===================================================================================================
            #   Parameters
            #===================================================================================================
            "EnableNetFX3" = [string]$EnableNetFX3;
            "WinPEAutoExtraFiles" = [string]$WinPEAutoExtraFiles;
            #===================================================================================================
            #   Internal
            #===================================================================================================
            "RemoveAppxProvisionedPackage" = [string[]]$RemoveAppxProvisionedPackage;
            "RemoveWindowsCapability" = [string[]]$RemoveWindowsCapability;
            "RemoveWindowsPackage" = [string[]]$RemoveWindowsPackage;
            "DisableWindowsOptionalFeature" = [string[]]$DisableWindowsOptionalFeature;
            "EnableWindowsOptionalFeature" = [string[]]$EnableWindowsOptionalFeature;
            #===================================================================================================
            #   Content
            #===================================================================================================
            "Drivers" = [string[]]$Drivers;
            "ExtraFiles" = [string[]]$ExtraFiles;
            "Scripts" = [string[]]$Scripts;
            "StartLayoutXML" = [string]$StartLayoutXML;
            "UnattendXML" = [string]$UnattendXML;
            #===================================================================================================
            #   Content Packages
            #===================================================================================================
            "AddWindowsPackage" = [string[]]$AddWindowsPackage;
            "AddFeatureOnDemand" = [string[]]$AddFeatureOnDemand;
            #===================================================================================================
            #   Content WinPE
            #===================================================================================================
            "WinPEADKPE" = [string[]]$WinPEADKPE;
            "WinPEADKRE" = [string[]]$WinPEADKRE;
            "WinPEADKSE" = [string[]]$WinPEADKSE;
            "WinPEDaRT" = [string]$WinPEDaRT;
            "WinPEDrivers" = [string[]]$WinPEDrivers;
            "WinPEExtraFilesPE" = [string[]]$WinPEExtraFilesPE;
            "WinPEExtraFilesRE" = [string[]]$WinPEExtraFilesRE;
            "WinPEExtraFilesSE" = [string[]]$WinPEExtraFilesSE;
            "WinPEScriptsPE" = [string[]]$WinPEScriptsPE;
            "WinPEScriptsRE" = [string[]]$WinPEScriptsRE;
            "WinPEScriptsSE" = [string[]]$WinPEScriptsSE;
            #===================================================================================================
            #   Language
            #===================================================================================================
            "LangSetAllIntl" = [string]$SetAllIntl;
            "LangSetInputLocale" = [string]$SetInputLocale;
            "LangSetSKUIntlDefaults" = [string]$SetSKUIntlDefaults;
            "LangSetSetupUILang" = [string]$SetSetupUILang;
            "LangSetSysLocale" = [string]$SetSysLocale;
            "LangSetUILang" = [string]$SetUILang;
            "LangSetUILangFallback" = [string]$SetUILangFallback;
            "LangSetUserLocale" = [string]$SetUserLocale;
            #===================================================================================================
            #   Language Packages
            #===================================================================================================
            "LanguagePack" = [string[]]$LanguagePack;
            "LanguageInterfacePack" = [string[]]$LanguageInterfacePack;
            "LocalExperiencePacks" = [string[]]$LocalExperiencePacks;
            "LanguageFeature" = [string[]]$LanguageFeature;
            "LanguageCopySources" = [string[]]$LanguageCopySources;

        }

        #===================================================================================================
        Write-Verbose '19.1.1 New-OSBuildTask Complete'
        #===================================================================================================
        Write-Host '========================================================================================' -ForegroundColor DarkGray
        Write-Host "OSBuild Task: $TaskName" -ForegroundColor Green
        $Task | ConvertTo-Json | Out-File "$TaskPath"
        $Task
    }

    END {
        #Write-Host '========================================================================================' -ForegroundColor DarkGray
        #Write-Host "$($MyInvocation.MyCommand.Name) END" -ForegroundColor Green
    }
}