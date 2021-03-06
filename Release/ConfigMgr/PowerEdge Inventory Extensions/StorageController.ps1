

#Code for creating the storage controller class
Function CreateWMIClass{
    #CIMTYPE Enum:http://msdn.microsoft.com/en-us/library/system.management.cimtype.aspx
    $newClass = New-Object System.Management.ManagementClass `
        ("root\cimv2\Dell", [String]::Empty, $null); 

    $newClass["__CLASS"] = "DellCustom_StorageController"; 

    $newClass.Qualifiers.Add("Static", $true)
    $newClass.Properties.Add("ID", [System.Management.CimType]::String, $false)
    $newClass.Properties["ID"].Qualifiers.Add("Key", $true)
    $newClass.Properties.Add("Abort_Check_Consistency_on_Error", [System.Management.CimType]::String, $false)
    $newClass.Properties.Add("Alarm_State", [System.Management.CimType]::String, $false)
    $newClass.Properties.Add("Allow_Revertible_Hot_Spare_and_Replace_Member", [System.Management.CimType]::String, $false)
    $newClass.Properties.Add("Auto_Replace_Member_on_Predictive_Failure", [System.Management.CimType]::String, $false)
    $newClass.Properties.Add("BGI_Rate", [System.Management.CimType]::String, $false)
    $newClass.Properties.Add("Cache_Memory_Size", [System.Management.CimType]::String, $false)
    $newClass.Properties.Add("CacheCade_Capable", [System.Management.CimType]::String, $false)
    $newClass.Properties.Add("Check_Consistency_Rate", [System.Management.CimType]::String, $false)
    $newClass.Properties.Add("Cluster_Mode", [System.Management.CimType]::String, $false)
    $newClass.Properties.Add("Driver_Version", [System.Management.CimType]::String, $false)
    $newClass.Properties.Add("Encryption_Capable", [System.Management.CimType]::String, $false)
    $newClass.Properties.Add("Encryption_Key_Present", [System.Management.CimType]::String, $false)
    $newClass.Properties.Add("Encryption_Mode", [System.Management.CimType]::String, $false)
    $newClass.Properties.Add("Firmware_Version", [System.Management.CimType]::String, $false)
    #$newClass.Properties.Add("ID", [System.Management.CimType]::String, $false)
    $newClass.Properties.Add("Load_Balance", [System.Management.CimType]::String, $false)
    $newClass.Properties.Add("Minimum_Required_Driver_Version", [System.Management.CimType]::String, $false)
    $newClass.Properties.Add("Minimum_Required_Firmware_Version", [System.Management.CimType]::String, $false)
    $newClass.Properties.Add("Minimum_Required_Storport_Driver_Version", [System.Management.CimType]::String, $false)
    $newClass.Properties.Add("Name", [System.Management.CimType]::String, $false)
    $newClass.Properties.Add("Number_of_Connectors", [System.Management.CimType]::String, $false)
    $newClass.Properties.Add("Patrol_Read_Iterations", [System.Management.CimType]::String, $false)
    $newClass.Properties.Add("Patrol_Read_Mode", [System.Management.CimType]::String, $false)
    $newClass.Properties.Add("Patrol_Read_Rate", [System.Management.CimType]::String, $false)
    $newClass.Properties.Add("Patrol_Read_State", [System.Management.CimType]::String, $false)
    $newClass.Properties.Add("Persistent_Hot_Spare", [System.Management.CimType]::String, $false)
    $newClass.Properties.Add("Rebuild_Rate", [System.Management.CimType]::String, $false)
    $newClass.Properties.Add("Reconstruct_Rate", [System.Management.CimType]::String, $false)
    $newClass.Properties.Add("Redundant_Path_view", [System.Management.CimType]::String, $false)
    $newClass.Properties.Add("SCSI_Initiator_ID", [System.Management.CimType]::String, $false)
    $newClass.Properties.Add("Slot_ID", [System.Management.CimType]::String, $false)
    $newClass.Properties.Add("Spin_Down_Hot_Spares", [System.Management.CimType]::String, $false)
    $newClass.Properties.Add("Spin_Down_Unconfigured_Drives", [System.Management.CimType]::String, $false)
    $newClass.Properties.Add("State", [System.Management.CimType]::String, $false)
    $newClass.Properties.Add("Status", [System.Management.CimType]::String, $false)
    $newClass.Properties.Add("Storport_Driver_Version", [System.Management.CimType]::String, $false)
    $newClass.Properties.Add("Time_Interval_for_Spin_Down_in_Minutes", [System.Management.CimType]::String, $false)
    $newClass.Put()
}

#see if the class already exists
if ((get-wmiobject -namespace root\cimv2\dell -list | where-object {$_.Name -eq "DellCustom_StorageController"} | Measure).count -ge 1) 
{
    #delete all instances
    get-wmiobject DellCustom_StorageController -namespace root\cimv2\dell | foreach  {
        $_.Delete()
    }
}
else
{
    #create wmi class
    $retval = CreateWMIClass

}

Try {
$colStorage = ConvertFrom-Csv -inputobject ((omreport storage controller -fmt ssv)[4..500]) -delimiter ";"
}
catch {
    "Failure running omreport"
}
$colStorage | foreach {
   $onull =  Set-WMIInstance -class DellCustom_StorageController -namespace root\cimv2\dell -argument @{
        Abort_Check_Consistency_on_Error = $_."Abort Check Consistency on Error "
        Alarm_State = $_."Alarm State"
        Allow_Revertible_Hot_Spare_and_Replace_Member = $_."Allow Revertible Hot Spare and Replace Member"
        Auto_Replace_Member_on_Predictive_Failure = $_."Auto Replace Member on Predictive Failure"
        BGI_Rate = $_."BGI Rate"
        Cache_Memory_Size = $_."Cache Memory Size"
        CacheCade_Capable = $_."CacheCade Capable"
        Check_Consistency_Rate = $_."Check Consistency Rate"
        Cluster_Mode = $_."Cluster Mode"
        Driver_Version = $_."Driver Version"
        Encryption_Capable = $_."Encryption Capable"
        Encryption_Key_Present = $_."Encryption Key Present"
        Encryption_Mode = $_."Encryption Mode"
        Firmware_Version = $_."Firmware Version"
        ID = $_."ID"
        Load_Balance = $_."Load Balance"
        Minimum_Required_Driver_Version = $_."Minimum Required Driver Version"
        Minimum_Required_Firmware_Version = $_."Minimum Required Firmware Version"
        Minimum_Required_Storport_Driver_Version = $_."Minimum Required Storport Driver Version"
        Name = $_."Name"
        Number_of_Connectors = $_."Number of Connectors"
        Patrol_Read_Iterations = $_."Patrol Read Iterations"
        Patrol_Read_Mode = $_."Patrol Read Mode"
        Patrol_Read_Rate = $_."Patrol Read Rate"
        Patrol_Read_State = $_."Patrol Read State"
        Persistent_Hot_Spare = $_."Persistent Hot Spare"
        Rebuild_Rate = $_."Rebuild Rate"
        Reconstruct_Rate = $_."Reconstruct Rate"
        Redundant_Path_view = $_."Redundant Path view "
        SCSI_Initiator_ID = $_."SCSI Initiator ID"
        Slot_ID = $_."Slot ID"
        Spin_Down_Hot_Spares = $_."Spin Down Hot Spares"
        Spin_Down_Unconfigured_Drives = $_."Spin Down Unconfigured Drives"
        State = $_."State"
        Status = $_."Status"
        Storport_Driver_Version = $_."Storport Driver Version"
        Time_Interval_for_Spin_Down_in_Minutes = $_."Time Interval for Spin Down (in Minutes)"
    }

}

