function Download-And-Install-ServiceUI {
    [CmdletBinding()]
    param(
        [string]$TargetFolder = "$PSScriptRoot\private"
    )

    Begin {
        try {
            Remove-ExistingServiceUI -TargetFolder $TargetFolder
        }
        catch {
            Write-EnhancedLog -Message "Error during Remove-ExistingServiceUI: $_" -Level "ERROR"
            throw $_
        }
    }

    Process {
        # Define the URL for MDT download
        $url = "https://download.microsoft.com/download/3/3/9/339BE62D-B4B8-4956-B58D-73C4685FC492/MicrosoftDeploymentToolkit_x64.msi"
        
        # Path for the downloaded MSI file
        $msiPath = Join-Path -Path $([System.IO.Path]::GetTempPath()) -ChildPath "MicrosoftDeploymentToolkit_x64.msi"
        
        try {
            # Download the MDT MSI file
            Write-EnhancedLog -Message "Downloading MDT MSI from: $url to: $msiPath" -Level "INFO"
            Invoke-WebRequest -Uri $url -OutFile $msiPath

            # Install the MSI silently
            Write-EnhancedLog -Message "Installing MDT MSI from: $msiPath" -Level "INFO"
            Start-Process msiexec.exe -ArgumentList "/i", "`"$msiPath`"", "/quiet", "/norestart" -Wait

            # Path to the installed ServiceUI.exe
            $installedServiceUIPath = "C:\Program Files\Microsoft Deployment Toolkit\Templates\Distribution\Tools\x64\ServiceUI.exe"
            $finalPath = Join-Path -Path $TargetFolder -ChildPath "ServiceUI.exe"

            # Move ServiceUI.exe to the desired location
            if (Test-Path -Path $installedServiceUIPath) {
                Write-EnhancedLog -Message "Copying ServiceUI.exe from: $installedServiceUIPath to: $finalPath" -Level "INFO"
                Copy-Item -Path $installedServiceUIPath -Destination $finalPath

                Write-EnhancedLog -Message "ServiceUI.exe has been successfully copied to: $finalPath" -Level "INFO"
            }
            else {
                throw "ServiceUI.exe not found at: $installedServiceUIPath"
            }

            # Remove the downloaded MSI file
            Remove-Item -Path $msiPath -Force
        }
        catch {
            # Handle any errors during the process
            Write-Error "An error occurred: $_"
            Write-EnhancedLog -Message "An error occurred: $_" -Level "ERROR"
        }
    }

    End {
        Write-EnhancedLog -Message "Download-And-Install-ServiceUI function execution completed." -Level "INFO"
    }
}