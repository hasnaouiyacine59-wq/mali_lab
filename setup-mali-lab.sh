#!/usr/bin/env bash
#
# Mali Kbase r54p0 research lab bootstrap
# Canonical workspace: /workspaces/mali_lab
# Primary kernel baseline: Linux 6.6 LTS
#
# README.md is intentionally ignored as a build authority.
# Existing repository scripts are used for kernel/driver/rootfs integration.
# Compatibility failures are hard failures; patches are never force-applied.
#
set -Eeuo pipefail

LAB_ROOT="/workspaces/mali_lab"
KERNEL_VERSION="${KERNEL_VERSION:-6.6}"
LOG_DIR="${LAB_ROOT}/logs"
SETUP_LOG="${LOG_DIR}/setup-${KERNEL_VERSION}.log"

export LAB_ROOT KERNEL_VERSION
mkdir -p "$LOG_DIR"
exec > >(tee -a "$SETUP_LOG") 2>&1

log() { printf '[%s] %s\n' "$(date '+%F %T')" "$*"; }
die() { printf '\nERROR: %s\n' "$*" >&2; exit 1; }
section() {
  printf '\n============================================================\n'
  printf '%s\n' "$*"
  printf '============================================================\n'
}

trap 'rc=$?; echo "SETUP FAILED at line $LINENO (status $rc). Log: $SETUP_LOG" >&2; exit $rc' ERR

section "Mali Kbase r54p0 Lab"
log "Workspace: $LAB_ROOT"
log "Kernel:    Linux $KERNEL_VERSION"
log "README.md is intentionally ignored."

[[ -d "$LAB_ROOT" ]] || die "Missing workspace: $LAB_ROOT"
cd "$LAB_ROOT"

required=(
  init_.sh
  workspace.env
  kernel/build_kernel.sh
  driver/build_driver.sh
  patches/verify_patches.sh
  rootfs/build_rootfs.sh
  qemu/boot_kernel_gdb.sh
)

for p in "${required[@]}"; do
  [[ -e "$p" ]] || die "Missing required integration point: $p"
  chmod +x "$p" 2>/dev/null || true
done

section "Host dependencies"

if [[ "$(id -u)" -eq 0 ]]; then SUDO=""; else
  command -v sudo >/dev/null 2>&1 || die "sudo is required"
  SUDO=sudo
fi

command -v apt-get >/dev/null 2>&1 || die "apt-get is required"

export DEBIAN_FRONTEND=noninteractive
$SUDO apt-get update
$SUDO apt-get install -y \
  ca-certificates curl git locate \
  build-essential bc bison flex libssl-dev libelf-dev libdw-dev \
  libncurses-dev dwarves cpio rsync unzip xz-utils zstd \
  gzip bzip2 tar patch file python3 python3-pip \
  qemu-system-x86 qemu-system-arm qemu-user-static gdb

section "OpenCode"

if [[ -x "$LAB_ROOT/opencode.sh" ]]; then
  "$LAB_ROOT/opencode.sh" || true
fi

if [[ -d "$HOME/.opencode/bin" ]]; then
  export PATH="$HOME/.opencode/bin:$PATH"
fi

if ! command -v opencode >/dev/null 2>&1; then
  log "OpenCode not available; continuing with lab build."
else
  log "OpenCode: $(command -v opencode)"
fi

section "Repository initialization"

./init_.sh
[[ -f workspace.env ]] || die "workspace.env missing after init_.sh"
# shellcheck disable=SC1091
source workspace.env

export LAB_ROOT KERNEL_VERSION

section "r54p0 source discovery"

R54_ARCHIVE="$(find "$LAB_ROOT" -type f \
  \( -name '*r54p0*.tar.gz' -o -name '*r54p0*.tgz' \
     -o -name '*r54p0*.tar.xz' -o -name '*r54p0*.tar' \) \
  -print -quit 2>/dev/null || true)"

if [[ -n "$R54_ARCHIVE" ]]; then
  log "Found bundled r54p0 archive: $R54_ARCHIVE"
else
  log "r54p0 archive not automatically located; driver builder will resolve it."
fi

section "Patch verification for Linux $KERNEL_VERSION"

# Intentionally no --force, --reject, or guessed patching.
./patches/verify_patches.sh

section "Linux $KERNEL_VERSION build"

./kernel/build_kernel.sh "$KERNEL_VERSION"

KERNEL_ARTIFACTS="$LAB_ROOT/kernel/$KERNEL_VERSION/artifacts"
KERNEL_SRC="$LAB_ROOT/kernel/$KERNEL_VERSION/src"

[[ -d "$KERNEL_SRC" ]] || die "Kernel source not produced: $KERNEL_SRC"
[[ -d "$KERNEL_ARTIFACTS" ]] || die "Kernel artifacts not produced: $KERNEL_ARTIFACTS"

section "Mali Kbase r54p0 build"

./driver/build_driver.sh --kernel "$KERNEL_VERSION"

DRIVER_ROOT="$LAB_ROOT/driver/artifacts"
[[ -d "$DRIVER_ROOT" ]] || die "Driver artifacts missing: $DRIVER_ROOT"

section "Root filesystem"

./rootfs/build_rootfs.sh

section "QEMU/GDB validation"

chmod +x "$LAB_ROOT/qemu/boot_kernel_gdb.sh"
command -v qemu-system-x86_64 >/dev/null 2>&1 || log "WARNING: qemu-system-x86_64 not in PATH"
command -v gdb >/dev/null 2>&1 || log "WARNING: gdb not in PATH"

section "Research helpers"

mkdir -p \
  "$LAB_ROOT/artifacts/corpus/seed" \
  "$LAB_ROOT/artifacts/corpus/mutated" \
  "$LAB_ROOT/artifacts/crashes" \
  "$LAB_ROOT/artifacts/repros" \
  "$LAB_ROOT/artifacts/triage"

section "Final status"

"$LAB_ROOT/tools/lab-status.sh"

cat > "$LAB_ROOT/logs/build-report-${KERNEL_VERSION}.txt" <<EOF
Mali Kbase r54p0 Research Lab

Workspace: $LAB_ROOT
Kernel: Linux $KERNEL_VERSION
Kbase: r54p0

README.md: intentionally ignored

Kernel source:
  $KERNEL_SRC

Kernel artifacts:
  $KERNEL_ARTIFACTS

Driver artifacts:
  $DRIVER_ROOT

OpenCode helper:
  $LAB_ROOT/tools/opencode-memory-review.sh

Status:
  $LAB_ROOT/tools/lab-status.sh

QEMU/GDB:
  $LAB_ROOT/qemu/boot_kernel_gdb.sh $KERNEL_VERSION

Patch policy:
  No force application.
  No silent compatibility changes.
EOF

section "Complete"
cat <<EOF
Workspace: $LAB_ROOT
Kernel:    Linux $KERNEL_VERSION
Kbase:     r54p0

Next:
  ./tools/lab-status.sh
  ./tools/opencode-memory-review.sh
  ./qemu/boot_kernel_gdb.sh $KERNEL_VERSION

Report:
  logs/build-report-${KERNEL_VERSION}.txt

Setup log:
  $SETUP_LOG
EOF
