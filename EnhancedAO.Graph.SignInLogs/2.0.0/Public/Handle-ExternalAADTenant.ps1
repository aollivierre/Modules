function Handle-ExternalAADTenant {
    param (
        [Parameter(Mandatory = $true)]
        [PSCustomObject]$Item,
        [Parameter(Mandatory = $true)]
        [PSCustomObject]$Context,
        [string]$UniqueId
    )

    if ([string]::Equals($Item.deviceDetail.deviceId, "{PII Removed}", [System.StringComparison]::OrdinalIgnoreCase)) {
        if ($Context.UniqueDeviceIds.Add($UniqueId)) {
            Write-EnhancedLog -Message "External Azure AD tenant detected for user: $($Item.userDisplayName)" -Level "INFO"
            Add-Result -Context $Context -Item $Item -DeviceId "N/A" -DeviceState "External" -HasPremiumLicense $false -OSVersion $null
        }
        return $true
    }
    return $false
}