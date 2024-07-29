function Install-MsiPackage {
    [CmdletBinding()]
    param (
        [string]$ScriptRoot,
        [string]$MsiFileName,
        [string]$FilePath,
        [string]$ArgumentTemplate
    )

    begin {
        Write-EnhancedLog -Message "Starting Install-MsiPackage function for: $MsiFileName" -Level 'INFO'
        Log-Params -Params $PSCmdlet.MyInvocation.BoundParameters
    }

    process {
        try {
            $installerPath = Join-Path -Path $ScriptRoot -ChildPath $MsiFileName
            
            if (Test-Path $installerPath) {
                Write-EnhancedLog -Message "Found installer file: $installerPath" -Level 'INFO'
                $arguments = $ArgumentTemplate -replace '{InstallerPath}', $installerPath
                Start-Process -FilePath $FilePath -ArgumentList $arguments -Wait
                Write-EnhancedLog -Message "Installation process completed for: $installerPath" -Level 'INFO'
                Write-EnhancedLog -Message "Installation process completed for: $installerPath" -Level 'INFO'
            } else {
                Write-EnhancedLog -Message "Installer file not found at path: $installerPath" -Level 'ERROR'

                Write-EnhancedLog -Message "Extracting all ZIP files recursively..."
                $zipFiles = Get-ChildItem -Path $ScriptRoot -Recurse -Include '*.zip.001'
                foreach ($zipFile in $zipFiles) {
                    $destinationFolder = [System.IO.Path]::GetDirectoryName($zipFile.FullName)
                    Write-EnhancedLog -Message "Combining and extracting segmented ZIP files for $($zipFile.BaseName) using 7-Zip..."
                    $sevenZipCommand = "& `"$env:ProgramFiles\7-Zip\7z.exe`" x `"$zipFile`" -o`"$destinationFolder`""
                    Write-EnhancedLog -Message "Executing: $sevenZipCommand"
                    Invoke-Expression $sevenZipCommand
                }
                Write-EnhancedLog -Message "All ZIP files extracted."

                $arguments = $ArgumentTemplate -replace '{InstallerPath}', $installerPath
                Start-Process -FilePath $FilePath -ArgumentList $arguments -Wait


                # Write-Output "Installer file not found at path: $installerPath"
            }
        } catch {
            Handle-Error -ErrorRecord $_
        }
    }

    end {
        Write-EnhancedLog -Message 'Install-MsiPackage function completed' -Level 'INFO'
    }
}

# # Example usage of Install-MsiPackage function with splatting
# $params = @{
#     ScriptRoot       = $PSScriptRoot
#     MsiFileName      = 'FortiClient.msi'
#     FilePath         = 'MsiExec.exe'
#     ArgumentTemplate = "/i `{InstallerPath}` /quiet /norestart"
# }
# Install-MsiPackage @params
