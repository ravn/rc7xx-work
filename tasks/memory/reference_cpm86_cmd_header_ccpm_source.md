# CP/M-86 / Concurrent CP/M-86 `.CMD` header — AUTHORITATIVE (OS source, 2026-08-19)

The complete `.CMD` command-file header format, grounded in the **genuine
Digital Research Concurrent CP/M-86 2.0 operating-system source** (July 5 1983),
downloaded from `https://www.cpm.z80.de/download/ccpm8620.zip` and unpacked at
`scratch/ccpm86-src/` (see `[[reference_cpm_dri_source_archive]]`). This is the
authoritative complement to `[[reference_cpm86_cmd_header]]` (which is written
from the Siemens/DRI *manuals* + measured RC759 register state). Where the
manuals are silent (byte 127 bit 7, the fixup table), THIS source is ground
truth — it is the code the RC759's OS family actually runs.

Cross-checked throughout against real DR C 1.11 artifacts in
`scratch/rc759-cmd-toolchain/mame-tests/` (`LL_l.CMD`, `MT_l.CMD`, `LL_s.CMD`).

Primary source files:
- `scratch/ccpm86-src/kern/cmdh.def` — *"Command Header Format and Load Fixup
  Records"*: the group-descriptor + fixup-record field offsets.
- `scratch/ccpm86-src/kern/load.sup` (902 lines) — the transient Program-Load
  supervisor routine (`load:` / `load_ent:`): reads the header, allocates
  memory, loads group images, applies fixups, builds the base page, sets entry
  registers.
- `scratch/ccpm86-src/kern/basep.fmt` — the base-page layout the loader writes.
- `scratch/ccpm86-src/kern/mpb.def` — memory-flag attribute bits.

---

## 1. The 128-byte header record — byte map

    offset  size  field       meaning
    ------  ----  ----------  --------------------------------------------------
    0x00     9    GD 0        group descriptor 0   (ch_form/length/base/min/max)
    0x09     9    GD 1        group descriptor 1
    0x12     9    GD 2        ...
    0x1B     9    GD 3
    0x24     9    GD 4
    0x2D     9    GD 5
    0x36     9    GD 6
    0x3F     9    GD 7        group descriptor 7   (last of ch_entmax = 8)
    0x48    53    (unused)    0x48..0x7C reserved / zero
    0x7D     2    ch_fixrec   fixup-table start RECORD number (word, LE)
    0x7F     1    ch_lbyte    flag byte; bit 7 = fixups present (see §4)

`ch_entmax equ 8` (`cmdh.def:15`) — at most 8 group descriptors. The header is
exactly one 128-byte record; group images follow immediately.

---

## 2. Group descriptor (9 bytes) — `cmdh.def:8-13`

    ch_form    equ byte ptr 0                    ; 0x00  G_Type (1 byte)
    ch_length  equ word ptr (ch_form + byte)     ; 0x01  paragraphs of stored image
    ch_base    equ word ptr (ch_length + word)   ; 0x03  A_Base: abs load paragraph
    ch_min     equ word ptr (ch_base + word)     ; 0x05  min paragraphs to allocate
    ch_max     equ word ptr (ch_min + word)      ; 0x07  max paragraphs to allocate
    chlen      equ ch_max + word                 ; = 9 bytes total

All multi-byte fields little-endian; all sizes in **16-byte paragraphs**. A
`ch_form` of 0 terminates the descriptor list (`load.sup:180` `cmp ch_form,0 !
jne ch_doit`).

### G_Type values (`ch_form`)

    1  Code          4  Stack        7  Aux 3
    2  Data          5  Aux 1        8  Aux 4
    3  Extra         6  Aux 2        9  Pure / Shared Code

Type **9** (shared/pure code): on **Concurrent CP/M** the loader rewrites it to
type 1 and flags the memory `mf_code` (`load.sup:229-237`, the `if ccpm` branch);
on **MP/M** it additionally sets `mf_share` and threads it onto the shared-code
list via `get_sh` (`load.sup:203-217`, the `if mpm` branch). Pure code must be
read-only to be shared. (Relevant to the open G-Type-9 TODO in
`[[tasks/plan-cpm86-big-model-2026-08-18]]`.)

### A_Base (`ch_base`) — absolute vs relocatable

