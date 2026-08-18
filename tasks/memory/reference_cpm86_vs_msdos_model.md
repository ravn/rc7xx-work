---
name: CP/M-86 target model — same 8086 core as MS-DOS, different runtime + executable format
description: Conceptual reference. For the Watcom toolchain, CP/M-86 codegen IS MS-DOS 8086 codegen; the only differences are the OS-call runtime (BDOS INT 0E0h vs DOS INT 21h) and the executable format (.CMD group descriptors vs .COM/MZ .EXE). Includes the __CPM86__ distinguishing-macro decision and reference pointers.
metadata:
  type: reference
---

# CP/M-86 as an Open Watcom target — the mental model

**One sentence:** CP/M-86 and MS-DOS share the *same* 8086 real-mode
compiler core; they differ only in the **runtime** (how a program calls the
OS) and the **executable format** (how the loader lays the program in
memory). Everything the *compiler* emits is identical; the two differences
are entirely **link-time and runtime** concerns.

## What CP/M-86 is

Digital Research's CP/M-86 (1981) is a single-tasking 8086/8088 real-mode
operating system — the 16-bit successor to 8-bit CP/M-80. **Concurrent
CP/M-86** is the multitasking descendant; the RC759 (and Siemens PC-D)
run a Concurrent CP/M-86 variant. It is *not* a clone of MS-DOS, but at the
level a C compiler cares about it is structurally the same machine: 8086
real mode, segmented memory, the same instruction set.

## Why "same core as MS-DOS" is literally true for codegen

For Open Watcom the CP/M-86 target reuses the **DOS** codegen with **zero**
divergence. They share, bit for bit:

- the **8086 real-mode instruction set** (`-0`/`-bt=dos` and cpm86 both
  target the same CPU level);
- the **OMF object format** (`.obj`) — objects are interchangeable;
- the **memory models** — tiny / small / compact / large map onto CP/M-86's
  8080 / Small / Compact / Big group models (code/data/extra/stack groups
  are just OMF segment groups); see CP/M-86 System Guide §4;
- the **calling conventions and register usage** (Watcom register calling
  convention, `-ms` small model, etc.).

Empirical proof in this repo: `HELLO.CMD` and `MANDEL.CMD` were **compiled
`wcc -bt=dos -0 -ms`**, then linked `wlink format cpm86`, and run correctly
on emu2 / MAME. The compiler never knew it was building for CP/M-86.

## The two — and only two — differences

### 1. Runtime / OS-call mechanism

| | MS-DOS | CP/M-86 |
|---|---|---|
| entry | `INT 21h`, function in `AH` | reserved software `INT 224` (`0E0h`), function in `CL` |
| model | DOS API | BDOS (8086 regs `CH:CL` mirror CP/M-80 `B:C`) |

The C-runtime **seam** (crt0, BDOS-based stdio/`printf`, arena heap, stubs)
is what bridges Watcom's otherwise-DOS clib onto BDOS. It lives in
`watcom-cpm86-libc/port/` and `open-watcom-v2/bld/clib/_cpm/` (the latter
`objects.mif` states cpm86 clib components use "the same `__DOS__`
target"). Ref: CP/M-86 System Guide §4.1 ("reserved software interrupt
224"; the txt's OCR "#244" is a typo — the assembler source in the same
guide reads `equ 224 ;reserved BDOS Interrupt`).

### 2. Executable format

| | MS-DOS | CP/M-86 |
|---|---|---|
| flat | `.COM` (≤64K, tiny) | `format cpm86 8080` (single group, `.COM`-like) |
| full | MZ `.EXE` (relocatable header) | `.CMD` — 128-byte header record of up to 8 nine-byte **group descriptors** (G-form: code/data/extra/stack + 4 aux; each = paragraph length + optional absolute base) |

The CCP/loader reads the `.CMD` group descriptors to place each group and
set CS/DS/SS/ES accordingly. Ref: CP/M-86 System Guide §3 (Intel-hex →
GENCMD → CMD header) and §4 (memory models / group setup). In the toolchain
this is realized by the native **`wlink format cpm86`** writer
(`bld/wl/c/{cmdcpm86.c,loadcpm86.c}`), not a wrapper — see
`reference_watcom_wlink_cpm86_format.md`.

