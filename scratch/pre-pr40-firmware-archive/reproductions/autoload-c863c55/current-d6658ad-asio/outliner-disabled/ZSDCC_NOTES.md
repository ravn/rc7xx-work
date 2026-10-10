# zsdcc (z88dk's SDCC fork) — Notes for Z80 ROM Development

## Version

zsdcc 4.5.0 #15242 (z88dk fork of SDCC).  Default `__STDC_VERSION__` is
199901L (C99), so `inline` keyword works without `--std-sdcc99`.

## `static inline` — Works But Leaves Dead Code

zsdcc supports `static inline` and genuinely inlines the function body
at each call site, eliminating CALL/RET overhead.

**However**, zsdcc also unconditionally emits the standalone function body
alongside the inlined copies.  The z88dk linker (`z80asm`) cannot strip
unreferenced functions within the same object file — there is no
`-ffunction-sections` or `--gc-sections` equivalent.

In a unity build (single `.c` file), ALL code is in one object file,
so the dead standalone copies can never be stripped.  A separate
translation unit doesn't help either: `static inline` makes the function
local to each TU, so every TU that includes the header gets its own copy.

**Result**: `static inline` increases total code size because you get
the inlined code PLUS the dead standalone body.  For a size-constrained
ROM, manual inlining (copying the function body into the caller and
removing the original function) is the only way to get inlining without
dead code.

**Tested**: A trivial `static inline byte add_one(byte x) { return x+1; }`
in a header, called once from `main()`.  The call was inlined (no `call`
instruction), but `_add_one` appeared in the map at its own address.

## `--fomit-frame-pointer`

Mandatory for ROM builds.  Without it, sdcc uses IX as a frame pointer,
adding `push ix` / `pop ix` (4 bytes) plus IX-relative addressing
(3 bytes per local variable access vs 3 bytes for static variable access).
Since the boot ROM has no recursion, all locals can be static.

## `--sdcccall 1` (Register Calling Convention)

- 1st param: 8-bit in A, 16-bit in HL
- 2nd param: 8-bit in L, 16-bit in DE
- 3rd+ params: pushed on stack (requires IX frame — forbidden)
- Return: 8-bit in A, 16-bit in DE

**Avoid 3-parameter functions** — they force stack access and IX usage.

## `--disable-warning 296`

Suppresses false positive `non-default sdcccall specified, but default
stdlib or crt0`.  Safe because we use `--no-crt` and link no stdlib
functions that use the wrong calling convention.  The Makefile checks
for sdcccall(0) library symbols (`__div*`, `__mod*`, `__mul*`) and
fails the build if any are linked.

## `memcpy` and `memset` Inlining

sdcc inlines `memcpy` and `memset` with compile-time constant lengths
as Z80 LDIR instructions (2 bytes, 21 T-states/byte).  Variable-length
calls go to a library function.

`memcmp` is **never** inlined — always generates a library call (+24 bytes).
Use a hand-written comparison loop instead.

## Variable-Count Shifts

`x << n` where `n` is not a constant generates a library call to
`__rlulong` or similar.  A manual shift loop (`for (i=0; i<n; i++) x<<=1`)
compiles to a tight DJNZ loop that is smaller than the library call.

## Peephole Optimizer

Custom rules via `-custom-copt-rules=peephole.def`.  Key rules:
- `ld a, 0x00` → `xor a, a` (saves 1 byte per occurrence)
- Redundant `xor a,a` after store to memory
- Dead code after unconditional jumps (`jp`/`jr`/`ret` followed by `jp`/`jr`)
- Tail-call fall-through: `jp label` where `label:` follows immediately
- Branch inversion: `jr NZ,skip; jp target; skip:` → `jp Z,target`

## Tail-Call Fall-Through

sdcc converts the last function call in a function to `jp` instead of
`call` (tail call).  If the target function is placed immediately after
in source order, the peephole rule `jp label / label:` → `label:`
eliminates the 3-byte jump.

**Requires**: functions must be adjacent in source order (sdcc preserves
function order within a translation unit).

## ISR Functions

- `__interrupt(N)` with N > 0 generates `EI; RETI` epilogue
- `__interrupt` without N (or N=0) generates `RETN` — **fatal** for
  maskable interrupts (leaves interrupts permanently disabled)
- `__critical __interrupt(N)` keeps interrupts disabled throughout
  (DI at entry, EI+RETI at exit)
- ISR functions save/restore all registers including IY

## Unity Build

All `.c` files compiled as a single translation unit via one `rom.c`.
Benefits:
- Cross-function optimization (sdcc sees all code at once)
- Dead code elimination within the TU
- Better register allocation across function boundaries
- Tail-call fall-through optimization (function ordering)
