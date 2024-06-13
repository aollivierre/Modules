# Function to fetch user licenses
# function Get-UserLicenses {
#     param (
#         [Parameter(Mandatory = $true)]
#         [string]$userId,
#         [Parameter(Mandatory = $true)]
#         [string]$username,
#         [Parameter(Mandatory = $true)]
#         [hashtable]$Headers
#     )

#     $licenses = [System.Collections.Generic.List[string]]::new()
#     $uri = "https://graph.microsoft.com/v1.0/users/$userId/licenseDetails"

#     try {
#         # Write-EnhancedLog -Message "Fetching licenses for user ID: $userId with username: $username" -Level "INFO" -ForegroundColor ([ConsoleColor]::Cyan)

#         $response = Invoke-RestMethod -Uri $uri -Headers $Headers -Method Get

#         if ($null -ne $response -and $null -ne $response.value) {
#             foreach ($license in $response.value) {
#                 $licenses.Add($license.skuId)
#             }
#         } else {
#             # Write-EnhancedLog -Message "No license details found for user ID: $userId" -Level "WARNING" -ForegroundColor ([ConsoleColor]::Yellow)
#         }
#     } catch {
#         Handle-Error -ErrorRecord $_
#         throw
#     }

#     return $licenses
# }






# class UserLicenseFetcher {
#     [string]$UserId
#     [string]$Username
#     [hashtable]$Headers
#     [System.Net.Http.HttpClient]$HttpClient

#     UserLicenseFetcher([string]$userId, [string]$username, [hashtable]$headers) {
#         $this.UserId = $userId
#         $this.Username = $username
#         $this.Headers = $headers
#         $this.HttpClient = [System.Net.Http.HttpClient]::new()
#         $this.HttpClient.DefaultRequestHeaders.Add("Authorization", $headers["Authorization"])
#     }

#     [System.Collections.Generic.List[string]] GetLicenses() {
#         $licenses = [System.Collections.Generic.List[string]]::new()
#         $uri = "https://graph.microsoft.com/v1.0/users/$($this.UserId)/licenseDetails"

#         try {
#             # Write-EnhancedLog -Message "Fetching licenses for user ID: $($this.UserId) with username: $($this.Username)" -Level "INFO" -ForegroundColor ([ConsoleColor]::Cyan)

#             $response = $this.HttpClient.GetStringAsync($uri).Result
#             $responseJson = [System.Text.Json.JsonDocument]::Parse($response)

#             if ($responseJson.RootElement.TryGetProperty("value", [ref]$licenseArray)) {
#                 foreach ($license in $licenseArray.EnumerateArray()) {
#                     $licenses.Add($license.GetProperty("skuId").GetString())
#                 }
#             } else {
#                 # Write-EnhancedLog -Message "No license details found for user ID: $($this.UserId)" -Level "WARNING" -ForegroundColor ([ConsoleColor]::Yellow)
#             }
#         } catch {
#             Handle-Error -ErrorRecord $_
#             throw
#         }

#         return $licenses
#     }

#     [void] Dispose() {
#         $this.HttpClient.Dispose()
#     }
# }

# class UserLicenseFetcher {
#     [string]$UserId
#     [string]$Username
#     [hashtable]$Headers
#     [System.Net.Http.HttpClient]$HttpClient

#     UserLicenseFetcher([string]$userId, [string]$username, [hashtable]$headers) {
#         $this.UserId = $userId
#         $this.Username = $username
#         $this.Headers = $headers
#         $this.HttpClient = [System.Net.Http.HttpClient]::new()
#         $this.HttpClient.DefaultRequestHeaders.Add("Authorization", $headers["Authorization"])
#     }

#     [System.Collections.Generic.List[string]] GetLicenses() {
#         $licenses = [System.Collections.Generic.List[string]]::new()
#         $uri = "https://graph.microsoft.com/v1.0/users/$($this.UserId)/licenseDetails"

#         try {
#             # Write-EnhancedLog -Message "Fetching licenses for user ID: $($this.UserId) with username: $($this.Username)" -Level "INFO" -ForegroundColor ([ConsoleColor]::Cyan)

#             $response = $this.HttpClient.GetStringAsync($uri).Result
#             $responseJson = [System.Text.Json.JsonDocument]::Parse($response)

