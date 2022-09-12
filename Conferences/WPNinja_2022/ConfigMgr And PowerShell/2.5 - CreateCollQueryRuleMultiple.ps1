#region Script Settings
#<ScriptSettings xmlns="http://tempuri.org/ScriptSettings.xsd">
#  <ScriptPackager>
#    <process>powershell.exe</process>
#    <arguments />
#    <extractdir>%TEMP%</extractdir>
#    <files />
#    <usedefaulticon>true</usedefaulticon>
#    <showinsystray>false</showinsystray>
#    <altcreds>false</altcreds>
#    <efs>true</efs>
#    <ntfs>true</ntfs>
#    <local>false</local>
#    <abortonfail>true</abortonfail>
#    <product />
#    <version>1.0.0.1</version>
#    <versionstring />
#    <comments />
#    <company />
#    <includeinterpreter>false</includeinterpreter>
#    <forcecomregistration>false</forcecomregistration>
#    <consolemode>false</consolemode>
#    <EnableChangelog>false</EnableChangelog>
#    <AutoBackup>false</AutoBackup>
#    <snapinforce>false</snapinforce>
#    <snapinshowprogress>false</snapinshowprogress>
#    <snapinautoadd>0</snapinautoadd>
#    <snapinpermanentpath />
#    <cpumode>1</cpumode>
#    <hidepsconsole>false</hidepsconsole>
#  </ScriptPackager>
#</ScriptSettings>
#endregion

#PARAM 
#(
#	[String]$serverName,
#	[String]$NameSpace,
#	[String]$CollectionID,
#	[String]$CollectionName
#) 


