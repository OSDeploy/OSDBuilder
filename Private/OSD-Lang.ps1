function OSD-Lang-LanguagePacks {
    [CmdletBinding()]
    PARAM ()
    if ($OSMajorVersion -ne 10) {Return}
    Write-Host '========================================================================================' -ForegroundColor DarkGray
    Write-Host "Install.wim: Language Packs"	-ForegroundColor Green

    foreach ($Update in $LanguagePacks) {
        if (Test-Path "$OSDBuilderContent\$Update") {
            if ($Update -like "*.cab") {
                Write-Host "$OSDBuilderContent\$Update" -ForegroundColor DarkGray
                Add-WindowsPackage -Path "$MountDirectory" -PackagePath "$OSDBuilderContent\$Update" -LogPath "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-LanguagePack.log" | Out-Null
            } elseif ($Update -like "*.appx") {
                Write-Host "$OSDBuilderContent\$Update" -ForegroundColor DarkGray
                Add-AppxProvisionedPackage -Path "$MountDirectory" -PackagePath "$OSDBuilderContent\$Update" -LicensePath "$((Get-Item $OSDBuilderContent\$Update).Directory.FullName)\License.xml" -LogPath "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-LocalExperiencePack.log" | Out-Null
            }
        } else {
            Write-Warning "Not Found: $OSDBuilderContent\$Update"
        }
    }
}
function OSD-Lang-LanguageInterfacePacks {
    [CmdletBinding()]
    PARAM ()
    if ($OSMajorVersion -ne 10) {Return}
    Write-Host '========================================================================================' -ForegroundColor DarkGray
    Write-Host "Install.wim: Language Interface Packs"	-ForegroundColor Green

    foreach ($Update in $LanguageInterfacePacks) {
        if (Test-Path "$OSDBuilderContent\$Update") {
            Write-Host "$OSDBuilderContent\$Update" -ForegroundColor DarkGray
            Add-WindowsPackage -Path "$MountDirectory" -PackagePath "$OSDBuilderContent\$Update" -LogPath "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-LanguageInterfacePack.log" | Out-Null
        } else {
            Write-Warning "Not Found: $OSDBuilderContent\$Update"
        }
    }
}
function OSD-Lang-LocalExperiencePacks {
    [CmdletBinding()]
    PARAM ()
    if ($OSMajorVersion -ne 10) {Return}
    Write-Host '========================================================================================' -ForegroundColor DarkGray
    Write-Host "Install.wim: Local Experience Packs"	-ForegroundColor Green

    foreach ($Update in $LocalExperiencePacks) {
        if (Test-Path "$OSDBuilderContent\$Update") {
            Write-Host "$OSDBuilderContent\$Update" -ForegroundColor DarkGray
            Add-AppxProvisionedPackage -Path "$MountDirectory" -PackagePath "$OSDBuilderContent\$Update" -LicensePath "$((Get-Item $OSDBuilderContent\$Update).Directory.FullName)\License.xml" -LogPath "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-LocalExperiencePack.log" | Out-Null
        } else {
            Write-Warning "Not Found: $OSDBuilderContent\$Update"
        }
    }
}
function OSD-Lang-LanguageFeatures {
    [CmdletBinding()]
    PARAM ()
    if ($OSMajorVersion -ne 10) {Return}
    Write-Host '========================================================================================' -ForegroundColor DarkGray
    Write-Host "Install.wim: Language Features"	-ForegroundColor Green
    
    foreach ($Update in $LanguageFeatures | Where-Object {$_ -notlike "*Speech*"}) {
        if (Test-Path "$OSDBuilderContent\$Update") {
            Write-Host "$OSDBuilderContent\$Update" -ForegroundColor DarkGray
            Add-WindowsPackage -Path "$MountDirectory" -PackagePath "$OSDBuilderContent\$Update" -LogPath "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-LanguageFeatures.log" | Out-Null
        }
    }
    foreach ($Update in $LanguageFeatures | Where-Object {$_ -like "*TextToSpeech*"}) {
        if (Test-Path "$OSDBuilderContent\$Update") {
            Write-Host "$OSDBuilderContent\$Update" -ForegroundColor DarkGray
            Add-WindowsPackage -Path "$MountDirectory" -PackagePath "$OSDBuilderContent\$Update" -LogPath "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-LanguageFeatures.log" | Out-Null
        }
    }
    foreach ($Update in $LanguageFeatures | Where-Object {$_ -like "*Speech*" -and $_ -notlike "*TextToSpeech*"}) {
        if (Test-Path "$OSDBuilderContent\$Update") {
            Write-Host "$OSDBuilderContent\$Update" -ForegroundColor DarkGray
            Add-WindowsPackage -Path "$MountDirectory" -PackagePath "$OSDBuilderContent\$Update" -LogPath "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-LanguageFeatures.log" | Out-Null
        }
    }
}
function OSD-Lang-LanguageSettings {
    [CmdletBinding()]
    PARAM ()
    if ($OSMajorVersion -ne 10) {Return}
    Write-Host '========================================================================================' -ForegroundColor DarkGray
    Write-Host "Install.wim: Language Settings" -ForegroundColor Green

    #===================================================================================================
    Write-Verbose '19.1.1 Install.wim: Generating Langini'
    #===================================================================================================
    if ($SetAllIntl) {
        #Write-Host '========================================================================================' -ForegroundColor DarkGray
        Write-Host "Install.wim: SetAllIntl" -ForegroundColor Green
        Dism /Image:"$MountDirectory" /Set-AllIntl:"$SetAllIntl" /LogPath:"$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Dism-SetAllIntl.log" | Out-Null
    }
    if ($SetInputLocale) {
        #Write-Host '========================================================================================' -ForegroundColor DarkGray
        Write-Host "Install.wim: SetInputLocale" -ForegroundColor Green
        Dism /Image:"$MountDirectory" /Set-InputLocale:"$SetInputLocale" /LogPath:"$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Dism-SetInputLocale.log" | Out-Null
    }
    if ($SetSKUIntlDefaults) {
        #Write-Host '========================================================================================' -ForegroundColor DarkGray
        Write-Host "Install.wim: SetSKUIntlDefaults" -ForegroundColor Green
        Dism /Image:"$MountDirectory" /Set-SKUIntlDefaults:"$SetSKUIntlDefaults" /LogPath:"$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Dism-SetSKUIntlDefaults.log" | Out-Null
    }
    if ($SetSetupUILang) {
        #Write-Host '========================================================================================' -ForegroundColor DarkGray
        Write-Host "Install.wim: SetSetupUILang" -ForegroundColor Green
        Dism /Image:"$MountDirectory" /Set-SetupUILang:"$SetSetupUILang" /Distribution:"$OS" /LogPath:"$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Dism-SetSetupUILang.log" | Out-Null
    }
    if ($SetSysLocale) {
        #Write-Host '========================================================================================' -ForegroundColor DarkGray
        Write-Host "Install.wim: SetSysLocale" -ForegroundColor Green
        Dism /Image:"$MountDirectory" /Set-SysLocale:"$SetSysLocale" /LogPath:"$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Dism-SetSysLocale.log" | Out-Null
    }
    if ($SetUILang) {
        #Write-Host '========================================================================================' -ForegroundColor DarkGray
        Write-Host "Install.wim: SetUILang" -ForegroundColor Green
        Dism /Image:"$MountDirectory" /Set-UILang:"$SetUILang" /LogPath:"$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Dism-SetUILang.log" | Out-Null
    }
    if ($SetUILangFallback) {
        #Write-Host '========================================================================================' -ForegroundColor DarkGray
        Write-Host "Install.wim: SetUILangFallback" -ForegroundColor Green
        Dism /Image:"$MountDirectory" /Set-UILangFallback:"$SetUILangFallback" /LogPath:"$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Dism-SetUILangFallback.log" | Out-Null
    }
    if ($SetUserLocale) {
        #Write-Host '========================================================================================' -ForegroundColor DarkGray
        Write-Host "Install.wim: SetUserLocale" -ForegroundColor Green
        Dism /Image:"$MountDirectory" /Set-UserLocale:"$SetUserLocale" /LogPath:"$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Dism-SetUserLocale.log" | Out-Null
    }
    Write-Host '========================================================================================' -ForegroundColor DarkGray
    Write-Host "Install.wim: Generating Updated Langini" -ForegroundColor Green
    Dism /Image:"$MountDirectory" /Gen-LangIni /Distribution:"$OS" /LogPath:"$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Dism-gen-langini.log" | Out-Null
}