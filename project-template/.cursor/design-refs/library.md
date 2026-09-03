# Design resource library (project copy)

Synced from cursor-agent-stack `docs/DESIGN-RESOURCES.md`. Edit the stack copy, then re-run `install-frontend` (or copy this file). Prefer the stack file when this repo sits next to it.

# Design resource library

Direction-agnostic adopt / reject list for Cursor. Holds whether the job is a dashboard, a marketing remake, or a hybrid 2D+WebGL site.

**Do not re-research this list from scratch** on a new device. Update a row only with new evidence (license change, a working link, a paid-gate that lifted).

How to read this file (stack docs, not this folder): [NEW-DEVICE.md](https://github.com/syed-hassan7/cursor-agent-stack/blob/master/docs/NEW-DEVICE.md) · [FRONTEND.md](https://github.com/syed-hassan7/cursor-agent-stack/blob/master/docs/FRONTEND.md) · [3D.md](https://github.com/syed-hassan7/cursor-agent-stack/blob/master/docs/3D.md) · [SITE-REMAKE.md](https://github.com/syed-hassan7/cursor-agent-stack/blob/master/docs/SITE-REMAKE.md) · [MCP.md](https://github.com/syed-hassan7/cursor-agent-stack/blob/master/docs/MCP.md).

## Layer map (what goes where)

Global stays lean. Heavy tools stay project-local or human-installed.

| Layer | Lives | Job |
|-------|--------|-----|
| **Law** | Repo `PRODUCT.md` + `DESIGN.md` | Facts vs visual world. Impeccable owns these after `/impeccable init`. |
| **Sequence** | `design-lane` skill + `frontend-design-lane.mdc` | Impeccable first, named extreme, then lookup, then code, then a real screenshot. |
| **Library** | This file (+ copy at `.cursor/design-refs/library.md`) | What to install, what to refuse, what is citation-only. |
| **2D craft** | `install-frontend.ps1` | Impeccable, ui-ux-pro-max, design-refs. |
| **3D craft** | `install-3d.ps1` | r3f-three, ProofScene gate. Never `/impeccable polish` on WebGL. |
| **Remake** | `site-remake` skill | Phase 1 scrape/inventory. No scaffold. |
| **Connectors** | Project `.cursor/mcp.json` | Firecrawl, official shadcn, Figma remote. Blender is an escalation, not a default. |
| **Human / plugin** | Cursor Marketplace or a copied skill | Superdesign (critique only), scroll-craft (scroll pages), Blender app. |

```
PRODUCT.md (facts)  →  DESIGN.md (tokens / world)
        ↓
Impeccable (author)  →  ui-ux-pro-max / Superdesign (lookup, critique)
        ↓
Motion / scroll-craft / react-bits / transitions-dev  (2D motion)
r3f-three + leva + postprocessing              (3D, after ProofScene)
        ↓
Browser screenshot  (hard gate — source review is not visual proof)
```

## Scroll & motion (2D)

| Resource | What it gives | License / access | Status |
|----------|----------------|------------------|--------|
| **scroll-craft** (`nateherkai/scroll-craft`) | Scroll-driven page grammars, one signature move per build, fingerprint gate, feeling curve, refuse-list, headless contact sheet. Run `node scripts/doctor.mjs` first (ffmpeg / webp muxer). Node 18+, full ffmpeg, `playwright-core` + Chrome. | MIT. Core needs no API key. `KIE_AI_API_KEY` only for optional AI assets. | **Adopt** for scroll-driven marketing. Claude Code: `/plugin marketplace add nateherkai/scroll-craft` then `/plugin install nateherk-design`. Cursor: copy the skill into `<repo>/.cursor/skills/scroll-craft/` (Cursor does not load Claude's plugin marketplace). |
| **easings.net** | Named bezier values. | GPL-3.0 — cite numbers in CSS, do not add as an npm dep. | Citation only. |
| **react-bits** (`DavidHDev/react-bits`) | Animated / personality components. Check before hand-assembling Motion. | MIT + Commons Clause (use in a product: yes; resell the library: no). | Adopt. Standalone npm / copy-paste — not the shadcn registry. |
| **transitions-dev** (`Jakubantalik/transitions-dev`) | Interaction snippets (modals, dropdowns, page transitions) with `prefers-reduced-motion`. | MIT. | Adopt. `npx skills add Jakubantalik/transitions-dev`, then copy into `.cursor/skills/` if Cursor cannot see the Claude skills folder. |
| **Motion** (`motion/react`) | Gestures, layout, springs. | MIT. | Default 2D motion primitive. Skip Anime.js if Motion is already in. |

## 3D / WebGL

| Resource | What it gives | License / access | Status |
|----------|----------------|------------------|--------|
| **r3f-three** (this stack) | ProofScene gate, stack picker, SSR / sizing checklist. | MIT (stack). | Default 3D lane. |
| **@react-three/postprocessing** | Bloom / DoF / grade. | MIT. | Adopt after 60fps proof. |
| **@react-three/rapier** | Real physics. | MIT. | Adopt only when idle-yaw / parallax is not enough. |
| **leva** | Live material / light UI, **dev-only**. Tune, hardcode, strip from the bundle. | MIT. | Adopt per-asset. |
| **blender-mcp** (`ahujasid/blender-mcp`) | Agent drives Blender; export glTF. Python-exec bridge inside Blender. | MIT. | **Pre-authorized escalation, not a default.** Use when a parametric Three.js mesh hits its ceiling. Do not leave it running unattended. Needs the Blender app + addon. Stub: `mcp.blender.json.example`. |
| **Poly Haven API** / **ambientCG v2** | HDRI / PBR values. | CC0, no key. | Values reference. Do not import HDRI if the spec forbids environment maps. |
| **Poly Pizza API** | glTF placeholders. | Free key. Filter CC0 unless attribution is handled. | Adopt for placeholder primitives only. |
| **glsl-noise** (`hughsk/glsl-noise`) | Shader noise. | MIT, stale since 2015. | Copy the function; do not add as a live npm dep. CSS/SVG grain is the lighter default. |

## Critique / lookup (do not author the spec)

| Resource | Role | Status |
|----------|------|--------|
| **Impeccable** | Creative director. Writes `PRODUCT.md` / `DESIGN.md`. Detectors + `/impeccable` commands. | Project install. **Authors** the visual world. |
| **ui-ux-pro-max** | CSV lookup (palette, stack, UX). | Project install. **After** named extreme, not instead of it. |
| **Superdesign** (Cursor Marketplace plugin) | Palette / canvas critique. | Optional human plugin. **Never** overwrite repo-root `DESIGN.md`. Pass `--context-file DESIGN.md` if the CLI is used. |
| **Owl-Listener/designer-skills** (`visual-critique`, `interaction-design`) | Structured critique (Claude Code plugins). | Layer-3 verification only. Cursor: copy those two skills into the **project** skills folder — do not vendor the whole 241-skill pack globally. |
| **awesome-design-md** (`VoltAgent/awesome-design-md`) | One real product's tokens, on demand. | Copy **one** company's file. Inspired interpretation, not a reverse-engineered spec. |
| **Figma remote MCP** (`https://mcp.figma.com/mcp`) | Read a real Figma file. | Free on Figma plans. Desktop MCP is the paid one — do not confuse them. Only useful once a file exists. |
| **Official shadcn MCP** | Component install. | Adopt. **Not** Shadcn Studio. |
| **The Component Gallery** (`component.gallery`) | Names + examples across real systems. | Browse-when-stuck. No code output. |

## Live remake connectors

Documented in [SITE-REMAKE.md](https://github.com/syed-hassan7/cursor-agent-stack/blob/master/docs/SITE-REMAKE.md) and [MCP.md](https://github.com/syed-hassan7/cursor-agent-stack/blob/master/docs/MCP.md). Short form:

| Connector | Role | Status |
|-----------|------|--------|
| **Firecrawl** | Map / scrape / crawl. Project MCP, pinned. | Adopt for Phase 1. Never Path B (SDK inside the marketing product) unless the product is a scraper. |
| **cursor-ide-browser** | Motion, cookies, CTA walk, screenshots. | Prefer over a second Playwright MCP. |
| **Kokonut OSS** | Copy-paste patterns. | Fine. Brik.space is a human playground, not a build dep. |

## Rejected — do not re-propose without new evidence

| Resource | Reason |
|----------|--------|
| **Relume MCP** | Paid-gated. Dropped mid-remake; do not reconnect. |
| **Spline** as hero | Iframe is not an owned scene. Comparable polish = Blender + R3F materials, not an embed. |
| **Rive** authoring | Runtime is MIT; the editor is human-only and the free tier cannot export `.riv`. Agent CLIs are immature. Watch, do not adopt. |
| **lygia** | Prosperity License — non-commercial. |
| **Kenney.nl / Quaternius (direct)** | Zip / Drive only — no API/CLI. |
| **Webflow MCP** | Writes Webflow CMS, not a Next/R3F repo. |
| **Shadcn Studio, FlyonUI, Browserbase, extra search MCPs** | Paid, vendor-fork, archived, or redundant with Cursor WebSearch. |
| **interior.dev, anti-ui-slop, design-tokens-mcp** | No canonical fetchable source found. Need a working link. |
| **Anime.js** when Motion is already installed | Two animation engines. Pick Motion. |

## Battle-tested sequence (do not invert)

Root cause of generic UI: lookup tools (`ui-ux-pro-max`, Superdesign) ran **before** Impeccable committed a world.

1. **Context** — `PRODUCT.md` + `DESIGN.md`. `/impeccable init` or `shape` if missing. Real reference images beat vibe adjectives.
2. **Named extreme** — one direction, written down, before the first CSS rule. Not a blend. Not Inter / Roboto / Space Grotesk unless the brief demands restraint.
3. **Lookup** — ui-ux-pro-max / one awesome-design-md brand / Superdesign, **against** that extreme.
4. **Components** — official shadcn, then react-bits for personality, then hand-roll.
5. **Motion** — Motion primitives; transitions-dev for overlay/page patterns; scroll-craft for a scroll-driven story.
6. **3D** — ProofScene first. leva to tune. postprocessing after 60fps. blender-mcp only if the mesh ceiling is real.
7. **Verify** — 1× DPR screenshot, whole view, compared to before. Source review is not visual proof. Native `<select>` popups are invisible to tab screenshots (Chromium limitation) — do not claim them verified.
8. **Two rejections** — stop polishing execution; ask if the **concept** is wrong.
9. **Open briefs** — do not label the conservative option "(Recommended)."

## Anti-patterns (check on the screenshot, not only in the rule)

- Full-bleed hairline dividers on data-heavy sections, unless asked.
- Box-shadow / border too close to the background (invisible until a screenshot).
- Native OS form chrome in a custom-themed app.
- Skipping to ui-ux-pro-max / component search on a new screen.
- Treating a placeholder mock (dot-grid SVG, lorem UI) as the real product.
- Inventing pricing, testimonials, or PII to "finish" a marketing remake.

## What a new session must not redo

Do not spend the first hour re-auditing Relume, Spline, Rive, lygia, or Shadcn Studio. This file is the audit. Open [NEW-DEVICE.md](https://github.com/syed-hassan7/cursor-agent-stack/blob/master/docs/NEW-DEVICE.md), install the stack, and start at step 1 of the sequence.
