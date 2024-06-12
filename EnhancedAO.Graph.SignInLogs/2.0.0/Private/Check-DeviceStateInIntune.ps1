function Check-DeviceStateInIntune {
    param (
        [Parameter(Mandatory = $true)]
        [string]$entraDeviceId,
        [Parameter(Mandatory = $true)]
        [string]$username,
        [Parameter(Mandatory = $true)]
        [hashtable]$headers
    )

    if (-not [string]::IsNullOrWhiteSpace($entraDeviceId)) {
        Write-EnhancedLog -Message "Checking device state in Intune for Entra Device ID: $entraDeviceId for username: $username " -ForegroundColor Cyan

        # Construct the Graph API URL to retrieve device details
        $graphApiUrl = "https://graph.microsoft.com/v1.0/deviceManagement/managedDevices?`$filter=azureADDeviceId eq '$entraDeviceId'"
        Write-EnhancedLog -Message "Constructed Graph API URL: $graphApiUrl"

        # Send the request
        try {
            $response = Invoke-WebRequest -Uri $graphApiUrl -Headers $headers -Method Get
            $data = ($response.Content | ConvertFrom-Json).value

            if ($data -and $data.Count -gt 0) {
                Write-EnhancedLog -Message "Device is present in Intune." -ForegroundColor Green
                return "Present"
            } else {
                Write-EnhancedLog -Message "Device is absent in Intune." -ForegroundColor Yellow
                return "Absent"
            }
        } catch {
            Handle-Error -ErrorRecord $_
            return "Error"
        }
    } else {
        # Write-EnhancedLog -Message "Device ID is empty, considered as BYOD." -ForegroundColor Yellow #uncomment if verbose output is desired
        return "BYOD"
    }
}