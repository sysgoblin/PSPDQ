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

.PARAMETER Credential
Specifies a user account that has permissions to perform this action.

.EXAMPLE
Get-PDQComputer -Computer WK01
Returns PDQ Inventory information for WK01

.NOTES
Author: Chris Bayliss
#>

    [CmdletBinding(SupportsShouldProcess = $True)]
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
        [string[]][alias('Name')]$Computer,

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
        [string[]]$Properties,

        [Parameter(Mandatory = $false)]
        [PSCredential]$Credential
    )

    begin {
        Get-PSPDQConfig
    }

    process {

        if ($PSBoundParameters.ContainsKey('Properties')) {
            $defaultProps = "ComputerId", "Name", "Model", "OSName", "OSServicePack"
            $allProps = $defaultProps + $Properties
        }
        else {
            $allProps = "ComputerId", "Name", "Model", "OSName", "OSServicePack"
        }

        $Computers = @()

        if ($PSBoundParameters.All) {
            $sql = "SELECT " + ($allProps -join ', ') + "
            FROM Computers"

            $icmParams = @{
                ComputerName = $invServer
                ScriptBlock  = { $args[0] | sqlite3.exe $args[1] }
                ArgumentList = $sql, $invDatabasePath
            }
            if ($Credential) { $icmParams['Credential'] = $Credential }
            $Computers += Invoke-Command @icmParams
        }

        if ($PSBoundParameters.Computer) {
            Write-Verbose "Getting details for $Computer"
            foreach ($Comp in $Computer) {
                $sql = "SELECT " + ($allProps -join ', ') + "
                FROM Computers
                WHERE Name LIKE '%%$Comp%%'"

                $icmParams = @{
                    ComputerName     = $invServer
                    ScriptBlock  = { $args[0] | sqlite3.exe $args[1] }
                    ArgumentList = $sql, $invDatabasePath
                }
                if ($Credential) { $icmParams['Credential'] = $Credential }
                Write-Verbose "$invServer"
                Write-Verbose "$invDatabasePath"
                Write-Verbose "Running query $sql"
                $Computers += Invoke-Command @icmParams
            }
        }

        if ($PSBoundParameters.User) {
            foreach ($u in $user) {
                $sql = "SELECT " + ($allProps -join ', ') + "
                FROM Computers
                WHERE CurrentUser LIKE '%%$u%%'"

                $icmParams = @{
                    ComputerName     = $invServer
                    ScriptBlock  = { $args[0] | sqlite3.exe $args[1] }
                    ArgumentList = $sql, $invDatabasePath
                }
                if ($Credential) { $icmParams['Credential'] = $Credential }
                $Computers += Invoke-Command @icmParams
            }
        }

        # obj builder
        $computersParsed = @()
        $Computers | ForEach-Object {
            $propsParsed = $_ -split '\|'
            $compObj = New-Object pscustomobject
            for ($p = 0; $p -lt $allProps.count; $p++) {
                $compObj | Add-Member NoteProperty $allProps[$p] $propsParsed[$p]
            }
            $computersParsed += $compObj
        }
    }

    end {
        return $computersParsed
    }
}