# Stage B implementation plan — pure loader-relocation in wlink CP/M-86 output

**Status:** planning (2026-08-19). Prereq work (mechanism verification) DONE — see
`[[reference_drc_cpm86_reloc_mechanism_VERIFIED]]`. Model LOCKED by user
2026-08-19: **pure loader-relocation** — wlink emits the `.CMD` fixup table +
header byte-127 bit 7 + `ch_fixrec`, and ships **NO** crt0 self-relocation. The
output relocates only on a loader that applies P_LOAD fixups (genuine CCP/M-86
does; emu2 does not yet — `ravn/emu2-cpm86#1`; real-oracle verification
`ravn/rc7xx-work#15`).

This plan supersedes the "Concrete wlink implementation spec" bullets in
`[[reference_drc_cpm86_reloc_format]]` and Phase B2 of
`[[tasks/plan-cpm86-big-model-2026-08-18]]` with concrete file:line anchors.

---

## 0. Toolchain of record (VERIFIED) — what actually exercises loadcpm86.c

The DELIVERABLE path is **`owcc -bcpm86 prog.c -o prog.cmd`** → fork wcc (i86,
`-bt=cpm86`) → fork **wlink `format cpm86`** → `bld/wl/c/loadcpm86.c`. Built
linker: `open-watcom-v2/rel/armo64/wlink`. owcc/wcc/wasm/wlink are located via
`PATH` + a `specs.owc`; see `scratch/rc759-cmd-toolchain/wlink-cpm86-plan.md`
(Phase 3, clib linkage DONE 2026-08-14; small-model C already boots on RC759 in
MAME and runs under emu2).

**NOT this path:** `scratch/rc759-cmd-toolchain/cc-cpm86.sh` links with **DR C's
own LINK-86** (bwcc → classicize → LINK86.CMD). It never touches wlink and is
irrelevant to Stage B. Do not confuse the two.

Large model needs the fork wcc to emit `-mm`/`-ml` i86 objects; per
`[[reference_cpm86_big_model]]` `-mm` alone gives the right multi-segment
codegen. Phase B validation starts with a hand-written far-pointer object /
small C case, not full large-model clib.

---

## 1. How relocation flows today (VERIFIED, `bld/wl/c/obj2supp.c`)

Pass 2 walks each fixup: `Relocate()` → `FmtReloc()` (obj2supp.c:1752) →
`formatBaseReloc()` (1338) which is a big per-format `#ifdef` chain, then
`DumpReloc()` (681) → `WriteReloc()` (reloc.c:170) appends a `reloc_item` to
`group->reloclist`; the format's load writer later dumps that list.

- **A far-pointer SEGMENT (base) fixup** is what we must intercept: `FIX_BASE`
  set, target in another group. For **CP/M-86 there is currently NO branch** in
  `formatBaseReloc`, so it **falls through to the DOS tail** (obj2supp.c:1742):
  `MakeBase(fix); breloc.item.dos.addr = {off, seg = group->grp_addr.seg}`. That
  reloc is written to `group->reloclist` but **loadcpm86.c never dumps the
  list**, so today the segment word is simply left at its link-time value
  (`grp_addr.seg`) and no fixup reaches the file. THIS is the gap.
- **Group index helper already exists:** `FindGroupIdx(segment)`
  (obj2supp.c:705) returns the 1-based index of the group whose `grp_addr.seg`
  matches — i.e. **exactly the CP/M-86 target/location group nibble**.
- **Link-time group segments** (`objcalc.c setGroupSeg` :221): CP/M-86 falls to
  the default `grp_addr.seg = seg_num`, so CODE=1, DATA=2, EXTRA=3, STACK=4,
  aux=5.. Each group's `grp_addr.off = 0` (AllocFileSegs). So a far pointer's
  stored segment word already equals the TARGET group's small index and its
  offset is within-group — **need to confirm empirically** (Phase B0) whether
  the stored paragraph is group-relative (loader wants: stored = paragraphs from
  group base; loader adds actual load seg of that group).

