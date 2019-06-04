function Export-WinPEWims {
    [CmdletBinding()]
    PARAM (
        [string]$OSMediaPath
    )
    #===================================================================================================
    #   StartTime
    #===================================================================================================
    $StartTime = Get-Date
    #===================================================================================================
    #   Header
    #===================================================================================================
    Write-Host "[$(($StartTime).ToString('yyyy-MM-dd-HHmmss'))] WinPE: Export WIMs to $OSMediaPath\WinPE" -ForegroundColor Green
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
    #===================================================================================================
    #   Duration
    #===================================================================================================
    $Duration = $(Get-Date) - $StartTime
    Write-Host "Duration: $($Duration.ToString('mm\:ss'))" -ForegroundColor DarkGray
}

function OSD-WinPE-Export {
    [CmdletBinding()]
    PARAM (
        [string]$OSMediaPath
    )
    #===================================================================================================
    #   StartTime
    #===================================================================================================
    $StartTime = Get-Date
    #===================================================================================================
    #   Header
    #===================================================================================================
    Write-Host "[$(($StartTime).ToString('yyyy-MM-dd-HHmmss'))] WinPE: Export WIMs to $OSMediaPath\WinPE" -ForegroundColor Green
    #===================================================================================================
    #   Execute
    #===================================================================================================
    $CurrentLog = "$OSMediaPath\WinPE\info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Export-WindowsImage-WinPE.log"
    Write-Verbose "CurrentLog: $CurrentLog"
    Export-WindowsImage -SourceImagePath "$OSMediaPath\WimTemp\winpe.wim" -SourceIndex 1 -DestinationImagePath "$OSMediaPath\WinPE\winpe.wim" -LogPath "$CurrentLog" | Out-Null
    
    $CurrentLog = "$OSMediaPath\WinPE\info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Export-WindowsImage-WinRE.log"
    Write-Verbose "CurrentLog: $CurrentLog"
    Export-WindowsImage -SourceImagePath "$OSMediaPath\WimTemp\winre.wim" -SourceIndex 1 -DestinationImagePath "$OSMediaPath\WinPE\winre.wim" -LogPath "$CurrentLog" | Out-Null

    $CurrentLog = "$OSMediaPath\WinPE\info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Export-WindowsImage-WinSE.log"
    Write-Verbose "CurrentLog: $CurrentLog"
    Export-WindowsImage -SourceImagePath "$OSMediaPath\WimTemp\winse.wim" -SourceIndex 1 -DestinationImagePath "$OSMediaPath\WinPE\winse.wim" -LogPath "$CurrentLog" | Out-Null
    #===================================================================================================
    #   Duration
    #===================================================================================================
    $Duration = $(Get-Date) - $StartTime
    Write-Host "Duration: $($Duration.ToString('mm\:ss'))" -ForegroundColor DarkGray
}

