function Get-GHIssue {
    <#
        .SYNOPSIS
        Get issues in a GitHub repository
        
        .EXAMPLE
        Get-GHIssue dfinke/importexcel
        
        .EXAMPLE
        # Get all issues, both open and closed
        Get-GHIssue dfinke/importexcel -state all

        .EXAMPLE
        # Get open issues, and go back 3 pages worth of issues
        Get-GHIssue dfinke/importexcel -NumberOfPages 3

        .EXAMPLE
        # Get open issues, including Pull Requests
        Get-GHIssue dfinke/importexcel -IncludePullRequests

        .EXAMPLE
        # Get open issues, return all the data from GitHub
        Get-GHIssue dfinke/importexcel -Raw
    #>

    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline)]
        $slug,
        [ValidateSet("open", "closed", "all")]
        $state = "open",
        # Number of pages to retrieve        
        $NumberOfPages = 1,
        [Switch]$IncludePullRequests,
        [Switch]$Raw
    )
    
    Process {
        if (!$slug) {
            Write-Warning "Slug not specified and is required"
            return
        }
        
        Write-Progress -Activity "Getting" -Status "$($state) issues for repo $($slug)"
        $result = (Invoke-GitHubAPI "https://api.github.com/repos/$($slug)/issues?state=$($state)" -FollowRelLink -MaximumFollowRelLink $NumberOfPages)
        # if (!$IncludePullRequests) {
        #     $result = $result | where-object { $null -eq $_.pull_request }    
        # }

        if ($Raw) {
            $result
        }
        else {
            TransformIssuesAndPullRequests $result
        }
    }
}
