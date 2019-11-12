<#
.SYNOPSIS
Offline Servicing for Windows 10, Windows Server 2016 and Windows Server 2019

.DESCRIPTION
Offline Servicing for Windows 7, Windows 10, Windows Server 2012 R2, Windows Server 2016 and Windows Server 2019

.LINK
https://osdbuilder.osdeploy.com/module/functions/get-osdbuilder
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

        #Initializes OSDBuilder variables
        #This action will occur automatically if OSDBuilder variables are not set
        [switch]$Initialize,

        #Hides Write-Host output.  Used when called from other functions
        #Alias: Silent
        [Alias('Silent')]
        [switch]$HideDetails,

        #Quick options
        [ValidateSet('OneDrive','Download','Cleanup')]
        [string]$Quick,
        
        #Changes the path from the default of C:\OSDBuilder to the path specified
        #Alias: Path
        [Alias('Path','SetPath')]
        [ValidateNotNullOrEmpty()]
        [string]$SetHome,

        #Updates the OSDBuilder Module
        #Alias: Update
        [Alias('Update')]
        [switch]$UpdateModule
    )
    #===================================================================================================
    #   Initialize-OSDBuilder
    #===================================================================================================
    #Must initialize the OSDBuilder variables.  This will set all to defaults
    #If Home is not set, then we need to initialize as well
    if ($SetHome) {Initialize-OSDBuilder -SetHome $SetHome}
    elseif (($Initialize.IsPresent) -or (!($global:GetOSDBuilder.Home))) {Initialize-OSDBuilder}
    if (($(Get-ItemProperty "HKCU:\Software\OSDeploy").GetOSDBuilderHome) -ne $global:GetOSDBuilderHome) {Initialize-OSDBuilder}
    #===================================================================================================
    #   OSDBuilder.PSModule*
    #===================================================================================================
    $global:GetOSDBuilder.PSModuleOSD               = Get-Module -Name OSD | Select-Object *
    $global:GetOSDBuilder.PSModuleOSDSUS            = Get-Module -Name OSDSUS | Select-Object *
    $global:GetOSDBuilder.PSModuleOSDBuilder        = Get-Module -Name OSDBuilder | Select-Object *
    #===================================================================================================
    #   OSDBuilder.Public*
    #===================================================================================================
    $global:GetOSDBuilder.PublicJson                = $null
    $global:GetOSDBuilder.PublicJsonURL             = "https://raw.githubusercontent.com/OSDeploy/OSDBuilder.Public/master/OSDBuilder.json"
    #===================================================================================================
    #   OSDBuilder.Version*
    #===================================================================================================
    $global:GetOSDBuilder.VersionOSD                = $global:GetOSDBuilder.PSModuleOSD.Version | Sort-Object | Select-Object -Last 1
    $global:GetOSDBuilder.VersionOSDPublic          = $global:GetOSDBuilder.VersionOSD

    $global:GetOSDBuilder.VersionOSDSUS             = $global:GetOSDBuilder.PSModuleOSDSUS.Version | Sort-Object | Select-Object -Last 1
    $global:GetOSDBuilder.VersionOSDSUSPublic       = $global:GetOSDBuilder.VersionOSDSUS
    
    $global:GetOSDBuilder.VersionOSDBuilder         = $global:GetOSDBuilder.PSModuleOSDBuilder.Version | Sort-Object | Select-Object -Last 1
    $global:GetOSDBuilder.VersionOSDBuilderPublic   = $global:GetOSDBuilder.VersionOSDBuilder

    if (!($HideDetails.IsPresent)) {
        $StatusCode = try {(Invoke-WebRequest -Uri $global:GetOSDBuilder.PublicJsonURL -UseBasicParsing -DisableKeepAlive).StatusCode}
        catch [Net.WebException]{[int]$_.Exception.Response.StatusCode}
        if ($StatusCode -ne "200") {
            #Check Failed
        } else {
            $global:GetOSDBuilder.PublicJson               = Invoke-RestMethod -Uri $global:GetOSDBuilder.PublicJsonURL
            $global:GetOSDBuilder.VersionOSDPublic         = $global:GetOSDBuilder.PublicJson.OSD
            $global:GetOSDBuilder.VersionOSDSUSPublic      = $global:GetOSDBuilder.PublicJson.OSDSUS
            $global:GetOSDBuilder.VersionOSDBuilderPublic  = $global:GetOSDBuilder.PublicJson.OSDBuilder
        }
    }
    #===================================================================================================
    #   Archive
    #===================================================================================================
    #$global:OSDBuilderPath                  = $global:GetOSDBuilder.Home
    #$global:OSDBuilderOSImport              = $global:SetOSDBuilder.PathOSImport
    #$global:OSDBuilderOSMedia               = $global:SetOSDBuilder.PathOSMedia
    #$global:OSDBuilderOSBuilds              = $global:SetOSDBuilder.PathOSBuilds
    #$global:OSDBuilderPEBuilds              = $global:SetOSDBuilder.PathPEBuilds
    #$global:OSDBuilderTasks                 = $global:GetOSDBuilder.PathTasks
    #$global:OSDBuilderTemplates             = $global:GetOSDBuilder.PathTemplates
    #$global:OSDBuilderContent               = $global:SetOSDBuilder.PathContent

    #$global:GetModuleOSD                    = $global:GetOSDBuilder.PSModuleOSD
    #$global:GetModuleOSDSUS                 = $global:GetOSDBuilder.PSModuleOSDSUS
    #$global:GetModuleOSDBuilder             = $global:GetOSDBuilder.PSModuleOSDBuilder

    #$global:GetModuleOSDVersion             = $global:GetOSDBuilder.VersionOSD
    #$global:GetModuleOSDSUSVersion          = $global:GetOSDBuilder.VersionOSDSUS
    #$global:GetModuleOSDBuilderVersion      = $global:GetOSDBuilder.VersionOSDBuilder
    #$global:GetOSDBuilderVersionOSDBuilder      = $global:GetOSDBuilder.VersionOSDBuilder

    #$global:OSDBuilderPublic                = $global:GetOSDBuilder.PublicJson
    #$global:OSDBuilderPublicURL             = $global:GetOSDBuilder.PublicJsonURL

    #$global:OSDBuilderPublicOSD             = $global:GetOSDBuilder.VersionOSDPublic
    #$global:OSDBuilderPublicOSDSUS          = $global:GetOSDBuilder.VersionOSDSUSPublic
    #$global:OSDBuilderPublicOSDBuilder      = $global:GetOSDBuilder.VersionOSDBuilderPublic
    #===================================================================================================
    #   Display Version Information
    #===================================================================================================
    if (!($HideDetails.IsPresent)) {
        if ($null -eq $global:GetOSDBuilder.PublicJson) {
            Write-Verbose "OSDBuilder $($global:GetOSDBuilder.VersionOSDBuilder) | OSDSUS $($global:GetOSDBuilder.VersionOSDSUS) | OFFLINE" -Verbose
        } else {
            if ($global:GetOSDBuilder.VersionOSDBuilder -ge $global:GetOSDBuilder.VersionOSDBuilderPublic) {
                Write-Host "OSDBuilder $($global:GetOSDBuilder.VersionOSDBuilder) " -ForegroundColor Green -NoNewline
            } else {
                Write-Host "OSDBuilder $($global:GetOSDBuilder.VersionOSDBuilder) " -ForegroundColor Yellow -NoNewline
            }
            Write-Host "| " -ForegroundColor White -NoNewline
        
            if ($global:GetOSDBuilder.VersionOSDSUS -ge $global:GetOSDBuilder.VersionOSDSUSPublic) {
                Write-Host "OSDSUS $($global:GetOSDBuilder.VersionOSDSUS) " -ForegroundColor Green -NoNewline
            } else {
                Write-Host "OSDSUS $($global:GetOSDBuilder.VersionOSDSUS) " -ForegroundColor Yellow -NoNewline
            }
            if (Get-IsContentPacksEnabled) {
                Write-Host "| " -ForegroundColor White -NoNewline
                Write-Host "#MMSJazz Ready" -ForegroundColor Magenta
            } else {
                Write-Host
            }
        }
    }
    #===================================================================================================
    #   Display OSDBulder Home Path
    #===================================================================================================
    if (!($HideDetails.IsPresent)) {
        Write-Host "Home            $global:GetOSDBuilderHome"
        Write-Host "-Content        $global:SetOSDBuilderPathContent" -ForegroundColor Gray
        Write-Host "-ContentPacks   $global:SetOSDBuilderPathContentPacks" -ForegroundColor Gray
        Write-Host "-FeatureUpdates $global:SetOSDBuilderPathFeatureUpdates" -ForegroundColor Gray
        Write-Host "-OSImport       $global:SetOSDBuilderPathOSImport" -ForegroundColor Gray
        Write-Host "-OSMedia        $global:SetOSDBuilderPathOSMedia" -ForegroundColor Gray
        Write-Host "-OSBuilds       $global:SetOSDBuilderPathOSBuilds" -ForegroundColor Gray
        Write-Host "-PEBuilds       $global:SetOSDBuilderPathPEBuilds" -ForegroundColor Gray
        Write-Host "-Mount          $global:SetOSDBuilderPathMount" -ForegroundColor Gray
        Write-Host "-Tasks          $global:SetOSDBuilderPathTasks" -ForegroundColor Gray
        Write-Host "-Templates      $global:SetOSDBuilderPathTemplates" -ForegroundColor Gray
        Write-Host "-Updates        $global:SetOSDBuilderPathUpdates" -ForegroundColor Gray
        #Show-OSDBuilderHomeMap
    }
    #===================================================================================================
    #   Verify Single Version of OSDBuilder
    #===================================================================================================
    if (($global:GetOSDBuilder.PSModuleOSDBuilder).Count -gt 1) {
        Write-Warning "Multiple OSDBuilder Modules are loaded"
        Write-Warning "Close all open PowerShell sessions before using OSDBuilder"
        Break
    }
    #===================================================================================================
    #   CreatePaths
    #===================================================================================================
    if ($CreatePaths.IsPresent) {
        New-ItemDirectoryGetOSDBuilderHome
        New-ItemDirectorySetOSDBuilderPathContent
        New-OSDBuilderContentPack -Name '_Global'
    }
    #===================================================================================================
    #   Remove Directories
    #===================================================================================================
    $OSDBuilderOldDirectories = @(
        "$SetOSDBuilderPathContent\UpdateStacks"
        "$SetOSDBuilderPathContent\UpdateWindows"
        "$SetOSDBuilderPathUpdates\Windows 10 1903"
    )

    foreach ($item in $OSDBuilderOldDirectories) {
        if (Test-Path "$item") {
            Write-Warning "'$item' is no longer required and should be removed"
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
        #===================================================================================================
        #   Display Home Content
        #===================================================================================================
        if (!($HideDetails.IsPresent)) {
            if ($global:GetOSDBuilder.VersionOSDBuilder -gt $global:GetOSDBuilder.VersionOSDBuilderPublic) {
                Write-Host
                Write-Host "OSDBuilder Release Preview" -ForegroundColor Green
                Write-Host "The current Public version is $($global:GetOSDBuilder.VersionOSDBuilderPublic)" -ForegroundColor DarkGray
            } elseif ($global:GetOSDBuilder.VersionOSDBuilder -eq $global:GetOSDBuilder.VersionOSDBuilderPublic) {
                #Write-Host "OSDBuilder is up to date" -ForegroundColor Green
                #""
            } else {
                Write-Host
                Write-Warning "OSDBuilder can be updated to $($global:GetOSDBuilder.VersionOSDBuilderPublic)"
                Write-Host "OSDBuilder -Update" -ForegroundColor Cyan
            }

            if ($global:GetOSDBuilder.VersionOSDSUS -gt $global:GetOSDBuilder.VersionOSDSUSPublic) {
                Write-Host
                Write-Host "OSDSUS Release Preview" -ForegroundColor Green
                Write-Host "The current Public version is $($global:GetOSDBuilder.VersionOSDSUSPublic)" -ForegroundColor DarkGray
            } elseif ($global:GetOSDBuilder.VersionOSDSUS -eq $global:GetOSDBuilder.VersionOSDSUSPublic) {
                #Write-Host "OSDSUS is up to date" -ForegroundColor Green
            } else {
                Write-Host
                Write-Warning "OSDSUS can be updated to $($global:GetOSDBuilder.VersionOSDSUSPublic)"
                Write-Host "Update-OSDSUS" -ForegroundColor Cyan
            }

            Write-Host ""
            Write-Host "Latest Updates:" -ForegroundColor Gray
            foreach ($line in $global:GetOSDBuilder.PublicJson.LatestUpdates) {Write-Host $line -ForegroundColor DarkGray}
            Write-Host ""
            Write-Host "Helpful Links:" -ForegroundColor Gray
            foreach ($line in $global:GetOSDBuilder.PublicJson.HelpfulLinks) {Write-Host $line -ForegroundColor DarkGray}
            Write-Host ""
            Write-Host "New Links:" -ForegroundColor Gray
            foreach ($line in $global:GetOSDBuilder.PublicJson.NewLinks) {Write-Host $line -ForegroundColor DarkGray}

        }
        Show-OSDBuilderHomeTips
    }
    if ($UpdateModule.IsPresent) {
        Update-OSDSUS
        Update-ModuleOSDBuilder
    }
}