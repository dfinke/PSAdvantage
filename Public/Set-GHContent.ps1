function Set-GHContent {
    <#
        .Synopsis
        Creates a new file or replaces an existing file in a repository

        .Example
        dir *.ps1 | Set-GHContent dfinke pstest

        .Example
        dir *.ps1 | Set-GHContent dfinke pstest public/test

        .Example
        Set-GHContent dfinke pstest -FullName .\test.ps1
    #>
    param (
        [Parameter(Mandatory)]
        $owner,
        [Parameter(Mandatory)]
        $reponame,
        [Parameter(ValueFromPipelineByPropertyName)]
        $FullName,
        $gitHubPath,
        $AccessToken,
        [Switch]$View
    )

    Process {
        $targetFile = Split-Path -Leaf $FullName
        
        $outPath = $targetFile                    
        if ($gitHubPath) {
            $outPath = "$gitHubPath/$($targetFile)"
        }

        $url = 'https://api.github.com/repos/{0}/{1}/contents/{2}' -f $owner, $reponame, $outPath
        
        $content = [System.IO.File]::ReadAllText((Resolve-Path $FullName))
        $payload = @{
            "content" = (ConvertTo-Base64String $content)
            "message" = 'Added content'
        } 

        if (!(Test-GHRepo -owner $owner -reponame $reponame -AccessToken $AccessToken)) {        
            New-GHRepo $reponame $reponame -AccessToken $AccessToken
        }

        if (Test-GHPath -owner $owner -repo $reponame -path $outPath -AccessToken $AccessToken) {
            $payload.sha = Get-GHFileSHA -owner $owner -repo $reponame -path $outPath -AccessToken $AccessToken
        }
    
        $payload = $payload | ConvertTo-Json
    
        $result = Invoke-GitHubAPI -Uri $url -Method Put -Body $payload -AccessToken $AccessToken
        if ($result) {
            Write-ToConsole + -text "$FullName pushed to $owner $outPath"
        }
    }
    
    End {
        if ($View) {
            Start-Process ('https://github.com/{0}/{1}' -f $owner, $reponame)
        }
    }
}