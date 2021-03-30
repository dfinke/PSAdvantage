function Get-GHMetrics {
    <#
        .Synopsis
        Gets GitHub metrics on repositories

        .Example
        Get-GHMetrics powershell/powershell -AccessToken f6080a507cc3775f5e1ea3aec53518973f5ee8d6
        
Date                  Owner      Name       issues pullRequests releases stargazers watchers forkCount
----                  -----      ----       ------ ------------ -------- ---------- -------- ---------
3/27/2021 10:38:59 AM powershell PowerShell   8882         5900       93      25453     1294      4056

        .Example
        'spinnaker/spinnaker','argoproj/argo','fluxcd/flux' | Get-GHMetrics | Format-Table

Date                  Owner     Name           issues pullRequests releases stargazers watchers forkCount
----                  -----     ----           ------ ------------ -------- ---------- -------- ---------
3/27/2021 10:46:52 AM spinnaker spinnaker        4854         1516       70       7732      363      1074
3/27/2021 10:46:52 AM argoproj  argo-workflows   2906         2544      122       7983      177      1430
3/27/2021 10:46:52 AM fluxcd    flux             1563         1835       77       6185      115      1069


    #>
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline)]
        $slug,
        $owner,
        $repo,
        $AccessToken
    )

    Process {
        if ($slug) {
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
    repository( owner: "$owner" name: "$repo" ) {
        name
        isPrivate
        issues{totalCount}
        pullRequests{totalCount}
        releases{totalCount}
        stargazers{totalCount}
        watchers{totalCount}    
        forkCount
    }
}
"@

        Write-Verbose $query
        Write-Verbose 'https://docs.github.com/en/graphql/overview/explorer'

        $q = ConvertTo-Json @{query = $query }

        $r = Invoke-GitHubAPI -Uri ("$(Get-GHBaseRestURI)/graphql") -Body $q -Method Post -AccessToken $AccessToken
        $repoStats = $r.data.repository

        [PSCustomObject][Ordered]@{
            Date         = Get-Date
            Owner        = $owner
            Name         = $repoStats.name
            IsPrivate    = $repoStats.isPrivate
            Issues       = $repoStats.issues.totalCount
            PullRequests = $repoStats.pullRequests.totalCount
            Releases     = $repoStats.releases.totalCount
            Stargazers   = $repoStats.stargazers.totalCount
            Watchers     = $repoStats.watchers.totalCount
            ForkCount    = $repoStats.forkCount
        }
    }
}