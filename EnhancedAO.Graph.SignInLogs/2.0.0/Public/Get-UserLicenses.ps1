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