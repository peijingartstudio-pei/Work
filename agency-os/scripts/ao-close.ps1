# Thin wrapper: canonical AO-CLOSE script is monorepo root scripts\ao-close.ps1.
param(
    [string]$WorkRoot = "",
    [string]$CommitMessage = "",
    [switch]$SkipPush
)
$monorepoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path
$canonical = Join-Path $monorepoRoot "scripts\ao-close.ps1"
if (-not (Test-Path $canonical)) {
    Write-Error "ao-close: missing $canonical"
    exit 1
}
if (-not $WorkRoot) { $WorkRoot = $monorepoRoot }
if ($SkipPush) {
    if ($CommitMessage) {
        & $canonical -WorkRoot $WorkRoot -CommitMessage $CommitMessage -SkipPush
    } else {
        & $canonical -WorkRoot $WorkRoot -SkipPush
    }
} else {
    if ($CommitMessage) {
        & $canonical -WorkRoot $WorkRoot -CommitMessage $CommitMessage
    } else {
        & $canonical -WorkRoot $WorkRoot
    }
}
exit $LASTEXITCODE
