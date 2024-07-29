function Import-CertificateIfNotExist {
    param (
        [Parameter(Mandatory = $true)]
        [string]$CertPath,
        
        [Parameter(Mandatory = $true)]
        [string]$CertPassword
    )

    try {
        Write-EnhancedLog -Message "Starting certificate import process." -Level "INFO"
        
        # Load the PFX file using the constructor
        $securePassword = ConvertTo-SecureString -String $CertPassword -AsPlainText -Force
        $cert = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2($CertPath, $securePassword, [System.Security.Cryptography.X509Certificates.X509KeyStorageFlags]::PersistKeySet)

        # Check if the certificate already exists in the local machine store
        $store = New-Object System.Security.Cryptography.X509Certificates.X509Store("My", "LocalMachine")
        $store.Open([System.Security.Cryptography.X509Certificates.OpenFlags]::ReadOnly)
        $existingCert = $store.Certificates | Where-Object { $_.Thumbprint -eq $cert.Thumbprint }
        $store.Close()

        if ($existingCert) {
            Write-EnhancedLog -Message "Certificate already exists in the local machine store." -Level "INFO"
        } else {
            Write-EnhancedLog -Message "Certificate does not exist in the local machine store. Importing certificate..." -Level "INFO"

            # Open the store with write access and add the certificate
            $store.Open([System.Security.Cryptography.X509Certificates.OpenFlags]::ReadWrite)
            $store.Add($cert)
            $store.Close()

            Write-EnhancedLog -Message "Certificate imported successfully." -Level "INFO"
        }
    } catch {
        Write-EnhancedLog -Message "An error occurred during the certificate import process." -Level "ERROR"
        Handle-Error -ErrorRecord $_
        throw $_
    }
}

# Example usage
# $params = @{
#     CertPath     = "C:\Path\To\Your\Certificate.pfx"
#     CertPassword = "YourPfxPassword"
# }

# Import-CertificateIfNotExist @params
