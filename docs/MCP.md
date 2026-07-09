# MCP — project-scoped, not always-on

Cursor does **not** support true lazy MCP (connect only on first tool call). Enabled servers connect at workspace load and contribute tool **names** + instructions to context. Disabled servers cost nothing.

## Recommended pattern

1. Keep **`~/.cursor/mcp.json` empty** (or without heavy servers).
2. Add servers only in **`<repo>/.cursor/mcp.json`** where you need them.
3. Optionally disable in **Customize → MCP** / **Tools & MCP** when idle in that repo.
4. CLI: `agent mcp disable <name>` / `agent mcp enable <name>`.

Global + project configs **merge**; same server name → project wins.

## Why global MCP hurts

Heavy connectors (e.g. endpoint management with 80+ tools, workflow platforms with 30+) inflate the Tools/MCP buckets in **every** chat — including home workspace and unrelated repos.

## Secrets

Prefer env interpolation — never commit tokens:

```json
{
  "mcpServers": {
    "example": {
      "url": "https://example.example/mcp",
      "headers": {
        "Authorization": "Bearer ${env:EXAMPLE_MCP_TOKEN}"
      }
    }
  }
}
```

## Templates

| File | Use |
|------|-----|
| `project-template/.cursor/mcp.json.example` | Combined stub |
| `project-template/.cursor/mcp.n8n.json.example` | n8n only |
| `project-template/.cursor/mcp.iru.json.example` | Iru / Kandji only |

Copy with:

```powershell
.\scripts\mcp-link.ps1 -Project "C:\path\to\repo" -Servers n8n
# or: -Servers iru  /  -Servers n8n,iru
```

```bash
./scripts/mcp-link.sh /path/to/repo n8n
```

Then set the env vars named in the example and reload Cursor.

## Agent discipline (context budget)

- Summarize MCP results — do not paste full list/export payloads into the thread.
- Health-checks: licensing + one device + blueprint **names** — not full blueprint `params`.
- Disable unused servers before long coding sessions.

## What Cursor does not support

- `"enabled": false` in `mcp.json` (ignored)
- Built-in MCP profiles / conditional load by workspace type
- Blocking load via `permissions.deny` (blocks **calls** only, not schema/names)

See also: [ARCHITECTURE.md](ARCHITECTURE.md) context forensics section.
