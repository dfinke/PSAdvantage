param(
    [Parameter(Mandatory)]
    $owner,
    $reponame = 'pstest'
)

Import-PSAdvantageConfig D:\temp\scratch\config.ps1 # imports config with GitHub Access Token

# Remove-Item ./logs -Recurse -Force -ErrorAction SilentlyContinue

$params = @{
    owner    = $owner
    reponame = $reponame
    template = 'basic-powershell' 
    command  = "'Hello, from PowerShell in GitHub Actions with logs'"
}

# Trigger a workflow
# Download the logs when is completes
Invoke-Advantage @params -saveLogs ./logs