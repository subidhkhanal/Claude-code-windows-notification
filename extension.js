const vscode = require('vscode');
const fs = require('fs');
const path = require('path');
const os = require('os');

/**
 * Sets up Claude Code hooks for Windows notifications.
 * Copies notify.ps1 to ~/.claude/hooks/ and registers Stop + Notification hooks.
 */
function setupHooks(context) {
    const claudeDir = path.join(os.homedir(), '.claude');
    const hooksDir = path.join(claudeDir, 'hooks');
    const settingsPath = path.join(claudeDir, 'settings.json');

    const sourceScript = path.join(context.extensionPath, 'scripts', 'notify.ps1');
    const destScript = path.join(hooksDir, 'notify.ps1');

    // Create ~/.claude/hooks/ directory
    fs.mkdirSync(hooksDir, { recursive: true });

    // Copy notify.ps1
    fs.copyFileSync(sourceScript, destScript);

    // Read existing settings or start fresh
    let settings = {};
    try {
        const content = fs.readFileSync(settingsPath, 'utf8');
        settings = JSON.parse(content);
    } catch {
        // File doesn't exist or invalid JSON — start fresh
    }

    // Build hook command using the destination path
    const escapedPath = destScript.replace(/\\/g, '\\\\');
    const hookCommand = `powershell.exe -ExecutionPolicy Bypass -File ${escapedPath}`;

    const hookConfig = [{
        matcher: '',
        hooks: [{
            type: 'command',
            command: hookCommand
        }]
    }];

    // Merge hooks into settings (preserve existing keys)
    if (!settings.hooks) {
        settings.hooks = {};
    }
    settings.hooks.Stop = hookConfig;
    settings.hooks.Notification = hookConfig;

    // Write settings back
    fs.writeFileSync(settingsPath, JSON.stringify(settings, null, 2), 'utf8');

    vscode.window.showInformationMessage('Claude Code Windows notifications enabled!');
}

function activate(context) {
    try {
        setupHooks(context);
    } catch (err) {
        vscode.window.showErrorMessage(`Claude notifications setup failed: ${err.message}`);
    }

    // Register manual setup command
    const disposable = vscode.commands.registerCommand('claude-notifications.setup', () => {
        try {
            setupHooks(context);
        } catch (err) {
            vscode.window.showErrorMessage(`Claude notifications setup failed: ${err.message}`);
        }
    });

    context.subscriptions.push(disposable);
}

function deactivate() {}

module.exports = { activate, deactivate };
