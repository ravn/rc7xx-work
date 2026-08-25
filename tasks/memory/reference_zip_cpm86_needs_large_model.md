# Info-ZIP `zip` på CP/M-86 kræver LARGE model (ikke medium)

2026-08-21. Under portning af Info-ZIP `zip` 3.0 til CP/M-86 (`owcc -bcpm86`,
repo `infozip-cpm86-builds`) viste det sig at **medium model (`-mm`/`-mcmodel=m`)
ikke duer** for zip, i modsætning til hvad Stage B-planen antog.

## Årsag (near/far type-mismatch, ikke en størrelses-ting)
`zip.h:834` prototyper `flush_block` som `char far *`, men K&R-definitionen i
`trees.c:1014` er `char *`. I **near-data**-modeller (small OG medium) er de to
ikke samme type → `trees.c(1018): Error! E1129`. Samme latente mismatch løber
gennem hele deflate-datastien (`window` er `far` via `DYN_ALLOC`, men flyder
gennem `char *`-parametre i `flush_block`/`copy_block`/`flush_outbuf`).

Kilden må **ikke** editeres: `src/zip30` er den pristine kilde DOS-buildet
(`build.sh` → `build/zip30` → `wmake msdos/makefile.wat`) reproducerer
byte-for-byte ("no C source file is changed"). Så fixet skal være model/flag, ikke edit.

## Empirisk matrix (owcc -bcpm86 -mcmodel=X, zip-kernen)
| model | far code | far data | trees.c | kerne |
|-------|:-:|:-:|:-:|:-:|
| s | ✗ | ✗ | E1129 | — |
| m | ✓ | ✗ | E1129 | — |
| c | ✗ | ✓ | OK | kode >64K → kan ikke linke (near code) |
| **l** | ✓ | ✓ | **OK** | **alle 11 objekter rent, nul edits** |

Large virker fordi far data gør `char *` == `char far *` (prototype matcher def),
og far code lader koden spænde flere 64K-frames (map: frame 0001 ~58K + 0002 ~52K).
Compact fejler fordi zip's kode ikke er ét ≤64K segment.

## Følger for large-model support (ny)
- `build-lib.sh` bygger kun s/m/c → skal have `MODEL=l` (`-ml -zm` + ny
  `crt0lm.asm` der definerer `_big_code_` + far-heap som crt0cm + far-code som crt0mm).
  Prøve-link viste `_big_code_` udefineret (large-runtime-markøren).
- DGROUP endte 68K (~3K over 64K); CONST alene 38K strenge → brug `-zc` (konstanter
  i kodesegmentet, far i large) for at tømme DGROUP. Flag, ikke edit.
- match.c (C-udgaven) SKAL med i objektsættet (`_longest_match`/`_match_init`);
  asm-`match` er kun en DOS-optimering.

Plan: `infozip-cpm86-builds/ZIP_CPM86_PLAN.md` (M1b = large clib). Kontrast:
unzip klarede sig med SMALL model (mindre kode, ingen far-data-mismatch) —
`[[reference_stageb_farcode_reloc_verified]]`.

## M1b FÆRDIG 2026-08-21: large-model clib bygget + valideret
- `build-lib.sh MODEL=l` (`-ml -zm`) → `clibl.lib` + `cstartlm.obj` (staged
  `lib286/cpm86/`). Ny `crt0lm.asm` = crt0mm's far-code startup.
- **Far-argv-finesse (vigtig):** i far-data-model er `char **argv` en far pointer
  (offset BX, segment CX) og hvert `argv[i]` en 4-byte far `char *`. crt0mm's near
  2-byte-argvtab gav tom argv[0]; crt0lm bygger far-pointer-slots med runtime-DS.
  Samme bug er LATENT i `crt0cm` (compact) — aldrig testet der; skal have samme fix.
