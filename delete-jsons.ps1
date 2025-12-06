$root = "C:\Users\genev\Downloads\Hack Club\Meow"
$folder = Join-Path $root ".vscode\chrome-user-data"
if (Test-Path $folder) {
    Remove-Item -Recurse -Force $folder -ErrorAction SilentlyContinue
    Write-Host "Deleted: $folder"
} else {
    Write-Host "Not found: $folder"
}

Write-Host ""
Write-Host "Remaining JSON files in workspace:"
Get-ChildItem -Path $root -Recurse -Filter '*.json' -ErrorAction SilentlyContinue | ForEach-Object { Write-Host $_.FullName }
