[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    $Owner,

    [Parameter(Mandatory = $true)]
    $ConfigFile,

    [Parameter(Mandatory = $true)]
    $GitFolder,

    [Parameter(Mandatory =  $false)]
    $Repository = 'pstest'
)

# You need to create a config.ps1, and set up a personal access token there
if (Test-Path $ConfigFile) {
    Import-PSAdvantageConfig  $ConfigFile

    Remove-Item $GitFolder -Recurse -Force -ErrorAction SilentlyContinue

    Remove-GHRepo $Owner $Repository -Confirm

    New-GHRepo $Repository -clone -GitFolder $GitFolder

    "# READ ME" > $GitFolder/$Repository/README.md

    Copy-Item -Path $PSScriptRoot/LICENSE -Destination $GitFolder/$Repository/LICENSE
    Copy-Item -Path $PSScriptRoot/.gitignore -Destination $GitFolder/$Repository/.gitignore

    Invoke-GHPush -RepoName $Repository -GitFolder $GitFolder

    Get-GHRepo $owner $Repository -View
}
