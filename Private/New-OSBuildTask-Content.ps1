
function Get-TaskContentDrivers {
    #===================================================================================================
    #   Content Drivers 
    #===================================================================================================
    [CmdletBinding()]
    PARAM ()
    $Drivers = Get-ChildItem -Path "$OSDBuilderContent\Drivers" -Directory -ErrorAction SilentlyContinue | Select-Object -Property Name, FullName
    foreach ($Pack in $Drivers) {$Pack.FullName = $($Pack.FullName).replace("$OSDBuilderContent\",'')}

    if ($null -eq $Drivers) {Write-Warning "Drivers: To select Windows Drivers, add Content to $OSDBuilderContent\Drivers"}
    else {
        if ($ExistingTask.Drivers) {
            foreach ($Item in $ExistingTask.Drivers) {
                $Drivers = $Drivers | Where-Object {$_.FullName -ne $Item}
            }
        }
        $Drivers = $Drivers | Out-GridView -Title "Drivers: Select Driver Paths to apply and press OK (Esc or Cancel to Skip)" -PassThru
    }
    foreach ($Item in $Drivers) {Write-Host "$($Item.FullName)" -ForegroundColor White}
    Return $Drivers
}
function Get-TaskContentExtraFiles {
    #===================================================================================================
    #   Content ExtraFiles
    #===================================================================================================
    [CmdletBinding()]
    PARAM ()
    $ExtraFiles = Get-ChildItem -Path "$OSDBuilderContent\ExtraFiles" -Directory -ErrorAction SilentlyContinue | Select-Object -Property Name, FullName
    $ExtraFiles = $ExtraFiles | Where-Object {(Get-ChildItem $_.FullName | Measure-Object).Count -gt 0}
    foreach ($Pack in $ExtraFiles) {$Pack.FullName = $($Pack.FullName).replace("$OSDBuilderContent\",'')}

    if ($null -eq $ExtraFiles) {Write-Warning "Extra Files: To select Extra Files, add Content to $OSDBuilderContent\ExtraFiles"}
    else {
        if ($ExistingTask.ExtraFiles) {
            foreach ($Item in $ExistingTask.ExtraFiles) {
                $ExtraFiles = $ExtraFiles | Where-Object {$_.FullName -ne $Item}
            }
        }
        $ExtraFiles = $ExtraFiles | Out-GridView -Title "Extra Files: Select directories to inject and press OK (Esc or Cancel to Skip)" -PassThru
    }
    foreach ($Item in $ExtraFiles) {Write-Host "$($Item.FullName)" -ForegroundColor White}
    Return $ExtraFiles
}
function Get-TaskContentScripts {
    #===================================================================================================
    #   Content Scripts
    #===================================================================================================
    [CmdletBinding()]
    PARAM ()
    $Scripts = Get-ChildItem -Path "$OSDBuilderContent\Scripts" *.ps1 -ErrorAction SilentlyContinue | Select-Object -Property Name, FullName, Length, CreationTime | Sort-Object -Property FullName
    foreach ($Item in $Scripts) {$Item.FullName = $($Item.FullName).replace("$OSDBuilderContent\",'')}

    if ($null -eq $Scripts) {Write-Warning "Scripts: To select PowerShell Scripts add Content to $OSDBuilderContent\Scripts"}
    else {
        if ($ExistingTask.Scripts) {
            foreach ($Item in $ExistingTask.Scripts) {
                $Scripts = $Scripts | Where-Object {$_.FullName -ne $Item}
            }
        }
        $Scripts = $Scripts | Out-GridView -Title "Scripts: Select PowerShell Scripts to execute and press OK (Esc or Cancel to Skip)" -PassThru
    }
    foreach ($Item in $Scripts) {Write-Host "$($Item.FullName)" -ForegroundColor White}
    Return $Scripts
}
function Get-TaskContentStartLayoutXML {
    #===================================================================================================
    #   Content StartLayout
    #===================================================================================================
    [CmdletBinding()]
    PARAM ()
    $StartLayoutXML = Get-ChildItem -Path "$OSDBuilderContent\StartLayout" *.xml -ErrorAction SilentlyContinue | Select-Object -Property Name, FullName, Length, CreationTime | Sort-Object -Property FullName
    foreach ($Item in $StartLayoutXML) {$Item.FullName = $($Item.FullName).replace("$OSDBuilderContent\",'')}

    if ($null -eq $StartLayoutXML) {Write-Warning "StartLayoutXML: To select a Start Layout, add Content to $OSDBuilderContent\StartLayout"}
    else {
        if ($ExistingTask.StartLayoutXML) {
            foreach ($Item in $ExistingTask.StartLayoutXML) {
                $StartLayoutXML = $StartLayoutXML | Where-Object {$_.FullName -ne $Item}
            }
        }
        $StartLayoutXML = $StartLayoutXML | Out-GridView -Title "StartLayoutXML: Select a Start Layout XML to apply and press OK (Esc or Cancel to Skip)" -OutputMode Single
    }
    foreach ($Item in $StartLayoutXML) {Write-Host "$($Item.FullName)" -ForegroundColor White}
    Return $StartLayoutXML
}
function Get-TaskContentUnattendXML {
    #===================================================================================================
    #   Content Unattend
    #===================================================================================================
    [CmdletBinding()]
    PARAM ()
    $UnattendXML = Get-ChildItem -Path "$OSDBuilderContent\Unattend" *.xml -ErrorAction SilentlyContinue | Select-Object -Property Name, FullName, Length, CreationTime | Sort-Object -Property FullName
    foreach ($Item in $UnattendXML) {$Item.FullName = $($Item.FullName).replace("$OSDBuilderContent\",'')}
    
    if ($null -eq $UnattendXML) {Write-Warning "UnattendXML: To select an Unattend XML, add Content to $OSDBuilderContent\Unattend"}
    else {
        if ($ExistingTask.UnattendXML) {
            foreach ($Item in $ExistingTask.UnattendXML) {
                $UnattendXML = $UnattendXML | Where-Object {$_.FullName -ne $Item}
            }
        }
        $UnattendXML = $UnattendXML | Out-GridView -Title "UnattendXML: Select a Windows Unattend XML File to apply and press OK (Esc or Cancel to Skip)" -OutputMode Single
    }
    foreach ($Item in $UnattendXML) {Write-Host "$($Item.FullName)" -ForegroundColor White}
    Return $UnattendXML
}
function Get-TaskContentAddWindowsPackage {
    #===================================================================================================
    #   Content Packages
    #===================================================================================================
    [CmdletBinding()]
    PARAM ()
    $AddWindowsPackage = Get-ChildItem -Path "$OSDBuilderContent\Packages\*" -Include *.cab, *.msu -Recurse | Select-Object -Property Name, FullName
    $AddWindowsPackage = $AddWindowsPackage | Where-Object {$_.FullName -like "*$($OSMedia.Arch)*"}
    foreach ($Item in $AddWindowsPackage) {$Item.FullName = $($Item.FullName).replace("$OSDBuilderContent\",'')}

    if ($null -eq $AddWindowsPackage) {Write-Warning "Packages: To select Windows Packages, add Content to $OSDBuilderContent\Packages"}
    else {
        if ($ExistingTask.AddWindowsPackage) {
            foreach ($Item in $ExistingTask.AddWindowsPackage) {
                $AddWindowsPackage = $AddWindowsPackage | Where-Object {$_.FullName -ne $Item}
            }
        }
        $AddWindowsPackage = $AddWindowsPackage | Out-GridView -Title "Packages: Select Packages to apply and press OK (Esc or Cancel to Skip)" -PassThru
    }
    foreach ($Item in $AddWindowsPackage) {Write-Host "$($Item.FullName)" -ForegroundColor White}
    Return $AddWindowsPackage
}