function Get-GHSecret {
    <#
        .Synopsis
        Gets the secrets name for the specified repo
        
        .Description
        If the repo has no secret, noting is returned

        .Example
        'importexcel','pstest','pskit' | foreach {Get-GHSecret dfinke $_}

        Owner  Repo   name  created_at           updated_at
        -----  ----   ----  ----------           ----------
        dfinke pstest TEST  3/12/2021 3:16:17 PM 3/12/2021 3:16:17 PM
        dfinke pstest TEST1 3/12/2021 3:21:15 PM 3/12/2021 3:21:15 PM

        .Example
        'importexcel','pstest','pskit' | foreach {Get-GHSecret dfinke $_ -Raw}

        Owner  Repo        total_count secrets
        -----  ----        ----------- -------
        dfinke importexcel           0 {}
        dfinke pstest                2 {@{name=TEST; created_at=3/12/2021 3:16:17 PM; updated_at=3/12/2021 3:16:17 PM}, @{name=ΓÇª
        dfinke pskit                 0 {}
    #>
    param(
        [Parameter(ValueFromPipelineByPropertyName, Mandatory)]
        $owner,
        [Parameter(ValueFromPipelineByPropertyName, Mandatory)]
        $repo,
        $secretName,
        $AccessToken,
        [Switch]$Raw,
        [Switch]$SilentlyContinue
    )

    Process {
        
        if ($secretName) {
            $url += '{0}/repos/{1}/{2}/actions/secrets/{3}' -f (Get-GHBaseRestURI), $owner, $repo, $secretName
        }
        else {
            $url = '{0}/repos/{1}/{2}/actions/secrets' -f (Get-GHBaseRestURI), $owner, $repo
        }

        Write-Verbose $url

        $result = Invoke-GitHubAPI -Uri $url -AccessToken $AccessToken -SilentlyContinue:$SilentlyContinue

        if ($secretName) {
            $result |
            Add-Member -PassThru -MemberType NoteProperty -Name Owner -Value $owner |
            Add-Member -PassThru -MemberType NoteProperty -Name Repo -Value $repo | 
            Select-Object Owner, Repo, name, created_at, updated_at
        }
        else {
            $result = $result |
            Add-Member -PassThru -MemberType NoteProperty -Name Owner -Value $owner |
            Add-Member -PassThru -MemberType NoteProperty -Name Repo -Value $repo | 
            Select-Object Owner, Repo, total_count, secrets 

            if ($Raw) {
                $result
            }
            else {
                foreach ($secret in $result.secrets) {
                    [PSCustomObject][Ordered]@{
                        Owner      = $owner
                        Repo       = $repo
                        name       = $secret.name
                        created_at = $secret.created_at
                        updated_at = $secret.updated_at                
                    }            
                }
            }
        }   
    }
}