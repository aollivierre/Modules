function Connect-GraphWithCert {
    param (
        [Parameter(Mandatory = $true)]
        [string]$tenantId,
        [Parameter(Mandatory = $true)]
        [string]$clientId,
        [Parameter(Mandatory = $true)]
        [string]$certPath,
        [Parameter(Mandatory = $true)]
        [string]$certPassword
    )

    # Log the certificate path
    Log-Params -Params @{certPath = $certPath}

    # Load the certificate from the PFX file
    $cert = [System.Security.Cryptography.X509Certificates.X509Certificate2]::new($certPath, $certPassword)

    # Define the splat for Connect-MgGraph
    $GraphParams = @{
        ClientId    = $clientId
        TenantId    = $tenantId
        Certificate = $cert
    }

    # Log the parameters
    Log-Params -Params $GraphParams

    # Obtain access token (if needed separately)
    $accessToken = Get-MsGraphAccessTokenCert -tenantId $tenantId -clientId $clientId -certPath $certPath -certPassword $certPassword
    Log-Params -Params @{accessToken = $accessToken}

    # Connect to Microsoft Graph
    Write-EnhancedLog -message 'Calling Connect-MgGraph with client certificate file path and password' -Level 'INFO' -ForegroundColor ([ConsoleColor]::Green)
    Connect-MgGraph @GraphParams -NoWelcome

    # # Example command after connection (optional)
    # $organization = Get-MgOrganization
    # Write-Output $organization





    
  # # Graph Connect 

        # Define the parameters for non-interactive connection

        $IntuneGraphconnectionParams = @{
            clientId     = $clientId
            tenantID     = $tenantId
            # ClientSecret = $secrets.ClientSecret
            Clientcert = $cert
        }

    # Call the Connect-MSIntuneGraph function with splatted parameters
    Write-EnhancedLog -Message "calling Connect-MSIntuneGraph with connectionParams " -Level "WARNING" -ForegroundColor ([ConsoleColor]::Yellow)

    $Session = Connect-MSIntuneGraph @IntuneGraphconnectionParams

    Write-EnhancedLog -Message "connecting to Graph using Connect-MSIntuneGraph - done" -Level "INFO" -ForegroundColor ([ConsoleColor]::Green)



    return $accessToken
}

# # Example usage
# $clientId = '8230c33e-ff30-419c-a1fc-4caf98f069c9'
# $tenantId = 'b5dae566-ad8f-44e1-9929-5669f1dbb343'
# $certPath = Join-Path -Path $PSScriptRoot -ChildPath 'graphcert.pfx'
# $certPassword = "somepassword"

# Connect-GraphWithCert -tenantId $tenantId -clientId $clientId -certPath $certPath -certPassword $certPassword
