<#
.SYNOPSIS
Offline Servicing for Windows 7, Windows 10, Windows Server 2012 R2, Windows Server 2016 and Windows Server 2019

.DESCRIPTION
Offline Servicing for Windows 7, Windows 10, Windows Server 2012 R2, Windows Server 2016 and Windows Server 2019

.LINK
https://osdbuilder.osdeploy.com/module/functions/get-osdbuilder

.PARAMETER CreatePaths
Alias: Create
Creates empty directories used by OSDBuilder

.PARAMETER HideDetails
Alias: Silent
Hides Write-Host output.  Used when called from other functions

.PARAMETER SetPath
Alias: Path
Changes the path from the default of C:\OSDBuilder to the path specified

.PARAMETER UpdateModule
Alias: Update
Updates the OSDBuilder Module

.EXAMPLE
Get-OSDBuilder -SetPath D:\OSDBuilder
Sets the OSDBuilder Main directory to D:\OSDBuilder

.EXAMPLE
Get-OSDBuilder -CreatePaths
Creates empty directories used by OSDBuilder

.EXAMPLE
Get-OSDBuilder -HideDetails
Method for refreshing all OSDBuilder Variables.  Used by other OSDBuilder Functions
#>
function Get-OSDBuilder {
    [CmdletBinding()]
    Param (
        [Alias('Create')]
        [switch]$CreatePaths,

        [ValidateSet('OneDrive','Download','Cleanup')]
        [string]$Quick,

        [ValidateSet('FeatureUpdates','OneDrive','OneDriveEnterprise','OSMediaUpdates')]
        [string]$Download,

        [Alias('Silent')]
        [switch]$HideDetails,
        
        [Alias('Path')]
        [string]$SetPath,

        [Alias('Update')]
        [switch]$UpdateModule
    )
    #===================================================================================================
    #   Verify Single Version of OSDBuilder
    #===================================================================================================
    if ((Get-Module -Name OSDBuilder).Count -gt 1) {
        Write-Warning "Multiple OSDBuilder Modules are loaded"
        Write-Warning "Close all open PowerShell sessions before using OSDBuilder"
        Exit
    }
    #===================================================================================================
    #   19.3.9 OSDBuilder URLs
    #===================================================================================================
    $global:OSDBuilderURL = "https://raw.githubusercontent.com/OSDeploy/OSDBuilder.Public/master/OSDBuilder.json"
    #===================================================================================================
    #   19.2.8  Get OSDBuilder Version
    #===================================================================================================
    $global:OSDBuilderVersion = $(Get-Module -Name OSDBuilder | Sort-Object Version | Select-Object Version -Last 1).Version
    if ($HideDetails -eq $false) {
        Write-Host "OSDBuilder $OSDBuilderVersion" -ForegroundColor Cyan
    }
    #===================================================================================================
    #   18.10.1 Create Empty Registry Key and Values
    #===================================================================================================
    if (!(Test-Path HKCU:\Software\OSDeploy\OSBuilder)) {New-Item HKCU:\Software\OSDeploy -Name OSBuilder -Force | Out-Null}
    #===================================================================================================
    #   18.10.1 Set Global OSDBuilder
    #===================================================================================================
    if (!(Get-ItemProperty -Path 'HKCU:\Software\OSDeploy' -Name OSBuilderPath -ErrorAction SilentlyContinue)) {New-ItemProperty -Path "HKCU:\Software\OSDeploy" -Name OSBuilderPath -Force | Out-Null}
    if ($SetPath) {Set-ItemProperty -Path "HKCU:\Software\OSDeploy" -Name "OSBuilderPath" -Value "$SetPath" -Force}
    $global:OSDBuilderPath = $(Get-ItemProperty "HKCU:\Software\OSDeploy").OSBuilderPath
    if (!($OSDBuilderPath)) {$global:OSDBuilderPath = "$Env:SystemDrive\OSDBuilder"}
    #===================================================================================================
    #   19.3.15 Set Primary Paths
    #===================================================================================================
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
    #   19.9.18  New Directories
    #===================================================================================================
    $OSDBuilderNewDirectories = @(
        $OSDBuilderPath
        $OSDBuilderOSBuilds
        $OSDBuilderOSImport
        $OSDBuilderOSMedia
        $OSDBuilderPEBuilds
        $OSDBuilderTasks
        $OSDBuilderTemplates
        $OSDBuilderContent
        "$OSDBuilderContent\ADK"
        "$OSDBuilderContent\ADK\Windows 10 1903\Windows Preinstallation Environment"
        "$OSDBuilderContent\ADK\Windows 10 1909\Windows Preinstallation Environment"
        "$OSDBuilderContent\DaRT"
        "$OSDBuilderContent\DaRT\DaRT 10"
        "$OSDBuilderContent\Drivers"
        "$OSDBuilderContent\ExtraFiles"
        "$OSDBuilderContent\IsoExtract"
        "$OSDBuilderContent\IsoExtract\Windows 10 1903 FOD x64"
        "$OSDBuilderContent\IsoExtract\Windows 10 1903 FOD x64"
        "$OSDBuilderContent\IsoExtract\Windows 10 1903 Language"
        "$OSDBuilderContent\IsoExtract\Windows 10 1909 Language"
        "$OSDBuilderContent\IsoExtract\Windows Server 2019 1809 FOD x64"
        "$OSDBuilderContent\IsoExtract\Windows Server 2019 1809 Language"
        #"$OSDBuilderContent\LanguagePacks"
        "$OSDBuilderContent\Mount"
        "$OSDBuilderContent\OneDrive"
        "$OSDBuilderContent\OSDUpdate"
        "$OSDBuilderContent\Packages"
        #"$OSDBuilderContent\Packages\Win10 x64 1809"
        #"$OSDBuilderContent\Provisioning"
        #"$OSDBuilderContent\Registry"
        "$OSDBuilderContent\Scripts"
        "$OSDBuilderContent\StartLayout"
        "$OSDBuilderContent\Unattend"
        #"$OSDBuilderContent\Updates"
        #"$OSDBuilderContent\Updates\Custom"
        #"$OSDBuilderContent\WinPE"
        #"$OSDBuilderContent\WinPE\ADK\Win10 x64 1809"
        #"$OSDBuilderContent\WinPE\DaRT\DaRT 10"
        #"$OSDBuilderContent\WinPE\Drivers"
        #"$OSDBuilderContent\WinPE\Drivers\WinPE 10 x64"
        #"$OSDBuilderContent\WinPE\Drivers\WinPE 10 x86"
        #"$OSDBuilderContent\WinPE\ExtraFiles"
        #"$OSDBuilderContent\WinPE\Scripts"
    )

    if ($CreatePaths.IsPresent) {
        foreach ($OSDBuilderDir in $OSDBuilderNewDirectories) {
            if (!(Test-Path "$OSDBuilderDir")) {
                New-Item "$OSDBuilderDir" -ItemType Directory -Force | Out-Null
            }
        }
    }
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
    #   19.3.4  Write Map
    #===================================================================================================
    if ($HideDetails -eq $false) {
        if (Test-Path "$OSDBuilderPath")                {Write-Host "Home:              $OSDBuilderPath" -ForegroundColor White}
            else                                        {Write-Host "Home:              $OSDBuilderPath (does not exist)" -ForegroundColor White}
        if (Test-Path "$OSDBuilderOSImport")            {Write-Host "OSImport:          $OSDBuilderOSImport" -ForegroundColor Gray}
            else                                        {Write-Host "OSImport:          $OSDBuilderOSImport (does not exist)" -ForegroundColor Gray}
        if (Test-Path "$OSDBuilderOSMedia")             {Write-Host "OSMedia:           $OSDBuilderOSMedia" -ForegroundColor Gray}
            else                                        {Write-Host "OSMedia:           $OSDBuilderOSMedia (does not exist)" -ForegroundColor Gray}
        if (Test-Path "$OSDBuilderOSBuilds")            {Write-Host "OSBuilds:          $OSDBuilderOSBuilds" -ForegroundColor Gray}
            else                                        {Write-Host "OSBuilds:          $OSDBuilderOSBuilds (does not exist)" -ForegroundColor Gray}
        if (Test-Path "$OSDBuilderPEBuilds")            {Write-Host "PEBuilds:          $OSDBuilderPEBuilds" -ForegroundColor Gray}
            else                                        {Write-Host "PEBuilds:          $OSDBuilderPEBuilds (does not exist)" -ForegroundColor Gray}
        if (Test-Path "$OSDBuilderTasks")               {Write-Host "Tasks:             $OSDBuilderTasks" -ForegroundColor Gray}
            else                                        {Write-Host "Tasks:             $OSDBuilderTasks (does not exist)" -ForegroundColor Gray}
        if (Test-Path "$OSDBuilderTemplates")           {Write-Host "Templates:         $OSDBuilderTemplates" -ForegroundColor Gray}
            else                                        {Write-Host "Templates:         $OSDBuilderTemplates (does not exist)" -ForegroundColor Gray}
        if (Test-Path "$OSDBuilderContent")             {Write-Host "Content:           $OSDBuilderContent" -ForegroundColor Gray}
            else                                        {Write-Host "Content:           $OSDBuilderContent (does not exist)" -ForegroundColor Gray}
<#         if (Test-Path "$OSDBuilderContent\Drivers")     {Write-Host "-Drivers:          $OSDBuilderContent\Drivers" -ForegroundColor DarkGray}
            else                                        {Write-Host "-Drivers:          $OSDBuilderContent\Drivers (does not exist)" -ForegroundColor DarkGray}
        if (Test-Path "$OSDBuilderContent\ExtraFiles")  {Write-Host "-Extra Files:      $OSDBuilderContent\ExtraFiles" -ForegroundColor DarkGray}
            else                                        {Write-Host "-Extra Files:      $OSDBuilderContent\ExtraFiles (does not exist)" -ForegroundColor DarkGray}
        if (Test-Path "$OSDBuilderContent\IsoExtract")  {Write-Host "-IsoExtract:       $OSDBuilderContent\IsoExtract" -ForegroundColor DarkGray}
            else                                        {Write-Host "-IsoExtract:       $OSDBuilderContent\IsoExtract (does not exist)" -ForegroundColor DarkGray}
        if (Test-Path "$OSDBuilderContent\Mount")       {Write-Host "-MountPath:        $OSDBuilderContent\Mount" -ForegroundColor DarkGray}
            else                                        {Write-Host "-MountPath:        $OSDBuilderContent\Mount (does not exist)" -ForegroundColor DarkGray}
        if (Test-Path "$OSDBuilderContent\ADK")         {Write-Host "-ADK:              $OSDBuilderContent\ADK" -ForegroundColor DarkGray}
            else                                        {Write-Host "-ADK:              $OSDBuilderContent\ADK (does not exist)" -ForegroundColor DarkGray}
        if (Test-Path "$OSDBuilderContent\DaRT")        {Write-Host "-DaRT:             $OSDBuilderContent\DaRT" -ForegroundColor DarkGray}
            else                                        {Write-Host "-DaRT:             $OSDBuilderContent\DaRT (does not exist)" -ForegroundColor DarkGray}
        if (Test-Path "$OSDBuilderContent\OneDrive")    {Write-Host "-OneDrive:         $OSDBuilderContent\OneDrive" -ForegroundColor DarkGray}
            else                                        {Write-Host "-OneDrive:         $OSDBuilderContent\OneDrive (does not exist)" -ForegroundColor DarkGray}
        if (Test-Path "$OSDBuilderContent\OSDUpdate")   {Write-Host "-OSDUpdate:        $OSDBuilderContent\OSDUpdate" -ForegroundColor Gray}
            else                                        {Write-Host "-OSDUpdate:        $OSDBuilderContent\OSDUpdate (does not exist)" -ForegroundColor Gray}
        if (Test-Path "$OSDBuilderContent\Packages")    {Write-Host "-Packages:         $OSDBuilderContent\Packages" -ForegroundColor DarkGray}
            else                                        {Write-Host "-Packages:         $OSDBuilderContent\Packages (does not exist)" -ForegroundColor DarkGray}
        if (Test-Path "$OSDBuilderContent\Scripts")     {Write-Host "-Scripts:          $OSDBuilderContent\Scripts" -ForegroundColor DarkGray}
            else                                        {Write-Host "-Scripts:          $OSDBuilderContent\Scripts (does not exist)" -ForegroundColor DarkGray}
        if (Test-Path "$OSDBuilderContent\StartLayout") {Write-Host "-Start Layouts:    $OSDBuilderContent\StartLayout" -ForegroundColor DarkGray}
            else                                        {Write-Host "-Start Layouts:    $OSDBuilderContent\StartLayout (does not exist)" -ForegroundColor DarkGray}
        if (Test-Path "$OSDBuilderContent\Unattend")    {Write-Host "-Unattend XML:     $OSDBuilderContent\Unattend" -ForegroundColor DarkGray}
            else                                        {Write-Host "-Unattend XML:     $OSDBuilderContent\Unattend (does not exist)" -ForegroundColor DarkGray} #>
        Write-Host ""
    }
    #===================================================================================================
    #   19.3.9 OSDBuilder Online
    #===================================================================================================
    if ($HideDetails -eq $false) {
        $statuscode = try {(Invoke-WebRequest -Uri $OSDBuilderURL -UseBasicParsing -DisableKeepAlive).StatusCode}
        catch [Net.WebException]{[int]$_.Exception.Response.StatusCode}
        if (!($statuscode -eq "200")) {
        } else {
            $LatestModuleVersion = @()
            $LatestModuleVersion = Invoke-RestMethod -Uri $OSDBuilderURL
            
            if ([System.Version]$($LatestModuleVersion.Version) -eq [System.Version]$OSDBuilderVersion) {
                Write-Host "OSDBuilder Module $OSDBuilderVersion" -ForegroundColor Green
                foreach ($line in $($LatestModuleVersion.LatestUpdates)) {Write-Host $line -ForegroundColor DarkGray}
                Write-Host ""
                Write-Host "New Links:" -ForegroundColor Cyan
                foreach ($line in $($LatestModuleVersion.NewLinks)) {Write-Host $line -ForegroundColor Gray}
                Write-Host ""
                Write-Host "Helpful Links:" -ForegroundColor Cyan
                foreach ($line in $($LatestModuleVersion.HelpfulLinks)) {Write-Host $line -ForegroundColor Gray}
            } elseif ([System.Version]$($LatestModuleVersion.Version) -lt [System.Version]$OSDBuilderVersion) {
                Write-Host "OSDBuilder Module $OSDBuilderVersion" -ForegroundColor Green
                Write-Warning "You are running a Pre-Release version of OSDBuilder"
                Write-Host "Public Version: $($LatestModuleVersion.Version)" -ForegroundColor DarkGray
                foreach ($line in $($LatestModuleVersion.LatestUpdates)) {Write-Host $line -ForegroundColor DarkGray}
                Write-Host ""
                Write-Host "New Links:" -ForegroundColor Cyan
                foreach ($line in $($LatestModuleVersion.NewLinks)) {Write-Host $line -ForegroundColor Gray}
                Write-Host ""
                Write-Host "Helpful Links:" -ForegroundColor Cyan
                foreach ($line in $($LatestModuleVersion.HelpfulLinks)) {Write-Host $line -ForegroundColor Gray}
            } else {
                Write-Host "PowerShell Gallery: $($LatestModuleVersion.Version)" -ForegroundColor DarkGray
                Write-Host "Installed Version: $OSDBuilderVersion" -ForegroundColor DarkGray
                Write-Warning "Updated OSDBuilder Module on PowerShell Gallery"
                foreach ($line in $($LatestModuleVersion.PSGallery)) {Write-Host $line -ForegroundColor DarkGray}
                Write-Host "Update Module Command: OSDBuilder -Update" -ForegroundColor Cyan
            }
        }
    }
    #===================================================================================================
    #   Tips
    #===================================================================================================
    if ($HideDetails -eq $false) {
        Write-Host ''

        Write-Host 'Change OSDBuilder Home Path:                        ' -NoNewline
        Write-Host 'OSDBuilder -SetPath D:\OSDBuilder' -ForegroundColor Cyan

        Write-Host 'Create OSDBuilder Directory Structure:              ' -NoNewline
        Write-Host 'OSDBuilder -CreatePaths' -ForegroundColor Cyan

        Write-Host 'Update OSDBuilder Module to the latest version:     ' -NoNewline
        Write-Host 'OSDBuilder -Update' -ForegroundColor Cyan
        
        Write-Host ''

        Write-Host 'Download missing Microsoft Updates for OSMedia:     ' -NoNewline
        Write-Host 'OSDBuilder -Download OSMediaUpdates' -ForegroundColor Green

        Write-Host 'Download Windows 10 Feature Updates for Import:     ' -NoNewline
        Write-Host 'OSDBuilder -Download FeatureUpdates' -ForegroundColor Green

        Write-Host 'Download the latest OneDriveSetup.exe:              ' -NoNewline
        Write-Host 'OSDBuilder -Download OneDrive' -ForegroundColor Green

        Write-Host 'Download the latest OneDriveSetup.exe (Enterprise): ' -NoNewline
        Write-Host 'OSDBuilder -Download OneDriveEnterprise' -ForegroundColor Green
        Write-Host ''
    }
    #===================================================================================================
    #   Update-ModuleOSDBuilder
    #===================================================================================================
    if ($UpdateModule.IsPresent) {Update-ModuleOSDBuilder}
}