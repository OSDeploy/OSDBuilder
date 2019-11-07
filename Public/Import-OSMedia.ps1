<#
.SYNOPSIS
Imports an Operating System into OSDBuilder

.DESCRIPTION
Imports a supported Operating System into the OSDBuilder OSMedia directory

.LINK
https://osdbuilder.osdeploy.com/module/functions/import-osmedia
#>
function Import-OSMedia {
    [CmdletBinding()]
    Param (
        #Unsupported
        #Allows the import of an unsupported OS
        #THIS PARAMETER IS NOT A GUARANTEE OF ANY FUNCTIONALITY
        #THIS PARAMETER IS A GUARANTEE OF BEING GHOSTED IF YOU CONTACT THE DEV FOR SUPPORT
        [switch]$AllowUnsupportedOS = $global:SetOSDBuilder.ImportOSMediaAllowUnsupportedOS,
        
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
        [string]$EditionId = $global:SetOSDBuilder.ImportOSMediaEditionId,

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
            'Windows Server Standard',`
            'Windows Server Datacenter',
            'Windows Server 2016 Standard',`
            'Windows Server 2016 Standard (Desktop Experience)',`
            'Windows Server 2016 Datacenter',`
            'Windows Server 2016 Datacenter (Desktop Experience)',`
            'Windows Server 2019 Standard',`
            'Windows Server 2019 Standard (Desktop Experience)',`
            'Windows Server 2019 Datacenter',`
            'Windows Server 2019 Datacenter (Desktop Experience)'
        )]
        [string]$ImageName = $global:SetOSDBuilder.ImportOSMediaImageName,
        
        #Used to bypass the ISE GridView Operating System Selection
        #Must use EditionId or ImageName Parameter for best results
        #Alias: SkipGridView
        [Alias('SkipGridView')]
        [switch]$SkipGrid = $global:SetOSDBuilder.ImportOSMediaSkipGrid,

        #Skips the searh of the FeatureUpdates path for downloaded Feature Updates
        [switch]$SkipFeatureUpdates = $global:SetOSDBuilder.ImportOSMediaSkipFeatureUpdates,

        #Creates an OSMedia with all Microsoft Updates applied
        #Import-OSMedia -Edition Enterprise -SkipGrid -QuickUpdate
        #Execute Command:
        #Update-OSMedia -Name $OSMediaName -Download -Execute -HideCleanupProgress
        #Alias: UpdateOSMedia
        [Alias('UpdateOSMedia')]
        [switch]$Update = $global:SetOSDBuilder.ImportOSMediaUpdate,
        
        #Creates an OSBuild with NetFX enabled
        #Import-OSMedia -Edition Enterprise -SkipGrid -QuickBuild
        #Execute Command:
        #New-OSBuild -Name $OSMediaName -Download -Execute -HideCleanupProgress -SkipTask -QuickEnableNetFX
        #Alias: Build,BuildNetFX
        [Alias('Build')]
        [switch]$BuildNetFX = $global:SetOSDBuilder.ImportOSMediaBuildNetFX,

        #Displays Media Information after Import
        #Show-OSDBuilderInfo -FullName $OSMediaPath
        #Alias: OSDInfo
        [Alias('OSDInfo')]
        [switch]$ShowInfo = $global:SetOSDBuilder.ImportOSMediaShowInfo
    )
    #===================================================================================================
    #   Variables
    #===================================================================================================
    #ImportOSMediaPSDrives
    #ImportOSMediaOperatingSystems
    #ImportOSMediaFeatureUpdates
    #ImportOSMediaPSDrives
    #ImportOSMediaPSDrives
    
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
        #===================================================================================================
        #   GetPSDrives
        #===================================================================================================
        $global:ImportOSMediaPSDrives = @()
        $global:ImportOSMediaPSDrives = Get-PSDrive -PSProvider 'FileSystem'
        #===================================================================================================
        #   ImportOSMediaOperatingSystems
        #===================================================================================================
        $global:ImportOSMediaOperatingSystems = @()
        foreach ($ImportOSMediaOperatingSystem in $global:ImportOSMediaPSDrives) {
            if (Test-Path "$($ImportOSMediaOperatingSystem.Root)Sources") {
                $global:ImportOSMediaOperatingSystems += Get-ChildItem "$($ImportOSMediaOperatingSystem.Root)Sources\*" -Include install.wim,install.esd | Select-Object -Property @{Name="OSRoot";Expression={(Get-Item $_.Directory).Parent.FullName}}, @{Name="OSWim";Expression={$_.FullName}}
            }
            if (Test-Path "$($ImportOSMediaOperatingSystem.Root)x64\Sources") {
                $global:ImportOSMediaOperatingSystems += Get-ChildItem "$($ImportOSMediaOperatingSystem.Root)x64\Sources\*" -Include install.wim,install.esd | Select-Object -Property @{Name="OSRoot";Expression={(Get-Item $_.Directory).Parent.FullName}}, @{Name="OSWim";Expression={$_.FullName}}
            }
            if (Test-Path "$($ImportOSMediaOperatingSystem.Root)x86\Sources") {
                $global:ImportOSMediaOperatingSystems += Get-ChildItem "$($ImportOSMediaOperatingSystem.Root)x86\Sources\*" -Include install.wim,install.esd | Select-Object -Property @{Name="OSRoot";Expression={(Get-Item $_.Directory).Parent.FullName}}, @{Name="OSWim";Expression={$_.FullName}}
            }
        }
        #===================================================================================================
        #   ImportOSMediaFeatureUpdates
        #===================================================================================================
        $global:ImportOSMediaFeatureUpdates = @()
        if ($SkipFeatureUpdates -ne $true) {
            $ImportOSMediaFeatureUpdates = Get-ChildItem $SetOSDBuilderPathFeatureUpdates -ErrorAction SilentlyContinue
            foreach ($ImportOSMediaOperatingSystem in $ImportOSMediaFeatureUpdates) {
                if (Test-Path "$($ImportOSMediaOperatingSystem.FullName)\Sources") {
                    $global:ImportOSMediaOperatingSystems += Get-ChildItem "$($ImportOSMediaOperatingSystem.FullName)\Sources\*" -Include install.wim,install.esd | Select-Object -Property @{Name="OSRoot";Expression={(Get-Item $_.Directory).Parent.FullName}}, @{Name="OSWim";Expression={$_.FullName}}
                }
            }
        }
        #===================================================================================================
        #   Validate ImportOSMediaOperatingSystems
        #===================================================================================================
        if ($null -eq $global:ImportOSMediaOperatingSystems) {
            Write-Host '========================================================================================' -ForegroundColor DarkGray
            Write-Warning "Windows Image could not be found on any CD or DVD Drives . . . Exiting!"
            Break
        }
        #===================================================================================================
        #   ImportOSMediaWindowsImages
        #===================================================================================================
        $global:ImportOSMediaWindowsImages = $global:ImportOSMediaOperatingSystems | ForEach-Object {
            Write-Host '========================================================================================' -ForegroundColor DarkGray
            Show-ActionTime; Write-Host "Media: Scan $($_.OSWim)" -ForegroundColor Green
            Get-WindowsImage -ImagePath "$($_.OSWim)"} | ForEach-Object {
                Get-WindowsImage -ImagePath "$($_.ImagePath)" -Index $($_.ImageIndex) | Select-Object -Property *
                Write-Host "ImageIndex $($_.ImageIndex): $($_.ImageName)" -ForegroundColor DarkGray
            }

        $global:ImportOSMediaWindowsImages = $global:ImportOSMediaWindowsImages | Select-Object -Property ImagePath, ImageIndex, ImageName, Architecture, EditionId, Languages, InstallationType, Version, MajorVersion, MinorVersion, Build, SPBuild, SPLevel, CreatedTime, ModifiedTime
        foreach ($Image in $global:ImportOSMediaWindowsImages) {
            if ($Image.Architecture -eq '0') {$Image.Architecture = 'x86'}
            if ($Image.Architecture -eq '6') {$Image.Architecture = 'ia64'}
            if ($Image.Architecture -eq '9') {$Image.Architecture = 'x64'}
            if ($Image.Architecture -eq '12') {$Image.Architecture = 'x64 ARM'}
        }
        #===================================================================================================
        #   AllowUnsupportedOS
        #===================================================================================================
        if ($AllowUnsupportedOS -eq $true) {
            Write-Warning "AllowUnsupportedOS: This parameter will allow you to import any OS into OSDBuilder"
            Write-Warning "AllowUnsupportedOS: This in no way guarantees any functionality"
            Write-Warning "AllowUnsupportedOS: Contacting the DEV for support on an unsupported OS will have consequences"
        } else {
            Write-Verbose "Filtering Windows (version 10 Client and Server), Windows 7 (version 6.1.7601 Client) and Server 2012 R2 (version 6.3 Server)"
            $global:ImportOSMediaWindowsImages = $global:ImportOSMediaWindowsImages | Where-Object {($_.MajorVersion -eq '10') -or ($_.Version -like "6.1.7601*" -and $_.InstallationType -like "*Client*") -or ($_.Version -like "6.3*" -and $_.ImageName -like "*Server*")}
            #   Windows 7 SP1
            #   Windows 8.1
            #   Windows Server 2012 R2
            #   Windows 10
            #   Windows Server 2016
            #   Windows Server 2019
        }
        #===================================================================================================
        #   ImportOSMediaWindowsImages Filter
        #===================================================================================================
        if ($EditionId) {$global:ImportOSMediaWindowsImages = $global:ImportOSMediaWindowsImages | Where-Object {$_.EditionId -eq $EditionId}}
        if ($ImageName) {$global:ImportOSMediaWindowsImages = $global:ImportOSMediaWindowsImages | Where-Object {$_.ImageName -eq $ImageName}}
        if ($ImageIndex) {$global:ImportOSMediaWindowsImages = $global:ImportOSMediaWindowsImages | Where-Object {$_.ImageIndex -eq $ImageIndex}}
        #===================================================================================================
        #   ImportOSMediaWindowsImages GridView
        #===================================================================================================
        if (@($global:ImportOSMediaWindowsImages).Count -gt 0) {
            if (!($SkipGrid.IsPresent)) {
                $global:ImportOSMediaWindowsImages = $global:ImportOSMediaWindowsImages | Out-GridView -Title "Import-OSMedia: Select OSMedia to Import and press OK (Cancel to Exit)" -PassThru        
                if($null -eq $global:ImportOSMediaWindowsImages) {
                    Write-Host '========================================================================================' -ForegroundColor DarkGray
                    Write-Warning "Import-OSMedia: Compatible OSMedia was not selected . . . Exiting!"
                    Break
                }
            }
        } else {
            Write-Host '========================================================================================' -ForegroundColor DarkGray
            Write-Warning "Import-OSMedia: OSMedia was not found . . . Exiting!"
            Break
        }
    }

    Process {
        Write-Host '========================================================================================' -ForegroundColor DarkGray
        Write-Host -ForegroundColor Green "$($MyInvocation.MyCommand.Name) PROCESS"
        Write-Verbose "MyInvocation.MyCommand.Name: $($MyInvocation.MyCommand.Name)"
        Write-Verbose "PSCmdlet.ParameterSetName: $($PSCmdlet.ParameterSetName)"
        #===================================================================================================
        Write-Verbose '19.1.1 Import Windows Images'
        #===================================================================================================
        #foreach ($WindowsImage in $global:ImportOSMediaWindowsImages) {
        foreach ($ImportOSMediaWindowsImage in $global:ImportOSMediaWindowsImages) {
            #===================================================================================================
            #   New PROCESS
            #===================================================================================================
            $global:OSMediaGetItem = Get-Item $ImportOSMediaWindowsImage.ImagePath

            $global:SourceImagePath = $OSMediaGetItem.FullName
            $global:SourceImageIndex = $ImportOSMediaWindowsImage.ImageIndex
            $global:SourceOSMedia =  ($OSMediaGetItem).Directory.Parent.FullName

            $global:GetWindowsImage = Get-WindowsImage -ImagePath $SourceImagePath -Index $SourceImageIndex | Select-Object -Property *
            $GetWindowsImage.ImageName = $GetWindowsImage.ImageName -replace '\(', ''
            $GetWindowsImage.ImageName = $GetWindowsImage.ImageName -replace '\)', ''
            if ($GetWindowsImage.Architecture -eq '0')  {$GetWindowsImage.Architecture = 'x86'}
            if ($GetWindowsImage.Architecture -eq '6')  {$GetWindowsImage.Architecture = 'ia64'}
            if ($GetWindowsImage.Architecture -eq '9')  {$GetWindowsImage.Architecture = 'x64'}
            if ($GetWindowsImage.Architecture -eq '12') {$GetWindowsImage.Architecture = 'x64 ARM'}
            #===================================================================================================
            #   ESD: Export-WindowsImage
            #===================================================================================================
            if ($OSMediaGetItem.Extension -eq '.esd') {
                $SourceTempWim = "$env:Temp\$((Get-Date).ToString('HHmmss')).wim"

                Write-Host '========================================================================================' -ForegroundColor DarkGray
                Write-Host "Image: Export Install.esd Index $SourceImageIndex to $SourceTempWim" -ForegroundColor Green
                
                $CurrentLog = "$env:Temp\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Export-WindowsImage.log"
                Write-Verbose "CurrentLog: $CurrentLog"
                Export-WindowsImage -SourceImagePath $SourceImagePath -SourceIndex $SourceImageIndex -DestinationImagePath $SourceTempWim -CheckIntegrity -CompressionType max -LogPath "$CurrentLog" | Out-Null
            }

            $global:MountDirectory = Join-Path $SetOSDBuilderPathMount "os$((Get-Date).ToString('HHmmss'))"
            Mount-ImportOSMediaWim
            #===================================================================================================
            #   Get-RegKeyCurrentVersion
            #===================================================================================================
            $GetRegKeyCurrentVersion = Get-RegKeyCurrentVersion -MountPath $MountDirectory
            #===================================================================================================
            #   Set Additional Properties
            #===================================================================================================
            $RegValueUbr = $null
            $RegValueReleaseId = $null
            $RegValueCurrentBuild = $null
            $OSMGuid = $(New-Guid)

            if ($GetWindowsImage.MajorVersion -eq '10') {
                $RegValueUbr = $($GetRegKeyCurrentVersion.UBR)
                $RegValueReleaseId = $($GetRegKeyCurrentVersion.ReleaseId)
                $RegValueCurrentBuild = $($GetRegKeyCurrentVersion.CurrentBuild)

                if ($RegValueReleaseId -gt 1909) {Write-Warning "OSDBuilder does not currently support this version of Windows ... Check for an updated version"}
                if ($null -eq $RegValueReleaseId) {
                    #if ($GetWindowsImage.Build -eq 7600) {$RegValueReleaseId = 7600}
                    #if ($GetWindowsImage.Build -eq 7601) {$RegValueReleaseId = 7601}
                    #if ($GetWindowsImage.Build -eq 9600) {$RegValueReleaseId = 9600}
                    if ($GetWindowsImage.Build -eq 10240) {$RegValueReleaseId = 1507}
                    if ($GetWindowsImage.Build -eq 14393) {$RegValueReleaseId = 1607}
                    if ($GetWindowsImage.Build -eq 15063) {$RegValueReleaseId = 1703}
                    if ($GetWindowsImage.Build -eq 16299) {$RegValueReleaseId = 1709}
                    #if ($GetWindowsImage.Build -eq 17134) {$RegValueReleaseId = 1803}
                    #if ($GetWindowsImage.Build -eq 17763) {$RegValueReleaseId = 1809}
                    #if ($GetWindowsImage.Build -eq 18362) {$RegValueReleaseId = 1903}
                }
                $global:UBR = "$RegValueCurrentBuild.$RegValueUbr"
                $global:OSMediaName = "$($GetWindowsImage.ImageName) $($GetWindowsImage.Architecture) $RegValueReleaseId $UBR $($GetWindowsImage.Languages)"
            } else {
                $UBR = "$($GetWindowsImage.Build).$($GetWindowsImage.SPBuild)"
                $global:OSMediaName = "$($GetWindowsImage.ImageName) $($GetWindowsImage.Architecture) $UBR $($GetWindowsImage.Languages)"
            }

            $GetWindowsImage | Add-Member -Type NoteProperty -Name "CurrentBuild" -Value $RegValueCurrentBuild
            $GetWindowsImage | Add-Member -Type NoteProperty -Name "ReleaseId" -Value $RegValueReleaseId
            $GetWindowsImage | Add-Member -Type NoteProperty -Name "UBR" -Value $UBR
            $GetWindowsImage | Add-Member -Type NoteProperty -Name "OSMGuid" -Value $OSMGuid
            #===================================================================================================
            #   Edit OSMediaName
            #===================================================================================================
            if (($GetWindowsImage.Languages).count -eq 1) {$global:OSMediaName = $global:OSMediaName.replace(' en-US','')}
            #===================================================================================================
            #   Set OSMediaPath
            #===================================================================================================
            $global:OSMediaPath = Join-Path $SetOSDBuilderPathOSImport $global:OSMediaName
            #===================================================================================================
            #   Remove Existing OSMedia
            #===================================================================================================
            if (Test-Path $OSMediaPath) {
                Write-Warning "$OSMediaPath exists.  Contents will be replaced!"
                Remove-Item -Path "$OSMediaPath" -Force -Recurse
            }
            #===================================================================================================
            #   Set Working Directories
            #===================================================================================================
            $global:OSMediaPathInfo = Join-Path $OSMediaPath 'info'
            if (!(Test-Path "$OSMediaPathInfo"))           {New-Item "$OSMediaPathInfo" -ItemType Directory -Force | Out-Null}
            if (!(Test-Path "$OSMediaPathInfo\json"))      {New-Item "$OSMediaPathInfo\json" -ItemType Directory -Force | Out-Null}
            if (!(Test-Path "$OSMediaPathInfo\logs"))      {New-Item "$OSMediaPathInfo\logs" -ItemType Directory -Force | Out-Null}
            if (!(Test-Path "$OSMediaPathInfo\xml"))       {New-Item "$OSMediaPathInfo\xml" -ItemType Directory -Force | Out-Null}
            
            $global:OSMediaPathOS = Join-Path $OSMediaPath 'OS'
            if (!(Test-Path "$OSMediaPathOS"))             {New-Item "$OSMediaPathOS" -ItemType Directory -Force | Out-Null}
            $global:OSMediaPathWindowsImage = $OSMediaPathOS + "\Sources\install.wim"

            $global:OSMediaPathWinPE = Join-Path $OSMediaPath 'WinPE'
            if (!(Test-Path "$OSMediaPathWinPE"))          {New-Item "$OSMediaPathWinPE" -ItemType Directory -Force | Out-Null}

            $global:OSMediaPathPEInfo = Join-Path $OSMediaPathWinPE 'info'
            if (!(Test-Path "$OSMediaPathPEInfo"))         {New-Item "$OSMediaPathPEInfo" -ItemType Directory -Force | Out-Null}
            if (!(Test-Path "$OSMediaPathPEInfo\json"))    {New-Item "$OSMediaPathPEInfo\json" -ItemType Directory -Force | Out-Null}
            if (!(Test-Path "$OSMediaPathPEInfo\logs"))    {New-Item "$OSMediaPathPEInfo\logs" -ItemType Directory -Force | Out-Null}
            if (!(Test-Path "$OSMediaPathPEInfo\xml"))     {New-Item "$OSMediaPathPEInfo\xml" -ItemType Directory -Force | Out-Null}
            #===================================================================================================
            #   Export RegistryCurrentVersionKey
            #===================================================================================================
            $GetRegKeyCurrentVersion | Out-File "$OSMediaPathInfo\CurrentVersion.txt"
            $GetRegKeyCurrentVersion | Out-File "$OSMediaPath\CurrentVersion.txt"
            $GetRegKeyCurrentVersion | Out-File "$OSMediaPathInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-CurrentVersion.txt"
            $GetRegKeyCurrentVersion | Export-Clixml -Path "$OSMediaPathInfo\xml\CurrentVersion.xml"
            $GetRegKeyCurrentVersion | Export-Clixml -Path "$OSMediaPathInfo\xml\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-CurrentVersion.xml"
            $GetRegKeyCurrentVersion | ConvertTo-Json | Out-File "$OSMediaPathInfo\json\CurrentVersion.json"
            $GetRegKeyCurrentVersion | ConvertTo-Json | Out-File "$OSMediaPathInfo\json\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-CurrentVersion.json"
            #===================================================================================================
            #   Start-Transcript
            #===================================================================================================
            Write-Host '========================================================================================' -ForegroundColor DarkGray
            $ScriptName = $MyInvocation.MyCommand.Name
            $LogName = "$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-$ScriptName.log"
            Start-Transcript -Path (Join-Path "$OSMediaPathInfo\logs" $LogName)
            $GetWindowsImage
            #===================================================================================================
            #   Image Information
            #===================================================================================================
            #Show-GetWindowsImage
            Show-OSMediaInfo
            #===================================================================================================
            #   Media: Copy Operating System
            #===================================================================================================
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
            #===================================================================================================
            #   Export-Inventory
            #===================================================================================================
            Save-AutoExtraFilesOS -OSMediaPath $OSMediaPath
            Save-SessionsXmlOS -OSMediaPath $OSMediaPath
            Save-InventoryOS -OSMediaPath $OSMediaPath
            Save-WimsPE -OSMediaPath $OSMediaPath
            Save-InventoryPE -OSMediaPath $OSMediaPath
            #===================================================================================================
            #   Dismount-WindowsImage
            #===================================================================================================
            Show-ActionTime; Write-Host "Install.wim: Dismount from $MountDirectory" -ForegroundColor Green
            if ($OSMediaGetItem.Extension -eq '.esd') {
                try {Remove-Item $SourceTempWim -Force | Out-Null}
                catch {Write-Warning "Could not remove $SourceTempWim"}
            }

            $CurrentLog = "$OSMediaPathInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Dismount-WindowsImage.log"
            Write-Verbose "CurrentLog: $CurrentLog"
            Dismount-WindowsImage -Discard -Path "$MountDirectory" -LogPath "$CurrentLog" | Out-Null
            #===================================================================================================
            #   Export-Configuration
            #===================================================================================================
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

            #19.10.17 to address issues with Windows 10 1909
            #$GetWindowsImage | Add-Member -Type NoteProperty -Name "CurrentBuild" -Value $RegValueCurrentBuild
            #$GetWindowsImage | Add-Member -Type NoteProperty -Name "UBR" -Value $UBR
            #$GetWindowsImage | Add-Member -Type NoteProperty -Name "OSMGuid" -Value $OSMGuid
            
            $GetWindowsImage | Out-File "$OSMediaPath\WindowsImage.txt"
            $GetWindowsImage | Out-File "$OSMediaPathInfo\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsImage.txt"
            $GetWindowsImage | Export-Clixml -Path "$OSMediaPathInfo\xml\Get-WindowsImage.xml"
            $GetWindowsImage | Export-Clixml -Path "$OSMediaPathInfo\xml\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsImage.xml"
            $GetWindowsImage | ConvertTo-Json | Out-File "$OSMediaPathInfo\json\Get-WindowsImage.json"
            $GetWindowsImage | ConvertTo-Json | Out-File "$OSMediaPathInfo\json\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsImage.json"
            (Get-Content "$OSMediaPath\WindowsImage.txt") | Where-Object {$_.Trim(" `t")} | Set-Content "$OSMediaPath\WindowsImage.txt"
            #===================================================================================================
            #    OSD-Export
            #===================================================================================================
            Save-OSMediaWindowsImageContent
            Save-OSMediaVariables
            if ($ShowInfo.IsPresent) {Show-OSDBuilderInfo -FullName $OSMediaPath}
            Stop-Transcript
            #===================================================================================================
            #   Update-OSMedia
            #===================================================================================================
            if ($Update.IsPresent) {
                if ($GetWindowsImage.MajorVersion -eq '10') {
                    Update-OSMedia -Name "$global:OSMediaName" -Download -Execute -HideCleanupProgress
                } else  {
                    Write-Verbose "Import-OSMedia: Update-OSMedia requires a Operating System Major Version of 10"
                }
            }
            #===================================================================================================
            #   New-OSBuild
            #===================================================================================================
            if ($BuildNetFX.IsPresent) {
                if ($GetWindowsImage.MajorVersion -eq '10') {
                    New-OSBuild -Name "$global:OSMediaName" -Download -Execute -HideCleanupProgress -SkipTask -EnableNetFX
                } else  {
                    Write-Verbose "Import-OSMedia: New-OSBuild requires a Operating System Major Version of 10"
                }
            }
        }
    }

    END {}
}
