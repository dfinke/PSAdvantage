function Get-GHJobSteps {
    <#
        .Synopsis

        .Example

    #>
    param(
        [Parameter(ValueFromPipelineByPropertyName, Mandatory)]
        $owner,
        [Parameter(ValueFromPipelineByPropertyName, Mandatory)]
        $repo,
        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('id')]
        $runId,
        $AccessToken
    )

    Process {                        
        Get-GHJob -owner $owner -repo $repo -runId $runId -AccessToken $AccessToken -Raw | Out-GHJobSteps
    }
}
