Exit 

#region Import CM Module
$CMModulePath = `
    $Env:SMS_ADMIN_UI_PATH.ToString().SubString(0,$Env:SMS_ADMIN_UI_PATH.Length - 5) `
    + "\ConfigurationManager.psd1" 
Import-Module $CMModulePath -force
cd TP1:
#endregion

#region ConfigMgr cmdlet overview and PowerShell basics

#all configmgr cmdlets
get-command -Module ConfigurationManager | measure | select count

#gridview
get-command -Module ConfigurationManager | Out-GridView

#show-command is your friend
Show-Command New-CMSchedule

#help with -showwindow
help New-CMSchedule -ShowWindow


#quick display of Client info for a collection
Get-CMDevice -CollectionName "Test Coll" | select Name, ADLastLogonTime, ADSiteName, `
    ClientVersion, DeviceOwner,Domain,LastActiveTime,LastHardwareScan, LastMPServerName, `
    SiteCode | Out-GridView

#endregion


#region query example

#display all queries
Get-CMQuery | out-gridview

#run a query
Invoke-CMQuery -Name 'All Systems'

#sample - ping each
Invoke-CMQuery -Name 'All Systems' | foreach  {
    "{0}={1}" -f $_.name,  (Test-Connection $_.name -quiet -Count 1)
}


#use Gridview to select and run a query
get-cmquery  | out-gridview -PassThru | invoke-cmquery


#endregion

#region cmdlet detail/debug, performance checking

#look to see how the cmdlet 'works'
Get-CMDevice -CollectionName "Test Coll" -debug

#measure timing
#ConfigMgr cmdlet
Measure-Command {Get-CMDevice -CollectionName "Test Coll"} | 
    select Totalseconds

#using invoke-cmwmiquery (still a configmgr cmdlet)    
$wql = 'SELECT * FROM SMS_CM_RES_COLL_TP100015'
Measure-Command { Invoke-CMWmiQuery -Query $wql} | 
    select Totalseconds

#direct wmi query
Measure-Command {Get-CimInstance -Namespace root\sms\site_tp1 `
    -ClassName sms_cm_res_coll_TP100015} | select Totalseconds





#example with lazy property
Measure-Command {get-cmprogram} | select TotalSeconds

Measure-Command {Get-CimInstance -Namespace root\sms\site_tp1 `
    -ClassName sms_program} | select Totalseconds

#?? why?  LAZY PROPERTY REFRESH
Get-CMProgram -Debug
#endregion
