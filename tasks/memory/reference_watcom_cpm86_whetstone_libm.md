# Watcom CP/M-86: Whetstone (libm + real %e printf) PROVEN + the 80186 CPU gate (rc7xx-work#6 milestone #9)

2026-08-15, milestone #9. Builds on #8's `-fpc` soft-float.

## What is proven
`contrib/ravn/watcom-cpm86-libc/build-whetstone.sh` + `test/whetstone.c` run the
**Whetstone** double benchmark on CP/M-86 under emu2, **no 8087**. All 10
per-module check values match an **independent host `cc -lm` oracle** (native
IEEE-754 double, different toolchain) to the printed 4 significant digits, in
`%12.4e` format. This is the first proof of Watcom's OWN transcendental libm
(sin/cos/atan/exp/log/sqrt) AND its genuine `%e/%f/%g` float formatter on the
target. Purity `INT21h=0 · BDOS>0`; anti-fold tripwire = 72 runtime `__FDx`
calls. Fork commit d98f624934 (local, unpushed).

## How the libm closure was assembled
- **Transcendentals + 80-bit long-double software layer**: pulled from Watcom's
  prebuilt **`mathlib/library/msdos.286/ms/*.obj`** (140 objects) archived via
  wlib into `math286.lib`. There is **NO msdos.086 mathlib build** — only .286/
  .386 — so the .286 objects are the ready-made math lib. They are software-float
  (call `__FDFS/__sqrt87/__sqrtd`, 0 inline 8087 ESC) and INT-21h-free.
- **FP conversions + %e formatter + fpu support**: the pure-8086 (`msdos.086`)
  clib component libs `clib/{cgsupp,fpu,math,convert}/library/msdos.086/ms/clibs.lib`
  as `library` directives (wlink pulls ONLY referenced modules).
- **Real float printf**: `noefgfmt.obj` defines the `__EFG_printf/scanf` DATA
  pointers as a fatal stub; `setefg.obj`'s `__setEFGfmt()` repoints them at the
  real `_EFG_Format` (→ `__LDcvt`). Our minimal crt0 does NOT walk the init
  table, so `test/whetstone.c` calls `__setEFGfmt()` (and `__InitFiles()`)
  manually at the top of `main()`.
- **Small DOS-free support modules** added to close the link: `seterrno.c`
  (`__set_EDOM_`/`__set_ERANGE_` — DOS build => `lib_set_errno(x)` is just
  `errno = x`), `rtcntrl.c` (`__get_rt_control_ptr_`, efgfmt rounding flag),
  `iobaddr.c` (`__get_std_stream_`, `_matherr`'s stderr → `&__iob[h]`),
  `istable.c` (`__IsTable`, ctype table strtod/`__cnvs2d` index into).
- **`port/errnoptr.c`**: `__get_errno_ptr_` returning `&errno`. Do NOT link the
  stock `errno.obj` — it also defines the `errno` global, duplicating the one
  `port/stubs.c` owns.
- **`port/fpsoftstub.asm`**: add `___FPE_handler dd 0` (three underscores — the
  stock symbol is `public "C",__FPE_handler`, and C linkage adds a leading `_`).
  Default 0 = "no user FP-exception handler"; the mathlib error/format path
  references it, our crt0 installs none.

## STANDING build convention: `assert_no_286` (the user's durable request)
User (2026-08-15): "jeg vil gerne have at cp/m-86 bygget eksplicit checker for
286 instruktioner i de benyttede biblioteker som en del af processen fremover."
=> **Every CP/M-86 build going forward** that makes a non-8086 (e.g. `.286`)
library object linkable must disassemble it (wdis) and **fail the build**
(`assert_no_286`, exit 4) if any 80286-only opcode appears. The RC759 is an
**80186**: it runs every 80186/80286 real-mode INTEGER instruction, but NOT the
286 system/protected-mode set — the complete differential is
`arpl,lar,lsl,lgdt,lidt,lldt,sgdt,sidt,sldt,lmsw,smsw,clts,str,ltr,verr,verw`.
This complements `assert_no_8087` (FPU guard) with a CPU-instruction-set guard.
Reference implementation lives in `build-whetstone.sh`. Result: 140 .286 math
objects scanned, 0 non-80186 opcodes — 80186-safe.

## Known caveat (TODO)
The raw-byte `INT34-3D` emulator-trap purity scan is **temporarily disabled** in
`build-whetstone.sh` (user: "drop the guard for now, get it working"). It
false-positives on the IEEE-double coefficient tables Watcom's libm (`exp`/`log`)
embeds: a `CD 3B` byte inside a double constant is DATA, not an `int 3Bh`
instruction (wdis shows no int/esc there; the byte sits in a run of `3F`-exponent
words). The genuine x87 in `fdmth086`/`chipd16` is the DEAD hardware branch
(ESC bytes D8–DF selected out at runtime by `__real87==0`), not `CD 3x`.
Replace with a disassembly-based code-vs-data check (like `assert_no_8087`).

## Still open
`-fpc`/libm cross-check on cycle-accurate **MAME rc759** — the authoritative
no-8087 oracle; emu2 is green but may not faithfully model a no-8087 machine.
Also queued: build with `-1` (80186 integer set) to exploit the extra
instructions for compute-heavy code (Mandelbrot) — see tasks/todo.md.
