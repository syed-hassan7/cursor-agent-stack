<p align="center">
  <img src="docs/assets/logo.png" alt="Cursor Agent Stack" width="96" height="96" style="border-radius: 50%;" />
</p>

<h1 align="center">Cursor Agent Stack</h1>

<p align="center">
  <strong>Session memory, context budget, and optional design modules for Cursor IDE + CLI.</strong><br/>
  Mechanical hooks + slim rules — survive <code>/summarize</code> without amnesia.
</p>

<p align="center">
  <a href="LICENSE"><img src="https://img.shields.io/badge/license-MIT-blue.svg" alt="MIT License" /></a>
  <a href="https://cursor.com"><img src="https://img.shields.io/badge/Cursor-Agent%20Hooks-000000?style=flat&logo=cursor&logoColor=white" alt="Cursor" /></a>
  <a href="https://nodejs.org"><img src="https://img.shields.io/badge/node-%3E%3D18-green.svg" alt="Node 18+" /></a>
  <a href="https://github.com/syed-hassan7/cursor-agent-stack/releases/tag/v0.7.0"><img src="https://img.shields.io/badge/release-v0.7.0-blue.svg" alt="v0.7.0" /></a>
</p>

<p align="center">
  <a href="https://github.com/syed-hassan7">@syed-hassan7</a>
</p>

![Cursor Agent Stack banner — session memory that survives /summarize](docs/assets/banner-cursor-agent-stack.png)

---

## Stack at a glance

| Layer | Install | What you get |
|-------|---------|--------------|
| **Global** | `install.ps1` | Session memory hooks, secret-guard, rules, caveman + RTK + design-lane + site-remake skills, RTK Cursor hook (Unix), CLI HUD |
| **2D frontend** | `project-template/install-frontend.ps1` | Impeccable, ui-ux-pro-max, design-refs + **library.md** |
| **3D / WebGL** | `project-template/install-3d.ps1` | r3f-three skill, react-three-fiber CSV, ProofScene gate, library.md |
| **Hybrid** | Both installers | [HYBRID.md](docs/HYBRID.md) — lane routing for UI + R3F |
| **Site remake** | `site-remake` skill (global) | [SITE-REMAKE.md](docs/SITE-REMAKE.md) — Phase 1 scrape/inventory from a live URL |
| **Design library** | `design-lane` skill (global) | [DESIGN-RESOURCES.md](docs/DESIGN-RESOURCES.md) — adopt/reject + sequence. New machine: [NEW-DEVICE.md](docs/NEW-DEVICE.md) |

Global stays lean (session hooks + slim rules). Heavy MCP belongs in **project** `.cursor/mcp.json` — see [MCP.md](docs/MCP.md). Project UI/3D modules opt in per repo.

---

## Why this exists

Cursor's `/summarize` compresses the chat — but the agent still **forgets** files, goals, and failed attempts.

| Pain | Fix |
|------|-----|
| Context **50%+** → quality drops | Context budget rules + CLI HUD `↻ compact` |
| Noisy shell fills context (git, tsc, tests) | RTK skill + `rtk` prefix; Unix hook via `install.sh` |
| `/summarize` amnesia | `preCompact` archives + re-injects checkpoint |
| "What broke yesterday?" | Agent reads `.cursor/session/archive/` |
| 2D UI slop | Impeccable + design-refs + sequence (named extreme before lookup) |
| 3D black canvas / wrong lane | r3f-three proof gate + stack CSV (per repo) |
| Hours re-researching design tools | [DESIGN-RESOURCES.md](docs/DESIGN-RESOURCES.md) + [NEW-DEVICE.md](docs/NEW-DEVICE.md) |

![Four-step session memory workflow](docs/assets/workflow-session-memory.png)

---

## Quick install

