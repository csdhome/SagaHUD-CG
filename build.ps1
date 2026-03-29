
$env:LUA_PATH = "$PWD/lua/?.lua;$PWD/util/?.lua;$PWD/lib/?.lua;$PWD/util/du-mocks/dumocks/?.lua"
& du-lua build release

# Read version from project.json and inject as global into compiled output
$versionJson = Get-Content -Path "$PWD/project.json" | ConvertFrom-Json
$version = $versionJson.version
if (-not $version) {
    Write-Error "Version could not be found"
    exit
}
$confPath = "$PWD/out/release/Saga.conf"
$conf = Get-Content -Path $confPath -Raw
$conf = $conf -replace "SAGA_VERSION", "`"$version`""
Set-Content -Path $confPath -Value $conf -Encoding UTF8

# Inject full slot definitions into conf for proper element linking
$conf = Get-Content -Path $confPath -Raw
$oldSlots = "slots:`n  core:`n    name: core`n    class: CoreUnit`n    select: null`n    type:`n      events: []`n      methods: []"
$newSlots = "slots:`n  core:`n    class: CoreUnit`n  databank:`n    class: databank`n    select: manual`n  radar:`n    class: RadarPVPUnit`n    select: all`n  warpdrive:`n    class: WarpDriveUnit`n  antigrav:`n    class: AntiGravityGeneratorUnit`n  shield:`n    class: ShieldGeneratorUnit`n  telemeter:`n    class: TelemeterUnit"
$conf = $conf -replace [regex]::Escape($oldSlots), $newSlots
Set-Content -Path $confPath -Value $conf -Encoding UTF8

(Get-Content -Path "$PWD/out/release/Saga.conf" -Raw) `
    -replace "Saga Saga", "SagaHUD $version" |
    Out-File -Encoding UTF8 "$PWD/SagaHud.conf"