`ch_base != 0` ⇒ **absolute** group: the loader allocates memory at that fixed
paragraph (`load.sup:243` `cmp ldt_start,0 ! je ...`, else `f_malloc` at the
requested address). `ch_base == 0` ⇒ **relocatable**: the loader picks the load
segment. Every shipping RC759 program sampled, and all DR C output, uses
`ch_base = 0` (fully relocatable).

### G_Min / G_Max (`ch_min` / `ch_max`)

`ch_min` = minimum paragraphs the loader MUST provide or the load fails;
`ch_max` = ceiling. If `ch_max == 0` the loader substitutes `ch_min`
(`load.sup:190-193` `setmax`). The loader first satisfies every group's `ch_min`,
then spreads remaining free memory across groups that asked for more, up to each
`ch_max` (`load.sup:302-345`, the `ls_more` / `lsl_mre` spread loops). This is
why `OPTION FARHEAP` uses `G_Min = 1`, `G_Max = size` — "use up to this much of
whatever is actually free" (see `[[reference_cpm86_cmd_header]]`).

---

## 3. Memory model is IMPLICIT in which group types are present

The loader never stores a "model" field; it infers behavior from the descriptors
(`load.sup` + CP/M-86 System Guide §2.2-2.5):
- Code group only ⇒ **8080 model** (CS=DS=SS=ES equal; entry IP = 0x100).
- Code + Data only ⇒ **Small model**.
- Code + Data + any of Stack/Extra/Aux ⇒ **Compact / Large model**.

---

## 4. Byte 127 (`ch_lbyte`, 0x7F) and the fixup mechanism

    ch_lbyte  equ byte ptr 07fh   ; MSB bit in CH_LBYTE          (cmdh.def:18)
    ch_fixrec equ word ptr 07dh   ; signals fixup records start
                                  ; at record number in CH_FIXREC (cmdh.def:19)

### Bit assignments in byte 127

| bit | mask | meaning | source |
|-----|------|---------|--------|
| 7 | 0x80 | **Load-time fixup records present** | CCP/M 2.0 `cmdh.def:18` + `load.sup:405` (authoritative) |
| 6 | 0x40 | Optional 8087 support | Concurrent CP/M-86 PRG §3.1.2 ("Program Flag") |
| 5 | 0x20 | 8087 required | Concurrent CP/M-86 PRG §3.1.2 |
| 0-4 | — | unused / reserved | — |

**Source caveat (verified 2026-08-21):** in this CCP/M-86 2.0 `kern/` source only **bit 7 is acted upon** — `load.sup:173` saves the flag byte to `lod_lbyte`, `load.sup:404` does `test lod_lbyte,80h`/`jz init_base` (fixups). There is NO `test lod_lbyte,20h`/`40h` anywhere; `lod_lbyte` is referenced only at those two lines. The 8087 subsystem exists as data (`pf_8087 equ 08000h` `pd.def:112`, `u8087len`, `owner8087`, `ndp8087`) but the dispatch save/restore in `dsptch.rtm` is fully commented out, and nothing wires header bit 5/6 to `pf_8087`. So bits 5/6 are DOCUMENTED (Concurrent PRG §3.1.2) but NOT enforced in this loader snapshot (8087 support stubbed). Only `kern/` was searched.

**Cross-version update (verified 2026-08-21):** the newer **CCP/M-86 v3.1** source (cached `scratch/ccpm31-src/`, `ccpmv31.zip`) DOES enforce the 8087 bits — 2.0 was simply an incomplete snapshot. 3.1 `D2/CMDH.DEF` gives the authoritative masks: `opt_8087 equ 040H` (bit 6), `need_8087 equ 020H` (bit 5), plus a NEW `susp_mode equ 008H` (bit 3 = suspend if background task). 3.1 `D1/LOAD.SUP` actively tests them: `ndpchk:` `test ch_lbyte[bx],need_8087`/`test ch_lbyte[bx],opt_8087` (l.109-122), checks `owner_8087`, sets `lod_ndp`, wires `or p_flag[bx],pf_8087` (l.585), and allocates the long/emulator UDA (`u8087len`/`em87len`). So bit map is stable across versions; only the enforcement differs (2.0 acts on bit 7 only; 3.1 acts on bits 3/5/6/7). 

The DRI *manuals* call byte 127 the "Program Flag" but document only the 8087
bits 5/6 — they never mention bit 7. Bit 7 = fixups is documented ONLY in the OS
source. (An earlier note wrongly downgraded bit 7 to "observed, not documented"
after checking only emu2; the genuine OS source settles it — bit 7 IS the fixup
flag and the LOADER acts on it.)

