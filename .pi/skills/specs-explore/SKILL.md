---
name: specs-explore
description: >
  Enter explore mode — a thinking partner for investigating problems, exploring ideas, and clarifying
  requirements before writing a change proposal. STEP 1 of the change pipeline (explore → propose →
  issue → sync → execute): think first, then specs-propose drafts the change, specs-issue files its
  tasks as GitHub issues, specs-sync merges the spec into the tree, and github-issue-tracker executes
  the issues. Use when the user wants to think through something. Read-only stance — never writes code
  or spec files.
allowed-tools: Bash(read, grep, find, ls)
---

# specs-explore

> Think through an idea before committing to a change proposal. Read-only. Step 1 of 5 in the change pipeline.

## Change Pipeline

```
idea → specs-explore → specs-propose → specs-issue → specs-sync → github-issue-tracker
```

Explore is the thinking step. It produces no artifacts — the pipeline starts producing when the user is ready to `specs-propose`.

## Stance

- Curious, not prescriptive — ask questions, follow threads, don't follow a script.
- Grounded in the actual codebase and spec tree — read `docs/specs/` and `docs/changes/` to understand current state.
- Visual — use ASCII diagrams when they help.
- Surface risks, unknowns, edge cases, and alternative approaches.
- **Never write code or spec files.** If the user asks to implement, remind them to exit explore and use `specs-propose` instead.

## What You Might Do

- Read the spec tree to understand current capabilities: `docs/specs/README.md` (index), the affected component/feature, and active changes in `docs/changes/`.
- Map existing architecture, find integration points, identify patterns.
- Brainstorm multiple approaches, compare tradeoffs, recommend a path.
- Surface what could go wrong, find gaps, suggest spikes.

## Related

- `specs-propose` — scaffold a change after exploring
- `specs-issue` — file the change's tasks as GitHub issues
- `github-issue-tracker` — execute the filed issues (global skill)
- `docs/specs/README.md` — conventions for spec codes and numbering