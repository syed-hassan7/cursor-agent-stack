#!/usr/bin/env bash
# install-frontend.sh — full frontend module for web app repos (run from repo root)
set -euo pipefail

TEMPLATE_ROOT="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(pwd)"
CURSOR_DIR="$PROJECT_ROOT/.cursor"
SKIP_IMPECCABLE="${SKIP_IMPECCABLE:-0}"

echo "Cursor Agent Stack — frontend module"
echo "Target: $PROJECT_ROOT"

BUNDLE=2d bash "$TEMPLATE_ROOT/install-project-skills.sh"

mkdir -p "$CURSOR_DIR/rules"
cp -f "$TEMPLATE_ROOT/.cursor/rules/frontend-design-lane.mdc" "$CURSOR_DIR/rules/"
mkdir -p "$CURSOR_DIR/design-refs"
cp -R "$TEMPLATE_ROOT/.cursor/design-refs/"* "$CURSOR_DIR/design-refs/"

mkdir -p "$CURSOR_DIR/session"
cp -f "$TEMPLATE_ROOT/.cursor/session/.gitignore" "$CURSOR_DIR/session/"

mkdir -p "$PROJECT_ROOT/.impeccable"
if [[ ! -f "$PROJECT_ROOT/.impeccable/config.json" ]]; then
  cp -f "$TEMPLATE_ROOT/.impeccable/config.json" "$PROJECT_ROOT/.impeccable/"
fi

if [[ "$SKIP_IMPECCABLE" == "1" ]]; then
  echo "Skipped npx impeccable install (SKIP_IMPECCABLE=1)"
  if [[ ! -f "$CURSOR_DIR/hooks.json" ]]; then
    cp -f "$TEMPLATE_ROOT/.cursor/hooks.impeccable.json" "$CURSOR_DIR/hooks.json"
  fi
else
  npx --yes impeccable install --providers=cursor --scope=project --yes
fi

GITIGNORE="$PROJECT_ROOT/.gitignore"
if [[ -f "$GITIGNORE" ]]; then
  if ! grep -q '.impeccable/config.local.json' "$GITIGNORE"; then
    printf '\n# Impeccable local developer prefs\n.impeccable/config.local.json\n' >> "$GITIGNORE"
  fi
  if ! grep -q '\.firecrawl/' "$GITIGNORE"; then
    printf '\n# Firecrawl scrape/crawl output\n.firecrawl/\n' >> "$GITIGNORE"
  fi
fi

echo ""
echo "Next steps:"
echo "  1. Reload Cursor (enable third-party agent configs if not already)"
echo "  2. Run /impeccable init"
echo "  3. Customize .cursor/design-refs/README.md (3-5 brands). Library is design-refs/library.md"
echo "  4. 3D hero too? Also run install-3d.sh — docs/HYBRID.md"
echo "  4b. Sequence: named extreme before ui-ux-pro-max — design-lane / docs/DESIGN-RESOURCES.md"
echo "  5. For /impeccable live: copy .impeccable/live/config.* for your framework"
