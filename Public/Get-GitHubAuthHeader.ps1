function Get-GitHubAuthHeader {
    <#
        .Synopsis
        Returns a hashtable useable in as a header to call the GitHub REST API with a GitHub Token

        .Description

        .Example
    #>
    param(
        $AccessToken
    )

    if ($null -eq $config.AccessToken -and $null -eq $AccessToken) {
        $msg = @{
            message = 'You have to supply an access token via -AccessToken or the config.ps1 file for this tool to work!'
        } | ConvertTo-Json

        throw $msg
    }

    if ($config.AccessToken) {
        $token = $config.AccessToken
    }
    else {
        $token = $AccessToken
    }

    return @{"Authorization" = "token $($token)" }
}