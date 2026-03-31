# Optional: fetch recently updated Linear issues and append audit block to memory/daily/YYYY-MM-DD.md.
# Requires env LINEAR_API_KEY. ASCII-only script (PS 5.1). Never fails the parent AO-CLOSE chain (exit 0 on API errors).

param(
    [string]$WorkspaceRoot = "",
    [int]$SinceHours = 72,
    [int]$First = 100
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
    if (Test-Path (Join-Path $agencyCandidate "scripts\sync-linear-delta-to-daily.ps1")) {
        return (Resolve-Path $agencyCandidate).Path
    }
    return $resolved
}

$root = Resolve-AgencyRoot -InputRoot $WorkspaceRoot
$apiKey = $env:LINEAR_API_KEY
if ([string]::IsNullOrWhiteSpace($apiKey)) {
    Write-Host "sync-linear-delta: LINEAR_API_KEY not set; skip." -ForegroundColor Yellow
    exit 0
}
$apiKey = ([string]$apiKey) -replace "[\u0000-\u001F\u007F]", ""
$apiKey = $apiKey.Trim()

$since = (Get-Date).ToUniversalTime().AddHours(-1 * [Math]::Max(1, $SinceHours))
$sinceIso = $since.ToString("yyyy-MM-ddTHH:mm:ss.fff") + "Z"

# orderBy omitted for broader API compatibility across Linear schema versions.
$query = @'
query($first: Int!) {
  issues(first: $first) {
    nodes {
      identifier
      title
      state { name }
      updatedAt
      url
    }
  }
}
'@.Trim()

$payloadObj = [ordered]@{
    query     = $query
    variables = [ordered]@{
        first = $First
    }
}
$payload = $payloadObj | ConvertTo-Json -Depth 6 -Compress

$uri = "https://api.linear.app/graphql"
$headers = @{
    Authorization  = $apiKey
    "Content-Type" = "application/json"
}

try {
    $resp = Invoke-RestMethod -Uri $uri -Method Post -Headers $headers -Body $payload -UseBasicParsing -TimeoutSec 30
} catch {
    Write-Host ("sync-linear-delta: HTTP error (skip): " + $_.Exception.Message) -ForegroundColor Yellow
    exit 0
}

if ($resp.PSObject.Properties['errors'] -and $resp.errors) {
    $msg = (@($resp.errors) | ForEach-Object { $_.message }) -join "; "
    Write-Host ("sync-linear-delta: GraphQL errors (skip): " + $msg) -ForegroundColor Yellow
    exit 0
}

$nodes = @()
if ($resp.data -and $resp.data.issues -and $resp.data.issues.nodes) {
    $nodes = @($resp.data.issues.nodes)
}

$dailyName = (Get-Date).ToString("yyyy-MM-dd")
$dailyDir = Join-Path $root "memory\daily"
if (-not (Test-Path -LiteralPath $dailyDir)) {
    New-Item -ItemType Directory -Path $dailyDir -Force | Out-Null
}
$dailyPath = Join-Path $dailyDir ($dailyName + ".md")

$utcStamp = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
$sb = [System.Text.StringBuilder]::new()
[void]$sb.AppendLine("")
[void]$sb.AppendLine("### Linear API sync (" + $utcStamp + ")")
[void]$sb.AppendLine("")
[void]$sb.AppendLine("> since UTC (GraphQL): " + $sinceIso + " | window hours: " + $SinceHours + " | script: sync-linear-delta-to-daily.ps1")
[void]$sb.AppendLine("")

if ($nodes.Count -eq 0) {
    [void]$sb.AppendLine("- _no issues returned (empty or no updates in window)_")
    [void]$sb.AppendLine("")
} else {
    foreach ($n in $nodes) {
        $id = $n.identifier
        $ti = $n.title
        $st = $n.state.name
        $u = $n.url
        [void]$sb.AppendLine("- ``" + $id + "`` **" + $st + "** — " + $ti + " — [" + "open" + "](" + $u + ")")
    }
    [void]$sb.AppendLine("")
}

$block = $sb.ToString()

if (Test-Path -LiteralPath $dailyPath) {
    Add-Content -LiteralPath $dailyPath -Value $block -Encoding UTF8
} else {
    $head = "# Daily notes — " + $dailyName + "`n"
    Set-Content -LiteralPath $dailyPath -Value ($head + $block) -Encoding UTF8
}

Write-Host ("sync-linear-delta: appended " + $nodes.Count + " issue(s) to memory/daily/" + $dailyName + ".md") -ForegroundColor Green
exit 0
