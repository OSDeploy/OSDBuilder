# Module Manifest

@{
    RootModule = 'OSDBuilder.psm1'
    ModuleVersion = '24.10.8.1'
    CompatiblePSEditions    = @('Desktop')
    GUID = 'adda1fa3-c13e-408b-b83f-f22b9cb3fd47'
    Author = 'David Segura'
    CompanyName = 'David Segura'
    Copyright = '(c) 2024 David Segura. All rights reserved.'
    Description = @'
https://osdbuilder.osdeploy.com

Requirements:
PowerShell Module OSD 24.10.8.1 or newer
'@
    PowerShellVersion = '5.1'
    RequiredModules = @(
        @{ModuleName = 'OSD'; ModuleVersion = '24.10.8.1'; Guid = '9fe5b9b6-0224-4d87-9018-a8978529f6f5'}
    )
    FunctionsToExport = @(
        'Get-OSBuilds',
        'Get-OSDBuilder',
        'Get-OSMedia',
        'Get-PEBuilds',
        'Import-OSMedia',
        'Initialize-OSDBuilder',
        'New-OSBuild',
        'New-OSBuildMultiLang',
        'New-OSBuildTask',
        'New-OSDBuilderContentPack',
        'New-OSDBuilderISO',
        'New-OSDBuilderUSB',
        'New-OSDBuilderVHD',
        'New-PEBuild',
        'New-PEBuildTask',
        'Save-OSDBuilderDownload',
        'Show-OSDBuilderInfo',
        'Update-OSMedia'
    )
    CmdletsToExport = @()
    VariablesToExport = @()
    AliasesToExport =   @(
        'Get-DownOSDBuilder',
        'Get-OSBuilder',
        'New-OSBMediaISO',
        'New-OSBMediaUSB',
        'Show-OSBMediaInfo'
    )
    PrivateData = @{
        PSData = @{
            Tags = @('OSD','OSDeploy','OSDBuilder','OSBuilder','OSBuilderSUS','Servicing','SCCM','MDT')
            LicenseUri = 'https://github.com/OSDeploy/OSDBuilder/blob/master/LICENSE'
            ProjectUri = 'https://github.com/OSDeploy/OSDBuilder'
            IconUri = 'https://raw.githubusercontent.com/OSDeploy/OSDBuilder/master/OSD.png'
            ReleaseNotes = 'https://osdbuilder.osdeploy.com/release'
        }
    }
}