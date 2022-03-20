function Get-GHRelease {
    <#
        .SYNOPSIS
        Get releases in a GitHub repository
        
        .EXAMPLE
        Get-GHRelease dfinke/importexcel
        
        .EXAMPLE
        # Get open releases, and go back 3 pages worth of releases
        Get-GHRelease dfinke/importexcel -NumberOfPages 3

        .EXAMPLE
        # Get open releases, return all the data from GitHub
        Get-GHRelease dfinke/importexcel -Raw
    #>

    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline)]
        $slug,
        # Number of pages to retrieve        
        $NumberOfPages = 1,
        [Switch]$Raw
    )
    
    Process {
        if (!$slug) {
            Write-Warning "Slug not specified and is required"
            return
        }
        
        Write-Progress -Activity "Getting" -Status "$($state) pull requests for repo $($slug)"
        $result = (Invoke-GitHubAPI "https://api.github.com/repos/$($slug)/releases" -FollowRelLink -MaximumFollowRelLink $NumberOfPages)

        if ($Raw) {
            $result
        }
        else {
            foreach ($item in $result) {
                foreach ($i in $item) {
                    $created = Get-Date $i.created_at        
        
                    [PSCustomObject][Ordered]@{
                        DateCreated = $created.ToShortDateString()
                        Tag         = $i.tag_name
                        Draft       = $i.draft
                        PreRelease  = $i.prerelease
                        Repo        = $slug
                        Tarball     = $i.tarball_url
                        Zipball     = $i.zipball_url
                    }
                }
            }            
        }
    }
}