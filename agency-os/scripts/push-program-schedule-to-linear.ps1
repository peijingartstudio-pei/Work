# Push docs/overview/PROGRAM_SCHEDULE.json tasks to Linear as issues (create or update).
# Uses LINEAR_API_KEY, LINEAR_TEAM_ID (optional if only one team), optional LINEAR_PROJECT_ID.
# Persists issue id map at reports/linear/linear-schedule-map.json for stable updates.
# ASCII-only. Planning SSOT remains JSON; re-run after editing JSON to refresh Linear.

param(
    [string]$WorkspaceRoot = "",
    [string]$SchedulePath = "",
    [int]$MaxTasks = 0,
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
    if (Test-Path (Join-Path $agencyCandidate "scripts\push-program-schedule-to-linear.ps1")) {
        return (Resolve-Path $agencyCandidate).Path
    }
    return $resolved
}

function Invoke-LinearGraphQL {
    param(
        [string]$Query,
        [hashtable]$Variables,
        [string]$ApiKey
    )
    $payloadObj = [ordered]@{ query = $Query.Trim() }
    if ($Variables -and $Variables.Count -gt 0) {
        $payloadObj.variables = $Variables
    }
    $payload = $payloadObj | ConvertTo-Json -Depth 12 -Compress
    $headers = @{
        Authorization  = $ApiKey
        "Content-Type" = "application/json"
    }
    try {
        return Invoke-RestMethod -Uri "https://api.linear.app/graphql" -Method Post -Headers $headers -Body $payload -UseBasicParsing -TimeoutSec 30
    } catch {
        $detail = $_.Exception.Message
        throw ("Linear HTTP error: " + $detail)
    }
}

function Get-GraphQLErrors {
    param([object]$Response)
    if ($null -eq $Response) { return @() }
    if (-not $Response.PSObject.Properties['errors']) { return @() }
    $errs = $Response.errors
    if ($null -eq $errs) { return @() }
    return @($errs)
}

