param(
    [Parameter(Mandatory)]
    $owner,
    $reponame = 'pstest'
)

Import-PSAdvantageConfig D:\temp\scratch\config.ps1 # imports config with GitHub Access Token

Invoke-Advantage -owner $owner -reponame pstest -template cron -command "Test-Connection microsoft.com" 