### `ch_fixrec` + fixup record format — `cmdh.def:23-26`

`ch_fixrec` (word at 0x7D) = the **128-byte file RECORD number** at which the
fixup table begins (record N = file offset N·128). Each fixup record is 4 bytes:

    fix_grp   equ byte ptr 0                 ; hi nibble = group the LOCATION is in
                                             ; lo nibble = TARGET group whose load
                                             ;             segment gets ADDED
    fix_para  equ word ptr fix_grp + byte    ; paragraph offset of the word (LE)
                                             ;   within the LOCATION group
    fix_offs  equ byte ptr fix_para + word   ; byte offset 0-15 within that paragraph
    fixlen    equ fix_offs + byte            ; = 4 bytes

### The LOADER applies the fixups — `load.sup:402-449`

    test lod_lbyte,80h        ; byte-127 bit 7 set?
    jz   init_base            ; no fixups -> skip
    ...                       ; random-read the file at record ch_fixrec
    fx_chk:
      mov al,fix_grp[bx] ! and al,0fh   ; low nibble = target group
      call tblsrch ! mov dx,ldt_start[di]   ; dx = TARGET group load segment
      mov al,fix_grp[bx] ! shr al,4         ; high nibble = location group
      call tblsrch ! mov ax,ldt_start[di]   ; ax = location group base segment
      add ax,fix_para[bx]                    ; es = location_base + para
      mov es,ax
      mov al,fix_offs[bx] ! mov di,ax
      add es:[di],dx        ; *** patch: add TARGET load segment to the word ***
      add bx,fixlen         ; next record; re-read next file record at end

So the genuine CP/M-86 / CCP/M loader **can relocate the program itself**.
But DR C's `.CMD` ALSO ships a `CLEARL` crt0 that self-relocates — and the two
never double-apply, because a **guard flag that is itself a relocation target**
selects exactly one actor. Full mechanism (disassembly + experiments):
`[[reference_drc_cpm86_reloc_mechanism_VERIFIED]]`. In brief: CLEARL's entry
`mov cx,0 / jcxz / ret` reads a 0x0000 immediate that has its OWN fixup record;
if the loader ran fixups that immediate is nonzero → CLEARL skips self-reloc; if
not (emu2, plain CP/M-86) it stays 0 → CLEARL self-relocates using the actual
group segments the loader wrote into the base page. `dx` (the value added) is the
*target* group's actual load segment; the record says which group's segment to
add and where.

### Cross-check against real DR C artifacts

`LL_l.CMD` (large model): `ch_lbyte=0x80`, `ch_fixrec=0x17B` (record 379 =
offset 0xBD80); records there include `grp=0x12` (code location, add DATA base)
and `grp=0x11` (code location, add CODE base) — exactly the loader's semantics.
The fixup table is ALSO reachable as a **type-8 (AUX4) group** whose image is the
same bytes (`LL_l.CMD` group list: Code, Data, Extra, Stack, AUX4@0xBD80 = the
`ch_fixrec` offset). `LL_s.CMD` (small model) ALSO has `ch_lbyte=0x80` with one
real fixup — so fixups are not unique to the large model.

### emu2 does NOT apply loader fixups — and that is CORRECT for DR C

`emu2-cpm86/src/cpm86.c` never reads `ch_fixrec` (0x7D) and never applies these
loader fixups. That is not a bug for DR C output: with no loader relocation the
guard immediate stays 0 and CLEARL self-relocates, so DR C large-model programs
run correctly on emu2 (VERIFIED: `RELOCALL.CMD` prints `ABC` — a far call
through a relocated pointer succeeds). The reloc table is emitted ONCE (as the
type-8 aux group; the same bytes are pointed at by `ch_fixrec`/bit 7 for a
relocating loader). A wlink `.CMD` that uses ONLY byte-127/`ch_fixrec` loader
fixups with NO self-reloc crt0 would run on genuine CCP/M-86 but NOT on emu2, so
it MUST be verified under MAME. See `[[reference_drc_cpm86_reloc_mechanism_VERIFIED]]`.

---

## 5. Base page — `basep.fmt`, built by `load.sup:init_base` (475-560)

