function ExportReport {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        $Type,
        [Parameter(Mandatory)]
        $Data,
        [Parameter(Mandatory)]
        $XLFilename,
        $WorksheetName
    )

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
        StartColumn   = 8
        PassThru      = $true
    }

    $excel = $data | ForEach-Object { $_.DateCreated = Get-Date $_.DateCreated; $_ } | Export-Excel @p 
        
    Set-ExcelRange -Worksheet $excel.$worksheetName -Range DateCreated -NumberFormat 'Short Date'
    Set-ExcelRange -Worksheet $excel.$worksheetName -Range Title -Width 20
    Set-ExcelRange -Worksheet $excel.$worksheetName -Range Repo -Width 30

    $pivotTableParams = @{
        PivotTableName  = $worksheetName
        Address         = $excel.$worksheetName.cells["A2"]
        SourceWorkSheet = $excel.$worksheetName
        PivotRows       = @("Repo", "DateCreated")
        PivotColumns    = @("State")
        PivotData       = @{'state' = 'count' }
        PivotTableStyle = 'Light21'
        GroupDateRow    = "DateCreated"
        GroupDatePart   = @("Year", "Quarter", "Month")
    }

    $pt = Add-PivotTable @pivotTableParams -PassThru 
    $pt.RowHeaderCaption = "$($Type) by Quarter and State"

    Close-ExcelPackage $excel

    Write-Information "Data saved to: $(Resolve-Path $XLFilename) - $($WorksheetName) " -InformationAction Continue
}