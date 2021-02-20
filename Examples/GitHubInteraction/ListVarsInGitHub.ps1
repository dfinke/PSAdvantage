param(
    [Parameter(Mandatory)]
    $owner,
    $reponame = 'pstest'
)

Import-PSAdvantageConfig D:\temp\scratch\config.ps1 # imports config with GitHub Access Token

# List the ENV: variables when run on GitHub
Invoke-Advantage -owner $owner -reponame $reponame -template basic-powershell -command "dir env:"