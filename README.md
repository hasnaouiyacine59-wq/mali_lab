# Mali r54p0 x86_64 external-driver research kit

Canonical workspace:
`/workspaces/x86_kernel/mali-r54p0-x86-full`

This kit separates Linux kernel builds from the Mali r54p0 Kbase build.

## Start

```bash
./init_.sh
source ./workspace.env
./kernel/build_kernel.sh 6.18.55
./patches/verify_patches.sh
./driver/build_driver.sh --kernel 6.18.55
```

## Driver builder

`driver/build_driver.sh` extracts the exact included `AX504X08X-SW-99002-r54p0-01eac0.tar.gz`, verifies r54p0, creates a private integration copy of the selected Linux source, configures the x86 Simulated Platform/No-Mali/CSF settings, then dry-runs all six patches. It **stops** if any patch fails to apply; it does not force or silently port a patch.

The six patches are kept verbatim in `patches/`. Their applicability to r54p0 is intentionally tested rather than assumed.

The original kernel source under `kernel/<version>/src/` is never modified by the driver builder.

## Output

```text
driver/artifacts/r54p0-18eac0/linux-6.18.55/
├── mali_kbase.ko
├── kernel-config
├── mali-release.txt
├── build-info.txt
└── SHA256SUMS
```

## QEMU/GDB

```bash
./rootfs/build_rootfs.sh
./qemu/boot_kernel_gdb.sh 6.18.55
```

In another terminal:

```bash
gdb kernel/6.18.55/artifacts/vmlinux
target remote :1234
```

## Important

The included six VP patches are the supplied Arm patch set. Existing research notes identify them as clean for r54p0 and explicitly caution that applicability is not automatic for other Kbase releases. This kit therefore treats successful r54p0 dry-run as a required gate.
