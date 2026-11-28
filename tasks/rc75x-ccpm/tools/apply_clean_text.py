#!/usr/bin/env python3
"""
apply_clean_text.py — Erstat disassembelt tekst med læsbare db "..." strenge:
1. Modul 0 (0x00086): Flemming Kraglund MEMIF copyright header
2. Modul 0 (0x015D7..0x0163F): CCP/M sign-on banner ("Concurrent CP/M-86 3.1...")
3. Modul 1 (0x01640): BDOS MEMIF copyright header
4. Modul 2 (0x026C0): MEM MEMIF copyright header
5. Modul 3 (0x031E0): CIO MEMIF copyright header
6. Modul 4 (0x03AD0): XIOS MEMIF copyright header
"""

import os
import subprocess

# ── 1. Modul 0: Banner ved 0x015D7..0x01640 ──────────────────────────────────
# Originale bytes:
# 0x15D7: 9 null bytes
# 0x15E0: \r\nConcurrent CP/M-86 3.1\r\nCopyright (C) 1983, Digital Research\r\nSystem med 1 konsol\r\n$\r\n
# 0x1638: 8 null bytes (op til 0x1640)

m0_banner = """  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 ; 015D7
  db 0x0D, 0x0A, "Concurrent CP/M-86 3.1", 0x0D, 0x0A ; 015E0
  db "Copyright (C) 1983, Digital Research", 0x0D, 0x0A ; 015F9
  db "System med 1 konsol", 0x0D, 0x0A, "$", 0x0D, 0x0A ; 01620
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00         ; 01638
"""

# ── 2. Modul 0: Copyright header ved 0x00086 ─────────────────────────────────
m0_header_full = """loc_00083:  ; 00083
  jmp near mod0_rtm_entry                      ; 00083  0xE9, 0x74, 0x02
  cli                                          ; 00086
  push es                                      ; 00087
  dw 0x0003                                    ; 00088  MEMIF version
  dw 0x0048                                    ; 0008A  Segment
  db 0x06                                      ; 0008C
  db "COPYRIGHT (C) 1982,1983,1984 DIGITAL RESEARCH 1034-0261-007041 Modifyed by Flemming Kraglund Rc-Computer Denmark " ; 0008D
"""

# ── 3. Modul 1: BDOS MEMIF Header ved 0x01640 ────────────────────────────────
m1_header = """  jmp near mod1_bdos1_init                     ; 01640  0xE9, 0x48, 0x00
  jmp near mod1_bdos1_entry                    ; 01643  0xE9, 0x9A, 0x00
  cli                                          ; 01646  0xFA
  push es                                      ; 01647  0x06
  dw 0x0003                                    ; 01648  MEMIF version
  dw 0x0048                                    ; 0164A  Segment
  db 0x06                                      ; 0164C
  db "COPYRIGHT (C) 1982,1983,1984 DIGITAL RESEARCH 1034-0261-007041" ; 0164D
"""

# ── 4. Modul 2: MEM MEMIF Header ved 0x026C0 ─────────────────────────────────
m2_header = """  jmp near mem_init                            ; 026C0  0xE9, 0x48, 0x00
  jmp near mem_entry                           ; 026C3  0xE9, 0x60, 0x00
  cli                                          ; 026C6  0xFA
  push es                                      ; 026C7  0x06
  dw 0x0003                                    ; 026C8  MEMIF version
  dw 0x0048                                    ; 026CA  Segment
  db 0x06                                      ; 026CC
  db "COPYRIGHT (C) 1982,1983,1984 DIGITAL RESEARCH 1034-0261-007041" ; 026CD
"""

# ── 5. Modul 3: CIO MEMIF Header ved 0x031E0 ─────────────────────────────────
m3_header = """  jmp near cio_init                            ; 031E0  0xE9, 0x48, 0x00
  jmp near cio_entry                           ; 031E3  0xE9, 0x80, 0x00
  cli                                          ; 031E6  0xFA
  push es                                      ; 031E7  0x06
  dw 0x0003                                    ; 031E8  MEMIF version
  dw 0x0048                                    ; 031EA  Segment
  db 0x06                                      ; 031EC
  db "COPYRIGHT (C) 1982,1983,1984 DIGITAL RESEARCH 1034-0261-007041" ; 031ED
"""

