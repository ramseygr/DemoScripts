#Publish-CMData - 

# Replace with your Workspace ID
$CustomerId = "e4ff0038-57fd-4c0c-9268-99a3c49647d5"  

# Replace with your Primary Key
$SharedKey = "CPfHRvey56FIaVokla3WVzic3fzYi6CkMgCNPWT/tPG/mG1FxMt8RcsHGuEY8Tq63WvUGLe00pcf+4t7b1aAMg=="

# Specify the name of the record type that you'll be creating
$LogType = "CM_CollevalInfo"

# Specify a field with the created time for the records
$TimeStampField = "LastEvaluationCompletionTime"

$cnstring = 'Provider=SQLOLEDB.1;Integrated Security=SSPI;Persist Security Info=False;Initial Catalog=CM_AM1;Data Source=auspwcfgam1db;User ID=;Password='


$cmdtext = @"
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



$cn = New-Object System.Data.OleDb.OleDbConnection $cnstring
$cn.Open()

$cmd = New-Object System.Data.OleDb.OleDbCommand $cmdtext, $cn
$cmd.CommandTimeout = 0
$reader = $cmd.ExecuteReader()

$table = new-object "system.data.datatable"
$table.Load($reader)
$json = convertto-json -inputobject (
    $table | select SiteCode, CollectionName, CollectionID, `
     RunTimeMS, LastEvaluationCompletionTime, NextEvaluationTime, 
     MemberChanges, LastmemberChangeTime) -Compress



# Create the function to create the authorization signature
Function Build-Signature ($customerId, $sharedKey, $date, $contentLength, $method, $contentType, $resource)
{
    $xHeaders = "x-ms-date:" + $date
    $stringToHash = $method + "`n" + $contentLength + "`n" + $contentType + "`n" + $xHeaders + "`n" + $resource

    $bytesToHash = [Text.Encoding]::UTF8.GetBytes($stringToHash)
    $keyBytes = [Convert]::FromBase64String($sharedKey)

    $sha256 = New-Object System.Security.Cryptography.HMACSHA256
    $sha256.Key = $keyBytes
    $calculatedHash = $sha256.ComputeHash($bytesToHash)
    $encodedHash = [Convert]::ToBase64String($calculatedHash)
    $authorization = 'SharedKey {0}:{1}' -f $customerId,$encodedHash
    return $authorization
}


# Create the function to create and post the request
Function Post-OMSData($customerId, $sharedKey, $body, $logType)
{
    $method = "POST"
    $contentType = "application/json"
    $resource = "/api/logs"
    $rfc1123date = [DateTime]::UtcNow.ToString("r")
    $contentLength = $body.Length
    $signature = Build-Signature `
        -customerId $customerId `
        -sharedKey $sharedKey `
        -date $rfc1123date `
        -contentLength $contentLength `
        -fileName $fileName `
        -method $method `
        -contentType $contentType `
        -resource $resource
    $uri = "https://" + $customerId + ".ods.opinsights.azure.com" + $resource + "?api-version=2016-04-01"

    $headers = @{
        "Authorization" = $signature;
        "Log-Type" = $logType;
        "x-ms-date" = $rfc1123date;
        "time-generated-field" = $TimeStampField;
    }

    $uri
    $method
    $contentType
    $headers
    #$body
    $response = Invoke-WebRequest -Uri $uri -Method $method -ContentType $contentType -Headers $headers -Body $body -UseBasicParsing
    return $response.StatusCode

}

# Submit the data to the API endpoint
Post-OMSData -customerId $customerId -sharedKey $sharedKey -body ([System.Text.Encoding]::UTF8.GetBytes($json)) -logType $logType  
 
