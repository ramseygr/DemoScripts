$dbname="CM-TP1"
$instancename="CM_TP1"

$query = @"
SELECT
'PS1' as [SiteCode],
[t0].[CollectionName] as [CollectionName],
[t0].[SiteID] as CollectionID,
[t1].[EvaluationLength] AS [RunTimeMS],
concat(convert(varchar(19), [t1].[LastRefreshTime], 127),'Z') as [LastEvaluationCompletionTime],
concat(convert(varchar(19), [t2].[NextRefreshTime], 127),'Z') as [NextEvaluationTime],
[t1].[MemberChanges] AS [MemberChanges],
concat(convert(varchar(19), [t1].[LastMemberChangeTime], 127),'Z')  AS [LastMemberChangeTime]
FROM [dbo].[Collections_G] AS [t0]
INNER JOIN [dbo].[Collections_L] AS [t1] ON [t0].[CollectionID] = [t1].[CollectionID]
INNER JOIN [dbo].[Collection_EvaluationAndCRCData] AS [t2] ON [t0].[CollectionID] = [t2].[CollectionID]

"@

import-module C:\scripts\OMSAndConfigMgr\OMSIngestionAPI\1.5\OMSIngestionAPI.psd1 -force

$cnstring = "Provider=SQLOLEDB.1;Integrated Security=SSPI;Persist Security Info=False;Initial Catalog=$instancename;Data Source=$dbname;User ID=;Password="
$cn = New-Object System.Data.OleDb.OleDbConnection $cnstring
$cn.Open()
 
$cmd = New-Object System.Data.OleDb.OleDbCommand $query, $cn
$cmd.CommandTimeout = 0
$reader = $cmd.ExecuteReader()
 
$table = new-object "system.data.datatable"
$table.Load($reader)

($table | select SiteCode, collectionName,CollectionID,RunTimeMS,LastEvaluationCompletiontime,NextEvaluationTime, `
    MemberChanges,LastMemberChangeTime |
ConvertTo-Csv -NoTypeInformation) |
Select-Object -Skip 1 |
Set-Content -Path "C:\OMSanalytics\Collinfo$(get-date -f MM-dd-yyyy-hh-mm).csv"

get-date