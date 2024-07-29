function Initialize-Context {
    param (
        [Parameter(Mandatory = $true)]
        [PSCustomObject]$Context
    )

    if (-not $Context.UniqueDeviceIds) {
        $Context.UniqueDeviceIds = [System.Collections.Generic.HashSet[string]]::new()
    }
}