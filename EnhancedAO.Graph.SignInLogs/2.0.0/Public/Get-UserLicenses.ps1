# Function to fetch user licenses
function Get-UserLicenses {
    param (
        [Parameter(Mandatory = $true)]
        [string]$userId,
        [Parameter(Mandatory = $true)]
        [string]$username,
        [Parameter(Mandatory = $true)]
        [hashtable]$Headers
    )

    $licenses = [System.Collections.Generic.List[string]]::new()
    $uri = "https://graph.microsoft.com/v1.0/users/$userId/licenseDetails"

    try {
        Write-EnhancedLog -Message "Fetching licenses for user ID: $userId with username: $username" -Level "INFO" -ForegroundColor ([ConsoleColor]::Cyan)

        $response = Invoke-RestMethod -Uri $uri -Headers $Headers -Method Get

        if ($null -ne $response -and $null -ne $response.value) {
            foreach ($license in $response.value) {
                $licenses.Add($license.skuId)
            }
        } else {
            Write-EnhancedLog -Message "No license details found for user ID: $userId" -Level "WARNING" -ForegroundColor ([ConsoleColor]::Yellow)
        }
    } catch {
        Handle-Error -ErrorRecord $_
        throw
    }

    return $licenses
}





