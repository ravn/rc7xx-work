<!--
  CANONICAL LOCATION: tasks/memory/MEMORY.md (in the project, version-controlled).
  Migrated out of ~/.claude/ on 2026-05-28 per the "persistent notes in the
  project, never ~/.claude/" rule.  The harness no longer auto-injects this;
  CLAUDE.md directs reading it at session start.  Add new durable notes as a
  file here + a one-line index entry below.  Never write to ~/.claude/.

  Entries are grouped by *the moment the rule fires* (sections below).
  HARD rules are bolded.  Some entries appear under more than one
  heading — duplication is intentional: cost is one extra index line,
  benefit is "I see the rule when the trigger fires".
-->

## 0. ABSOLUTE BANS — read before EVERY find/ls/grep/glob

- **[NEVER traverse outside /Users/ravn/z80/](feedback_no_home_search.md) — ABSOLUTE. No `find /`, `find /Users`, `find ~`, `ls ~`, `mdfind`, `locate`. Re-violated 2026-05-09; one more strike = trust broken. CHECK PATH BEFORE EVERY find/ls/glob.**

## 1. Always-on (every response)

- **[Communication Style](feedback_style.md) — Think out loud, concise, no apologies, record prompts**
- **[NEVER apologize](feedback_no_apology.md) — HARD: no "sorry", no self-criticism, no "my bad"; report state + next action only**
- **[No compliments](feedback_no_compliments.md) — HARD: no "sharp observation"/"good question"/"great point"; start with the substantive answer**
- **[No aphoristic flourishes](feedback_no_aphoristic_flourishes.md) — HARD: never wrap a decision in a maxim ("saying when to stop is a feature", "less is more"); user reads it as passive-aggressive**
- **[ALWAYS show thinking](feedback_show_thinking.md) — HARD: narrate reasoning aloud at all times; default-terse system prompt does NOT override**
- **[Dig one level deeper before parking](feedback_dig_deeper_before_parking.md) — HARD: before declaring "deferred / multi-week / regalloc-level", instrument+bisect 30 min first. Session 73p: surface estimates wrong 5×; the drill collapsed "multi-week regalloc work" into 5-line peephole fixes.**
- **[Zoom out on recurring pattern](feedback_zoom_out_on_recurring_pattern.md) — HARD: the "dig UP" complement. On "same family / Nth time" or after fixing 2-3 of one class, STOP and find the systemic cause before the next fix — don't wait to be told (session 73s: 5 same-family bugs, never escalated until asked).**
- **[Audit the oracle, not just the fix](feedback_audit_oracle_not_just_fix.md) — HARD: a bug found by luck is a bug in your oracle. Found by accident / in a noise bucket / Nth of a class → build the detector that would have caught it on purpose (session 73s).**
- **[Verify process state by full enumeration](feedback_verify_process_state_full_enumeration.md) — HARD: never claim "nothing running / clean" from a `ps | grep` matching only what you EXPECTED. Enumerate fully (bare `ps -ax`, by RSS/elapsed/build-dir) + reconcile against the harness shell/task count; after a runaway-class bug assume an orphan (session 76: 4.5 GB / 3h38m `llc` missed by a grep omitting `llc`).**
- [No Unicode arrows](feedback_no_unicode_arrows.md) — Use ASCII `->` not `→`, Unicode arrows overlap following char in user's terminal
- **[NEVER unquoted "===" in shell](feedback_no_double_equals.md) — HARD: zsh emits `== not found` and SILENTLY TRUNCATES the rest of the command. Repeatedly violated; user reminded "several times already" 2026-05-22. Use `---` as separator.**
- **[State certainty](feedback_state_certainty.md) — HARD: state as fact ONLY if verified this session; surface ALL doubt + offer research; familiarity/pattern-match ≠ certainty; correct overclaims in issues/commits too (re-reinforced 2026-05-26, #198)**
- [Ask about design decisions](feedback_ask_about_design_decisions.md) — at non-obvious forks, lay options out and let user pick
- [No ask in debug loop](feedback_no_ask_in_debug_loop.md) — inside a standing-auth debug cycle, run the next step; no "want me to...?"

## 2. Before any commit / PR / issue

- **[Never create UNSOLICITED PRs](feedback_no_pull_requests.md) — HARD: never `gh pr create` unless the user asks this turn. Engagement-mode (session 77): user may direct a tests-only + infra PR to llvm-z80/llvm-z80; NEVER a per-bug or fix PR.**
- **[Explain before filing](feedback_explain_before_filing.md) — HARD (2026-06-05, post-PR-#17 rejection): no upstream issue/PR/commit/close-comment goes out until root cause is explained in plain English in chat AND user says "go ahead, file it" for THIS specific filing. No batch approvals. Applies to ravn/* forks too. Step 2 (2026-06-06): check the target tracker for known-bug duplicates FIRST.**
- **[Cross-machine workflow](feedback_cross_machine_workflow.md) — HARD (2026-06-06): user works across multiple hosts (macbook + sonnyboy + future). State that isn't in git is lost on switch. Commit-push at end of every working segment; pull-with-submodules at start; use `tasks/handoff/YYYY-MM-DD-slug.md` for live in-progress narrative.**
- **[No commit on lit+size alone](feedback_no_commit_first_version.md) — HARD: combiner/ISel/lowering changes need value oracle (test-runner + MAME boot) BEFORE commit**
- **[Consult rules before acting](feedback_consult_rules_before_acting.md) — HARD: before proposing/implementing any fix, search MEMORY.md, cite rules; commit message must include `Rules-checked:` line**
- **[Grep repo docs before deriving](feedback_grep_repo_docs_before_deriving.md) — HARD: grep repo for existing `*_REFERENCE.md` / `*_CHARACTER_ROM.md` before re-deriving encodings.**
- [No UNSOLICITED Upstream Issues](feedback_no_upstream_issues.md) — default: file in ravn/* forks. When the user directs a curated submission (session 77), file at llvm-z80/llvm-z80 — one per underlying bug, draft→approve→file, linked failing test; never official llvm/llvm-project
- **[Upstream routing CORRECTED](feedback_upstream_routing_two_targets.md) — HARD (2026-06-05): generic-LLVM bugs go to llvm/llvm-project (or stay as local XFAIL only); llvm-z80/llvm-z80 is ONLY for Z80-specific bugs. Session 77's "z80 upstream only" was a velocity directive, not a routing override -- PR #17 misroute proved it.**
- **[MAME upstream routing](feedback_mame_upstream_routing.md) — HARD (user 2026-06-02): NEVER file in any MAME repo without explicit per-issue permission. Shared devices (FDC/PIO) → mamedev/mame; rc702 driver → ravn/mame fork. rc702 isn't upstream — repro device bugs on an upstream machine + latest MAME, run it in MAME, verify datasheet vs primary source, don't bundle with the driver.**
- **[No local zsdcc fixes](feedback_no_local_zsdcc_fixes.md) — HARD (user 2026-05-29): don't fix zsdcc/SDCC bugs in ravn/z88dk; root-cause + minimal-repro, mark `wontfix`, report upstream (e.g. #3/#16/#17). llvm-z80 (clang) fixes still done locally.**
- [File dep bugs in ravn/* forks](feedback_file_issues_in_forks.md) — bug in dep (llvm-z80, z80pack, mame, …) → ravn/* fork issue with repro + test case
- [Always test compiler bugs](feedback_compiler_bug_test.md) — Add XFAIL lit test for every clang Z80 codegen bug found
- [Test before fix](feedback_test_before_fix.md) — Always create failing test before implementing a fix
- [Project timeline log](feedback_timeline_record_keeping.md) — Append to rc700-gensmedet/tasks/timeline.md per meaningful change; tag Easy/Medium/Hard/Painful

## 3. Before any memory-layout / linker / address change

- **[RC702 IVT page constraint](project_rc702_ivt_page_constraint.md) — IM 2 IVT page (I*256) cannot overlap display memory 0xF800..0xFFCF; I=0xFF and I=0xF8..0xFE all forbidden; valid pages are 0xEC00/0xED00 (BSS) or 0xF500 (resident)**
- **[RC702 bank2h PROM mirror](feedback_rc702_bank2h_mirror.md) — HARD: 0x2800..0x2FFF is bank2h PROM1-mirror, NOT RAM. Use 0x1000..0x1FFF or 0x3000..0xF7FF for BSS before PROM-disable.**
- **[Grep mem_map before BSS literal](feedback_grep_memmap_before_bss.md) — HARD: before allocating BSS at a literal address, grep the emulator driver's mem_map for that range. Generalizes [[feedback-rc702-bank2h-mirror]]**
- **[Slave RAM state outside TPA](feedback_slave_state_outside_tpa.md) — HARD: slave-side state at 0x0100..BDOS-1 is INSIDE TPA; CP/M programs overwrite silently. Pin to SNIOS reserved area (0xED00..0xF7FF on RC702).**
- **[Phase-boundary state-address audit](feedback_state_address_phase_audit.md) — HARD: re-audit state addresses when a piece of state changes lifecycle (prom-init -> RAM-resident). Generalizes [[feedback-slave-state-outside-tpa]] + [[feedback-rc702-bank2h-mirror]].**
- **[Audit memory layout on port](feedback_memory_layout_on_port.md) — HARD: when porting, audit memory-layout invariants PROACTIVELY; hardcoded address constants describe hope; prefer HIGH(symbol) over literals**
- **[No literal memory addresses](feedback_no_literal_addresses.md) — HARD: every memory address must be linker-derived or `.sym`-extracted; literals OK only for ports, vectors, magic constants**
- **[Cross-stage --defsym atomic](feedback_relink_dependencies_atomically.md) — HARD: cross-stage `extern X[]` requires C decl + linker script + Makefile awk + Makefile defsym in the same commit; mind Z80-ABI underscore count**
- [cpnos.com address coupling brittle](project_cpnos_address_coupling_brittle.md) — cpbios.asm `rbcout` etc. hand-typed; silently desync from resident BIOS VMA — never replicate
- [Sentinel preconditions](feedback_sentinel_preconditions.md) — Never promote a context-specific sentinel to a shared #define; re-derive "real data can't equal sentinel" at every use site

## 4. Before any build / compile / link flag change

- **[Check sibling subprojects](feedback_check_sibling_subprojects.md) — HARD: before adding a build/compile/link flag, grep sibling subprojects for the same flag and mirror their wrapping**
- **[Symmetric recipes per compiler](feedback_symmetric_recipes_per_compiler.md) — HARD: parallel `ifeq COMPILER` Makefile recipes must emit the SAME artifact set; asymmetric outputs → stale-ROM "BAD CHECKSUM".**
- **[Build-var artifacts content-check, not mtime](feedback_build_var_artifacts_content_check.md) — HARD: generated files embedding TRANSPORT/COMPILER must regen via `$(shell)` grep of embedded marker, not mtime stamp. Diagnostic: `head -1 file`.**
- [Test both compilers](feedback_dual_compiler_test.md) — rcbios changes MUST build with BOTH z88dk and clang before commit; SDCC rejects `__asm__ volatile`
- [Check memory for builds](feedback_check_memory_for_builds.md) — Always check memory for correct build flags before building
- [Build-tool binaries](reference_build_binaries.md) — cmake/ninja from CLion app bundle (no brew); native llc/clang in llvm-z80/build-macos/bin
- [Z80 tool paths + canonical invocations](reference_z80_tool_paths.md) — full paths for ninja/clang/llc/opt/z88dk-ticks/test-runner/sweep with BUILD_DIR + PATH overrides
- **[Don't kill ninja mid-build](feedback_dont_kill_ninja.md) — HARD: SIGTERM/SIGKILL truncates .ninja_log -> "premature end of file" + 1700+ step rebuild. Wait it out or Ctrl-C ONCE.**
- **[Ninja clang+llc together](feedback_ninja_clang_llc_together.md) — HARD: after Z80 backend pass change, `ninja clang llc` BOTH; `ninja llc` alone leaves clang symlink stale, downstream builds look unchanged.**
- [Docker for missing binaries](feedback_docker_binaries.md) — Use Docker images for missing CLI tools, don't suggest installing
- [Build zmac if missing](feedback_build_zmac.md) — zmac builds from source in zmac subfolder, just `make`
- **[zmac local labels are global](feedback_zmac_local_label_scope.md) — HARD: zmac doesn't scope dotted local labels per parent; two `.wait:` in different subroutines collide as multi-def. Prefix with subroutine initials (.a_wait, .b_wait)**
- [macOS timeout](reference_macos_timeout.md) — No GNU timeout on macOS; use Bash tool's timeout param or perl -e 'alarm; exec'
- [C23 subset](feedback_c11_standard.md) — Use tested C23 features when refactoring (true/false/nullptr/typeof/0b)
- [No Undocumented Default](feedback_no_undocumented_default.md) — Never use undocumented Z80 instructions without +undocumented flag
- [Check for Undocumented](feedback_undoc_check.md) — After compilation, grep asm for IXH/IXL/IYH/IYL, file issues if found
- [Always regenerate timestamp](feedback_timestamp.md) — Delete builddate.h before every BIOS/PROM build
- [MAME OSD=sdl](feedback_mame_osd_sdl.md) — MAME must be built with OSD=sdl (not sdl3), full command in docs/MAME_RC702.md

## 5. Before any llvm-z80 compiler-codegen change

- **CRITICAL framing — [Z80 backend unfinished](project_z80_backend_unfinished.md): ravn/llvm-z80 Z80 support is preliminary; goal is to FINISH the backend correctly, not optimize a finished one**
- **CRITICAL framing — [Z80 staged collaboration model](project_z80_upstream_goal.md): near-term target llvm-z80/llvm-z80 (active fork parent); long-term aspiration llvm/llvm-project; collaborate with owner first**
- **[No commit on lit+size alone](feedback_no_commit_first_version.md) — HARD (cross-listed from §2): value oracle required before commit on combiner/ISel/lowering changes**
- [Always test compiler bugs](feedback_compiler_bug_test.md) — Add XFAIL lit test for every clang Z80 codegen bug found
- [Verify codegen not just size](feedback_verify_codegen.md) — For multi-compiler portable code, read disassembly per compiler — same size ≠ same behavior
- **[Compiler is not trusted](feedback_compiler_not_trusted.md) — HARD: ravn/llvm-z80 is unfinished; on any suspected bug, inspect generated Z80 asm BEFORE blaming source/runtime/hardware**
- [Late-opt audit](reference_late_opt_audit.md) — Pre-existing session-37 classification of all 46 Z80LateOptimization.cpp peepholes as Keep/Migrate/Delete
- [Root-cause over peephole](feedback_root_cause_over_peephole.md) — Favor upstream fixes (MIR DCE, regalloc cost model, GISel combiner) over post-RA peepholes
- **[Peephole safety guards](feedback_peephole_safety_guards.md) — HARD: late-opt peepholes that erase/move/convert need complete liveness + slot-aliasing (indirect/loop-carried/other-block/other-class) + iterator guards. Session 73s = 5 fixes of this one family (#14/#192/#193/#195×2).**
- [Proper fixes — backend immature](feedback_proper_fixes_immature_backend.md) — Question prior design decisions; don't band-aid an immature backend, including reverting my own past code
- [T-states Matter](feedback_tstates.md) — Evaluate both code size AND execution time for instruction sequences
- [Don't fight SDCC iCode](feedback_dont_fight_sdcc_icode.md) — Don't preempt SDCC's iCode allocator with `static`-locals; SDCC keeps auto-locals in registers. For clang use `+static-stack`.
- **[SDCC block-scope extern broken](feedback_sdcc_block_scope_extern.md) — HARD: declare cross-TU function externs at FILE scope under z88dk-SDCC; block-scope drops the GLOBAL emit (ravn/z88dk#7).**
- [Prefer C over inline asm](feedback_prefer_c_over_asm.md) — Don't replace small C constructs with __asm__ for ~6-10 B; file llvm-z80 codegen issues instead
- **[Z80 copies have spurious mayLoad/mayStore](feedback_z80_copy_spurious_mem_flags.md) — HARD: don't use MI.mayLoad()/mayStore() in Z80 peepholes; use !MI.memoperands_empty() (LD_D_A flag-noise, #154).**
- **[zeroext is ABI, not source-narrow](feedback_zeroext_is_abi_not_source.md) — HARD: `i16 zeroext` is an ABI signal, NOT proof source was narrower. Use computeKnownBits before narrowing. Session 71 #162: 318 miscompiles.**
- **[TruncInstCombine: swap before probe](feedback_truncinstcombine_swap_before_probe.md) — HARD: modify IR users BEFORE `getBestTruncatedType`; the multi-use guard bails otherwise. Need rollback on failure branch.**
- [IX caller-saved after #12](project_ix_caller_saved_after_12.md) — IX as an allocatable reg is a regression in the callee-saved ABI; only caller-saved IX wins (needs #12 FP-elimination). Revisit then.

## 6. Before any MAME / boot / test run

- **[Verify banner timestamp before trust](feedback_check_banner_timestamp.md) — HARD: check siob.raw banner timestamp vs latest BUILD_INFO_STR before any diagnosis; same timestamp across rebuilds = stale ROM.**
- **[Polypascal stage-1/2 flake = MP/M daemon state](feedback_polypascal_stage1_flake.md) — On polypascal-test timeout at stage 1 (E>) or stage 2 (`>>`), first try `make _kill-mpm; sleep 5-8; retry`. Stuck daemon mimics codegen regression.**
- **[Session-start: kill daemons BEFORE first test](feedback_session_start_kill_daemons.md) — HARD: at session start (no memory of prior daemon state), proactively `make -C cpnos-in-c _kill-mpm; sleep 8` BEFORE the first MAME/polypascal/CP-NET run, and between COMPILER switches. Proactive form of [[feedback-polypascal-stage1-flake]].**
- **[Screenshot to verify](feedback_screenshot_to_verify.md) — HARD: always capture a MAME screenshot to verify boot; PASS log lines AND memory dumps at the display base are NOT enough (the dump may be stale / wrong base / not what the CRTC paints — burned a session 2026-06-03).**
- **[Black screen is fatal](feedback_black_screen_fatal.md) — HARD: black MAME screen halts all other investigation; root-cause boot path before anything else**
- [Black screen → CRT ISR not firing](feedback_black_screen_crt_isr.md) — black RC702 display means `isr_crt` isn't running; suspect EI / IVT slot 2 / CTC ch2 in that order; SIO-B output still valid in this state
- [MAME Banner Check](feedback_mame_banner.md) — Verify boot banner compiler (CL=clang, ROA375=SDCC), fail if wrong
- [MAME PROM Checksum](feedback_mame_checksum.md) — Verify MAME CRC matches built PROM before trusting boot results
- [MAME ROM warning is a bug](feedback_mame_rom_warning.md) — Fix BAD_DUMP in driver, don't dismiss the warning
- [Full rebuild before MAME](feedback_mame_rebuild.md) — Always rm .o and rebuild fully before MAME boot test
- [Fresh BIOS+PROM before MAME](feedback_mame_fresh_build.md) — Always rebuild both BIOS and PROM before MAME boot
- [Run MAME at full speed](feedback_mame_full_speed.md) — Always include `-nothrottle` in unattended MAME tests
- **[MAME windowed only](feedback_mame_windowed_only.md) — HARD: always pass `-window`; never fullscreen (user directive 2026-05-25)**
- [MAME interactive timeout](feedback_mame_interactive_timeout.md) — Interactive MAME launches only need ~30s Bash timeout
- [Lua no port reads](feedback_lua_no_port_reads.md) — MAME Lua must never read IO ports (double reads break devices); use install_read_tap instead
- **[Lua errors are fatal — fix them first](feedback_lua_errors_fatal.md) — HARD: any `[LUA ERROR]` in a MAME run invalidates the harness's reported result. Triage: `grep -c 'LUA ERROR' <log>` → fix lua → re-run → THEN interpret. Burned a session (2026-06-03) ignoring 20 errors/run, mis-filed ravn/llvm-z80#215.**
- **[Display address from DMA, never hardcode](feedback_display_addr_from_dma.md) — HARD: read the RC702 display base from the Am9517A DMA ch2 address reg (write-taps on 0xF4 low/high + 0xFC clear), never hardcode 0x7A00/0xF800; bases differ per PROM (autoload 0x7A00, roa375 0x7800). Hardcoding misread the screen 2026-06-02.**
- [Bench self-termination](feedback_bench_must_self_terminate.md) — bench Lua taps must call `manager.machine:exit()` on finish-signal
- [No permission for MAME/MP/M launch](feedback_mame_mpm_no_permission.md) — standing authorization to spawn/kill MAME and z80pack mpm-net2 during RC702 work
- [Pre-launch change summary](feedback_show_changes_before_launch.md) — Before every MAME run, list edits/build/PROM/daemons + the hypothesis the run tests
- [MP/M shutdown via BYE](feedback_mpm_bye_shutdown.md) — Stop mpm-net2 with `BYE` on the console rather than killing cpmsim PID
- [CP/NOS MAME prereqs](project_cpnos_mame_prereqs.md) — z80pack-MP/M up + no stale conn + NDOS in-sync + cpnos-rom built; harness shouldn't spawn MP/M itself
- [Check port 4002 before MAME](feedback_port4002_check.md) — Abort if anything listens on :4002 before launching MAME for CP/NET
- [Watch slow commands](feedback_watch_slow_commands.md) — Flag unusually slow RC702/CP-NET ops; prior symptom was BIOS register clobbering
- [MAME keyboard test](reference_mame_keyboard_verification.md) — natkeyboard:post() to verify PIO-A → isr_pio_kbd → kbd_ring → impl_conin → CCP chain
- [pio-irq-fix test topology](project_pio_irq_test_topology.md) — Slave on PIO-with-envelope; use `make pio-irq-netboot` (PIO-B → mpm-net2 :4002 direct)

## 7. Before file/script ops

- **[NEVER traverse outside /Users/ravn/z80/](feedback_no_home_search.md) — see §0; ABSOLUTE BAN, re-violated 2026-05-09**
- **[No stale dump files](feedback_no_stale_dump_files.md) — HARD: `rm -f /tmp/foo` BEFORE the producer command, every iteration; never read a /tmp/* artifact without confirming it's from this iteration**
- **[No DOTALL backtracking on source](feedback_no_dotall_backtracking.md) — HARD: don't combine `re.DOTALL` with non-greedy `.*?` over multi-line source; use awk/grep or hand-rolled char-state machine; kill any scan exceeding ~10s**
- [z80 tree has no untrusted hooks](feedback_z80_tree_no_untrusted_hooks.md) — `cd /Users/ravn/z80/… && git …` is safe; do not hedge on hook risk
- [Docker Trace Disk](feedback_docker_trace.md) — z88dk-ticks -trace must pipe through tail, fills disk otherwise
- [CRLF on CP/M disk text](feedback_crlf_cpm_disk.md) — Always use CR+LF when injecting text into a CP/M disk image
- [Transcribe image PDFs](feedback_pdf_transcribe.md) — Create text version in repo when scanning image PDFs

## 8. Test / debug discipline

- **[Revalidate concern, not filename](feedback_revalidate_concern_not_filename.md) — HARD: an issue is NOT resolved because a file moved/dir was renamed/split, or a workaround is in place; verify the actual symptom in CURRENT source before closing. (User correction 2026-05-28: cpnos-rom split → bugs carried into cpnos-in-c.)**
- **[Outlier-first, not sweep](feedback_outlier_first_not_sweep.md) — HARD: when comparing two systems, find ≥1.5× / ≥50 B divergences and dig in; do NOT methodically touch every difference**
- **[Verify matrix before theory](feedback_verify_matrix_before_theory.md) — HARD: contradictory test-cell pattern = stale state; `make clean` + re-verify anchors before drawing cross-axis conclusions**
- **[Compilers agree means harness](feedback_compilers_agree_means_harness.md) — HARD: when clang + SDCC fail identically at byte level on shared C source, suspect MAME wiring / harness topology BEFORE auditing the binary**
- **[Compare total section sizes](feedback_compare_total_section_sizes.md) — HARD: for two-compiler size comparisons, sum all loaded sections (.text+.rodata+.data); per-function .text hides jumptables.**
- **[No mental arithmetic in fixtures](feedback_no_mental_arithmetic_in_fixtures.md) — HARD: never hand-compute expected values for non-trivial arithmetic; use trivial math, a tool, or a parallel reference**
- **[Auto-kill stale daemons](feedback_kill_stale_servers_on_test_target.md) — HARD: test targets that spawn long-running daemons should auto-cleanup leftover instances (BYE first, then SIGTERM)**
- **[Diff binaries before blaming codegen](feedback_diff_binaries_before_blaming_codegen.md) — HARD: when two configs "behave differently" at runtime, `cmp -l a b` FIRST. Byte-identical = environmental, not codegen.**
- **[Verify writes before chasing reads](feedback_verify_writes_before_chasing_reads.md) — HARD: when a buffer reads back wrong bytes, FIRST check the write succeeded (instrument around the store), THEN investigate input.**
- **[Recognize ROM-shadow byte patterns](feedback_recognize_rom_shadow_patterns.md) — HARD: structured "wrong" bytes from buffer/port reads → `xxd build/prom*.bin | head` first. If bytes match ROM, the bug is memory-map / mirror, not transport.**
- **[No taps inside polled-RX hot path](feedback_no_taps_in_polled_rx.md) — HARD: per-byte blocking debug TX inside polled-RX overruns the Z80 SIO 3-deep FIFO and drops bytes silently. Use per-frame markers or buffered ring trace.**
- **[A/B before blaming test-runner](feedback_ab_before_blaming_test_runner.md) — HARD: when test-runner FAILs after a llvm-z80 patch, stash + rebuild + rerun to A/B baseline first. test_90/91 edge_*_O1 are known noise (#136).**
- **[Baseline before implementing](feedback_baseline_before_implementing.md) — HARD: capture control measurement (fail-set/sizes/ts) on UNMODIFIED system BEFORE changing code; reconstructing "before" after the fact is slow + error-prone (session-ix miss).**
- **[Value oracle covers all TRANSPORT cells](feedback_value_oracle_all_transport_cells.md) — HARD: for SNIOS/xport_*/compat.h changes, runtime-test every linking TRANSPORT cell (session 58 shipped a latent SIO correctness gap).**
- **[Extract rules from time-sinks](feedback_extract_rules_from_time_sinks.md) — HARD (meta): after long debug sessions, proactively propose new memory-rule entries that would have caught the bug class earlier.**
- **[Verify PASS condition before trusting green](feedback_verify_pass_condition.md) — HARD: when a test prints PASS, cross-check elapsed time vs plausibility + scan artefact for setup-step evidence. Workaround without explanation = red flag.**
- [User guesses are not constraints](feedback_user_guesses_not_constraints.md) — when user says "my guess is X", treat as starting suggestion; widen candidate list; probe-first not hypothesis-first
- ["Intermittent" is a hypothesis](feedback_intermittent_is_hypothesis.md) — When inheriting "race / intermittent" framing, falsify it via data-content checks before pursuing timing causes
- [Integration Tests Expensive](feedback_integration_tests.md) — Only run full test suite before merge/PR
- [Zoo Fast First](feedback_zoo_fast_first.md) — Quick subset first, full suite only when asked
- [Verify DELAY_T](feedback_delay_tstates_test.md) — Integration tests must verify DELAY_T matches actual inner loop T-states
- [Poll don't sleep](feedback_poll_dont_sleep.md) — Poll for completion markers instead of long fixed sleeps on background tasks
- [Canonical targets > enumeration](feedback_canonical_targets_over_enumeration.md) — for lit/test workflows use `ninja check-<x>` instead of enumerating tools

## 9. Code & source style

- **[Clarity in C code](feedback_clarity_in_c_code.md) — HARD: prefer readable call shapes over macro tricks; compiler-specific glue confined to hal.h/intrinsic.h, never #ifdef in business logic**
- [Size over speed for cold paths](feedback_size_over_speed_for_cold_paths.md) — code that runs only a few times (cold-init, shutdown, error paths): bytes are permanent, T-states aren't; prefer compact loops over unrolled bodies
- [Volatile blocks loop idiom](feedback_volatile_blocks_loop_idiom.md) — clang's `LoopIdiomRecognize` rejects volatile stores; default-add volatile on cold-init pointers blocks memcpy/memset/LDIR-overlap. Only volatile for ISR-shared state or hardware-changing memory.
- [No self-correction in published docs](feedback_no_self_correction_in_published_docs.md) — drop "wait / actually / let me re-read" asides from committed docs/specs; narrate self-checks in chat, publish only the final version (CPNET_WIRE_PROTOCOL.md leak, 2026-05-10)

## 10. Project facts — RC702 hardware

- [No RC700 HW mods](user_no_hw_mods.md) — No PCB modifications; cables and external devices are OK
- **[2 KB PROM hard limit](project_rc702_2kb_prom_hard_limit.md) — HARD: user's RC702 has no A11 bridge (later-model feature); PROM0 + PROM1 are capped at 2048 B each. Never propose "close A11" / "use 2732" as a contingency.**
- [SIO-A fast TX, no fast RX](project_sioa_tx_only_fast.md) — ÷1 bit clock at 614 kbaud verified TX (framing layer uncertain); fast RX impossible (no DPLL, pins 15/17 NC); SIO-B likely same
- [Two Picos available](project_pico_count.md) — user has 2 Pi Picos; one runs cbl923 keyboard rig, second earmarked for J3 CP/NET bridge

## 11. Project facts — cpnos / cpnet / DRI

- **[Long-term goal: finish rcbios + autoload-in-c + CP/NET + cpnos](project_finishing_firmware_components.md) — user directive 2026-06-03: bring the four firmware components to a finished state. The compiler track serves them; bias toward work that measurably advances one of the four.**
- **[cpnos PARKED 2026-06-04 — awaiting physical parallel cable](project_cpnos_parked_awaiting_parallel_cable.md) — surface this before acting on any cpnos source / PIO transport / polypascal-test task. Unpark on user signal cable arrived.**
- **[SEM702 chip-photo request](project_sem702_request_chip_photo.md) — next time the physical RC702 is open, ASK the user to photograph the SEM702 piggyback boards (large on ic82, small under ic68) so we can ID the actual TTL/SRAM chips. Drop the reminder once the photo arrives.**
- [DRI NDOS — no upstream](project_dri_ndos_frozen.md) — cpnet-z80 DRI sources have no live upstream; we own them and can edit freely
- [CP/NOS no local floppy](project_cpnos_no_local_floppy.md) — CP/NOS payload stays diskless; do not propose drive B: as physical floppy on the slave
- [Fast link is CP/NET-only](project_fast_link_cpnet_only.md) — fast host<->RC702 transport is for CP/NET + CP/NOS frames only
- [Z80 simple, host complex, hardware-compatible](project_z80_simple_host_complex.md) — slave-side Z80 small/fast; push protocol work to host; must run on physical RC702
- [HiTech port parked — check note first](feedback_check_hitech_park_note.md) — read `rc700-gensmedet/tasks/hitech-port-parked.md` before proposing HiTech as third compiler
- **[AES corpus = parity oracle](project_aes256_corpus_goal.md) — `aes256-corpus/` drives clang→zsdcc parity AND queues SDCC bugs for upstream (two tracks, each files issues with test cases: ravn/llvm-z80#156, ravn/z88dk#5/#6). Post-73p Phase 1: clang DOMINATES SDCC on `09_Oz_prod_like` (−23% bin, −11% ts), all 13 configs faster. New gaps tracked in `tasks/all-modes-competitive-plan.md`.**

## 12. External-bug refs

- [ravn/mame#6 — PIO-B slot regression](project_ravn_mame_6.md) — open MAME bug; gates Option P bring-up; check status before resuming cpnet-fast-link work
- [ravn/mame#6 — workarounds failed](project_ravn_mame_6_workarounds_failed.md) — Path 2 (Einstein topology) and Path 3 (bypass slot) both attempted and failed; underlying bug must be fixed at chip/slot layer

## 13. Reference / one-offs

- [User Profile](user_profile.md) — Experienced dev, Z80/LLVM/SDCC, CLion, Docker, no brew
- [HiTech zc Docker image](reference_hitech_zc_docker.md) — `ghcr.io/ravn/hitech` provides the `zc` (HiTech C) Z80 compiler — Docker, no local install
- [Memory in tasks/memory/, never ~/.claude/](feedback_no_claude_memory.md) — durable memory canonical in `tasks/memory/`, read manually at session start; never write to `~/.claude/`

<!-- For project info that lives in the repo (not memory) — goal, TODOs, docs, MAME, PROM specs — see the "What's NOT in memory" map in README.md. -->
