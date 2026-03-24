#!/usr/bin/env bash
# jj-lint - Create a formatting-only "lint" change for lines touched in a revset
# Usage: jj lint [REVSET]   (default: @)

set -euo pipefail

REVSET="${1:-@}"

# Run from repo root so file paths resolve and .clang-format is found
ROOT=$(jj workspace root 2>/dev/null) || { echo "Not in a jj workspace"; exit 1; }
cd "$ROOT"

# Get the unified diff for the revset in git format
echo "[lint] getting diff for revset: $REVSET"
DIFF=$(jj diff --git -r "$REVSET")
echo "[lint] diff size: ${#DIFF} bytes"

if [[ -z "$DIFF" ]]; then
    echo "[lint] no changes in revset"
    exit 0
fi

# Dry-run: pipe through clang-format-diff to see if any lines need reformatting
echo "[lint] running clang-format-diff..."
FORMAT_DIFF=$(echo "$DIFF" | clang-format-diff.py -p1 2>&1) && RC=0 || RC=$?
echo "[lint] clang-format-diff exit code: $RC"
echo "[lint] format diff size: ${#FORMAT_DIFF} bytes"
echo "[lint] output: $FORMAT_DIFF"

if [[ -z "$FORMAT_DIFF" ]]; then
    echo "[lint] all changed lines already formatted"
    exit 0
fi

echo "$FORMAT_DIFF"

# Create a new child change, then apply fixes in-place
jj new -m "lint"
echo "$DIFF" | clang-format-diff.py -p1 -i

echo "Done — 'jj squash' to absorb or 'jj rebase' to move it."
