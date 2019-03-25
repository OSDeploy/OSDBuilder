<#
.SYNOPSIS
Creates a JSON Task for use with New-PEBuild

.DESCRIPTION
Creates a JSON Task for use with New-PEBuild

.LINK
http://osdbuilder.com/docs/functions/pebuild/new-pebuildtask

.PARAMETER SourceWim
Wim to use for the PEBuild

.PARAMETER TaskName
Name of the Task to create

.PARAMETER DeploymentShare
MDT DeployRoot Full Path

.PARAMETER AutoExtraFiles
Add Auto ExtraFiles to WinPE

.PARAMETER ScratchSpace
Set the Scratch Space for WinPE
#>

function New-PEBuildTask {
    [CmdletBinding(DefaultParameterSetName='Recovery')]
    PARAM (
        #==========================================================
        [Parameter(Mandatory)]
        [string]$TaskName,
        #==========================================================
        [Parameter(Mandatory,ParameterSetName='MDT')]
        [string]$DeploymentShare,
        #==========================================================
        [Parameter(Mandatory,ParameterSetName='WinPE')]
        [Parameter(Mandatory,ParameterSetName='MDT')]
        [ValidateSet('WinRE','WinPE')]
        [string]$SourceWim,
        #==========================================================
        [switch]$AutoExtraFiles,
        [string]$CustomName,
        [ValidateSet('64','128','256','512')]
        [string]$ScratchSpace = '128'
        #==========================================================
    )

    BEGIN {
        #Write-Host '========================================================================================' -ForegroundColor DarkGray
        #Write-Host "$($MyInvocation.MyCommand.Name) BEGIN" -ForegroundColor Green

        #===================================================================================================
        Write-Verbose '19.1.1 Initialize OSDBuilder'
        #===================================================================================================
        Get-OSDBuilder -CreatePaths -HideDetails
    }

    PROCESS {
        Write-Host '========================================================================================' -ForegroundColor DarkGray
        Write-Host "$($MyInvocation.MyCommand.Name) PROCESS" -ForegroundColor Green
        
        #===================================================================================================
        #   19.1.1 Validate Administrator Rights
        #===================================================================================================
        if (!([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
            Write-Warning 'OSDBuilder: This function needs to be run as Administrator'
            Pause
			Exit
        }

        #===================================================================================================
        Write-Verbose '19.1.1 Information'
        #===================================================================================================
        $WinPEOutput = $($PsCmdlet.ParameterSetName)
        if ($WinPEOutput -eq 'Recovery') {$SourceWim = 'WinRE'}

        $TaskName = "$TaskName"
        $TaskPath = "$OSDBuilderTasks\$WinPEOutput $TaskName.json"
        Write-Host '========================================================================================' -ForegroundColor DarkGray
        Write-Host "New-PEBuild Task Settings" -ForegroundColor Green
        Write-Host "-Task Name:                     $TaskName"
        Write-Host "-Task Path:                     $TaskPath"
        Write-Host "-WinPE Output:                  $WinPEOutput"
        Write-Host "-Custom Name:                   $CustomName"
        Write-Host "-Wim File:                      $SourceWim"
        Write-Host "-Deployment Share:              $DeploymentShare"
        Write-Host "-Scratch Space:                 $ScratchSpace"

        #===================================================================================================
        Write-Verbose '19.1.1 Validate Task'
        #===================================================================================================
        if (Test-Path $TaskPath) {
            Write-Host '========================================================================================' -ForegroundColor DarkGray
            Write-Warning "Task already exists at $TaskPath"
            Write-Warning "Content will be overwritten!"
        }

        #===================================================================================================
        Write-Verbose '19.3.21 Get-OSMedia'
        #===================================================================================================
        $OSMedia = @()
        $OSMedia = Get-OSMedia -ShowLatest | Where-Object {$_.MajorVersion -eq 10}

        if ($TaskName -like "*x64*") {$OSMedia = $OSMedia | Where-Object {$_.Arch -eq 'x64'}}
        if ($TaskName -like "*x86*") {$OSMedia = $OSMedia | Where-Object {$_.Arch -eq 'x86'}}
        if ($TaskName -like "*1511*") {$OSMedia = $OSMedia | Where-Object {$_.ReleaseId -eq '1511'}}
        if ($TaskName -like "*1607*") {$OSMedia = $OSMedia | Where-Object {$_.ReleaseId -eq '1607'}}
        if ($TaskName -like "*1703*") {$OSMedia = $OSMedia | Where-Object {$_.ReleaseId -eq '1703'}}
        if ($TaskName -like "*1709*") {$OSMedia = $OSMedia | Where-Object {$_.ReleaseId -eq '1709'}}
        if ($TaskName -like "*1803*") {$OSMedia = $OSMedia | Where-Object {$_.ReleaseId -eq '1803'}}
        if ($TaskName -like "*1809*") {$OSMedia = $OSMedia | Where-Object {$_.ReleaseId -eq '1809'}}

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
            $RegCurrentVersion = Import-Clixml -Path "$OSSourcePath\info\xml\CurrentVersion.xml"
            $ReleaseId = $($RegCurrentVersion.ReleaseId)
            if ($ReleaseId -gt 1809) {
                Write-Warning "OSDBuilder does not currently support this version of Windows ... Check for an updated version"
            }
        }

        #===================================================================================================
        Write-Verbose '19.1.1 Set ReleaseId'
        #===================================================================================================
        if ($null -eq $ReleaseId) {
            if ($OSBuild -eq 7601) {$ReleaseId = 7601}
            if ($OSBuild -eq 10240) {$ReleaseId = 1507}
            if ($OSBuild -eq 14393) {$ReleaseId = 1607}
            if ($OSBuild -eq 15063) {$ReleaseId = 1703}
            if ($OSBuild -eq 16299) {$ReleaseId = 1709}
            if ($OSBuild -eq 17134) {$ReleaseId = 1803}
            if ($OSBuild -eq 17763) {$ReleaseId = 1809}
        }

        #===================================================================================================
        Write-Verbose '19.1.1 WinPE DaRT'
        #===================================================================================================
        $SelectedWinPEDaRT =@()
        $SelectedWinPEDaRT = Get-ChildItem -Path "$OSDBuilderContent\WinPE\DaRT" *.cab -Recurse | Select-Object -Property Name, FullName
        foreach ($Pack in $SelectedWinPEDaRT) {$Pack.FullName = $($Pack.FullName).replace("$OSDBuilderContent\",'')}
        $SelectedWinPEDaRT = $SelectedWinPEDaRT | Where-Object {$_.FullName -like "*$OSArchitecture*"}
        $SelectedWinPEDaRT = $SelectedWinPEDaRT | Out-GridView -Title "Select a WinPE DaRT Package to apply and press OK (Esc or Cancel to Skip)" -OutputMode Single
        if($null -eq $SelectedWinPEDaRT) {Write-Warning "Skipping WinPE DaRT"}
        #===================================================================================================
        Write-Verbose '19.1.1 WinPE Drivers'
        #===================================================================================================
        $SelectedWinPEDrivers =@()
        $SelectedWinPEDrivers = Get-ChildItem -Path "$OSDBuilderContent\WinPE\Drivers" -Directory | Select-Object -Property Name, FullName
        $SelectedWinPEDrivers = $SelectedWinPEDrivers | Where-Object {(Get-ChildItem $_.FullName | Measure-Object).Count -gt 0}
        foreach ($Pack in $SelectedWinPEDrivers) {$Pack.FullName = $($Pack.FullName).replace("$OSDBuilderContent\",'')}
        $SelectedWinPEDrivers = $SelectedWinPEDrivers | Out-GridView -Title "Select WinPE Drivers to apply and press OK (Esc or Cancel to Skip)" -PassThru
        if($null -eq $SelectedWinPEDrivers) {Write-Warning "Skipping WinPE Drivers"}
        #===================================================================================================
        Write-Verbose '19.1.1 WinPE Scripts'
        #===================================================================================================
        $SelectedWinPEScripts =@()
        $SelectedWinPEScripts = Get-ChildItem -Path "$OSDBuilderContent\WinPE\Scripts" *.ps1 | Select-Object -Property Name, FullName
        foreach ($Pack in $SelectedWinPEScripts) {$Pack.FullName = $($Pack.FullName).replace("$OSDBuilderContent\",'')}
        $SelectedWinPEScripts = $SelectedWinPEScripts | Out-GridView -Title "Select WinPE PowerShell Scripts to execute and press OK (Esc or Cancel to Skip)" -PassThru
        if($null -eq $SelectedWinPEScripts) {Write-Warning "Skipping WinPE PowerShell Scripts"}
        #===================================================================================================
        Write-Verbose '19.1.1 WinPE Extra Files'
        #===================================================================================================
        $SelectedWinPEExtraFiles =@()
        $SelectedWinPEExtraFiles = Get-ChildItem -Path "$OSDBuilderContent\WinPE\ExtraFiles" -Directory | Select-Object -Property Name, FullName
        $SelectedWinPEExtraFiles = $SelectedWinPEExtraFiles | Where-Object {(Get-ChildItem $_.FullName | Measure-Object).Count -gt 0}
        foreach ($Pack in $SelectedWinPEExtraFiles) {$Pack.FullName = $($Pack.FullName).replace("$OSDBuilderContent\",'')}
        $SelectedWinPEExtraFiles = $SelectedWinPEExtraFiles | Out-GridView -Title "Select WinPE Extra Files to apply and press OK (Esc or Cancel to Skip)" -PassThru
        if($null -eq $SelectedWinPEExtraFiles) {Write-Warning "Skipping WinPE Extra Files"}

        #===================================================================================================
        Write-Verbose '19.1.1 Setup ADK Packages'
        #===================================================================================================
        $SelectedWinPEADKPkgs =@()
        $SelectedWinPEADKPkgs = Get-ChildItem -Path "$OSDBuilderContent\WinPE\ADK" *.cab -Recurse | Select-Object -Property Name, FullName
        foreach ($Pack in $SelectedWinPEADKPkgs) {$Pack.FullName = $($Pack.FullName).replace("$OSDBuilderContent\",'')}
        $SelectedWinPEADKPkgs = $SelectedWinPEADKPkgs | Where-Object {$_.FullName -like "*$OSArchitecture*"}
        $SelectedWinPEADKPkgs = $SelectedWinPEADKPkgs | Where-Object {$_.FullName -like "*$ReleaseId*"}
        $SelectedWinPEADKPkgs = $SelectedWinPEADKPkgs | Out-GridView -Title "Select WinPE ADK Packages to apply and press OK (Esc or Cancel to Skip)" -PassThru
        if($null -eq $SelectedWinPEADKPkgs) {Write-Warning "Skipping WinPE ADK Packages"}
        
        #===================================================================================================
        Write-Verbose '19.2.12 Build Task'
        #===================================================================================================
        $Task = [ordered]@{
            "TaskType" = [string]'PEBuild';
            "TaskName" = [string]$TaskName;
            "TaskVersion" = [string]$OSDBuilderVersion;
            "TaskGuid" = [string]$(New-Guid);

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

            "WinPEOutput" = [string]$WinPEOutput;
            "CustomName" = [string]$CustomName;
            "MDTDeploymentShare" = [string]$DeploymentShare;
            "ScratchSpace" = [string]$ScratchSpace;
            "SourceWim" = [string]$SourceWim;
            "WinPEAutoExtraFiles" = [string]$AutoExtraFiles;
            "WinPEExtraFiles" = [string[]]$SelectedWinPEExtraFiles.FullName;
            "WinPEADK" = [string[]]$SelectedWinPEADKPkgs.FullName;
            "WinPEDaRT" = [string]$SelectedWinPEDaRT.FullName;
            "WinPEDrivers" = [string[]]$SelectedWinPEDrivers.FullName;
            "WinPEScripts" = [string[]]$SelectedWinPEScripts.FullName;
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
        #Write-Host "$($MyInvocation.MyCommand.Name) END" -ForegroundColor Green
    }
}