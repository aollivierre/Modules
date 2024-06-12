
function Download-PsExec {
    [CmdletBinding()]
    param(
        # [string]$TargetFolder = "$PSScriptRoot\private"
        [string]$TargetFolder
    )

    Begin {

        Remove-ExistingPsExec -TargetFolder $TargetFolder
    }



    process {

        # Define the URL for PsExec download
        $url = "https://download.sysinternals.com/files/PSTools.zip"
    
        # Ensure the target folder exists
        if (-Not (Test-Path -Path $TargetFolder)) {
            New-Item -Path $TargetFolder -ItemType Directory
        }
  
        # Full path for the downloaded file
        $zipPath = Join-Path -Path $TargetFolder -ChildPath "PSTools.zip"
  
        try {
            # Download the PSTools.zip file containing PsExec
            Write-EnhancedLog -Message "Downloading PSTools.zip from: $url to: $zipPath"
            Invoke-WebRequest -Uri $url -OutFile $zipPath
  
            # Extract PsExec64.exe from the zip file
            Expand-Archive -Path $zipPath -DestinationPath "$TargetFolder\PStools" -Force
  
            # Specific extraction of PsExec64.exe
            $extractedFolderPath = Join-Path -Path $TargetFolder -ChildPath "PSTools"
            $PsExec64Path = Join-Path -Path $extractedFolderPath -ChildPath "PsExec64.exe"
            $finalPath = Join-Path -Path $TargetFolder -ChildPath "PsExec64.exe"
  
            # Move PsExec64.exe to the desired location
            if (Test-Path -Path $PsExec64Path) {
  
                Write-EnhancedLog -Message "Moving PSExec64.exe from: $PsExec64Path to: $finalPath"
                Move-Item -Path $PsExec64Path -Destination $finalPath
  
                # Remove the downloaded zip file and extracted folder
                Remove-Item -Path $zipPath -Force
                Remove-Item -Path $extractedFolderPath -Recurse -Force
  
                Write-EnhancedLog -Message "PsExec64.exe has been successfully downloaded and moved to: $finalPath"
            }
        }
        catch {
            # Handle any errors during the process
            Write-Error "An error occurred: $_"
        }
    }


  

}