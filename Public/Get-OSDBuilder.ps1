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

    $global:OSDBuilder = @{}
    #===================================================================================================
    #   Get-OSDBuilderPath
    #===================================================================================================
    if (!(Test-Path HKCU:\Software\OSDeploy\OSBuilder)) {New-Item HKCU:\Software\OSDeploy -Name OSBuilder -Force | Out-Null}
    if (!(Get-ItemProperty -Path 'HKCU:\Software\OSDeploy' -Name OSBuilderPath -ErrorAction SilentlyContinue)) {New-ItemProperty -Path "HKCU:\Software\OSDeploy" -Name OSBuilderPath -Force | Out-Null}
    if ($SetPath) {Set-ItemProperty -Path "HKCU:\Software\OSDeploy" -Name "OSBuilderPath" -Value "$SetPath" -Force}
    $global:OSDBuilderPath = $(Get-ItemProperty "HKCU:\Software\OSDeploy").OSBuilderPath
    if (!($OSDBuilderPath)) {$global:OSDBuilderPath = "$Env:SystemDrive\OSDBuilder"}
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
    if (Get-IsBuildPacksEnabled) {
        #$global:OSDBuilderTemplates =    "$OSDBuilderPath\BuildPacks\_Mandatory"
    } else {
        #$global:OSDBuilderTemplates =    "$OSDBuilderPath\Templates"
    }
    #===================================================================================================
    #   Get Module Information
    #===================================================================================================
    $global:GetModuleOSD = Get-Module -Name OSD | Select-Object *
    $global:GetModuleOSDSUS = Get-Module -Name OSDSUS | Select-Object *
    $global:GetModuleOSDBuilder = Get-Module -Name OSDBuilder | Select-Object *

    $global:GetModuleOSDVersion = ($global:GetModuleOSD | Sort-Object Version | Select-Object Version -Last 1).Version
    $global:GetModuleOSDSUSVersion = ($global:GetModuleOSDSUS | Sort-Object Version | Select-Object Version -Last 1).Version
    $global:GetModuleOSDBuilderVersion = ($global:GetModuleOSDBuilder | Sort-Object Version | Select-Object Version -Last 1).Version
    #===================================================================================================
    #   GitHub Update URL
    #===================================================================================================
    $global:OSDBuilderPublicURL = "https://raw.githubusercontent.com/OSDeploy/OSDBuilder.Public/master/OSDBuilder.json"
    #===================================================================================================
    #   Get Online Module Information
    #===================================================================================================
    $global:OSDBuilderPublic = $null

    $global:OSDBuilderPublicOSD = $GetModuleOSDVersion
    $global:OSDBuilderPublicOSDSUS = $GetModuleOSDSUSVersion
    $global:OSDBuilderPublicOSDBuilder = $GetModuleOSDBuilderVersion

    if (!($HideDetails.IsPresent)) {
        $StatusCode = try {(Invoke-WebRequest -Uri $OSDBuilderPublicURL -UseBasicParsing -DisableKeepAlive).StatusCode}
        catch [Net.WebException]{[int]$_.Exception.Response.StatusCode}
        if ($StatusCode -ne "200") {
            #Check Failed
        } else {
            $global:OSDBuilderPublic = Invoke-RestMethod -Uri $OSDBuilderPublicURL
            $global:OSDBuilderPublicOSD = $OSDBuilderPublic.OSD
            $global:OSDBuilderPublicOSDSUS = $OSDBuilderPublic.OSDSUS
            $global:OSDBuilderPublicOSDBuilder = $OSDBuilderPublic.OSDBuilder
        }
    }
    #===================================================================================================
    #   Display Version Information
    #===================================================================================================
    if ($HideDetails.IsPresent) {
        #Write-Verbose "OSDBuilder $GetModuleOSDBuilderVersion | OSDSUS $GetModuleOSDSUSVersion" -Verbose
        #Write-Verbose "OSDBuilder $GetModuleOSDBuilderVersion | OSDSUS $GetModuleOSDSUSVersion | OSD $GetModuleOSDVersion" -Verbose
    } else {
        if ($null -eq $global:OSDBuilderPublic) {
            Write-Verbose "OSDBuilder $GetModuleOSDBuilderVersion | OSDSUS $GetModuleOSDSUSVersion | OFFLINE" -Verbose
            #Write-Verbose "OSDBuilder $GetModuleOSDBuilderVersion | OSDSUS $GetModuleOSDSUSVersion | OSD $GetModuleOSDVersion | OFFLINE" -Verbose
        } else {
            if ($GetModuleOSDBuilderVersion -ge $OSDBuilderPublicOSDBuilder) {
                Write-Host "OSDBuilder $GetModuleOSDBuilderVersion " -ForegroundColor Green -NoNewline
            } else {
                Write-Host "OSDBuilder $GetModuleOSDBuilderVersion " -ForegroundColor Yellow -NoNewline
            }
            Write-Host "| " -ForegroundColor White -NoNewline
        
            if ($GetModuleOSDSUSVersion -ge $OSDBuilderPublicOSDSUS) {
                Write-Host "OSDSUS $GetModuleOSDSUSVersion " -ForegroundColor Green -NoNewline
                #Write-Host "OSDSUS $GetModuleOSDSUSVersion " -ForegroundColor Yellow -NoNewline
            } else {
                Write-Host "OSDSUS $GetModuleOSDSUSVersion " -ForegroundColor Yellow -NoNewline
                #Write-Host "OSDSUS $GetModuleOSDSUSVersion " -ForegroundColor Green -NoNewline
            }
            if (Get-IsBuildPacksEnabled) {
                Write-Host "| " -ForegroundColor White -NoNewline
                Write-Host "#MMSJazz Ready" -ForegroundColor Magenta
            } else {
                Write-Host
            }
            #Write-Host "| " -ForegroundColor White -NoNewline
            #if ($GetModuleOSDVersion -ne $OSDBuilderPublicOSD) {
            #    Write-Host "OSD $GetModuleOSDVersion " -ForegroundColor Yellow
            #} else {
            #    Write-Host "OSD $GetModuleOSDVersion " -ForegroundColor Green
            #}
        }
    }
    #===================================================================================================
    #   Display OSDBulder Home Path
    #===================================================================================================
    if (!($HideDetails.IsPresent)) {
        Write-Host "Home" -NoNewline
        Write-Host " $OSDBuilderPath"
    }
    #===================================================================================================
    #   Verify Single Version of OSDBuilder
    #===================================================================================================
    if (($global:GetModuleOSDBuilder).Count -gt 1) {
        Write-Warning "Multiple OSDBuilder Modules are loaded"
        Write-Warning "Close all open PowerShell sessions before using OSDBuilder"
        Break
    }
    #===================================================================================================
    #   CreatePaths
    #===================================================================================================
    if ($CreatePaths.IsPresent) {
        New-ItemDirectoryOSDBuilderRoot
        New-ItemDirectoryOSDBuilderContent
        New-OSDBuildPack -Name '_Mandatory'
        New-OSDBuildPack -Name '_Template'
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
    #   Show-OSDBuilderHome
    #===================================================================================================
    if ($HideDetails -eq $false) {
        #===================================================================================================
        #   Display Home Content
        #===================================================================================================
        if (!($HideDetails.IsPresent)) {
            if ($GetModuleOSDBuilderVersion -gt $OSDBuilderPublicOSDBuilder) {
                Write-Host
                Write-Host "OSDBuilder Release Preview" -ForegroundColor Green
                Write-Host "The current Public version is $OSDBuilderPublicOSDBuilder" -ForegroundColor DarkGray
            } elseif ($GetModuleOSDBuilderVersion -eq $OSDBuilderPublicOSDBuilder) {
                #Write-Host "OSDBuilder is up to date" -ForegroundColor Green
                #""
            } else {
                Write-Host
                Write-Warning "OSDBuilder can be updated to $OSDBuilderPublicOSDBuilder"
                Write-Host "OSDBuilder -Update" -ForegroundColor Cyan
            }

            if ($GetModuleOSDSUSVersion -gt $OSDBuilderPublicOSDSUS) {
                Write-Host
                Write-Host "OSDSUS Release Preview" -ForegroundColor Green
                Write-Host "The current Public version is $OSDBuilderPublicOSDSUS" -ForegroundColor DarkGray
            } elseif ($GetModuleOSDSUSVersion -eq $OSDBuilderPublicOSDSUS) {
                #Write-Host "OSDSUS is up to date" -ForegroundColor Green
            } else {
                Write-Host
                Write-Warning "OSDSUS can be updated to $OSDBuilderPublicOSDSUS"
                Write-Host "Update-OSDSUS" -ForegroundColor Cyan
            }

            Write-Host ""
            Write-Host "Latest Updates:" -ForegroundColor Gray
            foreach ($line in $($OSDBuilderPublic.LatestUpdates)) {Write-Host $line -ForegroundColor DarkGray}
            Write-Host ""
            Write-Host "Helpful Links:" -ForegroundColor Gray
            foreach ($line in $($OSDBuilderPublic.HelpfulLinks)) {Write-Host $line -ForegroundColor DarkGray}
            Write-Host ""
            Write-Host "New Links:" -ForegroundColor Gray
            foreach ($line in $($OSDBuilderPublic.NewLinks)) {Write-Host $line -ForegroundColor DarkGray}

        }


        #Show-OSDBuilderHomeOnline
        #Show-OSDBuilderHomeMap
        Show-OSDBuilderHomeTips
    }
    if ($UpdateModule.IsPresent) {
        Update-OSDSUS
        Update-ModuleOSDBuilder
    }
}