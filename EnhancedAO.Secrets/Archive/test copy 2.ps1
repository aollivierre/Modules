# Ensure the KeePass PowerShell module is installed
# If not installed, uncomment the next line to install it:
# Install-Module -Name PoShKeePass -Force

# Import the KeePass module
Import-Module PoShKeePass

# Set the path for the KeePass database
$dbPath = "C:\code\secrets\dummy_secrets.kdbx"

# Create the directory if it doesn't exist
New-Item -ItemType Directory -Force -Path (Split-Path -Path $dbPath)

# Set a master password for the database
$masterPassword = "your_master_password_here"

# Create a new KeePass database
New-KeePassDatabase -DatabasePath $dbPath -MasterKey $masterPassword

# Add a dummy secret
$entryParams = @{
    KeePassEntryGroupPath = 'database'
    DatabaseProfileName   = 'dummy_profile'
    Title                 = "Dummy Secret"
    UserName              = "dummy_user"
    KeePassPassword       = "dummy_password"
}
New-KeePassEntry @entryParams

Write-Host "KeePass database created and saved at: $dbPath"






# Create a database profile
$profileParams = @{
    DatabaseProfileName = 'dummy_profile'
    DatabasePath        = $dbPath
    MasterKey           = $masterPassword
}
New-KeePassDatabaseConfiguration @profileParams