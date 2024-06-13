# Function to add result to the context
# function Add-Result {
#     param (
#         [Parameter(Mandatory = $true)]
#         [hashtable]$Context,
#         [Parameter(Mandatory = $true)]
#         [PSCustomObject]$Item,
#         [Parameter(Mandatory = $true)]
#         [string]$DeviceId,
#         [Parameter(Mandatory = $true)]
#         [string]$DeviceState,
#         [Parameter(Mandatory = $true)]
#         [bool]$HasPremiumLicense
#     )

#     try {
#         $deviceName = $Item.deviceDetail.displayName
#         if ([string]::IsNullOrWhiteSpace($deviceName)) {
#             $deviceName = "BYOD"
#         }

#         $Context.Results.Add([PSCustomObject]@{
#             'DeviceName'             = $deviceName
#             'UserName'               = $Item.userDisplayName
#             'DeviceEntraID'          = $DeviceId
#             'UserEntraID'            = $Item.userId
#             'DeviceOS'               = $Item.deviceDetail.operatingSystem
#             'DeviceComplianceStatus' = if ($Item.deviceDetail.isCompliant) { "Compliant" } else { "Non-Compliant" }
#             'DeviceStateInIntune'    = $DeviceState
#             'TrustType'              = $Item.deviceDetail.trustType
#             'UserLicense'            = if ($HasPremiumLicense) { "Microsoft 365 Business Premium" } else { "Other" }
#         })

#         # Write-EnhancedLog -Message "Successfully added result for device: $deviceName for user: $($Item.userDisplayName)" -Level "INFO" -ForegroundColor ([ConsoleColor]::Green)
#     } catch {
#         Handle-Error -ErrorRecord $_
#         Write-EnhancedLog -Message "Failed to add result for device: $($Item.deviceDetail.displayName)" -Level "ERROR" -ForegroundColor ([ConsoleColor]::Red)
#     }
# }




# function Add-Result {
#     param (
#         [Parameter(Mandatory = $true)]
#         [hashtable]$Context,
#         [Parameter(Mandatory = $true)]
#         [PSCustomObject]$Item,
#         [Parameter(Mandatory = $true)]
#         [string]$DeviceId,
#         [Parameter(Mandatory = $true)]
#         [string]$DeviceState,
#         [Parameter(Mandatory = $true)]
#         [bool]$HasPremiumLicense
#     )

#     try {
#         $deviceName = $Item.deviceDetail.displayName
#         if ([string]::IsNullOrWhiteSpace($deviceName)) {
#             $deviceName = "BYOD"
#         }

#         # Using .NET Dictionary for result
#         $result = [System.Collections.Generic.Dictionary[string, object]]::new()
#         $result.Add('DeviceName', $deviceName)
#         $result.Add('UserName', $Item.userDisplayName)
#         $result.Add('DeviceEntraID', $DeviceId)
#         $result.Add('UserEntraID', $Item.userId)
#         $result.Add('DeviceOS', $Item.deviceDetail.operatingSystem)
#         $result.Add('DeviceComplianceStatus', if ($Item.deviceDetail.isCompliant) { "Compliant" } else { "Non-Compliant" })
#         $result.Add('DeviceStateInIntune', $DeviceState)
#         $result.Add('TrustType', $Item.deviceDetail.trustType)
#         $result.Add('UserLicense', if ($HasPremiumLicense) { "Microsoft 365 Business Premium" } else { "Other" })

#         $Context.Results.Add($result)

#         Write-EnhancedLog -Message "Successfully added result for device: $deviceName for user: $($Item.userDisplayName)" -Level "INFO" -ForegroundColor ([ConsoleColor]::Green)
#     } catch {
#         Handle-Error -ErrorRecord $_
#         Write-EnhancedLog -Message "Failed to add result for device: $($Item.deviceDetail.displayName)" -Level "ERROR" -ForegroundColor ([ConsoleColor]::Red)
#     }
# }

# # Initialize the context with a thread-safe results collection
# $context = @{
#     Results = [System.Collections.Concurrent.ConcurrentBag[System.Collections.Generic.Dictionary[string, object]]]::new()
# }

# # Usage Example
# # Load the sign-in logs from a JSON file
# $signInLogs = Load-SignInLogs -JsonFilePath "path\to\your\jsonfile.json"

# # Iterate through each log and add the result
# foreach ($log in $signInLogs) {
#     Add-Result -Context $context -Item $log -DeviceId "someDeviceId" -DeviceState "Active" -HasPremiumLicense $true
# }

# # Output the results
# $context.Results




# function Add-Result {
#     param (
#         [Parameter(Mandatory = $true)]
#         [hashtable]$Context,
#         [Parameter(Mandatory = $true)]
#         [PSCustomObject]$Item,
#         [Parameter(Mandatory = $true)]
#         [string]$DeviceId,
#         [Parameter(Mandatory = $true)]
#         [string]$DeviceState,
#         [Parameter(Mandatory = $true)]
#         [bool]$HasPremiumLicense
#     )

#     try {
#         $deviceName = $Item.deviceDetail.displayName
#         if ([string]::IsNullOrWhiteSpace($deviceName)) {
#             $deviceName = "BYOD"
#         }

#         # Determine the compliance status
#         $complianceStatus = if ($Item.deviceDetail.isCompliant) { "Compliant" } else { "Non-Compliant" }

#         # Determine the user license
#         $userLicense = if ($HasPremiumLicense) { "Microsoft 365 Business Premium" } else { "Other" }

