---
name: feedback-grep-memmap-before-bss
description: "HARD - before allocating BSS at a literal address on an embedded target, grep the MAME (or other emulator) mem_map for that range"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: b20efbb1-10f2-452a-bfa2-432a9ba5a6a3
---

**Rule:** When parking BSS / buffers at a literal address in a
hand-asm Z80 (or similar embedded) project, **grep the target's
emulator memory-map definition BEFORE writing the equ**.  For MAME
targets the file is `mame/src/mame/<vendor>/<board>.cpp` and the
relevant block is `void <board>_state::mem_map(address_map &map)`.

10 seconds with grep saves debug cycles.

**Why:** Failed to do this in cpnos-in-asm session 73e and parked
rx_frame_buf at 0x2800, which the rc702 driver maps as the `bank2h`
PROM1-extended-EPROM mirror -- not plain RAM.  Writes vanished;
reads returned PROM bytes.  Cost ~4 iterations of red-herring
hypotheses (loopback, baud mismatch, ENQ race) before I checked the
mem_map.  The information was in the same file I'd opened to label
the DIP switches earlier in the session.

**How to apply:** At the point of picking a literal address for
BSS / shared buffers on an embedded target:

  1. Open `mame/src/mame/<vendor>/<board>.cpp`.
  2. Find the `mem_map` function.
  3. Confirm the address range is `.ram()` (not `.bankr()`,
     `.rom()`, `.unmap()`, or any other override).
  4. Note any explicit overlays -- they win over the broad
     `.ram().share("mainram")` shared mapping.

For the RC702 specifically the safe RAM windows are 0x1000..0x1FFF
and 0x3000..0xF7FF before PROM-disable (see
[[feedback-rc702-bank2h-mirror]] for the why).

Generalizes to other emulated targets too; the pattern of "shared
RAM at full range PLUS overlays for ROM banks" is standard in MAME
drivers.

**Related:**
  - [[feedback-rc702-bank2h-mirror]] is the specific instance.
  - [[feedback-no-literal-addresses]] mostly handles this when a
    linker is involved; this rule covers the zmac / hand-asm
    fallback path where the developer chooses the literal directly.
