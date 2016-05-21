#Discovery script to report if WS-Man is listening on an https port.
#should return True if there is an ws-man listener enabled
try {
get-wsmaninstance winrm/config/listener -selectorset @{Address="*";Transport="https"} | out-null
}

catch {
Return $False
}

return $True