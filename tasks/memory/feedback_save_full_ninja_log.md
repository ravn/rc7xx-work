---
name: feedback-save-full-ninja-log
description: Gem altid fuld ninja-log til fil — grep/tail EFTER build er færdigt
metadata:
  type: feedback
---

Gem altid fuld ninja-output til en log-fil og grep/tail bagefter. Aldrig pipe ninja direkte til grep/tail i background builds — det giver et næsten tomt output-fil og ingen synlighed i fremskridt eller fejl.

**Why:** Bruger opdagede at build-output var usynligt fordi jeg pipede `2>&1 | grep ... | tail -5` i background-kommandoen.

**How to apply:** Brug altid formen:
```bash
$NINJA -C build-dir target > scratch/tmp/build-<target>.log 2>&1
```
Grep log-filen bagefter når build er færdigt:
```bash
grep -E "error:|FAILED:" scratch/tmp/build-<target>.log
```
