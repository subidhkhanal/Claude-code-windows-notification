Add-Type -AssemblyName System.Windows.Forms

# Defaults
$title = "Claude Code"
$text = "Task completed - needs your attention"
$tipIcon = [System.Windows.Forms.ToolTipIcon]::Info
$trayIcon = [System.Drawing.SystemIcons]::Information

# Read JSON input from stdin (provided by Claude Code hooks)
if ([Console]::IsInputRedirected) {
    try {
        $jsonInput = [Console]::In.ReadToEnd()
        if ($jsonInput) {
            $data = $jsonInput | ConvertFrom-Json

            switch ($data.hook_event_name) {
                "Stop" {
                    $title = "Claude Code"
                    $text = "Task completed - needs your attention"
                }
                "Notification" {
                    switch ($data.notification_type) {
                        "permission_prompt" {
                            $title = "Claude Code - Permission Needed"
                            $text = if ($data.message) { $data.message } else { "Claude needs your permission to proceed" }
                            $tipIcon = [System.Windows.Forms.ToolTipIcon]::Warning
                            $trayIcon = [System.Drawing.SystemIcons]::Warning
                        }
                        default {
                            if ($data.message) { $text = $data.message }
                        }
                    }
                }
            }
        }
    } catch {
        # JSON parsing failed, use defaults
    }
}

$balloon = New-Object System.Windows.Forms.NotifyIcon
$balloon.Icon = $trayIcon
$balloon.BalloonTipTitle = $title
$balloon.BalloonTipText = $text
$balloon.BalloonTipIcon = $tipIcon
$balloon.Visible = $true
$balloon.ShowBalloonTip(5000)

Start-Sleep -Milliseconds 5500
$balloon.Dispose()
