#Restart a Web App Pool and IIS a Wesbsite
#CopyLeft SVET :)
#Not Working (yet) on PowerShell 7

[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") 
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
Add-Type -AssemblyName System.Windows.Forms

$FormObject=[System.Windows.Forms.Form]
$LabelObject=[System.Windows.Forms.Label]
$ComboBoxObject=[System.Windows.Forms.ComboBox]
  
$Form = New-Object System.Windows.Forms.Form
$Form.Size = New-Object System.Drawing.Size(850,510)
$Form.Text = "AppPool and IIS Restarter (v1.0.6)"
$Form.StartPosition = "CenterScreen"
$Icon = [system.drawing.icon]::ExtractAssociatedIcon($PSHOME + "\powershell.exe")
$Form.MinimizeBox = $False
$Form.MaximizeBox = $False
$Form.WindowState = "Normal"
$Form.SizeGripStyle = "Hide"
$Form.Icon = $Icon
$Form.BackColor='#ff7cab'

# Output TextBox
$textBoxOut = New-Object System.Windows.Forms.TextBox
$textBoxOut.Location = New-Object System.Drawing.Size(5,100)
$textBoxOut.Multiline = $true;
$textBoxOut.ScrollBars = "Vertical"
$textBoxOut.Size = New-Object System.Drawing.Size(800,150)
$textBoxOut.Text = ""
$form.Controls.Add($textBoxOut)

$lblWebsite = New-Object $LabelObject
$lblWebsite.Text='Services'
$lblWebsite.AutoSize=$true
$lblWebsite.Location = New-Object System.Drawing.Point(10,10)

$lblStatus = New-Object $LabelObject
$lblStatus.Text = "Status: "
$lblStatus.AutoSize = $true
$lblStatus.Location = New-Object System.Drawing.Point(250,10)
$form.Controls.Add($lblStatus)


$ddlWebsite=New-Object $ComboBoxObject
#$ddlWebsite.Width = '300'
$ddlWebsite.Location = New-Object System.Drawing.Point(80,10)

#Get-Service | ForEach-Object {$ddlWebsite.Items.Add($_.Name)}
$Websites = Get-Website

foreach ($website in $Websites){
    $ddlWebsite.Items.Add($website.name)
}


$Form.Controls.AddRange(@($lblWebsite,$ddlWebsite))


function GetWebsiteDetails{
    $websiteName = $ddlWebsite.SelectedItem
    $details = Get-Website -name $websitename | Select-Object Name, State
    $lblStatus.Text = $details.state
    

    if ($lblStatus.Text -eq 'Started'){
        $lblStatus.ForeColor = 'Green'        
    }
    Else {
        $lblStatus.ForeColor = 'Red'
    }
}

#GetWebsiteDetails

function restart {
    Restart-WebAppPool $ddlWebsite.SelectedItem
    Stop-Website $ddlWebsite.SelectedItem
    Start-Website $ddlWebsite.SelectedItem
}

$ddlWebsite.Add_SelectedIndexChanged({GetWebsiteDetails})

# Restart Button
$ButtonRestart = New-Object System.Windows.Forms.Button 
$ButtonRestart.Location = New-Object System.Drawing.Size(5,50) 
$ButtonRestart.Size = New-Object System.Drawing.Size(200,30) 
$ButtonRestart.Text = "ReStart"
#$ButtonRestart.Add_Click({""})
$ButtonRestart.Add_Click({restart})
GetWebsiteDetails
$s = $ddlWebsite.SelectedItem
$ButtonRestart.Add_Click({$textBoxOut.Text = "$s was Successfully Restarted"})
$Form.Controls.Add($ButtonRestart)

# Output TextBox2
$textBoxOut2 = New-Object System.Windows.Forms.TextBox
$textBoxOut2.Location = New-Object System.Drawing.Size(5,300)
$textBoxOut2.Multiline = $true;
$textBoxOut2.ScrollBars = "Vertical"
$textBoxOut2.Size = New-Object System.Drawing.Size(800,150)
$textBoxOut2.Text = ""
$var1 = Get-Website | Select-Object Name, State | Out-String
$textBoxOut2.Text = $var1
$form.Controls.Add($textBoxOut2)

$Form.Add_Shown({$Form.Activate()})
[void] $Form.ShowDialog()