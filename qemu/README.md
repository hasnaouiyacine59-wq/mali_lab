# QEMU

The actual repository boot helper should remain the authoritative QEMU entry
point:

```bash
./qemu/boot_kernel_gdb.sh 6.6
```

This directory intentionally does not duplicate the repository's boot logic.