# ── 6. Modul 4: XIOS MEMIF Header ved 0x03AD0 ────────────────────────────────
m4_header = """  jmp near mod4_xios_init                      ; 03AD0  0xE9, 0x49, 0x00
  jmp near mod4_xios_entry                     ; 03AD3  0xE9, 0xD7, 0x00
  cli                                          ; 03AD6  0xFA
  push es                                      ; 03AD7  0x06
  dw 0x0003                                    ; 03AD8  MEMIF version
  dw 0x0048                                    ; 03ADA  Segment
  db 0x06, 0x00                                ; 03ADC
  db "COPYRIGHT(C)1983,84,DIGITAL RESEARCH(02/07/84)1034-0261-007041" ; 03ADE
"""

# Opdater mod0_rtm.asm
with open("tasks/rc75x-ccpm/mod0_rtm.asm") as f:
    m0_text = f.read()

# Erstat 0x00086
target_m0_hdr = m0_text[m0_text.find("loc_00083:"):m0_text.find("mod0_rtm_init:")]
m0_text = m0_text.replace(target_m0_hdr, m0_header_full + "\n")

# Erstat 0x015D7..0x01640
target_m0_bnr = m0_text[m0_text.find("  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00         ; 015D7"):m0_text.find("; end of mod0_rtm.asm", m0_text.find("015D7"))]
if not target_m0_bnr:
    # Hvis der ikke er en kommentar i bunden, find frem til EOF
    idx15d7 = m0_text.find("  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00         ; 015D7")
    target_m0_bnr = m0_text[idx15d7:]

m0_text = m0_text.replace(target_m0_bnr, m0_banner)
with open("tasks/rc75x-ccpm/mod0_rtm.asm", "w") as f:
    f.write(m0_text)
print("Modul 0 opdateret (header + sign-on banner).")

# Opdater mod1_bdos.asm
with open("tasks/rc75x-ccpm/mod1_bdos.asm") as f:
    m1_text = f.read()
target_m1 = m1_text[m1_text.find("  db 0x48"):m1_text.find("mod1_bdos1_init:")]
if target_m1:
    m1_text = m1_text.replace(target_m1, m1_header + "\n")
    with open("tasks/rc75x-ccpm/mod1_bdos.asm", "w") as f:
        f.write(m1_text)
    print("Modul 1 opdateret.")

# Opdater mod2_mem.asm
with open("tasks/rc75x-ccpm/mod2_mem.asm") as f:
    m2_text = f.read()
target_m2 = m2_text[m2_text.find("  jmp near mem_init"):m2_text.find("mem_init:")]
if target_m2:
    m2_text = m2_text.replace(target_m2, m2_header + "\n")
    with open("tasks/rc75x-ccpm/mod2_mem.asm", "w") as f:
        f.write(m2_text)
    print("Modul 2 opdateret.")

# Opdater mod3_cio.asm
with open("tasks/rc75x-ccpm/mod3_cio.asm") as f:
    m3_text = f.read()
target_m3 = m3_text[m3_text.find("  jmp near cio_init"):m3_text.find("cio_init:")]
if target_m3:
    m3_text = m3_text.replace(target_m3, m3_header + "\n")
    with open("tasks/rc75x-ccpm/mod3_cio.asm", "w") as f:
        f.write(m3_text)
    print("Modul 3 opdateret.")

# Opdater mod4_xios.asm
with open("tasks/rc75x-ccpm/mod4_xios.asm") as f:
    m4_text = f.read()
target_m4 = m4_text[m4_text.find("  db 0x49"):m4_text.find("mod4_xios_init:")]
if target_m4:
    m4_text = m4_text.replace(target_m4, m4_header + "\n")
    with open("tasks/rc75x-ccpm/mod4_xios.asm", "w") as f:
        f.write(m4_text)
    print("Modul 4 opdateret.")
