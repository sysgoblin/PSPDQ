function Get-PDQComputerInfo {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]    
        [string]$Computer,
        
        [Parameter(Mandatory = $true)]
        [ValidateSet("Tasks", "Services", "LocalUsers", "LocalGroups")]
        [string]$Information,

        [Parameter(Mandatory = $false)]
        [PSCredential]$Credential
    )
    
    begin {
        Get-PSPDQConfig
    }
    
    process {

        switch ($Information) {
            Tasks {
                $sql = "SELECT 
                WindowsTaskSchedules.ComputerId, 
                Computers.Name,
                WindowsTaskSchedules.TaskName, 
                WindowsTaskSchedules.Status, 
                WindowsTaskSchedules.NextRunTime,
                WindowsTaskSchedules.Folder
                FROM WindowsTaskSchedules
                INNER JOIN Computers on WindowsTaskSchedules.ComputerId = computers.ComputerId
                WHERE Computers.name LIKE '%%$Computer%%'"

                $icmParams = @{
                    Computer     = $invServer
                    ScriptBlock  = { $args[0] | sqlite3.exe $args[1] }
                    ArgumentList = $sql, $invDatabasePath
                }
                if ($Credential) { $icmParams['Credential'] = $Credential }
                $Tasks = Invoke-Command @icmParams

                $tasksParsed = $Tasks | ForEach-Object {
                    $t = $_ -split '\|'
                    [PSCustomObject]@{
                        ComputerId  = $t[0]
                        Computer    = $t[1]
                        Task        = $t[2]
                        Status      = $t[3]
                        NextRunTime = $t[4]
                        Folder      = $t[5]
                    }
                }

                $out = $tasksParsed
            }

            Services {
                $sql = "SELECT 
                Services.ComputerId, 
                Computers.Name,
                Services.Name, 
                Services.Title, 
                Services.Account,
                Services.StartMode,
                Services.PathName,
                Services.Description,
                Services.State
                FROM Services
                INNER JOIN Computers on Services.ComputerId = computers.ComputerId
                WHERE Computers.name LIKE '%%$Computer%%'"

                $icmParams = @{
                    Computer     = $invServer
                    ScriptBlock  = { $args[0] | sqlite3.exe $args[1] }
                    ArgumentList = $sql, $invDatabasePath
                }
                if ($Credential) { $icmParams['Credential'] = $Credential }
                $Services = Invoke-Command @icmParams

                $servicesParsed = $Services | ForEach-Object {
                    $s = $_ -split '\|'
                    [PSCustomObject]@{
                        ComputerId  = $s[0]
                        Computer    = $s[1]
                        Name        = $s[2]
                        Title = $s[3]
                        Account     = $s[4]
                        StartMode = $s[5]
                        Path = $s[6]
                        Description = $s[7]
                        State = $s[8]
                    }
                }

                $out = $servicesParsed
            }

            LocalGroups {
                $sql = "SELECT LocalGroups.LocalGroupId, LocalGroups.computerid, computers.name, LocalGroups.GroupName, LocalGroups.Description, LocalGroups.SID
                FROM LocalGroups
                INNER JOIN Computers on LocalGroups.ComputerId = computers.ComputerId
                WHERE Computers.Name LIKE '%%$Computer%%'"

                $icmParams = @{
                    Computer     = $invServer
                    ScriptBlock  = { $args[0] | sqlite3.exe $args[1] }
                    ArgumentList = $sql, $invDatabasePath
                }
                if ($Credential) { $icmParams['Credential'] = $Credential }
                $Groups = Invoke-Command @icmParams

                $groupsParsed = $Groups | ForEach-Object {
                    $g = $_ -split '\|'
                    [PSCustomObject]@{
                        GroupID     = $g[0]
                        ComputerID  = $g[1]
                        Computer    = $g[2]
                        Name        = $g[3]
                        Description = $g[4]
                        SID         = $g[5]
                        Members     = $null
                    }
                }

                $cId = $groupsParsed[0].ComputerID
                $mSql = "SELECT 
                LocalGroupMembers.computerid, 
                LocalGroupMembers.LocalGroupId, 
                LocalGroupMembers.GroupName, 
                LocalGroupMembers.UserDomain || '\' || LocalGroupMembers.UserName as 'User'
                FROM LocalGroupMembers
                INNER JOIN Computers on LocalGroupMembers.ComputerId = computers.ComputerId
                WHERE Computers.ComputerId = $cId"

                $icmParams = @{
                    Computer     = $invServer
                    ScriptBlock  = { $args[0] | sqlite3.exe $args[1] }
                    ArgumentList = $mSql, $invDatabasePath
                }
                if ($Credential) { $icmParams['Credential'] = $Credential }

                $Members = Invoke-Command @icmParams
                $membersParsed = $Members | ForEach-Object {
                    $m = $_ -split '\|'
                    [PSCustomObject]@{
                        GroupId = $m[1]
                        User    = $m[3]
                    }
                }

                $groupsParsed | % {
                    $g = $_
                    $g.Members = ($membersParsed.Where({$_.GroupId -eq $g.GroupID})).User
                }

                $out = $groupsParsed
            }

            LocalUsers {
                $sql = "SELECT 
                LocalUsers.ComputerId, 
                Computers.Name,
                LocalUsers.UserName, 
                LocalUsers.Description, 
                LocalUsers.IsDisabled,
                LocalUsers.SID
                FROM LocalUsers
                INNER JOIN Computers on LocalUsers.ComputerId = computers.ComputerId
                WHERE Computers.name LIKE '%%$Computer%%'"

                $icmParams = @{
                    Computer     = $invServer
                    ScriptBlock  = { $args[0] | sqlite3.exe $args[1] }
                    ArgumentList = $sql, $invDatabasePath
                }
                if ($Credential) { $icmParams['Credential'] = $Credential }
                $Users = Invoke-Command @icmParams

                $usersParsed = $Users | ForEach-Object {
                    $u = $_ -split '\|'
                    [PSCustomObject]@{
                        ComputerId  = $u[0]
                        Computer    = $u[1]
                        User        = $u[2]
                        Description = $u[3]
                        Enabled     = $(if ($u[4] -eq '1') { "Disabled" } else { "Enabled" })
                    }
                }

                $out = $usersParsed
            }
        }

    }
    
    end {
        return $out
    }
}