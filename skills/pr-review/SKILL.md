---
name: pr-review
description: Review code changes or a pull request — fetches PR context via /git-version-control then delegates analysis to @orchestrator
argument-hint: "[PR number | staged | file path — or omit to auto-detect]"
disable-model-invocation: true
---

Parse `$ARGUMENTS` to determine scope:
- PR number (e.g. `123` or `#123`)
- `staged` — review staged changes
- file path — review that file
- omit — use /git-version-control to check for an open PR on the current branch; fall back to staged then unstaged

**If scope is a PR:**
Use /git-version-control with the `fetch-pr` operation to retrieve title, body, author, base branch, diff, CI status, and open review threads. Pass this data directly to @orchestrator — do not make the orchestrator fetch it again.

**If scope is staged or file:**
Pass the scope to @orchestrator directly — no pre-fetching needed.

If there is nothing to review, say so and stop.

Return the orchestrator's report verbatim.
