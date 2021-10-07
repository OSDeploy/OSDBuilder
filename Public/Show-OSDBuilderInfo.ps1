<#
.SYNOPSIS
Shows Operating System information of any OSDBuilder Media

.DESCRIPTION
Shows Operating System information of any OSDBuilder Media (OSMedia, OSBuilds, PEBuilds)

.LINK
https://osdbuilder.osdeploy.com/module/functions/show-osdbuilderinfo

.PARAMETER FullName
Full Path of the OSDBuilder Media
#>
function Show-OSDBuilderInfo {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        [string[]]$FullName
    )

    Begin {
        #=================================================
        #   Header
        #=================================================
        #   Write-Host '========================================================================================' -ForegroundColor DarkGray
        #   Write-Host -ForegroundColor Green "$($MyInvocation.MyCommand.Name) BEGIN"
        #=================================================
        #   Get-OSDBuilder
        #=================================================
        Get-OSDBuilder -CreatePaths -HideDetails
        #=================================================
        #   Gather All OS Media
        $AllMyOSMedia = @()
        $AllMyOSBuilds = @()
        $AllMyPEBuilds = @()
        $AllMyOSDBMedia = @()


        $AllMyOSMedia = Get-OSMedia
        $AllMyOSBuilds = Get-OSBuilds
        $AllMyPEBuilds = Get-PEBuilds
        $AllMyOSDBMedia = [array]$AllMyOSMedia + [array]$AllMyOSBuilds + [array]$AllMyPEBuilds
        #=================================================
    }

    PROCESS {
        #Write-Host '========================================================================================' -ForegroundColor DarkGray
        #Write-Host -ForegroundColor Green "$($MyInvocation.MyCommand.Name) PROCESS"

        #=================================================
        Write-Verbose '19.1.1 Select Source OSMedia'
        #=================================================
        $SelectedOSMedia = @()

        if ($FullName) {
            foreach ($Item in $FullName) {
                Write-Verbose "Checking $Item"
                $SelectedOSMedia += $AllMyOSDBMedia | Where-Object {$_.FullName -eq $Item}
            }
        } else {
            $SelectedOSMedia = $AllMyOSDBMedia | Out-GridView -Title "OSDBuilder: Select one or more Media and press OK (Cancel to Exit)" -PassThru
        }

        #=================================================
        #   Foreach
        #=================================================
        foreach ($Media in $SelectedOSMedia) {
            Write-Host '========================================================================================' -ForegroundColor DarkGray
            Write-Host "Show-OSDBuilderInfo -FullName '$($Media.FullName)'" -ForegroundColor Green

            if (!(Test-Path $(Join-Path $Media.FullName (Join-Path "info" (Join-Path "xml" "Get-WindowsImage.xml"))))) {
                Write-Host '========================================================================================' -ForegroundColor DarkGray
                Write-Warning "Could not find an OSDBuilder Operating System at $Media.FullName"
                Break
            }

            #=================================================
            #   Get-AppxProvisionedPackage
            #=================================================
            $global:GetAppxProvisionedPackage = @()
            $GetAppxProvisionedPackageXml = Join-Path $($Media.FullName) (Join-Path "info" (Join-Path "xml" "Get-AppxProvisionedPackage.xml"))
            if (Test-Path $GetAppxProvisionedPackageXml) {
                $global:GetAppxProvisionedPackage = Import-CliXml $GetAppxProvisionedPackageXml

                Write-Host '========================================================================================' -ForegroundColor DarkGray
                Write-Host "Get-AppxProvisionedPackage (DisplayName)" -ForegroundColor Green
                foreach ($item in $GetAppxProvisionedPackage | Where-Object {$_.PackageName  -notmatch 'LanguageExperiencePack'}) {
                    Write-Host "$($Item.DisplayName)"
                }

                Write-Host '========================================================================================' -ForegroundColor DarkGray
                Write-Host "Get-AppxProvisionedPackage (PackageName)" -ForegroundColor Green
                foreach ($item in $GetAppxProvisionedPackage | Where-Object {$_.PackageName  -notmatch 'LanguageExperiencePack'}) {
                    Write-Host "$($Item.PackageName)"
                }

                Write-Host '========================================================================================' -ForegroundColor DarkGray
                Write-Host "Get-AppxProvisionedPackage Language Experience Packs (DisplayName)" -ForegroundColor Green
                foreach ($item in $GetAppxProvisionedPackage | Where-Object {$_.PackageName  -match 'LanguageExperiencePack'}) {
                    Write-Host "$($Item.DisplayName)"
                }

                Write-Host '========================================================================================' -ForegroundColor DarkGray
                Write-Host "Get-AppxProvisionedPackage Language Experience Packs (PackageName)" -ForegroundColor Green
                foreach ($item in $GetAppxProvisionedPackage | Where-Object {$_.PackageName  -match 'LanguageExperiencePack'}) {
                    Write-Host "$($Item.PackageName)"
                }
            }

            #=================================================
            #   Get-WindowsCapability
            #=================================================
            $global:GetWindowsCapability = @()
            $GetWindowsCapabilityXml = Join-Path $($Media.FullName) (Join-Path "info" (Join-Path "xml" "Get-WindowsCapability.xml"))
            if (Test-Path $GetWindowsCapabilityXml) {
                $global:GetWindowsCapability = Import-CliXml $GetWindowsCapabilityXml

                Write-Host '========================================================================================' -ForegroundColor DarkGray
                Write-Host "Get-WindowsCapability (State: Installed)" -ForegroundColor Green
                foreach ($item in $GetWindowsCapability | Where-Object {($_.State -eq 4) -and ($_.Name -notmatch 'Language')}) {
                    Write-Host "$($item.Name)"
                }

                Write-Host '========================================================================================' -ForegroundColor DarkGray
                Write-Host "Get-WindowsCapability (State: NotPresent)" -ForegroundColor Green
                foreach ($item in $GetWindowsCapability | Where-Object {($_.State -eq 0) -and ($_.Name -notmatch 'Language')}) {
                    Write-Host "$($item.Name)" -ForegroundColor DarkGray
                }

                Write-Host '========================================================================================' -ForegroundColor DarkGray
                Write-Host "Get-WindowsCapability Language (State: Installed)" -ForegroundColor Green
                foreach ($item in $GetWindowsCapability | Where-Object {($_.State -eq 4) -and ($_.Name -match 'Language')}) {
                    Write-Host "$($item.Name)"
                }

                Write-Host '========================================================================================' -ForegroundColor DarkGray
                Write-Host "Get-WindowsCapability Language (State: NotPresent)" -ForegroundColor Green
                foreach ($item in $GetWindowsCapability | Where-Object {($_.State -eq 0) -and ($_.Name -match 'Language')}) {
                    Write-Host "$($item.Name)" -ForegroundColor DarkGray
                }
            }

            #=================================================
            #   Get-WindowsOptionalFeature
            #=================================================
            $global:GetWindowsOptionalFeature = @()
            $WindowsOptionalFeatureXml = Join-Path $($Media.FullName) (Join-Path "info" (Join-Path "xml" "Get-WindowsOptionalFeature.xml"))
            if (Test-Path $WindowsOptionalFeatureXml) {
                $global:GetWindowsOptionalFeature = Import-CliXml $WindowsOptionalFeatureXml

                Write-Host '========================================================================================' -ForegroundColor DarkGray
                Write-Host "Get-WindowsOptionalFeature (State: Enabled)" -ForegroundColor Green
                foreach ($item in $GetWindowsOptionalFeature | Where-Object {$_.State -eq 2}) {
                    Write-Host "$($item.FeatureName)" -ForegroundColor White
                }

                Write-Host '========================================================================================' -ForegroundColor DarkGray
                Write-Host "Get-WindowsOptionalFeature (State: EnablePending)" -ForegroundColor Green
                foreach ($item in $GetWindowsOptionalFeature | Where-Object {$_.State -eq 3}) {
                    Write-Host "$($item.FeatureName)" -ForegroundColor White
                }

                Write-Host '========================================================================================' -ForegroundColor DarkGray
                Write-Host "Get-WindowsOptionalFeature (State: Disabled)" -ForegroundColor Green
                foreach ($item in $GetWindowsOptionalFeature | Where-Object {$_.State -eq 0}) {
                    Write-Host "$($item.FeatureName)" -ForegroundColor DarkGray
                }

                Write-Host '========================================================================================' -ForegroundColor DarkGray
                Write-Host "Get-WindowsOptionalFeature (State: DisabledWithPayloadRemoved)" -ForegroundColor Green
                foreach ($item in $GetWindowsOptionalFeature | Where-Object {$_.State -eq 6}) {
                    Write-Host "$($item.FeatureName)" -ForegroundColor DarkGray
                }
            }

            #=================================================
            #   Get-WindowsPackage
            #=================================================
            $global:GetWindowsPackage = @()
            $GetWindowsPackageXml = Join-Path $($Media.FullName) (Join-Path "info" (Join-Path "xml" "Get-WindowsPackage.xml"))
            if (Test-Path $GetWindowsPackageXml) {
                $global:GetWindowsPackage = Import-CliXml $GetWindowsPackageXml

                Write-Host '========================================================================================' -ForegroundColor DarkGray
                Write-Host "Get-WindowsPackage (PackageState: Superseded)" -ForegroundColor Green
                foreach ($item in $GetWindowsPackage | Where-Object {$_.PackageState -eq 6}) {
                    Write-Host "$($item.PackageName)" -ForegroundColor DarkGray
                }

                Write-Host '========================================================================================' -ForegroundColor DarkGray
                Write-Host "Get-WindowsPackage (PackageState: Installed) Language Packs" -ForegroundColor Green
                foreach ($item in $GetWindowsPackage | Where-Object {($_.PackageState -eq 4) -and ($_.PackageName -match 'LanguagePack')}) {
                    Write-Host "$($item.PackageName)" -ForegroundColor White
                }

                Write-Host '========================================================================================' -ForegroundColor DarkGray
                Write-Host "Get-WindowsPackage (PackageState: Installed) Language Features" -ForegroundColor Green
                foreach ($item in $GetWindowsPackage | Where-Object {($_.PackageState -eq 4) -and ($_.PackageName -match 'LanguageFeatures')}) {
                    Write-Host "$($item.PackageName)" -ForegroundColor White
                }

                Write-Host '========================================================================================' -ForegroundColor DarkGray
                Write-Host "Get-WindowsPackage (PackageState: Installed) Features on Demand" -ForegroundColor Green
                foreach ($item in $GetWindowsPackage | Where-Object {($_.PackageState -eq 4) -and ($_.PackageName -match 'FOD')}) {
                    Write-Host "$($item.PackageName)" -ForegroundColor White
                }

                Write-Host '========================================================================================' -ForegroundColor DarkGray
                Write-Host "Get-WindowsPackage (PackageState: Installed)" -ForegroundColor Green
                foreach ($item in $GetWindowsPackage | Where-Object {($_.PackageState -eq 4) -and ($_.PackageName -notmatch 'LanguagePack') -and ($_.PackageName -notmatch 'LanguageFeatures') -and ($_.PackageName -notmatch 'FOD') -and ($_.PackageName -notmatch 'Package_for')}) {
                    Write-Host "$($item.PackageName)" -ForegroundColor White
                }

                Write-Host '========================================================================================' -ForegroundColor DarkGray
                Write-Host "Get-WindowsPackage (PackageState: Installed) Updates" -ForegroundColor Green
                foreach ($item in $GetWindowsPackage | Where-Object {($_.PackageState -eq 4) -and ($_.PackageName -match 'Package_for')}) {
                    Write-Host "$($item.PackageName)" -ForegroundColor White
                }
            }

            #=================================================
            #   Get-WindowsImage
            #=================================================
            $global:GetWindowsImage = @()
            $GetWindowsImageXml = Join-Path $($Media.FullName) (Join-Path "info" (Join-Path "xml" "Get-WindowsImage.xml"))
            if (Test-Path $GetWindowsImageXml) {
                $global:GetWindowsImage = Import-CliXml $GetWindowsImageXml
                if ($GetWindowsImage.Architecture -eq '0') {$GetWindowsImage.Architecture = 'x86'}
                if ($GetWindowsImage.Architecture -eq '6') {$GetWindowsImage.Architecture = 'ia64'}
                if ($GetWindowsImage.Architecture -eq '9') {$GetWindowsImage.Architecture = 'x64'}
                if ($GetWindowsImage.Architecture -eq '12') {$GetWindowsImage.Architecture = 'x64 ARM'}
                Write-Host '========================================================================================' -ForegroundColor DarkGray
                Write-Host "Get-WindowsImage" -ForegroundColor Green
                $GetWindowsImage | Format-List
            }
        }
    }

    END {
        #Write-Host '========================================================================================' -ForegroundColor DarkGray
        #Write-Host -ForegroundColor Green "$($MyInvocation.MyCommand.Name) END"
    }
}