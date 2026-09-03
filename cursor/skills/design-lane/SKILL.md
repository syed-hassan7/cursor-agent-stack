---
name: design-lane
description: >-
  Design sequence and resource library for UI, marketing remakes, scroll
  choreography, and hybrid 2D+WebGL. Use when the user asks to design,
  redesign, polish, remake a site, pick motion/3D tools, or install
  design skills on a new machine. Read DESIGN-RESOURCES before researching
  new connectors.
---

# Design lane

Read the library **before** searching for new design tools, MCPs, or plugins.

Resolve **DESIGN-RESOURCES.md** in this order:

1. This repo is `cursor-agent-stack` → `docs/DESIGN-RESOURCES.md`
2. Else `<repo>/.cursor/design-refs/library.md`
3. Else sibling `cursor-agent-stack/docs/DESIGN-RESOURCES.md`
4. Else https://raw.githubusercontent.com/syed-hassan7/cursor-agent-stack/master/docs/DESIGN-RESOURCES.md

New machine / new Cursor: also read `docs/NEW-DEVICE.md` (same resolution).

## Sequence (do not invert)

1. `PRODUCT.md` + `DESIGN.md`. `/impeccable init` or `shape` if missing.
2. Name **one** visual extreme in writing before CSS.
3. Then ui-ux-pro-max / one awesome-design-md brand / Superdesign — against that extreme.
4. Official shadcn, then react-bits, then hand-roll.
5. Motion (`motion/react`). transitions-dev for overlays. scroll-craft for scroll-driven stories.
6. 3D: ProofScene first. No `/impeccable polish` on WebGL. blender-mcp only as an escalation.
7. Real browser screenshot before calling UI done.
8. Two rejections of the same element → stop and question the concept.

Live-URL remake: **site-remake** skill first (Phase 1 only). Do not scaffold.

## Hard rules

- Do not re-propose Relume, Spline-as-hero, Rive authoring, lygia, Shadcn Studio, or other rows in the library's reject table without new evidence.
- Superdesign / ui-ux-pro-max never overwrite repo-root `DESIGN.md`.
- Firecrawl and other heavy MCP stay in **project** `.cursor/mcp.json`.
- Do not invent pricing, testimonials, or PII on a remake.
