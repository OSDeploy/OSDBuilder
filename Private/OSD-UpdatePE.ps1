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