# Function to install KeePassXC CLI
function Install-KeePassXCCli {
    if ($OS -eq 'Windows') {
        Write-Output "Installing KeePassXC CLI on Windows..."
        $installerUrl = "https://github.com/keepassxreboot/keepassxc/releases/download/2.7.9/KeePassXC-2.7.9-Win64.msi"
        $installerPath = "$env:TEMP\KeePassXC.msi"
        Invoke-WebRequest -Uri $installerUrl -OutFile $installerPath
        Start-Process msiexec.exe -ArgumentList "/i $installerPath /quiet /norestart" -Wait
        Remove-Item -Path $installerPath
    } elseif ($OS -eq 'Linux') {
        Write-Output "Installing KeePassXC CLI on Linux..."
        $appImageUrl = "https://github.com/keepassxreboot/keepassxc/releases/download/2.7.9/KeePassXC-2.7.9-x86_64.AppImage"
        $appImagePath = "/usr/local/bin/keepassxc-cli"
        Invoke-WebRequest -Uri $appImageUrl -OutFile $appImagePath
        sudo chmod +x $appImagePath
    } else {
        Write-Output "Unsupported operating system."
        exit 1
    }
    Write-Output "KeePassXC CLI installation complete."
}

# Detect the operating system
$OS = ""
if ($PSVersionTable.OS -like '*Windows*') {
    $OS = 'Windows'
} elseif ($PSVersionTable.OS -like '*Linux*') {
    $OS = 'Linux'
} else {
    Write-Output "Unsupported operating system."
    exit 1
}

# Install KeePassXC CLI if it's not already installed
if (-not (Get-Command keepassxc-cli -ErrorAction SilentlyContinue)) {
    Install-KeePassXCCli
}






function New-KeePassDatabase {
    param (
        [string]$DatabasePath = "C:\code\secrets\myDatabase.kdbx",
        [string]$KeyFilePath = "C:\code\secrets\myKeyFile.keyx"
    )

    if (-not (Test-Path (Split-Path $DatabasePath))) {
        Write-Error "The directory for the database path does not exist."
        return
    }

    if (-not (Test-Path (Split-Path $KeyFilePath))) {
        Write-Error "The directory for the key file path does not exist."
        return
    }

    $command = "keepassxc-cli db-create `"$DatabasePath`" --set-key-file `"$KeyFilePath`""
    
    try {
        Invoke-Expression $command
        Write-Host "Database '$DatabasePath' created successfully with key file '$KeyFilePath'." -ForegroundColor Green
    } catch {
        Write-Error "Failed to create the database. $_"
    }
}




New-KeePassDatabase -DatabasePath "C:\code\secrets\myDatabase.kdbx" -KeyFilePath "C:\code\secrets\myKeyFile.keyx"






function Add-KeePassEntry {
    param (
        [string]$DatabasePath = "C:\code\secrets\myDatabase.kdbx",
        [string]$KeyFilePath = "C:\code\secrets\myKeyFile.keyx",
        [string]$Username,
        [string]$EntryName
    )

    if (-not $Username) {
        Write-Error "Username is required."
        return
    }

    if (-not $EntryName) {
        Write-Error "Entry name is required."
        return
    }

    if (-not (Test-Path $DatabasePath)) {
        Write-Error "The database file does not exist."
        return
    }

    if (-not (Test-Path $KeyFilePath)) {
        Write-Error "The key file does not exist."
        return
    }

    $command = "keepassxc-cli add `"$DatabasePath`" -u `"$Username`" -g `"$EntryName`" --key-file `"$KeyFilePath`" --no-password"
    
    try {
        Invoke-Expression $command
        Write-Host "Entry '$EntryName' added successfully to the database." -ForegroundColor Green
    } catch {
        Write-Error "Failed to add entry to the database. $_"
    }
}


Add-KeePassEntry -DatabasePath "C:\code\secrets\myDatabase.kdbx" -KeyFilePath "C:\code\secrets\myKeyFile.keyx" -Username "john_doe" -EntryName "example_entry"


function Add-KeePassAttachment {
    param (
        [string]$DatabasePath = "C:\code\secrets\myDatabase.kdbx",
        [string]$EntryName = "example_entry",
        [string]$AttachmentName = "certificate",
        [string]$AttachmentPath = "C:\code\secrets\cert.cer",
        [string]$KeyFilePath = "C:\code\secrets\myKeyFile.keyx"
    )

    if (-not (Test-Path $DatabasePath)) {
        Write-Error "The database file does not exist."
        return
    }

    if (-not (Test-Path $KeyFilePath)) {
        Write-Error "The key file does not exist."
        return
    }

    if (-not (Test-Path $AttachmentPath)) {
        Write-Error "The attachment file does not exist."
        return
    }

    $command = "keepassxc-cli attachment-import `"$DatabasePath`" `"$EntryName`" `"$AttachmentName`" `"$AttachmentPath`" --key-file `"$KeyFilePath`" --no-password"
    
    try {
        Invoke-Expression $command
        Write-Host "Attachment '$AttachmentName' added successfully to the entry '$EntryName' in the database." -ForegroundColor Green
    } catch {
        Write-Error "Failed to add attachment to the entry. $_"
    }
}


Add-KeePassAttachment -DatabasePath "C:\code\secrets\myDatabase.kdbx" -EntryName "example_entry" -AttachmentName "certificate" -AttachmentPath "C:\code\secrets\cert.cer" -KeyFilePath "C:\code\secrets\myKeyFile.keyx"





function Export-KeePassAttachment {
    param (
        [string]$DatabasePath = "C:\code\secrets\myDatabase.kdbx",
        [string]$EntryName = "example_entry",
        [string]$AttachmentName = "certificate",
        [string]$ExportPath = "C:\code\secrets\cert-fromdb.crt",
        [string]$KeyFilePath = "C:\code\secrets\myKeyFile.keyx"
    )

    if (-not (Test-Path $DatabasePath)) {
        Write-Error "The database file does not exist."
        return
    }

    if (-not (Test-Path $KeyFilePath)) {
        Write-Error "The key file does not exist."
        return
    }

    $command = "keepassxc-cli attachment-export `"$DatabasePath`" `"$EntryName`" `"$AttachmentName`" `"$ExportPath`" --key-file `"$KeyFilePath`" --no-password"
    
    try {
        Invoke-Expression $command
        Write-Host "Attachment '$AttachmentName' from entry '$EntryName' exported successfully to '$ExportPath'." -ForegroundColor Green
    } catch {
        Write-Error "Failed to export attachment from the entry. $_"
    }
}



Export-KeePassAttachment -DatabasePath "C:\code\secrets\myDatabase.kdbx" -EntryName "example_entry" -AttachmentName "certificate" -ExportPath "C:\code\secrets\cert-fromdb.crt" -KeyFilePath "C:\code\secrets\myKeyFile.keyx"



