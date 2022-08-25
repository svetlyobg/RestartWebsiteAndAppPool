#Restart a Web App Pool and IIS a Wesbsite
#CopyLeft SVET :)

[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") 
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
Add-Type -AssemblyName System.Windows.Forms

$FormObject=[System.Windows.Forms.Form]
$LabelObject=[System.Windows.Forms.Label]
$ComboBoxObject=[System.Windows.Forms.ComboBox]
  
$Form = New-Object System.Windows.Forms.Form
$Form.Size = New-Object System.Drawing.Size(850,510)
$Form.Text = "AppPool and IIS Restarter (v1.0.4)"
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
$textBoxOut.Location = New-Object System.Drawing.Size(5,50)
$textBoxOut.Multiline = $true;
$textBoxOut.ScrollBars = "Vertical"
$textBoxOut.Size = New-Object System.Drawing.Size(800,300)
$textBoxOut.Text = ""
$form.Controls.Add($textBoxOut)

$lblService = New-Object $LabelObject
$lblService.Text='Services'
$lblService.AutoSize=$true
$lblService.Location = New-Object System.Drawing.Point(10,10)

$lblStatus = New-Object $LabelObject
$lblStatus.Text = "Status: "
$lblStatus.AutoSize = $true
$lblStatus.Location = New-Object System.Drawing.Point(250,10)
$form.Controls.Add($lblStatus)


$ddlService=New-Object $ComboBoxObject
#$ddlService.Width = '300'
$ddlService.Location = New-Object System.Drawing.Point(80,10)

#Get-Service | ForEach-Object {$ddlService.Items.Add($_.Name)}
$Services = Get-Service

foreach ($service in $Services){
    $ddlService.Items.Add($service.name)
}


$Form.Controls.AddRange(@($lblService,$ddlService))


function GetServiceDetails{
    $ServiceName = $ddlService.SelectedItem
    $details = Get-Service -name $Servicename | Select-Object DisplayName, Status
    $lblStatus.Text = $details.status

    if ($lblStatus.Text -eq 'Running'){
        $lblStatus.ForeColor = 'Green'        
    }
    Else {
        $lblStatus.ForeColor = 'Red'
    }
}

#GetServiceDetails

function restart {
    Restart-Service $ddlService.SelectedItem
}

$ddlService.Add_SelectedIndexChanged({GetServiceDetails})

# Restart Button
$ButtonRestart = New-Object System.Windows.Forms.Button 
$ButtonRestart.Location = New-Object System.Drawing.Size(350,10) 
$ButtonRestart.Size = New-Object System.Drawing.Size(170,30) 
$ButtonRestart.Text = "ReStart"
#$ButtonRestart.Add_Click({""})
$ButtonRestart.Add_Click({restart})
GetServiceDetails
$s = $ddlService.SelectedItem
$ButtonRestart.Add_Click({$textBoxOut.Text = "$s was Successfully Restarted"})
$Form.Controls.Add($ButtonRestart)

$Form.Add_Shown({$Form.Activate()})
[void] $Form.ShowDialog()