#Backup SSRS Reports
#http://www.sqlmusings.com/2011/03/28/how-to-download-all-your-ssrs-report-definitions-rdl-files-using-powershell/
[void][System.Reflection.Assembly]::LoadWithPartialName("System.Xml.XmlDocument");
[void][System.Reflection.Assembly]::LoadWithPartialName("System.IO");
 
$ReportServerUri = "http://gmrcmcbrtm/ReportServer/ReportService2005.asmx";
$Proxy = New-WebServiceProxy -Uri $ReportServerUri -Namespace SSRS.ReportingService2005 -UseDefaultCredential ;
 
#check out all members of $Proxy
#$Proxy | Get-Member
#http://msdn.microsoft.com/en-us/library/aa225878(v=SQL.80).aspx
 
#second parameter means recursive
$items = $Proxy.ListChildren("/", $true) | `
         select Type, Path, ID, Name | `
         Where-Object {$_.type -eq "Report"};

#create a new folder where we will save the files
#PowerShell datetime format codes http://technet.microsoft.com/en-us/library/ee692801.aspx
 
#create a timestamped folder, format similar to 2011-Mar-28-0850PM
$folderName = Get-Date -format "yyyy-MMM-dd-hhmmtt";
$fullFolderName = "C:\BACKUP\REPORTS-" + $folderName;
[System.IO.Directory]::CreateDirectory($fullFolderName) | out-null
 
foreach($item in $items)
{
    #need to figure out if it has a folder name
    $subfolderName = split-path $item.Path;
    $reportName = split-path $item.Path -Leaf;
    $fullSubfolderName = $fullFolderName + $subfolderName;
    if(-not(Test-Path $fullSubfolderName))
    {
        #note this will create the full folder hierarchy
        [System.IO.Directory]::CreateDirectory($fullSubfolderName) | out-null
    }
 
    $rdlFile = New-Object System.Xml.XmlDocument;
    [byte[]] $reportDefinition = $null;
    $reportDefinition = $Proxy.GetReportDefinition($item.Path);
 
    #note here we're forcing the actual definition to be 
    #stored as a byte array
    #if you take out the @() from the MemoryStream constructor, you'll 
    #get an error
    [System.IO.MemoryStream] $memStream = New-Object System.IO.MemoryStream(@(,$reportDefinition));
    $rdlFile.Load($memStream);
 
    $fullReportFileName = $fullSubfolderName + "\" + $item.Name +  ".rdl";
    #Write-Host $fullReportFileName;
    $rdlFile.Save( $fullReportFileName);
 
}

Add-Type -Assembly 'System.IO.Compression.FileSystem' 
[IO.Compression.ZIPFile]::CreateFromDirectory($fullFolderName, ‘C:\BACKUP\RDLFiles-' + (Get-Date -format 'yyyyMMddHHmm') + '.zip')

Remove-Item -Path $fullFolderName -Recurse -force


