function OSD-GetRegistryTemplatesReg {
    [CmdletBinding()]
    PARAM ()

    $RegistryTemplatesRegOriginal = @()
    $RegistryTemplatesRegOriginal = Get-ChildItem "$OSDBuilderTemplates\Registry\AutoApply" *.reg -Recurse | Select-Object -Property Name, BaseName, Extension, Directory, FullName
    
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

    Write-Host "$OSDBuilderTemplates\Registry\AutoApply\Global" -ForegroundColor DarkGray
    [array]$RegistryTemplatesReg = Get-ChildItem "$OSDBuilderTemplates\Registry\AutoApply\Global\*" *.reg.Offline -Recurse

    Write-Host "$OSDBuilderTemplates\Registry\AutoApply\Global $OSArchitecture" -ForegroundColor DarkGray
    [array]$RegistryTemplatesReg += Get-ChildItem "$OSDBuilderTemplates\Registry\AutoApply\Global $OSArchitecture\*" *.reg.Offline -Recurse

    Write-Host "$OSDBuilderTemplates\Registry\AutoApply\$UpdateOS" -ForegroundColor DarkGray
    [array]$RegistryTemplatesReg += Get-ChildItem "$OSDBuilderTemplates\Registry\AutoApply\$UpdateOS\*" *.reg.Offline -Recurse

    if ($OSInstallationType -notlike "*Server*") {
        Write-Host "$OSDBuilderTemplates\Registry\AutoApply\$UpdateOS $OSArchitecture" -ForegroundColor DarkGray
        [array]$RegistryTemplatesReg += Get-ChildItem "$OSDBuilderTemplates\Registry\AutoApply\$UpdateOS $OSArchitecture\*" *.reg.Offline -Recurse
    }
    if ($OSInstallationType -notlike "*Server*" -and $OSMajorVersion -eq 10) {
        Write-Host "$OSDBuilderTemplates\Registry\AutoApply\$UpdateOS $OSArchitecture $ReleaseId" -ForegroundColor DarkGray
        [array]$RegistryTemplatesReg += Get-ChildItem "$OSDBuilderTemplates\Registry\AutoApply\$UpdateOS $OSArchitecture $ReleaseId\*" *.reg.Offline -Recurse
    }
    Return $RegistryTemplatesReg
}

function OSD-GetRegistryTemplatesXml {
    [CmdletBinding()]
    PARAM ()

    $RegistryTemplatesXml = @()

    Write-Host "$OSDBuilderTemplates\Registry\AutoApply\Global" -ForegroundColor DarkGray
    [array]$RegistryTemplatesXml = Get-ChildItem "$OSDBuilderTemplates\Registry\AutoApply\Global\*" *.xml -Recurse

    Write-Host "$OSDBuilderTemplates\Registry\AutoApply\Global $OSArchitecture" -ForegroundColor DarkGray
    [array]$RegistryTemplatesXml += Get-ChildItem "$OSDBuilderTemplates\Registry\AutoApply\Global $OSArchitecture\*" *.xml -Recurse

    Write-Host "$OSDBuilderTemplates\Registry\AutoApply\$UpdateOS" -ForegroundColor DarkGray
    [array]$RegistryTemplatesXml += Get-ChildItem "$OSDBuilderTemplates\Registry\AutoApply\$UpdateOS\*" *.xml -Recurse

    if ($OSInstallationType -notlike "*Server*") {
        Write-Host "$OSDBuilderTemplates\Registry\AutoApply\$UpdateOS $OSArchitecture" -ForegroundColor DarkGray
        [array]$RegistryTemplatesXml += Get-ChildItem "$OSDBuilderTemplates\Registry\AutoApply\$UpdateOS $OSArchitecture\*" *.xml -Recurse
    }
    if ($OSInstallationType -notlike "*Server*" -and $OSMajorVersion -eq 10) {
        Write-Host "$OSDBuilderTemplates\Registry\AutoApply\$UpdateOS $OSArchitecture $ReleaseId" -ForegroundColor DarkGray
        [array]$RegistryTemplatesXml += Get-ChildItem "$OSDBuilderTemplates\Registry\AutoApply\$UpdateOS $OSArchitecture $ReleaseId\*" *.xml -Recurse
    }
    Return $RegistryTemplatesXml
}

