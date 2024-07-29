function Is-ServerCore {
    $explorerPath = "$env:SystemRoot\explorer.exe"

    if (Test-Path $explorerPath) {
        return $false
    } else {
        return $true
    }
}

Is-ServerCore
