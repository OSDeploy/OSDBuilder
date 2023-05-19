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

.PARAMETER Split
Split install.wim into multiple .swm files. This will be automatically set to $true if the file is reported to be over 4GB.

.PARAMETER SplitSize
The desired size of the .swm files created when using the "Split" parameter. Note: The integer value should be in MB (ie. 4000 is 4GB)

#>
function New-OSDBuilderUSB {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$FullName,
        
        [ValidateLength(1,11)]
        [string]$USBLabel,

        [Parameter]
        [Switch]$Split
    )

    dynamicparam
    {
      if ($Split -eq $true)
      {
        $parameterAttribute = [System.Management.Automation.ParameterAttribute]@{
            ParameterSetName = "__AllParameterSets"
            Mandatory = $true
        }
  
        $attributeCollection = [System.Collections.ObjectModel.Collection[System.Attribute]]::new()
        $attributeCollection.Add($parameterAttribute)
  
        $dynParam1 = [System.Management.Automation.RuntimeDefinedParameter]::new(
          'SplitSize', [Int32], $attributeCollection
        )
  
        $paramDictionary = [System.Management.Automation.RuntimeDefinedParameterDictionary]::new()
        $paramDictionary.Add('SplitSize', $dynParam1)
        return $paramDictionary
      }
    }

    Begin {
        #=================================================
        #   Get-OSDBuilder
        #=================================================
        Get-OSDBuilder -CreatePaths -HideDetails
        #=================================================
        #   Block
        #=================================================
        Block-StandardUser
        #=================================================
        #   Gather all OSMedia OSBuilds PEBuilds
        #=================================================
        $AllMyOSMedia = @()
        $AllMyOSMedia = Get-OSMedia

        $AllMyOSBuilds = @()
        $AllMyOSBuilds = Get-OSBuilds

        $AllMyPEBuilds = @()
        $AllMyPEBuilds = Get-PEBuilds

        $AllMyOSDBMedia = @()
        $AllMyOSDBMedia = [array]$AllMyOSMedia + [array]$AllMyOSBuilds + [array]$AllMyPEBuilds

        # TODO: Create variable with size of the install.wim
    }

    Process {
        Write-Host '========================================================================================' -ForegroundColor DarkGray
        Write-Host -ForegroundColor Green "$($MyInvocation.MyCommand.Name) PROCESS"

        Write-Warning "USB will be formatted FAT32"
        Write-Warning "Install.wim larger than 4GB will FAIL"

        # TODO: Create a check if install.wim is greater than 4GB or the "split" parameter is selected, then split the wim file into multiple .swm files of the desired size (4GB exactly, if not using the split and splitsize parameters).
        # Example: Dism /Split-Image /ImageFile:C:\install.wim /SWMFile:C:\images\split\install.swm /FileSize:4000

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
            $SelectedOSMedia = $AllMyOSDBMedia | Out-GridView -Title "OSDBuilder: Select one OSMedia to create an USB and press OK (Cancel to Exit)" -OutputMode Single
        }

        #=================================================
        Write-Verbose '19.1.1 Select USB Drive'
        #=================================================
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

            #Copy Files from ISO to USB
            Copy-Item -Path "$($SelectedOSMedia.FullName)\OS\*" -Destination "$($Results.DriveLetter):" -Recurse -Verbose
        }
    }

    End {
        #Write-Host '========================================================================================' -ForegroundColor DarkGray
        #Write-Host -ForegroundColor Green "$($MyInvocation.MyCommand.Name) END"
    }
}