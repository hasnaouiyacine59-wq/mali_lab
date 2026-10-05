# Mali Kbase r54p0 Research Lab

This project is a security-research lab scaffold for Mali Kbase r54p0 with a Linux
6.6 LTS baseline.

## Important

- Canonical workspace: `/workspaces/mali_lab`
- Primary kernel baseline: Linux 6.6 LTS
- Target Kbase release: r54p0
- README.md is not used by `setup-mali-lab.sh` as a build authority.
- Existing Kbase compatibility patches must apply cleanly. The setup does not
  force or silently port failed patches.
- No-Mali is a software/simulated environment. It does not emulate real Mali
  hardware or CSF firmware behavior.

## Expected integration layout

This scaffold is intended to be placed over or alongside the actual `mali_lab`
repository containing:

- `init_.sh`
- `workspace.env`
- `kernel/build_kernel.sh`
- `driver/build_driver.sh`
- `patches/verify_patches.sh`
- `rootfs/build_rootfs.sh`
- `qemu/boot_kernel_gdb.sh`
- the bundled r54p0 source archive and compatibility patches

The bootstrap script validates these integration points before building.

## Quick start

```bash
cd /workspaces/mali_lab
chmod +x setup-mali-lab.sh
./setup-mali-lab.sh
```

After a successful setup:

```bash
./tools/lab-status.sh
./tools/opencode-memory-review.sh
```

For QEMU/GDB:

```bash
./qemu/boot_kernel_gdb.sh 6.6
```

Then:

```bash
gdb kernel/6.6/artifacts/vmlinux
```

Inside GDB:

```gdb
target remote :1234
```

## Research focus

The lab prioritizes:

1. GPU memory lifecycle
2. mmap/VMA lifecycle
3. allocation/free/commit/unmap state transitions
4. imported memory
5. alias mappings
6. JIT allocation/free
7. CSF queue lifecycle
8. CQS/KCPU synchronization
9. error and rollback paths
10. reference counting and object lifetime
11. KASAN/UBSAN findings
12. reproducible state-machine tests

Do not treat arbitrary ioctl-number generation as the primary fuzzing strategy.
Start with valid API contracts and mutate valid state transitions.
