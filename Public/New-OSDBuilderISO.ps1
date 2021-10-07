<#
.SYNOPSIS
Creates an ISO of any OSDBuilder Media

.DESCRIPTION
Creates an ISO of any OSDBuilder Media (OSMedia, OSBuilds, PEBuilds)

.LINK
https://osdbuilder.osdeploy.com/module/functions/new-osdbuilderiso

.PARAMETER FullName
Full Path of the OSDBuilder Media
.PARAMETER PassThru
Return created ISO information
#>
function New-OSDBuilderISO {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        [string[]]$FullName,
        [Parameter(Mandatory=$false)][Switch]$PassThru
    )

    BEGIN {
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
        Write-Verbose '19.2.10 Gather All OS Media'
        #=================================================
        $AllMyOSMedia = @()
        $AllMyOSMedia = Get-OSMedia

        $AllMyOSBuilds = @()
        $AllMyOSBuilds = Get-OSBuilds

        $AllMyPEBuilds = @()
        $AllMyPEBuilds = Get-PEBuilds

        $AllMyOSDBMedia = @()
        $AllMyOSDBMedia = [array]$AllMyOSMedia + [array]$AllMyOSBuilds + [array]$AllMyPEBuilds

        #=================================================
        Write-Verbose '19.1.1 Locate OSCDIMG'
        #=================================================
        if (Test-Path "$SetOSDBuilderPathContent\Tools\$env:PROCESSOR_ARCHITECTURE\Oscdimg\oscdimg.exe") {
            $oscdimg = "$SetOSDBuilderPathContent\Tools\$env:PROCESSOR_ARCHITECTURE\Oscdimg\oscdimg.exe"
        } elseif (Test-Path "C:\Program Files\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\$env:PROCESSOR_ARCHITECTURE\Oscdimg\oscdimg.exe") {
            $oscdimg = "C:\Program Files\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\$env:PROCESSOR_ARCHITECTURE\Oscdimg\oscdimg.exe"
        } elseif (Test-Path "C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\$env:PROCESSOR_ARCHITECTURE\Oscdimg\oscdimg.exe") {
            $oscdimg = "C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\$env:PROCESSOR_ARCHITECTURE\Oscdimg\oscdimg.exe"
        } else {
            Write-Host '========================================================================================' -ForegroundColor DarkGray
            Write-Warning "Could not locate OSCDIMG in Windows ADK at:"
            Write-Warning "${env:ProgramFiles(x86)}\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\amd64\Oscdimg\oscdimg.exe"
            Write-Warning "You can optionally copy OSCDIMG to:"
            Write-Warning "$SetOSDBuilderPathContent\Tools\$env:PROCESSOR_ARCHITECTURE\Oscdimg\oscdimg.exe"
            Break
        }
        Write-Verbose "OSCDIMG: $oscdimg"

        #Create results array
        if($PassThru)
        {
            $results = @()
        }
    }

    PROCESS {
        Write-Host '========================================================================================' -ForegroundColor DarkGray
        Write-Host -ForegroundColor Green "$($MyInvocation.MyCommand.Name) PROCESS"

        #=================================================
        Write-Verbose '19.1.14 Select Source OSMedia'
        #=================================================
        $SelectedOSMedia = @()

        if ($FullName) {
            foreach ($Item in $FullName) {
                Write-Verbose "Checking $Item"
                $SelectedOSMedia += $AllMyOSDBMedia | Where-Object {$_.FullName -eq $Item}
            }
        } else {
            $SelectedOSMedia = $AllMyOSDBMedia | Out-GridView -Title "OSDBuilder: Select one or more OSMedia to create an ISO and press OK (Cancel to Exit)" -PassThru
        }

        #=================================================
        Write-Verbose '19.1.1 Process OSMedia'
        #=================================================
        foreach ($Media in $SelectedOSMedia) {
            $ISOSourceFolder = "$($Media.FullName)\OS"
            $ISODestinationFolder = "$($Media.FullName)\ISO"
            if (!(Test-Path $ISODestinationFolder)) {New-Item $ISODestinationFolder -ItemType Directory -Force | Out-Null}

            #$ISOFile = "$ISODestinationFolder\$($Media.Name).iso"

            $PEImage = Import-CliXml -Path "$($Media.FullName)\info\xml\Get-WindowsImage.xml"
            #$PEImage = $PEImage

            $OSArchitecture = $($PEImage.Architecture)
            if ($OSArchitecture -eq '0') {$OSArchitecture = 'x86'}
            if ($OSArchitecture -eq '6') {$OSArchitecture = 'ia64'}
            if ($OSArchitecture -eq '9') {$OSArchitecture = 'x64'}
            if ($OSArchitecture -eq '12') {$OSArchitecture = 'x64 ARM'}

            $UBR = $($PEImage.UBR)

            $OSImageName = $($PEImage.ImageName)
            $OSImageName = $OSImageName -replace '\(', ''
            $OSImageName = $OSImageName -replace '\)', ''

            if ($Media.MediaType -eq "PEBuild") {
                if ($Media.MajorVersion -eq 10) {
                    $OSImageName = "WinPE10 $($Media.Arch) $($Media.ReleaseId) $($Media.UBR)"
                    $ISOFile = "$ISODestinationFolder\WinPE10 $($Media.Arch) $($Media.ReleaseId) $($Media.UBR).iso"
                } elseif ($Media.Version -like "6.3.*") {
                    $OSImageName = "WinPE5 $($Media.Arch) $($Media.UBR)"
                    $ISOFile = "$ISODestinationFolder\WinPE5 $($Media.Arch) $($Media.UBR).iso"
                } elseif ($Media.Version -like "6.2.*") {
                    $OSImageName = "WinPE4 $($Media.Arch) $($Media.UBR)"
                    $ISOFile = "$ISODestinationFolder\WinPE4 $($Media.Arch) $($Media.UBR).iso"
                } elseif ($Media.Version -like "6.1.*") {
                    $OSImageName = "WinPE3 $($Media.Arch) $($Media.UBR)"
                    $ISOFile = "$ISODestinationFolder\WinPE3 $($Media.Arch) $($Media.UBR).iso"
                } else {
                    $OSImageName = "WinPE $($Media.Arch) $($Media.UBR)"
                    $ISOFile = "$ISODestinationFolder\WinPE5 $($Media.Arch) $($Media.UBR).iso"
                }
            } elseif ($Media.OperatingSystem -like "*Server*") {
                $OSImageName = "Server $($Media.Version)"
                $ISOFile = "$ISODestinationFolder\Server $($Media.Version).iso"
            } else {
                if ($Media.MajorVersion -eq 10) {
                    $OSImageName = "Win10 $($Media.Arch) $($Media.ReleaseId) $($Media.UBR)"
                    $ISOFile = "$ISODestinationFolder\Win10 $($Media.Arch) $($Media.ReleaseId) $($Media.UBR).iso"
                } elseif ($Media.Version -like "6.3.*") {
                    $OSImageName = "Win8.1 $($Media.Arch) $($Media.UBR)"
                    $ISOFile = "$ISODestinationFolder\Win8.1 $($Media.Arch) $($Media.UBR).iso"
                } elseif ($Media.Version -like "6.2.*") {
                    $OSImageName = "Win8 $($Media.Arch) $($Media.UBR)"
                    $ISOFile = "$ISODestinationFolder\Win8 $($Media.Arch) $($Media.UBR).iso"
                } elseif ($Media.Version -like "6.1.*") {
                    $OSImageName = "Win7 $($Media.Arch) $($Media.UBR)"
                    $ISOFile = "$ISODestinationFolder\Win7 $($Media.Arch) $($Media.UBR).iso"
                } else {
                    $OSImageName = "Win $($Media.Arch) $($Media.UBR)"
                    $ISOFile = "$ISODestinationFolder\Win $($Media.Arch) $($Media.UBR).iso"
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
                Write-Warning "Make sure you have proper OS before using New-OSDBuilderISO"
                Return
            }
            $etfsboot = "$ISOSourceFolder\boot\etfsboot.com"
            if (!(Test-Path $etfsboot)) {
                Write-Warning "Could not locate $etfsboot"
                Write-Warning "Make sure you have proper OS before using New-OSDBuilderISO"
                Return
            }

            $efisys = "$ISOSourceFolder\efi\microsoft\boot\efisys.bin"
            if (Test-Path "$ISOSourceFolder\efi\microsoft\boot\efisys.bin") {
                $efisys = "$ISOSourceFolder\efi\microsoft\boot\efisys.bin"
            } elseif (Test-Path "$SetOSDBuilderPathContent\Tools\$env:PROCESSOR_ARCHITECTURE\Oscdimg\efisys.bin") {
                $efisys = "$SetOSDBuilderPathContent\Tools\$env:PROCESSOR_ARCHITECTURE\Oscdimg\efisys.bin"
            } elseif (Test-Path "C:\Program Files\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\$env:PROCESSOR_ARCHITECTURE\Oscdimg\efisys.bin") {
                $efisys = "C:\Program Files\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\$env:PROCESSOR_ARCHITECTURE\Oscdimg\efisys.bin"
            } elseif (Test-Path "C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\$env:PROCESSOR_ARCHITECTURE\Oscdimg\efisys.bin") {
                $efisys = "C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\$env:PROCESSOR_ARCHITECTURE\Oscdimg\efisys.bin"
            } else {
                Write-Warning "Could not locate $efisys"
                Write-Warning "Make sure you have proper OS before using New-OSDBuilderISO"
                Return
            }

            Write-Host "Label: $OSImageName" -ForegroundColor Cyan
            Write-Host "Creating: $ISOFile" -ForegroundColor Cyan
            $data = '2#p0,e,b"{0}"#pEF,e,b"{1}"' -f $etfsboot, $efisys
            start-process $oscdimg -args @("-m","-o","-u2","-bootdata:$data",'-u2','-udfver102',$ISOLabel,"`"$ISOSourceFolder`"", "`"$ISOFile`"") -Wait
            
            #Add ISO info to object
            if($passthru)
            {
                $results += [pscustomobject]@{
                    Label = $OSImageName
                    SourceFolder = $ISOSourceFolder
                    FilePath = $ISOFile
                }
            }

        }
    }

    END {
        #Write-Host '========================================================================================' -ForegroundColor DarkGray
        #Write-Host -ForegroundColor Green "$($MyInvocation.MyCommand.Name) END"
        if($PassThru)
        {
            return $results
        }
    }
}