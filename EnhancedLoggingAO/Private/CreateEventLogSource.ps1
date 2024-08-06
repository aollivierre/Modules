function CreateEventLogSource($logName, $EventSource) {
    try {
        if ($PSVersionTable.PSVersion.Major -lt 6) {
            New-EventLog -LogName $logName -Source $EventSource
        }
        else {
            [System.Diagnostics.EventLog]::CreateEventSource($EventSource, $logName)
        }
        Write-Host "Event source '$EventSource' created in log '$logName'" -ForegroundColor Green
    }
    catch {
        Write-Warning "Error creating the event log. Make sure you run PowerShell as an Administrator."
    }
}