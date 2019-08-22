---
external help file: PSPDQ-help.xml
Module Name: PSPDQ
online version:
schema: 2.0.0
---

# Get-PDQComputerApplications

## SYNOPSIS
Returns applications installed on target machine or all machines with application installed

## SYNTAX

### Comp
```
Get-PDQComputerApplications [[-Computer] <String[]>] [-Credential <PSCredential>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### App
```
Get-PDQComputerApplications [-Application <String[]>] [-Credential <PSCredential>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Returns applications installed on target machine or all machines with application installed

## EXAMPLES

### EXAMPLE 1
```
Get-PDQComputerApplications -Computer WK01
```

Returns applications installed on WK01

### EXAMPLE 2
```
Get-PDQComputerApplications -Application Chrome
```

Returns a list of machines with an application installed matching "Chrome"

## PARAMETERS

### -Computer
Target computer to return applications for

```yaml
Type: String[]
Parameter Sets: Comp
Aliases: Name

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Application
Application to search for

```yaml
Type: String[]
Parameter Sets: App
Aliases: PackageName

Required: False
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
