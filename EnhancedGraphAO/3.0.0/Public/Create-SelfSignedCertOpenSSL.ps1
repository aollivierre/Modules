# We'll create the following functions:

# Get-CurrentUser
# Generate-Certificate
# Convert-CertificateToPfx
# Import-PfxCertificateToStore
# Create-SelfSignedCertOpenSSL




function Get-CurrentUser {
    try {
        Write-EnhancedLog -Message "Fetching current user information from Microsoft Graph API." -Level "INFO"
        $currentUserResponse = Invoke-MgGraphRequest -Uri "https://graph.microsoft.com/v1.0/me" -Method GET
        Write-EnhancedLog -Message "Response from Microsoft Graph API: $($currentUserResponse | ConvertTo-Json -Compress)" -Level "DEBUG"
        return $currentUserResponse
    } catch {
        Write-EnhancedLog -Message "An error occurred while fetching the current user information." -Level "ERROR"
        Handle-Error -ErrorRecord $_
        throw $_
    }
}

function Convert-CertificateToPfx {
    param (
        [string]$CertKeyPath,
        [string]$CertCrtPath,
        [string]$PfxPath,
        [string]$PfxPassword
    )

    try {
        $opensslPfxCmd = "openssl pkcs12 -export -out `"$PfxPath`" -inkey `"$CertKeyPath`" -in `"$CertCrtPath`" -passout pass:$PfxPassword"
        Write-EnhancedLog -Message "Running OpenSSL command to convert certificate to PFX format: $opensslPfxCmd" -Level "INFO"

        $processInfo = New-Object System.Diagnostics.ProcessStartInfo
        $processInfo.FileName = "/bin/bash"
        $processInfo.Arguments = "-c `"$opensslPfxCmd`""
        $processInfo.RedirectStandardOutput = $true
        $processInfo.RedirectStandardError = $true
        $processInfo.UseShellExecute = $false
        $processInfo.CreateNoWindow = $true

        $process = New-Object System.Diagnostics.Process
        $process.StartInfo = $processInfo
        $process.Start() | Out-Null

        $stdout = $process.StandardOutput.ReadToEnd()
        $stderr = $process.StandardError.ReadToEnd()

        $process.WaitForExit()

        Write-EnhancedLog -Message "Standard Output: $stdout" -Level "DEBUG"
        Write-EnhancedLog -Message "Standard Error: $stderr" -Level "DEBUG"

        if ($process.ExitCode -ne 0) {
            Write-EnhancedLog -Message "OpenSSL PFX command failed with exit code $($process.ExitCode)" -Level "ERROR"
            throw "PFX file creation failed"
        }

        Write-EnhancedLog -Message "PFX file created successfully at $PfxPath" -Level "INFO"
    } catch {
        Write-EnhancedLog -Message "An error occurred while converting the certificate to PFX format." -Level "ERROR"
        Handle-Error -ErrorRecord $_
        throw $_
    }
}



function Import-PfxCertificateToStore {
    param (
        [string]$PfxPath,
        [string]$PfxPassword,
        [string]$CertStoreLocation
    )

    try {
        $securePfxPassword = ConvertTo-SecureString -String $PfxPassword -Force -AsPlainText
        $cert = Import-PfxCertificate -FilePath $PfxPath -Password $securePfxPassword -CertStoreLocation $CertStoreLocation
        Write-EnhancedLog -Message "Certificate imported successfully into store location $CertStoreLocation" -Level "INFO"
        return $cert
    } catch {
        Write-EnhancedLog -Message "An error occurred while importing the PFX certificate to the store." -Level "ERROR"
        Handle-Error -ErrorRecord $_
        throw $_
    }
}



function Create-DummyCertWithOpenSSL {
    param (
        # [string]$OutputDir = "/workspaces/cert"
        [string]$OutputDir
    )

    try {
        # Ensure the output directory exists
        if (-not (Test-Path -Path $OutputDir)) {
            New-Item -ItemType Directory -Path $OutputDir -Force | Out-Null
            Write-EnhancedLog -Message "Created output directory: $OutputDir" -Level "INFO"
        } else {
            Write-EnhancedLog -Message "Output directory already exists: $OutputDir" -Level "INFO"
        }

        # Define a simple command to run OpenSSL
        $opensslCmd = "openssl req -x509 -nodes -days 1 -newkey rsa:2048 -keyout $OutputDir/dummy.key -out $OutputDir/dummy.crt -subj '/CN=DummyCert/O=DummyOrg/C=US'"
        Write-EnhancedLog -Message "Running OpenSSL command: $opensslCmd" -Level "INFO"

        # Use Start-Process to execute the command
        $startInfo = New-Object System.Diagnostics.ProcessStartInfo
        $startInfo.FileName = "/bin/bash"
        $startInfo.Arguments = "-c `"$opensslCmd`""
        $startInfo.RedirectStandardOutput = $true
        $startInfo.RedirectStandardError = $true
        $startInfo.UseShellExecute = $false
        $startInfo.CreateNoWindow = $true

        $process = New-Object System.Diagnostics.Process
        $process.StartInfo = $startInfo
        $process.Start() | Out-Null

        # Capture the output
        $stdout = $process.StandardOutput.ReadToEnd()
        $stderr = $process.StandardError.ReadToEnd()

        $process.WaitForExit()

        # Output the results
        Write-EnhancedLog -Message "Standard Output: $stdout" -Level "INFO"
        Write-EnhancedLog -Message "Standard Error: $stderr" -Level "INFO"

        if ($process.ExitCode -ne 0) {
            Write-EnhancedLog -Message "OpenSSL command failed with exit code $($process.ExitCode)" -Level "ERROR"
            throw "Certificate creation failed"
        } else {
            Write-EnhancedLog -Message "Certificate created successfully using OpenSSL" -Level "INFO"
        }
    } catch {
        Write-EnhancedLog -Message "An error occurred while generating the certificate." -Level "ERROR"
        Handle-Error -ErrorRecord $_
        throw $_
    }
}

