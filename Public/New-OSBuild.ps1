<#
.SYNOPSIS
Creates a new OSBuild from an OSBuild Task

.DESCRIPTION
Creates a new OSBuild from an OSBuild Task created with New-OSBuildTask

.LINK
http://osdbuilder.com/docs/functions/osbuild/new-osbuild

.PARAMETER OSDISO
Creates an ISO of the OSDBuilder Media

.PARAMETER Download
Automatically download the required updates if they are not present in the Content\Updates directory

.PARAMETER Execute
Execute the Build

.PARAMETER ByTaskName
Task Name to Execute

.PARAMETER DontUseNewestMedia
Use the OSMedia specified in the Task, not the Latest

.PARAMETER WaitDismount
Adds a 'Press Enter to Continue' prompt before the Install.wim is dismounted

.PARAMETER WaitDismountWinPE
Adds a 'Press Enter to Continue' prompt before the WinPE Wims are dismounted

.PARAMETER SkipTemplates
Create a new OSBuild without applying Templates

.PARAMETER SkipUpdates
Create a new OSBuild without applying Updates

.PARAMETER Taskless
Create a new OSBuild from OSMedia without a Task
#>
function New-OSBuild {
    [CmdletBinding(DefaultParameterSetName='Basic')]
    PARAM (
        [switch]$Download,
        [switch]$Execute,
        [switch]$OSDInfo,
        [switch]$OSDISO,
        #==========================================================
        [Parameter(ParameterSetName='Advanced')]
        [string]$ByTaskName,
        
        [Parameter(ParameterSetName='Advanced')]
        [switch]$DontUseNewestMedia,

        [Parameter(ParameterSetName='Advanced')]
        [switch]$WaitDismount,

        [Parameter(ParameterSetName='Advanced')]
        [switch]$WaitDismountWinPE,
        #==========================================================
        [Parameter(ParameterSetName='Advanced')]
        [Parameter(ParameterSetName='Taskless')]
        [switch]$SkipComponentCleanup,

        [Parameter(ParameterSetName='Advanced')]
        [Parameter(ParameterSetName='Taskless')]
        [switch]$SkipTemplates,

        [Parameter(ParameterSetName='Advanced')]
        [Parameter(ParameterSetName='Taskless')]
        [switch]$SkipUpdates,
        #==========================================================
        [Parameter(ParameterSetName='Taskless', ValueFromPipelineByPropertyName=$True)]
        [string[]]$Name,

        [Parameter(ParameterSetName='Taskless', Mandatory=$True)]
        [switch]$SkipTask
        #==========================================================
    )

    BEGIN {
        #Write-Host '========================================================================================' -ForegroundColor DarkGray
        #Write-Host "$($MyInvocation.MyCommand.Name) BEGIN" -ForegroundColor Green
        Get-OSDBuilder -CreatePaths -HideDetails

        #===================================================================================================
        #   19.1.1 Validate Administrator Rights
        #===================================================================================================
        if (!([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
            Write-Warning 'OSDBuilder: This function needs to be run as Administrator'
            Pause
			Exit
        }
    }

    PROCESS {
        Write-Host '========================================================================================' -ForegroundColor DarkGray
        Write-Host "$($MyInvocation.MyCommand.Name) PROCESS" -ForegroundColor Green
        
        #===================================================================================================
        #   OSBuild
        Write-Verbose '19.3.21 Get-OSBuildTask'
        #===================================================================================================
        if ($MyInvocation.MyCommand.Name -eq 'New-OSBuild') {
            if ($PSCmdlet.ParameterSetName -eq 'Taskless') {
                if ($Name) {
                    $BirdBox = foreach ($Task in $Name) {
                        Write-Verbose '========== Checking $Task'
                        $ObjectProperties = @{
                            Name = $Task
                        }
                        New-Object -TypeName PSObject -Property $ObjectProperties
                    }
                } else {
                    $BirdBox = @()
                    if ($ShowAllOSMedia.IsPresent) {
                        $BirdBox = Get-OSMedia
                    } else {
                        $BirdBox = Get-OSMedia -Revision OK -OSMajorVersion 10
                    }
                    $BirdBox = $BirdBox | Out-GridView -PassThru -Title "Select one or more OSMedia to Build (Cancel to Exit) and press OK"
                }
                if ($null -eq $BirdBox) {
                    Write-Warning "Could not find a matching OSMedia . . . Exiting!"
                    Return
                }
            } else {
                if ($ByTaskName) {
                    $BirdBox = @()
                    $BirdBox = Get-OSBuildTask | Where-Object {$_.TaskName -eq "$ByTaskName"}
                } else {
                    $BirdBox = @()
                    $BirdBox = Get-OSBuildTask | Out-GridView -PassThru -Title "OSBuild Tasks: Select one or more Tasks to execute and press OK (Cancel to Exit)"
                }

                if ($null -eq $BirdBox) {
                    Write-Warning "OSBuild Task was not selected or found . . . Exiting!"
                    Return
                }
            }
        }

        #===================================================================================================
        Write-Verbose '19.3.12 Get-OSMedia'
        #===================================================================================================
        if ($MyInvocation.MyCommand.Name -eq 'Update-OSMedia') {
            if ($Name) {
                $BirdBox = foreach ($Item in $Name) {
                    Write-Verbose '========== Checking $Item'
                    $ObjectProperties = @{
                        Name = $Item
                    }
                    New-Object -TypeName PSObject -Property $ObjectProperties
                }
            } else {
                $BirdBox = @()
                if ($ShowAllOSMedia.IsPresent) {
                    $BirdBox = Get-OSMedia
                } else {
                    $BirdBox = Get-OSMedia -Revision OK -Updates Update
                }
                if ($UpdateNeeded.IsPresent) {
                    if ($BirdBox | Where-Object {$_.MajorVersion -eq 6}) {
                        Write-Warning "UpdateNeeded does not support Legacy Operating Systems"
                        Write-Warning "Legacy Operating Systems have been removed from the results"
                        $BirdBox = $BirdBox | Where-Object {$_.MajorVersion -eq 10}
                    }
                    $BirdBox = $BirdBox | Where-Object {($_.Servicing -eq '') -or ($_.Cumulative -eq '') -or ($_.Adobe -eq '')}
                }
                $BirdBox = $BirdBox | Where-Object {($_.MajorVersion -eq 10) -or ($_.InstallationType -like "*Client*" -and $_.Version -like "6.1.7601*") -or ($_.InstallationType -like "*Server*" -and $_.Version -like "6.3*")}
                $BirdBox = $BirdBox | Out-GridView -PassThru -Title "Select one or more OSMedia to Update (Cancel to Exit) and press OK"
            }
        }

        foreach ($Bird in $BirdBox) {
            #===================================================================================================
            #   OSBuild
            Write-Verbose '19.1.1 Read Task Contents'
            #===================================================================================================
            if ($MyInvocation.MyCommand.Name -eq 'New-OSBuild') {
                if ($PSCmdlet.ParameterSetName -eq 'Taskless') {
                    $Task = Get-OSMedia -Revision OK | Where-Object {$_.Name -eq $Bird.Name}

                    $TaskType = 'OSBuild'
                    $TaskName = 'Taskless'
                } else {
                    (Get-Content "$($Bird.FullName)").replace('WinPEAddDaRT', 'WinPEDaRT') | Set-Content "$($Bird.FullName)"
                    $Task = Get-Content "$($Bird.FullName)" | ConvertFrom-Json

                    $TaskType = $Task.TaskType
                    $TaskName = $Task.TaskName
                }
                $TaskVersion = $Task.TaskVersion
                $CustomName = $Task.CustomName

                $TaskOSMFamily = $Task.OSMFamily
                $TaskOSMGuid = $Task.OSMGuid
                $OSMediaName = $Task.Name
                $OSMediaPath = "$OSDBuilderOSMedia\$OSMediaName"

                $EnableNetFX3 = $Task.EnableNetFX3
                $StartLayoutXML = $Task.StartLayoutXML
                $UnattendXML = $Task.UnattendXML
                $WinPEAutoExtraFiles = $Task.WinPEAutoExtraFiles
                $WinPEDaRT = $Task.WinPEDart
                
                $ExtraFiles = $Task.ExtraFiles
                $Scripts = $Task.Scripts
                $Drivers = $Task.Drivers

                $Packages = $Task.AddWindowsPackage
                $RemovePackage = $Task.RemoveWindowsPackage
                $FeaturesOnDemand = $Task.AddFeatureOnDemand
                $EnableFeature = $Task.EnableWindowsOptionalFeature
                $DisableFeature = $Task.DisableWindowsOptionalFeature
                $RemoveAppx = $Task.RemoveAppxProvisionedPackage
                $RemoveCapability = $Task.RemoveWindowsCapability

                $WinPEDrivers = $Task.WinPEDrivers
                $WinPEScriptsPE = $Task.WinPEScriptsPE
                $WinPEScriptsRE = $Task.WinPEScriptsRE
                $WinPEScriptsSE = $Task.WinPEScriptsSE
                $WinPEExtraFilesPE = $Task.WinPEExtraFilesPE
                $WinPEExtraFilesRE = $Task.WinPEExtraFilesRE
                $WinPEExtraFilesSE = $Task.WinPEExtraFilesSE
                $WinPEADKPE = $Task.WinPEADKPE
                $WinPEADKRE = $Task.WinPEADKRE
                $WinPEADKSE = $Task.WinPEADKSE
                
                $SetAllIntl = $Task.LangSetAllIntl
                $SetInputLocale = $Task.LangSetInputLocale
                $SetSKUIntlDefaults = $Task.LangSetSKUIntlDefaults
                $SetSetupUILang = $Task.LangSetSetupUILang
                $SetSysLocale = $Task.LangSetSysLocale
                $SetUILang = $Task.LangSetUILang
                $SetUILangFallback = $Task.LangSetUILangFallback
                $SetUserLocale = $Task.LangSetUserLocale
                $LanguageFeatures = $Task.LanguageFeature
                $LanguagePacks = $Task.LanguagePack
                $LanguageInterfacePacks = $Task.LanguageInterfacePack
                $LocalExperiencePacks = $Task.LocalExperiencePacks
                
                if (!($TaskName -eq 'Taskless')) {OSD-Info-TaskInformation}
            }
            #===================================================================================================
            #   OSBuild
            Write-Verbose '19.1.1 Validate Proper TaskVersion'
            #===================================================================================================
            if ($MyInvocation.MyCommand.Name -eq 'New-OSBuild' -and (!($TaskName -eq 'Taskless'))) {
                if ([System.Version]$TaskVersion -lt [System.Version]"19.1.4.0") {
                    Write-Host '========================================================================================' -ForegroundColor DarkGray
                    Write-Warning "OSDBuilder Tasks need to be version 19.1.4.0 or newer"
                    Write-Warning "Recreate this Task using New-OSBuildTask or Repair-OSBuildTask"
                    Return
                }
            }

            #===================================================================================================
            #   OSBuild
            Write-Verbose '19.3.21 Select Latest OSMedia'
            #===================================================================================================
            if ($MyInvocation.MyCommand.Name -eq 'New-OSBuild' -and (!($DontUseNewestMedia))) {
                if ($TaskName -eq 'Taskless') {
                    $TaskOSMedia = Get-OSMedia | Where-Object {$_.Name -eq $OSMediaName}
                } else {
                    $TaskOSMedia = Get-OSMedia | Where-Object {$_.OSMGuid -eq $TaskOSMGuid}
                }
                
                if ($TaskOSMedia) {
                    $OSMediaName = $TaskOSMedia.Name
                    $OSMediaPath = $TaskOSMedia.FullName
                    Write-Host '========================================================================================' -ForegroundColor DarkGray
                    Write-Host "Task Source OSMedia" -ForegroundColor Green
                    Write-Host "-OSMedia Name:                  $OSMediaName"
                    Write-Host "-OSMedia Path:                  $OSMediaPath"
                    Write-Host "-OSMedia Family:                $TaskOSMFamily"
                    Write-Host "-OSMedia Guid:                  $TaskOSMGuid"
                }
                $LatestOSMedia = Get-OSMedia -Revision OK | Where-Object {$_.OSMFamily -eq $TaskOSMFamily}
                if ($LatestOSMedia) {
                    $OSMediaName = $LatestOSMedia.Name
                    $OSMediaPath = $LatestOSMedia.FullName
                    Write-Host '========================================================================================' -ForegroundColor DarkGray
                    Write-Host "Latest Source OSMedia" -ForegroundColor Green
                    Write-Host "-OSMedia Name:                  $OSMediaName"
                    Write-Host "-OSMedia Path:                  $OSMediaPath"
                    Write-Host "-OSMedia Family:                $($LatestOSMedia.OSMFamily)"
                    Write-Host "-OSMedia Guid:                  $($LatestOSMedia.OSMGuid)"
                } else {
                    Write-Warning "Unable to find a matching OSMFamily $TaskOSMFamily"
                    Return
                }
            }
            
            #===================================================================================================
            #   OSBuild
            Write-Verbose '19.1.22 Templates'
            #===================================================================================================
            if ($MyInvocation.MyCommand.Name -eq 'New-OSBuild' -and (Test-Path "$OSDBuilderTemplates") -and (!($SkipTemplates.IsPresent))) {
                Write-Host '========================================================================================' -ForegroundColor DarkGray
                Write-Host "OSBuild Templates" -ForegroundColor Green
                Get-ChildItem -Path "$OSDBuilderTemplates" *.json | foreach {(Get-Content "$($_.FullName)").replace('WinPEAddDaRT', 'WinPEDaRT') | Set-Content "$($_.FullName)"}
                $Templates = @()
                $Templates = Get-ChildItem -Path "$OSDBuilderTemplates" OSBuild*.json | ForEach-Object {Get-Content -Path $_.FullName | ConvertFrom-Json | Select-Object -Property *}

                foreach ($Task in $Templates) {
                    if ($Task.TaskName -like "*Global*") {
                        Write-Host "Global: $($Task.TaskName)"
                    } elseif ($Task.OSMFamily -eq $TaskOSMFamily) {
                        Write-Host "OSMedia Family: $($Task.TaskName)"
                    } else {
                        Write-Host "Skipping: $($Task.TaskName)" -ForegroundColor DarkGray
                        Continue
                    }

                    if (!($Task.EnableNetFX3 -eq $False)) {$EnableNetFX3 = $Task.EnableNetFX3}
                    if ($Task.StartLayoutXML) {$StartLayoutXML = $Task.StartLayoutXML}
                    if ($Task.UnattendXML) {$UnattendXML = $Task.UnattendXML}
                    if (!($Task.WinPEAutoExtraFiles -eq $False)) {$WinPEAutoExtraFiles = $Task.WinPEAutoExtraFiles}
                    if ($Task.WinPEDaRT) {$WinPEDaRT = $Task.WinPEDaRT}
                    
                    $ExtraFiles += @($Task.ExtraFiles | Where-Object {$_})
                    $Scripts += @($Task.Scripts | Where-Object {$_})
                    $Drivers += @($Task.Drivers | Where-Object {$_})
    
                    $Packages += @($Task.AddWindowsPackage | Where-Object {$_})
                    $RemovePackage += @($Task.RemoveWindowsPackage | Where-Object {$_})
                    $FeaturesOnDemand += @($Task.AddFeatureOnDemand | Where-Object {$_})
                    $EnableFeature += @($Task.EnableWindowsOptionalFeature | Where-Object {$_})
                    $DisableFeature += @($Task.DisableWindowsOptionalFeature | Where-Object {$_})
                    $RemoveAppx += @($Task.RemoveAppxProvisionedPackage | Where-Object {$_})
                    $RemoveCapability += @($Task.RemoveWindowsCapability | Where-Object {$_})
    
                    $WinPEDrivers += @($Task.WinPEDrivers | Where-Object {$_})
                    $WinPEScriptsPE += @($Task.WinPEScriptsPE | Where-Object {$_})
                    $WinPEScriptsRE += @($Task.WinPEScriptsRE | Where-Object {$_})
                    $WinPEScriptsSE += @($Task.WinPEScriptsSE | Where-Object {$_})
                    $WinPEExtraFilesPE += @($Task.WinPEExtraFilesPE | Where-Object {$_})
                    $WinPEExtraFilesRE += @($Task.WinPEExtraFilesRE | Where-Object {$_})
                    $WinPEExtraFilesSE += @($Task.WinPEExtraFilesSE | Where-Object {$_})
                    $WinPEADKPE += @($Task.WinPEADKPE | Where-Object {$_})
                    $WinPEADKRE += @($Task.WinPEADKRE | Where-Object {$_})
                    $WinPEADKSE += @($Task.WinPEADKSE | Where-Object {$_})
                    
                    if ($Task.SetAllIntl) {$SetAllIntl = $Task.SetAllIntl}
                    if ($Task.LangSetInputLocale) {$SetInputLocale = $Task.LangSetInputLocale}
                    if ($Task.LangSetSKUIntlDefaults) {$SetSKUIntlDefaults = $Task.LangSetSKUIntlDefaults}
                    if ($Task.LangSetSetupUILang) {$SetSetupUILang = $Task.LangSetSetupUILang}
                    if ($Task.LangSetSysLocale) {$SetSysLocale = $Task.LangSetSysLocale}
                    if ($Task.LangSetUILang) {$SetUILang = $Task.LangSetUILang}
                    if ($Task.LangSetUILangFallback) {$SetUILangFallback = $Task.LangSetUILangFallback}
                    if ($Task.LangSetUserLocale) {$SetUserLocale = $Task.LangSetUserLocale}
                    $LanguageFeatures += @($Task.LanguageFeature | Where-Object {$_})
                    $LanguagePacks += @($Task.LanguagePack | Where-Object {$_})
                    $LanguageInterfacePacks += @($Task.LanguageInterfacePack | Where-Object {$_})
                    $LocalExperiencePacks += @($Task.LocalExperiencePacks | Where-Object {$_})
                }
            }
            if ($MyInvocation.MyCommand.Name -eq 'New-OSBuild') {
                if (!($SkipTemplates.IsPresent)) {OSD-Info-TaskInformation}
            }
            #===================================================================================================
            Write-Verbose '19.1.1 Set Proper Paths'
            #===================================================================================================
            if ($MyInvocation.MyCommand.Name -eq 'Update-OSMedia') {
                $OSMediaPath = "$OSDBuilderOSMedia\$($Bird.Name)"
            }
            $OSImagePath = "$OSMediaPath\OS\sources\install.wim"

            if (!(Test-Path "$OSMediaPath\WindowsImage.txt")) {
                Write-Host '========================================================================================' -ForegroundColor DarkGray
                Write-Warning "$OSMediaPath is not a valid OSMedia Directory"
                Return
            }

            if (!(Test-Path "$OSImagePath")) {
                Write-Host '========================================================================================' -ForegroundColor DarkGray
                Write-Warning "$OSImagePath is not a valid Windows Image"
                Return
            }

            #===================================================================================================
            Write-Verbose '19.1.1 Get Windows Image Information'
            #===================================================================================================
            $OSImageIndex = 1
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
            $OSVersion =            $($WindowsImage.Version)
            $OSMajorVersion =       $($WindowsImage.MajorVersion)
            $OSMinorVersion =       $($WindowsImage.MinorVersion)
            $OSBuild =              $($WindowsImage.Build)
            $OSSPBuild =            $($WindowsImage.SPBuild)
            $OSSPLevel =            $($WindowsImage.SPLevel)
            $OSImageBootable =      $($WindowsImage.ImageBootable)
            $OSWIMBoot =            $($WindowsImage.WIMBoot)
            $OSCreatedTime =        $($WindowsImage.CreatedTime)
            $OSModifiedTime =       $($WindowsImage.ModifiedTime)

            OSD-Info-SourceOSMedia
            #===================================================================================================
            Write-Verbose '19.1.1 Validate Registry CurrentVersion.xml'
            #===================================================================================================
            if (Test-Path "$OSMediaPath\info\xml\CurrentVersion.xml") {
                $RegCurrentVersion = Import-Clixml -Path "$OSMediaPath\info\xml\CurrentVersion.xml"
                $ReleaseId = $($RegCurrentVersion.ReleaseId)
                if ($ReleaseId -gt 1809) {
                    Write-Host '========================================================================================' -ForegroundColor DarkGray
                    Write-Warning "OSDBuilder does not currently support this version of Windows ... Check for an updated version"
                }
            }
            #===================================================================================================
            Write-Verbose '19.1.1 Set ReleaseId'
            #===================================================================================================
            if ($null -eq $ReleaseId) {
                if ($OSBuild -eq 7600) {$ReleaseId = 7600}
                if ($OSBuild -eq 7601) {$ReleaseId = 7601}
                if ($OSBuild -eq 9600) {$ReleaseId = 9600}
                if ($OSBuild -eq 10240) {$ReleaseId = 1507}
                if ($OSBuild -eq 14393) {$ReleaseId = 1607}
                if ($OSBuild -eq 15063) {$ReleaseId = 1703}
                if ($OSBuild -eq 16299) {$ReleaseId = 1709}
                if ($OSBuild -eq 17134) {$ReleaseId = 1803}
                if ($OSBuild -eq 17763) {$ReleaseId = 1809}
            }
            #===================================================================================================
            #   Operating System
            #===================================================================================================
            $UpdateOS = ''
            if ($OSMajorVersion -eq 10) {
                if ($OSInstallationType -notlike "*Server*") {$UpdateOS = 'Windows 10'}
                elseif ($OSBuild -ge 17763) {$UpdateOS = 'Windows Server 2019'}
                else {$UpdateOS = 'Windows Server 2016'}
            } elseif ($OSMajorVersion -eq 6) {
                if ($OSInstallationType -like "*Server*") {
                    if ($OSVersion -like "6.3*") {
                        $UpdateOS = 'Windows Server 2012 R2'
                    }
                    elseif ($OSVersion -like "6.2*") {
                        $UpdateOS = 'Windows Server 2012'
                        Write-Warning "This Operating System is not supported"
                        Return
                    }
                    elseif ($OSVersion -like "6.1*") {
                        $UpdateOS = 'Windows Server 2008 R2'
                        Write-Warning "This Operating System is not supported"
                        Return
                    }
                    else {
                        Write-Warning "This Operating System is not supported"
                    }
                } else {
                    if ($OSVersion -like "6.3*") {
                        $UpdateOS = 'Windows 8.1'
                        Write-Warning "This Operating System is not supported"
                        Return
                    }
                    elseif ($OSVersion -like "6.2*") {
                        $UpdateOS = 'Windows 8'
                        Write-Warning "This Operating System is not supported"
                        Return
                    }
                    elseif ($OSVersion -like "6.1*") {
                        $UpdateOS = 'Windows 7'
                    }
                    else {
                        Write-Warning "This Operating System is not supported"
                    }
                }
            }
            #===================================================================================================
            Write-Verbose '19.1.1 WorkingName and WorkingPath'
            #===================================================================================================
            if ($MyInvocation.MyCommand.Name -eq 'New-OSBuild') {
                $WorkingName = "build$((Get-Date).ToString('mmss'))"
                $WorkingPath = "$OSDBuilderOSBuilds\$WorkingName"
            } else {
                $WorkingName = "build$((Get-Date).ToString('mmss'))"
                $WorkingPath = "$OSDBuilderOSMedia\$WorkingName"
            }
            #===================================================================================================
            Write-Verbose '19.1.1 Remove Existing OSMedia'
            #===================================================================================================
            if (Test-Path $WorkingPath) {
                Write-Host '========================================================================================' -ForegroundColor DarkGray
                Write-Warning "$WorkingPath will be replaced!"
            }
            #===================================================================================================
            #   OSBuild
            #   Driver Templates
            #===================================================================================================
            if ($MyInvocation.MyCommand.Name -eq 'New-OSBuild' -and (Test-Path "$OSDBuilderTemplates") -and (!($SkipTemplates.IsPresent))) {
                Write-Host '========================================================================================' -ForegroundColor DarkGray
                Write-Host "OSBuild Template Driver Directories (Applied)" -ForegroundColor Green
                $DriverTemplates = OSD-GetDriverTemplates
            }
            #===================================================================================================
            #   OSBuild
            #   ExtraFiles Templates
            #===================================================================================================
            if ($MyInvocation.MyCommand.Name -eq 'New-OSBuild' -and (Test-Path "$OSDBuilderTemplates") -and (!($SkipTemplates.IsPresent))) {
                Write-Host '========================================================================================' -ForegroundColor DarkGray
                Write-Host "OSBuild Template ExtraFiles Directories (Searched)" -ForegroundColor Green
                $ExtraFilesTemplates = OSD-GetExtraFilesTemplates
                Write-Host "OSBuild Template ExtraFiles Files (Applied)" -ForegroundColor Green
                if ($ExtraFilesTemplates) {foreach ($Item in $ExtraFilesTemplates) {Write-Host $Item.FullName -ForegroundColor Gray}}
            }
            #===================================================================================================
            #   OSBuild
            #   Registry REG Templates
            #===================================================================================================
            if ($MyInvocation.MyCommand.Name -eq 'New-OSBuild' -and (Test-Path "$OSDBuilderTemplates") -and (!($SkipTemplates.IsPresent))) {
                Write-Host '========================================================================================' -ForegroundColor DarkGray
                Write-Host "OSBuild Template Registry REG Directories (Searched)" -ForegroundColor Green
                $RegistryTemplatesReg = OSD-GetRegistryTemplatesReg
                Write-Host "OSBuild Template Registry REG Files (Applied)" -ForegroundColor Green
                if ($RegistryTemplatesReg) {foreach ($Item in $RegistryTemplatesReg) {Write-Host $Item.FullName -ForegroundColor Gray}}
            }
            #===================================================================================================
            #   OSBuild
            #   Registry XML Templates
            #===================================================================================================
            if ($MyInvocation.MyCommand.Name -eq 'New-OSBuild' -and (Test-Path "$OSDBuilderTemplates") -and (!($SkipTemplates.IsPresent))) {
                Write-Host '========================================================================================' -ForegroundColor DarkGray
                Write-Host "OSBuild Template Registry XML Directories (Searched)" -ForegroundColor Green
                $RegistryTemplatesXml = OSD-GetRegistryTemplatesXml
                Write-Host "OSBuild Template Registry XML Files (Applied)" -ForegroundColor Green
                if ($RegistryTemplatesXml) {foreach ($Item in $RegistryTemplatesXml) {Write-Host $Item.FullName -ForegroundColor Gray}}
            }
            #===================================================================================================
            #   OSBuild
            #   Script Templates
            #===================================================================================================
            if ($MyInvocation.MyCommand.Name -eq 'New-OSBuild' -and (Test-Path "$OSDBuilderTemplates") -and (!($SkipTemplates.IsPresent))) {
                Write-Host '========================================================================================' -ForegroundColor DarkGray
                Write-Host "OSBuild Template Script Directories (Searched)" -ForegroundColor Green
                $ScriptTemplates = OSD-GetScriptTemplates
                Write-Host "OSBuild Template Script Files (Applied)" -ForegroundColor Green
                if ($ScriptTemplates) {foreach ($Item in $ScriptTemplates) {Write-Host $Item.FullName -ForegroundColor Gray}}
            }
            #===================================================================================================
            #   Operating System Updates
            #===================================================================================================
            Write-Host '========================================================================================' -ForegroundColor DarkGray
            Write-Host "Operating System Updates" -ForegroundColor Green
            #===================================================================================================
            #   OSDUpdate Catalogs
            #===================================================================================================
            $OSDUpdates = @()
            $OSDUpdates = OSD-Update-GetOSDUpdates
            #===================================================================================================
            #   Skip Updates
            #===================================================================================================
            if ($SkipUpdates.IsPresent) {$OSDUpdates = @()}
            #===================================================================================================
            #   Filter UpdateArch
            #===================================================================================================
            $OSDUpdates = $OSDUpdates | Where-Object {$_.UpdateArch -eq $OSArchitecture}
            #===================================================================================================
            #   Filter UpdateOS
            #===================================================================================================
            $OSDUpdates = $OSDUpdates | Where-Object {$_.UpdateOS -eq $UpdateOS}
            #===================================================================================================
            #   Filter UpdateBuild
            #===================================================================================================
            $OSDUpdates = $OSDUpdates | Where-Object {($_.UpdateBuild -eq $ReleaseId) -or ($_.UpdateBuild -eq '')}
            #===================================================================================================
            #   OSDBuilder 10 Setup Updates
            #===================================================================================================
            $OSDUpdateSetupDU = @()
            $OSDUpdateSetupDU = $OSDUpdates | Where-Object {$_.UpdateGroup -eq 'SetupDU'}
            $OSDUpdateSetupDU = $OSDUpdateSetupDU | Sort-Object -Property CreationDate
            foreach ($Update in $OSDUpdateSetupDU) {
                if ($Update.OSDStatus -eq 'Downloaded') {
                    Write-Host "Ready       SetupDU         $($Update.Title)"
                } else {
                    if ($Download.IsPresent) {
                        OSD-Update-Download -OSDGuid $Update.OSDGuid
                    } else {
                        Write-Host "Missing     SetupDU         $($Update.Title)" -ForegroundColor Yellow
                        $Execute = $false
                    }
                }
            }
            #===================================================================================================
            #   OSDBuilder 10 Component Updates
            #===================================================================================================
            $OSDUpdateComponentDU = @()
            $OSDUpdateComponentDU = $OSDUpdates | Where-Object {$_.UpdateGroup -like "ComponentDU*"}
            $OSDUpdateComponentDU = $OSDUpdateComponentDU | Sort-Object -Property CreationDate
            foreach ($Update in $OSDUpdateComponentDU) {
                if ($Update.OSDStatus -eq 'Downloaded') {
                    Write-Host "Ready       ComponentDU     $($Update.Title)"
                } else {
                    if ($Download.IsPresent) {
                        OSD-Update-Download -OSDGuid $Update.OSDGuid
                    } else {
                        Write-Host "Missing     ComponentDU     $($Update.Title)" -ForegroundColor Yellow
                        $Execute = $false
                    }
                }
            }
            #===================================================================================================
            #   OSDBuilder 10 Servicing Stack
            #===================================================================================================
            $OSDUpdateSSU = @()
            if ($OSMajorVersion -eq 10) {
                $OSDUpdateSSU = $OSDUpdates | Where-Object {$_.UpdateGroup -eq 'SSU'}
                $OSDUpdateSSU = $OSDUpdateSSU | Sort-Object -Property CreationDate
                foreach ($Update in $OSDUpdateSSU) {
                    if ($Update.OSDStatus -eq 'Downloaded') {
                        Write-Host "Ready       Servicing       $($Update.Title)"
                    } else {
                        if ($Download.IsPresent) {
                            OSD-Update-Download -OSDGuid $Update.OSDGuid
                        } else {
                            Write-Host "Missing     Servicing       $($Update.Title)" -ForegroundColor Yellow
                            $Execute = $false
                        }
                    }
                }
            }
            #===================================================================================================
            #   OSDBuilder 10 Latest Cumulative Update
            #===================================================================================================
            $OSDUpdateLCU = @()
            if ($OSMajorVersion -eq 10) {
                $OSDUpdateLCU = $OSDUpdates | Where-Object {$_.UpdateGroup -eq 'LCU'}
                $OSDUpdateLCU = $OSDUpdateLCU | Sort-Object -Property CreationDate
                foreach ($Update in $OSDUpdateLCU) {
                    if ($Update.OSDStatus -eq 'Downloaded') {
                        Write-Host "Ready       Cumulative      $($Update.Title)"
                    } else {
                        if ($Download.IsPresent) {
                            OSD-Update-Download -OSDGuid $Update.OSDGuid
                        } else {
                            Write-Host "Missing     Cumulative      $($Update.Title)" -ForegroundColor Yellow
                            $Execute = $false
                        }
                    }
                }
            }
            #===================================================================================================
            #   OSDBuilder 10 Adobe
            #===================================================================================================
            $OSDUpdateAdobeSU = @()
            if ($OSMajorVersion -eq 10) {
                $OSDUpdateAdobeSU = $OSDUpdates | Where-Object {$_.UpdateGroup -eq 'AdobeSU'}
                $OSDUpdateAdobeSU = $OSDUpdateAdobeSU | Sort-Object -Property CreationDate
                foreach ($Update in $OSDUpdateAdobeSU) {
                    if ($Update.OSDStatus -eq 'Downloaded') {
                        Write-Host "Ready       AdobeSU         $($Update.Title)"
                    } else {
                        if ($Download.IsPresent) {
                            OSD-Update-Download -OSDGuid $Update.OSDGuid
                        } else {
                            Write-Host "Missing     AdobeSU         $($Update.Title)" -ForegroundColor Yellow
                            $Execute = $false
                        }
                    }
                }
            }
            #===================================================================================================
            #   OSDBuilder 10 DotNet
            #===================================================================================================
            $OSDUpdateDotNet = @()
            if ($OSMajorVersion -eq 10) {
                $OSDUpdateDotNet = $OSDUpdates | Where-Object {$_.UpdateGroup -like "DotNet*"}
                $OSDUpdateDotNet = $OSDUpdateDotNet | Sort-Object -Property CreationDate
                foreach ($Update in $OSDUpdateDotNet) {
                    if ($Update.OSDStatus -eq 'Downloaded') {
                        Write-Host "Ready       DotNet          $($Update.Title)"
                    } else {
                        if ($Download.IsPresent) {
                            OSD-Update-Download -OSDGuid $Update.OSDGuid
                        } else {
                            Write-Host "Missing     DotNet          $($Update.Title)" -ForegroundColor Yellow
                            $Execute = $false
                        }
                    }
                }
            }
            #===================================================================================================
            #   OSDBuilder Seven
            #===================================================================================================
            $OSDUpdateWinSeven = @()
            if ($MyInvocation.MyCommand.Name -eq 'Update-OSMedia' -and $UpdateOS -eq 'Windows 7') {
                $OSDUpdateWinSeven = $OSDUpdates
                $OSDUpdateWinSeven = $OSDUpdateWinSeven | Sort-Object -Property CreationDate
                foreach ($Update in $OSDUpdateWinSeven) {
                    if ($Update.OSDStatus -eq 'Downloaded') {
                        Write-Host "Ready       Seven       $($Update.Title)"
                    } else {
                        if ($Download.IsPresent -and $_.UpdateGroup -ne 'Optional') {
                            OSD-Update-Download -OSDGuid $Update.OSDGuid
                        } else {
                            Write-Host "Missing     Seven       $($Update.Title)" -ForegroundColor Yellow
                            if ($_.UpdateGroup -ne 'Optional') {$Execute = $false}
                        }
                    }
                }
            }
            #===================================================================================================
            #   OSDBuilder EightOne
            #===================================================================================================
            $OSDUpdateWinEightOne = @()
            if ($MyInvocation.MyCommand.Name -eq 'Update-OSMedia' -and $UpdateOS -eq 'Windows 8.1') {
                $OSDUpdateWinEightOne = $OSDUpdates
                $OSDUpdateWinEightOne = $OSDUpdateWinEightOne | Where-Object {$_.UpdateGroup -ne 'SetupDU'}
                $OSDUpdateWinEightOne = $OSDUpdateWinEightOne | Where-Object {$_.UpdateGroup -notlike "ComponentDU*"}
                $OSDUpdateWinEightOne = $OSDUpdateWinEightOne | Sort-Object -Property CreationDate
                foreach ($Update in $OSDUpdateWinEightOne) {
                    if ($Update.OSDStatus -eq 'Downloaded') {
                        Write-Host "Ready       EightOne        $($Update.Title)"
                    } else {
                        if ($Download.IsPresent -and $_.UpdateGroup -ne 'Optional') {
                            OSD-Update-Download -OSDGuid $Update.OSDGuid
                        } else {
                            Write-Host "Missing     EightOne        $($Update.Title)" -ForegroundColor Yellow
                            if ($_.UpdateGroup -ne 'Optional') {$Execute = $false}
                        }
                    }
                }
            }
            #===================================================================================================
            #   OSDBuilder Twelve
            #===================================================================================================
            $OSDUpdateWinTwelveR2 = @()
            if ($MyInvocation.MyCommand.Name -eq 'Update-OSMedia' -and $UpdateOS -eq 'Windows Server 2012 R2') {
                $OSDUpdateWinTwelveR2 = $OSDUpdates
                $OSDUpdateWinTwelveR2 = $OSDUpdateWinTwelveR2 | Where-Object {$_.UpdateGroup -ne 'SetupDU'}
                $OSDUpdateWinTwelveR2 = $OSDUpdateWinTwelveR2 | Where-Object {$_.UpdateGroup -notlike "ComponentDU*"}
                $OSDUpdateWinTwelveR2 = $OSDUpdateWinTwelveR2 | Sort-Object -Property CreationDate
                foreach ($Update in $OSDUpdateWinTwelveR2) {
                    if ($Update.OSDStatus -eq 'Downloaded') {
                        Write-Host "Ready       TwelveR2        $($Update.Title)"
                    } else {
                        if ($Download.IsPresent -and $_.UpdateGroup -ne 'Optional') {
                            OSD-Update-Download -OSDGuid $Update.OSDGuid
                        } else {
                            Write-Host "Missing     TwelveR2        $($Update.Title)" -ForegroundColor Yellow
                            if ($_.UpdateGroup -ne 'Optional') {$Execute = $false}
                        }
                    }
                }
            }
            #===================================================================================================
            #   OSDBuilder Optional
            #===================================================================================================
            $OSDUpdateOptional = @()
            if ($MyInvocation.MyCommand.Name -eq 'New-OSBuild' -and $OSMajorVersion -eq 10) {
                $OSDUpdateOptional = $OSDUpdates | Where-Object {$_.UpdateGroup -eq ''}
                $OSDUpdateOptional = $OSDUpdateOptional | Sort-Object -Property CreationDate
                foreach ($Update in $OSDUpdateOptional) {
                    if ($Update.OSDStatus -eq 'Downloaded') {
                        Write-Host "Optional        Ready       $($Update.Title)"
                    } else {
                        Write-Host "Missing     Optional        $($Update.Title)" -ForegroundColor Yellow
                    }
                }
            }
            #===================================================================================================
            #   Update Check
            #===================================================================================================
            if ($MyInvocation.MyCommand.Name -eq 'New-OSBuild' -and $LatestOSMedia) {
                if ($LatestOSMedia.Updates -ne 'OK') {
                    Write-Host '========================================================================================' -ForegroundColor DarkGray
                    Write-Warning "This OSMedia does not have the latest Microsoft Updates"
                    Write-Warning "Use the following command before running New-OSBuild"
                    Write-Warning "Update-OSMedia -Name `'$OSMediaName`' -Download -Execute"
                    Write-Host '========================================================================================' -ForegroundColor DarkGray
                }
            }
            #===================================================================================================
            #   Execution Check
            #===================================================================================================
            if ($Execute -eq $False) {Write-Warning "Execution is currently disabled"}
            #===================================================================================================
            Write-Verbose '19.1.25 Execute'
            #===================================================================================================
            if ($Execute.IsPresent) {
                #===================================================================================================
                Write-Verbose '19.1.25 Remove Existing WorkingPath'
                #===================================================================================================
                if (Test-Path $WorkingPath) {
                    Write-Host '========================================================================================' -ForegroundColor DarkGray
                    Remove-Item -Path "$WorkingPath" -Force -Recurse
                }
                #===================================================================================================
                Write-Verbose '19.2.25 Set Variables'
                #===================================================================================================
                $MountDirectory = Join-Path $OSDBuilderContent\Mount "os$((Get-Date).ToString('mmss'))"
                $MountWinPE = Join-Path $OSDBuilderContent\Mount "winpe$((Get-Date).ToString('mmss'))"
                $MountWinRE = Join-Path $OSDBuilderContent\Mount "winre$((Get-Date).ToString('mmss'))"
                $MountWinSE = Join-Path $OSDBuilderContent\Mount "setup$((Get-Date).ToString('mmss'))"
                $Info = Join-Path $WorkingPath 'info'
                    $Logs = Join-Path $Info 'logs'
                $OS = Join-Path $WorkingPath 'OS'
                $WimTemp = Join-Path $WorkingPath "WimTemp"
                $WinPE = Join-Path $WorkingPath 'WinPE'
                    $PEInfo = Join-Path $WinPE 'info'
                    $PELogs = Join-Path $PEInfo 'logs'
                #===================================================================================================
                Write-Verbose '19.1.1 Start Transcript'
                #===================================================================================================
                Write-Host '========================================================================================' -ForegroundColor DarkGray
                $ScriptName = $($MyInvocation.MyCommand.Name)
                $LogName = "$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-$ScriptName.log"
                Start-Transcript -Path (Join-Path "$Info\logs" $LogName)

                OSD-OS-CreateDirectories
                OSD-Info-WorkingInformation
                OSD-OS-CopyOS
                #===================================================================================================
                #   WinPE
                #===================================================================================================
                OSD-UpdatesPE-Setup
                OSD-WinPE-Mount -OSMediaPath "$WorkingPath"
                OSD-UpdatesPE-SSU
                OSD-UpdatesPE-LCU
                if ($MyInvocation.MyCommand.Name -eq 'Update-OSMedia') {
                    OSD-UpdatesPE-Seven
                }
                #===================================================================================================
                #   WinPE OSBuild
                #===================================================================================================
                if ($MyInvocation.MyCommand.Name -eq 'New-OSBuild') {
                    if ($WinPEDaRT) {OSD-WinPE-DaRT}
                    if ($WinPEAutoExtraFiles -eq $true) {OSD-WinPE-AutoExtraFiles}
                    if ($WinPEExtraFilesPE -or $WinPEExtraFilesRE -or $WinPEExtraFilesSE) {OSD-WinPE-ExtraFiles}
                    if ($WinPEDrivers) {OSD-WinPE-Drivers}
                    if ($WinPEADKPE -or $WinPEADKRE -or $WinPEADKSE) {OSD-WinPE-ADK}
                    if ($WinPEScriptsPE -or $WinPEScriptsRE -or $WinPEScriptsSE) {OSD-WinPE-Scripts}
                    #OSD-UpdatesPE-SSUForce
                    #OSD-UpdatesPE-LCUForce
                }

                OSD-WinPE-Sources -OSMediaPath "$WorkingPath"
                OSD-WinPE-PackageInventory -OSMediaPath "$WorkingPath"
                if ($WaitDismountWinPE.IsPresent){[void](Read-Host 'Press Enter to Continue')}
                OSD-WinPE-Dismount -OSMediaPath "$WorkingPath"
                OSD-WinPE-Export -OSMediaPath "$WorkingPath"
                OSD-WinPE-ExportBootWim -OSMediaPath "$WorkingPath"
                OSD-WinPE-ExportInventory -OSMediaPath "$WorkingPath"
                #===================================================================================================
                #   Install.wim
                #===================================================================================================
                OSD-OS-MountWindowsImage
                OSD-OS-ReplaceWinRE
                #===================================================================================================
                #   Install.wim UBR Pre-Update
                #===================================================================================================
                Write-Host "Install.wim: Mount Registry for UBR Information" -ForegroundColor Green
                reg LOAD 'HKLM\OSMedia' "$MountDirectory\Windows\System32\Config\SOFTWARE" | Out-Null
                $RegCurrentVersion = Get-ItemProperty -Path 'HKLM:\OSMedia\Microsoft\Windows NT\CurrentVersion'
                reg UNLOAD 'HKLM\OSMedia' | Out-Null
                $ReleaseId = $null
                $ReleaseId = $($RegCurrentVersion.ReleaseId)
                if ($($RegCurrentVersion.UBR)) {
                    $RegCurrentVersionUBR = $($RegCurrentVersion.UBR)
                    $UBR = "$OSBuild.$RegCurrentVersionUBR"
                } else {
                    $UBR = "$OSBuild.$OSSPBuild"
                    $RegCurrentVersionUBR = "$OSBuild.$OSSPBuild"
                }
                OSD-OS-RegExportCurrentVersion
                #===================================================================================================
                #   Install.wim Updates
                #===================================================================================================
                OSD-Updates-Component
                OSD-Updates-SSU
                $UBRPre = $UBR
                Write-Host "Install.wim: Update Build Revision $UBRPre (Pre-LCU)" -ForegroundColor Green
                OSD-Updates-LCU
                if ($MyInvocation.MyCommand.Name -eq 'Update-OSMedia') {
                    OSD-Updates-Seven
                    #OSD-Updates-EightOne
                    #OSD-Updates-Twelve
                    OSD-Updates-TwelveR2
                }
                #===================================================================================================
                #   Install.wim UBR Post-Update
                #===================================================================================================
                reg LOAD 'HKLM\OSMedia' "$MountDirectory\Windows\System32\Config\SOFTWARE" | Out-Null
                $RegCurrentVersion = Get-ItemProperty -Path 'HKLM:\OSMedia\Microsoft\Windows NT\CurrentVersion'
                reg UNLOAD 'HKLM\OSMedia' | Out-Null
                $ReleaseId = $null
                $ReleaseId = $($RegCurrentVersion.ReleaseId)
                if ($($RegCurrentVersion.UBR)) {
                    $RegCurrentVersionUBR = $($RegCurrentVersion.UBR)
                    $UBR = "$OSBuild.$RegCurrentVersionUBR"
                } else {
                    $UBR = "$OSBuild.$OSSPBuild"
                    $RegCurrentVersionUBR = "$OSBuild.$OSSPBuild"
                }
                OSD-OS-RegExportCurrentVersion
                #===================================================================================================
                Write-Host "Install.wim: Update Build Revision $UBR (Post-LCU)" -ForegroundColor Green
                #===================================================================================================
                OSD-Updates-Adobe
                OSD-Updates-DotNet
                OSD-Updates-DismImageCleanup

                if ($OSMajorVersion -eq 10 -and $OSInstallationType -eq 'Client') {
                    #===================================================================================================
                    #   OneDriveSetup Update
                    #===================================================================================================
                    Write-Host '========================================================================================' -ForegroundColor DarkGray
                    Write-Host "Install.wim: Update OneDriveSetup.exe" -ForegroundColor Green
                    Write-Warning "To update OneDriveSetup.exe use one of the following commands:"
                    Write-Warning "Get-DownOSDBuilder -ContentDownload 'OneDriveSetup Enterprise'"
                    Write-Warning "Get-DownOSDBuilder -ContentDownload 'OneDriveSetup Production'"
                    $OneDriveSetupDownload = $false
                    $OneDriveSetup = "$OSDBuilderContent\OneDrive\OneDriveSetup.exe"
                    if (!(Test-Path $OneDriveSetup)) {$OneDriveSetupDownload = $true}

                    if (Test-Path $OneDriveSetup) {
                        if (!(([System.Io.fileinfo]$OneDriveSetup).LastWriteTime.Date -ge [datetime]::Today )) {
                            $OneDriveSetupDownload = $true
                        }
                    }

<#                     if ($OneDriveSetupDownload -eq $true) {
                        $WebClient = New-Object System.Net.WebClient
                        Write-Host "Downloading to $OneDriveSetup" -ForegroundColor DarkGray
                        $WebClient.DownloadFile('https://go.microsoft.com/fwlink/p/?LinkId=248256',"$OneDriveSetup")
                    } #>

                    if ($OSArchitecture -eq 'x86') {
                        $OneDriveSetupInfo = Get-Item -Path "$MountDirectory\Windows\System32\OneDriveSetup.exe" | Select-Object -Property *
                        Write-Host "Install.wim version $($($OneDriveSetupInfo).VersionInfo.ProductVersion)" -ForegroundColor DarkGray
                        if (Test-Path $OneDriveSetup) {
                            robocopy "$OSDBuilderContent\OneDrive" "$MountDirectory\Windows\System32" OneDriveSetup.exe /ndl /xx /b /np /ts /tee /r:0 /w:0 /Log+:"$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Update-OneDriveSetup.log" | Out-Null
                            $OneDriveSetupInfo = Get-Item -Path "$MountDirectory\Windows\System32\OneDriveSetup.exe" | Select-Object -Property *
                            Write-Host "Updated version $($($OneDriveSetupInfo).VersionInfo.ProductVersion)" -ForegroundColor DarkGray
                        }
                    } else {
                        $OneDriveSetupInfo = Get-Item -Path "$MountDirectory\Windows\SysWOW64\OneDriveSetup.exe" | Select-Object -Property *
                        Write-Host "Install.wim version $($($OneDriveSetupInfo).VersionInfo.ProductVersion)" -ForegroundColor DarkGray
                        if (Test-Path $OneDriveSetup) {
                            robocopy "$OSDBuilderContent\OneDrive" "$MountDirectory\Windows\SysWOW64" OneDriveSetup.exe /ndl /xx /b /np /ts /tee /r:0 /w:0 /Log+:"$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Update-OneDriveSetup.log" | Out-Null
                            $OneDriveSetupInfo = Get-Item -Path "$MountDirectory\Windows\SysWOW64\OneDriveSetup.exe" | Select-Object -Property *
                            Write-Host "Updated version $($($OneDriveSetupInfo).VersionInfo.ProductVersion)" -ForegroundColor DarkGray
                        }
                    }
                }

                #===================================================================================================
                #	OSBuild Only
                #===================================================================================================
                if ($MyInvocation.MyCommand.Name -eq 'New-OSBuild') {
                    if ($LanguagePacks) {OSD-Lang-LanguagePacks}
                    if ($LanguageInterfacePacks) {OSD-Lang-LanguageInterfacePacks}
                    if ($LocalExperiencePacks) {OSD-Lang-LocalExperiencePacks}
                    if ($LanguageFeatures) {OSD-Lang-LanguageFeatures}
                    if ($LanguagePacks -or $LanguageInterfacePacks -or $LanguageFeatures -or $LocalExperiencePacks) {
                        OSD-Lang-LanguageSettings
                        OSD-Updates-LCUForce
                        OSD-Updates-DismImageCleanup
                    }
                    if ($FeaturesOnDemand) {OSD-OSBuild-FeaturesOnDemand}
                    if ($EnableFeature) {OSD-OSBuild-EnableWindowsOptionalFeature}
                    if ($EnableNetFX3 -eq 'True') {OSD-OSBuild-EnableNetFX}
                    if ($RemoveAppx) {OSD-OSBuild-RemoveAppx}
                    if ($RemovePackage) {OSD-OSBuild-RemovePackage}
                    if ($RemoveCapability) {OSD-OSBuild-RemoveCapability}
                    if ($DisableFeature) {OSD-OSBuild-DisableWindowsOptionalFeature}
                    if ($Packages) {OSD-OSBuild-Packages}
                    OSD-Drivers
                    OSD-ExtraFiles
                    if ($StartLayoutXML) {OSD-OSBuild-StartLayout}
                    if ($UnattendXML) {OSD-OSBuild-Unattend}
                    OSD-Scripts

                    OSD-Updates-SSUForce
                }
                #===================================================================================================
                #	Mirror OSMedia and OSBuild
                #===================================================================================================
                OSD-AutoExtraFilesBackup -OSMediaPath "$WorkingPath"
                OSD-SessionsCopy -OSMediaPath "$WorkingPath"
                OSD-OS-Inventory -OSMediaPath "$WorkingPath"
                if ($MyInvocation.MyCommand.Name -eq 'New-OSBuild') {
                    OSD-RegistryREG
                    OSD-RegistryXML
                }
                OSD-OS-DismountWindowsImage
                OSD-OS-ExportWindowsImage
                #===================================================================================================
                Write-Verbose '19.1.1 Install.wim: Export Configuration'
                #===================================================================================================
                Write-Host "Install.wim: Export Configuration to $WorkingPath\WindowsImage.txt" -ForegroundColor Green
                $GetWindowsImage = @()
                $GetWindowsImage = Get-WindowsImage -ImagePath "$OS\sources\install.wim" -Index 1 | Select-Object -Property *

                Write-Verbose "========== SPBuild: $($GetWindowsImage.Build).$($GetWindowsImage.SPBuild)"
                if ($OSVersion -like "6.*") {
                    Write-Verbose '========== Windows 6.x'
                    $UBR = "$($GetWindowsImage.Build).$($GetWindowsImage.SPBuild)"
                }
                Write-Verbose "========== UBR: $UBR"

                $GetWindowsImage | Add-Member -Type NoteProperty -Name "UBR" -Value $UBR
                $GetWindowsImage | Out-File "$WorkingPath\WindowsImage.txt"
                $GetWindowsImage | Out-File "$Info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsImage.txt"
                $GetWindowsImage | Export-Clixml -Path "$Info\xml\Get-WindowsImage.xml"
                $GetWindowsImage | Export-Clixml -Path "$Info\xml\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsImage.xml"
                $GetWindowsImage | ConvertTo-Json | Out-File "$Info\json\Get-WindowsImage.json"
                $GetWindowsImage | ConvertTo-Json | Out-File "$Info\json\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsImage.json"
                (Get-Content "$WorkingPath\WindowsImage.txt") | Where-Object {$_.Trim(" `t")} | Set-Content "$WorkingPath\WindowsImage.txt"
                
                #===================================================================================================
                #    OSD-Export
                #===================================================================================================
                #OSD-Export-WindowsImageContentPE

                #===================================================================================================
                Write-Verbose '19.3.17 UBR Validation'
                #===================================================================================================
				if ($MyInvocation.MyCommand.Name -eq 'Update-OSMedia') {
					if ($UBRPre -eq $UBR) {
						Write-Host '========================================================================================' -ForegroundColor DarkGray
						Write-Warning 'The Update Build Revision did not change after Windows Updates'
						Write-Warning 'There may have been an issue applying the Latest Cumulative Update if this was not expected'
					}
				}
                if (!($UBR)) {
                    Write-Host '========================================================================================' -ForegroundColor DarkGray
                    $UBR = $((Get-Date).ToString('mmss'))
                    Write-Warning 'Could not determine a UBR'
                }

                #===================================================================================================
                Write-Verbose '19.1.1 Remove Temporary Files'
                #===================================================================================================
                if (Test-Path "$WimTemp") {Remove-Item -Path "$WimTemp" -Force -Recurse | Out-Null}
                if (Test-Path "$MountDirectory") {Remove-Item -Path "$MountDirectory" -Force -Recurse | Out-Null}
                if (Test-Path "$MountWinRE") {Remove-Item -Path "$MountWinRE" -Force -Recurse | Out-Null}
                if (Test-Path "$MountWinPE") {Remove-Item -Path "$MountWinPE" -Force -Recurse | Out-Null}
                if (Test-Path "$MountWinSE") {Remove-Item -Path "$MountWinSE" -Force -Recurse | Out-Null}

                #===================================================================================================
                Write-Verbose '19.1.1 Set New Name'
                #===================================================================================================
                $OSImageName = $($GetWindowsImage.ImageName)
                $OSImageName = $OSImageName -replace '\(', ''
                $OSImageName = $OSImageName -replace '\)', ''

                $OSArchitecture = $($GetWindowsImage.Architecture)
                if ($OSArchitecture -eq '0') {$OSArchitecture = 'x86'}
                if ($OSArchitecture -eq '6') {$OSArchitecture = 'ia64'}
                if ($OSArchitecture -eq '9') {$OSArchitecture = 'x64'}
                if ($OSArchitecture -eq '12') {$OSArchitecture = 'x64 ARM'}

                $OSBuild = $($GetWindowsImage.Build)
                $ReleaseId = $null
                if (Test-Path "$Info\xml\CurrentVersion.xml") {
                    $RegCurrentVersion = Import-Clixml -Path "$Info\xml\CurrentVersion.xml"
                    $ReleaseId = $($RegCurrentVersion.ReleaseId)
                }
                if ($OSBuild -eq 7600) {$ReleaseId = 7600}
                if ($OSBuild -eq 7601) {$ReleaseId = 7601}
                if ($OSBuild -eq 9600) {$ReleaseId = 9600}
                if ($OSBuild -eq 10240) {$ReleaseId = 1507}
                if ($OSBuild -eq 14393) {$ReleaseId = 1607}
                if ($OSBuild -eq 15063) {$ReleaseId = 1703}
                if ($OSBuild -eq 16299) {$ReleaseId = 1709}
                if ($OSBuild -eq 17134) {$ReleaseId = 1803}
                if ($OSBuild -eq 17763) {$ReleaseId = 1809}


                if ($OSMajorVersion -eq 10) {
                    if ($WorkingName -like "build*") {$NewOSMediaName = "$OSImageName $OSArchitecture $ReleaseId $UBR"}
                } else {
                    if ($WorkingName -like "build*") {$NewOSMediaName = "$OSImageName $OSArchitecture $UBR"}
                }

                $OSLanguages = $($GetWindowsImage.Languages)

                $NewOSMediaName = "$NewOSMediaName $OSLanguages"
                if ($($OSLanguages.count) -eq 1) {$NewOSMediaName = $NewOSMediaName.replace(' en-US','')}

                if ($MyInvocation.MyCommand.Name -eq 'New-OSBuild') {
                    if ($CustomName) {$NewOSMediaName = "$CustomName $UBR"}
                }
                
                if ($MyInvocation.MyCommand.Name -eq 'Update-OSMedia') {$NewOSMediaPath = "$OSDBuilderOSMedia\$NewOSMediaName"}
                if ($MyInvocation.MyCommand.Name -eq 'New-OSBuild') {$NewOSMediaPath = "$OSDBuilderOSBuilds\$NewOSMediaName"}

                #===================================================================================================
                Write-Verbose '19.1.1 Rename Build Directory'
                #===================================================================================================
                if (Test-Path $NewOSMediaPath) {
                    $mmss = $((Get-Date).ToString('mmss'))
                    Write-Host '========================================================================================' -ForegroundColor DarkGray
                    Write-Warning 'Trying to rename the Build directory, but it already exists'
                    Write-Warning "Appending $mmss to the directory Name"
                    Write-Host '========================================================================================' -ForegroundColor DarkGray
                    $NewOSMediaName = "$NewOSMediaName $mmss"
                    $NewOSMediaPath = "$OSDBuilderOSMedia\$NewOSMediaName"
                }

                #===================================================================================================
                #   OSD-Export
                #===================================================================================================
                OSD-Export-WindowsImageContent
                OSD-Export-Variables

                #===================================================================================================
                #   OSDBuilder Media'
                #===================================================================================================
                if ($OSDISO.IsPresent) {New-OSDBuilderISO -FullName "$WorkingPath"}
                if ($OSDVHD.IsPresent) {New-OSDBuilderVHD -FullName "$WorkingPath"}
                if ($OSDInfo.IsPresent) {Show-OSDBuilderInfo -FullName "$WorkingPath"}

                #===================================================================================================
                #   Complete Update
                #===================================================================================================
                Write-Host "Media: Renaming ""$WorkingPath"" to ""$NewOSMediaName""" -ForegroundColor Green
                Write-Host '========================================================================================' -ForegroundColor DarkGray
                Stop-Transcript
                try {
                    Rename-Item -Path "$WorkingPath" -NewName "$NewOSMediaName" -ErrorAction SilentlyContinue
                }
                catch {
                    Write-Warning "Could not rename the the Build directory ... Waiting 30 seconds ..."
                    Start-Sleep -Seconds 30
                }
                if (Test-Path "$WorkingPath") {
                    try {
                        Rename-Item -Path "$WorkingPath" -NewName "$NewOSMediaName" -ErrorAction SilentlyContinue
                    }
                    catch {
                        Write-Warning "Could not rename the the Build directory ... Existing"
                        Exit
                    }
                }
            }
        }
    }

    END {
        #Write-Host '========================================================================================' -ForegroundColor DarkGray
        #Write-Host "$($MyInvocation.MyCommand.Name) END" -ForegroundColor Green
    }
}