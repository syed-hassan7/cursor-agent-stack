# Architecture

## Design principles

1. **Global = pleasant default** — no pass ceilings, no phase gates on every chat
2. **Mechanical > prose** — hooks write files; rules tell agent how to use them
3. **One checkpoint per workspace root** — home and each repo are isolated
4. **Archives on compact only** — not every edit (avoids disk noise)
5. **Lean ambient context** — one sessionStart inject; slim brief; pointer rules on globs only

## Hook pipeline

```
sessionStart
  └─ session-rehydrate.js
       └─ buildSessionStartContext()
            ├─ buildSessionMemoryBrief()  ← paths + recent archive index (no playbook)
            └─ readForInjection(checkpoint.md)

preCompact  (/summarize)
  └─ pre-compact-flush.js
       └─ finalizeCompact()
            ├─ write checkpoint.md
            ├─ archiveCheckpoint() → archive/checkpoint-<ts>.md
            └─ pruneArchives() → max 10, max 7 days

postToolUse (Write|StrReplace)
  └─ session-checkpoint-update.js
       └─ updateFromToolUse() → merge files + goal scrape (filtered)

preToolUse (Write|StrReplace)
  └─ secret-guard.js → block secret patterns in write content
```

**Note (v0.5):** Do **not** register a second `sessionStart` hook for compact. `session-rehydrate.js` covers normal and post-compact resumes. A prior `post-compact-rehydrate.js` duplicated injection (~4K chars).

## Workspace root resolution

`checkpoint-lib.js` uses `workspace_roots[0]` from the hook payload, then walks up for `.git` or `.cursor` to find the session directory.

## Rules vs hooks

| Mechanism | When loaded | Purpose |
|-----------|-------------|---------|
| Rules (`.mdc`) | Every Agent turn (or globs) | Ambient knowledge — paths, budget, forensics |
| Hooks | Events | Write files, inject slim brief + checkpoint on sessionStart |

Playbook lives in **`session-memory.mdc`** (merged with former `context-budget.mdc`). Hook brief is **paths + archive index only** — no duplicated forensics table.

## Context forensics (HUD buckets)

Typical fixed baseline before typing:

| Bucket | What |
|--------|------|
| Tool definitions | Built-in tools (largest fixed cost) |
| Rules | alwaysApply `.mdc` files |
| Skills | Catalog metadata (not full SKILL.md) |
| MCP | Enabled server names + instructions |
| hooks_context | sessionStart brief + checkpoint |

Heavy MCP servers in **global** `~/.cursor/mcp.json` inflate every workspace. Prefer **project-scoped** `.cursor/mcp.json` — see [MCP.md](MCP.md).

Verbose MCP **responses** (full blueprint params, large user lists) inflate the Conversation bucket in one turn — summarize, do not dump.

## Cursor native `/summarize` vs this stack

Cursor replaces chat history with a **large narrative summary** + transcript pointer. This stack adds **structured** checkpoint + **archived snapshots** the agent can grep without you re-explaining paths.

## Extension points

- **Goal extraction** — `pickGoalMessage()` / `isMetaUserMessage()` in `checkpoint-lib.js`
- **File tracking** — `shouldTrackFile()` filters debug/agent-tools noise; `MAX_FILES` default 20
- **Archive retention** — `MAX_ARCHIVES`, `MAX_ARCHIVE_AGE_DAYS` constants
- **Project skills** — copy domain skills into `<repo>/.cursor/skills/` only when needed
- **MCP** — project `.cursor/mcp.json` via `scripts/mcp-link.ps1` — see [MCP.md](MCP.md)

## Frontend module (project-local)

Separate from session memory. See [FRONTEND.md](FRONTEND.md).

```
Global ~/.cursor/
  frontend-design-pointer.mdc   ← globs only (not alwaysApply)
  hooks.json                      ← checkpoint + secret-guard ONLY

Project <repo>/.cursor/
  hooks.json                      ← Impeccable design detector ONLY
  skills/impeccable/              ← npx impeccable install
  skills/ui-ux-pro-max/
  rules/frontend-design-lane.mdc
  design-refs/README.md

Project root
  PRODUCT.md, DESIGN.md           ← /impeccable init
  .impeccable/config.json
```

Hook stacking: Cursor runs global + project hooks. Checkpoint hooks must not be duplicated in project `hooks.json`.

### 3D module (project-local)

See [3D.md](3D.md). Same hook-stacking rules as frontend — no checkpoint hooks in project `hooks.json`.

```
Project <repo>/.cursor/
  skills/r3f-three/
  rules/3d-interactive-lane.mdc
  design-refs/3d.md

Project root
  scenes/ProofScene.tsx   (optional template from install-3d)
```

Global pointers (glob-gated):
- `frontend-design-pointer.mdc` → Impeccable when `.cursor/skills/impeccable/` exists
- `3d-interactive-pointer.mdc` → r3f-three when `.cursor/skills/r3f-three/` exists

Hybrid lane routing: [HYBRID.md](HYBRID.md).

## Verify

`scripts/verify.sh` (CI: `.github/workflows/verify.yml`) — hook syntax, single sessionStart, ui-ux-pro-max stack smoke tests.
