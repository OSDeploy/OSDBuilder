function OSD-Scripts {
    [CmdletBinding()]
    PARAM ()
    Write-Host '========================================================================================' -ForegroundColor DarkGray
    Write-Host "Install.wim: Task Scripts" -ForegroundColor Green
    if ($Scripts) {
        foreach ($Script in $Scripts) {
            if (Test-Path "$OSDBuilderContent\$Script") {
                Write-Host "PowerShell Script: $OSDBuilderContent\$Script" -ForegroundColor Green
                Invoke-Expression "& '$OSDBuilderContent\$Script'"
            }
        }
    } else {
        Write-Host "No Task Scripts were processed" -ForegroundColor DarkGray
    }
    
    Write-Host '========================================================================================' -ForegroundColor DarkGray
    Write-Host "Install.wim: Template Scripts" -ForegroundColor Green
    if ($ScriptTemplates) {
        foreach ($Script in $ScriptTemplates) {
            Write-Host "$($Script.FullName)" -ForegroundColor DarkGray
            if (Test-Path "$($Script.FullName)") {
                Write-Host "PowerShell Script: $($Script.FullName)" -ForegroundColor Green
                Invoke-Expression "& '$($Script.FullName)'"
            }
        }
    } else {
        Write-Host "No Template Scripts were processed" -ForegroundColor DarkGray
    }
}