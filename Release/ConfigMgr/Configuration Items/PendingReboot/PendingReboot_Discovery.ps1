#Discovery script to report if ConfigMgr says a reboot is pending.
#http://blog.coretech.dk/kea/dealing-with-reboot-pending-clients-in-configuration-manager-2012/
#should return false if there is no pending reboot.
$val = Invoke-WmiMethod -Namespace "ROOT\ccm\ClientSDK" -Class CCM_ClientUtilities -Name DetermineIfRebootPending  | select-object -ExpandProperty "RebootPending"
$val

