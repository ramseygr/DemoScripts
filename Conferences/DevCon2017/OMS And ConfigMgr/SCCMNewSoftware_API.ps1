$dbname='CM-TP1'
$instancename='CM_TP1'
$customID = "0e26168a-8ae4-4883-a043-4a2942dca571"
$sharedID = "vlfz/RE80X0hQCd0nyWeOy9imLLT9s9GuNUSj9OcAlUCOItsh98ztxJPysm1PDVCMnmJipX6JwqkGtzHzbzgMQ=="
$time = Get-Date
$LogName = "SCCMSoftware"

$query = @"
SELECT    vrs.ResourceID
		, vrs.Netbios_Name0 AS [DeviceName]
		, vrs.Name0 + '.' + vrs.Full_Domain_Name0 AS Computer
		, vProg.DisplayName0 AS [ProgramName]
		, vProg.InstallDate0 AS [InstallDate]
		, vProg.Version0 AS Version
		--converts date to iso 8601 format - YYYY-MM-DDThh:mm:ssZ
		,concat(convert(varchar(19), vprog.timestamp, 127),'Z') as [TimeGenerated]
FROM            v_R_System AS vrs LEFT OUTER JOIN
                         v_Add_Remove_Programs AS vProg ON vProg.ResourceID = vrs.ResourceID
WHERE        (vProg.DisplayName0 <> 'NULL') AND (vrs.Active0 = 1) AND (vrs.ResourceID IN
                             (SELECT        MachineID
                               FROM            _RES_COLL_TP100016))
							   and datediff(day,vprog.TimeStamp,getdate()) < 90
"@

#psedit c:\scripts\oms\OMSIngestionAPI.psd1
#psedit c:\scripts\oms\OMSIngestionAPI.psm1
import-module C:\scripts\OMSAndConfigMgr\OMSIngestionAPI\1.5\OMSIngestionAPI.psd1 -force

$cnstring = "Provider=SQLOLEDB.1;Integrated Security=SSPI;Persist Security Info=False;Initial Catalog=$instancename;Data Source=$dbname;User ID=;Password="
$cn = New-Object System.Data.OleDb.OleDbConnection $cnstring
$cn.Open()
 
$cmd = New-Object System.Data.OleDb.OleDbCommand $query, $cn
$cmd.CommandTimeout = 0
$reader = $cmd.ExecuteReader()
 
$table = new-object "system.data.datatable"
$table.Load($reader)
$json = $table | select ResourceID, DeviceName, Computer, `
    ProgramName, InstallDate, Version, TimeGenerated |convertto-json -Compress
 
 
Send-OMSAPIIngestionFile -customerId $customID -sharedKey $sharedID -body $json `
       -logType $LogName -TimeStampField $time -Verbose

get-date