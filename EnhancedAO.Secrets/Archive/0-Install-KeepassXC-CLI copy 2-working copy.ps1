Install-Module -Name KeePassLib -Force

# Define the path to the KeePass database
$databasePath = "C:\code\secrets\myDatabase.kdbx"

# Define the master password for the database
$masterPassword = "YourMasterPassword"

# Load the KeePass library
Import-Module KeePassLib

# Open the KeePass database
$database = Open-KeePassDatabase -DatabaseFilePath $databasePath -MasterPassword $masterPassword

# Define the entry details
$entry = @{
    Title = "New Entry"
    Username = "MyUsername"
    Password = "MyPassword"
    URL = "http://example.com"
    Notes = "Some notes about this entry"
}

# Add the new entry to the root group of the database
Add-KeePassEntry -Database $database -GroupPath "\" -Entry $entry

# Save and close the database
Save-KeePassDatabase -Database $database
Close-KeePassDatabase -Database $database

Write-Output "Entry added successfully."
