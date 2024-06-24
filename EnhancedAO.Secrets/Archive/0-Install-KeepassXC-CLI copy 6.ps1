function Install-RequiredModules {
    [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12
    
    # Install SecretManagement.KeePass module if not installed or if the version is less than 0.9.2
    $KeePassModule = Get-Module -Name "SecretManagement.KeePass" -ListAvailable
    if (-not $KeePassModule -or ($KeePassModule.Version -lt [System.Version]::new(0, 9, 2))) {
        Write-Host "Installing SecretManagement.KeePass" -ForegroundColor Cyan
        Install-Module -Name "SecretManagement.KeePass" -RequiredVersion 0.9.2 -Force -Scope CurrentUser
    } else {
        Write-Host "SecretManagement.KeePass is already installed." -ForegroundColor Green
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
        Write-Host "Keepass $VaultName is already Registered..." -ForegroundColor Green
        Unregister-SecretVault -Name $VaultName
    }
    
    Register-KeePassSecretVault -Name $VaultName -Path $databaseKdbxPath -KeyPath $databaseKeyxPath
    Write-Host "Successfully Registered KeePass Vault" -ForegroundColor Green
}

function Get-KeePassDatabasePaths {
    $secretsPath = Join-Path $scriptPath "Secrets"
    $databaseKdbxPath = Join-Path $secretsPath "Database.kdbx"
    $databaseKeyxPath = Join-Path $secretsPath "Database.keyx"
    
    return @{
        DatabaseKdbxPath = $databaseKdbxPath
        DatabaseKeyxPath = $databaseKeyxPath
    }
}

function Create-KeePassDatabase {
    param (
        [string]$databaseKdbxPath,
        [string]$masterPassword
    )
    
    if (-not (Test-Path -Path $databaseKdbxPath)) {
        Write-Host "Creating new KeePass database at $databaseKdbxPath" -ForegroundColor Cyan
        
        # Use the KeePassCLI to create the database with a master password
        echo $masterPassword | keepassxc-cli db-create $databaseKdbxPath
    }
}

function Get-SecretsFromKeePass {
    param (
        [string[]]$KeePassEntryNames
    )
    
    $Secrets = @{}
    
    foreach ($entryName in $KeePassEntryNames) {
        $PasswordSecret = Get-Secret -Name "${entryName}_Password" -Vault "Database"
        $SecurePassword = $PasswordSecret
        
        # Convert SecureString back to plain text
        $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($PasswordSecret)
        $PlainText = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)
        
        $Secrets[$entryName] = @{
            "Username"       = $PasswordSecret.UserName
            "SecurePassword" = $SecurePassword
            "PlainText"      = $PlainText
        }
    }
    
    return $Secrets
}

# Main Execution
Install-RequiredModules

$VaultName = "Database"
$paths = Get-KeePassDatabasePaths
$databaseKdbxPath = $paths['DatabaseKdbxPath']
$databaseKeyxPath = $paths['DatabaseKeyxPath']

# Define the master password for KeePass database
$masterPassword = ConvertTo-SecureString -String "YourMasterPassword" -AsPlainText -Force

Create-KeePassDatabase -databaseKdbxPath $databaseKdbxPath -masterPassword $masterPassword

Register-KeePassVault -VaultName $VaultName -databaseKdbxPath $databaseKdbxPath -databaseKeyxPath $databaseKeyxPath

$KeePassEntryNames = @("ClientId", "ClientSecret", "TenantName", "SiteObjectId", "WebhookUrl")
$Secrets = Get-SecretsFromKeePass -KeePassEntryNames $KeePassEntryNames

$clientId = $Secrets["ClientId"].PlainText
$clientSecret = $Secrets["ClientSecret"].PlainText
$tenantName = $Secrets["TenantName"].PlainText
$site_objectid = $Secrets["SiteObjectId"].PlainText
$webhook_url = $Secrets["WebhookUrl"].PlainText

Write-Host "KeePass secrets are now available" -ForegroundColor Green
