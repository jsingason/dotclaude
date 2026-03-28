# Skills

Slash commands. Run in main conversation context (see all rules + CLAUDE.md).

`disable-model-invocation: true` = manual only. Without it, Claude can auto-trigger.

## Available

**/setupdotclaude** `[focus]` — scan project, customize all `.claude/` files for actual stack. Run once after install.

**/debug-fix** `[issue/error/desc]` — understand → reproduce → investigate → fix → verify → commit.

**/ship** `[message]` — scan → stage → commit → push → PR. Confirmation at each step.

**/hotfix** `[issue/error/desc]` — hotfix branch → minimal change → critical tests → ship fast.

**/pr-review** `[PR# | staged | path]` — delegates to @orchestrator → specialist agents → unified report.

**/tdd** `[feature]` — red/green/refactor loop, commits each cycle.

**/explain** `[file/function/concept]` — summary, mental model, ASCII diagram, modification guide.

**/refactor** `[target]` — tests first, small steps, verify no behavior change.

**/test-writer** — auto-triggered on new features. Full coverage: happy path, edge, null, async, error.

**/learn-lesson** — auto-triggered after mistakes. Recurring errors → noted immediately. One-offs → asks first. Writes to `.claude/rules/lessons.md`.

**/git-version-control** — single configuration point for all git hosting CLI operations (PRs, MRs, issues, CI checks). Auto-invoked by other skills. Configured once by /setupdotclaude.

## Add Your Own

```
your-skill/
└── SKILL.md
```

```yaml
---
name: your-skill
description: what it does
disable-model-invocation: true
---
instructions. use $ARGUMENTS for user input.
```
