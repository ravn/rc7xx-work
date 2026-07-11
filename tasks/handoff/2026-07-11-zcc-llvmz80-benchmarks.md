# Handoff: zcc -compiler=llvmz80 benchmark integration (2026-07-11)

**Session:** Claude Sonnet 4.6 on behalf of @ravn.
**Pick up with:** Read this file, then check `scratch/dcc-clang-bench/` for scripts.

---

## One-line status

Made zcc +cpm -compiler=llvmz80 build all four dcc benchmarks (sieve, e, ttt, tm).
Fixed `ticks_cpm.py` BDOS stub to work with z88dk programs. sieve and e measure
correctly. ttt restarts in a loop (root cause found but not fixed). tm output not
verified.

---

## What was DONE this session

### 1. z88dk llvmz80 fixes (all committed to ravn/z88dk)

**`lib/llvmz80/llvmz80_rules.1`** — three new copt rules:
- `.data` section → `SECTION data_compiler` (was missing; broke initialized globals
  like `int logging = 1` in ttt.c and `_winner_functions[]` array)
- `.section .data,%1` and `.section .data.%2,%1` → `SECTION data_compiler`
- `call __call_iy` → `call l_jpiy` (indirect function pointer calls;
  `__call_iy` from compiler-rt is not demand-loadable from z88dk libs because
  z88dk's library indexer doesn't index 2-underscore symbols correctly;
  `l_jpiy` = `jp (iy)` IS indexed and loadable)

**`lib/llvmz80/bridge_postproc.sh`** — two fixes:
- `GLOBAL` → `EXTERN` for referenced-but-undefined symbols (GLOBAL means
  "export" in z88dk; EXTERN means "import" — demand-loader only searches
  library for EXTERN references)
- awk regex extended: now also captures `l_xxx` symbols (e.g. `l_jpiy`) for
  the EXTERN header, not just `_xxx` symbols

**`libsrc/l/llvmz80/__calloc.asm`** (new file):
- Bridge from clang's `__calloc(size, nobj)` sdcccall(1) ABI to z88dk's
  `asm_HeapCalloc`. Enables tm.c's `calloc()` calls.
- Added to `libsrc/l/llvmz80.lst`
- Rebuilt `z80_crt0.lib` (run: `cd libsrc; TYPE=z80 z88dk-z80asm -d -I... -mz80
  -DSTANDARDESCAPECHARS -x../lib/clibs/z80_crt0 @classic/z80.lst`)

**`libsrc/l/llvmz80/__call_iy.asm`** (new file, NOT used):
- Was created but NOT the solution. `__call_iy` is not demand-loadable from
  z88dk libs (2-underscore naming issue). Use `l_jpiy` copt rule instead.

### 2. ntvcm: added `-m:X` flag (max X million cycles)

Modified `ntvcm/ntvcm.cxx`:
- New `uint64_t maxCycles = UINT64_MAX` variable
- Parses `-m:X` flag: `maxCycles = X * 1,000,000`
- In the main loop: `if (total_cycles >= maxCycles) { printf(...); break; }`
- Help text updated
- Rebuilt with `bash mmac.sh` in `/Users/ravn/z80/ntvcm/`

Usage: `ntvcm -p -m:50 prog.com` — stops after 50M cycles (prints the count).

**NOTE:** ntvcm is NOT suitable for z88dk programs. It spends 87% of cycles in
its own BDOS handler (Ctrl-C polling at 0xFE40) when z88dk output is used.
Use ticks_cpm.py for z88dk binaries.

### 3. ticks_cpm.py fixes (scratch/dcc-clang-bench/ticks_cpm.py)

Three bugs fixed:

**Bug 1: `-output` → `-x`**
z88dk-ticks uses `-x <file>` for RAM dump output, not `-output`. The fatal
sentinel check (0xDEAD at 0xFFF0) was silently never working because the dump
file was never created. Fixed.

**Bug 2: BDOS stub missing functions 11, 13, 14, 25, 26**
z88dk's CP/M startup calls BDOS 25 (Get Current Disk) early. Without it in the
stub, the program triggered the fatal path and exited early. Added:
- 11: Console Status → return 0 (no char)
- 13: Disk Reset → no-op  
- 14: Select Disk → no-op, A=0
- 25: Get Current Disk → A=0 (drive A)
- 26: Set DMA Address → no-op

