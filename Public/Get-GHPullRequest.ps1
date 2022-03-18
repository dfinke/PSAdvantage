function Get-GHPullRequest {
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
