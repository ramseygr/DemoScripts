#This discovery script reads the last 5,000 lines of a file for specific text, and returns 'false' if the text is found
$strFileName = "c:\programdata\MyFavoriteAV\common framework\DB\Agent_" + $env:computername + ".log"
$Flag = $True
if (test-path ($strFileName)) {
$strLog = GC $strFileName | select-object -last 5000
#$strLog.Contains("error=-2400(Unable to connect to AV Server)")
$strLog | Foreach {
    If ($_.Contains("error=-2400(Unable to connect to AV Server)") -eq $true)
    {
        $flag = $False
    }
}
}
$Flag