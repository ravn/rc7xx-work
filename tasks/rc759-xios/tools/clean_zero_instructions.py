#!/usr/bin/env python3
"""
clean_zero_instructions.py — Ryd op i utilsigtede 'add [bx + si], al' instruktioner.

Når en disassembler møder blokke af 0x00 0x00 (data-buffere, padding, tabeller),
bliver de naivt disassembelt som 'add [bx + si], al'.

Dette script konverterer dem tilbage til rene data-bytes (db 0x00, 0x00),
så de ikke forurener kildekoden som falske instruktioner.
"""

import re
import subprocess
import os

MODS = [
    "tasks/rc759-xios/mod0_rtm.asm",
    "tasks/rc759-xios/mod1_bdos.asm",
    "tasks/rc759-xios/mod2_mem.asm",
    "tasks/rc759-xios/mod3_cio.asm",
    "tasks/rc759-xios/mod4_xios.asm",
]

# Match enten:
# add [bx + si], al    ; 0004C  0x00, 0x00
# db 0x00, 0x00        ; 0004C  add byte [bx + si], al
re_add_zero1 = re.compile(r"^(\s*)add\s+(?:byte\s+)?\[bx\s*\+\s*si\],\s*al\s*;\s*([0-9a-fA-F]{5})\s+0x00,\s*0x00$")
re_add_zero2 = re.compile(r"^(\s*)db\s+0x00,\s*0x00\s*;\s*([0-9a-fA-F]{5})\s+add\s+(?:byte\s+)?\[bx\s*\+\s*si\],\s*al$")

total_cleaned = 0

for path in MODS:
    with open(path) as f:
        lines = f.readlines()

    mod_cleaned = 0
    for idx, l in enumerate(lines):
        m1 = re_add_zero1.match(l.strip())
        if m1:
            indent, off = m1.groups()
            lines[idx] = f"  db 0x00, 0x00                               ; {off}\n"
            mod_cleaned += 1
            continue

        m2 = re_add_zero2.match(l.strip())
        if m2:
            indent, off = m2.groups()
            lines[idx] = f"  db 0x00, 0x00                               ; {off}\n"
            mod_cleaned += 1
            continue

    if mod_cleaned > 0:
        print(f"{path}: rensede {mod_cleaned} 'add [bx + si], al' til db 0x00, 0x00")
        with open(path, "w") as f:
            f.writelines(lines)
        total_cleaned += mod_cleaned
    else:
        print(f"{path}: ingen fundet")

print(f"\nTotal rensede falske instruktioner: {total_cleaned}")