- Valideret: emu2 `CLIBHELL FOO BAR` → argc=3, argv[0..2]=ZIP/FOO/BAR; og
  `run-all-models.sh` (udvidet med `l`): model l heap/stdio/float/math/fltfmt/
  scanf/**disk**/argv PASS. 2 fejl (conin, redir) = far-data stdin/redirect-input-
  hæng (samme klasse som medium's kendte stdin-issue), IKKE på zip's sti — zip
  bruger disk-FILE* (PASS). Se harness-task #12.
- Harness fik en **per-test timeout** (`guard()` via perl alarm, default 25s,
  override `TEST_TIMEOUT`) så et far-data-hæng ikke staller hele matrixen (den
  spandt 6+ min før). `[[feedback_show_progress_on_long_runs]]`.

## MILEPÆL 2026-08-21: zip LINKER og STARTER på CP/M-86
`build-zip-cpm86.sh` bygger **ZIP.CMD (197632 B, header 0x01)** reproducerbart.
Opskrift: `owcc -bcpm86 -mcmodel=l -zm -Os` + `-DDOS -DMSDOS -DDYN_ALLOC
-DNO_ASM -DSMALL_MEM -DLIT_BUFSIZE=0x1000`, **ingen `-zc`**, link `format cpm86
… op farheap=0x8000 cstartlm.obj … clibl.lib`. Nul pristine-edits; OS-laget er
ny `src/zip30/cpm86/cpm86.c`.

Nøgle-gotchas (alle løst):
- **`-DNO_ASM` obligatorisk:** `msdos/osdep.h` tvinger ellers `#define ASMV` →
  udefinerede asm-entry `_crc32`/`_longest_match`/`_match_init` (C-udgaverne
  ligger i deflate.c/crc32.c under `#ifndef ASMV`).
- **`-zc` udelukket:** const-i-kode sprænger kodegruppen → `E2052` "relocation
  not in same segment" i clib-streamio. Behold CONST i DGROUP; trim data i
  stedet (`-DSMALL_MEM -DLIT_BUFSIZE=0x1000` bragte DGROUP fra 3.3 KB over → under).
- Kode ~115 KB spænder frames 0001+0002 (multi-gruppe far-code) uden E2052 når
  `-zc` er væk.
- `PATH_END`/`PAD` defineres PR. OS-fil (ikke i header) — cpm86.c definerer selv.
- clib strlwr hedder `_strlwr_` (ledende underscore); undgået via inline lowercase.

**M7 (runtime) ÅBEN:** ZIP.CMD loader + starter, crasher så i init med
`unimplemented opcode 0x65 at 1CEC:841A` (0x65 = 386 seg-prefix → udførelse
hoppet til garbage). Mistænkt: `intdosx` casemap-far-pointer-stub som
`init_upper()` (util.c MSDOS16-gren) kalder. Task #8.

## CCP/M-vs-emu2 compressed-size divergence (uafklaret, 2026-08-25)

The minimal `POEM2.ZIP` repro still diverges after deflation on real CCP/M-86
even after forcing `FOPW` and `FOPW_TMP` to `"wb"`. With identical input-read
samples (`zread` returns 3960 bytes, then 0, and sampled bytes match), emu2
writes a 333-byte archive while CCP/M reports `s=350, actual=349` and fails
with `Internal logic error (incorrect compressed size)`. The first observed
divergence is therefore not proven to be CR/LF translation or a generic
FILE*/BDOS write failure; it is currently localized to the ZIP/zlib
compression or runtime state under CCP/M. The source instrumentation was
removed after the comparison. The binary-mode source regression test remains
useful only as a guard for the intended mode definition, not as proof of a
runtime fix.

## VERIFIED ROOT CAUSE via MAME lua/debugger (2026-08-25)

Not CR/LF, not the size-check (that is only the messenger), not I/O. The
`incorrect compressed size` and the alternate hang/OOM are ALL symptoms of a
**large-model far-heap corruption in Info-ZIP's own deflate** (DYN_ALLOC:
`window`/`prev`/`head` via `_fcalloc`), which emu2 masks and real CCP/M-86
exposes. Manifestation depends on `option farheap=` size:
- 48K (0xC000): `zip error: Out of memory (hash table allocation)` — `_fcalloc`
  of prev/head fails after window succeeds.
- 64K (0x10000): allocs succeed, then deflate **hangs** in a deterministic
  infinite far-scan loop (confirmed 899 emul. sec, no progress).
- divergence env: completed once but produced a WRONG stream (s=350 vs emu2's
  219 B, +60%).

