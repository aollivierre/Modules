# Ensure the KeePass PowerShell module is installed
# If not installed, uncomment the next line to install it:
Install-Module -Name PoShKeePass -Force

# Import the KeePass module
Import-Module PoShKeePass

# Set the path for the KeePass database
$dbPath = "C:\code\secrets\dummy_secrets.kdbx"

# Create the directory if it doesn't exist
New-Item -ItemType Directory -Force -Path (Split-Path -Path $dbPath)

# Set a master password for the database
$masterPassword = ConvertTo-SecureString "your_master_password_here" -AsPlainText -Force

# Create a new KeePass database
New-KeePassDatabase -DatabasePath $dbPath -MasterKey $masterPassword

# Add a dummy secret
$entryParams = @{
    DatabasePath = $dbPath
    MasterKey    = $masterPassword
    Title        = "Dummy Secret"
    UserName     = "dummy_user"
    KeePassPassword = (ConvertTo-SecureString "dummy_password" -AsPlainText -Force)
}
New-KeePassEntry @entryParams

Write-Host "KeePass database created and saved at: $dbPath"