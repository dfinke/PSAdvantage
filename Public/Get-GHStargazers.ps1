function Get-GHStarGazers {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        $slug 
    )

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

    $r.data.repository.stargazers.edges.node
    Write-Verbose $query -
}