function ConvertTo-Base64String {
    <#
        .Synopsis
        .Example
    #>
    param(
        [Parameter(Mandatory)]
        $text
    )

    $bytes = [System.Text.Encoding]::UTF8.GetBytes($text)
    [System.Convert]::ToBase64String($bytes)
}