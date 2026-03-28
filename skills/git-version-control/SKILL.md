---
name: git-version-control
description: All git hosting platform operations — create/view PRs or MRs, check CI status, fetch issues and work-items. Single configuration point for the hosting CLI. Auto-invoked by other skills that need platform operations.
allowed-tools:
  - Bash(gh *)
---

# Hosting CLI: gh
# Configured by /setupdotclaude. To change platform, run /setupdotclaude or edit the CLI name above and the allowed-tools in the frontmatter.

## Command Reference

| Operation | Command |
|-----------|---------|
| Create PR/MR | `gh pr create --title "$TITLE" --body "$BODY"` |
| Check existing PR/MR on branch | `gh pr view` |
| Fetch PR/MR details | `gh pr view $NUMBER --json title,body,baseRefName,headRefName,author,additions,deletions,changedFiles` |
| Fetch PR/MR diff | `gh pr diff $NUMBER` |
| Check CI status | `gh pr checks $NUMBER` |
| List review comments | `gh api repos/{owner}/{repo}/pulls/$NUMBER/comments` |
| Fetch issue / work-item | `gh issue view $NUMBER` |

## Operations

Determine which operation is needed from $ARGUMENTS or the context of the invoking skill:

### create-pr
- Draft title (under 72 chars) and body (summary + test plan) from commits on this branch vs base
- Confirm with user before creating
- Run the create command above
- Output the PR/MR URL

### fetch-pr [number or auto-detect]
Gather full PR/MR context and return it as structured data for the caller:
- If no number given, run the "check existing" command to find the PR for the current branch
- Run view, diff, CI, and comments commands
- Return: title, body, author, base branch, additions/deletions, changed files, full diff, CI status, open review threads

### view-issue [number]
- Run the issue/work-item command above
- Return: title, body, labels, assignee, status

If no CLI is configured (none), tell the user to open the PR/MR manually and provide them with the branch name and a suggested title and body.
