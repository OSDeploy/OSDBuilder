function Save-InventoryOS {
    [CmdletBinding()]
    Param (
        [string]$OSMediaPath
    )
    #===================================================================================================
    #   Header
    #===================================================================================================
    Show-ActionTime
    Write-Host -ForegroundColor Green "OS: Export Inventory to $OSMediaPath"
    #===================================================================================================
    #   Execute
    #===================================================================================================
    Write-Verbose 'Save-InventoryOS'
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
function Save-InventoryPE {
    [CmdletBinding()]
    Param (
        [string]$OSMediaPath
    )
    #===================================================================================================
    #   Header
    #===================================================================================================
    Show-ActionTime
    Write-Host -ForegroundColor Green "WinPE: Export WIM Inventory to $OSMediaPath\WinPE\info"
    #===================================================================================================
    $GetWindowsImage = @()
    Write-Verbose "$OSMediaPath\WinPE\info\Get-WindowsImage-Boot.txt"
    $GetWindowsImage = Get-WindowsImage -ImagePath "$OSMediaPath\WinPE\boot.wim"
    $GetWindowsImage | Out-File "$OSMediaPath\WinPE\info\Get-WindowsImage-Boot.txt"
    (Get-Content "$OSMediaPath\WinPE\info\Get-WindowsImage-Boot.txt") | Where-Object {$_.Trim(" `t")} | Set-Content "$OSMediaPath\WinPE\info\Get-WindowsImage-Boot.txt"
    $GetWindowsImage | Out-File "$OSMediaPath\WinPE\info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsImage-Boot.txt"
    $GetWindowsImage | Export-Clixml -Path "$OSMediaPath\WinPE\info\xml\Get-WindowsImage-Boot.xml"
    $GetWindowsImage | Export-Clixml -Path "$OSMediaPath\WinPE\info\xml\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsImage-Boot.xml"
    $GetWindowsImage | ConvertTo-Json | Out-File "$OSMediaPath\WinPE\info\json\Get-WindowsImage-Boot.json"
    $GetWindowsImage | ConvertTo-Json | Out-File "$OSMediaPath\WinPE\info\json\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsImage-Boot.json"

    #===================================================================================================
    Write-Verbose 'Get-WindowsImage WinPE'
    #===================================================================================================
    $GetWindowsImage = @()
    Write-Verbose "$OSMediaPath\WinPE\info\Get-WindowsImage-WinPE.txt"
    $GetWindowsImage = Get-WindowsImage -ImagePath "$OSMediaPath\WinPE\winpe.wim" -Index 1 | Select-Object -Property *
    $GetWindowsImage | Out-File "$OSMediaPath\WinPE\info\Get-WindowsImage-WinPE.txt"
    (Get-Content "$OSMediaPath\WinPE\info\Get-WindowsImage-WinPE.txt") | Where-Object {$_.Trim(" `t")} | Set-Content "$OSMediaPath\WinPE\info\Get-WindowsImage-WinPE.txt"
    $GetWindowsImage | Out-File "$OSMediaPath\WinPE\info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsImage-WinPE.txt"
    $GetWindowsImage | Export-Clixml -Path "$OSMediaPath\WinPE\info\xml\Get-WindowsImage-WinPE.xml"
    $GetWindowsImage | Export-Clixml -Path "$OSMediaPath\WinPE\info\xml\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsImage-WinPE.xml"
    $GetWindowsImage | ConvertTo-Json | Out-File "$OSMediaPath\WinPE\info\json\Get-WindowsImage-WinPE.json"
    $GetWindowsImage | ConvertTo-Json | Out-File "$OSMediaPath\WinPE\info\json\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsImage-WinPE.json"

    #===================================================================================================
    Write-Verbose 'Get-WindowsImage WinRE'
    #===================================================================================================
    $GetWindowsImage = @()
    Write-Verbose "$OSMediaPath\WinPE\info\Get-WindowsImage-WinRE.txt"
    $GetWindowsImage = Get-WindowsImage -ImagePath "$OSMediaPath\WinPE\winre.wim" -Index 1 | Select-Object -Property *
    $GetWindowsImage | Out-File "$OSMediaPath\WinPE\info\Get-WindowsImage-WinRE.txt"
    (Get-Content "$OSMediaPath\WinPE\info\Get-WindowsImage-WinRE.txt") | Where-Object {$_.Trim(" `t")} | Set-Content "$OSMediaPath\WinPE\info\Get-WindowsImage-WinRE.txt"
    $GetWindowsImage | Out-File "$OSMediaPath\WinPE\info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsImage-WinRE.txt"
    $GetWindowsImage | Export-Clixml -Path "$OSMediaPath\WinPE\info\xml\Get-WindowsImage-WinRE.xml"
    $GetWindowsImage | Export-Clixml -Path "$OSMediaPath\WinPE\info\xml\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsImage-WinRE.xml"
    $GetWindowsImage | ConvertTo-Json | Out-File "$OSMediaPath\WinPE\info\json\Get-WindowsImage-WinRE.json"
    $GetWindowsImage | ConvertTo-Json | Out-File "$OSMediaPath\WinPE\info\json\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsImage-WinRE.json"

    #===================================================================================================
    Write-Verbose 'Get-WindowsImage Setup'
    #===================================================================================================
    $GetWindowsImage = @()
    Write-Verbose "$OSMediaPath\WinPE\info\Get-WindowsImage-WinSE.txt"
    $GetWindowsImage = Get-WindowsImage -ImagePath "$OSMediaPath\WinPE\winse.wim" -Index 1 | Select-Object -Property *
    $GetWindowsImage | Out-File "$OSMediaPath\WinPE\info\Get-WindowsImage-WinSE.txt"
    (Get-Content "$OSMediaPath\WinPE\info\Get-WindowsImage-WinSE.txt") | Where-Object {$_.Trim(" `t")} | Set-Content "$OSMediaPath\WinPE\info\Get-WindowsImage-WinSE.txt"
    $GetWindowsImage | Out-File "$OSMediaPath\WinPE\info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsImage-WinSE.txt"
    $GetWindowsImage | Export-Clixml -Path "$OSMediaPath\WinPE\info\xml\Get-WindowsImage-WinSE.xml"
    $GetWindowsImage | Export-Clixml -Path "$OSMediaPath\WinPE\info\xml\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsImage-WinSE.xml"
    $GetWindowsImage | ConvertTo-Json | Out-File "$OSMediaPath\WinPE\info\json\Get-WindowsImage-WinSE.json"
    $GetWindowsImage | ConvertTo-Json | Out-File "$OSMediaPath\WinPE\info\json\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsImage-WinSE.json"
}
function Save-PackageInventoryPE {
    [CmdletBinding()]
    Param (
        [string]$OSMediaPath
    )
    #===================================================================================================
    #   Header
    #===================================================================================================
    Show-ActionTime
    Write-Host -ForegroundColor Green "WinPE: Export WinPE Package Inventory to $OSMediaPath\WinPE\info"
    #===================================================================================================
    $GetWindowsPackage = @()
    Write-Verbose "$OSMediaPath\WinPE\info\Get-WindowsPackage-WinPE.txt"
    $GetWindowsPackage = Get-WindowsPackage -Path "$MountWinPE"
    $GetWindowsPackage | Out-File "$OSMediaPath\WinPE\info\Get-WindowsPackage-WinPE.txt"
    $GetWindowsPackage | Out-File "$OSMediaPath\WinPE\info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsPackage-WinPE.txt"
    $GetWindowsPackage | Export-Clixml -Path "$OSMediaPath\WinPE\info\xml\Get-WindowsPackage-WinPE.xml"
    $GetWindowsPackage | Export-Clixml -Path "$OSMediaPath\WinPE\info\xml\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsPackage-WinPE.xml"
    $GetWindowsPackage | ConvertTo-Json | Out-File "$OSMediaPath\WinPE\info\json\Get-WindowsPackage-WinPE.json"
    $GetWindowsPackage | ConvertTo-Json | Out-File "$OSMediaPath\WinPE\info\json\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsPackage-WinPE.json"

    #===================================================================================================
    Write-Verbose 'Get-WindowsPackage WinRE'
    #===================================================================================================
    $GetWindowsPackage = @()
    Write-Verbose "$OSMediaPath\WinPE\info\Get-WindowsPackage-WinRE.txt"
    $GetWindowsPackage = Get-WindowsPackage -Path "$MountWinRE"
    $GetWindowsPackage | Out-File "$OSMediaPath\WinPE\info\Get-WindowsPackage-WinRE.txt"
    $GetWindowsPackage | Out-File "$OSMediaPath\WinPE\info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsPackage-WinRE.txt"
    $GetWindowsPackage | Export-Clixml -Path "$OSMediaPath\WinPE\info\xml\Get-WindowsPackage-WinRE.xml"
    $GetWindowsPackage | Export-Clixml -Path "$OSMediaPath\WinPE\info\xml\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsPackage-WinRE.xml"
    $GetWindowsPackage | ConvertTo-Json | Out-File "$OSMediaPath\WinPE\info\json\Get-WindowsPackage-WinRE.json"
    $GetWindowsPackage | ConvertTo-Json | Out-File "$OSMediaPath\WinPE\info\json\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsPackage-WinRE.json"

    #===================================================================================================
    Write-Verbose 'Get-WindowsPackage WinSE'
    #===================================================================================================
    $GetWindowsPackage = @()
    Write-Verbose "$OSMediaPath\WinPE\info\Get-WindowsPackage-WinSE.txt"
    $GetWindowsPackage = Get-WindowsPackage -Path "$MountWinSE"
    $GetWindowsPackage | Out-File "$OSMediaPath\WinPE\info\Get-WindowsPackage-WinSE.txt"
    $GetWindowsPackage | Out-File "$OSMediaPath\WinPE\info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsPackage-WinSE.txt"
    $GetWindowsPackage | Export-Clixml -Path "$OSMediaPath\WinPE\info\xml\Get-WindowsPackage-WinSE.xml"
    $GetWindowsPackage | Export-Clixml -Path "$OSMediaPath\WinPE\info\xml\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsPackage-WinSE.xml"
    $GetWindowsPackage | ConvertTo-Json | Out-File "$OSMediaPath\WinPE\info\json\Get-WindowsPackage-WinSE.json"
    $GetWindowsPackage | ConvertTo-Json | Out-File "$OSMediaPath\WinPE\info\json\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsPackage-WinSE.json"
}
function Save-RegistryCurrentVersionOS {
    [CmdletBinding()]
    Param ()
    $RegCurrentVersion | Out-File "$Info\CurrentVersion.txt"
    $RegCurrentVersion | Out-File "$WorkingPath\CurrentVersion.txt"
    $RegCurrentVersion | Out-File "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-CurrentVersion.txt"
    $RegCurrentVersion | Export-Clixml -Path "$Info\xml\CurrentVersion.xml"
    $RegCurrentVersion | Export-Clixml -Path "$Info\xml\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-CurrentVersion.xml"
    $RegCurrentVersion | ConvertTo-Json | Out-File "$Info\json\CurrentVersion.json"
    $RegCurrentVersion | ConvertTo-Json | Out-File "$Info\json\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-CurrentVersion.json"
}
function Save-SessionsXmlOS {
    [CmdletBinding()]
    Param (
        [string]$OSMediaPath
    )
    #===================================================================================================
    #   Header
    #===================================================================================================
    Show-ActionTime
    Write-Host -ForegroundColor Green "OS: Copy Sessions.xml to $OSMediaPath\info\Sessions.xml"
    Write-Verbose "OSMediaPath: $OSMediaPath"

    if (Test-Path "$MountDirectory\Windows\Servicing\Sessions\Sessions.xml") {
        Write-Verbose "$OSMediaPath\info\Sessions.xml"
        Copy-Item "$MountDirectory\Windows\Servicing\Sessions\Sessions.xml" "$OSMediaPath\info\Sessions.xml" -Force | Out-Null

        [xml]$SessionsXML = Get-Content -Path "$MountDirectory\Windows\Servicing\Sessions\Sessions.xml"

        $Sessions = $SessionsXML.SelectNodes('Sessions/Session') | ForEach-Object {
            New-Object -Type PSObject -Property @{
                Id = $_.Tasks.Phase.package.id
                KBNumber = $_.Tasks.Phase.package.name
                TargetState = $_.Tasks.Phase.package.targetState
                Client = $_.Client
                Complete = $_.Complete
                Status = $_.Status
            }
        }
        
        $Sessions = $Sessions | Where-Object {$_.Id -like "Package*"}
        $Sessions = $Sessions | Select-Object -Property Id, KBNumber, TargetState, Client, Status, Complete | Sort-Object Complete -Descending

        $Sessions | Out-File "$OSMediaPath\Sessions.txt"
        $Sessions | Out-File "$OSMediaPath\info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Sessions.txt"
        $Sessions | Export-Clixml -Path "$OSMediaPath\info\xml\Sessions.xml"
        $Sessions | Export-Clixml -Path "$OSMediaPath\info\xml\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Sessions.xml"
        $Sessions | ConvertTo-Json | Out-File "$OSMediaPath\info\json\Sessions.json"
        $Sessions | ConvertTo-Json | Out-File "$OSMediaPath\info\json\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Sessions.json"
    }
    
    if (Test-Path "$OSMediaPath\Sessions.xml") {
        Remove-Item "$OSMediaPath\Sessions.xml" -Force | Out-Null
    }
}
function Save-VariablesOSD {
    [CmdletBinding()]
    Param ()
    Get-Variable | Select-Object -Property Name, Value | Export-Clixml "$Info\xml\Variables.xml"
    Get-Variable | Where-Object { $_.Value -isnot [System.Collections.Hashtable] } | Select-Object -Property Name, Value | ConvertTo-Json | Out-File "$Info\json\Variables.json"
}
function Save-WimsPE {
    [CmdletBinding()]
    Param (
        [string]$OSMediaPath
    )
    #===================================================================================================
    #   Header
    #===================================================================================================
    Show-ActionTime
    Write-Host -ForegroundColor Green "WinPE: Export WIMs to $OSMediaPath\WinPE"
    #===================================================================================================
    #   Execute
    #===================================================================================================
    Write-Verbose "OSMediaPath: $OSMediaPath"

    Write-Verbose "$OSMediaPath\WinPE\boot.wim"
    Copy-Item -Path "$OSMediaPath\OS\sources\boot.wim" -Destination "$OSMediaPath\WinPE\boot.wim" -Force

    Write-Verbose "$OSMediaPath\WinPE\winpe.wim"
    $CurrentLog = "$OSMediaPath\WinPE\info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Export-WindowsImage-WinPE.log"
    Write-Verbose "CurrentLog: $CurrentLog"
    Export-WindowsImage -SourceImagePath "$OSMediaPath\OS\sources\boot.wim" -SourceIndex 1 -DestinationImagePath "$OSMediaPath\WinPE\winpe.wim" -LogPath "$CurrentLog" | Out-Null

    Write-Verbose "$OSMediaPath\WinPE\winre.wim"
    $CurrentLog = "$OSMediaPath\WinPE\info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Export-WindowsImage-WinRE.log"
    Write-Verbose "CurrentLog: $CurrentLog"
    Export-WindowsImage -SourceImagePath "$MountDirectory\Windows\System32\Recovery\winre.wim" -SourceIndex 1 -DestinationImagePath "$OSMediaPath\WinPE\winre.wim" -LogPath "$CurrentLog" | Out-Null

    Write-Verbose "$OSMediaPath\WinPE\winse.wim"
    $CurrentLog = "$OSMediaPath\WinPE\info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Export-WindowsImage-WinSE.log"
    Write-Verbose "CurrentLog: $CurrentLog"
    Export-WindowsImage -SourceImagePath "$OSMediaPath\OS\sources\boot.wim" -SourceIndex 2 -DestinationImagePath "$OSMediaPath\WinPE\winse.wim" -LogPath "$CurrentLog" | Out-Null
}
function Save-WindowsImageContentOS {
    [CmdletBinding()]
    Param ()
    #===================================================================================================
    #   Header
    #===================================================================================================
    Show-ActionTime
    Write-Host -ForegroundColor Green "OS: Export Image Content to $Info\Get-WindowsImageContent.txt"
    #===================================================================================================
    #   Execute
    #===================================================================================================
    Get-WindowsImageContent -ImagePath "$OS\Sources\install.wim" -Index 1 | Out-File "$Info\Get-WindowsImageContent.txt"
}
function Save-WindowsImageContentPE {
    [CmdletBinding()]
    Param ()
    #===================================================================================================
    #   Header
    #===================================================================================================
    Show-ActionTime
    Write-Host -ForegroundColor Green "Export Image Content to $Info\Get-WindowsImageContent.txt"
    #===================================================================================================
    #   Execute
    #===================================================================================================
    Get-WindowsImageContent -ImagePath "$OS\Sources\boot.wim" -Index 1 | Out-File "$Info\Get-WindowsImageContent.txt"
}