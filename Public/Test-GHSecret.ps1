function Test-GHSecret {
    <#
        .Synopsis
        Test of the names secret exists in the specified repo
        
        .Example
        Test-GHSecret dfinke pstest test

        True
    #>
    param(
        [Parameter(ValueFromPipelineByPropertyName, Mandatory)]
        $owner,
        [Parameter(ValueFromPipelineByPropertyName, Mandatory)]
        $repo,
        [Parameter(Mandatory)]
        $secretName,               
        $AccessToken
    )
 
    Process {        
        $null -ne (Get-GHSecret $owner $repo $secretName -AccessToken $AccessToken -SilentlyContinue)
    }
}