function CheckAndExecuteTask {
    <#
    .SYNOPSIS
    Checks for an existing scheduled task and executes tasks based on conditions.

    .DESCRIPTION
    This function checks if a scheduled task with the specified name exists. If it does, it executes detection and remediation scripts. If not, it sets up a new task environment and registers the task. Enhanced logging is used for status messages, and error handling manages potential issues.

    .PARAMETER schtaskName
    The name of the scheduled task to check and potentially execute.

    .PARAMETER Path_PR
    The path to the directory containing the detection and remediation scripts, used if the task needs to be executed.

    .PARAMETER ScriptMode
    The mode in which the script should run.

    .PARAMETER PackageExecutionContext
    The context in which the package should execute (e.g., User, System).

    .PARAMETER schtaskDescription
    The description of the scheduled task.

    .PARAMETER RepetitionInterval
    The interval at which the task should repeat (e.g., "P1D").

    .PARAMETER Path_VBShiddenPS
    The path to the hidden PowerShell script file executed by VBScript.

    .EXAMPLE
    CheckAndExecuteTask -schtaskName "MyScheduledTask" -Path_PR "C:\Tasks\MyTask" -ScriptMode "Remediation" -PackageExecutionContext "System" -schtaskDescription "Task Description" -RepetitionInterval "P1D" -Path_VBShiddenPS "C:\Scripts\HiddenPS.vbs"

    This example checks for an existing scheduled task and executes the associated detection and remediation scripts if the task exists. Otherwise, it sets up a new task environment and registers the task.
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, HelpMessage = "Provide the name of the scheduled task.")]
        [string]$schtaskName,

        [Parameter(Mandatory = $true, HelpMessage = "Provide the path to the directory for detection and remediation scripts.")]
        [string]$Path_PR,

        [Parameter(Mandatory = $true, HelpMessage = "Specify the script mode (e.g., Remediation, Detection).")]
        [string]$ScriptMode,

        [Parameter(Mandatory = $true, HelpMessage = "Specify the execution context for the package (e.g., System, User).")]
        [string]$PackageExecutionContext,

        [Parameter(Mandatory = $true, HelpMessage = "Provide the description of the scheduled task.")]
        [string]$schtaskDescription,

        [Parameter(Mandatory = $true, HelpMessage = "Specify the task repetition interval (e.g., P1D).")]
        [string]$RepetitionInterval,

        [Parameter(Mandatory = $true, HelpMessage = "Provide the path to the VBScript for hidden PowerShell execution.")]
        [string]$Path_VBShiddenPS
    )

    Begin {
        Write-EnhancedLog -Message "Starting CheckAndExecuteTask function" -Level "Notice"
        Log-Params -Params $PSCmdlet.MyInvocation.BoundParameters
    }

    Process {
        try {
            Write-EnhancedLog -Message "Checking for existing task: $schtaskName" -Level "INFO"

            # Splatting for the Check-ExistingTask function
            $checkParams = @{
                taskName = $schtaskName
            }

            $taskExists = Check-ExistingTask @checkParams

            if ($taskExists) {
                Write-EnhancedLog -Message "Existing task found. Executing detection and remediation scripts." -Level "INFO"
                
                # Splatting for Execute-DetectionAndRemediation
                $executeParams = @{
                    Path_PR = $Path_PR
                }

                Execute-DetectionAndRemediation @executeParams
            }
            else {
                Write-EnhancedLog -Message "No existing task found. Setting up new task environment." -Level "INFO"

                # Splatting for SetupNewTaskEnvironment
                $setupParams = @{
                    Path_PR                 = $Path_PR
                    schtaskName             = $schtaskName
                    schtaskDescription      = $schtaskDescription
                    ScriptMode              = $ScriptMode
                    PackageExecutionContext = $PackageExecutionContext
                    RepetitionInterval      = $RepetitionInterval
                    Path_VBShiddenPS        = $Path_VBShiddenPS
                }

                SetupNewTaskEnvironment @setupParams
            }
        }
        catch {
            Write-EnhancedLog -Message "An error occurred while checking and executing the task: $($_.Exception.Message)" -Level "ERROR"
            Handle-Error -ErrorRecord $_
            throw
        }
    }

    End {
        Write-EnhancedLog -Message "CheckAndExecuteTask function completed" -Level "Notice"
    }
}

# Example usage:
# $params = @{
#     schtaskName          = "MyScheduledTask"
#     Path_PR              = "C:\Tasks\MyTask"
#     ScriptMode           = "Remediation"
#     PackageExecutionContext = "System"
#     schtaskDescription   = "Task Description"
#     RepetitionInterval   = "P1D"
#     Path_VBShiddenPS     = "C:\Scripts\HiddenPS.vbs"
# }
# CheckAndExecuteTask @params
