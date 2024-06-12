function Get-TenantDetails {
    # Retrieve the organization details
    $organization = Get-MgOrganization

    # Extract the required details
    $tenantName = $organization.DisplayName
    $tenantId = $organization.Id
    $tenantDomain = $organization.VerifiedDomains[0].Name

    # Output tenant summary
    Write-EnhancedLog -Message "Tenant Name: $tenantName" -Level "INFO" -ForegroundColor ([ConsoleColor]::White)
    Write-EnhancedLog -Message "Tenant ID: $tenantId" -Level "INFO" -ForegroundColor ([ConsoleColor]::White)
    Write-EnhancedLog -Message "Tenant Domain: $tenantDomain" -Level "INFO" -ForegroundColor ([ConsoleColor]::White)
}

# Example usage
# Get-TenantDetails
