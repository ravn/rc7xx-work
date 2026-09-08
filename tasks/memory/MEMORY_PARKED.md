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
- [llvmz80 clib speed benchmark](reference_llvmz80_clib_speed_benchmark.md) — classic qsort faster, newlib sprintf faster; full: tasks/benchmarks/
- [newlib signed % fix](reference_newlib_signed_mod_z88dk_bug.md) — stale-prebuilt-lib bug; FIXED 2026-07-24 by rebuild
- [newlib IEEE-754 %f printf fix](reference_llvmz80_newlib_ieee_printf_fix.md) — -D__LLVMZ80_IEEE_PRINTF; split __mulsi3; per-clib shim; __ZXNEXT trap
- [newlib remaining gaps](reference_newlib_remaining_gaps_file_printf.md) — #34 FILE* WONTFIX; #37 libm WONTFIX; #35 %f FIXED
- [llvmz80 qsort/strerror/bsearch classic fix](reference_llvmz80_qsort_strerror_classic_fix.md) — reversed-arg-alias-via-asm-label; __smallc comparator
- [newlib sdcc_iy uses ix archive](reference_newlib_sdcc_iy_uses_ix_archive.md) — -clib=sdcc_iy links sdcc_ix workers; IX callee-saved; audit result: OK
- [newlib integer helper gap closed](reference_newlib_integer_helper_gap.md) — llvmz80_imath.lib provides __mulhi3/__divsi3 etc; qsort/intdiv/long PASS
- [z88dk lib rebuild is native](reference_z88dk_lib_toolchain_native.md) — bin/z88dk-{sccz80,zsdcc,z80asm} native arm64; make -C libsrc TARGETS=...
- [TODO: zsdcc issues check upstream SDCC](todo_zsdcc_issues_check_upstream_sdcc.md) — 8 open ravn/z88dk bugs are upstream-SDCC problems; report upstream later
- [Session handoff 2026-08-07](project_session_handoff_2026-08-07.md) — stale; archived
- [RC702 mame fork reconciled 2026-08-07](project_rc702_mame_fork_reconciled_2026-08-07.md) — stale; archived
- [llvmz80 bdos() pointer-arg scramble](reference_llvmz80_bdos_pointer_arg_scramble.md) — FIXED ravn/z88dk#52; guard issue52_bdos_ptr_abi
- [Safari breaks claude login](reference_claude_login_safari_workaround.md) — use ANTHROPIC_API_KEY or non-Safari browser
- [copt is 32-bit-int engine](reference_copt_32bit_eval.md) — copt %eval is 32-bit; CANNOT split 64-bit .quad (verified 2026-08-05)
- [RC703 TFj BIOS oracle](reference_rc703_tfj_bios_oracle.md) — datamuseum Bits:30003297; byte-level oracle for rcbios
- [z88dk RC700 wiki TODO](reference_z88dk_rc700_wiki.md) — update z88dk/wiki/Platform-Regnecentralen-RC700; trigger ved upstream PR
