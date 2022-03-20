function Get-GHAllReports {
    <#
        .SYNOPSIS
        Gets all metrics from a GitHub repo, Releases, Issues, and Pull Requests. Exports to Excel

        .Example 
        Get-GHAllReports dfinke/importexcel
    #>
    param(
        [Parameter(ValueFromPipeline)]
        [string[]]$slug,
        [ValidateSet("open", "closed", "all")]
        $state = 'all',
        $XLFilename = "./GitHubStats.xlsx",        
        [int]$NumberOfPages = 1
    )

    Process {
        Get-GHIssueReport -slug $slug -state $state -XLFilename $XLFilename -NumberOfPages $NumberOfPages
        Get-GHPullRequestReport -slug $slug -state $state -XLFilename $XLFilename -NumberOfPages $NumberOfPages        
        Get-GHReleaseReport -slug $slug -XLFilename $XLFilename -NumberOfPages $NumberOfPages
    }
}