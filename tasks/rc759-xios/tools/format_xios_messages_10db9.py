#!/usr/bin/env python3
"""Format the CCP/M and RC-Net status, error, and command block (0x10DB9..0x11570)
in mod4_xios.asm from fake disassembly instructions into clean, structured tables
and readable strings with Danish character constants.
"""

import sys

def main():
    with open("scratch/tmp/ccpm.sys", "rb") as fp:
        full_bin = fp.read()

    orig_1975 = full_bin[0x10DB9:0x11570]

    def to_nasm_string(raw_bytes):
        parts = []
        curr_str = ""
        def flush_str():
            nonlocal curr_str
            if curr_str:
                parts.append(f"\"{curr_str}\"")
                curr_str = ""

        dk_map = {
            0x7B: "æ", 0x7C: "ø", 0x7D: "å",
            0x5B: "Æ", 0x5C: "Ø", 0x5D: "Å"
        }

        i = 0
        while i < len(raw_bytes):
            b = raw_bytes[i]
            if b in dk_map:
                flush_str()
                parts.append(dk_map[b])
            elif b == 0x0D and i + 1 < len(raw_bytes) and raw_bytes[i+1] == 0x0A:
                flush_str()
                parts.append("0x0D, 0x0A")
                i += 1
            elif b == 0:
                flush_str()
                parts.append("0")
            elif b == 0x1B:
                flush_str()
                parts.append("0x1B")
            elif 32 <= b <= 126 and b != ord("\""):
                curr_str += chr(b)
            else:
                flush_str()
                parts.append(f"0x{b:02X}")
            i += 1
        flush_str()
        return "  db " + ", ".join(parts)

    lines = []
    lines.append("; --- CCP/M Fejlbesked Pointer-Tabel (0x10DB9) ---")
    p1 = orig_1975[0:55]
    for i in range(0, 54, 2):
        val = p1[i] + p1[i+1]*256
        if i % 16 == 0:
            lines.append(f"  dw 0x{val:04X}")
        else:
            lines[-1] += f", 0x{val:04X}"
    lines.append(f"  db 0x{p1[54]:02X}")

    lines.append("\n; --- CCP/M Fejlbeskeder (0x10DF0) ---")
    p2 = orig_1975[55:55+407]
    idx = 0
    while idx < len(p2):
        end = p2.find(b"\x00", idx)
        if end == -1: end = len(p2)
        else: end += 1
        chunk = p2[idx:end]
        lines.append(to_nasm_string(chunk))
        idx = end

    lines.append("\n; --- RC-Net Statusbesked Pointer-Tabel (0x10F87) ---")
    p3 = orig_1975[55+407:55+407+30]
    for i in range(0, 30, 2):
        val = p3[i] + p3[i+1]*256
        if i % 16 == 0:
            lines.append(f"  dw 0x{val:04X}")
        else:
            lines[-1] += f", 0x{val:04X}"

    lines.append("\n; --- RC-Net Statusbeskeder & Terminalsekvenser (0x10FA5) ---")
    p4 = orig_1975[55+407+30:0x11330-0x10DB9]
    idx = 0
    while idx < len(p4):
        end = p4.find(b"\x00", idx)
        if end == -1: end = len(p4)
        else: end += 1
        chunk = p4[idx:end]
        lines.append(to_nasm_string(chunk))
        idx = end

    lines.append("\n; --- Piccoline Netværkskommandoer (0x11330) ---")
    cmd_bytes = orig_1975[0x11330-0x10DB9:0x113BD-0x10DB9]
    lines.append(to_nasm_string(cmd_bytes[:3]))
    lines.append(to_nasm_string(cmd_bytes[3:]))

    lines.append("\n; --- Kommando Dispatch Tabel (0x113BD) ---")
    tbl_bytes = orig_1975[0x113BD-0x10DB9:0x113E4-0x10DB9]
    for i in range(0, len(tbl_bytes), 16):
        chunk = tbl_bytes[i:i+16]
        lines.append("  db " + ", ".join(f"0x{b:02X}" for b in chunk))

    lines.append("\n; --- Start Kommando Prompt (0x113E4) ---")
    p_term = orig_1975[0x113E4-0x10DB9:0x113E4-0x10DB9+44]
    p_prompt = orig_1975[0x113E4-0x10DB9+44:0x113E4-0x10DB9+61]
    lines.append(to_nasm_string(p_term))
    lines.append(to_nasm_string(p_prompt))
    lines.append("  times 15 db 0")

    lines.append("\n; --- Process Descriptor Table (CLOCK) (0x11430) ---")
    lines.append("  db 0xCE, 0x0F")
    lines.append("  times 19 db 0")
    lines.append("  db 0xBE, 0x02, 0")
    lines.append("  db \"CLOCK   \"")
    lines.append("  db 0x04")
    lines.append("  times 83 db 0")
    lines.append("  dw 0x013A")
    lines.append("  times 26 db 0")
    lines.append("  dw 0x1197, 0x1183, 0x1183, 0x1183")
    lines.append("  times 8 db 0")
    lines.append("  db 1, 0")

    lines.append("\n; --- Padding 0xCC (0x114D2) ---")
    cc_len = 0x1156A - 0x114D2
    lines.append(f"  times {cc_len} db 0xCC")
    lines.append("  add ax, [bx + si]                           ; 1156A  0x03, 0x00")
    lines.append("  times 4 db 0\n")

    replacement_block = "\n".join(lines)

    with open("tasks/rc759-xios/mod4_xios.asm", "r") as fp:
        mod4_lines = fp.readlines()

    start_idx = None
    end_idx = None
    for idx, l in enumerate(mod4_lines):
        if "; 10DB9" in l or "CCP/M Fejlbesked Pointer-Tabel" in l:
            start_idx = idx
            break
    for idx in range(start_idx, len(mod4_lines)):
        if "; 11570" in mod4_lines[idx]:
            end_idx = idx
            break

    assert start_idx is not None and end_idx is not None

    new_mod4 = "".join(mod4_lines[:start_idx]) + replacement_block + "".join(mod4_lines[end_idx:])
    with open("tasks/rc759-xios/mod4_xios.asm", "w") as fp:
        fp.write(new_mod4)
    print("Done formatting messages block.")

if __name__ == "__main__":
    main()
