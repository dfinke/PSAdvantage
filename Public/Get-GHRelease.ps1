function Get-GHRelease {
    [CmdletBinding()]
    <#
        .SYNOPSIS
        Get releases in a GitHub repository
        
        .EXAMPLE
        Get-GHRelease dfinke/importexcel
        
        .EXAMPLE
        # Get open releases, and go back 3 pages worth of releases
        Get-GHRelease dfinke/importexcel -NumberOfPages 3

        .EXAMPLE
        # Get open releases, return all the data from GitHub
        Get-GHRelease dfinke/importexcel -Raw
    #>

    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline)]
        $slug,
        # Number of pages to retrieve        
        $NumberOfPages = 1,
        $XLFilename,
        [Switch]$AsExcelReport,
        [Switch]$Raw
    )
    
    Process {
        if (!$slug) {
            Write-Warning "Slug not specified and is required"
            return
        }
        
        Write-Progress -Activity "Getting" -Status "release info for repo $($slug)"
        $result = (Invoke-GitHubAPI "https://api.github.com/repos/$($slug)/releases" -FollowRelLink -MaximumFollowRelLink $NumberOfPages)

        if ($Raw) {
            $result
        }
        else {
            $transformed = foreach ($item in $result) {
                foreach ($i in $item) {
                    $created = Get-Date $i.created_at        
        
                    [PSCustomObject][Ordered]@{
                        DateCreated = $created
                        Tag         = $i.tag_name
                        Draft       = $i.draft
                        PreRelease  = $i.prerelease
                        Repo        = $slug[0]
                        Zipball     = $i.zipball_url
                        Tarball     = $i.tarball_url
                    }
                }
            }            
        }

        if ($AsExcelReport) {
            $Type = 'Releases'
            
            if (!$XLFilename) {
                $XLFilename = "./GitHubStats.xlsx"  
            }
            
            if (!$WorksheetName) {
                $ts = (Get-Date).ToString("yyyyMMddHHmmss")
                $worksheetName = "$($Type)-$($ts)"
            }

            $p = @{
                Path          = $xlfilename
                AutoSize      = $true
                AutoFilter    = $true
                AutoNameRange = $true
                # TableName     = "$($Type)-Table" + ((New-Guid).guid.split('-')[0])
                WorksheetName = $worksheetName
                MoveToStart   = $true
                StartColumn   = 6
                PassThru      = $true
            }
               
            $excel = $transformed | Export-Excel @p

            Set-ExcelRange -Worksheet $excel.$worksheetName -Range DateCreated -NumberFormat 'Short Date'
            Set-ExcelRange -Worksheet $excel.$worksheetName -Range Repo -Width 30
        
            $pivotTableParams = @{
                PivotTableName  = $worksheetName
                Address         = $excel.$worksheetName.cells["A2"]
                SourceWorkSheet = $excel.$worksheetName
                PivotRows       = @("Repo", "DateCreated")
                #PivotColumns    = @("State")
                PivotData       = @{'tag' = 'count' }
                PivotTableStyle = 'Light21'
                GroupDateRow    = "DateCreated"
                GroupDatePart   = @("Year", "Quarter", "Month")
            }
        
            $pt = Add-PivotTable @pivotTableParams -PassThru 
            $pt.RowHeaderCaption = "$($Type) by Quarter"
        
            Close-ExcelPackage $excel

            Write-Information "Data saved to: $(Resolve-Path $XLFilename) - $($WorksheetName) " -InformationAction Continue
        }
        else {
            $transformed
        }
    }
}