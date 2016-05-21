#status filter variables: http://technet.microsoft.com/en-us/library/bb693758.aspx
#Import cert to trusted publishers https://blogs.technet.microsoft.com/microsoft_denmark_premier_field_engineering_config_manager_blog/2013/01/30/running-configuration-manager-2012-powershell-scripts-as-a-service-account-or-local-system/
#Task Sequence Create (30000) or Modify (30001) - which is actually packages, so if you want to perform actions for packages too, you may need to add more logic to this script to cover both.
#writes to log file C:\Scripts\StatusFilter\TaskSequences\
#C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -command "& {c:\scripts\statusfilter\TaskSequenceAudit.ps1 -computername '%msgsys' -msgdesc '%msgdesc' -msgis01 '%msgis01' -msgis02 '%msgis02'  }"


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
    | Out-File C:\Scripts\StatusFilter\TaskSequences\TaskSequenceAudit.log -Append
}

write-log ("Source " + $ComputerName + " " + $msgdesc + " " + $MSGIS01 + " " + $MSGIS02)

#MSGIS01 = username
#MSGIS02 = PackageID

#region Import CM Module
$CMModulePath = `
    $Env:SMS_ADMIN_UI_PATH.ToString().SubString(0,$Env:SMS_ADMIN_UI_PATH.Length - 5) `
    + "\ConfigurationManager.psd1" 
Import-Module $CMModulePath -force
cd PS1:
#endregion


$PackageID = $MSGIS02
$dirName = "C:\Scripts\StatusFilter\TaskSequences"
$fileName = $PackageID
$ext = ".zip"
$FilePath  = "$dirName\$filename $(get-date -f yyyyMMddhhmmss)$ext"

#only export if it's a task sequence
if (Get-CMTaskSequence -TaskSequencePackageId $PackageID) {

Export-CMTaskSequence -ExportFilePath $FilePath `
    -TaskSequencePackageId $PackageID -Comment $MSGDesc

}



