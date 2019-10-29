<#
.SYNOPSIS
Downloads Microsoft Updates for use in OSDBuilder

.DESCRIPTION
Downloads Microsoft Updates for use in OSDBuilder

.LINK
https://osdbuilder.osdeploy.com/module/functions/get-downosdbuilder
#>
function Get-DownOSDBuilder {
    [CmdletBinding(DefaultParameterSetName='OSDUpdate')]
    Param (
        #Downloads Feature Updates
        [Parameter(ParameterSetName='FeatureUpdates')]
        [switch]$FeatureUpdates,
        
        #Remove Superseded Updates that are no longer needed
        [Parameter(ParameterSetName='OSDUpdateSuperseded', Mandatory=$True)]
        [ValidateSet ('List','Remove')]
        [string]$Superseded,
        #===================================================================================================
        #   Content
        #===================================================================================================
        [Parameter(ParameterSetName='Content')]
        [ValidateSet(
            'OneDriveSetup Production',
            'OneDriveSetup Enterprise')]
        [string]$ContentDownload,
        #===================================================================================================
        #   OSDUpdate
        #===================================================================================================
        [Parameter(ParameterSetName='OSDUpdate')]
        [ValidateSet(
            'Windows 7',
            #'Windows 8.1',
            'Windows 10',
            'Windows Server 2012 R2',
            'Windows Server 2016',
            'Windows Server 2019')]
        [string]$UpdateOS,
        
        [Parameter(ParameterSetName='OSDUpdate')]
        [switch]$Download,

        [Parameter(ParameterSetName='OSDUpdate')]
        [switch]$GridView,

        [Parameter(ParameterSetName='OSDUpdate')]
        [ValidateSet ('x64','x86')]
        [string]$UpdateArch,

        [Parameter(ParameterSetName='OSDUpdate')]
        [ValidateSet (1903,1809,1803,1709,1703,1607,1511,1507,7601,7603)]
        [string]$UpdateBuild,

        [Parameter(ParameterSetName='OSDUpdate')]
        [ValidateSet(
            'SSU Servicing Stack Update',
            'LCU Latest Cumulative Update',
            'DUSU Setup Dynamic Update',
            'DUCU Component Dynamic Update',
            'Adobe Flash Player',
            'DotNet Framework',
            'Optional')]
        [string]$UpdateGroup,

        [Parameter(ParameterSetName='OSDUpdate')]
        [switch]$WebClient
    )

    Begin {
        #===================================================================================================
        #   Get-OSDBuilder
        #===================================================================================================
        Get-OSDBuilder -CreatePaths -HideDetails
        #===================================================================================================
        #   Get-OSDGather -Property IsAdmin
        #===================================================================================================
        if ((Get-OSDGather -Property IsAdmin) -eq $false) {
            Write-Warning 'OSDBuilder: This function needs to be run as Administrator'
            Pause
            Break
        }
    }

    PROCESS {
        #Write-Host '========================================================================================' -ForegroundColor DarkGray
        #Write-Host -ForegroundColor Green "$($MyInvocation.MyCommand.Name) PROCESS"

        #===================================================================================================
        #   FeatureUpdates
        #===================================================================================================
        if ($FeatureUpdates.IsPresent) {
            Write-Warning "FeatureUpdates are downloaded using BITS Transfer"
            Write-Warning "Windows Server 2016 (1607) does not support ESD Files"
            #===================================================================================================
            #   Get FeatureUpdateDownloads
            #===================================================================================================
            $FeatureUpdateDownloads = @()
            $FeatureUpdateDownloads = Get-FeatureUpdateDownloads
            #===================================================================================================
            #   Select-Object
            #===================================================================================================
            $FeatureUpdateDownloads = $FeatureUpdateDownloads | Select-Object -Property OSDStatus, Title, UpdateOS,`
            UpdateBuild, UpdateArch, CreationDate, KBNumber, FileName, Size, OriginUri, Hash, AdditionalHash
            #===================================================================================================
            #   Sorting
            #===================================================================================================
            $FeatureUpdateDownloads = $FeatureUpdateDownloads | Sort-Object -Property Title
            #===================================================================================================
            #   Select Updates with GridView
            #===================================================================================================
            $FeatureUpdateDownloads = $FeatureUpdateDownloads | Out-GridView -PassThru -Title 'Select ESD Files to Download and Build and press OK'
            #===================================================================================================
            #   Download Updates
            #===================================================================================================
            if ($WebClient.IsPresent) {$WebClientObj = New-Object System.Net.WebClient}
            foreach ($Item in $FeatureUpdateDownloads) {
                $DownloadPath = $global:GetOSDBuilder.PathMedia
                $DownloadFullPath = "$DownloadPath\$($Item.FileName)"

                if (!(Test-Path $DownloadPath)) {New-Item -Path "$DownloadPath" -ItemType Directory -Force | Out-Null}
                Write-Host "$DownloadFullPath" -ForegroundColor Cyan
                Write-Host "$($Item.OriginUri)" -ForegroundColor DarkGray
                if (!(Test-Path $DownloadFullPath)) {
                    if ($WebClient.IsPresent) {							
                        $WebClientObj.DownloadFile("$($Item.OriginUri)","$DownloadFullPath")
                    } else {
                        Start-BitsTransfer -Source $Item.OriginUri -Destination $DownloadFullPath
                    }
                }

                $esdbasename = (Get-Item "$DownloadFullPath").Basename
                $esddirectory = "$($global:GetOSDBuilder.PathMedia)\$esdbasename"

                if (Test-Path "$esddirectory") {
                    Remove-Item "$esddirectory" -Force | Out-Null
                }
                
                Try {
                    $esdinfo = Get-WindowsImage -ImagePath "$DownloadFullPath"
                }
                Catch {
                    Write-Warning "Could not get ESD information"
                    Break
                }
                
                Write-Host "Creating $esddirectory" -ForegroundColor Cyan
                New-Item -Path "$esddirectory" -Force -ItemType Directory | Out-Null
                
                foreach ($image in $esdinfo) {
                    if ($image.ImageName -eq 'Windows Setup Media') {
                        Write-Host "Expanding Index $($image.ImageIndex) $($image.ImageName) ..." -ForegroundColor Cyan
                        Expand-WindowsImage -ImagePath "$($image.ImagePath)" -ApplyPath "$esddirectory" -Index "$($image.ImageIndex)" -ErrorAction SilentlyContinue | Out-Null
                    } elseif ($image.ImageName -like "*Windows PE*") {
                        Write-Host "Exporting Index $($image.ImageIndex) $($image.ImageName) ..." -ForegroundColor Cyan
                        Export-WindowsImage -SourceImagePath "$($image.ImagePath)" -SourceIndex $($image.ImageIndex) -DestinationImagePath "$esddirectory\sources\boot.wim" -CompressionType Max -ErrorAction SilentlyContinue | Out-Null
                    } elseif ($image.ImageName -like "*Windows Setup*") {
                        Write-Host "Exporting Index $($image.ImageIndex) $($image.ImageName) ..." -ForegroundColor Cyan
                        Export-WindowsImage -SourceImagePath "$($image.ImagePath)" -SourceIndex $($image.ImageIndex) -DestinationImagePath "$esddirectory\sources\boot.wim" -CompressionType Max -Setbootable -ErrorAction SilentlyContinue | Out-Null
                    } else {
                        Write-Host "Exporting Index $($image.ImageIndex) $($image.ImageName) ..." -ForegroundColor Cyan
                        Export-WindowsImage -SourceImagePath "$($image.ImagePath)" -SourceIndex $($image.ImageIndex) -DestinationImagePath "$esddirectory\sources\install.wim" -CompressionType Max -ErrorAction SilentlyContinue | Out-Null
                    }
                }
            }
            Write-Warning "Use Import-OSMedia to import this Feature Update to OSMedia"
        }


        if ($PSCmdlet.ParameterSetName -eq 'Content') {
            #===================================================================================================
            #   Database
            #===================================================================================================
            if ($ContentDownload -eq 'OneDriveSetup Production') {
                $DownloadUrl = 'https://go.microsoft.com/fwlink/p/?LinkId=248256'
                $DownloadPath = "$OSDBuilderContent\OneDrive"
                $DownloadFile = 'OneDriveSetup.exe'
            }
            if ($ContentDownload -eq 'OneDriveSetup Enterprise') {
                $DownloadUrl = 'https://go.microsoft.com/fwlink/p/?linkid=860987'
                $DownloadPath = "$OSDBuilderContent\OneDrive"
                $DownloadFile = 'OneDriveSetup.exe'
            }
            #===================================================================================================
            #   Download
            #===================================================================================================
            if (!(Test-Path "$DownloadPath")) {New-Item -Path $DownloadPath -ItemType Directory -Force | Out-Null}
            Write-Verbose "DownloadUrl: $DownloadUrl" -Verbose
            Write-Verbose "DownloadPath: $DownloadPath" -Verbose
            Write-Verbose "DownloadFile: $DownloadFile" -Verbose
            Invoke-WebRequest -Uri $DownloadUrl -OutFile "$DownloadPath\$DownloadFile"
            if (Test-Path "$DownloadPath\$DownloadFile") {
                $OneDriveSetupInfo = Get-Item -Path "$DownloadPath\$DownloadFile" | Select-Object -Property *
                Write-Verbose "DownloadVersion: $($($OneDriveSetupInfo).VersionInfo.ProductVersion)" -Verbose
                Write-Verbose 'Complete' -Verbose
            } else {
                Write-Warning 'Content could not be downloaded'
            }
        }

        
        if (($PSCmdlet.ParameterSetName -eq 'OSDUpdate') -or ($PSCmdlet.ParameterSetName -eq 'OSDUpdateSuperseded')) {
            #===================================================================================================
            #   Information
            #===================================================================================================
            if ($WebClient.IsPresent) {
                Write-Verbose "Downloading OSDUpdates using System.Net.WebClient" -Verbose
            } else {
                Write-Verbose "Downloading OSDUpdates using BITS-Transfer" -Verbose
                Write-Verbose "To use System.Net.WebClient, use the -WebClient Parameter" -Verbose
            }
            #===================================================================================================
            #   Get OSDUpdates
            #===================================================================================================
            $OSDUpdates = @()
            $OSDUpdates = Get-OSDUpdates | Sort-Object CreationDate -Descending
            #===================================================================================================
            #   Superseded Updates
            #===================================================================================================
            if ($Superseded) {
                $ExistingUpdates = @()
                if (!(Test-Path $global:GetOSDBuilder.PathOSDUpdate)) {New-Item $global:GetOSDBuilder.PathOSDUpdate -ItemType Directory -Force | Out-Null}
                $ExistingUpdates = Get-ChildItem -Path "$($global:GetOSDBuilder.PathOSDUpdate)\*\*" -Directory

                $SupersededUpdates = @()
                foreach ($Update in $ExistingUpdates) {
                    if ($OSDUpdates.Title -NotContains $Update.Name) {$SupersededUpdates += $Update.FullName}
                }
            
                if ($Superseded -eq 'List') {
                    Write-Warning 'Superseded Updates:'
                    foreach ($Update in $SupersededUpdates) {
                        Write-Host "$Update" -ForegroundColor Gray
                    }
                }
                if ($Superseded -eq 'Remove') {
                    Write-Warning 'Superseded Updates:'
                    foreach ($Update in $SupersededUpdates) {
                        Write-Warning "Deleting $Update"
                        Remove-Item $Update -Recurse -Force | Out-Null
                    }
                }
                Break
            }
            #===================================================================================================
            #   UpdateOS
            #===================================================================================================
            if ($UpdateOS) {$OSDUpdates = $OSDUpdates | Where-Object {$_.UpdateOS -eq $UpdateOS}}
            #===================================================================================================
            #   UpdateArch
            #===================================================================================================
            if ($UpdateArch) {$OSDUpdates = $OSDUpdates | Where-Object {$_.UpdateArch -eq $UpdateArch}}
            #===================================================================================================
            #   UpdateBuild
            #===================================================================================================
            if ($UpdateBuild) {$OSDUpdates = $OSDUpdates | Where-Object {$_.UpdateBuild -eq $UpdateBuild}}
            #===================================================================================================
            #   UpdateGroup
            #===================================================================================================
            if ($UpdateGroup -like "*Adobe*") {$OSDUpdates = $OSDUpdates | Where-Object {$_.UpdateGroup -eq 'AdobeSU'}}
            if ($UpdateGroup -like "*DotNet*") {$OSDUpdates = $OSDUpdates | Where-Object {$_.UpdateGroup -like "DotNet*"}}
            if ($UpdateGroup -like "*DUCU*") {$OSDUpdates = $OSDUpdates | Where-Object {$_.UpdateGroup -like "ComponentDU*"}}
            if ($UpdateGroup -like "*DUSU*") {$OSDUpdates = $OSDUpdates | Where-Object {$_.UpdateGroup -eq 'SetupDU'}}
            if ($UpdateGroup -like "*LCU*") {$OSDUpdates = $OSDUpdates | Where-Object {$_.UpdateGroup -eq 'LCU'}}
            if ($UpdateGroup -like "*SSU*") {$OSDUpdates = $OSDUpdates | Where-Object {$_.UpdateGroup -eq 'SSU'}}
            if ($UpdateGroup -eq 'Optional') {$OSDUpdates = $OSDUpdates | Where-Object {[String]::IsNullOrWhiteSpace($_.UpdateGroup) -or $_.UpdateGroup -eq 'Optional'}}
            #===================================================================================================
            #   Sorting
            #===================================================================================================
            $OSDUpdates = $OSDUpdates | Sort-Object -Property CreationDate -Descending
            #===================================================================================================
            #   Select Updates with GridView
            #===================================================================================================
            if ($GridView.IsPresent) {$OSDUpdates = $OSDUpdates | Out-GridView -PassThru -Title 'Select Updates to Download and press OK'}
            #===================================================================================================
            #   Download Updates
            #===================================================================================================
            if ($Download.IsPresent) {
				if ($WebClient.IsPresent) {$WebClientObj = New-Object System.Net.WebClient}
                foreach ($Update in $OSDUpdates) {
                    $DownloadPath = "$($global:GetOSDBuilder.PathOSDUpdate)\$($Update.Catalog)\$($Update.Title)"
                    $DownloadFullPath = "$DownloadPath\$($Update.FileName)"

                    if (!(Test-Path $DownloadPath)) {New-Item -Path "$DownloadPath" -ItemType Directory -Force | Out-Null}
                    if (!(Test-Path $DownloadFullPath)) {
                        Write-Host "$DownloadFullPath" -ForegroundColor Cyan
                        Write-Host "$($Update.OriginUri)" -ForegroundColor DarkGray
                        if ($WebClient.IsPresent) {							
                            $WebClientObj.DownloadFile("$($Update.OriginUri)","$DownloadFullPath")
                        } else {
                            Start-BitsTransfer -Source $Update.OriginUri -Destination $DownloadFullPath
                        }
                    } else {
                        #Write-Warning "Exists: $($Update.Title)"
                    }
                }
            } else {
                Return $OSDUpdates | Select-Object -Property Catalog, OSDVersion, OSDStatus, UpdateOS, UpdateBuild, UpdateArch, UpdateGroup, CreationDate, KBNumber, Title
            }
        }
    }

    END {
        #Write-Host '========================================================================================' -ForegroundColor DarkGray
        #Write-Host -ForegroundColor Green "$($MyInvocation.MyCommand.Name) END"
    }
}
