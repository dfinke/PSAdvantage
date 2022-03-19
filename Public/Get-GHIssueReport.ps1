#Requires -Modules ImportExcel
function Get-GHIssueReport {
    param(
        [Parameter(ValueFromPipeline)]
        [string[]]$slug,
        [ValidateSet("open", "closed", "all")]
        $state = 'all',
        $XLFilename = "./GitHubStats.xlsx",        
        [int]$NumberOfPages = 1
    )

    Begin {
        $script:data = @()
    }

    Process {
        $data += foreach ($item in $slug) {
            Get-GHIssue $item -state $state -NumberOfPages $NumberOfPages
        }
    }        

    End {
        ExportReport Issues $data -XLFilename $XLFilename
    }
}