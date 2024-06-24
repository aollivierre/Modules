#First, load secrets and create a credential object:
# Assuming secrets.json is in the same directory as your script
# $secretsPath = Join-Path -Path $PSScriptRoot -ChildPath "secrets.json"

# Load the secrets from the JSON file
# $secrets = Get-Content -Path $secretsPath -Raw | ConvertFrom-Json

# Read configuration from the JSON file
# Assign values from JSON to variables

# Read configuration from the JSON file
$configPath = Join-Path -Path $PSScriptRoot -ChildPath "config.json"
$env:MYMODULE_CONFIG_PATH = $configPath

$config = Get-Content -Path $configPath -Raw | ConvertFrom-Json

#  Variables from JSON file
# $tenantId = $secrets.tenantId
# $clientId = $secrets.clientId

# $certPath = Join-Path -Path $PSScriptRoot -ChildPath 'graphcert.pfx'
# $CertPassword = $secrets.CertPassword
# $siteObjectId = $secrets.SiteObjectId
# $documentDriveName = $secrets.DocumentDriveName


function Initialize-Environment {
    param (
        [string]$WindowsModulePath = "EnhancedBoilerPlateAO\2.0.0\EnhancedBoilerPlateAO.psm1",
        [string]$LinuxModulePath = "/usr/src/code/Modules/EnhancedBoilerPlateAO/2.0.0/EnhancedBoilerPlateAO.psm1"
    )

    function Get-Platform {
        if ($PSVersionTable.PSVersion.Major -ge 7) {
            return $PSVersionTable.Platform
        }
        else {
            return [System.Environment]::OSVersion.Platform
        }
    }

    function Setup-GlobalPaths {
        if ($env:DOCKER_ENV -eq $true) {
            $global:scriptBasePath = $env:SCRIPT_BASE_PATH
            $global:modulesBasePath = $env:MODULES_BASE_PATH
        }
        else {
            $global:scriptBasePath = $PSScriptRoot
            $global:modulesBasePath = "$PSScriptRoot\modules"
        }
    }

    function Setup-WindowsEnvironment {
        # Get the base paths from the global variables
        Setup-GlobalPaths

        # Construct the paths dynamically using the base paths
        $global:modulePath = Join-Path -Path $modulesBasePath -ChildPath $WindowsModulePath
        $global:AOscriptDirectory = Join-Path -Path $scriptBasePath -ChildPath "Win32Apps-DropBox"
        $global:directoryPath = Join-Path -Path $scriptBasePath -ChildPath "Win32Apps-DropBox"
        $global:Repo_Path = $scriptBasePath
        $global:Repo_winget = "$Repo_Path\Win32Apps-DropBox"


        # Import the module using the dynamically constructed path
        Import-Module -Name $global:modulePath -Verbose -Force:$true -Global:$true

        # Log the paths to verify
        Write-Output "Module Path: $global:modulePath"
        Write-Output "Repo Path: $global:Repo_Path"
        Write-Output "Repo Winget Path: $global:Repo_winget"
    }

    function Setup-LinuxEnvironment {
        # Get the base paths from the global variables
        Setup-GlobalPaths

        # Import the module using the Linux path
        Import-Module $LinuxModulePath -Verbose

        # Convert paths from Windows to Linux format
        $global:AOscriptDirectory = Convert-WindowsPathToLinuxPath -WindowsPath "C:\Users\Admin-Abdullah\AppData\Local\Intune-Win32-Deployer"
        $global:directoryPath = Convert-WindowsPathToLinuxPath -WindowsPath "C:\Users\Admin-Abdullah\AppData\Local\Intune-Win32-Deployer\Win32Apps-DropBox"
        $global:Repo_Path = Convert-WindowsPathToLinuxPath -WindowsPath "C:\Users\Admin-Abdullah\AppData\Local\Intune-Win32-Deployer"
        $global:Repo_winget = "$global:Repo_Path\Win32Apps-DropBox"
    }

    $platform = Get-Platform
    if ($platform -eq 'Win32NT' -or $platform -eq [System.PlatformID]::Win32NT) {
        Setup-WindowsEnvironment
    }
    elseif ($platform -eq 'Unix' -or $platform -eq [System.PlatformID]::Unix) {
        Setup-LinuxEnvironment
    }
    else {
        throw "Unsupported operating system"
    }
}

