function Get-GHJob {
    <#
        .Synopsis
        Lists workflow jobs. A workflow job is a set of steps that execute on the same runner

        .Example
        Get-GHJob -owner powershell -repo powershell

        .Example
        Get-GHJob -owner powershell -repo powershell -runId 543239692

        .Example
        Get-GHRun -owner powershell -repo powershell | Get-GHJob
        #>
    param(
        [Parameter(ValueFromPipelineByPropertyName, Mandatory)]
        $owner,
        [Parameter(ValueFromPipelineByPropertyName, Mandatory)]
        $repo,
        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('id')]
        $runId,
        $AccessToken,
        [Switch]$Raw
    ) 

    Process {
        if (!$runId) {
            foreach ($item in Get-GHRun $owner $repo -AccessToken $AccessToken) {
                $url = "https://api.github.com/repos/{0}/{1}/actions/runs/{2}/jobs" -f $owner, $repo, $item.RunId
                Invoke-GitHubAPI $url -AccessToken $AccessToken | Out-GHJobInfo -Raw:$Raw
            }            
        }
        else {
            $url = "https://api.github.com/repos/{0}/{1}/actions/runs/{2}/jobs" -f $owner, $repo, $runId            
            Invoke-GitHubAPI $url -AccessToken $AccessToken | Out-GHJobInfo -Raw:$Raw
        }
    }
}