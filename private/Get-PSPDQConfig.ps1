function Get-PSPDQConfig {
    if (!(Test-Path -Path "$($env:AppData)\pspdq\config.json")) {
        Throw "PSPDQ Configuration file not found in `"$($env:AppData)\pspdq\config.json`", please run Set-PSPDQConfig to configure module settings."
    }
    else {
        $config = Get-Content "$($env:AppData)\pspdq\config.json" | ConvertFrom-Json

        $Script:invServer = $config.Server.PDQInventoryServer
        $Script:invDatabasePath = $config.DBPath.PDQInventoryDB

        $Script:depServer = $config.Server.PDQDeployServer
        $Script:depDatabasePath = $config.DBPath.PDQDeployDB
    }
}