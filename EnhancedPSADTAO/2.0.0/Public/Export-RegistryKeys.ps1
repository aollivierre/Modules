function Export-RegistryKeys {
    [CmdletBinding()]
    param (
        [string]$ScriptDirectory,
        [string]$RegistryKeyPath
    )

    begin {
        Write-EnhancedLog -Message 'Starting Export-RegistryKeys function' -Level 'INFO'
        Log-Params -Params $PSCmdlet.MyInvocation.BoundParameters
    }

    process {
        try {
            if (-not (Test-Path $ScriptDirectory)) {
                Write-EnhancedLog -Message "Script directory not found: $ScriptDirectory" -Level 'ERROR'
                return
            }

            $timestamp = (Get-Date).ToString("yyyyMMddHHmmss")
            $exportFilePath = Join-Path -Path $ScriptDirectory -ChildPath "RegistryExport_$timestamp.reg"

            $arguments = "export `"$RegistryKeyPath`" `"$exportFilePath`" /y"
            $startProcessParams = @{
                FilePath = "reg.exe"
                ArgumentList = $arguments
                Wait = $true
            }

            Write-EnhancedLog -Message "Exporting registry key: $RegistryKeyPath to file: $exportFilePath" -Level 'INFO'
            
            Start-Process @startProcessParams

            if (Test-Path $exportFilePath) {
                Write-EnhancedLog -Message "Registry key export completed successfully: $exportFilePath" -Level 'INFO'
                
                # Validate the exported registry keys
                $validateParams = @{
                    RegistryFilePath = $exportFilePath
                }
                Validate-RegistryKeys @validateParams
            } else {
                Write-EnhancedLog -Message "Failed to export registry key: $RegistryKeyPath" -Level 'ERROR'
            }
        }
        catch {
            Handle-Error -ErrorRecord $_
        }
    }

    end {
        Write-EnhancedLog -Message 'Export-RegistryKeys function completed' -Level 'INFO'
    }
}

# # Usage Example with Splatting
# $scriptDirectory = "C:\Path\To\Your\Export\Directory"
# $params = @{
#     ScriptDirectory = $scriptDirectory
#     RegistryKeyPath = 'HKEY_LOCAL_MACHINE\SOFTWARE\Fortinet\FortiClient\Sslvpn\Tunnels'
# }
# Export-RegistryKeys @params
