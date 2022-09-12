#status filter variables: http://technet.microsoft.com/en-us/library/bb693758.aspx
#New Deployment of Application
#Source: SMS Provider
#Message ID: 30226
#Run Command (combine the next three lines, replace the # with a space:
#C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe
#-command "& {c:\scripts\statusfilter\nosecretdeployments.ps1
#-computername '%msgsys' -msgdesc '%msgdesc'}"
 
[CmdletBinding()]
Param(
  [Parameter(Mandatory=$True)]
   [string]$ComputerName,
 
  [Parameter(Mandatory=$True)]
   [string]$MSGDesc,
 
   [Parameter()]
   [string]$AdditionalInfo
)
 
function write-log ($string)
{
    $string + " " + (get-date) `
    | Out-File C:\scripts\StatusFilter\NoSecretDeployments.log -Append
}
 
write-log ("Source " + $ComputerName)
write-log ($MSGDesc)