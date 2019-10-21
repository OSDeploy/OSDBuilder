function Import-OSDBuildPackOSDrivers {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)]
        [string]$OSDBuildPackPath,

        [string]$MountDirectory
    )

    #======================================================================================
    #   Test-OSDBuildPackOSDrivers
    #======================================================================================
    $OSDBuildPackOSDrivers = "$OSDBuildPackPath\OSDrivers"

    if (!(Test-Path "$OSDBuildPackOSDrivers\*")) {
        Write-Verbose "Import-OSDBuildPackOSDrivers: Unable to locate content in $OSDBuildPackOSDrivers"
        Return
    } else {
        Write-Host "$OSDBuildPackOSDrivers" -ForegroundColor Cyan
    }

    $CurrentLog = "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Import-OSDBuildPackOSDrivers.log"
    Write-Verbose "CurrentLog: $CurrentLog"


    if ($OSMajorVersion -eq 6) {
        dism /Image:"$MountDirectory" /Add-Driver /Driver:"$OSDBuildPackOSDrivers" /Recurse /ForceUnsigned /LogPath:"$CurrentLog"
    } else {
        Add-WindowsDriver -Driver "$OSDBuildPackOSDrivers" -Recurse -Path "$MountDirectory" -ForceUnsigned -LogPath "$CurrentLog" | Out-Null
    }
}