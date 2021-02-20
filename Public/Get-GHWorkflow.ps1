# TODO - Add $Name param to search for a workflow by name
function Get-GHWorkflow {
    <#
        .Synopsis
        Lists the workflows in a repository

        .Example
        Get-GHWorkflow microsoft vscode | format-table
    #>
    param(
        [Parameter(Mandatory)]
        $owner,
        [Parameter(Mandatory)]
        $repo,
        $AccessToken
    )    
    
    try {
        
        $url = "https://api.github.com/repos/{0}/{1}/actions/workflows" -f $owner, $repo
        $result = Invoke-GitHubAPI -Uri $url -AccessToken $AccessToken
        
        foreach ($item in $result.workflows) {
            [PSCustomObject][Ordered]@{
                WorkflowId = $item.Id
                Name       = $item.name
                Created    = $item.created_at
                Updated    = $item.updated_at
                Path       = $item.path
                Url        = $item.html_url
                Owner      = $owner
                Repo       = $repo
            }
        }
    }
    catch {        
        $errVar.Message | ConvertFrom-Json | Select-Object -ExpandProperty message
    }
}
