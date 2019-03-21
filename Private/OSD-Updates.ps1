function OSD-Updates-Component {
    [CmdletBinding()]
    PARAM ()
    #===================================================================================================
    #   Abort
    #===================================================================================================
    #===================================================================================================
    #   Header
    #===================================================================================================
    Write-Host '========================================================================================' -ForegroundColor DarkGray
    Write-Host "Install.wim: Component Update" -ForegroundColor Green
    #===================================================================================================
    #   Parameters
    #===================================================================================================
    if ($SkipUpdates) {
        Write-Warning "Skip: -SkipUpdates Parameter was used"
        Return
    }
    #===================================================================================================
    #   Execute
    #===================================================================================================
    foreach ($Update in $OSDUpdateComponentDU) {
        $UpdateComp = $(Get-ChildItem -Path $OSDBuilderContent\OSDUpdate -Directory -Recurse | Where-Object {$_.Name -eq $($Update.Title)}).FullName
        if (Test-Path "$UpdateComp") {
            Write-Host "$UpdateComp" -ForegroundColor DarkGray
            if (Get-WindowsPackage -Path "$MountDirectory" | Where-Object {$_.PackageName -like "*$($Update.KBNumber)*"}) {
                Write-Warning "KB$($Update.KBNumber) is already installed"
            } else {
                $CurrentLog = "$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Component-KB$($Update.KBNumber).log"
                Write-Verbose "$CurrentLog"
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
    #===================================================================================================
    #   End
    #===================================================================================================
}
function OSD-Updates-SSU {
    [CmdletBinding()]
    PARAM ()
    #===================================================================================================
    #   Abort
    #===================================================================================================
    if ($OSMajorVersion -ne 10) {Return}
    #===================================================================================================
    #   Header
    #===================================================================================================
    Write-Host '========================================================================================' -ForegroundColor DarkGray
    Write-Host "Install.wim: (SSU) Servicing Stack Update" -ForegroundColor Green
    #===================================================================================================
    #   Parameters
    #===================================================================================================
    if ($SkipUpdates) {
        Write-Warning "Skip: -SkipUpdates Parameter was used"
        Return
    }
    #===================================================================================================
    #   Execute
    #===================================================================================================
    foreach ($Update in $OSDUpdateSSU) {
        $UpdateSSU = $(Get-ChildItem -Path $OSDBuilderContent\OSDUpdate -Directory -Recurse | Where-Object {$_.Name -eq $($Update.Title)}).FullName
        if (Test-Path "$UpdateSSU") {
            Write-Host "$UpdateSSU" -ForegroundColor DarkGray
            if (Get-WindowsPackage -Path "$MountDirectory" | Where-Object {$_.PackageName -like "*$($Update.KBNumber)*"}) {
                Write-Warning "KB$($Update.KBNumber) is already installed"
            } else {
                $CurrentLog = "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-ServicingStack-KB$($Update.KBNumber).log"
                Write-Verbose "$CurrentLog"
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
    #===================================================================================================
    #   End
    #===================================================================================================
}

function OSD-Updates-SSUForce {
    [CmdletBinding()]
    PARAM ()
    #===================================================================================================
    #   Abort
    #===================================================================================================
    if ($OSMajorVersion -ne 10) {Return}
    #===================================================================================================
    #   Header
    #===================================================================================================
    Write-Host '========================================================================================' -ForegroundColor DarkGray
    Write-Host "Install.wim: (SSU) Servicing Stack Update Forced" -ForegroundColor Green
    #===================================================================================================
    #   Parameters
    #===================================================================================================
    if ($SkipUpdates) {
        Write-Warning "Skip: -SkipUpdates Parameter was used"
        Return
    }
    #===================================================================================================
    #   Execute
    #===================================================================================================
    foreach ($Update in $OSDUpdateSSU) {
        $UpdateSSU = $(Get-ChildItem -Path $OSDBuilderContent\OSDUpdate -Directory -Recurse | Where-Object {$_.Name -eq $($Update.Title)}).FullName
        if (Test-Path "$UpdateSSU") {
            Write-Host "$UpdateSSU" -ForegroundColor DarkGray
            $CurrentLog = "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-ServicingStack-KB$($Update.KBNumber).log"
            Write-Verbose "$CurrentLog"
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
    #===================================================================================================
    #   End
    #===================================================================================================
}
function OSD-Updates-LCU {
    [CmdletBinding()]
    PARAM ()
    #===================================================================================================
    #   Abort
    #===================================================================================================
    if ($OSMajorVersion -ne 10) {Return}
    #===================================================================================================
    #   Header
    #===================================================================================================
    Write-Host '========================================================================================' -ForegroundColor DarkGray
    Write-Host "Install.wim: (LCU) Latest Cumulative Update" -ForegroundColor Green
    #===================================================================================================
    #   Parameters
    #===================================================================================================
    if ($SkipUpdates) {
        Write-Warning "Skip: -SkipUpdates Parameter was used"
        Return
    }
    #===================================================================================================
    #   Execute
    #===================================================================================================
    foreach ($Update in $OSDUpdateLCU) {
        $UpdateLCU = $(Get-ChildItem -Path $OSDBuilderContent\OSDUpdate -Directory -Recurse | Where-Object {$_.Name -eq $($Update.Title)}).FullName
        if (Test-Path "$UpdateLCU") {
            Write-Host "$UpdateLCU" -ForegroundColor DarkGray
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
                Write-Verbose "$CurrentLog"
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
    #===================================================================================================
    #   End
    #===================================================================================================
}
function OSD-Updates-LCUForce {
    [CmdletBinding()]
    PARAM ()
    #===================================================================================================
    #   Abort
    #===================================================================================================
    if ($OSMajorVersion -ne 10) {Return}
    #===================================================================================================
    #   Header
    #===================================================================================================
    Write-Host '========================================================================================' -ForegroundColor DarkGray
    Write-Host "Install.wim: LCU (Latest Cumulative Update Forced)" -ForegroundColor Green
    #===================================================================================================
    #   Parameters
    #===================================================================================================
    if ($SkipUpdates) {
        Write-Warning "Skip: -SkipUpdates Parameter was used"
        Return
    }
    #===================================================================================================
    #   Execute
    #===================================================================================================
    foreach ($Update in $OSDUpdateLCU) {
        $UpdateCU = $(Get-ChildItem -Path $OSDBuilderContent\OSDUpdate -Directory -Recurse | Where-Object {$_.Name -eq $($Update.Title)}).FullName
        if (Test-Path "$UpdateCU") {
            Write-Host "$UpdateCU" -ForegroundColor DarkGray
            $CurrentLog = "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Cumulative-KB$($Update.KBNumber).log"
            Write-Verbose "$CurrentLog"
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
    #===================================================================================================
    #   End
    #===================================================================================================
}
function OSD-Updates-Adobe {
    [CmdletBinding()]
    PARAM ()
    #===================================================================================================
    #   Abort
    #===================================================================================================
    if ($OSMajorVersion -ne 10) {Return}
    #===================================================================================================
    #   Header
    #===================================================================================================
    Write-Host '========================================================================================' -ForegroundColor DarkGray
    Write-Host "Install.wim: (ASU) Adobe Flash Player Security Update" -ForegroundColor Green
    #===================================================================================================
    #   Parameters
    #===================================================================================================
    if ($SkipUpdates) {
        Write-Warning "Skip: -SkipUpdates Parameter was used"
        Return
    }
    #===================================================================================================
    #   Execute
    #===================================================================================================
    foreach ($Update in $OSDUpdateAdobeSU) {
        $UpdateASU = @()
        $UpdateASU = $(Get-ChildItem -Path $OSDBuilderContent\OSDUpdate -Directory -Recurse | Where-Object {$_.Name -eq $($Update.Title)}).FullName
        if (Test-Path "$UpdateASU") {
            Write-Host "$UpdateASU" -ForegroundColor DarkGray
            if (Get-WindowsPackage -Path "$MountDirectory" | Where-Object {$_.PackageName -like "*$($Update.KBNumber)*"}) {
                Write-Warning "KB$($Update.KBNumber) is already installed"
            } else {
                $CurrentLog = "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-AdobeFlashPlayer-KB$($Update.KBNumber).log"
                Write-Verbose "$CurrentLog"
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
    #===================================================================================================
    #   End
    #===================================================================================================
}
function OSD-Updates-DotNet {
    [CmdletBinding()]
    PARAM ()
    #===================================================================================================
    #   Abort
    #===================================================================================================
    if ($OSMajorVersion -ne 10) {Return}
    #===================================================================================================
    #   Header
    #===================================================================================================
    Write-Host '========================================================================================' -ForegroundColor DarkGray
    Write-Host "Install.wim: (NetCU) DotNet Framework Cumulative Update" -ForegroundColor Green
    #===================================================================================================
    #   Parameters
    #===================================================================================================
    if ($SkipUpdates) {
        Write-Warning "Skip: -SkipUpdates Parameter was used"
        Return
    }
    #===================================================================================================
    #   Execute
    #===================================================================================================
    foreach ($Update in $OSDUpdateDotNet) {
        $UpdateNetCU = $(Get-ChildItem -Path $OSDBuilderContent\OSDUpdate -Directory -Recurse | Where-Object {$_.Name -eq $($Update.Title)}).FullName
        if (Test-Path "$UpdateNetCU") {
            Write-Host "$UpdateNetCU" -ForegroundColor DarkGray
            $CurrentLog = "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-DotNet-KB$($Update.KBNumber).log"
            Write-Verbose "$CurrentLog"
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
    #===================================================================================================
    #   End
    #===================================================================================================
}
function OSD-Updates-Seven {
    [CmdletBinding()]
    PARAM ()
    #===================================================================================================
    #   Abort
    #===================================================================================================
    #===================================================================================================
    #   Header
    #===================================================================================================
    Write-Host '========================================================================================' -ForegroundColor DarkGray
    Write-Host "Install.wim: Windows 7 Updates" -ForegroundColor Green
    #===================================================================================================
    #   Parameters
    #===================================================================================================
    if ($SkipUpdates) {
        Write-Warning "Skip: -SkipUpdates Parameter was used"
        Return
    }
    #===================================================================================================
    #   Execute
    #===================================================================================================
    foreach ($Update in $OSDUpdateWinSeven) {
        $UpdateSeven = $(Get-ChildItem -Path $OSDBuilderContent\OSDUpdate -Directory -Recurse | Where-Object {$_.Name -eq $($Update.Title)}).FullName
        if (Test-Path "$UpdateSeven") {
            Write-Host "$UpdateSeven" -ForegroundColor DarkGray
            if (Get-WindowsPackage -Path "$MountDirectory" | Where-Object {$_.PackageName -like "*$($Update.KBNumber)*"}) {
                Write-Warning "KB$($Update.KBNumber) is already installed"
            } else {
                $CurrentLog = "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-UpdateSeven-KB$($Update.KBNumber).log"
                Write-Verbose "$CurrentLog"
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
    #===================================================================================================
    #   End
    #===================================================================================================
}
function OSD-Updates-TwelveR2 {
    [CmdletBinding()]
    PARAM ()
    #===================================================================================================
    #   Abort
    #===================================================================================================
    #===================================================================================================
    #   Header
    #===================================================================================================
    Write-Host '========================================================================================' -ForegroundColor DarkGray
    Write-Host "Install.wim: Windows Server 2012 R2 Updates" -ForegroundColor Green
    #===================================================================================================
    #   Parameters
    #===================================================================================================
    if ($SkipUpdates) {
        Write-Warning "Skip: -SkipUpdates Parameter was used"
        Return
    }
    #===================================================================================================
    #   Execute
    #===================================================================================================
    foreach ($Update in $OSDUpdateWinTwelveR2) {
        $UpdateTwelveR2 = $(Get-ChildItem -Path $OSDBuilderContent\OSDUpdate -Directory -Recurse | Where-Object {$_.Name -eq $($Update.Title)}).FullName
        if (Test-Path "$UpdateTwelveR2") {
            Write-Host "$UpdateTwelveR2" -ForegroundColor DarkGray
            if (Get-WindowsPackage -Path "$MountDirectory" | Where-Object {$_.PackageName -like "*$($Update.KBNumber)*"}) {
                Write-Warning "KB$($Update.KBNumber) is already installed"
            } else {
                $CurrentLog = "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-UpdateTwelveR2-KB$($Update.KBNumber).log"
                Write-Verbose "$CurrentLog"
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
    #===================================================================================================
    #   End
    #===================================================================================================
}
function OSD-Updates-DismImageCleanup {
    [CmdletBinding()]
    PARAM ()
    #===================================================================================================
    #   Abort
    #===================================================================================================
    if ($OSVersion -like "6.1*") {Return}
    #===================================================================================================
    #   Header
    #===================================================================================================
    Write-Host '========================================================================================' -ForegroundColor DarkGray
    Write-Host "Install.wim: DISM Cleanup-Image" -ForegroundColor Green
    #===================================================================================================
    #   Parameters
    #===================================================================================================
    if ($SkipUpdates) {
        Write-Warning "Skip: -SkipUpdates Parameter was used"
        Return
    }
    if ($SkipComponentCleanup) {
        Write-Warning "Skip: -SkipComponentCleanup Parameter was used"
        Return
    }
    #===================================================================================================
    #   Log
    #===================================================================================================
    $CurrentLog = "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Dism-Cleanup-Image.log"
    #===================================================================================================
    #   Execute
    #===================================================================================================
    if ($OSMajorVersion -eq 10) {
        if ($(Get-WindowsCapability -Path $MountDirectory | Where-Object {$_.state -eq "*pending*"})) {
            Write-Warning "Cannot run WindowsImage Cleanup on a WIM with Pending Installations"
        } else {
            Write-Verbose "$CurrentLog"
            Dism /Image:"$MountDirectory" /Cleanup-Image /StartComponentCleanup /ResetBase /LogPath:"$CurrentLog"
        }
    } else {
        Write-Verbose "$CurrentLog"
        Dism /Image:"$MountDirectory" /Cleanup-Image /StartComponentCleanup /ResetBase /LogPath:"$CurrentLog" 
    }
    #===================================================================================================
    #   End
    #===================================================================================================
}