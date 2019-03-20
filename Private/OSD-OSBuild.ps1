function OSD-OSBuild-EnableNetFX {
    [CmdletBinding()]
    PARAM ()
    #===================================================================================================
    Write-Verbose '19.1.25 OSBuild EnableNetFX3'
    #===================================================================================================
    if ($OSMajorVersion -ne 10) {Return}
    
    Write-Host '========================================================================================' -ForegroundColor DarkGray
    Write-Host "Install.wim: Enable NetFX 3.5"	-ForegroundColor Green
    Try {
        Enable-WindowsOptionalFeature -Path "$MountDirectory" -FeatureName NetFX3 -All -LimitAccess -Source "$OS\sources\sxs" -LogPath "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-NetFX3.log" | Out-Null
        OSD-Updates-DotNet
        OSD-Updates-LCUForce
    }
    Catch {
        $ErrorMessage = $_.Exception.Message
        Write-Warning "$ErrorMessage"
    }
}

function OSD-OSBuild-FeaturesOnDemand {
    [CmdletBinding()]
    PARAM ()
    #===================================================================================================
    Write-Verbose '19.1.25 Features On Demand'
    #===================================================================================================
    
    Write-Host '========================================================================================' -ForegroundColor DarkGray
    Write-Host "Install.wim: Features On Demand"	-ForegroundColor Green
    foreach ($FOD in $FeaturesOnDemand) {
        Write-Host $FOD -ForegroundColor DarkGray
        $CurrentLog = "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-FOD.log"
        Try {
            Add-WindowsPackage -Path "$MountDirectory" -PackagePath "$OSDBuilderContent\$FOD" -LogPath "$CurrentLog" | Out-Null
        }
        Catch {
            $ErrorMessage = $_.Exception.Message
            Write-Warning "$ErrorMessage"
        }
    }
    OSD-Updates-LCUForce
    OSD-Updates-DismImageCleanup
}

function OSD-OSBuild-RemoveAppx {
    [CmdletBinding()]
    PARAM ()
    #===================================================================================================
    Write-Verbose '19.1.25 Remove Appx Packages'
    #===================================================================================================
    if ($OSMajorVersion -ne 10) {Return}

    Write-Host '========================================================================================' -ForegroundColor DarkGray
    Write-Host "Install.wim: Remove Appx Packages"	-ForegroundColor Green
    foreach ($item in $RemoveAppx) {
        Write-Host $item -ForegroundColor DarkGray
        Try {
            Remove-AppxProvisionedPackage -Path "$MountDirectory" -PackageName $item -LogPath "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Remove-AppxProvisionedPackage.log" | Out-Null
        }
        Catch {
            $ErrorMessage = $_.Exception.Message
            Write-Warning "$ErrorMessage"
        }
    }
}

function OSD-OSBuild-RemovePackage {
    [CmdletBinding()]
    PARAM ()
    #===================================================================================================
    Write-Verbose '19.1.25 Remove Packages'
    #===================================================================================================

    Write-Host '========================================================================================' -ForegroundColor DarkGray
    Write-Host "Install.wim: Remove Windows Packages"	-ForegroundColor Green
    foreach ($PackageName in $RemovePackage) {
        Write-Host $PackageName -ForegroundColor DarkGray
        Try {
            Remove-WindowsPackage -Path "$MountDirectory" -PackageName $PackageName -LogPath "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Remove-WindowsPackage.log" | Out-Null
        }
        Catch {
            $ErrorMessage = $_.Exception.Message
            Write-Warning "$ErrorMessage"
        }
    }
}

function OSD-OSBuild-RemoveCapability {
    [CmdletBinding()]
    PARAM ()
    #===================================================================================================
    #   Remove Capability'
    #===================================================================================================
    Write-Host '========================================================================================' -ForegroundColor DarkGray
    Write-Host "Install.wim: Remove Windows Capability"	-ForegroundColor Green
    foreach ($Name in $RemoveCapability) {
        Write-Host $Name -ForegroundColor DarkGray
        Try {
            Remove-WindowsCapability -Path "$MountDirectory" -Name $Name -LogPath "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Remove-WindowsCapability.log" | Out-Null
        }
        Catch {
            $ErrorMessage = $_.Exception.Message
            Write-Warning "$ErrorMessage"
        }
    }
}

