---
Module Name: PSPDQ
Module Guid: 8dfbe930-ce2a-4bcc-bc9b-e6d0515c805f
Download Help Link: Not available.
Help Version: 0.0.0.0
Locale: en-US
---

# PSPDQ Module
## Description
The PSPDQ module has been written to allow for quick, simple and easy querying and administration of PDQ's suite of tools under Deploy and Inventory.

Using the module it is possble to query for information of machines, remotely deploy software, trigger computer scans, get package information and much more.

Information is collected from Deploy and Inventory utilising sql queries ran directly against the Deploy and Inventory SQLite databases, meaning it is possible to extract large amounts of data quickly without having to build custom reports or waiting for the UI. These results can then be piped to other cmdlets within the module to get further information as required, or exported as defined by the user.

It is possible to invoke all cmdlets with the Credential paremeter allowing for the user to authenticate against PDQ Deploy and Inventory with credentials of a licensed user.

## PSPDQ Cmdlets
### [Get-PDQCollection](Get-PDQCollection.md)
{{ Fill in the Description }}

### [Get-PDQCollectionMembers](Get-PDQCollectionMembers.md)
{{ Fill in the Description }}

### [Get-PDQComputer](Get-PDQComputer.md)
{{ Fill in the Description }}

### [Get-PDQComputerApplications](Get-PDQComputerApplications.md)
{{ Fill in the Description }}

### [Get-PDQDeployment](Get-PDQDeployment.md)
{{ Fill in the Description }}

### [Get-PDQDeploymentSteps](Get-PDQDeploymentSteps.md)
{{ Fill in the Description }}

### [Get-PDQHotFixes](Get-PDQHotFixes.md)
{{ Fill in the Description }}

### [Get-PDQPackage](Get-PDQPackage.md)
{{ Fill in the Description }}

### [Get-PDQSchedule](Get-PDQSchedule.md)
{{ Fill in the Description }}

### [Get-PDQScheduleTargets](Get-PDQScheduleTargets.md)
{{ Fill in the Description }}

### [Install-PDQPackage](Install-PDQPackage.md)
{{ Fill in the Description }}

### [Set-PSPDQConfig](Set-PSPDQConfig.md)
{{ Fill in the Description }}

### [Start-PDQCollectionScan](Start-PDQCollectionScan.md)
{{ Fill in the Description }}

### [Start-PDQComputerScan](Start-PDQComputerScan.md)
{{ Fill in the Description }}

