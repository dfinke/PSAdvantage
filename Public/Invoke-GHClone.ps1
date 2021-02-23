function Invoke-GHClone {
    <#
        .Synopsis
        Clones a github repo

        .Description
        If the target directory exists, it gets deleted so it can be cloned

        .Example
        Invoke-GHClone https://github.com/dfinke/PSKit1.git pskit
    #>
    param(
        [Parameter(Mandatory)]
        $Url,
        [Parameter(Mandatory)]
        $Reponame
    )
    
    $defaultPath = './custom'
    $path = "$defaultPath/$reponame"
    
    if (Test-Path $path) {     
        Write-ToConsole * INFO 'Repository already exists under the custom folder. Recloning...'
        Remove-Item $path -Recurse -Force
    }

    $flag = '-q' # quiet mode

    Write-ToConsole * INFO -Text 'Trying to clone the repository...'
    $r = git clone $Url $path $flag $flag 2>&1
    
    if ($LASTEXITCODE -eq 0) {        
        Write-ToConsole + -Text "Repository successfully cloned under $($defaultPath) directory!"
    }
    else {
        Write-ToConsole - Error -Text $r -TextColor Red
    }
}