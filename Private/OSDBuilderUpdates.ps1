function OSD-Update-GetOSDUpdates {
    $AllOSDUpdates = @()
    $CatalogsXmls = @()
    $CatalogsXmls = Get-ChildItem "$($MyInvocation.MyCommand.Module.ModuleBase)\Catalogs\*" -Include *.xml
    foreach ($CatalogsXml in $CatalogsXmls) {
        $AllOSDUpdates += Import-Clixml -Path "$($CatalogsXml.FullName)"
    }
    #===================================================================================================
    #   Standard Filters
    #===================================================================================================
    $AllOSDUpdates = $AllOSDUpdates | Where-Object {$_.FileName -notlike "*.exe"}
    $AllOSDUpdates = $AllOSDUpdates | Where-Object {$_.FileName -notlike "*.psf"}
    $AllOSDUpdates = $AllOSDUpdates | Where-Object {$_.FileName -notlike "*.txt"}
    $AllOSDUpdates = $AllOSDUpdates | Where-Object {$_.FileName -notlike "*delta.exe"}
    $AllOSDUpdates = $AllOSDUpdates | Where-Object {$_.FileName -notlike "*express.cab"}
    $AllOSDUpdates = $AllOSDUpdates | Where-Object {$_.Title -notlike "* Next *"}
    #===================================================================================================
    #   Get Downloaded Updates
    #===================================================================================================
    foreach ($Update in $AllOSDUpdates) {
        $FullUpdatePath = "$OSDBuilderPath\Content\OSDUpdate\$($Update.Catalog)\$($Update.Title)\$($Update.FileName)"
        if (Test-Path $FullUpdatePath) {
            $Update.OSDStatus = "Downloaded"
        }
    }
    #===================================================================================================
    #   Return
    #===================================================================================================
    $AllOSDUpdates = $AllOSDUpdates | Select-Object -Property *
    Return $AllOSDUpdates
}

function OSD-Update-Download {
    [CmdletBinding()]
    PARAM (
        [string]$OSDGuid,
        [string]$UpdateTitle
    )
    #===================================================================================================
    #   Filtering
    #===================================================================================================
    if ($OSDGuid) {
        $OSDUpdateDownload = OSD-Update-GetOSDUpdates | Where-Object {$_.OSDGuid -eq $OSDGuid}
    } elseif ($UpdateTitle) {
        $OSDUpdateDownload = OSD-Update-GetOSDUpdates | Where-Object {$_.UpdateTitle -eq $UpdateTitle}
    } else {
        Break
    }
    #===================================================================================================
    #   Download
    #===================================================================================================
    foreach ($Update in $OSDUpdateDownload) {
        $DownloadPath = "$OSDBuilderPath\Content\OSDUpdate\$($Update.Catalog)\$($Update.Title)"
        $DownloadFullPath = "$DownloadPath\$($Update.FileName)"
        if (!(Test-Path $DownloadPath)) {New-Item -Path "$DownloadPath" -ItemType Directory -Force | Out-Null}
        if (!(Test-Path $DownloadFullPath)) {
            Write-Host "$DownloadFullPath" -ForegroundColor Cyan
            Write-Host "$($Update.OriginUri)" -ForegroundColor Gray
            $WebClient = New-Object System.Net.WebClient
            $WebClient.DownloadFile("$($Update.OriginUri)","$DownloadFullPath")
            #Start-BitsTransfer -Source $Update.OriginUri -Destination $DownloadFullPath
        }
    }
}

function Get-MediaESDDownloads {
    $MediaESDDownloads = @()
    $CatalogsXmls = @()
    $CatalogsXmls = Get-ChildItem "$($MyInvocation.MyCommand.Module.ModuleBase)\CatalogsESD\*" -Include *.xml
    foreach ($CatalogsXml in $CatalogsXmls) {
        $MediaESDDownloads += Import-Clixml -Path "$($CatalogsXml.FullName)"
    }
    #===================================================================================================
    #   Get Downloadeds
    #===================================================================================================
    foreach ($Download in $MediaESDDownloads) {
        $FullUpdatePath = "$OSDBuilderPath\MediaESD\$($Update.FileName)"
        if (Test-Path $FullUpdatePath) {
            $Download.OSDStatus = "Downloaded"
        }
    }
    #===================================================================================================
    #   Return
    #===================================================================================================
    $MediaESDDownloads = $MediaESDDownloads | Select-Object -Property *
    Return $MediaESDDownloads
}