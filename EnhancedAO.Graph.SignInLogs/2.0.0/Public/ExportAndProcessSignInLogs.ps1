# Main script logic
# function ExportAndProcessSignInLogs {
#     param (
#         [Parameter(Mandatory = $true)]
#         [string]$ScriptRoot,
#         [Parameter(Mandatory = $true)]
#         [string]$ExportsFolderName,
#         [Parameter(Mandatory = $true)]
#         [string]$ExportSubFolderName,
#         [Parameter(Mandatory = $true)]
#         [string]$url,
#         [Parameter(Mandatory = $true)]
#         [hashtable]$Headers
#     )

#     try {
#         $ExportSignInLogsparams = @{
#             ScriptRoot         = $ScriptRoot
#             ExportsFolderName  = $ExportsFolderName
#             ExportSubFolderName= $ExportSubFolderName
#             url                = $url
#             Headers            = $Headers
#         }
        
#         # Call the function with splatted parameters
#         # Export-SignInLogs @ExportSignInLogsparams (uncomment if you want to export fresh sign-in logs)

#         $subFolderPath = Join-Path -Path $ScriptRoot -ChildPath $ExportsFolderName
#         $subFolderPath = Join-Path -Path $subFolderPath -ChildPath $ExportSubFolderName

#         $latestJsonFile = Find-LatestJsonFile -Directory $subFolderPath

#         if ($latestJsonFile) {
#             $global:json = Load-SignInLogs -JsonFilePath $latestJsonFile
     
#             # Further processing of $json can go here...
#         } else {
#             Write-EnhancedLog -Message "No JSON file found to load sign-in logs." -Level "WARNING" -ForegroundColor ([ConsoleColor]::Yellow)
#         }
#     } catch {
#         Handle-Error -ErrorRecord $_
#     }
# }




# Example integration in the main script logic
# function ExportAndProcessSignInLogs {
#     param (
#         [Parameter(Mandatory = $true)]
#         [string]$ScriptRoot,
#         [Parameter(Mandatory = $true)]
#         [string]$ExportsFolderName,
#         [Parameter(Mandatory = $true)]
#         [string]$ExportSubFolderName,
#         [Parameter(Mandatory = $true)]
#         [string]$url,
#         [Parameter(Mandatory = $true)]
#         [hashtable]$Headers
#     )

#     try {
#         $ExportSignInLogsparams = @{
#             ScriptRoot         = $ScriptRoot
#             ExportsFolderName  = $ExportsFolderName
#             ExportSubFolderName= $ExportSubFolderName
#             url                = $url
#             Headers            = $Headers
#         }
        
#         # Call the function with splatted parameters
#         # Export-SignInLogs @ExportSignInLogsparams (uncomment if you want to export fresh sign-in logs to a new JSON file)

#         $subFolderPath = Join-Path -Path $ScriptRoot -ChildPath $ExportsFolderName
#         $subFolderPath = Join-Path -Path $subFolderPath -ChildPath $ExportSubFolderName

#         $latestJsonFile = Find-LatestJsonFile -Directory $subFolderPath

#         if ($latestJsonFile) {
#             # $signInLogs = Load-SignInLogs -JsonFilePath $latestJsonFile
#             $global:signInLogs = Load-SignInLogs -JsonFilePath $latestJsonFile
#             if ($signInLogs.Count -gt 0) {
#                 # $results = Process-AllDevices -Json $signInLogs -Headers $Headers
#                 # Further processing of $results can go here...

#                 Write-EnhancedLog -Message "sign-in logs found in $latestJsonFile. Starting to process it" -Level "INFO"
#             } else {
#                 Write-EnhancedLog -Message "No sign-in logs found in $latestJsonFile." -Level "WARNING"
#             }
#         } else {
#             Write-EnhancedLog -Message "No JSON file found to load sign-in logs." -Level "WARNING"
#         }
#     } catch {
#         Handle-Error -ErrorRecord $_
#     }
# }




# function ExportAndProcessSignInLogs {
#     param (
#         [Parameter(Mandatory = $true)]
#         [string]$ScriptRoot,
#         [Parameter(Mandatory = $true)]
#         [string]$ExportsFolderName,
#         [Parameter(Mandatory = $true)]
#         [string]$ExportSubFolderName,
#         [Parameter(Mandatory = $true)]
#         [string]$url,
#         [Parameter(Mandatory = $true)]
#         [hashtable]$Headers
#     )

#     try {
#         $ExportSignInLogsparams = @{
#             ScriptRoot         = $ScriptRoot
#             ExportsFolderName  = $ExportsFolderName
#             ExportSubFolderName= $ExportSubFolderName
#             url                = $url
#             Headers            = $Headers
#         }
        
#         # Call the function with splatted parameters
#         # Export-SignInLogs @ExportSignInLogsparams (uncomment if you want to export fresh sign-in logs to a new JSON file)

#         $subFolderPath = Join-Path -Path $ScriptRoot -ChildPath $ExportsFolderName
#         $subFolderPath = Join-Path -Path $subFolderPath -ChildPath $ExportSubFolderName

#         $latestJsonFile = Find-LatestJsonFile -Directory $subFolderPath

#         if ($latestJsonFile) {
#             $signInLogs = Load-SignInLogs -JsonFilePath $latestJsonFile
#             if ($signInLogs.Count -gt 0) {
#                 # Further processing of $signInLogs can go here...

