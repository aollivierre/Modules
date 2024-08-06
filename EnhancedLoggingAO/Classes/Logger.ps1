class Logger {
    [void] LogClassCall([string]$Message, [string]$Level = 'INFO') {
        $callerFunction = ''
        $callerClass = ''

        # Get the PowerShell call stack
        $callStack = Get-PSCallStack

        # Determine the correct index based on the call stack depth
        $stackIndex = if ($callStack.Count -ge 3) { 2 } else { 1 }

        # Capture the calling function if it exists
        if ($callStack.Count -ge $stackIndex + 1) {
            $callerFunction = $callStack[$stackIndex].Command
        }

        # Use .NET stack trace to get the calling class if it exists
        $Loggingstacktrace = [System.Diagnostics.stacktrace]::new($true)
        for ($i = $stackIndex + 1; $i -lt $Loggingstacktrace.FrameCount; $i++) {
            $frame = $Loggingstacktrace.GetFrame($i)
            $methodBase = $frame.GetMethod()
            if ($null -ne $methodBase -and $null -ne $methodBase.DeclaringType) {
                # Check if the declaring type is not a PowerShell internal type
                if ($methodBase.DeclaringType.FullName -notmatch '^System\.|^Microsoft\.') {
                    $callerClass = $methodBase.DeclaringType.FullName
                    break
                }
            }
        }

        $callerInfo = ''
        if ($callerClass) {
            $callerInfo += "[Class: $callerClass] "
        }
        if ($callerFunction) {
            $callerInfo += "[Function: $callerFunction]"
        }

        $formattedMessage = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') $($env:COMPUTERNAME): [$Level] $callerInfo $Message"

        # Set foreground color based on log level
        $ForegroundColor = [ConsoleColor]::White
        switch ($Level) {
            'DEBUG' { $ForegroundColor = [ConsoleColor]::Gray }
            'INFO' { $ForegroundColor = [ConsoleColor]::Green }
            'NOTICE' { $ForegroundColor = [ConsoleColor]::Cyan }
            'WARNING' { $ForegroundColor = [ConsoleColor]::Yellow }
            'ERROR' { $ForegroundColor = [ConsoleColor]::Red }
            'CRITICAL' { $ForegroundColor = [ConsoleColor]::Magenta }
            default { $ForegroundColor = [ConsoleColor]::White }
        }

        # Check if $Host.UI.RawUI.ForegroundColor is accessible
        if ($global:Host -and $global:Host.UI -and $global:Host.UI.RawUI) {
            $currentForegroundColor = $global:Host.UI.RawUI.ForegroundColor
            $global:Host.UI.RawUI.ForegroundColor = $ForegroundColor
            Write-Host $formattedMessage
            $global:Host.UI.RawUI.ForegroundColor = $currentForegroundColor
        } else {
            Write-Host $formattedMessage -ForegroundColor $ForegroundColor
        }
    }
}