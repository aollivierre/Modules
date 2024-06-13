# Main function to process all devices
# function Process-AllDevices {
#     param (
#         [Parameter(Mandatory = $true)]
#         [array]$Json,
#         [Parameter(Mandatory = $true)]
#         [hashtable]$Headers
#     )

#     $context = Initialize-Results

#     foreach ($item in $Json) {
#         # Exclude "On-Premises Directory Synchronization Service Account" user
#         if ($item.userDisplayName -eq "On-Premises Directory Synchronization Service Account") {
#             # Write-EnhancedLog -Message "Skipping user: $($item.userDisplayName)" -Level "INFO" -ForegroundColor ([ConsoleColor]::Yellow)
#             continue
#         }

#         try {
#             Process-DeviceItem -Item $item -Context $context -Headers $Headers
#         } catch {
#             Handle-Error -ErrorRecord $_
#         }
#     }

#     return $context.Results
# }
# # Example usage
# $Json = @() # Your JSON data here
# $Headers = @{} # Your actual headers

# $results = Process-AllDevices -Json $Json -Headers $Headers






# Main function to process all devices
# function Process-AllDevices {
#     param (
#         [Parameter(Mandatory = $true)]
#         [array]$Json,
#         [Parameter(Mandatory = $true)]
#         [hashtable]$Headers
#     )

#     $context = Initialize-Results

#     foreach ($item in $Json) {

#         # Write-Host "I'm now inside Process-AllDevices real processing - $item" -ForegroundColor Yellow
#         # Exclude "On-Premises Directory Synchronization Service Account" user
#         if ($item.userDisplayName -eq "On-Premises Directory Synchronization Service Account") {
#             continue
#         }

#         try {
#             Process-DeviceItem -Item $item -Context $context -Headers $Headers
#         } catch {
#             Handle-Error -ErrorRecord $_
#         }
#     }

#     return $context.Results
# }















function Process-AllDevices {
    param (
        [Parameter(Mandatory = $true)]
        [array]$Json,
        [Parameter(Mandatory = $true)]
        [hashtable]$Headers
    )

    # # Initialize the context with efficient collections for single-threaded operations
    # $context = [PSCustomObject]@{
    #     Results = [System.Collections.Generic.List[PSCustomObject]]::new()
    #     UniqueDeviceIds = [System.Collections.Generic.Dictionary[string, bool]]::new()
    # }

    $context = Initialize-Results

    foreach ($item in $Json) {
        # Exclude "On-Premises Directory Synchronization Service Account" user
        if ($item.userDisplayName -eq "On-Premises Directory Synchronization Service Account") {
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




# class ProcessingContext {
#     [System.Collections.Generic.List[PSCustomObject]]$Results
#     [System.Collections.Generic.Dictionary[string, bool]]$UniqueDeviceIds

#     ProcessingContext() {
#         $this.Results = [System.Collections.Generic.List[PSCustomObject]]::new()
#         $this.UniqueDeviceIds = [System.Collections.Generic.Dictionary[string, bool]]::new()
#     }

#     [void] AddResult([PSCustomObject]$result) {
#         $this.Results.Add($result)
#     }

#     [void] AddUniqueDeviceId([string]$deviceId) {
#         $this.UniqueDeviceIds[$deviceId] = $true
#     }
# }



# class DeviceProcessor {
#     [hashtable]$Headers

#     DeviceProcessor([hashtable]$headers) {
#         $this.Headers = $headers
#     }

#     [void] ProcessDeviceItem([PSCustomObject]$item, [ProcessingContext]$context) {
#         # Add your logic to process the device item
#         # Example: Add a result and a unique device ID
#         $result = [PSCustomObject]@{ Property1 = $item.Property1; Property2 = $item.Property2 }
#         $context.AddResult($result)
#         $context.AddUniqueDeviceId($item.DeviceId)
#     }
# }


# function Process-AllDevices {
#     param (
#         [Parameter(Mandatory = $true)]
#         [array]$Json,
#         [Parameter(Mandatory = $true)]
#         [hashtable]$Headers
#     )

#     # Initialize the context and processor
#     $context = [ProcessingContext]::new()
#     $processor = [DeviceProcessor]::new($Headers)

#     foreach ($item in $Json) {
#         # Exclude "On-Premises Directory Synchronization Service Account" user
#         if ($item.userDisplayName -eq "On-Premises Directory Synchronization Service Account") {
#             continue
#         }

#         try {
#             $processor.ProcessDeviceItem($item, $context)
#         } catch {
#             Handle-Error -ErrorRecord $_
#         }
#     }

#     return $context.Results
# }




# function Process-AllDevices {
#     param (
#         [Parameter(Mandatory = $true)]
#         [array]$Json,
#         [Parameter(Mandatory = $true)]
#         [hashtable]$Headers
#     )

#     foreach ($log in $Json) {
#         Write-EnhancedLog -Message "Processing sign-in log for user: $($log.UserPrincipalName)" -Level "INFO"
#         # Perform actual processing here

#         # Example: Processing each log entry
#         Write-EnhancedLog -Message "Sign-in log entry: $($log | ConvertTo-Json -Compress)" -Level "DEBUG"
#     }
# }









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