Import-Module "$PSScriptRoot\..\..\PSAdvantage.psd1" -Force

Get-GHStarGazers dfinke/powershell-notebooks | select -First 1 |clip