<!-- RC759 / CP/M-86 / Watcom / parked-project entries. NOT auto-loaded.
     Read manually when working on RC759, DR C, Open Watcom, or xcc. -->

## RC759 / CP/M-86 references

- [DRI C Programmer's Guide](reference_dri_cpm86_manuals_location.md) — DR C 1.11 ref already at cpm86-crossdev/docs/manuals/DRI_C_Programming_86.pdf
- [DR C float/8087 ABI](reference_drc_float_8087_abi.md) — no 8087 on RC759; double DX:CX:BX:AX, float BX:AX
- [wlink vs DR C OMF/.L86](reference_wlink_drc_omf_l86.md) — wlink reads OMF fine; rejects .L86 container (E2012); unpack_l86.py
- [CP/M-86 runtime RAM + wlink FARHEAP](reference_cpm86_runtime_memory_and_farheap.md) — BDOS 53-58; OPTION FARHEAP=<bytes> knob; farheap.c seam
- [CP/M-86 .CMD header + RC759 loader contract](reference_cpm86_cmd_header.md) — 128B header; small model DS=CS+code_paras; crt0 must NOT touch DS/ES
- [Watcom->DR C ABI bridge](reference_watcom_drc_abi_bridge.md) — RETIRED 2026-08-19; owcc -bcpm86 sole Watcom path; DR C = oracle only
- [DR C toolchain architecture](reference_drc_toolchain_architecture.md) — LINK86 = DR shared linker; pipeline: drc -b -> rasm86 -> link86
- [Official RC759 DR C v1.11 disk](reference_rc759_official_drc_disk.md) — datamuseum.dk Bits:30005869; diskdef rc759-drc; drc-oracle.sh
- [Watcom/Aztec interop RETIRED](reference_watcom_interop_retired_drc_oracle.md) — owc-drc BANNED; DR C = oracle only; never use owc-drc unless asked
- [RC759 i82730 CRT display + DDHF images](reference_rc759_i82730_display.md) — 916500 Hz clock; load_row consumes MAX DMA COUNT; ddhf-cache/bits/
- [OW Docker multi-arch](project_ow_docker_multiarch.md) — linux/amd64+arm64, alle 4 CP/M-86 modeller; bld/ cross-arch workaround
- [COMAL80 language manual](reference_comal80_manual.md) — RCSL 42-I-1758 Bits:30000018 Dec 1981; no CHAIN/EXTERNAL
- [xcc issue-filing process](xcc-issue-filing-process.md) — retro-vault/xyz issues DISABLED; file as PR from ravn/xyz fork
- [simavr master required](reference_simavr_master_required.md) — distro 1.6 too old; build master in Docker
- [emu2 TPA fidelity](reference_emu2_tpa_pool_fidelity.md) — emu2 default -m 210 > RC759 ~293 KB TPA; use -m 190 for byte-for-byte match
- [z88dk lib rebuild is native](reference_z88dk_lib_toolchain_native.md) — bin/z88dk-{sccz80,zsdcc,z80asm} native arm64; make -C libsrc TARGETS=...
- [TODO: zsdcc issues check upstream SDCC](todo_zsdcc_issues_check_upstream_sdcc.md) — 8 open ravn/z88dk bugs are upstream-SDCC problems; report upstream later
- [Session handoff 2026-08-07](project_session_handoff_2026-08-07.md) — stale; archived
- [RC702 mame fork reconciled 2026-08-07](project_rc702_mame_fork_reconciled_2026-08-07.md) — stale; archived
- [llvmz80 bdos() pointer-arg scramble](reference_llvmz80_bdos_pointer_arg_scramble.md) — FIXED ravn/z88dk#52; guard issue52_bdos_ptr_abi
- [Safari breaks claude login](reference_claude_login_safari_workaround.md) — use ANTHROPIC_API_KEY or non-Safari browser
- [copt is 32-bit-int engine](reference_copt_32bit_eval.md) — copt %eval is 32-bit; CANNOT split 64-bit .quad (verified 2026-08-05)
- [RC703 TFj BIOS oracle](reference_rc703_tfj_bios_oracle.md) — datamuseum Bits:30003297; byte-level oracle for rcbios
- [z88dk RC700 wiki TODO](reference_z88dk_rc700_wiki.md) — update z88dk/wiki/Platform-Regnecentralen-RC700; trigger ved upstream PR

## Parked project status & legacy references (archived from MEMORY.md)

- [PR #40 fallout](project_pr40_fallout_2026_09_10.md) — R1/R2/R4+inline-asm LØST; R5-drift = ingen regressioner. #316 static-frame analysis in llvm-z80
- [Upstream tracking issues](project_upstream_tracking_issues.md) — ravn/z88dk #64-68 + ravn/llvm-z80 #291-295 oprettet 2026-09-06 (#291 now upstreamed)
- [cpnos PARKED — awaiting physical parallel cable](project_cpnos_parked_awaiting_parallel_cable.md) — surface before acting on cpnos/PIO/polypascal tasks
- [RC750 Partner MAME boot](project_rc750_partner_boot_bringup.md) — ROD398/399 interleave; readable text DONE; 82730 mailbox DONE; NEXT: WD1797 floppy @0x200
- [MAME loose-branch inventory](reference_mame_loose_branches.md) — rc759+rc750 merged; only unmerged = RC702 upstreaming line
- [rc7xx MAME boot disks](reference_rc7xx_mame_boot_disks.md) — rc702=SW1711-I8.imd; rc750=SW1500_2.0.imd; rc759=sw1400_r31a_d1.img
- [rc759 CCP/M boots ~290s](reference_rc759_mame_c_verification.md) — HARD: -seconds_to_run 400; read LATE snapshot; early test banner = mid-boot not crash
- [MP/M disks: local-only, library frozen](project_mpm_disks_local_only.md) — make mpm-disks builds into disks/local/; NEVER write disks/library/
- [SDCC slave stack-room ceiling](project_sdcc_slave_stack_room.md) — cpnos SDCC PROM1 must end <=0xF60E or SP=0xF680 overruns resident SNIOS
- [MP/M II bakes RSPs at GENSYS time](reference_mpm_sys_baked_via_gensys.md) — .RSP edits inert until GENSYS regens MPM.SYS + re-installs on A:
- [ravn/mame#6 — PIO-B slot regression](project_ravn_mame_6.md) — gates Option P; fix needed at chip/slot layer
- [z88dk#3011 FP-under-interrupt EXX collision](reference_z88dk_3011_fp_interrupt_exx.md) — math48 uses EXX; shadow-set ISR -> corrupt; DI/EI around FP call
- [z88dk runtime verify: ntvcm not ticks](reference_z88dk_runtime_verify_ntvcm.md) — +cpm .COM under ntvcm/ntvcm; z88dk-ticks does NOT emulate +test $ED$FE trap
- [z88dk RC700 subtype build](reference_z88dk_rc700_subtype_build.md) — make -C libsrc TARGETS=rc700; -Cz+cpmdisk -f rc700-8dd; examples/rc700/

