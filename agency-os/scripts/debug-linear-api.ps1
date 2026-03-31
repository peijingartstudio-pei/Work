param(
    [int]$TimeoutSec = 20
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

if ([string]::IsNullOrWhiteSpace($env:LINEAR_API_KEY)) {
    Write-Error "LINEAR_API_KEY is missing in process env."
    exit 1
}
$apiKey = ([string]$env:LINEAR_API_KEY) -replace "[\u0000-\u001F\u007F]", ""
$apiKey = $apiKey.Trim()

$query = @'
query {
  viewer { id name }
  teams(first: 5) { nodes { id name key } }
}
'@

$payload = @{ query = $query } | ConvertTo-Json -Depth 6 -Compress

try {
    $resp = Invoke-RestMethod -Uri "https://api.linear.app/graphql" -Method Post -Headers @{
        Authorization = $apiKey
        "Content-Type" = "application/json"
    } -Body $payload -TimeoutSec $TimeoutSec

    if ($resp.errors) {
        Write-Host ("graphql_errors=" + (($resp.errors | ForEach-Object { $_.message }) -join "; ")) -ForegroundColor Yellow
        exit 2
    }

    $teams = @()
    if ($resp.data -and $resp.data.teams -and $resp.data.teams.nodes) { $teams = @($resp.data.teams.nodes) }
    $viewerName = ""
    if ($resp.data -and $resp.data.viewer -and $resp.data.viewer.name) { $viewerName = [string]$resp.data.viewer.name }
    Write-Host ("ok viewer=" + $viewerName + " teams=" + $teams.Count) -ForegroundColor Green
    foreach ($t in $teams) {
        Write-Host ("team " + $t.key + " " + $t.name + " " + $t.id)
    }
    exit 0
} catch {
    Write-Error ("http_error=" + $_.Exception.Message)
    exit 3
}
