---
name: project_zsdcc_autoload_boot_investigation
description: zsdcc autoload-in-c native build (SDCC 4.6) boots but CTC CH2 ISR never fires in MAME — paused 2026-10-14
metadata:
  type: project
---

Branch: `ravn/rc700-gensmedet` `work/zsdcc-sccz80-builds-20261012`.

**Why:** User asked to get autoload working with the SDCC path, via native zcc on ravn/z88dk (not Docker). Target: `make zsdcc-prom` produces a bootable PROM.

**How to apply:** Resume with [[feedback_check_memory_before_coding]] — read this file + lessons.md + the commit messages on the branch before touching the sources.

## Current state (2026-10-14, paused)

Build works, boot does not. `make zsdcc-prom` produces 3861 B. In MAME:
- Display stuck at 0x39 pattern (BIOS 0xF800 default)
- Lua port-0xF4 tap never fires → CTC CH2 ISR never entered
- MAME speed 1620% → tight polling loop (likely init_fdc wait-ready)

All inspectable setup is **correct at byte level**:
- `start()` at 0x0000 (DI, LD SP, LDIR)
- IVT at RAM 0x7200, page-aligned (`intvec[6]@0x720C = 0x78AD`)
- `set_i_reg(0x72)` → I = 0x72
- init_pio/ctc/dma/crt emit correct OUTs
- ISR body contains the OUT 0xF4 writes
- `DIAG_EARLY_EI` compile flag confirmed EI isn't the cause

## Resume recipe

1. `cd /Users/ravn/z80/rc700-gensmedet && git checkout work/zsdcc-sccz80-builds-20261012`
2. `cd autoload-in-c && make zsdcc-prom` (should produce 3861 B)
3. Launch MAME with `-debug` + breakpoint on ISR entry 0x78AD. If BP never hits, investigate CTC CH2 TRG wiring in MAME rc702 driver (hardware path from CRT HRTC → CTC CH2 TRG). If BP hits but ISR crashes, single-step through ISR body.

## Separate concern

Code size is 3861 B vs clang 2363 B (+63%). SDCC 4.6 regression vs the historically smaller SDCC 4.1 Docker build. Not blocking boot — investigate after boot works.
