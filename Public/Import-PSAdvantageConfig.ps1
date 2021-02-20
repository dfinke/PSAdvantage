function Import-PSAdvantageConfig { 
    <#
        .Synopsis
        Reads PSAdvantage configuration, has the GitHub Access token

        .Example
        Import-PSAdvantageConfig .\config.ps1
    #>
    param(
        [Parameter(Mandatory)]        
        $configFileFullName    
    )

    $script:config = . $configFileFullName
}