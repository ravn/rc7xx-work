---
name: Installing interrupt handlers on CP/M-86 (IVT poke) — for the 8087 emulator seam
description: The documented CP/M-86 / Concurrent CP/M-86 way to add an interrupt routine is a direct far-pointer write into the segment-0 IVT; used by the Watcom float (8087-emulator) retarget, rc7xx-work#8
type: reference
metadata:
  node_type: memory
  type: reference
---
# Adding interrupt routines on CP/M-86 (authoritative, from the DRI manuals in-workspace)

**Question this answers:** how does a transient program install an interrupt
handler on CP/M-86 (RC759 target = Concurrent CP/M-86 3.1, PICCOLINE XIOS 2.3)
WITHOUT calling DOS INT 21h? Needed for rc7xx-work#8 (Watcom-native float, whose
8087 software emulator dispatches via INT 0x34–0x3D and must install those
vectors). INT 21h is a FATAL error here (purity gate: 0× INT 21h).

## The documented mechanism — direct write into the segment-0 IVT

Source: **CP/M-86 System Guide (Jun 1983)**, in-workspace at
`open-watcom-v2/contrib/ravn/CPM-86_System_Guide_Jun83.txt` (+ .pdf). The BIOS
"Setup all interrupt vectors in low memory" sample (≈ line 9269 / 10905) shows
the canonical way an 8086 program sets an interrupt vector — there is NO BDOS
"set vector" call; you write the far pointer straight into physical segment 0:

```
    mov  ax,0
    mov  ds,ax            ; DS -> segment 0 (the IVT)
    mov  es,ax
    mov  word ptr [N*4],   offset handler   ; INT N vector: offset word
    mov  word ptr [N*4+2], cs               ;               segment word
```

- **Reserved interrupt locations are 0–3FFH** (256 vectors × 4 bytes), at
  physical segment 0. The System Guide (≈ line 3705, 248) states this region is
  reserved for interrupt vectors + the OS and is deliberately NOT part of the
  transient's Memory Region Table — it is always present and writable.
- INT N's vector lives at physical `N*4` (offset word) and `N*4+2` (segment
  word), i.e. `0000:N*4`.
- BDOS entry itself is just such a reserved software interrupt: **INT 224
  (0E0H)** (System Guide line 8412; `equ 224 ;reserved BDOS Interrupt`).

## Concurrent CP/M-86 (the actual RC759 OS) confirms transients set their own vectors

Source: **Siemens Concurrent CP/M-86 Programmer's Reference Guide** (in-workspace
`scratch/rc759-cmd-toolchain/docs/Siemens_Concurrent_CPM-86_Programmers_Reference_Guide.txt`),
§3.4 Parent/Child Relationships:

> "The child process also inherits interrupt vectors 0, 1, 3, 4, 224, and 225,
> which the parent process initialized."

Take-aways:
- Programs DO initialize interrupt vectors directly (0,1,3,4 = the CPU-exception
  vectors: divide, single-step, breakpoint, overflow; 224/225 = BDOS). The same
  direct-IVT mechanism extends to any free vector.
- DEV_SETFLAG / DEV_WAITFLAG are for *asynchronous hardware* interrupt/device
  signalling under the multitasking scheduler — NOT for the 8087 emulator. The
  emulator's INT 0x34–0x3D are **synchronous software interrupts** fired inline
  by the emulated ESC/FWAIT opcodes in the SAME process context, so no
  scheduler cooperation is needed; a plain IVT poke suffices.

## Application to the Watcom 8087-emulator seam (rc7xx-work#8)

- Watcom `-fpi` emits 8087 ESC opcodes with emulator FIXUP records; wlink rewrites
  FWAIT+ESC → INT 0x34–0x3D (magic constants FIARQQ=0FE32H, FISRQQ=0632H, … in
  `bld/fpuemu/i86/asm/initemu.asm`). The emulator INT handlers (`__int34…__int3d`)
  and compute engine live in `bld/fpuemu/i86/asm/{initemu,emu8087}.asm`.
- Watcom's `__init_87_emulator` fills a local table `i34off/seg…i3doff/seg` with
  the handler CS:offset, then calls `xchg_vects` — which uses **INT 21h** (DOS
  get/set-vector fn 35h/25h). That is the ONLY DOS coupling.
- Emulator vectors INT 0x34–0x3D occupy physical `0x34*4 = 0x00D0 … 0x00F7`
  (10 vectors × 4 = 40 bytes), inside the reserved 0–3FFH region.
- **Our Layer-2 CP/M-86 seam** replaces `xchg_vects` with a direct IVT poke:
  fill the table (reuse `__init_87_emulator`'s non-DOS setup, or replicate it),
  then `push es; xor ax,ax; mov es,ax; mov di,0D0H; <copy the 40-byte table>;
  pop es`. Zero INT 21h — purity gate stays green.
- Because the purity gate counts INT 21h *bytes statically*, we must NOT link
  Watcom's unmodified `initemu.asm` (its xchg_vects INT 21h would be present even
  if never executed). Carry a CP/M-86 variant in `port/` (startup glue = the
  layer we own; the clib proper stays unchanged). DR C solves the identical
  problem the same way (per @xthra) — install an 8087 emulator on CP/M-86 by
  setting the vectors directly when no coprocessor is present.

## Ultimate oracle

End goal is that this runs on **real RC759**; cycle-accurate MAME rc759 is the
authoritative cross-check (emu2 may not faithfully model no-8087, so a green emu2
alone is NOT sufficient proof — MAME rc759 is).
