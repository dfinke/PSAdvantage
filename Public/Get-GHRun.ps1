function Get-GHRun {
    <#
        .Synopsis
        Lists all workflow runs for a repository

        .Example
        Get-GHRun powershell powershell
    #>
    param(
        [Parameter(Mandatory)]
        $owner,
        [Parameter(Mandatory)]
        $repo,
        $conclusion,
        $AccessToken,
        [Switch]$Raw
    ) 

    $url = "https://api.github.com/repos/{0}/{1}/actions/runs" -f $owner, $repo
    $result = Invoke-GitHubAPI -Uri $url -AccessToken $AccessToken

    if ($result) {
        foreach ($item in $result.workflow_runs | Where-Object { $_.conclusion -match $conclusion }) {
            if ($Raw) {
                $item
            }
            else {                            
                [PSCustomObject][Ordered]@{
                    RunId      = $item.Id
                    Name       = $item.name
                    Event      = $item.event 
                    Status     = $item.status
                    Conclusion = $item.conclusion
                    Created    = $item.created_at
                    Updated    = $item.updated_at
                    LogsUrl    = $item.logs_url
                    Owner      = $owner
                    Repo       = $repo

                }
            }
        }
    }
}