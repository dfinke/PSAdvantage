param(
    $owner = 'dfinke',
    $repo = 'pstestsimple',
    [switch]$raw
)

function SetWithOnColumns {
    param(
        $Worksheet,
        [object[]]$Range,
        $Width = 16
    )

    foreach ($item in $Range) {
        Set-ExcelRange -Worksheet $Worksheet -Range $Range -Width $Width
    }

    Close-ExcelPackage $pkg
}

Import-Module "$PSScriptRoot\..\..\PSAdvantage.psd1" -Force

$xlfile = "$PSScriptRoot/gha.xlsx"
Remove-Item $xlfile -ErrorAction SilentlyContinue

$ghp = @{
    owner = $owner 
    repo  = $repo
    raw   = $raw
}

$p = @{
    Path          = $xlfile 
    AutoFilter    = $true
    AutoNameRange = $true
    AutoSize      = $true
}

Get-GHRepo @ghp | Export-Excel @p -WorksheetName Repo

$pkg = Get-GHWorkflow @ghp | Export-Excel @p -WorksheetName Workflows -PassThru

SetWithOnColumns $pkg.Workflows "Created", "Updated" 

$pkg = Get-GHRun @ghp | Export-Excel @p -WorksheetName Runs -PassThru
SetWithOnColumns $pkg.Runs "Created", "Updated" 

$pkg = Get-GHJob @ghp | Export-Excel @p -WorksheetName Jobs -PassThru
SetWithOnColumns $pkg.Jobs "Started", "Completed" 

$data = Get-GHJobSteps @ghp
$pkg = $data | Export-Excel @p -WorksheetName JobSteps -PassThru
SetWithOnColumns $pkg.JobSteps "started_at", "completed_at" 

Invoke-Item $xlfile