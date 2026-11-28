#!/usr/bin/env python3
"""
gen_nasm.py — Producér byte-identisk NASM-kilde fra ccpm.sys

Strategi:
  1. Udvidet CFG-traversal fra alle kendte seeds → markerer code-bytes
  2. Code-regioner → NASM-mnemonics (Capstone Intel syntax → NASM syntax)
  3. Data-regioner → db-sekvenser
  4. Labels ved alle branch/call-targets

Output: ccpm.asm  (assemblér med: nasm -f bin -o ccpm_out.sys ccpm.asm)
"""

import capstone, sys, re
from collections import defaultdict

CCPM_IN  = "/Users/ravn/z80/scratch/tmp/ccpm.sys"
NASM_OUT = "/Users/ravn/z80/scratch/tmp/ccpm.asm"
FILE_SIZE = 77568

d  = open(CCPM_IN, "rb").read()
cs = capstone.Cs(capstone.CS_ARCH_X86, capstone.CS_MODE_16)
cs.detail = True

# ── Seeds ─────────────────────────────────────────────────────────────────────
SEEDS = [
    # Modul-entrypoints
    0x000FE, 0x002FA,
    0x0168B, 0x016E0,
    0x0270B, 0x02726,
    0x0322B, 0x03266,
    0x03B1C, 0x03BAD,
    # XIOS
    0x0B163, 0x0B169,
    # RTM
    0x0282, 0x0313,
    # XIOS inter-modul dispatch
    0x0B163+0x4F0A, 0x0B163+0x4F12,
    # XIOS-funktioner
    0x282C, 0x055B, 0x4F8C, 0x0881, 0x095C, 0x09B2,
    0x0A05, 0x0A6B, 0x0A6F, 0x0AFA,
    # RTM handlers
    0x8517, 0x851E, 0x7C97, 0x7E11, 0x85D3, 0x8A54, 0x8A95,
    # IO helpers
    0x2863, 0x2793, 0x0557,
    # FDC
    0x09D4E, 0x09E00, 0x09F06, 0x09F4D, 0x0A00B, 0x0A2BE, 0x0CB31,
    0x0AC27, 0x0AD64,
    # CRT
    0x0C08A, 0x07BFE, 0x09607, 0x0B9B7,
    # Tastatur
    0x07A99,
    # EOI helper
    0x0AF11,
    # Fra CRT-analyse
    0x09621, 0x0C43F, 0x0C468,
    # Fra fase 2.1 konsol
    0x0AD8E, 0x0B032,
    # Yderligere subs fundet under analyse
    0x078C0, 0x078D1, 0x078D3,
]

# ── CFG-traversal ──────────────────────────────────────────────────────────────
# code[offset] = True  → byte er bekræftet kode
code_bytes = bytearray(FILE_SIZE)
# insn_at[offset] = (mnemonic, op_str, bytes, size)
insn_at    = {}
# branch_targets: sæt af file-offsets der er branch/call-targets
branch_targets = set()
# callers: hvad der kalder hvad
visited = set()
queue   = list(set(s for s in SEEDS if 0 <= s < FILE_SIZE))

TERM_MNEMONICS = {"ret", "retf", "retn", "iret", "iretd", "iretw", "hlt"}

def enqueue(o):
    if 0 <= o < FILE_SIZE and o not in visited:
        queue.append(o)

