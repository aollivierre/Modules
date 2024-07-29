# function Process-DeviceItem {
#     [CmdletBinding()]
#     param (
#         [Parameter(Mandatory = $true)]
#         $Item,
#         [Parameter(Mandatory = $true)]
#         $Context,
#         [Parameter(Mandatory = $true)]
#         $Headers
#     )

#     Begin {
#         Write-EnhancedLog -Message "Starting Process-DeviceItem function" -Level "INFO"
#         Log-Params -Params @{ Item = $Item; Context = $Context }
#         if (-not $Context.UniqueDeviceIds) {
#             $Context.UniqueDeviceIds = [System.Collections.Generic.HashSet[string]]::new()
#         }
#     }

#     Process {
#         # Ensure deviceDetail object and properties exist
#         if (-not $Item.deviceDetail) {
#             Write-EnhancedLog -Message "Missing deviceDetail for user: $($Item.userDisplayName)" -Level "WARNING"
#             return
#         }

#         $deviceId = $Item.deviceDetail.deviceId
#         $userId = $Item.userId
#         $os = $Item.deviceDetail.operatingSystem

#         if (-not $userId) {
#             Write-EnhancedLog -Message "Missing userId for device item" -Level "WARNING"
#             return
#         }

#         # Construct uniqueId based on availability of deviceId and OS for BYOD
#         $uniqueId = if ([string]::IsNullOrWhiteSpace($deviceId)) {
#             "$userId-$os".ToLowerInvariant()
#         } else {
#             $deviceId.ToLowerInvariant()
#         }

#         try {
#             # Log the device and user information
#             Write-EnhancedLog -Message "Processing device item for user: $($Item.userDisplayName) with unique ID: $uniqueId" -Level "INFO"

#             # Handle external Azure AD tenant case
#             if ([string]::Equals($deviceId, "{PII Removed}", [System.StringComparison]::OrdinalIgnoreCase)) {
#                 if ($Context.UniqueDeviceIds.Add($uniqueId)) {
#                     Write-EnhancedLog -Message "External Azure AD tenant detected for user: $($Item.userDisplayName)" -Level "INFO"
#                     Add-Result -Context $Context -Item $Item -DeviceId "N/A" -DeviceState "External" -HasPremiumLicense $false -OSVersion $null
#                 }
#                 return
#             }

#             # Process only if the unique ID is not already processed
#             if ($Context.UniqueDeviceIds.Add($uniqueId)) {
#                 # Handle BYOD case
#                 if ([string]::IsNullOrWhiteSpace($deviceId)) {
#                     # Check if there are already devices with the same userId and OS
#                     # $existingBYODs = $Context.UniqueDeviceIds | Where-Object { $_ -like "$userId-*" }

#                     # if ($existingBYODs.Count -gt 0) {
#                     #     Write-EnhancedLog -Message "User $($Item.userDisplayName) has multiple BYOD devices with the same OS: $os" -Level "WARNING"
#                     # }

#                     # Fetch user licenses with retry logic
#                     $retryCount = 0
#                     $maxRetries = 3
#                     do {
#                         try {
#                             $userLicenses = Fetch-UserLicense -UserId $userId -Username $Item.userDisplayName -Headers $Headers
#                             $fetchSuccess = $true
#                         } catch {
#                             Write-EnhancedLog -Message "Failed to fetch licenses for user: $($Item.userDisplayName). Attempt $($retryCount + 1) of $maxRetries" -Level "ERROR"
#                             $fetchSuccess = $false
#                             $retryCount++
#                             Start-Sleep -Seconds 2
#                         }
#                     } while (-not $fetchSuccess -and $retryCount -lt $maxRetries)

#                     if (-not $fetchSuccess) {
#                         Write-EnhancedLog -Message "Failed to fetch licenses for user: $($Item.userDisplayName) after $maxRetries attempts." -Level "ERROR"
#                         $userLicenses = @()
#                     }