#                 Write-EnhancedLog -Message "sign-in logs found in $latestJsonFile. Starting to process it" -Level "INFO"
#                 return $signInLogs
#             } else {
#                 Write-EnhancedLog -Message "No sign-in logs found in $latestJsonFile." -Level "WARNING"
#                 return @()
#             }
#         } else {
#             Write-EnhancedLog -Message "No JSON file found to load sign-in logs." -Level "WARNING"
#             return @()
#         }
#     } catch {
#         Handle-Error -ErrorRecord $_
#         return @()
#     }
# }




# function ExportAndProcessSignInLogs {
#     param (
#         [Parameter(Mandatory = $true)]
#         [string]$ScriptRoot,
#         [Parameter(Mandatory = $true)]
#         [string]$ExportsFolderName,
#         [Parameter(Mandatory = $true)]
#         [string]$ExportSubFolderName,
#         [Parameter(Mandatory = $true)]
#         [string]$url,
#         [Parameter(Mandatory = $true)]
#         [hashtable]$Headers
#     )

#     try {
#         $ExportSignInLogsparams = @{
#             ScriptRoot         = $ScriptRoot
#             ExportsFolderName  = $ExportsFolderName
#             ExportSubFolderName= $ExportSubFolderName
#             url                = $url
#             Headers            = $Headers
#         }
        
#         # Call the function with splatted parameters
#         # Export-SignInLogs @ExportSignInLogsparams (uncomment if you want to export fresh sign-in logs to a new JSON file)

#         $subFolderPath = Join-Path -Path $ScriptRoot -ChildPath $ExportsFolderName
#         $subFolderPath = Join-Path -Path $subFolderPath -ChildPath $ExportSubFolderName

#         $latestJsonFile = Find-LatestJsonFile -Directory $subFolderPath

#         if ($latestJsonFile) {
#             $signInLogs = Load-SignInLogs -JsonFilePath $latestJsonFile
#             if ($signInLogs.Count -gt 0) {
#                 Write-EnhancedLog -Message "Sign-in logs found in $latestJsonFile. Starting to process it" -Level "INFO"
#                 # Process-AllDevices -Json $signInLogs -Headers $Headers
#             } else {
#                 Write-EnhancedLog -Message "No sign-in logs found in $latestJsonFile." -Level "WARNING"
#                 return @()
#             }
#         } else {
#             Write-EnhancedLog -Message "No JSON file found to load sign-in logs." -Level "WARNING"
#             return @()
#         }
#     } catch {
#         Handle-Error -ErrorRecord $_
#         return @()
#     }
# }



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
        # Export-SignInLogs @ExportSignInLogsparams (uncomment if you want to export fresh sign-in logs to a new JSON file)

        $subFolderPath = Join-Path -Path $ScriptRoot -ChildPath $ExportsFolderName
        $subFolderPath = Join-Path -Path $subFolderPath -ChildPath $ExportSubFolderName

        Write-EnhancedLog -Message "Looking for JSON files in $subFolderPath" -Level "DEBUG"

        $latestJsonFile = Find-LatestJsonFile -Directory $subFolderPath

        if ($latestJsonFile) {
            Write-EnhancedLog -Message "Latest JSON file found: $latestJsonFile" -Level "DEBUG"
            $signInLogs = Load-SignInLogs -JsonFilePath $latestJsonFile
            if ($signInLogs.Count -gt 0) {
                Write-EnhancedLog -Message "Sign-in logs found in $latestJsonFile. Starting to process it" -Level "INFO"
                # Process-AllDevices -Json $signInLogs -Headers $Headers
                return $signInLogs
            } else {
                Write-EnhancedLog -Message "No sign-in logs found in $latestJsonFile." -Level "WARNING"
                return @()
            }
        } else {
            Write-EnhancedLog -Message "No JSON file found to load sign-in logs." -Level "WARNING"
            return @()
        }
    } catch {
        Handle-Error -ErrorRecord $_
        return @()
    }
}

# function Process-AllDevices {
#     param (
#         [Parameter(Mandatory = $true)]
#         [array]$Json,
#         [Parameter(Mandatory = $true)]
#         [hashtable]$Headers
#     )

#     foreach ($log in $Json) {
#         Write-EnhancedLog -Message "Processing sign-in log for user: $($log.UserPrincipalName)" -Level "INFO"
#         # Perform actual processing here

#         # Example: Processing each log entry
#         Write-EnhancedLog -Message "Sign-in log entry: $($log | ConvertTo-Json -Compress)" -Level "DEBUG"
#     }
# }

# # Example usage
# $ExportAndProcessSignInLogsparams = @{
#     ScriptRoot          = $PSScriptRoot
#     ExportsFolderName   = "CustomExports"
#     ExportSubFolderName = "CustomSignInLogs"
#     url                 = $url
#     Headers             = $headers
# }

# # Call the function using splatting
# $signInLogs = ExportAndProcessSignInLogs @ExportAndProcessSignInLogsparams

# # Process the sign-in logs if any are returned
# if ($signInLogs.Count -gt 0) {
#     # Further processing of $signInLogs can go here...
#     Write-Output "Sign-in logs found and processed."
# } else {
#     Write-Output "No sign-in logs found."
# }





# # Example usage
# $params = @{
#     ScriptRoot         = "C:\Path\To\ScriptRoot"
#     ExportsFolderName  = "Exports"
#     ExportSubFolderName= "SubFolder"
#     url                = "https://example.com/api/signinlogs"
#     Headers            = @{
#         "Authorization" = "Bearer <your_token>"
#         "Content-Type"  = "application/json"
#     }
# }

# ExportAndProcessSignInLogs @params
