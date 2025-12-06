param(
    [string]$FilePath = "index.html",
    [switch]$UseFileUrl
)

Write-Host "--- debug-open.ps1 starting ---"
Write-Host "Requested FilePath:`t$FilePath"

$fp = Resolve-Path -Path $FilePath -ErrorAction SilentlyContinue
if (-not $fp) {
    Write-Host "Resolve-Path failed for:`t$FilePath"
    exit 1
}
$full = $fp.Path
Write-Host "Resolved:`t$full"

$possible = @(
    "$env:ProgramFiles\Google\Chrome\Application\chrome.exe",
    "$env:ProgramFiles(x86)\Google\Chrome\Application\chrome.exe"
)

$chrome = $null
foreach ($p in $possible) {
    Write-Host "Checking:`t$p"
    if (Test-Path $p) { $chrome = $p; break }
}

if (-not $chrome) {
    $cmd = Get-Command chrome.exe -ErrorAction SilentlyContinue
    if ($cmd) { $chrome = $cmd.Source }
}

Write-Host "Chrome found:`t$chrome"
if ($UseFileUrl) {
    $fileUrl = 'file:///' + ($full -replace '\\','/')
    $fileUrl = $fileUrl -replace ' ', '%20'
    Write-Host "Starting Chrome with file URL:`t$fileUrl"
    if ($chrome) {
        Start-Process -FilePath $chrome -ArgumentList $fileUrl
        Write-Host "Start-Process called successfully."
    } else {
        Write-Host "Chrome not found - opening with default browser instead."
        Start-Process $fileUrl
    }
} else {
    Write-Host "Starting Chrome with argument:`t$full"
    if ($chrome) {
        Start-Process -FilePath $chrome -ArgumentList $full
        Write-Host "Start-Process called successfully."
    } else {
        Write-Host "Chrome not found - opening with default browser instead."
        Start-Process $full
    }
}
Write-Host "--- debug-open.ps1 finished ---"