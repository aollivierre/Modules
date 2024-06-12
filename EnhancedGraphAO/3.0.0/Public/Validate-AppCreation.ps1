function Validate-AppCreation {
    param (
        [string]$AppName,
        [string]$JsonPath
    )

    # Call the function to run the script in its own instance of pwsh
    

    # Example usage
    # $jsonPath = "C:\path\to\your\jsonfile.json"
    # $appInfo = Get-AppInfoFromJson -jsonPath $jsonPath

   
    write-enhancedlog -Message "validating AppName $AppName from $JsonPath"

    try {
        # Import application objects from JSON using Get-AppInfoFromJson function
        $allApps = Get-AppInfoFromJson -jsonPath $JsonPath

         # Output the extracted data
        # $allApps | Format-Table -AutoSize

        # # List all applications
        # write-enhancedlog -Message "Listing all applications:"
        # $allApps | Format-Table Id, DisplayName, AppId, SignInAudience, PublisherDomain -AutoSize

        # Filter the applications to find the one with the specified display name
        $app = $allApps | Where-Object { $_.DisplayName -eq $AppName }

        # Debug output
        # write-enhancedlog -Message "Filtered applications count: $($app.Count)"
        if ($app.Count -eq 0) {
            write-enhancedlog -Message "No applications found with the name $AppName"
        }
        else {
            # write-enhancedlog -Message "Filtered applications details:"
            # $app | Format-Table Id, DisplayName, AppId, SignInAudience, PublisherDomain -AutoSize
        }

        # Log the parameters and the retrieved application object
        $params = @{
            AppName    = $AppName
            AppCount   = ($app | Measure-Object).Count
            AppDetails = $app
        }
        Log-Params -Params $params

        # Check if the application object is not null and has items
        if ($null -ne $app -and ($app | Measure-Object).Count -gt 0) {
            write-enhancedlog -Message "Application found."
            return $true
        }
        write-enhancedlog -Message "Application not found."
        return $false
    }
    catch {
        write-enhancedlog -Message "An error occurred: $_"
        throw $_
    }
}