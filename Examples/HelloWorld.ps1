param(
    [Parameter(Mandatory)]
    $owner,
    $reponame = 'pstest'
)

Import-PSAdvantageConfig D:\temp\scratch\config.ps1 # imports config with GitHub Access Token

Invoke-Advantage -owner $owner -reponame $reponame -template basic-powershell -command "'Hello from PowerShell, in GitHub Actions'"