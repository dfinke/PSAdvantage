function ExportReport {
    param(
        $Type,
        $Data
    )

    $xlfilename = "./$($Type).xlsx"
    Remove-Item $xlfilename -ErrorAction SilentlyContinue

    $p = @{
        Path          = $xlfilename
        AutoSize      = $true
        AutoFilter    = $true
        AutoNameRange = $true
        TableName     = $Type
        PassThru      = $true
    }

    $excel = $data | ForEach-Object { $_.DateCreated = Get-Date $_.DateCreated; $_ } | Export-Excel @p -StartColumn 8
        
    Set-ExcelRange -Worksheet $excel.Sheet1 -Range DateCreated -NumberFormat 'Short Date'
    Set-ExcelRange -Worksheet $excel.Sheet1 -Range Title -Width 20
    Set-ExcelRange -Worksheet $excel.Sheet1 -Range Repo -Width 30

    $pivotTableParams = @{
        PivotTableName  = "ByDateAndState"
        Address         = $excel.Sheet1.cells["A2"]
        SourceWorkSheet = $excel.Sheet1    
        PivotRows       = @("Repo", "DateCreated")
        PivotColumns    = @("State")
        PivotData       = @{'state' = 'count' }
        PivotTableStyle = 'Light21'
        GroupDateRow    = "DateCreated"
        GroupDatePart   = @("Year", "Quarter", "Month")
    }

    $pt = Add-PivotTable @pivotTableParams -PassThru 
    $pt.RowHeaderCaption = "$($Type) by Quarter and State"

    Close-ExcelPackage $excel -Show
}