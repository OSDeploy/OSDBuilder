<#
.SYNOPSIS
Updates the OSDBuilder PowerShell Module to the latest version

.DESCRIPTION
Updates the OSDBuilder PowerShell Module to the latest version from the PowerShell Gallery in the CurrentUser Scope

.PARAMETER AllUsers
Installs the Module in the AllUsers Scope.  Requires Admin Rights

.LINK
https://www.osdeploy.com/osdbuilder/docs/functions/update-moduleosdbuilder

.Example
Update-ModuleOSDBuilder
#>
function Update-ModuleOSDBuilder {
    [CmdletBinding()]
    PARAM (
        [switch]$CurrentUser
    )

    try {
        Write-Warning "Uninstall-Module -Name OSDBuilder -AllVersions -Force"
        Uninstall-Module -Name OSDBuilder -AllVersions -Force -ErrorAction SilentlyContinue
    }
    catch {}

    if ($CurrentUser.IsPresent) {
        try {
            Write-Warning "Install-Module -Name OSDBuilder -Scope CurrentUser -Force"
            Install-Module -Name OSDBuilder -Scope CurrentUser -Force -ErrorAction SilentlyContinue
        }
        catch {}
    } else {
        try {
            Write-Warning "Install-Module -Name OSDBuilder -Force"
            Install-Module -Name OSDBuilder -Force -ErrorAction SilentlyContinue
        }
        catch {}
    }

    try {
        Write-Warning "Import-Module -Name OSDBuilder -Force"
        Import-Module -Name OSDBuilder -Force -ErrorAction SilentlyContinue
    }
    catch {}
}