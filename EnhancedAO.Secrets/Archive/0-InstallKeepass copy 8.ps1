function Create-KeePassDatabaseManually {
    param (
        [string]$databaseKdbxPath,
        [securestring]$masterPassword
    )
    
    try {
        Write-Host "Creating directory for KeePass database if it does not exist." -ForegroundColor Cyan
        $directoryPath = Split-Path -Parent $databaseKdbxPath
        if (-not (Test-Path -Path $directoryPath)) {
            New-Item -Path $directoryPath -ItemType Directory | Out-Null
        }

        Write-Host "Creating KeePass database at $databaseKdbxPath" -ForegroundColor Cyan
        # Assuming the use of KeePass CLI to create the database
        & "keepassxc-cli" database-create -p $masterPassword -o $databaseKdbxPath
        Write-Host "KeePass database created successfully." -ForegroundColor Green
    } catch {
        Write-Host "Failed to create KeePass database: $_" -ForegroundColor Red
    }
}

# Example usage
$databaseKdbxPath = "C:\Code\Modules\EnhancedAO.Secrets\Secrets\Database.kdbx"
$masterPassword = ConvertTo-SecureString -String "YourMasterPassword" -AsPlainText -Force

Create-KeePassDatabaseManually -databaseKdbxPath $databaseKdbxPath -masterPassword $masterPassword
