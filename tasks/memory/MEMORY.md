<!-- CANONICAL: tasks/memory/MEMORY.md. Read at session start (CLAUDE.md §Memory).
     Separate files: MEMORY_LAYOUT.md (§3), MEMORY_CODEGEN.md (§5), MEMORY_PARKED.md (RC759/one-offs).
     Hard limit: ~180 lines. Every entry ≤130 chars. Never write to ~/.claude/. -->

## 0. ABSOLUTE BAN — read before EVERY find/ls/grep/glob/mdfind

- **[NEVER traverse outside workspace root](feedback_no_home_search.md) — ABSOLUTE. Root: `/Users/ravn/z80/` (mac) `/home/ravn/z80/` (sonnyboy). No find/ls/mdfind outside.**

## 1. Always-on (every response)

- **[Check memory BEFORE coding](feedback_check_memory_before_coding.md) — HARD: scan MEMORY.md, READ linked files, NAME rules in first response, THEN code**
- **[MEMORY.md size check](feedback_memory_size_check.md) — HARD: if read shows "Truncated … of N total" with N>210, flag to user immediately**
- **[Revalidate historical compiler claims](feedback_revalidate_historical_compiler_claims.md) — HARD: re-run before acting on any historical size/speed/miscompile claim**
- **[Rebuild ALL Z80 tools after backend edit](feedback_rebuild_all_z80_tools.md) — HARD: `ninja -C build-macos clang llc lld` after any Z80/ edit**
- **[No-op control measurement](feedback_no_op_control_measurement.md) — HARD: baseline/no-op-control/feature-ON three cells; no-op must match baseline**
- **[Token-efficiency](feedback_token_efficiency.md) — HARD: no raw logs in context; long builds in background; handoff file at boundaries**
- **[Style](feedback_style.md) — tænk højt, ingen undskyldninger eller komplimenter, ingen aforismer, record prompts**
- [Suggest model switch](feedback_suggest_model_switch.md) — flag Opus/Sonnet fit before and mid-task
- **[Fix as close to the source as possible](reference_quad_init_backend_split.md) — HARD: fix in earliest/owning layer; never downstream band-aid**
- **[Session-break phrasing](feedback_session_break_phrasing.md) — HARD: say exactly "This is a good place to start a new session."**
- **[Show thinking — TIERED](feedback_show_thinking.md) — HARD: full narration at decisions/forks/surprises; one-liners in mechanical loops**
- **[Dig one level deeper before parking](feedback_dig_deeper_before_parking.md) — HARD: instrument + bisect 30 min before declaring deferred**
- **[Minimal repro BEFORE source dive](feedback_minimal_repro_before_source_dive.md) — HARD: 30s repro first; no "suggested fix" in filed issues without repro proof**
- **[Zoom out on recurring pattern](feedback_zoom_out_on_recurring_pattern.md) — HARD: after 2-3 fixes of one class, find the systemic cause unprompted**
- **[Audit the oracle](feedback_audit_oracle_not_just_fix.md) — HARD: bug found by luck -> build the detector that would have caught it**
- **[Verify process state by full enumeration](feedback_verify_process_state_full_enumeration.md) — HARD: never claim "clean" from ps|grep; enumerate fully**
- [No Unicode arrows](feedback_no_unicode_arrows.md) — ASCII `->` not `→`
- **[NEVER unquoted === in shell](feedback_no_double_equals.md) — HARD: zsh silently truncates; use `---` as separator**
- **[State certainty](feedback_state_certainty.md) — HARD: fact only if verified this session; surface ALL doubt**
- [Ask about design decisions](feedback_ask_about_design_decisions.md) — at non-obvious forks, lay options out
- **[Replicate user's PR text verbatim](feedback_replicate_user_pr_text_verbatim.md) — HARD: copy revised body 1:1 when opening upstream twin**
- **[Verify machine-specific facts before concluding](feedback_verify_machine_specific_before_concluding.md) — HARD: read OWN authoritative memory map FIRST**
- **[Probe must not consume the resource](feedback_probe_must_not_consume_resource.md) — HARD: health-check that grabs single-use connection corrupts what it verifies**

## 1b. Multi-agent

- **[Mistral Vibe agent](agent_mistralvibe_introduction.md) — capability profile + integration with Claude Code and Copilot**
- **[Mistral Vibe project understanding](agent_mistralvibe_project_understanding.md) — technical baseline, status matrix, known issues, roadmap**
- [RC750 Partner MAME boot](project_rc750_partner_boot_bringup.md) — ROD398/399 interleave; readable text DONE; 82730 mailbox DONE; NEXT: WD1797 floppy @0x200
- [MAME loose-branch inventory](reference_mame_loose_branches.md) — rc759+rc750 merged; only unmerged = RC702 upstreaming line
- [rc7xx MAME boot disks](reference_rc7xx_mame_boot_disks.md) — rc702=SW1711-I8.imd; rc750=SW1500_2.0.imd; rc759=sw1400_r31a_d1.img

## 2. Before any commit / PR / issue

- **[Never create UNSOLICITED PRs](feedback_no_pull_requests.md) — HARD: no gh pr create unless asked this turn**
- **[Explain before filing](feedback_explain_before_filing.md) — HARD: root cause in chat + explicit per-filing go-ahead; check for duplicates first**
- **[Self-caused bug? reflect](feedback_self_caused_bug_reflect_on_instructions.md) — HARD: if Co-Authored-By: anybody, identify which rule would have prevented it**
- **[File bugs, not fixes](feedback_file_bugs_not_fixes.md) — HARD: upstream filings are BUG REPORTS only; maintainer decides how to fix**
- **[Thorough tests for upstream bugs](feedback_thorough_tests_for_upstream_bugs.md) — HARD: matrix-grade (lit+runtime, negatives+positives+controls)**
- **[Cross-machine workflow](feedback_cross_machine_workflow.md) — HARD: commit-push at end of every working segment; pull-with-submodules at start**
- **[ravn/llvm-z80 Actions OFF](feedback_ravn_llvm_z80_ci_disabled.md) — HARD: no CI on ravn/llvm-z80; local oracle is the merge gate**
- **[No commit on lit+size alone](feedback_no_commit_first_version.md) — HARD: value oracle (test-runner + MAME) required before commit**
- **[Consult rules before acting](feedback_consult_rules_before_acting.md) — HARD: search MEMORY.md before any fix; commit message includes Rules-checked:**
- **[Grep repo docs before deriving](feedback_grep_repo_docs_before_deriving.md) — HARD: grep for *_REFERENCE.md before re-deriving encodings**
- [No UNSOLICITED Upstream Issues](feedback_no_upstream_issues.md) — default: file in ravn/* forks; curated submissions only on user direction
- **[No external issues ever](feedback_no_external_issues.md) — HARD: external repos require explicit per-issue go-ahead**
- [Upstream tracking issues](project_upstream_tracking_issues.md) — ravn/z88dk #64-68 + ravn/llvm-z80 #291-295 oprettet 2026-09-06
- **[PR #40 fallout — 4 åbne regressioner](project_pr40_fallout_2026_09_10.md) — builtins+memset.pattern ulegaliseret, IY-flag omdøbt, 32 lit FAIL; plan i llvm-z80/tasks/plan-pr40-fallout-recovery-2026-09-10.md**
- **[Upstream routing](feedback_upstream_routing_two_targets.md) — HARD: generic-LLVM bugs -> llvm/llvm-project; Z80-specific -> llvm-z80/llvm-z80 only**
- **[MAME upstream routing](feedback_mame_upstream_routing.md) — HARD: never file in MAME without explicit per-issue permission**
- **[No upstream sdcccall discrepancies](feedback_no_upstream_sdcccall_discrepancies.md) — HARD: ABI mismatches are known build-config issues, NOT upstream-fileable**
- [File dep bugs in ravn/* forks](feedback_file_issues_in_forks.md) — with repro + test case
- [Always test compiler bugs](feedback_compiler_bug_test.md) — XFAIL lit test for every clang Z80 codegen bug
- [Attribution line on filed issues](feedback_issue_attribution_line.md) — append `--- / _Filed by GitHub Copilot on behalf of @ravn._`
- **[Never mention zlfn in ravn's repos](feedback_never_mention_zlfn.md) — HARD: never write "zlfn"/@zlfn in any of ravn's repos; use "the fork owner"**
- [Comment on issue when fix committed](feedback_issue_comment_on_fix.md) — AUTO: post comment with hash + what changed + verification
- [Test before fix](feedback_test_before_fix.md) — failing test before implementing
- [Plan thoroughly first](feedback_plan_thoroughly_first.md) — explicit step-by-step plan + confirm before non-trivial work

## 3. Memory layout / linker / address changes

**-> Read [MEMORY_LAYOUT.md](MEMORY_LAYOUT.md) before any linker/BSS/address change**

## 4. Before any build / compile / link flag change

- **[+static-stack only for non-recursive code](feedback_static_stack_nonrecursive_only.md) — HARD: non-reentrant, SILENTLY miscompiles recursion**
- **[Check sibling subprojects](feedback_check_sibling_subprojects.md) — HARD: grep siblings for the same flag, mirror their wrapping**
- **[Symmetric recipes per compiler](feedback_symmetric_recipes_per_compiler.md) — HARD: parallel ifeq COMPILER recipes must emit the SAME artifact set**
- **[llvmz80 runtime-test gotchas](feedback_llvmz80_runtime_test_gotchas.md) — use -Cg-O2; verify const data in SHELL; build against classic not newlib**
- **[Use --math32 for llvmz80 float builds](feedback_use_math32_flag.md) — HARD: literal --math32 flag; auto-links fmath bridge + -mllvm -z80-float-sdcccall0**
- [Z80 tool paths](reference_z80_tool_paths.md) — full paths + canonical invocations; native llc/clang in llvm-z80/build-macos/bin
- **[Record macOS utility surprises](feedback_record_macos_utility_surprises.md) — HARD: BSD vs GNU; save memory note + workaround**
- **[Don't kill ninja mid-build](feedback_dont_kill_ninja.md) — HARD: SIGKILL truncates .ninja_log -> 1700+ step rebuild; Ctrl-C ONCE**
- **[Ninja clang+llc together](feedback_ninja_clang_llc_together.md) — HARD: after backend change, `ninja clang llc` BOTH**
- **[Docker shim batch](feedback_docker_shim_batch.md) — HARD: batch multi-step Docker calls into ONE docker run sh -c "..."**
- **[zmac local labels are global](feedback_zmac_local_label_scope.md) — HARD: dotted locals collide across subroutines; prefix with initials**
- **[Verify CMake fixes with compile_commands](feedback_verify_cmake_fixes.md) — HARD: cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON + confirm actual -I flags**

## 5. llvm-z80 compiler / codegen changes

**-> Read [MEMORY_CODEGEN.md](MEMORY_CODEGEN.md) before any compiler/codegen/ABI change**

## 6. Before any MAME / boot / test run

- **[rc759 CCP/M boots ~290s](reference_rc759_mame_c_verification.md) — HARD: -seconds_to_run 400; read LATE snapshot; early test banner = mid-boot not crash**
- **[Verify banner timestamp before trust](feedback_check_banner_timestamp.md) — HARD: banner timestamp vs BUILD_INFO_STR before any diagnosis**
- **[Polypascal stage-1/2 flake = MP/M daemon state](feedback_polypascal_stage1_flake.md) — first try make _kill-mpm; sleep 5-8; retry**
- **[cpnos PIO netboot: NO -autoboot_script](feedback_cpnos_pio_netboot_no_autoboot.md) — HARD: any autoboot breaks wall-clock-coupled PIO netboot**
- **[mpm-net2 weirdness: stop+rebuild+restart first](feedback_mpm_server_first_fix.md) — HARD: ANY unexpected mp/m behavior -> stop, rebuild, restart, retry BEFORE theorizing**
- **[Session-start: kill daemons BEFORE first test](feedback_session_start_kill_daemons.md) — HARD: make -C cpnos-in-c _kill-mpm; sleep 8 before first run**
- **[Screenshot to verify](feedback_screenshot_to_verify.md) — HARD: capture MAME screenshot; PASS lines alone are NOT enough**
- **[Visual capture for display path changes](feedback_visual_capture_for_display.md) — HARD: CRT/DMA/8275/display BSS changes need multi-frame video verification**
- **[Black screen is fatal](feedback_black_screen_fatal.md) — HARD: halts all other investigation**
- **[MAME always windowed + timeout](feedback_mame_always_window_timeout.md) — HARD: every launch needs -window AND finite -seconds_to_run N**
- **[Never concurrent builds, never kill a build](feedback_never_concurrent_or_kill_builds.md) — HARD: one ninja/make at a time; never pkill a build**
- **[Disable MAME audio in ALL tests](feedback_disable_audio_in_tests.md) — HARD: -sound none; CoreAudio causes SIGPIPE under background load**
- **[Headless host = no MAME window](feedback_host_no_graphics.md) — HARD: on sonnyboy use SDL_VIDEODRIVER=dummy**
- **[Display address from DMA, never hardcode](feedback_display_addr_from_dma.md) — HARD: read base from Am9517A DMA ch2**
- **[Lua errors are fatal](feedback_lua_errors_fatal.md) — HARD: any [LUA ERROR] invalidates the run; fix lua, re-run, THEN interpret**

## 7. Before file/script ops

- **[NEVER traverse outside workspace root](feedback_no_home_search.md) — see §0; ABSOLUTE**
- **[cpmtools at ~/.local/bin](reference_rc759_mame_c_verification.md) — invoke by full path; reads diskdefs from CURRENT DIR (DISKDEFS env IGNORED)**
- **[No stale dump files](feedback_no_stale_dump_files.md) — HARD: rm -f artifact BEFORE producer, every iteration**
- **[No DOTALL backtracking on source](feedback_no_dotall_backtracking.md) — HARD: no re.DOTALL + non-greedy over multi-line source; kill scans >10s**

## 8. Test / debug discipline

- **[Boundary codegen needs a runtime fixture](feedback_boundary_codegen_needs_runtime_fixture.md) — HARD: switch/range-check/off-by-one codegen ships a RUNTIME FIXTURE; lit alone insufficient**
- **[Outlier-first, not sweep](feedback_outlier_first_not_sweep.md) — HARD: dig >=1.5x/>=50 B divergences; don't touch every difference**
- **[Verify matrix before theory](feedback_verify_matrix_before_theory.md) — HARD: contradictory cell pattern = stale state; clean + re-verify anchors first**
- **[Compilers agree means harness](feedback_compilers_agree_means_harness.md) — HARD: identical failure on both compilers -> suspect harness/wiring first**
- **[Compare total section sizes](feedback_compare_total_section_sizes.md) — HARD: sum .text+.rodata+.data; per-function .text hides jumptables**
- **[No mental arithmetic in fixtures](feedback_no_mental_arithmetic_in_fixtures.md) — HARD: tool or trivial math only for expected values**
- **[Diff binaries before blaming codegen](feedback_diff_binaries_before_blaming_codegen.md) — HARD: cmp -l FIRST; byte-identical = environmental**
- **[Verify writes before chasing reads](feedback_verify_writes_before_chasing_reads.md) — HARD: instrument around the store first**
- **[A/B before blaming test-runner](feedback_ab_before_blaming_test_runner.md) — HARD: stash + rebuild + rerun baseline; test_90/91 edge_*_O1 known noise**
- **[Baseline before implementing](feedback_baseline_before_implementing.md) — HARD: capture control measurement on UNMODIFIED system first**
- **[Extract rules from time-sinks](feedback_extract_rules_from_time_sinks.md) — HARD: after long debug sessions, propose new memory rules proactively**
- **[Multi-pass marker interactions](feedback_multi_pass_marker_interactions.md) — HARD: -print-after-all when optimization "should fire" but doesn't**
- **[ticks canonical exit = ED FE trap](reference_ticks_canonical_exit_trap.md) — HARD: ED FE syscall (A=CMD_EXIT, L=code); -output bypassed**

## 9. Code & source style

- **[Clarity in C code](feedback_clarity_in_c_code.md) — HARD: readable call shapes; compiler glue confined to hal.h/intrinsic.h**
- [Size over speed for cold paths](feedback_size_over_speed_for_cold_paths.md) — bytes are permanent, T-states aren't

## 10. RC702 hardware facts

- **[RC700 family + PROM inventory](reference_rc700_family_proms.md) — RC701/702/703; target RC702/ROA375; RC701 has DIFFERENT ports + NO semigraphics**
- **[2 KB PROM hard limit](project_rc702_2kb_prom_hard_limit.md) — HARD: no A11 bridge; PROM0+PROM1 capped at 2048 B each**
- **[User's RC702 HAS SEM702](project_user_rc702_has_sem702.md) — define_sextants() essential (~79 ms); don't gate/remove it**
- [rcbios CP/NET PIO polypascal PASS](project_rcbios_cpnet_pio_race_parked.md) — FIXED: z80pio 2eb88cea + snios RECVBY_PIO timeout; #13 upstream candidate

## 11. cpnos / cpnet / DRI facts

- **[Long-term goal: finish rcbios + autoload + CP/NET + cpnos](project_finishing_firmware_components.md) — bias work toward advancing one of the four**
- **[cpnos PARKED — awaiting physical parallel cable](project_cpnos_parked_awaiting_parallel_cable.md) — surface before acting on cpnos/PIO/polypascal tasks**
- **[MP/M disks: local-only, library frozen](project_mpm_disks_local_only.md) — make mpm-disks builds into disks/local/; NEVER write disks/library/**
- **[SDCC slave stack-room ceiling](project_sdcc_slave_stack_room.md) — cpnos SDCC PROM1 must end <=0xF60E or SP=0xF680 overruns resident SNIOS**
- **[Never push/merge upstream remotes](feedback_never_push_or_merge_upstream_remotes.md) — HARD: cpnet-z80 origin is durgadas311/*; keep local commits FLAT**
- **[CP/NET 1.2 only](feedback_cpnet_12_only.md) — HARD: BDOS-105 NOT forwardable under 1.2; time-from-master via BDOS-66/67+FN-105**
- **[rcbios jump table is ABI](feedback_rcbios_jump_table_is_abi.md) — HARD: BIOS jump table at 0xDA00 is frozen ABI; new paths ADDITIVE only**
- **[rcbios -flto: section-attrs required](feedback_rcbios_no_lto_boot_placement.md) — was ON+working 2026-07-06 (section attrs+KEEP+ASSERTs); RE-DISABLED 2026-09-10 due to codegen crashes (ravn/llvm-z80#312: Z80DanglingDebugCleanup on -g + addrspace(2) cannot-select), NOT boot-placement**
- [MP/M II bakes RSPs at GENSYS time](reference_mpm_sys_baked_via_gensys.md) — .RSP edits inert until GENSYS regens MPM.SYS + re-installs on A:
- [ravn/mame#6 — PIO-B slot regression](project_ravn_mame_6.md) — gates Option P; fix needed at chip/slot layer

## 12. Reference / standing reminders

- **[Canonical test aggregator](reference_run_all_tests.md) — tasks/tools/run-all-tests.sh; fast=A+C+D; run at merge/checkpoint**
- **[z88dk llvmz80 evaluation doc](reference_z88dk_evaluation_doc.md) — tasks/z88dk-llvmz80-evaluation-2026-07-21.md; update after bridge/benchmark/float change**
- **[64-bit .quad split in backend](reference_quad_init_backend_split.md) — ravn/z88dk#27 FIXED: Data64bitsDirective=nullptr -> two .long; textual -S only**
- **[Standing goal: z88dk full llvmz80 CP/M support](project_z88dk_llvmz80_full_support_goal.md) — prioritize closing evaluation-doc gaps + modern-C support**
- [User Profile](user_profile.md) — experienced dev, Z80/LLVM/SDCC, CLion, Docker, no brew
- [Host: sonnyboy](reference_host_sonnyboy.md) — Ubuntu 26.04 x86_64, /home/ravn/z80, headless; upstream LLVM at ~/llvm-upstream/
- [Memory lives in tasks/memory/](feedback_no_claude_memory.md) — canonical here; NEVER ~/.claude/; also MEMORY_LAYOUT.md + MEMORY_CODEGEN.md + MEMORY_PARKED.md
- **[Fingerprint build after 2 no-change edits](feedback_fingerprint_build_after_two_no_change_edits.md) — HARD: add undeniable marker + prove new bytes run before edit #3**
- [z88dk#3022 console-lost-after-fopen](project_z88dk_3022_console_after_fopen_bug.md) — newlib fopen corrupts stdout; maintainer-confirmed; PR #3031 open
- [z88dk#3011 FP-under-interrupt EXX collision](reference_z88dk_3011_fp_interrupt_exx.md) — math48 uses EXX; shadow-set ISR -> corrupt; DI/EI around FP call
- [z88dk runtime verify: ntvcm not ticks](reference_z88dk_runtime_verify_ntvcm.md) — +cpm .COM under ntvcm/ntvcm; z88dk-ticks does NOT emulate +test $ED$FE trap
- [z88dk RC700 subtype build](reference_z88dk_rc700_subtype_build.md) — make -C libsrc TARGETS=rc700; -Cz+cpmdisk -f rc700-8dd; examples/rc700/

<!-- Parked / RC759 / CP/M-86 / one-offs -> MEMORY_PARKED.md -->
