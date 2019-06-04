function OSD-Upgrade-Module {
    [CmdletBinding()]
    PARAM ()
    try {
        Write-Warning "Uninstall-Module -Name OSDBuilder -AllVersions -Force"
        Uninstall-Module -Name OSDBuilder -AllVersions -Force
    }
    catch {}

    try {
        Write-Warning "Install-Module -Name OSDBuilder -Force"
        Install-Module -Name OSDBuilder -Scope CurrentUser -Force
    }
    catch {}

    try {
        Write-Warning "Import-Module -Name OSDBuilder -Force"
        Import-Module -Name OSDBuilder -Force
    }
    catch {}
}

function OSD-Upgrade-RemoveCatalogs {
    [CmdletBinding()]
    PARAM ()
    if (Test-Path "$CatalogLocal") {
        $CatalogsRemove = $(Get-Content $CatalogLocal | ConvertFrom-Json).CatalogsRemove
        foreach ($Catalog in $CatalogsRemove) {
            Get-ChildItem "$OSDBuilderContent\Updates\*" -Include "$Catalog" -Recurse | foreach {
                Write-Warning "Removing $($_.FullName)"
                Remove-Item $_.FullName -Force | Out-Null
            }
        }
    }
}