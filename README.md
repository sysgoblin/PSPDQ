# PSPDQ (WIP)

A powershell module for PDQ Deploy and Inventory administration and querying.

It can be utilised for querying the PDQ Sqlite db's directly without needing to load, or install the PDQ Deploy and Inventory client software. 

Cmdlets are also included for starting computer or collection scans, as well as deploying named packages from within Powershell. (Please note, these cmdlets will require PDQ Deploy and Inventory to be installed locally as client or server)

## Installation
```Powershell
git clone https://github.com/sysgoblin/PSPDQ
cd PSPDQ
Import-Module .\PSPDQ.psm1
```
The first cmdlet you should run is: `Set-PSPDQConfig` to configure the PDQ Deploy and Inventory server information.
```Powershell
Set-PSPDQConfig -PDQDeployServer PDQSERVER1 -PDQInventoryServer PDQSERVER2 -PDQDeployDBPath "C:\ProgramData\PDQ Deploy\Database.db" -PDQInventoryDBPath "C:\ProgramData\PDQ Inventory\Database.db"
```
**Database paths should be LOCAL to the server**

## Usage examples
Do you live in the shell and want to find out what the 10 most recent deployments have been?
```powershell
Get-PDQDeployment -Range 10
```

And then you want to get details on those computers from the past 10 deployments?
```powershell
Get-PDQDeployment -Range 10 | Get-PDQComputer
```

Or you want to find out what applications they all have installed?
```powershell
Get-PDQDeployment -Range 10 | Get-PDQComputerApplications
```

Or maybe get patches for each computer installed in the past 3 days?
```powershell
Get-PDQDeployment -Range 10 | Get-PDQHotFix | ? InstalledOn -le (Get-Date).AddDays(-3)
```