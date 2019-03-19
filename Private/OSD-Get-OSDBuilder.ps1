function Get-OSDBuilderVersion {
    param (
        [Parameter(Position=1)]
        [switch]$HideDetails
    )
    $global:OSDBuilderVersion = $(Get-Module -Name OSDBuilder).Version
    if ($HideDetails -eq $false) {
        Write-Host "OSDBuilder $OSDBuilderVersion" -ForegroundColor Green
        Write-Host ""
    }
}
function OSD-Remove-ModuleOSBuilder {
    if (Get-Module -ListAvailable -Name OSBuilder) {
        Write-Warning "PowerShell Module OSBuilder needs to be removed before using OSDBuilder"
        Write-Warning "Use the following command:"
        Write-Warning "Uninstall-Module -Name OSBuilder -AllVersions -Force"
    }
}
function OSD-Remove-ModuleOSMedia {
    if (Get-Module -ListAvailable -Name OSMedia) {
        Write-Warning "PowerShell Module OSMedia needs to be removed before using OSDBuilder"
        Write-Warning "Use the following command:"
        Write-Warning "Uninstall-Module -Name OSMedia -AllVersions -Force"
    }
}