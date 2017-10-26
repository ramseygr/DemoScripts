Exit








#Show how to get info on Service - "Get BITS Service Status"
Get-CimInstance win32_service -filter "Name='BITS'" | select Status -ExpandProperty Status









#add some (very basic) Error Checking.... - "Get BITS Service Status With Error Checking"

try {
    Get-CimInstance win32_service -filter "Name='BITS'" | select Status -ExpandProperty Status
}
catch {
    "Error"
    Exit -1
}











#Get under the hood

get-ciminstance -namespace root\sms\site_PS1 -class sms_scripts | Out-GridView


Invoke-CMWmiQuery "select * from sms_scripts" | out-gridview
Invoke-CMWmiQuery "Select * from sms_scriptsexecutionstatus" | out-gridview

####! Caution
#structured output - with json - getting process
try {
    Get-Process -Name wmiprvse | 
        select ProcessName, Handles, WS, NPM, PM, CPU | 
        convertto-json -Compress
}
catch {
    "Error"
    exit -1
}


#View the results
get-ciminstance -namespace root\sms\SITE_PS1 -class sms_scriptsexecutionstatus |
    Sort ClientOperationID  |
    Select ClientOperationID, DeviceName, LastUpdateTime, ScriptOutput

$collobj = @()
get-ciminstance -namespace root\sms\SITE_PS1 -class sms_scriptsexecutionstatus `
    -filter "ClientOperationID=16778246 and ScriptExitCode=0"  |
    Select ClientOperationID, DeviceName, ScriptOutput | foreach {
    $Device = $_.DeviceName
    $_.ScriptOutput | ConvertFrom-Json | foreach {
        $_ | Add-Member –MemberType NoteProperty –Name DeviceName –Value $Device
        $collobj += $_
    }
 }



 $collobj | Out-GridView
 $collobj | gm

 

#structured output - with parameters -example with process name -wmiprvse and w3wp
Param([Parameter(Mandatory=$true)][string]$ProcessName)
try {
    Get-Process -Name $ProcessName | select ProcessName, Handles, WS, NPM, PM, CPU | convertto-json -Compress
}
catch {
    "Error"
    exit -1
}


#parameter example with restart-service
Param([Parameter(Mandatory=$true)][string]$ServiceName)
try {
    restart-service $servicename
}
catch {
    "Error"
    exit -1
}





#Grand Finale -re-run TS - PS120003 - this assumes the TS is already deployed to the system, with a future mandatory date
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


