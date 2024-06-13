# function Check-DeviceStateInIntune {
#     param (
#         [Parameter(Mandatory = $true)]
#         [string]$entraDeviceId,
#         [Parameter(Mandatory = $true)]
#         [string]$username,
#         [Parameter(Mandatory = $true)]
#         [hashtable]$headers
#     )

#     if (-not [string]::IsNullOrWhiteSpace($entraDeviceId)) {
#         Write-EnhancedLog -Message "Checking device state in Intune for Entra Device ID: $entraDeviceId for username: $username " -ForegroundColor Cyan

#         # Construct the Graph API URL to retrieve device details
#         $graphApiUrl = "https://graph.microsoft.com/v1.0/deviceManagement/managedDevices?`$filter=azureADDeviceId eq '$entraDeviceId'"
#         Write-EnhancedLog -Message "Constructed Graph API URL: $graphApiUrl"

#         # Send the request
#         try {
#             $response = Invoke-WebRequest -Uri $graphApiUrl -Headers $headers -Method Get
#             $data = ($response.Content | ConvertFrom-Json).value

#             if ($data -and $data.Count -gt 0) {
#                 Write-EnhancedLog -Message "Device is present in Intune." -ForegroundColor Green
#                 return "Present"
#             } else {
#                 Write-EnhancedLog -Message "Device is absent in Intune." -ForegroundColor Yellow
#                 return "Absent"
#             }
#         } catch {
#             Handle-Error -ErrorRecord $_
#             return "Error"
#         }
#     } else {
#         # Write-EnhancedLog -Message "Device ID is empty, considered as BYOD." -ForegroundColor Yellow #uncomment if verbose output is desired
#         return "BYOD"
#     }
# }



# function Check-DeviceStateInIntune {
#     param (
#         [Parameter(Mandatory = $true)]
#         [string]$entraDeviceId,
#         [Parameter(Mandatory = $true)]
#         [string]$username,
#         [Parameter(Mandatory = $true)]
#         [hashtable]$headers
#     )

#     if ([string]::IsNullOrWhiteSpace($entraDeviceId)) {
#         # Write-EnhancedLog -Message "Device ID is empty, considered as BYOD." -ForegroundColor Yellow #uncomment if verbose output is desired
#         return "BYOD"
#     }

#     Write-EnhancedLog -Message "Checking device state in Intune for Entra Device ID: $entraDeviceId for username: $username" -ForegroundColor Cyan

#     # Construct the Graph API URL to retrieve device details
#     $graphApiUrl = "https://graph.microsoft.com/v1.0/deviceManagement/managedDevices?\$filter=azureADDeviceId eq '$entraDeviceId'"
#     Write-EnhancedLog -Message "Constructed Graph API URL: $graphApiUrl"

#     # Create an instance of HttpClient
#     $httpClient = [System.Net.Http.HttpClient]::new()
#     $httpClient.DefaultRequestHeaders.Add("Authorization", $headers["Authorization"])

#     try {
#         # Send the request
#         $response = $httpClient.GetStringAsync($graphApiUrl).Result

#         # Parse the response
#         $jsonDoc = [System.Text.Json.JsonDocument]::Parse($response)
#         $rootElement = $jsonDoc.RootElement

#         if ($rootElement.TryGetProperty("value", [ref]$valueProperty) -and $valueProperty.GetArrayLength() -gt 0) {
#             Write-EnhancedLog -Message "Device is present in Intune." -ForegroundColor Green
#             return "Present"
#         } else {
#             Write-EnhancedLog -Message "Device is absent in Intune." -ForegroundColor Yellow
#             return "Absent"
#         }
#     } catch {
#         Handle-Error -ErrorRecord $_
#         return "Error"
#     } finally {
#         $httpClient.Dispose()
#         if ($jsonDoc) {
#             $jsonDoc.Dispose()
#         }
#     }
# }



# function Check-DeviceStateInIntune {
#     param (
#         [Parameter(Mandatory = $true)]
#         [string]$entraDeviceId,
#         [Parameter(Mandatory = $true)]
#         [string]$username,
#         [Parameter(Mandatory = $true)]
#         [hashtable]$headers
#     )

#     if ([string]::IsNullOrWhiteSpace($entraDeviceId)) {
#         # Write-EnhancedLog -Message "Device ID is empty, considered as BYOD." -ForegroundColor Yellow #uncomment if verbose output is desired
#         return "BYOD"
#     }

