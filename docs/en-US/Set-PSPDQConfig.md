---
external help file: PSPDQ-help.xml
Module Name: PSPDQ
online version:
schema: 2.0.0
---

# Set-PSPDQConfig

## SYNOPSIS
Sets configuration for PSPDQ module.

## SYNTAX

```
Set-PSPDQConfig [-PDQDeployServer] <String> [-PDQInventoryServer] <String> [-PDQDeployDBPath] <String>
 [-PDQInventoryDBPath] <String> [<CommonParameters>]
```

## DESCRIPTION
Sets sever hostname and database path information for PDQ Deploy and Inventory to json file within $env:APPDATA
By default, database files will be located within:
PDQ Deploy: "C:\ProgramData\PDQ Deploy\Database.db"
PDQ Inventory: "C:\ProgramData\PDQ Inventory\Database.db"

Be sure to set the database path as the LOCAL path to the file.
As in "Drive:\file\path" NOT "\\\\UNCpath\file\path"

## EXAMPLES

### EXAMPLE 1
```
Set-PSPDQConfig -PDQDeployServer PDQSERVER1 -PDQInventoryServer PDQSERVER2 -PDQDeployDBPath "C:\ProgramData\PDQ Deploy\Database.db" -PDQInventoryDBPath "C:\ProgramData\PDQ Inventory\Database.db"
```

## PARAMETERS

### -PDQDeployServer
Hostname or FQDN or PDQ Deploy server

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PDQInventoryServer
Hostname or FQDN or PDQ Inventory server

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PDQDeployDBPath
Full LOCAL path of PDQ Deploy database

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PDQInventoryDBPath
Full LOCAL path of PDQ Inventory database

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Author: Chris Bayliss
Version: 1.0
Date: 12/05/2019

## RELATED LINKS
