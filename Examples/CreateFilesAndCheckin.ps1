param(
    [Parameter(Mandatory)]
    $owner,
    $reponame = 'pstest'
)

Import-PSAdvantageConfig D:\temp\scratch\config.ps1 # imports config with GitHub Access Token

# Create three files in the workflow
$command = @"
01..10 > test1.txt
11..20 > test2.txt
21..30 > test3.txt
"@

# Use the commit-files-powershell template, does a check-in as the last step
Invoke-Advantage -owner $owner -reponame $reponame -template commit-files-powershell -command $command

# Navigte to the repo in a browser
Get-GHRepo -owner $owner -repo $reponame -View