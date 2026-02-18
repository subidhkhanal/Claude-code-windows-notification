# Claude Code Windows Notifications

Get native Windows balloon notifications when Claude Code finishes a task and needs your attention — even when you're in another app.

![Windows 10/11](https://img.shields.io/badge/Windows-10%2F11-blue)
![Claude Code](https://img.shields.io/badge/Claude%20Code-CLI-orange)

## What it does

When Claude Code completes a task that requires your input, a notification pops up near the system tray (bottom-right corner) so you never miss it — even if you're browsing Chrome, coding in VS Code, or doing anything else.

## Quick Setup

### Option 1: Automatic (Recommended)

```powershell
git clone https://github.com/YOUR_USERNAME/claude-code-windows-notifications.git
cd claude-code-windows-notifications
powershell -ExecutionPolicy Bypass -File setup.ps1
```

The setup script will:
1. Create `~/.claude/hooks/` directory if it doesn't exist
2. Copy the notification script there
3. Add the hook to your `~/.claude/settings.json`
4. Send a test notification to verify it works

### Option 2: Manual

**Step 1:** Copy `notify.ps1` to `~/.claude/hooks/`:

```powershell
mkdir "$env:USERPROFILE\.claude\hooks" -Force
copy notify.ps1 "$env:USERPROFILE\.claude\hooks\notify.ps1"
```

**Step 2:** Add the hook to `~/.claude/settings.json`:

```json
{
  "hooks": {
    "Notification": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "powershell.exe -ExecutionPolicy Bypass -File C:\\Users\\YOUR_USERNAME\\.claude\\hooks\\notify.ps1"
          }
        ]
      }
    ]
  }
}
```

Replace `YOUR_USERNAME` with your Windows username.

**Step 3:** Test it:

```powershell
powershell -ExecutionPolicy Bypass -File "$env:USERPROFILE\.claude\hooks\notify.ps1"
```

You should see a balloon notification near the clock.

## Troubleshooting

### No notification appears

1. **Check Windows notifications are enabled:**
   Settings > System > Notifications > make sure it's ON

2. **Check "Get notifications from apps" is enabled** in the same settings page

3. **Test the script directly:**
   ```powershell
   powershell -ExecutionPolicy Bypass -File notify.ps1
   ```

### Notification appears but disappears too fast

Edit `notify.ps1` and increase the `5000` value (milliseconds) in `ShowBalloonTip(5000)` and the `5500` in `Start-Sleep`.

## How it works

- Uses .NET `System.Windows.Forms.NotifyIcon` to create a system tray balloon notification
- Claude Code triggers it via the [hooks system](https://docs.anthropic.com/en/docs/claude-code/hooks) whenever it needs your attention
- No external dependencies — uses built-in Windows/.NET APIs

## Requirements

- Windows 10 or 11
- PowerShell 5.1+ (comes with Windows)
- Claude Code CLI

## License

MIT
