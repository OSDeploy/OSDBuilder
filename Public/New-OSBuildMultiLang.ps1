<#
.SYNOPSIS
Separates an OSBuild with Language Packs into separate Image Indexes

.DESCRIPTION
Separates an OSBuild with Language Packs into separate Image Indexes.  This will create a new OSBuild

.LINK
https://osdbuilder.osdeploy.com/module/functions/new-osbuildmultilang
#>
function New-OSBuildMultiLang {
    [CmdletBinding()]
    param (
        #Name of the new OSBuild MultiLang to create.  MultiLang will be appended to the end of CustomName
        [Parameter(Position = 0, Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$CustomName
    )

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
        #   Get-OSDUpdates
        #=================================================
        $AllOSDUpdates = @()
        $AllOSDUpdates = Get-OSDUpdates
        #=================================================
        #   Block
        #=================================================
        Block-StandardUser
        #=================================================
    }
    
    PROCESS {
        Write-Host '========================================================================================' -ForegroundColor DarkGray
        Write-Host -ForegroundColor Green "$($MyInvocation.MyCommand.Name) PROCESS"
        Write-Warning "OSBuild MultiLang will take an OSBuild with Language Packs"
        Write-Warning "and create a new OSBuild with multiple Indexes"
        Write-Warning "Each Index will have a Language set as the System UI"
        Write-Warning "This process will take some time as the LCU will be reapplied"
        
        #=================================================
        #   Get OSBuilds with Multi Lang
        #=================================================
        $AllMyOSBuilds = @()
        $AllMyOSBuilds = Get-OSBuilds | Where-Object {($_.Languages).Count -gt 1} | Where-Object {$_.Name -notlike "*MultiLang"}
        #=================================================
        #   Select Source OSBuild
        #=================================================
        $SelectedOSBuild = @()
        $SelectedOSBuild = $AllMyOSBuilds | Out-GridView -Title "OSDBuilder: Select one or more OSBuilds to split and press OK (Cancel to Exit)" -PassThru
        #=================================================
        #   Build
        #=================================================
        foreach ($Media in $SelectedOSBuild) {
            $SourceFullName = "$($Media.FullName)"
            $BuildName = "$CustomName MultiLang"
            $DestinationFullName = "$SetOSDBuilderPathOSBuilds\$BuildName"
            $Info = "$DestinationFullName\info"
            #=================================================
            #   Copy Media
            #=================================================
            Write-Host "Copying Media to $DestinationFullName" -ForegroundColor Cyan
            if (Test-Path $DestinationFullName) {Write-Warning "Existing contents will be replaced in $DestinationFullName"}
            robocopy "$SourceFullName" "$DestinationFullName" *.* /mir /ndl /nfl /b /np /ts /tee /r:0 /w:0 /xf install.wim *.iso *.vhd *.vhdx
            #=================================================
            #   Process Languages
            #=================================================
            $LangMultiWindowsImage = Import-Clixml "$DestinationFullName\info\xml\Get-WindowsImage.xml"
            $LangMultiLanguages = $($LangMultiWindowsImage.Languages)
            [int]$LangMultiDefaultIndex = $($LangMultiWindowsImage.DefaultLanguageIndex)

            $LangMultiDefaultName = $LangMultiLanguages[$LangMultiDefaultIndex]
            #=================================================
            #
            #=================================================
            $RegValueCurrentBuild = $null
            if (Test-Path "$DestinationFullName\info\xml\CurrentVersion.xml") {
                $RegKeyCurrentVersion = Import-Clixml -Path "$DestinationFullName\info\xml\CurrentVersion.xml"

                [string]$RegValueCurrentBuild = ($RegKeyCurrentVersion).CurrentBuild
                [string]$RegValueDisplayVersion = ($RegKeyCurrentVersion).DisplayVersion
                [string]$ReleaseId = ($RegKeyCurrentVersion).ReleaseId
                if ($RegValueDisplayVersion) {$ReleaseId = $RegValueDisplayVersion}
            }
            #=================================================
            #   Operating System
            #=================================================
            $OSArchitecture         = $($LangMultiWindowsImage.Architecture)
            $OSBuild                = $($LangMultiWindowsImage.Build)
            $OSInstallationType     = $($LangMultiWindowsImage.InstallationType)
            $OSMajorVersion         = $($LangMultiWindowsImage.MajorVersion)
            $WindowsImageMediaName  = $($LangMultiWindowsImage.MediaName)
            $OSVersion              = $($LangMultiWindowsImage.Version)

            if ($OSArchitecture -eq '0') {$OSArchitecture = 'x86'}
            if ($OSArchitecture -eq '6') {$OSArchitecture = 'ia64'}
            if ($OSArchitecture -eq '9') {$OSArchitecture = 'x64'}
            if ($OSArchitecture -eq '12') {$OSArchitecture = 'x64 ARM'}
            #=================================================
            #   Operating System
            #=================================================
            $UpdateOS = ''
            if ($OSMajorVersion -eq 10) {
                if ($OSInstallationType -match 'Server') {
                    $UpdateOS = 'Windows Server'
                }
                else {
                    if ($WindowsImageMediaName -match ' 11 ') {
                        $UpdateOS = 'Windows 11'
                    }
                    else {
                        $UpdateOS = 'Windows 10'
                    }
                }
            }
            #=================================================
            #   OSDUpdateLCU
            #=================================================
            $OSDUpdateLCU = $AllOSDUpdates
            $OSDUpdateLCU = $OSDUpdateLCU | Where-Object {$_.UpdateArch -eq $OSArchitecture}
            $OSDUpdateLCU = $OSDUpdateLCU | Where-Object {$_.UpdateOS -eq $UpdateOS}
            $OSDUpdateLCU = $OSDUpdateLCU | Where-Object {($_.UpdateBuild -eq $ReleaseId) -or ($_.UpdateBuild -eq '')}
            $OSDUpdateLCU = $OSDUpdateLCU | Where-Object {$_.UpdateGroup -eq 'LCU'}
            #=================================================
            #   Export Install.wim
            #=================================================
            if (Test-Path "$DestinationFullName\OS\Sources\install.wim") {Remove-Item -Path "$DestinationFullName\OS\Sources\install.wim" -Force | Out-Null}
            $TempInstallWim = Join-Path "$env:Temp" "install$((Get-Date).ToString('mmss')).wim"

            Write-Host "Exporting install.wim to $DestinationFullName\OS\Sources\install.wim" -ForegroundColor Cyan
            Export-WindowsImage -SourceImagePath "$SourceFullName\OS\Sources\install.wim" -SourceIndex 1 -DestinationImagePath "$DestinationFullName\OS\Sources\install.wim" -DestinationName "$($Media.ImageName) $LangMultiDefaultName" | Out-Null
            
            Write-Host "Exporting temporary install.wim to $TempInstallWim" -ForegroundColor Cyan
            Export-WindowsImage -SourceImagePath "$SourceFullName\OS\Sources\Install.wim" -SourceIndex 1 -DestinationImagePath "$TempInstallWim" -DestinationName "$($Media.ImageName)" | Out-Null
            
            $MountDirectory = Join-Path "$env:Temp" "mount$((Get-Date).ToString('mmss'))"
            New-Item "$MountDirectory" -ItemType Directory | Out-Null
            Mount-WindowsImage -Path "$MountDirectory" -ImagePath "$TempInstallWim" -Index 1 | Out-Null
            #=================================================
            #   Process Indexes
            #=================================================
            foreach ($LangMultiLanguage in $LangMultiLanguages) {
                if ($LangMultiLanguage -eq $LangMultiDefaultName) {
					#=================================================
					#   Header
					#=================================================
					Show-ActionTime
					Write-Host -ForegroundColor Green "$($Media.ImageName) $LangMultiDefaultName is already processed as Index 1"
                } else {
                    Show-ActionTime
					Write-Host -ForegroundColor Green "Processing $($Media.ImageName) $LangMultiLanguage"

                    Write-Host "Dism /Image:"$MountDirectory" /Set-AllIntl:$LangMultiLanguage" -ForegroundColor Cyan
                    Dism /Image:"$MountDirectory" /Set-AllIntl:$LangMultiLanguage

                    Write-Host "Dism /Image:"$MountDirectory" /Get-Intl" -ForegroundColor Cyan
                    Dism /Image:"$MountDirectory" /Get-Intl
                    
                    Write-Warning "Waiting 10 seconds for processes to complete before applying LCU ..."
                    Start-Sleep -Seconds 10
                    Update-CumulativeOS -Force

                    Write-Warning "Waiting 10 seconds for processes to complete before Save-WindowsImage ..."
                    Start-Sleep -Seconds 10
                    Save-WindowsImage -Path "$MountDirectory" | Out-Null

                    Write-Warning "Waiting 10 seconds for processes to complete before Export-WindowsImage ..."
                    Start-Sleep -Seconds 10
                    Export-WindowsImage -SourceImagePath "$TempInstallWim" -SourceIndex 1 -DestinationImagePath "$DestinationFullName\OS\Sources\install.wim" -DestinationName "$($Media.ImageName) $LangMultiLanguage" | Out-Null
                }
            }
            #=================================================
            #   Cleanup
            #=================================================
            try {
                Write-Warning "Waiting 10 seconds for processes to complete before Dismount-WindowsImage ..."
                Start-Sleep -Seconds 10
                Dismount-WindowsImage -Path "$MountDirectory" -Discard -ErrorAction SilentlyContinue | Out-Null
            }
            catch {
                Write-Warning "Could not dismount $MountDirectory ... Waiting 30 seconds ..."
                Start-Sleep -Seconds 30
                Dismount-WindowsImage -Path "$MountDirectory" -Discard | Out-Null
            }
            Write-Warning "Waiting 10 seconds for processes to finish before removing Temporary Files ..."
            Start-Sleep -Seconds 10
            Remove-Item -Path "$MountDirectory" -Force | Out-Null
            if (Test-Path "$TempInstallWim") {Remove-Item -Path "$TempInstallWim" -Force | Out-Null}
        }
    }

    END {
        #Write-Host '========================================================================================' -ForegroundColor DarkGray
        #Write-Host -ForegroundColor Green "$($MyInvocation.MyCommand.Name) END"
    }
}