# Main function to process all devices
function Process-AllDevices {
    param (
        [Parameter(Mandatory = $true)]
        [array]$Json,
        [Parameter(Mandatory = $true)]
        [hashtable]$Headers
    )

    $context = Initialize-Results

    foreach ($item in $Json) {
        # Exclude "On-Premises Directory Synchronization Service Account" user
        if ($item.userDisplayName -eq "On-Premises Directory Synchronization Service Account") {
            # Write-EnhancedLog -Message "Skipping user: $($item.userDisplayName)" -Level "INFO" -ForegroundColor ([ConsoleColor]::Yellow)
            continue
        }

        try {
            Process-DeviceItem -Item $item -Context $context -Headers $Headers
        } catch {
            Handle-Error -ErrorRecord $_
        }
    }

    return $context.Results
}
# # Example usage
# $Json = @() # Your JSON data here
# $Headers = @{} # Your actual headers

# $results = Process-AllDevices -Json $Json -Headers $Headers













# Main function to process all devices
# function Process-AllDevices {
#     param (
#         [Parameter(Mandatory = $true)]
#         [string]$JsonFilePath,
#         [Parameter(Mandatory = $true)]
#         [hashtable]$Headers
#     )

#     # Load the JSON file using Newtonsoft JSON library
#     $reader = [System.IO.StreamReader]::new($JsonFilePath)
#     $jarray = [Newtonsoft.Json.Linq.JArray]::Load([NewtonSoft.Json.JsonTextReader]$reader)

#     # Filter out "On-Premises Directory Synchronization Service Account" user
#     $filteredJson = $jarray.SelectTokens('$..[?(@.userDisplayName != ''On-Premises Directory Synchronization Service Account'')]')

#     $context = Initialize-Results

#     foreach ($item in $filteredJson) {
#         try {
#             Process-DeviceItem -Item $item -Context $context -Headers $Headers
#         } catch {
#             Handle-Error -ErrorRecord $_
#         }
#     }

#     return $context.Results
# }

# Example call to the function
# $Headers = @{"Authorization" = "Bearer <your_token>"}
# Process-AllDevices -JsonFilePath "path\to\your\jsonfile.json" -Headers $Headers







# Main function to process all devices
# function Process-AllDevices {
#     param (
#         [Parameter(Mandatory = $true)]
#         [string]$JsonContent,
#         [Parameter(Mandatory = $true)]
#         [hashtable]$Headers
#     )

#     # Parse JSON content using Newtonsoft JSON library
#     $jarray = [Newtonsoft.Json.Linq.JArray]::Parse($JsonContent)

#     # Filter out "On-Premises Directory Synchronization Service Account" user
#     $filteredJson = $jarray.SelectTokens('$..[?(@.userDisplayName != ''On-Premises Directory Synchronization Service Account'')]')

#     $context = Initialize-Results

#     foreach ($item in $filteredJson) {
#         try {
#             Process-DeviceItem -Item $item -Context $context -Headers $Headers
#         } catch {
#             Handle-Error -ErrorRecord $_
#         }
#     }

#     return $context.Results
# }

# # Read JSON content from file
# $JsonFilePath = "path\to\your\jsonfile.json"
# $JsonContent = Get-Content -Path $JsonFilePath -Raw

# # Example call to the function
# $Headers = @{"Authorization" = "Bearer <your_token>"}
# Process-AllDevices -JsonContent $JsonContent -Headers $Headers





# function Process-AllDevices {
#     param (
#         [Parameter(Mandatory = $true)]
#         [array]$Json,
#         [Parameter(Mandatory = $true)]
#         [hashtable]$Headers
#     )

#     # Filter out "On-Premises Directory Synchronization Service Account" user
#     $jarray = [Newtonsoft.Json.Linq.JArray]::FromObject($Json)
#     $filteredJson = $jarray.SelectTokens('$..[?(@.userDisplayName != ''On-Premises Directory Synchronization Service Account'')]')

#     $context = Initialize-Results

#     foreach ($item in $filteredJson) {
#         try {
#             Process-DeviceItem -Item $item -Context $context -Headers $Headers
#         } catch {
#             Handle-Error -ErrorRecord $_
#         }
#     }

#     return $context.Results
# }