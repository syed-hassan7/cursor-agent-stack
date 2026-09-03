# New device / new Cursor session

Goal: the same design brain as this stack, without rebuilding it from chat history.

This is the pickup path after cloning [cursor-agent-stack](https://github.com/syed-hassan7/cursor-agent-stack) on a machine that has never seen the Zero remake (or any other job that trained the library).

## What travels vs what does not

| Travels (git + installers) | Does **not** travel (re-install per machine) |
|----------------------------|-----------------------------------------------|
| Session-memory hooks + compact archives pattern | Cursor `enableThirdPartyConfigs` |
| `design-lane` + `site-remake` skills | Superdesign Marketplace plugin |
| Adopt / reject library ([DESIGN-RESOURCES.md](DESIGN-RESOURCES.md)) | scroll-craft skill copy into a project |
| Impeccable / r3f-three **installers** | Blender app + blender-mcp addon |
| MCP **stubs** (`mcp-link`) | API keys (`FIRECRAWL_API_KEY`, Figma OAuth) |
| Lane rules (2D / 3D / remake) | `npx impeccable install` output until you run the frontend installer |

Chat transcripts and `.cursor/session/checkpoint.md` stay **in the product repo**, not in this stack. Copy or clone the product repo separately if you need yesterday's files.

## 30-minute path

### 1. Stack (once per machine)

```powershell
git clone https://github.com/syed-hassan7/cursor-agent-stack.git
cd cursor-agent-stack
.\install.ps1
.\scripts\verify.ps1
```

```bash
git clone https://github.com/syed-hassan7/cursor-agent-stack.git
cd cursor-agent-stack
chmod +x install.sh scripts/verify.sh && ./install.sh && ./scripts/verify.sh
```

Then in Cursor Settings: `cursor.agent.enableThirdPartyConfigs = true` → reload the window.

`install.ps1` copies `~/.cursor/skills/design-lane/` and the glob-gated pointer. A new Agent chat will load the library when the task is UI, remake, or 3D.

### 2. Product repo (once per app)

From the **app** root, not from this stack:

```powershell
# Live marketing remake — scrape first, do not scaffold yet
# (skill: site-remake → docs/SITE-REMAKE.md)

& "...\cursor-agent-stack\scripts\mcp-link.ps1" -Project (Get-Location) -Servers firecrawl,shadcn
# optional: ,figma   — only if a Figma file exists
# do not add blender here

& "...\cursor-agent-stack\project-template\install-frontend.ps1"
# + 3D hero?
& "...\cursor-agent-stack\project-template\install-3d.ps1"
```

Set `FIRECRAWL_API_KEY` in OS / Cursor MCP env. Never commit it.

Reload Cursor in that repo. Confirm:

```powershell
Test-Path .cursor\skills\impeccable\SKILL.md
Test-Path .cursor\design-refs\library.md
Test-Path .cursor\mcp.json
```

### 3. First prompt in the new session

Do **not** ask the agent to "research design tools again." Point it at the stack:

> Read `design-lane` and [DESIGN-RESOURCES.md](DESIGN-RESOURCES.md). Follow the sequence. Do not re-open Relume, Spline, or Shadcn Studio. Here is the job: …

If this workspace **is** `cursor-agent-stack`, the skill resolves `docs/DESIGN-RESOURCES.md` locally. If this workspace is the product repo, it resolves `.cursor/design-refs/library.md` (copied by `install-frontend`).

### 4. Optional, only when the job needs them

| Need | Install | Notes |
|------|---------|--------|
| Scroll-driven story page | Copy scroll-craft `SKILL.md` into `.cursor/skills/scroll-craft/` | Run `node scripts/doctor.mjs` in that skill before the contact sheet. |
| Overlay / page transition snippets | `npx skills add Jakubantalik/transitions-dev` → copy into `.cursor/skills/` | Cursor may not see Claude's skills folder. |
| Canvas / palette critique | Superdesign Cursor Marketplace plugin | Critique only. Never overwrite `DESIGN.md`. |
| Parametric mesh hit a ceiling | Blender + [blender-mcp](https://github.com/ahujasid/blender-mcp) via `mcp-link … blender` | Escalation. Disable the server when idle. |
| Live Figma file | `mcp-link … figma` | Remote MCP (`mcp.figma.com`). Not the paid desktop MCP. |

## What the first hour must not be

- Re-auditing Relume, Spline iframe heroes, Rive authoring, lygia, Kenney zips, Shadcn Studio blogs.
- Installing Firecrawl **globally** (`~/.cursor/mcp.json`).
- Running `/impeccable polish` on `scenes/*`.
- Scaffolding Next **before** Phase 1 inventory on a live-URL remake.
- Inventing pricing, testimonials, or PII to fill a marketing page.

Those decisions are already in [DESIGN-RESOURCES.md](DESIGN-RESOURCES.md).
