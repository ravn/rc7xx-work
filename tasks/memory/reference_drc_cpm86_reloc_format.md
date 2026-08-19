# DR C / LINK-86 CP/M-86 large-model relocation ("fixup") format — DECODED

Verified 2026-08-19 (macbook) against the GENUINE DR C 1.11 oracle
(`scratch/rc759-cmd-toolchain/rc759-drc-official/`, run under
`emu2-cpm86/emu2`). This is the authoritative answer to Stage B's three-way
"how do we relocate cross-segment far pointers" decision in
`tasks/plan-cpm86-big-model-2026-08-18.md` (Phase B2). DR C is the ultimate
oracle for the `.CMD` format (see
`[[reference_watcom_interop_retired_drc_oracle]]`) — we replicate what it
does, not interoperate with it.

## The decision it settles: Option 1 (real fixup records), NOT Option 2

DR C large model produces **fully relocatable** `.CMD` files — every group
descriptor has `A_Base = 0` — and resolves cross-segment far references with
a **relocation table carried in a type-8 auxiliary group** (observed as GD4
below). It does NOT use fixed (non-relocatable) load addresses. So Stage B
must implement CP/M-86 fixup records; the "fixed A_Base" shortcut (plan
Option 2) is ruled out because the reference toolchain demonstrably does not
use it, and a fixed address is unsafe under a multi-console Concurrent
CP/M-86 TPA anyway.

> **VERIFICATION STATUS — read before implementing.**
> The *file format* below is verified against genuine DR C 1.11 output. WHO
> applies the relocation is **not** verified on the authoritative oracle:
> - VERIFIED (emu2 loader source `emu2-cpm86/src/cpm86.c` + DR C programs
>   running under emu2): under **emu2**, the program **self-relocates** — the
>   loader loads the type-8 aux group's image and only sets the base-page aux
>   descriptor (slots 4-7 @ base-page 0x1B/0x21/0x27/0x2D); it does NOT walk
>   the table. The DR C startup runtime (CLEARL) reads its own reloc buffer
>   and patches its far pointers.
> - NOT VERIFIED: whether **genuine CCP/M's** loader ALSO processes such a
>   table. **emu2 is our reimplementation, not the oracle — only MAME running
>   genuine CCP/M-86 is 100% authoritative** for loader/relocation semantics.
>   emu2 may have chosen self-relocation where real CCP/M loader-relocates.
> - Header **byte 127 (07FH) = "Program Flag"** (Concurrent §3.1.2): DRI
>   documents ONLY bit 6 = optional 8087, bit 5 = 8087 required. That
>   `header[0x7F] = 0x80` (bit 7) triggers relocation is **observed in DR C
>   output, NOT documented** in any DRI manual in the workspace.
>
> Robust design conclusion regardless: **replicate DR C** (reloc table in a
> type-8 aux group + self-relocation in the runtime). That is safe on genuine
> CCP/M by construction (DR C is the shipping toolchain for this OS), and does
> not depend on unverified loader behavior. Confirm the final `.CMD` boots
> under **MAME**, not just emu2, before declaring Stage B done.

## How DR C emits a far call (compiler side)

`wcc`/DR C large model emits, for a cross-module call, `9A off16 seg16` with
**both operands left 0 in the .OBJ** (bwdis of `moda.obj`):

    0007  9A 00 00 00 00    call   callee     ; seg operand fixed up by linker
    0012  CB                retf

(A matching OMF FIXUPP relocation record in the .OBJ tells LINK-86 to patch
the segment word.) Same contract Watcom's own `-mm -zm` already produces
(`<func>_TEXT` per function, `jmp/call far ptr`) — see plan Phase B1/B3.

## How LINK-86 resolves it (linker side) — the format to replicate in wlink

Minimal repro: two DR C modules, `moda.c` (`main` calls extern `callee`) +
`modb.c` (`callee`), each its own translation unit → its own CODE segment in
large model; linked `MODA,MODB,CLEARL.L86[S]`. LINK-86 merged all CODE-class
segments (both modules + used libc) into ONE type-1 CODE group (0x36f paras
here, still < 64 KB) and produced this header:

    GD0 CODE  G_Len=0x036f A_Base=0 G_Min=0x036f G_Max=0
    GD1 DATA  G_Len=0x00e7 A_Base=0 G_Min=0x00e7 G_Max=0
    GD2 EXTRA G_Len=0      A_Base=0 G_Min=0x0080 G_Max=0x0800   ; far heap
    GD3 STACK G_Len=0x0002 A_Base=0 G_Min=0x0080 G_Max=0x0800   ; dedicated stack
    GD4 type8 G_Len=0x006a                                       ; = the reloc table (aux group)
    header[0x7F] = 0x80   -> "Program Flag" bit 7 set (see VERIFICATION STATUS)

So DR C large model = **CODE + DATA + EXTRA(far heap) + STACK + reloc-table**.
(The EXTRA + STACK groups match what Stage A already emits — consistent with
our design.)

