
# Deploy SagaHUD to Dual Universe autoconf directory
$duCustom = "C:\ProgramData\My Dual Universe\Game\data\lua\autoconf\custom"

if (-not (Test-Path $duCustom)) {
    Write-Error "DU autoconf directory not found: $duCustom"
    exit 1
}

# Ensure saga subdirectory exists
$sagaDir = "$duCustom\saga"
if (-not (Test-Path $sagaDir)) {
    New-Item -ItemType Directory -Path $sagaDir | Out-Null
}

# Copy the built conf file
Copy-Item -Path "$PWD\SagaHud.conf" -Destination "$duCustom\SagaHud.conf" -Force
Write-Host "Deployed: SagaHud.conf"

# Copy atlas if present
if (Test-Path "$PWD\atlas.lua") {
    Copy-Item -Path "$PWD\atlas.lua" -Destination "$duCustom\atlas.lua" -Force
    Write-Host "Deployed: atlas.lua"
}

# Copy all saga runtime modules from autoconf/custom/saga/
$sagaSrc = "$PWD\autoconf\custom\saga"
if (Test-Path $sagaSrc) {
    $files = Get-ChildItem -Path $sagaSrc -Filter "*.lua"
    foreach ($file in $files) {
        Copy-Item -Path $file.FullName -Destination "$sagaDir\$($file.Name)" -Force
        Write-Host "Deployed: saga/$($file.Name)"
    }
    Write-Host "Deployed $($files.Count) saga module(s)"
} else {
    Write-Warning "saga source directory not found: $sagaSrc"
}

Write-Host "`nDeploy complete to: $duCustom"
