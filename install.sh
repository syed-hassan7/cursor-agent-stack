#!/usr/bin/env bash
# install.sh — install Cursor Agent Stack to ~/.cursor/

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")" && pwd)"
CURSOR_HOME="${CURSOR_HOME:-$HOME/.cursor}"

echo "Cursor Agent Stack installer"
echo "Target: $CURSOR_HOME"

mkdir -p "$CURSOR_HOME"/{rules,hooks,skills,session}

if [[ -f "$CURSOR_HOME/hooks.json" ]]; then
  ts="$(date +%Y%m%d-%H%M%S)"
  cp "$CURSOR_HOME/hooks.json" "$CURSOR_HOME/hooks.json.bak-$ts"
  echo "Backed up hooks.json -> hooks.json.bak-$ts"
fi

cp -R "$REPO_ROOT/cursor/rules/"* "$CURSOR_HOME/rules/"
cp -R "$REPO_ROOT/cursor/hooks/"* "$CURSOR_HOME/hooks/"
cp -R "$REPO_ROOT/cursor/skills/"* "$CURSOR_HOME/skills/"
cp "$REPO_ROOT/cursor/hooks.json" "$CURSOR_HOME/hooks.json"
cp "$REPO_ROOT/cursor/statusline.js" "$CURSOR_HOME/statusline.js"
cp "$REPO_ROOT/cursor/session/.gitignore" "$CURSOR_HOME/session/.gitignore"

echo ""
echo "== RTK (token-efficient shell) =="
if command -v rtk >/dev/null 2>&1; then
  rtk --version 2>/dev/null | head -n1 || true
  if rtk init -g --agent cursor --auto-patch --hook-only; then
    echo "RTK Cursor hook installed (compresses shell output into context)"
  else
    echo "RTK hook install failed — skill still works. Run: rtk init -g --agent cursor --auto-patch --hook-only" >&2
  fi
else
  echo "RTK binary not found — skill installed; hook skipped."
  echo "  Install RTK, then re-run install.sh or: rtk init -g --agent cursor --auto-patch --hook-only"
fi

SLASH_HOME="${CURSOR_HOME//\\//}"

echo ""
echo "Installed rules, hooks, skills, statusline.js"
echo ""
echo "Next steps:"
echo "  1. Enable cursor.agent.enableThirdPartyConfigs = true in Cursor Settings"
echo "  2. Reload Cursor"
echo "  3. Optional CLI HUD — add statusLine to $CURSOR_HOME/cli-config.json:"
echo '     "statusLine": { "type": "command", "command": "node '"$SLASH_HOME"'/statusline.js", ... }'
echo "  4. Per repo: copy project-template/.cursor/session/.gitignore"
echo "  5. Per repo: install-frontend.sh (2D) or install-3d.sh (R3F) — docs/FRONTEND.md and docs/3D.md"
echo "  6. After changes: ./scripts/verify.sh"
