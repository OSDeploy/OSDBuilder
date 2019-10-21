function Import-OSDBuildPackOSRegistry {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)]
        [string]$OSDBuildPackPath,

        [string]$MountDirectory,

        [switch]$ShowRegContent
    )

    #======================================================================================
    #   Test-OSDBuildPackOSRegistry
    #======================================================================================
    $OSDBuildPackOSRegistry = "$OSDBuildPackPath\OSRegistry"

    if (!(Test-Path "$OSDBuildPackOSRegistry\*")) {
        Write-Verbose "Import-OSDBuildPackOSRegistry: Unable to locate content in $OSDBuildPackOSRegistry"
        Return
    } else {
        Write-Host "$OSDBuildPackOSRegistry" -ForegroundColor Cyan
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
        $OSDBuildPackTemp = "$env:TEMP\$(Get-Random)"
        if (!(Test-Path $OSDBuildPackTemp)) {New-Item -Path "$OSDBuildPackTemp" -ItemType Directory -Force | Out-Null}
    }

    #======================================================================================
    #   Get-RegFiles
    #======================================================================================
    [array]$OSDBuildPackOSRegistryFiles = @()
    [array]$OSDBuildPackOSRegistryFiles = Get-ChildItem "$OSDBuildPackOSRegistry" *.reg -Recurse | Select-Object -Property Name, BaseName, Extension, Directory, FullName

    #======================================================================================
    #	Import-OSDBuildPackOSRegistryFiles
    #======================================================================================
    foreach ($OSDRegistryRegFile in $OSDBuildPackOSRegistryFiles) {
        $OSDRegistryImportFile = $OSDRegistryRegFile.FullName

        if ($MountDirectory) {
            $RegFileContent = Get-Content -Path $OSDRegistryImportFile
            $OSDRegistryImportFile = "$OSDBuildPackTemp\$($OSDRegistryRegFile.BaseName).reg"

            $RegFileContent = $RegFileContent -replace 'HKEY_CURRENT_USER','HKEY_LOCAL_MACHINE\OfflineDefaultUser'
            $RegFileContent = $RegFileContent -replace 'HKEY_LOCAL_MACHINE\\SOFTWARE','HKEY_LOCAL_MACHINE\OfflineSoftware'
            $RegFileContent = $RegFileContent -replace 'HKEY_LOCAL_MACHINE\\SYSTEM','HKEY_LOCAL_MACHINE\OfflineSystem'
            $RegFileContent = $RegFileContent -replace 'HKEY_USERS\\.DEFAULT','HKEY_LOCAL_MACHINE\OfflineDefault'
            $RegFileContent | Set-Content -Path $OSDRegistryImportFile -Force
        }

        Write-Host "$OSDRegistryImportFile"  -ForegroundColor DarkGray
        if ($ShowRegContent.IsPresent){
            $OSDBuildPackRegFileContent = @()
            $OSDBuildPackRegFileContent = Get-Content -Path $OSDRegistryImportFile
            foreach ($Line in $OSDBuildPackRegFileContent) {
                Write-Host "$Line" -ForegroundColor Gray
            }
        }
        Start-Process reg -ArgumentList ('import',"`"$OSDRegistryImportFile`"") -Wait -WindowStyle Hidden -ErrorAction SilentlyContinue
    }
    
    #======================================================================================
    #	Remove-OSDBuildPackTemp
    #======================================================================================
    if ($MountDirectory) {
        if (Test-Path $OSDBuildPackTemp) {New-Item -Path "$OSDBuildPackTemp" -ItemType Directory -Force | Out-Null}
    }

    #======================================================================================
    #	Dismount-RegistryHives
    #======================================================================================
    if (($MountDirectory) -and (Test-Path "$MountDirectory" -ErrorAction SilentlyContinue)) {
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