#             if ($responseJson.RootElement.TryGetProperty("value", [ref]$licenseArray)) {
#                 foreach ($license in $licenseArray.EnumerateArray()) {
#                     $licenses.Add($license.GetProperty("skuId").GetString())
#                 }
#             } else {
#                 # Write-EnhancedLog -Message "No license details found for user ID: $($this.UserId)" -Level "WARNING" -ForegroundColor ([ConsoleColor]::Yellow)
#             }
#         } catch {
#             Handle-Error -ErrorRecord $_
#             throw
#         }

#         return $licenses
#     }

#     [void] Dispose() {
#         $this.HttpClient.Dispose()
#     }
# }





# function Get-UserLicenses {
#     param (
#         [Parameter(Mandatory = $true)]
#         [string]$UserId,
#         [Parameter(Mandatory = $true)]
#         [string]$Username,
#         [Parameter(Mandatory = $true)]
#         [hashtable]$Headers
#     )

#     # Create an instance of UserLicenseFetcher
#     $fetcher = [UserLicenseFetcher]::new($UserId, $Username, $Headers)

#     try {
#         # Get user licenses
#         $licenses = $fetcher.GetLicenses()
#     } finally {
#         # Dispose of the fetcher
#         $fetcher.Dispose()
#     }

#     return $licenses
# }


# # Define headers
# $headers = @{
#     Authorization = "Bearer <access_token>"
# }

# # Get user licenses
# $userLicenses = Get-UserLicenses -UserId "user_id_here" -Username "username_here" -Headers $headers

# # Output the licenses
# $userLicenses







# class UserLicenseFetcher {
#     [string]$UserId
#     [string]$Username
#     [hashtable]$Headers
#     [System.Net.Http.HttpClient]$HttpClient

#     UserLicenseFetcher([string]$userId, [string]$username, [hashtable]$headers) {
#         $this.UserId = $userId
#         $this.Username = $username
#         $this.Headers = $headers
#         $this.HttpClient = [System.Net.Http.HttpClient]::new()
#         $this.HttpClient.DefaultRequestHeaders.Add("Authorization", $headers["Authorization"])
#     }

#     [System.Collections.Generic.List[string]] GetLicenses() {
#         $licenses = [System.Collections.Generic.List[string]]::new()
#         $uri = "https://graph.microsoft.com/v1.0/users/$($this.UserId)/licenseDetails"

#         try {
#             # Write-EnhancedLog -Message "Fetching licenses for user ID: $($this.UserId) with username: $($this.Username)" -Level "INFO" -ForegroundColor ([ConsoleColor]::Cyan)

#             $response = $this.HttpClient.GetStringAsync($uri).Result
#             $responseJson = [System.Text.Json.JsonDocument]::Parse($response)
#             $licenseArray = $null

#             if ($responseJson.RootElement.TryGetProperty("value", [ref]$licenseArray)) {
#                 foreach ($license in $licenseArray.EnumerateArray()) {
#                     $licenses.Add($license.GetProperty("skuId").GetString())
#                 }
#             } else {
#                 # Write-EnhancedLog -Message "No license details found for user ID: $($this.UserId)" -Level "WARNING" -ForegroundColor ([ConsoleColor]::Yellow)
#             }
#         } catch {
#             Handle-Error -ErrorRecord $_
#             throw
#         }

#         return $licenses
#     }

#     [void] Dispose() {
#         $this.HttpClient.Dispose()
#     }
# }




# function Get-UserLicenses {
#     param (
#         [Parameter(Mandatory = $true)]
#         [string]$UserId,
#         [Parameter(Mandatory = $true)]
#         [string]$Username,
#         [Parameter(Mandatory = $true)]
#         [hashtable]$Headers
#     )

#     # Create an instance of UserLicenseFetcher
#     $fetcher = [UserLicenseFetcher]::new($UserId, $Username, $Headers)

#     try {
#         # Get user licenses
#         $licenses = $fetcher.GetLicenses()
#     } finally {
#         # Dispose of the fetcher
#         $fetcher.Dispose()
#     }

#     return $licenses
# }



# class UserLicenseFetcher {
#     [string]$UserId
#     [string]$Username
#     [hashtable]$Headers
#     [System.Net.Http.HttpClient]$HttpClient

#     UserLicenseFetcher([string]$userId, [string]$username, [hashtable]$headers) {
#         $this.UserId = $userId
#         $this.Username = $username
#         $this.Headers = $headers
#         $this.HttpClient = [System.Net.Http.HttpClient]::new()
#         $this.HttpClient.DefaultRequestHeaders.Add("Authorization", $headers["Authorization"])
#     }

#     [System.Collections.Generic.List[string]] GetLicenses() {
#         $licenses = [System.Collections.Generic.List[string]]::new()
#         $uri = "https://graph.microsoft.com/v1.0/users/$($this.UserId)/licenseDetails"

