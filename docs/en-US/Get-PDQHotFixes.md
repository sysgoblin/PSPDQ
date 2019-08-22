---
external help file: PSPDQ-help.xml
Module Name: PSPDQ
online version:
schema: 2.0.0
---

# Get-PDQHotFixes

## SYNOPSIS
Get information on hotfix/patches installed on specified target

## SYNTAX

### Default (Default)
```
Get-PDQHotFixes [-Credential <PSCredential>] [<CommonParameters>]
```

### Comp
```
Get-PDQHotFixes [[-Computer] <String>] [-Credential <PSCredential>] [<CommonParameters>]
```

### HF
```
Get-PDQHotFixes [-HotFix <String>] [-Credential <PSCredential>] [<CommonParameters>]
```

## DESCRIPTION
Retreives information on all hotfixes/patches installed on the target systems which have been scanned by PDQ Inventory.

## EXAMPLES

### EXAMPLE 1
```
Get-PDQHotFixes -Computer WK01
```

Returns all patches installed on WK01

### EXAMPLE 2
```
Get-PDQHotFixes -HotFix KB000001
```

Returns a list of machines which have patch "KB00001" installed

## PARAMETERS

### -Computer
Target computer to return hotfix/patch information for

```yaml
Type: String
Parameter Sets: Comp
Aliases: Name

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -HotFix
Specified hotfix/patch to return information for

```yaml
Type: String
Parameter Sets: HF
Aliases:

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Author: Chris Bayliss
Version: 1.0
Date: 12/05/2019

## RELATED LINKS
