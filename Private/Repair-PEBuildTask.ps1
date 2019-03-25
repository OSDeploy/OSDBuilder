<#
.SYNOPSIS
Updates PEBuild Tasks to the latest version

.DESCRIPTION
Updates PEBuild Tasks to the latest version

.LINK
http://osdbuilder.com/docs/functions/maintenance/repair-pebuildtask

#>
function Repair-PEBuildTask {
    [CmdletBinding()]
    PARAM ()
    BEGIN {
        #Write-Host '========================================================================================' -ForegroundColor DarkGray
        #Write-Host "$($MyInvocation.MyCommand.Name) BEGIN" -ForegroundColor Green

        #===================================================================================================
        Write-Verbose '19.1.1 Initialize OSDBuilder'
        #===================================================================================================
        Get-OSDBuilder -CreatePaths -HideDetails

        #===================================================================================================
        Write-Verbose '19.1.6 Gather All PEBuildTask'
        #===================================================================================================
        $PEBuildTask = @()
        $PEBuildTask = Get-PEBuildTask | Where-Object {$null -eq $_.OSMGuid}
    }
    
    PROCESS {
        #Write-Host '========================================================================================' -ForegroundColor DarkGray
        Write-Host "$($MyInvocation.MyCommand.Name) PROCESS" -ForegroundColor Green

        foreach ($Item in $PEBuildTask) {
            $TaskFile = Get-Item -Path "$($Item.FullName)" | Select-Object -Property *
            Write-Warning "Repair Required: $($Item.FullName)"

            #===================================================================================================
            Write-Verbose 'Read Task'
            #===================================================================================================
            $Task = @()
            $Task = Get-Content "$($Item.FullName)" | ConvertFrom-Json

            if ([System.Version]$Task.TaskVersion -gt [System.Version]"19.1.3.0") {
                Write-Warning "Error: PEBuild Task does not need a Repair . . . Exiting!"
                Return
            }
    
            Write-Host "Select the OSMedia that will be used with this PEBuild Task"
            Write-Host "Previous OSMedia: $($Task.MediaName)"
            $OSMedia = Get-OSMedia
            
            if ($Task.MediaName -like "*x64*") {$OSMedia = $OSMedia | Where-Object {$_.Arch -eq 'x64'}}
            if ($Task.MediaName -like "*x86*") {$OSMedia = $OSMedia | Where-Object {$_.Arch -eq 'x86'}}
            if ($Task.MediaName -like "*1511*") {$OSMedia = $OSMedia | Where-Object {$_.ReleaseId -eq '1511'}}
            if ($Task.MediaName -like "*1607*") {$OSMedia = $OSMedia | Where-Object {$_.ReleaseId -eq '1607'}}
            if ($Task.MediaName -like "*1703*") {$OSMedia = $OSMedia | Where-Object {$_.ReleaseId -eq '1703'}}
            if ($Task.MediaName -like "*1709*") {$OSMedia = $OSMedia | Where-Object {$_.ReleaseId -eq '1709'}}
            if ($Task.MediaName -like "*1803*") {$OSMedia = $OSMedia | Where-Object {$_.ReleaseId -eq '1803'}}
            if ($Task.MediaName -like "*1809*") {$OSMedia = $OSMedia | Where-Object {$_.ReleaseId -eq '1809'}}

            $OSMedia = $OSMedia | Out-GridView -OutputMode Single -Title "$($Task.TaskName): Select the OSMedia used with this PEBuild Task"
    
            if ($null -eq $OSMedia) {
                Write-Warning "Error: OSMedia was not selected . . . Exiting!"
                Return
            }

            Write-Host "Selected $($OSMedia.Name)"

            #===================================================================================================
            Write-Verbose '19.1.5 Create PEBuild Task'
            #===================================================================================================
            $NewTask = [ordered]@{
                "TaskType" = 'PEBuild'
                "TaskName" = [string]$Task.TaskName;
                "TaskVersion" = [string]$OSDBuilderVersion;
                "TaskGuid" = [string]$(New-Guid);
    
                "OSMFamily" = [string]$OSMedia.OSMFamily;
                "OSMGuid" = [string]$OSMedia.OSMGuid;
                "Name" = [string]$OSMedia.Name;
                "ImageName" = [string]$OSMedia.ImageName;
                "Arch" = [string]$OSMedia.Arch;
                "ReleaseId" = [string]$($OSMedia.ReleaseId);
                "UBR" = [string]$OSMedia.UBR;
                "EditionId" = [string]$OSMedia.EditionId;
                "InstallationType" = [string]$OSMedia.InstallationType;
                "MajorVersion" = [string]$OSMedia.MajorVersion;
                "Build" = [string]$OSMedia.Build;
                "CreatedTime" = [datetime]$OSMedia.CreatedTime;
                "ModifiedTime" = [datetime]$OSMedia.ModifiedTime;

                "WinPEOutput" = [string]$Task.PEOutput;
                "CustomName" = [string]'';
                "MDTDeploymentShare" = [string]$Task.DeploymentShare;
                "ScratchSpace" = [string]$Task.ScratchSpace;
                "SourceWim" = [string]$Task.SourceWim;
                "WinPEAutoExtraFiles" = [string]$Task.AutoExtraFiles;
                "WinPEDaRT" = [string]$Task.WinPEAddDaRT;
                "WinPEDrivers" = [string[]]$Task.WinPEAddWindowsDriver;
                "WinPEExtraFiles" = [string[]]$Task.WinPERobocopyExtraFiles;
                "WinPEScripts" = [string[]]$Task.WinPEInvokeScript;
                "WinPEADK" = [string[]]$Task.WinPEAddADK;
            }
    
            #===================================================================================================
            Write-Verbose '19.1.7 Create Backup'
            #===================================================================================================
            if (!(Test-Path "$($TaskFile.Directory)\Repair")) {
                New-Item -Path "$($TaskFile.Directory)\Repair"-ItemType Directory -Force | Out-Null
            }

            if (!(Test-Path "$($TaskFile.Directory)\Repair\$($TaskFile.Name)")) {
                Write-Host "Creating Backup $($TaskFile.Directory)\Repair\$($TaskFile.Name)"
                Copy-Item -Path "$($TaskFile.FullName)" -Destination "$($TaskFile.Directory)\Repair\$($TaskFile.Name)" -Force
            }
            
            #===================================================================================================
            Write-Verbose '19.1.7 New-PEBuildTask Complete'
            #===================================================================================================
            $NewTask | ConvertTo-Json | Out-File "$($Item.FullName)" -Encoding ascii
            Write-Host "Update Complete: $($Task.TaskName)" -ForegroundColor Green
            Write-Host '========================================================================================' -ForegroundColor DarkGray
        }
    }

    END {
        #Write-Host '========================================================================================' -ForegroundColor DarkGray
        #Write-Host "$($MyInvocation.MyCommand.Name) END" -ForegroundColor Green
    }
}