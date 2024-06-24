Install-Module -Name PoShKeePass -Scope CurrentUser

Import-Module PoShKeePass

# Define the path to the KeePass database and the master password
$databasePath = "C:\code\secrets\myDatabase.kdbx"
$masterPassword = ConvertTo-SecureString "YourMasterPassword" -AsPlainText -Force
$entryTitle = "Dummy Secret"
$username = "dummyUser"
$password = ConvertTo-SecureString "dummyPassword" -AsPlainText -Force
$url = "http://dummy-url.com"
$notes = "This is a dummy secret entry."

# Create a new KeePass database if it doesn't exist
if (-not (Test-Path -Path $databasePath)) {
    Write-Output "Creating new KeePass database at $databasePath"
    New-KeePassDatabase -DatabaseFilePath $databasePath -MasterPassword $masterPassword
}

# Open the KeePass database
$database = Open-KeePassDatabase -DatabaseFilePath $databasePath -MasterPassword $masterPassword

# Create a new KeePass entry
$entry = New-Object KeePassLib.PwEntry
$entry.Strings.Set("Title", [KeePassLib.Security.ProtectedString]::ReadOnlyUtf8($entryTitle))
$entry.Strings.Set("UserName", [KeePassLib.Security.ProtectedString]::ReadOnlyUtf8($username))
$entry.Strings.Set("Password", $password)
$entry.Strings.Set("URL", [KeePassLib.Security.ProtectedString]::ReadOnlyUtf8($url))
$entry.Strings.Set("Notes", [KeePassLib.Security.ProtectedString]::ReadOnlyUtf8($notes))

# Add the entry to the database
$database.RootGroup.AddEntry($entry, $true)

# Save and close the database
Save-KeePassDatabase -Database $database
Close-KeePassDatabase -Database $database

Write-Output "Dummy secret stored successfully in KeePass database at $databasePath"
