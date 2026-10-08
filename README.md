# <Project Name>

> <One-line description of the project>

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![CI](https://github.com/flintwillow-software/<repo>/actions/workflows/ci.yml/badge.svg)](https://github.com/flintwillow-software/<repo>/actions)

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
│   ├── adr/            # Architecture decision records (MADR-style, numbered)
│   └── ...             # Other durable documentation
├── .github/workflows/  # CI workflows
└── README.md           # You are here
```

## Design and Work Tracking

- **Design changes are recorded as ADRs** in `docs/adr/` (MADR-style, numbered). An accepted ADR is immutable — supersede it, don't edit it.
- **Work is tracked in Huly** (the workspace's canonical tracker). GitHub issues are public intake only.
- Durable design lives in the repo's `docs/`; work state lives in the tracker — never the other way around.

## Contributing

Please read [CONTRIBUTING.md](CONTRIBUTING.md) before opening a pull request.

## Links

- [Engineering Workspace](https://github.com/flintwillow-software/engineering-workspace)
