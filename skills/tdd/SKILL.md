---
name: tdd
description: Test-Driven Development loop — write a failing test first, then the minimum code to pass it, then refactor. Repeat.
argument-hint: "[feature description or function signature]"
disable-model-invocation: true
---

Build the following using strict Test-Driven Development:

**Feature**: $ARGUMENTS

Repeat this cycle for each behavior. Never skip steps.

---

## 🔴 Red: Write a Failing Test

1. Write ONE test for the smallest next behavior
2. Name it clearly: `should return 0 for empty cart`
3. Use Arrange-Act-Assert. Assert specific values.
4. **Run it. It MUST fail.** Passes? Either behavior exists (move on) or test is wrong (fix it).
5. Confirm the failure message tells you what's missing.

---

## 🟢 Green: Write Minimum Code to Pass

1. Write the **simplest code** that makes the test pass — no more.
2. Hardcoding is fine if only one test covers that path.
3. **Run it. It MUST pass.** Fails? Fix the code, not the test.
4. Run ALL tests. Nothing previously passing should break.

---

## 🔵 Refactor: Clean Up Without Changing Behavior

1. Fix: duplication, unclear names, magic values, bloated functions.
2. One improvement at a time.
3. **Run ALL tests after each change.** Anything breaks? Undo.
4. Stop when clean — don't over-engineer.

---

## What to Test Next

Simple → complex:
1. Degenerate cases (null, empty, zero)
2. Happy path
3. Variations (different valid inputs)
4. Edge cases (boundaries, limits)
5. Error cases (invalid input, failures)
6. Integration

Each test should require ~10 lines of production code max. More? Split the test.

## Rules

- No production code without a failing test.
- One failing test at a time.
- Hard to test = bad design. Fix the design, not the test approach.
- Don't mock what you own.
- Commit after each 🟢 + 🔵 cycle.

## After Each Cycle

State briefly:
- **🔴 Test**: what behavior was added
- **🟢 Code**: what changed
- **🔵 Refactor**: what was cleaned up (or "none")

When done, summarize all behaviors covered and any gaps needing integration or manual testing.
