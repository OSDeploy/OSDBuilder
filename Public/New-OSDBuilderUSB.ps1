<#
.SYNOPSIS
Creates a bootable USB of any OSDBuilder Media

.DESCRIPTION
Creates a bootable USB of any OSDBuilder Media (OSMedia, OSBuilds, PEBuilds)

.LINK
https://osdbuilder.osdeploy.com/module/functions/new-osdbuilderusb

.PARAMETER FullName
Full Path of the OSDBuilder Media

.PARAMETER USBLabel
Label for the USB Drive
#>
function New-OSDBuilderUSB {
    [CmdletBinding()]
    Param (
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$FullName,
        
        [ValidateLength(1,11)]
        [string]$USBLabel
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
        #   Gather all OSMedia OSBuilds PEBuilds
        #===================================================================================================
        $AllMyOSMedia = @()
        $AllMyOSMedia = Get-OSMedia

        $AllMyOSBuilds = @()
        $AllMyOSBuilds = Get-OSBuilds

        $AllMyPEBuilds = @()
        $AllMyPEBuilds = Get-PEBuilds

        $AllMyOSDBMedia = @()
        $AllMyOSDBMedia = [array]$AllMyOSMedia + [array]$AllMyOSBuilds + [array]$AllMyPEBuilds
    }

    PROCESS {
        Write-Host '========================================================================================' -ForegroundColor DarkGray
        Write-Host -ForegroundColor Green "$($MyInvocation.MyCommand.Name) PROCESS"

        Write-Warning "USB will be formatted FAT32"
        Write-Warning "Install.wim larger than 4GB will be split into 4GB split wim files"

        #===================================================================================================
        Write-Verbose '19.1.14 Select Source OSMedia'
        #===================================================================================================
        $SelectedOSMedia = @()

        if ($FullName) {
            foreach ($Item in $FullName) {
                Write-Verbose "Checking $Item"
                $SelectedOSMedia += $AllMyOSDBMedia | Where-Object {$_.FullName -eq $Item}
            }
        } else {
            $SelectedOSMedia = $AllMyOSDBMedia | Out-GridView -Title "OSDBuilder: Select one OSMedia to create an USB and press OK (Cancel to Exit)" -OutputMode Single
        }

        #===================================================================================================
        Write-Verbose '19.1.1 Select USB Drive'
        #===================================================================================================
        if (!($USBLabel)) {
            $USBLabel = 'OSDBuilder'
        }
        $Results = Get-Disk | Where-Object {$_.Size/1GB -lt 33 -and $_.BusType -eq 'USB'} | Out-GridView -Title 'OSDBuilder: Select a USB Drive to FORMAT' -OutputMode Single | Clear-Disk -RemoveData -RemoveOEM -Confirm:$false -PassThru | New-Partition -UseMaximumSize -IsActive -AssignDriveLetter | Format-Volume -FileSystem FAT32 -NewFileSystemLabel $USBLabel

        if ($null -eq $Results) {
            Write-Warning "No USB Drive was Found or Selected"
            Return
        } else {
            #Make Bootable
            Set-Location -Path "$($SelectedOSMedia.FullName)\OS\boot"
            bootsect.exe /nt60 "$($Results.DriveLetter):"

            #Hashtable of copy arguments for splatting
            $copyArgs = @{
                Path = "$($SelectedOSMedia.FullName)\OS\*"
                Destination = "$($Results.DriveLetter):"
                Recurse = $true
                Verbose = $true
            }

            #Test install.wim size and exculde install.wim from copy and split if more then 4GB in size
            $installWIM = Get-Item -Path "$($SelectedOSMedia.FullName)\OS\sources\install.wim"
            $split = $false
            if ($installWIM.Length/1GB -gt 4) {
                $copyArgs.Add("Exclude", "install.wim")
                Split-WindowsImage -ImagePath $installWIM.FullName -SplitImagePath $($installWIM.FullName -replace ".wim",".swm") -FileSize 4096 -CheckIntegrity
                $split = $true
            }

            #Copy Files from ISO to USB
            Copy-Item @copyArgs

            #Cleanup Split Wim files
            if ($split) {
                Get-ChildItem -Path "$($SelectedOSMedia.FullName)\OS\sources\*" -Include install*.swm | Remove-Item -Force -Confirm:$false -Verbose
            }
        }
    }

    END {
        #Write-Host '========================================================================================' -ForegroundColor DarkGray
        #Write-Host -ForegroundColor Green "$($MyInvocation.MyCommand.Name) END"
    }
}