The base page occupies the first 0x100 bytes of the **first Data group** (or the
first Code group in the 8080 model — `load.sup:485-495`). The loader zero-fills
0x00..0x5A then writes one 6-byte slot per loaded group:

    0x00  bpg_clen (3)  bpg_cseg (2)  bpg_8080 (1)   ; Code  group
    0x06  bpg_dlen (3)  bpg_dseg (2)  ---            ; Data  group
    0x0C  bpg_elen (3)  bpg_eseg (2)  ---            ; Extra group
    0x12  bpg_slen (3)  bpg_sseg (2)  ---            ; Stack group
    0x50  bpg_lddsk (1) + password ptrs
    0x5C  bpg_fcb0        ; parsed command-tail FCB #1
    0x6C  bpg_fcb1        ; parsed command-tail FCB #2
    0x80  bpg_dma         ; default DMA / command tail (<len><chars><CR>)
    0x100 bpg_udata       ; program data starts here

Slot index = `6 * (G_Type - 1)`, with type 9 mapped to 1 (`load.sup:512-517`).
Each slot's 3-byte length = `(G_Min_paragraphs * 16) - 1` (the group's last valid
20-bit byte offset — `load.sup:521-535`); the 2-byte segment = the group's actual
load segment (`ldt_start`, `load.sup:538`). Byte 0x05 = the 8080-model flag.

---

## 6. Register state at program entry — `load.sup` UDA setup (566-596)

    u_initds = u_inites = base-page segment (Data group)
    u_initcs = bpg_cseg  (Code group);  error e_no_cseg if absent
    u_inites = bpg_eseg  if an Extra group exists  (loader sets ES to it)
    u_initss = loader's own initial stack (in the UDA) -- the ~48/96-byte scratch
    IP       = 0  (0x100 for the 8080 model)
    initial stack primed for a RETF to terminate (ls_flags=0x200, user_retf)

This matches the RC759 measured entry state (`CS=2150 DS=ES=216D SS=214A SP=5C`,
see `[[reference_cpm86_cmd_header]]`). **crt0 must not touch DS/ES/CS** (the
loader set them); it only needs its own real stack + data at DS:0100. If an Extra
group is present the loader points ES at it automatically — no crt0 code needed
(the Stage A far-heap mechanism).

---

## 7. Note for our wlink emitter (`loadcpm86.c` is OURS, not upstream Watcom)

`bld/wl/c/loadcpm86.c` is a **project (ravn) contribution** (ravn/open-watcom-v2
#10), not stock Open Watcom code. Two of its current assumptions are ours to
revise for Stage B:

1. It appends debug info after the group images via `DBIWrite()` (line 159-162)
   on the premise *"the CMD loader ignores trailing bytes."* That premise holds
   only while byte 127 bit 7 is **clear**. Once we set bit 7 (Stage B fixups),
   the loader DOES read the trailing record `ch_fixrec` names — so the layout
   must be: header, images, **fixup table at exactly `ch_fixrec`**, then any
   debug info, and appending debug info must never shift the fixup record number.
2. It currently emits `ch_fixrec`/byte-127 = 0 (no fixups). Stage B must set
   byte 127 bit 7, write `ch_fixrec`, and emit the 4-byte fixup records in the
   format above. DR C's model is dual: the loader applies these IF it relocates
   (guard set nonzero → crt0 self-reloc skipped), else a CLEARL-style crt0
   walker self-relocates (guard=0). See
   `[[reference_drc_cpm86_reloc_mechanism_VERIFIED]]`; pick ONE coherent Stage B
   model (self-reloc runs on emu2 AND genuine loaders).

See also: `[[reference_cpm86_cmd_header]]`,
`[[reference_drc_cpm86_reloc_format]]`, `[[reference_cpm_dri_source_archive]]`,
`[[tasks/plan-cpm86-big-model-2026-08-18]]`.

## P_LOAD (BDOS fn 59) dispatch + full flag byte — from CCP/M-86 v3.1 source (2026-08-21)

Grounded in the newer v3.1 tree `scratch/ccpm31-src/` (`[[reference_ccpm86_v31_source]]`),
which is more complete than the v2.0 loader.

### Full `ch_lbyte` (Program Flag, byte 127 / 07FH) — all 5 bits
From `D2/CMDH.DEF` (v3.1) — supersedes the partial 2.0 map (bits 5/6/7 only):

| bit | mask  | equate      | meaning                                   |
|-----|-------|-------------|-------------------------------------------|
| 7   | 0x80  | `need_fxps` | load-time fixup records present           |
| 6   | 0x40  | `opt_8087`  | optional 8087 (LINK-86 `8087CONDITIONAL`) |
| 5   | 0x20  | `need_8087` | 8087 required (LINK-86 `8087REQUIRED`)    |
| 4   | 0x10  | `need_rsx`  | requires RSX (Resident System eXtension) load |
| 3   | 0x08  | `susp_mode` | suspend process if it is a background task |

**Not present in v2.0:** the v2.0 `kern/cmdh.def` defines ONLY `ch_lbyte equ byte ptr
07fh` — it has NO named flag equates at all; the 2.0 loader references bit 7 solely as
a magic literal (`test lod_lbyte,80h`). So ALL FIVE named equates
(`need_fxps`/`opt_8087`/`need_8087`/`need_rsx`/`susp_mode`) are v3.1 additions. Bits
5/6 (8087) existed only in the DRI manuals for 2.0, never in its source; bits 4
(`need_rsx`, RSX = Resident System eXtension) and 3 (`susp_mode`, background-suspend)
are genuinely new 3.x features with no counterpart anywhere in the 2.0 tree. The v3.1 loader
`D1/LOAD.SUP` acts on all of them: `ndpchk:`/`ndp_flg:` test bit5/bit6 (→ `lod_ndp`,
`owner_8087`, error `e_nondp=17`), `h_hdr:` tests `susp_mode` (→ `lod_suspnd`), and
`test lod_lbyte,80h` (l.440) gates fixups.

### Group descriptor + fixup record format (`D2/CMDH.DEF`)
Group descriptor (max `ch_entmax`=8): `ch_form`(byte type) `ch_length`(word)
`ch_base`(word) `ch_min`(word) `ch_max`(word); `chlen`=9. `ch_fixrec` = word at 0x7D =
file record# where fixup records start (only if bit 7). Fixup record = `fix_grp`(byte:
hi-nibble=location group, lo-nibble=target group) `fix_para`(word para offset)
`fix_offs`(byte in-para offset); `fixlen`=4. Loader applies `add es:[di],dx` where
DX=target group's load segment (`D1/LOAD.SUP` `fx_chk:`).