function Get-LinearTeamContext {
    param([string]$ApiKey)
    $envTeam = $env:LINEAR_TEAM_ID
    if (-not [string]::IsNullOrWhiteSpace($envTeam)) {
        $tid = $envTeam.Trim()
        Write-Host ("push-program-schedule-to-linear: TEAM from LINEAR_TEAM_ID = " + $tid) -ForegroundColor Cyan
        Write-Host ("  (confirm in Linear UI you are viewing this team / project)") -ForegroundColor Cyan
        return @{ Id = $tid; Name = "(env)"; Key = "(env)" }
    }
    $q = 'query { teams(first: 30) { nodes { id name key } pageInfo { hasNextPage } } }'
    $r = Invoke-LinearGraphQL -Query $q -Variables @{} -ApiKey $ApiKey
    $teamErrors = @(Get-GraphQLErrors -Response $r)
    if ($teamErrors.Count -gt 0) {
        throw ("teams query failed: " + (($teamErrors | ForEach-Object { $_.message }) -join "; "))
    }
    $nodes = @($r.data.teams.nodes)
    if ($nodes.Count -eq 0) { throw "Linear: no teams visible for this API key." }
    if ($nodes.Count -gt 1) {
        Write-Warning ("Multiple teams (" + $nodes.Count + "); set LINEAR_TEAM_ID to force one team. Using first: " + $nodes[0].name + ". Options: " + (($nodes | ForEach-Object { $_.key + ":" + $_.id + "(" + $_.name + ")" }) -join " | "))
    }
    $pick = $nodes[0]
    Write-Host ("push-program-schedule-to-linear: TEAM for new issues: """ + $pick.name + """ key=" + $pick.key + " id=" + $pick.id) -ForegroundColor Cyan
    return @{ Id = $pick.id; Name = $pick.name; Key = $pick.key }
}

function Ensure-ReportsLinearDir {
    param([string]$Root)
    $d = Join-Path $Root "reports\linear"
    if (-not (Test-Path -LiteralPath $d)) { New-Item -ItemType Directory -Path $d -Force | Out-Null }
    return $d
}

$root = Resolve-AgencyRoot -InputRoot $WorkspaceRoot

if ($DryRun) {
    Write-Host ""
    Write-Host "DRY-RUN: No HTTP requests to Linear. Nothing will appear in the Linear UI until you run WITHOUT -DryRun and with a real LINEAR_API_KEY." -ForegroundColor Yellow
    Write-Host ""
}

$apiKey = $env:LINEAR_API_KEY
if ([string]::IsNullOrWhiteSpace($apiKey)) {
    if ($DryRun) {
        $apiKey = "dry-run-no-api-key"
    } else {
        Write-Error "push-program-schedule-to-linear: set LINEAR_API_KEY for live push (Settings - API - Personal API key; Windows User env recommended, then open a new terminal)."
        exit 1
    }
}
$apiKey = ([string]$apiKey) -replace "[\u0000-\u001F\u007F]", ""
$apiKey = $apiKey.Trim()

if (-not $DryRun) {
    Write-Host "LIVE: Creating/updating Linear issues; map file: reports\linear\linear-schedule-map.json" -ForegroundColor Cyan
    if ($MaxTasks -gt 0) {
        Write-Host ("LIVE: -MaxTasks " + $MaxTasks + " (smoke test; use 0 or omit for all tasks)") -ForegroundColor Cyan
    }
    Write-Host ""
}

if (-not $SchedulePath) {
    $SchedulePath = Join-Path $root "docs\overview\PROGRAM_SCHEDULE.json"
}
if (-not (Test-Path -LiteralPath $SchedulePath)) {
    Write-Error "push-program-schedule-to-linear: missing $SchedulePath"
    exit 1
}

$null = Ensure-ReportsLinearDir -Root $root
$mapPath = Join-Path $root "reports\linear\linear-schedule-map.json"
$map = @{ version = 1; updated = ""; ids = @{} }
if (Test-Path -LiteralPath $mapPath) {
    try {
        $existing = Get-Content -LiteralPath $mapPath -Raw -Encoding UTF8 | ConvertFrom-Json
        if ($existing.version) { $map.version = [int]$existing.version }
        if ($existing.ids) {
            $idTable = @{}
            foreach ($p in $existing.ids.PSObject.Properties) {
                $v = $p.Value
                $idTable[$p.Name] = @{
                    issueId    = [string]$v.issueId
                    identifier = [string]$v.identifier
                    url        = [string]$v.url
                }
            }
            $map.ids = $idTable
        }
    } catch {
        Write-Warning "push-program-schedule-to-linear: map parse error; starting empty ids"
        $map.ids = @{}
    }
}

$schedule = Get-Content -LiteralPath $SchedulePath -Raw -Encoding UTF8 | ConvertFrom-Json
if ($DryRun) {
    $teamId = "dry-run-team"
} else {
    $teamCtx = Get-LinearTeamContext -ApiKey $apiKey
    $teamId = $teamCtx.Id
}
function Normalize-ProjectIdOrNull {
    param(
        [string]$Raw,
        [string]$Label
    )
    if ([string]::IsNullOrWhiteSpace($Raw)) { return $null }
    $v = $Raw.Trim()
    if ($v -notmatch '^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$') {
        Write-Warning ("push-program-schedule-to-linear: " + $Label + " is not UUID, ignore: " + $v)
        return $null
    }
    return $v
}

$defaultProjectId = Normalize-ProjectIdOrNull -Raw $env:LINEAR_PROJECT_ID -Label "LINEAR_PROJECT_ID"
$projectByStream = @{
    AO = Normalize-ProjectIdOrNull -Raw $env:LINEAR_PROJECT_ID_AO -Label "LINEAR_PROJECT_ID_AO"
    LF = Normalize-ProjectIdOrNull -Raw $env:LINEAR_PROJECT_ID_LF -Label "LINEAR_PROJECT_ID_LF"
    PJ = Normalize-ProjectIdOrNull -Raw $env:LINEAR_PROJECT_ID_PJ -Label "LINEAR_PROJECT_ID_PJ"
}

$createMutation = @'
mutation($input: IssueCreateInput!) {
  issueCreate(input: $input) {
    success
    issue { id identifier url title }
  }
}
'@

$updateMutation = @'
mutation($id: String!, $input: IssueUpdateInput!) {
  issueUpdate(id: $id, input: $input) {
    success
    issue { id identifier url title }
  }
}
'@

$processed = 0
$failed = 0
$taskSlot = 0

foreach ($stream in $schedule.streams) {
    if ($MaxTasks -gt 0 -and $taskSlot -ge $MaxTasks) { break }
    $sk = $stream.key
    $streamProjectId = $null
    if ($projectByStream.ContainsKey($sk) -and $projectByStream[$sk]) {
        $streamProjectId = $projectByStream[$sk]
    } else {
        $streamProjectId = $defaultProjectId
    }
    foreach ($task in $stream.tasks) {
        $tid = $task.id
        if ([string]::IsNullOrWhiteSpace($tid)) { continue }
        if ($MaxTasks -gt 0 -and $taskSlot -ge $MaxTasks) { break }
        $taskSlot++

        # Use subexpression to avoid serializing full object text (e.g. "@{id=...}").
        $tname = "$($task.name)"
        if ($tname.Length -gt 160) { $tname = $tname.Substring(0, 157) + "..." }
        $title = ("[" + $sk + " " + $tid + "] " + $tname).Trim()
        if ($title.Length -gt 240) { $title = $title.Substring(0, 237) + "..." }

        $ds = if ($task.start) { "$($task.start)" } else { "TBD" }
        $de = if ($task.end) { "$($task.end)" } else { "TBD" }
        $dep = if ($task.depends) { "$($task.depends)" } else { "-" }
        $acc = if ($task.acceptance) { "$($task.acceptance)" } else { "-" }
        $desc = @"
<!-- agency-os-schedule v1 id=$tid stream=$sk -->
**Planned start:** $ds
**Planned end:** $de
**Depends:** $dep
**Acceptance:** $acc
**Repo:** docs/overview/PROGRAM_SCHEDULE.json
"@

        $priority = 0
        if ($task.crit -eq $true) { $priority = 1 }

        $input = [ordered]@{
            teamId      = $teamId
            title       = $title
            description = $desc
        }
        if ($streamProjectId) { $input.projectId = $streamProjectId }
        if (($task.end) -and -not [string]::IsNullOrWhiteSpace("$($task.end)")) {
            $input.dueDate = "$($task.end)"
        }
        if ($priority -gt 0) { $input.priority = $priority }

        $existingIssueId = $null
        if ($map.ids -and $map.ids[$tid]) {
            $row = $map.ids[$tid]
            if ($row -is [hashtable]) { $existingIssueId = $row.issueId }
            elseif ($row.psobject.Properties['issueId']) { $existingIssueId = $row.issueId }
        }

        if ($DryRun) {
            Write-Host ("[dry-run] " + $tid + " -> " + $(if ($existingIssueId) { "update " + $existingIssueId } else { "create" }))
            $processed++
            continue
        }

        try {
            if ($existingIssueId) {
                $upd = [ordered]@{
                    title       = $title
                    description = $desc
                }
                if ($streamProjectId) { $upd.projectId = $streamProjectId }
                if (($task.end) -and -not [string]::IsNullOrWhiteSpace("$($task.end)")) {
                    $upd.dueDate = "$($task.end)"
                }
                if ($priority -gt 0) { $upd.priority = $priority }
                $vars = @{ id = $existingIssueId; input = $upd }
                $r2 = Invoke-LinearGraphQL -Query $updateMutation -Variables $vars -ApiKey $apiKey
                $gqlE = @(Get-GraphQLErrors -Response $r2)
                $updOk = $false
                if ($gqlE.Count -eq 0 -and $r2.data -and $r2.data.issueUpdate) { $updOk = [bool]$r2.data.issueUpdate.success }
                if ($gqlE.Count -gt 0) {
                    $msg = ($gqlE | ForEach-Object { $_.message }) -join "; "
                    Write-Warning ("push-program-schedule-to-linear: update " + $tid + " -> " + $msg)
                    try { Write-Host ($r2 | ConvertTo-Json -Depth 8) -ForegroundColor Red } catch {}
                    $failed++
                } elseif (-not $updOk) {
                    $msg = if ($r2.data -and $r2.data.issueUpdate) { "issueUpdate success=false" } else { "issueUpdate missing data (auth or API error?)" }
                    Write-Warning ("push-program-schedule-to-linear: update " + $tid + " -> " + $msg)
                    try { Write-Host ($r2 | ConvertTo-Json -Depth 8) -ForegroundColor Red } catch {}
                    $failed++
                } else {
                    $issue = $r2.data.issueUpdate.issue
                    $map.ids[$tid] = @{ issueId = $issue.id; identifier = $issue.identifier; url = $issue.url }
                    Write-Host ("  OK update -> " + $issue.identifier + " " + $issue.url) -ForegroundColor Green
                    $processed++
                }
            } else {
                $vars = @{ input = $input }
                $r2 = Invoke-LinearGraphQL -Query $createMutation -Variables $vars -ApiKey $apiKey
                $gqlC = @(Get-GraphQLErrors -Response $r2)
                $crOk = $false
                if ($gqlC.Count -eq 0 -and $r2.data -and $r2.data.issueCreate) { $crOk = [bool]$r2.data.issueCreate.success }
                if ($gqlC.Count -gt 0) {
                    $msgH = ($gqlC | ForEach-Object { $_.message }) -join "; "
                    Write-Warning ("push-program-schedule-to-linear: create " + $tid + " -> " + $msgH)
                    try { Write-Host ($r2 | ConvertTo-Json -Depth 8) -ForegroundColor Red } catch {}
                    $failed++
                } elseif (-not $crOk) {
                    $msgH = if ($r2.data -and $r2.data.issueCreate) { "issueCreate success=false" } else { "issueCreate missing data (auth or API error?)" }
                    Write-Warning ("push-program-schedule-to-linear: create " + $tid + " -> " + $msgH)
                    try { Write-Host ($r2 | ConvertTo-Json -Depth 8) -ForegroundColor Red } catch {}
                    $failed++
                } else {
                    $issue = $r2.data.issueCreate.issue
                    $map.ids[$tid] = @{ issueId = $issue.id; identifier = $issue.identifier; url = $issue.url }
                    Write-Host ("  OK create -> " + $issue.identifier + " " + $issue.url) -ForegroundColor Green
                    $processed++
                }
            }
        } catch {
            Write-Warning ("push-program-schedule-to-linear: " + $tid + " exception: " + $_.Exception.Message)
            $failed++
        }
        if (-not $DryRun) { Start-Sleep -Milliseconds 180 }
    }
}

$map.updated = (Get-Date).ToUniversalTime().ToString("o")

if (-not $DryRun) {
    $outIds = [ordered]@{}
    foreach ($k in $map.ids.Keys) { $outIds[$k] = $map.ids[$k] }
    $outObj = [ordered]@{ version = 1; updated = $map.updated; ids = $outIds }
    $outJson = $outObj | ConvertTo-Json -Depth 8
    Set-Content -LiteralPath $mapPath -Value $outJson -Encoding UTF8
}

Write-Host ("push-program-schedule-to-linear: processed=" + $processed + " failed=" + $failed + " map=" + $mapPath) -ForegroundColor $(if ($failed -gt 0) { "Yellow" } else { "Green" })
exit $(if ($failed -gt 0) { 1 } else { 0 })
