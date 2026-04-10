#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RUNNER="$SCRIPT_DIR/run_opencode_consult.sh"
DEFAULT_OPENCODE_BIN="$HOME/.opencode/bin/opencode"
OPENCODE_BIN="${OPENCODE_BIN:-}"

if [[ -z "$OPENCODE_BIN" ]]; then
  if command -v opencode >/dev/null 2>&1; then
    OPENCODE_BIN="$(command -v opencode)"
  else
    OPENCODE_BIN="$DEFAULT_OPENCODE_BIN"
  fi
fi

echo "Checking repository files..."
[[ -f "$RUNNER" ]] || { echo "Missing runner: $RUNNER" >&2; exit 1; }
[[ -f "$SCRIPT_DIR/../SKILL.md" ]] || { echo "Missing SKILL.md" >&2; exit 1; }

echo "Checking dependencies..."
command -v bash >/dev/null 2>&1 || { echo "bash is required" >&2; exit 1; }
command -v jq >/dev/null 2>&1 || { echo "jq is required" >&2; exit 1; }
[[ -x "$OPENCODE_BIN" ]] || {
  echo "opencode executable not found: $OPENCODE_BIN" >&2
  echo "Set OPENCODE_BIN or add opencode to PATH." >&2
  exit 1
}

echo "Checking runner help output..."
bash "$RUNNER" --help >/dev/null

echo "Self-check passed."
