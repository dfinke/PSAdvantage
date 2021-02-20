function Get-GHFileSHA {
    <#
        .Synopsis
            Gets the contents of a file or directory in a repository, and returns the `sha`
      
        .Example
        Get-GHFileSHA powershell powershell .github/workflows/daily.yml
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

    (Invoke-GitHubAPI -Uri $url -AccessToken $AccessToken).sha
}