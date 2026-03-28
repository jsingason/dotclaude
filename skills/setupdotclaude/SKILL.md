---
name: setupdotclaude
description: Scan the project codebase and customize all .claude/ configuration files to match. Run this after adding the .claude/ folder to a new project.
argument-hint: "[optional: focus area like 'frontend' or 'backend']"
disable-model-invocation: true
---

Scan this project's codebase and customize every `.claude/` configuration file to match the actual tech stack, conventions, and patterns in use. Confirm with the user before each change using AskUserQuestion.

CLAUDE.md must be at the project root (`./CLAUDE.md`), NOT inside `.claude/`. All other config files live inside `.claude/`.

If the project is empty or has no source code yet, tell the user the defaults will be kept as-is and stop.

## Phase 0: Clean Up Non-Config Files

Before anything else, delete files inside `.claude/` that exist for the dotclaude repo itself but waste tokens or cause issues at runtime:
- `.claude/README.md` (repo README accidentally copied in)
- `.claude/CONTRIBUTING.md` (repo contributing guide accidentally copied in)
- `.claude/.gitignore` (for the dotclaude repo, not the project — the project has its own .gitignore)
- `.claude/rules/README.md`
- `.claude/agents/README.md`
- `.claude/hooks/README.md`
- `.claude/skills/README.md`

Also delete `.claude/CLAUDE.md` if it exists — CLAUDE.md belongs at the project root, not inside `.claude/`.

Never delete `.claude/rules/lessons.md` — it contains project-specific lessons learned.

## Phase 1: Detect Tech Stack

Scan for package manifests, config files, and folder structure to detect: language, framework, package manager, test framework, linter/formatter, architecture pattern, and source/test directories.

Check: `package.json`, `pyproject.toml`, `Cargo.toml`, `go.mod`, `Gemfile`, `composer.json`, `build.gradle`, `pom.xml`, `Makefile`, `Dockerfile`.

Check for monorepo indicators: `workspaces` key in package.json, `pnpm-workspace.yaml`, `lerna.json`, `nx.json`, `turbo.json`, or multiple `package.json` files at depth 2+. If a monorepo is detected, ask the user which packages/apps to focus on and customize rule path patterns to include package prefixes (e.g., `packages/api/src/**` instead of `src/**`).

Detect frameworks from dependencies and config files (frontend, backend, CSS, components, ORM/DB).

Detect test framework from config files (`jest.config.*`, `vitest.config.*`, `pytest.ini`, `conftest.py`, `playwright.config.*`, etc.).

Detect linter/formatter from config files (`.eslintrc.*`, `.prettierrc.*`, `biome.json`, `ruff.toml`, `tsconfig.json`, `.editorconfig`, etc.).

Detect folder structure pattern (feature-based, layered, monorepo, MVC) and locate source, test, API, and auth directories.

Check `git log --oneline -20` for commit message style.

Detect git hosting from `git remote get-url origin`:
- `github.com` → gh
- `gitlab.com` or gitlab self-hosted pattern → glab
- `dev.azure.com` or `visualstudio.com` → az repos
- `bitbucket.org` → none (no standard CLI)
- SSH or unrecognized → unknown, ask user

## Phase 2: Present Findings

Present a summary to the user using AskUserQuestion:

```
I scanned your project. Here's what I found:

**Stack**: [language] + [framework] + [CSS] + [DB]
**Package manager**: [npm/pnpm/yarn/bun/pip/cargo/go]
**Test framework**: [jest/vitest/pytest/etc.]
**Linter/Formatter**: [eslint+prettier/ruff/clippy/etc.]
**Architecture**: [layered/feature-based/monorepo/etc.]
**Source dirs**: [list]
**Test dirs**: [list]
**Git remote**: [url]
**Git CLI (detected)**: [gh / glab / az repos / none / unknown]

Should I customize the .claude/ files based on this? (yes/no/corrections)
```

If the user provides corrections, incorporate them.

## Phase 2b: Configure Hooks & Workflow

### 2b.1 — Hook Opt-In

Present each hook and ask whether to enable it (all on by default):

```
Which hooks do you want enabled?

1. protect-files      — blocks writes to .env, secrets, keys, certs, lock files, generated files, settings.json. Prevents accidental overwrites.
2. warn-large-files   — blocks writes to node_modules/, dist/, build dirs, binaries. Prevents wasted edits on untracked artifacts.
3. scan-secrets       — scans content before writing; blocks if API keys, tokens, or credentials are detected.
4. block-dangerous-commands — blocks force-push to main/master, rm -rf /, DROP without WHERE, chmod 777, curl|bash.
5. format-on-save     — auto-runs your formatter (Prettier/Ruff/rustfmt/etc.) after each file edit.
6. session-start      — injects branch, last commit, uncommitted count, and stash count into each session.
7. notifications      — sends a desktop notification (macOS: osascript, Linux: notify-send) when Claude needs attention.

Enable all? (yes / or specify numbers to disable, e.g. "disable 5 7")
```

