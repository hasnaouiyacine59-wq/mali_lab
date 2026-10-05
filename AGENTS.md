# Mali Kbase Research Lab — OpenCode Agent Instructions

## Project

- Workspace: `/workspaces/mali_lab`
- Kernel baseline: Linux 6.6 LTS
- Mali target: Kbase r54p0
- Platform target: x86 simulated platform / No-Mali / CSF where supported

## Source authority

Do not use the root README as a build specification.

Prefer, in order:

1. actual source files
2. build scripts
3. kernel configuration
4. compatibility patches
5. generated artifacts/logs
6. documentation

Never invent an ioctl contract when the source is available.

## Research methodology

Build valid operations first:

```text
open device
  -> version/init sequence
  -> valid ioctl
  -> valid mmap/VMA operation
  -> state transition
  -> cleanup
```

Then mutate:

- ordering
- repeated operations
- cleanup timing
- object lifetime
- error paths
- concurrency
- reference ownership
- mappings
- synchronization dependencies

Prioritize lifetime bugs:

- UAF
- stale VMA
- double free
- refcount imbalance
- mapping lifetime mismatch
- rollback inconsistencies
- imported-buffer lifetime
- JIT lifetime
- queue/group lifetime
- sync-object lifetime

## No-Mali limitations

No-Mali does not prove real GPU or firmware behavior.

Do not claim a real hardware vulnerability solely from a No-Mali result.

GPU MMU page-fault behavior is not naturally equivalent to real hardware in No-Mali.

## Patch discipline

Never:

- `patch --force`
- silently skip a failed patch
- hide compiler errors
- replace a failed API port with an unreviewed guess

If Linux 6.6 compatibility fails, document the exact API mismatch first.

## Output

For each promising finding, preserve:

- reproducer
- kernel config
- Kbase version
- kernel version
- exact source commit/version if available
- dmesg/KASAN/UBSAN output
- minimized operation sequence
- expected vs observed state
