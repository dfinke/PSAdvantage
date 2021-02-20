function Out-GHJobInfo {
    param(
        [Parameter(ValueFromPipeline)]
        $data,
        [Switch]$Raw
    )

    Process {
        foreach ($item in $data.Jobs) {
            if ($Raw) {
                $item
            }
            else {
                [PSCustomObject][Ordered]@{
                    JobId      = $item.Id
                    Name       = $item.name
                    Status     = $item.status
                    Conclusion = $item.conclusion
                    Started    = $item.started_at
                    Completed  = $item.completed_at
                    Owner      = $owner
                    Repo       = $repo
                }
            }
        }
    }
}