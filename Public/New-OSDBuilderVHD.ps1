<#
.SYNOPSIS
Creates an VHD of any OSMedia or OSBuild

.DESCRIPTION
Creates an VHD of any OSMedia or OSBuild

.LINK
https://osdbuilder.osdeploy.com/module/functions/new-osdbuildervhd

.PARAMETER FullName
Full Path of the OSDBuilder Media.  If omitted, GridView will prompt for selection

.PARAMETER OSDriveLabel
Drive Label for the OS Partition.  Default is OSDisk

.PARAMETER VHDSizeGB
Size of the VHD in GB.  Default is 50

.NOTES
Requested by Bruce Sa @BruceSaaaa and Alan Yousif @Green17Mr
Thanks to Bruce Sa for testing
Thanks to Mikael Nystrom for this post
https://deploymentbunny.com/2013/12/19/powershell-is-king-convert-wim-to-vhdvhdx-with-support-for-gen-1-and-gen-2-biosuefi-and-then-some/

#>
function New-OSDBuilderVHD {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$FullName,
        [string]$OSDriveLabel = 'OSDisk',
        [int32]$VHDSizeGB = 50,
        [switch]$IncludeRecoveryPartition
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
        #   Require HyperV Module for VHD Cmdlets
        #=================================================
        if (!(Get-Module -ListAvailable -Name Hyper-V)) {
            Write-Warning "New-OSDBuilderVHD requires PowerShell Module HyperV"
            Break
        }

        #=================================================
        #   Gather All OS Media
        #=================================================
        $AllMyOSDMedia = @()
        [array]$AllMyOSDMedia = [array](Get-OSMedia) + [array](Get-OSBuilds)
    }

    Process {
        Write-Host '========================================================================================' -ForegroundColor DarkGray
        Write-Host -ForegroundColor Green "$($MyInvocation.MyCommand.Name) PROCESS"
        #=================================================
        #   Select Source OSMedia
        #=================================================
        $SelectedOSDMedia = @()

        if ($FullName) {
            foreach ($Item in $FullName) {
                Write-Verbose "Checking $Item"
                $SelectedOSDMedia += $AllMyOSDMedia | Where-Object {$_.FullName -eq $Item}
            }
        } else {
            $SelectedOSDMedia = $AllMyOSDMedia | Out-GridView -Title "OSDBuilder: Select one OSMedia to create an VHD and press OK (Cancel to Exit)" -OutputMode Single
        }
        if ($null -eq $SelectedOSDMedia) {
            Write-Warning "OSDBuilder Media was not selected or found . . . Exiting!"
            Return
        }
        #=================================================
        #   VHD Build
        #=================================================
        $VhdOSMedia = $SelectedOSDMedia.FullName
        $VhdSize = $VHDSizeGB*1024*1024*1024
        if ($SelectedOSDMedia.MajorVersion -eq 10) {
            $PartitionStyle = 'GPT'
            $VhdFile = "$VhdOSMedia\VHD\OSDBuilder.vhdx"
        } else {
            $PartitionStyle = 'MBR'
            $VhdFile = "$VhdOSMedia\VHD\OSDBuilder.vhd"
        }
        
        $VhdInstallWim = "$VhdOSMedia\OS\Sources\Install.wim"

        Write-Host '========================================================================================' -ForegroundColor DarkGray
        Write-Host "VHD Details" -ForegroundColor Green
        Write-Host "-VHD OSMedia:           $VhdOSMedia"
        Write-Host "-VHD File:              $VhdFile"
        Write-Host "-VHD Type:              Dynamic"
        Write-Host "-VHD PartitionStyle:    $PartitionStyle"
        Write-Host "-VHD Size in GB:        $VHDSizeGB"
        Write-Host "-VHD WIM:               $VhdInstallWim"

        Write-Host '========================================================================================' -ForegroundColor DarkGray
        Write-Host "Creating $VhdFile" -ForegroundColor Green
        if (Test-Path $VhdFile) {
            Write-Warning "$VhdFile exists and will be deleted"
            Remove-Item $VhdFile -Force | Out-Null
        }
        New-VHD -Path $VhdFile -Dynamic -SizeBytes $VhdSize | Out-Null

        Write-Host '========================================================================================' -ForegroundColor DarkGray
        Write-Host "Mount-DiskImage -ImagePath $VhdFile" -ForegroundColor Green
        Mount-DiskImage -ImagePath $VhdFile | Out-Null

        Write-Host '========================================================================================' -ForegroundColor DarkGray
        Write-Host "Get-DiskImage -ImagePath $VhdFile" -ForegroundColor Green
        $VhdDisk = Get-DiskImage -ImagePath $VhdFile | Get-Disk
        $DiskNumber = [string]$VhdDisk.Number

        Write-Host '========================================================================================' -ForegroundColor DarkGray
        Write-Host "Initialize-Disk -Number $DiskNumber -PartitionStyle $PartitionStyle" -ForegroundColor Green
        Initialize-Disk -Number $DiskNumber -PartitionStyle $PartitionStyle

        #=================================================
        #   MBR
        #=================================================
        if ($PartitionStyle -eq 'MBR') {
            Write-Host '========================================================================================' -ForegroundColor DarkGray
            Write-Host "New-Partition -DiskNumber $DiskNumber -UseMaximumSize -IsActive" -ForegroundColor Green
            $VhdDrive = New-Partition -DiskNumber $DiskNumber -UseMaximumSize -IsActive
    
            Write-Host '========================================================================================' -ForegroundColor DarkGray
            Write-Host "Format-Volume -FileSystem NTFS -NewFileSystemLabel $OSDriveLabel" -ForegroundColor Green
            $VhdDrive | Format-Volume -FileSystem NTFS -NewFileSystemLabel $OSDriveLabel -Confirm:$false | Out-Null

            Write-Host '========================================================================================' -ForegroundColor DarkGray
            Write-Host "Add-PartitionAccessPath -DiskNumber $DiskNumber -PartitionNumber $VhdDrive.PartitionNumber -AssignDriveLetter" -ForegroundColor Green
            Add-PartitionAccessPath -DiskNumber $DiskNumber -PartitionNumber $VhdDrive.PartitionNumber -AssignDriveLetter
            $VhdDrive = Get-Partition -DiskNumber $DiskNumber -PartitionNumber $VhdDrive.PartitionNumber
            $VhdVolume = [string]$VhdDrive.DriveLetter+":"

            Write-Host '========================================================================================' -ForegroundColor DarkGray
            Write-Host "Expand-WindowsImage -ImagePath $VhdInstallWim -Index 1 -ApplyPath $VhdVolume\" -ForegroundColor Green
            Try { Expand-WindowsImage -ImagePath $VhdInstallWim -Index 1 -ApplyPath $VhdVolume\ -ErrorAction Stop | Out-Null }
            Catch { $ErrorMessage = $_.Exception.Message }

            Write-Host '========================================================================================' -ForegroundColor DarkGray
            Write-Host "$VhdVolume\Windows\system32\bcdboot $VhdVolume\Windows /s $VhdVolume" -ForegroundColor Green
            cmd /c "$VhdVolume\Windows\system32\bcdboot $VhdVolume\Windows /s $VhdVolume"
        }

        #=================================================
        #   GPT
        #=================================================
        if ($PartitionStyle -eq 'GPT') {
            Write-Host '========================================================================================' -ForegroundColor DarkGray
            Write-Host "Creating System Partition 200MB FAT32" -ForegroundColor Green
            $PartitionSystem = New-Partition -DiskNumber $DiskNumber -GptType '{ebd0a0a2-b9e5-4433-87c0-68b6b72699c7}' -Size 200MB
            $PartitionSystem | Format-Volume -FileSystem FAT32 -NewFileSystemLabel System -Confirm:$false | Out-Null
            Add-PartitionAccessPath -DiskNumber $DiskNumber -PartitionNumber $PartitionSystem.PartitionNumber -AssignDriveLetter
            $PartitionSystem = Get-Partition -DiskNumber $DiskNumber -PartitionNumber $PartitionSystem.PartitionNumber
            $PartitionSystemVolume = [string]$PartitionSystem.DriveLetter+":"

            Write-Host '========================================================================================' -ForegroundColor DarkGray
            Write-Host "Creating MSR Partition 128MB" -ForegroundColor Green
            $PartitionMSR = New-Partition -DiskNumber $DiskNumber -GptType '{e3c9e316-0b5c-4db8-817d-f92df00215ae}' -Size 128MB

            Write-Host '========================================================================================' -ForegroundColor DarkGray
            Write-Host "Creating $OSDriveLabel Partition NTFS" -ForegroundColor Green
            $PartitionOS = New-Partition -DiskNumber $DiskNumber -GptType '{ebd0a0a2-b9e5-4433-87c0-68b6b72699c7}' -UseMaximumSize
            $PartitionOSSize = (Get-PartitionSupportedSize -DiskNumber $DiskNumber -PartitionNumber $PartitionOS.PartitionNumber)
            Resize-Partition -DiskNumber $DiskNumber -PartitionNumber $PartitionOS.PartitionNumber -Size ($PartitionOSSize.SizeMax - 984MB)
            $PartitionOS | Format-Volume -FileSystem NTFS -NewFileSystemLabel $OSDriveLabel -Confirm:$false | Out-Null
            Add-PartitionAccessPath -DiskNumber $DiskNumber -PartitionNumber $PartitionOS.PartitionNumber -AssignDriveLetter
            $PartitionOS = Get-Partition -DiskNumber $DiskNumber -PartitionNumber $PartitionOS.PartitionNumber
            $PartitionOSVolume = [string]$PartitionOS.DriveLetter+":"
            If($IncludeRecoveryPartition){
                Write-Host '========================================================================================' -ForegroundColor DarkGray
                Write-Host "Creating Recovery Partition 984MB NTFS" -ForegroundColor Green
                $PartitionRecovery = New-Partition -DiskNumber $DiskNumber -GptType '{de94bba4-06d1-4d40-a16a-bfd50179d6ac}' -UseMaximumSize
                $PartitionRecovery | Format-Volume -FileSystem NTFS -NewFileSystemLabel Recovery -Confirm:$false | Out-Null
            }
            Write-Host '========================================================================================' -ForegroundColor DarkGray
            Write-Host "Expand-WindowsImage -ImagePath $VhdInstallWim -Index 1 -ApplyPath $PartitionOSVolume\" -ForegroundColor Green
            Try { Expand-WindowsImage -ImagePath $VhdInstallWim -Index 1 -ApplyPath $PartitionOSVolume\ -ErrorAction Stop | Out-Null }
            Catch { $ErrorMessage = $_.Exception.Message }

            Write-Host '========================================================================================' -ForegroundColor DarkGray
            Write-Host "$PartitionOSVolume\Windows\system32\bcdboot $PartitionOSVolume\Windows /s $PartitionSystemVolume /f ALL" -ForegroundColor Green
            cmd /c "$PartitionOSVolume\Windows\system32\bcdboot $PartitionOSVolume\Windows /s $PartitionSystemVolume /f ALL"

            Write-Host '========================================================================================' -ForegroundColor DarkGray
            Write-Host "Set Disk $DiskNumber Partition $($PartitionSystem.PartitionNumber) Set ID=c12a7328-f81f-11d2-ba4b-00a0c93ec93b OVERRIDE" -ForegroundColor Green
            #$PartitionSystem | Set-Partition –DiskNumber $DiskNumber –PartitionNumber $PartitionSystem.PartitionNumber –GptType '{c12a7328-f81f-11d2-ba4b-00a0c93ec93b}'
            $DiskPartTextFile = New-Item "$env:Temp\OSDBuilderVHD.txt" -Type File -Force
            Set-Content $DiskPartTextFile "Select Disk $DiskNumber"
            Add-Content $DiskPartTextFile "Select Partition $($PartitionSystem.PartitionNumber)"
            Add-Content $DiskPartTextFile "Set ID=c12a7328-f81f-11d2-ba4b-00a0c93ec93b OVERRIDE"
            Add-Content $DiskPartTextFile "GPT Attributes=0x8000000000000000"
            cmd /c "diskpart.exe /s $env:Temp\OSDBuilderVHD.txt"
        }
        Write-Host '========================================================================================' -ForegroundColor DarkGray
        Write-Host "Dismount-DiskImage -ImagePath $VhdFile" -ForegroundColor Green
        Dismount-DiskImage -ImagePath $VhdFile | Out-Null
    }

    End {
        Write-Host '========================================================================================' -ForegroundColor DarkGray
        Write-Host -ForegroundColor Green "$($MyInvocation.MyCommand.Name) END"
        Write-Host '========================================================================================' -ForegroundColor DarkGray
    }
}