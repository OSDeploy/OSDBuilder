function OSD-RegistryREG {
    [CmdletBinding()]
    PARAM ()
    #===================================================================================================
    Write-Verbose '19.2.1 Registry REG'
    #===================================================================================================
    Write-Host '========================================================================================' -ForegroundColor DarkGray
    Write-Host "Install.wim: Template Registry REG" -ForegroundColor Green

    #======================================================================================
    #	Import Registry REG
    #======================================================================================
    if ($RegistryTemplatesReg) {
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
function OSD-RegistryXML {
    [CmdletBinding()]
    PARAM ()
    #===================================================================================================
    Write-Verbose '19.1.30 Registry XML'
    #===================================================================================================
    Write-Host '========================================================================================' -ForegroundColor DarkGray
    Write-Host "Install.wim: Template Registry XML" -ForegroundColor Green

    #======================================================================================
    #	Import Registry XML
    #======================================================================================
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