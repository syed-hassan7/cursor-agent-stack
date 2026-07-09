# Changelog

All notable releases of [cursor-agent-stack](https://github.com/darkyzowo/cursor-agent-stack).

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
