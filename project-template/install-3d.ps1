#!/usr/bin/env pwsh
# install-3d.ps1 — 3D / R3F module for web repos (run from repo root)
param(
  [string]$TemplateRoot = $PSScriptRoot
)

$ErrorActionPreference = 'Stop'
$ProjectRoot = Get-Location
$CursorDir = Join-Path $ProjectRoot '.cursor'

Write-Host "Cursor Agent Stack — 3D module" -ForegroundColor Cyan
Write-Host "Target: $ProjectRoot" -ForegroundColor DarkGray

& (Join-Path $TemplateRoot 'install-project-skills.ps1') -Bundle 3d

New-Item -ItemType Directory -Force -Path (Join-Path $CursorDir 'rules') | Out-Null
Copy-Item -Force (Join-Path $TemplateRoot '.cursor\rules\3d-interactive-lane.mdc') (Join-Path $CursorDir 'rules\3d-interactive-lane.mdc')
New-Item -ItemType Directory -Force -Path (Join-Path $CursorDir 'design-refs') | Out-Null
Copy-Item -Force (Join-Path $TemplateRoot '.cursor\design-refs\3d.md') (Join-Path $CursorDir 'design-refs\3d.md')
Copy-Item -Force (Join-Path $TemplateRoot '.cursor\design-refs\library.md') (Join-Path $CursorDir 'design-refs\library.md')
Write-Host "Installed 3d-interactive-lane rule + design-refs/3d.md + library.md" -ForegroundColor Green

$sessionDir = Join-Path $CursorDir 'session'
New-Item -ItemType Directory -Force -Path $sessionDir | Out-Null
Copy-Item -Force (Join-Path $TemplateRoot '.cursor\session\.gitignore') (Join-Path $sessionDir '.gitignore')

$scenesDir = Join-Path $ProjectRoot 'scenes'
New-Item -ItemType Directory -Force -Path $scenesDir | Out-Null
$proof = Join-Path $scenesDir 'ProofScene.tsx'
if (-not (Test-Path $proof)) {
  Copy-Item -Force (Join-Path $TemplateRoot 'scenes\ProofScene.tsx') $proof
  Copy-Item -Force (Join-Path $TemplateRoot 'scenes\README.md') (Join-Path $scenesDir 'README.md')
  Write-Host "Installed scenes/ProofScene.tsx" -ForegroundColor Green
} else {
  Write-Host "Kept existing scenes/ProofScene.tsx" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "  1. Reload Cursor (third-party agent configs enabled)"
Write-Host "  2. npm i three @react-three/fiber @react-three/drei"
Write-Host "  3. Render ProofScene before any environment work"
Write-Host "  4. Dashboard + 3D? Also run install-frontend.ps1 — docs/HYBRID.md"
Write-Host "  5. blender-mcp is an escalation, not a default — docs/MCP.md + docs/DESIGN-RESOURCES.md"
Write-Host "  Docs: docs/3D.md in cursor-agent-stack repo"
