function Remove-GHSecret {
    <#
        .Synopsis
        Deletes a secret in a repository using the secret name

        .Example
        Remove-GHSecret dfinke pstest test 

        .Example
        Remove-GHSecret dfinke pstest test -Confirm
    #> 
    param(
        [Parameter(Mandatory)]
        $owner,
        [Parameter(Mandatory)]
        $reponame,
        [Parameter(Mandatory)]
        $secretName,
        $AccessToken,
        [Switch]$Confirm
    )

    if (!$Confirm) {
        $message = "This will delete the secret $secretName from repo $($owner)/$($reponame) - type Y to confirm"
        $result = Read-Host $message
        if ($result -ne "y") {
            return
        }
    }

    if (Test-GHSecret $owner $reponame $secretName -AccessToken $AccessToken) {
        $url = "{0}/repos/{1}/{2}/actions/secrets/{3}" -f (Get-GHBaseRestURI), $owner, $reponame, $secretName

        $result = Invoke-GitHubAPI -Uri $url -Method Delete -AccessToken $AccessToken
        Write-ToConsole * INFO "Removed secret $secretName from $owner/$reponame"
    }
    else {
        Write-ToConsole * INFO "Nothing to remove - secret $secretName in $owner/$reponame not found"
    }
}