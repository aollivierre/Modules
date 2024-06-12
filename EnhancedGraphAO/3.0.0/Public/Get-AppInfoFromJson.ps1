function Get-AppInfoFromJson {
    param (
        [Parameter(Mandatory = $true)]
        [string]$jsonPath
    )

    # Check if the file exists
    if (-Not (Test-Path -Path $jsonPath)) {
        Write-Error "The file at path '$jsonPath' does not exist."
        return
    }

    # Read the JSON content from the file
    $jsonContent = Get-Content -Path $jsonPath -Raw

    # Convert the JSON content to a PowerShell object
    $appData = ConvertFrom-Json -InputObject $jsonContent

    # Extract the required information
    $extractedData = $appData | ForEach-Object {
        [PSCustomObject]@{
            Id              = $_.Id
            DisplayName     = $_.DisplayName
            AppId           = $_.AppId
            SignInAudience  = $_.SignInAudience
            PublisherDomain = $_.PublisherDomain
        }
    }

    # Return the extracted data
    return $extractedData
}
