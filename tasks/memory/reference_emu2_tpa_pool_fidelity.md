# emu2 MCB pool must be TPA-capped, not just the load-time grant (2026-08-25)

## The gap (confirmed this session)

emu2's underlying MCB (Memory Control Block) free-memory pool is created ONCE at
startup in `dos.c`'s `init_dos()` via `mcb_init(0x80, 0xA000)` (or `0x7FFF` under
`EMU2_LOWMEM`) — a generic ~512-640 KB DOS-sized arena. Separately,
`cpm86.c`'s `.CMD` loader (`cpm86_load_cmd`) applies a `CPM86_TPA_KB` cap, but
**only to the LOAD-TIME group allocation** (code+data+extra+stack).

Consequence: a running CP/M-86 program's RUNTIME BDOS-128 (M_ALLOC) calls — e.g.
Watcom `farheap.c`'s `_fmalloc`, used by Info-ZIP zip's deflate window/hash
allocation — draw from the SAME underlying MCB pool via `mem_alloc_segment()`,
which was never shrunk. So even with a small `CPM86_TPA_KB`, a program could
always find "free" memory at runtime that a real, memory-constrained machine
(e.g. the RC759, effective TPA ~210 KB) would not have. This is WHY emu2 never
reproduced MAME's `zip error: Out of memory (...)` failure, regardless of how
`CPM86_TPA_KB` was tuned — the cap only ever bit the load-time grant.

## The fix (`emu2-cpm86` commit `fe9dfb9`)

- `dos.c`'s `init_dos()` now peeks the program file via `cpm86_detect()` BEFORE
  calling `mcb_init()`. If it's a CP/M-86 program, the WHOLE arena is sized to
  `CPM86_TPA_KB` paragraphs (`mcb_init(0x80, 0x80 + tpa_paras)`) instead of the
  generic DOS pool — load-time AND runtime allocations now draw from one
  correctly-sized pool.
- New `cpm86_get_tpa_kb()` (in `cpm86.c`, exported via `cpm86.h`) is the single
  source of truth for the TPA size, used by BOTH `dos.c` and `cpm86.c`'s
  group-allocation logic, so they can never disagree. Precedence: `-m <kb>`
  CLI option (new, `main.c`/`dbg.c`) > `CPM86_TPA_KB` env var > built-in
  default (210 KB).
- `cpm86.c`'s group-allocation logic was reworked to use the SAME "ask for
  `want`, fall back to the actual available size if it still covers the
  minimum" pattern the BDOS-128 handler already used (rather than requiring an
  exact match), and to spread extra/stack surplus from the grant's TRUE size
  (not the theoretical TPA figure) — matching the real DRI loader
  (`kern/load.sup`)'s "spread happens AFTER the combined allocation returns"
  semantics.

## Calibration result

At `-m 190` (or `CPM86_TPA_KB=190`), emu2 reproduces MAME's CURRENT exact
failure, `zip error: Out of memory (window allocation)`, BYTE-FOR-BYTE the same
message as a fresh real-MAME run (`scripts/rc759_zip_autorun.sh` with cleared
NVRAM). At the built-in default (210 KB), emu2 instead fails one allocation
later, `hash table allocation` (Info-ZIP's `deflate.c` `lm_init()` allocates
`window` FIRST, then the larger combined `prev`+`head` "hash table" — so a
memory state with "enough for window but not hash" reports the later message,
while "not enough for window" reports the earlier one). This means the stock
default still leaves emu2 with marginally more headroom than the real RC759;
use `-m 190` (or lower, verified range ~187-198) for a byte-exact MAME OOM
reproduction.

## Regression note: shared MAME test-harness script

`open-watcom-v2/contrib/ravn/watcom-cpm86-libc/build-farheap-mame.sh` hardcoded
`op farheap=0xF0000` (~960 KB) for ALL `TEST_SRC` builds, including
`test/memtest128.c` — a pure raw-BDOS-128-syscall test that never touches the
static "OPTION FARHEAP" Extra-group feature. Once the MCB pool was correctly
TPA-capped, this unrelated huge Extra-group reservation (which the loader must
still honor/spread at LOAD time) starved the test's own runtime BDOS-128 calls.
Fixed (commit `2e95f9ad66` in `open-watcom-v2`): `memtest128.c` now links WITHOUT
`op farheap=...`; only `farheap_smalltest.c` (which genuinely tests the static
Extra-group feature) still gets it. General lesson: fixing one fidelity gap can
expose previously-masked bugs in adjacent test infrastructure that shared a
build recipe.

## Verification performed

- `memtest128` (nofh build): PASS 4/4 on real MAME (independent RAM-dump oracle
  PASS) AND on local emu2 (default + `CPM86_DIRTY_GROUPS=1`), at TPA=210 and 190.
- `farheap_smalltest`: PASS on real MAME (6/6 blocks, independent RAM-dump scan
  PASS) — unaffected by emu2 changes since it runs on real hardware. Local emu2
  run reports `PASS far-heap n=45 seg=16384 kb=720`; this number (720 KB
  concurrently held within an apparently ~210 KB-capped pool) is because
  `farheap.c`'s `__AllocSeg()` has a dual path (BDOS-128 primary, static-carve
  fallback) — NOT yet fully root-caused as of 2026-08-25, flagged as an open
  loose end for whoever picks this up next (see `emu2-cpm86/src/port` and
  `open-watcom-v2/.../port/farheap.c` `__AllocSeg`/`__cpm86_fh_bdos_alloc`).
- Production `ZIP.CMD` under local emu2: full `CPM86_TPA_KB` sweep confirmed
  the 210->190 message transition described above; `-m` CLI flag precedence
  over `CPM86_TPA_KB` env var confirmed via `CPM86_TPA_KB=300 emu2 -m 190 ...`
  (CLI wins, gives `window allocation`, not success).

## Key files

- `emu2-cpm86/src/dos.c` — `init_dos()`'s CP/M-86-aware `mcb_init()` sizing.
- `emu2-cpm86/src/cpm86.c` — `cpm86_get_tpa_kb()`, `cpm86_load_cmd()`'s
  group-allocation "ask max, fall back to available" logic, BDOS-128 handler.
- `emu2-cpm86/src/main.c`, `src/dbg.c` — new `-m <kb>` CLI option + `-h` text.
- `open-watcom-v2/contrib/ravn/watcom-cpm86-libc/build-farheap-mame.sh` — the
  `TEST_SRC`-conditional `op farheap=` link fix.
- `infozip-cpm86-builds/HANDOFF_farheap_bdos128.md` — operational summary,
  includes this session's findings appended under "emu2 catches MAME's exact
  ZIP OOM message (2026-08-25)".
