---
name: Native wlink FORMAT CPM86 — Watcom emits CP/M-86 .CMD directly (phase 1, MAME-verified)
description: Open Watcom wlink now has CP/M-86 as a first-class output target (`format cpm86`); DR C LINK-86 and Aztec C dropped. Phase 1 = small model only, MAME-verified on RC759.
metadata:
  type: reference
---

**Direction change (user, 2026-08-15):** dropped BOTH DR C (LINK-86 v1.4) and
Aztec C. Goal is now to give **Open Watcom itself** CP/M-86 as a platform, as
completely as possible. So the canonical CP/M-86 toolchain is a SINGLE Watcom
pipeline — `wcc → wlink FORMAT CPM86 → .CMD` — with no foreign linker and no OMF
"classicize" normalization step. DR C LINK-86 is now oracle/history only
(supersedes the external-linker approach in `reference_watcom_drc_abi_bridge`).

**Native `FORMAT CPM86` writer — MAME-verified on RC759 (copilot, 2026-08-15).**

Implementation in `scratch/open-watcom-v2` (⚠ two OW trees exist — root
`open-watcom-v2/` and `scratch/open-watcom-v2/`; the wlink work was uncommitted
in the scratch tree as of 2026-08-15, confirm which is canonical before building):
- New files: `bld/wl/c/{cmdcpm86.c,loadcpm86.c}` + `bld/wl/h/{cmdcpm86.h,loadcpm86.h}` (~301 lines).
- Hooks into existing linker: `cmdall.c`, `cmdline.c`, `loadfile.c`, `msg.c`,
  `_formats.h`, `formats.h`, `ldefext.h`, `wlinkcfg.h`, `lnk/specs.sp`,
  `wlobjs.mif`, `setvars.sh`.
- Format id: `MK_CPM86 = 0x00200000` (id 21) in `_formats.h`; in `MK_16BIT`.
- `specs.sp`: `system cpm86` → `ARCH i86 -bt=cpm86`, `libpath %WATCOM%/lib286/cpm86`, `format cpm86`.

**Phase 1 scope (`cmdcpm86.c` / `loadcpm86.c`):**
- **small model ONLY** = separate CODE (type 1) + DATA (type 2) groups. This is
  the only validated (MAME-verified) memory model.
- **8080 single-group model is REJECTED** — `Proc8080()` fatals
  (`MSG_FORMAT_BAD_OPTION "8080"`); only validated models are accepted (user's
  "reject unvalidated 8080 model", workspace commit `e411278`).
- Emits base=0 relocatable images, **no fixup table** (header 0x7F bit 7 clear).
- Large model + fixups = future phase 2.

**.CMD layout the writer produces** (see also `reference_cpm86_cmd_header`):
128-byte header = up to 8 × 9-byte group descriptors
`db type; dw length(paras); dw base; dw min(paras incl BSS); dw max`, then group
images. **Critical: group images pack at PARAGRAPH (16-byte) granularity, NOT
128-byte record** — the loader finds the next group at `base + length*16`.
Padding an image to a 128-byte record while declaring only the paragraph length
left every following group's data 0..112 bytes past where the loader reads it
(→ all zero). `FiniCPM86LoadFile()` pads each image with `PadLoad(-img_len & 15)`.
Debug info (`DBIWrite()`) is appended AFTER the images (loader ignores trailing
bytes), then the 128-byte header is seeked-back and written last.

**How to build normally (PROVEN 2026-08-15, emu2-verified).** The one-command
native path is `wcl -l=cpm86 -0 -ms <opt> SRC.c -fe=OUT.cmd` → running .CMD. No
DR C, no hand-invoked wlink, no bridge. Three env pieces the driver needs (each
was the cause of an earlier failure):
1. **`WLINK_LNK`** → `<OW>/bld/wl/lnk/osxa64/wlink.lnk` — the *generated* systems
   file that actually contains `system cpm86` (from `specs.sp` via `wsplice`).
   Without it wlink says `undefined system name: cpm86` and falls back to DOS.
   (The built wlink BINARY does not carry systems; it reads this .lnk at runtime.)
2. **`WATCOM`** → a staging root with `lib286/cpm86/{clibs.lib,cstartcpm.obj}`
   (the Watcom-native cpm86 clib + small-model crt0). `system cpm86` in specs.sp
   does `libpath %WATCOM%/lib286/cpm86` + `libfile cstartcpm.obj`. Install via
   `scratch/rc759-cmd-toolchain/cpm86-clib/build-and-install.sh` (assembles
   `wlink-cmd-test/crt0sm.asm` → `_cstart_`/`_small_code_`, copies `clibs.lib`).
   Missing → `_cstart_`/`_small_code_` undefined.
3. wcc/wasm/wlink symlinks (bare names) on PATH so the `wcl` driver finds them.
Reproducible wrapper: `scratch/rc759-cmd-toolchain/wcc-cpm86.sh SRC OUT [flags]`.
Built tools used = the SCRATCH OW tree (bld/*/osxa64); its cpm86 SOURCE is
byte-identical to the root tree's committed cpm86 work (556027a191), so it *is*
the latest source, just already built. Benign link warnings: W1080 (16-bit obj)
and W1023 (no start address → uses 0001:0000; CMD still runs).

**Both drivers work** (emu2-verified 2026-08-15): `wcl -l=cpm86 …` (Watcom
syntax) and `owcc -bcpm86 -mcmodel=s -O2 …` (gcc-style). owcc needs its
`specs.owc` (which carries `system begin cpm86 / ARCH i86 -bt=cpm86 / end`) ON
PATH — `FindPath()` = `_searchenv(name,"PATH")` does NOT search owcc's own exe
dir, so a bare invocation fails "Unable to find 'specs.owc'". The wrapper copies
`bld/wcl/owcc/osxa64/specs.owc` into its PATH dir; both drivers then produce a
running .CMD.

Related: `[[reference_watcom_cpm86_startup_initfini]]` (crt0/clib retarget),
`[[reference_watcom_cpm86_diskio]]`, `[[reference_cpm86_cmd_header]]`.
