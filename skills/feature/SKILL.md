---
name: feature
description: Build a new feature — plan with @orchestrator, /tdd for backend, @frontend-designer for UI, @orchestrator review before ship
argument-hint: "[feature description]"
disable-model-invocation: true
---

Feature: **$ARGUMENTS**

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
