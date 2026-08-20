---
name: reference_cpm86_emu2_p_load_reloc
description: emu2-cpm86 now implements CP/M-86 P_LOAD load-time relocation (closes issue #1); runs wlink medium/compact .CMDs AND keeps DR C self-reloc working
metadata:
  type: reference
---

# emu2-cpm86: P_LOAD load-time relocation implemented (2026-08-20, closes #1)

`emu2-cpm86` commit `b5b1a48` (branch `local/cpm86`) adds P_LOAD relocation to
the CP/M-86 loader (`src/cpm86.c cpm86_load_cmd`). If header byte 0x7F bit 7 is
set, it seeks to record `ch_fixrec` (header word 0x7D, ×128 = byte offset) and
walks the packed 4-byte fixup records `[grp-nibbles][para:2 LE][byte:1]` until
the first all-zero record, doing `word += target_group_load_seg` — a faithful
port of genuine CCP/M-86 2.0 `load.sup:405-449` (`add es:[di],dx`) and of
`cpm86run_unicorn.py _apply_fixups`. Group segments reuse the ones emu2 already
computes for the base page (code/data/extra/stack + aux 5..8). See
`[[reference_cpm86_p_load_fixups]]`.

**Effect:** emu2 now runs Open Watcom `wlink format cpm86` PURE-loader-reloc
output (medium far code via `-mm -zm`; compact type-3 EXTRA far data) that ships
NO crt0 self-reloc walker. Before, only the Unicorn runner could — emu2 could not
relocate, so it was small-model-only.

**DR C coexistence is safe (no double-relocation):** genuine DR C `.CMD`s also
set byte-127 bit 7, but their CLEARL crt0 self-relocates UNLESS a guard immediate
(itself a fixup target) is made nonzero — the guard-coordinated dual mechanism in
`[[reference_drc_cpm86_reloc_mechanism_VERIFIED]]`. Because emu2 now applies the
fixups, that guard is set, the crt0 walker stands down → single relocation.
Verified: LL_s/LL_l/MT_l (DR C, bit 7 set, ~38 KB) still pass under the new emu2.

**Regression test:** `tests/cpm86-reloc/run.sh` + two tiny vendored wlink oracles
`FARMULTI.CMD` (far call across coalesced *_TEXT, 512 B) and `FARPTR.CMD` (far
data ptr into type-3 EXTRA, 768 B); each prints `OK!` only if the loader
relocated the cross-group reference. `EMU2=... bash tests/cpm86-reloc/run.sh`.

**Downstream:** un-blocks the all-models disk test — `run-all-models.sh` disk now
PASSes in s, m AND c under emu2 (`[[reference_cpm86_clib_all_models_gate]]`), full
12/12 green. Also the path to a full UnZip runtime-CRC check under emu2 (was
blocked on this; see `[[reference_wlink_cpm86_far_data_type3]]`).

Build: `cd emu2-cpm86 && make` (LTO, `-Werror=implicit-function-declaration`).
