function Get-PDQComputer {
<#
.SYNOPSIS
Returns info for computer held within PDQ Inventory

.DESCRIPTION
Returns info for computer held within PDQ Inventory

.PARAMETER All
Switch. Will pull all results from PDQ Inventory.

.PARAMETER Computer
Defines computer(s) to return results for.

.PARAMETER User
If specified, results will only contain computers which the user is accessing.

.PARAMETER Properties
Specifies properties to include in results.

.EXAMPLE
Get-PDQComputer -Computer WK01
Returns PDQ Inventory information for WK01

.NOTES
Author: Chris Bayliss
#> 

    [CmdletBinding(DefaultParameterSetName = 'Default', SupportsShouldProcess = $True)]
    param (
        # Returns all information
        [Parameter(Mandatory = $false, 
        ParameterSetName = 'All')] 
        [switch]$All,

        # Returns information for specified computer
        [Parameter(Mandatory = $false, 
        ParameterSetName = 'Computer', 
        ValueFromPipelineByPropertyName,
        Position = 0)] 
        [string[]]$Computer,

        # Returns information for computer(s) where the specified user is or has been active
        [Parameter(Mandatory = $false, 
        ParameterSetName = 'User')] 
        [string[]]$User,   

        [Parameter(Mandatory = $false)] 
        [ValidateSet('Added', 'BootTime', 'Manufacturer', 'Memory', 'SerialNumber', 'OSArchitecture', 
        'IPAddress', 'CurrentUser', 'MacAddress', 'DotNetVersions', 'NeedsReboot', 'PSVersion', 'ADLogonServer', 
        'SMBv1Enabled', 'SimpleReasonForReboot', 'IsOnline', 'OSVersion', 'OSSerialNumber', 'SystemDrive', 
        'IEVersion', 'HeartbeatDate', 'ADDisplayName', 'BiosVersion', 'BiosManufacturer', 'Chassis', 'ADLogonServer', 
        'AddedFrom', 'ADIsDisabled')]
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

        if ($PSBoundParameters.ContainsKey('Properties')) {
            $defaultProps = "ComputerId", "Name", "Model", "OSName", "OSServicePack"
            $allProps = $defaultProps + $Properties
        } else {
            $allProps = "ComputerId", "Name", "Model", "OSName", "OSServicePack"
        }

        $Computers = @()

        if ($PSCmdlet.ParameterSetName -eq 'All') {
            $sql = "SELECT " + ($allProps -join ', ') + "
            FROM Computers"
            $Computers += Invoke-Command -Computer $Server -ScriptBlock { $args[0] | sqlite3.exe $args[1] } -ArgumentList $sql, $DatabasePath
        }
        
        if ($PSCmdlet.ParameterSetName -eq 'Computer') {
            foreach ($Comp in $Computer) {
                $sql = "SELECT " + ($allProps -join ', ') + "
                FROM Computers 
                WHERE Name LIKE '%%$Comp%%'"
                $Computers += Invoke-Command -Computer $Server -ScriptBlock { $args[0] | sqlite3.exe $args[1] } -ArgumentList $sql, $DatabasePath
            }
        } 
        
        if ($PSCmdlet.ParameterSetName -eq 'User') {
            foreach ($u in $user) {
                $sql = "SELECT " + ($allProps -join ', ') + "
                FROM Computers 
                WHERE CurrentUser LIKE '%%$u%%'"
                $Computers += Invoke-Command -Computer $Server -ScriptBlock { $args[0] | sqlite3.exe $args[1] } -ArgumentList $sql, $DatabasePath
            }
        }

        # obj builder
        $computersParsed = @()
        $Computers | % {
            $propsParsed = $_ -split '\|'
            $compObj = New-Object pscustomobject
            for ($p=0; $p -lt $allProps.count; $p++) {
                $compObj | Add-Member NoteProperty $allProps[$p] $propsParsed[$p]
            }
            $computersParsed += $compObj
        }

        return $computersParsed
    }
}