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
        [switch]$All,
        
        [Parameter(Mandatory = $false)] 
        [ValidateSet('Path', 'IsDrillDown', 'Created', 'Modified', 'ParentId', 'Type', 'Description', 'IsEnabled')]
        [string[]]$Properties
    )

    process {

        if (!(Test-Path -Path "$($env:AppData)\pspdq\config.json")) {
            Throw "PSPDQ Configuration file not found in `"$($env:AppData)\pspdq\config.json`", please run Set-PSPDQConfig to configure module settings."
        } else {
            $config = Get-Content "$($env:AppData)\pspdq\config.json" | ConvertFrom-Json

            $Server = $config.Server.PDQInventoryServer
            $DatabasePath = $config.DBPath.PDQInventoryDB
        }

        if ($PSBoundParameters.ContainsKey($Properties)) {
            $defaultProps = 'CollectionId', 'Name', 'Type', 'ComputerCount'
            $allProps = $defaultProps + $Properties
        } else {
            $allProps = 'CollectionId', 'Name', 'Type', 'ComputerCount'
        }

        if ($PSCmdlet.ParameterSetName -eq 'ColName') {
            $Collections = @()

            foreach ($col in $CollectionName) {
                $sql = "SELECT " + ($allProps -join ', ') + "
                        FROM Collections
                        WHERE Name LIKE '%%$col%%'"
                $Collections += Invoke-Command -Computer $Server -ScriptBlock { $args[0] | sqlite3.exe $args[1] } -ArgumentList $sql, $DatabasePath
            }
        } 
        
        if ($PSCmdlet.ParameterSetName -eq 'ColID') {
            $Collections = @()

            foreach ($i in $CollectionID) {
                $sql = "SELECT " + ($allProps -join ', ') + "
                        FROM Collections
                        WHERE CollectionId = $i"
                $Collections += Invoke-Command -Computer $Server -ScriptBlock { $args[0] | sqlite3.exe $args[1] } -ArgumentList $sql, $DatabasePath
            }
        } 
        
        if ($PSCmdlet.ParameterSetName -eq 'All') {
            $sql = "SELECT " + ($allProps -join ', ') + "
            FROM Collections"
            $Collections = Invoke-Command -Computer $Server -ScriptBlock { $args[0] | sqlite3.exe $args[1] } -ArgumentList $sql, $DatabasePath
        }

        $collectionsParsed = @()
        $Collections | % {
            $propsParsed = $_ -split '\|'
            $colObj = New-Object pscustomobject
            for ($p=0; $p -lt $allProps.count; $p++) {
                $colObj | Add-Member NoteProperty $allProps[$p] $propsParsed[$p]
            }
            $collectionsParsed += $colObj
        }
            
        return $collectionsParsed
    }
}