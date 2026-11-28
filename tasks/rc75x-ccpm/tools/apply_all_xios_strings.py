#!/usr/bin/env python3
"""
apply_all_xios_strings.py — Formatér hele Piccoline XIOS UI-, skærm- og boot-banneret
med rigtige danske tegn (æ, ø, å, Æ, Ø, Å) via NASM ISO-646-DK konstanter.
"""

import os

ASM_FILE = "tasks/rc75x-ccpm/mod4_xios.asm"

with open(ASM_FILE) as f:
    content = f.read()

# Sikr at %define æ/ø/å findes i toppen af filen
dk_defines = """; ISO-646-DK (Dansk 7-bit tegnsæt til RC759 Piccoline)
%define æ 0x7B
%define ø 0x7C
%define å 0x7D
%define Æ 0x5B
%define Ø 0x5C
%define Å 0x5D
"""

if "%define æ 0x7B" not in content:
    # Indsæt efter header-kommentar
    idx_top = content.find("; =============================================================================\n")
    if idx_top != -1:
        idx_top = content.find("; =============================================================================\n", idx_top + 10)
        idx_top = content.find("\n", idx_top) + 1
        content = content[:idx_top] + "\n" + dk_defines + "\n" + content[idx_top:]

# 1. 0x0B30D: 0x22, "Interrupt=                   :    "
s_inter = content.find("; 0B30D")
e_inter = content.find("sub_0B330:  ; 0B330")
if s_inter != -1 and e_inter != -1:
    line_s = content.rfind("\n", 0, s_inter) + 1
    rep_inter = '  db 0x22, "Interrupt=                   :    " ; 0B30D\n\n'
    content = content[:line_s] + rep_inter + content[e_inter:]

# 2. 0x0B34B til 0x0B79D: Hele skærmtrimnings-tabellen og boot-banneret
idx_ret = content.find("; 0B34A")
if idx_ret == -1:
    print("Kunne ikke finde 0B34A")
    exit(1)

line_start = content.find("\n", idx_ret) + 1

idx_end = content.find("; 0B79D")
if idx_end == -1:
    idx_end = content.find("loc_0B79D:")
line_end = content.rfind("\n", 0, idx_end) + 1

xios_ui_lines = [
    '; =============================================================================',
    '; RC759 Piccoline Skærmtrimning & Diagnostic Menu (0x0B34B - 0x0B4FC)',
    '; =============================================================================',
    '  db 0x14, 0x20, 0xFF, "759 SK", Æ, "RMTRIMNING "    ; 0B34B',
    '  db 0x0C, "Mark", ø, "r Blink"                      ; 0B361',
    '  db 0x0C, "Mark", ø, "r H", ø, "jde"                ; 0B36E',
    '  db 0x0C, "Bl", ø, "d Rulning"                      ; 0B37B',
    '  db 0x0E, "Standard Farve"                          ; 0B388',
    '  db 0x0E, "Sluk Sk", æ, "rm"                        ; 0B397',
    '  db "    sort   bl", å, "    gr", ø, "n   cyan   r", ø, "d    magentagul    hvid   NEJ JA   Konsol=", 0 ; 0B3A6',
    '  db " ", 0, 0, 0, 0, 0, 0, 0, 0, " ", 0, 0, 0, 0, 0, 0, 0, 0 ; 0B3F1',
    '  db " ", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0   ; 0B403',
    '  db " ", 0, 0, 0, 0, 0, 0, 0, 0, " Skriver=", 0, 0, " ", 0, 0, 0, 0, " 00:00:00 " ; 0B415',
    '  db "DynamiskBufferetBuffer  L", å, "st    L", Å, "S" ; 0B434',
    '  times 52 db " "                                    ; 0B458',
    '  db "- Tryk p", å, " en tast            "            ; 0B48C',
    '  times 80 db 0                                      ; 0B4A9',
    '  db "$ **"                                          ; 0B4F9',
    '',
    '; =============================================================================',
    '; RC759 Piccoline XIOS Status- og Fejlbeskeder (0x0B4FD - 0x0B5E0)',
    '; =============================================================================',
    '  db " Venter p", å, " f", æ, "lles diskettestation" ; 0B4FD',
    '  db 0x1C, " ** Venter p", å, " f", æ, "lles skriver1" ; 0B521',
    '  db "** Kun 1 konsol - Vinduesstyring ikke installeret" ; 0B53E',
    '  db 0x15, " ** Skriver ikke klar"                   ; 0B570',
    '  db 0x16, " ** Skriver Reserveret"                  ; 0B586',
    '  db 0x1A, " ** Grafiksk", æ, "rm reserveret2"       ; 0B59D',
    '  db " ** Skriver ikke klar. 1=gentag,2=afbryd,3=ignorer" ; 0B5B6',
    '',
    '; =============================================================================',
    '; RC759 Piccoline Boot Banner & Hardware Rapport (0x0B5E1 - 0x0B79D)',
    '; =============================================================================',
    '  db "PICCOLINE XIOS version 2.3 - Marts 1985 ", 0x0D, 0x0A, 0x0A ; 0B5E1',
    '  db "      K bytes hoved lager", 0x0D, 0x0A, 0       ; 0B613',
    '  db "      K bytes bruger lager", 0x0D, 0x0A, 0      ; 0B62F',
    '  db "      Diskette station(er)", 0x0D, 0x0A, 0      ; 0B64C',
    '  db "      Winchester disk station(er)", 0x0D, 0x0A, 0 ; 0B669',
    '  db "      Data buffer(e)", 0x0D, 0x0A, 0           ; 0B68D',
    '  db "      Katalog buffer(e)", 0x0D, 0x0A, 0        ; 0B6A4',
    '  db "      K bytes M-disk", 0x0D, 0x0A, 0           ; 0B6BE',
    '  db "  *** For lidt lager til M-disk", 0x0D, 0x0A, 0 ; 0B6DA',
    '  db 0x0D, 0x0A, "Lokalnet adaptor installeret", 0x0D, 0x0A, 0 ; 0B6F7',
    '  db 0x0D, 0x0A, "Numerisk Regneenhed installeret", 0x0D, 0x0A, 0 ; 0B718',
    '  db "Winchester disk  X er ikke initialiseret", 0x0D, 0x0A, 0 ; 0B73A',
    '  db "Winchester disk  x har d", å, "rlig konfigurations sektor", 0x0D, 0x0A, 0 ; 0B765',
]

replacement = "\n".join(xios_ui_lines) + "\n"
new_content = content[:line_start] + replacement + content[line_end:]

with open(ASM_FILE, "w") as f:
    f.write(new_content)

print("mod4_xios.asm opdateret med æ, ø, å!")
