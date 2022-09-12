#region Import CM Module
$CMModulePath = `
    $Env:SMS_ADMIN_UI_PATH.ToString().SubString(0,$Env:SMS_ADMIN_UI_PATH.Length - 5) `
    + "\ConfigurationManager.psd1" 
Import-Module $CMModulePath -force
cd CHQ:
#endregion

Get-CMQuery | Out-GridView


Invoke-CMQuery -Name 'Computer Details' | Out-GridView

Get-CMQuery | Select Name, QueryID | Out-GridView -PassThru | % { Invoke-CMQuery -id $_.queryID} 

#invoke-CMWMIQuery
$wql = 'select Name, ADSiteName, Build, ClientVersion  from sms_r_system'
invoke-cmwmiquery -Query $wql | out-gridview
