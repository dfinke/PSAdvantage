foreach ($path in 'Public', 'Private') {
    foreach ($file in Get-ChildItem $PSScriptRoot\$path *.ps1) {
        . $file.FullName
    }
}