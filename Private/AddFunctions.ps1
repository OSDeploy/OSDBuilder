function Add-ContentADKWinPE {
    [CmdletBinding()]
    Param ()
    #===================================================================================================
    #   Abort
    #===================================================================================================
    if ($ScriptName -ne 'New-OSBuild') {Return}
    if ([string]::IsNullOrWhiteSpace($WinPEADKPE)) {Return}
    #===================================================================================================
    #   Header
    #===================================================================================================
    Show-ActionTime
    Write-Host -ForegroundColor Green "WinPE: WinPE.wim ADK Optional Components"
    #===================================================================================================
    #   Execute
    #===================================================================================================
    $WinPEADKPE = $WinPEADKPE | Sort-Object Length

    foreach ($PackagePath in $WinPEADKPE) {
        if ($PackagePath -like "*WinPE-NetFx*") {
            $CurrentLog = "$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Add-ContentADKWinPE.log"
            Write-Verbose "CurrentLog: $CurrentLog"

            Write-Host "$OSDBuilderContent\$PackagePath" -ForegroundColor DarkGray
            Add-WindowsPackage -PackagePath "$OSDBuilderContent\$PackagePath" -Path "$MountWinPE" -LogPath "$CurrentLog" | Out-Null
        }
    }

    $WinPEADKPE = $WinPEADKPE | Where-Object {$_.Name -notlike "*WinPE-NetFx*"}
    foreach ($PackagePath in $WinPEADKPE) {
        if ($PackagePath -like "*WinPE-PowerShell*") {
            $CurrentLog = "$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Add-ContentADKWinPE.log"
            Write-Verbose "CurrentLog: $CurrentLog"

            Write-Host "$OSDBuilderContent\$PackagePath" -ForegroundColor DarkGray
            Add-WindowsPackage -PackagePath "$OSDBuilderContent\$PackagePath" -Path "$MountWinPE" -LogPath "$CurrentLog" | Out-Null
        }
    }

    $WinPEADKPE = $WinPEADKPE | Where-Object {$_.Name -notlike "*WinPE-PowerShell*"}
    foreach ($PackagePath in $WinPEADKPE) {
        Write-Host "$OSDBuilderContent\$PackagePath" -ForegroundColor DarkGray
        $CurrentLog = "$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Add-ContentADKWinPE.log"
        Write-Verbose "CurrentLog: $CurrentLog"
        if ($OSMajorVersion -eq 6) {
            dism /Image:"$MountWinPE" /Add-Package /PackagePath:"$OSDBuilderContent\$PackagePath" /LogPath:"$CurrentLog"
        } else {
            Add-WindowsPackage -PackagePath "$OSDBuilderContent\$PackagePath" -Path "$MountWinPE" -LogPath "$CurrentLog" | Out-Null
        }
    }
}
function Add-ContentADKWinRE {
    [CmdletBinding()]
    Param ()
    #===================================================================================================
    #   Abort
    #===================================================================================================
    if ($ScriptName -ne 'New-OSBuild') {Return}
    if ([string]::IsNullOrWhiteSpace($WinPEADKRE)) {Return}
    #===================================================================================================
    #   Header
    #===================================================================================================
    Show-ActionTime
    Write-Host -ForegroundColor Green "WinPE: WinRE.wim ADK Optional Components"
    #===================================================================================================
    #   Execute
    #===================================================================================================
    $WinPEADKRE = $WinPEADKRE | Sort-Object Length
    foreach ($PackagePath in $WinPEADKRE) {
        $CurrentLog = "$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Add-ContentADKWinRE.log"
        Write-Verbose "CurrentLog: $CurrentLog"

        if ($PackagePath -like "*WinPE-NetFx*") {
            Write-Host "$OSDBuilderContent\$PackagePath" -ForegroundColor DarkGray
            Add-WindowsPackage -PackagePath "$OSDBuilderContent\$PackagePath" -Path "$MountWinRE" -LogPath "$CurrentLog" | Out-Null
        }
    }

    $WinPEADKRE = $WinPEADKRE | Where-Object {$_.Name -notlike "*WinPE-NetFx*"}
    foreach ($PackagePath in $WinPEADKRE) {
        $CurrentLog = "$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Add-ContentADKWinRE.log"
        Write-Verbose "CurrentLog: $CurrentLog"

        if ($PackagePath -like "*WinPE-PowerShell*") {
            Write-Host "$OSDBuilderContent\$PackagePath" -ForegroundColor DarkGray
            Add-WindowsPackage -PackagePath "$OSDBuilderContent\$PackagePath" -Path "$MountWinRE" -LogPath "$CurrentLog" | Out-Null
        }
    }
    $WinPEADKRE = $WinPEADKRE | Where-Object {$_.Name -notlike "*WinPE-PowerShell*"}
    foreach ($PackagePath in $WinPEADKRE) {
        $CurrentLog = "$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Add-ContentADKWinRE.log"
        Write-Verbose "CurrentLog: $CurrentLog"

        Write-Host "$OSDBuilderContent\$PackagePath" -ForegroundColor DarkGray
        if ($OSMajorVersion -eq 6) {
            dism /Image:"$MountWinRE" /Add-Package /PackagePath:"$OSDBuilderContent\$PackagePath" /LogPath:"$CurrentLog"
        } else {
            Add-WindowsPackage -PackagePath "$OSDBuilderContent\$PackagePath" -Path "$MountWinRE" -LogPath "$CurrentLog" | Out-Null
        }
    }
}
function Add-ContentADKWinSE {
    [CmdletBinding()]
    Param ()
    #===================================================================================================
    #   Abort
    #===================================================================================================
    if ([string]::IsNullOrWhiteSpace($WinPEADKSE)) {Return}
    #===================================================================================================
    #   Header
    #===================================================================================================
    Show-ActionTime
    Write-Host -ForegroundColor Green "WinPE: WinSE.wim ADK Optional Components"
    #===================================================================================================
    #   Execute
    #===================================================================================================
    $WinPEADKSE = $WinPEADKSE | Sort-Object Length
    foreach ($PackagePath in $WinPEADKSE) {
        $CurrentLog = "$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Add-ContentADKWinSE.log"
        Write-Verbose "CurrentLog: $CurrentLog"

        if ($PackagePath -like "*WinPE-NetFx*") {
            Write-Host "$OSDBuilderContent\$PackagePath" -ForegroundColor DarkGray
            Add-WindowsPackage -PackagePath "$OSDBuilderContent\$PackagePath" -Path "$MountWinSE" -LogPath "$CurrentLog" | Out-Null
        }
    }
    $WinPEADKSE = $WinPEADKSE | Where-Object {$_.Name -notlike "*WinPE-NetFx*"}
    foreach ($PackagePath in $WinPEADKSE) {
        $CurrentLog = "$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Add-ContentADKWinSE.log"
        Write-Verbose "CurrentLog: $CurrentLog"

        if ($PackagePath -like "*WinPE-PowerShell*") {
            Write-Host "$OSDBuilderContent\$PackagePath" -ForegroundColor DarkGray
            Add-WindowsPackage -PackagePath "$OSDBuilderContent\$PackagePath" -Path "$MountWinSE" -LogPath "$CurrentLog" | Out-Null
        }
    }
    $WinPEADKSE = $WinPEADKSE | Where-Object {$_.Name -notlike "*WinPE-PowerShell*"}
    foreach ($PackagePath in $WinPEADKSE) {
        $CurrentLog = "$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Add-ContentADKWinSE.log"
        Write-Verbose "CurrentLog: $CurrentLog"

        Write-Host "$OSDBuilderContent\$PackagePath" -ForegroundColor DarkGray
        if ($OSMajorVersion -eq 6) {
            dism /Image:"$MountWinSE" /Add-Package /PackagePath:"$OSDBuilderContent\$PackagePath" /LogPath:"$CurrentLog.log"
        } else {
            Add-WindowsPackage -PackagePath "$OSDBuilderContent\$PackagePath" -Path "$MountWinSE" -LogPath "$CurrentLog" | Out-Null
        }
    }
}
function Add-ContentDriversOS {
    [CmdletBinding()]
    Param ()
    #===================================================================================================
    #   Abort
    #===================================================================================================
    if ($ScriptName -ne 'New-OSBuild') {Return}
    #===================================================================================================
    #   Task
    #===================================================================================================
    Show-ActionTime; Write-Host -ForegroundColor Green "OS: Drivers TASK"
    if ($Drivers) {
        foreach ($Driver in $Drivers) {
            Write-Host "$OSDBuilderContent\$Driver" -ForegroundColor DarkGray

            $CurrentLog = "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Add-ContentDriversOS-Task.log"
            Write-Verbose "CurrentLog: $CurrentLog"

            if ($OSMajorVersion -eq 6) {
                dism /Image:"$MountDirectory" /Add-Driver /Driver:"$OSDBuilderContent\$Driver" /Recurse /ForceUnsigned /LogPath:"$CurrentLog"
            } else {
                Add-WindowsDriver -Driver "$OSDBuilderContent\$Driver" -Recurse -Path "$MountDirectory" -ForceUnsigned -LogPath "$CurrentLog" | Out-Null
            }
        }
    }
    #===================================================================================================
    #   Template
    #===================================================================================================
    Show-ActionTime; Write-Host -ForegroundColor Green "OS: Drivers TEMPLATE"
    if ($DriverTemplates) {
        foreach ($Driver in $DriverTemplates) {
            Write-Host "$($Driver.FullName)" -ForegroundColor DarkGray

            $CurrentLog = "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Add-ContentDriversOS-Template.log"
            Write-Verbose "CurrentLog: $CurrentLog"

            if ($OSMajorVersion -eq 6) {
                dism /Image:"$MountDirectory" /Add-Driver /Driver:"$($Driver.FullName)" /Recurse /ForceUnsigned /LogPath:"$CurrentLog"
            } else {
                Add-WindowsDriver -Driver "$($Driver.FullName)" -Recurse -Path "$MountDirectory" -ForceUnsigned -LogPath "$CurrentLog" | Out-Null
            }
        }
    }
}
function Add-ContentDriversPE {
    [CmdletBinding()]
    Param ()
    #===================================================================================================
    #   Abort
    #===================================================================================================
    if ($ScriptName -ne 'New-OSBuild') {Return}
    #===================================================================================================
    #   Task
    #===================================================================================================
    if ([string]::IsNullOrWhiteSpace($WinPEDrivers)) {Return}
    Show-ActionTime; Write-Host -ForegroundColor Green "WinPE: Add-ContentDriversPE"
    foreach ($WinPEDriver in $WinPEDrivers) {
        Write-Host "$OSDBuilderContent\$WinPEDriver" -ForegroundColor DarkGray
        
        $CurrentLog = "$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Add-ContentDriversPE-Task.log"
        Write-Verbose "CurrentLog: $CurrentLog"

        if ($OSMajorVersion -eq 6) {
            dism /Image:"$MountWinPE" /Add-Driver /Driver:"$OSDBuilderContent\$WinPEDriver" /Recurse /ForceUnsigned /LogPath:"$CurrentLog"
            dism /Image:"$MountWinRE" /Add-Driver /Driver:"$OSDBuilderContent\$WinPEDriver" /Recurse /ForceUnsigned /LogPath:"$CurrentLog"
            dism /Image:"$MountWinSE" /Add-Driver /Driver:"$OSDBuilderContent\$WinPEDriver" /Recurse /ForceUnsigned /LogPath:"$CurrentLog"
        } else {
            Add-WindowsDriver -Path "$MountWinPE" -Driver "$OSDBuilderContent\$WinPEDriver" -Recurse -ForceUnsigned -LogPath "$CurrentLog" | Out-Null
            Add-WindowsDriver -Path "$MountWinRE" -Driver "$OSDBuilderContent\$WinPEDriver" -Recurse -ForceUnsigned -LogPath "$CurrentLog" | Out-Null
            Add-WindowsDriver -Path "$MountWinSE" -Driver "$OSDBuilderContent\$WinPEDriver" -Recurse -ForceUnsigned -LogPath "$CurrentLog" | Out-Null
        }
    }
}
function Add-ContentExtraFilesOS {
    [CmdletBinding()]
    Param ()
    #===================================================================================================
    #   Abort
    #===================================================================================================
    if ($ScriptName -ne 'New-OSBuild') {Return}
    #===================================================================================================
    #   Task
    #===================================================================================================
    if ($ExtraFiles) {
        Show-ActionTime; Write-Host -ForegroundColor Green "OS: Content Extra Files TASK"
        foreach ($ExtraFile in $ExtraFiles) {
        
            $CurrentLog = "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Add-ContentExtraFilesOS-Task.log"
            Write-Verbose "CurrentLog: $CurrentLog"

            Write-Host "$OSDBuilderContent\$ExtraFile" -ForegroundColor DarkGray
            robocopy "$OSDBuilderContent\$ExtraFile" "$MountDirectory" *.* /e /ndl /xx /b /np /ts /tee /r:0 /w:0 /Log+:"$CurrentLog" | Out-Null
        }
    }
    #===================================================================================================
    #   Template
    #===================================================================================================
    if ($ExtraFilesTemplates) {
        Show-ActionTime; Write-Host -ForegroundColor Green "OS: Content Extra Files TEMPLATE"
        foreach ($ExtraFile in $ExtraFilesTemplates) {
        
            $CurrentLog = "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Add-ContentExtraFilesOS-Template.log"
            Write-Verbose "CurrentLog: $CurrentLog"

            Write-Host "$($ExtraFile.FullName)" -ForegroundColor DarkGray
            robocopy "$($ExtraFile.FullName)" "$MountDirectory" *.* /e /ndl /xx /b /np /ts /tee /r:0 /w:0 /Log+:"$CurrentLog" | Out-Null
        }
    }
}
function Add-ContentExtraFilesPE {
    [CmdletBinding()]
    Param ()
    #===================================================================================================
    #   Abort
    #===================================================================================================
    if ($ScriptName -ne 'New-OSBuild') {Return}
    #===================================================================================================
    #   Task
    #===================================================================================================
    Show-ActionTime; Write-Host -ForegroundColor Green "WinPE: Add-ContentExtraFilesPE TASK"
    foreach ($ExtraFile in $WinPEExtraFilesPE) {
        Write-Host "Source: $OSDBuilderContent\$ExtraFile" -ForegroundColor DarkGray
        $CurrentLog = "$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Add-ContentExtraFilesPE.log"
        Write-Verbose "CurrentLog: $CurrentLog"
        robocopy "$OSDBuilderContent\$ExtraFile" "$MountWinPE" *.* /e /ndl /xx /b /np /ts /tee /r:0 /w:0 /Log+:"$CurrentLog" | Out-Null
    }
    foreach ($ExtraFile in $WinPEExtraFilesRE) {
        Write-Host "Source: $OSDBuilderContent\$ExtraFile" -ForegroundColor DarkGray
        $CurrentLog = "$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Add-ContentExtraFilesPE.log"
        Write-Verbose "CurrentLog: $CurrentLog"
        robocopy "$OSDBuilderContent\$ExtraFile" "$MountWinRE" *.* /e /ndl /xx /b /np /ts /tee /r:0 /w:0 /Log+:"$CurrentLog" | Out-Null
    }
    foreach ($ExtraFile in $WinPEExtraFilesSE) {
        Write-Host "Source: $OSDBuilderContent\$ExtraFile" -ForegroundColor DarkGray
        $CurrentLog = "$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Add-ContentExtraFilesPE.log"
        Write-Verbose "CurrentLog: $CurrentLog"
        robocopy "$OSDBuilderContent\$ExtraFile" "$MountWinSE" *.* /e /ndl /xx /b /np /ts /tee /r:0 /w:0 /Log+:"$CurrentLog" | Out-Null
    }
}
function Add-ContentScriptsOS {
    [CmdletBinding()]
    Param ()
    #===================================================================================================
    #   Abort
    #===================================================================================================
    if ($ScriptName -ne 'New-OSBuild') {Return}
    #===================================================================================================
    #   Task
    #===================================================================================================
    if ($Scripts) {
        Show-ActionTime; Write-Host -ForegroundColor Green "OS: Execute TASK Scripts"
        foreach ($Script in $Scripts) {
            if (Test-Path "$OSDBuilderContent\$Script") {
                Write-Host -ForegroundColor Cyan "Source: $OSDBuilderContent\$Script"
                Invoke-Expression "& '$OSDBuilderContent\$Script'"
            }
        }
    }
    #===================================================================================================
    #   Template
    #===================================================================================================
    if ($ScriptTemplates) {
        Show-ActionTime; Write-Host -ForegroundColor Green "OS: Execute TEMPLATE Scripts"
        foreach ($Script in $ScriptTemplates) {
            if (Test-Path "$($Script.FullName)") {
                Write-Host -ForegroundColor Cyan "Source: $($Script.FullName)"
                Invoke-Expression "& '$($Script.FullName)'"
            }
        }
    }
}
function Add-ContentScriptsPE {
    [CmdletBinding()]
    Param ()
    #===================================================================================================
    #   Abort
    #===================================================================================================
    if ($ScriptName -ne 'New-OSBuild') {Return}
    #===================================================================================================
    #   Header
    #===================================================================================================
    Show-ActionTime
    Write-Host -ForegroundColor Green "WinPE: Add-ContentScriptsPE"
    #===================================================================================================
    #   Execute
    #===================================================================================================
    foreach ($PSWimScript in $WinPEScriptsPE) {
        if (Test-Path "$OSDBuilderContent\$PSWimScript") {
            Write-Host "Source: $OSDBuilderContent\$PSWimScript" -ForegroundColor Cyan
            (Get-Content "$OSDBuilderContent\$PSWimScript").replace('winpe.wim.log', 'WinPE.log') | Set-Content "$OSDBuilderContent\$PSWimScript"
            Invoke-Expression "& '$OSDBuilderContent\$PSWimScript'"
        }
    }
    foreach ($PSWimScript in $WinPEScriptsRE) {
        if (Test-Path "$OSDBuilderContent\$PSWimScript") {
            Write-Host "Source: $OSDBuilderContent\$PSWimScript" -ForegroundColor Cyan
            (Get-Content "$OSDBuilderContent\$PSWimScript").replace('winre.wim.log', 'WinRE.log') | Set-Content "$OSDBuilderContent\$PSWimScript"
            Invoke-Expression "& '$OSDBuilderContent\$PSWimScript'"
        }
    }
    foreach ($PSWimScript in $WinPEScriptsSE) {
        if (Test-Path "$OSDBuilderContent\$PSWimScript") {
            Write-Host "Source: $OSDBuilderContent\$PSWimScript" -ForegroundColor Cyan
            (Get-Content "$OSDBuilderContent\$PSWimScript").replace('MountSetup', 'MountWinSE') | Set-Content "$OSDBuilderContent\$PSWimScript"
            (Get-Content "$OSDBuilderContent\$PSWimScript").replace('setup.wim.log', 'WinSE.log') | Set-Content "$OSDBuilderContent\$PSWimScript"
            Invoke-Expression "& '$OSDBuilderContent\$PSWimScript'"
        }
    }
}
function Add-ContentStartLayout {
    [CmdletBinding()]
    Param ()
    #===================================================================================================
    #   Abort
    #===================================================================================================
    if ($ScriptName -ne 'New-OSBuild') {Return}
    if ($OSMajorVersion -ne 10) {Return}
    if ([string]::IsNullOrWhiteSpace($StartLayoutXML)) {Return}
    #===================================================================================================
    #   Header
    #===================================================================================================
    Show-ActionTime
    Write-Host -ForegroundColor Green "OS: Use Content StartLayout"
    #===================================================================================================
    #   Execute
    #===================================================================================================
    Write-Host "$OSDBuilderContent\$StartLayoutXML" -ForegroundColor DarkGray
    Try {
        Copy-Item -Path "$OSDBuilderContent\$StartLayoutXML" -Destination "$MountDirectory\Users\Default\AppData\Local\Microsoft\Windows\Shell\LayoutModification.xml" -Recurse -Force | Out-Null
    }
    Catch {
        $ErrorMessage = $_.Exception.Message
        Write-Warning "$ErrorMessage"
    }
}
function Add-ContentUnattend {
    [CmdletBinding()]
    Param ()
    #===================================================================================================
    #   Abort
    #===================================================================================================
    if ($ScriptName -ne 'New-OSBuild') {Return}
    if ($OSMajorVersion -ne 10) {Return}
    if ([string]::IsNullOrWhiteSpace($UnattendXML)) {Return}
    #===================================================================================================
    #   Header
    #===================================================================================================
    Show-ActionTime
    Write-Host -ForegroundColor Green "OS: Use Content Unattend"
    #===================================================================================================
    #   Execute
    #===================================================================================================
    Write-Host "$OSDBuilderContent\$UnattendXML" -ForegroundColor DarkGray
    if (!(Test-Path "$MountDirectory\Windows\Panther")) {New-Item -Path "$MountDirectory\Windows\Panther" -ItemType Directory -Force | Out-Null}
    Copy-Item -Path "$OSDBuilderContent\$UnattendXML" -Destination "$MountDirectory\Windows\Panther\Unattend.xml" -Force
    
    $CurrentLog = "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Add-ContentUnattend.log"
    Write-Verbose "CurrentLog: $CurrentLog"

    Try {Use-WindowsUnattend -UnattendPath "$OSDBuilderContent\$UnattendXML" -Path "$MountDirectory" -LogPath "$CurrentLog" | Out-Null}
    Catch {
        $ErrorMessage = $_.Exception.Message
        Write-Warning "$ErrorMessage"
    }
}
function Add-FeaturesOnDemandOS {
    [CmdletBinding()]
    Param ()
    #===================================================================================================
    #   Abort
    #===================================================================================================
    if ($ScriptName -ne 'New-OSBuild') {Return}
    if ([string]::IsNullOrWhiteSpace($FeaturesOnDemand)) {Return}
    #===================================================================================================
    #   Header
    #===================================================================================================
    Show-ActionTime
    Write-Host -ForegroundColor Green "OS: Features On Demand"
    #===================================================================================================
    #   Execute
    #===================================================================================================
    foreach ($FOD in $FeaturesOnDemand) {
        Write-Host $FOD -ForegroundColor DarkGray
        $CurrentLog = "$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Add-FeaturesOnDemandOS.log"
        Write-Verbose "CurrentLog: $CurrentLog"
        Try {
            Add-WindowsPackage -Path "$MountDirectory" -PackagePath "$OSDBuilderContent\$FOD" -LogPath "$CurrentLog" | Out-Null
        }
        Catch {
            $ErrorMessage = $_.Exception.Message
            Write-Warning "$ErrorMessage"
        }
    }
    Update-CumulativeOS -Force
    Invoke-DismCleanupImage
}
function Add-LanguageFeaturesOnDemandOS {
    [CmdletBinding()]
    Param ()
    #===================================================================================================
    #   Abort
    #===================================================================================================
    if ($ScriptName -ne 'New-OSBuild') {Return}
    if ($OSMajorVersion -ne 10) {Return}
    if ([string]::IsNullOrWhiteSpace($LanguageFeatures)) {Return}
    #===================================================================================================
    #   Header
    #===================================================================================================
    Show-ActionTime
    Write-Host -ForegroundColor Green "OS: Language Features On Demand"
    #===================================================================================================
    #   Execute
    #===================================================================================================
    foreach ($Update in $LanguageFeatures | Where-Object {$_ -notlike "*Speech*"}) {
        if (Test-Path "$OSDBuilderContent\$Update") {
            Write-Host "$OSDBuilderContent\$Update" -ForegroundColor DarkGray
            Add-WindowsPackage -Path "$MountDirectory" -PackagePath "$OSDBuilderContent\$Update" -LogPath "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Add-LanguageFeaturesOnDemandOS.log" | Out-Null
        }
    }
    foreach ($Update in $LanguageFeatures | Where-Object {$_ -like "*TextToSpeech*"}) {
        if (Test-Path "$OSDBuilderContent\$Update") {
            Write-Host "$OSDBuilderContent\$Update" -ForegroundColor DarkGray
            Add-WindowsPackage -Path "$MountDirectory" -PackagePath "$OSDBuilderContent\$Update" -LogPath "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Add-LanguageFeaturesOnDemandOS.log" | Out-Null
        }
    }
    foreach ($Update in $LanguageFeatures | Where-Object {$_ -like "*Speech*" -and $_ -notlike "*TextToSpeech*"}) {
        if (Test-Path "$OSDBuilderContent\$Update") {
            Write-Host "$OSDBuilderContent\$Update" -ForegroundColor DarkGray
            Add-WindowsPackage -Path "$MountDirectory" -PackagePath "$OSDBuilderContent\$Update" -LogPath "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Add-LanguageFeaturesOnDemandOS.log" | Out-Null
        }
    }
}
function Add-LanguageInterfacePacksOS {
    [CmdletBinding()]
    Param ()
    #===================================================================================================
    #   Abort
    #===================================================================================================
    if ($ScriptName -ne 'New-OSBuild') {Return}
    if ($OSMajorVersion -ne 10) {Return}
    if ([string]::IsNullOrWhiteSpace($LanguageInterfacePacks)) {Return}
    #===================================================================================================
    #   Header
    #===================================================================================================
    Show-ActionTime
    Write-Host -ForegroundColor Green "OS: Language Interface Packs"
    #===================================================================================================
    #   Execute
    #===================================================================================================
    foreach ($Update in $LanguageInterfacePacks) {
        if (Test-Path "$OSDBuilderContent\$Update") {
            Write-Host "$OSDBuilderContent\$Update" -ForegroundColor DarkGray
            Add-WindowsPackage -Path "$MountDirectory" -PackagePath "$OSDBuilderContent\$Update" -LogPath "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Add-LanguageInterfacePacksOS.log" | Out-Null
        } else {
            Write-Warning "Not Found: $OSDBuilderContent\$Update"
        }
    }
}
function Add-LanguagePacksOS {
    [CmdletBinding()]
    Param ()
    #===================================================================================================
    #   Abort
    #===================================================================================================
    if ($ScriptName -ne 'New-OSBuild') {Return}
    if ($OSMajorVersion -ne 10) {Return}
    if ([string]::IsNullOrWhiteSpace($LanguagePacks)) {Return}
    #===================================================================================================
    #   Header
    #===================================================================================================
    Show-ActionTime
    Write-Host -ForegroundColor Green "OS: Language Packs"
    #===================================================================================================
    #   Execute
    #===================================================================================================
    foreach ($Update in $LanguagePacks) {
        if (Test-Path "$OSDBuilderContent\$Update") {
            if ($Update -like "*.cab") {
                Write-Host "$OSDBuilderContent\$Update" -ForegroundColor DarkGray
                Add-WindowsPackage -Path "$MountDirectory" -PackagePath "$OSDBuilderContent\$Update" -LogPath "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Add-LanguagePacksOS.log" | Out-Null
            } elseif ($Update -like "*.appx") {
                Write-Host "$OSDBuilderContent\$Update" -ForegroundColor DarkGray
                Add-AppxProvisionedPackage -Path "$MountDirectory" -PackagePath "$OSDBuilderContent\$Update" -LicensePath "$((Get-Item $OSDBuilderContent\$Update).Directory.FullName)\License.xml" -LogPath "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Add-LanguagePacksOS.log" | Out-Null
            }
        } else {
            Write-Warning "Not Found: $OSDBuilderContent\$Update"
        }
    }
}
function Add-LocalExperiencePacksOS {
    [CmdletBinding()]
    Param ()
    #===================================================================================================
    #   Abort
    #===================================================================================================
    if ($ScriptName -ne 'New-OSBuild') {Return}
    if ($OSMajorVersion -ne 10) {Return}
    if ([string]::IsNullOrWhiteSpace($LocalExperiencePacks)) {Return}
    #===================================================================================================
    #   Header
    #===================================================================================================
    Show-ActionTime
    Write-Host -ForegroundColor Green "OS: Local Experience Packs"
    #===================================================================================================
    #   Execute
    #===================================================================================================
    foreach ($Update in $LocalExperiencePacks) {
        if (Test-Path "$OSDBuilderContent\$Update") {
            Write-Host "$OSDBuilderContent\$Update" -ForegroundColor DarkGray
            Add-AppxProvisionedPackage -Path "$MountDirectory" -PackagePath "$OSDBuilderContent\$Update" -LicensePath "$((Get-Item $OSDBuilderContent\$Update).Directory.FullName)\License.xml" -LogPath "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Add-LocalExperiencePacksOS.log" | Out-Null
        } else {
            Write-Warning "Not Found: $OSDBuilderContent\$Update"
        }
    }
}
function Add-WindowsPackageOS {
    [CmdletBinding()]
    Param ()
    #===================================================================================================
    #   Abort
    #===================================================================================================
    if ($ScriptName -ne 'New-OSBuild') {Return}
    #===================================================================================================
    #   Task
    #===================================================================================================
    if ([string]::IsNullOrWhiteSpace($Packages)) {Return}
    Show-ActionTime; Write-Host -ForegroundColor Green "OS: Add Packages"
    foreach ($PackagePath in $Packages) {
        Write-Host "$OSDBuilderContent\$PackagePath" -ForegroundColor DarkGray
        Try {
            Add-WindowsPackage -PackagePath "$OSDBuilderContent\$PackagePath" -Path "$MountDirectory" -LogPath "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Add-WindowsPackageOS.log" | Out-Null
        }
        Catch {
            $ErrorMessage = $_.Exception.Message
            Write-Warning "$ErrorMessage"
        }
    }
}