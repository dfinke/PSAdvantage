function Get-GHBaseRestURI {
    <#
        .Synopsis
        Base url for GitHub Rest API
        
        .Example
        Invoke-RestMethod ((Get-GHBaseRestURI)+'/repos/powershell/powershell')
    #>

    "https://api.github.com"
}