function Get-GHIssue {
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
        
        Write-Progress -Activity "Getting" -Status "$($state) pull requests for repo $($slug)"
        $result = (Invoke-GitHubAPI "https://api.github.com/repos/$($slug)/issues?state=$($state)" -FollowRelLink -MaximumFollowRelLink $NumberOfPages)
        # if (!$IncludePullRequests) {
        #     $result = $result | where-object { $null -eq $_.pull_request }    
        # }

        if ($Raw) {
            $result
        }
        else {
            foreach ($item in $result) {
                foreach ($i in $item) {
                    $created = Get-Date $i.created_at

                    $closedDate = $i.closed_at
                    if ($i.state -eq 'open') { $closedDate = Get-Date }

                    [PSCustomObject][Ordered]@{
                        Created       = $created.ToShortDateString()
                        DaysOpen      = ($closedDate - $created).Days
                        ReviewerCount = $i.requested_reviewers.Count
                        State         = $i.state
                        Title         = $i.title
                        Repo          = $slug
                    }
                }
            }
        }
    }
}