**Bug 3: Added `--counter N` support**
`python3 ticks_cpm.py --counter 50000000 prog.com` passes `-counter N` to ticks
for cycle-limited runs (prevents infinite loops).

**Also: BDOS debug mode (current state)**
The stub currently prints "Bxx " for every BDOS call (e.g. "B19 B02 B0C").
This was added for debugging the ttt restart issue. REMOVE before production:
rebuild `bdos_stub.s` without the debug header, update STUB bytes in
ticks_cpm.py.

**How to rebuild STUB bytes:**
```bash
cd scratch/dcc-clang-bench
clang --target=z80 -c bdos_stub.s -o /tmp/s.o
ld.lld -Ttext=0xF000 -e _start /tmp/s.o -o /tmp/s.elf
llvm-objcopy -O binary /tmp/s.elf /tmp/s.bin
python3 -c "print(','.join(map(str,open('/tmp/s.bin','rb').read())))"
```
Then update the `STUB = bytes([...])` line in ticks_cpm.py.

### 4. Benchmark scripts (scratch/dcc-clang-bench/)

**`build_zcc.sh`** (new):
Builds one benchmark with `zcc +cpm -compiler=llvmz80 -O2
-pragma-define:CLIB_MALLOC_HEAP_SIZE=8000` and measures cycles with ntvcm.
NOTE: ntvcm is unreliable for z88dk programs (use ticks_cpm.py instead).

---

## Current benchmark results (2026-07-11)

### dcc reference (ntvcm, full-speed)
| Program | cycles    |
|---------|-----------|
| sieve   | 26,535,599 |
| e       | 25,371,146 |
| ttt     | 6,344,550  |
| tm      | 79,430,643 |

### zcc llvmz80 -O2 (ticks_cpm.py)
| Program | cycles      | output correct? | notes |
|---------|-------------|-----------------|-------|
| sieve   | 34,477,948  | ✓ "1899 primes." | +30% vs dcc |
| e       | 41,829,724  | ✓ "271828..."   | +65% vs dcc |
| ttt     | UNRESOLVED  | ✓ "6493 moves"  | RESTARTS in loop — see below |
| tm      | ~217K (wrong)| ✗ no "success" | logging=0 → LLVM may eliminate work |

**Binary sizes** (for reference):
- sieve: 7464 B (dcc: 1920 B)
- e: 7934 B (dcc: 2304 B)
- ttt: 8247 B (dcc: 3456 B)
- tm: 8657 B (dcc: 4224 B)

---

## ttt restart issue (UNRESOLVED, root cause partially identified)

### Symptom
`zcc ttt` outputs "6493 moves\n1 iterations\n" (correct!) and then IMMEDIATELY
restarts the program instead of exiting. In 200M cycles it runs ~19 times
(~10.5M cycles per game). The manual clang pipeline (build_one.sh) gives ~10.2M
cycles for one game — so the computation speed is correct; it's the exit that's broken.

### BDOS call sequence observed (via debug stub)
```
B19 B02×25 B19 B02×25 B19 ...
```
- B19 = BDOS 25 (Get Current Disk) — this is the STARTUP call in z88dk crt0
- B02 = BDOS 2 (Console Out) — the 25 output characters
- Then B19 again = STARTUP AGAIN

### What's missing from the exit path
Expected exit sequence: `B0E` (BDOS 14 Select Disk) then `B0C` (BDOS 12 Get
Version) then JP 0x0000 (HALT → ticks exits).

We see: NO B0E, NO B0C, just a direct restart back to the startup BDOS 25 call.
This means z88dk's crt0 exit path (`__Exit` → `crt0_exit` → restore SP → BDOS 12
→ `JP C, 0x0000`) is NOT being executed.

### Root cause hypothesis
z88dk's crt0 calls `_main` with argc/argv on the STACK (z88dk __smallc convention).
But LLVM's main expects argc in HL, argv in DE (sdcccall(1)). The crt0 then does
`pop bc; pop bc` to clean up the stack after main returns.

