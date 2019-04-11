function OSD-ExtraFiles {
    [CmdletBinding()]
    PARAM ()
    Write-Host '========================================================================================' -ForegroundColor DarkGray
    Write-Host "Install.wim: Task Extra Files"	-ForegroundColor Green
    if ($ExtraFiles) {
        foreach ($ExtraFile in $ExtraFiles) {
            Write-Host "$OSDBuilderContent\$ExtraFile" -ForegroundColor DarkGray
            robocopy "$OSDBuilderContent\$ExtraFile" "$MountDirectory" *.* /e /ndl /xx /b /np /ts /tee /r:0 /w:0 /Log+:"$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Task-ExtraFiles.log" | Out-Null
        }
    } else {
        Write-Host "No Task Extra Files were processed" -ForegroundColor DarkGray
    }
    
    Write-Host '========================================================================================' -ForegroundColor DarkGray
    Write-Host "Install.wim: Template Extra Files"	-ForegroundColor Green
    if ($ExtraFilesTemplates) {
        foreach ($ExtraFile in $ExtraFilesTemplates) {
            Write-Host "$($ExtraFile.FullName)" -ForegroundColor DarkGray
            robocopy "$($ExtraFile.FullName)" "$MountDirectory" *.* /e /ndl /xx /b /np /ts /tee /r:0 /w:0 /Log+:"$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Template-ExtraFiles.log" | Out-Null
        }
    } else {
        Write-Host "No Template Extra Files were processed" -ForegroundColor DarkGray
    }
}
