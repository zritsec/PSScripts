
# ------------------------------------------------------------------------------------------------------

# Script: LenovoTPM.ps1

# Author: Zachari Rodrigue, Information Systems Security Specialist

# Description: Get/Set the status of the TPM Chip in BIOS on a Lenovo ThinkPad using WMI

# Ref Link: https://support.lenovo.com/us/en/solutions/ht100612

# Last Edit: 11/20/2018 10:30 PM

# Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.

# Prerequisite: Needs to run elevated

# Examples:
    # Get-LenovoTPM 'MyComputer'
    # Set-LenovoTPM 'MyComputer'

# ------------------------------------------------------------------------------------------------------

function Get-LenovoTPM ($pcName)
{
  return gwmi -ComputerName $pcName -class Lenovo_BiosSetting -namespace root\wmi | ForEach-Object{ if ($_.CurrentSetting -like "SecurityChip*") {return $_.CurrentSetting.replace(","," = ")}}
} 

function Set-LenovoTPM ($pcName)
{
    (gwmi -ComputerName $pcName  -class Lenovo_SetBiosSetting –namespace root\wmi).SetBiosSetting("SecurityChip,Active")
    (gwmi -ComputerName $pcName  -class Lenovo_SaveBiosSettings -namespace root\wmi).SaveBiosSettings()
}

#example
$pcList = @('Comp1','Comp2')
$pcList | %{Try { IF (test-connection -count 1 -ComputerName $_ -Quiet) {write-host $_ $(Get-LenovoTPM $_)} else {write-host $_ "Offline"}} Catch{Write-host $_.Exception.Message}}
