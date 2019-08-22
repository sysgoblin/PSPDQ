---
external help file: PSPDQ-help.xml
Module Name: PSPDQ
online version:
schema: 2.0.0
---

# Get-PDQPackage

## SYNOPSIS
Get PDQ package information

## SYNTAX

### ID
```
Get-PDQPackage [-PackageID <Int32>] [-Credential <PSCredential>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Name
```
Get-PDQPackage [-PackageName <String>] [-Credential <PSCredential>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Approved
```
Get-PDQPackage [-Approved] [-Credential <PSCredential>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Waiting
```
Get-PDQPackage [-AwaitingApproval] [-Credential <PSCredential>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Retreives PDQ package information for specified package, approved packages or packages awaiting approval

## EXAMPLES

### EXAMPLE 1
```
Get-PDQPackage -PackageName "Chrome Enterprise 74"
```

PackageID   : 6
PackageName : Google Chrome Enterprise 74.0.3729.131
Version     : 74.0.3729.131
Path        : Packages\Google Chrome Enterprise 74.0.3729.131
Description : Google Chrome Enterprise (with BOTH 32-bit and 64-bit installers)...

Returns a list of approved PDQ packages matching the string "Chrome Enterprise 74"

## PARAMETERS

### -PackageID
ID of PDQ Deploy package to retreive information on

```yaml
Type: Int32
Parameter Sets: ID
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -PackageName
Name of PDQ Deploy package to retreive information on

```yaml
Type: String
Parameter Sets: Name
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Approved
Returns a list of approved PDQ Deploy packages

```yaml
Type: SwitchParameter
Parameter Sets: Approved
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -AwaitingApproval
Returns a list of PDQ Deploy packages awaiting approval

```yaml
Type: SwitchParameter
Parameter Sets: Waiting
Aliases:

Required: False
Position: Named
Default value: False
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
