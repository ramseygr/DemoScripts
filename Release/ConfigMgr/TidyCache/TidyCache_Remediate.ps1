#remediate
$MinDays = 60
$UIResourceMgr = New-Object -ComObject UIResource.UIResourceMgr
$Cache = $UIResourceMgr.GetCacheInfo()
$Cache.GetCacheElements()  | 
    where-object {[datetime]$_.LastReferenceTime -lt (get-date).adddays(-$mindays)} | 
    foreach {
$Cache.DeleteCacheElement($_.CacheElementID)
}