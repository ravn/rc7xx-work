# HANDOFF — llvm-z80 intrinsics + static frames (written 2026-11-02, host "sonnyboy")

Read first, in this order: `CLAUDE.md` → `tasks/memory/MEMORY.md` (esp. §0 absolute bans, §2 before-commit rules) →
`tasks/memory/project_z80_intrinsics_static_frames_2026-11-02.md` (status/pitfalls) → this file →
`tasks/plan-z80-intrinsics-static-frames-2026-11-02.md` (staged plan, written by a subagent; partly verified).

## Goal (user)
Use Z80 machine instructions (DI, EI, HALT, NOP, IN, OUT, IM 0/1/2, LD I,A) from C **without losing static frames**
(`Z80NonReentrant`, `+static-frame`), so the four RC702 firmware components (autoload-in-c 2 KB PROM, rcbios-in-c,
cpnos-in-c, CP/NET) get smaller/ faster code. The user wants the **z88dk integration to work correctly**; nobody else
uses this work until the user releases it. `address_space(2)`/`AS_IO` is deliberately NOT restored.

## Where the work is (all on GitHub)
- `ravn/rc7xx-work` (this workspace repo, branch `main`): notes, plan, this file, backup patches + reproducers in
  `tasks/patches/llvm-z80-intrinsics-static-frames-2026-11-02/` (`git am` them onto base `da06bcd8acc2`).
- `ravn/llvm-z80`, **branches pushed 2026-11-02, stacked** (each on the previous; base `da06bcd8acc2` = origin/main):
  `s1/z80-intrinsics-nocallback` (2a1f1ab9f81a) → `s2/z80-constant-port-in-out` (7072c68396f4) →
  `s3/z80-im-set-i-intrinsics` (575307b1713b) → `s4/z80-clang-builtins` (5746100bc287).
- The workspace's submodule pointer for `llvm-z80` is deliberately still the published pin `da06bcd8acc2`.
  Nothing has been proposed upstream (llvm-z80/llvm-z80); only issue ravn/llvm-z80#421 was filed (constant-port IN/OUT).

## Resume on a fresh machine (Ubuntu; workspace root differs per host, see CLAUDE.md)
```bash
git pull --no-recurse-submodules                      # NOT plain pull: the mame submodule fetch is huge
bash scripts/setup-ubuntu.sh --no-docker              # apt deps incl. z88dk deps (needs sudo); gh auth login; set git identity
git submodule update --checkout -- llvm-z80 z88dk rc700-gensmedet
git -C z88dk submodule update --init -- ext/UNIXem ext/Unity ext/optparse ext/regex ext/uthash
git -C llvm-z80 fetch origin s4/z80-clang-builtins && git -C llvm-z80 switch -c s4/z80-clang-builtins origin/s4/z80-clang-builtins
make toolchain            # ccache is mandatory (Makefile errors without it); COLD build ≈ 40+ min on 16 cores
ninja -C llvm-z80/build-linux count not split-file llvm-mc llvm-as llvm-dis llvm-config llvm-readobj llvm-readelf \
      llvm-ar llvm-ranlib llvm-strip llvm-size lib/z80/z80_rt.a     # lit helpers + runtime lib (rcbios link needs z80_rt.a)
make -C z88dk -j6                                      # z88dk-ticks etc; zsdcc recipe: tasks/memory/reference_host_sonnyboy.md
```
Build in the checkout's own `llvm-z80/build-linux` (same path → ccache hits; a new worktree = cold cache, see
`tasks/memory/feedback_ccache_llvm_build.md`). To return to the pin: `git -C llvm-z80 switch --detach da06bcd8acc2`.

## Test commands and EXPECTED numbers (S4 branch)
```bash
cd llvm-z80
build-linux/bin/llvm-lit llvm/test/CodeGen/Z80/                 # 159/160 pass; z88dk-runtime.ll fails on the BASE too
build-linux/bin/llvm-lit clang/test/CodeGen/z80-builtins.c clang/test/CodeGen/z80-builtins-sm83-gate.c   # + the other 15 z80 clang tests: 17/17
cd z80-utils && BUILD_DIR=$PWD/../build-linux PATH=<workspace>/z88dk/bin:$PATH cargo run --release -- clang
#   expect: Total 462  Pass 456  Fail 0  Fatal 0  Skip 6   (skips = SM83 inline-asm test, by design)
```
Both tiers are required before/after any compiler change (CLAUDE.md). New compiler behaviour needs a lit test that FAILS
without the fix. Quick demo that must keep working (C → asm, static frame kept): `repro/e2e.c` with
`clang --target=z80 -Oz -ffreestanding -nostdlib -Xclang -target-feature -Xclang +static-frame -S`.

