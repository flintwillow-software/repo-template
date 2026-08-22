#!/usr/bin/env bash
# sync-skills.sh — Sync the d3-* skills (and optionally the spec framework skeletons) from a
# repo template into target repos.
#
# Usage:
#   sync-skills.sh <repo-dir>...       Sync skills into the given repo directories
#   sync-skills.sh --all               Sync into every repo listed in .gitmodules (repos/ + infra/)
#   sync-skills.sh --full <repo-dir>   Also copy docs/specs, docs/changes, docs/templates skeletons
#                                      into the repo (only where missing — never clobbers)
#   sync-skills.sh --check --all       Dry run — print what would change without touching anything
#
# Examples (from the engineering-workspace root):
#   templates/repo-template/scripts/sync-skills.sh --full repos/bard
#   templates/repo-template/scripts/sync-skills.sh --check --all
#   templates/repo-template/scripts/sync-skills.sh --all

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
SKILLS_SRC="$TEMPLATE_DIR/.pi/skills"
DOCS_SKELETONS=(
  "docs/specs/README.md"
  "docs/changes/README.md"
  "docs/templates/spec-tree"
  "docs/templates/change"
)

MODE="sync"
FULL=false
TARGETS=()

repos_from_gitmodules() {
  local gmf=".gitmodules"
  [ -f "$gmf" ] || return 0
  grep -E '^\s*path\s*=' "$gmf" | sed -E 's/^\s*path\s*=\s*//' | grep -E '^(repos|infra)/' || true
}

usage() {
  head -14 "${BASH_SOURCE[0]}" | sed 's/^#!/  /'
  exit 0
}

while [ $# -gt 0 ]; do
  case "$1" in
    --all)     TARGETS=($(repos_from_gitmodules));;
    --full)    FULL=true;;
    --check)   MODE="check";;
    -h|--help) usage;;
    *)         TARGETS+=("$1");;
  esac
  shift
done

[ ${#TARGETS[@]} -eq 0 ] && {
  echo "No targets specified. Use --all or list repo directories."
  echo "Run --help for usage."
  exit 1
}

touch_() {
  local sname dst
  sname=$(basename "$1")
  dst="$2"
  if [ "$MODE" = "check" ]; then
    echo "  would sync skill: $sname"
  else
    mkdir -p "$(dirname "$dst")"
    rm -rf "$dst"
    cp -r "$1" "$dst"
    echo "  synced skill: $sname"
  fi
}

copy_skel() {
  local src="$1" dst="$2" label="$3"
  if [ -e "$dst" ]; then
    echo "  kept existing: $label"
  elif [ "$MODE" = "check" ]; then
    echo "  would copy: $label"
  else
    mkdir -p "$(dirname "$dst")"
    cp -r "$src" "$dst"
    echo "  copied: $label"
  fi
}

SUMMARY_GOOD=0
SUMMARY_SKIP=0

for target in "${TARGETS[@]}"; do
  [ -d "$target" ] || { echo "SKIP: $target (not found)"; SUMMARY_SKIP=$((SUMMARY_SKIP + 1)); continue; }
  name=$(basename "$target")
  echo "== $name ($target) =="

  # Skills
  if [ -d "$SKILLS_SRC" ]; then
    for skill_dir in "$SKILLS_SRC"/*/; do
      [ -d "$skill_dir" ] || continue
      sname=$(basename "$skill_dir")
      touch_ "$skill_dir" "$target/.pi/skills/$sname"
    done
  fi

  # Docs skeletons (--full only)
  if [ "$FULL" = true ]; then
    for skel in "${DOCS_SKELETONS[@]}"; do
      copy_skel "$TEMPLATE_DIR/$skel" "$target/$skel" "$skel"
    done
  fi

  SUMMARY_GOOD=$((SUMMARY_GOOD + 1))
done

echo "=== Done ==="
echo "  Repos processed: $SUMMARY_GOOD"
echo "  Repos skipped:   $SUMMARY_SKIP"
echo "  Mode:            $MODE"
if [ "$MODE" = "check" ]; then
  echo "  (dry run — no files changed)"
fi
exit 0