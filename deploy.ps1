
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

# Copy tankdata if present
$tankSrc = "$PWD\autoconf\custom\saga\tankdata.lua"
if (Test-Path $tankSrc) {
    Copy-Item -Path $tankSrc -Destination "$sagaDir\tankdata.lua" -Force
    Write-Host "Deployed: saga/tankdata.lua"
}

Write-Host "`nDeploy complete to: $duCustom"
