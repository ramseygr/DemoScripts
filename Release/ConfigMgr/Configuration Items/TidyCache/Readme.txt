https://gregramsey.wordpress.com/?p=926
ramseyg@hotmail.com

TidyCache is a ConfigMgr Compliance Settings Script used to clean up old ConfigMgr client cache from the %windir%\ccmcache directory. By default, any cache instance that has a LastReferenceTime of more than 60 days will be detected and purged from the script.

IUIResourceMgr::GetCacheInfo Method - https://msdn.microsoft.com/en-us/library/cc144856.aspx

a .vbs is also included, as there are scenarios where a modified default powershell profile (when run as system) may display text when loaded, which confuses ConfigMgr (ConfigMgr expects an integer returned from running the command, but PowerShell may return text [depending on the profile being loaded]).


