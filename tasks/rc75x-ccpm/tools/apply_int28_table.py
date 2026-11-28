#!/usr/bin/env python3
"""
apply_int28_table.py — Erstat rå disassemblering med int28h_jump_table
og navngiv samtlige 54 INT 28H funktioner i mod4_xios.asm.

Verificeret mod PICCOLINE Programmer's Guide v2, Appendix A.
"""

import sys

def main():
    path = "tasks/rc75x-ccpm/mod4_xios.asm"
    with open(path, "r") as f:
        content = f.read()

    # 1. Tilføj xios_code_base ved 0x06BA0
    old_base_anchor = "  add ax, [bx + si]                            ; 06BA0  0x03, 0x00"
    new_base_anchor = "xios_code_base:                             ; 06BA0 (XIOS Code Segment Base for INT 28h)\n" + old_base_anchor
    if old_base_anchor not in content:
        print("FEJL: Kunne ikke finde 06BA0 anker")
        sys.exit(1)
    content = content.replace(old_base_anchor, new_base_anchor, 1)

    # 2. Erstat bogus disassemblering ved 0x0784C - 0x078B7 med int28h_jump_table
    start_anchor = "  iret                                         ; 0784B  0xCF\n"
    end_anchor = "\nloc_078B8:                                     ; 078B8\n  ret                                          ; 078B8  0xC3\n  mov ax, 0x8523                               ; 078B9  0xB8, 0x23, 0x85\n  mov bx, 0x206                                ; 078BC  0xBB, 0x06, 0x02\n  ret                                          ; 078BF  0xC3"

    idx_start = content.find(start_anchor)
    idx_end = content.find(end_anchor)
    if idx_start == -1 or idx_end == -1:
        print(f"FEJL: Kunne ikke finde tabelgrænser (start={idx_start}, end={idx_end})")
        sys.exit(1)

    table_asm = """; =============================================================================
; INT 28H Function Dispatch Table (54 Funktioner: 0..53)
; Placering: CS:0CAC (filoffset 0x0784C - 0x078B7, 108 bytes = 54 words)
; Reference: PICCOLINE Programmer's Guide v2, Appendix A
; =============================================================================
int28h_jump_table:
  dw xios_int28_fn_00_graphics_mode - xios_code_base  ; Func  0: Skift til grafik-tilstand (CS:22B5, fil 0x08E55)
  dw xios_int28_fn_01_char_mode - xios_code_base      ; Func  1: Skift til tekst/tegn-tilstand (CS:23C7, fil 0x08F67)
  dw xios_int28_fn_02_scroll_step - xios_code_base    ; Func  2: Blød rulning scanline-step (CS:1D70, fil 0x08910)
  dw xios_int28_fn_03_get_nvram - xios_code_base      ; Func  3: Hent kopi af NVRAM (CS:42D6, fil 0x0AE76)
  dw xios_int28_fn_04_get_autoconfig - xios_code_base ; Func  4: Hent autokonfiguration / maskin-ID (CS:42DF, fil 0x0AE7F)
  dw xios_int28_fn_05_recalibrate - xios_code_base    ; Func  5: Floppy drev rekalibrering (CS:3459, fil 0x09FF9)
  dw xios_int28_fn_06_reserved - xios_code_base       ; Func  6: Reserveret (CS:3475, fil 0x0A015)
  dw xios_int28_fn_07_reserved - xios_code_base       ; Func  7: Reserveret (CS:3476, fil 0x0A016)
  dw xios_int28_fn_08_step_in - xios_code_base        ; Func  8: Floppy step et spor ind (CS:3477, fil 0x0A017)
  dw xios_int28_fn_09_step_out - xios_code_base       ; Func  9: Floppy step et spor ud (CS:3493, fil 0x0A033)
  dw xios_int28_fn_10_write_track - xios_code_base    ; Func 10: Floppy skriv helt spor (CS:3494, fil 0x0A034)
  dw xios_int28_fn_11_read_track - xios_code_base     ; Func 11: Floppy læs helt spor (CS:351F, fil 0x0A0BF)
  dw xios_int28_fn_12_sound - xios_code_base          ; Func 12: Lydgenerator skriv data-byte (CS:445E, fil 0x0AFFE)
  dw xios_int28_fn_13_disk_stats - xios_code_base     ; Func 13: Hent diskdriver-statistikker (CS:35AD, fil 0x0A14D)
  dw xios_int28_fn_14_reserved - xios_code_base       ; Func 14: Reserveret (CS:35B6, fil 0x0A156)
  dw xios_int28_fn_15_reserved - xios_code_base       ; Func 15: Reserveret (CS:110D, fil 0x07CAD)
  dw xios_int28_stub_ret - xios_code_base             ; Func 16: Reserveret stub (CS:0D18, fil 0x078B8)
  dw xios_int28_stub_ret - xios_code_base             ; Func 17: Reserveret stub (CS:0D18, fil 0x078B8)
  dw xios_int28_fn_18_reserved - xios_code_base       ; Func 18: Reserveret (CS:4024, fil 0x0ABC4)
  dw xios_int28_fn_19_timer - xios_code_base          ; Func 19: Hent 16 ms timer-tæller (CS:447F, fil 0x0B01F)
  dw xios_int28_fn_20_def_alt_char - xios_code_base   ; Func 20: Definer tegn i alternativt tegnsæt (CS:2542, fil 0x090E2)
  dw xios_int28_fn_21_get_disp_list - xios_code_base  ; Func 21: Hent pointer til display list (CS:25A1, fil 0x09141)
  dw xios_int28_fn_22_set_disp_list - xios_code_base  ; Func 22: Sæt display list tabel-pointer (CS:25AA, fil 0x0914A)
  dw xios_int28_fn_23_isbx_status - xios_code_base    ; Func 23: Hent iSBX351 seriel status (CS:4492, fil 0x0B032)
  dw xios_int28_fn_24_isbx_init - xios_code_base      ; Func 24: Initialiser iSBX351 controller (CS:4583, fil 0x0B123)
  dw xios_int28_fn_25_reserved - xios_code_base       ; Func 25: Reserveret (CS:3E5E, fil 0x0A9FE)
  dw xios_int28_fn_26_cas_read_hdr - xios_code_base   ; Func 26: Båndoptager læs filhoved (CS:5B16, fil 0x0C6B6)
  dw xios_int28_fn_27_cas_write_hdr - xios_code_base  ; Func 27: Båndoptager skriv filhoved (CS:5B35, fil 0x0C6D5)
  dw xios_int28_fn_28_cas_read_data - xios_code_base  ; Func 28: Båndoptager læs datablok (CS:5B52, fil 0x0C6F2)
  dw xios_int28_fn_29_cas_write_data - xios_code_base ; Func 29: Båndoptager skriv datablok (CS:5B6F, fil 0x0C70F)
  dw xios_int28_fn_30_mouse - xios_code_base          ; Func 30: Mus styring/status (CS:2900, fil 0x094A0)
  dw xios_int28_fn_31_palette - xios_code_base        ; Func 31: Definer farvepalette (CS:25D2, fil 0x09172)
  dw xios_int28_fn_32_reserved - xios_code_base       ; Func 32: Reserveret (CS:42E8, fil 0x0AE88)
  dw xios_int28_fn_33_reserved - xios_code_base       ; Func 33: Reserveret (CS:42F6, fil 0x0AE96)
  dw xios_int28_fn_34_reserved - xios_code_base       ; Func 34: Reserveret (CS:4306, fil 0x0AEA6)
  dw xios_int28_fn_35_write_str - xios_code_base      ; Func 35: Skriv streng direkte til konsolbuffer (CS:24F6, fil 0x09096)
  dw xios_int28_fn_36_cursor_pos - xios_code_base     ; Func 36: Sæt cursorposition (BH=række, BL=kol) (CS:25B6, fil 0x09156)
  dw xios_int28_fn_37_get_attr - xios_code_base       ; Func 37: Hent aktuelle skærmattributter (CS:25C4, fil 0x09164)
  dw xios_int28_fn_38_set_attr - xios_code_base       ; Func 38: Sæt skærmattributter (CS:25CB, fil 0x0916B)
  dw xios_int28_fn_39_update_screen - xios_code_base  ; Func 39: Opdater fysisk skærm (CS:253C, fil 0x090DC)
  dw xios_int28_fn_40_cas_write_eof - xios_code_base  ; Func 40: Båndoptager skriv EOF-blok (CS:5B8A, fil 0x0C72A)
  dw xios_int28_fn_41_dpc_parallel - xios_code_base   ; Func 41: Reserver/frigiv DPC parallelinterface (CS:5E63, fil 0x0CA03)
  dw xios_int28_fn_42_shared_disk - xios_code_base    ; Func 42: Reserver/frigiv delt disk (CS:5F15, fil 0x0CAB5)
  dw xios_int28_stub_ret - xios_code_base             ; Func 43: Reserveret stub (CS:0D18, fil 0x078B8)
  dw xios_int28_stub_ret - xios_code_base             ; Func 44: Reserveret stub (CS:0D18, fil 0x078B8)
  dw xios_int28_stub_ret - xios_code_base             ; Func 45: Reserveret stub (CS:0D18, fil 0x078B8)
  dw xios_int28_stub_ret - xios_code_base             ; Func 46: Reserveret stub (CS:0D18, fil 0x078B8)
  dw xios_int28_stub_ret - xios_code_base             ; Func 47: Reserveret stub (CS:0D18, fil 0x078B8)
  dw xios_int28_stub_ret - xios_code_base             ; Func 48: Reserveret stub (CS:0D18, fil 0x078B8)
  dw xios_int28_stub_ret - xios_code_base             ; Func 49: Reserveret stub (CS:0D18, fil 0x078B8)
  dw xios_int28_fn_50_isbx_reset - xios_code_base     ; Func 50: Reset iSBX351 controller (CS:44BE, fil 0x0B05E)
  dw xios_int28_fn_51_get_font - xios_code_base       ; Func 51: Hent tegndefinition fra font-RAM (CS:256A, fil 0x0910A)
  dw xios_int28_fn_52_def_font - xios_code_base       ; Func 52: Definer tegn i font-RAM (CS:2553, fil 0x090F3)
  dw xios_int28_fn_53_version - xios_code_base        ; Func 53: Hent XIOS version (CS:0D19, fil 0x078B9)
"""

    replacement_block = start_anchor + table_asm + "\nxios_int28_stub_ret:                            ; 078B8\nloc_078B8:\n  ret                                          ; 078B8  0xC3\n\nxios_int28_fn_53_version:                     ; 078B9\n  mov ax, 0x8523                               ; 078B9  0xB8, 0x23, 0x85\n  mov bx, 0x206                                ; 078BC  0xBB, 0x06, 0x02\n  ret                                          ; 078BF  0xC3"

    content = content[:idx_start] + replacement_block + content[idx_end + len(end_anchor):]

    # 3. Indsæt labels ved hver af funktionerne
    label_insertions = [
        ("  call sub_08FDC                               ; 07CAD  0xE8, 0x2C, 0x13",
         "xios_int28_fn_15_reserved:                   ; 07CAD\n  call sub_08FDC                               ; 07CAD  0xE8, 0x2C, 0x13"),

        ("  push ds                                      ; 08910  0x1E",
         "xios_int28_fn_02_scroll_step:                ; 08910\n  push ds                                      ; 08910  0x1E"),

        ("  mov es, dx                                   ; 08E55  0x8E, 0xC2",
         "xios_int28_fn_00_graphics_mode:              ; 08E55\n  mov es, dx                                   ; 08E55  0x8E, 0xC2"),

        ("  cmp word [cs:0x2c4b], 0                      ; 08F67  0x2E, 0x83, 0x3E, 0x4B, 0x2C, 0x00",
         "xios_int28_fn_01_char_mode:                  ; 08F67\n  cmp word [cs:0x2c4b], 0                      ; 08F67  0x2E, 0x83, 0x3E, 0x4B, 0x2C, 0x00"),

        ("  db 0x8B, 0xEC                                ; 09096  mov bp, sp",
         "xios_int28_fn_35_write_str:                  ; 09096\n  db 0x8B, 0xEC                                ; 09096  mov bp, sp"),

        ("  call sub_08FDC                               ; 090DC  0xE8, 0xFD, 0xFE",
         "xios_int28_fn_39_update_screen:              ; 090DC\n  call sub_08FDC                               ; 090DC  0xE8, 0xFD, 0xFE"),

        ("  db 0x8B, 0xEC                                ; 090E2  mov bp, sp",
         "xios_int28_fn_20_def_alt_char:               ; 090E2\n  db 0x8B, 0xEC                                ; 090E2  mov bp, sp"),

        ("  db 0x8B, 0xEC                                ; 090F3  mov bp, sp",
         "xios_int28_fn_52_def_font:                   ; 090F3\n  db 0x8B, 0xEC                                ; 090F3  mov bp, sp"),

        ("  db 0x8B, 0xEC                                ; 0910A  mov bp, sp",
         "xios_int28_fn_51_get_font:                   ; 0910A\n  db 0x8B, 0xEC                                ; 0910A  mov bp, sp"),

        ("  call sub_08FDC                               ; 09141  0xE8, 0x98, 0xFE",
         "xios_int28_fn_21_get_disp_list:              ; 09141\n  call sub_08FDC                               ; 09141  0xE8, 0x98, 0xFE"),

        ("  call sub_08FDC                               ; 0914A  0xE8, 0x8F, 0xFE",
         "xios_int28_fn_22_set_disp_list:              ; 0914A\n  call sub_08FDC                               ; 0914A  0xE8, 0x8F, 0xFE"),

        ("  push bx                                      ; 09156  0x53",
         "xios_int28_fn_36_cursor_pos:                 ; 09156\n  push bx                                      ; 09156  0x53"),

        ("  call sub_08FDC                               ; 09164  0xE8, 0x75, 0xFE",
         "xios_int28_fn_37_get_attr:                   ; 09164\n  call sub_08FDC                               ; 09164  0xE8, 0x75, 0xFE"),

        ("  call sub_08FDC                               ; 0916B  0xE8, 0x6E, 0xFE",
         "xios_int28_fn_38_set_attr:                   ; 0916B\n  call sub_08FDC                               ; 0916B  0xE8, 0x6E, 0xFE"),

        ("  xchg si, dx                                  ; 09172  87 F2",
         "xios_int28_fn_31_palette:                    ; 09172\n  xchg si, dx                                  ; 09172  87 F2"),

        ("  cmp cl, 4                                    ; 094A0  0x80, 0xF9, 0x04",
         "xios_int28_fn_30_mouse:                      ; 094A0\n  cmp cl, 4                                    ; 094A0  0x80, 0xF9, 0x04"),

        ("  mov byte [cs:0x3781], 1                      ; 09FF9  0x2E, 0xC6, 0x06, 0x81, 0x37, 0x01",
         "xios_int28_fn_05_recalibrate:                ; 09FF9\n  mov byte [cs:0x3781], 1                      ; 09FF9  0x2E, 0xC6, 0x06, 0x81, 0x37, 0x01"),

        ("  ret                                          ; 0A015  0xC3\n  ret                                          ; 0A016  0xC3",
         "xios_int28_fn_06_reserved:                   ; 0A015\n  ret                                          ; 0A015  0xC3\n\nxios_int28_fn_07_reserved:                   ; 0A016\n  ret                                          ; 0A016  0xC3"),

        ("  mov byte [cs:0x3781], 1                      ; 0A017  0x2E, 0xC6, 0x06, 0x81, 0x37, 0x01",
         "xios_int28_fn_08_step_in:                    ; 0A017\n  mov byte [cs:0x3781], 1                      ; 0A017  0x2E, 0xC6, 0x06, 0x81, 0x37, 0x01"),

        ("  ret                                          ; 0A033  0xC3\n  mov byte [cs:0x3781], 1                      ; 0A034  0x2E, 0xC6, 0x06, 0x81, 0x37, 0x01",
         "xios_int28_fn_09_step_out:                   ; 0A033\n  ret                                          ; 0A033  0xC3\n\nxios_int28_fn_10_write_track:                ; 0A034\n  mov byte [cs:0x3781], 1                      ; 0A034  0x2E, 0xC6, 0x06, 0x81, 0x37, 0x01"),

        ("  mov byte [cs:0x3781], 1                      ; 0A0BF  0x2E, 0xC6, 0x06, 0x81, 0x37, 0x01",
         "xios_int28_fn_11_read_track:                 ; 0A0BF\n  mov byte [cs:0x3781], 1                      ; 0A0BF  0x2E, 0xC6, 0x06, 0x81, 0x37, 0x01"),

        ("  mov es, [cs:0xc06]                           ; 0A14D  0x2E, 0x8E, 0x06, 0x06, 0x0C",
         "xios_int28_fn_13_disk_stats:                 ; 0A14D\n  mov es, [cs:0xc06]                           ; 0A14D  0x2E, 0x8E, 0x06, 0x06, 0x0C"),

        ("  ret                                          ; 0A156  0xC3",
         "xios_int28_fn_14_reserved:                   ; 0A156\n  ret                                          ; 0A156  0xC3"),

        ("  db 0x2E, 0x3A, 0x16                          ; 0A9FE  .:.",
         "xios_int28_fn_25_reserved:                   ; 0A9FE\n  db 0x2E, 0x3A, 0x16                          ; 0A9FE  .:."),

        ("sub_0ABC4:                                     ; 0ABC4",
         "xios_int28_fn_18_reserved:                   ; 0ABC4\nsub_0ABC4:                                     ; 0ABC4"),

        ("  mov es, [cs:0xc06]                           ; 0AE76  0x2E, 0x8E, 0x06, 0x06, 0x0C",
         "xios_int28_fn_03_get_nvram:                  ; 0AE76\n  mov es, [cs:0xc06]                           ; 0AE76  0x2E, 0x8E, 0x06, 0x06, 0x0C"),

        ("sub_0AE7F:                                     ; 0AE7F",
         "xios_int28_fn_04_get_autoconfig:             ; 0AE7F\nsub_0AE7F:                                     ; 0AE7F"),

        ("  pushf                                        ; 0AE88  0x9C",
         "xios_int28_fn_32_reserved:                   ; 0AE88\n  pushf                                        ; 0AE88  0x9C"),

        ("  pushf                                        ; 0AE96  0x9C",
         "xios_int28_fn_33_reserved:                   ; 0AE96\n  pushf                                        ; 0AE96  0x9C"),

        ("  pushf                                        ; 0AEA6  0x9C",
         "xios_int28_fn_34_reserved:                   ; 0AEA6\n  pushf                                        ; 0AEA6  0x9C"),

        ("  db 0x8A, 0xE2                                ; 0AFFE  mov ah, dl",
         "xios_int28_fn_12_sound:                      ; 0AFFE\n  db 0x8A, 0xE2                                ; 0AFFE  mov ah, dl"),

        ("  mov dx, [cs:0x4428]                          ; 0B01F  0x2E, 0x8B, 0x16, 0x28, 0x44",
         "xios_int28_fn_19_timer:                      ; 0B01F\n  mov dx, [cs:0x4428]                          ; 0B01F  0x2E, 0x8B, 0x16, 0x28, 0x44"),

        ("con_data_read:                                 ; 0B032",
         "xios_int28_fn_23_isbx_status:                ; 0B032\ncon_data_read:                                 ; 0B032"),

        ("sub_0B05E:                                     ; 0B05E",
         "xios_int28_fn_50_isbx_reset:                 ; 0B05E\nsub_0B05E:                                     ; 0B05E"),

        ("  push bp                                      ; 0B123  0x55",
         "xios_int28_fn_24_isbx_init:                  ; 0B123\n  push bp                                      ; 0B123  0x55"),

        # 4. Kassette I/O rutiner (Funktion 26, 27, 28, 29, 40)
        # Fn 26 ved 0x0C6B6:
        ("""  add ax, bp                                   ; 0C6B5  0x01, 0xE8
  and [bp + di], al                            ; 0C6B7  0x20, 0x03
  db 0x8B, 0xDA                                ; 0C6B9  mov bx, dx""",
         """  db 0x01                                      ; 0C6B5
xios_int28_fn_26_cas_read_hdr:                 ; 0C6B6 (Båndoptager læs filhoved)
  call sub_0C9D9                               ; 0C6B6  0xE8, 0x20, 0x03
  mov bx, dx                                   ; 0C6B9  0x8B, 0xDA"""),

        ("  call sub_0C9D9                               ; 0C6D5  0xE8, 0x01, 0x03",
         "xios_int28_fn_27_cas_write_hdr:                ; 0C6D5 (Båndoptager skriv filhoved)\n  call sub_0C9D9                               ; 0C6D5  0xE8, 0x01, 0x03"),

        ("  call sub_0C9D9                               ; 0C6F2  0xE8, 0xE4, 0x02",
         "xios_int28_fn_28_cas_read_data:               ; 0C6F2 (Båndoptager læs datablok)\n  call sub_0C9D9                               ; 0C6F2  0xE8, 0xE4, 0x02"),

        ("  call sub_0C9D9                               ; 0C70F  0xE8, 0xC7, 0x02",
         "xios_int28_fn_29_cas_write_data:              ; 0C70F (Båndoptager skriv datablok)\n  call sub_0C9D9                               ; 0C70F  0xE8, 0xC7, 0x02"),

        ("  call sub_0C9D9                               ; 0C72A  0xE8, 0xAC, 0x02",
         "xios_int28_fn_40_cas_write_eof:               ; 0C72A (Båndoptager skriv EOF-blok)\n  call sub_0C9D9                               ; 0C72A  0xE8, 0xAC, 0x02"),

        # 5. DPC & Shared disk (Funktion 41 & 42)
        ("  push ax                                      ; 0CA03  0x50",
         "xios_int28_fn_41_dpc_parallel:               ; 0CA03 (Reserver/frigiv DPC interface)\n  push ax                                      ; 0CA03  0x50"),

        ("  push ax                                      ; 0CAB5  0x50",
         "xios_int28_fn_42_shared_disk:                ; 0CAB5 (Reserver/frigiv delt disk)\n  push ax                                      ; 0CAB5  0x50"),
    ]

    for target, repl in label_insertions:
        if target not in content:
            print(f"FEJL: Kunne ikke finde mønster:\n{target[:60]}")
            sys.exit(1)
        content = content.replace(target, repl, 1)

    with open(path, "w") as f:
        f.write(content)
    print("Opdaterede mod4_xios.asm med int28h_jump_table og alle 54 funktioner!")

if __name__ == "__main__":
    main()
