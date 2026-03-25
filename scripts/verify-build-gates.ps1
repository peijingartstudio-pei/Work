param(
    [string]$WorkRoot = "",
    [switch]$LobsterOnly
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

if (-not $WorkRoot) {
    $WorkRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
} else {
    $WorkRoot = (Resolve-Path $WorkRoot).Path
}

$bootstrap = Join-Path $WorkRoot "lobster-factory\scripts\bootstrap-validate.mjs"
if (-not (Test-Path $bootstrap)) {
    Write-Error "verify-build-gates: missing $bootstrap"
    exit 1
}

Write-Host "== Lobster Factory: bootstrap-validate ==" -ForegroundColor Cyan
$hadWr = Test-Path env:LOBSTER_WORK_ROOT
$prevWr = $env:LOBSTER_WORK_ROOT
$env:LOBSTER_WORK_ROOT = $WorkRoot
try {
    & node $bootstrap
    if ($LASTEXITCODE -ne 0) {
        Write-Error "verify-build-gates: bootstrap-validate failed (exit $LASTEXITCODE)"
        exit $LASTEXITCODE
    }
} finally {
    if ($hadWr) { $env:LOBSTER_WORK_ROOT = $prevWr }
    else { Remove-Item Env:\LOBSTER_WORK_ROOT -ErrorAction SilentlyContinue }
}

if ($LobsterOnly) {
    Write-Host "verify-build-gates: LobsterOnly -> skipped agency-os health check" -ForegroundColor Yellow
    Write-Host "verify-build-gates: ALL PASSED (lobster only)" -ForegroundColor Green
    exit 0
}

$agencyRoot = Join-Path $WorkRoot "agency-os"
$healthScript = Join-Path $agencyRoot "scripts\system-health-check.ps1"
if (-not (Test-Path $healthScript)) {
    Write-Error "verify-build-gates: missing agency-os health script at $healthScript (use -LobsterOnly to skip)"
    exit 1
}

Write-Host "== Agency OS: system-health-check ==" -ForegroundColor Cyan
& powershell -ExecutionPolicy Bypass -NoProfile -File $healthScript -WorkspaceRoot $agencyRoot
if ($LASTEXITCODE -ne 0) {
    Write-Error "verify-build-gates: system-health-check failed (exit $LASTEXITCODE)"
    exit $LASTEXITCODE
}

Write-Host "verify-build-gates: ALL PASSED" -ForegroundColor Green
