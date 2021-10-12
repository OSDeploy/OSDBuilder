<#
.SYNOPSIS
Creates an OSDBuilder ContentPack

.DESCRIPTION
Creates or Updates an OSDBuilder ContentPack in the ContentPack directory

.LINK
https://osdbuilder.osdeploy.com/module/functions/new-osdbuildercontentpack
#>
function New-OSDBuilderContentPack {
    [CmdletBinding()]
    param (
        #Name of the ContentPack to create
        [Parameter(Position = 0, Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,
        
        #Content Pack Type
        [ValidateSet('All','OS','WinPE','MultiLang')]
        [string]$ContentType = 'All'
    )

    $OSContentPack = @(
        'Media\ALL'
        'Media\x64'
        #'Media\x86'
        'OSDrivers\ALL'
        'OSDrivers\x64'
        #'OSDrivers\x86'
        'OSExtraFiles\ALL'
        'OSExtraFiles\ALL Subdirs'
        'OSExtraFiles\x64'
        'OSExtraFiles\x64 Subdirs'
        'OSPoshMods\ProgramFiles'
        'OSPoshMods\System'
        'OSRegistry\ALL'
        'OSRegistry\x64'
        #'OSRegistry\x86'
        'OSScripts\ALL'
        'OSScripts\x64'
        #'OSScripts\x86'
        'OSStartLayout\ALL'
        'OSStartLayout\x64'
        #'OSStartLayout\x86'
    )

    $PEContentPack = @(
        'PEDaRT'
        'PEDrivers\ALL'
        'PEDrivers\x64'
        #'PEDrivers\x86'
        'PEExtraFiles\ALL'
        'PEExtraFiles\ALL Subdirs'
        'PEExtraFiles\x64'
        'PEExtraFiles\x64 Subdirs'
        #'PEExtraFiles\x86'
        #'PEExtraFiles\x86 Subdirs'
        'PEPoshMods\ProgramFiles'
        'PEPoshMods\System'
        'PERegistry\ALL'
        'PERegistry\x64'
        #'PERegistry\x86'
        'PEScripts\ALL'
        'PEScripts\x64'
        #'PEScripts\x86'
    )

    $MultiLangContentPack = @()
    #=================================================
    #   Get-OSDBuilder
    #=================================================
    Get-OSDBuilder -HideDetails
    #=================================================
    #   OSContentPack
    #=================================================
    if (($ContentType -eq 'All') -or ($ContentType -eq 'OS')) {
        foreach ($item in $OSContentPack) {
            if (!(Test-Path (Join-Path $SetOSDBuilderPathContentPacks "$Name\$item"))) {
                New-Item (Join-Path $SetOSDBuilderPathContentPacks "$Name\$item") -ItemType Directory -Force | Out-Null
            }
        }
    }
    #=================================================
    #   PEContentPack
    #=================================================
    if (($ContentType -eq 'All') -or ($ContentType -eq 'WinPE')) {
        foreach ($item in $PEContentPack) {
            if (!(Test-Path (Join-Path $SetOSDBuilderPathContentPacks "$Name\$item"))) {
                New-Item (Join-Path $SetOSDBuilderPathContentPacks "$Name\$item") -ItemType Directory -Force | Out-Null
            }
        }
    }
    #=================================================
    #   MultiLangContentPack
    #=================================================
    if (($ContentType -eq 'All') -or ($ContentType -eq 'MultiLang')) {
        foreach ($item in $MultiLangContentPack) {
            if (!(Test-Path (Join-Path $SetOSDBuilderPathContentPacks "$Name\$item"))) {
                New-Item (Join-Path $SetOSDBuilderPathContentPacks "$Name\$item") -ItemType Directory -Force | Out-Null
            }
        }
    }
}