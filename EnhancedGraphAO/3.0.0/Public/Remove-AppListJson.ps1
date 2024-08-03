function Remove-AppListJson {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$JsonPath
    )

    begin {
        Write-EnhancedLog -Message "Starting Remove-AppListJson function" -Level "INFO"
        Log-Params -Params $PSCmdlet.MyInvocation.BoundParameters
    }

    process {
        try {
            # Check if the file exists
            if (Test-Path -Path $JsonPath) {
                # Remove the file
                $removeParams = @{
                    Path  = $JsonPath
                    Force = $true
                }
                Remove-Item @removeParams
                Write-EnhancedLog -Message "The applist.json file has been removed successfully." -Level "INFO"
            }
            else {
                Write-EnhancedLog -Message "The file at path '$JsonPath' does not exist." -Level "WARNING"
            }
        }
        catch {
            Write-EnhancedLog -Message "An error occurred while removing the file: $_" -Level "ERROR"
            Handle-Error -ErrorRecord $_
            throw $_
        }
    }

    end {
        Write-EnhancedLog -Message "Remove-AppListJson function execution completed." -Level "INFO"
    }
}

# Example usage
# Remove-AppListJson -JsonPath "C:\Path\To\Your\applist.json"