**Requirements:** [Cursor](https://cursor.com) hooks · **Node 18+** · Python 3.10+ (ui-ux lookup) · `enableThirdPartyConfigs: true` · **RTK** optional ([rtk-ai/rtk](https://github.com/rtk-ai/rtk)) — skill ships with stack; hook auto-install on macOS/Linux via `install.sh`

### Global

```powershell
git clone https://github.com/syed-hassan7/cursor-agent-stack.git
cd cursor-agent-stack
.\install.ps1
.\scripts\verify.ps1
```

```bash
chmod +x install.sh scripts/verify.sh && ./install.sh && ./scripts/verify.sh
```

Reload Cursor after enabling third-party agent configs.

### Per repo (from YOUR app root)

```powershell
& "C:\path\to\cursor-agent-stack\project-template\install-frontend.ps1"  # 2D
& "C:\path\to\cursor-agent-stack\project-template\install-3d.ps1"        # 3D
```

Docs index: [docs/README.md](docs/README.md)

---

## Modules

**2D** — [FRONTEND.md](docs/FRONTEND.md): Impeccable first, named extreme, then ui-ux-pro-max. Pilot: Next.js dashboard.

**3D** — [3D.md](docs/3D.md): r3f-three, ProofScene gate, react-three-fiber CSV. blender-mcp is an escalation.

**Hybrid** — [HYBRID.md](docs/HYBRID.md): both installers + lane routing.

**Site remake** — [SITE-REMAKE.md](docs/SITE-REMAKE.md): Firecrawl + official shadcn MCP; Phase 1 inventory before scaffold.

**Design library** — [DESIGN-RESOURCES.md](docs/DESIGN-RESOURCES.md): what to install, what to refuse. Pickup: [NEW-DEVICE.md](docs/NEW-DEVICE.md).

---

## Verify

```powershell
.\scripts\verify.ps1
```

CI: `.github/workflows/verify.yml` on push/PR.

---

## Releases

[CHANGELOG.md](CHANGELOG.md) · current **v0.7.0**

| Version | Highlights |
|---------|------------|
| **v0.7.0** | Design resource library, new-device playbook, `design-lane` skill, blender-mcp stub as escalation |
| **v0.6.0** | Live-site remake playbook, `site-remake` skill, pinned Firecrawl/shadcn MCP stubs |
| **v0.5.0** | Project-scoped MCP, ambient context cut, sessionStart de-dupe |
| **v0.4.0** | Full-stack docs, VERSION file, README consolidation |
| **v0.3.1** | Bundle split, hybrid routing, verify CI |
| **v0.3.0** | 3D / R3F module |
| **v0.2.0** | Frontend / Impeccable module |
| **v0.1.0** | Session memory core |

---

## Not included

Machina harness, global Impeccable/r3f-three, vendored Impeccable (use `npx impeccable install`).

Details: [ARCHITECTURE.md](docs/ARCHITECTURE.md)

---

## Author

<p align="center">
  <a href="https://github.com/syed-hassan7"><strong>@syed-hassan7</strong></a>
</p>

## License

MIT — [LICENSE](LICENSE)

---

## Global components

| Component | Role |
|-----------|------|
| Hooks | Checkpoint, compact, rehydrate, secret-guard |
| Rules | Session memory, context budget, engineering defaults |
| Pointers | `frontend-design-pointer`, `3d-interactive-pointer`, `site-remake-pointer`, `design-lane-pointer` |
| Skills | caveman, RTK (+ Cursor hook on Unix), site-remake, design-lane |
| CLI HUD | `statusline.js` — context bar, compact warning |

### RTK (token-efficient shell)

| Layer | What | Where |
|-------|------|--------|
| **Skill** | Agent prefixes noisy CLI with `rtk` | `~/.cursor/skills/rtk/` |
| **CLI** | Compresses git/tsc/vitest/docker output | `winget install rtk-ai.rtk` (Windows) or [releases](https://github.com/rtk-ai/rtk) |
| **Hook** | Auto-compress even when agent forgets prefix | `install.sh` on macOS/Linux: `rtk init -g --agent cursor` |

Windows: RTK CLI + skill work; hook auto-install is Unix-only — use `rtk` prefix or WSL. Track savings: `rtk gain`.

### Checkpoint + archives

- `checkpoint.md` — rolling state (goal, files, git)
- `archive/checkpoint-*.md` — per `/summarize` (max 10, 7 days)

---

## Troubleshooting

| Symptom | Fix |
|---------|-----|
| Context fills fast during builds/tests | Install RTK CLI; agent uses `rtk` prefix (skill). Unix: re-run `install.sh` for hook |
| RTK skill present but full logs in chat | Windows: prefix manually (`rtk git diff`). Unix: `rtk init -g --agent cursor --auto-patch --hook-only` |
| Low RTK savings | `rtk gain` — use on git, tsc, vitest, docker logs |
| Hooks never run | `enableThirdPartyConfigs` + reload |
| No archive after summarize | `hook-audit.log` → `preCompact` |
| 3D black canvas | ProofScene first — [3D.md](docs/3D.md) |
| Wrong design lane | [HYBRID.md](docs/HYBRID.md) + [DESIGN-RESOURCES.md](docs/DESIGN-RESOURCES.md) — named extreme before lookup |
| MCP fills context / huge tool list | Keep servers out of global `~/.cursor/mcp.json` — use project `.cursor/mcp.json` — [MCP.md](docs/MCP.md) |
| Rebuilding a live marketing site | Phase 1 scrape first — [SITE-REMAKE.md](docs/SITE-REMAKE.md); skill `site-remake`. Do not scaffold yet |
| New machine, no design brain | Clone this repo → `install.ps1` → [NEW-DEVICE.md](docs/NEW-DEVICE.md). Do not re-audit Relume/Spline/Studio |
| Double checkpoint after compact | v0.5+: single `session-rehydrate` only — re-run `install.ps1` |
| Secret guard blocked write | Env vars, not literals |

