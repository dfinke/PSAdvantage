function Get-GHMetrics {
    <#
        .Synopsis
        Gets GitHub metrics on repositories

        .Example
        Get-GHMetrics powershell/powershell -AccessToken f6080a507cc3775f5e1ea3aec53518973f5ee8d6

Date                 Owner      Name       IsPrivate Issues PullRequests Releases Stargazers Watchers ForkCount
----                 -----      ----       --------- ------ ------------ -------- ---------- -------- ---------
3/30/2021 3:51:55 PM powershell PowerShell     False   8894         5903       93      25494     1298      4065

        .Example
        'spinnaker/spinnaker','argoproj/argo','fluxcd/flux' | Get-GHMetrics | Format-Table

Date                 Owner     Name           IsPrivate Issues PullRequests Releases Stargazers Watchers ForkCount
----                 -----     ----           --------- ------ ------------ -------- ---------- -------- ---------
3/30/2021 3:52:11 PM spinnaker spinnaker          False   4860         1516       70       7739      363      1076
3/30/2021 3:52:11 PM argoproj  argo-workflows     False   2919         2551      122       8007      177      1432
3/30/2021 3:52:11 PM fluxcd    flux               False   1564         1835       77       6189      114      1069

    #>
    [CmdletBinding()]
    param(
        # [parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName=$True)]
        [Parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        $slug,
        $owner,
        $repo,
        $AccessToken
    )

    Process {
        if ($slug) {
            if ($slug.slug) {
                $slug = $slug.slug
            }
            
            $owner, $repo = $slug -split '/'
        }

        if (!$owner) {
            throw 'owner not supplied'
        }

        if (!$repo) {
            throw 'repo not supplied'
        }

        $query = @"
query { 
    repository( owner: "$owner", name: "$repo" ) {
        name
        isPrivate
        issues{totalCount}
        pullRequests{totalCount}
        releases{totalCount}
        stargazers{totalCount}
        watchers{totalCount}
        forkCount

        defaultBranchRef {
            name
            target {
                ... on Commit {
                history(first: 1) {
                    edges {
                    node {
                        committedDate
                    }
                    }
                    totalCount
                }
                }
            }
            }
        
    }
}
"@

        Write-Verbose $query
        Write-Verbose 'https://docs.github.com/en/graphql/overview/explorer'

        $q = ConvertTo-Json @{query = $query }

        $r = Invoke-GitHubAPI -Uri ("$(Get-GHBaseRestURI)/graphql") -Body $q -Method Post -AccessToken $AccessToken
        $repoStats = $r.data.repository
        
        [PSCustomObject][Ordered]@{
            TimeStamp     = Get-Date
            Owner         = $owner
            Name          = $repoStats.name
            IsPrivate     = $repoStats.isPrivate
            Issues        = $repoStats.issues.totalCount
            PullRequests  = $repoStats.pullRequests.totalCount
            Releases      = $repoStats.releases.totalCount
            Stargazers    = $repoStats.stargazers.totalCount
            Watchers      = $repoStats.watchers.totalCount
            ForkCount     = $repoStats.forkCount

            TotalCommits  = $repoStats.defaultBranchRef.target.history.totalcount
            LastCommit    = $repoStats.defaultBranchRef.target.history.edges.node.committedDate
            defaultBranch = $repoStats.defaultBranchRef.Name
        }
    }
}