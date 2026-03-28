# Rules

Modular instructions. Auto-loaded per scope.

- `alwaysApply: true` — every session
- `paths: [...]` — only when touching matching files

## Available

**code-quality.md** — Source files. Principles, naming, comments, code markers, file organization.

**testing.md** — Test files. Behavior-not-implementation, single-file runs, no flaky tests, AAA structure.

**security.md** — `src/api/**`, `src/auth/**`, routes, controllers. Input validation, queries, tokens, headers.

**frontend.md** — `*.tsx/jsx/vue/svelte/css/html`, components/, pages/. Design tokens, accessibility, performance.

**database.md** — Migration dirs. No modifying existing, always reversible, no seeding in migrations.

**error-handling.md** — API/service/handler dirs. Typed errors, consistent HTTP shapes, no stack traces in responses.

## Add Your Own

```yaml
---
paths:
  - "src/your-area/**"
---
# Rule Name
- instructions
```
