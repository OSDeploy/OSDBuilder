function OSD-UpdatesPE-Setup {
    [CmdletBinding()]
    PARAM ()
    #===================================================================================================
    Write-Verbose '19.1.1 Media: Setup Update'
    #===================================================================================================
    #Write-Host '========================================================================================' -ForegroundColor DarkGray
    Write-Host "Media: Setup Update" -ForegroundColor Green
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

function OSD-UpdatesPE-Seven {
    [CmdletBinding()]
    PARAM ()
    #===================================================================================================
    #   WinPE Seven
    #===================================================================================================
    Write-Host '========================================================================================' -ForegroundColor DarkGray
    Write-Host "WinPE: Seven Updates" -ForegroundColor Green
    foreach ($Update in $OSDUpdateWinSeven) {
        if ($Update.UpdateGroup -eq 'SSU' -or $Update.UpdateGroup -eq 'LCU') {
            $UpdateWinPESeven = $(Get-ChildItem -Path $OSDBuilderContent\OSDUpdate -Directory -Recurse | Where-Object {$_.Name -eq $($Update.Title)}).FullName
            if (Test-Path "$UpdateWinPESeven") {
                Write-Host "$UpdateWinPESeven" -ForegroundColor DarkGray
    
                if (Get-WindowsPackage -Path "$MountWinSE" | Where-Object {$_.PackageName -like "*$($Update.KBNumber)*"}) {
                    Write-Warning "WinSE.wim KB$($Update.KBNumber) is already installed"
                } else {
                    $CurrentLog = "$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-UpdateWinPESeven-KB$($Update.KBNumber)-WinSE.log"
                    Write-Verbose "$CurrentLog"
                    Add-WindowsPackage -Path "$MountWinSE" -PackagePath "$UpdateWinPESeven" -LogPath "$CurrentLog" | Out-Null
                }
    
                if (Get-WindowsPackage -Path "$MountWinPE" | Where-Object {$_.PackageName -like "*$($Update.KBNumber)*"}) {
                    Write-Warning "WinPE.wim KB$($Update.KBNumber) is already installed"
                } else {
                    $CurrentLog = "$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-UpdateWinPESeven-KB$($Update.KBNumber)-WinPE.log"
                    Write-Verbose "$CurrentLog"
                    Add-WindowsPackage -Path "$MountWinPE" -PackagePath "$UpdateWinPESeven" -LogPath "$CurrentLog" | Out-Null
                }
    
                if (Get-WindowsPackage -Path "$MountWinRE" | Where-Object {$_.PackageName -like "*$($Update.KBNumber)*"}) {
                    Write-Warning "WinRE.wim KB$($Update.KBNumber) is already installed"
                } else {
                    $CurrentLog = "$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-UpdateWinPESeven-KB$($Update.KBNumber)-WinRE.log"
                    Write-Verbose "$CurrentLog"
                    Add-WindowsPackage -Path "$MountWinRE" -PackagePath "$UpdateWinPESeven" -LogPath "$CurrentLog" | Out-Null
                }
            } else {
                Write-Warning "Not Found: $UpdateWinPESeven ... Skipping Update"
            }
        }
    }
}

function OSD-UpdatesPE-SSU {
    [CmdletBinding()]
    PARAM ()
    #===================================================================================================
    Write-Verbose '19.1.1 WinPE: Servicing Stack Update'
    #===================================================================================================
    Write-Host '========================================================================================' -ForegroundColor DarkGray
    Write-Host "WinPE: (SSU) Servicing Stack Update" -ForegroundColor Green

    if (!($null -eq $OSDUpdateSSU)) {
        foreach ($Update in $OSDUpdateSSU) {
            $UpdateSSU = $(Get-ChildItem -Path $OSDBuilderContent\OSDUpdate -Directory -Recurse | Where-Object {$_.Name -eq $($Update.Title)}).FullName
            if (Test-Path "$UpdateSSU") {
                Write-Host "$UpdateSSU" -ForegroundColor DarkGray

                if (Get-WindowsPackage -Path "$MountWinPE" | Where-Object {$_.PackageName -like "*$($Update.KBNumber)*"}) {
                    Write-Warning "WinPE.wim KB$($Update.KBNumber) is already installed"
                } else {
                    $CurrentLog = "$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-UpdateServicing-KB$($Update.KBNumber)-WinPE.log"
                    Write-Verbose "$CurrentLog"
                    Add-WindowsPackage -Path "$MountWinPE" -PackagePath "$UpdateSSU" -LogPath "$CurrentLog" | Out-Null
                }

                if (Get-WindowsPackage -Path "$MountWinRE" | Where-Object {$_.PackageName -like "*$($Update.KBNumber)*"}) {
                    Write-Warning "WinRE.wim KB$($Update.KBNumber) is already installed"
                } else {
                    $CurrentLog = "$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-UpdateServicing-KB$($Update.KBNumber)-WinRE.log"
                    Write-Verbose "$CurrentLog"
                    Add-WindowsPackage -Path "$MountWinRE" -PackagePath "$UpdateSSU" -LogPath "$CurrentLog" | Out-Null
                }

                if (Get-WindowsPackage -Path "$MountWinSE" | Where-Object {$_.PackageName -like "*$($Update.KBNumber)*"}) {
                    Write-Warning "WinSE.wim KB$($Update.KBNumber) is already installed"
                } else {
                    $CurrentLog = "$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-UpdateServicing-KB$($Update.KBNumber)-WinSE.log"
                    Write-Verbose "$CurrentLog"
                    Add-WindowsPackage -Path "$MountWinSE" -PackagePath "$UpdateSSU" -LogPath "$CurrentLog" | Out-Null
                }
            } else {
                Write-Warning "Not Found: $UpdateSSU ... Skipping Update"
            }
        }
    }
}

function OSD-UpdatesPE-SSUForce {
    [CmdletBinding()]
    PARAM ()
    #===================================================================================================
    Write-Verbose '19.1.28 WinPE: Servicing Stack Update Forced'
    #===================================================================================================
    Write-Host '========================================================================================' -ForegroundColor DarkGray
    Write-Host "WinPE: (SSU) Servicing Stack Update Forced" -ForegroundColor Green

    if (!($null -eq $OSDUpdateSSU)) {
        foreach ($Update in $OSDUpdateSSU) {
            $UpdateSSU = $(Get-ChildItem -Path $OSDBuilderContent\OSDUpdate -Directory -Recurse | Where-Object {$_.Name -eq $($Update.Title)}).FullName
            if (Test-Path "$UpdateSSU") {
                Write-Host "$UpdateSSU" -ForegroundColor DarkGray
                $CurrentLog = "$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-UpdateServicing-KB$($Update.KBNumber)-WinPE.log"
                Write-Verbose "$CurrentLog"
                Add-WindowsPackage -Path "$MountWinPE" -PackagePath "$UpdateSSU" -LogPath "$CurrentLog" | Out-Null

                $CurrentLog = "$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-UpdateServicing-KB$($Update.KBNumber)-WinRE.log"
                Write-Verbose "$CurrentLog"
                Add-WindowsPackage -Path "$MountWinRE" -PackagePath "$UpdateSSU" -LogPath "$CurrentLog" | Out-Null

                $CurrentLog = "$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-UpdateServicing-KB$($Update.KBNumber)-WinSE.log"
                Write-Verbose "$CurrentLog"
                Add-WindowsPackage -Path "$MountWinSE" -PackagePath "$UpdateSSU" -LogPath "$CurrentLog" | Out-Null
            } else {
                Write-Warning "Not Found: $UpdateSSU ... Skipping Update"
            }
        }
    }
}

function OSD-UpdatesPE-LCU {
    [CmdletBinding()]
    PARAM ()
    #===================================================================================================
    Write-Verbose '19.1.1 WinPE: (LCU) Latest Cumulative Update'
    #===================================================================================================
    Write-Host '========================================================================================' -ForegroundColor DarkGray
    Write-Host "WinPE: (LCU) Latest Cumulative Update" -ForegroundColor Green
    if (!($null -eq $OSDUpdateLCU)) {
        foreach ($Update in $OSDUpdateLCU) {
            $UpdateLCU = $(Get-ChildItem -Path $OSDBuilderContent\OSDUpdate -Directory -Recurse | Where-Object {$_.Name -eq $($Update.Title)}).FullName
            if (Test-Path "$UpdateLCU") {
                Write-Host "$UpdateLCU" -ForegroundColor DarkGray

                #if (Get-WindowsPackage -Path "$MountWinPE" | Where-Object {$_.PackageName -like "*$($Update.KBNumber)*"}) {}
                $SessionsXmlWinPE = "$MountWinPE\Windows\Servicing\Sessions\Sessions.xml"
                if (Test-Path $SessionsXmlWinPE) {
                    [xml]$XmlDocument = Get-Content -Path $SessionsXmlWinPE
                    if ($XmlDocument.Sessions.Session.Tasks.Phase.package | Where-Object {$_.Name -like "*$($Update.KBNumber)*" -and $_.targetState -eq 'Installed'}) {
                        Write-Warning "WinPE.wim KB$($Update.KBNumber) is already installed"
                    } else {
                        $CurrentLog = "$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-UpdateCumulative-KB$($Update.KBNumber)-WinPE.log"
                        Write-Verbose "$CurrentLog"
                        Add-WindowsPackage -Path "$MountWinPE" -PackagePath "$UpdateLCU" -LogPath "$CurrentLog" | Out-Null
                        if (!($OSVersion -like "6.1.7601.*")) {
                            $CurrentLog = "$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-DismCleanupImage-WinPE.log"
                            Write-Verbose "$CurrentLog"
                            Dism /Image:"$MountWinPE" /Cleanup-Image /StartComponentCleanup /ResetBase /LogPath:"$CurrentLog"
                        }
                    }
                } else {
                    $CurrentLog = "$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-UpdateCumulative-KB$($Update.KBNumber)-WinPE.log"
                    Write-Verbose "$CurrentLog"
                    Add-WindowsPackage -Path "$MountWinPE" -PackagePath "$UpdateLCU" -LogPath "$CurrentLog" | Out-Null
                    if (!($OSVersion -like "6.1.7601.*")) {
                        $CurrentLog = "$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-DismCleanupImage-WinPE.log"
                        Write-Verbose "$CurrentLog"
                        Dism /Image:"$MountWinPE" /Cleanup-Image /StartComponentCleanup /ResetBase /LogPath:"$CurrentLog"
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
                        Write-Verbose "$CurrentLog"
                        Add-WindowsPackage -Path "$MountWinRE" -PackagePath "$UpdateLCU" -LogPath "$CurrentLog" | Out-Null
                        if (!($OSVersion -like "6.1.7601.*")) {
                            $CurrentLog = "$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-DismCleanupImage-WinRE.log"
                            Write-Verbose "$CurrentLog"
                            Dism /Image:"$MountWinRE" /Cleanup-Image /StartComponentCleanup /ResetBase /LogPath:"$CurrentLog"
                        }
                    }
                } else {
                    $CurrentLog = "$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-UpdateCumulative-KB$($Update.KBNumber)-WinRE.log"
                    Write-Verbose "$CurrentLog"
                    Add-WindowsPackage -Path "$MountWinRE" -PackagePath "$UpdateLCU" -LogPath "$CurrentLog" | Out-Null
                    if (!($OSVersion -like "6.1.7601.*")) {
                        $CurrentLog = "$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-DismCleanupImage-WinRE.log"
                        Write-Verbose "$CurrentLog"
                        Dism /Image:"$MountWinRE" /Cleanup-Image /StartComponentCleanup /ResetBase /LogPath:"$CurrentLog"
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
                        Write-Verbose "$CurrentLog"
                        Add-WindowsPackage -Path "$MountWinSE" -PackagePath "$UpdateLCU" -LogPath "$CurrentLog" | Out-Null
                        if (!($OSVersion -like "6.1.7601.*")) {
                            $CurrentLog = "$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-DismCleanupImage-WinSE.log"
                            Write-Verbose "$CurrentLog"
                            Dism /Image:"$MountWinSE" /Cleanup-Image /StartComponentCleanup /ResetBase /LogPath:"$CurrentLog"
                        }
                    }
                } else {
                    $CurrentLog = "$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-UpdateCumulative-KB$($Update.KBNumber)-WinSE.log"
                    Write-Verbose "$CurrentLog"
                    Add-WindowsPackage -Path "$MountWinSE" -PackagePath "$UpdateLCU" -LogPath "$CurrentLog" | Out-Null
                    if (!($OSVersion -like "6.1.7601.*")) {
                        $CurrentLog = "$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-DismCleanupImage-WinSE.log"
                        Write-Verbose "$CurrentLog"
                        Dism /Image:"$MountWinSE" /Cleanup-Image /StartComponentCleanup /ResetBase /LogPath:"$CurrentLog"
                    }
                }
            } else {
                Write-Warning "Not Found: $UpdateLCU"
            }
        }
    }
}
function OSD-UpdatesPE-LCUForce {
    [CmdletBinding()]
    PARAM ()
    #===================================================================================================
    Write-Verbose '19.1.28 WinPE: (LCU) Latest Cumulative Update Forced'
    #===================================================================================================
    Write-Host '========================================================================================' -ForegroundColor DarkGray
    Write-Host "WinPE: (LCU) Latest Cumulative Update Forced" -ForegroundColor Green
    if (!($null -eq $OSDUpdateLCU)) {
        foreach ($Update in $OSDUpdateLCU) {
            $UpdateLCU = $(Get-ChildItem -Path $OSDBuilderContent\OSDUpdate -Directory -Recurse | Where-Object {$_.Name -eq $($Update.Title)}).FullName
            if (Test-Path "$UpdateLCU") {
                Write-Host "$UpdateLCU" -ForegroundColor DarkGray

                $CurrentLog = "$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-UpdateCumulative-KB$($Update.KBNumber)-WinPE.log"
                Write-Verbose "$CurrentLog"
                Add-WindowsPackage -Path "$MountWinPE" -PackagePath "$UpdateLCU" -LogPath "$CurrentLog" | Out-Null
                if (!($OSVersion -like "6.1.7601.*")) {
                    $CurrentLog = "$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-DismCleanupImage-WinPE.log"
                    Write-Verbose "$CurrentLog"
                    Dism /Image:"$MountWinPE" /Cleanup-Image /StartComponentCleanup /ResetBase /LogPath:"$CurrentLog"
                }

                $CurrentLog = "$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-UpdateCumulative-KB$($Update.KBNumber)-WinRE.log"
                Write-Verbose "$CurrentLog"
                Add-WindowsPackage -Path "$MountWinRE" -PackagePath "$UpdateLCU" -LogPath "$CurrentLog" | Out-Null
                if (!($OSVersion -like "6.1.7601.*")) {
                    $CurrentLog = "$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-DismCleanupImage-WinRE.log"
                    Write-Verbose "$CurrentLog"
                    Dism /Image:"$MountWinRE" /Cleanup-Image /StartComponentCleanup /ResetBase /LogPath:"$CurrentLog"
                }

                $CurrentLog = "$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-UpdateCumulative-KB$($Update.KBNumber)-WinSE.log"
                Write-Verbose "$CurrentLog"
                Add-WindowsPackage -Path "$MountWinSE" -PackagePath "$UpdateLCU" -LogPath "$CurrentLog" | Out-Null
                if (!($OSVersion -like "6.1.7601.*")) {
                    $CurrentLog = "$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-DismCleanupImage-WinSE.log"
                    Write-Verbose "$CurrentLog"
                    Dism /Image:"$MountWinSE" /Cleanup-Image /StartComponentCleanup /ResetBase /LogPath:"$CurrentLog"
                }
            } else {
                Write-Warning "Not Found: $UpdateLCU"
            }
        }
    }
}


