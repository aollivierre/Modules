# Main script logic
function ExportAndProcessSignInLogs {
    param (
        [Parameter(Mandatory = $true)]
        [string]$ScriptRoot,
        [Parameter(Mandatory = $true)]
        [string]$ExportsFolderName,
        [Parameter(Mandatory = $true)]
        [string]$ExportSubFolderName,
        [Parameter(Mandatory = $true)]
        [string]$url,
        [Parameter(Mandatory = $true)]
        [hashtable]$Headers
    )

    try {
        $ExportSignInLogsparams = @{
            ScriptRoot         = $ScriptRoot
            ExportsFolderName  = $ExportsFolderName
            ExportSubFolderName= $ExportSubFolderName
            url                = $url
            Headers            = $Headers
        }
        
        # Call the function with splatted parameters
        # Export-SignInLogs @ExportSignInLogsparams (uncomment if you want to export fresh sign-in logs)

        $subFolderPath = Join-Path -Path $ScriptRoot -ChildPath $ExportsFolderName
        $subFolderPath = Join-Path -Path $subFolderPath -ChildPath $ExportSubFolderName

        $latestJsonFile = Find-LatestJsonFile -Directory $subFolderPath

        if ($latestJsonFile) {
            $global:json = Load-SignInLogs -JsonFilePath $latestJsonFile
            # Further processing of $json can go here...
        } else {
            Write-EnhancedLog -Message "No JSON file found to load sign-in logs." -Level "WARNING" -ForegroundColor ([ConsoleColor]::Yellow)
        }
    } catch {
        Handle-Error -ErrorRecord $_
    }
}