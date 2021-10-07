function Initialize-OSDBuilder {
    [CmdletBinding()]
    param (
        #Sets the OSDBuilder Path in the Registry
        [string]$SetHome
    )
    #=================================================
    #   GetOSDBuilderHome
    #=================================================
    if (! (Test-Path HKCU:\Software\OSDeploy)) {
        Try {New-Item HKCU:\Software -Name OSDeploy -Force | Out-Null}
        Catch {Write-Warning 'Unable to New-Item HKCU:\Software\OSDeploy'; Break}
    }

    if (Get-ItemProperty -Path 'HKCU:\Software\OSDeploy' -Name OSBuilderPath -ErrorAction SilentlyContinue) {
        Try {Rename-ItemProperty -Path 'HKCU:\Software\OSDeploy' -Name OSBuilderPath -NewName GetOSDBuilderHome -Force | Out-Null}
        Catch {Write-Warning 'Unable to Rename-ItemProperty HKCU:\Software\OSDeploy OSBuilderPath to GetOSDBuilderHome'; Break}
    }

    if (! (Get-ItemProperty -Path HKCU:\Software\OSDeploy -Name GetOSDBuilderHome -ErrorAction SilentlyContinue)) {
        Try {New-ItemProperty -Path HKCU:\Software\OSDeploy -Name GetOSDBuilderHome -Force | Out-Null}
        Catch {Write-Warning 'Unable to New-ItemProperty HKCU:\Software\OSDeploy GetOSDBuilderHome'; Break}
    }

    if ($SetHome) {
        Try {Set-ItemProperty -Path HKCU:\Software\OSDeploy -Name GetOSDBuilderHome -Value $SetHome -Force}
        Catch {Write-Warning "Unable to Set-ItemProperty HKCU:\Software\OSDeploy GetOSDBuilderHome to $SetHome"; Break}
    }

    $global:GetOSDBuilderHome = $(Get-ItemProperty "HKCU:\Software\OSDeploy").GetOSDBuilderHome

    if (! $global:GetOSDBuilderHome) {
        Set-ItemProperty -Path HKCU:\Software\OSDeploy -Name GetOSDBuilderHome -Value "$env:SystemDrive\OSDBuilder" -Force
        $global:GetOSDBuilderHome = "$env:SystemDrive\OSDBuilder"
    }
    #=================================================
    #   Initialize OSDBuilder Variables
    #=================================================
    Write-Verbose "Initializing OSDBuilder ..." -Verbose

    
    $global:GetOSDBuilder = [ordered]@{
        Home                    = $global:GetOSDBuilderHome
        Initialize              = $true
        JsonLocal               = Join-Path $global:GetOSDBuilderHome 'OSDBuilder.json'
        JsonGlobal              = Join-Path $env:ProgramData 'OSDeploy\OSDBuilder.json'
<#         PathContentADK          = Join-Path $global:GetOSDBuilderHome 'Content\ADK'
        PathContentDaRT         = Join-Path $global:GetOSDBuilderHome 'Content\DaRT'
        PathContentDrivers      = Join-Path $global:GetOSDBuilderHome 'Content\Drivers'
        PathContentExtraFiles   = Join-Path $global:GetOSDBuilderHome 'Content\ExtraFiles'
        PathContentIsoExtract   = Join-Path $global:GetOSDBuilderHome 'Content\IsoExtract'
        PathContentOneDrive     = Join-Path $global:GetOSDBuilderHome 'Content\OneDrive'
        PathContentPackages     = Join-Path $global:GetOSDBuilderHome 'Content\Packages'
        PathContentScripts      = Join-Path $global:GetOSDBuilderHome 'Content\Scripts'
        PathContentStartLayout  = Join-Path $global:GetOSDBuilderHome 'Content\StartLayout'
        PathContentUnattend     = Join-Path $global:GetOSDBuilderHome 'Content\Unattend' #>
    }

    $global:SetOSDBuilder = [ordered]@{
        AllowContentPacks       = $true
        AllowGlobalOptions      = $true
        #AllowLocalPriority      = $false
        PathContent             = Join-Path $global:GetOSDBuilderHome 'Content'
        PathContentPacks        = Join-Path $global:GetOSDBuilderHome 'ContentPacks'
        PathFeatureUpdates		= Join-Path $global:GetOSDBuilderHome 'FeatureUpdates'
        PathMount               = Join-Path $global:GetOSDBuilderHome 'Mount'
        PathOSBuilds            = Join-Path $global:GetOSDBuilderHome 'OSBuilds'
        PathOSImport            = Join-Path $global:GetOSDBuilderHome 'OSImport'
        PathOSMedia             = Join-Path $global:GetOSDBuilderHome 'OSMedia'
        PathPEBuilds            = Join-Path $global:GetOSDBuilderHome 'PEBuilds'
        PathTasks               = Join-Path $global:GetOSDBuilderHome 'Tasks'
        PathTemplates           = Join-Path $global:GetOSDBuilderHome 'Templates'
        PathUpdates             = Join-Path $global:GetOSDBuilderHome 'Updates'

        #Save-OSDBuilderDownload
        #Get-OSBuilds
        #Get-OSDBuilder
        #Get-OSMedia
        #Get-PEBuilds
        #Import-OSMedia
        ImportOSMediaAllowUnsupporteOS = $false
        ImportOSMediaBuildNetFX = $false
        ImportOSMediaEditionId = $null
        ImportOSMediaImageIndex = $null
        ImportOSMediaImageName = $null
        ImportOSMediaShowInfo = $false
        ImportOSMediaSkipGrid = $false
        ImportOSMediaSkipFeatureUpdates = $false
        ImportOSMediaUpdate = $false
        #Initialize-OSDBuilder
        #New-OSBuild
        NewOSBuildByTaskName = $null
        NewOSBuildCreateISO = $false
        NewOSBuildDontUseNewestMedia = $false
        NewOSBuildDownload = $false
        NewOSBuildExclude = $null
        NewOSBuildExecute = $false
        NewOSBuildEnableNetFX = $false
        NewOSBuildInclude = $null
        NewOSBuildHideCleanupProgress = $false
        NewOSBuildPauseDismountOS = $false
        NewOSBuildPauseDismountPE = $false
        NewOSBuildSelectContentPacks = $false
        NewOSBuildSelectUpdates = $false
        NewOSBuildShowHiddenOSMedia = $false
        NewOSBuildSkipComponentCleanup = $false
        NewOSBuildSkipContentPacks = $false
        NewOSBuildSkipTask = $false
        NewOSBuildSkipTemplates = $false
        NewOSBuildSkipUpdates = $false
        #New-OSBuildMultiLang
        #New-OSBuildTask
        NewOSBuildTaskAddContentPacks = $false
        NewOSBuildTaskContentDrivers = $false
        NewOSBuildTaskContentExtraFiles = $false
        NewOSBuildTaskContentFeaturesOnDemand = $false
        NewOSBuildTaskContentLanguagePackages = $false
        NewOSBuildTaskContentPackages = $false
        NewOSBuildTaskContentScripts = $false
        NewOSBuildTaskContentStartLayout = $false
        NewOSBuildTaskContentUnattend = $false
        NewOSBuildTaskContentWinPEADK = $false
        NewOSBuildTaskContentWinPEDart = $false
        NewOSBuildTaskContentWinPEDrivers = $false
        NewOSBuildTaskContentWinPEExtraFiles = $false
        NewOSBuildTaskContentWinPEScripts = $false
        NewOSBuildTaskCustomName = $null
        NewOSBuildTaskDisableFeature = $false
        NewOSBuildTaskEnableFeature = $false
        NewOSBuildTaskEnableNetFX3 = $false
        NewOSBuildTaskRemoveAppx = $false
        NewOSBuildTaskRemoveCapability = $false
        NewOSBuildTaskRemovePackage = $false
        NewOSBuildTaskTaskName = $null
        NewOSBuildTaskWinPEAutoExtraFiles = $false
        #New-OSDBuilderContentPack
        #New-OSDBuilderISO
        #New-OSDBuilderUSB
        #New-OSDBuilderVHD
        #New-PEBuild
        NewPEBuildCreateISO = $false
        NewPEBuildExecute = $false
        NewPEBuildPauseDismount = $false
        NewPEBuildPauseMount = $false
        #New-PEBuildTask
        #Show-OSDBuilderInfo
        #Update-OSMedia
        UpdateOSMediaCreateISO = $false
        UpdateOSMediaDownload = $false
        UpdateOSMediaExclude = $null
        UpdateOSMediaExecute = $false
        UpdateOSMediaHideCleanupProgress = $false
        UpdateOSMediaInclude = $null
        UpdateOSMediaName = $null
        UpdateOSMediaPauseDismountOS = $false
        UpdateOSMediaPauseDismountPE = $false
        UpdateOSMediaSelectUpdates = $false
        UpdateOSMediaShowHiddenOSMedia = $false
        UpdateOSMediaSkipComponentCleanup = $false
        UpdateOSMediaSkipUpdates = $false
        UpdateOSMediaSkipUpdatesPE = $false
    }
    #=================================================
    #   Import Local JSON
    #=================================================
    if (Test-Path $global:GetOSDBuilder.JsonLocal) {
        Write-Verbose "Importing OSDBuilder Local Settings $($global:GetOSDBuilder.JsonLocal)"
        Try {
            $global:GetOSDBuilder.LocalSettings = (Get-Content $global:GetOSDBuilder.JsonLocal -RAW | ConvertFrom-Json).PSObject.Properties | foreach {[ordered]@{Name = $_.Name; Value = $_.Value}} | ConvertTo-Json | ConvertFrom-Json
            $global:GetOSDBuilder.LocalSettings | foreach {
                Write-Verbose "$($_.Name) = $($_.Value)"
                $global:SetOSDBuilder.$($_.Name) = $($_.Value)
            }
        }
        Catch {Write-Warning "Unable to import $($global:GetOSDBuilder.JsonLocal)"}
    }

    if ($global:SetOSDBuilder.AllowGlobalOptions -eq $true) {
        if (Test-Path $global:GetOSDBuilder.JsonGlobal) {
            Write-Verbose "Importing OSDBuilder Global Settings $($global:GetOSDBuilder.JsonGlobal)"
            Try {
                $global:GetOSDBuilder.GlobalSettings = (Get-Content $global:GetOSDBuilder.JsonGlobal -RAW | ConvertFrom-Json).PSObject.Properties | foreach {[ordered]@{Name = $_.Name; Value = $_.Value}} | ConvertTo-Json | ConvertFrom-Json
                $global:GetOSDBuilder.GlobalSettings | foreach {
                    Write-Verbose "$($_.Name) = $($_.Value)"
                    $global:SetOSDBuilder.$($_.Name) = $($_.Value)
                }
            }
            Catch {Write-Warning "Unable to import $($global:GetOSDBuilder.JsonGlobal)"}
        }
    }

<#     if ($global:SetOSDBuilder.AllowLocalPriority -eq $true) {
        if (Test-Path $global:GetOSDBuilder.JsonLocal) {
            Write-Verbose "Importing OSDBuilder Local Priority $($global:GetOSDBuilder.JsonLocal) as Priority"
            Try {
                $global:GetOSDBuilder.LocalSettings = (Get-Content $global:GetOSDBuilder.JsonLocal -RAW | ConvertFrom-Json).PSObject.Properties | foreach {[ordered]@{Name = $_.Name; Value = $_.Value}} | ConvertTo-Json | ConvertFrom-Json
                $global:GetOSDBuilder.LocalSettings | foreach {
                    Write-Verbose "$($_.Name) = $($_.Value)"
                    $global:SetOSDBuilder.$($_.Name) = $($_.Value)
                }
            }
            Catch {Write-Warning "Unable to import $($global:GetOSDBuilder.JsonLocal)"}
        }
    } #>

    #=================================================
    #   Set Content Paths
    #=================================================
    $global:GetOSDBuilder.PathContentADK            = Join-Path $global:SetOSDBuilder.PathContent 'ADK'
    $global:GetOSDBuilder.PathContentDaRT           = Join-Path $global:SetOSDBuilder.PathContent 'DaRT'
    $global:GetOSDBuilder.PathContentDrivers        = Join-Path $global:SetOSDBuilder.PathContent 'Drivers'
    $global:GetOSDBuilder.PathContentExtraFiles     = Join-Path $global:SetOSDBuilder.PathContent 'ExtraFiles'
    $global:GetOSDBuilder.PathContentIsoExtract     = Join-Path $global:SetOSDBuilder.PathContent 'IsoExtract'
    $global:GetOSDBuilder.PathContentOneDrive       = Join-Path $global:SetOSDBuilder.PathContent 'OneDrive'
    $global:GetOSDBuilder.PathContentPackages       = Join-Path $global:SetOSDBuilder.PathContent 'Packages'
    $global:GetOSDBuilder.PathContentScripts        = Join-Path $global:SetOSDBuilder.PathContent 'Scripts'
    $global:GetOSDBuilder.PathContentStartLayout    = Join-Path $global:SetOSDBuilder.PathContent 'StartLayout'
    $global:GetOSDBuilder.PathContentUnattend       = Join-Path $global:SetOSDBuilder.PathContent 'Unattend'
    #=================================================
    #   Get Variables
    #=================================================
    $global:GetOSDBuilderHome                   = $global:GetOSDBuilder.Home
    $global:GetOSDBuilderPathContentADK         = $global:GetOSDBuilder.PathContentADK
    $global:GetOSDBuilderPathContentDaRT        = $global:GetOSDBuilder.PathContentDaRT
    $global:GetOSDBuilderPathContentDrivers     = $global:GetOSDBuilder.PathContentDrivers
    $global:GetOSDBuilderPathContentExtraFiles  = $global:GetOSDBuilder.PathContentExtraFiles
    $global:GetOSDBuilderPathContentIsoExtract  = $global:GetOSDBuilder.PathContentIsoExtract
    $global:GetOSDBuilderPathContentOneDrive    = $global:GetOSDBuilder.PathContentOneDrive
    $global:GetOSDBuilderPathContentPackages    = $global:GetOSDBuilder.PathContentPackages
    $global:GetOSDBuilderPathContentScripts     = $global:GetOSDBuilder.PathContentScripts
    $global:GetOSDBuilderPathContentStartLayout = $global:GetOSDBuilder.PathContentStartLayout
    $global:GetOSDBuilderPathContentUnattend    = $global:GetOSDBuilder.PathContentUnattend
    #=================================================
    #   Set Variables
    #=================================================
    $global:SetOSDBuilderPathContent            = $global:SetOSDBuilder.PathContent
    $global:SetOSDBuilderPathContentPacks       = $global:SetOSDBuilder.PathContentPacks
    $global:SetOSDBuilderPathMount              = $global:SetOSDBuilder.PathMount
    $global:SetOSDBuilderPathOSBuilds           = $global:SetOSDBuilder.PathOSBuilds
    $global:SetOSDBuilderPathFeatureUpdates		= $global:SetOSDBuilder.PathFeatureUpdates
    $global:SetOSDBuilderPathOSImport           = $global:SetOSDBuilder.PathOSImport
    $global:SetOSDBuilderPathOSMedia            = $global:SetOSDBuilder.PathOSMedia
    $global:SetOSDBuilderPathPEBuilds           = $global:SetOSDBuilder.PathPEBuilds
    $global:SetOSDBuilderPathTasks              = $global:SetOSDBuilder.PathTasks
    $global:SetOSDBuilderPathTemplates          = $global:SetOSDBuilder.PathTemplates
    $global:SetOSDBuilderPathUpdates            = $global:SetOSDBuilder.PathUpdates
    #=================================================
    #   Corrections
    #=================================================
    if (Test-Path "$GetOSDBuilderHome\Media") {
        Write-Warning "Renaming $GetOSDBuilderHome\Media to $SetOSDBuilderPathFeatureUpdates"
        Rename-Item "$GetOSDBuilderHome\Media" "$SetOSDBuilderPathFeatureUpdates" -Force | Out-Null
    }
    if (Test-Path "$GetOSDBuilderHome\OSDownload") {
        Write-Warning "Renaming $GetOSDBuilderHome\OSDownload to $SetOSDBuilderPathFeatureUpdates"
        Rename-Item "$GetOSDBuilderHome\OSDownload" "$SetOSDBuilderPathFeatureUpdates" -Force | Out-Null
    }
    if (Test-Path "$SetOSDBuilderPathContent\OSDUpdate") {
        Write-Warning "Moving $SetOSDBuilderPathContent\OSDUpdate to $SetOSDBuilderPathUpdates"
        if (! (Test-Path $SetOSDBuilderPathUpdates)) {New-Item $SetOSDBuilderPathUpdates -ItemType Directory -Force | Out-Null}
        Move-Item -Path "$SetOSDBuilderPathContent\OSDUpdate\*" -Destination $SetOSDBuilderPathUpdates -Force -ErrorAction SilentlyContinue | Out-Null
        Remove-Item "$SetOSDBuilderPathContent\OSDUpdate" -Recurse -Force -ErrorAction SilentlyContinue | Out-Null
    }
    if (Test-Path "$SetOSDBuilderPathContent\Mount") {
        Write-Warning "$SetOSDBuilderPathContent\Mount has been moved to $SetOSDBuilderPathMount"
        Write-Warning "Verify that you don't have any active mounted images and remove this directory"
    }
}