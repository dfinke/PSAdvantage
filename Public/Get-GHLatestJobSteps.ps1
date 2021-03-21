function Get-GHLatestJobSteps {
    <#
        .Synopsis

        .Example

    #>
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        $owner,
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        $repo,
        $AccessToken,
        [Switch]$wait
    )

    <#

runName name                         status    conclusion number started_at           completed_at
------- ----                         ------    ---------- ------ ----------           ------------
build   Set up job                   completed success         1 3/16/2021 6:02:03 PM 3/16/2021 6:02:06 PM
build   Run actions/checkout@v2      completed success         2 3/16/2021 6:02:06 PM 3/16/2021 6:02:07 PM
build   Run the scripts              completed success         3 3/16/2021 6:02:07 PM 3/16/2021 6:02:18 PM
build   Post Run actions/checkout@v2 completed success         6 3/16/2021 6:02:18 PM 3/16/2021 6:02:18 PM
build   Complete job                 completed success         7 3/16/2021 6:02:18 PM 3/16/2021 6:02:18 PM

#>
    Process {        
        if ($wait) {
            #$r = (Get-GHLatestRun -owner $owner -repo $repo -AccessToken $AccessToken) | Get-GHJob -AccessToken $AccessToken -Raw:$Raw | Where-Object { $_.Status -ne 'completed' }
            #Get-GHLatestJob -owner $owner -repo $repo -AccessToken $AccessToken -Raw | Out-GHJobSteps
            
            $previousStep = ''
            Write-ToConsole * INFO "[$(Get-Date)] Monitoring ..."
            while ((Get-GHLatestJob -owner $owner -repo $repo -AccessToken $AccessToken).Status -ne 'completed') {                
                
                #"waiting"                
                $step = Get-GHLatestJob -owner $owner -repo $repo -AccessToken $AccessToken -Raw | Out-GHJobSteps | Select-Object Name, Status
                $step
                # $step = $step | Where-Object {$_.Status -ne 'completed'} | Select-Object -First 1

                # if ($step.Name -ne $previousStep.Name -or $step.Status -ne $previousStep.Status) {
                #     $previousStep = $step
                    
                #     Write-ToConsole * INFO "Last step run: $($step.Name) - $($step.Status)"
                # }

                Start-Sleep -Seconds 3
            }
            
            $step
            
            Write-ToConsole * INFO "Completed"
            
            #Get-GHLatestJob -owner $owner -repo $repo -AccessToken $AccessToken -Raw | Out-GHJobSteps
        }
        else {
            # Get-GHLatestJob -owner $owner -repo $repo -AccessToken $AccessToken -Wait:$wait -Raw | Out-GHJobSteps
            Get-GHLatestJob -owner $owner -repo $repo -AccessToken $AccessToken -Raw | Out-GHJobSteps
        }
    }
}