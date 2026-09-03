#!/usr/bin/env pwsh
# verify.ps1 — smoke tests for cursor-agent-stack (run from repo root)
$ErrorActionPreference = 'Stop'
$Root = Split-Path $PSScriptRoot -Parent
Set-Location $Root
$Fail = 0

function Resolve-Python {
  $candidates = @(
    (Get-Command python -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Source),
    (Get-Command py -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Source)
  ) | Where-Object { $_ -and $_ -notmatch 'WindowsApps' }
  if ($candidates) {
    if ($candidates[0] -match 'py\.exe$') { return @('py', '-3') }
    return @($candidates[0])
  }
  throw 'Python not found (install 3.10+ or use py launcher)'
}

Write-Host "== Hook syntax =="
Get-ChildItem "cursor\hooks\*.js" | ForEach-Object {
  node -c $_.FullName
  if ($LASTEXITCODE -ne 0) { $Fail = 1 }
}

Write-Host "== Single sessionStart =="
$hooksJson = Get-Content -Raw "cursor\hooks.json" | ConvertFrom-Json
$ss = @($hooksJson.hooks.sessionStart)
if ($ss.Count -ne 1) { Write-Error "Expected exactly 1 sessionStart hook, got $($ss.Count)"; $Fail = 1 }
if ($ss[0].command -notmatch 'session-rehydrate') { Write-Error "sessionStart must be session-rehydrate.js"; $Fail = 1 }
if (Test-Path "cursor\hooks\post-compact-rehydrate.js") { Write-Error "post-compact-rehydrate.js should be removed"; $Fail = 1 }
if (Test-Path "cursor\rules\context-budget.mdc") { Write-Error "context-budget.mdc should be merged into session-memory.mdc"; $Fail = 1 }
if (-not (Test-Path "docs\MCP.md")) { Write-Error "Missing docs/MCP.md"; $Fail = 1 }
if (-not (Test-Path "docs\SITE-REMAKE.md")) { Write-Error "Missing docs/SITE-REMAKE.md"; $Fail = 1 }
if (-not (Test-Path "docs\DESIGN-RESOURCES.md")) { Write-Error "Missing docs/DESIGN-RESOURCES.md"; $Fail = 1 }
if (-not (Test-Path "docs\NEW-DEVICE.md")) { Write-Error "Missing docs/NEW-DEVICE.md"; $Fail = 1 }
if (-not (Test-Path "cursor\skills\site-remake\SKILL.md")) { Write-Error "Missing site-remake skill"; $Fail = 1 }
if (-not (Test-Path "cursor\skills\design-lane\SKILL.md")) { Write-Error "Missing design-lane skill"; $Fail = 1 }
if (-not (Test-Path "cursor\rules\site-remake-pointer.mdc")) { Write-Error "Missing site-remake-pointer.mdc"; $Fail = 1 }
if (-not (Test-Path "cursor\rules\design-lane-pointer.mdc")) { Write-Error "Missing design-lane-pointer.mdc"; $Fail = 1 }
if (-not (Test-Path "project-template\.cursor\mcp.n8n.json.example")) { Write-Error "Missing mcp.n8n.json.example"; $Fail = 1 }
if (-not (Test-Path "project-template\.cursor\mcp.firecrawl.json.example")) { Write-Error "Missing mcp.firecrawl.json.example"; $Fail = 1 }
if (-not (Test-Path "project-template\.cursor\mcp.shadcn.json.example")) { Write-Error "Missing mcp.shadcn.json.example"; $Fail = 1 }
if (-not (Test-Path "project-template\.cursor\mcp.figma.json.example")) { Write-Error "Missing mcp.figma.json.example"; $Fail = 1 }
if (-not (Test-Path "project-template\.cursor\mcp.blender.json.example")) { Write-Error "Missing mcp.blender.json.example"; $Fail = 1 }
if (-not (Test-Path "project-template\.cursor\design-refs\library.md")) { Write-Error "Missing design-refs/library.md"; $Fail = 1 }
if (-not (Select-String -Path "project-template\.gitignore" -Pattern '\.firecrawl/' -Quiet)) { Write-Error "project-template/.gitignore must ignore .firecrawl/"; $Fail = 1 }
if (-not (Select-String -Path "docs\README.md" -Pattern 'SITE-REMAKE.md' -Quiet)) { Write-Error "docs/README.md must index SITE-REMAKE.md"; $Fail = 1 }
if (-not (Select-String -Path "docs\README.md" -Pattern 'DESIGN-RESOURCES.md' -Quiet)) { Write-Error "docs/README.md must index DESIGN-RESOURCES.md"; $Fail = 1 }
if (-not (Select-String -Path "docs\README.md" -Pattern 'NEW-DEVICE.md' -Quiet)) { Write-Error "docs/README.md must index NEW-DEVICE.md"; $Fail = 1 }
if (-not (Select-String -Path "project-template\.cursor\rules\frontend-design-lane.mdc" -Pattern 'named extreme' -Quiet)) { Write-Error "frontend-design-lane.mdc must require a named extreme"; $Fail = 1 }
if (-not (Select-String -Path "README.md" -Pattern 'syed-hassan7/cursor-agent-stack' -Quiet)) { Write-Error "README clone URL must be syed-hassan7/cursor-agent-stack"; $Fail = 1 }


