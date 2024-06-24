# Define script path
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Definition

function Install-RequiredModules {
    [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12
    
    if (-not (Get-Module -ListAvailable -Name "SecretManagement.KeePass")) {
        Install-Module -Name "SecretManagement.KeePass" -Scope CurrentUser -Force
    }
    Import-Module "SecretManagement.KeePass" -ErrorAction Stop
}

function Create-KeePassDatabase {
    param (
        [string]$dbPath,
        [securestring]$masterPassword
    )
    Write-Output "Creating new KeePass database at $dbPath"

    # Convert SecureString to plain text
    $plainTextPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($masterPassword))

    # Create the KeePass database using the CLI command
    try {
        & keepassxc-cli db-create --set-password -p $plainTextPassword $dbPath
        Write-Output "KeePass database created successfully."
    } catch {
        Write-Output "Failed to create KeePass database: $_" -ForegroundColor Red
    }
}

function Register-KeePassVault {
    param (
        [string]$VaultName,
        [string]$databaseKdbxPath,
        [string]$databaseKeyxPath
    )

    $ExistingVault = Get-SecretVault -Name $VaultName -ErrorAction SilentlyContinue
    if ($ExistingVault) {
        Write-Host "KeePass $VaultName is already Registered..." -ForegroundColor Green
        Unregister-SecretVault -Name $VaultName
    }

    Register-KeePassSecretVault -Name $VaultName -Path $databaseKdbxPath -KeyPath $databaseKeyxPath
    Write-Host "Successfully Registered KeePass Vault" -ForegroundColor Green
}

function Get-KeePassDatabasePaths {
    $secretsPath = Join-Path $scriptPath "Secrets"
    if (-not (Test-Path -Path $secretsPath)) {
        New-Item -Path $secretsPath -ItemType Directory | Out-Null
    }
    $databaseKdbxPath = Join-Path $secretsPath "Database.kdbx"
    $databaseKeyxPath = Join-Path $secretsPath "Database.keyx"
    
    return @{
        DatabaseKdbxPath = $databaseKdbxPath
        DatabaseKeyxPath = $databaseKeyxPath
    }
}

# Main Execution
Install-RequiredModules

$VaultName = "Database"
$paths = Get-KeePassDatabasePaths
$databaseKdbxPath = $paths['DatabaseKdbxPath']
$databaseKeyxPath = $paths['DatabaseKeyxPath']

# Define the master password for KeePass database
$masterPassword = ConvertTo-SecureString -String "YourMasterPassword" -AsPlainText -Force

# Create the KeePass database
Create-KeePassDatabase -dbPath $databaseKdbxPath -masterPassword $masterPassword

# # Register the KeePass vault
# Register-KeePassVault -VaultName $VaultName -databaseKdbxPath $databaseKdbxPath -databaseKeyxPath $databaseKeyxPath

# Write-Host "KeePass setup and vault registration complete." -ForegroundColor Green
