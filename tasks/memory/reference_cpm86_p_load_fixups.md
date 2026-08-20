# CP/M-86 P_LOAD fixups — EXACT format (all four sources cross-checked)

Authoritative, verified 2026-08-19 against the genuine Concurrent CP/M-86 2.0
loader source AND both of our reimplementations AND the wlink producer. Use this
as the single source of truth for the `.CMD` load-time relocation ("P_LOAD")
mechanism — do not re-derive it from the DRI manuals (they document only the
8087 bits of byte 0x7F, never bit 7).

Sources (paths in `/Users/ravn/z80`):
- PRODUCER: `open-watcom-v2/bld/wl/c/loadcpm86.c` (`cpm86WriteFixups`,
  `AddCPM86Fixup`, `CPM86GroupRelPara`, `cpm86GroupImgPara`) +
  `open-watcom-v2/bld/wl/c/obj2supp.c:1360-1381` (`FmtReloc` capture point).
- GENUINE OS (ground truth): `scratch/ccpm86-src/kern/load.sup` fixup loop
  `fx_chk` (~lines 418-449) + field defs `scratch/ccpm86-src/kern/cmdh.def:18-26`.
- CONSUMER 1: `open-watcom-v2/contrib/ravn/cpm86run_unicorn.py` `_apply_fixups`.
- CONSUMER 2: `emu2-cpm86/src/cpm86.c` (P_LOAD block, ~lines 585-644).

--------------------------------------------------------------------------------
## 1. Header signal (`cmdh.def:18-19`)
--------------------------------------------------------------------------------
Two fields in the 128-byte `.CMD` header:
- **byte 0x7F = `ch_lbyte`**: **bit 7 (0x80) set ⇒ fixup records present**
  (bit 6/5 = 8087 flags, ignore). If clear, there is NO relocation table; the
  program is loaded as-is.
- **word 0x7D..0x7E = `ch_fixrec`** (LE): **FILE RECORD number** of the fixup
  table. Byte offset in the file = `ch_fixrec * 128`.

--------------------------------------------------------------------------------
## 2. Fixup record — 4 bytes (`cmdh.def:23-26`, `fixlen = 4`)
--------------------------------------------------------------------------------
The table is a packed array of 4-byte records beginning at `ch_fixrec*128`,
**terminated by the first record whose byte 0 (`fix_grp`) == 0**:

    offset name       meaning
    +0     fix_grp    hi nibble = LOCATION group TYPE (word to patch lives here)
                      lo nibble = TARGET   group TYPE (whose load seg is ADDED)
    +1..2  fix_para   paragraph of the word WITHIN the location group's image (LE word)
    +3     fix_offs   byte offset 0..15 of the word within that paragraph

Group TYPE numbers (same numbering everywhere — header descriptor, base page,
these nibbles): **1=Code 2=Data 3=Extra 4=Stack 5,6,7,8=Aux 1..4**.

The absolute file/memory address of the target *word* is therefore
`(location_group_load_seg + fix_para) : fix_offs` — i.e. it is a normal
seg:offset where the segment is `loc_load_seg + fix_para` and the offset is the
`0..15` residue. (Splitting a flat byte position into `para = pos>>4`,
`offs = pos & 0x0F` is exactly how the producer encodes it.)

--------------------------------------------------------------------------------
## 3. What the word HOLDS before relocation (the "group-relative paragraph")
--------------------------------------------------------------------------------
The far **segment** word the linker leaves in the image is **not** a final
segment — it is the TARGET object's **offset, in paragraphs, within its own
group's `.CMD` image** (`CPM86GroupRelPara` → `cpm86GroupImgPara(target)`).
At load time the loader ADDS the target group's runtime load segment, turning
the group-relative paragraph into an absolute segment. The matching **offset**
part of the far pointer is already final at link time — only FIX_BASE (segment)
fixups get a record; offset-only fixups were resolved in `PatchData` and never
reach the P_LOAD capture.

--------------------------------------------------------------------------------
## 4. Loader algorithm — GENUINE OS (`load.sup` fx_chk, AUTHORITATIVE)
--------------------------------------------------------------------------------
    test lod_lbyte,80h ; jz init_base      ; skip entirely if 0x7F bit7 clear
    ; read record #lod_fixrec (128 bytes) into lod_dma
    fx_chk:
      al = fix_grp[bx] ; test al,al ; jz init_base   ; byte0==0 ENDS the table
      dx = ldt_start[ tblsrch(al & 0x0F) ]           ; target group load seg
      ax = ldt_start[ tblsrch(al >> 4)   ]           ; location group load seg
      ax += fix_para[bx]                             ; -> absolute paragraph
      es = ax ; di = fix_offs[bx]                    ; (di zero-extended byte)
      add es:[di], dx                                ; THE fixup: 16-bit add
      bx += 4 ; if end of 128-byte record: inc lod_fixrec; read next record

Key genuine-loader facts:
- Groups are matched by **TYPE** (`tblsrch` compares `ldt_type`), then
  `ldt_start` gives that group's actual load paragraph. So the nibbles name
  TYPES, not table indices.
- The operation is a **16-bit ADD into the existing word** (`add es:[di],dx`),
  never a store — the word must already hold the group-relative paragraph.
