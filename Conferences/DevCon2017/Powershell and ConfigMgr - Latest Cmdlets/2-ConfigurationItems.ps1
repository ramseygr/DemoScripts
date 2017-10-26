Exit

#configuration item - Create CI, script-based setting rule, 

#Tidy Cache
$TCDiscover = @'
#Discovery
$MinDays = 60
$UIResourceMgr = New-Object -ComObject UIResource.UIResourceMgr
$Cache = $UIResourceMgr.GetCacheInfo()
($Cache.GetCacheElements() |
where-object {
    [datetime]$_.LastReferenceTime -lt (get-date).adddays(-$mindays)} |
Measure-object).Count
'@

$TCRemediate = @'
#Remediation
$MinDays = 60
$UIResourceMgr = New-Object -ComObject UIResource.UIResourceMgr
$Cache = $UIResourceMgr.GetCacheInfo()
$Cache.GetCacheElements() |
where-object {
    [datetime]$_.LastReferenceTime -lt (get-date).adddays(-$mindays)} |
foreach {
$Cache.DeleteCacheElement($_.CacheElementID)
}
'@

$CI = New-CMConfigurationItem `
    -Name 'CI - TidyCache' -CreationType WindowsOS

get-command -Module ConfigurationManager -Noun CMComp*

Show-Command Add-CMComplianceSettingScript

Add-CMComplianceSettingScript `
    -Datatype Integer `
    -DiscoveryScriptLanguage PowerShell `
    -ExpectedValue 0 `
    -ExpressionOperator IsEquals `
    -InputObject $CI `
    -Name 'Cache Less than 60 Days' `
    -RuleName 'Cache Less than 60 days' `
    -ValueRule `
    -DiscoveryScriptText $TCDiscover `
    -RemediationScriptLanguage PowerShell `
    -RemediationScriptText $TCRemediate `
    -Is64Bit
    #-Remediate      #Doesn't work - bug filed.
    

New-CMBaseline -Name 'ConfigMgr Client Maintenance'

Set-CMBaseline -name 'ConfigMgr Client Maintenance' `
    -AddOSConfigurationItem (Get-CMConfigurationItem  "CI - TidyCache" | 
    select CI_ID -ExpandProperty CI_ID)

$Sched = New-CMSchedule -RecurCount 30 `
    -RecurInterval Days -Start ([datetime] "10/28/2017 02:00")

New-CMBaselineDeployment -name 'ConfigMgr Client Maintenance' -CollectionName 'Workstations' `
    -EnableEnforcement $true -OverrideServiceWindow $true -Schedule $sched


# Remove-CMBaseline -Name 'ConfigMgr Client Maintenance' -Force
# Remove-CMConfigurationItem -Name 'CI - TidyCache' -Force



#GPO Checker (prototype) - 
#https://blogs.msdn.microsoft.com/ameltzer/2017/04/20/powershell-how-to-add-compliance-settings-and-rules-to-configuration-items-1704-tp/


Function Get-GPSettings {

    Param( 
        [string]$Key, 
        [string]$GPOName 
    )

        $CurrentRegKey = Get-GPRegistryValue -Name $GPOName -Key $Key

        If($CurrentRegKey -eq $null){ 
            Return 
        } 
        Foreach ($RegKey in $CurrentRegKey) { 
            If ($RegKey.ValueName -ne $null){

                [ARRAY]$ReturnKey += $RegKey 
            } 
            Else{
                Get-GPSettings -Key $RegKey.FullKeyPath -GPOName $GPOName
            } 
        }

    Return $ReturnKey             
}

$GPOName = 'Credential Guard'
Write-Output -InputObject "Using the GPO: $GPOName"

$Key = 'HKLM\Software\Policies'
Write-Output -InputObject "Using the Key: $Key"

$Settings = Get-GPSettings -Key $Key -GPOName $GPOName


#region Import CM Module
$CMModulePath = `
    $Env:SMS_ADMIN_UI_PATH.ToString().SubString(0,$Env:SMS_ADMIN_UI_PATH.Length - 5) `
    + "\ConfigurationManager.psd1" 
Import-Module $CMModulePath -force
cd PS1:
#endregion

Set-Location ps1:\

foreach($GPSetting in $Settings){

    IF($GPSetting){
        Switch($GPSetting.Value.GetType().Name){
        
        'Int32'{$DataType = 'Integer'}
        }

        Switch($GPSetting.Hive){
        
        'LocalMachine' {$Hive = 'LocalMachine'}
        }

        $CI = New-CMConfigurationItem -Name "CI - CG - $($GPSetting.ValueName)" -CreationType WindowsOS

        Add-CMComplianceSettingRegistryKeyValue `
                -SettingName "$($GPSetting.ValueName)" `
                -RuleName "$($GPSetting.ValueName) must be $($GPSetting.Value)" `
                -DataType $DataType  `
                -Hive $Hive `
                -KeyName $GPSetting.KeyPath `
                -ValueName $GPSetting.ValueName `
                -ValueRule `
                -ExpressionOperator IsEqual `
                -ExpectedValue $GPSetting.Value `
                -InputObject (Get-CMConfigurationItem -Name "CI - CG - $($GPSetting.ValueName)") `
                -Remediate
    }
    
}




New-CMBaseline -Name "Credential Guard Check"
Set-CMBaseline -name "Credential Guard Check" `
    -AddOSConfigurationItem (Get-CMConfigurationItem  "CI - CG -*" | 
    select CI_ID -ExpandProperty CI_ID)



New-CMBaselineDeployment -name "Credential Guard Check" -CollectionName "Workstations" `
    -EnableEnforcement $true -OverrideServiceWindow $true


# Remove-CMBaseline -Name 'Credential Guard Check' -Force
# Remove-CMConfigurationItem -Name 'CI - CG -*' -Force