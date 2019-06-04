function Mount-ImportOSMedia {
    [CmdletBinding()]
    PARAM ()
    #===================================================================================================
    #   StartTime
    #===================================================================================================
    $StartTime = Get-Date
    #===================================================================================================
    #   Header
    #===================================================================================================
    Write-Host "[$(($StartTime).ToString('yyyy-MM-dd-HHmmss'))] Mount Install.wim: $MountDirectory" -ForegroundColor Green
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
    #===================================================================================================
    #   Duration
    #===================================================================================================
    $Duration = $(Get-Date) - $StartTime
    Write-Host "Duration: $($Duration.ToString('mm\:ss'))" -ForegroundColor DarkGray
}

function Mount-WinPEWims {
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
    Write-Host "[$(($StartTime).ToString('yyyy-MM-dd-HHmmss'))] WinPE: Mount Wims" -ForegroundColor Green
    #===================================================================================================
    #   Execute
    #===================================================================================================
    Write-Verbose "MountWinPE: $MountWinPE"
    $CurrentLog = "$OSMediaPath\WinPE\info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Mount-WindowsImage-WinPE.log"
    Write-Verbose "CurrentLog: $CurrentLog"
    Mount-WindowsImage -ImagePath "$OSMediaPath\WimTemp\winpe.wim" -Index 1 -Path "$MountWinPE" -LogPath "$CurrentLog" | Out-Null

    Write-Verbose "MountWinRE: $MountWinRE"
    $CurrentLog = "$OSMediaPath\WinPE\info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Mount-WindowsImage-WinRE.log"
    Write-Verbose "CurrentLog: $CurrentLog"
    Mount-WindowsImage -ImagePath "$OSMediaPath\WimTemp\winre.wim" -Index 1 -Path "$MountWinRE" -LogPath "$CurrentLog" | Out-Null

    Write-Verbose "MountWinSE: $MountWinSE"
    $CurrentLog = "$OSMediaPath\WinPE\info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Mount-WindowsImage-WinSE.log"
    Write-Verbose "CurrentLog: $CurrentLog"
    Mount-WindowsImage -ImagePath "$OSMediaPath\WimTemp\winse.wim" -Index 1 -Path "$MountWinSE" -LogPath "$CurrentLog" | Out-Null
    #===================================================================================================
    #   Duration
    #===================================================================================================
    $Duration = $(Get-Date) - $StartTime
    Write-Host "Duration: $($Duration.ToString('mm\:ss'))" -ForegroundColor DarkGray
}

function Mount-InstallWim {
    [CmdletBinding()]
    PARAM ()
    #===================================================================================================
    #   StartTime
    #===================================================================================================
    $StartTime = Get-Date
    #===================================================================================================
    #   Header
    #===================================================================================================
    Write-Host "[$(($StartTime).ToString('yyyy-MM-dd-HHmmss'))] Install.wim: Mount to $MountDirectory" -ForegroundColor Green
    #===================================================================================================
    #   Execute
    #===================================================================================================
    $CurrentLog = "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Mount-WindowsImage.log"
    Write-Verbose "CurrentLog: $CurrentLog"
    Mount-WindowsImage -ImagePath "$WimTemp\install.wim" -Index 1 -Path "$MountDirectory" -LogPath "$CurrentLog" | Out-Null
    #===================================================================================================
    #   Duration
    #===================================================================================================
    $Duration = $(Get-Date) - $StartTime
    Write-Host "Duration: $($Duration.ToString('mm\:ss'))" -ForegroundColor DarkGray
}