$susupdates = @()
$xmls = Get-ChildItem "C:\Users\David\Documents\WindowsPowerShell\Modules\OSDBuilder\19.3.8.0\Catalogs\Merge" *.xml
foreach ($xml in $xmls) {
    $susupdates += Import-Clixml $($xml.FullName)
}
$susupdates = $susupdates | Sort-Object -Property CreationDate | Out-GridView -PassThru
$susupdates | Export-Clixml "C:\Users\David\Documents\WindowsPowerShell\Modules\OSDBuilder\19.3.8.0\Catalogs\Windows Server 2012 R2 $(Get-Random).xml"