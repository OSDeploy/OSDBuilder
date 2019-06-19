$Updates = @()
$Updates = Import-Clixml "$PSScriptRoot\Windows 10.xml" | Sort CreationDate -Descending | Out-GridView -PassThru
$Updates | Sort CreationDate -Descending | Export-Clixml "$PSScriptRoot\Windows 10 B.xml"