#                     $hasPremiumLicense = $userLicenses -and $userLicenses.Count -gt 0 -and $userLicenses.Contains("cbdc14ab-d96c-4c30-b9f4-6ada7cdc1d46")
#                     Write-EnhancedLog -Message "User $($Item.userDisplayName) has the following licenses: $($userLicenses -join ', ')" -Level "INFO"

#                     Add-Result -Context $Context -Item $Item -DeviceId "N/A" -DeviceState "BYOD" -HasPremiumLicense $hasPremiumLicense -OSVersion $null
#                     return
#                 }

#                 # Handle managed device case with retry logic
#                 $retryCount = 0
#                 $maxRetries = 3
#                 $deviceState = "Unknown"
#                 do {
#                     try {
#                         # Call the method to check device state
#                         $deviceState = Check-DeviceStateInIntune -entraDeviceId $deviceId -username $Item.userDisplayName -Headers $Headers
#                         $fetchSuccess = $true
#                     } catch {
#                         Write-EnhancedLog -Message "Failed to check device state for device ID: $deviceId. Attempt $($retryCount + 1) of $maxRetries" -Level "ERROR"
#                         $fetchSuccess = $false
#                         $retryCount++
#                         Start-Sleep -Seconds 2
#                     }
#                 } while (-not $fetchSuccess -and $retryCount -lt $maxRetries)

#                 if (-not $fetchSuccess) {
#                     Write-EnhancedLog -Message "Failed to check device state for device ID: $deviceId after $maxRetries attempts." -Level "ERROR"
#                 }

#                 $retryCount = 0
#                 $osVersion = "Unknown"
#                 do {
#                     try {
#                         # Fetch OS version
#                         $osVersion = Fetch-OSVersion -DeviceId $deviceId -Headers $Headers
#                         $fetchSuccess = $true
#                     } catch {
#                         Write-EnhancedLog -Message "Failed to fetch OS version for device ID: $deviceId. Attempt $($retryCount + 1) of $maxRetries" -Level "ERROR"
#                         $fetchSuccess = $false
#                         $retryCount++
#                         Start-Sleep -Seconds 2
#                     }
#                 } while (-not $fetchSuccess -and $retryCount -lt $maxRetries)

#                 if (-not $fetchSuccess) {
#                     Write-EnhancedLog -Message "Failed to fetch OS version for device ID: $deviceId after $maxRetries attempts." -Level "ERROR"
#                 }

#                 $retryCount = 0
#                 $userLicenses = @()
#                 do {
#                     try {
#                         # Fetch user licenses
#                         $userLicenses = Fetch-UserLicense -UserId $userId -Username $Item.userDisplayName -Headers $Headers
#                         $fetchSuccess = $true
#                     } catch {
#                         Write-EnhancedLog -Message "Failed to fetch licenses for user: $($Item.userDisplayName). Attempt $($retryCount + 1) of $maxRetries" -Level "ERROR"
#                         $fetchSuccess = $false
#                         $retryCount++
#                         Start-Sleep -Seconds 2
#                     }
#                 } while (-not $fetchSuccess -and $retryCount -lt $maxRetries)

#                 if (-not $fetchSuccess) {
#                     Write-EnhancedLog -Message "Failed to fetch licenses for user: $($Item.userDisplayName) after $maxRetries attempts." -Level "ERROR"
#                 }

#                 $hasPremiumLicense = $userLicenses -and $userLicenses.Count -gt 0 -and $userLicenses.Contains("cbdc14ab-d96c-4c30-b9f4-6ada7cdc1d46")
#                 Write-EnhancedLog -Message "User $($Item.userDisplayName) has the following licenses: $($userLicenses -join ', ')" -Level "INFO"

#                 Add-Result -Context $Context -Item $Item -DeviceId $deviceId -DeviceState $deviceState -HasPremiumLicense $hasPremiumLicense -OSVersion $osVersion
#             }
#         } catch {
#             Write-EnhancedLog -Message "An error occurred while processing the device item for user: $($Item.userDisplayName) - $_" -Level "ERROR"
#             Handle-Error -ErrorRecord $_
#         }
#     }

#     End {
#         Write-EnhancedLog -Message "Exiting Process-DeviceItem function" -Level "INFO"
#     }
# }
