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
        [string]$EditionId,

        #The Operating System Index to Import
        #Import-OSMedia -ImageIndex 3
        #Import-OSMedia -ImageIndex 3 -SkipGrid
        #Alias: Index
        [Alias('Index')]
        [int]$ImageIndex,
        
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
        [string]$ImageName,
        
        #Used to bypass the ISE GridView Operating System Selection
        #Must use EditionId or ImageName Parameter for best results
        #Alias: SkipGridView
        [Alias('SkipGridView')]
        [switch]$SkipGrid,

        #Creates an OSMedia with all Microsoft Updates applied
        #Import-OSMedia -Edition Enterprise -SkipGrid -QuickUpdate
        #Execute Command:
        #Update-OSMedia -Name $OSMediaName -Download -Execute -HideCleanupProgress
        #Alias: UpdateOSMedia
        [Alias('UpdateOSMedia')]
        [switch]$Update,
        
        #Creates an OSBuild with NetFX enabled
        #Import-OSMedia -Edition Enterprise -SkipGrid -QuickBuild
        #Execute Command:
        #New-OSBuild -Name $OSMediaName -Download -Execute -HideCleanupProgress -SkipTask -QuickEnableNetFX
        #Alias: Build,BuildNetFX
        [Alias('Build')]
        [switch]$BuildNetFX,

        #Displays Media Information after Import
        #Show-OSDBuilderInfo -FullName $OSMediaPath
        #Alias: OSDInfo
        [Alias('OSDInfo')]
        [switch]$ShowInfo
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
        #===================================================================================================
        #   Import Drives
        #===================================================================================================
        $ImportWims = @()
        $ImportDrives = Get-PSDrive -PSProvider 'FileSystem'
        foreach ($ImportDrive in $ImportDrives) {
            if (Test-Path "$($ImportDrive.Root)Sources") {$ImportWims += Get-ChildItem "$($ImportDrive.Root)Sources\*" -Include install.wim,install.esd | Select-Object -Property @{Name="OSRoot";Expression={(Get-Item $_.Directory).Parent.FullName}}, @{Name="OSWim";Expression={$_.FullName}}}
            if (Test-Path "$($ImportDrive.Root)x64\Sources") {$ImportWims += Get-ChildItem "$($ImportDrive.Root)x64\Sources\*" -Include install.wim,install.esd | Select-Object -Property @{Name="OSRoot";Expression={(Get-Item $_.Directory).Parent.FullName}}, @{Name="OSWim";Expression={$_.FullName}}}
            if (Test-Path "$($ImportDrive.Root)x86\Sources") {$ImportWims += Get-ChildItem "$($ImportDrive.Root)x86\Sources\*" -Include install.wim,install.esd | Select-Object -Property @{Name="OSRoot";Expression={(Get-Item $_.Directory).Parent.FullName}}, @{Name="OSWim";Expression={$_.FullName}}}
        }
        #===================================================================================================
        #   Import Media Directory
        #===================================================================================================
        $ImportMedia = Get-ChildItem $global:GetOSDBuilder.PathMedia -ErrorAction SilentlyContinue
        foreach ($ImportDrive in $ImportMedia) {
            if (Test-Path "$($ImportDrive.FullName)\Sources") {$ImportWims += Get-ChildItem "$($ImportDrive.FullName)\Sources\*" -Include install.wim,install.esd | Select-Object -Property @{Name="OSRoot";Expression={(Get-Item $_.Directory).Parent.FullName}}, @{Name="OSWim";Expression={$_.FullName}}}
        }
        #===================================================================================================
        #   Import WIMS
        #===================================================================================================
        if ($null -eq $ImportWims) {
            Write-Host '========================================================================================' -ForegroundColor DarkGray
            Write-Warning "Windows Image could not be found on any CD or DVD Drives . . . Exiting!"
            Break
        }
        #===================================================================================================
        #   Scan Windows Images'
        #===================================================================================================
        $WindowsImages = $ImportWims | ForEach-Object {
            Write-Host '========================================================================================' -ForegroundColor DarkGray
            Show-ActionTime; Write-Host "Media: Scan $($_.OSWim)" -ForegroundColor Green
            Get-WindowsImage -ImagePath "$($_.OSWim)"} | ForEach-Object {
                Get-WindowsImage -ImagePath "$($_.ImagePath)" -Index $($_.ImageIndex) | Select-Object -Property *
                Write-Host "ImageIndex $($_.ImageIndex): $($_.ImageName)" -ForegroundColor DarkGray
            }

        $WindowsImages = $WindowsImages | Select-Object -Property ImagePath, ImageIndex, ImageName, Architecture, EditionId, Languages, InstallationType, Version, MajorVersion, MinorVersion, Build, SPBuild, SPLevel, CreatedTime, ModifiedTime
        foreach ($Image in $WindowsImages) {
            if ($Image.Architecture -eq '0') {$Image.Architecture = 'x86'}
            if ($Image.Architecture -eq '6') {$Image.Architecture = 'ia64'}
            if ($Image.Architecture -eq '9') {$Image.Architecture = 'x64'}
            if ($Image.Architecture -eq '12') {$Image.Architecture = 'x64 ARM'}
        }
        #===================================================================================================
        Write-Verbose '19.1.1 Filter OS Version 6.1.7601 and 10'
        #===================================================================================================
        $WindowsImages = $WindowsImages | Where-Object {($_.MajorVersion -eq '10') -or ($_.Version -like "6.1.7601*" -and $_.InstallationType -like "*Client*") -or ($_.Version -like "6.3*" -and $_.ImageName -like "*Server*")}
        #   Windows 7 SP1
        #   Windows 8.1
        #   Windows Server 2012 R2
        #   Windows 10
        #   Windows Server 2016
        #   Windows Server 2019

        #===================================================================================================
        Write-Verbose '19.1.1 Filter Parameters'
        #===================================================================================================
        if ($EditionId) {$WindowsImages = $WindowsImages | Where-Object {$_.EditionId -eq $EditionId}}
        if ($ImageName) {$WindowsImages = $WindowsImages | Where-Object {$_.ImageName -eq $ImageName}}
        if ($ImageIndex) {$WindowsImages = $WindowsImages | Where-Object {$_.ImageIndex -eq $ImageIndex}}
        #===================================================================================================
        Write-Verbose '19.1.1 Select Operating Systems'
        #===================================================================================================
        if (@($WindowsImages).Count -gt 0) {
            if (!($SkipGrid.IsPresent)) {
                $WindowsImages = $WindowsImages | Out-GridView -Title "Import-OSMedia: Select OSMedia to Import and press OK (Cancel to Exit)" -PassThru        
                if($null -eq $WindowsImages) {
                    Write-Host '========================================================================================' -ForegroundColor DarkGray
                    Write-Warning "Import-OSMedia: Compatible OSMedia was not selected . . . Exiting!"
                    Return
                }
            }
        } else {
            Write-Host '========================================================================================' -ForegroundColor DarkGray
            Write-Warning "OSMedia was not found . . . Exiting!"
            Return
        }
    }

    PROCESS {
        Write-Host '========================================================================================' -ForegroundColor DarkGray
        Write-Host -ForegroundColor Green "$($MyInvocation.MyCommand.Name) PROCESS"
        Write-Verbose "MyInvocation.MyCommand.Name: $($MyInvocation.MyCommand.Name)"
        Write-Verbose "PSCmdlet.ParameterSetName: $($PSCmdlet.ParameterSetName)"
        #===================================================================================================
        Write-Verbose '19.1.1 Import Windows Images'
        #===================================================================================================
        foreach ($WindowsImage in $WindowsImages) {

            $OSImagePath = $($WindowsImage.ImagePath)
            $OSImageIndex = $($WindowsImage.ImageIndex)
            $OSSourcePath = (Get-Item $OSImagePath).Directory.Parent.FullName
            $WindowsImage = Get-WindowsImage -ImagePath "$OSImagePath" -Index $OSImageIndex | Select-Object -Property *

            $OSImageName = $($WindowsImage.ImageName)
            $OSImageName = $OSImageName -replace '\(', ''
            $OSImageName = $OSImageName -replace '\)', ''

            $OSImageDescription = $($WindowsImage.ImageDescription)

            $OSArchitecture = $($WindowsImage.Architecture)
            if ($OSArchitecture -eq '0') {$OSArchitecture = 'x86'}
            if ($OSArchitecture -eq '6') {$OSArchitecture = 'ia64'}
            if ($OSArchitecture -eq '9') {$OSArchitecture = 'x64'}
            if ($OSArchitecture -eq '12') {$OSArchitecture = 'x64 ARM'}

            $OSEditionID =        $($WindowsImage.EditionId)
            $OSInstallationType = $($WindowsImage.InstallationType)
            $OSLanguages =        $($WindowsImage.Languages)
            $OSMajorVersion =     $($WindowsImage.MajorVersion)
            $OSBuild =            $($WindowsImage.Build)
            $OSVersion =          $($WindowsImage.Version)
            $OSSPBuild =          $($WindowsImage.SPBuild)
            $OSSPLevel =            $($WindowsImage.SPLevel)
            $OSImageBootable =      $($WindowsImage.ImageBootable)
            $OSWIMBoot =            $($WindowsImage.WIMBoot)
            $OSCreatedTime =        $($WindowsImage.CreatedTime)
            $OSModifiedTime =       $($WindowsImage.ModifiedTime)

            $OSMGuid = $(New-Guid)

            #===================================================================================================
            #   ESD: Export-WindowsImage
            #===================================================================================================
            if ($OSImagePath -like "*.esd") {
                $InstallWimType = "esd"
                $TempESD = "$env:Temp\$((Get-Date).ToString('HHmmss')).wim"

                Write-Host '========================================================================================' -ForegroundColor DarkGray
                Write-Host "Image: Export Install.esd Index $OSImageIndex to $TempESD" -ForegroundColor Green
                
                $CurrentLog = "$env:Temp\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Export-WindowsImage.log"
                Write-Verbose "CurrentLog: $CurrentLog"
                Export-WindowsImage -SourceImagePath "$OSImagePath" -SourceIndex $OSImageIndex -DestinationImagePath "$TempESD" -CheckIntegrity -CompressionType max -LogPath "$CurrentLog" | Out-Null
            } else {
                $InstallWimType = "wim"
            }

            $MountDirectory = Join-Path $OSDBuilderContent\Mount "os$((Get-Date).ToString('HHmmss'))"
            Mount-InstallwimMEDIA
            #===================================================================================================
            #   REGISTRY
            #===================================================================================================
            Show-ActionTime; Write-Host "Image: Mount Registry for UBR Information" -ForegroundColor Green

                reg LOAD 'HKLM\OSMedia' "$MountDirectory\Windows\System32\Config\SOFTWARE" | Out-Null
                $RegKeyCurrentVersion = Get-ItemProperty -Path 'HKLM:\OSMedia\Microsoft\Windows NT\CurrentVersion'
                reg UNLOAD 'HKLM\OSMedia' | Out-Null
            #===================================================================================================
            #===================================================================================================
            Write-Verbose 'Set OS Main Information'
            if ($OSMajorVersion -eq '10') {
                #19.10.17 resolve issues with Windows 10 1909
                $RegValueCurrentBuild = $null
                $RegValueCurrentBuild = $($RegKeyCurrentVersion.CurrentBuild)

                $ReleaseId = $null
                $ReleaseId = $($RegKeyCurrentVersion.ReleaseId)
                if ($ReleaseId -gt 1909) {Write-Warning "OSDBuilder does not currently support this version of Windows ... Check for an updated version"}
                if ($null -eq $ReleaseId) {
                    #if ($OSBuild -eq 7600) {$ReleaseId = 7600}
                    #if ($OSBuild -eq 7601) {$ReleaseId = 7601}
                    #if ($OSBuild -eq 9600) {$ReleaseId = 9600}
                    if ($OSBuild -eq 10240) {$ReleaseId = 1507}
                    if ($OSBuild -eq 14393) {$ReleaseId = 1607}
                    if ($OSBuild -eq 15063) {$ReleaseId = 1703}
                    if ($OSBuild -eq 16299) {$ReleaseId = 1709}
                    #if ($OSBuild -eq 17134) {$ReleaseId = 1803}
                    #if ($OSBuild -eq 17763) {$ReleaseId = 1809}
                    #if ($OSBuild -eq 18362) {$ReleaseId = 1903}
                }

                $RegValueUbr = $null
                $RegValueUbr = $($RegKeyCurrentVersion.UBR)
                $UBR = "$RegValueCurrentBuild.$RegValueUbr"
                $OSMediaName = "$OSImageName $OSArchitecture $ReleaseId $UBR $OSLanguages"
            } else {
                $UBR = "$OSBuild.$OSSPBuild"
                $OSMediaName = "$OSImageName $OSArchitecture $UBR $OSLanguages"
            }
            #===================================================================================================
            #===================================================================================================
            Write-Verbose 'Trim en-US Language'
            if ($($OSLanguages.count) -eq 1) {$OSMediaName = $OSMediaName.replace(' en-US','')}
            #===================================================================================================
            #===================================================================================================
            Write-Verbose 'Set OSMediaPath'
            $OSMediaPath = Join-Path $OSDBuilderOSImport $OSMediaName
            #===================================================================================================
            #===================================================================================================
            Write-Verbose 'Remove Existing OSMedia'
            if (Test-Path $OSMediaPath) {
                Write-Warning "$OSMediaPath exists.  Contents will be replaced!"
                Remove-Item -Path "$OSMediaPath" -Force -Recurse
                Write-Host ""
            }
            #===================================================================================================
            #===================================================================================================
            Write-Verbose 'Set Working Directories'
            $Info = Join-Path $OSMediaPath 'info'
            if (!(Test-Path "$Info"))           {New-Item "$Info" -ItemType Directory -Force | Out-Null}
            if (!(Test-Path "$Info\json"))      {New-Item "$Info\json" -ItemType Directory -Force | Out-Null}
            if (!(Test-Path "$Info\logs"))      {New-Item "$Info\logs" -ItemType Directory -Force | Out-Null}
            if (!(Test-Path "$Info\xml"))       {New-Item "$Info\xml" -ItemType Directory -Force | Out-Null}
            
            $OS = Join-Path $OSMediaPath 'OS'
            if (!(Test-Path "$OS"))             {New-Item "$OS" -ItemType Directory -Force | Out-Null}

            $WinPE = Join-Path $OSMediaPath 'WinPE'
            if (!(Test-Path "$WinPE"))          {New-Item "$WinPE" -ItemType Directory -Force | Out-Null}

            $PEInfo = Join-Path $WinPE 'info'
            if (!(Test-Path "$PEInfo"))         {New-Item "$PEInfo" -ItemType Directory -Force | Out-Null}
            if (!(Test-Path "$PEInfo\json"))    {New-Item "$PEInfo\json" -ItemType Directory -Force | Out-Null}
            if (!(Test-Path "$PEInfo\logs"))    {New-Item "$PEInfo\logs" -ItemType Directory -Force | Out-Null}
            if (!(Test-Path "$PEInfo\xml"))     {New-Item "$PEInfo\xml" -ItemType Directory -Force | Out-Null}

            #===================================================================================================
            Write-Verbose 'Export RegistryCurrentVersionKey'
            #===================================================================================================
            $RegKeyCurrentVersion | Out-File "$Info\CurrentVersion.txt"
            $RegKeyCurrentVersion | Out-File "$OSMediaPath\CurrentVersion.txt"
            $RegKeyCurrentVersion | Out-File "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-CurrentVersion.txt"
            $RegKeyCurrentVersion | Export-Clixml -Path "$Info\xml\CurrentVersion.xml"
            $RegKeyCurrentVersion | Export-Clixml -Path "$Info\xml\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-CurrentVersion.xml"
            $RegKeyCurrentVersion | ConvertTo-Json | Out-File "$Info\json\CurrentVersion.json"
            $RegKeyCurrentVersion | ConvertTo-Json | Out-File "$Info\json\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-CurrentVersion.json"
            #===================================================================================================
            #   Start-Transcript
            #===================================================================================================
            Write-Host '========================================================================================' -ForegroundColor DarkGray
            $ScriptName = $MyInvocation.MyCommand.Name
            $LogName = "$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-$ScriptName.log"
            Start-Transcript -Path (Join-Path "$Info\logs" $LogName)
            #===================================================================================================
            #   Image Information
            #===================================================================================================
            Show-WindowsImageInfo
            Show-MediaInfoOS
            #===================================================================================================
            #   Media: Copy Operating System
            #===================================================================================================
            Write-Host '========================================================================================' -ForegroundColor DarkGray
            Show-ActionTime; Write-Host "Media: Copy Operating System to $OS" -ForegroundColor Green

            Copy-Item -Path "$OSSourcePath\*" -Destination "$OS" -Exclude "install.$InstallWimType" -Recurse -Force | Out-Null
            Get-ChildItem -Recurse -Path "$OS\*" | Set-ItemProperty -Name IsReadOnly -Value $false -ErrorAction SilentlyContinue | Out-Null

            if ($InstallWimType -eq "esd") {            
                $CurrentLog = "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Export-WindowsImage.log"
                Write-Verbose "CurrentLog: $CurrentLog"
                Export-WindowsImage -SourceImagePath "$TempESD" -SourceIndex 1 -DestinationImagePath "$OS\sources\install.wim" -LogPath "$CurrentLog" | Out-Null
            } else {            
                $CurrentLog = "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Export-WindowsImage.log"
                Write-Verbose "CurrentLog: $CurrentLog"
                Export-WindowsImage -SourceImagePath "$OSImagePath" -SourceIndex $OSImageIndex -DestinationImagePath "$OS\sources\install.wim" -LogPath "$CurrentLog" | Out-Null
            }
            #===================================================================================================
            #   Export-Inventory
            #===================================================================================================
            Write-Verbose 'Install.wim: Export Inventory'
            Backup-AutoExtraFilesOS -OSMediaPath "$OSMediaPath"
            Save-SessionsXmlOS -OSMediaPath "$OSMediaPath"
            Save-InventoryOS -OSMediaPath "$OSMediaPath"
            Save-WimsPE -OSMediaPath "$OSMediaPath"
            Save-InventoryPE -OSMediaPath "$OSMediaPath"
            #===================================================================================================
            #   Dismount-WindowsImage
            #===================================================================================================
            Show-ActionTime; Write-Host "Install.wim: Dismount from $MountDirectory" -ForegroundColor Green
            if ($OSImagePath -like "*.esd") {
                try {Remove-Item "$TempESD" -Force | Out-Null}
                catch {Write-Warning "Could not remove $TempESD"}
            }

            $CurrentLog = "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Dismount-WindowsImage.log"
            Write-Verbose "CurrentLog: $CurrentLog"
            Dismount-WindowsImage -Discard -Path "$MountDirectory" -LogPath "$CurrentLog" | Out-Null
            #===================================================================================================
            #   Export-Configuration
            #===================================================================================================
            Show-ActionTime; Write-Host "Install.wim: Export Configuration to $OSMediaPath\WindowsImage.txt" -ForegroundColor Green
            $GetWindowsImage = @()
            $GetWindowsImage = Get-WindowsImage -ImagePath "$OS\sources\install.wim" -Index 1 | Select-Object -Property *

            Write-Verbose "========== SPBuild: $($GetWindowsImage.Build).$($GetWindowsImage.SPBuild)"
            if ($OSVersion -like "6.1*") {
                Write-Verbose '========== Windows 6.1'
                $UBR = "$($GetWindowsImage.Build).$($GetWindowsImage.SPBuild)"
            }
            Write-Verbose "========== UBR: $UBR"

            #19.10.17 to address issues with Windows 10 1909
            $GetWindowsImage | Add-Member -Type NoteProperty -Name "CurrentBuild" -Value $RegValueCurrentBuild
            $GetWindowsImage | Add-Member -Type NoteProperty -Name "UBR" -Value $UBR
            $GetWindowsImage | Add-Member -Type NoteProperty -Name "OSMGuid" -Value $OSMGuid
            
            $GetWindowsImage | Out-File "$OSMediaPath\WindowsImage.txt"
            $GetWindowsImage | Out-File "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsImage.txt"
            $GetWindowsImage | Export-Clixml -Path "$Info\xml\Get-WindowsImage.xml"
            $GetWindowsImage | Export-Clixml -Path "$Info\xml\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsImage.xml"
            $GetWindowsImage | ConvertTo-Json | Out-File "$Info\json\Get-WindowsImage.json"
            $GetWindowsImage | ConvertTo-Json | Out-File "$Info\json\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsImage.json"
            (Get-Content "$OSMediaPath\WindowsImage.txt") | Where-Object {$_.Trim(" `t")} | Set-Content "$OSMediaPath\WindowsImage.txt"
            #===================================================================================================
            #    OSD-Export
            #===================================================================================================
            Save-WindowsImageContentOS
            Save-VariablesOSD
            if ($ShowInfo.IsPresent) {Show-OSDBuilderInfo -FullName $OSMediaPath}
            #===================================================================================================
            #   Stop-Transcript
            #===================================================================================================
            Write-Host '========================================================================================' -ForegroundColor DarkGray
            Stop-Transcript
            #===================================================================================================
            #   Update-OSMedia
            #===================================================================================================
            if ($Update.IsPresent) {
                if ($OSMajorVersion -eq '10') {
                    Update-OSMedia -Name "$OSMediaName" -Download -Execute -HideCleanupProgress
                } else  {
                    Write-Verbose "Import-OSMedia: Update-OSMedia requires a Operating System Major Version of 10"
                }
            }
            #===================================================================================================
            #   New-QuickOSBuild
            #===================================================================================================
            if ($BuildNetFX.IsPresent) {
                if ($OSMajorVersion -eq '10') {
                    New-OSBuild -Name "$OSMediaName" -Download -Execute -HideCleanupProgress -SkipTask -EnableNetFX
                } else  {
                    Write-Verbose "Import-OSMedia: New-OSBuild requires a Operating System Major Version of 10"
                }
            }
        }
    }

    END {}
}
