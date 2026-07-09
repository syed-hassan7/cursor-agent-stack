#!/usr/bin/env pwsh
# mcp-link.ps1 — copy MCP example config into a project .cursor/mcp.json
param(
  [Parameter(Mandatory = $true)]
  [string]$Project,
  [Parameter(Mandatory = $true)]
  [string]$Servers
)

$ErrorActionPreference = 'Stop'
$RepoRoot = Split-Path $PSScriptRoot -Parent
$TemplateDir = Join-Path $RepoRoot 'project-template\.cursor'
$DestDir = Join-Path $Project '.cursor'
$Dest = Join-Path $DestDir 'mcp.json'

$wanted = $Servers.Split(',') | ForEach-Object { $_.Trim().ToLower() } | Where-Object { $_ }
if (-not $wanted.Count) { throw 'Specify -Servers e.g. n8n or n8n,iru' }

New-Item -ItemType Directory -Force -Path $DestDir | Out-Null

$merged = @{ mcpServers = @{} }

foreach ($name in $wanted) {
  $example = Join-Path $TemplateDir "mcp.$name.json.example"
  if (-not (Test-Path $example)) {
    throw "Unknown server '$name' — expected file: $example"
  }
  $json = Get-Content -Raw $example | ConvertFrom-Json
  foreach ($prop in $json.mcpServers.PSObject.Properties) {
    $merged.mcpServers[$prop.Name] = $prop.Value
  }
}

if (Test-Path $Dest) {
  $ts = Get-Date -Format 'yyyyMMdd-HHmmss'
  Copy-Item $Dest "$Dest.bak-$ts"
  Write-Host "Backed up existing mcp.json -> mcp.json.bak-$ts" -ForegroundColor Yellow
}

$out = [ordered]@{ mcpServers = [ordered]@{} }
foreach ($k in ($merged.mcpServers.Keys | Sort-Object)) {
  $out.mcpServers[$k] = $merged.mcpServers[$k]
}

($out | ConvertTo-Json -Depth 10) | Set-Content -Encoding utf8NoBOM -Path $Dest
Write-Host "Wrote $Dest" -ForegroundColor Green
Write-Host 'Set env vars from the example (${env:...}), then reload Cursor.' -ForegroundColor DarkGray
