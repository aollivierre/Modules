function Copy-FilesToPath {
    <#
.SYNOPSIS
Copies all files and folders in the specified source directory to the specified destination path.

.DESCRIPTION
This function copies all files and folders located in the specified source directory to the specified destination path. It can be used to bundle necessary files and folders with the script for distribution or deployment.

.PARAMETER SourcePath
The source path from where the files and folders will be copied. If not provided, the default will be the directory of the calling script.

.PARAMETER DestinationPath
The destination path where the files and folders will be copied.

.EXAMPLE
Copy-FilesToPath -SourcePath "C:\Source" -DestinationPath "C:\Temp"

This example copies all files and folders in the "C:\Source" directory to the "C:\Temp" directory.

.EXAMPLE
Copy-FilesToPath -DestinationPath "C:\Temp"

This example copies all files and folders in the same directory as the calling script to the "C:\Temp" directory.
#>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        # [string]$SourcePath = $PSScriptRoot,
        [string]$SourcePath,

        [Parameter(Mandatory = $true)]
        [string]$DestinationPath
    )

    begin {
        Write-EnhancedLog -Message "Starting the copy process from the Source Path $SourcePath to $DestinationPath" -Level "INFO" -ForegroundColor ([System.ConsoleColor]::Cyan)
        
        # Ensure the destination directory exists
        if (-not (Test-Path -Path $DestinationPath)) {
            New-Item -Path $DestinationPath -ItemType Directory | Out-Null
        }
    }

    process {
        try {
            # Copy all items from the source directory to the destination, including subdirectories
            Copy-Item -Path "$SourcePath\*" -Destination $DestinationPath -Recurse -Force -ErrorAction Stop

            Write-EnhancedLog -Message "All items copied successfully from the Source Path $SourcePath to $DestinationPath." -Level "INFO" -ForegroundColor ([System.ConsoleColor]::Green)
        }
        catch {
            Write-EnhancedLog -Message "Error occurred during the copy process: $_" -Level "ERROR" -ForegroundColor ([System.ConsoleColor]::Red)
            throw $_
        }
    }

    end {
        Write-EnhancedLog -Message "Copy process completed." -Level "INFO" -ForegroundColor ([System.ConsoleColor]::Cyan)
    }
}
