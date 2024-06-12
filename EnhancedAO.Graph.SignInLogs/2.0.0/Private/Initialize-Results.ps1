# Function to initialize results and unique device IDs
function Initialize-Results {
    return @{
        Results = [System.Collections.Generic.List[PSCustomObject]]::new()
        UniqueDeviceIds = @{}
    }
}