# Reference: z88dk copt is a 32-bit-int engine (cannot split `.quad` itself)

**Verified 2026-08-05** (built `src/copt/copt.c` with `cc -O2`, ran real rules).

## What copt CAN do (beyond pure text substitution)
copt is not only literal token replacement. It has an output-side arithmetic
emitter and match-side guards:
- `%eval(<rpn>)` — emits the integer result of a reverse-Polish expression into
  the replacement text. Operators: `+ - * /`, `>` (=`>>`), `<` (=`<<`), `& |`,
  `!`; operands are decimal/`0x`hex literals and `%n` captured variables.
  (`src/copt/copt.c` ~line 509, `subst()`.)
- `%check min <= %n <= max`, `%eval result = expr`, `%is`/`%not`, `%notSame`,
  `"regex"` token match — all **boolean match-side guards** that only
  activate/deactivate a rule; they do NOT bind a new variable or emit a value.
- `%defb(...)`, `%L`–`%N` fresh labels, `%"..."n` regex capture.

## What it CANNOT do: 64-bit values
The whole evaluator is hardwired to C `int` (32-bit on every host copt builds
on): `int stack[STACKSIZE]` + `push(int)`/`pop()->int`, `int n = strtol(...)`
inside `rpn_eval`, result emitted via `sprintf(buf,"%d",r)`
(`src/copt/copt.c` ~868–990). Consequences, both **empirically reproduced**:
1. **Input truncated at parse time.** `.quad 4613937818241073152`
   (0x4008000000000000) → `strtol()` result stored in `int n` keeps only the low
   32 bits (0), so the high 32 bits are gone *before* any operator runs. Rule
   `.long %eval(%1 4294967295 &) / .long %eval(%1 32 >)` emitted `.long 0 /
   .long 0` (high half lost).
2. **`>> 32` is UB on a 32-bit int.** `.quad 7` → the high-half `7 >> 32` is
   undefined (shift count masked mod 32 → `>>0`), emitting `.long 7 / .long 7`
   instead of `7 / 0`.

## Conclusion for ravn/z88dk#27
Splitting an 8-byte `.quad` into two little-endian `.long` halves needs 64-bit
arithmetic, which copt does not have. Making copt do it would require patching
`copt.c` to be 64-bit-clean (`long long` stack/eval/`%lld` output) AND adding a
numeric-vs-symbolic guard, because an address-valued `.quad _sym+4` must pass a
*symbol* through to `.long`, not a number `%eval` can compute. That is a larger,
cross-cutting change to a shared upstream tool for a z80-only need. The external
`lib/llvmz80/splitquad.pl` pre-pass (Math::BigInt, exact 64-bit, handles
decimal/negative/hex + symbolic zero-extend) is the smaller, self-contained,
correct choice — so the external program is warranted, not merely convenient.
Same rationale already applies to `splitascii.pl` (copt's 512-char MAXLINE
buffer) and `fixlabels.pl` (dots in labels copt tokenises on whitespace).
