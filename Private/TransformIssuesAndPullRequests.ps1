function TransformIssuesAndPullRequests {
    param(
        $target
    )

    foreach ($item in $target) {
        foreach ($i in $item) {
            $created = Get-Date $i.created_at

            $closedDate = $i.closed_at
            if ($i.state -eq 'open') { $closedDate = Get-Date }

            [PSCustomObject][Ordered]@{
                DateCreated   = $created.ToShortDateString()
                DaysOpen      = ($closedDate - $created).Days
                ReviewerCount = $i.requested_reviewers.Count
                State         = $i.state
                Title         = $i.title
                Repo          = $slug
            }
        }
    }

}