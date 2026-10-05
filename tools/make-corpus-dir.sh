#!/usr/bin/env bash
set -Eeuo pipefail

LAB_ROOT="${LAB_ROOT:-/workspaces/mali_lab}"

mkdir -p \
    "${LAB_ROOT}/artifacts/corpus/seed" \
    "${LAB_ROOT}/artifacts/corpus/mutated" \
    "${LAB_ROOT}/artifacts/crashes" \
    "${LAB_ROOT}/artifacts/repros" \
    "${LAB_ROOT}/artifacts/triage"

echo "Corpus directories created."
