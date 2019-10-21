function Show-ActionDuration {
    [CmdletBinding()]
    Param ()
    #===================================================================================================
    #   Show-ActionDuration
    #===================================================================================================
    $OSDDuration = $(Get-Date) - $Global:OSDStartTime
    Write-Host -ForegroundColor DarkGray "Duration: $($OSDDuration.ToString('mm\:ss'))"
    #===================================================================================================
}
function Show-ActionTime {
    [CmdletBinding()]
    Param ()
    #===================================================================================================
    #   Show-ActionTime
    #===================================================================================================
    $Global:OSDStartTime = Get-Date
    Write-Host -ForegroundColor White "$(($Global:OSDStartTime).ToString('yyyy-MM-dd-HHmmss')) " -NoNewline
    #Write-Host -ForegroundColor DarkGray "[$(($Global:OSDStartTime).ToString('yyyy-MM-dd-HHmmss'))] " -NoNewline
    #===================================================================================================
}
function Show-MediaImageInfoOS {
    [CmdletBinding()]
    Param ()
    #===================================================================================================
    #   Show-MediaImageInfoOS
    #===================================================================================================
    Write-Host '========================================================================================' -ForegroundColor DarkGray
    Write-Host -ForegroundColor Green "Source OSMedia Windows Image Information"
    Write-Host "-OSMedia Path:                  $OSMediaPath" -ForegroundColor Yellow
    Write-Host "-Image File:                    $OSImagePath"
    #Write-Host "-Image Index:                   $OSImageIndex"
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
    #Write-Host "-Bootable:                      $OSImageBootable"
    #Write-Host "-WimBoot:                       $OSWIMBoot"
    Write-Host "-Created Time:                  $OSCreatedTime"
    Write-Host "-Modified Time:                 $OSModifiedTime"
}
function Show-MediaInfoOS {
    [CmdletBinding()]
    Param ()
    Write-Host '========================================================================================' -ForegroundColor DarkGray
    Write-Host -ForegroundColor Green "OSMedia Information"
    Write-Host "-OSMediaName:   $OSMediaName" -ForegroundColor Yellow
    Write-Host "-OSMediaPath:   $OSMediaPath" -ForegroundColor Yellow
    Write-Host "-OS:            $OS"
    Write-Host "-WinPE:         $WinPE"
    Write-Host "-Info:          $Info"
    Write-Host "-Logs:          $Info\logs"
}
function Show-SkipUpdatesInfo {
    #Show-ActionTime
    #Write-Host -ForegroundColor DarkGray "                  -SkipUpdates Parameter was used"
}
function Show-TaskInfo {
    [CmdletBinding()]
    Param ()        
    #===================================================================================================
    Write-Verbose '19.1.25 OSBuild Task Information'
    #===================================================================================================
    Write-Host '========================================================================================' -ForegroundColor DarkGray
    Write-Host -ForegroundColor Green "OSBuild Task Information"
    Write-Host "-TaskName:                      $TaskName"
    Write-Host "-TaskVersion:                   $TaskVersion"
    Write-Host "-TaskType:                      $TaskType"
    Write-Host "-OSMedia Name:                  $OSMediaName"
    Write-Host "-OSMedia Path:                  $OSMediaPath"
    if ($CustomName) {Write-Host "-Custom Name:                   $CustomName"}
    if ($EnableNetFX3 -eq $true) {Write-Host "-Enable NetFx3:                 $EnableNetFX3"}
    if ($WinPEAutoExtraFiles -eq $true) {Write-Host "-WinPE Auto ExtraFiles:         $WinPEAutoExtraFiles"}

    if ($DisableFeature) {
        Write-Host "-Disable Feature:"
        foreach ($item in $DisableFeature)      {Write-Host $item -ForegroundColor DarkGray}}

    if ($EnableFeature) {
        Write-Host "-Enable Feature:"
        foreach ($item in $EnableFeature)       {Write-Host $item -ForegroundColor DarkGray}}

    if ($RemoveAppx) {
        Write-Host "-Remove Appx:"
        foreach ($item in $RemoveAppx)          {Write-Host $item -ForegroundColor DarkGray}}
    
    if ($RemoveCapability) {
        Write-Host "-Remove Capability:"
        foreach ($item in $RemoveCapability)    {Write-Host $item -ForegroundColor DarkGray}}
        
    if ($RemovePackage) {
        Write-Host "-Remove Packages:"
        foreach ($item in $RemovePackage)       {Write-Host $item -ForegroundColor DarkGray}}


    if ($StartLayoutXML)    {Write-Host "-Start Layout:                  $OSDBuilderContent\$StartLayoutXML"}
    if ($UnattendXML)       {Write-Host "-Unattend:                      $OSDBuilderContent\$UnattendXML"}
    if ($WinPEDaRT)         {Write-Host "-WinPE DaRT:                    $OSDBuilderContent\$WinPEDaRT"}
    
    #if ($OSDBuildPacks) {
        #Write-Host "-OSDBuildPacks:"
        #foreach ($item in $OSDBuildPacks)            {Write-Host "$OSDBuilderPath\BuildPacks\$item" -ForegroundColor Cyan}}
    
    if ($Drivers) {
        Write-Host "-Drivers:"
        foreach ($item in $Drivers)             {Write-Host "$OSDBuilderContent\$item" -ForegroundColor Cyan}}
    
    if ($ExtraFiles) {
        Write-Host "-Extra Files:"
        foreach ($item in $ExtraFiles)          {Write-Host "$OSDBuilderContent\$item" -ForegroundColor Cyan}}

    if ($FeaturesOnDemand) {
        Write-Host "-Features On Demand:"
        foreach ($item in $FeaturesOnDemand)    {Write-Host $item -ForegroundColor DarkGray}}
    
    if ($Packages) {
        Write-Host "-Packages:"
        foreach ($item in $Packages)            {Write-Host $item -ForegroundColor DarkGray}}

    if ($Scripts) {
        Write-Host "-Scripts:"
        foreach ($item in $Scripts)             {Write-Host $item -ForegroundColor DarkGray}}

    if ($WinPEDrivers) {
        Write-Host "-WinPE Drivers:"
        foreach ($item in $WinPEDrivers)        {Write-Host $item -ForegroundColor DarkGray}}
    
    if ($WinPEADKPE) {
        Write-Host "-WinPE ADK Packages:"
        foreach ($item in $WinPEADKPE)          {Write-Host $item -ForegroundColor DarkGray}}
    
    if ($WinPEADKRE) {
        Write-Host "-WinRE ADK Packages:"
        foreach ($item in $WinPEADKRE)          {Write-Host $item -ForegroundColor DarkGray}}
    
    if ($WinPEADKSE) {
        Write-Host "-WinSE ADK Packages:"
        foreach ($item in $WinPEADKSE)          {Write-Host $item -ForegroundColor DarkGray}}
    
    if ($WinPEExtraFilesPE) {
        Write-Host "-WinPE Extra Files:"
        foreach ($item in $WinPEExtraFilesPE)   {Write-Host $item -ForegroundColor DarkGray}}
    
    if ($WinPEExtraFilesRE) {
        Write-Host "-WinRE Extra Files:"
        foreach ($item in $WinPEExtraFilesRE)   {Write-Host $item -ForegroundColor DarkGray}}
    
    if ($WinPEExtraFilesSE) {
        Write-Host "-WinSE Extra Files:"
        foreach ($item in $WinPEExtraFilesSE)   {Write-Host $item -ForegroundColor DarkGray}}
    
    if ($WinPEScriptsPE) {
        Write-Host "-WinPE Scripts:"
        foreach ($item in $WinPEScriptsPE)      {Write-Host $item -ForegroundColor DarkGray}}
    
    if ($WinPEScriptsRE) {
        Write-Host "-WinRE Scripts:"
        foreach ($item in $WinPEScriptsRE)      {Write-Host $item -ForegroundColor DarkGray}}
    
    if ($WinPEScriptsSE) {
        Write-Host "-WinSE Scripts:"
        foreach ($item in $WinPEScriptsSE)      {Write-Host $item -ForegroundColor DarkGray}}

    if ($SetAllIntl)            {Write-Host "-SetAllIntl (Language):         $SetAllIntl"}
    if ($SetInputLocale)        {Write-Host "-SetInputLocale (Language):     $SetInputLocale"}
    if ($SetSKUIntlDefaults)    {Write-Host "-SetSKUIntlDefaults (Language): $SetSKUIntlDefaults"}
    if ($SetSetupUILang)        {Write-Host "-SetSetupUILang (Language):     $SetSetupUILang"}
    if ($SetSysLocale)          {Write-Host "-SetSysLocale (Language):       $SetSysLocale"}
    if ($SetUILang)             {Write-Host "-SetUILang (Language):          $SetUILang"}
    if ($SetUILangFallback)     {Write-Host "-SetUILangFallback (Language):  $SetUILangFallback"}
    if ($SetUserLocale)         {Write-Host "-SetUserLocale (Language):      $SetUserLocale"}

    if ($LanguageFeatures) {
        Write-Host "-Language Features:"
        foreach ($item in $LanguageFeatures)        {Write-Host $item -ForegroundColor DarkGray}}
    
    if ($LanguageInterfacePacks) {
        Write-Host "-Language Interface Packs:"
        foreach ($item in $LanguageInterfacePacks)  {Write-Host $item -ForegroundColor DarkGray}}
    
    if ($LanguagePacks) {
        Write-Host "-Language Packs:"
        foreach ($item in $LanguagePacks)           {Write-Host $item -ForegroundColor DarkGray}}
    
    if ($LocalExperiencePacks) {
        Write-Host "-Local Experience Packs:"
        foreach ($item in $LocalExperiencePacks)    {Write-Host $item -ForegroundColor DarkGray}}
    
    if ($LanguageCopySources) {
        Write-Host "-Language Sources Copy:"
        foreach ($item in $LanguageCopySources)     {Write-Host $item -ForegroundColor DarkGray}}

    $CombinedOSMedia = Get-OSMedia -Revision OK | Where-Object {$_.OSMFamily -eq $TaskOSMFamily}

    $CombinedTask = [ordered]@{
        "TaskType" = [string]"OSBuild";
        "TaskName" = [string]$TaskName;
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
        #OSDBuildPacks = [string[]]$($OSDBuildPacks | Sort-Object -Unique);
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
function Show-WindowsImageInfo {
    [CmdletBinding()]
    Param ()
    Write-Host '========================================================================================' -ForegroundColor DarkGray
    Write-Host -ForegroundColor Green "Windows Image Information"
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
function Show-WorkingInfoOS {
    [CmdletBinding()]
    Param ()
    #===================================================================================================
    Write-Verbose '19.1.1 Working Information'
    #===================================================================================================
    Write-Host '========================================================================================' -ForegroundColor DarkGray
    Write-Host -ForegroundColor Green "Working Information"
    Write-Host "-WorkingName:   $WorkingName" -ForegroundColor Yellow
    Write-Host "-WorkingPath:   $WorkingPath" -ForegroundColor Yellow
    Write-Host "-OS:            $OS"
    Write-Host "-WinPE:         $WinPE"
    Write-Host "-Info:          $Info"
    Write-Host "-Logs:          $Info\logs"
    Write-Host '========================================================================================' -ForegroundColor DarkGray
}