- **Terminator is `fix_grp == 0` (byte 0 alone)**, tested before each record.
  It is read record-by-record (128 B at a time) and continues across record
  boundaries.

--------------------------------------------------------------------------------
## 5. Producer — wlink (`loadcpm86.c` / `obj2supp.c`)
--------------------------------------------------------------------------------
- CAPTURE (`obj2supp.c` `FmtReloc`, MK_CPM86 branch): for every `FIX_BASE`
  relocation call `AddCPM86Fixup(loc_addr.seg, loc_addr.off + OffsetSizes[...],
  target.seg)` and return `false` (suppress the generic reloc record — our own
  table carries it). The seg word sits right after the offset part (mirrors
  `MakeBase`).
- EMIT (`cpm86WriteFixups`, runs BEFORE `DBIWrite` so `ch_fixrec` is stable):
    table_pos = NullAlign(128);  fixrec = table_pos / 128;
    per fixup:
      loc_flat = cpm86GroupImgPara(loc_grp) * 16 + loc_off;   // flat byte pos
      para     = loc_flat >> 4;
      rec[0]   = (cpm86GroupCmdType(loc_grp) << 4) | (cpm86GroupCmdType(tgt_grp) & 0x0F);
      rec[1]   = para & 0xFF;  rec[2] = para >> 8;
      rec[3]   = loc_flat & 0x0F;
    then a 4-byte all-zero terminator; pad table to 128;
    header[0x7D]=fixrec_lo; header[0x7E]=fixrec_hi; header[0x7F] |= 0x80;
- `cpm86GroupImgPara(group)` = the group's paragraph offset in the packed `.CMD`
  IMAGE = running sum of `CMD_PARAS(CalcGroupSize())` over preceding same-image
  groups (all CODE coalesced into one; DGROUP → 0; each EXTRA → sum of preceding
  EXTRA images). **NOT the wlink frame number** — frames increment by 1 per
  segment while images are paragraph-packed; using the frame mislocated every
  multi-paragraph function's far word. That was THE Stage B bug (fixed; see
  `reference_stageb_farcode_reloc_verified.md`).

--------------------------------------------------------------------------------
## 6. Consumers — our two reimplementations (must stay byte-faithful)
--------------------------------------------------------------------------------
- `cpm86run_unicorn.py` `_apply_fixups`: reads the whole table linearly from
  `data[0x7D|0x7E<<8]*128`; `group_seg` keyed by TYPE number (1..8);
  `val = (word + tgt_seg) & 0xFFFF`, written back at
  `((loc_seg + para) << 4) + offs`. **Raises** on an undefined-group nibble.
- `emu2-cpm86/src/cpm86.c`: identical math; `grp_seg[1..8]` =
  code/data/extra/stack/aux1..4; **skips** (does not abort) an undefined-group
  record. Reads each 4-byte record via `fseek(f, pos, SEEK_SET)`.
- **Terminator discrepancy (harmless, but know it):** both reimplementations
  stop on an **all-4-bytes-zero** record; the genuine loader stops on
  **byte0==0 alone**. These agree in practice because a valid record always has
  location-group-type ≥ 1 in the high nibble, so `fix_grp` is never 0 for a real
  record. `fix_grp==0` is the authoritative terminator.

--------------------------------------------------------------------------------
## 7. DO NOT confuse: header descriptor (9 B) vs base-page descriptor (6 B)
--------------------------------------------------------------------------------
Two different structures use the same TYPE numbering — a frequent trap:
- **`.CMD` header group descriptor = 9 bytes** (`cmdh.def`): `ch_form`(type,1) +
  `length`(2) + `base`(2) + `min`(2) + `max`(2) paragraphs. Up to 8, at file
  offset 0. This is what the linker writes and what
  `reference_cpm86_cmd_header_ccpm_source.md` decodes.
- **Base-page group descriptor = 6 bytes** (`basep.fmt`, built by
  `load.sup:init_base`; see `emu2-cpm86/src/cpm86.c` base-page block): byte
  length **24-bit at +0..2 (in BYTES)** + segment word at +3..4 + model flag at
  +5. Laid out at DS:0x00 in the order code, data, **extra @ 0x0C**, stack @
  0x12, aux @ 0x18.. . `port/farheap.c` reads the EXTRA descriptor here
  (`DS:0x0C` byte-length, `DS:0x0F` segment). Turbo Pascal reads the same slot
  to size its heap.

--------------------------------------------------------------------------------
## 8. Status (2026-08-19)
--------------------------------------------------------------------------------
- Producer + both consumers verified: `__far` repro prints `FARDATA-OK`;
  compact-model far GLOBALS now read correctly under Unicorn (`__heap_enabled`
  reads 1, a far `int g=0x1234` reads 0x1234) — the checkpoint-037 "far globals
  read 0" blocker is GONE with the type-3 EXTRA far-data fix (commit
  `09c2eb3099`, see `reference_wlink_cpm86_far_data_type3.md`).
- OPEN: compact far HEAP still mis-integrates — `port/farheap.c` carves from
  EXTRA offset 0, colliding with the program far data that now lives at the
  start of the same type-3 EXTRA group; and the base-page EXTRA descriptor it
  reads did not reflect the real load length in one probe. Needs the far heap to
  start AFTER the program's far-data portion (EXTRA G_MIN), or a separate group.
