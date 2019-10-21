function Import-OSDBuildPack {
    [CmdletBinding()]
    Param (
        #[Alias('Path')]
        #[Parameter(Mandatory)]
        #[string]$OSDBuildPackPath,

        [Parameter(Mandatory)]
        [ValidateSet(
            'Auto',
            'OSDrivers',
            'OSExtraFiles',
            'OSPackages',
            'OSRegistry',
            'PEDrivers',
            'PEExtraFiles',
            'PEPackages',
            'PERegistry'
        )]
        [Alias('Type')]
        [string]$OSDBuildPackType = 'All',

        [string]$MountDirectory
    )

    if ($OSDBuildPackType -eq 'OSDrivers') {
        if ($OSDBuildPacks) {
            Show-ActionTime; Write-Host -ForegroundColor Green "OS: BuildPack OSDrivers"
            foreach ($OSDBuildPack in $OSDBuildPacks) {
                $OSDBuildPackPath = "$OSDBuilderPath\BuildPacks\$OSDBuildPack"
                Import-OSDBuildPackOSDrivers -OSDBuildPackPath "$OSDBuildPackPath" -MountDirectory "$MountDirectory"
            }
        }
    }
    if ($OSDBuildPackType -eq 'OSExtraFiles') {
        if ($OSDBuildPacks) {
            Show-ActionTime; Write-Host -ForegroundColor Green "OS: BuildPack OSExtraFiles"
            foreach ($OSDBuildPack in $OSDBuildPacks) {
                $OSDBuildPackPath = "$OSDBuilderPath\BuildPacks\$OSDBuildPack"
                Import-OSDBuildPackOSExtraFiles -OSDBuildPackPath "$OSDBuildPackPath" -MountDirectory "$MountDirectory" -Verbose
            }
        }
    }
    if ($OSDBuildPackType -eq 'OSRegistry') {
        if ($OSDBuildPacks) {
            Show-ActionTime; Write-Host -ForegroundColor Green "OS: BuildPack OSRegistry"
            foreach ($OSDBuildPack in $OSDBuildPacks) {
                $OSDBuildPackPath = "$OSDBuilderPath\BuildPacks\$OSDBuildPack"
                Import-OSDBuildPackOSRegistry -OSDBuildPackPath "$OSDBuildPackPath" -MountDirectory "$MountDirectory"
            }
        }
    }
    if ($OSDBuildPackType -eq 'PEDrivers') {
        if ($OSDBuildPacks) {
            Show-ActionTime; Write-Host -ForegroundColor Green "OS: BuildPack PEDrivers"
            foreach ($OSDBuildPack in $OSDBuildPacks) {
                $OSDBuildPackPath = "$OSDBuilderPath\BuildPacks\$OSDBuildPack"
                Import-OSDBuildPackPEDrivers -OSDBuildPackPath "$OSDBuildPackPath" -Verbose
            }
        }
    }
}