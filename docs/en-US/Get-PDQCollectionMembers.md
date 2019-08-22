---
external help file: PSPDQ-help.xml
Module Name: PSPDQ
online version:
schema: 2.0.0
---

# Get-PDQCollectionMembers

## SYNOPSIS
Returns members of specified PDQ Inventory collection

## SYNTAX

### ColName
```
Get-PDQCollectionMembers [[-CollectionName] <String>] [-Properties <String[]>] [-Credential <PSCredential>]
 [<CommonParameters>]
```

### ColID
```
Get-PDQCollectionMembers [-CollectionID <Int32>] [-Properties <String[]>] [-Credential <PSCredential>]
 [<CommonParameters>]
```

## DESCRIPTION
Returns members of specified PDQ Inventory collection

## EXAMPLES

### EXAMPLE 1
```
Get-PDQCollectionMembers -CollectionID 1
```

## PARAMETERS

### -CollectionName
Name of collection to return members of

```yaml
Type: String
Parameter Sets: ColName
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -CollectionID
ID of collection to return members of

```yaml
Type: Int32
Parameter Sets: ColID
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Properties
{{ Fill Properties Description }}

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
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

## RELATED LINKS
