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
        [string[]]$Properties   
    )
        
    process {   

        if (!(Test-Path -Path "$($env:AppData)\pspdq\config.json")) {
            Throw "PSPDQ Configuration file not found in `"$($env:AppData)\pspdq\config.json`", please run Set-PSPDQConfig to configure module settings."
        } else {
            $config = Get-Content "$($env:AppData)\pspdq\config.json" | ConvertFrom-Json

            $Server = $config.Server.PDQDeployServer
            $DatabasePath = $config.DBPath.PDQDeployDB
        }

        if ($PSBoundParameters.ContainsKey('Properties')) {
            $defaultProps = "Schedules.ScheduleId", "Schedules.Name", "Packages.PackageId", "Packages.Name", "ScheduleTriggers.TriggerType", "ScheduleTriggers.IsEnabled"
            $allProps = $defaultProps + $Properties
        } else {
            $allProps = "Schedules.ScheduleId", "Schedules.Name", "Packages.PackageId", "Packages.Name", "ScheduleTriggers.TriggerType", "ScheduleTriggers.IsEnabled"
        }

        $Schedules = @()

        if ($PSCmdlet.ParameterSetName -eq 'All') {
            $sql = "SELECT " + ($allProps -join ', ') + "
                    FROM Schedules
                    INNER JOIN SchedulePackages ON SchedulePackages.ScheduleId = Schedules.ScheduleId
                    INNER JOIN Packages ON Packages.PackageId = SchedulePackages.LocalPackageId
                    INNER JOIN ScheduleTriggers ON ScheduleTriggers.ScheduleTriggerSetId = Schedules.ScheduleTriggerSetId"

            $Schedules += Invoke-Command -Computer $Server -ScriptBlock { $args[0] | sqlite3.exe $args[1] } -ArgumentList $sql, $DatabasePath
        }
        
        # obj builder
        $schedulesParsed = @()
        $Schedules | % {
            $propsParsed = $_ -split '\|'
            $schedObj = New-Object pscustomobject
            for ($p=0; $p -lt $allProps.count; $p++) {

                switch ($allProps[$p]) {
                    "Schedules.ScheduleId" { $propName = "ScheduleId" }
                    "Schedules.Name" { $propName = "ScheduleName" }
                    "Packages.PackageId"  { $propName = "PackageId" }
                    "Packages.Name" { $propName = "PackageName" }
                    "ScheduleTriggers.TriggerType" { $propName = "TriggerType" }
                    "ScheduleTriggers.IsEnabled" { $propName = "IsEnabled" }
                }

                $schedObj | Add-Member NoteProperty $propName $propsParsed[$p]
            }
            $schedulesParsed += $schedObj
        }

        return $schedulesParsed
    }
}