while queue:
    off = queue.pop()
    if off in visited:
        continue
    visited.add(off)

    for insn in cs.disasm(d[off:off+16], off):
        sz = insn.size
        for i in range(sz):
            if off + i < FILE_SIZE:
                code_bytes[off + i] = 1
        insn_at[off] = (insn.mnemonic, insn.op_str, bytes(d[off:off+sz]), sz)

        mnem = insn.mnemonic.lower()
        ops  = insn.op_str

        # Udtræk branch-target fra call/jmp
        target = None
        if mnem in ("call", "jmp", "jmp short", "jmp near") or mnem.startswith("j"):
            m = re.search(r'0x([0-9a-f]+)', ops)
            if m:
                target = int(m.group(1), 16)
        elif mnem == "lcall":
            # far call — ikke direkte traceable på tværs af segment
            pass

        if target is not None and 0 <= target < FILE_SIZE:
            branch_targets.add(target)
            enqueue(target)

        # Fall-through for ikke-terminating, ikke-ubetinget jmp
        is_uncond_jmp = mnem in ("jmp", "jmp short", "jmp near", "ljmp")
        is_term       = mnem in TERM_MNEMONICS
        if not is_uncond_jmp and not is_term:
            enqueue(off + sz)
        break  # Capstone giver os ét insn ad gangen i denne loop

# Tilføj alle seeds som branch-targets (for at sikre labels)
for s in SEEDS:
    if s < FILE_SIZE:
        branch_targets.add(s)

# ── Linear sweep over hele filen (modul 0-4) ──────────────────────────────────
# Modul 0-3: primært kode — sweep finder dispatch-øer CFG ikke når.
# Modul 4 (XIOS+SYSDAT): ~62KB — sweep dækker XIOS-kode-regioner.
# SYSDAT-data-area (fil 0x6B20-0x7720) springes over via null-byte-filter
# og looks_like_code heuristikken (rå data-tabeller er ikke valid kode).
#
# Heuristik for valid kode: mindst 3 instruktioner uden invalid opcode + ingen
# for lange instruktioner (>7 bytes = typisk data-mismatch).
#
SWEEP_END = FILE_SIZE  # hele filen (modul 0-4)

INVALID_OPCODES = {0xD6, 0xF1}  # udefinerede i 8086/80186

def looks_like_code(start, min_insns=4, max_insn_size=7):
    """Returnér True hvis mindst min_insns valide instruktioner fra start."""
    count = 0
    off   = start
    while off < min(start + 64, SWEEP_END):
        insns = list(cs.disasm(d[off:off+10], off))
        if not insns:
            return False
        i = insns[0]
        if i.id == 0:              # capstone "invalid"
            return False
        if i.bytes[0] in INVALID_OPCODES:
            return False
        if i.size > max_insn_size:
            return False
        count += 1
        if count >= min_insns:
            return True
        off += i.size
    return count >= min_insns

# Beskyttede adresser (SEEDS): sweep må IKKE skabe instruktioner der overlapper disse
PROTECTED_ADDRS = set(s for s in SEEDS if 0 <= s < FILE_SIZE)

sweep_new = 0
off = 0x00FE  # start fra modul 0 kode-begyndelse
while off < SWEEP_END:
    if code_bytes[off]:          # allerede kortlagt af CFG
        off += 1
        continue
    if d[off] == 0x00:           # null-bytes er typisk data/padding
        off += 1
        continue
    if looks_like_code(off):
        # Kør mini-CFG fra dette offset
        mini_q = [off]
        while mini_q:
            cur = mini_q.pop()
            if cur in visited or cur >= SWEEP_END:
                continue
            visited.add(cur)
            for insn in cs.disasm(d[cur:cur+16], cur):
                sz = insn.size
                # Tjek om instruktionen overlapper en beskyttet adresse
                # Hvis ja: reducer til 1 byte (behandl som data)
                for i in range(1, sz):
                    if (cur + i) in PROTECTED_ADDRS or (cur + i) in insn_at:
                        sz = i  # stop FØR den beskyttede adresse
                        break
                if sz == 0:
                    sz = 1
                raw = bytes(d[cur:cur+sz])
                for i in range(sz):
                    if cur + i < FILE_SIZE:
                        code_bytes[cur + i] = 1
                if sz == insn.size:
                    insn_at[cur] = (insn.mnemonic, insn.op_str, raw, sz)
                else:
                    # Trunkeret — gem som data (ingen insn_at entry)
                    pass
                sweep_new += 1
                mnem = insn.mnemonic.lower()
                ops  = insn.op_str
                # Følg branches
                tgt  = None
                if mnem in ("call", "jmp") or mnem.startswith("j"):
                    import re as _re
                    m = _re.search(r'0x([0-9a-f]+)', ops)
                    if m:
                        tgt = int(m.group(1), 16)
                if tgt and 0 <= tgt < SWEEP_END and tgt not in visited:
                    branch_targets.add(tgt)
                    mini_q.append(tgt)
                is_term = mnem in TERM_MNEMONICS
                is_ujmp = mnem in ("jmp", "jmp short", "jmp near", "ljmp")
                if not is_term and not is_ujmp:
                    nxt = cur + sz
                    if nxt < SWEEP_END and nxt not in visited:
                        mini_q.append(nxt)
                break
        off += 1
    else:
        off += 1

