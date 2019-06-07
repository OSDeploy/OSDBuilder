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