# Zero-fill divergence: emulator vs real hardware (dirty BSS)

**Class:** an emulator that is *more generous* than the real machine hides a
whole bug class, and every test on that emulator passes while the hardware is
broken.

## What happened (2026-09-07, ravn/open-watcom-v2-ccpm86#47)

The CP/M-86 disk oracle passed `686/686` under `emu2` and failed `41 of 54`
on the real RC759 under MAME. Eight MAME runs isolated it: the source was not
the cause (the Aug-15 `diskio.c` rebuilt today also failed), the test change
was not the cause (baseline failed identically), and it was not a
`port/` vs `clib` divergence (both failed).

Root cause: **nothing zeroes the BSS.** A `.CMD` data group descriptor carries
G-Length (initialised data actually in the file) and G-Min (paragraphs the
loader must allocate); the difference is BSS. `crt0sm.asm` has no zero-fill
loop, so every `static`/global without an initialiser starts as garbage — a
violation of the C guarantee for static storage duration.

Measured with a 16 KB uninitialised static array read *before* any write:

| host | non-zero bytes |
| --- | --- |
| emu2 | 0 of 16384 — ZEROED |
| real RC759 | 16128 of 16384 — **DIRTY** |

The one binary that passed on hardware was immune by accident: its (now
absent) toolchain emitted the whole BSS as literal zeros inside the file, so
G-Length == G-Min and no uninitialised tail existed. That was also the entire
unexplained size gap, 45776 B vs 23-26 KB.

## The rule

**When an emulator and real hardware disagree, suspect a resource the emulator
initialises and the hardware does not.** Zero-filled memory is the classic
one; others in the same family: registers assumed zero at entry, allocated-
but-unwritten disk blocks, uninitialised device state, and unset segment
bases. The emulator is a *permissive* environment — passing there proves
almost nothing about a machine that recycles dirty memory.

**Corollary — the size gap was the tell, and I nearly ignored it.** A binary
that is 2x larger than its replacement for no articulated reason is evidence,
not noise. Here the extra 20 KB *was* the zero-filled BSS. When a measurement
is conspicuous and unexplained, explain it before theorising elsewhere.

## The methodological failure to avoid repeating

I first proposed an `SS:offset` vs `DS:DX` FCB mechanism — pattern-matched
from a comment in `port/diskio.c` describing a *different*, already-fixed bug.
It was wrong (`set_dma()` already sets both DMA offset and segment), and it
never explained the emu2/hardware split at all.

**Test: does the proposed cause explain the FULL observation, including which
environments do NOT show it?** A cause that explains the failure but not the
emulator's silence is incomplete, and being incomplete is the signal it is
wrong. Applying that test would have discarded the FCB theory immediately,
because emu2 models segmentation faithfully and would have shown the fault.

The fix was to build a *decoupled one-variable probe* (`test/bssprobe.c`:
declare an uninitialised static, count non-zero bytes before writing) rather
than continue bisecting the complex disk oracle. One probe run settled what
five MAME bisect runs could not — cf. `feedback_smallest_repro_tripwire`.

## Reusable technique

Checking any CP/M-86 `.CMD` for the exposure, no hardware needed:

```python
import struct, sys
b = open(sys.argv[1], 'rb').read(128)
for i in range(0, 72, 9):
    if b[i] == 0: break
    ln, base, mn, mx = struct.unpack('<HHHH', b[i+1:i+9])
    kind = {1: 'code', 2: 'data'}.get(b[i], 'g%d' % b[i])
    print("%s: in-file=%6d B alloc=%6d B BSS tail=%6d B"
          % (kind, ln * 16, mn * 16, (mn - ln) * 16))
```

A non-zero BSS tail on the data group means the binary depends on a zero-fill
that real hardware does not provide.

Probe: `open-watcom-v2/contrib/ravn/watcom-cpm86-libc/test/bssprobe.c`.
Write-up: `KNOWN_ISSUES.md` section 3c. Issue:
ravn/open-watcom-v2-ccpm86#47.