# # Test the function
# Create-DummyCertWithOpenSSL

# $DBG


function Create-SelfSignedCertOpenSSL {
    param (
        [string]$CertName,
        [string]$CertStoreLocation = "Cert:\CurrentUser\My",
        [string]$TenantName,
        [string]$AppId,
        [string]$OutputPath,
        [string]$PfxPassword
    )

    try {
        $currentUser = Get-CurrentUser

        # Create output directory if it doesn't exist
        if (-not (Test-Path -Path $OutputPath)) {
            New-Item -ItemType Directory -Path $OutputPath -Force | Out-Null
        }

        Write-EnhancedLog -Message "calling Run-GenerateCertificateScript" -Level "INFO"
        $DBG
        # $certPaths = Run-GenerateCertificateScript -CertName $CertName -TenantName $TenantName -AppId $AppId -OutputPath $OutputPath -CurrentUser $currentUser -RealCertName $CertName -RealTenantName $TenantName -RealAppId $AppId

        Create-DummyCertWithOpenSSL -OutputDir $OutputPath

        Write-EnhancedLog -Message "Done calling Run-GenerateCertificateScript" -Level "INFO"

        $DBG

        $pfxFilePath = Join-Path -Path $OutputPath -ChildPath "$CertName-$AppId.pfx"

        Convert-CertificateToPfx -CertKeyPath $certPaths.KeyPath -CertCrtPath $certPaths.CrtPath -PfxPath $pfxFilePath -PfxPassword $PfxPassword

        if ($PSVersionTable.OS -match "Windows") {
            try {
                $securePfxPassword = ConvertTo-SecureString -String $PfxPassword -Force -AsPlainText
                $cert = Import-PfxCertificateToStore -FilePath $pfxFilePath -Password $securePfxPassword -CertStoreLocation $CertStoreLocation
                Write-EnhancedLog -Message "Certificate imported successfully into store location $CertStoreLocation" -Level "INFO"
            } catch {
                Write-EnhancedLog -Message "An error occurred while importing the PFX certificate to the store." -Level "ERROR"
                Handle-Error -ErrorRecord $_
                throw $_
            }
        } else {
            Write-EnhancedLog -Message "Running on a non-Windows OS, skipping the import of the PFX certificate to the store." -Level "INFO"
            $cert = $null
        }

        return $cert
    } catch {
        Write-EnhancedLog -Message "An error occurred while creating the self-signed certificate." -Level "ERROR"
        Handle-Error -ErrorRecord $_
        throw $_
    }
}
