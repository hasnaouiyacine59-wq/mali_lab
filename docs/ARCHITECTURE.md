# Lab Architecture

```text
                     OpenCode / Big Pickle
                              |
                              v
                  Research state-machine tests
                              |
                              v
                      Userspace harness
                              |
                     ioctl / mmap / poll
                              |
                              v
                       Mali Kbase r54p0
                              |
             +----------------+----------------+
             |                |                |
             v                v                v
          GPU MMU           CSF             Sync
          memory            queues           CQS/KCPU
             |                |                |
             +----------------+----------------+
                              |
                              v
                     Linux 6.6 LTS kernel
                     KASAN / UBSAN / debug
                              |
                              v
                         QEMU / No-Mali
```

## Boundary of interest

The main security boundary is untrusted userspace to Kbase.

Important state joins include:

- ioctl state ↔ VMA state
- CPU VA ↔ GPU VA
- allocation ↔ physical backing
- mapping ↔ unmapping
- import ↔ dma-buf lifetime
- queue ↔ queue-group lifetime
- synchronization object ↔ producer/consumer lifetime
- JIT allocation ↔ delayed free/pool state
- error path ↔ normal cleanup path

## No-Mali boundary

The simulated GPU is useful for driver/software research, but it does not
execute real Mali firmware or reproduce all real GPU hardware behavior.
