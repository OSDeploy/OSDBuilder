<#
.SYNOPSIS
Downloads Microsoft Updates for use in OSDBuilder

.DESCRIPTION
Downloads Microsoft Updates for use in OSDBuilder

.LINK
https://www.osdeploy.com/osdbuilder/docs/functions/get-downosdbuilder
#>
function Get-DownOSDBuilder {
    [CmdletBinding(DefaultParameterSetName='OSDUpdate')]
    PARAM (
        #===================================================================================================
        #   OSDUpdateSuperseded
        #===================================================================================================
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
        [ValidateSet (1903,1809,1803,1709,1703,1607,1511,1507,7601)]
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

    BEGIN {
        #Write-Host '========================================================================================' -ForegroundColor DarkGray
        #Write-Host "$($MyInvocation.MyCommand.Name) BEGIN" -ForegroundColor Green
        Get-OSDBuilder -CreatePaths -HideDetails
    }

    PROCESS {
        #Write-Host '========================================================================================' -ForegroundColor DarkGray
        #Write-Host "$($MyInvocation.MyCommand.Name) PROCESS" -ForegroundColor Green




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
            $OSDUpdates = OSD-Update-GetOSDUpdates
            #===================================================================================================
            #   Superseded Updates
            #===================================================================================================
            if ($Superseded) {
                $ExistingUpdates = @()
                if (!(Test-Path "$OSDBuilderPath\Content\OSDUpdate")) {New-Item $OSDBuilderPath\Content\OSDUpdate -ItemType Directory -Force | Out-Null}
                $ExistingUpdates = Get-ChildItem -Path "$OSDBuilderPath\Content\OSDUpdate\*\*" -Directory

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
                foreach ($Update in $OSDUpdates) {
                    $DownloadPath = "$OSDBuilderPath\Content\OSDUpdate\$($Update.Catalog)\$($Update.Title)"
                    $DownloadFullPath = "$DownloadPath\$($Update.FileName)"

                    if (!(Test-Path $DownloadPath)) {New-Item -Path "$DownloadPath" -ItemType Directory -Force | Out-Null}
                    if (!(Test-Path $DownloadFullPath)) {
                        Write-Host "$DownloadFullPath" -ForegroundColor Cyan
                        Write-Host "$($Update.OriginUri)" -ForegroundColor DarkGray
                        if ($WebClient.IsPresent) {
                            $WebClient = New-Object System.Net.WebClient
                            $WebClient.DownloadFile("$($Update.OriginUri)","$DownloadFullPath")
                        } else {
                            Start-BitsTransfer -Source $Update.OriginUri -Destination $DownloadFullPath
                        }
                    } else {
                        #Write-Warning "Exists: $($Update.Title)"
                    }
                }
            } else {
                Return $OSDUpdates | Select-Object -Property Title
            }
        }
    }

    END {
        #Write-Host '========================================================================================' -ForegroundColor DarkGray
        #Write-Host "$($MyInvocation.MyCommand.Name) END" -ForegroundColor Green
    }
}