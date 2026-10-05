#!/usr/bin/env bash
set -Eeuo pipefail

LAB_ROOT="${LAB_ROOT:-/workspaces/mali_lab}"
KERNEL_VERSION="${KERNEL_VERSION:-6.6}"

cd "$LAB_ROOT"

if [[ -d "${HOME}/.opencode/bin" ]]; then
    export PATH="${HOME}/.opencode/bin:${PATH}"
fi

command -v opencode >/dev/null 2>&1 || {
    echo "ERROR: opencode is not installed or not in PATH." >&2
    exit 1
}

cat <<EOF | opencode run
You are auditing a Mali Kbase r54p0 security-research workspace.

Workspace:
${LAB_ROOT}

Kernel baseline:
Linux ${KERNEL_VERSION}

Ignore README.md as a build authority.

Inspect the actual r54p0 source tree, build scripts, compatibility patches,
kernel configuration, and generated artifacts.

Focus on:
- MEM_ALLOC / MEM_ALLOC_EX
- MEM_IMPORT
- MEM_ALIAS
- MEM_COMMIT
- MEM_FREE
- MEM_SYNC
- MEM_FLAGS_CHANGE
- mmap/munmap and VMA lifetime
- imported buffers
- JIT allocation/free
- reference counting
- CPU VA / GPU VA
- SAME_VA
- CSF queue registration/create/bind/kick/termination
- CQS/KCPU synchronization
- rollback and error paths

Return:
1. object/lifetime map
2. important state machines
3. user-controlled inputs
4. lifetime invariants
5. suspicious cleanup paths
6. likely race/UAF/refcount/OOB classes
7. concrete source functions to test
8. proposed valid-state mutation strategy

Do not modify files.
Do not invent API behavior.
Do not claim a vulnerability without a source path.
EOF
