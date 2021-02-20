param(
    [Parameter(Mandatory)]
    $owner,
    $reponame = 'pstest'
)

Import-PSAdvantageConfig D:\temp\scratch\config.ps1 # imports config with GitHub Access Token

# Grab the GitHub event info and convert it from JSON
$command = @'
$r = Get-Content -raw $env:GITHUB_EVENT_PATH | ConvertFrom-Json
$r
'@

Invoke-Advantage -owner dfinke -reponame pstest -template basic-powershell -command $command