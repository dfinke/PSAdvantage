function Get-GHLatestJob {
    <#
        .Synopsis
        Gets the last job that ran for the specified repo 

        .Example
        Get-GHLatestJob powershell powershell
    #>
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        $owner,
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        $repo,
        $AccessToken,
        [Switch]$Raw,
        [Switch]$wait
    )
    
    Process {
        if ($wait) {
            (Get-GHLatestRun -owner $owner -repo $repo -AccessToken $AccessToken) | Get-GHJob -AccessToken $AccessToken -Raw:$Raw
            $r = (Get-GHLatestRun -owner $owner -repo $repo -AccessToken $AccessToken) | Get-GHJob -AccessToken $AccessToken -Raw:$Raw | Where-Object { $_.Status -ne 'completed' }
            while ($r.count -gt 0) {
                Write-ToConsole * INFO "[$(Get-Date)] Waiting on $($r.count) job(s) to complete: $($r.Name)"
            
                $r = (Get-GHLatestRun -owner $owner -repo $repo -AccessToken $AccessToken) | Get-GHJob -AccessToken $AccessToken -Raw:$Raw | Where-Object { $_.Status -ne 'completed' }
                Start-Sleep -Seconds 10
            }
            ''
            (Get-GHLatestRun -owner $owner -repo $repo -AccessToken $AccessToken) | Get-GHJob -AccessToken $AccessToken -Raw:$Raw
        }
        else {
            (Get-GHLatestRun -owner $owner -repo $repo -AccessToken $AccessToken) | Get-GHJob -AccessToken $AccessToken -Raw:$Raw
        }
    }
}
