param(
    [string]$WorkRoot = "",
    [switch]$SkipVerify,
    [switch]$AllowUnexpectedDirty
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

if ($WorkRoot) {
    $WorkRoot = (Resolve-Path $WorkRoot).Path
} elseif ($PSScriptRoot) {
    $WorkRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
} else {
    $WorkRoot = (Get-Location).Path
}

$checkScript = Join-Path $WorkRoot "scripts\check-three-way-sync.ps1"
if (-not (Test-Path -LiteralPath $checkScript)) {
    Write-Error "ao-resume: missing check script at $checkScript"
    exit 1
}

Write-Host "== AO-RESUME: preflight auto-fix ==" -ForegroundColor Cyan
$args = @(
    "-NoProfile",
    "-ExecutionPolicy", "Bypass",
    "-File", $checkScript,
    "-WorkRoot", $WorkRoot,
    "-AutoFix"
)
if ($SkipVerify) { $args += "-SkipVerify" }
if ($AllowUnexpectedDirty) { $args += "-AllowUnexpectedDirty" }

& powershell.exe @args
if ($LASTEXITCODE -ne 0) {
    Write-Error "ao-resume: preflight check failed (exit $LASTEXITCODE)."
    exit $LASTEXITCODE
}

Write-Host "AO-RESUME preflight completed: repo is synced and ready." -ForegroundColor Green
exit 0
param(
    [string]$WorkRoot = "",
    [switch]$SkipVerify,
    [switch]$AllowUnexpectedDirty
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

if ($WorkRoot) {
    $WorkRoot = (Resolve-Path $WorkRoot).Path
} elseif ($PSScriptRoot) {
    $WorkRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
} else {
    $WorkRoot = (Get-Location).Path
}

$checkScript = Join-Path $WorkRoot "scripts\check-three-way-sync.ps1"
if (-not (Test-Path -LiteralPath $checkScript)) {
    Write-Error "ao-resume: missing check script at $checkScript"
    exit 1
}

Write-Host "== AO-RESUME: preflight auto-fix ==" -ForegroundColor Cyan
$args = @(
    "-NoProfile",
    "-ExecutionPolicy", "Bypass",
    "-File", $checkScript,
    "-WorkRoot", $WorkRoot,
    "-AutoFix"
)
if ($SkipVerify) { $args += "-SkipVerify" }
if ($AllowUnexpectedDirty) { $args += "-AllowUnexpectedDirty" }

& powershell.exe @args
if ($LASTEXITCODE -ne 0) {
    Write-Error "ao-resume: preflight check failed (exit $LASTEXITCODE)."
    exit $LASTEXITCODE
}

Write-Host "AO-RESUME preflight completed: repo is synced and ready." -ForegroundColor Green
exit 0
param(
    [string]$WorkRoot = "",
    [switch]$SkipVerify
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

if ($WorkRoot) {
    $WorkRoot = (Resolve-Path $WorkRoot).Path
} elseif ($PSScriptRoot) {
    $WorkRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
} else {
    $WorkRoot = (Get-Location).Path
}

$checkScript = Join-Path $WorkRoot "scripts\check-three-way-sync.ps1"
if (-not (Test-Path -LiteralPath $checkScript)) {
    Write-Error "ao-resume: missing check script at $checkScript"
    exit 1
}

Write-Host "== AO-RESUME: preflight auto-fix ==" -ForegroundColor Cyan
$args = @(
    "-NoProfile",
    "-ExecutionPolicy", "Bypass",
    "-File", $checkScript,
    "-WorkRoot", $WorkRoot,
    "-AutoFix"
)
if ($SkipVerify) { $args += "-SkipVerify" }

& powershell.exe @args
if ($LASTEXITCODE -ne 0) {
    Write-Error "ao-resume: preflight check failed (exit $LASTEXITCODE)."
    exit $LASTEXITCODE
}

Write-Host "AO-RESUME preflight completed: repo is synced and ready." -ForegroundColor Green
exit 0
