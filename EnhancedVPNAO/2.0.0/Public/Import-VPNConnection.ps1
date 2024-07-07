function Import-VPNConnection {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$ConnectionName
    )

    try {
        # Define the path to the VPN XML file
        $vpnXmlPath = Join-Path -Path $PSScriptRoot -ChildPath "vpn.xml"

        # Check if the VPN connection already exists
        if (Test-VPNConnection -ConnectionName $ConnectionName) {
            Write-EnhancedLog -Message "VPN connection '$ConnectionName' already exists. Import not required." -Level "WARNING"
            return
        }

        # Import the VPN connection from the XML file
        Add-VpnConnection -Name $ConnectionName -ServerAddress $serverAddress -AllUserConnection -SplitTunneling -RememberCredential -ProfileName $profileName -XmlFile $vpnXmlPath
        
        # Verify the VPN connection was created successfully
        if (Test-VPNConnection -ConnectionName $ConnectionName) {
            Write-EnhancedLog -Message "VPN connection '$ConnectionName' was successfully imported." -Level "INFO"
        } else {
            Write-EnhancedLog -Message "VPN connection '$ConnectionName' failed to import." -Level "ERROR"
        }
    }
    catch {
        Handle-Error -ErrorRecord $_
        Write-EnhancedLog -Message "An error occurred while importing VPN connection '$ConnectionName'." -Level "ERROR"
        throw $_
    }
}
