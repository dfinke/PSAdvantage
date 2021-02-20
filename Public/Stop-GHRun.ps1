function Stop-GHRun {
    <#
        .Synopsis
        Stops a workflow run using its id

        .Example
        Stop-GHRun -owner target -repo pstest -runId 559299780
    #>
    param(
        [Parameter(ValueFromPipelineByPropertyName, Mandatory)]
        $owner,
        [Parameter(ValueFromPipelineByPropertyName, Mandatory)]
        $repo,
        [Parameter(ValueFromPipelineByPropertyName, Mandatory)]
        [Alias('id')]
        $runId
    )

    Process {
        $url = 'https://api.github.com/repos/{0}/{1}/actions/runs/{2}/cancel' -f $owner, $repo, $runId
        Invoke-GitHubAPI -Uri $url -Method Post
    }
}