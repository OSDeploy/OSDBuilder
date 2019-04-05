
function Get-TaskContentLanguagePack {
    [CmdletBinding()]
    PARAM ()
    $LanguageLpIsoExtractDir = @()
    $LanguageLpIsoExtractDir = $ContentIsoExtract | Where-Object {$_.FullName -notlike "*FOD*"}
    $LanguageLpIsoExtractDir = $LanguageLpIsoExtractDir | Where-Object {$_.FullName -notlike "*LanguageFeatures*"}
    $LanguageLpIsoExtractDir = $LanguageLpIsoExtractDir | Where-Object {$_.FullName -like "*\langpacks\*"}
    $LanguageLpIsoExtractDir = $LanguageLpIsoExtractDir | Where-Object {$_.Name -notlike "*Language-Interface-Pack*"}

    $LanguageLpUpdatesDir = @()
    if (Test-Path "$OSDBuilderContent\Updates\LanguagePack") {
        $LanguageLpUpdatesDir = Get-ChildItem -Path "$OSDBuilderContent\Updates\LanguagePack" *.cab -Recurse | Select-Object -Property Name, FullName
        $LanguageLpUpdatesDir = $LanguageLpUpdatesDir | Where-Object {$_.FullName -like "*$($OSMedia.Arch)*"}
    }

    $LanguageLpLegacyDir = @()
    if (Test-Path "$OSDBuilderContent\LanguagePacks") {
        $LanguageLpLegacyDir = Get-ChildItem -Path "$OSDBuilderContent\LanguagePacks" *.cab -Recurse | Select-Object -Property Name, FullName
        $LanguageLpLegacyDir = $LanguageLpLegacyDir | Where-Object {$_.FullName -like "*$($OSMedia.Arch)*"}
    }

    [array]$LanguagePack = [array]$LanguageLpIsoExtractDir + [array]$LanguageLpUpdatesDir + [array]$LanguageLpLegacyDir

    if ($OSMedia.InstallationType -eq 'Client') {$LanguagePack = $LanguagePack | Where-Object {$_.FullName -notlike "*Windows Server*"}}
    if ($OSMedia.InstallationType -like "*Server*") {$LanguagePack = $LanguagePack | Where-Object {$_.FullName -like "*Windows Server*"}}
    if ($($OSMedia.ReleaseId)) {$LanguagePack = $LanguagePack | Where-Object {$_.FullName -like "*$($OSMedia.ReleaseId)*"}}

    foreach ($Package in $LanguagePack) {$Package.FullName = $($Package.FullName).replace("$OSDBuilderContent\",'')}

    if ($null -eq $LanguagePack) {Write-Warning "Install.wim Language Packs: Not Found"}
    else {
        if ($ExistingTask.LanguagePack) {
            foreach ($Item in $ExistingTask.LanguagePack) {
                $LanguagePack = $LanguagePack | Where-Object {$_.FullName -ne $Item}
            }
        }
        $LanguagePack = $LanguagePack | Sort-Object -Property FullName | Out-GridView -Title "Install.wim Language Packs: Select Packages to apply and press OK (Esc or Cancel to Skip)" -PassThru
        if ($null -eq $LanguagePack) {Write-Warning "Install.wim Language Packs: Skipping"}
    }
    foreach ($Item in $LanguagePack) {Write-Host "$($Item.FullName)" -ForegroundColor White}
    Return $LanguagePack
}
function Get-TaskContentLanguageFeature {
    [CmdletBinding()]
    PARAM ()
    $LanguageFodIsoExtractDir = @()
    $LanguageFodIsoExtractDir = $ContentIsoExtract | Where-Object {$_.Name -like "*LanguageFeatures*"}
    if ($OSMedia.InstallationType -eq 'Client') {
        if ($($OSMedia.Arch) -eq 'x86') {$LanguageFodIsoExtractDir = $LanguageFodIsoExtractDir | Where-Object {$_.FullName -like "*x86*"}}
        if ($($OSMedia.Arch) -eq 'x64') {$LanguageFodIsoExtractDir = $LanguageFodIsoExtractDir | Where-Object {$_.FullName -like "*x64*" -or $_.FullName -like "*amd64*"}}
    }

    $LanguageFodUpdatesDir = @()
    if (Test-Path "$OSDBuilderContent\Updates\LanguageFeature") {
        $LanguageFodUpdatesDir = Get-ChildItem -Path "$OSDBuilderContent\Updates\LanguageFeature" *.cab -Recurse | Select-Object -Property Name, FullName
        foreach ($Package in $LanguageFodUpdatesDir) {$Package.FullName = $($Package.FullName).replace("$OSDBuilderContent\",'')}
        if ($($OSMedia.Arch) -eq 'x86') {$LanguageFodUpdatesDir = $LanguageFodUpdatesDir | Where-Object {$_.FullName -like "*x86*"}}
        if ($($OSMedia.Arch) -eq 'x64') {$LanguageFodUpdatesDir = $LanguageFodUpdatesDir | Where-Object {$_.FullName -like "*x64*" -or $_.FullName -like "*amd64*"}}
        if ($($OSMedia.ReleaseId)) {$LanguageFodUpdatesDir = $LanguageFodUpdatesDir | Where-Object {$_.FullName -like "*$($OSMedia.ReleaseId)*"}}
    }

    [array]$LanguageFeature = [array]$LanguageFodIsoExtractDir + [array]$LanguageFodUpdatesDir
    if ($null -eq $LanguageFeature) {Write-Warning "Install.wim Language Features On Demand: Not Found"}
    else {
        if ($ExistingTask.LanguageFeature) {
            foreach ($Item in $ExistingTask.LanguageFeature) {
                $LanguageFeature = $LanguageFeature | Where-Object {$_.FullName -ne $Item}
            }
        }
        $LanguageFeature = $LanguageFeature | Sort-Object -Property FullName | Out-GridView -Title "Install.wim Language Features On Demand: Select Packages to apply and press OK (Esc or Cancel to Skip)" -PassThru
        if($null -eq $LanguageFeature) {Write-Warning "Install.wim Language Features On Demand: Skipping"}
    }
    foreach ($Item in $LanguageFeature) {Write-Host "$($Item.FullName)" -ForegroundColor White}
    Return $LanguageFeature
}
function Get-TaskContentLanguageInterfacePack {
    [CmdletBinding()]
    PARAM ()
    $LanguageLipIsoExtractDir = @()
    $LanguageLipIsoExtractDir = $ContentIsoExtract | Where-Object {$_.Name -like "*Language-Interface-Pack*"}
    $LanguageLipIsoExtractDir = $LanguageLipIsoExtractDir | Where-Object {$_.Name -like "*$($OSMedia.Arch)*"}

    $LanguageLipUpdatesDir = @()
    if (Test-Path "$OSDBuilderContent\Updates\LanguageInterfacePack") {
        $LanguageLipUpdatesDir = Get-ChildItem -Path "$OSDBuilderContent\Updates\LanguageInterfacePack" *.cab -Recurse | Select-Object -Property Name, FullName
        foreach ($Package in $LanguageLipUpdatesDir) {$Package.FullName = $($Package.FullName).replace("$OSDBuilderContent\",'')}
        $LanguageLipUpdatesDir = $LanguageLipUpdatesDir | Where-Object {$_.FullName -like "*$($OSMedia.Arch)*"}
        if ($($OSMedia.ReleaseId)) {$LanguageLipUpdatesDir = $LanguageLipUpdatesDir | Where-Object {$_.FullName -like "*$($OSMedia.ReleaseId)*"}}
    }
    
    [array]$LanguageInterfacePack = [array]$LanguageLipIsoExtractDir + [array]$LanguageLipUpdatesDir
    if ($null -eq $LanguageInterfacePack) {Write-Warning "Install.wim Language Interface Packs: Not Found"}
    else {
        if ($ExistingTask.LanguageInterfacePack) {
            foreach ($Item in $ExistingTask.LanguageInterfacePack) {
                $LanguageInterfacePack = $LanguageInterfacePack | Where-Object {$_.FullName -ne $Item}
            }
        }
        $LanguageInterfacePack = $LanguageInterfacePack | Sort-Object -Property FullName | Out-GridView -Title "Install.wim Language Interface Packs: Select Packages to apply and press OK (Esc or Cancel to Skip)" -PassThru
        if($null -eq $LanguageInterfacePack) {Write-Warning "Install.wim Language Interface Packs: Skipping"}
    }
    foreach ($Item in $LanguageInterfacePack) {Write-Host "$($Item.FullName)" -ForegroundColor White}
    Return $LanguageInterfacePack
}

function Get-TaskContentLocalExperiencePacks {
    [CmdletBinding()]
    PARAM ()
    $LocalExperiencePacks = $ContentIsoExtract | Where-Object {$_.FullName -like "*\LocalExperiencePack\*" -and $_.Name -like "*.appx"}
    if ($OSMedia.InstallationType -eq 'Client') {$LocalExperiencePacks = $LocalExperiencePacks | Where-Object {$_.FullName -notlike "*Server*"}}
    if ($OSMedia.InstallationType -eq 'Server') {$LocalExperiencePacks = $LocalExperiencePacks | Where-Object {$_.FullName -like "*Server*"}}
    if ($OSMedia.InstallationType -eq 'Server') {$LocalExperiencePacks = $LocalExperiencePacks | Where-Object {$_.FullName -notlike "*Windows 10*"}}

    foreach ($Pack in $LocalExperiencePacks) {$Pack.FullName = $($Pack.FullName).replace("$OSDBuilderContent\",'')}
    if ($null -eq $LocalExperiencePacks) {Write-Warning "Install.wim Local Experience Packs: Not Found"}
    else {
        if ($ExistingTask.LocalExperiencePacks) {
            foreach ($Item in $ExistingTask.LocalExperiencePacks) {
                $LocalExperiencePacks = $LocalExperiencePacks | Where-Object {$_.FullName -ne $Item}
            }
        }
        $LocalExperiencePacks = $LocalExperiencePacks | Sort-Object -Property FullName | Out-GridView -Title "Install.wim Local Experience Packs: Select Capabilities to apply and press OK (Esc or Cancel to Skip)" -PassThru
        if ($null -eq $LocalExperiencePacks) {Write-Warning "Install.wim Local Experience Packs: Skipping"}
    }
    foreach ($Item in $LocalExperiencePacks) {Write-Host "$($Item.FullName)" -ForegroundColor White}
    Return $LocalExperiencePacks
}
