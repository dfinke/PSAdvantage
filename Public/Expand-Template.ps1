function Expand-Template {
    <#
        .Synopsis
        .Example
    #>

    param(
        [Parameter(Mandatory)]
        $templateFile,
        $command,
        $script:name
    )
    
    $templateFile = "$PSScriptRoot\..\templates\$($templateFile).yml"

    $template = Get-Content $templateFile -Raw

    $command = $(
        foreach ($line in $command.Split("`n")) {
            (' ' * 10) + $line
        }
    ) -join "`n"
    
    $ExecutionContext.InvokeCommand.ExpandString($template)
}