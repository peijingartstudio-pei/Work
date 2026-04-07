param(
    [string]$WorkRoot = ""
)

# Reads agency-os/.agency-state/pending-task-completions.txt (optional).
# Each non-empty, non-# line is a unique substring that must appear in exactly one
# unchecked TASKS line (- [ ]). That line gets - [x]. File is removed after success.
# All-or-nothing: any ambiguity or missing match aborts without modifying TASKS.md.

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

if ($WorkRoot) {
    $WorkRoot = (Resolve-Path $WorkRoot).Path
} elseif ($PSScriptRoot) {
    $WorkRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
} else {
    $WorkRoot = (Get-Location).Path
}

$stateDir = Join-Path $WorkRoot "agency-os\.agency-state"
$pendingPath = Join-Path $stateDir "pending-task-completions.txt"
$tasksPath = Join-Path $WorkRoot "agency-os\TASKS.md"

if (-not (Test-Path -LiteralPath $pendingPath)) {
    exit 0
}

$utf8 = [System.Text.UTF8Encoding]::new($false)
$rawNeedles = @([System.IO.File]::ReadAllLines($pendingPath, $utf8))
$needles = New-Object System.Collections.Generic.List[string]
foreach ($line in $rawNeedles) {
    if ($null -eq $line) { continue }
    $t = $line.Trim()
    if (-not $t -or $t.StartsWith("#")) { continue }
    $needles.Add($t)
}

if ($needles.Count -eq 0) {
    exit 0
}

if (-not (Test-Path -LiteralPath $tasksPath)) {
    Write-Error "apply-pending-task-checkmarks: TASKS.md missing at $tasksPath"
    exit 1
}

$lines = [System.Collections.Generic.List[string]]::new()
foreach ($l in [System.IO.File]::ReadAllLines($tasksPath, $utf8)) {
    $lines.Add($l)
}

$rxUnchecked = [regex]'^\s*-\s+\[\s+\]\s+'
$planned = @()

foreach ($needle in $needles) {
    $hits = New-Object System.Collections.Generic.List[int]
    for ($i = 0; $i -lt $lines.Count; $i++) {
        if ($rxUnchecked.IsMatch($lines[$i]) -and ($lines[$i].IndexOf($needle, [System.StringComparison]::Ordinal) -ge 0)) {
            $hits.Add($i)
        }
    }
    if ($hits.Count -eq 0) {
        Write-Error ("apply-pending-task-checkmarks: no unique open task contains substring: {0}" -f $needle)
        exit 1
    }
    if ($hits.Count -gt 1) {
        $preview = ($hits | ForEach-Object { "    line {0}: {1}" -f ($_ + 1), $lines[$_] }) -join [Environment]::NewLine
        Write-Error ("apply-pending-task-checkmarks: substring matches multiple open tasks ({0}):`n{1}`nNeedle: {2}" -f $hits.Count, $preview, $needle)
        exit 1
    }
    $planned += [pscustomobject]@{ Index = $hits[0]; Needle = $needle }
}

# Same line must not be targeted twice
$idxDup = $planned | Group-Object Index | Where-Object { $_.Count -gt 1 }
if ($idxDup) {
    Write-Error "apply-pending-task-checkmarks: duplicate line index in planned updates (check pending file for overlapping needles)."
    exit 1
}

foreach ($p in $planned) {
    $ln = $lines[$p.Index]
    $newLine = [regex]::Replace($ln, '(?m)^(\s*-\s+)\[\s+\](\s+)', '${1}[x]$2', 1)
    if ($newLine -eq $ln) {
        Write-Error ("apply-pending-task-checkmarks: failed to flip checkbox at line {0}" -f ($p.Index + 1))
        exit 1
    }
    $lines[$p.Index] = $newLine
    $snippet = if ($p.Needle.Length -le 72) { $p.Needle } else { $p.Needle.Substring(0, 72) + "..." }
    Write-Host ("apply-pending-task-checkmarks: checked: {0}" -f $snippet) -ForegroundColor Green
}

$utf8NoBom = New-Object System.Text.UTF8Encoding $false
$body = ($lines -join [Environment]::NewLine) + [Environment]::NewLine
[System.IO.File]::WriteAllText($tasksPath, $body, $utf8NoBom)

Remove-Item -LiteralPath $pendingPath -Force
Write-Host "apply-pending-task-checkmarks: applied $($planned.Count) update(s); removed pending file." -ForegroundColor DarkGray
exit 0