Headless capture (no interactive typing): boot turnkey `mandel.img` to A>,
`natkeyboard:post` the ZIP command, sample CPU state via MAME lua.
Scripts: `scripts/rc759_zip_autorun.sh`, `scripts/rc759_zip_stream_diff.sh`,
`scratch/zip_debug.lua` / `zip_hang_dump.lua` / `zip_stack_dump.lua`.

Instruction-level evidence at the hang (CS=01A4 IP=0865, deterministic):
```
CMP byte ES:[0x1B], 0xFF ; JNZ +3 ; JMP -0x443   (ES:[0x1B] stays 0xFF)
2E 8E 1E 06 00 = MOV DS, CS:[6]   (large-model far-data DS-reload idiom)
```
- Loop never terminates because it scans a far buffer via `ES=0x2F3A` whose
  contents are NOT clean deflate array data — they are allocator-metadata /
  saved-context bytes (an exact copy of live SP=0xFDAA, SS=0x4C2E, BP=0xFDB2,
  0x5DD5 sits at ES:+0x18..). So **ES holds a wrong/corrupt far-segment value**;
  the scan's terminator is sought in the wrong segment.
- Caller (far return `[BP+2:4]` = 2000:0006) is in code frame 0002 = the
  deflate/longest_match/fill_window group (map `0002:2d92..365d`); the scan
  helper runs in frame 0001 with the bad ES.
- Deflate far globals (map, DGROUP=grp 0004): `_window` @0004:0774, `_prev`
  @0004:0778 (far ptrs), `_head` @0004:b29c — the objects whose far segment is
  mis-set. Root layer = the **M9 `CPM86_FARHEAP_PARAS` far-heap placement**,
  which was "verified on emu2, MAME pending" (`ZIP_CPM86_PLAN.md` M9) — this IS
  the pending MAME failure.

Instrumentation left in `src/zip30` (gated, pristine-DOS build unaffected):
`-DCPM86_KEEP_BADZIP` (zipup.c: keep archive instead of destroy(tempzip)),
`-DCPM86_AUTORUN` (zip.c: fixed `zip POEM.ZIP POEM.TXT` for headless autostart),
`-DCPM86_ASSERT_ONLY` (zip.h: keep Assert/check_match under DEBUG but drop the
Trace() format-string CONST bloat).

`-DDEBUG` build (`build-zip-debug.sh`, 201856 B): compiles DEBUG only in
deflate.c+zipup.c (isize must be global in both), Trace stripped via
CPM86_ASSERT_ONLY. DGROUP overflow (near DATA+BSS+CONST+STACK is one 64 KB
group; we sit at ~0 headroom) fixed NOT by `-zc` (that overflows CODE frame
0002 -> E2052 in clib) but by **`-zt64`** = move data objects >64 B to FAR_DATA,
freeing DGROUP for the assert strings. Result: builds+loads, but **asserts do
NOT fire** — the corruption manifests as a 2-instruction dead loop
(`CMP byte ES:[0x1B],0xFF ; JNZ ; JMP`) that never returns to the assert-guarded
C code. DEBUG would catch a wrong-but-progressing deflate, not this dead spin.
The 640 KB RAM dump stays the conclusive evidence.

CONCLUSIVE (full 640 KB RAM dump at the hang, `scratch/zip_ramdump.lua` ->
`/tmp/zipram.bin`, offline analysis):
- The **input text is ABSENT from all 640 KB of RAM** — no `poem.txt` fragment
  ("Line 01", "quick brown", "jumps" … all ABSENT). Zip re-reads POEM.TXT via
  BDOS (fbdos trace) but the data never lands in any coherent window buffer.
- The block the hang scans (`_window` -> seg 0x2F3A, phys 0x2F3A0) holds
  **far-heap allocator control data**, not window bytes: words
  `8062 EF76 4C2E 0C02 F35E 4C2E FFFF 0000` (0x4C2E = live SS appears twice).
- => `_fcalloc` returned a **bogus `window` far pointer** aimed at the
  allocator's own control structures / a wrong segment. So the file DMA/copy
  target is wrong (input lost), and deflate's match/scan loop reads garbage
  whose terminator (`ES:[0x1B]==0xFF`) is permanently true -> deterministic
  infinite loop.

