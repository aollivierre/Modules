function Remove-ExistingServiceUI {
    [CmdletBinding()]
    param(
        [string]$TargetFolder,
        [string]$FileName
    )

    begin {
        Write-EnhancedLog -Message "Starting Remove-ExistingServiceUI function" -Level "INFO"
        Log-Params -Params $PSCmdlet.MyInvocation.BoundParameters
    }

    process {
        # Full path for ServiceUI.exe
        $serviceUIPathParams = @{
            Path = $TargetFolder
            ChildPath = $FileName
        }
        $ServiceUIPath = Join-Path @serviceUIPathParams

        try {
            # Check if ServiceUI.exe exists
            $testPathParams = @{
                Path = $ServiceUIPath
            }
            if (Test-Path @testPathParams) {
                Write-EnhancedLog -Message "Removing existing ServiceUI.exe from: $TargetFolder" -Level "INFO"

                # Remove ServiceUI.exe
                $removeItemParams = @{
                    Path = $ServiceUIPath
                    Force = $true
                }
                Remove-Item @removeItemParams

                Write-Output "ServiceUI.exe has been removed from: $TargetFolder"
            }
            else {
                Write-EnhancedLog -Message "No ServiceUI.exe file found in: $TargetFolder" -Level "INFO"
            }
        }
        catch {
            # Handle any errors during the removal
            Write-Error "An error occurred while trying to remove ServiceUI.exe: $_"
            Write-EnhancedLog -Message "An error occurred while trying to remove ServiceUI.exe: $_" -Level "ERROR"
            Handle-Error -ErrorRecord $_
        }
    }

    end {
        Write-EnhancedLog -Message "Remove-ExistingServiceUI function execution completed." -Level "INFO"
    }
}

# # Example usage of Remove-ExistingServiceUI function with splatting
# $params = @{
#     TargetFolder = "C:\Path\To\Your\Desired\Folder",
#     FileName = "ServiceUI.exe"
# }
# Remove-ExistingServiceUI @params