# Call the function to initialize the environment
Initialize-Environment


# Example usage of global variables outside the function
Write-Output "Global variables set by Initialize-Environment:"
Write-Output "scriptBasePath: $scriptBasePath"
Write-Output "modulesBasePath: $modulesBasePath"
Write-Output "modulePath: $modulePath"
Write-Output "AOscriptDirectory: $AOscriptDirectory"
Write-Output "directoryPath: $directoryPath"
Write-Output "Repo_Path: $Repo_Path"
Write-Output "Repo_winget: $Repo_winget"

#################################################################################################################################
################################################# END VARIABLES #################################################################
#################################################################################################################################

###############################################################################################################################
############################################### START MODULE LOADING ##########################################################
###############################################################################################################################

<#
.SYNOPSIS
Dot-sources all PowerShell scripts in the 'private' folder relative to the script root.

.DESCRIPTION
This function finds all PowerShell (.ps1) scripts in a 'private' folder located in the script root directory and dot-sources them. It logs the process, including any errors encountered, with optional color coding.

.EXAMPLE
Dot-SourcePrivateScripts

Dot-sources all scripts in the 'private' folder and logs the process.

.NOTES
Ensure the Write-EnhancedLog function is defined before using this function for logging purposes.
#>


Write-Host "Starting to call Get-ModulesFolderPath..."

# Store the outcome in $ModulesFolderPath
try {
  
    $ModulesFolderPath = Get-ModulesFolderPath -WindowsPath "C:\code\modules" -UnixPath "/usr/src/code/modules"
    # $ModulesFolderPath = Get-ModulesFolderPath -WindowsPath "$PsScriptRoot\modules" -UnixPath "$PsScriptRoot/modules"
    Write-host "Modules folder path: $ModulesFolderPath"

}
catch {
    Write-Error $_.Exception.Message
}


Write-Host "Starting to call Import-LatestModulesLocalRepository..."
Import-LatestModulesLocalRepository -ModulesFolderPath $ModulesFolderPath -ScriptPath $PSScriptRoot

###############################################################################################################################
############################################### END MODULE LOADING ############################################################
###############################################################################################################################
try {
    Ensure-LoggingFunctionExists -LoggingFunctionName "Write-EnhancedLog"
    # Continue with the rest of the script here
    # exit
}
catch {
    Write-Host "Critical error: $_" -ForegroundColor Red
    Handle-Error $_.
    exit
}

###############################################################################################################################
###############################################################################################################################
###############################################################################################################################

# Setup logging
Write-EnhancedLog -Message "Script Started" -Level "INFO" -ForegroundColor ([ConsoleColor]::Cyan)

################################################################################################################################
################################################################################################################################
################################################################################################################################

# Execute InstallAndImportModulesPSGallery function
InstallAndImportModulesPSGallery -moduleJsonPath "$PSScriptRoot/modules.json"

################################################################################################################################
################################################ END MODULE CHECKING ###########################################################
################################################################################################################################

    
################################################################################################################################
################################################ END LOGGING ###################################################################
################################################################################################################################

#  Define the variables to be used for the function
#  $PSADTdownloadParams = @{
#      GithubRepository     = "psappdeploytoolkit/psappdeploytoolkit"
#      FilenamePatternMatch = "PSAppDeployToolkit*.zip"
#      ZipExtractionPath    = Join-Path "$PSScriptRoot\private" "PSAppDeployToolkit"
#  }

#  Call the function with the variables
#  Download-PSAppDeployToolkit @PSADTdownloadParams

################################################################################################################################
################################################ END DOWNLOADING PSADT #########################################################
################################################################################################################################


##########################################################################################################################
############################################STARTING THE MAIN FUNCTION LOGIC HERE#########################################
##########################################################################################################################


################################################################################################################################
################################################ START GRAPH CONNECTING ########################################################
################################################################################################################################
# $accessToken = Connect-GraphWithCert -tenantId $tenantId -clientId $clientId -certPath $certPath -certPassword $certPassword

# Log-Params -Params @{accessToken = $accessToken }

# Get-TenantDetails
#################################################################################################################################
################################################# END Connecting to Graph #######################################################
#################################################################################################################################


