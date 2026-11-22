#!/usr/bin/env python3
"""
format_xios_strings.py — Formatér Piccoline hardware- og boot-beskeder som rigtige db-tekststrenge.
Område: 0x0B48C til 0x0B79D i mod4_xios.asm (XIOS)
"""

ASM_FILE = "tasks/rc759-xios/mod4_xios.asm"

xios_text_lines = [
    '; --- RC759 Piccoline Skærmtrimning prompt (0x0B48C - 0x0B4FC) ---',
    '  db "- Tryk p} en tast            "            ; 0B48C',
    '  times 80 db 0                                ; 0B4A9',
    '  db "$ **"                                    ; 0B4F9',
    '',
    '; --- RC759 Piccoline XIOS Status- og Fejlbeskeder (0x0B4FD - 0x0B5B5) ---',
    '  db " Venter p} f{lles diskettestation"       ; 0B4FD',
    '  db 0x1C, " ** Venter p} f{lles skriver1"     ; 0B521',
    '  db "** Kun 1 konsol - Vinduesstyring ikke installeret" ; 0B53E',
    '  db 0x15, " ** Skriver ikke klar"             ; 0B570',
    '  db 0x16, " ** Skriver Reserveret"            ; 0B586',
    '  db 0x1A, " ** Grafiksk{rm reserveret2"       ; 0B59D',
    '  db " ** Skriver ikke klar. 1=gentag,2=afbryd,3=ignorer" ; 0B5B6',
    '',
    '; --- RC759 Piccoline Boot Banner & Hardware-rapport (0x0B5E1 - 0x0B79D) ---',
    '  db "PICCOLINE XIOS version 2.3 - Marts 1985 ", 0x0D, 0x0A, 0x0A ; 0B5E1',
    '  db "      K bytes hoved lager", 0x0D, 0x0A, 0 ; 0B613',
    '  db "      K bytes bruger lager", 0x0D, 0x0A, 0 ; 0B62F',
    '  db "      Diskette station(er)", 0x0D, 0x0A, 0 ; 0B64C',
    '  db "      Winchester disk station(er)", 0x0D, 0x0A, 0 ; 0B669',
    '  db "      Data buffer(e)", 0x0D, 0x0A, 0     ; 0B68D',
    '  db "      Katalog buffer(e)", 0x0D, 0x0A, 0  ; 0B6A4',
    '  db "      K bytes M-disk", 0x0D, 0x0A, 0     ; 0B6BE',
    '  db "  *** For lidt lager til M-disk", 0x0D, 0x0A, 0 ; 0B6DA',
    '  db 0x0D, 0x0A, "Lokalnet adaptor installeret", 0x0D, 0x0A, 0 ; 0B6F7',
    '  db 0x0D, 0x0A, "Numerisk Regneenhed installeret", 0x0D, 0x0A, 0 ; 0B718',
    '  db "Winchester disk  X er ikke initialiseret", 0x0D, 0x0A, 0 ; 0B73A',
    '  db "Winchester disk  x har d}rlig konfigurations sektor", 0x0D, 0x0A, 0 ; 0B765',
]

with open(ASM_FILE) as f:
    content = f.read()

# Find start ved 0B48C: "sub ax, 0x5420"
idx_start = content.find("; 0B48C")
if idx_start == -1:
    print("Kunne ikke finde 0B48C")
    exit(1)

line_start = content.rfind("\n", 0, idx_start) + 1

# Find slut ved 0B79A
idx_end = content.find("; 0B79A")
if idx_end == -1:
    print("Kunne ikke finde 0B79A")
    exit(1)

line_end = content.find("\n", idx_end) + 1

replacement = "\n".join(xios_text_lines) + "\n"
new_content = content[:line_start] + replacement + content[line_end:]

with open(ASM_FILE, "w") as f:
    f.write(new_content)

print(f"Erstattet linjer fra 0x0B48C til 0x0B79A i {ASM_FILE}")
