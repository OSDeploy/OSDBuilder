function Import-OSDBuildPackPEDrivers {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)]
        [string]$OSDBuildPackPath
    )

    #======================================================================================
    #   Test-OSDBuildPackPEDrivers
    #======================================================================================
    $OSDBuildPackPEDrivers = "$OSDBuildPackPath\PEDrivers"

    if (!(Test-Path "$OSDBuildPackPEDrivers\*")) {
        Write-Verbose "Import-OSDBuildPackPEDrivers: Unable to locate content in $OSDBuildPackPEDrivers"
        Return
    } else {
        Write-Host "$OSDBuildPackPEDrivers" -ForegroundColor Cyan
    }

    $CurrentLog = "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Import-OSDBuildPackPEDrivers.log"
    Write-Verbose "CurrentLog: $CurrentLog"

    if ($OSMajorVersion -eq 6) {
        dism /Image:"$MountWinPE" /Add-Driver /Driver:"$OSDBuildPackPEDrivers" /Recurse /ForceUnsigned /LogPath:"$CurrentLog"
        dism /Image:"$MountWinRE" /Add-Driver /Driver:"$OSDBuildPackPEDrivers" /Recurse /ForceUnsigned /LogPath:"$CurrentLog"
        dism /Image:"$MountWinSE" /Add-Driver /Driver:"$OSDBuildPackPEDrivers" /Recurse /ForceUnsigned /LogPath:"$CurrentLog"
    } else {
        Add-WindowsDriver -Driver "$OSDBuildPackPEDrivers" -Recurse -Path "$MountWinPE" -ForceUnsigned -LogPath "$CurrentLog" | Out-Null
        Add-WindowsDriver -Driver "$OSDBuildPackPEDrivers" -Recurse -Path "$MountWinRE" -ForceUnsigned -LogPath "$CurrentLog" | Out-Null
        Add-WindowsDriver -Driver "$OSDBuildPackPEDrivers" -Recurse -Path "$MountWinSE" -ForceUnsigned -LogPath "$CurrentLog" | Out-Null
    }
}