# Function to initialize results and unique device IDs
# function Initialize-Results {
#     return @{
#         # Results = [System.Collections.Generic.List[PSCustomObject]]::new()

#         # $context = @{
#             Results = [System.Collections.Concurrent.ConcurrentBag[Result]]::new()
#         # }

#         UniqueDeviceIds = @{}
#     }
# }

# class Result {
#     [string]$DeviceName
#     [string]$UserName
#     [string]$DeviceEntraID
#     [string]$UserEntraID
#     [string]$DeviceOS
#     [string]$DeviceComplianceStatus
#     [string]$DeviceStateInIntune
#     [string]$TrustType
#     [string]$UserLicense

#     Result([string]$deviceName, [string]$userName, [string]$deviceEntraID, [string]$userEntraID, [string]$deviceOS, [string]$deviceComplianceStatus, [string]$deviceStateInIntune, [string]$trustType, [string]$userLicense) {
#         $this.DeviceName = $deviceName
#         $this.UserName = $userName
#         $this.DeviceEntraID = $deviceEntraID
#         $this.UserEntraID = $userEntraID
#         $this.DeviceOS = $deviceOS
#         $this.DeviceComplianceStatus = $deviceComplianceStatus
#         $this.DeviceStateInIntune = $deviceStateInIntune
#         $this.TrustType = $trustType
#         $this.UserLicense = $userLicense
#     }
# }



# function Initialize-Results {
#     $context = @{
#         Results = [System.Collections.Concurrent.ConcurrentBag[Result]]::new()
#         UniqueDeviceIds = [System.Collections.Concurrent.ConcurrentDictionary[string, bool]]::new()
#     }
#     return $context
# }

# class Result {
#     [string]$Property1
#     [string]$Property2

#     Result([string]$property1, [string]$property2) {
#         $this.Property1 = $property1
#         $this.Property2 = $property2
#     }
# }


function Initialize-Results {
    $context = @{
        Results = [System.Collections.Generic.List[Result]]::new()
        UniqueDeviceIds = [System.Collections.Generic.Dictionary[string, bool]]::new()
    }
    return $context
}



# # Initialize the context
# $context = Initialize-Results

# # Add results to the context
# $context.Results.Add([Result]::new("Value1", "Value2"))
# $context.Results.Add([Result]::new("Value3", "Value4"))

# # Add unique device IDs
# $context.UniqueDeviceIds["device123"] = $true
# $context.UniqueDeviceIds["device456"] = $true

# # Output the context to ensure it is set up correctly
# $context
