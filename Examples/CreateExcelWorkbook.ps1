param(
    [Parameter(Mandatory)]
    $owner,
    $reponame = 'pstest'
)

Import-PSAdvantageConfig D:\temp\scratch\config.ps1 # imports config with GitHub Access Token

$command = @'
$url = 'https://raw.githubusercontent.com/dfinke/PSKit/master/sampleCsv/aapl.csv'

$ts = (Get-Date).ToString("yyyyMMddHHmmss")
Export-Excel -InputObject (Invoke-RestMethod $url | ConvertFrom-Csv) -Path "appl-$($ts).xlsx"
'@

Invoke-Advantage -owner $owner -reponame $reponame -template importexcel-powershell -command $command
