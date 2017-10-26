
#region Import CM Module
$CMModulePath = `
    $Env:SMS_ADMIN_UI_PATH.ToString().SubString(0,$Env:SMS_ADMIN_UI_PATH.Length - 5) `
    + "\ConfigurationManager.psd1" 
Import-Module $CMModulePath -force
cd PS1:
#endregion



psedit "C:\Scripts\DevCon2017\Powershell and ConfigMgr - Latest Cmdlets\2-ConfigurationItems.ps1"

psedit "C:\Scripts\DevCon2017\Powershell and ConfigMgr - Latest Cmdlets\3-AdvSWUpdates.ps1"

psedit "C:\Scripts\DevCon2017\Powershell and ConfigMgr - Latest Cmdlets\4-OSD.ps1"

psedit "C:\Scripts\DevCon2017\Powershell and ConfigMgr - Latest Cmdlets\5-Scripts.ps1"