### Relocation-table wire format (decoded + cross-checked against the image)

The table is a packed array of **4-byte records**, laid out right after the
group images (padded to a 128-byte record). Each record:

    byte 0:  group nibbles  hi<<4 | lo
             lo nibble  = which group's LOAD SEGMENT is ADDED to the 2-byte
                          word at this location (1=CODE base, 2=DATA base).
                          "Added" by whoever owns relocation — the program's
                          own startup under emu2; possibly the OS loader on
                          genuine CCP/M (UNVERIFIED, see VERIFICATION STATUS)
             hi nibble  = which group the LOCATION lives in (1=CODE image,
                          2=DATA image)
    byte 1-2: paragraph offset within that group's image (little-endian)
    byte 3:   byte offset (0..15) of the 2-byte word within that paragraph

    absolute file offset of the word to patch =
        group_image_base + para_offset*16 + byte_in_para

Observed byte-0 histogram in the repro (390 records): `0x11` ×368 (code
location, add CODE base), `0x12` ×19 (code location, add DATA base — e.g. a
`mov ax,DATA_seg` immediate), `0x22` ×3 (data location, add DATA base).
Table terminates at the first all-zero record / padding.

Cross-check that nails the semantics:
- rec `(0x12, 0x6F, 8)` → file 0x778 holds `B8 00 00` = `mov ax,0x0000`
  (a DATA segment-value load) → DATA base gets added. ✓
- rec `(0x11, 0x67, 10)` → the 2-byte word there is a **group-relative
  paragraph** (e.g. 0x0142) that LINK-86 wrote into a far pointer's segment
  field; CODE base gets added at load time. ✓

Key insight: LINK-86 writes the segment field as a **paragraph offset
relative to the group base** (already the final value minus the load base),
then the actual load segment is added (by the program's startup under emu2;
loader-vs-self on genuine CCP/M is unverified — VERIFICATION STATUS). wlink's
generic engine instead bakes in 0 with no record — that is exactly the
`EA 00 00 00 00` bug the plan saw (`main_TEXT`'s `jmp far ptr callee_` got
seg=0x0000).

## Concrete wlink implementation spec (Stage B, Phase B2)

`bld/wl/c/loadcpm86.c` today (small/compact only): one descriptor per wlink
`Groups` entry, all base=0, no table, `header[0x7F]` clear. To do Stage B:

1. **Coalesce CODE**: emit exactly ONE type-1 descriptor whose G_Len is the
   sum of ALL `CLASS_CODE` groups' paragraph images concatenated (not one
   descriptor per `-zm` `<func>_TEXT` group). DATA stays one type-2. This
   part is independent of the fixup work and needed regardless.
2. **Capture cross-group far fixups**: for each relocation whose target is a
   group-relative *segment* value, (a) write the group-relative paragraph
   into the image word instead of 0, and (b) append a 4-byte record in the
   format above. This means intercepting wlink's relocation walk for
   `FORMAT CPM86` so segment fixups become loader fixups instead of
   link-time-zeroed values (the plan's flagged "tell wlink our format has no
   link-time base for groups after the first").
3. **Emit the reloc table as a type-8 auxiliary group** (its own descriptor +
   image), matching DR C — NOT merely a bit-7-flagged trailing table. Under
   emu2 the program self-relocates from this aux group, so Stage B also needs
   **self-relocation startup code** in the CP/M-86 runtime/crt0 that walks the
   table and adds the base-page load segments (the loader will not do it under
   emu2, and genuine-CCP/M loader behavior is unverified — replicating DR C's
   self-relocation is the safe path). Setting `header[0x7F]` bit 7 mirrors DR
   C's "Program Flag"; keep it, but do not rely on it being loader-honored.
4. Optionally emit the dedicated **type-4 STACK** group (DR C does; matches
   `[[reference_cpm86_cmd_header]]`'s large-model SS:SP-from-base-page note).
5. **Verify the resulting `.CMD` boots under MAME (genuine CCP/M), not just
   emu2** — emu2 is not authoritative for loader/relocation semantics.

## Reproduce
```
cd scratch/rc759-cmd-toolchain
# (see the 2-module build in git history / drc-oracle.sh pattern; DRC.CMD -b
#  per module, then LINK86.CMD "MODA,MODB,CLEARL.L86[S]")
```
Parse any `.CMD`: 8×9-byte descriptors at 0x00, reloc table = a type-8 aux
group (4-byte records as above), images paragraph-packed from 0x80.
`header[0x7F]` = "Program Flag" (bit 5/6 = 8087 documented; bit 7 observed set
by DR C when relocating, meaning undocumented — VERIFICATION STATUS).

See also: `[[reference_cpm86_cmd_header]]`,
`[[tasks/plan-cpm86-big-model-2026-08-18]]`,
`[[reference_watcom_wlink_cpm86_format]]`.
