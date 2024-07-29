function Output-Secrets {
    param (
        [Parameter(Mandatory = $false)]
        [string]$AppDisplayName,
        
        [Parameter(Mandatory = $false)]
        [string]$ApplicationID,
        
        [Parameter(Mandatory = $false)]
        [string]$Thumbprint,
        
        [Parameter(Mandatory = $false)]
        [string]$TenantID,
        
        [Parameter(Mandatory = $false)]
        [string]$SecretsFile,
        
        [Parameter(Mandatory = $false)]
        [string]$CertPassword,
        
        [Parameter(Mandatory = $false)]
        [string]$CertName,
        
        [Parameter(Mandatory = $false)]
        [string]$TenantName,
        
        [Parameter(Mandatory = $false)]
        [string]$TenantDomainName,
        
        [Parameter(Mandatory = $false)]
        [string]$OutputPath
    )

    try {
        Write-EnhancedLog -Message "Starting to output secrets." -Level "INFO"
        
        $secrets = @{
            AppDisplayName   = $AppDisplayName
            ClientId         = $ApplicationID
            Thumbprint       = $Thumbprint
            TenantID         = $TenantID
            CertPassword     = $CertPassword
            CertName         = $CertName
            TenantName       = $TenantName
            TenantDomainName = $TenantDomainName
            OutputPath       = $OutputPath
        }

        $secrets | ConvertTo-Json | Set-Content -Path $SecretsFile

        Write-EnhancedLog -Message "Secrets have been written to file: $SecretsFile" -Level "INFO"

        Write-Host "================ Secrets ================"
        Write-Host "`$AppDisplayName    = $($AppDisplayName)"
        Write-Host "`$ClientId          = $($ApplicationID)"
        Write-Host "`$Thumbprint        = $($Thumbprint)"
        Write-Host "`$TenantID          = $TenantID"
        Write-Host "`$CertPassword      = $CertPassword"
        Write-Host "`$CertName          = $CertName"
        Write-Host "`$TenantName        = $TenantName"
        Write-Host "`$TenantDomainName  = $TenantDomainName"
        Write-Host "`$OutputPath        = $OutputPath"
        Write-Host "================ Secrets ================"
        Write-Host "    SAVE THESE IN A SECURE LOCATION     "

        Write-EnhancedLog -Message "Secrets have been output to the console." -Level "INFO"

    } catch {
        Write-EnhancedLog -Message "An error occurred while outputting secrets." -Level "ERROR"
        Handle-Error -ErrorRecord $_
        throw $_
    }
}

# # Example usage
# $params = @{
#     AppDisplayName    = $app.DisplayName
#     ApplicationID     = $app.AppId
#     TenantID          = $tenantDetails.Id
#     SecretsFile       = $secretsfile
#     CertName          = $Certname
#     Thumbprint        = $thumbprint
#     CertPassword      = $CertPassword
#     TenantName        = $tenantDetails.DisplayName
#     TenantDomainName  = $tenantDetails.DomainName
#     OutputPath        = $certexportDirectory
# }

# Output-Secrets @params
