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
                $started = Get-Date $step.started_at
                $start_month = $started.Month
                $start_day = $started.Day
                $start_year = $started.Year
                $start_hour = $started.Hour
                $start_minute = $started.Minute
                $start_second = $started.Second

                [PSCustomObject][Ordered]@{
                    jobid        = $job.id
                    runid        = $job.run_id
                    runName      = $job.name
                    name         = $step.name
                    fullName     = $job.name + '-' + $started.ToString('yyyy-MM-dd-HH-mm') + '-' + $job.run_id
                    status       = $step.status
                    conclusion   = $step.conclusion
                    number       = $step.number
                    started_at   = $step.started_at
                    start_month  = $start_month
                    start_day    = $start_day
                    start_year   = $start_year
                    start_hour   = $start_hour
                    start_minute = $start_minute
                    start_second = $start_second                        
                    completed_at = $step.completed_at
                }
            }
        }
    }
}
