# Function to process each device item
function Process-DeviceItem {
    param (
        [Parameter(Mandatory = $true)]
        [PSCustomObject]$Item,
        [Parameter(Mandatory = $true)]
        [hashtable]$Context,
        [Parameter(Mandatory = $true)]
        [hashtable]$Headers
    )

    $deviceId = $Item.deviceDetail.deviceId
    $deviceName = $Item.deviceDetail.displayName

    if ($deviceId -eq "{PII Removed}") {
        if (-not $Context.UniqueDeviceIds.ContainsKey($Item.userId)) {
            Write-EnhancedLog -Message "External Azure AD tenant detected for user: $($Item.userDisplayName)" -Level "INFO" -ForegroundColor ([ConsoleColor]::Yellow)
            Add-Result -Context $Context -Item $Item -DeviceId "N/A" -DeviceState "External" -HasPremiumLicense $false
            $Context.UniqueDeviceIds[$Item.userId] = $true
        }
        return
    }

    if (-not [string]::IsNullOrWhiteSpace($deviceId)) {
        if (-not $Context.UniqueDeviceIds.ContainsKey($deviceId)) {
            $Context.UniqueDeviceIds[$deviceId] = $true
            $deviceState = Check-DeviceStateInIntune -entraDeviceId $deviceId -username $Item.userDisplayName -Headers $Headers

            try {
                $userLicenses = Fetch-UserLicense -UserId $Item.userId -Username $Item.userDisplayName -Headers $Headers
                $hasPremiumLicense = $false

                if ($null -ne $userLicenses -and $userLicenses.Count -gt 0) {
                    $hasPremiumLicense = $userLicenses.Contains("cbdc14ab-d96c-4c30-b9f4-6ada7cdc1d46")
                }

                Add-Result -Context $Context -Item $Item -DeviceId $deviceId -DeviceState $deviceState -HasPremiumLicense ($hasPremiumLicense -eq $true)
            } catch {
                Handle-Error -ErrorRecord $_
            }
        }
    } else {
        # Handle BYOD case
        if (-not $Context.UniqueDeviceIds.ContainsKey($Item.userId)) {
            Add-Result -Context $Context -Item $Item -DeviceId "N/A" -DeviceState "BYOD" -HasPremiumLicense $false
            $Context.UniqueDeviceIds[$Item.userId] = $true
        }
    }
}
