function Get-GHPullRequest {
    <#
        .SYNOPSIS
        Get pull requests in a GitHub repository
        
        .EXAMPLE
        Get-GHPullRequest dfinke/importexcel
        
        .EXAMPLE
        # Get all pull requests, both open and closed
        Get-GHPullRequest dfinke/importexcel -state all

        .EXAMPLE
        # Get open pull requests, and go back 3 pages worth of pull requests
        Get-GHPullRequest dfinke/importexcel -NumberOfPages 3

        .EXAMPLE
        # Get open pull requests, return all the data from GitHub
        Get-GHPullRequest dfinke/importexcel -Raw
    #>
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline)]
        $slug,
        [ValidateSet("open", "closed", "all")]
        $state = "open",
        # Number of pages to retrieve        
        $NumberOfPages = 1,
        [Switch]$Raw
    )
    
    Process {
        if (!$slug) {
            Write-Warning "Slug not specified and is required"
            return
        }
        
        Write-Progress -Activity "Getting" -Status "$($state) pull requests for repo $($slug)"
        $result = (Invoke-GitHubAPI "https://api.github.com/repos/$($slug)/pulls?state=$($state)" -FollowRelLink -MaximumFollowRelLink $NumberOfPages)        

        if ($Raw) {
            $result
        }
        else {
            TransformIssuesAndPullRequests $result
        }
    }
}
