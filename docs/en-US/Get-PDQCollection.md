---
external help file: PSPDQ-help.xml
Module Name: PSPDQ
online version:
schema: 2.0.0
---

# Get-PDQCollection

## SYNOPSIS
Returns information on PDQ Inventory collections

## SYNTAX

### ColName
```
Get-PDQCollection [-CollectionName <String[]>] [-Properties <String[]>] [-Credential <PSCredential>]
 [<CommonParameters>]
```

### ColID
```
Get-PDQCollection [-CollectionId <Int32[]>] [-Properties <String[]>] [-Credential <PSCredential>]
 [<CommonParameters>]
```

### All
```
Get-PDQCollection [-All] [-Properties <String[]>] [-Credential <PSCredential>] [<CommonParameters>]
```

## DESCRIPTION
Returns information on either all or specified PDQ Inventory collections

## EXAMPLES

### EXAMPLE 1
```
Get-PDQCollection -CollectionName "Online"
```

Returns information on all collections matching the string "Online"

## PARAMETERS

### -CollectionName
Collection name to query

```yaml
Type: String[]
Parameter Sets: ColName
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CollectionId
Collection ID number to query

```yaml
Type: Int32[]
Parameter Sets: ColID
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -All
Returns information on all collections

```yaml
Type: SwitchParameter
Parameter Sets: All
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Properties
Properties to return

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
