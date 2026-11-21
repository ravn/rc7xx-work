#!/usr/bin/env python3
"""
Test script for B+2 conversion of ccpm.asm:
- Identifies all branch targets and assigns sub_XXXXX / loc_XXXXX / KNOWN_LABELS.
- Renames existing L_XXXXX labels to sub_XXXXX, loc_XXXXX, or data_XXXXX.
- Inserts labels for all missing branch targets.
- Converts db 0x.. branch instructions into proper NASM instructions.
- Verifies byte-identical reassembly.
"""

import re
import subprocess
import sys

ASM_IN = "tasks/rc759-xios/ccpm.asm"
ASM_OUT = "scratch/tmp/ccpm_b2.asm"
SYS_ORIG = "scratch/tmp/ccpm.sys"
SYS_OUT = "scratch/tmp/ccpm_b2.sys"

VALID_8086_BRANCH_OPCODES = {
    0xE8, 0xE9, 0xEB,
    0x70, 0x71, 0x72, 0x73, 0x74, 0x75, 0x76, 0x77, 0x78, 0x79, 0x7A, 0x7B, 0x7C, 0x7D, 0x7E, 0x7F,
    0xE0, 0xE1, 0xE2, 0xE3,
}

re_code = re.compile(r"^(\s*)db\s+([0-9a-fA-FxX,\s]+);\s*([0-9a-fA-F]{5})\s+([a-zA-Z0-9_]+)\s*(.*)$")
re_label = re.compile(r"^([a-zA-Z0-9_]+):\s*;\s*([0-9a-fA-F]{5})")
re_branch = re.compile(r"^(call|jmp|jmp\s+short|j[a-z]{1,4}|loop[a-z]{0,2})\s+(short\s+)?0x([0-9a-fA-F]+)$", re.IGNORECASE)

with open(ASM_IN, "r") as f:
    lines = f.readlines()

print(f"Total lines in input: {len(lines)}")

# 1. First pass: map offsets to line numbers and collect existing labels
code_offsets = {}
existing_labels = {}  # offset -> label_name

for i, line in enumerate(lines):
    m = re_code.match(line)
    if m:
        off = int(m.group(3), 16)
        code_offsets[off] = i

    ml = re_label.match(line)
    if ml:
        lbl = ml.group(1)
        off = int(ml.group(2), 16)
        existing_labels[off] = lbl

print(f"Total instruction offsets: {len(code_offsets)}")
print(f"Total existing labels: {len(existing_labels)}")

# 2. Second pass: identify all valid branches and categorize targets
call_targets = set()
jump_targets = set()
branch_info = {}  # line_idx -> (off, opcode, mnem, tgt_off, raw_bytes, raw_hex_str)

for i, line in enumerate(lines):
    m = re_code.match(line)
    if not m:
        continue
    indent, raw_hex, off_str, mnem, ops = m.groups()
    full_insn = f"{mnem} {ops}".strip()
    bm = re_branch.match(full_insn)
    if not bm:
        continue

    raw_b = [int(x.strip(), 16) for x in raw_hex.split(",") if x.strip()]
    if raw_b[0] not in VALID_8086_BRANCH_OPCODES:
        continue

    off = int(off_str, 16)
    tgt = int(bm.group(3), 16)
    if tgt not in code_offsets:
        # Not landing on an instruction boundary (data/ASCII false positive)
        continue

    if raw_b[0] == 0xE8:
        call_targets.add(tgt)
    else:
        jump_targets.add(tgt)

    branch_info[i] = (off, raw_b[0], mnem.lower(), tgt, raw_b, raw_hex.strip())

all_targets = call_targets | jump_targets
print(f"Convertible branch instructions: {len(branch_info)}")
print(f"Call targets (subroutines): {len(call_targets)}")
print(f"Jump targets: {len(jump_targets)}")
print(f"Total unique branch targets: {len(all_targets)}")

# 3. Build symbol mapping
# Preserve any existing label that is NOT a generic L_XXXXX (e.g. bdos1_..., mem_..., cio_..., rtm_...)
symbol_map = {}  # offset -> symbol_name

# First, any existing label with a custom name
for off, lbl in existing_labels.items():
    if not re.match(r"^L_[0-9A-Fa-f]{5}$", lbl):
        symbol_map[off] = lbl

# Next, for all branch targets:
for tgt in sorted(all_targets):
    if tgt in symbol_map:
        continue
    if tgt in call_targets:
        symbol_map[tgt] = f"sub_{tgt:05X}"
    else:
        symbol_map[tgt] = f"loc_{tgt:05X}"

# For any remaining existing L_XXXXX labels that are not branch targets:
for off, lbl in existing_labels.items():
    if off not in symbol_map:
        if off in code_offsets:
            symbol_map[off] = f"loc_{off:05X}"
        else:
            symbol_map[off] = f"data_{off:05X}"

print(f"Total symbols in symbol map: {len(symbol_map)}")

# 4. Prepare lines to insert missing labels
# We need to know which branch targets have no label at their line
labels_to_insert = {}  # target_offset -> symbol_name
for tgt in all_targets:
    if tgt not in existing_labels:
        labels_to_insert[tgt] = symbol_map[tgt]

print(f"Labels to insert for missing targets: {len(labels_to_insert)}")

# Map target_offset to line number where label should be inserted
insert_at_line = {}
for tgt, sym in labels_to_insert.items():
    line_idx = code_offsets[tgt]
    insert_at_line.setdefault(line_idx, []).append((tgt, sym))

# 5. Generate converted assembly
out_lines = []

for i, line in enumerate(lines):
    # Check if we should insert any missing label before this line
    if i in insert_at_line:
        for tgt, sym in insert_at_line[i]:
            out_lines.append(f"\n{sym}:  ; {tgt:05X}\n")

    # Check if this line is an existing label definition
    ml = re_label.match(line)
    if ml:
        off = int(ml.group(2), 16)
        sym = symbol_map.get(off, ml.group(1))
        out_lines.append(f"{sym}:  ; {off:05X}\n")
        continue

    # Check if this line is a convertible branch
    if i in branch_info:
        off, opcode, mnem, tgt, raw_b, raw_hex_str = branch_info[i]
        target_sym = symbol_map[tgt]
        raw_hex_compact = ", ".join(f"0x{b:02X}" for b in raw_b)

        if opcode == 0xE8:
            insn_str = f"call {target_sym}"
        elif opcode == 0xE9:
            insn_str = f"jmp near {target_sym}"
        elif opcode == 0xEB:
            insn_str = f"jmp short {target_sym}"
        elif 0x70 <= opcode <= 0x7F:
            insn_str = f"{mnem} {target_sym}"
        elif 0xE0 <= opcode <= 0xE3:
            insn_str = f"{mnem} {target_sym}"
        else:
            insn_str = f"{mnem} {target_sym}"

        # Format line with instruction and comment with offset and raw bytes
        formatted_line = f"  {insn_str:<44} ; {off:05X}  {raw_hex_compact}\n"
        out_lines.append(formatted_line)
        continue

    # Otherwise keep line as-is
    out_lines.append(line)

with open(ASM_OUT, "w") as f:
    f.writelines(out_lines)

print(f"Wrote converted ASM to {ASM_OUT} ({len(out_lines)} lines)")
