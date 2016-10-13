#http://gregramsey.net/?p=882
$StatMsgs = @()
$cnstring = 'Provider=SQLOLEDB;Integrated Security=SSPI;Persist Security Info=False;' + `
 'Initial Catalog=CM_LAB;Data Source=mylab.lab.com;User ID=;Password='
Add-Type -Path `
    "D:\MSRS10_50.MSSQLSERVER\Reporting Services\ReportServer\bin\srsresources.dll"

$cmdtext = @"
select top 1000 smsgs.RecordID, 
CASE smsgs.Severity 
WHEN -1073741824 THEN 'Error' 
WHEN 1073741824 THEN 'Informational' 
WHEN -2147483648 THEN 'Warning' 
ELSE 'Unknown' 
END As 'SeverityName', 
smsgs.MessageID, smsgs.Severity, modNames.MsgDLLName, smsgs.Component, 
smsgs.MachineName, smsgs.Time, smsgs.SiteCode, smwis.InsString1, 
smwis.InsString2, smwis.InsString3, smwis.InsString4, smwis.InsString5, 
smwis.InsString6, smwis.InsString7, smwis.InsString8, smwis.InsString9, 
smwis.InsString10  
from v_StatusMessage smsgs   
join v_StatMsgWithInsStrings smwis on smsgs.RecordID = smwis.RecordID
join v_StatMsgModuleNames modNames on smsgs.ModuleName = modNames.ModuleName
--where smsgs.MessageID = 10803 and smsgs.MachineName in 
--    (select name from _res_coll_CEN00018)
--where smsgs.MachineName = 'mycomputername'
Order by smsgs.Time DESC
"@

$sql

$cn = New-Object System.Data.OleDb.OleDbConnection $cnstring
$cn.Open()

$cmd = New-Object System.Data.OleDb.OleDbCommand $cmdtext, $cn
$cmd.CommandTimeout = 0
$reader = $cmd.ExecuteReader()
while ($reader.read())
{
$FullMsgString = `
    [SrsResources.Localization]::GetStatusMessage([int]$reader["MessageID"], 
    [int]$reader["Severity"], $reader["MsgDllName"].ToString(), "en-US", 
    $reader["InsString1"].ToString(), $reader["InsString2"].ToString(), 
    $reader["InsString3"].ToString(), $reader["InsString4"].ToString(), 
    $reader["InsString5"].ToString(), $reader["InsString6"].ToString(), 
    $reader["InsString7"].ToString(), $reader["InsString8"].ToString(), 
    $reader["InsString9"].ToString(), $reader["InsString10"].ToString())
$FullMsgString = $FullMsgString -replace '([\.][\r])[\n]','.'
$FullMsgString = $FullMsgString -replace '([\.][\r])[\n]','.'
$obj = @{
SeverityName = $reader["SeverityName"].ToString()
MessageID = $reader["MessageID"].ToString()
Severity = $reader["Severity"].ToString()
MsgDLLName = $reader["MsgDLLName"].ToString()
Component = $reader["Component"].ToString()
MachineName = $reader["MachineName"].ToString()
Time = $reader["Time"].ToString()
SiteCode = $reader["SiteCode"].ToString()
InsString1 = $reader["InsString1"].ToString()
InsString2 = $reader["InsString2"].ToString()
InsString3 = $reader["InsString3"].ToString()
InsString4 = $reader["InsString4"].ToString()
InsString5 = $reader["InsString5"].ToString()
InsString6 = $reader["InsString6"].ToString()
InsString7 = $reader["InsString7"].ToString()
InsString8 = $reader["InsString8"].ToString()
InsString9 = $reader["InsString9"].ToString()
InsString10 = $reader["InsString10"].ToString()
FullMsgString = $FullMsgString
}

$statmsgs += new-object psobject -Property $obj
}
$cn.Close()

$wmidate = new-object -com Wbemscripting.swbemdatetime
$date = get-date -format g
$wmidate.SetVarDate($date,$true)
$csv = "C:\logs\Statmsgs_" + $wmidate.value.substring(0,12) + ".csv"

$statmsgs | select-object SeverityName, MessageID, Component,
     MachineName, Time, SiteCode, FullMsgString `
    | export-csv $csv -notypeinformation
$statmsgs | select-object SeverityName, MessageID, Component, MachineName, 
    Time, SiteCode, FullMsgString `
    | out-gridview
$statmsgs | group-object component | sort count -descending | out-gridview