## 2. The CP/M-86 fixup record (AUTHORITATIVE, `kern/cmdh.def`)

4-byte record: `{ fix_grp:byte, fix_para:word LE, fix_offs:byte }` where
`fix_grp` hi nibble = LOCATION group (where the word to patch lives), lo nibble
= TARGET group (whose actual load segment the loader adds). Loader
(`load.sup:405-449`): `test ch_lbyte,80h`; per record `add es:[loc_para*16 +
loc_offs], target_group_load_seg`. Table located via header word 0x7D
(`ch_fixrec` = FILE RECORD number, 128-byte units), byte 0x7F bit 7 = present.

---

## 3. Implementation phases

### Phase B0 — empirical baseline (NO code change; do FIRST)
1. Build the smallest far-pointer test with the fork toolchain:
   `owcc -bcpm86` on a C file holding a global far function pointer + a far data
   pointer (or hand-write an i86 `.asm` with two inter-group far pointers).
2. Dump the resulting `.CMD` with
   `scratch/rc759-cmd-toolchain/mame-tests/reloc_probe.py`. Record: what segment
   word is stored for each far pointer (expect the link-time group index 1/2),
   whether `header[0x7F]` bit7=0 and `ch_fixrec`=0 today, group layout/offsets.
3. This fixes the exact "stored value" contract (group-relative paragraph vs.
   absolute) before writing emit code. **Gate:** we know precisely what bytes
   change between "today" and "correct".

### Phase B1 — coalesce CODE-class groups into ONE type-1 descriptor (independent)
`loadcpm86.c FiniCPM86LoadFile` (:79) currently emits one descriptor per wlink
group. Large model may present multiple CODE-class groups; CP/M-86 wants ONE
type-1 Code descriptor (LINK-86 `CODE[SEGMENT[..],CLASS[..],GROUP[..]]`).
- Group the `Groups` ring by `class->flags & CLASS_CODE`; concatenate their
  images paragraph-aligned into one descriptor; likewise one type-2 DATA.
- Audit `CMD_PARAS`/`CalcGroupSize` handle "one descriptor, many concatenated
  segments" (summary flagged; audit don't assume).
- Independent of the fixup question — needed for large model regardless. Small
  model (single CODE + single DATA) is already correct; keep it byte-identical.

### Phase B2 — intercept far-segment fixups → CP/M-86 fixup records
Add the missing CP/M-86 branch so base fixups become CP/M-86 records instead of
falling into the DOS tail.
1. `h/reloc.h` (:163 union): add `cpm86_reloc_item { unsigned_8 grp; unsigned_16
   para; unsigned_8 offs; }` (4 bytes, packed) to the `reloc_item` union.
2. `c/reloc.c SetRelocSize` (:457): add `if( FmtData.type & MK_CPM86 ) {
   FmtRelocSize = sizeof(cpm86_reloc_item); return; }`.
3. `c/obj2supp.c formatBaseReloc` (:1338): add, before the DOS tail, a
   `#ifdef _CPM86 if( FmtData.type & MK_CPM86 )` branch that builds the record:
   - `loc_grp = FindGroupIdx( seg->u.leader->group->grp_addr.seg )` (location).
   - `tgt_grp = FindGroupIdx( fix->tgt_addr.seg )` (target group being pointed
     at). Reject/skip fixups whose target isn't a real group (index 0).
   - `breloc->item.cpm86.grp = (loc_grp<<4) | tgt_grp;`
     `para = (fix->loc_addr.off - group->grp_addr.off) >> 4; offs = ...&0xF`
     (confirm the para/offs split against Phase B0 dump).
   - **Stored image value:** the segment word must be TARGET-group-relative
     paragraphs so loader `add`s the real seg. Phase B0 tells us whether wlink
     already stores that (grp_addr.seg small index → likely subtract
     `tgt group grp_addr.seg`). Patch the stored word here if needed
     (`MakeBase` currently bakes in the link-time seg — for CP/M-86 we want
     group-relative, so replace/adjust rather than call the DOS `MakeBase`).
   - `return true` so `DumpReloc`→`WriteReloc` records it in `group->reloclist`.