Write-Host "== ui-ux-pro-max stack search =="
$Search = Join-Path $Root "project-template\.cursor\skills\ui-ux-pro-max\scripts\search.py"
$Py = Resolve-Python
foreach ($stack in @('react-three-fiber', 'react-tailwind', 'react-native')) {
  & @Py $Search "test" --stack $stack --max-results 1 | Out-Null
  if ($LASTEXITCODE -ne 0) { $Fail = 1 }
}

Write-Host "== Template files =="
@(
  "project-template\.cursor\skills\r3f-three\SKILL.md",
  "project-template\.cursor\rules\3d-interactive-lane.mdc",
  "project-template\scenes\ProofScene.tsx",
  "docs\HYBRID.md"
) | ForEach-Object {
  if (-not (Test-Path $_)) { Write-Error "Missing: $_"; $Fail = 1 }
}

Write-Host "== Install bundle scripts =="
if (-not (Select-String -Path "project-template\install-frontend.ps1" -Pattern "-Bundle 2d" -Quiet)) { $Fail = 1 }
if (-not (Select-String -Path "project-template\install-frontend.sh" -Pattern "BUNDLE=2d" -Quiet)) { $Fail = 1 }
if (-not (Select-String -Path "project-template\install-3d.ps1" -Pattern "-Bundle 3d" -Quiet)) { $Fail = 1 }

Write-Host "== RTK bundle =="
if (-not (Test-Path "cursor\skills\rtk\SKILL.md")) { Write-Error "Missing: cursor\skills\rtk\SKILL.md"; $Fail = 1 }
if (-not (Select-String -Path "install.ps1" -Pattern "RTK \(token-efficient shell\)" -Quiet)) { $Fail = 1 }
if (-not (Select-String -Path "install.sh" -Pattern "rtk init -g --agent cursor" -Quiet)) { $Fail = 1 }

$rtkCmd = Get-Command rtk -ErrorAction SilentlyContinue
if ($rtkCmd) {
  $show = (& rtk init -g --agent cursor --show 2>&1 | Out-String)
  if ($show -match 'Cursor hook:\s*\[ok\]') {
    Write-Host "RTK Cursor hook: configured" -ForegroundColor DarkGray
  } elseif ($IsWindows -or $env:OS -match 'Windows') {
    Write-Host "RTK CLI present; Cursor hook needs macOS/Linux/WSL (Windows: use rtk prefix + skill)" -ForegroundColor DarkGray
  } else {
    Write-Warning "RTK CLI present but Cursor hook not configured. Re-run install.sh"
  }
} else {
  Write-Host "RTK CLI not installed (optional — winget install rtk-ai.rtk)" -ForegroundColor DarkGray
}

if ($Fail -ne 0) { throw "VERIFY FAILED" }
Write-Host "VERIFY OK" -ForegroundColor Green

