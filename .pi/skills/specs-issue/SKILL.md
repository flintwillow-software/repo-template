---
name: specs-issue
description: >
  File a change's task list as actionable GitHub issues. Reads the change's tasks.md (and proposal.md)
  from docs/changes/<version>/<NN>-<kebab>-S<code>/, creates an Epic per change plus one Task/Feature
  issue per task item, links them as sub-issues, and adds them to the project board in Ready status.
  STEP 3 of the change pipeline (explore → propose → issue → sync → execute): run AFTER specs-propose
  and BEFORE specs-sync (which deletes the change dir). Execution of the filed issues happens via
  github-issue-tracker. Use when a proposed spec change needs its implementation work tracked.
  NOTE: only for changes with code to implement — documentation-only spec updates skip this skill
  entirely (edit docs/specs/ directly, see specs-propose).
allowed-tools: Bash(read, grep, find, ls, mkdir, sed, gh)
---

# specs-issue

> Turn a change's tasks into GitHub issues — the bridge between the spec tree and the issue tracker. STEP 3 of the change pipeline.
>
> **Only for tracked changes with code to implement.** If the change is documentation-only (spec
> content with no code), do NOT file issues — edit `docs/specs/` directly instead (see specs-propose).

## Change Pipeline

```
idea → specs-explore → specs-propose → specs-issue → specs-sync → github-issue-tracker
```

Propose drafts the change (specs/ future-state + tasks.md). Issue files the task list as GitHub
issues on the target repo's project board. Sync then merges the spec content into the tree and
deletes the change dir. Execution of the issues is handled by the global `github-issue-tracker`
skill (Ready → In Progress → In Review → Done).

## Prerequisites

- `gh` authenticated with `project` + `read:org` scopes: `gh auth status` / `gh auth refresh -s project,read:org`
- The target repo is a GitHub repo under the workspace org (e.g. `flintwillow-software/opennavi`)
- Follow the global `github-project-manager` skill conventions: discover the project board and its
  Status/Issue-Type fields first; org-level issue types must exist (Epic, Task, Feature) before creating typed issues

## Steps

### 1. Identify the change

- The user specifies a change dir, or read `docs/changes/README.md` for the next proposed change.
- Path: `docs/changes/<version>/<NN>-<kebab>-S<code>/`

### 2. Read the change artifacts

- `proposal.md` — why, what, spec impact, `s-code`, `spec-refs`
- `tasks.md` — the numbered task list (sections group related work; items are atomic)
- `specs/` — future-state spec files (context for issue bodies)

### 3. Discover the project board

Per `github-project-manager` conventions:

```bash
# Find the project for the repo's issues (org-scoped: --owner flintwillow-software)
gh project list --owner flintwillow-software --format json | jq -r '.[] | "\(.number) | \(.title)"'

# Get the Status field and option IDs (for setting Ready)
gh project field-list <project-number> --owner flintwillow-software --format json | jq '
  .[] | select(.name == "Status") | {id: .id, options: [.single_select_options[] | {name, id}]}'
```

### 4. Create the Epic

One Epic per change, typed per org issue types:

```bash
gh issue create --repo flintwillow-software/<repo> \
  --title "Spec <s-code>: <change name>" \
  --type Epic \
  --body "$(cat <<'EOF'
## Goal
<from proposal.md Why>

## Scope
<from proposal.md What Changes / Out of Scope>

## Acceptance
<from proposal.md Success Criteria>

Spec refs: <spec-refs>
Change: docs/changes/<version>/<NN>-<kebab>-S<code>/
EOF
)"
```

### 5. Create Task issues per task item

For each numbered task item in `tasks.md` (1.1, 1.2, 2.1, …), create a Task-type issue in the
same repo. Title format per `github-project-manager`: `Implement <component>` / `Document <topic>`.
Body: description + acceptance criteria from the task item, plus a link to the Epic and the spec codes.

### 6. Link tasks to the Epic

Use GraphQL sub-issues (node_ids, `GraphQL-Features: sub_issues` header) per `github-project-manager`:

```bash
EPIC_NODE=$(gh api repos/flintwillow-software/<repo>/issues/<epic_num> --jq '.node_id')
TASK_NODE=$(gh api repos/flintwillow-software/<repo>/issues/<task_num> --jq '.node_id')
gh api graphql -H "GraphQL-Features: sub_issues" \
  -f query="mutation { addSubIssue(input: { issueId: \"$EPIC_NODE\", subIssueId: \"$TASK_NODE\" }) { issue { title } } }"
```

Verify with `subIssues { totalCount }` after each link.

### 7. Add to the project board (Ready)

Org-scoped projects: `gh project item-add` after creation (the `--project` flag on `gh issue create`
does not work for org projects):

```bash
gh project item-add <project-number> --owner flintwillow-software \
  --url "https://github.com/flintwillow-software/<repo>/issues/<num>"
```

Then set Status → Ready via `gh project item-edit` with the Status field + Ready option IDs.

### 8. Update the change tracker

- Note the issue numbers in the change's `proposal.md` (or a `docs/changes/README.md` note) so the
  issue → change traceability chain holds (spec code → change folder → issues → version tag).
- Leave the change dir in place — `specs-sync` consumes it next.

## Verification

- [ ] One Epic + N Task issues created, all typed (Epic/Task), titles per naming conventions
- [ ] Sub-issue links verified (`subIssues.totalCount` on the Epic)
- [ ] All issues present on the project board in Ready status
- [ ] Issue bodies reference the spec codes and change path
- [ ] No `fleet` terminology (the workspace uses `team`)

## Related

- `specs-propose` — previous step: scaffold the change (produces tasks.md)
- `specs-sync` — next step: merge the change's spec content into the tree
- `github-issue-tracker` — execute the filed issues (global skill)
- `github-project-manager` — project board administration (global skill)
