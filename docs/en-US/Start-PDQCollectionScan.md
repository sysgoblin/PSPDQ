---
external help file: PSPDQ-help.xml
Module Name: PSPDQ
online version:
schema: 2.0.0
---

# Start-PDQCollectionScan

## SYNOPSIS
Scan target collection with specified scan profile.

## SYNTAX

```
Start-PDQCollectionScan [-Collection] <String[]> [[-ScanProfile] <String>] [-Credential <PSCredential>]
 [<CommonParameters>]
```

## DESCRIPTION
Scan the target collection with the scan profile specified.
By default the "Standard" profile will be used.
Requires PDQ Inventory client or server to be installed locally.

## EXAMPLES

### EXAMPLE 1
```
Start-PDQCollectionScan -Collection "Online Systems" -ScanProfile "Standard"
```

Scan the target collection "Online Systems" with the "Standard" scan profile

## PARAMETERS

### -Collection
Name of collection to scan

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: Name

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ScanProfile
Profile to scan the target computer with

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: Standard
Accept pipeline input: False
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
