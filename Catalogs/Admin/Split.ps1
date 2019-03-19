$updates = @()
$updates = Import-Clixml "C:\Users\David\Documents\WindowsPowerShell\Modules\OSDBuilder\19.3.12.0\Catalogs\Windows Server 2012 R2 Core.xml" | Out-GridView -PassThru
$updates | Export-Clixml "C:\Users\David\Documents\WindowsPowerShell\Modules\OSDBuilder\19.3.12.0\Catalogs\Windows Server 2012 R2 Core2.xml"