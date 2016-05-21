#Discovery script to report Windows Firewall isn't running
#Returns true if running, false otherwise.
$svc = gwmi win32_service -filter "name='mpssvc'"
if ($svc.StartMode -eq 'Disabled' -or $svc.StartMode -eq 'Manual') {
    return $False
}

if ($svc.state -eq 'Running') {
    return $True
}
return $false
