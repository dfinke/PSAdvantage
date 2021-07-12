function New-GHIssue {
    <#
        .SYNOPSIS
            Create a new issue on GitHub Repo

        .EXAMPLE
        New-GHIssue -slug dfinke/pstest -Title "My New Issue" -Body "This is my new issue" -labels bug

        .EXAMPLE
        # Add same issue to multiple repos
        echo dfinke/pstest1, dfinke/pstest2 | New-GHIssue "My New Issue" "This is my new issue" -labels bug, documentation
    #>
    param (
        [Parameter(Mandatory)]
        $title,
        [Parameter(Mandatory)]
        $body,
        [Parameter(Mandatory, ValueFromPipeline)]
        $slug,
        $labels,
        $AccessToken
    )

    Process {
        Write-ToConsole * INFO 'Trying to create issue  ...'
        $payload = @{
            "title" = $title
            "body"  = $body    
        } 
    
        if ($labels) {
            $payload.labels = @($labels)
        }
    
        $payload = $payload | ConvertTo-Json
  
        $url = '{0}/repos/{1}/issues' -f (Get-GHBaseRestURI), $slug

        $result = Invoke-GitHubAPI -Uri $url -Method Post -Body $payload -AccessToken $AccessToken

        if ($result) {
            Write-ToConsole + -Text "Successfully created issue for $($slug)"
        }
    }
}