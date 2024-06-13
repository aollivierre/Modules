# # Function to load sign-in logs from the latest JSON file
# function Load-SignInLogs {
#     param (
#         [Parameter(Mandatory = $true)]
#         [string]$JsonFilePath
#     )

#     try {
#         $json = Get-Content -Path $JsonFilePath | ConvertFrom-Json
#         # Write-EnhancedLog -Message "Sign-in logs loaded successfully from $JsonFilePath." -Level "INFO" -ForegroundColor ([ConsoleColor]::Green)
#         return $json
#     } catch {
#         Handle-Error -ErrorRecord $_
        
#     }
# }



class SignInLog {
    [string] $userDisplayName
    [string] $userId
    [DeviceDetail] $deviceDetail

    SignInLog([string] $userDisplayName, [string] $userId, [DeviceDetail] $deviceDetail) {
        $this.userDisplayName = $userDisplayName
        $this.userId = $userId
        $this.deviceDetail = $deviceDetail
    }
}

class DeviceDetail {
    [string] $deviceId
    [string] $displayName
    [string] $operatingSystem
    [bool] $isCompliant
    [string] $trustType

    DeviceDetail([string] $deviceId, [string] $displayName, [string] $operatingSystem, [bool] $isCompliant, [string] $trustType) {
        $this.deviceId = $deviceId
        $this.displayName = $displayName
        $this.operatingSystem = $operatingSystem
        $this.isCompliant = $isCompliant
        $this.trustType = $trustType
    }
}




# Function to load sign-in logs from the latest JSON file
function Load-SignInLogs {
    param (
        [Parameter(Mandatory = $true)]
        [string]$JsonFilePath
    )

    $signInLogs = [System.Collections.Generic.List[SignInLog]]::new()
    $fileStream = [System.IO.File]::OpenRead($JsonFilePath)

    try {
        $jsonDoc = [System.Text.Json.JsonDocument]::Parse($fileStream)

        foreach ($element in $jsonDoc.RootElement.EnumerateArray()) {
            $deviceDetail = [DeviceDetail]::new(
                $element.GetProperty("deviceDetail").GetProperty("deviceId").GetString(),
                $element.GetProperty("deviceDetail").GetProperty("displayName").GetString(),
                $element.GetProperty("deviceDetail").GetProperty("operatingSystem").GetString(),
                $element.GetProperty("deviceDetail").GetProperty("isCompliant").GetBoolean(),
                $element.GetProperty("deviceDetail").GetProperty("trustType").GetString()
            )
            $signInLog = [SignInLog]::new(
                $element.GetProperty("userDisplayName").GetString(),
                $element.GetProperty("userId").GetString(),
                $deviceDetail
            )

            $signInLogs.Add($signInLog)
        }

        # Write-EnhancedLog -Message "Sign-in logs loaded successfully from $JsonFilePath." -Level "INFO" -ForegroundColor ([ConsoleColor]::Green)
    } catch {
        Handle-Error -ErrorRecord $_
    } finally {
        $fileStream.Dispose()
    }

    return $signInLogs
}










# # Function to load sign-in logs from the latest JSON file
# function Load-SignInLogs {
#     param (
#         [Parameter(Mandatory = $true)]
#         [string]$JsonFilePath
#     )

#     $signInLogs = [System.Collections.Generic.List[PSCustomObject]]::new()
#     $fileStream = [System.IO.File]::OpenRead($JsonFilePath)

#     try {
#         $jsonDoc = [System.Text.Json.JsonDocument]::Parse($fileStream)

#         foreach ($element in $jsonDoc.RootElement.EnumerateArray()) {
#             $signInLog = [PSCustomObject]@{
#                 userDisplayName = $element.GetProperty("userDisplayName").GetString()
#                 userId = $element.GetProperty("userId").GetString()
#                 deviceDetail = [PSCustomObject]@{
#                     deviceId = $element.GetProperty("deviceDetail").GetProperty("deviceId").GetString()
#                     displayName = $element.GetProperty("deviceDetail").GetProperty("displayName").GetString()
#                     operatingSystem = $element.GetProperty("deviceDetail").GetProperty("operatingSystem").GetString()
#                     isCompliant = $element.GetProperty("deviceDetail").GetProperty("isCompliant").GetBoolean()
#                     trustType = $element.GetProperty("deviceDetail").GetProperty("trustType").GetString()
#                 }
#             }

#             $signInLogs.Add($signInLog)
#         }

#         # Write-EnhancedLog -Message "Sign-in logs loaded successfully from $JsonFilePath." -Level "INFO" -ForegroundColor ([ConsoleColor]::Green)
#     } catch {
#         Handle-Error -ErrorRecord $_
#     } finally {
#         $fileStream.Dispose()
#     }

#     return $signInLogs
# }













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
        
#         # Write-EnhancedLog -Message "Sign-in logs loaded and filtered successfully from $JsonFilePath." -Level "INFO" -ForegroundColor ([ConsoleColor]::Green)
#         return $filteredLogs
#     } catch {
#         Handle-Error -ErrorRecord $_
#         # return $null
#     }
# }