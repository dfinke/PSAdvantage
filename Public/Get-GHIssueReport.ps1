#Requires -Modules ImportExcel
function Get-GHIssueReport {
    <#
        .SYNOPSIS
        Get issues in a GitHub repository, and save them to Excel, and make a pivot table
        
        .EXAMPLE
        Get-GHIssueReport dfinke/importexcel
        
        .EXAMPLE
        Get-GHIssueReport dfinke/importexcel -state all
    #>
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