function OSD-OSBuild-EnableWindowsOptionalFeature {
    [CmdletBinding()]
    PARAM ()
    #===================================================================================================
    #   Enable Windows Optional Features'
    #===================================================================================================
    Write-Host '========================================================================================' -ForegroundColor DarkGray
    Write-Host "Install.wim: Enable Windows Optional Feature"	-ForegroundColor Green
    foreach ($FeatureName in $EnableFeature) {
        Write-Host $FeatureName -ForegroundColor DarkGray
        Try {
            Enable-WindowsOptionalFeature -FeatureName $FeatureName -Path "$MountDirectory" -All -LogPath "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Enable-WindowsOptionalFeature.log" | Out-Null
        }
        Catch {
            $ErrorMessage = $_.Exception.Message
            Write-Warning "$ErrorMessage"
        }
    }
    OSD-Updates-LCUForce
    OSD-Updates-DismImageCleanup
}
function OSD-OSBuild-DisableWindowsOptionalFeature {
    [CmdletBinding()]
    PARAM ()
    #===================================================================================================
    Write-Verbose '19.1.25 Disable Windows Optional Feature'
    #===================================================================================================

    Write-Host '========================================================================================' -ForegroundColor DarkGray
    Write-Host "Install.wim: Disable Windows Optional Feature" -ForegroundColor Green
    foreach ($FeatureName in $DisableFeature) {
        Write-Host $FeatureName -ForegroundColor DarkGray
        Try {
            Disable-WindowsOptionalFeature -FeatureName $FeatureName -Path "$MountDirectory" -LogPath "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Disable-WindowsOptionalFeature.log" | Out-Null
        }
        Catch {
            $ErrorMessage = $_.Exception.Message
            Write-Warning "$ErrorMessage"
        }
    }
}

function OSD-OSBuild-Packages {
    [CmdletBinding()]
    PARAM ()
    #===================================================================================================
    Write-Verbose '19.1.25 Add Packages'
    #===================================================================================================

    Write-Host '========================================================================================' -ForegroundColor DarkGray
    Write-Host "Install.wim: Add Packages"	-ForegroundColor Green
    foreach ($PackagePath in $Packages) {
        Write-Host "$OSDBuilderContent\$PackagePath" -ForegroundColor DarkGray
        Try {
            Add-WindowsPackage -PackagePath "$OSDBuilderContent\$PackagePath" -Path "$MountDirectory" -LogPath "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Add-WindowsPackage.log" | Out-Null
        }
        Catch {
            $ErrorMessage = $_.Exception.Message
            Write-Warning "$ErrorMessage"
        }
    }
}



function OSD-OSBuild-StartLayout {
    [CmdletBinding()]
    PARAM ()
    #===================================================================================================
    Write-Verbose '19.1.25 Start Layout'
    #===================================================================================================
    if ($OSMajorVersion -ne 10) {Return}

    Write-Host '========================================================================================' -ForegroundColor DarkGray
    Write-Host "Install.wim: Start Layout" -ForegroundColor Green
    Write-Host "$OSDBuilderContent\$StartLayoutXML" -ForegroundColor DarkGray
    Try {
        Copy-Item -Path "$OSDBuilderContent\$StartLayoutXML" -Destination "$MountDirectory\Users\Default\AppData\Local\Microsoft\Windows\Shell\LayoutModification.xml" -Recurse -Force | Out-Null
    }
    Catch {
        $ErrorMessage = $_.Exception.Message
        Write-Warning "$ErrorMessage"
    }
}

function OSD-OSBuild-Unattend {
    [CmdletBinding()]
    PARAM ()
    #===================================================================================================
    Write-Verbose '19.1.25 Unattend.xml'
    #===================================================================================================
    if ($OSMajorVersion -ne 10) {Return}

    Write-Host '========================================================================================' -ForegroundColor DarkGray
    Write-Host "Install.wim: Unattend.xml" -ForegroundColor Green
    Write-Host "$OSDBuilderContent\$UnattendXML" -ForegroundColor DarkGray
    if (!(Test-Path "$MountDirectory\Windows\Panther")) {New-Item -Path "$MountDirectory\Windows\Panther" -ItemType Directory -Force | Out-Null}
    Copy-Item -Path "$OSDBuilderContent\$UnattendXML" -Destination "$MountDirectory\Windows\Panther\Unattend.xml" -Force
    Try {
        Use-WindowsUnattend -UnattendPath "$OSDBuilderContent\$UnattendXML" -Path "$MountDirectory" -LogPath "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Use-WindowsUnattend.log" | Out-Null
    }
    Catch {
        $ErrorMessage = $_.Exception.Message
        Write-Warning "$ErrorMessage"
    }
}