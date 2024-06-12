function Remove-ScheduledTaskFilesWithLogging {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Path
    )

    try {
        # Validate before removal
        $existsBefore = Validate-PathExistsWithLogging -Path $Path

        if ($existsBefore) {
            Write-EnhancedLog -Message "Calling Remove-Item for path: $Path" -Level "INFO" -ForegroundColor ([ConsoleColor]::Yellow)
            Remove-Item -Path $Path -Recurse -Force
            Write-EnhancedLog -Message "Remove-Item done for path: $Path" -Level "INFO" -ForegroundColor ([ConsoleColor]::Green)
        } else {
            Write-EnhancedLog -Message "Path $Path does not exist. No action taken." -Level "WARNING" -ForegroundColor ([ConsoleColor]::Yellow)
        }

        # Validate after removal
        $existsAfter = Validate-PathExistsWithLogging -Path $Path

        if ($existsAfter) {
            Write-EnhancedLog -Message "Path $Path still exists after attempting to remove. Manual intervention may be required." -Level "ERROR" -ForegroundColor ([ConsoleColor]::Red)
        } else {
            Write-EnhancedLog -Message "Path $Path successfully removed." -Level "INFO" -ForegroundColor ([ConsoleColor]::Green)
        }
    }
    catch {
        Write-EnhancedLog -Message "Error during Remove-Item for path: $Path. Error: $_" -Level "ERROR" -ForegroundColor ([ConsoleColor]::Red)
        throw $_
    }
}