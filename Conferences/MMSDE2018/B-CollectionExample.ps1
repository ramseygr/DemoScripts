Exit 

#region Import CM Module
$CMModulePath = `
    $Env:SMS_ADMIN_UI_PATH.ToString().SubString(0,$Env:SMS_ADMIN_UI_PATH.Length - 5) `
    + "\ConfigurationManager.psd1" 
Import-Module $CMModulePath -force
cd PS1:
#endregion



#look at collection details
Get-CMDeviceCollection -name "Test Coll"



#quick display of Client info for a collection
Get-CMDevice -CollectionName "Test Coll" | select Name, ADLastLogonTime, ADSiteName, `
    ClientVersion, DeviceOwner,Domain,LastActiveTime,LastHardwareScan, LastMPServerName, `
    SiteCode | Out-GridView
    
#write to .csv
Get-CMDevice -CollectionName "Test Coll" | select Name, ADLastLogonTime, ADSiteName, `
    ClientVersion, DeviceOwner,Domain,LastActiveTime,LastHardwareScan, LastMPServerName, `
    SiteCode | export-csv c:\scripts\ClientInfo.csv -NoTypeInformation

notepad c:\scripts\ClientInfo.csv

#Create a collection, with schedule


#look at new schedule
Show-Command New-CMSchedule



#create a collection, with schedule
$Sched = New-CMSchedule -DayOfWeek Saturday
$MyColl = New-CMDeviceCollection -Name "Test Coll2" -LimitingCollectionName `
    "All Desktop and Server Clients" -RefreshSchedule $Sched -RefreshType Periodic
$MyColl




#Add rule to exclude my "All DCs Collection"
Add-CMDeviceCollectionExcludeMembershipRule -CollectionName "Test Coll2" `
    -ExcludeCollectionName "All DCs"




    #now, update the schedule, and set refreshtype to 'both'
$Sched = New-CMSchedule -RecurCount 3 `
    -RecurInterval Days -Start ([datetime] "12/02/2018 02:00")

Set-CMDeviceCollection -Name "Test Coll2" `
    -RefreshSchedule $sched -RefreshType Both


    #look at the schedule with gwmi
$Coll = Get-ciminstance -Class SMS_Collection -Namespace "Root\SMS\Site_PS1" `
    -Filter "Name='Test Coll2'"
$Coll.refreshschedule    # (Refreshschedule is blank...)





#you see refreshschedule info here:
$coll = Get-CMDeviceCollection -name "Test Coll2" -debug
$coll.RefreshSchedule


#why is refreshschedule missing when get-wmiobject?


#Debug!
$coll = Get-CMDeviceCollection -name "Test Coll2" -debug






#need to handle lazy property..... (check sms_collection Class for lazy props)
Get-CimInstance -Class SMS_Collection -Namespace "Root\SMS\Site_PS1" `
    -Filter "Name='Test Coll2'" 

$coll = Get-CimInstance -Class SMS_Collection -Namespace "Root\SMS\Site_PS1" `
    -Filter "Name='Test Coll2'" | Get-CimInstance
$coll.RefreshSchedule

#Add Direct Membership Rule
$Device = get-CMDevice -name GMRCMTP
Add-CMDeviceCollectionDirectMembershipRule -CollectionName "Test Coll2" `
    -ResourceId $Device.ResourceID



#Add Multiple Direct Membership Rules
##add foreach to simplify
notepad c:\scripts\systems.txt
get-content c:\scripts\systems.txt | foreach-object {
    $Device = get-CMDevice -name $PSItem
    Add-CMDeviceCollectionDirectMembershipRule -CollectionName 'Test Coll2' `
        -ResourceId $Device.ResourceID
}

#Create Query Rule
$WQLQuery = `
    "select * from sms_r_system Where OperatingSystemNameAndVersion like '%Workstation%'"
Add-CMDeviceCollectionQueryMembershipRule -CollectionName $Coll.Name `
    -RuleName "All Workstations" -QueryExpression $WQLQuery




#perform surgery - remove one rule
Remove-CMDeviceCollectionDirectMembershipRule -CollectionName "Test Coll2" `
    -ResourceName "WIN10-1" -Debug



#Remove all direct membership rules
$CollectionName = "Test Coll2"
$coll = Get-CMDeviceCollection -name $CollectionName 

$Coll.CollectionRules | select objectclass

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
#Move collections to a folder

### do a new-item to create the folder.
new-item -Path PS1:\DeviceCollection -Name "MyNewFolder" 




#Move All non-standard Collections to a subfolder
#Find Destination Folder
$DestinationFolder = Get-Item -Path PS1:\DeviceCollection\* | ? {$_.name -eq 'MyNewFolder'}
#Confirm you have proper destination folder
$DestinationFolder

$strquery = "SELECT * FROM SMS_Collection WHERE CollectionID is " + `
    "not in (Select InstanceKey from SMS_ObjectContainerItem "  +`
    "where ObjectType = '5000') and CollectionType='2'" 

#get all device collections in the root
$RootCollections = Get-CimInstance -Namespace `
    root\sms\site_ps1 -query $strQuery | `
     Where-Object {$_.CollectionID -notlike "SMS*"}

#Move to subfolder
$RootCollections | foreach {
    Move-CMObject -ObjectId $_.CollectionID -FolderPath $DestinationFolder.PSPath
}






#Make a copy of a collection, and move it to a subfolder
Copy-CMCollection -name "Test Coll" -NewName "Test Coll2"
Get-CMCollection -Name "Test Coll2" | Move-CMObject -FolderPath PS1:\DeviceCollection\MyNewFolder

