function Download-PSAppDeployToolkit {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$GithubRepository,

        [Parameter(Mandatory = $true)]
        [string]$FilenamePatternMatch,

        [Parameter(Mandatory = $true)]
        [string]$ScriptDirectory
    )

    begin {
        Write-EnhancedLog -Message "Starting Download-PSAppDeployToolkit function" -Level "INFO"
        Log-Params -Params $PSCmdlet.MyInvocation.BoundParameters

        try {
            # Set the URI to get the latest release information from the GitHub repository
            $psadtReleaseUri = "https://api.github.com/repos/$GithubRepository/releases/latest"
            Write-EnhancedLog -Message "GitHub release URI: $psadtReleaseUri" -Level "INFO"
        }
        catch {
            Write-EnhancedLog -Message "Error in begin block: $($_.Exception.Message)" -Level "ERROR"
            Handle-Error -ErrorRecord $_
            throw $_
        }
    }

    process {
        try {
            # Fetch the latest release information from GitHub
            Write-EnhancedLog -Message "Fetching the latest release information from GitHub" -Level "INFO"
            $psadtDownloadUri = (Invoke-RestMethod -Method GET -Uri $psadtReleaseUri).assets |
                Where-Object { $_.name -like $FilenamePatternMatch } |
                Select-Object -ExpandProperty browser_download_url

            if (-not $psadtDownloadUri) {
                throw "No matching file found for pattern: $FilenamePatternMatch"
            }
            Write-EnhancedLog -Message "Found matching download URL: $psadtDownloadUri" -Level "INFO"

            # Set the path for the temporary download location
            $zipTempDownloadPath = Join-Path -Path ([System.IO.Path]::GetTempPath()) -ChildPath (Split-Path -Path $psadtDownloadUri -Leaf)
            Write-EnhancedLog -Message "Temporary download path: $zipTempDownloadPath" -Level "INFO"

            # Download the file to the temporary location
            Write-EnhancedLog -Message "Downloading file from $psadtDownloadUri to $zipTempDownloadPath" -Level "INFO"
            Invoke-WebRequest -Uri $psadtDownloadUri -OutFile $zipTempDownloadPath

            # Unblock the downloaded file if necessary
            Write-EnhancedLog -Message "Unblocking file at $zipTempDownloadPath" -Level "INFO"
            Unblock-File -Path $zipTempDownloadPath

            # Set the temporary extraction path
            $tempExtractionPath = Join-Path -Path ([System.IO.Path]::GetTempPath()) -ChildPath "PSAppDeployToolkit"
            if (-not (Test-Path $tempExtractionPath)) {
                New-Item -Path $tempExtractionPath -ItemType Directory | Out-Null
            }

            # Extract the contents of the zip file to the temporary extraction path
            Write-EnhancedLog -Message "Extracting file from $zipTempDownloadPath to $tempExtractionPath" -Level "INFO"
            Expand-Archive -Path $zipTempDownloadPath -DestinationPath $tempExtractionPath -Force

            # Use robocopy to copy all files from the temporary extraction folder to the ScriptDirectory, excluding deploy-application.ps1
            Write-EnhancedLog -Message "Copying files from $tempExtractionPath to $ScriptDirectory" -Level "INFO"
            $robocopyArgs = @(
                $tempExtractionPath,
                $ScriptDirectory,
                "/E", # Copies subdirectories, including empty ones.
                "/XF", "deploy-application.ps1"
            )
            $robocopyCommand = "robocopy.exe $($robocopyArgs -join ' ')"
            Write-EnhancedLog -Message "Executing command: $robocopyCommand" -Level "INFO"
            Invoke-Expression $robocopyCommand

            # Copy Deploy-Application.exe from Toolkit to ScriptDirectory
            Write-EnhancedLog -Message "Copying Deploy-Application.exe from Toolkit to $ScriptDirectory" -Level "INFO"
            $deployAppSource = Join-Path -Path $tempExtractionPath -ChildPath "Toolkit"
            $deployAppArgs = @(
                $deployAppSource,
                $ScriptDirectory,
                "Deploy-Application.exe",
                "/COPY:DAT",
                "/R:1",
                "/W:1"
            )
            $deployAppCommand = "robocopy.exe $($deployAppArgs -join ' ')"
            Write-EnhancedLog -Message "Executing command: $deployAppCommand" -Level "INFO"
            Invoke-Expression $deployAppCommand

            Write-EnhancedLog -Message "Files copied successfully to $ScriptDirectory" -Level "INFO"

            # Clean up temporary files
            Write-EnhancedLog -Message "Removing temporary download file: $zipTempDownloadPath" -Level "INFO"
            Remove-Item -Path $zipTempDownloadPath -Force

            Write-EnhancedLog -Message "Removing temporary extraction folder: $tempExtractionPath" -Level "INFO"
            Remove-Item -Path $tempExtractionPath -Recurse -Force
        }
        catch {
            Write-EnhancedLog -Message "Error in process block: $($_.Exception.Message)" -Level "ERROR"
            Handle-Error -ErrorRecord $_
            throw $_
        }
    }

    end {
        try {
            Write-EnhancedLog -Message "File extracted and copied successfully to $ScriptDirectory" -Level "INFO"
        }
        catch {
            Write-EnhancedLog -Message "Error in end block: $($_.Exception.Message)" -Level "ERROR"
            Handle-Error -ErrorRecord $_
        }

        Write-EnhancedLog -Message "Exiting Download-PSAppDeployToolkit function" -Level "INFO"
    }
}

# # Example usage
# $params = @{
#     GithubRepository = 'PSAppDeployToolkit/PSAppDeployToolkit';
#     FilenamePatternMatch = '*.zip';
#     ScriptDirectory = 'C:\YourScriptDirectory'
# }
# Download-PSAppDeployToolkit @params
