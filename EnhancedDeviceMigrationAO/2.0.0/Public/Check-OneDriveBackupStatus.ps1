function Check-OneDriveBackupStatus {
    [CmdletBinding()]
    param ()

    Begin {
        Write-EnhancedLog -Message "Starting Check-OneDriveBackupStatus function" -Level "INFO"
    }

    Process {
        try {
            # Attempt to find the OneDrive directory
            $oneDriveDirectory = (Get-ChildItem "$env:USERPROFILE" -Filter "OneDrive - *" -Directory).FullName

            # Check if the OneDrive directory exists
            if (-not $oneDriveDirectory) {
                Write-EnhancedLog -Message "OneDrive directory does not exist. Remediation is not possible for now." -Level "WARNING"
                exit 0
            }

            # Define the backup path within the OneDrive directory
            $backupPath = Join-Path $oneDriveDirectory "DownloadsBackup"

            # Check if the DownloadsBackup folder exists and contains files
            if (Test-Path $backupPath) {
                $fileCount = (Get-ChildItem -Path $backupPath -Recurse -File).Count
                if ($fileCount -gt 0) {
                    Write-EnhancedLog -Message "DownloadsBackup folder detected with files at $backupPath. Remediation needed." -Level "WARNING"
                    exit 1
                } else {
                    Write-EnhancedLog -Message "DownloadsBackup folder exists at $backupPath but is empty. Remediation needed." -Level "WARNING"
                    exit 1
                }
            } else {
                Write-EnhancedLog -Message "DownloadsBackup folder does not exist at $backupPath. Remediation needed." -Level "WARNING"
                exit 1
            }
        }
        catch {
            Write-EnhancedLog -Message "An error occurred in Check-OneDriveBackupStatus function: $($_.Exception.Message)" -Level "ERROR"
            Handle-Error -ErrorRecord $_
        }
    }

    End {
        Write-EnhancedLog -Message "Exiting Check-OneDriveBackupStatus function" -Level "INFO"
    }
}

# Example usage
# Check-OneDriveBackupStatus
