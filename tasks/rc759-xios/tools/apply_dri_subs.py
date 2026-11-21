#!/usr/bin/env python3
"""
Derive semantic names for sub_XXXXX in Modules 1, 2, and 3 from DRI CCP/M 3.1 sources.
Verifies byte-identical reassembly.
"""

import re
import subprocess

ASM_PATH = "tasks/rc759-xios/ccpm.asm"

# Mappings derived from DRI CCP/M 3.1 source analysis:
# Module 2 (MEM) - matched against CPMMEM.MEM, MEMORY.MEM, MAU.MEM, ML.MEM, UTIL.MEM, SHARE.MEM
MEM_MAPPINGS = {
    0x028BC: "mem_free_memory",       # CPMMEM.MEM: free_memory (called by cpmfree_entry)
    0x02AE0: "mem_try_mau",           # MEMORY.MEM: check/try MAU allocation (currmpb @ 0x666)
    0x02B57: "mem_take_scl",          # MEMORY.MEM: take shared process off SCL
    0x02C30: "mem_free_mau_call",     # MEMORY.MEM: call f_maufree (0x030A)
    0x02E4A: "mem_mau_split",         # MAU.MEM: mau_split (split SAT entry into 2)
    0x02E72: "mem_mau_collapse",      # MAU.MEM: mau_collapse (collapse adjacent free SATs)
    0x02F0A: "mem_mau_release",       # MAU.MEM: mau_release (release SAT entry)
    0x02F34: "mem_mau_insert",        # MAU.MEM: mau_insert (insert new SAT entry)
    0x02FA5: "mem_mla_value",         # ML.MEM: mla_value (calculate best-fit score for MD)
    0x0310B: "mem_ml_insert",         # ML.MEM: ml_insert (insert MD into sorted memory list)
    0x03125: "mem_getmd",             # UTIL.MEM: getmd (allocate MD from mdul @ 0x58)
    0x03148: "mem_freemd",            # UTIL.MEM: freemd (free MD back to mdul @ 0x58)
}

# Module 3 (CIO) - matched against CHARIO.CIO, CONSOLE.CIO, CIOIF.CIO
CIO_MAPPINGS = {
    0x03270: "cio_xios_far_call",     # CIOIF.CIO: far call to XIOS via [cs:8]
    0x03276: "cio_xios_call",         # CIOIF.CIO: xios call via [0x28]
    0x03286: "cio_lcb_verify",        # CONSOLE.CIO: lcb_verify (verify list control block)
    0x032A2: "cio_ccb_verify",        # CONSOLE.CIO: ccb_verify (verify console control block)
    0x032EC: "cio_ciodetach",         # CONSOLE.CIO: ciodetach (detach device from process)
    0x03316: "cio_condetach_dev",     # CONSOLE.CIO: condetach_dev (detach console device)
    0x03414: "cio_wake_disp",         # CONSOLE.CIO: wake dispatcher / clear 0x652
    0x0342A: "cio_conassign_match",   # CONSOLE.CIO: conassign match PD on thread
    0x034A9: "cio_getccbadr",         # CONSOLE.CIO: getccbadr (get CCB for default console)
    0x034B0: "cio_getccbadr_spec",    # CONSOLE.CIO: getccbadr_spec (get CCB for specific console)
    0x034C7: "cio_getlcbadr",         # CONSOLE.CIO: getlcbadr (get LCB for list device)
    0x035CF: "cio_dirio_status",      # CHARIO.CIO: dirio status check
    0x03801: "cio_set_raw_mode",      # CHARIO.CIO: set raw console flag in PD
    0x0380C: "cio_clr_raw_mode",      # CHARIO.CIO: clear raw console flag in PD
    0x0382E: "cio_chk_ctrlp",         # CHARIO.CIO: chk_ctrlP (check printer echo / column)
    0x03864: "cio_conout",            # CHARIO.CIO: conout (console character output)
    0x038A4: "cio_chk_cmode",         # CHARIO.CIO: check console mode word
    0x038CE: "cio_ctlout",            # CHARIO.CIO: ctlout (display control char as ^X)
    0x038DD: "cio_tabout",            # CHARIO.CIO: tabout (expand tab to spaces)
    0x038F4: "cio_crlf",              # CHARIO.CIO: crlf (output CR + LF)
    0x03901: "cio_prcsmsg",           # CHARIO.CIO: prcsmsg (print '#' and CR+LF prompt)
    0x03919: "cio_constf",            # CHARIO.CIO: constf (console status function)
    0x03938: "cio_coninf",            # CHARIO.CIO: coninf (console input function)
    0x0395D: "cio_conout_sleep",      # CHARIO.CIO: conoutsleep (yield waiting for console)
    0x03974: "cio_conoutf",           # CHARIO.CIO: conoutf (console output function)
    0x03A3C: "cio_listf",             # CHARIO.CIO: listf (list character output)
    0x03A3F: "cio_goxios",            # CHARIO.CIO: goxios (dispatch call to XIOS)
}

