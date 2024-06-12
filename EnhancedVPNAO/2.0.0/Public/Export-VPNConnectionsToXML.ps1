function Export-VPNConnectionsToXML {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$ExportFolder
    )

    # Get the list of current VPN connections
    $vpnConnections = Get-VpnConnection

    # Check if there are no VPN connections
    if ($vpnConnections.Count -eq 0) {
        Write-EnhancedLog -Message "NO VPN connections found." -Level "WARNING" -ForegroundColor ([ConsoleColor]::Yellow)
        return
    }

    # Generate a timestamp for the export
    $timestamp = Get-Date -Format "yyyyMMddHHmmss"
    $baseOutputPath = Join-Path -Path $ExportFolder -ChildPath "VPNExport_$timestamp"

    # Setup parameters for Export-Data using splatting
    $exportParams = @{
        Data             = $vpnConnections
        BaseOutputPath   = $baseOutputPath
        IncludeCSV       = $true
        IncludeJSON      = $true
        IncludeXML       = $true
        # IncludeHTML      = $true
        IncludePlainText = $true
        IncludeExcel     = $true
        IncludeYAML      = $true
        # IncludeGridView  = $true  # Note: GridView displays data but doesn't export/save it
    }

    # Call the Export-Data function with splatted parameters
    Export-Data @exportParams
    Write-EnhancedLog -Message "Data export completed successfully." -Level "INFO" -ForegroundColor ([ConsoleColor]::Green)
}