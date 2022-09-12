#region Import CM Module
$CMModulePath = `
    $Env:SMS_ADMIN_UI_PATH.ToString().SubString(0,$Env:SMS_ADMIN_UI_PATH.Length - 5) `
    + "\ConfigurationManager.psd1" 
Import-Module $CMModulePath -force
cd CHQ:
#endregion



#quick display of Client info for a collection - choose your columns
Get-CMDevice -CollectionName "Test Coll" | select Name, ADLastLogonTime, ADSiteName, `
    ClientVersion, DeviceOwner,Domain,LastActiveTime,LastHardwareScan, LastMPServerName, `
    SiteCode | Out-GridView





#write to .csv
Get-CMDevice -CollectionName "Test Coll" | select Name, ADLastLogonTime, ADSiteName, `
    ClientVersion, DeviceOwner,Domain,LastActiveTime,LastHardwareScan, LastMPServerName, `
    SiteCode | export-csv c:\scripts\ClientInfo.csv -NoTypeInformation
notepad c:\scripts\ClientInfo.csv





#View Collection info
Get-CMDeviceCollection -name "Test Coll"







#look at schedule
Show-Command New-CMSchedule







#create a collection, with schedule
$Sched = New-CMSchedule -DayOfWeek Saturday
$MyColl = New-CMDeviceCollection -Name "Test Coll2" -LimitingCollectionName `
    "All Desktop and Server Clients" -RefreshSchedule $Sched -RefreshType Periodic





#Add rule to exclude my "All DCs Collection"
Add-CMDeviceCollectionExcludeMembershipRule -CollectionName "Test Coll2" `
    -ExcludeCollectionName "All DCs"






#now, update the schedule, and set refreshtype to 'both'
$Sched = New-CMSchedule -RecurCount 7 -RecurInterval Days -Start ([datetime] "9/10/2022 02:00")
Set-CMDeviceCollection -Name "Test Coll2" -RefreshSchedule $sched -RefreshType Both




##Lazy Alert!

#look at the schedule with gwmi
$Coll = Get-WmiObject -Class SMS_Collection -Namespace "Root\SMS\Site_chq" `
    -Filter "Name='Test Coll2'"
$Coll
$Coll.refreshschedule    # (Refreshschedule is blank...)





#you see refreshschedule info here:
$coll = Get-CMDeviceCollection -name "Test Coll2" 
$coll.RefreshSchedule



#why is refreshschedule missing when get-wmiobject?

#need to handle lazy property..... (check sms_collection Class for lazy props)
$Coll = Get-WmiObject -Class SMS_Collection -Namespace "Root\SMS\Site_chq" `
    -Filter "Name='Test Coll2'"
$coll.__path
$coll2 = [wmi]$coll.__path  #get specific instance using the [wmi] and __Path 
$coll2.RefreshSchedule



#Create new Maintenance Window
#Create new MW Schedule - every Saturday at 2:00AM for 3 Hours
$mwSched = New-CMSchedule -DayOfWeek Saturday -Start ([datetime]"2:00 am") `
    -End ([datetime]"2:00 am").addhours(3) 
New-CMMaintenanceWindow -CollectionName 'Test Coll2' -Schedule $mwSched `
    -Name "Test Coll2 MW" -ApplyTo SoftwareUpdatesOnly



#show mw
Get-CMMaintenanceWindow -CollectionName 'Test Coll2'







#Add Direct Membership Rule
Add-CMDeviceCollectionDirectMembershipRule -CollectionName $Coll2.Name `
    -ResourceId (get-CMDevice -name CLIENT1).ResourceID






#Add Multiple Direct Membership Rules
notepad c:\scripts\systems.txt
get-content c:\scripts\systems.txt | foreach-object {
    Add-CMDeviceCollectionDirectMembershipRule -CollectionName $Coll2.Name `
        -ResourceId (get-CMDevice -name $PSItem).ResourceID
}



#Create Query Rule
$WQLQuery = `
    "select * from sms_r_system Where OperatingSystemNameAndVersion like '%Workstation%'"
Add-CMDeviceCollectionQueryMembershipRule -CollectionName $Coll2.Name `
    -RuleName "All Workstations" -QueryExpression $WQLQuery




#perform surgery - remove one rule
Remove-CMDeviceCollectionDirectMembershipRule -CollectionName "Test Coll2" `
    -ResourceName "CLIENT1"





#Remove all direct membership rules
$CollectionName = "Test Coll2"
$coll = Get-CMDeviceCollection -name $CollectionName 
$coll.CollectionRules | where-object {$PSItem.ObjectClass -eq "SMS_CollectionRuleDirect"} |
    foreach-object { 
        Remove-CMDeviceCollectionDirectMembershipRule -collectionname $CollectionName `
        -resourceID $_.ResourceID -force
    }

#Update Collection membership now
Invoke-CMDeviceCollectionUpdate -Name "Test Coll2"



#Remove Collection use -force to not get prompted
Remove-CMDeviceCollection -name "Test Coll2" -force







#Look at collection update info
Get-CMDeviceCollection | Out-GridView
#https://msdn.microsoft.com/en-us/library/hh948939.aspx
#CollectionType: 1=User, 2=Device
#RefreshType: 1=Manual, 2=Periodic, 4=Constant, 6=Periodic+Constant




#Look at collection members - automation around compliance failures, etc
Get-CMCollectionMember -CollectionName 'Test Coll' | 
    out-gridview





Copy-CMCollection -Name "Test Coll" -NewName "Test Coll-Copy"






Invoke-CMClientAction -CollectionName "Test Coll" -ActionType ClientNotificationRequestHWInvNow







Export-CMCollection -ExportFilePath c:\scripts\mycoll.mof -name "Test Coll"
notepad c:\scripts\mycoll.mof


#stand-alone Collection Tool. . .
& 'C:\Scripts\1.5 - CreateCollQueryRuleMultiple.ps1'