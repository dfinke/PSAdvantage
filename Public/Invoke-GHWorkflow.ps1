function Invoke-GHWorkflow {
    <#
        .Synopsis
        Trigger a GitHub Actions workflow run

        .Example
        Invoke-GHWorkflow dfinke PSGitHubCLICrescendo 4394193

        .Example
        Get-GHWorkflow $owner $repo | Invoke-GHWorkflow
    #>
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipelineByPropertyName)]
        $owner,
        [Parameter(ValueFromPipelineByPropertyName)]
        $repo,
        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('id')]
        $workflowId,
        $AccessToken
    )

    Process {
        $baseurl = 'https://api.github.com/repos'

        $url = "https://api.github.com/repos/${owner}/${repo}/branches"
        $branchName = (Invoke-GitHubAPI -Uri $url -AccessToken $AccessToken).name

        $url = "$baseurl/{0}/{1}/actions/workflows/{2}/dispatches" -f $owner, $repo, $workflowId
            
        $payload = @{'ref' = $branchName} | ConvertTo-Json
            
        Invoke-GitHubAPI -Uri $url -Method Post -Body $payload -AccessToken $AccessToken
        Write-ToConsole + -text "Workflow triggered for $($owner)/$($repo) - getting initial status"
            
        Start-Sleep -Seconds 2
        $result = Get-GHLatestRun -owner $owner -repo $repo -AccessToken $AccessToken
        while ($null -eq $result) {
            $result = Get-GHLatestRun -owner $owner -repo $repo -AccessToken $AccessToken
            Start-Sleep -Milliseconds 350
        }

        $result
    }
}