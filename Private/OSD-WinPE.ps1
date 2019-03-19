function OSD-WinPE-ExportWims {
    [CmdletBinding()]
    PARAM (
        [string]$OSMediaPath
    )
    Write-Host "WinPE: Export WIMs to $OSMediaPath\WinPE" -ForegroundColor Green
    Write-Verbose "OSMediaPath: $OSMediaPath"

    Write-Verbose "$OSMediaPath\WinPE\boot.wim"
    Copy-Item -Path "$OSMediaPath\OS\sources\boot.wim" -Destination "$OSMediaPath\WinPE\boot.wim" -Force

    Write-Verbose "$OSMediaPath\WinPE\winpe.wim"
    $CurrentLog = "$OSMediaPath\WinPE\info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Export-WindowsImage-WinPE.log"
    Write-Verbose "$CurrentLog"
    Export-WindowsImage -SourceImagePath "$OSMediaPath\OS\sources\boot.wim" -SourceIndex 1 -DestinationImagePath "$OSMediaPath\WinPE\winpe.wim" -LogPath "$CurrentLog" | Out-Null

    Write-Verbose "$OSMediaPath\WinPE\winre.wim"
    $CurrentLog = "$OSMediaPath\WinPE\info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Export-WindowsImage-WinRE.log"
    Write-Verbose "$CurrentLog"
    Export-WindowsImage -SourceImagePath "$MountDirectory\Windows\System32\Recovery\winre.wim" -SourceIndex 1 -DestinationImagePath "$OSMediaPath\WinPE\winre.wim" -LogPath "$CurrentLog" | Out-Null

    Write-Verbose "$OSMediaPath\WinPE\winse.wim"
    $CurrentLog = "$OSMediaPath\WinPE\info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Export-WindowsImage-WinSE.log"
    Write-Verbose "$CurrentLog"
    Export-WindowsImage -SourceImagePath "$OSMediaPath\OS\sources\boot.wim" -SourceIndex 2 -DestinationImagePath "$OSMediaPath\WinPE\winse.wim" -LogPath "$CurrentLog" | Out-Null
}

function OSD-WinPE-Mount {
    [CmdletBinding()]
    PARAM (
        [string]$OSMediaPath
    )
    #===================================================================================================
    Write-Verbose '19.1.1 Mount WinPE'
    #===================================================================================================
    Write-Host '========================================================================================' -ForegroundColor DarkGray

    Write-Host "WinPE: Mount WIMs" -ForegroundColor Green
    Write-Verbose '========== OSD-WinPE-Mount'
    Write-Verbose "OSMediaPath: $OSMediaPath"
    Write-Verbose "MountWinPE: $MountWinPE"
    Write-Verbose "MountWinRE: $MountWinRE"
    Write-Verbose "MountWinSE: $MountWinSE"

    Write-Verbose "$MountWinPE"
    $CurrentLog = "$OSMediaPath\WinPE\info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Mount-WindowsImage-WinPE.log"
    Write-Verbose "$CurrentLog"
    Mount-WindowsImage -ImagePath "$OSMediaPath\WimTemp\winpe.wim" -Index 1 -Path "$MountWinPE" -LogPath "$CurrentLog" | Out-Null

    Write-Verbose "$MountWinRE"
    $CurrentLog = "$OSMediaPath\WinPE\info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Mount-WindowsImage-WinRE.log"
    Write-Verbose "$CurrentLog"
    Mount-WindowsImage -ImagePath "$OSMediaPath\WimTemp\winre.wim" -Index 1 -Path "$MountWinRE" -LogPath "$CurrentLog" | Out-Null
	
    Write-Verbose "$MountWinSE"
    $CurrentLog = "$OSMediaPath\WinPE\info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Mount-WindowsImage-WinSE.log"
    Write-Verbose "$CurrentLog"
    Mount-WindowsImage -ImagePath "$OSMediaPath\WimTemp\winse.wim" -Index 1 -Path "$MountWinSE" -LogPath "$CurrentLog" | Out-Null
}

