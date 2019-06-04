function Dismount-WinPEWims {
    [CmdletBinding()]
    PARAM (
        [string]$OSMediaPath
    )
    #===================================================================================================
    #   StartTime
    #===================================================================================================
    $StartTime = Get-Date
    #===================================================================================================
    #   Header
    #===================================================================================================
    Write-Host '========================================================================================' -ForegroundColor DarkGray
    Write-Host "[$(($StartTime).ToString('yyyy-MM-dd-HHmmss'))] WinPE: Dismount Wims" -ForegroundColor Green
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
    #   Duration
    #===================================================================================================
    $Duration = $(Get-Date) - $StartTime
    Write-Host "Duration: $($Duration.ToString('mm\:ss'))" -ForegroundColor DarkGray
}
function Dismount-InstallWim {
    [CmdletBinding()]
    PARAM ()
    #===================================================================================================
    #   StartTime
    #===================================================================================================
    $StartTime = Get-Date
    #===================================================================================================
    #   Header
    #===================================================================================================
    Write-Host '========================================================================================' -ForegroundColor DarkGray
    Write-Host "[$(($StartTime).ToString('yyyy-MM-dd-HHmmss'))] Install.wim: Dismount from $MountDirectory" -ForegroundColor Green
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
    #   Duration
    #===================================================================================================
    $Duration = $(Get-Date) - $StartTime
    Write-Host "Duration: $($Duration.ToString('mm\:ss'))" -ForegroundColor DarkGray
}