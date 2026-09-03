# Hybrid apps (2D UI + WebGL)

When a repo has **both** Impeccable (2D) and r3f-three (3D) installed.

Design sequence and adopt / reject list still apply: [DESIGN-RESOURCES.md](DESIGN-RESOURCES.md). File routing below does not change that.

## Install order

```powershell
& "...\install-frontend.ps1"   # 2D lane + Impeccable
& "...\install-3d.ps1"         # 3D lane + ProofScene
```

Either order OK. Both add `ui-ux-pro-max` — second install refreshes same skill.

## Lane routing (agent must follow)

| File pattern | Lane | Tools |
|--------------|------|-------|
| `app/**`, `components/**`, `*.css`, Tailwind | 2D | Impeccable, `frontend-design-lane.mdc`, design-refs/README + `library.md` |
| `scenes/**`, `*Scene*.tsx`, `@react-three/*` imports | 3D | r3f-three skill, `3d-interactive-lane.mdc`, design-refs/3d.md + `library.md` |
| Shared `DESIGN.md` | Both | 2D tokens in main sections; optional **3D** section for camera/light/material |

## Do not

- Run `/impeccable polish` on WebGL scene files expecting CSS fixes
- Apply Impeccable purple-gradient detectors to R3F canvas code
- Start 3D work without ProofScene milestone (see docs/3D.md)
- Enable blender-mcp by default (escalation only — disable when idle)
- Embed Spline as the owned hero scene

## Verify hybrid setup

```powershell
Test-Path .cursor\skills\impeccable\SKILL.md      # 2D
Test-Path .cursor\skills\r3f-three\SKILL.md       # 3D
Test-Path .cursor\rules\frontend-design-lane.mdc
Test-Path .cursor\rules\3d-interactive-lane.mdc
```

## Related

- [FRONTEND.md](FRONTEND.md) — 2D module
- [3D.md](3D.md) — WebGL module
- [DESIGN-RESOURCES.md](DESIGN-RESOURCES.md) — library
- [NEW-DEVICE.md](NEW-DEVICE.md) — another machine
