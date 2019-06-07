function Disable-OSDWindowsOptionalFeature {
    [CmdletBinding()]
    PARAM ()
    #===================================================================================================
    #   Header
    #===================================================================================================
    Get-OSDStartTime
    Write-Host -ForegroundColor Green "Install.wim: Disable Windows Optional Feature"
    #===================================================================================================
    #   Execute
    #===================================================================================================
    foreach ($FeatureName in $DisableFeature) {
        Write-Host $FeatureName -ForegroundColor DarkGray
        Try {
            Disable-WindowsOptionalFeature -FeatureName $FeatureName -Path "$MountDirectory" -LogPath "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Disable-WindowsOptionalFeature.log" | Out-Null
        }
        Catch {
            $ErrorMessage = $_.Exception.Message
            Write-Warning "$ErrorMessage"
        }
    }
    #===================================================================================================
}