
function Get-SelectedTaskScripts {
    [CmdletBinding()]
    PARAM ()
    $SelectedTaskScripts = Get-ChildItem -Path "$OSDBuilderContent\Scripts" *.ps1 | Select-Object -Property Name, FullName, Length, CreationTime | Sort-Object -Property FullName
    foreach ($TaskScript in $SelectedTaskScripts) {$TaskScript.FullName = $($TaskScript.FullName).replace("$OSDBuilderContent\",'')}
    if ($null -eq $SelectedTaskScripts) {Write-Warning "Install.wim PowerShell Scripts: Not Found"}
    else {
        $SelectedTaskScripts = $SelectedTaskScripts | Out-GridView -Title "Install.wim PowerShell Scripts: Select PowerShell Scripts to execute and press OK (Esc or Cancel to Skip)" -PassThru
        if ($null -eq $SelectedTaskScripts) {Write-Warning "Install.wim PowerShell Scripts: Skipping"}
    }
    Return $SelectedTaskScripts
}



function Get-SelectedWindowsDrivers {
    [CmdletBinding()]
    PARAM ()
    $SelectedWindowsDrivers =@()
    $SelectedWindowsDrivers = Get-ChildItem -Path "$OSDBuilderContent\Drivers" -Directory | Select-Object -Property Name, FullName
    foreach ($Pack in $SelectedWindowsDrivers) {$Pack.FullName = $($Pack.FullName).replace("$OSDBuilderContent\",'')}
    if ($null -eq $SelectedWindowsDrivers) {Write-Warning "Install.wim Drivers: Add Content to $OSDBuilderContent\Drivers"}
    else {
        $SelectedWindowsDrivers = $SelectedWindowsDrivers | Out-GridView -Title "Install.wim Windows Drivers: Select Driver Paths to apply and press OK (Esc or Cancel to Skip)" -PassThru
        if ($null -eq $SelectedWindowsDrivers) {Write-Warning "Install.wim Windows Drivers: Skipping"}
    }
    Return $SelectedWindowsDrivers
}

function Get-SelectedExtraFiles {
    [CmdletBinding()]
    PARAM ()
    $SelectedExtraFiles = Get-ChildItem -Path "$OSDBuilderContent\ExtraFiles" -Directory | Select-Object -Property Name, FullName
    $SelectedExtraFiles = $SelectedExtraFiles | Where-Object {(Get-ChildItem $_.FullName | Measure-Object).Count -gt 0}
    foreach ($Pack in $SelectedExtraFiles) {$Pack.FullName = $($Pack.FullName).replace("$OSDBuilderContent\",'')}
    if ($null -eq $SelectedExtraFiles) {Write-Warning "Install.wim Extra Files: Add Content to $OSDBuilderContent\ExtraFiles"}
    else {
        $SelectedExtraFiles = $SelectedExtraFiles | Out-GridView -Title "Install.wim Extra Files: Select directories to inject and press OK (Esc or Cancel to Skip)" -PassThru
        if ($null -eq $SelectedExtraFiles) {Write-Warning "Install.wim Extra Files: Skipping"}
    }
    Return $SelectedExtraFiles
}

function Get-SelectedWindowsPackages {
    [CmdletBinding()]
    PARAM ()
    $SelectedWindowsPackages =@()
    $SelectedWindowsPackages = Get-ChildItem -Path "$OSDBuilderContent\Packages\*" -Include *.cab, *.msu -Recurse | Select-Object -Property Name, FullName
    $SelectedWindowsPackages = $SelectedWindowsPackages | Where-Object {$_.FullName -like "*$($OSMedia.Arch)*"}
    foreach ($Pack in $SelectedWindowsPackages) {$Pack.FullName = $($Pack.FullName).replace("$OSDBuilderContent\",'')}
    if ($null -eq $SelectedWindowsPackages) {Write-Warning "Install.wim Packages: Add Content to $OSDBuilderContent\Packages"}
    else {
        $SelectedWindowsPackages = $SelectedWindowsPackages | Out-GridView -Title "Install.wim Windows Packages: Select Packages to apply and press OK (Esc or Cancel to Skip)" -PassThru
        if ($null -eq $SelectedWindowsPackages) {Write-Warning "Install.wim Windows Packages: Skipping"}
    }
    Return $SelectedWindowsPackages
}
function Get-SelectedStartLayoutXML {
    [CmdletBinding()]
    PARAM ()
    $SelectedStartLayoutXML = Get-ChildItem -Path "$OSDBuilderContent\StartLayout" *.xml | Select-Object -Property Name, FullName, Length, CreationTime | Sort-Object -Property FullName
    foreach ($StartLayout in $SelectedStartLayoutXML) {$StartLayout.FullName = $($StartLayout.FullName).replace("$OSDBuilderContent\",'')}
    if ($null -eq $SelectedStartLayoutXML) {Write-Warning "Install.wim Start Layout XML: Add Content to $OSDBuilderContent\StartLayout"}
    else {
        $SelectedStartLayoutXML = $SelectedStartLayoutXML | Out-GridView -Title "Install.wim Start Layout: Select a Start Layout XML to apply and press OK (Esc or Cancel to Skip)" -OutputMode Single
        if ($null -eq $SelectedStartLayoutXML) {Write-Warning "Install.wim Start Layout: Skipping"}
    }
    Return $SelectedStartLayoutXML
}

function Get-SelectedUnattendXML {
    [CmdletBinding()]
    PARAM ()
    $SelectedUnattendXML = Get-ChildItem -Path "$OSDBuilderContent\Unattend" *.xml | Select-Object -Property Name, FullName, Length, CreationTime | Sort-Object -Property FullName
    foreach ($Pack in $SelectedUnattendXML) {$Pack.FullName = $($Pack.FullName).replace("$OSDBuilderContent\",'')}
    if ($null -eq $SelectedUnattendXML) {Write-Warning "Install.wim Unattend XML: Add Content to $OSDBuilderContent\Unattend"}
    else {
        $SelectedUnattendXML = $SelectedUnattendXML | Out-GridView -Title "Install.wim Unattend.xml: Select a Windows Unattend XML File to apply and press OK (Esc or Cancel to Skip)" -OutputMode Single
        if ($null -eq $SelectedUnattendXML) {Write-Warning "Install.wim Unattend.xml: Skipping"}
    }
    Return $SelectedUnattendXML
}

function Get-SelectedWinPEDaRT {
    [CmdletBinding()]
    PARAM ()
    $SelectedWinPEDaRT = Get-ChildItem -Path "$OSDBuilderContent\WinPE\DaRT" *.cab -Recurse | Select-Object -Property Name, FullName
    $SelectedWinPEDaRT = $SelectedWinPEDaRT | Where-Object {$_.FullName -like "*$($OSMedia.Arch)*"}
    foreach ($Pack in $SelectedWinPEDaRT) {$Pack.FullName = $($Pack.FullName).replace("$OSDBuilderContent\",'')}
    if ($null -eq $SelectedWinPEDaRT) {Write-Warning "WinPE DaRT: Add Content to $OSDBuilderContent\WinPE\DaRT"}
    else {
        $SelectedWinPEDaRT = $SelectedWinPEDaRT | Out-GridView -Title "WinPE DaRT: Select a WinPE DaRT Package to apply and press OK (Esc or Cancel to Skip)" -OutputMode Single
        if ($null -eq $SelectedWinPEDaRT) {Write-Warning "WinPE DaRT: Skipping"}
    }
    Return $SelectedWinPEDaRT
}
function Get-SelectedFeaturesOnDemand {
    [CmdletBinding()]
    PARAM ()
    $FeaturesOnDemandIsoExtractDir =@()
    $FeaturesOnDemandIsoExtractDir = $ContentIsoExtract

    if ($OSMedia.InstallationType -eq 'Client') {
        if ($($OSMedia.Arch) -eq 'x64') {$FeaturesOnDemandIsoExtractDir = $FeaturesOnDemandIsoExtractDir | Where-Object {$_.FullName -like "*x64*"}}
        if ($($OSMedia.Arch) -eq 'x86') {$FeaturesOnDemandIsoExtractDir = $FeaturesOnDemandIsoExtractDir | Where-Object {$_.FullName -like "*x86*"}}
    }

    $FeaturesOnDemandIsoExtractDir = $FeaturesOnDemandIsoExtractDir | Where-Object {$_.Name -notlike "*lp.cab"}
    $FeaturesOnDemandIsoExtractDir = $FeaturesOnDemandIsoExtractDir | Where-Object {$_.Name -notlike "*Language-Pack*"}
    $FeaturesOnDemandIsoExtractDir = $FeaturesOnDemandIsoExtractDir | Where-Object {$_.Name -notlike "*Language-Interface-Pack*"}
    $FeaturesOnDemandIsoExtractDir = $FeaturesOnDemandIsoExtractDir | Where-Object {$_.Name -notlike "*LanguageFeatures*"}
    $FeaturesOnDemandIsoExtractDir = $FeaturesOnDemandIsoExtractDir | Where-Object {$_.Name -notlike "*LanguageExperiencePack*"}
    $FeaturesOnDemandIsoExtractDir = $FeaturesOnDemandIsoExtractDir | Where-Object {$_.FullName -notlike "*metadata*"}

    if ($OSMedia.ReleaseId -gt 1803) {
        $FeaturesOnDemandIsoExtractDir = $FeaturesOnDemandIsoExtractDir | Where-Object {$_.Name -notlike "*ActiveDirectory*"}
        $FeaturesOnDemandIsoExtractDir = $FeaturesOnDemandIsoExtractDir | Where-Object {$_.Name -notlike "*BitLocker-Recovery*"}
        $FeaturesOnDemandIsoExtractDir = $FeaturesOnDemandIsoExtractDir | Where-Object {$_.Name -notlike "*CertificateServices*"}
        $FeaturesOnDemandIsoExtractDir = $FeaturesOnDemandIsoExtractDir | Where-Object {$_.Name -notlike "*DHCP-Tools*"}
        $FeaturesOnDemandIsoExtractDir = $FeaturesOnDemandIsoExtractDir | Where-Object {$_.Name -notlike "*DNS-Tools*"}
        $FeaturesOnDemandIsoExtractDir = $FeaturesOnDemandIsoExtractDir | Where-Object {$_.Name -notlike "*FailoverCluster*"}
        $FeaturesOnDemandIsoExtractDir = $FeaturesOnDemandIsoExtractDir | Where-Object {$_.Name -notlike "*FileServices-Tools*"}
        $FeaturesOnDemandIsoExtractDir = $FeaturesOnDemandIsoExtractDir | Where-Object {$_.Name -notlike "*GroupPolicy-Management*"}
        $FeaturesOnDemandIsoExtractDir = $FeaturesOnDemandIsoExtractDir | Where-Object {$_.Name -notlike "*IPAM-Client*"}
        $FeaturesOnDemandIsoExtractDir = $FeaturesOnDemandIsoExtractDir | Where-Object {$_.Name -notlike "*LLDP*"}
        $FeaturesOnDemandIsoExtractDir = $FeaturesOnDemandIsoExtractDir | Where-Object {$_.Name -notlike "*NetworkController*"}
        $FeaturesOnDemandIsoExtractDir = $FeaturesOnDemandIsoExtractDir | Where-Object {$_.Name -notlike "*NetworkLoadBalancing*"}
        $FeaturesOnDemandIsoExtractDir = $FeaturesOnDemandIsoExtractDir | Where-Object {$_.Name -notlike "*RasCMAK*"}
        $FeaturesOnDemandIsoExtractDir = $FeaturesOnDemandIsoExtractDir | Where-Object {$_.Name -notlike "*RasRip*"}
        $FeaturesOnDemandIsoExtractDir = $FeaturesOnDemandIsoExtractDir | Where-Object {$_.Name -notlike "*RemoteAccess-Management*"}
        $FeaturesOnDemandIsoExtractDir = $FeaturesOnDemandIsoExtractDir | Where-Object {$_.Name -notlike "*RemoteDesktop-Services*"}
        #$FeaturesOnDemandIsoExtractDir = $FeaturesOnDemandIsoExtractDir | Where-Object {$_.Name -notlike "*Server-AppCompat*"}
        $FeaturesOnDemandIsoExtractDir = $FeaturesOnDemandIsoExtractDir | Where-Object {$_.Name -notlike "*ServerManager-Tools*"}
        $FeaturesOnDemandIsoExtractDir = $FeaturesOnDemandIsoExtractDir | Where-Object {$_.Name -notlike "*Shielded-VM*"}
        $FeaturesOnDemandIsoExtractDir = $FeaturesOnDemandIsoExtractDir | Where-Object {$_.Name -notlike "*SNMP-Client*"}
        $FeaturesOnDemandIsoExtractDir = $FeaturesOnDemandIsoExtractDir | Where-Object {$_.Name -notlike "*StorageManagement*"}
        $FeaturesOnDemandIsoExtractDir = $FeaturesOnDemandIsoExtractDir | Where-Object {$_.Name -notlike "*StorageMigrationService*"}
        $FeaturesOnDemandIsoExtractDir = $FeaturesOnDemandIsoExtractDir | Where-Object {$_.Name -notlike "*StorageReplica*"}
        $FeaturesOnDemandIsoExtractDir = $FeaturesOnDemandIsoExtractDir | Where-Object {$_.Name -notlike "*SystemInsights*"}
        $FeaturesOnDemandIsoExtractDir = $FeaturesOnDemandIsoExtractDir | Where-Object {$_.Name -notlike "*VolumeActivation*"}
        $FeaturesOnDemandIsoExtractDir = $FeaturesOnDemandIsoExtractDir | Where-Object {$_.Name -notlike "*WMI-SNMP-Provider*"}
        $FeaturesOnDemandIsoExtractDir = $FeaturesOnDemandIsoExtractDir | Where-Object {$_.Name -notlike "*WSUS-Tools*"}
    }

    $FeaturesOnDemandUpdatesDir = @()
    if (Test-Path "$OSDBuilderContent\Updates\FeatureOnDemand") {
        $FeaturesOnDemandUpdatesDir = Get-ChildItem -Path "$OSDBuilderContent\Updates\FeatureOnDemand" *.cab -Recurse | Select-Object -Property Name, FullName
    }
    
    $SelectedFeaturesOnDemand = @()
    $SelectedFeaturesOnDemand = [array]$FeaturesOnDemandIsoExtractDir + [array]$FeaturesOnDemandUpdatesDir

    if ($OSMedia.InstallationType -eq 'Client') {$SelectedFeaturesOnDemand = $SelectedFeaturesOnDemand | Where-Object {$_.FullName -notlike "*Windows Server*"}}
    if ($OSMedia.InstallationType -like "*Server*") {$SelectedFeaturesOnDemand = $SelectedFeaturesOnDemand | Where-Object {$_.FullName -like "*Windows Server*"}}
    if ($($OSMedia.ReleaseId)) {$SelectedFeaturesOnDemand = $SelectedFeaturesOnDemand | Where-Object {$_.FullName -like "*$($OSMedia.ReleaseId)*"}}

    foreach ($Pack in $SelectedFeaturesOnDemand) {$Pack.FullName = $($Pack.FullName).replace("$OSDBuilderContent\",'')}
    if ($null -eq $SelectedFeaturesOnDemand) {Write-Warning "Install.wim Features On Demand: Not Found"}
    else {
        $SelectedFeaturesOnDemand = $SelectedFeaturesOnDemand | Sort-Object -Property FullName | Out-GridView -Title "Install.wim Features On Demand: Select Packages to apply and press OK (Esc or Cancel to Skip)" -PassThru
        if ($null -eq $SelectedFeaturesOnDemand) {Write-Warning "Install.wim Features On Demand: Skipping"}
    }
    Return $SelectedFeaturesOnDemand
}
function Get-ContentIsoExtract {
    [CmdletBinding()]
    PARAM ()
    Write-Warning "Generating IsoExtract Content ... This may take a while"
    $ContentIsoExtract = Get-ChildItem -Path "$OSDBuilderContent\IsoExtract\*" -Include *.cab, *.appx -Recurse | Select-Object -Property Name, FullName
    if ($($OSMedia.ReleaseId)) {$ContentIsoExtract = $ContentIsoExtract | Where-Object {$_.FullName -like "*$($OSMedia.ReleaseId)*"}}
    foreach ($IsoExtractPackage in $ContentIsoExtract) {$IsoExtractPackage.FullName = $($IsoExtractPackage.FullName).replace("$OSDBuilderContent\",'')}

    $ContentIsoExtract = $ContentIsoExtract | Where-Object {$_.FullName -notlike "*\arm64\*"}

    if ($($OSMedia.Arch) -eq 'x64') {$ContentIsoExtract = $ContentIsoExtract | Where-Object {$_.Name -notlike "*x86*"}}
    if ($($OSMedia.Arch) -eq 'x64') {$ContentIsoExtract = $ContentIsoExtract | Where-Object {$_.FullName -notlike "*\x86\*"}}

    if ($($OSMedia.Arch) -eq 'x86') {$ContentIsoExtract = $ContentIsoExtract | Where-Object {$_.Name -notlike "*x64*"}}
    if ($($OSMedia.Arch) -eq 'x86') {$ContentIsoExtract = $ContentIsoExtract | Where-Object {$_.Name -notlike "*amd64*"}}
    if ($($OSMedia.Arch) -eq 'x86') {$ContentIsoExtract = $ContentIsoExtract | Where-Object {$_.FullName -notlike "*\x64\*"}}
    if ($($OSMedia.Arch) -eq 'x86') {$ContentIsoExtract = $ContentIsoExtract | Where-Object {$_.FullName -notlike "*\amd64\*"}}

    $ContentIsoExtract = $ContentIsoExtract | Where-Object {$_.FullName -notlike "*Windows Preinstallation Environment*"}

    if ($OSMedia.InstallationType -eq 'Client') {$ContentIsoExtract = $ContentIsoExtract | Where-Object {$_.FullName -notlike "*Windows Server*"}}
    if ($OSMedia.InstallationType -like "*Server*") {$ContentIsoExtract = $ContentIsoExtract | Where-Object {$_.FullName -like "*Windows Server*"}}

    Return $ContentIsoExtract
}