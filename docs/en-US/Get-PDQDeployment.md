---
external help file: PSPDQ-help.xml
Module Name: PSPDQ
online version:
schema: 2.0.0
---

# Get-PDQDeployment

## SYNOPSIS
Get details on PDQ Deploy deployment

## SYNTAX

### Comp
```
Get-PDQDeployment [-Computer <String[]>] [-Credential <PSCredential>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Name
```
Get-PDQDeployment [-PackageName <String>] [-Credential <PSCredential>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### ID
```
Get-PDQDeployment [-PackageID <Int32>] [-Credential <PSCredential>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### DepID
```
Get-PDQDeployment [-DeploymentID <Int32>] [-Credential <PSCredential>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### Recent
```
Get-PDQDeployment [-Recent <Int32>] [-Credential <PSCredential>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Retreives details on PDQ Deploy deployments for the specified computer, deployment id, or package

## EXAMPLES

### EXAMPLE 1
```
Get-PDQDeployment -PackageID 1
```

Returns deployment data for the package with the ID of 1

### EXAMPLE 2
```
Get-PDQPackage -PackageName "7-Zip" | Get-PDQDeployment
```

Returns deployment data for applications containing "7-Zip" in the name

## PARAMETERS

### -Computer
Will return all deployment data related to target

```yaml
Type: String[]
Parameter Sets: Comp
Aliases: Name

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -PackageName
Returns deployment data for specified package

```yaml
Type: String
Parameter Sets: Name
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -PackageID
Returns deployment data for specified package

```yaml
Type: Int32
Parameter Sets: ID
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -DeploymentID
Returns deployment data for specified deployment id

```yaml
Type: Int32
Parameter Sets: DepID
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Recent
Returns most recent deployment information for up to the entered number

```yaml
Type: Int32
Parameter Sets: Recent
Aliases:

Required: False
Position: Named
Default value: 10
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
