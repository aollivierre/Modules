# Output secrets to console and file
function Output-Secrets {
    param (
        [string]$AppDisplayName,
        [string]$ApplicationID,
        [string]$Thumbprint,
        [string]$TenantID,
        [string]$SecretsFile = "$PSScriptRoot/secrets.json"
    )

    $secrets = @{
        AppDisplayName         = $AppDisplayName
        ApplicationID_ClientID = $ApplicationID
        Thumbprint             = $Thumbprint
        TenantID               = $TenantID
    }

    $secrets | ConvertTo-Json | Set-Content -Path $SecretsFile

    Write-Host "================ Secrets ================"
    Write-Host "`$AppDisplayName        = $($AppDisplayName)"
    Write-Host "`$ApplicationID_ClientID          = $($ApplicationID)"
    Write-Host "`$Thumbprint     = $($Thumbprint)"
    Write-Host "`$TenantID        = $TenantID"
    Write-Host "================ Secrets ================"
    Write-Host "    SAVE THESE IN A SECURE LOCATION     "
}