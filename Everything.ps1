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
function Use-ContentDriversWinPE {
    [CmdletBinding()]
    PARAM ()
    #===================================================================================================
    #   Header
    #===================================================================================================
    Get-OSDStartTime
    Write-Host -ForegroundColor Green "WinPE: Use Content Drivers"
    #===================================================================================================
    #   Execute
    #===================================================================================================
    if ($WinPEDrivers) {
        foreach ($WinPEDriver in $WinPEDrivers) {
            Write-Host "$OSDBuilderContent\$WinPEDriver" -ForegroundColor Gray
            if ($OSMajorVersion -eq 6) {
                dism /Image:"$MountWinPE" /Add-Driver /Driver:"$OSDBuilderContent\$WinPEDriver" /Recurse /ForceUnsigned /LogPath:"$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-ContentDrivers-WinPE.log"
                dism /Image:"$MountWinRE" /Add-Driver /Driver:"$OSDBuilderContent\$WinPEDriver" /Recurse /ForceUnsigned /LogPath:"$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-ContentDrivers-WinRE.log"
                dism /Image:"$MountWinSE" /Add-Driver /Driver:"$OSDBuilderContent\$WinPEDriver" /Recurse /ForceUnsigned /LogPath:"$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-ContentDrivers-WinSE.log"
            } else {
                Add-WindowsDriver -Path "$MountWinPE" -Driver "$OSDBuilderContent\$WinPEDriver" -Recurse -ForceUnsigned -LogPath "$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-ContentDrivers-WinPE.log" | Out-Null
                Add-WindowsDriver -Path "$MountWinRE" -Driver "$OSDBuilderContent\$WinPEDriver" -Recurse -ForceUnsigned -LogPath "$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-ContentDrivers-WinRE.log" | Out-Null
                Add-WindowsDriver -Path "$MountWinSE" -Driver "$OSDBuilderContent\$WinPEDriver" -Recurse -ForceUnsigned -LogPath "$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-ContentDrivers-WinSE.log" | Out-Null
            }
        }
    } else {
        Write-Host "No TASK WinPE Drivers were processed" -ForegroundColor Gray
    }
}

