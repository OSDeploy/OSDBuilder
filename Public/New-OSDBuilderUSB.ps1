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
Dynamic parameter when "Split" is used. The desired size of the .swm files created when using the "Split" parameter. Note: The integer value should be in MB (ie. 4000 is 4GB)

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

    dynamicparam {
		if ($Split) {
			$ParameterName = "SplitSize"
			
			$parameterAttribute = New-Object System.Management.Automation.ParameterAttribute
			$parameterAttribute.HelpMessage = "Please enter the size you wish to split:"
			$parameterAttribute.Mandatory = $true
	
			$validateAttribute = New-Object System.Management.Automation.ValidateNotNullOrEmptyAttribute
			$attributeCollection = [System.Collections.ObjectModel.Collection[System.Attribute]]::new()
			$attributeCollection.Add($parameterAttribute)
			$attributeCollection.Add($validateAttribute)
	
			$dynParam1 = [System.Management.Automation.RuntimeDefinedParameter]::new(
				$ParameterName, [Int32], $attributeCollection
			)
	
			$paramDictionary = [System.Management.Automation.RuntimeDefinedParameterDictionary]::new()
			$paramDictionary.Add( $ParameterName, $dynParam1)
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

    }

    Process {
        Write-Host '========================================================================================' -ForegroundColor DarkGray
        Write-Host -ForegroundColor Green "$($MyInvocation.MyCommand.Name) PROCESS"

        Write-Warning "USB will be formatted FAT32"
        Write-Warning "Install.wim larger than 4GB will FAIL"

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

        # Get install.wim size in MB
        $WIMSize = (Get-Item "$($SelectedOSMedia.FullName)\OS\Sources\install.wim").Length/100000

        # If the split parameter is not selected and install.wim is larger than 4000MB, set the split size to 4000MB
        Switch ($Split){
            $true { Continue }
            $false { if ( $WIMSize -gt 4000 ) { $SplitSize = 4000 } }
        }

        if ($null -eq $Results) {
            Write-Warning "No USB Drive was Found or Selected"
            Return
        } else {
            #Make Bootable
            Set-Location -Path "$($SelectedOSMedia.FullName)\OS\boot"
            bootsect.exe /nt60 "$($Results.DriveLetter):"

            #Copy Files from ISO to USB and split the install.wim if needed or if specified by the split parameter
            if ($Split -eq $true -or $WIMSize -gt 4000){
                #Create .swm files from the install.wim and copy them over instead of the install.wim (keeps filesize down for FAT32)
                Dism /Split-Image /ImageFile:"$($SelectedOSMedia.FullName)\OS\Sources\install.wim" /SWMFile:"$($SelectedOSMedia.FullName)\OS\Sources\install.swm" /FileSize:$SplitSize /Verbose
                Copy-Item -Path "$($SelectedOSMedia.FullName)\OS\*" -Destination "$($Results.DriveLetter):" -Recurse -Exclude "$($SelectedOSMedia.FullName)\OS\Sources\install.wim" -Verbose
            } else {
                Copy-Item -Path "$($SelectedOSMedia.FullName)\OS\*" -Destination "$($Results.DriveLetter):" -Recurse -Verbose
            }
        }

    }

    End {
        #Write-Host '========================================================================================' -ForegroundColor DarkGray
        #Write-Host -ForegroundColor Green "$($MyInvocation.MyCommand.Name) END"
    }
}