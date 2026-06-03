---
name: Get the RC702 display address from the DMA controller, never hardcode
description: When reading the RC702 display buffer (MAME Lua boot checks, screen dumps), derive the base from the Am9517A DMA channel-2 address register — never hardcode 0x7A00/0xF800/etc.
metadata:
  type: feedback
---

The RC702 display buffer base is **not** a fixed address — it is wherever the
running firmware programs the Am9517A DMA controller's **channel-2 address
register**, which feeds the i8275 CRTC. Different PROMs use different bases
(autoload-in-c = `0x7A00`, genuine roa375 = `0x7800`), and CP/M may move it
again after boot. **Always derive the display base from DMA ch2; never hardcode
it.**

**Why:** a hardcoded display address (`0x7A00`/`0xF800`) made a MAME boot check
read the wrong memory and report a misleading fragment (a lone "L") instead of
the real screen. Deriving the base from DMA ch2 read the correct buffer (`0x7800`
for roa375) and revealed the real message ("**NO SYSTEM FILES**"), 2026-06-02.

**How to apply (MAME Lua):** capture the base with **passive write-taps only**
(never `space:read` on IO — see [[feedback_lua_no_port_reads]]):
- port **0xFC** (clear byte-pointer flip-flop) → next 0xF4 write is the low byte
- port **0xF4** (Am9517A ch2 address) → low byte then high byte → 16-bit base
```lua
local dma = { base=nil, msb=false, lo=0 }
io:install_write_tap(0xFC,0xFC,"clbp", function() dma.msb=false end)
io:install_write_tap(0xF4,0xF4,"ch2",  function(_,d)
    if not dma.msb then dma.lo=d; dma.msb=true
    else dma.base=((d<<8)|dma.lo)&0xFFFF; dma.msb=false end end)
```
The firmware reprograms ch2 every frame, so `dma.base` tracks the live display.
Reference implementations (both converted 2026-06-02):
`rc700-gensmedet/autoload-in-c/mame_boot_test.lua` and `mame_sw1_test.lua`.

**Caveat — also scan 0xF800 when looking for BIOS output (2026-06-03):**
The DMA tap reliably captures *autoload's* ch2 writes (its boot banner at
e.g. 0x7A00) but does NOT always cleanly capture the *DRI BIOS* takeover —
the BIOS's ch2-address write order / 8237 flip-flop sequence may diverge
from autoload's low-then-high pattern, so `dma.base` can be left pointing at
the stale autoload framebuffer even after CP/M is up and `A>` is on screen
at the canonical BIOS display 0xF800.  A single-base scan misses the boot
success.  **Fix: when searching for boot markers, scan BOTH `dma.base` AND
0xF800.**  This burned ~a session on a false "autoload boot hangs"
diagnosis (chasing a non-existent codegen regression; eventually filed as
ravn/llvm-z80#215, closed the same day as does-not-reproduce, then traced
to this lua limitation).
