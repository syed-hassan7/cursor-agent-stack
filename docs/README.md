# Documentation

| Doc | Purpose |
|-----|---------|
| [ARCHITECTURE.md](ARCHITECTURE.md) | Hooks, rules, context forensics, global vs project-local |
| [MCP.md](MCP.md) | Project-scoped MCP — avoid always-on global servers |
| [DESIGN-RESOURCES.md](DESIGN-RESOURCES.md) | Adopt / reject library — do not re-research on a new device |
| [NEW-DEVICE.md](NEW-DEVICE.md) | 30-minute pickup on another machine / new Cursor session |
| [FRONTEND.md](FRONTEND.md) | 2D web app module (Impeccable + ui-ux-pro-max) |
| [3D.md](3D.md) | WebGL / R3F module (r3f-three + ProofScene gate) |
| [HYBRID.md](HYBRID.md) | Dashboard + 3D hero — lane routing |
| [SITE-REMAKE.md](SITE-REMAKE.md) | Live marketing remake — Phase 1 scrape/inventory (no scaffold) |
| [../CHANGELOG.md](../CHANGELOG.md) | Release history |

## Install scripts

| Script | Scope |
|--------|--------|
| `../install.ps1` / `install.sh` | Global `~/.cursor/` — hooks, rules, skills |
| `../project-template/install-frontend.ps1` | Per-repo 2D (`-Bundle 2d`) |
| `../project-template/install-3d.ps1` | Per-repo 3D (`-Bundle 3d`) |
| `../scripts/mcp-link.ps1` / `mcp-link.sh` | Copy MCP examples into a project |
| `../scripts/verify.ps1` | Repo smoke tests (also runs in CI) |

Live-site remake (Phase 1 scrape, no scaffold): also copy `../project-template/.gitignore` into the remake repo (`.firecrawl/`).