print(f"Linear sweep: {sweep_new} nye instruktioner i modul 0-3")

# ── Labels ─────────────────────────────────────────────────────────────────────
KNOWN_LABELS = {
    0x078C0: "xios_rtm_flag_set",
    0x078D1: "xios_rtm_flag_wait",
    0x078DC: "xios_rtm_svc_call",
    0x07A99: "xios_kbd_isr",
    0x07BFE: "xios_crt_retrace_isr",
    0x09601: "xios_crt_trigger_ca",
    0x09D4E: "xios_fdc_fcr_setup",
    0x09E00: "xios_fdc_fcr_write",
    0x09E05: "xios_fdc_select_drive",
    0x09E48: "xios_fdc_restore_track0",
    0x09ECA: "xios_fdc_step_in",
    0x09EF3: "xios_fdc_cmd_read_sector",
    0x09F06: "xios_fdc_send_cmd",
    0x09F0E: "xios_fdc_read_track_reg",
    0x09F4D: "xios_fdc_wait",
    0x09F95: "xios_fdc_test_busy",
    0x0A0B0: "xios_fdc_send_cmd_wait",
    0x0A295: "xios_dma_chan_ctrl",
    0x0A29A: "xios_dma_mask_reg",
    0x0A2BE: "xios_fdc_isr",
    0x0AC27: "xios_floppy_ack",
    0x0AD64: "xios_floppy_status_check",
    0x0AD8E: "xios_con_status_poll",
    0x0AF11: "xios_eoi_pic_and_cpu",
    0x0AF1D: "xios_switch_to_priv_stack",
    0x0B032: "xios_con_data_read",
    0x016EC: "bdos1_far_call_user",
    0x016F2: "bdos1_userdisp_call",
    0x01846: "bdos1_set_di_70",
    0x01870: "bdos1_check_dx",
    0x019C0: "bdos1_copy_fcb_words",
    0x019D8: "bdos1_get_abs_para_30",
    0x01AA6: "bdos1_set_p_ready",
    0x01AB0: "bdos1_cli_chk_652",
    0x01CB2: "bdos1_check_attr_20",
    0x01F6E: "bdos1_open_close_setup",
    0x021D0: "bdos1_lock_disk_cli",
    0x021DE: "bdos1_mxdisk_sync",
    0x021EC: "bdos1_mxdisk_unsync",
    0x021FA: "bdos1_test_chain_head",
    0x02212: "bdos1_load_u_wrkseg_fcb",
    0x02234: "bdos1_get_abs_para_1c",
    0x022D2: "bdos1_calc_abs_para",
    0x02302: "bdos1_calc_record_offset",
    0x02336: "bdos1_link_free_buffer",
    0x02579: "bdos1_enqueue_head",
    0x02587: "bdos1_zero_cx",
    0x0259A: "bdos1_init_di_70",
    0x025AC: "bdos1_load_si_di",
    0x025D4: "bdos1_wake_next_process",
    0x025E4: "bdos1_check_disk_flags",
    0x0260A: "bdos1_load_rlr_si_74",
    0x028BC: "mem_free_memory",
    0x02AE0: "mem_try_mau",
    0x02B57: "mem_take_scl",
    0x02C30: "mem_free_mau_call",
    0x02E4A: "mem_mau_split",
    0x02E72: "mem_mau_collapse",
    0x02F0A: "mem_mau_release",
    0x02F34: "mem_mau_insert",
    0x02FA5: "mem_mla_value",
    0x0310B: "mem_ml_insert",
    0x03125: "mem_getmd",
    0x03148: "mem_freemd",
    0x03270: "cio_xios_far_call",
    0x03276: "cio_xios_call",
    0x03286: "cio_lcb_verify",
    0x032A2: "cio_ccb_verify",
    0x032EC: "cio_ciodetach",
    0x03316: "cio_condetach_dev",
    0x03414: "cio_wake_disp",
    0x0342A: "cio_conassign_match",
    0x034A9: "cio_getccbadr",
    0x034B0: "cio_getccbadr_spec",
    0x034C7: "cio_getlcbadr",
    0x035CF: "cio_dirio_status",
    0x03801: "cio_set_raw_mode",
    0x0380C: "cio_clr_raw_mode",
    0x0382E: "cio_chk_ctrlp",
    0x03864: "cio_conout",
    0x038A4: "cio_chk_cmode",
    0x038CE: "cio_ctlout",
    0x038DD: "cio_tabout",
    0x038F4: "cio_crlf",
    0x03901: "cio_prcsmsg",
    0x03919: "cio_constf",
    0x03938: "cio_coninf",
    0x0395D: "cio_conout_sleep",
    0x03974: "cio_conoutf",
    0x03A3C: "cio_listf",
    0x03A3F: "cio_goxios",
    0x000FE: "mod0_rtm_init",
    0x002FA: "mod0_rtm_entry",
    0x0168B: "mod1_bdos1_init",
    0x016AC: "bdos1_dispatch_table",
    0x016E0: "mod1_bdos1_entry",
    # Modul 1: BDOS (Filsystem / intern supervisor) — bekræftet via MAME dispatch-dump 2026-11-20
    0x016F9: "bdos1_fn01_queue_read",
    0x01709: "bdos1_fn11_delay",        # func 141: delay
    0x0171B: "bdos1_fn12_nop",          # nop / return 0
    0x01720: "bdos1_fn15_set_priority", # func 145: set priority
    0x0172C: "bdos1_fn16_get_pd",       # func 156: get process descriptor address
    0x01731: "bdos1_func24_get_dlog",   # func 24: get dlog bitmap
    0x01736: "bdos1_fn14_dispatch",     # func 142: dispatch process
    0x0173C: "bdos1_fn18_flag_wait",    # func 132: flag wait
    0x01753: "bdos1_fn19_flag_set",     # func 133: flag set
    0x0177B: "bdos1_fn21_sync",         # sync system
    0x0179A: "bdos1_fn22_unsync",       # unsync system
    0x017F2: "bdos1_fn23_poll_device",  # poll device
    0x01811: "bdos1_fn25_chain",        # chain
    0x01815: "bdos1_fn24_test_device",  # test device
    0x01B01: "bdos1_switch_stack",      # save SS:SP til ES:[0x1e/0x1c], skift til BDOS-stak
    0x01EC1: "bdos1_fn03_close_file",   # func 16: close file
    0x01F41: "bdos1_fn02_open_file",    # func 15: open file
    0x01F9C: "bdos1_fn04_search_first", # func 17: search first
    0x01FF2: "bdos1_fn05_search_next",  # func 18: search next
    0x02045: "bdos1_fn06_delete_make",  # func 19/22: delete/make file
    0x020AB: "bdos1_fn07_read_seq",     # func 20: read sequential
    0x020AF: "bdos1_fn08_read_rand",    # func 33: read random
    0x0213A: "bdos1_fn09_write_seq",    # func 21: write sequential
    0x0213E: "bdos1_fn10_write_rand",   # func 34: write random
    0x02368: "bdos1_fn20_flush_buffers",# func 48: flush buffers
    0x0239E: "bdos1_fn00_disk_reset",   # func 13: disk reset
    0x023A6: "bdos1_fn13_seldisk",      # func 14: select disk
    0x02455: "bdos1_fn17_time_of_day",  # func 155: time of day

    # Modul 2: MEM (Memory Management) — MEMIF.MEM (bekræftet via MAME dispatch-dump 2026-11-20)
    0x0270B: "mem_init",
    0x02726: "mem_entry",
    0x0274A: "mem_switch_stack",      # save SS:SP til [0x672/0x670], skift til MEM-stak
    0x02773: "mem_restore_stack",     # restore SS:SP fra [0x672/0x670] (goback MEM)
    0x02790: "mem_exit",              # exit: mov ax,bx; retf (MEMIF exit)
    0x0279E: "mem_fn00_maxmem",       # func 53: get max memory
    0x027CA: "mem_fn01_absmax",       # func 54: get abs max memory
    0x027F2: "mem_fn02_cpmalloc",     # func 55: alloc memory
    0x0281A: "mem_fn03_cpmabsa",      # func 56: alloc abs memory
    0x02880: "mem_fn04_cpmfree",      # func 57: free memory
    0x028CF: "mem_fn05_freeall",      # func 58: free all memory
    0x0292B: "mem_fn06_malloc",       # func 129: rel mem rqst
    0x02BA1: "mem_fn07_mfree",        # func 130: memory free
    0x02C93: "mem_fn08_share",        # share memory
    0x02D3A: "mem_fn09_maualloc",     # alloc from MAU
    0x02DEB: "mem_fn10_maufree",      # free from MAU
    0x02F60: "mem_fn11_mlalloc",      # alloc from mem list
    0x030DE: "mem_fn12_mlfree",       # free from mem list

    # Modul 3: CIO (Character I/O) — CIOIF.CIO (bekræftet via MAME dispatch-dump 2026-11-20)
    0x0322B: "cio_init",
    0x03266: "cio_entry",
    0x0327B: "cio_fn21_notimp",       # func 21/22: not implemented
    0x0327F: "cio_fn15_lstattach",    # func 158: attach list
    0x03283: "cio_fn18_clstattch",    # func 161: cond list attach
    0x0329B: "cio_fn09_conattach",    # func 146: attach console
    0x0329F: "cio_fn19_cconattch",    # func 162: cond list detach
    0x032E9: "cio_fn16_lstdetach",    # func 159: detach list
    0x03313: "cio_fn10_condetach",    # func 147: detach console
    0x03344: "cio_fn12_conassign",    # func 149: assign console
    0x03457: "cio_fn13_getdefcon",    # func 153: get default console
    0x03461: "cio_fn20_getdeflst",    # func 164: get default list
    0x0346B: "cio_fn11_setdefcon",    # func 148: set default console
    0x0348A: "cio_fn17_setdeflst",    # func 160: set default list
    0x034EC: "cio_fn23_cioterm",      # cleanup for termination
    0x03539: "cio_fn25_cmode",        # func 109: get/set console mode word
    0x0354B: "cio_fn00_conin",        # func 1: console input
    0x0355E: "cio_fn01_conout",       # func 2: console output
    0x0356E: "cio_fn02_rconin",       # func 3: raw console input
    0x03574: "cio_fn03_rconout",      # func 4: raw console output
    0x0357A: "cio_fn04_listout",      # func 5: list output
    0x0358E: "cio_fn08_constat",      # func 11: console status
    0x035B3: "cio_fn24_ciostat",      # check status w/out changing mode
    0x035DB: "cio_fn05_dirio",        # func 6: direct console I/O
    0x035F8: "cio_fn06_conwrite",     # func 9: print string
    0x03626: "cio_fn26_delim",        # func 110: get/set delimiter
    0x03637: "cio_fn27_pblock",       # func 111: print block
    0x03643: "cio_fn28_lblock",       # func 112: list block
    0x03690: "cio_fn14_conprint",     # print string (internal)
    0x036C6: "cio_fn07_conread",      # func 10: read buffer
    0x03B1C: "mod4_xios_init",
    0x03BAD: "mod4_xios_entry",
    0x0B163: "xios_jmp_init",
    0x0B166: "xios_jmp_entry",
    0x0B169: "xios_init",
    0x0B1EF: "xios_entry_0x8C",
    0x0282:  "rtm_core",
    0x0313:  "rtm_dispatcher",
    0x0B163+0x4F0A: "xios_imod_dispatch_shl",
    0x0B163+0x4F12: "xios_imod_dispatch_jmp",
    0x16A4:  "__xios_dispatch_table__",
    0x282C:  "io_const",
    0x055B:  "io_conin",
    0x4F8C:  "io_conout",
    0x0881:  "io_switch",
    0x095C:  "io_statline",
    0x09B2:  "io_seldsk",
    0x0A05:  "io_read",
    0x0A6B:  "io_write",
    0x0A6F:  "io_flushbuf",
    0x0AFA:  "io_polldev",
    0x8517:  "rtm_al80_poll_console",
    0x851E:  "rtm_al87_blocking_read",
    0x7C97:  "sub_7c97",
    0x7E11:  "sub_7e11",
    0x85D3:  "sub_85d3",
    0x8A54:  "sub_8a54",
    0x8A95:  "sub_8a95",
    0x2863:  "io_const_rtm_helper",
    0x2793:  "rtm_call_0x80_entry",
    0x0557:  "io_conin_rtm_helper",
    0x09D4E: "fdc_fcr_setup",
    0x09E00: "fdc_fcr_write",
    0x09F06: "fdc_send_cmd",
    0x09F4D: "fdc_wait",
    0x0A00B: "fdc_read_path",
    0x0A2BE: "fdc_isr",
    0x0CB31: "fdc_release",
    0x0AC27: "floppy_ack",
    0x0AD64: "floppy_status_check",
    0x0C08A: "fdc_dma_scroll_cmd",
    0x07BFE: "crt_init_irst_ca",
    0x09607: "crt_post_cmd_wait",
    0x0B9B7: "crt_mode_switch",
    0x07A99: "kbd_handler",
    0x0AF11: "eoi_helper",
    0x0AD8E: "con_status_poll",
    0x0B032: "con_data_read",
    0x078C0: "rtm_call_helper",
    0x078D1: "rtm_timer_wait",
    0x078D3: "rtm_timer_wait2",
}

