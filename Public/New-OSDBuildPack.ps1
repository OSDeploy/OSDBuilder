<#
.SYNOPSIS
Creates an OSDBuilder BuildPack

.DESCRIPTION
Creates an OSDBuilder BuildPack in the BuildPack Home directory

.LINK
https://osdbuilder.osdeploy.com/module/functions/new-osdbuildpack
#>
function New-OSDBuildPack {
    [CmdletBinding()]
    Param (
        #Name of the BuildPack to create
        [Parameter(Mandatory)]
        [string]$Name
    )
    $ItemDirectories = @(
        #$OSDBuilderBuildPacks
        "$OSDBuilderBuildPacks\$Name\Media\ALL"
        "$OSDBuilderBuildPacks\$Name\Media\x64"
        "$OSDBuilderBuildPacks\$Name\Media\x86"
        "$OSDBuilderBuildPacks\$Name\OSDrivers\ALL"
        "$OSDBuilderBuildPacks\$Name\OSDrivers\x64"
        "$OSDBuilderBuildPacks\$Name\OSDrivers\x86"
        "$OSDBuilderBuildPacks\$Name\OSExtraFiles\ALL"
        "$OSDBuilderBuildPacks\$Name\OSExtraFiles\ALL Subdirs"
        "$OSDBuilderBuildPacks\$Name\OSExtraFiles\x64"
        "$OSDBuilderBuildPacks\$Name\OSExtraFiles\x64 Subdirs"
        "$OSDBuilderBuildPacks\$Name\OSExtraFiles\x86"
        "$OSDBuilderBuildPacks\$Name\OSExtraFiles\x86 Subdirs"
        "$OSDBuilderBuildPacks\$Name\OSPoshMods\ProgamFiles"
        "$OSDBuilderBuildPacks\$Name\OSPoshMods\System"
        "$OSDBuilderBuildPacks\$Name\OSRegistry\ALL"
        "$OSDBuilderBuildPacks\$Name\OSRegistry\x64"
        "$OSDBuilderBuildPacks\$Name\OSRegistry\x86"
        "$OSDBuilderBuildPacks\$Name\OSScripts\ALL"
        "$OSDBuilderBuildPacks\$Name\OSScripts\x64"
        "$OSDBuilderBuildPacks\$Name\OSScripts\x86"
        "$OSDBuilderBuildPacks\$Name\OSStartLayout\ALL"
        "$OSDBuilderBuildPacks\$Name\OSStartLayout\x64"
        "$OSDBuilderBuildPacks\$Name\OSStartLayout\x86"
        "$OSDBuilderBuildPacks\$Name\PEADK\1809 x64"
        "$OSDBuilderBuildPacks\$Name\PEADK\1809 x86"
        "$OSDBuilderBuildPacks\$Name\PEADK\1903 x64"
        "$OSDBuilderBuildPacks\$Name\PEADK\1903 x86"
        "$OSDBuilderBuildPacks\$Name\PEADK\1909 x64"
        "$OSDBuilderBuildPacks\$Name\PEADK\1909 x86"
        "$OSDBuilderBuildPacks\$Name\PEDrivers\ALL"
        "$OSDBuilderBuildPacks\$Name\PEDrivers\x64"
        "$OSDBuilderBuildPacks\$Name\PEDrivers\x86"
        "$OSDBuilderBuildPacks\$Name\PEExtraFiles\ALL"
        "$OSDBuilderBuildPacks\$Name\PEExtraFiles\ALL Subdirs"
        "$OSDBuilderBuildPacks\$Name\PEExtraFiles\x64"
        "$OSDBuilderBuildPacks\$Name\PEExtraFiles\x64 Subdirs"
        "$OSDBuilderBuildPacks\$Name\PEExtraFiles\x86"
        "$OSDBuilderBuildPacks\$Name\PEExtraFiles\x86 Subdirs"
        "$OSDBuilderBuildPacks\$Name\PEPoshMods\ProgamFiles"
        "$OSDBuilderBuildPacks\$Name\PEPoshMods\System"
        "$OSDBuilderBuildPacks\$Name\PERegistry\ALL"
        "$OSDBuilderBuildPacks\$Name\PERegistry\x64"
        "$OSDBuilderBuildPacks\$Name\PERegistry\x86"
        "$OSDBuilderBuildPacks\$Name\PEScripts\ALL"
        "$OSDBuilderBuildPacks\$Name\PEScripts\x64"
        "$OSDBuilderBuildPacks\$Name\PEScripts\x86"
    )

    foreach ($item in $ItemDirectories) {
        if (!(Test-Path "$item")) {New-Item "$item" -ItemType Directory -Force | Out-Null}
    }
}