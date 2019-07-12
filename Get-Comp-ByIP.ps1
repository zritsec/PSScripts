<# ------------------------------------------------------------------------------------------------------

Script: get-comp-byIP.ps1

Author: Zachari Rodrigue, Information Systems Security Specialist

Description: Enter an IP address to resolve hostname and pull AD information.

Ref Link: 

Last Edit: 7/12/2019 10:30 PM

Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.

Prerequisite: None

 Examples:

 ------------------------------------------------------------------------------------------------------ #>

Function Resolve-IP($IP){

    if([bool]($IP -as [ipaddress] -and ($IP.ToCharArray() | ?{$_ -eq "."}).count -eq 3)){
        Try{
            $hName = ([system.net.dns]::gethostbyaddress($IP).hostname)
            Write-host "($IP) Resolved to '$hName'"
            Try{get-adcomputer $hName.split('.')[0]}catch{Write-Host '[Error] getting AD information for' $hName.split('.')[0] -ForegroundColor Red }
        }
        catch{write-host "Unable to resolve IP " $IP}
    }
    Else{
        clear
        Write-Host "Please Enter a valid IP" -ForegroundColor red
        Resolve-IP (read-host 'Enter An Ip Address').Trim()
    }
}
clear
Resolve-IP (read-host 'Enter An Ip Address').Trim()
