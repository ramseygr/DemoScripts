#scripts
****
Exit


#Show how to get info on Service - "Get BITS Service Status"
#add some (very basic) Error Checking.... - "Get BITS Service Status With Error Checking"

try {
    Get-CimInstance win32_service -filter "Name='BITS'" |
         select Status -ExpandProperty Status
}
catch {
    "Error"
    Exit -1
}




#structured output - with parameters -example with 
#process name -wmiprvse and w3wp
Param([Parameter(Mandatory=$true)][string]$ProcessName)
try {
    Get-Process -Name $ProcessName | 
        select ProcessName, Handles, WS, NPM, PM, CPU 
}
catch {
    "Error"
    exit -1
}







#Get under the hood

Get-CimInstance -Namespace root\sms\site_tp1 `
     -ClassName SMS_Scripts | Out-GridView


Invoke-CMWmiQuery "select * from sms_scripts" | out-gridview

Invoke-CMWmiQuery "Select * from SMS_ScriptsExecutionStatus" | Out-GridView



#get the status for the last script to run
$wql = @"
    Select distinct ClientOperationID 
    from SMS_ScriptsExecutionStatus 
    order by ClientOperationID desc
"@
$LastRun = (Invoke-CMWmiQuery $wql ).ClientOperationID[0]

#query for last one based on ClientOperationID
$wql = @"
    Select * from SMS_ScriptsExecutionStatus
    where ClientOperationID=$lastrun
"@
$LastRunDetails = Invoke-CMWmiQuery $wql
$LastRunDetails | Out-GridView


#get the data to where we can use it...
$collobj = @()
$LastRunDetails | foreach {
    $Device = $_.DeviceName
    $_.ScriptOutput | ConvertFrom-Json | foreach {
        $_ | Add-Member –MemberType NoteProperty –Name DeviceName –Value $Device
        $collobj += $_
    }
}

$collobj | Out-GridView



#Re-run TS - TP120002 - this assumes the TS is already deployed to the system,
# with a future mandatory date
Param([Parameter(Mandatory=$true)][string]$DeploymentID)
$strFilter = "ScheduledMessageID like '$DeploymentID%'"

$deployment = gwmi ccm_scheduler_scheduledmessage `
    -Namespace root\ccm\policy\machine\actualconfig -filter $strFilter 
if (($deployment | measure).count -eq 0) {
     "Deployment Not Found!"
     exit -1
     } 
     else {
    $retval =Invoke-WmiMethod -Namespace root\ccm -Class sms_client `
        -Name TriggerSchedule $deployment.ScheduledMessageID
}




#Approve a script pending approval
#Approve Scripts ApprovalState: 3=approved 0=pending

#pending approvals
$Pending = Get-WmiObject -class sms_scripts -namespace root\sms\site_TP1 `
    -filter "ApprovalState=0"
$Pending | Out-GridView

$env:USERNAME
$Pending.UpdateApprovalState("3", "gmr\ramseygrgoat", "approved")




#??What just happened?


