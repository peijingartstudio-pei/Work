# Fails (exit 1) if Git checkpoint / AO-CLOSE policy surfaces drift or legacy rhythm returns.
# Invoked from system-health-check.ps1. Owner: scripts/validate-git-workflow-ssot.ps1
param(
    [string]$MonorepoRoot = ""
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

if ($MonorepoRoot) {
    $MonorepoRoot = (Resolve-Path $MonorepoRoot).Path
} elseif ($PSScriptRoot) {
    $MonorepoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
} else {
    $MonorepoRoot = (Get-Location).Path
}

$errors = New-Object System.Collections.Generic.List[string]

function Add-Err { param([string]$Msg) $script:errors.Add($Msg) }

function Test-RequiredSubstrings {
    param(
        [string]$RelativePath,
        [string]$Label,
        [string[]]$Substrings
    )
    $full = Join-Path $MonorepoRoot $RelativePath
    if (-not (Test-Path -LiteralPath $full)) {
        Add-Err "Missing $Label : $RelativePath"
        return
    }
    $raw = Get-Content -LiteralPath $full -Raw -Encoding UTF8
    foreach ($s in $Substrings) {
        if ($raw.IndexOf($s, [StringComparison]::Ordinal) -lt 0) {
            Add-Err "$Label missing required text: $s"
        }
    }
}

function Test-NoLegacyBuZhuDong {
    param(
        [string]$RelativePath,
        [string]$Label
    )
    $full = Join-Path $MonorepoRoot $RelativePath
    if (-not (Test-Path -LiteralPath $full)) { return }
    $raw = Get-Content -LiteralPath $full -Raw -Encoding UTF8
    if ($raw -match "\u4E0D\u4E3B\u52D5") {
        Add-Err "$Label contains legacy rhythm marker (bu-zhu-dong); see REMOTE_WORKSTATION_STARTUP section 2.5 only"
    }
}

# --- Required SSOT markers (ASCII-safe where possible) ---
Test-RequiredSubstrings "agency-os/docs/overview/REMOTE_WORKSTATION_STARTUP.md" "REMOTE (Git SSOT)" @(
    "## 2.5",
    "commit-checkpoint.ps1",
    "AO-CLOSE",
    "validate-git-workflow-ssot.ps1"
)
Test-RequiredSubstrings "agency-os/AGENTS.md" "AGENTS" @(
    "REMOTE_WORKSTATION_STARTUP.md",
    "commit-checkpoint.ps1",
    "50-operator-autopilot.mdc"
)
Test-RequiredSubstrings "agency-os/.cursor/rules/50-operator-autopilot.mdc" "50-operator (agency-os)" @(
    "## 7) Git",
    "REMOTE_WORKSTATION_STARTUP.md",
    "commit-checkpoint.ps1"
)
Test-RequiredSubstrings ".cursor/rules/50-operator-autopilot.mdc" "50-operator (repo root)" @(
    "## 7) Git",
    "REMOTE_WORKSTATION_STARTUP.md",
    "commit-checkpoint.ps1"
)
Test-RequiredSubstrings "scripts/commit-checkpoint.ps1" "commit-checkpoint script" @(
    "Local-only git checkpoint",
    "git commit"
)

# --- 50-operator: both copies must be byte-identical (policy drift prevention) ---
$p50a = Join-Path $MonorepoRoot "agency-os\.cursor\rules\50-operator-autopilot.mdc"
$p50b = Join-Path $MonorepoRoot ".cursor\rules\50-operator-autopilot.mdc"
if (-not (Test-Path -LiteralPath $p50a)) { Add-Err "Missing agency-os/.cursor/rules/50-operator-autopilot.mdc" }
if (-not (Test-Path -LiteralPath $p50b)) { Add-Err "Missing monorepo root .cursor/rules/50-operator-autopilot.mdc" }
if ((Test-Path -LiteralPath $p50a) -and (Test-Path -LiteralPath $p50b)) {
    $ha = (Get-FileHash -LiteralPath $p50a -Algorithm SHA256).Hash
    $hb = (Get-FileHash -LiteralPath $p50b -Algorithm SHA256).Hash
    if ($ha -cne $hb) {
        Add-Err "50-operator-autopilot.mdc SHA256 differs: copy agency-os version to monorepo root .cursor/rules (or vice versa)"
    }
}

# --- ao-resume: single implementation; wrapper under agency-os ---
$ar = Join-Path $MonorepoRoot "scripts\ao-resume.ps1"
if (Test-Path -LiteralPath $ar) {
    $raw = Get-Content -LiteralPath $ar -Raw -Encoding UTF8
    $paramBlocks = [regex]::Matches($raw, '(?m)^\s*param\s*\(')
    if ($paramBlocks.Count -ne 1) {
        Add-Err ("scripts/ao-resume.ps1 must have exactly one param( block (found {0})" -f $paramBlocks.Count)
    }
    if ($raw.IndexOf("Reports since last AO-RESUME", [StringComparison]::Ordinal) -lt 0) {
        Add-Err "scripts/ao-resume.ps1 missing report delta section"
    }
} else {
    Add-Err "Missing scripts/ao-resume.ps1"
}

$arw = Join-Path $MonorepoRoot "agency-os\scripts\ao-resume.ps1"
if (Test-Path -LiteralPath $arw) {
    $w = Get-Content -LiteralPath $arw -Raw -Encoding UTF8
    if ($w.IndexOf("Single-owner design", [StringComparison]::Ordinal) -lt 0) {
        Add-Err "agency-os/scripts/ao-resume.ps1 must be thin wrapper (Single-owner design)"
    }
    if ([regex]::Matches($w, '(?m)^\s*param\s*\(').Count -ne 1) {
        Add-Err "agency-os/scripts/ao-resume.ps1 should have single param( only"
    }
} else {
    Add-Err "Missing agency-os/scripts/ao-resume.ps1"
}

# --- Active surfaces: forbid reintroduced legacy phrase (Unicode regex) ---
$noLegacy = @(
    @("agency-os/AGENTS.md", "AGENTS.md"),
    @("agency-os/docs/overview/EXECUTION_DASHBOARD.md", "EXECUTION_DASHBOARD"),
    @("agency-os/docs/overview/INTEGRATED_STATUS_REPORT.md", "INTEGRATED_STATUS_REPORT"),
    @("agency-os/docs/operations/end-of-day-checklist.md", "end-of-day-checklist"),
    @("README.md", "monorepo README")
)
foreach ($pair in $noLegacy) {
    Test-NoLegacyBuZhuDong -RelativePath $pair[0] -Label $pair[1]
}

if ($errors.Count -gt 0) {
    Write-Host "validate-git-workflow-ssot: FAIL" -ForegroundColor Red
    foreach ($e in $errors) { Write-Host "  - $e" -ForegroundColor Yellow }
    exit 1
}

Write-Host "validate-git-workflow-ssot: OK" -ForegroundColor Green
exit 0
