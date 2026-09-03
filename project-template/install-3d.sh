#!/usr/bin/env bash
# install-3d.sh — 3D / R3F module for web repos (run from repo root)
set -euo pipefail

TEMPLATE_ROOT="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(pwd)"
CURSOR_DIR="$PROJECT_ROOT/.cursor"

echo "Cursor Agent Stack — 3D module"
echo "Target: $PROJECT_ROOT"

BUNDLE=3d bash "$TEMPLATE_ROOT/install-project-skills.sh"

mkdir -p "$CURSOR_DIR/rules" "$CURSOR_DIR/design-refs"
cp -f "$TEMPLATE_ROOT/.cursor/rules/3d-interactive-lane.mdc" "$CURSOR_DIR/rules/"
cp -f "$TEMPLATE_ROOT/.cursor/design-refs/3d.md" "$CURSOR_DIR/design-refs/"
cp -f "$TEMPLATE_ROOT/.cursor/design-refs/library.md" "$CURSOR_DIR/design-refs/"

mkdir -p "$CURSOR_DIR/session"
cp -f "$TEMPLATE_ROOT/.cursor/session/.gitignore" "$CURSOR_DIR/session/"

mkdir -p "$PROJECT_ROOT/scenes"
if [[ ! -f "$PROJECT_ROOT/scenes/ProofScene.tsx" ]]; then
  cp -f "$TEMPLATE_ROOT/scenes/ProofScene.tsx" "$PROJECT_ROOT/scenes/"
  cp -f "$TEMPLATE_ROOT/scenes/README.md" "$PROJECT_ROOT/scenes/"
  echo "Installed scenes/ProofScene.tsx"
else
  echo "Kept existing scenes/ProofScene.tsx"
fi

echo ""
echo "Next steps:"
echo "  1. Reload Cursor"
echo "  2. npm i three @react-three/fiber @react-three/drei"
echo "  3. Render ProofScene before environment work"
echo "  4. Dashboard + 3D? Also run install-frontend.sh — docs/HYBRID.md"
echo "  5. blender-mcp is an escalation, not a default — docs/MCP.md"
