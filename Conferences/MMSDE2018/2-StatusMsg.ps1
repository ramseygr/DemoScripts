#C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -command "& {C:\Scripts\StatusFilter\NoSecretDeployments.ps1 -computername '%msgsys' -msgdesc '%msgdesc' -UserName '%msgis01' -ApplicationName '%msgis03' -CollectionName '%msgis04' }"
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
    $string + " [" + (get-date) + "]" | Out-File C:\Scripts\StatusFilter\NoSecrets\NoSecretRequiredDeployments.log -Append
}

write-log ("Start ")
write-log ("Source " + $ComputerName)
write-log ($MSGDesc)
write-log ("ComputerName " + $ComputerName)
write-log ("Username " + $Username)
write-log ("ApplicationName " + $ApplicationName)
write-log ("CollectionName " + $CollectionName)



