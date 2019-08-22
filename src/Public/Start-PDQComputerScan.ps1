function Start-PDQComputerScan {
<#
.SYNOPSIS
Scan target machine with specified scan profile.

.DESCRIPTION
Scan the target computer or server with the scan profile specified. By default the "Standard" profile will be used.

.PARAMETER Computer
Target to scan

.PARAMETER ScanProfile
Profile to scan the target computer with

.PARAMETER Credential
Specifies a user account that has permissions to perform this action.

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
        [string]$ScanProfile = "Standard",

        [PSCredential]$Credential
    )

    begin {
        Get-PSPDQConfig
    }

    process {
        $icmParams = @{
            Computer     = $invServer
            ScriptBlock  = { PDQInventory.exe ScanComputers -ScanProfile $using:ScanProfile -Computers $using:Computer }
            ArgumentList = $ScanProfile, $computer
        }
        if ($Credential) { $icmParams['Credential'] = $Credential }
        Invoke-Command @icmParams
    }
}
