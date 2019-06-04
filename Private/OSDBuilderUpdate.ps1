function Update-WinPESources {
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
    Write-Host "[$(($StartTime).ToString('yyyy-MM-dd-HHmmss'))] Media: Update Sources with WinSE.wim" -ForegroundColor Green
    #===================================================================================================
    #   Execute
    #===================================================================================================
    robocopy "$MountWinSE\sources" "$OSMediaPath\OS\sources" setup.exe /ndl /xo /xx /xl /b /np /ts /tee /r:0 /w:0 /Log+:"$OSMediaPath\info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Robocopy-WinSE-MediaSources.log" | Out-Null
    robocopy "$MountWinSE\sources" "$OSMediaPath\OS\sources" setuphost.exe /ndl /xo /xx /xl /b /np /ts /tee /r:0 /w:0 /Log+:"$OSMediaPath\info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Robocopy-WinSE-MediaSources.log" | Out-Null
    #===================================================================================================
    #   Duration
    #===================================================================================================
    $Duration = $(Get-Date) - $StartTime
    Write-Host "Duration: $($Duration.ToString('mm\:ss'))" -ForegroundColor DarkGray
}