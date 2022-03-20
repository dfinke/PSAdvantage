function Get-GHReleaseReport {
    [CmdletBinding()]
    <#
        .SYNOPSIS
        Get releases in a GitHub repository, and export them to Excel
        
        .EXAMPLE
        Get-GHReleaseReport dfinke/importexcel
        
        .EXAMPLE
        # Get releases, and go back 3 pages worth of releases
        Get-GHReleaseReport dfinke/importexcel -NumberOfPages 3
    #>

    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline)]
        [string[]]$slug,
        # Number of pages to retrieve        
        $XLFilename = "./GitHubStats.xlsx",
        $NumberOfPages = 1        
    )
    
    Begin {
        if (!$slug) {
            Write-Warning "Slug not specified and is required"
            return
        }
       
        $script:data = @()
    }

    Process {
        $data += foreach ($item in $slug) {
            Get-GHRelease $item -NumberOfPages $NumberOfPages
        }
    }

    End {
        $Type = 'Releases'

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
               
        $excel = $data | Export-Excel @p

        Set-ExcelRange -Worksheet $excel.$worksheetName -Range DateCreated -NumberFormat 'Short Date'
        Set-ExcelRange -Worksheet $excel.$worksheetName -Range Repo -Width 30
        
        $pivotTableParams = @{
            PivotTableName  = $worksheetName
            Address         = $excel.$worksheetName.cells["A2"]
            SourceWorkSheet = $excel.$worksheetName
            PivotRows       = @("Repo", "DateCreated")
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
}