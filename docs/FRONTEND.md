See also: [documentation index](README.md) · [DESIGN-RESOURCES.md](DESIGN-RESOURCES.md) (adopt / reject library) · [NEW-DEVICE.md](NEW-DEVICE.md) · [HYBRID.md](HYBRID.md) for UI + WebGL apps · [SITE-REMAKE.md](SITE-REMAKE.md) for live-URL marketing remakes (Phase 1 scrape before this installer).

# Frontend module

Optional **project-local** stack for web apps. Keeps global Cursor lean; rigor when a repo opts in.

## Layer model

| Layer | Location | What | Why |
|-------|----------|------|-----|
| **Global** | `~/.cursor/` | Session memory, secret-guard, caveman, RTK | Every workspace |
| **Global pointer** | `frontend-design-pointer.mdc` | "If Impeccable exists, use it" | Zero bloat when not installed |
| **Project** | `<repo>/.cursor/` | Impeccable skill + hook, ui-ux-pro-max, rule, design-refs | Web app repos only |

Checkpoint hooks stay **global only** (`~/.cursor/hooks.json`). Project `.cursor/hooks.json` is **Impeccable design detector only** — never duplicate checkpoint hooks (double-fire).

## Three tools, one job

```
┌─────────────────────────────────────────────────────────────┐
│  Impeccable          Creative director + bouncer            │
│  • /impeccable init → PRODUCT.md + DESIGN.md                │
│  • 23 commands (critique, typeset, polish, live, …)         │
│  • 44 detector rules + preToolUse hook                      │
├─────────────────────────────────────────────────────────────┤
│  ui-ux-pro-max       Design encyclopedia (on demand)        │
│  • CSV lookup: palettes, stacks, UX guidelines              │
│  • Python search script — not auto-loaded prose             │
├─────────────────────────────────────────────────────────────┤
│  design-refs/        Inspiration index (links only)         │
│  • 3–5 awesome-design-md brands per project                  │
│  • library.md — adopt / reject (do not re-research)         │
│  • Read targeted sections — never vend full YAML dumps      │
└─────────────────────────────────────────────────────────────┘
```

**Impeccable** kills AI slop and owns committed design context.  
**ui-ux-pro-max** answers "what palette fits fintech spa dashboard?" — **after** a named extreme, not instead of it.  
**design-refs** answer "what does stripe do for dense tables?" plus the portable library.

## Install (web app repo)

From your project root:

```powershell
# Windows
& "C:\path\to\cursor-agent-stack\project-template\install-frontend.ps1"
```

```bash
# macOS / Linux
chmod +x /path/to/cursor-agent-stack/project-template/install-frontend.sh
/path/to/cursor-agent-stack/project-template/install-frontend.sh
```

This copies domain skills, `frontend-design-lane` rule, design-refs (including `library.md`), `.impeccable/config.json`, and runs `npx impeccable install`.

## Sequence (do not invert)

Root cause of generic UI: `ui-ux-pro-max` / Superdesign ran **before** Impeccable committed a world. Full table: [DESIGN-RESOURCES.md](DESIGN-RESOURCES.md).

1. `PRODUCT.md` + `DESIGN.md` (`/impeccable init` or `shape` if missing).
2. Named extreme — one direction, written, before the first CSS rule.
3. Then lookup (ui-ux-pro-max, one awesome-design-md brand, Superdesign critique).
4. Official shadcn MCP → **react-bits** → hand-roll.
5. Motion (`motion/react`). **transitions-dev** for overlays / page transitions. **scroll-craft** for a scroll-driven story — copy the skill into `.cursor/skills/scroll-craft/` (Cursor does not load Claude's plugin marketplace). Do not vendor the whole Owl-Listener pack globally.
6. Real 1× screenshot of the whole view. Two rejections of the same element → stop and question the concept.

**Animation default:** Motion (`motion/react`, MIT). Skip Anime.js if Motion is already in (two engines). Kokonut OSS = copy-paste patterns; Brik.space is closed SaaS (human playground, not a build dep). Live-site remake before scaffold: [SITE-REMAKE.md](SITE-REMAKE.md).

**Superdesign** (optional Cursor Marketplace plugin): palette / canvas critique only. Never overwrite repo-root `DESIGN.md`. If the CLI is used, `--context-file DESIGN.md`.

### Skills-only (no Impeccable)

```powershell
& ".../project-template/install-project-skills.ps1"
```

Includes: `security-audit`, `playwright`, `ui-ux-pro-max`.

## After install

1. **Reload Cursor** — third-party configs must be enabled.
2. **`/impeccable init`** — writes `PRODUCT.md`; offers `DESIGN.md`.
   Live-site remake: Phase 1 already wrote `PRODUCT.md`; write **revamp** `DESIGN.md` only in Phase 2 — [SITE-REMAKE.md](SITE-REMAKE.md). Incumbent look stays in `.cursor/session/<site>-current-design.md`.
3. **Customize** `.cursor/design-refs/README.md` — swap brands for your lane. Keep **3–5**. The adopt/reject list is `library.md` — do not replace it with brand links.
4. **Optional** `/impeccable document` — scan existing CSS/components into `DESIGN.md`.

## Live mode (optional)

Impeccable browser iteration needs:

- Running dev server (HMR)
- `.impeccable/live/config.json` — see template `config.next-app-router.json`
- CSP patch for `localhost:8400` — run `node .cursor/skills/impeccable/scripts/detect-csp.mjs`

## What gets committed

| Commit | Don't commit |
|--------|--------------|
| `.cursor/rules/frontend-design-lane.mdc` | `.impeccable/config.local.json` |
| `.cursor/design-refs/` | `.cursor/session/*` (gitignored) |
| `.cursor/skills/` (ui-ux-pro-max, impeccable via install) | `__pycache__/` from Python scripts |
| `PRODUCT.md`, `DESIGN.md` | |
| `.cursor/hooks.json` (Impeccable) | |

Impeccable skill files are installed by `npx impeccable install` — commit them so teammates get the same version, or re-run install in CI/docs.

## Pilot reference

Battle-tested on **content-audit** (Next.js + Tailwind + Radix): Impeccable hook blocked purple-gradient slop on first test; baseline detect surfaced 8 real drift items.

## Not in global (by design)

- Impeccable (~large skill + npm lifecycle)
- ui-ux-pro-max CSV corpus
- PRODUCT.md / DESIGN.md (per-project)
- scroll-craft, Owl-Listener pack, blender-mcp (copy/enable per repo when needed)

Global `frontend-design-pointer.mdc` + `design-lane-pointer.mdc` tell the agent to *use* Impeccable and the library when the task is UI. The library itself is `docs/DESIGN-RESOURCES.md` (stack) / `.cursor/design-refs/library.md` (product repo).

## 3D module (optional, separate)

For **WebGL / R3F** work — not loaded by `install-frontend.ps1`.

| Tool | Role |
|------|------|
| **r3f-three** | Proof scene gate, stack picker, SSR/sizing checklist |
| **ui-ux-pro-max** | `react-three-fiber` stack CSV |
| **design-refs/3d.md** | pmndrs / drei links |
| **design-refs/library.md** | Spline / blender-mcp adopt-reject |
| **scenes/ProofScene.tsx** | Milestone 1 baseline |

```powershell
& "...\project-template\install-3d.ps1"
```

Hybrid apps (dashboard + 3D): run **both** `install-frontend.ps1` and `install-3d.ps1`.

Full docs: [3D.md](3D.md)

Hybrid routing: [HYBRID.md](HYBRID.md)
