# Changelog

All notable releases of [cursor-agent-stack](https://github.com/syed-hassan7/cursor-agent-stack).

## [v0.7.0] — 2026-09-03

### Added
- [docs/DESIGN-RESOURCES.md](docs/DESIGN-RESOURCES.md) — portable adopt / reject library (scroll-craft, react-bits, transitions-dev, Motion, blender-mcp escalation, Superdesign critique-only)
- [docs/NEW-DEVICE.md](docs/NEW-DEVICE.md) — 30-minute pickup on another machine / new Cursor session
- Global **`design-lane`** skill + glob-gated `design-lane-pointer.mdc` so a new chat loads the sequence (Impeccable → named extreme → lookup → screenshot) without a prior research thread
- Project copy at `.cursor/design-refs/library.md` (install-frontend and install-3d)
- `mcp.blender.json.example` — blender-mcp as **escalation**, not a default (`mcp-link -Servers blender`)

### Changed
- Frontend / 3D lane rules: do not invert lookup before a named extreme; leva then strip; postprocessing after ~60fps; rapier only when needed
- README clone URL `darkyzowo` → `syed-hassan7`; Relume / Spline-as-hero / Shadcn Studio remain rejected

### Notes
- Do not vendor scroll-craft or the Owl-Listener 241-skill pack into `~/.cursor`. Copy scroll-craft into a **project** skills folder when the page is scroll-driven.
- Superdesign stays a Marketplace plugin — critique / palette only; never overwrite `DESIGN.md`.
- Firecrawl stays **project** `.cursor/mcp.json`. blender-mcp: disable when idle; Windows GUI often needs `cmd /c uvx blender-mcp`.

## [v0.6.0] — 2026-09-02

### Added
- [docs/SITE-REMAKE.md](docs/SITE-REMAKE.md) — Phase 1 live-site remake playbook (map/scrape/inventory; no scaffold)
- Global **`site-remake`** skill + glob-gated `site-remake-pointer.mdc` so new sessions load the playbook without a prior MCP audit thread
- Project MCP stubs: Firecrawl (pinned), official shadcn MCP, Figma OAuth — `mcp-link` `-Servers firecrawl,shadcn,figma`
- `project-template/.gitignore` ignores `.firecrawl/` and `.env*`

### Changed
- [MCP.md](docs/MCP.md) / [FRONTEND.md](docs/FRONTEND.md): pointers + remake MCP/motion defaults (Motion not Anime.js; skip Studio/Browserbase/unpinned npx)
- Official shadcn MCP is the adopt path — Shadcn Studio blogs are vendor marketing, not a spec

### Notes
- Firecrawl for remakes = **project** `.cursor/mcp.json` (Path A+C). Path B (SDK in the marketing product) is out of scope unless the product is a scraper
- Pin verified 2026-09-02: `firecrawl-mcp@3.24.0` (`3.24.1` not published), `shadcn@4.19.1`. Re-run `npm view` before install
- Framelink Figma fallback: pin ≥0.13.2; CVE-2025-53967 RCE in versions before 0.6.3

## [v0.5.0] — 2026-07-09

### Fixed
- **Double sessionStart injection** after `/compact` — removed `post-compact-rehydrate.js`; single `session-rehydrate.js` covers all resumes
- Checkpoint noise: filter `agent-tools/`, `sim_*` / `debug_*` / `repro_*` / `inspect_*` scripts; skip HUD meta lines in recent messages

### Changed
- Merged `context-budget.mdc` into `session-memory.mdc` (one always-on memory/budget rule)
- Slim `buildSessionMemoryBrief()` — paths + archive index only (playbook stays in the rule)
- `MAX_FILES` 40 → 20
- Pointer rules (`frontend-design-pointer`, `3d-interactive-pointer`) → `alwaysApply: false` + globs
- `secret-guard` timeout 5s → 15s (failClosed was blocking large writes on slow Windows)

### Added
- [docs/MCP.md](docs/MCP.md) — project-scoped MCP pattern (no true lazy load in Cursor)
- `project-template/.cursor/mcp*.json.example` — n8n / iru stubs with `${env:...}`
- `scripts/mcp-link.ps1` / `mcp-link.sh` — copy examples into a project
- Verify checks: single sessionStart, no duplicate rehydrate, MCP docs present

### Notes
- Cursor cannot load MCP only on first tool call — disable servers or keep them out of global `~/.cursor/mcp.json`
- After install: migrate heavy MCP out of global config into per-project `.cursor/mcp.json`
## [v0.4.1] — 2026-07-09

### Added
- **RTK Cursor hook** step in `install.sh` (macOS/Linux): `rtk init -g --agent cursor --auto-patch --hook-only`
- **RTK bundle** checks in `scripts/verify.ps1` / `verify.sh`
- README: RTK layer table, context-troubleshooting rows, optional RTK in requirements

### Changed
- `install.ps1`: RTK CLI detection; Windows path documents skill + prefix (hook is Unix-only per RTK)
- `install.sh`: fixed duplicate next-step numbering

### Notes
- RTK **skill** ships globally; **hook** auto-patches `~/.cursor/hooks.json` on Unix only
- Windows users: `winget install rtk-ai.rtk` + agent `rtk` prefix; track with `rtk gain`

## [v0.4.0] — 2026-06-30

### Added
- `VERSION` file and [docs/README.md](docs/README.md) documentation index
- Consolidated root README — full stack overview (global, 2D, 3D, hybrid)

### Changed
- README structure: stack table, verify section, release history
- Architecture and module docs aligned with v0.3.1 installers

### Notes
- 3D module complete through v0.3.x (proof gate, bundles, hybrid routing, CI)
- Per-repo 3D validation is done at install time in your app — not vendored in this repo

## [v0.3.1] — 2026-06-26

### Fixed
- **install bundle split**: `install-frontend` uses `-Bundle 2d` (no orphan `r3f-three` without 3D rule)
- **install-3d** uses `-Bundle 3d` via shared `install-project-skills`
- **global-engineering**: correct pointer refs (`frontend-design-pointer` + `3d-interactive-pointer`)
- **Hybrid routing**: `docs/HYBRID.md`, pointer rules, installer next-steps

### Added
- `scripts/verify.ps1` / `verify.sh` — hook syntax + ui-ux stack smoke tests
- GitHub Actions `verify.yml` on push/PR
- Cross-link `design-refs/README.md` → `3d.md`

### Changed
- Enriched `r3f-three` skill (deps, Next/Vite, Playwright verify)
- ui-ux-pro-max skill description stack count

## [v0.3.0] — 2026-06-26

- 3D / R3F module: r3f-three skill, react-three-fiber CSV, install-3d, ProofScene, docs/3D.md

## [v0.2.0] — 2026-06-25

- Frontend module: Impeccable + ui-ux-pro-max + design-refs

## [v0.1.0] — initial

- Session memory hooks, rules, caveman, RTK, statusline

