function Update-ApplicationPermissions {
    param (
        [string]$appId,
        [string]$permissionsFile
    )

    $resourceAppId = "00000003-0000-0000-c000-000000000000"  # Microsoft Graph

    # Load permissions from the JSON file
    if (Test-Path -Path $permissionsFile) {
        $permissions = Get-Content -Path $permissionsFile | ConvertFrom-Json
    }
    else {
        Write-EnhancedLog -Message "Permissions file not found: $permissionsFile" -Level "ERROR"
        throw "Permissions file not found: $permissionsFile"
    }

    # Retrieve the existing application (optional, uncomment if needed)
    # $app = Get-MgApplication -ApplicationId $appId

    # Prepare the required resource access
    $requiredResourceAccess = @(
        @{
            ResourceAppId = $resourceAppId
            ResourceAccess = $permissions
        }
    )

    # Update the application
    try {
        Update-MgApplication -ApplicationId $appId -RequiredResourceAccess $requiredResourceAccess
        Write-EnhancedLog -Message "Successfully updated application permissions for appId: $appId" -Level "INFO"
    }
    catch {
        Write-EnhancedLog -Message "Failed to update application permissions for appId: $appId. Error: $_" -Level "ERROR"
        throw $_
    }
}
