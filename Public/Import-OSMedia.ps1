<#
.SYNOPSIS
Imports a supported Operating System into the OSDBuilder OSImport directory

.DESCRIPTION
Imports a supported Operating System into the OSDBuilder OSImport directory

.LINK
https://osdbuilder.osdeploy.com/module/functions/import-osmedia
#>
function Import-OSMedia {
    [CmdletBinding()]
    param (
        #Unsupported
        #Allows the import of an unsupported OS
        #THIS PARAMETER IS NOT A GUARANTEE OF ANY FUNCTIONALITY
        #THIS PARAMETER IS A GUARANTEE OF BEING GHOSTED IF YOU CONTACT THE DEV FOR SUPPORT
        [switch]$AllowUnsupportedOS = $global:SetOSDBuilder.ImportOSMediaAllowUnsupportedOS,
        
        #Creates an OSBuild with NetFX enabled
        #Import-OSMedia -Edition Enterprise -SkipGrid -QuickBuild
        #Execute Command:
        #New-OSBuild -Name $OSMediaName -Download -Execute -HideCleanupProgress -SkipTask -QuickEnableNetFX
        #Alias: Build,BuildNetFX
        [Alias('Build')]
        [switch]$BuildNetFX = $global:SetOSDBuilder.ImportOSMediaBuildNetFX,
        
        #The Operating System EditionId to import
        #Import-OSMedia -EditionId Enterprise
        #Import-OSMedia -EditionId Enterprise -SkipGrid
        #Values:
        #Education
        #EducationN
        #Enterprise
        #EnterpriseN
        #EnterpriseS
        #EnterpriseSN
        #Professional
        #ProfessionalEducation
        #ProfessionalEducationN
        #ProfessionalN
        #ProfessionalWorkstation
        #ProfessionalWorkstationN
        #ServerDatacenter
        #ServerDatacenterACor
        #ServerRdsh
        #ServerStandard
        #ServerStandardACor
        [ValidateSet(`
            'Education',`
            'Enterprise',`
            'Professional',`
            'ProfessionalEducation',`
            'ProfessionalWorkstation',`
            'ServerStandard',`
            'ServerDatacenter',`
            'ServerStandardACor',`
            'ServerDatacenterACor',`
            'ServerRdsh',`
            'EducationN',`
            'EnterpriseN',`
            'EnterpriseS',`
            'EnterpriseSN',`
            'ProfessionalN',`
            'ProfessionalEducationN',`
            'ProfessionalWorkstationN'
        )]
        #Alias: Edition
        [Alias('Edition')]
        [string[]]$EditionId = $global:SetOSDBuilder.ImportOSMediaEditionId,

        #The Operating System Index to Import
        #Import-OSMedia -ImageIndex 3
        #Import-OSMedia -ImageIndex 3 -SkipGrid
        #Alias: Index
        [Alias('Index')]
        [int]$ImageIndex = $global:SetOSDBuilder.ImportOSMediaImageIndex,
        
        #The Operating System ImageName to Import
        #Import-OSMedia -ImageName 'Windows 10 Enterprise'
        #Import-OSMedia -ImageName 'Windows 10 Enterprise' -SkipGrid
        #Values:
        #Windows 10 Education
        #Windows 10 Enterprise
        #Windows 10 Enterprise for Virtual Desktops
        #Windows 10 Enterprise 2016 LTSB
        #Windows 10 Enterprise LTSC
        #Windows 10 Pro
        #Windows 10 Pro Education
        #Windows 10 Pro for Workstations
        #Windows 10 Education N
        #Windows 10 Enterprise N
        #Windows 10 Enterprise N LTSC
        #Windows 10 Pro N
        #Windows 10 Pro Education N
        #Windows 10 Pro N for Workstations
        #Windows Server Standard
        #Windows Server Datacenter
        #Windows Server 2016 Standard
        #Windows Server 2016 Standard (Desktop Experience)
        #Windows Server 2016 Datacenter
        #Windows Server 2016 Datacenter (Desktop Experience)
        #Windows Server 2019 Standard
        #Windows Server 2019 Standard (Desktop Experience)
        #Windows Server 2019 Datacenter
        #Windows Server 2019 Datacenter (Desktop Experience)
        [ValidateSet(`
            'Windows 10 Education',`
            'Windows 10 Enterprise',`
            'Windows 10 Enterprise for Virtual Desktops',`
            'Windows 10 Enterprise 2016 LTSB',`
            'Windows 10 Enterprise LTSC',`
            'Windows 10 Pro',`
            'Windows 10 Pro Education',`
            'Windows 10 Pro for Workstations',`
            'Windows 10 Education N',`
            'Windows 10 Enterprise N',`
            'Windows 10 Enterprise N LTSC',`
            'Windows 10 Pro N',`
            'Windows 10 Pro Education N',`
            'Windows 10 Pro N for Workstations',`
            'Windows 11 Education',`
            'Windows 11 Enterprise',`
            'Windows 11 Enterprise for Virtual Desktops',`
            'Windows 11 Enterprise 2016 LTSB',`
            'Windows 11 Enterprise LTSC',`
            'Windows 11 Pro',`
            'Windows 11 Pro Education',`
            'Windows 11 Pro for Workstations',`
            'Windows 11 Education N',`
            'Windows 11 Enterprise N',`
            'Windows 11 Enterprise N LTSC',`
            'Windows 11 Pro N',`
            'Windows 11 Pro Education N',`
            'Windows 11 Pro N for Workstations',`
            'Windows Server Standard',`
            'Windows Server Datacenter',
            'Windows Server 2019 Standard',`
            'Windows Server 2019 Standard (Desktop Experience)',`
            'Windows Server 2019 Datacenter',`
            'Windows Server 2019 Datacenter (Desktop Experience)',
            'Windows Server 2022 Standard',`
            'Windows Server 2022 Standard (Desktop Experience)',`
            'Windows Server 2022 Datacenter',`
            'Windows Server 2022 Datacenter (Desktop Experience)'
        )]
        [string[]]$ImageName = $global:SetOSDBuilder.ImportOSMediaImageName,

        #The Operating System InstallationType to Import
        #Import-OSMedia -InstallationType 'Client'
        #Import-OSMedia -InstallationType 'Server Core' -SkipGrid
        [ValidateSet(`
            'Client',`
            'Server',`
            'Server Core'
        )]
        [string[]]$InstallationType = $global:SetOSDBuilder.ImportOSMediaInstallationType,

        [String]$Path = $global:SetOSDBuilder.ImportOSMediaPath,

        #Displays Media Information after Import
        #Show-OSDBuilderInfo -FullName $OSMediaPath
        #Alias: OSDInfo
        [Alias('OSDInfo')]
        [switch]$ShowInfo = $global:SetOSDBuilder.ImportOSMediaShowInfo,

        #Skips the searh of the FeatureUpdates path for downloaded Feature Updates
        [switch]$SkipFeatureUpdates = $global:SetOSDBuilder.ImportOSMediaSkipFeatureUpdates,
        
        #Used to bypass the ISE GridView Operating System Selection
        #Must use EditionId or ImageName Parameter for best results
        #Alias: SkipGridView
        [Alias('SkipGridView')]
        [switch]$SkipGrid = $global:SetOSDBuilder.ImportOSMediaSkipGrid,

        #Creates an OSMedia with all Microsoft Updates applied
        #Import-OSMedia -Edition Enterprise -SkipGrid -QuickUpdate
        #Execute Command:
        #Update-OSMedia -Name $OSMediaName -Download -Execute -HideCleanupProgress
        #Alias: UpdateOSMedia
        [Alias('UpdateOSMedia')]
        [switch]$Update = $global:SetOSDBuilder.ImportOSMediaUpdate
    )
    #=================================================
    #   Variables
    #=================================================
    #ImportOSMediaPSDrives
    #ImportOSMediaOperatingSystems
    #ImportOSMediaFeatureUpdates
    #ImportOSMediaPSDrives
    #ImportOSMediaPSDrives
    
    begin {
        Write-Host '========================================================================================' -ForegroundColor DarkGray
        Write-Host -ForegroundColor Green "$($MyInvocation.MyCommand.Name) BEGIN"
        #=================================================
        #   Get-OSDBuilder
        #=================================================
        Show-ActionTime; Write-Host 'Get-OSDBuilder: Validating OSDBuilder Content'
        Show-ActionTime; Write-Warning 'This version of OSDBuilder only supports:'
        Show-ActionTime; Write-Warning 'Windows 10 1607 - 21H2'
        Show-ActionTime; Write-Warning 'Windows 11 21H2'
        Show-ActionTime; Write-Warning 'Windows Server 2016 1607 - Windows Server 2022 21H1'
        Get-OSDBuilder -CreatePaths -HideDetails
        #=================================================
        #   Block
        #=================================================
        Block-StandardUser
        #=================================================
        #   ImportOSMediaOperatingSystems
        #=================================================
        $ImportOSMediaOperatingSystems = @()
        #=================================================
        #   Path
        #=================================================
        if ($Path) {
            Show-ActionTime; Write-Host "Test-Path: $Path"
            if (Test-Path "$Path") {
                Show-ActionTime; Write-Host "Get-ChildItem: Finding OS Media in $Path"
                $PathSources = Get-ChildItem "$Path" -Recurse | Where-Object {$_.PSIsContainer -and $_.Name -eq 'Sources'}

                foreach ($item in $PathSources) {
                    $ImportOSMediaOperatingSystems += Get-ChildItem "$($item.FullName)\*" -Include install.wim,install.esd | Select-Object -Property @{Name="OSRoot";Expression={(Get-Item $_.Directory).Parent.FullName}}, @{Name="OSWim";Expression={$_.FullName}}
                }
            } else {
                Show-ActionTime; Write-Warning "Test-Path: Could not find specified Path '$Path'. Throw BREAK"
                Pause
                Break
            }
        } else {
            #=================================================
            #   GetPSDrives
            #=================================================
            $ImportOSMediaPSDrives = @()
            $ImportOSMediaPSDrives = Get-PSDrive -PSProvider 'FileSystem'
            #=================================================
            #   ImportOSMediaOperatingSystems ImportOSMediaPSDrives
            #=================================================
            foreach ($item in $ImportOSMediaPSDrives) {
                if (Test-Path "$($item.Root)Sources") {
                    $ImportOSMediaOperatingSystems += Get-ChildItem "$($item.Root)Sources\*" -Include install.wim,install.esd | Select-Object -Property @{Name="OSRoot";Expression={(Get-Item $_.Directory).Parent.FullName}}, @{Name="OSWim";Expression={$_.FullName}}
                }
                if (Test-Path "$($item.Root)x64\Sources") {
                    $ImportOSMediaOperatingSystems += Get-ChildItem "$($item.Root)x64\Sources\*" -Include install.wim,install.esd | Select-Object -Property @{Name="OSRoot";Expression={(Get-Item $_.Directory).Parent.FullName}}, @{Name="OSWim";Expression={$_.FullName}}
                }
                if (Test-Path "$($item.Root)x86\Sources") {
                    $ImportOSMediaOperatingSystems += Get-ChildItem "$($item.Root)x86\Sources\*" -Include install.wim,install.esd | Select-Object -Property @{Name="OSRoot";Expression={(Get-Item $_.Directory).Parent.FullName}}, @{Name="OSWim";Expression={$_.FullName}}
                }
            }
            #=================================================
            #   ImportOSMediaFeatureUpdates
            #=================================================
            $ImportOSMediaFeatureUpdates = @()
            if ($SkipFeatureUpdates -ne $true) {
                $ImportOSMediaFeatureUpdates = Get-ChildItem $global:SetOSDBuilderPathFeatureUpdates -ErrorAction SilentlyContinue
                foreach ($item in $ImportOSMediaFeatureUpdates) {
                    if (Test-Path "$($item.FullName)\Sources") {
                        $ImportOSMediaOperatingSystems += Get-ChildItem "$($item.FullName)\Sources\*" -Include install.wim,install.esd | Select-Object -Property @{Name="OSRoot";Expression={(Get-Item $_.Directory).Parent.FullName}}, @{Name="OSWim";Expression={$_.FullName}}
                    }
                }
            }
        }
        #=================================================
        #   Validate ImportOSMediaOperatingSystems
        #=================================================
        if ($null -eq $ImportOSMediaOperatingSystems) {
            Write-Host '========================================================================================' -ForegroundColor DarkGray
            Show-ActionTime; Write-Warning "Windows Image could not be found on any CD or DVD Drives.  Throw BREAK"
            Break
        }
        #=================================================
        #   ImportOSMediaWindowsImages
        #=================================================
        $ImportOSMediaWindowsImages = $ImportOSMediaOperatingSystems | ForEach-Object {
            Write-Host '========================================================================================' -ForegroundColor DarkGray
            Show-ActionTime; Write-Host "Media: Scan $($_.OSWim)" -ForegroundColor Green
            Get-WindowsImage -ImagePath "$($_.OSWim)"} | ForEach-Object {
                Get-WindowsImage -ImagePath "$($_.ImagePath)" -Index $($_.ImageIndex) | Select-Object -Property *
                Write-Host "ImageIndex $($_.ImageIndex): $($_.ImageName)" -ForegroundColor DarkGray
            }

        $ImportOSMediaWindowsImages = $ImportOSMediaWindowsImages | Select-Object -Property ImagePath, ImageIndex, ImageName, Architecture, EditionId, Languages, InstallationType, Version, MajorVersion, MinorVersion, Build, SPBuild, SPLevel, CreatedTime, ModifiedTime
        foreach ($Image in $ImportOSMediaWindowsImages) {
            if ($Image.Architecture -eq '0') {$Image.Architecture = 'x86'}
            if ($Image.Architecture -eq '6') {$Image.Architecture = 'ia64'}
            if ($Image.Architecture -eq '9') {$Image.Architecture = 'x64'}
            if ($Image.Architecture -eq '12') {$Image.Architecture = 'x64 ARM'}
        }
        #=================================================
        #   AllowUnsupportedOS
        #   Major Version gt 10
        #   Build ge 1809
        #=================================================
        Write-Verbose "Filtering Windows Major Version gt 10 and Build ge 1809"
        $ImportOSMediaWindowsImages = $ImportOSMediaWindowsImages | Where-Object {($_.MajorVersion -eq '10')}
        #=================================================
        #   ImportOSMediaWindowsImages Filter
        #=================================================
        if ($EditionId) {
            $ImportOSMediaWindowsImages = $ImportOSMediaWindowsImages | Where-Object {$_.EditionId -in $EditionId}
        }
        if ($ImageName) {
            $ImportOSMediaWindowsImages = $ImportOSMediaWindowsImages | Where-Object {$_.ImageName -in $ImageName}
        }
        if ($InstallationType) {
            $ImportOSMediaWindowsImages = $ImportOSMediaWindowsImages | Where-Object {$_.InstallationType -in $InstallationType}
        }
        if ($ImageIndex) {$ImportOSMediaWindowsImages = $ImportOSMediaWindowsImages | Where-Object {$_.ImageIndex -eq $ImageIndex}}
        #=================================================
        #   ImportOSMediaWindowsImages GridView
        #=================================================
        if (@($ImportOSMediaWindowsImages).Count -gt 0) {
            if (!($SkipGrid.IsPresent)) {
                $ImportOSMediaWindowsImages = $ImportOSMediaWindowsImages | Out-GridView -Title "Import-OSMedia: Select OSMedia to Import and press OK (Cancel to Exit)" -PassThru        
                if($null -eq $ImportOSMediaWindowsImages) {
                    Write-Host '========================================================================================' -ForegroundColor DarkGray
                    Show-ActionTime; Write-Warning "Import-OSMedia: Compatible OSMedia was not selected . . . Exiting!"
                    Break
                }
            }
        } else {
            Write-Host '========================================================================================' -ForegroundColor DarkGray
            Show-ActionTime; Write-Warning "Import-OSMedia: OSMedia was not found . . . Exiting!"
            Break
        }
    }

    process {
        Write-Host '========================================================================================' -ForegroundColor DarkGray
        Write-Host -ForegroundColor Green "$($MyInvocation.MyCommand.Name) PROCESS"
        Write-Verbose "MyInvocation.MyCommand.Name: $($MyInvocation.MyCommand.Name)"
        Write-Verbose "PSCmdlet.ParameterSetName: $($PSCmdlet.ParameterSetName)"
        #=================================================
        foreach ($ImportOSMediaWindowsImage in $ImportOSMediaWindowsImages) {
            #=================================================
            #   New PROCESS
            #=================================================
            $OSMediaGetItem = Get-Item $ImportOSMediaWindowsImage.ImagePath

            $SourceImagePath = $OSMediaGetItem.FullName
            $SourceImageIndex = $ImportOSMediaWindowsImage.ImageIndex
            $SourceOSMedia =  ($OSMediaGetItem).Directory.Parent.FullName

            $GetWindowsImage = Get-WindowsImage -ImagePath $SourceImagePath -Index $SourceImageIndex | Select-Object -Property *
            $GetWindowsImage.ImageName = $GetWindowsImage.ImageName -replace '\(', ''
            $GetWindowsImage.ImageName = $GetWindowsImage.ImageName -replace '\)', ''
            if ($GetWindowsImage.Architecture -eq '0')  {$GetWindowsImage.Architecture = 'x86'}
            if ($GetWindowsImage.Architecture -eq '6')  {$GetWindowsImage.Architecture = 'ia64'}
            if ($GetWindowsImage.Architecture -eq '9')  {$GetWindowsImage.Architecture = 'x64'}
            if ($GetWindowsImage.Architecture -eq '12') {$GetWindowsImage.Architecture = 'x64 ARM'}
            #=================================================
            #   ESD: Export-WindowsImage
            #=================================================
            if ($OSMediaGetItem.Extension -eq '.esd') {
                $SourceTempWim = "$env:Temp\$((Get-Date).ToString('HHmmss')).wim"

                Write-Host '========================================================================================' -ForegroundColor DarkGray
                Write-Host "Image: Export Install.esd Index $SourceImageIndex to $SourceTempWim" -ForegroundColor Green
                
                $CurrentLog = "$env:Temp\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Export-WindowsImage.log"
                Write-Verbose "CurrentLog: $CurrentLog"
                Export-WindowsImage -SourceImagePath $SourceImagePath -SourceIndex $SourceImageIndex -DestinationImagePath $SourceTempWim -CheckIntegrity -CompressionType max -LogPath "$CurrentLog" | Out-Null
            }

            $MountDirectory = Join-Path $global:SetOSDBuilderPathMount "os$((Get-Date).ToString('HHmmss'))"
            Mount-ImportOSMediaWim
            #=================================================
            #   Get-RegCurrentVersion
            #=================================================
            $RegKeyCurrentVersion = Get-RegCurrentVersion -Path $MountDirectory
            #=================================================
            #   Set Additional Properties
            #=================================================
            $RegValueUbr = $null
            $RegValueReleaseId = $null
            $RegValueCurrentBuild = $null
            $OSMGuid = $(New-Guid)

            if ($GetWindowsImage.MajorVersion -eq '10') {
                $RegValueUbr = ($RegKeyCurrentVersion).UBR
                $RegValueReleaseId = ($RegKeyCurrentVersion).ReleaseId
                $RegValueCurrentBuild = ($RegKeyCurrentVersion).CurrentBuild
                $RegValueDisplayVersion = ($RegKeyCurrentVersion).DisplayVersion

                if ($RegValueDisplayVersion) {$RegValueReleaseId = $RegValueDisplayVersion}

                $UBR = "$($RegValueCurrentBuild).$($RegValueUbr)"
                $OSMediaName = "$($GetWindowsImage.ImageName) $($GetWindowsImage.Architecture) $RegValueReleaseId $UBR $($GetWindowsImage.Languages)"
            } else {
                $UBR = "$($GetWindowsImage.Build).$($GetWindowsImage.SPBuild)"
                $OSMediaName = "$($GetWindowsImage.ImageName) $($GetWindowsImage.Architecture) $UBR $($GetWindowsImage.Languages)"
            }

            $GetWindowsImage | Add-Member -Type NoteProperty -Name "CurrentBuild" -Value $RegValueCurrentBuild -Force
            $GetWindowsImage | Add-Member -Type NoteProperty -Name "DisplayVersion" -Value $RegValueDisplayVersion -Force
            $GetWindowsImage | Add-Member -Type NoteProperty -Name "ReleaseId" -Value $RegValueReleaseId -Force
            $GetWindowsImage | Add-Member -Type NoteProperty -Name "UBR" -Value $UBR -Force
            $GetWindowsImage | Add-Member -Type NoteProperty -Name "OSMGuid" -Value $OSMGuid -Force
            #=================================================
            #   Edit OSMediaName
            #=================================================
            if (($GetWindowsImage.Languages).count -eq 1) {$OSMediaName = $OSMediaName.replace(' en-US','')}
            #=================================================
            #   Set OSMediaPath
            #=================================================
            $OSMediaPath = Join-Path $global:SetOSDBuilderPathOSImport $OSMediaName
            #=================================================
            #   Remove Existing OSMedia
            #=================================================
            if (Test-Path $OSMediaPath) {
                Write-Warning "$OSMediaPath exists.  Contents will be replaced!"
                Remove-Item -Path "$OSMediaPath" -Force -Recurse
            }
            #=================================================
            #   Set Working Directories
            #=================================================
            $OSMediaPathInfo = Join-Path $OSMediaPath 'info'
            if (!(Test-Path "$OSMediaPathInfo"))           {New-Item "$OSMediaPathInfo" -ItemType Directory -Force | Out-Null}
            if (!(Test-Path "$OSMediaPathInfo\json"))      {New-Item "$OSMediaPathInfo\json" -ItemType Directory -Force | Out-Null}
            if (!(Test-Path "$OSMediaPathInfo\logs"))      {New-Item "$OSMediaPathInfo\logs" -ItemType Directory -Force | Out-Null}
            if (!(Test-Path "$OSMediaPathInfo\xml"))       {New-Item "$OSMediaPathInfo\xml" -ItemType Directory -Force | Out-Null}
            
            $OSMediaPathOS = Join-Path $OSMediaPath 'OS'
            if (!(Test-Path "$OSMediaPathOS"))             {New-Item "$OSMediaPathOS" -ItemType Directory -Force | Out-Null}
            $OSMediaPathWindowsImage = $OSMediaPathOS + "\Sources\install.wim"

            $OSMediaPathWinPE = Join-Path $OSMediaPath 'WinPE'
            if (!(Test-Path "$OSMediaPathWinPE"))          {New-Item "$OSMediaPathWinPE" -ItemType Directory -Force | Out-Null}

            $OSMediaPathPEInfo = Join-Path $OSMediaPathWinPE 'info'
            if (!(Test-Path "$OSMediaPathPEInfo"))         {New-Item "$OSMediaPathPEInfo" -ItemType Directory -Force | Out-Null}
            if (!(Test-Path "$OSMediaPathPEInfo\json"))    {New-Item "$OSMediaPathPEInfo\json" -ItemType Directory -Force | Out-Null}
            if (!(Test-Path "$OSMediaPathPEInfo\logs"))    {New-Item "$OSMediaPathPEInfo\logs" -ItemType Directory -Force | Out-Null}
            if (!(Test-Path "$OSMediaPathPEInfo\xml"))     {New-Item "$OSMediaPathPEInfo\xml" -ItemType Directory -Force | Out-Null}
            #=================================================
            #   Export RegistryCurrentVersionKey
            #=================================================
            $RegKeyCurrentVersion | Out-File "$OSMediaPathInfo\CurrentVersion.txt"
            $RegKeyCurrentVersion | Out-File "$OSMediaPath\CurrentVersion.txt"
            $RegKeyCurrentVersion | Out-File "$OSMediaPathInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-CurrentVersion.txt"
            $RegKeyCurrentVersion | Export-Clixml -Path "$OSMediaPathInfo\xml\CurrentVersion.xml"
            $RegKeyCurrentVersion | Export-Clixml -Path "$OSMediaPathInfo\xml\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-CurrentVersion.xml"
            $RegKeyCurrentVersion | ConvertTo-Json | Out-File "$OSMediaPathInfo\json\CurrentVersion.json"
            $RegKeyCurrentVersion | ConvertTo-Json | Out-File "$OSMediaPathInfo\json\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-CurrentVersion.json"
            #=================================================
            #   Start-Transcript
            #=================================================
            Write-Host '========================================================================================' -ForegroundColor DarkGray
            $ScriptName = $MyInvocation.MyCommand.Name
            $LogName = "$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-$ScriptName.log"
            Start-Transcript -Path (Join-Path "$OSMediaPathInfo\logs" $LogName)
            $GetWindowsImage
            #=================================================
            #   Image Information
            #=================================================
            #Show-GetWindowsImage
            Show-OSMediaInfo
            #=================================================
            #   Media: Copy Operating System
            #=================================================
            Write-Host '========================================================================================' -ForegroundColor DarkGray
            Show-ActionTime; Write-Host "Media: Copy Operating System to $OSMediaPathOS" -ForegroundColor Green

            #Copy-Item -Path "$SourceOSMedia\*" -Destination "$OSMediaPathOS" -Exclude "install.$($OSMediaGetItem.Extension)" -Recurse -Force | Out-Null
            robocopy "$SourceOSMedia" "$OSMediaPathOS" *.* /e /xf install.wim install.esd | Out-Null
            Get-ChildItem -Recurse -Path "$OSMediaPathOS\*" | Set-ItemProperty -Name IsReadOnly -Value $false -ErrorAction SilentlyContinue | Out-Null

            if ($OSMediaGetItem.Extension -eq '.esd') {        
                $CurrentLog = "$OSMediaPathInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Export-WindowsImage.log"
                Write-Verbose "CurrentLog: $CurrentLog"
                Export-WindowsImage -SourceImagePath $SourceTempWim -SourceIndex 1 -DestinationImagePath "$OSMediaPathOS\sources\install.wim" -LogPath "$CurrentLog" | Out-Null
            } else {            
                $CurrentLog = "$OSMediaPathInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Export-WindowsImage.log"
                Write-Verbose "CurrentLog: $CurrentLog"
                Export-WindowsImage -SourceImagePath $SourceImagePath -SourceIndex $SourceImageIndex -DestinationImagePath "$OSMediaPathOS\sources\install.wim" -LogPath "$CurrentLog" | Out-Null
            }
            #=================================================
            #   Export-Inventory
            #=================================================
            Save-AutoExtraFilesOS -OSMediaPath $OSMediaPath
            Save-SessionsXmlOS -OSMediaPath $OSMediaPath
            Save-InventoryOS -OSMediaPath $OSMediaPath
            Save-WimsPE -OSMediaPath $OSMediaPath
            Save-InventoryPE -OSMediaPath $OSMediaPath
            #=================================================
            #   Dismount-WindowsImage
            #=================================================
            Show-ActionTime; Write-Host "Install.wim: Dismount from $MountDirectory" -ForegroundColor Green
            if ($OSMediaGetItem.Extension -eq '.esd') {
                try {Remove-Item $SourceTempWim -Force | Out-Null}
                catch {Write-Warning "Could not remove $SourceTempWim"}
            }

            $CurrentLog = "$OSMediaPathInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Dismount-WindowsImage.log"
            Write-Verbose "CurrentLog: $CurrentLog"
            Dismount-WindowsImage -Discard -Path "$MountDirectory" -LogPath "$CurrentLog" | Out-Null
            #=================================================
            #   Export-Configuration
            #=================================================
            Show-ActionTime; Write-Host "Install.wim: Export Configuration to $OSMediaPath\WindowsImage.txt" -ForegroundColor Green
            $GetWindowsImage = @()
            $GetWindowsImage = Get-WindowsImage -ImagePath "$OSMediaPathOS\sources\install.wim" -Index 1 | Select-Object -Property *

            $GetWindowsImage | Add-Member -Type NoteProperty -Name "CurrentBuild" -Value $RegValueCurrentBuild
            $GetWindowsImage | Add-Member -Type NoteProperty -Name "ReleaseId" -Value $RegValueReleaseId
            $GetWindowsImage | Add-Member -Type NoteProperty -Name "UBR" -Value $UBR
            $GetWindowsImage | Add-Member -Type NoteProperty -Name "OSMGuid" -Value $OSMGuid

            Write-Verbose "========== SPBuild: $($GetWindowsImage.Build).$($GetWindowsImage.SPBuild)"
            if ($GetWindowsImage.Version -like "6.1*") {
                Write-Verbose '========== Windows 6.1'
                $UBR = "$($GetWindowsImage.Build).$($GetWindowsImage.SPBuild)"
            }
            Write-Verbose "========== UBR: $UBR"
            
            $GetWindowsImage | Out-File "$OSMediaPath\WindowsImage.txt"
            $GetWindowsImage | Out-File "$OSMediaPathInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsImage.txt"
            $GetWindowsImage | Export-Clixml -Path "$OSMediaPathInfo\xml\Get-WindowsImage.xml"
            $GetWindowsImage | Export-Clixml -Path "$OSMediaPathInfo\xml\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsImage.xml"
            $GetWindowsImage | ConvertTo-Json | Out-File "$OSMediaPathInfo\json\Get-WindowsImage.json"
            $GetWindowsImage | ConvertTo-Json | Out-File "$OSMediaPathInfo\json\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsImage.json"
            (Get-Content "$OSMediaPath\WindowsImage.txt") | Where-Object {$_.Trim(" `t")} | Set-Content "$OSMediaPath\WindowsImage.txt"
            #=================================================
            #    OSD-Export
            #=================================================
            Save-OSMediaWindowsImageContent
            Save-OSMediaVariables
            if ($ShowInfo.IsPresent) {Show-OSDBuilderInfo -FullName $OSMediaPath}
            Stop-Transcript
            #=================================================
            #   Update-OSMedia
            #=================================================
            if ($Update.IsPresent) {
                Update-OSMedia -Name "$OSMediaName" -Download -Execute -HideCleanupProgress
            }
            #=================================================
            #   New-OSBuild
            #=================================================
            if ($BuildNetFX.IsPresent) {
                New-OSBuild -Name "$OSMediaName" -Download -Execute -HideCleanupProgress -SkipTask -EnableNetFX
            }
        }
    }

    end {}
}