function OSD-GetScriptTemplates {
    [CmdletBinding()]
    PARAM ()

    $ScriptTemplates = @()

    Write-Host "$OSDBuilderTemplates\Scripts\AutoApply\Global" -ForegroundColor DarkGray
    [array]$ScriptTemplates = Get-ChildItem "$OSDBuilderTemplates\Scripts\AutoApply\Global\*" *.ps1 -Recurse

    Write-Host "$OSDBuilderTemplates\Scripts\AutoApply\Global $OSArchitecture" -ForegroundColor DarkGray
    [array]$ScriptTemplates += Get-ChildItem "$OSDBuilderTemplates\Scripts\AutoApply\Global $OSArchitecture\*" *.ps1 -Recurse

    Write-Host "$OSDBuilderTemplates\Scripts\AutoApply\$UpdateOS" -ForegroundColor DarkGray
    [array]$ScriptTemplates += Get-ChildItem "$OSDBuilderTemplates\Scripts\AutoApply\$UpdateOS\*" *.ps1 -Recurse

    if ($OSInstallationType -notlike "*Server*") {
        Write-Host "$OSDBuilderTemplates\Scripts\AutoApply\$UpdateOS $OSArchitecture" -ForegroundColor DarkGray
        [array]$ScriptTemplates += Get-ChildItem "$OSDBuilderTemplates\Scripts\AutoApply\$UpdateOS $OSArchitecture\*" *.ps1 -Recurse
    }
    if ($OSInstallationType -notlike "*Server*" -and $OSMajorVersion -eq 10) {
        Write-Host "$OSDBuilderTemplates\Scripts\AutoApply\$UpdateOS $OSArchitecture $ReleaseId" -ForegroundColor DarkGray
        [array]$ScriptTemplates += Get-ChildItem "$OSDBuilderTemplates\Scripts\AutoApply\$UpdateOS $OSArchitecture $ReleaseId\*" *.ps1 -Recurse
    }
    Return $ScriptTemplates
}

function OSD-GetDriverTemplates {
    [CmdletBinding()]
    PARAM ()

    $DriverTemplates = @()

    Write-Host "$OSDBuilderTemplates\Drivers\AutoApply\Global" -ForegroundColor Gray
    [array]$DriverTemplates = Get-Item "$OSDBuilderTemplates\Drivers\AutoApply\Global"

    Write-Host "$OSDBuilderTemplates\Drivers\AutoApply\Global $OSArchitecture" -ForegroundColor Gray
    [array]$DriverTemplates += Get-Item "$OSDBuilderTemplates\Drivers\AutoApply\Global $OSArchitecture"

    Write-Host "$OSDBuilderTemplates\Drivers\AutoApply\$UpdateOS" -ForegroundColor Gray
    [array]$DriverTemplates += Get-Item "$OSDBuilderTemplates\Drivers\AutoApply\$UpdateOS"

    if ($OSInstallationType -notlike "*Server*") {
        Write-Host "$OSDBuilderTemplates\Drivers\AutoApply\$UpdateOS $OSArchitecture" -ForegroundColor Gray
        [array]$DriverTemplates += Get-Item "$OSDBuilderTemplates\Drivers\AutoApply\$UpdateOS $OSArchitecture"
    }
    if ($OSInstallationType -notlike "*Server*" -and $OSMajorVersion -eq 10) {
        Write-Host "$OSDBuilderTemplates\Drivers\AutoApply\$UpdateOS $OSArchitecture $ReleaseId" -ForegroundColor Gray
        [array]$DriverTemplates += Get-Item "$OSDBuilderTemplates\Drivers\AutoApply\$UpdateOS $OSArchitecture $ReleaseId"
    }
    Return $DriverTemplates
}

function OSD-GetExtraFilesTemplates {
    [CmdletBinding()]
    PARAM ()

    $ExtraFilesTemplates = @()

    Write-Host "$OSDBuilderTemplates\ExtraFiles\AutoApply\Global" -ForegroundColor DarkGray
    [array]$ExtraFilesTemplates = Get-ChildItem "$OSDBuilderTemplates\ExtraFiles\AutoApply\Global" | Where-Object {$_.PSIsContainer -eq $true} 

    Write-Host "$OSDBuilderTemplates\ExtraFiles\AutoApply\Global $OSArchitecture" -ForegroundColor DarkGray
    [array]$ExtraFilesTemplates += Get-ChildItem "$OSDBuilderTemplates\ExtraFiles\AutoApply\Global $OSArchitecture" | Where-Object {$_.PSIsContainer -eq $true} 

    Write-Host "$OSDBuilderTemplates\ExtraFiles\AutoApply\$UpdateOS" -ForegroundColor DarkGray
    [array]$ExtraFilesTemplates += Get-ChildItem "$OSDBuilderTemplates\ExtraFiles\AutoApply\$UpdateOS" | Where-Object {$_.PSIsContainer -eq $true} 

    if ($OSInstallationType -notlike "*Server*") {
        Write-Host "$OSDBuilderTemplates\ExtraFiles\AutoApply\$UpdateOS $OSArchitecture" -ForegroundColor DarkGray
        [array]$ExtraFilesTemplates += Get-ChildItem "$OSDBuilderTemplates\ExtraFiles\AutoApply\$UpdateOS $OSArchitecture" | Where-Object {$_.PSIsContainer -eq $true} 
    }
    if ($OSInstallationType -notlike "*Server*" -and $OSMajorVersion -eq 10) {
        Write-Host "$OSDBuilderTemplates\ExtraFiles\AutoApply\$UpdateOS $OSArchitecture $ReleaseId" -ForegroundColor DarkGray
        [array]$ExtraFilesTemplates += Get-ChildItem "$OSDBuilderTemplates\ExtraFiles\AutoApply\$UpdateOS $OSArchitecture $ReleaseId" | Where-Object {$_.PSIsContainer -eq $true} 
    }
    Return $ExtraFilesTemplates
}