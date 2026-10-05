#!/usr/bin/env bash
set -Eeuo pipefail

LAB_ROOT="${LAB_ROOT:-/workspaces/mali_lab}"
KERNEL_VERSION="${KERNEL_VERSION:-6.6}"

cd "$LAB_ROOT"

echo "============================================================"
echo "Mali Kbase Lab Status"
echo "============================================================"
echo "Workspace: ${LAB_ROOT}"
echo "Kernel:    ${KERNEL_VERSION}"
echo

check() {
    local label="$1"
    local path="$2"
    if [[ -e "$path" ]]; then
        printf '[OK]   %-24s %s\n' "$label" "$path"
    else
        printf '[MISS] %-24s %s\n' "$label" "$path"
    fi
}

check "kernel source" "kernel/${KERNEL_VERSION}/src"
check "kernel artifacts" "kernel/${KERNEL_VERSION}/artifacts"
check "vmlinux" "kernel/${KERNEL_VERSION}/artifacts/vmlinux"
check "driver artifacts" "driver/artifacts"
check "QEMU boot script" "qemu/boot_kernel_gdb.sh"
check "rootfs" "rootfs"

if command -v opencode >/dev/null 2>&1; then
    printf '[OK]   %-24s %s\n' "OpenCode" "$(command -v opencode)"
else
    printf '[MISS] %-24s %s\n' "OpenCode" "not in PATH"
fi

if command -v qemu-system-x86_64 >/dev/null 2>&1; then
    printf '[OK]   %-24s %s\n' "QEMU" "$(command -v qemu-system-x86_64)"
else
    printf '[MISS] %-24s %s\n' "QEMU" "not in PATH"
fi

if command -v gdb >/dev/null 2>&1; then
    printf '[OK]   %-24s %s\n' "GDB" "$(command -v gdb)"
else
    printf '[MISS] %-24s %s\n' "GDB" "not in PATH"
fi
