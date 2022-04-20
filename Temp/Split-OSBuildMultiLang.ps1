<#
.SYNOPSIS
BETA ONLY

.DESCRIPTION
BETA ONLY

.LINK
https://osdbuilder.osdeploy.com/module/functions/osbuild/split-osbuild

.PARAMETER CustomName
Name of the OSBuild to create.  MultiIndex will be appended to the Custom Name
#>
function Split-OSBuildMultiLang {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$CustomName
    )

    Begin {
        #Write-Host '========================================================================================' -ForegroundColor DarkGray
        #Write-Host -ForegroundColor Green "$($MyInvocation.MyCommand.Name) BEGIN"

        #=================================================
        Write-Verbose '19.1.1 Initialize OSDBuilder'
        #=================================================
        Get-OSDBuilder -CreatePaths -HideDetails
    }
    
    Process {
        Write-Host '========================================================================================' -ForegroundColor DarkGray
        Write-Host -ForegroundColor Green "$($MyInvocation.MyCommand.Name) PROCESS"
        Write-Warning "This script is under Development at this time"
        Pause
        
        #=================================================
        #   19.1.1 Validate Administrator Rights
        #=================================================
        if (!([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
            Write-Warning 'OSDBuilder: This function needs to be run as Administrator'
            Pause
			Exit
        }
        #=================================================
        #   Get OSBuilds with Multi Lang
        #=================================================
        $AllMyOSBuilds = @()
        $AllMyOSBuilds = Get-OSBuilds | Where-Object {($_.Languages).Count -gt 1} | Where-Object {$_.Name -notlike "*MultiIndex"}
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
            $BuildName = "$CustomName MultiIndex"
            $DestinationFullName = "$SetOSDBuilderPathOSBuilds\$BuildName"
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
            #   Export Install.wim
            #=================================================
            if (Test-Path "$DestinationFullName\OS\Sources\install.wim") {Remove-Item -Path "$DestinationFullName\OS\Sources\install.wim" -Force | Out-Null}
            $TempInstallWim = Join-Path "$env:Temp" "install$((Get-Date).ToString('mmss')).wim"

            Write-Host "Exporting install.wim to $DestinationFullName\OS\Sources\install.wim" -ForegroundColor Cyan
            Export-WindowsImage -SourceImagePath "$SourceFullName\OS\Sources\install.wim" -SourceIndex 1 -DestinationImagePath "$DestinationFullName\OS\Sources\install.wim" -DestinationName "$($Media.ImageName) $LangMultiDefaultName" | Out-Null
            
            Write-Host "Exporting temporary install.wim to $TempInstallWim" -ForegroundColor Cyan
            Export-WindowsImage -SourceImagePath "$SourceFullName\OS\Sources\Install.wim" -SourceIndex 1 -DestinationImagePath "$TempInstallWim" -DestinationName "$($Media.ImageName)" | Out-Null
            #=================================================
            #   Process Indexes
            #=================================================
            foreach ($LangMultiLanguage in $LangMultiLanguages) {
                if ($LangMultiLanguage -eq $LangMultiDefaultName) {
                    Write-Host "$($Media.ImageName) $LangMultiDefaultName is already processed as Index 1" -ForegroundColor Cyan
                } else {
                    Write-Host "Processing $($Media.ImageName) $LangMultiLanguage" -ForegroundColor Cyan
                    $TempMount = Join-Path "$env:Temp" "mount$((Get-Date).ToString('mmss'))"

                    New-Item "$TempMount" -ItemType Directory | Out-Null
                    Mount-WindowsImage -Path "$TempMount" -ImagePath "$TempInstallWim" -Index 1 | Out-Null
                    #Dism /Image:"$TempMount" /Gen-LangIni /Distribution:"$DestinationFullName\OS"
                    Dism /image:"$TempMount" /Set-AllIntl:$LangMultiLanguage
                    Dism /image:"$TempMount" /Get-Intl
                    #Dism /Image:"$TempMount" /Gen-LangIni /Distribution:"$DestinationFullName\OS"
                    Write-Warning "Waiting 10 seconds for processes to finish ..."
                    Start-Sleep -Seconds 10
                    try {
                        Dismount-WindowsImage -Path "$TempMount" -Save -ErrorAction SilentlyContinue | Out-Null
                    }
                    catch {
                        Write-Warning "Could not dismount $TempMount ... Waiting 30 seconds ..."
                        Start-Sleep -Seconds 30
                        Dismount-WindowsImage -Path "$TempMount" -Save | Out-Null
                    }
                    Write-Warning "Waiting 10 seconds for processes to finish ..."
                    Start-Sleep -Seconds 10
                    Remove-Item -Path "$TempMount" -Force | Out-Null
                    
                    Export-WindowsImage -SourceImagePath "$TempInstallWim" -SourceIndex 1 -DestinationImagePath "$DestinationFullName\OS\Sources\install.wim" -DestinationName "$($Media.ImageName) $LangMultiLanguage" | Out-Null
                }
            }
            #=================================================
            #   Cleanup
            #=================================================
            if (Test-Path "$TempInstallWim") {Remove-Item -Path "$TempInstallWim" -Force | Out-Null}
        }
    }

    End {
        #Write-Host '========================================================================================' -ForegroundColor DarkGray
        #Write-Host -ForegroundColor Green "$($MyInvocation.MyCommand.Name) END"
    }
}