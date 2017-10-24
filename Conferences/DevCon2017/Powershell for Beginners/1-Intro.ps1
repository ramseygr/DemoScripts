Exit

#Launch Provider from Console







#"normal" import module
#region Import CM Module
$CMModulePath = `
    $Env:SMS_ADMIN_UI_PATH.ToString().SubString(0,$Env:SMS_ADMIN_UI_PATH.Length - 5) `
    + "\ConfigurationManager.psd1" 
Import-Module $CMModulePath -force
cd PS1:
#endregion


#Discuss automation - running as a different user.
regedit
#HKEY_CURRENT_USER\Software\Microsoft\ConfigMgr10\AdminUI\MRU\1




#region use this code to import module and connect drive, even if MRU doesn't exist
$SiteCode = "PS1"
$Root = "GMRCMTP.GMR.NET"
Import-Module `
    $env:SMS_ADMIN_UI_PATH.Replace("\bin\i386","\bin\configurationmanager.psd1") `
    -ErrorAction STOP 
New-PSDrive -Name $SiteCode -PSProvider 'AdminUI.PS.Provider\CMSite' -Description 'SCCM Site' -Root $Root
Set-Location -Path PS1:\ 
#endregion









#get CM cmdlets
get-command -Module ConfigurationManager | Out-GridView





Get-Help Set-CMApplication -Full


Get-Help Set-CMApplication -ShowWindow




#show parameter sets for set-cmapplication
Show-Command Set-CMApplication






#Show Debug
Get-CMDevice -Debug | Out-GridView

#grab wmi query and run it.





#Show Devices
Get-CMDevice | `
    Select Name, LastPolicyRequest, LastMPServerName, DeviceOS | `
     Out-GridView



psedit "C:\Scripts\DevCon2017\PowerShell and ConfigMgr For Beginners\2-Collections.ps1"

psedit "C:\Scripts\DevCon2017\PowerShell and ConfigMgr For Beginners\3-PackageProgramApps.ps1"

psedit "C:\Scripts\DevCon2017\PowerShell and ConfigMgr For Beginners\4-SoftwareUpdates.ps1"

psedit "C:\Scripts\DevCon2017\PowerShell and ConfigMgr For Beginners\5-Queries.ps1"
