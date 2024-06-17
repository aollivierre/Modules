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

