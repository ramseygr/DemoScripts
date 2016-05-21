ramseyg@hotmail.com
www.ramseyg.com

This is a sample PowerShell script that has a nice GUI for adding systems to a collection (using query-based rules). This script uses the WMI cmdlets, so there's no dependency on the ConfigMgr module - you should be able to run this remotely, and have the same rights to add systems to collection as you would through the admin console (you will also only see collections that you have rights to see - everything goes through the SMS provider).