$dbname='CM-TP1'
$instancename='CM_TP1'
$customID = "0e26168a-8ae4-4883-a043-4a2942dca571"
$sharedID = "vlfz/RE80X0hQCd0nyWeOy9imLLT9s9GuNUSj9OcAlUCOItsh98ztxJPysm1PDVCMnmJipX6JwqkGtzHzbzgMQ=="
$time = Get-Date
$LogName = "SCCMWorkstationStatus"

$query = @"
SELECT  vWorkstationStatus.ResourceID
		, (v_R_System.Name0 + '.' + v_R_System.Full_Domain_Name0) AS Computer
		, vWorkstationStatus.ClientVersion
		, concat(convert(varchar(19), vWorkstationStatus.LastHardwareScan, 127),'Z')  AS LastHardwareScan
		, concat(convert(varchar(19), vWorkstationStatus.LastDDR, 127),'Z')  AS LastDDR
		, concat(convert(varchar(19), vWorkstationStatus.LastPolicyRequest, 127),'Z')  AS LastPolicyRequest
		, vWorkstationStatus.LastMPServerName
		, vWorkstationStatus.OperatingSystem
FROM            vWorkstationStatus INNER JOIN
                         v_R_System  ON vWorkstationStatus.ResourceID = v_R_System.ResourceID
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
$json = $table | select ResourceID,Computer,ClientVersion,LastHardwareScan,`
    LastDDR,LastPolicyRequest,LastMPServerName,OperatingSystem |convertto-json -Compress
 
 
Send-OMSAPIIngestionFile -customerId $customID -sharedKey $sharedID -body $json `
       -logType $LogName -TimeStampField $time -Verbose

       get-date