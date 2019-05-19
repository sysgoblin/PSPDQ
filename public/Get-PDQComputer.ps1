function Get-PDQComputer {
    <#
    .SYNOPSIS
        Returns info for computer held within PDQ Inventory

    .DESCRIPTION
        Returns info for computer held within PDQ Inventory

    .EXAMPLE
        Get-PDQComputer -Computer WK01
        Returns PDQ Inventory information for WK01

    .NOTES
        Author: Chris Bayliss
        Version: 1.0
        Date: 12/05/2019
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
        Position = 0)] 
        [string[]]$Computer,

        # Returns information for computer(s) where the specified user is or has been active
        [Parameter(Mandatory = $false, 
        ParameterSetName = 'User')] 
        [string[]]$User   
    )
    
    process {   

        if (!(Test-Path -Path "$($env:AppData)\pspdq\config.json")) {
            Throw "PSPDQ Configuration file not found in `"$($env:AppData)\pspdq\config.json`", please run Set-PSPDQConfig to configure module settings."
        } else {
            $config = Get-Content "$($env:AppData)\pspdq\config.json" | ConvertFrom-Json

            $Server = $config.Server.PDQInventoryServer
            $DatabasePath = $config.DBPath.PDQInventoryDB
        }

        $Computers = @()

        if ($PSCmdlet.ParameterSetName -eq 'All') {
            $sql = "SELECT ComputerId, Name, Added, BootTime, Manufacturer, Model, Memory, OSName, OSServicePack, SerialNumber, OSArchitecture, 
            IPAddress, CurrentUser, MacAddress, DotNetVersions, NeedsReboot, PSVersion, ADLogonServer, SMBv1Enabled, SimpleReasonForReboot, IsOnline
            FROM Computers"
            $Computers += Invoke-Command -Computer $Server -ScriptBlock { $args[0] | sqlite3.exe $args[1] } -ArgumentList $sql, $DatabasePath
        }
        
        if ($PSCmdlet.ParameterSetName -eq 'Computer') {
            foreach ($Comp in $Computer) {
                $sql = "SELECT ComputerId, Name, Added, BootTime, Manufacturer, Model, Memory, OSName, OSServicePack, SerialNumber, OSArchitecture, 
                IPAddress, CurrentUser, MacAddress, DotNetVersions, NeedsReboot, PSVersion, ADLogonServer, SMBv1Enabled, SimpleReasonForReboot, IsOnline
                FROM Computers 
                WHERE Name LIKE '%%$Comp%%'"
                $Computers += Invoke-Command -Computer $Server -ScriptBlock { $args[0] | sqlite3.exe $args[1] } -ArgumentList $sql, $DatabasePath
            }
        } 
        
        if ($PSCmdlet.ParameterSetName -eq 'User') {
            foreach ($u in $user) {
                $sql = "SELECT ComputerId, Name, Added, BootTime, Manufacturer, Model, Memory, OSName, OSServicePack, SerialNumber, OSArchitecture, 
                IPAddress, CurrentUser, MacAddress, DotNetVersions, NeedsReboot, PSVersion, ADLogonServer, SMBv1Enabled, SimpleReasonForReboot, IsOnline
                FROM Computers 
                WHERE CurrentUser LIKE '%%$u%%'"
                $Computers += Invoke-Command -Computer $Server -ScriptBlock { $args[0] | sqlite3.exe $args[1] } -ArgumentList $sql, $DatabasePath
            }
        }

        $ComputersParsed = $Computers | ForEach-Object {
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

        return $computersParsed
    }
}