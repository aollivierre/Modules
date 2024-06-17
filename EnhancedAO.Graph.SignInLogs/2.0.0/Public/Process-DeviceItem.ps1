function Process-DeviceItem {
    param (
        [Parameter(Mandatory = $true)]
        [SignInLog]$Item,
        [Parameter(Mandatory = $true)]
        [ProcessingContext]$Context,
        [Parameter(Mandatory = $true)]
        [hashtable]$Headers
    )

    $deviceId = $Item.deviceDetail.deviceId
    $userId = $Item.userId

    # Use .NET methods for string comparison
    if ([string]::Equals($deviceId, "{PII Removed}", [System.StringComparison]::OrdinalIgnoreCase)) {
        if ($Context.UniqueDeviceIds.Add($userId)) {
            Write-EnhancedLog -Message "External Azure AD tenant detected for user: $($Item.userDisplayName)" -Level "INFO"
            Add-Result -Context $Context -Item $Item -DeviceId "N/A" -DeviceState "External" -HasPremiumLicense $false
        }
        return
    }

    if ([string]::IsNullOrWhiteSpace($deviceId)) {
        if ($Context.UniqueDeviceIds.Add($userId)) {
            Add-Result -Context $Context -Item $Item -DeviceId "N/A" -DeviceState "BYOD" -HasPremiumLicense $false
        }
        return
    }

    if ($Context.UniqueDeviceIds.Add($deviceId)) {
        # Call the method to check device state
        $deviceState = Check-DeviceStateInIntune -entraDeviceId $deviceId -username $Item.userDisplayName -Headers $Headers

        try {
            # Fetch user licenses
            $userLicenses = Fetch-UserLicense -UserId $userId -Username $Item.userDisplayName -Headers $Headers
            $hasPremiumLicense = $false

            # Use .NET method to check for the presence of a license
            if ($null -ne $userLicenses -and $userLicenses.Count -gt 0) {
                $hasPremiumLicense = $userLicenses.Contains("cbdc14ab-d96c-4c30-b9f4-6ada7cdc1d46")
            }

            Add-Result -Context $Context -Item $Item -DeviceId $deviceId -DeviceState $deviceState -HasPremiumLicense $hasPremiumLicense
        } catch {
            Handle-Error -ErrorRecord $_
        }
    }
}
