<#
.SYNOPSIS
Manage OSDBuilder Catalogs and Microsoft Updates

.DESCRIPTION
Function used by OSDBuilder to update Catalogs and to download Microsoft Updates.  Content is saved to OSDBuilder\Content\Updates

.LINK
http://osdbuilder.com/docs/functions/updates/get-osbupdate

.PARAMETER Catalog
Selects the Catalog JSON file containing the Updates

.PARAMETER Download
Executes the Download of files

.PARAMETER HideDetails
Hides all results

.PARAMETER GridView
Displays the Updates in a PowerShell GridView so Updates can be selected.

.PARAMETER RemoveSuperseded
Removes Downloaded Updated that have been Superseded

.PARAMETER ShowDownloaded
Lists Downloaded Updates

.PARAMETER UpdateCatalogs
Downloads updated Catalogs from GitHub

.EXAMPLE
Get-OSBUpdate -Catalog Cumulative -Download
Downloads all Cumulative Updates for Windows 10 and Windows Server 2016

.EXAMPLE
Get-OSBUpdate -Catalog Adobe -FilterOS 'Windows 10' -FilterOSArch 'x64' -FilterOSBuild '1803'
Lists all Adobe Security Updates for Windows 10 x64 1803

.EXAMPLE
Get-OSBUpdate -Catalog Adobe -Download -FilterOS 'Windows 10' -FilterOSArch 'x64' -FilterOSBuild '1803'
Downloads all Adobe Security Updates for Windows 10 x64 1803
#>

