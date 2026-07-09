#!/usr/bin/env pwsh
# install.ps1 — install Cursor Agent Stack to ~/.cursor/

$ErrorActionPreference = "Stop"
$RepoRoot = $PSScriptRoot
$CursorHome = Join-Path $env:USERPROFILE ".cursor"

Write-Host "Cursor Agent Stack installer" -ForegroundColor Cyan
Write-Host "Target: $CursorHome" -ForegroundColor DarkGray

foreach ($dir in @("rules", "hooks", "skills", "session")) {
  New-Item -ItemType Directory -Force -Path (Join-Path $CursorHome $dir) | Out-Null
}

$ts = Get-Date -Format "yyyyMMdd-HHmmss"
$hooksJson = Join-Path $CursorHome "hooks.json"
if (Test-Path $hooksJson) {
  Copy-Item $hooksJson "$hooksJson.bak-$ts"
  Write-Host "Backed up hooks.json -> hooks.json.bak-$ts" -ForegroundColor Yellow
}

Copy-Item -Recurse -Force (Join-Path $RepoRoot "cursor\rules\*") (Join-Path $CursorHome "rules\")
Copy-Item -Recurse -Force (Join-Path $RepoRoot "cursor\hooks\*") (Join-Path $CursorHome "hooks\")
Copy-Item -Recurse -Force (Join-Path $RepoRoot "cursor\skills\*") (Join-Path $CursorHome "skills\")
Copy-Item -Force (Join-Path $RepoRoot "cursor\hooks.json") $hooksJson
Copy-Item -Force (Join-Path $RepoRoot "cursor\statusline.js") (Join-Path $CursorHome "statusline.js")
Copy-Item -Force (Join-Path $RepoRoot "cursor\session\.gitignore") (Join-Path $CursorHome "session\.gitignore")

Write-Host ""
Write-Host "== RTK (token-efficient shell) ==" -ForegroundColor Cyan
$rtk = Get-Command rtk -ErrorAction SilentlyContinue
if (-not $rtk) {
  Write-Host "RTK binary not found — skill installed; prefix commands manually after install." -ForegroundColor Yellow
  Write-Host "  Windows: winget install rtk-ai.rtk" -ForegroundColor DarkGray
  Write-Host "  macOS/Linux: see https://github.com/rtk-ai/rtk" -ForegroundColor DarkGray
} else {
  $rtkVersion = (& rtk --version 2>&1 | Select-Object -First 1).ToString().Trim()
  Write-Host "RTK $rtkVersion" -ForegroundColor DarkGray
  if ($IsWindows -or $env:OS -match 'Windows') {
    Write-Host "RTK skill + CLI ready. Prefix noisy commands: rtk git diff, rtk tsc, rtk vitest run" -ForegroundColor Green
    Write-Host "Cursor hook auto-install is Unix-only — use WSL/Linux CI, or rely on RTK skill + rtk prefix." -ForegroundColor Yellow
  } else {
    & rtk init -g --agent cursor --auto-patch --hook-only 2>&1 | ForEach-Object { Write-Host $_ }
    if ($LASTEXITCODE -eq 0) {
      Write-Host "RTK Cursor hook installed (compresses shell output into context)" -ForegroundColor Green
    } else {
      Write-Host "RTK hook install failed — skill still works. Run: rtk init -g --agent cursor --auto-patch --hook-only" -ForegroundColor Yellow
    }
  }
}

$cliConfig = Join-Path $CursorHome "cli-config.json"
$statusLineBlock = @"
  "statusLine": {
    "type": "command",
    "command": "node $($CursorHome -replace '\\', '/')/statusline.js",
    "padding": 2,
    "updateIntervalMs": 500,
    "timeoutMs": 1500
  }
"@

Write-Host ""
Write-Host "Installed rules, hooks, skills, statusline.js" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "  1. Enable cursor.agent.enableThirdPartyConfigs = true in Cursor Settings"
Write-Host "  2. Reload Cursor (Developer -> Reload Window)"
Write-Host "  3. Optional CLI HUD — merge into $cliConfig :"
Write-Host $statusLineBlock -ForegroundColor DarkGray
Write-Host ""
Write-Host "  4. Per repo: copy project-template\.cursor\session\.gitignore to .cursor\session\"
Write-Host "  5. After changes: .\scripts\verify.ps1"
Write-Host "  6. Optional RTK CLI: winget install rtk-ai.rtk (Windows) — prefix noisy shell commands"
Write-Host "  7. Web apps: install-frontend.ps1 (2D) or install-3d.ps1 (R3F) — see docs/FRONTEND.md and docs/3D.md"
