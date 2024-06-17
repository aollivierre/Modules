# Function to load sign-in logs from the latest JSON file
function Load-SignInLogs {
    param (
        [Parameter(Mandatory = $true)]
        [string]$JsonFilePath
    )

    $signInLogs = [System.Collections.Generic.List[SignInLog]]::new()
    # $fileStream = [System.IO.File]::OpenRead($JsonFilePath)
    Write-EnhancedLog -Message "Opening file: $JsonFilePath" -Level 'Debug'
    $fileStream = [System.IO.FileStream]::new($JsonFilePath, [System.IO.FileMode]::Open, [System.IO.FileAccess]::Read, [System.IO.FileShare]::Read, 4096, [System.IO.FileOptions]::SequentialScan)

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