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
    
    Process {
        Get-GHLatestJob -owner $owner -repo $repo -AccessToken $AccessToken -Wait:$wait -Raw | Out-GHJobSteps
    }
}