## Testcase + emu2-fidelity goal (2026-08-25)

Testcase built: `watcom-cpm86-libc/test/deflate_fheap_test.c` +
`build-deflate-fheap-mame.sh` — allocates deflate's exact triple
(`_fcalloc` window/prev/head, 3×8 KB, LARGE model, FARHEAP=0x10000, M9 farheap.c)
and checks NULL / not-zeroed / alias / overlap, signalling PASS/FAIL via
`mame_done()`. **It PASSES on BOTH emu2 and real MAME** — proving the bug is NOT
the raw 3-alloc pattern. The trigger is zip's cumulative state: zip's image is
~200 KB, so its far heap is handed out from a HIGH segment (0x2F3A, near the
RC759 384 KB ceiling) where farheap.c's overcommit
(`total_paras = marker + FARHEAP_PARAS`, assuming the FULL 64 KB farheap reserve)
runs PAST the real (spread) Extra grant into adjacent live memory. The test's
26 KB image gets a low, roomy heap and never reaches the boundary.

**Why emu2 != real CCP/M (user goal: make emu2 faithful).** emu2-cpm86 ALREADY
models the loader's group-SIZE spread (`cpm86.c:463+`, load.sup-style, bounded by
`CPM86_TPA_KB=210`) so it reproduces the OOM boundary. The residual gap is memory
CONTENTS: emu2's `memory[0x110000]` arena is a zero BSS global and it `memset(0)`
the granted Extra group (`cpm86.c:629`), so farheap.c's over-committed pointer
reads **zeros (benign)** on emu2 but **garbage/live-neighbour data (0xFF -> deflate
scan never finds its terminator -> hang)** on real CCP/M. Fix design: emu2 should
POISON uninitialized/over-committed TPA (garbage, e.g. 0xFF) instead of leaving it
zero — but the arena is MCB-managed (`loader.c` mcb_alloc_new), so a blanket
poison would corrupt MCB headers; the safe version poisons each group's
allocated-but-uninitialized span (extra->min..extra_par) + free space minus MCB
headers, env-gated (`CPM86_POISON`), default off so existing tests are unaffected.
With that fidelity fix, zip AND deflate_fheap_test would reproduce the hang under
emu2 (fast oracle) instead of only on slow MAME.

