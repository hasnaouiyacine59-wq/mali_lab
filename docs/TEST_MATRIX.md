# Test Matrix

| Area | Baseline | Mutation |
|---|---|---|
| MEM_ALLOC | valid alloc/free | sizes, repeats, cleanup |
| mmap/VMA | alloc/mmap/munmap | split, repeat, early free |
| MEM_IMPORT | import/map/unmap | lifetime/order |
| MEM_ALIAS | alias/map/unmap | overlap/order |
| MEM_COMMIT | valid commit | boundaries/failure |
| JIT | init/alloc/free | pressure/order |
| CSF | register/create/bind | teardown/races |
| KCPU | wait/signal | blocked queue transitions |
| CQS | wait/set | producer/consumer lifetime |
| Errors | valid failure path | cleanup/retry |
| Power | normal transitions | alloc/free around transitions |

The matrix is a planning artifact; it does not claim that every operation is
available in every Kbase configuration.
