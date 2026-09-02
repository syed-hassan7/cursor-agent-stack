# Project template

Copy or run installers from here into **individual repos**. Nothing in this folder is loaded globally.

## Web app (2D frontend module)

```powershell
# From your Next/React/Vue repo root
& "C:\path\to\cursor-agent-stack\project-template\install-frontend.ps1"
```

```bash
chmod +x ./install-frontend.sh && ./install-frontend.sh
```

Then: **`/impeccable init`** → customize **`design-refs/README.md`**.

Full docs: [docs/FRONTEND.md](../docs/FRONTEND.md)

Live-site remake (scrape/inventory **before** this installer): [docs/SITE-REMAKE.md](../docs/SITE-REMAKE.md). Copy `.gitignore` (ignores `.firecrawl/`) into the remake repo on day one.

## 3D / WebGL (R3F module)

```powershell
& "C:\path\to\cursor-agent-stack\project-template\install-3d.ps1"
```

```bash
chmod +x ./install-3d.sh && ./install-3d.sh
```

Then: install `three` + `@react-three/fiber` + `@react-three/drei`, render **ProofScene** first.

Full docs: [docs/3D.md](../docs/3D.md)

Hybrid UI + 3D: run **both** installers.


## Skill bundles (`install-project-skills`)

| Bundle | Skills | Used by |
|--------|--------|---------|
| `2d` | security-audit, playwright, ui-ux-pro-max | install-frontend |
| `3d` | above + r3f-three | install-3d |
| `all` | every skill in template | manual |

```powershell
& ".\install-project-skills.ps1" -Bundle 2d
```

## Domain skills only

```powershell
& ".\install-project-skills.ps1"   # run from this folder, target = current directory
```

| Skill | Use when |
|-------|----------|
| `security-audit` | Auth, APIs, admin, user data |
| `playwright` | E2E browser tests |
| `ui-ux-pro-max` | Palette/stack/UX lookup |
| `r3f-three` | WebGL / R3F scenes (also installed by install-3d) |

## Session folder

Checkpoint **hooks** are global (`~/.cursor/hooks.json`). Session **files** are per-repo.

## Included files

```
project-template/
├── .gitignore                      # .firecrawl/ + .env* (copy into remake repos)
├── install-frontend.ps1 / .sh      # 2D stack (Impeccable)
├── install-3d.ps1 / .sh            # 3D stack (R3F)
├── install-project-skills.ps1 / .sh
├── scenes/ProofScene.tsx
├── .cursor/
│   ├── mcp.*.json.example          # n8n, iru, firecrawl, shadcn, figma
│   ├── rules/frontend-design-lane.mdc
│   ├── rules/3d-interactive-lane.mdc
│   ├── design-refs/README.md, 3d.md
│   └── skills/                     # r3f-three, ui-ux-pro-max, ...
└── .impeccable/                    # frontend module only
```
