# v0.9.3

- Added `Find-GHRepoByUser`

# 7/5/2021

- Update Get-GHWorkflow, filter workflows by name

```powershell
Get-GHWorkflow microsoft vscode deep*
```

# 7/5/2021

- Update Get-GHWorkflow parameters with `[Parameter(ValueFromPipelineByPropertyName)]`

# 5/1/2021

- Update Get-GHMetrics GraphQL with total commits, default branch, last commit date

# 4/28/2021

- Add GitHub Token to basic-powershell.yml
- Add `total commits` and `last commit date` to `Get-GHMetrics`
- Add raw switch to `Get-GHWorkflow`

# 4/03/2021

- Add value by property name. `Get-GHMetrics`
- Move launching the browser till after all files are pushed. `Set-GHContent`

# 3/28/2021

- Enabled `$env:PSAdvantageGHToken` as a third way to pass the GitHub public access token to the PSAdvantage functions

# 3/16/2021

- Enable pipeline processing for `Get-GHLatestJob`, `Get-GHLatestJobSteps`, `Get-GHLatestRun`, `Remove-GHRepo`
