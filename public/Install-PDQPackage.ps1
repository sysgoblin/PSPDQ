function Install-PDQPackage {
    <#
.SYNOPSIS
Triggers deployment of PDQ package to specified target(s)

.DESCRIPTION
Starts deployment of specified PDQ Packages either by ID number or matching name, to specified target computers.
If an exact match is not found for package name, any matches will be listed and the user will be prompted to select the corresponding ID for the package they wish to deploy.

.PARAMETER Computer
Target machine(s) to deploy package to

.PARAMETER PackageID
ID number of package to deploy

.PARAMETER PackageName
Name of package to deploy

.EXAMPLE
Install-PDQPackage -Computer WK01, WK02 -PackageID 101
Deployes package with ID 101 to targets WK01, WK02

.EXAMPLE
Install-PDQPackage -Computer WK01 -PackageName Chrome
PackageID PackageName                            Version
--------- -----------                            -------
6         Google Chrome Enterprise 74.0.3729.131 74.0.3729.131
47        Google Chrome Enterprise 73.0.3683.86  73.0.3683.86
58        Google Chrome Enterprise 73.0.3683.103 73.0.3683.103
65        Google Chrome Enterprise 74.0.3729.108 74.0.3729.108

Multiple matches, select Package ID: 6

Deploys package 6 to target WK01. As "Chrome" as a string matches multiple packages, the user was prompted to choose from those available.

.NOTES
Author: Chris Bayliss
Version: 1.0
Date: 12/05/2019
#>


    [CmdletBinding(SupportsShouldProcess = $True)]
    param (
        [Parameter(Mandatory = $true, 
            ValueFromPipelineByPropertyName)] 
        [string[]]$Computer,

        [Parameter(Mandatory = $true, 
            ParameterSetName = 'ID', 
            ValueFromPipelineByPropertyName)] 
        [int[]]$PackageID,

        [Parameter(Mandatory = $true, 
            ParameterSetName = 'Name', 
            ValueFromPipelineByPropertyName)] 
        [string[]]$PackageName
    )

    process {

        if (!(Test-Path -Path "$($env:AppData)\pspdq\config.json")) {
            Throw "PSPDQ Configuration file not found in `"$($env:AppData)\pspdq\config.json`", please run Set-PSPDQConfig to configure module settings."
        }
        else {
            $config = Get-Content "$($env:AppData)\pspdq\config.json" | ConvertFrom-Json

            $Server = $config.Server.PDQDeployServer
            $DatabasePath = $config.DBPath.PDQDeployDB
        }

        if ($PSCmdlet.ParameterSetName -eq 'ID') {
            $Package = @()

            $PackageID | % {
                $i = $_
                $sql = "SELECT PackageID, Name FROM Packages WHERE PackageID = $i"
                $packages = Invoke-Command -Computer $Server -ScriptBlock { $args[0] | sqlite3.exe $args[1] } -ArgumentList $sql, $DatabasePath

                $packagesParsed = $packages | % {
                    $p = $_ -split '\|'
                    [PSCustomObject]@{
                        PackageID   = $p[0]
                        PackageName = $p[1]
                    }
                }

                $Package += ($packagesParsed).PackageName
            }
        }
        
        if ($PSCmdlet.ParameterSetName -eq 'Name') {
            $Package = @()

            $PackageName | % {
                try {
                    $n = $_
                    $sql = "SELECT PackageID, Name, Version FROM Packages WHERE Name LIKE '%%$n%%'"
                    $packages = Invoke-Command -Computer $Server -ScriptBlock { $args[0] | sqlite3.exe $args[1] } -ArgumentList $sql, $DatabasePath
                
                    $packagesParsed = $packages | % {
                        $p = $_ -split '\|'
                        [PSCustomObject]@{
                            PackageID   = $p[0]
                            PackageName = $p[1]
                            Version     = $p[2]
                        }
                    }
                
                    if ($packagesParsed.Count -gt 1) {
                        Write-Output "$($packagesParsed | out-string)"
                        $selection = Read-Host "Multiple matches, select Package ID"
                
                        $Package += ($packagesParsed | ? PackageID -eq $selection).PackageName
                    }
                    else {
                        $Package += ($packagesParsed).PackageName
                    }
                }
                catch {
                    Throw "No packages found matching $n"
                }
            }
        }
    
        foreach ($pkg in $Package) {
            PDQDeploy.exe Deploy -Package $pkg -Targets $Computer
        }
    }
}