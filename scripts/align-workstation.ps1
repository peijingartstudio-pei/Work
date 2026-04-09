<#
.SYNOPSIS
  One-shot workstation alignment: same as ao-resume.ps1 with -AutoVerifyAll always on.

.DESCRIPTION
  Runs, in order: Git fetch / pull when behind (AutoFix), verify-build-gates, workflows npm ci if needed,
  open TASKS list, then machine-environment-audit -FetchOrigin -Strict.
  Exit 0 means the machine says you are ready to work—no manual reading of LAST_SYSTEM_STATUS / TASKS / integrated-status.
  Does NOT auto-create secrets: gh auth, DPAPI vault, and Cursor mcp.json must exist per machine; -Strict fails until they do.

.EXAMPLE
  powershell -ExecutionPolicy Bypass -File .\scripts\align-workstation.ps1
#>
param(
    [string]$WorkRoot = "",
    [switch]$AllowUnexpectedDirty,
    [switch]$AllowStashBeforePull,
    [switch]$AllowPendingStash,
    [switch]$SkipWorkflowsDeps,
    [switch]$SkipOpenTasksList
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$here = $PSScriptRoot
$resume = Join-Path $here "ao-resume.ps1"
if (-not (Test-Path -LiteralPath $resume)) {
    Write-Error "align-workstation: missing $resume"
    exit 1
}

$argv = @(
    "-NoProfile",
    "-ExecutionPolicy", "Bypass",
    "-File", $resume,
    "-AutoVerifyAll"
)
if ($WorkRoot) { $argv += "-WorkRoot", $WorkRoot }
if ($AllowUnexpectedDirty) { $argv += "-AllowUnexpectedDirty" }
if ($AllowStashBeforePull) { $argv += "-AllowStashBeforePull" }
if ($AllowPendingStash) { $argv += "-AllowPendingStash" }
if ($SkipWorkflowsDeps) { $argv += "-SkipWorkflowsDeps" }
if ($SkipOpenTasksList) { $argv += "-SkipOpenTasksList" }

& powershell.exe @argv
exit $LASTEXITCODE
