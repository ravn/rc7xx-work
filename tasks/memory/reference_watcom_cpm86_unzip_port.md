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

## BDOS directory API: opendir/readdir/closedir/rewinddir (2026-08, follow-up)

`port/dirent.c` (in `contrib/ravn/watcom-cpm86-libc/`) implements the POSIX
directory-scan API for `-bcpm86`, backed by BDOS Search First/Next (fn 17/18).
It fills Watcom's own `<dirent.h>` `struct dirent` — on DOS/CP/M `DIR` and
`struct dirent` are the SAME type (`typedef struct dirent DIR;`), so the private
handle puts `struct dirent` FIRST (DIR* == malloc block => closedir frees it).

**Key gotcha (CP/M FCB has no `*`):** BDOS matches only with `?` per name(8)/
type(3) position; a literal `*` in an FCB is byte 0x2A, not a wildcard. So the
DOS/Unix `*` is expanded in `pattern_to_fcb()` — within a field `*` fills the
REST of that field with `?`: `*.C`→name"????????" type"C  "; `FOO*.?`→
name"FOO?????" type"?  ". A field with no `*` that ends early is SPACE-padded =
exact-length match (correct CP/M semantics). `"."`/`""`/bare drive/trailing sep
⇒ match-all (`????????`+`???`).

Other design points: single global BDOS search cursor (F_SNEXT continues the
last F_SFIRST) — a DIR is only valid for a tight opendir→readdir*→closedir loop
with no intervening file I/O. Multi-extent files (>16 KB) reported once by
skipping entries whose EX(byte12)/S2(byte14) are non-zero. d_attr set from the
high bits of the 3 type bytes (R/O=_A_RDONLY, SYS=_A_SYSTEM, ARCH=_A_ARCH);
size/time stay 0 (plain CP/M 2.2 dir entry has none — use stat()).

Verified under emu2 (`scratch/cpm86-tools/emu2-cpm86/emu2`, NOT a PATH emu2):
`*.*`→all, `*.C`→only .C (.OBJ excluded), `*.TXT`→1, `FOO.*`→both FOO.*, exact
`FOO.C`→1, and a 20 KB multi-extent `BIG.DAT` listed exactly once. Wired into
build-lib.sh (compile + `wlib` archive list) so the canonical `clibs.lib` now
exports opendir/readdir/closedir/rewinddir. This closes the ONLY real stdlib gap
for a future store-only Zip 3.0 port (unix/unix.c OS layer needs opendir/readdir).
(open-watcom-v2 commit `c7e23e2ddc`.)
