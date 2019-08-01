function Start-PDQCollectionScan {
    <#
.SYNOPSIS
Scan target collection with specified scan profile.

.DESCRIPTION
Scan the target collection with the scan profile specified. By default the "Standard" profile will be used.
Requires PDQ Inventory client or server to be installed locally.

.PARAMETER Collection
Name of collection to scan

.PARAMETER ScanProfile
Profile to scan the target computer with

.PARAMETER Credential
Specifies a user account that has permissions to perform this action.

.EXAMPLE
Start-PDQCollectionScan -Collection "Online Systems" -ScanProfile "Standard"
Scan the target collection "Online Systems" with the "Standard" scan profile

.NOTES
Author: Chris Bayliss
Version: 1.0
Date: 12/05/2019
#>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true,
            Position = 0,
            ValueFromPipelinebyPropertyName)]
        [Alias('Name')]
        [string[]]$Collection,

        [Parameter(Position = 1)]
        [string]$ScanProfile = "Standard",

        [PSCredential]$Credential
    )
    begin {
        if (!(Test-Path -Path "$($env:AppData)\pspdq\config.json")) {
            Throw "PSPDQ Configuration file not found in `"$($env:AppData)\pspdq\config.json`", please run Set-PSPDQConfig to configure module settings."
        }

        else {
            $config = Get-Content "$($env:AppData)\pspdq\config.json" | ConvertFrom-Json
            $Server = $config.Server.PDQInventoryServer
        }
    }

    process {

        $icmParams = @{
            Computer     = $Server
            ScriptBlock  = { PDQInventory.exe ScanCollections -ScanProfile $using:ScanProfile -Collections $using:Collection }
            ArgumentList = $ScanProfile, $Collection
        }
        if ($Credential) { $icmParams['Credential'] = $Credential }
        Invoke-Command @icmParams
    }

}

