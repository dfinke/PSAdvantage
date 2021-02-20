function Get-GHLog {
    <#
        .Synopsis
        Download a plain text file of logs for a workflow job
        
        .Example
    #>
    param(
        $LogPath,
        $AccessToken,
        [Parameter(ValueFromPipelineByPropertyName)]
        $LogsUrl
    )

    Process {
        if (!(Test-Path $LogPath)) {
            $null = mkdir $LogPath            
        }

        Write-ToConsole * INFO 'Trying to download logs  ...'
        
        $fullName = "$LogPath/log.zip"
        Invoke-GitHubAPI -Uri $LogsUrl -OutFile $fullName -AccessToken $AccessToken
 
        if (Test-Path $fullName) {
            Write-ToConsole * INFO "Expanding zip: $($fullName)"
            Expand-Archive -LiteralPath $fullName -DestinationPath $LogPath -Force
        }
    }
}