## Firmware status with the S4 clang (make targets only — NEVER run mame directly)
- `make -C rc700-gensmedet/autoload-in-c prom` → OK, 2035 B (cap 2048). Boot gate NOT run yet (`make mame` in that dir).
- `make -C rc700-gensmedet/rcbios-in-c bios` → OK, 5761 B (CLAUDE.md says 5462 B from June; +299 B unexplained). Boot test NOT run.
- `make -C rc700-gensmedet/cpnos-in-c prom1-lineprog COMPILER=clang` → **FAILS**: (a) attribute `z80_preserves_regs`
  (commit `70eed199d837`, not on main; ignored with a warning) and (b) backend `report_fatal_error` "target did not
  implement null MCTargetStreamer" when compiling `src/snios_c.c`, `src/transport_pio.c` with `-flto -g -Oz ... +static-frame`
  (cause unknown — start by bisecting flags / checking the `-g` + inline-asm path; CMake note "exclude llvm-mc-affected sources").
- Headers using the builtins: `autoload-in-c/rom.h`, `autoload-in-c/clang/intrinsic.h`, `rcbios-in-c/hal.h`,
  `rcbios-in-c/clang/intrinsic.h`, `cpnos-in-c/src/hal.h`, `cpnos-in-c/compiler/compat.h`. Inline asm still in autoload:
  replaceable `clang/intrinsic.h:28` (`ld i,a`) and `rom.h:295` (`im 2`); not replaceable: `jump_to` (rom.h:144), `SET_SP`, ISRs, boot_rom.c layout asm.

## Open tasks, in priority order
1. **cpnos build** (above). 2. Switch autoload `set_i_reg`/`intrinsic_im_2` to `__builtin_z80_set_i/im2`, measure bytes
and the MAME boot gate via Makefile targets, compare with the inline-asm version (plan stage S5). 3. `intrinsic_*` mapping
for clang in `z88dk/include/intrinsic.h` (`#if defined(__LLVMZ80) || defined(__CLANG)` block, currently only `intrinsic_label`),
guarded with `__has_builtin`; z88dk's `intrinsic_*` are otherwise real `extern` calls (= external calls, lose static frames).
4. rcbios +299 B investigation. 5. Decide #413 (commits `b899080f18ed`+`78018171a730`, on main): user said WAIT; keep until
all production asm is migrated; known gap: `Z80StaticFrameAlloc` does not filter asm edges (8 B frame-overlap loss in a toy).
Local-only branch recreation if wanted: `git revert 78018171a730 b899080f18ed` on `da06bcd8acc2`.
6. Minor: `llvm.trap/ubsantrap/debugtrap` lack nocallback; `LD_A_I/LD_A_R/LD_R_A` lack Defs/Uses (unused today);
`z88dk-runtime.ll` pre-existing failure; CLAUDE.md size numbers are stale (June). 7. Landing: when it all works the user
says "rykker vi det op": first a bug-report issue on `ravn/llvm-z80` (S1 as small attribute fix with reproducer, like #421),
upstream (llvm-z80/llvm-z80) only with a per-filing explanation and the user's explicit go-ahead.

## Decisions already made by the user
High port byte unspecified · three separate im intrinsics (im0/im1/im2, matching z88dk `intrinsic_im_0/1/2`) · #413: wait ·
no restoring of AS_IO · mid-body `ei` in a C ISR: not present in firmware (ISRs are `__naked`) so no special handling ·
local first, then "rykke op" · z88dk correctness is the goal.

## Rules a new AI must obey (details in CLAUDE.md / MEMORY.md)
Never search outside the workspace root · never run MAME binaries directly (Makefile targets/`scripts/mame_capture.sh` only) ·
never create PRs / post comments / file upstream issues without the user's explicit go-ahead in that turn; issues go to
`ravn/*` first, every issue body ends with the attribution line from `feedback_issue_attribution_line.md` · never write the
fork owner's GitHub handle anywhere (say "the fork owner") · temp files in `scratch/tmp/`, never `/tmp`, never `~/.claude` ·
use ccache · commit messages carry `Rules-checked:` · push only when asked (workspace repo is pushed at the end of a segment)
· be concise; the user is Danish and writes Danish.

## Pitfalls (also in the project note)
`int_z80_set_i` is spelled `llvm.z80.set.i` in IR (a wrong spelling silently disappears and kills static frames) ·
nocallback must be set in the `.td`, not in IR text · FileCheck `DAG` cannot use variables defined in the same group ·
rcbios link needs `ninja lib/z80/z80_rt.a` · after a rejected tool call check for partial side effects.
