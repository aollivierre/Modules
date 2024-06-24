function Install-SecretManagementKeePassModule {
    if (-not (Get-Module -ListAvailable -Name "SecretManagement.KeePass")) {
        Install-Module -Name "SecretManagement.KeePass" -Scope CurrentUser -Force
    }
    Import-Module "SecretManagement.KeePass" -ErrorAction Stop
}

function Create-KeePassDatabase2 {
    param (
        [string]$databaseKdbxPath,
        [securestring]$masterPassword
    )
    
    try {
        Write-Host "Creating new KeePass database at $databaseKdbxPath" -ForegroundColor Cyan
        # Assuming a different method to create the database since New-KeePassDatabase is not found
        # We might need to use KeePass CLI or other mechanisms here
        & "keepassxc-cli" database-create -p $masterPassword -o $databaseKdbxPath
        Write-Host "KeePass database created successfully." -ForegroundColor Green
    } catch {
        Write-Host "Failed to create KeePass database: $_" -ForegroundColor Red
    }
}

# Example usage
$databaseKdbxPath = "C:\Code\Modules\EnhancedAO.Secrets\Secrets\Database.kdbx"
$masterPassword = ConvertTo-SecureString -String "YourMasterPassword" -AsPlainText -Force

Install-SecretManagementKeePassModule
Create-KeePassDatabase2 -databaseKdbxPath $databaseKdbxPath -masterPassword $masterPassword