For each disabled hook, remove its entry from `settings.json`. If **all hooks are disabled**, ask: "Remove the entire `hooks` block from settings.json and delete the hooks/ folder? (yes/no)" — if yes, remove the whole block and delete `.claude/hooks/`. For enabled hooks, proceed with per-hook config in section 3.7.

### 2b.2 — Feature Branch vs Worktree Workflow

Ask:

```
How do you prefer to isolate feature work?

  1. feature-branches — checkout a new branch in your working directory (standard git flow)
  2. worktrees        — each feature gets its own directory via `git worktree add`, keeping your working dir clean

Which do you prefer? (1/2, default: 1)
```

If worktrees: add a line to `CLAUDE.md` under the Workflow section: "Use `git worktree` for feature isolation — don't checkout branches in the main working directory."

## Phase 3: Customize Each File

For each file below, propose the specific changes and ask the user to confirm before applying.

### 3.1 — CLAUDE.md

Replace the template commands with actual commands from the detected manifest:
- **Build**: actual build command from package.json scripts, Makefile targets, etc.
- **Test**: actual test command + how to run a single test file
- **Lint/Format**: actual lint and format commands
- **Dev**: actual dev server command
- **Architecture**: replace placeholder directories with actual project structure (only non-obvious parts)

Remove sections that don't apply (e.g., Architecture section for a single-file utility).

### 3.2 — settings.json

Update permissions to match actual commands:
- Replace `npm run` with the actual package manager (`pnpm run`, `yarn`, `bun run`, `cargo`, `go`, `make`, `python -m pytest`, etc.)
- Add project-specific allow rules for detected scripts
- Keep deny rules for secrets as-is (these are universal)

### 3.2b — Detect Build/Test/Lint Commands for Skill Allowed-Tools

Detect the project's actual build, test, and lint commands:
- **Node.js**: read `package.json` scripts for `build`, `test`, `lint`, `typecheck`
- **Go**: `go build ./...`, `go test ./...`, `golangci-lint run` (if installed)
- **Rust**: `cargo build`, `cargo test`, `cargo clippy`
- **Python**: `pytest` or `python -m pytest` (check deps), `ruff check .` or `flake8`
- **.NET**: `dotnet build`, `dotnet test`
- **Make**: grep Makefile for `build:`, `test:`, `lint:` targets

Present to user and confirm:

```
Detected commands:
  build: [command or "not found"]
  test:  [command or "not found"]
  lint:  [command or "not found"]

Update skill allowed-tools with these? (yes/no/edit)
```

After confirmation, update `allowed-tools` frontmatter in skill files:
- `skills/hotfix/SKILL.md`: replace `Bash(npm run test *)` and `Bash(npm run build)` with detected commands (e.g. `Bash(pnpm run test *)`, `Bash(go test *)`)
- `skills/ship/SKILL.md`: add lint command to `allowed-tools` if detected (e.g. `Bash(pnpm run lint)`)

**Restart required**: `allowed-tools` loads at session start. Tell the user to restart Claude Code after setup completes.

If no build system is detected, skip this section and note it.

### 3.2c — Git Hosting CLI

Ask the user to confirm (or correct) the detected CLI:

```
Which CLI do you use for PR/MR/issue operations?
  1. gh       — GitHub CLI
  2. glab     — GitLab CLI
  3. az repos — Azure DevOps CLI
  4. none     — I'll create PRs manually
  5. other    — specify the command prefix
```

All git hosting configuration lives in one file: `skills/git-version-control/SKILL.md`. After confirming, update only that file:

**1. `allowed-tools` frontmatter** — replace `Bash(gh *)` with the appropriate entry:
- glab → `Bash(glab *)`
- az repos → `Bash(az *)`
- none → remove the entry entirely
- other → `Bash([prefix] *)`

**2. `# Hosting CLI:` line** — update the name (e.g. `# Hosting CLI: glab`)

**3. Command Reference table** — replace all `gh` commands with the platform's equivalents:

| Operation | glab | az repos | none |
|-----------|------|----------|------|
| Create PR/MR | `glab mr create --title "$T" --description "$B"` | `az repos pr create --title "$T" --description "$B"` | *(manual — provide branch + title/body to user)* |
| Check existing | `glab mr view` | `az repos pr list --source-branch $BRANCH` | — |
| Fetch details | `glab mr view $N --output json` | `az repos pr show --id $N` | — |
| Fetch diff | `glab mr diff $N` | *(no direct equivalent — use `git diff`)* | — |
| Check CI | `glab mr checks $N` | `az pipelines runs list --branch $BRANCH` | — |
| Review comments | `glab mr note list $N` | `az repos pr reviewer list --id $N` | — |
| Fetch issue | `glab issue view $N` | `az boards work-item show --id $N` | — |

No other skill files need editing — they all delegate to /git-version-control.

### 3.3 — rules/code-quality.md

Update naming conventions ONLY if the project's existing code uses different patterns:
- Sample 5-10 source files to detect actual naming style (camelCase vs snake_case, etc.)
- If the project uses different file naming than the template, update
- If the project's import style differs, update the import order section

If everything matches the defaults, leave it unchanged.

### 3.4 — rules/testing.md

