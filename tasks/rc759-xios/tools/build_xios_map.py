#!/usr/bin/env python3
"""
build_xios_map.py — Fase 0.1: Byg symbol-tabel for ccpm.sys (RC759 XIOS 2.3)

Laver en CFG-baseret disassembly fra kendte entry-points og producerer:
  xios_map.json  — maskinlæsbar symbol-tabel + cross-refs
  xios_map.txt   — menneskelæsbar listing med annotationer

Adressemodel: fil loades ved paragraph 0x0048 (physical 0x0480).
Kode-segment-offset = fil-offset (da CS = 0x0048 = fil-load-paragraph).
"""

import capstone, json, sys, struct, re
from collections import defaultdict

# ── Konfiguration ──────────────────────────────────────────────────────────────
CCPM_SYS  = "/tmp/ccpm.sys"
OUT_JSON  = "/Users/ravn/z80/tasks/rc759-xios/xios_map.json"
OUT_TXT   = "/Users/ravn/z80/tasks/rc759-xios/xios_map.txt"
FILE_SIZE = 77568          # 0x12F00

# Kendte labels (fil-offset → navn)
KNOWN_LABELS = {
    # Modul-entrypoints (fra fase 0.2 MEMIF-headers)
    0x000FE: "mod0_rtm_init",
    0x002FA: "mod0_rtm_entry",
    0x0168B: "mod1_bdos1_init",
    0x016E0: "mod1_bdos1_entry",
    0x0270B: "mod2_bdos2_init",
    0x02726: "mod2_bdos2_entry",
    0x0322B: "mod3_bdos3_init",
    0x03266: "mod3_bdos3_entry",
    0x03B1C: "mod4_xios_init",    # RETF — pre-init?
    0x03BAD: "mod4_xios_entry",
    # XIOS JMP-header (inde i modul 4)
    0x0B163: "xios_jmp_init",
    0x0B166: "xios_jmp_entry",
    # XIOS init()
    0x0B169: "xios_init",
    # XIOS entry/dispatch
    0x0B1EF: "xios_entry_0x8C",   # 'pop bp / ret' — uklareret
    # RTM-kerne og dispatcher
    0x0282:  "rtm_core",           # SI=AL*2, opslag i SYSDAT+0xAA
    0x0313:  "rtm_dispatcher",     # DS=SYSDAT, kalder 0x282
    # XIOS inter-modul dispatch
    0x0B163+0x4F0A: "xios_imod_dispatch_shl",
    0x0B163+0x4F12: "xios_imod_dispatch_jmp",
    # Dispatch-tabel (data, ikke kode)
    0x16A4: "__xios_dispatch_table__",
    # XIOS-funktioner (fra dispatch-tabellen)
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
    # RTM service-handlers (fase 1.1 fund — fra SYSDAT+0xAA tabel)
    0x8517:  "rtm_al80_poll_console",    # AL=0x80 io_const poll
    0x851E:  "rtm_al87_blocking_read",   # AL=0x87 io_conin blocking
    0x7C97:  "sub_7c97",
    0x7E11:  "sub_7e11",
    0x85D3:  "sub_85d3",
    0x8A54:  "sub_8a54",   # test byte ptr [bx+0x6b], 4
    0x8A95:  "sub_8a95",   # test word ptr [bx+0x6b], 0x200
    # io_const helpers
    0x2863:  "io_const_rtm_helper",
    0x2793:  "rtm_call_0x80_entry",
    # io_conin helpers
    0x0557:  "io_conin_rtm_helper",
    # Disk-driver (RTM fn 2 patch-target, formodet)
    0x09D4E: "fdc_fcr_setup",
    0x09E00: "fdc_fcr_write",
    0x09F06: "fdc_send_cmd",
    0x09F4D: "fdc_wait",
    0x0A00B: "fdc_read_path",
    0x0A2BE: "fdc_isr",         # ISR (IRET+EOI) — fejlnavnet fdc_force_int
    0x0CB31: "fdc_release",
    # Floppy reserve/ack
    0x0AC27: "floppy_ack",
    0x0AD64: "floppy_status_check",
    # CRT (XIOS del)
    0x0C08A: "fdc_dma_scroll_cmd",  # skriver til 0x288+0x280+0x294, ikke CRT-porte
    # CRT init + command helpers
    0x07BFE: "crt_init_irst_ca",    # OUT 0x230 (IRST) + OUT 0x240 (CA)
    0x09607: "crt_post_cmd_wait",   # OUT 0x240 CA + poll cs:[0x5FA4]
    0x0B9B7: "crt_mode_switch",     # CA + VRAM-clear + charset-upload
}

