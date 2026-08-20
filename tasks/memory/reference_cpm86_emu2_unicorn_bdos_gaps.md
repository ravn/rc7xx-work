---
name: BDOS coverage gaps — emu2-cpm86 vs the Unicorn runner (they are COMPLEMENTARY)
description: Which CP/M-86 BDOS functions each of the two CP/M-86 emulators implements, and what each is missing. The two have complementary holes; neither is a superset of the other.
metadata:
  type: reference
  verified: 2026-08-21
---

# CP/M-86 BDOS coverage — emu2-cpm86 vs Unicorn runner (verified 2026-08-21)

Two independent CP/M-86 execution oracles live in the workspace. They were built
for different jobs, so their BDOS coverage is **complementary, not nested** —
each implements a handful of functions the other does not. Use this note to pick
the right oracle and to know what will silently mis-run.

- **emu2** = `emu2-cpm86/` (fork `ravn/emu2-cpm86`, branch `local/cpm86`),
  source `src/cpm86.c` (~1575 lines). Full-ish CP/M-86: file system, memory
  allocation, DMA, S_BIOS, program chaining. Runs DR C 1.11 headless.
- **unicorn** = `open-watcom-v2/contrib/ravn/cpm86run_unicorn.py` (~656 lines).
  A deliberately minimal **console + compute + time** harness over QEMU's CPU
  core, used as an *independent* result oracle (not a file system). "Full-speed
  rule": a plain output run has only the INT hook, no per-block callback.

## Top-level BDOS functions each implements (measured from source, 2026-08-21)

emu2 (`switch(func)` in cpm86.c, 4-space cases only):
`0 1 2 6 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 29 30 31 32
33 34 35 36 47 50 51 53 54 55 56 57 58 105 143 152`
(NB: the `case 3:`/`case 4:` in cpm86.c are **S_BIOS subfunctions** inside
func 50 — CONIN/CONOUT — NOT top-level BDOS 3/4.)

unicorn (`func == N` in cpm86run_unicorn.py):
`0 1 2 5 6 9 10 11 12 13 14 25 104 105 155`

## The complementary gap (the headline)

| BDOS | Name | emu2 | unicorn | note |
|------|------|:----:|:-------:|------|
| 3  | A_READ (AUXIN / reader in)      | ✗ | ✗ | character device, nobody has it |
| 4  | A_WRITE (AUXOUT / punch out)     | ✗ | ✗ | character device, nobody has it |
| 5  | L_WRITE (list / LST: output)    | ✗ | **✓** | unicorn only |
| 7  | Get IOBYTE                       | ✗ | ✗ | redirection control byte |
| 8  | Set IOBYTE                       | ✗ | ✗ | redirection control byte |
| 104| T_SET (set date/time)           | ✗ | **✓** | unicorn only |
| 155| T_SECONDS (get time + seconds)  | ✗ | **✓** | unicorn only; self-timing |
| 15..36 | file system (open/read/... FCB) | **✓** | ✗ | emu2 only (by design) |
| 26/51 | F_DMAOFF / F_DMASEG           | **✓** | ✗ | emu2 only |
| 27/29/30/31 | alloc/RO vec, attrib, DPB | **✓** | ✗ | emu2 only |
| 47 | P_CHAIN                          | **✓** | ✗ | emu2 only |
| 50/51 | S_BIOS / DMA seg              | **✓** | ✗ | emu2 only |
| 53..58 | MC memory allocation         | **✓** (55/53/57; 54/56 stub) | ✗ | emu2 only |
| 152 | F_PARSE                         | **✓** | ✗ | emu2 only |

**Sharpest finding for the redirection thread:** the work that started this whole
line of investigation was *stdin/stdout redirection under CP/M-86*. The BDOS
character-device functions that redirection is built on — **3 (AUXIN), 4 (AUXOUT),
5 (L_WRITE), and the 7/8 IOBYTE pair** — are almost entirely absent: emu2 has
NONE of them, unicorn has only L_WRITE (5). A program that writes to LST: or PUN:,
or reads RDR:, or consults/sets the IOBYTE, silently hits the UNIMPLEMENTED
default (emu2 returns 0xFF; unicorn stops with `BdosUnimplemented`).

**Second finding:** emu2 has `105 T_GET` but not `104 T_SET` / `155 T_SECONDS`.
That is exactly why stdcbench self-timing runs on the Unicorn runner and real
MAME rc759 but **NOT under emu2** (see MEMORY.md notes marked "(not emu2)").

## unicorn's gaps are BY DESIGN; emu2's are genuine holes

- unicorn is a compute/console/time oracle — no file system, no memory
  allocation, no DMA. Missing 15..58/152 is intentional and should stay that way
  (adding a file system would defeat its "independent, no shared code with the
  build toolchain" purpose). The only console-adjacent thing it lacks that a
  compute test might touch is 3/4 (aux) — rarely used by benchmarks.
- emu2 aims to be a faithful CP/M-86 machine, so its missing character-device
  and time functions ARE real fidelity gaps. Filed as issues (2026-08-21):
  - **ravn/emu2-cpm86 char-device issue** — 3/4/5 + 7/8 (AUXIN/AUXOUT/L_WRITE +
    IOBYTE). Ties directly to the redirection theme.
  - **ravn/emu2-cpm86 time issue** — 104/155 (T_SET/T_SECONDS); complements the
    already-present 105, unblocks self-timing benchmarks under emu2.
  - **ravn/emu2-cpm86 filesys-completeness issue** — 28 (DRV_SETRO), 37
    (DRV_RESET), 40 (F_WRITEZF), 52 (F_MULTISEC).
- Already-tracked emu2 gaps (do NOT re-file): 59 P_LOAD (#11), 54/56 abs alloc
  (#10), 8080 base-page layout (#12). See `gh issue list --repo ravn/emu2-cpm86`.

## How to re-derive this table (do not trust memory)

```
# emu2 top-level BDOS cases:
sed -n '/switch(func)/,/^}/p' emu2-cpm86/src/cpm86.c | grep -E '^    case ' \
  | grep -oE '[0-9]+' | sort -n | uniq
# unicorn:
grep -oE 'func == [0-9]+' open-watcom-v2/contrib/ravn/cpm86run_unicorn.py \
  | grep -oE '[0-9]+' | sort -n | uniq
```
