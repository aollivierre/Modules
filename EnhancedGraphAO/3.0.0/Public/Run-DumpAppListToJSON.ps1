
# function Run-DumpAppListToJSON {
#     param (
#         [string]$JsonPath
#     )

#     $scriptContent = @"
# function Dump-AppListToJSON {
#     param (
#         [string]`$JsonPath
#     )


#     Disconnect-MgGraph

#     # Connect to Graph interactively
#     Connect-MgGraph -Scopes 'Application.ReadWrite.All'

#     # Retrieve all application objects
#     `$allApps = Get-MgApplication

#     # Export to JSON
#     `$allApps | ConvertTo-Json -Depth 10 | Out-File -FilePath `$JsonPath
# }

# # Dump application list to JSON
# Dump-AppListToJSON -JsonPath `"$JsonPath`"
# "@

#     # Write the script content to a temporary file
#     $tempScriptPath = [System.IO.Path]::Combine($PSScriptRoot, "DumpAppListTemp.ps1")
#     Set-Content -Path $tempScriptPath -Value $scriptContent

#     # Start a new PowerShell session to run the script and wait for it to complete
#     $process = Start-Process pwsh -ArgumentList "-NoProfile", "-NoLogo", "-File", $tempScriptPath -PassThru
#     $process.WaitForExit()

#     # Remove the temporary script file after execution
#     Remove-Item -Path $tempScriptPath
# }



# function Run-DumpAppListToJSON {
#     param (
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
#         Get-Error | Select-Object -Property Message, Exception, ScriptStackTrace | Format-List
#         throw
#     } finally {
#         Disconnect-MgGraph
#     }
# }

# # Dump application list to JSON
# Dump-AppListToJSON -JsonPath `"$JsonPath`"
# "@

#     try {
#         # Write the script content to a temporary file
#         $tempScriptPath = [System.IO.Path]::Combine($PSScriptRoot, "DumpAppListTemp.ps1")
#         Set-Content -Path $tempScriptPath -Value $scriptContent -ErrorAction Stop

#         # Start a new PowerShell session to run the script and wait for it to complete
#         $process = Start-Process pwsh -ArgumentList "-NoProfile", "-NoLogo", "-File", $tempScriptPath -PassThru -ErrorAction Stop
#         $process.WaitForExit()

#         if ($process.ExitCode -ne 0) {
#             Write-Error "The PowerShell script process exited with code $($process.ExitCode)."
#             throw "The PowerShell script process exited with an error."
#         }

#         Write-Host "Script executed successfully."

#     } catch {
#         Write-Error "An error occurred in Run-DumpAppListToJSON: `$_"
#         Get-Error | Select-Object -Property Message, Exception, ScriptStackTrace | Format-List
#         throw
#     } finally {
#         # Remove the temporary script file after execution
#         if (Test-Path -Path $tempScriptPath) {
#             Remove-Item -Path $tempScriptPath -ErrorAction Stop
#         }
#     }
# }


function Run-DumpAppListToJSON {
    param (
        [string]$JsonPath
    )

    $scriptContent = @"
function Dump-AppListToJSON {
    param (
        [string]`$JsonPath
    )

    try {
        Disconnect-MgGraph

        # Connect to Graph interactively
        Connect-MgGraph -Scopes 'Application.ReadWrite.All' -ErrorAction Stop

        # Retrieve all application objects
        `$allApps = Get-MgApplication -ErrorAction Stop

        # Export to JSON
        `$allApps | ConvertTo-Json -Depth 10 | Out-File -FilePath `$JsonPath -ErrorAction Stop

        Write-Host "Application list successfully dumped to JSON at: `$JsonPath"

    } catch {
        Write-Error "An error occurred in Dump-AppListToJSON: `$_"
        Get-Error | Select-Object -Property Message, Exception, ScriptStackTrace | Format-List
        throw
    } finally {
        Disconnect-MgGraph
    }
}

# Dump application list to JSON
Dump-AppListToJSON -JsonPath `"$JsonPath`"
"@

    try {
        # Create a temporary file in /tmp directory
        $tempScriptPath = [System.IO.Path]::Combine("/tmp", [System.IO.Path]::GetRandomFileName() + ".ps1")
        Set-Content -Path $tempScriptPath -Value $scriptContent -ErrorAction Stop

        # Start a new PowerShell session to run the script and wait for it to complete
        $process = Start-Process pwsh -ArgumentList "-NoProfile", "-NoLogo", "-File", $tempScriptPath -PassThru -ErrorAction Stop
        $process.WaitForExit()

        if ($process.ExitCode -ne 0) {
            Write-Error "The PowerShell script process exited with code $($process.ExitCode)."
            throw "The PowerShell script process exited with an error."
        }

        Write-Host "Script executed successfully."

    } catch {
        Write-Error "An error occurred in Run-DumpAppListToJSON: `$_"
        Get-Error | Select-Object -Property Message, Exception, ScriptStackTrace | Format-List
        throw
    } finally {
        # Remove the temporary script file after execution
        if (Test-Path -Path $tempScriptPath) {
            Remove-Item -Path $tempScriptPath -ErrorAction Stop
        }
    }
}


