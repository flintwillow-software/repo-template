# <Project Name>

> <One-line description of the project>

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![CI](https://github.com/flintwillow-software/<repo>/actions/workflows/ci.yml/badge.svg)](https://github.com/flintwillow-software/<repo>/actions)
[![Specs](https://github.com/flintwillow-software/<repo>/actions/workflows/specs-validate.yml/badge.svg)](https://github.com/flintwillow-software/<repo>/actions/workflows/specs-validate.yml)

## Overview

<!-- Brief description of what this project does and why it exists -->

## Quick Start

```bash
# Clone and setup
git clone git@github.com:flintwillow-software/<repo>.git
cd <repo>
# ... setup steps ...
```

## Development

```bash
# Run tests
npm test

# Lint
npm run lint

# Build
npm run build
```

## Structure

```
<repo>/
├── src/                # Source code
├── tests/              # Test files
├── docs/
│   ├── specs/          # Ordered specification tree (numbered, hierarchical)
│   ├── changes/        # Versioned change proposals (semver + S-codes)
│   ├── templates/      # Spec-tree and change skeletons (copy-on-use)
│   └── ...             # Other documentation
├── .pi/skills/         # specs-* skills (loaded by pi when the repo is trusted)
├── scripts/            # Automation scripts (incl. specs-validate.sh)
├── .github/workflows/  # CI workflows (incl. specs-validate.yml)
└── README.md           # You are here
```

## Spec-Driven Development

This repo uses an ordered specification framework:

- **`docs/specs/`** — numbered spec tree (`000000` = `component.feature.subfeature` flattened). Requirements use SHALL + GIVEN/WHEN/THEN/AND scenarios.
- **`docs/changes/`** — versioned change proposals. Each change is a folder `NN-<name>-S<code>` under a semver directory, containing proposal, design, tasks, and future-state spec copies.
- **Cycle**: propose → design → tasks → implement → sync → tag. Changes are the atomic unit of traceability from idea to versioned release.
- **Skills**: 11 skills ship in `.pi/skills/` (pi loads them once the repo is trusted): the 8 `specs-*` lifecycle skills (explore, propose, apply, sync, index, render, renumber, status) plus `commit`, `pr-create`, and `pr-update` for conventional commit/PR workflows.
- **CI**: `scripts/specs-validate.sh` runs on every PR touching `docs/specs/` or `docs/changes/` (validates numbering, semver dirs, S-code uniqueness, frontmatter format).

See [`docs/specs/README.md`](docs/specs/README.md) for conventions and [`docs/changes/README.md`](docs/changes/README.md) for the active change tracker.

## Scripts

- `scripts/specs-validate.sh` — CI validator for the spec/change tree structure.
- `scripts/sync-skills.sh` — sync the `.pi/skills/specs-*` skills from this template into target repos (`--all` syncs every repo in `.gitmodules`, `--full <repo>` also copies docs skeletons where missing, `--check` dry-runs).

## Contributing

Please read [CONTRIBUTING.md](CONTRIBUTING.md) before opening a pull request.

## Links

- [Engineering Workspace](https://github.com/flintwillow-software/engineering-workspace)
- [Conventions](https://github.com/flintwillow-software/engineering-workspace/blob/main/docs/conventions.md)
- [Spec Conventions](docs/specs/README.md)