# Hardware-porte (til annotation)
HW_PORTS = {
    0x000:"i8259A PIC cmd",    0x002:"i8259A PIC data",
    0x020:"Tastatur HLE",
    0x056:"SN76489A lyd",
    0x05A:"MM58167 RTC data",  0x05C:"MM58167 RTC addr",
    0x060:"i82730 ctrl",
    0x070:"i8255 PPI-A",       0x072:"i8255 PPI-B",
    0x074:"i8255 PPI-C",       0x076:"i8255 PPI ctrl",
    0x230:"i82730 IRST reset",  0x240:"i82730 Channel Attn",
    0x260:"Floppy status drev1",0x280:"WD2797 cmd/stat",
    0x282:"WD2797 track",       0x284:"WD2797 sector",
    0x286:"WD2797 data",        0x288:"Floppy FCR",
    0x28C:"Floppy status drev0",0x28E:"Floppy ack/reserve",
    0x290:"Floppy release",     0x292:"Floppy DMA ack",
    0x294:"DMA scroll/kanal",   0x300:"iSBX MCS0",
    0x302:"iSBX seriel+2",      0x310:"iSBX MCS1",
}

# WD2797 kommandoer
WD2797_CMDS = {
    0x00:"Restore", 0x10:"Seek", 0x18:"Step",
    0x80:"Read Sector", 0x88:"Read Sector (m)",
    0xA0:"Write Sector", 0xC0:"Read Address",
    0xD0:"Force Interrupt", 0xF0:"Write Track",
}

# ── Datastrukturer ─────────────────────────────────────────────────────────────
d    = open(CCPM_SYS, "rb").read()
md   = capstone.Cs(capstone.CS_ARCH_X86, capstone.CS_MODE_16)
md.detail = True

# code[offset] = True means byte is confirmed code
code   = bytearray(FILE_SIZE)
# insn_map[offset] = (mnemonic, op_str, bytes_hex, size)
insn_map = {}
# calls_to[src] = set of targets (CALL)
calls_to  = defaultdict(set)
# jumps_to[src] = set of targets (JMP/Jcc)
jumps_to  = defaultdict(set)
# called_from[target] = set of sources
called_from = defaultdict(set)
# jumped_from[target] = set of sources
jumped_from = defaultdict(set)

visited = set()
queue   = []

def enqueue(offset):
    if 0 <= offset < FILE_SIZE and offset not in visited:
        queue.append(offset)

