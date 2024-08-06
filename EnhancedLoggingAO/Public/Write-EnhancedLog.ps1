

function Write-EnhancedLog {

    # Example usage:
    # class TestClass {
    #     [Logger]$logger

    #     TestClass() {
    #         $this.logger = [Logger]::new()
    #     }

    #     [void] TestMethod() {
    #         Write-EnhancedLog -Message "This is a test message from TestClass."
    #     }
    # }

    # Direct call to Write-EnhancedLog for testing
    # Write-EnhancedLog -Message "This is a direct test message."

    # $testInstance = [TestClass]::new()
    # $testInstance.TestMethod()

    param (
        [string]$Message,
        [string]$Level = 'INFO',
        [ConsoleColor]$ForegroundColor = [ConsoleColor]::White,
        [switch]$UseModule = $false
    )

    $logger = [Logger]::new()
    $logger.LogClassCall($Message, $Level)
}