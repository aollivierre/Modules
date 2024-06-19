# function Create-SelfSignedCert {
#     param (
#         [string]$CertName,
#         [string]$CertStoreLocation = "Cert:\CurrentUser\My",
#         [string]$TenantName,
#         [string]$AppId
#     )

#     $cert = New-SelfSignedCertificate -CertStoreLocation $CertStoreLocation `
#         -Subject "CN=$CertName, O=$TenantName, OU=$AppId" `
#         -KeyLength 2048 `
#         -NotAfter (Get-Date).AddDays(30)

#     if ($null -eq $cert) {
#         Write-EnhancedLog -Message "Failed to create certificate" -Level "ERROR" -ForegroundColor ([ConsoleColor]::Red)
#         throw "Certificate creation failed"
#     }
#     Write-EnhancedLog -Message "Certificate created successfully" -Level "INFO" -ForegroundColor ([ConsoleColor]::Cyan)
#     return $cert
# }







# function Create-SelfSignedCert {
#     param (
#         [string]$CertName,
#         [string]$CertStoreLocation = "Cert:\CurrentUser\My",
#         [string]$TenantName,
#         [string]$AppId,
#         # [string]$OutputPath = "C:\Certificates",
#         [string]$OutputPath,
#         # [string]$PfxPassword = "YourPfxPassword"
#         [string]$PfxPassword
#     )

#     try {
#         # Create output directory if it doesn't exist
#         if (-not (Test-Path -Path $OutputPath)) {
#             New-Item -ItemType Directory -Path $OutputPath
#         }

#         # Define certificate subject details
#         $subject = "CN=$CertName, O=$TenantName, OU=$AppId, L=City, S=State, C=US"

#         # Generate the self-signed certificate
#         $cert = New-SelfSignedCertificate -CertStoreLocation $CertStoreLocation `
#             -Subject $subject `
#             -KeyLength 2048 `
#             -KeyExportPolicy Exportable `
#             -NotAfter (Get-Date).AddDays(30) `
#             -KeyUsage DigitalSignature, KeyEncipherment `
#             -FriendlyName "$CertName for $TenantName"

#         if ($null -eq $cert) {
#             Write-EnhancedLog -Message "Failed to create certificate" -Level "ERROR"
#             throw "Certificate creation failed"
#         }

#         Write-EnhancedLog -Message "Certificate created successfully" -Level "INFO"

#         # Convert password to secure string
#         $securePfxPassword = ConvertTo-SecureString -String $PfxPassword -Force -AsPlainText

#         # Export the certificate to a PFX file
#         $pfxFilePath = Join-Path -Path $OutputPath -ChildPath "$CertName-$TenantName-$AppId.pfx"
#         Export-PfxCertificate -Cert $cert -FilePath $pfxFilePath -Password $securePfxPassword

#         Write-EnhancedLog -Message "PFX file created successfully at $pfxFilePath" -Level "INFO"

#         # Export the private key
#         $privateKeyFilePath = Join-Path -Path $OutputPath -ChildPath "$CertName-$TenantName-$AppId.key"
#         $privateKey = $cert.PrivateKey
#         $privateKeyBytes = [System.Convert]::ToBase64String($privateKey.ExportCspBlob($true))
#         Set-Content -Path $privateKeyFilePath -Value $privateKeyBytes

#         Write-EnhancedLog -Message "Private key file created successfully at $privateKeyFilePath" -Level "INFO"

#         return $cert

#     } catch {
#         Write-EnhancedLog -Message "An error occurred while creating the self-signed certificate" -Level "ERROR"
#         Handle-Error -ErrorRecord $_ 
#         throw $_
#     }
# }

# Example usage
# $cert = Create-SelfSignedCert -CertName "GraphCert" -TenantName "YourTenantName" -AppId "YourAppId" -OutputPath $OutputPath















function Create-SelfSignedCert {
    param (
        [string]$CertName,
        [string]$CertStoreLocation = "Cert:\CurrentUser\My",
        [string]$TenantName,
        [string]$AppId,
        [string]$OutputPath,
        [string]$PfxPassword
    )

    try {
        # Create output directory if it doesn't exist
        if (-not (Test-Path -Path $OutputPath)) {
            New-Item -ItemType Directory -Path $OutputPath -Force
        }

        # Define certificate subject details
        $subject = "CN=$CertName, O=$TenantName, OU=$AppId, L=City, S=State, C=US"

        # Generate the self-signed certificate
        $cert = New-SelfSignedCertificate -CertStoreLocation $CertStoreLocation `
            -Subject $subject `
            -KeyLength 2048 `
            -KeyExportPolicy Exportable `
            -NotAfter (Get-Date).AddDays(30) `
            -KeyUsage DigitalSignature, KeyEncipherment `
            -FriendlyName "$CertName for $TenantName"

        if ($null -eq $cert) {
            Write-EnhancedLog -Message "Failed to create certificate" -Level "ERROR"
            throw "Certificate creation failed"
        }

        Write-EnhancedLog -Message "Certificate created successfully" -Level "INFO"

        # Convert password to secure string
        $securePfxPassword = ConvertTo-SecureString -String $PfxPassword -Force -AsPlainText

        # Export the certificate to a PFX file
        $pfxFilePath = Join-Path -Path $OutputPath -ChildPath "$CertName-$TenantName-$AppId.pfx"
        Export-PfxCertificate -Cert $cert -FilePath $pfxFilePath -Password $securePfxPassword

        Write-EnhancedLog -Message "PFX file created successfully at $pfxFilePath" -Level "INFO"

        # Export the private key
        $privateKeyFilePath = Join-Path -Path $OutputPath -ChildPath "$CertName-$TenantName-$AppId.key"
        $privateKey = $cert.PrivateKey

        $rsaParameters = $privateKey.ExportParameters($true)
        $privateKeyPem = Convert-RsaParametersToPem -rsaParameters $rsaParameters
        Set-Content -Path $privateKeyFilePath -Value $privateKeyPem

        Write-EnhancedLog -Message "Private key file created successfully at $privateKeyFilePath" -Level "INFO"

        return $cert

    } catch {
        Write-EnhancedLog -Message "An error occurred while creating the self-signed certificate" -Level "ERROR"
        Handle-Error -ErrorRecord $_ 
        throw $_
    }
}



# # Example usage
# $certParams = @{
#     CertName   = "GraphCert"
#     TenantName = "YourTenantName"
#     AppId      = "YourAppId"
#     OutputPath = "C:\Certificates"
#     PfxPassword = "YourPfxPassword"
# }
# $cert = Create-SelfSignedCert @certParams
