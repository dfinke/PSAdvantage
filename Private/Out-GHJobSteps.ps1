function Out-GHJobSteps {
    <#
        .Synopsis

        .Example

    #>
    param(
        [Parameter(ValueFromPipeline)]
        $GHJobInfo
    )

    Process {
        foreach ($job in $GHJobInfo) {
            foreach ($step in $job.steps) {
                [PSCustomObject][Ordered]@{
                    runName      = $job.name
                    name         = $step.name
                    status       = $step.status
                    conclusion   = $step.conclusion
                    number       = $step.number
                    started_at   = $step.started_at
                    completed_at = $step.completed_at
                }
            }
        }
    }
}
