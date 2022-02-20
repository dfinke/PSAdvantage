function Find-GHRepoByUser {
    param(
        [Parameter(Mandatory)]
        $user,
        $AccessToken,
        [Switch]$BasicProperties,
        [Switch]$Raw
    )

    $uri = (Get-GHBaseRestURI) + "/search/repositories?q=user:$($user)&per_page=100"    
    try {
        $result = Invoke-RestMethod -Uri $uri -Headers (Get-GitHubAuthHeader -AccessToken $AccessToken) -FollowRelLink -MaximumFollowRelLink 10 
        if ($Raw) {
            $result
        }
        elseif ($BasicProperties) {
            $result.Items | Select-Object created_at, name, full_name, private
        }
        else {
            $result.Items
        }
    }
    catch {
        ($Error[0].ErrorDetails.Message | ConvertFrom-Json).errors.message
    }
}

