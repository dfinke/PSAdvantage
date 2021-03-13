function Remove-GHRepoWorkflowFile {
    <#
        .Synopsis
        Deletes a file in a repository
        
        .Example
        Remove-GHRepoWorkflowFile dfinke pstest basic-powershell.yml 
    #>

    param(
        [Parameter(Mandatory)]
        $owner,
        [Parameter(Mandatory)]
        $repo,
        [Parameter(Mandatory)]
        $fileName,
        $AccessToken,
        [Switch]$Confirm
    )

    $path = ".github/workflows/$fileName"

    if (!$Confirm) {
        $message = "This will delete file $($filename) in $($owner)/$($repo) - type Y to confirm"
        $result = Read-Host $message
        if ($result -ne "y") {
            return
        }
    }

    if (Test-GHPath -owner $owner -repo $repo -path $path -AccessToken $AccessToken) {    
        # Needs a confirm message

        # Needs to write log messages

        $payload = @{
            "message" = "Removed $path"
        } 
    
        $payload.sha = Get-GHFileSHA -owner $owner -repo $repo -path $path -AccessToken $AccessToken
    
        $url = 'https://api.github.com/repos/{0}/{1}/contents/{2}' -f $owner, $repo, $path    
    
        $result = Invoke-GitHubAPI -Uri $url -Method Delete -Body ($payload | ConvertTo-Json)

        if ($result) {
            Write-ToConsole + -Text $result.commit.message
        }
    }
    else {
        "Not found"
    }
}