param(
    [string]$WorkspaceRoot = "",
    [int]$SinceHours = 72,
    [int]$First = 30,
    [switch]$Smoke
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Resolve-AgencyRoot {
    param([string]$InputRoot)
    $resolved = $null
    if ($InputRoot -and (Test-Path $InputRoot)) {
        $resolved = (Resolve-Path $InputRoot).Path
    } elseif ($PSScriptRoot) {
        $resolved = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
    } else {
        $resolved = (Get-Location).Path
    }
    $agencyCandidate = Join-Path $resolved "agency-os"
    if (Test-Path (Join-Path $agencyCandidate "scripts\push-program-schedule-to-linear.ps1")) {
        return (Resolve-Path $agencyCandidate).Path
    }
    return $resolved
}

$root = Resolve-AgencyRoot -InputRoot $WorkspaceRoot
$pushScript = Join-Path $root "scripts\push-program-schedule-to-linear.ps1"
$deltaScript = Join-Path $root "scripts\sync-linear-delta-to-daily.ps1"

if (-not (Test-Path -LiteralPath $pushScript)) { throw "Missing push script: $pushScript" }
if (-not (Test-Path -LiteralPath $deltaScript)) { throw "Missing delta script: $deltaScript" }

if ([string]::IsNullOrWhiteSpace($env:LINEAR_API_KEY)) {
    throw "LINEAR_API_KEY missing in env. Set it (or run through secrets-vault Action=run)."
}

Write-Host "== linear-sync-all: PROGRAM_SCHEDULE -> Linear ==" -ForegroundColor Cyan
if ($Smoke) {
    & powershell.exe -NoProfile -ExecutionPolicy Bypass -File $pushScript -WorkspaceRoot $root -MaxTasks 1
} else {
    & powershell.exe -NoProfile -ExecutionPolicy Bypass -File $pushScript -WorkspaceRoot $root
}
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

Write-Host "== linear-sync-all: Linear delta -> memory/daily ==" -ForegroundColor Cyan
& powershell.exe -NoProfile -ExecutionPolicy Bypass -File $deltaScript -WorkspaceRoot $root -SinceHours $SinceHours -First $First
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

Write-Host "linear-sync-all: done." -ForegroundColor Green
exit 0
