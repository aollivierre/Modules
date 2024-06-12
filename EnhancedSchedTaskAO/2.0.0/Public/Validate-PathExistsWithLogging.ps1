function Validate-PathExistsWithLogging {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Path
    )

    $exists = Test-Path -Path $Path

    if ($exists) {
        Write-EnhancedLog -Message "Path exists: $Path" -Level "INFO" -ForegroundColor ([ConsoleColor]::Green)
    } else {
        Write-EnhancedLog -Message "Path does not exist: $Path" -Level "WARNING" -ForegroundColor ([ConsoleColor]::Yellow)
    }

    return $exists
}
