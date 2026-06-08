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

- **[Token-efficiency disciplines](feedback_token_efficiency.md) — HARD: (1) never raw logs into context — file + grep/tail summary, failing slice only; (2) long builds/runs in background; (3) handoff file + suggest fresh session at work-item boundaries.**
- **[Communication Style](feedback_style.md) — think out loud, concise, no apologies, record prompts**
- **[NEVER apologize](feedback_no_apology.md) — HARD: no "sorry"/self-criticism; report state + next action**
- **[No compliments](feedback_no_compliments.md) — HARD: start with the substantive answer**
- **[No aphoristic flourishes](feedback_no_aphoristic_flourishes.md) — HARD: never wrap a decision in a maxim**
- **[Show thinking — TIERED](feedback_show_thinking.md) — HARD: full narration at decisions/diagnoses/forks/surprises; one-liners during mechanical loops (tiered 2026-06-06)**
- **[Dig one level deeper before parking](feedback_dig_deeper_before_parking.md) — HARD: before declaring "deferred/multi-week", instrument + bisect 30 min first**
- **[Zoom out on recurring pattern](feedback_zoom_out_on_recurring_pattern.md) — HARD: after 2-3 fixes of one class, STOP and find the systemic cause unprompted**
- **[Audit the oracle, not just the fix](feedback_audit_oracle_not_just_fix.md) — HARD: bug found by luck → build the detector that would have caught it on purpose**
- **[Verify process state by full enumeration](feedback_verify_process_state_full_enumeration.md) — HARD: never claim "clean" from a `ps | grep` of expected names; enumerate fully + reconcile**
- [No Unicode arrows](feedback_no_unicode_arrows.md) — ASCII `->`, not `→`
- **[NEVER unquoted "===" in shell](feedback_no_double_equals.md) — HARD: zsh silently truncates the command; use `---` as separator**
- **[State certainty](feedback_state_certainty.md) — HARD: fact only if verified this session; surface ALL doubt; applies to issues/commits too**
- [Ask about design decisions](feedback_ask_about_design_decisions.md) — at non-obvious forks, lay options out, user picks
- [No ask in debug loop](feedback_no_ask_in_debug_loop.md) — inside standing-auth debug cycle, run the next step

## 2. Before any commit / PR / issue

