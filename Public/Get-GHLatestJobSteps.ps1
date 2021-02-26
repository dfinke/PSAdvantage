function Get-GHLatestJobSteps {
    <#
        .Synopsis

        .Example

    #>
    param(
        [Parameter(Mandatory)]
        $owner,
        [Parameter(Mandatory)]
        $repo,
        $AccessToken,
        [Switch]$wait
    )

    Get-GHLatestJob -owner $owner -repo $repo -AccessToken $AccessToken -Wait:$wait -Raw | Out-GHJobSteps
}