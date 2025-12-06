<#
Back up and update VS Code user keybindings to map F5 globally to run
the workspace task "Open index.html in Chrome (script)".

Usage (will only run when you execute the script):
  powershell -ExecutionPolicy Bypass -File .\set-vscode-global-f5.ps1

The script will:
  - Back up your existing keybindings.json to keybindings.json.bak.TIMESTAMP
  - Add the F5 binding if not present
  - Print the exact JSON entry it added

NOTE: This edits the file at %APPDATA%\Code\User\keybindings.json (standard VS Code).
If you use VS Code Insiders or a different location, edit the script accordingly.
#>

# Paths
$appdata = $env:APPDATA
$settingsPath = Join-Path $appdata 'Code\User\keybindings.json'

if (-not (Test-Path $settingsPath)) {
    Write-Host "No existing keybindings.json found at: $settingsPath"
    Write-Host "A new file will be created with the requested F5 mapping."
}

# Backup
$time = Get-Date -Format 'yyyyMMddHHmmss'
$backupPath = "$settingsPath.bak.$time"
try {
    if (Test-Path $settingsPath) { Copy-Item -Path $settingsPath -Destination $backupPath -Force; Write-Host "Backed up existing keybindings to: $backupPath" }
} catch {
    Write-Warning "Could not create backup: $_"
}

# Read current bindings (or start with empty array)
$content = @()
if (Test-Path $settingsPath) {
    try {
        $raw = Get-Content -Raw -Path $settingsPath -ErrorAction Stop
        if ($raw.Trim().Length -gt 0) {
            $content = ConvertFrom-Json $raw -ErrorAction Stop
        } else {
            $content = @()
        }
    } catch {
        Write-Warning "Failed to parse existing keybindings.json. Aborting to avoid corruption: $_"
        exit 1
    }
} else {
    $content = @()
}

# Prepare the new binding object
$newBinding = [PSCustomObject]@{
    key     = 'f5'
    command = 'workbench.action.tasks.runTask'
    args    = 'Open index.html in Chrome (script)'
    when    = 'editorTextFocus || explorerViewletVisible'
}

# Determine if the binding already exists (by key+command+args)
$exists = $false
foreach ($b in $content) {
    if ($b.key -eq $newBinding.key -and $b.command -eq $newBinding.command -and ($b.args -eq $newBinding.args)) { $exists = $true; break }
}

if ($exists) {
    Write-Host "The requested F5 binding already exists in your keybindings. No changes made."
} else {
    # Append the new binding
    $newList = @()
    $newList += $content
    $newList += $newBinding

    # Write back to file
    try {
        $json = $newList | ConvertTo-Json -Depth 10
        # Ensure parent dir exists
        $dir = Split-Path -Parent $settingsPath
        if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
        $json | Set-Content -Path $settingsPath -Encoding UTF8
        Write-Host "Added F5 binding to: $settingsPath"
    } catch {
        Write-Warning "Failed to write keybindings.json: $_"
        Write-Host "Your backup is at: $backupPath"
        exit 1
    }
}

Write-Host "Done. If you want to revert, restore the backup file to: $settingsPath"
