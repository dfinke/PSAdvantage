#Requires -Modules ImportExcel
function Get-GHPullRequestReport {
    param(
        [Parameter(ValueFromPipeline)]
        [string[]]$slug,
        [ValidateSet("open", "closed", "all")]
        $state = 'all',
        [int]$NumberOfPages = 1
    )

    Begin {
        $script:data = @()
    }

    Process {
        $data += foreach ($item in $slug) {
            Get-GHPullRequest $item -state $state -NumberOfPages $NumberOfPages
        }
    }        

    End {
        ExportReport PullRequests $data 
    }
}