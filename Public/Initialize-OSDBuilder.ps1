function Initialize-OSDBuilder {
    [CmdletBinding()]
    Param (
        #Initializes OSDBuilder variables
        #This action will occur automatically if OSDBuilder variables are not set
        [switch]$Default,

        #Sets the OSDBuilder Path in the Registry
        [string]$OSDBuilderHome
    )
    #===================================================================================================
    #   GetOSDBuilderHome
    #===================================================================================================
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

    if ($OSDBuilderHome) {
        Try {Set-ItemProperty -Path HKCU:\Software\OSDeploy -Name GetOSDBuilderHome -Value $OSDBuilderHome -Force}
        Catch {Write-Warning "Unable to Set-ItemProperty HKCU:\Software\OSDeploy GetOSDBuilderHome to $OSDBuilderHome"; Break}
    }

    $global:GetOSDBuilderHome = $(Get-ItemProperty "HKCU:\Software\OSDeploy").GetOSDBuilderHome
    if ($null -eq $global:GetOSDBuilderHome) {$global:GetOSDBuilderHome = "$env:SystemDrive\OSDBuilder"}
    #===================================================================================================
    #   Initialize OSDBuilder Variables
    #===================================================================================================
    Write-Verbose "Initializing OSDBuilder Defaults" -Verbose

    $global:GetOSDBuilder = [ordered]@{
        Home                    = $global:GetOSDBuilderHome
        Initialize              = $true
        JsonLocal               = Join-Path $global:GetOSDBuilderHome 'OSDBuilder.json'
        JsonGlobal              = Join-Path $env:ProgramData 'OSDeploy\OSDBuilder.json'
        PathContent             = Join-Path $global:GetOSDBuilderHome 'Content'
    }
    $global:SetOSDBuilder = [ordered]@{
        AllowContentPacks       = $false
        AllowGlobalOptions      = $true
        AllowLocalOptions       = $true
        PathContentPacks        = Join-Path $global:GetOSDBuilderHome 'ContentPacks'
        PathFeatureUpdates      = Join-Path $global:GetOSDBuilderHome 'FeatureUpdates'
        PathOSBuilds            = Join-Path $global:GetOSDBuilderHome 'OSBuilds'
        PathOSImport            = Join-Path $global:GetOSDBuilderHome 'OSImport'
        PathOSMedia             = Join-Path $global:GetOSDBuilderHome 'OSMedia'
        PathPEBuilds            = Join-Path $global:GetOSDBuilderHome 'PEBuilds'
        PathTasks               = Join-Path $global:GetOSDBuilderHome 'Tasks'
        PathTemplates           = Join-Path $global:GetOSDBuilderHome 'Templates'

        PathContentADK          = Join-Path $global:GetOSDBuilder.PathContent 'ADK'
        PathContentDaRT         = Join-Path $global:GetOSDBuilder.PathContent 'DaRT'
        PathContentDrivers      = Join-Path $global:GetOSDBuilder.PathContent 'Drivers'
        PathContentExtraFiles   = Join-Path $global:GetOSDBuilder.PathContent 'ExtraFiles'
        PathContentIsoExtract   = Join-Path $global:GetOSDBuilder.PathContent 'IsoExtract'
        PathContentMount        = Join-Path $global:GetOSDBuilder.PathContent 'Mount'
        PathContentOneDrive     = Join-Path $global:GetOSDBuilder.PathContent 'OneDrive'
        PathContentOSDUpdate    = Join-Path $global:GetOSDBuilder.PathContent 'OSDUpdate'
        PathContentPackages     = Join-Path $global:GetOSDBuilder.PathContent 'Packages'
        PathContentScripts      = Join-Path $global:GetOSDBuilder.PathContent 'Scripts'
        PathContentStartLayout  = Join-Path $global:GetOSDBuilder.PathContent 'StartLayout'
        PathContentUnattend     = Join-Path $global:GetOSDBuilder.PathContent 'Unattend'

        ImportOSMediaBuildNetFX = $false
        ImportOSMediaEditionId  = $null
        ImportOSMediaImageIndex = $null
        ImportOSMediaImageName  = $null
        ImportOSMediaShowInfo   = $false
        ImportOSMediaSkipGrid   = $false
        ImportOSMediaUpdate     = $false

        NewOSBuildCreateISO = $false
        NewOSBuildDownload = $false
        NewOSBuildEnableNetFX = $false
        NewOSBuildHideCleanupProgress = $false
        NewOSBuildSelectContentPacks = $false
        NewOSBuildSkipTemplates = $false
        NewOSBuildSkipUpdates = $false

        UpdateOSMediaCreateISO = $false
        UpdateOSMediaDownload = $false
        UpdateOSMediaExecute = $false
        UpdateOSMediaHideCleanupProgress = $false
        UpdateOSMediaName = $null
        UpdateOSMediaPauseDismountOS = $false
        UpdateOSMediaPauseDismountPE = $false
        UpdateOSMediaSelectUpdates = $false
        UpdateOSMediaShowHiddenOSMedia = $false
        UpdateOSMediaSkipComponentCleanup = $false
        UpdateOSMediaSkipUpdates = $false
    }

<#     $global:GetOSDBuilder.PathContent       = Join-Path $global:GetOSDBuilder.Home 'Content'
    $global:GetOSDBuilder.PathTasks         = Join-Path $global:GetOSDBuilder.Home 'Tasks'
    $global:GetOSDBuilder.PathTemplates     = Join-Path $global:GetOSDBuilder.Home 'Templates' #>
    #===================================================================================================
    #   Import Local JSON
    #===================================================================================================
    if (Test-Path $global:GetOSDBuilder.JsonLocal) {
        Write-Verbose "Importing $($global:GetOSDBuilder.JsonLocal)" -Verbose
        Try {
            $global:GetOSDBuilder.LocalSettings = (Get-Content $global:GetOSDBuilder.JsonLocal -RAW | ConvertFrom-Json).PSObject.Properties | foreach {[ordered]@{Name = $_.Name; Value = $_.Value}} | ConvertTo-Json | ConvertFrom-Json
            $global:GetOSDBuilder.LocalSettings | foreach {
                Write-Verbose "$($_.Name) = $($_.Value)" -Verbose
                $global:SetOSDBuilder.$($_.Name) = $($_.Value)
            }
        }
        Catch {Write-Warning "Unable to import $($global:GetOSDBuilder.JsonLocal)"}
    }

    if ($global:SetOSDBuilder.AllowGlobalOptions -eq $true) {
        if (Test-Path $global:GetOSDBuilder.JsonGlobal) {
            Write-Verbose "Importing $($global:GetOSDBuilder.JsonGlobal)" -Verbose
            Try {
                $global:GetOSDBuilder.LocalSettings = (Get-Content $global:GetOSDBuilder.JsonGlobal -RAW | ConvertFrom-Json).PSObject.Properties | foreach {[ordered]@{Name = $_.Name; Value = $_.Value}} | ConvertTo-Json | ConvertFrom-Json
                $global:GetOSDBuilder.LocalSettings | foreach {
                    Write-Verbose "$($_.Name) = $($_.Value)" -Verbose
                    $global:SetOSDBuilder.$($_.Name) = $($_.Value)
                }
            }
            Catch {Write-Warning "Unable to import $($global:GetOSDBuilder.JsonGlobal)"}
        }
    }


<#     #if ($null -eq $global:SetOSDBuilder.PathContent) {}

    #$global:SetOSDBuilder.PathContent               = Join-Path $global:GetOSDBuilder.Home 'Content'
    $global:SetOSDBuilder.PathContentPacks          = Join-Path $global:GetOSDBuilder.Home 'ContentPacks'
    $global:SetOSDBuilder.PathFeatureUpdates        = Join-Path $global:GetOSDBuilder.Home 'FeatureUpdates'
    $global:SetOSDBuilder.PathOSBuilds              = Join-Path $global:GetOSDBuilder.Home 'OSBuilds'
    $global:SetOSDBuilder.PathOSImport              = Join-Path $global:GetOSDBuilder.Home 'OSImport'
    $global:SetOSDBuilder.PathOSMedia               = Join-Path $global:GetOSDBuilder.Home 'OSMedia'
    $global:SetOSDBuilder.PathPEBuilds              = Join-Path $global:GetOSDBuilder.Home 'PEBuilds'
    #$global:SetOSDBuilder.PathTasks                 = Join-Path $global:GetOSDBuilder.Home 'Tasks'
    #$global:SetOSDBuilder.PathTemplates             = Join-Path $global:GetOSDBuilder.Home 'Templates'

    $global:SetOSDBuilder.PathContentADK            = Join-Path $global:SetOSDBuilder.PathContent 'ADK'
    $global:SetOSDBuilder.PathContentDaRT           = Join-Path $global:SetOSDBuilder.PathContent 'DaRT'
    $global:SetOSDBuilder.PathContentDrivers        = Join-Path $global:SetOSDBuilder.PathContent 'Drivers'
    $global:SetOSDBuilder.PathContentExtraFiles     = Join-Path $global:SetOSDBuilder.PathContent 'ExtraFiles'
    $global:SetOSDBuilder.PathContentIsoExtract     = Join-Path $global:SetOSDBuilder.PathContent 'IsoExtract'
    $global:SetOSDBuilder.PathContentMount          = Join-Path $global:SetOSDBuilder.PathContent 'Mount'
    $global:SetOSDBuilder.PathContentOneDrive       = Join-Path $global:SetOSDBuilder.PathContent 'OneDrive'
    $global:SetOSDBuilder.PathContentOSDUpdate      = Join-Path $global:SetOSDBuilder.PathContent 'OSDUpdate'
    $global:SetOSDBuilder.PathContentPackages       = Join-Path $global:SetOSDBuilder.PathContent 'Packages'
    $global:SetOSDBuilder.PathContentScripts        = Join-Path $global:SetOSDBuilder.PathContent 'Scripts'
    $global:SetOSDBuilder.PathContentStartLayout    = Join-Path $global:SetOSDBuilder.PathContent 'StartLayout'
    $global:SetOSDBuilder.PathContentUnattend       = Join-Path $global:SetOSDBuilder.PathContent 'Unattend' #>

<#     $global:GetOSDBuilder.PathContent               = Join-Path $global:GetOSDBuilder.Home 'Content'
    $global:SetOSDBuilder.PathContentADK            = Join-Path $global:GetOSDBuilder.PathContent 'ADK'
    $global:SetOSDBuilder.PathContentDaRT           = Join-Path $global:GetOSDBuilder.PathContent 'DaRT'
    $global:SetOSDBuilder.PathContentDrivers        = Join-Path $global:GetOSDBuilder.PathContent 'Drivers'
    $global:SetOSDBuilder.PathContentExtraFiles     = Join-Path $global:GetOSDBuilder.PathContent 'ExtraFiles'
    $global:SetOSDBuilder.PathContentIsoExtract     = Join-Path $global:GetOSDBuilder.PathContent 'IsoExtract'
    $global:SetOSDBuilder.PathContentMount          = Join-Path $global:GetOSDBuilder.PathContent 'Mount'
    $global:SetOSDBuilder.PathContentOneDrive       = Join-Path $global:GetOSDBuilder.PathContent 'OneDrive'
    $global:SetOSDBuilder.PathContentOSDUpdate      = Join-Path $global:GetOSDBuilder.PathContent 'OSDUpdate'
    $global:SetOSDBuilder.PathContentPackages       = Join-Path $global:GetOSDBuilder.PathContent 'Packages'
    $global:SetOSDBuilder.PathContentScripts        = Join-Path $global:GetOSDBuilder.PathContent 'Scripts'
    $global:SetOSDBuilder.PathContentStartLayout    = Join-Path $global:GetOSDBuilder.PathContent 'StartLayout'
    $global:SetOSDBuilder.PathContentUnattend       = Join-Path $global:GetOSDBuilder.PathContent 'Unattend'
    $global:SetOSDBuilder.PathContentPacks          = Join-Path $global:GetOSDBuilder.Home 'ContentPacks'
    $global:SetOSDBuilder.PathFeatureUpdates        = Join-Path $global:GetOSDBuilder.Home 'FeatureUpdates'
    $global:SetOSDBuilder.PathOSBuilds              = Join-Path $global:GetOSDBuilder.Home 'OSBuilds'
    $global:SetOSDBuilder.PathOSImport              = Join-Path $global:GetOSDBuilder.Home 'OSImport'
    $global:SetOSDBuilder.PathOSMedia               = Join-Path $global:GetOSDBuilder.Home 'OSMedia'
    $global:SetOSDBuilder.PathPEBuilds              = Join-Path $global:GetOSDBuilder.Home 'PEBuilds'
    $global:GetOSDBuilder.PathTasks                 = Join-Path $global:GetOSDBuilder.Home 'Tasks'
    $global:GetOSDBuilder.PathTemplates             = Join-Path $global:GetOSDBuilder.Home 'Templates' #>


<#     $global:GetOSDBuilder = [ordered]@{
        Home                = $global:GetOSDBuilderHome
        Initialize          = $true
    }
    $global:SetOSDBuilder = [ordered]@{
        AllowContentPacks   = $false
        AllowGlobalOptions  = $true
        AllowLocalOptions   = $true
    }
    $global:SetOSDBuilder.Paths = [ordered]@{}
    $global:SetOSDBuilder.GetDownOSDBuilder = [ordered]@{}
    $global:SetOSDBuilder.GetOSBuilds = [ordered]@{}
    $global:SetOSDBuilder.GetOSDBuilder = [ordered]@{}
    $global:SetOSDBuilder.GetOSMedia = [ordered]@{}
    $global:SetOSDBuilder.GetPEBuilds = [ordered]@{}
    $global:SetOSDBuilder.ImportOSMedia = [ordered]@{
        BuildNetFX = $false
        EditionId = $null
        ImageIndex = $null
        ImageName = $null
        ShowInfo = $false
        SkipGrid = $false
        Update = $false
    }
    $global:SetOSDBuilder.NewOSBuild = [ordered]@{
        CreateISO = $false
        Download = $false
        EnableNetFX = $false
        HideCleanupProgress = $false
        SelectContentPacks = $false
        SkipTemplates = $false
        SkipUpdates = $false
    }
    $global:SetOSDBuilder.NewOSBuildMultiLang = [ordered]@{}
    $global:SetOSDBuilder.NewOSBuildTask = [ordered]@{}
    $global:SetOSDBuilder.NewOSDBuilderContentPack = [ordered]@{}
    $global:SetOSDBuilder.NewOSDBuilderISO = [ordered]@{}
    $global:SetOSDBuilder.NewOSDBuilderUSB = [ordered]@{}
    $global:SetOSDBuilder.NewOSDBuilderVHD = [ordered]@{}
    $global:SetOSDBuilder.NewPEBuild = [ordered]@{}
    $global:SetOSDBuilder.NewPEBuildTask = [ordered]@{}
    $global:SetOSDBuilder.ShowOSDBuilderInfo = [ordered]@{}
    $global:SetOSDBuilder.UpdateOSMedia = [ordered]@{
        CreateISO = $false
        Download = $false
        Execute = $false
        HideCleanupProgress = $false
        Name = $null
        PauseDismountOS = $false
        PauseDismountPE = $false
        SelectUpdates = $false
        ShowHiddenOSMedia = $false
        SkipComponentCleanup = $false
        SkipUpdates = $false
    }

    $global:SetOSDBuilder | ConvertTo-Json | Set-Content 'C:\OSDBuilder\Defaults.json' #>

}