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

    if ($AccessToken) {
        $token = $AccessToken
    }
    elseif ($config.AccessToken) {
        $token = $config.AccessToken        
    }
    elseif ($env:PSAdvantageGHToken) {
        $token = $env:PSAdvantageGHToken
    }
    else {
        $msg = @{
            message = 'You have to supply an access token via -AccessToken, a config.ps1 file, or $env:PSAdvantageGHToken for this tool to work! https://github.com/dfinke/PSAdvantage/wiki/Setup'
        } | ConvertTo-Json

        throw $msg
    }

    return @{"Authorization" = "token $($token)" }
}