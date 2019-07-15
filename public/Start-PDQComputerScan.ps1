function Start-PDQComputerScan {
    <#
.SYNOPSIS
Scan target machine with specified scan profile.

.DESCRIPTION
Scan the target computer or server with the scan profile specified. By default the "Standard" profile will be used.
Requires PDQ Inventory client or server to be installed locally.

.PARAMETER Computer
Target to scan

.PARAMETER ScanProfile
Profile to scan the target computer with

.EXAMPLE
Start-PDQComputerScan -Computer WORKSTATION01 -ScanProfile "Standard"
Scan the target WORKSTATION01 with the "Standard" scan profile

.NOTES
Author: Chris Bayliss
Version: 1.0
Date: 12/05/2019
#>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, 
            ValueFromPipelineByPropertyName,
            Position = 0)]
        [string[]][alias('Name')]$Computer,

        [Parameter(Mandatory = $false,  
            Position = 1)]
        [string]$ScanProfile = "Standard"     
    )

    process {
        if (Get-Command pdqinventory.exe -ErrorAction SilentlyContinue) {
            PDQInventory.exe ScanComputers -ScanProfile $ScanProfile -Computers $Computer
        }
        else {
            Throw "PDQInventory.exe not in path or not installed."
        }
    }
}