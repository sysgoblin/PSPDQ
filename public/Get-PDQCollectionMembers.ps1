function Get-PDQCollectionMembers {
    <#
    .SYNOPSIS
        Returns members of specified PDQ Inventory collection

    .DESCRIPTION
        Returns members of specified PDQ Inventory collection
    .PARAMETER Credential
        Specifies a user account that has permissions to perform this action.
    .EXAMPLE
        Get-PDQCollectionMembers -CollectionID 1

    .NOTES
        Author: Chris Bayliss
    #>


    [CmdletBinding()]
    param (
        # Name of collection to return members of
        [Parameter(Mandatory = $false,
            ParameterSetName = 'ColName',
            ValueFromPipelineByPropertyName)]
        [string]$CollectionName,

        # ID of collection to return members of
        [Parameter(Mandatory = $false,
            ParameterSetName = 'ColID',
            ValueFromPipelineByPropertyName)]
        [int]$CollectionID,

        [Parameter(Mandatory = $false)]
        [ValidateSet('Added', 'BootTime', 'Manufacturer', 'Memory', 'SerialNumber', 'OSArchitecture',
            'IPAddress', 'CurrentUser', 'MacAddress', 'DotNetVersions', 'NeedsReboot', 'PSVersion', 'ADLogonServer',
            'SMBv1Enabled', 'SimpleReasonForReboot', 'IsOnline', 'OSVersion', 'OSSerialNumber', 'SystemDrive',
            'IEVersion', 'HeartbeatDate', 'ADDisplayName', 'BiosVersion', 'BiosManufacturer', 'Chassis', 'ADLogonServer',
            'AddedFrom', 'ADIsDisabled')]
        [string[]]$Properties,

        [PSCredential]$Credential
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

        if ($PSBoundParameters.ContainsKey('Properties')) {

            $defaultProps = "ComputerId", "Name", "Model", "OSName", "OSServicePack"
            $allProps = $defaultProps + $Properties
        }
        else {
            $allProps = "ComputerId", "Name", "Model", "OSName", "OSServicePack"
        }

        if ($PSCmdlet.ParameterSetName -eq 'ColName') {
            $sql = "SELECT " + ($allProps -join ', ') + "
                    FROM Computers
                    WHERE Computers.ComputerId IN (
                    SELECT CollectionComputers.ComputerId
                    FROM CollectionComputers
                    INNER JOIN Collections ON CollectionComputers.CollectionId = Collections.CollectionId
                    WHERE Collections.Name = '$CollectionName' AND IsMember = 1)"

            $icmParams = @{
                Computer     = $Server
                ScriptBlock  = { $args[0] | sqlite3.exe $args[1] }
                ArgumentList = $sql, $DatabasePath
            }
            if ($Credential) { $icmParams['Credential'] = $Credential }
            $Computers = Invoke-Command @icmParams

            $nsql = "SELECT Name FROM Collections WHERE Name = '$CollectionName'"

            $icmParams = @{
                Computer     = $Server
                ScriptBlock  = { $args[0] | sqlite3.exe $args[1] }
                ArgumentList = $nsql, $DatabasePath
            }
            if ($Credential) { $icmParams['Credential'] = $Credential }
            $ColName = Invoke-Command @icmParams
        }

        if ($PSCmdlet.ParameterSetName -eq 'ColID') {
            $sql = "SELECT " + ($allProps -join ', ') + "
                    FROM Computers
                    WHERE Computers.ComputerId IN (
                    SELECT ComputerId
                    FROM CollectionComputers
                    WHERE CollectionId = $CollectionID AND IsMember = 1
                    )"

            $icmParams = @{
                Computer     = $Server
                ScriptBlock  = { $args[0] | sqlite3.exe $args[1] }
                ArgumentList = $sql, $DatabasePath
            }
            if ($Credential) { $icmParams['Credential'] = $Credential }
            $Computers = Invoke-Command @icmParams

            $nsql = "SELECT Name FROM Collections WHERE CollectionId = $CollectionID"

            $icmParams = @{
                Computer     = $Server
                ScriptBlock  = { $args[0] | sqlite3.exe $args[1] }
                ArgumentList = $nsql, $DatabasePath
            }
            if ($Credential) { $icmParams['Credential'] = $Credential }
            $ColName = Invoke-Command @icmParams

            $computersParsed = @()
            $Computers | ForEach-Object {
                $propsParsed = $_ -split '\|'
                $compObj = New-Object pscustomobject
                for ($p = 0; $p -lt $allProps.count; $p++) {
                    $compObj | Add-Member NoteProperty $allProps[$p] $propsParsed[$p]
                }
                $computersParsed += $compObj
            }

            Write-Output "`r`n`tMembers of Collection: $ColName `r`n"
            $computersParsed
        }
    }
