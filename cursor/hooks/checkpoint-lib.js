#!/usr/bin/env node
// checkpoint-lib.js — repo-local session checkpoint (survives /compact)

const fs = require('fs');
const path = require('path');
const { spawnSync } = require('child_process');

const MAX_FILES = 20;
const MAX_GOAL_CHARS = 240;
const MAX_USER_MSGS = 5;
const MAX_ARCHIVES = 10;
const MAX_ARCHIVE_AGE_DAYS = 7;

function readHookInput() {
  if (process.stdin.isTTY) return {};
  try {
    const raw = fs.readFileSync(0, 'utf8').trim();
    return raw ? JSON.parse(raw) : {};
  } catch (_) {
    return {};
  }
}

function normalizeRoot(p) {
  if (!p || typeof p !== 'string') return '';
  return p.replace(/^\/([a-zA-Z]):/, '$1:');
}

function hookCwd(input) {
  const roots = input.workspace_roots || input.workspace?.roots;
  if (Array.isArray(roots) && roots[0]) {
    const root = normalizeRoot(roots[0]);
    if (root) return root;
  }
  return (
    input.cwd ||
    input.working_directory ||
    input.workspace?.current_dir ||
    process.cwd()
  );
}

function findProjectRoot(start) {
  let dir = path.resolve(start || process.cwd());
  for (let i = 0; i < 25; i++) {
    if (fs.existsSync(path.join(dir, '.git'))) return dir;
    if (fs.existsSync(path.join(dir, '.cursor'))) return dir;
    const parent = path.dirname(dir);
    if (parent === dir) break;
    dir = parent;
  }
  return path.resolve(start || process.cwd());
}

function sessionDir(projectRoot) {
  return path.join(projectRoot, '.cursor', 'session');
}

function checkpointPath(projectRoot) {
  return path.join(sessionDir(projectRoot), 'checkpoint.md');
}

function archiveDir(projectRoot) {
  return path.join(sessionDir(projectRoot), 'archive');
}

function archiveFileName(compactAt) {
  const safe = String(compactAt).replace(/[:.]/g, '-');
  return `checkpoint-${safe}.md`;
}

function archiveCheckpoint(projectRoot, content, compactAt) {
  const dir = archiveDir(projectRoot);
  fs.mkdirSync(dir, { recursive: true });
  const name = archiveFileName(compactAt);
  const fp = path.join(dir, name);
  fs.writeFileSync(fp, content, 'utf8');
  pruneArchives(projectRoot);
  return path.join('archive', name).replace(/\\/g, '/');
}

function pruneArchives(projectRoot) {
  const dir = archiveDir(projectRoot);
  if (!fs.existsSync(dir)) return;
  const now = Date.now();
  const maxAgeMs = MAX_ARCHIVE_AGE_DAYS * 24 * 60 * 60 * 1000;
  const files = fs
    .readdirSync(dir)
    .filter((f) => /^checkpoint-.+\.md$/.test(f))
    .map((f) => {
      const fp = path.join(dir, f);
      let mtime = 0;
      try {
        mtime = fs.statSync(fp).mtimeMs;
      } catch (_) {}
      return { fp, mtime };
    })
    .sort((a, b) => b.mtime - a.mtime);

  for (let i = 0; i < files.length; i++) {
    const { fp, mtime } = files[i];
    if (i >= MAX_ARCHIVES || now - mtime > maxAgeMs) {
      try {
        fs.unlinkSync(fp);
      } catch (_) {}
    }
  }
}

function gitBrief(projectRoot) {
  const branch = spawnSync(
    'git',
    ['-C', projectRoot, '--no-optional-locks', 'symbolic-ref', '--short', 'HEAD'],
    { encoding: 'utf8', timeout: 800 }
  );
  const stat = spawnSync(
    'git',
    ['-C', projectRoot, '--no-optional-locks', 'diff', '--stat', '--shortstat'],
    { encoding: 'utf8', timeout: 1200 }
  );
  const branchName =
    branch.status === 0 && branch.stdout ? branch.stdout.trim() : '(no branch)';
  const statLine = (stat.stdout || '').trim().split('\n').filter(Boolean).slice(-1)[0] || '';
  return { branch: branchName, stat: statLine };
}

