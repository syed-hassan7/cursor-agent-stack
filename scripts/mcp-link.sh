#!/usr/bin/env bash
# mcp-link.sh — copy MCP example config into a project .cursor/mcp.json
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TEMPLATE="$ROOT/project-template/.cursor"
PROJECT="${1:-}"
SERVERS="${2:-}"

if [[ -z "$PROJECT" || -z "$SERVERS" ]]; then
  echo "Usage: $0 /path/to/repo n8n[,iru,firecrawl,shadcn,figma]" >&2
  exit 1
fi

DEST_DIR="$PROJECT/.cursor"
DEST="$DEST_DIR/mcp.json"
mkdir -p "$DEST_DIR"

# Prefer python for JSON merge
python3 - "$TEMPLATE" "$DEST" "$SERVERS" <<'PY'
import json, os, sys, time
template_dir, dest, servers = sys.argv[1], sys.argv[2], sys.argv[3]
wanted = [s.strip().lower() for s in servers.split(",") if s.strip()]
merged = {"mcpServers": {}}
for name in wanted:
    path = os.path.join(template_dir, f"mcp.{name}.json.example")
    if not os.path.isfile(path):
        raise SystemExit(f"Unknown server {name!r} — missing {path}")
    with open(path, encoding="utf-8") as f:
        data = json.load(f)
    merged["mcpServers"].update(data.get("mcpServers") or {})
if os.path.isfile(dest):
    bak = f"{dest}.bak-{time.strftime('%Y%m%d-%H%M%S')}"
    os.replace(dest, bak)
    print(f"Backed up existing mcp.json -> {os.path.basename(bak)}")
with open(dest, "w", encoding="utf-8") as f:
    json.dump(merged, f, indent=2)
    f.write("\n")
print(f"Wrote {dest}")
print("Set env vars from the example (${env:...}), then reload Cursor.")
PY
