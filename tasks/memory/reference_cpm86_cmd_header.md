# CP/M-86 .CMD header + RC759 loader contract (verified 2026-08-14)

Reference for building CP/M-86 `.CMD` files (wlink `format cpm86`, ravn/open-watcom-v2#10)
and writing their crt0.

## Primary source

**Siemens Concurrent CP/M-86 Programmer's Reference Guide** (= Digital Research
*Concurrent CP/M-86 Programmer's Guide*), in-project at
`open-watcom-v2/contrib/ravn/Siemens_Concurrent_CPM-86_Programmers_Reference_Guide.{pdf,txt}`.
Relevant sections: **§3.2 Command File Format**, **§3.3 Base Page Initialization**,
**§4.1 Transient Execution Models** (§4.1.1 8080, §4.1.2 Small, Table 4-1).
Also: FlexOS 286 Programmer's Utilities Guide §7.7.1 (same 8-descriptor header).

## §3.2 Command File Format (header + group descriptors)

> "A CMD file consists of a 128-byte header record followed immediately by the
> memory image. The command file header record is composed of **8 group
> descriptors (GDs), each 9 bytes long**." (Fig 3-1)

Group Descriptor format (Fig 3-2), all multi-byte fields little-endian, sizes in
**16-byte paragraphs** (assumed low nibble 0 → 20-bit address):

    00H G_TYPE   (1 byte)
    01H G_LENGTH (2 bytes)  paragraphs stored in the file image
    03H A_BASE   (2 bytes)  base paragraph for a NON-relocatable group; 0 => relocatable
    05H G_MIN    (2 bytes)  min paragraphs to allocate
    07H G_MAX    (2 bytes)  max paragraphs to allocate

**Table 3-1 — G_Type:** 01=Code, 02=Data, 03=Extra, 04=Stack, 05-08=Auxiliary
#1-#4. (Header byte 0x7F bit 7 = "fixup records present" — a fixup table trails
the images; base=0/no-fixups covers every shipping RC759 program sampled.)

**Table 3-2 — fields:** G_Length = paragraphs in the group; A_Base = base para of
a non-relocatable group; G_Min/G_Max = min/max memory to allocate (loader
zero-fills G_Min − G_Length). Each group image is padded to a 128-byte record.

**Memory model is IMPLICIT in the descriptors (§3.2 / §4.1):** only a Code group
⇒ **8080 Model**; Code + Data only ⇒ **Small Model**; anything more ⇒ **Compact
Model**. For one header, only a Code group plus one of any other type is allowed.

## §4.1.1 The 8080 Memory Model

Code and data overlap in one group; CS=DS=SS=ES equal. P_CLI sets **IP=100H**
("thus allowing Base Page values at the beginning of the code group") and
initializes the stack so a Far Return terminates. So an 8080 CMD must `org 100h`
— a single-group CMD with code at offset 0 does NOT run (loader jumps to 0x100 =
base page). (This is why the first single-group wlink test printed nothing; the
2-group small-model version then ran.)

## §4.1.2 The Small Memory Model

> "the P_CLI system call sets the **[DS] register to the beginning of the data
> group**, and the **SS and SP registers to a 96-byte initial stack area that it
> initializes**." (Fig 4-2: DS=ES=data, CS=IP=0, SS:SP=48H:00H, data at 0100H.)

So the ~96-byte stack is **BY DESIGN**, not a missing header request. The program
switches to its own stack (see DR C below).

## §3.3 Base Page Initialization

Base page occupies the first 100H bytes of the data group (DS:0000-00FF). It holds
the group descriptors as loaded (**0x00 code, 0x06 data, 0x0C extra, 0x12 stack** —
each = length(3) + segment(2)), the command-tail FCB at 5CH, and the default DMA
/ command tail at 80H-FFH. Program data therefore starts at **DS:0100**.

## MEASURED at entry on real RC759 (`regs.asm` dumped them)

    CS=2150  DS=216D  ES=216D  SS=214A  SP=005C

Confirms §4.1.2 exactly: loader sets **DS=ES=data group**, **DS=CS+code_paras**
(0x216D-0x2150 = 0x1D = 29 = the CODE group size), CS=code, IP=0, SP≈96-byte
scratch stack. **crt0 must NOT touch DS/ES** (loader already set them); it only
needs a real stack + data at DS:0100 (0x100 reservation via `wlink op dosseg` +
a `BEGDATA` seg).

## How DR C handles wanting more stack (`drc-oracle/startup.a86`, `m.init.stack`)

- **Small model:** startup does **`SS=DS`, `SP` = base-page word at offset 6 =
  the TOP of the whole DGROUP**; stack limit `SL.` = heap pointer. So stack grows
  DOWN from the top of the data group while the heap grows UP — they share DGROUP
  and collide in the middle. **More stack ⇒ a bigger DATA group** (LINK-86 sets
  its G_Max, e.g. dir.cmd DATA G_Max=4096 para=64K = the whole segment).
- **Large/compact model:** startup reads **SS:SP from the base-page STACK-group
  descriptor (0x12/0x15)** — a dedicated **type-4 Stack group** the loader
  allocates; size is set via the stack group's G_Min/G_Max in the header
  (LINK-86 has a stack-size control). wlink's loadcpm86.c currently emits only
  type 1/2, so a loader-allocated stack group is a future extension.

## §2.5 "The Compact Memory Model" (CP/M-86 System Guide) — loader-level register setup

Found 2026-08-18, directly relevant to Stage A of
`tasks/plan-cpm86-big-model-2026-08-18.md`. **"Compact Model" is the CP/M-86
loader's own name** for "code+data groups plus one or more of
stack/extra/auxiliary" — not just a Watcom `-mc` coincidence; both names
independently mean the same loader-defined thing.

> The Compact Model is assumed when code and data groups are present, along
> with one or more of the remaining stack, extra, or auxiliary groups. In
> this case, **the CS, DS, and ES registers are set to the base addresses of
> their respective areas**... If the transient program intends to use the
> stack group as a stack area, **the SS and SP registers must be set upon
> entry** [by the program itself]. The SS and SP registers remain in the CCP
> area, even if a stack group is defined.

So for Stage A (adds an Extra group, no Stack group): **the loader sets ES
to the Extra group's base automatically**, same load-time mechanism as
CS/DS already — crt0 needs to do NOTHING extra to make ES point at the far
heap; it's correct on entry, exactly like small model's DS/ES already are
(measured below). This simplifies the crt0 phase considerably from earlier
scoping (which assumed manual base-page parsing would be needed) — Stage
A's `__AllocSeg` port likely just reads the CURRENT `ES` register directly
(e.g. inline `mov ax, es`) rather than walking the base page at all.

SS/SP auto-setup is a Stage-B-and-later concern (only matters once a Stack
group descriptor exists) — Stage A doesn't touch the stack at all.

## Proof artifacts
`scratch/rc759-cmd-toolchain/wlink-cmd-test/`: `RC759_ENTRY_REGISTERS.png` (the
register dump), `RC759_WLINK_CMD_PROOF.png` (a wlink CMD printing on real RC759),
`regs.asm`, `rc759_2group.asm`. See also [[reference_wlink_drc_omf_l86]],
[[reference_rc759_mame_c_verification]], [[reference_drc_toolchain_architecture]].
