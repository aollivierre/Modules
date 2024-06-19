# Output secrets to console and file
# function Output-Secrets {
#     param (
#         [string]$AppDisplayName,
#         [string]$ApplicationID,
#         [string]$Thumbprint,
#         [string]$TenantID,
#         # [string]$SecretsFile = "$PSScriptRoot/secrets.json"
#         [string]$SecretsFile,
#         [string]$CertPassword
#     )

#     $secrets = @{
#         AppDisplayName = $AppDisplayName
#         clientId       = $ApplicationID
#         Thumbprint     = $Thumbprint
#         TenantID       = $TenantID
#         CertPassword   = $CertPassword
#         SecretsFile   = $SecretsFile

#     }

#     $secrets | ConvertTo-Json | Set-Content -Path $SecretsFile

#     Write-Host "================ Secrets ================"
#     Write-Host "`$AppDisplayName        = $($AppDisplayName)"
#     Write-Host "`$clientId          = $($ApplicationID)"
#     Write-Host "`$Thumbprint     = $($Thumbprint)"
#     Write-Host "`$TenantID        = $TenantID"
#     Write-Host "================ Secrets ================"
#     Write-Host "    SAVE THESE IN A SECURE LOCATION     "
# }





# Output secrets to console and file
# function Output-Secrets {
#     param (
#         [string]$AppDisplayName,
#         [string]$ApplicationID,
#         [string]$Thumbprint,
#         [string]$TenantID,
#         [string]$SecretsFile,
#         [string]$CertPassword,
#         [string]$CertName,
#         [string]$TenantName,
#         [string]$OutputPath
#     )

#     $secrets = @{
#         AppDisplayName = $AppDisplayName
#         ClientId       = $ApplicationID
#         Thumbprint     = $Thumbprint
#         TenantID       = $TenantID
#         CertPassword   = $CertPassword
#         CertName       = $CertName
#         TenantName     = $TenantName
#         OutputPath     = $OutputPath
#     }

#     $secrets | ConvertTo-Json | Set-Content -Path $SecretsFile

#     Write-Host "================ Secrets ================"
#     Write-Host "`$AppDisplayName    = $($AppDisplayName)"
#     Write-Host "`$ClientId          = $($ApplicationID)"
#     Write-Host "`$Thumbprint        = $($Thumbprint)"
#     Write-Host "`$TenantID          = $TenantID"
#     Write-Host "`$CertPassword      = $CertPassword"
#     Write-Host "`$CertName          = $CertName"
#     Write-Host "`$TenantName        = $TenantName"
#     Write-Host "`$OutputPath        = $OutputPath"
#     Write-Host "================ Secrets ================"
#     Write-Host "    SAVE THESE IN A SECURE LOCATION     "
# }

# # Example usage
# $params = @{
#     AppDisplayName = $app.DisplayName
#     ApplicationID  = $app.AppId
#     TenantID       = $tenantDetails.Id
#     SecretsFile    = $secretsfile
#     CertName       = $Certname
#     Thumbprint     = $thumbprint
#     CertPassword   = $CertPassword
#     TenantName     = $tenantDetails.DisplayName
#     OutputPath     = $certexportDirectory
# }

# Output-Secrets @params





# Output secrets to console and file
function Output-Secrets {
    param (
        [Parameter(Mandatory = $true)]
        [string]$AppDisplayName,
        
        [Parameter(Mandatory = $true)]
        [string]$ApplicationID,
        
        [Parameter(Mandatory = $true)]
        [string]$Thumbprint,
        
        [Parameter(Mandatory = $true)]
        [string]$TenantID,
        
        [Parameter(Mandatory = $true)]
        [string]$SecretsFile,
        
        [Parameter(Mandatory = $true)]
        [string]$CertPassword,
        
        [Parameter(Mandatory = $true)]
        [string]$CertName,
        
        [Parameter(Mandatory = $true)]
        [string]$TenantName,
        
        [Parameter(Mandatory = $true)]
        [string]$OutputPath
    )

    try {
        Write-EnhancedLog -Message "Starting to output secrets." -Level "INFO"
        
        $secrets = @{
            AppDisplayName = $AppDisplayName
            ClientId       = $ApplicationID
            Thumbprint     = $Thumbprint
            TenantID       = $TenantID
            CertPassword   = $CertPassword
            CertName       = $CertName
            TenantName     = $TenantName
            OutputPath     = $OutputPath
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
#     AppDisplayName = $app.DisplayName
#     ApplicationID  = $app.AppId
#     TenantID       = $tenantDetails.Id
#     SecretsFile    = $secretsfile
#     CertName       = $Certname
#     Thumbprint     = $thumbprint
#     CertPassword   = $CertPassword
#     TenantName     = $tenantDetails.DisplayName
#     OutputPath     = $certexportDirectory
# }

# Output-Secrets @params
