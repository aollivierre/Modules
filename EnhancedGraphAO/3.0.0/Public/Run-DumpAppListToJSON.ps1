#the following function work in GUI mode but not in containers and honestly the idea of it having to start a PowerShell session is not vert appealing sure we start seperate powershell sessions all of the time but we need to figure out a way to make it work inside of containers


# function Run-DumpAppListToJSON {
#     [CmdletBinding()]
#     param (
#         [Parameter(Mandatory = $true)]
#         [string]$JsonPath
#     )

#     $scriptContent = @"
# function Dump-AppListToJSON {
#     param (
#         [string]`$JsonPath
#     )

#     try {
#         Disconnect-MgGraph

#         # Connect to Graph interactively
#         Connect-MgGraph -Scopes 'Application.ReadWrite.All' -ErrorAction Stop

#         # Retrieve all application objects
#         `$allApps = Get-MgApplication -ErrorAction Stop

#         # Export to JSON
#         `$allApps | ConvertTo-Json -Depth 10 | Out-File -FilePath `$JsonPath -ErrorAction Stop

#         Write-Host "Application list successfully dumped to JSON at: `$JsonPath"

#     } catch {
#         Write-Error "An error occurred in Dump-AppListToJSON: `$_"
#         $_ | Format-List -Property Message, Exception, ScriptStackTrace
#         throw
#     } finally {
#         Disconnect-MgGraph
#     }
# }

# # Dump application list to JSON
# Dump-AppListToJSON -JsonPath `"$JsonPath`"
# "@

#     try {
#         # Create a temporary file in the temp directory
#         $tempScriptPath = [System.IO.Path]::Combine([System.IO.Path]::GetTempPath(), [System.IO.Path]::GetRandomFileName() + ".ps1")
#         Set-Content -Path $tempScriptPath -Value $scriptContent -ErrorAction Stop

#         # Start a new PowerShell session to run the script and wait for it to complete
#         $startProcessParams = @{
#             FilePath     = "pwsh"
#             ArgumentList = @("-NoProfile", "-NoLogo", "-File", $tempScriptPath)
#             PassThru     = $true
#             ErrorAction  = "Stop"
#         }
#         $process = Start-Process @startProcessParams
#         $process.WaitForExit()

#         if ($process.ExitCode -ne 0) {
#             Write-Error "The PowerShell script process exited with code $($process.ExitCode)."
#             throw "The PowerShell script process exited with an error."
#         }

#         Write-Host "Script executed successfully."

#     } catch {
#         Write-Error "An error occurred in Run-DumpAppListToJSON: $_"
#         $_ | Format-List -Property Message, Exception, ScriptStackTrace
#         throw
#     } finally {
#         # Remove the temporary script file after execution
#         if (Test-Path -Path $tempScriptPath) {
#             Remove-Item -Path $tempScriptPath -ErrorAction Stop
#         }
#     }
# }

# # Example usage
# # Run-DumpAppListToJSON -JsonPath "C:\Path\To\Your\Output.json"
