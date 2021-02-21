Class TemplateNames : System.Management.Automation.IValidateSetValuesGenerator {
    [String[]] GetValidValues() {
        $templates = foreach ($template in Get-ChildItem $PSScriptRoot\..\templates) {
            $template.BaseName
        }
        
        return $templates
    }
}

function Invoke-Advantage {
    <#
        .Synopsis
        A GitHub Actions Automation Framework

        .Example
        Invoke-Advantage -owner dfinke -reponame pstest -template basic-powershell -command "'Hello World'"
    #>
    param (
        $owner,
        $reponame,
        [ValidateSet([TemplateNames])]
        $template,
        $command,
        $AccessToken,
        $saveLogs
    )
    
    Write-ToConsole * INFO 'Expanding template'

    $expandedTemplate = Expand-Template -templateFile $template -command $command

    $path = '.github/workflows/{0}.yml' -f $template

    $url = 'https://api.github.com/repos/{0}/{1}/contents/{2}' -f $owner, $reponame, $path

    $payload = @{
        "content" = (ConvertTo-Base64String $expandedTemplate)
        "message" = 'Added workflow file'
    } 

    if (!(Test-GHRepo -owner $owner -reponame $reponame -AccessToken $AccessToken)) {        
        New-GHRepo $reponame $reponame -AccessToken $AccessToken
    }

    Write-ToConsole +  -text 'Updating workflow'
    if (Test-GHPath -owner $owner -repo $reponame -path $path -AccessToken $AccessToken) {
        $payload.sha = Get-GHFileSHA -owner $owner -repo $reponame -path $path -AccessToken $AccessToken
    }

    $payload = $payload | ConvertTo-Json

    # pause for a few seconds, otheriwse github api gets confused on the branch name
    Start-Sleep -Seconds 2
    $null = Invoke-GitHubAPI -Uri $url -Method Put -Body $payload -AccessToken $AccessToken
    Write-ToConsole +  -text "Successfully updated workflow for: $($template)"

    Start-Sleep -Seconds 2
    $runInfo = Get-GHWorkflow -owner $owner -repo $reponame -AccessToken $AccessToken | Where-Object { $_.path -eq $path } | Invoke-GHWorkflow -AccessToken $AccessToken
    Write-ToConsole + -text "Run ID: $($runInfo.RunId)"


    if ($saveLogs) {
        Write-ToConsole * INFO 'Entering monitor mode ...'
        Write-ToConsole * INFO 'Pausing for a few seconds for the the workflow to trigger ...'
        Start-Sleep -Seconds 2
        $null = Get-GHLatestJob -owner $owner -repo $reponame -AccessToken $AccessToken -wait
        Write-ToConsole + -text "Job seems to have successfully completed"
        
        $null = Get-GHLatestRun -owner $owner -repo $reponame -AccessToken $AccessToken | Get-GHLog -LogPath $saveLogs -AccessToken $AccessToken
    }
}