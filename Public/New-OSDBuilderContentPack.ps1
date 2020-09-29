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
    Param (
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
        #'OSCapability\1903 x64'
        #'OSCapability\1903 x64 RSAT'
        'OSCapability\1909 x64'
        'OSCapability\1909 x64 RSAT'
        'OSCapability\2004 x64'
        'OSCapability\2004 x64 RSAT'
        'OSCapability\2009 x64'
        'OSCapability\2009 x64 RSAT'
        'OSDrivers\ALL'
        'OSDrivers\x64'
        #'OSDrivers\x86'
        'OSExtraFiles\ALL'
        'OSExtraFiles\ALL Subdirs'
        'OSExtraFiles\x64'
        'OSExtraFiles\x64 Subdirs'
        #'OSExtraFiles\x86'
        #'OSExtraFiles\x86 Subdirs'
        'OSPackages\1903 x64'
        'OSPackages\1909 x64'
        'OSPackages\2004 x64'
        'OSPackages\2009 x64'
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
        'PEADK\1903 x64'
        #'PEADK\1903 x64 WinPE'
        #'PEADK\1903 x64 WinRE'
        #'PEADK\1903 x64 WinSE'
        #'PEADK\1903 x86'
        #'PEADK\1903 x86 WinPE'
        #'PEADK\1903 x86 WinRE'
        #'PEADK\1903 x86 WinSE'
        'PEADK\1909 x64'
        #'PEADK\1909 x64 WinPE'
        #'PEADK\1909 x64 WinRE'
        #'PEADK\1909 x64 WinSE'
        #'PEADK\1909 x86'
        #'PEADK\1909 x86 WinPE'
        #'PEADK\1909 x86 WinRE'
        #'PEADK\1909 x86 WinSE'
        'PEADK\2004 x64'
        'PEADK\2009 x64'
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

    $MultiLangContentPack = @(
        'OSLanguageFeatures\1903 x64'
        'OSLanguagePacks\1903 x64'
        'OSLocalExperiencePacks\1903 x64'
        'PEADKLang\1903 x64'
        'OSLanguageFeatures\1909 x64'
        'OSLanguagePacks\1909 x64'
        'OSLocalExperiencePacks\1909 x64'
        'PEADKLang\1909 x64'
        'OSLanguageFeatures\2004 x64'
        'OSLanguagePacks\2004 x64'
        'OSLocalExperiencePacks\2004 x64'
        'PEADKLang\2004 x64'
        'OSLanguageFeatures\2009 x64'
        'OSLanguagePacks\2009 x64'
        'OSLocalExperiencePacks\2009 x64'
        'PEADKLang\2009 x64'
    )
    #===================================================================================================
    #   Get-OSDBuilder
    #===================================================================================================
    Get-OSDBuilder -HideDetails
    #===================================================================================================
    #   OSContentPack
    #===================================================================================================
    if (($ContentType -eq 'All') -or ($ContentType -eq 'OS')) {
        foreach ($item in $OSContentPack) {
            if (!(Test-Path (Join-Path $SetOSDBuilderPathContentPacks "$Name\$item"))) {
                New-Item (Join-Path $SetOSDBuilderPathContentPacks "$Name\$item") -ItemType Directory -Force | Out-Null
            }
        }
    }
    #===================================================================================================
    #   PEContentPack
    #===================================================================================================
    if (($ContentType -eq 'All') -or ($ContentType -eq 'WinPE')) {
        foreach ($item in $PEContentPack) {
            if (!(Test-Path (Join-Path $SetOSDBuilderPathContentPacks "$Name\$item"))) {
                New-Item (Join-Path $SetOSDBuilderPathContentPacks "$Name\$item") -ItemType Directory -Force | Out-Null
            }
        }
    }
    #===================================================================================================
    #   MultiLangContentPack
    #===================================================================================================
    if (($ContentType -eq 'All') -or ($ContentType -eq 'MultiLang')) {
        foreach ($item in $MultiLangContentPack) {
            if (!(Test-Path (Join-Path $SetOSDBuilderPathContentPacks "$Name\$item"))) {
                New-Item (Join-Path $SetOSDBuilderPathContentPacks "$Name\$item") -ItemType Directory -Force | Out-Null
            }
        }
    }
}