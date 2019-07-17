# PSPDQ (beta)
### **Note: this is still very much WIP and features will be changed/added. PR's welcome.**

A powershell module for PDQ Deploy and Inventory administration and querying.

It can be utilised for querying the PDQ Sqlite db's directly without needing to load, or install the PDQ Deploy and Inventory client software.

Cmdlets are also included for starting computer or collection scans, as well as deploying named packages from within Powershell. (Please note, these cmdlets will require PDQ Deploy and Inventory to be installed locally as client or server)

## Installation
```Powershell
git clone https://github.com/sysgoblin/PSPDQ
cd PSPDQ
Import-Module .\PSPDQ.psm1
```
If you don't have PDQ Deploy/Inventory installed you may also need to install sqlite3. `https://www.sqlite.org/download.html`

The first cmdlet you should run is: `Set-PSPDQConfig` to configure the PDQ Deploy and Inventory server information.
```Powershell
Set-PSPDQConfig -PDQDeployServer PDQSERVER1 -PDQInventoryServer PDQSERVER2 -PDQDeployDBPath "C:\ProgramData\PDQ Deploy\Database.db" -PDQInventoryDBPath "C:\ProgramData\PDQ Inventory\Database.db"
```
**Database paths should be LOCAL to the server**

## Examples
Get the last 10 deployments and their status:
```powershell
Get-PDQDeployment -Range 10
```

Get the basic computer details of each computer the last 10 deployments went to:
```powershell
Get-PDQDeployment -Range 10 | Get-PDQComputer
```

Get the applications installed on those computers instead:
```powershell
Get-PDQDeployment -Range 10 | Get-PDQComputerApplications
```

Or maybe get patches for each computer installed in the past 3 days because why not?
```powershell
Get-PDQDeployment -Range 10 | Get-PDQHotFix | ? InstalledOn -le (Get-Date).AddDays(-3)
```