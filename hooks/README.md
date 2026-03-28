# Hooks

Deterministic enforcement — hooks block/transform tool calls, unlike rules (advisory).
Wired in `settings.json` under `"hooks"`. Exit 0 = allow, exit 2 = block. Scripts receive JSON on stdin; use `jq` to parse.

## Available

**protect-files.sh** — PreToolUse(Edit|Write). Blocks: `.env*`, certs/keys, credentials, lock files, `*.gen.ts`, minified bundles, `.git/`, `secrets/`, hook scripts, `settings.json`. Fails closed.

**warn-large-files.sh** — PreToolUse(Edit|Write). Blocks: `node_modules/`, `vendor/`, `dist/`, build dirs, binaries, media. Fails closed.

**block-dangerous-commands.sh** — PreToolUse(Bash). Blocks: force push to main/master, `rm -rf /~`, DROP/DELETE without WHERE, `chmod 777`, curl-to-bash.

**format-on-save.sh** — PostToolUse(Edit|Write). Auto-formats after edits. Detects: Biome, Prettier, Ruff, Black, rustfmt, gofmt.

**session-start.sh** — SessionStart. Injects: branch, last commit, uncommitted count, staged indicator, stash count.

## Add Your Own

1. Create `.sh` in this directory, `chmod +x`
2. Wire in `settings.json` under the relevant event + matcher
3. Parse `tool_input` from stdin with `jq`
