function Set-PSPDQConfig {
<#
.SYNOPSIS
Sets configuration for PSPDQ module.

.DESCRIPTION
Sets sever hostname and database path information for PDQ Deploy and Inventory to json file within $env:APPDATA
By default, database files will be located within:
PDQ Deploy: "C:\ProgramData\PDQ Deploy\Database.db"
PDQ Inventory: "C:\ProgramData\PDQ Inventory\Database.db"

Be sure to set the database path as the LOCAL path to the file. As in "Drive:\file\path" NOT "\\UNCpath\file\path"

.PARAMETER PDQDeployServer
Hostname or FQDN or PDQ Deploy server

.PARAMETER PDQInventoryServer
Hostname or FQDN or PDQ Inventory server

.PARAMETER PDQDeployDBPath
Full LOCAL path of PDQ Deploy database

.PARAMETER PDQInventoryDBPath
Full LOCAL path of PDQ Inventory database

.EXAMPLE
Set-PSPDQConfig -PDQDeployServer PDQSERVER1 -PDQInventoryServer PDQSERVER2 -PDQDeployDBPath "C:\ProgramData\PDQ Deploy\Database.db" -PDQInventoryDBPath "C:\ProgramData\PDQ Inventory\Database.db"

.NOTES
Author: Chris Bayliss
Version: 1.0
Date: 12/05/2019
#>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$PDQDeployServer,

        [Parameter(Mandatory = $true)]
        [string]$PDQInventoryServer,

        [Parameter(Mandatory = $true)]
        [string]$PDQDeployDBPath,

        [Parameter(Mandatory = $true)]
        [string]$PDQInventoryDBPath
    )
    
    process {
        if (!(Test-Path -Path "$($env:AppData)\pspdq\config.json")) {
            New-Item -Path "$($env:AppData)\pspdq\config.json" -Force
        }

        $conf = @{
            "Server" = @{
                "PDQDeployServer"    = "$PDQDeployServer"
                "PDQInventoryServer" = "$PDQInventoryServer"
            }

            "DBPath" = @{
                "PDQDeployDB"    = "$PDQDeployDBPath"
                "PDQInventoryDB" = "$PDQInventoryDBPath"
            }
        } | ConvertTo-Json

        $conf | Out-File "$($env:AppData)\pspdq\config.json" -Force
    }
}