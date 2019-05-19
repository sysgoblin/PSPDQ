function Start-PDQCollectionScan {
    <#
.SYNOPSIS
Scan target collection with specified scan profile.

.DESCRIPTION
Scan the target collection with the scan profile specified. By default the "Standard" profile will be used.
Requires PDQ Inventory client or server to be installed locally.

.PARAMETER Computer
Name of collection to scan

.PARAMETER ScanProfile
Profile to scan the target computer with

.EXAMPLE
Start-PDQCollectionScan -Collection "Online Systems" -ScanProfile "Standard"
Scan the target collection "Online Systems" with the "Standard" scan profile

.NOTES
Author: Chris Bayliss
Version: 1.0
Date: 12/05/2019
#>

    [CmdletBinding(DefaultParameterSetName = 'Default')]
    param (
        [Parameter(Mandatory = $true, 
            ParameterSetName = 'Default', 
            Position = 0)] 
        [string[]]$Collection,

        [Parameter(Mandatory = $false, 
            ParameterSetName = 'Default', 
            Position = 1)] 
        [string]$ScanProfile = "Standard"
    )

    process {
        if (Get-Command pdqinventory.exe -ErrorAction SilentlyContinue) {
            PDQInventory.exe ScanCollection -ScanProfile $ScanProfile -Computers $Computer
        }
        else {
            Throw "PDQInventory.exe not in path or not installed."
        }
    }
}