function Fetch-DeviceStateWithRetry {
    param (
        [Parameter(Mandatory = $true)]
        [string]$DeviceId,
        [Parameter(Mandatory = $true)]
        [string]$Username,
        [Parameter(Mandatory = $true)]
        [hashtable]$Headers
    )

    $retryCount = 0
    $maxRetries = 3
    $fetchSuccess = $false
    $deviceState = "Unknown"

    do {
        try {
            $deviceState = Check-DeviceStateInIntune -entraDeviceId $DeviceId -username $Username -Headers $Headers
            $fetchSuccess = $true
        } catch {
            Write-EnhancedLog -Message "Failed to check device state for device ID: $DeviceId. Attempt $($retryCount + 1) of $maxRetries" -Level "ERROR"
            $retryCount++
            Start-Sleep -Seconds 2
        }
    } while (-not $fetchSuccess -and $retryCount -lt $maxRetries)

    if (-not $fetchSuccess) {
        Write-EnhancedLog -Message "Failed to check device state for device ID: $DeviceId after $maxRetries attempts." -Level "ERROR"
    }

    return $deviceState
}