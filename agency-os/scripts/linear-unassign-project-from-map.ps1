param(
    [string]$WorkspaceRoot = "",
    [string]$MapPath = "",
    [switch]$DryRun
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
    if (Test-Path (Join-Path $agencyCandidate "scripts\linear-unassign-project-from-map.ps1")) {
        return (Resolve-Path $agencyCandidate).Path
    }
    return $resolved
}

$root = Resolve-AgencyRoot -InputRoot $WorkspaceRoot

$apiKey = $env:LINEAR_API_KEY
if ([string]::IsNullOrWhiteSpace($apiKey)) {
    throw "LINEAR_API_KEY missing in env."
}
$apiKey = ([string]$apiKey) -replace "[\u0000-\u001F\u007F]", ""
$apiKey = $apiKey.Trim()

if ([string]::IsNullOrWhiteSpace($MapPath)) {
    $MapPath = Join-Path $root "reports\linear\linear-schedule-map.json"
}
if (-not (Test-Path -LiteralPath $MapPath)) {
    throw "Map file not found: $MapPath"
}

$map = Get-Content -LiteralPath $MapPath -Raw -Encoding UTF8 | ConvertFrom-Json
if (-not $map.ids) { throw "Map file has no ids." }

$issues = @()
foreach ($p in $map.ids.PSObject.Properties) {
    $v = $p.Value
    if ($v -and $v.issueId) {
        $issues += [pscustomobject]@{
            TaskId     = $p.Name
            IssueId    = [string]$v.issueId
            Identifier = [string]$v.identifier
            Url        = [string]$v.url
        }
    }
}

if ($issues.Count -eq 0) {
    Write-Host "No mapped issues in map file." -ForegroundColor Yellow
    exit 0
}

if ($DryRun) {
    Write-Host ("[dry-run] issues to unassign project: " + $issues.Count) -ForegroundColor Yellow
    $issues | Select-Object -First 20 | ForEach-Object {
        Write-Host ("  " + $_.Identifier + " (" + $_.IssueId + ")")
    }
    exit 0
}

$mutation = @'
mutation($id: String!, $input: IssueUpdateInput!) {
  issueUpdate(id: $id, input: $input) {
    success
    issue { id identifier url }
  }
}
'@

$ok = 0
$fail = 0
foreach ($it in $issues) {
    $payload = @{
        query = $mutation
        variables = @{
            id = $it.IssueId
            input = @{
                projectId = $null
            }
        }
    } | ConvertTo-Json -Depth 10 -Compress

    try {
        $resp = Invoke-RestMethod -Uri "https://api.linear.app/graphql" -Method Post -Headers @{
            Authorization = $apiKey
            "Content-Type" = "application/json"
        } -Body $payload -UseBasicParsing -TimeoutSec 30

        $errs = @()
        if ($resp.PSObject.Properties['errors'] -and $resp.errors) { $errs = @($resp.errors) }
        if ($errs.Count -gt 0) {
            $msg = ($errs | ForEach-Object { $_.message }) -join "; "
            Write-Warning ("unassign failed " + $it.Identifier + ": " + $msg)
            $fail++
            continue
        }
        if ($resp.data -and $resp.data.issueUpdate -and $resp.data.issueUpdate.success) {
            $id = $resp.data.issueUpdate.issue.identifier
            Write-Host ("OK unassigned project -> " + $id) -ForegroundColor Green
            $ok++
        } else {
            Write-Warning ("unassign failed " + $it.Identifier + ": success=false")
            $fail++
        }
    } catch {
        Write-Warning ("unassign failed " + $it.Identifier + ": " + $_.Exception.Message)
        $fail++
    }
}

Write-Host ("linear-unassign-project-from-map: ok=" + $ok + " fail=" + $fail)
if ($fail -gt 0) { exit 1 } else { exit 0 }
