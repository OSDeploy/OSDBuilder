$AllOSDUpdates = @()
$AllUpdateCatalogs = Get-ChildItem -Path "$PSScriptRoot\*" -Include 'Windows 10 1809.xml','Windows 10 1903.xml'
foreach ($UpdateCatalog in $AllUpdateCatalogs) {$AllOSDUpdates += Import-Clixml -Path "$($UpdateCatalog.FullName)"}

$AllOSDUpdates = $AllOSDUpdates | Sort-Object CreationDate -Descending
$AllOSDUpdates | Export-Clixml "$PSScriptRoot\Windows 10.xml"