function scrapeUserMessages(transcriptPath, limit = MAX_USER_MSGS) {
  if (!transcriptPath || !fs.existsSync(transcriptPath)) return [];
  const messages = [];
  try {
    const lines = fs.readFileSync(transcriptPath, 'utf8').split('\n');
    for (let i = lines.length - 1; i >= 0 && messages.length < limit; i--) {
      const line = lines[i].trim();
      if (!line) continue;
      let row;
      try {
        row = JSON.parse(line);
      } catch (_) {
        continue;
      }
      const text = extractUserText(row);
      if (text && !isMetaUserMessage(text)) messages.unshift(text.slice(0, MAX_GOAL_CHARS));
    }
  } catch (_) {}
  return messages;
}

function pickGoalMessage(messages) {
  if (!messages.length) return '';
  for (let i = messages.length - 1; i >= 0; i--) {
    const m = messages[i];
    if (isMetaUserMessage(m)) continue;
    if (m.length >= 30 && !/^If the available MCP/i.test(m)) return m;
  }
  for (let i = messages.length - 1; i >= 0; i--) {
    if (!isMetaUserMessage(messages[i])) return messages[i];
  }
  return '';
}

function cleanUserQuery(text) {
  if (!text) return '';
  return text
    .replace(/<\/?user_query>/gi, '')
    .replace(/\s+/g, ' ')
    .trim()
    .slice(0, MAX_GOAL_CHARS);
}

function shouldTrackFile(relPath) {
  if (!relPath) return false;
  const p = String(relPath).replace(/\\/g, '/');
  if (p.includes('agent-tools/')) return false;
  const base = p.split('/').pop() || '';
  if (/^(sim_|debug_|repro_|inspect_)/i.test(base)) return false;
  return true;
}

function isMetaUserMessage(text) {
  if (!text) return true;
  const t = String(text);
  if (/System prompt\s+\d+/i.test(t) && /Free space/i.test(t)) return true;
  if (/^Tool definitions\s+/i.test(t)) return true;
  if (/^\/compact\b/i.test(t.trim())) return true;
  if (/^\/summarize\b/i.test(t.trim())) return true;
  return false;
}

function extractUserText(row) {
  if (!row || typeof row !== 'object') return '';
  let text = '';

  if (row.role === 'user') {
    if (typeof row.content === 'string') text = row.content;
    else if (row.message?.content) {
      const c = row.message.content;
      if (typeof c === 'string') text = c;
      else if (Array.isArray(c)) {
        text = c
          .filter((p) => p && p.type === 'text' && typeof p.text === 'string')
          .map((p) => p.text)
          .join(' ')
          .trim();
      }
    }
  } else if (row.type === 'user' && typeof row.message === 'string') {
    text = row.message;
  } else if (row.type === 'user' && row.message?.content) {
    const c = row.message.content;
    if (typeof c === 'string') text = c;
    else if (Array.isArray(c)) {
      text = c
        .filter((p) => p && p.type === 'text')
        .map((p) => p.text)
        .join(' ')
        .trim();
    }
  } else if (typeof row.text === 'string' && (row.role === 'user' || row.source === 'user')) {
    text = row.text;
  }

  return cleanUserQuery(text);
}

