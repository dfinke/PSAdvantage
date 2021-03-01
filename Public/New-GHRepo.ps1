function New-GHRepo {
    <#
        .Synopsis
        Creates a new private GitHub repository

        .Example
        New-GHRepo -reponame pstest
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        $reponame,

        $description = 'My Custom Automation Setup',

        [Switch]$IsPublic,

        $AccessToken,

        [switch]$clone,

        $GitFolder
    )

    Write-ToConsole * INFO 'Trying to create repository ...'
    $payload = @{
        "name"        = $reponame
        "description" = $description
        "private"     = if ($IsPublic) { $false } else { $true }
    } | ConvertTo-Json

    $url = 'https://api.github.com/user/repos'
    $result = Invoke-GitHubAPI -Uri $url -Method Post -Body $payload -AccessToken $AccessToken

    Write-ToConsole + -Text "Successfully created: $($result.html_url)"

    if ($clone) {
        Invoke-GHClone -Url $result.clone_url -RepoName $reponame -GitFolder $GitFolder
    }
}