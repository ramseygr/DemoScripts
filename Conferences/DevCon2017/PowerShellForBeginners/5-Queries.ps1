Exit


#region Import CM Module
$CMModulePath = `
    $Env:SMS_ADMIN_UI_PATH.ToString().SubString(0,$Env:SMS_ADMIN_UI_PATH.Length - 5) `
    + "\ConfigurationManager.psd1" 
Import-Module $CMModulePath -force
cd GMR:
#endregion

#display all queries
get-cmquery | out-gridview

#run a query
Invoke-CMQuery -Name 'All Systems'

#sample - ping each
Invoke-CMQuery -Name 'All Systems' | foreach  {
    "{0}={1}" -f $_.name,  (Test-Connection $_.name -quiet -Count 1)
}



#use Gridview to select and run a query
get-cmquery  | out-gridview -PassThru | invoke-cmquery

