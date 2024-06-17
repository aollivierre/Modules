function Add-Result {
    param (
        [Parameter(Mandatory = $true)]
        [ProcessingContext]$Context,
        [Parameter(Mandatory = $true)]
        [SignInLog]$Item,
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

        # Determine the compliance status
        $complianceStatus = if ($Item.deviceDetail.isCompliant) { "Compliant" } else { "Non-Compliant" }

        # Determine the user license
        $userLicense = if ($HasPremiumLicense) { "Microsoft 365 Business Premium" } else { "Other" }

        # Create a new Result object
        $result = [Result]::new(
            $deviceName,
            $Item.userDisplayName,
            $DeviceId,
            $Item.userId,
            $Item.deviceDetail.operatingSystem,
            $complianceStatus,
            $DeviceState,
            $Item.deviceDetail.trustType,
            $userLicense
        )

        # Add the result to the context
        $Context.Results.Add($result)

        Write-EnhancedLog -Message "Successfully added result for device: $deviceName for user: $($Item.userDisplayName)" -Level "INFO" -ForegroundColor ([ConsoleColor]::Green)
    } catch {
        Handle-Error -ErrorRecord $_
        Write-EnhancedLog -Message "Failed to add result for device: $($Item.deviceDetail.displayName)" -Level "ERROR" -ForegroundColor ([ConsoleColor]::Red)
    }
}