# ── CFG-traversal ──────────────────────────────────────────────────────────────
def disasm_from(start):
    pos = start
    while pos < FILE_SIZE:
        if pos in visited:
            break
        chunk = d[pos:pos+16]
        instrs = list(md.disasm(chunk, pos))
        if not instrs:
            break
        insn = instrs[0]
        sz   = insn.size
        mnem = insn.mnemonic
        ops  = insn.op_str

        # Markér kode-bytes
        for i in range(sz):
            if pos+i < FILE_SIZE:
                code[pos+i] = 1
        visited.add(pos)
        insn_map[pos] = (mnem, ops, insn.bytes.hex(), sz)

        # Følg kontrol-flow
        if mnem == "jmp":
            # Ubetinget hopp
            if insn.operands and insn.operands[0].type == capstone.x86.X86_OP_IMM:
                tgt = insn.operands[0].imm & 0xFFFF
                # tgt er CS-relativ = fil-offset
                if 0 <= tgt < FILE_SIZE:
                    jumps_to[pos].add(tgt)
                    jumped_from[tgt].add(pos)
                    enqueue(tgt)
            break  # stop lineær scan

        elif mnem.startswith("j") and mnem != "jmp":
            # Betinget branch — følg begge veje
            if insn.operands and insn.operands[0].type == capstone.x86.X86_OP_IMM:
                tgt = insn.operands[0].imm & 0xFFFF
                if 0 <= tgt < FILE_SIZE:
                    jumps_to[pos].add(tgt)
                    jumped_from[tgt].add(pos)
                    enqueue(tgt)
            # Fald-igennem fortsætter

        elif mnem == "call":
            if insn.operands and insn.operands[0].type == capstone.x86.X86_OP_IMM:
                tgt = insn.operands[0].imm & 0xFFFF
                if 0 <= tgt < FILE_SIZE:
                    calls_to[pos].add(tgt)
                    called_from[tgt].add(pos)
                    enqueue(tgt)
            # Fald-igennem efter call

        elif mnem in ("ret", "retf", "iret", "hlt"):
            break  # stop lineær scan

        pos += sz

# Seed med alle kendte labels
for offset in KNOWN_LABELS:
    if not KNOWN_LABELS[offset].startswith("__"):
        enqueue(offset)

# BFS
print(f"Starter CFG-traversal fra {len(queue)} seed-punkter...", flush=True)
iterations = 0
while queue:
    nxt = queue.pop(0)
    if nxt not in visited:
        disasm_from(nxt)
    iterations += 1
    if iterations % 500 == 0:
        print(f"  {iterations} iterationer, {len(visited)} adresser besøgt, {len(queue)} i kø...", flush=True)

print(f"Færdig: {len(visited)} kode-bytes kortlagt, {len(insn_map)} instruktioner")

# ── Byg symbol-tabel ───────────────────────────────────────────────────────────
# Alle unikke adresser der er mål for CALL
func_starts = set(KNOWN_LABELS.keys())
func_starts.update(called_from.keys())

symbols = {}
for addr in sorted(func_starts):
    if addr >= FILE_SIZE:
        continue
    label = KNOWN_LABELS.get(addr, f"sub_{addr:04x}")
    # Find out-bound calls og jumps fra denne funktion
    # (simplificeret: alle calls/jumps fra kode-range til udenfor)
    out_calls = set()
    out_jumps = set()
    # Scan instruktioner for at finde funktionsafslutning
    pos = addr
    func_end = addr
    while pos in insn_map:
        mnem, ops, _, sz = insn_map[pos]
        if pos in calls_to:
            out_calls.update(calls_to[pos])
        if pos in jumps_to:
            out_jumps.update(jumps_to[pos])
        func_end = pos + sz
        if mnem in ("ret", "retf", "iret", "hlt"):
            break
        # Stop hvis næste adresse ikke er besøgt i sammenhæng
        next_pos = pos + sz
        if next_pos not in insn_map or next_pos in called_from:
            break
        pos = next_pos

    # IO-porte brugt
    io_ports = set()
    pos = addr
    while pos in insn_map:
        mnem, ops, _, sz = insn_map[pos]
        if mnem in ("in", "out"):
            # Find port-konstant
            m = re.search(r'\b0x([0-9a-f]+)\b', ops)
            if m:
                p = int(m.group(1), 16)
                hw = HW_PORTS.get(p, f"?0x{p:03x}")
                io_ports.add(f"0x{p:03x} ({hw})")
        pos += sz
        if pos not in insn_map: break

    symbols[addr] = {
        "label":        label,
        "file_offset":  f"0x{addr:05x}",
        "seg_offset":   f"0x{addr:04x}",   # = fil-offset siden CS=0x0048=fil-base
        "size_approx":  func_end - addr,
        "callers":      sorted(f"0x{c:04x}" for c in called_from.get(addr, set())),
        "calls":        sorted(f"0x{c:04x}" for c in out_calls),
        "io_ports":     sorted(io_ports),
        "is_known":     addr in KNOWN_LABELS,
    }

