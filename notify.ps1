Add-Type -AssemblyName System.Windows.Forms

$balloon = New-Object System.Windows.Forms.NotifyIcon
$balloon.Icon = [System.Drawing.SystemIcons]::Information
$balloon.BalloonTipTitle = "Claude Code"
$balloon.BalloonTipText = "Task completed - needs your attention"
$balloon.BalloonTipIcon = [System.Windows.Forms.ToolTipIcon]::Info
$balloon.Visible = $true
$balloon.ShowBalloonTip(5000)

Start-Sleep -Milliseconds 5500
$balloon.Dispose()
