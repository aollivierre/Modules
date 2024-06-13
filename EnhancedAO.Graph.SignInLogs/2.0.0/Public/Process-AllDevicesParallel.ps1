# $functionInitializeResults = ${function:Initialize-Results}.ToString()
# $functionProcessDeviceItem = ${function:Process-DeviceItem}.ToString()
# $functionHandleError = ${function:Handle-Error}.ToString()

# function Process-AllDevicesParallel {
#     param (
#         [Parameter(Mandatory = $true)]
#         [array]$Json,
#         [Parameter(Mandatory = $true)]
#         [hashtable]$Headers
#     )

#     # Initialize the results
#     $context = Initialize-Results

#     # Use ForEach-Object -Parallel to process items in parallel
#     $results = $Json | ForEach-Object -Parallel {
#         # Import the necessary functions
#         Invoke-Expression $using:functionInitializeResults
#         Invoke-Expression $using:functionProcessDeviceItem
#         Invoke-Expression $using:functionHandleError

#         # Initialize results in each runspace
#         $localContext = Initialize-Results

#         # Exclude "On-Premises Directory Synchronization Service Account" user
#         if ($using:item.userDisplayName -eq "On-Premises Directory Synchronization Service Account") {
#             return
#         }

#         try {
#             Process-DeviceItem -Item $_ -Context $localContext -Headers $using:Headers
#         } catch {
#             Handle-Error -ErrorRecord $_
#         }

#         return $localContext.Results
#     } -ArgumentList $Headers -ThrottleLimit 4

#     return $results
# }





# function Process-AllDevicesParallel {
#     param (
#         [Parameter(Mandatory = $true)]
#         [array]$Json,
#         [Parameter(Mandatory = $true)]
#         [hashtable]$Headers,
#         [Parameter(Mandatory = $true)]
#         [string]$FunctionInitializeResults,
#         [Parameter(Mandatory = $true)]
#         [string]$FunctionProcessDeviceItem,
#         [Parameter(Mandatory = $true)]
#         [string]$FunctionHandleError
#     )

#     # Use ForEach-Object -Parallel to process items in parallel
#     $results = $Json | ForEach-Object -Parallel {
#         # Import the necessary functions
#         Invoke-Expression $using:FunctionInitializeResults
#         Invoke-Expression $using:FunctionProcessDeviceItem
#         Invoke-Expression $using:FunctionHandleError

#         # Initialize results in each runspace
#         $localContext = Initialize-Results

#         # Exclude "On-Premises Directory Synchronization Service Account" user
#         if ($_.userDisplayName -eq "On-Premises Directory Synchronization Service Account") {
#             return
#         }

#         try {
#             Process-DeviceItem -Item $_ -Context $localContext -Headers $using:Headers
#         } catch {
#             Handle-Error -ErrorRecord $_
#         }

#         return $localContext.Results
#     } -ThrottleLimit 4

#     return $results
# }




# function Process-AllDevicesParallel {
#     param (
#         [Parameter(Mandatory = $true)]
#         [array]$Json,
#         [Parameter(Mandatory = $true)]
#         [hashtable]$Headers,
#         [Parameter(Mandatory = $true)]
#         [string]$FunctionInitializeResults,
#         [Parameter(Mandatory = $true)]
#         [string]$FunctionProcessDeviceItem,
#         [Parameter(Mandatory = $true)]
#         [string]$FunctionHandleError,
#         [Parameter(Mandatory = $true)]
#         [string]$FunctionImportLatestModulesLocalRepository,
#         [Parameter(Mandatory = $true)]
#         [string]$FunctionInstallAndImportModulesPSGallery,
#         [Parameter(Mandatory = $true)]
#         [string]$ModulesFolderPath,
#         [Parameter(Mandatory = $true)]
#         [string]$ModuleJsonPath
#     )

#     $results = $Json | ForEach-Object -Parallel {


     

#         # Define necessary functions within the parallel block
      
#         Invoke-Expression $using:FunctionImportLatestModulesLocalRepository
#         Invoke-Expression $using:FunctionInstallAndImportModulesPSGallery

#            # Import and install necessary modules
#            Import-LatestModulesLocalRepository -ModulesFolderPath $using:ModulesFolderPath
#            InstallAndImportModulesPSGallery -moduleJsonPath $using:ModuleJsonPath

#         Invoke-Expression $using:FunctionInitializeResults
#         Invoke-Expression $using:FunctionProcessDeviceItem
#         Invoke-Expression $using:FunctionHandleError

#         # Initialize results in each runspace
#         $localContext = Initialize-Results

#         if ($_.userDisplayName -eq "On-Premises Directory Synchronization Service Account") {
#             return
#         }

#         try {
#             Process-DeviceItem -Item $_ -Context $localContext -Headers $using:Headers
#         } catch {
#             Handle-Error -ErrorRecord $_
#         }

#         return $localContext.Results
#     } -ThrottleLimit 4

#     return $results
# }





# # Example JSON input and headers
# $jsonInput = @(
#     [pscustomobject]@{ userDisplayName = "User1"; DeviceId = 1 },
#     [pscustomobject]@{ userDisplayName = "User2"; DeviceId = 2 }
#     # Add more items as needed
# )
# $headers = @{ Authorization = "Bearer token" }

# # Process all devices in parallel
# $results = Process-AllDevices -Json $jsonInput -Headers $headers

# # Output the results
# $results




# function Process-AllDevicesParallel {
#     param (
#         [Parameter(Mandatory = $true)]
#         [array]$Json,
#         [Parameter(Mandatory = $true)]
#         [hashtable]$Headers
#     )

#     $results = $Json | ForEach-Object -Parallel {
#         # Import and install necessary modules


      

#         # Initialize results in each runspace
#         $localContext = Initialize-Results

#         if ($_.userDisplayName -eq "On-Premises Directory Synchronization Service Account") {
#             return
#         }

#         try {
#             Process-DeviceItem -Item $_ -Context $localContext -Headers $using:Headers
#         } catch {
#             Handle-Error -ErrorRecord $_
#         }

#         return $localContext.Results
#     } -ThrottleLimit 4

#     return $results
# }

