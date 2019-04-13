# Module Manifest
#

@{

# Script module or binary module file associated with this manifest.
RootModule = 'OSDBuilder.psm1'

# Version number of his module.
ModuleVersion = '19.4.13.0'

# Supported PSEditions
# CompatiblePSEditions = @()

# ID used to uniquely identify this module
GUID = 'adda1fa3-c13e-408b-b83f-f22b9cb3fd47'

# Author of this module
Author = 'David Segura'

# Company or vendor of this module
CompanyName = 'osdeploy.com'

# Copyright statement for this module
Copyright = '(c) 2019 David Segura osdeploy.com. All rights reserved.'

# Description of the functionality provided by this module
Description = 'Offline Servicing for Windows 7 x64 SP1, Windows 10, Windows Server 2012 R2, Windows Server 2016, and Windows Server 2019'

# Minimum version of the Windows PowerShell engine required by this module
PowerShellVersion = '5.0'

# Name of the Windows PowerShell host required by this module
# PowerShellHostName = 'Windows PowerShell ISE Host'

# Minimum version of the Windows PowerShell host required by this module
# PowerShellHostVersion = ''

# Minimum version of Microsoft .NET Framework required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
# DotNetFrameworkVersion = ''

# Minimum version of the common language runtime (CLR) required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
# CLRVersion = ''

# Processor architecture (None, X86, Amd64) required by this module
# ProcessorArchitecture = ''

# Modules that must be imported into the global environment prior to importing this module
# RequiredModules = @()

# Assemblies that must be loaded prior to importing this module
# RequiredAssemblies = @()

# Script files (.ps1) that are run in the caller's environment prior to importing this module.
# ScriptsToProcess = @()

# Type files (.ps1xml) to be loaded when importing this module
# TypesToProcess = @()

# Format files (.ps1xml) to be loaded when importing this module
# FormatsToProcess = @()

# Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
# NestedModules = @()

# Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
FunctionsToExport = 'Get-OSDBuilder',
                    'Get-OSMedia','Import-OSMedia','Update-OSMedia',
                    'Get-OSBuilds','New-OSBuild','New-OSBuildTask',
                    'Get-PEBuilds','New-PEBuild','New-PEBuildTask',
                    'New-OSDBuilderISO','New-OSDBuilderUSB','Show-OSDBuilderInfo',
                    'Get-DownOSDBuilder',
                    'New-OSBuildMultiLang',
                    'New-OSDBuilderVHD'

# Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
CmdletsToExport = @()

# Variables to export from this module
VariablesToExport = @()

# Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
AliasesToExport =   'Get-OSBuilder',
                    'New-OSBMediaISO',
                    'New-OSBMediaUSB',
                    'Show-OSBMediaInfo'

# DSC resources to export from this module
# DscResourcesToExport = @()

# List of all modules packaged with this module
# ModuleList = @()

# List of all files packaged with this module
# FileList = @()

# Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
PrivateData = @{

    PSData = @{

        # Tags applied to this module. These help with module discovery in online galleries.
        Tags = @('OSDeploy','OSDBuilder','OSBuilder','Servicing','SCCM','MDT')

        # A URL to the license for this module.
        # LicenseUri = ''

        # A URL to the main website for this project.
        ProjectUri = 'https://www.osdbuilder.com/home'

        # A URL to an icon representing this module.
        # IconUri = ''

        # ReleaseNotes of this module
        ReleaseNotes = 'https://www.osdbuilder.com/releases'

    } # End of PSData hashtable

} # End of PrivateData hashtable

# HelpInfo URI of this module
# HelpInfoURI = ''

# Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
# DefaultCommandPrefix = ''

}
