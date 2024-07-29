function Invoke-Uninstall {
    [CmdletBinding()]
    param (
        [string]$ProductId,
        [string]$FilePath,
        [string]$ArgumentTemplate
    )

    begin {
        Write-EnhancedLog -Message 'Starting Invoke-Uninstall function' -Level 'INFO'
        Log-Params -Params $PSCmdlet.MyInvocation.BoundParameters
    }

    process {
        try {
            Write-EnhancedLog -Message 'Starting uninstallation process.' -Level 'INFO'

            # Ensure the ProductId is wrapped in curly braces
            $wrappedProductId = "{$ProductId}"
            # Construct the argument list using the template
            $arguments = $ArgumentTemplate -replace '{ProductId}', $wrappedProductId

            Write-EnhancedLog -Message "FilePath: $FilePath" -Level 'INFO'
            Write-EnhancedLog -Message "Arguments: $arguments" -Level 'INFO'

            Start-Process -FilePath $FilePath -ArgumentList $arguments -Wait -WindowStyle Hidden

            Write-EnhancedLog -Message "Executed uninstallation with arguments: $arguments" -Level 'INFO'
        } catch {
            Write-EnhancedLog -Message "An error occurred during the uninstallation process: $($_.Exception.Message)" -Level 'ERROR'
            Handle-Error -ErrorRecord $_
        }
    }

    end {
        Write-EnhancedLog -Message 'Invoke-Uninstall function completed' -Level 'INFO'
    }
}

# # Example usage of Invoke-Uninstall function with splatting
# $params = @{
#     ProductId = '0DC51760-4FB7-41F3-8967-D3DEC9D320EB'
#     FilePath = 'MsiExec.exe'
#     ArgumentTemplate = "/X{ProductId} /quiet /norestart"
# }
# Invoke-Uninstall @params