# Module 1 (BDOS) - matched against BDOSIF.BDO, FILE1-5.BDO
BDOS_MAPPINGS = {
    0x016EC: "bdos1_far_call_user",    # BDOSIF: far call via [cs:8]
    0x016F2: "bdos1_userdisp_call",   # BDOSIF: userdisp far call
    0x01846: "bdos1_set_di_70",       # FILE: init DI with 0x70
    0x01870: "bdos1_check_dx",        # BDOSIF: test dx for null
    0x019C0: "bdos1_copy_fcb_words",  # FILE: compare & copy FCB words
    0x019D8: "bdos1_get_abs_para_30", # FILE: get absolute paragraph for 0x30
    0x01AA6: "bdos1_set_p_ready",     # BDOSIF: set p_stat = 0 (READY) in RLR
    0x01AB0: "bdos1_cli_chk_652",     # BDOSIF: cli and check flag 0x652
    0x01CB2: "bdos1_check_attr_20",   # FILE: check bit 0x20 in FCB attributes
    0x01F6E: "bdos1_open_close_setup",# FILE1: common setup for open/close file
    0x021D0: "bdos1_lock_disk_cli",   # FILE: enter critical disk section (CLI + sync)
    0x021DE: "bdos1_mxdisk_sync",     # FILE: sync on mxdisk queue (0x6FD)
    0x021EC: "bdos1_mxdisk_unsync",   # FILE: unsync on mxdisk queue (0x6FD)
    0x021FA: "bdos1_test_chain_head", # FILE: test chain head word
    0x02212: "bdos1_load_u_wrkseg_fcb",# FILE: load FCB from u_wrkseg (0x2E)
    0x02234: "bdos1_get_abs_para_1c", # FILE: get absolute paragraph for 0x1C
    0x022D2: "bdos1_calc_abs_para",   # FILE: calculate absolute paragraph (dx+bx+15)>>4
    0x02302: "bdos1_calc_record_offset",# FILE: calculate 32-bit disk byte offset
    0x02336: "bdos1_link_free_buffer",# FILE: link buffer into free chain
    0x02579: "bdos1_enqueue_head",    # FILE: atomic insert at head of list (0x6C)
    0x02587: "bdos1_zero_cx",         # FILE: clear cx helper
    0x0259A: "bdos1_init_di_70",      # FILE: clear cx and set di = 0x70
    0x025AC: "bdos1_load_si_di",      # FILE: load si from [di] and clear cx
    0x025D4: "bdos1_wake_next_process",# FILE: clear 0x652 and wake process on 0x6C
    0x025E4: "bdos1_check_disk_flags",# FILE: check disk flags bit 0x200
    0x0260A: "bdos1_load_rlr_si_74",  # FILE: load RLR into bx and si = 0x74
}

ALL_NEW_NAMES = {}
ALL_NEW_NAMES.update(MEM_MAPPINGS)
ALL_NEW_NAMES.update(CIO_MAPPINGS)
ALL_NEW_NAMES.update(BDOS_MAPPINGS)

print(f"Total new subroutine mappings to apply: {len(ALL_NEW_NAMES)}")
print(f"  Modul 1 (BDOS): {len(BDOS_MAPPINGS)}")
print(f"  Modul 2 (MEM):  {len(MEM_MAPPINGS)}")
print(f"  Modul 3 (CIO):  {len(CIO_MAPPINGS)}")

with open(ASM_PATH, "r") as f:
    text = f.read()

# Replace each sub_XXXXX with its semantic name
for off, new_name in ALL_NEW_NAMES.items():
    old_sub = f"sub_{off:05X}"
    # Replace label definitions: sub_XXXXX: -> new_name:
    text = re.sub(rf"\b{old_sub}\b", new_name, text)

with open("scratch/tmp/ccpm_semantic.asm", "w") as f:
    f.write(text)

print("Saved scratch/tmp/ccpm_semantic.asm. Verifying reassembly...")
