function Get-PSPDQConfig {
    
    if (!(Test-Path -Path "$($env:AppData)\pspdq\config.json")) {
        Throw "PSPDQ Configuration file not found in `"$($env:AppData)\pspdq\config.json`", please run Set-PSPDQConfig to configure module settings."
    } else {
        $config = Get-Content "$($env:AppData)\pspdq\config.json" | ConvertFrom-Json

        Write-Output "PSPDQ Server settings:"
        $config.Server | fl

        Write-Output "`r`nPSPDQ Database path settings:"
        $config.DBPath | fl
    }
}