# Define script path
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Definition

function Install-KeePass {
    param (
        [string]$KeePassDownloadUrl = "https://sourceforge.net/projects/keepass/files/KeePass%202.x/2.50/KeePass-2.50-Setup.exe/download",
        [string]$KeePassInstallPath = "$env:ProgramFiles\KeePassPasswordSafe2"
    )

    if (-not (Test-Path -Path $KeePassInstallPath)) {
        Write-Host "Downloading KeePass installer..." -ForegroundColor Cyan
        $installerPath = "$env:TEMP\KeePassSetup.exe"
        Invoke-WebRequest -Uri $KeePassDownloadUrl -OutFile $installerPath
        
        Write-Host "Installing KeePass..." -ForegroundColor Cyan
        try {
            Start-Process -FilePath $installerPath -ArgumentList "/VERYSILENT", "/NORESTART" -Wait -ErrorAction Stop
            Remove-Item -Path $installerPath
            Write-Host "KeePass installed successfully." -ForegroundColor Green
        } catch {
            Write-Host "Failed to install KeePass: $_" -ForegroundColor Red
        }
    } else {
        Write-Host "KeePass is already installed." -ForegroundColor Green
    }
}

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

function Create-KeePassDatabase {
    param (
        [string]$databaseKdbxPath,
        [securestring]$masterPassword
    )
    
    if (-not (Test-Path -Path $databaseKdbxPath)) {
        Write-Host "Creating new KeePass database at $databaseKdbxPath" -ForegroundColor Cyan
        try {
            New-KeePassDatabase -DatabasePath $databaseKdbxPath -MasterPassword $masterPassword
        } catch {
            Write-Host "Failed to create KeePass database: $_" -ForegroundColor Red
        }
    }
}

function Get-SecretsFromKeePass {
    param (
        [string[]]$KeePassEntryNames
    )
    
    $Secrets = @{}
    
    foreach ($entryName in $KeePassEntryNames) {
        $PasswordSecret = Get-Secret -Name "${entryName}_Password" -Vault "Database"
        
        if ($PasswordSecret -ne $null) {
            $SecurePassword = $PasswordSecret
            # Convert SecureString back to plain text
            $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($PasswordSecret)
            $PlainText = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)
            
            $Secrets[$entryName] = @{
                "Username"       = $PasswordSecret.UserName
                "SecurePassword" = $SecurePassword
                "PlainText"      = $PlainText
            }
        } else {
            Write-Host "Secret ${entryName}_Password not found in the vault" -ForegroundColor Yellow
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

# Install KeePass
Install-KeePass

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
