function Get-GHStarGazers {
  <#
    .Synopsis
    Gets GitHub stargazers on repositories

    .Description
    Gets first 100 stargazers on a GitHub repository, **does not** paginate

    .Example
    Get-GHStarGazers dfinke/powershell-notebooks

    login           : thedavecarroll
    email           : 
    name            : Dave Carroll
    bio             : PowerShell developer and enthusiast with a side of DevOps, infrastructure, and retrocomputing.
    company         : 
    repositories    : @{totalCount=11}
    isHireable      : False
    avatarUrl       : https://avatars.githubusercontent.com/u/37391437?v=4
    createdAt       : 3/15/2018 3:07:59 AM
    updatedAt       : 11/28/2021 1:11:41 AM
    twitterUsername : thedavecarroll
    websiteUrl      : https://thedavecarroll.com
    followers       : @{totalCount=91}
    following       : @{totalCount=86}
  #>
  [CmdletBinding()]
  param(
    [Parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    $slug,
    $AccessToken,
    [Switch]$CountOnly
  )

  Process {
    $owner, $repo = $slug.split('/')

    $query = @"
{
  repository(owner: "$owner", name: "$repo") {
    stargazers(first: 100) {
      pageInfo {
        endCursor
        hasNextPage
        hasPreviousPage
        startCursor
      }
      edges {
        starredAt
        node {
          login
          email
          name
          bio
          company
          repositories(first:100, isFork: false) {
            totalCount
          }
          isHireable
          avatarUrl
          createdAt
          updatedAt
          twitterUsername
          websiteUrl
          followers(first: 0) {
            totalCount
          }
          following(first: 0) {
            totalCount
          }
        }
      }
    }
  }
}
"@

    $q = ConvertTo-Json @{query = $query }

    $r = Invoke-GitHubAPI -Uri ("$(Get-GHBaseRestURI)/graphql") -Body $q -Method Post -AccessToken $AccessToken

    if ($r.errors) {
      Write-Host $r.errors[0].message
      return
    }

    Write-Verbose $query

    if ($CountOnly) {
      "Stargazers {0}" -f $r.data.repository.stargazers.edges.node.count
    }
    else {
      $r.data.repository.stargazers.edges.node | Add-Member -PassThru -MemberType NoteProperty -Name repo -Value $slug
    }
  }
}