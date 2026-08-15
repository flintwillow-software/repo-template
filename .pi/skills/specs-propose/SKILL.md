---
name: specs-propose
description: >
  Scaffold a new versioned change proposal. Creates the change directory under
  docs/changes/<version>/<NN>-<kebab>-S<code>/ with proposal.md, design.md, tasks.md (the change's
  implementation task list), and specs/ future-state copies of the affected spec files. STEP 2 of the
  change pipeline (explore → propose → issue → sync → execute): after proposing, specs-issue files
  tasks.md as GitHub issues, specs-sync merges the spec content into the tree, and github-issue-tracker
  executes the issues. The proposal is an intermediate artifact — the spec content and task list are
  the deliverables. Use when the user wants to make a spec change.
allowed-tools: Bash(read, grep, find, ls, mkdir, cp, mv)
---

# specs-propose

> Scaffold a new change proposal. The atomic unit of traceability from idea to versioned release.

## When to use this skill — vs. direct spec edits

**Direct spec update (docs work):** when the user says "update the specs", "fix the spec", or wants
spec content changed with no code to implement, edit `docs/specs/` in place — feature files, component
READMEs, and the tree root `docs/specs/README.md`. Update Status History on each touched file. Record
the change in `docs/changes/README.md` (Active Changes or a version note). **No change dir, no
proposal/design/tasks, no issue filing.** The spec tree is the deliverable.

**Change pipeline (tracked implementation):** when the change produces CODE that will be filed as
GitHub issues and executed via the tracker (specs-issue → github-issue-tracker), scaffold the change
dir with this skill, then sync into the tree with specs-sync.

> Rule of thumb: if the change is spec-only (documentation), edit the tree directly. If the change
> has implementation tasks that need issue tracking, use the propose → issue → sync → execute pipeline.

## Change Pipeline

```
idea → specs-explore → specs-propose → specs-issue → specs-sync → github-issue-tracker
```

Propose produces the change dir: `specs/` (future-state spec content, the spec update) and `tasks.md` (the change list). It does NOT implement anything — implementation is filed as issues (`specs-issue`) and executed through the tracker. Continue the pipeline after this step; do not stop here.

## Spec Code Convention

Spec codes are 6 digits = `component.feature.subfeature` flattened (`00.01.00` → `000100`). Bare in frontmatter (`spec-refs: [000000]`), `S`-prefixed in display and folder names (`S000000`). Unique within a version directory.

## Steps

### 1. Determine the target version

- Read `docs/changes/README.md` for the current active version.
- If no active version exists, use the next semver bump from the latest git tag (or `0.0.0` if none).
- If changes already exist in a version dir, use that version.

### 2. Determine the primary spec code and folder name

- Read `docs/specs/README.md` to find the next available component/feature/subfeature slot.
- The primary spec code is the first subfeature this change creates or modifies.
- The folder name: `<NN>-<kebab-name>-S<primary-code>` — NN is the next number in the version (00, 01, …), kebab name is a short descriptive slug.

### 3. Scaffold the change directory

```bash
mkdir -p docs/changes/<version>/<NN>-<kebab>-S<code>/{specs/}
```

### 4. Copy template files

```bash
cp docs/templates/change/proposal.md docs/changes/<version>/<NN>-<kebab>-S<code>/proposal.md
cp docs/templates/change/design.md   docs/changes/<version>/<NN>-<kebab>-S<code>/design.md
cp docs/templates/change/tasks.md    docs/changes/<version>/<NN>-<kebab>-S<code>/tasks.md
```

### 5. Fill proposal.md

- `s-code`: the primary spec code with S prefix (matches folder name)
- `version`: the target version directory
- `spec-refs`: array of all spec codes this change touches (bare 6-digit form)
- Why / What Changes / Out of Scope / Spec Impact table

### 6. Populate specs/ with future-state copies

For each affected spec file, copy it from `docs/specs/` into the same path under `specs/`, then apply the amendment. The file must be the **complete future state** — no delta markers.

```bash
mkdir -p docs/changes/<version>/<NN>-<kebab>-S<code>/specs/NN-component
cp docs/specs/NN-component/NN-feature.md docs/changes/<version>/<NN>-<kebab>-S<code>/specs/NN-component/NN-feature.md
# Then edit the copy to add/modify/remove subfeatures
```

### 7. Update `docs/changes/README.md` tracker

Add an entry to the Active Changes table.

## Related

- `specs-explore` — think through the idea first
- `specs-issue` — NEXT STEP: file tasks.md as GitHub issues
- `specs-sync` — merge the change's spec content into the tree
- `specs-apply` — direct execution of tasks.md (alternative to the issue path)
- `github-issue-tracker` — execute the filed issues (global skill)
- `docs/specs/README.md` — full conventions
- `docs/templates/change/` — template files