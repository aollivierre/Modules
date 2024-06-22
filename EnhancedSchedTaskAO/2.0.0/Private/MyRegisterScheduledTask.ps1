function MyRegisterScheduledTask {

    <#
    .SYNOPSIS
    Registers a scheduled task with the system.
    
    .DESCRIPTION
    This function creates a new scheduled task with the specified parameters, including the name, description, VBScript path, and PowerShell script path. It sets up a basic daily trigger and runs the task as the SYSTEM account with the highest privileges. Enhanced logging is used for status messages and error handling to manage potential issues.
    
    .PARAMETER schtaskName
    The name of the scheduled task to register.
    
    .PARAMETER schtaskDescription
    A description for the scheduled task.
    
    .PARAMETER Path_vbs
    The path to the VBScript file used to run the PowerShell script.
    
    .PARAMETER Path_PSscript
    The path to the PowerShell script to execute.
    
    .PARAMETER PackageExecutionContext
    The context in which the package is being executed.
    
    .PARAMETER RepetitionInterval
    The interval at which the task should be repeated.
    
    .EXAMPLE
    MyRegisterScheduledTask -schtaskName "MyTask" -schtaskDescription "Performs automated checks" -Path_vbs "C:\Scripts\run-hidden.vbs" -Path_PSscript "C:\Scripts\myScript.ps1"
    
    This example registers a new scheduled task named "MyTask" that executes "myScript.ps1" using "run-hidden.vbs".
    #>
    
        [CmdletBinding()]
        param (
            [Parameter(Mandatory = $true)]
            [string]$schtaskName,
    
            [Parameter(Mandatory = $true)]
            [string]$schtaskDescription,
    
            [Parameter(Mandatory = $true)]
            [string]$Path_vbs,
    
            [Parameter(Mandatory = $true)]
            [string]$Path_PSscript,
    
            [Parameter(Mandatory = $true)]
            [string]$PackageExecutionContext,
    
            [Parameter(Mandatory = $true)]
            [string]$RepetitionInterval
        )
    
        try {
            Write-EnhancedLog -Message "Registering scheduled task: $schtaskName" -Level "INFO" -ForegroundColor Magenta
    
            $startTime = (Get-Date).AddMinutes(1).ToString("HH:mm")
    
            try {
                if ($config.UsePSADT) {
                    Write-EnhancedLog -Message "Setting up Scheduled Task action for Service UI and PSADT" -Level "INFO" -ForegroundColor Magenta
    
                    $ToolkitExecutable = "$Path_PR\Private\PSAppDeployToolkit\Toolkit\Deploy-Application.exe"
                    $ServiceUIExecutable = "$Path_PR\Private\ServiceUI.exe"
                    $DeploymentType = "install"
                    $argList = "-process:explorer.exe `"$ToolkitExecutable`" -DeploymentType $DeploymentType"
                    $action = New-ScheduledTaskAction -Execute $ServiceUIExecutable -Argument $argList
                } else {
                    Write-EnhancedLog -Message "Setting up Scheduled Task action for wscript and VBS" -Level "INFO" -ForegroundColor Magenta
    
                    $argList = "`"$Path_vbs`" `"$Path_PSscript`""
                    $action = New-ScheduledTaskAction -Execute "C:\Windows\System32\wscript.exe" -Argument $argList
                }
            } catch {
                Write-EnhancedLog -Message "An error occurred while setting up the task action: $_" -Level "ERROR" -ForegroundColor Red
                Handle-Error -ErrorRecord $_
                throw $_
            }
    
            try {
                if ($config.TriggerType -eq "Daily") {
                    $trigger = New-ScheduledTaskTrigger -Daily -At $startTime
                    Write-EnhancedLog -Message "Trigger set to Daily at $startTime" -Level "INFO"
                } elseif ($config.TriggerType -eq "Logon") {
                    if (-not $config.LogonUserId) {
                        throw "LogonUserId must be specified for Logon trigger type."
                    }
                    $trigger = New-ScheduledTaskTrigger -AtLogOn
                    Write-EnhancedLog -Message "Trigger set to logon of user $($config.LogonUserId)" -Level "INFO"
                } else {
                    throw "Invalid TriggerType specified in the configuration."
                }
            } catch {
                Write-EnhancedLog -Message "An error occurred while setting up the task trigger: $_" -Level "ERROR" -ForegroundColor Red
                Handle-Error -ErrorRecord $_
                throw $_
            }
    
            try {
                $principal = New-ScheduledTaskPrincipal -UserId "NT AUTHORITY\SYSTEM" -LogonType ServiceAccount -RunLevel Highest
    
                if ($config.RunOnDemand -eq $true) {
                    Write-EnhancedLog -Message "Registering task with RunOnDemand set to $($config.RunOnDemand)" -Level "INFO"
                    $task = Register-ScheduledTask -TaskName $schtaskName -Action $action -Principal $principal -Description $schtaskDescription -Force
                    $task = Get-ScheduledTask -TaskName $schtaskName
                } else {
                    Write-EnhancedLog -Message "Registering task with triggers" -Level "INFO"
                    $task = Register-ScheduledTask -TaskName $schtaskName -Action $action -Trigger $trigger -Principal $principal -Description $schtaskDescription -Force
                    Write-EnhancedLog -Message "Updating task repetition interval to $RepetitionInterval" -Level "INFO"
                    $task = Get-ScheduledTask -TaskName $schtaskName
                    $task.Triggers[0].Repetition.Interval = $RepetitionInterval
                    $task | Set-ScheduledTask
                }
            } catch {
                Write-EnhancedLog -Message "An error occurred while registering the scheduled task: $_" -Level "ERROR" -ForegroundColor Red
                Handle-Error -ErrorRecord $_
                throw $_
            }
    
            try {
                if ($PackageExecutionContext -eq "User") {
                    $ShedService = New-Object -ComObject 'Schedule.Service'
                    $ShedService.Connect()
                    $taskFolder = $ShedService.GetFolder("\")
                    $Task = $taskFolder.GetTask("$schtaskName")
                    $taskFolder.RegisterTaskDefinition("$schtaskName", $Task.Definition, 6, 'Users', $null, 4)
                    Write-EnhancedLog -Message "Task registered with user context" -Level "INFO"
                } else {
                    Write-Host "Execution context is not set to 'User', skipping this block."
                }
            } catch {
                Write-EnhancedLog -Message "An error occurred while setting execution context for the scheduled task: $_" -Level "ERROR" -ForegroundColor Red
                Handle-Error -ErrorRecord $_
                throw $_
            }
    
            Write-EnhancedLog -Message "Scheduled task $schtaskName registered successfully." -Level "INFO" -ForegroundColor Green
        } catch {
            Write-EnhancedLog -Message "An error occurred while registering the scheduled task: $_" -Level "ERROR" -ForegroundColor Red
            Handle-Error -ErrorRecord $_
            throw $_
        }
    }
    