function Use-OSBuildDrivers {
    #===================================================================================================
    #   Use-OSBuildDrivers
    #===================================================================================================
    [CmdletBinding()]
    PARAM ()
    Write-Host '========================================================================================' -ForegroundColor DarkGray
    Write-Host "Install.wim: Task Drivers"	-ForegroundColor Green
    if ($Drivers) {
        foreach ($Driver in $Drivers) {
            Write-Host "$OSDBuilderContent\$Driver" -ForegroundColor DarkGray
            if ($OSMajorVersion -eq 6) {
                dism /Image:"$MountDirectory" /Add-Driver /Driver:"$OSDBuilderContent\$Driver" /Recurse /ForceUnsigned /LogPath:"$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-DISM-Task-Driver.log"
            } else {
                Add-WindowsDriver -Driver "$OSDBuilderContent\$Driver" -Recurse -Path "$MountDirectory" -ForceUnsigned -LogPath "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Task-Driver.log" | Out-Null
            }
        }
    } else {
        Write-Host "No Task Drivers were processed" -ForegroundColor DarkGray
    }
    
    Write-Host '========================================================================================' -ForegroundColor DarkGray
    Write-Host "Install.wim: Template Drivers"	-ForegroundColor Green
    if ($DriverTemplates) {
        foreach ($Driver in $DriverTemplates) {
            Write-Host "$($Driver.FullName)" -ForegroundColor DarkGray
            if ($OSMajorVersion -eq 6) {
                dism /Image:"$MountDirectory" /Add-Driver /Driver:"$($Driver.FullName)" /Recurse /ForceUnsigned /LogPath:"$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-DISM-Template-Driver.log"
            } else {
                Add-WindowsDriver -Driver "$($Driver.FullName)" -Recurse -Path "$MountDirectory" -ForceUnsigned -LogPath "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Template-Driver.log" | Out-Null
            }
        }
    } else {
        Write-Host "No Template Drivers were processed" -ForegroundColor DarkGray
    }
}

function Use-OSBuildDriversWinPE {
    #===================================================================================================
    #   Use-OSBuildDriversWinPE
    #===================================================================================================
    [CmdletBinding()]
    PARAM ()
    Write-Host '========================================================================================' -ForegroundColor DarkGray
    Write-Host "WinPE: Task WinPE Drivers" -ForegroundColor Green
    if ($WinPEDrivers) {
        foreach ($WinPEDriver in $WinPEDrivers) {
            Write-Host "$OSDBuilderContent\$WinPEDriver" -ForegroundColor DarkGray
            if ($OSMajorVersion -eq 6) {
                dism /Image:"$MountWinPE" /Add-Driver /Driver:"$OSDBuilderContent\$WinPEDriver" /Recurse /ForceUnsigned /LogPath:"$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-DISM-Add-Driver-WinPE.log"
                dism /Image:"$MountWinRE" /Add-Driver /Driver:"$OSDBuilderContent\$WinPEDriver" /Recurse /ForceUnsigned /LogPath:"$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-DISM-Add-Driver-WinRE.log"
                dism /Image:"$MountWinSE" /Add-Driver /Driver:"$OSDBuilderContent\$WinPEDriver" /Recurse /ForceUnsigned /LogPath:"$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-DISM-Add-Driver-WinSE.log"
            } else {
                Add-WindowsDriver -Path "$MountWinPE" -Driver "$OSDBuilderContent\$WinPEDriver" -Recurse -ForceUnsigned -LogPath "$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Add-WindowsDriver-WinPE.log" | Out-Null
                Add-WindowsDriver -Path "$MountWinRE" -Driver "$OSDBuilderContent\$WinPEDriver" -Recurse -ForceUnsigned -LogPath "$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Add-WindowsDriver-WinRE.log" | Out-Null
                Add-WindowsDriver -Path "$MountWinSE" -Driver "$OSDBuilderContent\$WinPEDriver" -Recurse -ForceUnsigned -LogPath "$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Add-WindowsDriver-WinSE.log" | Out-Null
            }
        }
    } else {
        Write-Host "No Task WinPE Drivers were processed" -ForegroundColor DarkGray
    }
}