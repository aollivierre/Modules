
function Unregister-ScheduledTaskWithLogging {
    param (
        [Parameter(Mandatory = $true)]
        [string]$TaskName
    )

    try {
        Write-EnhancedLog -Message "Checking if task '$TaskName' exists before attempting to unregister." -Level "INFO" -ForegroundColor ([ConsoleColor]::Cyan)
        $taskExistsBefore = Check-ExistingTask -taskName $TaskName
        
        if ($taskExistsBefore) {
            Write-EnhancedLog -Message "Task '$TaskName' found. Proceeding to unregister." -Level "INFO" -ForegroundColor ([ConsoleColor]::Yellow)
            Unregister-ScheduledTask -TaskName $TaskName -Confirm:$false
            Write-EnhancedLog -Message "Unregister-ScheduledTask done for task: $TaskName" -Level "INFO" -ForegroundColor ([ConsoleColor]::Green)
        } else {
            Write-EnhancedLog -Message "Task '$TaskName' not found. No action taken." -Level "INFO" -ForegroundColor ([ConsoleColor]::Green)
        }

        Write-EnhancedLog -Message "Checking if task '$TaskName' exists after attempting to unregister." -Level "INFO" -ForegroundColor ([ConsoleColor]::Cyan)
        $taskExistsAfter = Check-ExistingTask -taskName $TaskName
        
        if ($taskExistsAfter) {
            Write-EnhancedLog -Message "Task '$TaskName' still exists after attempting to unregister. Manual intervention may be required." -Level "ERROR" -ForegroundColor ([ConsoleColor]::Red)
        } else {
            Write-EnhancedLog -Message "Task '$TaskName' successfully unregistered." -Level "INFO" -ForegroundColor ([ConsoleColor]::Green)
        }
    }
    catch {
        Write-EnhancedLog -Message "Error during Unregister-ScheduledTask for task: $TaskName. Error: $_" -Level "ERROR" -ForegroundColor ([ConsoleColor]::Red)
        throw $_
    }
}