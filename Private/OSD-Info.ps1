function OSD-Info-OSMedia {
    [CmdletBinding()]
    PARAM ()
    Write-Host '========================================================================================' -ForegroundColor DarkGray
    Write-Host "OSMedia Information" -ForegroundColor Green
    Write-Host "-OSMediaName:   $OSMediaName" -ForegroundColor Yellow
    Write-Host "-OSMediaPath:   $OSMediaPath" -ForegroundColor Yellow
    Write-Host "-OS:            $OS"
    Write-Host "-WinPE:         $WinPE"
    Write-Host "-Info:          $Info"
    Write-Host "-Logs:          $Info\logs"
}

function OSD-Info-WindowsImage {
    [CmdletBinding()]
    PARAM ()
    Write-Host '========================================================================================' -ForegroundColor DarkGray
    Write-Host "Windows Image Information" -ForegroundColor Green
    Write-Host "Source Path:    $OSSourcePath"
    Write-Host "-Image File:    $OSImagePath"
    Write-Host "-Image Index:   $OSImageIndex"
    Write-Host "-Name:          $OSImageName"
    Write-Host "-Description:   $OSImageDescription"
    Write-Host "-Architecture:  $OSArchitecture"
    Write-Host "-Edition:       $OSEditionID"
    Write-Host "-Type:          $OSInstallationType"
    Write-Host "-Languages:     $OSLanguages"
    Write-Host "-Build:         $OSBuild"
    Write-Host "-Version:       $OSVersion"
    Write-Host "-SPBuild:       $OSSPBuild"
    Write-Host "-SPLevel:       $OSSPLevel"
    Write-Host "-Bootable:      $OSImageBootable"
    Write-Host "-WimBoot:       $OSWIMBoot"
    Write-Host "-Created Time:  $OSCreatedTime"
    Write-Host "-Modified Time: $OSModifiedTime"
    Write-Host "-UBR:           $UBR"
    Write-Host "-OSMGuid:       $OSMGuid"
}

