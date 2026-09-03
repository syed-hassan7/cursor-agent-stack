---
name: r3f-three
description: >-
  React Three Fiber and WebGL implementation for interactive 3D scenes. Use when
  building R3F scenes, Three.js environments, WebGL canvases, GLTF viewers,
  orbit controls, lighting setups, or debugging black canvas / SSR WebGL errors.
  Stack picker before coding. Proof scene gate before any environment work.
---

# R3F / Three.js implementation lane

**Not** a 2D UI skill. Dashboards → Impeccable + `react-tailwind`. WebGL → this skill.

## When to apply

- 3D scene, environment, WebGL hero, GLTF/GLB viewer
- `scenes/`, `*Scene*.tsx`, `@react-three/fiber` imports
- Black canvas, SSR errors, zero-size canvas

## Stack picker

| Need | Use |
|------|-----|
| Interactive scene | R3F + `@react-three/drei` |
| GLB spin only | `@google/model-viewer` or Spline embed |
| CSS parallax | Tailwind transforms — no WebGL |
| Game / heavy physics | Babylon.js (separate — not this skill) |

## Dependencies (pin together)

```bash
npm i three @react-three/fiber @react-three/drei
```

Keep `three`, `@react-three/fiber`, `@react-three/drei` on **compatible majors** (check pmndrs release notes). Mismatch → runtime errors.

## Proof scene gate (mandatory)

Never start with terrain, HDRI city, or particles.

1. Sized wrapper (`h-[480px]` or `h-screen`)
2. `Canvas` + camera `[3,3,3]` fov 50
3. `ambientLight` + `directionalLight`
4. Colored mesh
5. `OrbitControls`

Copy `scenes/ProofScene.tsx` if present. **Orbit must work** before stage/content/polish.

## Next.js (App Router)

```tsx
'use client';
import dynamic from 'next/dynamic';

const ProofScene = dynamic(() => import('@/scenes/ProofScene'), { ssr: false });

export function Hero3D() {
  return (
    <div className="h-[480px] w-full">
      <ProofScene />
    </div>
  );
}
```

## Vite + React

- Put scene in `src/scenes/ProofScene.tsx`
- Import directly — no SSR issue unless using SSR framework
- Still require **non-zero height** on wrapper

## Black screen checklist

| Symptom | Fix |
|---------|-----|
| Black, no errors | Add lights; check wrapper height |
| `window is not defined` | `dynamic(..., { ssr: false })` |
| Tiny canvas | Parent `height: 0` — set explicit height |
| Model invisible | Scale 0.001/1000; camera inside mesh |

## Performance defaults

```tsx
<Canvas dpr={[1, 2]} gl={{ antialias: true, powerPreference: 'high-performance' }}>
```

- Defer shadows until 60fps baseline
- Draco for large GLB
- `prefers-reduced-motion`: disable auto-spin

## Verify (before done)

1. DevTools: zero WebGL/R3F errors
2. Canvas has layout size > 0
3. Orbit/zoom works
4. Optional: Playwright skill — screenshot page, assert canvas visible

## Lookup

```bash
python .cursor/skills/ui-ux-pro-max/scripts/search.py "canvas ssr" --stack react-three-fiber
python .cursor/skills/ui-ux-pro-max/scripts/search.py "gltf draco" --stack react-three-fiber
```

Inspiration: `.cursor/design-refs/3d.md`

## Hybrid repos

Impeccable for 2D UI only. See [HYBRID.md](https://github.com/syed-hassan7/cursor-agent-stack/blob/master/docs/HYBRID.md). blender-mcp is an escalation — library: `.cursor/design-refs/library.md`.

## Milestones

1. Proof → 2. Stage (grid, Environment) → 3. GLTF → 4. Polish (after perf OK)
