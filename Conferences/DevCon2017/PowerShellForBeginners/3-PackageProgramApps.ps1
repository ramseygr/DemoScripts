Exit

#region Import CM Module
$CMModulePath = `
    $Env:SMS_ADMIN_UI_PATH.ToString().SubString(0,$Env:SMS_ADMIN_UI_PATH.Length - 5) `
    + "\ConfigurationManager.psd1" 
Import-Module $CMModulePath -force
cd PS1:
#endregion


#List Package info
Get-CMPackage | 
    select Manufacturer, Name, PackageID, LastRefreshTime, PkgSourcePath | Out-GridView

#Export to CSV
#Get-CMPackage | export-csv c:\logs\Allpackages.csv -NoTypeInformation

#Create new Package
$PackageName = '7-Zip'
$Manufacturer = 'Igor Pavlov'
$Ver = 9.20
$Description = 'Common Utilities'
$PackagePath = "\\gmrcmtp\c$\source\7-zip\x64" 
$ProgramName = 'Install x64'
$cmd = "msiexec /i 7z1701-x64.msi /quiet /norestart"

$Pkg = New-CMPackage -Name $PackageName -Version $Ver -Description $Description `
    -Path $PackagePath

$Prg = New-CMProgram -PackageId $Pkg.PackageID `
    -StandardProgramName $ProgramName -CommandLine  $cmd



Set-CMPackage -Name '7-zip' -Path '\\gmrcmtp\source\7-zip\x64'






#Set a program to 'allow program to install from task sequence'
show-command Set-CMProgram







Set-CMProgram -PackageId $pkg.PackageID -ProgramName `
    'Install x64' `
    -StandardProgram -EnableTaskSequence $True




# List all Programs with this enabled:
# "Allow this program to be installed from install
#  Package task sequence action without being deployed."
Get-CMProgram | foreach {
    if ($_.ProgramFlags -band 0x1) {
    "{0} {1} {2}" -f $_.ProgramName, $_.PackageID, "Enabled"
    }
}
#Enable this setting on all Programs
Get-CMProgram | foreach {
    if  ($_.ProgramFlags -band 0x1) {
        #Already Enabled
    }
    else {
        #currently disabled, enable now
        "{0} {1} {2}" -f $_.ProgramName, $_.PackageID, "Enabling"
        $_.ProgramFlags = $_.ProgramFlags -bxor 0x1
        $_.Put()
    }
}

#List all disabled programs   
Get-CMProgram | foreach {
    if  ($_.ProgramFlags -band 0x1000) {
        #disabled
        "{0} {1} {2}" -f $_.ProgramName, $_.PackageID, "Disabled"
    }
    else {
        #enabled
    }
}





#new application

$AppName = '7-Zip-DevConn'
$Manufacturer = 'Igor Pavlov'
$Ver = 9.20
$Description = 'Common Utilities'
$MSIPath = '\\gmrcmtp\c$\source\7-zip\x64\7z1701-x64.msi' 
$ProgramName = 'Install x64'
$cmd = 'msiexec /i 7z1701-x64.msi /quiet /norestart'
$DTName = '7-zipx64'
New-CMApplication `
    -Name $AppName `
    -Description $Description `
    -Owner $Manufacturer `
    -ReleaseDate (get-date) `
    -SoftwareVersion $Ver


#Add DT
Add-CMMsiDeploymentType -ApplicationName $AppName `
    -ContentLocation $MSIPath -Force -Comment 'Compression' `
    -ContentFallback  -DeploymentTypeName $DTName `
    -InstallationBehaviorType InstallForSystemIfResourceIsDeviceOtherwiseInstallForUser `
    -InstallCommand $cmd -SlowNetworkDeploymentMode Download


#modify application source path, and a couple other items
Set-CMMsiDeploymentType -ApplicationName `
    $AppName -DeploymentTypeName `
    $DTName -ContentFallback `
    $True -SlowNetworkDeploymentMode Download `
    -ContentLocation '\\gmrcmtp\source\7-zip\x64\7z1701-x64.msi' -Force


#Send to DP Group 'Americas'
Start-CMContentDistribution `
    -ApplicationName $AppName `
    -DistributionPointGroupName 'Americas'


Get-CMDistributionStatus | Where-Object {$_.SoftwareName -eq $AppName}

#Deploy Application Simuation
$CollName = 'Workstations'
Start-CMApplicationDeploymentSimulation `
    -name $AppName `
    -CollectionName $CollName `
    -DeployAction Install


#remove deployment
Remove-CMDeployment -ApplicationName $AppName -CollectionName 'workstations'

#Remove application
Get-CMApplication -name $AppName | Remove-CMApplication -Force

