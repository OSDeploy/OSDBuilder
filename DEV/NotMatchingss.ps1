$Catalog = @()
$Catalog += Import-Clixml "$PSScriptRoot\Windows\Windows 10.xml"
$Catalog += Import-Clixml "$PSScriptRoot\Windows\Windows 10 1903.xml"
$Catalog += Import-Clixml "$PSScriptRoot\Windows\Windows Server 2016.xml"
$Catalog += Import-Clixml "$PSScriptRoot\Windows\Windows Server 2019.xml"
$Catalog += Import-Clixml "$PSScriptRoot\Win7\Windows 7.xml"
$Catalog += Import-Clixml "$PSScriptRoot\Windows\Windows Server 2012 R2.xml"

$CatalogErrors = @()
$CatalogCorrections = @()

foreach ($item in $Catalog) {
    if ($($item.FileName) -notlike "*$($item.KBNumber)*") {   
        $CatalogErrors += $item
    }

    $pattern = 'KB(\d{4,6})'
    $FileKBNumber = [regex]::matches($item.FileName, $pattern).Value
    $TitleKBNumber = [regex]::matches($item.FileName, $pattern).Value


}
$CatalogErrors | Out-GridView