# ################################################################################################################################
# ############### CALLING AS SYSTEM to simulate Intune deployment as SYSTEM (Uncomment for debugging) ############################
# ################################################################################################################################

# Example usage
$privateFolderPath = Join-Path -Path $PSScriptRoot -ChildPath "private"
$PsExec64Path = Join-Path -Path $privateFolderPath -ChildPath "PsExec64.exe"
$ScriptToRunAsSystem = $MyInvocation.MyCommand.Path

Ensure-RunningAsSystem -PsExec64Path $PsExec64Path -ScriptPath $ScriptToRunAsSystem -TargetFolder $privateFolderPath


# ################################################################################################################################
# ################################################ END CALLING AS SYSTEM (Uncomment for debugging) ###############################
# ################################################################################################################################




<#      
.NOTES
#===========================================================================  
# Script:  
# Created With: 
# Author:  
# Date: 
# Organization:  
# File Name: 
# Comments:
#===========================================================================  
.DESCRIPTION  
#>  

#region Function Add-EnvPath

# $ScriptRootDir = $PSScriptRoot.Replace("Private", "")
# $ChromeDriverBinDir = $ScriptRootDir + "bin\ChromeDriver\v79"

function Add-EnvPath {
    [CmdletBinding()]
    param (

        [Parameter(Mandatory = $true)]
        [string] $Path,

        [ValidateSet('Machine', 'User', 'Session')]
        [string] $Container = 'Session'

        #session mean temporarily
        #User or Machines means permanently

    )
    
    begin {

        $ENVPATHHASHTABLEADD = [Ordered]@{ } #*creating an empty hashtable
        $persistedPathsHashtable = [Ordered]@{ } #*creating an empty hashtable
        $containerMapping = [Ordered]@{ }
        $containerType = ""
    }
    
    process {

        try {


            #step 1 : #! This step will update the PATH VARIABLE under SYSTEM VARIABLES (Sysdm.cpl -> Advanced -> Environment Variables -> System Variables -> Path) this will modify the user/system environment variables permanently (i.e. will be persistent across shell restarts)
            if ($Container -ne 'Session') {
                $containerMapping = @{
                    Machine = [System.EnvironmentVariableTarget]::Machine
                    User    = [System.EnvironmentVariableTarget]::User
                }
                $containerType = $containerMapping[$Container]
                $MultiGetEnvironmentVariablePath = [System.Environment]::GetEnvironmentVariable('Path', $containerType) -split ';'
        
                ForEach ($SingleGetEnvironmentVariablePath in $MultiGetEnvironmentVariablePath) {
                    $persistedPathsHashtable[$SingleGetEnvironmentVariablePath] = $null #building a hashtable whose keys are all of the existing paths in the system environment variable
                }
     

                if (!($persistedPathsHashtable.Contains($Path))) {
                    Write-Host "path not found in hashtable adding it right now" -ForegroundColor green
                    $persistedPathsHashtable[$Path] = $null #add the path as a new key entry to the hashtable beside the keys that are already there
                    [System.Environment]::SetEnvironmentVariable('Path', $persistedPathsHashtable.Keys -join ';', $containerType)
                }
            }


            #step 2 : updating the EnvPath #!this will modify the session environment variables temporarily (i.e. will NOT be persistent across shell restarts)

            $MultiENVPATHSPLIT = $env:Path -split ';'
            ForEach ($SingleENVPATHSPLIT in $MultiENVPATHSPLIT) {
                $ENVPATHHASHTABLEADD[$SingleENVPATHSPLIT] = $null #* building the hashtable and adding the system env path to it
            }
       
            if (!($ENVPATHHASHTABLEADD.Contains($Path))) {
               
                $ENVPATHHASHTABLEADD[$Path] = $null #*add the path as a new key entry to the hashtable beside the keys that are already there
                $env:Path = $ENVPATHHASHTABLEADD.Keys -join ';'
            }
        }

        #$env:Path is DIFFERENT THAN [System.Environment]::GetEnvironmentVariable('Path', [System.EnvironmentVariableTarget]::Machine) -split ';'
    
        catch {

            Write-Host "A Terminating Error (Exception) happened" -ForegroundColor Magenta
            Write-Host "Displaying the Catch Statement ErrorCode" -ForegroundColor Yellow
            Write-Host $PSItem -ForegroundColor Red
            $PSItem
            Write-Host $PSItem.ScriptStackTrace -ForegroundColor Red
            
        }
        finally {
 
        }

    }
        
    end {

        
        Write-Host "the Premanent Env VAR "
        [System.Environment]::GetEnvironmentVariable('Path', [System.EnvironmentVariableTarget]::Machine) -split ';'


        # write-host "the new Env VAR 2 is"
        # $env:Path -split ';'

        # write-host "the new Env VAR 3 is" #Same result as [System.Environment]::GetEnvironmentVariable('Path', [System.EnvironmentVariableTarget]::Machine) -split ';'
        # $Reg = "Registry::HKLM\System\CurrentControlSet\Control\Session Manager\Environment"
        # (Get-ItemProperty -Path "$Reg" -Name PATH).Path -split ';'


        Write-Host "the Temp Env VAR is" #!Same result as $env:Path -split ';
        [System.Environment]::GetEnvironmentVariable("Path") -split ';'


        # write-host "the new Env VAR 5 is" # This step will gather VARIABLE under USER VARIABLES (Sysdm.cpl -> Advanced -> Environment Variables -> USER Variables -> Path)
        # [System.Environment]::GetEnvironmentVariable('Path', [System.EnvironmentVariableTarget]::User) -split ';'

        #to open the env variable window
        rundll32.exe sysdm.cpl, EditEnvironmentVariables

        
    }
}

