function Get-PDQCollection {
    <#
    .SYNOPSIS
        Returns information on PDQ Inventory collections

    .DESCRIPTION
        Returns information on either all or specified PDQ Inventory collections

    .EXAMPLE
        Get-PDQCollection -CollectionName "Online"
        Returns information on all collections matching the string "Online"

    .NOTES
        Author: Chris Bayliss
        Version: 1.0
        Date: 12/05/2019
    #>

    [CmdletBinding()]
    param (
        # Collection name to query
        [Parameter(Mandatory = $false, 
        ParameterSetName = 'ColName')] 
        [string[]]$CollectionName,

        #Collection ID number to query
        [Parameter(Mandatory = $false, 
        ParameterSetName = 'ColID')] 
        [int[]]$CollectionID,  

        # Returns information on all collections
        [Parameter(Mandatory = $false, 
        ParameterSetName = 'All')] 
        [switch]$All   
    )

    process {

        if (!(Test-Path -Path "$($env:AppData)\pspdq\config.json")) {
            Throw "PSPDQ Configuration file not found in `"$($env:AppData)\pspdq\config.json`", please run Set-PSPDQConfig to configure module settings."
        } else {
            $config = Get-Content "$($env:AppData)\pspdq\config.json" | ConvertFrom-Json

            $Server = $config.Server.PDQInventoryServer
            $DatabasePath = $config.DBPath.PDQInventoryDB
        }

        if ($PSCmdlet.ParameterSetName -eq 'ColName') {
            $Collections = @()

            foreach ($col in $Collection) {
                $sql = "SELECT CollectionId, Name, Type, ComputerCount
                        FROM Collections
                        WHERE Name LIKE '%%$col%%'"
                $Collections += Invoke-Command -Computer $Server -ScriptBlock { $args[0] | sqlite3.exe $args[1] } -ArgumentList $sql, $DatabasePath
            }
        } 
        
        if ($PSCmdlet.ParameterSetName -eq 'ColID') {
            $Collections = @()

            foreach ($i in $ID) {
                $sql = "SELECT CollectionId, Name, Type, ComputerCount
                        FROM Collections
                        WHERE CollectionId = $i"
                $Collections += Invoke-Command -Computer $Server -ScriptBlock { $args[0] | sqlite3.exe $args[1] } -ArgumentList $sql, $DatabasePath
            }
        } 
        
        if ($PSCmdlet.ParameterSetName -eq 'All') {
            $sql = "SELECT CollectionId, Name, Type, ComputerCount
            FROM Collections"
            $Collections = Invoke-Command -Computer $Server -ScriptBlock { $args[0] | sqlite3.exe $args[1] } -ArgumentList $sql, $DatabasePath
        }

        $collectionsParsed += $Collections | ForEach-Object {
            $p = $_ -split '\|'
            [PSCustomObject]@{
                CollectionID   = [int]$p[0]
                CollectionName = $p[1]
                CollectionType = $p[2]
                ComputerCount  = [int]$p[3]
            }
        }
            
        return $collectionsParsed
    }
}