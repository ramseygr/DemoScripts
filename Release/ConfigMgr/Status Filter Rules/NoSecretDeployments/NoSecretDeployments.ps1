#Pushes out the enforcement deadline by 10 years
#www.ramseyg.com  ramseyg@hotmail.com
#C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -command "& {D:\Source\Scripts\DevConn2015\NoSecretDeployments\Demo2-NoSecrets.ps1 -computername '%msgsys' -msgdesc '%msgdesc' -UserName '%msgis01' -ApplicationName '%msgis03' -CollectionName '%msgis04' }"
#status filter variables: http://technet.microsoft.com/en-us/library/bb693758.aspx
#New Deployment of Application
#Source: SMS Provider
#Message ID: 30226

[CmdletBinding()]
Param(
  [Parameter(Mandatory=$True)]
   [string]$ComputerName,
	
  [Parameter(Mandatory=$True)]
   [string]$MSGDesc,

  [Parameter(Mandatory=$True)]
   [string]$UserName,

  [Parameter(Mandatory=$True)]
   [string]$ApplicationName,

  [Parameter(Mandatory=$True)]
   [string]$CollectionName,
   	
  [Parameter()]
   [string]$AdditionalInfo
)

function write-log ($string)
{
    $string + " " + (get-date) | Out-File D:\Source\Scripts\DevConn2015\NoSecretDeployments\NoSecretRequiredDeployments.log -Append
}

write-log ("Start ")
write-log ("Source " + $ComputerName)
write-log ($MSGDesc)

write-log ("Importing ConfigMgr Module")
$CMModulePath = $Env:SMS_ADMIN_UI_PATH.ToString().SubString(0,$Env:SMS_ADMIN_UI_PATH.Length - 5) `
    + "\ConfigurationManager.psd1" 
Import-Module $CMModulePath -force
cd GMR:

write-log ("Querying Application Name")
write-log ($CollectionName)
write-log ($ApplicationName)
$App = Get-CMDeployment -CollectionName $CollectionName | `
    Where-Object {$_.SoftwareName -eq $ApplicationName -and $_.DeploymentIntent -eq 1}

write-log ("Current Enforcement Deadline (UTC) is " + $App.EnforcementDeadline.ToUniversalTime())

# we could have just removed it by running this:
#   Remove-CMDeployment -DeploymentId $app.AssignmentID -ApplicationName $ApplicationName


#Can't modify deployment from PowerShell, but can use SDK/WMI
#Create filter string for Get-CimInstance
$filter = "AssignmentUniqueID='" + $App.DeploymentID + "'"
$Assignment = Get-CimInstance `
    -Namespace root\sms\site_gmr `
    -class SMS_ApplicationAssignment `
    -filter $filter
#add 10 years
$NewTime = $Assignment.EnforcementDeadline.ToUniversalTime().Addyears(10)
    
Set-CimInstance -InputObject $Assignment -Property @{EnforcementDeadline=$NewTime}   
write-log "Modified assignment time to $NewTime"


