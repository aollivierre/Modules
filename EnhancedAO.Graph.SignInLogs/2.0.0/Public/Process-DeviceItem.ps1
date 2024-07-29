function Process-DeviceItem {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        $Item,
        [Parameter(Mandatory = $true)]
        $Context,
        [Parameter(Mandatory = $true)]
        $Headers
    )

    Begin {
        Write-EnhancedLog -Message "Starting Process-DeviceItem function" -Level "INFO"
        Log-Params -Params @{ Item = $Item; Context = $Context }
        Initialize-Context -Context $Context
    }

    Process {
        # Ensure deviceDetail object and properties exist
        if (-not $Item.deviceDetail) {
            Write-EnhancedLog -Message "Missing deviceDetail for user: $($Item.userDisplayName)" -Level "WARNING"
            return
        }

        $deviceId = $Item.deviceDetail.deviceId
        $userId = $Item.userId
        $os = $Item.deviceDetail.operatingSystem

        if (-not $userId) {
            Write-EnhancedLog -Message "Missing userId for device item" -Level "WARNING"
            return
        }

        try {
            # Construct uniqueId based on availability of deviceId and OS for BYOD
            if ([string]::IsNullOrWhiteSpace($deviceId)) {
                $uniqueId = "$userId-$os".ToLowerInvariant()
            } else {
                $uniqueId = $deviceId.ToLowerInvariant()
            }

            # Log the device and user information
            Write-EnhancedLog -Message "Processing device item for user: $($Item.userDisplayName) with unique ID: $uniqueId" -Level "INFO"

            # Handle external Azure AD tenant case
            if (Handle-ExternalAADTenant -Item $Item -Context $Context -UniqueId $uniqueId) {
                return
            }

            # Process only if the unique ID is not already processed
            if ($Context.UniqueDeviceIds.Add($uniqueId)) {
                # Handle BYOD case
                if ([string]::IsNullOrWhiteSpace($deviceId)) {
                    # Fetch user licenses with retry logic
                    $userLicenses = Fetch-UserLicensesWithRetry -UserId $userId -Username $Item.userDisplayName -Headers $Headers
                    $hasPremiumLicense = $userLicenses -and $userLicenses.Count -gt 0 -and $userLicenses.Contains("cbdc14ab-d96c-4c30-b9f4-6ada7cdc1d46")
                    Write-EnhancedLog -Message "User $($Item.userDisplayName) has the following licenses: $($userLicenses -join ', ')" -Level "INFO"

                    Add-Result -Context $Context -Item $Item -DeviceId "N/A" -DeviceState "BYOD" -HasPremiumLicense $hasPremiumLicense -OSVersion $null
                    return
                }

                # Handle managed device case with retry logic
                $deviceState = Fetch-DeviceStateWithRetry -DeviceId $deviceId -Username $Item.userDisplayName -Headers $Headers
                $osVersion = Fetch-OSVersionWithRetry -DeviceId $deviceId -Headers $Headers

                $userLicenses = Fetch-UserLicensesWithRetry -UserId $userId -Username $Item.userDisplayName -Headers $Headers
                $hasPremiumLicense = $userLicenses -and $userLicenses.Count -gt 0 -and $userLicenses.Contains("cbdc14ab-d96c-4c30-b9f4-6ada7cdc1d46")
                Write-EnhancedLog -Message "User $($Item.userDisplayName) has the following licenses: $($userLicenses -join ', ')" -Level "INFO"

                Add-Result -Context $Context -Item $Item -DeviceId $deviceId -DeviceState $deviceState -HasPremiumLicense $hasPremiumLicense -OSVersion $osVersion
            }
        } catch {
            Write-EnhancedLog -Message "An error occurred while processing the device item for user: $($Item.userDisplayName) - $_" -Level "ERROR"
            Handle-Error -ErrorRecord $_
        }
    }

    End {
        Write-EnhancedLog -Message "Exiting Process-DeviceItem function" -Level "INFO"
    }
}