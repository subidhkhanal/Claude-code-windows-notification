# Claude Code Windows Notification

Native Windows balloon notifications when Claude Code finishes a task or asks for permission — even when you're in another app.

![Windows 10/11](https://img.shields.io/badge/Windows-10%2F11-blue)
![VS Code](https://img.shields.io/badge/VS%20Code-Extension-007ACC)

## Install

### From .vsix file

1. Download the `.vsix` file from [Releases](https://github.com/SubidhKhanal/Claude-code-windows-notification/releases)
2. In VS Code: Extensions sidebar → `...` menu → **Install from VSIX...**
3. Restart VS Code — done!

### From source

```bash
git clone https://github.com/SubidhKhanal/Claude-code-windows-notification.git
cd Claude-code-windows-notification
npx @vscode/vsce package
```

Then install the generated `.vsix` file via the method above.

## What it does

You'll get a Windows balloon notification (near the system tray) when:

- **Task completed** — Claude finished and is waiting for your next message
- **Permission needed** — Claude wants to run a tool and needs your approval

No manual setup required. The extension automatically configures Claude Code hooks on startup.

## How it works

On activation, the extension:

1. Copies the notification script to `~/.claude/hooks/`
2. Registers two [Claude Code hooks](https://docs.anthropic.com/en/docs/claude-code/hooks) in `~/.claude/settings.json`:
   - **`Stop`** — fires immediately when Claude finishes responding
   - **`Notification`** — fires when Claude needs permission or the user has been idle
3. When a hook fires, it runs a PowerShell script that shows a native Windows balloon notification

## Commands

| Command | Description |
|---------|-------------|
| `Claude Notifications: Setup Hooks` | Re-run the hook setup (useful after updates) |

## Requirements

- Windows 10 or 11
- VS Code 1.74+
- Claude Code CLI

## License

MIT