- **[Never create UNSOLICITED PRs](feedback_no_pull_requests.md) — HARD: no `gh pr create` unless asked this turn; never per-bug/fix PRs upstream**
- **[Explain before filing](feedback_explain_before_filing.md) — HARD: root cause explained in chat + explicit per-filing "go ahead" before ANY upstream post; check target tracker for duplicates FIRST**
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
- [File dep bugs in ravn/* forks](feedback_file_issues_in_forks.md) — with repro + test case
- [Always test compiler bugs](feedback_compiler_bug_test.md) — XFAIL lit test for every clang Z80 codegen bug
- [Test before fix](feedback_test_before_fix.md) — failing test before implementing
- [Project timeline log](feedback_timeline_record_keeping.md) — append to rc700-gensmedet/tasks/timeline.md per meaningful change

## 3. Before any memory-layout / linker / address change

- **[RC702 IVT page constraint](project_rc702_ivt_page_constraint.md) — IM 2 IVT page must not overlap display 0xF800..0xFFCF; valid: 0xEC00/0xED00 (BSS) or 0xF500 (resident)**
- **[RC702 bank2h PROM mirror](feedback_rc702_bank2h_mirror.md) — HARD: 0x2800..0x2FFF is PROM1-mirror, NOT RAM**
- **[Grep mem_map before BSS literal](feedback_grep_memmap_before_bss.md) — HARD: grep emulator mem_map before allocating BSS at a literal address**
- **[Slave RAM state outside TPA](feedback_slave_state_outside_tpa.md) — HARD: pin slave state to SNIOS reserved area (0xED00..0xF7FF), never inside TPA**
- **[Phase-boundary state-address audit](feedback_state_address_phase_audit.md) — HARD: re-audit state addresses when lifecycle changes (prom-init → RAM-resident)**
- **[Audit memory layout on port](feedback_memory_layout_on_port.md) — HARD: audit layout invariants proactively when porting; prefer HIGH(symbol) over literals**
- **[No literal memory addresses](feedback_no_literal_addresses.md) — HARD: linker-derived or `.sym`-extracted only; literals OK for ports/vectors/magic**
- **[Cross-stage --defsym atomic](feedback_relink_dependencies_atomically.md) — HARD: C decl + linker script + Makefile awk + defsym in same commit; mind underscore count**
- [cpnos.com address coupling brittle](project_cpnos_address_coupling_brittle.md) — never replicate hand-typed cross-image addresses
- [Sentinel preconditions](feedback_sentinel_preconditions.md) — re-derive "real data ≠ sentinel" at every use site

## 4. Before any build / compile / link flag change

- **[Check sibling subprojects](feedback_check_sibling_subprojects.md) — HARD: grep siblings for the same flag, mirror their wrapping**
- **[Symmetric recipes per compiler](feedback_symmetric_recipes_per_compiler.md) — HARD: parallel `ifeq COMPILER` recipes must emit the SAME artifact set**
- **[Build-var artifacts content-check, not mtime](feedback_build_var_artifacts_content_check.md) — HARD: files embedding TRANSPORT/COMPILER regen via content grep**
- [Test both compilers](feedback_dual_compiler_test.md) — rcbios changes build with BOTH z88dk and clang before commit
- [Check memory for builds](feedback_check_memory_for_builds.md) — check memory for correct build flags first
- [Build-tool binaries](reference_build_binaries.md) — cmake/ninja from CLion bundle (mac); native llc/clang in llvm-z80/build-macos/bin
- [Z80 tool paths](reference_z80_tool_paths.md) — full paths + canonical invocations, BUILD_DIR/PATH overrides
- **[AVR density oracle](feedback_avr_density_oracle.md) — HARD: before blaming a generic pass or filing upstream, compile the repro for in-tree AVR; AVR-cheap + Z80-expensive = OUR backend gap (and AVR shows the mechanism)**
- **[Don't kill ninja mid-build](feedback_dont_kill_ninja.md) — HARD: SIGKILL truncates .ninja_log → 1700+ step rebuild; Ctrl-C ONCE**
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

## 5. Before any llvm-z80 compiler-codegen change

- **CRITICAL framing — [Z80 backend unfinished](project_z80_backend_unfinished.md): goal is to FINISH the backend correctly, not optimize a finished one**
- **CRITICAL framing — [Z80 staged collaboration model](project_z80_upstream_goal.md): near-term llvm-z80/llvm-z80; long-term llvm/llvm-project; collaborate with owner**
- **[No commit on lit+size alone](feedback_no_commit_first_version.md) — HARD (cross-listed §2): value oracle required**
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

## 6. Before any MAME / boot / test run

- **[Verify banner timestamp before trust](feedback_check_banner_timestamp.md) — HARD: banner timestamp vs BUILD_INFO_STR before any diagnosis**
- **[Polypascal stage-1/2 flake = MP/M daemon state](feedback_polypascal_stage1_flake.md) — first try `make _kill-mpm; sleep 5-8; retry`**
- **[Session-start: kill daemons BEFORE first test](feedback_session_start_kill_daemons.md) — HARD: `make -C cpnos-in-c _kill-mpm; sleep 8` before first run + between COMPILER switches**
- **[Screenshot to verify](feedback_screenshot_to_verify.md) — HARD: capture a MAME screenshot to verify boot; PASS lines + memory dumps are NOT enough**
- **[Black screen is fatal](feedback_black_screen_fatal.md) — HARD: halts all other investigation**
- [Black screen → CRT ISR not firing](feedback_black_screen_crt_isr.md) — suspect EI / IVT slot 2 / CTC ch2 in that order
- [MAME Banner Check](feedback_mame_banner.md) — verify compiler (CL=clang, ROA375=SDCC)
- [MAME PROM Checksum](feedback_mame_checksum.md) — verify CRC matches built PROM
- [MAME ROM warning is a bug](feedback_mame_rom_warning.md) — fix BAD_DUMP, don't dismiss
- [Full rebuild before MAME](feedback_mame_rebuild.md) — rm .o + full rebuild first
- [Fresh BIOS+PROM before MAME](feedback_mame_fresh_build.md) — rebuild both
- [Run MAME at full speed](feedback_mame_full_speed.md) — `-nothrottle` in unattended tests
- **[MAME windowed only](feedback_mame_windowed_only.md) — HARD: always `-window`, never fullscreen**
- **[Headless host = no MAME window](feedback_host_no_graphics.md) — HARD: on sonnyboy use `SDL_VIDEODRIVER=dummy` (or xvfb-run); snapshots/AVI still work**
- [MAME interactive timeout](feedback_mame_interactive_timeout.md) — ~30s Bash timeout suffices
- [Lua no port reads](feedback_lua_no_port_reads.md) — use install_read_tap; double reads break devices
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

## 9. Code & source style

- **[Clarity in C code](feedback_clarity_in_c_code.md) — HARD: readable call shapes; compiler glue confined to hal.h/intrinsic.h, never #ifdef in business logic**
- [Size over speed for cold paths](feedback_size_over_speed_for_cold_paths.md) — cold code: bytes are permanent, T-states aren't
- [Volatile blocks loop idiom](feedback_volatile_blocks_loop_idiom.md) — volatile only for ISR-shared or hardware-changing memory
- [No self-correction in published docs](feedback_no_self_correction_in_published_docs.md) — narrate self-checks in chat; publish only the final version

## 10. Project facts — RC702 hardware

- [No RC700 HW mods](user_no_hw_mods.md) — no PCB modifications; cables/external devices OK
- **[2 KB PROM hard limit](project_rc702_2kb_prom_hard_limit.md) — HARD: no A11 bridge; PROM0+PROM1 capped at 2048 B each; never propose "close A11"/"use 2732"**
- [SIO-A fast TX, no fast RX](project_sioa_tx_only_fast.md) — 614 kbaud TX verified; fast RX impossible (no DPLL)
- [Two Picos available](project_pico_count.md) — one on cbl923 keyboard rig, second for J3 CP/NET bridge

## 11. Project facts — cpnos / cpnet / DRI

- **[Long-term goal: finish rcbios + autoload-in-c + CP/NET + cpnos](project_finishing_firmware_components.md) — bias work toward measurably advancing one of the four**
- **[cpnos PARKED — awaiting physical parallel cable](project_cpnos_parked_awaiting_parallel_cable.md) — surface before acting on cpnos/PIO/polypascal tasks; unpark on user signal**
- **[SEM702 chip-photo request](project_sem702_request_chip_photo.md) — when the RC702 is open, ask for photos of the piggyback boards (ic82 + under ic68)**
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

- [User Profile](user_profile.md) — experienced dev, Z80/LLVM/SDCC, CLion, Docker, no brew
- [Host: sonnyboy](reference_host_sonnyboy.md) — Ubuntu 26.04 x86_64, `/home/ravn/z80`, headless, gh authed, upstream LLVM at `~/llvm-upstream/llvm-project`
- [Safari breaks claude login callback](reference_claude_login_safari_workaround.md) — use ANTHROPIC_API_KEY or non-Safari default browser
- [HiTech zc Docker image](reference_hitech_zc_docker.md) — `ghcr.io/ravn/hitech` provides `zc`
- [simavr master required for .mmcu console](reference_simavr_master_required.md) — distro 1.6 is too old; build master in Docker
- [Memory in tasks/memory/, never ~/.claude/](feedback_no_claude_memory.md) — canonical here, read manually at session start

<!-- For project info that lives in the repo (not memory) — goal, TODOs, docs, MAME, PROM specs — see the "What's NOT in memory" map in README.md. -->