function Get-OSBUpdate {
    [CmdletBinding()]
    PARAM (
        #[ValidateSet('Adobe','Component','Cumulative','DotNet','Servicing','Setup','FeatureOnDemand','LanguagePack','LanguageInterfacePack','LanguageFeature','Windows 7 x64 7601','Windows 7 x86 7601','Windows Server 2012 R2 x64')]
        [ValidateSet('Adobe','Component','Cumulative','DotNet','Servicing','Setup','FeatureOnDemand','LanguagePack','LanguageInterfacePack','LanguageFeature')]
        [string]$Catalog,
        [switch]$Download,
        [string]$FilterCategory,
        [string]$FilterKBNumber,
        [string]$FilterKBTitle,
        [ValidateSet('ar-SA','bg-BG','zh-CN','zh-TW','hr-HR','cs-CZ','da-DK','nl-NL','en-US','en-GB','et-EE','fi-FI','fr-CA','fr-FR','de-DE','el-GR','he-IL','hu-HU','it-IT','ja-JP','ko-KR','lv-LV','lt-LT','nb-NO','pl-PL','pt-BR','pt-PT','ro-RO','ru-RU','sr-Latn-RS','sk-SK','sl-SI','es-MX','es-ES','sv-SE','th-TH','tr-TR','uk-UA')]
        [string]$FilterLP,
        [ValidateSet('af-ZA','am-ET','as-IN','az-Latn-AZ','be-BY','bn-BD','bn-IN','bs-Latn-BA','ca-ES','ca-ES-valencia','chr-CHER-US','cy-GB','eu-ES','fa-IR','fil-PH','ga-IE','gd-GB','gl-ES','gu-IN','ha-Latn-NG','hi-IN','hy-AM','id-ID','ig-NG','is-IS','ka-GE','kk-KZ','km-KH','kn-IN','kok-IN','ku-ARAB-IQ','ky-KG','lb-LU','lo-LA','mi-NZ','mk-MK','ml-IN','mn-MN','mr-IN','ms-MY','mt-MT','ne-NP','nn-NO','nso-ZA','or-IN','pa-Arab-PK','pa-IN','prs-AF','quc-Latn-GT','quz-PE','rw-RW','sd-Arab-PK','si-LK','sq-AL','sr-Cyrl-BA','sr-Cyrl-RS','sw-KE','ta-IN','te-IN','tg-Cyrl-TJ','ti-ET','tk-TM','tn-ZA','tt-RU','ug-CN','ur-PK','uz-Latn-UZ','vi-VN','wo-SN','xh-ZA','yo-NG','zu-ZA')]
        [string]$FilterLIP,
        [ValidateSet('Windows 10','Windows Server 2016','Windows Server 2019','Windows 7')]
        [string]$FilterOS,
        [ValidateSet('x64','x86')]
        [string]$FilterOSArch,
        [ValidateSet('1507','1511','1607','1703','1709','1803','1809')]
        [string]$FilterOSBuild,
        [switch]$HideDetails,
        #[switch]$HideOptionalUpdates,
        [switch]$GridView,
        [switch]$RemoveSuperseded,
        [switch]$ShowDownloaded,
        [switch]$UpdateCatalogs
    )

    BEGIN {
        #Write-Host '========================================================================================' -ForegroundColor DarkGray
        #Write-Host "$($MyInvocation.MyCommand.Name) BEGIN" -ForegroundColor Green
        Get-OSDBuilder -CreatePaths -HideDetails
    }

    PROCESS {
        #Write-Host '========================================================================================' -ForegroundColor DarkGray
        #Write-Host "$($MyInvocation.MyCommand.Name) PROCESS" -ForegroundColor Green
        if ($RemoveSuperseded.IsPresent) {
            Write-Warning "This OSDBuilder version has an issue with RemoveSuperseded"
            Write-Warning "RemoveSuperseded is disabled until a solution can be implemented"
        }

        $RemoveSuperseded = $false
        #===================================================================================================
        Write-Verbose '19.1.1 Reset Variables'
        #===================================================================================================
        $null = $ImportCatalog
        $CatalogDownloads = @()
        $DownloadedUpdates = @()
        $SupersededUpdates = @()
        
        #===================================================================================================
        Write-Verbose '19.1.1 Get Catalogs'
        #===================================================================================================
        if (!(Test-Path "$CatalogLocal")) {$UpdateCatalogs = $true}
        if (Test-Path "$OSDBuilderContent\Updates\Catalog.json") {
            Remove-Item "$OSDBuilderContent\Updates\Catalog.json" -Force | Out-Null
            $UpdateCatalogs = $true
        }
        if (Test-Path "$OSDBuilderContent\Updates\Catalog.xml") {
            Remove-Item "$OSDBuilderContent\Updates\Catalog.xml" -Force | Out-Null
            $UpdateCatalogs = $true
        }
        #===================================================================================================
        Write-Verbose '19.1.1 Update Catalogs'
        #===================================================================================================
        if ($UpdateCatalogs.IsPresent) {
            Write-Warning "Downloading $OSDBuilderCatalogURL"
            $statuscode = try {(Invoke-WebRequest -Uri $OSDBuilderCatalogURL -UseBasicParsing -DisableKeepAlive).StatusCode}
            catch [Net.WebException]{[int]$_.Exception.Response.StatusCode}
            if (!($statuscode -eq "200")) {
                Write-Warning "Could not connect to $OSDBuilderCatalogURL (Status Code: $statuscode) ..."
            } else {
                Invoke-WebRequest -Uri "$OSDBuilderCatalogURL" -OutFile "$CatalogLocal"
                if (Test-Path "$CatalogLocal") {
                    $CatalogJson = Get-Content -Path "$CatalogLocal" | ConvertFrom-Json
                    foreach ($item in $($CatalogJson.CatalogsDownload)) {
                        $statuscode = try {(Invoke-WebRequest -Uri $OSDBuilderCatalogURL -UseBasicParsing -DisableKeepAlive).StatusCode}
                        catch [Net.WebException]{[int]$_.Exception.Response.StatusCode}
                        if ($statuscode -eq "200") {
                            Invoke-WebRequest -Uri "$($item)" -OutFile "$OSDBuilderContent\Updates\$(Split-Path "$($item)" -Leaf)"
                        }
                    }
                }
            }
        }
        #===================================================================================================
        Write-Verbose '19.1.1 Catalog Test'
        #===================================================================================================
        if (!(Test-Path "$CatalogLocal")) {
            Write-Warning "$CatalogLocal could not be downloaded ... Exiting"
            Return
        }
        #===================================================================================================
        Write-Verbose '19.1.1 Get Update Catalogs'
        #===================================================================================================
        $CatalogsXmls = Get-ChildItem "$OSDBuilderContent\Updates\*" -Include Catalog*.xml -Recurse
        $ExistingUpdates = @(Get-ChildItem -Path "$OSDBuilderContent\Updates\*\*" -Directory)

        #Exclude contents of the Custom directory
        #$ExistingUpdates = $ExistingUpdates | Where-Object {$_.FullName -notlike "*\Custom\*"}

        foreach ($CatalogsXml in $CatalogsXmls) {
            if ($($CatalogsXml.Name) -like "*Custom*") {
                #Write-Host "Processing Custom Catalog: $($CatalogsXml.FullName)" -ForegroundColor Green
            }
            $ImportCatalog = Import-Clixml -Path "$($CatalogsXml.FullName)"
            $CatalogDownloads += $ImportCatalog
        }

        $CatalogDownloads = $CatalogDownloads | Sort-Object DatePosted -Descending | Select-Object -Property Group, Category, KBNumber, KBTitle, FileName, DatePosted, DateRevised, DateCreated, DateLastModified, URL
        
        if ($Catalog) {
            if (!(Test-Path "$OSDBuilderContent\Updates\$Catalog")) {New-Item "$OSDBuilderContent\Updates\$Catalog" -ItemType Directory -Force | Out-Null}
            $CatalogDownloads = $CatalogDownloads | Where-Object {$_.Name -like "*$Catalog*"}
            $ExistingUpdates = $ExistingUpdates | Where-Object {$_.Name -like "*$Catalog*"}
        }
        
        #===================================================================================================
        Write-Verbose '19.1.1 Get Downloaded and Superseded Updates'
        #===================================================================================================
        #Write-Host "Existing: $ExistingUpdates"
        foreach ($Update in $ExistingUpdates) {
            if ($CatalogDownloads.KBTitle -NotContains $Update.Name) {$SupersededUpdates += $Update.Name}
            else {$DownloadedUpdates += $Update.Name}
        }
        #===================================================================================================
        Write-Verbose '19.1.1 Show Downloaded Updates'
        #===================================================================================================
        if ($ShowDownloaded.IsPresent) {
            if ($DownloadedUpdates) {
                Write-Host "Downloaded Updates" -ForegroundColor Green
                $DownloadedUpdates
                Write-Host ""
            }
        }
        #===================================================================================================
        Write-Verbose '19.1.1 Show Superseded Updates'
        #===================================================================================================
        if (!($HideDetails.IsPresent)) {
            if ($SupersededUpdates) {
                Write-Host "Superseded Updates can be removed with -RemoveSuperseded" -ForegroundColor Green
                $SupersededUpdates
                Write-Host ""
            }
        }
        #===================================================================================================
        Write-Verbose '19.1.1 Remove Superseded Updates'
        #===================================================================================================
        if ($RemoveSuperseded.IsPresent){
            foreach ($Update in $SupersededUpdates) {
                $RemoveUpdate = Get-ChildItem -Path "$OSDBuilderContent\Updates\*\*" -Directory | Where-Object {$_.Name -eq $Update}
                Write-Warning "Removing $RemoveUpdate"
                Remove-Item -Path $RemoveUpdate -Recurse -Force
            }
            Write-Host ""
        }
        #===================================================================================================
        #Write-Verbose '19.1.1 Show Available Updates'
        #===================================================================================================
    <#     foreach ($Update in $CatalogDownloads) {
            if ($ExistingUpdates.Name -NotContains $Update.KBTitle) {
                $AvailableUpdates += $Update.KBTitle
            }
        }
        if ($AvailableUpdates) {
            Write-Host "Available Updates that have not been downloaded" -ForegroundColor Green
            $AvailableUpdates
            Write-Host ""
        } #>
        #===================================================================================================
        Write-Verbose '19.1.1 Filters'
        #===================================================================================================
        #if (!($Catalog.IsPresent)) {$HideOptionalUpdates = $true}
        #if ($HideOptionalUpdates) {$CatalogDownloads = $CatalogDownloads | Where-Object {$_.Category -notlike "Language*"}}
        #if ($HideOptionalUpdates) {$CatalogDownloads = $CatalogDownloads | Where-Object {$_.Category -notlike "FeatureOnDemand"}}
        if (!($Catalog -or $FilterKBTitle)) {
            $CatalogDownloads = $CatalogDownloads | Where-Object {$_.Category -notlike "Language*"}
            $CatalogDownloads = $CatalogDownloads | Where-Object {$_.Category -notlike "FeatureOnDemand"}
            Write-Warning "Language Packs, Language Interface Packs and Features on Demand are not automatically displayed"
            Write-Warning "To view these updates, use the Catalog parameter"
            Write-Host ""
        }

        if ($FilterCategory) {$CatalogDownloads = $CatalogDownloads | Where-Object {$_.Category -like "*$FilterCategory*"}}
        if ($FilterKBNumber) {$CatalogDownloads = $CatalogDownloads | Where-Object {$_.KBNumber -like "*$FilterKBNumber*"}}
        if ($FilterKBNumber) {$CatalogDownloads = $CatalogDownloads | Where-Object {$_.KBNumber -like "*$FilterKBNumber*"}}
        if ($FilterKBTitle) {$CatalogDownloads = $CatalogDownloads | Where-Object {$_.KBTitle -like "*$FilterKBTitle*"}}
        if ($FilterLP) {$CatalogDownloads = $CatalogDownloads | Where-Object {$_.KBTitle -like "*$FilterLP*"}}
        if ($FilterLIP) {$CatalogDownloads = $CatalogDownloads | Where-Object {$_.KBTitle -like "*$FilterLIP*"}}
        if ($FilterOS) {$CatalogDownloads = $CatalogDownloads | Where-Object {$_.KBTitle -like "*$FilterOS*"}}
        if ($FilterOSArch) {$CatalogDownloads = $CatalogDownloads | Where-Object {$_.KBTitle -like "*$FilterOSArch*"}}
        if ($FilterOSBuild) {$CatalogDownloads = $CatalogDownloads | Where-Object {$_.KBTitle -like "*$FilterOSBuild*"}}
        #===================================================================================================
        Write-Verbose '19.1.1 Select Updates with PowerShell ISE'
        #===================================================================================================
        if ($GridView.IsPresent) {$CatalogDownloads = $CatalogDownloads | Out-GridView -PassThru -Title 'Select Updates to Download and press OK'}
        #===================================================================================================
        Write-Verbose '19.1.1 Filtered Updates'
        #===================================================================================================
        $FilteredUpdates = @()
        foreach ($Update in $CatalogDownloads) {
            if ($ExistingUpdates.Name -NotContains $Update.KBTitle) {
                $FilteredUpdates += $Update.KBTitle
            }
        }
        if (!($HideDetails.IsPresent)) {
            if ($FilteredUpdates) {
                Write-Host "Available Filtered Updates can be downloaded with the -Download parameter" -ForegroundColor Green
                $FilteredUpdates
                Write-Host ""
            }
        }
        #===================================================================================================
        Write-Verbose '19.2.11 Download Updates'
        #===================================================================================================
        if ($Download.IsPresent) {
            foreach ($Update in $CatalogDownloads) {
                if ($null -eq $Update.Group) {
                    $DownloadPath = "$OSDBuilderContent\Updates\$($Update.Category)\$($Update.KBTitle)"
                } else {
                    $DownloadPath = "$OSDBuilderContent\Updates\$($Update.Group)\$($Update.KBTitle)"
                }
                $DownloadFullPath = "$DownloadPath\$($Update.FileName)"

                if (!(Test-Path $DownloadPath)) {New-Item -Path "$DownloadPath" -ItemType Directory -Force | Out-Null}
                if (!(Test-Path $DownloadFullPath)) {
                    Write-Host "$($Update.URL)" -ForegroundColor Yellow
                    $WebClient = New-Object System.Net.WebClient
                    $WebClient.DownloadFile("$($Update.URL)","$DownloadFullPath")
                    #Start-BitsTransfer -Source $($Update.URL) -Destination $DownloadFullPath
                    Write-Host "$DownloadFullPath"
                } else {
                    #Write-Warning "Exists: $($Update.KBTitle)"
                }
            }
        }
        if (!($HideDetails.IsPresent)) {
            #===================================================================================================
            Write-Verbose '19.1.1 Remove Variables'
            #===================================================================================================
            Remove-Variable Catalog
            if ($CatalogsXml) {Remove-Variable CatalogsXml}
            Remove-Variable Download
            Remove-Variable ExistingUpdates
            Remove-Variable FilterCategory
            Remove-Variable FilterKBNumber
            Remove-Variable FilterKBTitle
            Remove-Variable FilterLIP
            Remove-Variable FilterLP
            Remove-Variable FilterOS
            Remove-Variable FilterOSArch
            Remove-Variable FilterOSBuild
            Remove-Variable RemoveSuperseded
            Remove-Variable ShowDownloaded
            if ($Update) {Remove-Variable Update}
            Remove-Variable UpdateCatalogs
        }
    }

    END {
        #Write-Host '========================================================================================' -ForegroundColor DarkGray
        #Write-Host "$($MyInvocation.MyCommand.Name) END" -ForegroundColor Green
    }
}