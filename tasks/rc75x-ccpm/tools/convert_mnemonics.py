#!/usr/bin/env python3
"""
convert_mnemonics.py — Konverter db-instruktioner til verificerede NASM-mnemonics

Test- og verifikationspipeline:
1. For hver db-linje der matcher en gyldig 8086-instruktion:
   - Rens eventuelle DRI-annoteringer (p_field[reg] -> [reg + 0x..])
   - Fjern redundant 'ptr', 'byte', 'word' når register er til stede
2. Kør bisektions-batch-samling i Docker NASM.
3. Kun instruktioner der er 100% BYTE-IDENTISKE erstattes i kildefilen.
   Instruktioner med alternative encodings (f.eks. direction bit d=1) bevares som db.
4. Verificér den fulde ccpm.sys mod originalen via cmp.
"""

import os
import re
import struct
import subprocess
import sys

VALID_8086_MNEMONICS = {
    "mov", "push", "pop", "xchg", "in", "out", "xlat", "xlatb",
    "lea", "lds", "les", "lahf", "sahf", "pushf", "popf",
    "add", "adc", "inc", "sub", "sbb", "dec", "neg", "cmp", "cbw", "cwd",
    "not", "shl", "shr", "sar", "rol", "ror", "rcl", "rcr",
    "and", "test", "or", "xor",
    "rep", "repe", "repz", "repne", "repnz",
    "movs", "movsb", "movsw", "cmps", "cmpsb", "cmpsw",
    "scas", "scasb", "scasw", "lods", "lodsb", "lodsw",
    "stos", "stosb", "stosw",
    "call", "jmp", "ret", "retn", "retf",
    "int", "into", "iret",
    "clc", "cmc", "stc", "cld", "std", "cli", "sti", "wait", "esc", "lock", "nop", "hlt"
}

PD_INVERT = {
    "p_link": "0x00", "p_thread": "0x02", "p_stat": "0x04", "p_prior": "0x05",
    "p_flag": "0x06", "p_name": "0x08", "p_uda": "0x10", "p_dsk": "0x12",
    "p_user": "0x13", "p_ldsk": "0x14", "p_luser": "0x15", "p_mem": "0x16",
    "p_cmod": "0x18", "p_tkcnt": "0x19", "p_wait": "0x1A", "p_org": "0x1C",
    "p_parent": "0x1E", "p_cns": "0x20", "p_abort": "0x21", "p_conmode": "0x22",
    "p_lst": "0x24", "p_sflag": "0x26", "p_userdisp": "0x28", "p_pret": "0x2C",
    "p_scratch": "0x2E",
}

REGS = re.compile(r"\b(ax|bx|cx|dx|sp|bp|si|di|al|ah|bl|bh|cl|ch|dl|dh|cs|ds|es|ss)\b", re.IGNORECASE)
re_code = re.compile(r"^(\s*)db\s+([0-9a-fA-FxX,\s]+);\s*([0-9a-fA-F]{5})\s+([a-zA-Z0-9_]+)\s*(.*)$")

def clean_insn(mnem, ops):
    def repl_pd(m):
        field = m.group(1)
        reg = m.group(2)
        off = PD_INVERT.get(field, "0x00")
        return f"[{reg} + {off}]"
    ops = re.sub(r"\b(p_[a-z0-9]+)\[([a-z0-9]+)\]", repl_pd, ops)
    ops = ops.replace("[rlr]", "[0x002e]")
    ops = ops.replace("[indisp]", "[0x0219]")
    ops = ops.replace("[sysdat]", "[0x0006]")
    ops = ops.replace("[rtm_svc_tbl]", "[0x00aa]")
    ops = re.sub(r"\bptr\b", "", ops).strip()

    # Fjern kun byte/word foran [..] hvis der er et register UDENFOR klammerne
    no_brackets = re.sub(r"\[.*?\]", "", ops)
    if re.search(r"\b(ax|bx|cx|dx|sp|bp|si|di|al|ah|bl|bh|cl|ch|dl|dh|cs|ds|es|ss)\b", no_brackets, re.IGNORECASE):
        ops = re.sub(r"\b(byte|word|dword)\s+\[", "[", ops)

    return f"{mnem} {ops}".strip()

batch_counter = 0

