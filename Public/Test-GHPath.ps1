function Test-GHPath {
    <#
        .Synopsis
        Determines whether all elements of a GitHub path exists
        
        .Example
    #>
    param(
        [Parameter(Mandatory)]
        $owner,
        [Parameter(Mandatory)]
        $repo,
        [Parameter(Mandatory)]
        $path,
        $AccessToken
    )

    $url = "https://api.github.com/repos/{0}/{1}/contents/{2}" -f $owner, $repo, $path

    $result = Invoke-GitHubAPI -Uri $url -SilentlyContinue -AccessToken $AccessToken
    if ($result) {
        $true
    }
    else {
        $false
    }
}