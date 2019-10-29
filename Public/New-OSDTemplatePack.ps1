<#
.SYNOPSIS
Creates an OSDBuilder TemplatePack

.DESCRIPTION
Creates an OSDBuilder TemplatePack in the Templatesdirectory

.LINK
https://osdbuilder.osdeploy.com/module/functions/new-osdtemplatepack
#>
function New-OSDTemplatePack {
    [CmdletBinding()]
    Param (
        #Name of the Template to create
        #Template Name must start with an Underscore
        [Parameter(Mandatory)]
        [string]$TemplateName
    )
    $TemplateDirectories = @(
        "Media\ALL"
        "Media\x64"
        "Media\x86"
        "OSDrivers\ALL"
        "OSDrivers\x64"
        "OSDrivers\x86"
        "OSExtraFiles\ALL"
        "OSExtraFiles\ALL Subdirs"
        "OSExtraFiles\x64"
        "OSExtraFiles\x64 Subdirs"
        "OSExtraFiles\x86"
        "OSExtraFiles\x86 Subdirs"
        "OSPoshMods\ProgamFiles"
        "OSPoshMods\System"
        "OSRegistry\ALL"
        "OSRegistry\x64"
        "OSRegistry\x86"
        "OSScripts\ALL"
        "OSScripts\x64"
        "OSScripts\x86"
        "OSStartLayout\ALL"
        "OSStartLayout\x64"
        "OSStartLayout\x86"
        "PEADK\1809 x64"
        "PEADK\1809 x86"
        "PEADK\1903 x64"
        "PEADK\1903 x86"
        "PEADK\1909 x64"
        "PEADK\1909 x86"
        "PEDrivers\ALL"
        "PEDrivers\x64"
        "PEDrivers\x86"
        "PEExtraFiles\ALL"
        "PEExtraFiles\ALL Subdirs"
        "PEExtraFiles\x64"
        "PEExtraFiles\x64 Subdirs"
        "PEExtraFiles\x86"
        "PEExtraFiles\x86 Subdirs"
        "PEPoshMods\ProgamFiles"
        "PEPoshMods\System"
        "PERegistry\ALL"
        "PERegistry\x64"
        "PERegistry\x86"
        "PEScripts\ALL"
        "PEScripts\x64"
        "PEScripts\x86"
    )
    foreach ($TemplateDirectory in $TemplateDirectories) {
        if (!(Test-Path "$OSDBuilderTemplates\$TemplateName\$TemplateDirectory")) {
            New-Item "$OSDBuilderTemplates\$TemplateName\$TemplateDirectory" -ItemType Directory -Force | Out-Null
        }
    }
}