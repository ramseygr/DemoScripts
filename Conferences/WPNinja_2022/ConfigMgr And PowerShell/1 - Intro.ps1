#region importcmmodule
$SiteCode = "CHQ" # Site code 
$ProviderMachineName = "CM1.corp.contoso.com" # SMS Provider machine name
$initParams = @{}

# Import the ConfigurationManager.psd1 module 
if((Get-Module ConfigurationManager) -eq $null) {
    Import-Module "$($ENV:SMS_ADMIN_UI_PATH)\..\ConfigurationManager.psd1" @initParams 
}

# Connect to the site's drive if it is not already present
if((Get-PSDrive -Name $SiteCode -PSProvider CMSite -ErrorAction SilentlyContinue) -eq $null) {
    New-PSDrive -Name $SiteCode -PSProvider CMSite -Root $ProviderMachineName @initParams
}

# Set the current location to be the site code.
Set-Location "$($SiteCode):\" @initParams
#endregion



#show all cmdlets for ConfigMgr
get-command -Module ConfigurationManager | Out-GridView







#Show parameter sets for a command
Show-Command Set-CMApplication







#using debug
Get-CMDeviceCollection -debug






#a little on performance
Measure-Command {Get-CMDeviceCollection | 
    Where-Object {$_.name -eq 'All Systems'}} | 
    Select-Object milliseconds

Measure-Command {Get-CMDeviceCollection -name 'All Systems'} |
     Select-Object milliseconds





#Choose your columns
Get-CMDevice | Select-Object Name, LastHardwareScan, `
    LastPolicyRequest, AdSiteName, Comanaged, SiteCode





#Getting data "out"#(copy output to clipboard)Get-CMDevice | Select-Object Name, LastHardwareScan, `    LastPolicyRequest, AdSiteName, Comanaged, SiteCode  | clipnotepadGet-CMDevice | Select-Object Name, LastHardwareScan, `    LastPolicyRequest, AdSiteName, Comanaged, SiteCode | Set-Clipboardnotepad#export to .csvGet-CMDevice | Select-Object Name, LastHardwareScan, `    LastPolicyRequest, AdSiteName, Comanaged, SiteCode |     export-csv c:\scripts\devices.csv -NoTypeInformation #-Append and NoClobbernotepad C:\scripts\devices.csv