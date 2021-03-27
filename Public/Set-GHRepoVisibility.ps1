function Set-GHRepoVisibility {
    <#
        .Synopsis
        Set the visibility of a repository

        .Example
        Set-GHRepoVisibility dfinke pstest public

        .Example
        Set-GHRepoVisibility dfinke pstest private
    #>

    param(
        [Parameter(Mandatory)]
        $owner,
        [Parameter(Mandatory)]
        $repo,
        [Parameter(Mandatory)]
        [ValidateSet('public', 'private')]
        $visibility,
        $AccessToken,
        [Switch]$Raw
    )

    $url = "$(Get-GHBaseRestURI)/repos/{0}/{1}" -f $owner, $repo

    $targetVisibility = $visibility -eq 'public' ? $false : $true

    $result = Invoke-GitHubAPI -Uri $url -Method Patch -Body (@{private = $targetVisibility } | ConvertTo-Json) -AccessToken $AccessToken

    if ($Raw) {
        $result
    } else {
        if($result) {
            Write-ToConsole + -Text "Visibilty for $owner $repo is now $visibility"
        }
    }
}