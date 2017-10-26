Exit
#Warning - CM TS cmdlets are **really powerful**. Make sure to test them out in lab before using them in Production!




#replace old 7-zip package/program with new one, and add wmi condition


$OldPackage = Get-CMPackage -Name '7-zip' | Where-Object {$_.version -eq '9.2'}
$OldProgram = Get-CMProgram -Package $OldPackage -ProgramName 'Install x64'
$NewPackage = Get-CMPackage -Name '7-zip' | Where-Object {$_.version -eq '9.3'}
$NewProgram = Get-CMProgram -Package $NewPackage -ProgramName 'Install x64'


#Get the TS
$CMTaskSequence = Get-CMTaskSequence -Name 'IT Software Stack'

$NewPrgCondition = New-CMTaskSequenceStepConditionQueryWMI `
    -Query "select * from Win32_OperatingSystem where OSArchitecture ='64-bit'"

$NewPackageTSStep = New-CMTaskSequenceStepInstallSoftware `
    -Program $NewProgram -Name 'Install 7-Zip 9.3' `
    -Condition $NewPrgCondition


#Add the TS Step
Set-CMTaskSequenceGroup -AddStep $NewPackageTSStep -InputObject $CMTaskSequence -StepName 'Standard Software'

#Remove the old TS Step
Remove-CMTaskSequenceStep -InputObject $CMTaskSequence -StepName 'Install 7-Zip 9.2'









#region Lab Prep before the session
#New sample driver package for OSD
    New-CMPackage -Name 'OSD DRV - Microsoft Surface Book 2'
#endregion

#Add two new Task Sequence Groups
#Get the TS first
New-CMTaskSequence -Name 'Drivers' -CustomTaskSequence

$CMTaskSequence = Get-CMTaskSequence -Name 'Drivers'
#Define new TS Groups
$Microsoft = New-CMTaskSequenceGroup -Name 'Microsoft' #Sub Group under Drivers
$Lenovo = New-CMTaskSequenceGroup -Name 'Lenovo' #Sub Group under Drivers
$HP = New-CMTaskSequenceGroup -Name 'HP' #Sub Group under Drivers
$Dell = New-CMTaskSequenceGroup -Name 'Dell' #Sub Group under Drivers
$BIOSUpdates = New-CMTaskSequenceGroup -Name 'BIOS Updates'
$Drivers = New-CMTaskSequenceGroup -Name 'Drivers' -Step @($Microsoft,$Lenovo,$HP, $Dell)


#Add the groups first. Index == order nr in TS
Add-CMTaskSequenceStep -Step $BIOSUpdates -InputObject $CMTaskSequence -InsertStepStartIndex 1
Add-CMTaskSequenceStep -Step $Drivers -InputObject $CMTaskSequence -InsertStepStartIndex 2


#Get the DRV Package
$NewCMDriverPackage = Get-CMPackage -Name 'OSD DRV - Microsoft Surface Book 2'
#Get the TS
$CMTaskSequence = Get-CMTaskSequence -Name 'Drivers'

#New DRV commandline to inject the drivers during OSD
$DRVCommandLine = 'DISM.exe /Image:%OSDisk%\ /Add-Driver /Driver:.\ /Recurse'

#Get the Drivers/Microsoft Group
$Drivers = Get-CMTaskSequenceGroup -InputObject $CMTaskSequence -StepName Microsoft

#New TS DRV Condition - WMI
$NewDRVCondition = New-CMTaskSequenceStepConditionQueryWMI `
    -Query "Select * from Win32_ComputerSystem where model like '%Surface Book 2%'"

#Define TS Command-line Step
$NewTSCommandLine = New-CMTaskSequenceStepRunCommandLine `
    -CommandLine $DRVCommandLine `
    -PackageId $NewCMDriverPackage.PackageID `
    -SuccessCode @(0,3010,2,50) `
    -Name $NewCMDriverPackage.Name -Condition $NewDRVCondition

#Add the TS Step
Set-CMTaskSequenceGroup -AddStep $NewTSCommandLine -InputObject $CMTaskSequence -StepName Microsoft





