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