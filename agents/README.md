# Agents

Specialist sub-agents in isolated context. Invoked with `@agent-name` or auto-delegated.

- **orchestrator** — gathers diff once, fans out to reviewers, synthesizes report. Used by /pr-review.
- **code-reviewer** — bugs, null dereferences, logic errors, race conditions. No style nitpicks.
- **security-reviewer** — OWASP: injection, broken auth, IDOR, data exposure, weak crypto.
- **performance-reviewer** — N+1, memory leaks, blocking I/O, unbounded caches, re-renders.
- **doc-reviewer** — accuracy vs actual source, completeness, staleness.
- **frontend-designer** — production UI with design tokens. Anti-slop aesthetics. Has Write/Edit access.

## Add Your Own

```yaml
---
name: your-agent
description: When to delegate here
tools: [Read, Grep, Glob, Bash]
---
system prompt here
```