def label_for(off):
    if off in KNOWN_LABELS:
        return KNOWN_LABELS[off]
    return f"L_{off:05X}"

# ── DRI struct-felt og SYSDAT-variable (fra PD.DEF + binær-analyse) ──────────
PD_FIELDS = {
    0x00: "p_link",   0x02: "p_thread", 0x04: "p_stat",    0x05: "p_prior",
    0x06: "p_flag",   0x08: "p_name",   0x10: "p_uda",     0x12: "p_dsk",
    0x13: "p_user",   0x14: "p_ldsk",   0x15: "p_luser",   0x16: "p_mem",
    0x18: "p_cmod",   0x19: "p_tkcnt",  0x1A: "p_wait",    0x1C: "p_org",
    0x1E: "p_parent", 0x20: "p_cns",    0x21: "p_abort",   0x22: "p_conmode",
    0x24: "p_lst",    0x26: "p_sflag",  0x28: "p_userdisp",0x2C: "p_pret",
    0x2E: "p_scratch",
}

# SYSDAT-variable: offset fra SYSDAT-segment-base (DS = 0x06FA i RTM)
# Fundet via binær-analyse + DRI kilde-kryds
SYSDAT_VARS = {
    0x002E: "rlr",       # Running List Root (4× MOV AX,[002E] i modul 0)
    0x0219: "indisp",    # In-dispatcher flag (9× CMP byte[0219], 0/1/0xFF)
    0x0006: "sysdat",    # CS:[6] = SYSDAT segment (rtm_dispatcher)
    0x00AA: "rtm_svc_tbl", # RTM service table (fra fase 1.1)
    0x5FA4: "crt_comp_flag", # CRT completion flag (crt_post_cmd_wait)
    0x5E42: "dpc_reserved",  # DPC reservation flag (fdc_release)
    0x376E: "fdc_wait_flag",  # FDC cooperative wait flag (fdc_wait)
    0x392F: "fdc_isr_save",   # FDC ISR saved state (fdc_isr)
    0x1040: "kbd_char",       # Tastatur: konverteret tegn (kbd_handler)
    0x1044: "kbd_scan",       # Tastatur: scancode (kbd_handler)
    0x10B1: "crt_init_ctr1",  # CRT init counter 1 (crt_init_irst_ca)
    0x10B2: "crt_init_ctr2",  # CRT init counter 2
    0x10B3: "crt_init_ctr3",  # CRT init counter 3
    0x2C45: "vram_seg",       # VRAM segment (crt_mode_switch)
    0x2C52: "kbd_xlat",       # Keyboard XLAT tabel (kbd_handler)
    0x6228: "charset_ptr",    # Charset far-pointer (crt_mode_switch)
}

