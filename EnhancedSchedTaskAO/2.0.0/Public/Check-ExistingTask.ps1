
function Check-ExistingTask {

    <#
.SYNOPSIS
Checks for the existence of a specified scheduled task.

.DESCRIPTION
This function searches for a scheduled task by name and optionally filters it by version. It returns $true if a task matching the specified criteria exists, otherwise $false.

.PARAMETER taskName
The name of the scheduled task to search for.

.PARAMETER version
The version of the scheduled task to match. The task's description must start with "Version" followed by this parameter value.

.EXAMPLE
$exists = Check-ExistingTask -taskName "MyTask" -version "1"
This example checks if a scheduled task named "MyTask" with a description starting with "Version 1" exists.

#>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$taskName,

        [string]$version
    )

    try {
        Write-EnhancedLog -Message "Checking for existing scheduled task: $taskName" -Level "INFO" -ForegroundColor Magenta
        $task_existing = Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue
        if ($null -eq $task_existing) {
            Write-EnhancedLog -Message "No existing task named $taskName found." -Level "INFO" -ForegroundColor Yellow
            return $false
        }

        if ($null -ne $version) {
            $versionMatch = $task_existing.Description -like "Version $version*"
            if ($versionMatch) {
                Write-EnhancedLog -Message "Found matching task with version: $version" -Level "INFO" -ForegroundColor Green
            }
            else {
                Write-EnhancedLog -Message "No matching version found for task: $taskName" -Level "INFO" -ForegroundColor Yellow
            }
            return $versionMatch
        }

        return $true
    }
    catch {
        Write-EnhancedLog -Message "An error occurred while checking for the scheduled task: $_" -Level "ERROR" -ForegroundColor Red
        throw $_
    }
}