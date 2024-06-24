# function Install-KeePass1 {
#     param (
#         [string]$KeePassDownloadUrl = "https://sourceforge.net/projects/keepass/files/KeePass%202.x/2.50/KeePass-2.50-Setup.exe/download",
#         [string]$KeePassInstallPath = "$env:ProgramFiles\KeePassPasswordSafe2"
#     )

#     if (-not (Test-Path -Path $KeePassInstallPath)) {
#         Write-Host "Downloading KeePass installer..." -ForegroundColor Cyan
#         $installerPath = "$env:TEMP\KeePassSetup.exe"
#         try {
#             Invoke-WebRequest -Uri $KeePassDownloadUrl -OutFile $installerPath
#             Write-Host "Installing KeePass..." -ForegroundColor Cyan
#             Start-Process -FilePath $installerPath -ArgumentList "/VERYSILENT", "/NORESTART" -Wait -NoNewWindow -ErrorAction Stop
#             Remove-Item -Path $installerPath
#             Write-Host "KeePass installed successfully." -ForegroundColor Green
#         } catch {
#             Write-Host "Failed to install KeePass: $_" -ForegroundColor Red
#         }
#     } else {
#         Write-Host "KeePass is already installed." -ForegroundColor Green
#     }
# }



# function Install-KeePass2 {
#     param (
#         [string]$KeePassDownloadUrl = "https://sourceforge.net/projects/keepass/files/KeePass%202.x/2.50/KeePass-2.50-Setup.exe/download",
#         [string]$KeePassInstallPath = "$env:ProgramFiles\KeePassPasswordSafe2"
#     )

#     if (-not (Test-Path -Path $KeePassInstallPath)) {
#         Write-Host "Downloading KeePass installer..." -ForegroundColor Cyan
#         $installerPath = "$env:TEMP\KeePassSetup.exe"
#         try {
#             Invoke-WebRequest -Uri $KeePassDownloadUrl -OutFile $installerPath
#             Write-Host "Installing KeePass..." -ForegroundColor Cyan
#             $installCommand = "& $installerPath /VERYSILENT /NORESTART"
#             Invoke-Expression $installCommand
#             Remove-Item -Path $installerPath
#             Write-Host "KeePass installed successfully." -ForegroundColor Green
#         } catch {
#             Write-Host "Failed to install KeePass: $_" -ForegroundColor Red
#         }
#     } else {
#         Write-Host "KeePass is already installed." -ForegroundColor Green
#     }
# }








function Install-KeePass3 {
    param (
        [string]$KeePassDownloadUrl = "https://sourceforge.net/projects/keepass/files/KeePass%202.x/2.50/KeePass-2.50-Setup.exe/download",
        [string]$KeePassInstallPath = "$env:ProgramFiles\KeePassPasswordSafe2"
    )

    if (-not (Test-Path -Path $KeePassInstallPath)) {
        Write-Host "Downloading KeePass installer..." -ForegroundColor Cyan
        $installerPath = "$env:TEMP\KeePassSetup.exe"
        try {
            Start-BitsTransfer -Source $KeePassDownloadUrl -Destination $installerPath
            Write-Host "Installing KeePass..." -ForegroundColor Cyan
            Start-Process -FilePath $installerPath -ArgumentList "/VERYSILENT", "/NORESTART" -Wait -NoNewWindow -ErrorAction Stop
            Remove-Item -Path $installerPath
            Write-Host "KeePass installed successfully." -ForegroundColor Green
        } catch {
            Write-Host "Failed to install KeePass: $_" -ForegroundColor Red
        }
    } else {
        Write-Host "KeePass is already installed." -ForegroundColor Green
    }
}


# Install-KeePass1
# Install-KeePass2
Install-KeePass3
