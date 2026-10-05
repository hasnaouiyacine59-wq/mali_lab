# Research Plan

## Phase 1 — Establish baseline

- Build Linux 6.6 LTS.
- Enable KASAN/UBSAN according to the lab configuration.
- Build r54p0 without forcing compatibility patches.
- Boot the resulting environment.
- Record exact versions and hashes.

## Phase 2 — Source model

Map:

- ioctl entry points
- object constructors
- object destructors
- refcount operations
- mmap/VMA handlers
- import/unimport
- JIT paths
- CSF queue registration/bind/unbind
- CQS/KCPU synchronization
- fault/error cleanup

## Phase 3 — Valid API corpus

Create small deterministic tests:

- allocation/free
- allocation/mmap/munmap/free
- import/map/unmap
- alias/map/unmap
- JIT alloc/free
- queue register/create/bind/kick/terminate
- synchronization wait/set

## Phase 4 — State-machine mutation

Mutate:

- legal orderings
- repeated cleanup
- concurrent cleanup
- failure injection
- delayed operations
- boundary sizes
- mapping splits
- object sharing

## Phase 5 — Sanitizer triage

Capture:

- KASAN
- UBSAN
- WARN/OOPS
- refcount warnings
- lockdep reports where enabled
- hung tasks
- unexpected errno changes

## Phase 6 — Minimization

Every candidate should become:

```text
small input
+ exact environment
+ deterministic sequence
+ crash/anomaly
+ source path
+ invariant violated
```

## Phase 7 — Hardware confirmation

A No-Mali result is a driver/software signal, not automatic proof of a
real-device vulnerability. Hardware confirmation is a separate phase.
