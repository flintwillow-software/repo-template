# AGENTS.md

## Project Overview

This is a **repo scaffolding template** from the Engineering Workspace. New repositories should be created by copying this template and customizing it for the target project.

## Template Structure

```
repo-template/
├── README.md                           ← Project overview (uses <placeholder> syntax)
├── CONTRIBUTING.md                     ← Contribution guidelines
├── CHANGELOG.md                        ← Keep a Changelog format
├── .github/
│   └── PULL_REQUEST_TEMPLATE.md       ← PR template with type dropdown
└── AGENTS.md                           ← You are here
```

### README.md

Uses `<placeholder>` syntax for project-specific values:
- `<Project Name>` — title
- `<repo>` — repository name
- `flintwillow-software/<repo>` — GitHub path
- `<One-line description>` — project summary

### CONTRIBUTING.md

Covers the basics: fork/clone workflow, conventional commits, PR requirements, and code standards.

### CHANGELOG.md

Follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) format with semantic versioning.

### PULL_REQUEST_TEMPLATE.md

Includes a type dropdown (bug, feature, refactor, etc.), related issue link, testing checklist, and screenshots section.

## Design and Work Tracking

- **Design changes are recorded as ADRs** in the repo's `docs/adr/` (MADR-style, numbered). An accepted ADR is immutable — supersede it, don't edit it.
- **Work is tracked in Huly** (the workspace's canonical tracker). GitHub issues are public intake only.
- Durable design lives in the repo's `docs/`; work state lives in the tracker — never the other way around.

## Documentation Priority

**Always look in `docs/` first for conventions, standards, and how-to guides.**

## Commit Conventions

Use [Conventional Commits](https://www.conventionalcommits.org/):

```
feat: add new feature
fix: resolve bug #123
docs: update README
chore: update dependencies
refactor: restructure module
test: add unit tests
```

## AI Agent Guidelines

- Always check `docs/` before answering workflow or convention questions
- For workspace-wide conventions, check the parent `engineering-workspace/`
- When scaffolding a new repo, copy this template and replace `<placeholder>` values
