<#
.SYNOPSIS
Renames directories in OSMedia

.DESCRIPTION
Renames directories in OSMedia

.LINK
http://osdbuilder.com/docs/functions/maintenance/rename-osmedia
#>
function Rename-OSMedia {
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
        Write-Verbose '19.1.1 Gather All OSMedia'
        #===================================================================================================
        $AllOSMedia = @()
        $AllOSMedia = Get-ChildItem -Path "$OSDBuilderOSMedia" -Directory | Select-Object -Property * | Where-Object {Test-Path $(Join-Path $_.FullName "info\xml\Get-WindowsImage.xml")}
    }

    PROCESS {
        #Write-Host '========================================================================================' -ForegroundColor DarkGray
        #Write-Host "$($MyInvocation.MyCommand.Name) PROCESS" -ForegroundColor Green

        $RenameOSMedia = foreach ($Item in $AllOSMedia) {
            #===================================================================================================
            #Write-Verbose '19.1.1 Get Windows Image Information'
            #===================================================================================================
            $RenameOSMediaPath = $($Item.FullName)
            Write-Verbose "OSMedia Full Path: $RenameOSMediaPath"
            
            $OSMWindowsImage = @()
            $OSMWindowsImage = Import-Clixml -Path "$RenameOSMediaPath\info\xml\Get-WindowsImage.xml"
            
            $OSMVersion = $($OSMWindowsImage.Version)
            Write-Verbose "Version: $OSMVersion"

            $OSMImageName = $($OSMWindowsImage.ImageName)
            Write-Verbose "ImageName: $OSMImageName"

            $OSMArch = $OSMWindowsImage.Architecture
            if ($OSMArch -eq '0') {$OSMArch = 'x86'}
            if ($OSMArch -eq '6') {$OSMArch = 'ia64'}
            if ($OSMArch -eq '9') {$OSMArch = 'x64'}
            if ($OSMArch -eq '12') {$OSMArch = 'x64 ARM'}
            Write-Verbose "Arch: $OSMArch"

            $OSMEditionId = $($OSMWindowsImage.EditionId)
            Write-Verbose "EditionId: $OSMEditionId"

            $OSMInstallationType = $($OSMWindowsImage.InstallationType)
            Write-Verbose "InstallationType: $OSMInstallationType"

            $OSMMajorVersion = $($OSMWindowsImage.MajorVersion)
            Write-Verbose "MajorVersion: $OSMMajorVersion"

            $OSMMinorVersion = $($OSMWindowsImage.MinorVersion)
            Write-Verbose "MinorVersion: $OSMMinorVersion"

            $OSMBuild = $OSMWindowsImage.Build
            Write-Verbose "Build: $OSMBuild"

            $OSMLanguages = $($OSMWindowsImage.Languages)
            Write-Verbose "Languages: $OSMLanguages"

            $OperatingSystem = ''
            if ($OSMMajorVersion -eq 6 -and $OSMInstallationType -eq 'Client') {$OperatingSystem = 'Windows 7'}
            if ($OSMMajorVersion -eq 10 -and $OSMInstallationType -eq 'Client') {$OperatingSystem = 'Windows 10'}
            if ($OSMMajorVersion -eq 10 -and $OSMInstallationType -eq 'Server' -and $OSMImageName -like "*2016*") {$OperatingSystem = 'Server 2016'}
            if ($OSMMajorVersion -eq 10 -and $OSMInstallationType -eq 'Server' -and $OSMImageName -like "*2019*") {$OperatingSystem = 'Server 2019'}

            $OSMUBR = $($OSMWindowsImage.UBR)
            Write-Verbose "UBR: $OSMUBR"
			
            #   OSMFamily V1
            $OSMFamilyV1 = $(Get-Date -Date $($OSMWindowsImage.CreatedTime)).ToString("yyyyMMddHHmmss") + $OSMEditionID
            #   OSMFamily V2
            $OSMFamily = $OSMInstallationType + " " + $OSMEditionId + " " + $OSMArch + " " + [string]$OSMBuild + " " + $OSMLanguages
            Write-Verbose "OSMFamily: $OSMFamily"

            #$OSMWindowsImage | ForEach {$_.PSObject.Properties.Remove('Guid')}

            $OSMGuid = $($OSMWindowsImage.OSMGuid)
            if (-not ($OSMGuid)) {
                $OSMGuid = $(New-Guid)
                $OSMWindowsImage | Add-Member -Type NoteProperty -Name "OSMGuid" -Value $OSMGuid
                $OSMWindowsImage | Out-File "$RenameOSMediaPath\WindowsImage.txt"
                $OSMWindowsImage | Out-File "$RenameOSMediaPath\info\logs\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsImage.txt"
                $OSMWindowsImage | Export-Clixml -Path "$RenameOSMediaPath\info\xml\Get-WindowsImage.xml"
                $OSMWindowsImage | Export-Clixml -Path "$RenameOSMediaPath\info\xml\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsImage.xml"
                $OSMWindowsImage | ConvertTo-Json | Out-File "$RenameOSMediaPath\info\json\Get-WindowsImage.json"
                $OSMWindowsImage | ConvertTo-Json | Out-File "$RenameOSMediaPath\info\json\$((Get-Date).ToString('yyyy-MM-dd-HHmmss'))-Get-WindowsImage.json"
                (Get-Content "$RenameOSMediaPath\WindowsImage.txt") | Where-Object {$_.Trim(" `t")} | Set-Content "$RenameOSMediaPath\WindowsImage.txt"
                Write-Verbose "Guid (New): $OSMGuid"
            } else {
                Write-Verbose "Guid: $OSMGuid"
            }

            #===================================================================================================
            #Write-Verbose '19.1.1 Gather Registry Information'
            #===================================================================================================
            $OSMRegistry = @()
            if (Test-Path "$RenameOSMediaPath\info\xml\CurrentVersion.xml") {
                Write-Verbose "Registry: $RenameOSMediaPath\info\xml\CurrentVersion.xml"
                $OSMRegistry = Import-Clixml -Path "$RenameOSMediaPath\info\xml\CurrentVersion.xml"
            } else {
                Write-Verbose "Registry: $RenameOSMediaPath\info\xml\CurrentVersion.xml (Not Found)"
            }
            [string]$OSMReleaseId = $($OSMRegistry.ReleaseId)

            if ($OSMBuild -eq 7600) {$OSMReleaseId = 7600}
            if ($OSMBuild -eq 7601) {$OSMReleaseId = 7601}
            if ($OSMBuild -eq 9600) {$OSMReleaseId = 9600}
            if ($OSMBuild -eq 10240) {$OSMReleaseId = 1507}
            if ($OSMBuild -eq 14393) {$OSMReleaseId = 1607}
            if ($OSMBuild -eq 15063) {$OSMReleaseId = 1703}
            if ($OSMBuild -eq 16299) {$OSMReleaseId = 1709}
            if ($OSMBuild -eq 17134) {$OSMReleaseId = 1803}
            if ($OSMBuild -eq 17763) {$OSMReleaseId = 1809}

            Write-Verbose "ReleaseId: $OSMReleaseId"

            if ($OSMReleaseId -eq 7601) {$OSMReleaseId = 'SP1'}

            $FullNameFormat = "$OSMImageName $OSMArch $OSMReleaseId $OSMUBR $($OSMWindowsImage.Languages)"

            $FullNameFormat = $FullNameFormat -replace '\(', ''
            $FullNameFormat = $FullNameFormat -replace '\)', ''

            if ($($($OSMWindowsImage.Languages).count) -eq 1) {$FullNameFormat = $FullNameFormat.replace(' en-US','')}

            if (!($Item.Name -eq $FullNameFormat)) {
                #===================================================================================================
                #Write-Verbose '19.1.1 Object Properties'
                #===================================================================================================
                $ObjectProperties = @{
                    
                    FullNameFormat      = $FullNameFormat
                    Name                = $Item.Name
                    FullName            = $Item.FullName
                }
                New-Object -TypeName PSObject -Property $ObjectProperties
                Write-Verbose ""
            }

        }

        #===================================================================================================
        #Write-Verbose '19.1.3 Output'
        #===================================================================================================
        $RenameOSMedia = $RenameOSMedia | Select-Object FullNameFormat,Name,FullName | Out-GridView -PassThru -Title 'Rename-OSMedia: Select one or more OSMedia to Rename and press OK'
        foreach ($Item in $RenameOSMedia){
            Write-Warning "Renaming $($Item.FullName) to $($Item.FullNameFormat)"
            Rename-Item -Path "$($Item.FullName)" -NewName "$($Item.FullNameFormat)" -Force
        }
    }

    END {
        #Write-Host '========================================================================================' -ForegroundColor DarkGray
        #Write-Host "$($MyInvocation.MyCommand.Name) END" -ForegroundColor Green
    }
}