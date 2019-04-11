function Get-TaskWinPEADK {
    #===================================================================================================
    #   WinPE ADK
    #===================================================================================================
    [CmdletBinding()]
    PARAM ()
    $WinPEADK = Get-ChildItem -Path ("$OSDBuilderContent\WinPE\ADK\*","$OSDBuilderContent\ADK\*\Windows Preinstallation Environment\*\WinPE_OCs") *.cab -Recurse -ErrorAction SilentlyContinue | Select-Object -Property Name, FullName
    foreach ($Pack in $WinPEADK) {$Pack.FullName = $($Pack.FullName).replace("$OSDBuilderContent\",'')}
    $WinPEADK = $WinPEADK | Where-Object {$_.FullName -like "*$($OSMedia.ReleaseId)*"}

    if ($OSMedia.Arch -eq 'x86') {$WinPEADK = $WinPEADK | Where-Object {$_.FullName -like "*x86*"}
    } else {$WinPEADK = $WinPEADK | Where-Object {($_.FullName -like "*x64*") -or ($_.FullName -like "*amd64*")}}

    $WinPEADKIE = @()
    $WinPEADKIE = $ContentIsoExtractWinPE | Select-Object -Property Name, FullName
    [array]$WinPEADK = [array]$WinPEADK + [array]$WinPEADKIE

    if ($null -eq $WinPEADK) {Write-Warning "WinPE.wim ADK Packages: Add Content to $OSDBuilderContent\ADK"}
    else {
        if ($ExistingTask.WinPEADK) {
            foreach ($Item in $ExistingTask.WinPEADK) {
                $WinPEADK = $WinPEADK | Where-Object {$_.FullName -ne $Item}
            }
        }
        $WinPEADK = $WinPEADK | Out-GridView -Title "WinPE.wim ADK Packages: Select ADK Packages to apply and press OK (Esc or Cancel to Skip)" -PassThru
    }
    foreach ($Item in $WinPEADK) {Write-Host "$($Item.FullName)" -ForegroundColor White}
    Return $WinPEADK
}
function Get-TaskWinPEExtraFiles {
    #===================================================================================================
    #   WinPEExtraFiles
    #===================================================================================================
    [CmdletBinding()]
    PARAM ()
    $WinPEExtraFiles = Get-ChildItem -Path ("$OSDBuilderContent\ExtraFiles","$OSDBuilderContent\WinPE\ExtraFiles") -Directory -ErrorAction SilentlyContinue | Select-Object -Property Name, FullName
    $WinPEExtraFiles = $WinPEExtraFiles | Where-Object {(Get-ChildItem $_.FullName | Measure-Object).Count -gt 0}
    foreach ($Pack in $WinPEExtraFiles) {$Pack.FullName = $($Pack.FullName).replace("$OSDBuilderContent\",'')}
    if ($null -eq $WinPEExtraFiles) {Write-Warning "WinPEExtraFiles: To select WinPE Extra Files, add Content to $OSDBuilderContent\ExtraFiles"}
    else {
        if ($ExistingTask.WinPEExtraFiles) {
            foreach ($Item in $ExistingTask.WinPEExtraFiles) {
                $WinPEExtraFiles = $WinPEExtraFiles | Where-Object {$_.FullName -ne $Item}
            }
        }
        $WinPEExtraFiles = $WinPEExtraFiles | Out-GridView -Title "WinPEExtraFiles: Select directories to inject and press OK (Esc or Cancel to Skip)" -PassThru
    }
    foreach ($Item in $WinPEExtraFiles) {Write-Host "$($Item.FullName)" -ForegroundColor White}
    Return $WinPEExtraFiles
}
function Get-TaskWinPEScripts {
    #===================================================================================================
    #   WinPE PowerShell Scripts
    #===================================================================================================
    [CmdletBinding()]
    PARAM ()
    $WinPEScripts = Get-ChildItem -Path ("$OSDBuilderContent\Scripts","$OSDBuilderContent\WinPE\Scripts") *.ps1 -ErrorAction SilentlyContinue | Select-Object -Property Name, FullName, Length, CreationTime | Sort-Object -Property FullName
    foreach ($TaskScript in $WinPEScripts) {$TaskScript.FullName = $($TaskScript.FullName).replace("$OSDBuilderContent\",'')}
    if ($null -eq $WinPEScripts) {Write-Warning "WinPE PowerShell Scripts: To select PowerShell Scripts add Content to $OSDBuilderContent\Scripts"}
    else {
        if ($ExistingTask.WinPEScripts) {
            foreach ($Item in $ExistingTask.WinPEScripts) {
                $WinPEScripts = $WinPEScripts | Where-Object {$_.FullName -ne $Item}
            }
        }
        $WinPEScripts = $WinPEScripts | Out-GridView -Title "WinPE PowerShell Scripts: Select PowerShell Scripts to execute and press OK (Esc or Cancel to Skip)" -PassThru
    }
    foreach ($Item in $WinPEScripts) {Write-Host "$($Item.FullName)" -ForegroundColor White}
    Return $WinPEScripts
}