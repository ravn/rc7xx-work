# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Goal

Optimize the Z80 backend of ravn/llvm-z80 (a GlobalISel-based LLVM fork) to match or beat SDCC code density. Test against RC700 PROM and BIOS sources in rc700-gensmedet.

Current (2026-05-05): autoload PROM clang **1756 B** SDCC 1910 B, plus a clang `-g`-enabled variant at **1861 B** for source-annotated listings (+35 B, see #123). **BIOS: Clang 5961 B vs SDCC 6123 B (clang 162 B smaller)**; rcbios `bios.clang.cim` = 5961 B (+32 B over 2026-05-03's 5929 B due to #74 revert that restored autoload-in-c boot — see session 43/44 below). cpnos-rom payload 1777 B (unchanged). (IX/IY reserved — un-reserve gated on Phase 3 regalloc cost-model work, see #38 reclassification below.) Z80 lit suite: **90/90 (89 PASS + 1 XFAIL #99)**; **CI green** (`static-stack-loop-counter-desync.ll` updated session 44 for post-#82 conservative state). **2026-05-05 issue state**: #74 + #120 reopened with implementation instructions; #123 + #124 filed. autoload-in-c boots PASS at frame=225 / 4.5 s; rolling-walk in `rc700-gensmedet:5dbedb6..b75b7ae` proved #74 is the ONLY boot-breaking regression in the post-merge ravn-fork commit window.

**Canonical plan:** `llvm-z80/tasks/roadmap-to-maturity.md` (master, session 36) overlaid by `llvm-z80/tasks/plan-2026-05-03-structural.md` (current, session 42 admin pass on top of evening 2026-05-03 third pass).  Strategic frame: bring `llvm-z80/llvm-z80` (active fork-of-record, owner @zlfn) to maturity via collaborative work; eventual official LLVM upstream is long-term aspiration.  Workspace mode (current) → engagement mode (gated on substantial body of work) split.  **Phase status (session 42, 2026-05-03):** Phase 1 Foundation **DONE**; **Phase 2 Correctness sweep DONE** — four issues fixed (#28, #36, #63, #81) plus **#38 reclassified to Phase 3** because session 39 proved its residual is greedy-regalloc cost-model under -Os, not Phase 2 codegen-correctness; Phase 3 Cluster A regalloc **3 of 5 closed** on its original membership (#94, #98, #99 closed earlier), now also owns #38; #89 + #27 remain as multi-session investigations and are expected to subsume #38 as a side effect.  Engagement-mode gate is **one cluster away**: finish #89/#27, then engage.

Session #47 (2026-05-06/07): cpnos-rom data-driven relocator (header-prefixed payload).  Branch `session47-cpnos-header-driven-relocator` in z80, rc700-gensmedet, cpnos-rom.

(1) **Plan #19 approved + steps 1-5 implemented** (clang side).  Replaces the four-way coupling (C decl + linker script + Makefile awk + Makefile defsym) that wired payload metadata into the relocator with a small `__payload_header` struct emitted into the PROM image at link time.  Header carries: magic/version, resident dest, chunk srcs/sizes (linker-emitted, no hardcoded 0x0400), cold entry, checksum magic, sentinel-terminated BSS-pair list.  Relocator reads it at boot.  6 of 7 cross-stage `--defsym` lines deleted from `cpnos-rom/Makefile`; only `__stack_top` remains (consumed by reset.s before the relocator runs).  `cpnos-polypascal-test` PASS end-to-end (PPAS PRIMES → 29989 → E>) at every step.  Steps 6-8 pending: SDCC port of unified `relocator.c` (replaces `prom_loader.asm`); IVT section + IVT pair to header (closes task #18); cleanup.

(2) **Two memory-layout bugs identified in the SDCC port and one fixed**: IVT overlap (active JP-0 source — `defc __ivt_start = 0xF500` had no SECTION reservation; `_cursor_down` and `_cursor_up` placed inside the range; setup_ivt destroyed their middle bytes; fix folded into plan #19 step 7); `_pio_rx_buf_page` mismatch (latent — constant 0xF7 disagreed with actual placement at 0xECEE; **fixed this session** by deriving `_pio_rx_buf_page = HIGH(_pio_rx_buf)` in both pipelines via linker symbol expression).

(3) **`.init` VMA shift `0x0100 → 0x0200`** in clang's payload.ld + relocator.ld to give the data-driven relocator a 512 B code budget (header parsing + BSS-pair loop grew the relocator from 110 B to 393 B).  `PROM0_TAIL_SIZE 1024 → 768`; chunk B grew from 708 to 964 (still within 1536 B clearance from display memory at 0xF800).  Total payload size unchanged.

(4) **Compiler stamped in the boot banner** via new `CPNOS_COMPILER_NAME` macro in `compiler/compat.h` selected from `__clang__`/`__SDCC`/`__HITECH__` predefined macros at preprocess time.  Banner format: `RC702 CP/NOS 55K PIO-IRQ clang 2026-05-07 08:55 6fd1b93+`.  Operator can now identify the build at a glance from a serial-log scrape — no Makefile -D flag to forget.

(5) **Memory-layout investigation written** (`cpnos-rom/tasks/memory-layout-investigation-2026-05-06.md`) — full survey of both pipelines' MEMORY/SECTION/`defc`/ASSERT vocabularies, catalog of pinned-vs-movable items, design rationale for fully linker-driven layout.  Plan #19 implements the recommendation.

(6) **4 new HARD-RULE memory entries** captured (per the user-flagged "extract rules from time-sinks" meta-rule, also added this session): `feedback_memory_layout_on_port.md` (audit memory layout when porting); `feedback_extract_rules_from_time_sinks.md` (the meta-rule); `feedback_relink_dependencies_atomically.md` (cross-stage --defsym requires C decl + linker + Makefile awk + Makefile defsym in one commit); `feedback_kill_stale_servers_on_test_target.md` (auto-cleanup leftover daemons rather than abort).

(7) **Tasks filed**: #20-23 (relocator inline-asm hl clobber, header version check at boot, cross-compiler symbol parity audit, stale 0x0100 comments).  #18 absorbed into plan #19 step 7.

(8) **Steps 6-8 landed 2026-05-07 (afternoon continuation)**:
  - **Step 6** (commit `d2485c8`): `relocator.c` compiles under SDCC and replaces `prom_loader.asm`; SDCC slave boots through the unified C relocator (banner `RC702 CP/NOS 55K SIO sdcc ...` on display, slave reaches netboot wait loop).  Two side-fixes folded in: (a) SDCC reset.asm sets SP=0xEC00 (was 0xF700) so library calls during the relocator don't push into the resident bytes the checksum is about to read; (b) a `__naked` `relocator_zero` helper inlines LDIR-from-self to side-step a z88dk-zsdcc 4.5.0 calling-convention mismatch where `--sdcccall=1` codegen for `memset(d,0,n)` doesn't match `_memset`'s sdcccall=0 stack-arg preamble (filed as #26).
  - **Step 7 clang side** (commit `0e8fc58`): `--include-ivt` added to gen_payload_header.py invocation; (`__ivt_start`, `__ivt_end`) now lands in the header's bss_pairs list and the relocator zeroes the IVT region during the BSS-clear pass before checksum.  SDCC side blocked on **#29** (resident is currently exactly full at 2560 B; reserving a 36-byte page-aligned `RESIDENT_IVT` section costs ~38 B, requires SDCC code-size trim work).
  - **Step 8** (commit `302ce24`): `sdcc/prom_loader.asm` physically deleted; `tasks/scripts/check_sdcc_layout.py` extended with payload-header sanity check (verifies magic 0x6350, version 0x0001, sentinel pair within 64 B after header).  Both fail paths verified by manual tampering.
  - **Persistent SDCC IX+/IY+ frame-pointer regression gate** (commit `55d68c2`): new `tasks/scripts/check_no_frame_ptr.py` scans per-source `.s` files for `(ix±d)` / `(iy±d)` operands, identifies the violating function, and fails the build if any new (file, function) appears -- or if a baselined function's count grows.  Two known violators captured: `relocator.c::relocate` (10 hits, fundamental locals count) and `resident.c::delete_line` (2 hits).  Tracked as #27 / #28.

(9) **Two more HARD-RULE memory entries** captured (session 47 evening): `feedback_no_stale_dump_files.md` (`rm -f /tmp/foo` BEFORE the producer command, every iteration); `feedback_no_dotall_backtracking.md` (don't combine Python `re.DOTALL` with non-greedy `.*?` over multi-line source -- catastrophic backtracking; use awk/grep or hand-rolled state machine).

(10) **Plan #19 status post-session-47**: 7 of 8 structural steps fully done (1-6, 8); step 7 done on clang side, blocked on SDCC step 7 by #29.  Outstanding tasks: #29 (relocate IVT to 0xFFD0 — see below), #26 (file z88dk memset bug upstream), #27/#28 (drive IX-spill baseline toward zero), #21 (runtime version check, low priority), #13 (hunt remaining JP-0 sources, gated on #29).

(11) **`--opt-code-size` investigation (commit `8429b8d`)**: User asked whether SDCC was being told to optimize for size.  No -- the build was running at default speed-tuned codegen.  First attempt at adding `-Cs"--opt-code-size"` saved only 6 B (caught me passing it through `-Cs` instead of as a zcc-level flag — sibling rcbios-in-c already had the right wrapping; HARD RULE memory entry `feedback_check_sibling_subprojects.md` captures the lesson).  Lifted to zcc level so z88dk's peephole file flips from `sdcc_peeph.3` to `sdcc_peeph_cs.3` and saw ~17 B of code-size savings.  BUT `--opt-code-size` factors out an 11 B `___sdcc_enter_ix` shared helper as `code_l_sdcc`, which amortises only against IX-frame function prologues — this build has just 2 such functions (the audit's known violators), saving 6 B on prologues but paying 11 B for the helper.  Net: +5 B resident, overflows display memory at 0xF800.  **Reverted; documented in Makefile comment.**

(12) **Memory-map gap analysis surfaced clean fix for #29 (2026-05-07 evening user pointer)**.  Display memory is hardware-mapped 0xF800..0xFFCF (2000 chars, 80×25), leaving 0xFFD0..0xFFFF = **48 B of scratch RAM** at the top of the address space.  isr.c:130 uses 4 of those bytes (frame counter at 0xFFFC..0xFFFF); the remaining **44 B at 0xFFD0..0xFFFB are unused**.  A 36 B IVT fits cleanly there with 8 B spare — no resident trim required.  Cost: reconfigure each device's vector low byte in `port_init[]` from the current 0x00..0x22 to 0xD0..0xF2, set `I = 0xFF`, and update the IVT_ADDR macro.  This is a much cleaner #29 path than trimming SDCC code to land a `RESIDENT_IVT` section — the IVT moves OUT of the resident region entirely, and the same approach applies to clang (replace `__ivt_start = 0xF500` with 0xFFD0, freeing 36 B of clang resident).

See `tasks/session47-cpnos-header-driven-relocator.md` (full session report including 10 followup issues), `cpnos-rom/tasks/memory-layout-investigation-2026-05-06.md` (design analysis), and `/Users/ravn/.claude/plans/harmonic-sleeping-spring.md` (the approved plan).

Session #46 (2026-05-06): cpnos-rom SDCC port reaches NDOS handoff (~95% done).

(1) **Phase 2B/2C/2E landed under SDCC**: 7 hand-written z88dk asm files in `cpnos-rom/sdcc/` (`sections.asm`, `reset.asm`, `prom_loader.asm`, `bios_jt.asm`, `snios.asm`, `hal.asm`, `xport_aliases.asm`); single-stage z88dk link emits one resident binary at VMA 0xEE00..0xF7FF; Makefile dd-splits into PROM0 tail (chunk A, 1024 B for RAM 0xEE00..0xF1FF) + PROM1 (chunk B, 1536 B max for RAM 0xF200..0xF7FF, capped to clear display memory at 0xF800).

(2) **Path 4 — cpnos.com base shift to 0xDF80**.  Original CODE_BASE LE180 made cpnos.com end at 0xEE00; SDCC's larger BSS at 0xEC00 was getting clobbered by netboot sectors 22+, killing `_cfgtbl.netst.ACTIVE`.  Fix: `cpnos-build/Makefile` CODE_BASE LE180→LDF80, DATA_BASE DDD80→DDB80 — cpnos.com now ends at 0xEC00, frees 0xEC00..0xEDFF for slave BSS.  TPA reduces 56→55 KB (acceptable).  Both clang and SDCC slaves load same cpnos.com at new address — clang reaches `E>` prompt, SDCC reaches NDOS but doesn't (yet — see (5)).  Permanent fix tracked: relocatable cpnos.SPR refactor (RELOCATABLE_SPR.md option a, task #11).

(3) **Eight bring-up bugs found and fixed during the session**: TRANSPORT_NAME quote-escaping under zcc; `<string.h>` shim for `__builtin_mem*` since z88dk-zsdcc 4.5.0 lowers builtins to library calls without auto-declaring; SDCC only emits asm EXTERNs for file-scope `extern` declarations (block-scope ones get silently dropped — fixed by hoisting in `init.c` and `isr.c`); PATH export for `z88dk-z80asm` / `z88dk-appmake`; `xport_aliases.asm` JP-trampoline generator (z88dk has no `--defsym` equivalent); cpnos.com base shift; **NIOS placement** (BIOS jt at 0xEE00 so SNIOS jt lands at 0xEE33 per `cpnos-build/src/cpnios-shim.asm` EQU); **`_bios_stub_ret` outside resident range** (placed by SDCC in `code_l_sccz80` runtime-library section ~0xEDF4, OUTSIDE our PROM-loaded resident — every NDOS call to LIST/PUNCH/SELDSK/READ/WRITE jumped into uninit RAM → eventual JP 0 → warm-boot loop; fixed by defining symbol in `sdcc/bios_jt.asm SECTION RESIDENT_CODE`).

(4) **Phase 2D progress**: `cpnos_main.c::resident_handoff`'s `zp_init_data` LDIR was `#ifdef __clang__`-gated with no-op SDCC `else` — ZP[0..7] never written under SDCC.  Replaced with `ASM_VOLATILE("ld hl,_zp_init_data; ld de,0; ld bc,8; ldir")`.  `resident.c::insert_line` LDDR still gated (task #17).

(5) **Status — 25-dot netboot + handoff + NDOS COLDST + nwboot work; CCP load triggers stack corruption**.  Boot marks confirm `I PNILOREC+P J` (every cold-init phase visible).  Slave reaches NDOS coldst, runs nwboot, attempts CCP load via `call load`.  Stack inspection at hang shows multiple `0x0000` return addresses interleaved with valid resident addresses — additional JP-0 cascades remain (task #13).  clang at the same cpnos.com address reaches `E>` prompt cleanly, validating cpnos.com itself + most of the resident code paths.

(6) **Polypascal-test infrastructure blockers** (independent of compiler choice): MAME_IRQ branch (ravn/mame:cpnet-fast-link with `-piob cpnet_bridge` support) not built in this workspace (task #15); test harness uses `llvm-nm payload.elf` for symbol extraction — clang-specific (task #16).  Test cannot run yet for either compiler.

(7) **Lessons captured** (in `cpnos-rom/tasks/sdcc-port.md`): (a) SDCC silently drops block-scope `extern` declarations from asm output — always declare cross-file references at file scope.  (b) z88dk's link inserts runtime-library sections (`code_clib`, `code_l_sccz80`, `code_string`) into address gaps before user-org'd sections — small functions (`void f(void){}`) can land OUTSIDE the user-controlled resident region.  (c) symbol-by-symbol audit of every NDOS call target is a known-needed step (task #14).  (d) cpnos.com address shifts cascade through `cpnos_addrs.h` regeneration; both compilers must rebuild after a shift.  (e) build-time stack-mismatch detection would have caught (b) earlier — adding it is task #14.

(8) **Phase 2F link audit landed (closes task #14)**: `cpnos-rom/tasks/scripts/check_sdcc_layout.py` parses `sdcc/cpnos.map`, walks every `addr` symbol and every `__SECTION_head/size/tail`, fails the build if a `code_*`/`rodata_*`/`data_*` symbol resolves outside the resident range 0xEE00..0xF7FF, a `bss_*` symbol resolves outside the BSS scratch range 0xEC00..0xEDFF, or any two non-zero-size sections overlap.  Wired as a hard build gate in the SDCC `cpnos.cim` recipe (`Makefile:1354`).  On its first run it caught a NEW outside-resident symbol independent of bug #8: `_memset @ 0xEDF1` with `code_string` overlapping RESIDENT_JUMPTABLE at 0xEE00..0xEE0D — every `__builtin_memset` in `resident.c` (clear_screen, scroll_up, erase_to_eol/eos, insert/delete_line) was a dormant JP-0 source.  Fix: declare every z88dk runtime section explicitly in `sdcc/sections.asm` so z88dk has nowhere else to put them (`code_clib` / `code_string` / `code_l_sccz80` / `code_home` / `code_crt_init` / `code_compiler` at end of resident chain; `rodata_*` / `data_*` after RESIDENT_RODATA; `bss_clib` / `bss_string` after `bss_compiler`).  Post-fix: `_memset @ 0xF7A3` (inside resident, dd-split chunk B contains the bytes); audit re-runs on every SDCC build and refuses to produce `cpnos.bin` on regression.  Generalises bug #8's manual fix into a class-level guard.

See `rc700-gensmedet/cpnos-rom/tasks/sdcc-port.md` (full session findings, Bugs Fixed list, Architecture summary) and `rc700-gensmedet/tasks/timeline.md` Phase 46 for the structural plan.

Session #45 (2026-05-05/06): cpnos-rom dual+triple compile port — Phase 1 + 2A landed.

(1) **Phase 1 source-level dual-compile DONE**.  All 10 cpnos-rom `.c` files now compile clean under both clang Z80 and SDCC z88dk-zsdcc.  Clang side byte-stable: payload **1738 B**, PROM0 **1778 non-padding B** (unchanged from session-44 baseline).  Major pieces: `hal.h` 3-backend dispatch with the same `_port_in(p)` / `_port_out(p, v)` call shape across clang Z80 / SDCC / HiTech / host fallback; new `compiler/compat.h` consolidates `ASM_VOLATILE`, `__naked`, `NORETURN`, `USED`, `NOINLINE`, `STATIC_ASSERT`, `SECTION_*`, `CPNOS_STR(x)`, and uniform `intrinsic_di/_ei/_halt/_nop/_im_2/_ld_i_a` (SDCC pulls z88dk's `<intrinsic.h>`, clang has matching `static inline` wrappers); `tasks/scripts/bin2inc.py` is the `#embed` workaround (`#include "x.inc"` from generated byte streams) — both compilers see identical C source; numeric local labels in inline asm replaced with globally-unique labels (`_isr_crt_count_done` etc.); `__naked` keyword positioned after declarator for cross-compiler parity.

(2) **Phase 2A Makefile dispatch DONE**.  `make cpnos COMPILER=clang|sdcc|hitech` selects the build path.  `BUILDDIR = $(COMPILER)` parameterized 96 hardcoded `clang/` references.  Per-compiler tool/flag block: clang uses ld.lld + llvm-objcopy (existing path, byte-stable); SDCC uses `+z80 -compiler=sdcc -clib=sdcc_iy --no-crt -Cs"--std-sdcc23" -Cs"--sdcccall 1"` with native zcc preferred / Docker fallback; HiTech `$(error not yet implemented)`.  `make cpnos COMPILER=clang` byte-identical to baseline; `COMPILER=sdcc` reaches the assembler and stops at the first .s file (Phase 2C).

(3) **Phase 2 remaining (NOT DONE, ~8-14 hours)**:  **2B** linker port (`cpnos_rom.ld` 4 memory regions → z88dk `sdcc/sections.asm` + `appmake +rom`); **2C** parallel `.asm` files for SDCC for `reset.s` / `runtime.s` / `bios_jt.s` / `snios.s`; **2D** `mem_copy_forward` / `mem_copy_backwards` helpers in runtime.{s,asm} replacing the two `#if defined(__clang__)` gates around inline LDIR/LDDR (`resident.c::insert_line` + `cpnos_main.c::resident_handoff` — `__builtin_memmove` was tried as a fallback but inflated the clang payload past budget); **2E** validate via `cpnos-polypascal-test`.

(4) **User-stated principles recorded as memories**.  "clarity in the c code is very important" (`feedback_clarity_in_c_code.md` HARD RULE) drives the entire compiler-dispatch design: identical call shape across backends, all `#ifdef` confined to `compiler/compat.h`, no `#ifdef __SDCC` in business logic.  "z88dk has intrinsic definitions" steered Phase 1B toward `<intrinsic.h>` reuse over rolling our own.  `project_cpnos_clang_only.md` updated to note the direction reversal (was: clang-only acceptable; now: dual-compile in progress, HiTech scaffolded).

(5) **#embed spike + decision.**  Sketched a minimal SDCC-side `#embed` patch (~200 LOC in `sdcpp/libcpp/directives.cc`, 1.5-3 days with debug variance against ~30 LOC + 1-2 hours for the build-script workaround).  User chose the workaround.

(6) **Lessons (session 45)**: (a) Header naming clash bites silently — `compiler/intrinsic.h` recursed into itself when SDCC tried `#include <intrinsic.h>`; renamed to `compiler/compat.h`.  (b) `__builtin_memmove` is not a free portability fallback on clang Z80 — payload-size cost is real; measure first.  (c) Parallel Edit-tool batches on the same file can leave it at 0 bytes silently — do edits sequentially when modifying one file; verify with `wc -l` after batches.

See `rc700-gensmedet/tasks/timeline.md` Phase 45 and `rc700-gensmedet/cpnos-rom/tasks/sdcc-port.md` for the structural plan.

Session #44 (2026-05-05): rolling-walk validation + CI fix + planning refresh.

(1) **Rolling-walk** through 13 post-merge ravn-fork commits in `da18ede..HEAD`, surgical Z80-only checkouts with #74 reverted on top per step.  Per-step source-annotated listings committed to `rc700-gensmedet:5dbedb6..b75b7ae` (14 commits + walk-summary).  Result: **#74 (96dde0c) is the ONLY boot-breaking regression** in this window — every other codegen-changing commit between `da18ede` and HEAD boots autoload-in-c correctly with #74 reverted.  Step 13 (#120 active) PASSes the boot test but is documented as a known-symptomless case where peephole #26 masks the IR-layer miscompile.  Procedure documented in `tasks/issue-74-cross-pair-rca-2026-05-04.md` ("Surgical-walk procedure").

(2) **CI fix** (commit `99198c91`).  Updated `static-stack-loop-counter-desync.ll` CHECK directives to assert post-#82 conservative codegen (`ld (slot),bc; ld hl,(slot); ...; ld bc,(slot)`) instead of the reverted #74 cross-pair shape (`push bc; pop hl; push hl; ...; pop bc`).  Test now serves as a regression-lock against the cross-pair extension coming back without proper investigation.  CI run `25358763543` green.

(3) **Issue triage refresh.**  **Reopened**: ravn/llvm-z80#74 with full implementation instructions (4 investigation hypotheses, 2 restoration paths, HARD-RULE verification protocol, refs to RCA + lessons + walk listings); ravn/llvm-z80#120 with three sound migration paths (post-ISel combiner / split G_ICMP lowering / change BooleanContents target-wide).  **Filed**: #123 (`-g`-affected codegen), #124 (workspace cmake/benchmark issue).

(4) **Plans refreshed**: `tasks/plan-2026-05-03-structural.md` updated with sessions 43 + 44 entries and 2026-05-05 issue-state snapshot.  `tasks/issue-74-cross-pair-rca-2026-05-04.md` updated with surgical-walk procedure recipe and walk-listings carry-forward.

Net session 44: working compiler at HEAD, lit 90/90, CI green, autoload-in-c boots, three open issues with actionable instructions.

Session #43 (2026-05-04 evening): #74 cross-pair extension fully reverted (commit `b843d94`) after bisect pinned `96dde0c` as the autoload-in-c boot regression.  Conservative fix `021d5e5` (cross-pair revert only, keep LIFO refactor) was *insufficient* — autoload still hung.  Full revert via splice of `da18ede`'s BSS-spill block.  Cost: rcbios 5929 → 5961 B (+32 B).  Mechanism still unknown.  Build hygiene work landed: distinct artifact names per compiler (`bios.clang.cim`, `prom.clang.bin`); source-annotated listings tracked in git; CI workflow uses canonical `check-llvm-codegen-z80` target.

Session #42 (2026-05-03): two deliverables, no codegen changes that landed.

(1) **Phase 2 admin pass.**  Closed Phase 2 by reclassifying #38 from Phase 2 (correctness) to Phase 3 (Cluster A regalloc).  Justification: session 39 already re-tested un-reserving IY with #28 and #105 fixed and got 11 runtime FAILs + 52 compile FATALs — the residual bug is the greedy register allocator's cost-model on Z80's 3-pair file under -Os IR pressure, i.e. the same surface area as #94/#98/#89/#27.  Issue #38 comment 4 already records this finding ("Stays parked for the Phase 3 regalloc cluster").  Updated `tasks/roadmap-to-maturity.md` (sections 12.2, 12.3) and `tasks/plan-2026-05-03-structural.md` (phase table, engagement-mode gating, near-term sessions, summary).  Phase 3 step 6 now explicitly schedules #38 as a re-test step gated on #89/#27 cost-model work — do NOT attempt #38 directly before that work lands.  Commits `de311bfbda4a` (llvm-z80) + `df9ed69` (root).

(2) **#89 investigation — two paths ruled out empirically.**

  **Path 1** (drop `isAsCheapAsAMove` from `LD_r16_nn` pseudo): BIOS +15 B / cpnos-rom +20 B.  TableGen flag couples MachineLICM hoist and RegisterCoalescer remat; Z80 needs them to behave oppositely; flag is too coarse.

  **Diagnosis sharpened via MIR dump:** `-print-before/after=register-coalescer` confirms MachineLICM hoists `LD_r16_nn @target_fn` to slot 16B (entry block), then RegisterCoalescer pushes it back to slot 320B (loop body) via `reMaterializeDef`.  RegisterCoalescer ALREADY HAS `MachineLoopInfo` but doesn't consult it at the cheap-as-move remat gate (line 1316).

  **Path 2** (add loop-depth check to `RegisterCoalescer::reMaterializeDef`, two variants tested): BIOS +3 B / cpnos-rom +4 B.  5x smaller blast radius than Path 1 but still net negative.  Variant 1 (`UseDepth > DefDepth`) and Variant 2 (`DefDepth == 0 && UseDepth > 0`) produce byte-identical results — all regression sites already match the depth-0-to-N pattern, but blocking remat at those sites increases pressure inside the loop and forces *worse* spills (typically 16-bit pointer to BSS).

  **Conclusion:** the decisive factor at the coalescer-time remat gate is register pressure on Z80's 3-pair file, not loop depth.  Both Paths reverted; no compiler-source commits landed (only doc commits).  Findings in `tasks/issue-89-investigation-2026-05-03.md`.  Future #89 work should pursue option (b) [Z80 pre-RA pressure-aware pass] or option (c) [merge into broader regalloc cost-model surface]; (c) remains the recommendation.

  **Lessons:** (a) TableGen flags couple multiple passes — when the target needs them to diverge, the flag is the wrong knob; (b) synthetic-only data misled in Path 1 — measure rcbios + cpnos-rom before believing a regalloc-area change; (c) loop-depth alone is insufficient context at the coalescer remat gate — register pressure is the dominant factor on Z80's constrained file.

**Net session 42 status:** Phase 2 closed (admin); two #89 paths ruled out with measured byte costs; next-session #89 work has two open options (b) or (c) with (c) recommended.  Engagement-mode gate unchanged from earlier session 42 update.

(3) **#120 attempted combiner migration ruled out as unsound.**  Wrote a `z80_sext_from_icmp` rule (rewrites `G_SEXT (G_ICMP)` → `G_ANYEXT`) and a sibling `z80_ashr_shl_from_icmp` rule (catches the post-legalization `G_ASHR (G_SHL X, 7), 7` form).  Both rules built clean, lit suite passed (90/90), and they recovered 10 of the 14 BIOS bytes that disabling peephole #26 had cost.  But a post-combiner MIR dump on `bios_conin` (which contains the canonical `kbstat = (kbtail != kbhead) ? 0xFF : 0x00;`) revealed the rules are **silently incorrect**: Z80's `BooleanContents` is `ZeroOrOneBooleanContent` (Z80ISelLowering.cpp:49), not `ZeroOrNegativeOneBoolean`.  The G_ICMP s8 result is therefore `0x01`/`0x00` (low bit only) by IR contract — even though the Z80 instruction selector physically lowers G_ICMP via `SUB; ADD a,$ff; SBC a,a` which leaves a full mask in A.  At the GISel layer the `(shl 7; ashr 7)` shift idiom is a meaningful **widen** from 1-bit-encoded i1 to full-mask i8, NOT an identity.  Eliding it produces 0x01/0x00 instead of the source-required 0xFF/0x00 — silently breaking any consumer that needs the full mask.  Peephole #26 IS sound because it operates **post-Instruction-Selection** where it can rely on the target-specific invariant "after SBC A,A on Z80, A holds a full mask physically" — a property the GISel combiner can't access.  Both rules reverted; peephole #26 source comment updated to record the empirical finding.  Scoping doc rewritten with three revised migration paths (post-ISel combiner, split G_ICMP lowering, change BooleanContents target-wide), all multi-session.  Recommendation: park #120 until regalloc cluster work done; revisit with fuller context.

  **Lessons (session 42 #120):** (a) GISel combiners can rely only on IR contracts, not on target-specific lowering invariants; (b) `mask-from-flag.ll` is a weak test (CHECK-NOT on instructions, not value semantics) — use rcbios/cpnos-rom builds as verification harness for combiner changes; (c) the `and $1` after `sbc a,a` in pre-peephole asm is the `ZeroOrOneBoolean` truncation, NOT redundant — future readers should not assume otherwise.

**Net session 42 final:** Phase 2 closed; #89 two paths ruled out; #120 attempted migration ruled out as unsound (combiner reverted, peephole #26 stays); compiler tree byte-identical to session start (5929 / 1777, lit 90/90).

(4) **Lessons doc landed** (`llvm-z80/tasks/lessons-2026-05-04-structural-fix-failures.md`) capturing the meta-pattern across all three failed structural-fix attempts and the four process changes that would have caught them earlier.  **HARD RULE elevated by the user 2026-05-04** (also in `~/.claude/.../feedback_no_commit_first_version.md`): **stop committing the first version of a structural fix the moment lit + size are clean**.  Lit + size are a *size oracle*; combiner / ISel / lowering changes need a *value oracle* too (test-runner suite via `cargo run -- clang`, plus MAME boot for BIOS-touching changes).  A combiner+peephole composition that produces byte-identical baseline output is a **red flag** for "the peephole is covering for a broken combiner", not a green light.  Session 42 attempt 3 was exactly such a value miscompile that the size oracle missed because the peephole+combiner composition produced byte-identical output to baseline.  Audit reclassification: peephole #26 moved Delete → **Keep** (post-ISel-invariant; not migratable to GISel); #27/#28 flagged Likely Keep pending the same check; the entire 16-entry Migrate column is "candidate pending discriminator check", not "ready for migration".  Future regalloc / combiner / ISel work MUST follow the four process rules in the lessons doc.

**The discriminator** (use for any future "should this peephole be migrated?" question): a peephole is migratable if it (a) re-derives information available earlier in the pipeline OR catches cases that should never have been emitted by a cleaner upstream pass.  A peephole is the right home if it (b) exploits a target-specific physical-register invariant created by the chosen lowering (e.g., "after SBC A,A on Z80, A holds a full mask").  Category (b) cannot be moved to GISel/IR without large surgery (target-specific intermediate analysis pass, IR contract change, or split G_ICMP lowering).

Evening continuation 2026-05-03 (post-session 41): closed **#113** (GR16NoIR on `XOR_CMP_*16` + `SM83_CMP_Z16` operands, commit `e4b3496a`; sibling of #112 IY un-reserve plumbing; byte-neutral with IY currently reserved, lit 90/90 with new `issue-113-gr16noir-cmp.ll`).  Closed **#121** (filed and immediately closed: `XOR_CMP_*16` IR16 PUSH/POP fallback became unreachable after #113's class restriction, ~38 LOC removed, commit `c8d2dbed`).  Closed **#119** as duplicate of #102 — the disabled EXX block was already deleted in commit `2c9395f6` on the session-37-phase-1-foundation branch (now in main); the audit doc had stale line refs.  Closed **#118** (audit complete: `tasks/audit-emitFusedCompareAndBranch.md`; six potential gaps examined under structural-first lens, all skip — function is at a good local optimum at ~550 LOC; filed #122 as low-ROI tracking for the only real but zero-fire-site gap).  Phase 3 Cluster A re-verified: **3 of 5 closed** (#94, #98, #99 closed in earlier sessions; #89 + #27 remain as multi-session investigations).  Engagement-mode gate is now **one thread away** (loose reading) or two threads away (strict): close #38, optionally finish #89/#27.  Lessons: (1) read current source state before filing follow-up issues — #119 was filed without checking that #102 had already deleted the block; trivial cost but preventable.  (2) audit docs decay — line references become stale within the same session that wrote them.  See `tasks/plan-2026-05-03-structural.md` (third-pass evening update) and `tasks/audit-emitFusedCompareAndBranch.md`.

Session #41 (2026-05-03): closed ravn/llvm-z80#116 with a -4 B rcbios win.  Two attempts: morning ISel-time gate (`hasMinSize()` → `SUB_HL_rr`) regressed bios.cim +27 B because forcing LHS into HL evicts long-lived values; reverted in same session (merge `2bd035317e55`).  Afternoon post-RA peephole in `Z80LateOptimization.cpp` (~170 LOC) only fires when regalloc has *already* parked one operand in HL and HL is dead-after-branch — sidesteps eviction by construction (merge `9afb40502956`).  rcbios bios.cim 5933→**5929 B** (-4 B); cpnos.bin 1777 B (no fires).  Z80 lit 86 PASS + 1 XFAIL.  #114 ROI survey: 6 BSS-pair stores in rcbios; only one matches the static shape (`_bg_set_at` bgstar) and even that's unsafe (DE loop-carried).  Session 35's BC ping-pong peephole already absorbed the simple cases #114 was designed for; original strand-B candidate list is stale.  Lessons: per-fire savings math is incomplete without a regalloc-state model; static fingerprints can match non-target instructions sharing opcodes.  Triage 2026-05-03 retired the "Phase 4 Cluster B (#100, #20, #96, #16)" recommendation: #20/#16 owner-downgraded since session 36, #96 is investigation-only, #16 belongs to Cluster A per the canonical roadmap (mis-clustered in earlier note); only #100 is live in Cluster B.  **Structural-lens re-rank** (per restated user principle: "underlying datastructures should reflect z80 properties, not fix bad modelling with peepholes"): next entry should advance modelling, not accumulate post-RA fixups.  Top picks: **#113** (TableGen class restriction; declarative; gates IY un-reserve), **#98 + #94** (regalloc hint cluster per roadmap section 12.3 — one cost-model change closes 4-5 Cluster A issues incl. #89/#99/#27), or **Phase 1 Foundation** (CI + size baseline) so structural work has measurable feedback.  Demoted: #109, #108 (peephole audits — useful but structural-zero), #100 option 1 (peephole extension); #100 should land via option 2/3 (regalloc cost-model / pre-rotation hint) instead.  See `llvm-z80/tasks/triage-2026-05-03-cluster-b.md` ("Lens: structural fixes over peephole accumulation") and `llvm-z80/tasks/session41-summary.md`.

Session #36 (2026-05-02 evening): no codegen changes — strategic reframe + research + upstream sync.  4 parallel research agents: backend-area audit (~80% production-ready, 79 files / 27K LOC), upstream LLVM Z80 status (no Z80 in llvm/llvm-project; jacobly0 archived; llvm-z80/llvm-z80 active under @zlfn), peer-target precedent (DJNZ-as-primary was wrong; ARM uses post-RA fusion via ConstantIslandPass; Z80's pseudo+peephole is aligned), open-issue triage (27 open, 5 correctness, 22 pessimization, 6 clusters).  Master plan `tasks/roadmap-to-maturity.md` lays out 9-phase execution, 13-23 calendar weeks part-time.  Upstream sync: merged llvm-z80/llvm-z80:main (~3782 commits, 1 Z80-source change: zlfn's Combiner API fix); build clean; lit 77 PASS + 1 XFAIL; sizes byte-exact (5920 / 1708).  Filed ravn/llvm-z80#101 (missing `override` markers on Z80TargetTransformInfo.h post-merge).  See `llvm-z80/tasks/session36-summary.md`.

Session #35 (2026-05-02): closed ravn/llvm-z80#97 (BC ping-pong in single-BB self-loops).  New post-RA peephole in `Z80LateOptimization.cpp` (~250 LOC) handles three pred shapes (`LD C,L; LD B,H` from HL param, `LD HL,nn N; LD BC,nn N` constant in both, `LD BC,nn N` only) crossed with two body orderings (anchor-first vs anchor-last).  Filed #99 (i16-counter sub-case where counter and pointer compete for HL — needs regalloc-level swap, parked) and #100 (rotation-around-CALL forces BSS spills: rcbios +33 B, cpnos-rom +4 B with rotation on; now the gate on #77a default-on).  `Z80LoopRotate` stays default-off pending #100.  Sizes unchanged from session 33 baseline (peephole still fires on Case 1 hand-written shapes; PROM0 non-padding -1 B).  See `llvm-z80/tasks/session35-summary.md`.

Session #33 (2026-05-02): regalloc cluster + BSS-spill family.  rcbios 5967→**5920 B** (-47 B); cpnos-rom payload 1730→**1708 B** (-22 B); Z80 lit 73/73 → 75/75.  Closed #92 (nested-loop DJNZ direction; getRegAllocationHints requires self-back-edge), #74 (PUSH/POP for short-lived 16-bit spills, no-CALL + cross-pair), #53, #37, #39.  Branch `z80-regalloc-cluster`.

Session #34 (2026-05-02): source-cleanup audit + Z80LoopRotate (gated off) + #97/#98 investigation.  No size win; landed `Z80LoopRotate` pass + filed #96, #97, #98 with thorough investigations and lit tests (77/77 = 76 PASS + 1 XFAIL).

Session #32 (2026-05-01/02): cluster 2 (DJNZ + LDIR family) + adjacent peepholes -- 8 issues fixed (#78, #88, #64, #91, #82, #76, #93, #86), 5 filed (#91 fixed same session, #92, #93 fixed same session, #94, #95), 15 retroactively closed.  rcbios BIOS 5998→5967B (-31B); cpnos-rom payload 1738→1730B (-8B); Z80 lit 65/66+1 XFAIL → 73/73.  Highlights: #88 new IR pass `Z80LoopIdiomFill` for K-byte (1-4 incl. jump-table) constant-trip pattern fills → seed+LDIR; #82 BSS-spill peephole orphan-reload bug fixed (XFAIL → PASS); #76 LD A,(HL); LD r,A → LD r,(HL); #93 carry-roundtrip elimination (11→3 B per countdown loop body); #86 u8 switch range-check 16→8 bit (saves 4 B per switch).  See rc700-gensmedet/tasks/timeline.md Phase 32 and llvm-z80/tasks/issue-status-2026-05-02.md.

Session #12: PROM fixes #58 (JP→JR), #60 peephole, cross-block OR A, #62 dead HL copy, LD (nn),A→LD (HL),A peephole — PROM 1771→1756B (-15B). BIOS fixes #62-#68 (7 compiler fixes), DJNZ peephole, #66 BSS reload fix, #53 relocate_bios rewrite (clean C with __builtin_memcpy + BSS-clear-first ordering), check_no_bss_in_relocate.py test — BIOS 5952→5826B (-126B). Native macOS build replaces Docker for compilation.

Session #18 (2026-04-18): Serial speed investigation. CTC-to-SIO shared clock confirmed (no split TX/RX). Z80-SIO/2 has NO DPLL/BRG (those are SCC features). SDLC mode with CTC clock at x1 is the fast path -- 250 kbaud bidirectional, ~28 KB/s (7x current). DMA channel assignments corrected (ch0=J8 external, ch3=display not free). J8 bus expansion documented. MAME rc702.cpp fixed: z80dart->z80sio (ravn/mame#3).

Sessions #20-21 (2026-04-18): SDLC TX validated on physical RC702 (SIO-A, CTC timer mode). DDT deploy path (`ddt_deploy.py`) replaces PIP+MLOAD. Host capture via FT2232D async bit-bang (`sdlc_capture.c` + `sdlc_receiver.py` with DPLL decoder). FT2232D caps at ~200 kHz bit-bang -- too slow for 250 kbaud capture. CTC CLK on PCB530 is NOT 4 MHz as MAME models (observed ~5 MHz, needs scope). Decoder logic verified correct via synthetic tests (`test_sdlc_decoder.py`); real captures show flag structure but zero CRC-OK frames -- likely RS-232 transceiver signal integrity issue on cheap adapter. Next HW step: FT2232H adapter (USB-COM232-PLUS2 from Farnell/Newark EU). Board identified as PCB530 (MIC702 variant). DB-25 pinout documented -- no TxC/RxC pins on MIC702/703, so sync RX from host is impossible without cable mod (TX-only SDLC viable).

Session #23 (2026-04-19/20): SIO async flow-control bug fixed.  `list_lpt`, `bios_punch_body`, `serial_conout` each rewrote WR5/WR1 per byte, clobbering the RX ISR's RTS-deassert and defeating RX flow control on sustained bidirectional traffic (RX overruns observed on 1024-byte test, 26% byte loss).  `readi()` now arms both SIOs and runs before banner.  SIO-B got symmetric RTS flow control.  MAME rc702.cpp `rs232b_defaults` FLOW_CONTROL 0x00→0x01 so null_modem honors RTS-B.  New `make sio-echo-test`: 4096-byte bidirectional BIOS-direct echo on both SIOs, passes clean.  BIOS size 6013→6002B.  See rcbios-in-c/tasks/session23-sio-flow-control.md.

Session #16 (2026-04-15/16): type-correctness sweep in BIOS sources. `dskad` word→byte* (-35B clang — fixed partial-constant-fold bloat), `dmaadr` word→byte*, FSPA/DPH const-correct (6 casts removed), bios_seldsk_c returns DPH*. `BUFF` renamed to `BDOS_DMAADDR`, `CCP_BASE` now typed as pointer. Both SIOs default to 38400 ×1 (prep for 76800/115200 on real HW — MAME Z80-DART ×1 receive fails at >38400, filed ravn/mame#2). `siob-baud` test harness auto-extracts BSS addrs from bios.elf. New llvm-z80 fix: #71 SRL A→RRCA when followed by AND mask (-13B clang). SDCC const-pointer codegen inefficiency filed as ravn/z88dk#2.

## Workspace Layout (`/Users/ravn/z80/`)

Everything lives under one folder:
- `llvm-z80/` — LLVM/clang fork with Z80 backend (shallow clone of github.com/ravn/llvm-z80)
- `rc700-gensmedet/` — RC700 CP/M system sources (github.com/ravn/rc700-gensmedet)
  - `autoload-in-c/` — Primary test case: ROA375 boot PROM in C (priority 1)
  - `rcbios-in-c/` — Secondary test case: CP/M BIOS in C (priority 2)
- `z88dk/` — z88dk toolchain (github.com/z88dk/z88dk, shallow clone). Contains sdcc/sccz80 compilers, Docker build workflows.

The autoload Makefile references `LLVM_Z80` relative to this workspace (via `$(CURDIR)/../../llvm-z80`).

## Build Commands

### LLVM-Z80 compiler (in Docker)
```bash
cd llvm-z80
cmake -C clang/cmake/caches/Z80.cmake -G Ninja -S llvm -B build
ninja -C build          # full build
ninja -C build clang    # just clang
ninja -C build llc      # just llc
```
Docker build image: `llvm-z80-build` (ubuntu:24.04 + cmake/ninja/clang/lld/python3).

### PROM builds (in rc700-gensmedet/autoload-in-c/)
```bash
make rom_parts          # SDCC build (needs z88dk in ../z88dk)
make clang              # Clang build (needs Docker + llvm-z80/build/)
make clang_asm          # Show clang assembly output
make mame               # Build SDCC PROM + boot test in MAME
make clang_prom         # Build clang PROM + install to MAME/RC700
```

### Tests
```bash
# LLVM lit tests
build/bin/llvm-lit llvm/test/CodeGen/Z80/

# Integration tests (in z80-utils/test-runner/)
cargo run                   # Default (O1, O2, Os)
cargo run -- clang          # Clang C suite
cargo run -- bench          # Code size benchmark
```

## Architecture

The llvm-z80 backend uses **GlobalISel** (not SelectionDAG). Key files:
- `llvm/lib/Target/Z80/Z80InstructionSelector.cpp` — instruction selection patterns (largest)
- `llvm/lib/Target/Z80/Z80LateOptimization.cpp` — peephole optimizations (most modified)
- `llvm/lib/Target/Z80/Z80ExpandPseudo.cpp` — post-RA pseudo expansion
- `llvm/lib/Target/Z80/Z80CallLowering.cpp` — sdcccall(0/1) calling conventions
- `llvm/lib/Target/Z80/Z80LegalizerInfo.cpp` — GlobalISel legalization
- `llvm/lib/Target/Z80/Z80RegisterBankInfo.cpp` — register bank selection

The PROM build uses `--target=z80 -Os` with `+static-stack` (BSS locals) and `+shadow-regs` (EXX for ISRs), linked with `ld.lld` via a custom linker script.

## Code Density Gap Analysis (BIOS, remeasured 2026-05-02)

Clang BIOS = **5920 B**, SDCC BIOS = 6123 B (clang **−203 B** overall).
Per-function profile of the largest clang BIOS functions shows where
clang's bytes still cluster — not "clang vs SDCC overhead", but
"where the remaining shrink budget hides":

| Cause                                | Impact                    | Status                                   |
| ------------------------------------ | ------------------------- | ---------------------------------------- |
| 1. BSS load/store traffic            | 30–48% of large functions | **dominant**; #20, #15, #100 open        |
| 2. Excess reg-to-reg moves (regalloc) | 22–58 per large fn        | #94 / #98 / #89 / #95 cluster open       |
| 3. Flag re-derivation (`or a`, `cp`) | 5–15 per large fn         | #77 open; #93, #86 closed                |
| 4. IX frame overhead                 | ~0 B (`+static-stack`)    | **obsolete on BIOS**; #12, #40 small     |
| 5. IY prefix overhead                | ~0 B (IY reserved)        | **obsolete**; #38 gates re-enabling      |
| 6. 8→16 bit promotion                | residual / case-by-case   | mostly closed (#86, narrow-via-zext)     |

Largest clang BIOS functions (excludes `_conv_tables` / boot data):

| Function          | Bytes | BSS-access | Reg-reg | Notes                          |
| ----------------- | ----: | ---------: | ------: | ------------------------------ |
| `_specc`          |  676  | 208 (31%)  | 58      | display char dispatch          |
| `_bios_hw_init`   |  341  |   —        |  —      | port-init sequence (data-like) |
| `_rwoper`         |  263  | 105 (40%)  | 35      | floppy block/deblock           |
| `_bg_clear_from`  |  262  |   —        |  —      | display fill                   |
| `_sec_rw`         |  247  |   —        |  —      | sector r/w                     |
| `_bios_seldsk_c`  |  199  |  66 (33%)  | 28      | disk-table lookup              |
| `_bios_write_c`   |  170  |   —        |  —      | floppy write entry             |
| `_isr_crt`        |  166  |  80 (48%)  |  6      | CRT ISR (highest BSS density)  |
| `_xyadd`          |  149  |  64 (43%)  | 22      | coordinate calc                |
| `_chktrk`         |  136  |   —        |  —      | multi-density track dispatch   |

cpnos-rom hot functions (`_netboot_mpm` 224 B, `_relocate` 115 B,
`_impl_conout` 87 B) show single-digit BSS-access bytes — they carry
much less state than BIOS and are already close to optimum.

Conclusion: **BSS spill traffic + regalloc churn** account for almost
all remaining clang bloat in BIOS.  The historical IX/IY-overhead and
8→16 promotion items in this section's prior version are no longer
active gaps; #38 (IY un-reserve) and #12/#40 (IX as frame ptr) are
parked side issues.

## Key Z80 Optimization Patterns (from SDCC)

- **DJNZ** for `do { } while(--n)` loops (2 bytes vs 4)
- **LDIR/LDDR** for memcpy/memset
- **CP (HL)** for direct memory compare (1 byte, no temp)
- **BIT n,A** for single-bit tests (vs XOR/CP sequences)
- **ADD HL,HL** for 16-bit left shift (1 byte)
- **EX DE,HL** for register swap (1 byte, but destroys both)
- **SBC A,A** to materialize carry as 0x00/0xFF

## C Language Standard

Sources use **C23 features that work in both clang and z88dk zsdcc 4.5.0**.
When refactoring, prefer these over older C99/C11 equivalents.

Tested and working in both compilers:
- `true`, `false` as keywords (no stdbool.h needed)
- `nullptr`
- `_Bool`, `_Static_assert`
- `__typeof` / `typeof`
- `0b` binary literals
- designated initializers (`{.x = 42}`)
- for-loop declarations (`for (int i = 0; ...)`)
- `#embed`

**NOT working in zsdcc** (do not use in shared sources):
- `constexpr`
- `[[attributes]]` (use `__attribute__` instead)
- digit separators (`1'000` or `1_000`)
- `typeof` in expressions (`typeof(x){42}`)

## Environment

- Docker available for SDCC, **no brew** (never use or suggest brew)
- Native LLVM-Z80 clang at `llvm-z80/build-macos/bin/` (`make toolchain`)
- z88dk via Docker container (do not rebuild from source)
- CLion as IDE, command-line collaboration here
- MAME for hardware emulation testing
- Never create pull requests unless explicitly told to
- Always use `--no-ff` for git merges

## Workflow

- Record all user prompts in `tasks/prompts.md`
- Think out loud — show reasoning process
- All persistent notes stored in project (`tasks/`, `CLAUDE.md`), never in `~/.claude/`
- Plan in `tasks/todo.md`, lessons in `tasks/lessons.md`
- Never apologize. Be concise and accurate.
- Enter plan mode for non-trivial tasks. Re-plan if things go sideways.
- Verify changes work (tests, MAME boot) before marking done.
- **Whenever you modify the compiler, always add a lit test showing it works.**
  Add to existing relevant test file or create a new one in `llvm/test/CodeGen/Z80/`.

## Known Bugs in llvm-z80

- `"hl"` inline asm constraint crashes IRTranslator
- hasFP=false has runtime bug (parked)

## Working LLVM-Z80 features (use directly; no inline-asm workaround needed)

- `address_space(2)` for port I/O — fixed in `0ff2114c62a6` + `0d71a91b4e18`
  (ravn/llvm-z80 #1, #44).  `*(volatile __attribute__((address_space(2)))
  uint8_t *)0x10` lowers cleanly to `IN A,(0x10)` / `OUT (0x10),A`.
