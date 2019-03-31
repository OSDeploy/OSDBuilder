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