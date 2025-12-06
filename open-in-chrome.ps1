<#
Open a file in Google Chrome (falls back to default browser).
Usage:
  .\open-in-chrome.ps1 -FilePath "index.html"
  .\open-in-chrome.ps1              # opens ./index.html
#>
param(
    [string]$FilePath = "index.html"
)

# Resolve the file path
$resolved = Resolve-Path -Path $FilePath -ErrorAction SilentlyContinue
if (-not $resolved) {
    Write-Error "File not found: $FilePath"
    exit 1
}
$full = $resolved.Path

# Common Chrome locations
$possible = @(
    "$env:ProgramFiles\Google\Chrome\Application\chrome.exe",
    "$env:ProgramFiles(x86)\Google\Chrome\Application\chrome.exe"
)

$chrome = $null
foreach ($p in $possible) { if (Test-Path $p) { $chrome = $p; break } }

# If not found, try to find chrome.exe on PATH
if (-not $chrome) {
    $cmd = Get-Command chrome.exe -ErrorAction SilentlyContinue
    if ($cmd) { $chrome = $cmd.Source }
}

if ($chrome) {
    Start-Process -FilePath $chrome -ArgumentList $full
} else {
    Write-Host "Google Chrome not found - opening with default browser instead."
    Start-Process $full
}
