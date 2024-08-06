{
  GUID = "7d39a168-928c-46a4-98e5-8323c42caed5",
  FunctionsToExport = [
    "Add-Step",
    "Export-Data",
    "Handle-Error",
    "Initialize-ScriptAndLogging",
    "Log-And-Execute-Step",
    "Log-Params",
    "Write-EnhancedLog"
  ],
  VariablesToExport = [],
  Description = "Enhanced logging module for PowerShell scripts.",
  PrivateData = {
    PSData = {
      Tags = [
        "Logging",
        "PowerShell",
        "Enhanced"
      ],
      LicenseUri = "https://your-license-url",
      ProjectUri = "https://your-project-url"
    }
  },
  ModuleVersion = "1.0.0",
  RootModule = "EnhancedLoggingAO.psm1",
  Author = "Abdullah Ollivierre",
  PowerShellVersion = "5.1",
  AliasesToExport = [],
  NestedModules = [
    "Public\\Add-Step.ps1",
    "Public\\Export-Data.ps1",
    "Public\\Handle-Error.ps1",
    "Public\\Initialize-ScriptAndLogging.ps1",
    "Public\\Log-And-Execute-Step.ps1",
    "Public\\Log-Params.ps1",
    "Public\\Write-EnhancedLog.ps1",
    "Private\\AppendCSVLog.ps1",
    "Private\\CreateEventSourceAndLog.ps1",
    "Private\\Export-EventLog.ps1",
    "Private\\Initialize-CSVDirectory.ps1",
    "Private\\Write-EventLogMessage.ps1"
  ],
  Copyright = "Your Company. All rights reserved.",
  CompatiblePSEditions = [
    "Core",
    "Desktop"
  ],
  CompanyName = "Your Company",
  CmdletsToExport = []
}