function OSD-WinPE-Sources {
    [CmdletBinding()]
    PARAM (
        [string]$OSMediaPath
    )
    #===================================================================================================
    Write-Verbose '19.1.1 OSD-WinPE-Sources'
    #===================================================================================================
    Write-Host '========================================================================================' -ForegroundColor DarkGray

    Write-Host "Media: Update Sources with WinSE.wim" -ForegroundColor Green
    Write-Verbose '========== OSD-WinPE-Sources'
    Write-Verbose "OSMediaPath: $OSMediaPath"
    Write-Verbose "MountWinSE: $MountWinSE"

    robocopy "$MountWinSE\sources" "$OSMediaPath\OS\sources" setup.exe /ndl /xo /xx /xl /b /np /ts /tee /r:0 /w:0 /Log+:"$OSMediaPath\info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Robocopy-WinSE-MediaSources.log" | Out-Null
    robocopy "$MountWinSE\sources" "$OSMediaPath\OS\sources" setuphost.exe /ndl /xo /xx /xl /b /np /ts /tee /r:0 /w:0 /Log+:"$OSMediaPath\info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Robocopy-WinSE-MediaSources.log" | Out-Null
}

function OSD-WinPE-PackageInventory {
    [CmdletBinding()]
    PARAM (
        [string]$OSMediaPath
    )
    #===================================================================================================
    Write-Verbose '19.1.1 OSD-WinPE-PackageInventory'
    #===================================================================================================
    #Write-Host '========================================================================================' -ForegroundColor DarkGray

    Write-Host "WinPE: Export Package Inventory to $OSMediaPath\WinPE\info" -ForegroundColor Green
    Write-Verbose '========== OSD-WinPE-PackageInventory'
    Write-Verbose "OSMediaPath: $OSMediaPath"
    Write-Verbose "MountWinPE: $MountWinPE"
    Write-Verbose "MountWinRE: $MountWinRE"
    Write-Verbose "MountWinSE: $MountWinSE"

    #===================================================================================================
    Write-Verbose 'Get-WindowsPackage WinPE'
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

function OSD-WinPE-Dismount {
    [CmdletBinding()]
    PARAM (
        [string]$OSMediaPath
    )
    #===================================================================================================
    Write-Verbose '19.1.1 OSD-WinPE-Dismount'
    #===================================================================================================

    Write-Host "WinPE: Dismount and Save" -ForegroundColor Green
    Write-Verbose '========== OSD-WinPE-Dismount'
    Write-Verbose "OSMediaPath: $OSMediaPath"
    
    Write-Verbose "$MountWinPE"
    $CurrentLog = "$OSMediaPath\WinPE\info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Dismount-WindowsImage-WinPE.log"
    Write-Verbose "$CurrentLog"
    Dismount-WindowsImage -Path "$MountWinPE" -Save -LogPath "$CurrentLog" | Out-Null
    
    Write-Verbose "$MountWinRE"
    $CurrentLog = "$OSMediaPath\WinPE\info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Dismount-WindowsImage-WinRE.log"
    Write-Verbose "$CurrentLog"
    Dismount-WindowsImage -Path "$MountWinRE" -Save -LogPath "$CurrentLog" | Out-Null
    
    Write-Verbose "$MountWinSE"
    $CurrentLog = "$OSMediaPath\WinPE\info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Dismount-WindowsImage-WinSE.log"
    Write-Verbose "$CurrentLog"
    Dismount-WindowsImage -Path "$MountWinSE" -Save -LogPath "$CurrentLog" | Out-Null
}

function OSD-WinPE-Export {
    [CmdletBinding()]
    PARAM (
        [string]$OSMediaPath
    )
    #===================================================================================================
    Write-Verbose '19.1.1 OSD-WinPE-Export'
    #===================================================================================================

    Write-Host "WinPE: Export WIMs to $OSMediaPath\WinPE" -ForegroundColor Green
    Write-Verbose '========== OSD-WinPE-Export'
    Write-Verbose "OSMediaPath: $OSMediaPath"
    
    $CurrentLog = "$OSMediaPath\WinPE\info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Export-WindowsImage-WinPE.log"
    Write-Verbose "$CurrentLog"
    Export-WindowsImage -SourceImagePath "$OSMediaPath\WimTemp\winpe.wim" -SourceIndex 1 -DestinationImagePath "$OSMediaPath\WinPE\winpe.wim" -LogPath "$CurrentLog" | Out-Null
    
    $CurrentLog = "$OSMediaPath\WinPE\info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Export-WindowsImage-WinRE.log"
    Write-Verbose "$CurrentLog"
    Export-WindowsImage -SourceImagePath "$OSMediaPath\WimTemp\winre.wim" -SourceIndex 1 -DestinationImagePath "$OSMediaPath\WinPE\winre.wim" -LogPath "$CurrentLog" | Out-Null

    $CurrentLog = "$OSMediaPath\WinPE\info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Export-WindowsImage-WinSE.log"
    Write-Verbose "$CurrentLog"
    Export-WindowsImage -SourceImagePath "$OSMediaPath\WimTemp\winse.wim" -SourceIndex 1 -DestinationImagePath "$OSMediaPath\WinPE\winse.wim" -LogPath "$CurrentLog" | Out-Null
}

function OSD-WinPE-ExportBootWim {
    [CmdletBinding()]
    PARAM (
        [string]$OSMediaPath
    )
    #===================================================================================================
    Write-Verbose '19.1.1 OSD-WinPE-ExportBootWim'
    #===================================================================================================

    Write-Host "WinPE: Rebuild $OSMediaPath\OS\sources\boot.wim" -ForegroundColor Green
    Write-Verbose '========== OSD-WinPE-ExportBootWim'
    Write-Verbose "OSMediaPath: $OSMediaPath"

    $CurrentLog = "$OSMediaPath\WinPE\info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Export-WindowsImage-WinPE.log"
    Write-Verbose "$CurrentLog"
    Export-WindowsImage -SourceImagePath "$OSMediaPath\WimTemp\winpe.wim" -SourceIndex 1 -DestinationImagePath "$OSMediaPath\WinPE\boot.wim" -LogPath "$CurrentLog" | Out-Null
    
    $CurrentLog = "$OSMediaPath\WinPE\info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Export-WindowsImage-WinSE.log"
    Write-Verbose "$CurrentLog"
    Export-WindowsImage -SourceImagePath "$OSMediaPath\WimTemp\winse.wim" -SourceIndex 1 -DestinationImagePath "$OSMediaPath\WinPE\boot.wim" -Setbootable -LogPath "$CurrentLog" | Out-Null
	
    Copy-Item -Path "$OSMediaPath\WinPE\boot.wim" -Destination "$OSMediaPath\OS\sources\boot.wim" -Force | Out-Null
}

function OSD-WinPE-ExportInventory {
    [CmdletBinding()]
    PARAM (
        [string]$OSMediaPath
    )
    #===================================================================================================
    Write-Verbose '19.1.1 OSD-WinPE-ExportInventory'
    #===================================================================================================
    Write-Host "WinPE: Export WIM Inventory to $OSMediaPath\WinPE\info" -ForegroundColor Green
    Write-Verbose 'OSD-WinPE-ExportInventory'
    Write-Verbose "OSMediaPath: $OSMediaPath"

    #===================================================================================================
    Write-Verbose 'Get-WindowsImage Boot.wim'
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
function OSD-WinPE-DaRT {
    [CmdletBinding()]
    PARAM ()
    #===================================================================================================
    Write-Verbose '19.1.1 WinPE DaRT'
    #   OSBuild Only
    #===================================================================================================
    Write-Host '========================================================================================' -ForegroundColor DarkGray
    Write-Host "WinPE: Microsoft DaRT" -ForegroundColor Green
    if ([string]::IsNullOrEmpty($WinPEDaRT) -or [string]::IsNullOrWhiteSpace($WinPEDaRT)) {Write-Warning "Skipping WinPE DaRT"}
    elseif (Test-Path "$OSDBuilderContent\$WinPEDaRT") {
        #===================================================================================================
        Write-Host "WinPE: WinPE.wim Microsoft DaRT $OSDBuilderContent\$WinPEDaRT" -ForegroundColor Green
        expand.exe "$OSDBuilderContent\$WinPEDaRT" -F:*.* "$MountWinPE"
        if (Test-Path "$MountWinPE\Windows\System32\winpeshl.ini") {Remove-Item -Path "$MountWinPE\Windows\System32\winpeshl.ini" -Force}
        #===================================================================================================
        Write-Host "WinPE: WinRE.wim Microsoft DaRT $OSDBuilderContent\$WinPEDaRT" -ForegroundColor Green
        expand.exe "$OSDBuilderContent\$WinPEDaRT" -F:*.* "$MountWinRE"
        (Get-Content "$MountWinRE\Windows\System32\winpeshl.ini") | ForEach-Object {$_ -replace '-prompt','-network'} | Out-File "$MountWinRE\Windows\System32\winpeshl.ini"
        #===================================================================================================
        Write-Host "WinPE: WinSE.wim Microsoft DaRT $OSDBuilderContent\$WinPEDaRT" -ForegroundColor Green
        expand.exe "$OSDBuilderContent\$WinPEDaRT" -F:*.* "$MountWinSE"
        if (Test-Path "$MountWinSE\Windows\System32\winpeshl.ini") {Remove-Item -Path "$MountWinSE\Windows\System32\winpeshl.ini" -Force}
        
        if (Test-Path $(Join-Path $(Split-Path "$OSDBuilderContent\$WinPEDart") 'DartConfig.dat')) {
            Copy-Item -Path $(Join-Path $(Split-Path "$OSDBuilderContent\$WinPEDart") 'DartConfig.dat') -Destination "$MountWinPE\Windows\System32\DartConfig.dat" -Force | Out-Null
            Copy-Item -Path $(Join-Path $(Split-Path "$OSDBuilderContent\$WinPEDart") 'DartConfig.dat') -Destination "$MountWinSE\Windows\System32\DartConfig.dat" -Force | Out-Null
            Copy-Item -Path $(Join-Path $(Split-Path "$OSDBuilderContent\$WinPEDart") 'DartConfig.dat') -Destination "$MountWinRE\Windows\System32\DartConfig.dat" -Force | Out-Null
        } elseif (Test-Path $(Join-Path $(Split-Path $WinPEDart) 'DartConfig8.dat')) {
            Copy-Item -Path $(Join-Path $(Split-Path "$OSDBuilderContent\$WinPEDart") 'DartConfig8.dat') -Destination "$MountWinSE\Windows\System32\DartConfig.dat" -Force | Out-Null
            Copy-Item -Path $(Join-Path $(Split-Path "$OSDBuilderContent\$WinPEDart") 'DartConfig8.dat') -Destination "$MountWinPE\Windows\System32\DartConfig.dat" -Force | Out-Null
            Copy-Item -Path $(Join-Path $(Split-Path "$OSDBuilderContent\$WinPEDart") 'DartConfig8.dat') -Destination "$MountWinRE\Windows\System32\DartConfig.dat" -Force | Out-Null
        }
        #===================================================================================================
    } else {Write-Warning "WinPE DaRT do not exist in $OSDBuilderContent\$WinPEDart"}
}
function OSD-WinPE-AutoExtraFiles {
    [CmdletBinding()]
    PARAM ()
    #===================================================================================================
    Write-Verbose '19.1.28 Auto Extra Files'
    #===================================================================================================
    Write-Host '========================================================================================' -ForegroundColor DarkGray
    Write-Host "WinPE: Auto ExtraFiles" -ForegroundColor Green
    Write-Host "$WinPE\AutoExtraFiles" -ForegroundColor DarkGray
    $CurrentLog = "$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-AutoExtraFiles.log"

    robocopy "$WinPE\AutoExtraFiles" "$MountWinPE" *.* /e /ndl /xf bcp47*.dll /xx /b /np /ts /tee /r:0 /w:0 /Log+:"$CurrentLog" | Out-Null
    robocopy "$WinPE\AutoExtraFiles" "$MountWinRE" *.* /e /ndl /xf bcp47*.dll /xx /b /np /ts /tee /r:0 /w:0 /Log+:"$CurrentLog" | Out-Null
    robocopy "$WinPE\AutoExtraFiles" "$MountWinSE" *.* /e /ndl /xf bcp47*.dll /xx /b /np /ts /tee /r:0 /w:0 /Log+:"$CurrentLog" | Out-Null
}

function OSD-WinPE-ExtraFiles {
    [CmdletBinding()]
    PARAM ()
    Write-Host '========================================================================================' -ForegroundColor DarkGray
    Write-Host "WinPE: WinPE.wim Extra Files" -ForegroundColor Green
    foreach ($ExtraFile in $WinPEExtraFilesPE) {
        Write-Host "$OSDBuilderContent\$ExtraFile" -ForegroundColor DarkGray
        robocopy "$OSDBuilderContent\$ExtraFile" "$MountWinPE" *.* /e /ndl /xx /b /np /ts /tee /r:0 /w:0 /Log+:"$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-ExtraFiles-WinPE.log" | Out-Null
    }
    Write-Host "WinPE: WinRE.wim Extra Files" -ForegroundColor Green
    foreach ($ExtraFile in $WinPEExtraFilesRE) {
        Write-Host "$OSDBuilderContent\$ExtraFile" -ForegroundColor DarkGray
        robocopy "$OSDBuilderContent\$ExtraFile" "$MountWinRE" *.* /e /ndl /xx /b /np /ts /tee /r:0 /w:0 /Log+:"$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-ExtraFiles-WinRE.log" | Out-Null
    }
    Write-Host "WinPE: WinSE.wim Extra Files" -ForegroundColor Green
    foreach ($ExtraFile in $WinPEExtraFilesSE) {
        Write-Host "$OSDBuilderContent\$ExtraFile" -ForegroundColor DarkGray
        robocopy "$OSDBuilderContent\$ExtraFile" "$MountWinSE" *.* /e /ndl /xx /b /np /ts /tee /r:0 /w:0 /Log+:"$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-ExtraFiles-WinSE.log" | Out-Null
    }
}

function OSD-WinPE-ADK {
    [CmdletBinding()]
    PARAM ()
    #===================================================================================================
    Write-Verbose '19.1.1 WinPE WIM ADK Optional Components'
    #   OSBuild Only
    #===================================================================================================
    Write-Host '========================================================================================' -ForegroundColor DarkGray
    Write-Host "WinPE: WinPE.wim ADK Optional Components" -ForegroundColor Green
    if ([string]::IsNullOrEmpty($WinPEADKPE) -or [string]::IsNullOrWhiteSpace($WinPEADKPE)) {
        # Do Nothing
    } else {
        foreach ($PackagePath in $WinPEADKPE) {
            if ($PackagePath -like "*WinPE-NetFx*") {
                Write-Host "$OSDBuilderContent\$PackagePath" -ForegroundColor DarkGray
                Add-WindowsPackage -PackagePath "$OSDBuilderContent\$PackagePath" -Path "$MountWinPE" -LogPath "$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Add-WindowsPackage-WinPE.log" | Out-Null
            }
        }
        $WinPEADKPE = $WinPEADKPE | Where-Object {$_.Name -notlike "*WinPE-NetFx*"}
        foreach ($PackagePath in $WinPEADKPE) {
            if ($PackagePath -like "*WinPE-PowerShell*") {
                Write-Host "$OSDBuilderContent\$PackagePath" -ForegroundColor DarkGray
                Add-WindowsPackage -PackagePath "$OSDBuilderContent\$PackagePath" -Path "$MountWinPE" -LogPath "$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Add-WindowsPackage-WinPE.log" | Out-Null
            }
        }
        $WinPEADKPE = $WinPEADKPE | Where-Object {$_.Name -notlike "*WinPE-PowerShell*"}
        foreach ($PackagePath in $WinPEADKPE) {
            Write-Host "$OSDBuilderContent\$PackagePath" -ForegroundColor DarkGray
            if ($OSMajorVersion -eq 6) {
                dism /Image:"$MountWinPE" /Add-Package /PackagePath:"$OSDBuilderContent\$PackagePath" /LogPath:"$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-DISM-Add-WindowsPackage-WinPE.log"
            } else {
                Add-WindowsPackage -PackagePath "$OSDBuilderContent\$PackagePath" -Path "$MountWinPE" -LogPath "$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Add-WindowsPackage-WinPE.log" | Out-Null
            }
        }
    }
    #===================================================================================================
    Write-Verbose '19.1.1 WinRE WIM ADK Optional Components'
    #   OSBuild Only
    #===================================================================================================
    #Write-Host '========================================================================================' -ForegroundColor DarkGray
    Write-Host "WinPE: WinRE.wim ADK Optional Components" -ForegroundColor Green
    if ([string]::IsNullOrEmpty($WinPEADKRE) -or [string]::IsNullOrWhiteSpace($WinPEADKRE)) {
        # Do Nothing
    } else {
        foreach ($PackagePath in $WinPEADKRE) {
            if ($PackagePath -like "*WinPE-NetFx*") {
                Write-Host "$OSDBuilderContent\$PackagePath" -ForegroundColor DarkGray
                Add-WindowsPackage -PackagePath "$OSDBuilderContent\$PackagePath" -Path "$MountWinRE" -LogPath "$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Add-WindowsPackage-WinRE.log" | Out-Null
            }
        }
        $WinPEADKRE = $WinPEADKRE | Where-Object {$_.Name -notlike "*WinPE-NetFx*"}
        foreach ($PackagePath in $WinPEADKRE) {
            if ($PackagePath -like "*WinPE-PowerShell*") {
                Write-Host "$OSDBuilderContent\$PackagePath" -ForegroundColor DarkGray
                Add-WindowsPackage -PackagePath "$OSDBuilderContent\$PackagePath" -Path "$MountWinRE" -LogPath "$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Add-WindowsPackage-WinRE.log" | Out-Null
            }
        }
        $WinPEADKRE = $WinPEADKRE | Where-Object {$_.Name -notlike "*WinPE-PowerShell*"}
        foreach ($PackagePath in $WinPEADKRE) {
            Write-Host "$OSDBuilderContent\$PackagePath" -ForegroundColor DarkGray
            if ($OSMajorVersion -eq 6) {
                dism /Image:"$MountWinRE" /Add-Package /PackagePath:"$OSDBuilderContent\$PackagePath" /LogPath:"$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-DISM-Add-WindowsPackage-WinRE.log"
            } else {
                Add-WindowsPackage -PackagePath "$OSDBuilderContent\$PackagePath" -Path "$MountWinRE" -LogPath "$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Add-WindowsPackage-WinRE.log" | Out-Null
            }
        }
    }
    #===================================================================================================
    Write-Verbose '19.1.1 Setup WIM ADK Optional Components'
    #   OSBuild Only
    #===================================================================================================
    #Write-Host '========================================================================================' -ForegroundColor DarkGray
    Write-Host "WinPE: WinSE.wim ADK Optional Components" -ForegroundColor Green
    if ([string]::IsNullOrEmpty($WinPEADKSE) -or [string]::IsNullOrWhiteSpace($WinPEADKSE)) {
        # Do Nothing
    } else {
        foreach ($PackagePath in $WinPEADKSE) {
            if ($PackagePath -like "*WinPE-NetFx*") {
                Write-Host "$OSDBuilderContent\$PackagePath" -ForegroundColor DarkGray
                Add-WindowsPackage -PackagePath "$OSDBuilderContent\$PackagePath" -Path "$MountWinSE" -LogPath "$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Add-WindowsPackage-WinSE.log" | Out-Null
            }
        }
        $WinPEADKSE = $WinPEADKSE | Where-Object {$_.Name -notlike "*WinPE-NetFx*"}
        foreach ($PackagePath in $WinPEADKSE) {
            if ($PackagePath -like "*WinPE-PowerShell*") {
                Write-Host "$OSDBuilderContent\$PackagePath" -ForegroundColor DarkGray
                Add-WindowsPackage -PackagePath "$OSDBuilderContent\$PackagePath" -Path "$MountWinSE" -LogPath "$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Add-WindowsPackage-WinSE.log" | Out-Null
            }
        }
        $WinPEADKSE = $WinPEADKSE | Where-Object {$_.Name -notlike "*WinPE-PowerShell*"}
        foreach ($PackagePath in $WinPEADKSE) {
            Write-Host "$OSDBuilderContent\$PackagePath" -ForegroundColor DarkGray
            if ($OSMajorVersion -eq 6) {
                dism /Image:"$MountWinSE" /Add-Package /PackagePath:"$OSDBuilderContent\$PackagePath" /LogPath:"$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-DISM-Add-WindowsPackage-WinSE.log"
            } else {
                Add-WindowsPackage -PackagePath "$OSDBuilderContent\$PackagePath" -Path "$MountWinSE" -LogPath "$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Add-WindowsPackage-WinSE.log" | Out-Null
            }
        }
    }
}

function OSD-WinPE-Scripts {
    [CmdletBinding()]
    PARAM ()
    #===================================================================================================
    #   Write-Verbose '19.1.16 PowerShell Scripts'
    #   OSBuild Only
    #===================================================================================================
    Write-Host '========================================================================================' -ForegroundColor DarkGray
    Write-Host "WinPE: WinPE.wim PowerShell Scripts" -ForegroundColor Green
    foreach ($PSWimScript in $WinPEScriptsPE) {
        if (Test-Path "$OSDBuilderContent\$PSWimScript") {
            Write-Host "PowerShell Script: $OSDBuilderContent\$PSWimScript" -ForegroundColor DarkGray
            (Get-Content "$OSDBuilderContent\$PSWimScript").replace('winpe.wim.log', 'WinPE.log') | Set-Content "$OSDBuilderContent\$PSWimScript"
            Invoke-Expression "& '$OSDBuilderContent\$PSWimScript'"
        }
    }
    Write-Host "WinPE: WinRE.wim PowerShell Scripts" -ForegroundColor Green
    foreach ($PSWimScript in $WinPEScriptsRE) {
        if (Test-Path "$OSDBuilderContent\$PSWimScript") {
            Write-Host "PowerShell Script: $OSDBuilderContent\$PSWimScript" -ForegroundColor DarkGray
            (Get-Content "$OSDBuilderContent\$PSWimScript").replace('winre.wim.log', 'WinRE.log') | Set-Content "$OSDBuilderContent\$PSWimScript"
            Invoke-Expression "& '$OSDBuilderContent\$PSWimScript'"
        }
    }
    Write-Host "WinPE: WinSE.wim PowerShell Scripts" -ForegroundColor Green
    foreach ($PSWimScript in $WinPEScriptsSE) {
        if (Test-Path "$OSDBuilderContent\$PSWimScript") {
            Write-Host "PowerShell Script: $OSDBuilderContent\$PSWimScript" -ForegroundColor DarkGray
            (Get-Content "$OSDBuilderContent\$PSWimScript").replace('MountSetup', 'MountWinSE') | Set-Content "$OSDBuilderContent\$PSWimScript"
            (Get-Content "$OSDBuilderContent\$PSWimScript").replace('setup.wim.log', 'WinSE.log') | Set-Content "$OSDBuilderContent\$PSWimScript"
            Invoke-Expression "& '$OSDBuilderContent\$PSWimScript'"
        }
    }
}