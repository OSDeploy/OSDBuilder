function OSD-OS-Inventory {
    [CmdletBinding()]
    PARAM (
        [string]$OSMediaPath
    )
    #===================================================================================================
    Write-Verbose '19.1.1 OSD-OS-Inventory'
    #===================================================================================================
    #Write-Host '========================================================================================' -ForegroundColor DarkGray
    Write-Host "Install.wim: Export Inventory to $OSMediaPath" -ForegroundColor Green
    Write-Verbose 'OSD-OS-Inventory'
    Write-Verbose "OSMediaPath: $OSMediaPath"

    $GetAppxProvisionedPackage = @()
    TRY {
        Write-Verbose "$OSMediaPath\AppxProvisionedPackage.txt"
        $GetAppxProvisionedPackage = Get-AppxProvisionedPackage -Path "$MountDirectory"
        $GetAppxProvisionedPackage | Out-File "$OSMediaPath\info\Get-AppxProvisionedPackage.txt"
        $GetAppxProvisionedPackage | Out-File "$OSMediaPath\AppxProvisionedPackage.txt"
        $GetAppxProvisionedPackage | Out-File "$OSMediaPath\info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-AppxProvisionedPackage.txt"
        $GetAppxProvisionedPackage | Export-Clixml -Path "$OSMediaPath\info\xml\Get-AppxProvisionedPackage.xml"
        $GetAppxProvisionedPackage | Export-Clixml -Path "$OSMediaPath\info\xml\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-AppxProvisionedPackage.xml"
        $GetAppxProvisionedPackage | ConvertTo-Json | Out-File "$OSMediaPath\info\json\Get-AppxProvisionedPackage.json"
        $GetAppxProvisionedPackage | ConvertTo-Json | Out-File "$OSMediaPath\info\json\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-AppxProvisionedPackage.json"
    }
    CATCH {Write-Warning "Get-AppxProvisionedPackage is not supported by this Operating System"}

    $GetWindowsOptionalFeature = @()
    TRY {
        Write-Verbose "$OSMediaPath\WindowsOptionalFeature.txt"
        $GetWindowsOptionalFeature = Get-WindowsOptionalFeature -Path "$MountDirectory"
        $GetWindowsOptionalFeature | Out-File "$OSMediaPath\info\Get-WindowsOptionalFeature.txt"
        $GetWindowsOptionalFeature | Out-File "$OSMediaPath\WindowsOptionalFeature.txt"
        $GetWindowsOptionalFeature | Out-File "$OSMediaPath\info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsOptionalFeature.txt"
        $GetWindowsOptionalFeature | Export-Clixml -Path "$OSMediaPath\info\xml\Get-WindowsOptionalFeature.xml"
        $GetWindowsOptionalFeature | Export-Clixml -Path "$OSMediaPath\info\xml\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsOptionalFeature.xml"
        $GetWindowsOptionalFeature | ConvertTo-Json | Out-File "$OSMediaPath\info\json\Get-WindowsOptionalFeature.json"
        $GetWindowsOptionalFeature | ConvertTo-Json | Out-File "$OSMediaPath\info\json\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsOptionalFeature.json"
    }
    CATCH {Write-Warning "Get-WindowsOptionalFeature is not supported by this Operating System"}

    $GetWindowsCapability = @()
    TRY {
        Write-Verbose "$OSMediaPath\WindowsCapability.txt"
        $GetWindowsCapability = Get-WindowsCapability -Path "$MountDirectory"
        $GetWindowsCapability | Out-File "$OSMediaPath\info\Get-WindowsCapability.txt"
        $GetWindowsCapability | Out-File "$OSMediaPath\WindowsCapability.txt"
        $GetWindowsCapability | Out-File "$OSMediaPath\info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsCapability.txt"
        $GetWindowsCapability | Export-Clixml -Path "$OSMediaPath\info\xml\Get-WindowsCapability.xml"
        $GetWindowsCapability | Export-Clixml -Path "$OSMediaPath\info\xml\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsCapability.xml"
        $GetWindowsCapability | ConvertTo-Json | Out-File "$OSMediaPath\info\json\Get-WindowsCapability.json"
        $GetWindowsCapability | ConvertTo-Json | Out-File "$OSMediaPath\info\json\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsCapability.json"            
    }
    CATCH {Write-Warning "Get-WindowsCapability is not supported by this Operating System"}

    $GetWindowsPackage = @()
    TRY {
        Write-Verbose "$OSMediaPath\WindowsPackage.txt"
        $GetWindowsPackage = Get-WindowsPackage -Path "$MountDirectory"
        $GetWindowsPackage | Out-File "$OSMediaPath\info\Get-WindowsPackage.txt"
        $GetWindowsPackage | Out-File "$OSMediaPath\WindowsPackage.txt"
        $GetWindowsPackage | Out-File "$OSMediaPath\info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsPackage.txt"
        $GetWindowsPackage | Export-Clixml -Path "$OSMediaPath\info\xml\Get-WindowsPackage.xml"
        $GetWindowsPackage | Export-Clixml -Path "$OSMediaPath\info\xml\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsPackage.xml"
        $GetWindowsPackage | ConvertTo-Json | Out-File "$OSMediaPath\info\json\Get-WindowsPackage.json"
        $GetWindowsPackage | ConvertTo-Json | Out-File "$OSMediaPath\info\json\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsPackage.json"
    }
    CATCH {Write-Warning "Get-WindowsPackage is not supported by this Operating System"}
}







