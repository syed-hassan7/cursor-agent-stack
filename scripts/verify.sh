#!/usr/bin/env bash
# verify.sh — smoke tests for cursor-agent-stack (run from repo root)
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"
FAIL=0

echo "== Hook syntax =="
for f in cursor/hooks/*.js; do
  node -c "$f" || FAIL=1
done

echo "== ui-ux-pro-max stack search =="
PY=python3
command -v python3 >/dev/null 2>&1 || PY=python
SEARCH="$ROOT/project-template/.cursor/skills/ui-ux-pro-max/scripts/search.py"
$PY "$SEARCH" "canvas" --stack react-three-fiber --max-results 1 >/dev/null || FAIL=1
$PY "$SEARCH" "tailwind" --stack react-tailwind --max-results 1 >/dev/null || FAIL=1
$PY "$SEARCH" "list" --stack react-native --max-results 1 >/dev/null || FAIL=1

echo "== Template files =="
test -f project-template/.cursor/skills/r3f-three/SKILL.md || FAIL=1
test -f project-template/.cursor/rules/3d-interactive-lane.mdc || FAIL=1
test -f project-template/scenes/ProofScene.tsx || FAIL=1
test -f docs/HYBRID.md || FAIL=1

echo "== Install bundle scripts =="
grep -q "\-Bundle 2d" project-template/install-frontend.ps1 || FAIL=1
grep -q 'BUNDLE=2d' project-template/install-frontend.sh || FAIL=1

echo "== RTK bundle =="
test -f cursor/skills/rtk/SKILL.md || FAIL=1
grep -q 'rtk init -g --agent cursor' install.sh || FAIL=1
grep -q 'RTK (token-efficient shell)' install.ps1 || FAIL=1

if [[ "$FAIL" -ne 0 ]]; then
  echo "VERIFY FAILED" >&2
  exit 1
fi
echo "VERIFY OK"
