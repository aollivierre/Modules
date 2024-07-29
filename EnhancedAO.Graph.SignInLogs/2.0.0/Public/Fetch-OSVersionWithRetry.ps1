
function Fetch-OSVersionWithRetry {
    param (
        [Parameter(Mandatory = $true)]
        [string]$DeviceId,
        [Parameter(Mandatory = $true)]
        [hashtable]$Headers
    )

    $retryCount = 0
    $maxRetries = 3
    $fetchSuccess = $false
    $osVersion = "Unknown"

    do {
        try {
            $osVersion = Fetch-OSVersion -DeviceId $DeviceId -Headers $Headers
            $fetchSuccess = $true
        } catch {
            Write-EnhancedLog -Message "Failed to fetch OS version for device ID: $DeviceId. Attempt $($retryCount + 1) of $maxRetries" -Level "ERROR"
            $retryCount++
            Start-Sleep -Seconds 2
        }
    } while (-not $fetchSuccess -and $retryCount -lt $maxRetries)

    if (-not $fetchSuccess) {
        Write-EnhancedLog -Message "Failed to fetch OS version for device ID: $DeviceId after $maxRetries attempts." -Level "ERROR"
    }

    return $osVersion
}