---
name: specs-apply
description: >
  Execute a change's tasks directly — the direct-execution path for a change proposal. Reads the
  change's tasks.md and executes each task in order, verifying against the specs/ future-state copies.
  STEP 5 alternative in the change pipeline (explore → propose → issue → sync → execute): for tracked
  work the preferred path is specs-issue (file tasks.md as GitHub issues) + github-issue-tracker
  (execute issues); use specs-apply only for quick changes that don't need issue tracking. After
  execution, specs-sync merges the change into the spec tree. NOTE: this skill EXECUTES CODE tasks —
  for documentation-only spec updates (no code), edit docs/specs/ directly instead (see specs-propose).
allowed-tools: Bash(all)
---

# specs-apply

> Execute a change's task list, building the feature according to the spec. Direct-execution path — for issue-tracked work, prefer specs-issue + github-issue-tracker.
>
> **Not for doc-only spec updates.** This skill runs CODE tasks (implement the feature). If the
> change is pure spec/document content with no code, edit `docs/specs/` in place instead — no change
> dir, no apply step.

## Change Pipeline

```
idea → specs-explore → specs-propose → specs-issue → specs-sync → github-issue-tracker
```

Apply sits at the execution step, bypassing issue filing. Prefer the issue path (`specs-issue` → `github-issue-tracker`) whenever the work should be visible on a project board; use this skill for small, direct changes. Either way, finish with `specs-sync` to merge the spec content into the tree.

## Steps

### 1. Identify the change

- The user specifies which change to apply, or you read `docs/changes/README.md` for the next unapplied change.
- A change path: `docs/changes/<version>/<NN>-<kebab>-S<code>/`

### 2. Read the change artifacts

- `proposal.md` — why, what, out of scope, spec impact
- `design.md` — technical approach, decisions
- `tasks.md` — numbered checklist 1.1, 1.2, …
- `specs/` — future-state copies of affected spec files (the target state)

### 3. Execute tasks in order

- Implement each task (`1.1`, `1.2`, `2.1`…) in sequence.
- Verify implementation against the future-state `specs/` files — the behavior should match the amended spec.
- Update `CHANGELOG.md` under `Unreleased` as you go.

### 4. Verify

- Run the test suite, resolve regressions.
- Confirm the implementation matches the spec by reading the future-state files against the code.

## Related

- `specs-issue` — file the change's tasks as GitHub issues (preferred for tracked work)
- `github-issue-tracker` — execute the filed issues (global skill)
- `specs-sync` — merge the applied change into the spec tree after completion
- `specs-propose` — scaffold the change before applying