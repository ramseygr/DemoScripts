#remediation rule for windowsfirewall (enables firewall, completely open with no rules** caution)
#Sets the Windows Firewall service to Auto, and starts it.
#resets the firewall, and enables all incoming and outgoing

Set-Service -Name MpsSvc -StartupType Automatic -Status Running
#Run Netsh Commands to Reset Firewall Profile
netsh advfirewall reset
#Enable all incoming and outgoing communication through Windows Firewall
netsh advfirewall set allprofiles state off 
