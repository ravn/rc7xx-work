#!/usr/bin/env python3
"""
fix_memif_headers.py — Erstat disassembelt tekst i MEMIF headers med rene tekst-strenge.
"""

import subprocess
import os

# Modul 1
m1_header = """  jmp near mod1_bdos1_init                     ; 01640  0xE9, 0x48, 0x00
  jmp near mod1_bdos1_entry                    ; 01643  0xE9, 0x9A, 0x00
  cli                                          ; 01646  0xFA
  push es                                      ; 01647  0x06
  dw 0x0003                                    ; 01648  MEMIF version
  dw 0x0048                                    ; 0164A  Segment
  db 0x06                                      ; 0164C
  db "COPYRIGHT (C) 1982,1983,1984 DIGITAL RESEARCH 1034-0261-007041" ; 0164D
"""

# Modul 2
m2_header = """  jmp near mem_init                            ; 026C0  0xE9, 0x48, 0x00
  jmp near mem_entry                           ; 026C3  0xE9, 0x60, 0x00
  cli                                          ; 026C6  0xFA
  push es                                      ; 026C7  0x06
  dw 0x0003                                    ; 026C8  MEMIF version
  dw 0x0048                                    ; 026CA  Segment
  db 0x06                                      ; 026CC
  db "COPYRIGHT (C) 1982,1983,1984 DIGITAL RESEARCH 1034-0261-007041" ; 026CD
"""

# Modul 3
m3_header = """  jmp near cio_init                            ; 031E0  0xE9, 0x48, 0x00
  jmp near cio_entry                           ; 031E3  0xE9, 0x80, 0x00
  cli                                          ; 031E6  0xFA
  push es                                      ; 031E7  0x06
  dw 0x0003                                    ; 031E8  MEMIF version
  dw 0x0048                                    ; 031EA  Segment
  db 0x06                                      ; 031EC
  db "COPYRIGHT (C) 1982,1983,1984 DIGITAL RESEARCH 1034-0261-007041" ; 031ED
"""

# Modul 4
m4_header = """  jmp near mod4_xios_init                      ; 03AD0  0xE9, 0x49, 0x00
  jmp near mod4_xios_entry                     ; 03AD3  0xE9, 0xD7, 0x00
  cli                                          ; 03AD6  0xFA
  push es                                      ; 03AD7  0x06
  dw 0x0003                                    ; 03AD8  MEMIF version
  dw 0x0048                                    ; 03ADA  Segment
  db 0x06, 0x00                                ; 03ADC
  db "COPYRIGHT(C)1983,84,DIGITAL RESEARCH(02/07/84)1034-0261-007041" ; 03ADE
"""

def replace_header(path, start_marker, end_marker, replacement):
    with open(path) as f:
        content = f.read()
    
    idx_start = content.find(start_marker)
    if idx_start == -1:
        print(f"Start marker not found in {path}: {start_marker[:30]}")
        return False
    
    idx_end = content.find(end_marker, idx_start)
    if idx_end == -1:
        print(f"End marker not found in {path}: {end_marker[:30]}")
        return False
    
    new_content = content[:idx_start] + replacement + "\n" + content[idx_end:]
    with open(path, "w") as f:
        f.write(new_content)
    print(f"Updated header in {path}")
    return True

# Modul 1
with open("tasks/rc759-xios/mod1_bdos.asm") as f:
    m1_text = f.read()
# Replace from "; Offset range: 0x01640 - 0x026C0\n; =============================================================================\n" to "mod1_bdos1_init:"
target_m1 = m1_text[m1_text.find("  dec ax"):m1_text.find("mod1_bdos1_init:")]
m1_text = m1_text.replace(target_m1, m1_header + "\n")
with open("tasks/rc759-xios/mod1_bdos.asm", "w") as f:
    f.write(m1_text)
print("Modul 1 header updated.")

# Modul 2
with open("tasks/rc759-xios/mod2_mem.asm") as f:
    m2_text = f.read()
target_m2 = m2_text[m2_text.find("  jmp near mem_init"):m2_text.find("mem_init:")]
m2_text = m2_text.replace(target_m2, m2_header + "\n")
with open("tasks/rc759-xios/mod2_mem.asm", "w") as f:
    f.write(m2_text)
print("Modul 2 header updated.")

# Modul 3
with open("tasks/rc759-xios/mod3_cio.asm") as f:
    m3_text = f.read()
target_m3 = m3_text[m3_text.find("  jmp near cio_init"):m3_text.find("cio_init:")]
m3_text = m3_text.replace(target_m3, m3_header + "\n")
with open("tasks/rc759-xios/mod3_cio.asm", "w") as f:
    f.write(m3_text)
print("Modul 3 header updated.")

# Modul 4
with open("tasks/rc759-xios/mod4_xios.asm") as f:
    m4_text = f.read()
target_m4 = m4_text[m4_text.find("  db 0x49"):m4_text.find("mod4_xios_init:")]
m4_text = m4_text.replace(target_m4, m4_header + "\n")
with open("tasks/rc759-xios/mod4_xios.asm", "w") as f:
    f.write(m4_text)
print("Modul 4 header updated.")