4. `c/reloc.c WriteReloc` (:170): CP/M-86 uses the DOS-style default tail (append
   to `group->reloclist`, `section->relocs++`) — confirm it isn't shadowed by an
   earlier `#ifdef` return; if the plain tail already appends, no change needed.

### Phase B3 — emit the table + header flags in loadcpm86.c
In `FiniCPM86LoadFile` (:79), after writing group images (and before rewriting
the header), model on `loaddos.c WriteDOSRootRelocs` (:53):
1. Pad the file to the next 128-byte RECORD boundary; that record number =
   `ch_fixrec`.
2. Walk the accumulated reloc list(s) (all groups) and write each 4-byte
   `cpm86_reloc_item` LE. Use `DumpRelocList`/`WalkRelocList` (reloc.h) or a
   direct `WriteLoad` loop.
3. Set `header[0x7D..0x7E] = ch_fixrec` (record number, LE) and `header[0x7F] |=
   0x80`.
4. **DBIWrite ordering:** debug info must go AFTER the fixup table so it never
   shifts `ch_fixrec` (the comment at loadcpm86.c:158 already warns this). Move
   `DBIWrite()` to after the table emit, or emit the table before DBIWrite and
   record its record number.
5. Small model with zero cross-group far pointers must still emit bit7=0 /
   `ch_fixrec`=0 (byte-identical to today) — only emit the table when records
   exist.

### Phase B4 — build + verify
1. Rebuild fork wlink (Docker Open Watcom build or the native `rel/armo64`
   build used to produce the current `wlink`). Confirm the small-model C proof
   case is byte-identical (no regression).
2. Rebuild the Phase B0 far-pointer test; dump with `reloc_probe.py`: assert
   `header[0x7F]&0x80`, `ch_fixrec` points at the table record, and each record
   names the right (loc,tgt) groups + para/offs.
3. **Runtime oracle:** run under emu2 ONLY after `ravn/emu2-cpm86#1` (P_LOAD
   reloc) lands — until then emu2 can't relocate our pure-loader output. The
   authoritative check is genuine CP/M-86 in MAME (RC759, per
   `ravn/rc7xx-work#15`): the far call/segment test must print its success token
   with correctly relocated pointers. Carry the "untested on early CP/M-86
   loader editions" caveat until that passes.

---

## 4. Risks / open questions (resolve in B0/B2)
- Exact para/offs split and whether the stored segment word is already
  group-relative (B0 dump decides; the DOS `MakeBase` bakes in link-time seg, so
  CP/M-86 likely needs its own store, not `MakeBase`).
- Multiple CODE groups → one descriptor changes group indices seen by
  `FindGroupIdx`; keep B1 (coalescing) and B2 (indices) consistent — a far
  pointer into a coalesced CODE super-group must resolve to that one descriptor's
  index.
- `reloclist` is per-group; ensure the emit walks ALL groups' lists in a stable
  order and that offsets are file-absolute-correct within each group image.
- Aux/type-8 group: NOT needed in the pure-loader model (that was DR C's
  self-reloc buffer). Do not emit it.

## 5. Definition of done
- `owcc -bcpm86` on a cross-group far-pointer program emits a `.CMD` with a
  correct fixup table (bit7 + ch_fixrec + records), verified by `reloc_probe.py`.
- Small-model regression: byte-identical to pre-Stage-B output.
- Runtime: correct far-pointer behaviour under genuine CP/M-86 in MAME
  (`ravn/rc7xx-work#15`); emu2 once `ravn/emu2-cpm86#1` lands.
