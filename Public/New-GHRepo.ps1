function New-GHRepo {
    <#
        .Synopsis
        Creates a new private GitHub repository
      
        .Example
        New-GHRepo -reponame pstest
    #>
    param(
        [Parameter(Mandatory)]
        $reponame,
        $description = 'My Custom Automation Setup',
        [Switch]$IsPublic,
        $AccessToken,
        [switch]$clone
    )
        
    $payload = @{
        "name"        = $reponame
        "description" = $description
        "private"     = if ($IsPublic) { $false } else { $true }
    } | ConvertTo-Json
    
    $url = 'https://api.github.com/user/repos'    
    $result = Invoke-GitHubAPI -Uri $url -Method Post -Body $payload -AccessToken $AccessToken

    if ($clone) {
        git clone $result.clone_url ./custom/$reponame
    }
}
