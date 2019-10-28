<#
.SYNOPSIS
Creates a JSON Task for use with New-PEBuild

.DESCRIPTION
Creates a JSON Task for use with New-PEBuild

.LINK
https://osdbuilder.osdeploy.com/module/functions/pebuild/new-pebuildtask

.PARAMETER SourceWim
Wim to use for the PEBuild

.PARAMETER TaskName
Name of the Task to create

.PARAMETER MDTDeploymentShare
MDT DeployRoot Full Path

.PARAMETER AutoExtraFiles
Add Auto ExtraFiles to WinPE

.PARAMETER ScratchSpace
Set the Scratch Space for WinPE
#>

function New-PEBuildTask {
    [CmdletBinding(DefaultParameterSetName='Recovery')]
    Param (
        #==========================================================
        [Parameter(Mandatory)]
        [string]$TaskName,
        #==========================================================
        [Parameter(Mandatory,ParameterSetName='MDT')]
        [string]$MDTDeploymentShare,
        #==========================================================
        [Parameter(Mandatory,ParameterSetName='WinPE')]
        [Parameter(Mandatory,ParameterSetName='MDT')]
        [ValidateSet('WinRE','WinPE')]
        [string]$SourceWim,
        #==========================================================
        [switch]$WinPEAutoExtraFiles,
        [string]$CustomName,
        [ValidateSet('64','128','256','512')]
        [string]$ScratchSpace = '128',
        #===================================================================================================
        #   WinPE Content
        #===================================================================================================
        [switch]$ContentWinPEADK,
        [switch]$ContentWinPEDart,
        [switch]$ContentWinPEDrivers,
        [switch]$ContentWinPEExtraFiles,
        [switch]$ContentWinPEScripts
    )

    Begin {
        #===================================================================================================
        #   Header
        #===================================================================================================
        #   Write-Host '========================================================================================' -ForegroundColor DarkGray
        #   Write-Host -ForegroundColor Green "$($MyInvocation.MyCommand.Name) BEGIN"
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
    }

    PROCESS {
        Write-Host '========================================================================================' -ForegroundColor DarkGray
        Write-Host -ForegroundColor Green "$($MyInvocation.MyCommand.Name) PROCESS"

        #===================================================================================================
        #   Set Task Name
        #===================================================================================================
        $WinPEOutput = $($PsCmdlet.ParameterSetName)
        if ($WinPEOutput -eq 'Recovery') {$SourceWim = 'WinRE'}

        $TaskName = "$TaskName"
        $TaskPath = "$OSDBuilderTasks\$WinPEOutput $TaskName.json"

        $ExistingTask = @()
        if (Test-Path "$TaskPath") {
            Write-Host '========================================================================================' -ForegroundColor DarkGray
            Write-Warning "Task already exists at $TaskPath"
            Write-Warning "Content will be updated!"
            $ExistingTask = Get-Content "$TaskPath" | ConvertFrom-Json
        }
        #===================================================================================================
        #   Task Information
        #===================================================================================================
        Write-Host '========================================================================================' -ForegroundColor DarkGray
        Write-Host "New-PEBuild Task Settings" -ForegroundColor Green
        Write-Host "-Task Name:                     $TaskName"
        Write-Host "-Task Path:                     $TaskPath"
        Write-Host "-WinPE Output:                  $WinPEOutput"
        Write-Host "-Custom Name:                   $CustomName"
        Write-Host "-Wim File:                      $SourceWim"
        Write-Host "-Deployment Share:              $MDTDeploymentShare"
        Write-Host "-Scratch Space:                 $ScratchSpace"
        #===================================================================================================
        Write-Verbose '19.3.26 Get-OSMedia'
        #===================================================================================================
        $OSMedia = @()
        $OSMedia = Get-OSMedia -Revision OK -OSMajorVersion 10

        if ($TaskName -like "*x64*") {$OSMedia = $OSMedia | Where-Object {$_.Arch -eq 'x64'}}
        if ($TaskName -like "*x86*") {$OSMedia = $OSMedia | Where-Object {$_.Arch -eq 'x86'}}
        if ($TaskName -like "*1511*") {$OSMedia = $OSMedia | Where-Object {$_.ReleaseId -eq '1511'}}
        if ($TaskName -like "*1607*") {$OSMedia = $OSMedia | Where-Object {$_.ReleaseId -eq '1607'}}
        if ($TaskName -like "*1703*") {$OSMedia = $OSMedia | Where-Object {$_.ReleaseId -eq '1703'}}
        if ($TaskName -like "*1709*") {$OSMedia = $OSMedia | Where-Object {$_.ReleaseId -eq '1709'}}
        if ($TaskName -like "*1803*") {$OSMedia = $OSMedia | Where-Object {$_.ReleaseId -eq '1803'}}
        if ($TaskName -like "*1809*") {$OSMedia = $OSMedia | Where-Object {$_.ReleaseId -eq '1809'}}
        if ($TaskName -like "*1903*") {$OSMedia = $OSMedia | Where-Object {$_.ReleaseId -eq '1903'}}
        if ($TaskName -like "*1909*") {$OSMedia = $OSMedia | Where-Object {$_.ReleaseId -eq '1909'}}

        $OSMedia = $OSMedia | Out-GridView -OutputMode Single -Title "Select a Source OSMedia to use for this Task (Cancel to Exit)"
        if($null -eq $OSMedia) {
            Write-Warning "Source OSMedia was not selected . . . Exiting!"
            Return
        }

        #===================================================================================================
        Write-Verbose '19.1.7 Get Windows Image Information'
        #===================================================================================================
        $WindowsImage = Get-WindowsImage -ImagePath "$($OSMedia.FullName)\OS\sources\install.wim" -Index 1 | Select-Object -Property *

        #===================================================================================================
        Write-Verbose '19.1.7 Source OSMedia Windows Image Information'
        #===================================================================================================
        Write-Host '========================================================================================' -ForegroundColor DarkGray
        Write-Host "Source OSMedia Windows Image Information" -ForegroundColor Green
        Write-Host "-OSMedia Chain:                 $($OSMedia.OSMFamily)"
        Write-Host "-OSMedia Guid:                  $($OSMedia.OSMGuid)"
        Write-Host "-OSMedia Name:                  $($OSMedia.Name)"
        Write-Host "-OSMedia FullName:              $($OSMedia.FullName)"
        Write-Host "-Image File:                    $($OSMedia.FullName)\OS\sources\install.wim"
        Write-Host "-Image Index:                   1"
        Write-Host "-Image Name:                    $($OSMedia.ImageName)"
        Write-Host "-Architecture:                  $($OSMedia.Arch)"
        Write-Host "-ReleaseId:                     $($OSMedia.ReleaseId)"
        Write-Host "-UBR:                           $($OSMedia.UBR)"
        Write-Host "-Edition:                       $($OSMedia.EditionId)"
        Write-Host "-InstallationType:              $($OSMedia.InstallationType)"
        Write-Host "-Languages:                     $($OSMedia.Languages)"
        Write-Host "-Version:                       $($WindowsImage.Version)"
        Write-Host "-Major Version:                 $($OSMedia.MajorVersion)"
        Write-Host "-Minor Version:                 $($WindowsImage.MinorVersion)"
        Write-Host "-Build:                         $($OSMedia.Build)"
        Write-Host "-SPBuild:                       $($WindowsImage.SPBuild)"
        Write-Host "-SPLevel:                       $($WindowsImage.SPLevel)"
        Write-Host "-Bootable:                      $($WindowsImage.ImageBootable)"
        Write-Host "-WimBoot:                       $($WindowsImage.WIMBoot)"
        Write-Host "-Created Time:                  $($OSMedia.CreatedTime)"
        Write-Host "-Modified Time:                 $($OSMedia.ModifiedTime)"
        
        #===================================================================================================
        Write-Verbose '19.1.1 Validate Registry CurrentVersion.xml'
        #===================================================================================================
        if (Test-Path "$OSSourcePath\info\xml\CurrentVersion.xml") {
            $RegKeyCurrentVersion = Import-Clixml -Path "$OSSourcePath\info\xml\CurrentVersion.xml"
            $ReleaseId = $($RegKeyCurrentVersion.ReleaseId)
            if ($ReleaseId -gt 1909) {
                Write-Warning "OSDBuilder does not currently support this version of Windows ... Check for an updated version"
            }
        }
        #===================================================================================================
        Write-Verbose '19.1.1 Set OSMedia.ReleaseId'
        #===================================================================================================
        if ($null -eq $($OSMedia.ReleaseId)) {
            if ($($OSMedia.Build) -eq 7601) {$OSMedia.ReleaseId = 7601}
            if ($($OSMedia.Build) -eq 10240) {$OSMedia.ReleaseId = 1507}
            if ($($OSMedia.Build) -eq 14393) {$OSMedia.ReleaseId = 1607}
            if ($($OSMedia.Build) -eq 15063) {$OSMedia.ReleaseId = 1703}
            if ($($OSMedia.Build) -eq 16299) {$OSMedia.ReleaseId = 1709}
            if ($($OSMedia.Build) -eq 17134) {$OSMedia.ReleaseId = 1803}
            if ($($OSMedia.Build) -eq 17763) {$OSMedia.ReleaseId = 1809}
            #if ($($OSMedia.Build) -eq 18362) {$OSMedia.ReleaseId = 1903}
        }
        #===================================================================================================
        Write-Host '========================================================================================' -ForegroundColor DarkGray
        #===================================================================================================
        #   Content WinPEDaRT
        #===================================================================================================
        Write-Host "WinPEDaRT" -ForegroundColor Green
        if ($ExistingTask.WinPEDaRT) {
            foreach ($Item in $ExistingTask.WinPEDaRT) {
                Write-Host "$Item" -ForegroundColor DarkGray
            }
        }
        $WinPEDaRT = $null
        if ($ContentWinPEDaRT.IsPresent) {
            if ($OSMedia.MajorVersion -eq 10) {
                [string]$WinPEDaRT = (Get-TaskWinPEDaRT).FullName
            }
        }
        if ($null -eq $WinPEDaRT) {if ($ExistingTask.WinPEDaRT) {$WinPEDaRT = $ExistingTask.WinPEDaRT}}
        #===================================================================================================
        #   ContentIsoExtract
        #===================================================================================================
        if ($ContentWinPEADK.IsPresent) {
            Write-Warning "Generating IsoExtract Content ... This may take a while"
            $ContentIsoExtract = @()
            [array]$ContentIsoExtract = Get-TaskContentIsoExtract

            $ContentIsoExtractWinPE = @()
            $ContentIsoExtractWinPE = $ContentIsoExtract | Where-Object {$_.FullName -like "*Windows Preinstallation Environment*"}
        }
        #===================================================================================================
        #   WinPEADK
        #===================================================================================================
        Write-Host "WinPEADK" -ForegroundColor Green
        if ($ExistingTask.WinPEADK) {
            foreach ($Item in $ExistingTask.WinPEADK) {
                Write-Host "$Item" -ForegroundColor DarkGray
            }
        }
        $WinPEADK = $null
        if ($ContentWinPEADK.IsPresent) {
            [array]$WinPEADK = (Get-TaskWinPEADK).FullName
            
            $WinPEADK = [array]$WinPEADK + [array]$ExistingTask.WinPEADK
            $WinPEADK = $WinPEADK | Sort-Object -Unique | Sort-Object Length
        } else {
            if ($ExistingTask.WinPEADK) {$WinPEADK = $ExistingTask.WinPEADK | Sort-Object Length}
        }
        #===================================================================================================
        #   WinPEDrivers
        #===================================================================================================
        Write-Host "WinPEDrivers" -ForegroundColor Green
        if ($ExistingTask.WinPEDrivers) {
            foreach ($Item in $ExistingTask.WinPEDrivers) {
                Write-Host "$Item" -ForegroundColor DarkGray
            }
        }
        $WinPEDrivers = $null
        if ($ContentWinPEDrivers.IsPresent) {
            [array]$WinPEDrivers = (Get-TaskWinPEDrivers).FullName
            
            $WinPEDrivers = [array]$WinPEDrivers + [array]$ExistingTask.WinPEDrivers
            $WinPEDrivers = $WinPEDrivers | Sort-Object -Unique
        } else {
            if ($ExistingTask.WinPEDrivers) {$WinPEDrivers = $ExistingTask.WinPEDrivers}
        }
        #===================================================================================================
        #   WinPEExtraFiles
        #===================================================================================================
        Write-Host "WinPEExtraFiles" -ForegroundColor Green
        if ($ExistingTask.WinPEExtraFiles) {
            foreach ($Item in $ExistingTask.WinPEExtraFiles) {
                Write-Host "$Item" -ForegroundColor DarkGray
            }
        }
        $WinPEExtraFiles = $null
        if ($ContentWinPEExtraFiles.IsPresent) {
            [array]$WinPEExtraFiles = (Get-TaskWinPEExtraFiles).FullName
            
            $WinPEExtraFiles = [array]$WinPEExtraFiles + [array]$ExistingTask.WinPEExtraFiles
            $WinPEExtraFiles = $WinPEExtraFiles | Sort-Object -Unique
        } else {
            if ($ExistingTask.WinPEExtraFiles) {$WinPEExtraFiles = $ExistingTask.WinPEExtraFiles}
        }
        #===================================================================================================
        #   WinPEScripts
        #===================================================================================================
        Write-Host "WinPEScripts" -ForegroundColor Green
        if ($ExistingTask.WinPEScripts) {
            foreach ($Item in $ExistingTask.WinPEScripts) {
                Write-Host "$Item" -ForegroundColor DarkGray
            }
        }
        $WinPEScripts = $null
        if ($ContentWinPEScripts.IsPresent) {
            [array]$WinPEScripts = (Get-TaskWinPEScripts).FullName
            
            $WinPEScripts = [array]$WinPEScripts + [array]$ExistingTask.WinPEScripts
            $WinPEScripts = $WinPEScripts | Sort-Object -Unique
        } else {
            if ($ExistingTask.WinPEScripts) {$WinPEScripts = $ExistingTask.WinPEScripts}
        }
        #===================================================================================================
        #   Parameters
        #===================================================================================================
        if (!($CustomName) -and $ExistingTask.CustomName) {$CustomName = $ExistingTask.CustomName}
        if (!($MDTDeploymentShare) -and $ExistingTask.MDTDeploymentShare) {$MDTDeploymentShare = $ExistingTask.MDTDeploymentShare}
        if (!($ScratchSpace) -and $ExistingTask.ScratchSpace) {$ScratchSpace = $ExistingTask.ScratchSpace}
        if ($ExistingTask.WinPEAutoExtraFiles -eq $true) {$WinPEAutoExtraFiles = $true}
        #===================================================================================================
        #   PEBuildTask
        #===================================================================================================
        $Task = [ordered]@{
            "TaskType" = [string]'PEBuild';
            "TaskVersion" = [string]$GetModuleOSDBuilderVersion;
            "TaskGuid" = [string]$(New-Guid);

            "TaskName" = [string]$TaskName;
            "CustomName" = [string]$CustomName;
            #===================================================================================================
            #   OSMedia
            #===================================================================================================
            "OSMFamily" = [string]$OSMedia.OSMFamily;
            "OSMGuid" = [string]$OSMedia.OSMGuid;
            "Name" = [string]$OSMedia.Name;
            "ImageName" = [string]$OSMedia.ImageName;
            "Arch" = [string]$OSMedia.Arch;
            "ReleaseId" = [string]$($OSMedia.ReleaseId);
            "UBR" = [string]$OSMedia.UBR;
            "Languages" = [string[]]$OSMedia.Languages;
            "EditionId" = [string]$OSMedia.EditionId;
            "InstallationType" = [string]$OSMedia.InstallationType;
            "MajorVersion" = [string]$OSMedia.MajorVersion;
            "Build" = [string]$OSMedia.Build;
            "CreatedTime" = [datetime]$OSMedia.CreatedTime;
            "ModifiedTime" = [datetime]$OSMedia.ModifiedTime;
            #===================================================================================================
            #   String
            #===================================================================================================
            "WinPEOutput" = [string]$WinPEOutput;
            "SourceWim" = [string]$SourceWim;
            "MDTDeploymentShare" = [string]$MDTDeploymentShare;
            "WinPEDaRT" = [string]$WinPEDaRT;
            #===================================================================================================
            #   Switch
            #===================================================================================================
            "WinPEAutoExtraFiles" = [string]$WinPEAutoExtraFiles;
            #===================================================================================================
            #   Int
            #===================================================================================================
            "ScratchSpace" = [string]$ScratchSpace;
            #===================================================================================================
            #   Array
            #===================================================================================================
            "WinPEADK" = [string[]]$WinPEADK;
            "WinPEDrivers" = [string[]]$WinPEDrivers;
            "WinPEExtraFiles" = [string[]]$WinPEExtraFiles;
            "WinPEScripts" = [string[]]$WinPEScripts;
        }

        #===================================================================================================
        Write-Verbose '19.1.1 New-OSBuildTask Complete'
        #===================================================================================================
        Write-Host '========================================================================================' -ForegroundColor DarkGray
        Write-Host "PEBuild Task: $TaskName" -ForegroundColor Green
        $Task | ConvertTo-Json | Out-File "$TaskPath"
        $Task
    }
    
    END {
        #Write-Host '========================================================================================' -ForegroundColor DarkGray
        #Write-Host -ForegroundColor Green "$($MyInvocation.MyCommand.Name) END"
    }
}