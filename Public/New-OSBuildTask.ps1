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
        [string]$CustomName,

        [switch]$DisableFeature,
        [switch]$EnableFeature,
        [switch]$EnableNetFX3,
        [switch]$RemoveAppx,
        [switch]$RemoveCapability,
        [switch]$RemovePackage,
        [switch]$WinPEAutoExtraFiles,
        #===================================================================================================
        #   Select
        #===================================================================================================
        [Parameter(ParameterSetName='Advanced')]
        [switch]$SelectDrivers,
        [Parameter(ParameterSetName='Advanced')]
        [switch]$SelectExtraFiles,
        [Parameter(ParameterSetName='Advanced')]
        [switch]$SelectFeaturesOnDemand,
        [Parameter(ParameterSetName='Advanced')]
        [switch]$SelectLanguagePackages,
        [Parameter(ParameterSetName='Advanced')]
        [switch]$SelectPackages,
        [Parameter(ParameterSetName='Advanced')]
        [switch]$SelectScripts,
        [Parameter(ParameterSetName='Advanced')]
        [switch]$SelectStartLayoutXML,
        [Parameter(ParameterSetName='Advanced')]
        [switch]$SelectUnattendXML,
        [Parameter(ParameterSetName='Advanced')]
        [switch]$SelectWinPEADK,
        [Parameter(ParameterSetName='Advanced')]
        [switch]$SelectWinPEDart,
        [Parameter(ParameterSetName='Advanced')]
        [switch]$SelectWinPEDrivers,
        [Parameter(ParameterSetName='Advanced')]
        [switch]$SelectWinPEExtraFiles,
        [Parameter(ParameterSetName='Advanced')]
        [switch]$SelectWinPEScripts,
        #===================================================================================================
        #   Language
        #===================================================================================================
        #[ValidateSet('ar-SA','bg-BG','zh-CN','zh-TW','hr-HR','cs-CZ','da-DK','nl-NL','en-US','en-GB','et-EE','fi-FI','fr-CA','fr-FR','de-DE','el-GR','he-IL','hu-HU','it-IT','ja-JP','ko-KR','lv-LV','lt-LT','nb-NO','pl-PL','pt-BR','pt-PT','ro-RO','ru-RU','sr-Latn-RS','sk-SK','sl-SI','es-MX','es-ES','sv-SE','th-TH','tr-TR','uk-UA')]
        #[ValidateSet('af-ZA','am-ET','as-IN','az-Latn-AZ','be-BY','bn-BD','bn-IN','bs-Latn-BA','ca-ES','ca-ES-valencia','chr-CHER-US','cy-GB','eu-ES','fa-IR','fil-PH','ga-IE','gd-GB','gl-ES','gu-IN','ha-Latn-NG','hi-IN','hy-AM','id-ID','ig-NG','is-IS','ka-GE','kk-KZ','km-KH','kn-IN','kok-IN','ku-ARAB-IQ','ky-KG','lb-LU','lo-LA','mi-NZ','mk-MK','ml-IN','mn-MN','mr-IN','ms-MY','mt-MT','ne-NP','nn-NO','nso-ZA','or-IN','pa-Arab-PK','pa-IN','prs-AF','quc-Latn-GT','quz-PE','rw-RW','sd-Arab-PK','si-LK','sq-AL','sr-Cyrl-BA','sr-Cyrl-RS','sw-KE','ta-IN','te-IN','tg-Cyrl-TJ','ti-ET','tk-TM','tn-ZA','tt-RU','ug-CN','ur-PK','uz-Latn-UZ','vi-VN','wo-SN','xh-ZA','yo-NG','zu-ZA')]
        [Parameter(ParameterSetName='Advanced')]
        [ValidateSet('ar-SA','bg-BG','zh-CN','zh-TW','hr-HR','cs-CZ','da-DK','nl-NL','en-US','en-GB','et-EE','fi-FI','fr-CA','fr-FR','de-DE','el-GR','he-IL','hu-HU','it-IT','ja-JP','ko-KR','lv-LV','lt-LT','nb-NO','pl-PL','pt-BR','pt-PT','ro-RO','ru-RU','sr-Latn-RS','sk-SK','sl-SI','es-MX','es-ES','sv-SE','th-TH','tr-TR','uk-UA','af-ZA','am-ET','as-IN','az-Latn-AZ','be-BY','bn-BD','bn-IN','bs-Latn-BA','ca-ES','ca-ES-valencia','chr-CHER-US','cy-GB','eu-ES','fa-IR','fil-PH','ga-IE','gd-GB','gl-ES','gu-IN','ha-Latn-NG','hi-IN','hy-AM','id-ID','ig-NG','is-IS','ka-GE','kk-KZ','km-KH','kn-IN','kok-IN','ku-ARAB-IQ','ky-KG','lb-LU','lo-LA','mi-NZ','mk-MK','ml-IN','mn-MN','mr-IN','ms-MY','mt-MT','ne-NP','nn-NO','nso-ZA','or-IN','pa-Arab-PK','pa-IN','prs-AF','quc-Latn-GT','quz-PE','rw-RW','sd-Arab-PK','si-LK','sq-AL','sr-Cyrl-BA','sr-Cyrl-RS','sw-KE','ta-IN','te-IN','tg-Cyrl-TJ','ti-ET','tk-TM','tn-ZA','tt-RU','ug-CN','ur-PK','uz-Latn-UZ','vi-VN','wo-SN','xh-ZA','yo-NG','zu-ZA')]
        [string]$SetAllIntl,
        [Parameter(ParameterSetName='Advanced')]
        [string]$SetInputLocale,
        [Parameter(ParameterSetName='Advanced')]
        [ValidateSet('ar-SA','bg-BG','zh-CN','zh-TW','hr-HR','cs-CZ','da-DK','nl-NL','en-US','en-GB','et-EE','fi-FI','fr-CA','fr-FR','de-DE','el-GR','he-IL','hu-HU','it-IT','ja-JP','ko-KR','lv-LV','lt-LT','nb-NO','pl-PL','pt-BR','pt-PT','ro-RO','ru-RU','sr-Latn-RS','sk-SK','sl-SI','es-MX','es-ES','sv-SE','th-TH','tr-TR','uk-UA','af-ZA','am-ET','as-IN','az-Latn-AZ','be-BY','bn-BD','bn-IN','bs-Latn-BA','ca-ES','ca-ES-valencia','chr-CHER-US','cy-GB','eu-ES','fa-IR','fil-PH','ga-IE','gd-GB','gl-ES','gu-IN','ha-Latn-NG','hi-IN','hy-AM','id-ID','ig-NG','is-IS','ka-GE','kk-KZ','km-KH','kn-IN','kok-IN','ku-ARAB-IQ','ky-KG','lb-LU','lo-LA','mi-NZ','mk-MK','ml-IN','mn-MN','mr-IN','ms-MY','mt-MT','ne-NP','nn-NO','nso-ZA','or-IN','pa-Arab-PK','pa-IN','prs-AF','quc-Latn-GT','quz-PE','rw-RW','sd-Arab-PK','si-LK','sq-AL','sr-Cyrl-BA','sr-Cyrl-RS','sw-KE','ta-IN','te-IN','tg-Cyrl-TJ','ti-ET','tk-TM','tn-ZA','tt-RU','ug-CN','ur-PK','uz-Latn-UZ','vi-VN','wo-SN','xh-ZA','yo-NG','zu-ZA')]
        [string]$SetSKUIntlDefaults,
        [Parameter(ParameterSetName='Advanced')]
        [ValidateSet('ar-SA','bg-BG','zh-CN','zh-TW','hr-HR','cs-CZ','da-DK','nl-NL','en-US','en-GB','et-EE','fi-FI','fr-CA','fr-FR','de-DE','el-GR','he-IL','hu-HU','it-IT','ja-JP','ko-KR','lv-LV','lt-LT','nb-NO','pl-PL','pt-BR','pt-PT','ro-RO','ru-RU','sr-Latn-RS','sk-SK','sl-SI','es-MX','es-ES','sv-SE','th-TH','tr-TR','uk-UA','af-ZA','am-ET','as-IN','az-Latn-AZ','be-BY','bn-BD','bn-IN','bs-Latn-BA','ca-ES','ca-ES-valencia','chr-CHER-US','cy-GB','eu-ES','fa-IR','fil-PH','ga-IE','gd-GB','gl-ES','gu-IN','ha-Latn-NG','hi-IN','hy-AM','id-ID','ig-NG','is-IS','ka-GE','kk-KZ','km-KH','kn-IN','kok-IN','ku-ARAB-IQ','ky-KG','lb-LU','lo-LA','mi-NZ','mk-MK','ml-IN','mn-MN','mr-IN','ms-MY','mt-MT','ne-NP','nn-NO','nso-ZA','or-IN','pa-Arab-PK','pa-IN','prs-AF','quc-Latn-GT','quz-PE','rw-RW','sd-Arab-PK','si-LK','sq-AL','sr-Cyrl-BA','sr-Cyrl-RS','sw-KE','ta-IN','te-IN','tg-Cyrl-TJ','ti-ET','tk-TM','tn-ZA','tt-RU','ug-CN','ur-PK','uz-Latn-UZ','vi-VN','wo-SN','xh-ZA','yo-NG','zu-ZA')]
        [string]$SetSetupUILang,
        [Parameter(ParameterSetName='Advanced')]
        [string]$SetSysLocale,
        [Parameter(ParameterSetName='Advanced')]
        [ValidateSet('ar-SA','bg-BG','zh-CN','zh-TW','hr-HR','cs-CZ','da-DK','nl-NL','en-US','en-GB','et-EE','fi-FI','fr-CA','fr-FR','de-DE','el-GR','he-IL','hu-HU','it-IT','ja-JP','ko-KR','lv-LV','lt-LT','nb-NO','pl-PL','pt-BR','pt-PT','ro-RO','ru-RU','sr-Latn-RS','sk-SK','sl-SI','es-MX','es-ES','sv-SE','th-TH','tr-TR','uk-UA','af-ZA','am-ET','as-IN','az-Latn-AZ','be-BY','bn-BD','bn-IN','bs-Latn-BA','ca-ES','ca-ES-valencia','chr-CHER-US','cy-GB','eu-ES','fa-IR','fil-PH','ga-IE','gd-GB','gl-ES','gu-IN','ha-Latn-NG','hi-IN','hy-AM','id-ID','ig-NG','is-IS','ka-GE','kk-KZ','km-KH','kn-IN','kok-IN','ku-ARAB-IQ','ky-KG','lb-LU','lo-LA','mi-NZ','mk-MK','ml-IN','mn-MN','mr-IN','ms-MY','mt-MT','ne-NP','nn-NO','nso-ZA','or-IN','pa-Arab-PK','pa-IN','prs-AF','quc-Latn-GT','quz-PE','rw-RW','sd-Arab-PK','si-LK','sq-AL','sr-Cyrl-BA','sr-Cyrl-RS','sw-KE','ta-IN','te-IN','tg-Cyrl-TJ','ti-ET','tk-TM','tn-ZA','tt-RU','ug-CN','ur-PK','uz-Latn-UZ','vi-VN','wo-SN','xh-ZA','yo-NG','zu-ZA')]
        [string]$SetUILang,
        [Parameter(ParameterSetName='Advanced')]
        [ValidateSet('ar-SA','bg-BG','zh-CN','zh-TW','hr-HR','cs-CZ','da-DK','nl-NL','en-US','en-GB','et-EE','fi-FI','fr-CA','fr-FR','de-DE','el-GR','he-IL','hu-HU','it-IT','ja-JP','ko-KR','lv-LV','lt-LT','nb-NO','pl-PL','pt-BR','pt-PT','ro-RO','ru-RU','sr-Latn-RS','sk-SK','sl-SI','es-MX','es-ES','sv-SE','th-TH','tr-TR','uk-UA','af-ZA','am-ET','as-IN','az-Latn-AZ','be-BY','bn-BD','bn-IN','bs-Latn-BA','ca-ES','ca-ES-valencia','chr-CHER-US','cy-GB','eu-ES','fa-IR','fil-PH','ga-IE','gd-GB','gl-ES','gu-IN','ha-Latn-NG','hi-IN','hy-AM','id-ID','ig-NG','is-IS','ka-GE','kk-KZ','km-KH','kn-IN','kok-IN','ku-ARAB-IQ','ky-KG','lb-LU','lo-LA','mi-NZ','mk-MK','ml-IN','mn-MN','mr-IN','ms-MY','mt-MT','ne-NP','nn-NO','nso-ZA','or-IN','pa-Arab-PK','pa-IN','prs-AF','quc-Latn-GT','quz-PE','rw-RW','sd-Arab-PK','si-LK','sq-AL','sr-Cyrl-BA','sr-Cyrl-RS','sw-KE','ta-IN','te-IN','tg-Cyrl-TJ','ti-ET','tk-TM','tn-ZA','tt-RU','ug-CN','ur-PK','uz-Latn-UZ','vi-VN','wo-SN','xh-ZA','yo-NG','zu-ZA')]
        [string]$SetUILangFallback,
        [Parameter(ParameterSetName='Advanced')]
        [string]$SetUserLocale
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
        $TaskName = "$TaskName"
        if ($Kind -eq 'Task') {
            $TaskPath = "$OSDBuilderTasks\OSBuild $TaskName.json"
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
            Write-Warning "Content will be overwritten!"
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
        Write-Host "-OSMedia Chain:                 $($OSMedia.OSMFamily)"
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
        #===================================================================================================
        Write-Host '========================================================================================' -ForegroundColor DarkGray
        Write-Host "Operating System (Parameter Based)" -ForegroundColor Green
        #===================================================================================================
        #   Install.wim RemoveAppx
        #===================================================================================================
        $TaskRemoveAppxProvisionedPackage = @()
        [array]$TaskRemoveAppxProvisionedPackage = Get-TaskRemoveAppxProvisionedPackage
        #===================================================================================================
        #   Install.wim Remove-WindowsPackage
        #===================================================================================================
        $TaskRemoveWindowsPackage = @()
        [array]$TaskRemoveWindowsPackage = Get-TaskRemoveWindowsPackage
        #===================================================================================================
        #   Install.wim Remove-WindowsCapability
        #===================================================================================================
        $TaskRemoveWindowsCapability = @()
        [array]$TaskRemoveWindowsCapability = Get-TaskRemoveWindowsCapability
        #===================================================================================================
        #   Install.Wim Disable-WindowsOptionalFeature
        #===================================================================================================
        $TaskDisableWindowsOptionalFeature = @()
        [array]$TaskDisableWindowsOptionalFeature = Get-TaskDisableWindowsOptionalFeature
        #===================================================================================================
        #   Install.Wim Enable-WindowsOptionalFeature
        #===================================================================================================
        $TaskEnableWindowsOptionalFeature = @()
        [array]$TaskEnableWindowsOptionalFeature = Get-TaskEnableWindowsOptionalFeature
        #===================================================================================================
        #===================================================================================================
        Write-Host '========================================================================================' -ForegroundColor DarkGray
        Write-Host "Operating System (Content Based)" -ForegroundColor Green
        #===================================================================================================
        #   Install.wim Windows Drivers
        #===================================================================================================
        $TaskDrivers =@()
        [array]$TaskDrivers = Get-TaskDrivers
        #===================================================================================================
        #   Install.wim Extra Files
        #===================================================================================================
        $TaskExtraFiles =@()
        [array]$TaskExtraFiles = Get-TaskExtraFiles
        #===================================================================================================
        #   Install.wim Windows Packages
        #===================================================================================================
        $SelectedWindowsPackages =@()
        [array]$SelectedWindowsPackages = Get-SelectedWindowsPackages
        #===================================================================================================
        #   Install.wim PowerShell Scripts
        #===================================================================================================
        $TaskScripts =@()
        if ($OSMedia.MajorVersion -eq 10) {[array]$TaskScripts = Get-TaskScripts}
        #===================================================================================================
        #   Install.wim Start Layout
        #===================================================================================================
        $TaskStartLayoutXML =@()
        if ($OSMedia.MajorVersion -eq 10) {[array]$TaskStartLayoutXML = Get-TaskStartLayoutXML}
        #===================================================================================================
        #   Install.wim Unattend.xml
        #===================================================================================================
        $TaskUnattendXML =@()
        if ($OSMedia.MajorVersion -eq 10) {$TaskUnattendXML = Get-TaskUnattendXML}
        #===================================================================================================
        #   WinPE Configuration
        #===================================================================================================
        Write-Host '========================================================================================' -ForegroundColor DarkGray
        Write-Host "WinPE (Content Based)" -ForegroundColor Green

        if ($SelectWinPEADK.IsPresent) {
            #===================================================================================================
            #   WinPE ADK
            #===================================================================================================
            $TaskWinPEADK =@()
            $TaskWinPEADK = Get-ChildItem -Path "$OSDBuilderContent\WinPE\ADK" *.cab -Recurse | Select-Object -Property Name, FullName
            foreach ($Pack in $TaskWinPEADK) {$Pack.FullName = $($Pack.FullName).replace("$OSDBuilderContent\",'')}
            $TaskWinPEADK = $TaskWinPEADK | Where-Object {$_.FullName -like "*$($OSMedia.Arch)*"}
            $TaskWinPEADK = $TaskWinPEADK | Where-Object {$_.FullName -like "*$($OSMedia.ReleaseId)*"}
            if ($null -eq $TaskWinPEADK) {Write-Warning "WinPE ADK: Add Content to $OSDBuilderContent\WinPE\ADK"}
            else {
                $TaskWinPEADK = $TaskWinPEADK | Out-GridView -Title "WinPE.wim ADK Packages: Select ADK Packages to apply and press OK (Esc or Cancel to Skip)" -PassThru
                if ($null -eq $TaskWinPEADK) {Write-Warning "WinPE.wim ADK Packages: Skipping"}
            }
            #===================================================================================================
            #   WinRE ADK
            #===================================================================================================
            $TaskWinREADK =@()
            $TaskWinREADK = Get-ChildItem -Path "$OSDBuilderContent\WinPE\ADK" *.cab -Recurse | Select-Object -Property Name, FullName
            foreach ($Pack in $TaskWinREADK) {$Pack.FullName = $($Pack.FullName).replace("$OSDBuilderContent\",'')}
            $TaskWinREADK = $TaskWinREADK | Where-Object {$_.FullName -like "*$($OSMedia.Arch)*"}
            $TaskWinREADK = $TaskWinREADK | Where-Object {$_.FullName -like "*$($OSMedia.ReleaseId)*"}
            if ($null -eq $TaskWinREADK) {Write-Warning "WinRE ADK: Add Content to $OSDBuilderContent\WinPE\ADK"}
            else {
                $TaskWinREADK = $TaskWinREADK | Out-GridView -Title "WinRE.wim ADK Packages: Select ADK Packages to apply and press OK (Esc or Cancel to Skip)" -PassThru
                if ($null -eq $TaskWinREADK) {
                    Write-Warning "WinRE.wim ADK Packages: Skipping"}
                else {
                    Write-Warning "If you add too many ADK Packages to WinRE, like .Net and PowerShell"
                    Write-Warning "You run a risk of your WinRE size increasing considerably"
                    Write-Warning "If your MBR System or UEFI Recovery Partition are 500MB,"
                    Write-Warning "your WinRE.wim should not be more than 400MB (100MB Free)"
                    Write-Warning "Consider changing your Task Sequences to have a 984MB"
                    Write-Warning "MBR System or UEFI Recovery Partition"
                }
            }
            #===================================================================================================
            #   WinSE ADK
            #===================================================================================================
            $TaskWinSEADK =@()
            $TaskWinSEADK = Get-ChildItem -Path "$OSDBuilderContent\WinPE\ADK" *.cab -Recurse | Select-Object -Property Name, FullName
            foreach ($Pack in $TaskWinSEADK) {$Pack.FullName = $($Pack.FullName).replace("$OSDBuilderContent\",'')}
            $TaskWinSEADK = $TaskWinSEADK | Where-Object {$_.FullName -like "*$($OSMedia.Arch)*"}
            $TaskWinSEADK = $TaskWinSEADK | Where-Object {$_.FullName -like "*$($OSMedia.ReleaseId)*"}
            if ($null -eq $TaskWinSEADK) {Write-Warning "WinSE ADK: Add Content to $OSDBuilderContent\WinPE\ADK"}
            else {
                $TaskWinSEADK = $TaskWinSEADK | Out-GridView -Title "WinSE.wim ADK Packages: Select ADK Packages to apply and press OK (Esc or Cancel to Skip)" -PassThru
                if ($null -eq $TaskWinSEADK) {Write-Warning "WinSE.wim ADK Packages: Skipping"}
            }
        }
        #===================================================================================================
        #   WinPE DaRT
        #===================================================================================================
        $SelectedWinPEDaRT =@()
        $SelectedWinPEDaRT = Get-SelectedWinPEDaRT
        #===================================================================================================
        #   WinPE Drivers
        #===================================================================================================
        $TaskWinPEDrivers =@()
        [array]$TaskWinPEDrivers = Get-TaskWinPEDrivers
        #===================================================================================================
        #   WinPE Extra Files
        #===================================================================================================
        $TaskWinPEExtraFiles =@()
        [array]$TaskWinPEExtraFiles = Get-TaskWinPEExtraFiles
        #===================================================================================================
        #   WinRE Extra Files
        #===================================================================================================
        $TaskWinREExtraFiles =@()
        [array]$TaskWinREExtraFiles = Get-TaskWinREExtraFiles
        #===================================================================================================
        #   WinSE Extra Files
        #===================================================================================================
        $TaskWinSEExtraFiles =@()
        [array]$TaskWinSEExtraFiles = Get-TaskWinSEExtraFiles
        #===================================================================================================
        #   WinPE Scripts
        #===================================================================================================
        $TaskWinPEScripts =@()
        [array]$TaskWinPEScripts = Get-TaskWinPEScripts
        #===================================================================================================
        #   WinRE Scripts
        #===================================================================================================
        $TaskWinREScripts =@()
        [array]$TaskWinREScripts = Get-TaskWinREScripts
        #===================================================================================================
        #   WinSE Scripts
        #===================================================================================================
        $TaskWinSEScripts =@()
        [array]$TaskWinSEScripts = Get-TaskWinSEScripts
        #===================================================================================================
        #   Operating System Add-Ons
        #===================================================================================================
        Write-Host '========================================================================================' -ForegroundColor DarkGray
        Write-Host "IsoExtract and Languages (Content Based)" -ForegroundColor Green
        #===================================================================================================
        #   Install.wim IsoExtract Content
        #===================================================================================================
        $ContentIsoExtract = @()
        if ($OSMedia.MajorVersion -eq 10) {[array]$ContentIsoExtract = Get-ContentIsoExtract}
        #===================================================================================================
        #   Install.wim Features On Demand
        #===================================================================================================
        $SelectedFeaturesOnDemand  = @()
        if ($OSMedia.MajorVersion -eq 10) {[array]$SelectedFeaturesOnDemand = Get-SelectedFeaturesOnDemand}
        #===================================================================================================
        #   Install.wim Language Packs
        #===================================================================================================
        $SelectedLanguagePacks  = @()
        if ($OSMedia.MajorVersion -eq 10) {[array]$SelectedLanguagePacks = Get-SelectedLanguagePacks}
        #===================================================================================================
        #   Install.wim Language Interface Packs
        #===================================================================================================
        $SelectedLanguageInterfacePacks  = @()
        if ($OSMedia.MajorVersion -eq 10) {[array]$SelectedLanguageInterfacePacks = Get-SelectedLanguageInterfacePacks}
        #===================================================================================================
        #   Install.wim Language Features On Demand
        #===================================================================================================
        $SelectedLanguageFeaturesOnDemand  = @()
        if ($OSMedia.MajorVersion -eq 10) {[array]$SelectedLanguageFeaturesOnDemand = Get-SelectedLanguageFeaturesOnDemand}
        #===================================================================================================
        #   Install.wim Local Experience Packs
        #===================================================================================================
        $SelectedLocalExperiencePacks = @()
        if ($OSMedia.MajorVersion -eq 10) {[array]$SelectedLocalExperiencePacks = Get-SelectedLocalExperiencePacks}
        #===================================================================================================
        #   Install.wim NetFX
        #===================================================================================================
        if ($OSMedia.MajorVersion -eq 6) {$EnableNetFX3 = $false}
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

            "EnableNetFX3" = [string]$EnableNetFX3;
            "StartLayoutXML" = [string]$TaskStartLayoutXML.FullName;
            "UnattendXML" = [string]$TaskUnattendXML.FullName;
            "WinPEAutoExtraFiles" = [string]$WinPEAutoExtraFiles;
            "WinPEDaRT" = [string]$SelectedWinPEDaRT.FullName;

            "ExtraFiles" = [string[]]$TaskExtraFiles.FullName;
            "Scripts" = [string[]]$TaskScripts.FullName;
            "Drivers" = [string[]]$TaskDrivers.FullName;

            "AddWindowsPackage" = [string[]]$SelectedWindowsPackages.FullName;
            "RemoveWindowsPackage" = [string[]]$TaskRemoveWindowsPackage.PackageName;
            "AddFeatureOnDemand" = [string[]]$SelectedFeaturesOnDemand.FullName;
            "EnableWindowsOptionalFeature" = [string[]]$TaskEnableWindowsOptionalFeature.FeatureName;
            "DisableWindowsOptionalFeature" = [string[]]$TaskDisableWindowsOptionalFeature.FeatureName;
            "RemoveAppxProvisionedPackage" = [string[]]$TaskRemoveAppxProvisionedPackage.PackageName;
            "RemoveWindowsCapability" = [string[]]$TaskRemoveWindowsCapability.Name;

            "WinPEDrivers" = [string[]]$TaskWinPEDrivers.FullName;
            "WinPEExtraFilesPE" = [string[]]$TaskWinPEExtraFiles.FullName;
            "WinPEExtraFilesRE" = [string[]]$TaskWinREExtraFiles.FullName;
            "WinPEExtraFilesSE" = [string[]]$TaskWinSEExtraFiles.FullName;
            "WinPEScriptsPE" = [string[]]$TaskWinPEScripts.FullName;
            "WinPEScriptsRE" = [string[]]$TaskWinREScripts.FullName;
            "WinPEScriptsSE" = [string[]]$TaskWinSEScripts.FullName
            "WinPEADKPE" = [string[]]$TaskWinPEADK.FullName;
            "WinPEADKRE" = [string[]]$TaskWinREADK.FullName;
            "WinPEADKSE" = [string[]]$TaskWinSEADK.FullName;

            "LangSetAllIntl" = [string]$SetAllIntl;
            "LangSetInputLocale" = [string]$SetInputLocale;
            "LangSetSKUIntlDefaults" = [string]$SetSKUIntlDefaults;
            "LangSetSetupUILang" = [string]$SetSetupUILang;
            "LangSetSysLocale" = [string]$SetSysLocale;
            "LangSetUILang" = [string]$SetUILang;
            "LangSetUILangFallback" = [string]$SetUILangFallback;
            "LangSetUserLocale" = [string]$SetUserLocale;
            "LanguageFeature" = [string[]]$SelectedLanguageFeaturesOnDemand.FullName;
            "LanguageInterfacePack" = [string[]]$SelectedLanguageInterfacePacks.FullName;
            "LanguagePack" = [string[]]$SelectedLanguagePacks.FullName;
            "LocalExperiencePacks" = [string[]]$SelectedLocalExperiencePacks.FullName;
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