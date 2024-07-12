# Get-WiFi
This script collects wifi configs and passwords of known networks from remote machines.
[Download Get-Wifi](https://github.com/softwaresuave/Get-WiFi/archive/refs/heads/main.zip)

## Description

It includes optional functions to add the wlan profiles to your known networks, display ssid's and their keys, or delete known networks from a machine.  


To use:
Get-Wifi -Computer TARGETCOMPUTER


Optional Parameters:
Get-Wifi -Computer TARGETCOMPUTER -AddWifi (Yes/No) -RemoveWifi (Yes/No)