## Distinguishing CP/M-86 in source — the `__CPM86__` macro

`-bt=cpm86` is a **first-class compiler build target** (implemented in
`bld/cc/c/cmdlnx86.c`, 2026-08-18). Verified empirically
(`wcc … -bt=<x>` + `#pragma message`):

- `-bt=dos`   → predefines `__DOS__`, `_DOS`, `MSDOS` (no `__CPM86__`).
- `-bt=cpm86` → predefines `__CPM86__` **and** `__DOS__`, `_DOS`, `MSDOS`.

So `#ifdef __CPM86__` distinguishes CP/M-86 code paths, while the DOS-family
macros keep every DOS-gated header and clib component applying unchanged.

**How it works (the two-line change):**

1. `setTargetSystem()` maps `"CPM86"` → `TargetSystem = TS_DOS`. This has
   **zero codegen effect** — nothing in `bld/cg` or `bld/cc` branches on
   `TS_DOS` vs the former default `TS_OTHER`; `TS_DOS` only selects the
   `_DOS`/`MSDOS` predefines. Guarded `#if _CPU == 8086` (CP/M-86 is
   real-mode 8086; `wcc386 -bt=cpm86` is left untouched).
2. `SetFinalTargetSystem()` additionally predefines `__DOS__` for cpm86
   (the auto `__<TARGET>__` gives `__CPM86__` from `target_name`; the
   explicit `__DOS__` gives DOS header/clib compat). Same `#if _CPU == 8086`
   guard.

The production driver `owcc -bcpm86` already passes `-bt=cpm86` (via
`bld/wcl/owcc/*/specs.owc`, `system begin cpm86 … ARCH i86 -bt=cpm86`), so
the shipping build now gets all four macros. (Note: the *clib build* still
compiles the `_cpm` variant with `-bt=dos` via `bld/clib/flags.mif`
`sw_c_cpm86 = -bt=dos`; that is fine — identical codegen, and clib does not
need `__CPM86__`.)

**Verified:** `wcc -bt=cpm86` predefines `__CPM86__`+`__DOS__`+`_DOS`+`MSDOS`;
`-bt=dos` is unchanged (no `__CPM86__`); `owcc -bcpm86` + `wlink format
cpm86` still produces a valid `.CMD` that renders correctly on emu2
(mandel_watcom.c). ⚠ `open-watcom-v2` is a shared submodule (sonnyboy's
active area) — this compiler-source change was committed/pushed to its
remote and the superproject gitlink bumped, coordinated cross-machine.

## Reference pointers

Primary sources (in `open-watcom-v2/contrib/ravn/`):
- `CPM-86_System_Guide_Jun83.{pdf,txt}` — BDOS `INT 224` (§4.1, ~line 437 &
  8412); `.CMD` header + group descriptors (§3, ~line 941+); memory models
  (§4, ~line 346–713).
- `CPM-86_Programmers_Guide_Jan83.{pdf,txt}` — C/asm programming model.
- `Concurrent_CPM_Programmers_Reference_Guide_Jan84` +
  `Siemens_Concurrent_CPM-86_Programmers_Reference_Guide` — the RC759's
  Concurrent variant.

Toolchain realization:
- `open-watcom-v2/contrib/ravn/README-cpm86.md` — build/link how-to.
- `tasks/memory/reference_watcom_wlink_cpm86_format.md` — native
  `format cpm86` `.CMD` writer (linker side).
- `tasks/memory/reference_watcom_cpm86_startup_initfini.md`,
  `reference_cpm86_ss_ds_entry_bug.md`, `reference_cpm86_interrupt_vector_install.md`
  — runtime seam / crt0 details.
- `open-watcom-v2/bld/clib/_cpm/`, `watcom-cpm86-libc/` — the C runtime seam.
- `open-watcom-v2/bld/cc/c/cmdlnx86.c` — `setTargetSystem()` /
  `SetFinalTargetSystem()` (target macro predefinition).
- `tasks/memory/reference_watcom_submodule_build_apple_silicon.md` — macOS
  build + cpm86 codegen facts.