def annotate_ops(ops):
    """Tilføj DRI-symbolnavne til register+offset og direkte memory-accesses."""
    # [bx + 0xNN] → p_field[bx]
    def pd_replace(m):
        reg = m.group(1)
        off = int(m.group(2), 16)
        name = PD_FIELDS.get(off)
        return f"{name}[{reg}]" if name else m.group(0)
    ops = re.sub(r'\[(bx|si|di|bp)\s*\+\s*(0x[0-9a-f]+)\]', pd_replace, ops)
    # Hjælpefunktion for direkte memory-accesses [0xNNNN]
    def sysdat_replace(m):
        off = int(m.group(1), 16)
        name = SYSDAT_VARS.get(off)
        return f"[{name}]" if name else m.group(0)
    ops = re.sub(r'\[(0x[0-9a-f]+)\]', sysdat_replace, ops)
    return ops

# ── NASM syntax-konvertering ───────────────────────────────────────────────────
# Capstone Intel syntax → NASM syntax

def fixup_nasm(mnem, ops, insn_bytes):
    """Konvertér Capstone Intel syntax til NASM-kompatibel syntax."""
    # Fjern 'ptr' keyword: 'byte ptr' → 'byte', 'word ptr' → 'word'
    ops = re.sub(r'\b(byte|word|dword|qword|tbyte)\s+ptr\b', r'\1', ops)

    # Segment-override: cs:[0xXX] → [cs:0xXX]
    ops = re.sub(r'(cs|ds|es|ss|fs|gs):\[', r'[\1:', ops)

    # String-instruktioner: fjern eksplicitte register-operander
    # Gælder også rep/repe/repne-præfikser (mnemonic indeholder præfiks)
    string_ops = {"stosw", "stosb", "lodsw", "lodsb", "movsw", "movsb",
                  "scasw", "scasb", "cmpsw", "cmpsb", "insw", "insb",
                  "outsw", "outsb"}
    mnem_base = re.sub(r'^(rep|repe|repne|repnz|repz)\s+', '', mnem.lower())
    if mnem_base in string_ops:
        ops = ""

    # lds/les/lss/lfs/lgs: fjern 'ptr' fra operander (ptr [mem] → [mem])
    if mnem.lower() in ("lds", "les", "lss", "lfs", "lgs"):
        ops = re.sub(r'\bptr\s+', '', ops)

    # pushaw/popaw → pusha/popa
    mnem_map = {
        "pushaw": "pusha", "popaw": "popa",
        "pushfw": "pushf", "popfw": "popf",
        "iretd": "iret",  "iretw": "iret",
        "retfw": "retf",
        "cbw": "cbw", "cwd": "cwd",
    }
    mnem = mnem_map.get(mnem.lower(), mnem)

    # lcall → call far, ljmp → jmp far
    if mnem.lower() == "lcall":
        mnem = "call"
        if not ops.startswith("far"):
            ops = "far " + ops
    elif mnem.lower() == "ljmp":
        mnem = "jmp"
        if not ops.startswith("far"):
            ops = "far " + ops

    # Short jumps: 2-byte EB encoding → tilføj 'short'
    if len(insn_bytes) == 2 and insn_bytes[0] == 0xEB:
        if mnem.lower() == "jmp" and "short" not in mnem.lower():
            mnem = "jmp short"

    # Ryd op i ops
    ops = ops.strip()
    return mnem, ops

