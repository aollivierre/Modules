# Function to add result to the context
function Add-Result {
    param (
        [Parameter(Mandatory = $true)]
        [hashtable]$Context,
        [Parameter(Mandatory = $true)]
        [PSCustomObject]$Item,
        [Parameter(Mandatory = $true)]
        [string]$DeviceId,
        [Parameter(Mandatory = $true)]
        [string]$DeviceState,
        [Parameter(Mandatory = $true)]
        [bool]$HasPremiumLicense
    )

    try {
        $deviceName = $Item.deviceDetail.displayName
        if ([string]::IsNullOrWhiteSpace($deviceName)) {
            $deviceName = "BYOD"
        }

        $Context.Results.Add([PSCustomObject]@{
            'DeviceName'             = $deviceName
            'UserName'               = $Item.userDisplayName
            'DeviceEntraID'          = $DeviceId
            'UserEntraID'            = $Item.userId
            'DeviceOS'               = $Item.deviceDetail.operatingSystem
            'DeviceComplianceStatus' = if ($Item.deviceDetail.isCompliant) { "Compliant" } else { "Non-Compliant" }
            'DeviceStateInIntune'    = $DeviceState
            'TrustType'              = $Item.deviceDetail.trustType
            'UserLicense'            = if ($HasPremiumLicense) { "Microsoft 365 Business Premium" } else { "Other" }
        })

        # Write-EnhancedLog -Message "Successfully added result for device: $deviceName for user: $($Item.userDisplayName)" -Level "INFO" -ForegroundColor ([ConsoleColor]::Green)
    } catch {
        Handle-Error -ErrorRecord $_
        Write-EnhancedLog -Message "Failed to add result for device: $($Item.deviceDetail.displayName)" -Level "ERROR" -ForegroundColor ([ConsoleColor]::Red)
    }
}