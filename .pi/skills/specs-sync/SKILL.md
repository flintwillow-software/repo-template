---
name: specs-sync
description: >
  Merge a completed change into the spec tree. Copies the change's specs/ future-state files into
  docs/specs/, appends spec codes to feature file frontmatter, updates Status History, regenerates
  the index, deletes the change directory, and writes a commit message from the proposal. STEP 4 of
  the change pipeline (explore → propose → issue → sync → execute). For tracked changes this runs
  AFTER specs-issue has filed the change's tasks as GitHub issues (sync deletes the change dir,
  which is the source for filing); for documentation-only changes the change dir may be deleted
  directly without issue filing. Execution of the filed issues happens via github-issue-tracker.
allowed-tools: Bash(cp, rm, mv, mkdir, grep, sed, find, git)
---

# specs-sync

> Merge a completed change into the spec tree, then delete the change dir. Git history is the permanent record — no archive.

## Change Pipeline

```
idea → specs-explore → specs-propose → specs-issue → specs-sync → github-issue-tracker
```

Sync is the spec-side completion step: the change's spec content lands in the tree. The implementation work lives on the issue tracker — sync does not implement anything.

> **Documentation-only changes:** if the change has no code to implement (pure spec/document work),
> the issue-filing gate below does NOT apply — delete the change dir after sync without filing
> GitHub issues. The issue-filing requirement exists only when the change's tasks need tracker
> execution.

## Steps

### 1. Read the change's proposal.md

- `s-code` — primary spec code (display form, e.g. `S000000`)
- `spec-refs` — all spec codes touched (bare form, e.g. `[000000, 000100]`)
- The Why section — becomes the commit message body

### 2. Copy future-state specs into the tree

For each file in `docs/changes/<version>/<NN>-<kebab>-S<code>/specs/`:

```bash
cp docs/changes/<version>/<NN>-<kebab>-S<code>/specs/NN-component/NN-feature.md \
   docs/specs/NN-component/NN-feature.md
```

### 3. Update spec file frontmatter

For each affected spec file, append any new subfeature codes to the `spec-refs` frontmatter array. For example, if the file previously had `spec-refs: [000000, 000001]` and the change adds subfeature 02, update to `spec-refs: [000000, 000001, 000002]`. **Append only** — never remove codes.

### 4. Update Status History

Add a row to each affected feature file's Status History table:

```markdown
| YYYY-MM-DD | S000000 | 0.1.0 | Added 000002, modified 000001 |
```

### 5. Regenerate the spec tree index

Call `specs-index` to regenerate `docs/specs/README.md`.

### 6. Update the change tracker

Add the change to the Completed Versions table in `docs/changes/README.md`. Remove from Active Changes.

### 7. Delete the change directory

- **Tracked change (has implementation tasks):** delete ONLY after its tasks have been filed as GitHub issues via `specs-issue` (the change dir holds tasks.md, the source for filing). If issues have not been filed yet, run `specs-issue` first or leave the change dir in place and flag it.
- **Documentation-only change (no code to implement):** delete directly — no issue filing needed.

```bash
rm -rf docs/changes/<version>/<NN>-<kebab>-S<code>
```

### 8. Write the commit message

```text
<version>: <change title>

<Proposal's Why section>

Spec refs: [000000, 000100]
S-code: S000000
```

### 9. Tag on version completion

If the version directory is now empty (all changes synced), `git tag v<version>`.

## Related

- `specs-issue` — file the change's tasks as GitHub issues BEFORE sync deletes the change dir
- `specs-apply` — direct execution of the change's tasks (alternative to the issue path)
- `github-issue-tracker` — execute the filed issues (global skill)
- `specs-index` — regenerate the spec tree index