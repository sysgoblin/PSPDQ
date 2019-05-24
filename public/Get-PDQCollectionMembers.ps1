function Get-PDQCollectionMembers {
    <#
    .SYNOPSIS
        Returns members of specified PDQ Inventory collection

    .DESCRIPTION
        Returns members of specified PDQ Inventory collection

    .EXAMPLE
        Get-PDQCollectionMembers -CollectionID 1

    .NOTES
        Author: Chris Bayliss
        Version: 1.0
        Date: 12/05/2019
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
        [int]$CollectionID
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
            $sql = "SELECT Computers.ComputerId, Computers.Name, Computers.Added, Computers.BootTime, Computers.Manufacturer, Computers.Model, Computers.Memory, Computers.OSName, Computers.OSServicePack, Computers.SerialNumber, Computers.OSArchitecture, Computers.IPAddress, Computers.CurrentUser, Computers.MacAddress, Computers.DotNetVersions, Computers.NeedsReboot, Computers.PSVersion, Computers.ADLogonServer, Computers.SMBv1Enabled, Computers.SimpleReasonForReboot, Computers.IsOnline
                    FROM Computers
                    WHERE Computers.ComputerId IN (
                    SELECT CollectionComputers.ComputerId
                    FROM CollectionComputers
                    INNER JOIN Collections ON CollectionComputers.CollectionId = Collections.CollectionId
                    WHERE Collections.Name = '$CollectionName' AND IsMember = 1)"
            $Collections = Invoke-Command -Computer $Server -ScriptBlock { $args[0] | sqlite3.exe $args[1] } -ArgumentList $sql, $DatabasePath
            
            $nsql = "SELECT Name FROM Collections WHERE Name = '$CollectionName'"
            $ColName = Invoke-Command -Computer $Server -ScriptBlock { $args[0] | sqlite3.exe $args[1] } -ArgumentList $nsql, $DatabasePath
        } 

        if ($PSCmdlet.ParameterSetName -eq 'ColID') {
            $sql = "SELECT Computers.ComputerId, Computers.Name, Computers.Added, Computers.BootTime, Computers.Manufacturer, Computers.Model, Computers.Memory, Computers.OSName, Computers.OSServicePack, Computers.SerialNumber, Computers.OSArchitecture, Computers.IPAddress, Computers.CurrentUser, Computers.MacAddress, Computers.DotNetVersions, Computers.NeedsReboot, Computers.PSVersion, Computers.ADLogonServer, Computers.SMBv1Enabled, Computers.SimpleReasonForReboot, Computers.IsOnline
                    FROM Computers
                    WHERE Computers.ComputerId IN (
                    SELECT ComputerId
                    FROM CollectionComputers
                    WHERE CollectionId = $CollectionID AND IsMember = 1
                    )"
            $Collections = Invoke-Command -Computer $Server -ScriptBlock { $args[0] | sqlite3.exe $args[1] } -ArgumentList $sql, $DatabasePath
        
            $nsql = "SELECT Name FROM Collections WHERE CollectionId = $CollectionID"
            $ColName = Invoke-Command -Computer $Server -ScriptBlock { $args[0] | sqlite3.exe $args[1] } -ArgumentList $nsql, $DatabasePath
        }

        $collectionsParsed = $Collections | ForEach-Object {
            $p = $_ -split '\|'
            [PSCustomObject]@{
                ComputerId            = $p[0]
                Computer              = $p[1]
                Added                 = $p[2]
                BootTime              = $p[3]
                Manufacturer          = $p[4]
                Model                 = $p[5]
                Memory                = $p[6]
                OperatingSystem       = $p[7]
                ServicePack           = $p[8]
                SerialNumber          = $p[9]
                OSArchitecture        = $p[10]
                IPAddress             = $p[11]
                CurrentUser           = $p[12]
                MacAddress            = $p[13]
                DotNetVersions        = $p[14]
                NeedsReboot           = if ($p[15] -eq '1') { "Yes" } else { "No" }
                PSVersion             = $p[16]
                ADLogonServer         = $p[17]
                SMBv1Enabled          = $p[18]
                SimpleReasonForReboot = $p[19]
                Online                = if ($p[20] -eq '1') { "Yes" } else { "No" }
            }
        }
            
        Write-Output "`r`n`tMembers of Collection: $ColName `r`n"
        return $collectionsParsed
    }
}