function Get-TenantDetails {
    try {
        # Retrieve the organization details
        $organization = Get-MgOrganization

        # Extract the required details
        $tenantName = $organization.DisplayName
        $tenantId = $organization.Id

        # Initialize tenantDomain
        $tenantDomain = $null

        # Search for a verified domain matching the onmicrosoft.com pattern
        foreach ($domain in $organization.VerifiedDomains) {
            if ($domain.Name -match '\.onmicrosoft\.com$') {
                $tenantDomain = $domain.Name
                break
            }
        }

        # Adjust the tenant domain if necessary
        if ($tenantDomain -match '\.mail\.onmicrosoft\.com$') {
            $tenantDomain = $tenantDomain -replace '\.mail\.onmicrosoft\.com$', '.onmicrosoft.com'
        }

        if ($null -eq $tenantDomain) {
            throw "No onmicrosoft.com domain found."
        }

        # Output tenant summary
        Write-EnhancedLog -Message "Tenant Name: $tenantName" -Level "INFO"
        Write-EnhancedLog -Message "Tenant ID: $tenantId" -Level "INFO"
        Write-EnhancedLog -Message "Tenant Domain: $tenantDomain" -Level "INFO"


        # Return the extracted details
        return @{
            TenantName = $tenantName
            TenantId = $tenantId
            TenantDomain = $tenantDomain
        }
    } catch {
        Handle-Error -ErrorRecord $_
        Write-EnhancedLog -Message "Failed to retrieve tenant details" -Level "ERROR"
        return $null
    }
}

# # Example usage
# $tenantDetails = Get-TenantDetails

# if ($null -ne $tenantDetails) {
#     $tenantName = $tenantDetails.TenantName
#     $tenantId = $tenantDetails.TenantId
#     $tenantDomain = $tenantDetails.TenantDomain

#     # Use the tenant details as needed
#     Write-EnhancedLog -Message "Using Tenant Details outside the function" -Level "INFO"
#     Write-EnhancedLog -Message "Tenant Name: $tenantName" -Level "INFO"
#     Write-EnhancedLog -Message "Tenant ID: $tenantId" -Level "INFO"
#     Write-EnhancedLog -Message "Tenant Domain: $tenantDomain" -Level "INFO"
# } else {
#     Write-EnhancedLog -Message "Tenant details could not be retrieved." -Level "ERROR"
# }
