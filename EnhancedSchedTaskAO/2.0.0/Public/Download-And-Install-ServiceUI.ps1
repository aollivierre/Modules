function Download-And-Install-ServiceUI {
    [CmdletBinding()]
    param(
        [string]$TargetFolder,
        [string]$DownloadUrl,
        [string]$MsiFileName,
        [string]$InstalledServiceUIPath
    )

    begin {
        Write-EnhancedLog -Message "Starting Download-And-Install-ServiceUI function" -Level "INFO"
        Log-Params -Params $PSCmdlet.MyInvocation.BoundParameters

        try {
            $removeParams = @{
                TargetFolder = $TargetFolder;
                FileName = "ServiceUI.exe"
            }
            Remove-ExistingServiceUI @removeParams
        }
        catch {
            Write-EnhancedLog -Message "Error during Remove-ExistingServiceUI: $_" -Level "ERROR"
            Handle-Error -ErrorRecord $_
            throw $_
        }
    }

    process {
        $msiPath = Join-Path -Path $([System.IO.Path]::GetTempPath()) -ChildPath $MsiFileName
        $finalPath = Join-Path -Path $TargetFolder -ChildPath "ServiceUI.exe"
        $maxRetries = 3
        $retryCount = 0
        $downloadSuccess = $false

        while (-not $downloadSuccess -and $retryCount -lt $maxRetries) {
            try {
                $retryCount++
                $webClient = New-Object System.Net.WebClient
                Write-EnhancedLog -Message "Downloading MDT MSI from: $DownloadUrl to: $msiPath (Attempt $retryCount)" -Level "INFO"
                $webClient.DownloadFile($DownloadUrl, $msiPath)
                $downloadSuccess = $true
            }
            catch {
                Write-EnhancedLog -Message "Error downloading MDT MSI on attempt $retryCount $_" -Level "ERROR"
                if ($retryCount -eq $maxRetries) {
                    Write-EnhancedLog -Message "Maximum retry attempts reached. Download failed." -Level "ERROR"
                    throw $_
                }
                Start-Sleep -Seconds 5
            }
        }

        try {
            $installParams = @{
                FilePath     = "msiexec.exe";
                ArgumentList = "/i `"$msiPath`" /quiet /norestart";
                Wait         = $true
            }
            Write-EnhancedLog -Message "Installing MDT MSI from: $msiPath" -Level "INFO"
            Start-Process @installParams

            if (Test-Path -Path $InstalledServiceUIPath) {
                $sourceDir = "`"$(Split-Path -Parent $InstalledServiceUIPath)`""
                $destDir = "`"$TargetFolder`""
                $fileName = "ServiceUI.exe"
                $robocopyCommand = "robocopy.exe $sourceDir $destDir $fileName"
                Write-EnhancedLog -Message "Executing command: $robocopyCommand" -Level "INFO"
                Invoke-Expression $robocopyCommand

                Write-EnhancedLog -Message "ServiceUI.exe has been successfully copied to: $finalPath" -Level "INFO"
            }
            else {
                throw "ServiceUI.exe not found at: $InstalledServiceUIPath"
            }

            $removeMsiParams = @{
                Path  = $msiPath;
                Force = $true
            }
            Write-EnhancedLog -Message "Removing downloaded MSI file: $msiPath" -Level "INFO"
            Remove-Item @removeMsiParams
        }
        catch {
            Write-EnhancedLog -Message "An error occurred: $_" -Level "ERROR"
            Handle-Error -ErrorRecord $_
            throw $_
        }
    }

    end {
        Write-EnhancedLog -Message "Download-And-Install-ServiceUI function execution completed." -Level "INFO"
    }
}


# # Example usage of Download-And-Install-ServiceUI function with splatting
# $params = @{
#     TargetFolder = "C:\Path\To\Your\Desired\Folder";
#     DownloadUrl = "https://download.microsoft.com/download/3/3/9/339BE62D-B4B8-4956-B58D-73C4685FC492/MicrosoftDeploymentToolkit_x64.msi";
#     MsiFileName = "MicrosoftDeploymentToolkit_x64.msi";
#     InstalledServiceUIPath = "C:\Program Files\Microsoft Deployment Toolkit\Templates\Distribution\Tools\x64\ServiceUI.exe"
# }
# Download-And-Install-ServiceUI @params
