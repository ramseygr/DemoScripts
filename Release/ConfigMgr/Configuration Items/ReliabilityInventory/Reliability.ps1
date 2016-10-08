#use this script to insert reliability info into custom wmi class, so you can pick it up in inventory.

#Code for creating the reliability class
Function New-WMIClass{
    #CIMTYPE Enum:http://msdn.microsoft.com/en-us/library/system.management.cimtype.aspx
    $newClass = New-Object System.Management.ManagementClass `
        ("root\cimv2", [String]::Empty, $null); 

    $newClass["__CLASS"] = "MyCustom_Reliability"; 

    $newClass.Qualifiers.Add("Static", $true)
    $newClass.Properties.Add("ID", [System.Management.CimType]::String, $false)
    $newClass.Properties["ID"].Qualifiers.Add("Key", $true)
    $newClass.Properties.Add("TimeGenerated", [System.Management.CimType]::DateTime, $false)
    $newClass.Properties.Add("LogFile", [System.Management.CimType]::String, $false)
    $newClass.Properties.Add("ProductName", [System.Management.CimType]::String, $false)
    $newClass.Properties.Add("SourceName", [System.Management.CimType]::String, $false)
    $newClass.Properties.Add("FaultingAppName", [System.Management.CimType]::String, $false)
    $newClass.Properties.Add("FaultingAppVersion", [System.Management.CimType]::String, $false)
    $newClass.Properties.Add("FaultingAppPath", [System.Management.CimType]::String, $false)
    $newClass.Properties.Add("FaultingModule", [System.Management.CimType]::String, $false)
    $newClass.Properties.Add("FaultingModuleVersion", [System.Management.CimType]::String, $false)
    $newClass.Properties.Add("FaultingModulePath", [System.Management.CimType]::String, $false)
    $newClass.Put()
}

#Code for querying all reliability records for Apps
Function Get-AppReliabilityRecords {

$records = get-wmiobject win32_reliabilityrecords `
    -filter "SourceName='Application Error' OR SourceName='Application Hang'" | 
        select ComputerName, LogFile, Message, ProductName, SourceName, TimeGenerated, InsertionStrings  
$records | Sort-Object timegenerated -Descending | foreach {

#Clear hash table
$ht = $Null

if ($_.SourceName -eq 'Application hang' ) {
    #create hash table with app hang info
    $ht = @{
    ComputerName = $_.computername
    Logfile = $_.Logfile
    ProductName = $_.ProductName
    SourceName = $_.SourceName
    TimeGenerated = $_.TimeGenerated
    FaultingAppName = $_.InsertionStrings[0]
    FaultingAppVersion = $_.InsertionStrings[1]
    FaultingAppPath = $_.InsertionStrings[5]

    }
}

if ($_.Sourcename -eq 'Application Error') {
    #create HT for app error
    $ht = @{
    ComputerName = $_.computername
    Logfile = $_.Logfile
    ProductName = $_.ProductName
    SourceName = $_.SourceName
    TimeGenerated = $_.TimeGenerated
    FaultingAppName = $_.InsertionStrings[0]
    FaultingAppVersion = $_.InsertionStrings[1]
    FaultingModule =  $_.InsertionStrings[3]
    FaultingModuleVersion = $_.InsertionStrings[4] 
    FaultingAppPath = $_.InsertionStrings[10]
    FaultingModulePath =  $_.InsertionStrings[11]
    }

}
    
    $myObj = New-Object PSobject -Property $ht
    $myObj
    }
}

#see if the class already exists
if ((get-wmiobject -namespace root\cimv2 -list | 
    where-object {$_.Name -eq "MyCustom_Reliability"} | 
    Measure).count -ge 1) 
{
    #Delete old instances > 90 days
    get-wmiobject MyCustom_Reliability -namespace root\cimv2 | 
        Select-Object *, @{label='TimeGenerated2';expression={$_.ConvertToDateTime($_.TimeGenerated)}} | 
        where-object {$_.timegenerated2 -lt ((get-date).AddDays(-90))} | % {
        #Remove old Instances
        $myvar = $_.id
        Get-WmiObject Mycustom_reliability -namespace root\cimv2 -filter "ID='$myvar'" | foreach {$_.delete()}
    }
}
else
{
    #create wmi class
    $retval = New-WMIClass
}

#if you want to filter for only specific .exe, use the following line.
#Get-AppReliabilityRecords where-object {$_.ProductName -eq 'Lync.exe' -or $_.ProductName -eq 'ngvpnmgr.exe' -or $_.ProductName -eq 'outlook.exe'} | 

Get-AppReliabilityRecords |  #this line gets all reliability records
    foreach-object {

 #See if it's already in WMI - if not, add it.
   $time = $_.timegenerated
   if ( (Get-WmiObject Mycustom_reliability -namespace root\cimv2 -filter "TimeGenerated='$time'" | Measure).count -eq 0) {

   #add new instances to the class.
    $onull =  Set-WMIInstance -class MyCustom_Reliability -namespace root\cimv2 -argument @{
            FaultingModule = $_.FaultingModule
            SourceName = $_.SourceName
            TimeGenerated = $_.TimeGenerated
            ProductName = $_.ProductName
            FaultingModuleVersion = $_.FaultingModuleVersion
            FaultingAppPath = $_.FaultingAppPath
            FaultingAppVersion = $_.FaultingAppVersion
            FaultingAppName = $_.FaultingAppName
            FaultingModulePath = $_.FaultingModulePath
            Logfile = $_.Logfile
    }
   }

}