### LDTAB (internal load table, `D1/LOAD.SUP` header comment)
9 entries (1 per potential group + 1 for independent allocs), each: `ldt_start`(abs
seg) `ldt_min` `ldt_max` `ldt_pd` `ldt_atr`(mem flags) `ldt_fstrt`(file para)
`ldt_flen`(file paras) `ldt_type`(group type) `ldt_id`(seg addr); `ldtlen`=17.

### P_LOAD = BDOS function 59 — the dispatch chain (answers "where is 59?")
Public fn 59 is alive despite `;f_userload equ (user*0100h)+59` being commented in
`D2/MODFUNC.DEF`. The live wiring:
1. BDOS entered with `CL=59`. Functions ≤80 are NOT renumbered, so table index=59.
2. `D1/SYSDAT.DAT:258` `sysent` row: **`db 4, sup or net_bit ; 59-load`** — word
   `enttab_entry[59]` = AL=4 (subfunction), AH=`sup`(module 1) `| net_bit` (P_LOAD is
   CP/NET-capable).
3. `D1/SUPIF.SUP` `okfunc`→`localfunc`: `cmp ah,sup ! je insup`; `insup:` `shl ax,1`
   (4→8) `jmp cs:supfunc[si]`.
4. `D1/SUPIF.SUP:349` `supfunc` table row 4: **`dw load_ent ; 4-(59)user load
   function`** → enters `load_ent` in `D1/LOAD.SUP`.
Neighbours #60/#61 are `db 1, sup` → `supfunc[1]=i_ent` (illegal-function stub),
i.e. reserved. So P_LOAD IS a real supervisor call routing to the loader; it's also
called internally by P_CLI (150, `cli_ent`) and P_CHAIN (47, `chain_ent`/`cload_ent`).

### `load_ent` contract & error codes (`D1/LOAD.SUP`, `D2/ERR.DEF`)
Input: `DX`=addr of open FCB in `u_wrkseg`. Output: `BX`=base-page segment, or
`BX=0FFFFh` + `CX`=error. Errors: `e_no_memory=3`, `e_nondp=17` (no 8087 when
required), `e_bad_load=28` (0-length/bad header), `e_no_cseg=33` (no code segment),
`e_fixuprec=41` (fixup error). Base page (`init_base:`) built in the 1st Data group
(type 2), else 1st non-shared Code group (type 1) = 8080 model (`lod_8080=1`, written
to base-page byte 5).
