function Get-PDQComputerInfo {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$Computer,

        [Parameter(Mandatory = $true)]
        [ValidateSet("Tasks", "Services", "LocalUsers", "LocalGroups", "Disks")]
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

            Disks {
                $sql = "SELECT
                LogicalDisks.ComputerId,
                Computers.Name,
                DiskDrives.DiskDeviceId,
                DiskDrives.Model,
                DiskDrives.InterfaceType,
                DiskDrives.SerialNumber,
                DiskDrives.SmartStatus,
                DiskDrives.PhysicalDiskType,
                LogicalDisks.FileSystem,
                LogicalDisks.Size,
                LogicalDisks.FreeSpace,
                LogicalDisks.EncryptionMethod,
                LogicalDisks.BitLockerVersion,
                LogicalDisks.PercentageEncrypted,
                LogicalDisks.KeyProtectors,
                LogicalDisks.ConversionStatus,
                LogicalDisks.LogicalDeviceId
                FROM LogicalDisks
                INNER JOIN Computers ON LogicalDisks.ComputerId = Computers.ComputerId
                INNER JOIN DiskDrives ON LogicalDisks.ComputerId = DiskDrives.ComputerId
                WHERE Computers.name LIKE '%%$Computer%%'
                "

                $icmParams = @{
                    Computer     = $invServer
                    ScriptBlock  = { $args[0] | sqlite3.exe $args[1] }
                    ArgumentList = $sql, $invDatabasePath
                }
                if ($Credential) { $icmParams['Credential'] = $Credential }
                $disks = Invoke-Command @icmParams

                $disksParsed = $disks | ForEach-Object {
                    $d = $_ -split '\|'
                    [PSCustomObject]@{
                        ComputerId          = $d[0]
                        Computer            = $d[1]
                        Model               = $d[3]
                        InterfaceType       = $d[4]
                        SmartStatus         = $d[6]
                        DriveLetter         = $d[16]
                        PhysicalDiskType    = $d[7]
                        FileSystem          = $d[8]
                        Size                = $d[9]
                        FreeSpace           = $d[10]
                        FreeSpacePercent    = ($d[10]/$d[9]).ToString("P")
                        SerialNumber        = $d[5]
                        EncryptionMethod    = $d[11]
                        BitLockerVersion    = $d[12]
                        PercentageEncrypted = $d[13]
                        KeyProtectors       = $d[14]
                        ConversionStatus    = $d[15]
                    }
                }

                $out = $disksParsed
            }
        }

    }

    end {
        return $out
    }
}