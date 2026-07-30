#!/usr/bin/env python3
"""
Extract .COM size from an sdldz80 map file.
Rules (in priority order):
  1. If _DATA section exists with l__DATA > 0: file ends at s__DATA + l__DATA
     (initialized globals live after BSS in address space, and makebin fills the BSS
     gap with zeros; all of CODE+BSS_gap+DATA must be in the .COM file).
  2. Else if _BSS exists: file ends at s__BSS (BSS is not file-resident).
  3. Else: file ends at s__CODE + l__CODE.
Returns the count (number of bytes to dd from offset 256).
"""
import re, sys

txt = open(sys.argv[1]).read()

def sym(name):
    m = re.search(r'([0-9A-Fa-f]{8})\s+' + name, txt)
    return int(m.group(1), 16) if m else None

l_data = sym('l__DATA')
s_data = sym('s__DATA')
if l_data and l_data > 0 and s_data:
    end = s_data + l_data
else:
    s_bss = sym('s__BSS')
    if s_bss:
        end = s_bss
    else:
        s_code = sym('s__CODE') or 0x100
        l_code = sym('l__CODE') or 0
        end = s_code + l_code

print(end - 0x100)

