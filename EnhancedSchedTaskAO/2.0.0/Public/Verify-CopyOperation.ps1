
function Verify-CopyOperation {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [string]$SourcePath,

        [Parameter(Mandatory = $true)]
        [string]$DestinationPath
    )

    begin {
        Write-EnhancedLog -Message "Verifying copy operation..." -Level "INFO" -ForegroundColor ([System.ConsoleColor]::Cyan)
        $sourceItems = Get-ChildItem -Path $SourcePath -Recurse
        $destinationItems = Get-ChildItem -Path $DestinationPath -Recurse

        # Use a generic list for better performance compared to using an array with +=
        $verificationResults = New-Object System.Collections.Generic.List[Object]
    }

    process {
        try {
            foreach ($item in $sourceItems) {
                $relativePath = $item.FullName.Substring($SourcePath.Length)
                $correspondingPath = Join-Path -Path $DestinationPath -ChildPath $relativePath

                if (-not (Test-Path -Path $correspondingPath)) {
                    $verificationResults.Add([PSCustomObject]@{
                            Status       = "Missing"
                            SourcePath   = $item.FullName
                            ExpectedPath = $correspondingPath
                        })
                }
            }

            foreach ($item in $destinationItems) {
                $relativePath = $item.FullName.Substring($DestinationPath.Length)
                $correspondingPath = Join-Path -Path $SourcePath -ChildPath $relativePath

                if (-not (Test-Path -Path $correspondingPath)) {
                    $verificationResults.Add([PSCustomObject]@{
                            Status     = "Extra"
                            SourcePath = $correspondingPath
                            ActualPath = $item.FullName
                        })
                }
            }
        }
        catch {
            Write-EnhancedLog -Message "Error during verification process: $_" -Level "ERROR" -ForegroundColor ([System.ConsoleColor]::Red)
        }
    }

    end {
        if ($verificationResults.Count -gt 0) {
            Write-EnhancedLog -Message "Discrepancies found. See detailed log." -Level "WARNING" -ForegroundColor ([System.ConsoleColor]::Yellow)
            $verificationResults | Format-Table -AutoSize | Out-String | ForEach-Object { 
                Write-EnhancedLog -Message $_ -Level "INFO" 
            }
        }
        else {
            Write-EnhancedLog -Message "All items verified successfully. No discrepancies found." -Level "INFO" -ForegroundColor ([System.ConsoleColor]::Green)
        }

        Write-EnhancedLog -Message ("Total items in source: " + $sourceItems.Count) -Level "INFO" -ForegroundColor ([System.ConsoleColor]::Cyan)
        Write-EnhancedLog -Message ("Total items in destination: " + $destinationItems.Count) -Level "INFO" -ForegroundColor ([System.ConsoleColor]::Cyan)
    }
}