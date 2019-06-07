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