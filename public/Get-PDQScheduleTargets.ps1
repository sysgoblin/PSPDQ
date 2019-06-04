function Get-PDQScheduleTargets {

    [CmdletBinding(DefaultParameterSetName = 'Default', SupportsShouldProcess = $True)]
    param (
        [Parameter(Mandatory = $false, 
        ParameterSetName = 'Name')] 
        [string[]]$ScheduleName,   

        [Parameter(Mandatory = $false, 
        ParameterSetName = 'ID')] 
        [int[]]$ScheduleId   
    )
        
    process {   

        if (!(Test-Path -Path "$($env:AppData)\pspdq\config.json")) {
            Throw "PSPDQ Configuration file not found in `"$($env:AppData)\pspdq\config.json`", please run Set-PSPDQConfig to configure module settings."
        } else {
            $config = Get-Content "$($env:AppData)\pspdq\config.json" | ConvertFrom-Json

            $Server = $config.Server.PDQDeployServer
            $DatabasePath = $config.DBPath.PDQDeployDB
        }

        $Targets = @()

        if ($PSCmdlet.ParameterSetName -eq 'ID') {
                foreach ($id in $ScheduleId) {
                $sql = "SELECT Schedules.ScheduleId, Schedules.Name, Packages.PackageId, Packages.Name,  Targets.TargetType, Targets.Name
                FROM Targets
                INNER JOIN ScheduleTargets ON ScheduleTargets.TargetId = Targets.TargetId
                INNER JOIN Schedules ON ScheduleTargets.ScheduleId
                INNER JOIN SchedulePackages ON SchedulePackages.ScheduleId = Schedules.ScheduleId
                INNER JOIN Packages ON Packages.PackageId = SchedulePackages.LocalPackageId
                WHERE ScheduleTargets.ScheduleId = $id"

                $Targets += Invoke-Command -Computer $Server -ScriptBlock { $args[0] | sqlite3.exe $args[1] } -ArgumentList $sql, $DatabasePath
            }
        }

        if ($PSCmdlet.ParameterSetName -eq 'Name') {
            foreach ($Name in $ScheduleName) {
            $sql = "SELECT Schedules.ScheduleId, Schedules.Name, Packages.PackageId, Packages.Name,  Targets.TargetType, Targets.Name
            FROM Targets
            INNER JOIN ScheduleTargets ON ScheduleTargets.TargetId = Targets.TargetId
            INNER JOIN Schedules ON ScheduleTargets.ScheduleId
            INNER JOIN SchedulePackages ON SchedulePackages.ScheduleId = Schedules.ScheduleId
            INNER JOIN Packages ON Packages.PackageId = SchedulePackages.LocalPackageId
            WHERE Schedules.Name LIKE '%%$Name%%'"

            $Targets += Invoke-Command -Computer $Server -ScriptBlock { $args[0] | sqlite3.exe $args[1] } -ArgumentList $sql, $DatabasePath
        }
    }

        # obj builder
        $targetsParsed = $Targets | % {
            $p = $_ -split '\|'
            [PSCustomObject]@{
                ScheduldId      = $p[0]
                ScheduleName    = $p[1]
                PackageId       = $p[2]
                PackageName     = $p[3]
                TargetType      = $p[4]
                TargetName      = $p[5]
            }
        }

        return $targetsParsed
    }
}