#     Write-EnhancedLog -Message "Checking device state in Intune for Entra Device ID: $entraDeviceId for username: $username" -ForegroundColor Cyan

#     # Construct the Graph API URL to retrieve device details
#     $graphApiUrl = "https://graph.microsoft.com/v1.0/deviceManagement/managedDevices?\$filter=azureADDeviceId eq '$entraDeviceId'"
#     Write-EnhancedLog -Message "Constructed Graph API URL: $graphApiUrl"

#     # Create an instance of HttpClient
#     $httpClient = [System.Net.Http.HttpClient]::new()
#     $httpClient.DefaultRequestHeaders.Add("Authorization", $headers["Authorization"])

#     try {
#         # Send the request
#         $response = $httpClient.GetStringAsync($graphApiUrl).Result

#         # Parse the response
#         $jsonDoc = [System.Text.Json.JsonDocument]::Parse($response)
#         $rootElement = $jsonDoc.RootElement
#         $valueProperty = $null

#         if ($rootElement.TryGetProperty("value", [ref]$valueProperty) -and $valueProperty.GetArrayLength() -gt 0) {
#             Write-EnhancedLog -Message "Device is present in Intune." -ForegroundColor Green
#             return "Present"
#         } else {
#             Write-EnhancedLog -Message "Device is absent in Intune." -ForegroundColor Yellow
#             return "Absent"
#         }
#     } catch {
#         Handle-Error -ErrorRecord $_
#         return "Error"
#     } finally {
#         $httpClient.Dispose()
#         if ($jsonDoc) {
#             $jsonDoc.Dispose()
#         }
#     }
# }



# function Check-DeviceStateInIntune {
#     param (
#         [Parameter(Mandatory = $true)]
#         [string]$entraDeviceId,
#         [Parameter(Mandatory = $true)]
#         [string]$username,
#         [Parameter(Mandatory = $true)]
#         [hashtable]$headers
#     )

#     if ([string]::IsNullOrWhiteSpace($entraDeviceId)) {
#         # Write-EnhancedLog -Message "Device ID is empty, considered as BYOD." -ForegroundColor Yellow #uncomment if verbose output is desired
#         return "BYOD"
#     }

#     Write-EnhancedLog -Message "Checking device state in Intune for Entra Device ID: $entraDeviceId for username: $username" -ForegroundColor Cyan

#     # Construct the Graph API URL to retrieve device details
#     $graphApiUrl = "https://graph.microsoft.com/v1.0/deviceManagement/managedDevices?\$filter=azureADDeviceId eq '$entraDeviceId'"
#     Write-EnhancedLog -Message "Constructed Graph API URL: $graphApiUrl"

#     # Create an instance of HttpClient
#     $httpClient = [System.Net.Http.HttpClient]::new()
#     $httpClient.DefaultRequestHeaders.Add("Authorization", $headers["Authorization"])

#     try {
#         # Send the request
#         $response = $httpClient.GetStringAsync($graphApiUrl).Result

#         # Parse the response
#         $jsonDoc = [System.Text.Json.JsonDocument]::Parse($response)
#         $rootElement = $jsonDoc.RootElement
#         $valueProperty = $null

#         # Check if the "value" property exists and has elements
#         if ($rootElement.TryGetProperty("value", [ref]$valueProperty) -and $valueProperty.ValueKind -eq [System.Text.Json.JsonValueKind]::Array -and $valueProperty.GetArrayLength() -gt 0) {
#             Write-EnhancedLog -Message "Device is present in Intune." -ForegroundColor Green
#             return "Present"
#         } else {
#             Write-EnhancedLog -Message "Device is absent in Intune." -ForegroundColor Yellow
#             return "Absent"
#         }
#     } catch {
#         Handle-Error -ErrorRecord $_
#         return "Error"
#     } finally {
#         $httpClient.Dispose()
#         if ($jsonDoc) {
#             $jsonDoc.Dispose()
#         }
#     }
# }






# function Check-DeviceStateInIntune {
#     param (
#         [Parameter(Mandatory = $true)]
#         [string]$entraDeviceId,
#         [Parameter(Mandatory = $true)]
#         [string]$username,
#         [Parameter(Mandatory = $true)]
#         [hashtable]$headers
#     )