def insn_to_nasm(off):
    """Returnér NASM-linje for instruktion ved offset, eller None."""
    if off not in insn_at:
        return None
    mnem, ops, raw, sz = insn_at[off]
    mnem, ops = fixup_nasm(mnem, ops, raw)
    if ops:
        return f"  {mnem} {ops}"
    else:
        return f"  {mnem}"

# ── NASM-kilde generator ───────────────────────────────────────────────────────

code_count = sum(1 for b in code_bytes if b)
print(f"Code bytes: {code_count} / {FILE_SIZE} ({100*code_count/FILE_SIZE:.1f}%)")
print(f"Instructions: {len(insn_at)}")
print(f"Branch targets: {len(branch_targets)}")

out = []
out.append("; ccpm.sys — PICCOLINE CCPM 3.1 reassembly")
out.append("; Genereret af gen_nasm.py (RC759 XIOS RE projekt)")
out.append("; Assemblér: nasm -f bin -o ccpm_out.sys ccpm.asm")
out.append("")
out.append("BITS 16")
out.append("ORG 0x0000")
out.append("")

off = 0
while off < FILE_SIZE:
    # Label?
    if off in branch_targets or off in KNOWN_LABELS:
        name = label_for(off)
        out.append(f"")
        out.append(f"{name}:  ; {off:05X}")

    if code_bytes[off] and off in insn_at:
        # Kode-region: db med mnemonic som kommentar (garanterer byte-identisk encoding)
        mnem, ops, raw, sz = insn_at[off]
        mnem_disp, ops_disp = fixup_nasm(mnem, ops, raw)
        ops_ann = annotate_ops(ops_disp)
        asm_comment = f"{mnem_disp} {ops_ann}".strip()
        hex_vals = ", ".join(f"0x{b:02X}" for b in raw)
        out.append(f"  db {hex_vals:<40} ; {off:05X}  {asm_comment}")
        off += sz
    else:
        # Data-region: samle så mange bytes som muligt
        db_bytes = []
        start_off = off
        while off < FILE_SIZE:
            if off in branch_targets or off in KNOWN_LABELS:
                break
            if code_bytes[off] and off in insn_at:
                break
            db_bytes.append(d[off])
            off += 1

        if not db_bytes:
            db_bytes = [d[off]]
            off += 1

        # Skriv i linjer af 16 bytes
        for chunk_start in range(0, len(db_bytes), 16):
            chunk = db_bytes[chunk_start:chunk_start+16]
            hex_vals = ", ".join(f"0x{b:02X}" for b in chunk)
            ascii_rep = "".join(chr(b) if 32 <= b < 127 and b != 0x5C else "." for b in chunk)
            abs_off = start_off + chunk_start
            out.append(f"  db {hex_vals:<60} ; {abs_off:05X}  {ascii_rep}")

nasm_src = "\n".join(out) + "\n"
with open(NASM_OUT, "w") as f:
    f.write(nasm_src)

print(f"\nNASM-kilde skrevet til {NASM_OUT}")
print(f"Linjer: {len(out)}")
