# Ubuntu unattended-upgrades notification script

Notes:  
- You do NOT need to clone this repo, just download the .ps1 script.
- This is NOT a replacement for Windows Update.

requirements:
1. SendGrid.com account
2. Windows Server 2016+
3. notifier.ps1 script (here in this repo)
---------------------------

## Instructions
- Sign up for a free [SendGrid.com](https://sendgrid.com) account
- Wait for them to review your use case (~24 hour response time)
- Verify your sender address or domain
- Get your API keys
	1. Log into your account at **SendGrid.com**.
	2. On your Dashboard, select **Email API** -> Integration Guide.
	3. On the Integrate page, choose **SMTP Relay**.
	4. If you have not already created an API key, you can do so on the _How to send email using the SMTP Relay_ page.
	5. Note that Username is listed as "apikey". That's the username you should use, because the authentication is actually done with the API Key value (very long string).
	6. Note the server name: **smtp.sendgrid.net**
	7. Various ports are available, but **587** works just fine.
	8. **Password** is obviously your API Key value (again, it's a very long string).

- Download a [copy of script](/notifier.ps1)
-- this will be the script you run on the server

- Change the 

- Configure the Windows Task Scheduler to run the script once per week (or your choice)
The code below will run the script once per week on Sundays at 23:00.

```
$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "<location of script>\notifier.ps1"
$trigger = New-ScheduledTaskTrigger -Weekly -DaysOfWeek Sunday -At "23:00" -WeeksInterval 1
$settings = New-ScheduledTaskSettingsSet
$task = New-ScheduledTask -Action $action -Trigger $trigger -Settings $settings
Register-ScheduledTask 'Patch and disk notifier' -InputObject $task
```
