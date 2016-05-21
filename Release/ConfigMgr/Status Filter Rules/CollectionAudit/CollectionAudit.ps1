#www.ramseyg.com  ramseyg@hotmail.com
#status filter variables: http://technet.microsoft.com/en-us/library/bb693758.aspx and https://technet.microsoft.com/en-us/library/cc181208.aspx
#Import cert to trusted publishers https://blogs.technet.microsoft.com/microsoft_denmark_premier_field_engineering_config_manager_blog/2013/01/30/running-configuration-manager-2012-powershell-scripts-as-a-service-account-or-local-system/
#writes to log file C:\Scripts\StatusFilter\TaskSequences\
#New Collection (30015) or modified collection (30016)
#Source: SMS Provider
#Message ID: 30015 and 30016
#C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -command "& {c:\scripts\statusfilter\CollectionAudit.ps1 -computername '%msgsys' -msgdesc '%msgdesc' -msgis01 '%msgis01' -msgis02 '%msgis02'  }"


[CmdletBinding()]
Param(
  [Parameter(Mandatory=$True)]
   [string]$ComputerName,
	
  [Parameter(Mandatory=$True)]
   [string]$MSGDesc,

  [Parameter(Mandatory=$True)]
   [string]$MSGIS01,
	
  [Parameter(Mandatory=$True)]
   [string]$MSGIS02,
		
   [Parameter()]
   [string]$AdditionalInfo
)

function write-log ($string)
{
    $string + " " + (get-date) `
    | Out-File C:\Scripts\StatusFilter\Collections\CollectionAudit.log -Append
}

write-log ("Source " + $ComputerName + " " + $msgdesc + " " + $MSGIS01 + " " + $MSGIS02)

#MSGIS01 = username
#MSGIS02 = CollectionID

#region Import CM Module
$CMModulePath = `
    $Env:SMS_ADMIN_UI_PATH.ToString().SubString(0,$Env:SMS_ADMIN_UI_PATH.Length - 5) `
    + "\ConfigurationManager.psd1" 
Import-Module $CMModulePath -force
cd PS1:
#endregion


$CollID = $MSGIS02
$dirName = "C:\Scripts\StatusFilter\Collections"
$fileName = $CollID
$ext = ".mof"
$FilePath  = "$dirName\$filename $(get-date -f yyyyMMddhhmmss)$ext"

Export-CMCollection -ExportFilePath $FilePath `
    -CollectionId $CollID -ExportComment $MSGDesc



