function Test-GHRepo {
    <#
        .Synopsis
        Determines if a GitHub repository exists

        .Example
    #>
    param(
        [Parameter(Mandatory)]
        $owner,
        [Parameter(Mandatory)]
        $reponame,
        $AccessToken
    )

    $url = "https://api.github.com/repos/{0}/{1}" -f $owner, $reponame

    $result = Invoke-GitHubAPI -Uri $url -SilentlyContinue -AccessToken $AccessToken
    if ($result) {
        $true
    }
    else {
        $false
    }
}