#region ScriptForm Designer

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
#region$frmCreateCollectionRules.Icon = ([System.Drawing.Icon](...)
$frmCreateCollectionRules.Icon = ([System.Drawing.Icon](New-Object System.Drawing.Icon((New-Object System.IO.MemoryStream(($$ = [System.Convert]::FromBase64String(
"AAABAAEAICAAAAEAIACoEAAAFgAAACgAAAAgAAAAQAAAAAEAIAAAAAAAAAAAABMLAAATCwAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAhoSEMZaVlIB2dna3"+
                                "eXh613p5eu1oZ2jtZ2Vn7Xh3eO2Hhofhf35/wXh2d46Bf39IoJ+eAwAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAkZCQTIiG"+
                                "hruOjY36bGts/0NCRP87Ojz/KScq/x8eIP8dHB7/JCMl/zIxM/9CQUP/Wllb/4B/f/99e3vOhYOD"+
                                "YrSysQQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "kZCPFYaFhaF+fH3/X15g/ycmKP8LCgz/BwYI/wcGCP8KCQv/DAsN/wwLDf8KCQv/CAcJ/wYFB/8I"+
                                "Bwn/Gxoc/0hHSf94dnj/iIaGxrq4uDgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAALSysTqFhIPWcXBx/ygnKv8GBQf/CQgK/w0MDv8ODQ//Dg0P/w4ND/8ODQ//Dg0P"+
                                "/w4ND/8ODQ//Dg0P/w4ND/8LCgz/BQQF/xcWGP9cW13/hIOD95yammQAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAADOzcxRmZeX81pZWv8ODhD/CAcJ/w4ND/8ODQ//Dg0P/w4ND/8O"+
                                "DQ//Dg0P/w4ND/8ODQ//Dg0P/w4ND/8ODQ//Dg0P/w4ND/8ODQ//CwoM/wUEBv89PD7/enl6/7i3"+
                                "t4QAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAy8rKN3VzdPdNTE//BwYJ/wwLDf8ODQ//Dg0P"+
                                "/w4ND/8ODQ//Dg0P/w4ND/8ODQ//Dg0P/w4ND/8ODQ//Dg0P/w4ND/8ODQ//Dg0P/w4ND/8ODQ//"+
                                "Dg0P/wMCBf8vLjD/e3p7/7u6umUAAAAAAAAAAAAAAAAAAAAAAAAAAO3s7BF2dHXVUE9Q/xwcH/8M"+
                                "Cw3/Dg0P/w4ND/8ODQ//Dg0P/w4ND/8ODQ//Dg0P/w4ND/8ODQ//Dg0P/w4ND/8ODQ//Dg0P/w4N"+
                                "D/8ODQ//Dg0P/w4ND/8ODQ//Dg0P/wMCBP86OTv/hoSE+NPR0TUAAAAAAAAAAAAAAAAAAAAAnZuc"+
                                "mFlYWf8vLzL/KSks/w4ND/8ODQ//Dg0P/w4ND/8ODQ//Dg0P/w4ND/8ODQ//Dg0P/w4ND/8ODQ//"+
                                "Dg0P/w4ND/8ODQ//Dg0P/w4ND/8ODQ//Dg0P/w4ND/8ODQ//Dg0P/wQDBv9VVFX/lJOSyuPi4QUA"+
                                "AAAAAAAAAKSioilqaWr7QUFE/y4uMf8wMDP/ExIU/w0MDv8ODQ//Dg0P/w4ND/8ODQ//Dw4Q/w8O"+
                                "EP8PDhD/Dw4Q/w8OEP8ODQ//Dg0P/w4ND/8ODQ//Dg0P/w4ND/8ODQ//Dg0P/w4ND/8ODQ//DAsN"+
                                "/xEQEv91dHT/vr29bwAAAAAAAAAAioiJp2JhY/8qKi3/MTE0/zMzNv8gHyL/DAsN/w4ND/8ODQ//"+
                                "EA8R/xEQEv8SERP/EhET/xIRE/8SERP/EhET/xAPEf8PDhD/Dg0P/w4ND/8ODQ//Dg0P/w4ND/8O"+
                                "DQ//Dg0P/w4ND/8ODQ//BQQG/zw7PP+OjY3a1NLRB8C+vhiBgIDwQkFE/y0tMP8wMDP/MTE0/y4u"+
                                "Mf8SERP/Dg0P/xEQEv8TEhT/ExIU/xQTFf8TEhT/ExIU/xQTFf8TEhT/ExIU/xEQEv8PDhD/Dg0O"+
                                "/w4ND/8ODQ//Dg0P/w0MDv8ODQ//Dg0P/w4ND/8MCw3/ExIU/359fv+rq6pRoJ+fZnZ1dv8wMDP/"+
                                "Kysu/ywsL/8sLC//Li0x/xsbHv8IBwn/ExIU/xQTFP8VFBb/Dw4R/xUUF/8XFhn/Dw4R/xUUF/8V"+
                                "FBb/EQ8R/w8OEP8NDA7/DAsN/wwLDf8MCw7/DQwO/w0MDv8NDA7/DQwO/w0MDv8FBAb/TUxO/6Cf"+
                                "n5yTkpKbVFNW/z4+Qf+tq6z/tbO0/7m4uP+7urr/paWl/01MTv8KCQv/FBMV/wwLDv81Mzb/kY+P"+
                                "/5aUk/88Oz3/CwoO/xIRFP9raWr/cG9u/2FfX/9SUVL/SkhK/0ZFR/9WVFb/RkRG/0RDRP9CQUP/"+
                                "QkFC/xkYGv8yMTP/n56dzoeGhsBLSk3/SklM/+Xj4//t6+r/9/b0//79/P//////9fT0/1ZVV/8I"+
                                "Bwr/X15f/727uv/Ny8r/z87M/8PBwP9sa2v/FxYZ/4yMjP+enZv/iIaF/3p4d/9nZ2f/Xl1e/21r"+
                                "bP9aWFn/WVdY/1lYWf9aWFn/JSMl/yAfIf+XlZXoi4qK6khHSv9KSkz/393d/+zr6v+WlZX/k5KT"+
                                "/+zr6v///v7/1tXV/6qpqf/OzMr/z8/O/9fW1f/Hxsb/xcXE/9bV0/+amJj/npyc/52cnP+Jh4b/"+
                                "XFtb/0dGR/9HRkf/a2lq/1lXWP9RUFH/Ojk6/zo5Ov8cGx3/EBAS/4OBge6CgIDuRkZI/0tKTf/g"+
                                "3t3/8fDv/2RjZf8SEhb/oaCh//7+/v/+/f3///////Ly8f/j4uH/8fDv/7+9vf9XVlj/np6e/8/N"+
                                "zP+0sbD/oaCf/4mIh/8cGx3/BAMF/yMiJP9tbG3/W1la/0dFR/8KCQv/CwoM/wwLDf8NDA7/fnx8"+
                                "7YiGhu9GRkj/S0pN/+Df3v/y8fD/Y2Nk/x8fIv+0tLT//v39/////////////////8HAwP+ysbH/"+
                                "/////83MzP9kY2T/bm1t/6+trP+mpaT/i4qJ/yAfIf8IBwn/JSQm/25sbf9bWVr/SEZI/w0MDv8O"+
                                "DQ//DQwO/wwLDf+DgoLtnZub5kpJTP9KSUz/4N/e/+zr6v+7u7r/wL+///b19f//////zc3N/7e2"+
                                "t///////8vLy/56en/+Pjo//4+Hh/+Hg3/9TUlT/joyN/6qpqP+Lion/IB8h/wgHCf8lJCb/bmxt"+
                                "/1tZWv9IRkj/DQwO/w4ND/8MCw3/ExEU/5STk+6mpKO7VFNV/0pJTP/q5+f/8/Lx//38+v//////"+
                                "/////+Tj5P9WVVj/IyMm/3x7ff/s7Oz//////9PT0/+GhYb/a2ts/xoZHP+WlJT/rqyr/4+NjP8h"+
                                "ICH/CAcJ/yYlJ/9ycXH/X11e/0xKS/8NDA7/Dg0P/woJC/8lIyX/s7Kx5bu5uZZubW7/Nzc6/5WU"+
                                "lf+dnJ3/oaCg/6CfoP+Hh4j/QkJE/yoqLf8wMDP/JSUo/0ZGSP+3trb/ycnJ/05NUP8kJCj/Kysu"+
                                "/3BvcP9xcHD/W1la/xoZG/8KCQv/HRwe/05NTv9BQEH/MzIz/w4ND/8ODQ//BgUH/zo5O//HxsXH"+
                                "z87MXKempv8rKy//Jycq/ycnKv8nJyv/JiYq/yUlKf8tLTD/MTE0/zExNP8xMTT/Kysu/y0sL/8v"+
                                "LzL/Kysu/zIyNf8yMjX/LS0w/yUlKP8WFhj/DQwO/w0MDv8NDA7/CgkL/wsKDP8LCgz/Dg0P/w4N"+
                                "D/8DAgT/ZGNj/9LQz5Ts6+sQysjH50dGSf8rKy7/MTE0/zExNP8xMTT/MTE0/zExNP8xMTT/MTE0"+
                                "/zExNP8xMTT/MDAz/zAwM/8xMTT/MTE0/zExNP8xMTT/MjI1/zIyNf8lJSf/ERAS/wwLDf8ODQ//"+
                                "Dg0P/w4ND/8ODQ//DAsN/xEQE/+lpKT+0c/ORQAAAADS0dCTiIiJ/yUlKf8xMTT/MTE0/zExNP8x"+
                                "MTT/MTE0/zExNP8xMTT/MTE0/zExNP8xMTT/MTE0/zExNP8xMTT/MTE0/zExNP8xMTT/MTE0/zMz"+
                                "Nv8tLTD/FhYY/wwLDf8ODQ//Dg0P/w4ND/8EAwX/SEhJ/8jGxdLo5+YEAAAAANbU1B6xr6/1SkpN"+
                                "/ysrLv8xMTT/MTE0/zExNP8xMTT/MTE0/zExNP8xMTT/MTE0/zExNP8xMTT/MTE0/zExNP8xMTT/"+
                                "MTE0/zExNP8xMTT/MTE0/zMzNv8xMTT/Ghkc/wwLDf8ODQ//CwoM/xEQEv+Qj4//6OfmYQAAAAAA"+
                                "AAAAAAAAAM/OzYKKiYn/LS0w/y8vMv8xMTT/MTE0/zExNP8xMTT/MTE0/zExNP8xMTT/MTE0/zEx"+
                                "NP8xMTT/MTE0/zExNP8xMTT/MTE0/zExNP8xMTT/MTE0/zIyNf8yMjX/Hh0f/wwLDf8GBQf/XFtc"+
                                "/5aVlbvp6egDAAAAAAAAAAAAAAAA8/LyB6+urb9xcHH/KCgr/zAwM/8xMTT/MTE0/zExNP8xMTT/"+
                                "MTE0/zExNP8xMTT/MTE0/zExNP8xMTT/MTE0/zExNP8xMTT/MTE0/zExNP8xMTT/MTE0/zIyNf8z"+
                                "Mzb/EhEU/0NCQ/+FhITt1NPTJAAAAAAAAAAAAAAAAAAAAAAAAAAA4d/fJaCfnupqaWv/KCgr/zAw"+
                                "M/8xMTT/MTE0/zExNP8xMTT/MTE0/zExNP8xMTT/MTE0/zExNP8xMTT/MTE0/zExNP8xMTT/MTE0"+
                                "/zExNP8xMTT/MTE0/yoqLf9LS03/enh5/Ly7u0kAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "1dTTOJ+eneZxcHL/LCwv/ysrL/8xMTT/MTE0/zExNP8xMTT/MTE0/zExNP8xMTT/MTE0/zExNP8x"+
                                "MTT/MTE0/zExNP8xMTT/MTE0/y4uMv8rKy7/UE9R/2tpavq7ubppAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAvry8J52bmr2GhYX/RURH/ycoK/8tLTD/MTE0/zExNP8xMTT/MTE0"+
                                "/zExNP8xMTT/MTE0/zExNP8xMTT/MTE0/y8vMv8qKi7/Ozs+/2BfYf93dXXmkI+OSwAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAsK+uB7i2tYKjoqH1c3Fz/0FBRP8w"+
                                "LzP/Kiot/ywsL/8tLTD/Li4x/y4uMf8tLTD/LCwv/ysrLv8vLzL/Ozs+/1tZXP9raWr+e3l6qLa1"+
                                "tCIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AMrJySuenZycg4KC5nZ1dv9VVFb/TUxP/0hHSv9FREf/RkZI/0hHSv9KSkz/Tk1P/2ZlZf9wb2/0"+
                                "b21ts3RyckAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAACRj48XjIuKYYSCgpmGhITDjIuL7H17fO1samvtdHJz7Xx7"+
                                "e9Vxb3Cla2lqb3JxcSQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA/8AB"+
                                "//8AAH/8AAA/+AAAH/AAAA/gAAAHwAAAA8AAAAGAAAABgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"+
                                "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAIAAAACAAAABwAAAAcAAAAPgAAAH8AAAD/gAAB/8"+
                                "AAA//wAA///AA/8=")),0,$$.Length)))))
#endregion

#endregion

#region Custom Code


function log($strText)
{

	Write-Host $strText
	$statusBar.Text = $strText	
	$strText >> "c:\scripts\$(( get-date ).ToString('yyyyMMdd'))-AddQueryRules.log"

}


$date = (Get-Date).ToString()
log "*************************************************************"
log "    Start $date "
log "*************************************************************"
$txtConfigMgrSiteServer.Text = "."
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

#region Event Loop

function Main{
	[System.Windows.Forms.Application]::EnableVisualStyles()
	[System.Windows.Forms.Application]::Run($frmCreateCollectionRules)
}

#endregion

#endregion

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



	