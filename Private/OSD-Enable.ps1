function Enable-OSDNetFX {
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
    Write-Host -ForegroundColor Green "Install.wim: Enable NetFX 3.5"
    #===================================================================================================
    #   Execute
    #===================================================================================================
    Try {
        Enable-WindowsOptionalFeature -Path "$MountDirectory" -FeatureName NetFX3 -All -LimitAccess -Source "$OS\sources\sxs" -LogPath "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-NetFX3.log" | Out-Null
    }
    Catch {
        $ErrorMessage = $_.Exception.Message
        Write-Warning "$ErrorMessage"
    }
    #===================================================================================================
    #   Post Action
    #===================================================================================================
    Update-OSDotNet
    Update-OSCumulativeForce
    #===================================================================================================
}

function Enable-OSDWindowsOptionalFeature {
    [CmdletBinding()]
    PARAM ()
    #===================================================================================================
    #   Header
    #===================================================================================================
    Get-OSDStartTime
    Write-Host -ForegroundColor Green "Install.wim: Enable Windows Optional Feature"
    #===================================================================================================
    #   Execute
    #===================================================================================================
    foreach ($FeatureName in $EnableFeature) {
        Write-Host $FeatureName -ForegroundColor DarkGray
        Try {
            Enable-WindowsOptionalFeature -FeatureName $FeatureName -Path "$MountDirectory" -All -LogPath "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Enable-WindowsOptionalFeature.log" | Out-Null
        }
        Catch {
            $ErrorMessage = $_.Exception.Message
            Write-Warning "$ErrorMessage"
        }
    }
    #===================================================================================================
    #   Post Action
    #===================================================================================================
    Update-OSCumulativeForce
    Use-DismCleanupImage
    #===================================================================================================
}