# TODO - Add $Name param to search for a workflow by name
function Get-GHWorkflow {
    <#
        .Synopsis
        Lists the workflows in a repository

        .Example
        Get-GHWorkflow microsoft vscode | format-table

        .Example
        Get-GHWorkflow microsoft vscode deep*

    #>
    param(
        [Parameter(ValueFromPipelineByPropertyName)]
        $owner,
        [Parameter(ValueFromPipelineByPropertyName)]
        $repo,
        $Name = '*',
        $AccessToken,
        [Switch]$Raw
    )   
    
    Process {
        try {
        
            $url = "https://api.github.com/repos/{0}/{1}/actions/workflows" -f $owner, $repo
            Write-Verbose $url
            $result = Invoke-GitHubAPI -Uri $url -AccessToken $AccessToken
        
            $(
                foreach ($item in $result.workflows) {
                    if ($Raw) {
                        $item
                    }
                    else {
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
            ) | Where-Object { $_.Name -like $Name } 
        }
        catch {        
            $errVar.Message | ConvertFrom-Json | Select-Object -ExpandProperty message
        }
    }
}
