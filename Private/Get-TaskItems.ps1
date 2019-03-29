function Get-TaskRemoveAppxProvisionedPackage {
    #===================================================================================================
    #   Install.wim Remove-AppxProvisionedPackage
    #===================================================================================================
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
function Get-TaskRemoveWindowsPackage {
    #===================================================================================================
    #   Install.wim Remove-WindowsPackage
    #===================================================================================================
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
function Get-TaskRemoveWindowsCapability {
    #===================================================================================================
    #   Install.wim Remove-WindowsCapability
    #===================================================================================================
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
function Get-TaskDisableWindowsOptionalFeature {
    #===================================================================================================
    #   Install.Wim Disable-WindowsOptionalFeature
    #===================================================================================================
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
function Get-TaskEnableWindowsOptionalFeature {
    #===================================================================================================
    #   Install.Wim Enable-WindowsOptionalFeature
    #===================================================================================================
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
function Get-TaskDrivers {
    #===================================================================================================
    #   Install.Wim Add-WindowsDriver
    #===================================================================================================
    [CmdletBinding()]
    PARAM ()
    if ($SelectDrivers.IsPresent) {
        $TaskDrivers =@()
        $TaskDrivers = Get-ChildItem -Path "$OSDBuilderContent\Drivers" -Directory -ErrorAction SilentlyContinue | Select-Object -Property Name, FullName
        foreach ($Pack in $TaskDrivers) {$Pack.FullName = $($Pack.FullName).replace("$OSDBuilderContent\",'')}
        if ($null -eq $TaskDrivers) {Write-Warning "Add-WindowsDriver: To select Windows Drivers, add Content to $OSDBuilderContent\Drivers"}
        else {
            $TaskDrivers = $TaskDrivers | Out-GridView -Title "Add-WindowsDriver: Select Driver Paths to apply and press OK (Esc or Cancel to Skip)" -PassThru
            if ($null -eq $TaskDrivers) {Write-Warning "Add-WindowsDriver: Skipping"}
        }
        Return $TaskDrivers
    }
}

function Get-TaskWinPEDrivers {
    #===================================================================================================
    #   WinPE Add-WindowsDriver
    #===================================================================================================
    [CmdletBinding()]
    PARAM ()
    if ($SelectWinPEDrivers.IsPresent) {
        $TaskWinPEDrivers =@()
        $TaskWinPEDrivers = Get-ChildItem -Path ("$OSDBuilderContent\Drivers","$OSDBuilderContent\WinPE\Drivers") -Directory -ErrorAction SilentlyContinue | Select-Object -Property Name, FullName
        foreach ($Pack in $TaskWinPEDrivers) {$Pack.FullName = $($Pack.FullName).replace("$OSDBuilderContent\",'')}
        if ($null -eq $TaskWinPEDrivers) {Write-Warning "Add-WindowsDriver WinPE: To select WinPE Drivers, add Content to $OSDBuilderContent\Drivers"}
        else {
            $TaskWinPEDrivers = $TaskWinPEDrivers | Out-GridView -Title "Add-WindowsDriver WinPE: Select Driver Paths to apply and press OK (Esc or Cancel to Skip)" -PassThru
            if ($null -eq $TaskWinPEDrivers) {Write-Warning "Add-WindowsDriver WinPE: Skipping"}
        }
        Return $TaskWinPEDrivers
    }
}
function Get-TaskExtraFiles {
    #===================================================================================================
    #   Install.Wim Add-ExtraFiles
    #===================================================================================================
    [CmdletBinding()]
    PARAM ()
    if ($SelectExtraFiles.IsPresent) {
        $TaskExtraFiles = Get-ChildItem -Path "$OSDBuilderContent\ExtraFiles" -Directory -ErrorAction SilentlyContinue | Select-Object -Property Name, FullName
        $TaskExtraFiles = $TaskExtraFiles | Where-Object {(Get-ChildItem $_.FullName | Measure-Object).Count -gt 0}
        foreach ($Pack in $TaskExtraFiles) {$Pack.FullName = $($Pack.FullName).replace("$OSDBuilderContent\",'')}
        if ($null -eq $TaskExtraFiles) {Write-Warning "Add Extra Files: To select Extra Files, add Content to $OSDBuilderContent\ExtraFiles"}
        else {
            $TaskExtraFiles = $TaskExtraFiles | Out-GridView -Title "AddExtra Files: Select directories to inject and press OK (Esc or Cancel to Skip)" -PassThru
            if ($null -eq $TaskExtraFiles) {Write-Warning "Add Extra Files: Skipping"}
        }
        Return $TaskExtraFiles
    }
}
function Get-TaskWinPEExtraFiles {
    #===================================================================================================
    #   WinPE Add-ExtraFiles
    #===================================================================================================
    [CmdletBinding()]
    PARAM ()
    if ($SelectWinPEExtraFiles.IsPresent) {
        $TaskWinPEExtraFiles = Get-ChildItem -Path ("$OSDBuilderContent\ExtraFiles","$OSDBuilderContent\WinPE\ExtraFiles") -Directory -ErrorAction SilentlyContinue | Select-Object -Property Name, FullName
        $TaskWinPEExtraFiles = $TaskWinPEExtraFiles | Where-Object {(Get-ChildItem $_.FullName | Measure-Object).Count -gt 0}
        foreach ($Pack in $TaskWinPEExtraFiles) {$Pack.FullName = $($Pack.FullName).replace("$OSDBuilderContent\",'')}
        if ($null -eq $TaskWinPEExtraFiles) {Write-Warning "Add WinPE Extra Files: To select WinPE Extra Files, add Content to $OSDBuilderContent\ExtraFiles"}
        else {
            $TaskWinPEExtraFiles = $TaskWinPEExtraFiles | Out-GridView -Title "Add WinPE Extra Files: Select directories to inject and press OK (Esc or Cancel to Skip)" -PassThru
            if ($null -eq $TaskWinPEExtraFiles) {Write-Warning "Add WinPE Extra Files: Skipping"}
        }
        Return $TaskWinPEExtraFiles
    }
}
function Get-TaskWinREExtraFiles {
    #===================================================================================================
    #   WinRE Add-ExtraFiles
    #===================================================================================================
    [CmdletBinding()]
    PARAM ()
    if ($SelectWinPEExtraFiles.IsPresent) {
        $TaskWinREExtraFiles = Get-ChildItem -Path ("$OSDBuilderContent\ExtraFiles","$OSDBuilderContent\WinPE\ExtraFiles") -Directory -ErrorAction SilentlyContinue | Select-Object -Property Name, FullName
        $TaskWinREExtraFiles = $TaskWinREExtraFiles | Where-Object {(Get-ChildItem $_.FullName | Measure-Object).Count -gt 0}
        foreach ($Pack in $TaskWinREExtraFiles) {$Pack.FullName = $($Pack.FullName).replace("$OSDBuilderContent\",'')}
        if ($null -eq $TaskWinREExtraFiles) {Write-Warning "Add WinRE Extra Files: To select WinRE Extra Files, add Content to $OSDBuilderContent\ExtraFiles"}
        else {
            $TaskWinREExtraFiles = $TaskWinREExtraFiles | Out-GridView -Title "Add WinRE Extra Files: Select directories to inject and press OK (Esc or Cancel to Skip)" -PassThru
            if ($null -eq $TaskWinREExtraFiles) {Write-Warning "Add WinRE Extra Files: Skipping"}
        }
        Return $TaskWinREExtraFiles
    }
}
function Get-TaskWinSEExtraFiles {
    #===================================================================================================
    #   WinSE Add-ExtraFiles
    #===================================================================================================
    [CmdletBinding()]
    PARAM ()
    if ($SelectWinPEExtraFiles.IsPresent) {
        $TaskWinSEExtraFiles = Get-ChildItem -Path ("$OSDBuilderContent\ExtraFiles","$OSDBuilderContent\WinPE\ExtraFiles") -Directory -ErrorAction SilentlyContinue | Select-Object -Property Name, FullName
        $TaskWinSEExtraFiles = $TaskWinSEExtraFiles | Where-Object {(Get-ChildItem $_.FullName | Measure-Object).Count -gt 0}
        foreach ($Pack in $TaskWinSEExtraFiles) {$Pack.FullName = $($Pack.FullName).replace("$OSDBuilderContent\",'')}
        if ($null -eq $TaskWinSEExtraFiles) {Write-Warning "Add WinSE Extra Files: To select WinSE Extra Files, add Content to $OSDBuilderContent\ExtraFiles"}
        else {
            $TaskWinSEExtraFiles = $TaskWinSEExtraFiles | Out-GridView -Title "Add WinSE Extra Files: Select directories to inject and press OK (Esc or Cancel to Skip)" -PassThru
            if ($null -eq $TaskWinSEExtraFiles) {Write-Warning "Add WinSE Extra Files: Skipping"}
        }
        Return $TaskWinSEExtraFiles
    }
}
function Get-TaskScripts {
    #===================================================================================================
    #   Install.Wim PowerShell Scripts
    #===================================================================================================
    [CmdletBinding()]
    PARAM ()
    if ($SelectScripts.IsPresent) {
        $TaskScripts = Get-ChildItem -Path "$OSDBuilderContent\Scripts" *.ps1 -ErrorAction SilentlyContinue | Select-Object -Property Name, FullName, Length, CreationTime | Sort-Object -Property FullName
        foreach ($TaskScript in $TaskScripts) {$TaskScript.FullName = $($TaskScript.FullName).replace("$OSDBuilderContent\",'')}
        if ($null -eq $TaskScripts) {Write-Warning "PowerShell Scripts: To select PowerShell Scripts add Content to $OSDBuilderContent\Scripts"}
        else {
            $TaskScripts = $TaskScripts | Out-GridView -Title "PowerShell Scripts: Select PowerShell Scripts to execute and press OK (Esc or Cancel to Skip)" -PassThru
            if ($null -eq $TaskScripts) {Write-Warning "PowerShell Scripts: Skipping"}
        }
        Return $TaskScripts
    }
}
function Get-TaskWinPEScripts {
    #===================================================================================================
    #   WinPE PowerShell Scripts
    #===================================================================================================
    [CmdletBinding()]
    PARAM ()
    if ($SelectWinPEScripts.IsPresent) {
        $TaskWinPEScripts = Get-ChildItem -Path ("$OSDBuilderContent\Scripts","$OSDBuilderContent\WinPE\Scripts") *.ps1 -ErrorAction SilentlyContinue | Select-Object -Property Name, FullName, Length, CreationTime | Sort-Object -Property FullName
        foreach ($TaskScript in $TaskWinPEScripts) {$TaskScript.FullName = $($TaskScript.FullName).replace("$OSDBuilderContent\",'')}
        if ($null -eq $TaskWinPEScripts) {Write-Warning "WinPE PowerShell Scripts: To select PowerShell Scripts add Content to $OSDBuilderContent\Scripts"}
        else {
            $TaskWinPEScripts = $TaskWinPEScripts | Out-GridView -Title "WinPE PowerShell Scripts: Select PowerShell Scripts to execute and press OK (Esc or Cancel to Skip)" -PassThru
            if ($null -eq $TaskWinPEScripts) {Write-Warning "WinPE PowerShell Scripts: Skipping"}
        }
        Return $TaskWinPEScripts
    }
}
function Get-TaskWinREScripts {
    #===================================================================================================
    #   WinRE PowerShell Scripts
    #===================================================================================================
    [CmdletBinding()]
    PARAM ()
    if ($SelectWinREScripts.IsPresent) {
        $TaskWinREScripts = Get-ChildItem -Path ("$OSDBuilderContent\Scripts","$OSDBuilderContent\WinPE\Scripts") *.ps1 -ErrorAction SilentlyContinue | Select-Object -Property Name, FullName, Length, CreationTime | Sort-Object -Property FullName
        foreach ($TaskScript in $TaskWinREScripts) {$TaskScript.FullName = $($TaskScript.FullName).replace("$OSDBuilderContent\",'')}
        if ($null -eq $TaskWinREScripts) {Write-Warning "WinRE PowerShell Scripts: To select PowerShell Scripts add Content to $OSDBuilderContent\Scripts"}
        else {
            $TaskWinREScripts = $TaskWinREScripts | Out-GridView -Title "WinRE PowerShell Scripts: Select PowerShell Scripts to execute and press OK (Esc or Cancel to Skip)" -PassThru
            if ($null -eq $TaskWinREScripts) {Write-Warning "WinRE PowerShell Scripts: Skipping"}
        }
        Return $TaskWinREScripts
    }
}
function Get-TaskWinSEScripts {
    #===================================================================================================
    #   WinSE PowerShell Scripts
    #===================================================================================================
    [CmdletBinding()]
    PARAM ()
    if ($SelectWinSEScripts.IsPresent) {
        $TaskWinSEScripts = Get-ChildItem -Path ("$OSDBuilderContent\Scripts","$OSDBuilderContent\WinPE\Scripts") *.ps1 -ErrorAction SilentlyContinue | Select-Object -Property Name, FullName, Length, CreationTime | Sort-Object -Property FullName
        foreach ($TaskScript in $TaskWinSEScripts) {$TaskScript.FullName = $($TaskScript.FullName).replace("$OSDBuilderContent\",'')}
        if ($null -eq $TaskWinSEScripts) {Write-Warning "WinSE PowerShell Scripts: To select PowerShell Scripts add Content to $OSDBuilderContent\Scripts"}
        else {
            $TaskWinSEScripts = $TaskWinSEScripts | Out-GridView -Title "WinSE PowerShell Scripts: Select PowerShell Scripts to execute and press OK (Esc or Cancel to Skip)" -PassThru
            if ($null -eq $TaskWinSEScripts) {Write-Warning "WinSE PowerShell Scripts: Skipping"}
        }
        Return $TaskWinSEScripts
    }
}
function Get-TaskStartLayoutXML {
    #===================================================================================================
    #   Install.Wim Start Layout
    #===================================================================================================
    [CmdletBinding()]
    PARAM ()
    if ($SelectStartLayoutXML.IsPresent) {
        $TaskStartLayoutXML = Get-ChildItem -Path "$OSDBuilderContent\StartLayout" *.xml -ErrorAction SilentlyContinue | Select-Object -Property Name, FullName, Length, CreationTime | Sort-Object -Property FullName
        foreach ($StartLayout in $TaskStartLayoutXML) {$StartLayout.FullName = $($StartLayout.FullName).replace("$OSDBuilderContent\",'')}
        if ($null -eq $TaskStartLayoutXML) {Write-Warning "Add-StartLayout: To select a Start Layout, add Content to $OSDBuilderContent\StartLayout"}
        else {
            $TaskStartLayoutXML = $TaskStartLayoutXML | Out-GridView -Title "Add-StartLayout: Select a Start Layout XML to apply and press OK (Esc or Cancel to Skip)" -OutputMode Single
            if ($null -eq $TaskStartLayoutXML) {Write-Warning "Add-StartLayout: Skipping"}
        }
        Return $TaskStartLayoutXML
    }
}
function Get-TaskUnattendXML {
    #===================================================================================================
    #   Install.Wim Unattend.xml
    #===================================================================================================
    [CmdletBinding()]
    PARAM ()
    if ($SelectUnattendXML.IsPresent) {
        $TaskUnattendXML = Get-ChildItem -Path "$OSDBuilderContent\Unattend" *.xml -ErrorAction SilentlyContinue | Select-Object -Property Name, FullName, Length, CreationTime | Sort-Object -Property FullName
        foreach ($Pack in $TaskUnattendXML) {$Pack.FullName = $($Pack.FullName).replace("$OSDBuilderContent\",'')}
        if ($null -eq $TaskUnattendXML) {Write-Warning "Use-WindowsUnattend: To select an Unattend XML, add Content to $OSDBuilderContent\Unattend"}
        else {
            $TaskUnattendXML = $TaskUnattendXML | Out-GridView -Title "Use-WindowsUnattend: Select a Windows Unattend XML File to apply and press OK (Esc or Cancel to Skip)" -OutputMode Single
            if ($null -eq $TaskUnattendXML) {Write-Warning "Use-WindowsUnattend: Skipping"}
        }
        Return $TaskUnattendXML
    }
}

function Get-SelectedWindowsPackages {
    #===================================================================================================
    #   Install.Wim Packages
    #===================================================================================================
    [CmdletBinding()]
    PARAM ()
    if ($SelectPackages.IsPresent) {
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
}
function Get-SelectedWinPEDaRT {
    #===================================================================================================
    #   WinPE DaRT
    #===================================================================================================
    [CmdletBinding()]
    PARAM ()
    if ($SelectWinPEDart.IsPresent) {
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
}
function Get-SelectedFeaturesOnDemand {
    #===================================================================================================
    #   Install.Wim Features On Demand
    #===================================================================================================
    [CmdletBinding()]
    PARAM ()
    if ($SelectFeaturesOnDemand.IsPresent) {
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