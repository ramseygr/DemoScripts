#region Import CM Module
$CMModulePath = `
    $Env:SMS_ADMIN_UI_PATH.ToString().SubString(0,$Env:SMS_ADMIN_UI_PATH.Length - 5) `
    + "\ConfigurationManager.psd1" 
Import-Module $CMModulePath -force
cd CHQ:
#endregion


#new application

$AppName = '7-Zip-Ninjas'
$Manufacturer = 'Igor Pavlov'
$Ver = 22.01
$Description = 'Common Utilities'
$MSIPath = '\\cm1.corp.contoso.com\c$\source\7-zip\7z2201-x64.msi' 
$ProgramName = 'Install x64'
$cmd = 'msiexec /i 7z2201-x64.msi /quiet /norestart'
$DTName = '7-zipx64'

New-CMApplication -Name $AppName -Description $Description `
 -ReleaseDate (get-date) -SoftwareVersion $Ver


Add-CMMsiDeploymentType -ContentLocation $MSIPath -InstallCommand `
    $cmd -Comment 'Compression' -ApplicationName $AppName -DeploymentTypeName $DTName `
    -InstallationBehaviorType InstallForSystem -SlowNetworkDeploymentMode Download `
    -Force -ContentFallback 



#modify application source path - must use -MsiOrScriptInstaller, or doesn't work
Set-CMDeploymentType -ApplicationName $AppName -DeploymentTypeName $DTName `
-MsiOrScriptInstaller -ContentLocation "\\cm1.corp.contoso.com\source$\7-zip\"




#Send to DP Group 'Americas'
Start-CMContentDistribution -ApplicationName $AppName -DistributionPointGroupName 'Corp DPs'



#Deploy Application Simuation
New-CMApplicationDeployment -Simulation -name $AppName -CollectionName $CollName





#Show all deployments targeting a collection:
Get-CMDeployment -CollectionName "TEst Coll" | Out-GridView

#remove deployment
Remove-CMDeployment -ApplicationName '7-Zip-Ninjas' -CollectionName $CollName
#Remove application
Get-CMApplication -name '7-Zip-Ninjas' | Remove-CMApplication