### A implemented + refined (2026-08-25): poison is necessary-not-sufficient
Added `CPM86_POISON=<byte>` to emu2-cpm86 (`loader.c` `mem_poison_free()` walks the
MCB chain and fills FREE-block DATA, leaving headers intact; `cpm86.c`
`cpm86_load_cmd` calls it before carving the program's groups). Safe + env-gated
(default off, existing tests unaffected). BUT with poison ON, zip still produces a
valid archive under emu2 even at low `CPM86_TPA_KB` (grant ~10 K << the 24 K
triple). So poison alone does NOT reproduce the hang. Refined root of the emu2
divergence: it is NOT the initial CONTENTS of the over-committed region — it is
that on real CCP/M the far-heap over-commit lands on the **LIVE STACK** (the RAM
dump shows SS/SP/BP bytes inside the window region), which overwrites the
`_fcalloc`-zeroed window AFTER the fact; under emu2 the same over-commit lands in
DEAD free space that nothing rewrites, so the window survives and zip works.
Full emu2 fidelity therefore also needs matching the Extra/stack LAYOUT adjacency
(over-commit must hit the live stack), a bigger emu2 change than poison. Poison is
kept as a correct, independent fidelity improvement.

### B options (the real fix) — for user decision
On real CCP/M the base page exposes only G_MIN at 0x0C (not the loader's SPREAD
grant), so a far heap literally cannot know its true size; M9's
`FARHEAP_PARAS` assumes the FULL reservation and thus over-commits past the spread.
Candidate fixes:
- B1: shrink the far-heap footprint so the loader grants it FULLY
  (`farheap <= effective_TPA - program`); narrow window (~24-32 K need vs ~28 K
  grant) -- fragile.
- B2: `farheap.c` PROBES real available memory at runtime (write/read-back walk
  from the Extra base until it wraps/fails) instead of trusting `FARHEAP_PARAS`.
- B3: shrink zip's code footprint (smaller image -> more TPA -> full grant).
B2 is the robust fix; B1/B3 are mitigations.

### B2 API confirmed from CCP/M-86 source (2026-08-25)
The bug is in OUR libc port, not firmware/compiler/malloc: `__AllocSeg`
(`port/farheap.c`, our "sbrk") over-reports the far heap by trusting compile-time
`FARHEAP_PARAS` instead of the loader's real spread grant. The correct fix uses
the OS memory call, which RETURNS the actual granted size (user hypothesis,
confirmed in `scratch/ccpm86-src/kern/memory.mem` + `mpb.def` + `modfunc.def`):
- **BDOS function 128 = Allocate Memory** (`f_malloc equ user*0x100 + 128`).
- Input: `CL=128`, `DX=offset(MPB)` in the DS work seg. MPB = 5 words
  `{start, min, max, pdadr, flags}`: start=0 (relocatable), min=least acceptable
  paras, max=wanted paras, pdadr=0 (self), flags=0 (plain unused mem).
- Output: `BX=0` ok / `0xFFFF` fail, `CX`=err. MPB updated in place:
  **`mpb_start`=granted base paragraph (segment), `mpb_max`=ACTUAL granted paras**
  (memory.mem clamps mpb_max to available at L143-145 & writes it at L265).
- Free = function 130 (`f_memfree`, MFPB `{pd}`).
So `__AllocSeg` should call BDOS 128 (min=needed, max=wanted), use `mpb_start` as
the segment and `mpb_max` as the true size -- no overcommit possible. Likely lets
us drop `OPTION FARHEAP` entirely (loader no longer pre-reserves -> more free TPA
for runtime M_ALLOC). Free path -> BDOS 130. Verify: zip deflates on real MAME
(window holds poem text; no hang; s==actual) + emu2 (emu2 already implements the
memory-manager spread, so it should agree once __AllocSeg asks the OS).

### B2 IMPLEMENTED + MAME-verified (2026-08-25) -- see HANDOFF doc
`__AllocSeg` (`port/farheap.c`) now calls BDOS 128 first (fn128 probe
`test/memtest128.c` CONFIRMED it works on real MAME rc759 and returns the actual
grant in mpb.max); old OPTION-FARHEAP carving kept as fallback. emu2 gained fn
128/130 (`cpm86.c`) -- it previously only had CP/M-86 fns 53-57, a real Concurrent
machine does NOT expose those, which was itself an emu2 fidelity bug. On MAME zip
**no longer hangs** -- it cleanly reports `Out of memory (window allocation)`
(ZE_MEM). Hang -> honest OOM = the correctness win. REMAINING (Copilot):
(1) drop `OPTION FARHEAP` to minimal in build-zip-cpm86.sh so its reservation
stops starving the runtime M_ALLOC grant; (2) shrink zip's ~200 KB image (B3) so
deflate's 24 KB far heap fits the ~210 KB effective TPA. Full operational handoff:
`infozip-cpm86-builds/HANDOFF_farheap_bdos128.md`.

### B2 interface contract strengthened (2026-08-25)

After the initial fn128 probe, `test/memtest128.c` was expanded to cover
variable-size and partial-grant requests (`min < max`) and to verify the
returned blocks by writing/reading all bytes in each grant. On MAME rc759:
- guest self-check: `pass=4 fail=0`
- independent host oracle (`test/verify_memtest128_dump.py`) found all expected
  pattern blocks in the full 384 KB RAM dump

This closes the remaining uncertainty around the BDOS memory-call interface
itself: current ZIP failures are downstream of allocator correctness (not a
wrong CL/DX/MPB contract implementation).

ROOT LAYER = the **M9 `CPM86_FARHEAP_PARAS` far-heap accounting** returns wrong
far pointers on the real CCP/M-86 loader's memory layout (it was "verified on
emu2, MAME pending" per `ZIP_CPM86_PLAN.md` M9 — this is that pending MAME
failure, now pinned to the instruction and the corrupt pointer). emu2 lays the
far heap out benignly, hiding it. FIX belongs in `port/farheap.c` /
`__cpm86_fh_init` so `_fcalloc` hands out valid, correctly-based, non-metadata
segments; then re-run the headless oracle (window must contain poem text; no
hang; s==actual).
