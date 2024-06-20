# Get-WiFi
This script collects wifi configs and passwords of known networks from remote machines.


It includes optional functions to add the wlan profiles to your known networks, display ssid's and their keys, or delete known networks from a machine.  


Uses:
Get-Wifi -Computer TARGETCOMPUTER


Optional:
Get-Wifi -Computer TARGETCOMPUTER -AddWifi (Yes/No) -RemoveWifi (Yes/No)