If LLVM's main or the called functions use a mismatched stack depth (e.g. due to
ABI mismatch), the `pop bc; pop bc` after main returns might pop the wrong values,
corrupting the return address path into `jp __Exit`. Instead of jumping to __Exit
(address 0x0209), execution might jump somewhere that loops back to the startup.

### `__Exit` address in ttt binary
`0x0209` — confirmed by searching for `LD (0x0080),HL; PUSH HL` pattern.

### What to investigate next
1. Trace execution from 0x0209 (`-start 0x0209` in ticks) to see what crt0_exit
   and __restore_sp_onexit actually do.
2. Check if `crt0_exit` (atexit handlers) is returning normally or jumping somewhere.
3. Check the SP value at `__restore_sp_onexit: ld sp, [saved]` — if saved_sp=0
   because ticks Z80 starts with SP=0, the restored SP might point to address 0
   which contains wrong data.
4. Alternative fix: patch the zcc compilation to add `-DCRT_ENABLE_COMMANDLINE=0`
   or similar to skip the argc/argv handling that causes ABI issues.

---

## tm correctness issue (UNRESOLVED)

tm.c sets `logging = (argc > 1)`. With ntvcm/ticks passing no args, argc=1 →
logging=0. All printf calls are guarded by `if (logging)`, so no output. The only
output should be `printf("success\n")` at the end. But no "success" appears.

Possible causes:
1. LLVM optimizes away the malloc/calloc/free loop (plausible with -O2)
2. calloc fails silently → null pointer dereference → crash before "success"
3. Some other ABI issue in the malloc path

The 217K cycle count is suspiciously low for 66×10 allocation/free cycles.
To debug: build with `logging=1` forced (add `-Dlogging=1` or test with an
argument), watch what BDOS calls happen, check if "success" appears.

---

## Files changed this session (not all committed)

### ravn/z88dk (committed)
- `lib/llvmz80/llvmz80_rules.1` — .data + call __call_iy fixes
- `lib/llvmz80/bridge_postproc.sh` — EXTERN fix + l_xxx regex
- `libsrc/l/llvmz80/__call_iy.asm` — (created but not the solution)
- `libsrc/l/llvmz80/__calloc.asm` — calloc bridge
- `libsrc/l/llvmz80.lst` — added __call_iy and __calloc entries
- `lib/clibs/z80_crt0.lib` — rebuilt with new modules

### workspace (NOT committed)
- `scratch/dcc-clang-bench/bdos_stub.s` — debug version (has "Bxx " prints)
- `scratch/dcc-clang-bench/ticks_cpm.py` — fixed (-x flag, STUB, --counter,
  BDOS 11/13/14/25/26); currently has debug STUB bytes
- `scratch/dcc-clang-bench/build_zcc.sh` — new script (uses ntvcm, not ideal)
- `ntvcm/ntvcm.cxx` — added -m:X flag

### ravn/llvm-z80 (no changes)
No compiler changes this session.

---

## Key tool paths
- zcc: `/Users/ravn/z80/z88dk/bin/zcc`
- ZCCCFG: `/Users/ravn/z80/z88dk/lib/config/`
- ticks: `/Users/ravn/z80/z88dk/bin/z88dk-ticks`
- ntvcm: `/Users/ravn/z80/ntvcm/ntvcm`
- Benchmark sources: `/Users/ravn/z80/dcc/tests/{sieve,e,ttt,tm}.c`
- Pre-built dcc binaries: `/Users/ravn/z80/dcc/build/{SIEVE,E,TTT,TM}.COM`

## Build commands
```bash
# Build one benchmark with zcc llvmz80
export PATH="/Users/ravn/z80/z88dk/bin:$PATH"
export ZCCCFG=/Users/ravn/z80/z88dk/lib/config/
zcc +cpm -compiler=llvmz80 -O2 -pragma-define:CLIB_MALLOC_HEAP_SIZE=8000 \
  -o /tmp/sieve /Users/ravn/z80/dcc/tests/sieve.c

# Measure cycles with ticks_cpm.py
python3 /Users/ravn/z80/scratch/dcc-clang-bench/ticks_cpm.py /tmp/sieve

# With cycle limit (ttt)
python3 /Users/ravn/z80/scratch/dcc-clang-bench/ticks_cpm.py \
  --counter 50000000 /tmp/ttt
```