def assemble_chunk(chunk):
    global batch_counter
    batch_counter += 1
    test_asm_lines = [
        "bits 16",
        "%macro T 2+",
        "  align 16",
        "  dw %1",
        "  dw %%end - %%start",
        "%%start:",
        "  %2",
        "%%end:",
        "%endmacro",
        ""
    ]
    for (line_idx, off, raw_b, insn, indent, raw_hex, off_str) in chunk:
        test_asm_lines.append(f"T {len(raw_b)}, {insn}")

    test_asm_path = f"scratch/tmp/batch_{os.getpid()}_{batch_counter}.asm"
    test_bin_path = f"scratch/tmp/batch_{os.getpid()}_{batch_counter}.bin"
    with open(test_asm_path, "w") as f:
        f.write("\n".join(test_asm_lines) + "\n")

    cmd = [
        "docker", "run", "--rm",
        "-v", f"{os.getcwd()}:/work",
        "-w", "/work",
        "rc759-nasm",
        "nasm", "-f", "bin", "-o", f"/work/{test_bin_path}", f"/work/{test_asm_path}"
    ]
    env = os.environ.copy()
    env["DOCKER_HOST"] = "unix:///Users/ravn/.docker/run/docker.sock"
    res = subprocess.run(cmd, env=env, capture_output=True, text=True)

    if os.path.exists(test_asm_path):
        os.remove(test_asm_path)

    if res.returncode == 0:
        with open(test_bin_path, "rb") as f:
            bin_data = f.read()
        os.remove(test_bin_path)
        return [(chunk, bin_data)]
    else:
        if os.path.exists(test_bin_path):
            os.remove(test_bin_path)
        if len(chunk) <= 1:
            return []  # Syntaktisk ugyldig enkeltlinje
        mid = len(chunk) // 2
        return assemble_chunk(chunk[:mid]) + assemble_chunk(chunk[mid:])

def process_module(asm_path, chunk_size=1000):
    print(f"\n--- Behandler {asm_path} ---")
    with open(asm_path) as f:
        lines = f.readlines()

    candidates = []
    for i, l in enumerate(lines):
        m = re_code.match(l)
        if not m:
            continue
        indent, raw_hex, off_str, mnem, ops = m.groups()
        raw_b = bytes([int(x.strip(), 16) for x in raw_hex.split(",") if x.strip()])
        if len(raw_b) <= 6 and mnem.lower() in VALID_8086_MNEMONICS:
            # Udeluk altid blokke af nul (add [bx+si], al) — disse er data/buffere, ikke kode
            if raw_b == b'\x00\x00' or (mnem.lower() == "add" and "[bx + si]" in ops and "al" in ops):
                continue
            insn = clean_insn(mnem, ops)
            candidates.append((i, int(off_str, 16), raw_b, insn, indent, raw_hex.strip(), off_str))

    total = len(candidates)
    print(f"Fandt {total} instruktionskandidater.")
    if total == 0:
        return 0

    converted_total = 0

    for start in range(0, total, chunk_size):
        chunk = candidates[start:start+chunk_size]
        results = assemble_chunk(chunk)
        chunk_converted = 0
        for sub_chunk, bin_data in results:
            for idx, (line_idx, off, expected_bytes, insn, indent, raw_hex, off_str) in enumerate(sub_chunk):
                entry = bin_data[idx*16:(idx+1)*16]
                exp_len, act_len = struct.unpack("<HH", entry[:4])
                act_bytes = entry[4:4+act_len]
                if act_len == exp_len and act_bytes == expected_bytes:
                    lines[line_idx] = f"{indent}{insn:<44} ; {off_str}  {raw_hex}\n"
                    chunk_converted += 1

        converted_total += chunk_converted
        print(f"Batch {start}..{min(start+chunk_size, total)}: konverterede {chunk_converted} / {len(chunk)} instruktioner")

    print(f"I alt konverteret i {asm_path}: {converted_total} / {total} ({100*converted_total/total:.1f}%)")

    with open(asm_path, "w") as f:
        f.writelines(lines)

    return converted_total

if __name__ == "__main__":
    modules = sys.argv[1:] if len(sys.argv) > 1 else [
        "tasks/rc75x-ccpm/mod1_bdos.asm",
        "tasks/rc75x-ccpm/mod2_mem.asm",
        "tasks/rc75x-ccpm/mod3_cio.asm",
    ]
    total_conv = 0
    for mod in modules:
        total_conv += process_module(mod)
    print(f"\nTotal konverterede instruktioner: {total_conv}")
