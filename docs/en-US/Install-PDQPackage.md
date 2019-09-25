---
external help file: PSPDQ-help.xml
Module Name: PSPDQ
online version:
schema: 2.0.0
---

# Install-PDQPackage

## SYNOPSIS
Triggers deployment of PDQ package to specified target(s)

## SYNTAX

### ID
```
Install-PDQPackage -Computer <String[]> -PackageID <Int32[]> [-Credential <PSCredential>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### Name
```
Install-PDQPackage -Computer <String[]> -PackageName <String[]> [-Credential <PSCredential>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Starts deployment of specified PDQ Packages either by ID number or matching name, to specified target computers.
If an exact match is not found for package name, any matches will be listed and the user will be prompted to select the corresponding ID for the package they wish to deploy.

## EXAMPLES

### EXAMPLE 1
```
Install-PDQPackage -Computer WK01, WK02 -PackageID 101
```

Deployes package with ID 101 to targets WK01, WK02

### EXAMPLE 2
```
Install-PDQPackage -Computer WK01 -PackageName Chrome


PackageID PackageName                            Version
--------- -----------                            -------
6         Google Chrome Enterprise 74.0.3729.131 74.0.3729.131
47        Google Chrome Enterprise 73.0.3683.86  73.0.3683.86
58        Google Chrome Enterprise 73.0.3683.103 73.0.3683.103
65        Google Chrome Enterprise 74.0.3729.108 74.0.3729.108

Multiple matches, select Package ID: 6
```

Deploys package 6 to target WK01.
As "Chrome" as a string matches multiple packages, the user was prompted to choose from those available.

## PARAMETERS

### -Computer
Target machine(s) to deploy package to

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: Name

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -PackageID
ID number of package to deploy

```yaml
Type: Int32[]
Parameter Sets: ID
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -PackageName
Name of package to deploy

```yaml
Type: String[]
Parameter Sets: Name
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Credential
Specifies a user account that has permissions to perform this action.

```yaml
Type: PSCredential
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
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
