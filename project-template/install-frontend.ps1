#!/usr/bin/env pwsh
# install-frontend.ps1 — full frontend module for web app repos (run from repo root)
param(
  [string]$TemplateRoot = $PSScriptRoot,
  [switch]$SkipImpeccable
)

$ErrorActionPreference = 'Stop'
$ProjectRoot = Get-Location
$CursorDir = Join-Path $ProjectRoot '.cursor'

Write-Host "Cursor Agent Stack — frontend module" -ForegroundColor Cyan
Write-Host "Target: $ProjectRoot" -ForegroundColor DarkGray

# 1. Domain skills (ui-ux-pro-max, playwright, security-audit)
& (Join-Path $TemplateRoot 'install-project-skills.ps1') -Bundle 2d

# 2. Project rule + design refs
New-Item -ItemType Directory -Force -Path (Join-Path $CursorDir 'rules') | Out-Null
Copy-Item -Force (Join-Path $TemplateRoot '.cursor\rules\frontend-design-lane.mdc') (Join-Path $CursorDir 'rules\frontend-design-lane.mdc')

robocopy (Join-Path $TemplateRoot '.cursor\design-refs') (Join-Path $CursorDir 'design-refs') /E /NFL /NDL /NJH /NJS /nc /ns /np | Out-Null
Write-Host "Installed frontend-design-lane rule + design-refs" -ForegroundColor Green

# 3. Session gitignore (checkpoint hooks are global)
$sessionDir = Join-Path $CursorDir 'session'
New-Item -ItemType Directory -Force -Path $sessionDir | Out-Null
Copy-Item -Force (Join-Path $TemplateRoot '.cursor\session\.gitignore') (Join-Path $sessionDir '.gitignore')

# 4. Impeccable config (do not overwrite existing)
$impeccableDir = Join-Path $ProjectRoot '.impeccable'
New-Item -ItemType Directory -Force -Path $impeccableDir | Out-Null
$configPath = Join-Path $impeccableDir 'config.json'
if (-not (Test-Path $configPath)) {
  Copy-Item -Force (Join-Path $TemplateRoot '.impeccable\config.json') $configPath
  Write-Host "Installed .impeccable/config.json" -ForegroundColor Green
} else {
  Write-Host "Kept existing .impeccable/config.json" -ForegroundColor Yellow
}

# 5. Impeccable skill + project hook (npm package — not vendored in this repo)
if (-not $SkipImpeccable) {
  Write-Host "Running npx impeccable install ..." -ForegroundColor Cyan
  npx --yes impeccable install --providers=cursor --scope=project --yes
  if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
} else {
  Write-Host "Skipped npx impeccable install (-SkipImpeccable)" -ForegroundColor Yellow
  $hooksTemplate = Join-Path $TemplateRoot '.cursor\hooks.impeccable.json'
  $hooksPath = Join-Path $CursorDir 'hooks.json'
  if (-not (Test-Path $hooksPath)) {
    Copy-Item -Force $hooksTemplate $hooksPath
    Write-Host "Copied hooks.impeccable.json -> .cursor/hooks.json" -ForegroundColor Yellow
  }
}

# 6. .gitignore hints
$gitignore = Join-Path $ProjectRoot '.gitignore'
function Add-GitignoreLine([string]$line, [string]$comment) {
  if (Test-Path $gitignore) {
    if (-not (Select-String -Path $gitignore -Pattern [regex]::Escape($line) -Quiet)) {
      Add-Content $gitignore "`n$comment`n$line`n"
      Write-Host "Added $line to .gitignore" -ForegroundColor Green
    }
  }
}
Add-GitignoreLine '.impeccable/config.local.json' '# Impeccable local developer prefs'
Add-GitignoreLine '.firecrawl/' '# Firecrawl scrape/crawl output'

Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "  1. Reload Cursor (enable third-party agent configs if not already)"
Write-Host "  2. Run /impeccable init  — writes PRODUCT.md (+ optional DESIGN.md)"
Write-Host "  3. Customize .cursor/design-refs/README.md for your product lane"
Write-Host "  4. 3D hero too? Also run install-3d.ps1 — see docs/HYBRID.md"
Write-Host "  5. For /impeccable live: copy .impeccable/live/config.* template for your framework"
Write-Host ""
Write-Host "Do NOT add checkpoint hooks to .cursor/hooks.json — they live in ~/.cursor/hooks.json" -ForegroundColor DarkGray
