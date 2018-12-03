#https://gregramsey.net/2014/05/19/running-actions-based-on-configmgr-status-filter-rules-with-powershell/

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
    $string + " " + (get-date) | Out-File C:\Scripts\StatusFilter\NoSecrets\NoSecretRequiredDeployments.log -Append
}

write-log ("Start ")
write-log ("Source " + $ComputerName)
write-log ($MSGDesc)

write-log ("Importing ConfigMgr Module")
Import-Module $env:SMS_ADMIN_UI_PATH.Replace("\bin\i386","\bin\configurationmanager.psd1")$SiteCode = Get-PSDrive -PSProvider CMSITESet-Location "$($SiteCode.Name):\"

write-log ("Querying Application Name")
write-log ($ApplicationName)
write-log ($CollectionName)
