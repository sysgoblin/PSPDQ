function Get-PDQSchedule {

    [CmdletBinding(DefaultParameterSetName = 'Default', SupportsShouldProcess = $True)]
    param (
        # Returns all information
        [Parameter(Mandatory = $false,
        ParameterSetName = 'All')]
        [switch]$All,

        # Returns information for computer(s) where the specified user is or has been active
        [Parameter(Mandatory = $false,
        ParameterSetName = 'Package')]
        [string[]]$ScheduleName,

        [Parameter(Mandatory = $false,
        ParameterSetName = 'Package')]
        [int[]]$ScheduleId,

        [Parameter(Mandatory = $false)]
        [ValidateSet('')]
        [string[]]$Properties,

        [PSCredential]$Credential
    )

    begin {
        Get-PSPDQConfig
    }

    process {
        if ($PSBoundParameters.ContainsKey('Properties')) {
            $defaultProps = "Schedules.ScheduleId", "Schedules.Name", "Packages.PackageId", "Packages.Name", "ScheduleTriggers.TriggerType", "ScheduleTriggers.IsEnabled"
            $allProps = $defaultProps + $Properties
        }
        else {
            $allProps = "Schedules.ScheduleId", "Schedules.Name", "Packages.PackageId", "Packages.Name", "ScheduleTriggers.TriggerType", "ScheduleTriggers.IsEnabled"
        }

        $Schedules = @()

        if ($PSCmdlet.ParameterSetName -eq 'All') {
            $sql = "SELECT " + ($allProps -join ', ') + "
                    FROM Schedules
                    INNER JOIN SchedulePackages ON SchedulePackages.ScheduleId = Schedules.ScheduleId
                    INNER JOIN Packages ON Packages.PackageId = SchedulePackages.LocalPackageId
                    INNER JOIN ScheduleTriggers ON ScheduleTriggers.ScheduleTriggerSetId = Schedules.ScheduleTriggerSetId"

            $icmParams = @{
                Computer     = $Server
                ScriptBlock  = { $args[0] | sqlite3.exe $args[1] }
                ArgumentList = $sql, $DatabasePath
            }
            if ($Credential) { $icmParams['Credential'] = $Credential }
            $Schedules += Invoke-Command @icmParams
        }

        # obj builder
        $schedulesParsed = @()
        $Schedules | ForEach-Object {
            $propsParsed = $_ -split '\|'
            $schedObj = New-Object pscustomobject
            for ($p = 0; $p -lt $allProps.count; $p++) {

                switch ($allProps[$p]) {
                    "Schedules.ScheduleId" { $propName = "ScheduleId" }
                    "Schedules.Name" { $propName = "ScheduleName" }
                    "Packages.PackageId" { $propName = "PackageId" }
                    "Packages.Name" { $propName = "PackageName" }
                    "ScheduleTriggers.TriggerType" { $propName = "TriggerType" }
                    "ScheduleTriggers.IsEnabled" { $propName = "IsEnabled" }
                }

                $schedObj | Add-Member NoteProperty $propName $propsParsed[$p]
            }
            $schedulesParsed += $schedObj
        }

        $schedulesParsed
    }
}
