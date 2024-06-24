function Install-PoShKeePassModule {
    if (-not (Get-Module -ListAvailable -Name PoShKeePass)) {
        Install-Module -Name PoShKeePass -Scope CurrentUser -Force
    }
    Import-Module PoShKeePass -ErrorAction Stop
}

function Create-KeePassDatabase1 {
    param (
        [string]$databaseKdbxPath,
        [securestring]$masterPassword
    )
    
    try {
        Write-Host "Creating new KeePass database at $databaseKdbxPath" -ForegroundColor Cyan
        New-KeePassDatabase -DatabaseFilePath $databaseKdbxPath -MasterPassword $masterPassword
        Write-Host "KeePass database created successfully." -ForegroundColor Green
    } catch {
        Write-Host "Failed to create KeePass database: $_" -ForegroundColor Red
    }
}

# Example usage
$databaseKdbxPath = "C:\Code\Modules\EnhancedAO.Secrets\Secrets\Database.kdbx"
$masterPassword = ConvertTo-SecureString -String "YourMasterPassword" -AsPlainText -Force

Install-PoShKeePassModule
Create-KeePassDatabase1 -databaseKdbxPath $databaseKdbxPath -masterPassword $masterPassword
