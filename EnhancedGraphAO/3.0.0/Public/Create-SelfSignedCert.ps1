function Create-SelfSignedCert {
    param (
        [string]$CertName,
        [string]$CertStoreLocation = "Cert:\CurrentUser\My",
        [string]$TenantName,
        [string]$AppId
    )

    $cert = New-SelfSignedCertificate -CertStoreLocation $CertStoreLocation `
        -Subject "CN=$CertName, O=$TenantName, OU=$AppId" `
        -KeyLength 2048 `
        -NotAfter (Get-Date).AddDays(30)

    if ($null -eq $cert) {
        Write-EnhancedLog -Message "Failed to create certificate" -Level "ERROR" -ForegroundColor ([ConsoleColor]::Red)
        throw "Certificate creation failed"
    }
    Write-EnhancedLog -Message "Certificate created successfully" -Level "INFO" -ForegroundColor ([ConsoleColor]::Cyan)
    return $cert
}