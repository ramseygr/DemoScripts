Exit

#First things first - Create new Maintenance Window
#Create new MW Schedule - every Saturday at 2:00AM for 3 Hours
$mwSched = New-CMSchedule -DayOfWeek Saturday -Start ([datetime]"2:00 am") `
    -End ([datetime]"2:00 am").addhours(3) 
New-CMMaintenanceWindow -CollectionName 'Test Coll' -Schedule $mwSched `
    -Name "Test Coll MW" -ApplyTo SoftwareUpdatesOnly


#show existing mw
Get-CMMaintenanceWindow -CollectionName 'Test Coll'






#List all SW Update cmdlets
Get-Command *softwareupdate* -Module ConfigurationManager | Select-Object -ExpandProperty Name







#Show one sw update - Lazy property message
Get-CMSoftwareUpdate | select -first 1

#let's talk about Lazy
measure-command {Get-CMSoftwareUpdate} # 1min, 20 s
measure-command {Get-CMSoftwareUpdate -fast} #.6s

#create group
New-CMSoftwareUpdateGroup -Name 'October 2017'


#create sw update package
New-CMSoftwareUpdateDeploymentPackage -Name "October 2017" `
    -Path '\\gmrcmtp.gmr.net\source\Software Updates\Oct2017'

#save-cmswupate to download
Get-CMSoftwareUpdate | Out-GridView

#Get-CMSoftwareUpdate -debug

Get-CMSoftwareUpdate -IsExpired $False -IsLatest $True `
    -IsSuperseded $False -Severity Critical | 
    ? {$_.NumMissing -gt 0} | select -first 2 | foreach {

    Save-CMSoftwareUpdate -DeploymentPackageName "October 2017" -SoftwareUpdate $_
    Add-CMSoftwareUpdateToGroup -SoftwareUpdateGroupName "October 2017" -SoftwareUpdate $_
}

#Distribute
Start-CMContentDistribution -DeploymentPackageName "October 2017" -DistributionPointGroupName "Americas"

#Check Status
$pkg = get-CMSoftwareUpdateDeploymentPackage -Name "October 2017"
Get-CMDistributionStatus | Where-Object {$_.PackageID -eq $pkg.PackageID}


New-CMSoftwareUpdateDeployment -SoftwareUpdateGroupName "October 2017" `
    -CollectionName "Workstations" -DeadlineDateTime (get-date).AddDays(3) `
    -DownloadFromMicrosoftUpdate $true





#Cleanup

Remove-CMSoftwareUpdateGroup -Name "October 2017" -Force

Remove-CMSoftwareUpdateDeploymentPackage -Name "October 2017" -Force


#Cleanup expired and superseded from update groups and update packages

Set-CMSoftwareUpdateGroup -name "Test SWUpdate Group" -ClearExpiredSoftwareUpdate -ClearSupersededSoftwareUpdate



Set-CMSoftwareUpdateDeploymentPackage -Name "SUM WRK 2017 Sep" -RemoveExpired -RemoveSuperseded -RefreshDistributionPoint





