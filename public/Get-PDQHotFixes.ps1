function Get-PDQHotFixes {
<#
.SYNOPSIS
Get information on hotfix/patches installed on specified target

.DESCRIPTION
Retreives information on all hotfixes/patches installed on the target systems which have been scanned by PDQ Inventory.

.PARAMETER Computer
Target computer to return hotfix/patch information for

.PARAMETER HotFix
Specified hotfix/patch to return information for

.EXAMPLE
Get-PDQHotFixes -Computer WK01

Returns all patches installed on WK01

.EXAMPLE
Get-PDQHotFixes -HotFix KB000001

Returns a list of machines which have patch "KB00001" installed

.NOTES
Author: Chris Bayliss
Version: 1.0
Date: 12/05/2019
#>

    [CmdletBinding(DefaultParameterSetName = 'Default')]
    param (
        [Parameter(Mandatory = $false, 
        ParameterSetName = 'Comp', 
        ValueFromPipelineByPropertyName,
        Position = 0)] 
        [string][alias('Name')]$Computer,

        [Parameter(Mandatory = $false, 
        ParameterSetName = 'HF', 
        ValueFromPipelineByPropertyName)] 
        [string]$HotFix
    )
    
    process {
        if (!(Test-Path -Path "$($env:AppData)\pspdq\config.json")) {
            Throw "PSPDQ Configuration file not found in `"$($env:AppData)\pspdq\config.json`", please run Set-PSPDQConfig to configure module settings."
        }
        else {
            $config = Get-Content "$($env:AppData)\pspdq\config.json" | ConvertFrom-Json

            $Server = $config.Server.PDQInventoryServer
            $DatabasePath = $config.DBPath.PDQInventoryDB
        }

        if ($PSCmdlet.ParameterSetName -eq 'Comp') {
            $sql = "SELECT hotfixes.hotfixid, hotfixes.computerid, computers.name, hotfixes.name, hotfixes.Description, hotfixes.InstalledOn, hotfixes.InstalledBy, hotfixes.Program, hotfixes.Version, hotfixes.Publisher, hotfixes.HelpLink
            FROM HotFixes
            INNER JOIN Computers on hotfixes.ComputerId = computers.ComputerId
            WHERE Computers.Name LIKE '%%$Computer%%'
            ORDER BY hotfixes.InstalledOn DESC"
        }

        if ($PSCmdlet.ParameterSetName -eq 'HF') {
            $sql = "SELECT hotfixes.hotfixid, hotfixes.computerid, computers.name, hotfixes.name, hotfixes.Description, hotfixes.InstalledOn, hotfixes.InstalledBy, hotfixes.Program, hotfixes.Version, hotfixes.Publisher, hotfixes.HelpLink
            FROM HotFixes
            INNER JOIN Computers on hotfixes.ComputerId = computers.ComputerId
            WHERE Hotfixes.Name LIKE '%%$HotFix%%'
            ORDER BY hotfixes.InstalledOn DESC"
        }

        $HotFixes = Invoke-Command -Computer $Server -ScriptBlock { $args[0] | sqlite3.exe $args[1] } -ArgumentList $sql, $DatabasePath

        $HotFixesParsed = $HotFixes | % {
            $p = $_ -split '\|'
            [PSCustomObject]@{
                HotFixID    = $p[0]
                ComputerID  = $p[1]
                Computer    = $p[2]
                Name        = $p[3]
                Description = $p[4]
                InstalledOn = $p[5]
                InstalledBy = $p[6]
                Program     = $p[7]
                Version     = $p[8]
                Publisher   = $p[9]
                HelpLink    = $p[10]
            }
        }

        return $HotFixesParsed
    }
}