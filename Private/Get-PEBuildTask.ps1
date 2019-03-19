function Get-PEBuildTask {
    [CmdletBinding()]
    PARAM (
        [switch]$GridView
    )

    BEGIN {
        #Write-Host '========================================================================================' -ForegroundColor DarkGray
        #Write-Host "$($MyInvocation.MyCommand.Name) BEGIN" -ForegroundColor Green

        #===================================================================================================
        Write-Verbose '19.1.1 Initialize OSDBuilder'
        #===================================================================================================
        Get-OSDBuilder -CreatePaths -HideDetails

        #===================================================================================================
        Write-Verbose '19.1.1 Gather All PEBuildTask'
        #===================================================================================================
        $AllPEBuildTasks = @()
        $AllPEBuildTasks = Get-ChildItem -Path "$OSDBuilderTasks" *.json -File | Select-Object -Property *
        $AllPEBuildTasks = $AllPEBuildTasks | Where-Object {$_.Name -like "MDT*" -or $_.Name -like "Recovery*" -or $_.Name -like "WinPE*"}
    }

    PROCESS {
        #Write-Host '========================================================================================' -ForegroundColor DarkGray
        #Write-Host "$($MyInvocation.MyCommand.Name) PROCESS" -ForegroundColor Green

        $PEBuildTask = foreach ($Item in $AllPEBuildTasks) {
            #===================================================================================================
            #Write-Verbose '19.1.1 Get Windows Image Information'
            #===================================================================================================
            $PEBuildTaskPath = $($Item.FullName)
            Write-Verbose "PEBuildTask Full Path: $PEBuildTaskPath"
            
            $PEBTask = @()
            $PEBTask = Get-Content "$($Item.FullName)" | ConvertFrom-Json

            $PEBTaskProps = @()
            $PEBTaskProps = Get-Item "$($Item.FullName)" | Select-Object -Property *
            
            if ([System.Version]$PEBTask.TaskVersion -lt [System.Version]"19.1.3.0") {
                $ObjectProperties = @{
                    LastWriteTime       = $PEBTaskProps.LastWriteTime
                    TaskName            = $PEBTask.TaskName
                    TaskVersion         = $PEBTask.TaskVersion
                    Name                = $PEBTask.MediaName
                    FullName            = $Item.FullName
                }
                New-Object -TypeName PSObject -Property $ObjectProperties
                Write-Verbose ""
            }

            if ([System.Version]$PEBTask.TaskVersion -gt [System.Version]"19.1.3.0") {

                if ($null -eq $PEBTask.Languages) {
                    Write-Warning "Reading Task: $PEBuildTaskPath"
                    Write-Warning "Searching for OSMFamily: $($PEBTask.OSMFamily)"
                    $LangUpdate = Get-OSMedia | Where-Object {$_.OSMFamilyV1 -eq $PEBTask.OSMFamily} | Select-Object -Last 1
                    Write-Warning "Adding Language: $($LangUpdate.Languages)"
                    $PEBTask | Add-Member -Type NoteProperty -Name 'Languages' -Value "$LangUpdate.Languages"
                    $PEBTask.Languages = $LangUpdate.Languages
                    $PEBTask.OSMFamily = $PEBTask.InstallationType + " " + $PEBTask.EditionId + " " + $PEBTask.Arch + " " + [string]$PEBTask.Build + " " + $PEBTask.Languages
                    Write-Warning "Updating OSMFamily: $($PEBTask.OSMFamily)"
                    Write-Warning "Updating Task: $PEBuildTaskPath"
                    $PEBTask | ConvertTo-Json | Out-File $PEBuildTaskPath
                    Write-Host ""
                }

                $ObjectProperties = @{
                    TaskType            = $PEBTask.TaskType
                    TaskVersion         = $PEBTask.TaskVersion
                    TaskName            = $PEBTask.TaskName
                    TaskGuid            = $PEBTask.TaskGuid
                    CustomName          = $PEBTask.CustomName
                    SourceOSMedia       = $PEBTask.Name
                    ImageName           = $PEBTask.ImageName
                    Arch                = $PEBTask.Arch
                    ReleaseId           = $PEBTask.ReleaseId
                    UBR                 = $PEBTask.UBR
                    EditionId           = $PEBTask.EditionId
                    FullName            = $Item.FullName
                    LastWriteTime       = $PEBTaskProps.LastWriteTime
                    CreatedTime         = [datetime]$PEBTask.CreatedTime
                    ModifiedTime        = [datetime]$PEBTask.ModifiedTime
                    OSMFamily           = $PEBTask.OSMFamily
                    OSMGuid             = $PEBTask.OSMGuid
                }
                New-Object -TypeName PSObject -Property $ObjectProperties
                Write-Verbose ""
            }
        }

        #===================================================================================================
        #Write-Verbose '19.1.3 Output'
        #===================================================================================================
        if ($GridView.IsPresent) {$PEBuildTask | Select-Object TaskType,TaskVersion,TaskName,CustomName,SourceOSMedia,ImageName,Arch,ReleaseId,UBR,EditionId,FullName,LastWriteTime,OSMFamily,OSMGuid | Sort-Object TaskName | Out-GridView -PassThru -Title 'PEBuildTask'}
        else {$PEBuildTask | Select-Object TaskType,TaskVersion,TaskName,CustomName,SourceOSMedia,ImageName,Arch,ReleaseId,UBR,EditionId,FullName,LastWriteTime,OSMFamily,OSMGuid | Sort-Object TaskName }
    }

    END {
        #Write-Host '========================================================================================' -ForegroundColor DarkGray
        #Write-Host "$($MyInvocation.MyCommand.Name) END" -ForegroundColor Green
    }
}