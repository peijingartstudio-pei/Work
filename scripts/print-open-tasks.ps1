param(
    [string]$WorkRoot = ""
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# Windows PowerShell 5.x consoles often default to a legacy code page; TASKS.md is UTF-8.
if ($PSVersionTable.PSVersion.Major -lt 7) {
    try {
        chcp 65001 | Out-Null
        [Console]::OutputEncoding = [System.Text.Encoding]::UTF8
        $OutputEncoding = [System.Text.Encoding]::UTF8
    } catch {}
}

if ($WorkRoot) {
    $WorkRoot = (Resolve-Path $WorkRoot).Path
} elseif ($PSScriptRoot) {
    $WorkRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
} else {
    $WorkRoot = (Get-Location).Path
}

$tasksPath = Join-Path $WorkRoot "agency-os\TASKS.md"
if (-not (Test-Path -LiteralPath $tasksPath)) {
    Write-Host "print-open-tasks: TASKS.md not found at $tasksPath" -ForegroundColor Yellow
    exit 0
}

$utf8 = [System.Text.UTF8Encoding]::new($false)
$lines = @([System.IO.File]::ReadAllLines($tasksPath, $utf8))
$section = "(prologue — before first ##)"
$rxOpen = [regex]'^\s*-\s+\[\s+\]\s+'
$rxHeading = [regex]'^##\s+'

Write-Host ""
Write-Host "== Open tasks in agency-os/TASKS.md (all unchecked - [ ]) ==" -ForegroundColor Cyan

$count = 0
foreach ($line in $lines) {
    if ($rxHeading.IsMatch($line)) {
        $section = $line.Trim()
        continue
    }
    if ($rxOpen.IsMatch($line)) {
        $count++
        Write-Host ("  [{0}] {1}" -f $section, $line.Trim())
    }
}

if ($count -eq 0) {
    Write-Host "  (none)" -ForegroundColor Green
} else {
    Write-Host ""
    Write-Host ("Total open: {0}" -f $count) -ForegroundColor DarkGray
}

exit 0
