# Claude Code Windows Notifications - Setup Script
# Run this script to install the notification hook automatically

$hooksDir = "$env:USERPROFILE\.claude\hooks"
$settingsFile = "$env:USERPROFILE\.claude\settings.json"
$scriptSource = Join-Path $PSScriptRoot "notify.ps1"
$scriptDest = Join-Path $hooksDir "notify.ps1"

# Create hooks directory
if (-not (Test-Path $hooksDir)) {
    New-Item -ItemType Directory -Path $hooksDir -Force | Out-Null
    Write-Host "[OK] Created hooks directory: $hooksDir" -ForegroundColor Green
} else {
    Write-Host "[OK] Hooks directory already exists" -ForegroundColor Green
}

# Copy notification script
Copy-Item -Path $scriptSource -Destination $scriptDest -Force
Write-Host "[OK] Copied notify.ps1 to $scriptDest" -ForegroundColor Green

# Update settings.json
$hookCommand = "powershell.exe -ExecutionPolicy Bypass -File $($scriptDest -replace '\\', '\\')"

$hookEntry = @{
    type = "command"
    command = $hookCommand
}

$hookConfig = @{
    matcher = ""
    hooks = @($hookEntry)
}

if (Test-Path $settingsFile) {
    $settings = Get-Content $settingsFile -Raw | ConvertFrom-Json
} else {
    $settings = [PSCustomObject]@{}
}

# Add hooks.Notification if not present
if (-not $settings.hooks) {
    $settings | Add-Member -NotePropertyName "hooks" -NotePropertyValue ([PSCustomObject]@{})
}

$settings.hooks | Add-Member -NotePropertyName "Notification" -NotePropertyValue @($hookConfig) -Force

$settings | ConvertTo-Json -Depth 10 | Set-Content $settingsFile -Encoding UTF8
Write-Host "[OK] Updated settings.json with notification hook" -ForegroundColor Green

# Test notification
Write-Host ""
Write-Host "Testing notification..." -ForegroundColor Cyan
& $scriptDest
Write-Host "[OK] Setup complete! You should have seen a test notification." -ForegroundColor Green
Write-Host ""
Write-Host "Claude Code will now notify you when tasks complete." -ForegroundColor White
