#Only need to modify one line in this script - search for "$txtConfigMgrSiteServer.Text = "CM2012R2"" (line 157) and replace CM2012R2 with your site server.
#Script also writes to c:\PowerShell\ - it will create that directory, if it doesn't already exist.


#region Constructor

[void][System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
[void][System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")

#endregion

#region Post-Constructor Custom Code

#endregion

#region Form Creation
#Warning: It is recommended that changes inside this region be handled using the ScriptForm Designer.
#When working with the ScriptForm designer this region and any changes within may be overwritten.
#~~< frmCreateCollectionRules >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$frmCreateCollectionRules = New-Object System.Windows.Forms.Form
$frmCreateCollectionRules.ClientSize = New-Object System.Drawing.Size(248, 363)
$frmCreateCollectionRules.Text = "Create Collection Rules"
#~~< statusBar >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$statusBar = New-Object System.Windows.Forms.StatusBar
$statusBar.Dock = [System.Windows.Forms.DockStyle]::Bottom
$statusBar.Location = New-Object System.Drawing.Point(0, 341)
$statusBar.Size = New-Object System.Drawing.Size(248, 22)
$statusBar.SizingGrip = $false
$statusBar.TabIndex = 12
$statusBar.Text = ""
#~~< btnResetForm >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$btnResetForm = New-Object System.Windows.Forms.Button
$btnResetForm.Location = New-Object System.Drawing.Point(159, 63)
$btnResetForm.Size = New-Object System.Drawing.Size(80, 23)
$btnResetForm.TabIndex = 11
$btnResetForm.Text = "Reset Form"
$btnResetForm.UseVisualStyleBackColor = $true
$btnResetForm.add_Click({ResetForm($btnResetForm)})
#~~< chkDelQueryRules >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$chkDelQueryRules = New-Object System.Windows.Forms.CheckBox
$chkDelQueryRules.Location = New-Object System.Drawing.Point(13, 291)
$chkDelQueryRules.Size = New-Object System.Drawing.Size(226, 17)
$chkDelQueryRules.TabIndex = 10
$chkDelQueryRules.Text = "Delete All Existing Query Rules"
$chkDelQueryRules.UseVisualStyleBackColor = $true
#~~< txtSiteCode >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$txtSiteCode = New-Object System.Windows.Forms.TextBox
$txtSiteCode.Location = New-Object System.Drawing.Point(210, 371)
$txtSiteCode.Size = New-Object System.Drawing.Size(46, 20)
$txtSiteCode.TabIndex = 9
$txtSiteCode.Text = ""
$txtSiteCode.Visible = $false
#~~< btnAddSystemsToCollection >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$btnAddSystemsToCollection = New-Object System.Windows.Forms.Button
$btnAddSystemsToCollection.Location = New-Object System.Drawing.Point(12, 314)
$btnAddSystemsToCollection.Size = New-Object System.Drawing.Size(145, 23)
$btnAddSystemsToCollection.TabIndex = 8
$btnAddSystemsToCollection.Text = "Add Systems to Collection"
$btnAddSystemsToCollection.UseVisualStyleBackColor = $true
$btnAddSystemsToCollection.add_Click({AddToColl($btnAddSystemsToCollection)})
#~~< lblEnterComputers >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$lblEnterComputers = New-Object System.Windows.Forms.Label
$lblEnterComputers.Location = New-Object System.Drawing.Point(13, 68)
$lblEnterComputers.Size = New-Object System.Drawing.Size(147, 20)
$lblEnterComputers.TabIndex = 7
$lblEnterComputers.Text = "Enter Computer Names"
#~~< TxtComputers >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$TxtComputers = New-Object System.Windows.Forms.TextBox
$TxtComputers.Location = New-Object System.Drawing.Point(13, 88)
$TxtComputers.MaxLength = 32767000
$TxtComputers.Multiline = $true
$TxtComputers.ScrollBars = [System.Windows.Forms.ScrollBars]::Vertical
$TxtComputers.Size = New-Object System.Drawing.Size(226, 198)
$TxtComputers.TabIndex = 6
$TxtComputers.Text = ""
$TxtComputers.WordWrap = $false
#~~< txtNamespace >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$txtNamespace = New-Object System.Windows.Forms.TextBox
$txtNamespace.Location = New-Object System.Drawing.Point(33, 370)
$txtNamespace.Size = New-Object System.Drawing.Size(46, 20)
$txtNamespace.TabIndex = 5
$txtNamespace.Text = $NameSpace
$txtNamespace.Visible = $false
#~~< btnExit >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$btnExit = New-Object System.Windows.Forms.Button
$btnExit.Location = New-Object System.Drawing.Point(164, 316)
$btnExit.Size = New-Object System.Drawing.Size(75, 23)
$btnExit.TabIndex = 4
$btnExit.Text = "Exit"
$btnExit.UseVisualStyleBackColor = $true
$btnExit.add_Click({btnExit($btnExit)})
#~~< cboCollectionIDs >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$cboCollectionIDs = New-Object System.Windows.Forms.ComboBox
$cboCollectionIDs.FormattingEnabled = $true
$cboCollectionIDs.Location = New-Object System.Drawing.Point(85, 370)
$cboCollectionIDs.Size = New-Object System.Drawing.Size(121, 21)
$cboCollectionIDs.TabIndex = 3
$cboCollectionIDs.Text = ""
$cboCollectionIDs.Visible = $false
#~~< cboCollections >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$cboCollections = New-Object System.Windows.Forms.ComboBox
$cboCollections.Enabled = $false
$cboCollections.FormattingEnabled = $true
$cboCollections.Location = New-Object System.Drawing.Point(13, 40)
$cboCollections.Size = New-Object System.Drawing.Size(226, 21)
$cboCollections.TabIndex = 2
$cboCollections.Text = "Select a Collection"
#~~< btnConnect >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$btnConnect = New-Object System.Windows.Forms.Button
$btnConnect.Location = New-Object System.Drawing.Point(164, 12)
$btnConnect.Size = New-Object System.Drawing.Size(75, 23)
$btnConnect.TabIndex = 1
$btnConnect.Text = "Connect"
$btnConnect.UseVisualStyleBackColor = $true
$btnConnect.add_Click({ConnectToSite($btnConnect)})
#~~< txtConfigMgrSiteServer >~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$txtConfigMgrSiteServer = New-Object System.Windows.Forms.TextBox
$txtConfigMgrSiteServer.Location = New-Object System.Drawing.Point(13, 13)
$txtConfigMgrSiteServer.Size = New-Object System.Drawing.Size(144, 20)
$txtConfigMgrSiteServer.TabIndex = 0
$txtConfigMgrSiteServer.Text = $ServerName
$frmCreateCollectionRules.Controls.Add($statusBar)
$frmCreateCollectionRules.Controls.Add($btnResetForm)
$frmCreateCollectionRules.Controls.Add($chkDelQueryRules)
$frmCreateCollectionRules.Controls.Add($txtSiteCode)
$frmCreateCollectionRules.Controls.Add($btnAddSystemsToCollection)
$frmCreateCollectionRules.Controls.Add($lblEnterComputers)
$frmCreateCollectionRules.Controls.Add($TxtComputers)
$frmCreateCollectionRules.Controls.Add($txtNamespace)
$frmCreateCollectionRules.Controls.Add($btnExit)
$frmCreateCollectionRules.Controls.Add($cboCollectionIDs)
$frmCreateCollectionRules.Controls.Add($cboCollections)
$frmCreateCollectionRules.Controls.Add($btnConnect)
$frmCreateCollectionRules.Controls.Add($txtConfigMgrSiteServer)


#endregion

#region Custom Code


function log($strText)
{
    #Create c:\PowerShell if it doesn't already exist
    if ((test-path c:\powershell) -eq $False) {md c:\PowerShell}
	Write-Host $strText
	$statusBar.Text = $strText	
	$strText >> "c:\powershell\$(( get-date ).ToString('yyyyMMdd'))-AddQueryRules.log"

}


$date = (Get-Date).ToString()
log "*************************************************************"
log "    Start $date "
log "*************************************************************"
$txtConfigMgrSiteServer.Text = "CM2012R2"
$chkDelQueryRules.Checked = $True

function CreateCollectionQueryRule($Coll, $Server, $Namespace, $Computers, $RuleName)
{
	$wqlqUERY = "select SMS_R_SYSTEM.ResourceID,SMS_R_SYSTEM.ResourceType,SMS_R_SYSTEM.Name,SMS_R_SYSTEM.SMSUniqueIdentifier,SMS_R_SYSTEM.ResourceDomainORWorkgroup,SMS_R_SYSTEM.Client from SMS_R_System WHERE Name in (" + $Computers + ")"
	$wmiclass = "\\" + $Server + "\" + $NameSpace + ":sms_CollectionRuleQuery"
	$wmiclass
	$CollQuery = ([wmiclass]$wmiclass).CreateInstance()
	$collquery.QueryExpression = $wqlqUERY
	$CollQuery.RuleName = $RuleName
	$coll = gwmi sms_collection -namespace $Namespace -computer $server | Where-Object { $_.CollectionID -eq $coll }
	
	log "Adding Membership Rule"
	log ("     Query Rule Name: " + $RuleName)
	log ("     Query WQL: " + $wqlQuery)
	$coll.AddMembershipRule($CollQuery)
									
									
}

function DeleteAllQueryRules($Coll, $Server, $NameSpace)
{
	
	log ("Deleting Collection Query Rules from " + $Coll)
	$strPath = (gwmi sms_collection -namespace $NameSpace -computer $server | Where-Object { $_.CollectionID -eq $coll }).__Path
	$collwmi = [wmi]$strPath
	$collWMI.DeleteMembershipRules($collWMI.CollectionRules)
}





#endregion

function Main{
	[System.Windows.Forms.Application]::EnableVisualStyles()
	[System.Windows.Forms.Application]::Run($frmCreateCollectionRules)
}

#region Event Handlers



function ConnectToSite($object)
{
	$cboCollections.items.clear()
	$cboCollectionIDs.items.clear()
	#$chkDelQueryRules.Checked = $True
	$txtComputers.Text = $null
	
	log ("Site Server Name = " + $txtConfigMgrSiteServer.Text)
	$SMSServer = $txtConfigMgrSiteServer.Text		
	
	log ("Connecting to site..." + $SMSServer)
	$oSite = Get-WmiObject -class SMS_ProviderLocation -Namespace `
	ROOT\SMS -ComputerName $SMSServer | where { $_.ProviderForLocalSite -eq "True" }
	$oNS = "ROOT\SMS\Site_" + $oSite.SiteCode
	$ns = $oSite.NamespacePath	
	
	log ("NameSpace = " + $ons)
	$txtNamespace.Text = $ons
	$txtSiteCode.Text = $oSite.Sitecode
	
	log "Gathering Collection Info...."
	$cboCollections.Enabled = $True
		
	$myQuery = "select * from SMS_Collection" # where CollectioNID in (" + $cb + ")"
	$Collections = gwmi -namespace $oNS -computer $SMSServer -query $myQuery | Sort-Object Name

			$Collections | foreach {
				$i += 1
				
				log ("    Found Collections - " + ($_.Name) + "   " + $_.CollectionID)
				$cboCollections.Items.Add($_.Name)
				$cboCollectionIDs.Items.Add($_.CollectionID)
	}
	$cboCollections.Enabled = $True
	
	log "Select a Collection, and enter Computer Names"
}

function btnExit($object)
{
	log "Exit!"
	$frmCreateCollectionRules.Close()
	
}

function AddToColl($object)
{
	$b = $null
	$c = $null
	$CollMax = 2000
	$intCount = 0
	$strQueryRuleName = "Query"
	$strQueryRuleNumber = 0
	$server = $txtConfigMgrSiteServer.Text
	$SiteCode = $txtSiteCode.Text 
	$NameSpace = $txtNamespace.Text
	$CollName = $cboCollections.items[$cboCollections.SelectedIndex]
	$Coll = $cboCollectionIDs.items[$cboCollections.SelectedIndex]
	if ($Coll -ne $Null)
	{
				
		if ($chkDelQueryRules.Checked -eq $True)
		{
			log "Deleting all Query Rules!"
			DeleteAllQueryRules $Coll $Server $NameSpace
			
		}
				
				
		log "Preparing to add systems to collection...."
		log ("Server Name: "+  $Server	)
	
		log ("Collection Name: " + $CollName)
		log ("Collection ID: " + $Coll)
				
		($txtComputers.Text).split("`n") | foreach {
			if ($_.Length -gt 1)
			{
				$b += "`"" + $_.trim() + "`"" + ","
			}
			$intCount++
			if ($intCount -eq $CollMax)
			{
				$c = $b.Remove(($b.length-1), 1)
				
				$strQueryRuleNumber++
				log ("Adding " + $intCount + " items to the collection")
				
				log ("Collection = " + $Coll)
				
				log ("Creating Query Named " + $strQueryRuleName + "for Collection " + $Coll)
				CreateCollectionQueryRule $Coll $Server $NameSpace $c ( $strQueryRuleName + $strQueryRuleNumber )
										
				$intCount = 0
				$c = $null
				$b = $null
			}
		}
			
		if ($intCount -gt 0)
		{
			
			$c = $b.Remove(($b.length-1), 1)
			
			$strQueryRuleNumber++
			log "Adding items to the collection"
			log ("Count = " + $intCount)
			log ("Server = " + $Server)
			
			log ("Collection = " + $Coll)
			log ("QueryRuleName = " + ( $strQueryRuleName + $strQueryRuleNumber ))
			log ("Creating Query Named " + $QueryRuleName + "for Collection " + $Coll)
			CreateCollectionQueryRule $Coll $Server $NameSpace $c ( $strQueryRuleName + $strQueryRuleNumber )
		}
		#$a = New-Object -comobject wscript.shell
		log "Add to Collection Complete!"
		#$a.popup("Add to Collection Complete!", 0, "Added to Collection Complete!", 0)
			
	}
	
}

function ResetForm( $object ){
$txtComputers.Text = $null
}

Main # This call must remain below all other event functions

#endregion



	