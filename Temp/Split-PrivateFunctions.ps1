$ModuleFile = "D:\GitHub\Modules\OSDBuilder\Private\OSDBuilderPrivate.ps1" # path to your PSM1 file
$ExportPath = "D:\GitHub\Modules\OSDBuilder\Split" # path where to export functions into separate PS1 files. Skip the trailing \
$AST = [System.Management.Automation.Language.Parser]::ParseFile(
    $ModuleFile,
    [ref]$null,
    [ref]$Null
)

$AST.FindAll({
    $args[0] -is [System.Management.Automation.Language.FunctionDefinitionAst]}
    , $true) | foreach {
    $_.Extent.Text | Out-File -Append "$ExportPath\$($_.name).ps1"
}

Return
Get-ChildItem D:\GitHub\Modules\OSDBuilder\Split\*.ps1 | Get-Content | Add-Content "D:\GitHub\Modules\OSDBuilder\Private\AllFunctions.ps1"