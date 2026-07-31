<!--
  CANONICAL LOCATION: tasks/memory/MEMORY.md (in the project, version-controlled).
  The harness does not auto-inject this; CLAUDE.md directs reading it at session
  start.  Add new durable notes as a file here + a one-line index entry below.
  Never write to ~/.claude/.

  Entries are grouped by *the moment the rule fires*.  HARD rules are bolded.
  Intentional cross-listings exist (cost: one line; benefit: rule visible at its
  trigger).  Index lines are deliberately TERSE (token-efficiency, 2026-06-06):
  trigger + imperative only — the why/history lives in each rule file; read it
  before relying on nuance.
-->

## 0. ABSOLUTE BANS — read before EVERY find/ls/grep/glob

- **[NEVER traverse outside the workspace root](feedback_no_home_search.md) — ABSOLUTE. Root per-host: `/Users/ravn/z80/` (macbook), `/home/ravn/z80/` (sonnyboy). No `find /`~`ls ~`/`mdfind`/`locate`. Check path before every find/ls/glob.**

## 1. Always-on (every response)

- **[Check memory BEFORE coding](feedback_check_memory_before_coding.md) — HARD: at task start (not just session start) scan MEMORY.md for applicable sections, READ the linked files, NAME the rules that apply in your first response, THEN start coding. Session-start read is necessary but not sufficient.**
- **[Revalidate historical compiler claims](feedback_revalidate_historical_compiler_claims.md) — HARD: before acting on any historical compiler-perf claim (size/speed/miscompile/"pass X pessimizes"), re-run the original measurement on a clean rebuild. Stale-rebuild + backend movement invalidate old numbers; current measurement wins. CASCADING: any replacement code (heuristic/fix) you write needs the same scrutiny — use a no-op control cell, not the heuristic's own output, to validate it.**
- **[Rebuild ALL Z80 tools after backend edit](feedback_rebuild_all_z80_tools.md) — HARD: after editing llvm/lib/Target/Z80/, `ninja -C build-macos clang llc lld` (all three; LLVMZ80CodeGen is in all). LTO/`-flto`/PROM builds go through `ld.lld` — rebuilding only clang+llc leaves it stale → phantom "LTO differs" bugs (2026-07-08 incident).**
- **[No-op control measurement](feedback_no_op_control_measurement.md) — HARD: for any new heuristic / cost-model hook / pass override, run THREE cells (baseline / no-op control / feature-ON) and check that no-op-control matches baseline byte-identically. If not, the new code has a presence-cost side effect; investigate before trusting feature-ON measurements.**
- **[Token-efficiency disciplines](feedback_token_efficiency.md) — HARD: (1) never raw logs into context — file + grep/tail summary, failing slice only; (2) long builds/runs in background; (3) handoff file + suggest fresh session at work-item boundaries.**
- **[Communication Style](feedback_style.md) — think out loud, concise, no apologies, record prompts**
- [Suggest model switch when warranted](feedback_suggest_model_switch.md) — flag Opus vs Sonnet fit before starting a task; one sentence suffices
- **[NEVER apologize](feedback_no_apology.md) — HARD: no "sorry"/self-criticism; report state + next action**
- **[No compliments](feedback_no_compliments.md) — HARD: start with the substantive answer**
- **[No aphoristic flourishes](feedback_no_aphoristic_flourishes.md) — HARD: never wrap a decision in a maxim**
- **[Session-break phrasing](feedback_session_break_phrasing.md) — HARD: when a checkpoint warrants a fresh session, state exactly "This is a good place to start a new session." — no preamble, no reference to hour/length/fatigue/"fresh head". Otherwise say nothing.**
- **[Show thinking — TIERED](feedback_show_thinking.md) — HARD: full narration at decisions/diagnoses/forks/surprises; one-liners during mechanical loops (tiered 2026-06-06)**
- **[Dig one level deeper before parking](feedback_dig_deeper_before_parking.md) — HARD: before declaring "deferred/multi-week", instrument + bisect 30 min first**
- **[Minimal repro BEFORE source dive](feedback_minimal_repro_before_source_dive.md) — HARD: for "why does X fail under tool Y" questions, do a 30-second minimal repro (failing form + variants that the assumed root cause says shouldn't fail) BEFORE reading the implementation source. Don't post "suggested fix" lines in filed issues without proving them via repro.**
- **[Zoom out on recurring pattern](feedback_zoom_out_on_recurring_pattern.md) — HARD: after 2-3 fixes of one class, STOP and find the systemic cause unprompted**
- **[Audit the oracle, not just the fix](feedback_audit_oracle_not_just_fix.md) — HARD: bug found by luck → build the detector that would have caught it on purpose**
- **[Verify process state by full enumeration](feedback_verify_process_state_full_enumeration.md) — HARD: never claim "clean" from a `ps | grep` of expected names; enumerate fully + reconcile**
- [No Unicode arrows](feedback_no_unicode_arrows.md) — ASCII `->`, not `→`
- **[NEVER unquoted "===" in shell](feedback_no_double_equals.md) — HARD: zsh silently truncates the command; use `---` as separator**
- **[State certainty](feedback_state_certainty.md) — HARD: fact only if verified this session; surface ALL doubt; applies to issues/commits too**
- [Ask about design decisions](feedback_ask_about_design_decisions.md) — at non-obvious forks, lay options out, user picks
- [No ask in debug loop](feedback_no_ask_in_debug_loop.md) — inside standing-auth debug cycle, run the next step
- **[Probe must not consume the resource](feedback_probe_must_not_consume_resource.md) — a health-check that grabs a single-use connection/lock/token corrupts what it verifies; if a probe passes but the guarded thing still fails identically, run the probe TWICE on a fresh resource — 2nd fail = destructive probe (cpnos #119: ping wedged single-connection MP/M master)**

## 2. Before any commit / PR / issue

- **[Never create UNSOLICITED PRs](feedback_no_pull_requests.md) — HARD: no `gh pr create` unless asked this turn; never per-bug/fix PRs upstream**
- **[Explain before filing](feedback_explain_before_filing.md) — HARD: root cause explained in chat + explicit per-filing "go ahead" before ANY upstream post; check target tracker for duplicates FIRST. Draft approval ≠ filing approval. 2026-07-08: filed mamedev/mame#15664 without gate — closed immediately.**
- **[Self-caused bug? reflect on instructions](feedback_self_caused_bug_reflect_on_instructions.md) — HARD: when filing/finding a bug that traces to AI-authored code (check git trailers for `Co-Authored-By: Claude*`), pause and identify the instruction (test-coverage rule OR code-convention) that would have prevented it. Offer to save as memory BEFORE fixing.**
- **[Peephole adjacency uses next_nodbg](feedback_peephole_next_nodbg.md) — HARD: any peephole walking adjacent MIs uses `MachineBasicBlock::next_nodbg()` / `skipDebugInstructionsForward()`, NEVER raw `std::next` (DBG_VALUE pseudos break adjacency match under `-g`)**
- **[Peephole lit tests must exercise -g](feedback_peephole_test_with_g.md) — HARD: every peephole lit test has TWO RUN lines (-O2 and -O2 -g) with identical FileCheck pattern; catches `-g`-defeats-peephole class silently**
- **[File bugs, not fixes](feedback_file_bugs_not_fixes.md) — HARD: upstream filings are BUGS (repro, current vs expected, root cause, evidence, NO fix); maintainer decides how to fix; user must understand each well enough to defend**
- **[Thorough tests for upstream bugs](feedback_thorough_tests_for_upstream_bugs.md) — HARD: upstream submissions need matrix-grade test cases (lit + runtime, negatives + positives + controls, self-checking expecteds), not just a minimal repro**
- **[Cross-machine workflow](feedback_cross_machine_workflow.md) — HARD: commit-push at end of every working segment; pull-with-submodules at start; live narrative in `tasks/handoff/`**
- **[ravn/llvm-z80 Actions OFF](feedback_ravn_llvm_z80_ci_disabled.md) — HARD: never expect CI on ravn/llvm-z80; local oracle is the merge gate; don't re-enable without user direction**
- **[No commit on lit+size alone](feedback_no_commit_first_version.md) — HARD: combiner/ISel/lowering changes need value oracle (test-runner + MAME) before commit**
- **[Consult rules before acting](feedback_consult_rules_before_acting.md) — HARD: search MEMORY.md before any fix; commit message includes `Rules-checked:`**
- **[Grep repo docs before deriving](feedback_grep_repo_docs_before_deriving.md) — HARD: grep for existing `*_REFERENCE.md` before re-deriving encodings**
- [No UNSOLICITED Upstream Issues](feedback_no_upstream_issues.md) — default: file in ravn/* forks; curated submissions only on user direction
- **[Upstream routing](feedback_upstream_routing_two_targets.md) — HARD: generic-LLVM bugs → llvm/llvm-project (or local XFAIL); llvm-z80/llvm-z80 ONLY for Z80-specific**
- **[MAME upstream routing](feedback_mame_upstream_routing.md) — HARD: never file in any MAME repo without explicit per-issue permission; devices → mamedev, rc702 driver → ravn/mame**
- **[No local zsdcc fixes](feedback_no_local_zsdcc_fixes.md) — HARD: root-cause + repro + `wontfix` + report upstream; clang fixes still local**
- **[No upstream sdcccall 0/1 discrepancies](feedback_no_upstream_sdcccall_discrepancies.md) — HARD: sdcccall 0/1 ABI mismatches are known build-config issues (z88dk warning 296), NOT upstream-fileable; work around locally (SKIP_CELL or register-arg shims)**
- [File dep bugs in ravn/* forks](feedback_file_issues_in_forks.md) — with repro + test case
- [Always test compiler bugs](feedback_compiler_bug_test.md) — XFAIL lit test for every clang Z80 codegen bug
- [Attribution line on filed issues](feedback_issue_attribution_line.md) — append `--- / _Filed by GitHub Copilot on behalf of @ravn._` to every issue body
- [Comment on issue when fix committed](feedback_issue_comment_on_fix.md) — AUTO (no prompt): after fix commit, post comment with hash + what changed + verification + remaining notes
- [Test before fix](feedback_test_before_fix.md) — failing test before implementing
- [Plan thoroughly first](feedback_plan_thoroughly_first.md) — explicit step-by-step plan + confirm before any non-trivial work
- [Production-hard, AES/upstream-soft](feedback_production_hard_aes_soft.md) — production triplet is the load-bearing workload; AES + upstream-correctness are additional signal
- [BSD awk only on macOS](feedback_bsd_awk_only_on_macos.md) — avoid strtonum/gensub/asort; use Python for hex parsing
- [Project timeline log](feedback_timeline_record_keeping.md) — append to rc700-gensmedet/tasks/timeline.md per meaningful change

## 3. Before any memory-layout / linker / address change

- **[RC702 IVT page constraint](project_rc702_ivt_page_constraint.md) — IM 2 IVT page must not overlap display 0xF800..0xFFCF; valid: 0xEC00/0xED00 (BSS) or 0xF500 (resident)**
- [rcbios 32-bit RTC = diffs only](reference_rcbios_rtc_counter_diffs_only.md) — rtc0/rtc2 (0xFFFC/0xFFFE) is a 50Hz boot-relative tick counter; wraps ~2.72yr; use for elapsed-time differences, NEVER as a since-epoch timestamp. Same 50Hz as z88dk rc700 clock().
- **[RC702 bank2h PROM mirror](feedback_rc702_bank2h_mirror.md) — HARD: 0x2800..0x2FFF is PROM1-mirror, NOT RAM**
- **[Grep mem_map before BSS literal](feedback_grep_memmap_before_bss.md) — HARD: grep emulator mem_map before allocating BSS at a literal address**
- **[Slave RAM state outside TPA](feedback_slave_state_outside_tpa.md) — HARD: pin slave state to SNIOS reserved area (0xED00..0xF7FF), never inside TPA**
- **[Phase-boundary state-address audit](feedback_state_address_phase_audit.md) — HARD: re-audit state addresses when lifecycle changes (prom-init → RAM-resident)**
- **[Audit memory layout on port](feedback_memory_layout_on_port.md) — HARD: audit layout invariants proactively when porting; prefer HIGH(symbol) over literals**
- **[No literal memory addresses](feedback_no_literal_addresses.md) — HARD: linker-derived or `.sym`-extracted only; literals OK for ports/vectors/magic**
- **[Cross-stage --defsym atomic](feedback_relink_dependencies_atomically.md) — HARD: C decl + linker script + Makefile awk + defsym in same commit; mind underscore count**
- [cpnos.com address coupling brittle](project_cpnos_address_coupling_brittle.md) — never replicate hand-typed cross-image addresses
- [rcbios + cpnos code sharing (future)](project_cpnos_rcbios_code_sharing.md) — VRTC ISR / DMA / 8275 / PIO+SIO duplicated across both; factor after INIR work settles (#22)
- **[Ring-shrink + INIR coupling](feedback_ring_shrink_inir_coupled.md) — HARD: cpnos PIO-B `pio_rx_buf` 256→16 B sizing ASSUMES INIR drains data bytes direct to msg+5; without INIR a 41-byte data block overflows 16 B and slave deadlocks at netboot. Don't ship the shrink without INIR; don't bisect by forcing INIR off without restoring the ring.**
- **[Verify HW register is load-bearing](feedback_verify_hw_register_load_bearing.md) — HARD: when modifying init-time hw reg writes OR the ISR/code consuming them, verify the bit is actually load-bearing (consumer behaves differently without it); vestigial config accumulates and masks bugs**
- **[Bundle layout migrations proactively](feedback_bundle_layout_migrations_proactively.md) — HARD: when deferring a layout move with "we don't need it yet", check region headroom; if <200 B, the next workstream will need it — bundle now**
- [Sentinel preconditions](feedback_sentinel_preconditions.md) — re-derive "real data ≠ sentinel" at every use site

## 4. Before any build / compile / link flag change

- **[+static-stack only for non-recursive code](feedback_static_stack_nonrecursive_only.md) — HARD: `+static-stack` is non-reentrant and SILENTLY miscompiles recursion (no error, wrong answer). Never enable globally; establish non-recursion first. Evidence: nqueens wrong + 404K vs 53M ts under `clangp`.**
- **[Check sibling subprojects](feedback_check_sibling_subprojects.md) — HARD: grep siblings for the same flag, mirror their wrapping**
- **[Symmetric recipes per compiler](feedback_symmetric_recipes_per_compiler.md) — HARD: parallel `ifeq COMPILER` recipes must emit the SAME artifact set**
- **[Build-var artifacts content-check, not mtime](feedback_build_var_artifacts_content_check.md) — HARD: files embedding TRANSPORT/COMPILER regen via content grep**
- [Test both compilers](feedback_dual_compiler_test.md) — rcbios changes build with BOTH z88dk and clang before commit
- [Check memory for builds](feedback_check_memory_for_builds.md) — check memory for correct build flags first
- [Build-tool binaries](reference_build_binaries.md) — cmake/ninja from CLion bundle (mac); native llc/clang in llvm-z80/build-macos/bin
- **[Record macOS utility surprises](feedback_record_macos_utility_surprises.md) — when a BSD utility misbehaves vs GNU, SAVE a memory note + workaround (no brew here; python3 is the fallback).**
- [macOS awk lacks strtonum](reference_macos_awk_no_strtonum.md) — default awk is BWK not gawk; no strtonum/gensub/hex-parse. Use python3/printf/`$((16#..))` for hex crunching.
- [Z80 tool paths](reference_z80_tool_paths.md) — full paths + canonical invocations, BUILD_DIR/PATH overrides
- **[AVR density oracle](feedback_avr_density_oracle.md) — HARD: before blaming a generic pass or filing upstream, compile the repro for in-tree AVR; AVR-cheap + Z80-expensive = OUR backend gap (and AVR shows the mechanism)**
- **[Don't kill ninja mid-build](feedback_dont_kill_ninja.md) — HARD: SIGKILL truncates .ninja_log → 1700+ step rebuild; Ctrl-C ONCE. Separate build DIRS OK concurrently. Log to scratch/ninja-*.log; no pgrep|kill probes.**
- **[Read build-tool docs before improvising](feedback_read_tool_docs_before_improvising.md) — rm only .ninja_log NOT .ninja_deps (deps DB → full rebuild); `set -o pipefail` for tee'd ninja (else exit code is echo's, not ninja's).**
- **[Ninja clang+llc together](feedback_ninja_clang_llc_together.md) — HARD: after backend change, `ninja clang llc` BOTH**
- [Docker for missing binaries](feedback_docker_binaries.md) — don't suggest installing
- **[Docker shim batch](feedback_docker_shim_batch.md) — HARD: build Makefiles batch multi-step Docker calls into ONE `docker run sh -c "..."`; ~150-500 ms container startup tax dominates otherwise**
- [Docker invocation budget](feedback_docker_invocation_budget.md) — all hosts wherever Docker is used; track per-workflow call count; flag when any routine pipeline exceeds ~100
- [Build zmac if missing](feedback_build_zmac.md) — `make` in zmac subfolder
- **[zmac local labels are global](feedback_zmac_local_label_scope.md) — HARD: dotted locals collide across subroutines; prefix with initials**
- [macOS timeout](reference_macos_timeout.md) — no GNU timeout; use Bash timeout param or perl alarm
- [C23 subset](feedback_c11_standard.md) — tested C23 features only (true/false/nullptr/typeof/0b)
- [No Undocumented Default](feedback_no_undocumented_default.md) — no undocumented Z80 instructions without +undocumented
- [Check for Undocumented](feedback_undoc_check.md) — grep asm for IXH/IXL/IYH/IYL after compiling
- [Always regenerate timestamp](feedback_timestamp.md) — delete builddate.h before every BIOS/PROM build
- [MAME OSD=sdl](feedback_mame_osd_sdl.md) — not sdl3; full command in docs/MAME_RC702.md

- **[Verify CMake fixes with compile_commands](feedback_verify_cmake_fixes.md) — HARD: a CMake/.clangd include fix is not done until you `cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON` and confirm the failing file's actual -I flags; compiler-resolves-header is NOT proof. Prefer absolute `${CMAKE_CURRENT_SOURCE_DIR}` in CMakeLists over relative -I in .clangd (clangd resolves those from the source dir).**

## 5. Before any llvm-z80 compiler-codegen change

- **CRITICAL framing — [Z80 backend unfinished](project_z80_backend_unfinished.md): goal is to FINISH the backend correctly, not optimize a finished one**
- **CRITICAL framing — [Z80 staged collaboration model](project_z80_upstream_goal.md): near-term llvm-z80/llvm-z80; long-term llvm/llvm-project; collaborate with owner**
- **[No commit on lit+size alone](feedback_no_commit_first_version.md) — HARD (cross-listed §2): value oracle required**
- **[+static-stack only for non-recursive code](feedback_static_stack_nonrecursive_only.md) — HARD (cross-listed §4): non-reentrant, silently miscompiles recursion**
- [Always test compiler bugs](feedback_compiler_bug_test.md) — XFAIL lit test per bug
- [Verify codegen not just size](feedback_verify_codegen.md) — read disassembly per compiler; same size ≠ same behavior
- **[Compiler is not trusted](feedback_compiler_not_trusted.md) — HARD: inspect generated asm BEFORE blaming source/runtime/hardware**
- **[Verdict AFTER real pass output](feedback_verdict_after_real_pass_output.md) — HARD: show the IR/asm the named pass actually produces + contamination + remaining doubt BEFORE stating any verdict; synthetic worst-case ≠ evidence**
- [Late-opt audit](reference_late_opt_audit.md) — session-37 Keep/Migrate/Delete classification of all 46 peepholes
- [Root-cause over peephole](feedback_root_cause_over_peephole.md) — favor upstream fixes over post-RA peepholes
- **[Peephole safety guards](feedback_peephole_safety_guards.md) — HARD: erase/move/convert peepholes need complete liveness + slot-aliasing + iterator guards**
- [Proper fixes — backend immature](feedback_proper_fixes_immature_backend.md) — question prior design decisions, including my own past code
- [T-states Matter](feedback_tstates.md) — evaluate size AND execution time
- [Don't fight SDCC iCode](feedback_dont_fight_sdcc_icode.md) — no `static`-locals to preempt SDCC; clang uses `+static-stack`
- **[SDCC block-scope extern broken](feedback_sdcc_block_scope_extern.md) — HARD: cross-TU externs at FILE scope under z88dk-SDCC**
- [Prefer C over inline asm](feedback_prefer_c_over_asm.md) — file codegen issues instead of ~6-10 B asm rewrites
- **[Z80 copies have spurious mayLoad/mayStore](feedback_z80_copy_spurious_mem_flags.md) — HARD: use `!MI.memoperands_empty()`, not mayLoad()/mayStore()**
- **[zeroext is ABI, not source-narrow](feedback_zeroext_is_abi_not_source.md) — HARD: use computeKnownBits before narrowing**
- **[TruncInstCombine: swap before probe](feedback_truncinstcombine_swap_before_probe.md) — HARD: modify IR users BEFORE `getBestTruncatedType`; rollback on failure branch**
- [IX caller-saved after #12](project_ix_caller_saved_after_12.md) — IX allocatable only pays caller-saved; revisit after #12
- [pi CSE / branch-fold miscompile PARKED](project_pi_cse_branchfold_parked.md) — Branch Folder unsound hoist (exposed by MachineCSE); production unaffected; don't re-investigate, don't flip `-z80-enable-cse` default ON until upstream fix
- [Fork-local pass naming = upstream candidacy honesty](feedback_fork_local_pass_naming.md) — `Z80*` prefix is locative not semantic; if a pass's body is target-agnostic, name with the operation (`*Recognize`/`*Combine`) AND record the upstream debt in `upstream-coherence-map`. `Z80LoopIdiomFill`→`Z80PatternFillRecognize` (2026-06-09) is the pinned example.
- [#212-class HL borrow-save audit pattern](project_212_class_borrow_save_pattern.md) — `if (HLLive) PUSH_HL` without IMPLICIT_DEF for dead half trips verifier when fastregalloc places undef; 5+ latent sites in Z80InstrInfo.cpp filed as #239; reflex check whenever auditing pseudo-expanders that borrow HL/IX/IY
- **[z88dk classic calling conventions under clang](reference_z88dk_calling_conventions.md) — `__smallc`=sdcccall(0) WORKS; `__z88dk_callee` + `__z88dk_fastcall` are no-ops (fastcall only 16-bit-safe: z88dk L/HL/DEHL vs clang A/HL/HLDE). clang C ABI: args HL/DE, 16-bit RETURN in DE, no callee-saved GPRs. Helper name mismatch = backend emits libgcc names, `l/clang/` shipped SDCC names (whole div/mod/mul family dead-named). Native z88dk-CC support is FEASIBLE (proven `Z80_SDCCCall0`/`Z80_AllReg` pattern); plan in `llvm-z80/tasks/plan-2026-07-10-z88dk-calling-conventions.md`**

## 6. Before any MAME / boot / test run

- **[Verify banner timestamp before trust](feedback_check_banner_timestamp.md) — HARD: banner timestamp vs BUILD_INFO_STR before any diagnosis**
- **[Polypascal stage-1/2 flake = MP/M daemon state](feedback_polypascal_stage1_flake.md) — first try `make _kill-mpm; sleep 5-8; retry`. ★ BOTH PIO+SIO failing identically (transport-agnostic), or after you ran standalone `mpm`/`nc`-probed :4002 = master state YOU contaminated; kill your own stragglers (ps/lsof :4002), NOT codegen.**
- **[cpnos PIO netboot: NO -autoboot_script](feedback_cpnos_pio_netboot_no_autoboot.md) — HARD: any autoboot (even empty) breaks the wall-clock-coupled PIO cpnet_bridge netboot (stalls at 1st LOGIN byte); drive cpnos via host-side SIO-B injector (`cpnos_polypascal_inject.py`), `-nothrottle`, `wait_mpm_ready.py` gate. Never restore local/mpm-net2-1.dsk from library (stale SERVER.RSP → gettod `ff`); rebuild MPM.SYS.**
- **[mpm-net2 weirdness — first fix is stop+rebuild+restart](feedback_mpm_server_first_fix.md) — HARD: ANY unexpected mp/m server behavior → stop, rebuild, restart, retry BEFORE theorizing. If still bad: ASK the user.**
- **[Session-start: kill daemons BEFORE first test](feedback_session_start_kill_daemons.md) — HARD: `make -C cpnos-in-c _kill-mpm; sleep 8` before first run + between COMPILER switches**
- **[Screenshot to verify](feedback_screenshot_to_verify.md) — HARD: capture a MAME screenshot to verify boot; PASS lines + memory dumps are NOT enough**
- **[Visual capture for display path changes](feedback_visual_capture_for_display.md) — HARD: CRT ISR / DMA refresh / 8275 / display BSS changes need multi-frame video verification; textual PASS doesn't catch garble**
- **[Black screen is fatal](feedback_black_screen_fatal.md) — HARD: halts all other investigation**
- [Black screen → CRT ISR not firing](feedback_black_screen_crt_isr.md) — suspect EI / IVT slot 2 / CTC ch2 in that order
- [MAME Banner Check](feedback_mame_banner.md) — verify compiler (CL=clang, ROA375=SDCC)
- [MAME PROM Checksum](feedback_mame_checksum.md) — verify CRC matches built PROM
- [MAME ROM warning is a bug](feedback_mame_rom_warning.md) — fix BAD_DUMP, don't dismiss
- [Full rebuild before MAME](feedback_mame_rebuild.md) — rm .o + full rebuild first
- **[MAME always windowed + timeout](feedback_mame_always_window_timeout.md) — HARD: every launch needs `-window` AND finite `-seconds_to_run N`; never fullscreen, never timeout 0. User can't stop a runaway fullscreen instance.**
- **[Never concurrent builds, never kill a build](feedback_never_concurrent_or_kill_builds.md) — HARD: one ninja/make at a time (shared obj dir races); never pkill a build (deletes partial .o -> full rebuild). Wait for it to finish/fail.**
- [Fresh BIOS+PROM before MAME](feedback_mame_fresh_build.md) — rebuild both
- [Run MAME at full speed](feedback_mame_full_speed.md) — `-nothrottle` in unattended tests
- **[Disable MAME audio in ALL tests](feedback_disable_audio_in_tests.md) — HARD: pass `-sound none`.  Motor sounds annoy user; CoreAudio causes SIGPIPE (exit 141) under sustained background-test load.**
- **[MAME windowed only](feedback_mame_windowed_only.md) — HARD: always `-window`, never fullscreen**
- **[Headless host = no MAME window](feedback_host_no_graphics.md) — HARD: on sonnyboy use `SDL_VIDEODRIVER=dummy` (or xvfb-run); snapshots/AVI still work**
- [MAME interactive timeout](feedback_mame_interactive_timeout.md) — ~30s Bash timeout suffices
- [Lua no port reads](feedback_lua_no_port_reads.md) — use install_read_tap; double reads break devices
- [Lua retain tap handles](feedback_lua_retain_tap_handles.md) — store install_*_tap return in a long-lived table or GC frees it -> segfault in lua_topointer
- **[Lua errors are fatal](feedback_lua_errors_fatal.md) — HARD: any `[LUA ERROR]` invalidates the run; fix lua, re-run, THEN interpret**
- **[Display address from DMA, never hardcode](feedback_display_addr_from_dma.md) — HARD: read base from Am9517A DMA ch2 (autoload 0x7A00, roa375 0x7800)**
- [Bench self-termination](feedback_bench_must_self_terminate.md) — taps call `manager.machine:exit()` on finish
- [No permission for MAME/MP/M launch](feedback_mame_mpm_no_permission.md) — standing authorization to spawn/kill
- [Pre-launch change summary](feedback_show_changes_before_launch.md) — list edits/build/PROM/daemons + hypothesis before every run
- [MP/M shutdown via BYE](feedback_mpm_bye_shutdown.md) — `BYE` on console, not kill
- [CP/NOS MAME prereqs](project_cpnos_mame_prereqs.md) — MP/M up + no stale conn + NDOS in-sync + cpnos built
- [Check port 4002 before MAME](feedback_port4002_check.md) — abort if occupied
- [Watch slow commands](feedback_watch_slow_commands.md) — unusually slow ops flagged; prior symptom of register clobbering
- [MAME keyboard test](reference_mame_keyboard_verification.md) — natkeyboard:post() chain verification
- [pio-irq-fix test topology](project_pio_irq_test_topology.md) — `make pio-irq-netboot` (PIO-B → mpm-net2 :4002)

## 7. Before file/script ops

- **[NEVER traverse outside the workspace root](feedback_no_home_search.md) — see §0; ABSOLUTE**
- **[No stale dump files](feedback_no_stale_dump_files.md) — HARD: `rm -f` the artifact BEFORE the producer, every iteration**
- **[No DOTALL backtracking on source](feedback_no_dotall_backtracking.md) — HARD: no `re.DOTALL` + non-greedy over multi-line source; kill scans >10s**
- [z80 tree has no untrusted hooks](feedback_z80_tree_no_untrusted_hooks.md) — `cd … && git …` is safe; don't hedge
- [Docker Trace Disk](feedback_docker_trace.md) — z88dk-ticks -trace pipes through tail
- [CRLF on CP/M disk text](feedback_crlf_cpm_disk.md) — CR+LF when injecting text into disk images
- [Transcribe image PDFs](feedback_pdf_transcribe.md) — text version in repo when scanning image PDFs

## 8. Test / debug discipline

- **[Boundary codegen needs a runtime fixture](feedback_boundary_codegen_needs_runtime_fixture.md) — HARD: switch/range-check/compare-narrowing/off-by-one codegen ships a RUNTIME FIXTURE exercising min/max/just-past — the load-bearing safeguard, an oracle INDEPENDENT of your reasoning. A lit test alone is insufficient and "derive CHECK from first principles" does NOT save you (the blind spot is in the reasoning). Origin: #86 jump-table off-by-one, lit-only, cemented ~2.5mo.**
- **[Revalidate concern, not filename](feedback_revalidate_concern_not_filename.md) — HARD: file moved / workaround in place ≠ resolved; verify the symptom in CURRENT source**
- **[Outlier-first, not sweep](feedback_outlier_first_not_sweep.md) — HARD: dig ≥1.5×/≥50 B divergences; don't touch every difference**
- **[Verify matrix before theory](feedback_verify_matrix_before_theory.md) — HARD: contradictory cell pattern = stale state; clean + re-verify anchors first**
- **[Compilers agree means harness](feedback_compilers_agree_means_harness.md) — HARD: identical failure on both compilers → suspect harness/wiring first**
- **[Compare total section sizes](feedback_compare_total_section_sizes.md) — HARD: sum .text+.rodata+.data; per-function .text hides jumptables**
- **[No mental arithmetic in fixtures](feedback_no_mental_arithmetic_in_fixtures.md) — HARD: tool or trivial math only for expected values**
- **[Auto-kill stale daemons](feedback_kill_stale_servers_on_test_target.md) — HARD: test targets auto-cleanup leftover daemons (BYE, then SIGTERM)**
- **[Diff binaries before blaming codegen](feedback_diff_binaries_before_blaming_codegen.md) — HARD: `cmp -l` FIRST; byte-identical = environmental**
- **[Verify writes before chasing reads](feedback_verify_writes_before_chasing_reads.md) — HARD: instrument around the store first**
- **[Recognize ROM-shadow byte patterns](feedback_recognize_rom_shadow_patterns.md) — HARD: structured wrong bytes → `xxd` the PROMs first; match = memory-map bug**
- **[No taps inside polled-RX hot path](feedback_no_taps_in_polled_rx.md) — HARD: per-byte debug TX overruns SIO FIFO; per-frame markers or ring trace**
- **[A/B before blaming test-runner](feedback_ab_before_blaming_test_runner.md) — HARD: stash + rebuild + rerun baseline first; test_90/91 edge_*_O1 known noise (#136)**
- **[Baseline before implementing](feedback_baseline_before_implementing.md) — HARD: capture control measurement on UNMODIFIED system first**
- **[Value oracle covers all TRANSPORT cells](feedback_value_oracle_all_transport_cells.md) — HARD: SNIOS/xport/compat.h changes runtime-test every linking cell**
- **[Extract rules from time-sinks](feedback_extract_rules_from_time_sinks.md) — HARD (meta): after long debug sessions, propose new memory rules proactively**
- **[Multi-pass marker interactions](feedback_multi_pass_marker_interactions.md) — HARD: when an optimization "should fire" but doesn't, `-print-after-all` and check if the trigger marker existed earlier and was stripped mid-pipeline**
- **[Verify PASS condition before trusting green](feedback_verify_pass_condition.md) — HARD: cross-check elapsed time + artefact evidence; unexplained workaround = red flag**
- [User guesses are not constraints](feedback_user_guesses_not_constraints.md) — treat as starting suggestion; probe-first
- ["Intermittent" is a hypothesis](feedback_intermittent_is_hypothesis.md) — falsify via data-content checks before chasing timing
- [Integration Tests Expensive](feedback_integration_tests.md) — full suite only before merge/PR
- [Zoo Fast First](feedback_zoo_fast_first.md) — quick subset first
- [Verify DELAY_T](feedback_delay_tstates_test.md) — DELAY_T must match actual inner-loop T-states
- [Poll don't sleep](feedback_poll_dont_sleep.md) — poll completion markers, no long fixed sleeps
- [Canonical targets > enumeration](feedback_canonical_targets_over_enumeration.md) — `ninja check-<x>` over enumerating tools
- **[ticks canonical exit = ED FE trap](reference_ticks_canonical_exit_trap.md) — HARD: ED FE syscall (A=CMD_EXIT, L=exit code) not HALT; `-output` bypassed; grep existing project harnesses before deriving termination from scratch**

## 9. Code & source style

- **[Clarity in C code](feedback_clarity_in_c_code.md) — HARD: readable call shapes; compiler glue confined to hal.h/intrinsic.h, never #ifdef in business logic**
- [Size over speed for cold paths](feedback_size_over_speed_for_cold_paths.md) — cold code: bytes are permanent, T-states aren't
- [Volatile blocks loop idiom](feedback_volatile_blocks_loop_idiom.md) — volatile only for ISR-shared or hardware-changing memory
- [No self-correction in published docs](feedback_no_self_correction_in_published_docs.md) — narrate self-checks in chat; publish only the final version

## 10. Project facts — RC702 hardware

- **[RC700 family + PROM inventory](reference_rc700_family_proms.md) — RC701/702/703; RC701 has DIFFERENT ports + NO semigraphics (MAME emulation needs code changes); we target RC702/ROA375; RC701 PROM source likely lost**
- [No RC700 HW mods](user_no_hw_mods.md) — no PCB modifications; cables/external devices OK
- **[2 KB PROM hard limit](project_rc702_2kb_prom_hard_limit.md) — HARD: no A11 bridge; PROM0+PROM1 capped at 2048 B each; never propose "close A11"/"use 2732"**
- [SIO-A fast TX, no fast RX](project_sioa_tx_only_fast.md) — 614 kbaud TX verified; fast RX impossible (no DPLL)
- [Two Picos available](project_pico_count.md) — one on cbl923 keyboard rig, second for J3 CP/NET bridge

## 11. Project facts — cpnos / cpnet / DRI

- **[Long-term goal: finish rcbios + autoload-in-c + CP/NET + cpnos](project_finishing_firmware_components.md) — bias work toward measurably advancing one of the four**
- **[cpnos PARKED — awaiting physical parallel cable](project_cpnos_parked_awaiting_parallel_cable.md) — surface before acting on cpnos/PIO/polypascal tasks; unpark on user signal**
- **[MP/M disks: local-only, library frozen](project_mpm_disks_local_only.md) — `make mpm-disks` (cpnos-in-c) builds all tailored disks into disks/local/; NEVER write disks/library/; slave netboot image is RC700.NOS (was cpnos.img)**
- **[SDCC slave stack-room ceiling](project_sdcc_slave_stack_room.md) — cpnos SDCC PROM1 resident must end <= 0xF60E or SP=0xF680 stack overruns resident SNIOS data -> netboots but hangs at cpnos.sys handoff; check_sdcc_stack_room.py guards the build. sdcc = MAME-only secondary; clang = production**
- **[rcbios CP/NET PIO polypascal PASS 16s](project_rcbios_cpnet_pio_race_parked.md) — FIXED: z80pio 2eb88cea + snios RECVBY_PIO timeout; test: H:→PPAS→P PRIMES→PRIMES.COM→TESTDONE; ravn/mame#13 upstream candidate**
- **[SEM702 chip-photo request](project_sem702_request_chip_photo.md) — when the RC702 is open, ask for photos of the piggyback boards (ic82 + under ic68)**
- **[User's RC702 HAS SEM702, not ROA327](project_user_rc702_has_sem702.md) — define_sextants() is essential on the user's hardware (~79 ms, accepted); don't gate/remove it**
- [DRI NDOS — no upstream](project_dri_ndos_frozen.md) — we own cpnet-z80 DRI sources, edit freely
- [CP/NOS no local floppy](project_cpnos_no_local_floppy.md) — payload stays diskless
- [Fast link is CP/NET-only](project_fast_link_cpnet_only.md) — fast transport carries CP/NET + CP/NOS frames only
- [Z80 simple, host complex, hardware-compatible](project_z80_simple_host_complex.md) — push protocol work to host; must run on physical RC702
- [HiTech port parked](feedback_check_hitech_park_note.md) — read `tasks/hitech-port-parked.md` before proposing HiTech
- **[AES corpus = parity oracle](project_aes256_corpus_goal.md) — drives clang↔zsdcc parity + upstream bug queue; clang now dominates; gaps in `tasks/all-modes-competitive-plan.md`**
- **[AES K&R speed gap accepted](project_aes_kr_speed_gap_accepted.md) — clang +51% slower than SDCC on AES K&R `09_Oz_prod_like` post-sound-gate; structural CVP-strips-marker chain; off the critical path for the four finishing-firmware components**

## 12. External-bug refs

- [ravn/mame#6 — PIO-B slot regression](project_ravn_mame_6.md) — gates Option P bring-up; check before resuming cpnet-fast-link
- [ravn/mame#6 — workarounds failed](project_ravn_mame_6_workarounds_failed.md) — Paths 2+3 failed; fix needed at chip/slot layer

## 13. Reference / one-offs

- **[Canonical test aggregator](reference_run_all_tests.md) — `tasks/tools/run-all-tests.sh` runs all 4 test groups (lit / test-runner / z88dk run_all / softfloat) from one place; run at merge/checkpoint (canonical script, NOT a hook). `fast`=A+C+D, no-arg=full.**
- **[z88dk llvmz80 evaluation doc](reference_z88dk_evaluation_doc.md) — living document for z88dk project at `tasks/z88dk-llvmz80-evaluation-2026-07-21.md`; update after any bridge/benchmark/float change**

- **[xcc issue-filing process](xcc-issue-filing-process.md) — retro-vault/xyz has issues DISABLED → file bugs as PR from ravn/xyz fork; repro goes in `x/tests/repro/` (their red-but-ignored convention, no xfail in cases/); root-cause via `xcc -S` (.ds vs .dw), GREEN oracle via docker gcc; libc/printf not auto-linked in the binary release. First bug: retro-vault/xyz#2**
- **[ez80clang comparison oracle](reference_ez80clang_oracle.md) — CEdev `ez80-clang` (SelectionDAG eZ80 fork) as corpus 6th lane, CODE-QUALITY only; `setup_ez80clang.sh` + `EZ80CLANG_ORACLE_SETUP.md`; needs z88dk clang_rules.1 fix (branch rc700-gensmedet-1); 3 cells skipped (sieve/fannkuch codegen cliff, pi 32-bit runtime gap) → rc700-gensmedet#122**
- **[RC703 TFj BIOS oracle](reference_rc703_tfj_bios_oracle.md) — datamuseum Bits:30003297 system tracks = a runnable assembled RC703 BIOS (`rel. TFj`); byte-level oracle for rcbios; system tracks preserved in rc703-div-bios-typer/**
- [User Profile](user_profile.md) — experienced dev, Z80/LLVM/SDCC, CLion, Docker, no brew
- **[TODO-later: cpmish distribution](project_cpmish_todolater.md) — undersøg davidgiven/cpmish som distributions-vehicle for rc702-8dd/5dd + rc703-qd diskbilleder**
- [TODO-later: z88dk RC700 wiki](reference_z88dk_rc700_wiki.md) — opdater github.com/z88dk/z88dk/wiki/Platform-Regnecentralen-RC700 med nye diskformater + llvmz80; trigger ved upstream PR
- **[FILE* test suite parked — newlib migration](project_fileio_suite_parked_newlib.md) — 4 XFAIL + 9 SKIP genoptages når z88dk newlib CP/M file-driver lander upstream (ravn/z88dk#34)**
- [Host: sonnyboy](reference_host_sonnyboy.md) — Ubuntu 26.04 x86_64, `/home/ravn/z80`, headless, gh authed, upstream LLVM at `~/llvm-upstream/llvm-project`
- [Safari breaks claude login callback](reference_claude_login_safari_workaround.md) — use ANTHROPIC_API_KEY or non-Safari default browser
- [HiTech zc Docker image](reference_hitech_zc_docker.md) — `ghcr.io/ravn/hitech` provides `zc`
- [COMAL80 language manual](reference_comal80_manual.md) — RCSL 42-I-1758 @ Bits:30000018 (Dec 1981, OLDER than disk rev 1.07: no CHAIN/EXTERNAL); explains why .PRG apps won't load
- [simavr master required for .mmcu console](reference_simavr_master_required.md) — distro 1.6 is too old; build master in Docker
- [Memory in tasks/memory/, never ~/.claude/](feedback_no_claude_memory.md) — canonical here, read manually at session start
- **[Fingerprint build after 2 no-change edits](feedback_fingerprint_build_after_two_no_change_edits.md) — HARD: stop editing, add an undeniable marker, prove new bytes are running before edit #3**
- [MP/M II bakes RSPs into MPM.SYS at GENSYS time](reference_mpm_sys_baked_via_gensys.md) — `.RSP` edits inert until GENSYS regens `MPM.SYS` + re-installs on drive A:
- **[Never push/merge upstream remotes](feedback_never_push_or_merge_upstream_remotes.md) — HARD: cpnet-z80 origin is `durgadas311/*` (upstream); keep local commits FLAT, no `--no-ff` merges, no push. Only `ravn/*` repos get pushed/merged.**
- **[CP/NET 1.2 only](feedback_cpnet_12_only.md) — HARD: assume CP/NET 1.2 semantics; BDOS-105 is NOT forwardable under 1.2; ndos3.asm:504 (`db 0 ; 105 - can't support here, use SEND NW MESG`) is correct; time-from-master goes via BDOS-66/67 + FN-105 vendor extension (see `cpnet/todget/todget.c`).**
- **[rcbios jump table is ABI](feedback_rcbios_jump_table_is_abi.md) — HARD: BIOS jump table at 0xDA00 (incl. vendor extensions like 0xDA56 CLOCK) is frozen ABI for compiled CP/M programs on system disks. No delete, reposition, or stub of existing entries — even when a "better" wire path exists. New paths are ADDITIVE; legacy stays callable. New entries OK at end of table.**

- **[rcbios: never enable -flto (breaks boot-code placement)](feedback_rcbios_no_lto_boot_placement.md) — HARD: `-flto` merges C objects so `rc700_bios.ld` per-file matchers (`*boot_entry.o`, `*bios_hw_init.o`) fail; relocate_bios/verify/hw_init land high at 0xDA00 and `_coldboot` calls empty RAM → no `A>`. Fix = drop `-flto` (~15 B). Toggling a compile flag needs `rm *.o`, not just a relink.**

- **[Sieve-gap passes (sink + pin)](reference_sieve_gap_passes.md) — llvm-z80 has TWO opt-in default-OFF passes: `Z80SinkColdLoopIV` (`-z80-sink-cold-loop-iv`, M3, sieve −2.3% clean) + `Z80PinLoopPointer` (`-z80-pin-loop-pointer` + HLReg class, M5, net-regresses via scan-loop regalloc cascade). Don't re-implement. Trackers #256/#250/#251. Default-on RESERVED for user.**

- [llvmz80 classic-vs-newlib SPEED benchmark](reference_llvmz80_clib_speed_benchmark.md) — compiler fixed, lib varies: no single winner (classic qsort 1.5x faster, newlib sprintf 1.47x faster, string tie; newlib ~half size). qsort gap = CP/M newlib picks shellsort vs classic quicksort (__CLIB_OPT_SORT, tunable; +quicksort = -26% cyc/+194B, reverted). Cycle-accurate via ticks_cpm.py not ntvcm. Full: tasks/benchmarks/llvmz80-clib-speed-2026-07-26.md.
- **[z88dk native z80asm rebuild = 1-line Perl patch](reference_z88dk_native_z80asm_perl_patch.md)** — native macOS z80asm rebuild needs `make_lib_list.pl` `Modern::Perl`→`feature 'say'` (carried on master `64f43a9805`); rm stale empty `.lst` on refail; after upstream merges rebuild z80asm via `make -C src/z80asm ... install` THEN `./build.sh -b -p cpm`. The #3025 file driver only assembles under rebuilt z80asm.
- **[z88dk#3022 console-lost-after-fopen (CONFIRMED)](project_z88dk_3022_console_after_fopen_bug.md)** — newlib +cpm: fopen corrupts stdout, console output after fopen misrouted into the file (classic OK; sccz80+SDCC+clang all hit it → not a convention bug). Maintainer-confirmed "memory reuse, default subtype"; test PR #3031 open, feilipu fixes then merges. Flip fork XFAIL `test/clang/runtime_file_console.*` when merged.
- **[z88dk#3011 RC700 FP-under-interrupt = EXX collision](reference_z88dk_3011_fp_interrupt_exx.md)** — open Q from suborb: stock FP crashes under interrupts, 8080 mathlib works. Cause: math48 uses `EXX` 367×/genmath 21× as scratch → interrupted FP corrupted by any shadow-set-touching ISR (our `+shadow-regs` firmware qualifies). Confirm via DI/EI around the FP call. Draft reply parked, post only in user's voice.
- **[z88dk direction: classic forward, newlib deprecated](reference_z88dk_direction_classic_not_newlib.md) — MAINTAINER-STATED (z88dk/z88dk#3022): classic is the way forward, newlib is compat-only (being folded into classic); newlib file support NOT wanted (#34 stays unsupported). NEITHER lib is plain sdcccall(1) — public fns are __smallc/__z88dk_callee/__z88dk_fastcall; register-passing = __z88dk_fastcall; sdcccall(0) as the compiler convention beats per-call swapping. newlib's real edge for llvmz80 = it ships _callee/_fastcall variants clang calls directly (0 ex-de-hl adapters) vs classic's libsrc/l/llvmz80 adapter modules — but newlib is compat-only, so classic is the strategic target.**
- **[z88dk clang register ABI (ez80clang vs llvmz80)](reference_z88dk_clang_register_abi.md) — z88dk's `__CLANG` bridges were written for ez80-clang (eZ80, STACK args); ravn/llvm-z80 is z80 REGISTER ABI (HL/DE args, return in DE). The `defc ___X = X` string/mem bridges were wrong → hang; rewrote them in-place as `call asm_X; ex de,hl; ret` (z88dk commits bc1c0cd8, a452cd6c). strlen + single-arg fastcall class FIXED via header `__LLVMZ80` branch (12cfa587, 0292af1e). Don't split `__CLANG`. Bridges done for ~13 mem/str funcs; MANY str*/stdlib remain (see plan). Backend-HL-return would collapse all bridges to pure aliases.**
- **[clang double duty: ez80clang + llvmz80](reference_clang_double_duty_ez80_llvmz80.md) — BOTH z88dk clang backends define `__clang__`; any llvmz80 header/config branch MUST gate on `__LLVMZ80`, never bare `__clang__` (else it fires under the ez80clang oracle too). This is the newlib `_DEVELOPMENT/common/sys/compiler.h` trap (Phase C).**
- [newlib sdcc_iy links the sdcc_ix archive + IX audit](reference_newlib_sdcc_iy_uses_ix_archive.md) — `-clib=sdcc_iy` links sdcc_ix workers (only `--reserve-regs-iy` differs); clang's sole callee-saved GPR is IX, so the `__preserves_regs` risk = "does a public newlib entry clobber IX unrestored" → audited NO for stdio/malloc/str/atoi.
- [newlib clang integer helpers — CLOSED via llvmz80_imath.lib](reference_newlib_integer_helper_gap.md) — Phase C landed `-clib=newlib_iy/_ix` + compiler.h `__LLVMZ80` mapping. clang's gcc-style `__mulhi3`/`__divsi3`/`__divmodsi4`/`__mulsi3`/`__udivqi3` now provided by `z88dk/libsrc/l/llvmz80/newlib/llvmz80_imath.lib` (adapters over newlib-bundled `l_*` cores; wired into the CLIB lines). qsort/intdiv/long PASS.
- [z88dk newlib signed % drops sign — RESOLVED by lib rebuild](reference_newlib_signed_mod_z88dk_bug.md) — was a stale-prebuilt-lib bug (not clang); FIXED 2026-07-24 by merging upstream/master + rebuilding newlib libs (fix af5630797c). Merge left 2 classic clang regressions (#33 qsort, #32 strerror) — BOTH FIXED 2026-07-24 (see next). `xfail_signed_mod` now PASSES.
- [newlib IEEE-754 %f printf fix (#35) — split __mulsi3 + per-clib shim + __ZXNEXT trap](reference_llvmz80_newlib_ieee_printf_fix.md) — stock printf("%f") on newlib_iy + -D__LLVMZ80_IEEE_PRINTF now correct (z88dk cbbcc50031). 3 gotchas: split __mulsi3 (softfloat/imath dup), per-clib shim (classic shim bakes _sgoioblk), and the #ifdef __ZXNEXT placement trap (block silently skipped on CP/M).
- [newlib clang remaining gaps — #34 FILE* + #37 libm WONTFIX; #35 %f FIXED](reference_newlib_remaining_gaps_file_printf.md) — after Phase C the only remaining newlib_iy gaps are WONTFIX: #34 FILE* (CP/M newlib target has no file-open driver, maintainers want classic instead) + #37 libm. #35 variadic %f FIXED 2026-07-25 (`-D__LLVMZ80_IEEE_PRINTF`, z88dk cbbcc50031). classic printf_ieee skip + xfail_tmpfile are NOT product gaps.
- [llvmz80 classic qsort/strerror/bsearch fix — reversed-arg-alias-via-asm-label](reference_llvmz80_qsort_strerror_classic_fix.md) — #33+#32 fixed, commit 9e13c271c2 (classic clang 24 PASS/0 FAIL). qsort/bsearch: `stdlib.h __LLVMZ80` reversed-arg alias bound to `_qsort`/`_bsearch` via `__asm("name")` label (z80 re-prepends `_`) + swapping MACRO (inline would recurse) + `__smallc` comparator. strerror: add `__strerror_table.asm` to `llvmz80.lst` (was never in z80_crt0.lib; old "buildcrt glob" comment was false — z80nm proved it). bsearch xfail retired → runtime_bsearch.
- [z88dk lib rebuild is native (no Docker)](reference_z88dk_lib_toolchain_native.md) — CLAUDE.md "z88dk via Docker" note is STALE; bin/z88dk-{sccz80,zsdcc,z80asm} are native arm64. Recipe: `make -C libsrc TARGETS={cpm,z80}` + `install`; newlib `make -C libsrc/newlib cpm`; `*-clean` first (z80asm `-d` reuses stale .o). Libs gitignored (fix in source).

<!-- For project info that lives in the repo (not memory) — goal, TODOs, docs, MAME, PROM specs — see the "What's NOT in memory" map in README.md. -->

- **[M6: narrow i16 EQ/NE of byte sext (strrchr IY shuttle)](reference_m6_sext_icmp_narrowing.md)** — ravn/llvm-z80#259. `*s==(char)c` → un-narrowed i16 compare → IY shuttle. InstCombine misses the `ashr(shl x,8),8` sext-inreg idiom (narrows canonical `sext==sext` only). Z80-local GISel combine fixes -Oz/-Os only (LICM ordering); IR-level narrowing is the uniform fix (CHOSEN). No upstream report until verified end-to-end.

- **[z88dk runtime verify: ntvcm not ticks](reference_z88dk_runtime_verify_ntvcm.md)** — `+cpm` .COM under `ntvcm/ntvcm` for console output; `z88dk-ticks` does NOT emulate the `+test` `$ED$FE` console trap (no stdout). Idiomatic tests: `z88dk/test/clang/*.{c,sh}` via `NTVCM` env.

- **[Z80Pseudo undersize → far-`jr` under-relaxation class (#266/#267 + 14 latent)](issue267_pseudo_undersize_class.md)** — isPseudo pseudos that expand post-BranchRelaxation are sized 0 by getInstSizeInBytes → textual `.s` keeps out-of-range `jr` that z88dk z80asm rejects. #266+#267 fixed; guarded-LDIR/IDX8/MUL8/DIV8/SAT8 still latent.

- **[Pending canonical AGENTS.md edits](pending_agents_md_canonical_edits.md)** — cross-project rule changes discovered here but not yet applied to the canonical AGENTS.md repo. Currently queued: proactive oracle-coverage rule from #273 (every public entry point / sole helper user must run in the oracle).
- [Preserve reviewed commit](feedback_preserve_reviewed_commit.md) — on a PR under review, keep the reviewed commit as-is + add follow-ups; never squash it
- [RC702 MAME upstream PR #15805](project_rc702_mame_upstream_pr.md) — awaiting review; 3 commits, dot clock is PLL (plain int, not XTAL)
