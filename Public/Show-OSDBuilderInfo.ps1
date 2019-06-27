<#
.SYNOPSIS
Shows Operating System information of any OSDBuilder Media

.DESCRIPTION
Shows Operating System information of any OSDBuilder Media (OSMedia, OSBuilds, PEBuilds)

.LINK
http://osdbuilder.com/functions/show-osdbuilderinfo

.PARAMETER FullName
Full Path of the OSDBuilder Media
#>
function Show-OSDBuilderInfo {
    [CmdletBinding()]
    PARAM (
        [Parameter(ValueFromPipelineByPropertyName)]
        [string[]]$FullName
    )

    BEGIN {
        #Write-Host '========================================================================================' -ForegroundColor DarkGray
        #Write-Host -ForegroundColor Green "$($MyInvocation.MyCommand.Name) BEGIN"
        #===================================================================================================
        #   Initialize OSDBuilder
        Get-OSDBuilder -CreatePaths -HideDetails
        #===================================================================================================
        #   Gather All OS Media
        $AllMyOSMedia = @()
        $AllMyOSBuilds = @()
        $AllMyPEBuilds = @()
        $AllMyOSDBMedia = @()


        $AllMyOSMedia = Get-OSMedia
        $AllMyOSBuilds = Get-OSBuilds
        $AllMyPEBuilds = Get-PEBuilds
        $AllMyOSDBMedia = [array]$AllMyOSMedia + [array]$AllMyOSBuilds + [array]$AllMyPEBuilds
        #===================================================================================================
    }

    PROCESS {
        #Write-Host '========================================================================================' -ForegroundColor DarkGray
        #Write-Host -ForegroundColor Green "$($MyInvocation.MyCommand.Name) PROCESS"

        #===================================================================================================
        Write-Verbose '19.1.1 Select Source OSMedia'
        #===================================================================================================
        $SelectedOSMedia = @()

        if ($FullName) {
            foreach ($Item in $FullName) {
                Write-Verbose "Checking $Item"
                $SelectedOSMedia += $AllMyOSDBMedia | Where-Object {$_.FullName -eq $Item}
            }
        } else {
            $SelectedOSMedia = $AllMyOSDBMedia | Out-GridView -Title "OSDBuilder: Select one or more Media and press OK (Cancel to Exit)" -PassThru
        }

        #===================================================================================================
        Write-Verbose '19.1.1 Process OSMedia'
        #===================================================================================================
        foreach ($Media in $SelectedOSMedia) {
            Write-Host '========================================================================================' -ForegroundColor DarkGray
            Write-Host "Show-OSDBuilderInfo -FullName '$($Media.FullName)'" -ForegroundColor Green
            if (!(Test-Path $(Join-Path $Media.FullName (Join-Path "info" (Join-Path "xml" "Get-WindowsImage.xml"))))) {
                Write-Host '========================================================================================' -ForegroundColor DarkGray
                Write-Warning "Could not find an OSDBuilder Operating System at $Media.FullName"
            } else {
                if (!($($Media.FullName) -like "*PEBuilds*")) {
                    Write-Host '========================================================================================' -ForegroundColor DarkGray
                    Write-Host "Enabled Appx Provisioned Packages" -ForegroundColor Green
                    $GetAppxProvisionedPackageXml = Join-Path $($Media.FullName) (Join-Path "info" (Join-Path "xml" "Get-AppxProvisionedPackage.xml"))
                    if ($Media.Name -like "*server*") {Write-Warning "Appx Provisioned Packages are not present in Windows Server"}
                    if (Test-Path $GetAppxProvisionedPackageXml) {
                        $GetAppxProvisionedPackage = Import-CliXml $GetAppxProvisionedPackageXml
                        foreach ($Item in $GetAppxProvisionedPackage) {Write-Host "$($Item.DisplayName)"}
                    }
                }

                Write-Host '========================================================================================' -ForegroundColor DarkGray
                Write-Host "Windows Packages" -ForegroundColor Green
                $GetWindowsPackageXml = Join-Path $($Media.FullName) (Join-Path "info" (Join-Path "xml" "Get-WindowsPackage.xml"))
                if (Test-Path $GetWindowsPackageXml) {
                    $GetWindowsPackage = Import-CliXml $GetWindowsPackageXml
                    $GetWindowsPackage = $GetWindowsPackage | Where-Object {$_.PackageName -notlike "*Package_for*"}
                    $GetWindowsPackage = $GetWindowsPackage | Where-Object {$_.PackageName -notlike "*LanguageFeatures*"}
                    foreach ($Item in $GetWindowsPackage) {Write-Host "$($Item.PackageName)"}
                }

                if (!($($Media.FullName) -like "*PEBuilds*")) {
                    Write-Host '========================================================================================' -ForegroundColor DarkGray
                    Write-Host "Windows Packages (Language)" -ForegroundColor Green
                    $GetWindowsPackageXml = Join-Path $($Media.FullName) (Join-Path "info" (Join-Path "xml" "Get-WindowsPackage.xml"))
                    if (Test-Path $GetWindowsPackageXml) {
                        $GetWindowsPackage = Import-CliXml $GetWindowsPackageXml
                        $GetWindowsPackage = $GetWindowsPackage | Where-Object {$_.PackageName -like "*LanguageFeatures*"}
                        foreach ($Item in $GetWindowsPackage) {Write-Host "$($Item.PackageName)"}
                    }

                    Write-Host '========================================================================================' -ForegroundColor DarkGray
                    Write-Host "Windows Capabilities" -ForegroundColor Green
                    $GetWindowsCapabilityXml = Join-Path $($Media.FullName) (Join-Path "info" (Join-Path "xml" "Get-WindowsCapability.xml"))
                    if (Test-Path $GetWindowsCapabilityXml) {
                        $GetWindowsCapability = Import-CliXml $GetWindowsCapabilityXml
                        $GetWindowsCapability = $GetWindowsCapability | Where-Object {$_.Name -notlike "Language*"}
                        foreach ($Item in $GetWindowsCapability) {Write-Host "$($Item.Name)"}
                    }

                    Write-Host '========================================================================================' -ForegroundColor DarkGray
                    Write-Host "Windows Capabilities (Language)" -ForegroundColor Green
                    $GetWindowsCapabilityXml = Join-Path $($Media.FullName) (Join-Path "info" (Join-Path "xml" "Get-WindowsCapability.xml"))
                    if (Test-Path $GetWindowsCapabilityXml) {
                        $GetWindowsCapability = Import-CliXml $GetWindowsCapabilityXml
                        $GetWindowsCapability = $GetWindowsCapability | Where-Object {$_.Name -like "Language*"}
                        foreach ($Item in $GetWindowsCapability) {Write-Host "$($Item.Name)"}
                    }

                    Write-Host '========================================================================================' -ForegroundColor DarkGray
                    Write-Host "Windows Optional Features (Enabled)" -ForegroundColor Green
                    $WindowsOptionalFeatureXml = Join-Path $($Media.FullName) (Join-Path "info" (Join-Path "xml" "Get-WindowsOptionalFeature.xml"))
                    if (Test-Path $WindowsOptionalFeatureXml) {
                        $WindowsOptionalFeature = Import-CliXml $WindowsOptionalFeatureXml
                        $WindowsOptionalFeature = $WindowsOptionalFeature | Where-Object {$_.State -eq 2}
                        foreach ($Item in $WindowsOptionalFeature) {Write-Host "$($Item.FeatureName)"}
                    }

                    Write-Host '========================================================================================' -ForegroundColor DarkGray
                    Write-Host "Windows Optional Features (Enable Pending)" -ForegroundColor Green
                    $WindowsOptionalFeatureXml = Join-Path $($Media.FullName) (Join-Path "info" (Join-Path "xml" "Get-WindowsOptionalFeature.xml"))
                    if (Test-Path $WindowsOptionalFeatureXml) {
                        $WindowsOptionalFeature = Import-CliXml $WindowsOptionalFeatureXml
                        $WindowsOptionalFeature = $WindowsOptionalFeature | Where-Object {$_.State -eq 3}
                        foreach ($Item in $WindowsOptionalFeature) {Write-Host "$($Item.FeatureName)"}
                    }

                    Write-Host '========================================================================================' -ForegroundColor DarkGray
                    Write-Host "Windows Optional Features (Disabled)" -ForegroundColor Green
                    $WindowsOptionalFeatureXml = Join-Path $($Media.FullName) (Join-Path "info" (Join-Path "xml" "Get-WindowsOptionalFeature.xml"))
                    if (Test-Path $WindowsOptionalFeatureXml) {
                        $WindowsOptionalFeature = Import-CliXml $WindowsOptionalFeatureXml
                        $WindowsOptionalFeature = $WindowsOptionalFeature | Where-Object {$_.State -eq 0}
                        foreach ($Item in $WindowsOptionalFeature) {Write-Host "$($Item.FeatureName)"}
                    }

                    Write-Host '========================================================================================' -ForegroundColor DarkGray
                    Write-Host "Windows Optional Features (Disabled with Payload Removed)" -ForegroundColor Green
                    $WindowsOptionalFeatureXml = Join-Path $($Media.FullName) (Join-Path "info" (Join-Path "xml" "Get-WindowsOptionalFeature.xml"))
                    if (Test-Path $WindowsOptionalFeatureXml) {
                        $WindowsOptionalFeature = Import-CliXml $WindowsOptionalFeatureXml
                        $WindowsOptionalFeature = $WindowsOptionalFeature | Where-Object {$_.State -eq 6}
                        foreach ($Item in $WindowsOptionalFeature) {Write-Host "$($Item.FeatureName)"}
                    }
                }

                Write-Host '========================================================================================' -ForegroundColor DarkGray
                Write-Host "Windows Update Packages" -ForegroundColor Green
                $GetWindowsPackageXml = Join-Path $($Media.FullName) (Join-Path "info" (Join-Path "xml" "Get-WindowsPackage.xml"))
                if (Test-Path $GetWindowsPackageXml) {
                    $GetWindowsPackage = Import-CliXml $GetWindowsPackageXml
                    $GetWindowsPackage = $GetWindowsPackage | Where-Object {$_.PackageName -like "*Package_for*"}
                    foreach ($Item in $GetWindowsPackage) {Write-Host "$($Item.PackageName)"}
                }

                Write-Host '========================================================================================' -ForegroundColor DarkGray
                Write-Host "Windows Image Information" -ForegroundColor Green
                $GetWindowsImageXml = Join-Path $($Media.FullName) (Join-Path "info" (Join-Path "xml" "Get-WindowsImage.xml"))
                if (Test-Path $GetWindowsImageXml) {
                    $GetWindowsImageInfo = Import-CliXml $GetWindowsImageXml
                    if ($GetWindowsImageInfo.Architecture -eq '0') {$GetWindowsImageInfo.Architecture = 'x86'}
                    if ($GetWindowsImageInfo.Architecture -eq '6') {$GetWindowsImageInfo.Architecture = 'ia64'}
                    if ($GetWindowsImageInfo.Architecture -eq '9') {$GetWindowsImageInfo.Architecture = 'x64'}
                    if ($GetWindowsImageInfo.Architecture -eq '12') {$GetWindowsImageInfo.Architecture = 'x64 ARM'}
                    $GetWindowsImageInfo | Format-List
                }
            }
        }
    }

    END {
        #Write-Host '========================================================================================' -ForegroundColor DarkGray
        #Write-Host -ForegroundColor Green "$($MyInvocation.MyCommand.Name) END"
    }
}