#         # Using .NET Dictionary for result
#         $result = [System.Collections.Generic.Dictionary[string, object]]::new()
#         $result.Add('DeviceName', $deviceName)
#         $result.Add('UserName', $Item.userDisplayName)
#         $result.Add('DeviceEntraID', $DeviceId)
#         $result.Add('UserEntraID', $Item.userId)
#         $result.Add('DeviceOS', $Item.deviceDetail.operatingSystem)
#         $result.Add('DeviceComplianceStatus', $complianceStatus)
#         $result.Add('DeviceStateInIntune', $DeviceState)
#         $result.Add('TrustType', $Item.deviceDetail.trustType)
#         $result.Add('UserLicense', $userLicense)

#         $Context.Results.Add($result)

#         Write-EnhancedLog -Message "Successfully added result for device: $deviceName for user: $($Item.userDisplayName)" -Level "INFO" -ForegroundColor ([ConsoleColor]::Green)
#     } catch {
#         Handle-Error -ErrorRecord $_
#         Write-EnhancedLog -Message "Failed to add result for device: $($Item.deviceDetail.displayName)" -Level "ERROR" -ForegroundColor ([ConsoleColor]::Red)
#     }
# }

# # Initialize the context with a thread-safe results collection
# $context = @{
#     Results = [System.Collections.Concurrent.ConcurrentBag[System.Collections.Generic.Dictionary[string, object]]]::new()
# }

# # Usage Example
# # Load the sign-in logs from a JSON file
# $signInLogs = Load-SignInLogs -JsonFilePath "path\to\your\jsonfile.json"

# # Iterate through each log and add the result
# foreach ($log in $signInLogs) {
#     Add-Result -Context $context -Item $log -DeviceId "someDeviceId" -DeviceState "Active" -HasPremiumLicense $true
# }

# # Output the results
# $context.Results









class Result {
    [string]$DeviceName
    [string]$UserName
    [string]$DeviceEntraID
    [string]$UserEntraID
    [string]$DeviceOS
    [string]$DeviceComplianceStatus
    [string]$DeviceStateInIntune
    [string]$TrustType
    [string]$UserLicense

    Result([string]$deviceName, [string]$userName, [string]$deviceEntraID, [string]$userEntraID, [string]$deviceOS, [string]$deviceComplianceStatus, [string]$deviceStateInIntune, [string]$trustType, [string]$userLicense) {
        $this.DeviceName = $deviceName
        $this.UserName = $userName
        $this.DeviceEntraID = $deviceEntraID
        $this.UserEntraID = $userEntraID
        $this.DeviceOS = $deviceOS
        $this.DeviceComplianceStatus = $deviceComplianceStatus
        $this.DeviceStateInIntune = $deviceStateInIntune
        $this.TrustType = $trustType
        $this.UserLicense = $userLicense
    }
}






function Add-Result {
    param (
        [Parameter(Mandatory = $true)]
        [hashtable]$Context,
        [Parameter(Mandatory = $true)]
        [PSCustomObject]$Item,
        [Parameter(Mandatory = $true)]
        [string]$DeviceId,
        [Parameter(Mandatory = $true)]
        [string]$DeviceState,
        [Parameter(Mandatory = $true)]
        [bool]$HasPremiumLicense
    )

    try {
        $deviceName = $Item.deviceDetail.displayName
        if ([string]::IsNullOrWhiteSpace($deviceName)) {
            $deviceName = "BYOD"
        }

        # Determine the compliance status
        $complianceStatus = if ($Item.deviceDetail.isCompliant) { "Compliant" } else { "Non-Compliant" }

        # Determine the user license
        $userLicense = if ($HasPremiumLicense) { "Microsoft 365 Business Premium" } else { "Other" }

        # Create a new Result object
        $result = [Result]::new(
            $deviceName,
            $Item.userDisplayName,
            $DeviceId,
            $Item.userId,
            $Item.deviceDetail.operatingSystem,
            $complianceStatus,
            $DeviceState,
            $Item.deviceDetail.trustType,
            $userLicense
        )

        $Context.Results.Add($result)

        Write-EnhancedLog -Message "Successfully added result for device: $deviceName for user: $($Item.userDisplayName)" -Level "INFO" -ForegroundColor ([ConsoleColor]::Green)
    } catch {
        Handle-Error -ErrorRecord $_
        Write-EnhancedLog -Message "Failed to add result for device: $($Item.deviceDetail.displayName)" -Level "ERROR" -ForegroundColor ([ConsoleColor]::Red)
    }
}

# Initialize the context with a thread-safe results collection
# $context = @{
#     Results = [System.Collections.Concurrent.ConcurrentBag[Result]]::new()
# }

# Usage Example
# Load the sign-in logs from a JSON file
# $signInLogs = Load-SignInLogs -JsonFilePath "path\to\your\jsonfile.json"

# Define the parameters for parallel processing
# $parallelParams = @{
#     Context = $context
#     DeviceId = "someDeviceId"
#     DeviceState = "Active"
#     HasPremiumLicense = $true
# }

# # Process logs in parallel
# $signInLogs | ForEach-Object -Parallel {
#     param (
#         $log,
#         $parallelParams
#     )
#     Add-Result -Context $parallelParams.Context -Item $log -DeviceId $parallelParams.DeviceId -DeviceState $parallelParams.DeviceState -HasPremiumLicense $parallelParams.HasPremiumLicense
# } -ArgumentList $_, $parallelParams

# # Output the results
# $context.Results
