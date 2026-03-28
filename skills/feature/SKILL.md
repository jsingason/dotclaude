---
name: feature
description: Build a new feature — plan with @orchestrator, /tdd for backend, @frontend-designer for UI, @orchestrator review before ship
argument-hint: "[feature description]"
disable-model-invocation: true
---

Feature: **$ARGUMENTS**

## 0. Branch Setup

Ask the user: "Create a feature branch for this work? (y/n)"

If yes:
1. `git pull` to sync with remote
2. Generate a descriptive branch name from the feature description (e.g. `feat/add-user-authentication`)
3. `git checkout -b <branch-name>`
4. Confirm the branch was created before proceeding

If no, continue on the current branch.

## 1. Classify

- **Backend** — services, APIs, models, business logic, jobs
- **Frontend** — components, pages, interactions, styling
- **Full-stack** — both
- **Unclear** — ask before proceeding

## 2. Plan → @orchestrator

Pass: feature description, classification, known file paths.
Get back: work breakdown, files affected, ambiguities.
Confirm plan with user. Don't implement until confirmed.

## 3. Implement

**Backend → /tdd**
No backend code without a failing test. One behavior at a time. Commit each cycle.

**Frontend → @frontend-designer**
Pass: confirmed plan, component names, data shapes, relevant files.
Never implement UI yourself.

**Full-stack:** backend first, then frontend — designer needs real contracts.

## 4. Review → @orchestrator

Pass all changed files. Correctness + integration check. Fix findings before shipping.

## 5. Ship

/test-writer if coverage gaps, then /ship.

## Rules

- Never skip @orchestrator planning
- No backend code without /tdd
- No UI without @frontend-designer
- Scope grows → pause, re-plan with @orchestrator
