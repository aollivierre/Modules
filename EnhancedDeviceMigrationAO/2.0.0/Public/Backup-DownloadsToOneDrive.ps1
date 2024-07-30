function Backup-DownloadsToOneDrive {
    [CmdletBinding()]
    param ()

    Begin {
        Write-EnhancedLog -Message "Starting Backup-DownloadsToOneDrive function" -Level "INFO"
    }

    Process {
        try {
            # Define full-name variables and check for OneDrive directory existence
            $oneDriveDirectory = (Get-ChildItem -Path "$env:USERPROFILE" -Filter "OneDrive - *" -Directory).FullName

            # Exit with an error if the OneDrive directory does not exist
            if (-not $oneDriveDirectory) {
                Throw "OneDrive directory not found. Please ensure OneDrive is set up correctly."
            }

            $downloadsPath = "$env:USERPROFILE\Downloads"
            $backupPath = Join-Path -Path $oneDriveDirectory -ChildPath "DownloadsBackup"

            # Use splatting for function parameters
            $params = @{
                SourcePath      = $downloadsPath + "\"
                DestinationPath = $backupPath
            }

            # Execute the function with splatting
            Copy-ItemsWithRobocopy @params

            Write-EnhancedLog -Message "Backup of Downloads to OneDrive completed successfully." -Level "INFO"
        }
        catch {
            Write-EnhancedLog -Message "An error occurred in Backup-DownloadsToOneDrive function: $($_.Exception.Message)" -Level "ERROR"
            Handle-Error -ErrorRecord $_
        }
    }

    End {
        Write-EnhancedLog -Message "Exiting Backup-DownloadsToOneDrive function" -Level "INFO"
    }
}

# Example usage
# Backup-DownloadsToOneDrive
