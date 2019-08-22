using namespace System.Management.Automation

<#
    [Error]::PathNotFound($Path) is provided as an example below. To use these errors:

        throw [Terminating]

            throw [Error]::PathNotFound($MyPath)

        $PSCmdlet.ThrowTerminatingError [Terminating]

            $PSCmdlet.ThrowTerminatingError([Error]::PathNotFound($MyPath))

        $PSCmdlet.WriteError

            $PSCmdlet.WriteError([Error]::PathNotFound($MyPath))

    Valid error categories:

        PS> [enum]::GetValues([System.Management.Automation.ErrorCategory])
#>

class Error {
    static [ErrorRecord] PathNotFound([string]$Path) {
        $Exception = [System.ArgumentException]::new("Cannot find path '$Path' because it does not exist.")
        $ErrorCategory = [ErrorCategory]::ObjectNotFound
        return [ErrorRecord]::new($Exception, 'PathNotFound', $ErrorCategory, $Path)
    }
}

