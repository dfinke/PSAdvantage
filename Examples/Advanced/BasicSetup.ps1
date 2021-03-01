param(
    [Parameter(Mandatory)]
    $owner,
    $repo = 'pstest'
)

# You need to create a config.ps1, and set up a personal access token there
Import-PSAdvantageConfig D:\temp\scratch\config.ps1
Remove-Item ./custom -Recurse -Force -ErrorAction SilentlyContinue

Remove-GHRepo $owner $repo -Confirm

New-GHRepo $repo -clone

"# READ ME" > ./custom/$repo/README.md
# "License info" > ./custom/$repo/LICENSE

Copy-Item -Path $PSScriptRoot/LICENSE -Destination ./custom/$repo/LICENSE
Copy-Item -Path $PSScriptRoot/.gitignore -Destination ./custom/$repo/.gitignore

Invoke-GHPush $repo
Get-GHRepo $owner $repo -View