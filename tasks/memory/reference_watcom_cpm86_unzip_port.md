# UnZip 6.0 on CP/M-86 (small model) — STORED-correct; deflate hits a DGROUP ceiling

**Milestone (2026-08-16, rc7xx-work#9):** Info-ZIP UnZip 6.0 links against the
CP/M-86-retargeted Open Watcom clib (`clibcpm.lib` + `crt0.obj`) and, under
emu2, extracts **STORED** entries with **byte-correct content AND passing CRC**.
ZERO edits to UnZip's generic C sources — the only new source is the OS layer
`src/unzip60/cpm86/cpm86.c` (selected by `-DFLEXOS`); everything else is `-D`
config captured in the fork's `build-cpm86.sh` (branch `cpm86-port`,
commit 5116747). clib side: open-watcom-v2 master `e3e9c6b61f`.

## The non-obvious root cause: a 16-bit `zcalloc` overflow that masquerades as a CRC bug

Symptom: every entry extracted with **correct bytes on disk** but printed
`bad CRC 00000000 (should be …)`. A CRC of *exactly* 0 (not garbage) is the tell.

Chain: UnZip's default build enables Deflate64 → `WSIZE = 65536L`. The window is
allocated by `unzip.c`: `zcalloc(UZ_NUMOF_CHUNKS, UZ_SLIDE_CHUNK)` where for
WSIZE=64K, `UZ_NUMOF_CHUNKS = 16384`, `UZ_SLIDE_CHUNK = 4`. `zcalloc` →
`calloc((unsigned)16384, (unsigned)4)`; `16384*4 == 65536` **wraps to 0 in
16-bit `size_t`** → a 0-byte (NULL) window. `G.area.Slide = NULL`. The alloc is
**unchecked**, so UnZip decompresses/copies through the NULL **near** pointer
(offset 0 in DGROUP is writable, so the file bytes land correctly and get
written back — hence correct output). But `crc32(crc, buf, len)` opens with
`if (buf == NULL) return 0L;` — its "initialize" sentinel — so with buf==NULL it
returns 0 every call: `crc32val` stays 0 → `bad CRC 00000000`.

**Fix: `-DNO_DEFLATE64`** → `WSIZE = 0x8000` (32 KB) → `zcalloc(8192,4)=32768`,
no overflow, real window. (16-bit CP/M-86 can't address a 64 KB near window
anyway.) Diagnosis method that cracked it: a one-line `printf` of `size`,
`crc32val`, and **`rawbuf`** inside `flush()` showed `b=0000` — the buffer was
at offset 0, i.e. NULL — after an isolated `crc32("Hello",5)` test had already
proven the CRC routine itself computed `9a1ce165` correctly. Lesson: when a
routine "returns 0 for all inputs," suspect a **0-length / NULL-buffer** call,
not a miscompiled routine — and print the *pointer*, not just the length.

## Companion tuning needed to fit the 32 KB window

- `port/lowlevel.c`: set `_amblksiz = 16` in `wc_heap_init` — grownear rounds
  every heap grab up to `_amblksiz` (default 4–8 KB), so a 32 KB request rounds
  to 40 KB and overruns the ~35 KB arena. 16-byte granularity ≈ no waste.
- `-DINBUFSIZ=512` (OUTBUFSIZ follows) so the 2×2 KB SMALL_MEM I/O buffers
  shrink and coexist with the 32 KB window in the arena.

## Known ceiling (honest): DEFLATE does not fit

DEFLATE entries fail `not enough memory to inflate`: 32 KB window + inflate
`huft` tables (`inflate.c` `huft_build` mallocs, ~3 KB) + UnZip's **~22 KB of
`Far` message strings** (CONST/CONST2 in DGROUP) + globals + 512 B stack exceed
the single **64 KB small-model DGROUP** by a few KB (DGROUP measured 0xffba /
65466 with the arena maxed, 70 B free). Reclaiming it needs either far-segment
message strings (compact model — against the near-clib design) or stripping
messages (a generic-source edit — against the zero-edit rule). Left documented,
not worked around. STORED remains the proven, correct deliverable.

## Reusable gotchas

- **emu2 upper-cases the CP/M command tail** (`-l` → `-L`) — genuine CCP
  behaviour, not a port bug. Test the default *extract* action, not case-
  sensitive option letters.
- UnZip takes zip length from `stat().st_size` (`process.c` `G.ziplen`), so the
  clib `stat()` must return the **exact** byte length (see the LRBC diskio note),
  not the record-rounded size, or the EOCD scan derails.

## Canonical cpm86 stdlib (2026-08, follow-up)

`clibcpm.lib` (183 modules) is now the **canonical** `-bcpm86` C library, not
just an UnZip link-time input. `contrib/ravn/watcom-cpm86-libc/build-lib.sh`
installs it as `lib286/cpm86/clibs.lib` and `crt0.obj` as `cstartcpm.obj` —
the two files wlink's `system begin cpm86` block auto-links (`libfile
cstartcpm.obj` + auto-fetch of `clibs.lib` from `%WATCOM%/lib286/cpm86`). So a
bare `owcc -bcpm86 prog.c -o PROG.CMD` (after `. contrib/ravn/cpm86-clib/env.sh`)
links the whole library + real startup with **no explicit `library`/`file` on
the link line**. `env.sh` now also exports `INCLUDE` (clib/watcom/lib_misc
headers) so `<stdio.h>` etc. resolve with no manual `-I`.

Verified under emu2: `printf`, `malloc`/`free`, `strcpy`, and `time()`
returning a real Unix epoch via the `__getctime` BDOS seam (`gtctmcpm.c`).
The old 4-module proof-of-concept `contrib/ravn/cpm86-clib/build.sh`
(putchar/i4m/i4d/strlen) is **DEPRECATED/superseded** by build-lib.sh.
`lib286/cpm86/` is a `.gitignored` install dir — rerun build-lib.sh after clean.
(open-watcom-v2 master commit `0c95ddfb33`.)
