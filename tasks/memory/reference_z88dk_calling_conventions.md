# z88dk classic calling conventions under llvm-z80 clang

Verified 2026-07-10 (from source, not assumption).  Context: migrating the
dcc-vs-clang CP/M benchmark suite onto the OFFICIAL z88dk clib (no shims), and
the long-term goal of making llvm-z80 clang a FULL CP/M compiler.

## The three z88dk classic-clib calling conventions and their clang status

z88dk decorates clib functions with one of three attributes.  Mapping in
`z88dk/include/sys/compiler.h` (the `#if __clang__` branch):

| z88dk attribute    | ABI                                     | clang mapping today          | status |
|--------------------|-----------------------------------------|------------------------------|--------|
| `__smallc`         | args on stack, **caller** cleanup       | `__attribute__((sdcccall(0)))` | ✅ works |
| `__z88dk_callee`   | args on stack, **callee** cleanup       | `__attribute__((z80_callee))` | ✅ works (2026-07-10) |
| `__z88dk_fastcall` | single arg in a fixed reg (L/HL/DE:HL)   | `__attribute__((z80_fastcall))` | ✅ works (2026-07-10) |

`sdcccall(0)` = `CallingConv::Z80_SDCCCall0` (128) is FULLY implemented — that is
what fixed console I/O (`putchar('H')` no longer reads stack garbage) and what
the divide helpers link through.  So "can clang support sdcccall(0)" → it already
does; nothing to add there.

## clang Z80 default C ABI (the numbers that matter — VERIFIED)

- **Fixed args**: arg1 → HL, arg2 → DE.  8-bit single arg → **A**.
- **16-bit return value → DE** (not HL).  Triple-verified: call-site disasm
  `ld (x),de` after a helper call; `keep(){...}` ends `ex de,hl; ret`; the
  div/mod swap symptom matched exactly.
- **No callee-saved general registers** — HL/DE/BC/AF all caller-saved.  IX/IY
  reserved.
- Per `llvm/include/llvm/IR/CallingConv.h:301`: i8→A, i16→HL, i32→**HLDE**.

## Official z88dk wiki vs. SDCC "sdcccall 0/1" terminology (cross-checked 2026-07-11)

Source: https://github.com/z88dk/z88dk/wiki/CallingConventions (raw:
`raw.githubusercontent.com/wiki/z88dk/z88dk/CallingConventions.md`).  The wiki
CONFIRMS: `__z88dk_callee` = callee cleans the stack; `__z88dk_fastcall` = at
most one arg in a subset of DEHL by width (int→HL, long→DEHL), return in the
same registers; return values in a DEHL subset by width; `__smallc` =
caller-cleanup; conventions are a per-function prototype-suffix property.

CAVEAT — the wiki does NOT use the terms "sdcccall(0)" / "sdcccall(1)" (those
are SDCC-side).  Its zsdcc default `__z88dk_sdccdecl` is described as
stack-based (args pushed right-to-left, caller cleanup, char as single byte).
That matches the OLD sdcccall 0.  But clang's ACTUAL z80 default is
register-passing (arg1→HL, arg2→DE — verified: `int callee(int,int)` call emits
`ld hl,4660; ld de,22136`), i.e. SDCC 4.2+ `--sdcccall 1`.  So the wiki page
predates sdcccall1 and neither confirms nor contradicts clang's
register-passing default — do NOT cite the wiki as confirming "clang default =
sdcccall1"; that rests on our own codegen measurement.  Push order is
consistent though: wiki right-to-left → first (leftmost) arg pushed last →
ends up on top, matching the observed `fputc_callee` `pop de`=first-arg.

## `__z88dk_fastcall` — now a real convention (was "works by luck" for 16-bit)

z88dk fastcall passes its single arg in a FIXED register by width.  As of
2026-07-10 the ravn/llvm-z80 backend has a dedicated convention
`CallingConv::Z80_Z88dkFastCall = 130` (clang attribute
`__attribute__((z80_fastcall))`), so all three widths are correct by
construction — no longer a coincidence:

