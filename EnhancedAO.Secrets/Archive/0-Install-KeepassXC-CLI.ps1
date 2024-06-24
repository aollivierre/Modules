# Function to install KeePassXC CLI
function Install-KeePassXCCli {
    if ($IsWindows) {
        Write-Output "Installing KeePassXC CLI on Windows..."
        $installerUrl = "https://github.com/keepassxreboot/keepassxc/releases/download/2.7.9/KeePassXC-2.7.9-Win64.msi"
        $installerPath = "$env:TEMP\KeePassXC.msi"
        Invoke-WebRequest -Uri $installerUrl -OutFile $installerPath
        Start-Process msiexec.exe -ArgumentList "/i $installerPath /quiet /norestart" -Wait
        Remove-Item -Path $installerPath
    } elseif ($IsLinux) {
        Write-Output "Installing KeePassXC CLI on Linux..."
        $appImageUrl = "https://github.com/keepassxreboot/keepassxc/releases/download/2.7.9/KeePassXC-2.7.9-x86_64.AppImage"
        $appImagePath = "/usr/local/bin/keepassxc-cli"
        Invoke-WebRequest -Uri $appImageUrl -OutFile $appImagePath
        chmod +x $appImagePath
    } else {
        Write-Output "Unsupported operating system."
        exit 1
    }
    Write-Output "KeePassXC CLI installation complete."
}

# Detect the operating system
$IsWindows = $false
$IsLinux = $false

if ($PSVersionTable.OS -like '*Windows*') {
    $IsWindows = $true
} elseif ($PSVersionTable.OS -like '*Linux*') {
    $IsLinux = $true
} else {
    Write-Output "Unsupported operating system."
    exit 1
}

# Install KeePassXC CLI if it's not already installed
if (-not (Get-Command keepassxc-cli -ErrorAction SilentlyContinue)) {
    Install-KeePassXCCli
}

# Define the path to the KeePass database and the master password
$databasePath = "C:\code\secrets\myDatabase.kdbx"
$masterPassword = "YourMasterPassword"
$entryTitle = "Dummy Secret"
$username = "dummyUser"
$password = "dummyPassword"
$url = "http://dummy-url.com"
$notes = "This is a dummy secret entry."

# Function to create a new KeePass database
function Create-KeePassDatabase {
    param (
        [string]$dbPath,
        [string]$password
    )
    & keepassxc-cli database-create -p $password $dbPath
}

# Function to add a new entry to the KeePass database
function Add-KeePassEntry {
    param (
        [string]$dbPath,
        [string]$password,
        [string]$title,
        [string]$user,
        [string]$pass,
        [string]$url,
        [string]$notes
    )
    & keepassxc-cli add --username $user --password $pass --url $url --notes $notes --group "/" --title $title -p $password $dbPath
}

# Check if the KeePass database exists; if not, create it
if (-not (Test-Path -Path $databasePath)) {
    Write-Output "Creating new KeePass database at $databasePath"
    Create-KeePassDatabase -dbPath $databasePath -password $masterPassword
}

# Add the dummy secret entry to the KeePass database
Add-KeePassEntry -dbPath $databasePath -password $masterPassword -title $entryTitle -user $username -pass $password -url $url -notes $notes

Write-Output "Dummy secret stored successfully in KeePass database at $databasePath"