#     if ([string]::IsNullOrWhiteSpace($entraDeviceId)) {
#         # Write-EnhancedLog -Message "Device ID is empty, considered as BYOD." -ForegroundColor Yellow #uncomment if verbose output is desired
#         return "BYOD"
#     }

#     Write-EnhancedLog -Message "Checking device state in Intune for Entra Device ID: $entraDeviceId for username: $username" -ForegroundColor Cyan

#     # Construct the Graph API URL to retrieve device details
#     $graphApiUrl = "https://graph.microsoft.com/v1.0/deviceManagement/managedDevices?\$filter=azureADDeviceId eq '$entraDeviceId'"
#     Write-EnhancedLog -Message "Constructed Graph API URL: $graphApiUrl"

#     # Create an instance of HttpClient
#     $httpClient = [System.Net.Http.HttpClient]::new()
#     $httpClient.DefaultRequestHeaders.Add("Authorization", $headers["Authorization"])

#     try {
#         # Send the request
#         $response = $httpClient.GetStringAsync($graphApiUrl).Result

#         # Parse the response
#         $jsonDoc = [System.Text.Json.JsonDocument]::Parse($response)
#         $rootElement = $jsonDoc.RootElement

#         # Check if the "value" property exists and has elements
#         if ($rootElement.TryGetProperty("value", [ref]$valueProperty) -and $valueProperty.ValueKind -eq [System.Text.Json.JsonValueKind]::Array -and $valueProperty.GetArrayLength() -gt 0) {
#             Write-EnhancedLog -Message "Device is present in Intune." -ForegroundColor Green
#             return "Present"
#         } else {
#             Write-EnhancedLog -Message "Device is absent in Intune." -ForegroundColor Yellow
#             return "Absent"
#         }
#     } catch {
#         Handle-Error -ErrorRecord $_
#         return "Error"
#     } finally {
#         $httpClient.Dispose()
#         if ($jsonDoc) {
#             $jsonDoc.Dispose()
#         }
#     }
# }





# function Check-DeviceStateInIntune {
#     param (
#         [Parameter(Mandatory = $true)]
#         [string]$entraDeviceId,
#         [Parameter(Mandatory = $true)]
#         [string]$username,
#         [Parameter(Mandatory = $true)]
#         [hashtable]$headers
#     )

#     if ([string]::IsNullOrWhiteSpace($entraDeviceId)) {
#         # Write-EnhancedLog -Message "Device ID is empty, considered as BYOD." -ForegroundColor Yellow #uncomment if verbose output is desired
#         return "BYOD"
#     }

#     Write-EnhancedLog -Message "Checking device state in Intune for Entra Device ID: $entraDeviceId for username: $username" -ForegroundColor Cyan

#     # Construct the Graph API URL to retrieve device details
#     $graphApiUrl = "https://graph.microsoft.com/v1.0/deviceManagement/managedDevices?\$filter=azureADDeviceId eq '$entraDeviceId'"
#     Write-EnhancedLog -Message "Constructed Graph API URL: $graphApiUrl"

#     # Create an instance of HttpClient
#     $httpClient = [System.Net.Http.HttpClient]::new()
#     $httpClient.DefaultRequestHeaders.Add("Authorization", $headers["Authorization"])

#     try {
#         # Send the request
#         $response = $httpClient.GetStringAsync($graphApiUrl).Result

#         # Parse the response
#         $jsonDoc = [System.Text.Json.JsonDocument]::Parse($response)
#         $rootElement = $jsonDoc.RootElement

#         # Check if the "value" property exists and has elements
#         if ($rootElement.TryGetProperty("value").ValueKind -eq [System.Text.Json.JsonValueKind]::Array -and $rootElement.GetProperty("value").GetArrayLength() -gt 0) {
#             Write-EnhancedLog -Message "Device is present in Intune." -ForegroundColor Green
#             return "Present"
#         } else {
#             Write-EnhancedLog -Message "Device is absent in Intune." -ForegroundColor Yellow
#             return "Absent"
#         }
#     } catch {
#         Handle-Error -ErrorRecord $_
#         return "Error"
#     } finally {
#         $httpClient.Dispose()
#         if ($jsonDoc) {
#             $jsonDoc.Dispose()
#         }
#     }
# }



# function Check-DeviceStateInIntune {
#     param (
#         [Parameter(Mandatory = $true)]
#         [string]$entraDeviceId,
#         [Parameter(Mandatory = $true)]
#         [string]$username,
#         [Parameter(Mandatory = $true)]
#         [hashtable]$headers
#     )

