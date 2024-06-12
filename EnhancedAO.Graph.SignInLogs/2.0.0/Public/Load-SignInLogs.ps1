# Function to load sign-in logs from the latest JSON file
function Load-SignInLogs {
    param (
        [Parameter(Mandatory = $true)]
        [string]$JsonFilePath
    )

    try {
        $json = Get-Content -Path $JsonFilePath | ConvertFrom-Json
        Write-EnhancedLog -Message "Sign-in logs loaded successfully from $JsonFilePath." -Level "INFO" -ForegroundColor ([ConsoleColor]::Green)
        return $json
    } catch {
        Handle-Error -ErrorRecord $_
        
    }
}


# class SignInLog {
#     [string] $userDisplayName
#     [string] $deviceID
#     [datetime] $signInDateTime
#     # Add other relevant properties here
# }

# # Function to load and deserialize sign-in logs from the latest JSON file
# function Load-SignInLogs {
#     param (
#         [Parameter(Mandatory = $true)]
#         [string]$JsonFilePath
#     )

#     try {
#         # Load the JSON file
#         $reader = [System.IO.StreamReader]::new($JsonFilePath)
#         $jarray = [Newtonsoft.Json.Linq.JArray]::Load([NewtonSoft.Json.JsonTextReader]$reader)
        
#         # Filter out specific users and deserialize to SignInLog class
#         $filteredLogs = $jarray.SelectTokens('$..[?(@.userDisplayName != ''On-Premises Directory Synchronization Service Account'')]').ToObject[SignInLog]()
        
#         Write-EnhancedLog -Message "Sign-in logs loaded and filtered successfully from $JsonFilePath." -Level "INFO" -ForegroundColor ([ConsoleColor]::Green)
#         return $filteredLogs
#     } catch {
#         Handle-Error -ErrorRecord $_
#         # return $null
#     }
# }