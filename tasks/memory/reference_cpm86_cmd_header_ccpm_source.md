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
