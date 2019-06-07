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