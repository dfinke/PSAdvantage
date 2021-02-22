param(
    [Parameter(Mandatory)]
    $owner,
    [Parameter(Mandatory)]
    $reponame = 'pstest',
    $logPath = './logs'
)

Import-PSAdvantageConfig D:/temp/scratch/config.ps1 # imports config with GitHub Access Token

$defaultPath = "./custom"

Remove-GHRepo $owner $repoName -Confirm
Remove-Item $defaultPath -Recurse -Force -ErrorAction SilentlyContinue

New-GHRepo $repoName -clone

'"Hello World"' > $defaultPath/$repoName/hello.ps1
'"Howdy"' > $defaultPath/$repoName/howdy.ps1
'"So long"' > $defaultPath/$repoName/bye.ps1
'"Fare thee well"' > $defaultPath/$repoName/farewell.ps1

Copy-Item "$PSScriptRoot/ci.ps1" $defaultPath/$repoName

Invoke-GHPush $repoName

$params = @{
    owner    = $owner
    reponame = $reponame
    template = 'basic-powershell'
    saveLogs = $logPath
    command  = @'
./ci.ps1
./farewell.ps1
'@
}

Invoke-Advantage @params