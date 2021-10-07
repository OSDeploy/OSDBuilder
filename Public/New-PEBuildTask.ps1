<#
.SYNOPSIS
Creates a JSON Task for use with New-PEBuild

.DESCRIPTION
Creates a JSON Task for use with New-PEBuild

.LINK
https://osdbuilder.osdeploy.com/module/functions/new-pebuildtask
#>

function New-PEBuildTask {
    [CmdletBinding(DefaultParameterSetName='Recovery')]
    param (
        #=================================================
        #   Basic Parameters
        #=================================================
        #Sets the name of the Task
        [Parameter(Mandatory)]
        [string]$TaskName,

        #Custom name of the Build used in the final output directory
        #This parameter is recommended
        [string]$CustomName,

        #Adds some handy files copied from the Windows OS
        #This parameter is recommended
        [switch]$WinPEAutoExtraFiles,

        #Allows selection of a Template Pack to this Build
        [switch]$AddContentPacks,

        #Set the Scratch Space for WinPE
        #Default is 512MB
        [ValidateSet('64','128','256','512')]
        [string]$ScratchSpace = '512',

        #Wim to use for the PEBuild
        [Parameter(Mandatory,ParameterSetName='WinPE')]
        [Parameter(Mandatory,ParameterSetName='MDT')]
        [ValidateSet('WinRE','WinPE')]
        [string]$SourceWim,
        #=================================================
        #   MDT
        #=================================================
        #Full Path to an MDT DeployRoot
        [Parameter(Mandatory,ParameterSetName='MDT')]
        [string]$MDTDeploymentShare,
        #=================================================
        #   Add Content
        #=================================================
        [switch]$ContentWinPEADK,
        [switch]$ContentWinPEDart,
        [switch]$ContentWinPEDrivers,
        [switch]$ContentWinPEExtraFiles,
        [switch]$ContentWinPEScripts
    )

    Begin {
        #=================================================
        #   Header
        #=================================================
        #   Write-Host '========================================================================================' -ForegroundColor DarkGray
        #   Write-Host -ForegroundColor Green "$($MyInvocation.MyCommand.Name) BEGIN"
        #=================================================
        #   Get-OSDBuilder
        #=================================================
        Get-OSDBuilder -CreatePaths -HideDetails
        #=================================================
        #   Block
        #=================================================
        Block-StandardUser
        #=================================================
    }

    Process {
        Write-Host '========================================================================================' -ForegroundColor DarkGray
        Write-Host -ForegroundColor Green "$($MyInvocation.MyCommand.Name) PROCESS"
        Write-Verbose "MyInvocation.MyCommand.Name: $($MyInvocation.MyCommand.Name)"
        Write-Verbose "PSCmdlet.ParameterSetName: $($PSCmdlet.ParameterSetName)"
        #=================================================
        #   Set Task Name
        #=================================================
        $WinPEOutput = $($PsCmdlet.ParameterSetName)
        if ($WinPEOutput -eq 'Recovery') {$SourceWim = 'WinRE'}

        $TaskName = "$TaskName"
        $TaskPath = "$SetOSDBuilderPathTasks\$WinPEOutput $TaskName.json"
        #=================================================
        #   Existing Task
        #=================================================
        $ExistingTask = @()
        if (Test-Path "$TaskPath") {
            Write-Host '========================================================================================' -ForegroundColor DarkGray
            Write-Warning "Task already exists at $TaskPath"
            Write-Warning "Content will be updated!"
            $ExistingTask = Get-Content "$TaskPath" | ConvertFrom-Json
        }
        #=================================================
        #   Task Information
        #=================================================
        Write-Host '========================================================================================' -ForegroundColor DarkGray
        Write-Host "New-PEBuild Task Settings" -ForegroundColor Green
        Write-Host "-Task Name:                     $TaskName"
        Write-Host "-Task Path:                     $TaskPath"
        Write-Host "-WinPE Output:                  $WinPEOutput"
        Write-Host "-Custom Name:                   $CustomName"
        Write-Host "-Wim File:                      $SourceWim"
        Write-Host "-Deployment Share:              $MDTDeploymentShare"
        Write-Host "-Scratch Space:                 $ScratchSpace"
        #=================================================
        #   Get-OSMedia
        #=================================================
        $OSMedia = @()
        $OSMedia = Get-OSMedia -Revision OK -OSMajorVersion 10 | Sort-Object Name

        if ($TaskName -match 'x64') {$OSMedia = $OSMedia | Where-Object {$_.Arch -eq 'x64'}}
        if ($TaskName -match 'x86') {$OSMedia = $OSMedia | Where-Object {$_.Arch -eq 'x86'}}
        if ($TaskName -match '1511') {$OSMedia = $OSMedia | Where-Object {$_.ReleaseId -eq '1511'}}
        if ($TaskName -match '1607') {$OSMedia = $OSMedia | Where-Object {$_.ReleaseId -eq '1607'}}
        if ($TaskName -match '1703') {$OSMedia = $OSMedia | Where-Object {$_.ReleaseId -eq '1703'}}
        if ($TaskName -match '1709') {$OSMedia = $OSMedia | Where-Object {$_.ReleaseId -eq '1709'}}
        if ($TaskName -match '1803') {$OSMedia = $OSMedia | Where-Object {$_.ReleaseId -eq '1803'}}
        if ($TaskName -match '1809') {$OSMedia = $OSMedia | Where-Object {$_.ReleaseId -eq '1809'}}
        if ($TaskName -match '1903') {$OSMedia = $OSMedia | Where-Object {$_.ReleaseId -eq '1903'}}
        if ($TaskName -match '1909') {$OSMedia = $OSMedia | Where-Object {$_.ReleaseId -eq '1909'}}
        if ($TaskName -match '2004') {$OSMedia = $OSMedia | Where-Object {$_.ReleaseId -eq '2004'}}
        if ($TaskName -match '2009') {$OSMedia = $OSMedia | Where-Object {($_.ReleaseId -eq '2009') -or ($_.ReleaseId -eq '20H2')}}
        if ($TaskName -match '20H2') {$OSMedia = $OSMedia | Where-Object {($_.ReleaseId -eq '2009') -or ($_.ReleaseId -eq '20H2')}}
        if ($TaskName -match '21H1') {$OSMedia = $OSMedia | Where-Object {$_.ReleaseId -eq '21H1'}}
        if ($TaskName -match '21H2') {$OSMedia = $OSMedia | Where-Object {$_.ReleaseId -eq '21H2'}}

        Try {
            $OSMedia = $OSMedia | Out-GridView -OutputMode Single -Title "Select a Source OSMedia to use for this Task (Cancel to Exit)"
        }
        Catch {
            Write-Warning "Source OSMedia was not selected . . . Exiting!"
            Break
        }
        if($null -eq $OSMedia) {
            Write-Warning "Source OSMedia was not selected . . . Exiting!"
            Return
        }
        #=================================================
        Write-Verbose 'Get-WindowsImage Information'
        #=================================================
        $WindowsImage = Get-WindowsImage -ImagePath "$($OSMedia.FullName)\OS\sources\install.wim" -Index 1 | Select-Object -Property *

        #=================================================
        Write-Verbose 'Source OSMedia Windows Image Information'
        #=================================================
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
        #=================================================
        Write-Verbose '19.10.29 Validate Registry CurrentVersion.xml'
        #=================================================
        if ($null -eq $($OSMedia.ReleaseId)) {
            if (Test-Path "$($OSMedia.FullName)\info\xml\CurrentVersion.xml") {
                $RegKeyCurrentVersion = Import-Clixml -Path "$($OSMedia.FullName)\info\xml\CurrentVersion.xml"
                $OSMedia.ReleaseId = $($RegKeyCurrentVersion.ReleaseId)
                if ($($OSMedia.ReleaseId) -gt 2009) {
                    Write-Warning "OSDBuilder does not currently support this version of Windows ... Check for an updated version"
                }
            }
        }
        #=================================================
        Write-Verbose '19.10.29 Set-OSMedia.ReleaseId'
        #=================================================
        if ($null -eq $($OSMedia.ReleaseId)) {
            if ($($OSMedia.Build) -eq 7601) {$OSMedia.ReleaseId = 7601}
            if ($($OSMedia.Build) -eq 10240) {$OSMedia.ReleaseId = 1507}
            if ($($OSMedia.Build) -eq 14393) {$OSMedia.ReleaseId = 1607}
            if ($($OSMedia.Build) -eq 15063) {$OSMedia.ReleaseId = 1703}
            if ($($OSMedia.Build) -eq 16299) {$OSMedia.ReleaseId = 1709}
            if ($($OSMedia.Build) -eq 17134) {$OSMedia.ReleaseId = 1803}
            if ($($OSMedia.Build) -eq 17763) {$OSMedia.ReleaseId = 1809}
            #if ($($OSMedia.Build) -eq 18362) {$OSMedia.ReleaseId = 1903}
            #if ($($OSMedia.Build) -eq 18363) {$OSMedia.ReleaseId = 1909}
            #if ($($OSMedia.Build) -eq 19041) {$OSMedia.ReleaseId = 2004}
            #if ($($OSMedia.Build) -eq 19042) {$OSMedia.ReleaseId = '20H2'}
            #if ($($OSMedia.Build) -eq 19043) {$OSMedia.ReleaseId = '21H1'}
            #if ($($OSMedia.Build) -eq 19043) {$OSMedia.ReleaseId = '21H2'}
        }
        #=================================================
        Write-Host '========================================================================================' -ForegroundColor DarkGray
        #=================================================
        #   Validate-ContentPacks
        #=================================================
        Write-Host "ContentPacks" -ForegroundColor Green
        if ($ExistingTask.ContentPacks) {
            foreach ($Item in $ExistingTask.ContentPacks) {
                Write-Host "$Item" -ForegroundColor DarkGray
            }
        }
        $ContentPacks = $null
        if ($AddContentPacks.IsPresent) {
            if (Get-IsContentPacksEnabled) {
                [array]$ContentPacks = (Get-TaskContentPacks).Name
            
                $ContentPacks = [array]$ContentPacks + [array]$ExistingTask.ContentPacks
                $ContentPacks = $ContentPacks | Sort-Object -Unique
            } else {
                Write-Warning "ContentPacks are not enabled for this OSBuild Task"
            }
        } else {
            if ($ExistingTask.ContentPacks) {$ContentPacks = $ExistingTask.ContentPacks}
        }
        #=================================================
        #   Content WinPEDaRT
        #=================================================
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
        #=================================================
        #   ContentIsoExtract
        #=================================================
        if ($ContentWinPEADK.IsPresent) {
            Write-Warning "Generating IsoExtract Content ... This may take a while"
            $ContentIsoExtract = @()
            [array]$ContentIsoExtract = Get-TaskContentIsoExtract

            $ContentIsoExtractWinPE = @()
            $ContentIsoExtractWinPE = $ContentIsoExtract | Where-Object {$_.FullName -like "*Windows Preinstallation Environment*"}
        }
        #=================================================
        #   WinPEADK
        #=================================================
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
        #=================================================
        #   WinPEDrivers
        #=================================================
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
        #=================================================
        #   WinPEExtraFiles
        #=================================================
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
        #=================================================
        #   WinPEScripts
        #=================================================
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
        #=================================================
        #   Parameters
        #=================================================
        if (!($CustomName) -and $ExistingTask.CustomName) {$CustomName = $ExistingTask.CustomName}
        if (!($MDTDeploymentShare) -and $ExistingTask.MDTDeploymentShare) {$MDTDeploymentShare = $ExistingTask.MDTDeploymentShare}
        if (!($ScratchSpace) -and $ExistingTask.ScratchSpace) {$ScratchSpace = $ExistingTask.ScratchSpace}
        if ($ExistingTask.WinPEAutoExtraFiles -eq $true) {$WinPEAutoExtraFiles = $true}
        #=================================================
        #   PEBuildTask
        #=================================================
        $Task = [ordered]@{
            "TaskType" = [string]'PEBuild';
            "TaskVersion" = [string]$global:GetOSDBuilder.VersionOSDBuilder;
            "TaskGuid" = [string]$(New-Guid);

            "TaskName" = [string]$TaskName;
            "CustomName" = [string]$CustomName;
            #=================================================
            #   ContentPacks
            #=================================================
            "ContentPacks" = [string[]]$ContentPacks;
            #=================================================
            #   OSMedia
            #=================================================
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
            #=================================================
            #   String
            #=================================================
            "WinPEOutput" = [string]$WinPEOutput;
            "SourceWim" = [string]$SourceWim;
            "MDTDeploymentShare" = [string]$MDTDeploymentShare;
            "WinPEDaRT" = [string]$WinPEDaRT;
            "ScratchSpace" = [string]$ScratchSpace;
            #=================================================
            #   Switch
            #=================================================
            "WinPEAutoExtraFiles" = [string]$WinPEAutoExtraFiles;
            #=================================================
            #   Array
            #=================================================
            "WinPEADK" = [string[]]$WinPEADK;
            "WinPEDrivers" = [string[]]$WinPEDrivers;
            "WinPEExtraFiles" = [string[]]$WinPEExtraFiles;
            "WinPEScripts" = [string[]]$WinPEScripts;
        }

        #=================================================
        #   Task Complete
        #=================================================
        Write-Host '========================================================================================' -ForegroundColor DarkGray
        Write-Host "PEBuild Task: $TaskName" -ForegroundColor Green
        $Task | ConvertTo-Json | Out-File "$TaskPath"
        $Task
    }
    
    End {
        #Write-Host '========================================================================================' -ForegroundColor DarkGray
        #Write-Host -ForegroundColor Green "$($MyInvocation.MyCommand.Name) END"
    }
}