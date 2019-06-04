<#
.SYNOPSIS
Imports an Operating System into OSDBuilder

.DESCRIPTION
Imports a supported Operating System into the OSDBuilder OSMedia directory

.LINK
http://osdbuilder.com/docs/functions/osmedia/import-osmedia

.PARAMETER OSDInfo
Executes Show-OSDBuilderInfo -FullName $FullName
Displays Media Information after Import

.PARAMETER UpdateOSMedia
Executes Update-OSMedia -Name $Name -Download -Execute
Automatically updates the Imported Operating System

.PARAMETER EditionId
Operating System Edition to import

.EXAMPLE
Import-OSMedia -EditionId Enterprise

.PARAMETER ImageIndex
Operating System Index to Import

.PARAMETER ImageName
Operating System Image Name to Import

.PARAMETER SkipGridView
Used to bypass the ISE GridView Operating System Selection

.EXAMPLE
Import-OSMedia -EditionId Enterprise -SkipGridView

.EXAMPLE
Import-OSMedia -EditionId Enterprise -SkipGridView -UpdateOSMedia
#>
function Import-OSMedia {
    [CmdletBinding(DefaultParameterSetName='Basic')]
    PARAM (
        [switch]$OSDInfo,
        [switch]$UpdateOSMedia,

        [Parameter(ParameterSetName='Advanced')]
        [ValidateSet('Education','EducationN','Enterprise','EnterpriseN','EnterpriseS','EnterpriseSN','Professional','ProfessionalEducation','ProfessionalEducationN','ProfessionalN','ProfessionalWorkstation','ProfessionalWorkstationN','ServerRdsh','ServerDatacenter','ServerDatacenterACor','ServerRdsh','ServerStandard','ServerStandardACor')]
        [string]$EditionId,
        [Parameter(ParameterSetName='Advanced')]
        [int]$ImageIndex,
        [Parameter(ParameterSetName='Advanced')]
        [ValidateSet('Windows 10 Education','Windows 10 Education N','Windows 10 Enterprise','Windows 10 Enterprise 2016 LTSB','Windows 10 Enterprise for Virtual Desktops','Windows 10 Enterprise LTSC','Windows 10 Enterprise N','Windows 10 Enterprise N LTSC','Windows 10 Pro','Windows 10 Pro Education','Windows 10 Pro Education N','Windows 10 Pro for Workstations','Windows 10 Pro N','Windows 10 Pro N for Workstations','Windows Server 2016 Datacenter','Windows Server 2016 Datacenter (Desktop Experience)','Windows Server 2016 Standard','Windows Server 2016 Standard (Desktop Experience)','Windows Server 2019 Datacenter','Windows Server 2019 Datacenter (Desktop Experience)','Windows Server 2019 Standard','Windows Server 2019 Standard (Desktop Experience)','Windows Server Datacenter','Windows Server Standard')]
        [string]$ImageName,
        [Parameter(ParameterSetName='Advanced')]
        [switch]$SkipGridView
    )

    BEGIN {
        #Write-Host '========================================================================================' -ForegroundColor DarkGray
        #Write-Host "$($MyInvocation.MyCommand.Name) BEGIN" -ForegroundColor Green

        #===================================================================================================
        Write-Verbose '19.1.1 Validate Administrator Rights'
        #===================================================================================================
        if (!([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
            Write-Host '========================================================================================' -ForegroundColor DarkGray
            Write-Warning 'OSDBuilder: This function needs to be run as Administrator'
            Pause
            Exit
        }

        #===================================================================================================
        Write-Verbose '19.1.1 Initialize OSDBuilder'
        #===================================================================================================
        Get-OSDBuilder -CreatePaths -HideDetails

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
        $ImportMedia = Get-ChildItem "$OSDBuilderPath\Media" -ErrorAction SilentlyContinue
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
        Write-Verbose '19.1.1 Media: Scan Windows Images'
        #===================================================================================================
        $WindowsImages = $ImportWims | ForEach-Object {
            Write-Host '========================================================================================' -ForegroundColor DarkGray
            Write-Host "Media: Scan $($_.OSWim)" -ForegroundColor Green
            Get-WindowsImage -ImagePath "$($_.OSWim)"} | ForEach-Object {
                Get-WindowsImage -ImagePath "$($_.ImagePath)" -Index $($_.ImageIndex) | Select-Object -Property *
                Write-Host "Index $($_.ImageIndex): $($_.ImageName)" -ForegroundColor DarkGray
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
            if (!($SkipGridView.IsPresent)) {
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
        Write-Host "$($MyInvocation.MyCommand.Name) PROCESS" -ForegroundColor Green

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

            $OSEditionID =          $($WindowsImage.EditionId)
            $OSInstallationType =   $($WindowsImage.InstallationType)
            $OSLanguages =          $($WindowsImage.Languages)
            $OSMajorVersion =       $($WindowsImage.MajorVersion)
            $OSBuild =              $($WindowsImage.Build)
            $OSVersion =            $($WindowsImage.Version)
            $OSSPBuild =            $($WindowsImage.SPBuild)
            $OSSPLevel =            $($WindowsImage.SPLevel)
            $OSImageBootable =      $($WindowsImage.ImageBootable)
            $OSWIMBoot =            $($WindowsImage.WIMBoot)
            $OSCreatedTime =        $($WindowsImage.CreatedTime)
            $OSModifiedTime =       $($WindowsImage.ModifiedTime)

            $OSMGuid = $(New-Guid)

            #===================================================================================================
            #   19.1.1 Image: Export Install.esd'
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
            Mount-ImportOSMedia

            #===================================================================================================
            #   19.1.1 Image: Get Registry and UBR'
            #===================================================================================================
            #Write-Host '========================================================================================' -ForegroundColor DarkGray
            Write-Host "Image: Mount Registry for UBR Information" -ForegroundColor Green

            reg LOAD 'HKLM\OSMedia' "$MountDirectory\Windows\System32\Config\SOFTWARE" | Out-Null
            $RegCurrentVersion = Get-ItemProperty -Path 'HKLM:\OSMedia\Microsoft\Windows NT\CurrentVersion'
            reg UNLOAD 'HKLM\OSMedia' | Out-Null

            $ReleaseId = $null
            $RegCurrentVersionUBR = $null

            #===================================================================================================
            #   19.1.1 Set OS Main Information'
            #===================================================================================================
            if ($OSMajorVersion -eq '10') {
                $ReleaseId = $($RegCurrentVersion.ReleaseId)
                $RegCurrentVersionUBR = $($RegCurrentVersion.UBR)
                $UBR = "$OSBuild.$RegCurrentVersionUBR"
                if ($ReleaseId -gt 1903) {Write-Warning "OSDBuilder does not currently support this version of Windows ... Check for an updated version"}
                $OSMediaName = "$OSImageName $OSArchitecture $ReleaseId $UBR $OSLanguages"
            } else {
                $UBR = "$OSBuild.$OSSPBuild"
                $OSMediaName = "$OSImageName $OSArchitecture $UBR $OSLanguages"
            }

            if ($($OSLanguages.count) -eq 1) {$OSMediaName = $OSMediaName.replace(' en-US','')}

            #===================================================================================================
            #   19.1.1 Set OSMediaPath'
            #===================================================================================================
            $OSMediaPath = Join-Path $OSDBuilderOSMedia $OSMediaName

            #===================================================================================================
            #   19.1.1 Remove Existing OSMedia'
            #===================================================================================================
            if (Test-Path $OSMediaPath) {
                Write-Warning "$OSMediaPath exists.  Contents will be replaced!"
                Remove-Item -Path "$OSMediaPath" -Force -Recurse
                Write-Host ""
            }

            #===================================================================================================
            #   19.1.1 Set Working Directories'
            #===================================================================================================
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
            #   19.1.1 Export RegCurrentVersion'
            #===================================================================================================
            $RegCurrentVersion | Out-File "$Info\CurrentVersion.txt"
            $RegCurrentVersion | Out-File "$OSMediaPath\CurrentVersion.txt"
            $RegCurrentVersion | Out-File "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-CurrentVersion.txt"
            $RegCurrentVersion | Export-Clixml -Path "$Info\xml\CurrentVersion.xml"
            $RegCurrentVersion | Export-Clixml -Path "$Info\xml\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-CurrentVersion.xml"
            $RegCurrentVersion | ConvertTo-Json | Out-File "$Info\json\CurrentVersion.json"
            $RegCurrentVersion | ConvertTo-Json | Out-File "$Info\json\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-CurrentVersion.json"

            #===================================================================================================
            #   19.1.1 Start Transcript'
            #===================================================================================================
            Write-Host '========================================================================================' -ForegroundColor DarkGray
            $ScriptName = $MyInvocation.MyCommand.Name
            $LogName = "$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-$ScriptName.log"
            Start-Transcript -Path (Join-Path "$Info\logs" $LogName)

            #===================================================================================================
            Write-Verbose 'OSD-Info'
            #===================================================================================================
            OSD-Info-OSMedia
            OSD-Info-WindowsImage

            #===================================================================================================
            #   19.1.1 Media: Copy Operating System'
            #===================================================================================================
            Write-Host '========================================================================================' -ForegroundColor DarkGray
            Write-Host "Media: Copy Operating System to $OS" -ForegroundColor Green
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
            #   19.2.13 Export
            #===================================================================================================
            OSD-AutoExtraFilesBackup -OSMediaPath "$OSMediaPath"
            OSD-SessionsCopy -OSMediaPath "$OSMediaPath"
            OSD-OS-Inventory -OSMediaPath "$OSMediaPath"
            Export-WinPEWims -OSMediaPath "$OSMediaPath"
            OSD-WinPE-ExportInventory -OSMediaPath "$OSMediaPath"

            #===================================================================================================
            #   19.1.1 Install.wim: Dismount
            #===================================================================================================
            Write-Host "Install.wim: Dismount from $MountDirectory" -ForegroundColor Green
            if ($OSImagePath -like "*.esd") {
                try {Remove-Item "$TempESD" -Force | Out-Null}
                catch {Write-Warning "Could not remove $TempESD"}
            }

            $CurrentLog = "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Dismount-WindowsImage.log"
            Write-Verbose "CurrentLog: $CurrentLog"
            Dismount-WindowsImage -Discard -Path "$MountDirectory" -LogPath "$CurrentLog" | Out-Null

            #===================================================================================================
            #   19.1.1 Install.wim: Export Configuration
            #===================================================================================================
            Write-Host "Install.wim: Export Configuration to $OSMediaPath\WindowsImage.txt" -ForegroundColor Green
            $GetWindowsImage = @()
            $GetWindowsImage = Get-WindowsImage -ImagePath "$OS\sources\install.wim" -Index 1 | Select-Object -Property *

            Write-Verbose "========== SPBuild: $($GetWindowsImage.Build).$($GetWindowsImage.SPBuild)"
            if ($OSVersion -like "6.1*") {
                Write-Verbose '========== Windows 6.1'
                $UBR = "$($GetWindowsImage.Build).$($GetWindowsImage.SPBuild)"
            }
            Write-Verbose "========== UBR: $UBR"

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
            OSD-Export-WindowsImageContent
            OSD-Export-Variables

            #===================================================================================================
            #   19.1.1 Show-OSDBuilderInfo
            #===================================================================================================
            if ($OSDInfo.IsPresent) {Show-OSDBuilderInfo -FullName $OSMediaPath}

            #===================================================================================================
            #   19.1.1 Stop Transcript
            #===================================================================================================
            Write-Host '========================================================================================' -ForegroundColor DarkGray
            Stop-Transcript
            #===================================================================================================
            #   19.1.1 Update-OSMedia
            #===================================================================================================
            if ($UpdateOSMedia.IsPresent) {
                if ($OSMajorVersion -eq '10') {
                    Write-Verbose "Update-OSMedia -Name $OSMediaName -Download -Execute"
                    Update-OSMedia -Name "$OSMediaName" -Download -Execute
                } else  {
                    Write-Verbose "Import-OSMedia: Cannot process Update-OSMedia with this Operating System version"
                    Write-Verbose "Import-OSMedia: Try using Update-OSMedia separately"
                }
            }
        }
    }

    END {
        #Write-Host '========================================================================================' -ForegroundColor DarkGray
        #Write-Host "$($MyInvocation.MyCommand.Name) END" -ForegroundColor Green
    }
}