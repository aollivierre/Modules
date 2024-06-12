function Test-VPNConnection {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$ConnectionName
    )

    try {
        # Check if the VPN connection exists
        $vpnConnection = Get-VpnConnection -Name $ConnectionName -ErrorAction SilentlyContinue
        if ($vpnConnection) {
            Write-EnhancedLog -Message "VPN connection '$ConnectionName' exists." -Level "INFO" -ForegroundColor ([ConsoleColor]::Green)
            return $true
        } else {
            Write-EnhancedLog -Message "VPN connection '$ConnectionName' does not exist." -Level "INFO" -ForegroundColor ([ConsoleColor]::Yellow)
            return $false
        }
    }
    catch {
        Write-EnhancedLog -Message "An error occurred while checking VPN connection '$ConnectionName': $_" -Level "ERROR" -ForegroundColor ([ConsoleColor]::Red)
        throw $_
    }
}
