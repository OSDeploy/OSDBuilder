function Get-TaskRemoveAppxProvisionedPackage {
    #===================================================================================================
    #   RemoveAppx
    #===================================================================================================
    [CmdletBinding()]
    PARAM ()
    if ($($OSMedia.InstallationType) -eq 'Client') {
        if (Test-Path "$($OSMedia.FullName)\info\xml\Get-AppxProvisionedPackage.xml") {
            $RemoveAppxProvisionedPackage = Import-CliXml "$($OSMedia.FullName)\info\xml\Get-AppxProvisionedPackage.xml"
            $RemoveAppxProvisionedPackage = $RemoveAppxProvisionedPackage | Select-Object -Property DisplayName, PackageName
            if ($ExistingTask.RemoveAppxProvisionedPackage) {
                foreach ($Item in $ExistingTask.RemoveAppxProvisionedPackage) {
                    $RemoveAppxProvisionedPackage = $RemoveAppxProvisionedPackage | Where-Object {$_.PackageName -ne $Item}
                }
            }
            $RemoveAppxProvisionedPackage = $RemoveAppxProvisionedPackage | Out-GridView -Title "Remove-AppxProvisionedPackage: Select Packages to REMOVE and press OK (Esc or Cancel to Skip)" -PassThru
        }
        foreach ($Item in $RemoveAppxProvisionedPackage) {Write-Host "$($Item.PackageName)" -ForegroundColor White}
        Return $RemoveAppxProvisionedPackage
    } else {Write-Warning "Remove-AppxProvisionedPackage: Unsupported"}
}
function Get-TaskRemoveWindowsCapability {
    #===================================================================================================
    #   RemoveCapability
    #===================================================================================================
    [CmdletBinding()]
    PARAM ()
    if (Test-Path "$($OSMedia.FullName)\info\xml\Get-WindowsCapability.xml") {
        $RemoveWindowsCapability = Import-CliXml "$($OSMedia.FullName)\info\xml\Get-WindowsCapability.xml"
        $RemoveWindowsCapability = $RemoveWindowsCapability | Where-Object {$_.State -eq 4}
        $RemoveWindowsCapability = $RemoveWindowsCapability | Select-Object -Property Name, State
        if ($ExistingTask.RemoveWindowsCapability) {
            foreach ($Item in $ExistingTask.RemoveWindowsCapability) {
                $RemoveWindowsCapability = $RemoveWindowsCapability | Where-Object {$_.Name -ne $Item}
            }
        }
        $RemoveWindowsCapability = $RemoveWindowsCapability | Out-GridView -Title "Remove-WindowsCapability: Select Windows InBox Capability to REMOVE and press OK (Esc or Cancel to Skip)" -PassThru
    }
    foreach ($Item in $RemoveWindowsCapability) {Write-Host "$($Item.Name)" -ForegroundColor White}
    Return $RemoveWindowsCapability
}
function Get-TaskRemoveWindowsPackage {
    #===================================================================================================
    #   RemovePackage
    #===================================================================================================
    [CmdletBinding()]
    PARAM ()
    if (Test-Path "$($OSMedia.FullName)\info\xml\Get-WindowsPackage.xml") {
        $RemoveWindowsPackage = Import-CliXml "$($OSMedia.FullName)\info\xml\Get-WindowsPackage.xml"
        $RemoveWindowsPackage = $RemoveWindowsPackage | Select-Object -Property PackageName
        if ($ExistingTask.RemoveWindowsPackage) {
            foreach ($Item in $ExistingTask.RemoveWindowsPackage) {
                $RemoveWindowsPackage = $RemoveWindowsPackage | Where-Object {$_.PackageName -ne $Item}
            }
        }
        $RemoveWindowsPackage = $RemoveWindowsPackage | Out-GridView -Title "Remove-WindowsPackage: Select Packages to REMOVE and press OK (Esc or Cancel to Skip)" -PassThru
    }
    foreach ($Item in $RemoveWindowsPackage) {Write-Host "$($Item.PackageName)" -ForegroundColor White}
    Return $RemoveWindowsPackage
}
function Get-TaskDisableWindowsOptionalFeature {
    #===================================================================================================
    #   DisableWindowsOptionalFeature
    #===================================================================================================
    [CmdletBinding()]
    PARAM ()
    if (Test-Path "$($OSMedia.FullName)\info\xml\Get-WindowsOptionalFeature.xml") {
        $DisableWindowsOptionalFeature = Import-CliXml "$($OSMedia.FullName)\info\xml\Get-WindowsOptionalFeature.xml"
    }
    $DisableWindowsOptionalFeature = $DisableWindowsOptionalFeature | Select-Object -Property FeatureName, State | Sort-Object -Property FeatureName | Where-Object {$_.State -eq 2 -or $_.State -eq 3}
    $DisableWindowsOptionalFeature = $DisableWindowsOptionalFeature | Select-Object -Property FeatureName
    if ($ExistingTask.DisableWindowsOptionalFeature) {
        foreach ($Item in $ExistingTask.DisableWindowsOptionalFeature) {
            $DisableWindowsOptionalFeature = $DisableWindowsOptionalFeature | Where-Object {$_.FeatureName -ne $Item}
        }
    }
    $DisableWindowsOptionalFeature = $DisableWindowsOptionalFeature | Out-GridView -PassThru -Title "Disable-WindowsOptionalFeature: Select Windows Optional Features to Disable and press OK (Esc or Cancel to Skip)"
    foreach ($Item in $DisableWindowsOptionalFeature) {Write-Host "$($Item.FeatureName)" -ForegroundColor White}
    Return $DisableWindowsOptionalFeature
}
function Get-TaskEnableWindowsOptionalFeature {
    #===================================================================================================
    #   EnableWindowsOptionalFeature
    #===================================================================================================
    [CmdletBinding()]
    PARAM ()
    if (Test-Path "$($OSMedia.FullName)\info\xml\Get-WindowsOptionalFeature.xml") {
        $EnableWindowsOptionalFeature = Import-CliXml "$($OSMedia.FullName)\info\xml\Get-WindowsOptionalFeature.xml"
    }
    $EnableWindowsOptionalFeature = $EnableWindowsOptionalFeature | Select-Object -Property FeatureName, State | Sort-Object -Property FeatureName | Where-Object {$_.State -eq 0}
    $EnableWindowsOptionalFeature = $EnableWindowsOptionalFeature | Select-Object -Property FeatureName
    if ($ExistingTask.EnableWindowsOptionalFeature) {
        foreach ($Item in $ExistingTask.EnableWindowsOptionalFeature) {
            $EnableWindowsOptionalFeature = $EnableWindowsOptionalFeature | Where-Object {$_.FeatureName -ne $Item}
        }
    }

    $EnableWindowsOptionalFeature = $EnableWindowsOptionalFeature | Out-GridView -PassThru -Title "Enable-WindowsOptionalFeature: Select Windows Optional Features to ENABLE and press OK (Esc or Cancel to Skip)"
    foreach ($Item in $EnableWindowsOptionalFeature) {Write-Host "$($Item.FeatureName)" -ForegroundColor White}
    Return $EnableWindowsOptionalFeature
}