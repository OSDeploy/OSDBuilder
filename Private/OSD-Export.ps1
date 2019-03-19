function OSD-Export-WindowsImageContent {
    [CmdletBinding()]
    PARAM ()
    Write-Host "Install.wim: Export Image Content to $Info\Get-WindowsImageContent.txt" -ForegroundColor Green
    Get-WindowsImageContent -ImagePath "$OS\Sources\install.wim" -Index 1 | Out-File "$Info\Get-WindowsImageContent.txt"
}

function OSD-Export-WindowsImageContentPE {
    [CmdletBinding()]
    PARAM ()
    Write-Host "Export Image Content to $Info\Get-WindowsImageContent.txt" -ForegroundColor Green
    Get-WindowsImageContent -ImagePath "$OS\Sources\boot.wim" -Index 1 | Out-File "$Info\Get-WindowsImageContent.txt"
}

function OSD-Export-Variables {
    [CmdletBinding()]
    PARAM ()
    Get-Variable | Select-Object -Property Name, Value | Export-Clixml "$Info\xml\Variables.xml"
    Get-Variable | Select-Object -Property Name, Value | ConvertTo-Json | Out-File "$Info\json\Variables.json"
}

