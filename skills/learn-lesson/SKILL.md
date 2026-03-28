---
name: learn-lesson
description: After any mistake — classify it, then record it if likely to recur.
disable-model-invocation: true
---

Analyze the mistake just made.

## Step 1: Classify

**Recurring** — wrong assumption about codebase, misunderstood convention, repeated error pattern, architectural misconception. Note it without asking.

**One-off** — typo, misread file, context confusion unlikely to repeat. Ask: "One-off mistake — note it as a lesson anyway? (yes/no)"

## Step 2: Write the Lesson

If noting: append one bullet to `.claude/rules/lessons.md`. Create with `alwaysApply: true` frontmatter if it doesn't exist.

Format — lead with the rule, not the story:
- Bad: "I tried X but the project uses Y"
- Good: "Project uses Y — never assume X"

One sentence. No hedging.
