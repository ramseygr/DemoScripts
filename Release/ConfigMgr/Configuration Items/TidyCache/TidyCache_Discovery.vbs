on error resume next
'This is an alternate script for tidycache discovery, which uses vbscript instead of powershell. You may encounter issues if PowerShell loads a default profile that immediately displays characters (because the discovery compliance rule is expecting an integer).
 dim oUIResManager
 dim oCache
 dim oCacheElement
 dim oCacheElements

 set oUIResManager = createobject("UIResource.UIResourceMgr")
   if oUIResManager is nothing then      
     wscript.echo "Couldn't create Resource Manager - quitting"
     wscript.quit
   end if
 set oCache=oUIResManager.GetCacheInfo()
   if oCache is nothing then
     set oUIResManager=nothing
         wscript.echo "Couldn't get cache info - quitting"
         wscript.quit
   end if
 set oCacheElements=oCache.GetCacheElements
     for each oCacheElement in oCacheElements
	if datediff("d",oCacheElement.LastReferenceTime,now) > 90 then
		i=i+1
	end if
         'oCache.DeleteCacheElement(oCacheElement.CacheElementID)
     next
 set oCacheElements=nothing
 set oUIResManager=nothing
 set oCache=nothing

if i > 0 then
	wscript.echo i
else
	wscript.echo 0
end if




