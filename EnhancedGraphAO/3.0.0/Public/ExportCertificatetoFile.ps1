    # Define the function
    function ExportCertificatetoFile {
        param (
            [Parameter(Mandatory = $true)]
            [string]$CertThumbprint,

            [Parameter(Mandatory = $true)]
            [string]$ExportDirectory
        )

        try {
            # Get the certificate from the current user's personal store
            $cert = Get-Item -Path "Cert:\CurrentUser\My\$CertThumbprint"
        
            # Ensure the export directory exists
            if (-not (Test-Path -Path $ExportDirectory)) {
                New-Item -ItemType Directory -Path $ExportDirectory -Force
            }

            # Dynamically create a file name using the certificate subject name and current timestamp
            $timestamp = (Get-Date).ToString("yyyyMMddHHmmss")
            $subjectName = $cert.SubjectName.Name -replace "[^a-zA-Z0-9]", "_"
            $fileName = "${subjectName}_$timestamp"

            # Set the export file path
            $certPath = Join-Path -Path $ExportDirectory -ChildPath "$fileName.cer"
        
            # Export the certificate to a file (DER encoded binary format with .cer extension)
            $cert | Export-Certificate -FilePath $certPath -Type CERT -Force | Out-Null

            # Output the export file path
            Write-EnhancedLog -Message "Certificate exported to: $certPath"

            # Return the export file path
            return $certPath
        }
        catch {
            Write-Host "Failed to export certificate: $_" -ForegroundColor Red
        }
    }