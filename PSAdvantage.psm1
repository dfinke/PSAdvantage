Update-TypeData -TypeName "PSAdvantage.GitHubWorkflow" -DefaultDisplayPropertySet 'Name', 'WorkflowId', 'Owner', 'Repo' -Force

foreach ($path in 'Public', 'Private') {
    foreach ($file in Get-ChildItem $PSScriptRoot\$path *.ps1) {
        . $file.FullName
    }
}