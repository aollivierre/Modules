function Ensure-LoggingFunctionExists {
    if (Get-Command Write-EnhancedLog -ErrorAction SilentlyContinue) {
        Write-EnhancedLog -Message "Logging works" -Level "INFO" -ForegroundColor ([ConsoleColor]::Green)
    }
    else {
        throw "Write-EnhancedLog function not found. Terminating script."
    }
}