function OSD-WinPE-ExportBootWim {
    [CmdletBinding()]
    PARAM (
        [string]$OSMediaPath
    )
    #===================================================================================================
    #   StartTime
    #===================================================================================================
    $StartTime = Get-Date
    #===================================================================================================
    #   Header
    #===================================================================================================
    Write-Host "[$(($StartTime).ToString('yyyy-MM-dd-HHmmss'))] WinPE: Rebuild $OSMediaPath\OS\sources\boot.wim" -ForegroundColor Green
    #===================================================================================================
    #   Execute
    #===================================================================================================
    $CurrentLog = "$OSMediaPath\WinPE\info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Export-WindowsImage-WinPE.log"
    Write-Verbose "CurrentLog: $CurrentLog"
    Export-WindowsImage -SourceImagePath "$OSMediaPath\WimTemp\winpe.wim" -SourceIndex 1 -DestinationImagePath "$OSMediaPath\WinPE\boot.wim" -LogPath "$CurrentLog" | Out-Null
    
    $CurrentLog = "$OSMediaPath\WinPE\info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Export-WindowsImage-WinSE.log"
    Write-Verbose "CurrentLog: $CurrentLog"
    Export-WindowsImage -SourceImagePath "$OSMediaPath\WimTemp\winse.wim" -SourceIndex 1 -DestinationImagePath "$OSMediaPath\WinPE\boot.wim" -Setbootable -LogPath "$CurrentLog" | Out-Null
    Copy-Item -Path "$OSMediaPath\WinPE\boot.wim" -Destination "$OSMediaPath\OS\sources\boot.wim" -Force | Out-Null
    #===================================================================================================
    #   Duration
    #===================================================================================================
    $Duration = $(Get-Date) - $StartTime
    Write-Host "Duration: $($Duration.ToString('mm\:ss'))" -ForegroundColor DarkGray
}
function OSD-Export-WindowsImageContent {
    [CmdletBinding()]
    PARAM ()
    #===================================================================================================
    #   StartTime
    #===================================================================================================
    $StartTime = Get-Date
    #===================================================================================================
    #   Header
    #===================================================================================================
    Write-Host "[$(($StartTime).ToString('yyyy-MM-dd-HHmmss'))] Install.wim: Export Image Content to $Info\Get-WindowsImageContent.txt" -ForegroundColor Green
    #===================================================================================================
    #   Execute
    #===================================================================================================
    Get-WindowsImageContent -ImagePath "$OS\Sources\install.wim" -Index 1 | Out-File "$Info\Get-WindowsImageContent.txt"
    #===================================================================================================
    #   Duration
    #===================================================================================================
    $Duration = $(Get-Date) - $StartTime
    Write-Host "Duration: $($Duration.ToString('mm\:ss'))" -ForegroundColor DarkGray
}

function OSD-Export-WindowsImageContentPE {
    [CmdletBinding()]
    PARAM ()
    #===================================================================================================
    #   StartTime
    #===================================================================================================
    $StartTime = Get-Date
    #===================================================================================================
    #   Header
    #===================================================================================================
    Write-Host "[$(($StartTime).ToString('yyyy-MM-dd-HHmmss'))] Export Image Content to $Info\Get-WindowsImageContent.txt" -ForegroundColor Green
    #===================================================================================================
    #   Execute
    #===================================================================================================
    Get-WindowsImageContent -ImagePath "$OS\Sources\boot.wim" -Index 1 | Out-File "$Info\Get-WindowsImageContent.txt"
    #===================================================================================================
    #   Duration
    #===================================================================================================
    $Duration = $(Get-Date) - $StartTime
    Write-Host "Duration: $($Duration.ToString('mm\:ss'))" -ForegroundColor DarkGray
}

function OSD-Export-Variables {
    [CmdletBinding()]
    PARAM ()
    Get-Variable | Select-Object -Property Name, Value | Export-Clixml "$Info\xml\Variables.xml"
    Get-Variable | Select-Object -Property Name, Value | ConvertTo-Json | Out-File "$Info\json\Variables.json"
}

function Export-InstallWim {
    [CmdletBinding()]
    PARAM ()
    #===================================================================================================
    #   StartTime
    #===================================================================================================
    $StartTime = Get-Date
    #===================================================================================================
    #   Header
    #===================================================================================================
    Write-Host "[$(($StartTime).ToString('yyyy-MM-dd-HHmmss'))] Install.wim: Export to $OS\sources\install.wim" -ForegroundColor Green
    #===================================================================================================
    #   Execute
    #===================================================================================================
    $CurrentLog = "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Export-WindowsImage.log"
    Write-Verbose "CurrentLog: $CurrentLog"
    Export-WindowsImage -SourceImagePath "$WimTemp\install.wim" -SourceIndex 1 -DestinationImagePath "$OS\sources\install.wim" -LogPath "$CurrentLog" | Out-Null
    #===================================================================================================
    #   Duration
    #===================================================================================================
    $Duration = $(Get-Date) - $StartTime
    Write-Host "Duration: $($Duration.ToString('mm\:ss'))" -ForegroundColor DarkGray
}