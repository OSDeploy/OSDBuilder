#===================================================================================================
#   Install.wim Remove-AppxProvisionedPackage
#===================================================================================================
function Get-TaskRemoveAppxProvisionedPackage {
    [CmdletBinding()]
    PARAM ()
    if ($RemoveAppx.IsPresent) {
        if ($($OSMedia.InstallationType) -eq 'Client') {
            $TaskRemoveAppxProvisionedPackage = @()
            if (Test-Path "$($OSMedia.FullName)\info\xml\Get-AppxProvisionedPackage.xml") {
                $TaskRemoveAppxProvisionedPackage = Import-CliXml "$($OSMedia.FullName)\info\xml\Get-AppxProvisionedPackage.xml"
                $TaskRemoveAppxProvisionedPackage = $TaskRemoveAppxProvisionedPackage | Select-Object -Property DisplayName, PackageName
                $TaskRemoveAppxProvisionedPackage = $TaskRemoveAppxProvisionedPackage | Out-GridView -Title "Remove-AppxProvisionedPackage: Select Packages to REMOVE and press OK (Esc or Cancel to Skip)" -PassThru
            }
            if ($null -eq $TaskRemoveAppxProvisionedPackage) {Write-Warning "Remove-AppxProvisionedPackage: Skipping"}
            Return $TaskRemoveAppxProvisionedPackage
        } else {Write-Warning "Remove-AppxProvisionedPackage: Unsupported"}
    } else {
        Write-Host "RemoveAppx: Select Appx Provisioned Packages to remove using Remove-AppxProvisionedPackage" -ForegroundColor Cyan
    }
}
#===================================================================================================
#   Install.wim Remove-WindowsPackage
#===================================================================================================
function Get-TaskRemoveWindowsPackage {
    [CmdletBinding()]
    PARAM ()
    if ($RemovePackage.IsPresent) {
        $TaskRemoveWindowsPackage = @()
        if (Test-Path "$($OSMedia.FullName)\info\xml\Get-WindowsPackage.xml") {
            $TaskRemoveWindowsPackage = Import-CliXml "$($OSMedia.FullName)\info\xml\Get-WindowsPackage.xml"
            $TaskRemoveWindowsPackage = $TaskRemoveWindowsPackage | Select-Object -Property PackageName
            $TaskRemoveWindowsPackage = $TaskRemoveWindowsPackage | Out-GridView -Title "Remove-WindowsPackage: Select Packages to REMOVE and press OK (Esc or Cancel to Skip)" -PassThru
        }
        if ($null -eq $TaskRemoveWindowsPackage) {Write-Warning "Install.wim Remove-WindowsPackage: Skipping"}
        Return $TaskRemoveWindowsPackage
    } else {
        Write-Host "RemovePackage: Select Windows Packages to remove using Remove-WindowsPackage" -ForegroundColor Cyan
    }
}
#===================================================================================================
#   Install.wim Remove-WindowsCapability
#===================================================================================================
function Get-TaskRemoveWindowsCapability {
    [CmdletBinding()]
    PARAM ()
    if ($RemoveCapability.IsPresent) {
        $TaskRemoveWindowsCapability = @()
        if (Test-Path "$($OSMedia.FullName)\info\xml\Get-WindowsCapability.xml") {
            $TaskRemoveWindowsCapability = Import-CliXml "$($OSMedia.FullName)\info\xml\Get-WindowsCapability.xml"
            $TaskRemoveWindowsCapability = $TaskRemoveWindowsCapability | Where-Object {$_.State -eq 4}
            $TaskRemoveWindowsCapability = $TaskRemoveWindowsCapability | Select-Object -Property Name, State
            $TaskRemoveWindowsCapability = $TaskRemoveWindowsCapability | Out-GridView -Title "Remove-WindowsCapability: Select Windows InBox Capability to REMOVE and press OK (Esc or Cancel to Skip)" -PassThru
        }
        if ($null -eq $TaskRemoveWindowsCapability) {Write-Warning "Remove-WindowsCapability: Skipping"}
        Return $TaskRemoveWindowsCapability
    } else {
        Write-Host "RemoveCapability: Select Windows Capabilities to remove using Remove-WindowsCapability" -ForegroundColor Cyan
    }
}
#===================================================================================================
#   Install.Wim Disable-WindowsOptionalFeature
#===================================================================================================
function Get-TaskDisableWindowsOptionalFeature {
    [CmdletBinding()]
    PARAM ()
    if ($DisableFeature.IsPresent) {
        $TaskDisableWindowsOptionalFeature = @()
        if (Test-Path "$($OSMedia.FullName)\info\xml\Get-WindowsOptionalFeature.xml") {
            $TaskDisableWindowsOptionalFeature = Import-CliXml "$($OSMedia.FullName)\info\xml\Get-WindowsOptionalFeature.xml"
        }
        $TaskDisableWindowsOptionalFeature = $TaskDisableWindowsOptionalFeature | Select-Object -Property FeatureName, State | Sort-Object -Property FeatureName | Where-Object {$_.State -eq 2 -or $_.State -eq 3}
        $TaskDisableWindowsOptionalFeature = $TaskDisableWindowsOptionalFeature | Select-Object -Property FeatureName
        $TaskDisableWindowsOptionalFeature = $TaskDisableWindowsOptionalFeature | Out-GridView -PassThru -Title "Disable-WindowsOptionalFeature: Select Windows Optional Features to Disable and press OK (Esc or Cancel to Skip)"
        if ($null -eq $TaskDisableWindowsOptionalFeature) {Write-Warning "Disable-WindowsOptionalFeature: Skipping"}
        Return $TaskDisableWindowsOptionalFeature
    } else {
        Write-Host "DisableFeature: Select Windows Optional Features to disable using Disable-WindowsOptionalFeature" -ForegroundColor Cyan
    }
}
#===================================================================================================
#   Install.Wim Enable-WindowsOptionalFeature
#===================================================================================================
function Get-TaskEnableWindowsOptionalFeature {
    [CmdletBinding()]
    PARAM ()
    if ($EnableFeature.IsPresent) {
        $TaskEnableWindowsOptionalFeature = @()
        if (Test-Path "$($OSMedia.FullName)\info\xml\Get-WindowsOptionalFeature.xml") {
            $TaskEnableWindowsOptionalFeature = Import-CliXml "$($OSMedia.FullName)\info\xml\Get-WindowsOptionalFeature.xml"
        }
        $TaskEnableWindowsOptionalFeature = $TaskEnableWindowsOptionalFeature | Select-Object -Property FeatureName, State | Sort-Object -Property FeatureName | Where-Object {$_.State -eq 0}
        $TaskEnableWindowsOptionalFeature = $TaskEnableWindowsOptionalFeature | Select-Object -Property FeatureName
        $TaskEnableWindowsOptionalFeature = $TaskEnableWindowsOptionalFeature | Out-GridView -PassThru -Title "Enable-WindowsOptionalFeature: Select Windows Optional Features to ENABLE and press OK (Esc or Cancel to Skip)"
        if ($null -eq $TaskEnableWindowsOptionalFeature) {Write-Warning "Enable-WindowsOptionalFeature: Skipping"}
        Return $TaskEnableWindowsOptionalFeature
    } else {
        Write-Host "EnableFeature: Select Windows Optional Features to enable using Enable-WindowsOptionalFeature" -ForegroundColor Cyan
    }
}
function Get-TaskAddWindowsDriver {
    [CmdletBinding()]
    PARAM ()
    $TaskAddWindowsDriver =@()
    $TaskAddWindowsDriver = Get-ChildItem -Path "$OSDBuilderContent\Drivers" -Directory | Select-Object -Property Name, FullName
    foreach ($Pack in $TaskAddWindowsDriver) {$Pack.FullName = $($Pack.FullName).replace("$OSDBuilderContent\",'')}
    if ($null -eq $TaskAddWindowsDriver) {Write-Warning "Add-WindowsDriver: To select Windows Drivers, add Content to $OSDBuilderContent\Drivers"}
    else {
        $TaskAddWindowsDriver = $TaskAddWindowsDriver | Out-GridView -Title "Add-WindowsDriver: Select Driver Paths to apply and press OK (Esc or Cancel to Skip)" -PassThru
        if ($null -eq $TaskAddWindowsDriver) {Write-Warning "Add-WindowsDriver: Skipping"}
    }
    Return $TaskAddWindowsDriver
}
function Get-TaskExtraFiles {
    [CmdletBinding()]
    PARAM ()
    $TaskExtraFiles = Get-ChildItem -Path "$OSDBuilderContent\ExtraFiles" -Directory | Select-Object -Property Name, FullName
    $TaskExtraFiles = $TaskExtraFiles | Where-Object {(Get-ChildItem $_.FullName | Measure-Object).Count -gt 0}
    foreach ($Pack in $TaskExtraFiles) {$Pack.FullName = $($Pack.FullName).replace("$OSDBuilderContent\",'')}
    if ($null -eq $TaskExtraFiles) {Write-Warning "Add Extra Files: To select Extra Files, add Content to $OSDBuilderContent\ExtraFiles"}
    else {
        $TaskExtraFiles = $TaskExtraFiles | Out-GridView -Title "AddExtra Files: Select directories to inject and press OK (Esc or Cancel to Skip)" -PassThru
        if ($null -eq $TaskExtraFiles) {Write-Warning "Add Extra Files: Skipping"}
    }
    Return $TaskExtraFiles
}
function Get-SelectedWindowsPackages {
    [CmdletBinding()]
    PARAM ()
    $SelectedWindowsPackages =@()
    $SelectedWindowsPackages = Get-ChildItem -Path "$OSDBuilderContent\Packages\*" -Include *.cab, *.msu -Recurse | Select-Object -Property Name, FullName
    $SelectedWindowsPackages = $SelectedWindowsPackages | Where-Object {$_.FullName -like "*$($OSMedia.Arch)*"}
    foreach ($Pack in $SelectedWindowsPackages) {$Pack.FullName = $($Pack.FullName).replace("$OSDBuilderContent\",'')}
    if ($null -eq $SelectedWindowsPackages) {Write-Warning "Add Windows Package: To select Windows Packages, add Content to $OSDBuilderContent\Packages"}
    else {
        $SelectedWindowsPackages = $SelectedWindowsPackages | Out-GridView -Title "Add Windows Package: Select Packages to apply and press OK (Esc or Cancel to Skip)" -PassThru
        if ($null -eq $SelectedWindowsPackages) {Write-Warning "Add Windows Package: Skipping"}
    }
    Return $SelectedWindowsPackages
}
function Get-SelectedTaskScripts {
    [CmdletBinding()]
    PARAM ()
    $SelectedTaskScripts = Get-ChildItem -Path "$OSDBuilderContent\Scripts" *.ps1 | Select-Object -Property Name, FullName, Length, CreationTime | Sort-Object -Property FullName
    foreach ($TaskScript in $SelectedTaskScripts) {$TaskScript.FullName = $($TaskScript.FullName).replace("$OSDBuilderContent\",'')}
    if ($null -eq $SelectedTaskScripts) {Write-Warning "Invoke PowerShell Scripts: To select PowerShell Scripts add Content to $OSDBuilderContent\Scripts"}
    else {
        $SelectedTaskScripts = $SelectedTaskScripts | Out-GridView -Title "Invoke PowerShell Scripts: Select PowerShell Scripts to execute and press OK (Esc or Cancel to Skip)" -PassThru
        if ($null -eq $SelectedTaskScripts) {Write-Warning "Invoke PowerShell Scripts: Skipping"}
    }
    Return $SelectedTaskScripts
}
function Get-SelectedStartLayoutXML {
    [CmdletBinding()]
    PARAM ()
    $SelectedStartLayoutXML = Get-ChildItem -Path "$OSDBuilderContent\StartLayout" *.xml | Select-Object -Property Name, FullName, Length, CreationTime | Sort-Object -Property FullName
    foreach ($StartLayout in $SelectedStartLayoutXML) {$StartLayout.FullName = $($StartLayout.FullName).replace("$OSDBuilderContent\",'')}
    if ($null -eq $SelectedStartLayoutXML) {Write-Warning "Add-StartLayout: To select a Start Layout, add Content to $OSDBuilderContent\StartLayout"}
    else {
        $SelectedStartLayoutXML = $SelectedStartLayoutXML | Out-GridView -Title "Add-StartLayout: Select a Start Layout XML to apply and press OK (Esc or Cancel to Skip)" -OutputMode Single
        if ($null -eq $SelectedStartLayoutXML) {Write-Warning "Add-StartLayout: Skipping"}
    }
    Return $SelectedStartLayoutXML
}

function Get-SelectedUnattendXML {
    [CmdletBinding()]
    PARAM ()
    $SelectedUnattendXML = Get-ChildItem -Path "$OSDBuilderContent\Unattend" *.xml | Select-Object -Property Name, FullName, Length, CreationTime | Sort-Object -Property FullName
    foreach ($Pack in $SelectedUnattendXML) {$Pack.FullName = $($Pack.FullName).replace("$OSDBuilderContent\",'')}
    if ($null -eq $SelectedUnattendXML) {Write-Warning "Use-WindowsUnattend: To select an Unattend XML, add Content to $OSDBuilderContent\Unattend"}
    else {
        $SelectedUnattendXML = $SelectedUnattendXML | Out-GridView -Title "Use-WindowsUnattend: Select a Windows Unattend XML File to apply and press OK (Esc or Cancel to Skip)" -OutputMode Single
        if ($null -eq $SelectedUnattendXML) {Write-Warning "Use-WindowsUnattend: Skipping"}
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