function loadState(projectRoot) {
  const fp = checkpointPath(projectRoot);
  const state = {
    files: [],
    userMessages: [],
    lastCompactAt: null,
    updatedAt: null,
  };
  if (!fs.existsSync(fp)) return state;
  try {
    const raw = fs.readFileSync(fp, 'utf8');
    const compactMatch = raw.match(/^compact_at:\s*(.+)$/m);
    if (compactMatch) state.lastCompactAt = compactMatch[1].trim();
    const fileSection = raw.match(/## Files touched\n([\s\S]*?)(?:\n##|$)/);
    if (fileSection) {
      state.files = fileSection[1]
        .split('\n')
        .map((l) => l.replace(/^-\s*/, '').trim())
        .filter((f) => f && f !== '(none yet)' && shouldTrackFile(f));
    }
  } catch (_) {}
  return state;
}

function relFile(projectRoot, filePath) {
  if (!filePath) return null;
  const abs = path.isAbsolute(filePath) ? filePath : path.join(projectRoot, filePath);
  try {
    return path.relative(projectRoot, abs).replace(/\\/g, '/');
  } catch (_) {
    return String(filePath).replace(/\\/g, '/');
  }
}

function renderCheckpoint(projectRoot, state, opts = {}) {
  const { branch, stat } = gitBrief(projectRoot);
  const now = new Date().toISOString();
  const goal =
    pickGoalMessage(opts.userMessages || []) ||
    pickGoalMessage(state.userMessages || []) ||
    '(infer from recent user messages after compact)';

  const files = [...new Set([...(state.files || []), ...(opts.newFiles || [])])].slice(-MAX_FILES);

  const lines = [
    '# Session checkpoint',
    `updated_at: ${now}`,
    `compact_at: ${opts.compactAt || state.lastCompactAt || 'none'}`,
    `workspace: ${projectRoot.replace(/\\/g, '/')}`,
    `branch: ${branch}`,
    '',
    '## Goal (latest user intent)',
    goal,
    '',
    '## Files touched',
    ...(files.length ? files.map((f) => `- ${f}`) : ['- (none yet)']),
    '',
    '## Git delta',
    stat || '(clean or not a git repo)',
    '',
    '## After compact',
    'This file is auto-maintained. Continue from Goal + Files + Git delta.',
    'Do not re-explore the repo from scratch.',
  ];

  if (opts.userMessages && opts.userMessages.length > 1) {
    lines.push('', '## Recent user messages');
    for (const msg of opts.userMessages.slice(-MAX_USER_MSGS)) {
      lines.push(`- ${msg.replace(/\s+/g, ' ').slice(0, MAX_GOAL_CHARS)}`);
    }
  }

  return lines.join('\n') + '\n';
}

function auditLog(projectRoot, event, detail) {
  try {
    const dir = sessionDir(projectRoot);
    fs.mkdirSync(dir, { recursive: true });
    const line = `${new Date().toISOString()} | ${event} | ${detail || ''}\n`;
    fs.appendFileSync(path.join(dir, 'hook-audit.log'), line, 'utf8');
  } catch (_) {}
}

function writeCheckpoint(projectRoot, content) {
  const dir = sessionDir(projectRoot);
  fs.mkdirSync(dir, { recursive: true });
  const gitignore = path.join(dir, '.gitignore');
  if (!fs.existsSync(gitignore)) {
    fs.writeFileSync(gitignore, '# Session state — do not commit\n*\n!.gitignore\n', 'utf8');
  }
  fs.writeFileSync(checkpointPath(projectRoot), content, 'utf8');
}

function updateFromToolUse(input) {
  const cwd = hookCwd(input);
  const projectRoot = findProjectRoot(cwd);
  const toolInput = input.tool_input || input.toolInput || {};
  const filePath = toolInput.path || toolInput.file_path || '';
  const rel = relFile(projectRoot, filePath);
  const transcriptPath = input.transcript_path || input.transcriptPath || '';
  const userMessages = scrapeUserMessages(transcriptPath);
  const state = loadState(projectRoot);
  if (rel && !rel.startsWith('..') && shouldTrackFile(rel)) state.files.push(rel);
  // drop untracked noise from prior checkpoints
  state.files = (state.files || []).filter(shouldTrackFile);
  if (userMessages.length) state.userMessages = userMessages;
  const content = renderCheckpoint(projectRoot, state, {
    newFiles: rel && !rel.startsWith('..') && shouldTrackFile(rel) ? [rel] : [],
    userMessages,
  });
  writeCheckpoint(projectRoot, content);
  auditLog(projectRoot, 'postToolUse', rel || 'write');
  return { projectRoot, content, rel };
}

function finalizeCompact(input) {
  const cwd = hookCwd(input);
  const projectRoot = findProjectRoot(cwd);
  const transcriptPath = input.transcript_path || input.transcriptPath || '';
  const userMessages = scrapeUserMessages(transcriptPath);
  const state = loadState(projectRoot);
  if (userMessages.length) state.userMessages = userMessages;
  const compactAt = new Date().toISOString();
  const content = renderCheckpoint(projectRoot, state, {
    userMessages,
    compactAt,
  });
  writeCheckpoint(projectRoot, content);
  const archiveRel = archiveCheckpoint(projectRoot, content, compactAt);
  auditLog(projectRoot, 'preCompact', `${compactAt} | ${archiveRel}`);
  return { projectRoot, content, compactAt, archiveRel };
}

function listArchives(projectRoot, limit = 5) {
  const dir = archiveDir(projectRoot);
  if (!fs.existsSync(dir)) return [];
  return fs
    .readdirSync(dir)
    .filter((f) => /^checkpoint-.+\.md$/.test(f))
    .map((f) => {
      const fp = path.join(dir, f);
      let mtime = 0;
      let goal = '';
      try {
        mtime = fs.statSync(fp).mtimeMs;
        const raw = fs.readFileSync(fp, 'utf8');
        const goalMatch = raw.match(/## Goal \(latest user intent\)\n([\s\S]*?)(?:\n##|$)/);
        if (goalMatch) goal = goalMatch[1].trim().slice(0, 120);
      } catch (_) {}
      return { name: f, mtime, goal };
    })
    .sort((a, b) => b.mtime - a.mtime)
    .slice(0, limit);
}

function buildSessionMemoryBrief(projectRoot, opts = {}) {
  const ws = projectRoot.replace(/\\/g, '/');
  const archives = listArchives(projectRoot);
  const lines = [
    'SESSION MEMORY',
    `Workspace: ${ws}`,
    'Live: `.cursor/session/checkpoint.md`',
    'Archives: `.cursor/session/archive/` (newest 10, max 7 days)',
    'Audit: `.cursor/session/hook-audit.log`',
  ];

  if (opts.compactAt) {
    lines.push('', `Latest compact: ${opts.compactAt}${opts.archiveRel ? ` → ${opts.archiveRel}` : ''}`);
  }

  if (archives.length) {
    lines.push('', 'Recent compacts (newest first):');
    for (const a of archives) {
      const when = new Date(a.mtime).toISOString().replace('T', ' ').slice(0, 16);
      lines.push(`- ${a.name} (${when} UTC)${a.goal ? ` — ${a.goal}` : ''}`);
    }
  } else {
    lines.push('', 'Recent compacts: none yet (appear after first `/summarize`).');
  }

  return lines.join('\n');
}

function buildSessionStartContext(input, eventName, opts = {}) {
  const projectRoot = findProjectRoot(hookCwd(input));
  const brief = buildSessionMemoryBrief(projectRoot, opts);
  const checkpoint = opts.checkpoint || readForInjection(projectRoot);
  auditLog(
    projectRoot,
    eventName,
    checkpoint ? 'brief+checkpoint' : 'brief-only'
  );

  const parts = [brief];
  if (checkpoint) {
    parts.push(
      '',
      '---',
      'CURRENT CHECKPOINT — continue from this unless user asks for older session history:',
      '',
      checkpoint
    );
  }

  return { projectRoot, context: parts.join('\n'), hasCheckpoint: !!checkpoint };
}

function rehydrateFromCheckpoint(input, eventName) {
  const { context, hasCheckpoint } = buildSessionStartContext(input, eventName);
  return hasCheckpoint || context ? context : null;
}

function readForInjection(projectRoot) {
  const fp = checkpointPath(projectRoot);
  if (!fs.existsSync(fp)) return null;
  try {
    const text = fs.readFileSync(fp, 'utf8').trim();
    return text.length > 6000 ? text.slice(0, 6000) + '\n\n...(truncated)' : text;
  } catch (_) {
    return null;
  }
}

function emitJson(obj) {
  process.stdout.write(JSON.stringify(obj));
}

module.exports = {
  readHookInput,
  hookCwd,
  findProjectRoot,
  checkpointPath,
  updateFromToolUse,
  finalizeCompact,
  readForInjection,
  emitJson,
  auditLog,
  buildSessionStartContext,
  rehydrateFromCheckpoint,
};