Update if the detected test framework has specific idioms. Otherwise leave as-is (it's only 3 lines).

### 3.5 — rules/security.md

Update the `paths:` frontmatter to match actual project directories:
- Replace `src/api/**` with actual API directory paths found
- Replace `src/auth/**` with actual auth directory paths
- Replace `src/middleware/**` with actual middleware paths
- If none found, keep the defaults as reasonable guesses

### 3.5b — rules/error-handling.md

Update the `paths:` frontmatter to match actual backend directories (same paths as security.md plus service/handler directories). If the project has no backend, delete this file.

### 3.6 — rules/frontend.md

- **If no frontend files exist** (no .tsx, .jsx, .vue, .svelte, .css): delete this file entirely
- **If frontend exists**: update the Component Framework table to highlight which options the project actually uses (detected from dependencies)
- Update path patterns in frontmatter if the project uses non-standard directories

### 3.7 — hooks/ _(apply per user choices from Phase 2b.1)_

For each hook the user **disabled**, remove its block from `settings.json`. For each hook the user **kept**, apply the project-specific config below:

**hook 1 — protect-files.sh**: No configuration needed. Check `protect-files.sh` for hardcoded paths; if the project uses non-standard secret/generated file patterns, add them.

**hook 2 — warn-large-files.sh**: No configuration needed. Blocks standard build artifact dirs by default.

**hook 3 — scan-secrets.sh**: No configuration needed. Pattern-based; works across all projects.

**hook 4 — block-dangerous-commands.sh**: Check the default branch name (`git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null` or `git remote show origin`). If it's not `main` or `master`, update the regex pattern in the script.

**hook 5 — format-on-save.sh**: Uncomment the section matching the detected formatter:
- Prettier → uncomment Node.js section
- Black/isort → uncomment Python section
- Ruff → uncomment Ruff section
- Biome → uncomment Biome section
- rustfmt → uncomment Rust section
- gofmt → uncomment Go section
- Multiple languages → uncomment all relevant sections

**hook 6 — session-start.sh**: No configuration needed. Injects git state automatically.

**hook 7 — notifications**: Already inline in `settings.json` (not a shell script). If disabled, remove the `Notification` block from `settings.json`.

### 3.9 — rules/database.md

- Check if the project has a database (look for: migration directories, ORM config files like `prisma/schema.prisma`, `drizzle.config.*`, `alembic.ini`, `knexfile.*`, `sequelize` in dependencies, `typeorm` in dependencies, `ActiveRecord` patterns, `flyway`, `liquibase`)
- **If database/migrations detected**: keep the rule, update `paths:` frontmatter to match the actual migration directory paths found
- **If no database detected**: delete `rules/database.md` entirely

### 3.10 — skills/

All skills are methodology-based and project-agnostic. Leave unchanged.

### 3.11 — agents/

- **frontend-designer.md**: delete if no frontend files exist
- **doc-reviewer.md**: delete if the project has no documentation directory (no `docs/`, `doc/`, or significant `.md` files beyond README)
- **security-reviewer.md**: keep (universal)
- **code-reviewer.md**: keep (universal)
- **performance-reviewer.md**: keep (universal)
- **orchestrator.md**: keep (universal — coordinates all reviewers)

## Phase 4: Review & Simplify

After all changes are applied, run a thorough final review pass.

Strip any remaining `> REPLACE:` placeholder blocks from `CLAUDE.md` — these are template guidance that should have been replaced with real content or removed during Phase 3.1.

Review the entire codebase alongside the customized `.claude/` configuration:
- Do the rules match how the code is actually written?
- Do the settings permissions cover the commands the project actually uses?
- Do the security rule paths match where sensitive code actually lives?
- Do the hook protections cover the files that actually need protecting in this project?
- Are there project patterns, conventions, or architectural decisions not yet captured in the config?
- Remove any redundancy introduced during customization
- Ensure no file contradicts another
- Trim any verbose instructions back to essentials
- Verify all YAML frontmatter is valid
- Verify all hook scripts referenced in settings.json exist and are executable

Present the review findings to the user. If changes are needed, confirm before applying.

## Phase 5: Summary

After everything is finalized, present a summary:

```
Setup complete. Here's what was customized:

- CLAUDE.md: updated commands for [stack]
- settings.json: permissions updated for [package manager]
- skills/hotfix/SKILL.md + skills/ship/SKILL.md: allowed-tools updated for [commands]
- CLAUDE.md + skill allowed-tools: git CLI configured for [gh/glab/az repos/none]
- rules/security.md: paths updated to [actual dirs]
- rules/frontend.md: [kept/removed]
- hooks/format-on-save.sh: enabled [formatter]
- [any other changes]

Files left as defaults (universal, no project-specific changes needed):
- [list]

Review pass: [any issues found and fixed, or "all clean"]
```

## Rules

- NEVER write changes without user confirmation first
- NEVER delete a file without confirming — propose "remove" and explain why
- If the project is empty (no source files, no manifests), say "Project appears empty — keeping all defaults" and stop
- If detection is uncertain, ASK the user rather than guessing
- Preserve any manual edits the user has already made to .claude/ files — only update sections that need project-specific customization
- Keep it minimal — don't add complexity. If the default works, leave it alone.
