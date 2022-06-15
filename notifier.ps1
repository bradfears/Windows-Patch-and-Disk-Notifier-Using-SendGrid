# script to check for available patches and available disk space

$EmailTo = "email1@example.com"
$EmailFrom = "email2@example.com"
$SMTPServer = "smtp.sendgrid.net"
$SMTPServerPort = 587
$APIKeyID = "apikey" # leave this value as 'apikey'!
$APIKey = "<your API Key value here>"

$UpdateSession = New-Object -ComObject Microsoft.Update.Session
$UpdateSearcher = $UpdateSession.CreateupdateSearcher()
$Updates = @($UpdateSearcher.Search("IsHidden=0 and IsInstalled=0").Updates)

$UpdatesList = ""
for ($num = 0 ; $num -lt ($Updates | Measure-Object).Count ; $num++) {
    $UpdatesList += "<a href='$($Updates[$num].SupportUrl)'><b>$($Updates[$num].Title)</b></a><br/>"
    $UpdatesList += "$($Updates[$num].Description)<br/><br/>"
}

$DiskInfo = ""
$Disk = (Get-CimInstance -ClassName Win32_LogicalDisk)
for ($num = 0 ; $num -lt ($Disk | Measure-Object).Count ; $num++) {
    $DiskSize = [math]::round(($Disk[$num].FreeSpace / 1.0000E+9), 2)
    $DiskSize = "$($DiskSize) GB"
    $DriveLetter = $Disk[$num].DeviceID
    $DiskInfo += "$($DriveLetter) $($DiskSize)<br/>"
}

$Subject = "Patches and disk space report: $((Get-CIMInstance CIM_ComputerSystem).Name)"
$Body = "<b>Updates available:</b><br/><br/>$($UpdatesList)<br/><b>Disk space available:</b><br/><br/>$($DiskInfo)"
#$filenameAndPath = "C:\abc.jpg" # left this here in case you want to send attachments
$SMTPMessage = New-Object System.Net.Mail.MailMessage($EmailFrom,$EmailTo,$Subject,$Body)
$SMTPMessage.IsBodyHTML = $true
#$attachment = New-Object System.Net.Mail.Attachment($filenameAndPath)
#$SMTPMessage.Attachments.Add($attachment)
$SMTPClient = New-Object Net.Mail.SmtpClient($SmtpServer, $SMTPServerPort)
$SMTPClient.EnableSsl = $true 
$SMTPClient.Credentials = New-Object System.Net.NetworkCredential($APIKeyID, $APIKey);
$SMTPClient.Send($SMTPMessage)
