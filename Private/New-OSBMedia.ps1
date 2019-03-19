function New-OSBMedia {
    [CmdletBinding()]
    PARAM (
        [Parameter(ValueFromPipelineByPropertyName)]
        [string[]]$FullName,
        [switch]$USB
    )

    BEGIN {
        #Write-Host '========================================================================================' -ForegroundColor DarkGray
        #Write-Host "$($MyInvocation.MyCommand.Name) BEGIN" -ForegroundColor Green

        #===================================================================================================
        Write-Verbose '19.1.1 Initialize OSDBuilder'
        #===================================================================================================
        Get-OSDBuilder -CreatePaths -HideDetails

        #===================================================================================================
        Write-Verbose '19.2.10 Gather All OS Media'
        #===================================================================================================
        $AllOSMedia = @()
        $AllOSMedia = $(Get-OSMedia)

        
        $AllOSBuild = @()
        $AllOSBuild = $(Get-OSBuild)

        
        $AllPEBuild = @()
        $AllPEBuild = $(Get-PEBuild)

        $AllOSBMedia = @()
        $AllOSBMedia = [array]$AllOSMedia + [array]$AllOSBuild + [array]$AllPEBuild

        if (!($USB.IsPresent)) {
            #===================================================================================================
            Write-Verbose '19.1.1 Locate OSCDIMG'
            #===================================================================================================
            if (Test-Path "$OSDBuilderContent\Tools\$env:PROCESSOR_ARCHITECTURE\Oscdimg\oscdimg.exe") {
                $oscdimg = "$OSDBuilderContent\Tools\$env:PROCESSOR_ARCHITECTURE\Oscdimg\oscdimg.exe"
            } elseif (Test-Path "C:\Program Files\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\$env:PROCESSOR_ARCHITECTURE\Oscdimg\oscdimg.exe") {
                $oscdimg = "C:\Program Files\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\$env:PROCESSOR_ARCHITECTURE\Oscdimg\oscdimg.exe"
            } elseif (Test-Path "C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\$env:PROCESSOR_ARCHITECTURE\Oscdimg\oscdimg.exe") {
                $oscdimg = "C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\$env:PROCESSOR_ARCHITECTURE\Oscdimg\oscdimg.exe"
            } else {
                Write-Host '========================================================================================' -ForegroundColor DarkGray
                Write-Warning "Could not locate OSCDIMG in Windows ADK at:"
                Write-Warning "${env:ProgramFiles(x86)}\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\amd64\Oscdimg\oscdimg.exe"
                Write-Warning "You can optionally copy OSCDIMG to:"
                Write-Warning "$OSDBuilderContent\Tools\$env:PROCESSOR_ARCHITECTURE\Oscdimg\oscdimg.exe"
                Break
            }
            Write-Verbose "OSCDIMG: $oscdimg"
        }

    }

    PROCESS {
        Write-Host '========================================================================================' -ForegroundColor DarkGray
        Write-Host "$($MyInvocation.MyCommand.Name) PROCESS" -ForegroundColor Green

        if ($USB.IsPresent) {
            Write-Warning "USB will be formatted FAT32"
            Write-Warning "Install.wim larger than 4GB will FAIL"
        }

        #===================================================================================================
        Write-Verbose '19.1.1 Select Source OSMedia'
        #===================================================================================================
        $SelectedOSMedia = @()

        if ($FullName) {
            foreach ($Item in $FullName) {
                Write-Verbose "Checking $Item"
                $SelectedOSMedia += $AllOSBMedia | Where-Object {$_.FullName -eq $Item}
            }
        } else {
            if ($USB.IsPresent) {
                $SelectedOSMedia = $AllOSBMedia | Out-GridView -Title "OSDBuilder: Select one Source to create a USB and press OK (Cancel to Exit)" -OutputMode Single
            } else {
                $SelectedOSMedia = $AllOSBMedia | Out-GridView -Title "OSDBuilder: Select one or more Sources to create an ISO and press OK (Cancel to Exit)" -PassThru
            }
        }

        if ($USB.IsPresent) {
            #===================================================================================================
            Write-Verbose '19.1.1 Select USB Drive'
            #===================================================================================================
            $Results = Get-Disk | Where-Object {$_.Size/1GB -lt 33 -and $_.BusType -eq 'USB'} | Out-GridView -Title 'OSDBuilder: Select a USB Drive to FORMAT' -OutputMode Single | Clear-Disk -RemoveData -RemoveOEM -Confirm:$false -PassThru | New-Partition -UseMaximumSize -IsActive -AssignDriveLetter | Format-Volume -FileSystem FAT32 -NewFileSystemLabel 'OSDBuilder'

            if ($null -eq $Results) {
                Write-Warning "No USB Drive was Found or Selected"
                Return
            } else {
                #Make Bootable
                Set-Location -Path "$($SelectedOSMedia.FullName)\OS\boot"
                bootsect.exe /nt60 "$($Results.DriveLetter):"

                #Copy Files from ISO to USB
                Copy-Item -Path "$($SelectedOSMedia.FullName)\OS\*" -Destination "$($Results.DriveLetter):" -Recurse -Verbose
            }
        } else {
            #===================================================================================================
            Write-Verbose '19.1.1 Process OSMedia'
            #===================================================================================================
            foreach ($Media in $SelectedOSMedia) {
                $ISOSourceFolder = "$($Media.FullName)\OS"
                $ISODestinationFolder = "$($Media.FullName)\ISO"
                if (!(Test-Path $ISODestinationFolder)) {New-Item $ISODestinationFolder -ItemType Directory -Force | Out-Null}
                #$ISOFile = "$ISODestinationFolder\$($Media.Name).iso"

                $WindowsImage = Get-Content -Path "$($Media.FullName)\info\json\Get-WindowsImage.json"
                $WindowsImage = $WindowsImage | ConvertFrom-Json

                $OSImageDescription = $($WindowsImage.ImageName)

                $OSArchitecture = $($WindowsImage.Architecture)
                if ($OSArchitecture -eq '0') {$OSArchitecture = 'x86'}
                if ($OSArchitecture -eq '6') {$OSArchitecture = 'ia64'}
                if ($OSArchitecture -eq '9') {$OSArchitecture = 'x64'}
                if ($OSArchitecture -eq '12') {$OSArchitecture = 'x64 ARM'}

                $UBR = $($WindowsImage.UBR)

                $OSImageName = $OSImageDescription
            
                $OSImageName = $OSImageName -replace "Microsoft Windows Recovery Environment", "WinPE"
                $OSImageName = $OSImageName -replace "Windows 10", "Win10"
                $OSImageName = $OSImageName -replace "Enterprise", "Ent"
                $OSImageName = $OSImageName -replace "Education", "Edu"
                $OSImageName = $OSImageName -replace "Virtual Desktops", "VD"
                $OSImageName = $OSImageName -replace " for ", " "
                $OSImageName = $OSImageName -replace "Workstations", "Wks"
                $OSImageName = $OSImageName -replace "Windows Server 2016", "Svr2016"
                $OSImageName = $OSImageName -replace "Windows Server 2019", "Svr2019"
                $OSImageName = $OSImageName -replace "ServerStandardACore", "Std Core"
                $OSImageName = $OSImageName -replace "ServerDatacenterACore", "DC Core"
                $OSImageName = $OSImageName -replace "ServerStandardCore", "Std Core"
                $OSImageName = $OSImageName -replace "ServerDatacenterCore", "DC Core"
                $OSImageName = $OSImageName -replace "ServerStandard", "Std"
                $OSImageName = $OSImageName -replace "ServerDatacenter", "DC"
                $OSImageName = $OSImageName -replace "Standard", "Std"
                $OSImageName = $OSImageName -replace "Datacenter", "DC"
                $OSImageName = $OSImageName -replace 'Desktop Experience', 'DTE'
                $OSImageName = $OSImageName -replace '\(', ''
                $OSImageName = $OSImageName -replace '\)', ''

                if ($($Media.FullName) -like "*PEBuilds*") {
                    $OSImageName = "WinPE $OSArchitecture $UBR"
                    $ISOFile = "$ISODestinationFolder\WinPE $OSArchitecture $UBR.iso"
                } elseif ($($Media.FullName) -like "*OSMedia*") {
                    if ($OSImageName -like "*Win10*") {
                        $OSImageName = "OSMedia Win10 $OSArchitecture $UBR"
                        $ISOFile = "$ISODestinationFolder\OSMedia Win10 $OSArchitecture $UBR.iso"
                    } elseif ($OSImageName -like "*2016*") {
                        $OSImageName = "OSMedia Svr2016 $OSArchitecture $UBR"
                        $ISOFile = "$ISODestinationFolder\OSMedia Svr2016 $OSArchitecture $UBR.iso"
                    } elseif ($OSImageName -like "*2019*") {
                        $OSImageName = "OSMedia Svr2019 $OSArchitecture $UBR"
                        $ISOFile = "$ISODestinationFolder\OSMedia Svr2019 $OSArchitecture $UBR.iso"
                    } else {
                        $OSImageName = "OSMedia WinOS $OSArchitecture $UBR"
                        $ISOFile = "$ISODestinationFolder\OSMedia WinOS $OSArchitecture $UBR.iso"
                    }
                } elseif ($($Media.FullName) -like "*OSBuilds*") {
                    if ($OSImageName -like "*Win10*") {
                        $OSImageName = "OSBuild Win10 $OSArchitecture $UBR"
                        $ISOFile = "$ISODestinationFolder\OSBuild Win10 $OSArchitecture $UBR.iso"
                    } elseif ($OSImageName -like "*2016*") {
                        $OSImageName = "OSBuild Svr2016 $OSArchitecture $UBR"
                        $ISOFile = "$ISODestinationFolder\OSBuild Svr2016 $OSArchitecture $UBR.iso"
                    } elseif ($OSImageName -like "*2019*") {
                        $OSImageName = "OSBuild Svr2019 $OSArchitecture $UBR"
                        $ISOFile = "$ISODestinationFolder\OSBuild Svr2019 $OSArchitecture $UBR.iso"
                    } else {
                        $OSImageName = "OSBuild WinOS $OSArchitecture $UBR"
                        $ISOFile = "$ISODestinationFolder\OSBuild WinOS $OSArchitecture $UBR.iso"
                    }
                }

                # 32 character limit for a Label
                # 23 = Win10 Edu x64 17134.112
                # 25 = Win10 Edu N x64 17134.112
                # 23 = Win10 Ent x64 17134.112
                # 25 = Win10 Ent N x64 17134.112
                # 23 = Win10 Pro x64 17134.112
                # 27 = Win10 Pro Edu x64 17134.112
                # 29 = Win10 Pro EduN x64 17134.112
                # 27 = Win10 Pro Wks x64 17134.112
                # 26 = Win10 Pro N x64 17134.112
                # 29 = Win10 Pro N Wks x64 17134.112
                $ISOLabel = '-l"{0}"' -f $OSImageName
                $ISOFolder = "$($Media.FullName)\ISO"
                if (!(Test-Path $ISOFolder)) {New-Item -Path $ISOFolder -ItemType Directory -Force | Out-Null}

                if (!(Test-Path $ISOSourceFolder)) {
                    Write-Warning "Could not locate $ISOSourceFolder"
                    Write-Warning "Make sure you have proper OS before using New-OSBMediaISO"
                    Return
                }
                $etfsboot = "$ISOSourceFolder\boot\etfsboot.com"
                if (!(Test-Path $etfsboot)) {
                    Write-Warning "Could not locate $etfsboot"
                    Write-Warning "Make sure you have proper OS before using New-OSBMediaISO"
                    Return
                }
                $efisys = "$ISOSourceFolder\efi\microsoft\boot\efisys.bin"
                if (!(Test-Path $efisys)) {
                    Write-Warning "Could not locate $efisys"
                    Write-Warning "Make sure you have proper OS before using New-OSBMediaISO"
                    Return
                }
                Write-Host "Label: $OSImageName" -ForegroundColor Cyan
                Write-Host "Creating: $ISOFile" -ForegroundColor Cyan
                $data = '2#p0,e,b"{0}"#pEF,e,b"{1}"' -f $etfsboot, $efisys
                start-process $oscdimg -args @("-m","-o","-u2","-bootdata:$data",'-u2','-udfver102',$ISOLabel,"`"$ISOSourceFolder`"", "`"$ISOFile`"") -Wait
            }
        }
    }

    END {
        #Write-Host '========================================================================================' -ForegroundColor DarkGray
        #Write-Host "$($MyInvocation.MyCommand.Name) END" -ForegroundColor Green
    }
}