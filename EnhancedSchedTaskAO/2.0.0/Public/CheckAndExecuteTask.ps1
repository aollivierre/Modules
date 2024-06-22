function CheckAndExecuteTask {

    <#
    .SYNOPSIS
    Checks for an existing scheduled task and executes tasks based on conditions.
    
    .DESCRIPTION
    This function checks if a scheduled task with the specified name and version exists. If it does, it proceeds to execute detection and remediation scripts. If not, it sets up a new task environment and registers the task. It uses enhanced logging for status messages and error handling to manage potential issues.
    
    .PARAMETER schtaskName
    The name of the scheduled task to check and potentially execute.
    
    .PARAMETER Version
    The version of the task to check for. This is used to verify if the correct task version is already scheduled.
    
    .PARAMETER Path_PR
    The path to the directory containing the detection and remediation scripts, used if the task needs to be executed.
    
    .PARAMETER ScriptMode
    The mode in which the script is being executed.
    
    .PARAMETER PackageExecutionContext
    The context in which the package is being executed.
    
    .PARAMETER RepetitionInterval
    The interval at which the task should be repeated.
    #>
    
        [CmdletBinding()]
        param (
            [Parameter(Mandatory = $true)]
            [string]$schtaskName,
    
            [Parameter(Mandatory = $true)]
            [int]$Version,
    
            [Parameter(Mandatory = $true)]
            [string]$Path_PR,
    
            [Parameter(Mandatory = $true)]
            [string]$ScriptMode,
    
            [Parameter(Mandatory = $true)]
            [string]$PackageExecutionContext,
    
            [Parameter(Mandatory = $true)]
            [string]$RepetitionInterval
        )
    
        try {
            Write-EnhancedLog -Message "Starting task check for: $schtaskName, Version: $Version" -Level "INFO" -ForegroundColor Cyan
    
            $taskExists = Check-ExistingTask -taskName $schtaskName -version $Version
            if ($taskExists) {
                Write-EnhancedLog -Message "Existing task found: $schtaskName. Executing detection and remediation scripts." -Level "INFO" -ForegroundColor Green
                try {
                    Execute-DetectionAndRemediation -Path_PR $Path_PR
                    Write-EnhancedLog -Message "Detection and remediation scripts executed successfully for task: $schtaskName." -Level "INFO" -ForegroundColor Green
                } catch {
                    Write-EnhancedLog -Message "An error occurred while executing detection and remediation scripts for task: $schtaskName. Error: $_" -Level "ERROR" -ForegroundColor Red
                    Handle-Error -ErrorRecord $_
                    throw $_
                }
            } else {
                Write-EnhancedLog -Message "No existing task found: $schtaskName. Setting up new task environment." -Level "INFO" -ForegroundColor Yellow
                try {
                    SetupNewTaskEnvironment -Path_PR $Path_PR -schtaskName $schtaskName -ScriptMode $ScriptMode -PackageExecutionContext $PackageExecutionContext -RepetitionInterval $RepetitionInterval
                    Write-EnhancedLog -Message "New task environment set up successfully for task: $schtaskName." -Level "INFO" -ForegroundColor Green
                } catch {
                    Write-EnhancedLog -Message "An error occurred while setting up new task environment for task: $schtaskName. Error: $_" -Level "ERROR" -ForegroundColor Red
                    Handle-Error -ErrorRecord $_
                    throw $_
                }
            }
        } catch {
            Write-EnhancedLog -Message "An error occurred while checking and executing the task: $_" -Level "ERROR" -ForegroundColor Red
            Handle-Error -ErrorRecord $_
            throw $_
        }
    }
    