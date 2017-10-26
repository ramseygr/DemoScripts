Exit



##Change ADR Package
#Create new Software Update Deployment Package
$pkg = New-CMSoftwareUpdateDeploymentPackage `
    -Name 'SUM WRK 2017 Oct' `
    -Description 'SUM WRK 2017 06 June' `
    -Path '\\gmrcmtp\source\Software Updates\SUM WRK 2017 Oct'

#Distribute the SOftware Update Deployment Package
Start-CMContentDistribution -DeploymentPackageName 'SUM WRK 2017 Oct' -DistributionPointGroupName 'Americas'

#Modify the ADR Package
$ADR = Get-CMSoftwareUpdateAutoDeploymentRule -Name 'Patch Tuesday'
$Template = [XML]$ADR.ContentTemplate

#Print out the new configuration
$Template.OuterXml

$Template.ContentActionXML.PackageID = $pkg.PackageID

#Print out the new configuration
$Template.OuterXml

#Save the new configuration
$ADR.ContentTemplate = $Template.OuterXml
$ADR.Put()

#Remove-CMSoftwareUpdateDeploymentPackage -name 'SUM WRK 2017 Oct'




#region Demosetup

New-CMSoftwareUpdateGroup -Name 'SUM WRK 2017 July'
New-CMSoftwareUpdateGroup -Name 'SUM WRK 2017 August'
New-CMSoftwareUpdateGroup -Name 'SUM WRK 2017 September'

#endregion

# Combine mulitple  Software Update Groups
    #Create new Software Update Group for 2017 Updates
    New-CMSoftwareUpdateGroup -Name 'Rollup Updates Compliance - SUM WRK 2017'

    #Get Standard 2017 Software Updates Groups
    Get-CMSoftwareUpdateGroup -Name 'SUM WRK 2017*' -ForceWildcardHandling |
        ForEach-Object {
            foreach($Update in $PsItem.Updates){
                Add-CMSoftwareUpdateToGroup -SoftwareUpdateId $Update `
                    -SoftwareUpdateGroupName 'Rollup Updates Compliance - SUM WRK 2017'
            }
        }     


#Cleanup expired and superseded from update groups and update packages

#region Remove Superseded Updates from Software Update Group - CB 1702
Remove-CMSoftwareUpdateFromGroup `
    -SoftwareUpdateGroupName 'SUM WRK 2017 July' -SoftwareUpdateId 16777852 -Force

# Get all Software Update Groups
$SoftwareUpdateGroups = Get-CMSoftwareUpdateGroup

# Get all Superseded updates
$SupersededUpdates = Get-CMSoftwareUpdate -IsSuperseded $True -Fast | 
    Select-Object -Property LocalizedDisplayName,CI_ID

foreach($Update in $SupersededUpdates){
    Write-Output -InputObject "Processing update $($Update.CI_ID)"

    foreach($SWGroup in $SoftwareUpdateGroups){
        If($Update.CI_ID -in $SWGroup.Updates){

            #Write-Output -InputObject "---$($Update.CI_ID) is in $($SWGroup.LocalizedDisplayName)"

            Remove-CMSoftwareUpdateFromGroup -SoftwareUpdateGroupName $SWGroup.LocalizedDisplayName `
                -SoftwareUpdateId $Update.CI_ID -Force
        }
    }
}

#endregion


Set-CMSoftwareUpdateGroup `
    -name "Rollup Updates Compliance - SUM WRK 2017" `
    -ClearExpiredSoftwareUpdate -ClearSupersededSoftwareUpdate

Set-CMSoftwareUpdateDeploymentPackage -Name "SUM WRK 2017 Sep" `
    -RemoveExpired -RemoveSuperseded -RefreshDistributionPoint







#region Build SW Update Group for Win10

New-CMSoftwareUpdateGroup -name "Win10"
# Software Updates
(Get-CMSoftwareUpdate -DatePostedMax ((Get-Date).AddMonths(-1)) -Fast -IsExpired $False -IsSuperseded $False).count

# Get the Product IDs
$ProductCategories = Get-CimInstance `
    -ClassName SMS_UpdateCategoryInstance `
    -Filter 'CategoryTypeName="Product" and IsSubscribed=1' `
    -Namespace 'ROOT\SMS\Site_PS1'

#Windows 10 ProductID - a3c2375d-0c8a-42f9-bce0-28333e198407
#Windows 10 LTSB ProductID - d2085b71-5f1f-43a9-880d-ed159016d5c6
$AllowedProducts = @(
    'a3c2375d-0c8a-42f9-bce0-28333e198407'
    'd2085b71-5f1f-43a9-880d-ed159016d5c6'
)

$SoftwareUpdates = Get-CMSoftwareUpdate `
    -DatePostedMax ((Get-Date).AddMonths(-1)) `
    -Fast -IsExpired $False -IsSuperseded $False

#Look at productID
$SoftwareUpdates | select -first 1

foreach($Update in $SoftwareUpdates){
    $UpdateXMLDoc = [System.Xml.XmlDocument]$Update.ApplicabilityCondition
    If($AllowedProducts.Contains($UpdateXMLDoc.ApplicabilityRule.ProductId)){
        Write-Output -InputObject "$($Update.CI_ID),$($Update.LocalizedDisplayName) "
        Add-CMSoftwareUpdateToGroup -SoftwareUpdateGroupName Win10 -SoftwareUpdateId $Update.CI_ID
    }
}
#endregion
