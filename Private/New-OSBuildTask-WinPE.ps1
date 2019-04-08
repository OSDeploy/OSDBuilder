function Get-TaskWinPEDaRT {
    #===================================================================================================
    #   WinPE DaRT
    #===================================================================================================
    [CmdletBinding()]
    PARAM ()
    $WinPEDaRT = Get-ChildItem -Path ("$OSDBuilderContent\DaRT","$OSDBuilderContent\WinPE\DaRT") *.cab -Recurse -ErrorAction SilentlyContinue | Select-Object -Property Name, FullName
    $WinPEDaRT = $WinPEDaRT | Where-Object {$_.FullName -like "*$($OSMedia.Arch)*"}
    foreach ($Pack in $WinPEDaRT) {$Pack.FullName = $($Pack.FullName).replace("$OSDBuilderContent\",'')}
    if ($null -eq $WinPEDaRT) {Write-Warning "WinPEDaRT: Add Content to $OSDBuilderContent\DaRT"}
    else {
        if ($ExistingTask.WinPEDaRT) {
            foreach ($Item in $ExistingTask.WinPEDaRT) {
                $WinPEDaRT = $WinPEDaRT | Where-Object {$_.FullName -ne $Item}
            }
        }
        $WinPEDaRT = $WinPEDaRT | Out-GridView -Title "WinPEDaRT: Select a WinPE DaRT Package to apply and press OK (Esc or Cancel to Skip)" -OutputMode Single
    }
    foreach ($Item in $WinPEDaRT) {Write-Host "$($Item.FullName)" -ForegroundColor White}
    Return $WinPEDaRT
}
function Get-TaskWinPEADKPE {
    #===================================================================================================
    #   WinPE ADK
    #===================================================================================================
    [CmdletBinding()]
    PARAM ()
    $WinPEADKPE = Get-ChildItem -Path ("$OSDBuilderContent\WinPE\ADK\*","$OSDBuilderContent\ADK\*\Windows Preinstallation Environment\*\WinPE_OCs") *.cab -Recurse -ErrorAction SilentlyContinue | Select-Object -Property Name, FullName
    foreach ($Pack in $WinPEADKPE) {$Pack.FullName = $($Pack.FullName).replace("$OSDBuilderContent\",'')}
    $WinPEADKPE = $WinPEADKPE | Where-Object {$_.FullName -like "*$($OSMedia.ReleaseId)*"}

    if ($OSMedia.Arch -eq 'x86') {$WinPEADKPE = $WinPEADKPE | Where-Object {$_.FullName -like "*x86*"}
    } else {$WinPEADKPE = $WinPEADKPE | Where-Object {($_.FullName -like "*x64*") -or ($_.FullName -like "*amd64*")}}

    $WinPEADKPEIE = @()
    $WinPEADKPEIE = $ContentIsoExtractWinPE | Select-Object -Property Name, FullName
    [array]$WinPEADKPE = [array]$WinPEADKPE + [array]$WinPEADKPEIE

    if ($null -eq $WinPEADKPE) {Write-Warning "WinPE.wim ADK Packages: Add Content to $OSDBuilderContent\ADK"}
    else {
        if ($ExistingTask.WinPEADKPE) {
            foreach ($Item in $ExistingTask.WinPEADKPE) {
                $WinPEADKPE = $WinPEADKPE | Where-Object {$_.FullName -ne $Item}
            }
        }
        $WinPEADKPE = $WinPEADKPE | Out-GridView -Title "WinPE.wim ADK Packages: Select ADK Packages to apply and press OK (Esc or Cancel to Skip)" -PassThru
    }
    foreach ($Item in $WinPEADKPE) {Write-Host "$($Item.FullName)" -ForegroundColor White}
    Return $WinPEADKPE
}
function Get-TaskWinPEADKRE {
    #===================================================================================================
    #   WinRE ADK
    #===================================================================================================
    [CmdletBinding()]
    PARAM ()
    $WinPEADKRE = Get-ChildItem -Path ("$OSDBuilderContent\WinPE\ADK\*","$OSDBuilderContent\ADK\*\Windows Preinstallation Environment\*\WinPE_OCs") *.cab -Recurse -ErrorAction SilentlyContinue | Select-Object -Property Name, FullName
    
    foreach ($Pack in $WinPEADKRE) {$Pack.FullName = $($Pack.FullName).replace("$OSDBuilderContent\",'')}
    $WinPEADKRE = $WinPEADKRE | Where-Object {$_.FullName -like "*$($OSMedia.ReleaseId)*"}

    if ($OSMedia.Arch -eq 'x86') {$WinPEADKRE = $WinPEADKRE | Where-Object {$_.FullName -like "*x86*"}
    } else {$WinPEADKRE = $WinPEADKRE | Where-Object {($_.FullName -like "*x64*") -or ($_.FullName -like "*amd64*")}}

    $WinPEADKREIE = @()
    $WinPEADKREIE = $ContentIsoExtractWinPE | Select-Object -Property Name, FullName
    [array]$WinPEADKRE = [array]$WinPEADKRE + [array]$WinPEADKREIE

    if ($null -eq $WinPEADKRE) {Write-Warning "WinRE.wim ADK Packages: Add Content to $OSDBuilderContent\ADK"}
    else {
        if ($ExistingTask.WinPEADKRE) {
            foreach ($Item in $ExistingTask.WinPEADKRE) {
                $WinPEADKRE = $WinPEADKRE | Where-Object {$_.FullName -ne $Item}
            }
        }
        Write-Warning "If you add too many ADK Packages to WinRE, like .Net and PowerShell"
        Write-Warning "You run a risk of your WinRE size increasing considerably"
        Write-Warning "If your MBR System or UEFI Recovery Partition are 500MB,"
        Write-Warning "your WinRE.wim should not be more than 400MB (100MB Free)"
        Write-Warning "Consider changing your Task Sequences to have a 984MB"
        Write-Warning "MBR System or UEFI Recovery Partition"
        $WinPEADKRE = $WinPEADKRE | Out-GridView -Title "WinRE.wim ADK Packages: Select ADK Packages to apply and press OK (Esc or Cancel to Skip)" -PassThru
    }
    foreach ($Item in $WinPEADKRE) {Write-Host "$($Item.FullName)" -ForegroundColor White}
    Return $WinPEADKRE
}
function Get-TaskWinPEADKSE {
    #===================================================================================================
    #   WinRE ADK
    #===================================================================================================
    [CmdletBinding()]
    PARAM ()
    $WinPEADKSE = Get-ChildItem -Path ("$OSDBuilderContent\WinPE\ADK\*","$OSDBuilderContent\ADK\*\Windows Preinstallation Environment\*\WinPE_OCs","$ContentIsoExtractWinPE") *.cab -Recurse -ErrorAction SilentlyContinue | Select-Object -Property Name, FullName
    foreach ($Pack in $WinPEADKSE) {$Pack.FullName = $($Pack.FullName).replace("$OSDBuilderContent\",'')}
    $WinPEADKSE = $WinPEADKSE | Where-Object {$_.FullName -like "*$($OSMedia.ReleaseId)*"}

    if ($OSMedia.Arch -eq 'x86') {$WinPEADKSE = $WinPEADKSE | Where-Object {$_.FullName -like "*x86*"}
    } else {$WinPEADKSE = $WinPEADKSE | Where-Object {($_.FullName -like "*x64*") -or ($_.FullName -like "*amd64*")}}

    $WinPEADKSEIE = @()
    $WinPEADKSEIE = $ContentIsoExtractWinPE | Select-Object -Property Name, FullName
    [array]$WinPEADKSE = [array]$WinPEADKSE + [array]$WinPEADKSEIE

    if ($null -eq $WinPEADKSE) {Write-Warning "WinSE.wim ADK Packages: Add Content to $OSDBuilderContent\ADK"}
    else {
        if ($ExistingTask.WinPEADKSE) {
            foreach ($Item in $ExistingTask.WinPEADKSE) {
                $WinPEADKSE = $WinPEADKSE | Where-Object {$_.FullName -ne $Item}
            }
        }
        $WinPEADKSE = $WinPEADKSE | Out-GridView -Title "WinSE.wim ADK Packages: Select ADK Packages to apply and press OK (Esc or Cancel to Skip)" -PassThru
    }
    foreach ($Item in $WinPEADKSE) {Write-Host "$($Item.FullName)" -ForegroundColor White}
    Return $WinPEADKSE
}
function Get-TaskWinPEDrivers {
    #===================================================================================================
    #   WinPE Add-WindowsDriver
    #===================================================================================================
    [CmdletBinding()]
    PARAM ()
    $WinPEDrivers = Get-ChildItem -Path ("$OSDBuilderContent\Drivers","$OSDBuilderContent\WinPE\Drivers") -Directory -ErrorAction SilentlyContinue | Select-Object -Property Name, FullName
    foreach ($Pack in $WinPEDrivers) {$Pack.FullName = $($Pack.FullName).replace("$OSDBuilderContent\",'')}
    if ($null -eq $WinPEDrivers) {Write-Warning "WinPEDrivers: To select WinPE Drivers, add Content to $OSDBuilderContent\Drivers"}
    else {
        if ($ExistingTask.WinPEDrivers) {
            foreach ($Item in $ExistingTask.WinPEDrivers) {
                $WinPEDrivers = $WinPEDrivers | Where-Object {$_.FullName -ne $Item}
            }
        }
        $WinPEDrivers = $WinPEDrivers | Out-GridView -Title "WinPEDrivers: Select Driver Paths to apply and press OK (Esc or Cancel to Skip)" -PassThru
    }
    foreach ($Item in $WinPEDrivers) {Write-Host "$($Item.FullName)" -ForegroundColor White}
    Return $WinPEDrivers
}
function Get-TaskWinPEExtraFilesPE {
    #===================================================================================================
    #   WinPEExtraFilesPE
    #===================================================================================================
    [CmdletBinding()]
    PARAM ()
    $WinPEExtraFilesPE = Get-ChildItem -Path ("$OSDBuilderContent\ExtraFiles","$OSDBuilderContent\WinPE\ExtraFiles") -Directory -ErrorAction SilentlyContinue | Select-Object -Property Name, FullName
    $WinPEExtraFilesPE = $WinPEExtraFilesPE | Where-Object {(Get-ChildItem $_.FullName | Measure-Object).Count -gt 0}
    foreach ($Pack in $WinPEExtraFilesPE) {$Pack.FullName = $($Pack.FullName).replace("$OSDBuilderContent\",'')}
    if ($null -eq $WinPEExtraFilesPE) {Write-Warning "WinPEExtraFilesPE: To select WinPE Extra Files, add Content to $OSDBuilderContent\ExtraFiles"}
    else {
        if ($ExistingTask.WinPEExtraFilesPE) {
            foreach ($Item in $ExistingTask.WinPEExtraFilesPE) {
                $WinPEExtraFilesPE = $WinPEExtraFilesPE | Where-Object {$_.FullName -ne $Item}
            }
        }
        $WinPEExtraFilesPE = $WinPEExtraFilesPE | Out-GridView -Title "WinPEExtraFilesPE: Select directories to inject and press OK (Esc or Cancel to Skip)" -PassThru
    }
    foreach ($Item in $WinPEExtraFilesPE) {Write-Host "$($Item.FullName)" -ForegroundColor White}
    Return $WinPEExtraFilesPE
}
function Get-TaskWinPEExtraFilesRE {
    #===================================================================================================
    #   WinPEExtraFilesRE
    #===================================================================================================
    [CmdletBinding()]
    PARAM ()
    $WinPEExtraFilesRE = Get-ChildItem -Path ("$OSDBuilderContent\ExtraFiles","$OSDBuilderContent\WinPE\ExtraFiles") -Directory -ErrorAction SilentlyContinue | Select-Object -Property Name, FullName
    $WinPEExtraFilesRE = $WinPEExtraFilesRE | Where-Object {(Get-ChildItem $_.FullName | Measure-Object).Count -gt 0}
    foreach ($Pack in $WinPEExtraFilesRE) {$Pack.FullName = $($Pack.FullName).replace("$OSDBuilderContent\",'')}
    if ($null -eq $WinPEExtraFilesRE) {Write-Warning "WinPEExtraFilesRE: To select WinRE Extra Files, add Content to $OSDBuilderContent\ExtraFiles"}
    else {
        if ($ExistingTask.WinPEExtraFilesRE) {
            foreach ($Item in $ExistingTask.WinPEExtraFilesRE) {
                $WinPEExtraFilesRE = $WinPEExtraFilesRE | Where-Object {$_.FullName -ne $Item}
            }
        }
        $WinPEExtraFilesRE = $WinPEExtraFilesRE | Out-GridView -Title "WinPEExtraFilesRE: Select directories to inject and press OK (Esc or Cancel to Skip)" -PassThru
    }
    foreach ($Item in $WinPEExtraFilesRE) {Write-Host "$($Item.FullName)" -ForegroundColor White}
    Return $WinPEExtraFilesRE
}
function Get-TaskWinPEExtraFilesSE {
    #===================================================================================================
    #   WinSE Add-ExtraFiles
    #===================================================================================================
    [CmdletBinding()]
    PARAM ()
    $WinPEExtraFilesSE = Get-ChildItem -Path ("$OSDBuilderContent\ExtraFiles","$OSDBuilderContent\WinPE\ExtraFiles") -Directory -ErrorAction SilentlyContinue | Select-Object -Property Name, FullName
    $WinPEExtraFilesSE = $WinPEExtraFilesSE | Where-Object {(Get-ChildItem $_.FullName | Measure-Object).Count -gt 0}
    foreach ($Pack in $WinPEExtraFilesSE) {$Pack.FullName = $($Pack.FullName).replace("$OSDBuilderContent\",'')}
    if ($null -eq $WinPEExtraFilesSE) {Write-Warning "WinPEExtraFilesSE: To select WinSE Extra Files, add Content to $OSDBuilderContent\ExtraFiles"}
    else {
        if ($ExistingTask.WinPEExtraFilesSE) {
            foreach ($Item in $ExistingTask.WinPEExtraFilesSE) {
                $WinPEExtraFilesSE = $WinPEExtraFilesSE | Where-Object {$_.FullName -ne $Item}
            }
        }
        $WinPEExtraFilesSE = $WinPEExtraFilesSE | Out-GridView -Title "WinPEExtraFilesSE: Select directories to inject and press OK (Esc or Cancel to Skip)" -PassThru
    }
    foreach ($Item in $WinPEExtraFilesSE) {Write-Host "$($Item.FullName)" -ForegroundColor White}
    Return $WinPEExtraFilesSE
}
function Get-TaskWinPEScriptsPE {
    #===================================================================================================
    #   WinPE PowerShell Scripts
    #===================================================================================================
    [CmdletBinding()]
    PARAM ()
    $WinPEScriptsPE = Get-ChildItem -Path ("$OSDBuilderContent\Scripts","$OSDBuilderContent\WinPE\Scripts") *.ps1 -ErrorAction SilentlyContinue | Select-Object -Property Name, FullName, Length, CreationTime | Sort-Object -Property FullName
    foreach ($TaskScript in $WinPEScriptsPE) {$TaskScript.FullName = $($TaskScript.FullName).replace("$OSDBuilderContent\",'')}
    if ($null -eq $WinPEScriptsPE) {Write-Warning "WinPE PowerShell Scripts: To select PowerShell Scripts add Content to $OSDBuilderContent\Scripts"}
    else {
        if ($ExistingTask.WinPEScriptsPE) {
            foreach ($Item in $ExistingTask.WinPEScriptsPE) {
                $WinPEScriptsPE = $WinPEScriptsPE | Where-Object {$_.FullName -ne $Item}
            }
        }
        $WinPEScriptsPE = $WinPEScriptsPE | Out-GridView -Title "WinPE PowerShell Scripts: Select PowerShell Scripts to execute and press OK (Esc or Cancel to Skip)" -PassThru
    }
    foreach ($Item in $WinPEScriptsPE) {Write-Host "$($Item.FullName)" -ForegroundColor White}
    Return $WinPEScriptsPE
}
function Get-TaskWinPEScriptsRE {
    #===================================================================================================
    #   WinRE PowerShell Scripts
    #===================================================================================================
    [CmdletBinding()]
    PARAM ()
    $WinPEScriptsRE = Get-ChildItem -Path ("$OSDBuilderContent\Scripts","$OSDBuilderContent\WinPE\Scripts") *.ps1 -ErrorAction SilentlyContinue | Select-Object -Property Name, FullName, Length, CreationTime | Sort-Object -Property FullName
    foreach ($TaskScript in $WinPEScriptsRE) {$TaskScript.FullName = $($TaskScript.FullName).replace("$OSDBuilderContent\",'')}
    if ($null -eq $WinPEScriptsRE) {Write-Warning "WinRE PowerShell Scripts: To select PowerShell Scripts add Content to $OSDBuilderContent\Scripts"}
    else {
        if ($ExistingTask.WinPEScriptsRE) {
            foreach ($Item in $ExistingTask.WinPEScriptsRE) {
                $WinPEScriptsRE = $WinPEScriptsRE | Where-Object {$_.FullName -ne $Item}
            }
        }
        $WinPEScriptsRE = $WinPEScriptsRE | Out-GridView -Title "WinRE PowerShell Scripts: Select PowerShell Scripts to execute and press OK (Esc or Cancel to Skip)" -PassThru
    }
    foreach ($Item in $WinPEScriptsRE) {Write-Host "$($Item.FullName)" -ForegroundColor White}
    Return $WinPEScriptsRE
}
function Get-TaskWinPEScriptsSE {
    #===================================================================================================
    #   WinSE PowerShell Scripts
    #===================================================================================================
    [CmdletBinding()]
    PARAM ()
    $WinPEScriptsSE = Get-ChildItem -Path ("$OSDBuilderContent\Scripts","$OSDBuilderContent\WinPE\Scripts") *.ps1 -ErrorAction SilentlyContinue | Select-Object -Property Name, FullName, Length, CreationTime | Sort-Object -Property FullName
    foreach ($TaskScript in $WinPEScriptsSE) {$TaskScript.FullName = $($TaskScript.FullName).replace("$OSDBuilderContent\",'')}
    if ($null -eq $WinPEScriptsSE) {Write-Warning "WinSE PowerShell Scripts: To select PowerShell Scripts add Content to $OSDBuilderContent\Scripts"}
    else {
        if ($ExistingTask.WinPEScriptsSE) {
            foreach ($Item in $ExistingTask.WinPEScriptsSE) {
                $WinPEScriptsSE = $WinPEScriptsSE | Where-Object {$_.FullName -ne $Item}
            }
        }
        $WinPEScriptsSE = $WinPEScriptsSE | Out-GridView -Title "WinSE PowerShell Scripts: Select PowerShell Scripts to execute and press OK (Esc or Cancel to Skip)" -PassThru
    }
    foreach ($Item in $WinPEScriptsSE) {Write-Host "$($Item.FullName)" -ForegroundColor White}
    Return $WinPEScriptsSE
}