function OSD-Info-WorkingInformation {
    [CmdletBinding()]
    PARAM ()
    #===================================================================================================
    Write-Verbose '19.1.1 Working Information'
    #===================================================================================================
    Write-Host '========================================================================================' -ForegroundColor DarkGray
    Write-Host "Working Information" -ForegroundColor Green
    Write-Host "-WorkingName:   $WorkingName" -ForegroundColor Yellow
    Write-Host "-WorkingPath:   $WorkingPath" -ForegroundColor Yellow
    Write-Host "-OS:            $OS"
    Write-Host "-WinPE:         $WinPE"
    Write-Host "-Info:          $Info"
    Write-Host "-Logs:          $Info\logs"
}
function OSD-Info-SourceOSMedia {
    [CmdletBinding()]
    PARAM ()
    #===================================================================================================
    #   OSD-Info-SourceOSMedia
    #===================================================================================================
    Write-Host '========================================================================================' -ForegroundColor DarkGray
    Write-Host "Source OSMedia Windows Image Information" -ForegroundColor Green
    Write-Host "-OSMedia Path:                  $OSMediaPath" -ForegroundColor Yellow
    Write-Host "-Image File:                    $OSImagePath"
    Write-Host "-Image Index:                   $OSImageIndex"
    Write-Host "-Name:                          $OSImageName"
    Write-Host "-Description:                   $OSImageDescription"
    Write-Host "-Architecture:                  $OSArchitecture"
    Write-Host "-Edition:                       $OSEditionID"
    Write-Host "-Type:                          $OSInstallationType"
    Write-Host "-Languages:                     $OSLanguages"
    Write-Host "-Major Version:                 $OSMajorVersion"
    Write-Host "-Build:                         $OSBuild"
    Write-Host "-Version:                       $OSVersion"
    Write-Host "-SPBuild:                       $OSSPBuild"
    Write-Host "-SPLevel:                       $OSSPLevel"
    Write-Host "-Bootable:                      $OSImageBootable"
    Write-Host "-WimBoot:                       $OSWIMBoot"
    Write-Host "-Created Time:                  $OSCreatedTime"
    Write-Host "-Modified Time:                 $OSModifiedTime"
}
function OSD-Info-TaskInformation {
    [CmdletBinding()]
    PARAM ()        
    #===================================================================================================
    Write-Verbose '19.1.25 OSBuild Task Information'
    #===================================================================================================
    Write-Host '========================================================================================' -ForegroundColor DarkGray
    Write-Host "OSBuild Task Information" -ForegroundColor Green
    Write-Host "-TaskName:                      $TaskName"
    Write-Host "-TaskVersion:                   $TaskVersion"
    Write-Host "-TaskType:                      $TaskType"
    Write-Host "-OSMedia Name:                  $OSMediaName"
    Write-Host "-OSMedia Path:                  $OSMediaPath"
    Write-Host "-Custom Name:                   $CustomName"
    Write-Host "-Disable Feature:"
    if ($DisableFeature) {foreach ($item in $DisableFeature)            {Write-Host $item -ForegroundColor DarkGray}}
    Write-Host "-Drivers:"
    if ($Drivers) {foreach ($item in $Drivers)                          {Write-Host $item -ForegroundColor DarkGray}}
    Write-Host "-Enable Feature:"
    if ($EnableFeature) {foreach ($item in $EnableFeature)              {Write-Host $item -ForegroundColor DarkGray}}
    Write-Host "-Enable NetFx3:                 $EnableNetFX3"
    Write-Host "-Extra Files:"
    if ($ExtraFiles) {foreach ($item in $ExtraFiles)                    {Write-Host $item -ForegroundColor DarkGray}}
    Write-Host "-Features On Demand:"
    if ($FeaturesOnDemand) {foreach ($item in $FeaturesOnDemand)        {Write-Host $item -ForegroundColor DarkGray}}
    Write-Host "-Packages:"
    if ($Packages) {foreach ($item in $Packages)                        {Write-Host $item -ForegroundColor DarkGray}}
    Write-Host "-Remove Appx:"
    if ($RemoveAppx) {foreach ($item in $RemoveAppx)                    {Write-Host $item -ForegroundColor DarkGray}}
    Write-Host "-Remove Capability:"
    if ($RemoveCapability) {foreach ($item in $RemoveCapability)        {Write-Host $item -ForegroundColor DarkGray}}
    Write-Host "-Remove Packages:"
    if ($RemovePackage) {foreach ($item in $RemovePackage)              {Write-Host $item -ForegroundColor DarkGray}}
    Write-Host "-Scripts:"
    if ($Scripts) {foreach ($item in $Scripts)                          {Write-Host $item -ForegroundColor DarkGray}}
    Write-Host "-Start Layout:                  $StartLayoutXML"
    Write-Host "-Unattend:                      $UnattendXML"
    Write-Host "-WinPE Auto ExtraFiles:         $WinPEAutoExtraFiles"
    Write-Host "-WinPE DaRT:                    $WinPEDaRT"
    Write-Host "-WinPE Drivers:"
    if ($WinPEDrivers) {foreach ($item in $WinPEDrivers)                {Write-Host $item -ForegroundColor DarkGray}}
    Write-Host "-WinPE ADK Packages:"
    if ($WinPEADKPE) {foreach ($item in $WinPEADKPE)                    {Write-Host $item -ForegroundColor DarkGray}}
    Write-Host "-WinRE ADK Packages:"
    if ($WinPEADKRE) {foreach ($item in $WinPEADKRE)                    {Write-Host $item -ForegroundColor DarkGray}}
    Write-Host "-WinSE ADK Packages:"
    if ($WinPEADKSE) {foreach ($item in $WinPEADKSE)                    {Write-Host $item -ForegroundColor DarkGray}}
    Write-Host "-WinPE Extra Files:"
    if ($WinPEExtraFilesPE) {foreach ($item in $WinPEExtraFilesPE)      {Write-Host $item -ForegroundColor DarkGray}}
    Write-Host "-WinRE Extra Files:"
    if ($WinPEExtraFilesRE) {foreach ($item in $WinPEExtraFilesRE)      {Write-Host $item -ForegroundColor DarkGray}}
    Write-Host "-WinSE Extra Files:"
    if ($WinPEExtraFilesSE) {foreach ($item in $WinPEExtraFilesSE)      {Write-Host $item -ForegroundColor DarkGray}}
    Write-Host "-WinPE Scripts:"
    if ($WinPEScriptsPE) {foreach ($item in $WinPEScriptsPE)            {Write-Host $item -ForegroundColor DarkGray}}
    Write-Host "-WinRE Scripts:"
    if ($WinPEScriptsRE) {foreach ($item in $WinPEScriptsRE)            {Write-Host $item -ForegroundColor DarkGray}}
    Write-Host "-WinSE Scripts:"
    if ($WinPEScriptsSE) {foreach ($item in $WinPEScriptsSE)            {Write-Host $item -ForegroundColor DarkGray}}
    Write-Host "-SetAllIntl (Language):         $SetAllIntl"
    Write-Host "-SetInputLocale (Language):     $SetInputLocale"
    Write-Host "-SetSKUIntlDefaults (Language): $SetSKUIntlDefaults"
    Write-Host "-SetSetupUILang (Language):     $SetSetupUILang"
    Write-Host "-SetSysLocale (Language):       $SetSysLocale"
    Write-Host "-SetUILang (Language):          $SetUILang"
    Write-Host "-SetUILangFallback (Language):  $SetUILangFallback"
    Write-Host "-SetUserLocale (Language):      $SetUserLocale"
    Write-Host "-Language Features:"
    if ($LanguageFeatures) {foreach ($item in $LanguageFeatures)        {Write-Host $item -ForegroundColor DarkGray}}
    Write-Host "-Language Interface Packs:"
    if ($LanguageInterfacePacks) {foreach ($item in $LanguageInterfacePacks) {Write-Host $item -ForegroundColor DarkGray}}
    Write-Host "-Language Packs:"
    if ($LanguagePacks) {foreach ($item in $LanguagePacks)              {Write-Host $item -ForegroundColor DarkGray}}
    Write-Host "-Local Experience Packs:"
    if ($LocalExperiencePacks) {foreach ($item in $LocalExperiencePacks){Write-Host $item -ForegroundColor DarkGray}}

    $CombinedOSMedia = Get-OSMedia | Where-Object {$_.Name -eq "$OSMediaName"}

    $CombinedTask = [ordered]@{
        "TaskType" = [string]"OSBuild";
        "TaskName" = [string]"Merged Last Run";
        "TaskVersion" = [string]$TaskVersion;
        "TaskGuid" = [string]$(New-Guid);
        "CustomName" = [string]$CustomName;
        "OSMFamily" = [string]$TaskOSMFamily
        "OSMGuid" = [string]$CombinedOSMedia.OSMGuid;
        "Name" = [string]$OSMediaName;

        "ImageName" = [string]$CombinedOSMedia.ImageName;
        "Arch" = [string]$CombinedOSMedia.Arch;
        "ReleaseId" = [string]$CombinedOSMedia.ReleaseId;
        "UBR" = [string]$CombinedOSMedia.UBR;
        "Languages" = [string[]]$CombinedOSMedia.Languages;
        "EditionId" = [string]$CombinedOSMedia.EditionId;
        "InstallationType" = [string]$CombinedOSMedia.InstallationType;
        "MajorVersion" = [string]$CombinedOSMedia.MajorVersion;
        "Build" = [string]$CombinedOSMedia.Build;
        "CreatedTime" = [datetime]$CombinedOSMedia.CreatedTime;
        "ModifiedTime" = [datetime]$CombinedOSMedia.ModifiedTime;

        "EnableNetFX3" = [string]$EnableNetFX3;
        "StartLayoutXML" = [string]$StartLayoutXML;
        "UnattendXML" = [string]$UnattendXML;
        "WinPEAutoExtraFiles" = [string]$WinPEAutoExtraFiles;
        "WinPEDaRT" = [string]$WinPEDaRT;

        "ExtraFiles" = [string[]]$($ExtraFiles | Sort-Object -Unique);
        "Scripts" = [string[]]$($Scripts | Sort-Object -Unique);
        "Drivers" = [string[]]$($Drivers | Sort-Object -Unique);

        "AddWindowsPackage" = [string[]]$($Packages | Sort-Object -Unique);
        "RemoveWindowsPackage" = [string[]]$($RemovePackage | Sort-Object -Unique);
        "AddFeatureOnDemand" = [string[]]$($FeaturesOnDemand | Sort-Object -Unique);
        "EnableWindowsOptionalFeature" = [string[]]$($EnableFeature | Sort-Object -Unique);
        "DisableWindowsOptionalFeature" = [string[]]$($DisableFeature | Sort-Object -Unique);
        "RemoveAppxProvisionedPackage" = [string[]]$($RemoveAppx | Sort-Object -Unique);
        "RemoveWindowsCapability" = [string[]]$($RemoveCapability | Sort-Object -Unique);

        "WinPEDrivers" = [string[]]$($WinPEDrivers | Sort-Object -Unique);
        "WinPEExtraFilesPE" = [string[]]$($WinPEExtraFilesPE | Sort-Object -Unique);
        "WinPEExtraFilesRE" = [string[]]$($WinPEExtraFilesRE | Sort-Object -Unique);
        "WinPEExtraFilesSE" = [string[]]$($WinPEExtraFilesSE | Sort-Object -Unique);
        "WinPEScriptsPE" = [string[]]$($WinPEScriptsPE | Sort-Object -Unique);
        "WinPEScriptsRE" = [string[]]$($WinPEScriptsRE | Sort-Object -Unique);
        "WinPEScriptsSE" = [string[]]$($WinPEScriptsSE | Sort-Object -Unique);
        "WinPEADKPE" = [string[]]$($WinPEADKPE | Select-Object -Unique);
        "WinPEADKRE" = [string[]]$($WinPEADKRE | Select-Object -Unique);
        "WinPEADKSE" = [string[]]$($WinPEADKSE | Select-Object -Unique);

        "LangSetAllIntl" = [string]$SetAllIntl;
        "LangSetInputLocale" = [string]$SetInputLocale;
        "LangSetSKUIntlDefaults" = [string]$SetSKUIntlDefaults;
        "LangSetSetupUILang" = [string]$SetSetupUILang;
        "LangSetSysLocale" = [string]$SetSysLocale;
        "LangSetUILang" = [string]$SetUILang;
        "LangSetUILangFallback" = [string]$SetUILangFallback;
        "LangSetUserLocale" = [string]$SetUserLocale;
        "LanguageFeature" = [string[]]$($LanguageFeatures | Sort-Object -Unique);
        "LanguageInterfacePack" = [string[]]$($LanguageInterfacePacks | Sort-Object -Unique);
        "LanguagePack" = [string[]]$($LanguagePacks | Sort-Object -Unique);
        "LocalExperiencePacks" = [string[]]$($LocalExperiencePacks | Sort-Object -Unique);
    }
    $CombinedTask | ConvertTo-Json | Out-File "$($CombinedOSMedia.FullName)\OSBuild.json"
}