#         try {
#             # Write-EnhancedLog -Message "Fetching licenses for user ID: $($this.UserId) with username: $($this.Username)" -Level "INFO" -ForegroundColor ([ConsoleColor]::Cyan)

#             $response = $this.HttpClient.GetStringAsync($uri).Result
#             $responseJson = [System.Text.Json.JsonDocument]::Parse($response)
#             $licenseArray = $null

#             if ($responseJson.RootElement.TryGetProperty("value", [ref]$licenseArray)) {
#                 foreach ($license in $licenseArray.EnumerateArray()) {
#                     $licenses.Add($license.GetProperty("skuId").GetString())
#                 }
#             } else {
#                 # Write-EnhancedLog -Message "No license details found for user ID: $($this.UserId)" -Level "WARNING" -ForegroundColor ([ConsoleColor]::Yellow)
#             }
#         } catch {
#             Handle-Error -ErrorRecord $_
#             throw
#         }

#         return $licenses
#     }

#     [void] Dispose() {
#         $this.HttpClient.Dispose()
#     }
# }

# function Get-UserLicenses {
#     param (
#         [Parameter(Mandatory = $true)]
#         [string]$UserId,
#         [Parameter(Mandatory = $true)]
#         [string]$Username,
#         [Parameter(Mandatory = $true)]
#         [hashtable]$Headers
#     )

#     # Create an instance of UserLicenseFetcher
#     $fetcher = [UserLicenseFetcher]::new($UserId, $Username, $Headers)

#     try {
#         # Get user licenses
#         $licenses = $fetcher.GetLicenses()
#     } finally {
#         # Dispose of the fetcher
#         $fetcher.Dispose()
#     }

#     return $licenses
# }







# class UserLicenseFetcher {
#     [string]$UserId
#     [string]$Username
#     [hashtable]$Headers
#     [System.Net.Http.HttpClient]$HttpClient

#     UserLicenseFetcher([string]$userId, [string]$username, [hashtable]$headers) {
#         $this.UserId = $userId
#         $this.Username = $username
#         $this.Headers = $headers
#         $this.HttpClient = [System.Net.Http.HttpClient]::new()
#         $this.HttpClient.DefaultRequestHeaders.Add("Authorization", $headers["Authorization"])
#     }

#     [System.Collections.Generic.List[string]] GetLicenses() {
#         $licenses = [System.Collections.Generic.List[string]]::new()
#         $uri = "https://graph.microsoft.com/v1.0/users/$($this.UserId)/licenseDetails"

#         try {
#             # Write-EnhancedLog -Message "Fetching licenses for user ID: $($this.UserId) with username: $($this.Username)" -Level "INFO" -ForegroundColor ([ConsoleColor]::Cyan)

#             $response = $this.HttpClient.GetStringAsync($uri).Result
#             $responseJson = [System.Text.Json.JsonDocument]::Parse($response)
            
#             $licenseArray = $null
#             if ($responseJson.RootElement.TryGetProperty("value", [ref]$licenseArray)) {
#                 foreach ($license in $licenseArray.EnumerateArray()) {
#                     $licenses.Add($license.GetProperty("skuId").GetString())
#                 }
#             } else {
#                 # Write-EnhancedLog -Message "No license details found for user ID: $($this.UserId)" -Level "WARNING" -ForegroundColor ([ConsoleColor]::Yellow)
#             }
#         } catch {
#             Handle-Error -ErrorRecord $_
#             throw
#         }

#         return $licenses
#     }

#     [void] Dispose() {
#         $this.HttpClient.Dispose()
#     }
# }




# function Get-UserLicenses {
#     param (
#         [Parameter(Mandatory = $true)]
#         [string]$UserId,
#         [Parameter(Mandatory = $true)]
#         [string]$Username,
#         [Parameter(Mandatory = $true)]
#         [hashtable]$Headers
#     )

#     # Create an instance of UserLicenseFetcher
#     $fetcher = [UserLicenseFetcher]::new($UserId, $Username, $Headers)

#     try {
#         # Get user licenses
#         $licenses = $fetcher.GetLicenses()
#     } finally {
#         # Dispose of the fetcher
#         $fetcher.Dispose()
#     }

#     return $licenses
# }



# class UserLicenseFetcher {
#     [string]$UserId
#     [string]$Username
#     [hashtable]$Headers
#     [System.Net.Http.HttpClient]$HttpClient

