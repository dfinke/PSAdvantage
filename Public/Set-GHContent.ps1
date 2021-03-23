function Set-GHContent {
    <#
        .Synopsis
    #>
    param (
        [Parameter(Mandatory)]
        $owner,
        [Parameter(Mandatory)]
        $reponame,
        [Parameter(Mandatory)]
        $path,
        [Parameter(Mandatory)]
        $content,
        $AccessToken     
    )

    $url = 'https://api.github.com/repos/{0}/{1}/contents/{2}' -f $owner, $reponame, $path

    $payload = @{
        "content" = (ConvertTo-Base64String $content)
        "message" = 'Added content'
    } 

    if (!(Test-GHRepo -owner $owner -reponame $reponame -AccessToken $AccessToken)) {        
        New-GHRepo $reponame $reponame -AccessToken $AccessToken
    }

    if (Test-GHPath -owner $owner -repo $reponame -path $path -AccessToken $AccessToken) {
        $payload.sha = Get-GHFileSHA -owner $owner -repo $reponame -path $path -AccessToken $AccessToken
    }
    
    $payload = $payload | ConvertTo-Json
    
    $result = Invoke-GitHubAPI -Uri $url -Method Put -Body $payload -AccessToken $AccessToken
    if ($result) {
        Write-ToConsole +  -text "$path pushed $owner $path"
    }
}