function OSD-OS-RegExportCurrentVersion {
    [CmdletBinding()]
    PARAM ()

    $RegCurrentVersion | Out-File "$Info\CurrentVersion.txt"
    $RegCurrentVersion | Out-File "$WorkingPath\CurrentVersion.txt"
    $RegCurrentVersion | Out-File "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-CurrentVersion.txt"
    $RegCurrentVersion | Export-Clixml -Path "$Info\xml\CurrentVersion.xml"
    $RegCurrentVersion | Export-Clixml -Path "$Info\xml\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-CurrentVersion.xml"
    $RegCurrentVersion | ConvertTo-Json | Out-File "$Info\json\CurrentVersion.json"
    $RegCurrentVersion | ConvertTo-Json | Out-File "$Info\json\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-CurrentVersion.json"
}

function OSD-OS-CopyOS {
    [CmdletBinding()]
    PARAM ()
    #===================================================================================================
    Write-Verbose '19.3.15 Media: Copy Operating System'
    #===================================================================================================
    Write-Host '========================================================================================' -ForegroundColor DarkGray
    Write-Host "Media: Copy Operating System to $WorkingPath" -ForegroundColor Green
    Copy-Item -Path "$OSMediaPath\*" -Destination "$WorkingPath" -Exclude ('*.wim','*.iso','*.vhd','*.vhx') -Recurse -Force | Out-Null
    if (Test-Path "$WorkingPath\ISO") {Remove-Item -Path "$WorkingPath\ISO" -Force -Recurse | Out-Null}
    if (Test-Path "$WorkingPath\VHD") {Remove-Item -Path "$WorkingPath\VHD" -Force -Recurse | Out-Null}
    Copy-Item -Path "$OSMediaPath\OS\sources\install.wim" -Destination "$WimTemp\install.wim" -Force | Out-Null
    Copy-Item -Path "$OSMediaPath\WinPE\*.wim" -Destination "$WimTemp" -Exclude boot.wim -Force | Out-Null
}

function OSD-OS-CreateDirectories {
    [CmdletBinding()]
    PARAM ()
    #===================================================================================================
    Write-Verbose '19.1.25 Create Directories'
    #===================================================================================================
    if (!(Test-Path "$Info"))           {New-Item "$Info" -ItemType Directory -Force | Out-Null}
    if (!(Test-Path "$Info\json"))      {New-Item "$Info\json" -ItemType Directory -Force | Out-Null}
    if (!(Test-Path "$Info\logs"))      {New-Item "$Info\logs" -ItemType Directory -Force | Out-Null}
    if (!(Test-Path "$Info\xml"))       {New-Item "$Info\xml" -ItemType Directory -Force | Out-Null}
    if (!(Test-Path "$OS"))             {New-Item "$OS" -ItemType Directory -Force | Out-Null}
    if (!(Test-Path "$WinPE"))          {New-Item "$WinPE" -ItemType Directory -Force | Out-Null}
    if (!(Test-Path "$PEInfo"))         {New-Item "$PEInfo" -ItemType Directory -Force | Out-Null}
    if (!(Test-Path "$PEInfo\json"))    {New-Item "$PEInfo\json" -ItemType Directory -Force | Out-Null}
    if (!(Test-Path "$PEInfo\logs"))    {New-Item "$PEInfo\logs" -ItemType Directory -Force | Out-Null}
    if (!(Test-Path "$PEInfo\xml"))     {New-Item "$PEInfo\xml" -ItemType Directory -Force | Out-Null}
    if (!(Test-Path "$WimTemp"))        {New-Item "$WimTemp" -ItemType Directory -Force | Out-Null}
    if (!(Test-Path "$MountDirectory")) {New-Item "$MountDirectory" -ItemType Directory -Force | Out-Null}
    if (!(Test-Path "$MountWinPE"))     {New-Item "$MountWinPE" -ItemType Directory -Force | Out-Null}
    if (!(Test-Path "$MountWinSE"))     {New-Item "$MountWinSE" -ItemType Directory -Force | Out-Null}
    if (!(Test-Path "$MountWinRE"))     {New-Item "$MountWinRE" -ItemType Directory -Force | Out-Null}
}