function Use-ContentDriversOS {
    [CmdletBinding()]
    PARAM ()
    #===================================================================================================
    #   Header
    #===================================================================================================
    Get-OSDStartTime
    Write-Host -ForegroundColor Green "Install.wim: Use Content Drivers TASK"
    #===================================================================================================
    #   Execute
    #===================================================================================================
    if ($Drivers) {
        foreach ($Driver in $Drivers) {
            Write-Host "$OSDBuilderContent\$Driver" -ForegroundColor Gray
            if ($OSMajorVersion -eq 6) {
                dism /Image:"$MountDirectory" /Add-Driver /Driver:"$OSDBuilderContent\$Driver" /Recurse /ForceUnsigned /LogPath:"$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-ContentDrivers-TASK.log"
            } else {
                Add-WindowsDriver -Driver "$OSDBuilderContent\$Driver" -Recurse -Path "$MountDirectory" -ForceUnsigned -LogPath "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-ContentDrivers-TASK.log" | Out-Null
            }
        }
    } else {
        Write-Host "No TASK Drivers were processed" -ForegroundColor Gray
    }

    #===================================================================================================
    #   Header
    #===================================================================================================
    Get-OSDStartTime
    Write-Host -ForegroundColor Green "Install.wim: Use Content Drivers TEMPLATE"
    #===================================================================================================
    #   Execute
    #===================================================================================================
    if ($DriverTemplates) {
        foreach ($Driver in $DriverTemplates) {
            Write-Host "$($Driver.FullName)" -ForegroundColor Gray
            if ($OSMajorVersion -eq 6) {
                dism /Image:"$MountDirectory" /Add-Driver /Driver:"$($Driver.FullName)" /Recurse /ForceUnsigned /LogPath:"$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-ContentDrivers-TEMPLATE.log"
            } else {
                Add-WindowsDriver -Driver "$($Driver.FullName)" -Recurse -Path "$MountDirectory" -ForceUnsigned -LogPath "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-ContentDrivers-TEMPLATE.log" | Out-Null
            }
        }
    } else {
        Write-Host "No TEMPLATE Drivers were processed" -ForegroundColor Gray
    }
}
function Use-ContentExtraFilesWinPE {
    [CmdletBinding()]
    PARAM ()
    #===================================================================================================
    #   Header
    #===================================================================================================
    Get-OSDStartTime
    Write-Host -ForegroundColor Green "WinPE: Use Content ExtraFiles"
    #===================================================================================================
    #   Execute
    #===================================================================================================
    foreach ($ExtraFile in $WinPEExtraFilesPE) {
        Write-Host "$OSDBuilderContent\$ExtraFile" -ForegroundColor Gray
        robocopy "$OSDBuilderContent\$ExtraFile" "$MountWinPE" *.* /e /ndl /xx /b /np /ts /tee /r:0 /w:0 /Log+:"$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-ContentExtraFiles-WinPE.log" | Out-Null
    }
    foreach ($ExtraFile in $WinPEExtraFilesRE) {
        Write-Host "$OSDBuilderContent\$ExtraFile" -ForegroundColor Gray
        robocopy "$OSDBuilderContent\$ExtraFile" "$MountWinRE" *.* /e /ndl /xx /b /np /ts /tee /r:0 /w:0 /Log+:"$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-ContentExtraFiles-WinRE.log" | Out-Null
    }
    foreach ($ExtraFile in $WinPEExtraFilesSE) {
        Write-Host "$OSDBuilderContent\$ExtraFile" -ForegroundColor Gray
        robocopy "$OSDBuilderContent\$ExtraFile" "$MountWinSE" *.* /e /ndl /xx /b /np /ts /tee /r:0 /w:0 /Log+:"$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-ContentExtraFiles-WinSE.log" | Out-Null
    }
}
function Use-ContentExtraFilesOS {
    [CmdletBinding()]
    PARAM ()
    #===================================================================================================
    #   Header
    #===================================================================================================
    Get-OSDStartTime
    Write-Host -ForegroundColor Green "Install.wim: Use Content Extra Files TASK"
    #===================================================================================================
    #   Execute
    #===================================================================================================
    if ($ExtraFiles) {
        foreach ($ExtraFile in $ExtraFiles) {
            Write-Host "$OSDBuilderContent\$ExtraFile" -ForegroundColor DarkGray
            robocopy "$OSDBuilderContent\$ExtraFile" "$MountDirectory" *.* /e /ndl /xx /b /np /ts /tee /r:0 /w:0 /Log+:"$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-ContentExtraFiles-TASK.log" | Out-Null
        }
    } else {
        Write-Host "No Task Extra Files were processed" -ForegroundColor DarkGray
    }

    #===================================================================================================
    #   Header
    #===================================================================================================
    Get-OSDStartTime
    Write-Host -ForegroundColor Green "Install.wim: Use Content Extra Files TEMPLATE"
    if ($ExtraFilesTemplates) {
        foreach ($ExtraFile in $ExtraFilesTemplates) {
            Write-Host "$($ExtraFile.FullName)" -ForegroundColor DarkGray
            robocopy "$($ExtraFile.FullName)" "$MountDirectory" *.* /e /ndl /xx /b /np /ts /tee /r:0 /w:0 /Log+:"$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-ContentExtraFiles-TEMPLATE.log" | Out-Null
        }
    } else {
        Write-Host "No Template Extra Files were processed" -ForegroundColor DarkGray
    }
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
function Use-ContentScriptsWinPE {
    [CmdletBinding()]
    PARAM ()
    #===================================================================================================
    #   Header
    #===================================================================================================
    Get-OSDStartTime
    Write-Host -ForegroundColor Green "WinPE: Use Content Scripts"
    #===================================================================================================
    #   Execute
    #===================================================================================================
    foreach ($PSWimScript in $WinPEScriptsPE) {
        if (Test-Path "$OSDBuilderContent\$PSWimScript") {
            Write-Host "Script: $OSDBuilderContent\$PSWimScript" -ForegroundColor Gray
            (Get-Content "$OSDBuilderContent\$PSWimScript").replace('winpe.wim.log', 'WinPE.log') | Set-Content "$OSDBuilderContent\$PSWimScript"
            Invoke-Expression "& '$OSDBuilderContent\$PSWimScript'"
        }
    }
    Write-Host "WinPE: WinRE.wim PowerShell Scripts"
    foreach ($PSWimScript in $WinPEScriptsRE) {
        if (Test-Path "$OSDBuilderContent\$PSWimScript") {
            Write-Host "Script: $OSDBuilderContent\$PSWimScript" -ForegroundColor Gray
            (Get-Content "$OSDBuilderContent\$PSWimScript").replace('winre.wim.log', 'WinRE.log') | Set-Content "$OSDBuilderContent\$PSWimScript"
            Invoke-Expression "& '$OSDBuilderContent\$PSWimScript'"
        }
    }
    Write-Host "WinPE: WinSE.wim PowerShell Scripts"
    foreach ($PSWimScript in $WinPEScriptsSE) {
        if (Test-Path "$OSDBuilderContent\$PSWimScript") {
            Write-Host "Script: $OSDBuilderContent\$PSWimScript" -ForegroundColor Gray
            (Get-Content "$OSDBuilderContent\$PSWimScript").replace('MountSetup', 'MountWinSE') | Set-Content "$OSDBuilderContent\$PSWimScript"
            (Get-Content "$OSDBuilderContent\$PSWimScript").replace('setup.wim.log', 'WinSE.log') | Set-Content "$OSDBuilderContent\$PSWimScript"
            Invoke-Expression "& '$OSDBuilderContent\$PSWimScript'"
        }
    }
}
function Use-ContentScriptsOS {
    [CmdletBinding()]
    PARAM ()
    #===================================================================================================
    #   Header
    #===================================================================================================
    Get-OSDStartTime
    Write-Host -ForegroundColor Green "Install.wim: Use Content Scripts TASK"
    #===================================================================================================
    #   Execute
    #===================================================================================================
    if ($Scripts) {
        foreach ($Script in $Scripts) {
            if (Test-Path "$OSDBuilderContent\$Script") {
                Write-Host "Script: $OSDBuilderContent\$Script"
                Invoke-Expression "& '$OSDBuilderContent\$Script'"
            }
        }
    } else {
        Write-Host "No Task Scripts were processed" -ForegroundColor Gray
    }

    #===================================================================================================
    #   Header
    #===================================================================================================
    Get-OSDStartTime
    Write-Host -ForegroundColor Green "Install.wim: Use Content Scripts TEMPLATE"
    #===================================================================================================
    #   Execute
    #===================================================================================================
    if ($ScriptTemplates) {
        foreach ($Script in $ScriptTemplates) {
            if (Test-Path "$($Script.FullName)") {
                Write-Host "Script: $($Script.FullName)"
                Invoke-Expression "& '$($Script.FullName)'"
            }
        }
    } else {
        Write-Host "No Template Scripts were processed" -ForegroundColor Gray
    }
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
function Use-ContentStartLayout {
    [CmdletBinding()]
    PARAM ()
    #===================================================================================================
    #   Abort
    #===================================================================================================
    if ($OSMajorVersion -ne 10) {Return}
    #===================================================================================================
    #   Header
    #===================================================================================================
    Get-OSDStartTime
    Write-Host -ForegroundColor Green "Install.wim: Use Content StartLayout"
    #===================================================================================================
    #   Execute
    #===================================================================================================
    Write-Host "$OSDBuilderContent\$StartLayoutXML" -ForegroundColor Gray
    Try {
        Copy-Item -Path "$OSDBuilderContent\$StartLayoutXML" -Destination "$MountDirectory\Users\Default\AppData\Local\Microsoft\Windows\Shell\LayoutModification.xml" -Recurse -Force | Out-Null
    }
    Catch {
        $ErrorMessage = $_.Exception.Message
        Write-Warning "$ErrorMessage"
    }
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
function Use-ContentUnattend {
    [CmdletBinding()]
    PARAM ()
    #===================================================================================================
    #   Abort
    #===================================================================================================
    if ($OSMajorVersion -ne 10) {Return}
    #===================================================================================================
    #   Header
    #===================================================================================================
    Get-OSDStartTime
    Write-Host -ForegroundColor Green "Install.wim: Use Content Unattend"
    #===================================================================================================
    #   Execute
    #===================================================================================================
    Write-Host "$OSDBuilderContent\$UnattendXML" -ForegroundColor DarkGray
    if (!(Test-Path "$MountDirectory\Windows\Panther")) {New-Item -Path "$MountDirectory\Windows\Panther" -ItemType Directory -Force | Out-Null}
    Copy-Item -Path "$OSDBuilderContent\$UnattendXML" -Destination "$MountDirectory\Windows\Panther\Unattend.xml" -Force
    Try {Use-WindowsUnattend -UnattendPath "$OSDBuilderContent\$UnattendXML" -Path "$MountDirectory" -LogPath "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-ContentUnattend.log" | Out-Null}
    Catch {
        $ErrorMessage = $_.Exception.Message
        Write-Warning "$ErrorMessage"
    }
}
function Get-OSDUpdates {
    $AllOSDUpdates = @()
    $CatalogsXmls = @()
    $CatalogsXmls = Get-ChildItem "$($MyInvocation.MyCommand.Module.ModuleBase)\Catalogs\*" -Include *.xml
    foreach ($CatalogsXml in $CatalogsXmls) {
        $AllOSDUpdates += Import-Clixml -Path "$($CatalogsXml.FullName)"
    }
    #===================================================================================================
    #   Standard Filters
    #===================================================================================================
    $AllOSDUpdates = $AllOSDUpdates | Where-Object {$_.FileName -notlike "*.exe"}
    $AllOSDUpdates = $AllOSDUpdates | Where-Object {$_.FileName -notlike "*.psf"}
    $AllOSDUpdates = $AllOSDUpdates | Where-Object {$_.FileName -notlike "*.txt"}
    $AllOSDUpdates = $AllOSDUpdates | Where-Object {$_.FileName -notlike "*delta.exe"}
    $AllOSDUpdates = $AllOSDUpdates | Where-Object {$_.FileName -notlike "*express.cab"}
    $AllOSDUpdates = $AllOSDUpdates | Where-Object {$_.Title -notlike "* Next *"}
    #===================================================================================================
    #   Get Downloaded Updates
    #===================================================================================================
    foreach ($Update in $AllOSDUpdates) {
        $FullUpdatePath = "$OSDBuilderPath\Content\OSDUpdate\$($Update.Catalog)\$($Update.Title)\$($Update.FileName)"
        if (Test-Path $FullUpdatePath) {
            $Update.OSDStatus = "Downloaded"
        }
    }
    #===================================================================================================
    #   Return
    #===================================================================================================
    $AllOSDUpdates = $AllOSDUpdates | Select-Object -Property *
    Return $AllOSDUpdates
}

function Get-OSDUpdateDownloads {
    [CmdletBinding()]
    PARAM (
        [string]$OSDGuid,
        [string]$UpdateTitle
    )
    #===================================================================================================
    #   Filtering
    #===================================================================================================
    if ($OSDGuid) {
        $OSDUpdateDownload = Get-OSDUpdates | Where-Object {$_.OSDGuid -eq $OSDGuid}
    } elseif ($UpdateTitle) {
        $OSDUpdateDownload = Get-OSDUpdates | Where-Object {$_.UpdateTitle -eq $UpdateTitle}
    } else {
        Break
    }
    #===================================================================================================
    #   Download
    #===================================================================================================
    foreach ($Update in $OSDUpdateDownload) {
        $DownloadPath = "$OSDBuilderPath\Content\OSDUpdate\$($Update.Catalog)\$($Update.Title)"
        $DownloadFullPath = "$DownloadPath\$($Update.FileName)"
        if (!(Test-Path $DownloadPath)) {New-Item -Path "$DownloadPath" -ItemType Directory -Force | Out-Null}
        if (!(Test-Path $DownloadFullPath)) {
            Write-Host "$DownloadFullPath"
            Write-Host "$($Update.OriginUri)" -ForegroundColor Gray
            $WebClient = New-Object System.Net.WebClient
            $WebClient.DownloadFile("$($Update.OriginUri)","$DownloadFullPath")
            #Start-BitsTransfer -Source $Update.OriginUri -Destination $DownloadFullPath
        }
    }
}

function Get-MediaESDDownloads {
    $MediaESDDownloads = @()
    $CatalogsXmls = @()
    $CatalogsXmls = Get-ChildItem "$($MyInvocation.MyCommand.Module.ModuleBase)\CatalogsESD\*" -Include *.xml
    foreach ($CatalogsXml in $CatalogsXmls) {
        $MediaESDDownloads += Import-Clixml -Path "$($CatalogsXml.FullName)"
    }
    #===================================================================================================
    #   Get Downloadeds
    #===================================================================================================
    foreach ($Download in $MediaESDDownloads) {
        $FullUpdatePath = "$OSDBuilderPath\MediaESD\$($Update.FileName)"
        if (Test-Path $FullUpdatePath) {
            $Download.OSDStatus = "Downloaded"
        }
    }
    #===================================================================================================
    #   Return
    #===================================================================================================
    $MediaESDDownloads = $MediaESDDownloads | Select-Object -Property *
    Return $MediaESDDownloads
}
function Get-OSBuildTask {
    [CmdletBinding()]
    PARAM (
        [switch]$GridView
    )

    BEGIN {
        #Write-Host '========================================================================================' -ForegroundColor DarkGray
        #Write-Host "$($MyInvocation.MyCommand.Name) BEGIN"

        #===================================================================================================
        Write-Verbose '19.1.1 Initialize OSDBuilder'
        #===================================================================================================
        Get-OSDBuilder -CreatePaths -HideDetails

        #===================================================================================================
        Write-Verbose '19.1.1 Gather All OSBuildTask'
        #===================================================================================================
        $AllOSBuildTasks = @()
        $AllOSBuildTasks = Get-ChildItem -Path "$OSDBuilderTasks" OSBuild*.json -File | Select-Object -Property *
    }

    PROCESS {
        #Write-Host '========================================================================================' -ForegroundColor DarkGray
        #Write-Host "$($MyInvocation.MyCommand.Name) PROCESS"

        $OSBuildTask = foreach ($Item in $AllOSBuildTasks) {
            #===================================================================================================
            #Write-Verbose '19.1.1 Get Windows Image Information'
            #===================================================================================================
            $OSBuildTaskPath = $($Item.FullName)
            Write-Verbose "OSBuildTask Full Path: $OSBuildTaskPath"
            $OSBTask = @()
            $OSBTask = Get-Content "$($Item.FullName)" | ConvertFrom-Json

            $OSBTaskProps = @()
            $OSBTaskProps = Get-Item "$($Item.FullName)" | Select-Object -Property *
            
            if ([System.Version]$OSBTask.TaskVersion -lt [System.Version]"19.1.3.0") {
                $ObjectProperties = @{
                    LastWriteTime       = $OSBTaskProps.LastWriteTime
                    TaskName            = $OSBTask.TaskName
                    TaskVersion         = $OSBTask.TaskVersion
                    OSMediaName         = $OSBTask.MediaName
                    FullName            = $Item.FullName
                }
                New-Object -TypeName PSObject -Property $ObjectProperties
                Write-Verbose ""
            }

            if ([System.Version]$OSBTask.TaskVersion -gt [System.Version]"19.1.3.0") {

                if ($null -eq $OSBTask.Languages) {
                    Write-Warning "Reading Task: $OSBuildTaskPath"
                    Write-Warning "Searching for OSMFamily: $($OSBTask.OSMFamily)"
                    $LangUpdate = Get-OSMedia | Where-Object {$_.OSMFamilyV1 -eq $OSBTask.OSMFamily} | Select-Object -Last 1
                    Write-Warning "Adding Language: $($LangUpdate.Languages)"
                    $OSBTask | Add-Member -Type NoteProperty -Name 'Languages' -Value "$LangUpdate.Languages"
                    $OSBTask.Languages = $LangUpdate.Languages
                    $OSBTask.OSMFamily = $OSBTask.InstallationType + " " + $OSBTask.EditionId + " " + $OSBTask.Arch + " " + [string]$OSBTask.Build + " " + $OSBTask.Languages
                    Write-Warning "Updating OSMFamily: $($OSBTask.OSMFamily)"
                    Write-Warning "Updating Task: $OSBuildTaskPath"
                    $OSBTask | ConvertTo-Json | Out-File $OSBuildTaskPath
                    Write-Host ""
                }

                $ObjectProperties = @{
                    TaskType            = $OSBTask.TaskType
                    TaskVersion         = $OSBTask.TaskVersion
                    TaskName            = $OSBTask.TaskName
                    TaskGuid            = $OSBTask.TaskGuid
                    CustomName          = $OSBTask.CustomName
                    SourceOSMedia       = $OSBTask.Name
                    ImageName           = $OSBTask.ImageName
                    Arch                = $OSBTask.Arch
                    ReleaseId           = $OSBTask.ReleaseId
                    UBR                 = $OSBTask.UBR
                    Languages           = $OSBTask.Languages
                    EditionId           = $OSBTask.EditionId
                    FullName            = $Item.FullName
                    LastWriteTime       = $OSBTaskProps.LastWriteTime
                    CreatedTime         = [datetime]$OSBTask.CreatedTime
                    ModifiedTime        = [datetime]$OSBTask.ModifiedTime
                    OSMFamily           = $OSBTask.OSMFamily
                    OSMGuid             = $OSBTask.OSMGuid
                }
                New-Object -TypeName PSObject -Property $ObjectProperties
                Write-Verbose ""
            }
        }

        #===================================================================================================
        #Write-Verbose '19.1.3 Output'
        #===================================================================================================
        if ($GridView.IsPresent) {$OSBuildTask | Select-Object TaskType,TaskVersion,TaskName,CustomName,SourceOSMedia,ImageName,Arch,ReleaseId,UBR,Languages,EditionId,FullName,LastWriteTime,OSMFamily,OSMGuid | Sort-Object TaskName | Out-GridView -PassThru -Title 'OSBuildTask'}
        else {$OSBuildTask | Select-Object TaskType,TaskVersion,TaskName,CustomName,SourceOSMedia,ImageName,Arch,ReleaseId,UBR,Languages,EditionId,FullName,LastWriteTime,OSMFamily,OSMGuid | Sort-Object TaskName }
    }

    END {
        #Write-Host '========================================================================================' -ForegroundColor DarkGray
        #Write-Host "$($MyInvocation.MyCommand.Name) END"
    }
}
<#
.SYNOPSIS
Manage OSDBuilder Catalogs and Microsoft Updates

.DESCRIPTION
Function used by OSDBuilder to update Catalogs and to download Microsoft Updates.  Content is saved to OSDBuilder\Content\Updates

.LINK
http://osdbuilder.com/docs/functions/updates/get-osbupdate

.PARAMETER Catalog
Selects the Catalog JSON file containing the Updates

.PARAMETER Download
Executes the Download of files

.PARAMETER HideDetails
Hides all results

.PARAMETER GridView
Displays the Updates in a PowerShell GridView so Updates can be selected.

.PARAMETER RemoveSuperseded
Removes Downloaded Updated that have been Superseded

.PARAMETER ShowDownloaded
Lists Downloaded Updates

.PARAMETER UpdateCatalogs
Downloads updated Catalogs from GitHub

.EXAMPLE
Get-OSBUpdate -Catalog Cumulative -Download
Downloads all Cumulative Updates for Windows 10 and Windows Server 2016

.EXAMPLE
Get-OSBUpdate -Catalog Adobe -FilterOS 'Windows 10' -FilterOSArch 'x64' -FilterOSBuild '1803'
Lists all Adobe Security Updates for Windows 10 x64 1803

.EXAMPLE
Get-OSBUpdate -Catalog Adobe -Download -FilterOS 'Windows 10' -FilterOSArch 'x64' -FilterOSBuild '1803'
Downloads all Adobe Security Updates for Windows 10 x64 1803
#>

function Get-OSBUpdate {
    [CmdletBinding()]
    PARAM (
        #[ValidateSet('Adobe','Component','Cumulative','DotNet','Servicing','Setup','FeatureOnDemand','LanguagePack','LanguageInterfacePack','LanguageFeature','Windows 7 x64 7601','Windows 7 x86 7601','Windows Server 2012 R2 x64')]
        [ValidateSet('Adobe','Component','Cumulative','DotNet','Servicing','Setup','FeatureOnDemand','LanguagePack','LanguageInterfacePack','LanguageFeature')]
        [string]$Catalog,
        [switch]$Download,
        [string]$FilterCategory,
        [string]$FilterKBNumber,
        [string]$FilterKBTitle,
        [ValidateSet('ar-SA','bg-BG','zh-CN','zh-TW','hr-HR','cs-CZ','da-DK','nl-NL','en-US','en-GB','et-EE','fi-FI','fr-CA','fr-FR','de-DE','el-GR','he-IL','hu-HU','it-IT','ja-JP','ko-KR','lv-LV','lt-LT','nb-NO','pl-PL','pt-BR','pt-PT','ro-RO','ru-RU','sr-Latn-RS','sk-SK','sl-SI','es-MX','es-ES','sv-SE','th-TH','tr-TR','uk-UA')]
        [string]$FilterLP,
        [ValidateSet('af-ZA','am-ET','as-IN','az-Latn-AZ','be-BY','bn-BD','bn-IN','bs-Latn-BA','ca-ES','ca-ES-valencia','chr-CHER-US','cy-GB','eu-ES','fa-IR','fil-PH','ga-IE','gd-GB','gl-ES','gu-IN','ha-Latn-NG','hi-IN','hy-AM','id-ID','ig-NG','is-IS','ka-GE','kk-KZ','km-KH','kn-IN','kok-IN','ku-ARAB-IQ','ky-KG','lb-LU','lo-LA','mi-NZ','mk-MK','ml-IN','mn-MN','mr-IN','ms-MY','mt-MT','ne-NP','nn-NO','nso-ZA','or-IN','pa-Arab-PK','pa-IN','prs-AF','quc-Latn-GT','quz-PE','rw-RW','sd-Arab-PK','si-LK','sq-AL','sr-Cyrl-BA','sr-Cyrl-RS','sw-KE','ta-IN','te-IN','tg-Cyrl-TJ','ti-ET','tk-TM','tn-ZA','tt-RU','ug-CN','ur-PK','uz-Latn-UZ','vi-VN','wo-SN','xh-ZA','yo-NG','zu-ZA')]
        [string]$FilterLIP,
        [ValidateSet('Windows 10','Windows Server 2016','Windows Server 2019','Windows 7')]
        [string]$FilterOS,
        [ValidateSet('x64','x86')]
        [string]$FilterOSArch,
        [ValidateSet('1507','1511','1607','1703','1709','1803','1809')]
        [string]$FilterOSBuild,
        [switch]$HideDetails,
        #[switch]$HideOptionalUpdates,
        [switch]$GridView,
        [switch]$RemoveSuperseded,
        [switch]$ShowDownloaded,
        [switch]$UpdateCatalogs
    )

    BEGIN {
        #Write-Host '========================================================================================' -ForegroundColor DarkGray
        #Write-Host "$($MyInvocation.MyCommand.Name) BEGIN"
        Get-OSDBuilder -CreatePaths -HideDetails
    }

    PROCESS {
        #Write-Host '========================================================================================' -ForegroundColor DarkGray
        #Write-Host "$($MyInvocation.MyCommand.Name) PROCESS"
        if ($RemoveSuperseded.IsPresent) {
            Write-Warning "This OSDBuilder version has an issue with RemoveSuperseded"
            Write-Warning "RemoveSuperseded is disabled until a solution can be implemented"
        }

        $RemoveSuperseded = $false
        #===================================================================================================
        Write-Verbose '19.1.1 Reset Variables'
        #===================================================================================================
        $null = $ImportCatalog
        $CatalogDownloads = @()
        $DownloadedUpdates = @()
        $SupersededUpdates = @()
        
        #===================================================================================================
        Write-Verbose '19.1.1 Get Catalogs'
        #===================================================================================================
        if (!(Test-Path "$CatalogLocal")) {$UpdateCatalogs = $true}
        if (Test-Path "$OSDBuilderContent\Updates\Catalog.json") {
            Remove-Item "$OSDBuilderContent\Updates\Catalog.json" -Force | Out-Null
            $UpdateCatalogs = $true
        }
        if (Test-Path "$OSDBuilderContent\Updates\Catalog.xml") {
            Remove-Item "$OSDBuilderContent\Updates\Catalog.xml" -Force | Out-Null
            $UpdateCatalogs = $true
        }
        #===================================================================================================
        Write-Verbose '19.1.1 Update Catalogs'
        #===================================================================================================
        if ($UpdateCatalogs.IsPresent) {
            Write-Warning "Downloading $OSDBuilderCatalogURL"
            $statuscode = try {(Invoke-WebRequest -Uri $OSDBuilderCatalogURL -UseBasicParsing -DisableKeepAlive).StatusCode}
            catch [Net.WebException]{[int]$_.Exception.Response.StatusCode}
            if (!($statuscode -eq "200")) {
                Write-Warning "Could not connect to $OSDBuilderCatalogURL (Status Code: $statuscode) ..."
            } else {
                Invoke-WebRequest -Uri "$OSDBuilderCatalogURL" -OutFile "$CatalogLocal"
                if (Test-Path "$CatalogLocal") {
                    $CatalogJson = Get-Content -Path "$CatalogLocal" | ConvertFrom-Json
                    foreach ($item in $($CatalogJson.CatalogsDownload)) {
                        $statuscode = try {(Invoke-WebRequest -Uri $OSDBuilderCatalogURL -UseBasicParsing -DisableKeepAlive).StatusCode}
                        catch [Net.WebException]{[int]$_.Exception.Response.StatusCode}
                        if ($statuscode -eq "200") {
                            Invoke-WebRequest -Uri "$($item)" -OutFile "$OSDBuilderContent\Updates\$(Split-Path "$($item)" -Leaf)"
                        }
                    }
                }
            }
        }
        #===================================================================================================
        Write-Verbose '19.1.1 Catalog Test'
        #===================================================================================================
        if (!(Test-Path "$CatalogLocal")) {
            Write-Warning "$CatalogLocal could not be downloaded ... Exiting"
            Return
        }
        #===================================================================================================
        Write-Verbose '19.1.1 Get Update Catalogs'
        #===================================================================================================
        $CatalogsXmls = Get-ChildItem "$OSDBuilderContent\Updates\*" -Include Catalog*.xml -Recurse
        $ExistingUpdates = @(Get-ChildItem -Path "$OSDBuilderContent\Updates\*\*" -Directory)

        #Exclude contents of the Custom directory
        #$ExistingUpdates = $ExistingUpdates | Where-Object {$_.FullName -notlike "*\Custom\*"}

        foreach ($CatalogsXml in $CatalogsXmls) {
            if ($($CatalogsXml.Name) -like "*Custom*") {
                #Write-Host "Processing Custom Catalog: $($CatalogsXml.FullName)"
            }
            $ImportCatalog = Import-Clixml -Path "$($CatalogsXml.FullName)"
            $CatalogDownloads += $ImportCatalog
        }

        $CatalogDownloads = $CatalogDownloads | Sort-Object DatePosted -Descending | Select-Object -Property Group, Category, KBNumber, KBTitle, FileName, DatePosted, DateRevised, DateCreated, DateLastModified, URL
        
        if ($Catalog) {
            if (!(Test-Path "$OSDBuilderContent\Updates\$Catalog")) {New-Item "$OSDBuilderContent\Updates\$Catalog" -ItemType Directory -Force | Out-Null}
            $CatalogDownloads = $CatalogDownloads | Where-Object {$_.Name -like "*$Catalog*"}
            $ExistingUpdates = $ExistingUpdates | Where-Object {$_.Name -like "*$Catalog*"}
        }
        
        #===================================================================================================
        Write-Verbose '19.1.1 Get Downloaded and Superseded Updates'
        #===================================================================================================
        #Write-Host "Existing: $ExistingUpdates"
        foreach ($Update in $ExistingUpdates) {
            if ($CatalogDownloads.KBTitle -NotContains $Update.Name) {$SupersededUpdates += $Update.Name}
            else {$DownloadedUpdates += $Update.Name}
        }
        #===================================================================================================
        Write-Verbose '19.1.1 Show Downloaded Updates'
        #===================================================================================================
        if ($ShowDownloaded.IsPresent) {
            if ($DownloadedUpdates) {
                Write-Host "Downloaded Updates"
                $DownloadedUpdates
                Write-Host ""
            }
        }
        #===================================================================================================
        Write-Verbose '19.1.1 Show Superseded Updates'
        #===================================================================================================
        if (!($HideDetails.IsPresent)) {
            if ($SupersededUpdates) {
                Write-Host "Superseded Updates can be removed with -RemoveSuperseded"
                $SupersededUpdates
                Write-Host ""
            }
        }
        #===================================================================================================
        Write-Verbose '19.1.1 Remove Superseded Updates'
        #===================================================================================================
        if ($RemoveSuperseded.IsPresent){
            foreach ($Update in $SupersededUpdates) {
                $RemoveUpdate = Get-ChildItem -Path "$OSDBuilderContent\Updates\*\*" -Directory | Where-Object {$_.Name -eq $Update}
                Write-Warning "Removing $RemoveUpdate"
                Remove-Item -Path $RemoveUpdate -Recurse -Force
            }
            Write-Host ""
        }
        #===================================================================================================
        #Write-Verbose '19.1.1 Show Available Updates'
        #===================================================================================================
    <#     foreach ($Update in $CatalogDownloads) {
            if ($ExistingUpdates.Name -NotContains $Update.KBTitle) {
                $AvailableUpdates += $Update.KBTitle
            }
        }
        if ($AvailableUpdates) {
            Write-Host "Available Updates that have not been downloaded"
            $AvailableUpdates
            Write-Host ""
        } #>
        #===================================================================================================
        Write-Verbose '19.1.1 Filters'
        #===================================================================================================
        #if (!($Catalog.IsPresent)) {$HideOptionalUpdates = $true}
        #if ($HideOptionalUpdates) {$CatalogDownloads = $CatalogDownloads | Where-Object {$_.Category -notlike "Language*"}}
        #if ($HideOptionalUpdates) {$CatalogDownloads = $CatalogDownloads | Where-Object {$_.Category -notlike "FeatureOnDemand"}}
        if (!($Catalog -or $FilterKBTitle)) {
            $CatalogDownloads = $CatalogDownloads | Where-Object {$_.Category -notlike "Language*"}
            $CatalogDownloads = $CatalogDownloads | Where-Object {$_.Category -notlike "FeatureOnDemand"}
            Write-Warning "Language Packs, Language Interface Packs and Features on Demand are not automatically displayed"
            Write-Warning "To view these updates, use the Catalog parameter"
            Write-Host ""
        }

        if ($FilterCategory) {$CatalogDownloads = $CatalogDownloads | Where-Object {$_.Category -like "*$FilterCategory*"}}
        if ($FilterKBNumber) {$CatalogDownloads = $CatalogDownloads | Where-Object {$_.KBNumber -like "*$FilterKBNumber*"}}
        if ($FilterKBNumber) {$CatalogDownloads = $CatalogDownloads | Where-Object {$_.KBNumber -like "*$FilterKBNumber*"}}
        if ($FilterKBTitle) {$CatalogDownloads = $CatalogDownloads | Where-Object {$_.KBTitle -like "*$FilterKBTitle*"}}
        if ($FilterLP) {$CatalogDownloads = $CatalogDownloads | Where-Object {$_.KBTitle -like "*$FilterLP*"}}
        if ($FilterLIP) {$CatalogDownloads = $CatalogDownloads | Where-Object {$_.KBTitle -like "*$FilterLIP*"}}
        if ($FilterOS) {$CatalogDownloads = $CatalogDownloads | Where-Object {$_.KBTitle -like "*$FilterOS*"}}
        if ($FilterOSArch) {$CatalogDownloads = $CatalogDownloads | Where-Object {$_.KBTitle -like "*$FilterOSArch*"}}
        if ($FilterOSBuild) {$CatalogDownloads = $CatalogDownloads | Where-Object {$_.KBTitle -like "*$FilterOSBuild*"}}
        #===================================================================================================
        Write-Verbose '19.1.1 Select Updates with PowerShell ISE'
        #===================================================================================================
        if ($GridView.IsPresent) {$CatalogDownloads = $CatalogDownloads | Out-GridView -PassThru -Title 'Select Updates to Download and press OK'}
        #===================================================================================================
        Write-Verbose '19.1.1 Filtered Updates'
        #===================================================================================================
        $FilteredUpdates = @()
        foreach ($Update in $CatalogDownloads) {
            if ($ExistingUpdates.Name -NotContains $Update.KBTitle) {
                $FilteredUpdates += $Update.KBTitle
            }
        }
        if (!($HideDetails.IsPresent)) {
            if ($FilteredUpdates) {
                Write-Host "Available Filtered Updates can be downloaded with the -Download parameter"
                $FilteredUpdates
                Write-Host ""
            }
        }
        #===================================================================================================
        Write-Verbose '19.2.11 Download Updates'
        #===================================================================================================
        if ($Download.IsPresent) {
            foreach ($Update in $CatalogDownloads) {
                if ($null -eq $Update.Group) {
                    $DownloadPath = "$OSDBuilderContent\Updates\$($Update.Category)\$($Update.KBTitle)"
                } else {
                    $DownloadPath = "$OSDBuilderContent\Updates\$($Update.Group)\$($Update.KBTitle)"
                }
                $DownloadFullPath = "$DownloadPath\$($Update.FileName)"

                if (!(Test-Path $DownloadPath)) {New-Item -Path "$DownloadPath" -ItemType Directory -Force | Out-Null}
                if (!(Test-Path $DownloadFullPath)) {
                    Write-Host "$($Update.URL)" -ForegroundColor Yellow
                    $WebClient = New-Object System.Net.WebClient
                    $WebClient.DownloadFile("$($Update.URL)","$DownloadFullPath")
                    #Start-BitsTransfer -Source $($Update.URL) -Destination $DownloadFullPath
                    Write-Host "$DownloadFullPath"
                } else {
                    #Write-Warning "Exists: $($Update.KBTitle)"
                }
            }
        }
        if (!($HideDetails.IsPresent)) {
            #===================================================================================================
            Write-Verbose '19.1.1 Remove Variables'
            #===================================================================================================
            Remove-Variable Catalog
            if ($CatalogsXml) {Remove-Variable CatalogsXml}
            Remove-Variable Download
            Remove-Variable ExistingUpdates
            Remove-Variable FilterCategory
            Remove-Variable FilterKBNumber
            Remove-Variable FilterKBTitle
            Remove-Variable FilterLIP
            Remove-Variable FilterLP
            Remove-Variable FilterOS
            Remove-Variable FilterOSArch
            Remove-Variable FilterOSBuild
            Remove-Variable RemoveSuperseded
            Remove-Variable ShowDownloaded
            if ($Update) {Remove-Variable Update}
            Remove-Variable UpdateCatalogs
        }
    }

    END {
        #Write-Host '========================================================================================' -ForegroundColor DarkGray
        #Write-Host "$($MyInvocation.MyCommand.Name) END"
    }
}
function Get-PEBuildTask {
    [CmdletBinding()]
    PARAM (
        [switch]$GridView
    )

    BEGIN {
        #Write-Host '========================================================================================' -ForegroundColor DarkGray
        #Write-Host "$($MyInvocation.MyCommand.Name) BEGIN"

        #===================================================================================================
        Write-Verbose '19.1.1 Initialize OSDBuilder'
        #===================================================================================================
        Get-OSDBuilder -CreatePaths -HideDetails

        #===================================================================================================
        Write-Verbose '19.1.1 Gather All PEBuildTask'
        #===================================================================================================
        $AllPEBuildTasks = @()
        $AllPEBuildTasks = Get-ChildItem -Path "$OSDBuilderTasks" *.json -File | Select-Object -Property *
        $AllPEBuildTasks = $AllPEBuildTasks | Where-Object {$_.Name -like "MDT*" -or $_.Name -like "Recovery*" -or $_.Name -like "WinPE*"}
    }

    PROCESS {
        #Write-Host '========================================================================================' -ForegroundColor DarkGray
        #Write-Host "$($MyInvocation.MyCommand.Name) PROCESS"

        $PEBuildTask = foreach ($Item in $AllPEBuildTasks) {
            #===================================================================================================
            #Write-Verbose '19.1.1 Get Windows Image Information'
            #===================================================================================================
            $PEBuildTaskPath = $($Item.FullName)
            Write-Verbose "PEBuildTask Full Path: $PEBuildTaskPath"
            
            $PEBTask = @()
            $PEBTask = Get-Content "$($Item.FullName)" | ConvertFrom-Json

            $PEBTaskProps = @()
            $PEBTaskProps = Get-Item "$($Item.FullName)" | Select-Object -Property *
            
            if ([System.Version]$PEBTask.TaskVersion -lt [System.Version]"19.1.3.0") {
                $ObjectProperties = @{
                    LastWriteTime       = $PEBTaskProps.LastWriteTime
                    TaskName            = $PEBTask.TaskName
                    TaskVersion         = $PEBTask.TaskVersion
                    Name                = $PEBTask.MediaName
                    FullName            = $Item.FullName
                }
                New-Object -TypeName PSObject -Property $ObjectProperties
                Write-Verbose ""
            }

            if ([System.Version]$PEBTask.TaskVersion -gt [System.Version]"19.1.3.0") {

                if ($null -eq $PEBTask.Languages) {
                    Write-Warning "Reading Task: $PEBuildTaskPath"
                    Write-Warning "Searching for OSMFamily: $($PEBTask.OSMFamily)"
                    $LangUpdate = Get-OSMedia | Where-Object {$_.OSMFamilyV1 -eq $PEBTask.OSMFamily} | Select-Object -Last 1
                    Write-Warning "Adding Language: $($LangUpdate.Languages)"
                    $PEBTask | Add-Member -Type NoteProperty -Name 'Languages' -Value "$LangUpdate.Languages"
                    $PEBTask.Languages = $LangUpdate.Languages
                    $PEBTask.OSMFamily = $PEBTask.InstallationType + " " + $PEBTask.EditionId + " " + $PEBTask.Arch + " " + [string]$PEBTask.Build + " " + $PEBTask.Languages
                    Write-Warning "Updating OSMFamily: $($PEBTask.OSMFamily)"
                    Write-Warning "Updating Task: $PEBuildTaskPath"
                    $PEBTask | ConvertTo-Json | Out-File $PEBuildTaskPath
                    Write-Host ""
                }

                $ObjectProperties = @{
                    TaskType            = $PEBTask.TaskType
                    TaskVersion         = $PEBTask.TaskVersion
                    TaskName            = $PEBTask.TaskName
                    TaskGuid            = $PEBTask.TaskGuid
                    CustomName          = $PEBTask.CustomName
                    SourceOSMedia       = $PEBTask.Name
                    ImageName           = $PEBTask.ImageName
                    Arch                = $PEBTask.Arch
                    ReleaseId           = $PEBTask.ReleaseId
                    UBR                 = $PEBTask.UBR
                    EditionId           = $PEBTask.EditionId
                    FullName            = $Item.FullName
                    LastWriteTime       = $PEBTaskProps.LastWriteTime
                    CreatedTime         = [datetime]$PEBTask.CreatedTime
                    ModifiedTime        = [datetime]$PEBTask.ModifiedTime
                    OSMFamily           = $PEBTask.OSMFamily
                    OSMGuid             = $PEBTask.OSMGuid
                }
                New-Object -TypeName PSObject -Property $ObjectProperties
                Write-Verbose ""
            }
        }

        #===================================================================================================
        #Write-Verbose '19.1.3 Output'
        #===================================================================================================
        if ($GridView.IsPresent) {$PEBuildTask | Select-Object TaskType,TaskVersion,TaskName,CustomName,SourceOSMedia,ImageName,Arch,ReleaseId,UBR,EditionId,FullName,LastWriteTime,OSMFamily,OSMGuid | Sort-Object TaskName | Out-GridView -PassThru -Title 'PEBuildTask'}
        else {$PEBuildTask | Select-Object TaskType,TaskVersion,TaskName,CustomName,SourceOSMedia,ImageName,Arch,ReleaseId,UBR,EditionId,FullName,LastWriteTime,OSMFamily,OSMGuid | Sort-Object TaskName }
    }

    END {
        #Write-Host '========================================================================================' -ForegroundColor DarkGray
        #Write-Host "$($MyInvocation.MyCommand.Name) END"
    }
}
function New-OSBMedia {
    [CmdletBinding()]
    PARAM (
        [Parameter(ValueFromPipelineByPropertyName)]
        [string[]]$FullName,
        [switch]$USB
    )

    BEGIN {
        #Write-Host '========================================================================================' -ForegroundColor DarkGray
        #Write-Host "$($MyInvocation.MyCommand.Name) BEGIN"

        #===================================================================================================
        Write-Verbose '19.1.1 Initialize OSDBuilder'
        #===================================================================================================
        Get-OSDBuilder -CreatePaths -HideDetails

        #===================================================================================================
        Write-Verbose '19.2.10 Gather All OS Media'
        #===================================================================================================
        $AllOSMedia = @()
        $AllOSMedia = $(Get-OSMedia)

        
        $AllOSBuild = @()
        $AllOSBuild = $(Get-OSBuild)

        
        $AllPEBuild = @()
        $AllPEBuild = $(Get-PEBuild)

        $AllOSBMedia = @()
        $AllOSBMedia = [array]$AllOSMedia + [array]$AllOSBuild + [array]$AllPEBuild

        if (!($USB.IsPresent)) {
            #===================================================================================================
            Write-Verbose '19.1.1 Locate OSCDIMG'
            #===================================================================================================
            if (Test-Path "$OSDBuilderContent\Tools\$env:PROCESSOR_ARCHITECTURE\Oscdimg\oscdimg.exe") {
                $oscdimg = "$OSDBuilderContent\Tools\$env:PROCESSOR_ARCHITECTURE\Oscdimg\oscdimg.exe"
            } elseif (Test-Path "C:\Program Files\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\$env:PROCESSOR_ARCHITECTURE\Oscdimg\oscdimg.exe") {
                $oscdimg = "C:\Program Files\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\$env:PROCESSOR_ARCHITECTURE\Oscdimg\oscdimg.exe"
            } elseif (Test-Path "C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\$env:PROCESSOR_ARCHITECTURE\Oscdimg\oscdimg.exe") {
                $oscdimg = "C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\$env:PROCESSOR_ARCHITECTURE\Oscdimg\oscdimg.exe"
            } else {
                Write-Host '========================================================================================' -ForegroundColor DarkGray
                Write-Warning "Could not locate OSCDIMG in Windows ADK at:"
                Write-Warning "${env:ProgramFiles(x86)}\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\amd64\Oscdimg\oscdimg.exe"
                Write-Warning "You can optionally copy OSCDIMG to:"
                Write-Warning "$OSDBuilderContent\Tools\$env:PROCESSOR_ARCHITECTURE\Oscdimg\oscdimg.exe"
                Break
            }
            Write-Verbose "OSCDIMG: $oscdimg"
        }

    }

    PROCESS {
        Write-Host '========================================================================================' -ForegroundColor DarkGray
        Write-Host "$($MyInvocation.MyCommand.Name) PROCESS"

        if ($USB.IsPresent) {
            Write-Warning "USB will be formatted FAT32"
            Write-Warning "Install.wim larger than 4GB will FAIL"
        }

        #===================================================================================================
        Write-Verbose '19.1.1 Select Source OSMedia'
        #===================================================================================================
        $SelectedOSMedia = @()

        if ($FullName) {
            foreach ($Item in $FullName) {
                Write-Verbose "Checking $Item"
                $SelectedOSMedia += $AllOSBMedia | Where-Object {$_.FullName -eq $Item}
            }
        } else {
            if ($USB.IsPresent) {
                $SelectedOSMedia = $AllOSBMedia | Out-GridView -Title "OSDBuilder: Select one Source to create a USB and press OK (Cancel to Exit)" -OutputMode Single
            } else {
                $SelectedOSMedia = $AllOSBMedia | Out-GridView -Title "OSDBuilder: Select one or more Sources to create an ISO and press OK (Cancel to Exit)" -PassThru
            }
        }

        if ($USB.IsPresent) {
            #===================================================================================================
            Write-Verbose '19.1.1 Select USB Drive'
            #===================================================================================================
            $Results = Get-Disk | Where-Object {$_.Size/1GB -lt 33 -and $_.BusType -eq 'USB'} | Out-GridView -Title 'OSDBuilder: Select a USB Drive to FORMAT' -OutputMode Single | Clear-Disk -RemoveData -RemoveOEM -Confirm:$false -PassThru | New-Partition -UseMaximumSize -IsActive -AssignDriveLetter | Format-Volume -FileSystem FAT32 -NewFileSystemLabel 'OSDBuilder'

            if ($null -eq $Results) {
                Write-Warning "No USB Drive was Found or Selected"
                Return
            } else {
                #Make Bootable
                Set-Location -Path "$($SelectedOSMedia.FullName)\OS\boot"
                bootsect.exe /nt60 "$($Results.DriveLetter):"

                #Copy Files from ISO to USB
                Copy-Item -Path "$($SelectedOSMedia.FullName)\OS\*" -Destination "$($Results.DriveLetter):" -Recurse -Verbose
            }
        } else {
            #===================================================================================================
            Write-Verbose '19.1.1 Process OSMedia'
            #===================================================================================================
            foreach ($Media in $SelectedOSMedia) {
                $ISOSourceFolder = "$($Media.FullName)\OS"
                $ISODestinationFolder = "$($Media.FullName)\ISO"
                if (!(Test-Path $ISODestinationFolder)) {New-Item $ISODestinationFolder -ItemType Directory -Force | Out-Null}
                #$ISOFile = "$ISODestinationFolder\$($Media.Name).iso"

                $WindowsImage = Get-Content -Path "$($Media.FullName)\info\json\Get-WindowsImage.json"
                $WindowsImage = $WindowsImage | ConvertFrom-Json

                $OSImageDescription = $($WindowsImage.ImageName)

                $OSArchitecture = $($WindowsImage.Architecture)
                if ($OSArchitecture -eq '0') {$OSArchitecture = 'x86'}
                if ($OSArchitecture -eq '6') {$OSArchitecture = 'ia64'}
                if ($OSArchitecture -eq '9') {$OSArchitecture = 'x64'}
                if ($OSArchitecture -eq '12') {$OSArchitecture = 'x64 ARM'}

                $UBR = $($WindowsImage.UBR)

                $OSImageName = $OSImageDescription
            
                $OSImageName = $OSImageName -replace "Microsoft Windows Recovery Environment", "WinPE"
                $OSImageName = $OSImageName -replace "Windows 10", "Win10"
                $OSImageName = $OSImageName -replace "Enterprise", "Ent"
                $OSImageName = $OSImageName -replace "Education", "Edu"
                $OSImageName = $OSImageName -replace "Virtual Desktops", "VD"
                $OSImageName = $OSImageName -replace " for ", " "
                $OSImageName = $OSImageName -replace "Workstations", "Wks"
                $OSImageName = $OSImageName -replace "Windows Server 2016", "Svr2016"
                $OSImageName = $OSImageName -replace "Windows Server 2019", "Svr2019"
                $OSImageName = $OSImageName -replace "ServerStandardACore", "Std Core"
                $OSImageName = $OSImageName -replace "ServerDatacenterACore", "DC Core"
                $OSImageName = $OSImageName -replace "ServerStandardCore", "Std Core"
                $OSImageName = $OSImageName -replace "ServerDatacenterCore", "DC Core"
                $OSImageName = $OSImageName -replace "ServerStandard", "Std"
                $OSImageName = $OSImageName -replace "ServerDatacenter", "DC"
                $OSImageName = $OSImageName -replace "Standard", "Std"
                $OSImageName = $OSImageName -replace "Datacenter", "DC"
                $OSImageName = $OSImageName -replace 'Desktop Experience', 'DTE'
                $OSImageName = $OSImageName -replace '\(', ''
                $OSImageName = $OSImageName -replace '\)', ''

                if ($($Media.FullName) -like "*PEBuilds*") {
                    $OSImageName = "WinPE $OSArchitecture $UBR"
                    $ISOFile = "$ISODestinationFolder\WinPE $OSArchitecture $UBR.iso"
                } elseif ($($Media.FullName) -like "*OSMedia*") {
                    if ($OSImageName -like "*Win10*") {
                        $OSImageName = "OSMedia Win10 $OSArchitecture $UBR"
                        $ISOFile = "$ISODestinationFolder\OSMedia Win10 $OSArchitecture $UBR.iso"
                    } elseif ($OSImageName -like "*2016*") {
                        $OSImageName = "OSMedia Svr2016 $OSArchitecture $UBR"
                        $ISOFile = "$ISODestinationFolder\OSMedia Svr2016 $OSArchitecture $UBR.iso"
                    } elseif ($OSImageName -like "*2019*") {
                        $OSImageName = "OSMedia Svr2019 $OSArchitecture $UBR"
                        $ISOFile = "$ISODestinationFolder\OSMedia Svr2019 $OSArchitecture $UBR.iso"
                    } else {
                        $OSImageName = "OSMedia WinOS $OSArchitecture $UBR"
                        $ISOFile = "$ISODestinationFolder\OSMedia WinOS $OSArchitecture $UBR.iso"
                    }
                } elseif ($($Media.FullName) -like "*OSBuilds*") {
                    if ($OSImageName -like "*Win10*") {
                        $OSImageName = "OSBuild Win10 $OSArchitecture $UBR"
                        $ISOFile = "$ISODestinationFolder\OSBuild Win10 $OSArchitecture $UBR.iso"
                    } elseif ($OSImageName -like "*2016*") {
                        $OSImageName = "OSBuild Svr2016 $OSArchitecture $UBR"
                        $ISOFile = "$ISODestinationFolder\OSBuild Svr2016 $OSArchitecture $UBR.iso"
                    } elseif ($OSImageName -like "*2019*") {
                        $OSImageName = "OSBuild Svr2019 $OSArchitecture $UBR"
                        $ISOFile = "$ISODestinationFolder\OSBuild Svr2019 $OSArchitecture $UBR.iso"
                    } else {
                        $OSImageName = "OSBuild WinOS $OSArchitecture $UBR"
                        $ISOFile = "$ISODestinationFolder\OSBuild WinOS $OSArchitecture $UBR.iso"
                    }
                }

                # 32 character limit for a Label
                # 23 = Win10 Edu x64 17134.112
                # 25 = Win10 Edu N x64 17134.112
                # 23 = Win10 Ent x64 17134.112
                # 25 = Win10 Ent N x64 17134.112
                # 23 = Win10 Pro x64 17134.112
                # 27 = Win10 Pro Edu x64 17134.112
                # 29 = Win10 Pro EduN x64 17134.112
                # 27 = Win10 Pro Wks x64 17134.112
                # 26 = Win10 Pro N x64 17134.112
                # 29 = Win10 Pro N Wks x64 17134.112
                $ISOLabel = '-l"{0}"' -f $OSImageName
                $ISOFolder = "$($Media.FullName)\ISO"
                if (!(Test-Path $ISOFolder)) {New-Item -Path $ISOFolder -ItemType Directory -Force | Out-Null}

                if (!(Test-Path $ISOSourceFolder)) {
                    Write-Warning "Could not locate $ISOSourceFolder"
                    Write-Warning "Make sure you have proper OS before using New-OSBMediaISO"
                    Return
                }
                $etfsboot = "$ISOSourceFolder\boot\etfsboot.com"
                if (!(Test-Path $etfsboot)) {
                    Write-Warning "Could not locate $etfsboot"
                    Write-Warning "Make sure you have proper OS before using New-OSBMediaISO"
                    Return
                }
                $efisys = "$ISOSourceFolder\efi\microsoft\boot\efisys.bin"
                if (!(Test-Path $efisys)) {
                    Write-Warning "Could not locate $efisys"
                    Write-Warning "Make sure you have proper OS before using New-OSBMediaISO"
                    Return
                }
                Write-Host "Label: $OSImageName"
                Write-Host "Creating: $ISOFile"
                $data = '2#p0,e,b"{0}"#pEF,e,b"{1}"' -f $etfsboot, $efisys
                start-process $oscdimg -args @("-m","-o","-u2","-bootdata:$data",'-u2','-udfver102',$ISOLabel,"`"$ISOSourceFolder`"", "`"$ISOFile`"") -Wait
            }
        }
    }

    END {
        #Write-Host '========================================================================================' -ForegroundColor DarkGray
        #Write-Host "$($MyInvocation.MyCommand.Name) END"
    }
}
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
function Get-TaskContentIsoExtract {
    [CmdletBinding()]
    PARAM ()
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

    Return $ContentIsoExtract
}
function Get-TaskContentAddFeatureOnDemand {
    #===================================================================================================
    #   Install.Wim Features On Demand
    #===================================================================================================
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
    
    $AddFeatureOnDemand = [array]$FeaturesOnDemandIsoExtractDir + [array]$FeaturesOnDemandUpdatesDir

    if ($OSMedia.InstallationType -eq 'Client') {$AddFeatureOnDemand = $AddFeatureOnDemand | Where-Object {$_.FullName -notlike "*Windows Server*"}}
    if ($OSMedia.InstallationType -like "*Server*") {$AddFeatureOnDemand = $AddFeatureOnDemand | Where-Object {$_.FullName -like "*Windows Server*"}}
    if ($($OSMedia.ReleaseId)) {$AddFeatureOnDemand = $AddFeatureOnDemand | Where-Object {$_.FullName -like "*$($OSMedia.ReleaseId)*"}}

    foreach ($Pack in $AddFeatureOnDemand) {$Pack.FullName = $($Pack.FullName).replace("$OSDBuilderContent\",'')}
    if ($null -eq $AddFeatureOnDemand) {Write-Warning "Install.wim Features On Demand: Not Found"}
    else {
        if ($ExistingTask.AddFeatureOnDemand) {
            foreach ($Item in $ExistingTask.AddFeatureOnDemand) {
                $AddFeatureOnDemand = $AddFeatureOnDemand | Where-Object {$_.FullName -ne $Item}
            }
        }
        $AddFeatureOnDemand = $AddFeatureOnDemand | Sort-Object -Property FullName | Out-GridView -Title "Install.wim Features On Demand: Select Packages to apply and press OK (Esc or Cancel to Skip)" -PassThru
    }
    foreach ($Item in $AddFeatureOnDemand) {Write-Host "$($Item.FullName)" -ForegroundColor White}
    Return $AddFeatureOnDemand
}

function Get-TaskContentLanguagePack {
    [CmdletBinding()]
    PARAM ()
    $LanguageLpIsoExtractDir = @()
    $LanguageLpIsoExtractDir = $ContentIsoExtract | Where-Object {$_.FullName -notlike "*FOD*"}
    $LanguageLpIsoExtractDir = $LanguageLpIsoExtractDir | Where-Object {$_.FullName -notlike "*LanguageFeatures*"}
    $LanguageLpIsoExtractDir = $LanguageLpIsoExtractDir | Where-Object {$_.FullName -like "*\langpacks\*"}
    $LanguageLpIsoExtractDir = $LanguageLpIsoExtractDir | Where-Object {$_.Name -notlike "*Language-Interface-Pack*"}

    $LanguageLpUpdatesDir = @()
    if (Test-Path "$OSDBuilderContent\Updates\LanguagePack") {
        $LanguageLpUpdatesDir = Get-ChildItem -Path "$OSDBuilderContent\Updates\LanguagePack" *.cab -Recurse | Select-Object -Property Name, FullName
        $LanguageLpUpdatesDir = $LanguageLpUpdatesDir | Where-Object {$_.FullName -like "*$($OSMedia.Arch)*"}
    }

    $LanguageLpLegacyDir = @()
    if (Test-Path "$OSDBuilderContent\LanguagePacks") {
        $LanguageLpLegacyDir = Get-ChildItem -Path "$OSDBuilderContent\LanguagePacks" *.cab -Recurse | Select-Object -Property Name, FullName
        $LanguageLpLegacyDir = $LanguageLpLegacyDir | Where-Object {$_.FullName -like "*$($OSMedia.Arch)*"}
    }

    [array]$LanguagePack = [array]$LanguageLpIsoExtractDir + [array]$LanguageLpUpdatesDir + [array]$LanguageLpLegacyDir

    if ($OSMedia.InstallationType -eq 'Client') {$LanguagePack = $LanguagePack | Where-Object {$_.FullName -notlike "*Windows Server*"}}
    if ($OSMedia.InstallationType -like "*Server*") {$LanguagePack = $LanguagePack | Where-Object {$_.FullName -like "*Windows Server*"}}
    if ($($OSMedia.ReleaseId)) {$LanguagePack = $LanguagePack | Where-Object {$_.FullName -like "*$($OSMedia.ReleaseId)*"}}

    foreach ($Package in $LanguagePack) {$Package.FullName = $($Package.FullName).replace("$OSDBuilderContent\",'')}

    if ($null -eq $LanguagePack) {Write-Warning "Install.wim Language Packs: Not Found"}
    else {
        if ($ExistingTask.LanguagePack) {
            foreach ($Item in $ExistingTask.LanguagePack) {
                $LanguagePack = $LanguagePack | Where-Object {$_.FullName -ne $Item}
            }
        }
        $LanguagePack = $LanguagePack | Sort-Object -Property FullName | Out-GridView -Title "Install.wim Language Packs: Select Packages to apply and press OK (Esc or Cancel to Skip)" -PassThru
        if ($null -eq $LanguagePack) {Write-Warning "Install.wim Language Packs: Skipping"}
    }
    foreach ($Item in $LanguagePack) {Write-Host "$($Item.FullName)" -ForegroundColor White}
    Return $LanguagePack
}
function Get-TaskContentLanguageFeature {
    [CmdletBinding()]
    PARAM ()
    $LanguageFodIsoExtractDir = @()
    $LanguageFodIsoExtractDir = $ContentIsoExtract | Where-Object {$_.Name -like "*LanguageFeatures*"}
    if ($OSMedia.InstallationType -eq 'Client') {
        if ($($OSMedia.Arch) -eq 'x86') {$LanguageFodIsoExtractDir = $LanguageFodIsoExtractDir | Where-Object {$_.FullName -like "*x86*"}}
        if ($($OSMedia.Arch) -eq 'x64') {$LanguageFodIsoExtractDir = $LanguageFodIsoExtractDir | Where-Object {$_.FullName -like "*x64*" -or $_.FullName -like "*amd64*"}}
    }

    $LanguageFodUpdatesDir = @()
    if (Test-Path "$OSDBuilderContent\Updates\LanguageFeature") {
        $LanguageFodUpdatesDir = Get-ChildItem -Path "$OSDBuilderContent\Updates\LanguageFeature" *.cab -Recurse | Select-Object -Property Name, FullName
        foreach ($Package in $LanguageFodUpdatesDir) {$Package.FullName = $($Package.FullName).replace("$OSDBuilderContent\",'')}
        if ($($OSMedia.Arch) -eq 'x86') {$LanguageFodUpdatesDir = $LanguageFodUpdatesDir | Where-Object {$_.FullName -like "*x86*"}}
        if ($($OSMedia.Arch) -eq 'x64') {$LanguageFodUpdatesDir = $LanguageFodUpdatesDir | Where-Object {$_.FullName -like "*x64*" -or $_.FullName -like "*amd64*"}}
        if ($($OSMedia.ReleaseId)) {$LanguageFodUpdatesDir = $LanguageFodUpdatesDir | Where-Object {$_.FullName -like "*$($OSMedia.ReleaseId)*"}}
    }

    [array]$LanguageFeature = [array]$LanguageFodIsoExtractDir + [array]$LanguageFodUpdatesDir
    if ($null -eq $LanguageFeature) {Write-Warning "Install.wim Language Features On Demand: Not Found"}
    else {
        if ($ExistingTask.LanguageFeature) {
            foreach ($Item in $ExistingTask.LanguageFeature) {
                $LanguageFeature = $LanguageFeature | Where-Object {$_.FullName -ne $Item}
            }
        }
        $LanguageFeature = $LanguageFeature | Sort-Object -Property FullName | Out-GridView -Title "Install.wim Language Features On Demand: Select Packages to apply and press OK (Esc or Cancel to Skip)" -PassThru
        if($null -eq $LanguageFeature) {Write-Warning "Install.wim Language Features On Demand: Skipping"}
    }
    foreach ($Item in $LanguageFeature) {Write-Host "$($Item.FullName)" -ForegroundColor White}
    Return $LanguageFeature
}
function Get-TaskContentLanguageInterfacePack {
    [CmdletBinding()]
    PARAM ()
    $LanguageLipIsoExtractDir = @()
    $LanguageLipIsoExtractDir = $ContentIsoExtract | Where-Object {$_.Name -like "*Language-Interface-Pack*"}
    $LanguageLipIsoExtractDir = $LanguageLipIsoExtractDir | Where-Object {$_.Name -like "*$($OSMedia.Arch)*"}

    $LanguageLipUpdatesDir = @()
    if (Test-Path "$OSDBuilderContent\Updates\LanguageInterfacePack") {
        $LanguageLipUpdatesDir = Get-ChildItem -Path "$OSDBuilderContent\Updates\LanguageInterfacePack" *.cab -Recurse | Select-Object -Property Name, FullName
        foreach ($Package in $LanguageLipUpdatesDir) {$Package.FullName = $($Package.FullName).replace("$OSDBuilderContent\",'')}
        $LanguageLipUpdatesDir = $LanguageLipUpdatesDir | Where-Object {$_.FullName -like "*$($OSMedia.Arch)*"}
        if ($($OSMedia.ReleaseId)) {$LanguageLipUpdatesDir = $LanguageLipUpdatesDir | Where-Object {$_.FullName -like "*$($OSMedia.ReleaseId)*"}}
    }
    
    [array]$LanguageInterfacePack = [array]$LanguageLipIsoExtractDir + [array]$LanguageLipUpdatesDir
    if ($null -eq $LanguageInterfacePack) {Write-Warning "Install.wim Language Interface Packs: Not Found"}
    else {
        if ($ExistingTask.LanguageInterfacePack) {
            foreach ($Item in $ExistingTask.LanguageInterfacePack) {
                $LanguageInterfacePack = $LanguageInterfacePack | Where-Object {$_.FullName -ne $Item}
            }
        }
        $LanguageInterfacePack = $LanguageInterfacePack | Sort-Object -Property FullName | Out-GridView -Title "Install.wim Language Interface Packs: Select Packages to apply and press OK (Esc or Cancel to Skip)" -PassThru
        if($null -eq $LanguageInterfacePack) {Write-Warning "Install.wim Language Interface Packs: Skipping"}
    }
    foreach ($Item in $LanguageInterfacePack) {Write-Host "$($Item.FullName)" -ForegroundColor White}
    Return $LanguageInterfacePack
}

function Get-TaskContentLocalExperiencePacks {
    [CmdletBinding()]
    PARAM ()
    $LocalExperiencePacks = $ContentIsoExtract | Where-Object {$_.FullName -like "*\LocalExperiencePack\*" -and $_.Name -like "*.appx"}
    if ($OSMedia.InstallationType -eq 'Client') {$LocalExperiencePacks = $LocalExperiencePacks | Where-Object {$_.FullName -notlike "*Server*"}}
    if ($OSMedia.InstallationType -eq 'Server') {$LocalExperiencePacks = $LocalExperiencePacks | Where-Object {$_.FullName -like "*Server*"}}
    if ($OSMedia.InstallationType -eq 'Server') {$LocalExperiencePacks = $LocalExperiencePacks | Where-Object {$_.FullName -notlike "*Windows 10*"}}

    foreach ($Pack in $LocalExperiencePacks) {$Pack.FullName = $($Pack.FullName).replace("$OSDBuilderContent\",'')}
    if ($null -eq $LocalExperiencePacks) {Write-Warning "Install.wim Local Experience Packs: Not Found"}
    else {
        if ($ExistingTask.LocalExperiencePacks) {
            foreach ($Item in $ExistingTask.LocalExperiencePacks) {
                $LocalExperiencePacks = $LocalExperiencePacks | Where-Object {$_.FullName -ne $Item}
            }
        }
        $LocalExperiencePacks = $LocalExperiencePacks | Sort-Object -Property FullName | Out-GridView -Title "Install.wim Local Experience Packs: Select Capabilities to apply and press OK (Esc or Cancel to Skip)" -PassThru
        if ($null -eq $LocalExperiencePacks) {Write-Warning "Install.wim Local Experience Packs: Skipping"}
    }
    foreach ($Item in $LocalExperiencePacks) {Write-Host "$($Item.FullName)" -ForegroundColor White}
    Return $LocalExperiencePacks
}
function Get-TaskContentLanguageCopySources {
    #===================================================================================================
    #   Content Scripts
    #===================================================================================================
    [CmdletBinding()]
    PARAM ()
    $LanguageCopySources = Get-OSMedia -Revision OK
    $LanguageCopySources = $LanguageCopySources | Where-Object {$_.Arch -eq $OSMedia.Arch}
    $LanguageCopySources = $LanguageCopySources | Where-Object {$_.Build -eq $OSMedia.Build}
    $LanguageCopySources = $LanguageCopySources | Where-Object {$_.OperatingSystem -eq $OSMedia.OperatingSystem}
    $LanguageCopySources = $LanguageCopySources | Where-Object {$_.OSMFamily -ne $OSMedia.OSMFamily}

    if ($ExistingTask.LanguageCopySources) {
        foreach ($Item in $ExistingTask.LanguageCopySources) {
            $LanguageCopySources = $LanguageCopySources | Where-Object {$_.OSMFamily -ne $Item}
        }
    }
    $LanguageCopySources = $LanguageCopySources | Out-GridView -Title "SourcesLanguageCopy: Select OSMedia to copy the Language Sources and press OK (Esc or Cancel to Skip)" -PassThru

    foreach ($Item in $LanguageCopySources) {Write-Host "$($Item.OSMFamily)" -ForegroundColor White}
    Return $LanguageCopySources
}
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
function Get-OSDBuilderVersion {
    param (
        [Parameter(Position=1)]
        [switch]$HideDetails
    )
    $global:OSDBuilderVersion = $(Get-Module -Name OSDBuilder).Version
    if ($HideDetails -eq $false) {
        Write-Host "OSDBuilder $OSDBuilderVersion"
        Write-Host ""
    }
}
function Remove-OSDModuleOSBuilder {
    if (Get-Module -ListAvailable -Name OSBuilder) {
        Write-Warning "PowerShell Module OSBuilder needs to be removed before using OSDBuilder"
        Write-Warning "Use the following command:"
        Write-Warning "Uninstall-Module -Name OSBuilder -AllVersions -Force"
    }
}
function Remove-OSDModuleOSMedia {
    if (Get-Module -ListAvailable -Name OSMedia) {
        Write-Warning "PowerShell Module OSMedia needs to be removed before using OSDBuilder"
        Write-Warning "Use the following command:"
        Write-Warning "Uninstall-Module -Name OSMedia -AllVersions -Force"
    }
}
function Add-OSDLanguagePacks {
    [CmdletBinding()]
    PARAM ()
    if ($OSMajorVersion -ne 10) {Return}
    Write-Host '========================================================================================' -ForegroundColor DarkGray
    Write-Host "Install.wim: Language Packs"

    foreach ($Update in $LanguagePacks) {
        if (Test-Path "$OSDBuilderContent\$Update") {
            if ($Update -like "*.cab") {
                Write-Host "$OSDBuilderContent\$Update" -ForegroundColor DarkGray
                Add-WindowsPackage -Path "$MountDirectory" -PackagePath "$OSDBuilderContent\$Update" -LogPath "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-LanguagePack.log" | Out-Null
            } elseif ($Update -like "*.appx") {
                Write-Host "$OSDBuilderContent\$Update" -ForegroundColor DarkGray
                Add-AppxProvisionedPackage -Path "$MountDirectory" -PackagePath "$OSDBuilderContent\$Update" -LicensePath "$((Get-Item $OSDBuilderContent\$Update).Directory.FullName)\License.xml" -LogPath "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-LocalExperiencePack.log" | Out-Null
            }
        } else {
            Write-Warning "Not Found: $OSDBuilderContent\$Update"
        }
    }
}
function Add-OSDLanguageInterfacePacks {
    [CmdletBinding()]
    PARAM ()
    if ($OSMajorVersion -ne 10) {Return}
    Write-Host '========================================================================================' -ForegroundColor DarkGray
    Write-Host "Install.wim: Language Interface Packs"

    foreach ($Update in $LanguageInterfacePacks) {
        if (Test-Path "$OSDBuilderContent\$Update") {
            Write-Host "$OSDBuilderContent\$Update" -ForegroundColor DarkGray
            Add-WindowsPackage -Path "$MountDirectory" -PackagePath "$OSDBuilderContent\$Update" -LogPath "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-LanguageInterfacePack.log" | Out-Null
        } else {
            Write-Warning "Not Found: $OSDBuilderContent\$Update"
        }
    }
}
function Add-OSDLanguageLocalExperiencePacks {
    [CmdletBinding()]
    PARAM ()
    if ($OSMajorVersion -ne 10) {Return}
    Write-Host '========================================================================================' -ForegroundColor DarkGray
    Write-Host "Install.wim: Local Experience Packs"

    foreach ($Update in $LocalExperiencePacks) {
        if (Test-Path "$OSDBuilderContent\$Update") {
            Write-Host "$OSDBuilderContent\$Update" -ForegroundColor DarkGray
            Add-AppxProvisionedPackage -Path "$MountDirectory" -PackagePath "$OSDBuilderContent\$Update" -LicensePath "$((Get-Item $OSDBuilderContent\$Update).Directory.FullName)\License.xml" -LogPath "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-LocalExperiencePack.log" | Out-Null
        } else {
            Write-Warning "Not Found: $OSDBuilderContent\$Update"
        }
    }
}
function Add-OSDLanguageFeatures {
    [CmdletBinding()]
    PARAM ()
    if ($OSMajorVersion -ne 10) {Return}
    Write-Host '========================================================================================' -ForegroundColor DarkGray
    Write-Host "Install.wim: Language Features"
    
    foreach ($Update in $LanguageFeatures | Where-Object {$_ -notlike "*Speech*"}) {
        if (Test-Path "$OSDBuilderContent\$Update") {
            Write-Host "$OSDBuilderContent\$Update" -ForegroundColor DarkGray
            Add-WindowsPackage -Path "$MountDirectory" -PackagePath "$OSDBuilderContent\$Update" -LogPath "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-LanguageFeatures.log" | Out-Null
        }
    }
    foreach ($Update in $LanguageFeatures | Where-Object {$_ -like "*TextToSpeech*"}) {
        if (Test-Path "$OSDBuilderContent\$Update") {
            Write-Host "$OSDBuilderContent\$Update" -ForegroundColor DarkGray
            Add-WindowsPackage -Path "$MountDirectory" -PackagePath "$OSDBuilderContent\$Update" -LogPath "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-LanguageFeatures.log" | Out-Null
        }
    }
    foreach ($Update in $LanguageFeatures | Where-Object {$_ -like "*Speech*" -and $_ -notlike "*TextToSpeech*"}) {
        if (Test-Path "$OSDBuilderContent\$Update") {
            Write-Host "$OSDBuilderContent\$Update" -ForegroundColor DarkGray
            Add-WindowsPackage -Path "$MountDirectory" -PackagePath "$OSDBuilderContent\$Update" -LogPath "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-LanguageFeatures.log" | Out-Null
        }
    }
}
function Set-OSDLanguageSettings {
    [CmdletBinding()]
    PARAM ()
    if ($OSMajorVersion -ne 10) {Return}
    Write-Host '========================================================================================' -ForegroundColor DarkGray
    Write-Host "Install.wim: Language Settings"

    #===================================================================================================
    Write-Verbose '19.1.1 Install.wim: Generating Lang.ini'
    #===================================================================================================
    if ($SetAllIntl) {
        #Write-Host '========================================================================================' -ForegroundColor DarkGray
        Write-Host "Install.wim: SetAllIntl"
        Dism /Image:"$MountDirectory" /Set-AllIntl:"$SetAllIntl" /LogPath:"$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Dism-SetAllIntl.log" | Out-Null
    }
    if ($SetInputLocale) {
        #Write-Host '========================================================================================' -ForegroundColor DarkGray
        Write-Host "Install.wim: SetInputLocale"
        Dism /Image:"$MountDirectory" /Set-InputLocale:"$SetInputLocale" /LogPath:"$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Dism-SetInputLocale.log" | Out-Null
    }
    if ($SetSKUIntlDefaults) {
        #Write-Host '========================================================================================' -ForegroundColor DarkGray
        Write-Host "Install.wim: SetSKUIntlDefaults"
        Dism /Image:"$MountDirectory" /Set-SKUIntlDefaults:"$SetSKUIntlDefaults" /LogPath:"$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Dism-SetSKUIntlDefaults.log" | Out-Null
    }
    if ($SetSetupUILang) {
        #Write-Host '========================================================================================' -ForegroundColor DarkGray
        Write-Host "Install.wim: SetSetupUILang"
        Dism /Image:"$MountDirectory" /Set-SetupUILang:"$SetSetupUILang" /Distribution:"$OS" /LogPath:"$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Dism-SetSetupUILang.log" | Out-Null
    }
    if ($SetSysLocale) {
        #Write-Host '========================================================================================' -ForegroundColor DarkGray
        Write-Host "Install.wim: SetSysLocale"
        Dism /Image:"$MountDirectory" /Set-SysLocale:"$SetSysLocale" /LogPath:"$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Dism-SetSysLocale.log" | Out-Null
    }
    if ($SetUILang) {
        #Write-Host '========================================================================================' -ForegroundColor DarkGray
        Write-Host "Install.wim: SetUILang"
        Dism /Image:"$MountDirectory" /Set-UILang:"$SetUILang" /LogPath:"$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Dism-SetUILang.log" | Out-Null
    }
    if ($SetUILangFallback) {
        #Write-Host '========================================================================================' -ForegroundColor DarkGray
        Write-Host "Install.wim: SetUILangFallback"
        Dism /Image:"$MountDirectory" /Set-UILangFallback:"$SetUILangFallback" /LogPath:"$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Dism-SetUILangFallback.log" | Out-Null
    }
    if ($SetUserLocale) {
        #Write-Host '========================================================================================' -ForegroundColor DarkGray
        Write-Host "Install.wim: SetUserLocale"
        Dism /Image:"$MountDirectory" /Set-UserLocale:"$SetUserLocale" /LogPath:"$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Dism-SetUserLocale.log" | Out-Null
    }
    Write-Host '========================================================================================' -ForegroundColor DarkGray
    Write-Host "Install.wim: Generating Updated Lang.ini"
    Dism /Image:"$MountDirectory" /Gen-LangIni /Distribution:"$OS" /LogPath:"$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Dism-gen-langini.log" | Out-Null

    Update-WinSELangIni -OSMediaPath "$WorkingPath"
}

function Update-WinSELangIni {
    [CmdletBinding()]
    PARAM (
        [string]$OSMediaPath
    )
    Write-Host "Install.wim: Updating WinSE.wim with updated Lang.ini"
    $MountWinSELangIni = Join-Path $OSDBuilderContent\Mount "winselangini$((Get-Date).ToString('hhmmss'))"
    if (!(Test-Path "$MountWinSELangIni")) {New-Item "$MountWinSELangIni" -ItemType Directory -Force | Out-Null}

    $CurrentLog = "$OSMediaPath\WinPE\info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Mount-WinSELangIni.log"
    Mount-WindowsImage -ImagePath "$OSMediaPath\WinPE\winse.wim" -Index 1 -Path "$MountWinSELangIni" -LogPath "$CurrentLog" | Out-Null

    Copy-Item -Path "$OS\Sources\lang.ini" -Destination "$MountWinSELangIni\Sources" -Force | Out-Null

    Start-Sleep -Seconds 10
    $CurrentLog = "$OSMediaPath\WinPE\info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Dismount-WinSELangIni.log"
    try {
        Dismount-WindowsImage -Path "$MountWinSELangIni" -Save -LogPath "$CurrentLog" -ErrorAction SilentlyContinue | Out-Null
    }
    catch {
        Write-Warning "Could not dismount WinSE.wim ... Waiting 30 seconds ..."
        Start-Sleep -Seconds 30
        Dismount-WindowsImage -Path "$MountWinSELangIni" -Save -LogPath "$CurrentLog" | Out-Null
    }
    if (Test-Path "$MountWinSELangIni") {Remove-Item -Path "$MountWinSELangIni" -Force -Recurse | Out-Null}

    Write-Host "Install.wim: Updating Boot.wim Index 2 with updated Lang.ini"
    $MountBootLangIni = Join-Path $OSDBuilderContent\Mount "bootlangini$((Get-Date).ToString('hhmmss'))"
    if (!(Test-Path "$MountBootLangIni")) {New-Item "$MountBootLangIni" -ItemType Directory -Force | Out-Null}

    $CurrentLog = "$OSMediaPath\WinPE\info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Mount-BootLangIni.log"
    Mount-WindowsImage -ImagePath "$OS\Sources\boot.wim" -Index 2 -Path "$MountBootLangIni" -LogPath "$CurrentLog" | Out-Null

    Copy-Item -Path "$OS\Sources\lang.ini" -Destination "$MountBootLangIni\Sources" -Force | Out-Null

    Start-Sleep -Seconds 10
    $CurrentLog = "$OSMediaPath\WinPE\info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Dismount-BootLangIni.log"
    try {
        Dismount-WindowsImage -Path "$MountBootLangIni" -Save -LogPath "$CurrentLog" -ErrorAction SilentlyContinue | Out-Null
    }
    catch {
        Write-Warning "Could not dismount Boot.wim ... Waiting 30 seconds ..."
        Start-Sleep -Seconds 30
        Dismount-WindowsImage -Path "$MountBootLangIni" -Save -LogPath "$CurrentLog" | Out-Null
    }
    if (Test-Path "$MountBootLangIni") {Remove-Item -Path "$MountBootLangIni" -Force -Recurse | Out-Null}
}


function Export-OSDInventoryOS {
    [CmdletBinding()]
    PARAM (
        [string]$OSMediaPath
    )
    #===================================================================================================
    #   Header
    #===================================================================================================
    Get-OSDStartTime
    Write-Host -ForegroundColor Green "Install.wim: Export Inventory to $OSMediaPath"
    #===================================================================================================
    #   Execute
    #===================================================================================================
    Write-Verbose 'Export-OSDInventoryOS'
    Write-Verbose "OSMediaPath: $OSMediaPath"

    $GetAppxProvisionedPackage = @()
    TRY {
        Write-Verbose "$OSMediaPath\AppxProvisionedPackage.txt"
        $GetAppxProvisionedPackage = Get-AppxProvisionedPackage -Path "$MountDirectory"
        $GetAppxProvisionedPackage | Out-File "$OSMediaPath\info\Get-AppxProvisionedPackage.txt"
        $GetAppxProvisionedPackage | Out-File "$OSMediaPath\AppxProvisionedPackage.txt"
        $GetAppxProvisionedPackage | Out-File "$OSMediaPath\info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-AppxProvisionedPackage.txt"
        $GetAppxProvisionedPackage | Export-Clixml -Path "$OSMediaPath\info\xml\Get-AppxProvisionedPackage.xml"
        $GetAppxProvisionedPackage | Export-Clixml -Path "$OSMediaPath\info\xml\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-AppxProvisionedPackage.xml"
        $GetAppxProvisionedPackage | ConvertTo-Json | Out-File "$OSMediaPath\info\json\Get-AppxProvisionedPackage.json"
        $GetAppxProvisionedPackage | ConvertTo-Json | Out-File "$OSMediaPath\info\json\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-AppxProvisionedPackage.json"
    }
    CATCH {Write-Warning "Get-AppxProvisionedPackage is not supported by this Operating System"}

    $GetWindowsOptionalFeature = @()
    TRY {
        Write-Verbose "$OSMediaPath\WindowsOptionalFeature.txt"
        $GetWindowsOptionalFeature = Get-WindowsOptionalFeature -Path "$MountDirectory"
        $GetWindowsOptionalFeature | Out-File "$OSMediaPath\info\Get-WindowsOptionalFeature.txt"
        $GetWindowsOptionalFeature | Out-File "$OSMediaPath\WindowsOptionalFeature.txt"
        $GetWindowsOptionalFeature | Out-File "$OSMediaPath\info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsOptionalFeature.txt"
        $GetWindowsOptionalFeature | Export-Clixml -Path "$OSMediaPath\info\xml\Get-WindowsOptionalFeature.xml"
        $GetWindowsOptionalFeature | Export-Clixml -Path "$OSMediaPath\info\xml\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsOptionalFeature.xml"
        $GetWindowsOptionalFeature | ConvertTo-Json | Out-File "$OSMediaPath\info\json\Get-WindowsOptionalFeature.json"
        $GetWindowsOptionalFeature | ConvertTo-Json | Out-File "$OSMediaPath\info\json\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsOptionalFeature.json"
    }
    CATCH {Write-Warning "Get-WindowsOptionalFeature is not supported by this Operating System"}

    $GetWindowsCapability = @()
    TRY {
        Write-Verbose "$OSMediaPath\WindowsCapability.txt"
        $GetWindowsCapability = Get-WindowsCapability -Path "$MountDirectory"
        $GetWindowsCapability | Out-File "$OSMediaPath\info\Get-WindowsCapability.txt"
        $GetWindowsCapability | Out-File "$OSMediaPath\WindowsCapability.txt"
        $GetWindowsCapability | Out-File "$OSMediaPath\info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsCapability.txt"
        $GetWindowsCapability | Export-Clixml -Path "$OSMediaPath\info\xml\Get-WindowsCapability.xml"
        $GetWindowsCapability | Export-Clixml -Path "$OSMediaPath\info\xml\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsCapability.xml"
        $GetWindowsCapability | ConvertTo-Json | Out-File "$OSMediaPath\info\json\Get-WindowsCapability.json"
        $GetWindowsCapability | ConvertTo-Json | Out-File "$OSMediaPath\info\json\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsCapability.json"            
    }
    CATCH {Write-Warning "Get-WindowsCapability is not supported by this Operating System"}

    $GetWindowsPackage = @()
    TRY {
        Write-Verbose "$OSMediaPath\WindowsPackage.txt"
        $GetWindowsPackage = Get-WindowsPackage -Path "$MountDirectory"
        $GetWindowsPackage | Out-File "$OSMediaPath\info\Get-WindowsPackage.txt"
        $GetWindowsPackage | Out-File "$OSMediaPath\WindowsPackage.txt"
        $GetWindowsPackage | Out-File "$OSMediaPath\info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsPackage.txt"
        $GetWindowsPackage | Export-Clixml -Path "$OSMediaPath\info\xml\Get-WindowsPackage.xml"
        $GetWindowsPackage | Export-Clixml -Path "$OSMediaPath\info\xml\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsPackage.xml"
        $GetWindowsPackage | ConvertTo-Json | Out-File "$OSMediaPath\info\json\Get-WindowsPackage.json"
        $GetWindowsPackage | ConvertTo-Json | Out-File "$OSMediaPath\info\json\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsPackage.json"
    }
    CATCH {Write-Warning "Get-WindowsPackage is not supported by this Operating System"}
}
function Export-OSDRegistryCurrentVersion {
    [CmdletBinding()]
    PARAM ()
    $RegCurrentVersion | Out-File "$Info\CurrentVersion.txt"
    $RegCurrentVersion | Out-File "$WorkingPath\CurrentVersion.txt"
    $RegCurrentVersion | Out-File "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-CurrentVersion.txt"
    $RegCurrentVersion | Export-Clixml -Path "$Info\xml\CurrentVersion.xml"
    $RegCurrentVersion | Export-Clixml -Path "$Info\xml\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-CurrentVersion.xml"
    $RegCurrentVersion | ConvertTo-Json | Out-File "$Info\json\CurrentVersion.json"
    $RegCurrentVersion | ConvertTo-Json | Out-File "$Info\json\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-CurrentVersion.json"
}
function New-ItemOSMediaDirectories {
    [CmdletBinding()]
    PARAM ()
    if (!(Test-Path "$Info"))           {New-Item "$Info" -ItemType Directory -Force | Out-Null}
    if (!(Test-Path "$Info\json"))      {New-Item "$Info\json" -ItemType Directory -Force | Out-Null}
    if (!(Test-Path "$Info\logs"))      {New-Item "$Info\logs" -ItemType Directory -Force | Out-Null}
    if (!(Test-Path "$Info\xml"))       {New-Item "$Info\xml" -ItemType Directory -Force | Out-Null}
    if (!(Test-Path "$OS"))             {New-Item "$OS" -ItemType Directory -Force | Out-Null}
    if (!(Test-Path "$WinPE"))          {New-Item "$WinPE" -ItemType Directory -Force | Out-Null}
    if (!(Test-Path "$PEInfo"))         {New-Item "$PEInfo" -ItemType Directory -Force | Out-Null}
    if (!(Test-Path "$PEInfo\json"))    {New-Item "$PEInfo\json" -ItemType Directory -Force | Out-Null}
    if (!(Test-Path "$PEInfo\logs"))    {New-Item "$PEInfo\logs" -ItemType Directory -Force | Out-Null}
    if (!(Test-Path "$PEInfo\xml"))     {New-Item "$PEInfo\xml" -ItemType Directory -Force | Out-Null}
    if (!(Test-Path "$WimTemp"))        {New-Item "$WimTemp" -ItemType Directory -Force | Out-Null}
    if (!(Test-Path "$MountDirectory")) {New-Item "$MountDirectory" -ItemType Directory -Force | Out-Null}
    if (!(Test-Path "$MountWinPE"))     {New-Item "$MountWinPE" -ItemType Directory -Force | Out-Null}
    if (!(Test-Path "$MountWinSE"))     {New-Item "$MountWinSE" -ItemType Directory -Force | Out-Null}
    if (!(Test-Path "$MountWinRE"))     {New-Item "$MountWinRE" -ItemType Directory -Force | Out-Null}
}




function Remove-AppxProvisionedPackageOSD {
    [CmdletBinding()]
    PARAM ()
    #===================================================================================================
    Write-Verbose '19.1.25 Remove Appx Packages'
    #===================================================================================================
    if ($OSMajorVersion -ne 10) {Return}

    Write-Host '========================================================================================' -ForegroundColor DarkGray
    Write-Host "Install.wim: Remove Appx Packages"
    foreach ($item in $RemoveAppx) {
        Write-Host $item -ForegroundColor DarkGray
        Try {
            Remove-AppxProvisionedPackage -Path "$MountDirectory" -PackageName $item -LogPath "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Remove-AppxProvisionedPackage.log" | Out-Null
        }
        Catch {
            $ErrorMessage = $_.Exception.Message
            Write-Warning "$ErrorMessage"
        }
    }
}

function Remove-WindowsPackageOSD {
    [CmdletBinding()]
    PARAM ()
    #===================================================================================================
    Write-Verbose '19.1.25 Remove Packages'
    #===================================================================================================

    Write-Host '========================================================================================' -ForegroundColor DarkGray
    Write-Host "Install.wim: Remove Windows Packages"
    foreach ($PackageName in $RemovePackage) {
        Write-Host $PackageName -ForegroundColor DarkGray
        Try {
            Remove-WindowsPackage -Path "$MountDirectory" -PackageName $PackageName -LogPath "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Remove-WindowsPackage.log" | Out-Null
        }
        Catch {
            $ErrorMessage = $_.Exception.Message
            Write-Warning "$ErrorMessage"
        }
    }
}

function Remove-WindowsCapabilityOSD {
    [CmdletBinding()]
    PARAM ()
    #===================================================================================================
    #   Remove Capability'
    #===================================================================================================
    Write-Host '========================================================================================' -ForegroundColor DarkGray
    Write-Host "Install.wim: Remove Windows Capability"
    foreach ($Name in $RemoveCapability) {
        Write-Host $Name -ForegroundColor DarkGray
        Try {
            Remove-WindowsCapability -Path "$MountDirectory" -Name $Name -LogPath "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Remove-WindowsCapability.log" | Out-Null
        }
        Catch {
            $ErrorMessage = $_.Exception.Message
            Write-Warning "$ErrorMessage"
        }
    }
}

function Add-OSDWindowsPackage {
    [CmdletBinding()]
    PARAM ()
    #===================================================================================================
    Write-Verbose '19.1.25 Add Packages'
    #===================================================================================================

    Write-Host '========================================================================================' -ForegroundColor DarkGray
    Write-Host "Install.wim: Add Packages"
    foreach ($PackagePath in $Packages) {
        Write-Host "$OSDBuilderContent\$PackagePath" -ForegroundColor DarkGray
        Try {
            Add-WindowsPackage -PackagePath "$OSDBuilderContent\$PackagePath" -Path "$MountDirectory" -LogPath "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Add-WindowsPackage.log" | Out-Null
        }
        Catch {
            $ErrorMessage = $_.Exception.Message
            Write-Warning "$ErrorMessage"
        }
    }
}





function Save-AutoExtraFilesOSD {
    [CmdletBinding()]
    PARAM (
        [string]$OSMediaPath
    )
    #===================================================================================================
    #   Header
    #===================================================================================================
    Get-OSDStartTime
    Write-Host -ForegroundColor Green "Install.wim: Copy Auto Extra Files to $OSMediaPath\WinPE\AutoExtraFiles"
    #===================================================================================================
    #   Execute
    #===================================================================================================
    $AEFLog = "$OSMediaPath\info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Robocopy-AutoExtraFiles.log"
    Write-Verbose "$AEFLog"

    robocopy "$MountDirectory\Windows\System32" "$OSMediaPath\WinPE\AutoExtraFiles\Windows\System32" cacls.exe* /s /xd rescache servicing /ndl /b /np /ts /tee /r:0 /w:0 /log+:"$AEFLog" | Out-Null
    robocopy "$MountDirectory\Windows\System32" "$OSMediaPath\WinPE\AutoExtraFiles\Windows\System32" choice.exe* /s /xd rescache servicing /ndl /b /np /ts /tee /r:0 /w:0 /log+:"$AEFLog" | Out-Null
    #robocopy "$MountDirectory\Windows\System32" "$OSMediaPath\WinPE\AutoExtraFiles\Windows\System32" cleanmgr.exe* /s /xd rescache servicing /ndl /b /np /ts /tee /r:0 /w:0 /log+:"$AEFLog" | Out-Null
    robocopy "$MountDirectory\Windows\System32" "$OSMediaPath\WinPE\AutoExtraFiles\Windows\System32" comp.exe*.* /s /xd rescache servicing /ndl /b /np /ts /tee /r:0 /w:0 /log+:"$AEFLog" | Out-Null
    robocopy "$MountDirectory\Windows\System32" "$OSMediaPath\WinPE\AutoExtraFiles\Windows\System32" defrag*.* /s /xd rescache servicing /ndl /b /np /ts /tee /r:0 /w:0 /log+:"$AEFLog" | Out-Null
    robocopy "$MountDirectory\Windows\System32" "$OSMediaPath\WinPE\AutoExtraFiles\Windows\System32" djoin*.* /s /xd rescache servicing /ndl /b /np /ts /tee /r:0 /w:0 /log+:"$AEFLog" | Out-Null
    robocopy "$MountDirectory\Windows\System32" "$OSMediaPath\WinPE\AutoExtraFiles\Windows\System32" forfiles*.* /s /xd rescache servicing /ndl /b /np /ts /tee /r:0 /w:0 /log+:"$AEFLog" | Out-Null
    robocopy "$MountDirectory\Windows\System32" "$OSMediaPath\WinPE\AutoExtraFiles\Windows\System32" getmac*.* /s /xd rescache servicing /ndl /b /np /ts /tee /r:0 /w:0 /log+:"$AEFLog" | Out-Null
    robocopy "$MountDirectory\Windows\System32" "$OSMediaPath\WinPE\AutoExtraFiles\Windows\System32" makecab.* /s /xd rescache servicing /ndl /b /np /ts /tee /r:0 /w:0 /log+:"$AEFLog" | Out-Null
    robocopy "$MountDirectory\Windows\System32" "$OSMediaPath\WinPE\AutoExtraFiles\Windows\System32" msinfo32.* /s /xd rescache servicing /ndl /b /np /ts /tee /r:0 /w:0 /log+:"$AEFLog" | Out-Null
    robocopy "$MountDirectory\Windows\System32" "$OSMediaPath\WinPE\AutoExtraFiles\Windows\System32" nslookup.* /s /xd rescache servicing /ndl /b /np /ts /tee /r:0 /w:0 /log+:"$AEFLog" | Out-Null
    robocopy "$MountDirectory\Windows\System32" "$OSMediaPath\WinPE\AutoExtraFiles\Windows\System32" systeminfo.* /s /xd rescache servicing /ndl /b /np /ts /tee /r:0 /w:0 /log+:"$AEFLog" | Out-Null
    robocopy "$MountDirectory\Windows\System32" "$OSMediaPath\WinPE\AutoExtraFiles\Windows\System32" tskill.* /s /xd rescache servicing /ndl /b /np /ts /tee /r:0 /w:0 /log+:"$AEFLog" | Out-Null
    robocopy "$MountDirectory\Windows\System32" "$OSMediaPath\WinPE\AutoExtraFiles\Windows\System32" winver.* /s /xd rescache servicing /ndl /b /np /ts /tee /r:0 /w:0 /log+:"$AEFLog" | Out-Null
   
    #AeroLite Theme
    robocopy "$MountDirectory\Windows\Resources" "$OSMediaPath\WinPE\AutoExtraFiles\Windows\Resources" aerolite*.* /s /ndl /b /np /ts /tee /r:0 /w:0 /log+:"$AEFLog" | Out-Null
    robocopy "$MountDirectory\Windows\Resources" "$OSMediaPath\WinPE\AutoExtraFiles\Windows\Resources" shellstyle*.* /s /ndl /b /np /ts /tee /r:0 /w:0 /log+:"$AEFLog" | Out-Null
    
    # BCP47
    robocopy "$MountDirectory\Windows\System32" "$OSMediaPath\WinPE\AutoExtraFiles\Windows\System32" bcp47*.dll /s /xd rescache servicing /ndl /b /np /ts /tee /r:0 /w:0 /log+:"$AEFLog" | Out-Null
    
    # Browse Dialog
    robocopy "$MountDirectory\Windows\Resources\Themes\aero\shell\normalcolor" "$OSMediaPath\WinPE\AutoExtraFiles\Windows\System32" shellstyle*.* /s /ndl /b /np /ts /tee /r:0 /w:0 /log+:"$AEFLog" | Out-Null
    robocopy "$MountDirectory\Windows\System32" "$OSMediaPath\WinPE\AutoExtraFiles\Windows\System32" explorerframe*.* /s /xd rescache servicing /ndl /b /np /ts /tee /r:0 /w:0 /log+:"$AEFLog" | Out-Null
    robocopy "$MountDirectory\Windows\System32" "$OSMediaPath\WinPE\AutoExtraFiles\Windows\System32" StructuredQuery*.* /s /xd rescache servicing /ndl /b /np /ts /tee /r:0 /w:0 /log+:"$AEFLog" | Out-Null
    robocopy "$MountDirectory\Windows\System32" "$OSMediaPath\WinPE\AutoExtraFiles\Windows\System32" edputil*.* /s /xd rescache servicing /ndl /b /np /ts /tee /r:0 /w:0 /log+:"$AEFLog" | Out-Null

    # Magnify
    robocopy "$MountDirectory\Windows\System32" "$OSMediaPath\WinPE\AutoExtraFiles\Windows\System32" magnify*.* /s /xd rescache servicing /ndl /b /np /ts /tee /r:0 /w:0 /log+:"$AEFLog" | Out-Null
    robocopy "$MountDirectory\Windows\System32" "$OSMediaPath\WinPE\AutoExtraFiles\Windows\System32" magnification*.* /s /xd rescache servicing /ndl /b /np /ts /tee /r:0 /w:0 /log+:"$AEFLog" | Out-Null
    
    # On Screen Keyboard
    robocopy "$MountDirectory\Windows\System32" "$OSMediaPath\WinPE\AutoExtraFiles\Windows\System32" osk*.* /s /xd rescache servicing /ndl /b /np /ts /tee /r:0 /w:0 /log+:"$AEFLog" | Out-Null
    
    # RDP
    robocopy "$MountDirectory\Windows\System32" "$OSMediaPath\WinPE\AutoExtraFiles\Windows\System32" mstsc*.* /s /xd rescache servicing /ndl /b /np /ts /tee /r:0 /w:0 /log+:"$AEFLog" | Out-Null
    robocopy "$MountDirectory\Windows\System32" "$OSMediaPath\WinPE\AutoExtraFiles\Windows\System32" pdh.dll* /s /xd rescache servicing /ndl /b /np /ts /tee /r:0 /w:0 /log+:"$AEFLog" | Out-Null
    robocopy "$MountDirectory\Windows\System32" "$OSMediaPath\WinPE\AutoExtraFiles\Windows\System32" srpapi.dll* /s /xd rescache servicing /ndl /b /np /ts /tee /r:0 /w:0 /log+:"$AEFLog" | Out-Null
    
    # Shutdown
    robocopy "$MountDirectory\Windows\System32" "$OSMediaPath\WinPE\AutoExtraFiles\Windows\System32" shutdown.* /s /xd rescache servicing /ndl /b /np /ts /tee /r:0 /w:0 /log+:"$AEFLog" | Out-Null
    robocopy "$MountDirectory\Windows\System32" "$OSMediaPath\WinPE\AutoExtraFiles\Windows\System32" shutdownext.* /s /xd rescache servicing /ndl /b /np /ts /tee /r:0 /w:0 /log+:"$AEFLog" | Out-Null
    robocopy "$MountDirectory\Windows\System32" "$OSMediaPath\WinPE\AutoExtraFiles\Windows\System32" shutdownux.* /s /xd rescache servicing /ndl /b /np /ts /tee /r:0 /w:0 /log+:"$AEFLog" | Out-Null

    # Wireless
    # http://www.scconfigmgr.com/2018/03/06/build-a-winpe-with-wireless-support/
    robocopy "$MountDirectory\Windows\System32" "$OSMediaPath\WinPE\AutoExtraFiles\Windows\System32" dmcmnutils*.* /s /xd rescache servicing /ndl /b /np /ts /tee /r:0 /w:0 /log+:"$AEFLog" | Out-Null
    robocopy "$MountDirectory\Windows\System32" "$OSMediaPath\WinPE\AutoExtraFiles\Windows\System32" mdmregistration*.* /s /xd rescache servicing /ndl /b /np /ts /tee /r:0 /w:0 /log+:"$AEFLog" | Out-Null
}
function Export-WinPEWims {
    [CmdletBinding()]
    PARAM (
        [string]$OSMediaPath
    )
    #===================================================================================================
    #   Header
    #===================================================================================================
    Get-OSDStartTime
    Write-Host -ForegroundColor Green "WinPE: Export WIMs to $OSMediaPath\WinPE"
    #===================================================================================================
    #   Execute
    #===================================================================================================
    Write-Verbose "OSMediaPath: $OSMediaPath"

    Write-Verbose "$OSMediaPath\WinPE\boot.wim"
    Copy-Item -Path "$OSMediaPath\OS\sources\boot.wim" -Destination "$OSMediaPath\WinPE\boot.wim" -Force

    Write-Verbose "$OSMediaPath\WinPE\winpe.wim"
    $CurrentLog = "$OSMediaPath\WinPE\info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Export-WindowsImage-WinPE.log"
    Write-Verbose "CurrentLog: $CurrentLog"
    Export-WindowsImage -SourceImagePath "$OSMediaPath\OS\sources\boot.wim" -SourceIndex 1 -DestinationImagePath "$OSMediaPath\WinPE\winpe.wim" -LogPath "$CurrentLog" | Out-Null

    Write-Verbose "$OSMediaPath\WinPE\winre.wim"
    $CurrentLog = "$OSMediaPath\WinPE\info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Export-WindowsImage-WinRE.log"
    Write-Verbose "CurrentLog: $CurrentLog"
    Export-WindowsImage -SourceImagePath "$MountDirectory\Windows\System32\Recovery\winre.wim" -SourceIndex 1 -DestinationImagePath "$OSMediaPath\WinPE\winre.wim" -LogPath "$CurrentLog" | Out-Null

    Write-Verbose "$OSMediaPath\WinPE\winse.wim"
    $CurrentLog = "$OSMediaPath\WinPE\info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Export-WindowsImage-WinSE.log"
    Write-Verbose "CurrentLog: $CurrentLog"
    Export-WindowsImage -SourceImagePath "$OSMediaPath\OS\sources\boot.wim" -SourceIndex 2 -DestinationImagePath "$OSMediaPath\WinPE\winse.wim" -LogPath "$CurrentLog" | Out-Null
}

function Export-OSDWindowsImagePE {
    [CmdletBinding()]
    PARAM (
        [string]$OSMediaPath
    )
    #===================================================================================================
    #   Header
    #===================================================================================================
    Get-OSDStartTime
    Write-Host -ForegroundColor Green "WinPE: Export WIMs to $OSMediaPath\WinPE"
    #===================================================================================================
    #   Execute
    #===================================================================================================
    $CurrentLog = "$OSMediaPath\WinPE\info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Export-WindowsImage-WinPE.log"
    Write-Verbose "CurrentLog: $CurrentLog"
    Export-WindowsImage -SourceImagePath "$OSMediaPath\WimTemp\winpe.wim" -SourceIndex 1 -DestinationImagePath "$OSMediaPath\WinPE\winpe.wim" -LogPath "$CurrentLog" | Out-Null
    
    $CurrentLog = "$OSMediaPath\WinPE\info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Export-WindowsImage-WinRE.log"
    Write-Verbose "CurrentLog: $CurrentLog"
    Export-WindowsImage -SourceImagePath "$OSMediaPath\WimTemp\winre.wim" -SourceIndex 1 -DestinationImagePath "$OSMediaPath\WinPE\winre.wim" -LogPath "$CurrentLog" | Out-Null

    $CurrentLog = "$OSMediaPath\WinPE\info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Export-WindowsImage-WinSE.log"
    Write-Verbose "CurrentLog: $CurrentLog"
    Export-WindowsImage -SourceImagePath "$OSMediaPath\WimTemp\winse.wim" -SourceIndex 1 -DestinationImagePath "$OSMediaPath\WinPE\winse.wim" -LogPath "$CurrentLog" | Out-Null
}

function Export-OSDWindowsImagePEBootWim {
    [CmdletBinding()]
    PARAM (
        [string]$OSMediaPath
    )
    #===================================================================================================
    #   Header
    #===================================================================================================
    Get-OSDStartTime
    Write-Host -ForegroundColor Green "WinPE: Rebuild $OSMediaPath\OS\sources\boot.wim"
    #===================================================================================================
    #   Execute
    #===================================================================================================
    $CurrentLog = "$OSMediaPath\WinPE\info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Export-WindowsImage-WinPE.log"
    Write-Verbose "CurrentLog: $CurrentLog"
    Export-WindowsImage -SourceImagePath "$OSMediaPath\WimTemp\winpe.wim" -SourceIndex 1 -DestinationImagePath "$OSMediaPath\WinPE\boot.wim" -LogPath "$CurrentLog" | Out-Null
    
    $CurrentLog = "$OSMediaPath\WinPE\info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Export-WindowsImage-WinSE.log"
    Write-Verbose "CurrentLog: $CurrentLog"
    Export-WindowsImage -SourceImagePath "$OSMediaPath\WimTemp\winse.wim" -SourceIndex 1 -DestinationImagePath "$OSMediaPath\WinPE\boot.wim" -Setbootable -LogPath "$CurrentLog" | Out-Null
    Copy-Item -Path "$OSMediaPath\WinPE\boot.wim" -Destination "$OSMediaPath\OS\sources\boot.wim" -Force | Out-Null
}
function Save-OSDWindowsImageContent {
    [CmdletBinding()]
    PARAM ()
    #===================================================================================================
    #   Header
    #===================================================================================================
    Get-OSDStartTime
    Write-Host -ForegroundColor Green "Install.wim: Export Image Content to $Info\Get-WindowsImageContent.txt"
    #===================================================================================================
    #   Execute
    #===================================================================================================
    Get-WindowsImageContent -ImagePath "$OS\Sources\install.wim" -Index 1 | Out-File "$Info\Get-WindowsImageContent.txt"
}

function Save-OSDWindowsImageContentPE {
    [CmdletBinding()]
    PARAM ()
    #===================================================================================================
    #   Header
    #===================================================================================================
    Get-OSDStartTime
    Write-Host -ForegroundColor Green "Export Image Content to $Info\Get-WindowsImageContent.txt"
    #===================================================================================================
    #   Execute
    #===================================================================================================
    Get-WindowsImageContent -ImagePath "$OS\Sources\boot.wim" -Index 1 | Out-File "$Info\Get-WindowsImageContent.txt"
}

function Save-OSDVariables {
    [CmdletBinding()]
    PARAM ()
    Get-Variable | Select-Object -Property Name, Value | Export-Clixml "$Info\xml\Variables.xml"
    Get-Variable | Select-Object -Property Name, Value | ConvertTo-Json | Out-File "$Info\json\Variables.json"
}

function Export-OSDWimOS {
    [CmdletBinding()]
    PARAM ()
    #===================================================================================================
    #   Header
    #===================================================================================================
    Get-OSDStartTime
    Write-Host -ForegroundColor Green "Install.wim: Export to $OS\sources\install.wim"
    #===================================================================================================
    #   Execute
    #===================================================================================================
    $CurrentLog = "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Export-WindowsImage.log"
    Write-Verbose "CurrentLog: $CurrentLog"
    Export-WindowsImage -SourceImagePath "$WimTemp\install.wim" -SourceIndex 1 -DestinationImagePath "$OS\sources\install.wim" -LogPath "$CurrentLog" | Out-Null
}
function Show-OSDInfoOSMedia {
    [CmdletBinding()]
    PARAM ()
    Write-Host '========================================================================================' -ForegroundColor DarkGray
    Write-Host "OSMedia Information"
    Write-Host "-OSMediaName:   $OSMediaName" -ForegroundColor Yellow
    Write-Host "-OSMediaPath:   $OSMediaPath" -ForegroundColor Yellow
    Write-Host "-OS:            $OS"
    Write-Host "-WinPE:         $WinPE"
    Write-Host "-Info:          $Info"
    Write-Host "-Logs:          $Info\logs"
}

function Show-OSDInfoWindowsImage {
    [CmdletBinding()]
    PARAM ()
    Write-Host '========================================================================================' -ForegroundColor DarkGray
    Write-Host "Windows Image Information"
    Write-Host "Source Path:    $OSSourcePath"
    Write-Host "-Image File:    $OSImagePath"
    Write-Host "-Image Index:   $OSImageIndex"
    Write-Host "-Name:          $OSImageName"
    Write-Host "-Description:   $OSImageDescription"
    Write-Host "-Architecture:  $OSArchitecture"
    Write-Host "-Edition:       $OSEditionID"
    Write-Host "-Type:          $OSInstallationType"
    Write-Host "-Languages:     $OSLanguages"
    Write-Host "-Build:         $OSBuild"
    Write-Host "-Version:       $OSVersion"
    Write-Host "-SPBuild:       $OSSPBuild"
    Write-Host "-SPLevel:       $OSSPLevel"
    Write-Host "-Bootable:      $OSImageBootable"
    Write-Host "-WimBoot:       $OSWIMBoot"
    Write-Host "-Created Time:  $OSCreatedTime"
    Write-Host "-Modified Time: $OSModifiedTime"
    Write-Host "-UBR:           $UBR"
    Write-Host "-OSMGuid:       $OSMGuid"
}

function Show-OSDInfoWorkingInformation {
    [CmdletBinding()]
    PARAM ()
    #===================================================================================================
    Write-Verbose '19.1.1 Working Information'
    #===================================================================================================
    Write-Host '========================================================================================' -ForegroundColor DarkGray
    Write-Host "Working Information"
    Write-Host "-WorkingName:   $WorkingName" -ForegroundColor Yellow
    Write-Host "-WorkingPath:   $WorkingPath" -ForegroundColor Yellow
    Write-Host "-OS:            $OS"
    Write-Host "-WinPE:         $WinPE"
    Write-Host "-Info:          $Info"
    Write-Host "-Logs:          $Info\logs"
}
function Show-OSDInfoSourceOSMedia {
    [CmdletBinding()]
    PARAM ()
    #===================================================================================================
    #   Show-OSDInfoSourceOSMedia
    #===================================================================================================
    Write-Host '========================================================================================' -ForegroundColor DarkGray
    Write-Host "Source OSMedia Windows Image Information"
    Write-Host "-OSMedia Path:                  $OSMediaPath" -ForegroundColor Yellow
    Write-Host "-Image File:                    $OSImagePath"
    Write-Host "-Image Index:                   $OSImageIndex"
    Write-Host "-Name:                          $OSImageName"
    Write-Host "-Description:                   $OSImageDescription"
    Write-Host "-Architecture:                  $OSArchitecture"
    Write-Host "-Edition:                       $OSEditionID"
    Write-Host "-Type:                          $OSInstallationType"
    Write-Host "-Languages:                     $OSLanguages"
    Write-Host "-Major Version:                 $OSMajorVersion"
    Write-Host "-Build:                         $OSBuild"
    Write-Host "-Version:                       $OSVersion"
    Write-Host "-SPBuild:                       $OSSPBuild"
    Write-Host "-SPLevel:                       $OSSPLevel"
    Write-Host "-Bootable:                      $OSImageBootable"
    Write-Host "-WimBoot:                       $OSWIMBoot"
    Write-Host "-Created Time:                  $OSCreatedTime"
    Write-Host "-Modified Time:                 $OSModifiedTime"
}
function Show-OSDInfoTask {
    [CmdletBinding()]
    PARAM ()        
    #===================================================================================================
    Write-Verbose '19.1.25 OSBuild Task Information'
    #===================================================================================================
    Write-Host '========================================================================================' -ForegroundColor DarkGray
    Write-Host "OSBuild Task Information"
    Write-Host "-TaskName:                      $TaskName"
    Write-Host "-TaskVersion:                   $TaskVersion"
    Write-Host "-TaskType:                      $TaskType"
    Write-Host "-OSMedia Name:                  $OSMediaName"
    Write-Host "-OSMedia Path:                  $OSMediaPath"
    Write-Host "-Custom Name:                   $CustomName"
    Write-Host "-Disable Feature:"
    if ($DisableFeature) {foreach ($item in $DisableFeature)            {Write-Host $item -ForegroundColor DarkGray}}
    Write-Host "-Drivers:"
    if ($Drivers) {foreach ($item in $Drivers)                          {Write-Host $item -ForegroundColor DarkGray}}
    Write-Host "-Enable Feature:"
    if ($EnableFeature) {foreach ($item in $EnableFeature)              {Write-Host $item -ForegroundColor DarkGray}}
    Write-Host "-Enable NetFx3:                 $EnableNetFX3"
    Write-Host "-Extra Files:"
    if ($ExtraFiles) {foreach ($item in $ExtraFiles)                    {Write-Host $item -ForegroundColor DarkGray}}
    Write-Host "-Features On Demand:"
    if ($FeaturesOnDemand) {foreach ($item in $FeaturesOnDemand)        {Write-Host $item -ForegroundColor DarkGray}}
    Write-Host "-Packages:"
    if ($Packages) {foreach ($item in $Packages)                        {Write-Host $item -ForegroundColor DarkGray}}
    Write-Host "-Remove Appx:"
    if ($RemoveAppx) {foreach ($item in $RemoveAppx)                    {Write-Host $item -ForegroundColor DarkGray}}
    Write-Host "-Remove Capability:"
    if ($RemoveCapability) {foreach ($item in $RemoveCapability)        {Write-Host $item -ForegroundColor DarkGray}}
    Write-Host "-Remove Packages:"
    if ($RemovePackage) {foreach ($item in $RemovePackage)              {Write-Host $item -ForegroundColor DarkGray}}
    Write-Host "-Scripts:"
    if ($Scripts) {foreach ($item in $Scripts)                          {Write-Host $item -ForegroundColor DarkGray}}
    Write-Host "-Start Layout:                  $StartLayoutXML"
    Write-Host "-Unattend:                      $UnattendXML"
    Write-Host "-WinPE Auto ExtraFiles:         $WinPEAutoExtraFiles"
    Write-Host "-WinPE DaRT:                    $WinPEDaRT"
    Write-Host "-WinPE Drivers:"
    if ($WinPEDrivers) {foreach ($item in $WinPEDrivers)                {Write-Host $item -ForegroundColor DarkGray}}
    Write-Host "-WinPE ADK Packages:"
    if ($WinPEADKPE) {foreach ($item in $WinPEADKPE)                    {Write-Host $item -ForegroundColor DarkGray}}
    Write-Host "-WinRE ADK Packages:"
    if ($WinPEADKRE) {foreach ($item in $WinPEADKRE)                    {Write-Host $item -ForegroundColor DarkGray}}
    Write-Host "-WinSE ADK Packages:"
    if ($WinPEADKSE) {foreach ($item in $WinPEADKSE)                    {Write-Host $item -ForegroundColor DarkGray}}
    Write-Host "-WinPE Extra Files:"
    if ($WinPEExtraFilesPE) {foreach ($item in $WinPEExtraFilesPE)      {Write-Host $item -ForegroundColor DarkGray}}
    Write-Host "-WinRE Extra Files:"
    if ($WinPEExtraFilesRE) {foreach ($item in $WinPEExtraFilesRE)      {Write-Host $item -ForegroundColor DarkGray}}
    Write-Host "-WinSE Extra Files:"
    if ($WinPEExtraFilesSE) {foreach ($item in $WinPEExtraFilesSE)      {Write-Host $item -ForegroundColor DarkGray}}
    Write-Host "-WinPE Scripts:"
    if ($WinPEScriptsPE) {foreach ($item in $WinPEScriptsPE)            {Write-Host $item -ForegroundColor DarkGray}}
    Write-Host "-WinRE Scripts:"
    if ($WinPEScriptsRE) {foreach ($item in $WinPEScriptsRE)            {Write-Host $item -ForegroundColor DarkGray}}
    Write-Host "-WinSE Scripts:"
    if ($WinPEScriptsSE) {foreach ($item in $WinPEScriptsSE)            {Write-Host $item -ForegroundColor DarkGray}}
    Write-Host "-SetAllIntl (Language):         $SetAllIntl"
    Write-Host "-SetInputLocale (Language):     $SetInputLocale"
    Write-Host "-SetSKUIntlDefaults (Language): $SetSKUIntlDefaults"
    Write-Host "-SetSetupUILang (Language):     $SetSetupUILang"
    Write-Host "-SetSysLocale (Language):       $SetSysLocale"
    Write-Host "-SetUILang (Language):          $SetUILang"
    Write-Host "-SetUILangFallback (Language):  $SetUILangFallback"
    Write-Host "-SetUserLocale (Language):      $SetUserLocale"
    Write-Host "-Language Features:"
    if ($LanguageFeatures) {foreach ($item in $LanguageFeatures)        {Write-Host $item -ForegroundColor DarkGray}}
    Write-Host "-Language Interface Packs:"
    if ($LanguageInterfacePacks) {foreach ($item in $LanguageInterfacePacks) {Write-Host $item -ForegroundColor DarkGray}}
    Write-Host "-Language Packs:"
    if ($LanguagePacks) {foreach ($item in $LanguagePacks)              {Write-Host $item -ForegroundColor DarkGray}}
    Write-Host "-Local Experience Packs:"
    if ($LocalExperiencePacks) {foreach ($item in $LocalExperiencePacks){Write-Host $item -ForegroundColor DarkGray}}
    Write-Host "-Language Sources Copy:"
    if ($LanguageCopySources) {foreach ($item in $LanguageCopySources){Write-Host $item -ForegroundColor DarkGray}}

    $CombinedOSMedia = Get-OSMedia -Revision OK | Where-Object {$_.OSMFamily -eq $TaskOSMFamily}

    $CombinedTask = [ordered]@{
        "TaskType" = [string]"OSBuild";
        "TaskName" = [string]$TaskName;
        "TaskVersion" = [string]$TaskVersion;
        "TaskGuid" = [string]$(New-Guid);
        "CustomName" = [string]$CustomName;
        "OSMFamily" = [string]$TaskOSMFamily
        "OSMGuid" = [string]$CombinedOSMedia.OSMGuid;
        "Name" = [string]$OSMediaName;

        "ImageName" = [string]$CombinedOSMedia.ImageName;
        "Arch" = [string]$CombinedOSMedia.Arch;
        "ReleaseId" = [string]$CombinedOSMedia.ReleaseId;
        "UBR" = [string]$CombinedOSMedia.UBR;
        "Languages" = [string[]]$CombinedOSMedia.Languages;
        "EditionId" = [string]$CombinedOSMedia.EditionId;
        "InstallationType" = [string]$CombinedOSMedia.InstallationType;
        "MajorVersion" = [string]$CombinedOSMedia.MajorVersion;
        "Build" = [string]$CombinedOSMedia.Build;
        "CreatedTime" = [datetime]$CombinedOSMedia.CreatedTime;
        "ModifiedTime" = [datetime]$CombinedOSMedia.ModifiedTime;

        "EnableNetFX3" = [string]$EnableNetFX3;
        "StartLayoutXML" = [string]$StartLayoutXML;
        "UnattendXML" = [string]$UnattendXML;
        "WinPEAutoExtraFiles" = [string]$WinPEAutoExtraFiles;
        "WinPEDaRT" = [string]$WinPEDaRT;

        "ExtraFiles" = [string[]]$($ExtraFiles | Sort-Object -Unique);
        "Scripts" = [string[]]$($Scripts | Sort-Object -Unique);
        "Drivers" = [string[]]$($Drivers | Sort-Object -Unique);

        "AddWindowsPackage" = [string[]]$($Packages | Sort-Object -Unique);
        "RemoveWindowsPackage" = [string[]]$($RemovePackage | Sort-Object -Unique);
        "AddFeatureOnDemand" = [string[]]$($FeaturesOnDemand | Sort-Object -Unique);
        "EnableWindowsOptionalFeature" = [string[]]$($EnableFeature | Sort-Object -Unique);
        "DisableWindowsOptionalFeature" = [string[]]$($DisableFeature | Sort-Object -Unique);
        "RemoveAppxProvisionedPackage" = [string[]]$($RemoveAppx | Sort-Object -Unique);
        "RemoveWindowsCapability" = [string[]]$($RemoveCapability | Sort-Object -Unique);

        "WinPEDrivers" = [string[]]$($WinPEDrivers | Sort-Object -Unique);
        "WinPEExtraFilesPE" = [string[]]$($WinPEExtraFilesPE | Sort-Object -Unique);
        "WinPEExtraFilesRE" = [string[]]$($WinPEExtraFilesRE | Sort-Object -Unique);
        "WinPEExtraFilesSE" = [string[]]$($WinPEExtraFilesSE | Sort-Object -Unique);
        "WinPEScriptsPE" = [string[]]$($WinPEScriptsPE | Sort-Object -Unique);
        "WinPEScriptsRE" = [string[]]$($WinPEScriptsRE | Sort-Object -Unique);
        "WinPEScriptsSE" = [string[]]$($WinPEScriptsSE | Sort-Object -Unique);
        "WinPEADKPE" = [string[]]$($WinPEADKPE | Select-Object -Unique);
        "WinPEADKRE" = [string[]]$($WinPEADKRE | Select-Object -Unique);
        "WinPEADKSE" = [string[]]$($WinPEADKSE | Select-Object -Unique);

        "LangSetAllIntl" = [string]$SetAllIntl;
        "LangSetInputLocale" = [string]$SetInputLocale;
        "LangSetSKUIntlDefaults" = [string]$SetSKUIntlDefaults;
        "LangSetSetupUILang" = [string]$SetSetupUILang;
        "LangSetSysLocale" = [string]$SetSysLocale;
        "LangSetUILang" = [string]$SetUILang;
        "LangSetUILangFallback" = [string]$SetUILangFallback;
        "LangSetUserLocale" = [string]$SetUserLocale;
        "LanguageFeature" = [string[]]$($LanguageFeatures | Sort-Object -Unique);
        "LanguageInterfacePack" = [string[]]$($LanguageInterfacePacks | Sort-Object -Unique);
        "LanguagePack" = [string[]]$($LanguagePacks | Sort-Object -Unique);
        "LocalExperiencePacks" = [string[]]$($LocalExperiencePacks | Sort-Object -Unique);
    }
    $CombinedTask | ConvertTo-Json | Out-File "$($CombinedOSMedia.FullName)\OSBuild.json"
}
function Mount-ImportOSMedia {
    [CmdletBinding()]
    PARAM ()
    #===================================================================================================
    #   Header
    #===================================================================================================
    Get-OSDStartTime
    Write-Host -ForegroundColor Green "Mount Install.wim: $MountDirectory"
    #===================================================================================================
    #   Execute
    #===================================================================================================
    if (!(Test-Path "$MountDirectory")) {New-Item "$MountDirectory" -ItemType Directory -Force | Out-Null}

    if ($InstallWimType -eq "esd") {
        Write-Host "Image: Mount $TempESD (Index 1) to $MountDirectory" -ForegroundColor Gray
        Mount-WindowsImage -ImagePath "$TempESD" -Index '1' -Path "$MountDirectory" -ReadOnly | Out-Null
    } else {
        Write-Host "Image: Mount $OSImagePath (Index $OSImageIndex) to $MountDirectory" -ForegroundColor Gray
        Mount-WindowsImage -ImagePath "$OSImagePath" -Index $OSImageIndex -Path "$MountDirectory" -ReadOnly | Out-Null
    }
}




function Import-OSDRegistryReg {
    [CmdletBinding()]
    PARAM ()
    #===================================================================================================
    Write-Verbose '19.2.1 Registry REG'
    #===================================================================================================
    Write-Host '========================================================================================' -ForegroundColor DarkGray
    Write-Host "Install.wim: Template Registry REG"

    #======================================================================================
    #	Import Registry REG
    #======================================================================================
    if ($RegistryTemplatesReg) {
        #======================================================================================
        # Load Registry Hives
        #======================================================================================
        if (Test-Path "$MountDirectory\Users\Default\NTUser.dat") {
            Write-Host "Loading Offline Registry Hive Default User" -ForegroundColor DarkGray
            Start-Process reg -ArgumentList "load HKLM\OfflineDefaultUser $MountDirectory\Users\Default\NTUser.dat" -Wait -WindowStyle Hidden -ErrorAction SilentlyContinue
        }
        if (Test-Path "$MountDirectory\Windows\System32\Config\DEFAULT") {
            Write-Host "Loading Offline Registry Hive DEFAULT" -ForegroundColor DarkGray
            Start-Process reg -ArgumentList "load HKLM\OfflineDefault $MountDirectory\Windows\System32\Config\DEFAULT" -Wait -WindowStyle Hidden -ErrorAction SilentlyContinue
        }
        if (Test-Path "$MountDirectory\Windows\System32\Config\SOFTWARE") {
            Write-Host "Loading Offline Registry Hive SOFTWARE" -ForegroundColor DarkGray
            Start-Process reg -ArgumentList "load HKLM\OfflineSoftware $MountDirectory\Windows\System32\Config\SOFTWARE" -Wait -WindowStyle Hidden -ErrorAction SilentlyContinue
        }
        if (Test-Path "$MountDirectory\Windows\System32\Config\SYSTEM") {
            Write-Host "Loading Offline Registry Hive SYSTEM" -ForegroundColor DarkGray
            Start-Process reg -ArgumentList "load HKLM\OfflineSystem $MountDirectory\Windows\System32\Config\SYSTEM" -Wait -WindowStyle Hidden -ErrorAction SilentlyContinue
        }
        #======================================================================================
        #	Process Registry REG
        #======================================================================================
        foreach ($RegistryREG in $RegistryTemplatesReg) {
            Write-Host "Processing $($RegistryREG.FullName)"
            $REGImportContent = @()
            $REGImportContent = Get-Content -Path $RegistryREG.FullName
            foreach ($Line in $REGImportContent) {
                Write-Host "$Line" -ForegroundColor Gray
            }
            Start-Process reg -ArgumentList ('import',"`"$($RegistryREG.FullName)`"") -Wait -WindowStyle Hidden -ErrorAction SilentlyContinue
        }
        #======================================================================================
        #	Unload Registry Hives
        #======================================================================================
        if (Test-Path -Path "HKLM:\OfflineDefaultUser") {
            Write-Host "Unloading Registry HKLM\OfflineDefaultUser" -ForegroundColor DarkGray
            Start-Process reg -ArgumentList "unload HKLM\OfflineDefaultUser" -Wait -WindowStyle Hidden -ErrorAction SilentlyContinue
        }
        if (Test-Path -Path "HKLM:\OfflineDefault") {
            Write-Host "Unloading Registry HKLM\OfflineDefault" -ForegroundColor DarkGray
            Start-Process reg -ArgumentList "unload HKLM\OfflineDefault" -Wait -WindowStyle Hidden -ErrorAction SilentlyContinue
        }
        if (Test-Path -Path "HKLM:\OfflineSoftware") {
            Write-Host "Unloading Registry HKLM\OfflineSoftware" -ForegroundColor DarkGray
            Start-Process reg -ArgumentList "unload HKLM\OfflineSoftware" -Wait -WindowStyle Hidden -ErrorAction SilentlyContinue
        }
        if (Test-Path -Path "HKLM:\OfflineSystem") {
            Write-Host "Unloading Registry HKLM\OfflineSystem" -ForegroundColor DarkGray
            Start-Process reg -ArgumentList "unload HKLM\OfflineSystem" -Wait -WindowStyle Hidden -ErrorAction SilentlyContinue
        }

        if (Test-Path -Path "HKLM:\OfflineDefaultUser") {
            Write-Host "Unloading Registry HKLM\OfflineDefaultUser (Second Attempt)" -ForegroundColor DarkGray
            Start-Process reg -ArgumentList "unload HKLM\OfflineDefaultUser" -Wait -WindowStyle Hidden -ErrorAction SilentlyContinue
        }
        if (Test-Path -Path "HKLM:\OfflineDefault") {
            Write-Host "Unloading Registry HKLM\OfflineDefault (Second Attempt)" -ForegroundColor DarkGray
            Start-Process reg -ArgumentList "unload HKLM\OfflineDefault" -Wait -WindowStyle Hidden -ErrorAction SilentlyContinue
        }
        if (Test-Path -Path "HKLM:\OfflineSoftware") {
            Write-Host "Unloading Registry HKLM\OfflineSoftware (Second Attempt)" -ForegroundColor DarkGray
            Start-Process reg -ArgumentList "unload HKLM\OfflineSoftware" -Wait -WindowStyle Hidden -ErrorAction SilentlyContinue
        }
        if (Test-Path -Path "HKLM:\OfflineSystem") {
            Write-Host "Unloading Registry HKLM\OfflineSystem (Second Attempt)" -ForegroundColor DarkGray
            Start-Process reg -ArgumentList "unload HKLM\OfflineSystem" -Wait -WindowStyle Hidden -ErrorAction SilentlyContinue
        }

        if (Test-Path -Path "HKLM:\OfflineDefaultUser") {
            Write-Warning "HKLM:\OfflineDefaultUser could not be dismounted.  Open Regedit and unload the Hive manually"
            Pause
        }
        if (Test-Path -Path "HKLM:\OfflineDefault") {
            Write-Warning "HKLM:\OfflineDefault could not be dismounted.  Open Regedit and unload the Hive manually"
            Pause
        }
        if (Test-Path -Path "HKLM:\OfflineSoftware") {
            Write-Warning "HKLM:\OfflineSoftware could not be dismounted.  Open Regedit and unload the Hive manually"
            Pause
        }
        if (Test-Path -Path "HKLM:\OfflineSystem") {
            Write-Warning "HKLM:\OfflineSystem could not be dismounted.  Open Regedit and unload the Hive manually"
            Pause
        }
    }
    #======================================================================================
}
function Import-OSDRegistryXml {
    [CmdletBinding()]
    PARAM ()
    #===================================================================================================
    Write-Verbose '19.1.30 Registry XML'
    #===================================================================================================
    Write-Host '========================================================================================' -ForegroundColor DarkGray
    Write-Host "Install.wim: Template Registry XML"

    #======================================================================================
    #	Import Registry XML
    #======================================================================================
    if ($RegistryTemplatesXml) {
        #======================================================================================
        # Load Registry Hives
        #======================================================================================
        if (Test-Path "$MountDirectory\Users\Default\NTUser.dat") {
            Write-Host "Loading Offline Registry Hive Default User" -ForegroundColor DarkGray
            Start-Process reg -ArgumentList "load HKLM\OfflineDefaultUser $MountDirectory\Users\Default\NTUser.dat" -Wait -WindowStyle Hidden -ErrorAction SilentlyContinue
        }
        if (Test-Path "$MountDirectory\Windows\System32\Config\DEFAULT") {
            Write-Host "Loading Offline Registry Hive DEFAULT" -ForegroundColor DarkGray
            Start-Process reg -ArgumentList "load HKLM\OfflineDefault $MountDirectory\Windows\System32\Config\DEFAULT" -Wait -WindowStyle Hidden -ErrorAction SilentlyContinue
        }
        if (Test-Path "$MountDirectory\Windows\System32\Config\SOFTWARE") {
            Write-Host "Loading Offline Registry Hive SOFTWARE" -ForegroundColor DarkGray
            Start-Process reg -ArgumentList "load HKLM\OfflineSoftware $MountDirectory\Windows\System32\Config\SOFTWARE" -Wait -WindowStyle Hidden -ErrorAction SilentlyContinue
        }
        if (Test-Path "$MountDirectory\Windows\System32\Config\SYSTEM") {
            Write-Host "Loading Offline Registry Hive SYSTEM" -ForegroundColor DarkGray
            Start-Process reg -ArgumentList "load HKLM\OfflineSystem $MountDirectory\Windows\System32\Config\SYSTEM" -Wait -WindowStyle Hidden -ErrorAction SilentlyContinue
        }
        #======================================================================================
        #	Process Registry XML
        #======================================================================================
        foreach ($RegistryXml in $RegistryTemplatesXml) {
            $RegistrySettings = @()
            Write-Host "Processing $($RegistryXml.FullName)"

            [xml]$XmlDocument = Get-Content -Path $RegistryXml.FullName
            $nodes = $XmlDocument.SelectNodes("//*[@action]")

            foreach ($node in $nodes) {
                $NodeAction = $node.attributes['action'].value
                $NodeDefault = $node.attributes['default'].value
                $NodeHive = $node.attributes['hive'].value
                $NodeKey = $node.attributes['key'].value
                $NodeName = $node.attributes['name'].value
                $NodeType = $node.attributes['type'].value
                $NodeValue = $node.attributes['value'].value

                $obj = new-object psobject -prop @{Action=$NodeAction;Default=$NodeDefault;Hive=$NodeHive;Key=$NodeKey;Name=$NodeName;Type=$NodeType;Value=$NodeValue}
                $RegistrySettings += $obj
            }

            foreach ($RegEntry in $RegistrySettings) {
                $RegAction = $RegEntry.Action
                $RegDefault = $RegEntry.Default
                $RegHive = $RegEntry.Hive
                #$RegHive = $RegHive -replace 'HKEY_LOCAL_MACHINE','HKLM:' -replace 'HKEY_CURRENT_USER','HKCU:' -replace 'HKEY_USERS','HKU:'
                $RegKey = $RegEntry.Key
                $RegName = $RegEntry.Name
                $RegType = $RegEntry.Type
                $RegType = $RegType -replace 'REG_SZ','String'
                $RegType = $RegType -replace 'REG_DWORD','DWord'
                $RegType = $RegType -replace 'REG_QWORD','QWord'
                $RegType = $RegType -replace 'REG_MULTI_SZ','MultiString'
                $RegType = $RegType -replace 'REG_EXPAND_SZ','ExpandString'
                $RegType = $RegType -replace 'REG_BINARY','Binary'
                $RegValue = $RegEntry.Value

                if ($RegType -eq 'Binary') {
                    $RegValue = $RegValue -replace '(..(?!$))','$1,'
                    $RegValue = $RegValue.Split(',') | ForEach-Object {"0x$_"}
                }

                $RegPath = "Registry::$RegHive\$RegKey"
                $RegPath = $RegPath -replace 'HKEY_CURRENT_USER','HKEY_LOCAL_MACHINE\OfflineDefaultUser'
                $RegPath = $RegPath -replace 'HKEY_LOCAL_MACHINE\\SOFTWARE','HKEY_LOCAL_MACHINE\OfflineSoftware'
                $RegPath = $RegPath -replace 'HKEY_LOCAL_MACHINE\\SYSTEM','HKEY_LOCAL_MACHINE\OfflineSystem'
                $RegPath = $RegPath -replace 'HKEY_USERS\\.DEFAULT','HKEY_LOCAL_MACHINE\OfflineDefault'
                
                if ($RegAction -eq "D") {
                    Write-Host "Remove-ItemProperty -LiteralPath $RegPath" -ForegroundColor Red
                    if ($RegDefault -eq '0' -and $RegName -eq '' -and $RegValue -eq '') {
                        Remove-ItemProperty -LiteralPath $RegPath -Force -ErrorAction SilentlyContinue | Out-Null
                    } elseif ($RegDefault -eq '1') {
                        Write-Host "-Name '(Default)'"
                        Remove-ItemProperty -LiteralPath $RegPath -Name '(Default)' -Force -ErrorAction SilentlyContinue | Out-Null
                    } else {
                        Write-Host "-Name $RegName"
                        Remove-ItemProperty -LiteralPath $RegPath -Name $RegName -Force -ErrorAction SilentlyContinue | Out-Null
                    }
                } else {
                    if (!(Test-Path -LiteralPath $RegPath)) {
                        Write-Host "New-Item -Path $RegPath" -ForegroundColor Gray
                        New-Item -Path $RegPath -Force | Out-Null
                    }
                    if ($RegDefault -eq '1') {$RegName = '(Default)'}
                    if (!($RegType -eq '')) {
                        Write-Host "New-ItemProperty -LiteralPath $RegPath" -ForegroundColor Gray
                        Write-Host "-Name $RegName -PropertyType $RegType -Value $RegValue" -ForegroundColor DarkGray
                        New-ItemProperty -LiteralPath $RegPath -Name $RegName -PropertyType $RegType -Value $RegValue -Force | Out-Null
                    }
                }
            }
        }
        #======================================================================================
        #	Unload Registry Hives
        #======================================================================================
        if (Test-Path -Path "HKLM:\OfflineDefaultUser") {
            Write-Host "Unloading Registry HKLM\OfflineDefaultUser" -ForegroundColor DarkGray
            Start-Process reg -ArgumentList "unload HKLM\OfflineDefaultUser" -Wait -WindowStyle Hidden -ErrorAction SilentlyContinue
        }
        if (Test-Path -Path "HKLM:\OfflineDefault") {
            Write-Host "Unloading Registry HKLM\OfflineDefault" -ForegroundColor DarkGray
            Start-Process reg -ArgumentList "unload HKLM\OfflineDefault" -Wait -WindowStyle Hidden -ErrorAction SilentlyContinue
        }
        if (Test-Path -Path "HKLM:\OfflineSoftware") {
            Write-Host "Unloading Registry HKLM\OfflineSoftware" -ForegroundColor DarkGray
            Start-Process reg -ArgumentList "unload HKLM\OfflineSoftware" -Wait -WindowStyle Hidden -ErrorAction SilentlyContinue
        }
        if (Test-Path -Path "HKLM:\OfflineSystem") {
            Write-Host "Unloading Registry HKLM\OfflineSystem" -ForegroundColor DarkGray
            Start-Process reg -ArgumentList "unload HKLM\OfflineSystem" -Wait -WindowStyle Hidden -ErrorAction SilentlyContinue
        }

        if (Test-Path -Path "HKLM:\OfflineDefaultUser") {
            Write-Host "Unloading Registry HKLM\OfflineDefaultUser (Second Attempt)" -ForegroundColor DarkGray
            Start-Process reg -ArgumentList "unload HKLM\OfflineDefaultUser" -Wait -WindowStyle Hidden -ErrorAction SilentlyContinue
        }
        if (Test-Path -Path "HKLM:\OfflineDefault") {
            Write-Host "Unloading Registry HKLM\OfflineDefault (Second Attempt)" -ForegroundColor DarkGray
            Start-Process reg -ArgumentList "unload HKLM\OfflineDefault" -Wait -WindowStyle Hidden -ErrorAction SilentlyContinue
        }
        if (Test-Path -Path "HKLM:\OfflineSoftware") {
            Write-Host "Unloading Registry HKLM\OfflineSoftware (Second Attempt)" -ForegroundColor DarkGray
            Start-Process reg -ArgumentList "unload HKLM\OfflineSoftware" -Wait -WindowStyle Hidden -ErrorAction SilentlyContinue
        }
        if (Test-Path -Path "HKLM:\OfflineSystem") {
            Write-Host "Unloading Registry HKLM\OfflineSystem (Second Attempt)" -ForegroundColor DarkGray
            Start-Process reg -ArgumentList "unload HKLM\OfflineSystem" -Wait -WindowStyle Hidden -ErrorAction SilentlyContinue
        }

        if (Test-Path -Path "HKLM:\OfflineDefaultUser") {
            Write-Warning "HKLM:\OfflineDefaultUser could not be dismounted.  Open Regedit and unload the Hive manually"
            Pause
        }
        if (Test-Path -Path "HKLM:\OfflineDefault") {
            Write-Warning "HKLM:\OfflineDefault could not be dismounted.  Open Regedit and unload the Hive manually"
            Pause
        }
        if (Test-Path -Path "HKLM:\OfflineSoftware") {
            Write-Warning "HKLM:\OfflineSoftware could not be dismounted.  Open Regedit and unload the Hive manually"
            Pause
        }
        if (Test-Path -Path "HKLM:\OfflineSystem") {
            Write-Warning "HKLM:\OfflineSystem could not be dismounted.  Open Regedit and unload the Hive manually"
            Pause
        }
    }
    #======================================================================================
}
function Set-OSDWinREWim {
    [CmdletBinding()]
    PARAM ()
    #===================================================================================================
    #   Header
    #===================================================================================================
    Get-OSDStartTime
    Write-Host -ForegroundColor Green "Install.wim: Replace $MountDirectory\Windows\System32\Recovery\winre.wim"
    #===================================================================================================
    #   Execute
    #===================================================================================================
    if (Test-Path "$MountDirectory\Windows\System32\Recovery\winre.wim") {
        Remove-Item -Path "$MountDirectory\Windows\System32\Recovery\winre.wim" -Force
    }

    Copy-Item -Path "$WinPE\winre.wim" -Destination "$MountDirectory\Windows\System32\Recovery\winre.wim" -Force | Out-Null
    $GetWindowsImage = @()
    $GetWindowsImage = Get-WindowsImage -ImagePath "$WinPE\winre.wim" -Index 1 | Select-Object -Property *
    $GetWindowsImage | Out-File "$PEInfo\Get-WindowsImage-WinRE.txt"
    (Get-Content "$PEInfo\Get-WindowsImage-WinRE.txt") | Where-Object {$_.Trim(" `t")} | Set-Content "$PEInfo\Get-WindowsImage-WinRE.txt"
    $GetWindowsImage | Out-File "$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsImage-WinRE.txt"
    $GetWindowsImage | Export-Clixml -Path "$PEInfo\xml\Get-WindowsImage-WinRE.xml"
    $GetWindowsImage | Export-Clixml -Path "$PEInfo\xml\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsImage-WinRE.xml"
    $GetWindowsImage | ConvertTo-Json | Out-File "$PEInfo\json\Get-WindowsImage-WinRE.json"
    $GetWindowsImage | ConvertTo-Json | Out-File "$PEInfo\json\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsImage-WinRE.json"
}
function Save-OSDSessionsXml {
    [CmdletBinding()]
    PARAM (
        [string]$OSMediaPath
    )
    #===================================================================================================
    #   Header
    #===================================================================================================
    Get-OSDStartTime
    Write-Host -ForegroundColor Green "Install.wim: Copy Sessions.xml to $OSMediaPath\info\Sessions.xml"
    Write-Verbose "OSMediaPath: $OSMediaPath"

    if (Test-Path "$MountDirectory\Windows\Servicing\Sessions\Sessions.xml") {
        Write-Verbose "$OSMediaPath\info\Sessions.xml"
        Copy-Item "$MountDirectory\Windows\Servicing\Sessions\Sessions.xml" "$OSMediaPath\info\Sessions.xml" -Force | Out-Null

        [xml]$SessionsXML = Get-Content -Path "$MountDirectory\Windows\Servicing\Sessions\Sessions.xml"

        $Sessions = $SessionsXML.SelectNodes('Sessions/Session') | ForEach-Object {
            New-Object -Type PSObject -Property @{
                Id = $_.Tasks.Phase.package.id
                KBNumber = $_.Tasks.Phase.package.name
                TargetState = $_.Tasks.Phase.package.targetState
                Client = $_.Client
                Complete = $_.Complete
                Status = $_.Status
            }
        }
        
        $Sessions = $Sessions | Where-Object {$_.Id -like "Package*"}
        $Sessions = $Sessions | Select-Object -Property Id, KBNumber, TargetState, Client, Status, Complete | Sort-Object Complete -Descending

        $Sessions | Out-File "$OSMediaPath\Sessions.txt"
        $Sessions | Out-File "$OSMediaPath\info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Sessions.txt"
        $Sessions | Export-Clixml -Path "$OSMediaPath\info\xml\Sessions.xml"
        $Sessions | Export-Clixml -Path "$OSMediaPath\info\xml\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Sessions.xml"
        $Sessions | ConvertTo-Json | Out-File "$OSMediaPath\info\json\Sessions.json"
        $Sessions | ConvertTo-Json | Out-File "$OSMediaPath\info\json\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Sessions.json"
    }
    
    if (Test-Path "$OSMediaPath\Sessions.xml") {
        Remove-Item "$OSMediaPath\Sessions.xml" -Force | Out-Null
    }
}

function Export-OSDSessionsXml {
    [CmdletBinding()]
    PARAM (
        [string]$OSMediaPath
    )
    Write-Verbose "$OSMediaPath\Sessions.xml"
    Copy-Item "$OSMediaPath\Sessions.xml" "$OSMediaPath\info\Sessions.xml" -Force | Out-Null

    [xml]$SessionsXML = Get-Content -Path "$OSMediaPath\info\Sessions.xml"

    $Sessions = $SessionsXML.SelectNodes('Sessions/Session') | ForEach-Object {
        New-Object -Type PSObject -Property @{
            Id = $_.Tasks.Phase.package.id
            KBNumber = $_.Tasks.Phase.package.name
            TargetState = $_.Tasks.Phase.package.targetState
            Client = $_.Client
            Complete = $_.Complete
            Status = $_.Status
        }
    }
    
    $Sessions = $Sessions | Where-Object {$_.Id -like "Package*"}
    $Sessions = $Sessions | Select-Object -Property Id, KBNumber, TargetState, Client, Status, Complete | Sort-Object Complete -Descending

    $Sessions | Out-File "$OSMediaPath\Sessions.txt"
    $Sessions | Out-File "$OSMediaPath\info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Sessions.txt"
    $Sessions | Export-Clixml -Path "$OSMediaPath\info\xml\Sessions.xml"
    $Sessions | Export-Clixml -Path "$OSMediaPath\info\xml\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Sessions.xml"
    $Sessions | ConvertTo-Json | Out-File "$OSMediaPath\info\json\Sessions.json"
    $Sessions | ConvertTo-Json | Out-File "$OSMediaPath\info\json\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Sessions.json"

    Remove-Item "$OSMediaPath\Sessions.xml" -Force | Out-Null
}
function Get-OSDTemplateRegistryReg {
    [CmdletBinding()]
    PARAM ()

    $RegistryTemplatesRegOriginal = @()
    $RegistryTemplatesRegOriginal = Get-ChildItem "$OSDBuilderTemplates\Registry\AutoApply" *.reg -Recurse | Select-Object -Property Name, BaseName, Extension, Directory, FullName
    
    foreach ($REG in $RegistryTemplatesRegOriginal) {
        if (!(Test-Path "$($REG.FullName).Offline")) {
           Write-Host "Creating $($REG.FullName).Offline" -ForegroundColor DarkGray
           $REGContent = Get-Content -Path $REG.FullName
            $REGContent = $REGContent -replace 'HKEY_CURRENT_USER','HKEY_LOCAL_MACHINE\OfflineDefaultUser'
            $REGContent = $REGContent -replace 'HKEY_LOCAL_MACHINE\\SOFTWARE','HKEY_LOCAL_MACHINE\OfflineSoftware'
            $REGContent = $REGContent -replace 'HKEY_LOCAL_MACHINE\\SYSTEM','HKEY_LOCAL_MACHINE\OfflineSystem'
            $REGContent = $REGContent -replace 'HKEY_USERS\\.DEFAULT','HKEY_LOCAL_MACHINE\OfflineDefault'
           $REGContent | Set-Content "$($REG.FullName).Offline" -Force
        }
    }

    $RegistryTemplatesReg = @()

    Write-Host "$OSDBuilderTemplates\Registry\AutoApply\Global" -ForegroundColor DarkGray
    [array]$RegistryTemplatesReg = Get-ChildItem "$OSDBuilderTemplates\Registry\AutoApply\Global\*" *.reg.Offline -Recurse

    Write-Host "$OSDBuilderTemplates\Registry\AutoApply\Global $OSArchitecture" -ForegroundColor DarkGray
    [array]$RegistryTemplatesReg += Get-ChildItem "$OSDBuilderTemplates\Registry\AutoApply\Global $OSArchitecture\*" *.reg.Offline -Recurse

    Write-Host "$OSDBuilderTemplates\Registry\AutoApply\$UpdateOS" -ForegroundColor DarkGray
    [array]$RegistryTemplatesReg += Get-ChildItem "$OSDBuilderTemplates\Registry\AutoApply\$UpdateOS\*" *.reg.Offline -Recurse

    if ($OSInstallationType -notlike "*Server*") {
        Write-Host "$OSDBuilderTemplates\Registry\AutoApply\$UpdateOS $OSArchitecture" -ForegroundColor DarkGray
        [array]$RegistryTemplatesReg += Get-ChildItem "$OSDBuilderTemplates\Registry\AutoApply\$UpdateOS $OSArchitecture\*" *.reg.Offline -Recurse
    }
    if ($OSInstallationType -notlike "*Server*" -and $OSMajorVersion -eq 10) {
        Write-Host "$OSDBuilderTemplates\Registry\AutoApply\$UpdateOS $OSArchitecture $ReleaseId" -ForegroundColor DarkGray
        [array]$RegistryTemplatesReg += Get-ChildItem "$OSDBuilderTemplates\Registry\AutoApply\$UpdateOS $OSArchitecture $ReleaseId\*" *.reg.Offline -Recurse
    }
    Return $RegistryTemplatesReg
}

function Get-OSDTemplateRegistryXml {
    [CmdletBinding()]
    PARAM ()

    $RegistryTemplatesXml = @()

    Write-Host "$OSDBuilderTemplates\Registry\AutoApply\Global" -ForegroundColor DarkGray
    [array]$RegistryTemplatesXml = Get-ChildItem "$OSDBuilderTemplates\Registry\AutoApply\Global\*" *.xml -Recurse

    Write-Host "$OSDBuilderTemplates\Registry\AutoApply\Global $OSArchitecture" -ForegroundColor DarkGray
    [array]$RegistryTemplatesXml += Get-ChildItem "$OSDBuilderTemplates\Registry\AutoApply\Global $OSArchitecture\*" *.xml -Recurse

    Write-Host "$OSDBuilderTemplates\Registry\AutoApply\$UpdateOS" -ForegroundColor DarkGray
    [array]$RegistryTemplatesXml += Get-ChildItem "$OSDBuilderTemplates\Registry\AutoApply\$UpdateOS\*" *.xml -Recurse

    if ($OSInstallationType -notlike "*Server*") {
        Write-Host "$OSDBuilderTemplates\Registry\AutoApply\$UpdateOS $OSArchitecture" -ForegroundColor DarkGray
        [array]$RegistryTemplatesXml += Get-ChildItem "$OSDBuilderTemplates\Registry\AutoApply\$UpdateOS $OSArchitecture\*" *.xml -Recurse
    }
    if ($OSInstallationType -notlike "*Server*" -and $OSMajorVersion -eq 10) {
        Write-Host "$OSDBuilderTemplates\Registry\AutoApply\$UpdateOS $OSArchitecture $ReleaseId" -ForegroundColor DarkGray
        [array]$RegistryTemplatesXml += Get-ChildItem "$OSDBuilderTemplates\Registry\AutoApply\$UpdateOS $OSArchitecture $ReleaseId\*" *.xml -Recurse
    }
    Return $RegistryTemplatesXml
}

function Get-OSDTemplateScripts {
    [CmdletBinding()]
    PARAM ()

    $ScriptTemplates = @()

    Write-Host "$OSDBuilderTemplates\Scripts\AutoApply\Global" -ForegroundColor DarkGray
    [array]$ScriptTemplates = Get-ChildItem "$OSDBuilderTemplates\Scripts\AutoApply\Global\*" *.ps1 -Recurse

    Write-Host "$OSDBuilderTemplates\Scripts\AutoApply\Global $OSArchitecture" -ForegroundColor DarkGray
    [array]$ScriptTemplates += Get-ChildItem "$OSDBuilderTemplates\Scripts\AutoApply\Global $OSArchitecture\*" *.ps1 -Recurse

    Write-Host "$OSDBuilderTemplates\Scripts\AutoApply\$UpdateOS" -ForegroundColor DarkGray
    [array]$ScriptTemplates += Get-ChildItem "$OSDBuilderTemplates\Scripts\AutoApply\$UpdateOS\*" *.ps1 -Recurse

    if ($OSInstallationType -notlike "*Server*") {
        Write-Host "$OSDBuilderTemplates\Scripts\AutoApply\$UpdateOS $OSArchitecture" -ForegroundColor DarkGray
        [array]$ScriptTemplates += Get-ChildItem "$OSDBuilderTemplates\Scripts\AutoApply\$UpdateOS $OSArchitecture\*" *.ps1 -Recurse
    }
    if ($OSInstallationType -notlike "*Server*" -and $OSMajorVersion -eq 10) {
        Write-Host "$OSDBuilderTemplates\Scripts\AutoApply\$UpdateOS $OSArchitecture $ReleaseId" -ForegroundColor DarkGray
        [array]$ScriptTemplates += Get-ChildItem "$OSDBuilderTemplates\Scripts\AutoApply\$UpdateOS $OSArchitecture $ReleaseId\*" *.ps1 -Recurse
    }
    Return $ScriptTemplates
}

function Get-OSDTemplateDrivers {
    [CmdletBinding()]
    PARAM ()

    $DriverTemplates = @()

    Write-Host "$OSDBuilderTemplates\Drivers\AutoApply\Global" -ForegroundColor Gray
    [array]$DriverTemplates = Get-Item "$OSDBuilderTemplates\Drivers\AutoApply\Global"

    Write-Host "$OSDBuilderTemplates\Drivers\AutoApply\Global $OSArchitecture" -ForegroundColor Gray
    [array]$DriverTemplates += Get-Item "$OSDBuilderTemplates\Drivers\AutoApply\Global $OSArchitecture"

    Write-Host "$OSDBuilderTemplates\Drivers\AutoApply\$UpdateOS" -ForegroundColor Gray
    [array]$DriverTemplates += Get-Item "$OSDBuilderTemplates\Drivers\AutoApply\$UpdateOS"

    if ($OSInstallationType -notlike "*Server*") {
        Write-Host "$OSDBuilderTemplates\Drivers\AutoApply\$UpdateOS $OSArchitecture" -ForegroundColor Gray
        [array]$DriverTemplates += Get-Item "$OSDBuilderTemplates\Drivers\AutoApply\$UpdateOS $OSArchitecture"
    }
    if ($OSInstallationType -notlike "*Server*" -and $OSMajorVersion -eq 10) {
        Write-Host "$OSDBuilderTemplates\Drivers\AutoApply\$UpdateOS $OSArchitecture $ReleaseId" -ForegroundColor Gray
        [array]$DriverTemplates += Get-Item "$OSDBuilderTemplates\Drivers\AutoApply\$UpdateOS $OSArchitecture $ReleaseId"
    }
    Return $DriverTemplates
}

function Get-OSDTemplateExtraFiles {
    [CmdletBinding()]
    PARAM ()

    $ExtraFilesTemplates = @()

    Write-Host "$OSDBuilderTemplates\ExtraFiles\AutoApply\Global" -ForegroundColor DarkGray
    [array]$ExtraFilesTemplates = Get-ChildItem "$OSDBuilderTemplates\ExtraFiles\AutoApply\Global" | Where-Object {$_.PSIsContainer -eq $true} 

    Write-Host "$OSDBuilderTemplates\ExtraFiles\AutoApply\Global $OSArchitecture" -ForegroundColor DarkGray
    [array]$ExtraFilesTemplates += Get-ChildItem "$OSDBuilderTemplates\ExtraFiles\AutoApply\Global $OSArchitecture" | Where-Object {$_.PSIsContainer -eq $true} 

    Write-Host "$OSDBuilderTemplates\ExtraFiles\AutoApply\$UpdateOS" -ForegroundColor DarkGray
    [array]$ExtraFilesTemplates += Get-ChildItem "$OSDBuilderTemplates\ExtraFiles\AutoApply\$UpdateOS" | Where-Object {$_.PSIsContainer -eq $true} 

    if ($OSInstallationType -notlike "*Server*") {
        Write-Host "$OSDBuilderTemplates\ExtraFiles\AutoApply\$UpdateOS $OSArchitecture" -ForegroundColor DarkGray
        [array]$ExtraFilesTemplates += Get-ChildItem "$OSDBuilderTemplates\ExtraFiles\AutoApply\$UpdateOS $OSArchitecture" | Where-Object {$_.PSIsContainer -eq $true} 
    }
    if ($OSInstallationType -notlike "*Server*" -and $OSMajorVersion -eq 10) {
        Write-Host "$OSDBuilderTemplates\ExtraFiles\AutoApply\$UpdateOS $OSArchitecture $ReleaseId" -ForegroundColor DarkGray
        [array]$ExtraFilesTemplates += Get-ChildItem "$OSDBuilderTemplates\ExtraFiles\AutoApply\$UpdateOS $OSArchitecture $ReleaseId" | Where-Object {$_.PSIsContainer -eq $true} 
    }
    Return $ExtraFilesTemplates
}
function Update-WinPESources {
    [CmdletBinding()]
    PARAM (
        [string]$OSMediaPath
    )
    #===================================================================================================
    #   Header
    #===================================================================================================
    Get-OSDStartTime
    Write-Host -ForegroundColor Green "Media: Update Sources with WinSE.wim"
    #===================================================================================================
    #   Execute
    #===================================================================================================
    robocopy "$MountWinSE\sources" "$OSMediaPath\OS\sources" setup.exe /ndl /xo /xx /xl /b /np /ts /tee /r:0 /w:0 /Log+:"$OSMediaPath\info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Robocopy-WinSE-MediaSources.log" | Out-Null
    robocopy "$MountWinSE\sources" "$OSMediaPath\OS\sources" setuphost.exe /ndl /xo /xx /xl /b /np /ts /tee /r:0 /w:0 /Log+:"$OSMediaPath\info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Robocopy-WinSE-MediaSources.log" | Out-Null
}
function Save-OSDInventoryPackagesPE {
    [CmdletBinding()]
    PARAM (
        [string]$OSMediaPath
    )
    #===================================================================================================
    #   Header
    #===================================================================================================
    Get-OSDStartTime
    Write-Host -ForegroundColor Green "WinPE: Export WinPE Package Inventory to $OSMediaPath\WinPE\info"
    #===================================================================================================
    $GetWindowsPackage = @()
    Write-Verbose "$OSMediaPath\WinPE\info\Get-WindowsPackage-WinPE.txt"
    $GetWindowsPackage = Get-WindowsPackage -Path "$MountWinPE"
    $GetWindowsPackage | Out-File "$OSMediaPath\WinPE\info\Get-WindowsPackage-WinPE.txt"
    $GetWindowsPackage | Out-File "$OSMediaPath\WinPE\info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsPackage-WinPE.txt"
    $GetWindowsPackage | Export-Clixml -Path "$OSMediaPath\WinPE\info\xml\Get-WindowsPackage-WinPE.xml"
    $GetWindowsPackage | Export-Clixml -Path "$OSMediaPath\WinPE\info\xml\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsPackage-WinPE.xml"
    $GetWindowsPackage | ConvertTo-Json | Out-File "$OSMediaPath\WinPE\info\json\Get-WindowsPackage-WinPE.json"
    $GetWindowsPackage | ConvertTo-Json | Out-File "$OSMediaPath\WinPE\info\json\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsPackage-WinPE.json"

    #===================================================================================================
    Write-Verbose 'Get-WindowsPackage WinRE'
    #===================================================================================================
    $GetWindowsPackage = @()
    Write-Verbose "$OSMediaPath\WinPE\info\Get-WindowsPackage-WinRE.txt"
    $GetWindowsPackage = Get-WindowsPackage -Path "$MountWinRE"
    $GetWindowsPackage | Out-File "$OSMediaPath\WinPE\info\Get-WindowsPackage-WinRE.txt"
    $GetWindowsPackage | Out-File "$OSMediaPath\WinPE\info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsPackage-WinRE.txt"
    $GetWindowsPackage | Export-Clixml -Path "$OSMediaPath\WinPE\info\xml\Get-WindowsPackage-WinRE.xml"
    $GetWindowsPackage | Export-Clixml -Path "$OSMediaPath\WinPE\info\xml\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsPackage-WinRE.xml"
    $GetWindowsPackage | ConvertTo-Json | Out-File "$OSMediaPath\WinPE\info\json\Get-WindowsPackage-WinRE.json"
    $GetWindowsPackage | ConvertTo-Json | Out-File "$OSMediaPath\WinPE\info\json\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsPackage-WinRE.json"

    #===================================================================================================
    Write-Verbose 'Get-WindowsPackage WinSE'
    #===================================================================================================
    $GetWindowsPackage = @()
    Write-Verbose "$OSMediaPath\WinPE\info\Get-WindowsPackage-WinSE.txt"
    $GetWindowsPackage = Get-WindowsPackage -Path "$MountWinSE"
    $GetWindowsPackage | Out-File "$OSMediaPath\WinPE\info\Get-WindowsPackage-WinSE.txt"
    $GetWindowsPackage | Out-File "$OSMediaPath\WinPE\info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsPackage-WinSE.txt"
    $GetWindowsPackage | Export-Clixml -Path "$OSMediaPath\WinPE\info\xml\Get-WindowsPackage-WinSE.xml"
    $GetWindowsPackage | Export-Clixml -Path "$OSMediaPath\WinPE\info\xml\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsPackage-WinSE.xml"
    $GetWindowsPackage | ConvertTo-Json | Out-File "$OSMediaPath\WinPE\info\json\Get-WindowsPackage-WinSE.json"
    $GetWindowsPackage | ConvertTo-Json | Out-File "$OSMediaPath\WinPE\info\json\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsPackage-WinSE.json"
}

function Save-OSDInventoryPE {
    [CmdletBinding()]
    PARAM (
        [string]$OSMediaPath
    )
    #===================================================================================================
    #   Header
    #===================================================================================================
    Get-OSDStartTime
    Write-Host -ForegroundColor Green "WinPE: Export WIM Inventory to $OSMediaPath\WinPE\info"
    #===================================================================================================
    $GetWindowsImage = @()
    Write-Verbose "$OSMediaPath\WinPE\info\Get-WindowsImage-Boot.txt"
    $GetWindowsImage = Get-WindowsImage -ImagePath "$OSMediaPath\WinPE\boot.wim"
    $GetWindowsImage | Out-File "$OSMediaPath\WinPE\info\Get-WindowsImage-Boot.txt"
    (Get-Content "$OSMediaPath\WinPE\info\Get-WindowsImage-Boot.txt") | Where-Object {$_.Trim(" `t")} | Set-Content "$OSMediaPath\WinPE\info\Get-WindowsImage-Boot.txt"
    $GetWindowsImage | Out-File "$OSMediaPath\WinPE\info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsImage-Boot.txt"
    $GetWindowsImage | Export-Clixml -Path "$OSMediaPath\WinPE\info\xml\Get-WindowsImage-Boot.xml"
    $GetWindowsImage | Export-Clixml -Path "$OSMediaPath\WinPE\info\xml\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsImage-Boot.xml"
    $GetWindowsImage | ConvertTo-Json | Out-File "$OSMediaPath\WinPE\info\json\Get-WindowsImage-Boot.json"
    $GetWindowsImage | ConvertTo-Json | Out-File "$OSMediaPath\WinPE\info\json\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsImage-Boot.json"

    #===================================================================================================
    Write-Verbose 'Get-WindowsImage WinPE'
    #===================================================================================================
    $GetWindowsImage = @()
    Write-Verbose "$OSMediaPath\WinPE\info\Get-WindowsImage-WinPE.txt"
    $GetWindowsImage = Get-WindowsImage -ImagePath "$OSMediaPath\WinPE\winpe.wim" -Index 1 | Select-Object -Property *
    $GetWindowsImage | Out-File "$OSMediaPath\WinPE\info\Get-WindowsImage-WinPE.txt"
    (Get-Content "$OSMediaPath\WinPE\info\Get-WindowsImage-WinPE.txt") | Where-Object {$_.Trim(" `t")} | Set-Content "$OSMediaPath\WinPE\info\Get-WindowsImage-WinPE.txt"
    $GetWindowsImage | Out-File "$OSMediaPath\WinPE\info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsImage-WinPE.txt"
    $GetWindowsImage | Export-Clixml -Path "$OSMediaPath\WinPE\info\xml\Get-WindowsImage-WinPE.xml"
    $GetWindowsImage | Export-Clixml -Path "$OSMediaPath\WinPE\info\xml\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsImage-WinPE.xml"
    $GetWindowsImage | ConvertTo-Json | Out-File "$OSMediaPath\WinPE\info\json\Get-WindowsImage-WinPE.json"
    $GetWindowsImage | ConvertTo-Json | Out-File "$OSMediaPath\WinPE\info\json\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsImage-WinPE.json"

    #===================================================================================================
    Write-Verbose 'Get-WindowsImage WinRE'
    #===================================================================================================
    $GetWindowsImage = @()
    Write-Verbose "$OSMediaPath\WinPE\info\Get-WindowsImage-WinRE.txt"
    $GetWindowsImage = Get-WindowsImage -ImagePath "$OSMediaPath\WinPE\winre.wim" -Index 1 | Select-Object -Property *
    $GetWindowsImage | Out-File "$OSMediaPath\WinPE\info\Get-WindowsImage-WinRE.txt"
    (Get-Content "$OSMediaPath\WinPE\info\Get-WindowsImage-WinRE.txt") | Where-Object {$_.Trim(" `t")} | Set-Content "$OSMediaPath\WinPE\info\Get-WindowsImage-WinRE.txt"
    $GetWindowsImage | Out-File "$OSMediaPath\WinPE\info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsImage-WinRE.txt"
    $GetWindowsImage | Export-Clixml -Path "$OSMediaPath\WinPE\info\xml\Get-WindowsImage-WinRE.xml"
    $GetWindowsImage | Export-Clixml -Path "$OSMediaPath\WinPE\info\xml\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsImage-WinRE.xml"
    $GetWindowsImage | ConvertTo-Json | Out-File "$OSMediaPath\WinPE\info\json\Get-WindowsImage-WinRE.json"
    $GetWindowsImage | ConvertTo-Json | Out-File "$OSMediaPath\WinPE\info\json\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsImage-WinRE.json"

    #===================================================================================================
    Write-Verbose 'Get-WindowsImage Setup'
    #===================================================================================================
    $GetWindowsImage = @()
    Write-Verbose "$OSMediaPath\WinPE\info\Get-WindowsImage-WinSE.txt"
    $GetWindowsImage = Get-WindowsImage -ImagePath "$OSMediaPath\WinPE\winse.wim" -Index 1 | Select-Object -Property *
    $GetWindowsImage | Out-File "$OSMediaPath\WinPE\info\Get-WindowsImage-WinSE.txt"
    (Get-Content "$OSMediaPath\WinPE\info\Get-WindowsImage-WinSE.txt") | Where-Object {$_.Trim(" `t")} | Set-Content "$OSMediaPath\WinPE\info\Get-WindowsImage-WinSE.txt"
    $GetWindowsImage | Out-File "$OSMediaPath\WinPE\info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsImage-WinSE.txt"
    $GetWindowsImage | Export-Clixml -Path "$OSMediaPath\WinPE\info\xml\Get-WindowsImage-WinSE.xml"
    $GetWindowsImage | Export-Clixml -Path "$OSMediaPath\WinPE\info\xml\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsImage-WinSE.xml"
    $GetWindowsImage | ConvertTo-Json | Out-File "$OSMediaPath\WinPE\info\json\Get-WindowsImage-WinSE.json"
    $GetWindowsImage | ConvertTo-Json | Out-File "$OSMediaPath\WinPE\info\json\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsImage-WinSE.json"
}
function Expand-OSDDaRTPE {
    [CmdletBinding()]
    PARAM ()
    #===================================================================================================
    #   Header
    #===================================================================================================
    Get-OSDStartTime
    Write-Host -ForegroundColor Green "WinPE: Expand Microsoft DaRT"
    #===================================================================================================
    #   Execute
    #===================================================================================================
    if ([string]::IsNullOrEmpty($WinPEDaRT) -or [string]::IsNullOrWhiteSpace($WinPEDaRT)) {Write-Warning "Skipping WinPE DaRT"}
    elseif (Test-Path "$OSDBuilderContent\$WinPEDaRT") {
        #===================================================================================================
        Write-Host "WinPE: WinPE.wim Microsoft DaRT $OSDBuilderContent\$WinPEDaRT"
        expand.exe "$OSDBuilderContent\$WinPEDaRT" -F:*.* "$MountWinPE" | Out-Null
        if (Test-Path "$MountWinPE\Windows\System32\winpeshl.ini") {Remove-Item -Path "$MountWinPE\Windows\System32\winpeshl.ini" -Force}
        #===================================================================================================
        Write-Host "WinPE: WinRE.wim Microsoft DaRT $OSDBuilderContent\$WinPEDaRT"
        expand.exe "$OSDBuilderContent\$WinPEDaRT" -F:*.* "$MountWinRE" | Out-Null
        (Get-Content "$MountWinRE\Windows\System32\winpeshl.ini") | ForEach-Object {$_ -replace '-prompt','-network'} | Out-File "$MountWinRE\Windows\System32\winpeshl.ini"
        #===================================================================================================
        Write-Host "WinPE: WinSE.wim Microsoft DaRT $OSDBuilderContent\$WinPEDaRT"
        expand.exe "$OSDBuilderContent\$WinPEDaRT" -F:*.* "$MountWinSE" | Out-Null
        if (Test-Path "$MountWinSE\Windows\System32\winpeshl.ini") {Remove-Item -Path "$MountWinSE\Windows\System32\winpeshl.ini" -Force}
        
        if (Test-Path $(Join-Path $(Split-Path "$OSDBuilderContent\$WinPEDart") 'DartConfig.dat')) {
            Copy-Item -Path $(Join-Path $(Split-Path "$OSDBuilderContent\$WinPEDart") 'DartConfig.dat') -Destination "$MountWinPE\Windows\System32\DartConfig.dat" -Force | Out-Null
            Copy-Item -Path $(Join-Path $(Split-Path "$OSDBuilderContent\$WinPEDart") 'DartConfig.dat') -Destination "$MountWinSE\Windows\System32\DartConfig.dat" -Force | Out-Null
            Copy-Item -Path $(Join-Path $(Split-Path "$OSDBuilderContent\$WinPEDart") 'DartConfig.dat') -Destination "$MountWinRE\Windows\System32\DartConfig.dat" -Force | Out-Null
        } elseif (Test-Path $(Join-Path $(Split-Path $WinPEDart) 'DartConfig8.dat')) {
            Copy-Item -Path $(Join-Path $(Split-Path "$OSDBuilderContent\$WinPEDart") 'DartConfig8.dat') -Destination "$MountWinSE\Windows\System32\DartConfig.dat" -Force | Out-Null
            Copy-Item -Path $(Join-Path $(Split-Path "$OSDBuilderContent\$WinPEDart") 'DartConfig8.dat') -Destination "$MountWinPE\Windows\System32\DartConfig.dat" -Force | Out-Null
            Copy-Item -Path $(Join-Path $(Split-Path "$OSDBuilderContent\$WinPEDart") 'DartConfig8.dat') -Destination "$MountWinRE\Windows\System32\DartConfig.dat" -Force | Out-Null
        }
        #===================================================================================================
    } else {Write-Warning "WinPE DaRT do not exist in $OSDBuilderContent\$WinPEDart"}
}
<#
.SYNOPSIS
Renames directories in OSMedia

.DESCRIPTION
Renames directories in OSMedia

.LINK
http://osdbuilder.com/docs/functions/maintenance/rename-osmedia
#>
function Rename-OSMedia {
    [CmdletBinding()]
    PARAM ()

    BEGIN {
        #Write-Host '========================================================================================' -ForegroundColor DarkGray
        #Write-Host "$($MyInvocation.MyCommand.Name) BEGIN"

        #===================================================================================================
        Write-Verbose '19.1.1 Initialize OSDBuilder'
        #===================================================================================================
        Get-OSDBuilder -CreatePaths -HideDetails

        #===================================================================================================
        Write-Verbose '19.1.1 Gather All OSMedia'
        #===================================================================================================
        $AllOSMedia = @()
        $AllOSMedia = Get-ChildItem -Path "$OSDBuilderOSMedia" -Directory | Select-Object -Property * | Where-Object {Test-Path $(Join-Path $_.FullName "info\xml\Get-WindowsImage.xml")}
    }

    PROCESS {
        #Write-Host '========================================================================================' -ForegroundColor DarkGray
        #Write-Host "$($MyInvocation.MyCommand.Name) PROCESS"

        $RenameOSMedia = foreach ($Item in $AllOSMedia) {
            #===================================================================================================
            #Write-Verbose '19.1.1 Get Windows Image Information'
            #===================================================================================================
            $RenameOSMediaPath = $($Item.FullName)
            Write-Verbose "OSMedia Full Path: $RenameOSMediaPath"
            
            $OSMWindowsImage = @()
            $OSMWindowsImage = Import-Clixml -Path "$RenameOSMediaPath\info\xml\Get-WindowsImage.xml"
            
            $OSMVersion = $($OSMWindowsImage.Version)
            Write-Verbose "Version: $OSMVersion"

            $OSMImageName = $($OSMWindowsImage.ImageName)
            Write-Verbose "ImageName: $OSMImageName"

            $OSMArch = $OSMWindowsImage.Architecture
            if ($OSMArch -eq '0') {$OSMArch = 'x86'}
            if ($OSMArch -eq '6') {$OSMArch = 'ia64'}
            if ($OSMArch -eq '9') {$OSMArch = 'x64'}
            if ($OSMArch -eq '12') {$OSMArch = 'x64 ARM'}
            Write-Verbose "Arch: $OSMArch"

            $OSMEditionId = $($OSMWindowsImage.EditionId)
            Write-Verbose "EditionId: $OSMEditionId"

            $OSMInstallationType = $($OSMWindowsImage.InstallationType)
            Write-Verbose "InstallationType: $OSMInstallationType"

            $OSMMajorVersion = $($OSMWindowsImage.MajorVersion)
            Write-Verbose "MajorVersion: $OSMMajorVersion"

            $OSMMinorVersion = $($OSMWindowsImage.MinorVersion)
            Write-Verbose "MinorVersion: $OSMMinorVersion"

            $OSMBuild = $OSMWindowsImage.Build
            Write-Verbose "Build: $OSMBuild"

            $OSMLanguages = $($OSMWindowsImage.Languages)
            Write-Verbose "Languages: $OSMLanguages"

            $OperatingSystem = ''
            if ($OSMMajorVersion -eq 6 -and $OSMInstallationType -eq 'Client') {$OperatingSystem = 'Windows 7'}
            if ($OSMMajorVersion -eq 10 -and $OSMInstallationType -eq 'Client') {$OperatingSystem = 'Windows 10'}
            if ($OSMMajorVersion -eq 10 -and $OSMInstallationType -eq 'Server' -and $OSMImageName -like "*2016*") {$OperatingSystem = 'Server 2016'}
            if ($OSMMajorVersion -eq 10 -and $OSMInstallationType -eq 'Server' -and $OSMImageName -like "*2019*") {$OperatingSystem = 'Server 2019'}

            $OSMUBR = $($OSMWindowsImage.UBR)
            Write-Verbose "UBR: $OSMUBR"
			
            #   OSMFamily V1
            $OSMFamilyV1 = $(Get-Date -Date $($OSMWindowsImage.CreatedTime)).ToString("yyyyMMddHHmmss") + $OSMEditionID
            #   OSMFamily V2
            $OSMFamily = $OSMInstallationType + " " + $OSMEditionId + " " + $OSMArch + " " + [string]$OSMBuild + " " + $OSMLanguages
            Write-Verbose "OSMFamily: $OSMFamily"

            #$OSMWindowsImage | ForEach {$_.PSObject.Properties.Remove('Guid')}

            $OSMGuid = $($OSMWindowsImage.OSMGuid)
            if (-not ($OSMGuid)) {
                $OSMGuid = $(New-Guid)
                $OSMWindowsImage | Add-Member -Type NoteProperty -Name "OSMGuid" -Value $OSMGuid
                $OSMWindowsImage | Out-File "$RenameOSMediaPath\WindowsImage.txt"
                $OSMWindowsImage | Out-File "$RenameOSMediaPath\info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsImage.txt"
                $OSMWindowsImage | Export-Clixml -Path "$RenameOSMediaPath\info\xml\Get-WindowsImage.xml"
                $OSMWindowsImage | Export-Clixml -Path "$RenameOSMediaPath\info\xml\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsImage.xml"
                $OSMWindowsImage | ConvertTo-Json | Out-File "$RenameOSMediaPath\info\json\Get-WindowsImage.json"
                $OSMWindowsImage | ConvertTo-Json | Out-File "$RenameOSMediaPath\info\json\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsImage.json"
                (Get-Content "$RenameOSMediaPath\WindowsImage.txt") | Where-Object {$_.Trim(" `t")} | Set-Content "$RenameOSMediaPath\WindowsImage.txt"
                Write-Verbose "Guid (New): $OSMGuid"
            } else {
                Write-Verbose "Guid: $OSMGuid"
            }

            #===================================================================================================
            #Write-Verbose '19.1.1 Gather Registry Information'
            #===================================================================================================
            $OSMRegistry = @()
            if (Test-Path "$RenameOSMediaPath\info\xml\CurrentVersion.xml") {
                Write-Verbose "Registry: $RenameOSMediaPath\info\xml\CurrentVersion.xml"
                $OSMRegistry = Import-Clixml -Path "$RenameOSMediaPath\info\xml\CurrentVersion.xml"
            } else {
                Write-Verbose "Registry: $RenameOSMediaPath\info\xml\CurrentVersion.xml (Not Found)"
            }
            [string]$OSMReleaseId = $($OSMRegistry.ReleaseId)

            if ($OSMBuild -eq 7600) {$OSMReleaseId = 7600}
            if ($OSMBuild -eq 7601) {$OSMReleaseId = 7601}
            if ($OSMBuild -eq 9600) {$OSMReleaseId = 9600}
            if ($OSMBuild -eq 10240) {$OSMReleaseId = 1507}
            if ($OSMBuild -eq 14393) {$OSMReleaseId = 1607}
            if ($OSMBuild -eq 15063) {$OSMReleaseId = 1703}
            if ($OSMBuild -eq 16299) {$OSMReleaseId = 1709}
            if ($OSMBuild -eq 17134) {$OSMReleaseId = 1803}
            if ($OSMBuild -eq 17763) {$OSMReleaseId = 1809}
            if ($OSMBuild -eq 18362) {$OSMReleaseId = 1903}

            Write-Verbose "ReleaseId: $OSMReleaseId"

            if ($OSMReleaseId -eq 7601) {$OSMReleaseId = 'SP1'}

            $FullNameFormat = "$OSMImageName $OSMArch $OSMReleaseId $OSMUBR $($OSMWindowsImage.Languages)"

            $FullNameFormat = $FullNameFormat -replace '\(', ''
            $FullNameFormat = $FullNameFormat -replace '\)', ''

            if ($($($OSMWindowsImage.Languages).count) -eq 1) {$FullNameFormat = $FullNameFormat.replace(' en-US','')}

            if (!($Item.Name -eq $FullNameFormat)) {
                #===================================================================================================
                #Write-Verbose '19.1.1 Object Properties'
                #===================================================================================================
                $ObjectProperties = @{
                    
                    FullNameFormat      = $FullNameFormat
                    Name                = $Item.Name
                    FullName            = $Item.FullName
                }
                New-Object -TypeName PSObject -Property $ObjectProperties
                Write-Verbose ""
            }

        }

        #===================================================================================================
        #Write-Verbose '19.1.3 Output'
        #===================================================================================================
        $RenameOSMedia = $RenameOSMedia | Select-Object FullNameFormat,Name,FullName | Out-GridView -PassThru -Title 'Rename-OSMedia: Select one or more OSMedia to Rename and press OK'
        foreach ($Item in $RenameOSMedia){
            Write-Warning "Renaming $($Item.FullName) to $($Item.FullNameFormat)"
            Rename-Item -Path "$($Item.FullName)" -NewName "$($Item.FullNameFormat)" -Force
        }
    }

    END {
        #Write-Host '========================================================================================' -ForegroundColor DarkGray
        #Write-Host "$($MyInvocation.MyCommand.Name) END"
    }
}
<#
.SYNOPSIS
Updates OSBuild Tasks to the latest version

.DESCRIPTION
Updates OSBuild Tasks to the latest version

.LINK
http://osdbuilder.com/docs/functions/maintenance/repair-osbuildtask
#>
function Repair-OSBuildTask {
    [CmdletBinding()]
    PARAM ()
    BEGIN {
        #Write-Host '========================================================================================' -ForegroundColor DarkGray
        #Write-Host "$($MyInvocation.MyCommand.Name) BEGIN"

        #===================================================================================================
        Write-Verbose '19.1.1 Initialize OSDBuilder'
        #===================================================================================================
        Get-OSDBuilder -CreatePaths -HideDetails

        #===================================================================================================
        Write-Verbose '19.1.6 Gather All OSBuildTask'
        #===================================================================================================
        $OSBuildTask = @()
        $OSBuildTask = Get-OSBuildTask | Where-Object {$null -eq $_.OSMGuid}
    }
    
    PROCESS {
        #Write-Host '========================================================================================' -ForegroundColor DarkGray
        Write-Host "$($MyInvocation.MyCommand.Name) PROCESS"

        foreach ($Item in $OSBuildTask) {
            $TaskFile = Get-Item -Path "$($Item.FullName)" | Select-Object -Property *
            Write-Warning "Repair Required: $($Item.FullName)"

            #===================================================================================================
            Write-Verbose 'Read Task'
            #===================================================================================================
            $Task = @()
            $Task = Get-Content "$($Item.FullName)" | ConvertFrom-Json

            if ([System.Version]$Task.TaskVersion -gt [System.Version]"19.1.3.0") {
                Write-Warning "Error: OSBuild Task does not need a Repair . . . Exiting!"
                Return
            }
    
            Write-Host "Select the OSMedia that will be used with this OSBuild Task"
            Write-Host "Previous OSMedia: $($Task.MediaName)"
            $OSMedia = Get-OSMedia

            if ($Task.MediaName -like "*x64*") {$OSMedia = $OSMedia | Where-Object {$_.Arch -eq 'x64'}}
            if ($Task.MediaName -like "*x86*") {$OSMedia = $OSMedia | Where-Object {$_.Arch -eq 'x86'}}
            if ($Task.MediaName -like "*1511*") {$OSMedia = $OSMedia | Where-Object {$_.ReleaseId -eq '1511'}}
            if ($Task.MediaName -like "*1607*") {$OSMedia = $OSMedia | Where-Object {$_.ReleaseId -eq '1607'}}
            if ($Task.MediaName -like "*1703*") {$OSMedia = $OSMedia | Where-Object {$_.ReleaseId -eq '1703'}}
            if ($Task.MediaName -like "*1709*") {$OSMedia = $OSMedia | Where-Object {$_.ReleaseId -eq '1709'}}
            if ($Task.MediaName -like "*1803*") {$OSMedia = $OSMedia | Where-Object {$_.ReleaseId -eq '1803'}}
            if ($Task.MediaName -like "*1809*") {$OSMedia = $OSMedia | Where-Object {$_.ReleaseId -eq '1809'}}
            
            $OSMedia = $OSMedia | Out-GridView -OutputMode Single -Title "$($Task.TaskName): Select the OSMedia used with this OSBuild Task"
    
            if ($null -eq $OSMedia) {
                Write-Warning "Error: OSMedia was not selected . . . Exiting!"
                Return
            }

            Write-Host "Selected $($OSMedia.Name)"

            #===================================================================================================
            Write-Verbose '19.1.5 Create OSBuild Task'
            #===================================================================================================
            $NewTask = [ordered]@{
                "TaskType" = [string]"OSBuild";
                "TaskName" = [string]$Task.TaskName;
                "TaskVersion" = [string]$OSDBuilderVersion;
                "TaskGuid" = [string]$(New-Guid);
                "CustomName" = [string]$Task.BuildName;
    
                "OSMFamily" = [string]$OSMedia.OSMFamily;
                "OSMGuid" = [string]$OSMedia.OSMGuid;
                "Name" = [string]$OSMedia.Name;
                "ImageName" = [string]$OSMedia.ImageName;
                "Arch" = [string]$OSMedia.Arch;
                "ReleaseId" = [string]$($OSMedia.ReleaseId);
                "UBR" = [string]$OSMedia.UBR;
                "EditionId" = [string]$OSMedia.EditionId;
                "InstallationType" = [string]$OSMedia.InstallationType;
                "MajorVersion" = [string]$OSMedia.MajorVersion;
                "Build" = [string]$OSMedia.Build;
                "CreatedTime" = [datetime]$OSMedia.CreatedTime;
                "ModifiedTime" = [datetime]$OSMedia.ModifiedTime;
    
                "EnableNetFX3" = [string]$Task.EnableNetFX3;
                "StartLayoutXML" = [string]$Task.ImportStartLayout;
                "UnattendXML" = [string]$Task.UseWindowsUnattend;
                "WinPEAutoExtraFiles" = [string]"False";
                "WinPEDaRT" = [string]$Task.WinPEAddDaRT;

                "ExtraFiles" = [string[]]$Task.RobocopyExtraFiles;
                "Scripts" = [string[]]$Task.InvokeScript;
                "Drivers" = [string[]]$Task.AddWindowsDriver;
    
                "AddWindowsPackage" = [string[]]$Task.AddWindowsPackage;
                "RemoveWindowsPackage" = [string[]]$Task.RemoveWindowsPackage;
                "AddFeatureOnDemand" = [string[]]$Task.AddFeatureOnDemand;
                "EnableWindowsOptionalFeature" = [string[]]$Task.EnableWindowsOptionalFeature;
                "DisableWindowsOptionalFeature" = [string[]]$Task.DisableWindowsOptionalFeature;
                "RemoveAppxProvisionedPackage" = [string[]]$Task.RemoveAppxProvisionedPackage;
                "RemoveWindowsCapability" = [string[]]$Task.RemoveWindowsCapability;
    
                "WinPEDrivers" = [string[]]$Task.WinPEAddWindowsDriver;
                "WinPEScriptsPE" = [string[]]$Task.WinPEInvokeScriptPE;
                "WinPEScriptsRE" = [string[]]$Task.WinPEInvokeScriptRE;
                "WinPEScriptsSE" = [string[]]$Task.WinPEInvokeScriptSetup;
                "WinPEExtraFilesPE" = [string[]]$Task.WinPERobocopyExtraFilesPE;
                "WinPEExtraFilesRE" = [string[]]$Task.WinPERobocopyExtraFilesRE;
                "WinPEExtraFilesSE" = [string[]]$Task.WinPERobocopyExtraFilesSetup;
                "WinPEADKPE" = [string[]]$Task.WinPEAddADKPE;
                "WinPEADKRE" = [string[]]$Task.WinPEAddADKRE;
                "WinPEADKSE" = [string[]]$Task.WinPEAddADKSetup;
    
                "LangSetAllIntl" = [string]$Task.LangSetAllIntl;
                "LangSetInputLocale" = [string]$Task.LangSetInputLocale;
                "LangSetSKUIntlDefaults" = [string]$Task.LangSetSKUIntlDefaults;
                "LangSetSetupUILang" = [string]$Task.LangSetSetupUILang;
                "LangSetSysLocale" = [string]$Task.LangSetSysLocale;
                "LangSetUILang" = [string]$Task.LangSetUILang;
                "LangSetUILangFallback" = [string]$Task.LangSetUILangFallback;
                "LangSetUserLocale" = [string]$Task.LangSetUserLocale;
                "LanguageFeature" = [string[]]$Task.AddLanguageFeature;
                "LanguageInterfacePack" = [string[]]$Task.AddLanguageInterfacePack;
                "LanguagePack" = [string[]]$Task.AddLanguagePack;
            }
			
            #===================================================================================================
            Write-Verbose '19.1.7 Create Backup'
            #===================================================================================================
            if (!(Test-Path "$($TaskFile.Directory)\Repair")) {
                New-Item -Path "$($TaskFile.Directory)\Repair"-ItemType Directory -Force | Out-Null
            }

            if (!(Test-Path "$($TaskFile.Directory)\Repair\$($TaskFile.Name)")) {
                Write-Host "Creating Backup $($TaskFile.Directory)\Repair\$($TaskFile.Name)"
                Copy-Item -Path "$($TaskFile.FullName)" -Destination "$($TaskFile.Directory)\Repair\$($TaskFile.Name)" -Force
            }
    
            #===================================================================================================
            Write-Verbose '19.1.1 New-OSBuildTask Complete'
            #===================================================================================================
            $NewTask | ConvertTo-Json | Out-File "$($Item.FullName)" -Encoding ascii
            Write-Host "Update Complete: $($Task.TaskName)"
            Write-Host '========================================================================================' -ForegroundColor DarkGray
        }
    }

    END {
        #Write-Host '========================================================================================' -ForegroundColor DarkGray
        #Write-Host "$($MyInvocation.MyCommand.Name) END"
    }
}
<#
.SYNOPSIS
Updates PEBuild Tasks to the latest version

.DESCRIPTION
Updates PEBuild Tasks to the latest version

.LINK
http://osdbuilder.com/docs/functions/maintenance/repair-pebuildtask

#>
function Repair-PEBuildTask {
    [CmdletBinding()]
    PARAM ()
    BEGIN {
        #Write-Host '========================================================================================' -ForegroundColor DarkGray
        #Write-Host "$($MyInvocation.MyCommand.Name) BEGIN"

        #===================================================================================================
        Write-Verbose '19.1.1 Initialize OSDBuilder'
        #===================================================================================================
        Get-OSDBuilder -CreatePaths -HideDetails

        #===================================================================================================
        Write-Verbose '19.1.6 Gather All PEBuildTask'
        #===================================================================================================
        $PEBuildTask = @()
        $PEBuildTask = Get-PEBuildTask | Where-Object {$null -eq $_.OSMGuid}
    }
    
    PROCESS {
        #Write-Host '========================================================================================' -ForegroundColor DarkGray
        Write-Host "$($MyInvocation.MyCommand.Name) PROCESS"

        foreach ($Item in $PEBuildTask) {
            $TaskFile = Get-Item -Path "$($Item.FullName)" | Select-Object -Property *
            Write-Warning "Repair Required: $($Item.FullName)"

            #===================================================================================================
            Write-Verbose 'Read Task'
            #===================================================================================================
            $Task = @()
            $Task = Get-Content "$($Item.FullName)" | ConvertFrom-Json

            if ([System.Version]$Task.TaskVersion -gt [System.Version]"19.1.3.0") {
                Write-Warning "Error: PEBuild Task does not need a Repair . . . Exiting!"
                Return
            }
    
            Write-Host "Select the OSMedia that will be used with this PEBuild Task"
            Write-Host "Previous OSMedia: $($Task.MediaName)"
            $OSMedia = Get-OSMedia
            
            if ($Task.MediaName -like "*x64*") {$OSMedia = $OSMedia | Where-Object {$_.Arch -eq 'x64'}}
            if ($Task.MediaName -like "*x86*") {$OSMedia = $OSMedia | Where-Object {$_.Arch -eq 'x86'}}
            if ($Task.MediaName -like "*1511*") {$OSMedia = $OSMedia | Where-Object {$_.ReleaseId -eq '1511'}}
            if ($Task.MediaName -like "*1607*") {$OSMedia = $OSMedia | Where-Object {$_.ReleaseId -eq '1607'}}
            if ($Task.MediaName -like "*1703*") {$OSMedia = $OSMedia | Where-Object {$_.ReleaseId -eq '1703'}}
            if ($Task.MediaName -like "*1709*") {$OSMedia = $OSMedia | Where-Object {$_.ReleaseId -eq '1709'}}
            if ($Task.MediaName -like "*1803*") {$OSMedia = $OSMedia | Where-Object {$_.ReleaseId -eq '1803'}}
            if ($Task.MediaName -like "*1809*") {$OSMedia = $OSMedia | Where-Object {$_.ReleaseId -eq '1809'}}

            $OSMedia = $OSMedia | Out-GridView -OutputMode Single -Title "$($Task.TaskName): Select the OSMedia used with this PEBuild Task"
    
            if ($null -eq $OSMedia) {
                Write-Warning "Error: OSMedia was not selected . . . Exiting!"
                Return
            }

            Write-Host "Selected $($OSMedia.Name)"

            #===================================================================================================
            Write-Verbose '19.1.5 Create PEBuild Task'
            #===================================================================================================
            $NewTask = [ordered]@{
                "TaskType" = 'PEBuild'
                "TaskName" = [string]$Task.TaskName;
                "TaskVersion" = [string]$OSDBuilderVersion;
                "TaskGuid" = [string]$(New-Guid);
    
                "OSMFamily" = [string]$OSMedia.OSMFamily;
                "OSMGuid" = [string]$OSMedia.OSMGuid;
                "Name" = [string]$OSMedia.Name;
                "ImageName" = [string]$OSMedia.ImageName;
                "Arch" = [string]$OSMedia.Arch;
                "ReleaseId" = [string]$($OSMedia.ReleaseId);
                "UBR" = [string]$OSMedia.UBR;
                "EditionId" = [string]$OSMedia.EditionId;
                "InstallationType" = [string]$OSMedia.InstallationType;
                "MajorVersion" = [string]$OSMedia.MajorVersion;
                "Build" = [string]$OSMedia.Build;
                "CreatedTime" = [datetime]$OSMedia.CreatedTime;
                "ModifiedTime" = [datetime]$OSMedia.ModifiedTime;

                "WinPEOutput" = [string]$Task.PEOutput;
                "CustomName" = [string]'';
                "MDTDeploymentShare" = [string]$Task.DeploymentShare;
                "ScratchSpace" = [string]$Task.ScratchSpace;
                "SourceWim" = [string]$Task.SourceWim;
                "WinPEAutoExtraFiles" = [string]$Task.AutoExtraFiles;
                "WinPEDaRT" = [string]$Task.WinPEAddDaRT;
                "WinPEDrivers" = [string[]]$Task.WinPEAddWindowsDriver;
                "WinPEExtraFiles" = [string[]]$Task.WinPERobocopyExtraFiles;
                "WinPEScripts" = [string[]]$Task.WinPEInvokeScript;
                "WinPEADK" = [string[]]$Task.WinPEAddADK;
            }
    
            #===================================================================================================
            Write-Verbose '19.1.7 Create Backup'
            #===================================================================================================
            if (!(Test-Path "$($TaskFile.Directory)\Repair")) {
                New-Item -Path "$($TaskFile.Directory)\Repair"-ItemType Directory -Force | Out-Null
            }

            if (!(Test-Path "$($TaskFile.Directory)\Repair\$($TaskFile.Name)")) {
                Write-Host "Creating Backup $($TaskFile.Directory)\Repair\$($TaskFile.Name)"
                Copy-Item -Path "$($TaskFile.FullName)" -Destination "$($TaskFile.Directory)\Repair\$($TaskFile.Name)" -Force
            }
            
            #===================================================================================================
            Write-Verbose '19.1.7 New-PEBuildTask Complete'
            #===================================================================================================
            $NewTask | ConvertTo-Json | Out-File "$($Item.FullName)" -Encoding ascii
            Write-Host "Update Complete: $($Task.TaskName)"
            Write-Host '========================================================================================' -ForegroundColor DarkGray
        }
    }

    END {
        #Write-Host '========================================================================================' -ForegroundColor DarkGray
        #Write-Host "$($MyInvocation.MyCommand.Name) END"
    }
}
<#
.SYNOPSIS
Updates the OSDBuilder PowerShell Module to the latest version

.DESCRIPTION
Updates the OSDBuilder PowerShell Module to the latest version from the PowerShell Gallery in the CurrentUser Scope

.PARAMETER AllUsers
Installs the Module in the AllUsers Scope.  Requires Admin Rights

.LINK
http://osdbuilder.com/docs/functions/update-moduleosdbuilder

.Example
Update-ModuleOSDBuilder
#>
function Update-ModuleOSDBuilder {
    [CmdletBinding()]
    PARAM (
        [switch]$CurrentUser
    )
    #===================================================================================================
    #   Uninstall-Module
    #===================================================================================================
    Write-Warning "Uninstall-Module -Name OSDBuilder -AllVersions -Force"
    try {Uninstall-Module -Name OSDBuilder -AllVersions -Force -ErrorAction SilentlyContinue}
    catch {}
    #===================================================================================================
    #   Remove-Module
    #===================================================================================================
    Write-Warning "Remove-Module -Name OSDBuilder -Force"
    try {Remove-Module -Name OSDBuilder -Force -ErrorAction SilentlyContinue}
    catch {}
    #===================================================================================================
    #   Install-Module
    #===================================================================================================
    if ($CurrentUser.IsPresent) {
        Write-Warning "Install-Module -Name OSDBuilder -Scope CurrentUser -Force"
        try {Install-Module -Name OSDBuilder -Scope CurrentUser -Force -ErrorAction SilentlyContinue}
        catch {}
    } else {
        Write-Warning "Install-Module -Name OSDBuilder -Force"
        try {Install-Module -Name OSDBuilder -Force -ErrorAction SilentlyContinue}
        catch {}
    }
    #===================================================================================================
    #   Import-Module
    #===================================================================================================
    Write-Warning "Import-Module -Name OSDBuilder -Force"
    try {Import-Module -Name OSDBuilder -Force -ErrorAction SilentlyContinue}
    catch {}
    #===================================================================================================
    #   Close PowerShell
    #===================================================================================================
    Write-Warning "Close all open PowerShell sessions before using OSDBuilder"
}

function Use-DismCleanupImage {
    [CmdletBinding()]
    PARAM ()
    #===================================================================================================
    #   Abort
    #===================================================================================================
    if ($OSVersion -like "6.1*") {Return}
    if ($SkipUpdates) {Return}
    if ($SkipComponentCleanup) {Return}
    #===================================================================================================
    #   Header
    #===================================================================================================
    Get-OSDStartTime
    Write-Host -ForegroundColor Green "Install.wim: DISM Cleanup-Image"
    #===================================================================================================
    #   Execute
    #===================================================================================================
    $CurrentLog = "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Dism-Cleanup-Image.log"
    if ($OSMajorVersion -eq 10) {
        if ($(Get-WindowsCapability -Path $MountDirectory | Where-Object {$_.state -eq "*pending*"})) {
            Write-Warning "Cannot run WindowsImage Cleanup on a WIM with Pending Installations"
        } else {
            Write-Verbose "CurrentLog: $CurrentLog"
            Dism /Image:"$MountDirectory" /Cleanup-Image /StartComponentCleanup /ResetBase /LogPath:"$CurrentLog"
        }
    } else {
        Write-Verbose "CurrentLog: $CurrentLog"
        Dism /Image:"$MountDirectory" /Cleanup-Image /StartComponentCleanup /ResetBase /LogPath:"$CurrentLog" 
    }
}
function Copy-OSDAutoExtraFiles {
    [CmdletBinding()]
    PARAM ()
    #===================================================================================================
    #   Header
    #===================================================================================================
    Get-OSDStartTime
    Write-Host -ForegroundColor Green "WinPE: Auto ExtraFiles"
    #===================================================================================================
    #   Execute
    #===================================================================================================
    Write-Host "$WinPE\AutoExtraFiles" -ForegroundColor Gray
    $CurrentLog = "$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-AutoExtraFiles.log"

    robocopy "$WinPE\AutoExtraFiles" "$MountWinPE" *.* /e /ndl /xf bcp47*.dll /xx /b /np /ts /tee /r:0 /w:0 /Log+:"$CurrentLog" | Out-Null
    robocopy "$WinPE\AutoExtraFiles" "$MountWinRE" *.* /e /ndl /xf bcp47*.dll /xx /b /np /ts /tee /r:0 /w:0 /Log+:"$CurrentLog" | Out-Null
    robocopy "$WinPE\AutoExtraFiles" "$MountWinSE" *.* /e /ndl /xf bcp47*.dll /xx /b /np /ts /tee /r:0 /w:0 /Log+:"$CurrentLog" | Out-Null
    #===================================================================================================
}
function Copy-OSDLanguageSources {
    [CmdletBinding()]
    PARAM ()
    #===================================================================================================
    #   Return
    #===================================================================================================
    if ($OSMajorVersion -ne 10) {Return}
    #===================================================================================================
    #   Header
    #===================================================================================================
    Get-OSDStartTime
    Write-Host -ForegroundColor Green "Install.wim: Language Sources"
    #===================================================================================================
    #   Execute
    #===================================================================================================
    foreach ($LanguageSource in $LanguageCopySources) {
        $CurrentLanguageSource = Get-OSMedia -Revision OK | Where-Object {$_.OSMFamily -eq $LanguageSource} | Select-Object -Property FullName
        Write-Host "Copying Language Resources from $($CurrentLanguageSource.FullName)" -ForegroundColor DarkGray
        robocopy "$($CurrentLanguageSource.FullName)\OS" "$OS" *.* /e /xf *.wim /ndl /xc /xn /xo /xf /xx /b /np /ts /tee /r:0 /w:0 /Log+:"$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-LanguageSources.log" | Out-Null
    }
    #===================================================================================================
}
function Copy-OSDOperatingSystem {
    [CmdletBinding()]
    PARAM ()
    #===================================================================================================
    #   Header
    #===================================================================================================
    Get-OSDStartTime
    Write-Host -ForegroundColor Green "Media: Copy Operating System to $WorkingPath"
    #===================================================================================================
    #   Execute
    #===================================================================================================
    Copy-Item -Path "$OSMediaPath\*" -Destination "$WorkingPath" -Exclude ('*.wim','*.iso','*.vhd','*.vhx') -Recurse -Force | Out-Null
    if (Test-Path "$WorkingPath\ISO") {Remove-Item -Path "$WorkingPath\ISO" -Force -Recurse | Out-Null}
    if (Test-Path "$WorkingPath\VHD") {Remove-Item -Path "$WorkingPath\VHD" -Force -Recurse | Out-Null}
    Copy-Item -Path "$OSMediaPath\OS\sources\install.wim" -Destination "$WimTemp\install.wim" -Force | Out-Null
    Copy-Item -Path "$OSMediaPath\WinPE\*.wim" -Destination "$WimTemp" -Exclude boot.wim -Force | Out-Null
    #===================================================================================================
}
function Disable-OSDWindowsOptionalFeature {
    [CmdletBinding()]
    PARAM ()
    #===================================================================================================
    #   Header
    #===================================================================================================
    Get-OSDStartTime
    Write-Host -ForegroundColor Green "Install.wim: Disable Windows Optional Feature"
    #===================================================================================================
    #   Execute
    #===================================================================================================
    foreach ($FeatureName in $DisableFeature) {
        Write-Host $FeatureName -ForegroundColor DarkGray
        Try {
            Disable-WindowsOptionalFeature -FeatureName $FeatureName -Path "$MountDirectory" -LogPath "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Disable-WindowsOptionalFeature.log" | Out-Null
        }
        Catch {
            $ErrorMessage = $_.Exception.Message
            Write-Warning "$ErrorMessage"
        }
    }
    #===================================================================================================
}
function Dismount-OSDWimOS {
    [CmdletBinding()]
    PARAM ()
    #===================================================================================================
    #   Header
    #===================================================================================================
    Get-OSDStartTime
    Write-Host -ForegroundColor Green "Install.wim: Dismount from $MountDirectory"
    #===================================================================================================
    #   Execute
    #===================================================================================================
    if ($WaitDismount.IsPresent){[void](Read-Host 'Press Enter to Continue')}
    $CurrentLog = "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Dismount-WindowsImage.log"
    Write-Verbose "CurrentLog: $CurrentLog"
    Start-Sleep -Seconds 10
    try {
        Dismount-WindowsImage -Path "$MountDirectory" -Save -LogPath "$CurrentLog" -ErrorAction SilentlyContinue | Out-Null
    }
    catch {
        Write-Warning "Could not dismount Install.wim ... Waiting 30 seconds ..."
        Start-Sleep -Seconds 30
        Dismount-WindowsImage -Path "$MountDirectory" -Save -LogPath "$CurrentLog" | Out-Null
    }
    #===================================================================================================
}

function Dismount-OSDWimPE {
    [CmdletBinding()]
    PARAM (
        [string]$OSMediaPath
    )
    #===================================================================================================
    #   Header
    #===================================================================================================
    Get-OSDStartTime
    Write-Host -ForegroundColor Green "WinPE: Dismount Wims"
    #===================================================================================================
    #   Execute
    #===================================================================================================
    Start-Sleep -Seconds 10
    
    Write-Verbose "$MountWinPE"
    $CurrentLog = "$OSMediaPath\WinPE\info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Dismount-WindowsImage-WinPE.log"
    Write-Verbose "CurrentLog: $CurrentLog"
    try {
        Dismount-WindowsImage -Path "$MountWinPE" -Save -LogPath "$CurrentLog" -ErrorAction SilentlyContinue | Out-Null
    }
    catch {
        Write-Warning "Could not dismount WinPE ... Waiting 30 seconds ..."
        Start-Sleep -Seconds 30
        Dismount-WindowsImage -Path "$MountWinPE" -Save -LogPath "$CurrentLog" | Out-Null
    }
    
    Write-Verbose "$MountWinRE"
    $CurrentLog = "$OSMediaPath\WinPE\info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Dismount-WindowsImage-WinRE.log"
    Write-Verbose "CurrentLog: $CurrentLog"
    try {
        Dismount-WindowsImage -Path "$MountWinRE" -Save -LogPath "$CurrentLog" -ErrorAction SilentlyContinue | Out-Null
    }
    catch {
        Write-Warning "Could not dismount WinRE ... Waiting 30 seconds ..."
        Start-Sleep -Seconds 30
        Dismount-WindowsImage -Path "$MountWinRE" -Save -LogPath "$CurrentLog" | Out-Null
    }
    
    Write-Verbose "$MountWinSE"
    $CurrentLog = "$OSMediaPath\WinPE\info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Dismount-WindowsImage-WinSE.log"
    Write-Verbose "CurrentLog: $CurrentLog"
    try {
        Dismount-WindowsImage -Path "$MountWinSE" -Save -LogPath "$CurrentLog" -ErrorAction SilentlyContinue | Out-Null
    }
    catch {
        Write-Warning "Could not dismount WinSE ... Waiting 30 seconds ..."
        Start-Sleep -Seconds 30
        Dismount-WindowsImage -Path "$MountWinSE" -Save -LogPath "$CurrentLog" | Out-Null
    }
    #===================================================================================================
}
function Enable-OSDNetFX {
    [CmdletBinding()]
    PARAM ()
    #===================================================================================================
    #   Return
    #===================================================================================================
    if ($OSMajorVersion -ne 10) {Return}
    #===================================================================================================
    #   Header
    #===================================================================================================
    Get-OSDStartTime
    Write-Host -ForegroundColor Green "Install.wim: Enable NetFX 3.5"
    #===================================================================================================
    #   Execute
    #===================================================================================================
    Try {
        Enable-WindowsOptionalFeature -Path "$MountDirectory" -FeatureName NetFX3 -All -LimitAccess -Source "$OS\sources\sxs" -LogPath "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-NetFX3.log" | Out-Null
    }
    Catch {
        $ErrorMessage = $_.Exception.Message
        Write-Warning "$ErrorMessage"
    }
    #===================================================================================================
    #   Post Action
    #===================================================================================================
    Update-OSDotNet
    Update-OSCumulativeForce
    #===================================================================================================
}

function Enable-OSDWindowsOptionalFeature {
    [CmdletBinding()]
    PARAM ()
    #===================================================================================================
    #   Header
    #===================================================================================================
    Get-OSDStartTime
    Write-Host -ForegroundColor Green "Install.wim: Enable Windows Optional Feature"
    #===================================================================================================
    #   Execute
    #===================================================================================================
    foreach ($FeatureName in $EnableFeature) {
        Write-Host $FeatureName -ForegroundColor DarkGray
        Try {
            Enable-WindowsOptionalFeature -FeatureName $FeatureName -Path "$MountDirectory" -All -LogPath "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Enable-WindowsOptionalFeature.log" | Out-Null
        }
        Catch {
            $ErrorMessage = $_.Exception.Message
            Write-Warning "$ErrorMessage"
        }
    }
    #===================================================================================================
    #   Post Action
    #===================================================================================================
    Update-OSCumulativeForce
    Use-DismCleanupImage
    #===================================================================================================
}
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

function Mount-WimInstall {
    [CmdletBinding()]
    PARAM ()
    #===================================================================================================
    #   Header
    #===================================================================================================
    Get-OSDStartTime
    Write-Host -ForegroundColor Green "Install.wim: Mount to $MountDirectory"
    #===================================================================================================
    #   Execute
    #===================================================================================================
    $CurrentLog = "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Mount-WindowsImage.log"
    Write-Verbose "CurrentLog: $CurrentLog"
    Mount-WindowsImage -ImagePath "$WimTemp\install.wim" -Index 1 -Path "$MountDirectory" -LogPath "$CurrentLog" | Out-Null
}
function Mount-WimWinPE {
    [CmdletBinding()]
    PARAM (
        [string]$OSMediaPath
    )
    #===================================================================================================
    #   Header
    #===================================================================================================
    Get-OSDStartTime
    Write-Host -ForegroundColor Green "WinPE.wim: Mount to $MountWinPE"
    #===================================================================================================
    #   Execute
    #===================================================================================================
    $CurrentLog = "$OSMediaPath\WinPE\info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Mount-WindowsImage-WinPE.log"
    Write-Verbose "CurrentLog: $CurrentLog"
    Mount-WindowsImage -ImagePath "$OSMediaPath\WimTemp\winpe.wim" -Index 1 -Path "$MountWinPE" -LogPath "$CurrentLog" | Out-Null
}
function Mount-WimWinRE {
    [CmdletBinding()]
    PARAM (
        [string]$OSMediaPath
    )
    #===================================================================================================
    #   Header
    #===================================================================================================
    Get-OSDStartTime
    Write-Host -ForegroundColor Green "WinRE.wim: Mount to $MountWinRE"
    #===================================================================================================
    #   Execute
    #===================================================================================================
    $CurrentLog = "$OSMediaPath\WinPE\info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Mount-WindowsImage-WinRE.log"
    Write-Verbose "CurrentLog: $CurrentLog"
    Mount-WindowsImage -ImagePath "$OSMediaPath\WimTemp\winre.wim" -Index 1 -Path "$MountWinRE" -LogPath "$CurrentLog" | Out-Null
}
function Mount-WimWinSE {
    [CmdletBinding()]
    PARAM (
        [string]$OSMediaPath
    )
    #===================================================================================================
    #   Header
    #===================================================================================================
    Get-OSDStartTime
    Write-Host -ForegroundColor Green "WinSE.wim: Mount to $MountWinSE"
    #===================================================================================================
    #   Execute
    #===================================================================================================
    $CurrentLog = "$OSMediaPath\WinPE\info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Mount-WindowsImage-WinSE.log"
    Write-Verbose "CurrentLog: $CurrentLog"
    Mount-WindowsImage -ImagePath "$OSMediaPath\WimTemp\winse.wim" -Index 1 -Path "$MountWinSE" -LogPath "$CurrentLog" | Out-Null
}
function Update-MediaSetup {
    [CmdletBinding()]
    PARAM ()
    #===================================================================================================
    #   Header
    #===================================================================================================
    Get-OSDStartTime
    Write-Host -ForegroundColor Green "Media: Setup Update"
    #===================================================================================================
    #   Execute
    #===================================================================================================
    if (!($null -eq $OSDUpdateSetupDU)) {
        foreach ($Update in $OSDUpdateSetupDU) {
            $OSDUpdateSetupDU = $(Get-ChildItem -Path $OSDBuilderContent\OSDUpdate -File -Recurse | Where-Object {$_.Name -eq $($Update.FileName)}).FullName
            $OSDUpdateSetupDU
            if (Test-Path "$OSDUpdateSetupDU") {
                expand.exe "$OSDUpdateSetupDU" -F:*.* "$OS\Sources"
            } else {
                Write-Warning "Not Found: $OSDUpdateSetupDU ... Skipping Update"
            }
        }
    }
}
function Update-OSAdobe {
    [CmdletBinding()]
    PARAM ()
    #===================================================================================================
    #   Abort
    #===================================================================================================
    if ($OSMajorVersion -ne 10) {Return}
    if ($SkipUpdates) {Return}
    #===================================================================================================
    #   Header
    #===================================================================================================
    Get-OSDStartTime
    Write-Host -ForegroundColor Green "Install.wim: (ASU) Adobe Flash Player Security Update"
    #===================================================================================================
    #   Execute
    #===================================================================================================
    foreach ($Update in $OSDUpdateAdobeSU) {
        $UpdateASU = @()
        $UpdateASU = $(Get-ChildItem -Path $OSDBuilderContent\OSDUpdate -Directory -Recurse | Where-Object {$_.Name -eq $($Update.Title)}).FullName
        if (Test-Path "$UpdateASU") {
            Write-Host "$UpdateASU" -ForegroundColor Gray
            if (Get-WindowsPackage -Path "$MountDirectory" | Where-Object {$_.PackageName -like "*$($Update.KBNumber)*"}) {
                Write-Warning "KB$($Update.KBNumber) is already installed"
            } else {
                $CurrentLog = "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-AdobeFlashPlayer-KB$($Update.KBNumber).log"
                Write-Verbose "CurrentLog: $CurrentLog"
                Try {Add-WindowsPackage -Path "$MountDirectory" -PackagePath "$UpdateASU" -LogPath "$CurrentLog" | Out-Null}
                Catch {
                    $ErrorMessage = $_.Exception.$ErrorMessage
                    Write-Host "$ErrorMessage"
                    if ($ErrorMessage -like "*0x800f081e*") {Write-Warning "Update not applicable to this Operating System"}
                }
            }
        } else {
            Write-Warning "Not Found: $UpdateASU"
        }
    }
}
function Update-OSComponent {
    [CmdletBinding()]
    PARAM ()
    #===================================================================================================
    #   Abort
    #===================================================================================================
    if ($SkipUpdates) {Return}
    #===================================================================================================
    #   Header
    #===================================================================================================
    Get-OSDStartTime
    Write-Host -ForegroundColor Green "Install.wim: Component Update"
    #===================================================================================================
    #   Execute
    #===================================================================================================
    foreach ($Update in $OSDUpdateComponentDU) {
        $UpdateComp = $(Get-ChildItem -Path $OSDBuilderContent\OSDUpdate -Directory -Recurse | Where-Object {$_.Name -eq $($Update.Title)}).FullName
        if (Test-Path "$UpdateComp") {
            Write-Host "$UpdateComp" -ForegroundColor Gray
            if (Get-WindowsPackage -Path "$MountDirectory" | Where-Object {$_.PackageName -like "*$($Update.KBNumber)*"}) {
                Write-Warning "KB$($Update.KBNumber) is already installed"
            } else {
                $CurrentLog = "$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Component-KB$($Update.KBNumber).log"
                Write-Verbose "CurrentLog: $CurrentLog"
                Try {Add-WindowsPackage -Path "$MountDirectory" -PackagePath "$UpdateComp" -LogPath "$CurrentLog" | Out-Null}
                Catch {
                    $ErrorMessage = $_.Exception.$ErrorMessage
                    Write-Host "$ErrorMessage"
                    if ($ErrorMessage -like "*0x800f081e*") {Write-Warning "Update not applicable to this Operating System"}
                }
            }
        } else {
            Write-Warning "Not Found: $UpdateComp"
        }
    }
}
function Update-OSCumulative {
    [CmdletBinding()]
    PARAM ()
    #===================================================================================================
    #   Abort
    #===================================================================================================
    if ($SkipUpdates) {Return}
    if ($OSMajorVersion -ne 10) {Return}
    #===================================================================================================
    #   Header
    #===================================================================================================
    Get-OSDStartTime
    Write-Host -ForegroundColor Green "Install.wim: (LCU) Latest Cumulative Update"
    #===================================================================================================
    #   Execute
    #===================================================================================================
    foreach ($Update in $OSDUpdateLCU) {
        $UpdateLCU = $(Get-ChildItem -Path $OSDBuilderContent\OSDUpdate -Directory -Recurse | Where-Object {$_.Name -eq $($Update.Title)}).FullName
        if (Test-Path "$UpdateLCU") {
            Write-Host "$UpdateLCU" -ForegroundColor Gray
            $SessionsXmlInstall = "$MountDirectory\Windows\Servicing\Sessions\Sessions.xml"
            if (Test-Path $SessionsXmlInstall) {
                [xml]$XmlDocument = Get-Content -Path $SessionsXmlInstall
                if ($XmlDocument.Sessions.Session.Tasks.Phase.package | Where-Object {$_.Name -like "*$($Update.KBNumber)*" -and $_.targetState -eq 'Installed'}) {
                    Write-Warning "KB$($Update.KBNumber) is already installed"
                } else {
                    Add-WindowsPackage -Path "$MountDirectory" -PackagePath "$UpdateLCU" -LogPath "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-UpdateCumulative-KB$($Update.KBNumber).log" | Out-Null
                }
            } else {
                $CurrentLog = "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-UpdateCumulative-KB$($Update.KBNumber).log"
                Write-Verbose "CurrentLog: $CurrentLog"
                Try {Add-WindowsPackage -Path "$MountDirectory" -PackagePath "$UpdateLCU" -LogPath "$CurrentLog" | Out-Null}
                Catch {
                    $ErrorMessage = $_.Exception.$ErrorMessage
                    Write-Host "$ErrorMessage"
                    if ($ErrorMessage -like "*0x800f081e*") {Write-Warning "Update not applicable to this Operating System"}
                }
            }
        } else {
            Write-Warning "Not Found: $UpdateLCU"
        }
    }
}
function Update-OSCumulativeForce {
    [CmdletBinding()]
    PARAM ()
    #===================================================================================================
    #   Abort
    #===================================================================================================
    if ($SkipUpdates) {Return}
    if ($OSMajorVersion -ne 10) {Return}
    #===================================================================================================
    #   Header
    #===================================================================================================
    Get-OSDStartTime
    Write-Host -ForegroundColor Green "Install.wim: (LCU) Latest Cumulative Update Forced"
    #===================================================================================================
    #   Execute
    #===================================================================================================
    foreach ($Update in $OSDUpdateLCU) {
        $UpdateCU = $(Get-ChildItem -Path $OSDBuilderContent\OSDUpdate -Directory -Recurse | Where-Object {$_.Name -eq $($Update.Title)}).FullName
        if (Test-Path "$UpdateCU") {
            Write-Host "$UpdateCU" -ForegroundColor Gray
            $CurrentLog = "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Cumulative-KB$($Update.KBNumber).log"
            Write-Verbose "CurrentLog: $CurrentLog"
            Try {Add-WindowsPackage -Path "$MountDirectory" -PackagePath "$UpdateCU" -LogPath "$CurrentLog" | Out-Null}
            Catch {
                $ErrorMessage = $_.Exception.$ErrorMessage
                Write-Host "$ErrorMessage"
                if ($ErrorMessage -like "*0x800f081e*") {Write-Warning "Update not applicable to this Operating System"}
            }
        } else {
            Write-Warning "Not Found: $UpdateCU"
        }
    }
}
function Update-OSDotNet {
    [CmdletBinding()]
    PARAM ()
    #===================================================================================================
    #   Abort
    #===================================================================================================
    if ($SkipUpdates) {Return}
    if ($OSMajorVersion -ne 10) {Return}
    #===================================================================================================
    #   Header
    #===================================================================================================
    Get-OSDStartTime
    Write-Host -ForegroundColor Green "Install.wim: (NetCU) DotNet Framework Cumulative Update"
    #===================================================================================================
    #   Execute
    #===================================================================================================
    foreach ($Update in $OSDUpdateDotNet) {
        $UpdateNetCU = $(Get-ChildItem -Path $OSDBuilderContent\OSDUpdate -Directory -Recurse | Where-Object {$_.Name -eq $($Update.Title)}).FullName
        if (Test-Path "$UpdateNetCU") {
            Write-Host "$UpdateNetCU" -ForegroundColor Gray
            $CurrentLog = "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-DotNet-KB$($Update.KBNumber).log"
            Write-Verbose "CurrentLog: $CurrentLog"
            Try {Add-WindowsPackage -Path "$MountDirectory" -PackagePath "$UpdateNetCU" -LogPath "$CurrentLog" | Out-Null}
            Catch {
                $ErrorMessage = $_.Exception.$ErrorMessage
                Write-Host "$ErrorMessage"
                if ($ErrorMessage -like "*0x800f081e*") {Write-Warning "Update not applicable to this Operating System"}
            }
        } else {
            Write-Warning "Not Found: $UpdateNetCU"
        }
    }
}
function Update-OSServicingStack {
    [CmdletBinding()]
    PARAM ()
    #===================================================================================================
    #   Abort
    #===================================================================================================
    if ($SkipUpdates) {Return}
    if ($OSMajorVersion -ne 10) {Return}
    #===================================================================================================
    #   Header
    #===================================================================================================
    Get-OSDStartTime
    Write-Host -ForegroundColor Green "Install.wim: (SSU) Servicing Stack Update"
    #===================================================================================================
    #   Execute
    #===================================================================================================
    foreach ($Update in $OSDUpdateSSU) {
        $UpdateSSU = $(Get-ChildItem -Path $OSDBuilderContent\OSDUpdate -Directory -Recurse | Where-Object {$_.Name -eq $($Update.Title)}).FullName
        if (Test-Path "$UpdateSSU") {
            Write-Host "$UpdateSSU" -ForegroundColor Gray
            if (Get-WindowsPackage -Path "$MountDirectory" | Where-Object {$_.PackageName -like "*$($Update.KBNumber)*"}) {
                Write-Warning "KB$($Update.KBNumber) is already installed"
            } else {
                $CurrentLog = "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-ServicingStack-KB$($Update.KBNumber).log"
                Write-Verbose "CurrentLog: $CurrentLog"
                Try {Add-WindowsPackage -Path "$MountDirectory" -PackagePath "$UpdateSSU" -LogPath "$CurrentLog" | Out-Null}
                Catch {
                    $ErrorMessage = $_.Exception.$ErrorMessage
                    Write-Host "$ErrorMessage"
                    if ($ErrorMessage -like "*0x800f081e*") {Write-Warning "Update not applicable to this Operating System"}
                }
            }
        } else {
            Write-Warning "Not Found: $UpdateSSU"
        }
    }
}

function Update-OSServicingStackForce {
    [CmdletBinding()]
    PARAM ()
    #===================================================================================================
    #   Abort
    #===================================================================================================
    if ($SkipUpdates) {Return}
    if ($OSMajorVersion -ne 10) {Return}
    #===================================================================================================
    #   Header
    #===================================================================================================
    Get-OSDStartTime
    Write-Host -ForegroundColor Green "Install.wim: (SSU) Servicing Stack Update Forced"
    #===================================================================================================
    #   Execute
    #===================================================================================================
    foreach ($Update in $OSDUpdateSSU) {
        $UpdateSSU = $(Get-ChildItem -Path $OSDBuilderContent\OSDUpdate -Directory -Recurse | Where-Object {$_.Name -eq $($Update.Title)}).FullName
        if (Test-Path "$UpdateSSU") {
            Write-Host "$UpdateSSU" -ForegroundColor Gray
            $CurrentLog = "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-ServicingStack-KB$($Update.KBNumber).log"
            Write-Verbose "CurrentLog: $CurrentLog"
            Try {Add-WindowsPackage -Path "$MountDirectory" -PackagePath "$UpdateSSU" -LogPath "$CurrentLog" | Out-Null}
            Catch {
                $ErrorMessage = $_.Exception.$ErrorMessage
                Write-Host "$ErrorMessage"
                if ($ErrorMessage -like "*0x800f081e*") {Write-Warning "Update not applicable to this Operating System"}
            }
        } else {
            Write-Warning "Not Found: $UpdateSSU"
        }
    }
}



function Update-OSWindowsSeven {
    [CmdletBinding()]
    PARAM ()
    #===================================================================================================
    #   Abort
    #===================================================================================================
    if ($SkipUpdates) {Return}
    if ($OSMajorVersion -eq 10) {Return}
    #===================================================================================================
    #   Header
    #===================================================================================================
    Get-OSDStartTime
    Write-Host -ForegroundColor Green "Install.wim: Windows 7 Updates"
    #===================================================================================================
    #   Execute
    #===================================================================================================
    foreach ($Update in $OSDUpdateWinSeven) {
        $UpdateSeven = $(Get-ChildItem -Path $OSDBuilderContent\OSDUpdate -Directory -Recurse | Where-Object {$_.Name -eq $($Update.Title)}).FullName
        if (Test-Path "$UpdateSeven") {
            Write-Host "$UpdateSeven" -ForegroundColor Gray
            if (Get-WindowsPackage -Path "$MountDirectory" | Where-Object {$_.PackageName -like "*$($Update.KBNumber)*"}) {
                Write-Warning "KB$($Update.KBNumber) is already installed"
            } else {
                $CurrentLog = "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-UpdateSeven-KB$($Update.KBNumber).log"
                Write-Verbose "CurrentLog: $CurrentLog"
                Try {Add-WindowsPackage -Path "$MountDirectory" -PackagePath "$UpdateSeven" -LogPath "$CurrentLog" | Out-Null}
                Catch {
                    $ErrorMessage = $_.Exception.$ErrorMessage
                    Write-Host "$ErrorMessage"
                    if ($ErrorMessage -like "*0x800f081e*") {Write-Warning "Update not applicable to this Operating System"}
                }
            }
        } else {
            Write-Warning "Not Found: $UpdateSeven"
        }
    }
}
function Update-OSWindowsTwelveR2 {
    [CmdletBinding()]
    PARAM ()
    #===================================================================================================
    #   Abort
    #===================================================================================================
    if ($SkipUpdates) {Return}
    if ($OSMajorVersion -eq 10) {Return}
    #===================================================================================================
    #   Header
    #===================================================================================================
    Get-OSDStartTime
    Write-Host -ForegroundColor Green "Install.wim: Windows Server 2012 R2 Updates"
    #===================================================================================================
    #   Execute
    #===================================================================================================
    foreach ($Update in $OSDUpdateWinTwelveR2) {
        $UpdateTwelveR2 = $(Get-ChildItem -Path $OSDBuilderContent\OSDUpdate -Directory -Recurse | Where-Object {$_.Name -eq $($Update.Title)}).FullName
        if (Test-Path "$UpdateTwelveR2") {
            Write-Host "$UpdateTwelveR2" -ForegroundColor Gray
            if (Get-WindowsPackage -Path "$MountDirectory" | Where-Object {$_.PackageName -like "*$($Update.KBNumber)*"}) {
                Write-Warning "KB$($Update.KBNumber) is already installed"
            } else {
                $CurrentLog = "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-UpdateTwelveR2-KB$($Update.KBNumber).log"
                Write-Verbose "CurrentLog: $CurrentLog"
                Try {Add-WindowsPackage -Path "$MountDirectory" -PackagePath "$UpdateTwelveR2" -LogPath "$CurrentLog" | Out-Null}
                Catch {
                    $ErrorMessage = $_.Exception.$ErrorMessage
                    Write-Host "$ErrorMessage"
                    if ($ErrorMessage -like "*0x800f081e*") {Write-Warning "Update not applicable to this Operating System"}
                }
            }
        } else {
            Write-Warning "Not Found: $UpdateTwelveR2"
        }
    }
}
function Update-PEServicingStack {
    [CmdletBinding()]
    PARAM ()
    #===================================================================================================
    #   Header
    #===================================================================================================
    Get-OSDStartTime
    Write-Host -ForegroundColor Green "WinPE: (SSU) Servicing Stack Update"
    #===================================================================================================
    #   Return
    #===================================================================================================
    if ($OSMajorVersion -ne 10) {Return}
    if ($SkipUpdates) {
        Show-InfoSkipUpdates
        Return
    }
    #===================================================================================================
    #   Execute
    #===================================================================================================
    foreach ($Update in $OSDUpdateSSU) {
        $UpdateSSU = $(Get-ChildItem -Path $OSDBuilderContent\OSDUpdate -Directory -Recurse | Where-Object {$_.Name -eq $($Update.Title)}).FullName
        if (Test-Path "$UpdateSSU") {
            Write-Host "$UpdateSSU" -ForegroundColor Gray

            if (Get-WindowsPackage -Path "$MountWinPE" | Where-Object {$_.PackageName -like "*$($Update.KBNumber)*"}) {
                Write-Warning "WinPE.wim KB$($Update.KBNumber) is already installed"
            } else {
                $CurrentLog = "$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-ServicingStack-KB$($Update.KBNumber)-WinPE.log"
                Write-Verbose "CurrentLog: $CurrentLog"
                Try {Add-WindowsPackage -Path "$MountWinPE" -PackagePath "$UpdateSSU" -LogPath "$CurrentLog" | Out-Null}
                Catch {
                    $ErrorMessage = $_.Exception.$ErrorMessage
                    Write-Host "$ErrorMessage"
                    if ($ErrorMessage -like "*0x800f081e*") {Write-Warning "Update not applicable to this Operating System"}
                }
            }

            if (Get-WindowsPackage -Path "$MountWinRE" | Where-Object {$_.PackageName -like "*$($Update.KBNumber)*"}) {
                Write-Warning "WinRE.wim KB$($Update.KBNumber) is already installed"
            } else {
                $CurrentLog = "$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-ServicingStack-KB$($Update.KBNumber)-WinRE.log"
                Write-Verbose "CurrentLog: $CurrentLog"
                Try {Add-WindowsPackage -Path "$MountWinRE" -PackagePath "$UpdateSSU" -LogPath "$CurrentLog" | Out-Null}
                Catch {
                    $ErrorMessage = $_.Exception.$ErrorMessage
                    Write-Host "$ErrorMessage"
                    if ($ErrorMessage -like "*0x800f081e*") {Write-Warning "Update not applicable to this Operating System"}
                }
            }

            if (Get-WindowsPackage -Path "$MountWinSE" | Where-Object {$_.PackageName -like "*$($Update.KBNumber)*"}) {
                Write-Warning "WinSE.wim KB$($Update.KBNumber) is already installed"
            } else {
                $CurrentLog = "$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-ServicingStack-KB$($Update.KBNumber)-WinSE.log"
                Write-Verbose "CurrentLog: $CurrentLog"
                Try {Add-WindowsPackage -Path "$MountWinSE" -PackagePath "$UpdateSSU" -LogPath "$CurrentLog" | Out-Null}
                Catch {
                    $ErrorMessage = $_.Exception.$ErrorMessage
                    Write-Host "$ErrorMessage"
                    if ($ErrorMessage -like "*0x800f081e*") {Write-Warning "Update not applicable to this Operating System"}
                }
            }
        } else {
            Write-Warning "Not Found: $UpdateSSU"
        }
    }
}

function Update-PEServicingStackForce {
    [CmdletBinding()]
    PARAM ()
    #===================================================================================================
    #   Header
    #===================================================================================================
    Get-OSDStartTime
    Write-Host -ForegroundColor Green "WinPE: (SSU) Servicing Stack Update Forced"
    #===================================================================================================
    #   Return
    #===================================================================================================
    if ($OSMajorVersion -ne 10) {Return}
    if ($SkipUpdates) {
        Show-InfoSkipUpdates
        Return
    }
    #===================================================================================================
    #   Execute
    #===================================================================================================
    foreach ($Update in $OSDUpdateSSU) {
        $UpdateSSU = $(Get-ChildItem -Path $OSDBuilderContent\OSDUpdate -Directory -Recurse | Where-Object {$_.Name -eq $($Update.Title)}).FullName

        if (Test-Path "$UpdateSSU") {
            Write-Host "$UpdateSSU" -ForegroundColor Gray
            $CurrentLog = "$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-ServicingStack-KB$($Update.KBNumber)-WinPE.log"
            Write-Verbose "CurrentLog: $CurrentLog"
            Try {Add-WindowsPackage -Path "$MountWinPE" -PackagePath "$UpdateSSU" -LogPath "$CurrentLog" | Out-Null}
            Catch {
                $ErrorMessage = $_.Exception.$ErrorMessage
                Write-Host "$ErrorMessage"
                if ($ErrorMessage -like "*0x800f081e*") {Write-Warning "Update not applicable to this Operating System"}
            }

            $CurrentLog = "$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-ServicingStack-KB$($Update.KBNumber)-WinRE.log"
            Write-Verbose "CurrentLog: $CurrentLog"
            Try {Add-WindowsPackage -Path "$MountWinRE" -PackagePath "$UpdateSSU" -LogPath "$CurrentLog" | Out-Null}
            Catch {
                $ErrorMessage = $_.Exception.$ErrorMessage
                Write-Host "$ErrorMessage"
                if ($ErrorMessage -like "*0x800f081e*") {Write-Warning "Update not applicable to this Operating System"}
            }

            $CurrentLog = "$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-ServicingStack-KB$($Update.KBNumber)-WinSE.log"
            Write-Verbose "CurrentLog: $CurrentLog"
            Try {Add-WindowsPackage -Path "$MountWinSE" -PackagePath "$UpdateSSU" -LogPath "$CurrentLog" | Out-Null}
            Catch {
                $ErrorMessage = $_.Exception.$ErrorMessage
                Write-Host "$ErrorMessage"
                if ($ErrorMessage -like "*0x800f081e*") {Write-Warning "Update not applicable to this Operating System"}
            }
        } else {
            Write-Warning "Not Found: $UpdateSSU ... Skipping Update"
        }
    }
}
function Update-PECumulative {
    [CmdletBinding()]
    PARAM ()
    #===================================================================================================
    #   Header
    #===================================================================================================
    Get-OSDStartTime
    Write-Host -ForegroundColor Green "WinPE: (LCU) Latest Cumulative Update"
    #===================================================================================================
    #   Return
    #===================================================================================================
    if ($SkipUpdates) {
        Show-InfoSkipUpdates
        Return
    }
<#     if ($OSBuild -eq 18362) {
        Write-Warning "Skip: Windows 10 1903 LCU error 0x80070002"
        Return
    } #>
    #===================================================================================================
    #   Execute
    #===================================================================================================
    foreach ($Update in $OSDUpdateLCU) {
        $UpdateLCU = $(Get-ChildItem -Path $OSDBuilderContent\OSDUpdate -Directory -Recurse | Where-Object {$_.Name -eq $($Update.Title)}).FullName
        if (Test-Path "$UpdateLCU") {
            Write-Host "$UpdateLCU" -ForegroundColor Gray

            #if (Get-WindowsPackage -Path "$MountWinPE" | Where-Object {$_.PackageName -like "*$($Update.KBNumber)*"}) {}
            $SessionsXmlWinPE = "$MountWinPE\Windows\Servicing\Sessions\Sessions.xml"
            if (Test-Path $SessionsXmlWinPE) {
                [xml]$XmlDocument = Get-Content -Path $SessionsXmlWinPE
                if ($XmlDocument.Sessions.Session.Tasks.Phase.package | Where-Object {$_.Name -like "*$($Update.KBNumber)*" -and $_.targetState -eq 'Installed'}) {
                    Write-Warning "WinPE.wim KB$($Update.KBNumber) is already installed"
                } else {
                    $CurrentLog = "$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-UpdateCumulative-KB$($Update.KBNumber)-WinPE.log"
                    Write-Verbose "CurrentLog: $CurrentLog"
                    Add-WindowsPackage -Path "$MountWinPE" -PackagePath "$UpdateLCU" -LogPath "$CurrentLog" | Out-Null
                    #Dism /Image:"$MountWinPE" /Add-Package /PackagePath:"$UpdateLCU" /LogPath:"$CurrentLog"
                    if (!($OSVersion -like "6.1.7601.*")) {
                        $CurrentLog = "$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-DismCleanupImage-WinPE.log"
                        Write-Verbose "CurrentLog: $CurrentLog"
                        if ($SkipComponentCleanup) {
                            Write-Warning "Skip: -SkipComponentCleanup Parameter was used"
                        } else {
                            Dism /Image:"$MountWinPE" /Cleanup-Image /StartComponentCleanup /ResetBase /LogPath:"$CurrentLog"
                        }
                    }
                }
            } else {
                $CurrentLog = "$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-UpdateCumulative-KB$($Update.KBNumber)-WinPE.log"
                Write-Verbose "CurrentLog: $CurrentLog"
                Add-WindowsPackage -Path "$MountWinPE" -PackagePath "$UpdateLCU" -LogPath "$CurrentLog" | Out-Null
                if (!($OSVersion -like "6.1.7601.*")) {
                    $CurrentLog = "$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-DismCleanupImage-WinPE.log"
                    Write-Verbose "CurrentLog: $CurrentLog"
                    if ($SkipComponentCleanup) {
                        Write-Warning "Skip: -SkipComponentCleanup Parameter was used"
                    } else {
                        Dism /Image:"$MountWinPE" /Cleanup-Image /StartComponentCleanup /ResetBase /LogPath:"$CurrentLog"
                    }
                }
            }

            #if (Get-WindowsPackage -Path "$MountWinRE" | Where-Object {$_.PackageName -like "*$($Update.KBNumber)*"}) {}
            $SessionsXmlWinRE = "$MountWinRE\Windows\Servicing\Sessions\Sessions.xml"
            if (Test-Path $SessionsXmlWinRE) {
                [xml]$XmlDocument = Get-Content -Path $SessionsXmlWinRE
                if ($XmlDocument.Sessions.Session.Tasks.Phase.package | Where-Object {$_.Name -like "*$($Update.KBNumber)*" -and $_.targetState -eq 'Installed'}) {
                    Write-Warning "WinRE.wim KB$($Update.KBNumber) is already installed"
                } else {
                    $CurrentLog = "$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-UpdateCumulative-KB$($Update.KBNumber)-WinRE.log"
                    Write-Verbose "CurrentLog: $CurrentLog"
                    Add-WindowsPackage -Path "$MountWinRE" -PackagePath "$UpdateLCU" -LogPath "$CurrentLog" | Out-Null
                    if (!($OSVersion -like "6.1.7601.*")) {
                        $CurrentLog = "$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-DismCleanupImage-WinRE.log"
                        Write-Verbose "CurrentLog: $CurrentLog"
                        if ($SkipComponentCleanup) {
                            Write-Warning "Skip: -SkipComponentCleanup Parameter was used"
                        } else {
                            Dism /Image:"$MountWinRE" /Cleanup-Image /StartComponentCleanup /ResetBase /LogPath:"$CurrentLog"
                        }
                    }
                }
            } else {
                $CurrentLog = "$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-UpdateCumulative-KB$($Update.KBNumber)-WinRE.log"
                Write-Verbose "CurrentLog: $CurrentLog"
                Add-WindowsPackage -Path "$MountWinRE" -PackagePath "$UpdateLCU" -LogPath "$CurrentLog" | Out-Null
                if (!($OSVersion -like "6.1.7601.*")) {
                    $CurrentLog = "$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-DismCleanupImage-WinRE.log"
                    Write-Verbose "CurrentLog: $CurrentLog"
                    if ($SkipComponentCleanup) {
                        Write-Warning "Skip: -SkipComponentCleanup Parameter was used"
                    } else {
                        Dism /Image:"$MountWinRE" /Cleanup-Image /StartComponentCleanup /ResetBase /LogPath:"$CurrentLog"
                    }
                }
            }

            #if (Get-WindowsPackage -Path "$MountWinSE" | Where-Object {$_.PackageName -like "*$($Update.KBNumber)*"}) {}
            $SessionsXmlSetup = "$MountWinSE\Windows\Servicing\Sessions\Sessions.xml"
            if (Test-Path $SessionsXmlSetup) {
                [xml]$XmlDocument = Get-Content -Path $SessionsXmlSetup
                if ($XmlDocument.Sessions.Session.Tasks.Phase.package | Where-Object {$_.Name -like "*$($Update.KBNumber)*" -and $_.targetState -eq 'Installed'}) {
                    Write-Warning "WinSE.wim KB$($Update.KBNumber) is already installed"
                } else {
                    $CurrentLog = "$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-UpdateCumulative-KB$($Update.KBNumber)-WinSE.log"
                    Write-Verbose "CurrentLog: $CurrentLog"
                    Add-WindowsPackage -Path "$MountWinSE" -PackagePath "$UpdateLCU" -LogPath "$CurrentLog" | Out-Null
                    if (!($OSVersion -like "6.1.7601.*")) {
                        $CurrentLog = "$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-DismCleanupImage-WinSE.log"
                        Write-Verbose "CurrentLog: $CurrentLog"
                        if ($SkipComponentCleanup) {
                            Write-Warning "Skip: -SkipComponentCleanup Parameter was used"
                        } else {
                            Dism /Image:"$MountWinSE" /Cleanup-Image /StartComponentCleanup /ResetBase /LogPath:"$CurrentLog"
                        }
                    }
                }
            } else {
                $CurrentLog = "$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-UpdateCumulative-KB$($Update.KBNumber)-WinSE.log"
                Write-Verbose "CurrentLog: $CurrentLog"
                Add-WindowsPackage -Path "$MountWinSE" -PackagePath "$UpdateLCU" -LogPath "$CurrentLog" | Out-Null
                if (!($OSVersion -like "6.1.7601.*")) {
                    $CurrentLog = "$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-DismCleanupImage-WinSE.log"
                    Write-Verbose "CurrentLog: $CurrentLog"
                    if ($SkipComponentCleanup) {
                        Write-Warning "Skip: -SkipComponentCleanup Parameter was used"
                    } else {
                        Dism /Image:"$MountWinSE" /Cleanup-Image /StartComponentCleanup /ResetBase /LogPath:"$CurrentLog"
                    }
                }
            }
        } else {
            Write-Warning "Not Found: $UpdateLCU"
        }
    }
}
function Update-PECumulativeForce {
    [CmdletBinding()]
    PARAM ()
    #===================================================================================================
    #   Header
    #===================================================================================================
    Get-OSDStartTime
    Write-Host -ForegroundColor Green "WinPE: (LCU) Latest Cumulative Update Forced"
    #===================================================================================================
    #   Return
    #===================================================================================================
    if ($SkipUpdates) {
        Show-InfoSkipUpdates
        Return
    }
<#     if ($OSBuild -eq 18362) {
        Write-Warning "Skip: Windows 10 1903 LCU error 0x80070002"
        Return
    } #>
    #===================================================================================================
    #   Execute
    #===================================================================================================
    if (!($null -eq $OSDUpdateLCU)) {
        foreach ($Update in $OSDUpdateLCU) {
            $UpdateLCU = $(Get-ChildItem -Path $OSDBuilderContent\OSDUpdate -Directory -Recurse | Where-Object {$_.Name -eq $($Update.Title)}).FullName
            if (Test-Path "$UpdateLCU") {
                Write-Host "$UpdateLCU" -ForegroundColor Gray

                $CurrentLog = "$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-UpdateCumulative-KB$($Update.KBNumber)-WinPE.log"
                Write-Verbose "CurrentLog: $CurrentLog"
                Add-WindowsPackage -Path "$MountWinPE" -PackagePath "$UpdateLCU" -LogPath "$CurrentLog" | Out-Null
                #Dism /Image:"$MountWinPE" /Add-Package /PackagePath:"$UpdateLCU" /LogPath:"$CurrentLog"

                if (!($OSVersion -like "6.1.7601.*")) {
                    $CurrentLog = "$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-DismCleanupImage-WinPE.log"
                    Write-Verbose "CurrentLog: $CurrentLog"
                    if ($SkipComponentCleanup) {
                        Write-Warning "Skip: -SkipComponentCleanup Parameter was used"
                    } else {
                        Dism /Image:"$MountWinPE" /Cleanup-Image /StartComponentCleanup /ResetBase /LogPath:"$CurrentLog"
                    }
                }

                $CurrentLog = "$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-UpdateCumulative-KB$($Update.KBNumber)-WinRE.log"
                Write-Verbose "CurrentLog: $CurrentLog"
                Add-WindowsPackage -Path "$MountWinRE" -PackagePath "$UpdateLCU" -LogPath "$CurrentLog" | Out-Null
                if (!($OSVersion -like "6.1.7601.*")) {
                    $CurrentLog = "$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-DismCleanupImage-WinRE.log"
                    Write-Verbose "CurrentLog: $CurrentLog"
                    if ($SkipComponentCleanup) {
                        Write-Warning "Skip: -SkipComponentCleanup Parameter was used"
                    } else {
                        Dism /Image:"$MountWinRE" /Cleanup-Image /StartComponentCleanup /ResetBase /LogPath:"$CurrentLog"
                    }
                }

                $CurrentLog = "$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-UpdateCumulative-KB$($Update.KBNumber)-WinSE.log"
                Write-Verbose "CurrentLog: $CurrentLog"
                Add-WindowsPackage -Path "$MountWinSE" -PackagePath "$UpdateLCU" -LogPath "$CurrentLog" | Out-Null
                if (!($OSVersion -like "6.1.7601.*")) {
                    $CurrentLog = "$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-DismCleanupImage-WinSE.log"
                    Write-Verbose "CurrentLog: $CurrentLog"
                    if ($SkipComponentCleanup) {
                        Write-Warning "Skip: -SkipComponentCleanup Parameter was used"
                    } else {
                        Dism /Image:"$MountWinSE" /Cleanup-Image /StartComponentCleanup /ResetBase /LogPath:"$CurrentLog"
                    }
                }
            } else {
                Write-Warning "Not Found: $UpdateLCU"
            }
        }
    }
}
function Update-PEWindowsSeven {
    [CmdletBinding()]
    PARAM ()
    #===================================================================================================
    #   Header
    #===================================================================================================
    Get-OSDStartTime
    Write-Host -ForegroundColor Green "WinPE: Windows 7 Updates"
    #===================================================================================================
    #   Return
    #===================================================================================================
    if ($OSMajorVersion -eq 10) {Return}
    if ($SkipUpdates) {
        Show-InfoSkipUpdates
        Return
    }
    #===================================================================================================
    #   Execute
    #===================================================================================================
    foreach ($Update in $OSDUpdateWinSeven) {
        if ($Update.UpdateGroup -eq 'SSU' -or $Update.UpdateGroup -eq 'LCU') {
            $UpdateWinPESeven = $(Get-ChildItem -Path $OSDBuilderContent\OSDUpdate -Directory -Recurse | Where-Object {$_.Name -eq $($Update.Title)}).FullName
            if (Test-Path "$UpdateWinPESeven") {
                Write-Host "$UpdateWinPESeven" -ForegroundColor Gray
    
                if (Get-WindowsPackage -Path "$MountWinSE" | Where-Object {$_.PackageName -like "*$($Update.KBNumber)*"}) {
                    Write-Warning "WinSE.wim KB$($Update.KBNumber) is already installed"
                } else {
                    $CurrentLog = "$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-UpdateWinPESeven-KB$($Update.KBNumber)-WinSE.log"
                    Write-Verbose "CurrentLog: $CurrentLog"
                    Add-WindowsPackage -Path "$MountWinSE" -PackagePath "$UpdateWinPESeven" -LogPath "$CurrentLog" | Out-Null
                }
    
                if (Get-WindowsPackage -Path "$MountWinPE" | Where-Object {$_.PackageName -like "*$($Update.KBNumber)*"}) {
                    Write-Warning "WinPE.wim KB$($Update.KBNumber) is already installed"
                } else {
                    $CurrentLog = "$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-UpdateWinPESeven-KB$($Update.KBNumber)-WinPE.log"
                    Write-Verbose "CurrentLog: $CurrentLog"
                    Add-WindowsPackage -Path "$MountWinPE" -PackagePath "$UpdateWinPESeven" -LogPath "$CurrentLog" | Out-Null
                }
    
                if (Get-WindowsPackage -Path "$MountWinRE" | Where-Object {$_.PackageName -like "*$($Update.KBNumber)*"}) {
                    Write-Warning "WinRE.wim KB$($Update.KBNumber) is already installed"
                } else {
                    $CurrentLog = "$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-UpdateWinPESeven-KB$($Update.KBNumber)-WinRE.log"
                    Write-Verbose "CurrentLog: $CurrentLog"
                    Add-WindowsPackage -Path "$MountWinRE" -PackagePath "$UpdateWinPESeven" -LogPath "$CurrentLog" | Out-Null
                }
            } else {
                Write-Warning "Not Found: $UpdateWinPESeven ... Skipping Update"
            }
        }
    }
}
function Get-OSDStartTime {
    [CmdletBinding()]
    PARAM ()
    #===================================================================================================
    #   Get-OSDStartTime
    #===================================================================================================
    $Global:OSDStartTime = Get-Date
    Write-Host -ForegroundColor Gray "$(($Global:OSDStartTime).ToString('yyyy-MM-dd-HHmmss')) " -NoNewline
    #Write-Host -ForegroundColor DarkGray "[$(($Global:OSDStartTime).ToString('yyyy-MM-dd-HHmmss'))] " -NoNewline
    #===================================================================================================
}
function Show-OSDDuration {
    [CmdletBinding()]
    PARAM ()
    #===================================================================================================
    #   Show-OSDDuration
    #===================================================================================================
    $Global:OSDDuration = $(Get-Date) - $Global:OSDStartTime
    Write-Host -ForegroundColor DarkGray "Duration: $($Duration.ToString('mm\:ss'))"
    #===================================================================================================
}

function Show-InfoSkipUpdates {
    #Get-OSDStartTime
    #Write-Host -ForegroundColor DarkGray "                  -SkipUpdates Parameter was used"
}
