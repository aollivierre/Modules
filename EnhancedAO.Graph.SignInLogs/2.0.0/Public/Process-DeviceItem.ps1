# function Process-DeviceItem {
#     param (
#         [Parameter(Mandatory = $true)]
#         [PSCustomObject]$Item,
#         [Parameter(Mandatory = $true)]
#         [hashtable]$Context,
#         [Parameter(Mandatory = $true)]
#         [hashtable]$Headers
#     )

#     $deviceId = $Item.deviceDetail.deviceId
#     $userId = $Item.userId

#     if ($deviceId -eq "{PII Removed}") {
#         if (-not $Context.UniqueDeviceIds.ContainsKey($userId)) {
#             Write-EnhancedLog -Message "External Azure AD tenant detected for user: $($Item.userDisplayName)" -Level "INFO" -ForegroundColor ([ConsoleColor]::Yellow)
#             Add-Result -Context $Context -Item $Item -DeviceId "N/A" -DeviceState "External" -HasPremiumLicense $false
#             $Context.UniqueDeviceIds[$userId] = $true
#         }
#         return
#     }

#     if ([string]::IsNullOrWhiteSpace($deviceId)) {
#         if (-not $Context.UniqueDeviceIds.ContainsKey($userId)) {
#             Add-Result -Context $Context -Item $Item -DeviceId "N/A" -DeviceState "BYOD" -HasPremiumLicense $false
#             $Context.UniqueDeviceIds[$userId] = $true
#         }
#         return
#     }

#     if (-not $Context.UniqueDeviceIds.ContainsKey($deviceId)) {
#         $Context.UniqueDeviceIds[$deviceId] = $true
#         $deviceState = Check-DeviceStateInIntune -entraDeviceId $deviceId -username $Item.userDisplayName -Headers $Headers

#         try {
#             $userLicenses = Fetch-UserLicense -UserId $userId -Username $Item.userDisplayName -Headers $Headers
#             $hasPremiumLicense = $false

#             if ($null -ne $userLicenses -and $userLicenses.Count -gt 0) {
#                 $hasPremiumLicense = $userLicenses.Contains("cbdc14ab-d96c-4c30-b9f4-6ada7cdc1d46")
#             }

#             Add-Result -Context $Context -Item $Item -DeviceId $deviceId -DeviceState $deviceState -HasPremiumLicense $hasPremiumLicense
#         } catch {
#             Handle-Error -ErrorRecord $_
#         }
#     }
# }


# function Process-DeviceItem {
#     param (
#         [Parameter(Mandatory = $true)]
#         [PSCustomObject]$Item,
#         [Parameter(Mandatory = $true)]
#         [PSCustomObject]$Context,
#         [Parameter(Mandatory = $true)]
#         [hashtable]$Headers
#     )

#     $deviceId = $Item.deviceDetail.deviceId
#     $userId = $Item.userId

#     # Use .NET methods for string comparison
#     if ([string]::Equals($deviceId, "{PII Removed}", [System.StringComparison]::OrdinalIgnoreCase)) {
#         if (-not $Context.UniqueDeviceIds.ContainsKey($userId)) {
#             Write-EnhancedLog -Message "External Azure AD tenant detected for user: $($Item.userDisplayName)" -Level "INFO" -ForegroundColor ([ConsoleColor]::Yellow)
#             Add-Result -Context $Context -Item $Item -DeviceId "N/A" -DeviceState "External" -HasPremiumLicense $false
#             $Context.UniqueDeviceIds[$userId] = $true
#         }
#         return
#     }

#     if ([string]::IsNullOrWhiteSpace($deviceId)) {
#         if (-not $Context.UniqueDeviceIds.ContainsKey($userId)) {
#             Add-Result -Context $Context -Item $Item -DeviceId "N/A" -DeviceState "BYOD" -HasPremiumLicense $false
#             $Context.UniqueDeviceIds[$userId] = $true
#         }
#         return
#     }

#     if (-not $Context.UniqueDeviceIds.ContainsKey($deviceId)) {
#         $Context.UniqueDeviceIds[$deviceId] = $true

#         # Call the method to check device state
#         $deviceState = Check-DeviceStateInIntune -entraDeviceId $deviceId -username $Item.userDisplayName -Headers $Headers

#         try {
#             # Fetch user licenses
#             $userLicenses = Fetch-UserLicense -UserId $userId -Username $Item.userDisplayName -Headers $Headers
#             $hasPremiumLicense = $false

#             # Use .NET method to check for the presence of a license
#             if ($null -ne $userLicenses -and $userLicenses.Count -gt 0) {
#                 $hasPremiumLicense = [System.Linq.Enumerable]::Contains($userLicenses, "cbdc14ab-d96c-4c30-b9f4-6ada7cdc1d46")
#             }

#             Add-Result -Context $Context -Item $Item -DeviceId $deviceId -DeviceState $deviceState -HasPremiumLicense $hasPremiumLicense
#         } catch {
#             Handle-Error -ErrorRecord $_
#         }
#     }
# }




function Process-DeviceItem {
    param (
        [Parameter(Mandatory = $true)]
        [PSCustomObject]$Item,
        [Parameter(Mandatory = $true)]
        [PSCustomObject]$Context,
        [Parameter(Mandatory = $true)]
        [hashtable]$Headers
    )

    $deviceId = $Item.deviceDetail.deviceId
    $userId = $Item.userId

    # Use .NET methods for string comparison
    if ([string]::Equals($deviceId, "{PII Removed}", [System.StringComparison]::OrdinalIgnoreCase)) {
        if (-not $Context.UniqueDeviceIds.ContainsKey($userId)) {
            Write-EnhancedLog -Message "External Azure AD tenant detected for user: $($Item.userDisplayName)" -Level "INFO" -ForegroundColor ([ConsoleColor]::Yellow)
            Add-Result -Context $Context -Item $Item -DeviceId "N/A" -DeviceState "External" -HasPremiumLicense $false
            $Context.UniqueDeviceIds[$userId] = $true
        }
        return
    }

    if ([string]::IsNullOrWhiteSpace($deviceId)) {
        if (-not $Context.UniqueDeviceIds.ContainsKey($userId)) {
            Add-Result -Context $Context -Item $Item -DeviceId "N/A" -DeviceState "BYOD" -HasPremiumLicense $false
            $Context.UniqueDeviceIds[$userId] = $true
        }
        return
    }

    if (-not $Context.UniqueDeviceIds.ContainsKey($deviceId)) {
        $Context.UniqueDeviceIds[$deviceId] = $true

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
