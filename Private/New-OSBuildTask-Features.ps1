function Get-TaskContentIsoExtract {
    [CmdletBinding()]
    PARAM ()
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
function Get-TaskContentAddFeatureOnDemand {
    #===================================================================================================
    #   Install.Wim Features On Demand
    #===================================================================================================
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
    
    $AddFeatureOnDemand = [array]$FeaturesOnDemandIsoExtractDir + [array]$FeaturesOnDemandUpdatesDir

    if ($OSMedia.InstallationType -eq 'Client') {$AddFeatureOnDemand = $AddFeatureOnDemand | Where-Object {$_.FullName -notlike "*Windows Server*"}}
    if ($OSMedia.InstallationType -like "*Server*") {$AddFeatureOnDemand = $AddFeatureOnDemand | Where-Object {$_.FullName -like "*Windows Server*"}}
    if ($($OSMedia.ReleaseId)) {$AddFeatureOnDemand = $AddFeatureOnDemand | Where-Object {$_.FullName -like "*$($OSMedia.ReleaseId)*"}}

    foreach ($Pack in $AddFeatureOnDemand) {$Pack.FullName = $($Pack.FullName).replace("$OSDBuilderContent\",'')}
    if ($null -eq $AddFeatureOnDemand) {Write-Warning "Install.wim Features On Demand: Not Found"}
    else {
        if ($ExistingTask.AddFeatureOnDemand) {
            foreach ($Item in $ExistingTask.AddFeatureOnDemand) {
                $AddFeatureOnDemand = $AddFeatureOnDemand | Where-Object {$_.FullName -ne $Item}
            }
        }
        $AddFeatureOnDemand = $AddFeatureOnDemand | Sort-Object -Property FullName | Out-GridView -Title "Install.wim Features On Demand: Select Packages to apply and press OK (Esc or Cancel to Skip)" -PassThru
    }
    foreach ($Item in $AddFeatureOnDemand) {Write-Host "$($Item.FullName)" -ForegroundColor White}
    Return $AddFeatureOnDemand
}