#     if ([string]::IsNullOrWhiteSpace($entraDeviceId)) {
#         # Write-EnhancedLog -Message "Device ID is empty, considered as BYOD." -ForegroundColor Yellow #uncomment if verbose output is desired
#         return "BYOD"
#     }

#     Write-EnhancedLog -Message "Checking device state in Intune for Entra Device ID: $entraDeviceId for username: $username" -ForegroundColor Cyan

#     # Construct the Graph API URL to retrieve device details
#     $graphApiUrl = "https://graph.microsoft.com/v1.0/deviceManagement/managedDevices?\$filter=azureADDeviceId eq '$entraDeviceId'"
#     Write-EnhancedLog -Message "Constructed Graph API URL: $graphApiUrl"

#     # Create an instance of HttpClient
#     $httpClient = [System.Net.Http.HttpClient]::new()
#     $httpClient.DefaultRequestHeaders.Add("Authorization", $headers["Authorization"])

#     try {
#         # Send the request
#         $response = $httpClient.GetStringAsync($graphApiUrl).Result

#         # Parse the response
#         $jsonDoc = [System.Text.Json.JsonDocument]::Parse($response)
#         $rootElement = $jsonDoc.RootElement

#         # Check if the "value" property exists and has elements
#         if ($rootElement.TryGetProperty("value").GetArrayLength() -gt 0) {
#             Write-EnhancedLog -Message "Device is present in Intune." -ForegroundColor Green
#             return "Present"
#         } else {
#             Write-EnhancedLog -Message "Device is absent in Intune." -ForegroundColor Yellow
#             return "Absent"
#         }
#     } catch {
#         Handle-Error -ErrorRecord $_
#         return "Error"
#     } finally {
#         $httpClient.Dispose()
#         if ($jsonDoc) {
#             $jsonDoc.Dispose()
#         }
#     }
# }





class DeviceStateChecker {
    [string]$EntraDeviceId
    [string]$Username
    [hashtable]$Headers
    [System.Net.Http.HttpClient]$HttpClient

    DeviceStateChecker([string]$entraDeviceId, [string]$username, [hashtable]$headers) {
        $this.EntraDeviceId = $entraDeviceId
        $this.Username = $username
        $this.Headers = $headers
        $this.HttpClient = [System.Net.Http.HttpClient]::new()
        $this.HttpClient.DefaultRequestHeaders.Add("Authorization", $headers["Authorization"])
    }

    [string] CheckState() {
        if ([string]::IsNullOrWhiteSpace($this.EntraDeviceId)) {
            return "BYOD"
        }

        Write-EnhancedLog -Message "Checking device state in Intune for Entra Device ID: $($this.EntraDeviceId) for username: $($this.Username)" -ForegroundColor Cyan

        $graphApiUrl = "https://graph.microsoft.com/v1.0/deviceManagement/managedDevices?`$filter=azureADDeviceId eq '$($this.EntraDeviceId)'"
        Write-EnhancedLog -Message "Constructed Graph API URL: $graphApiUrl"

        try {
            $response = $this.HttpClient.GetStringAsync($graphApiUrl).Result
            $responseJson = [System.Text.Json.JsonDocument]::Parse($response)

            $valueProperty = $responseJson.RootElement.GetProperty("value")
            if ($valueProperty.GetArrayLength() -gt 0) {
                Write-EnhancedLog -Message "Device is present in Intune." -ForegroundColor Green
                return "Present"
            } else {
                Write-EnhancedLog -Message "Device is absent in Intune." -ForegroundColor Yellow
                return "Absent"
            }
        } catch {
            Handle-Error -ErrorRecord $_
            return "Error"
        } finally {
            $responseJson.Dispose()
        }
    }

    [void] Dispose() {
        $this.HttpClient.Dispose()
    }
}

function Check-DeviceStateInIntune {
    param (
        [Parameter(Mandatory = $true)]
        [string]$EntraDeviceId,
        [Parameter(Mandatory = $true)]
        [string]$Username,
        [Parameter(Mandatory = $true)]
        [hashtable]$Headers
    )

    # Create an instance of DeviceStateChecker
    $checker = [DeviceStateChecker]::new($EntraDeviceId, $Username, $Headers)

    try {
        # Check device state
        $state = $checker.CheckState()
    } finally {
        # Dispose of the checker
        $checker.Dispose()
    }

    return $state
}