# ── JSON output ────────────────────────────────────────────────────────────────
result = {
    "meta": {
        "file":        "ccpm.sys",
        "file_size":   FILE_SIZE,
        "load_para":   "0x0048",
        "xios_start":  "0x0B163",
        "total_code_bytes":   int(sum(code)),
        "total_instructions": len(insn_map),
        "total_symbols":      len(symbols),
    },
    "symbols": symbols,
}
json.dump(result, open(OUT_JSON, "w"), indent=2, ensure_ascii=False)
print(f"JSON skrevet: {OUT_JSON}")

# ── Menneskelæsbar output ──────────────────────────────────────────────────────
with open(OUT_TXT, "w") as f:
    f.write("=" * 72 + "\n")
    f.write("RC759 PICCOLINE — ccpm.sys XIOS symbol-tabel\n")
    f.write("XIOS 2.3 (Flemming Kraglund, Rc-Computer Denmark, Marts 1985)\n")
    f.write(f"Fil: ccpm.sys  {FILE_SIZE} bytes  load-paragraph 0x0048\n")
    f.write("=" * 72 + "\n\n")

    f.write(f"Statistik:\n")
    f.write(f"  Kode-bytes kortlagt: {int(sum(code))} / {FILE_SIZE}\n")
    f.write(f"  Instruktioner:       {len(insn_map)}\n")
    f.write(f"  Symboler:            {len(symbols)}\n\n")

    f.write("SYMBOLER (sorteret efter adresse):\n")
    f.write("-" * 72 + "\n")
    for addr, sym in sorted(symbols.items()):
        mark = "★" if sym["is_known"] else " "
        f.write(f"\n{mark} {sym['file_offset']}  {sym['label']:<30}  (~{sym['size_approx']} B)\n")
        if sym["callers"]:
            f.write(f"   Kaldt fra: {', '.join(sym['callers'])}\n")
        if sym["calls"]:
            f.write(f"   Kalder:    {', '.join(sym['calls'][:8])}\n")
        if sym["io_ports"]:
            f.write(f"   I/O-porte: {', '.join(sym['io_ports'])}\n")

    # Disassembly af kendte funktioner
    f.write("\n\n" + "=" * 72 + "\n")
    f.write("DISASSEMBLY AF KENDTE FUNKTIONER\n")
    f.write("=" * 72 + "\n")
    for addr in sorted(KNOWN_LABELS):
        if KNOWN_LABELS[addr].startswith("__") or addr not in insn_map:
            continue
        label = KNOWN_LABELS[addr]
        f.write(f"\n; {'─'*60}\n")
        f.write(f"; {label}  (fil 0x{addr:05x})\n")
        f.write(f"; {'─'*60}\n")
        pos = addr
        lines = 0
        while pos in insn_map and lines < 60:
            mnem, ops, hexb, sz = insn_map[pos]
            lbl = KNOWN_LABELS.get(pos, "")
            if lbl and pos != addr:
                f.write(f"{lbl}:\n")
            # I/O-annotation
            ann = ""
            if mnem in ("in","out"):
                m = re.search(r'\b0x([0-9a-f]+)\b', ops)
                if m:
                    p = int(m.group(1), 16)
                    ann = f"  ; {HW_PORTS.get(p, f'?0x{p:03x}')}"
                else:
                    ann = "  ; port i DX"
            caller_ann = ""
            if pos in called_from and pos != addr:
                caller_ann = f"  ; ← kaldt fra {', '.join(f'0x{c:04x}' for c in list(called_from[pos])[:3])}"
            f.write(f"  {pos:04x}:  {hexb:<12}  {mnem} {ops}{ann}{caller_ann}\n")
            if mnem in ("ret","retf","iret","hlt"):
                break
            pos += sz
            lines += 1
        if pos in insn_map and lines >= 60:
            f.write(f"  ... (fortsat)\n")

print(f"TXT skrevet:  {OUT_TXT}")
print("\nFærdigt!")