#     UserLicenseFetcher([string]$userId, [string]$username, [hashtable]$headers) {
#         $this.UserId = $userId
#         $this.Username = $username
#         $this.Headers = $headers
#         $this.HttpClient = [System.Net.Http.HttpClient]::new()
#         $this.HttpClient.DefaultRequestHeaders.Add("Authorization", $headers["Authorization"])
#     }

#     [System.Collections.Generic.List[string]] GetLicenses() {
#         $licenses = [System.Collections.Generic.List[string]]::new()
#         $uri = "https://graph.microsoft.com/v1.0/users/$($this.UserId)/licenseDetails"

#         try {
#             # Write-EnhancedLog -Message "Fetching licenses for user ID: $($this.UserId) with username: $($this.Username)" -Level "INFO" -ForegroundColor ([ConsoleColor]::Cyan)

#             $response = $this.HttpClient.GetStringAsync($uri).Result
#             $responseJson = [System.Text.Json.JsonDocument]::Parse($response)

#             $licenseArray = $null
#             if ($responseJson.RootElement.TryGetProperty("value", [ref]$licenseArray)) {
#                 foreach ($license in $licenseArray.EnumerateArray()) {
#                     $licenses.Add($license.GetProperty("skuId").GetString())
#                 }
#             } else {
#                 # Write-EnhancedLog -Message "No license details found for user ID: $($this.UserId)" -Level "WARNING" -ForegroundColor ([ConsoleColor]::Yellow)
#             }
#         } catch {
#             Handle-Error -ErrorRecord $_
#             throw
#         } finally {
#             $responseJson.Dispose()
#         }

#         return $licenses
#     }

#     [void] Dispose() {
#         $this.HttpClient.Dispose()
#     }
# }





# function Get-UserLicenses {
#     param (
#         [Parameter(Mandatory = $true)]
#         [string]$UserId,
#         [Parameter(Mandatory = $true)]
#         [string]$Username,
#         [Parameter(Mandatory = $true)]
#         [hashtable]$Headers
#     )

#     # Create an instance of UserLicenseFetcher
#     $fetcher = [UserLicenseFetcher]::new($UserId, $Username, $Headers)

#     try {
#         # Get user licenses
#         $licenses = $fetcher.GetLicenses()
#     } finally {
#         # Dispose of the fetcher
#         $fetcher.Dispose()
#     }

#     return $licenses
# }


class UserLicenseFetcher {
    [string]$UserId
    [string]$Username
    [hashtable]$Headers
    [System.Net.Http.HttpClient]$HttpClient

    UserLicenseFetcher([string]$userId, [string]$username, [hashtable]$headers) {
        $this.UserId = $userId
        $this.Username = $username
        $this.Headers = $headers
        $this.HttpClient = [System.Net.Http.HttpClient]::new()
        $this.HttpClient.DefaultRequestHeaders.Add("Authorization", $headers["Authorization"])
    }

    [System.Collections.Generic.List[string]] GetLicenses() {
        $licenses = [System.Collections.Generic.List[string]]::new()
        $uri = "https://graph.microsoft.com/v1.0/users/$($this.UserId)/licenseDetails"

        try {
            Write-EnhancedLog -Message "Fetching licenses for user ID: $($this.UserId) with username: $($this.Username)" -Level "INFO" -ForegroundColor ([ConsoleColor]::Cyan)

            $response = $this.HttpClient.GetStringAsync($uri).Result
            $responseJson = [System.Text.Json.JsonDocument]::Parse($response)

            $valueProperty = $responseJson.RootElement.GetProperty("value")
            foreach ($license in $valueProperty.EnumerateArray()) {
                $licenses.Add($license.GetProperty("skuId").GetString())
            }
        } catch {
            Handle-Error -ErrorRecord $_
            throw
        } finally {
            $responseJson.Dispose()
        }

        return $licenses
    }

    [void] Dispose() {
        $this.HttpClient.Dispose()
    }
}



function Get-UserLicenses {
    param (
        [Parameter(Mandatory = $true)]
        [string]$UserId,
        [Parameter(Mandatory = $true)]
        [string]$Username,
        [Parameter(Mandatory = $true)]
        [hashtable]$Headers
    )

    # Create an instance of UserLicenseFetcher
    $fetcher = [UserLicenseFetcher]::new($UserId, $Username, $Headers)

    try {
        # Get user licenses
        $licenses = $fetcher.GetLicenses()
    } finally {
        # Dispose of the fetcher
        $fetcher.Dispose()
    }

    return $licenses
}