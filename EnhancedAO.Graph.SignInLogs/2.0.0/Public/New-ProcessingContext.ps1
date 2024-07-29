# Function to create a ProcessingContext object

function New-ProcessingContext {
    [PSCustomObject]@{
        UniqueDeviceIds = [System.Collections.Generic.HashSet[string]]::new()
        Results = [System.Collections.Generic.List[PSCustomObject]]::new()
        # ProcessedUserDeviceIds = [System.Collections.Generic.Dictionary[string, System.Collections.Generic.HashSet[string]]]::new()
    }
}