| width | z88dk_fastcall (asm reads)         | z80_fastcall (cc130) | match |
|-------|-------------------------------------|----------------------|-------|
| 8-bit | **L**  (`rs232_put.asm`: `ld a,l`)  | L                    | ✓ |
| 16-bit| **HL** (`swapendian.asm`)           | HL                   | ✓ |
| 32-bit| **DE:HL** (DE high, HL low)         | DE:HL                | ✓ |

Return value uses the same registers.  Backend: `classifyArgFastCall` +
`CCRegsFast` in `Z80CallLowering.{h,cpp}`.  Tests:
`llvm/test/CodeGen/Z80/z88dk-fastcall.ll` (backend register discipline),
`clang/test/CodeGen/z80-fastcall.c` (frontend attribute→cc130),
`z88dk/test/clang/fastcall_abi_16.c` + `.sh` (red-green 16-bit contract).
Header: `z88dk/include/sys/compiler.h` maps the macro.  `__z88dk_callee`
(callee-cleanup stack) is ALSO a real convention now (2026-07-10):
`CallingConv::Z80_Z88dkCallee = 131`, clang attr `__attribute__((z80_callee))`.
Arg layout + return regs identical to sdcccall(0) (getRegsForCC maps cc131 ->
CCRegs0); the ONLY difference is `isCalleeCleanup -> true` for cc131, FORCED
independent of return size.  Key invariant (pinned by test): cc131 i32-return
STILL callee-cleans (BC-fallback `pop bc; inc sp×4; push bc; ret`) whereas cc128
i32-return caller-cleans (plain `ld sp,ix; pop ix; ret`).  Void-return callee
uses the EX-trick cleanup (`pop hl; inc sp; inc sp; ex (sp),hl; ret`).  Tests:
`llvm/test/CodeGen/Z80/z88dk-callee.ll` (backend, XFAIL removed) +
`z88dk-callee-controls.ll` + `clang/test/CodeGen/z80-callee.c` (frontend).  The
old no-op was a LATENT BUG: clang caller-cleaned while a real callee-clean clib
fn also cleaned -> double-pop stack corruption.

## Historical root cause of the runtime-helper name mismatch

The backend (`Z80InstructionSelector.cpp:575,5191,5749,5824`) hard-codes
libgcc/compiler-rt names (`__divhi3`, `__modhi3`, `__udivhi3`, …); 32/64-bit come
from LLVM's default libcall table (also libgcc names).  z88dk's `libsrc/l/clang/`
was populated with SDCC-style wrapper names (`__sdivs`, `__ldivu`, …), mirroring
`l/sdcc/`, on the assumption clang would request those.  Never reconciled → the
ENTIRE integer div/mod/mul helper family in `l/clang/` is dead-named.  Fix is
z88dk-side: provide libgcc-named wrappers.  See `z88dk/libsrc/l/clang/__divhi3.asm`
(the 16-bit family: `___divhi3/___udivhi3/___mulhi3` do `call l_*; ex de,hl; ret`
→ result to DE; `___modhi3/___umodhi3` tail-call the core, remainder already in
DE).  Symbol mangling: clang prepends ONE underscore, so C `__divhi3` → asm
`___divhi3` (three underscores).

## Feasibility of native z88dk-CC support — HIGH (proven pattern)

The fork already added this exact plumbing pattern TWICE (`Z80_SDCCCall0`=128,
`Z80_AllReg`=129).  Lowering is fully parameterized by a `CallingConvRegs` struct
selected in `getRegsForCC(CC)` (`Z80CallLowering.h`); i32 return word-order is a
data field (`Ret_I32_Hi/Lo`), and callee-stack-cleanup (no `ret N` on Z80) is a
`RET_CLEANUP` pseudo + `StackParamBytes` + `ADJCALLSTACKUP`-after-CALL, already
exercised by sdcccall(1).  So:
- `__z88dk_fastcall` = a swapped/byte-precise `CallingConvRegs` for one arg+return.
- `__z88dk_callee`   = sdcccall(0) arg layout + force callee cleanup.

Full CC-plumbing chain (9 hooks) and the phased implementation plan:
`llvm-z80/tasks/plan-2026-07-10-z88dk-calling-conventions.md`.
