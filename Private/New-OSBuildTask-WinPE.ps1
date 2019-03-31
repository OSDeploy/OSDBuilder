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
function Get-TaskWinPEADK {
    #===================================================================================================
    #   WinPE ADK
    #===================================================================================================
    [CmdletBinding()]
    PARAM ()
    if ($SelectWinPEADK.IsPresent) {
        $TaskWinPEADK = Get-ChildItem -Path ("$OSDBuilderContent\WinPE\ADK\*","$OSDBuilderContent\ADK\*\Windows Preinstallation Environment\*\WinPE_OCs") *.cab -Recurse | Select-Object -Property Name, FullName
        foreach ($Pack in $TaskWinPEADK) {$Pack.FullName = $($Pack.FullName).replace("$OSDBuilderContent\",'')}
        $TaskWinPEADK = $TaskWinPEADK | Where-Object {$_.FullName -like "*$($OSMedia.ReleaseId)*"}

        if ($OSMedia.Arch -eq 'x86') {$TaskWinPEADK = $TaskWinPEADK | Where-Object {$_.FullName -like "*x86*"}
        } else {$TaskWinPEADK = $TaskWinPEADK | Where-Object {($_.FullName -like "*x64*") -or ($_.FullName -like "*amd64*")}}

        if ($null -eq $TaskWinPEADK) {Write-Warning "WinPE.wim ADK Packages: Add Content to $OSDBuilderContent\WinPE ADK"}
        else {
            $TaskWinPEADK = $TaskWinPEADK | Out-GridView -Title "WinPE.wim ADK Packages: Select ADK Packages to apply and press OK (Esc or Cancel to Skip)" -PassThru
            if ($null -eq $TaskWinPEADK) {Write-Warning "WinPE.wim ADK Packages: Skipping"}
        }
    }
}
function Get-TaskWinREADK {
    #===================================================================================================
    #   WinRE ADK
    #===================================================================================================
    [CmdletBinding()]
    PARAM ()
    if ($SelectWinPEADK.IsPresent) {
        $TaskWinREADK = Get-ChildItem -Path ("$OSDBuilderContent\WinPE\ADK\*","$OSDBuilderContent\ADK\*\Windows Preinstallation Environment\*\WinPE_OCs") *.cab -Recurse | Select-Object -Property Name, FullName
        foreach ($Pack in $TaskWinREADK) {$Pack.FullName = $($Pack.FullName).replace("$OSDBuilderContent\",'')}
        $TaskWinREADK = $TaskWinREADK | Where-Object {$_.FullName -like "*$($OSMedia.ReleaseId)*"}

        if ($OSMedia.Arch -eq 'x86') {$TaskWinREADK = $TaskWinREADK | Where-Object {$_.FullName -like "*x86*"}
        } else {$TaskWinREADK = $TaskWinREADK | Where-Object {($_.FullName -like "*x64*") -or ($_.FullName -like "*amd64*")}}

        if ($null -eq $TaskWinREADK) {Write-Warning "WinRE.wim ADK Packages: Add Content to $OSDBuilderContent\WinPE ADK"}
        else {
            $TaskWinREADK = $TaskWinREADK | Out-GridView -Title "WinRE.wim ADK Packages: Select ADK Packages to apply and press OK (Esc or Cancel to Skip)" -PassThru
            if ($null -eq $TaskWinREADK) {Write-Warning "WinRE.wim ADK Packages: Skipping"}
            else {
                Write-Warning "If you add too many ADK Packages to WinRE, like .Net and PowerShell"
                Write-Warning "You run a risk of your WinRE size increasing considerably"
                Write-Warning "If your MBR System or UEFI Recovery Partition are 500MB,"
                Write-Warning "your WinRE.wim should not be more than 400MB (100MB Free)"
                Write-Warning "Consider changing your Task Sequences to have a 984MB"
                Write-Warning "MBR System or UEFI Recovery Partition"
            }
        }
    }
}
function Get-TaskWinSEADK {
    #===================================================================================================
    #   WinRE ADK
    #===================================================================================================
    [CmdletBinding()]
    PARAM ()
    if ($SelectWinPEADK.IsPresent) {
        $TaskWinSEADK = Get-ChildItem -Path ("$OSDBuilderContent\WinPE\ADK\*","$OSDBuilderContent\ADK\*\Windows Preinstallation Environment\*\WinPE_OCs") *.cab -Recurse | Select-Object -Property Name, FullName
        foreach ($Pack in $TaskWinSEADK) {$Pack.FullName = $($Pack.FullName).replace("$OSDBuilderContent\",'')}
        $TaskWinSEADK = $TaskWinSEADK | Where-Object {$_.FullName -like "*$($OSMedia.ReleaseId)*"}

        if ($OSMedia.Arch -eq 'x86') {$TaskWinSEADK = $TaskWinSEADK | Where-Object {$_.FullName -like "*x86*"}
        } else {$TaskWinSEADK = $TaskWinSEADK | Where-Object {($_.FullName -like "*x64*") -or ($_.FullName -like "*amd64*")}}

        if ($null -eq $TaskWinSEADK) {Write-Warning "WinSE.wim ADK Packages: Add Content to $OSDBuilderContent\WinPE ADK"}
        else {
            $TaskWinSEADK = $TaskWinSEADK | Out-GridView -Title "WinSE.wim ADK Packages: Select ADK Packages to apply and press OK (Esc or Cancel to Skip)" -PassThru
            if ($null -eq $TaskWinSEADK) {Write-Warning "WinSE.wim ADK Packages: Skipping"}
        }
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
