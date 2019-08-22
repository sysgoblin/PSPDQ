function Get-PDQScheduleTargets {

    [CmdletBinding(DefaultParameterSetName = 'Default', SupportsShouldProcess = $True)]
    param (
        [Parameter(Mandatory = $false,
        ParameterSetName = 'Name')]
        [string[]]$ScheduleName,

        [Parameter(Mandatory = $false,
        ParameterSetName = 'ID')]
        [int[]]$ScheduleId,

        [PSCredential]$Credential
    )

    begin {
        Get-PSPDQConfig
    }

    process {
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

                $icmParams = @{
                    Computer     = $depServer
                    ScriptBlock  = { $args[0] | sqlite3.exe $args[1] }
                    ArgumentList = $sql, $depDatabasePath
                }
                if ($Credential) { $icmParams['Credential'] = $Credential }
                $Targets += Invoke-Command @icmParams
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

                $icmParams = @{
                    Computer     = $depServer
                    ScriptBlock  = { $args[0] | sqlite3.exe $args[1] }
                    ArgumentList = $sql, $depDatabasePath
                }
                if ($Credential) { $icmParams['Credential'] = $Credential }
                $Targets += Invoke-Command @icmParams
            }
        }

        # obj builder
        $targetsParsed = $Targets | ForEach-Object {
            $p = $_ -split '\|'
            [PSCustomObject]@{
                ScheduldId   = $p[0]
                ScheduleName = $p[1]
                PackageId    = $p[2]
                PackageName  = $p[3]
                TargetType   = $p[4]
                TargetName   = $p[5]
            }
        }

        $targetsParsed
    }
}
