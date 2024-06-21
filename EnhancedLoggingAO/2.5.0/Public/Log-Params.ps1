
function Log-Params {
    param (
        [hashtable]$Params
    )

    foreach ($key in $Params.Keys) {
        Write-EnhancedLog "$key $($Params[$key])" -Color Yellow
    }
}
