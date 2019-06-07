function Add-OSDADKWinPE {
    [CmdletBinding()]
    PARAM ()
    #===================================================================================================
    #   Header
    #===================================================================================================
    Get-OSDStartTime
    Write-Host -ForegroundColor Green "WinPE: WinPE.wim ADK Optional Components"
    #===================================================================================================
    #   Execute
    #===================================================================================================
    if ([string]::IsNullOrEmpty($WinPEADKPE) -or [string]::IsNullOrWhiteSpace($WinPEADKPE)) {
        # Do Nothing
    } else {
        $WinPEADKPE = $WinPEADKPE | Sort-Object Length
        foreach ($PackagePath in $WinPEADKPE) {
            if ($PackagePath -like "*WinPE-NetFx*") {
                Write-Host "$OSDBuilderContent\$PackagePath" -ForegroundColor Gray
                Add-WindowsPackage -PackagePath "$OSDBuilderContent\$PackagePath" -Path "$MountWinPE" -LogPath "$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Add-WindowsPackage-WinPE.log" | Out-Null
            }
        }
        $WinPEADKPE = $WinPEADKPE | Where-Object {$_.Name -notlike "*WinPE-NetFx*"}
        foreach ($PackagePath in $WinPEADKPE) {
            if ($PackagePath -like "*WinPE-PowerShell*") {
                Write-Host "$OSDBuilderContent\$PackagePath" -ForegroundColor Gray
                Add-WindowsPackage -PackagePath "$OSDBuilderContent\$PackagePath" -Path "$MountWinPE" -LogPath "$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Add-WindowsPackage-WinPE.log" | Out-Null
            }
        }
        $WinPEADKPE = $WinPEADKPE | Where-Object {$_.Name -notlike "*WinPE-PowerShell*"}
        foreach ($PackagePath in $WinPEADKPE) {
            Write-Host "$OSDBuilderContent\$PackagePath" -ForegroundColor Gray
            if ($OSMajorVersion -eq 6) {
                dism /Image:"$MountWinPE" /Add-Package /PackagePath:"$OSDBuilderContent\$PackagePath" /LogPath:"$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-DISM-Add-WindowsPackage-WinPE.log"
            } else {
                Add-WindowsPackage -PackagePath "$OSDBuilderContent\$PackagePath" -Path "$MountWinPE" -LogPath "$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Add-WindowsPackage-WinPE.log" | Out-Null
            }
        }
    }
}
function Add-OSDADKWinRE {
    [CmdletBinding()]
    PARAM ()
    #===================================================================================================
    #   Header
    #===================================================================================================
    Get-OSDStartTime
    Write-Host -ForegroundColor Green "WinPE: WinPE.wim ADK Optional Components"
    #===================================================================================================
    #   Execute
    #===================================================================================================
    $StartTime = Get-Date
    Write-Host "[$(($StartTime).ToString('yyyy-MM-dd-HHmmss'))] WinPE: WinRE.wim ADK Optional Components" -ForegroundColor Cyan
    if ([string]::IsNullOrEmpty($WinPEADKRE) -or [string]::IsNullOrWhiteSpace($WinPEADKRE)) {
        # Do Nothing
    } else {
        $WinPEADKRE = $WinPEADKRE | Sort-Object Length
        foreach ($PackagePath in $WinPEADKRE) {
            if ($PackagePath -like "*WinPE-NetFx*") {
                Write-Host "$OSDBuilderContent\$PackagePath" -ForegroundColor Gray
                Add-WindowsPackage -PackagePath "$OSDBuilderContent\$PackagePath" -Path "$MountWinRE" -LogPath "$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Add-WindowsPackage-WinRE.log" | Out-Null
            }
        }
        $WinPEADKRE = $WinPEADKRE | Where-Object {$_.Name -notlike "*WinPE-NetFx*"}
        foreach ($PackagePath in $WinPEADKRE) {
            if ($PackagePath -like "*WinPE-PowerShell*") {
                Write-Host "$OSDBuilderContent\$PackagePath" -ForegroundColor Gray
                Add-WindowsPackage -PackagePath "$OSDBuilderContent\$PackagePath" -Path "$MountWinRE" -LogPath "$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Add-WindowsPackage-WinRE.log" | Out-Null
            }
        }
        $WinPEADKRE = $WinPEADKRE | Where-Object {$_.Name -notlike "*WinPE-PowerShell*"}
        foreach ($PackagePath in $WinPEADKRE) {
            Write-Host "$OSDBuilderContent\$PackagePath" -ForegroundColor Gray
            if ($OSMajorVersion -eq 6) {
                dism /Image:"$MountWinRE" /Add-Package /PackagePath:"$OSDBuilderContent\$PackagePath" /LogPath:"$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-DISM-Add-WindowsPackage-WinRE.log"
            } else {
                Add-WindowsPackage -PackagePath "$OSDBuilderContent\$PackagePath" -Path "$MountWinRE" -LogPath "$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Add-WindowsPackage-WinRE.log" | Out-Null
            }
        }
    }
}
function Add-OSDADKWinPE {
    [CmdletBinding()]
    PARAM ()
    #===================================================================================================
    #   Header
    #===================================================================================================
    Get-OSDStartTime
    Write-Host -ForegroundColor Green "WinPE: WinPE.wim ADK Optional Components"
    #===================================================================================================
    #   Execute
    #===================================================================================================
    if ([string]::IsNullOrEmpty($WinPEADKSE) -or [string]::IsNullOrWhiteSpace($WinPEADKSE)) {
        # Do Nothing
    } else {
        $WinPEADKSE = $WinPEADKSE | Sort-Object Length
        foreach ($PackagePath in $WinPEADKSE) {
            if ($PackagePath -like "*WinPE-NetFx*") {
                Write-Host "$OSDBuilderContent\$PackagePath" -ForegroundColor Gray
                Add-WindowsPackage -PackagePath "$OSDBuilderContent\$PackagePath" -Path "$MountWinSE" -LogPath "$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Add-WindowsPackage-WinSE.log" | Out-Null
            }
        }
        $WinPEADKSE = $WinPEADKSE | Where-Object {$_.Name -notlike "*WinPE-NetFx*"}
        foreach ($PackagePath in $WinPEADKSE) {
            if ($PackagePath -like "*WinPE-PowerShell*") {
                Write-Host "$OSDBuilderContent\$PackagePath" -ForegroundColor Gray
                Add-WindowsPackage -PackagePath "$OSDBuilderContent\$PackagePath" -Path "$MountWinSE" -LogPath "$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Add-WindowsPackage-WinSE.log" | Out-Null
            }
        }
        $WinPEADKSE = $WinPEADKSE | Where-Object {$_.Name -notlike "*WinPE-PowerShell*"}
        foreach ($PackagePath in $WinPEADKSE) {
            Write-Host "$OSDBuilderContent\$PackagePath" -ForegroundColor Gray
            if ($OSMajorVersion -eq 6) {
                dism /Image:"$MountWinSE" /Add-Package /PackagePath:"$OSDBuilderContent\$PackagePath" /LogPath:"$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-DISM-Add-WindowsPackage-WinSE.log"
            } else {
                Add-WindowsPackage -PackagePath "$OSDBuilderContent\$PackagePath" -Path "$MountWinSE" -LogPath "$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Add-WindowsPackage-WinSE.log" | Out-Null
            }
        }
    }
}
function Add-OSDFeaturesOnDemand {
    [CmdletBinding()]
    PARAM ()
    #===================================================================================================
    #   Header
    #===================================================================================================
    Get-OSDStartTime
    Write-Host -ForegroundColor Green "Install.wim: Features On Demand"
    #===================================================================================================
    #   Execute
    #===================================================================================================
    foreach ($FOD in $FeaturesOnDemand) {
        Write-Host $FOD -ForegroundColor DarkGray
        $CurrentLog = "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-FOD.log"
        Try {
            Add-WindowsPackage -Path "$MountDirectory" -PackagePath "$OSDBuilderContent\$FOD" -LogPath "$CurrentLog" | Out-Null
        }
        Catch {
            $ErrorMessage = $_.Exception.Message
            Write-Warning "$ErrorMessage"
        }
    }
    Update-OSCumulativeForce
    Use-DismCleanupImage
}