# Add-EnvPath -Path 'C:\Users\aollivierre\Downloads\postgresql-16.2-1-windows-x64-binaries\pgsql\bin' -Container 'Machine'
# Add-EnvPath -Path 'D:\Users\aollivierre\Downloads\postgresql-16.2-1-windows-x64-binaries\pgsql\bin' -Container 'Machine'
# Add-EnvPath -Path 'C:\Program Files\PostgreSQL\16\bin' -Container 'Machine'
Add-EnvPath -Path 'C:\Program Files\KeePassXC' -Container 'Machine'
# Add-EnvPath -Path 'D:\Users\aollivierre\Downloads\azcopy_windows_amd64_10.24.0\azcopy_windows_amd64_10.24.0' -Container 'Machine'
# Add-EnvPath -Path 'C:\banana2' -Container 'Machine'

















# PS C:\Code\CB\DB\PSQL\CaRMS> .\Add-PATH_v7.ps1
# path not found in hashtable adding it right now



# the Premanent Env VAR
# C:\Program Files\Microsoft\jdk-17.0.10.7-hotspot\bin
# C:\Windows\system32
# C:\Windows
# C:\Windows\System32\Wbem
# C:\Windows\System32\WindowsPowerShell\v1.0\
# C:\Windows\System32\OpenSSH\
# C:\Program Files (x86)\Microsoft Group Policy\Windows 11 September 2022 Update (22H2)\PolicyDefinitions\
# C:\ProgramData\chocolatey\bin
# C:\Program Files\dotnet\
# C:\Program Files\Tailscale\
# C:\Program Files\PowerShell\7\
# C:\Program Files\PuTTY\
# C:\Users\aollivierre\Downloads\postgresql-16.2-1-windows-x64-binaries\pgsql\bin



# the Temp Env VAR is
# C:\Program Files\PowerShell\7
# C:\Program Files\Microsoft\jdk-17.0.10.7-hotspot\bin
# C:\Windows\system32
# C:\Windows
# C:\Windows\System32\Wbem
# C:\Windows\System32\WindowsPowerShell\v1.0\
# C:\Windows\System32\OpenSSH\
# C:\Program Files (x86)\Microsoft Group Policy\Windows 11 September 2022 Update (22H2)\PolicyDefinitions\
# C:\ProgramData\chocolatey\bin
# C:\Program Files\dotnet\
# C:\Program Files\Tailscale\
# C:\Program Files\PowerShell\7\
# C:\Program Files\PuTTY\
# C:\Users\Admin-Abdullah\AppData\Local\Microsoft\WindowsApps

# C:\Users\aollivierre\Downloads\postgresql-16.2-1-windows-x64-binaries\pgsql\bin

