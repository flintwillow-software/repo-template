#!/usr/bin/env bash
# d3-validate.sh — Validate spec tree and change tree structure for CI (d3 workflow)
# Usage: d3-validate.sh [--root <repo-root>]  (or positional: d3-validate.sh <repo-root>)
# Exit code: 0 = valid, 1 = validation errors

set -euo pipefail

ROOT=""
if [ "${1:-}" = "--root" ]; then
  ROOT="${2:-.}"
else
  ROOT="${1:-.}"
fi
ROOT="$(realpath "$ROOT" 2>/dev/null || echo "$ROOT")"
ERRORS=0

# --- helpers ---
die()  { echo "ERROR: $*" >&2; ERRORS=$((ERRORS + 1)); }
info() { echo "  OK: $*"; }

# Read frontmatter spec-refs from a file and validate format
check_spec_refs() {
  local file="$1"
  local rel="$2"
  local line
  line=$(grep -m1 '^spec-refs:' "$file" 2>/dev/null || true)
  if [ -n "$line" ]; then
    # Extract array values between brackets
    local values
    values=$(echo "$line" | sed -n 's/^spec-refs:\s*\[\(.*\)\]/\1/p')
    if [ -n "$values" ]; then
      IFS=',' read -ra refs <<< "$values"
      for ref in "${refs[@]}"; do
        ref=$(echo "$ref" | xargs)  # trim
        if [[ ! "$ref" =~ ^[0-9]{6}$ ]]; then
          die "$rel: spec-ref entry '$ref' must be 6 digits (bare, no S prefix)"
        fi
      done
    fi
  fi
}

SPECS_DIR="$ROOT/docs/specs"
CHANGES_DIR="$ROOT/docs/changes"

echo "=== Validating spec tree ($SPECS_DIR) ==="

[ -d "$SPECS_DIR" ] || die "docs/specs/ directory not found"
[ -f "$SPECS_DIR/README.md" ] || die "docs/specs/README.md not found"

check_spec_refs "$SPECS_DIR/README.md" "docs/specs/README.md"

for comp in "$SPECS_DIR"/[0-9][0-9]-*/; do
  [ -d "$comp" ] || continue
  comp_name=$(basename "$comp")
  info "Component: $comp_name"

  [ -f "$comp/README.md" ] || die "$comp_name: missing README.md"
  check_spec_refs "$comp/README.md" "docs/specs/$comp_name/README.md"

  for feat in "$comp"/[0-9][0-9]-*.md; do
    [ -f "$feat" ] || continue
    feat_name=$(basename "$feat")
    [ "$feat_name" = "README.md" ] && continue
    info "  Feature: $feat_name"
    check_spec_refs "$feat" "docs/specs/$comp_name/$feat_name"
  done
done

# Check no unnumbered files
find "$SPECS_DIR" -name '*.md' -not -name 'README.md' | while read -r f; do
  rel="${f#$ROOT/}"
  base=$(basename "$f")
  if [[ ! "$base" =~ ^[0-9][0-9]- ]] && [ "$base" != "README.md" ]; then
    die "$rel: file name must start with NN- (two digits + hyphen)"
  fi
done

echo "=== Validating change tree ($CHANGES_DIR) ==="

[ -d "$CHANGES_DIR" ] || die "docs/changes/ directory not found"
[ -f "$CHANGES_DIR/README.md" ] || die "docs/changes/README.md not found"

# Track S-codes per version for uniqueness
declare -A S_CODES_PER_VER

for ver in "$CHANGES_DIR"/[0-9]*/; do
  [ -d "$ver" ] || continue
  ver_name=$(basename "$ver")

  if [[ ! "$ver_name" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    die "$ver_name: version directory must be semver (X.Y.Z)"
    continue
  fi
  info "Version: $ver_name"

  # Per-version S-code tracking
  VER_SCODES=""

  for change in "$ver"*/; do
    [ -d "$change" ] || continue
    change_name=$(basename "$change")
    change_path="${ver_name}/${change_name}"

    # Validate folder name format
    if [[ ! "$change_name" =~ ^[0-9][0-9]-[a-z0-9-]+-S[0-9]{6}$ ]]; then
      die "$change_path: folder name must be NN-<kebab>-S<6digits>"
    fi

    # Extract S-code (display form) and check per-version uniqueness
    s_code=$(echo "$change_name" | grep -oP 'S[0-9]{6}')
    if echo "$VER_SCODES" | grep -q "$s_code"; then
      die "$change_path: duplicate S-code $s_code in version $ver_name"
    fi
    VER_SCODES="$VER_SCODES $s_code"

    # Check required files
    [ -f "$change/proposal.md" ] || die "$change_path: missing proposal.md"
    [ -f "$change/design.md" ]   || die "$change_path: missing design.md"
    [ -f "$change/tasks.md" ]    || die "$change_path: missing tasks.md"
    [ -d "$change/specs" ]       || die "$change_path: missing specs/ directory"

    # Validate frontmatter spec-refs in change files
    for cf in proposal.md design.md tasks.md; do
      [ -f "$change/$cf" ] && check_spec_refs "$change/$cf" "$change_path/$cf"
    done

    info "  Change: $change_name"

    # Validate that future-state specs mirror valid paths
    find "$change/specs" -name '*.md' -not -name 'README.md' | while read -r spec_future; do
      rel_path="${spec_future#$change/specs/}"
      if [[ ! "$rel_path" =~ .*/[0-9][0-9]-.*\.md$ ]]; then
        die "$change_path/specs/$rel_path: future-state spec path must mirror docs/specs/ structure"
      fi
    done
  done
done

echo "=== Summary ==="
if [ $ERRORS -eq 0 ]; then
  echo "  All checks passed."
  exit 0
else
  echo "  $ERRORS error(s) found."
  exit 1
fi