function Remove-GHRepo {
    <#
        .Synopsis
        Removes a repository
        
        .Description 
        Deleting a repository requires admin access. The delete_repo scope is required.
        
        .Example
        Remove-GHRepo user reponame 

        .Example
        Remove-GHRepo user reponame -Confirm
    #>
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        $owner,
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [Alias('repo')]
        $reponame,
        $AccessToken,
        [Switch]$Confirm
    )
    
    Process {
        if (!$Confirm) {
            $message = "This will delete repo $($owner)/$($reponame) - type Y to confirm"
            $result = Read-Host $message
            if ($result -ne "y") {
                return
            }
        }
    
        if (Test-GHRepo $owner $reponame -AccessToken $AccessToken) {
            $url = 'https://api.github.com/repos/{0}/{1}' -f $owner, $reponame
            $result = Invoke-GitHubAPI -Uri $url -Method Delete -AccessToken $AccessToken
            Write-ToConsole * INFO "Removed $owner/$reponame"
        }
        else {
            Write-ToConsole * INFO "Nothing to remove - $owner/$reponame not found"
        }
    }
}