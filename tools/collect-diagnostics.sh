#!/usr/bin/env bash
set -Eeuo pipefail

LAB_ROOT="${LAB_ROOT:-/workspaces/mali_lab}"
KERNEL_VERSION="${KERNEL_VERSION:-6.6}"
OUT="${1:-${LAB_ROOT}/logs/diagnostics-${KERNEL_VERSION}-$(date +%Y%m%d-%H%M%S)}"

mkdir -p "$OUT"

cd "$LAB_ROOT"

{
    echo "date=$(date --iso-8601=seconds)"
    echo "kernel_version=${KERNEL_VERSION}"
    echo "lab_root=${LAB_ROOT}"
    echo
    uname -a
} > "${OUT}/host.txt"

if [[ -f "kernel/${KERNEL_VERSION}/artifacts/vmlinux" ]]; then
    file "kernel/${KERNEL_VERSION}/artifacts/vmlinux" \
        > "${OUT}/vmlinux-file.txt" 2>&1 || true
fi

if [[ -f "kernel/${KERNEL_VERSION}/artifacts/kernel-config" ]]; then
    cp "kernel/${KERNEL_VERSION}/artifacts/kernel-config" \
       "${OUT}/kernel-config" || true
fi

find logs -maxdepth 2 -type f -print \
    > "${OUT}/log-index.txt" 2>/dev/null || true

echo "Diagnostics collected in: ${OUT}"
