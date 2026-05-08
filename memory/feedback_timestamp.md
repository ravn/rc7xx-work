---
name: Always regenerate timestamp
description: Delete builddate.h before every BIOS or PROM build to get a fresh timestamp
type: feedback
---

ALWAYS generate a new timestamp when building a new BIOS or autoload PROM.

**Why:** The user identifies builds by timestamp on the boot banner. A stale timestamp makes it impossible to tell if a new build was actually written.

**How to apply:** Before `make bios` or `make prom`, delete `builddate.h`:
```bash
rm -f builddate.h && rm -f clang/*.o && make bios
```
Or for the PROM:
```bash
rm -f builddate.h && make prom
```
