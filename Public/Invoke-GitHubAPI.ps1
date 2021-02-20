function Invoke-GitHubAPI {
    <#
        .Synopsis
        .Example
    #>
    param(
        [Parameter(Mandatory)]
        $Uri,
        [ValidateSet('Default', 'Delete', 'Get', 'Head', 'Merge', 'Options', 'Patch', 'Post', 'Put', 'Trace')]
        $Method = 'Get',
        $Body,
        $OutFile,
        $AccessToken,
        [Switch]$SilentlyContinue
    )

    try {
        Invoke-RestMethod -Uri $uri -Headers (Get-GitHubAuthHeader -AccessToken $AccessToken) -Method $Method -Body $Body -OutFile $OutFile -ErrorVariable errVar
    }
    catch {
        if ($errVar) {
            $targetMessage = $errVar
        }
        else {
            $targetMessage = $_.Exception
        }
        
        $msg = ($targetMessage.Message | ConvertFrom-Json | Select-Object -ExpandProperty message)        
        if ($msg -match '^bad credentials$') {
            Write-Warning $msg
        }
        elseif ($msg -match '^You have to supply an access token') {
            Write-Warning $msg
        }
        elseif (!$SilentlyContinue) {
            Write-Warning $msg
        }
    }
}