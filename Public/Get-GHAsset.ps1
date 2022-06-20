function Get-GHAssest {
    <#
        .SYNOPSIS
        This returns a list of releases
        
        .EXAMPLE
        Get-GHAssest dfinke/importexcel

        .EXAMPLE
        Get-GHAssest dfinke/importexcel *fix*

        .EXAMPLE
        Get-GHAssest dfinke/importexcel *columns*

        .EXAMPLE
        Get-GHAssest dfinke/importexcel *columns* -download
    #>

    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline)]
        $slug,
        # Number of pages to retrieve
        $name,
        $NumberOfPages = 1,
        $AccessToken,
        [Switch]$Download,
        [Switch]$Raw
    )
    
    Process {
        if (!$slug) {
            Write-Warning "Slug not specified and is required"
            return
        }
        
        Write-Progress -Activity "Getting" -Status "$($state) assests for repo $($slug)"
        
        $result = (Invoke-GitHubAPI "https://api.github.com/repos/$($slug)/releases" -FollowRelLink -MaximumFollowRelLink $NumberOfPages)        

        if (!$name) { $name = '*' }
        $releases = $result | Where-Object { $_.name -like $name } 

        if ($Raw) {
            $releases
        }
        else {             
            if ($Download) {
                'Downloading {0} items(s) from GitHub' -f $releases.Count                
                foreach ($release in $releases) {                             
                    $zipBall = $release.zipball_url
                    'Downloading release {0}' -f $zipBall
                    $parts = $zipBall.split('/')
                    $zipFile = '{0}-{1}-{2}.zip' -f $parts[4], $parts[5], $parts[-1]                    
                    Invoke-RestMethod -Uri $zipBall -OutFile $zipFile
                }
            }
            else {
                $releases | select-object name, tag_name, created_at, published_at            
            }
        }
    }
}
