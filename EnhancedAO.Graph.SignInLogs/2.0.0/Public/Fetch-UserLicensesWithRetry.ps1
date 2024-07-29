
function Fetch-UserLicensesWithRetry {
    param (
        [Parameter(Mandatory = $true)]
        [string]$UserId,
        [Parameter(Mandatory = $true)]
        [string]$Username,
        [Parameter(Mandatory = $true)]
        [hashtable]$Headers
    )

    $retryCount = 0
    $maxRetries = 3
    $fetchSuccess = $false
    $userLicenses = @()

    do {
        try {
            $userLicenses = Fetch-UserLicense -UserId $UserId -Username $Username -Headers $Headers
            $fetchSuccess = $true
        } catch {
            Write-EnhancedLog -Message "Failed to fetch licenses for user: $Username. Attempt $($retryCount + 1) of $maxRetries" -Level "ERROR"
            $retryCount++
            Start-Sleep -Seconds 2
        }
    } while (-not $fetchSuccess -and $retryCount -lt $maxRetries)

    if (-not $fetchSuccess) {
        Write-EnhancedLog -Message "Failed to fetch licenses for user: $Username after $maxRetries attempts." -Level "ERROR"
    }

    return $userLicenses
}