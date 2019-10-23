<#
.SYNOPSIS
Offline Servicing for Windows 10, Windows Server 2016 and Windows Server 2019

.DESCRIPTION
Offline Servicing for Windows 7, Windows 10, Windows Server 2012 R2, Windows Server 2016 and Windows Server 2019

.LINK
https://osdbuilder.osdeploy.com/module/functions/get-osdbuilder

.EXAMPLE
Get-OSDBuilder -SetPath D:\OSDBuilder
Sets the OSDBuilder Main directory to D:\OSDBuilder

.EXAMPLE
Get-OSDBuilder -CreatePaths
Creates empty directories used by OSDBuilder
#>
function Get-OSDBuilder {
    [CmdletBinding()]
    Param (
        #Creates OSDBuilder directory structure
        #Directories are automatically created with first Import
        #Alias: Create
        [Alias('Create')]
        [switch]$CreatePaths,

        #Quick Download options
        [ValidateSet('FeatureUpdates','OneDrive','OneDriveEnterprise','OSMediaUpdates')]
        [string]$Download,

        #Hides Write-Host output.  Used when called from other functions
        #Alias: Silent
        [Alias('Silent')]
        [switch]$HideDetails,

        #Quick options
        [ValidateSet('OneDrive','Download','Cleanup')]
        [string]$Quick,
        
        #Changes the path from the default of C:\OSDBuilder to the path specified
        #Alias: Path
        [Alias('Path')]
        [string]$SetPath,

        #Updates the OSDBuilder Module
        #Alias: Update
        [Alias('Update')]
        [switch]$UpdateModule
    )
    #===================================================================================================
    #   Get-OSDBuilderPath
    #===================================================================================================
    if (!(Test-Path HKCU:\Software\OSDeploy\OSBuilder)) {New-Item HKCU:\Software\OSDeploy -Name OSBuilder -Force | Out-Null}
    if (!(Get-ItemProperty -Path 'HKCU:\Software\OSDeploy' -Name OSBuilderPath -ErrorAction SilentlyContinue)) {New-ItemProperty -Path "HKCU:\Software\OSDeploy" -Name OSBuilderPath -Force | Out-Null}
    if ($SetPath) {Set-ItemProperty -Path "HKCU:\Software\OSDeploy" -Name "OSBuilderPath" -Value "$SetPath" -Force}
    $global:OSDBuilderPath = $(Get-ItemProperty "HKCU:\Software\OSDeploy").OSBuilderPath
    if (!($OSDBuilderPath)) {$global:OSDBuilderPath = "$Env:SystemDrive\OSDBuilder"}
    #===================================================================================================
    #   OSD Versions
    #===================================================================================================
    $global:OSDBuilderVersion = $(Get-Module -Name OSDBuilder | Sort-Object Version | Select-Object Version -Last 1).Version
    $global:OSDVersion = $(Get-Module -Name OSD | Sort-Object Version | Select-Object Version -Last 1).Version
    $global:OSDSUSVersion = $(Get-Module -Name OSDSUS | Sort-Object Version | Select-Object Version -Last 1).Version
    if ($HideDetails -eq $false) {
        Write-Host "OSDBuilder $OSDBuilderVersion | OSDSUS $OSDSUSVersion | Home $OSDBuilderPath" -ForegroundColor Cyan
        Write-Host ""
    }
    #===================================================================================================
    #   Verify Single Version of OSDBuilder
    #===================================================================================================
    if ((Get-Module -Name OSDBuilder).Count -gt 1) {
        Write-Warning "Multiple OSDBuilder Modules are loaded"
        Write-Warning "Close all open PowerShell sessions before using OSDBuilder"
        Break
    }
    #===================================================================================================
    #   19.3.9 OSDBuilder URLs
    #===================================================================================================
    $global:OSDBuilderURL = "https://raw.githubusercontent.com/OSDeploy/OSDBuilder.Public/master/OSDBuilder.json"
    #===================================================================================================
    #   OSDBuilder Primary Directories
    #===================================================================================================
    $global:OSDBuilderBuildPacks =   "$OSDBuilderPath\BuildPacks"
    $global:OSDBuilderContent =      "$OSDBuilderPath\Content"
    $global:OSDBuilderOSBuilds =     "$OSDBuilderPath\OSBuilds"
    $global:OSDBuilderOSImport =     "$OSDBuilderPath\OSImport"
    $global:OSDBuilderOSMedia =      "$OSDBuilderPath\OSMedia"
    $global:OSDBuilderPEBuilds =     "$OSDBuilderPath\PEBuilds"
    $global:OSDBuilderTasks =        "$OSDBuilderPath\Tasks"
    $global:OSDBuilderTemplates =    "$OSDBuilderPath\Templates"

    $global:OSBuilderContent =      "$OSDBuilderPath\Content"
    $global:OSBuilderOSBuilds =     "$OSDBuilderPath\OSBuilds"
    $global:OSBuilderOSImport =     "$OSDBuilderPath\OSImport"
    $global:OSBuilderOSMedia =      "$OSDBuilderPath\OSMedia"
    $global:OSBuilderPEBuilds =     "$OSDBuilderPath\PEBuilds"
    $global:OSBuilderTasks =        "$OSDBuilderPath\Tasks"
    $global:OSBuilderTemplates =    "$OSDBuilderPath\Templates"
    #===================================================================================================
    #   BuildPacks
    #===================================================================================================
    $global:BuildPacksEnabled = $true
    if (Test-Path $OSDBuilderTemplates\Drivers) {$global:BuildPacksEnabled = $false}
    if (Test-Path $OSDBuilderTemplates\ExtraFiles) {$global:BuildPacksEnabled = $false}
    if (Test-Path $OSDBuilderTemplates\Registry) {$global:BuildPacksEnabled = $false}
    if (Test-Path $OSDBuilderTemplates\Scripts) {$global:BuildPacksEnabled = $false}
    #===================================================================================================
    #   New-OSDBuilderCreatePaths
    #===================================================================================================
    if ($CreatePaths.IsPresent) {New-OSDBuilderCreatePaths}
    #===================================================================================================
    #   Remove Directories
    #===================================================================================================
    $OSDBuilderOldDirectories = @(
        "$OSDBuilderContent\UpdateStacks"
        "$OSDBuilderContent\UpdateWindows"
        "$OSDBuilderContent\OSDUpdate\Windows 10 1903"
    )

    foreach ($OSDBuilderDir in $OSDBuilderOldDirectories) {
        if (Test-Path "$OSDBuilderDir") {
            Write-Warning "'$OSDBuilderDir' is no longer required and should be removed"
        }
    }
    #===================================================================================================
    #   DownloadOneDrive
    #===================================================================================================
    if ($Quick -eq 'Download' -or $Download -eq 'OSMediaUpdates') {
        $HideDetails = $true
        Get-OSMedia | Update-OSMedia -Download
        Return
    }
    if ($Quick -eq 'Cleanup') {
        $HideDetails = $true
        Get-DownOSDBuilder -Superseded Remove
        Return
    }
    if ($Download -eq 'FeatureUpdates') {
        $HideDetails = $true
        Get-DownOSDBuilder -FeatureUpdates
        Return
    }
    if ($Download -eq 'OneDrive' -or $Quick -eq 'OneDrive') {
        $HideDetails = $true
        Get-DownOSDBuilder -ContentDownload "OneDriveSetup Production"
        Return
    }
    if ($Download -eq 'OneDriveEnterprise') {
        $HideDetails = $true
        Get-DownOSDBuilder -ContentDownload "OneDriveSetup Enterprise"
        Return
    }
    #===================================================================================================
    #   Show-OSDBuilderHome
    #===================================================================================================
    if ($HideDetails -eq $false) {
        Show-OSDBuilderHomeOnline
        #Show-OSDBuilderHomeMap
        Show-OSDBuilderHomeTips
    }
    if ($UpdateModule.IsPresent) {Update-ModuleOSDBuilder}
}