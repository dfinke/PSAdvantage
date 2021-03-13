function Get-GHRepo {
    <#
        .Synopsis
        Get info on a repo

        .Example
        Get-GHRepo microsoft vscode

        .Example
        # Show repo in a browser
        Get-GHRepo microsoft vscode -View
    #>
    param(
        [Parameter(Mandatory)]
        $owner,
        [Parameter(Mandatory)]
        $repo,
        $AccessToken,
        [Switch]$View,
        [Switch]$Raw
    )    

    $url = 'https://api.github.com/repos/{0}/{1}' -f $owner, $repo
    $result = Invoke-GitHubAPI $url -AccessToken $AccessToken

    if ($View -and $result) {
        Start-Process $result.html_url
        return
    }

    if (!$Raw) {
        if ($result) {
            [PSCustomObject][Ordered]@{
                Owner       = $owner
                Repo        = $result.Name
                FullName    = $result.full_name            
                Private     = $result.private
                HtmlUrl     = $result.html_url
                Description = $result.description
            }
        }
    }
    else {
        $result
    }
}