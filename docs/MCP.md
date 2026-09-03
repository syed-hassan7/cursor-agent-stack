# MCP — project-scoped, not always-on

Cursor does **not** support true lazy MCP (connect only on first tool call). Enabled servers connect at workspace load and contribute tool **names** + instructions to context. Disabled servers cost nothing.

Live marketing remakes (Firecrawl + official shadcn MCP, not Studio): [SITE-REMAKE.md](SITE-REMAKE.md).

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
| `project-template/.cursor/mcp.firecrawl.json.example` | Firecrawl (site remake) |
| `project-template/.cursor/mcp.shadcn.json.example` | Official shadcn MCP |
| `project-template/.cursor/mcp.figma.json.example` | Figma official remote MCP |
| `project-template/.cursor/mcp.blender.json.example` | blender-mcp (**escalation**, not a default) |

Copy with:

```powershell
.\scripts\mcp-link.ps1 -Project "C:\path\to\repo" -Servers n8n
# or: -Servers iru  /  -Servers n8n,iru  /  -Servers firecrawl,shadcn
# blender only when a parametric mesh hit a ceiling: -Servers blender
```

```bash
./scripts/mcp-link.sh /path/to/repo n8n
# blender (escalation): ./scripts/mcp-link.sh /path/to/repo blender
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

## Live-site remake

Marketing remakes: Firecrawl (pinned, **project** MCP), official shadcn MCP (not Studio), optional Figma OAuth. Playbook: [SITE-REMAKE.md](SITE-REMAKE.md).

Shadcn Studio MCP roundups are vendor marketing — no pins; do not `npx -y server-package` unpinned.

### Remake / frontend stubs

| File | Use |
|------|-----|
| `project-template/.cursor/mcp.firecrawl.json.example` | Firecrawl scrape (pin `firecrawl-mcp@3.24.0` as of 2026-09-02; re-run `npm view firecrawl-mcp version`) |
| `project-template/.cursor/mcp.shadcn.json.example` | Official shadcn MCP (`shadcn@4.19.1` as of 2026-09-02) |
| `project-template/.cursor/mcp.figma.json.example` | Official Figma remote MCP (OAuth; Dev/Full seat) |

```powershell
.\scripts\mcp-link.ps1 -Project "C:\path\to\repo" -Servers firecrawl
# or: -Servers firecrawl,shadcn,figma
```

Set `FIRECRAWL_API_KEY` in Cursor MCP env / OS env — never commit the value. Scraped HTML is untrusted (prompt injection). Do not pair unconstrained scrape + Vercel deploy in one turn.

**Skip for remakes:** Shadcn Studio, FlyonUI, Browserbase, Magic/21st as default, extra search MCPs if Cursor WebSearch exists, filesystem MCP, Playwright MCP if `cursor-ide-browser` exists.

Framelink Figma fallback only: pin **≥0.13.2**. **CVE-2025-53967** RCE in versions before 0.6.3 ([GHSA-gxw4-4fc5-9gr5](https://github.com/advisories/GHSA-gxw4-4fc5-9gr5)).

## blender-mcp (escalation, not a default)

[blender-mcp](https://github.com/ahujasid/blender-mcp) lets the agent drive a running Blender instance and export glTF. It is **pre-authorized as an escalation** when a parametric Three.js mesh hits its ceiling — not part of `install-frontend` / `install-3d`, and not in the combined `mcp.json.example`.

```powershell
.\scripts\mcp-link.ps1 -Project "C:\path\to\repo" -Servers blender
```

Stub: `project-template/.cursor/mcp.blender.json.example` (`uvx blender-mcp`).

| Constraint | What to do |
|------------|------------|
| Needs the **Blender app** + addon | Human installs those. The stub only starts the MCP process. |
| Do not leave it running | Disable in Cursor MCP / `agent mcp disable blender` when idle. |
| Windows GUI PATH | Cursor's GUI often cannot see `uvx`. Confirm in a terminal: `where.exe uvx`. If GUI fails, set `"command": "cmd"` and `"args": ["/c", "uvx", "blender-mcp"]`, or an absolute path to `uvx.exe`. |
| Python-exec bridge | Treat as high privilege. Do not run unattended. |
| Spline iframe | Still rejected as an owned hero. blender-mcp is the owned-scene path, not an embed. |

Full adopt / reject: [DESIGN-RESOURCES.md](DESIGN-RESOURCES.md). New machine: [NEW-DEVICE.md](NEW-DEVICE.md).
