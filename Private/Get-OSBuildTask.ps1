function Get-OSBuildTask {
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
        Write-Verbose '19.4.3 Gather All OSBuildTask'
        #===================================================================================================
        $AllOSBuildTasks = @()
        $AllOSBuildTasks = Get-ChildItem -Path "$OSDBuilderTasks" OSBuild*.json -File | Select-Object -Property *
        $AllOSBuildTasks = $AllOSBuildTasks | Where-Object {$_.Name -notlike "*Merged Last Run*"}
        #===================================================================================================
    }

    PROCESS {
        #Write-Host '========================================================================================' -ForegroundColor DarkGray
        #Write-Host "$($MyInvocation.MyCommand.Name) PROCESS" -ForegroundColor Green

        $OSBuildTask = foreach ($Item in $AllOSBuildTasks) {
            #===================================================================================================
            #Write-Verbose '19.1.1 Get Windows Image Information'
            #===================================================================================================
            $OSBuildTaskPath = $($Item.FullName)
            Write-Verbose "OSBuildTask Full Path: $OSBuildTaskPath"
            $OSBTask = @()
            $OSBTask = Get-Content "$($Item.FullName)" | ConvertFrom-Json

            $OSBTaskProps = @()
            $OSBTaskProps = Get-Item "$($Item.FullName)" | Select-Object -Property *
            
            if ([System.Version]$OSBTask.TaskVersion -lt [System.Version]"19.1.3.0") {
                $ObjectProperties = @{
                    LastWriteTime       = $OSBTaskProps.LastWriteTime
                    TaskName            = $OSBTask.TaskName
                    TaskVersion         = $OSBTask.TaskVersion
                    OSMediaName         = $OSBTask.MediaName
                    FullName            = $Item.FullName
                }
                New-Object -TypeName PSObject -Property $ObjectProperties
                Write-Verbose ""
            }

            if ([System.Version]$OSBTask.TaskVersion -gt [System.Version]"19.1.3.0") {

                if ($null -eq $OSBTask.Languages) {
                    Write-Warning "Reading Task: $OSBuildTaskPath"
                    Write-Warning "Searching for OSMFamily: $($OSBTask.OSMFamily)"
                    $LangUpdate = Get-OSMedia | Where-Object {$_.OSMFamilyV1 -eq $OSBTask.OSMFamily} | Select-Object -Last 1
                    Write-Warning "Adding Language: $($LangUpdate.Languages)"
                    $OSBTask | Add-Member -Type NoteProperty -Name 'Languages' -Value "$LangUpdate.Languages"
                    $OSBTask.Languages = $LangUpdate.Languages
                    $OSBTask.OSMFamily = $OSBTask.InstallationType + " " + $OSBTask.EditionId + " " + $OSBTask.Arch + " " + [string]$OSBTask.Build + " " + $OSBTask.Languages
                    Write-Warning "Updating OSMFamily: $($OSBTask.OSMFamily)"
                    Write-Warning "Updating Task: $OSBuildTaskPath"
                    $OSBTask | ConvertTo-Json | Out-File $OSBuildTaskPath
                    Write-Host ""
                }

                $ObjectProperties = @{
                    TaskType            = $OSBTask.TaskType
                    TaskVersion         = $OSBTask.TaskVersion
                    TaskName            = $OSBTask.TaskName
                    TaskGuid            = $OSBTask.TaskGuid
                    CustomName          = $OSBTask.CustomName
                    SourceOSMedia       = $OSBTask.Name
                    ImageName           = $OSBTask.ImageName
                    Arch                = $OSBTask.Arch
                    ReleaseId           = $OSBTask.ReleaseId
                    UBR                 = $OSBTask.UBR
                    Languages           = $OSBTask.Languages
                    EditionId           = $OSBTask.EditionId
                    FullName            = $Item.FullName
                    LastWriteTime       = $OSBTaskProps.LastWriteTime
                    CreatedTime         = [datetime]$OSBTask.CreatedTime
                    ModifiedTime        = [datetime]$OSBTask.ModifiedTime
                    OSMFamily           = $OSBTask.OSMFamily
                    OSMGuid             = $OSBTask.OSMGuid
                }
                New-Object -TypeName PSObject -Property $ObjectProperties
                Write-Verbose ""
            }
        }

        #===================================================================================================
        #Write-Verbose '19.1.3 Output'
        #===================================================================================================
        if ($GridView.IsPresent) {$OSBuildTask | Select-Object TaskType,TaskVersion,TaskName,CustomName,SourceOSMedia,ImageName,Arch,ReleaseId,UBR,Languages,EditionId,FullName,LastWriteTime,OSMFamily,OSMGuid | Sort-Object TaskName | Out-GridView -PassThru -Title 'OSBuildTask'}
        else {$OSBuildTask | Select-Object TaskType,TaskVersion,TaskName,CustomName,SourceOSMedia,ImageName,Arch,ReleaseId,UBR,Languages,EditionId,FullName,LastWriteTime,OSMFamily,OSMGuid | Sort-Object TaskName }
    }

    END {
        #Write-Host '========================================================================================' -ForegroundColor DarkGray
        #Write-Host "$($MyInvocation.MyCommand.Name) END" -ForegroundColor Green
    }
}