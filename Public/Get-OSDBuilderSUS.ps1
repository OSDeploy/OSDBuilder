<#
.SYNOPSIS
Returns an Array of Microsoft Updates

.DESCRIPTION
Returns an Array of Microsoft Updates contained in the local WSUS Catalogs

.LINK
https://osdbuilder.osdeploy.com/

.PARAMETER GridView
Displays the results in GridView with -PassThru

.PARAMETER Silent
Hide the Current Update Date information
#>
function Get-OSDBuilderSUS {
    [CmdletBinding()]
    PARAM (
        #Filter by Catalog Property
        [Parameter(Position = 0)]
        [ValidateSet(
            'All',
            'FeatureUpdate',
            'Windows',
            'Windows Client',
            'Windows Server',
            'Windows 10',
            'Windows 11'
        )]
        [Alias('Format')]
        [string]$Catalog = 'All',

        #Filter by UpdateArch Property
        [ValidateSet('x64','x86')]
        [string]$UpdateArch,

        #Filter by UpdateBuild Property
        [ValidateSet(1507,1511,1607,1703,1709,1803,1809,1903,1909,2004,'20H2','21H1','21H2')]
        [string]$UpdateBuild,

        #Filter by UpdateGroup Property
        [ValidateSet('AdobeSU','DotNet','DotNetCU','LCU','Optional','SSU')]
        [string]$UpdateGroup,

        #Filter by UpdateOS Property
        [ValidateSet('Windows 10','Windows 11','Windows Server')]
        [string]$UpdateOS,

        #Display the results in GridView
        [switch]$GridView,

        #Don't display the Module Information
        [switch]$Silent
    )
    #===================================================================================================
    #   Defaults
    #===================================================================================================
    $OSDBuilderSUSCatalogPath = "$($MyInvocation.MyCommand.Module.ModuleBase)\Catalogs"
    $OSDBuilderSUSVersion = $($MyInvocation.MyCommand.Module.Version)
    #===================================================================================================
    #   Catalogs
    #===================================================================================================
    $OSDBuilderSUSCatalogs = Get-ChildItem -Path "$OSDBuilderSUSCatalogPath\*" -Include "*.xml" -Recurse | Select-Object -Property *

    switch ($Catalog) {
        'FeatureUpdate'     {$OSDBuilderSUSCatalogs = $OSDBuilderSUSCatalogs | Where-Object {$_.BaseName -match 'FeatureUpdate'}}
        'Windows' {
            $OSDBuilderSUSCatalogs = $OSDBuilderSUSCatalogs | Where-Object {$_.BaseName -match 'Windows'}
            $OSDBuilderSUSCatalogs = $OSDBuilderSUSCatalogs | Where-Object {$_.BaseName -notmatch 'FeatureUpdate'}
        }
        'Windows Client' {
            $OSDBuilderSUSCatalogs = $OSDBuilderSUSCatalogs | Where-Object {$_.BaseName -match 'Windows'}
            $OSDBuilderSUSCatalogs = $OSDBuilderSUSCatalogs | Where-Object {$_.BaseName -notmatch 'Windows Server'}
            $OSDBuilderSUSCatalogs = $OSDBuilderSUSCatalogs | Where-Object {$_.BaseName -notmatch 'Dynamic Update'}
            $OSDBuilderSUSCatalogs = $OSDBuilderSUSCatalogs | Where-Object {$_.BaseName -notmatch 'FeatureUpdate'}
        }
        'Windows Server'    {$OSDBuilderSUSCatalogs = $OSDBuilderSUSCatalogs | Where-Object {$_.BaseName -match 'Windows Server'}}

        'Windows 10' {
            $OSDBuilderSUSCatalogs = $OSDBuilderSUSCatalogs | Where-Object {$_.BaseName -match 'Windows 10'}
            $OSDBuilderSUSCatalogs = $OSDBuilderSUSCatalogs | Where-Object {$_.BaseName -notmatch 'Dynamic Update'}
            $OSDBuilderSUSCatalogs = $OSDBuilderSUSCatalogs | Where-Object {$_.BaseName -notmatch 'FeatureUpdate'}
        }
        'Windows 11' {
            $OSDBuilderSUSCatalogs = $OSDBuilderSUSCatalogs | Where-Object {$_.BaseName -match 'Windows 11'}
            $OSDBuilderSUSCatalogs = $OSDBuilderSUSCatalogs | Where-Object {$_.BaseName -notmatch 'Dynamic Update'}
            $OSDBuilderSUSCatalogs = $OSDBuilderSUSCatalogs | Where-Object {$_.BaseName -notmatch 'FeatureUpdate'}
        }
    }
    #===================================================================================================
    #   Update Information
    #===================================================================================================
    if (!($Silent.IsPresent)) {
        Write-Verbose "OSDBuilderSUS $OSDBuilderSUSVersion $Catalog http://osdbuilder.osdeploy.com/release" -Verbose
    }
    #===================================================================================================
    #   Variables
    #===================================================================================================
    $OSDBuilderSUS = @()
    #===================================================================================================
    #   Import Catalog XML Files
    #===================================================================================================
    foreach ($OSDBuilderSUSCatalog in $OSDBuilderSUSCatalogs) {
        $OSDBuilderSUS += Import-Clixml -Path "$($OSDBuilderSUSCatalog.FullName)"
    }
    #===================================================================================================
    #   Standard Filters
    #===================================================================================================
    $OSDBuilderSUS = $OSDBuilderSUS | Where-Object {$_.FileName -notlike "*.exe"}
    $OSDBuilderSUS = $OSDBuilderSUS | Where-Object {$_.FileName -notlike "*.psf"}
    $OSDBuilderSUS = $OSDBuilderSUS | Where-Object {$_.FileName -notlike "*.txt"}
    $OSDBuilderSUS = $OSDBuilderSUS | Where-Object {$_.FileName -notlike "*delta.exe"}
    $OSDBuilderSUS = $OSDBuilderSUS | Where-Object {$_.FileName -notlike "*express.cab"}

    if ($Catalog -match 'Office') {
        if ($Catalog -match '32-Bit') {
            $OSDBuilderSUS = $OSDBuilderSUS | Where-Object {$_.Title -match '32-Bit'}
        }
        else {
            $OSDBuilderSUS = $OSDBuilderSUS | Where-Object {$_.Title -notmatch '32-Bit'}
        }
    }
    #===================================================================================================
    #   Filter
    #===================================================================================================
    if ($UpdateArch) {$OSDBuilderSUS = $OSDBuilderSUS | Where-Object {$_.UpdateArch -eq $UpdateArch}}
    if ($UpdateBuild) {$OSDBuilderSUS = $OSDBuilderSUS | Where-Object {$_.UpdateBuild -eq $UpdateBuild}}
    if ($UpdateGroup) {$OSDBuilderSUS = $OSDBuilderSUS | Where-Object {$_.UpdateGroup -eq $UpdateGroup}}
    if ($UpdateOS) {$OSDBuilderSUS = $OSDBuilderSUS | Where-Object {$_.UpdateOS -eq $UpdateOS}}
    #===================================================================================================
    #   Sorting
    #===================================================================================================
    #$OSDBuilderSUS = $OSDBuilderSUS | Sort-Object -Property @{Expression = {$_.CreationDate}; Ascending = $false}, Size -Descending
    $OSDBuilderSUS = $OSDBuilderSUS | Sort-Object -Property CreationDate -Descending
    if ($Catalog -eq 'FeatureUpdate') {$OSDBuilderSUS = $OSDBuilderSUS | Sort-Object -Property Title}
    #===================================================================================================
    #   GridView
    #===================================================================================================
    if ($GridView.IsPresent) {
        $OSDBuilderSUS = $OSDBuilderSUS | Out-GridView -PassThru -Title 'Select Updates to Return'
    }
    #===================================================================================================
    #   Return
    #===================================================================================================
    Return $OSDBuilderSUS
}
