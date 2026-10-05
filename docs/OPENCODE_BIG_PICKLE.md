# OpenCode + Big Pickle Workflow

## Principle

Use the model as a research assistant around a deterministic test engine.

```text
valid Kbase test corpus
        |
        v
state-machine model
        |
        v
Big Pickle mutation
        |
        v
KASAN / UBSAN / kernel logs
        |
        v
OpenCode triage
        |
        v
minimized reproducer
```

Do not start with unrestricted random ioctl generation.

## First review

Run:

```bash
./tools/opencode-memory-review.sh
```

The helper asks OpenCode to inspect actual r54p0 source and identify:

- objects
- ownership
- lifetime
- state transitions
- user-controlled inputs
- cleanup paths
- promising fuzz targets

## Model configuration

Do not hard-code a provider API key in this project.

Configure the Big Pickle model/provider through the OpenCode installation and
configuration available in your environment.

If your OpenCode installation uses a different model identifier, change the
model in your OpenCode configuration rather than modifying the research
scripts.

## Suggested agent tasks

1. Source map generation
2. ioctl contract extraction
3. lifetime invariant extraction
4. state-machine generation
5. crash triage
6. reproducer minimization
7. regression test generation

## Evidence discipline

Every suspected bug should have source references and a reproducible test.
