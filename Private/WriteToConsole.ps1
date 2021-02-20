function Write-Colorized {
    param(
        [Parameter(Mandatory)]
        $text,
        [Parameter(Mandatory)]
        $color
    )

    Write-Host -NoNewline $text -ForegroundColor $color
}

function Write-ToConsole {
    param(
        $indicator,
        $indicatorText,
        $text,
        $textColor = 'cyan'
    )

    Write-Colorized '[' white
    Write-Colorized $indicator yellow
    Write-Colorized ']' white
    Write-Colorized ' ' white

    if ($indicatorText) {
        Write-Colorized $indicatorText yellow
        Write-Colorized ':' yellow
        Write-Colorized ' ' white
    }

    if ($text) {
        Write-Colorized $text $textColor
        Write-Host ""
    }
}