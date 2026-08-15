# Watcom OWN double soft-float runs on CP/M-86 via `-fpc` — no 8087, no IVT (rc7xx-work#8, PROVEN)

2026-08-15, milestone #8 of rc7xx-work#6. Open Watcom's **unchanged** `double`
arithmetic runs on the no-8087 RC759 as **pure call-based software float**, driven
only by our Layer-2 seams. Committed in the fork (`open-watcom-v2`
`contrib/ravn/watcom-cpm86-libc`).

## The key correction (supersedes the earlier "must emulate 8087" framing)

`-fpc` does **NOT** emit 8087 ESC opcodes and needs **no emulator and no
interrupt-vector install**. Verified empirically with `wdis`:

- `wcc -bt=dos -0 -ms -fpc` emits plain `call __FDA/__FDS/__FDM/__FDD`
  (add/sub/mul/div) + `__FDI4` (double→long) — **0 ESC, 0 INT traps**.
- `fdmth086.asm` dispatches each `__FDx` through a data word that `_chk8087`
  initialises from `__real87`: when `__real87 == 0` it self-patches to the
  **pure-software `__FDxemu` branch**. The 9 ESC opcodes in that file live only
  in the dead hardware `__FDx87` branch, never reached.
- Our `port/fpsoftstub.asm` defines `__real87=__8087=__chipbug=… = 0` (replacing
  stock `_8087086.asm`+`chipvar.asm`, and avoiding dragging
  `__chk8087`/`__verify_problems`). So the software path is selected
  automatically.

Therefore the whole INT 0x34–0x3D emulator + segment-0 IVT-poke route
(`port/emu87cpm.asm`, doc `FLOAT_8087_EMULATOR.md`) is **UNNEEDED for the shipped
`-fpc` build**. That earlier design note's premise ("no pure-integer soft-float;
both -fpi and -fpc run ESC") was empirically **refuted**; it is now demoted to the
DEFERRED-hardware note. Watcom's own `fpuemu/i86/asm/emustub.asm` ("-fpc, NO
emulator": all `FIxRQQ equ 0`, empty `__init_87_emulator`) confirms the -fpc build
links a no-op emulator stub.

## Proof (build-float.sh + test/floattest.c, emu2)

```
soft-float: 9 runtime __FDx call site(s) in floattest.obj (not folded)
purity: INT21h(DOS)=0  INTE0h(BDOS)=2  INT34-3D(8087emu)=0
pi6=3141592 mul=40115 add=468 sub=242   (hand oracle: 355/113 = 3.14159292…)
PASS
```

- **Constant-folding tripwire (learned the hard way):** with plain
  `double a=355.0,b=113.0` the optimizer folds the arithmetic to constants and
  emits **zero** `__FDx` calls — the oracle still prints right but proves nothing.
  The test uses **`volatile` operands** to force runtime calls; `build-float.sh`
  fails (`exit 3`) if `floattest.obj` has no `call __FD*`.
- **stdio init gotcha:** the test must call `__InitFiles()` before printf and
  `fflush(stdout)` after (minimal crt0 doesn't walk the init table) — same as
  `stdiotest.c`. Omitting it prints blank (this caused a long false "blank output"
  hunt).

## Link closure for the -fpc float build (build-float.sh)

Watcom clib objs: `fdmth086` (+`fdi4086` for __FDI4, `chipd16` for `__fdiv_m64r`)
plus our stubs: `port/fpsoftstub.asm` (chip vars =0), `port/fpsupport.asm`
(`F8UnderFlow`→0.0, `F8OverFlow`/`F8DivZero`→±Inf `0x7FF0…`, IEEE leaf stubs that
avoid `fstat086.asm`'s `__FPE_handler`/`__set_ERANGE`/errno chain), and
`fpuemu/…/emustub.asm` (no-op FIxRQQ). Everything else = the proven stdio+heap
seam set from build-stdio.sh.

## Status / deferred

- **8087 hardware support intentionally NOT shipped** — left to a contributor with
  a real 8087 (`docs/8087_HARDWARE_SUPPORT_DEFERRED.md`): Route A `-fpi`
  trap-emulator via `port/emu87cpm.asm` IVT poke; Route B `-fpi87` real chip. Both
  UNVERIFIED here.
- **Still pending for the supported path:** cross-check `-fpc` float output on
  cycle-accurate **MAME rc759** (authoritative no-8087 oracle; emu2 green but may
  not model a no-8087 machine faithfully).
- The DR C independent oracle (segment-0 IVT poke; `m.init.8087` if-0'd out of the
  C startup = library-driven float) is in `docs/DR_C_8087_CPM86_REFERENCE.md`.
