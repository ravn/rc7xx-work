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

# ── Linear sweep over modul 0-3 (RTM + BDOS: 0x0000-0x03ACF) ─────────────────
# CFG kan ikke følge GENSYS-patchede dispatch-tabeller, men disse moduler er
# primært kode. Linear sweep finder "øer" som CFG ikke når.
#
# Heuristik for valid kode: mindst 3 instruktioner uden invalid opcode + ingen
# for lange instruktioner (>7 bytes = typisk data-mismatch).
#
SWEEP_END = 0x03AD0  # slut af modul 0-3

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
    0x000FE: "mod0_rtm_init",
    0x002FA: "mod0_rtm_entry",
    0x0168B: "mod1_bdos1_init",
    0x016E0: "mod1_bdos1_entry",
    # BDOS-funktioner identificeret via signatur-matching (2026-11-20)
    0x01731: "bdos1_func24_get_dlog",   # mov bx,[0x68]; ret → func24: get dlog bitmap
    0x01B01: "bdos1_switch_stack",      # save SS:SP til ES:[0x1e/0x1c], skift til BDOS-stak
    0x0270B: "mod2_bdos2_init",
    0x02726: "mod2_bdos2_entry",
    0x0274A: "bdos2_switch_stack",      # save SS:SP til [0x672/0x670], skift til BDOS-stak
    0x02773: "bdos2_restore_stack",     # restore SS:SP fra [0x672/0x670] (goback mod2)
    0x02790: "bdos_exit",               # exit: mov ax,bx; retf (BDOSIF exit)
    0x03344: "bdos3_xios_call",         # push dx; mov bx,0x70d; call intermod; mov[0x652],0xff; push ds
    0x0322B: "mod3_bdos3_init",
    0x03266: "mod3_bdos3_entry",
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
