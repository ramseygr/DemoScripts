#region Import CM Module
$CMModulePath = `
    $Env:SMS_ADMIN_UI_PATH.ToString().SubString(0,$Env:SMS_ADMIN_UI_PATH.Length - 5) `
    + "\ConfigurationManager.psd1" 
Import-Module $CMModulePath -force
cd TP1:
#endregion


Get-CMScript | Where-Object {$_.approvalstate -eq 0}

Get-CMScript | Where-Object {$_.approvalstate -eq 0} | Approve-CMScript


Get-CMScript -ScriptName "BITS2" | 
    Invoke-CMScript -CollectionName "My Limited Collection for Running Scripts"





#Query via wmi
Invoke-CMWmiQuery "select * from sms_scripts" | out-gridview

#get script execution status (I don't see a cmdlet to do this - so using wmi)
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



#remove script
Remove-CMScript -ScriptName "BITS2" -Force