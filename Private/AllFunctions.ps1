function Add-ContentADKWinPE {
    [CmdletBinding()]
    param ()
    #=================================================
    #   Abort
    #=================================================
    if (($ScriptName -ne 'New-OSBuild') -and ($ScriptName -ne 'New-PEBuild')) {Return}
    if ([string]::IsNullOrWhiteSpace($WinPEADKPE)) {Return}
    $global:ReapplyLCU = $true
    #=================================================
    #   Execute
    #=================================================
    Show-ActionTime; Write-Host -ForegroundColor Green "WinPE: WinPE.wim ADK Optional Components"

    $WinPEADKPE = $WinPEADKPE | Sort-Object Length
    foreach ($PackagePath in $WinPEADKPE) {
        if ($PackagePath -like "*WinPE-NetFx*") {
            $CurrentLog = "$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Add-ContentADKWinPE.log"
            Write-Verbose "CurrentLog: $CurrentLog"

            Write-Host "$SetOSDBuilderPathContent\$PackagePath" -ForegroundColor DarkGray
            Try {Add-WindowsPackage -PackagePath "$SetOSDBuilderPathContent\$PackagePath" -Path "$MountWinPE" -LogPath "$CurrentLog" | Out-Null}
            Catch {
                if ($_.Exception.Message -match '0x800f081e') {Write-Verbose "OSDBuilder: 0x800f081e The package is not applicable to this image" -Verbose}
                Write-Verbose "$CurrentLog" -Verbose
            }
        }
    }

    $WinPEADKPE = $WinPEADKPE | Where-Object {$_.Name -notlike "*WinPE-NetFx*"}
    foreach ($PackagePath in $WinPEADKPE) {
        if ($PackagePath -like "*WinPE-PowerShell*") {
            $CurrentLog = "$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Add-ContentADKWinPE.log"
            Write-Verbose "CurrentLog: $CurrentLog"

            Write-Host "$SetOSDBuilderPathContent\$PackagePath" -ForegroundColor DarkGray
            Try {Add-WindowsPackage -PackagePath "$SetOSDBuilderPathContent\$PackagePath" -Path "$MountWinPE" -LogPath "$CurrentLog" | Out-Null}
            Catch {
                if ($_.Exception.Message -match '0x800f081e') {Write-Verbose "OSDBuilder: 0x800f081e The package is not applicable to this image" -Verbose}
                Write-Verbose "$CurrentLog" -Verbose
            }
        }
    }

    $WinPEADKPE = $WinPEADKPE | Where-Object {$_.Name -notlike "*WinPE-PowerShell*"}
    foreach ($PackagePath in $WinPEADKPE) {
        Write-Host "$SetOSDBuilderPathContent\$PackagePath" -ForegroundColor DarkGray
        $CurrentLog = "$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Add-ContentADKWinPE.log"
        Write-Verbose "CurrentLog: $CurrentLog"
        if ($OSMajorVersion -eq 6) {
            dism /Image:"$MountWinPE" /Add-Package /PackagePath:"$SetOSDBuilderPathContent\$PackagePath" /LogPath:"$CurrentLog"
        } else {
            Try {Add-WindowsPackage -PackagePath "$SetOSDBuilderPathContent\$PackagePath" -Path "$MountWinPE" -LogPath "$CurrentLog" | Out-Null}
            Catch {
                if ($_.Exception.Message -match '0x800f081e') {Write-Verbose "OSDBuilder: 0x800f081e The package is not applicable to this image" -Verbose}
                Write-Verbose "$CurrentLog" -Verbose
            }
        }
    }
}
function Add-ContentADKWinRE {
    [CmdletBinding()]
    param ()
    #=================================================
    #   Abort
    #=================================================
    if (($ScriptName -ne 'New-OSBuild') -and ($ScriptName -ne 'New-PEBuild')) {Return}
    if ([string]::IsNullOrWhiteSpace($WinPEADKRE)) {Return}
    $global:ReapplyLCU = $true
    #=================================================
    #   Execute
    #=================================================
    Show-ActionTime; Write-Host -ForegroundColor Green "WinPE: WinRE.wim ADK Optional Components"

    $WinPEADKRE = $WinPEADKRE | Sort-Object Length
    foreach ($PackagePath in $WinPEADKRE) {
        $CurrentLog = "$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Add-ContentADKWinRE.log"
        Write-Verbose "CurrentLog: $CurrentLog"

        if ($PackagePath -like "*WinPE-NetFx*") {
            Write-Host "$SetOSDBuilderPathContent\$PackagePath" -ForegroundColor DarkGray
            Try {Add-WindowsPackage -PackagePath "$SetOSDBuilderPathContent\$PackagePath" -Path "$MountWinRE" -LogPath "$CurrentLog" | Out-Null}
            Catch {
                if ($_.Exception.Message -match '0x800f081e') {Write-Verbose "OSDBuilder: 0x800f081e The package is not applicable to this image" -Verbose}
                Write-Verbose "$CurrentLog" -Verbose
            }
        }
    }

    $WinPEADKRE = $WinPEADKRE | Where-Object {$_.Name -notlike "*WinPE-NetFx*"}
    foreach ($PackagePath in $WinPEADKRE) {
        $CurrentLog = "$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Add-ContentADKWinRE.log"
        Write-Verbose "CurrentLog: $CurrentLog"

        if ($PackagePath -like "*WinPE-PowerShell*") {
            Write-Host "$SetOSDBuilderPathContent\$PackagePath" -ForegroundColor DarkGray
            Try {Add-WindowsPackage -PackagePath "$SetOSDBuilderPathContent\$PackagePath" -Path "$MountWinRE" -LogPath "$CurrentLog" | Out-Null}
            Catch {
                if ($_.Exception.Message -match '0x800f081e') {Write-Verbose "OSDBuilder: 0x800f081e The package is not applicable to this image" -Verbose}
                Write-Verbose "$CurrentLog" -Verbose
            }
        }
    }
    $WinPEADKRE = $WinPEADKRE | Where-Object {$_.Name -notlike "*WinPE-PowerShell*"}
    foreach ($PackagePath in $WinPEADKRE) {
        $CurrentLog = "$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Add-ContentADKWinRE.log"
        Write-Verbose "CurrentLog: $CurrentLog"

        Write-Host "$SetOSDBuilderPathContent\$PackagePath" -ForegroundColor DarkGray
        if ($OSMajorVersion -eq 6) {
            dism /Image:"$MountWinRE" /Add-Package /PackagePath:"$SetOSDBuilderPathContent\$PackagePath" /LogPath:"$CurrentLog"
        } else {
            Try {Add-WindowsPackage -PackagePath "$SetOSDBuilderPathContent\$PackagePath" -Path "$MountWinRE" -LogPath "$CurrentLog" | Out-Null}
            Catch {
                if ($_.Exception.Message -match '0x800f081e') {Write-Verbose "OSDBuilder: 0x800f081e The package is not applicable to this image" -Verbose}
                Write-Verbose "$CurrentLog" -Verbose
            }
        }
    }
}
function Add-ContentADKWinSE {
    [CmdletBinding()]
    param ()
    #=================================================
    #   Abort
    #=================================================
    if (($ScriptName -ne 'New-OSBuild') -and ($ScriptName -ne 'New-PEBuild')) {Return}
    if ([string]::IsNullOrWhiteSpace($WinPEADKSE)) {Return}
    $global:ReapplyLCU = $true
    #=================================================
    #   Header
    #=================================================
    Show-ActionTime
    Write-Host -ForegroundColor Green "WinPE: WinSE.wim ADK Optional Components"
    #=================================================
    #   Execute
    #=================================================
    $WinPEADKSE = $WinPEADKSE | Sort-Object Length
    foreach ($PackagePath in $WinPEADKSE) {
        $CurrentLog = "$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Add-ContentADKWinSE.log"
        Write-Verbose "CurrentLog: $CurrentLog"

        if ($PackagePath -like "*WinPE-NetFx*") {
            Write-Host "$SetOSDBuilderPathContent\$PackagePath" -ForegroundColor DarkGray
            Try {Add-WindowsPackage -PackagePath "$SetOSDBuilderPathContent\$PackagePath" -Path "$MountWinSE" -LogPath "$CurrentLog" | Out-Null}
            Catch {
                if ($_.Exception.Message -match '0x800f081e') {Write-Verbose "OSDBuilder: 0x800f081e The package is not applicable to this image" -Verbose}
                Write-Verbose "$CurrentLog" -Verbose
            }
        }
    }
    $WinPEADKSE = $WinPEADKSE | Where-Object {$_.Name -notlike "*WinPE-NetFx*"}
    foreach ($PackagePath in $WinPEADKSE) {
        $CurrentLog = "$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Add-ContentADKWinSE.log"
        Write-Verbose "CurrentLog: $CurrentLog"

        if ($PackagePath -like "*WinPE-PowerShell*") {
            Write-Host "$SetOSDBuilderPathContent\$PackagePath" -ForegroundColor DarkGray
            Try {Add-WindowsPackage -PackagePath "$SetOSDBuilderPathContent\$PackagePath" -Path "$MountWinSE" -LogPath "$CurrentLog" | Out-Null}
            Catch {
                if ($_.Exception.Message -match '0x800f081e') {Write-Verbose "OSDBuilder: 0x800f081e The package is not applicable to this image" -Verbose}
                Write-Verbose "$CurrentLog" -Verbose
            }
        }
    }
    $WinPEADKSE = $WinPEADKSE | Where-Object {$_.Name -notlike "*WinPE-PowerShell*"}
    foreach ($PackagePath in $WinPEADKSE) {
        $CurrentLog = "$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Add-ContentADKWinSE.log"
        Write-Verbose "CurrentLog: $CurrentLog"

        Write-Host "$SetOSDBuilderPathContent\$PackagePath" -ForegroundColor DarkGray
        if ($OSMajorVersion -eq 6) {
            dism /Image:"$MountWinSE" /Add-Package /PackagePath:"$SetOSDBuilderPathContent\$PackagePath" /LogPath:"$CurrentLog.log"
        } else {
            Try {Add-WindowsPackage -PackagePath "$SetOSDBuilderPathContent\$PackagePath" -Path "$MountWinSE" -LogPath "$CurrentLog" | Out-Null}
            Catch {
                if ($_.Exception.Message -match '0x800f081e') {Write-Verbose "OSDBuilder: 0x800f081e The package is not applicable to this image" -Verbose}
                Write-Verbose "$CurrentLog" -Verbose
            }
        }
    }
}
function Add-ContentDriversOS {
    [CmdletBinding()]
    param ()
    #=================================================
    #   Abort
    #=================================================
    if ($ScriptName -ne 'New-OSBuild') {Return}
    #=================================================
    #   Task
    #=================================================
    if ($Drivers) {
        Show-ActionTime; Write-Host -ForegroundColor Green "OS: Drivers TASK"
        foreach ($Driver in $Drivers) {
            Write-Host "$SetOSDBuilderPathContent\$Driver" -ForegroundColor DarkGray

            $CurrentLog = "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Add-ContentDriversOS-Task.log"
            Write-Verbose "CurrentLog: $CurrentLog"

            if ($OSMajorVersion -eq 6) {
                dism /Image:"$MountDirectory" /Add-Driver /Driver:"$SetOSDBuilderPathContent\$Driver" /Recurse /ForceUnsigned /LogPath:"$CurrentLog"
            } else {
                Try {Add-WindowsDriver -Driver "$SetOSDBuilderPathContent\$Driver" -Recurse -Path "$MountDirectory" -ForceUnsigned -LogPath "$CurrentLog" | Out-Null}
                Catch {
                    if ($_.Exception.Message -match '0x800f081e') {Write-Verbose "OSDBuilder: 0x800f081e The package is not applicable to this image" -Verbose}

                    Write-Verbose "$CurrentLog" -Verbose
                }
            }
        }
    }
    #=================================================
    #   Template
    #=================================================
    if ($DriverTemplates) {
        Show-ActionTime; Write-Host -ForegroundColor Green "OS: Drivers TEMPLATE"
        foreach ($Driver in $DriverTemplates) {
            Write-Host "$($Driver.FullName)" -ForegroundColor DarkGray

            $CurrentLog = "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Add-ContentDriversOS-Template.log"
            Write-Verbose "CurrentLog: $CurrentLog"

            if ($OSMajorVersion -eq 6) {
                dism /Image:"$MountDirectory" /Add-Driver /Driver:"$($Driver.FullName)" /Recurse /ForceUnsigned /LogPath:"$CurrentLog"
            } else {
                Try {Add-WindowsDriver -Driver "$($Driver.FullName)" -Recurse -Path "$MountDirectory" -ForceUnsigned -LogPath "$CurrentLog" | Out-Null}
                Catch {
                    if ($_.Exception.Message -match '0x800f081e') {Write-Verbose "OSDBuilder: 0x800f081e The package is not applicable to this image" -Verbose}

                    Write-Verbose "$CurrentLog" -Verbose
                }
            }
        }
    }
}
function Add-ContentDriversPE {
    [CmdletBinding()]
    param ()
    #=================================================
    #   Abort
    #=================================================
    if ($ScriptName -ne 'New-OSBuild') {Return}
    #=================================================
    #   MountPaths
    #=================================================
    $MountPaths = @(
        $MountWinPE
        $MountWinPE
        $MountWinPE
    )
    #=================================================
    #   Task
    #=================================================
    if ([string]::IsNullOrWhiteSpace($WinPEDrivers)) {Return}
    Show-ActionTime; Write-Host -ForegroundColor Green "WinPE: Add-ContentDriversPE"
    foreach ($WinPEDriver in $WinPEDrivers) {
        Write-Host "$SetOSDBuilderPathContent\$WinPEDriver" -ForegroundColor DarkGray

        foreach ($MountPath in $MountPaths) {
            $CurrentLog = "$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Add-ContentDriversPE-Task.log"
            Write-Verbose "CurrentLog: $CurrentLog"
    
            if ($OSMajorVersion -eq 6) {
                dism /Image:"$MountPath" /Add-Driver /Driver:"$SetOSDBuilderPathContent\$WinPEDriver" /Recurse /ForceUnsigned /LogPath:"$CurrentLog"
            } else {
                Add-WindowsDriver -Path "$MountPath" -Driver "$SetOSDBuilderPathContent\$WinPEDriver" -Recurse -ForceUnsigned -LogPath "$CurrentLog" | Out-Null
            }
        }
    }
}
function Add-ContentExtraFilesOS {
    [CmdletBinding()]
    param ()
    #=================================================
    #   ABORT
    #=================================================
    if ($ScriptName -ne 'New-OSBuild') {Return}
    #=================================================
    #   TASK
    #=================================================
    if ($ExtraFiles) {
        Show-ActionTime; Write-Host -ForegroundColor Green "OS: Extra Files TASK"
        foreach ($ExtraFile in $ExtraFiles) {
        
            $CurrentLog = "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Add-ContentExtraFilesOS-Task.log"
            Write-Verbose "CurrentLog: $CurrentLog"

            Write-Host "$SetOSDBuilderPathContent\$ExtraFile" -ForegroundColor DarkGray
            robocopy "$SetOSDBuilderPathContent\$ExtraFile" "$MountDirectory" *.* /s /ndl /xx /b /np /ts /tee /r:0 /w:0 /Log+:"$CurrentLog" | Out-Null
        }
    }
    #=================================================
    #   TEMPLATE
    #=================================================
    if ($ExtraFilesTemplates) {
        Show-ActionTime; Write-Host -ForegroundColor Green "OS: Extra Files TEMPLATE"
        foreach ($ExtraFile in $ExtraFilesTemplates) {
        
            $CurrentLog = "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Add-ContentExtraFilesOS-Template.log"
            Write-Verbose "CurrentLog: $CurrentLog"

            Write-Host "$($ExtraFile.FullName)" -ForegroundColor DarkGray
            robocopy "$($ExtraFile.FullName)" "$MountDirectory" *.* /s /ndl /xx /b /np /ts /tee /r:0 /w:0 /Log+:"$CurrentLog" | Out-Null
        }
    }
}
function Add-ContentExtraFilesPE {
    [CmdletBinding()]
    param ()
    #=================================================
    #   ABORT
    #=================================================
    if ($ScriptName -ne 'New-OSBuild') {Return}
    #=================================================
    #   TASK
    #=================================================
    if ($WinPEExtraFilesPE -or $WinPEExtraFilesRE -or $WinPEExtraFilesSE) {
        Show-ActionTime; Write-Host -ForegroundColor Green "WinPE: Extra Files TASK"
        foreach ($ExtraFile in $WinPEExtraFilesPE) {
            Write-Host "Source: $SetOSDBuilderPathContent\$ExtraFile" -ForegroundColor DarkGray
            $CurrentLog = "$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Add-ContentExtraFilesPE.log"
            Write-Verbose "CurrentLog: $CurrentLog"
            #robocopy "$SetOSDBuilderPathContent\$ExtraFile" "$MountWinPE" *.* /s /ndl /xx /np /ts /tee /r:0 /w:0 /Log+:"$CurrentLog" | Out-Null
            robocopy "$SetOSDBuilderPathContent\$ExtraFile" "$MountWinPE" *.* /S /ZB /COPY:D /NODCOPY /XJ /NDL /NP /TEE /TS /XX /R:0 /W:0 /LOG+:"$CurrentLog" | Out-Null
        }
        foreach ($ExtraFile in $WinPEExtraFilesRE) {
            Write-Host "Source: $SetOSDBuilderPathContent\$ExtraFile" -ForegroundColor DarkGray
            $CurrentLog = "$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Add-ContentExtraFilesPE.log"
            Write-Verbose "CurrentLog: $CurrentLog"
            robocopy "$SetOSDBuilderPathContent\$ExtraFile" "$MountWinRE" *.* /S /ZB /COPY:D /NODCOPY /XJ /NDL /NP /TEE /TS /XX /R:0 /W:0 /LOG+:"$CurrentLog" | Out-Null
        }
        foreach ($ExtraFile in $WinPEExtraFilesSE) {
            Write-Host "Source: $SetOSDBuilderPathContent\$ExtraFile" -ForegroundColor DarkGray
            $CurrentLog = "$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Add-ContentExtraFilesPE.log"
            Write-Verbose "CurrentLog: $CurrentLog"
            robocopy "$SetOSDBuilderPathContent\$ExtraFile" "$MountWinSE" *.* /S /ZB /COPY:D /NODCOPY /XJ /NDL /NP /TEE /TS /XX /R:0 /W:0 /LOG+:"$CurrentLog" | Out-Null
        }
    } else {
        Return
    }
}
function Add-ContentScriptsOS {
    [CmdletBinding()]
    param ()
    #=================================================
    #   ABORT
    #=================================================
    if ($ScriptName -ne 'New-OSBuild') {Return}
    #=================================================
    #   TASK
    #=================================================
    if ($Scripts) {
        Show-ActionTime; Write-Host -ForegroundColor Green "OS: Scripts TASK"
        foreach ($Script in $Scripts) {
            if (Test-Path "$SetOSDBuilderPathContent\$Script") {
                Write-Host -ForegroundColor Cyan "Source: $SetOSDBuilderPathContent\$Script"
                Invoke-Expression "& '$SetOSDBuilderPathContent\$Script'"
            }
        }
    }
    #=================================================
    #   TEMPLATE
    #=================================================
    if ($ScriptTemplates) {
        Show-ActionTime; Write-Host -ForegroundColor Green "OS: Scripts TEMPLATE"
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
    param ()
    #=================================================
    #   Abort
    #=================================================
    if ($ScriptName -ne 'New-OSBuild') {Return}
    #=================================================
    #   TASK
    #=================================================
    if ($WinPEScriptsPE -or $WinPEScriptsRE -or $WinPEScriptsSE) {
        Show-ActionTime; Write-Host -ForegroundColor Green "WinPE: Scripts TASK"
        foreach ($PSWimScript in $WinPEScriptsPE) {
            if (Test-Path "$SetOSDBuilderPathContent\$PSWimScript") {
                Write-Host "Source: $SetOSDBuilderPathContent\$PSWimScript" -ForegroundColor Cyan
                (Get-Content "$SetOSDBuilderPathContent\$PSWimScript").replace('winpe.wim.log', 'WinPE.log') | Set-Content "$SetOSDBuilderPathContent\$PSWimScript"
                Invoke-Expression "& '$SetOSDBuilderPathContent\$PSWimScript'"
            }
        }
        foreach ($PSWimScript in $WinPEScriptsRE) {
            if (Test-Path "$SetOSDBuilderPathContent\$PSWimScript") {
                Write-Host "Source: $SetOSDBuilderPathContent\$PSWimScript" -ForegroundColor Cyan
                (Get-Content "$SetOSDBuilderPathContent\$PSWimScript").replace('winre.wim.log', 'WinRE.log') | Set-Content "$SetOSDBuilderPathContent\$PSWimScript"
                Invoke-Expression "& '$SetOSDBuilderPathContent\$PSWimScript'"
            }
        }
        foreach ($PSWimScript in $WinPEScriptsSE) {
            if (Test-Path "$SetOSDBuilderPathContent\$PSWimScript") {
                Write-Host "Source: $SetOSDBuilderPathContent\$PSWimScript" -ForegroundColor Cyan
                (Get-Content "$SetOSDBuilderPathContent\$PSWimScript").replace('MountSetup', 'MountWinSE') | Set-Content "$SetOSDBuilderPathContent\$PSWimScript"
                (Get-Content "$SetOSDBuilderPathContent\$PSWimScript").replace('setup.wim.log', 'WinSE.log') | Set-Content "$SetOSDBuilderPathContent\$PSWimScript"
                Invoke-Expression "& '$SetOSDBuilderPathContent\$PSWimScript'"
            }
        }
    }
}
function Add-ContentStartLayout {
    [CmdletBinding()]
    param ()
    #=================================================
    #   Abort
    #=================================================
    if ($ScriptName -ne 'New-OSBuild') {Return}
    if ($OSMajorVersion -ne 10) {Return}
    if ([string]::IsNullOrWhiteSpace($StartLayoutXML)) {Return}
    #=================================================
    #   TASK
    #=================================================
    Show-ActionTime; Write-Host -ForegroundColor Green "OS: Use Content StartLayout"
    Write-Host "$SetOSDBuilderPathContent\$StartLayoutXML" -ForegroundColor DarkGray
    Try {
        Copy-Item -Path "$SetOSDBuilderPathContent\$StartLayoutXML" -Destination "$MountDirectory\Users\Default\AppData\Local\Microsoft\Windows\Shell\LayoutModification.xml" -Recurse -Force | Out-Null
    }
    Catch {
        $ErrorMessage = $_.Exception.Message
        Write-Warning "$ErrorMessage"
    }
}
function Add-ContentUnattend {
    [CmdletBinding()]
    param ()
    #=================================================
    #   Abort
    #=================================================
    if ($ScriptName -ne 'New-OSBuild') {Return}
    if ($OSMajorVersion -ne 10) {Return}
    if ([string]::IsNullOrWhiteSpace($UnattendXML)) {Return}
    #=================================================
    #   Header
    #=================================================
    Show-ActionTime; Write-Host -ForegroundColor Green "OS: Use Content Unattend"
    #=================================================
    #   Execute
    #=================================================
    Write-Host "$SetOSDBuilderPathContent\$UnattendXML" -ForegroundColor DarkGray
    if (!(Test-Path "$MountDirectory\Windows\Panther")) {New-Item -Path "$MountDirectory\Windows\Panther" -ItemType Directory -Force | Out-Null}
    Copy-Item -Path "$SetOSDBuilderPathContent\$UnattendXML" -Destination "$MountDirectory\Windows\Panther\Unattend.xml" -Force
    
    $CurrentLog = "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Add-ContentUnattend.log"
    Write-Verbose "CurrentLog: $CurrentLog"

    Try {Use-WindowsUnattend -UnattendPath "$SetOSDBuilderPathContent\$UnattendXML" -Path "$MountDirectory" -LogPath "$CurrentLog" | Out-Null}
    Catch {
        $ErrorMessage = $_.Exception.Message
        Write-Warning "$ErrorMessage"
    }
}
function Add-ContentPack {
    [CmdletBinding()]
    param (
        #[Alias('Path')]
        #[Parameter(Mandatory)]
        #[string]$ContentPackPath,

        [ValidateSet(
            'MEDIA',
            'OSCapability',
            'OSDrivers',
            'OSExtraFiles',
            'OSLanguageFeatures',
            'OSLanguagePacks',
            'OSLocalExperiencePacks',
            'OSPackages',
            'OSPoshMods',
            'OSRegistry',
            'OSScripts',
            'OSStartLayout',
            'PEADK',
            'PEADKLang',
            'PEDaRT',
            'PEDrivers',
            'PEExtraFiles',
            'PEPackages',
            'PEPoshMods',
            'PERegistry',
            'PEScripts'
        )]
        [Alias('Type')]
        [string]$PackType = 'All'
    )
    #=================================================
    #   ABORT
    #=================================================
    if (Get-IsTemplatesEnabled) {Return}
    if ($SkipContentPacks -eq $true) {Return}
    if (($ScriptName -ne 'New-OSBuild') -and ($ScriptName -ne 'New-PEBuild')) {Return}
    #=================================================
    #   BUILD
    #=================================================
    if ($ContentPacks) {
        if ($ReleaseID -match '1909') {$MSUX = '1903'}
        elseif ($ReleaseID -match '20H2') {$MSUX = '2004'}
        elseif ($ReleaseID -match '21H1') {$MSUX = '2004'}
        elseif ($ReleaseID -match '21H2') {$MSUX = '2004'}
        else {$MSUX = $ReleaseID}
        #=================================================
        #   MEDIA ContentPacks
        #=================================================
        if ($PackType -eq 'MEDIA') {
            Show-ActionTime; Write-Host -ForegroundColor Green "MEDIA: ContentPack"
            foreach ($ContentPack in $ContentPacks) {
                $ContentPackPath = Join-Path $SetOSDBuilderPathContentPacks "$ContentPack\MEDIA"

                $ContentPaths = @(
                    "$ContentPackPath\ALL"
                    "$ContentPackPath\$OSArchitecture"
                    "$ContentPackPath\$UpdateOS $ReleaseID $OSArchitecture"
                )
                foreach ($ContentPath in $ContentPaths) {
                    if (! (Test-Path $ContentPath)) {New-Item -Path $ContentPath -ItemType Directory -Force -ErrorAction Ignore | Out-Null}
                    Add-ContentPackMEDIA -ContentPackContent $ContentPath
                }
            }
        }
        #=================================================
        #   OS ContentPacks
        #=================================================
        if ($PackType -eq 'OSDrivers') {
            Show-ActionTime; Write-Host -ForegroundColor Green "OS: ContentPack OSDrivers"
            foreach ($ContentPack in $ContentPacks) {
                $ContentPackPath = Join-Path $SetOSDBuilderPathContentPacks "$ContentPack\OSDrivers"

                $ContentPaths = @(
                    "$ContentPackPath\ALL"
                    "$ContentPackPath\$OSArchitecture"
                    "$ContentPackPath\$UpdateOS $ReleaseID $OSArchitecture"
                )
                foreach ($ContentPath in $ContentPaths) {
                    if (! (Test-Path $ContentPath)) {New-Item -Path $ContentPath -ItemType Directory -Force -ErrorAction Ignore | Out-Null}
                    Add-ContentPackOSDrivers -ContentPackContent $ContentPath
                }
            }
        }
        if ($PackType -eq 'OSExtraFiles') {
            Show-ActionTime; Write-Host -ForegroundColor Green "OS: ContentPack OSExtraFiles"
            foreach ($ContentPack in $ContentPacks) {
                $ContentPackPath = Join-Path $SetOSDBuilderPathContentPacks "$ContentPack\OSExtraFiles"

                $ContentPaths = @(
                    "$ContentPackPath\ALL"
                    "$ContentPackPath\$OSArchitecture"
                    "$ContentPackPath\$UpdateOS $ReleaseID $OSArchitecture"
                )
                foreach ($ContentPath in $ContentPaths) {
                    if (! (Test-Path $ContentPath)) {New-Item -Path $ContentPath -ItemType Directory -Force -ErrorAction Ignore | Out-Null}
                    Add-ContentPackOSExtraFiles -ContentPackContent $ContentPath
                }
                Get-ChildItem "$ContentPackPath\All Subdirs" -Directory -ErrorAction SilentlyContinue | foreach {Add-ContentPackOSExtraFiles -ContentPackContent "$($_.FullName)"}
                Get-ChildItem "$ContentPackPath\$OSArchitecture Subdirs" -Directory -ErrorAction SilentlyContinue | foreach {Add-ContentPackOSExtraFiles -ContentPackContent "$($_.FullName)"}
            }
        }
        if ($PackType -eq 'OSCapability') {
            Show-ActionTime; Write-Host -ForegroundColor Green "OS: ContentPack OSCapability"
            foreach ($ContentPack in $ContentPacks) {
                $ContentPackPath = Join-Path $SetOSDBuilderPathContentPacks "$ContentPack\OSCapability"

                if (! (Test-Path "$ContentPackPath\$UpdateOS $ReleaseID $OSArchitecture")) {New-Item -Path "$ContentPackPath\$UpdateOS $ReleaseID $OSArchitecture" -ItemType Directory -Force -ErrorAction Ignore | Out-Null}
                Add-ContentPackOSCapability -ContentPackContent "$ContentPackPath\$UpdateOS $ReleaseID $OSArchitecture"

                if (! (Test-Path "$ContentPackPath\$UpdateOS $ReleaseID $OSArchitecture RSAT")) {New-Item -Path "$ContentPackPath\$UpdateOS $ReleaseID $OSArchitecture RSAT" -ItemType Directory -Force -ErrorAction Ignore | Out-Null}
                Add-ContentPackOSCapability -ContentPackContent "$ContentPackPath\$UpdateOS $ReleaseID $OSArchitecture RSAT" -RSAT
            }
        }
        if ($PackType -eq 'OSLanguageFeatures') {
            Show-ActionTime; Write-Host -ForegroundColor Green "OS: ContentPack OSLanguageFeatures"
            foreach ($ContentPack in $ContentPacks) {
                $ContentPackPath = Join-Path $SetOSDBuilderPathContentPacks "$ContentPack\OSLanguageFeatures"
                
                if (! (Test-Path "$ContentPackPath\$UpdateOS $ReleaseID $OSArchitecture")) {New-Item -Path "$ContentPackPath\$UpdateOS $ReleaseID $OSArchitecture" -ItemType Directory -Force -ErrorAction Ignore | Out-Null}
                Add-ContentPackOSLanguageFeatures -ContentPackContent "$ContentPackPath\$UpdateOS $ReleaseID $OSArchitecture"
            }
        }
        if ($PackType -eq 'OSLanguagePacks') {
            Show-ActionTime; Write-Host -ForegroundColor Green "OS: ContentPack OSLanguagePacks"
            foreach ($ContentPack in $ContentPacks) {
                $ContentPackPath = Join-Path $SetOSDBuilderPathContentPacks "$ContentPack\OSLanguagePacks"
                
                if (! (Test-Path "$ContentPackPath\$UpdateOS $ReleaseID $OSArchitecture")) {New-Item -Path "$ContentPackPath\$UpdateOS $ReleaseID $OSArchitecture" -ItemType Directory -Force -ErrorAction Ignore | Out-Null}
                Add-ContentPackOSLanguagePacks -ContentPackContent "$ContentPackPath\$UpdateOS $ReleaseID $OSArchitecture"
            }
        }
        if ($PackType -eq 'OSLocalExperiencePacks') {
            Show-ActionTime; Write-Host -ForegroundColor Green "OS: ContentPack OSLocalExperiencePacks"
            foreach ($ContentPack in $ContentPacks) {
                $ContentPackPath = Join-Path $SetOSDBuilderPathContentPacks "$ContentPack\OSLocalExperiencePacks"
                
                if (! (Test-Path "$ContentPackPath\$UpdateOS $ReleaseID $OSArchitecture")) {New-Item -Path "$ContentPackPath\$UpdateOS $ReleaseID $OSArchitecture" -ItemType Directory -Force -ErrorAction Ignore | Out-Null}
                Add-ContentPackOSLocalExperiencePacks -ContentPackContent "$ContentPackPath\$UpdateOS $ReleaseID $OSArchitecture"
            }
        }
        if ($PackType -eq 'OSPackages') {
            Show-ActionTime; Write-Host -ForegroundColor Green "OS: ContentPack OSPackages"
            foreach ($ContentPack in $ContentPacks) {
                $ContentPackPath = Join-Path $SetOSDBuilderPathContentPacks "$ContentPack\OSPackages"
                
                if (! (Test-Path "$ContentPackPath\$UpdateOS $ReleaseID $OSArchitecture")) {New-Item -Path "$ContentPackPath\$UpdateOS $ReleaseID $OSArchitecture" -ItemType Directory -Force -ErrorAction Ignore | Out-Null}
                Add-ContentPackOSPackages -ContentPackContent "$ContentPackPath\$UpdateOS $ReleaseID $OSArchitecture"
            }
        }
        if ($PackType -eq 'OSPoshMods') {
            Show-ActionTime; Write-Host -ForegroundColor Green "OS: ContentPack OSPoshMods"
            foreach ($ContentPack in $ContentPacks) {
                $ContentPackPath = Join-Path $SetOSDBuilderPathContentPacks "$ContentPack\OSPoshMods"

                if (! (Test-Path "$ContentPackPath\ProgramFiles")) {New-Item -Path "$ContentPackPath\ProgramFiles" -ItemType Directory -Force -ErrorAction Ignore | Out-Null}
                Add-ContentPackOSPoshMods -ContentPackContent "$ContentPackPath\ProgramFiles"
            }
            foreach ($ContentPack in $ContentPacks) {
                $ContentPackPath = Join-Path $SetOSDBuilderPathContentPacks "$ContentPack\OSPoshMods"

                if (! (Test-Path "$ContentPackPath\System")) {New-Item -Path "$ContentPackPath\System" -ItemType Directory -Force -ErrorAction Ignore | Out-Null}
                Add-ContentPackOSPoshModsSystem -ContentPackContent "$ContentPackPath\System"
            }
        }
        if ($PackType -eq 'OSRegistry') {
            Show-ActionTime; Write-Host -ForegroundColor Green "OS: ContentPack OSRegistry"
            foreach ($ContentPack in $ContentPacks) {
                $ContentPackPath = Join-Path $SetOSDBuilderPathContentPacks "$ContentPack\OSRegistry"

                $ContentPaths = @(
                    "$ContentPackPath\ALL"
                    "$ContentPackPath\$OSArchitecture"
                    "$ContentPackPath\$UpdateOS $ReleaseID $OSArchitecture"
                )
                foreach ($ContentPath in $ContentPaths) {
                    if (! (Test-Path $ContentPath)) {New-Item -Path $ContentPath -ItemType Directory -Force -ErrorAction Ignore | Out-Null}
                    Add-ContentPackOSRegistry -ContentPackContent $ContentPath
                }
            }
        }
        if ($PackType -eq 'OSScripts') {
            Show-ActionTime; Write-Host -ForegroundColor Green "OS: ContentPack OSScripts"
            foreach ($ContentPack in $ContentPacks) {
                $ContentPackPath = Join-Path $SetOSDBuilderPathContentPacks "$ContentPack\OSScripts"

                $ContentPaths = @(
                    "$ContentPackPath\ALL"
                    "$ContentPackPath\$OSArchitecture"
                    "$ContentPackPath\$UpdateOS $ReleaseID $OSArchitecture"
                )
                foreach ($ContentPath in $ContentPaths) {
                    if (! (Test-Path $ContentPath)) {New-Item -Path $ContentPath -ItemType Directory -Force -ErrorAction Ignore | Out-Null}
                    Add-ContentPackOSScripts -ContentPackContent $ContentPath
                }
            }
        }
        if ($PackType -eq 'OSStartLayout') {
            Show-ActionTime; Write-Host -ForegroundColor Green "OS: ContentPack OSStartLayout"
            foreach ($ContentPack in $ContentPacks) {
                $ContentPackPath = Join-Path $SetOSDBuilderPathContentPacks "$ContentPack\OSStartLayout"

                $ContentPaths = @(
                    "$ContentPackPath\ALL"
                    "$ContentPackPath\$OSArchitecture"
                    "$ContentPackPath\$UpdateOS $ReleaseID $OSArchitecture"
                )
                foreach ($ContentPath in $ContentPaths) {
                    if (! (Test-Path $ContentPath)) {New-Item -Path $ContentPath -ItemType Directory -Force -ErrorAction Ignore | Out-Null}
                    Add-ContentPackOSStartLayouts -ContentPackContent $ContentPath
                }
            }
        }
        #=================================================
        #   WinPE ContentPacks
        #=================================================
        if ($PackType -eq 'PEADK') {
            Show-ActionTime; Write-Host -ForegroundColor Green "WinPE: ContentPack PEADK"
            foreach ($ContentPack in $ContentPacks) {
                $ContentPackPath = Join-Path $SetOSDBuilderPathContentPacks "$ContentPack\PEADK"
                if (! (Test-Path "$ContentPackPath\$UpdateOS $ReleaseID $OSArchitecture")) {New-Item -Path "$ContentPackPath\$UpdateOS $ReleaseID $OSArchitecture" -ItemType Directory -Force -ErrorAction Ignore | Out-Null}
                Add-ContentPackPEADK -ContentPackContent "$ContentPackPath\$UpdateOS $ReleaseID $OSArchitecture"
            }
        }
        if ($PackType -eq 'PEADKLang') {
            Show-ActionTime; Write-Host -ForegroundColor Green "WinPE: ContentPack PEADKLang"
            foreach ($ContentPack in $ContentPacks) {
                $ContentPackPath = Join-Path $SetOSDBuilderPathContentPacks "$ContentPack\PEADKLang"
                if (! (Test-Path "$ContentPackPath\$UpdateOS $ReleaseID $OSArchitecture")) {New-Item -Path "$ContentPackPath\$UpdateOS $ReleaseID $OSArchitecture" -ItemType Directory -Force -ErrorAction Ignore | Out-Null}
                Add-ContentPackPEADK -ContentPackContent "$ContentPackPath\$UpdateOS $ReleaseID $OSArchitecture" -Lang
            }
        }
        if ($PackType -eq 'PEDaRT') {
            Show-ActionTime; Write-Host -ForegroundColor Green "WinPE: ContentPack PEDaRT"
            foreach ($ContentPack in $ContentPacks) {
                $ContentPackPath = Join-Path $SetOSDBuilderPathContentPacks "$ContentPack\PEDaRT"
                if (! (Test-Path $ContentPackPath)) {New-Item -Path $ContentPackPath -ItemType Directory -Force -ErrorAction Ignore | Out-Null}
                Add-ContentPackPEDaRT -ContentPackContent "$ContentPackPath"
            }
        }
        if ($PackType -eq 'PEDrivers') {
            Show-ActionTime; Write-Host -ForegroundColor Green "WinPE: ContentPack PEDrivers"
            foreach ($ContentPack in $ContentPacks) {
                $ContentPackPath = Join-Path $SetOSDBuilderPathContentPacks "$ContentPack\PEDrivers"

                $ContentPaths = @(
                    "$ContentPackPath\ALL"
                    "$ContentPackPath\$OSArchitecture"
                    "$ContentPackPath\$UpdateOS $ReleaseID $OSArchitecture"
                )
                foreach ($ContentPath in $ContentPaths) {
                    if (! (Test-Path $ContentPath)) {New-Item -Path $ContentPath -ItemType Directory -Force -ErrorAction Ignore | Out-Null}
                    Add-ContentPackPEDrivers -ContentPackContent $ContentPath
                }
            }
        }
        if ($PackType -eq 'PEExtraFiles') {
            Show-ActionTime; Write-Host -ForegroundColor Green "WinPE: ContentPack PEExtraFiles"
            foreach ($ContentPack in $ContentPacks) {
                $ContentPackPath = Join-Path $SetOSDBuilderPathContentPacks "$ContentPack\PEExtraFiles"

                $ContentPaths = @(
                    "$ContentPackPath\ALL"
                    "$ContentPackPath\$OSArchitecture"
                    "$ContentPackPath\$UpdateOS $ReleaseID $OSArchitecture"
                )
                foreach ($ContentPath in $ContentPaths) {
                    if (! (Test-Path $ContentPath)) {New-Item -Path $ContentPath -ItemType Directory -Force -ErrorAction Ignore | Out-Null}
                    Add-ContentPackPEExtraFiles -ContentPackContent $ContentPath
                }

                Get-ChildItem "$ContentPackPath\ALL Subdirs" -Directory -ErrorAction SilentlyContinue | foreach {
                    Add-ContentPackPEExtraFiles -ContentPackContent "$($_.FullName)"
                }
                Get-ChildItem "$ContentPackPath\$OSArchitecture Subdirs" -Directory -ErrorAction SilentlyContinue | foreach {
                    Add-ContentPackPEExtraFiles -ContentPackContent "$($_.FullName)"
                }
            }
        }
        if ($PackType -eq 'PEPoshMods') {
            Show-ActionTime; Write-Host -ForegroundColor Green "WinPE: ContentPack PEPoshMods"
            foreach ($ContentPack in $ContentPacks) {
                $ContentPackPath = Join-Path $SetOSDBuilderPathContentPacks "$ContentPack\PEPoshMods"

                if (! (Test-Path "$ContentPackPath\ProgramFiles")) {New-Item -Path "$ContentPackPath\ProgramFiles" -ItemType Directory -Force -ErrorAction Ignore | Out-Null}
                Add-ContentPackPEPoshMods -ContentPackContent "$ContentPackPath\ProgramFiles"
            }
            foreach ($ContentPack in $ContentPacks) {
                $ContentPackPath = Join-Path $SetOSDBuilderPathContentPacks "$ContentPack\PEPoshMods"
                
                if (! (Test-Path "$ContentPackPath\System")) {New-Item -Path "$ContentPackPath\System" -ItemType Directory -Force -ErrorAction Ignore | Out-Null}
                Add-ContentPackPEPoshModsSystem -ContentPackContent "$ContentPackPath\System"
            }
        }
        if ($PackType -eq 'PERegistry') {
            Show-ActionTime; Write-Host -ForegroundColor Green "WinPE: ContentPack PERegistry"
            foreach ($ContentPack in $ContentPacks) {
                $ContentPackPath = Join-Path $SetOSDBuilderPathContentPacks "$ContentPack\PERegistry"

                $ContentPaths = @(
                    "$ContentPackPath\ALL"
                    "$ContentPackPath\$OSArchitecture"
                    "$ContentPackPath\$UpdateOS $ReleaseID $OSArchitecture"
                )
                foreach ($ContentPath in $ContentPaths) {
                    if (! (Test-Path $ContentPath)) {New-Item -Path $ContentPath -ItemType Directory -Force -ErrorAction Ignore | Out-Null}
                    Add-ContentPackPERegistry -ContentPackContent $ContentPath
                }
            }
        }
        if ($PackType -eq 'PEScripts') {
            Show-ActionTime; Write-Host -ForegroundColor Green "WinPE: ContentPack PEScripts"
            foreach ($ContentPack in $ContentPacks) {
                $ContentPackPath = Join-Path $SetOSDBuilderPathContentPacks "$ContentPack\PEScripts"

                $ContentPaths = @(
                    "$ContentPackPath\ALL"
                    "$ContentPackPath\$OSArchitecture"
                    "$ContentPackPath\$UpdateOS $ReleaseID $OSArchitecture"
                )
                foreach ($ContentPath in $ContentPaths) {
                    if (! (Test-Path $ContentPath)) {New-Item -Path $ContentPath -ItemType Directory -Force -ErrorAction Ignore | Out-Null}
                    Add-ContentPackPEScripts -ContentPackContent $ContentPath
                }
            }
        }
    }
}
function Add-ContentPackMEDIA {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$ContentPackContent
    )
    Write-Host -ForegroundColor DarkGray "AutoApply Content $ContentPackContent"
    #======================================================================================
    #   Test
    #======================================================================================
    if (!(Test-Path "$ContentPackContent\*")) {
        Write-Verbose "Add-ContentPackMEDIA: Unable to locate content in $ContentPackContent"
        Return
    } else {
        Write-Host "$ContentPackContent" -ForegroundColor Cyan
    }
    #======================================================================================
    #   Import
    #======================================================================================
    $CurrentLog = "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Add-ContentPackMEDIA.log"
    Write-Verbose "CurrentLog: $CurrentLog"

    Get-ChildItem "$ContentPackContent" *.* -File -Recurse | Select-Object -Property FullName | foreach {Write-Host "$($_.FullName)" -ForegroundColor DarkGray}

    robocopy "$ContentPackContent" "$OS" *.* /s /ndl /xx /b /np /ts /tee /r:0 /w:0 /Log+:"$CurrentLog" | Out-Null
}
function Add-ContentPackOSDrivers {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$ContentPackContent
        #[string]$MountDirectory
    )
    Write-Host -ForegroundColor DarkGray "AutoApply Content $ContentPackContent"
    #======================================================================================
    #   Test
    #======================================================================================
    if (!(Test-Path "$ContentPackContent\*")) {
        Write-Verbose "Add-ContentPackOSDrivers: Unable to locate content in $ContentPackContent"
        Return
    } else {
        Write-Host "$ContentPackContent" -ForegroundColor Cyan
    }
    #======================================================================================
    #   Import
    #======================================================================================
    $CurrentLog = "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Add-ContentPackOSDrivers.log"
    Write-Verbose "CurrentLog: $CurrentLog"

    Get-ChildItem "$ContentPackContent" *.inf -File -Recurse | Select-Object -Property FullName | foreach {Write-Host "$($_.FullName)" -ForegroundColor DarkGray}

    if ($OSMajorVersion -eq 6) {
        dism /Image:"$MountDirectory" /Add-Driver /Driver:"$ContentPackContent" /Recurse /ForceUnsigned /LogPath:"$CurrentLog"
    } else {
        Add-WindowsDriver -Driver "$ContentPackContent" -Recurse -Path "$MountDirectory" -ForceUnsigned -LogPath "$CurrentLog" | Out-Null
    }
}
function Add-ContentPackOSExtraFiles {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$ContentPackContent
    )
    Write-Host -ForegroundColor DarkGray "AutoApply Content $ContentPackContent"
    #======================================================================================
    #   Test
    #======================================================================================
    if (!(Test-Path "$ContentPackContent\*")) {
        Write-Verbose "Add-ContentPackOSExtraFiles: Unable to locate content in $ContentPackContent"
        Return
    } else {
        Write-Host "$ContentPackContent" -ForegroundColor Cyan
    }
    #======================================================================================
    #   Import
    #======================================================================================
    $CurrentLog = "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Add-ContentPackOSExtraFiles.log"
    Write-Verbose "CurrentLog: $CurrentLog"

    Get-ChildItem "$ContentPackContent" *.* -File -Recurse | Select-Object -Property FullName | foreach {Write-Host "$($_.FullName)" -ForegroundColor DarkGray}

    robocopy "$ContentPackContent" "$MountDirectory" *.* /s /ndl /xx /b /np /ts /tee /r:0 /w:0 /Log+:"$CurrentLog" | Out-Null
}
function Add-ContentPackOSCapability {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$ContentPackContent,
        [switch]$RSAT
    )
    Write-Host -ForegroundColor DarkGray "AutoApply Content $ContentPackContent"
    #======================================================================================
    #   Test
    #======================================================================================
    if (!(Test-Path "$ContentPackContent\FoDMetadata_Client.cab")) {
        Write-Verbose "Add-ContentPackOSCapability: Unable to locate content in $ContentPackContent"
        Return
    } else {
        $global:ReapplyLCU = $true
        Write-Host "$ContentPackContent" -ForegroundColor Cyan
    }
    #======================================================================================
    #   Import
    #======================================================================================
    if (Get-Command Get-WindowsCapability) {
        if ($RSAT.IsPresent) {
            if ((Get-Command Get-WindowsCapability).Parameters.ContainsKey('LimitAccess')) {
                Get-WindowsCapability -Path $MountDirectory -LimitAccess | Where-Object {$_.Name -match 'RSAT'} | Where-Object {$_.State -eq 'NotPresent'} | foreach {
                    $CurrentLog = "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-ContentPackOSCapability-$($_.Name).log"
                    Write-Verbose "CurrentLog: $CurrentLog"
            
                    Write-Host "$($_.Name)" -ForegroundColor DarkGray
                    Try {
                        Add-WindowsCapability -Path $MountDirectory -Name $_.Name -Source $ContentPackContent -LimitAccess -LogPath $CurrentLog | Out-Null
                    }
                    Catch {
                        if ($_.Exception.Message -match '0x800f081e') {
                            Write-Verbose "OSDBuilder: 0x800f081e The package is not applicable to this image" -Verbose
                        } else {
                            Write-Warning $_.Exception.ErrorCode
                            Write-Warning $_.Exception.Message
                        }
                    }
                }
            } else {
                Get-WindowsCapability -Path $MountDirectory | Where-Object {$_.Name -match 'RSAT'} | Where-Object {$_.State -eq 'NotPresent'} | foreach {
                    $CurrentLog = "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-ContentPackOSCapability-$($_.Name).log"
                    Write-Verbose "CurrentLog: $CurrentLog"
            
                    Write-Host "$($_.Name)" -ForegroundColor DarkGray
                    Try {
                        Add-WindowsCapability -Path $MountDirectory -Name $_.Name -Source $ContentPackContent -LogPath $CurrentLog | Out-Null
                    }
                    Catch {
                        if ($_.Exception.Message -match '0x800f081e') {
                            Write-Verbose "OSDBuilder: 0x800f081e The package is not applicable to this image" -Verbose
                        } else {
                            Write-Warning $_.Exception.ErrorCode
                            Write-Warning $_.Exception.Message
                        }
                    }
                }
            }
        } else {
            if ((Get-Command Get-WindowsCapability).Parameters.ContainsKey('LimitAccess')) {
                Get-WindowsCapability -Path $MountDirectory -LimitAccess | Where-Object {$_.Name -notmatch 'Language'} | Where-Object {$_.Name -notmatch 'RSAT'} | Where-Object {$_.State -eq 'NotPresent'} | foreach {
                    $CurrentLog = "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-ContentPackOSCapability-$($_.Name).log"
                    Write-Verbose "CurrentLog: $CurrentLog"
            
                    Write-Host "$($_.Name)" -ForegroundColor DarkGray
                    Try {
                        Add-WindowsCapability -Path $MountDirectory -Name $_.Name -Source $ContentPackContent -LimitAccess -LogPath $CurrentLog | Out-Null
                    }
                    Catch {
                        if ($_.Exception.Message -match '0x800f081e') {
                            Write-Verbose "OSDBuilder: 0x800f081e The package is not applicable to this image" -Verbose
                        } else {
                            Write-Warning $_.Exception.ErrorCode
                            Write-Warning $_.Exception.Message
                        }
                    }
                }
            } else {
                Get-WindowsCapability -Path $MountDirectory | Where-Object {$_.Name -notmatch 'Language'} | Where-Object {$_.Name -notmatch 'RSAT'} | Where-Object {$_.State -eq 'NotPresent'} | foreach {
                    $CurrentLog = "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-ContentPackOSCapability-$($_.Name).log"
                    Write-Verbose "CurrentLog: $CurrentLog"
            
                    Write-Host "$($_.Name)" -ForegroundColor DarkGray
                    Try {
                        Add-WindowsCapability -Path $MountDirectory -Name $_.Name -Source $ContentPackContent -LogPath $CurrentLog | Out-Null
                    }
                    Catch {
                        if ($_.Exception.Message -match '0x800f081e') {
                            Write-Verbose "OSDBuilder: 0x800f081e The package is not applicable to this image" -Verbose
                        } else {
                            Write-Warning $_.Exception.ErrorCode
                            Write-Warning $_.Exception.Message
                        }
                    }
                }
            }
        }
    }
<#     if ($RSAT.IsPresent) {
        Get-WindowsCapability -Path $MountDirectory -LimitAccess | Where-Object {$_.Name -match 'RSAT'} | Where-Object {$_.State -eq 'NotPresent'} | foreach {
            $CurrentLog = "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-ContentPackOSCapability-$($_.Name).log"
            Write-Verbose "CurrentLog: $CurrentLog"
    
            Write-Host "$($_.Name)" -ForegroundColor DarkGray
            Try {
                Add-WindowsCapability -Path $MountDirectory -Name $_.Name -Source $ContentPackContent -LimitAccess -LogPath $CurrentLog | Out-Null
            }
            Catch {
                if ($_.Exception.Message -match '0x800f081e') {
                    Write-Verbose "OSDBuilder: 0x800f081e The package is not applicable to this image" -Verbose
                } else {
                    Write-Warning $_.Exception.ErrorCode
                    Write-Warning $_.Exception.Message
                }
            }
        }
    } else {
        Get-WindowsCapability -Path $MountDirectory -LimitAccess | Where-Object {$_.Name -notmatch 'Language'} | Where-Object {$_.Name -notmatch 'RSAT'} | Where-Object {$_.State -eq 'NotPresent'} | foreach {
            $CurrentLog = "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-ContentPackOSCapability-$($_.Name).log"
            Write-Verbose "CurrentLog: $CurrentLog"
    
            Write-Host "$($_.Name)" -ForegroundColor DarkGray
            Try {
                Add-WindowsCapability -Path $MountDirectory -Name $_.Name -Source $ContentPackContent -LimitAccess -LogPath $CurrentLog | Out-Null
            }
            Catch {
                if ($_.Exception.Message -match '0x800f081e') {
                    Write-Verbose "OSDBuilder: 0x800f081e The package is not applicable to this image" -Verbose
                } else {
                    Write-Warning $_.Exception.ErrorCode
                    Write-Warning $_.Exception.Message
                }
            }
        }
    } #>
<#     $OSFeaturesFiles = Get-ChildItem "$ContentPackContent\*" -Include *.cab -File -Recurse | Sort-Object Name | Select-Object Name, FullName, Directory
    Pause
    Get-WindowsCapability -Offline -Path $MountDirectory
    foreach ($item in $OSFeaturesFiles) {
        $CurrentLog = "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-ContentPackOSCapability-$($item.Name).log"
        Write-Verbose "CurrentLog: $CurrentLog"
        Write-Host "$($item.FullName)" -ForegroundColor DarkGray

        if ($MountDirectory) {
            Try {Add-WindowsCapability -Name $item.FullName -Path $MountDirectory -Source $item.Directory -LimitAccess -LogPath $CurrentLog | Out-Null}
            Catch {
                if ($_.Exception.Message -match '0x800f081e') {Write-Verbose "OSDBuilder: 0x800f081e The package is not applicable to this image" -Verbose}
                Write-Verbose "$CurrentLog" -Verbose
            }
            Try {Add-WindowsPackage -PackagePath "$($item.FullName)" -Path "$MountDirectory" -LogPath $CurrentLog | Out-Null}
            Catch {
                if ($_.Exception.Message -match '0x800f081e') {Write-Verbose "OSDBuilder: 0x800f081e The package is not applicable to this image" -Verbose}
                Write-Verbose "$CurrentLog" -Verbose
            }
        }
    } #>
}
function Add-ContentPackOSLanguageFeatures {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$ContentPackContent
    )
    Write-Host -ForegroundColor DarkGray "AutoApply Content $ContentPackContent"
    #======================================================================================
    #   Test
    #======================================================================================
    if (!(Test-Path "$ContentPackContent\*")) {
        Write-Verbose "Add-ContentPackOSLanguageFeatures: Unable to locate content in $ContentPackContent"
        Return
    } else {
        Write-Host "$ContentPackContent" -ForegroundColor Cyan
    }
    #======================================================================================
    #   Import
    #======================================================================================
    $OSLanguageFeaturesFiles = Get-ChildItem "$ContentPackContent\*" -Include *.cab -File -Recurse | Sort-Object Length -Descending | Select-Object Name, FullName

    foreach ($OSLanguageFeaturesFile in $OSLanguageFeaturesFiles) {
        $CurrentLog = "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-ContentPackOSLanguageFeatures-$($OSLanguageFeaturesFile.Name).log"
        Write-Verbose "CurrentLog: $CurrentLog"
        Write-Host "$($OSLanguageFeaturesFile.FullName)" -ForegroundColor DarkGray

        if ($MountDirectory) {
            Try {
                $global:ReapplyLCU = $true
                Add-WindowsPackage -PackagePath "$($OSLanguageFeaturesFile.FullName)" -Path "$MountDirectory" -LogPath $CurrentLog | Out-Null
            }
            Catch {
                if ($_.Exception.Message -match '0x800f081e') {Write-Verbose "OSDBuilder: 0x800f081e The package is not applicable to this image" -Verbose}
                Write-Verbose "$CurrentLog" -Verbose
            }
        }
    }
}
function Add-ContentPackOSLanguagePacks {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$ContentPackContent
    )
    Write-Host -ForegroundColor DarkGray "AutoApply Content $ContentPackContent"
    #======================================================================================
    #   Test
    #======================================================================================
    if (!(Test-Path "$ContentPackContent\*")) {
        Write-Verbose "Add-ContentPackOSLanguagePacks: Unable to locate content in $ContentPackContent"
        Return
    } else {
        Write-Host "$ContentPackContent" -ForegroundColor Cyan
    }
    #======================================================================================
    #   Import
    #======================================================================================
    $OSLanguagePacksFiles = Get-ChildItem "$ContentPackContent\*" -Include *.cab -File | Sort-Object Length -Descending | Select-Object Name, FullName

    foreach ($OSLanguagePacksFile in $OSLanguagePacksFiles) {
        $global:ReapplyLCU = $true
        $global:UpdateLanguageContent = $true
        $CurrentLog = "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-ContentPackOSLanguagePacks-$($OSLanguagePacksFile.Name).log"
        Write-Verbose "CurrentLog: $CurrentLog"
        Write-Host "$($OSLanguagePacksFile.FullName)" -ForegroundColor DarkGray

        if ($MountDirectory) {
            Try {Add-WindowsPackage -PackagePath "$($OSLanguagePacksFile.FullName)" -Path "$MountDirectory" -LogPath $CurrentLog | Out-Null}
            Catch {
                if ($_.Exception.Message -match '0x800f081e') {Write-Verbose "OSDBuilder: 0x800f081e The package is not applicable to this image" -Verbose}
                Write-Verbose "$CurrentLog" -Verbose
            }
        }
    }
}
function Add-ContentPackOSLocalExperiencePacks {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$ContentPackContent
    )
    Write-Host -ForegroundColor DarkGray "AutoApply Content $ContentPackContent"
    #======================================================================================
    #   Test
    #======================================================================================
    if (!(Test-Path "$ContentPackContent\*")) {
        Write-Verbose "Add-ContentPackOSLocalExperiencePacks: Unable to locate content in $ContentPackContent"
        Return
    } else {
        Write-Host "$ContentPackContent" -ForegroundColor Cyan
    }
    #======================================================================================
    #   Import
    #======================================================================================
    $OSLocalExperiencePacksFiles = Get-ChildItem "$ContentPackContent" *.appx -File -Recurse | Sort-Object Length -Descending | Select-Object Name, FullName

    foreach ($OSLocalExperiencePacksFile in $OSLocalExperiencePacksFiles) {
        $CurrentLog = "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-ContentPackOSLocalExperiencePacks-$($OSLocalExperiencePacksFile.Name).log"
        Write-Verbose "CurrentLog: $CurrentLog"
        Write-Host "$($OSLocalExperiencePacksFile.FullName)" -ForegroundColor DarkGray

        if ($MountDirectory) {
            $LicensePath = "$((Get-Item $OSLocalExperiencePacksFile.FullName).Directory.FullName)\License.xml"
            if (!(Test-Path $LicensePath)) {
                Write-Warning "Unable to find Appx License at $LicensePath"
            } else {
                Try {
                    $global:ReapplyLCU = $true
                    Add-AppxProvisionedPackage -Path "$MountDirectory" -PackagePath $OSLocalExperiencePacksFile.FullName -LicensePath $LicensePath -LogPath $CurrentLog | Out-Null
                }
                Catch {$ErrorMessage = $_.Exception.$ErrorMessage; Write-Warning "$CurrentLog"; Write-Host "$ErrorMessage"}
            }
        }
    }
}
function Add-ContentPackOSPackages {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$ContentPackContent
    )
    Write-Host -ForegroundColor DarkGray "AutoApply Content $ContentPackContent"
    #======================================================================================
    #   Test
    #======================================================================================
    if (!(Test-Path "$ContentPackContent\*")) {
        Write-Verbose "Add-ContentPackOSPackages: Unable to locate content in $ContentPackContent"
        Return
    } else {
        Write-Host "$ContentPackContent" -ForegroundColor Cyan
    }
    #======================================================================================
    #   Import
    #======================================================================================
    $OSPackagesFiles = Get-ChildItem "$ContentPackContent\*" -Include *.cab -File -Recurse | Sort-Object Name | Select-Object Name, FullName

    foreach ($item in $OSPackagesFiles) {
        $CurrentLog = "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-ContentPackOSPackages-$($item.Name).log"
        Write-Verbose "CurrentLog: $CurrentLog"
        Write-Host "$($item.FullName)" -ForegroundColor DarkGray

        if ($MountDirectory) {
            Try {
                $global:ReapplyLCU = $true
                Add-WindowsPackage -PackagePath "$($item.FullName)" -Path "$MountDirectory" -LogPath $CurrentLog | Out-Null
            }
            Catch {
                if ($_.Exception.Message -match '0x800f081e') {Write-Verbose "OSDBuilder: 0x800f081e The package is not applicable to this image" -Verbose}
                Write-Verbose "$CurrentLog" -Verbose
            }
        }
    }
}
function Add-ContentPackOSPoshMods {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$ContentPackContent
    )
    Write-Host -ForegroundColor DarkGray "AutoApply Content $ContentPackContent"
    Write-Warning "OSPoshMods is being deprecated in the near future"
    #======================================================================================
    #   Test
    #======================================================================================
    if (!(Test-Path "$ContentPackContent\*")) {
        Write-Verbose "Add-ContentPackOSPoshMods: Unable to locate content in $ContentPackContent"
        Return
    } else {
        Write-Host "$ContentPackContent" -ForegroundColor Cyan
    }
    #======================================================================================
    #   Import
    #======================================================================================
    $CurrentLog = "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Add-ContentPackOSPoshMods.log"
    Write-Verbose "CurrentLog: $CurrentLog"

    Get-ChildItem "$ContentPackContent" *.* -File -Recurse | Select-Object -Property FullName | foreach {Write-Host "$($_.FullName)" -ForegroundColor DarkGray}

    robocopy "$ContentPackContent" "$MountDirectory\Program Files\WindowsPowerShell\Modules" *.* /s /ndl /xx /b /np /ts /tee /r:0 /w:0 /Log+:"$CurrentLog" | Out-Null
}
function Add-ContentPackOSPoshModsSystem {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$ContentPackContent
    )
    Write-Host -ForegroundColor DarkGray "AutoApply Content $ContentPackContent"
    Write-Warning "OSPoshModsSystem is being deprecated in the near future"
    #======================================================================================
    #   Test
    #======================================================================================
    if (!(Test-Path "$ContentPackContent\*")) {
        Write-Verbose "Add-ContentPackOSPoshModsSystem: Unable to locate content in $ContentPackContent"
        Return
    } else {
        Write-Host "$ContentPackContent" -ForegroundColor Cyan
    }
    #======================================================================================
    #   Import
    #======================================================================================
    $CurrentLog = "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Add-ContentPackOSPoshModsSystem.log"
    Write-Verbose "CurrentLog: $CurrentLog"

    Get-ChildItem "$ContentPackContent" *.* -File -Recurse | Select-Object -Property FullName | foreach {Write-Host "$($_.FullName)" -ForegroundColor DarkGray}

    robocopy "$ContentPackContent" "$MountDirectory\Windows\System32\WindowsPowerShell\v1.0\Modules" *.* /s /ndl /xx /b /np /ts /tee /r:0 /w:0 /Log+:"$CurrentLog" | Out-Null
}
function Add-ContentPackOSRegistry {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$ContentPackContent,

        [switch]$ShowRegContent
    )
    Write-Host -ForegroundColor DarkGray "AutoApply Content $ContentPackContent"
    #======================================================================================
    #   Test-OSDContentPackOSRegistry
    #======================================================================================
    if (!(Test-Path "$ContentPackContent\*")) {
        Write-Verbose "Add-ContentPackOSRegistry: Unable to locate content in $ContentPackContent"
        Return
    } else {
        Write-Host "$ContentPackContent" -ForegroundColor Cyan
    }

    #======================================================================================
    #   Mount-OfflineRegistryHives
    #======================================================================================
    if (($MountDirectory) -and (Test-Path "$MountDirectory" -ErrorAction SilentlyContinue)) {
        if (Test-Path "$MountDirectory\Users\Default\NTUser.dat") {
            Write-Verbose "Loading Offline Registry Hive Default User" 
            Start-Process reg -ArgumentList "load HKLM\OfflineDefaultUser $MountDirectory\Users\Default\NTUser.dat" -Wait -WindowStyle Hidden -ErrorAction SilentlyContinue
        }
        if (Test-Path "$MountDirectory\Windows\System32\Config\DEFAULT") {
            Write-Verbose "Loading Offline Registry Hive DEFAULT" 
            Start-Process reg -ArgumentList "load HKLM\OfflineDefault $MountDirectory\Windows\System32\Config\DEFAULT" -Wait -WindowStyle Hidden -ErrorAction SilentlyContinue
        }
        if (Test-Path "$MountDirectory\Windows\System32\Config\SOFTWARE") {
            Write-Verbose "Loading Offline Registry Hive SOFTWARE" 
            Start-Process reg -ArgumentList "load HKLM\OfflineSoftware $MountDirectory\Windows\System32\Config\SOFTWARE" -Wait -WindowStyle Hidden -ErrorAction Stop
        }
        if (Test-Path "$MountDirectory\Windows\System32\Config\SYSTEM") {
            Write-Verbose "Loading Offline Registry Hive SYSTEM" 
            Start-Process reg -ArgumentList "load HKLM\OfflineSystem $MountDirectory\Windows\System32\Config\SYSTEM" -Wait -WindowStyle Hidden -ErrorAction Stop
        }
        $OSDContentPackTemp = "$env:TEMP\$(Get-Random)"
        if (!(Test-Path $OSDContentPackTemp)) {New-Item -Path "$OSDContentPackTemp" -ItemType Directory -Force | Out-Null}
    }

    #======================================================================================
    #   Get-RegFiles
    #======================================================================================
    [array]$ContentPackContentFiles = @()
    [array]$ContentPackContentFiles = Get-ChildItem "$ContentPackContent" *.reg -Recurse | Select-Object -Property Name, BaseName, Extension, Directory, FullName

    #======================================================================================
    #	Add-ContentPackOSRegistryFiles
    #======================================================================================
    foreach ($OSDRegistryRegFile in $ContentPackContentFiles) {
        $OSDRegistryImportFile = $OSDRegistryRegFile.FullName

        if ($MountDirectory) {
            $RegFileContent = Get-Content -Path $OSDRegistryImportFile
            $OSDRegistryImportFile = "$OSDContentPackTemp\$($OSDRegistryRegFile.BaseName).reg"

            $RegFileContent = $RegFileContent -replace 'HKEY_CURRENT_USER','HKEY_LOCAL_MACHINE\OfflineDefaultUser'
            $RegFileContent = $RegFileContent -replace 'HKEY_LOCAL_MACHINE\\SOFTWARE','HKEY_LOCAL_MACHINE\OfflineSoftware'
            $RegFileContent = $RegFileContent -replace 'HKEY_LOCAL_MACHINE\\SYSTEM','HKEY_LOCAL_MACHINE\OfflineSystem'
            $RegFileContent = $RegFileContent -replace 'HKEY_USERS\\.DEFAULT','HKEY_LOCAL_MACHINE\OfflineDefault'
            $RegFileContent | Set-Content -Path $OSDRegistryImportFile -Force
        }

        Write-Host "$OSDRegistryImportFile"  -ForegroundColor DarkGray
        if ($ShowRegContent.IsPresent){
            $OSDContentPackRegFileContent = @()
            $OSDContentPackRegFileContent = Get-Content -Path $OSDRegistryImportFile
            foreach ($Line in $OSDContentPackRegFileContent) {
                Write-Host "$Line" -ForegroundColor Gray
            }
        }
        Start-Process reg -ArgumentList ('import',"`"$OSDRegistryImportFile`"") -Wait -WindowStyle Hidden -ErrorAction SilentlyContinue
    }
    
    #======================================================================================
    #	Remove-OSDContentPackTemp
    #======================================================================================
    if ($MountDirectory) {
        if (Test-Path $OSDContentPackTemp) {Remove-Item -Path "$OSDContentPackTemp" -Recurse -Force | Out-Null}
    }

    #======================================================================================
    #	Dismount-RegistryHives
    #======================================================================================
    Dismount-OSDOfflineRegistry -MountPath $MountDirectory
}
function Add-ContentPackOSScripts {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$ContentPackContent
    )
    Write-Host -ForegroundColor DarkGray "AutoApply Content $ContentPackContent"
    #======================================================================================
    #   TEST
    #======================================================================================
    if (!(Test-Path "$ContentPackContent\*")) {
        Write-Verbose "Add-ContentPackOSScripts: Unable to locate content in $ContentPackContent"
        Return
    }
    else {Write-Host "$ContentPackContent" -ForegroundColor Cyan}
    #======================================================================================
    #   BUILD
    #======================================================================================
    $ContentPackOSScripts = Get-ChildItem "$ContentPackContent" *.ps1 -File -Recurse | Select-Object -Property FullName
    foreach ($ContentPackOSScript in $ContentPackOSScripts) {
        Write-Host "$($ContentPackOSScript.FullName)" -ForegroundColor DarkGray
        Invoke-Expression "& '$($ContentPackOSScript.FullName)'"
    }
}
function Add-ContentPackOSStartLayouts {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$ContentPackContent
    )
    Write-Host -ForegroundColor DarkGray "AutoApply Content $ContentPackContent"
    #======================================================================================
    #   TEST
    #======================================================================================
    if (!(Test-Path "$ContentPackContent\*")) {
        Write-Verbose "Add-ContentPackOSStartLayouts: Unable to locate content in $ContentPackContent"
        Return
    }
    else {Write-Host "$ContentPackContent" -ForegroundColor Cyan}
    #======================================================================================
    #   BUILD
    #======================================================================================
    $ContentPackOSStartLayouts = Get-ChildItem "$ContentPackContent\*.xml" -File | Select-Object -Property FullName
    foreach ($ContentPackOSStartLayout in $ContentPackOSStartLayouts) {
        Write-Host "$($ContentPackOSStartLayout.FullName)" -ForegroundColor DarkGray
        Try {
            Copy-Item -Path "$($ContentPackOSStartLayout.FullName)" -Destination "$MountDirectory\Users\Default\AppData\Local\Microsoft\Windows\Shell\LayoutModification.xml" -Recurse -Force | Out-Null
        }
        Catch {
            $ErrorMessage = $_.Exception.Message
            Write-Warning "$ErrorMessage"
        }
    }
}
function Add-ContentPackPEADK {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$ContentPackContent,

        [string]$MountPath,

        [switch]$Lang

        #[ValidateSet('MDT','Recovery','WinPE')]
        #[string]$WinPEOutput,

        #[ValidateSet('WinPE','WinRE')]
        #[string]$SourceWim
    )
    Write-Host -ForegroundColor DarkGray "AutoApply Content $ContentPackContent"
    #======================================================================================
    #   Test
    #======================================================================================
    if (!(Test-Path "$ContentPackContent\*")) {
        Write-Verbose "Add-ContentPackPEADK: Unable to locate content in $ContentPackContent"
        Return
    } else {
        Write-Host "$ContentPackContent" -ForegroundColor Cyan
    }
    if ($Lang.IsPresent) {
        $global:ReapplyLCU = $true
        $global:UpdateLanguageContent = $true
    }
    #======================================================================================
    #   Import
    #======================================================================================
    $ADKFiles = Get-ChildItem "$ContentPackContent\*" -Include *.cab -File | Sort-Object Length -Descending | Select-Object Name, FullName
    $ADKFilesSub = Get-ChildItem "$ContentPackContent\*\*" -Include *.cab -File -Recurse | Sort-Object Length -Descending | Select-Object Name, FullName

    if ($ScriptName -eq 'New-PEBuild') {
        if ($WinPEOutput -eq 'MDT') {}
        if ($WinPEOutput -eq 'Recovery') {}
        if ($WinPEOutput -eq 'WinPE') {}

        if ($SourceWim -eq 'WinPE') {
            $ADKFiles = $ADKFiles | Where-Object {$_.Name -notmatch 'setup'} | Where-Object {$_.Name -notmatch 'wifi'} | Where-Object {$_.Name -notmatch 'appxpackaging'} | Where-Object {$_.Name -notmatch 'rejuv'} | Where-Object {$_.Name -notmatch 'opcservices'}
            $ADKFilesSub = $ADKFilesSub | Where-Object {$_.Name -notmatch 'setup'} | Where-Object {$_.Name -notmatch 'wifi'} | Where-Object {$_.Name -notmatch 'appxpackaging'} | Where-Object {$_.Name -notmatch 'rejuv'} | Where-Object {$_.Name -notmatch 'opcservices'}
        }

        if ($SourceWim -eq 'WinRE') {
            $ADKFiles = $ADKFiles | Where-Object {$_.Name -notmatch 'setup'}
            $ADKFilesSub = $ADKFiles | Where-Object {$_.Name -notmatch 'setup'}
        }

        foreach ($ADKFile in $ADKFiles | Where-Object {$_.Name -eq 'lp.cab'}) {
            $CurrentLog = "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-ContentPackPEADK-$($ADKFile.Name).log"
            Write-Verbose "CurrentLog: $CurrentLog"
            Write-Host "$($ADKFile.FullName)" -ForegroundColor DarkGray
            if ($MountDirectory) {
                Try {Add-WindowsPackage -PackagePath "$($ADKFile.FullName)" -Path "$MountDirectory" -LogPath "$CurrentLog" | Out-Null}
                Catch {
                    if ($_.Exception.Message -match '0x800f081e') {Write-Verbose "OSDBuilder: 0x800f081e The package is not applicable to this image" -Verbose}

                    Write-Verbose "$CurrentLog" -Verbose
                }
            }
        }

        foreach ($ADKFile in $ADKFiles | Where-Object {$_.Name -ne 'lp.cab'}) {
            $CurrentLog = "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-ContentPackPEADK-$($ADKFile.Name).log"
            Write-Verbose "CurrentLog: $CurrentLog"
            Write-Host "$($ADKFile.FullName)" -ForegroundColor DarkGray
            if ($MountDirectory) {
                Try {Add-WindowsPackage -PackagePath "$($ADKFile.FullName)" -Path "$MountDirectory" -LogPath "$CurrentLog" | Out-Null}
                Catch {
                    if ($_.Exception.Message -match '0x800f081e') {Write-Verbose "OSDBuilder: 0x800f081e The package is not applicable to this image" -Verbose}

                    Write-Verbose "$CurrentLog" -Verbose
                }
            }
        }

        foreach ($ADKFile in $ADKFilesSub | Where-Object {$_.Name -eq 'lp.cab'}) {
            $CurrentLog = "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-ContentPackPEADK-$($ADKFile.Name).log"
            Write-Verbose "CurrentLog: $CurrentLog"
            Write-Host "$($ADKFile.FullName)" -ForegroundColor DarkGray
            if ($MountDirectory) {
                Try {Add-WindowsPackage -PackagePath "$($ADKFile.FullName)" -Path "$MountDirectory" -LogPath "$CurrentLog" | Out-Null}
                Catch {
                    if ($_.Exception.Message -match '0x800f081e') {Write-Verbose "OSDBuilder: 0x800f081e The package is not applicable to this image" -Verbose}

                    Write-Verbose "$CurrentLog" -Verbose
                }
            }
        }

        foreach ($ADKFile in $ADKFilesSub | Where-Object {$_.Name -ne 'lp.cab'}) {
            $CurrentLog = "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-ContentPackPEADK-$($ADKFile.Name).log"
            Write-Verbose "CurrentLog: $CurrentLog"
            Write-Host "$($ADKFile.FullName)" -ForegroundColor DarkGray
            if ($MountDirectory) {
                Try {Add-WindowsPackage -PackagePath "$($ADKFile.FullName)" -Path "$MountDirectory" -LogPath "$CurrentLog" | Out-Null}
                Catch {
                    if ($_.Exception.Message -match '0x800f081e') {Write-Verbose "OSDBuilder: 0x800f081e The package is not applicable to this image" -Verbose}

                    Write-Verbose "$CurrentLog" -Verbose
                }
            }
        }

        Return
    }

    foreach ($ADKFile in $ADKFiles | Where-Object {$_.Name -notmatch 'Setup'}) {
        if ($MountWinPE) {
            $CurrentLog = "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-ContentPackPEADK-$($ADKFile.Name).log"
            Write-Verbose "CurrentLog: $CurrentLog"
            Write-Host "WinPE: $($ADKFile.FullName)" -ForegroundColor DarkGray
            Try {Add-WindowsPackage -PackagePath "$($ADKFile.FullName)" -Path "$MountWinPE" -LogPath "$CurrentLog" | Out-Null}
            Catch {
                if ($_.Exception.Message -match '0x800f081e') {Write-Verbose "OSDBuilder: 0x800f081e The package is not applicable to this image" -Verbose}
                Write-Verbose "$CurrentLog" -Verbose
            }
        }
        if ($MountWinRE) {
            $CurrentLog = "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-ContentPackPEADK-$($ADKFile.Name).log"
            Write-Verbose "CurrentLog: $CurrentLog"
            Write-Host "WinRE: $($ADKFile.FullName)" -ForegroundColor DarkGray
            Try {Add-WindowsPackage -PackagePath "$($ADKFile.FullName)" -Path "$MountWinRE" -LogPath "$CurrentLog" | Out-Null}
            Catch {
                if ($_.Exception.Message -match '0x800f081e') {Write-Verbose "OSDBuilder: 0x800f081e The package is not applicable to this image" -Verbose}
                Write-Verbose "$CurrentLog" -Verbose
            }
        }
        if ($MountWinSE) {
            $CurrentLog = "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-ContentPackPEADK-$($ADKFile.Name).log"
            Write-Verbose "CurrentLog: $CurrentLog"
            Write-Host "WinSE: $($ADKFile.FullName)" -ForegroundColor DarkGray
            Try {Add-WindowsPackage -PackagePath "$($ADKFile.FullName)" -Path "$MountWinSE" -LogPath "$CurrentLog" | Out-Null}
            Catch {
                if ($_.Exception.Message -match '0x800f081e') {Write-Verbose "OSDBuilder: 0x800f081e The package is not applicable to this image" -Verbose}
                Write-Verbose "$CurrentLog" -Verbose
            }
        }
    }

    $ADKFilesWinPE = $ADKFilesSub | Where-Object {$_.Name -notmatch 'setup'} | Where-Object {$_.Name -notmatch 'wifi'} | Where-Object {$_.Name -notmatch 'appxpackaging'} | Where-Object {$_.Name -notmatch 'rejuv'} | Where-Object {$_.Name -notmatch 'opcservices'}
    $ADKFilesWinRE = $ADKFilesSub | Where-Object {$_.Name -notmatch 'setup'}
    $ADKFilesWinSE = $ADKFilesSub | Where-Object {$_.Name -notmatch 'wifi'} | Where-Object {$_.Name -notmatch 'legacysetup'} | Where-Object {$_.Name -notmatch 'appxpackaging'} | Where-Object {$_.Name -notmatch 'rejuv'} | Where-Object {$_.Name -notmatch 'opcservices'}

    foreach ($ADKFile in $ADKFilesWinPE | Where-Object {$_.Name -eq 'lp.cab'}) {
        if ($MountWinPE) {
            $CurrentLog = "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-ContentPackPEADK-$($ADKFile.Name).log"
            Write-Verbose "CurrentLog: $CurrentLog"
            Write-Host "WinPE: $($ADKFile.FullName)" -ForegroundColor DarkGray
            Try {Add-WindowsPackage -PackagePath "$($ADKFile.FullName)" -Path "$MountWinPE" -LogPath "$CurrentLog" | Out-Null}
            Catch {
                if ($_.Exception.Message -match '0x800f081e') {Write-Verbose "OSDBuilder: 0x800f081e The package is not applicable to this image" -Verbose}
                Write-Verbose "$CurrentLog" -Verbose
            }
        }
    }
    foreach ($ADKFile in $ADKFilesWinRE | Where-Object {$_.Name -eq 'lp.cab'}) {
        if ($MountWinRE) {
            $CurrentLog = "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-ContentPackPEADK-$($ADKFile.Name).log"
            Write-Verbose "CurrentLog: $CurrentLog"
            Write-Host "WinRE: $($ADKFile.FullName)" -ForegroundColor DarkGray
            Try {Add-WindowsPackage -PackagePath "$($ADKFile.FullName)" -Path "$MountWinRE" -LogPath "$CurrentLog" | Out-Null}
            Catch {
                if ($_.Exception.Message -match '0x800f081e') {Write-Verbose "OSDBuilder: 0x800f081e The package is not applicable to this image" -Verbose}
                Write-Verbose "$CurrentLog" -Verbose
            }
        }
    }
    foreach ($ADKFile in $ADKFilesWinSE | Where-Object {$_.Name -eq 'lp.cab'}) {
        if ($MountWinSE) {
            $CurrentLog = "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-ContentPackPEADK-$($ADKFile.Name).log"
            Write-Verbose "CurrentLog: $CurrentLog"
            Write-Host "WinSE: $($ADKFile.FullName)" -ForegroundColor DarkGray
            Try {Add-WindowsPackage -PackagePath "$($ADKFile.FullName)" -Path "$MountWinSE" -LogPath "$CurrentLog" | Out-Null}
            Catch {
                if ($_.Exception.Message -match '0x800f081e') {Write-Verbose "OSDBuilder: 0x800f081e The package is not applicable to this image" -Verbose}
                Write-Verbose "$CurrentLog" -Verbose
            }
        }
    }

    foreach ($ADKFile in $ADKFilesWinPE | Where-Object {$_.Name -ne 'lp.cab'}) {
        if ($MountWinPE) {
            $CurrentLog = "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-ContentPackPEADK-$($ADKFile.Name).log"
            Write-Verbose "CurrentLog: $CurrentLog"
            Write-Host "WinPE: $($ADKFile.FullName)" -ForegroundColor DarkGray
            Try {Add-WindowsPackage -PackagePath "$($ADKFile.FullName)" -Path "$MountWinPE" -LogPath "$CurrentLog" | Out-Null}
            Catch {
                if ($_.Exception.Message -match '0x800f081e') {Write-Verbose "OSDBuilder: 0x800f081e The package is not applicable to this image" -Verbose}
                Write-Verbose "$CurrentLog" -Verbose
            }
        }
    }
    foreach ($ADKFile in $ADKFilesWinRE | Where-Object {$_.Name -ne 'lp.cab'}) {
        if ($MountWinRE) {
            $CurrentLog = "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-ContentPackPEADK-$($ADKFile.Name).log"
            Write-Verbose "CurrentLog: $CurrentLog"
            Write-Host "WinRE: $($ADKFile.FullName)" -ForegroundColor DarkGray
            Try {Add-WindowsPackage -PackagePath "$($ADKFile.FullName)" -Path "$MountWinRE" -LogPath "$CurrentLog" | Out-Null}
            Catch {
                if ($_.Exception.Message -match '0x800f081e') {Write-Verbose "OSDBuilder: 0x800f081e The package is not applicable to this image" -Verbose}
                Write-Verbose "$CurrentLog" -Verbose
            }
        }
    }
    foreach ($ADKFile in $ADKFilesWinSE | Where-Object {$_.Name -ne 'lp.cab'}) {
        if ($MountWinSE) {
            $CurrentLog = "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-ContentPackPEADK-$($ADKFile.Name).log"
            Write-Verbose "CurrentLog: $CurrentLog"
            Write-Host "WinSE: $($ADKFile.FullName)" -ForegroundColor DarkGray
            Try {Add-WindowsPackage -PackagePath "$($ADKFile.FullName)" -Path "$MountWinSE" -LogPath "$CurrentLog" | Out-Null}
            Catch {
                if ($_.Exception.Message -match '0x800f081e') {Write-Verbose "OSDBuilder: 0x800f081e The package is not applicable to this image" -Verbose}
                Write-Verbose "$CurrentLog" -Verbose
            }
        }
    }
}
function Add-ContentPackPEDaRT {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$ContentPackContent
    )
    Write-Host -ForegroundColor DarkGray "AutoApply Content $ContentPackContent"
    #======================================================================================
    #   TEST
    #======================================================================================
    if (!(Test-Path "$ContentPackContent\Tools$($OSArchitecture).cab")) {
        Write-Verbose "Add-ContentPackPEDaRT: Unable to locate content in $ContentPackContent"
        Return
    }
    else {Write-Host "$ContentPackContent\Tools$($OSArchitecture).cab" -ForegroundColor Cyan}
    #======================================================================================
    #   BUILD
    #======================================================================================
    $MicrosoftDartCab = "$ContentPackContent\Tools$($OSArchitecture).cab"
    if (Test-Path $MicrosoftDartCab) {
        if ($MountWinPE) {expand.exe "$MicrosoftDartCab" -F:*.* "$MountWinPE" | Out-Null}
        if ($MountWinRE) {expand.exe "$MicrosoftDartCab" -F:*.* "$MountWinRE" | Out-Null}
        if ($MountWinSE) {expand.exe "$MicrosoftDartCab" -F:*.* "$MountWinSE" | Out-Null}

        $MicrosoftDartConfig = $(Join-Path $(Split-Path "$MicrosoftDartCab") 'DartConfig.dat')
        if (Test-Path $MicrosoftDartConfig) {
            if ($MountWinPE) {Copy-Item -Path $MicrosoftDartConfig -Destination "$MountWinPE\Windows\System32\DartConfig.dat" -Force}
            if ($MountWinRE) {Copy-Item -Path $MicrosoftDartConfig -Destination "$MountWinSE\Windows\System32\DartConfig.dat" -Force}
            if ($MountWinSE) {Copy-Item -Path $MicrosoftDartConfig -Destination "$MountWinRE\Windows\System32\DartConfig.dat" -Force}
        }

        $MicrosoftDartConfig = $(Join-Path $(Split-Path "$MicrosoftDartCab") 'DartConfig8.dat')
        if (Test-Path $MicrosoftDartConfig) {
            if ($MountWinPE) {Copy-Item -Path $MicrosoftDartConfig -Destination "$MountWinPE\Windows\System32\DartConfig.dat" -Force}
            if ($MountWinRE) {Copy-Item -Path $MicrosoftDartConfig -Destination "$MountWinSE\Windows\System32\DartConfig.dat" -Force}
            if ($MountWinSE) {Copy-Item -Path $MicrosoftDartConfig -Destination "$MountWinRE\Windows\System32\DartConfig.dat" -Force}
        }

        if ($ScriptName -eq 'New-OSBuild') {
            if (Test-Path "$MountWinPE\Windows\System32\winpeshl.ini") {Remove-Item -Path "$MountWinPE\Windows\System32\winpeshl.ini" -Force}
            (Get-Content "$MountWinRE\Windows\System32\winpeshl.ini") | ForEach-Object {$_ -replace '-prompt','-network'} | Out-File "$MountWinRE\Windows\System32\winpeshl.ini"
            if (Test-Path "$MountWinSE\Windows\System32\winpeshl.ini") {Remove-Item -Path "$MountWinSE\Windows\System32\winpeshl.ini" -Force}
        }

        if ($ScriptName -eq 'New-PEBuild') {
            if ($WinPEOutput -eq 'Recovery') {
                (Get-Content "$MountDirectory\Windows\System32\winpeshl.ini") | ForEach-Object {$_ -replace '-prompt','-network'} | Out-File "$MountDirectory\Windows\System32\winpeshl.ini"
            }
        }
    } else {Write-Warning "Microsoft DaRT do not exist in $MicrosoftDartCab"}
}
function Add-ContentPackPEDrivers {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$ContentPackContent
    )
    Write-Host -ForegroundColor DarkGray "AutoApply Content $ContentPackContent"
    #======================================================================================
    #   Test
    #======================================================================================
    if (!(Test-Path "$ContentPackContent\*")) {
        Write-Verbose "Add-ContentPackPEDrivers: Unable to locate content in $ContentPackContent"
        Return
    } else {
        Write-Host "$ContentPackContent" -ForegroundColor Cyan
    }
    #======================================================================================
    #   Import
    #======================================================================================
    $CurrentLog = "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Add-ContentPackPEDrivers.log"
    Write-Verbose "CurrentLog: $CurrentLog"

    Get-ChildItem "$ContentPackContent" *.inf -File -Recurse | Select-Object -Property FullName | foreach {Write-Host "$($_.FullName)" -ForegroundColor DarkGray}

    if ($OSMajorVersion -eq 6) {
        if ($MountWinPE) {dism /Image:"$MountWinPE" /Add-Driver /Driver:"$ContentPackContent" /Recurse /ForceUnsigned /LogPath:"$CurrentLog" | Out-Null}
        if ($MountWinRE) {dism /Image:"$MountWinRE" /Add-Driver /Driver:"$ContentPackContent" /Recurse /ForceUnsigned /LogPath:"$CurrentLog" | Out-Null}
        if ($MountWinSE) {dism /Image:"$MountWinSE" /Add-Driver /Driver:"$ContentPackContent" /Recurse /ForceUnsigned /LogPath:"$CurrentLog" | Out-Null}
    } else {
        if ($MountWinPE) {Add-WindowsDriver -Driver "$ContentPackContent" -Recurse -Path "$MountWinPE" -ForceUnsigned -LogPath "$CurrentLog" | Out-Null}
        if ($MountWinRE) {Add-WindowsDriver -Driver "$ContentPackContent" -Recurse -Path "$MountWinRE" -ForceUnsigned -LogPath "$CurrentLog" | Out-Null}
        if ($MountWinSE) {Add-WindowsDriver -Driver "$ContentPackContent" -Recurse -Path "$MountWinSE" -ForceUnsigned -LogPath "$CurrentLog" | Out-Null}
    }
}
function Add-ContentPackPEExtraFiles {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$ContentPackContent
    )
    Write-Host -ForegroundColor DarkGray "AutoApply Content $ContentPackContent"
    #======================================================================================
    #   Test
    #======================================================================================
    if (!(Test-Path "$ContentPackContent\*")) {
        Write-Verbose "Add-ContentPackPEExtraFiles: Unable to locate content in $ContentPackContent"
        Return
    } else {
        Write-Host "$ContentPackContent" -ForegroundColor Cyan
    }
    #======================================================================================
    #   Import
    #======================================================================================
    $CurrentLog = "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Add-ContentPackPEExtraFiles.log"
    Write-Verbose "CurrentLog: $CurrentLog"

    Get-ChildItem "$ContentPackContent" *.* -File -Recurse | Select-Object -Property FullName | foreach {Write-Host "$($_.FullName)" -ForegroundColor DarkGray}
    #Save-WindowsImage -Path $MountWinPE | Out-Null
    if ($MountWinPE) {
        #robocopy "$ContentPackContent" "$MountWinPE" *.* /s /ndl /xx /b /np /ts /tee /r:0 /w:0 /Log+:"$CurrentLog" | Out-Null
        robocopy "$ContentPackContent" "$MountWinPE" *.* /S /B /COPY:D /NODCOPY /XJ /FP /NS /NC /NDL /NJH /NJS /NP /TEE /XX /R:0 /W:0 /LOG+:"$CurrentLog" | Out-Null
        #xcopy "$ContentPackContent" "$MountWinPE" /F /C /H /E /R /Y /J
        #Copy-Item "$ContentPackContent\*" -Destination "$MountWinPE\" -Recurse -Force
    }
    if ($MountWinRE) {
        #robocopy "$ContentPackContent" "$MountWinRE" *.* /s /ndl /xx /b /np /ts /tee /r:0 /w:0 /Log+:"$CurrentLog" | Out-Null
        robocopy "$ContentPackContent" "$MountWinRE" *.* /S /B /COPY:D /NODCOPY /XJ /FP /NS /NC /NDL /NJH /NJS /NP /TEE /XX /R:0 /W:0 /LOG+:"$CurrentLog" | Out-Null
    }
    if ($MountWinSE) {
        #robocopy "$ContentPackContent" "$MountWinSE" *.* /s /ndl /xx /b /np /ts /tee /r:0 /w:0 /Log+:"$CurrentLog" | Out-Null
        robocopy "$ContentPackContent" "$MountWinSE" *.* /S /B /COPY:D /NODCOPY /XJ /FP /NS /NC /NDL /NJH /NJS /NP /TEE /XX /R:0 /W:0 /LOG+:"$CurrentLog" | Out-Null
    }
    #Start-Sleep -Seconds 1
}
function Add-ContentPackPEPoshMods {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$ContentPackContent
    )
    Write-Host -ForegroundColor DarkGray "AutoApply Content $ContentPackContent"
    #======================================================================================
    #   Test
    #======================================================================================
    if (!(Test-Path "$ContentPackContent\*")) {
        Write-Verbose "Add-ContentPackPEPoshMods: Unable to locate content in $ContentPackContent"
        Return
    } else {
        Write-Host "$ContentPackContent" -ForegroundColor Cyan
    }
    #======================================================================================
    #   Import
    #======================================================================================
    $CurrentLog = "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Add-ContentPackPEPoshMods.log"
    Write-Verbose "CurrentLog: $CurrentLog"

    Get-ChildItem "$ContentPackContent" *.* -File -Recurse | Select-Object -Property FullName | foreach {Write-Host "$($_.FullName)" -ForegroundColor DarkGray}

    if ($MountWinPE) {robocopy "$ContentPackContent" "$MountWinPE\Program Files\WindowsPowerShell\Modules" *.* /s /ndl /xx /b /np /ts /tee /r:0 /w:0 /Log+:"$CurrentLog" | Out-Null}
    if ($MountWinRE) {robocopy "$ContentPackContent" "$MountWinRE\Program Files\WindowsPowerShell\Modules" *.* /s /ndl /xx /b /np /ts /tee /r:0 /w:0 /Log+:"$CurrentLog" | Out-Null}
    if ($MountWinSE) {robocopy "$ContentPackContent" "$MountWinSE\Program Files\WindowsPowerShell\Modules" *.* /s /ndl /xx /b /np /ts /tee /r:0 /w:0 /Log+:"$CurrentLog" | Out-Null}
}
function Add-ContentPackPEPoshModsSystem {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$ContentPackContent
    )
    Write-Host -ForegroundColor DarkGray "AutoApply Content $ContentPackContent"
    #======================================================================================
    #   Test
    #======================================================================================
    if (!(Test-Path "$ContentPackContent\*")) {
        Write-Verbose "Add-ContentPackPEPoshModsSystem: Unable to locate content in $ContentPackContent"
        Return
    } else {
        Write-Host "$ContentPackContent" -ForegroundColor Cyan
    }
    #======================================================================================
    #   Import
    #======================================================================================
    $CurrentLog = "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Add-ContentPackPEPoshModsSystem.log"
    Write-Verbose "CurrentLog: $CurrentLog"

    Get-ChildItem "$ContentPackContent" *.* -File -Recurse | Select-Object -Property FullName | foreach {Write-Host "$($_.FullName)" -ForegroundColor DarkGray}

    if ($MountWinPE) {robocopy "$ContentPackContent" "$MountWinPE\Windows\System32\WindowsPowerShell\v1.0\Modules" *.* /s /ndl /xx /b /np /ts /tee /r:0 /w:0 /Log+:"$CurrentLog" | Out-Null}
    if ($MountWinRE) {robocopy "$ContentPackContent" "$MountWinRE\Windows\System32\WindowsPowerShell\v1.0\Modules" *.* /s /ndl /xx /b /np /ts /tee /r:0 /w:0 /Log+:"$CurrentLog" | Out-Null}
    if ($MountWinSE) {robocopy "$ContentPackContent" "$MountWinSE\Windows\System32\WindowsPowerShell\v1.0\Modules" *.* /s /ndl /xx /b /np /ts /tee /r:0 /w:0 /Log+:"$CurrentLog" | Out-Null}
}
function Add-ContentPackPERegistry {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$ContentPackContent,
        [switch]$ShowRegContent
    )
    Write-Host -ForegroundColor DarkGray "AutoApply Content $ContentPackContent"
    #======================================================================================
    #   Test-OSDContentPackPERegistry
    #======================================================================================
    if (!(Test-Path "$ContentPackContent\*")) {
        Write-Verbose "Add-ContentPackPERegistry: Unable to locate content in $ContentPackContent"
        Return
    } else {
        Write-Host "$ContentPackContent" -ForegroundColor Cyan
    }
    #======================================================================================
    #   Mount-OfflineRegistryHives
    #======================================================================================
    if (($MountWinPE) -and (Test-Path "$MountWinPE" -ErrorAction SilentlyContinue)) {
        Mount-OSDOfflineRegistryPE -MountPath $MountWinPE
    } else {Return}
    $OSDContentPackTemp = "$env:TEMP\$(Get-Random)"
    if (!(Test-Path $OSDContentPackTemp)) {New-Item -Path "$OSDContentPackTemp" -ItemType Directory -Force | Out-Null}

    #======================================================================================
    #   Get-RegFiles
    #======================================================================================
    [array]$ContentPackContentFiles = @()
    [array]$ContentPackContentFiles = Get-ChildItem "$ContentPackContent" *.reg -Recurse | Select-Object -Property Name, BaseName, Extension, Directory, FullName

    #======================================================================================
    #	Add-ContentPackPERegistryFiles
    #======================================================================================
    foreach ($OSDRegistryRegFile in $ContentPackContentFiles) {
        $OSDRegistryImportFile = $OSDRegistryRegFile.FullName

        if ($MountWinPE) {
            $RegFileContent = Get-Content -Path $OSDRegistryImportFile
            $OSDRegistryImportFile = "$OSDContentPackTemp\$($OSDRegistryRegFile.BaseName).reg"

            $RegFileContent = $RegFileContent -replace 'HKEY_CURRENT_USER','HKEY_LOCAL_MACHINE\OfflineDefaultUser'
            $RegFileContent = $RegFileContent -replace 'HKEY_LOCAL_MACHINE\\SOFTWARE','HKEY_LOCAL_MACHINE\OfflineSoftware'
            $RegFileContent = $RegFileContent -replace 'HKEY_LOCAL_MACHINE\\SYSTEM','HKEY_LOCAL_MACHINE\OfflineSystem'
            $RegFileContent = $RegFileContent -replace 'HKEY_USERS\\.DEFAULT','HKEY_LOCAL_MACHINE\OfflineDefault'
            $RegFileContent | Set-Content -Path $OSDRegistryImportFile -Force
        }

        Write-Host "$OSDRegistryImportFile"  -ForegroundColor DarkGray
        if ($ShowRegContent.IsPresent){
            $OSDContentPackRegFileContent = @()
            $OSDContentPackRegFileContent = Get-Content -Path $OSDRegistryImportFile
            foreach ($Line in $OSDContentPackRegFileContent) {
                Write-Host "$Line" -ForegroundColor Gray
            }
        }
        Start-Process reg -ArgumentList ('import',"`"$OSDRegistryImportFile`"") -Wait -WindowStyle Hidden -ErrorAction SilentlyContinue
    }
    
    #======================================================================================
    #	Remove-OSDContentPackTemp
    #======================================================================================
    if ($MountWinPE) {
        if (Test-Path $OSDContentPackTemp) {Remove-Item -Path "$OSDContentPackTemp" -Recurse -Force | Out-Null}
    }
    #======================================================================================
    #	Dismount-RegistryHives
    #======================================================================================
    Dismount-OSDOfflineRegistry -MountPath $MountWinPE
    #======================================================================================
    #   Mount-OfflineRegistryHives
    #======================================================================================
    if (($MountWinRE) -and (Test-Path "$MountWinRE" -ErrorAction SilentlyContinue)) {
        Mount-OSDOfflineRegistryPE -MountPath $MountWinRE
    } else {Return}
    $OSDContentPackTemp = "$env:TEMP\$(Get-Random)"
    if (!(Test-Path $OSDContentPackTemp)) {New-Item -Path "$OSDContentPackTemp" -ItemType Directory -Force | Out-Null}

    #======================================================================================
    #   Get-RegFiles
    #======================================================================================
    [array]$ContentPackContentFiles = @()
    [array]$ContentPackContentFiles = Get-ChildItem "$ContentPackContent" *.reg -Recurse | Select-Object -Property Name, BaseName, Extension, Directory, FullName

    #======================================================================================
    #	Add-ContentPackPERegistryFiles
    #======================================================================================
    foreach ($OSDRegistryRegFile in $ContentPackContentFiles) {
        $OSDRegistryImportFile = $OSDRegistryRegFile.FullName

        if ($MountWinRE) {
            $RegFileContent = Get-Content -Path $OSDRegistryImportFile
            $OSDRegistryImportFile = "$OSDContentPackTemp\$($OSDRegistryRegFile.BaseName).reg"

            $RegFileContent = $RegFileContent -replace 'HKEY_CURRENT_USER','HKEY_LOCAL_MACHINE\OfflineDefaultUser'
            $RegFileContent = $RegFileContent -replace 'HKEY_LOCAL_MACHINE\\SOFTWARE','HKEY_LOCAL_MACHINE\OfflineSoftware'
            $RegFileContent = $RegFileContent -replace 'HKEY_LOCAL_MACHINE\\SYSTEM','HKEY_LOCAL_MACHINE\OfflineSystem'
            $RegFileContent = $RegFileContent -replace 'HKEY_USERS\\.DEFAULT','HKEY_LOCAL_MACHINE\OfflineDefault'
            $RegFileContent | Set-Content -Path $OSDRegistryImportFile -Force
        }

        Write-Host "$OSDRegistryImportFile"  -ForegroundColor DarkGray
        if ($ShowRegContent.IsPresent){
            $OSDContentPackRegFileContent = @()
            $OSDContentPackRegFileContent = Get-Content -Path $OSDRegistryImportFile
            foreach ($Line in $OSDContentPackRegFileContent) {
                Write-Host "$Line" -ForegroundColor Gray
            }
        }
        Start-Process reg -ArgumentList ('import',"`"$OSDRegistryImportFile`"") -Wait -WindowStyle Hidden -ErrorAction SilentlyContinue
    }
    
    #======================================================================================
    #	Remove-OSDContentPackTemp
    #======================================================================================
    if ($MountWinRE) {
        if (Test-Path $OSDContentPackTemp) {Remove-Item -Path "$OSDContentPackTemp" -Recurse -Force | Out-Null}
    }
    #======================================================================================
    #	Dismount-RegistryHives
    #======================================================================================
    Dismount-OSDOfflineRegistry -MountPath $MountWinRE
        #======================================================================================
    #   Mount-OfflineRegistryHives
    #======================================================================================
    if (($MountWinSE) -and (Test-Path "$MountWinSE" -ErrorAction SilentlyContinue)) {
        Mount-OSDOfflineRegistryPE -MountPath $MountWinSE
    } else {Return}
    $OSDContentPackTemp = "$env:TEMP\$(Get-Random)"
    if (!(Test-Path $OSDContentPackTemp)) {New-Item -Path "$OSDContentPackTemp" -ItemType Directory -Force | Out-Null}

    #======================================================================================
    #   Get-RegFiles
    #======================================================================================
    [array]$ContentPackContentFiles = @()
    [array]$ContentPackContentFiles = Get-ChildItem "$ContentPackContent" *.reg -Recurse | Select-Object -Property Name, BaseName, Extension, Directory, FullName

    #======================================================================================
    #	Add-ContentPackPERegistryFiles
    #======================================================================================
    foreach ($OSDRegistryRegFile in $ContentPackContentFiles) {
        $OSDRegistryImportFile = $OSDRegistryRegFile.FullName

        if ($MountWinSE) {
            $RegFileContent = Get-Content -Path $OSDRegistryImportFile
            $OSDRegistryImportFile = "$OSDContentPackTemp\$($OSDRegistryRegFile.BaseName).reg"

            $RegFileContent = $RegFileContent -replace 'HKEY_CURRENT_USER','HKEY_LOCAL_MACHINE\OfflineDefaultUser'
            $RegFileContent = $RegFileContent -replace 'HKEY_LOCAL_MACHINE\\SOFTWARE','HKEY_LOCAL_MACHINE\OfflineSoftware'
            $RegFileContent = $RegFileContent -replace 'HKEY_LOCAL_MACHINE\\SYSTEM','HKEY_LOCAL_MACHINE\OfflineSystem'
            $RegFileContent = $RegFileContent -replace 'HKEY_USERS\\.DEFAULT','HKEY_LOCAL_MACHINE\OfflineDefault'
            $RegFileContent | Set-Content -Path $OSDRegistryImportFile -Force
        }

        Write-Host "$OSDRegistryImportFile"  -ForegroundColor DarkGray
        if ($ShowRegContent.IsPresent){
            $OSDContentPackRegFileContent = @()
            $OSDContentPackRegFileContent = Get-Content -Path $OSDRegistryImportFile
            foreach ($Line in $OSDContentPackRegFileContent) {
                Write-Host "$Line" -ForegroundColor Gray
            }
        }
        Start-Process reg -ArgumentList ('import',"`"$OSDRegistryImportFile`"") -Wait -WindowStyle Hidden -ErrorAction SilentlyContinue
    }
    
    #======================================================================================
    #	Remove-OSDContentPackTemp
    #======================================================================================
    if ($MountWinSE) {
        if (Test-Path $OSDContentPackTemp) {Remove-Item -Path "$OSDContentPackTemp" -Recurse -Force | Out-Null}
    }
    #======================================================================================
    #	Dismount-RegistryHives
    #======================================================================================
    Dismount-OSDOfflineRegistry -MountPath $MountWinSE
}
function Add-ContentPackPEScripts {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$ContentPackContent
    )
    Write-Host -ForegroundColor DarkGray "AutoApply Content $ContentPackContent"
    #======================================================================================
    #   TEST
    #======================================================================================
    if (!(Test-Path "$ContentPackContent\*")) {
        Write-Verbose "Add-ContentPackPEScripts: Unable to locate content in $ContentPackContent"
        Return
    }
    else {Write-Host "$ContentPackContent" -ForegroundColor Cyan}
    #======================================================================================
    #   BUILD
    #======================================================================================
    $ContentPackPEScripts = Get-ChildItem "$ContentPackContent" *.ps1 -File -Recurse | Select-Object -Property FullName
    foreach ($ContentPackPEScript in $ContentPackPEScripts) {
        Write-Host "$($ContentPackPEScript.FullName)" -ForegroundColor DarkGray
        Invoke-Expression "& '$($ContentPackPEScript.FullName)'"
    }
}
function Add-FeaturesOnDemandOS {
    [CmdletBinding()]
    param ()
    #=================================================
    #   Abort
    #=================================================
    if ($ScriptName -ne 'New-OSBuild') {Return}
    if ([string]::IsNullOrWhiteSpace($FeaturesOnDemand)) {Return}
    #=================================================
    #   Execute
    #=================================================
    Show-ActionTime; Write-Host -ForegroundColor Green "OS: Features On Demand"
    foreach ($FOD in $FeaturesOnDemand) {
        $global:ReapplyLCU = $true
        Write-Host "$SetOSDBuilderPathContent\$FOD" -ForegroundColor DarkGray
        $CurrentLog = "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Add-FeaturesOnDemandOS.log"
        Write-Verbose "CurrentLog: $CurrentLog"
        Try {
            Add-WindowsPackage -Path "$MountDirectory" -PackagePath "$SetOSDBuilderPathContent\$FOD" -LogPath "$CurrentLog" | Out-Null
        }
        Catch {
            if ($_.Exception.Message -match '0x800f081e') {Write-Verbose "OSDBuilder: 0x800f081e The package is not applicable to this image" -Verbose}
            Write-Verbose "OSDBuilder: Review the log for more information" -Verbose
            Write-Verbose "$CurrentLog" -Verbose
        }
    }
    #=================================================
    #   PostAction
    #=================================================
    #Update-CumulativeOS -Force
    #Invoke-DismCleanupImage
}
function Add-LanguageFeaturesOnDemandOS {
    [CmdletBinding()]
    param ()
    #=================================================
    #   Abort
    #=================================================
    if ($ScriptName -ne 'New-OSBuild') {Return}
    if ($OSMajorVersion -ne 10) {Return}
    if ([string]::IsNullOrWhiteSpace($LanguageFeatures)) {Return}
    #=================================================
    #   Execute
    #=================================================
    Show-ActionTime; Write-Host -ForegroundColor Green "OS: Language Features On Demand"
    foreach ($Update in $LanguageFeatures | Where-Object {$_ -notlike "*Speech*"}) {
        $global:ReapplyLCU = $true
        if (Test-Path "$SetOSDBuilderPathContent\$Update") {
            Write-Host "$SetOSDBuilderPathContent\$Update" -ForegroundColor DarkGray

            $CurrentLog = "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Add-LanguageFeaturesOnDemandOS.log"
            Try {Add-WindowsPackage -Path "$MountDirectory" -PackagePath "$SetOSDBuilderPathContent\$Update" -LogPath $CurrentLog | Out-Null}
            Catch {
                if ($_.Exception.Message -match '0x800f081e') {Write-Verbose "OSDBuilder: 0x800f081e The package is not applicable to this image" -Verbose}
                Write-Verbose "$CurrentLog" -Verbose
            }
        }
    }
    foreach ($Update in $LanguageFeatures | Where-Object {$_ -like "*TextToSpeech*"}) {
        $global:ReapplyLCU = $true
        if (Test-Path "$SetOSDBuilderPathContent\$Update") {
            Write-Host "$SetOSDBuilderPathContent\$Update" -ForegroundColor DarkGray

            $CurrentLog = "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Add-LanguageFeaturesOnDemandOS.log"
            Try {Add-WindowsPackage -Path "$MountDirectory" -PackagePath "$SetOSDBuilderPathContent\$Update" -LogPath $CurrentLog | Out-Null}
            Catch {
                if ($_.Exception.Message -match '0x800f081e') {Write-Verbose "OSDBuilder: 0x800f081e The package is not applicable to this image" -Verbose}
                Write-Verbose "$CurrentLog" -Verbose
            }
        }
    }
    foreach ($Update in $LanguageFeatures | Where-Object {$_ -like "*Speech*" -and $_ -notlike "*TextToSpeech*"}) {
        $global:ReapplyLCU = $true
        if (Test-Path "$SetOSDBuilderPathContent\$Update") {
            Write-Host "$SetOSDBuilderPathContent\$Update" -ForegroundColor DarkGray

            $CurrentLog = "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Add-LanguageFeaturesOnDemandOS.log"
            Try {Add-WindowsPackage -Path "$MountDirectory" -PackagePath "$SetOSDBuilderPathContent\$Update" -LogPath $CurrentLog | Out-Null}
            Catch {
                if ($_.Exception.Message -match '0x800f081e') {Write-Verbose "OSDBuilder: 0x800f081e The package is not applicable to this image" -Verbose}
                Write-Verbose "$CurrentLog" -Verbose
            }
        }
    }
}
function Add-LanguageInterfacePacksOS {
    [CmdletBinding()]
    param ()
    #=================================================
    #   Abort
    #=================================================
    if ($ScriptName -ne 'New-OSBuild') {Return}
    if ($OSMajorVersion -ne 10) {Return}
    if ([string]::IsNullOrWhiteSpace($LanguageInterfacePacks)) {Return}
    #=================================================
    #   Header
    #=================================================
    Show-ActionTime; Write-Host -ForegroundColor Green "OS: Language Interface Packs"
    #=================================================
    #   Execute
    #=================================================
    foreach ($Update in $LanguageInterfacePacks) {
        if (Test-Path "$SetOSDBuilderPathContent\$Update") {
            Write-Host "$SetOSDBuilderPathContent\$Update" -ForegroundColor DarkGray

            $CurrentLog = "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Add-LanguageInterfacePacksOS.log"
            Try {
                $global:ReapplyLCU = $true
                Add-WindowsPackage -Path "$MountDirectory" -PackagePath "$SetOSDBuilderPathContent\$Update" -LogPath $CurrentLog | Out-Null
            }
            Catch {
                if ($_.Exception.Message -match '0x800f081e') {Write-Verbose "OSDBuilder: 0x800f081e The package is not applicable to this image" -Verbose}
                Write-Verbose "$CurrentLog" -Verbose
            }
        } else {
            Write-Warning "Not Found: $SetOSDBuilderPathContent\$Update"
        }
    }
}
function Add-LanguagePacksOS {
    [CmdletBinding()]
    param ()
    #=================================================
    #   Abort
    #=================================================
    if ($ScriptName -ne 'New-OSBuild') {Return}
    if ($OSMajorVersion -ne 10) {Return}
    if ([string]::IsNullOrWhiteSpace($LanguagePacks)) {Return}
    #=================================================
    #   Header
    #=================================================
    Show-ActionTime; Write-Host -ForegroundColor Green "OS: Language Packs"
    #=================================================
    #   Execute
    #=================================================
    foreach ($Update in $LanguagePacks) {
        if (Test-Path "$SetOSDBuilderPathContent\$Update") {
            if ($Update -like "*.cab") {
                Write-Host "$SetOSDBuilderPathContent\$Update" -ForegroundColor DarkGray

                $CurrentLog = "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Add-LanguagePacksOS.log"
                Try {
                    $global:ReapplyLCU = $true
                    Add-WindowsPackage -Path "$MountDirectory" -PackagePath "$SetOSDBuilderPathContent\$Update" -LogPath $CurrentLog | Out-Null
                }
                Catch {
                    if ($_.Exception.Message -match '0x800f081e') {Write-Verbose "OSDBuilder: 0x800f081e The package is not applicable to this image" -Verbose}

                    Write-Verbose "$CurrentLog" -Verbose
                }
            } elseif ($Update -like "*.appx") {
                Write-Host "$SetOSDBuilderPathContent\$Update" -ForegroundColor DarkGray
                Add-AppxProvisionedPackage -Path "$MountDirectory" -PackagePath "$SetOSDBuilderPathContent\$Update" -LicensePath "$((Get-Item $SetOSDBuilderPathContent\$Update).Directory.FullName)\License.xml" -LogPath "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Add-LanguagePacksOS.log" | Out-Null
            }
        } else {
            Write-Warning "Not Found: $SetOSDBuilderPathContent\$Update"
        }
    }
}
function Add-LocalExperiencePacksOS {
    [CmdletBinding()]
    param ()
    #=================================================
    #   Abort
    #=================================================
    if ($ScriptName -ne 'New-OSBuild') {Return}
    if ($OSMajorVersion -ne 10) {Return}
    if ([string]::IsNullOrWhiteSpace($LocalExperiencePacks)) {Return}
    #=================================================
    #   Header
    #=================================================
    Show-ActionTime
    Write-Host -ForegroundColor Green "OS: Local Experience Packs"
    #=================================================
    #   Execute
    #=================================================
    foreach ($Update in $LocalExperiencePacks) {
        if (Test-Path "$SetOSDBuilderPathContent\$Update") {
            Write-Host "$SetOSDBuilderPathContent\$Update" -ForegroundColor DarkGray
            $global:ReapplyLCU = $true
            Add-AppxProvisionedPackage -Path "$MountDirectory" -PackagePath "$SetOSDBuilderPathContent\$Update" -LicensePath "$((Get-Item $SetOSDBuilderPathContent\$Update).Directory.FullName)\License.xml" -LogPath "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Add-LocalExperiencePacksOS.log" | Out-Null
        } else {
            Write-Warning "Not Found: $SetOSDBuilderPathContent\$Update"
        }
    }
}
function Add-WindowsPackageOS {
    [CmdletBinding()]
    param ()
    #=================================================
    #   Abort
    #=================================================
    if ($ScriptName -ne 'New-OSBuild') {Return}
    #=================================================
    #   Task
    #=================================================
    if ([string]::IsNullOrWhiteSpace($Packages)) {Return}
    Show-ActionTime; Write-Host -ForegroundColor Green "OS: Add Packages"
    foreach ($PackagePath in $Packages) {
        Write-Host "$SetOSDBuilderPathContent\$PackagePath" -ForegroundColor DarkGray

        $CurrentLog = "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Add-WindowsPackageOS.log"
        Try {
            $global:ReapplyLCU = $true
            Add-WindowsPackage -PackagePath "$SetOSDBuilderPathContent\$PackagePath" -Path "$MountDirectory" -LogPath $CurrentLog | Out-Null
        }
        Catch {
            if ($_.Exception.Message -match '0x800f081e') {Write-Verbose "OSDBuilder: 0x800f081e The package is not applicable to this image" -Verbose}
            Write-Verbose "OSDBuilder: Review the log for more information" -Verbose
            Write-Verbose "$CurrentLog" -Verbose
        }
    }
}
function Copy-MediaLanguageSources {
    [CmdletBinding()]
    param ()
    #=================================================
    #   Abort
    #=================================================
    if ($ScriptName -ne 'New-OSBuild') {Return}
    if ($OSMajorVersion -ne 10) {Return}
    if ([string]::IsNullOrWhiteSpace($LanguageCopySources)) {Return}
    #=================================================
    #   Header
    #=================================================
    Show-ActionTime
    Write-Host -ForegroundColor Green "OS: Language Sources"
    #=================================================
    #   Execute
    #=================================================
    foreach ($LanguageSource in $LanguageCopySources) {
        $CurrentLanguageSource = Get-OSMedia -Revision OK | Where-Object {$_.OSMFamily -eq $LanguageSource} | Select-Object -Property FullName
        Write-Host "Copying Language Resources from $($CurrentLanguageSource.FullName)" -ForegroundColor DarkGray
        robocopy "$($CurrentLanguageSource.FullName)\OS" "$OS" *.* /s /xf *.wim /ndl /xc /xn /xo /xf /xx /b /np /ts /tee /r:0 /w:0 /Log+:"$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Copy-MediaLanguageSources.log" | Out-Null
    }
    #=================================================
}
function Copy-MediaOperatingSystem {
    [CmdletBinding()]
    param ()
    #=================================================
    #   Header
    #=================================================
    Show-ActionTime
    Write-Host -ForegroundColor Green "MEDIA: Copy Operating System to $WorkingPath"
    #=================================================
    #   Execute
    #=================================================
    #Copy-Item -Path "$OSMediaPath\*" -Destination "$WorkingPath" -Exclude ('*.wim','*.iso','*.vhd','*.vhx') -Recurse -Force | Out-Null
    robocopy "$OSMediaPath" "$WorkingPath" *.* /s /r:0 /w:0 /nfl /ndl /xf *.wim *.iso *.vhd *.vhx *.vhdx | Out-Null
    if (Test-Path "$WorkingPath\ISO") {Remove-Item -Path "$WorkingPath\ISO" -Force -Recurse | Out-Null}
    if (Test-Path "$WorkingPath\VHD") {Remove-Item -Path "$WorkingPath\VHD" -Force -Recurse | Out-Null}
    #Copy-Item -Path "$OSMediaPath\OS\sources\install.wim" -Destination "$WimTemp\install.wim" -Force | Out-Null
    robocopy "$OSMediaPath\OS\sources" "$WimTemp" install.wim /r:0 /w:0 /nfl /ndl | Out-Null
    #Copy-Item -Path "$OSMediaPath\WinPE\*.wim" -Destination "$WimTemp" -Exclude boot.wim -Force | Out-Null
    robocopy "$OSMediaPath\WinPE" "$WimTemp" *.wim /r:0 /w:0 /nfl /ndl /xf boot.wim | Out-Null
}
function Disable-WindowsOptionalFeatureOS {
    [CmdletBinding()]
    param ()
    #=================================================
    #   Abort
    #=================================================
    if ($ScriptName -ne 'New-OSBuild') {Return}
    if ([string]::IsNullOrWhiteSpace($DisableFeature)) {Return}
    #=================================================
    #   Header
    #=================================================
    Show-ActionTime
    Write-Host -ForegroundColor Green "OS: Disable Windows Optional Feature"
    #=================================================
    #   Execute
    #=================================================
    foreach ($FeatureName in $DisableFeature) {
        Write-Host $FeatureName -ForegroundColor DarkGray
        Try {
            Disable-WindowsOptionalFeature -FeatureName $FeatureName -Path "$MountDirectory" -LogPath "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Disable-WindowsOptionalFeature.log" | Out-Null
        }
        Catch {
            $ErrorMessage = $_.Exception.Message
            Write-Warning "$ErrorMessage"
        }
    }
    #=================================================
}
function Dismount-InstallwimOS {
    [CmdletBinding()]
    param ()
    #=================================================
    #   Header
    #=================================================
    Show-ActionTime
    Write-Host -ForegroundColor Green "OS: Dismount from $MountDirectory"
    #=================================================
    #   Execute
    #=================================================
    if ($WaitDismount.IsPresent){[void](Read-Host 'Press Enter to Continue')}
    $CurrentLog = "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Dismount-WindowsImage.log"
    Write-Verbose "CurrentLog: $CurrentLog"
    Start-Sleep -Seconds 10
    try {
        Dismount-WindowsImage -Path "$MountDirectory" -Save -LogPath "$CurrentLog" -ErrorAction SilentlyContinue | Out-Null
    }
    catch {
        Write-Warning "Could not dismount Install.wim ... Waiting 30 seconds ..."
        Start-Sleep -Seconds 30
        Dismount-WindowsImage -Path "$MountDirectory" -Save -LogPath "$CurrentLog" | Out-Null
    }
    #=================================================
}
function Dismount-OSDOfflineRegistry {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$MountPath
    )
    #======================================================================================
    #	Dismount-RegistryHives
    #======================================================================================
    if (($MountPath) -and (Test-Path "$MountPath" -ErrorAction SilentlyContinue)) {
        if (Test-Path -Path "HKLM:\OfflineDefaultUser") {
            Write-Verbose "Unloading Registry HKLM\OfflineDefaultUser" 
            Start-Process reg -ArgumentList "unload HKLM\OfflineDefaultUser" -Wait -WindowStyle Hidden -ErrorAction SilentlyContinue
        }
        if (Test-Path -Path "HKLM:\OfflineDefault") {
            Write-Verbose "Unloading Registry HKLM\OfflineDefault" 
            Start-Process reg -ArgumentList "unload HKLM\OfflineDefault" -Wait -WindowStyle Hidden -ErrorAction SilentlyContinue
        }
        if (Test-Path -Path "HKLM:\OfflineSoftware") {
            Write-Verbose "Unloading Registry HKLM\OfflineSoftware" 
            Start-Process reg -ArgumentList "unload HKLM\OfflineSoftware" -Wait -WindowStyle Hidden -ErrorAction SilentlyContinue
        }
        if (Test-Path -Path "HKLM:\OfflineSystem") {
            Write-Verbose "Unloading Registry HKLM\OfflineSystem" 
            Start-Process reg -ArgumentList "unload HKLM\OfflineSystem" -Wait -WindowStyle Hidden -ErrorAction SilentlyContinue
        }

        if (Test-Path -Path "HKLM:\OfflineDefaultUser") {
            Write-Verbose "Unloading Registry HKLM\OfflineDefaultUser (Second Attempt)" 
            Start-Process reg -ArgumentList "unload HKLM\OfflineDefaultUser" -Wait -WindowStyle Hidden -ErrorAction SilentlyContinue
        }
        if (Test-Path -Path "HKLM:\OfflineDefault") {
            Write-Verbose "Unloading Registry HKLM\OfflineDefault (Second Attempt)" 
            Start-Process reg -ArgumentList "unload HKLM\OfflineDefault" -Wait -WindowStyle Hidden -ErrorAction SilentlyContinue
        }
        if (Test-Path -Path "HKLM:\OfflineSoftware") {
            Write-Verbose "Unloading Registry HKLM\OfflineSoftware (Second Attempt)" 
            Start-Process reg -ArgumentList "unload HKLM\OfflineSoftware" -Wait -WindowStyle Hidden -ErrorAction SilentlyContinue
        }
        if (Test-Path -Path "HKLM:\OfflineSystem") {
            Write-Verbose "Unloading Registry HKLM\OfflineSystem (Second Attempt)" 
            Start-Process reg -ArgumentList "unload HKLM\OfflineSystem" -Wait -WindowStyle Hidden -ErrorAction SilentlyContinue
        }

        if (Test-Path -Path "HKLM:\OfflineDefaultUser") {
            Write-Warning "HKLM:\OfflineDefaultUser could not be dismounted.  Open Regedit and unload the Hive manually"
            Pause
        }
        if (Test-Path -Path "HKLM:\OfflineDefault") {
            Write-Warning "HKLM:\OfflineDefault could not be dismounted.  Open Regedit and unload the Hive manually"
            Pause
        }
        if (Test-Path -Path "HKLM:\OfflineSoftware") {
            Write-Warning "HKLM:\OfflineSoftware could not be dismounted.  Open Regedit and unload the Hive manually"
            Pause
        }
        if (Test-Path -Path "HKLM:\OfflineSystem") {
            Write-Warning "HKLM:\OfflineSystem could not be dismounted.  Open Regedit and unload the Hive manually"
            Pause
        }
    }
}
function Dismount-WimsPE {
    [CmdletBinding()]
    param (
        [string]$OSMediaPath
    )
    #=================================================
    #   Header
    #=================================================
    Show-ActionTime
    Write-Host -ForegroundColor Green "WinPE: Dismount-WimsPE"
    #=================================================
    #   Execute
    #=================================================
    Start-Sleep -Seconds 10
    
    Write-Verbose "$MountWinPE"
    $CurrentLog = "$OSMediaPath\WinPE\info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Dismount-WimsPE-WinPE.log"
    Write-Verbose "CurrentLog: $CurrentLog"
    try {
        Dismount-WindowsImage -Path "$MountWinPE" -Save -LogPath "$CurrentLog" -ErrorAction SilentlyContinue | Out-Null
    }
    catch {
        Write-Warning "Could not dismount WinPE ... Waiting 30 seconds ..."
        Start-Sleep -Seconds 30
        Dismount-WindowsImage -Path "$MountWinPE" -Save -LogPath "$CurrentLog" | Out-Null
    }
    
    Write-Verbose "$MountWinRE"
    $CurrentLog = "$OSMediaPath\WinPE\info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Dismount-WimsPE-WinRE.log"
    Write-Verbose "CurrentLog: $CurrentLog"
    try {
        Dismount-WindowsImage -Path "$MountWinRE" -Save -LogPath "$CurrentLog" -ErrorAction SilentlyContinue | Out-Null
    }
    catch {
        Write-Warning "Could not dismount WinRE ... Waiting 30 seconds ..."
        Start-Sleep -Seconds 30
        Dismount-WindowsImage -Path "$MountWinRE" -Save -LogPath "$CurrentLog" | Out-Null
    }
    
    Write-Verbose "$MountWinSE"
    $CurrentLog = "$OSMediaPath\WinPE\info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Dismount-WimsPE-WinSE.log"
    Write-Verbose "CurrentLog: $CurrentLog"
    try {
        Dismount-WindowsImage -Path "$MountWinSE" -Save -LogPath "$CurrentLog" -ErrorAction SilentlyContinue | Out-Null
    }
    catch {
        Write-Warning "Could not dismount WinSE ... Waiting 30 seconds ..."
        Start-Sleep -Seconds 30
        Dismount-WindowsImage -Path "$MountWinSE" -Save -LogPath "$CurrentLog" | Out-Null
    }
    #=================================================
}
function Enable-NetFXOS {
    [CmdletBinding()]
    param ()
    #=================================================
    #   Abort
    #=================================================
    if ($ScriptName -ne 'New-OSBuild') {Return}
    if ($EnableNetFX3 -ne $true) {Return}
    if ($OSMajorVersion -ne 10) {Return}
    #=================================================
    #   Header
    #=================================================
    Show-ActionTime
    Write-Host -ForegroundColor Green "OS: Enable NetFX 3.5"
    #=================================================
    #   Execute
    #=================================================
    $CurrentLog = "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Enable-NetFXOS.log"
    Write-Verbose "CurrentLog: $CurrentLog"
    Try {
        Enable-WindowsOptionalFeature -Path "$MountDirectory" -FeatureName NetFX3 -All -LimitAccess -Source "$OS\sources\sxs" -LogPath "$CurrentLog" | Out-Null
    }
    Catch {
        $ErrorMessage = $_.Exception.Message
        Write-Warning "$ErrorMessage"
    }
    #=================================================
    #   Post Action
    #=================================================
    Update-DotNetOS -Force
    Update-CumulativeOS -Force
    #=================================================
}
function Enable-WindowsOptionalFeatureOS {
    [CmdletBinding()]
    param ()
    #=================================================
    #   Abort
    #=================================================
    if ($ScriptName -ne 'New-OSBuild') {Return}
    if ([string]::IsNullOrWhiteSpace($EnableFeature)) {Return}
    #=================================================
    #   Header
    #=================================================
    Show-ActionTime
    Write-Host -ForegroundColor Green "OS: Enable Windows Optional Feature"
    #=================================================
    #   Execute
    #=================================================
    foreach ($FeatureName in $EnableFeature) {
        Write-Host $FeatureName -ForegroundColor DarkGray
        Try {
            $CurrentLog = "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Enable-WindowsOptionalFeatureOS.log"
            Write-Verbose "CurrentLog: $CurrentLog"
            Enable-WindowsOptionalFeature -FeatureName $FeatureName -Path "$MountDirectory" -All -LogPath "$CurrentLog" | Out-Null
        }
        Catch {
            $ErrorMessage = $_.Exception.Message
            Write-Warning "$ErrorMessage"
        }
    }
    #=================================================
    #   Post Action
    #=================================================
    Update-CumulativeOS -Force
    Invoke-DismCleanupImage
    #=================================================
}
function Enable-WinREWiFi {
    [CmdletBinding()]
    param ()
    #=================================================
    #   Abort
    #=================================================
    if (($ScriptName -ne 'New-OSBuild') -and ($ScriptName -ne 'New-OSDCloudOSMedia')) {Return}
    if ($WinREWiFi -ne $true) {Return}
    #=================================================
    #   Header
    #=================================================
    Show-ActionTime; Write-Host -ForegroundColor Green "WinPE: Enable WinREWiFi"
    #=================================================
    #   Execute
    #=================================================
    if ($OSArchitecture -eq 'x64') {
        $IntelWirelessDriverUrl = 'https://downloadmirror.intel.com/30435/a08/WiFi_22.50.1_Driver64_Win10.zip'
    }
    else {
        $IntelWirelessDriverUrl = 'https://downloadmirror.intel.com/30435/a08/WiFi_22.50.1_Driver32_Win10.zip'
    }

    if (Test-WebConnection -Uri $IntelWirelessDriverUrl) {
        $SaveWebFile = Save-WebFile -SourceUrl $IntelWirelessDriverUrl
        if (Test-Path $SaveWebFile.FullName) {
            $DriverCab = Get-Item -Path $SaveWebFile.FullName
            $ExpandPath = Join-Path $DriverCab.Directory $DriverCab.BaseName
            Write-Verbose -Verbose "Expanding Intel Wireless Drivers to $ExpandPath"

            Expand-Archive -Path $DriverCab -DestinationPath $ExpandPath -Force
            Add-WindowsDriver -Path $MountWinRE -Driver $ExpandPath -Recurse -ForceUnsigned -Verbose
        }
    }
    else {
        Write-Warning "Unable to connect to $IntelWirelessDriverUrl"
    }
}
function Enable-WinPEOSDCloud {
    [CmdletBinding()]
    param ()
    #=================================================
    #   Abort
    #=================================================
    if (($ScriptName -ne 'New-OSBuild') -and ($ScriptName -ne 'New-PEBuild') -and ($ScriptName -ne 'New-OSDCloudOSMedia')) {Return}
    if ($WinPEOSDCloud -ne $true) {Return}
    #=================================================
    #   Header
    #=================================================
    Show-ActionTime; Write-Host -ForegroundColor Green "WinPE: OSDBuilder Function Enable-WinPEOSDCloud"
    #=================================================
    #   MountPaths
    #=================================================
    $MountPaths = @(
        $MountWinPE
        $MountWinRE
        $MountWinSE
    )
    #=======================================================================
    #	PowerShell Execution Policy
    #=======================================================================
    Write-Host -ForegroundColor DarkGray "========================================================================="
    Write-Host -ForegroundColor Cyan "Set WinPE PowerShell ExecutionPolicy to Bypass"
    Write-Host -ForegroundColor Yellow "OSD Function: Set-WindowsImageExecutionPolicy"
    foreach ($MountPath in $MountPaths) {
        Set-WindowsImageExecutionPolicy -Path $MountPath -ExecutionPolicy Bypass
    }
    #=======================================================================
    #   Enable PowerShell Gallery
    #=======================================================================
    Write-Host -ForegroundColor DarkGray "========================================================================="
    Write-Host -ForegroundColor Cyan "$((Get-Date).ToString('yyyy-MM-dd-HHmmss')) Enable WinPE PowerShell Gallery"
    Write-Host -ForegroundColor Yellow "OSD Function: Enable-PEWindowsImagePSGallery"
    foreach ($MountPath in $MountPaths) {
        Enable-PEWindowsImagePSGallery -Path $MountPath
    }

$RegistryConsole = @'
Windows Registry Editor Version 5.00

[HKEY_LOCAL_MACHINE\Default\Console]
"ColorTable00"=dword:000c0c0c
"ColorTable01"=dword:00da3700
"ColorTable02"=dword:000ea113
"ColorTable03"=dword:00dd963a
"ColorTable04"=dword:001f0fc5
"ColorTable05"=dword:00981788
"ColorTable06"=dword:00009cc1
"ColorTable07"=dword:00cccccc
"ColorTable08"=dword:00767676
"ColorTable09"=dword:00ff783b
"ColorTable10"=dword:000cc616
"ColorTable11"=dword:00d6d661
"ColorTable12"=dword:005648e7
"ColorTable13"=dword:009e00b4
"ColorTable14"=dword:00a5f1f9
"ColorTable15"=dword:00f2f2f2
"CtrlKeyShortcutsDisabled"=dword:00000000
"CursorColor"=dword:ffffffff
"CursorSize"=dword:00000019
"DefaultBackground"=dword:ffffffff
"DefaultForeground"=dword:ffffffff
"EnableColorSelection"=dword:00000000
"ExtendedEditKey"=dword:00000001
"ExtendedEditKeyCustom"=dword:00000000
"FaceName"="Consolas"
"FilterOnPaste"=dword:00000001
"FontFamily"=dword:00000036
"FontSize"=dword:00140000
"FontWeight"=dword:00000000
"ForceV2"=dword:00000000
"FullScreen"=dword:00000000
"HistoryBufferSize"=dword:00000032
"HistoryNoDup"=dword:00000000
"InsertMode"=dword:00000001
"LineSelection"=dword:00000001
"LineWrap"=dword:00000001
"LoadConIme"=dword:00000001
"NumberOfHistoryBuffers"=dword:00000004
"PopupColors"=dword:000000f5
"QuickEdit"=dword:00000001
"ScreenBufferSize"=dword:23290078
"ScreenColors"=dword:00000007
"ScrollScale"=dword:00000001
"TerminalScrolling"=dword:00000000
"TrimLeadingZeros"=dword:00000000
"WindowAlpha"=dword:000000ff
"WindowSize"=dword:001e0078
"WordDelimiters"=dword:00000000

[HKEY_LOCAL_MACHINE\Default\Console\%SystemRoot%_System32_cmd.exe]
"FaceName"="Consolas"
"FilterOnPaste"=dword:00000000
"FontSize"=dword:00100000
"FontWeight"=dword:00000190
"LineSelection"=dword:00000000
"LineWrap"=dword:00000000
"WindowAlpha"=dword:00000000
"WindowPosition"=dword:00000000
"WindowSize"=dword:00110054

[HKEY_LOCAL_MACHINE\Default\Console\%SystemRoot%_System32_WindowsPowerShell_v1.0_powershell.exe]
"ColorTable05"=dword:00562401
"ColorTable06"=dword:00f0edee
"FaceName"="Consolas"
"FilterOnPaste"=dword:00000000
"FontFamily"=dword:00000036
"FontSize"=dword:00140000
"FontWeight"=dword:00000190
"LineSelection"=dword:00000000
"LineWrap"=dword:00000000
"PopupColors"=dword:000000f3
"QuickEdit"=dword:00000001
"ScreenBufferSize"=dword:03e8012c
"ScreenColors"=dword:00000056
"WindowAlpha"=dword:00000000
"WindowSize"=dword:0020006c

[HKEY_LOCAL_MACHINE\Default\Console\%SystemRoot%_SysWOW64_WindowsPowerShell_v1.0_powershell.exe]
"ColorTable05"=dword:00562401
"ColorTable06"=dword:00f0edee
"FaceName"="Consolas"
"FilterOnPaste"=dword:00000000
"FontFamily"=dword:00000036
"FontSize"=dword:00140000
"FontWeight"=dword:00000190
"LineSelection"=dword:00000000
"LineWrap"=dword:00000000
"PopupColors"=dword:000000f3
"QuickEdit"=dword:00000001
"ScreenBufferSize"=dword:03e8012c
"ScreenColors"=dword:00000056
"WindowAlpha"=dword:00000000
"WindowSize"=dword:0020006c
'@
    #=======================================================================
    #   Registry Fixes
    #=======================================================================
    Write-Host -ForegroundColor DarkGray "========================================================================="
    Write-Host -ForegroundColor Cyan "$((Get-Date).ToString('yyyy-MM-dd-HHmmss')) Modifying WinPE CMD and PowerShell Console settings"
    Write-Host -ForegroundColor Yellow "This increases the buffer and sets the window metrics and default fonts"
    $RegistryConsole | Out-File -FilePath "$env:TEMP\RegistryConsole.reg" -Encoding ascii -Force

    foreach ($MountPath in $MountPaths) {
        reg load HKLM\Default "$MountPath\Windows\System32\Config\DEFAULT"
        reg import "$env:TEMP\RegistryConsole.reg" | Out-Null -ErrorAction Ignore
        reg unload HKLM\Default
    }
    #=======================================================================
    #   OSD Module
    #=======================================================================
    Write-Host -ForegroundColor Yellow "Saving OSD PowerShell Module to mounted WinPE at Program Files\WindowsPowerShell\Modules"
    if ($ScriptName -ne 'New-PEBuild') {
        Save-Module -Name OSD -Path "$MountWinPE\Program Files\WindowsPowerShell\Modules" -Force
        Save-Module -Name OSD -Path "$MountWinRE\Program Files\WindowsPowerShell\Modules" -Force
        Save-Module -Name OSD -Path "$MountWinSE\Program Files\WindowsPowerShell\Modules" -Force
    }
    else {
        Save-Module -Name OSD -Path "$MountDirectory\Program Files\WindowsPowerShell\Modules" -Force
    }
}
function Expand-DaRTPE {
    [CmdletBinding()]
    param ()
    #=================================================
    #   Abort
    #=================================================
    if (($ScriptName -ne 'New-OSBuild') -and ($ScriptName -ne 'New-PEBuild')) {Return}
    if ([string]::IsNullOrWhiteSpace($WinPEDaRT)) {Return}
    #=================================================
    #   Header
    #=================================================
    $MicrosoftDartCab = "$SetOSDBuilderPathContent\$WinPEDaRT"
    Show-ActionTime; Write-Host -ForegroundColor Green "Microsoft DaRT: $MicrosoftDartCab"
    #=================================================
    #   Execute
    #=================================================
    if (Test-Path "$MicrosoftDartCab") {
        if ($MountWinPE) {expand.exe "$MicrosoftDartCab" -F:*.* "$MountWinPE" | Out-Null}
        if ($MountWinRE) {expand.exe "$MicrosoftDartCab" -F:*.* "$MountWinRE" | Out-Null}
        if ($MountWinSE) {expand.exe "$MicrosoftDartCab" -F:*.* "$MountWinSE" | Out-Null}

        $MicrosoftDartConfig = $(Join-Path $(Split-Path "$MicrosoftDartCab") 'DartConfig.dat')
        if (Test-Path $MicrosoftDartConfig) {
            if ($MountWinPE) {Copy-Item -Path $MicrosoftDartConfig -Destination "$MountWinPE\Windows\System32\DartConfig.dat" -Force}
            if ($MountWinRE) {Copy-Item -Path $MicrosoftDartConfig -Destination "$MountWinSE\Windows\System32\DartConfig.dat" -Force}
            if ($MountWinSE) {Copy-Item -Path $MicrosoftDartConfig -Destination "$MountWinRE\Windows\System32\DartConfig.dat" -Force}
        }

        $MicrosoftDartConfig = $(Join-Path $(Split-Path "$MicrosoftDartCab") 'DartConfig8.dat')
        if (Test-Path $MicrosoftDartConfig) {
            if ($MountWinPE) {Copy-Item -Path $MicrosoftDartConfig -Destination "$MountWinPE\Windows\System32\DartConfig.dat" -Force}
            if ($MountWinRE) {Copy-Item -Path $MicrosoftDartConfig -Destination "$MountWinSE\Windows\System32\DartConfig.dat" -Force}
            if ($MountWinSE) {Copy-Item -Path $MicrosoftDartConfig -Destination "$MountWinRE\Windows\System32\DartConfig.dat" -Force}
        }

        if ($ScriptName -eq 'New-OSBuild') {
            if (Test-Path "$MountWinPE\Windows\System32\winpeshl.ini") {Remove-Item -Path "$MountWinPE\Windows\System32\winpeshl.ini" -Force}
            (Get-Content "$MountWinRE\Windows\System32\winpeshl.ini") | ForEach-Object {$_ -replace '-prompt','-network'} | Out-File "$MountWinRE\Windows\System32\winpeshl.ini"
            if (Test-Path "$MountWinSE\Windows\System32\winpeshl.ini") {Remove-Item -Path "$MountWinSE\Windows\System32\winpeshl.ini" -Force}
        }

        if ($ScriptName -eq 'New-PEBuild') {
            if ($WinPEOutput -eq 'Recovery') {
                (Get-Content "$MountDirectory\Windows\System32\winpeshl.ini") | ForEach-Object {$_ -replace '-prompt','-network'} | Out-File "$MountDirectory\Windows\System32\winpeshl.ini"
            } else {
                if (Test-Path "$MountDirectory\Windows\System32\winpeshl.ini") {Remove-Item -Path "$MountDirectory\Windows\System32\winpeshl.ini" -Force}
            }
        }
    } else {Write-Warning "Microsoft DaRT do not exist in $MicrosoftDartCab"}
}
function Export-InstallwimOS {
    [CmdletBinding()]
    param ()
    #=================================================
    #   Header
    #=================================================
    Show-ActionTime
    Write-Host -ForegroundColor Green "OS: Export to $OS\sources\install.wim"
    #=================================================
    #   Execute
    #=================================================
    $CurrentLog = "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Export-WindowsImage.log"
    Write-Verbose "CurrentLog: $CurrentLog"
    Export-WindowsImage -SourceImagePath "$WimTemp\install.wim" -SourceIndex 1 -DestinationImagePath "$OS\sources\install.wim" -LogPath "$CurrentLog" | Out-Null
}
function Export-PEBootWim {
    [CmdletBinding()]
    param (
        [string]$OSMediaPath
    )
    #=================================================
    #   Header
    #=================================================
    Show-ActionTime
    Write-Host -ForegroundColor Green "WinPE: Rebuild $OSMediaPath\OS\sources\boot.wim"
    #=================================================
    #   Execute
    #=================================================
    $CurrentLog = "$OSMediaPath\WinPE\info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Export-WindowsImage-WinPE.log"
    Write-Verbose "CurrentLog: $CurrentLog"
    Export-WindowsImage -SourceImagePath "$OSMediaPath\WimTemp\winpe.wim" -SourceIndex 1 -DestinationImagePath "$OSMediaPath\WinPE\boot.wim" -LogPath "$CurrentLog" | Out-Null
    
    $CurrentLog = "$OSMediaPath\WinPE\info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Export-WindowsImage-WinSE.log"
    Write-Verbose "CurrentLog: $CurrentLog"
    Export-WindowsImage -SourceImagePath "$OSMediaPath\WimTemp\winse.wim" -SourceIndex 1 -DestinationImagePath "$OSMediaPath\WinPE\boot.wim" -Setbootable -LogPath "$CurrentLog" | Out-Null
    Copy-Item -Path "$OSMediaPath\WinPE\boot.wim" -Destination "$OSMediaPath\OS\sources\boot.wim" -Force | Out-Null
}
function Export-PEWims {
    [CmdletBinding()]
    param (
        [string]$OSMediaPath
    )
    #=================================================
    #   Header
    #=================================================
    Show-ActionTime
    Write-Host -ForegroundColor Green "WinPE: Export WIMs to $OSMediaPath\WinPE"
    #=================================================
    #   Execute
    #=================================================
    $CurrentLog = "$OSMediaPath\WinPE\info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Export-WindowsImage-WinPE.log"
    Write-Verbose "CurrentLog: $CurrentLog"
    Export-WindowsImage -SourceImagePath "$OSMediaPath\WimTemp\winpe.wim" -SourceIndex 1 -DestinationImagePath "$OSMediaPath\WinPE\winpe.wim" -LogPath "$CurrentLog" | Out-Null
    
    $CurrentLog = "$OSMediaPath\WinPE\info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Export-WindowsImage-WinRE.log"
    Write-Verbose "CurrentLog: $CurrentLog"
    Export-WindowsImage -SourceImagePath "$OSMediaPath\WimTemp\winre.wim" -SourceIndex 1 -DestinationImagePath "$OSMediaPath\WinPE\winre.wim" -LogPath "$CurrentLog" | Out-Null

    $CurrentLog = "$OSMediaPath\WinPE\info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Export-WindowsImage-WinSE.log"
    Write-Verbose "CurrentLog: $CurrentLog"
    Export-WindowsImage -SourceImagePath "$OSMediaPath\WimTemp\winse.wim" -SourceIndex 1 -DestinationImagePath "$OSMediaPath\WinPE\winse.wim" -LogPath "$CurrentLog" | Out-Null
}
function Export-SessionsXmlOS {
    [CmdletBinding()]
    param (
        [string]$OSMediaPath
    )
    Write-Verbose "$OSMediaPath\Sessions.xml"
    Copy-Item "$OSMediaPath\Sessions.xml" "$OSMediaPath\info\Sessions.xml" -Force | Out-Null

    [xml]$SessionsXML = Get-Content -Path "$OSMediaPath\info\Sessions.xml"

    $Sessions = $SessionsXML.SelectNodes('Sessions/Session') | ForEach-Object {
        New-Object -Type PSObject -Property @{
            Id = $_.Tasks.Phase.package.id
            KBNumber = $_.Tasks.Phase.package.name
            TargetState = $_.Tasks.Phase.package.targetState
            Client = $_.Client
            Complete = $_.Complete
            Status = $_.Status
        }
    }
    
    $Sessions = $Sessions | Where-Object {$_.Id -like "Package*"}
    $Sessions = $Sessions | Select-Object -Property Id, KBNumber, TargetState, Client, Status, Complete | Sort-Object Complete -Descending

    $Sessions | Out-File "$OSMediaPath\Sessions.txt"
    $Sessions | Out-File "$OSMediaPath\info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Sessions.txt"
    $Sessions | Export-Clixml -Path "$OSMediaPath\info\xml\Sessions.xml"
    $Sessions | Export-Clixml -Path "$OSMediaPath\info\xml\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Sessions.xml"
    $Sessions | ConvertTo-Json | Out-File "$OSMediaPath\info\json\Sessions.json"
    $Sessions | ConvertTo-Json | Out-File "$OSMediaPath\info\json\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Sessions.json"

    Remove-Item "$OSMediaPath\Sessions.xml" -Force | Out-Null
}
function Get-FeatureUpdateDownloads {
    $FeatureUpdateDownloads = @()
    $FeatureUpdateDownloads = Get-WSUSXML FeatureUpdate
<#     $CatalogsXmls = @()
    $CatalogsXmls = Get-ChildItem "$($MyInvocation.MyCommand.Module.ModuleBase)\CatalogsESD\*" -Include *.xml
    foreach ($CatalogsXml in $CatalogsXmls) {
        $FeatureUpdateDownloads += Import-Clixml -Path "$($CatalogsXml.FullName)"
    } #>
    #=================================================
    #   Get Downloadeds
    #=================================================
    foreach ($Download in $FeatureUpdateDownloads) {
        $FullUpdatePath = Join-Path $SetOSDBuilderPathFeatureUpdates $Download.FileName
        if (Test-Path $FullUpdatePath) {
            $Download.OSDStatus = "Downloaded"
        }
    }
    #=================================================
    #   Return
    #=================================================
    $FeatureUpdateDownloads = $FeatureUpdateDownloads | Select-Object -Property * | Sort-Object -Property CreationDate -Descending
    Return $FeatureUpdateDownloads
}
function Get-IsContentPacksEnabled {
    [CmdletBinding()]
    param ()
    if ($global:SetOSDBuilder.AllowContentPacks -eq $false) {Return $false}
    if (Test-Path $SetOSDBuilderPathTemplates\Drivers) {Return $false}
    if (Test-Path $SetOSDBuilderPathTemplates\ExtraFiles) {Return $false}
    if (Test-Path $SetOSDBuilderPathTemplates\Registry) {Return $false}
    if (Test-Path $SetOSDBuilderPathTemplates\Scripts) {Return $false}
    Return $true
}
function Get-IsTemplatesEnabled {
    #Is Templates Content enabled
    [CmdletBinding()]
    param ()
    if (Test-Path $SetOSDBuilderPathTemplates\Drivers) {Return $true}
    if (Test-Path $SetOSDBuilderPathTemplates\ExtraFiles) {Return $true}
    if (Test-Path $SetOSDBuilderPathTemplates\Registry) {Return $true}
    if (Test-Path $SetOSDBuilderPathTemplates\Scripts) {Return $true}
    Return $false
}
function Get-OSBuildTask {
    [CmdletBinding()]
    param (
        [switch]$GridView
    )

    Begin {
        #Write-Host '========================================================================================' -ForegroundColor DarkGray
        #Write-Host "$($MyInvocation.MyCommand.Name) BEGIN"

        #=================================================
        Write-Verbose '19.1.1 Initialize OSDBuilder'
        #=================================================
        Get-OSDBuilder -CreatePaths -HideDetails

        #=================================================
        Write-Verbose '19.1.1 Gather All OSBuildTask'
        #=================================================
        $AllOSBuildTasks = @()
        $AllOSBuildTasks = Get-ChildItem -Path $SetOSDBuilderPathTasks OSBuild*.json -File | Select-Object -Property *
    }

    Process {
        #Write-Host '========================================================================================' -ForegroundColor DarkGray
        #Write-Host "$($MyInvocation.MyCommand.Name) PROCESS"

        $OSBuildTask = foreach ($Item in $AllOSBuildTasks) {
            #=================================================
            #Write-Verbose '19.1.1 Get Windows Image Information'
            #=================================================
            $OSBuildTaskPath = $($Item.FullName)
            Write-Verbose "OSBuildTask Full Path: $OSBuildTaskPath"
            $OSBTask = @()
            $OSBTask = Get-Content "$($Item.FullName)" | ConvertFrom-Json

            $OSBTaskProps = @()
            $OSBTaskProps = Get-Item "$($Item.FullName)" | Select-Object -Property *
            
            if ([System.Version]$OSBTask.TaskVersion -lt [System.Version]"19.1.3.0") {
                $ObjectProperties = @{
                    LastWriteTime       = $OSBTaskProps.LastWriteTime
                    TaskName            = $OSBTask.TaskName
                    TaskVersion         = $OSBTask.TaskVersion
                    OSMediaName         = $OSBTask.MediaName
                    FullName            = $Item.FullName
                }
                New-Object -TypeName PSObject -Property $ObjectProperties
                Write-Verbose ""
            }

            if ([System.Version]$OSBTask.TaskVersion -gt [System.Version]"19.1.3.0") {
                if ($OSBTask.ReleaseId -match '2009') {$OSBTask.ReleaseId = '20H2'}

                if ($null -eq $OSBTask.Languages) {
                    Write-Warning "Reading Task: $OSBuildTaskPath"
                    Write-Warning "Searching for OSMFamily: $($OSBTask.OSMFamily)"
                    $LangUpdate = Get-OSMedia | Where-Object {$_.OSMFamilyV1 -eq $OSBTask.OSMFamily} | Select-Object -Last 1
                    Write-Warning "Adding Language: $($LangUpdate.Languages)"
                    $OSBTask | Add-Member -Type NoteProperty -Name 'Languages' -Value "$LangUpdate.Languages"
                    $OSBTask.Languages = $LangUpdate.Languages
                    $OSBTask.OSMFamily = $OSBTask.InstallationType + " " + $OSBTask.EditionId + " " + $OSBTask.Arch + " " + [string]$OSBTask.Build + " " + $OSBTask.Languages
                    Write-Warning "Updating OSMFamily: $($OSBTask.OSMFamily)"
                    Write-Warning "Updating Task: $OSBuildTaskPath"
                    $OSBTask | ConvertTo-Json | Out-File $OSBuildTaskPath
                    Write-Host ""
                }

                $ObjectProperties = @{
                    TaskType            = $OSBTask.TaskType
                    TaskVersion         = $OSBTask.TaskVersion
                    TaskName            = $OSBTask.TaskName
                    TaskGuid            = $OSBTask.TaskGuid
                    CustomName          = $OSBTask.CustomName
                    SourceOSMedia       = $OSBTask.Name
                    ImageName           = $OSBTask.ImageName
                    Arch                = $OSBTask.Arch
                    ReleaseId           = $OSBTask.ReleaseId
                    UBR                 = $OSBTask.UBR
                    Languages           = $OSBTask.Languages
                    EditionId           = $OSBTask.EditionId
                    FullName            = $Item.FullName
                    LastWriteTime       = $OSBTaskProps.LastWriteTime
                    CreatedTime         = [datetime]$OSBTask.CreatedTime
                    ModifiedTime        = [datetime]$OSBTask.ModifiedTime
                    OSMFamily           = $OSBTask.OSMFamily
                    OSMGuid             = $OSBTask.OSMGuid
                }
                New-Object -TypeName PSObject -Property $ObjectProperties
                Write-Verbose ""
            }
        }

        #=================================================
        #Write-Verbose '19.1.3 Output'
        #=================================================
        if ($GridView.IsPresent) {$OSBuildTask | Select-Object TaskType,TaskVersion,TaskName,CustomName,SourceOSMedia,ImageName,Arch,ReleaseId,UBR,Languages,EditionId,FullName,LastWriteTime,OSMFamily,OSMGuid | Sort-Object TaskName | Out-GridView -PassThru -Title 'OSBuildTask'}
        else {$OSBuildTask | Select-Object TaskType,TaskVersion,TaskName,CustomName,SourceOSMedia,ImageName,Arch,ReleaseId,UBR,Languages,EditionId,FullName,LastWriteTime,OSMFamily,OSMGuid | Sort-Object TaskName }
    }

    END {
        #Write-Host '========================================================================================' -ForegroundColor DarkGray
        #Write-Host "$($MyInvocation.MyCommand.Name) END"
    }
}
function Get-OSDFromJson
{
    param(
        [Parameter(Mandatory=$true, Position=1)]
        [string]$Path
    )

    function Get-Value {
        param( $value )

        $result = $null
        if ( $value -is [System.Management.Automation.PSCustomObject] )
        {
            Write-Verbose "Get-Value: value is PSCustomObject"
            $result = @{}
            $value.psobject.properties | ForEach-Object { 
                $result[$_.Name] = Get-Value -value $_.Value 
            }
        }
        elseif ($value -is [System.Object[]])
        {
            $list = New-Object System.Collections.ArrayList
            Write-Verbose "Get-Value: value is Array"
            $value | ForEach-Object {
                $list.Add((Get-Value -value $_)) | Out-Null
            }
            $result = $list
        }
        else
        {
            Write-Verbose "Get-Value: value is type: $($value.GetType())"
            $result = $value
        }
        return $result
    }


    if (Test-Path $Path)
    {
        $json = Get-Content $Path -Raw
    }
    else
    {
        $json = '{}'
    }

    $hashtable = Get-Value -value (ConvertFrom-Json $json)

    return $hashtable
}
function Get-OSDUpdateDownloads {
    [CmdletBinding()]
    param (
        [string]$OSDGuid,
        [string]$UpdateTitle,
        [switch]$Silent
    )
    #=================================================
    #   Filtering
    #=================================================
    if ($OSDGuid) {
        $OSDUpdateDownload = Get-OSDUpdates -Silent | Where-Object {$_.OSDGuid -eq $OSDGuid}
    } elseif ($UpdateTitle) {
        $OSDUpdateDownload = Get-OSDUpdates -Silent | Where-Object {$_.UpdateTitle -eq $UpdateTitle}
    } else {
        Break
    }
    #=================================================
    #   Download
    #=================================================
    foreach ($Update in $OSDUpdateDownload) {
        $DownloadPath = $SetOSDBuilderPathUpdates
        $DownloadFullPath = Join-Path $DownloadPath $(Split-Path $Update.OriginUri -Leaf)
        #=================================================
        #	Download
        #=================================================
        $SourceUrl = $Update.OriginUri
        $SourceUrl = [Uri]::EscapeUriString($SourceUrl)

        if (!(Test-Path $DownloadPath)) {New-Item -Path "$DownloadPath" -ItemType Directory -Force | Out-Null}
        if (!(Test-Path $DownloadFullPath)) {
            Write-Host "$DownloadFullPath"
            Write-Host "$($Update.OriginUri)" -ForegroundColor Gray
            if (Get-Command 'curl.exe' -ErrorAction SilentlyContinue) {
                Write-Verbose "cURL: $SourceUrl"
                if ($host.name -match 'ConsoleHost') {
                    Invoke-Expression "& curl.exe --insecure --location --output `"$DownloadFullPath`" --url `"$SourceUrl`""
                }
                else {
                    #PowerShell ISE will display a NativeCommandError, so progress will not be displayed
                    $Quiet = Invoke-Expression "& curl.exe --insecure --location --output `"$DownloadFullPath`" --url `"$SourceUrl`" 2>&1"
                }
            }
            else {
                [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls1
                $WebClient = New-Object System.Net.WebClient
                $WebClient.DownloadFile("$SourceUrl", "$DownloadFullPath")
                $WebClient.Dispose()
            }
        }
    }
}
function Get-OSDUpdates {
    param (
        [switch]$Silent
    )
    $AllOSDUpdates = @()
    if ($Silent.IsPresent) {
        $AllOSDUpdates = Get-WSUSXML Windows -Silent
    } else {
        $AllOSDUpdates = Get-WSUSXML Windows
    }
    #=================================================
    #   Get Downloaded Updates
    #=================================================
    foreach ($Update in $AllOSDUpdates) {
        $FullUpdatePath = Join-Path $SetOSDBuilderPathUpdates $(Split-Path $Update.OriginUri -Leaf)

        if (Test-Path $FullUpdatePath) {
            $Update.OSDStatus = "Downloaded"
        }
    }
    #=================================================
    #   Return
    #=================================================
    $AllOSDUpdates = $AllOSDUpdates | Select-Object -Property *
    Return $AllOSDUpdates
}
function Get-OSTemplateDrivers {
    [CmdletBinding()]
    param ()
    #=================================================
    #   Abort
    #=================================================
    if (Get-IsContentPacksEnabled) {Return}
    #=================================================
    #   Process
    #=================================================
    $DriverTemplates = @()

    #Write-Host "$SetOSDBuilderPathTemplates\Drivers\AutoApply\Global" -ForegroundColor Gray
    [array]$DriverTemplates = Get-Item "$SetOSDBuilderPathTemplates\Drivers\AutoApply\Global"

    #Write-Host "$SetOSDBuilderPathTemplates\Drivers\AutoApply\Global $OSArchitecture" -ForegroundColor Gray
    [array]$DriverTemplates += Get-Item "$SetOSDBuilderPathTemplates\Drivers\AutoApply\Global $OSArchitecture"

    #Write-Host "$SetOSDBuilderPathTemplates\Drivers\AutoApply\$UpdateOS" -ForegroundColor Gray
    [array]$DriverTemplates += Get-Item "$SetOSDBuilderPathTemplates\Drivers\AutoApply\$UpdateOS"

    if ($OSInstallationType -notlike "*Server*") {
        #Write-Host "$SetOSDBuilderPathTemplates\Drivers\AutoApply\$UpdateOS $OSArchitecture" -ForegroundColor Gray
        [array]$DriverTemplates += Get-Item "$SetOSDBuilderPathTemplates\Drivers\AutoApply\$UpdateOS $OSArchitecture"
    }
    if ($OSInstallationType -notlike "*Server*" -and $OSMajorVersion -eq 10) {
        #Write-Host "$SetOSDBuilderPathTemplates\Drivers\AutoApply\$UpdateOS $OSArchitecture $ReleaseId" -ForegroundColor Gray
        [array]$DriverTemplates += Get-Item "$SetOSDBuilderPathTemplates\Drivers\AutoApply\$UpdateOS $OSArchitecture $ReleaseId"
    }
    Return $DriverTemplates
}
function Get-OSTemplateExtraFiles {
    [CmdletBinding()]
    param ()
    #=================================================
    #   Abort
    #=================================================
    if (Get-IsContentPacksEnabled) {Return}
    #=================================================
    #   Process
    #=================================================
    $ExtraFilesTemplates = @()

    #Write-Host "$SetOSDBuilderPathTemplates\ExtraFiles\AutoApply\Global" -ForegroundColor DarkGray
    [array]$ExtraFilesTemplates = Get-ChildItem "$SetOSDBuilderPathTemplates\ExtraFiles\AutoApply\Global" | Where-Object {$_.PSIsContainer -eq $true} 

    #Write-Host "$SetOSDBuilderPathTemplates\ExtraFiles\AutoApply\Global $OSArchitecture" -ForegroundColor DarkGray
    [array]$ExtraFilesTemplates += Get-ChildItem "$SetOSDBuilderPathTemplates\ExtraFiles\AutoApply\Global $OSArchitecture" | Where-Object {$_.PSIsContainer -eq $true} 

    #Write-Host "$SetOSDBuilderPathTemplates\ExtraFiles\AutoApply\$UpdateOS" -ForegroundColor DarkGray
    [array]$ExtraFilesTemplates += Get-ChildItem "$SetOSDBuilderPathTemplates\ExtraFiles\AutoApply\$UpdateOS" | Where-Object {$_.PSIsContainer -eq $true} 

    if ($OSInstallationType -notlike "*Server*") {
        #Write-Host "$SetOSDBuilderPathTemplates\ExtraFiles\AutoApply\$UpdateOS $OSArchitecture" -ForegroundColor DarkGray
        [array]$ExtraFilesTemplates += Get-ChildItem "$SetOSDBuilderPathTemplates\ExtraFiles\AutoApply\$UpdateOS $OSArchitecture" | Where-Object {$_.PSIsContainer -eq $true} 
    }
    if ($OSInstallationType -notlike "*Server*" -and $OSMajorVersion -eq 10) {
        #Write-Host "$SetOSDBuilderPathTemplates\ExtraFiles\AutoApply\$UpdateOS $OSArchitecture $ReleaseId" -ForegroundColor DarkGray
        [array]$ExtraFilesTemplates += Get-ChildItem "$SetOSDBuilderPathTemplates\ExtraFiles\AutoApply\$UpdateOS $OSArchitecture $ReleaseId" | Where-Object {$_.PSIsContainer -eq $true} 
    }
    Return $ExtraFilesTemplates
}
function Get-OSTemplateRegistryReg {
    [CmdletBinding()]
    param ()
    #=================================================
    #   Abort
    #=================================================
    if (Get-IsContentPacksEnabled) {Return}
    #=================================================
    #   Process
    #=================================================
    $RegistryTemplatesRegOriginal = @()
    $RegistryTemplatesRegOriginal = Get-ChildItem "$SetOSDBuilderPathTemplates\Registry\AutoApply" *.reg -Recurse | Select-Object -Property Name, BaseName, Extension, Directory, FullName
    
    foreach ($REG in $RegistryTemplatesRegOriginal) {
        if (!(Test-Path "$($REG.FullName).Offline")) {
           Write-Host "Creating $($REG.FullName).Offline" -ForegroundColor DarkGray
           $REGContent = Get-Content -Path $REG.FullName
            $REGContent = $REGContent -replace 'HKEY_CURRENT_USER','HKEY_LOCAL_MACHINE\OfflineDefaultUser'
            $REGContent = $REGContent -replace 'HKEY_LOCAL_MACHINE\\SOFTWARE','HKEY_LOCAL_MACHINE\OfflineSoftware'
            $REGContent = $REGContent -replace 'HKEY_LOCAL_MACHINE\\SYSTEM','HKEY_LOCAL_MACHINE\OfflineSystem'
            $REGContent = $REGContent -replace 'HKEY_USERS\\.DEFAULT','HKEY_LOCAL_MACHINE\OfflineDefault'
           $REGContent | Set-Content "$($REG.FullName).Offline" -Force
        }
    }

    $RegistryTemplatesReg = @()

    #Write-Host "$SetOSDBuilderPathTemplates\Registry\AutoApply\Global" -ForegroundColor DarkGray
    [array]$RegistryTemplatesReg = Get-ChildItem "$SetOSDBuilderPathTemplates\Registry\AutoApply\Global\*" *.reg.Offline -Recurse

    #Write-Host "$SetOSDBuilderPathTemplates\Registry\AutoApply\Global $OSArchitecture" -ForegroundColor DarkGray
    [array]$RegistryTemplatesReg += Get-ChildItem "$SetOSDBuilderPathTemplates\Registry\AutoApply\Global $OSArchitecture\*" *.reg.Offline -Recurse

    #Write-Host "$SetOSDBuilderPathTemplates\Registry\AutoApply\$UpdateOS" -ForegroundColor DarkGray
    [array]$RegistryTemplatesReg += Get-ChildItem "$SetOSDBuilderPathTemplates\Registry\AutoApply\$UpdateOS\*" *.reg.Offline -Recurse

    if ($OSInstallationType -notlike "*Server*") {
        #Write-Host "$SetOSDBuilderPathTemplates\Registry\AutoApply\$UpdateOS $OSArchitecture" -ForegroundColor DarkGray
        [array]$RegistryTemplatesReg += Get-ChildItem "$SetOSDBuilderPathTemplates\Registry\AutoApply\$UpdateOS $OSArchitecture\*" *.reg.Offline -Recurse
    }
    if ($OSInstallationType -notlike "*Server*" -and $OSMajorVersion -eq 10) {
        #Write-Host "$SetOSDBuilderPathTemplates\Registry\AutoApply\$UpdateOS $OSArchitecture $ReleaseId" -ForegroundColor DarkGray
        [array]$RegistryTemplatesReg += Get-ChildItem "$SetOSDBuilderPathTemplates\Registry\AutoApply\$UpdateOS $OSArchitecture $ReleaseId\*" *.reg.Offline -Recurse
    }
    Return $RegistryTemplatesReg
}
function Get-OSTemplateRegistryXml {
    [CmdletBinding()]
    param ()
    #=================================================
    #   Abort
    #=================================================
    if (Get-IsContentPacksEnabled) {Return}
    #=================================================
    #   Process
    #=================================================
    $RegistryTemplatesXml = @()

    #Write-Host "$SetOSDBuilderPathTemplates\Registry\AutoApply\Global" -ForegroundColor DarkGray
    [array]$RegistryTemplatesXml = Get-ChildItem "$SetOSDBuilderPathTemplates\Registry\AutoApply\Global\*" *.xml -Recurse

    #Write-Host "$SetOSDBuilderPathTemplates\Registry\AutoApply\Global $OSArchitecture" -ForegroundColor DarkGray
    [array]$RegistryTemplatesXml += Get-ChildItem "$SetOSDBuilderPathTemplates\Registry\AutoApply\Global $OSArchitecture\*" *.xml -Recurse

    #Write-Host "$SetOSDBuilderPathTemplates\Registry\AutoApply\$UpdateOS" -ForegroundColor DarkGray
    [array]$RegistryTemplatesXml += Get-ChildItem "$SetOSDBuilderPathTemplates\Registry\AutoApply\$UpdateOS\*" *.xml -Recurse

    if ($OSInstallationType -notlike "*Server*") {
        #Write-Host "$SetOSDBuilderPathTemplates\Registry\AutoApply\$UpdateOS $OSArchitecture" -ForegroundColor DarkGray
        [array]$RegistryTemplatesXml += Get-ChildItem "$SetOSDBuilderPathTemplates\Registry\AutoApply\$UpdateOS $OSArchitecture\*" *.xml -Recurse
    }
    if ($OSInstallationType -notlike "*Server*" -and $OSMajorVersion -eq 10) {
        #Write-Host "$SetOSDBuilderPathTemplates\Registry\AutoApply\$UpdateOS $OSArchitecture $ReleaseId" -ForegroundColor DarkGray
        [array]$RegistryTemplatesXml += Get-ChildItem "$SetOSDBuilderPathTemplates\Registry\AutoApply\$UpdateOS $OSArchitecture $ReleaseId\*" *.xml -Recurse
    }
    Return $RegistryTemplatesXml
}
function Get-OSTemplateScripts {
    [CmdletBinding()]
    param ()
    #=================================================
    #   Abort
    #=================================================
    if (Get-IsContentPacksEnabled) {Return}
    #=================================================
    #   Process
    #=================================================
    $ScriptTemplates = @()

    #Write-Host "$SetOSDBuilderPathTemplates\Scripts\AutoApply\Global" -ForegroundColor DarkGray
    [array]$ScriptTemplates = Get-ChildItem "$SetOSDBuilderPathTemplates\Scripts\AutoApply\Global\*" *.ps1 -Recurse

    #Write-Host "$SetOSDBuilderPathTemplates\Scripts\AutoApply\Global $OSArchitecture" -ForegroundColor DarkGray
    [array]$ScriptTemplates += Get-ChildItem "$SetOSDBuilderPathTemplates\Scripts\AutoApply\Global $OSArchitecture\*" *.ps1 -Recurse

    #Write-Host "$SetOSDBuilderPathTemplates\Scripts\AutoApply\$UpdateOS" -ForegroundColor DarkGray
    [array]$ScriptTemplates += Get-ChildItem "$SetOSDBuilderPathTemplates\Scripts\AutoApply\$UpdateOS\*" *.ps1 -Recurse

    if ($OSInstallationType -notlike "*Server*") {
        #Write-Host "$SetOSDBuilderPathTemplates\Scripts\AutoApply\$UpdateOS $OSArchitecture" -ForegroundColor DarkGray
        [array]$ScriptTemplates += Get-ChildItem "$SetOSDBuilderPathTemplates\Scripts\AutoApply\$UpdateOS $OSArchitecture\*" *.ps1 -Recurse
    }
    if ($OSInstallationType -notlike "*Server*" -and $OSMajorVersion -eq 10) {
        #Write-Host "$SetOSDBuilderPathTemplates\Scripts\AutoApply\$UpdateOS $OSArchitecture $ReleaseId" -ForegroundColor DarkGray
        [array]$ScriptTemplates += Get-ChildItem "$SetOSDBuilderPathTemplates\Scripts\AutoApply\$UpdateOS $OSArchitecture $ReleaseId\*" *.ps1 -Recurse
    }
    Return $ScriptTemplates
}
function Get-PEBuildTask {
    [CmdletBinding()]
    param (
        [switch]$GridView
    )

    Begin {
        #Write-Host '========================================================================================' -ForegroundColor DarkGray
        #Write-Host "$($MyInvocation.MyCommand.Name) BEGIN"

        #=================================================
        Write-Verbose '19.1.1 Initialize OSDBuilder'
        #=================================================
        Get-OSDBuilder -CreatePaths -HideDetails

        #=================================================
        Write-Verbose '19.1.1 Gather All PEBuildTask'
        #=================================================
        $AllPEBuildTasks = @()
        $AllPEBuildTasks = Get-ChildItem -Path $SetOSDBuilderPathTasks *.json -File | Select-Object -Property *
        $AllPEBuildTasks = $AllPEBuildTasks | Where-Object {$_.Name -like "MDT*" -or $_.Name -like "Recovery*" -or $_.Name -like "WinPE*"}
    }

    Process {
        #Write-Host '========================================================================================' -ForegroundColor DarkGray
        #Write-Host "$($MyInvocation.MyCommand.Name) PROCESS"

        $PEBuildTask = foreach ($Item in $AllPEBuildTasks) {
            #=================================================
            #Write-Verbose '19.1.1 Get Windows Image Information'
            #=================================================
            $PEBuildTaskPath = $($Item.FullName)
            Write-Verbose "PEBuildTask Full Path: $PEBuildTaskPath"
            
            $PEBTask = @()
            $PEBTask = Get-Content "$($Item.FullName)" | ConvertFrom-Json

            $PEBTaskProps = @()
            $PEBTaskProps = Get-Item "$($Item.FullName)" | Select-Object -Property *
            
            if ([System.Version]$PEBTask.TaskVersion -lt [System.Version]"19.1.3.0") {
                $ObjectProperties = @{
                    LastWriteTime       = $PEBTaskProps.LastWriteTime
                    TaskName            = $PEBTask.TaskName
                    TaskVersion         = $PEBTask.TaskVersion
                    Name                = $PEBTask.MediaName
                    FullName            = $Item.FullName
                }
                New-Object -TypeName PSObject -Property $ObjectProperties
                Write-Verbose ""
            }

            if ([System.Version]$PEBTask.TaskVersion -gt [System.Version]"19.1.3.0") {
                if ($PEBTask.ReleaseId -match '2009') {$PEBTask.ReleaseId = '20H2'}

                if ($null -eq $PEBTask.Languages) {
                    Write-Warning "Reading Task: $PEBuildTaskPath"
                    Write-Warning "Searching for OSMFamily: $($PEBTask.OSMFamily)"
                    $LangUpdate = Get-OSMedia | Where-Object {$_.OSMFamilyV1 -eq $PEBTask.OSMFamily} | Select-Object -Last 1
                    Write-Warning "Adding Language: $($LangUpdate.Languages)"
                    $PEBTask | Add-Member -Type NoteProperty -Name 'Languages' -Value "$LangUpdate.Languages"
                    $PEBTask.Languages = $LangUpdate.Languages
                    $PEBTask.OSMFamily = $PEBTask.InstallationType + " " + $PEBTask.EditionId + " " + $PEBTask.Arch + " " + [string]$PEBTask.Build + " " + $PEBTask.Languages
                    Write-Warning "Updating OSMFamily: $($PEBTask.OSMFamily)"
                    Write-Warning "Updating Task: $PEBuildTaskPath"
                    $PEBTask | ConvertTo-Json | Out-File $PEBuildTaskPath
                    Write-Host ""
                }

                $ObjectProperties = @{
                    TaskType            = $PEBTask.TaskType
                    TaskVersion         = $PEBTask.TaskVersion
                    TaskName            = $PEBTask.TaskName
                    TaskGuid            = $PEBTask.TaskGuid
                    CustomName          = $PEBTask.CustomName
                    SourceOSMedia       = $PEBTask.Name
                    ImageName           = $PEBTask.ImageName
                    Arch                = $PEBTask.Arch
                    ReleaseId           = $PEBTask.ReleaseId
                    UBR                 = $PEBTask.UBR
                    EditionId           = $PEBTask.EditionId
                    FullName            = $Item.FullName
                    LastWriteTime       = $PEBTaskProps.LastWriteTime
                    CreatedTime         = [datetime]$PEBTask.CreatedTime
                    ModifiedTime        = [datetime]$PEBTask.ModifiedTime
                    OSMFamily           = $PEBTask.OSMFamily
                    OSMGuid             = $PEBTask.OSMGuid
                }
                New-Object -TypeName PSObject -Property $ObjectProperties
                Write-Verbose ""
            }
        }

        #=================================================
        #Write-Verbose '19.1.3 Output'
        #=================================================
        if ($GridView.IsPresent) {$PEBuildTask | Select-Object TaskType,TaskVersion,TaskName,CustomName,SourceOSMedia,ImageName,Arch,ReleaseId,UBR,EditionId,FullName,LastWriteTime,OSMFamily,OSMGuid | Sort-Object TaskName | Out-GridView -PassThru -Title 'PEBuildTask'}
        else {$PEBuildTask | Select-Object TaskType,TaskVersion,TaskName,CustomName,SourceOSMedia,ImageName,Arch,ReleaseId,UBR,EditionId,FullName,LastWriteTime,OSMFamily,OSMGuid | Sort-Object TaskName }
    }

    End {
        #Write-Host '========================================================================================' -ForegroundColor DarkGray
        #Write-Host "$($MyInvocation.MyCommand.Name) END"
    }
}
function Get-TaskContentAddFeatureOnDemand {
    #=================================================
    #   Install.Wim Features On Demand
    #=================================================
    [CmdletBinding()]
    param ()
    $FeaturesOnDemandIsoExtractDir =@()
    $FeaturesOnDemandIsoExtractDir = $ContentIsoExtract

    if ($OSMedia.InstallationType -eq 'Client') {
        if ($($OSMedia.Arch) -eq 'x64') {$FeaturesOnDemandIsoExtractDir = $FeaturesOnDemandIsoExtractDir | Where-Object {$_.FullName -like "*x64*"}}
        if ($($OSMedia.Arch) -eq 'x86') {$FeaturesOnDemandIsoExtractDir = $FeaturesOnDemandIsoExtractDir | Where-Object {$_.FullName -like "*x86*"}}
    }

    $FeaturesOnDemandIsoExtractDir = $FeaturesOnDemandIsoExtractDir | Where-Object {$_.Name -notlike "*lp.cab"}
    $FeaturesOnDemandIsoExtractDir = $FeaturesOnDemandIsoExtractDir | Where-Object {$_.Name -notlike "*Language-Pack*"}
    $FeaturesOnDemandIsoExtractDir = $FeaturesOnDemandIsoExtractDir | Where-Object {$_.Name -notlike "*Language-Interface-Pack*"}
    $FeaturesOnDemandIsoExtractDir = $FeaturesOnDemandIsoExtractDir | Where-Object {$_.Name -notlike "*LanguageFeatures*"}
    $FeaturesOnDemandIsoExtractDir = $FeaturesOnDemandIsoExtractDir | Where-Object {$_.Name -notlike "*LanguageExperiencePack*"}
    $FeaturesOnDemandIsoExtractDir = $FeaturesOnDemandIsoExtractDir | Where-Object {$_.FullName -notlike "*metadata*"}

    if (($OSMedia.ReleaseId -gt 1803) -or ($OSMedia.ReleaseId -match '20H2') -or ($OSMedia.ReleaseId -match '21H1') -or ($OSMedia.ReleaseId -match '21H2')) {
        $FeaturesOnDemandIsoExtractDir = $FeaturesOnDemandIsoExtractDir | Where-Object {$_.Name -notlike "*ActiveDirectory*"}
        $FeaturesOnDemandIsoExtractDir = $FeaturesOnDemandIsoExtractDir | Where-Object {$_.Name -notlike "*BitLocker-Recovery*"}
        $FeaturesOnDemandIsoExtractDir = $FeaturesOnDemandIsoExtractDir | Where-Object {$_.Name -notlike "*CertificateServices*"}
        $FeaturesOnDemandIsoExtractDir = $FeaturesOnDemandIsoExtractDir | Where-Object {$_.Name -notlike "*DHCP-Tools*"}
        $FeaturesOnDemandIsoExtractDir = $FeaturesOnDemandIsoExtractDir | Where-Object {$_.Name -notlike "*DNS-Tools*"}
        $FeaturesOnDemandIsoExtractDir = $FeaturesOnDemandIsoExtractDir | Where-Object {$_.Name -notlike "*FailoverCluster*"}
        $FeaturesOnDemandIsoExtractDir = $FeaturesOnDemandIsoExtractDir | Where-Object {$_.Name -notlike "*FileServices-Tools*"}
        $FeaturesOnDemandIsoExtractDir = $FeaturesOnDemandIsoExtractDir | Where-Object {$_.Name -notlike "*GroupPolicy-Management*"}
        $FeaturesOnDemandIsoExtractDir = $FeaturesOnDemandIsoExtractDir | Where-Object {$_.Name -notlike "*IPAM-Client*"}
        $FeaturesOnDemandIsoExtractDir = $FeaturesOnDemandIsoExtractDir | Where-Object {$_.Name -notlike "*LLDP*"}
        $FeaturesOnDemandIsoExtractDir = $FeaturesOnDemandIsoExtractDir | Where-Object {$_.Name -notlike "*NetworkController*"}
        $FeaturesOnDemandIsoExtractDir = $FeaturesOnDemandIsoExtractDir | Where-Object {$_.Name -notlike "*NetworkLoadBalancing*"}
        $FeaturesOnDemandIsoExtractDir = $FeaturesOnDemandIsoExtractDir | Where-Object {$_.Name -notlike "*RasCMAK*"}
        $FeaturesOnDemandIsoExtractDir = $FeaturesOnDemandIsoExtractDir | Where-Object {$_.Name -notlike "*RasRip*"}
        $FeaturesOnDemandIsoExtractDir = $FeaturesOnDemandIsoExtractDir | Where-Object {$_.Name -notlike "*RemoteAccess-Management*"}
        $FeaturesOnDemandIsoExtractDir = $FeaturesOnDemandIsoExtractDir | Where-Object {$_.Name -notlike "*RemoteDesktop-Services*"}
        #$FeaturesOnDemandIsoExtractDir = $FeaturesOnDemandIsoExtractDir | Where-Object {$_.Name -notlike "*Server-AppCompat*"}
        $FeaturesOnDemandIsoExtractDir = $FeaturesOnDemandIsoExtractDir | Where-Object {$_.Name -notlike "*ServerManager-Tools*"}
        $FeaturesOnDemandIsoExtractDir = $FeaturesOnDemandIsoExtractDir | Where-Object {$_.Name -notlike "*Shielded-VM*"}
        $FeaturesOnDemandIsoExtractDir = $FeaturesOnDemandIsoExtractDir | Where-Object {$_.Name -notlike "*SNMP-Client*"}
        $FeaturesOnDemandIsoExtractDir = $FeaturesOnDemandIsoExtractDir | Where-Object {$_.Name -notlike "*StorageManagement*"}
        $FeaturesOnDemandIsoExtractDir = $FeaturesOnDemandIsoExtractDir | Where-Object {$_.Name -notlike "*StorageMigrationService*"}
        $FeaturesOnDemandIsoExtractDir = $FeaturesOnDemandIsoExtractDir | Where-Object {$_.Name -notlike "*StorageReplica*"}
        $FeaturesOnDemandIsoExtractDir = $FeaturesOnDemandIsoExtractDir | Where-Object {$_.Name -notlike "*SystemInsights*"}
        $FeaturesOnDemandIsoExtractDir = $FeaturesOnDemandIsoExtractDir | Where-Object {$_.Name -notlike "*VolumeActivation*"}
        $FeaturesOnDemandIsoExtractDir = $FeaturesOnDemandIsoExtractDir | Where-Object {$_.Name -notlike "*WMI-SNMP-Provider*"}
        $FeaturesOnDemandIsoExtractDir = $FeaturesOnDemandIsoExtractDir | Where-Object {$_.Name -notlike "*WSUS-Tools*"}
    }

    $FeaturesOnDemandUpdatesDir = @()
    if (Test-Path "$SetOSDBuilderPathContent\Updates\FeatureOnDemand") {
        $FeaturesOnDemandUpdatesDir = Get-ChildItem -Path "$SetOSDBuilderPathContent\Updates\FeatureOnDemand" *.cab -Recurse | Select-Object -Property Name, FullName
    }
    
    $AddFeatureOnDemand = [array]$FeaturesOnDemandIsoExtractDir + [array]$FeaturesOnDemandUpdatesDir

    if ($OSMedia.InstallationType -eq 'Client') {$AddFeatureOnDemand = $AddFeatureOnDemand | Where-Object {$_.FullName -notlike "*Windows Server*"}}
    if ($OSMedia.InstallationType -like "*Server*") {$AddFeatureOnDemand = $AddFeatureOnDemand | Where-Object {$_.FullName -like "*Windows Server*"}}
    if ($($OSMedia.ReleaseId)) {
        if ($($OSMedia.ReleaseId) -eq 1909) {
            $AddFeatureOnDemand = $AddFeatureOnDemand | Where-Object {$_.FullName -match '1903' -or $_.FullName -match '1909'}
        }
        elseif ($($OSMedia.ReleaseId) -eq 2009) {
            $AddFeatureOnDemand = $AddFeatureOnDemand | Where-Object {$_.FullName -match '2004' -or $_.FullName -match '2009' -or $_.FullName -match '20H2' -or $_.FullName -match '21H1' -or $_.FullName -match '21H2'}
        }
        elseif ($($OSMedia.ReleaseId) -eq '20H2') {
            $AddFeatureOnDemand = $AddFeatureOnDemand | Where-Object {$_.FullName -match '2004' -or $_.FullName -match '2009' -or $_.FullName -match '20H2' -or $_.FullName -match '21H1' -or $_.FullName -match '21H2'}
        }
        elseif ($($OSMedia.ReleaseId) -eq '21H1') {
            $AddFeatureOnDemand = $AddFeatureOnDemand | Where-Object {$_.FullName -match '2004' -or $_.FullName -match '2009' -or $_.FullName -match '20H2' -or $_.FullName -match '21H1' -or $_.FullName -match '21H2'}
        }
        elseif ($($OSMedia.ReleaseId) -eq '21H2') {
            $AddFeatureOnDemand = $AddFeatureOnDemand | Where-Object {$_.FullName -match '2004' -or $_.FullName -match '2009' -or $_.FullName -match '20H2' -or $_.FullName -match '21H1' -or $_.FullName -match '21H2'}
        }
        else {
            $AddFeatureOnDemand = $AddFeatureOnDemand | Where-Object {$_.FullName -match $OSMedia.ReleaseId}
        }
    }

    foreach ($Pack in $AddFeatureOnDemand) {$Pack.FullName = $($Pack.FullName).replace("$SetOSDBuilderPathContent\",'')}
    if ($null -eq $AddFeatureOnDemand) {Write-Warning "Install.wim Features On Demand: Not Found"}
    else {
        if ($ExistingTask.AddFeatureOnDemand) {
            foreach ($Item in $ExistingTask.AddFeatureOnDemand) {
                $AddFeatureOnDemand = $AddFeatureOnDemand | Where-Object {$_.FullName -ne $Item}
            }
        }
        $AddFeatureOnDemand = $AddFeatureOnDemand | Sort-Object -Property FullName | Out-GridView -Title "Install.wim Features On Demand: Select Packages to apply and press OK (Esc or Cancel to Skip)" -PassThru
    }
    foreach ($Item in $AddFeatureOnDemand) {Write-Host "$($Item.FullName)" -ForegroundColor White}
    Return $AddFeatureOnDemand
}
function Get-TaskContentAddWindowsPackage {
    #=================================================
    #   Content Packages
    #=================================================
    [CmdletBinding()]
    param ()
    $AddWindowsPackage = Get-ChildItem -Path "$GetOSDBuilderPathContentPackages\*" -Include *.cab, *.msu -Recurse | Select-Object -Property Name, FullName
    $AddWindowsPackage = $AddWindowsPackage | Where-Object {$_.FullName -like "*$($OSMedia.Arch)*"}
    foreach ($Item in $AddWindowsPackage) {$Item.FullName = $($Item.FullName).replace("$SetOSDBuilderPathContent\",'')}

    if ($null -eq $AddWindowsPackage) {Write-Warning "Packages: To select Windows Packages, add Content to $GetOSDBuilderPathContentPackages"}
    else {
        if ($ExistingTask.AddWindowsPackage) {
            foreach ($Item in $ExistingTask.AddWindowsPackage) {
                $AddWindowsPackage = $AddWindowsPackage | Where-Object {$_.FullName -ne $Item}
            }
        }
        $AddWindowsPackage = $AddWindowsPackage | Out-GridView -Title "Packages: Select Packages to apply and press OK (Esc or Cancel to Skip)" -PassThru
    }
    foreach ($Item in $AddWindowsPackage) {Write-Host "$($Item.FullName)" -ForegroundColor White}
    Return $AddWindowsPackage
}
function Get-TaskContentDrivers {
    #=================================================
    #   Content Drivers 
    #=================================================
    [CmdletBinding()]
    param ()
    $Drivers = Get-ChildItem -Path $GetOSDBuilderPathContentDrivers -Directory -ErrorAction SilentlyContinue | Select-Object -Property Name, FullName
    foreach ($Pack in $Drivers) {$Pack.FullName = $($Pack.FullName).replace("$SetOSDBuilderPathContent\",'')}

    if ($null -eq $Drivers) {Write-Warning "Drivers: To select Windows Drivers, add Content to $GetOSDBuilderPathContentDrivers"}
    else {
        if ($ExistingTask.Drivers) {
            foreach ($Item in $ExistingTask.Drivers) {
                $Drivers = $Drivers | Where-Object {$_.FullName -ne $Item}
            }
        }
        $Drivers = $Drivers | Out-GridView -Title "Drivers: Select Driver Paths to apply and press OK (Esc or Cancel to Skip)" -PassThru
    }
    foreach ($Item in $Drivers) {Write-Host "$($Item.FullName)" -ForegroundColor White}
    Return $Drivers
}
function Get-TaskContentExtraFiles {
    #=================================================
    #   Content ExtraFiles
    #=================================================
    [CmdletBinding()]
    param ()
    $ExtraFiles = Get-ChildItem -Path $GetOSDBuilderPathContentExtraFiles -Directory -ErrorAction SilentlyContinue | Select-Object -Property Name, FullName
    $ExtraFiles = $ExtraFiles | Where-Object {(Get-ChildItem $_.FullName | Measure-Object).Count -gt 0}
    foreach ($Pack in $ExtraFiles) {$Pack.FullName = $($Pack.FullName).replace("$SetOSDBuilderPathContent\",'')}

    if ($null -eq $ExtraFiles) {Write-Warning "Extra Files: To select Extra Files, add Content to $GetOSDBuilderPathContentExtraFiles"}
    else {
        if ($ExistingTask.ExtraFiles) {
            foreach ($Item in $ExistingTask.ExtraFiles) {
                $ExtraFiles = $ExtraFiles | Where-Object {$_.FullName -ne $Item}
            }
        }
        $ExtraFiles = $ExtraFiles | Out-GridView -Title "Extra Files: Select directories to inject and press OK (Esc or Cancel to Skip)" -PassThru
    }
    foreach ($Item in $ExtraFiles) {Write-Host "$($Item.FullName)" -ForegroundColor White}
    Return $ExtraFiles
}
function Get-TaskContentIsoExtract {
    [CmdletBinding()]
    param ()
    $ContentIsoExtract = Get-ChildItem -Path "$GetOSDBuilderPathContentIsoExtract\*" -Include *.cab, *.appx -Recurse | Select-Object -Property Name, FullName
    if ($($OSMedia.ReleaseId)) {
        if ($($OSMedia.ReleaseId) -eq 1909) {
            $ContentIsoExtract = $ContentIsoExtract | Where-Object {$_.FullName -match '1903' -or $_.FullName -match '1909'}
        }
        elseif ($($OSMedia.ReleaseId) -eq 2009) {
            $ContentIsoExtract = $ContentIsoExtract | Where-Object {$_.FullName -match '2004' -or $_.FullName -match '2009' -or $_.FullName -match '20H2' -or $_.FullName -match '21H1' -or $_.FullName -match '21H2'}
        }
        elseif ($($OSMedia.ReleaseId) -eq '20H2') {
            $ContentIsoExtract = $ContentIsoExtract | Where-Object {$_.FullName -match '2004' -or $_.FullName -match '2009' -or $_.FullName -match '20H2' -or $_.FullName -match '21H1' -or $_.FullName -match '21H2'}
        }
        elseif ($($OSMedia.ReleaseId) -eq '21H1') {
            $ContentIsoExtract = $ContentIsoExtract | Where-Object {$_.FullName -match '2004' -or $_.FullName -match '2009' -or $_.FullName -match '20H2' -or $_.FullName -match '21H1' -or $_.FullName -match '21H2'}
        }
        elseif ($($OSMedia.ReleaseId) -eq '21H2') {
            $ContentIsoExtract = $ContentIsoExtract | Where-Object {$_.FullName -match '2004' -or $_.FullName -match '2009' -or $_.FullName -match '20H2' -or $_.FullName -match '21H1' -or $_.FullName -match '21H2'}
        }
        else {
            $ContentIsoExtract = $ContentIsoExtract | Where-Object {$_.FullName -match $OSMedia.ReleaseId}
        }
    }
    foreach ($IsoExtractPackage in $ContentIsoExtract) {$IsoExtractPackage.FullName = $($IsoExtractPackage.FullName).replace("$SetOSDBuilderPathContent\",'')}

    $ContentIsoExtract = $ContentIsoExtract | Where-Object {$_.FullName -notlike "*\arm64\*"}

    if ($($OSMedia.Arch) -eq 'x64') {$ContentIsoExtract = $ContentIsoExtract | Where-Object {$_.Name -notlike "*x86*"}}
    if ($($OSMedia.Arch) -eq 'x64') {$ContentIsoExtract = $ContentIsoExtract | Where-Object {$_.FullName -notlike "*\x86\*"}}

    if ($($OSMedia.Arch) -eq 'x86') {$ContentIsoExtract = $ContentIsoExtract | Where-Object {$_.Name -notlike "*x64*"}}
    if ($($OSMedia.Arch) -eq 'x86') {$ContentIsoExtract = $ContentIsoExtract | Where-Object {$_.Name -notlike "*amd64*"}}
    if ($($OSMedia.Arch) -eq 'x86') {$ContentIsoExtract = $ContentIsoExtract | Where-Object {$_.FullName -notlike "*\x64\*"}}
    if ($($OSMedia.Arch) -eq 'x86') {$ContentIsoExtract = $ContentIsoExtract | Where-Object {$_.FullName -notlike "*\amd64\*"}}

    Return $ContentIsoExtract
}
function Get-TaskContentLanguageCopySources {
    #=================================================
    #   Content Scripts
    #=================================================
    [CmdletBinding()]
    param ()
    $LanguageCopySources = Get-OSMedia -Revision OK
    $LanguageCopySources = $LanguageCopySources | Where-Object {$_.Arch -eq $OSMedia.Arch}
    $LanguageCopySources = $LanguageCopySources | Where-Object {$_.Build -eq $OSMedia.Build}
    $LanguageCopySources = $LanguageCopySources | Where-Object {$_.OperatingSystem -eq $OSMedia.OperatingSystem}
    $LanguageCopySources = $LanguageCopySources | Where-Object {$_.OSMFamily -ne $OSMedia.OSMFamily}

    if ($ExistingTask.LanguageCopySources) {
        foreach ($Item in $ExistingTask.LanguageCopySources) {
            $LanguageCopySources = $LanguageCopySources | Where-Object {$_.OSMFamily -ne $Item}
        }
    }
    $LanguageCopySources = $LanguageCopySources | Out-GridView -Title "SourcesLanguageCopy: Select OSMedia to copy the Language Sources and press OK (Esc or Cancel to Skip)" -PassThru

    foreach ($Item in $LanguageCopySources) {Write-Host "$($Item.OSMFamily)" -ForegroundColor White}
    Return $LanguageCopySources
}
function Get-TaskContentLanguageFeature {
    [CmdletBinding()]
    param ()
    $LanguageFodIsoExtractDir = @()
    $LanguageFodIsoExtractDir = $ContentIsoExtract | Where-Object {$_.Name -like "*LanguageFeatures*"}
    if ($OSMedia.InstallationType -eq 'Client') {
        if ($($OSMedia.Arch) -eq 'x86') {$LanguageFodIsoExtractDir = $LanguageFodIsoExtractDir | Where-Object {$_.FullName -like "*x86*"}}
        if ($($OSMedia.Arch) -eq 'x64') {$LanguageFodIsoExtractDir = $LanguageFodIsoExtractDir | Where-Object {$_.FullName -like "*x64*" -or $_.FullName -like "*amd64*"}}
    }

    $LanguageFodUpdatesDir = @()
    if (Test-Path "$SetOSDBuilderPathContent\Updates\LanguageFeature") {
        $LanguageFodUpdatesDir = Get-ChildItem -Path "$SetOSDBuilderPathContent\Updates\LanguageFeature" *.cab -Recurse | Select-Object -Property Name, FullName
        foreach ($Package in $LanguageFodUpdatesDir) {$Package.FullName = $($Package.FullName).replace("$SetOSDBuilderPathContent\",'')}
        if ($($OSMedia.Arch) -eq 'x86') {$LanguageFodUpdatesDir = $LanguageFodUpdatesDir | Where-Object {$_.FullName -like "*x86*"}}
        if ($($OSMedia.Arch) -eq 'x64') {$LanguageFodUpdatesDir = $LanguageFodUpdatesDir | Where-Object {$_.FullName -like "*x64*" -or $_.FullName -like "*amd64*"}}
        if ($($OSMedia.ReleaseId)) {
            if ($($OSMedia.ReleaseId) -eq 1909) {
                $LanguageFodUpdatesDir = $LanguageFodUpdatesDir | Where-Object {$_.FullName -match '1903' -or $_.FullName -match '1909'}
            }
            elseif ($($OSMedia.ReleaseId) -eq 2009) {
                $LanguageFodUpdatesDir = $LanguageFodUpdatesDir | Where-Object {$_.FullName -match '2004' -or $_.FullName -match '2009' -or $_.FullName -match '20H2' -or $_.FullName -match '21H1' -or $_.FullName -match '21H2'}
            }
            elseif ($($OSMedia.ReleaseId) -eq '20H2') {
                $LanguageFodUpdatesDir = $LanguageFodUpdatesDir | Where-Object {$_.FullName -match '2004' -or $_.FullName -match '2009' -or $_.FullName -match '20H2' -or $_.FullName -match '21H1' -or $_.FullName -match '21H2'}
            }
            elseif ($($OSMedia.ReleaseId) -eq '21H1') {
                $LanguageFodUpdatesDir = $LanguageFodUpdatesDir | Where-Object {$_.FullName -match '2004' -or $_.FullName -match '2009' -or $_.FullName -match '20H2' -or $_.FullName -match '21H1' -or $_.FullName -match '21H2'}
            }
            elseif ($($OSMedia.ReleaseId) -eq '21H2') {
                $LanguageFodUpdatesDir = $LanguageFodUpdatesDir | Where-Object {$_.FullName -match '2004' -or $_.FullName -match '2009' -or $_.FullName -match '20H2' -or $_.FullName -match '21H1' -or $_.FullName -match '21H2'}
            }
            else {
                $LanguageFodUpdatesDir = $LanguageFodUpdatesDir | Where-Object {$_.FullName -match $OSMedia.ReleaseId}
            }
        }
    }

    [array]$LanguageFeature = [array]$LanguageFodIsoExtractDir + [array]$LanguageFodUpdatesDir
    if ($null -eq $LanguageFeature) {Write-Warning "Install.wim Language Features On Demand: Not Found"}
    else {
        if ($ExistingTask.LanguageFeature) {
            foreach ($Item in $ExistingTask.LanguageFeature) {
                $LanguageFeature = $LanguageFeature | Where-Object {$_.FullName -ne $Item}
            }
        }
        $LanguageFeature = $LanguageFeature | Sort-Object -Property FullName | Out-GridView -Title "Install.wim Language Features On Demand: Select Packages to apply and press OK (Esc or Cancel to Skip)" -PassThru
        if($null -eq $LanguageFeature) {Write-Warning "Install.wim Language Features On Demand: Skipping"}
    }
    foreach ($Item in $LanguageFeature) {Write-Host "$($Item.FullName)" -ForegroundColor White}
    Return $LanguageFeature
}
function Get-TaskContentLanguageInterfacePack {
    [CmdletBinding()]
    param ()
    $LanguageLipIsoExtractDir = @()
    $LanguageLipIsoExtractDir = $ContentIsoExtract | Where-Object {$_.Name -like "*Language-Interface-Pack*"}
    $LanguageLipIsoExtractDir = $LanguageLipIsoExtractDir | Where-Object {$_.Name -like "*$($OSMedia.Arch)*"}

    $LanguageLipUpdatesDir = @()
    if (Test-Path "$SetOSDBuilderPathContent\Updates\LanguageInterfacePack") {
        $LanguageLipUpdatesDir = Get-ChildItem -Path "$SetOSDBuilderPathContent\Updates\LanguageInterfacePack" *.cab -Recurse | Select-Object -Property Name, FullName
        foreach ($Package in $LanguageLipUpdatesDir) {$Package.FullName = $($Package.FullName).replace("$SetOSDBuilderPathContent\",'')}
        $LanguageLipUpdatesDir = $LanguageLipUpdatesDir | Where-Object {$_.FullName -like "*$($OSMedia.Arch)*"}
        if ($($OSMedia.ReleaseId)) {
            if ($($OSMedia.ReleaseId) -eq 1909) {
                $LanguageLipUpdatesDir = $LanguageLipUpdatesDir | Where-Object {$_.FullName -match '1903' -or $_.FullName -match '1909'}
            }
            elseif ($($OSMedia.ReleaseId) -eq 2009) {
                $LanguageLipUpdatesDir = $LanguageLipUpdatesDir | Where-Object {$_.FullName -match '2004' -or $_.FullName -match '2009' -or $_.FullName -match '20H2' -or $_.FullName -match '21H1' -or $_.FullName -match '21H2'}
            }
            elseif ($($OSMedia.ReleaseId) -eq '20H2') {
                $LanguageLipUpdatesDir = $LanguageLipUpdatesDir | Where-Object {$_.FullName -match '2004' -or $_.FullName -match '2009' -or $_.FullName -match '20H2' -or $_.FullName -match '21H1' -or $_.FullName -match '21H2'}
            }
            elseif ($($OSMedia.ReleaseId) -eq '21H1') {
                $LanguageLipUpdatesDir = $LanguageLipUpdatesDir | Where-Object {$_.FullName -match '2004' -or $_.FullName -match '2009' -or $_.FullName -match '20H2' -or $_.FullName -match '21H1' -or $_.FullName -match '21H2'}
            }
            elseif ($($OSMedia.ReleaseId) -eq '21H2') {
                $LanguageLipUpdatesDir = $LanguageLipUpdatesDir | Where-Object {$_.FullName -match '2004' -or $_.FullName -match '2009' -or $_.FullName -match '20H2' -or $_.FullName -match '21H1' -or $_.FullName -match '21H2'}
            }
            else {
                $LanguageLipUpdatesDir = $LanguageLipUpdatesDir | Where-Object {$_.FullName -match $OSMedia.ReleaseId}
            }
        }
    }
    
    [array]$LanguageInterfacePack = [array]$LanguageLipIsoExtractDir + [array]$LanguageLipUpdatesDir
    if ($null -eq $LanguageInterfacePack) {Write-Warning "Install.wim Language Interface Packs: Not Found"}
    else {
        if ($ExistingTask.LanguageInterfacePack) {
            foreach ($Item in $ExistingTask.LanguageInterfacePack) {
                $LanguageInterfacePack = $LanguageInterfacePack | Where-Object {$_.FullName -ne $Item}
            }
        }
        $LanguageInterfacePack = $LanguageInterfacePack | Sort-Object -Property FullName | Out-GridView -Title "Install.wim Language Interface Packs: Select Packages to apply and press OK (Esc or Cancel to Skip)" -PassThru
        if($null -eq $LanguageInterfacePack) {Write-Warning "Install.wim Language Interface Packs: Skipping"}
    }
    foreach ($Item in $LanguageInterfacePack) {Write-Host "$($Item.FullName)" -ForegroundColor White}
    Return $LanguageInterfacePack
}
function Get-TaskContentLanguagePack {
    [CmdletBinding()]
    param ()
    $LanguageLpIsoExtractDir = @()
    $LanguageLpIsoExtractDir = $ContentIsoExtract | Where-Object {$_.FullName -notlike "*FOD*"}
    $LanguageLpIsoExtractDir = $LanguageLpIsoExtractDir | Where-Object {$_.FullName -notlike "*LanguageFeatures*"}
    $LanguageLpIsoExtractDir = $LanguageLpIsoExtractDir | Where-Object {$_.FullName -like "*\langpacks\*"}
    $LanguageLpIsoExtractDir = $LanguageLpIsoExtractDir | Where-Object {$_.Name -notlike "*Language-Interface-Pack*"}

    $LanguageLpUpdatesDir = @()
    if (Test-Path "$SetOSDBuilderPathContent\Updates\LanguagePack") {
        $LanguageLpUpdatesDir = Get-ChildItem -Path "$SetOSDBuilderPathContent\Updates\LanguagePack" *.cab -Recurse | Select-Object -Property Name, FullName
        $LanguageLpUpdatesDir = $LanguageLpUpdatesDir | Where-Object {$_.FullName -like "*$($OSMedia.Arch)*"}
    }

    $LanguageLpLegacyDir = @()
    if (Test-Path "$SetOSDBuilderPathContent\LanguagePacks") {
        $LanguageLpLegacyDir = Get-ChildItem -Path "$SetOSDBuilderPathContent\LanguagePacks" *.cab -Recurse | Select-Object -Property Name, FullName
        $LanguageLpLegacyDir = $LanguageLpLegacyDir | Where-Object {$_.FullName -like "*$($OSMedia.Arch)*"}
    }

    [array]$LanguagePack = [array]$LanguageLpIsoExtractDir + [array]$LanguageLpUpdatesDir + [array]$LanguageLpLegacyDir

    if ($OSMedia.InstallationType -eq 'Client') {$LanguagePack = $LanguagePack | Where-Object {$_.FullName -notlike "*Windows Server*"}}
    if ($OSMedia.InstallationType -like "*Server*") {$LanguagePack = $LanguagePack | Where-Object {$_.FullName -like "*Windows Server*"}}
    if ($($OSMedia.ReleaseId)) {
        if ($($OSMedia.ReleaseId) -eq 1909) {
            $LanguagePack = $LanguagePack | Where-Object {$_.FullName -match '1903' -or $_.FullName -match '1909'}
        }
        elseif ($($OSMedia.ReleaseId) -eq 2009) {
            $LanguagePack = $LanguagePack | Where-Object {$_.FullName -match '2004' -or $_.FullName -match '2009' -or $_.FullName -match '20H2' -or $_.FullName -match '21H1' -or $_.FullName -match '21H2'}
        }
        elseif ($($OSMedia.ReleaseId) -eq '20H2') {
            $LanguagePack = $LanguagePack | Where-Object {$_.FullName -match '2004' -or $_.FullName -match '2009' -or $_.FullName -match '20H2' -or $_.FullName -match '21H1' -or $_.FullName -match '21H2'}
        }
        elseif ($($OSMedia.ReleaseId) -eq '21H1') {
            $LanguagePack = $LanguagePack | Where-Object {$_.FullName -match '2004' -or $_.FullName -match '2009' -or $_.FullName -match '20H2' -or $_.FullName -match '21H1' -or $_.FullName -match '21H2'}
        }
        elseif ($($OSMedia.ReleaseId) -eq '21H2') {
            $LanguagePack = $LanguagePack | Where-Object {$_.FullName -match '2004' -or $_.FullName -match '2009' -or $_.FullName -match '20H2' -or $_.FullName -match '21H1' -or $_.FullName -match '21H2'}
        }
        else {
            $LanguagePack = $LanguagePack | Where-Object {$_.FullName -match $OSMedia.ReleaseId}
        }
    }

    foreach ($Package in $LanguagePack) {$Package.FullName = $($Package.FullName).replace("$SetOSDBuilderPathContent\",'')}

    if ($null -eq $LanguagePack) {Write-Warning "Install.wim Language Packs: Not Found"}
    else {
        if ($ExistingTask.LanguagePack) {
            foreach ($Item in $ExistingTask.LanguagePack) {
                $LanguagePack = $LanguagePack | Where-Object {$_.FullName -ne $Item}
            }
        }
        $LanguagePack = $LanguagePack | Sort-Object -Property FullName | Out-GridView -Title "Install.wim Language Packs: Select Packages to apply and press OK (Esc or Cancel to Skip)" -PassThru
        if ($null -eq $LanguagePack) {Write-Warning "Install.wim Language Packs: Skipping"}
    }
    foreach ($Item in $LanguagePack) {Write-Host "$($Item.FullName)" -ForegroundColor White}
    Return $LanguagePack
}
function Get-TaskContentLocalExperiencePacks {
    [CmdletBinding()]
    param ()
    $LocalExperiencePacks = $ContentIsoExtract | Where-Object {$_.FullName -like "*\LocalExperiencePack\*" -and $_.Name -like "*.appx"}
    if ($OSMedia.InstallationType -eq 'Client') {$LocalExperiencePacks = $LocalExperiencePacks | Where-Object {$_.FullName -notlike "*Server*"}}
    if ($OSMedia.InstallationType -eq 'Server') {$LocalExperiencePacks = $LocalExperiencePacks | Where-Object {$_.FullName -like "*Server*"}}
    if ($OSMedia.InstallationType -eq 'Server') {$LocalExperiencePacks = $LocalExperiencePacks | Where-Object {$_.FullName -notlike "*Windows 10*"}}

    foreach ($Pack in $LocalExperiencePacks) {$Pack.FullName = $($Pack.FullName).replace("$SetOSDBuilderPathContent\",'')}
    if ($null -eq $LocalExperiencePacks) {Write-Warning "Install.wim Local Experience Packs: Not Found"}
    else {
        if ($ExistingTask.LocalExperiencePacks) {
            foreach ($Item in $ExistingTask.LocalExperiencePacks) {
                $LocalExperiencePacks = $LocalExperiencePacks | Where-Object {$_.FullName -ne $Item}
            }
        }
        $LocalExperiencePacks = $LocalExperiencePacks | Sort-Object -Property FullName | Out-GridView -Title "Install.wim Local Experience Packs: Select Capabilities to apply and press OK (Esc or Cancel to Skip)" -PassThru
        if ($null -eq $LocalExperiencePacks) {Write-Warning "Install.wim Local Experience Packs: Skipping"}
    }
    foreach ($Item in $LocalExperiencePacks) {Write-Host "$($Item.FullName)" -ForegroundColor White}
    Return $LocalExperiencePacks
}
function Get-TaskContentPacks {
    #=================================================
    #   Content Box 
    #=================================================
    [CmdletBinding()]
    param (
        [switch]$Select
    )
    $TaskContentPacks = Get-ChildItem -Path $SetOSDBuilderPathContentPacks -Directory -ErrorAction SilentlyContinue | Select-Object -Property Name
    if (!($Select.IsPresent)) {$TaskContentPacks = $TaskContentPacks | Where-Object {$_.Name -ne '_Global'}}

    if ($null -eq $TaskContentPacks) {Write-Warning "ContentPacks: No Packs exist in $SetOSDBuilderPathContentPacks"}
    else {
        if ($ExistingTask.ContentPacks) {
            foreach ($Item in $ExistingTask.ContentPacks) {
                $TaskContentPacks = $TaskContentPacks | Where-Object {$_.Name -ne $Item}
            }
        }
        if ($Select.IsPresent) {
            $TaskContentPacks = $TaskContentPacks | Out-GridView -Title "ContentPacks: Select only the ContentPacks to apply and press OK (Esc or Cancel to Skip)" -PassThru
        } else {
            $TaskContentPacks = $TaskContentPacks | Out-GridView -Title "ContentPacks: Select ContentPacks to add to this Task and press OK (Esc or Cancel to Skip)" -PassThru
        }
    }
    if (!($Select.IsPresent)) {foreach ($Item in $TaskContentPacks) {Write-Host "$($Item.Name)" -ForegroundColor White}}
    Return $TaskContentPacks
}
function Get-TaskContentScripts {
    #=================================================
    #   Content Scripts
    #=================================================
    [CmdletBinding()]
    param ()
    $Scripts = Get-ChildItem -Path $GetOSDBuilderPathContentScripts *.ps1 -ErrorAction SilentlyContinue | Select-Object -Property Name, FullName, Length, CreationTime | Sort-Object -Property FullName
    foreach ($Item in $Scripts) {$Item.FullName = $($Item.FullName).replace("$SetOSDBuilderPathContent\",'')}

    if ($null -eq $Scripts) {Write-Warning "Scripts: To select PowerShell Scripts add Content to $GetOSDBuilderPathContentScripts"}
    else {
        if ($ExistingTask.Scripts) {
            foreach ($Item in $ExistingTask.Scripts) {
                $Scripts = $Scripts | Where-Object {$_.FullName -ne $Item}
            }
        }
        $Scripts = $Scripts | Out-GridView -Title "Scripts: Select PowerShell Scripts to execute and press OK (Esc or Cancel to Skip)" -PassThru
    }
    foreach ($Item in $Scripts) {Write-Host "$($Item.FullName)" -ForegroundColor White}
    Return $Scripts
}
function Get-TaskContentStartLayoutXML {
    #=================================================
    #   Content StartLayout
    #=================================================
    [CmdletBinding()]
    param ()
    $StartLayoutXML = Get-ChildItem -Path $GetOSDBuilderPathContentStartLayout *.xml -ErrorAction SilentlyContinue | Select-Object -Property Name, FullName, Length, CreationTime | Sort-Object -Property FullName
    foreach ($Item in $StartLayoutXML) {$Item.FullName = $($Item.FullName).replace("$SetOSDBuilderPathContent\",'')}

    if ($null -eq $StartLayoutXML) {Write-Warning "StartLayoutXML: To select a Start Layout, add Content to $GetOSDBuilderPathContentStartLayout"}
    else {
        if ($ExistingTask.StartLayoutXML) {
            foreach ($Item in $ExistingTask.StartLayoutXML) {
                $StartLayoutXML = $StartLayoutXML | Where-Object {$_.FullName -ne $Item}
            }
        }
        $StartLayoutXML = $StartLayoutXML | Out-GridView -Title "StartLayoutXML: Select a Start Layout XML to apply and press OK (Esc or Cancel to Skip)" -OutputMode Single
    }
    foreach ($Item in $StartLayoutXML) {Write-Host "$($Item.FullName)" -ForegroundColor White}
    Return $StartLayoutXML
}
function Get-TaskContentUnattendXML {
    #=================================================
    #   Content Unattend
    #=================================================
    [CmdletBinding()]
    param ()
    $UnattendXML = Get-ChildItem -Path $GetOSDBuilderPathContentUnattend *.xml -ErrorAction SilentlyContinue | Select-Object -Property Name, FullName, Length, CreationTime | Sort-Object -Property FullName
    foreach ($Item in $UnattendXML) {$Item.FullName = $($Item.FullName).replace("$SetOSDBuilderPathContent\",'')}
    
    if ($null -eq $UnattendXML) {Write-Warning "UnattendXML: To select an Unattend XML, add Content to $GetOSDBuilderPathContentUnattend"}
    else {
        if ($ExistingTask.UnattendXML) {
            foreach ($Item in $ExistingTask.UnattendXML) {
                $UnattendXML = $UnattendXML | Where-Object {$_.FullName -ne $Item}
            }
        }
        $UnattendXML = $UnattendXML | Out-GridView -Title "UnattendXML: Select a Windows Unattend XML File to apply and press OK (Esc or Cancel to Skip)" -OutputMode Single
    }
    foreach ($Item in $UnattendXML) {Write-Host "$($Item.FullName)" -ForegroundColor White}
    Return $UnattendXML
}
function Get-TaskDisableWindowsOptionalFeature {
    #=================================================
    #   DisableWindowsOptionalFeature
    #=================================================
    [CmdletBinding()]
    param ()
    if (Test-Path "$($OSMedia.FullName)\info\xml\Get-WindowsOptionalFeature.xml") {
        $DisableWindowsOptionalFeature = Import-CliXml "$($OSMedia.FullName)\info\xml\Get-WindowsOptionalFeature.xml"
    }
    $DisableWindowsOptionalFeature = $DisableWindowsOptionalFeature | Select-Object -Property FeatureName, State | Sort-Object -Property FeatureName | Where-Object {$_.State -eq 2 -or $_.State -eq 3}
    $DisableWindowsOptionalFeature = $DisableWindowsOptionalFeature | Select-Object -Property FeatureName
    if ($ExistingTask.DisableWindowsOptionalFeature) {
        foreach ($Item in $ExistingTask.DisableWindowsOptionalFeature) {
            $DisableWindowsOptionalFeature = $DisableWindowsOptionalFeature | Where-Object {$_.FeatureName -ne $Item}
        }
    }
    $DisableWindowsOptionalFeature = $DisableWindowsOptionalFeature | Out-GridView -PassThru -Title "Disable-WindowsOptionalFeature: Select Windows Optional Features to Disable and press OK (Esc or Cancel to Skip)"
    foreach ($Item in $DisableWindowsOptionalFeature) {Write-Host "$($Item.FeatureName)" -ForegroundColor White}
    Return $DisableWindowsOptionalFeature
}
function Get-TaskEnableWindowsOptionalFeature {
    #=================================================
    #   EnableWindowsOptionalFeature
    #=================================================
    [CmdletBinding()]
    param ()
    if (Test-Path "$($OSMedia.FullName)\info\xml\Get-WindowsOptionalFeature.xml") {
        $EnableWindowsOptionalFeature = Import-CliXml "$($OSMedia.FullName)\info\xml\Get-WindowsOptionalFeature.xml"
    }
    $EnableWindowsOptionalFeature = $EnableWindowsOptionalFeature | Select-Object -Property FeatureName, State | Sort-Object -Property FeatureName | Where-Object {$_.State -eq 0}
    $EnableWindowsOptionalFeature = $EnableWindowsOptionalFeature | Select-Object -Property FeatureName
    if ($ExistingTask.EnableWindowsOptionalFeature) {
        foreach ($Item in $ExistingTask.EnableWindowsOptionalFeature) {
            $EnableWindowsOptionalFeature = $EnableWindowsOptionalFeature | Where-Object {$_.FeatureName -ne $Item}
        }
    }

    $EnableWindowsOptionalFeature = $EnableWindowsOptionalFeature | Out-GridView -PassThru -Title "Enable-WindowsOptionalFeature: Select Windows Optional Features to ENABLE and press OK (Esc or Cancel to Skip)"
    foreach ($Item in $EnableWindowsOptionalFeature) {Write-Host "$($Item.FeatureName)" -ForegroundColor White}
    Return $EnableWindowsOptionalFeature
}
function Get-TaskRemoveAppxProvisionedPackage {
    #=================================================
    #   RemoveAppx
    #=================================================
    [CmdletBinding()]
    param ()
    if ($($OSMedia.InstallationType) -eq 'Client') {
        if (Test-Path "$($OSMedia.FullName)\info\xml\Get-AppxProvisionedPackage.xml") {
            $RemoveAppxProvisionedPackage = Import-CliXml "$($OSMedia.FullName)\info\xml\Get-AppxProvisionedPackage.xml"
            $RemoveAppxProvisionedPackage = $RemoveAppxProvisionedPackage | Select-Object -Property DisplayName, PackageName
            if ($ExistingTask.RemoveAppxProvisionedPackage) {
                foreach ($Item in $ExistingTask.RemoveAppxProvisionedPackage) {
                    $RemoveAppxProvisionedPackage = $RemoveAppxProvisionedPackage | Where-Object {$_.PackageName -ne $Item}
                }
            }
            $RemoveAppxProvisionedPackage = $RemoveAppxProvisionedPackage | Out-GridView -Title "Remove-AppxProvisionedPackage: Select Packages to REMOVE and press OK (Esc or Cancel to Skip)" -PassThru
        }
        foreach ($Item in $RemoveAppxProvisionedPackage) {Write-Host "$($Item.PackageName)" -ForegroundColor White}
        Return $RemoveAppxProvisionedPackage
    } else {Write-Warning "Remove-AppxProvisionedPackage: Unsupported"}
}
function Get-TaskRemoveWindowsCapability {
    #=================================================
    #   RemoveCapability
    #=================================================
    [CmdletBinding()]
    param ()
    if (Test-Path "$($OSMedia.FullName)\info\xml\Get-WindowsCapability.xml") {
        $RemoveWindowsCapability = Import-CliXml "$($OSMedia.FullName)\info\xml\Get-WindowsCapability.xml"
        $RemoveWindowsCapability = $RemoveWindowsCapability | Where-Object {$_.State -eq 4}
        $RemoveWindowsCapability = $RemoveWindowsCapability | Select-Object -Property Name, State
        if ($ExistingTask.RemoveWindowsCapability) {
            foreach ($Item in $ExistingTask.RemoveWindowsCapability) {
                $RemoveWindowsCapability = $RemoveWindowsCapability | Where-Object {$_.Name -ne $Item}
            }
        }
        $RemoveWindowsCapability = $RemoveWindowsCapability | Out-GridView -Title "Remove-WindowsCapability: Select Windows InBox Capability to REMOVE and press OK (Esc or Cancel to Skip)" -PassThru
    }
    foreach ($Item in $RemoveWindowsCapability) {Write-Host "$($Item.Name)" -ForegroundColor White}
    Return $RemoveWindowsCapability
}
function Get-TaskRemoveWindowsPackage {
    #=================================================
    #   RemovePackage
    #=================================================
    [CmdletBinding()]
    param ()
    if (Test-Path "$($OSMedia.FullName)\info\xml\Get-WindowsPackage.xml") {
        $RemoveWindowsPackage = Import-CliXml "$($OSMedia.FullName)\info\xml\Get-WindowsPackage.xml"
        $RemoveWindowsPackage = $RemoveWindowsPackage | Select-Object -Property PackageName
        if ($ExistingTask.RemoveWindowsPackage) {
            foreach ($Item in $ExistingTask.RemoveWindowsPackage) {
                $RemoveWindowsPackage = $RemoveWindowsPackage | Where-Object {$_.PackageName -ne $Item}
            }
        }
        $RemoveWindowsPackage = $RemoveWindowsPackage | Out-GridView -Title "Remove-WindowsPackage: Select Packages to REMOVE and press OK (Esc or Cancel to Skip)" -PassThru
    }
    foreach ($Item in $RemoveWindowsPackage) {Write-Host "$($Item.PackageName)" -ForegroundColor White}
    Return $RemoveWindowsPackage
}
function Get-TaskWinPEADK {
    #=================================================
    #   WinPE ADK
    #=================================================
    [CmdletBinding()]
    param ()
    $WinPEADK = Get-ChildItem -Path ("$SetOSDBuilderPathContent\WinPE\ADK\*","$GetOSDBuilderPathContentADK\*\Windows Preinstallation Environment\*\WinPE_OCs") *.cab -Recurse -ErrorAction SilentlyContinue | Select-Object -Property Name, FullName
    foreach ($Pack in $WinPEADK) {$Pack.FullName = $($Pack.FullName).replace("$SetOSDBuilderPathContent\",'')}
    
    if ($($OSMedia.ReleaseId) -eq 1909) {
        $WinPEADK = $WinPEADK | Where-Object {$_.FullName -match '1903' -or $_.FullName -match '1909'}
    }
    elseif ($($OSMedia.ReleaseId) -eq 2009) {
        $WinPEADK = $WinPEADK | Where-Object {$_.FullName -match '2004' -or $_.FullName -match '2009' -or $_.FullName -match '20H2' -or $_.FullName -match '21H1' -or $_.FullName -match '21H2'}
    }
    elseif ($($OSMedia.ReleaseId) -eq '20H2') {
        $WinPEADK = $WinPEADK | Where-Object {$_.FullName -match '2004' -or $_.FullName -match '2009' -or $_.FullName -match '20H2' -or $_.FullName -match '21H1' -or $_.FullName -match '21H2'}
    }
    elseif ($($OSMedia.ReleaseId) -eq '21H1') {
        $WinPEADK = $WinPEADK | Where-Object {$_.FullName -match '2004' -or $_.FullName -match '2009' -or $_.FullName -match '20H2' -or $_.FullName -match '21H1' -or $_.FullName -match '21H2'}
    }
    elseif ($($OSMedia.ReleaseId) -eq '21H2') {
        $WinPEADK = $WinPEADK | Where-Object {$_.FullName -match '2004' -or $_.FullName -match '2009' -or $_.FullName -match '20H2' -or $_.FullName -match '21H1' -or $_.FullName -match '21H2'}
    }
    else {
        $WinPEADK = $WinPEADK | Where-Object {$_.FullName -match $OSMedia.ReleaseId}
    }

    if ($OSMedia.Arch -eq 'x86') {$WinPEADK = $WinPEADK | Where-Object {$_.FullName -like "*x86*"}
    } else {$WinPEADK = $WinPEADK | Where-Object {($_.FullName -like "*x64*") -or ($_.FullName -like "*amd64*")}}

    $WinPEADKIE = @()
    $WinPEADKIE = $ContentIsoExtractWinPE | Select-Object -Property Name, FullName
    [array]$WinPEADK = [array]$WinPEADK + [array]$WinPEADKIE

    if ($null -eq $WinPEADK) {Write-Warning "WinPE.wim ADK Packages: Add Content to $GetOSDBuilderPathContentADK"}
    else {
        if ($ExistingTask.WinPEADK) {
            foreach ($Item in $ExistingTask.WinPEADK) {
                $WinPEADK = $WinPEADK | Where-Object {$_.FullName -ne $Item}
            }
        }
        $WinPEADK = $WinPEADK | Out-GridView -Title "WinPE.wim ADK Packages: Select ADK Packages to apply and press OK (Esc or Cancel to Skip)" -PassThru
    }
    foreach ($Item in $WinPEADK) {Write-Host "$($Item.FullName)" -ForegroundColor White}
    Return $WinPEADK
}
function Get-TaskWinPEADKPE {
    #=================================================
    #   WinPE ADK
    #=================================================
    [CmdletBinding()]
    param ()
    $WinPEADKPE = Get-ChildItem -Path ("$SetOSDBuilderPathContent\WinPE\ADK\*","$GetOSDBuilderPathContentADK\*\Windows Preinstallation Environment\*\WinPE_OCs") *.cab -Recurse -ErrorAction SilentlyContinue | Select-Object -Property Name, FullName
    foreach ($Pack in $WinPEADKPE) {$Pack.FullName = $($Pack.FullName).replace("$SetOSDBuilderPathContent\",'')}
    
    if ($($OSMedia.ReleaseId) -eq 1909) {
        $WinPEADKPE = $WinPEADKPE | Where-Object {$_.FullName -match '1903' -or $_.FullName -match '1909'}
    }
    elseif ($($OSMedia.ReleaseId) -eq 2009) {
        $WinPEADKPE = $WinPEADKPE | Where-Object {$_.FullName -match '2004' -or $_.FullName -match '2009' -or $_.FullName -match '20H2' -or $_.FullName -match '21H1' -or $_.FullName -match '21H2'}
    }
    elseif ($($OSMedia.ReleaseId) -eq '20H2') {
        $WinPEADKPE = $WinPEADKPE | Where-Object {$_.FullName -match '2004' -or $_.FullName -match '2009' -or $_.FullName -match '20H2' -or $_.FullName -match '21H1' -or $_.FullName -match '21H2'}
    }
    elseif ($($OSMedia.ReleaseId) -eq '21H1') {
        $WinPEADKPE = $WinPEADKPE | Where-Object {$_.FullName -match '2004' -or $_.FullName -match '2009' -or $_.FullName -match '20H2' -or $_.FullName -match '21H1' -or $_.FullName -match '21H2'}
    }
    elseif ($($OSMedia.ReleaseId) -eq '21H2') {
        $WinPEADKPE = $WinPEADKPE | Where-Object {$_.FullName -match '2004' -or $_.FullName -match '2009' -or $_.FullName -match '20H2' -or $_.FullName -match '21H1' -or $_.FullName -match '21H2'}
    }
    else {
        $WinPEADKPE = $WinPEADKPE | Where-Object {$_.FullName -match $OSMedia.ReleaseId}
    }

    if ($OSMedia.Arch -eq 'x86') {$WinPEADKPE = $WinPEADKPE | Where-Object {$_.FullName -like "*x86*"}
    } else {$WinPEADKPE = $WinPEADKPE | Where-Object {($_.FullName -like "*x64*") -or ($_.FullName -like "*amd64*")}}

    $WinPEADKPEIE = @()
    $WinPEADKPEIE = $ContentIsoExtractWinPE | Select-Object -Property Name, FullName
    [array]$WinPEADKPE = [array]$WinPEADKPE + [array]$WinPEADKPEIE

    if ($null -eq $WinPEADKPE) {Write-Warning "WinPE.wim ADK Packages: Add Content to $GetOSDBuilderPathContentADK"}
    else {
        if ($ExistingTask.WinPEADKPE) {
            foreach ($Item in $ExistingTask.WinPEADKPE) {
                $WinPEADKPE = $WinPEADKPE | Where-Object {$_.FullName -ne $Item}
            }
        }
        $WinPEADKPE = $WinPEADKPE | Out-GridView -Title "WinPE.wim ADK Packages: Select ADK Packages to apply and press OK (Esc or Cancel to Skip)" -PassThru
    }
    foreach ($Item in $WinPEADKPE) {Write-Host "$($Item.FullName)" -ForegroundColor White}
    Return $WinPEADKPE
}
function Get-TaskWinPEADKRE {
    #=================================================
    #   WinRE ADK
    #=================================================
    [CmdletBinding()]
    param ()
    $WinPEADKRE = Get-ChildItem -Path ("$SetOSDBuilderPathContent\WinPE\ADK\*","$GetOSDBuilderPathContentADK\*\Windows Preinstallation Environment\*\WinPE_OCs") *.cab -Recurse -ErrorAction SilentlyContinue | Select-Object -Property Name, FullName
    
    foreach ($Pack in $WinPEADKRE) {$Pack.FullName = $($Pack.FullName).replace("$SetOSDBuilderPathContent\",'')}

    if ($($OSMedia.ReleaseId) -eq 1909) {
        $WinPEADKRE = $WinPEADKRE | Where-Object {$_.FullName -match '1903' -or $_.FullName -match '1909'}
    }
    elseif ($($OSMedia.ReleaseId) -eq 2009) {
        $WinPEADKRE = $WinPEADKRE | Where-Object {$_.FullName -match '2004' -or $_.FullName -match '2009' -or $_.FullName -match '20H2' -or $_.FullName -match '21H1' -or $_.FullName -match '21H2'}
    }
    elseif ($($OSMedia.ReleaseId) -eq '20H2') {
        $WinPEADKRE = $WinPEADKRE | Where-Object {$_.FullName -match '2004' -or $_.FullName -match '2009' -or $_.FullName -match '20H2' -or $_.FullName -match '21H1' -or $_.FullName -match '21H2'}
    }
    elseif ($($OSMedia.ReleaseId) -eq '21H1') {
        $WinPEADKRE = $WinPEADKRE | Where-Object {$_.FullName -match '2004' -or $_.FullName -match '2009' -or $_.FullName -match '20H2' -or $_.FullName -match '21H1' -or $_.FullName -match '21H2'}
    }
    elseif ($($OSMedia.ReleaseId) -eq '21H2') {
        $WinPEADKRE = $WinPEADKRE | Where-Object {$_.FullName -match '2004' -or $_.FullName -match '2009' -or $_.FullName -match '20H2' -or $_.FullName -match '21H1' -or $_.FullName -match '21H2'}
    }
    else {
        $WinPEADKRE = $WinPEADKRE | Where-Object {$_.FullName -match $OSMedia.ReleaseId}
    }

    if ($OSMedia.Arch -eq 'x86') {$WinPEADKRE = $WinPEADKRE | Where-Object {$_.FullName -like "*x86*"}
    } else {$WinPEADKRE = $WinPEADKRE | Where-Object {($_.FullName -like "*x64*") -or ($_.FullName -like "*amd64*")}}

    $WinPEADKREIE = @()
    $WinPEADKREIE = $ContentIsoExtractWinPE | Select-Object -Property Name, FullName
    [array]$WinPEADKRE = [array]$WinPEADKRE + [array]$WinPEADKREIE

    if ($null -eq $WinPEADKRE) {Write-Warning "WinRE.wim ADK Packages: Add Content to $GetOSDBuilderPathContentADK"}
    else {
        if ($ExistingTask.WinPEADKRE) {
            foreach ($Item in $ExistingTask.WinPEADKRE) {
                $WinPEADKRE = $WinPEADKRE | Where-Object {$_.FullName -ne $Item}
            }
        }
        Write-Warning "If you add too many ADK Packages to WinRE, like .Net and PowerShell"
        Write-Warning "You run a risk of your WinRE size increasing considerably"
        Write-Warning "If your MBR System or UEFI Recovery Partition are 500MB,"
        Write-Warning "your WinRE.wim should not be more than 400MB (100MB Free)"
        Write-Warning "Consider changing your Task Sequences to have a 984MB"
        Write-Warning "MBR System or UEFI Recovery Partition"
        $WinPEADKRE = $WinPEADKRE | Out-GridView -Title "WinRE.wim ADK Packages: Select ADK Packages to apply and press OK (Esc or Cancel to Skip)" -PassThru
    }
    foreach ($Item in $WinPEADKRE) {Write-Host "$($Item.FullName)" -ForegroundColor White}
    Return $WinPEADKRE
}
function Get-TaskWinPEADKSE {
    #=================================================
    #   WinRE ADK
    #=================================================
    [CmdletBinding()]
    param ()
    $WinPEADKSE = Get-ChildItem -Path ("$SetOSDBuilderPathContent\WinPE\ADK\*","$GetOSDBuilderPathContentADK\*\Windows Preinstallation Environment\*\WinPE_OCs") *.cab -Recurse -ErrorAction SilentlyContinue | Select-Object -Property Name, FullName
    foreach ($Pack in $WinPEADKSE) {$Pack.FullName = $($Pack.FullName).replace("$SetOSDBuilderPathContent\",'')}

    if ($($OSMedia.ReleaseId) -eq 1909) {
        $WinPEADKSE = $WinPEADKSE | Where-Object {$_.FullName -match '1903' -or $_.FullName -match '1909'}
    }
    elseif ($($OSMedia.ReleaseId) -eq 2009) {
        $WinPEADKSE = $WinPEADKSE | Where-Object {$_.FullName -match '2004' -or $_.FullName -match '2009' -or $_.FullName -match '20H2' -or $_.FullName -match '21H1' -or $_.FullName -match '21H2'}
    }
    elseif ($($OSMedia.ReleaseId) -eq '20H2') {
        $WinPEADKSE = $WinPEADKSE | Where-Object {$_.FullName -match '2004' -or $_.FullName -match '2009' -or $_.FullName -match '20H2' -or $_.FullName -match '21H1' -or $_.FullName -match '21H2'}
    }
    elseif ($($OSMedia.ReleaseId) -eq '21H1') {
        $WinPEADKSE = $WinPEADKSE | Where-Object {$_.FullName -match '2004' -or $_.FullName -match '2009' -or $_.FullName -match '20H2' -or $_.FullName -match '21H1' -or $_.FullName -match '21H2'}
    }
    elseif ($($OSMedia.ReleaseId) -eq '21H2') {
        $WinPEADKSE = $WinPEADKSE | Where-Object {$_.FullName -match '2004' -or $_.FullName -match '2009' -or $_.FullName -match '20H2' -or $_.FullName -match '21H1' -or $_.FullName -match '21H2'}
    }
    else {
        $WinPEADKSE = $WinPEADKSE | Where-Object {$_.FullName -match $OSMedia.ReleaseId}
    }

    if ($OSMedia.Arch -eq 'x86') {$WinPEADKSE = $WinPEADKSE | Where-Object {$_.FullName -like "*x86*"}
    } else {$WinPEADKSE = $WinPEADKSE | Where-Object {($_.FullName -like "*x64*") -or ($_.FullName -like "*amd64*")}}

    $WinPEADKSEIE = @()
    $WinPEADKSEIE = $ContentIsoExtractWinPE | Select-Object -Property Name, FullName
    [array]$WinPEADKSE = [array]$WinPEADKSE + [array]$WinPEADKSEIE

    if ($null -eq $WinPEADKSE) {Write-Warning "WinSE.wim ADK Packages: Add Content to $GetOSDBuilderPathContentADK"}
    else {
        if ($ExistingTask.WinPEADKSE) {
            foreach ($Item in $ExistingTask.WinPEADKSE) {
                $WinPEADKSE = $WinPEADKSE | Where-Object {$_.FullName -ne $Item}
            }
        }
        $WinPEADKSE = $WinPEADKSE | Out-GridView -Title "WinSE.wim ADK Packages: Select ADK Packages to apply and press OK (Esc or Cancel to Skip)" -PassThru
    }
    foreach ($Item in $WinPEADKSE) {Write-Host "$($Item.FullName)" -ForegroundColor White}
    Return $WinPEADKSE
}
function Get-TaskWinPEDaRT {
    #=================================================
    #   WinPE DaRT
    #=================================================
    [CmdletBinding()]
    param ()
    $WinPEDaRT = Get-ChildItem -Path ($GetOSDBuilderPathContentDaRT,"$SetOSDBuilderPathContent\WinPE\DaRT") *.cab -Recurse -ErrorAction SilentlyContinue | Select-Object -Property Name, FullName
    $WinPEDaRT = $WinPEDaRT | Where-Object {$_.FullName -like "*$($OSMedia.Arch)*"}
    foreach ($Pack in $WinPEDaRT) {$Pack.FullName = $($Pack.FullName).replace("$SetOSDBuilderPathContent\",'')}
    if ($null -eq $WinPEDaRT) {Write-Warning "WinPEDaRT: Add Content to $GetOSDBuilderPathContentDaRT"}
    else {
        if ($ExistingTask.WinPEDaRT) {
            foreach ($Item in $ExistingTask.WinPEDaRT) {
                $WinPEDaRT = $WinPEDaRT | Where-Object {$_.FullName -ne $Item}
            }
        }
        $WinPEDaRT = $WinPEDaRT | Out-GridView -Title "WinPEDaRT: Select a WinPE DaRT Package to apply and press OK (Esc or Cancel to Skip)" -OutputMode Single
    }
    foreach ($Item in $WinPEDaRT) {Write-Host "$($Item.FullName)" -ForegroundColor White}
    Return $WinPEDaRT
}
function Get-TaskWinPEDrivers {
    #=================================================
    #   WinPE Add-WindowsDriver
    #=================================================
    [CmdletBinding()]
    param ()
    $WinPEDrivers = Get-ChildItem -Path ($GetOSDBuilderPathContentDrivers,"$SetOSDBuilderPathContent\WinPE\Drivers") -Directory -ErrorAction SilentlyContinue | Select-Object -Property Name, FullName
    foreach ($Pack in $WinPEDrivers) {$Pack.FullName = $($Pack.FullName).replace("$SetOSDBuilderPathContent\",'')}
    if ($null -eq $WinPEDrivers) {Write-Warning "WinPEDrivers: To select WinPE Drivers, add Content to $GetOSDBuilderPathContentDrivers"}
    else {
        if ($ExistingTask.WinPEDrivers) {
            foreach ($Item in $ExistingTask.WinPEDrivers) {
                $WinPEDrivers = $WinPEDrivers | Where-Object {$_.FullName -ne $Item}
            }
        }
        $WinPEDrivers = $WinPEDrivers | Out-GridView -Title "WinPEDrivers: Select Driver Paths to apply and press OK (Esc or Cancel to Skip)" -PassThru
    }
    foreach ($Item in $WinPEDrivers) {Write-Host "$($Item.FullName)" -ForegroundColor White}
    Return $WinPEDrivers
}
function Get-TaskWinPEExtraFiles {
    #=================================================
    #   WinPEExtraFiles
    #=================================================
    [CmdletBinding()]
    param ()
    $WinPEExtraFiles = Get-ChildItem -Path ($GetOSDBuilderPathContentExtraFiles,"$SetOSDBuilderPathContent\WinPE\ExtraFiles") -Directory -ErrorAction SilentlyContinue | Select-Object -Property Name, FullName
    $WinPEExtraFiles = $WinPEExtraFiles | Where-Object {(Get-ChildItem $_.FullName | Measure-Object).Count -gt 0}
    foreach ($Pack in $WinPEExtraFiles) {$Pack.FullName = $($Pack.FullName).replace("$SetOSDBuilderPathContent\",'')}
    if ($null -eq $WinPEExtraFiles) {Write-Warning "WinPEExtraFiles: To select WinPE Extra Files, add Content to $GetOSDBuilderPathContentExtraFiles"}
    else {
        if ($ExistingTask.WinPEExtraFiles) {
            foreach ($Item in $ExistingTask.WinPEExtraFiles) {
                $WinPEExtraFiles = $WinPEExtraFiles | Where-Object {$_.FullName -ne $Item}
            }
        }
        $WinPEExtraFiles = $WinPEExtraFiles | Out-GridView -Title "WinPEExtraFiles: Select directories to inject and press OK (Esc or Cancel to Skip)" -PassThru
    }
    foreach ($Item in $WinPEExtraFiles) {Write-Host "$($Item.FullName)" -ForegroundColor White}
    Return $WinPEExtraFiles
}
function Get-TaskWinPEExtraFilesPE {
    #=================================================
    #   WinPEExtraFilesPE
    #=================================================
    [CmdletBinding()]
    param ()
    $WinPEExtraFilesPE = Get-ChildItem -Path ($GetOSDBuilderPathContentExtraFiles,"$SetOSDBuilderPathContent\WinPE\ExtraFiles") -Directory -ErrorAction SilentlyContinue | Select-Object -Property Name, FullName
    $WinPEExtraFilesPE = $WinPEExtraFilesPE | Where-Object {(Get-ChildItem $_.FullName | Measure-Object).Count -gt 0}
    foreach ($Pack in $WinPEExtraFilesPE) {$Pack.FullName = $($Pack.FullName).replace("$SetOSDBuilderPathContent\",'')}
    if ($null -eq $WinPEExtraFilesPE) {Write-Warning "WinPEExtraFilesPE: To select WinPE Extra Files, add Content to $GetOSDBuilderPathContentExtraFiles"}
    else {
        if ($ExistingTask.WinPEExtraFilesPE) {
            foreach ($Item in $ExistingTask.WinPEExtraFilesPE) {
                $WinPEExtraFilesPE = $WinPEExtraFilesPE | Where-Object {$_.FullName -ne $Item}
            }
        }
        $WinPEExtraFilesPE = $WinPEExtraFilesPE | Out-GridView -Title "WinPEExtraFilesPE: Select directories to inject and press OK (Esc or Cancel to Skip)" -PassThru
    }
    foreach ($Item in $WinPEExtraFilesPE) {Write-Host "$($Item.FullName)" -ForegroundColor White}
    Return $WinPEExtraFilesPE
}
function Get-TaskWinPEExtraFilesRE {
    #=================================================
    #   WinPEExtraFilesRE
    #=================================================
    [CmdletBinding()]
    param ()
    $WinPEExtraFilesRE = Get-ChildItem -Path ($GetOSDBuilderPathContentExtraFiles,"$SetOSDBuilderPathContent\WinPE\ExtraFiles") -Directory -ErrorAction SilentlyContinue | Select-Object -Property Name, FullName
    $WinPEExtraFilesRE = $WinPEExtraFilesRE | Where-Object {(Get-ChildItem $_.FullName | Measure-Object).Count -gt 0}
    foreach ($Pack in $WinPEExtraFilesRE) {$Pack.FullName = $($Pack.FullName).replace("$SetOSDBuilderPathContent\",'')}
    if ($null -eq $WinPEExtraFilesRE) {Write-Warning "WinPEExtraFilesRE: To select WinRE Extra Files, add Content to $GetOSDBuilderPathContentExtraFiles"}
    else {
        if ($ExistingTask.WinPEExtraFilesRE) {
            foreach ($Item in $ExistingTask.WinPEExtraFilesRE) {
                $WinPEExtraFilesRE = $WinPEExtraFilesRE | Where-Object {$_.FullName -ne $Item}
            }
        }
        $WinPEExtraFilesRE = $WinPEExtraFilesRE | Out-GridView -Title "WinPEExtraFilesRE: Select directories to inject and press OK (Esc or Cancel to Skip)" -PassThru
    }
    foreach ($Item in $WinPEExtraFilesRE) {Write-Host "$($Item.FullName)" -ForegroundColor White}
    Return $WinPEExtraFilesRE
}
function Get-TaskWinPEExtraFilesSE {
    #=================================================
    #   WinSE Add-ExtraFiles
    #=================================================
    [CmdletBinding()]
    param ()
    $WinPEExtraFilesSE = Get-ChildItem -Path ($GetOSDBuilderPathContentExtraFiles,"$SetOSDBuilderPathContent\WinPE\ExtraFiles") -Directory -ErrorAction SilentlyContinue | Select-Object -Property Name, FullName
    $WinPEExtraFilesSE = $WinPEExtraFilesSE | Where-Object {(Get-ChildItem $_.FullName | Measure-Object).Count -gt 0}
    foreach ($Pack in $WinPEExtraFilesSE) {$Pack.FullName = $($Pack.FullName).replace("$SetOSDBuilderPathContent\",'')}
    if ($null -eq $WinPEExtraFilesSE) {Write-Warning "WinPEExtraFilesSE: To select WinSE Extra Files, add Content to $GetOSDBuilderPathContentExtraFiles"}
    else {
        if ($ExistingTask.WinPEExtraFilesSE) {
            foreach ($Item in $ExistingTask.WinPEExtraFilesSE) {
                $WinPEExtraFilesSE = $WinPEExtraFilesSE | Where-Object {$_.FullName -ne $Item}
            }
        }
        $WinPEExtraFilesSE = $WinPEExtraFilesSE | Out-GridView -Title "WinPEExtraFilesSE: Select directories to inject and press OK (Esc or Cancel to Skip)" -PassThru
    }
    foreach ($Item in $WinPEExtraFilesSE) {Write-Host "$($Item.FullName)" -ForegroundColor White}
    Return $WinPEExtraFilesSE
}
function Get-TaskWinPEScripts {
    #=================================================
    #   WinPE PowerShell Scripts
    #=================================================
    [CmdletBinding()]
    param ()
    $WinPEScripts = Get-ChildItem -Path ($GetOSDBuilderPathContentScripts,"$SetOSDBuilderPathContent\WinPE\Scripts") *.ps1 -ErrorAction SilentlyContinue | Select-Object -Property Name, FullName, Length, CreationTime | Sort-Object -Property FullName
    foreach ($TaskScript in $WinPEScripts) {$TaskScript.FullName = $($TaskScript.FullName).replace("$SetOSDBuilderPathContent\",'')}
    if ($null -eq $WinPEScripts) {Write-Warning "WinPE PowerShell Scripts: To select PowerShell Scripts add Content to $GetOSDBuilderPathContentScripts"}
    else {
        if ($ExistingTask.WinPEScripts) {
            foreach ($Item in $ExistingTask.WinPEScripts) {
                $WinPEScripts = $WinPEScripts | Where-Object {$_.FullName -ne $Item}
            }
        }
        $WinPEScripts = $WinPEScripts | Out-GridView -Title "WinPE PowerShell Scripts: Select PowerShell Scripts to execute and press OK (Esc or Cancel to Skip)" -PassThru
    }
    foreach ($Item in $WinPEScripts) {Write-Host "$($Item.FullName)" -ForegroundColor White}
    Return $WinPEScripts
}
function Get-TaskWinPEScriptsPE {
    #=================================================
    #   WinPE PowerShell Scripts
    #=================================================
    [CmdletBinding()]
    param ()
    $WinPEScriptsPE = Get-ChildItem -Path ($GetOSDBuilderPathContentScripts,"$SetOSDBuilderPathContent\WinPE\Scripts") *.ps1 -ErrorAction SilentlyContinue | Select-Object -Property Name, FullName, Length, CreationTime | Sort-Object -Property FullName
    foreach ($TaskScript in $WinPEScriptsPE) {$TaskScript.FullName = $($TaskScript.FullName).replace("$SetOSDBuilderPathContent\",'')}
    if ($null -eq $WinPEScriptsPE) {Write-Warning "WinPE PowerShell Scripts: To select PowerShell Scripts add Content to $GetOSDBuilderPathContentScripts"}
    else {
        if ($ExistingTask.WinPEScriptsPE) {
            foreach ($Item in $ExistingTask.WinPEScriptsPE) {
                $WinPEScriptsPE = $WinPEScriptsPE | Where-Object {$_.FullName -ne $Item}
            }
        }
        $WinPEScriptsPE = $WinPEScriptsPE | Out-GridView -Title "WinPE PowerShell Scripts: Select PowerShell Scripts to execute and press OK (Esc or Cancel to Skip)" -PassThru
    }
    foreach ($Item in $WinPEScriptsPE) {Write-Host "$($Item.FullName)" -ForegroundColor White}
    Return $WinPEScriptsPE
}
function Get-TaskWinPEScriptsRE {
    #=================================================
    #   WinRE PowerShell Scripts
    #=================================================
    [CmdletBinding()]
    param ()
    $WinPEScriptsRE = Get-ChildItem -Path ($GetOSDBuilderPathContentScripts,"$SetOSDBuilderPathContent\WinPE\Scripts") *.ps1 -ErrorAction SilentlyContinue | Select-Object -Property Name, FullName, Length, CreationTime | Sort-Object -Property FullName
    foreach ($TaskScript in $WinPEScriptsRE) {$TaskScript.FullName = $($TaskScript.FullName).replace("$SetOSDBuilderPathContent\",'')}
    if ($null -eq $WinPEScriptsRE) {Write-Warning "WinRE PowerShell Scripts: To select PowerShell Scripts add Content to $GetOSDBuilderPathContentScripts"}
    else {
        if ($ExistingTask.WinPEScriptsRE) {
            foreach ($Item in $ExistingTask.WinPEScriptsRE) {
                $WinPEScriptsRE = $WinPEScriptsRE | Where-Object {$_.FullName -ne $Item}
            }
        }
        $WinPEScriptsRE = $WinPEScriptsRE | Out-GridView -Title "WinRE PowerShell Scripts: Select PowerShell Scripts to execute and press OK (Esc or Cancel to Skip)" -PassThru
    }
    foreach ($Item in $WinPEScriptsRE) {Write-Host "$($Item.FullName)" -ForegroundColor White}
    Return $WinPEScriptsRE
}
function Get-TaskWinPEScriptsSE {
    #=================================================
    #   WinSE PowerShell Scripts
    #=================================================
    [CmdletBinding()]
    param ()
    $WinPEScriptsSE = Get-ChildItem -Path ($GetOSDBuilderPathContentScripts,"$SetOSDBuilderPathContent\WinPE\Scripts") *.ps1 -ErrorAction SilentlyContinue | Select-Object -Property Name, FullName, Length, CreationTime | Sort-Object -Property FullName
    foreach ($TaskScript in $WinPEScriptsSE) {$TaskScript.FullName = $($TaskScript.FullName).replace("$SetOSDBuilderPathContent\",'')}
    if ($null -eq $WinPEScriptsSE) {Write-Warning "WinSE PowerShell Scripts: To select PowerShell Scripts add Content to $GetOSDBuilderPathContentScripts"}
    else {
        if ($ExistingTask.WinPEScriptsSE) {
            foreach ($Item in $ExistingTask.WinPEScriptsSE) {
                $WinPEScriptsSE = $WinPEScriptsSE | Where-Object {$_.FullName -ne $Item}
            }
        }
        $WinPEScriptsSE = $WinPEScriptsSE | Out-GridView -Title "WinSE PowerShell Scripts: Select PowerShell Scripts to execute and press OK (Esc or Cancel to Skip)" -PassThru
    }
    foreach ($Item in $WinPEScriptsSE) {Write-Host "$($Item.FullName)" -ForegroundColor White}
    Return $WinPEScriptsSE
}
function Get-Value {
        param( $value )

        $result = $null
        if ( $value -is [System.Management.Automation.PSCustomObject] )
        {
            Write-Verbose "Get-Value: value is PSCustomObject"
            $result = @{}
            $value.psobject.properties | ForEach-Object { 
                $result[$_.Name] = Get-Value -value $_.Value 
            }
        }
        elseif ($value -is [System.Object[]])
        {
            $list = New-Object System.Collections.ArrayList
            Write-Verbose "Get-Value: value is Array"
            $value | ForEach-Object {
                $list.Add((Get-Value -value $_)) | Out-Null
            }
            $result = $list
        }
        else
        {
            Write-Verbose "Get-Value: value is type: $($value.GetType())"
            $result = $value
        }
        return $result
    }
function Import-AutoExtraFilesPE {
    [CmdletBinding()]
    param ()
    #=================================================
    #   Abort
    #=================================================
    if (($ScriptName -ne 'New-OSBuild') -and ($ScriptName -ne 'New-OSDCloudOSMedia')) {Return}
    if ($WinPEAutoExtraFiles -ne $true) {Return}
    #=================================================
    #   Header
    #=================================================
    Show-ActionTime; Write-Host -ForegroundColor Green "WinPE: Import AutoExtraFiles"
    #=================================================
    #   Execute
    #=================================================
    Write-Host "Source: $WinPE\AutoExtraFiles" -ForegroundColor DarkGray
    $CurrentLog = "$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Import-AutoExtraFilesPE.log"

    robocopy "$WinPE\AutoExtraFiles" "$MountWinPE" *.* /s /ndl /xf bcp47*.dll /xx /b /np /ts /tee /r:0 /w:0 /Log+:"$CurrentLog" | Out-Null
    robocopy "$WinPE\AutoExtraFiles" "$MountWinRE" *.* /s /ndl /xf bcp47*.dll /xx /b /np /ts /tee /r:0 /w:0 /Log+:"$CurrentLog" | Out-Null
    robocopy "$WinPE\AutoExtraFiles" "$MountWinSE" *.* /s /ndl /xf bcp47*.dll /xx /b /np /ts /tee /r:0 /w:0 /Log+:"$CurrentLog" | Out-Null
    #=================================================
}
function Import-RegistryRegOS {
    [CmdletBinding()]
    param ()
    #=================================================
    #   ABORT
    #=================================================
    if ([string]::IsNullOrWhiteSpace($RegistryTemplatesReg)) {Return}
    #=================================================
    #   Execute
    #=================================================
    if ($RegistryTemplatesReg) {
        Show-ActionTime; Write-Host -ForegroundColor Green "OS: Template Registry REG"
        #======================================================================================
        # Load Registry Hives
        #======================================================================================
        if (Test-Path "$MountDirectory\Users\Default\NTUser.dat") {
            Write-Host "Loading Offline Registry Hive Default User" -ForegroundColor DarkGray
            Start-Process reg -ArgumentList "load HKLM\OfflineDefaultUser $MountDirectory\Users\Default\NTUser.dat" -Wait -WindowStyle Hidden -ErrorAction SilentlyContinue
        }
        if (Test-Path "$MountDirectory\Windows\System32\Config\DEFAULT") {
            Write-Host "Loading Offline Registry Hive DEFAULT" -ForegroundColor DarkGray
            Start-Process reg -ArgumentList "load HKLM\OfflineDefault $MountDirectory\Windows\System32\Config\DEFAULT" -Wait -WindowStyle Hidden -ErrorAction SilentlyContinue
        }
        if (Test-Path "$MountDirectory\Windows\System32\Config\SOFTWARE") {
            Write-Host "Loading Offline Registry Hive SOFTWARE" -ForegroundColor DarkGray
            Start-Process reg -ArgumentList "load HKLM\OfflineSoftware $MountDirectory\Windows\System32\Config\SOFTWARE" -Wait -WindowStyle Hidden -ErrorAction SilentlyContinue
        }
        if (Test-Path "$MountDirectory\Windows\System32\Config\SYSTEM") {
            Write-Host "Loading Offline Registry Hive SYSTEM" -ForegroundColor DarkGray
            Start-Process reg -ArgumentList "load HKLM\OfflineSystem $MountDirectory\Windows\System32\Config\SYSTEM" -Wait -WindowStyle Hidden -ErrorAction SilentlyContinue
        }
        #======================================================================================
        #	Process Registry REG
        #======================================================================================
        foreach ($RegistryREG in $RegistryTemplatesReg) {
            Write-Host "Processing $($RegistryREG.FullName)"
            $REGImportContent = @()
            $REGImportContent = Get-Content -Path $RegistryREG.FullName
            foreach ($Line in $REGImportContent) {
                Write-Host "$Line" -ForegroundColor Gray
            }
            Start-Process reg -ArgumentList ('import',"`"$($RegistryREG.FullName)`"") -Wait -WindowStyle Hidden -ErrorAction SilentlyContinue
        }
        #======================================================================================
        #	Unload Registry Hives
        #======================================================================================
        if (Test-Path -Path "HKLM:\OfflineDefaultUser") {
            Write-Host "Unloading Registry HKLM\OfflineDefaultUser" -ForegroundColor DarkGray
            Start-Process reg -ArgumentList "unload HKLM\OfflineDefaultUser" -Wait -WindowStyle Hidden -ErrorAction SilentlyContinue
        }
        if (Test-Path -Path "HKLM:\OfflineDefault") {
            Write-Host "Unloading Registry HKLM\OfflineDefault" -ForegroundColor DarkGray
            Start-Process reg -ArgumentList "unload HKLM\OfflineDefault" -Wait -WindowStyle Hidden -ErrorAction SilentlyContinue
        }
        if (Test-Path -Path "HKLM:\OfflineSoftware") {
            Write-Host "Unloading Registry HKLM\OfflineSoftware" -ForegroundColor DarkGray
            Start-Process reg -ArgumentList "unload HKLM\OfflineSoftware" -Wait -WindowStyle Hidden -ErrorAction SilentlyContinue
        }
        if (Test-Path -Path "HKLM:\OfflineSystem") {
            Write-Host "Unloading Registry HKLM\OfflineSystem" -ForegroundColor DarkGray
            Start-Process reg -ArgumentList "unload HKLM\OfflineSystem" -Wait -WindowStyle Hidden -ErrorAction SilentlyContinue
        }

        if (Test-Path -Path "HKLM:\OfflineDefaultUser") {
            Write-Host "Unloading Registry HKLM\OfflineDefaultUser (Second Attempt)" -ForegroundColor DarkGray
            Start-Process reg -ArgumentList "unload HKLM\OfflineDefaultUser" -Wait -WindowStyle Hidden -ErrorAction SilentlyContinue
        }
        if (Test-Path -Path "HKLM:\OfflineDefault") {
            Write-Host "Unloading Registry HKLM\OfflineDefault (Second Attempt)" -ForegroundColor DarkGray
            Start-Process reg -ArgumentList "unload HKLM\OfflineDefault" -Wait -WindowStyle Hidden -ErrorAction SilentlyContinue
        }
        if (Test-Path -Path "HKLM:\OfflineSoftware") {
            Write-Host "Unloading Registry HKLM\OfflineSoftware (Second Attempt)" -ForegroundColor DarkGray
            Start-Process reg -ArgumentList "unload HKLM\OfflineSoftware" -Wait -WindowStyle Hidden -ErrorAction SilentlyContinue
        }
        if (Test-Path -Path "HKLM:\OfflineSystem") {
            Write-Host "Unloading Registry HKLM\OfflineSystem (Second Attempt)" -ForegroundColor DarkGray
            Start-Process reg -ArgumentList "unload HKLM\OfflineSystem" -Wait -WindowStyle Hidden -ErrorAction SilentlyContinue
        }

        if (Test-Path -Path "HKLM:\OfflineDefaultUser") {
            Write-Warning "HKLM:\OfflineDefaultUser could not be dismounted.  Open Regedit and unload the Hive manually"
            Pause
        }
        if (Test-Path -Path "HKLM:\OfflineDefault") {
            Write-Warning "HKLM:\OfflineDefault could not be dismounted.  Open Regedit and unload the Hive manually"
            Pause
        }
        if (Test-Path -Path "HKLM:\OfflineSoftware") {
            Write-Warning "HKLM:\OfflineSoftware could not be dismounted.  Open Regedit and unload the Hive manually"
            Pause
        }
        if (Test-Path -Path "HKLM:\OfflineSystem") {
            Write-Warning "HKLM:\OfflineSystem could not be dismounted.  Open Regedit and unload the Hive manually"
            Pause
        }
    }
    #======================================================================================
}
function Import-RegistryXmlOS {
    [CmdletBinding()]
    param ()
    #=================================================
    #   ABORT
    #=================================================
    if ([string]::IsNullOrWhiteSpace($RegistryTemplatesXml)) {Return}
    #=================================================
    #   Execute
    #=================================================
    Show-ActionTime; Write-Host -ForegroundColor Green "OS: Template Registry XML"
    if ($RegistryTemplatesXml) {
        #======================================================================================
        # Load Registry Hives
        #======================================================================================
        if (Test-Path "$MountDirectory\Users\Default\NTUser.dat") {
            Write-Host "Loading Offline Registry Hive Default User" -ForegroundColor DarkGray
            Start-Process reg -ArgumentList "load HKLM\OfflineDefaultUser $MountDirectory\Users\Default\NTUser.dat" -Wait -WindowStyle Hidden -ErrorAction SilentlyContinue
        }
        if (Test-Path "$MountDirectory\Windows\System32\Config\DEFAULT") {
            Write-Host "Loading Offline Registry Hive DEFAULT" -ForegroundColor DarkGray
            Start-Process reg -ArgumentList "load HKLM\OfflineDefault $MountDirectory\Windows\System32\Config\DEFAULT" -Wait -WindowStyle Hidden -ErrorAction SilentlyContinue
        }
        if (Test-Path "$MountDirectory\Windows\System32\Config\SOFTWARE") {
            Write-Host "Loading Offline Registry Hive SOFTWARE" -ForegroundColor DarkGray
            Start-Process reg -ArgumentList "load HKLM\OfflineSoftware $MountDirectory\Windows\System32\Config\SOFTWARE" -Wait -WindowStyle Hidden -ErrorAction SilentlyContinue
        }
        if (Test-Path "$MountDirectory\Windows\System32\Config\SYSTEM") {
            Write-Host "Loading Offline Registry Hive SYSTEM" -ForegroundColor DarkGray
            Start-Process reg -ArgumentList "load HKLM\OfflineSystem $MountDirectory\Windows\System32\Config\SYSTEM" -Wait -WindowStyle Hidden -ErrorAction SilentlyContinue
        }
        #======================================================================================
        #	Process Registry XML
        #======================================================================================
        foreach ($RegistryXml in $RegistryTemplatesXml) {
            $RegistrySettings = @()
            Write-Host "Processing $($RegistryXml.FullName)"

            [xml]$XmlDocument = Get-Content -Path $RegistryXml.FullName
            $nodes = $XmlDocument.SelectNodes("//*[@action]")

            foreach ($node in $nodes) {
                $NodeAction = $node.attributes['action'].value
                $NodeDefault = $node.attributes['default'].value
                $NodeHive = $node.attributes['hive'].value
                $NodeKey = $node.attributes['key'].value
                $NodeName = $node.attributes['name'].value
                $NodeType = $node.attributes['type'].value
                $NodeValue = $node.attributes['value'].value

                $obj = new-object psobject -prop @{Action=$NodeAction;Default=$NodeDefault;Hive=$NodeHive;Key=$NodeKey;Name=$NodeName;Type=$NodeType;Value=$NodeValue}
                $RegistrySettings += $obj
            }

            foreach ($RegEntry in $RegistrySettings) {
                $RegAction = $RegEntry.Action
                $RegDefault = $RegEntry.Default
                $RegHive = $RegEntry.Hive
                #$RegHive = $RegHive -replace 'HKEY_LOCAL_MACHINE','HKLM:' -replace 'HKEY_CURRENT_USER','HKCU:' -replace 'HKEY_USERS','HKU:'
                $RegKey = $RegEntry.Key
                $RegName = $RegEntry.Name
                $RegType = $RegEntry.Type
                $RegType = $RegType -replace 'REG_SZ','String'
                $RegType = $RegType -replace 'REG_DWORD','DWord'
                $RegType = $RegType -replace 'REG_QWORD','QWord'
                $RegType = $RegType -replace 'REG_MULTI_SZ','MultiString'
                $RegType = $RegType -replace 'REG_EXPAND_SZ','ExpandString'
                $RegType = $RegType -replace 'REG_BINARY','Binary'
                $RegValue = $RegEntry.Value

                if ($RegType -eq 'Binary') {
                    $RegValue = $RegValue -replace '(..(?!$))','$1,'
                    $RegValue = $RegValue.Split(',') | ForEach-Object {"0x$_"}
                }

                $RegPath = "Registry::$RegHive\$RegKey"
                $RegPath = $RegPath -replace 'HKEY_CURRENT_USER','HKEY_LOCAL_MACHINE\OfflineDefaultUser'
                $RegPath = $RegPath -replace 'HKEY_LOCAL_MACHINE\\SOFTWARE','HKEY_LOCAL_MACHINE\OfflineSoftware'
                $RegPath = $RegPath -replace 'HKEY_LOCAL_MACHINE\\SYSTEM','HKEY_LOCAL_MACHINE\OfflineSystem'
                $RegPath = $RegPath -replace 'HKEY_USERS\\.DEFAULT','HKEY_LOCAL_MACHINE\OfflineDefault'
                
                if ($RegAction -eq "D") {
                    Write-Host "Remove-ItemProperty -LiteralPath $RegPath" -ForegroundColor Red
                    if ($RegDefault -eq '0' -and $RegName -eq '' -and $RegValue -eq '') {
                        Remove-ItemProperty -LiteralPath $RegPath -Force -ErrorAction SilentlyContinue | Out-Null
                    } elseif ($RegDefault -eq '1') {
                        Write-Host "-Name '(Default)'"
                        Remove-ItemProperty -LiteralPath $RegPath -Name '(Default)' -Force -ErrorAction SilentlyContinue | Out-Null
                    } else {
                        Write-Host "-Name $RegName"
                        Remove-ItemProperty -LiteralPath $RegPath -Name $RegName -Force -ErrorAction SilentlyContinue | Out-Null
                    }
                } else {
                    if (!(Test-Path -LiteralPath $RegPath)) {
                        Write-Host "New-Item -Path $RegPath" -ForegroundColor Gray
                        New-Item -Path $RegPath -Force | Out-Null
                    }
                    if ($RegDefault -eq '1') {$RegName = '(Default)'}
                    if (!($RegType -eq '')) {
                        Write-Host "New-ItemProperty -LiteralPath $RegPath" -ForegroundColor Gray
                        Write-Host "-Name $RegName -PropertyType $RegType -Value $RegValue" -ForegroundColor DarkGray
                        New-ItemProperty -LiteralPath $RegPath -Name $RegName -PropertyType $RegType -Value $RegValue -Force | Out-Null
                    }
                }
            }
        }
        #======================================================================================
        #	Unload Registry Hives
        #======================================================================================
        if (Test-Path -Path "HKLM:\OfflineDefaultUser") {
            Write-Host "Unloading Registry HKLM\OfflineDefaultUser" -ForegroundColor DarkGray
            Start-Process reg -ArgumentList "unload HKLM\OfflineDefaultUser" -Wait -WindowStyle Hidden -ErrorAction SilentlyContinue
        }
        if (Test-Path -Path "HKLM:\OfflineDefault") {
            Write-Host "Unloading Registry HKLM\OfflineDefault" -ForegroundColor DarkGray
            Start-Process reg -ArgumentList "unload HKLM\OfflineDefault" -Wait -WindowStyle Hidden -ErrorAction SilentlyContinue
        }
        if (Test-Path -Path "HKLM:\OfflineSoftware") {
            Write-Host "Unloading Registry HKLM\OfflineSoftware" -ForegroundColor DarkGray
            Start-Process reg -ArgumentList "unload HKLM\OfflineSoftware" -Wait -WindowStyle Hidden -ErrorAction SilentlyContinue
        }
        if (Test-Path -Path "HKLM:\OfflineSystem") {
            Write-Host "Unloading Registry HKLM\OfflineSystem" -ForegroundColor DarkGray
            Start-Process reg -ArgumentList "unload HKLM\OfflineSystem" -Wait -WindowStyle Hidden -ErrorAction SilentlyContinue
        }

        if (Test-Path -Path "HKLM:\OfflineDefaultUser") {
            Write-Host "Unloading Registry HKLM\OfflineDefaultUser (Second Attempt)" -ForegroundColor DarkGray
            Start-Process reg -ArgumentList "unload HKLM\OfflineDefaultUser" -Wait -WindowStyle Hidden -ErrorAction SilentlyContinue
        }
        if (Test-Path -Path "HKLM:\OfflineDefault") {
            Write-Host "Unloading Registry HKLM\OfflineDefault (Second Attempt)" -ForegroundColor DarkGray
            Start-Process reg -ArgumentList "unload HKLM\OfflineDefault" -Wait -WindowStyle Hidden -ErrorAction SilentlyContinue
        }
        if (Test-Path -Path "HKLM:\OfflineSoftware") {
            Write-Host "Unloading Registry HKLM\OfflineSoftware (Second Attempt)" -ForegroundColor DarkGray
            Start-Process reg -ArgumentList "unload HKLM\OfflineSoftware" -Wait -WindowStyle Hidden -ErrorAction SilentlyContinue
        }
        if (Test-Path -Path "HKLM:\OfflineSystem") {
            Write-Host "Unloading Registry HKLM\OfflineSystem (Second Attempt)" -ForegroundColor DarkGray
            Start-Process reg -ArgumentList "unload HKLM\OfflineSystem" -Wait -WindowStyle Hidden -ErrorAction SilentlyContinue
        }

        if (Test-Path -Path "HKLM:\OfflineDefaultUser") {
            Write-Warning "HKLM:\OfflineDefaultUser could not be dismounted.  Open Regedit and unload the Hive manually"
            Pause
        }
        if (Test-Path -Path "HKLM:\OfflineDefault") {
            Write-Warning "HKLM:\OfflineDefault could not be dismounted.  Open Regedit and unload the Hive manually"
            Pause
        }
        if (Test-Path -Path "HKLM:\OfflineSoftware") {
            Write-Warning "HKLM:\OfflineSoftware could not be dismounted.  Open Regedit and unload the Hive manually"
            Pause
        }
        if (Test-Path -Path "HKLM:\OfflineSystem") {
            Write-Warning "HKLM:\OfflineSystem could not be dismounted.  Open Regedit and unload the Hive manually"
            Pause
        }
    }
    #======================================================================================
}
function Invoke-DismCleanupImage {
    [CmdletBinding()]
    param (
        [switch]$HideCleanupProgress
    )
    #19.10.14 Removed Out-Null.  Modified Warning Message
    #=================================================
    #   Abort
    #=================================================
    if ($SkipUpdates) {Return}
    if ($SkipComponentCleanup) {Return}
    if ($OSVersion -like "6.1*") {Return}
    #=================================================
    #   Header
    #=================================================
    Show-ActionTime
    Write-Host -ForegroundColor Green "OS: DISM Cleanup-Image StartComponentCleanup ResetBase"
    #=================================================
    #   Abort Pending Operations
    #=================================================
    if ($OSMajorVersion -eq 10) {
        if ($(Get-WindowsCapability -Path $MountDirectory | Where-Object {$_.state -eq "*pending*"})) {
            Write-Warning "Cannot run WindowsImage Cleanup on a WIM with Pending Installations"
            Return
        }
    }
    #=================================================
    #   CurrentLog
    #=================================================
    $CurrentLog = "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Invoke-DismCleanupImage.log"
    #=================================================
    #   Execute
    #=================================================
    if ($HideCleanupProgress.IsPresent) {
        Write-Warning "This process will take between 5 - 200 minutes to complete, depending on the number of Updates"
        Write-Warning "Check Task Manager DISM and DISMHOST processes for activity"
        Write-Host -ForegroundColor DarkGray "                  $CurrentLog"
        Dism /Image:"$MountDirectory" /Cleanup-Image /StartComponentCleanup /ResetBase /LogPath:"$CurrentLog" | Out-Null
    } else {
        Write-Verbose "$CurrentLog"
        Dism /Image:"$MountDirectory" /Cleanup-Image /StartComponentCleanup /ResetBase /LogPath:"$CurrentLog"
    }
    #=================================================
}
function Mount-ImportOSMediaWim {
    [CmdletBinding()]
    param ()
    #=================================================
    #   Header
    #=================================================
    Show-ActionTime; Write-Host -ForegroundColor Green "Mount Install.wim: $MountDirectory"
    #=================================================
    #   Execute
    #=================================================
    if (!(Test-Path "$MountDirectory")) {New-Item "$MountDirectory" -ItemType Directory -Force | Out-Null}

    if ($OSMediaGetItem.Extension -eq '.esd') {
        Write-Host -ForegroundColor Gray "                  Image: $SourceTempWim"
        Write-Host -ForegroundColor Gray "                  Index: 1"
        Write-Host -ForegroundColor Gray "                  Mount Directory: $MountDirectory"
        Mount-WindowsImage -ImagePath $SourceTempWim -Index '1' -Path "$MountDirectory" -ReadOnly | Out-Null
    } else {
        Write-Host -ForegroundColor Gray "                  Image: $SourceImagePath"
        Write-Host -ForegroundColor Gray "                  Index: $SourceImageIndex"
        Write-Host -ForegroundColor Gray "                  Mount Directory: $MountDirectory"
        Mount-WindowsImage -ImagePath $SourceImagePath -Index $SourceImageIndex -Path "$MountDirectory" -ReadOnly | Out-Null
    }
}
function Mount-InstallwimOS {
    [CmdletBinding()]
    param ()
    #=================================================
    #   Header
    #=================================================
    Show-ActionTime
    Write-Host -ForegroundColor Green "OS: Mount to $MountDirectory"
    #=================================================
    #   Execute
    #=================================================
    $CurrentLog = "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Mount-WindowsImage.log"
    Write-Verbose "CurrentLog: $CurrentLog"
    Mount-WindowsImage -ImagePath "$WimTemp\install.wim" -Index 1 -Path "$MountDirectory" -LogPath "$CurrentLog" | Out-Null
}
function Mount-OSDOfflineRegistryPE {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$MountPath
    )
    if (($MountPath) -and (Test-Path "$MountPath" -ErrorAction SilentlyContinue)) {
        if (Test-Path "$MountPath\Windows\ServiceProfiles\LocalService\NTUser.dat") {
            Write-Verbose "Loading Offline Registry Hive System Profile" 
            Start-Process reg -ArgumentList "load HKLM\OfflineDefaultUser $MountPath\Windows\ServiceProfiles\LocalService\NTUser.dat" -Wait -WindowStyle Hidden -ErrorAction SilentlyContinue
        }
        if (Test-Path "$MountPath\Windows\System32\Config\DEFAULT") {
            Write-Verbose "Loading Offline Registry Hive DEFAULT" 
            Start-Process reg -ArgumentList "load HKLM\OfflineDefault $MountPath\Windows\System32\Config\DEFAULT" -Wait -WindowStyle Hidden -ErrorAction SilentlyContinue
        }
        if (Test-Path "$MountPath\Windows\System32\Config\SOFTWARE") {
            Write-Verbose "Loading Offline Registry Hive SOFTWARE" 
            Start-Process reg -ArgumentList "load HKLM\OfflineSoftware $MountPath\Windows\System32\Config\SOFTWARE" -Wait -WindowStyle Hidden -ErrorAction Stop
        }
        if (Test-Path "$MountPath\Windows\System32\Config\SYSTEM") {
            Write-Verbose "Loading Offline Registry Hive SYSTEM" 
            Start-Process reg -ArgumentList "load HKLM\OfflineSystem $MountPath\Windows\System32\Config\SYSTEM" -Wait -WindowStyle Hidden -ErrorAction Stop
        }
    }
}
function Mount-PEBuild {
    [CmdletBinding()]
    param (
        [string]$MountDirectory,
        [string]$WorkingWim
    )
    #=================================================
    #   Header
    #=================================================
    Show-ActionTime; Write-Host -ForegroundColor Green "WinPE: Mount WinPE to $MountDirectory"
    #=================================================
    #   Execute
    #=================================================
    $CurrentLog = "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Mount-PEBuild.log"
    Write-Verbose "CurrentLog: $CurrentLog"
    Mount-WindowsImage -ImagePath $WorkingWim -Index 1 -Path "$MountDirectory" -LogPath "$CurrentLog" | Out-Null
}
function Mount-WinPEwim {
    [CmdletBinding()]
    param (
        [string]$OSMediaPath
    )
    #=================================================
    #   Header
    #=================================================
    Show-ActionTime; Write-Host -ForegroundColor Green "WinPE: Mount WinPE.wim to $MountWinPE"
    #=================================================
    #   Execute
    #=================================================
    $CurrentLog = "$OSMediaPath\WinPE\info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Mount-WindowsImage-WinPE.log"
    Write-Verbose "CurrentLog: $CurrentLog"
    Mount-WindowsImage -ImagePath "$OSMediaPath\WimTemp\winpe.wim" -Index 1 -Path "$MountWinPE" -LogPath "$CurrentLog" | Out-Null
}
function Mount-WinREwim {
    [CmdletBinding()]
    param (
        [string]$OSMediaPath
    )
    #=================================================
    #   Header
    #=================================================
    Show-ActionTime; Write-Host -ForegroundColor Green "WinPE: Mount WinRE.wim to $MountWinRE"
    #=================================================
    #   Execute
    #=================================================
    $CurrentLog = "$OSMediaPath\WinPE\info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Mount-WindowsImage-WinRE.log"
    Write-Verbose "CurrentLog: $CurrentLog"
    Mount-WindowsImage -ImagePath "$OSMediaPath\WimTemp\winre.wim" -Index 1 -Path "$MountWinRE" -LogPath "$CurrentLog" | Out-Null
}
function Mount-WinSEwim {
    [CmdletBinding()]
    param (
        [string]$OSMediaPath
    )
    #=================================================
    #   Header
    #=================================================
    Show-ActionTime; Write-Host -ForegroundColor Green "WinPE: Mount WinSE.wim to $MountWinSE"
    #=================================================
    #   Execute
    #=================================================
    $CurrentLog = "$OSMediaPath\WinPE\info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Mount-WindowsImage-WinSE.log"
    Write-Verbose "CurrentLog: $CurrentLog"
    Mount-WindowsImage -ImagePath "$OSMediaPath\WimTemp\winse.wim" -Index 1 -Path "$MountWinSE" -LogPath "$CurrentLog" | Out-Null
}
function New-DirectoriesOSMedia {
    [CmdletBinding()]
    param ()
    if (!(Test-Path "$Info"))           {New-Item "$Info" -ItemType Directory -Force | Out-Null}
    if (!(Test-Path "$Info\json"))      {New-Item "$Info\json" -ItemType Directory -Force | Out-Null}
    if (!(Test-Path "$Info\logs"))      {New-Item "$Info\logs" -ItemType Directory -Force | Out-Null}
    if (!(Test-Path "$Info\xml"))       {New-Item "$Info\xml" -ItemType Directory -Force | Out-Null}
    if (!(Test-Path "$OS"))             {New-Item "$OS" -ItemType Directory -Force | Out-Null}
    if (!(Test-Path "$WinPE"))          {New-Item "$WinPE" -ItemType Directory -Force | Out-Null}
    if (!(Test-Path "$PEInfo"))         {New-Item "$PEInfo" -ItemType Directory -Force | Out-Null}
    if (!(Test-Path "$PEInfo\json"))    {New-Item "$PEInfo\json" -ItemType Directory -Force | Out-Null}
    if (!(Test-Path "$PEInfo\logs"))    {New-Item "$PEInfo\logs" -ItemType Directory -Force | Out-Null}
    if (!(Test-Path "$PEInfo\xml"))     {New-Item "$PEInfo\xml" -ItemType Directory -Force | Out-Null}
    if (!(Test-Path "$WimTemp"))        {New-Item "$WimTemp" -ItemType Directory -Force | Out-Null}
    if (!(Test-Path "$MountDirectory")) {New-Item "$MountDirectory" -ItemType Directory -Force | Out-Null}
    if (!(Test-Path "$MountWinPE"))     {New-Item "$MountWinPE" -ItemType Directory -Force | Out-Null}
    if (!(Test-Path "$MountWinSE"))     {New-Item "$MountWinSE" -ItemType Directory -Force | Out-Null}
    if (!(Test-Path "$MountWinRE"))     {New-Item "$MountWinRE" -ItemType Directory -Force | Out-Null}
}
function New-ItemDirectoryGetOSDBuilderHome {
    [CmdletBinding()]
    param ()
    $ItemDirectories = @(
        $GetOSDBuilderHome
        $SetOSDBuilderPathContent
        $SetOSDBuilderPathContentPacks
        $SetOSDBuilderPathFeatureUpdates
        $SetOSDBuilderPathOSBuilds
        $SetOSDBuilderPathOSImport
        $SetOSDBuilderPathOSMedia
        $SetOSDBuilderPathPEBuilds
        $SetOSDBuilderPathTasks
        $SetOSDBuilderPathTemplates
        $SetOSDBuilderPathMount
        $SetOSDBuilderPathUpdates
    )

    foreach ($ItemDirectory in $ItemDirectories) {
        if (!(Test-Path $ItemDirectory)) {New-Item $ItemDirectory -ItemType Directory -Force | Out-Null}
    }
}
function New-ItemDirectorySetOSDBuilderPathContent {
    [CmdletBinding()]
    param ()
    $ItemDirectories = @(
        $SetOSDBuilderPathContent
        $GetOSDBuilderPathContentADK
        "$GetOSDBuilderPathContentADK\Windows 10 1903\Windows Preinstallation Environment"
        #"$GetOSDBuilderPathContentADK\Windows 10 1909\Windows Preinstallation Environment"
        "$GetOSDBuilderPathContentADK\Windows 10 2004\Windows Preinstallation Environment"
        #"$GetOSDBuilderPathContentADK\Windows 10 2009\Windows Preinstallation Environment"
        $GetOSDBuilderPathContentDaRT
        "$GetOSDBuilderPathContentDaRT\DaRT 10"
        $GetOSDBuilderPathContentDrivers
        "$SetOSDBuilderPathContent\ExtraFiles"
        #"$GetOSDBuilderPathContentIsoExtract"
        "$GetOSDBuilderPathContentIsoExtract\Windows 10 1903 FOD x64"
        "$GetOSDBuilderPathContentIsoExtract\Windows 10 1903 Language"
        #"$GetOSDBuilderPathContentIsoExtract\Windows 10 1909 FOD x64"
        #"$GetOSDBuilderPathContentIsoExtract\Windows 10 1909 Language"
        "$GetOSDBuilderPathContentIsoExtract\Windows 10 2004 FOD x64"
        "$GetOSDBuilderPathContentIsoExtract\Windows 10 2004 Language"
        #"$GetOSDBuilderPathContentIsoExtract\Windows 10 2009 FOD x64"
        #"$GetOSDBuilderPathContentIsoExtract\Windows 10 2009 Language"
        #"$GetOSDBuilderPathContentIsoExtract\Windows 10 1909 Language"
        "$GetOSDBuilderPathContentIsoExtract\Windows Server 2019 1809 FOD x64"
        "$GetOSDBuilderPathContentIsoExtract\Windows Server 2019 1809 Language"
        #"$SetOSDBuilderPathContent\LanguagePacks"
        $SetOSDBuilderPathMount
        $GetOSDBuilderPathContentOneDrive
		$SetOSDBuilderPathUpdates
        $GetOSDBuilderPathContentPackages
        #"$GetOSDBuilderPathContentPackages\Win10 x64 1809"
        #"$SetOSDBuilderPathContent\Provisioning"
        #"$SetOSDBuilderPathContent\Registry"
		$GetOSDBuilderPathContentScripts
        $GetOSDBuilderPathContentStartLayout
        $GetOSDBuilderPathContentUnattend
        #"$SetOSDBuilderPathContent\Updates"
        #"$SetOSDBuilderPathContent\Updates\Custom"
        #"$SetOSDBuilderPathContent\WinPE"
        #"$SetOSDBuilderPathContent\WinPE\ADK\Win10 x64 1809"
        #"$SetOSDBuilderPathContent\WinPE\DaRT\DaRT 10"
        #"$SetOSDBuilderPathContent\WinPE\Drivers"
        #"$SetOSDBuilderPathContent\WinPE\Drivers\WinPE 10 x64"
        #"$SetOSDBuilderPathContent\WinPE\Drivers\WinPE 10 x86"
        #"$SetOSDBuilderPathContent\WinPE\ExtraFiles"
        #"$SetOSDBuilderPathContent\WinPE\Scripts"
    )

    foreach ($ItemDirectory in $ItemDirectories) {
        if (!(Test-Path $ItemDirectory)) {New-Item $ItemDirectory -ItemType Directory -Force | Out-Null}
    }
}
function Remove-AppxProvisionedPackageOS {
    [CmdletBinding()]
    param ()
    #=================================================
    #   Abort
    #=================================================
    if ($ScriptName -ne 'New-OSBuild') {Return}
    if ($OSMajorVersion -ne 10) {Return}
    if ([string]::IsNullOrWhiteSpace($RemoveAppx)) {Return}
    #=================================================
    #   Header
    #=================================================
    Show-ActionTime
    Write-Host -ForegroundColor Green "OS: Remove Appx Packages"
    #=================================================
    #   Execute
    #=================================================
    foreach ($item in $RemoveAppx) {
        Write-Host $item -ForegroundColor DarkGray
        Try {
            Remove-AppxProvisionedPackage -Path "$MountDirectory" -PackageName $item -LogPath "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Remove-AppxProvisionedPackage.log" | Out-Null
        }
        Catch {
            $ErrorMessage = $_.Exception.Message
            Write-Warning "$ErrorMessage"
        }
    }
}
function Remove-WindowsCapabilityOS {
    [CmdletBinding()]
    param ()
    #=================================================
    #   Abort
    #=================================================
    if ($ScriptName -ne 'New-OSBuild') {Return}
    if ([string]::IsNullOrWhiteSpace($RemoveCapability)) {Return}
    #=================================================
    #   Header
    #=================================================
    Show-ActionTime
    Write-Host -ForegroundColor Green "OS: Remove Windows Capability"
    #=================================================
    #   Execute
    #=================================================
    foreach ($Name in $RemoveCapability) {
        Write-Host $Name -ForegroundColor DarkGray
        Try {
            Remove-WindowsCapability -Path "$MountDirectory" -Name $Name -LogPath "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Remove-WindowsCapability.log" | Out-Null
        }
        Catch {
            $ErrorMessage = $_.Exception.Message
            Write-Warning "$ErrorMessage"
        }
    }
}
function Remove-WindowsPackageOS {
    [CmdletBinding()]
    param ()
    #=================================================
    #   Abort
    #=================================================
    if ($ScriptName -ne 'New-OSBuild') {Return}
    if ([string]::IsNullOrWhiteSpace($RemovePackage)) {Return}
    #=================================================
    #   Header
    #=================================================
    Show-ActionTime
    Write-Host -ForegroundColor Green "OS: Remove Windows Packages"
    #=================================================
    #   Execute
    #=================================================
    foreach ($PackageName in $RemovePackage) {
        Write-Host $PackageName -ForegroundColor DarkGray
        Try {
            Remove-WindowsPackage -Path "$MountDirectory" -PackageName $PackageName -LogPath "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Remove-WindowsPackage.log" | Out-Null
        }
        Catch {
            $ErrorMessage = $_.Exception.Message
            Write-Warning "$ErrorMessage"
        }
    }
}
function Rename-OSMedia {
    [CmdletBinding()]
    param ()

    BEGIN {
        #=================================================
        #   Header
        #=================================================
        #   Write-Host '========================================================================================' -ForegroundColor DarkGray
        #   Write-Host -ForegroundColor Green "$($MyInvocation.MyCommand.Name) BEGIN"
        #=================================================
        #   Get-OSDBuilder
        #=================================================
        Get-OSDBuilder -CreatePaths -HideDetails
        #=================================================
        Write-Verbose '19.1.1 Gather All OSMedia'
        #=================================================
        $AllOSMedia = @()
        $AllOSMedia = Get-ChildItem -Path "$SetOSDBuilderPathOSMedia" -Directory | Select-Object -Property * | Where-Object {Test-Path $(Join-Path $_.FullName "info\xml\Get-WindowsImage.xml")}
    }

    PROCESS {
        #Write-Host '========================================================================================' -ForegroundColor DarkGray
        #Write-Host "$($MyInvocation.MyCommand.Name) PROCESS"

        $RenameOSMedia = foreach ($Item in $AllOSMedia) {
            #=================================================
            #Write-Verbose '19.1.1 Get Windows Image Information'
            #=================================================
            $RenameOSMediaPath = $($Item.FullName)
            Write-Verbose "OSMedia Full Path: $RenameOSMediaPath"
            
            $OSMWindowsImage = @()
            $OSMWindowsImage = Import-Clixml -Path "$RenameOSMediaPath\info\xml\Get-WindowsImage.xml"
            
            $OSMVersion = $($OSMWindowsImage.Version)
            Write-Verbose "Version: $OSMVersion"

            $OSMImageName = $($OSMWindowsImage.ImageName)
            Write-Verbose "ImageName: $OSMImageName"

            $OSMArch = $OSMWindowsImage.Architecture
            if ($OSMArch -eq '0') {$OSMArch = 'x86'}
            if ($OSMArch -eq '6') {$OSMArch = 'ia64'}
            if ($OSMArch -eq '9') {$OSMArch = 'x64'}
            if ($OSMArch -eq '12') {$OSMArch = 'x64 ARM'}
            Write-Verbose "Arch: $OSMArch"

            $OSMEditionId = $($OSMWindowsImage.EditionId)
            Write-Verbose "EditionId: $OSMEditionId"

            $OSMInstallationType = $($OSMWindowsImage.InstallationType)
            Write-Verbose "InstallationType: $OSMInstallationType"

            $OSMMajorVersion = $($OSMWindowsImage.MajorVersion)
            Write-Verbose "MajorVersion: $OSMMajorVersion"

            $OSMMinorVersion = $($OSMWindowsImage.MinorVersion)
            Write-Verbose "MinorVersion: $OSMMinorVersion"

            $OSMBuild = $OSMWindowsImage.Build
            Write-Verbose "Build: $OSMBuild"

            $OSMLanguages = $($OSMWindowsImage.Languages)
            Write-Verbose "Languages: $OSMLanguages"

            $OperatingSystem = ''
            if ($OSMMajorVersion -eq 6 -and $OSMInstallationType -eq 'Client') {$OperatingSystem = 'Windows 7'}
            if ($OSMMajorVersion -eq 10 -and $OSMInstallationType -eq 'Client') {
                if ($OSMImageName -match ' 11 ') {
                    $OperatingSystem = 'Windows 11'
                }
                else {
                    $OperatingSystem = 'Windows 10'
                }
            }
            if ($OSMMajorVersion -eq 10 -and $OSMInstallationType -eq 'Server' -and $OSMImageName -match '2016') {$OperatingSystem = 'Server 2016'}
            if ($OSMMajorVersion -eq 10 -and $OSMInstallationType -eq 'Server' -and $OSMImageName -match '2019') {$OperatingSystem = 'Server 2019'}
            if ($OSMMajorVersion -eq 10 -and $OSMInstallationType -eq 'Server' -and $OSMImageName -match '2022') {$OperatingSystem = 'Server 2022'}

            $OSMUBR = $($OSMWindowsImage.UBR)
            Write-Verbose "UBR: $OSMUBR"
			
            #   OSMFamily V1
            $OSMFamilyV1 = $(Get-Date -Date $($OSMWindowsImage.CreatedTime)).ToString("yyyyMMddHHmmss") + $OSMEditionID
            #   OSMFamily V2
            $OSMFamily = $OSMInstallationType + " " + $OSMEditionId + " " + $OSMArch + " " + [string]$OSMBuild + " " + $OSMLanguages
            Write-Verbose "OSMFamily: $OSMFamily"

            #$OSMWindowsImage | ForEach {$_.PSObject.Properties.Remove('Guid')}

            $OSMGuid = $($OSMWindowsImage.OSMGuid)
            if (-not ($OSMGuid)) {
                $OSMGuid = $(New-Guid)
                $OSMWindowsImage | Add-Member -Type NoteProperty -Name "OSMGuid" -Value $OSMGuid
                $OSMWindowsImage | Out-File "$RenameOSMediaPath\WindowsImage.txt"
                $OSMWindowsImage | Out-File "$RenameOSMediaPath\info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsImage.txt"
                $OSMWindowsImage | Export-Clixml -Path "$RenameOSMediaPath\info\xml\Get-WindowsImage.xml"
                $OSMWindowsImage | Export-Clixml -Path "$RenameOSMediaPath\info\xml\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsImage.xml"
                $OSMWindowsImage | ConvertTo-Json | Out-File "$RenameOSMediaPath\info\json\Get-WindowsImage.json"
                $OSMWindowsImage | ConvertTo-Json | Out-File "$RenameOSMediaPath\info\json\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsImage.json"
                (Get-Content "$RenameOSMediaPath\WindowsImage.txt") | Where-Object {$_.Trim(" `t")} | Set-Content "$RenameOSMediaPath\WindowsImage.txt"
                Write-Verbose "Guid (New): $OSMGuid"
            } else {
                Write-Verbose "Guid: $OSMGuid"
            }

            #=================================================
            #Write-Verbose '19.1.1 Gather Registry Information'
            #=================================================
            $OSMRegistry = @()
            if (Test-Path "$RenameOSMediaPath\info\xml\CurrentVersion.xml") {
                Write-Verbose "Registry: $RenameOSMediaPath\info\xml\CurrentVersion.xml"
                $OSMRegistry = Import-Clixml -Path "$RenameOSMediaPath\info\xml\CurrentVersion.xml"
            } else {
                Write-Verbose "Registry: $RenameOSMediaPath\info\xml\CurrentVersion.xml (Not Found)"
            }
            [string]$OSMReleaseId = $($OSMRegistry.ReleaseId)

            if ($OSMBuild -eq 7600) {$OSMReleaseId = 7600}
            if ($OSMBuild -eq 7601) {$OSMReleaseId = 7601}
            if ($OSMBuild -eq 9600) {$OSMReleaseId = 9600}
            if ($OSMBuild -eq 10240) {$OSMReleaseId = 1507}
            if ($OSMBuild -eq 14393) {$OSMReleaseId = 1607}
            if ($OSMBuild -eq 15063) {$OSMReleaseId = 1703}
            if ($OSMBuild -eq 16299) {$OSMReleaseId = 1709}
            if ($OSMBuild -eq 17134) {$OSMReleaseId = 1803}
            if ($OSMBuild -eq 17763) {$OSMReleaseId = 1809}
            #if ($OSMBuild -eq 18362) {$OSMReleaseId = 1903}
            #if ($OSMBuild -eq 18363) {$OSMReleaseId = 1909}
            #if ($OSMBuild -eq 19041) {$OSMReleaseId = 2004}
            #if ($OSMBuild -eq 19042) {$OSMReleaseId = '20H2'}
            #if ($OSMBuild -eq 19043) {$OSMReleaseId = '21H1'}
            #if ($OSMBuild -eq 19044) {$OSMReleaseId = '21H2'}

            Write-Verbose "ReleaseId: $OSMReleaseId"

            if ($OSMReleaseId -eq 7601) {$OSMReleaseId = 'SP1'}

            $FullNameFormat = "$OSMImageName $OSMArch $OSMReleaseId $OSMUBR $($OSMWindowsImage.Languages)"

            $FullNameFormat = $FullNameFormat -replace '\(', ''
            $FullNameFormat = $FullNameFormat -replace '\)', ''

            if ($($($OSMWindowsImage.Languages).count) -eq 1) {$FullNameFormat = $FullNameFormat.replace(' en-US','')}

            if (!($Item.Name -eq $FullNameFormat)) {
                #=================================================
                #Write-Verbose '19.1.1 Object Properties'
                #=================================================
                $ObjectProperties = @{
                    
                    FullNameFormat      = $FullNameFormat
                    Name                = $Item.Name
                    FullName            = $Item.FullName
                }
                New-Object -TypeName PSObject -Property $ObjectProperties
                Write-Verbose ""
            }

        }

        #=================================================
        #Write-Verbose '19.1.3 Output'
        #=================================================
        $RenameOSMedia = $RenameOSMedia | Select-Object FullNameFormat,Name,FullName | Out-GridView -PassThru -Title 'Rename-OSMedia: Select one or more OSMedia to Rename and press OK'
        foreach ($Item in $RenameOSMedia){
            Write-Warning "Renaming $($Item.FullName) to $($Item.FullNameFormat)"
            Rename-Item -Path "$($Item.FullName)" -NewName "$($Item.FullNameFormat)" -Force
        }
    }

    END {
        #Write-Host '========================================================================================' -ForegroundColor DarkGray
        #Write-Host "$($MyInvocation.MyCommand.Name) END"
    }
}
function Repair-OSBuildTask {
    [CmdletBinding()]
    param ()
    BEGIN {
        #=================================================
        #   Header
        #=================================================
        #   Write-Host '========================================================================================' -ForegroundColor DarkGray
        #   Write-Host -ForegroundColor Green "$($MyInvocation.MyCommand.Name) BEGIN"
        #=================================================
        #   Get-OSDBuilder
        #=================================================
        Get-OSDBuilder -CreatePaths -HideDetails
        #=================================================
        Write-Verbose '19.1.6 Gather All OSBuildTask'
        #=================================================
        $OSBuildTask = @()
        $OSBuildTask = Get-OSBuildTask | Where-Object {$null -eq $_.OSMGuid}
    }
    
    PROCESS {
        #Write-Host '========================================================================================' -ForegroundColor DarkGray
        Write-Host "$($MyInvocation.MyCommand.Name) PROCESS"

        foreach ($Item in $OSBuildTask) {
            $TaskFile = Get-Item -Path "$($Item.FullName)" | Select-Object -Property *
            Write-Warning "Repair Required: $($Item.FullName)"

            #=================================================
            Write-Verbose 'Read Task'
            #=================================================
            $Task = @()
            $Task = Get-Content "$($Item.FullName)" | ConvertFrom-Json

            if ([System.Version]$Task.TaskVersion -gt [System.Version]"19.1.3.0") {
                Write-Warning "Error: OSBuild Task does not need a Repair . . . Exiting!"
                Return
            }
    
            Write-Host "Select the OSMedia that will be used with this OSBuild Task"
            Write-Host "Previous OSMedia: $($Task.MediaName)"
            $OSMedia = Get-OSMedia

            if ($Task.MediaName -like "*x64*") {$OSMedia = $OSMedia | Where-Object {$_.Arch -eq 'x64'}}
            if ($Task.MediaName -like "*x86*") {$OSMedia = $OSMedia | Where-Object {$_.Arch -eq 'x86'}}
            if ($Task.MediaName -like "*1511*") {$OSMedia = $OSMedia | Where-Object {$_.ReleaseId -eq '1511'}}
            if ($Task.MediaName -like "*1607*") {$OSMedia = $OSMedia | Where-Object {$_.ReleaseId -eq '1607'}}
            if ($Task.MediaName -like "*1703*") {$OSMedia = $OSMedia | Where-Object {$_.ReleaseId -eq '1703'}}
            if ($Task.MediaName -like "*1709*") {$OSMedia = $OSMedia | Where-Object {$_.ReleaseId -eq '1709'}}
            if ($Task.MediaName -like "*1803*") {$OSMedia = $OSMedia | Where-Object {$_.ReleaseId -eq '1803'}}
            if ($Task.MediaName -like "*1809*") {$OSMedia = $OSMedia | Where-Object {$_.ReleaseId -eq '1809'}}
            
            $OSMedia = $OSMedia | Out-GridView -OutputMode Single -Title "$($Task.TaskName): Select the OSMedia used with this OSBuild Task"
    
            if ($null -eq $OSMedia) {
                Write-Warning "Error: OSMedia was not selected . . . Exiting!"
                Return
            }

            Write-Host "Selected $($OSMedia.Name)"

            #=================================================
            Write-Verbose '19.1.5 Create OSBuild Task'
            #=================================================
            $NewTask = [ordered]@{
                "TaskType" = [string]"OSBuild";
                "TaskName" = [string]$Task.TaskName;
                "TaskVersion" = [string]$global:GetOSDBuilder.VersionOSDBuilder;
                "TaskGuid" = [string]$(New-Guid);
                "CustomName" = [string]$Task.BuildName;
    
                "OSMFamily" = [string]$OSMedia.OSMFamily;
                "OSMGuid" = [string]$OSMedia.OSMGuid;
                "Name" = [string]$OSMedia.Name;
                "ImageName" = [string]$OSMedia.ImageName;
                "Arch" = [string]$OSMedia.Arch;
                "ReleaseId" = [string]$($OSMedia.ReleaseId);
                "UBR" = [string]$OSMedia.UBR;
                "EditionId" = [string]$OSMedia.EditionId;
                "InstallationType" = [string]$OSMedia.InstallationType;
                "MajorVersion" = [string]$OSMedia.MajorVersion;
                "Build" = [string]$OSMedia.Build;
                "CreatedTime" = [datetime]$OSMedia.CreatedTime;
                "ModifiedTime" = [datetime]$OSMedia.ModifiedTime;
    
                "EnableNetFX3" = [string]$Task.EnableNetFX3;
                "StartLayoutXML" = [string]$Task.ImportStartLayout;
                "UnattendXML" = [string]$Task.UseWindowsUnattend;
                "WinPEAutoExtraFiles" = [string]"False";
                "WinPEDaRT" = [string]$Task.WinPEAddDaRT;

                "ExtraFiles" = [string[]]$Task.RobocopyExtraFiles;
                "Scripts" = [string[]]$Task.InvokeScript;
                "Drivers" = [string[]]$Task.AddWindowsDriver;
    
                "AddWindowsPackage" = [string[]]$Task.AddWindowsPackage;
                "RemoveWindowsPackage" = [string[]]$Task.RemoveWindowsPackage;
                "AddFeatureOnDemand" = [string[]]$Task.AddFeatureOnDemand;
                "EnableWindowsOptionalFeature" = [string[]]$Task.EnableWindowsOptionalFeature;
                "DisableWindowsOptionalFeature" = [string[]]$Task.DisableWindowsOptionalFeature;
                "RemoveAppxProvisionedPackage" = [string[]]$Task.RemoveAppxProvisionedPackage;
                "RemoveWindowsCapability" = [string[]]$Task.RemoveWindowsCapability;
    
                "WinPEDrivers" = [string[]]$Task.WinPEAddWindowsDriver;
                "WinPEScriptsPE" = [string[]]$Task.WinPEInvokeScriptPE;
                "WinPEScriptsRE" = [string[]]$Task.WinPEInvokeScriptRE;
                "WinPEScriptsSE" = [string[]]$Task.WinPEInvokeScriptSetup;
                "WinPEExtraFilesPE" = [string[]]$Task.WinPERobocopyExtraFilesPE;
                "WinPEExtraFilesRE" = [string[]]$Task.WinPERobocopyExtraFilesRE;
                "WinPEExtraFilesSE" = [string[]]$Task.WinPERobocopyExtraFilesSetup;
                "WinPEADKPE" = [string[]]$Task.WinPEAddADKPE;
                "WinPEADKRE" = [string[]]$Task.WinPEAddADKRE;
                "WinPEADKSE" = [string[]]$Task.WinPEAddADKSetup;
    
                "LangSetAllIntl" = [string]$Task.LangSetAllIntl;
                "LangSetInputLocale" = [string]$Task.LangSetInputLocale;
                "LangSetSKUIntlDefaults" = [string]$Task.LangSetSKUIntlDefaults;
                "LangSetSetupUILang" = [string]$Task.LangSetSetupUILang;
                "LangSetSysLocale" = [string]$Task.LangSetSysLocale;
                "LangSetUILang" = [string]$Task.LangSetUILang;
                "LangSetUILangFallback" = [string]$Task.LangSetUILangFallback;
                "LangSetUserLocale" = [string]$Task.LangSetUserLocale;
                "LanguageFeature" = [string[]]$Task.AddLanguageFeature;
                "LanguageInterfacePack" = [string[]]$Task.AddLanguageInterfacePack;
                "LanguagePack" = [string[]]$Task.AddLanguagePack;
            }
			
            #=================================================
            Write-Verbose '19.1.7 Create Backup'
            #=================================================
            if (!(Test-Path "$($TaskFile.Directory)\Repair")) {
                New-Item -Path "$($TaskFile.Directory)\Repair"-ItemType Directory -Force | Out-Null
            }

            if (!(Test-Path "$($TaskFile.Directory)\Repair\$($TaskFile.Name)")) {
                Write-Host "Creating Backup $($TaskFile.Directory)\Repair\$($TaskFile.Name)"
                Copy-Item -Path "$($TaskFile.FullName)" -Destination "$($TaskFile.Directory)\Repair\$($TaskFile.Name)" -Force
            }
    
            #=================================================
            Write-Verbose '19.1.1 New-OSBuildTask Complete'
            #=================================================
            $NewTask | ConvertTo-Json | Out-File "$($Item.FullName)" -Encoding ascii
            Write-Host "Update Complete: $($Task.TaskName)"
            Write-Host '========================================================================================' -ForegroundColor DarkGray
        }
    }

    END {
        #Write-Host '========================================================================================' -ForegroundColor DarkGray
        #Write-Host "$($MyInvocation.MyCommand.Name) END"
    }
}
function Repair-PEBuildTask {
    [CmdletBinding()]
    param ()
    Begin {
        #=================================================
        #   Header
        #=================================================
        #   Write-Host '========================================================================================' -ForegroundColor DarkGray
        #   Write-Host -ForegroundColor Green "$($MyInvocation.MyCommand.Name) BEGIN"
        #=================================================
        #   Get-OSDBuilder
        #=================================================
        Get-OSDBuilder -CreatePaths -HideDetails
        #=================================================
        Write-Verbose '19.1.6 Gather All PEBuildTask'
        #=================================================
        $PEBuildTask = @()
        $PEBuildTask = Get-PEBuildTask | Where-Object {$null -eq $_.OSMGuid}
    }
    
    PROCESS {
        #Write-Host '========================================================================================' -ForegroundColor DarkGray
        Write-Host "$($MyInvocation.MyCommand.Name) PROCESS"

        foreach ($Item in $PEBuildTask) {
            $TaskFile = Get-Item -Path "$($Item.FullName)" | Select-Object -Property *
            Write-Warning "Repair Required: $($Item.FullName)"

            #=================================================
            Write-Verbose 'Read Task'
            #=================================================
            $Task = @()
            $Task = Get-Content "$($Item.FullName)" | ConvertFrom-Json

            if ([System.Version]$Task.TaskVersion -gt [System.Version]"19.1.3.0") {
                Write-Warning "Error: PEBuild Task does not need a Repair . . . Exiting!"
                Return
            }
    
            Write-Host "Select the OSMedia that will be used with this PEBuild Task"
            Write-Host "Previous OSMedia: $($Task.MediaName)"
            $OSMedia = Get-OSMedia
            
            if ($Task.MediaName -like "*x64*") {$OSMedia = $OSMedia | Where-Object {$_.Arch -eq 'x64'}}
            if ($Task.MediaName -like "*x86*") {$OSMedia = $OSMedia | Where-Object {$_.Arch -eq 'x86'}}
            if ($Task.MediaName -like "*1511*") {$OSMedia = $OSMedia | Where-Object {$_.ReleaseId -eq '1511'}}
            if ($Task.MediaName -like "*1607*") {$OSMedia = $OSMedia | Where-Object {$_.ReleaseId -eq '1607'}}
            if ($Task.MediaName -like "*1703*") {$OSMedia = $OSMedia | Where-Object {$_.ReleaseId -eq '1703'}}
            if ($Task.MediaName -like "*1709*") {$OSMedia = $OSMedia | Where-Object {$_.ReleaseId -eq '1709'}}
            if ($Task.MediaName -like "*1803*") {$OSMedia = $OSMedia | Where-Object {$_.ReleaseId -eq '1803'}}
            if ($Task.MediaName -like "*1809*") {$OSMedia = $OSMedia | Where-Object {$_.ReleaseId -eq '1809'}}

            $OSMedia = $OSMedia | Out-GridView -OutputMode Single -Title "$($Task.TaskName): Select the OSMedia used with this PEBuild Task"
    
            if ($null -eq $OSMedia) {
                Write-Warning "Error: OSMedia was not selected . . . Exiting!"
                Return
            }

            Write-Host "Selected $($OSMedia.Name)"

            #=================================================
            Write-Verbose '19.1.5 Create PEBuild Task'
            #=================================================
            $NewTask = [ordered]@{
                "TaskType" = 'PEBuild'
                "TaskName" = [string]$Task.TaskName;
                "TaskVersion" = [string]$global:GetOSDBuilder.VersionOSDBuilder;
                "TaskGuid" = [string]$(New-Guid);
    
                "OSMFamily" = [string]$OSMedia.OSMFamily;
                "OSMGuid" = [string]$OSMedia.OSMGuid;
                "Name" = [string]$OSMedia.Name;
                "ImageName" = [string]$OSMedia.ImageName;
                "Arch" = [string]$OSMedia.Arch;
                "ReleaseId" = [string]$($OSMedia.ReleaseId);
                "UBR" = [string]$OSMedia.UBR;
                "EditionId" = [string]$OSMedia.EditionId;
                "InstallationType" = [string]$OSMedia.InstallationType;
                "MajorVersion" = [string]$OSMedia.MajorVersion;
                "Build" = [string]$OSMedia.Build;
                "CreatedTime" = [datetime]$OSMedia.CreatedTime;
                "ModifiedTime" = [datetime]$OSMedia.ModifiedTime;

                "WinPEOutput" = [string]$Task.PEOutput;
                "CustomName" = [string]'';
                "MDTDeploymentShare" = [string]$Task.DeploymentShare;
                "ScratchSpace" = [string]$Task.ScratchSpace;
                "SourceWim" = [string]$Task.SourceWim;
                "WinPEAutoExtraFiles" = [string]$Task.AutoExtraFiles;
                "WinPEDaRT" = [string]$Task.WinPEAddDaRT;
                "WinPEDrivers" = [string[]]$Task.WinPEAddWindowsDriver;
                "WinPEExtraFiles" = [string[]]$Task.WinPERobocopyExtraFiles;
                "WinPEScripts" = [string[]]$Task.WinPEInvokeScript;
                "WinPEADK" = [string[]]$Task.WinPEAddADK;
            }
    
            #=================================================
            Write-Verbose '19.1.7 Create Backup'
            #=================================================
            if (!(Test-Path "$($TaskFile.Directory)\Repair")) {
                New-Item -Path "$($TaskFile.Directory)\Repair"-ItemType Directory -Force | Out-Null
            }

            if (!(Test-Path "$($TaskFile.Directory)\Repair\$($TaskFile.Name)")) {
                Write-Host "Creating Backup $($TaskFile.Directory)\Repair\$($TaskFile.Name)"
                Copy-Item -Path "$($TaskFile.FullName)" -Destination "$($TaskFile.Directory)\Repair\$($TaskFile.Name)" -Force
            }
            
            #=================================================
            Write-Verbose '19.1.7 New-PEBuildTask Complete'
            #=================================================
            $NewTask | ConvertTo-Json | Out-File "$($Item.FullName)" -Encoding ascii
            Write-Host "Update Complete: $($Task.TaskName)"
            Write-Host '========================================================================================' -ForegroundColor DarkGray
        }
    }

    END {
        #Write-Host '========================================================================================' -ForegroundColor DarkGray
        #Write-Host "$($MyInvocation.MyCommand.Name) END"
    }
}
function Save-AutoExtraFilesOS {
    [CmdletBinding()]
    param (
        [string]$OSMediaPath
    )
    #=================================================
    #   Header
    #=================================================
    Show-ActionTime
    Write-Host -ForegroundColor Green "OS: Backup Auto Extra Files to $OSMediaPath\WinPE\AutoExtraFiles"
    #=================================================
    #   Execute
    #=================================================
    $AEFLog = "$OSMediaPath\info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Save-AutoExtraFilesOS.log"
    Write-Verbose "$AEFLog"

    robocopy "$MountDirectory\Windows\System32" "$OSMediaPath\WinPE\AutoExtraFiles\Windows\System32" cacls.exe* /s /xd rescache servicing /ndl /b /np /ts /tee /r:0 /w:0 /log+:"$AEFLog" | Out-Null
    robocopy "$MountDirectory\Windows\System32" "$OSMediaPath\WinPE\AutoExtraFiles\Windows\System32" choice.exe* /s /xd rescache servicing /ndl /b /np /ts /tee /r:0 /w:0 /log+:"$AEFLog" | Out-Null
    #robocopy "$MountDirectory\Windows\System32" "$OSMediaPath\WinPE\AutoExtraFiles\Windows\System32" cleanmgr.exe* /s /xd rescache servicing /ndl /b /np /ts /tee /r:0 /w:0 /log+:"$AEFLog" | Out-Null
    robocopy "$MountDirectory\Windows\System32" "$OSMediaPath\WinPE\AutoExtraFiles\Windows\System32" comp.exe*.* /s /xd rescache servicing /ndl /b /np /ts /tee /r:0 /w:0 /log+:"$AEFLog" | Out-Null
    robocopy "$MountDirectory\Windows\System32" "$OSMediaPath\WinPE\AutoExtraFiles\Windows\System32" curl.exe /xd rescache servicing /ndl /b /np /ts /tee /r:0 /w:0 /log+:"$AEFLog" | Out-Null
    robocopy "$MountDirectory\Windows\System32" "$OSMediaPath\WinPE\AutoExtraFiles\Windows\System32" defrag*.* /s /xd rescache servicing /ndl /b /np /ts /tee /r:0 /w:0 /log+:"$AEFLog" | Out-Null
    robocopy "$MountDirectory\Windows\System32" "$OSMediaPath\WinPE\AutoExtraFiles\Windows\System32" djoin*.* /s /xd rescache servicing /ndl /b /np /ts /tee /r:0 /w:0 /log+:"$AEFLog" | Out-Null
    robocopy "$MountDirectory\Windows\System32" "$OSMediaPath\WinPE\AutoExtraFiles\Windows\System32" forfiles*.* /s /xd rescache servicing /ndl /b /np /ts /tee /r:0 /w:0 /log+:"$AEFLog" | Out-Null
    robocopy "$MountDirectory\Windows\System32" "$OSMediaPath\WinPE\AutoExtraFiles\Windows\System32" getmac*.* /s /xd rescache servicing /ndl /b /np /ts /tee /r:0 /w:0 /log+:"$AEFLog" | Out-Null
    robocopy "$MountDirectory\Windows\System32" "$OSMediaPath\WinPE\AutoExtraFiles\Windows\System32" makecab.* /s /xd rescache servicing /ndl /b /np /ts /tee /r:0 /w:0 /log+:"$AEFLog" | Out-Null
    robocopy "$MountDirectory\Windows\System32" "$OSMediaPath\WinPE\AutoExtraFiles\Windows\System32" msinfo32.* /s /xd rescache servicing /ndl /b /np /ts /tee /r:0 /w:0 /log+:"$AEFLog" | Out-Null
    robocopy "$MountDirectory\Windows\System32" "$OSMediaPath\WinPE\AutoExtraFiles\Windows\System32" nslookup.* /s /xd rescache servicing /ndl /b /np /ts /tee /r:0 /w:0 /log+:"$AEFLog" | Out-Null
    robocopy "$MountDirectory\Windows\System32" "$OSMediaPath\WinPE\AutoExtraFiles\Windows\System32" setx.* /s /xd rescache servicing /ndl /b /np /ts /tee /r:0 /w:0 /log+:"$AEFLog" | Out-Null
    robocopy "$MountDirectory\Windows\System32" "$OSMediaPath\WinPE\AutoExtraFiles\Windows\System32" systeminfo.* /s /xd rescache servicing /ndl /b /np /ts /tee /r:0 /w:0 /log+:"$AEFLog" | Out-Null
    robocopy "$MountDirectory\Windows\System32" "$OSMediaPath\WinPE\AutoExtraFiles\Windows\System32" tskill.* /s /xd rescache servicing /ndl /b /np /ts /tee /r:0 /w:0 /log+:"$AEFLog" | Out-Null
    robocopy "$MountDirectory\Windows\System32" "$OSMediaPath\WinPE\AutoExtraFiles\Windows\System32" winver.* /s /xd rescache servicing /ndl /b /np /ts /tee /r:0 /w:0 /log+:"$AEFLog" | Out-Null
    robocopy "$MountDirectory\Windows\System32" "$OSMediaPath\WinPE\AutoExtraFiles\Windows\System32" tar.exe /xd rescache servicing /ndl /b /np /ts /tee /r:0 /w:0 /log+:"$AEFLog" | Out-Null
   
    #AeroLite Theme
    robocopy "$MountDirectory\Windows\Resources" "$OSMediaPath\WinPE\AutoExtraFiles\Windows\Resources" aerolite*.* /s /ndl /b /np /ts /tee /r:0 /w:0 /log+:"$AEFLog" | Out-Null
    robocopy "$MountDirectory\Windows\Resources" "$OSMediaPath\WinPE\AutoExtraFiles\Windows\Resources" shellstyle*.* /s /ndl /b /np /ts /tee /r:0 /w:0 /log+:"$AEFLog" | Out-Null
    
    # BCP47
    robocopy "$MountDirectory\Windows\System32" "$OSMediaPath\WinPE\AutoExtraFiles\Windows\System32" bcp47*.dll /s /xd rescache servicing /ndl /b /np /ts /tee /r:0 /w:0 /log+:"$AEFLog" | Out-Null
    
    # Browse Dialog
    robocopy "$MountDirectory\Windows\Resources\Themes\aero\shell\normalcolor" "$OSMediaPath\WinPE\AutoExtraFiles\Windows\System32" shellstyle*.* /s /ndl /b /np /ts /tee /r:0 /w:0 /log+:"$AEFLog" | Out-Null
    robocopy "$MountDirectory\Windows\System32" "$OSMediaPath\WinPE\AutoExtraFiles\Windows\System32" explorerframe*.* /s /xd rescache servicing /ndl /b /np /ts /tee /r:0 /w:0 /log+:"$AEFLog" | Out-Null
    robocopy "$MountDirectory\Windows\System32" "$OSMediaPath\WinPE\AutoExtraFiles\Windows\System32" StructuredQuery*.* /s /xd rescache servicing /ndl /b /np /ts /tee /r:0 /w:0 /log+:"$AEFLog" | Out-Null
    robocopy "$MountDirectory\Windows\System32" "$OSMediaPath\WinPE\AutoExtraFiles\Windows\System32" edputil*.* /s /xd rescache servicing /ndl /b /np /ts /tee /r:0 /w:0 /log+:"$AEFLog" | Out-Null

    # Magnify
    robocopy "$MountDirectory\Windows\System32" "$OSMediaPath\WinPE\AutoExtraFiles\Windows\System32" magnify*.* /s /xd rescache servicing /ndl /b /np /ts /tee /r:0 /w:0 /log+:"$AEFLog" | Out-Null
    robocopy "$MountDirectory\Windows\System32" "$OSMediaPath\WinPE\AutoExtraFiles\Windows\System32" magnification*.* /s /xd rescache servicing /ndl /b /np /ts /tee /r:0 /w:0 /log+:"$AEFLog" | Out-Null
    
    # On Screen Keyboard
    robocopy "$MountDirectory\Windows\System32" "$OSMediaPath\WinPE\AutoExtraFiles\Windows\System32" osk*.* /s /xd rescache servicing /ndl /b /np /ts /tee /r:0 /w:0 /log+:"$AEFLog" | Out-Null
    
    # RDP
    robocopy "$MountDirectory\Windows\System32" "$OSMediaPath\WinPE\AutoExtraFiles\Windows\System32" mstsc*.* /s /xd rescache servicing /ndl /b /np /ts /tee /r:0 /w:0 /log+:"$AEFLog" | Out-Null
    robocopy "$MountDirectory\Windows\System32" "$OSMediaPath\WinPE\AutoExtraFiles\Windows\System32" pdh.dll* /s /xd rescache servicing /ndl /b /np /ts /tee /r:0 /w:0 /log+:"$AEFLog" | Out-Null
    robocopy "$MountDirectory\Windows\System32" "$OSMediaPath\WinPE\AutoExtraFiles\Windows\System32" srpapi.dll* /s /xd rescache servicing /ndl /b /np /ts /tee /r:0 /w:0 /log+:"$AEFLog" | Out-Null
    
    # Shutdown
    robocopy "$MountDirectory\Windows\System32" "$OSMediaPath\WinPE\AutoExtraFiles\Windows\System32" shutdown.* /s /xd rescache servicing /ndl /b /np /ts /tee /r:0 /w:0 /log+:"$AEFLog" | Out-Null
    robocopy "$MountDirectory\Windows\System32" "$OSMediaPath\WinPE\AutoExtraFiles\Windows\System32" shutdownext.* /s /xd rescache servicing /ndl /b /np /ts /tee /r:0 /w:0 /log+:"$AEFLog" | Out-Null
    robocopy "$MountDirectory\Windows\System32" "$OSMediaPath\WinPE\AutoExtraFiles\Windows\System32" shutdownux.* /s /xd rescache servicing /ndl /b /np /ts /tee /r:0 /w:0 /log+:"$AEFLog" | Out-Null

    # Wireless
    # http://www.scconfigmgr.com/2018/03/06/build-a-winpe-with-wireless-support/
    robocopy "$MountDirectory\Windows\System32" "$OSMediaPath\WinPE\AutoExtraFiles\Windows\System32" dmcmnutils*.* /s /xd rescache servicing /ndl /b /np /ts /tee /r:0 /w:0 /log+:"$AEFLog" | Out-Null
    robocopy "$MountDirectory\Windows\System32" "$OSMediaPath\WinPE\AutoExtraFiles\Windows\System32" mdmpostprocessevaluator*.* /s /xd rescache servicing /ndl /b /np /ts /tee /r:0 /w:0 /log+:"$AEFLog" | Out-Null
    robocopy "$MountDirectory\Windows\System32" "$OSMediaPath\WinPE\AutoExtraFiles\Windows\System32" mdmregistration*.* /s /xd rescache servicing /ndl /b /np /ts /tee /r:0 /w:0 /log+:"$AEFLog" | Out-Null
}
function Save-InventoryOS {
    [CmdletBinding()]
    param (
        [string]$OSMediaPath
    )
    #=================================================
    #   Header
    #=================================================
    Show-ActionTime
    Write-Host -ForegroundColor Green "OS: Export Inventory to $OSMediaPath"
    #=================================================
    #   Execute
    #=================================================
    Write-Verbose 'Save-InventoryOS'
    Write-Verbose "OSMediaPath: $OSMediaPath"

    $GetAppxProvisionedPackage = @()
    TRY {
        Write-Verbose "$OSMediaPath\AppxProvisionedPackage.txt"
        $GetAppxProvisionedPackage = Get-AppxProvisionedPackage -Path "$MountDirectory"
        $GetAppxProvisionedPackage | Out-File "$OSMediaPath\info\Get-AppxProvisionedPackage.txt"
        $GetAppxProvisionedPackage | Out-File "$OSMediaPath\AppxProvisionedPackage.txt"
        $GetAppxProvisionedPackage | Out-File "$OSMediaPath\info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-AppxProvisionedPackage.txt"
        $GetAppxProvisionedPackage | Export-Clixml -Path "$OSMediaPath\info\xml\Get-AppxProvisionedPackage.xml"
        $GetAppxProvisionedPackage | Export-Clixml -Path "$OSMediaPath\info\xml\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-AppxProvisionedPackage.xml"
        $GetAppxProvisionedPackage | ConvertTo-Json | Out-File "$OSMediaPath\info\json\Get-AppxProvisionedPackage.json"
        $GetAppxProvisionedPackage | ConvertTo-Json | Out-File "$OSMediaPath\info\json\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-AppxProvisionedPackage.json"
    }
    CATCH {Write-Warning "Get-AppxProvisionedPackage is not supported by this Operating System"}

    $GetWindowsOptionalFeature = @()
    TRY {
        Write-Verbose "$OSMediaPath\WindowsOptionalFeature.txt"
        $GetWindowsOptionalFeature = Get-WindowsOptionalFeature -Path "$MountDirectory"
        $GetWindowsOptionalFeature | Out-File "$OSMediaPath\info\Get-WindowsOptionalFeature.txt"
        $GetWindowsOptionalFeature | Out-File "$OSMediaPath\WindowsOptionalFeature.txt"
        $GetWindowsOptionalFeature | Out-File "$OSMediaPath\info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsOptionalFeature.txt"
        $GetWindowsOptionalFeature | Export-Clixml -Path "$OSMediaPath\info\xml\Get-WindowsOptionalFeature.xml"
        $GetWindowsOptionalFeature | Export-Clixml -Path "$OSMediaPath\info\xml\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsOptionalFeature.xml"
        $GetWindowsOptionalFeature | ConvertTo-Json | Out-File "$OSMediaPath\info\json\Get-WindowsOptionalFeature.json"
        $GetWindowsOptionalFeature | ConvertTo-Json | Out-File "$OSMediaPath\info\json\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsOptionalFeature.json"
    }
    CATCH {Write-Warning "Get-WindowsOptionalFeature is not supported by this Operating System"}

    $GetWindowsCapability = @()
    TRY {
        Write-Verbose "$OSMediaPath\WindowsCapability.txt"
        $GetWindowsCapability = Get-WindowsCapability -Path "$MountDirectory"
        $GetWindowsCapability | Out-File "$OSMediaPath\info\Get-WindowsCapability.txt"
        $GetWindowsCapability | Out-File "$OSMediaPath\WindowsCapability.txt"
        $GetWindowsCapability | Out-File "$OSMediaPath\info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsCapability.txt"
        $GetWindowsCapability | Export-Clixml -Path "$OSMediaPath\info\xml\Get-WindowsCapability.xml"
        $GetWindowsCapability | Export-Clixml -Path "$OSMediaPath\info\xml\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsCapability.xml"
        $GetWindowsCapability | ConvertTo-Json | Out-File "$OSMediaPath\info\json\Get-WindowsCapability.json"
        $GetWindowsCapability | ConvertTo-Json | Out-File "$OSMediaPath\info\json\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsCapability.json"            
    }
    CATCH {Write-Warning "Get-WindowsCapability is not supported by this Operating System"}

    $GetWindowsPackage = @()
    TRY {
        Write-Verbose "$OSMediaPath\WindowsPackage.txt"
        $GetWindowsPackage = Get-WindowsPackage -Path "$MountDirectory"
        $GetWindowsPackage | Out-File "$OSMediaPath\info\Get-WindowsPackage.txt"
        $GetWindowsPackage | Out-File "$OSMediaPath\WindowsPackage.txt"
        $GetWindowsPackage | Out-File "$OSMediaPath\info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsPackage.txt"
        $GetWindowsPackage | Export-Clixml -Path "$OSMediaPath\info\xml\Get-WindowsPackage.xml"
        $GetWindowsPackage | Export-Clixml -Path "$OSMediaPath\info\xml\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsPackage.xml"
        $GetWindowsPackage | ConvertTo-Json | Out-File "$OSMediaPath\info\json\Get-WindowsPackage.json"
        $GetWindowsPackage | ConvertTo-Json | Out-File "$OSMediaPath\info\json\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsPackage.json"
    }
    CATCH {Write-Warning "Get-WindowsPackage is not supported by this Operating System"}
}
function Save-InventoryPE {
    [CmdletBinding()]
    param (
        [string]$OSMediaPath
    )
    #=================================================
    #   Header
    #=================================================
    Show-ActionTime
    Write-Host -ForegroundColor Green "WinPE: Export WIM Inventory to $OSMediaPath\WinPE\info"
    #=================================================
    $GetWindowsImage = @()
    Write-Verbose "$OSMediaPath\WinPE\info\Get-WindowsImage-Boot.txt"
    $GetWindowsImage = Get-WindowsImage -ImagePath "$OSMediaPath\WinPE\boot.wim"
    $GetWindowsImage | Out-File "$OSMediaPath\WinPE\info\Get-WindowsImage-Boot.txt"
    (Get-Content "$OSMediaPath\WinPE\info\Get-WindowsImage-Boot.txt") | Where-Object {$_.Trim(" `t")} | Set-Content "$OSMediaPath\WinPE\info\Get-WindowsImage-Boot.txt"
    $GetWindowsImage | Out-File "$OSMediaPath\WinPE\info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsImage-Boot.txt"
    $GetWindowsImage | Export-Clixml -Path "$OSMediaPath\WinPE\info\xml\Get-WindowsImage-Boot.xml"
    $GetWindowsImage | Export-Clixml -Path "$OSMediaPath\WinPE\info\xml\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsImage-Boot.xml"
    $GetWindowsImage | ConvertTo-Json | Out-File "$OSMediaPath\WinPE\info\json\Get-WindowsImage-Boot.json"
    $GetWindowsImage | ConvertTo-Json | Out-File "$OSMediaPath\WinPE\info\json\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsImage-Boot.json"

    #=================================================
    Write-Verbose 'Get-WindowsImage WinPE'
    #=================================================
    $GetWindowsImage = @()
    Write-Verbose "$OSMediaPath\WinPE\info\Get-WindowsImage-WinPE.txt"
    $GetWindowsImage = Get-WindowsImage -ImagePath "$OSMediaPath\WinPE\winpe.wim" -Index 1 | Select-Object -Property *
    $GetWindowsImage | Out-File "$OSMediaPath\WinPE\info\Get-WindowsImage-WinPE.txt"
    (Get-Content "$OSMediaPath\WinPE\info\Get-WindowsImage-WinPE.txt") | Where-Object {$_.Trim(" `t")} | Set-Content "$OSMediaPath\WinPE\info\Get-WindowsImage-WinPE.txt"
    $GetWindowsImage | Out-File "$OSMediaPath\WinPE\info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsImage-WinPE.txt"
    $GetWindowsImage | Export-Clixml -Path "$OSMediaPath\WinPE\info\xml\Get-WindowsImage-WinPE.xml"
    $GetWindowsImage | Export-Clixml -Path "$OSMediaPath\WinPE\info\xml\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsImage-WinPE.xml"
    $GetWindowsImage | ConvertTo-Json | Out-File "$OSMediaPath\WinPE\info\json\Get-WindowsImage-WinPE.json"
    $GetWindowsImage | ConvertTo-Json | Out-File "$OSMediaPath\WinPE\info\json\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsImage-WinPE.json"

    #=================================================
    Write-Verbose 'Get-WindowsImage WinRE'
    #=================================================
    $GetWindowsImage = @()
    Write-Verbose "$OSMediaPath\WinPE\info\Get-WindowsImage-WinRE.txt"
    $GetWindowsImage = Get-WindowsImage -ImagePath "$OSMediaPath\WinPE\winre.wim" -Index 1 | Select-Object -Property *
    $GetWindowsImage | Out-File "$OSMediaPath\WinPE\info\Get-WindowsImage-WinRE.txt"
    (Get-Content "$OSMediaPath\WinPE\info\Get-WindowsImage-WinRE.txt") | Where-Object {$_.Trim(" `t")} | Set-Content "$OSMediaPath\WinPE\info\Get-WindowsImage-WinRE.txt"
    $GetWindowsImage | Out-File "$OSMediaPath\WinPE\info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsImage-WinRE.txt"
    $GetWindowsImage | Export-Clixml -Path "$OSMediaPath\WinPE\info\xml\Get-WindowsImage-WinRE.xml"
    $GetWindowsImage | Export-Clixml -Path "$OSMediaPath\WinPE\info\xml\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsImage-WinRE.xml"
    $GetWindowsImage | ConvertTo-Json | Out-File "$OSMediaPath\WinPE\info\json\Get-WindowsImage-WinRE.json"
    $GetWindowsImage | ConvertTo-Json | Out-File "$OSMediaPath\WinPE\info\json\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsImage-WinRE.json"

    #=================================================
    Write-Verbose 'Get-WindowsImage Setup'
    #=================================================
    $GetWindowsImage = @()
    Write-Verbose "$OSMediaPath\WinPE\info\Get-WindowsImage-WinSE.txt"
    $GetWindowsImage = Get-WindowsImage -ImagePath "$OSMediaPath\WinPE\winse.wim" -Index 1 | Select-Object -Property *
    $GetWindowsImage | Out-File "$OSMediaPath\WinPE\info\Get-WindowsImage-WinSE.txt"
    (Get-Content "$OSMediaPath\WinPE\info\Get-WindowsImage-WinSE.txt") | Where-Object {$_.Trim(" `t")} | Set-Content "$OSMediaPath\WinPE\info\Get-WindowsImage-WinSE.txt"
    $GetWindowsImage | Out-File "$OSMediaPath\WinPE\info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsImage-WinSE.txt"
    $GetWindowsImage | Export-Clixml -Path "$OSMediaPath\WinPE\info\xml\Get-WindowsImage-WinSE.xml"
    $GetWindowsImage | Export-Clixml -Path "$OSMediaPath\WinPE\info\xml\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsImage-WinSE.xml"
    $GetWindowsImage | ConvertTo-Json | Out-File "$OSMediaPath\WinPE\info\json\Get-WindowsImage-WinSE.json"
    $GetWindowsImage | ConvertTo-Json | Out-File "$OSMediaPath\WinPE\info\json\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsImage-WinSE.json"
}
function Save-OSMediaVariables {
    [CmdletBinding()]
    param ()
    Get-Variable | Select-Object -Property Name, Value | Export-Clixml "$OSMediaPathInfo\xml\Variables.xml"
    Get-Variable | Where-Object { $_.Value -isnot [System.Collections.Hashtable] } | Select-Object -Property Name, Value | ConvertTo-Json | Out-File "$OSMediaPathInfo\json\Variables.json"
}
function Save-OSMediaWindowsImageContent {
    [CmdletBinding()]
    param ()
    #=================================================
    #   Header
    #=================================================
    Show-ActionTime; Write-Host -ForegroundColor Green "OS: Save Windows Image Content to $OSMediaPathInfo\Get-WindowsImageContent.txt"
    #=================================================
    #   Execute
    #=================================================
    Get-WindowsImageContent -ImagePath $OSMediaPathWindowsImage -Index 1 | Out-File "$OSMediaPathInfo\Get-WindowsImageContent.txt"
}
function Save-PackageInventoryPE {
    [CmdletBinding()]
    param (
        [string]$OSMediaPath
    )
    #=================================================
    #   Header
    #=================================================
    Show-ActionTime
    Write-Host -ForegroundColor Green "WinPE: Export WinPE Package Inventory to $OSMediaPath\WinPE\info"
    #=================================================
    $GetWindowsPackage = @()
    Write-Verbose "$OSMediaPath\WinPE\info\Get-WindowsPackage-WinPE.txt"
    $GetWindowsPackage = Get-WindowsPackage -Path "$MountWinPE"
    $GetWindowsPackage | Out-File "$OSMediaPath\WinPE\info\Get-WindowsPackage-WinPE.txt"
    $GetWindowsPackage | Out-File "$OSMediaPath\WinPE\info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsPackage-WinPE.txt"
    $GetWindowsPackage | Export-Clixml -Path "$OSMediaPath\WinPE\info\xml\Get-WindowsPackage-WinPE.xml"
    $GetWindowsPackage | Export-Clixml -Path "$OSMediaPath\WinPE\info\xml\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsPackage-WinPE.xml"
    $GetWindowsPackage | ConvertTo-Json | Out-File "$OSMediaPath\WinPE\info\json\Get-WindowsPackage-WinPE.json"
    $GetWindowsPackage | ConvertTo-Json | Out-File "$OSMediaPath\WinPE\info\json\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsPackage-WinPE.json"

    #=================================================
    Write-Verbose 'Get-WindowsPackage WinRE'
    #=================================================
    $GetWindowsPackage = @()
    Write-Verbose "$OSMediaPath\WinPE\info\Get-WindowsPackage-WinRE.txt"
    $GetWindowsPackage = Get-WindowsPackage -Path "$MountWinRE"
    $GetWindowsPackage | Out-File "$OSMediaPath\WinPE\info\Get-WindowsPackage-WinRE.txt"
    $GetWindowsPackage | Out-File "$OSMediaPath\WinPE\info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsPackage-WinRE.txt"
    $GetWindowsPackage | Export-Clixml -Path "$OSMediaPath\WinPE\info\xml\Get-WindowsPackage-WinRE.xml"
    $GetWindowsPackage | Export-Clixml -Path "$OSMediaPath\WinPE\info\xml\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsPackage-WinRE.xml"
    $GetWindowsPackage | ConvertTo-Json | Out-File "$OSMediaPath\WinPE\info\json\Get-WindowsPackage-WinRE.json"
    $GetWindowsPackage | ConvertTo-Json | Out-File "$OSMediaPath\WinPE\info\json\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsPackage-WinRE.json"

    #=================================================
    Write-Verbose 'Get-WindowsPackage WinSE'
    #=================================================
    $GetWindowsPackage = @()
    Write-Verbose "$OSMediaPath\WinPE\info\Get-WindowsPackage-WinSE.txt"
    $GetWindowsPackage = Get-WindowsPackage -Path "$MountWinSE"
    $GetWindowsPackage | Out-File "$OSMediaPath\WinPE\info\Get-WindowsPackage-WinSE.txt"
    $GetWindowsPackage | Out-File "$OSMediaPath\WinPE\info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsPackage-WinSE.txt"
    $GetWindowsPackage | Export-Clixml -Path "$OSMediaPath\WinPE\info\xml\Get-WindowsPackage-WinSE.xml"
    $GetWindowsPackage | Export-Clixml -Path "$OSMediaPath\WinPE\info\xml\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsPackage-WinSE.xml"
    $GetWindowsPackage | ConvertTo-Json | Out-File "$OSMediaPath\WinPE\info\json\Get-WindowsPackage-WinSE.json"
    $GetWindowsPackage | ConvertTo-Json | Out-File "$OSMediaPath\WinPE\info\json\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsPackage-WinSE.json"
}
function Save-RegistryCurrentVersionOS {
    [CmdletBinding()]
    param ()
    $RegKeyCurrentVersion | Out-File "$Info\CurrentVersion.txt"
    $RegKeyCurrentVersion | Out-File "$WorkingPath\CurrentVersion.txt"
    $RegKeyCurrentVersion | Out-File "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-CurrentVersion.txt"
    $RegKeyCurrentVersion | Export-Clixml -Path "$Info\xml\CurrentVersion.xml"
    $RegKeyCurrentVersion | Export-Clixml -Path "$Info\xml\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-CurrentVersion.xml"
    $RegKeyCurrentVersion | ConvertTo-Json | Out-File "$Info\json\CurrentVersion.json"
    $RegKeyCurrentVersion | ConvertTo-Json | Out-File "$Info\json\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-CurrentVersion.json"
}
function Save-SessionsXmlOS {
    [CmdletBinding()]
    param (
        [string]$OSMediaPath
    )
    #=================================================
    #   Header
    #=================================================
    Show-ActionTime
    Write-Host -ForegroundColor Green "OS: Exporting Sessions.xml Patch Inventory"

    if (Test-Path "$MountDirectory\Windows\Servicing\Sessions\Sessions.xml") {
        [xml]$SessionsXML = Get-Content -Path "$MountDirectory\Windows\Servicing\Sessions\Sessions.xml"

        $Sessions = $SessionsXML.SelectNodes('Sessions/Session') | ForEach-Object {
            New-Object -Type PSObject -Property @{
                Id = $_.Tasks.Phase.package.id
                KBNumber = $_.Tasks.Phase.package.name
                TargetState = $_.Tasks.Phase.package.targetState
                Client = $_.Client
                Complete = $_.Complete
                Status = $_.Status
            }
        }
        $Sessions = $Sessions | Where-Object {$_.Id -like "Package*"}
        $Sessions = $Sessions | Select-Object -Property Id, KBNumber, TargetState, Client, Status, Complete | Sort-Object Complete -Descending
        #=================================================
        #   Export Sessions
        #=================================================
        Write-Host -ForegroundColor DarkGray "                  Source:      $MountDirectory\Windows\Servicing\Sessions\Sessions.xml"
        Write-Host -ForegroundColor DarkGray "                  Destination: $OSMediaPath\info\Sessions.xml"
        Copy-Item "$MountDirectory\Windows\Servicing\Sessions\Sessions.xml" "$OSMediaPath\info\Sessions.xml" -Force | Out-Null

        Write-Host -ForegroundColor DarkGray "                  Export:      $OSMediaPath\Sessions.txt"
        $Sessions | Out-File "$OSMediaPath\Sessions.txt"
        $Sessions | Out-File "$OSMediaPath\info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Sessions.txt"

        Write-Host -ForegroundColor DarkGray "                  Export:      $OSMediaPath\info\xml\Sessions.xml"
        $Sessions | Export-Clixml -Path "$OSMediaPath\info\xml\Sessions.xml"
        $Sessions | Export-Clixml -Path "$OSMediaPath\info\xml\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Sessions.xml"

        Write-Host -ForegroundColor DarkGray "                  Export:      $OSMediaPath\info\json\Sessions.json"
        $Sessions | ConvertTo-Json | Out-File "$OSMediaPath\info\json\Sessions.json"
        $Sessions | ConvertTo-Json | Out-File "$OSMediaPath\info\json\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Sessions.json"
    }
    #=================================================
    #   Remove Old Version
    #=================================================
    if (Test-Path "$OSMediaPath\Sessions.xml") {
        Remove-Item "$OSMediaPath\Sessions.xml" -Force | Out-Null
    }
}
function Save-VariablesOSD {
    [CmdletBinding()]
    param ()
    Get-Variable | Select-Object -Property Name, Value | Export-Clixml "$Info\xml\Variables.xml"
    Get-Variable | Where-Object { $_.Value -isnot [System.Collections.Hashtable] } | Select-Object -Property Name, Value | ConvertTo-Json | Out-File "$Info\json\Variables.json"
}
function Save-WimsPE {
    [CmdletBinding()]
    param (
        [string]$OSMediaPath
    )
    #=================================================
    #   Header
    #=================================================
    Show-ActionTime
    Write-Host -ForegroundColor Green "WinPE: Export WIMs to $OSMediaPath\WinPE"
    #=================================================
    #   Execute
    #=================================================
    Write-Verbose "OSMediaPath: $OSMediaPath"

    Write-Verbose "$OSMediaPath\WinPE\boot.wim"
    Copy-Item -Path "$OSMediaPath\OS\sources\boot.wim" -Destination "$OSMediaPath\WinPE\boot.wim" -Force

    Write-Verbose "$OSMediaPath\WinPE\winpe.wim"
    $CurrentLog = "$OSMediaPath\WinPE\info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Export-WindowsImage-WinPE.log"
    Write-Verbose "CurrentLog: $CurrentLog"
    Export-WindowsImage -SourceImagePath "$OSMediaPath\OS\sources\boot.wim" -SourceIndex 1 -DestinationImagePath "$OSMediaPath\WinPE\winpe.wim" -LogPath "$CurrentLog" | Out-Null

    Write-Verbose "$OSMediaPath\WinPE\winre.wim"
    $CurrentLog = "$OSMediaPath\WinPE\info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Export-WindowsImage-WinRE.log"
    Write-Verbose "CurrentLog: $CurrentLog"
    Export-WindowsImage -SourceImagePath "$MountDirectory\Windows\System32\Recovery\winre.wim" -SourceIndex 1 -DestinationImagePath "$OSMediaPath\WinPE\winre.wim" -LogPath "$CurrentLog" | Out-Null

    Write-Verbose "$OSMediaPath\WinPE\winse.wim"
    $CurrentLog = "$OSMediaPath\WinPE\info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Export-WindowsImage-WinSE.log"
    Write-Verbose "CurrentLog: $CurrentLog"
    Export-WindowsImage -SourceImagePath "$OSMediaPath\OS\sources\boot.wim" -SourceIndex 2 -DestinationImagePath "$OSMediaPath\WinPE\winse.wim" -LogPath "$CurrentLog" | Out-Null
}
function Save-WindowsImageContentOS {
    [CmdletBinding()]
    param ()
    #=================================================
    #   Header
    #=================================================
    Show-ActionTime; Write-Host -ForegroundColor Green "OS: Export Image Content to $Info\Get-WindowsImageContent.txt"
    #=================================================
    #   Execute
    #=================================================
    Get-WindowsImageContent -ImagePath "$OS\Sources\install.wim" -Index 1 | Out-File "$Info\Get-WindowsImageContent.txt"
}
function Save-WindowsImageContentPE {
    [CmdletBinding()]
    param ()
    #=================================================
    #   Header
    #=================================================
    Show-ActionTime
    Write-Host -ForegroundColor Green "Export Image Content to $Info\Get-WindowsImageContent.txt"
    #=================================================
    #   Execute
    #=================================================
    Get-WindowsImageContent -ImagePath "$OS\Sources\boot.wim" -Index 1 | Out-File "$Info\Get-WindowsImageContent.txt"
}
function Set-LanguageSettingsOS {
    [CmdletBinding()]
    param ()
    if ($ScriptName -ne 'New-OSBuild') {Return}
    if ($OSMajorVersion -ne 10) {Return}
    #=================================================
    #   Header
    #=================================================
    Show-ActionTime
    Write-Host -ForegroundColor Green "OS: Language Settings"

    if ($SetAllIntl) {
        Show-ActionTime
        Write-Host -ForegroundColor Green "OS: SetAllIntl"
        Dism /Image:"$MountDirectory" /Set-AllIntl:"$SetAllIntl" /LogPath:"$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Dism-SetAllIntl.log" | Out-Null
    }
    if ($SetInputLocale) {
        Show-ActionTime
        Write-Host -ForegroundColor Green "OS: SetInputLocale"
        Dism /Image:"$MountDirectory" /Set-InputLocale:"$SetInputLocale" /LogPath:"$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Dism-SetInputLocale.log" | Out-Null
    }
    if ($SetSKUIntlDefaults) {
        Show-ActionTime
        Write-Host -ForegroundColor Green "OS: SetSKUIntlDefaults"
        Dism /Image:"$MountDirectory" /Set-SKUIntlDefaults:"$SetSKUIntlDefaults" /LogPath:"$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Dism-SetSKUIntlDefaults.log" | Out-Null
    }
    if ($SetSetupUILang) {
        Show-ActionTime
        Write-Host -ForegroundColor Green "OS: SetSetupUILang"
        Dism /Image:"$MountDirectory" /Set-SetupUILang:"$SetSetupUILang" /Distribution:"$OS" /LogPath:"$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Dism-SetSetupUILang.log" | Out-Null
    }
    if ($SetSysLocale) {
        Show-ActionTime
        Write-Host -ForegroundColor Green "OS: SetSysLocale"
        Dism /Image:"$MountDirectory" /Set-SysLocale:"$SetSysLocale" /LogPath:"$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Dism-SetSysLocale.log" | Out-Null
    }
    if ($SetUILang) {
        Show-ActionTime
        Write-Host -ForegroundColor Green "OS: SetUILang"
        Dism /Image:"$MountDirectory" /Set-UILang:"$SetUILang" /LogPath:"$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Dism-SetUILang.log" | Out-Null
    }
    if ($SetUILangFallback) {
        Show-ActionTime
        Write-Host -ForegroundColor Green "OS: SetUILangFallback"
        Dism /Image:"$MountDirectory" /Set-UILangFallback:"$SetUILangFallback" /LogPath:"$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Dism-SetUILangFallback.log" | Out-Null
    }
    if ($SetUserLocale) {
        Show-ActionTime
        Write-Host -ForegroundColor Green "OS: SetUserLocale"
        Dism /Image:"$MountDirectory" /Set-UserLocale:"$SetUserLocale" /LogPath:"$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Dism-SetUserLocale.log" | Out-Null
    }
    Show-ActionTime
    Write-Host -ForegroundColor Green "OS: Generating Updated Lang.ini"
    Dism /Image:"$MountDirectory" /Gen-LangIni /Distribution:"$OS" /LogPath:"$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Dism-gen-langini.log" | Out-Null

    Update-LangIniMEDIA -OSMediaPath "$WorkingPath"
}
function Set-PEBuildScratchSpace {
    [CmdletBinding()]
    param (
        [string]$MountDirectory,
        [string]$ScratchSpace
    )
    #=================================================
    #   Header
    #=================================================
    Show-ActionTime; Write-Host -ForegroundColor Green "WinPE: Set-ScratchSpace $ScratchSpace"
    #=================================================
    #   Execute
    #=================================================
    Try {
        Dism /Image:"$MountDirectory" /Set-ScratchSpace:$ScratchSpace /LogPath:"$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Set-PEBuildScratchSpace.log" | Out-Null
    }
    Catch {
        $ErrorMessage = $_.Exception.Message
        Write-Warning "$ErrorMessage"
    }
}
function Set-PEBuildTargetPath {
    [CmdletBinding()]
    param (
        [string]$MountDirectory
    )
    #=================================================
    #   Header
    #=================================================
    Show-ActionTime; Write-Host -ForegroundColor Green "WinPE: Set-TargetPath X:\"
    #=================================================
    #   Execute
    #=================================================
    Try {
        Dism /Image:"$MountDirectory" /Set-TargetPath:"X:\" /LogPath:"$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Set-PEBuildTargetPath.log" | Out-Null
    }
    Catch {
        $ErrorMessage = $_.Exception.Message
        Write-Warning "$ErrorMessage"
    }
}
function Set-WinREWimOS {
    [CmdletBinding()]
    param ()
    #=================================================
    #   Header
    #=================================================
    Show-ActionTime
    Write-Host -ForegroundColor Green "OS: Replace $MountDirectory\Windows\System32\Recovery\winre.wim"
    #=================================================
    #   Execute
    #=================================================
    if (Test-Path "$MountDirectory\Windows\System32\Recovery\winre.wim") {
        Remove-Item -Path "$MountDirectory\Windows\System32\Recovery\winre.wim" -Force
    }

    Copy-Item -Path "$WinPE\winre.wim" -Destination "$MountDirectory\Windows\System32\Recovery\winre.wim" -Force | Out-Null
    $GetWindowsImage = @()
    $GetWindowsImage = Get-WindowsImage -ImagePath "$WinPE\winre.wim" -Index 1 | Select-Object -Property *
    $GetWindowsImage | Out-File "$PEInfo\Get-WindowsImage-WinRE.txt"
    (Get-Content "$PEInfo\Get-WindowsImage-WinRE.txt") | Where-Object {$_.Trim(" `t")} | Set-Content "$PEInfo\Get-WindowsImage-WinRE.txt"
    $GetWindowsImage | Out-File "$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsImage-WinRE.txt"
    $GetWindowsImage | Export-Clixml -Path "$PEInfo\xml\Get-WindowsImage-WinRE.xml"
    $GetWindowsImage | Export-Clixml -Path "$PEInfo\xml\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsImage-WinRE.xml"
    $GetWindowsImage | ConvertTo-Json | Out-File "$PEInfo\json\Get-WindowsImage-WinRE.json"
    $GetWindowsImage | ConvertTo-Json | Out-File "$PEInfo\json\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsImage-WinRE.json"
}
function Show-ActionTime {
    [CmdletBinding()]
    param ()
    #=================================================
    #   Show-ActionTime
    #=================================================
    $Global:OSDStartTime = Get-Date
    Write-Host -ForegroundColor White "$(($Global:OSDStartTime).ToString('yyyy-MM-dd-HHmmss')) " -NoNewline
    #Write-Host -ForegroundColor DarkGray "[$(($Global:OSDStartTime).ToString('yyyy-MM-dd-HHmmss'))] " -NoNewline
    #=================================================
}
function Show-GetWindowsImage {
    [CmdletBinding()]
    param ()
    Write-Host '========================================================================================' -ForegroundColor DarkGray
    Write-Host -ForegroundColor Green "Windows Image Information"
    $GetWindowsImage
<#     Write-Host "Source Path:                $OSSourcePath"
    Write-Host "-Image File:                $OSImagePath"
    Write-Host "-Image Index:               $OSImageIndex"
    Write-Host "-Name:                      $OSImageName"
    Write-Host "-Description:               $OSImageDescription"
    Write-Host "-Architecture:              $($GetWindowsImage.Architecture)"
    Write-Host "-Edition:                   $($GetWindowsImage.EditionID)"
    Write-Host "-Type:                      $OSInstallationType"
    Write-Host "-Languages:                 $OSLanguages"
    Write-Host "-Build:                     $OSBuild"
    Write-Host "-Version:                   $OSVersion"
    Write-Host "-SPBuild:                   $OSSPBuild"
    Write-Host "-SPLevel:                   $OSSPLevel"
    Write-Host "-Bootable:                  $OSImageBootable"
    Write-Host "-WimBoot:                   $OSWIMBoot"
    Write-Host "-Created Time:              $OSCreatedTime"
    Write-Host "-Modified Time:             $OSModifiedTime" #>
    #Write-Host "UBR                  : $UBR"
    #Write-Host "OSMGuid              : $OSMGuid"
}
function Show-MediaImageInfoOS {
    [CmdletBinding()]
    param ()
    #=================================================
    #   Show-MediaImageInfoOS
    #=================================================
    Write-Host '========================================================================================' -ForegroundColor DarkGray
    Write-Host -ForegroundColor Green "Source OSMedia Windows Image Information"
    Write-Host "-OSMedia Path:              $OSMediaPath" -ForegroundColor Yellow
    Write-Host "-Image File:                $OSImagePath"
    #Write-Host "-Image Index:              $OSImageIndex"
    Write-Host "-Name:                      $OSImageName"
    Write-Host "-Description:               $OSImageDescription"
    Write-Host "-Architecture:              $OSArchitecture"
    Write-Host "-Edition:                   $OSEditionID"
    Write-Host "-Type:                      $OSInstallationType"
    Write-Host "-Languages:                 $OSLanguages"
    Write-Host "-Major Version:             $OSMajorVersion"
    Write-Host "-Build:                     $OSBuild"
    Write-Host "-Version:                   $OSVersion"
    Write-Host "-SPBuild:                   $OSSPBuild"
    Write-Host "-SPLevel:                   $OSSPLevel"
    #Write-Host "-Bootable:                 $OSImageBootable"
    #Write-Host "-WimBoot:                  $OSWIMBoot"
    Write-Host "-Created Time:              $OSCreatedTime"
    Write-Host "-Modified Time:             $OSModifiedTime"
}
function Show-MediaInfoOS {
    [CmdletBinding()]
    param ()
    Write-Host '========================================================================================' -ForegroundColor DarkGray
    Write-Host -ForegroundColor Green "OSMedia Information"
    Write-Host "-OSMediaName:       $OSMediaName" -ForegroundColor Yellow
    Write-Host "-OSMediaPath:       $OSMediaPath" -ForegroundColor Yellow
    Write-Host "-OS:                $OS"
    Write-Host "-WinPE:             $WinPE"
    Write-Host "-Info:              $Info"
    Write-Host "-Logs:              $Info\logs"
}
function Show-OSDBuilderHomeMap {
    [CmdletBinding()]
    param ()
    Write-Host ""
    
    if (Test-Path $GetOSDBuilderHome)            {Write-Host "OSDBuilder Home:                                    $GetOSDBuilderHome" -ForegroundColor White}
    else                                        {Write-Host "OSDBuilder Home:                                    $GetOSDBuilderHome (does not exist)" -ForegroundColor White}
    if (Get-IsContentPacksEnabled) {
        if (Test-Path $SetOSDBuilderPathContentPacks)  {Write-Host "ContentPacks:                                         $SetOSDBuilderPathContentPacks" -ForegroundColor Cyan}
        else                                    {Write-Host "ContentPacks:                                         $SetOSDBuilderPathContentPacks (does not exist)" -ForegroundColor Gray}
    }

<#     if (Test-Path "$SetOSDBuilderPathOSImport")            {Write-Host "OSImport:          $SetOSDBuilderPathOSImport" -ForegroundColor Gray}
        else                                        {Write-Host "OSImport:          $SetOSDBuilderPathOSImport (does not exist)" -ForegroundColor Gray}
    if (Test-Path "$SetOSDBuilderPathOSMedia")             {Write-Host "OSMedia:           $SetOSDBuilderPathOSMedia" -ForegroundColor Gray}
        else                                        {Write-Host "OSMedia:           $SetOSDBuilderPathOSMedia (does not exist)" -ForegroundColor Gray}
    if (Test-Path "$SetOSDBuilderPathOSBuilds")            {Write-Host "OSBuilds:          $SetOSDBuilderPathOSBuilds" -ForegroundColor Gray}
        else                                        {Write-Host "OSBuilds:          $SetOSDBuilderPathOSBuilds (does not exist)" -ForegroundColor Gray}
    if (Test-Path "$SetOSDBuilderPathPEBuilds")            {Write-Host "PEBuilds:          $SetOSDBuilderPathPEBuilds" -ForegroundColor Gray}
        else                                        {Write-Host "PEBuilds:          $SetOSDBuilderPathPEBuilds (does not exist)" -ForegroundColor Gray}
    if (Test-Path $SetOSDBuilderPathTasks)               {Write-Host "Tasks:             $SetOSDBuilderPathTasks" -ForegroundColor Gray}
        else                                        {Write-Host "Tasks:             $SetOSDBuilderPathTasks (does not exist)" -ForegroundColor Gray}
    if (Test-Path $SetOSDBuilderPathTemplates)           {Write-Host "Templates:         $SetOSDBuilderPathTemplates" -ForegroundColor Gray}
        else                                        {Write-Host "Templates:         $SetOSDBuilderPathTemplates (does not exist)" -ForegroundColor Gray}
    if (Test-Path $SetOSDBuilderPathContent)             {Write-Host "Content:           $SetOSDBuilderPathContent" -ForegroundColor Gray}
        else                                        {Write-Host "Content:           $SetOSDBuilderPathContent (does not exist)" -ForegroundColor Gray} #>

}
function Show-OSDBuilderHomeTips {
    [CmdletBinding()]
    param ()
    Write-Host ''
    Write-Host "Shortcuts:" -ForegroundColor Gray
    Write-Host 'OSDBuilder -SetHome D:\OSDBuilder       '   -ForegroundColor DarkGray -NoNewline
    Write-Host 'Change OSDBuilder Home Path' -ForegroundColor DarkGray
    Write-Host 'OSDBuilder -CreatePaths                 ' -ForegroundColor DarkGray -NoNewline
    Write-Host 'Create OSDBuilder Directory Structure' -ForegroundColor DarkGray

    Write-Host 'OSDBuilder -Download OSMediaUpdates     ' -ForegroundColor DarkGray -NoNewline
    Write-Host 'Download missing Microsoft Updates for OSMedia' -ForegroundColor DarkGray
    Write-Host 'OSDBuilder -Download FeatureUpdates     ' -ForegroundColor DarkGray -NoNewline
    Write-Host 'Download Windows 10 and 11 Feature Updates for Import' -ForegroundColor DarkGray
    Write-Host 'OSDBuilder -Download OneDrive           ' -ForegroundColor DarkGray -NoNewline
    Write-Host 'Download the latest OneDriveSetup.exe' -ForegroundColor DarkGray
    Write-Host 'OSDBuilder -Download OneDriveEnterprise ' -ForegroundColor DarkGray -NoNewline
    Write-Host 'Download the latest OneDriveSetup.exe (Enterprise)' -ForegroundColor DarkGray
    Write-Host 'Import-OSMedia -Update                  '   -ForegroundColor Green -NoNewline
    Write-Host 'Import and Update an OS (Downloads Updates)'
    Write-Host 'Import-OSMedia -Update -BuildNetFX      '   -ForegroundColor Green -NoNewline
    Write-Host 'Import, Update, and Build (NetFX) an OS (Downloads Updates)'
    Write-Host 'Update-OSMedia -Download -Execute       '   -ForegroundColor Green -NoNewline
    Write-Host 'Update an OS (Downloads Updates)'
}
function Show-OSMediaInfo {
    [CmdletBinding()]
    param ()

    Write-Host '========================================================================================' -ForegroundColor DarkGray
    Write-Host -ForegroundColor Green "OSMedia Information"
    Write-Host "-OSMedia Name:          $OSMediaName" -ForegroundColor Yellow
    Write-Host "-OSMedia Path:          $OSMediaPath" -ForegroundColor Yellow
    Write-Host "-OSMedia Path OS:       $OSMediaPathOS"
    Write-Host "-OSMedia Path WinPE:    $OSMediaPathWinPE"
    Write-Host "-OSMedia Path Info:     $OSMediaPathInfo"
}
function Show-SkipUpdatesInfo {
    #Show-ActionTime
    #Write-Host -ForegroundColor DarkGray "                  -SkipUpdates Parameter was used"
}
function Show-TaskInfo {
    [CmdletBinding()]
    param ()
    #=================================================
    Write-Verbose 'Show-TaskInfo'
    #=================================================
    Write-Host '========================================================================================' -ForegroundColor DarkGray
    Write-Host "OSBuild Task Information" -ForegroundColor Green
    Write-Host "-TaskName:                  $TaskName"
    Write-Host "-TaskVersion:               $TaskVersion"
    Write-Host "-TaskType:                  $TaskType"
    Write-Host "-OSMedia Name:              $OSMediaName"
    Write-Host "-OSMedia Path:              $OSMediaPath"
    if ($CustomName) {
    Write-Host "-Custom Name:               $CustomName"}
    
    if ((Get-IsContentPacksEnabled) -and (!($SkipContentPacks.IsPresent))) {
        Write-Host "-ContentPacks:" -ForegroundColor Cyan
        foreach ($item in $ContentPacks)       {Write-Host "   $SetOSDBuilderPathContentPacks\$item" -ForegroundColor Cyan}}
    
    if ($EnableNetFX3 -eq $true) {
    Write-Host "-Enable NetFx3:             $EnableNetFX3"}
    if ($WinPEAutoExtraFiles -eq $true) {
    Write-Host "-WinPE Auto ExtraFiles:     $WinPEAutoExtraFiles"}
    if ($WinPEOSDCloud -eq $true) {
    Write-Host "-WinPE OSDCloud:            $WinPEOSDCloud"}
    if ($WinREWiFi -eq $true) {
    Write-Host "-WinRE WiFi                 $WinREWiFi"}

    if ($DisableFeature) {
        Write-Host "-Disable Feature:"
        foreach ($item in $DisableFeature)      {Write-Host "   $item" -ForegroundColor DarkGray}}

    if ($EnableFeature) {
        Write-Host "-Enable Feature:"
        foreach ($item in $EnableFeature)       {Write-Host "   $item" -ForegroundColor DarkGray}}

    if ($RemoveAppx) {
        Write-Host "-Remove Appx:"
        foreach ($item in $RemoveAppx)          {Write-Host "   $item" -ForegroundColor DarkGray}}
    
    if ($RemoveCapability) {
        Write-Host "-Remove Capability:"
        foreach ($item in $RemoveCapability)    {Write-Host "   $item" -ForegroundColor DarkGray}}
        
    if ($RemovePackage) {
        Write-Host "-Remove Packages:"
        foreach ($item in $RemovePackage)       {Write-Host "   $item" -ForegroundColor DarkGray}}


    if ($StartLayoutXML)    {
    Write-Host "-Start Layout:              $SetOSDBuilderPathContent\$StartLayoutXML"}
    if ($UnattendXML)       {
    Write-Host "-Unattend:                  $SetOSDBuilderPathContent\$UnattendXML"}
    if ($WinPEDaRT)         {
    Write-Host "-WinPE DaRT:                $SetOSDBuilderPathContent\$WinPEDaRT"}

    if ($Drivers) {
        Write-Host "-Drivers:"
        foreach ($item in $Drivers)             {Write-Host "   $SetOSDBuilderPathContent\$item" -ForegroundColor DarkGray}}
    
    if ($ExtraFiles) {
        Write-Host "-Extra Files:"
        foreach ($item in $ExtraFiles)          {Write-Host "   $SetOSDBuilderPathContent\$item" -ForegroundColor DarkGray}}

    if ($FeaturesOnDemand) {
        Write-Host "-Features On Demand:"
        foreach ($item in $FeaturesOnDemand)    {Write-Host "   $SetOSDBuilderPathContent\$item" -ForegroundColor DarkGray}}
    
    if ($Packages) {
        Write-Host "-Packages:"
        foreach ($item in $Packages)            {Write-Host "   $SetOSDBuilderPathContent\$item" -ForegroundColor DarkGray}}

    if ($Scripts) {
        Write-Host "-Scripts:"
        foreach ($item in $Scripts)             {Write-Host "   $SetOSDBuilderPathContent\$item" -ForegroundColor DarkGray}}

    if ($WinPEDrivers) {
        Write-Host "-WinPE Drivers:"
        foreach ($item in $WinPEDrivers)        {Write-Host "   $SetOSDBuilderPathContent\$item" -ForegroundColor DarkGray}}
    
    if ($WinPEADKPE) {
        Write-Host "-WinPE ADK Packages:"
        foreach ($item in $WinPEADKPE)          {Write-Host "   $SetOSDBuilderPathContent\$item" -ForegroundColor DarkGray}}
    
    if ($WinPEADKRE) {
        Write-Host "-WinRE ADK Packages:"
        foreach ($item in $WinPEADKRE)          {Write-Host "   $SetOSDBuilderPathContent\$item" -ForegroundColor DarkGray}}
    
    if ($WinPEADKSE) {
        Write-Host "-WinSE ADK Packages:"
        foreach ($item in $WinPEADKSE)          {Write-Host "   $SetOSDBuilderPathContent\$item" -ForegroundColor DarkGray}}
    
    if ($WinPEExtraFilesPE) {
        Write-Host "-WinPE Extra Files:"
        foreach ($item in $WinPEExtraFilesPE)   {Write-Host "   $SetOSDBuilderPathContent\$item" -ForegroundColor DarkGray}}
    
    if ($WinPEExtraFilesRE) {
        Write-Host "-WinRE Extra Files:"
        foreach ($item in $WinPEExtraFilesRE)   {Write-Host "   $SetOSDBuilderPathContent\$item" -ForegroundColor DarkGray}}
    
    if ($WinPEExtraFilesSE) {
        Write-Host "-WinSE Extra Files:"
        foreach ($item in $WinPEExtraFilesSE)   {Write-Host "   $SetOSDBuilderPathContent\$item" -ForegroundColor DarkGray}}
    
    if ($WinPEScriptsPE) {
        Write-Host "-WinPE Scripts:"
        foreach ($item in $WinPEScriptsPE)      {Write-Host "   $SetOSDBuilderPathContent\$item" -ForegroundColor DarkGray}}
    
    if ($WinPEScriptsRE) {
        Write-Host "-WinRE Scripts:"
        foreach ($item in $WinPEScriptsRE)      {Write-Host "   $SetOSDBuilderPathContent\$item" -ForegroundColor DarkGray}}
    
    if ($WinPEScriptsSE) {
        Write-Host "-WinSE Scripts:"
        foreach ($item in $WinPEScriptsSE)      {Write-Host "   $SetOSDBuilderPathContent\$item" -ForegroundColor DarkGray}}

    if ($SetAllIntl)            {Write-Host "-SetAllIntl (Language):         $SetAllIntl"}
    if ($SetInputLocale)        {Write-Host "-SetInputLocale (Language):     $SetInputLocale"}
    if ($SetSKUIntlDefaults)    {Write-Host "-SetSKUIntlDefaults (Language): $SetSKUIntlDefaults"}
    if ($SetSetupUILang)        {Write-Host "-SetSetupUILang (Language):     $SetSetupUILang"}
    if ($SetSysLocale)          {Write-Host "-SetSysLocale (Language):       $SetSysLocale"}
    if ($SetUILang)             {Write-Host "-SetUILang (Language):          $SetUILang"}
    if ($SetUILangFallback)     {Write-Host "-SetUILangFallback (Language):  $SetUILangFallback"}
    if ($SetUserLocale)         {Write-Host "-SetUserLocale (Language):      $SetUserLocale"}

    if ($LanguageFeatures) {
        Write-Host "-Language Features:"
        foreach ($item in $LanguageFeatures)        {Write-Host "   $item" -ForegroundColor DarkGray}}
    
    if ($LanguageInterfacePacks) {
        Write-Host "-Language Interface Packs:"
        foreach ($item in $LanguageInterfacePacks)  {Write-Host "   $item" -ForegroundColor DarkGray}}
    
    if ($LanguagePacks) {
        Write-Host "-Language Packs:"
        foreach ($item in $LanguagePacks)           {Write-Host "   $item" -ForegroundColor DarkGray}}
    
    if ($LocalExperiencePacks) {
        Write-Host "-Local Experience Packs:"
        foreach ($item in $LocalExperiencePacks)    {Write-Host "   $item" -ForegroundColor DarkGray}}
    
    if ($LanguageCopySources) {
        Write-Host "-Language Sources Copy:"
        foreach ($item in $LanguageCopySources)     {Write-Host "   $item" -ForegroundColor DarkGray}}

    $CombinedOSMedia = Get-OSMedia -Revision OK | Where-Object {$_.OSMFamily -eq $TaskOSMFamily}

    $CombinedTask = [ordered]@{
        "TaskType" = [string]"OSBuild";
        "TaskName" = [string]$TaskName;
        "TaskVersion" = [string]$TaskVersion;
        "TaskGuid" = [string]$(New-Guid);
        "CustomName" = [string]$CustomName;
        "OSMFamily" = [string]$TaskOSMFamily
        "OSMGuid" = [string]$CombinedOSMedia.OSMGuid;
        "Name" = [string]$OSMediaName;

        "ImageName" = [string]$CombinedOSMedia.ImageName;
        "Arch" = [string]$CombinedOSMedia.Arch;
        "ReleaseId" = [string]$CombinedOSMedia.ReleaseId;
        "UBR" = [string]$CombinedOSMedia.UBR;
        "Languages" = [string[]]$CombinedOSMedia.Languages;
        "EditionId" = [string]$CombinedOSMedia.EditionId;
        "InstallationType" = [string]$CombinedOSMedia.InstallationType;
        "MajorVersion" = [string]$CombinedOSMedia.MajorVersion;
        "Build" = [string]$CombinedOSMedia.Build;
        "CreatedTime" = [datetime]$CombinedOSMedia.CreatedTime;
        "ModifiedTime" = [datetime]$CombinedOSMedia.ModifiedTime;

        "EnableNetFX3" = [string]$EnableNetFX3;
        "StartLayoutXML" = [string]$StartLayoutXML;
        "UnattendXML" = [string]$UnattendXML;
        "WinPEAutoExtraFiles" = [string]$WinPEAutoExtraFiles;
        "WinPEOSDCloud" = [string]$WinPEOSDCloud;
        "WinREWiFi" = [string]$WinREWiFi;
        "WinPEDaRT" = [string]$WinPEDaRT;
        ContentPacks = [string[]]$($ContentPacks | Sort-Object -Unique);
        "ExtraFiles" = [string[]]$($ExtraFiles | Sort-Object -Unique);
        "Scripts" = [string[]]$($Scripts | Sort-Object -Unique);
        "Drivers" = [string[]]$($Drivers | Sort-Object -Unique);

        "AddWindowsPackage" = [string[]]$($Packages | Sort-Object -Unique);
        "RemoveWindowsPackage" = [string[]]$($RemovePackage | Sort-Object -Unique);
        "AddFeatureOnDemand" = [string[]]$($FeaturesOnDemand | Sort-Object -Unique);
        "EnableWindowsOptionalFeature" = [string[]]$($EnableFeature | Sort-Object -Unique);
        "DisableWindowsOptionalFeature" = [string[]]$($DisableFeature | Sort-Object -Unique);
        "RemoveAppxProvisionedPackage" = [string[]]$($RemoveAppx | Sort-Object -Unique);
        "RemoveWindowsCapability" = [string[]]$($RemoveCapability | Sort-Object -Unique);

        "WinPEDrivers" = [string[]]$($WinPEDrivers | Sort-Object -Unique);
        "WinPEExtraFilesPE" = [string[]]$($WinPEExtraFilesPE | Sort-Object -Unique);
        "WinPEExtraFilesRE" = [string[]]$($WinPEExtraFilesRE | Sort-Object -Unique);
        "WinPEExtraFilesSE" = [string[]]$($WinPEExtraFilesSE | Sort-Object -Unique);
        "WinPEScriptsPE" = [string[]]$($WinPEScriptsPE | Sort-Object -Unique);
        "WinPEScriptsRE" = [string[]]$($WinPEScriptsRE | Sort-Object -Unique);
        "WinPEScriptsSE" = [string[]]$($WinPEScriptsSE | Sort-Object -Unique);
        "WinPEADKPE" = [string[]]$($WinPEADKPE | Select-Object -Unique);
        "WinPEADKRE" = [string[]]$($WinPEADKRE | Select-Object -Unique);
        "WinPEADKSE" = [string[]]$($WinPEADKSE | Select-Object -Unique);

        "LangSetAllIntl" = [string]$SetAllIntl;
        "LangSetInputLocale" = [string]$SetInputLocale;
        "LangSetSKUIntlDefaults" = [string]$SetSKUIntlDefaults;
        "LangSetSetupUILang" = [string]$SetSetupUILang;
        "LangSetSysLocale" = [string]$SetSysLocale;
        "LangSetUILang" = [string]$SetUILang;
        "LangSetUILangFallback" = [string]$SetUILangFallback;
        "LangSetUserLocale" = [string]$SetUserLocale;
        "LanguageFeature" = [string[]]$($LanguageFeatures | Sort-Object -Unique);
        "LanguageInterfacePack" = [string[]]$($LanguageInterfacePacks | Sort-Object -Unique);
        "LanguagePack" = [string[]]$($LanguagePacks | Sort-Object -Unique);
        "LocalExperiencePacks" = [string[]]$($LocalExperiencePacks | Sort-Object -Unique);
    }
    $CombinedTask | ConvertTo-Json | Out-File "$($CombinedOSMedia.FullName)\OSBuild.json"
}
function Show-WorkingInfoOS {
    [CmdletBinding()]
    param ()
    #=================================================
    Write-Verbose '19.1.1 Working Information'
    #=================================================
    Write-Host '========================================================================================' -ForegroundColor DarkGray
    Write-Host -ForegroundColor Green "Working Information"
    Write-Host "-WorkingName:               $WorkingName" -ForegroundColor Yellow
    Write-Host "-WorkingPath:               $WorkingPath" -ForegroundColor Yellow
    Write-Host "-OS:                        $OS"
    Write-Host "-WinPE:                     $WinPE"
    Write-Host "-Info:                      $Info"
    Write-Host "-Logs:                      $Info\logs"
    Write-Host '========================================================================================' -ForegroundColor DarkGray
}
function Update-AdobeOS {
    [CmdletBinding()]
    param (
        [switch]$Force
    )
    #=================================================
    #   Abort
    #=================================================
    if ($SkipUpdates) {Return}
    if ($SkipUpdatesOS) {Return}
    if ($OSMajorVersion -ne 10) {Return}
    if ($null -eq $OSDUpdateAdobeSU) {Return}
    #=================================================
    #   Header
    #=================================================
    Show-ActionTime
    if ($Force.IsPresent) {
        Write-Host -ForegroundColor Green "OS: (ASU) Adobe Flash Player Security Update (Forced)"
    } else {
        Write-Host -ForegroundColor Green "OS: (ASU) Adobe Flash Player Security Update"
    }
    #=================================================
    #   Execute
    #=================================================
    foreach ($Update in $OSDUpdateAdobeSU) {
        $UpdateASU = $(Get-ChildItem -Path $SetOSDBuilderPathUpdates -File -Recurse | Where-Object {$_.Name -match $(Split-Path $Update.OriginUri -Leaf)}).FullName | Select-Object -First 1

        if ($null -eq $UpdateASU) {Write-Warning "Update-AdobeOS is Null"; Continue}
        if (!(Test-Path "$UpdateASU")) {Write-Warning "Update-AdobeOS was not found"; Continue}
        
        if (! ($Force.IsPresent)) {
            if (Get-SessionsXml -Path $MountDirectory -KBNumber $Update.FileKBNumber | Where-Object {$_.TargetState -eq 'Installed'}) {
                Write-Host -ForegroundColor Gray "INSTALLED         $($Update.Title) - $(Split-Path $Update.OriginUri -Leaf)"; Continue
            }
            if (Get-WindowsPackage -Path "$MountDirectory" | Where-Object {$_.PackageName -match "$($Update.FileKBNumber)"}) {
                Write-Host -ForegroundColor Gray "INSTALLED         $($Update.Title) - $(Split-Path $Update.OriginUri -Leaf)"; Continue
            }
        }

        Write-Host -ForegroundColor Cyan "INSTALLING        " -NoNewline
        Write-Host -ForegroundColor Gray "$($Update.Title) - $(Split-Path $Update.OriginUri -Leaf)"

        $CurrentLog = "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Update-AdobeOS-KB$($Update.FileKBNumber).log"
        Write-Verbose "CurrentLog: $CurrentLog"
        Try {Add-WindowsPackage -Path "$MountDirectory" -PackagePath "$UpdateASU" -LogPath $CurrentLog | Out-Null}
        Catch {
            if ($_.Exception.Message -match '0x800f081e') {Write-Verbose "OSDBuilder: 0x800f081e The package is not applicable to this image" -Verbose}
            Write-Verbose "OSDBuilder: Review the log for more information" -Verbose
            Write-Verbose "$CurrentLog" -Verbose
        }
    }
}
function Update-ComponentOS {
    [CmdletBinding()]
    param (
        [switch]$Force
    )
    #=================================================
    #   Abort
    #=================================================
    if ($SkipUpdates) {Return}
    if ($SkipUpdatesDUC) {Return}
    if ($SkipUpdatesOS) {Return}
    if ($null -eq $OSDUpdateComponentDU) {Return}
    #=================================================
    #   Header
    #=================================================
    Show-ActionTime
    if ($Force.IsPresent) {
        Write-Host -ForegroundColor Green "OS: Component Update (Forced)"
    } else {
        Write-Host -ForegroundColor Green "OS: Component Update"
    }
    #=================================================
    #   Execute
    #=================================================
    foreach ($Update in $OSDUpdateComponentDU) {
        $UpdateComp = $(Get-ChildItem -Path $SetOSDBuilderPathUpdates -File -Recurse | Where-Object {$_.Name -match $(Split-Path $Update.OriginUri -Leaf)}).FullName | Select-Object -First 1
        if ($null -eq $UpdateComp) {Write-Warning "Update-ComponentOS is Null"; Continue}
        if (!(Test-Path "$UpdateComp")) {Write-Warning "Update-ComponentOS was not found"; Continue}

        if (! ($Force.IsPresent)) {
            if (Get-SessionsXml -Path $MountDirectory -KBNumber $Update.FileKBNumber | Where-Object {$_.TargetState -eq 'Installed'}) {
                Write-Host -ForegroundColor Gray "INSTALLED         $($Update.Title) - $(Split-Path $Update.OriginUri -Leaf)"; Continue
            }
            if (Get-WindowsPackage -Path "$MountDirectory" | Where-Object {$_.PackageName -match "$($Update.FileKBNumber)"}) {
                Write-Host -ForegroundColor Gray "INSTALLED         $($Update.Title) - $(Split-Path $Update.OriginUri -Leaf)"; Continue
            }
        }

        Write-Host -ForegroundColor Cyan "INSTALLING        " -NoNewline
        Write-Host -ForegroundColor Gray "$($Update.Title) - $(Split-Path $Update.OriginUri -Leaf)"

        $CurrentLog = "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Update-ComponentOS-KB$($Update.FileKBNumber).log"
        Write-Verbose "CurrentLog: $CurrentLog"
        Try {Add-WindowsPackage -Path "$MountDirectory" -PackagePath "$UpdateComp" -LogPath "$CurrentLog" | Out-Null}
        Catch {
            if ($_.Exception.Message -match '0x800f081e') {Write-Verbose "OSDBuilder: 0x800f081e The package is not applicable to this image" -Verbose}
            Write-Verbose "OSDBuilder: Review the log for more information" -Verbose
            Write-Verbose "$CurrentLog" -Verbose
        }
    }
}
function Update-CumulativeOS {
    [CmdletBinding()]
    param (
        [switch]$Force
    )
    #=================================================
    #   Abort
    #=================================================
    if ($SkipUpdates) {Return}
    if ($SkipUpdatesOS) {Return}
    if ($SkipUpdatesOSLCU) {Return}
    if ($OSMajorVersion -ne 10) {Return}
    if ($null -eq $OSDUpdateLCU) {Return}
    #=================================================
    #   Header
    #=================================================
    Show-ActionTime
    if ($Force.IsPresent) {
        Write-Host -ForegroundColor Green "OS: (LCU) Latest Cumulative Update (Forced)"
    } else {
        Write-Host -ForegroundColor Green "OS: (LCU) Latest Cumulative Update"
    }
    #=================================================
    #   Execute
    #=================================================
    foreach ($Update in $OSDUpdateLCU) {
        $UpdateLCU = $(Get-ChildItem -Path $SetOSDBuilderPathUpdates -File -Recurse | Where-Object {$_.Name -match $(Split-Path $Update.OriginUri -Leaf)}).FullName | Select-Object -First 1
        if ($null -eq $UpdateLCU) {Write-Warning "Update-CumulativeOS is Null"; Continue}
        if (!(Test-Path "$UpdateLCU")) {Write-Warning "Update-CumulativeOS was not found"; Continue}
        
        if (!($Force.IsPresent)) {
            if (Get-SessionsXml -Path $MountDirectory -KBNumber $Update.FileKBNumber | Where-Object {$_.TargetState -eq 'Installed'}) {
                Write-Host -ForegroundColor Gray "INSTALLED         $($Update.Title) - $(Split-Path $Update.OriginUri -Leaf)"; Continue
            }
        }

        Write-Host -ForegroundColor Cyan "INSTALLING        " -NoNewline
        Write-Host -ForegroundColor Gray "$($Update.Title) - $(Split-Path $Update.OriginUri -Leaf)"

        $CurrentLog = "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Add-WindowsPackageSSU-KB$($Update.FileKBNumber).log"
        Write-Verbose "CurrentLog: $CurrentLog"

        Add-WindowsPackageSSU -Path "$MountDirectory" -PackagePath "$UpdateLCU" -LogPath "$CurrentLog" | Out-Null

        $CurrentLog = "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Update-CumulativeOS-KB$($Update.FileKBNumber).log"
        Write-Verbose "CurrentLog: $CurrentLog"
        Try {Add-WindowsPackage -Path "$MountDirectory" -PackagePath "$UpdateLCU" -LogPath "$CurrentLog" | Out-Null}
        Catch {
            if ($_.Exception.Message -match '0x800f081e') {
                Write-Verbose "OSDBuilder: 0x800f081e The package is not applicable to this image" -Verbose
            }
<#             elseif ($_.Exception.Message -match '0x800f0823') {
                Write-Verbose "OSDBuilder: 0x800f0823 Retrying the installation of the LCU.  This is necessary to ensure the SSU is installed properly" -Verbose
                Add-WindowsPackage -Path "$MountDirectory" -PackagePath "$UpdateLCU" -LogPath "$CurrentLog" | Out-Null
            } #>
            else {
                Write-Verbose "OSDBuilder: Review the log for more information" -Verbose
            }
            Write-Verbose "$CurrentLog" -Verbose
        }
    }
}
function Update-CumulativePE {
    [CmdletBinding()]
    param (
        [switch]$Force
    )
    #=================================================
    #   Abort
    #=================================================
    if ($SkipUpdates) {Return}
    if ($SkipUpdatesPE) {Return}
    if ($SkipUpdatesPELCU) {Return}
    if ($null -eq $OSDUpdateLCU) {Return}
    #=================================================
    #   Update WinPE
    #=================================================
    if ($OSMajorVersion -ne 10) {
        $OSDUpdateLCU = $OSDUpdateLCU | Where-Object {$_.OSDWinPE -eq $true}
        if ($Force.IsPresent) {Return}
    }
    Show-ActionTime
    Write-Host -ForegroundColor Green "WinPE: (LCU) Latest Cumulative Update"
    Write-Warning "Skipping WinPE LCU Update for this version of Windows"
    Return
    if ($OSBuild -ge 18362) {
        Write-Warning "Skipping WinPE LCU Update for this version of Windows"
        Return
    }

    foreach ($Update in $OSDUpdateLCU) {
        $UpdateLCU = $(Get-ChildItem -Path $SetOSDBuilderPathUpdates -File -Recurse | Where-Object {$_.Name -match $(Split-Path $Update.OriginUri -Leaf)}).FullName | Select-Object -First 1
        if ($null -eq $UpdateLCU) {Write-Warning "Update-CumulativePE is Null"; Continue}
        if (!(Test-Path "$UpdateLCU")) {Write-Warning "Update-CumulativePE was not found"; Continue}

        if (! ($Force.IsPresent)) {
            if (Get-SessionsXml -Path $MountWinPE -KBNumber $Update.FileKBNumber | Where-Object {$_.TargetState -eq 'Installed'}) {
                Write-Host -ForegroundColor Gray "INSTALLED         $($Update.Title) - $(Split-Path $Update.OriginUri -Leaf)"; Continue
            }
            if (Get-WindowsPackage -Path "$MountWinPE" | Where-Object {$_.PackageName -match "$($Update.FileKBNumber)"}) {
                Write-Host -ForegroundColor Gray "INSTALLED         $($Update.Title) - $(Split-Path $Update.OriginUri -Leaf)"; Continue
            }
        }

        Write-Host -ForegroundColor Cyan "INSTALLING        " -NoNewline
        Write-Host -ForegroundColor Gray "$($Update.Title) - $(Split-Path $Update.OriginUri -Leaf)"

        $CurrentLog = "$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Add-WindowsPackageSSU-KB$($Update.KBNumber)-WinPE.log"
        Write-Verbose "CurrentLog: $CurrentLog"
        
        Add-WindowsPackageSSU -Path "$MountDirectory" -PackagePath "$UpdateLCU" -LogPath "$CurrentLog" | Out-Null

        $CurrentLog = "$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Update-CumulativePE-KB$($Update.KBNumber)-WinPE.log"
        Write-Verbose "CurrentLog: $CurrentLog"

        Try {Add-WindowsPackage -Path "$MountWinPE" -PackagePath "$UpdateLCU" -LogPath "$CurrentLog" | Out-Null}
        Catch {
            if ($_.Exception.Message -match '0x800f081e') {Write-Verbose "OSDBuilder: 0x800f081e The package is not applicable to this image" -Verbose}
            Write-Verbose "OSDBuilder: Review the log for more information" -Verbose
            Write-Verbose "$CurrentLog" -Verbose
        }

        if (!($OSVersion -like "6.1.7601.*")) {
            $CurrentLog = "$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-DismCleanupImage-WinPE.log"
            Write-Verbose "CurrentLog: $CurrentLog"
            if ($SkipComponentCleanup) {
                Write-Warning "Skip: -SkipComponentCleanup Parameter was used"
            } else {
                Dism /Image:"$MountWinPE" /Cleanup-Image /StartComponentCleanup /ResetBase /LogPath:"$CurrentLog" | Out-Null
            }
        }
    }
    #=================================================
    #   Update WinRE
    #=================================================
    Show-ActionTime
    Write-Host -ForegroundColor Green "WinRE: (LCU) Latest Cumulative Update"
    foreach ($Update in $OSDUpdateLCU) {
        $UpdateLCU = $(Get-ChildItem -Path $SetOSDBuilderPathUpdates -File -Recurse | Where-Object {$_.Name -match $(Split-Path $Update.OriginUri -Leaf)}).FullName | Select-Object -First 1
        if ($null -eq $UpdateLCU) {Write-Warning "Update-CumulativePE is Null"; Continue}
        if (!(Test-Path "$UpdateLCU")) {Write-Warning "Update-CumulativePE was not found"; Continue}

        if (! ($Force.IsPresent)) {
            if (Get-SessionsXml -Path $MountWinRE -KBNumber $Update.FileKBNumber | Where-Object {$_.TargetState -eq 'Installed'}) {
                Write-Host -ForegroundColor Gray "INSTALLED         $($Update.Title) - $(Split-Path $Update.OriginUri -Leaf)"; Continue
            }
            if (Get-WindowsPackage -Path "$MountWinRE" | Where-Object {$_.PackageName -match "$($Update.FileKBNumber)"}) {
                Write-Host -ForegroundColor Gray "INSTALLED         $($Update.Title) - $(Split-Path $Update.OriginUri -Leaf)"; Continue
            }
        }

        Write-Host -ForegroundColor Cyan "INSTALLING        " -NoNewline
        Write-Host -ForegroundColor Gray "$($Update.Title) - $(Split-Path $Update.OriginUri -Leaf)"

        $CurrentLog = "$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Update-CumulativePE-KB$($Update.KBNumber)-WinRE.log"
        Write-Verbose "CurrentLog: $CurrentLog"
        Try {Add-WindowsPackage -Path "$MountWinRE" -PackagePath "$UpdateLCU" -LogPath "$CurrentLog" | Out-Null}
        Catch {
            if ($_.Exception.Message -match '0x800f081e') {Write-Verbose "OSDBuilder: 0x800f081e The package is not applicable to this image" -Verbose}
            Write-Verbose "OSDBuilder: Review the log for more information" -Verbose
            Write-Verbose "$CurrentLog" -Verbose
        }
        if (!($OSVersion -like "6.1.7601.*")) {
            $CurrentLog = "$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-DismCleanupImage-WinRE.log"
            Write-Verbose "CurrentLog: $CurrentLog"
            if ($SkipComponentCleanup) {
                Write-Warning "Skip: -SkipComponentCleanup Parameter was used"
            } else {
                Dism /Image:"$MountWinRE" /Cleanup-Image /StartComponentCleanup /ResetBase /LogPath:"$CurrentLog" | Out-Null
            }
        }
    }

    if ($SkipUpdatesWinSE) {Return}
    #=================================================
    #   Update WinSE
    #=================================================
    Show-ActionTime
    Write-Host -ForegroundColor Green "WinSE: (LCU) Latest Cumulative Update"
    
    if (($OSMajorVersion -eq 10) -and ($ReleaseId -ge 1903)) {Write-Warning 'Not adding LCU to WinSE to resolve Setup issues'; Return}
    foreach ($Update in $OSDUpdateLCU) {
        $UpdateLCU = $(Get-ChildItem -Path $SetOSDBuilderPathUpdates -File -Recurse | Where-Object {$_.Name -match $(Split-Path $Update.OriginUri -Leaf)}).FullName | Select-Object -First 1
        if ($null -eq $UpdateLCU) {Write-Warning "Update-CumulativePE is Null"; Continue}
        if (!(Test-Path "$UpdateLCU")) {Write-Warning "Update-CumulativePE was not found"; Continue}

        if (! ($Force.IsPresent)) {
            if (Get-SessionsXml -Path $MountWinSE -KBNumber $Update.FileKBNumber | Where-Object {$_.TargetState -eq 'Installed'}) {
                Write-Host -ForegroundColor Gray "INSTALLED         $($Update.Title) - $(Split-Path $Update.OriginUri -Leaf)"; Continue
            }
            if (Get-WindowsPackage -Path "$MountWinSE" | Where-Object {$_.PackageName -match "$($Update.FileKBNumber)"}) {
                Write-Host -ForegroundColor Gray "INSTALLED         $($Update.Title) - $(Split-Path $Update.OriginUri -Leaf)"; Continue
            }
        }

        Write-Host -ForegroundColor Cyan "INSTALLING        " -NoNewline
        Write-Host -ForegroundColor Gray "$($Update.Title) - $(Split-Path $Update.OriginUri -Leaf)"

        $CurrentLog = "$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Update-CumulativePE-KB$($Update.KBNumber)-WinSE.log"
        Write-Verbose "CurrentLog: $CurrentLog"
        Try {Add-WindowsPackage -Path "$MountWinSE" -PackagePath "$UpdateLCU" -LogPath "$CurrentLog" | Out-Null}
        Catch {
            if ($_.Exception.Message -match '0x800f081e') {Write-Verbose "OSDBuilder: 0x800f081e The package is not applicable to this image" -Verbose}
            Write-Verbose "OSDBuilder: Review the log for more information" -Verbose
            Write-Verbose "$CurrentLog" -Verbose
        }
        if (!($OSVersion -like "6.1.7601.*")) {
            $CurrentLog = "$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-DismCleanupImage-WinSE.log"
            Write-Verbose "CurrentLog: $CurrentLog"
            if ($SkipComponentCleanup) {
                Write-Warning "Skip: -SkipComponentCleanup Parameter was used"
            } else {
                Dism /Image:"$MountWinSE" /Cleanup-Image /StartComponentCleanup /ResetBase /LogPath:"$CurrentLog" | Out-Null
            }
        }
    }
}
function Update-DotNetOS {
    [CmdletBinding()]
    param (
        [switch]$Force
    )
    #=================================================
    #   Abort
    #=================================================
    if ($SkipUpdates) {Return}
    if ($SkipUpdatesOS) {Return}
    if ($OSMajorVersion -ne 10) {Return}
    if ($null -eq $OSDUpdateDotNet) {Return}
    #=================================================
    #   Header
    #=================================================
    Show-ActionTime
    if ($Force.IsPresent) {
        Write-Host -ForegroundColor Green "OS: (NetCU) DotNet Framework Cumulative Update (Forced)"
    } else {
        Write-Host -ForegroundColor Green "OS: (NetCU) DotNet Framework Cumulative Update"
    }
    #=================================================
    #   Execute DotNet
    #=================================================
    $OSDUpdateDotNet = $OSDUpdateDotNet | Sort-Object FileKBNumber
    foreach ($Update in $OSDUpdateDotNet | Where-Object {$_.UpdateGroup -eq 'DotNet'}) {
        $UpdateNetCU = $(Get-ChildItem -Path $SetOSDBuilderPathUpdates -File -Recurse | Where-Object {$_.Name -match $(Split-Path $Update.OriginUri -Leaf)}).FullName | Select-Object -First 1
        if ($null -eq $UpdateNetCU) {Write-Warning "Update-DotNetOS is Null"; Continue}
        if (!(Test-Path "$UpdateNetCU")) {Write-Warning "Update-DotNetOS was not found"; Continue}
        
        if (! ($Force.IsPresent)) {
            if (Get-SessionsXml -Path $MountDirectory -KBNumber $Update.FileKBNumber | Where-Object {$_.TargetState -eq 'Installed'}) {
                Write-Host -ForegroundColor Gray "INSTALLED         $($Update.Title) - $(Split-Path $Update.OriginUri -Leaf)"; Continue
            }
            if (Get-WindowsPackage -Path "$MountDirectory" | Where-Object {$_.PackageName -match "$($Update.FileKBNumber)"}) {
                Write-Host -ForegroundColor Gray "INSTALLED         $($Update.Title) - $(Split-Path $Update.OriginUri -Leaf)"; Continue
            }
        }
        
        Write-Host -ForegroundColor Cyan "INSTALLING        " -NoNewline
        Write-Host -ForegroundColor Gray "$($Update.Title) - $(Split-Path $Update.OriginUri -Leaf)"

        $CurrentLog = "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Update-DotNetOS-KB$($Update.FileKBNumber).log"
        Write-Verbose "CurrentLog: $CurrentLog"
        Try {Add-WindowsPackage -Path "$MountDirectory" -PackagePath "$UpdateNetCU" -LogPath "$CurrentLog" | Out-Null}
        Catch {
            if ($_.Exception.Message -match '0x800f081e') {Write-Verbose "OSDBuilder: 0x800f081e The package is not applicable to this image" -Verbose}
            if ($_.Exception.Message -match '0x8007371b') {
                Write-Verbose "OSDBuilder: 0x8007371b ERROR_SXS_TRANSACTION_CLOSURE_INCOMPLETE" -Verbose
                Write-Verbose "One or more required members of the transaction are not present" -Verbose
                Write-Verbose "Since this is a DotNet Update, it is quite possible this won't install until you enable a DotNet Feature like NetFX 3.5" -Verbose
            }
            Write-Verbose "OSDBuilder: Review the log for more information" -Verbose
            Write-Verbose "$CurrentLog" -Verbose
        }
    }
    #=================================================
    #   Execute DotNetCU
    #=================================================
    foreach ($Update in $OSDUpdateDotNet | Where-Object {$_.UpdateGroup -eq 'DotNetCU'}) {
        $UpdateNetCU = $(Get-ChildItem -Path $SetOSDBuilderPathUpdates -File -Recurse | Where-Object {$_.Name -match $(Split-Path $Update.OriginUri -Leaf)}).FullName | Select-Object -First 1
        if ($null -eq $UpdateNetCU) {Write-Warning "Update-DotNetOS is Null"; Continue}
        if (!(Test-Path "$UpdateNetCU")) {Write-Warning "Update-DotNetOS was not found"; Continue}
        
        if (! ($Force.IsPresent)) {
            if (Get-SessionsXml -Path $MountDirectory -KBNumber $Update.FileKBNumber | Where-Object {$_.TargetState -eq 'Installed'}) {
                Write-Host -ForegroundColor Gray "INSTALLED         $($Update.Title) - $(Split-Path $Update.OriginUri -Leaf)"; Continue
            }
            if (Get-WindowsPackage -Path "$MountDirectory" | Where-Object {$_.PackageName -match "$($Update.FileKBNumber)"}) {
                Write-Host -ForegroundColor Gray "INSTALLED         $($Update.Title) - $(Split-Path $Update.OriginUri -Leaf)"; Continue
            }
        }
        
        Write-Host -ForegroundColor Cyan "INSTALLING        " -NoNewline
        Write-Host -ForegroundColor Gray "$($Update.Title) - $(Split-Path $Update.OriginUri -Leaf)"

        $CurrentLog = "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Update-DotNetOS-KB$($Update.FileKBNumber).log"
        Write-Verbose "CurrentLog: $CurrentLog"
        Try {Add-WindowsPackage -Path "$MountDirectory" -PackagePath "$UpdateNetCU" -LogPath "$CurrentLog" | Out-Null}
        Catch {
            if ($_.Exception.Message -match '0x800f081e') {
                Write-Verbose "OSDBuilder: 0x800f081e The package is not applicable to this image" -Verbose
            }
            if ($_.Exception.Message -match '0x8007371b') {
                Write-Verbose "OSDBuilder: 0x8007371b ERROR_SXS_TRANSACTION_CLOSURE_INCOMPLETE" -Verbose
                Write-Verbose "One or more required members of the transaction are not present" -Verbose
                Write-Verbose "Since this is a DotNet Update, it is quite possible this won't install until you enable a DotNet Feature like NetFX 3.5" -Verbose
            }
            Write-Verbose "OSDBuilder: Review the log for more information" -Verbose
            Write-Verbose "$CurrentLog" -Verbose
        }
    }
}
function Update-LangIniMEDIA {
    [CmdletBinding()]
    param (
        [string]$OSMediaPath
    )
    #=================================================
    #   WinSE.wim
    #=================================================
    Show-ActionTime; Write-Host -ForegroundColor Green "WinSE: Updating WinSE.wim with updated Lang.ini"
    $MountWinSELangIni = Join-Path $SetOSDBuilderPathMount "winselangini$((Get-Date).ToString('hhmmss'))"
    if (!(Test-Path "$MountWinSELangIni")) {New-Item "$MountWinSELangIni" -ItemType Directory -Force | Out-Null}
    $CurrentLog = "$OSMediaPath\WinPE\info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Mount-WinSELangIni.log"
    Mount-WindowsImage -ImagePath "$OSMediaPath\WinPE\winse.wim" -Index 1 -Path "$MountWinSELangIni" -LogPath "$CurrentLog" | Out-Null

    Copy-Item -Path "$OS\Sources\lang.ini" -Destination "$MountWinSELangIni\Sources" -Force | Out-Null

    Start-Sleep -Seconds 10
    $CurrentLog = "$OSMediaPath\WinPE\info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Dismount-WinSELangIni.log"
    try {Dismount-WindowsImage -Path "$MountWinSELangIni" -Save -LogPath "$CurrentLog" -ErrorAction SilentlyContinue | Out-Null}
    catch {
        Write-Warning "Could not dismount WinSE.wim ... Waiting 30 seconds ..."
        Start-Sleep -Seconds 30
        Dismount-WindowsImage -Path "$MountWinSELangIni" -Save -LogPath "$CurrentLog" | Out-Null
    }
    if (Test-Path "$MountWinSELangIni") {Remove-Item -Path "$MountWinSELangIni" -Force -Recurse | Out-Null}
    #=================================================
    #   Boot.wim
    #=================================================
    Show-ActionTime; Write-Host -ForegroundColor Green "Boot: Updating Boot.wim (Index 2 - Windows Setup Environment) with updated Lang.ini"
    $MountBootLangIni = Join-Path $SetOSDBuilderPathMount "bootlangini$((Get-Date).ToString('hhmmss'))"
    if (!(Test-Path "$MountBootLangIni")) {New-Item "$MountBootLangIni" -ItemType Directory -Force | Out-Null}
    $CurrentLog = "$OSMediaPath\WinPE\info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Mount-BootLangIni.log"
    Mount-WindowsImage -ImagePath "$OS\Sources\boot.wim" -Index 2 -Path "$MountBootLangIni" -LogPath "$CurrentLog" | Out-Null
    Copy-Item -Path "$OS\Sources\lang.ini" -Destination "$MountBootLangIni\Sources" -Force | Out-Null
    Start-Sleep -Seconds 10
    $CurrentLog = "$OSMediaPath\WinPE\info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Dismount-BootLangIni.log"
    try {Dismount-WindowsImage -Path "$MountBootLangIni" -Save -LogPath "$CurrentLog" -ErrorAction SilentlyContinue | Out-Null}
    catch {
        Write-Warning "Could not dismount Boot.wim ... Waiting 30 seconds ..."
        Start-Sleep -Seconds 30
        Dismount-WindowsImage -Path "$MountBootLangIni" -Save -LogPath "$CurrentLog" | Out-Null
    }
    if (Test-Path "$MountBootLangIni") {Remove-Item -Path "$MountBootLangIni" -Force -Recurse | Out-Null}
}
function Update-ModuleOSDBuilder {
    [CmdletBinding()]
    param (
        [switch]$CurrentUser
    )
    #=================================================
    #   Uninstall-Module
    #=================================================
    Write-Warning "Uninstall-Module -Name OSDBuilder -AllVersions -Force"
    try {Uninstall-Module -Name OSDBuilder -AllVersions -Force -ErrorAction SilentlyContinue}
    catch {}
    #=================================================
    #   Remove-Module
    #=================================================
    Write-Warning "Remove-Module -Name OSDBuilder -Force"
    try {Remove-Module -Name OSDBuilder -Force -ErrorAction SilentlyContinue}
    catch {}
    #=================================================
    #   Install-Module
    #=================================================
    if ($CurrentUser.IsPresent) {
        Write-Warning "Install-Module -Name OSDBuilder -Scope CurrentUser -Force"
        try {Install-Module -Name OSDBuilder -Scope CurrentUser -Force -ErrorAction SilentlyContinue}
        catch {}
    } else {
        Write-Warning "Install-Module -Name OSDBuilder -Force"
        try {Install-Module -Name OSDBuilder -Force -ErrorAction SilentlyContinue}
        catch {}
    }
    #=================================================
    #   Import-Module
    #=================================================
    Write-Warning "Import-Module -Name OSDBuilder -Force"
    try {Import-Module -Name OSDBuilder -Force -ErrorAction SilentlyContinue}
    catch {}
    #=================================================
    #   Close PowerShell
    #=================================================
    Write-Warning "Close all open PowerShell sessions before using OSDBuilder"
}
function Update-OptionalOS {
    [CmdletBinding()]
    param ()
    #=================================================
    #   Abort
    #=================================================
    if ($ScriptName -ne 'New-OSBuild') {Return}
    if ($SkipUpdates) {Return}
    if ($SkipUpdatesOS) {Return}
    if ($OSMajorVersion -ne 10) {Return}
    if ($null -eq $OSDUpdateOptional) {Return}
    #=================================================
    #   Header
    #=================================================
    Show-ActionTime
    Write-Host -ForegroundColor Green "OS: Optional Updates"
    #=================================================
    #   Execute
    #=================================================
    foreach ($Update in $OSDUpdateOptional) {
        $UpdateOptional = $(Get-ChildItem -Path $SetOSDBuilderPathUpdates -File -Recurse | Where-Object {$_.Name -match $(Split-Path $Update.OriginUri -Leaf)}).FullName | Select-Object -First 1
        if ($null -eq $UpdateOptional) {Write-Warning "Update-OptionalOS is Null"; Continue}
        if (!(Test-Path "$UpdateOptional")) {Write-Warning "Update-OptionalOS was not found"; Continue}

        if (! ($Force.IsPresent)) {
            if (Get-SessionsXml -Path $MountDirectory -KBNumber $Update.FileKBNumber | Where-Object {$_.TargetState -eq 'Installed'}) {
                Write-Host -ForegroundColor Gray "INSTALLED         $($Update.Title) - $(Split-Path $Update.OriginUri -Leaf)"; Continue
            }
            if (Get-WindowsPackage -Path "$MountDirectory" | Where-Object {$_.PackageName -match "$($Update.FileKBNumber)"}) {
                Write-Host -ForegroundColor Gray "INSTALLED         $($Update.Title) - $(Split-Path $Update.OriginUri -Leaf)"; Continue
            }
        }

        Write-Host -ForegroundColor Cyan "INSTALLING        " -NoNewline
        Write-Host -ForegroundColor Gray "$($Update.Title) - $(Split-Path $Update.OriginUri -Leaf)"

        $CurrentLog = "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Update-OptionalOS-KB$($Update.FileKBNumber).log"
        Write-Verbose "CurrentLog: $CurrentLog"
        Try {Add-WindowsPackage -Path "$MountDirectory" -PackagePath "$UpdateOptional" -LogPath "$CurrentLog" | Out-Null}
        Catch {
            if ($_.Exception.Message -match '0x800f081e') {Write-Verbose "OSDBuilder: 0x800f081e The package is not applicable to this image" -Verbose}
            Write-Verbose "$CurrentLog" -Verbose
        }
    }
}
function Update-ServicingStackOS {
    [CmdletBinding()]
    param (
        [switch]$Force
    )
    #=================================================
    #   Abort
    #=================================================
    if ($SkipUpdates) {Return}
    if ($SkipUpdatesOS) {Return}
    if ($SkipUpdatesOSSSU) {Return}
    if ($OSMajorVersion -ne 10) {Return}
    if ($null -eq $OSDUpdateSSU) {Return}
    #=================================================
    #   Header
    #=================================================
    Show-ActionTime
    if ($Force.IsPresent) {
        Write-Host -ForegroundColor Green "OS: (SSU) Servicing Stack Update (Forced)"
    } else {
        Write-Host -ForegroundColor Green "OS: (SSU) Servicing Stack Update"
    }
    #=================================================
    #   Execute
    #=================================================
    foreach ($Update in $OSDUpdateSSU) {
        $UpdateSSU = $(Get-ChildItem -Path $SetOSDBuilderPathUpdates -File -Recurse | Where-Object {$_.Name -match $(Split-Path $Update.OriginUri -Leaf)}).FullName | Select-Object -First 1
        if ($null -eq $UpdateSSU) {Write-Warning "Update-ServicingStackOS is Null"; Continue}
        if (!(Test-Path "$UpdateSSU")) {Write-Warning "Update-ServicingStackOS was not found"; Continue}

        if (! ($Force.IsPresent)) {
            if (Get-SessionsXml -Path $MountDirectory -KBNumber $Update.FileKBNumber | Where-Object {$_.TargetState -eq 'Installed'}) {
                Write-Host -ForegroundColor Gray "INSTALLED         $($Update.Title) - $(Split-Path $Update.OriginUri -Leaf)"; Continue
            }
            if (Get-WindowsPackage -Path "$MountDirectory" | Where-Object {$_.PackageName -match "$($Update.FileKBNumber)"}) {
                Write-Host -ForegroundColor Gray "INSTALLED         $($Update.Title) - $(Split-Path $Update.OriginUri -Leaf)"; Continue
            }
        }

        Write-Host -ForegroundColor Cyan "INSTALLING        " -NoNewline
        Write-Host -ForegroundColor Gray "$($Update.Title) - $(Split-Path $Update.OriginUri -Leaf)"

        $CurrentLog = "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Update-ServicingStackOS-KB$($Update.FileKBNumber).log"
        Write-Verbose "CurrentLog: $CurrentLog"
        Try {Add-WindowsPackage -Path "$MountDirectory" -PackagePath "$UpdateSSU" -LogPath "$CurrentLog" | Out-Null}
        Catch {
            if ($_.Exception.Message -match '0x800f081e') {Write-Verbose "OSDBuilder: 0x800f081e The package is not applicable to this image" -Verbose}
            Write-Verbose "OSDBuilder: Review the log for more information" -Verbose
            Write-Verbose "$CurrentLog" -Verbose
        }
    }
}
function Update-ServicingStackPE {
    [CmdletBinding()]
    param (
        [switch]$Force
    )
    #=================================================
    #   Abort
    #=================================================
    if ($SkipUpdates) {Return}
    if ($SkipUpdatesPE) {Return}
    if ($SkipUpdatesPESSU) {Return}
    #if ($OSMajorVersion -ne 10) {Return}
    if ($null -eq $OSDUpdateSSU) {Return}
    #=================================================
    #   Update WinPE
    #=================================================
    if ($OSMajorVersion -ne 10) {
        $OSDUpdateSSU = $OSDUpdateSSU | Where-Object {$_.OSDWinPE -eq $true}
        if ($Force.IsPresent) {Return}
    }
    Show-ActionTime
    Write-Host -ForegroundColor Green "WinPE: (SSU) Servicing Stack Update"
    Write-Warning "Skipping WinPE SSU Update for this version of Windows"
    Return
    if ($OSBuild -ge 18362) {
        Write-Warning "Skipping WinPE SSU Update for this version of Windows"
        Return
    }

    foreach ($Update in $OSDUpdateSSU) {
        $UpdateSSU = $(Get-ChildItem -Path $SetOSDBuilderPathUpdates -File -Recurse | Where-Object {$_.Name -match $(Split-Path $Update.OriginUri -Leaf)}).FullName | Select-Object -First 1
        if ($null -eq $UpdateSSU) {Write-Warning "Update-ServicingStackPE is Null"; Continue}
        if (!(Test-Path "$UpdateSSU")) {Write-Warning "Update-ServicingStackPE was not found"; Continue}

        if (! ($Force.IsPresent)) {
            if (Get-SessionsXml -Path $MountWinPE -KBNumber $Update.FileKBNumber | Where-Object {$_.TargetState -eq 'Installed'}) {
                Write-Host -ForegroundColor Gray "INSTALLED         $($Update.Title) - $(Split-Path $Update.OriginUri -Leaf)"; Continue
            }
            if (Get-WindowsPackage -Path "$MountWinPE" | Where-Object {$_.PackageName -match "$($Update.FileKBNumber)"}) {
                Write-Host -ForegroundColor Gray "INSTALLED         $($Update.Title) - $(Split-Path $Update.OriginUri -Leaf)"; Continue
            }
        }

        Write-Host -ForegroundColor Cyan "INSTALLING        " -NoNewline
        Write-Host -ForegroundColor Gray "$($Update.Title) - $(Split-Path $Update.OriginUri -Leaf)"

        $CurrentLog = "$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Update-ServicingStackPE-KB$($Update.KBNumber)-WinPE.log"
        Write-Verbose "CurrentLog: $CurrentLog"
        Try {Add-WindowsPackage -Path "$MountWinPE" -PackagePath "$UpdateSSU" -LogPath "$CurrentLog" | Out-Null}
        Catch {
            if ($_.Exception.Message -match '0x800f081e') {Write-Verbose "OSDBuilder: 0x800f081e The package is not applicable to this image" -Verbose}
            Write-Verbose "OSDBuilder: Review the log for more information" -Verbose
            Write-Verbose "$CurrentLog" -Verbose
        }
    }
    #=================================================
    #   Update WinRE
    #=================================================
    Show-ActionTime
    Write-Host -ForegroundColor Green "WinRE: (SSU) Servicing Stack Update"
    foreach ($Update in $OSDUpdateSSU) {
        $UpdateSSU = $(Get-ChildItem -Path $SetOSDBuilderPathUpdates -File -Recurse | Where-Object {$_.Name -match $(Split-Path $Update.OriginUri -Leaf)}).FullName | Select-Object -First 1
        if ($null -eq $UpdateSSU) {Write-Warning "Update-ServicingStackPE is Null"; Continue}
        if (!(Test-Path "$UpdateSSU")) {Write-Warning "Update-ServicingStackPE was not found"; Continue}

        if (! ($Force.IsPresent)) {
            if (Get-SessionsXml -Path $MountWinRE -KBNumber $Update.FileKBNumber | Where-Object {$_.TargetState -eq 'Installed'}) {
                Write-Host -ForegroundColor Gray "INSTALLED         $($Update.Title) - $(Split-Path $Update.OriginUri -Leaf)"; Continue
            }
            if (Get-WindowsPackage -Path "$MountWinRE" | Where-Object {$_.PackageName -match "$($Update.FileKBNumber)"}) {
                Write-Host -ForegroundColor Gray "INSTALLED         $($Update.Title) - $(Split-Path $Update.OriginUri -Leaf)"; Continue
            }
        }

        Write-Host -ForegroundColor Cyan "INSTALLING        " -NoNewline
        Write-Host -ForegroundColor Gray "$($Update.Title) - $(Split-Path $Update.OriginUri -Leaf)"
        
        $CurrentLog = "$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Update-ServicingStackPE-KB$($Update.KBNumber)-WinRE.log"
        Write-Verbose "CurrentLog: $CurrentLog"
        Try {Add-WindowsPackage -Path "$MountWinRE" -PackagePath "$UpdateSSU" -LogPath "$CurrentLog" | Out-Null}
        Catch {
            $ErrorMessage = $_.Exception.$ErrorMessage
            Write-Warning "$CurrentLog"
            Write-Host "$ErrorMessage"
            if ($ErrorMessage -like "*0x800f081e*") {Write-Warning "Update not applicable to this Operating System"}
        }
    }
    #=================================================
    #   Update WinSE
    #=================================================
    Show-ActionTime
    Write-Host -ForegroundColor Green "WinSE: (SSU) Servicing Stack Update"
    foreach ($Update in $OSDUpdateSSU) {
        $UpdateSSU = $(Get-ChildItem -Path $SetOSDBuilderPathUpdates -File -Recurse | Where-Object {$_.Name -match $(Split-Path $Update.OriginUri -Leaf)}).FullName | Select-Object -First 1
        if ($null -eq $UpdateSSU) {Write-Warning "Update-ServicingStackPE is Null"; Continue}
        if (!(Test-Path "$UpdateSSU")) {Write-Warning "Update-ServicingStackPE was not found"; Continue}

        if (! ($Force.IsPresent)) {
            if (Get-SessionsXml -Path $MountWinSE -KBNumber $Update.FileKBNumber | Where-Object {$_.TargetState -eq 'Installed'}) {
                Write-Host -ForegroundColor Gray "INSTALLED         $($Update.Title) - $(Split-Path $Update.OriginUri -Leaf)"; Continue
            }
            if (Get-WindowsPackage -Path "$MountWinSE" | Where-Object {$_.PackageName -match "$($Update.FileKBNumber)"}) {
                Write-Host -ForegroundColor Gray "INSTALLED         $($Update.Title) - $(Split-Path $Update.OriginUri -Leaf)"; Continue
            }
        }

        Write-Host -ForegroundColor Cyan "INSTALLING        " -NoNewline
        Write-Host -ForegroundColor Gray "$($Update.Title) - $(Split-Path $Update.OriginUri -Leaf)"
        
        $CurrentLog = "$PEInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Update-ServicingStackPE-KB$($Update.KBNumber)-WinSE.log"
        Write-Verbose "CurrentLog: $CurrentLog"
        Try {Add-WindowsPackage -Path "$MountWinSE" -PackagePath "$UpdateSSU" -LogPath "$CurrentLog" | Out-Null}
        Catch {
            if ($_.Exception.Message -match '0x800f081e') {Write-Verbose "OSDBuilder: 0x800f081e The package is not applicable to this image" -Verbose}
            Write-Verbose "OSDBuilder: Review the log for more information" -Verbose
            Write-Verbose "$CurrentLog" -Verbose
        }
    }
}
function Update-SetupDUMEDIA {
    [CmdletBinding()]
    param ()
    #=================================================
    #   Changelog
    #=================================================
    #19.10.14 Resolved issue with color for Update FileName
    #21.3.8 Apply update to WinSE
    #=================================================
    #   Abort
    #=================================================
    if ($SkipUpdates) {Return}
    if ($SkipSetupDU) {Return}
    if ($null -eq $OSDUpdateSetupDU) {Return}
    #=================================================
    #   Header
    #=================================================
    Show-ActionTime
    Write-Host -ForegroundColor Green "MEDIA: (SetupDU) Windows Setup Dynamic Update"
    #=================================================
    #   Execute
    #=================================================
    foreach ($Update in $OSDUpdateSetupDU) {
        $UpdateSetupDU = $(Get-ChildItem -Path $SetOSDBuilderPathUpdates -File -Recurse | Where-Object {$_.Name -match $(Split-Path $Update.OriginUri -Leaf)}).FullName | Select-Object -First 1
        if ($null -eq $UpdateSetupDU) {Continue}
        if (!(Test-Path "$UpdateSetupDU")) {Write-Warning "Not Found: $UpdateSetupDU"; Continue}

        Write-Host -ForegroundColor Cyan "INSTALLING        " -NoNewline
        Write-Host -ForegroundColor Gray "$($Update.Title) - $(Split-Path $Update.OriginUri -Leaf)"

        $TempRandom = "$env:TEMP\$(Get-Random)"
        if (-NOT (Test-Path $TempRandom)) {
            New-Item -Path $TempRandom -ItemType Directory -Force | Out-Null
        }

        Write-Host -ForegroundColor Cyan "Expanding to temporary path $TempRandom"
        expand.exe "$UpdateSetupDU" -F:*.* "$TempRandom"

        Write-Host "Logging to $Logs"

        Write-Host -ForegroundColor Cyan "Applying update to WinSE at $OS\Sources"
        robocopy "$TempRandom" "$OS\Sources" *.* /s /ndl /xo /xx /xl /b /np /ts /tee /r:0 /w:0 /Log+:"$Logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Robocopy-Media-SetupDU.log" | Out-Null

        Write-Host -ForegroundColor Cyan "Applying update to WinSE at $MountWinSE\Sources"
        robocopy "$TempRandom" "$MountWinSE\Sources" *.* /s /ndl /xo /xx /xl /b /np /ts /tee /r:0 /w:0 /Log+:"$Logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Robocopy-WinSE-SetupDU.log" | Out-Null

        #expand.exe "$UpdateSetupDU" -F:*.* "$OS\Sources"
        #expand.exe "$UpdateSetupDU" -F:*.* "$MountWinSE\Sources"
        #pause
    }
}
function Update-SourcesPE {
    [CmdletBinding()]
    param (
        [string]$OSMediaPath
    )
    #=================================================
    #   Abort
    #=================================================
    if ($SkipUpdates) {Return}
    if ($SkipUpdatesPE) {Return}
    if ($SkipUpdatesOS) {Return}
    if ($ReleaseId -ge 1903) {Return}
    #=================================================
    #   Header
    #=================================================
    Show-ActionTime; Write-Host -ForegroundColor Green "MEDIA: Update Media Sources with WinSE.wim"
    #=================================================
    #   Warning
    #=================================================
    if ($OSBuild -ge 18362) {
        Write-Warning "Skipping WinPE Update for this version of Windows"
        Return
    }
    if ($ReleaseId -ge 1903) {
        Write-Warning "This step is currently disabled for Windows 10 1903"
        Write-Warning "If this is the first time you are seeing this warning,"
        Write-Warning "you should Update-OSMedia from Windows 10 1903 18362.30"
        Return
    }
    #=================================================
    #   Execute
    #=================================================
    robocopy "$MountWinSE\sources" "$OSMediaPath\OS\sources" setup.exe /ndl /xo /xx /xl /b /np /ts /tee /r:0 /w:0 /Log+:"$OSMediaPath\info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Robocopy-WinSE-MediaSources.log" | Out-Null
    robocopy "$MountWinSE\sources" "$OSMediaPath\OS\sources" setuphost.exe /ndl /xo /xx /xl /b /np /ts /tee /r:0 /w:0 /Log+:"$OSMediaPath\info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Robocopy-WinSE-MediaSources.log" | Out-Null
}
function Update-WindowsServer2012R2OS {
    [CmdletBinding()]
    param ()
    #=================================================
    #   Abort
    #=================================================
    if ($ScriptName -ne 'Update-OSMedia') {Return}
    if ($SkipUpdates) {Return}
    if ($OSMajorVersion -eq 10) {Return}
    if ($null -eq $OSDUpdateWinTwelveR2) {Return}
    #=================================================
    #   Header
    #=================================================
    Show-ActionTime
    Write-Host -ForegroundColor Green "OS: Windows Server 2012 R2 Updates"
    $SessionsXmlInstall = "$MountDirectory\Windows\Servicing\Sessions\Sessions.xml"
    if (Test-Path $SessionsXmlInstall) {
        [xml]$XmlDocument = Get-Content -Path $SessionsXmlInstall
    }
    #=================================================
    #   Execute
    #=================================================
    foreach ($Update in $OSDUpdateWinTwelveR2) {
        $UpdateTwelveR2 = $(Get-ChildItem -Path $SetOSDBuilderPathUpdates -File -Recurse | Where-Object {$_.Name -match $(Split-Path $Update.OriginUri -Leaf)}).FullName | Select-Object -First 1
        $UpdateTwelveR2 = $UpdateTwelveR2 | Select-Object -First 1
        
        if ($null -eq $UpdateTwelveR2) {Continue}
        if (!(Test-Path "$UpdateTwelveR2")) {Write-Warning "Not Found: $UpdateTwelveR2"; Continue}
        
        
        if (Test-Path $SessionsXmlInstall) {
            if ($null -eq $Update.FileKBNumber) {
                if ($XmlDocument.Sessions.Session.Tasks.Phase.package | Where-Object {$_.Name -like "*$($Update.KBNumber)*" -and $_.targetState -eq 'Installed'}) {
                    Write-Host -ForegroundColor Gray "INSTALLED         $($Update.Title) - $(Split-Path $Update.OriginUri -Leaf)"; Continue
                }
            } else {
                if ($XmlDocument.Sessions.Session.Tasks.Phase.package | Where-Object {$_.Name -like "*$($Update.FileKBNumber)*" -and $_.targetState -eq 'Installed'}) {
                    Write-Host -ForegroundColor Gray "INSTALLED         $($Update.Title) - $(Split-Path $Update.OriginUri -Leaf)"; Continue
                }
            }
        }

        #Get updated Sessions.xml and check again
        if (Test-Path $SessionsXmlInstall) {
            [xml]$XmlDocument = Get-Content -Path $SessionsXmlInstall
        }

        if (Test-Path $SessionsXmlInstall) {
            if ($null -eq $Update.FileKBNumber) {
                if ($XmlDocument.Sessions.Session.Tasks.Phase.package | Where-Object {$_.Name -like "*$($Update.KBNumber)*" -and $_.targetState -eq 'Installed'}) {
                    Write-Host -ForegroundColor Gray "INSTALLED         $($Update.Title) - $(Split-Path $Update.OriginUri -Leaf)"; Continue
                }
            } else {
                if ($XmlDocument.Sessions.Session.Tasks.Phase.package | Where-Object {$_.Name -like "*$($Update.FileKBNumber)*" -and $_.targetState -eq 'Installed'}) {
                    Write-Host -ForegroundColor Gray "INSTALLED         $($Update.Title) - $(Split-Path $Update.OriginUri -Leaf)"; Continue
                }
            }
        }

        if ($null -eq $Update.FileKBNumber) {
            $CurrentLog = "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Update-WindowsServer2012R2OS-KB$($Update.KBNumber).log"
            if (Get-WindowsPackage -Path "$MountDirectory" | Where-Object {$_.PackageName -match "$($Update.KBNumber)"}) {
                Write-Host -ForegroundColor Gray "INSTALLED         $($Update.Title) - $(Split-Path $Update.OriginUri -Leaf)"; Continue
            }
        } else {
            $CurrentLog = "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Update-WindowsServer2012R2OS-KB$($Update.FileKBNumber).log"
            if (Get-WindowsPackage -Path "$MountDirectory" | Where-Object {$_.PackageName -match "$($Update.FileKBNumber)"}) {
                Write-Host -ForegroundColor Gray "INSTALLED         $($Update.Title) - $(Split-Path $Update.OriginUri -Leaf)"; Continue
            }
        }

        Write-Host -ForegroundColor Cyan "INSTALLING        " -NoNewline
        Write-Host -ForegroundColor Gray "$($Update.Title) - $(Split-Path $Update.OriginUri -Leaf)"

        Write-Verbose "CurrentLog: $CurrentLog"
        Try {Add-WindowsPackage -Path "$MountDirectory" -PackagePath "$UpdateTwelveR2" -LogPath "$CurrentLog" | Out-Null}
        Catch {
            if ($_.Exception.Message -match '0x800f081e') {Write-Verbose "OSDBuilder: 0x800f081e The package is not applicable to this image" -Verbose}
            Write-Verbose "OSDBuilder: Review the log for more information" -Verbose
            Write-Verbose "$CurrentLog" -Verbose
        }
    }
}
function Update-WindowsSevenOS {
    [CmdletBinding()]
    param ()
    #=================================================
    #   Abort
    #=================================================
    if ($ScriptName -ne 'Update-OSMedia') {Return}
    if ($SkipUpdates) {Return}
    if ($OSMajorVersion -eq 10) {Return}
    if ($null -eq $OSDUpdateWinSeven) {Return}
    #=================================================
    #   Header
    #=================================================
    Show-ActionTime; Write-Host -ForegroundColor Green "OS: Windows 7 Updates"
    $SessionsXmlInstall = "$MountDirectory\Windows\Servicing\Sessions\Sessions.xml"
    if (Test-Path $SessionsXmlInstall) {
        [xml]$XmlDocument = Get-Content -Path $SessionsXmlInstall
    }
    #=================================================
    #   Execute
    #=================================================
    foreach ($Update in $OSDUpdateWinSeven) {
        $UpdateSeven = $(Get-ChildItem -Path $SetOSDBuilderPathUpdates -File -Recurse | Where-Object {$_.Name -match $(Split-Path $Update.OriginUri -Leaf)}).FullName
        $UpdateSeven = $UpdateSeven | Select-Object -First 1

        if ($null -eq $UpdateSeven) {Continue}
        if (!(Test-Path "$UpdateSeven")) {Write-Warning "Not Found: $UpdateSeven"; Continue}

        if (Test-Path $SessionsXmlInstall) {
            if ($null -eq $Update.FileKBNumber) {
                if ($XmlDocument.Sessions.Session.Tasks.Phase.package | Where-Object {$_.Name -like "*$($Update.KBNumber)*" -and $_.targetState -eq 'Installed'}) {
                    Write-Host -ForegroundColor Gray "INSTALLED         $($Update.Title) - $(Split-Path $Update.OriginUri -Leaf)"; Continue
                }
            } else {
                if ($XmlDocument.Sessions.Session.Tasks.Phase.package | Where-Object {$_.Name -like "*$($Update.FileKBNumber)*" -and $_.targetState -eq 'Installed'}) {
                    Write-Host -ForegroundColor Gray "INSTALLED         $($Update.Title) - $(Split-Path $Update.OriginUri -Leaf)"; Continue
                }
            }
        }

        #Get updated Sessions.xml and check again
        if (Test-Path $SessionsXmlInstall) {
            [xml]$XmlDocument = Get-Content -Path $SessionsXmlInstall
        }

        if (Test-Path $SessionsXmlInstall) {
            if ($null -eq $Update.FileKBNumber) {
                if ($XmlDocument.Sessions.Session.Tasks.Phase.package | Where-Object {$_.Name -like "*$($Update.KBNumber)*" -and $_.targetState -eq 'Installed'}) {
                    Write-Host -ForegroundColor Gray "INSTALLED         $($Update.Title) - $(Split-Path $Update.OriginUri -Leaf)"; Continue
                }
            } else {
                if ($XmlDocument.Sessions.Session.Tasks.Phase.package | Where-Object {$_.Name -like "*$($Update.FileKBNumber)*" -and $_.targetState -eq 'Installed'}) {
                    Write-Host -ForegroundColor Gray "INSTALLED         $($Update.Title) - $(Split-Path $Update.OriginUri -Leaf)"; Continue
                }
            }
        }

        if ($null -eq $Update.FileKBNumber) {
            $CurrentLog = "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Update-WindowsSevenOS-KB$($Update.KBNumber).log"
            if (Get-WindowsPackage -Path "$MountDirectory" | Where-Object {$_.PackageName -match "$($Update.KBNumber)"}) {
                Write-Host -ForegroundColor Gray "INSTALLED         $($Update.Title) - $(Split-Path $Update.OriginUri -Leaf)"; Continue
            }
        } else {
            $CurrentLog = "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Update-WindowsSevenOS-KB$($Update.FileKBNumber).log"
            if (Get-WindowsPackage -Path "$MountDirectory" | Where-Object {$_.PackageName -match "$($Update.FileKBNumber)"}) {
                Write-Host -ForegroundColor Gray "INSTALLED         $($Update.Title) - $(Split-Path $Update.OriginUri -Leaf)"; Continue
            }
        }

        Write-Host -ForegroundColor Cyan "INSTALLING        " -NoNewline
        Write-Host -ForegroundColor Gray "$($Update.Title) - $(Split-Path $Update.OriginUri -Leaf)"

        Write-Verbose "CurrentLog: $CurrentLog"
        Try {Add-WindowsPackage -Path "$MountDirectory" -PackagePath "$UpdateSeven" -LogPath "$CurrentLog" | Out-Null}
        Catch {
            if ($_.Exception.Message -match '0x800f081e') {Write-Verbose "OSDBuilder: 0x800f081e The package is not applicable to this image" -Verbose}
            Write-Verbose "OSDBuilder: Review the log for more information" -Verbose
            Write-Verbose "$CurrentLog" -Verbose
        }
    }
}

Function Convert-ByteArrayToHex {
#borrowed from https://www.reddit.com/r/PowerShell/comments/5rhjsy/hex_to_byte_array_and_back/
    [cmdletbinding()]

    param(
        [parameter(Mandatory=$true)]
        [Byte[]]
        $Bytes
    )

    $HexString = [System.Text.StringBuilder]::new($Bytes.Length * 2)

    ForEach($byte in $Bytes){
        $HexString.AppendFormat("{0:x2}", $byte) | Out-Null
    }

    $HexString.ToString()
} 
