
function Get-SelectedLanguagePacks {
    [CmdletBinding()]
    PARAM ()
    if ($SelectLanguagePackages.IsPresent) {
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

        [array]$SelectedLanguagePacks = [array]$LanguageLpIsoExtractDir + [array]$LanguageLpUpdatesDir + [array]$LanguageLpLegacyDir

        if ($OSMedia.InstallationType -eq 'Client') {$SelectedLanguagePacks = $SelectedLanguagePacks | Where-Object {$_.FullName -notlike "*Windows Server*"}}
        if ($OSMedia.InstallationType -like "*Server*") {$SelectedLanguagePacks = $SelectedLanguagePacks | Where-Object {$_.FullName -like "*Windows Server*"}}
        if ($($OSMedia.ReleaseId)) {$SelectedLanguagePacks = $SelectedLanguagePacks | Where-Object {$_.FullName -like "*$($OSMedia.ReleaseId)*"}}

        foreach ($Package in $SelectedLanguagePacks) {$Package.FullName = $($Package.FullName).replace("$OSDBuilderContent\",'')}

        if ($null -eq $SelectedLanguagePacks) {Write-Warning "Install.wim Language Packs: Not Found"}
        else {
            $SelectedLanguagePacks = $SelectedLanguagePacks | Sort-Object -Property FullName | Out-GridView -Title "Install.wim Language Packs: Select Packages to apply and press OK (Esc or Cancel to Skip)" -PassThru
            if ($null -eq $SelectedLanguagePacks) {Write-Warning "Install.wim Language Packs: Skipping"}
        }
        Return $SelectedLanguagePacks
    }
}
function Get-SelectedLanguageInterfacePacks {
    [CmdletBinding()]
    PARAM ()
    if ($SelectLanguagePackages.IsPresent) {
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
        
        [array]$SelectedLanguageInterfacePacks = [array]$LanguageLipIsoExtractDir + [array]$LanguageLipUpdatesDir
        if ($null -eq $SelectedLanguageInterfacePacks) {Write-Warning "Install.wim Language Interface Packs: Not Found"}
        else {
            $SelectedLanguageInterfacePacks = $SelectedLanguageInterfacePacks | Sort-Object -Property FullName | Out-GridView -Title "Install.wim Language Interface Packs: Select Packages to apply and press OK (Esc or Cancel to Skip)" -PassThru
            if($null -eq $SelectedLanguageInterfacePacks) {Write-Warning "Install.wim Language Interface Packs: Skipping"}
        }
        Return $SelectedLanguageInterfacePacks
    }
}
function Get-SelectedLanguageFeaturesOnDemand {
    [CmdletBinding()]
    PARAM ()
    if ($SelectLanguagePackages.IsPresent) {
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

        [array]$SelectedLanguageFeaturesOnDemand = [array]$LanguageFodIsoExtractDir + [array]$LanguageFodUpdatesDir
        if ($null -eq $SelectedLanguageFeaturesOnDemand) {Write-Warning "Install.wim Language Features On Demand: Not Found"}
        else {
            $SelectedLanguageFeaturesOnDemand = $SelectedLanguageFeaturesOnDemand | Sort-Object -Property FullName | Out-GridView -Title "Install.wim Language Features On Demand: Select Packages to apply and press OK (Esc or Cancel to Skip)" -PassThru
            if($null -eq $SelectedLanguageFeaturesOnDemand) {Write-Warning "Install.wim Language Features On Demand: Skipping"}
        }
        Return $SelectedLanguageFeaturesOnDemand
    }
}

function Get-SelectedLocalExperiencePacks {
    [CmdletBinding()]
    PARAM ()
    if ($SelectLanguagePackages.IsPresent) {
        $SelectedLocalExperiencePacks = $ContentIsoExtract | Where-Object {$_.FullName -like "*\LocalExperiencePack\*" -and $_.Name -like "*.appx"}
        if ($OSMedia.InstallationType -eq 'Client') {$SelectedLocalExperiencePacks = $SelectedLocalExperiencePacks | Where-Object {$_.FullName -notlike "*Server*"}}
        if ($OSMedia.InstallationType -eq 'Server') {$SelectedLocalExperiencePacks = $SelectedLocalExperiencePacks | Where-Object {$_.FullName -like "*Server*"}}
        if ($OSMedia.InstallationType -eq 'Server') {$SelectedLocalExperiencePacks = $SelectedLocalExperiencePacks | Where-Object {$_.FullName -notlike "*Windows 10*"}}

        foreach ($Pack in $SelectedLocalExperiencePacks) {$Pack.FullName = $($Pack.FullName).replace("$OSDBuilderContent\",'')}
        if ($null -eq $SelectedLocalExperiencePacks) {Write-Warning "Install.wim Local Experience Packs: Not Found"}
        else {
            $SelectedLocalExperiencePacks = $SelectedLocalExperiencePacks | Sort-Object -Property FullName | Out-GridView -Title "Install.wim Local Experience Packs: Select Capabilities to apply and press OK (Esc or Cancel to Skip)" -PassThru
            if ($null -eq $SelectedLocalExperiencePacks) {Write-Warning "Install.wim Local Experience Packs: Skipping"}
        }
        Return $SelectedLocalExperiencePacks
    }
}
