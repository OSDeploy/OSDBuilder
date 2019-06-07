<#
.SYNOPSIS
Separates an OSBuild with Language Packs into separate Image Indexes

.DESCRIPTION
Separates an OSBuild with Language Packs into separate Image Indexes.  This will create a new OSBuild

.LINK
http://osdbuilder.com/docs/functions/osbuild/new-osbuildmultilang

.PARAMETER CustomName
Name of the new OSBuild MultiLang to create.  MultiLang will be appended to the end of CustomName
#>
function New-OSBuildMultiLang {
    [CmdletBinding()]
    PARAM (
        [Parameter(Mandatory)]
        [string]$CustomName
    )

    BEGIN {
        #Write-Host '========================================================================================' -ForegroundColor DarkGray
        #Write-Host -ForegroundColor Green "$($MyInvocation.MyCommand.Name) BEGIN"

        #===================================================================================================
        Write-Verbose '19.1.1 Initialize OSDBuilder'
        #===================================================================================================
        Get-OSDBuilder -CreatePaths -HideDetails
    }
    
    PROCESS {
        Write-Host '========================================================================================' -ForegroundColor DarkGray
        Write-Host -ForegroundColor Green "$($MyInvocation.MyCommand.Name) PROCESS"
        Write-Warning "OSBuild MultiLang will take an OSBuild with Language Packs"
        Write-Warning "and create a new OSBuild with multiple Indexes"
        Write-Warning "Each Index will have a Language set as the System UI"
        Write-Host ""
        Write-Warning "This script is under Development at this time"
        
        #===================================================================================================
        #   19.1.1 Validate Administrator Rights
        #===================================================================================================
        if (!([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
            Write-Warning 'OSDBuilder: This function needs to be run as Administrator'
            Pause
			Exit
        }
        #===================================================================================================
        #   Get OSBuilds with Multi Lang
        #===================================================================================================
        $AllMyOSBuilds = @()
        $AllMyOSBuilds = Get-OSBuilds | Where-Object {($_.Languages).Count -gt 1} | Where-Object {$_.Name -notlike "*MultiLang"}
        #===================================================================================================
        #   Select Source OSBuild
        #===================================================================================================
        $SelectedOSBuild = @()
        $SelectedOSBuild = $AllMyOSBuilds | Out-GridView -Title "OSDBuilder: Select one or more OSBuilds to split and press OK (Cancel to Exit)" -PassThru
        #===================================================================================================
        #   Build
        #===================================================================================================
        foreach ($Media in $SelectedOSBuild) {
            $SourceFullName = "$($Media.FullName)"
            $BuildName = "$CustomName MultiLang"
            $DestinationFullName = "$OSDBuilderOSBuilds\$BuildName"
            #===================================================================================================
            #   Copy Media
            #===================================================================================================
            Write-Host "Copying Media to $DestinationFullName" -ForegroundColor Cyan
            if (Test-Path $DestinationFullName) {Write-Warning "Existing contents will be replaced in $DestinationFullName"}
            robocopy "$SourceFullName" "$DestinationFullName" *.* /mir /ndl /nfl /b /np /ts /tee /r:0 /w:0 /xf install.wim *.iso *.vhd *.vhdx
            #===================================================================================================
            #   Process Languages
            #===================================================================================================
            $LangMultiWindowsImage = Import-Clixml "$DestinationFullName\info\xml\Get-WindowsImage.xml"
            $LangMultiLanguages = $($LangMultiWindowsImage.Languages)
            [int]$LangMultiDefaultIndex = $($LangMultiWindowsImage.DefaultLanguageIndex)

            $LangMultiDefaultName = $LangMultiLanguages[$LangMultiDefaultIndex]
            #===================================================================================================
            #   Export Install.wim
            #===================================================================================================
            if (Test-Path "$DestinationFullName\OS\Sources\install.wim") {Remove-Item -Path "$DestinationFullName\OS\Sources\install.wim" -Force | Out-Null}
            $TempInstallWim = Join-Path "$env:Temp" "install$((Get-Date).ToString('mmss')).wim"

            Write-Host "Exporting install.wim to $DestinationFullName\OS\Sources\install.wim" -ForegroundColor Cyan
            Export-WindowsImage -SourceImagePath "$SourceFullName\OS\Sources\install.wim" -SourceIndex 1 -DestinationImagePath "$DestinationFullName\OS\Sources\install.wim" -DestinationName "$($Media.ImageName) $LangMultiDefaultName" | Out-Null
            
            Write-Host "Exporting temporary install.wim to $TempInstallWim" -ForegroundColor Cyan
            Export-WindowsImage -SourceImagePath "$SourceFullName\OS\Sources\Install.wim" -SourceIndex 1 -DestinationImagePath "$TempInstallWim" -DestinationName "$($Media.ImageName)" | Out-Null
            


            $TempMount = Join-Path "$env:Temp" "mount$((Get-Date).ToString('mmss'))"
            New-Item "$TempMount" -ItemType Directory | Out-Null
            Mount-WindowsImage -Path "$TempMount" -ImagePath "$TempInstallWim" -Index 1 | Out-Null
            #===================================================================================================
            #   Process Indexes
            #===================================================================================================
            foreach ($LangMultiLanguage in $LangMultiLanguages) {
                if ($LangMultiLanguage -eq $LangMultiDefaultName) {
					#===================================================================================================
					#   Header
					#===================================================================================================
					Get-OSDStartTime
					Write-Host -ForegroundColor Green "$($Media.ImageName) $LangMultiDefaultName is already processed as Index 1"
                } else {
                    Get-OSDStartTime
					Write-Host -ForegroundColor Green "Processing $($Media.ImageName) $LangMultiLanguage"

                    Write-Host "Dism /Image:"$TempMount" /Set-AllIntl:$LangMultiLanguage" -ForegroundColor Cyan
                    Dism /Image:"$TempMount" /Set-AllIntl:$LangMultiLanguage

                    Write-Host "Dism /Image:"$TempMount" /Get-Intl" -ForegroundColor Cyan
                    Dism /Image:"$TempMount" /Get-Intl
                    
                    Write-Warning "Waiting 10 seconds for processes to complete before Save-WindowsImage ..."
                    Start-Sleep -Seconds 10
                    Save-WindowsImage -Path "$TempMount" | Out-Null

                    Write-Warning "Waiting 10 seconds for processes to complete before Export-WindowsImage ..."
                    Start-Sleep -Seconds 10
                    Export-WindowsImage -SourceImagePath "$TempInstallWim" -SourceIndex 1 -DestinationImagePath "$DestinationFullName\OS\Sources\install.wim" -DestinationName "$($Media.ImageName) $LangMultiLanguage" | Out-Null
                }
            }
            #===================================================================================================
            #   Cleanup
            #===================================================================================================
            try {
                Write-Warning "Waiting 10 seconds for processes to complete before Dismount-WindowsImage ..."
                Start-Sleep -Seconds 10
                Dismount-WindowsImage -Path "$TempMount" -Discard -ErrorAction SilentlyContinue | Out-Null
            }
            catch {
                Write-Warning "Could not dismount $TempMount ... Waiting 30 seconds ..."
                Start-Sleep -Seconds 30
                Dismount-WindowsImage -Path "$TempMount" -Discard | Out-Null
            }
            Write-Warning "Waiting 10 seconds for processes to finish before removing Temporary Files ..."
            Start-Sleep -Seconds 10
            Remove-Item -Path "$TempMount" -Force | Out-Null
            if (Test-Path "$TempInstallWim") {Remove-Item -Path "$TempInstallWim" -Force | Out-Null}
        }
    }

    END {
        #Write-Host '========================================================================================' -ForegroundColor DarkGray
        #Write-Host -ForegroundColor Green "$($MyInvocation.MyCommand.Name) END"
    }
}