  jmp near loc_0BD52                           ; 077A0  0xE9, 0xAF, 0x45
  jmp near loc_077DA                           ; 077A3  0xE9, 0x34, 0x00
  dw 0x0000                                    ; SYSDAT segment (unlinked)
  dw 0x0000                                    ; SYSDAT entry offset (unlinked)
  dw 0x0000                                    ; Supervisor paragraph base (unlinked)

; ===========================================================================
; SYSDAT:0x0C0C (fil-offset 0x77AC) — DRI struct xios_table
; ===========================================================================
xios_config_table:
  db 0x00                                      ; 077AC: xt_tick (system tick flag)
  db 0x3C                                      ; 077AD: xt_ticks_sec (60 Hz VSYNC ticks/sekund)
  db 0x00                                      ; 077AE: xt_door (reserveret)
  db 0x00                                      ; 077AF: xt_rsvd (reserveret)
  db 0x01                                      ; 077B0: xt_xpcns (antal fysiske konsoller = 1)
  db 0x01                                      ; 077B1: xt_nvcns (antal virtuelle konsoller = 1 i CCPM1)
  db 0x09                                      ; 077B2: xt_nccbs (antal Console Control Blocks = 9)
  db 0x03                                      ; 077B3: xt_nlcbs (antal List Control Blocks = 3)
  dw 0x0D49                                    ; 077B4: xt_ccb (offset til CCB-array i SYSDAT)
  dw 0x0ED5                                    ; 077B6: xt_lcb (offset til LCB-array i SYSDAT)
  ; xt_dphtab: Disk Parameter Header pointere for drev A..P
  dw 0x3942                                    ; 077B8: Drev A (Floppy 0 DPH)
  dw 0x3956                                    ; 077BA: Drev B (Floppy 1 DPH)
  dw 0x0000, 0x0000, 0x0000, 0x0000            ; 077BC: Drev C, D, E, F
  dw 0x0000, 0x0000, 0x0000, 0x0000            ; 077C4: Drev G, H, I, J
  dw 0x0000, 0x0000                            ; 077CC: Drev K, L
  dw 0x3A32                                    ; 077D0: Drev M (Memory Disk / M-Disk DPH)
  dw 0x0000, 0x0000, 0x0000                    ; 077D2: Drev N, O, P
  dw 0x01F4                                    ; xt_alloc (unlinked 500 paras)
loc_077DA:                                     ; 077DA
  cld                                          ; 077DA  0xFC
  cbw                                          ; 077DB  0x98 (Convert Byte to Word)
  shl al, 1                                    ; 077DC  0xD0, 0xE0
  xchg bx, ax                                  ; 077DE  0x93
  call word [cs:bx + 0xc47]                    ; 077DF  0x2E, 0xFF, 0x97, 0x47, 0x0C
  db 0x8B, 0xD8                                ; 077E4  mov bx, ax (d=1)
  retf                                         ; 077E6  0xCB
; =============================================================================
; Digital Research CCP/M-86 XIOS Function Dispatch Table (CS:0C47h, 37 entries)
; Reference: Digital Research CCP/M-86 XIOS-86 (xios.a86)
; Indgang: AL = funktionsnummer (0..13 standard + udvidede funktioner)
; =============================================================================
xios_function_table:
  dw io_const - xios_code_base                 ; Func  0: Console input status (CS:1116h)
  dw io_conin - xios_code_base                 ; Func  1: Console input character (CS:1119h)
  dw io_conout - xios_code_base                ; Func  2: Console output character (CS:142Ch)
  dw io_listst - xios_code_base                ; Func  3: List/printer status (CS:4190h)
  dw io_list - xios_code_base                  ; Func  4: List/printer output (CS:40BFh)
  dw io_auxin - xios_code_base                 ; Func  5: AUX/serial input (CS:3C4Dh)
  dw io_auxout - xios_code_base                ; Func  6: AUX/serial output (CS:3C50h)
  dw io_switch - xios_code_base                ; Func  7: Switch virtual console (CS:1FE8h)
  dw io_statline - xios_code_base              ; Func  8: Update console status line (CS:20C1h)
  dw io_seldsk - xios_code_base                ; Func  9: Select disk drive (CS:2D7Bh)
  dw io_read - xios_code_base                  ; Func 10: Read logical disk sector (CS:2DD9h)
  dw io_write - xios_code_base                 ; Func 11: Write logical disk sector (CS:2E99h)
  dw io_flushbuf - xios_code_base              ; Func 12: Flush disk buffers (CS:2F5Bh)
  dw io_poll - xios_code_base                  ; Func 13: Poll hardware device (CS:4081h)
  times 5 dw xios_int28_stub_ret - xios_code_base ; Func 14..18: Uimplementerede funktioner (CS:0D18h)
  dw io_auxist - xios_code_base                ; Func 19: AUX input status (CS:261Bh)
  times 10 dw xios_int28_stub_ret - xios_code_base ; Func 20..29: Uimplementerede funktioner (CS:0D18h)
  dw io_setblank - xios_code_base              ; Func 30: Screen blanking / skærmsluk (CS:264Eh)
  times 6 dw xios_int28_stub_ret - xios_code_base ; Func 31..36: Uimplementerede funktioner (CS:0D18h)
; -----------------------------------------------------------------------------
; INT 28H Dispatcher (RC759 Udvidet Hardware/BIOS Funktioner)
; Reference: PICCOLINE Programmer's Guide v2, Appendix A (Funktioner 0-53)
; Indgang: AL = funktionsnummer (0..53)
; Udfører tabelopslag via [cs:bx + 0xcac] og afslutter med IRET.
; -----------------------------------------------------------------------------
int28h_dispatcher:
  push ds                                      ; 07831  0x1E
  mov ds, [cs:0xc06]                           ; 07832  0x2E, 0x8E, 0x1E, 0x06, 0x0C
  mov bx, [cs:0x68]                            ; 07837  0x2E, 0x8B, 0x1E, 0x68, 0x00
  mov es, [bx + 0x10]                          ; 0783C  0x8E, 0x47, 0x10
  db 0x33, 0xDB                                ; 0783F  xor bx, bx
  db 0x8A, 0xD8                                ; 07841  mov bl, al
  shl bx, 1                                    ; 07843  0xD1, 0xE3
  call word [cs:bx + 0xcac]                    ; 07845  0x2E, 0xFF, 0x97, 0xAC, 0x0C
  pop ds                                       ; 0784A  0x1F
  iret                                         ; 0784B  0xCF
; =============================================================================
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

xios_int28_stub_ret:                            ; 078B8
loc_078B8:
  ret                                          ; 078B8  0xC3

xios_int28_fn_53_version:                     ; 078B9
  mov ax, 0x8523                               ; 078B9  0xB8, 0x23, 0x85
  mov bx, 0x206                                ; 078BC  0xBB, 0x06, 0x02
  ret                                          ; 078BF  0xC3

rtm_call_helper:                               ; 078C0
  push dx                                      ; 078C0  0x52
  mov cl, 0x85                                 ; 078C1  0xB1, 0x85
  call xios_rtm_svc_call                       ; 078C3  0xE8, 0x16, 0x00
  pop dx                                       ; 078C6  0x5A
  test ax, ax                                  ; 078C7  0x85, 0xC0
  je loc_078D0                                 ; 078C9  0x74, 0x05
  cmp cl, 0x2a                                 ; 078CB  0x80, 0xF9, 0x2A
  je rtm_call_helper                           ; 078CE  0x74, 0xF0

loc_078D0:                                     ; 078D0
  ret                                          ; 078D0  0xC3

rtm_timer_wait:                                ; 078D1
  mov cl, 0x84                                 ; 078D1  0xB1, 0x84

rtm_timer_wait2:                               ; 078D3
  mov bx, [cs:0x68]                            ; 078D3  0x2E, 0x8B, 0x1E, 0x68, 0x00
  mov es, [cs:bx + 0x10]                       ; 078D8  0x2E, 0x8E, 0x47, 0x10

xios_rtm_svc_call:                             ; 078DC
  db 0x32, 0xED                                ; 078DC  xor ch, ch
  mov ds, [cs:0xc06]                           ; 078DE  0x2E, 0x8E, 0x1E, 0x06, 0x0C
  call far [cs:0xc08]                          ; 078E3  0x2E, 0xFF, 0x1E, 0x08, 0x0C
  ret                                          ; 078E8  0xC3
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xFF  ; 078E9  .........
  inc word [bx + si]                           ; 078F2  0xFF, 0x00
  db 0x00, 0x00                                ; 078F4
  db 0x00, 0x00                                ; 078F6
  add [bx + si], dl                            ; 078F8  0x00, 0x10
  db 0x00, 0x00                                ; 078FA
  db 0x00, 0x00                                ; 078FC
  db 0x00, 0x00                                ; 078FE
  db 0x00, 0x00                                ; 07900
  db 0x00, 0x00                                ; 07902
  db 0x00, 0x00                                ; 07904
  db 0x00, 0x00                                ; 07906
  db 0x00, 0x00                                ; 07908
  db 0x00, 0x00                                ; 0790A
  db 0x00, 0x00                                ; 0790C
  db 0x00, 0x00                                ; 0790E
  add [di + 0xd], dh                           ; 07910  0x00, 0x75, 0x0D
  db 0x00, 0x00                                ; 07913
  db 0x00, 0x00                                ; 07915
  db 0x00, 0x00                                ; 07917
  db 0x00, 0x00                                ; 07919
  db 0x00, 0x00                                ; 0791B
  db 0xFF                                      ; 0791D  .
  inc word [bx + si]                           ; 0791E  0xFF, 0x00
  add [bx + si], ax                            ; 07920  0x01, 0x00
  add [bp + si], al                            ; 07922  0x00, 0x02
  add [bx + si], dl                            ; 07924  0x00, 0x10
  db 0x00, 0x00                                ; 07926
  db 0x00, 0x00                                ; 07928
  db 0x00, 0x00                                ; 0792A
  db 0x00, 0x00                                ; 0792C
  db 0x00, 0x00                                ; 0792E
  db 0x00, 0x00                                ; 07930
  db 0x00, 0x00                                ; 07932
  db 0x00, 0x00                                ; 07934
  db 0x00, 0x00                                ; 07936
  db 0x00, 0x00                                ; 07938
  db 0x00, 0x00                                ; 0793A
  db 0x00, 0xA1, 0x0D, 0x00                    ; 0793C  add byte [bx + di + 0xd], ah
  db 0x00, 0x00                                ; 07940
  db 0x00, 0x00                                ; 07942
  db 0x00, 0x00                                ; 07944
  db 0x00, 0x00                                ; 07946
  add bh, bh                                   ; 07948  0x00, 0xFF
  inc word [bx + si]                           ; 0794A  0xFF, 0x00
  db 0x02, 0x00                                ; 0794C  add al, byte [bx + si]
  add [bp + si], al                            ; 0794E  0x00, 0x02
  add [bx + si], dl                            ; 07950  0x00, 0x10
  db 0x00, 0x00                                ; 07952
  db 0x00, 0x00                                ; 07954
  db 0x00, 0x00                                ; 07956
  db 0x00, 0x00                                ; 07958
  db 0x00, 0x00                                ; 0795A
  db 0x00, 0x00                                ; 0795C
  db 0x00, 0x00                                ; 0795E
  db 0x00, 0x00                                ; 07960
  db 0x00, 0x00                                ; 07962
  db 0x00, 0x00                                ; 07964
  db 0x00, 0x00                                ; 07966
  add ch, cl                                   ; 07968  0x00, 0xCD
  or ax, strict word 0                         ; 0796A  0D 00 00
  db 0x00, 0x00                                ; 0796D
  db 0x00, 0x00                                ; 0796F
  db 0x00, 0x00                                ; 07971
  db 0x00, 0x00                                ; 07973
  db 0xFF                                      ; 07975  .
  inc word [bx + si]                           ; 07976  0xFF, 0x00
  add ax, [bx + si]                            ; 07978  0x03, 0x00
  add [bp + si], al                            ; 0797A  0x00, 0x02
  add [bx + si], dl                            ; 0797C  0x00, 0x10
  db 0x00, 0x00                                ; 0797E
  db 0x00, 0x00                                ; 07980
  db 0x00, 0x00                                ; 07982
  db 0x00, 0x00                                ; 07984
  db 0x00, 0x00                                ; 07986
  db 0x00, 0x00                                ; 07988
  db 0x00, 0x00                                ; 0798A
  db 0x00, 0x00                                ; 0798C
  db 0x00, 0x00                                ; 0798E
  db 0x00, 0x00                                ; 07990
  db 0x00, 0x00                                ; 07992
  add cl, bh                                   ; 07994  0x00, 0xF9
  or ax, strict word 0                         ; 07996  0D 00 00
  db 0x00, 0x00                                ; 07999
  db 0x00, 0x00                                ; 0799B
  db 0x00, 0x00                                ; 0799D
  db 0x00, 0x00                                ; 0799F
  db 0x00, 0x00                                ; 079A1
  db 0x00, 0x00                                ; 079A3
  db 0x00, 0x00                                ; 079A5
  db 0x00, 0x00                                ; 079A7
  db 0x00, 0x00                                ; 079A9
  db 0x00, 0x00                                ; 079AB
  db 0x00, 0x00                                ; 079AD
  db 0x00, 0x00                                ; 079AF
  db 0x00, 0x00                                ; 079B1
  db 0x00, 0x00                                ; 079B3
  db 0x00, 0x00                                ; 079B5
  db 0x00, 0x00                                ; 079B7
  db 0x00, 0x00                                ; 079B9
  db 0x00, 0x00                                ; 079BB
  db 0x00, 0x00                                ; 079BD
  db 0x00, 0x00                                ; 079BF
  and ax, strict word 0xe                      ; 079C1  25 0E 00
  db 0x00, 0x00                                ; 079C4
  db 0x00, 0x00                                ; 079C6
  db 0x00, 0x00                                ; 079C8
  db 0x00, 0x00                                ; 079CA
  db 0x00, 0x00                                ; 079CC
  db 0x00, 0x00                                ; 079CE
  db 0x00, 0x00                                ; 079D0
  db 0x00, 0x00                                ; 079D2
  db 0x00, 0x00                                ; 079D4
  db 0x00, 0x00                                ; 079D6
  db 0x00, 0x00                                ; 079D8
  db 0x00, 0x00                                ; 079DA
  db 0x00, 0x00                                ; 079DC
  db 0x00, 0x00                                ; 079DE
  db 0x00, 0x00                                ; 079E0
  db 0x00, 0x00                                ; 079E2
  db 0x00, 0x00                                ; 079E4
  db 0x00, 0x00                                ; 079E6
  db 0x00, 0x00                                ; 079E8
  db 0x00, 0x00                                ; 079EA
  add [bx + di + 0xe], dl                      ; 079EC  0x00, 0x51, 0x0E
  db 0x00, 0x00                                ; 079EF
  db 0x00, 0x00                                ; 079F1
  db 0x00, 0x00                                ; 079F3
  db 0x00, 0x00                                ; 079F5
  db 0x00, 0x00                                ; 079F7
  db 0x00, 0x00                                ; 079F9
  db 0x00, 0x00                                ; 079FB
  db 0x00, 0x00                                ; 079FD
  db 0x00, 0x00                                ; 079FF
  db 0x00, 0x00                                ; 07A01
  db 0x00, 0x00                                ; 07A03
  db 0x00, 0x00                                ; 07A05
  db 0x00, 0x00                                ; 07A07
  db 0x00, 0x00                                ; 07A09
  db 0x00, 0x00                                ; 07A0B
  db 0x00, 0x00                                ; 07A0D
  db 0x00, 0x00                                ; 07A0F
  db 0x00, 0x00                                ; 07A11
  db 0x00, 0x00                                ; 07A13
  db 0x00, 0x00                                ; 07A15
  db 0x00, 0x00                                ; 07A17
  jge loc_07A29                                ; 07A19  0x7D, 0x0E
  db 0x00, 0x00                                ; 07A1B
  db 0x00, 0x00                                ; 07A1D
  db 0x00, 0x00                                ; 07A1F
  db 0x00, 0x00                                ; 07A21
  db 0x00, 0x00                                ; 07A23
  db 0x00, 0x00                                ; 07A25
  db 0x00, 0x00                                ; 07A27

loc_07A29:                                     ; 07A29
  db 0x00, 0x00                                ; 07A29
  db 0x00, 0x00                                ; 07A2B
  db 0x00, 0x00                                ; 07A2D
  db 0x00, 0x00                                ; 07A2F
  db 0x00, 0x00                                ; 07A31
  db 0x00, 0x00                                ; 07A33
  db 0x00, 0x00                                ; 07A35
  db 0x00, 0x00                                ; 07A37
  db 0x00, 0x00                                ; 07A39
  db 0x00, 0x00                                ; 07A3B
  db 0x00, 0x00                                ; 07A3D
  db 0x00, 0x00                                ; 07A3F
  db 0x00, 0x00                                ; 07A41
  db 0x00, 0x00                                ; 07A43
  test ax, 0xe                                 ; 07A45  0xA9, 0x0E, 0x00
  db 0x00, 0x00                                ; 07A48
  db 0x00, 0x00                                ; 07A4A
  db 0x00, 0x00                                ; 07A4C
  db 0x00, 0x00                                ; 07A4E
  db 0x00, 0x00                                ; 07A50
  db 0x00, 0x00                                ; 07A52
  db 0x00, 0x00                                ; 07A54
  db 0x00, 0x00                                ; 07A56
  db 0x00, 0x00                                ; 07A58
  db 0x00, 0x00                                ; 07A5A
  db 0x00, 0x00                                ; 07A5C
  db 0x00, 0x00                                ; 07A5E
  db 0x00, 0x00                                ; 07A60
  db 0x00, 0x00                                ; 07A62
  db 0x00, 0x00                                ; 07A64
  db 0x00, 0x00                                ; 07A66
  db 0x00, 0x00                                ; 07A68
  db 0x00, 0x00                                ; 07A6A
  db 0x00, 0x00                                ; 07A6C
  db 0x00, 0x00                                ; 07A6E
  db 0x00, 0x00                                ; 07A70
  db 0x00, 0x00                                ; 07A72
  db 0x00, 0x00                                ; 07A74
  db 0x00, 0x00                                ; 07A76
  db 0x00, 0x00                                ; 07A78
  db 0x00, 0x00                                ; 07A7A
  add bh, bh                                   ; 07A7C  0x00, 0xFF
  inc word [bx + si]                           ; 07A7E  0xFF, 0x00
  db 0x00, 0x00                                ; 07A80
  db 0x00, 0x00                                ; 07A82
  db 0x00, 0x00                                ; 07A84
  add bh, bh                                   ; 07A86  0x00, 0xFF
  inc word [bx + si]                           ; 07A88  0xFF, 0x00
  db 0x00, 0x00                                ; 07A8A
  db 0x00, 0x00                                ; 07A8C
  db 0x00, 0x00                                ; 07A8E
  add bh, bh                                   ; 07A90  0x00, 0xFF
  db 0xFF                                      ; 07A92  .
  call xios_switch_to_priv_stack               ; 07A93  0xE8, 0x87, 0x34
  db 0x2E, 0x80, 0x3E                          ; 07A96  ..>

; -----------------------------------------------------------------------------
; Tastatur Afbrydelsesrutine (Keyboard ISR, IR1 / Vektor 0x84)
; Læser rå seriel scancode fra PORT_KBD_DATA (0x20), håndterer taster (Shift/Ctrl/Alt),
; oversætter scancode via XLATB-opslag ved 0x2C52 og signalerer konsol-driveren
; via CCP/M-86 flagmekanismen (rtm_call_helper).
; -----------------------------------------------------------------------------
i_keyboard:
kbd_handler:                                   ; 07A99
  pusha                                        ; 07A99  60
  db 0x2A, 0xFF                                ; 07A9A  sub bh, bh
  jne loc_07AA1                                ; 07A9C  0x75, 0x03
  call sub_095CB                               ; 07A9E  0xE8, 0x2A, 0x1B

loc_07AA1:                                     ; 07AA1
  push ds                                      ; 07AA1  0x1E
  pop es                                       ; 07AA2  0x07
  call eoi_helper                              ; 07AA3  0xE8, 0x6B, 0x34
  in al, PORT_KBD_DATA                         ; 07AA6  0xE4, 0x20
  mov [cs:0x1044], al                          ; 07AA8  0x2E, 0xA2, 0x44, 0x10
  cmp byte [cs:0x1047], 0xff                   ; 07AAC  0x2E, 0x80, 0x3E, 0x47, 0x10, 0xFF
  jne loc_07ACF                                ; 07AB2  0x75, 0x1B
  test al, 0x80                                ; 07AB4  0xA8, 0x80
  jne loc_07B0E                                ; 07AB6  0x75, 0x56
  mov byte [cs:0x1047], 0                      ; 07AB8  0x2E, 0xC6, 0x06, 0x47, 0x10, 0x00
  mov bx, 0x2c52                               ; 07ABE  0xBB, 0x52, 0x2C
  xlatb                                        ; 07AC1  0xD7
  mov [cs:0x1040], al                          ; 07AC2  0x2E, 0xA2, 0x40, 0x10
  mov dx, 0x13                                 ; 07AC6  0xBA, 0x13, 0x00
  call rtm_call_helper                         ; 07AC9  0xE8, 0xF4, 0xFD
  jmp near loc_07BA5                           ; 07ACC  0xE9, 0xD6, 0x00

loc_07ACF:                                     ; 07ACF
  cmp byte [cs:0x1048], 0xff                   ; 07ACF  0x2E, 0x80, 0x3E, 0x48, 0x10, 0xFF
  jne loc_07AE3                                ; 07AD5  0x75, 0x0C
  mov byte [cs:0x1048], 0                      ; 07AD7  0x2E, 0xC6, 0x06, 0x48, 0x10, 0x00
  call sub_094EB                               ; 07ADD  0xE8, 0x0B, 0x1A
  jmp near loc_07BA5                           ; 07AE0  0xE9, 0xC2, 0x00

loc_07AE3:                                     ; 07AE3
  cmp al, 0xe3                                 ; 07AE3  0x3C, 0xE3
  jne loc_07AF0                                ; 07AE5  0x75, 0x09
  mov byte [cs:0x1048], 0xff                   ; 07AE7  0x2E, 0xC6, 0x06, 0x48, 0x10, 0xFF
  jmp near loc_07BA5                           ; 07AED  0xE9, 0xB5, 0x00

loc_07AF0:                                     ; 07AF0
  cmp al, 0xe                                  ; 07AF0  0x3C, 0x0E
  jne loc_07B0E                                ; 07AF2  0x75, 0x1A
  test byte [cs:0x1045], 2                     ; 07AF4  0x2E, 0xF6, 0x06, 0x45, 0x10, 0x02
  je loc_07B0E                                 ; 07AFA  0x74, 0x12
  test byte [cs:0x1045], 0x10                  ; 07AFC  0x2E, 0xF6, 0x06, 0x45, 0x10, 0x10
  je loc_07B0E                                 ; 07B02  0x74, 0x0A
  mov bx, 0x5fa4                               ; 07B04  0xBB, 0xA4, 0x5F
  jmp near loc_0B24F                           ; 07B07  0xE9, 0x45, 0x37
  db 0xCC                                      ; 07B0A  int3
  jmp near loc_07BA5                           ; 07B0B  0xE9, 0x97, 0x00

loc_07B0E:                                     ; 07B0E
  and al, 0x7f                                 ; 07B0E  0x24, 0x7F
  cmp al, 0x62                                 ; 07B10  0x3C, 0x62
  jle loc_07B17                                ; 07B12  0x7E, 0x03
  jmp near loc_07BA5                           ; 07B14  0xE9, 0x8E, 0x00

loc_07B17:                                     ; 07B17
  mov cx, 5                                    ; 07B17  0xB9, 0x05, 0x00
  mov ah, 2                                    ; 07B1A  0xB4, 0x02
  mov bx, 0x1049                               ; 07B1C  0xBB, 0x49, 0x10

loc_07B1F:                                     ; 07B1F
  cmp al, [bx]                                 ; 07B1F  0x3A, 0x07
  jne loc_07B26                                ; 07B21  0x75, 0x03
  jmp near loc_07BA8                           ; 07B23  0xE9, 0x82, 0x00

loc_07B26:                                     ; 07B26
  shl ah, 1                                    ; 07B26  0xD0, 0xE4
  inc bx                                       ; 07B28  0x43
  loop loc_07B1F                               ; 07B29  0xE2, 0xF4
  mov al, [cs:0x1044]                          ; 07B2B  0x2E, 0xA0, 0x44, 0x10
  db 0x0A, 0xC0                                ; 07B2F  or al, al
  jns loc_07B36                                ; 07B31  0x79, 0x03
  jmp near loc_07BA5                           ; 07B33  0xE9, 0x6F, 0x00

loc_07B36:                                     ; 07B36
  mov bx, 0x2d18                               ; 07B36  0xBB, 0x18, 0x2D
  test byte [cs:0x1045], 2                     ; 07B39  0x2E, 0xF6, 0x06, 0x45, 0x10, 0x02
  jne loc_07B4F                                ; 07B3F  0x75, 0x0E
  mov bx, 0x2cb5                               ; 07B41  0xBB, 0xB5, 0x2C
  test byte [cs:0x1045], 0xc                   ; 07B44  0x2E, 0xF6, 0x06, 0x45, 0x10, 0x0C
  jne loc_07B4F                                ; 07B4A  0x75, 0x03
  mov bx, 0x2c52                               ; 07B4C  0xBB, 0x52, 0x2C

loc_07B4F:                                     ; 07B4F
  xlatb                                        ; 07B4F  0xD7
  cmp al, 0xff                                 ; 07B50  0x3C, 0xFF
  je loc_07BA5                                 ; 07B52  0x74, 0x51
  db 0x98                                      ; 07B54  cwde
  mov [cs:0x103f], ah                          ; 07B55  0x2E, 0x88, 0x26, 0x3F, 0x10
  test byte [cs:0x1046], 0x20                  ; 07B5A  0x2E, 0xF6, 0x06, 0x46, 0x10, 0x20
  je loc_07B74                                 ; 07B60  0x74, 0x12
  cmp al, 0x7e                                 ; 07B62  0x3C, 0x7E
  ja loc_07B74                                 ; 07B64  0x77, 0x0E
  cmp al, 0x61                                 ; 07B66  0x3C, 0x61
  jae loc_07B72                                ; 07B68  0x73, 0x08
  cmp al, 0x5e                                 ; 07B6A  0x3C, 0x5E
  ja loc_07B74                                 ; 07B6C  0x77, 0x06
  cmp al, 0x41                                 ; 07B6E  0x3C, 0x41
  jb loc_07B74                                 ; 07B70  0x72, 0x02

loc_07B72:                                     ; 07B72
  xor al, 0x20                                 ; 07B72  0x34, 0x20

loc_07B74:                                     ; 07B74
  and al, 0x7f                                 ; 07B74  0x24, 0x7F
  test byte [cs:0x1045], 0x10                  ; 07B76  0x2E, 0xF6, 0x06, 0x45, 0x10, 0x10
  je loc_07B8E                                 ; 07B7C  0x74, 0x10
  test ah, ah                                  ; 07B7E  0x84, 0xE4
  jns loc_07B8C                                ; 07B80  0x79, 0x0A
  cmp al, 0xb                                  ; 07B82  0x3C, 0x0B
  ja loc_07B8E                                 ; 07B84  0x77, 0x08
  mov bx, 0x104e                               ; 07B86  0xBB, 0x4E, 0x10
  xlatb                                        ; 07B89  0xD7
  jmp short loc_07B8E                          ; 07B8A  0xEB, 0x02

loc_07B8C:                                     ; 07B8C
  or al, 0x80                                  ; 07B8C  0x0C, 0x80

loc_07B8E:                                     ; 07B8E
  mov [cs:0x103e], al                          ; 07B8E  0x2E, 0xA2, 0x3E, 0x10
  mov dx, [cs:0x1041]                          ; 07B92  0x2E, 0x8B, 0x16, 0x41, 0x10
  cmp dx, 0x18                                 ; 07B97  0x83, 0xFA, 0x18
  jne loc_07BA2                                ; 07B9A  0x75, 0x06
  mov byte [cs:0x1043], 0xff                   ; 07B9C  0x2E, 0xC6, 0x06, 0x43, 0x10, 0xFF

loc_07BA2:                                     ; 07BA2
  call rtm_call_helper                         ; 07BA2  0xE8, 0x1B, 0xFD

loc_07BA5:                                     ; 07BA5
  jmp near loc_0AF3E                           ; 07BA5  0xE9, 0x96, 0x33

loc_07BA8:                                     ; 07BA8
  cmp al, 0x28                                 ; 07BA8  0x3C, 0x28
  je loc_07BC4                                 ; 07BAA  0x74, 0x18
  test byte [cs:0x1044], 0x80                  ; 07BAC  0x2E, 0xF6, 0x06, 0x44, 0x10, 0x80
  je loc_07BBD                                 ; 07BB2  0x74, 0x09
  not ah                                       ; 07BB4  0xF6, 0xD4
  and [cs:0x1045], ah                          ; 07BB6  0x2E, 0x20, 0x26, 0x45, 0x10
  jmp short loc_07BDC                          ; 07BBB  0xEB, 0x1F

loc_07BBD:                                     ; 07BBD
  or [cs:0x1045], ah                           ; 07BBD  0x2E, 0x08, 0x26, 0x45, 0x10
  jmp short loc_07BDC                          ; 07BC2  0xEB, 0x18

loc_07BC4:                                     ; 07BC4
  test byte [cs:0x1044], 0x80                  ; 07BC4  0x2E, 0xF6, 0x06, 0x44, 0x10, 0x80
  jne loc_07BDC                                ; 07BCA  0x75, 0x10
  xor [cs:0x1046], ah                          ; 07BCC  0x2E, 0x30, 0x26, 0x46, 0x10
  cmp byte [cs:0x224e], 0xff                   ; 07BD1  0x2E, 0x80, 0x3E, 0x4E, 0x22, 0xFF
  je loc_07BDC                                 ; 07BD7  0x74, 0x03
  call sub_08C5F                               ; 07BD9  0xE8, 0x83, 0x10

loc_07BDC:                                     ; 07BDC
  jmp short loc_07BA5                          ; 07BDC  0xEB, 0xC7
  db 0x00, 0x00, 0x00                          ; 07BDE  ...
  add ax, strict word 0                        ; 07BE1  05 00 00
  db 0x00, 0x00                                ; 07BE4
  db 0x00, 0x00                                ; 07BE6
  add [di], bl                                 ; 07BE8  0x00, 0x1D
  sub dh, [ss:bx]                              ; 07BEA  0x36, 0x2A, 0x37
  sub [bp + di], ah                            ; 07BED  0x28, 0x23
  and al, 0x25                                 ; 07BEF  0x24, 0x25
  db 0x26, 0x27                                ; 07BF1  daa
  sub [bx + di], ch                            ; 07BF3  0x28, 0x29
  sub ch, [bp + di]                            ; 07BF5  0x2A, 0x2B
  sub al, 0x1d                                 ; 07BF7  0x2C, 0x1D
  push ds                                      ; 07BF9  0x1E
  call xios_switch_to_priv_stack               ; 07BFA  0xE8, 0x20, 0x33
  cld                                          ; 07BFD  0xFC

i_crt:
crt_init_irst_ca:                              ; 07BFE
  mov dx, PORT_CRT_RESET                       ; 07BFE  0xBA, 0x30, 0x02
  out dx, ax                                   ; 07C01  0xEF
  mov dx, PORT_CRT_CA                          ; 07C02  0xBA, 0x40, 0x02
  out dx, ax                                   ; 07C05  0xEF
  inc byte [cs:0x10b3]                         ; 07C06  0x2E, 0xFE, 0x06, 0xB3, 0x10
  cmp byte [cs:0x10b1], 0                      ; 07C0B  0x2E, 0x80, 0x3E, 0xB1, 0x10, 0x00
  je loc_07C38                                 ; 07C11  0x74, 0x25
  mov dx, PORT_PCB_T1_CON                      ; 07C13  0xBA, 0x5E, 0xFF
  cmp byte [cs:0x10b2], 0                      ; 07C16  0x2E, 0x80, 0x3E, 0xB2, 0x10, 0x00
  jne loc_07C28                                ; 07C1C  0x75, 0x0A
  mov byte [cs:0x10b2], 8                      ; 07C1E  0x2E, 0xC6, 0x06, 0xB2, 0x10, 0x08
  mov ax, 0xc003                               ; 07C24  0xB8, 0x03, 0xC0
  out dx, ax                                   ; 07C27  0xEF

loc_07C28:                                     ; 07C28
  dec byte [cs:0x10b2]                         ; 07C28  0x2E, 0xFE, 0x0E, 0xB2, 0x10
  jne loc_07C38                                ; 07C2D  0x75, 0x09
  mov ax, 0xc002                               ; 07C2F  0xB8, 0x02, 0xC0
  out dx, ax                                   ; 07C32  0xEF
  dec byte [cs:0x10b1]                         ; 07C33  0x2E, 0xFE, 0x0E, 0xB1, 0x10

loc_07C38:                                     ; 07C38
  cmp byte [cs:0xc0c], 0                       ; 07C38  0x2E, 0x80, 0x3E, 0x0C, 0x0C, 0x00
  je loc_07C46                                 ; 07C3E  0x74, 0x06
  mov dx, 1                                    ; 07C40  0xBA, 0x01, 0x00
  call rtm_call_helper                         ; 07C43  0xE8, 0x7A, 0xFC

loc_07C46:                                     ; 07C46
  call far [cs:0x4325]                         ; 07C46  0x2E, 0xFF, 0x1E, 0x25, 0x43
  call eoi_helper                              ; 07C4B  0xE8, 0xC3, 0x32
  jmp near loc_0AF3E                           ; 07C4E  0xE9, 0xED, 0x32
  db 0x00, 0x00, 0x00, 0x00                    ; 07C51  ....
  cmp di, [si]                                 ; 07C55  0x3B, 0x3C
  cmp ax, 0x3f3e                               ; 07C57  0x3D, 0x3E, 0x3F
  inc ax                                       ; 07C5A  0x40
  inc cx                                       ; 07C5B  0x41
  inc dx                                       ; 07C5C  0x42
  inc bx                                       ; 07C5D  0x43
  inc sp                                       ; 07C5E  0x44
  inc bp                                       ; 07C5F  0x45
  inc si                                       ; 07C60  0x46
  inc di                                       ; 07C61  0x47
  dec ax                                       ; 07C62  0x48
  dec cx                                       ; 07C63  0x49
  dec dx                                       ; 07C64  0x4A
  dec bx                                       ; 07C65  0x4B
  dec sp                                       ; 07C66  0x4C
  dec bp                                       ; 07C67  0x4D
  dec si                                       ; 07C68  0x4E
  dec di                                       ; 07C69  0x4F
  push ax                                      ; 07C6A  0x50
  push cx                                      ; 07C6B  0x51
  push dx                                      ; 07C6C  0x52
  push bx                                      ; 07C6D  0x53
  push bp                                      ; 07C6E  0x55
  push si                                      ; 07C6F  0x56
  push di                                      ; 07C70  0x57
  pop ax                                       ; 07C71  0x58
  pop cx                                       ; 07C72  0x59
  pop dx                                       ; 07C73  0x5A
  pop bx                                       ; 07C74  0x5B
  pop sp                                       ; 07C75  0x5C
  pop bp                                       ; 07C76  0x5D
  pop si                                       ; 07C77  0x5E
  db 0x61                                      ; 07C78  popa
  db 0x62, 0x63, 0x64                          ; 07C79  bound sp, dword [bp + di + 0x64]
  db 0x65, 0x66, 0x67, 0x68, 0x69, 0x6A, 0x6B, 0x6C  ; 07C7C  push 0x6c6b6a69
  db 0x6D                                      ; 07C84  insw
  db 0x6E                                      ; 07C85  outsb
  db 0x6F                                      ; 07C86  outsw
  db 0x70, 0x71                                ; 07C87  jo 0x7cfa
  jb loc_07CFE                                 ; 07C89  0x72, 0x73
  db 0x74, 0x75                                ; 07C8B  je 0x7d02
  db 0x76, 0x77                                ; 07C8D  jbe 0x7d06
  db 0x78, 0x79                                ; 07C8F  js 0x7d0a
  db 0x7A, 0x7B                                ; 07C91  jp 0x7d0e
  jl loc_07D12                                 ; 07C93  0x7C, 0x7D
  jle loc_07CEB                                ; 07C95  0x7E, 0x54

sub_7c97:                                      ; 07C97
  mov si, [bx + 0x76]                          ; 07C97  0x8B, 0x77, 0x76
  mov cl, 0x14                                 ; 07C9A  0xB1, 0x14
  cmp al, 0xc                                  ; 07C9C  0x3C, 0x0C
  jb loc_07CA8                                 ; 07C9E  0x72, 0x08
  sub al, 0xc                                  ; 07CA0  0x2C, 0x0C
  add si, 0xf0                                 ; 07CA2  0x81, 0xC6, 0xF0, 0x00
  mov cl, 4                                    ; 07CA6  0xB1, 0x04

loc_07CA8:                                     ; 07CA8
  db 0xF6, 0xE1                                ; 07CA8  mul cl
  db 0x03, 0xF0                                ; 07CAA  add si, ax
  ret                                          ; 07CAC  0xC3
xios_int28_fn_15_reserved:                   ; 07CAD
  call sub_08FDC                               ; 07CAD  0xE8, 0x2C, 0x13
  mov bx, [bx + 0x76]                          ; 07CB0  0x8B, 0x5F, 0x76
  push ds                                      ; 07CB3  0x1E
  pop es                                       ; 07CB4  0x07
  ret                                          ; 07CB5  0xC3
io_const:
  jmp near sub_0A8A9                           ; 07CB6  0xE9, 0xF0, 0x2B

io_conin:
loc_07CB9:                                     ; 07CB9
  cmp dl, 1                                    ; 07CB9  0x80, 0xFA, 0x01
  jb loc_07CC1                                 ; 07CBC  0x72, 0x03
  jmp near loc_0A7F1                           ; 07CBE  0xE9, 0x30, 0x2B

loc_07CC1:                                     ; 07CC1
  mov bx, [cs:0x2b58]                          ; 07CC1  0x2E, 0x8B, 0x1E, 0x58, 0x2B
  cmp byte [bx + 0x7a], 0                      ; 07CC6  0x80, 0x7F, 0x7A, 0x00
  jne loc_07D18                                ; 07CCA  0x75, 0x4C

loc_07CCC:                                     ; 07CCC
  push bx                                      ; 07CCC  0x53
  mov dx, 5                                    ; 07CCD  0xBA, 0x05, 0x00
  call rtm_timer_wait                          ; 07CD0  0xE8, 0xFE, 0xFB
  pop bx                                       ; 07CD3  0x5B
  mov ax, [cs:0x2a5c]                          ; 07CD4  0x2E, 0xA1, 0x5C, 0x2A
  mov [cs:0x2a5e], ax                          ; 07CD8  0x2E, 0xA3, 0x5E, 0x2A
  mov ax, [cs:0x103e]                          ; 07CDC  0x2E, 0xA1, 0x3E, 0x10
  test ah, ah                                  ; 07CE0  0x84, 0xE4
  je loc_07CFD                                 ; 07CE2  0x74, 0x19
  cmp al, 0x7a                                 ; 07CE4  0x3C, 0x7A
  je loc_07D2D                                 ; 07CE6  0x74, 0x45
  cmp al, 0x7b                                 ; 07CE8  0x3C, 0x7B
  db 0x74                                      ; 07CEA  t

loc_07CEB:                                     ; 07CEB
  inc bx                                       ; 07CEB  0x43
  cmp al, 0x7d                                 ; 07CEC  0x3C, 0x7D
  je loc_07D35                                 ; 07CEE  0x74, 0x45
  cmp al, 0x7e                                 ; 07CF0  0x3C, 0x7E
  jne loc_07CF7                                ; 07CF2  0x75, 0x03
  jmp near loc_07EEC                           ; 07CF4  0xE9, 0xF5, 0x01

loc_07CF7:                                     ; 07CF7
  cmp al, 0x70                                 ; 07CF7  0x3C, 0x70
  jb loc_07CFE                                 ; 07CF9  0x72, 0x03
  and al, 0                                    ; 07CFB  0x24, 0x00

loc_07CFD:                                     ; 07CFD
  ret                                          ; 07CFD  0xC3

loc_07CFE:                                     ; 07CFE
  test word [bx + 0x6b], 0x800                 ; 07CFE  0xF7, 0x47, 0x6B, 0x00, 0x08
  je loc_07D0F                                 ; 07D03  0x74, 0x0A
  mov bx, 0x10b5                               ; 07D05  0xBB, 0xB5, 0x10
  xlatb                                        ; 07D08  0xD7
  db 0x32, 0xE4                                ; 07D09  xor ah, ah
  or al, 0x80                                  ; 07D0B  0x0C, 0x80
  jmp short loc_07CFD                          ; 07D0D  0xEB, 0xEE

loc_07D0F:                                     ; 07D0F
  call sub_7c97                                ; 07D0F  0xE8, 0x85, 0xFF

loc_07D12:                                     ; 07D12
  mov [bx + 0x78], si                          ; 07D12  0x89, 0x77, 0x78
  mov [bx + 0x7a], cl                          ; 07D15  0x88, 0x4F, 0x7A

loc_07D18:                                     ; 07D18
  mov si, [bx + 0x78]                          ; 07D18  0x8B, 0x77, 0x78
  lodsb                                        ; 07D1B  0xAC
  mov [bx + 0x78], si                          ; 07D1C  0x89, 0x77, 0x78
  dec byte [bx + 0x7a]                         ; 07D1F  0xFE, 0x4F, 0x7A
  db 0x32, 0xE4                                ; 07D22  xor ah, ah
  db 0x0A, 0xC0                                ; 07D24  or al, al
  jne loc_07CFD                                ; 07D26  0x75, 0xD5
  mov [bx + 0x7a], al                          ; 07D28  0x88, 0x47, 0x7A
  jmp short loc_07CCC                          ; 07D2B  0xEB, 0x9F

loc_07D2D:                                     ; 07D2D
  jmp short loc_07CCC                          ; 07D2D  0xEB, 0x9D

loc_07D2F:                                     ; 07D2F
  jmp near loc_07CCC                           ; 07D2F  0xE9, 0x9A, 0xFF

loc_07D32:                                     ; 07D32
  call sub_09312                               ; 07D32  0xE8, 0xDD, 0x15

loc_07D35:                                     ; 07D35
  mov al, 0xff                                 ; 07D35  0xB0, 0xFF
  xchg [cs:0x224e], al                         ; 07D37  0x2E, 0x86, 0x06, 0x4E, 0x22
  cmp al, 0xff                                 ; 07D3C  0x3C, 0xFF
  je loc_07D32                                 ; 07D3E  0x74, 0xF2
  mov [cs:0x224f], bx                          ; 07D40  0x2E, 0x89, 0x1E, 0x4F, 0x22
  mov [cs:0x224e], al                          ; 07D45  0x2E, 0xA2, 0x4E, 0x22
  mov bp, es                                   ; 07D49  0x8C, 0xC5
  push cx                                      ; 07D4B  0x51
  push ds                                      ; 07D4C  0x1E
  pop es                                       ; 07D4D  0x07
  mov di, 0x614a                               ; 07D4E  0xBF, 0x4A, 0x61
  push di                                      ; 07D51  0x57
  mov ax, 0x820                                ; 07D52  0xB8, 0x20, 0x08
  mov cx, 0x50                                 ; 07D55  0xB9, 0x50, 0x00
  rep stosw                                    ; 07D58  0xF3, 0xAB
  pop di                                       ; 07D5A  0x5F
  mov si, 0x47ab                               ; 07D5B  0xBE, 0xAB, 0x47
  lodsb                                        ; 07D5E  0xAC
  call sub_07DFE                               ; 07D5F  0xE8, 0x9C, 0x00

loc_07D62:                                     ; 07D62
  mov si, 0x12a7                               ; 07D62  0xBE, 0xA7, 0x12

loc_07D65:                                     ; 07D65
  lodsw                                        ; 07D65  0xAD
  db 0x0B, 0xC0                                ; 07D66  or ax, ax
  je loc_07D62                                 ; 07D68  0x74, 0xF8
  xchg di, ax                                  ; 07D6A  0x97
  push si                                      ; 07D6B  0x56
  push di                                      ; 07D6C  0x57
  mov si, [di - 4]                             ; 07D6D  0x8B, 0x75, 0xFC
  lodsb                                        ; 07D70  0xAC
  mov di, 0x6186                               ; 07D71  0xBF, 0x86, 0x61
  call sub_07DFE                               ; 07D74  0xE8, 0x87, 0x00
  mov cx, 0x14                                 ; 07D77  0xB9, 0x14, 0x00
  mov al, 0x20                                 ; 07D7A  0xB0, 0x20
  rep stosw                                    ; 07D7C  0xF3, 0xAB
  pop di                                       ; 07D7E  0x5F
  mov bx, [cs:0x2b58]                          ; 07D7F  0x2E, 0x8B, 0x1E, 0x58, 0x2B
  mov si, [di - 6]                             ; 07D84  0x8B, 0x75, 0xFA
  mov bl, [bx + si]                            ; 07D87  0x8A, 0x18
  db 0x32, 0xFF                                ; 07D89  xor bh, bh
  shl bx, 1                                    ; 07D8B  0xD1, 0xE3
  pop si                                       ; 07D8D  0x5E
  jmp short loc_07D92                          ; 07D8E  0xEB, 0x02

loc_07D90:                                     ; 07D90
  db 0x33, 0xDB                                ; 07D90  xor bx, bx

loc_07D92:                                     ; 07D92
  mov ax, [bx + di]                            ; 07D92  0x8B, 0x01
  db 0x0B, 0xC0                                ; 07D94  or ax, ax
  je loc_07D90                                 ; 07D96  0x74, 0xF8
  push si                                      ; 07D98  0x56
  push di                                      ; 07D99  0x57
  db 0x8B, 0xF0                                ; 07D9A  mov si, ax
  mov al, [di - 7]                             ; 07D9C  0x8A, 0x45, 0xF9
  mov di, 0x61b8                               ; 07D9F  0xBF, 0xB8, 0x61
  call sub_07DFE                               ; 07DA2  0xE8, 0x59, 0x00
  mov cx, 8                                    ; 07DA5  0xB9, 0x08, 0x00
  mov al, 0x20                                 ; 07DA8  0xB0, 0x20
  rep stosw                                    ; 07DAA  0xF3, 0xAB
  mov dx, [cs:0x1041]                          ; 07DAC  0x2E, 0x8B, 0x16, 0x41, 0x10
  push bx                                      ; 07DB1  0x53
  mov es, bp                                   ; 07DB2  0x8E, 0xC5
  call rtm_timer_wait                          ; 07DB4  0xE8, 0x1A, 0xFB
  mov bp, es                                   ; 07DB7  0x8C, 0xC5
  push ds                                      ; 07DB9  0x1E
  pop es                                       ; 07DBA  0x07
  pop bx                                       ; 07DBB  0x5B
  pop di                                       ; 07DBC  0x5F
  pop si                                       ; 07DBD  0x5E
  mov ax, [cs:0x103e]                          ; 07DBE  0x2E, 0xA1, 0x3E, 0x10
  cmp ax, 0xff7d                               ; 07DC2  0x3D, 0x7D, 0xFF
  je loc_07DE1                                 ; 07DC5  0x74, 0x1A
  cmp ax, strict word 0x1b                     ; 07DC7  3D 1B 00
  je loc_07D65                                 ; 07DCA  0x74, 0x99
  cmp ax, strict word 0xd                      ; 07DCC  3D 0D 00
  je loc_07DDB                                 ; 07DCF  0x74, 0x0A
  cmp ax, strict word 0x20                     ; 07DD1  3D 20 00
  jne loc_07D92                                ; 07DD4  0x75, 0xBC
  inc bx                                       ; 07DD6  0x43
  inc bx                                       ; 07DD7  0x43
  jmp near loc_07D92                           ; 07DD8  0xE9, 0xB7, 0xFF

loc_07DDB:                                     ; 07DDB
  call sub_07DF0                               ; 07DDB  0xE8, 0x12, 0x00
  jmp near loc_07D65                           ; 07DDE  0xE9, 0x84, 0xFF

loc_07DE1:                                     ; 07DE1
  call sub_07DF0                               ; 07DE1  0xE8, 0x0C, 0x00
  mov es, bp                                   ; 07DE4  0x8E, 0xC5
  mov cx, 0xffff                               ; 07DE6  0xB9, 0xFF, 0xFF
  call sub_08C61                               ; 07DE9  0xE8, 0x75, 0x0E
  pop cx                                       ; 07DEC  0x59
  jmp near loc_07CB9                           ; 07DED  0xE9, 0xC9, 0xFE

sub_07DF0:                                     ; 07DF0
  shr bx, 1                                    ; 07DF0  0xD1, 0xEB
  xchg bx, ax                                  ; 07DF2  0x93
  push si                                      ; 07DF3  0x56
  mov bx, [cs:0x2b58]                          ; 07DF4  0x2E, 0x8B, 0x1E, 0x58, 0x2B
  call word [di - 2]                           ; 07DF9  0xFF, 0x55, 0xFE
  pop si                                       ; 07DFC  0x5E
  ret                                          ; 07DFD  0xC3

sub_07DFE:                                     ; 07DFE
  db 0x98                                      ; 07DFE  cwde
  xchg cx, ax                                  ; 07DFF  0x91
  mov ah, 8                                    ; 07E00  0xB4, 0x08

loc_07E02:                                     ; 07E02
  lodsb                                        ; 07E02  0xAC
  stosw                                        ; 07E03  0xAB
  loop loc_07E02                               ; 07E04  0xE2, 0xFC
  ret                                          ; 07E06  0xC3

loc_07E07:                                     ; 07E07
  mov [bx + 0x74], al                          ; 07E07  0x88, 0x47, 0x74
  jmp near sub_096CF                           ; 07E0A  0xE9, 0xC2, 0x18
  db 0x8A, 0xE8                                ; 07E0D  mov ch, al
  mov cl, 0xa                                  ; 07E0F  0xB1, 0x0A

sub_7e11:                                      ; 07E11
  mov [bx + 0x72], cx                          ; 07E11  0x89, 0x4F, 0x72
  jmp near sub_096CF                           ; 07E14  0xE9, 0xB8, 0x18
  mov [bx + 0x71], al                          ; 07E17  0x88, 0x47, 0x71
  mov [cs:0x2c08], al                          ; 07E1A  0x2E, 0xA2, 0x08, 0x2C
  ret                                          ; 07E1E  0xC3
  mov [bx + 0x7f], al                          ; 07E1F  0x88, 0x47, 0x7F
  ret                                          ; 07E22  0xC3
  push bx                                      ; 07E23  0x53
  push cx                                      ; 07E24  0x51
  db 0x32, 0xE4                                ; 07E25  xor ah, ah
  mov bx, 0x2b5d                               ; 07E27  0xBB, 0x5D, 0x2B
  mov [bx + 0x83], al                          ; 07E2A  0x88, 0x87, 0x83, 0x00
  db 0x8B, 0xD8                                ; 07E2E  mov bx, ax
  mov cl, 4                                    ; 07E30  0xB1, 0x04
  shl bx, cl                                   ; 07E32  0xD3, 0xE3
  db 0x2B, 0xD8                                ; 07E34  sub bx, ax
  mov cl, 2                                    ; 07E36  0xB1, 0x02
  shl bx, cl                                   ; 07E38  0xD3, 0xE3
  mov [cs:0x2a5c], bx                          ; 07E3A  0x2E, 0x89, 0x1E, 0x5C, 0x2A
  mov [cs:0x2a5e], bx                          ; 07E3F  0x2E, 0x89, 0x1E, 0x5E, 0x2A
  pop cx                                       ; 07E44  0x59
  pop bx                                       ; 07E45  0x5B
  ret                                          ; 07E46  0xC3
  db 0xC7                                      ; 07E47  .
  adc bh, [bp + si - 0x1bee]                   ; 07E48  0x12, 0xBA, 0x12, 0xE4
  adc cl, [bp + si]                            ; 07E4C  0x12, 0x0A
  db 0x13, 0xF1                                ; 07E4E  adc si, cx
  adc al, [bx + si]                            ; 07E50  0x12, 0x00
  add [si], al                                 ; 07E52  0x00, 0x04
  je loc_07E56                                 ; 07E54  0x74, 0x00

loc_07E56:                                     ; 07E56
  rol byte [bx + 0x67], 0x12                   ; 07E56  0xC0, 0x47, 0x67, 0x12
  cmp ax, 0x4148                               ; 07E5A  0x3D, 0x48, 0x41
  dec ax                                       ; 07E5D  0x48
  db 0x00, 0x00                                ; 07E5E
  db 0x02, 0x73, 0x00                          ; 07E60  add dh, byte [bp + di]
  int 0x47                                     ; 07E63  0xCD, 0x47
  db 0x6D                                      ; 07E65  insw
  adc bh, [0x3c13]                             ; 07E66  0x12, 0x3E, 0x13, 0x3C
  adc di, [bp + si]                            ; 07E6A  0x13, 0x3A
  adc di, [bx + si]                            ; 07E6C  0x13, 0x38
  adc si, [0x3413]                             ; 07E6E  0x13, 0x36, 0x13, 0x34
  adc si, [bp + si]                            ; 07E72  0x13, 0x32
  adc si, [bx + si]                            ; 07E74  0x13, 0x30
  adc bp, [0x2c13]                             ; 07E76  0x13, 0x2E, 0x13, 0x2C
  adc ax, [bx + si]                            ; 07E7A  0x13, 0x00
  add [si], al                                 ; 07E7C  0x00, 0x04
  jno loc_07E80                                ; 07E7E  0x71, 0x00

loc_07E80:                                     ; 07E80
  db 0xDA, 0x47, 0x77                          ; 07E80  fiadd dword [bx + 0x77]
  adc bh, [di]                                 ; 07E83  0x12, 0x3D
  dec ax                                       ; 07E85  0x48
  inc cx                                       ; 07E86  0x41
  dec ax                                       ; 07E87  0x48
  db 0x00, 0x00                                ; 07E88
  pop es                                       ; 07E8A  0x07
  jg loc_07E8D                                 ; 07E8B  0x7F, 0x00

loc_07E8D:                                     ; 07E8D
  out 0x47, ax                                 ; 07E8D  0xE7, 0x47
  jg loc_07EA3                                 ; 07E8F  0x7F, 0x12
  add ax, 0xc48                                ; 07E91  0x05, 0x48, 0x0C
  dec ax                                       ; 07E94  0x48
  adc cx, [bx + si + 0x1a]                     ; 07E95  0x13, 0x48, 0x1A
  dec ax                                       ; 07E98  0x48
  and [bx + si + 0x28], cx                     ; 07E99  0x21, 0x48, 0x28
  dec ax                                       ; 07E9C  0x48
  db 0x2F                                      ; 07E9D  das
  dec ax                                       ; 07E9E  0x48
  db 0x36, 0x48                                ; 07E9F  dec ax
  db 0x00, 0x00                                ; 07EA1

loc_07EA3:                                     ; 07EA3
  add al, [bp + di - 0xa00]                    ; 07EA3  0x02, 0x83, 0x00, 0xF6
  inc di                                       ; 07EA7  0x47
  adc word [bp + si], 0x4a                     ; 07EA8  0x83, 0x12, 0x4A
  adc bp, [si]                                 ; 07EAB  0x13, 0x2C
  adc bp, [0x3013]                             ; 07EAD  0x13, 0x2E, 0x13, 0x30
  adc si, [bp + si]                            ; 07EB1  0x13, 0x32
  adc si, [si]                                 ; 07EB3  0x13, 0x34
  adc si, [0x3813]                             ; 07EB5  0x13, 0x36, 0x13, 0x38
  adc di, [bp + si]                            ; 07EB9  0x13, 0x3A
  adc di, [si]                                 ; 07EBB  0x13, 0x3C
  adc di, [0x4013]                             ; 07EBD  0x13, 0x3E, 0x13, 0x40
  adc ax, [bp + si + 0x13]                     ; 07EC1  0x13, 0x42, 0x13
  inc sp                                       ; 07EC4  0x44
  adc ax, [bp + 0x13]                          ; 07EC5  0x13, 0x46, 0x13
  dec ax                                       ; 07EC8  0x48
  adc ax, [bx + si]                            ; 07EC9  0x13, 0x00
  add [bx + di], dh                            ; 07ECB  0x00, 0x31
  and [bp + si], dh                            ; 07ECD  0x20, 0x32
  and [bp + di], dh                            ; 07ECF  0x20, 0x33
  and [si], dh                                 ; 07ED1  0x20, 0x34
  and [di], dh                                 ; 07ED3  0x20, 0x35
  and [0x3720], dh                             ; 07ED5  0x20, 0x36, 0x20, 0x37
  and [bx + si], bh                            ; 07ED9  0x20, 0x38
  and [bx + di], bh                            ; 07EDB  0x20, 0x39
  and [bx + di], dh                            ; 07EDD  0x20, 0x31
  xor [bx + di], dh                            ; 07EDF  0x30, 0x31
  xor [bx + di], si                            ; 07EE1  0x31, 0x31
  xor dh, [bx + di]                            ; 07EE3  0x32, 0x31
  xor si, [bx + di]                            ; 07EE5  0x33, 0x31
  xor al, 0x31                                 ; 07EE7  0x34, 0x31
  xor ax, 0x209b                               ; 07EE9  0x35, 0x9B, 0x20

loc_07EEC:                                     ; 07EEC
  test byte [bx + 0x6b], 4                     ; 07EEC  0xF6, 0x47, 0x6B, 0x04
  je loc_07EF5                                 ; 07EF0  0x74, 0x03
  jmp near loc_07CC1                           ; 07EF2  0xE9, 0xCC, 0xFD

loc_07EF5:                                     ; 07EF5
  mov bx, [bx + 0x5c]                          ; 07EF5  0x8B, 0x5F, 0x5C
  mov si, [bx]                                 ; 07EF8  0x8B, 0x37
  mov dl, [si + 0x24]                          ; 07EFA  0x8A, 0x54, 0x24
  push dx                                      ; 07EFD  0x52
  mov cl, 0xa0                                 ; 07EFE  0xB1, 0xA0
  call rtm_timer_wait2                         ; 07F00  0xE8, 0xD0, 0xF9
  mov cl, 0xa1                                 ; 07F03  0xB1, 0xA1
  call rtm_timer_wait2                         ; 07F05  0xE8, 0xCB, 0xF9
  pop dx                                       ; 07F08  0x5A
  mov si, 0x49e3                               ; 07F09  0xBE, 0xE3, 0x49
  db 0x0B, 0xC0                                ; 07F0C  or ax, ax
  jne loc_07F59                                ; 07F0E  0x75, 0x49
  push dx                                      ; 07F10  0x52
  call sub_0AD30                               ; 07F11  0xE8, 0x1C, 0x2E
  pop dx                                       ; 07F14  0x5A
  mov si, 0x49cd                               ; 07F15  0xBE, 0xCD, 0x49
  db 0x0A, 0xC0                                ; 07F18  or al, al
  je loc_07F59                                 ; 07F1A  0x74, 0x3D
  mov cl, 0xc                                  ; 07F1C  0xB1, 0x0C
  call sub_07F88                               ; 07F1E  0xE8, 0x67, 0x00
  mov bx, [cs:0x2b58]                          ; 07F21  0x2E, 0x8B, 0x1E, 0x58, 0x2B
  mov cx, [bx + 0x48]                          ; 07F26  0x8B, 0x4F, 0x48
  test byte [cs:0x2b5a], 0xff                  ; 07F29  0x2E, 0xF6, 0x06, 0x5A, 0x2B, 0xFF
  jne loc_07F37                                ; 07F2F  0x75, 0x06
  mov bx, 0x61f6                               ; 07F31  0xBB, 0xF6, 0x61
  mov cx, 0x18                                 ; 07F34  0xB9, 0x18, 0x00

loc_07F37:                                     ; 07F37
  mov si, [bx]                                 ; 07F37  0x8B, 0x37
  push bx                                      ; 07F39  0x53
  push cx                                      ; 07F3A  0x51
  push ds                                      ; 07F3B  0x1E
  mov ds, [cs:0x2bf1]                          ; 07F3C  0x2E, 0x8E, 0x1E, 0xF1, 0x2B
  call sub_07F5E                               ; 07F41  0xE8, 0x1A, 0x00
  pop ds                                       ; 07F44  0x1F
  pop cx                                       ; 07F45  0x59
  pop bx                                       ; 07F46  0x5B
  inc bx                                       ; 07F47  0x43
  inc bx                                       ; 07F48  0x43
  loop loc_07F37                               ; 07F49  0xE2, 0xEC
  mov si, 0x614a                               ; 07F4B  0xBE, 0x4A, 0x61
  call sub_07F5E                               ; 07F4E  0xE8, 0x0D, 0x00

loc_07F51:                                     ; 07F51
  mov cl, 0x9f                                 ; 07F51  0xB1, 0x9F
  call rtm_timer_wait2                         ; 07F53  0xE8, 0x7D, 0xF9
  jmp near loc_07CC1                           ; 07F56  0xE9, 0x68, 0xFD

loc_07F59:                                     ; 07F59
  call sub_08DF1                               ; 07F59  0xE8, 0x95, 0x0E
  jmp short loc_07F51                          ; 07F5C  0xEB, 0xF3

sub_07F5E:                                     ; 07F5E
  mov cx, 0x51                                 ; 07F5E  0xB9, 0x51, 0x00
  db 0x8B, 0xDE                                ; 07F61  mov bx, si
  add bx, 0xa0                                 ; 07F63  0x81, 0xC3, 0xA0, 0x00

loc_07F67:                                     ; 07F67
  dec cx                                       ; 07F67  0x49
  je loc_07F7D                                 ; 07F68  0x74, 0x13
  dec bx                                       ; 07F6A  0x4B
  dec bx                                       ; 07F6B  0x4B
  cmp byte [bx], 0x20                          ; 07F6C  0x80, 0x3F, 0x20
  je loc_07F67                                 ; 07F6F  0x74, 0xF6

loc_07F71:                                     ; 07F71
  lodsw                                        ; 07F71  0xAD
  push cx                                      ; 07F72  0x51
  push si                                      ; 07F73  0x56
  db 0x8A, 0xC8                                ; 07F74  mov cl, al
  call sub_07F88                               ; 07F76  0xE8, 0x0F, 0x00
  pop si                                       ; 07F79  0x5E
  pop cx                                       ; 07F7A  0x59
  loop loc_07F71                               ; 07F7B  0xE2, 0xF4

loc_07F7D:                                     ; 07F7D
  mov cl, 0xd                                  ; 07F7D  0xB1, 0x0D
  call sub_07F88                               ; 07F7F  0xE8, 0x06, 0x00
  mov cl, 0xa                                  ; 07F82  0xB1, 0x0A
  call sub_07F88                               ; 07F84  0xE8, 0x01, 0x00
  ret                                          ; 07F87  0xC3

sub_07F88:                                     ; 07F88
  test cl, 0x80                                ; 07F88  0xF6, 0xC1, 0x80
  je loc_07F9D                                 ; 07F8B  0x74, 0x10
  cmp dl, 1                                    ; 07F8D  0x80, 0xFA, 0x01
  je loc_07F9B                                 ; 07F90  0x74, 0x09
  mov bx, 0x4256                               ; 07F92  0xBB, 0x56, 0x42
  test [cs:bx + 0x1c], cl                      ; 07F95  0x2E, 0x84, 0x4F, 0x1C
  je loc_07F9D                                 ; 07F99  0x74, 0x02

loc_07F9B:                                     ; 07F9B
  mov cl, 0x20                                 ; 07F9B  0xB1, 0x20

loc_07F9D:                                     ; 07F9D
  push dx                                      ; 07F9D  0x52
  push ds                                      ; 07F9E  0x1E
  mov ds, [cs:0xc06]                           ; 07F9F  0x2E, 0x8E, 0x1E, 0x06, 0x0C
  call sub_0AC5F                               ; 07FA4  0xE8, 0xB8, 0x2C
  pop ds                                       ; 07FA7  0x1F
  pop dx                                       ; 07FA8  0x5A
  ret                                          ; 07FA9  0xC3
  db 0x32, 0xE4                                ; 07FAA  xor ah, ah
  mov al, [cs:0x1043]                          ; 07FAC  0x2E, 0xA0, 0x43, 0x10
  cmp cl, 0xfe                                 ; 07FB0  0x80, 0xF9, 0xFE
  je loc_07FCB                                 ; 07FB3  0x74, 0x16
  jb loc_07FBB                                 ; 07FB5  0x72, 0x04
  test al, al                                  ; 07FB7  0x84, 0xC0
  je loc_07FCB                                 ; 07FB9  0x74, 0x10

loc_07FBB:                                     ; 07FBB
  mov dx, 0x18                                 ; 07FBB  0xBA, 0x18, 0x00
  call rtm_timer_wait                          ; 07FBE  0xE8, 0x10, 0xF9
  mov byte [cs:0x1043], 0                      ; 07FC1  0x2E, 0xC6, 0x06, 0x43, 0x10, 0x00
  mov ax, [cs:0x103e]                          ; 07FC7  0x2E, 0xA1, 0x3E, 0x10

loc_07FCB:                                     ; 07FCB
  ret                                          ; 07FCB  0xC3

io_conout:
sub_07FCC:                                     ; 07FCC
  cmp dl, 1                                    ; 07FCC  0x80, 0xFA, 0x01
  jb loc_07FD4                                 ; 07FCF  0x72, 0x03
  jmp near loc_0A8C5                           ; 07FD1  0xE9, 0xF1, 0x28

loc_07FD4:                                     ; 07FD4
  push es                                      ; 07FD4  0x06
  push ds                                      ; 07FD5  0x1E
  pop es                                       ; 07FD6  0x07
  db 0x32, 0xF6                                ; 07FD7  xor dh, dh
  db 0x8B, 0xDA                                ; 07FD9  mov bx, dx
  shl bx, 1                                    ; 07FDB  0xD1, 0xE3
  mov bx, [cs:bx + 0x2bf3]                     ; 07FDD  0x2E, 0x8B, 0x9F, 0xF3, 0x2B
  call word [bx + 0x5e]                        ; 07FE2  0xFF, 0x57, 0x5E
  mov ax, [cs:0x2a5c]                          ; 07FE5  0x2E, 0xA1, 0x5C, 0x2A
  mov [cs:0x2a5e], ax                          ; 07FE9  0x2E, 0xA3, 0x5E, 0x2A
  pop es                                       ; 07FED  0x07
  ret                                          ; 07FEE  0xC3

loc_07FEF:                                     ; 07FEF
  cmp cl, 0x20                                 ; 07FEF  0x80, 0xF9, 0x20
  jae loc_08053                                ; 07FF2  0x73, 0x5F
  cmp cl, 0                                    ; 07FF4  0x80, 0xF9, 0x00
  jne loc_07FFA                                ; 07FF7  0x75, 0x01
  ret                                          ; 07FF9  0xC3

loc_07FFA:                                     ; 07FFA
  cmp cl, 0xd                                  ; 07FFA  0x80, 0xF9, 0x0D
  jne loc_08002                                ; 07FFD  0x75, 0x03
  jmp near loc_085CE                           ; 07FFF  0xE9, 0xCC, 0x05

loc_08002:                                     ; 08002
  cmp cl, 0xa                                  ; 08002  0x80, 0xF9, 0x0A
  jne loc_0801C                                ; 08005  0x75, 0x15
  test byte [bx + 0x6b], 4                     ; 08007  0xF6, 0x47, 0x6B, 0x04
  jne loc_08013                                ; 0800B  0x75, 0x06
  call sub_0859D                               ; 0800D  0xE8, 0x8D, 0x05
  jmp near sub_85d3                            ; 08010  0xE9, 0xC0, 0x05

loc_08013:                                     ; 08013
  call sub_8a54                                ; 08013  0xE8, 0x3E, 0x0A
  call sub_0859D                               ; 08016  0xE8, 0x84, 0x05
  jmp near sub_8a95                            ; 08019  0xE9, 0x79, 0x0A

loc_0801C:                                     ; 0801C
  cmp cl, 8                                    ; 0801C  0x80, 0xF9, 0x08
  jne loc_08037                                ; 0801F  0x75, 0x16
  dec word [bx + 0x66]                         ; 08021  0xFF, 0x4F, 0x66
  jns loc_08034                                ; 08024  0x79, 0x0E
  mov ax, [bx + 0x60]                          ; 08026  0x8B, 0x47, 0x60
  mov [bx + 0x66], ax                          ; 08029  0x89, 0x47, 0x66
  dec word [bx + 0x64]                         ; 0802C  0xFF, 0x4F, 0x64
  jns loc_08034                                ; 0802F  0x79, 0x03
  jmp near sub_085C9                           ; 08031  0xE9, 0x95, 0x05

loc_08034:                                     ; 08034
  jmp near sub_85d3                            ; 08034  0xE9, 0x9C, 0x05

loc_08037:                                     ; 08037
  cmp cl, 0x1b                                 ; 08037  0x80, 0xF9, 0x1B
  jne loc_08042                                ; 0803A  0x75, 0x06
  mov word [bx + 0x5e], 0x156b                 ; 0803C  0xC7, 0x47, 0x5E, 0x6B, 0x15
  ret                                          ; 08041  0xC3

loc_08042:                                     ; 08042
  cmp cl, 7                                    ; 08042  0x80, 0xF9, 0x07
  jne loc_08053                                ; 08045  0x75, 0x0C
  test byte [bx + 0x6b], 2                     ; 08047  0xF6, 0x47, 0x6B, 0x02
  jne loc_08052                                ; 0804B  0x75, 0x05
  inc byte [cs:0x10b1]                         ; 0804D  0x2E, 0xFE, 0x06, 0xB1, 0x10

loc_08052:                                     ; 08052
  ret                                          ; 08052  0xC3

loc_08053:                                     ; 08053
  test byte [bx + 0x6b], 4                     ; 08053  0xF6, 0x47, 0x6B, 0x04
  jne loc_080C5                                ; 08057  0x75, 0x6C
  test byte [bx + 0x6b], 8                     ; 08059  0xF6, 0x47, 0x6B, 0x08
  je loc_08062                                 ; 0805D  0x74, 0x03
  call sub_0837A                               ; 0805F  0xE8, 0x18, 0x03

loc_08062:                                     ; 08062
  test word [bx + 0x6b], 0x1000                ; 08062  0xF7, 0x47, 0x6B, 0x00, 0x10
  je loc_0806B                                 ; 08067  0x74, 0x02
  mov cl, 0x20                                 ; 08069  0xB1, 0x20

loc_0806B:                                     ; 0806B
  mov di, [bx + 0x62]                          ; 0806B  0x8B, 0x7F, 0x62
  mov ch, [bx + 0x6a]                          ; 0806E  0x8A, 0x6F, 0x6A
  push es                                      ; 08071  0x06
  mov es, [cs:0x2bf1]                          ; 08072  0x2E, 0x8E, 0x06, 0xF1, 0x2B
  mov [es:di], cx                              ; 08077  0x26, 0x89, 0x0D
  test byte [cs:0x2b5a], 0xff                  ; 0807A  0x2E, 0xF6, 0x06, 0x5A, 0x2B, 0xFF
  jne loc_080BE                                ; 08080  0x75, 0x3C
  call sub_09220                               ; 08082  0xE8, 0x9B, 0x11
  mov dh, [bx + 0x64]                          ; 08085  0x8A, 0x77, 0x64
  mov dl, [bx + 0x66]                          ; 08088  0x8A, 0x57, 0x66
  call sub_092FE                               ; 0808B  0xE8, 0x70, 0x12
  add ax, [bx + 0x46]                          ; 0808E  0x03, 0x47, 0x46
  xchg si, ax                                  ; 08091  0x96
  call sub_091F2                               ; 08092  0xE8, 0x5D, 0x11
  jb loc_080BA                                 ; 08095  0x72, 0x23
  mov al, 1                                    ; 08097  0xB0, 0x01
  call sub_0930B                               ; 08099  0xE8, 0x6F, 0x12
  cmp al, [bx + 0x34]                          ; 0809C  0x3A, 0x47, 0x34
  jne loc_080BA                                ; 0809F  0x75, 0x19
  shl si, 1                                    ; 080A1  0xD1, 0xE6
  test byte [bx + 0x6b], 2                     ; 080A3  0xF6, 0x47, 0x6B, 0x02
  je loc_080B7                                 ; 080A7  0x74, 0x0E
  cmp byte [cs:0x2bfb], 0xff                   ; 080A9  0x2E, 0x80, 0x3E, 0xFB, 0x2B, 0xFF
  jne loc_080B7                                ; 080AF  0x75, 0x06
  and ch, 0x87                                 ; 080B1  0x80, 0xE5, 0x87
  or ch, 8                                     ; 080B4  0x80, 0xCD, 0x08

loc_080B7:                                     ; 080B7
  mov [es:si], cx                              ; 080B7  0x26, 0x89, 0x0C

loc_080BA:                                     ; 080BA
  mov byte [bx + 0x35], 0                      ; 080BA  0xC6, 0x47, 0x35, 0x00

loc_080BE:                                     ; 080BE
  pop es                                       ; 080BE  0x07
  call sub_080D4                               ; 080BF  0xE8, 0x12, 0x00
  jmp near sub_085ED                           ; 080C2  0xE9, 0x28, 0x05

loc_080C5:                                     ; 080C5
  mov ax, [bx + 0x64]                          ; 080C5  0x8B, 0x47, 0x64
  mov dx, [bx + 0x66]                          ; 080C8  0x8B, 0x57, 0x66
  call sub_08985                               ; 080CB  0xE8, 0xB7, 0x08
  call sub_080D4                               ; 080CE  0xE8, 0x03, 0x00
  jmp near sub_8a95                            ; 080D1  0xE9, 0xC1, 0x09

sub_080D4:                                     ; 080D4
  add word [bx + 0x62], 2                      ; 080D4  0x83, 0x47, 0x62, 0x02
  mov ax, [bx + 0x66]                          ; 080D8  0x8B, 0x47, 0x66
  inc ax                                       ; 080DB  0x40
  cmp al, [bx + 0x4d]                          ; 080DC  0x3A, 0x47, 0x4D
  jb loc_080FC                                 ; 080DF  0x72, 0x1B
  sub word [bx + 0x62], 2                      ; 080E1  0x83, 0x6F, 0x62, 0x02
  dec ax                                       ; 080E5  0x48
  test word [bx + 0x6b], 0x100                 ; 080E6  0xF7, 0x47, 0x6B, 0x00, 0x01
  jne loc_080FC                                ; 080EB  0x75, 0x0F
  call sub_0859D                               ; 080ED  0xE8, 0xAD, 0x04

sub_080F0:                                     ; 080F0
  mov si, [bx + 0x64]                          ; 080F0  0x8B, 0x77, 0x64
  shl si, 1                                    ; 080F3  0xD1, 0xE6
  mov si, [bx + si]                            ; 080F5  0x8B, 0x30
  mov [bx + 0x62], si                          ; 080F7  0x89, 0x77, 0x62
  db 0x33, 0xC0                                ; 080FA  xor ax, ax

loc_080FC:                                     ; 080FC
  mov [bx + 0x66], ax                          ; 080FC  0x89, 0x47, 0x66
  ret                                          ; 080FF  0xC3
  call sub_095CB                               ; 08100  0xE8, 0xC8, 0x14
  mov word [bx + 0x5e], 0x144f                 ; 08103  0xC7, 0x47, 0x5E, 0x4F, 0x14
  jmp near loc_07FEF                           ; 08108  0xE9, 0xE4, 0xFE
  mov word [bx + 0x5e], 0x144f                 ; 0810B  0xC7, 0x47, 0x5E, 0x4F, 0x14
  mov di, 0x15f4                               ; 08110  0xBF, 0xF4, 0x15
  db 0x8A, 0xC1                                ; 08113  mov al, cl
  call sub_08B79                               ; 08115  0xE8, 0x61, 0x0A
  inc dx                                       ; 08118  0x42
  sbb [bp + si], bp                            ; 08119  0x19, 0x2A
  sbb [bp + si], sp                            ; 0811B  0x19, 0x22
  sbb [si], bx                                 ; 0811D  0x19, 0x1C
  sbb [0xf19], dx                              ; 0811F  0x19, 0x16, 0x19, 0x0F
  sbb [bx + si], cx                            ; 08123  0x19, 0x08
  sbb [bp + di], ax                            ; 08125  0x19, 0x03
  sbb si, di                                   ; 08127  0x19, 0xFE
  sbb al, bh                                   ; 08129  0x18, 0xF8
  sbb bl, dh                                   ; 0812B  0x18, 0xF3
  sbb dh, ch                                   ; 0812D  0x18, 0xEE
  sbb [si], bl                                 ; 0812F  0x18, 0x1C
  sbb [0xcb19], dx                             ; 08131  0x19, 0x16, 0x19, 0xCB
  sbb [bp + si - 0x7ce8], bh                   ; 08135  0x18, 0xBA, 0x18, 0x83
  sbb [si + 0x18], ch                          ; 08139  0x18, 0x6C, 0x18
  db 0x61                                      ; 0813C  popa
  sbb [bp + si + 0x18], bl                     ; 0813D  0x18, 0x5A, 0x18
  cmp al, 0x19                                 ; 08140  0x3C, 0x19
  mov al, [0x9a17]                             ; 08142  0xA0, 0x17, 0x9A
  pop ss                                       ; 08145  0x17
  push sp                                      ; 08146  0x54
  sbb [bp + 0x18], cl                          ; 08147  0x18, 0x4E, 0x18
  rcl word [bx], 0xb9                          ; 0814A  0xC1, 0x17, 0xB9
  pop ss                                       ; 0814D  0x17
  db 0x8F                                      ; 0814E  .
  pop ss                                       ; 0814F  0x17
  mov dl, [bx]                                 ; 08150  0x8A, 0x17
  db 0x7E, 0x17                                ; 08152  jle 0x816b
  db 0x77, 0x17                                ; 08154  ja 0x816d
  sbb dx, [bx]                                 ; 08156  0x1B, 0x17
  xor dl, [bx]                                 ; 08158  0x32, 0x17
  and dx, [bx]                                 ; 0815A  0x23, 0x17
  db 0x67, 0x17                                ; 0815C  pop ss
  pop cx                                       ; 0815E  0x59
  pop ss                                       ; 0815F  0x17
  dec di                                       ; 08160  0x4F
  pop ss                                       ; 08161  0x17
  xchg sp, ax                                  ; 08162  0x94
  pop ss                                       ; 08163  0x17
  db 0x72, 0x17                                ; 08164  jb 0x817d
  db 0x6D                                      ; 08166  insw
  pop ss                                       ; 08167  0x17
  xor dl, [bx]                                 ; 08168  0x32, 0x17
  and dx, [bx]                                 ; 0816A  0x23, 0x17
  db 0x0F, 0x17, 0x09                          ; 0816C  movhps qword [bx + di], xmm1
  pop ss                                       ; 0816F  0x17
  add dx, [bx]                                 ; 08170  0x03, 0x17
  std                                          ; 08172  0xFD
  push ss                                      ; 08173  0x16
  db 0x36, 0x19, 0xF8                          ; 08174  sbb ax, di
  push ss                                      ; 08177  0x16
  db 0xF3, 0x16                                ; 08178  push ss
  scasw                                        ; 0817A  0xAF
  push ss                                      ; 0817B  0x16
  retf 0xa016                                  ; 0817C  0xCA, 0x16, 0xA0
  db 0x16, 0x91                                ; 0817F  ..
  push ss                                      ; 08181  0x16
  mov [0x1679], dl                             ; 08182  0x88, 0x16, 0x79, 0x16
  pop cx                                       ; 08186  0x59
  push ss                                      ; 08187  0x16
  db 0x66, 0x16                                ; 08188  push ss
  push ax                                      ; 0818A  0x50
  push ss                                      ; 0818B  0x16
  dec bp                                       ; 0818C  0x4D
  push ss                                      ; 0818D  0x16
  inc sp                                       ; 0818E  0x44
  push ss                                      ; 0818F  0x16
  xor ax, 0x3216                               ; 08190  0x35, 0x16, 0x32
  push ss                                      ; 08193  0x16
  cmp ax, 0x4348                               ; 08194  0x3D, 0x48, 0x43
  inc sp                                       ; 08197  0x44
  inc dx                                       ; 08198  0x42
  inc cx                                       ; 08199  0x41
  inc bp                                       ; 0819A  0x45
  dec cx                                       ; 0819B  0x49
  dec dx                                       ; 0819C  0x4A
  dec bx                                       ; 0819D  0x4B
  dec sp                                       ; 0819E  0x4C
  dec bp                                       ; 0819F  0x4D
  dec si                                       ; 081A0  0x4E
  dec di                                       ; 081A1  0x4F
  push ax                                      ; 081A2  0x50
  push cx                                      ; 081A3  0x51
  pop cx                                       ; 081A4  0x59
  db 0x61                                      ; 081A5  popa
  db 0x62, 0x63, 0x64                          ; 081A6  bound sp, dword [bp + di + 0x64]
  db 0x65, 0x66, 0x67, 0x68, 0x69, 0x6A, 0x6B, 0x6C  ; 081A9  push 0x6c6b6a69
  db 0x6D                                      ; 081B1  insw
  db 0x6E                                      ; 081B2  outsb
  db 0x6F                                      ; 081B3  outsw
  jo loc_08227                                 ; 081B4  0x70, 0x71
  jae loc_0822C                                ; 081B6  0x73, 0x74
  jb loc_0822F                                 ; 081B8  0x72, 0x75
  jbe loc_08233                                ; 081BA  0x76, 0x77
  js loc_08238                                 ; 081BC  0x78, 0x7A
  cmp bh, [si]                                 ; 081BE  0x3A, 0x3C
  xor [ds:bx + di], dh                         ; 081C0  0x3E, 0x30, 0x31
  xor dh, [bp + di]                            ; 081C3  0x32, 0x33
  db 0x36, 0x37                                ; 081C5  aaa
  db 0xF1                                      ; 081C7  int1
  db 0xF2, 0xF3, 0xF4                          ; 081C8  hlt
  cmc                                          ; 081CB  0xF5
  db 0xF6, 0xF7                                ; 081CC  div bh
  sti                                          ; 081CE  0xFB
  cld                                          ; 081CF  0xFC
  std                                          ; 081D0  0xFD
  db 0xFE                                      ; 081D1  .
  jmp near sub_085C9                           ; 081D2  0xE9, 0xF4, 0x03
  mov dx, [bx + 0x66]                          ; 081D5  0x8B, 0x57, 0x66
  cmp dx, [bx + 0x60]                          ; 081D8  0x3B, 0x57, 0x60
  je loc_08203                                 ; 081DB  0x74, 0x26
  inc dx                                       ; 081DD  0x42
  mov [bx + 0x66], dx                          ; 081DE  0x89, 0x57, 0x66
  jmp near sub_85d3                            ; 081E1  0xE9, 0xEF, 0x03
  dec word [bx + 0x66]                         ; 081E4  0xFF, 0x4F, 0x66
  jns loc_08203                                ; 081E7  0x79, 0x1A
  inc word [bx + 0x66]                         ; 081E9  0xFF, 0x47, 0x66
  ret                                          ; 081EC  0xC3
  jmp near loc_085BA                           ; 081ED  0xE9, 0xCA, 0x03

loc_081F0:                                     ; 081F0
  dec word [bx + 0x64]                         ; 081F0  0xFF, 0x4F, 0x64
  jns loc_08203                                ; 081F3  0x79, 0x0E
  inc word [bx + 0x64]                         ; 081F5  0xFF, 0x47, 0x64
  ret                                          ; 081F8  0xC3
  mov si, [bx + 0x64]                          ; 081F9  0x8B, 0x77, 0x64
  test si, si                                  ; 081FC  0x85, 0xF6
  jne loc_081F0                                ; 081FE  0x75, 0xF0
  call sub_086EF                               ; 08200  0xE8, 0xEC, 0x04

loc_08203:                                     ; 08203
  jmp near sub_85d3                            ; 08203  0xE9, 0xCD, 0x03

sub_08206:                                     ; 08206
  test byte [bx + 0x6b], 4                     ; 08206  0xF6, 0x47, 0x6B, 0x04
  jne loc_08216                                ; 0820A  0x75, 0x0A
  call sub_09643                               ; 0820C  0xE8, 0x34, 0x14
  mov al, [bx + 0x80]                          ; 0820F  0x8A, 0x87, 0x80, 0x00
  call sub_08371                               ; 08213  0xE8, 0x5B, 0x01

loc_08216:                                     ; 08216
  call sub_085C9                               ; 08216  0xE8, 0xB0, 0x03
  mov si, [bx + 0x64]                          ; 08219  0x8B, 0x77, 0x64
  inc si                                       ; 0821C  0x46
  cmp si, [bx + 0x48]                          ; 0821D  0x3B, 0x77, 0x48
  db 0x74, 0x06                                ; 08220  je 0x8228
  mov dx, [bx + 0x48]                          ; 08222  0x8B, 0x57, 0x48
  db 0xE8, 0x37                                ; 08225  .7

loc_08227:                                     ; 08227
  add al, 0x8b                                 ; 08227  0x04, 0x8B
  dec di                                       ; 08229  0x4F
  db 0x60                                      ; 0822A  pusha
  db 0x8B                                      ; 0822B  .

loc_0822C:                                     ; 0822C
  push di                                      ; 0822C  0x57
  db 0x66, 0xE9                                ; 0822D  f.

loc_0822F:                                     ; 0822F
  std                                          ; 0822F  0xFD
  db 0x03, 0xE8                                ; 08230  add bp, ax
  db 0x20                                      ; 08232

loc_08233:                                     ; 08233
  or [bp + di + 0x6477], cl                    ; 08233  0x08, 0x8B, 0x77, 0x64
  db 0xE8                                      ; 08237  .

loc_08238:                                     ; 08238
  mov ch, 4                                    ; 08238  0xB5, 0x04
  call sub_080F0                               ; 0823A  0xE8, 0xB3, 0xFE
  jmp near sub_08625                           ; 0823D  0xE9, 0xE5, 0x03
  call sub_8a54                                ; 08240  0xE8, 0x11, 0x08
  mov si, [bx + 0x64]                          ; 08243  0x8B, 0x77, 0x64
  call sub_086C6                               ; 08246  0xE8, 0x7D, 0x04
  call sub_080F0                               ; 08249  0xE8, 0xA4, 0xFE
  jmp near sub_08625                           ; 0824C  0xE9, 0xD6, 0x03
  test byte [bx + 0x6b], 4                     ; 0824F  0xF6, 0x47, 0x6B, 0x04
  jne loc_08297                                ; 08253  0x75, 0x42
  mov si, [bx + 0x64]                          ; 08255  0x8B, 0x77, 0x64
  shl si, 1                                    ; 08258  0xD1, 0xE6
  mov si, [bx + si]                            ; 0825A  0x8B, 0x30
  mov ax, [bx + 0x60]                          ; 0825C  0x8B, 0x47, 0x60
  shl ax, 1                                    ; 0825F  0xD1, 0xE0
  db 0x03, 0xF0                                ; 08261  add si, ax
  db 0x8B, 0xFE                                ; 08263  mov di, si
  dec si                                       ; 08265  0x4E
  dec si                                       ; 08266  0x4E
  std                                          ; 08267  0xFD
  jmp short loc_08277                          ; 08268  0xEB, 0x0D
  test byte [bx + 0x6b], 4                     ; 0826A  0xF6, 0x47, 0x6B, 0x04
  jne loc_08297                                ; 0826E  0x75, 0x27
  mov si, [bx + 0x62]                          ; 08270  0x8B, 0x77, 0x62
  db 0x8B, 0xFE                                ; 08273  mov di, si
  inc si                                       ; 08275  0x46
  inc si                                       ; 08276  0x46

loc_08277:                                     ; 08277
  mov cx, [bx + 0x60]                          ; 08277  0x8B, 0x4F, 0x60
  mov dx, [bx + 0x66]                          ; 0827A  0x8B, 0x57, 0x66
  db 0x2B, 0xCA                                ; 0827D  sub cx, dx
  push es                                      ; 0827F  0x06
  mov es, [cs:0x2bf1]                          ; 08280  0x2E, 0x8E, 0x06, 0xF1, 0x2B
  db 0xF3, 0x26, 0xA5                          ; 08285  rep movsw
  mov al, 0x20                                 ; 08288  0xB0, 0x20
  mov ah, [bx + 0x6a]                          ; 0828A  0x8A, 0x67, 0x6A
  stosw                                        ; 0828D  0xAB
  pop es                                       ; 0828E  0x07
  cld                                          ; 0828F  0xFC
  jmp near sub_09334                           ; 08290  0xE9, 0xA1, 0x10
  or byte [bx + 0x6a], 2                       ; 08293  0x80, 0x4F, 0x6A, 0x02

loc_08297:                                     ; 08297
  ret                                          ; 08297  0xC3
  and byte [bx + 0x6a], 0xfd                   ; 08298  0x80, 0x67, 0x6A, 0xFD
  ret                                          ; 0829C  0xC3
  mov word [bx + 0x5e], 0x19f7                 ; 0829D  0xC7, 0x47, 0x5E, 0xF7, 0x19
  ret                                          ; 082A2  0xC3
  mov word [bx + 0x5e], 0x1943                 ; 082A3  0xC7, 0x47, 0x5E, 0x43, 0x19
  ret                                          ; 082A8  0xC3
  mov word [bx + 0x5e], 0x194c                 ; 082A9  0xC7, 0x47, 0x5E, 0x4C, 0x19
  ret                                          ; 082AE  0xC3
  db 0x33, 0xF6                                ; 082AF  xor si, si
  mov dx, [bx + 0x64]                          ; 082B1  0x8B, 0x57, 0x64
  db 0x0B, 0xD2                                ; 082B4  or dx, dx
  je loc_082BB                                 ; 082B6  0x74, 0x03
  call sub_0865F                               ; 082B8  0xE8, 0xA4, 0x03

loc_082BB:                                     ; 082BB
  db 0x33, 0xD2                                ; 082BB  xor dx, dx
  mov cx, [bx + 0x66]                          ; 082BD  0x8B, 0x4F, 0x66
  jmp near loc_0862E                           ; 082C0  0xE9, 0x6B, 0x03
  test word [bx + 0x6b], 0x200                 ; 082C3  0xF7, 0x47, 0x6B, 0x00, 0x02
  je loc_082EE                                 ; 082C8  0x74, 0x24
  and word [bx + 0x6b], 0xfdff                 ; 082CA  0x81, 0x67, 0x6B, 0xFF, 0xFD
  jmp near sub_08625                           ; 082CF  0xE9, 0x53, 0x03
  test word [bx + 0x6b], 0x200                 ; 082D2  0xF7, 0x47, 0x6B, 0x00, 0x02
  jne loc_082EE                                ; 082D7  0x75, 0x15
  call sub_8a54                                ; 082D9  0xE8, 0x78, 0x07
  or word [bx + 0x6b], 0x200                   ; 082DC  0x81, 0x4F, 0x6B, 0x00, 0x02
  test byte [bx + 0x6b], 2                     ; 082E1  0xF6, 0x47, 0x6B, 0x02
  jne loc_082EE                                ; 082E5  0x75, 0x07
  db 0x2E, 0xC7, 0x06, 0xBE, 0x5F, 0xFF, 0xFF  ; 082E7  mov word [cs:0x5fbe], 0xffff

loc_082EE:                                     ; 082EE
  ret                                          ; 082EE  0xC3
  mov al, [bx + 0x66]                          ; 082EF  0x8A, 0x47, 0x66
  mov ah, [bx + 0x64]                          ; 082F2  0x8A, 0x67, 0x64
  mov [bx + 0x68], ax                          ; 082F5  0x89, 0x47, 0x68
  ret                                          ; 082F8  0xC3
  db 0x33, 0xC0                                ; 082F9  xor ax, ax
  xchg [bx + 0x68], ax                         ; 082FB  0x87, 0x47, 0x68
  mov [bx + 0x66], al                          ; 082FE  0x88, 0x47, 0x66
  mov [bx + 0x64], ah                          ; 08301  0x88, 0x67, 0x64
  jmp near sub_85d3                            ; 08304  0xE9, 0xCC, 0x02
  mov si, [bx + 0x64]                          ; 08307  0x8B, 0x77, 0x64
  jmp near sub_0865C                           ; 0830A  0xE9, 0x4F, 0x03
  or byte [bx + 0x6a], 1                       ; 0830D  0x80, 0x4F, 0x6A, 0x01
  ret                                          ; 08311  0xC3
  and byte [bx + 0x6a], 0xfe                   ; 08312  0x80, 0x67, 0x6A, 0xFE
  ret                                          ; 08316  0xC3
  or word [bx + 0x6b], 0x400                   ; 08317  0x81, 0x4F, 0x6B, 0x00, 0x04
  jmp short loc_08323                          ; 0831C  0xEB, 0x05
  and word [bx + 0x6b], 0xfbff                 ; 0831E  0x81, 0x67, 0x6B, 0xFF, 0xFB

loc_08323:                                     ; 08323
  mov al, [bx + 0x80]                          ; 08323  0x8A, 0x87, 0x80, 0x00
  jmp near sub_08371                           ; 08327  0xE9, 0x47, 0x00
  or byte [bx + 0x6a], 4                       ; 0832A  0x80, 0x4F, 0x6A, 0x04
  ret                                          ; 0832E  0xC3
  and byte [bx + 0x6a], 0xfb                   ; 0832F  0x80, 0x67, 0x6A, 0xFB
  ret                                          ; 08333  0xC3
  or word [bx + 0x6b], 0x1000                  ; 08334  0x81, 0x4F, 0x6B, 0x00, 0x10
  ret                                          ; 08339  0xC3
  and word [bx + 0x6b], 0xefff                 ; 0833A  0x81, 0x67, 0x6B, 0xFF, 0xEF
  ret                                          ; 0833F  0xC3
  and word [bx + 0x6b], 0xe0ff                 ; 08340  0x81, 0x67, 0x6B, 0xFF, 0xE0
  and byte [bx + 0x6a], 0xf8                   ; 08345  0x80, 0x67, 0x6A, 0xF8
  mov byte [bx + 0x75], 0xf8                   ; 08349  0xC6, 0x47, 0x75, 0xF8
  mov al, [bx + 0x7f]                          ; 0834D  0x8A, 0x47, 0x7F
  ror al, 4                                    ; 08350  0xC0, 0xC8, 0x04
  call sub_08371                               ; 08353  0xE8, 0x1B, 0x00
  jmp near sub_08625                           ; 08356  0xE9, 0xCC, 0x02
  mov al, [bx + 0x80]                          ; 08359  0x8A, 0x87, 0x80, 0x00
  or al, 0x80                                  ; 0835D  0x0C, 0x80
  jmp short sub_08371                          ; 0835F  0xEB, 0x10
  mov al, [bx + 0x80]                          ; 08361  0x8A, 0x87, 0x80, 0x00
  and al, 0x7f                                 ; 08365  0x24, 0x7F
  jmp short sub_08371                          ; 08367  0xEB, 0x08

sub_08369:                                     ; 08369
  mov al, [bx + 0x80]                          ; 08369  0x8A, 0x87, 0x80, 0x00
  and al, 0xf                                  ; 0836D  0x24, 0x0F
  db 0x0A, 0xC1                                ; 0836F  or al, cl

sub_08371:                                     ; 08371
  mov [bx + 0x80], al                          ; 08371  0x88, 0x87, 0x80, 0x00
  or byte [bx + 0x6b], 8                       ; 08375  0x80, 0x4F, 0x6B, 0x08
  ret                                          ; 08379  0xC3

sub_0837A:                                     ; 0837A
  and byte [bx + 0x6b], 0xf7                   ; 0837A  0x80, 0x67, 0x6B, 0xF7
  mov al, [bx + 0x80]                          ; 0837E  0x8A, 0x87, 0x80, 0x00
  test word [bx + 0x6b], 0x400                 ; 08382  0xF7, 0x47, 0x6B, 0x00, 0x04
  je loc_0838C                                 ; 08387  0x74, 0x03
  ror al, 4                                    ; 08389  0xC0, 0xC8, 0x04

loc_0838C:                                     ; 0838C
  push cx                                      ; 0838C  0x51
  push di                                      ; 0838D  0x57
  lea di, [bx + 0x84]                          ; 0838E  0x8D, 0xBF, 0x84, 0x00
  mov cx, [bx + 0x81]                          ; 08392  0x8B, 0x8F, 0x81, 0x00
  db 0x8B, 0xD1                                ; 08396  mov dx, cx
  repne scasb                                  ; 08398  0xF2, 0xAE
  pushf                                        ; 0839A  0x9C
  inc cx                                       ; 0839B  0x41
  db 0x2B, 0xD1                                ; 0839C  sub dx, cx
  popf                                         ; 0839E  0x9D
  je loc_083DE                                 ; 0839F  0x74, 0x3D
  cmp word [bx + 0x81], 0x10                   ; 083A1  0x83, 0xBF, 0x81, 0x00, 0x10
  jne loc_083BF                                ; 083A6  0x75, 0x17
  mov al, [bx + 0x6a]                          ; 083A8  0x8A, 0x47, 0x6A
  db 0x98                                      ; 083AB  cwde
  shr ax, 3                                    ; 083AC  0xC1, 0xE8, 0x03
  xchg si, ax                                  ; 083AF  0x96
  mov al, [bx + si + 0x84]                     ; 083B0  0x8A, 0x80, 0x84, 0x00
  mov [bx + 0x80], al                          ; 083B4  0x88, 0x87, 0x80, 0x00
  and word [bx + 0x6b], 0xfbff                 ; 083B8  0x81, 0x67, 0x6B, 0xFF, 0xFB
  jmp short loc_083EB                          ; 083BD  0xEB, 0x2C

loc_083BF:                                     ; 083BF
  inc dx                                       ; 083BF  0x42
  mov [di], al                                 ; 083C0  0x88, 0x05
  inc word [bx + 0x81]                         ; 083C2  0xFF, 0x87, 0x81, 0x00
  test byte [bx + 0x6b], 2                     ; 083C6  0xF6, 0x47, 0x6B, 0x02
  jne loc_083DE                                ; 083CA  0x75, 0x12
  call sub_09694                               ; 083CC  0xE8, 0xC5, 0x12
  db 0x8B, 0xCA                                ; 083CF  mov cx, dx
  shl dx, 2                                    ; 083D1  0xC1, 0xE2, 0x02
  add dx, 0x180                                ; 083D4  0x81, 0xC2, 0x80, 0x01
  out dx, al                                   ; 083D8  0xEE
  inc dx                                       ; 083D9  0x42
  inc dx                                       ; 083DA  0x42
  out dx, al                                   ; 083DB  0xEE
  db 0x8B, 0xD1                                ; 083DC  mov dx, cx

loc_083DE:                                     ; 083DE
  shl dl, 3                                    ; 083DE  0xC0, 0xE2, 0x03
  mov al, [bx + 0x6a]                          ; 083E1  0x8A, 0x47, 0x6A
  and al, 7                                    ; 083E4  0x24, 0x07
  db 0x0A, 0xC2                                ; 083E6  or al, dl
  mov [bx + 0x6a], al                          ; 083E8  0x88, 0x47, 0x6A

loc_083EB:                                     ; 083EB
  pop di                                       ; 083EB  0x5F
  pop cx                                       ; 083EC  0x59
  ret                                          ; 083ED  0xC3
  and word [bx + 0x6b], 0xfeff                 ; 083EE  0x81, 0x67, 0x6B, 0xFF, 0xFE
  ret                                          ; 083F3  0xC3
  or word [bx + 0x6b], 0x100                   ; 083F4  0x81, 0x4F, 0x6B, 0x00, 0x01
  ret                                          ; 083F9  0xC3
  mov word [bx + 0x7b], 0x1b2a                 ; 083FA  0xC7, 0x47, 0x7B, 0x2A, 0x1B
  jmp short loc_08406                          ; 083FF  0xEB, 0x05
  mov word [bx + 0x7b], 0x1b53                 ; 08401  0xC7, 0x47, 0x7B, 0x53, 0x1B

loc_08406:                                     ; 08406
  mov word [bx + 0x5e], 0x195d                 ; 08406  0xC7, 0x47, 0x5E, 0x5D, 0x19
  ret                                          ; 0840B  0xC3
  mov si, 0x18                                 ; 0840C  0xBE, 0x18, 0x00
  call sub_0865C                               ; 0840F  0xE8, 0x4A, 0x02
  call sub_09220                               ; 08412  0xE8, 0x0B, 0x0E
  call sub_09312                               ; 08415  0xE8, 0xFA, 0x0E
  mov ax, 0x19                                 ; 08418  0xB8, 0x19, 0x00
  call sub_08444                               ; 0841B  0xE8, 0x26, 0x00
  mov byte [bx + 0x35], 0                      ; 0841E  0xC6, 0x47, 0x35, 0x00
  ret                                          ; 08422  0xC3
  call sub_09220                               ; 08423  0xE8, 0xFA, 0x0D
  call sub_09312                               ; 08426  0xE8, 0xE9, 0x0E
  cmp word [bx + 0x64], 0x18                   ; 08429  0x83, 0x7F, 0x64, 0x18
  jne loc_08439                                ; 0842D  0x75, 0x0A
  dec word [bx + 0x64]                         ; 0842F  0xFF, 0x4F, 0x64
  mov byte [bx + 0x35], 0                      ; 08432  0xC6, 0x47, 0x35, 0x00
  call sub_85d3                                ; 08436  0xE8, 0x9A, 0x01

loc_08439:                                     ; 08439
  mov ax, 0x18                                 ; 08439  0xB8, 0x18, 0x00
  call sub_08444                               ; 0843C  0xE8, 0x05, 0x00
  mov byte [bx + 0x35], 0                      ; 0843F  0xC6, 0x47, 0x35, 0x00
  ret                                          ; 08443  0xC3

sub_08444:                                     ; 08444
  mov [bx + 0x48], ax                          ; 08444  0x89, 0x47, 0x48
  test byte [bx + 0x6b], 0x16                  ; 08447  0xF6, 0x47, 0x6B, 0x16
  jne loc_08459                                ; 0844B  0x75, 0x0C
  call sub_0893E                               ; 0844D  0xE8, 0xEE, 0x04
  xor byte [cs:0x5fa6], 0x80                   ; 08450  0x2E, 0x80, 0x36, 0xA6, 0x5F, 0x80
  call sub_09312                               ; 08456  0xE8, 0xB9, 0x0E

loc_08459:                                     ; 08459
  ret                                          ; 08459  0xC3
  mov ax, [bx + 0x6b]                          ; 0845A  0x8B, 0x47, 0x6B
  mov al, [bx + 0x6a]                          ; 0845D  0x8A, 0x47, 0x6A
  mov [bx + 0x6d], ax                          ; 08460  0x89, 0x47, 0x6D
  mov al, [bx + 0x80]                          ; 08463  0x8A, 0x87, 0x80, 0x00
  mov [bx + 0x6f], al                          ; 08467  0x88, 0x47, 0x6F
  ret                                          ; 0846A  0xC3
  mov ax, [bx + 0x6d]                          ; 0846B  0x8B, 0x47, 0x6D
  mov [bx + 0x6a], al                          ; 0846E  0x88, 0x47, 0x6A
  mov al, [bx + 0x6b]                          ; 08471  0x8A, 0x47, 0x6B
  mov [bx + 0x6b], ax                          ; 08474  0x89, 0x47, 0x6B
  mov al, [bx + 0x6f]                          ; 08477  0x8A, 0x47, 0x6F
  call sub_08371                               ; 0847A  0xE8, 0xF4, 0xFE
  test byte [bx + 0x6b], 2                     ; 0847D  0xF6, 0x47, 0x6B, 0x02
  je loc_08484                                 ; 08481  0x74, 0x01
  ret                                          ; 08483  0xC3

loc_08484:                                     ; 08484
  db 0x2E, 0xC7, 0x06, 0xBE, 0x5F, 0xFF, 0xFF  ; 08484  mov word [cs:0x5fbe], 0xffff
  jmp near sub_08625                           ; 0848B  0xE9, 0x97, 0x01
  mov al, 1                                    ; 0848E  0xB0, 0x01
  jmp near loc_07E07                           ; 08490  0xE9, 0x74, 0xF9
  db 0x32, 0xC0                                ; 08493  xor al, al
  jmp near loc_07E07                           ; 08495  0xE9, 0x6F, 0xF9
  mov word [bx + 0x5e], 0x1991                 ; 08498  0xC7, 0x47, 0x5E, 0x91, 0x19
  ret                                          ; 0849D  0xC3
  mov byte [bx + 0x71], 1                      ; 0849E  0xC6, 0x47, 0x71, 0x01
  ret                                          ; 084A2  0xC3
  mov byte [bx + 0x71], 0                      ; 084A3  0xC6, 0x47, 0x71, 0x00
  ret                                          ; 084A7  0xC3
  mov byte [bx + 0x75], 0xff                   ; 084A8  0xC6, 0x47, 0x75, 0xFF
  jmp near sub_096CF                           ; 084AC  0xE9, 0x20, 0x12
  mov byte [bx + 0x75], 0xf8                   ; 084AF  0xC6, 0x47, 0x75, 0xF8
  jmp near sub_096CF                           ; 084B3  0xE9, 0x19, 0x12
  or word [bx + 0x6b], 0x800                   ; 084B6  0x81, 0x4F, 0x6B, 0x00, 0x08
  ret                                          ; 084BB  0xC3
  and word [bx + 0x6b], 0xf7ff                 ; 084BC  0x81, 0x67, 0x6B, 0xFF, 0xF7
  ret                                          ; 084C1  0xC3
  mov si, [bx + 0x76]                          ; 084C2  0x8B, 0x77, 0x76
  mov di, 0x4bc4                               ; 084C5  0xBF, 0xC4, 0x4B
  jmp short loc_084D0                          ; 084C8  0xEB, 0x06
  mov di, [bx + 0x76]                          ; 084CA  0x8B, 0x7F, 0x76
  mov si, 0x4bc4                               ; 084CD  0xBE, 0xC4, 0x4B

loc_084D0:                                     ; 084D0
  mov cx, 0x1c8                                ; 084D0  0xB9, 0xC8, 0x01
  rep movsb                                    ; 084D3  0xF3, 0xA4
  ret                                          ; 084D5  0xC3
  mov word [bx + 0x5e], 0x199d                 ; 084D6  0xC7, 0x47, 0x5E, 0x9D, 0x19
  ret                                          ; 084DB  0xC3
  mov word [bx + 0x5e], 0x19c3                 ; 084DC  0xC7, 0x47, 0x5E, 0xC3, 0x19
  ret                                          ; 084E1  0xC3
  ret                                          ; 084E2  0xC3
  shl cl, 4                                    ; 084E3  0xC0, 0xE1, 0x04
  call sub_08369                               ; 084E6  0xE8, 0x80, 0xFE
  jmp near loc_08597                           ; 084E9  0xE9, 0xAB, 0x00
  and cl, 0xf                                  ; 084EC  0x80, 0xE1, 0x0F
  mov al, [bx + 0x80]                          ; 084EF  0x8A, 0x87, 0x80, 0x00
  and al, 0xf0                                 ; 084F3  0x24, 0xF0
  db 0x0A, 0xC1                                ; 084F5  or al, cl
  call sub_08371                               ; 084F7  0xE8, 0x77, 0xFE
  jmp near loc_08597                           ; 084FA  0xE9, 0x9A, 0x00
  mov word [bx + 0x5e], 0x196b                 ; 084FD  0xC7, 0x47, 0x5E, 0x6B, 0x19
  sub cl, 0x20                                 ; 08502  0x80, 0xE9, 0x20
  db 0x32, 0xED                                ; 08505  xor ch, ch
  mov [bx + 0x7d], cx                          ; 08507  0x89, 0x4F, 0x7D
  ret                                          ; 0850A  0xC3
  sub cl, 0x20                                 ; 0850B  0x80, 0xE9, 0x20
  cmp cl, [bx + 0x48]                          ; 0850E  0x3A, 0x4F, 0x48
  jae loc_0854D                                ; 08511  0x73, 0x3A
  db 0x32, 0xED                                ; 08513  xor ch, ch
  db 0x8B, 0xF9                                ; 08515  mov di, cx

rtm_al80_poll_console:                         ; 08517
  mov si, [bx + 0x7d]                          ; 08517  0x8B, 0x77, 0x7D
  db 0x3B, 0xFE                                ; 0851A  cmp di, si
  jb loc_0854D                                 ; 0851C  0x72, 0x2F

rtm_al87_blocking_read:                        ; 0851E
  push si                                      ; 0851E  0x56
  push di                                      ; 0851F  0x57
  call sub_8a54                                ; 08520  0xE8, 0x31, 0x05
  pop di                                       ; 08523  0x5F
  pop si                                       ; 08524  0x5E
  call word [bx + 0x7b]                        ; 08525  0xFF, 0x57, 0x7B
  call sub_8a95                                ; 08528  0xE8, 0x6A, 0x05
  call sub_85d3                                ; 0852B  0xE8, 0xA5, 0x00
  jmp near loc_08597                           ; 0852E  0xE9, 0x66, 0x00
  ror cx, 4                                    ; 08531  0xC1, 0xC9, 0x04
  ror ch, 4                                    ; 08534  0xC0, 0xCD, 0x04
  call sub_7e11                                ; 08537  0xE8, 0xD7, 0xF8
  jmp near loc_08597                           ; 0853A  0xE9, 0x5A, 0x00
  mov word [bx + 0x5e], 0x19ae                 ; 0853D  0xC7, 0x47, 0x5E, 0xAE, 0x19
  sub cl, 0x20                                 ; 08542  0x80, 0xE9, 0x20
  cmp cl, [bx + 0x48]                          ; 08545  0x3A, 0x4F, 0x48
  jae loc_0854D                                ; 08548  0x73, 0x03
  mov [bx + 0x64], cl                          ; 0854A  0x88, 0x4F, 0x64

loc_0854D:                                     ; 0854D
  ret                                          ; 0854D  0xC3
  mov word [bx + 0x5e], 0x144f                 ; 0854E  0xC7, 0x47, 0x5E, 0x4F, 0x14
  sub cl, 0x20                                 ; 08553  0x80, 0xE9, 0x20
  cmp cl, [bx + 0x60]                          ; 08556  0x3A, 0x4F, 0x60
  ja loc_08597                                 ; 08559  0x77, 0x3C
  mov [bx + 0x66], cl                          ; 0855B  0x88, 0x4F, 0x66
  call sub_85d3                                ; 0855E  0xE8, 0x72, 0x00
  jmp short loc_08597                          ; 08561  0xEB, 0x34
  xchg al, cl                                  ; 08563  86 C1
  mov di, 0x10b5                               ; 08565  0xBF, 0xB5, 0x10
  db 0x8B, 0xD7                                ; 08568  mov dx, di
  mov cx, 0x42                                 ; 0856A  0xB9, 0x42, 0x00
  repne scasb                                  ; 0856D  0xF2, 0xAE
  jne loc_08597                                ; 0856F  0x75, 0x26
  dec di                                       ; 08571  0x4F
  db 0x2B, 0xFA                                ; 08572  sub di, dx
  xchg di, ax                                  ; 08574  0x97
  call sub_7c97                                ; 08575  0xE8, 0x1F, 0xF7
  mov [bx + 0x7b], si                          ; 08578  0x89, 0x77, 0x7B
  mov [bx + 0x7d], cl                          ; 0857B  0x88, 0x4F, 0x7D
  mov word [bx + 0x5e], 0x19e4                 ; 0857E  0xC7, 0x47, 0x5E, 0xE4, 0x19
  ret                                          ; 08583  0xC3
  mov si, [bx + 0x7b]                          ; 08584  0x8B, 0x77, 0x7B
  mov [si], cl                                 ; 08587  0x88, 0x0C
  inc si                                       ; 08589  0x46
  mov [bx + 0x7b], si                          ; 0858A  0x89, 0x77, 0x7B
  db 0x0A, 0xC9                                ; 0858D  or cl, cl
  je loc_08597                                 ; 0858F  0x74, 0x06
  dec byte [bx + 0x7d]                         ; 08591  0xFE, 0x4F, 0x7D
  je loc_08597                                 ; 08594  0x74, 0x01
  ret                                          ; 08596  0xC3

loc_08597:                                     ; 08597
  mov word [bx + 0x5e], 0x144f                 ; 08597  0xC7, 0x47, 0x5E, 0x4F, 0x14
  ret                                          ; 0859C  0xC3

sub_0859D:                                     ; 0859D
  mov si, [bx + 0x64]                          ; 0859D  0x8B, 0x77, 0x64
  inc si                                       ; 085A0  0x46
  cmp si, [bx + 0x48]                          ; 085A1  0x3B, 0x77, 0x48
  jne loc_085AD                                ; 085A4  0x75, 0x07
  mov si, 0                                    ; 085A6  0xBE, 0x00, 0x00
  call sub_086C6                               ; 085A9  0xE8, 0x1A, 0x01
  ret                                          ; 085AC  0xC3

loc_085AD:                                     ; 085AD
  mov [bx + 0x64], si                          ; 085AD  0x89, 0x77, 0x64
  cmp byte [bx + 0x4c], 0                      ; 085B0  0x80, 0x7F, 0x4C, 0x00
  je loc_085B9                                 ; 085B4  0x74, 0x03
  call sub_09334                               ; 085B6  0xE8, 0x7B, 0x0D

loc_085B9:                                     ; 085B9
  ret                                          ; 085B9  0xC3

loc_085BA:                                     ; 085BA
  mov dx, [bx + 0x64]                          ; 085BA  0x8B, 0x57, 0x64
  inc dx                                       ; 085BD  0x42
  cmp dx, [bx + 0x48]                          ; 085BE  0x3B, 0x57, 0x48
  je loc_085C8                                 ; 085C1  0x74, 0x05
  mov [bx + 0x64], dx                          ; 085C3  0x89, 0x57, 0x64
  jmp short sub_85d3                           ; 085C6  0xEB, 0x0B

loc_085C8:                                     ; 085C8
  ret                                          ; 085C8  0xC3

sub_085C9:                                     ; 085C9
  mov word [bx + 0x64], 0                      ; 085C9  0xC7, 0x47, 0x64, 0x00, 0x00

loc_085CE:                                     ; 085CE
  mov word [bx + 0x66], 0                      ; 085CE  0xC7, 0x47, 0x66, 0x00, 0x00

sub_85d3:                                      ; 085D3
  mov di, [bx + 0x66]                          ; 085D3  0x8B, 0x7F, 0x66
  mov si, [bx + 0x64]                          ; 085D6  0x8B, 0x77, 0x64
  shl si, 1                                    ; 085D9  0xD1, 0xE6
  mov dx, [bx + si]                            ; 085DB  0x8B, 0x10
  shl di, 1                                    ; 085DD  0xD1, 0xE7
  db 0x03, 0xD7                                ; 085DF  add dx, di
  mov [bx + 0x62], dx                          ; 085E1  0x89, 0x57, 0x62
  test byte [bx + 0x6b], 4                     ; 085E4  0xF6, 0x47, 0x6B, 0x04
  je sub_085ED                                 ; 085E8  0x74, 0x03
  jmp near loc_08A92                           ; 085EA  0xE9, 0xA5, 0x04

sub_085ED:                                     ; 085ED
  test word [bx + 0x6b], 0x203                 ; 085ED  0xF7, 0x47, 0x6B, 0x03, 0x02
  jne loc_0861C                                ; 085F2  0x75, 0x28
  mov dh, [bx + 0x64]                          ; 085F4  0x8A, 0x77, 0x64
  mov dl, [bx + 0x66]                          ; 085F7  0x8A, 0x57, 0x66
  test byte [bx + 0x6b], 0x10                  ; 085FA  0xF6, 0x47, 0x6B, 0x10
  je loc_08617                                 ; 085FE  0x74, 0x17
  sub dh, [bx + 0x4b]                          ; 08600  0x2A, 0x77, 0x4B
  jb loc_0861D                                 ; 08603  0x72, 0x18
  sub dl, [bx + 0x4a]                          ; 08605  0x2A, 0x57, 0x4A
  jb loc_0861D                                 ; 08608  0x72, 0x13
  cmp dh, [bx + 0x42]                          ; 0860A  0x3A, 0x77, 0x42
  jae loc_0861D                                ; 0860D  0x73, 0x0E
  cmp dl, [bx + 0x44]                          ; 0860F  0x3A, 0x57, 0x44
  jae loc_0861D                                ; 08612  0x73, 0x09
  add dx, [bx + 0x36]                          ; 08614  0x03, 0x57, 0x36

loc_08617:                                     ; 08617
  mov [cs:0x5fbe], dx                          ; 08617  0x2E, 0x89, 0x16, 0xBE, 0x5F

loc_0861C:                                     ; 0861C
  ret                                          ; 0861C  0xC3

loc_0861D:                                     ; 0861D
  db 0x2E, 0xC7, 0x06, 0xBE, 0x5F, 0xFF, 0xFF  ; 0861D  mov word [cs:0x5fbe], 0xffff
  ret                                          ; 08624  0xC3

sub_08625:                                     ; 08625
  test byte [bx + 0x6b], 4                     ; 08625  0xF6, 0x47, 0x6B, 0x04
  je sub_085ED                                 ; 08629  0x74, 0xC2
  jmp near sub_8a95                            ; 0862B  0xE9, 0x67, 0x04

loc_0862E:                                     ; 0862E
  mov si, [bx + 0x64]                          ; 0862E  0x8B, 0x77, 0x64
  shl si, 1                                    ; 08631  0xD1, 0xE6
  mov di, [bx + si]                            ; 08633  0x8B, 0x38
  shr si, 1                                    ; 08635  0xD1, 0xEE
  db 0x03, 0xFA                                ; 08637  add di, dx
  db 0x03, 0xFA                                ; 08639  add di, dx
  db 0x2B, 0xCA                                ; 0863B  sub cx, dx
  inc cx                                       ; 0863D  0x41
  test byte [bx + 0x6b], 4                     ; 0863E  0xF6, 0x47, 0x6B, 0x04
  jne loc_08649                                ; 08642  0x75, 0x05
  call sub_08686                               ; 08644  0xE8, 0x3F, 0x00
  jmp short loc_0866B                          ; 08647  0xEB, 0x22

loc_08649:                                     ; 08649
  db 0x8B, 0xC6                                ; 08649  mov ax, si

loc_0864B:                                     ; 0864B
  push ax                                      ; 0864B  0x50
  push dx                                      ; 0864C  0x52
  push cx                                      ; 0864D  0x51
  mov cl, 0x20                                 ; 0864E  0xB1, 0x20
  call sub_08985                               ; 08650  0xE8, 0x32, 0x03
  pop cx                                       ; 08653  0x59
  pop dx                                       ; 08654  0x5A
  pop ax                                       ; 08655  0x58
  inc dx                                       ; 08656  0x42
  loop loc_0864B                               ; 08657  0xE2, 0xF2
  jmp near sub_8a95                            ; 08659  0xE9, 0x39, 0x04

sub_0865C:                                     ; 0865C
  db 0x8B, 0xD6                                ; 0865C  mov dx, si
  inc dx                                       ; 0865E  0x42

sub_0865F:                                     ; 0865F
  push si                                      ; 0865F  0x56
  push dx                                      ; 08660  0x52
  call sub_08677                               ; 08661  0xE8, 0x13, 0x00
  pop dx                                       ; 08664  0x5A
  pop si                                       ; 08665  0x5E
  inc si                                       ; 08666  0x46
  db 0x3B, 0xD6                                ; 08667  cmp dx, si
  jne sub_0865F                                ; 08669  0x75, 0xF4

loc_0866B:                                     ; 0866B
  test byte [cs:0x2b5a], 0xff                  ; 0866B  0x2E, 0xF6, 0x06, 0x5A, 0x2B, 0xFF
  jne loc_08676                                ; 08671  0x75, 0x03
  call sub_09334                               ; 08673  0xE8, 0xBE, 0x0C

loc_08676:                                     ; 08676
  ret                                          ; 08676  0xC3

sub_08677:                                     ; 08677
  test byte [bx + 0x6b], 4                     ; 08677  0xF6, 0x47, 0x6B, 0x04
  jne loc_0869E                                ; 0867B  0x75, 0x21
  shl si, 1                                    ; 0867D  0xD1, 0xE6
  mov di, [bx + si]                            ; 0867F  0x8B, 0x38
  shr si, 1                                    ; 08681  0xD1, 0xEE
  mov cx, 0x50                                 ; 08683  0xB9, 0x50, 0x00

sub_08686:                                     ; 08686
  test byte [bx + 0x6b], 8                     ; 08686  0xF6, 0x47, 0x6B, 0x08
  je loc_0868F                                 ; 0868A  0x74, 0x03
  call sub_0837A                               ; 0868C  0xE8, 0xEB, 0xFC

loc_0868F:                                     ; 0868F
  push es                                      ; 0868F  0x06
  mov ah, [bx + 0x6a]                          ; 08690  0x8A, 0x67, 0x6A
  mov al, 0x20                                 ; 08693  0xB0, 0x20
  mov es, [cs:0x2bf1]                          ; 08695  0x2E, 0x8E, 0x06, 0xF1, 0x2B
  rep stosw                                    ; 0869A  0xF3, 0xAB
  pop es                                       ; 0869C  0x07
  ret                                          ; 0869D  0xC3

loc_0869E:                                     ; 0869E
  push ds                                      ; 0869E  0x1E
  db 0x8B, 0xC6                                ; 0869F  mov ax, si
  mov ah, 0xa                                  ; 086A1  0xB4, 0x0A
  db 0xF6, 0xE4                                ; 086A3  mul ah
  db 0x8B, 0xF8                                ; 086A5  mov di, ax
  shl di, 1                                    ; 086A7  0xD1, 0xE7
  call sub_08B5E                               ; 086A9  0xE8, 0xB2, 0x04
  push ds                                      ; 086AC  0x1E
  pop es                                       ; 086AD  0x07
  db 0x33, 0xC0                                ; 086AE  xor ax, ax
  mov cx, 0x23                                 ; 086B0  0xB9, 0x23, 0x00

loc_086B3:                                     ; 086B3
  push cx                                      ; 086B3  0x51
  mov cx, 0xa                                  ; 086B4  0xB9, 0x0A, 0x00
  rep stosw                                    ; 086B7  0xF3, 0xAB
  add di, 0x1ec                                ; 086B9  0x81, 0xC7, 0xEC, 0x01
  pop cx                                       ; 086BD  0x59
  loop loc_086B3                               ; 086BE  0xE2, 0xF3
  pop ds                                       ; 086C0  0x1F
  mov byte [bx + 0x35], 0                      ; 086C1  0xC6, 0x47, 0x35, 0x00
  ret                                          ; 086C5  0xC3

sub_086C6:                                     ; 086C6
  mov di, [bx + 0x48]                          ; 086C6  0x8B, 0x7F, 0x48
  dec di                                       ; 086C9  0x4F
  test byte [bx + 0x6b], 4                     ; 086CA  0xF6, 0x47, 0x6B, 0x04
  je loc_086D3                                 ; 086CE  0x74, 0x03
  jmp near loc_08AEE                           ; 086D0  0xE9, 0x1B, 0x04

loc_086D3:                                     ; 086D3
  push si                                      ; 086D3  0x56
  push di                                      ; 086D4  0x57
  db 0x8B, 0xCF                                ; 086D5  mov cx, di
  db 0x2B, 0xCE                                ; 086D7  sub cx, si
  shl si, 1                                    ; 086D9  0xD1, 0xE6
  db 0x03, 0xF3                                ; 086DB  add si, bx
  db 0x8B, 0xFE                                ; 086DD  mov di, si
  lodsw                                        ; 086DF  0xAD
  rep movsw                                    ; 086E0  0xF3, 0xA5
  xchg [bx + 0x32], ax                         ; 086E2  0x87, 0x47, 0x32
  stosw                                        ; 086E5  0xAB
  pop dx                                       ; 086E6  0x5A
  pop cx                                       ; 086E7  0x59
  db 0x8B, 0xF2                                ; 086E8  mov si, dx
  mov di, 0                                    ; 086EA  0xBF, 0x00, 0x00
  jmp short loc_08716                          ; 086ED  0xEB, 0x27

sub_086EF:                                     ; 086EF
  mov di, [bx + 0x48]                          ; 086EF  0x8B, 0x7F, 0x48
  dec di                                       ; 086F2  0x4F
  test byte [bx + 0x6b], 4                     ; 086F3  0xF6, 0x47, 0x6B, 0x04
  je loc_086FA                                 ; 086F7  0x74, 0x01
  ret                                          ; 086F9  0xC3

loc_086FA:                                     ; 086FA
  push si                                      ; 086FA  0x56
  push di                                      ; 086FB  0x57
  db 0x8B, 0xCF                                ; 086FC  mov cx, di
  db 0x2B, 0xCE                                ; 086FE  sub cx, si
  shl di, 1                                    ; 08700  0xD1, 0xE7
  db 0x03, 0xFB                                ; 08702  add di, bx
  db 0x8B, 0xF7                                ; 08704  mov si, di
  std                                          ; 08706  0xFD
  lodsw                                        ; 08707  0xAD
  rep movsw                                    ; 08708  0xF3, 0xA5
  xchg [bx + 0x32], ax                         ; 0870A  0x87, 0x47, 0x32
  stosw                                        ; 0870D  0xAB
  cld                                          ; 0870E  0xFC
  pop dx                                       ; 0870F  0x5A
  pop cx                                       ; 08710  0x59
  db 0x8B, 0xF1                                ; 08711  mov si, cx
  mov di, 6                                    ; 08713  0xBF, 0x06, 0x00

loc_08716:                                     ; 08716
  push ax                                      ; 08716  0x50
  call sub_09220                               ; 08717  0xE8, 0x06, 0x0B
  pop ax                                       ; 0871A  0x58
  test byte [bx + 0x6b], 0x12                  ; 0871B  0xF6, 0x47, 0x6B, 0x12
  jne loc_0873E                                ; 0871F  0x75, 0x1D
  cmp byte [bx + 0x71], 0                      ; 08721  0x80, 0x7F, 0x71, 0x00
  je loc_08743                                 ; 08725  0x74, 0x1C
  db 0x3B, 0xCA                                ; 08727  cmp cx, dx
  jne loc_08754                                ; 08729  0x75, 0x29
  call sub_0865C                               ; 0872B  0xE8, 0x2E, 0xFF
  call sub_0893E                               ; 0872E  0xE8, 0x0D, 0x02
  xor byte [cs:0x5fa6], 0x80                   ; 08731  0x2E, 0x80, 0x36, 0xA6, 0x5F, 0x80
  mov ah, 0                                    ; 08737  0xB4, 0x00
  call xios_crt_trigger_ca                     ; 08739  0xE8, 0xC5, 0x0E
  jmp short loc_0874F                          ; 0873C  0xEB, 0x11

loc_0873E:                                     ; 0873E
  call sub_0865C                               ; 0873E  0xE8, 0x1B, 0xFF
  jmp short loc_0874F                          ; 08741  0xEB, 0x0C

loc_08743:                                     ; 08743
  call sub_0865C                               ; 08743  0xE8, 0x16, 0xFF
  call sub_0893E                               ; 08746  0xE8, 0xF5, 0x01
  xor byte [cs:0x5fa6], 0x80                   ; 08749  0x2E, 0x80, 0x36, 0xA6, 0x5F, 0x80

loc_0874F:                                     ; 0874F
  mov byte [bx + 0x35], 0                      ; 0874F  0xC6, 0x47, 0x35, 0x00
  ret                                          ; 08753  0xC3

loc_08754:                                     ; 08754
  push di                                      ; 08754  0x57
  or byte [bx + 0x6b], 1                       ; 08755  0x80, 0x4F, 0x6B, 0x01
  call sub_087FD                               ; 08759  0xE8, 0xA1, 0x00
  mov byte [cs:0x2c06], 0xff                   ; 0875C  0x2E, 0xC6, 0x06, 0x06, 0x2C, 0xFF
  call sub_087F4                               ; 08762  0xE8, 0x8F, 0x00
  mov byte [cs:0x2c06], 0                      ; 08765  0x2E, 0xC6, 0x06, 0x06, 0x2C, 0x00
  pop ax                                       ; 0876B  0x58
  mov [cs:0x2c07], al                          ; 0876C  0x2E, 0xA2, 0x07, 0x2C
  mov [cs:0x2c00], bx                          ; 08770  0x2E, 0x89, 0x1E, 0x00, 0x2C
  push bx                                      ; 08775  0x53
  mov dx, 4                                    ; 08776  0xBA, 0x04, 0x00
  call rtm_call_helper                         ; 08779  0xE8, 0x44, 0xF1
  mov cl, 0x8e                                 ; 0877C  0xB1, 0x8E
  call rtm_timer_wait2                         ; 0877E  0xE8, 0x52, 0xF1
  mov dx, 9                                    ; 08781  0xBA, 0x09, 0x00
  call rtm_timer_wait                          ; 08784  0xE8, 0x4A, 0xF1
  pop bx                                       ; 08787  0x5B
  ret                                          ; 08788  0xC3
  call sub_0880E                               ; 08789  0xE8, 0x82, 0x00
  inc word [cs:0x2c04]                         ; 0878C  0x2E, 0xFF, 0x06, 0x04, 0x2C
  push ax                                      ; 08791  0x50
  call sub_0865C                               ; 08792  0xE8, 0xC7, 0xFE
  db 0x8B, 0xF3                                ; 08795  mov si, bx
  mov di, 0x2c13                               ; 08797  0xBF, 0x13, 0x2C
  mov cx, [bx + 0x48]                          ; 0879A  0x8B, 0x4F, 0x48
  rep movsw                                    ; 0879D  0xF3, 0xA5
  call sub_08825                               ; 0879F  0xE8, 0x83, 0x00
  pop ax                                       ; 087A2  0x58
  mov di, [cs:0x2c04]                          ; 087A3  0x2E, 0x8B, 0x3E, 0x04, 0x2C
  add di, 3                                    ; 087A8  0x83, 0xC7, 0x03
  mov cl, 1                                    ; 087AB  0xB1, 0x01
  jmp near loc_087CD                           ; 087AD  0xE9, 0x1D, 0x00
  call sub_0880E                               ; 087B0  0xE8, 0x5B, 0x00
  push ax                                      ; 087B3  0x50
  call sub_0865C                               ; 087B4  0xE8, 0xA5, 0xFE
  db 0x8B, 0xF3                                ; 087B7  mov si, bx
  mov di, 0x2c13                               ; 087B9  0xBF, 0x13, 0x2C
  mov cx, [bx + 0x48]                          ; 087BC  0x8B, 0x4F, 0x48
  rep movsw                                    ; 087BF  0xF3, 0xA5
  call sub_08825                               ; 087C1  0xE8, 0x61, 0x00
  pop ax                                       ; 087C4  0x58
  mov di, [cs:0x2c02]                          ; 087C5  0x2E, 0x8B, 0x3E, 0x02, 0x2C
  inc di                                       ; 087CA  0x47
  mov cl, 7                                    ; 087CB  0xB1, 0x07

loc_087CD:                                     ; 087CD
  mov [cs:bx + 0x80], cl                       ; 087CD  0x2E, 0x88, 0x8F, 0x80, 0x00
  inc cl                                       ; 087D2  0xFE, 0xC1
  mov [cs:bx + 0x7c], cl                       ; 087D4  0x2E, 0x88, 0x4F, 0x7C
  shl di, 1                                    ; 087D8  0xD1, 0xE7
  shl di, 1                                    ; 087DA  0xD1, 0xE7
  db 0x03, 0xFB                                ; 087DC  add di, bx
  mov dx, [cs:0x2bf1]                          ; 087DE  0x2E, 0x8B, 0x16, 0xF1, 0x2B
  call sub_09623                               ; 087E3  0xE8, 0x3D, 0x0E
  db 0x2E, 0xC7, 0x06, 0xBE, 0x5F, 0xFF, 0xFF  ; 087E6  mov word [cs:0x5fbe], 0xffff
  xor byte [cs:0x5fa6], 0x80                   ; 087ED  0x2E, 0x80, 0x36, 0xA6, 0x5F, 0x80
  ret                                          ; 087F3  0xC3

sub_087F4:                                     ; 087F4
  push bx                                      ; 087F4  0x53
  mov dx, 0xa                                  ; 087F5  0xBA, 0x0A, 0x00
  call rtm_timer_wait                          ; 087F8  0xE8, 0xD6, 0xF0
  pop bx                                       ; 087FB  0x5B
  ret                                          ; 087FC  0xC3

sub_087FD:                                     ; 087FD
  mov di, 0x2c09                               ; 087FD  0xBF, 0x09, 0x2C
  stosw                                        ; 08800  0xAB
  db 0x8B, 0xC3                                ; 08801  mov ax, bx
  stosw                                        ; 08803  0xAB
  db 0x8B, 0xC1                                ; 08804  mov ax, cx
  stosw                                        ; 08806  0xAB
  db 0x8B, 0xC2                                ; 08807  mov ax, dx
  stosw                                        ; 08809  0xAB
  db 0x8B, 0xC6                                ; 0880A  mov ax, si
  stosw                                        ; 0880C  0xAB
  ret                                          ; 0880D  0xC3

sub_0880E:                                     ; 0880E
  mov si, 0x2c0b                               ; 0880E  0xBE, 0x0B, 0x2C
  lodsw                                        ; 08811  0xAD
  db 0x8B, 0xD8                                ; 08812  mov bx, ax
  lodsw                                        ; 08814  0xAD
  mov [cs:0x2c02], ax                          ; 08815  0x2E, 0xA3, 0x02, 0x2C
  lodsw                                        ; 08819  0xAD
  mov [cs:0x2c04], ax                          ; 0881A  0x2E, 0xA3, 0x04, 0x2C
  mov si, [si]                                 ; 0881E  0x8B, 0x34
  mov ax, [cs:0x2c09]                          ; 08820  0x2E, 0xA1, 0x09, 0x2C
  ret                                          ; 08824  0xC3

sub_08825:                                     ; 08825
  mov cx, [bx + 0x48]                          ; 08825  0x8B, 0x4F, 0x48
  mov dx, [cs:0x2c04]                          ; 08828  0x2E, 0x8B, 0x16, 0x04, 0x2C
  db 0x2B, 0xCA                                ; 0882D  sub cx, dx
  shl cx, 1                                    ; 0882F  0xD1, 0xE1
  push cx                                      ; 08831  0x51
  mov cx, [cs:0x2c02]                          ; 08832  0x2E, 0x8B, 0x0E, 0x02, 0x2C
  db 0x2B, 0xD1                                ; 08837  sub dx, cx
  shl dx, 1                                    ; 08839  0xD1, 0xE2
  push dx                                      ; 0883B  0x52
  shl cx, 1                                    ; 0883C  0xD1, 0xE1
  call sub_08972                               ; 0883E  0xE8, 0x31, 0x01
  rep movsw                                    ; 08841  0xF3, 0xA5
  lea ax, [bx + 0x7c]                          ; 08843  0x8D, 0x47, 0x7C
  call sub_09621                               ; 08846  0xE8, 0xD8, 0x0D
  mov ax, 0x6140                               ; 08849  0xB8, 0x40, 0x61
  call sub_09621                               ; 0884C  0xE8, 0xD2, 0x0D
  pop cx                                       ; 0884F  0x59
  rep movsw                                    ; 08850  0xF3, 0xA5
  lea ax, [bx + 0x80]                          ; 08852  0x8D, 0x87, 0x80, 0x00
  call sub_09621                               ; 08856  0xE8, 0xC8, 0x0D
  mov ax, 0x6140                               ; 08859  0xB8, 0x40, 0x61
  call sub_09621                               ; 0885C  0xE8, 0xC2, 0x0D
  pop cx                                       ; 0885F  0x59
  rep movsw                                    ; 08860  0xF3, 0xA5
  push bx                                      ; 08862  0x53
  mov bx, [cs:0x2c00]                          ; 08863  0x2E, 0x8B, 0x1E, 0x00, 0x2C
  mov cx, [bx + 0x48]                          ; 08868  0x8B, 0x4F, 0x48
  pop bx                                       ; 0886B  0x5B
  jmp near loc_08960                           ; 0886C  0xE9, 0xF1, 0x00
  mov al, 5                                    ; 0886F  0xB0, 0x05
  jmp short loc_08875                          ; 08871  0xEB, 0x02
  mov al, 3                                    ; 08873  0xB0, 0x03

loc_08875:                                     ; 08875
  call sub_08972                               ; 08875  0xE8, 0xFA, 0x00
  mov cx, 0x3e                                 ; 08878  0xB9, 0x3E, 0x00
  rep movsw                                    ; 0887B  0xF3, 0xA5
  mov [cs:bx + 0x80], al                       ; 0887D  0x2E, 0x88, 0x87, 0x80, 0x00
  inc al                                       ; 08882  0xFE, 0xC0
  mov [cs:bx + 0x7c], al                       ; 08884  0x2E, 0x88, 0x47, 0x7C
  mov di, [cs:0x2c02]                          ; 08888  0x2E, 0x8B, 0x3E, 0x02, 0x2C
  shl di, 1                                    ; 0888D  0xD1, 0xE7
  shl di, 1                                    ; 0888F  0xD1, 0xE7
  db 0x03, 0xFB                                ; 08891  add di, bx
  lea ax, [bx + 0x7c]                          ; 08893  0x8D, 0x47, 0x7C
  call sub_09621                               ; 08896  0xE8, 0x88, 0x0D
  mov di, [cs:0x2c04]                          ; 08899  0x2E, 0x8B, 0x3E, 0x04, 0x2C
  inc di                                       ; 0889E  0x47
  inc di                                       ; 0889F  0x47
  shl di, 1                                    ; 088A0  0xD1, 0xE7
  shl di, 1                                    ; 088A2  0xD1, 0xE7
  db 0x03, 0xFB                                ; 088A4  add di, bx
  lea ax, [bx + 0x80]                          ; 088A6  0x8D, 0x87, 0x80, 0x00
  call sub_09621                               ; 088AA  0xE8, 0x74, 0x0D
  xor byte [cs:0x5fa6], 0x80                   ; 088AD  0x2E, 0x80, 0x36, 0xA6, 0x5F, 0x80
  ret                                          ; 088B3  0xC3
  call sub_08972                               ; 088B4  0xE8, 0xBB, 0x00
  add byte [cs:bx + 0x7c], 4                   ; 088B7  0x2E, 0x80, 0x47, 0x7C, 0x04
  add byte [cs:bx + 0x80], 4                   ; 088BC  0x2E, 0x80, 0x87, 0x80, 0x00, 0x04
  xor byte [cs:0x5fa6], 0x80                   ; 088C2  0x2E, 0x80, 0x36, 0xA6, 0x5F, 0x80
  ret                                          ; 088C8  0xC3
  call sub_08972                               ; 088C9  0xE8, 0xA6, 0x00
  sub byte [cs:bx + 0x7c], 4                   ; 088CC  0x2E, 0x80, 0x6F, 0x7C, 0x04
  sub byte [cs:bx + 0x80], 4                   ; 088D1  0x2E, 0x80, 0xAF, 0x80, 0x00, 0x04
  xor byte [cs:0x5fa6], 0x80                   ; 088D7  0x2E, 0x80, 0x36, 0xA6, 0x5F, 0x80
  ret                                          ; 088DD  0xC3
  mov bx, [cs:0x2c00]                          ; 088DE  0x2E, 0x8B, 0x1E, 0x00, 0x2C
  mov cx, [bx + 0x48]                          ; 088E3  0x8B, 0x4F, 0x48
  push bx                                      ; 088E6  0x53
  mov bx, 0x2c13                               ; 088E7  0xBB, 0x13, 0x2C
  call sub_08941                               ; 088EA  0xE8, 0x54, 0x00
  xor byte [cs:0x5fa6], 0x80                   ; 088ED  0x2E, 0x80, 0x36, 0xA6, 0x5F, 0x80
  pop bx                                       ; 088F3  0x5B
  mov byte [bx + 0x35], 0                      ; 088F4  0xC6, 0x47, 0x35, 0x00
  ret                                          ; 088F8  0xC3
  mov bx, [cs:0x2c00]                          ; 088F9  0x2E, 0x8B, 0x1E, 0x00, 0x2C
  mov al, [cs:0x2c06]                          ; 088FE  0x2E, 0xA0, 0x06, 0x2C
  db 0x0A, 0xC0                                ; 08902  or al, al
  jne loc_0890F                                ; 08904  0x75, 0x09
  and byte [bx + 0x6b], 0xfe                   ; 08906  0x80, 0x67, 0x6B, 0xFE
  call sub_085ED                               ; 0890A  0xE8, 0xE0, 0xFC
  db 0x32, 0xC0                                ; 0890D  xor al, al

loc_0890F:                                     ; 0890F
  ret                                          ; 0890F  0xC3
xios_int28_fn_02_scroll_step:                ; 08910
  push ds                                      ; 08910  0x1E
  pop es                                       ; 08911  0x07
  mov bl, [cs:0x2c07]                          ; 08912  0x2E, 0x8A, 0x1E, 0x07, 0x2C
  db 0x32, 0xFF                                ; 08917  xor bh, bh
  shl bx, 1                                    ; 08919  0xD1, 0xE3
  call word [cs:bx + 0x1d86]                   ; 0891B  0x2E, 0xFF, 0x97, 0x86, 0x1D
  inc byte [cs:0x2c07]                         ; 08920  0x2E, 0xFE, 0x06, 0x07, 0x2C
  ret                                          ; 08925  0xC3
  db 0xE9, 0x1B, 0xD3                          ; 08926  jmp 0x5c44
  sbb al, 0x14                                 ; 08929  0x1C, 0x14
  sbb ax, 0x1d14                               ; 0892B  0x1D, 0x14, 0x1D
  db 0x3E, 0x1D, 0x59, 0x1D                    ; 0892E  sbb ax, 0x1d59
  adc [si], bl                                 ; 08932  0x10, 0x1C
  iret                                         ; 08934  0xCF
  sbb al, 0x29                                 ; 08935  0x1C, 0x29
  sbb ax, 0x1d29                               ; 08937  0x1D, 0x29, 0x1D
  db 0x3E, 0x1D, 0x59, 0x1D                    ; 0893A  sbb ax, 0x1d59

sub_0893E:                                     ; 0893E
  mov cx, [bx + 0x48]                          ; 0893E  0x8B, 0x4F, 0x48

sub_08941:                                     ; 08941
  push cx                                      ; 08941  0x51
  db 0x8B, 0xF3                                ; 08942  mov si, bx
  mov di, 0x602a                               ; 08944  0xBF, 0x2A, 0x60
  test byte [cs:0x5fa6], 0x80                  ; 08947  0x2E, 0xF6, 0x06, 0xA6, 0x5F, 0x80
  jne loc_08952                                ; 0894D  0x75, 0x03
  mov di, 0x60b2                               ; 0894F  0xBF, 0xB2, 0x60

loc_08952:                                     ; 08952
  push cx                                      ; 08952  0x51
  lodsw                                        ; 08953  0xAD
  mov dx, [cs:0x2bf1]                          ; 08954  0x2E, 0x8B, 0x16, 0xF1, 0x2B
  call sub_09623                               ; 08959  0xE8, 0xC7, 0x0C
  pop cx                                       ; 0895C  0x59
  loop loc_08952                               ; 0895D  0xE2, 0xF3
  pop cx                                       ; 0895F  0x59

loc_08960:                                     ; 08960
  cmp cx, 0x18                                 ; 08960  0x83, 0xF9, 0x18
  ja loc_0896B                                 ; 08963  0x77, 0x06
  mov ax, 0x614a                               ; 08965  0xB8, 0x4A, 0x61
  call sub_09621                               ; 08968  0xE8, 0xB6, 0x0C

loc_0896B:                                     ; 0896B
  mov ax, 0x61ea                               ; 0896B  0xB8, 0xEA, 0x61
  call sub_09621                               ; 0896E  0xE8, 0xB0, 0x0C
  ret                                          ; 08971  0xC3

sub_08972:                                     ; 08972
  mov si, 0x602a                               ; 08972  0xBE, 0x2A, 0x60
  mov di, 0x60b2                               ; 08975  0xBF, 0xB2, 0x60
  test byte [cs:0x5fa6], 0x80                  ; 08978  0x2E, 0xF6, 0x06, 0xA6, 0x5F, 0x80
  je loc_08982                                 ; 0897E  0x74, 0x02
  xchg si, di                                  ; 08980  87 F7

loc_08982:                                     ; 08982
  db 0x8B, 0xDF                                ; 08982  mov bx, di
  ret                                          ; 08984  0xC3

sub_08985:                                     ; 08985
  mov bp, [bx + 0x6b]                          ; 08985  0x8B, 0x6F, 0x6B
  mov [cs:0x1fce], bp                          ; 08988  0x2E, 0x89, 0x2E, 0xCE, 0x1F
  push bx                                      ; 0898D  0x53
  push ds                                      ; 0898E  0x1E
  call sub_08B5E                               ; 0898F  0xE8, 0xCC, 0x01
  db 0x32, 0xED                                ; 08992  xor ch, ch
  db 0x8B, 0xD9                                ; 08994  mov bx, cx
  mov cl, 5                                    ; 08996  0xB1, 0x05
  shl bx, cl                                   ; 08998  0xD3, 0xE3
  call sub_08B27                               ; 0899A  0xE8, 0x8A, 0x01
  cmp byte [cs:0x1fd7], 2                      ; 0899D  0x2E, 0x80, 0x3E, 0xD7, 0x1F, 0x02
  je loc_089AC                                 ; 089A3  0x74, 0x07
  mov bp, 0x1ff                                ; 089A5  0xBD, 0xFF, 0x01
  ror bp, cl                                   ; 089A8  0xD3, 0xCD
  jmp short loc_089CB                          ; 089AA  0xEB, 0x1F

loc_089AC:                                     ; 089AC
  cmp cl, 3                                    ; 089AC  0x80, 0xF9, 0x03
  jge loc_089BE                                ; 089AF  0x7D, 0x0D
  mov bp, 3                                    ; 089B1  0xBD, 0x03, 0x00
  ror bp, cl                                   ; 089B4  0xD3, 0xCD
  mov byte [cs:0x1fd8], 0xff                   ; 089B6  0x2E, 0xC6, 0x06, 0xD8, 0x1F, 0xFF
  jmp short loc_089CB                          ; 089BC  0xEB, 0x0D

loc_089BE:                                     ; 089BE
  mov bp, 0x3ff                                ; 089BE  0xBD, 0xFF, 0x03
  mov byte [cs:0x1fd8], 0                      ; 089C1  0x2E, 0xC6, 0x06, 0xD8, 0x1F, 0x00
  ror bp, cl                                   ; 089C7  0xD3, 0xCD
  shr cl, 1                                    ; 089C9  0xD0, 0xE9

loc_089CB:                                     ; 089CB
  mov ch, 0xa                                  ; 089CB  0xB5, 0x0A

loc_089CD:                                     ; 089CD
  mov ax, [es:bx]                              ; 089CD  0x26, 0x8B, 0x07
  test word [cs:0x1fce], 0x400                 ; 089D0  2E F7 06 CE 1F 00 04
  je loc_089DB                                 ; 089D7  0x74, 0x02
  not ax                                       ; 089D9  0xF7, 0xD0

loc_089DB:                                     ; 089DB
  and ax, 0xfe00                               ; 089DB  0x25, 0x00, 0xFE
  cmp byte [cs:0x1fd7], 2                      ; 089DE  0x2E, 0x80, 0x3E, 0xD7, 0x1F, 0x02
  jne loc_089F8                                ; 089E4  0x75, 0x12
  cmp byte [cs:0x1fd8], 0                      ; 089E6  0x2E, 0x80, 0x3E, 0xD8, 0x1F, 0x00
  je loc_089F8                                 ; 089EC  0x74, 0x0A
  push cx                                      ; 089EE  0x51
  mov cx, 8                                    ; 089EF  0xB9, 0x08, 0x00
  call sub_08A49                               ; 089F2  0xE8, 0x54, 0x00
  db 0x8B, 0xC2                                ; 089F5  mov ax, dx
  pop cx                                       ; 089F7  0x59

loc_089F8:                                     ; 089F8
  ror ax, cl                                   ; 089F8  0xD3, 0xC8
  cmp byte [cs:0x1fd7], 2                      ; 089FA  0x2E, 0x80, 0x3E, 0xD7, 0x1F, 0x02
  jne loc_08A0A                                ; 08A00  0x75, 0x08
  cmp byte [cs:0x1fd8], 0                      ; 08A02  0x2E, 0x80, 0x3E, 0xD8, 0x1F, 0x00
  je loc_08A18                                 ; 08A08  0x74, 0x0E

loc_08A0A:                                     ; 08A0A
  mov dh, [si]                                 ; 08A0A  0x8A, 0x34
  mov dl, [di]                                 ; 08A0C  0x8A, 0x15
  db 0x23, 0xD5                                ; 08A0E  and dx, bp
  db 0x0B, 0xD0                                ; 08A10  or dx, ax
  mov [si], dh                                 ; 08A12  0x88, 0x34
  mov [di], dl                                 ; 08A14  0x88, 0x15
  jmp short loc_08A38                          ; 08A16  0xEB, 0x20

loc_08A18:                                     ; 08A18
  db 0x8B, 0xD5                                ; 08A18  mov dx, bp
  and [si], dh                                 ; 08A1A  0x20, 0x34
  and [si + 0x200], dl                         ; 08A1C  0x20, 0x94, 0x00, 0x02
  push cx                                      ; 08A20  0x51
  mov cx, 4                                    ; 08A21  0xB9, 0x04, 0x00
  call sub_08A49                               ; 08A24  0xE8, 0x22, 0x00
  push dx                                      ; 08A27  0x52
  mov cx, 8                                    ; 08A28  0xB9, 0x08, 0x00
  call sub_08A49                               ; 08A2B  0xE8, 0x1B, 0x00
  pop ax                                       ; 08A2E  0x58
  pop cx                                       ; 08A2F  0x59
  or [si], al                                  ; 08A30  0x08, 0x04
  mov [di], dh                                 ; 08A32  0x88, 0x35
  or [si + 0x200], dl                          ; 08A34  0x08, 0x94, 0x00, 0x02

loc_08A38:                                     ; 08A38
  inc bx                                       ; 08A38  0x43
  inc bx                                       ; 08A39  0x43
  inc si                                       ; 08A3A  0x46
  inc si                                       ; 08A3B  0x46
  inc di                                       ; 08A3C  0x47
  inc di                                       ; 08A3D  0x47
  dec ch                                       ; 08A3E  0xFE, 0xCD
  jne loc_089CD                                ; 08A40  0x75, 0x8B
  pop ds                                       ; 08A42  0x1F
  pop bx                                       ; 08A43  0x5B
  mov byte [bx + 0x35], 0                      ; 08A44  0xC6, 0x47, 0x35, 0x00
  ret                                          ; 08A48  0xC3

sub_08A49:                                     ; 08A49
  db 0x33, 0xD2                                ; 08A49  xor dx, dx

loc_08A4B:                                     ; 08A4B
  shl ax, 1                                    ; 08A4B  0xD1, 0xE0
  rcl dx, 1                                    ; 08A4D  0xD1, 0xD2
  rol dx, 1                                    ; 08A4F  0xD1, 0xC2
  loop loc_08A4B                               ; 08A51  0xE2, 0xF8
  ret                                          ; 08A53  0xC3

sub_8a54:                                      ; 08A54
  test byte [bx + 0x6b], 4                     ; 08A54  0xF6, 0x47, 0x6B, 0x04
  je loc_08A91                                 ; 08A58  0x74, 0x37
  test word [bx + 0x6b], 0x200                 ; 08A5A  0xF7, 0x47, 0x6B, 0x00, 0x02
  jne loc_08A91                                ; 08A5F  0x75, 0x30
  push ds                                      ; 08A61  0x1E
  call sub_08B5E                               ; 08A62  0xE8, 0xF9, 0x00
  mov dx, [cs:0x1fd0]                          ; 08A65  0x2E, 0x8B, 0x16, 0xD0, 0x1F
  mov si, [cs:0x1fd3]                          ; 08A6A  0x2E, 0x8B, 0x36, 0xD3, 0x1F
  mov di, [cs:0x1fd5]                          ; 08A6F  0x2E, 0x8B, 0x3E, 0xD5, 0x1F
  xor [si], dh                                 ; 08A74  0x30, 0x34
  cmp byte [cs:0x1fd7], 2                      ; 08A76  0x2E, 0x80, 0x3E, 0xD7, 0x1F, 0x02
  je loc_08A82                                 ; 08A7C  0x74, 0x04
  xor [di], dl                                 ; 08A7E  0x30, 0x15
  jmp short loc_08A8C                          ; 08A80  0xEB, 0x0A

loc_08A82:                                     ; 08A82
  xor [di], dl                                 ; 08A82  0x30, 0x15
  mov al, [cs:0x1fd2]                          ; 08A84  0x2E, 0xA0, 0xD2, 0x1F
  xor [si + 0x200], al                         ; 08A88  0x30, 0x84, 0x00, 0x02

loc_08A8C:                                     ; 08A8C
  pop ds                                       ; 08A8C  0x1F
  mov byte [bx + 0x35], 0                      ; 08A8D  0xC6, 0x47, 0x35, 0x00

loc_08A91:                                     ; 08A91
  ret                                          ; 08A91  0xC3

loc_08A92:                                     ; 08A92
  call sub_8a54                                ; 08A92  0xE8, 0xBF, 0xFF

sub_8a95:                                      ; 08A95
  test word [bx + 0x6b], 0x200                 ; 08A95  0xF7, 0x47, 0x6B, 0x00, 0x02
  jne loc_08A91                                ; 08A9A  0x75, 0xF5
  mov ax, [bx + 0x64]                          ; 08A9C  0x8B, 0x47, 0x64
  mov dx, [bx + 0x66]                          ; 08A9F  0x8B, 0x57, 0x66
  push ds                                      ; 08AA2  0x1E
  call sub_08B5E                               ; 08AA3  0xE8, 0xB8, 0x00
  call sub_08B27                               ; 08AA6  0xE8, 0x7E, 0x00
  add si, 0x12                                 ; 08AA9  0x83, 0xC6, 0x12
  add di, 0x12                                 ; 08AAC  0x83, 0xC7, 0x12
  cmp byte [cs:0x1fd7], 2                      ; 08AAF  0x2E, 0x80, 0x3E, 0xD7, 0x1F, 0x02
  je loc_08AC2                                 ; 08AB5  0x74, 0x0B
  mov dx, 0xfe00                               ; 08AB7  0xBA, 0x00, 0xFE
  ror dx, cl                                   ; 08ABA  0xD3, 0xCA
  xor [si], dh                                 ; 08ABC  0x30, 0x34
  xor [di], dl                                 ; 08ABE  0x30, 0x15
  jmp short loc_08AD9                          ; 08AC0  0xEB, 0x17

loc_08AC2:                                     ; 08AC2
  mov dx, 0xfffc                               ; 08AC2  0xBA, 0xFC, 0xFF
  db 0x8A, 0xE2                                ; 08AC5  mov ah, dl
  db 0x32, 0xC0                                ; 08AC7  xor al, al
  shr dx, cl                                   ; 08AC9  0xD3, 0xEA
  shr ax, cl                                   ; 08ACB  0xD3, 0xE8
  xor [si], dh                                 ; 08ACD  0x30, 0x34
  xor [di], dl                                 ; 08ACF  0x30, 0x15
  xor [si + 0x200], al                         ; 08AD1  0x30, 0x84, 0x00, 0x02
  mov [cs:0x1fd2], al                          ; 08AD5  0x2E, 0xA2, 0xD2, 0x1F

loc_08AD9:                                     ; 08AD9
  mov [cs:0x1fd0], dx                          ; 08AD9  0x2E, 0x89, 0x16, 0xD0, 0x1F
  mov [cs:0x1fd3], si                          ; 08ADE  0x2E, 0x89, 0x36, 0xD3, 0x1F
  mov [cs:0x1fd5], di                          ; 08AE3  0x2E, 0x89, 0x3E, 0xD5, 0x1F
  pop ds                                       ; 08AE8  0x1F
  mov byte [bx + 0x35], 0                      ; 08AE9  0xC6, 0x47, 0x35, 0x00
  ret                                          ; 08AED  0xC3

loc_08AEE:                                     ; 08AEE
  push di                                      ; 08AEE  0x57
  push ds                                      ; 08AEF  0x1E
  db 0x8B, 0xC7                                ; 08AF0  mov ax, di
  db 0x2B, 0xC6                                ; 08AF2  sub ax, si
  mov ah, 0xa                                  ; 08AF4  0xB4, 0x0A
  db 0xF6, 0xE4                                ; 08AF6  mul ah
  db 0x8B, 0xC8                                ; 08AF8  mov cx, ax
  db 0x8B, 0xC6                                ; 08AFA  mov ax, si
  mov ah, 0xa                                  ; 08AFC  0xB4, 0x0A
  db 0xF6, 0xE4                                ; 08AFE  mul ah
  shl ax, 1                                    ; 08B00  0xD1, 0xE0
  db 0x8B, 0xF8                                ; 08B02  mov di, ax
  mov dx, 0x23                                 ; 08B04  0xBA, 0x23, 0x00
  call sub_08B5E                               ; 08B07  0xE8, 0x54, 0x00
  push ds                                      ; 08B0A  0x1E
  pop es                                       ; 08B0B  0x07

loc_08B0C:                                     ; 08B0C
  db 0x8B, 0xF7                                ; 08B0C  mov si, di
  add si, 0x14                                 ; 08B0E  0x83, 0xC6, 0x14
  push di                                      ; 08B11  0x57
  push cx                                      ; 08B12  0x51
  rep movsw                                    ; 08B13  0xF3, 0xA5
  pop cx                                       ; 08B15  0x59
  pop di                                       ; 08B16  0x5F
  add di, 0x200                                ; 08B17  0x81, 0xC7, 0x00, 0x02
  dec dx                                       ; 08B1B  0x4A
  jne loc_08B0C                                ; 08B1C  0x75, 0xEE
  pop ds                                       ; 08B1E  0x1F
  pop si                                       ; 08B1F  0x5E
  mov byte [bx + 0x35], 0                      ; 08B20  0xC6, 0x47, 0x35, 0x00
  jmp near sub_0865C                           ; 08B24  0xE9, 0x35, 0xFB

sub_08B27:                                     ; 08B27
  mov ah, 0xa                                  ; 08B27  0xB4, 0x0A
  db 0xF6, 0xE4                                ; 08B29  mul ah
  db 0x8B, 0xF0                                ; 08B2B  mov si, ax
  mov ax, 7                                    ; 08B2D  0xB8, 0x07, 0x00
  db 0xF7, 0xE2                                ; 08B30  mul dx
  cmp byte [cs:0x1fd7], 2                      ; 08B32  0x2E, 0x80, 0x3E, 0xD7, 0x1F, 0x02
  jne loc_08B3C                                ; 08B38  0x75, 0x02
  shl ax, 1                                    ; 08B3A  0xD1, 0xE0

loc_08B3C:                                     ; 08B3C
  db 0x8B, 0xC8                                ; 08B3C  mov cx, ax
  and ax, strict word 0xfff0                   ; 08B3E  25 F0 FF
  mov dx, 0x10                                 ; 08B41  0xBA, 0x10, 0x00
  db 0xF7, 0xE2                                ; 08B44  mul dx
  db 0x03, 0xF0                                ; 08B46  add si, ax
  shl si, 1                                    ; 08B48  0xD1, 0xE6
  db 0x8B, 0xFE                                ; 08B4A  mov di, si
  test cx, 8                                   ; 08B4C  0xF7, 0xC1, 0x08, 0x00
  jne loc_08B55                                ; 08B50  0x75, 0x03
  inc si                                       ; 08B52  0x46
  jmp short loc_08B59                          ; 08B53  0xEB, 0x04

loc_08B55:                                     ; 08B55
  add di, 0x201                                ; 08B55  0x81, 0xC7, 0x01, 0x02

loc_08B59:                                     ; 08B59
  and cx, strict word 7                        ; 08B59  81 E1 07 00
  ret                                          ; 08B5D  0xC3

sub_08B5E:                                     ; 08B5E
  push ax                                      ; 08B5E  0x50
  call sub_09220                               ; 08B5F  0xE8, 0xBE, 0x06
  pop ax                                       ; 08B62  0x58
  mov es, [cs:0x2c4e]                          ; 08B63  0x2E, 0x8E, 0x06, 0x4E, 0x2C
  mov ds, [cs:0x2c50]                          ; 08B68  0x2E, 0x8E, 0x1E, 0x50, 0x2C
  ret                                          ; 08B6D  0xC3
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00  ; 08B6E  ...........

sub_08B79:                                     ; 08B79
  db 0x33, 0xC9                                ; 08B79  xor cx, cx
  mov cl, [di]                                 ; 08B7B  0x8A, 0x0D
  inc di                                       ; 08B7D  0x47
  inc cx                                       ; 08B7E  0x41
  repne scasb                                  ; 08B7F  0xF2, 0xAE
  pop si                                       ; 08B81  0x5E
  shl cx, 1                                    ; 08B82  0xD1, 0xE1
  db 0x03, 0xF1                                ; 08B84  add si, cx
  jmp word [si]                                ; 08B86  0xFF, 0x24
io_switch:
  cmp dl, [cs:0x2b56]                          ; 08B88  0x2E, 0x3A, 0x16, 0x56, 0x2B
  jne loc_08B90                                ; 08B8D  0x75, 0x01
  ret                                          ; 08B8F  0xC3

loc_08B90:                                     ; 08B90
  mov bx, [cs:0x2b58]                          ; 08B90  0x2E, 0x8B, 0x1E, 0x58, 0x2B
  call sub_08C56                               ; 08B95  0xE8, 0xBE, 0x00
  je loc_08B9B                                 ; 08B98  0x74, 0x01
  ret                                          ; 08B9A  0xC3

loc_08B9B:                                     ; 08B9B
  cmp byte [cs:0x10b1], 0                      ; 08B9B  0x2E, 0x80, 0x3E, 0xB1, 0x10, 0x00
  je loc_08BA9                                 ; 08BA1  0x74, 0x06
  mov byte [cs:0x10b1], 1                      ; 08BA3  0x2E, 0xC6, 0x06, 0xB1, 0x10, 0x01

loc_08BA9:                                     ; 08BA9
  call sub_0922F                               ; 08BA9  0xE8, 0x83, 0x06
  test byte [bx + 0x6b], 1                     ; 08BAC  0xF6, 0x47, 0x6B, 0x01
  je loc_08BB5                                 ; 08BB0  0x74, 0x03
  call sub_09312                               ; 08BB2  0xE8, 0x5D, 0x07

loc_08BB5:                                     ; 08BB5
  or byte [bx + 0x6b], 2                       ; 08BB5  0x80, 0x4F, 0x6B, 0x02
  mov cl, [bx + 0x70]                          ; 08BB9  0x8A, 0x4F, 0x70
  call sub_092F2                               ; 08BBC  0xE8, 0x33, 0x07
  mov [cs:0x2b58], bx                          ; 08BBF  0x2E, 0x89, 0x1E, 0x58, 0x2B
  and byte [bx + 0x6b], 0xfd                   ; 08BC4  0x80, 0x67, 0x6B, 0xFD
  cmp cl, [bx + 0x70]                          ; 08BC8  0x3A, 0x4F, 0x70
  je sub_08BFB                                 ; 08BCB  0x74, 0x2E
  push es                                      ; 08BCD  0x06
  les si, [cs:0x2c49]                          ; 08BCE  0x2E, 0xC4, 0x36, 0x49, 0x2C

loc_08BD3:                                     ; 08BD3
  mov al, 0xff                                 ; 08BD3  0xB0, 0xFF
  xchg [es:si], al                             ; 08BD5  0x26, 0x86, 0x04
  db 0x0A, 0xC0                                ; 08BD8  or al, al
  je loc_08BE1                                 ; 08BDA  0x74, 0x05
  call sub_09312                               ; 08BDC  0xE8, 0x33, 0x07
  jmp short loc_08BD3                          ; 08BDF  0xEB, 0xF2

loc_08BE1:                                     ; 08BE1
  push si                                      ; 08BE1  0x56
  push es                                      ; 08BE2  0x06
  mov ah, 3                                    ; 08BE3  0xB4, 0x03
  call xios_crt_trigger_ca                     ; 08BE5  0xE8, 0x19, 0x0A
  call sub_08FE7                               ; 08BE8  0xE8, 0xFC, 0x03
  pop es                                       ; 08BEB  0x07
  pop si                                       ; 08BEC  0x5E
  mov dx, [cs:0x2c50]                          ; 08BED  0x2E, 0x8B, 0x16, 0x50, 0x2C
  mov [es:si + 1], dx                          ; 08BF2  0x26, 0x89, 0x54, 0x01
  mov byte [es:si], 0                          ; 08BF6  0x26, 0xC6, 0x04, 0x00
  pop es                                       ; 08BFA  0x07

sub_08BFB:                                     ; 08BFB
  push es                                      ; 08BFB  0x06
  push ds                                      ; 08BFC  0x1E
  pop es                                       ; 08BFD  0x07
  mov dl, [bx + 0x34]                          ; 08BFE  0x8A, 0x57, 0x34
  call sub_0928E                               ; 08C01  0xE8, 0x8A, 0x06
  db 0x2E, 0xC7, 0x06, 0xBE, 0x5F, 0xFF, 0xFF  ; 08C04  mov word [cs:0x5fbe], 0xffff
  call sub_096B8                               ; 08C0B  0xE8, 0xAA, 0x0A
  call sub_0920B                               ; 08C0E  0xE8, 0xFA, 0x05
  mov cx, [bx + 0x48]                          ; 08C11  0x8B, 0x4F, 0x48
  push bx                                      ; 08C14  0x53
  mov byte [cs:0x2b5a], 0xff                   ; 08C15  0x2E, 0xC6, 0x06, 0x5A, 0x2B, 0xFF
  test byte [bx + 0x6b], 4                     ; 08C1B  0xF6, 0x47, 0x6B, 0x04
  jne loc_08C36                                ; 08C1F  0x75, 0x15
  test byte [bx + 0x6b], 0x10                  ; 08C21  0xF6, 0x47, 0x6B, 0x10
  je loc_08C36                                 ; 08C25  0x74, 0x0F
  mov byte [cs:0x2b5a], 0                      ; 08C27  0x2E, 0xC6, 0x06, 0x5A, 0x2B, 0x00
  call sub_09333                               ; 08C2D  0xE8, 0x03, 0x07
  mov bx, 0x61f6                               ; 08C30  0xBB, 0xF6, 0x61
  mov cx, 0x18                                 ; 08C33  0xB9, 0x18, 0x00

loc_08C36:                                     ; 08C36
  call sub_08941                               ; 08C36  0xE8, 0x08, 0xFD
  pop bx                                       ; 08C39  0x5B
  xor byte [cs:0x5fa6], 0x80                   ; 08C3A  0x2E, 0x80, 0x36, 0xA6, 0x5F, 0x80
  call sub_096CF                               ; 08C40  0xE8, 0x8C, 0x0A
  mov ah, 1                                    ; 08C43  0xB4, 0x01
  call xios_crt_trigger_ca                     ; 08C45  0xE8, 0xB9, 0x09
  test byte [bx + 0x6b], 4                     ; 08C48  0xF6, 0x47, 0x6B, 0x04
  jne loc_08C51                                ; 08C4C  0x75, 0x03
  call sub_085ED                               ; 08C4E  0xE8, 0x9C, 0xF9

loc_08C51:                                     ; 08C51
  call sub_09243                               ; 08C51  0xE8, 0xEF, 0x05
  pop es                                       ; 08C54  0x07
  ret                                          ; 08C55  0xC3

sub_08C56:                                     ; 08C56
  mov si, [bx + 0x5c]                          ; 08C56  0x8B, 0x77, 0x5C
  test word [si + 0xe], 8                      ; 08C59  0xF7, 0x44, 0x0E, 0x08, 0x00
  ret                                          ; 08C5E  0xC3

sub_08C5F:                                     ; 08C5F
  db 0x33, 0xC9                                ; 08C5F  xor cx, cx

io_statline:
sub_08C61:                                     ; 08C61
  mov bx, 0x222b                               ; 08C61  0xBB, 0x2B, 0x22

loc_08C64:                                     ; 08C64
  mov al, 0xff                                 ; 08C64  0xB0, 0xFF
  xchg [cs:0x224e], al                         ; 08C66  0x2E, 0x86, 0x06, 0x4E, 0x22
  cmp al, 0xff                                 ; 08C6B  0x3C, 0xFF
  jne loc_08C74                                ; 08C6D  0x75, 0x05
  call sub_09312                               ; 08C6F  0xE8, 0xA0, 0x06
  jmp short loc_08C64                          ; 08C72  0xEB, 0xF0

loc_08C74:                                     ; 08C74
  cld                                          ; 08C74  0xFC
  push es                                      ; 08C75  0x06
  push ds                                      ; 08C76  0x1E
  push bx                                      ; 08C77  0x53
  mov ax, cs                                   ; 08C78  0x8C, 0xC8
  mov es, ax                                   ; 08C7A  0x8E, 0xC0
  mov al, 0xff                                 ; 08C7C  0xB0, 0xFF
  jcxz loc_08C85                               ; 08C7E  0xE3, 0x05
  mov [cs:0x224f], cx                          ; 08C80  0x2E, 0x89, 0x0E, 0x4F, 0x22

loc_08C85:                                     ; 08C85
  cmp word [cs:0x224f], -1                     ; 08C85  0x2E, 0x83, 0x3E, 0x4F, 0x22, 0xFF
  je loc_08C9A                                 ; 08C8B  0x74, 0x0D
  jcxz loc_08C96                               ; 08C8D  0xE3, 0x07
  mov ds, dx                                   ; 08C8F  0x8E, 0xDA
  db 0x8B, 0xF1                                ; 08C91  mov si, cx
  jmp near loc_08DB2                           ; 08C93  0xE9, 0x1C, 0x01

loc_08C96:                                     ; 08C96
  pop bx                                       ; 08C96  0x5B
  jmp near loc_08DC2                           ; 08C97  0xE9, 0x28, 0x01

loc_08C9A:                                     ; 08C9A
  mov di, 0x484d                               ; 08C9A  0xBF, 0x4D, 0x48
  mov al, 0x20                                 ; 08C9D  0xB0, 0x20
  mov cx, 0x487c                               ; 08C9F  0xB9, 0x7C, 0x48
  db 0x2B, 0xCF                                ; 08CA2  sub cx, di
  rep stosb                                    ; 08CA4  0xF3, 0xAA
  mov di, 0x4884                               ; 08CA6  0xBF, 0x84, 0x48
  mov cx, 0x488c                               ; 08CA9  0xB9, 0x8C, 0x48
  db 0x2B, 0xCF                                ; 08CAC  sub cx, di
  rep stosb                                    ; 08CAE  0xF3, 0xAA
  mov al, [cs:0x2b56]                          ; 08CB0  0x2E, 0xA0, 0x56, 0x2B
  add al, 0x30                                 ; 08CB4  0x04, 0x30
  mov [cs:0x484d], al                          ; 08CB6  0x2E, 0xA2, 0x4D, 0x48
  db 0x2E, 0xC7, 0x06, 0x84, 0x48, 0x30, 0x20  ; 08CBA  mov word [cs:0x4884], 0x2030
  mov bx, [cs:0x2b58]                          ; 08CC1  0x2E, 0x8B, 0x1E, 0x58, 0x2B
  mov bx, [bx + 0x5c]                          ; 08CC6  0x8B, 0x5F, 0x5C
  mov si, [bx]                                 ; 08CC9  0x8B, 0x37
  test si, si                                  ; 08CCB  0x85, 0xF6
  je loc_08CE4                                 ; 08CCD  0x74, 0x15
  mov al, [si + 0x24]                          ; 08CCF  0x8A, 0x44, 0x24
  call sub_08DDE                               ; 08CD2  0xE8, 0x09, 0x01
  mov [cs:0x4884], ax                          ; 08CD5  0x2E, 0xA3, 0x84, 0x48
  lea si, [si + 8]                             ; 08CD9  0x8D, 0x74, 0x08
  mov di, 0x4858                               ; 08CDC  0xBF, 0x58, 0x48
  mov cx, 4                                    ; 08CDF  0xB9, 0x04, 0x00
  rep movsw                                    ; 08CE2  0xF3, 0xA5

loc_08CE4:                                     ; 08CE4
  mov cx, [bx + 0xe]                           ; 08CE4  0x8B, 0x4F, 0x0E
  test cx, 0x80                                ; 08CE7  0xF7, 0xC1, 0x80, 0x00
  je loc_08CF6                                 ; 08CEB  0x74, 0x09
  db 0x2E, 0xC7, 0x06, 0x73, 0x48, 0x92, 0x53  ; 08CED  mov word [cs:0x4873], 0x5392
  jmp short loc_08D03                          ; 08CF4  0xEB, 0x0D

loc_08CF6:                                     ; 08CF6
  test cx, 0x100                               ; 08CF6  0xF7, 0xC1, 0x00, 0x01
  je loc_08D03                                 ; 08CFA  0x74, 0x07
  db 0x2E, 0xC7, 0x06, 0x73, 0x48, 0x92, 0x4F  ; 08CFC  mov word [cs:0x4873], 0x4f92

loc_08D03:                                     ; 08D03
  test cx, 0x200                               ; 08D03  0xF7, 0xC1, 0x00, 0x02
  je loc_08D1D                                 ; 08D07  0x74, 0x14
  mov di, 0x4876                               ; 08D09  0xBF, 0x76, 0x48
  mov word [di], 0x5092                        ; 08D0C  0xC7, 0x05, 0x92, 0x50
  mov byte [di + 2], 0x3d                      ; 08D10  0xC6, 0x45, 0x02, 0x3D
  mov al, [bx + 8]                             ; 08D14  0x8A, 0x47, 0x08
  call sub_08DDE                               ; 08D17  0xE8, 0xC4, 0x00
  mov [di + 3], ax                             ; 08D1A  0x89, 0x45, 0x03

loc_08D1D:                                     ; 08D1D
  mov si, 0x48ad                               ; 08D1D  0xBE, 0xAD, 0x48
  test cx, 8                                   ; 08D20  0xF7, 0xC1, 0x08, 0x00
  jne loc_08D3B                                ; 08D24  0x75, 0x15
  mov si, 0x4895                               ; 08D26  0xBE, 0x95, 0x48
  test cx, 1                                   ; 08D29  0xF7, 0xC1, 0x01, 0x00
  je loc_08D3B                                 ; 08D2D  0x74, 0x0C
  mov si, 0x489d                               ; 08D2F  0xBE, 0x9D, 0x48
  test cx, 4                                   ; 08D32  0xF7, 0xC1, 0x04, 0x00
  je loc_08D3B                                 ; 08D36  0x74, 0x03
  mov si, 0x48a5                               ; 08D38  0xBE, 0xA5, 0x48

loc_08D3B:                                     ; 08D3B
  mov di, 0x484f                               ; 08D3B  0xBF, 0x4F, 0x48
  mov cx, 8                                    ; 08D3E  0xB9, 0x08, 0x00
  rep movsb                                    ; 08D41  0xF3, 0xA4
  mov cx, 0x10                                 ; 08D43  0xB9, 0x10, 0x00
  mov ah, 0x41                                 ; 08D46  0xB4, 0x41
  mov al, 0x20                                 ; 08D48  0xB0, 0x20
  mov dx, [cs:0x88]                            ; 08D4A  0x2E, 0x8B, 0x16, 0x88, 0x00
  mov di, 0x4862                               ; 08D4F  0xBF, 0x62, 0x48

loc_08D52:                                     ; 08D52
  shr dx, 1                                    ; 08D52  0xD1, 0xEA
  jae loc_08D5D                                ; 08D54  0x73, 0x07
  xchg ah, al                                  ; 08D56  86 E0
  stosb                                        ; 08D58  0xAA
  xchg ah, al                                  ; 08D59  86 E0
  jmp short loc_08D5E                          ; 08D5B  0xEB, 0x01

loc_08D5D:                                     ; 08D5D
  stosb                                        ; 08D5D  0xAA

loc_08D5E:                                     ; 08D5E
  inc ah                                       ; 08D5E  0xFE, 0xC4
  loop loc_08D52                               ; 08D60  0xE2, 0xF0
  mov si, 0x80                                 ; 08D62  0xBE, 0x80, 0x00
  mov di, 0x488c                               ; 08D65  0xBF, 0x8C, 0x48
  mov cx, 3                                    ; 08D68  0xB9, 0x03, 0x00

loc_08D6B:                                     ; 08D6B
  lodsb                                        ; 08D6B  0xAC
  call sub_08DD5                               ; 08D6C  0xE8, 0x66, 0x00
  stosw                                        ; 08D6F  0xAB
  inc di                                       ; 08D70  0x47
  loop loc_08D6B                               ; 08D71  0xE2, 0xF8
  mov al, [cs:0x1046]                          ; 08D73  0x2E, 0xA0, 0x46, 0x10
  test al, 0x20                                ; 08D77  0xA8, 0x20
  je loc_08D86                                 ; 08D79  0x74, 0x0B
  mov si, 0x48b5                               ; 08D7B  0xBE, 0xB5, 0x48
  mov di, 0x4887                               ; 08D7E  0xBF, 0x87, 0x48
  mov cx, 4                                    ; 08D81  0xB9, 0x04, 0x00
  rep movsb                                    ; 08D84  0xF3, 0xA4

loc_08D86:                                     ; 08D86
  cmp byte [cs:0x2b51], 0                      ; 08D86  0x2E, 0x80, 0x3E, 0x51, 0x2B, 0x00
  je loc_08D94                                 ; 08D8C  0x74, 0x06
  mov byte [cs:0x4861], 7                      ; 08D8E  0x2E, 0xC6, 0x06, 0x61, 0x48, 0x07

loc_08D94:                                     ; 08D94
  test byte [cs:0x2b5a], 0xff                  ; 08D94  0x2E, 0xF6, 0x06, 0x5A, 0x2B, 0xFF
  jne loc_08DAF                                ; 08D9A  0x75, 0x13
  mov cx, 1                                    ; 08D9C  0xB9, 0x01, 0x00
  mov si, 0x2bf3                               ; 08D9F  0xBE, 0xF3, 0x2B

loc_08DA2:                                     ; 08DA2
  lodsw                                        ; 08DA2  0xAD
  xchg bx, ax                                  ; 08DA3  0x93
  push cx                                      ; 08DA4  0x51
  push si                                      ; 08DA5  0x56
  push es                                      ; 08DA6  0x06
  call sub_09473                               ; 08DA7  0xE8, 0xC9, 0x06
  pop es                                       ; 08DAA  0x07
  pop si                                       ; 08DAB  0x5E
  pop cx                                       ; 08DAC  0x59
  loop loc_08DA2                               ; 08DAD  0xE2, 0xF3

loc_08DAF:                                     ; 08DAF
  mov si, 0x4845                               ; 08DAF  0xBE, 0x45, 0x48

loc_08DB2:                                     ; 08DB2
  mov di, 0x614a                               ; 08DB2  0xBF, 0x4A, 0x61
  mov ah, 8                                    ; 08DB5  0xB4, 0x08
  mov cx, 0x50                                 ; 08DB7  0xB9, 0x50, 0x00
  pop bx                                       ; 08DBA  0x5B

loc_08DBB:                                     ; 08DBB
  call bx                                      ; 08DBB  0xFF, 0xD3
  stosw                                        ; 08DBD  0xAB
  loop loc_08DBB                               ; 08DBE  0xE2, 0xFB
  db 0x32, 0xC0                                ; 08DC0  xor al, al

loc_08DC2:                                     ; 08DC2
  mov byte [cs:0x224e], 0                      ; 08DC2  0x2E, 0xC6, 0x06, 0x4E, 0x22, 0x00
  pop ds                                       ; 08DC8  0x1F
  pop es                                       ; 08DC9  0x07
  ret                                          ; 08DCA  0xC3
  lodsb                                        ; 08DCB  0xAC
  ret                                          ; 08DCC  0xC3
  lodsw                                        ; 08DCD  0xAD
  ret                                          ; 08DCE  0xC3
  mov bx, 0x222d                               ; 08DCF  0xBB, 0x2D, 0x22
  jmp near loc_08C64                           ; 08DD2  0xE9, 0x8F, 0xFE

sub_08DD5:                                     ; 08DD5
  mov ah, 0x33                                 ; 08DD5  0xB4, 0x33
  ror ax, 4                                    ; 08DD7  0xC1, 0xC8, 0x04
  ror ah, 4                                    ; 08DDA  0xC0, 0xCC, 0x04
  ret                                          ; 08DDD  0xC3

sub_08DDE:                                     ; 08DDE
  db 0xD4, 0x0A                                ; 08DDE  aam 0xa
  add ax, 0x3030                               ; 08DE0  0x05, 0x30, 0x30
  xchg al, ah                                  ; 08DE3  86 C4
  cmp al, 0x30                                 ; 08DE5  0x3C, 0x30
  jne loc_08DED                                ; 08DE7  0x75, 0x04
  mov al, 0x20                                 ; 08DE9  0xB0, 0x20
  xchg al, ah                                  ; 08DEB  86 C4

loc_08DED:                                     ; 08DED
  ret                                          ; 08DED  0xC3
  db 0x00, 0xFF, 0xFF                          ; 08DEE  ...

sub_08DF1:                                     ; 08DF1
  push es                                      ; 08DF1  0x06
  mov di, 0x48b9                               ; 08DF2  0xBF, 0xB9, 0x48
  push di                                      ; 08DF5  0x57
  push di                                      ; 08DF6  0x57
  push ds                                      ; 08DF7  0x1E
  pop es                                       ; 08DF8  0x07
  mov cx, 0x32                                 ; 08DF9  0xB9, 0x32, 0x00
  mov al, 0x20                                 ; 08DFC  0xB0, 0x20
  rep stosb                                    ; 08DFE  0xF3, 0xAA
  lodsb                                        ; 08E00  0xAC
  db 0x8A, 0xC8                                ; 08E01  mov cl, al
  pop di                                       ; 08E03  0x5F
  rep movsb                                    ; 08E04  0xF3, 0xA4
  mov bx, [cs:0x2b58]                          ; 08E06  0x2E, 0x8B, 0x1E, 0x58, 0x2B
  call sub_09220                               ; 08E0B  0xE8, 0x12, 0x04
  call sub_09312                               ; 08E0E  0xE8, 0x01, 0x05
  db 0x2E, 0xC7, 0x06, 0xBE, 0x5F, 0xFF, 0xFF  ; 08E11  mov word [cs:0x5fbe], 0xffff
  push word [bx + 0x48]                        ; 08E18  0xFF, 0x77, 0x48
  mov ax, 0x18                                 ; 08E1B  0xB8, 0x18, 0x00
  call sub_08444                               ; 08E1E  0xE8, 0x23, 0xF6
  pop ax                                       ; 08E21  0x58
  pop cx                                       ; 08E22  0x59
  mov dx, cs                                   ; 08E23  0x8C, 0xCA
  pop es                                       ; 08E25  0x07
  push ax                                      ; 08E26  0x50
  push bx                                      ; 08E27  0x53
  call sub_08C61                               ; 08E28  0xE8, 0x36, 0xFE
  inc byte [cs:0x10b1]                         ; 08E2B  0x2E, 0xFE, 0x06, 0xB1, 0x10
  mov byte [cs:0x1047], 0xff                   ; 08E30  0x2E, 0xC6, 0x06, 0x47, 0x10, 0xFF
  mov dx, 0x13                                 ; 08E36  0xBA, 0x13, 0x00
  call rtm_timer_wait                          ; 08E39  0xE8, 0x95, 0xEA
  mov cx, 0xffff                               ; 08E3C  0xB9, 0xFF, 0xFF
  call sub_08C61                               ; 08E3F  0xE8, 0x1F, 0xFE
  pop bx                                       ; 08E42  0x5B
  pop ax                                       ; 08E43  0x58
  push es                                      ; 08E44  0x06
  call sub_08444                               ; 08E45  0xE8, 0xFC, 0xF5
  mov byte [bx + 0x35], 0                      ; 08E48  0xC6, 0x47, 0x35, 0x00
  call sub_08625                               ; 08E4C  0xE8, 0xD6, 0xF7
  pop es                                       ; 08E4F  0x07
  mov al, [cs:0x1040]                          ; 08E50  0x2E, 0xA0, 0x40, 0x10
  ret                                          ; 08E54  0xC3
xios_int28_fn_00_graphics_mode:              ; 08E55
  mov es, dx                                   ; 08E55  0x8E, 0xC2
  xchg si, cx                                  ; 08E57  87 F1
  call sub_08FDC                               ; 08E59  0xE8, 0x80, 0x01
  cmp word [cs:0x2c4b], 0                      ; 08E5C  0x2E, 0x83, 0x3E, 0x4B, 0x2C, 0x00
  je loc_08E79                                 ; 08E62  0x74, 0x15
  cmp dl, [cs:0x2c4d]                          ; 08E64  0x2E, 0x3A, 0x16, 0x4D, 0x2C
  je loc_08E79                                 ; 08E69  0x74, 0x0E
  mov si, 0x49fa                               ; 08E6B  0xBE, 0xFA, 0x49
  call sub_08DF1                               ; 08E6E  0xE8, 0x80, 0xFF
  mov cl, 0                                    ; 08E71  0xB1, 0x00
  call rtm_timer_wait2                         ; 08E73  0xE8, 0x5D, 0xEA
  mov al, 0xff                                 ; 08E76  0xB0, 0xFF
  ret                                          ; 08E78  0xC3

loc_08E79:                                     ; 08E79
  test byte [bx + 0x6b], 4                     ; 08E79  0xF6, 0x47, 0x6B, 0x04
  je loc_08E8B                                 ; 08E7D  0x74, 0x0C
  mov dx, [cs:0x2c50]                          ; 08E7F  0x2E, 0x8B, 0x16, 0x50, 0x2C
  mov [es:si + 1], dx                          ; 08E84  0x26, 0x89, 0x54, 0x01
  jmp near loc_08F5E                           ; 08E88  0xE9, 0xD3, 0x00

loc_08E8B:                                     ; 08E8B
  mov [cs:0x2c4d], dl                          ; 08E8B  0x2E, 0x88, 0x16, 0x4D, 0x2C
  mov [cs:0x2c49], si                          ; 08E90  0x2E, 0x89, 0x36, 0x49, 0x2C
  mov [cs:0x2c4b], es                          ; 08E95  0x2E, 0x8C, 0x06, 0x4B, 0x2C
  mov dx, [es:si + 1]                          ; 08E9A  0x26, 0x8B, 0x54, 0x01
  mov [cs:0x2c47], dx                          ; 08E9E  0x2E, 0x89, 0x16, 0x47, 0x2C
  mov [cs:0x1fd7], ah                          ; 08EA3  0x2E, 0x88, 0x26, 0xD7, 0x1F
  mov dx, 0x4f                                 ; 08EA8  0xBA, 0x4F, 0x00
  cmp ah, 2                                    ; 08EAB  0x80, 0xFC, 0x02
  jne loc_08EB3                                ; 08EAE  0x75, 0x03
  mov dx, 0x27                                 ; 08EB0  0xBA, 0x27, 0x00

loc_08EB3:                                     ; 08EB3
  mov [bx + 0x60], dx                          ; 08EB3  0x89, 0x57, 0x60
  inc dx                                       ; 08EB6  0x42
  mov [bx + 0x4d], dl                          ; 08EB7  0x88, 0x57, 0x4D
  call sub_0922F                               ; 08EBA  0xE8, 0x72, 0x03
  call sub_09312                               ; 08EBD  0xE8, 0x52, 0x04
  or byte [bx + 0x6b], 4                       ; 08EC0  0x80, 0x4F, 0x6B, 0x04
  mov byte [bx + 0x70], 0xc                    ; 08EC4  0xC6, 0x47, 0x70, 0x0C
  mov dx, [cs:0x2c47]                          ; 08EC8  0x2E, 0x8B, 0x16, 0x47, 0x2C
  mov [cs:0x2c50], dx                          ; 08ECD  0x2E, 0x89, 0x16, 0x50, 0x2C
  test byte [bx + 0x6b], 2                     ; 08ED2  0xF6, 0x47, 0x6B, 0x02
  jne loc_08EE0                                ; 08ED6  0x75, 0x08
  mov ah, 3                                    ; 08ED8  0xB4, 0x03
  call xios_crt_trigger_ca                     ; 08EDA  0xE8, 0x24, 0x07
  call sub_08FEE                               ; 08EDD  0xE8, 0x0E, 0x01

loc_08EE0:                                     ; 08EE0
  mov es, [cs:0x2bf1]                          ; 08EE0  0x2E, 0x8E, 0x06, 0xF1, 0x2B
  db 0x33, 0xF6                                ; 08EE5  xor si, si
  mov dx, 0                                    ; 08EE7  0xBA, 0x00, 0x00
  cmp byte [cs:0x1fd7], 1                      ; 08EEA  0x2E, 0x80, 0x3E, 0xD7, 0x1F, 0x01
  je loc_08EF5                                 ; 08EF0  0x74, 0x03
  mov dx, 0x4000                               ; 08EF2  0xBA, 0x00, 0x40

loc_08EF5:                                     ; 08EF5
  mov di, [bx + si]                            ; 08EF5  0x8B, 0x38
  db 0x8B, 0xC2                                ; 08EF7  mov ax, dx
  mov cx, 0x23                                 ; 08EF9  0xB9, 0x23, 0x00

loc_08EFC:                                     ; 08EFC
  stosw                                        ; 08EFC  0xAB
  add ax, strict word 0x10                     ; 08EFD  05 10 00
  loop loc_08EFC                               ; 08F00  0xE2, 0xFA
  mov word [es:di], 0x8200                     ; 08F02  0x26, 0xC7, 0x05, 0x00, 0x82
  inc si                                       ; 08F07  0x46
  inc si                                       ; 08F08  0x46
  inc dx                                       ; 08F09  0x42
  cmp dl, 0x10                                 ; 08F0A  0x80, 0xFA, 0x10
  jb loc_08EF5                                 ; 08F0D  0x72, 0xE6
  mov word [es:di], 0x8100                     ; 08F0F  0x26, 0xC7, 0x05, 0x00, 0x81
  mov ax, 0xccc0                               ; 08F14  0xB8, 0xC0, 0xCC
  cmp byte [cs:0x2bfb], 0xff                   ; 08F17  0x2E, 0x80, 0x3E, 0xFB, 0x2B, 0xFF
  jne loc_08F22                                ; 08F1D  0x75, 0x03
  mov ax, 0x1240                               ; 08F1F  0xB8, 0x40, 0x12

loc_08F22:                                     ; 08F22
  cmp byte [cs:0x1fd7], 2                      ; 08F22  0x2E, 0x80, 0x3E, 0xD7, 0x1F, 0x02
  je loc_08F30                                 ; 08F28  0x74, 0x06
  mov al, [bx + 0x7f]                          ; 08F2A  0x8A, 0x47, 0x7F
  ror al, 4                                    ; 08F2D  0xC0, 0xC8, 0x04

loc_08F30:                                     ; 08F30
  lea si, [bx + 0x84]                          ; 08F30  0x8D, 0xB7, 0x84, 0x00
  mov [si], al                                 ; 08F34  0x88, 0x04
  mov [si + 8], ah                             ; 08F36  0x88, 0x64, 0x08
  mov ax, [cs:0x2c50]                          ; 08F39  0x2E, 0xA1, 0x50, 0x2C
  les si, [cs:0x2c49]                          ; 08F3D  0x2E, 0xC4, 0x36, 0x49, 0x2C
  mov [es:si + 1], ax                          ; 08F42  0x26, 0x89, 0x44, 0x01
  mov es, ax                                   ; 08F46  0x8E, 0xC0
  mov cx, 0x4000                               ; 08F48  0xB9, 0x00, 0x40
  db 0x33, 0xC0                                ; 08F4B  xor ax, ax
  db 0x33, 0xFF                                ; 08F4D  xor di, di
  rep stosw                                    ; 08F4F  0xF3, 0xAB
  or word [bx + 0x6b], 0x200                   ; 08F51  0x81, 0x4F, 0x6B, 0x00, 0x02
  mov bx, [cs:0x2b58]                          ; 08F56  0x2E, 0x8B, 0x1E, 0x58, 0x2B
  call sub_08BFB                               ; 08F5B  0xE8, 0x9D, 0xFC

loc_08F5E:                                     ; 08F5E
  lea bx, [bx + 0x35]                          ; 08F5E  0x8D, 0x5F, 0x35
  mov dx, [cs:0xc06]                           ; 08F61  0x2E, 0x8B, 0x16, 0x06, 0x0C
  ret                                          ; 08F66  0xC3
xios_int28_fn_01_char_mode:                  ; 08F67
  cmp word [cs:0x2c4b], 0                      ; 08F67  0x2E, 0x83, 0x3E, 0x4B, 0x2C, 0x00
  je loc_08FDB                                 ; 08F6D  0x74, 0x6C
  call sub_08FDC                               ; 08F6F  0xE8, 0x6A, 0x00
  cmp dl, [cs:0x2c4d]                          ; 08F72  0x2E, 0x3A, 0x16, 0x4D, 0x2C
  jne loc_08FDB                                ; 08F77  0x75, 0x62
  les si, [cs:0x2c49]                          ; 08F79  0x2E, 0xC4, 0x36, 0x49, 0x2C
  db 0x2E, 0xC7, 0x06, 0x4B, 0x2C, 0x00, 0x00  ; 08F7E  mov word [cs:0x2c4b], 0
  mov ax, [cs:0x2c47]                          ; 08F85  0x2E, 0xA1, 0x47, 0x2C
  mov [es:si + 1], ax                          ; 08F89  0x26, 0x89, 0x44, 0x01
  mov byte [es:si], 0                          ; 08F8D  0x26, 0xC6, 0x04, 0x00
  test byte [bx + 0x6b], 4                     ; 08F91  0xF6, 0x47, 0x6B, 0x04
  je loc_08FDB                                 ; 08F95  0x74, 0x44
  and byte [bx + 0x6b], 0xfb                   ; 08F97  0x80, 0x67, 0x6B, 0xFB
  mov byte [bx + 0x70], 0xd                    ; 08F9B  0xC6, 0x47, 0x70, 0x0D
  call sub_09643                               ; 08F9F  0xE8, 0xA1, 0x06
  mov ax, [bx + 0x84]                          ; 08FA2  0x8B, 0x87, 0x84, 0x00
  mov [bx + 0x80], ah                          ; 08FA6  0x88, 0xA7, 0x80, 0x00
  mov byte [bx + 0x6a], 8                      ; 08FAA  0xC6, 0x47, 0x6A, 0x08
  test byte [bx + 0x6b], 2                     ; 08FAE  0xF6, 0x47, 0x6B, 0x02
  jne loc_08FBF                                ; 08FB2  0x75, 0x0B
  mov ah, 3                                    ; 08FB4  0xB4, 0x03
  call xios_crt_trigger_ca                     ; 08FB6  0xE8, 0x48, 0x06
  call sub_09001                               ; 08FB9  0xE8, 0x45, 0x00
  call sub_09079                               ; 08FBC  0xE8, 0xBA, 0x00

loc_08FBF:                                     ; 08FBF
  mov byte [bx + 0x4d], 0x50                   ; 08FBF  0xC6, 0x47, 0x4D, 0x50
  mov word [bx + 0x60], 0x4f                   ; 08FC3  0xC7, 0x47, 0x60, 0x4F, 0x00
  call sub_08206                               ; 08FC8  0xE8, 0x3B, 0xF2
  and word [bx + 0x6b], 0xfdff                 ; 08FCB  0x81, 0x67, 0x6B, 0xFF, 0xFD
  call sub_0922F                               ; 08FD0  0xE8, 0x5C, 0x02
  mov bx, [cs:0x2b58]                          ; 08FD3  0x2E, 0x8B, 0x1E, 0x58, 0x2B
  call sub_08BFB                               ; 08FD8  0xE8, 0x20, 0xFC

loc_08FDB:                                     ; 08FDB
  ret                                          ; 08FDB  0xC3

sub_08FDC:                                     ; 08FDC
  mov bx, [cs:0x68]                            ; 08FDC  0x2E, 0x8B, 0x1E, 0x68, 0x00
  mov dl, [bx + 0x20]                          ; 08FE1  0x8A, 0x57, 0x20
  jmp near sub_092F2                           ; 08FE4  0xE9, 0x0B, 0x03

sub_08FE7:                                     ; 08FE7
  cmp byte [cs:bx + 0x70], 0xd                 ; 08FE7  0x2E, 0x80, 0x7F, 0x70, 0x0D
  je sub_09001                                 ; 08FEC  0x74, 0x13

sub_08FEE:                                     ; 08FEE
  db 0x2E, 0xC7, 0x06, 0x3C, 0x61, 0x0F, 0x00  ; 08FEE  mov word [cs:0x613c], 0xf
  db 0x2E, 0xC7, 0x06, 0x3E, 0x61, 0x23, 0x87  ; 08FF5  mov word [cs:0x613e], 0x8723
  mov si, 0x5ff8                               ; 08FFC  0xBE, 0xF8, 0x5F
  jmp short loc_09012                          ; 08FFF  0xEB, 0x11

sub_09001:                                     ; 09001
  db 0x2E, 0xC7, 0x06, 0x3C, 0x61, 0x09, 0x00  ; 09001  mov word [cs:0x613c], 9
  db 0x2E, 0xC7, 0x06, 0x3E, 0x61, 0x50, 0x87  ; 09008  mov word [cs:0x613e], 0x8750
  mov si, 0x5fca                               ; 0900F  0xBE, 0xCA, 0x5F

loc_09012:                                     ; 09012
  mov ax, [cs:0x2c50]                          ; 09012  0x2E, 0xA1, 0x50, 0x2C
  mov dx, [cs:0x2c4e]                          ; 09016  0x2E, 0x8B, 0x16, 0x4E, 0x2C
  mov [cs:0x2c4e], ax                          ; 0901B  0x2E, 0xA3, 0x4E, 0x2C
  mov [cs:0x2c50], dx                          ; 0901F  0x2E, 0x89, 0x16, 0x50, 0x2C
  push ds                                      ; 09024  0x1E
  push si                                      ; 09025  0x56
  db 0x33, 0xED                                ; 09026  xor bp, bp
  mov cx, 4                                    ; 09028  0xB9, 0x04, 0x00

loc_0902B:                                     ; 0902B
  push cx                                      ; 0902B  0x51
  db 0x8B, 0xF5                                ; 0902C  mov si, bp
  db 0x33, 0xFF                                ; 0902E  xor di, di
  mov ds, ax                                   ; 09030  0x8E, 0xD8
  mov es, [cs:0x2bf1]                          ; 09032  0x2E, 0x8E, 0x06, 0xF1, 0x2B
  call sub_09073                               ; 09037  0xE8, 0x39, 0x00
  db 0x8B, 0xF5                                ; 0903A  mov si, bp
  db 0x8B, 0xFE                                ; 0903C  mov di, si
  mov ds, dx                                   ; 0903E  0x8E, 0xDA
  mov es, ax                                   ; 09040  0x8E, 0xC0
  call sub_09073                               ; 09042  0xE8, 0x2E, 0x00
  db 0x8B, 0xFD                                ; 09045  mov di, bp
  db 0x33, 0xF6                                ; 09047  xor si, si
  mov ds, [cs:0x2bf1]                          ; 09049  0x2E, 0x8E, 0x1E, 0xF1, 0x2B
  mov es, dx                                   ; 0904E  0x8E, 0xC2
  call sub_09073                               ; 09050  0xE8, 0x20, 0x00
  add bp, 0x800                                ; 09053  0x81, 0xC5, 0x00, 0x08
  pop cx                                       ; 09057  0x59
  loop loc_0902B                               ; 09058  0xE2, 0xD1
  pop si                                       ; 0905A  0x5E
  pop ds                                       ; 0905B  0x1F
  push bx                                      ; 0905C  0x53
  mov al, [bx + 0x70]                          ; 0905D  0x8A, 0x47, 0x70
  mov dx, PORT_PPI_CTRL                        ; 09060  0xBA, 0x76, 0x00
  out dx, al                                   ; 09063  0xEE
  mov di, 0x5fc2                               ; 09064  0xBF, 0xC2, 0x5F
  db 0x8B, 0xC6                                ; 09067  mov ax, si
  call sub_09621                               ; 09069  0xE8, 0xB5, 0x05
  mov ah, 4                                    ; 0906C  0xB4, 0x04
  call xios_crt_trigger_ca                     ; 0906E  0xE8, 0x90, 0x05
  pop bx                                       ; 09071  0x5B
  ret                                          ; 09072  0xC3

sub_09073:                                     ; 09073
  mov cx, 0x400                                ; 09073  0xB9, 0x00, 0x04
  rep movsw                                    ; 09076  0xF3, 0xA5
  ret                                          ; 09078  0xC3

sub_09079:                                     ; 09079
  push ds                                      ; 09079  0x1E
  push es                                      ; 0907A  0x06
  push si                                      ; 0907B  0x56
  push di                                      ; 0907C  0x57
  push cx                                      ; 0907D  0x51
  mov ax, [cs:0x2c45]                          ; 0907E  0x2E, 0xA1, 0x45, 0x2C
  mov ds, ax                                   ; 09082  0x8E, 0xD8
  mov es, ax                                   ; 09084  0x8E, 0xC0
  mov di, 0x2000                               ; 09086  0xBF, 0x00, 0x20
  mov cx, 0x3000                               ; 09089  0xB9, 0x00, 0x30
  db 0x33, 0xF6                                ; 0908C  xor si, si
  rep movsw                                    ; 0908E  0xF3, 0xA5
  pop cx                                       ; 09090  0x59
  pop di                                       ; 09091  0x5F
  pop si                                       ; 09092  0x5E
  pop es                                       ; 09093  0x07
  pop ds                                       ; 09094  0x1F
  ret                                          ; 09095  0xC3
xios_int28_fn_35_write_str:                  ; 09096
  db 0x8B, 0xEC                                ; 09096  mov bp, sp
  push ds                                      ; 09098  0x1E
  push dx                                      ; 09099  0x52
  push cx                                      ; 0909A  0x51
  push si                                      ; 0909B  0x56
  call sub_08FDC                               ; 0909C  0xE8, 0x3D, 0xFF
  test byte [bx + 0x6b], 8                     ; 0909F  0xF6, 0x47, 0x6B, 0x08
  je loc_090AA                                 ; 090A3  0x74, 0x05
  push ds                                      ; 090A5  0x1E
  pop es                                       ; 090A6  0x07
  call sub_0837A                               ; 090A7  0xE8, 0xD0, 0xF2

loc_090AA:                                     ; 090AA
  pop si                                       ; 090AA  0x5E
  pop cx                                       ; 090AB  0x59
  pop dx                                       ; 090AC  0x5A
  mov es, [cs:0x2bf1]                          ; 090AD  0x2E, 0x8E, 0x06, 0xF1, 0x2B
  mov ds, [bp + 2]                             ; 090B2  0x8E, 0x5E, 0x02
  db 0x33, 0xC0                                ; 090B5  xor ax, ax
  xchg al, dh                                  ; 090B7  86 C6
  xchg bp, ax                                  ; 090B9  0x95
  mov ah, [cs:bx + 0x6a]                       ; 090BA  0x2E, 0x8A, 0x67, 0x6A
  jmp short loc_090C3                          ; 090BE  0xEB, 0x03

loc_090C0:                                     ; 090C0
  inc bp                                       ; 090C0  0x45
  db 0x33, 0xD2                                ; 090C1  xor dx, dx

loc_090C3:                                     ; 090C3
  db 0x8B, 0xFD                                ; 090C3  mov di, bp
  shl di, 1                                    ; 090C5  0xD1, 0xE7
  mov di, [cs:bx + di]                         ; 090C7  0x2E, 0x8B, 0x39
  db 0x03, 0xFA                                ; 090CA  add di, dx
  db 0x03, 0xFA                                ; 090CC  add di, dx

loc_090CE:                                     ; 090CE
  cmp dx, 0x50                                 ; 090CE  0x83, 0xFA, 0x50
  je loc_090C0                                 ; 090D1  0x74, 0xED
  lodsb                                        ; 090D3  0xAC
  stosw                                        ; 090D4  0xAB
  inc dx                                       ; 090D5  0x42
  loop loc_090CE                               ; 090D6  0xE2, 0xF6
  pop ds                                       ; 090D8  0x1F
  jmp near sub_09334                           ; 090D9  0xE9, 0x58, 0x02
xios_int28_fn_39_update_screen:              ; 090DC
  call sub_08FDC                               ; 090DC  0xE8, 0xFD, 0xFE
  jmp near sub_09334                           ; 090DF  0xE9, 0x52, 0x02
xios_int28_fn_20_def_alt_char:               ; 090E2
  db 0x8B, 0xEC                                ; 090E2  mov bp, sp
  mov bp, [bp + 2]                             ; 090E4  0x8B, 0x6E, 0x02
  mov ch, 2                                    ; 090E7  0xB5, 0x02
  push cx                                      ; 090E9  0x51
  push dx                                      ; 090EA  0x52
  call sub_090F8                               ; 090EB  0xE8, 0x0A, 0x00
  pop cx                                       ; 090EE  0x59
  pop dx                                       ; 090EF  0x5A
  or ch, 1                                     ; 090F0  0x80, 0xCD, 0x01
xios_int28_fn_52_def_font:                   ; 090F3
  db 0x8B, 0xEC                                ; 090F3  mov bp, sp
  mov bp, [bp + 2]                             ; 090F5  0x8B, 0x6E, 0x02

sub_090F8:                                     ; 090F8
  xchg si, dx                                  ; 090F8  87 F2
  xchg di, cx                                  ; 090FA  87 F9
  call sub_09123                               ; 090FC  0xE8, 0x24, 0x00
  shl di, 5                                    ; 090FF  0xC1, 0xE7, 0x05
  call sub_09131                               ; 09102  0xE8, 0x2C, 0x00
  mov byte [bx + 0x35], 0                      ; 09105  0xC6, 0x47, 0x35, 0x00
  ret                                          ; 09109  0xC3
xios_int28_fn_51_get_font:                   ; 0910A
  db 0x8B, 0xEC                                ; 0910A  mov bp, sp
  mov bp, [bp + 2]                             ; 0910C  0x8B, 0x6E, 0x02
  shl cx, 5                                    ; 0910F  0xC1, 0xE1, 0x05
  xchg si, cx                                  ; 09112  87 F1
  xchg di, dx                                  ; 09114  87 FA
  call sub_09123                               ; 09116  0xE8, 0x0A, 0x00
  xchg dx, bp                                  ; 09119  87 D5
  call sub_09131                               ; 0911B  0xE8, 0x13, 0x00
  mov byte [bx + 0x35], 0                      ; 0911E  0xC6, 0x47, 0x35, 0x00
  ret                                          ; 09122  0xC3

sub_09123:                                     ; 09123
  call sub_08FDC                               ; 09123  0xE8, 0xB6, 0xFE
  call sub_09220                               ; 09126  0xE8, 0xF7, 0x00
  push bx                                      ; 09129  0x53
  mov dx, [cs:0x2c4e]                          ; 0912A  0x2E, 0x8B, 0x16, 0x4E, 0x2C
  pop bx                                       ; 0912F  0x5B
  ret                                          ; 09130  0xC3

sub_09131:                                     ; 09131
  mov cx, 0x10                                 ; 09131  0xB9, 0x10, 0x00
  push ds                                      ; 09134  0x1E
  mov ds, bp                                   ; 09135  0x8E, 0xDD
  mov es, dx                                   ; 09137  0x8E, 0xC2
  push si                                      ; 09139  0x56
  push di                                      ; 0913A  0x57
  rep movsw                                    ; 0913B  0xF3, 0xA5
  pop si                                       ; 0913D  0x5E
  pop di                                       ; 0913E  0x5F
  pop ds                                       ; 0913F  0x1F
  ret                                          ; 09140  0xC3
xios_int28_fn_21_get_disp_list:              ; 09141
  call sub_08FDC                               ; 09141  0xE8, 0x98, 0xFE
  mov si, 0x5fa4                               ; 09144  0xBE, 0xA4, 0x5F
  jmp near loc_091B1                           ; 09147  0xE9, 0x67, 0x00
xios_int28_fn_22_set_disp_list:              ; 0914A
  call sub_08FDC                               ; 0914A  0xE8, 0x8F, 0xFE
  mov dh, [bx + 0x64]                          ; 0914D  0x8A, 0x77, 0x64
  mov dl, [bx + 0x66]                          ; 09150  0x8A, 0x57, 0x66
  xchg bx, dx                                  ; 09153  87 DA
  ret                                          ; 09155  0xC3
xios_int28_fn_36_cursor_pos:                 ; 09156
  push bx                                      ; 09156  0x53
  call sub_08FDC                               ; 09157  0xE8, 0x82, 0xFE
  pop dx                                       ; 0915A  0x5A
  mov [bx + 0x64], dh                          ; 0915B  0x88, 0x77, 0x64
  mov [bx + 0x66], dl                          ; 0915E  0x88, 0x57, 0x66
  jmp near sub_85d3                            ; 09161  0xE9, 0x6F, 0xF4
xios_int28_fn_37_get_attr:                   ; 09164
  call sub_08FDC                               ; 09164  0xE8, 0x75, 0xFE
  mov ah, [bx + 0x6a]                          ; 09167  0x8A, 0x67, 0x6A
  ret                                          ; 0916A  0xC3
xios_int28_fn_38_set_attr:                   ; 0916B
  call sub_08FDC                               ; 0916B  0xE8, 0x6E, 0xFE
  mov [bx + 0x6a], ah                          ; 0916E  0x88, 0x67, 0x6A
  ret                                          ; 09171  0xC3
xios_int28_fn_31_palette:                    ; 09172
  xchg si, dx                                  ; 09172  87 F2
  call sub_08FDC                               ; 09174  0xE8, 0x65, 0xFE
  lea di, [bx + 0x84]                          ; 09177  0x8D, 0xBF, 0x84, 0x00
  db 0x8B, 0xEC                                ; 0917B  mov bp, sp
  mov cx, 8                                    ; 0917D  0xB9, 0x08, 0x00
  push ds                                      ; 09180  0x1E
  pop es                                       ; 09181  0x07
  mov ds, [bp + 2]                             ; 09182  0x8E, 0x5E, 0x02
  cld                                          ; 09185  0xFC
  rep movsw                                    ; 09186  0xF3, 0xA5
  push cs                                      ; 09188  0x0E
  pop ds                                       ; 09189  0x1F
  test byte [bx + 0x6b], 2                     ; 0918A  0xF6, 0x47, 0x6B, 0x02
  jne loc_091A5                                ; 0918E  0x75, 0x15
  cmp byte [cs:0x1fd7], 2                      ; 09190  0x2E, 0x80, 0x3E, 0xD7, 0x1F, 0x02
  jne loc_0919D                                ; 09196  0x75, 0x05
  mov ah, 3                                    ; 09198  0xB4, 0x03
  call xios_crt_trigger_ca                     ; 0919A  0xE8, 0x64, 0x04

loc_0919D:                                     ; 0919D
  call sub_096B8                               ; 0919D  0xE8, 0x18, 0x05
  mov ah, 1                                    ; 091A0  0xB4, 0x01
  call xios_crt_trigger_ca                     ; 091A2  0xE8, 0x5C, 0x04

loc_091A5:                                     ; 091A5
  ret                                          ; 091A5  0xC3
  mov ax, 0x2b51                               ; 091A6  0xB8, 0x51, 0x2B
  cmp dl, 1                                    ; 091A9  0x80, 0xFA, 0x01
  jae loc_091BA                                ; 091AC  0x73, 0x0C
  call sub_092F2                               ; 091AE  0xE8, 0x41, 0x01

loc_091B1:                                     ; 091B1
  db 0x8B, 0xC3                                ; 091B1  mov ax, bx
  push cs                                      ; 091B3  0x0E
  pop es                                       ; 091B4  0x07
  mov dx, [cs:0x2bf1]                          ; 091B5  0x2E, 0x8B, 0x16, 0xF1, 0x2B

loc_091BA:                                     ; 091BA
  ret                                          ; 091BA  0xC3
io_auxist:
  push ds                                      ; 091BB  0x1E
  push es                                      ; 091BC  0x06
  push cx                                      ; 091BD  0x51
  push dx                                      ; 091BE  0x52
  push cs                                      ; 091BF  0x0E
  pop ds                                       ; 091C0  0x1F
  mov si, [cs:0x68]                            ; 091C1  0x2E, 0x8B, 0x36, 0x68, 0x00
  mov es, [si + 0x10]                          ; 091C6  0x8E, 0x44, 0x10
  mov si, 0x499b                               ; 091C9  0xBE, 0x9B, 0x49
  call sub_08DF1                               ; 091CC  0xE8, 0x22, 0xFC
  mov si, [cs:0x68]                            ; 091CF  0x2E, 0x8B, 0x36, 0x68, 0x00
  mov es, [si + 0x10]                          ; 091D4  0x8E, 0x44, 0x10
  mov word [si + 6], 0                         ; 091D7  0xC7, 0x44, 0x06, 0x00, 0x00
  mov cx, 0x8f                                 ; 091DC  0xB9, 0x8F, 0x00
  call rtm_timer_wait2                         ; 091DF  0xE8, 0xF1, 0xE6
  pop dx                                       ; 091E2  0x5A
  pop cx                                       ; 091E3  0x59
  pop es                                       ; 091E4  0x07
  pop ds                                       ; 091E5  0x1F
  ret                                          ; 091E6  0xC3

loc_091E7:                                     ; 091E7
  ret                                          ; 091E7  0xC3
  ret                                          ; 091E8  0xC3
  ret                                          ; 091E9  0xC3
  jmp near loc_091E7                           ; 091EA  0xE9, 0xFA, 0xFF
  ret                                          ; 091ED  0xC3
io_setblank:
  mov ax, 0x5001                               ; 091EE  0xB8, 0x01, 0x50
  ret                                          ; 091F1  0xC3

sub_091F2:                                     ; 091F2
  mov ax, [bx + 0x4a]                          ; 091F2  0x8B, 0x47, 0x4A
  db 0x3A, 0xD0                                ; 091F5  cmp dl, al
  jb loc_0920A                                 ; 091F7  0x72, 0x11
  db 0x3A, 0xF4                                ; 091F9  cmp dh, ah
  jb loc_0920A                                 ; 091FB  0x72, 0x0D
  add al, [bx + 0x44]                          ; 091FD  0x02, 0x47, 0x44
  add ah, [bx + 0x42]                          ; 09200  0x02, 0x67, 0x42
  db 0x3A, 0xD0                                ; 09203  cmp dl, al
  jae loc_09209                                ; 09205  0x73, 0x02
  db 0x3A, 0xF4                                ; 09207  cmp dh, ah

loc_09209:                                     ; 09209
  cmc                                          ; 09209  0xF5

loc_0920A:                                     ; 0920A
  ret                                          ; 0920A  0xC3

sub_0920B:                                     ; 0920B
  or byte [bx + 0x6b], 0x10                    ; 0920B  0x80, 0x4F, 0x6B, 0x10
  cmp byte [bx + 0x42], 0x18                   ; 0920F  0x80, 0x7F, 0x42, 0x18
  jb loc_0921F                                 ; 09213  0x72, 0x0A
  cmp byte [bx + 0x44], 0x50                   ; 09215  0x80, 0x7F, 0x44, 0x50
  jne loc_0921F                                ; 09219  0x75, 0x04
  xor byte [bx + 0x6b], 0x10                   ; 0921B  0x80, 0x77, 0x6B, 0x10

loc_0921F:                                     ; 0921F
  ret                                          ; 0921F  0xC3

sub_09220:                                     ; 09220
  mov al, 0xff                                 ; 09220  0xB0, 0xFF
  xchg [bx + 0x35], al                         ; 09222  0x86, 0x47, 0x35
  test al, al                                  ; 09225  0x84, 0xC0
  je loc_0922E                                 ; 09227  0x74, 0x05
  call sub_09312                               ; 09229  0xE8, 0xE6, 0x00
  jmp short sub_09220                          ; 0922C  0xEB, 0xF2

loc_0922E:                                     ; 0922E
  ret                                          ; 0922E  0xC3

sub_0922F:                                     ; 0922F
  push bx                                      ; 0922F  0x53
  push cx                                      ; 09230  0x51
  mov bx, 0x2b5d                               ; 09231  0xBB, 0x5D, 0x2B
  mov cx, 1                                    ; 09234  0xB9, 0x01, 0x00

loc_09237:                                     ; 09237
  call sub_09220                               ; 09237  0xE8, 0xE6, 0xFF
  add bx, 0x94                                 ; 0923A  0x81, 0xC3, 0x94, 0x00
  loop loc_09237                               ; 0923E  0xE2, 0xF7
  pop cx                                       ; 09240  0x59
  pop bx                                       ; 09241  0x5B
  ret                                          ; 09242  0xC3

sub_09243:                                     ; 09243
  push bx                                      ; 09243  0x53
  push cx                                      ; 09244  0x51
  mov bx, 0x2b5d                               ; 09245  0xBB, 0x5D, 0x2B
  mov cx, 1                                    ; 09248  0xB9, 0x01, 0x00

loc_0924B:                                     ; 0924B
  mov byte [bx + 0x35], 0                      ; 0924B  0xC6, 0x47, 0x35, 0x00
  add bx, 0x94                                 ; 0924F  0x81, 0xC3, 0x94, 0x00
  loop loc_0924B                               ; 09253  0xE2, 0xF6
  pop cx                                       ; 09255  0x59
  pop bx                                       ; 09256  0x5B
  ret                                          ; 09257  0xC3

sub_09258:                                     ; 09258
  cmp byte [bx + 0x4c], 0                      ; 09258  0x80, 0x7F, 0x4C, 0x00
  je loc_09276                                 ; 0925C  0x74, 0x18
  mov ah, [bx + 0x64]                          ; 0925E  0x8A, 0x67, 0x64
  mov al, [bx + 0x4b]                          ; 09261  0x8A, 0x47, 0x4B
  db 0x3A, 0xC4                                ; 09264  cmp al, ah
  ja loc_09273                                 ; 09266  0x77, 0x0B
  sub ah, [bx + 0x42]                          ; 09268  0x2A, 0x67, 0x42
  js loc_09276                                 ; 0926B  0x78, 0x09
  db 0x3A, 0xC4                                ; 0926D  cmp al, ah
  ja loc_09276                                 ; 0926F  0x77, 0x05
  inc ah                                       ; 09271  0xFE, 0xC4

loc_09273:                                     ; 09273
  mov [bx + 0x4b], ah                          ; 09273  0x88, 0x67, 0x4B

loc_09276:                                     ; 09276
  mov dx, [bx + 0x36]                          ; 09276  0x8B, 0x57, 0x36
  call sub_092FE                               ; 09279  0xE8, 0x82, 0x00
  xchg dx, ax                                  ; 0927C  0x92
  mov al, 0x50                                 ; 0927D  0xB0, 0x50
  db 0xF6, 0x67, 0x4B                          ; 0927F  mul byte [bx + 0x4b]
  db 0x2B, 0xD0                                ; 09282  sub dx, ax
  mov al, [bx + 0x4a]                          ; 09284  0x8A, 0x47, 0x4A
  db 0x98                                      ; 09287  cwde
  db 0x2B, 0xD0                                ; 09288  sub dx, ax
  mov [bx + 0x46], dx                          ; 0928A  0x89, 0x57, 0x46
  ret                                          ; 0928D  0xC3

sub_0928E:                                     ; 0928E
  mov di, 0x2b53                               ; 0928E  0xBF, 0x53, 0x2B
  mov cx, 1                                    ; 09291  0xB9, 0x01, 0x00
  db 0x8A, 0xC2                                ; 09294  mov al, dl
  repne scasb                                  ; 09296  0xF2, 0xAE
  jcxz sub_092A5                               ; 09298  0xE3, 0x0B
  dec di                                       ; 0929A  0x4F

loc_0929B:                                     ; 0929B
  mov al, [di + 1]                             ; 0929B  0x8A, 0x45, 0x01
  mov [di], al                                 ; 0929E  0x88, 0x05
  inc di                                       ; 092A0  0x47
  loop loc_0929B                               ; 092A1  0xE2, 0xF8
  mov [di], dl                                 ; 092A3  0x88, 0x15

sub_092A5:                                     ; 092A5
  mov di, 0x2b5b                               ; 092A5  0xBF, 0x5B, 0x2B
  mov al, [bx + 0x4e]                          ; 092A8  0x8A, 0x47, 0x4E
  mov ah, 0                                    ; 092AB  0xB4, 0x00
  mov cx, 2                                    ; 092AD  0xB9, 0x02, 0x00

loc_092B0:                                     ; 092B0
  test al, ah                                  ; 092B0  0x84, 0xE0
  je loc_092B6                                 ; 092B2  0x74, 0x02
  mov [di], dl                                 ; 092B4  0x88, 0x15

loc_092B6:                                     ; 092B6
  inc ah                                       ; 092B6  0xFE, 0xC4
  inc di                                       ; 092B8  0x47
  loop loc_092B0                               ; 092B9  0xE2, 0xF5
  ret                                          ; 092BB  0xC3
  mov al, [bx + 0x39]                          ; 092BC  0x8A, 0x47, 0x39
  sub al, [bx + 0x37]                          ; 092BF  0x2A, 0x47, 0x37
  db 0x98                                      ; 092C2  cwde
  inc ax                                       ; 092C3  0x40
  mov [bx + 0x42], ax                          ; 092C4  0x89, 0x47, 0x42
  mov al, [bx + 0x38]                          ; 092C7  0x8A, 0x47, 0x38
  sub al, [bx + 0x36]                          ; 092CA  0x2A, 0x47, 0x36
  db 0x98                                      ; 092CD  cwde
  inc ax                                       ; 092CE  0x40
  mov [bx + 0x44], ax                          ; 092CF  0x89, 0x47, 0x44
  ret                                          ; 092D2  0xC3
  mov dx, [bx + 0x40]                          ; 092D3  0x8B, 0x57, 0x40
  mov al, [bx + 0x48]                          ; 092D6  0x8A, 0x47, 0x48
  sub al, [bx + 0x42]                          ; 092D9  0x2A, 0x47, 0x42
  db 0x3A, 0xC6                                ; 092DC  cmp al, dh
  jae loc_092E2                                ; 092DE  0x73, 0x02
  db 0x8A, 0xF0                                ; 092E0  mov dh, al

loc_092E2:                                     ; 092E2
  mov al, 0x50                                 ; 092E2  0xB0, 0x50
  sub al, [bx + 0x44]                          ; 092E4  0x2A, 0x47, 0x44
  db 0x3A, 0xC2                                ; 092E7  cmp al, dl
  jae loc_092ED                                ; 092E9  0x73, 0x02
  db 0x8A, 0xD0                                ; 092EB  mov dl, al

loc_092ED:                                     ; 092ED
  mov [bx + 0x4a], dx                          ; 092ED  0x89, 0x57, 0x4A
  ret                                          ; 092F0  0xC3
  ret                                          ; 092F1  0xC3

sub_092F2:                                     ; 092F2
  db 0x8A, 0xDA                                ; 092F2  mov bl, dl
  db 0x32, 0xFF                                ; 092F4  xor bh, bh
  shl bx, 1                                    ; 092F6  0xD1, 0xE3
  mov bx, [cs:bx + 0x2bf3]                     ; 092F8  0x2E, 0x8B, 0x9F, 0xF3, 0x2B
  ret                                          ; 092FD  0xC3

sub_092FE:                                     ; 092FE
  mov al, 0xb0                                 ; 092FE  0xB0, 0xB0
  db 0xF6, 0xE6                                ; 09300  mul dh
  neg ax                                       ; 09302  0xF7, 0xD8
  db 0x03, 0xC2                                ; 09304  add ax, dx
  db 0x8B, 0xF8                                ; 09306  mov di, ax
  db 0x03, 0xFF                                ; 09308  add di, di
  ret                                          ; 0930A  0xC3

sub_0930B:                                     ; 0930B
  push bx                                      ; 0930B  0x53
  mov bx, 0x2b5b                               ; 0930C  0xBB, 0x5B, 0x2B
  xlatb                                        ; 0930F  0xD7
  pop bx                                       ; 09310  0x5B
  ret                                          ; 09311  0xC3

sub_09312:                                     ; 09312
  push bx                                      ; 09312  0x53
  push cx                                      ; 09313  0x51
  push dx                                      ; 09314  0x52
  push si                                      ; 09315  0x56
  push di                                      ; 09316  0x57
  push es                                      ; 09317  0x06
  mov cl, 0x8d                                 ; 09318  0xB1, 0x8D
  mov dx, 1                                    ; 0931A  0xBA, 0x01, 0x00
  mov bx, [cs:0x68]                            ; 0931D  0x2E, 0x8B, 0x1E, 0x68, 0x00
  mov es, [bx + 0x10]                          ; 09322  0x8E, 0x47, 0x10
  call rtm_timer_wait2                         ; 09325  0xE8, 0xAB, 0xE5
  pop es                                       ; 09328  0x07
  pop di                                       ; 09329  0x5F
  pop si                                       ; 0932A  0x5E
  pop dx                                       ; 0932B  0x5A
  pop cx                                       ; 0932C  0x59
  pop bx                                       ; 0932D  0x5B
  ret                                          ; 0932E  0xC3
  ret                                          ; 0932F  0xC3
  db 0x00, 0x00, 0x00                          ; 09330  ...

sub_09333:                                     ; 09333
  ret                                          ; 09333  0xC3

sub_09334:                                     ; 09334
  test byte [cs:0x2b5a], 0xff                  ; 09334  0x2E, 0xF6, 0x06, 0x5A, 0x2B, 0xFF
  jne loc_093A2                                ; 0933A  0x75, 0x66
  call sub_09258                               ; 0933C  0xE8, 0x19, 0xFF
  shl dx, 1                                    ; 0933F  0xD1, 0xE2
  mov si, [bx + 0x58]                          ; 09341  0x8B, 0x77, 0x58
  push ds                                      ; 09344  0x1E
  push es                                      ; 09345  0x06
  mov ax, [cs:0x2bf1]                          ; 09346  0x2E, 0xA1, 0xF1, 0x2B
  mov ds, ax                                   ; 0934A  0x8E, 0xD8
  mov es, ax                                   ; 0934C  0x8E, 0xC0

loc_0934E:                                     ; 0934E
  db 0x2E, 0xAC                                ; 0934E  lodsb
  db 0x98                                      ; 09350  cwde
  xchg cx, ax                                  ; 09351  0x91
  jcxz loc_093A0                               ; 09352  0xE3, 0x4C
  db 0x2E, 0xAD                                ; 09354  lodsw
  xchg dx, ax                                  ; 09356  0x92
  call sub_092FE                               ; 09357  0xE8, 0xA4, 0xFF
  sub dx, [cs:bx + 0x36]                       ; 0935A  0x2E, 0x2B, 0x57, 0x36
  add dx, [cs:bx + 0x4a]                       ; 0935E  0x2E, 0x03, 0x57, 0x4A
  db 0x8A, 0xC6                                ; 09362  mov al, dh
  db 0x98                                      ; 09364  cwde
  shl ax, 1                                    ; 09365  0xD1, 0xE0
  push si                                      ; 09367  0x56
  xchg si, ax                                  ; 09368  0x96
  mov si, [cs:bx + si]                         ; 09369  0x2E, 0x8B, 0x30
  db 0x32, 0xF6                                ; 0936C  xor dh, dh
  shl dx, 1                                    ; 0936E  0xD1, 0xE2
  db 0x03, 0xF2                                ; 09370  add si, dx
  test byte [cs:bx + 0x6b], 4                  ; 09372  0x2E, 0xF6, 0x47, 0x6B, 0x04
  je loc_09380                                 ; 09377  0x74, 0x07
  mov ax, 0x820                                ; 09379  0xB8, 0x20, 0x08
  rep stosw                                    ; 0937C  0xF3, 0xAB
  jmp short loc_0939D                          ; 0937E  0xEB, 0x1D

loc_09380:                                     ; 09380
  test byte [cs:bx + 0x6b], 2                  ; 09380  0x2E, 0xF6, 0x47, 0x6B, 0x02
  je loc_0939B                                 ; 09385  0x74, 0x14
  cmp byte [cs:0x2bfb], 0xff                   ; 09387  0x2E, 0x80, 0x3E, 0xFB, 0x2B, 0xFF
  jne loc_0939B                                ; 0938D  0x75, 0x0C

loc_0938F:                                     ; 0938F
  lodsw                                        ; 0938F  0xAD
  and ah, 0x87                                 ; 09390  0x80, 0xE4, 0x87
  or ah, 8                                     ; 09393  0x80, 0xCC, 0x08
  stosw                                        ; 09396  0xAB
  loop loc_0938F                               ; 09397  0xE2, 0xF6
  jmp short loc_0939D                          ; 09399  0xEB, 0x02

loc_0939B:                                     ; 0939B
  rep movsw                                    ; 0939B  0xF3, 0xA5

loc_0939D:                                     ; 0939D
  pop si                                       ; 0939D  0x5E
  jmp short loc_0934E                          ; 0939E  0xEB, 0xAE

loc_093A0:                                     ; 093A0
  pop es                                       ; 093A0  0x07
  pop ds                                       ; 093A1  0x1F

loc_093A2:                                     ; 093A2
  ret                                          ; 093A2  0xC3
  mov word [bx + 0x5a], 0xffff                 ; 093A3  0xC7, 0x47, 0x5A, 0xFF, 0xFF
  mov dx, [bx + 0x36]                          ; 093A8  0x8B, 0x57, 0x36
  mov cx, [bx + 0x44]                          ; 093AB  0x8B, 0x4F, 0x44
  dec dh                                       ; 093AE  0xFE, 0xCE
  js loc_093BE                                 ; 093B0  0x78, 0x0C
  mov byte [cs:0x28ce], 0xac                   ; 093B2  0x2E, 0xC6, 0x06, 0xCE, 0x28, 0xAC
  mov ax, 0xccbc                               ; 093B8  0xB8, 0xBC, 0xCC
  call sub_093F6                               ; 093BB  0xE8, 0x38, 0x00

loc_093BE:                                     ; 093BE
  mov dh, [bx + 0x39]                          ; 093BE  0x8A, 0x77, 0x39
  inc dh                                       ; 093C1  0xFE, 0xC6
  cmp dh, [bx + 0x48]                          ; 093C3  0x3A, 0x77, 0x48
  je loc_093D4                                 ; 093C6  0x74, 0x0C
  mov byte [cs:0x28ce], 0xd0                   ; 093C8  0x2E, 0xC6, 0x06, 0xCE, 0x28, 0xD0
  mov ax, 0xdad5                               ; 093CE  0xB8, 0xD5, 0xDA
  call sub_093F6                               ; 093D1  0xE8, 0x22, 0x00

loc_093D4:                                     ; 093D4
  mov dx, [bx + 0x36]                          ; 093D4  0x8B, 0x57, 0x36
  mov cx, [bx + 0x42]                          ; 093D7  0x8B, 0x4F, 0x42
  dec dl                                       ; 093DA  0xFE, 0xCA
  js loc_093E3                                 ; 093DC  0x78, 0x05
  mov al, 0xb5                                 ; 093DE  0xB0, 0xB5
  call sub_09457                               ; 093E0  0xE8, 0x74, 0x00

loc_093E3:                                     ; 093E3
  mov dl, [bx + 0x38]                          ; 093E3  0x8A, 0x57, 0x38
  inc dl                                       ; 093E6  0xFE, 0xC2
  cmp dl, 0x50                                 ; 093E8  0x80, 0xFA, 0x50
  je loc_093F2                                 ; 093EB  0x74, 0x05
  mov al, 0xca                                 ; 093ED  0xB0, 0xCA
  call sub_09457                               ; 093EF  0xE8, 0x65, 0x00

loc_093F2:                                     ; 093F2
  call sub_09473                               ; 093F2  0xE8, 0x7E, 0x00
  ret                                          ; 093F5  0xC3

sub_093F6:                                     ; 093F6
  push dx                                      ; 093F6  0x52
  push cx                                      ; 093F7  0x51
  push ax                                      ; 093F8  0x50
  call sub_092FE                               ; 093F9  0xE8, 0x02, 0xFF
  xchg si, ax                                  ; 093FC  0x96
  pop ax                                       ; 093FD  0x58
  push ax                                      ; 093FE  0x50
  mov ah, 8                                    ; 093FF  0xB4, 0x08
  cmp dl, 0                                    ; 09401  0x80, 0xFA, 0x00
  je loc_0940C                                 ; 09404  0x74, 0x06
  dec di                                       ; 09406  0x4F
  dec di                                       ; 09407  0x4F
  dec si                                       ; 09408  0x4E
  call sub_0946F                               ; 09409  0xE8, 0x63, 0x00

loc_0940C:                                     ; 0940C
  db 0x02, 0xD1                                ; 0940C  add dl, cl
  dec dl                                       ; 0940E  0xFE, 0xCA
  cmp byte [cs:0x28ce], 0xac                   ; 09410  0x2E, 0x80, 0x3E, 0xCE, 0x28, 0xAC
  jne loc_09440                                ; 09416  0x75, 0x28
  push ax                                      ; 09418  0x50
  push cx                                      ; 09419  0x51
  mov ah, 8                                    ; 0941A  0xB4, 0x08
  mov al, 0x20                                 ; 0941C  0xB0, 0x20
  call sub_0946F                               ; 0941E  0xE8, 0x4E, 0x00
  mov al, [bx + 0x34]                          ; 09421  0x8A, 0x47, 0x34
  add al, 0x30                                 ; 09424  0x04, 0x30
  call sub_0946F                               ; 09426  0xE8, 0x46, 0x00
  mov al, 0x3a                                 ; 09429  0xB0, 0x3A
  call sub_0946F                               ; 0942B  0xE8, 0x41, 0x00
  mov [bx + 0x5a], si                          ; 0942E  0x89, 0x77, 0x5A
  call sub_09473                               ; 09431  0xE8, 0x3F, 0x00
  mov al, 0x20                                 ; 09434  0xB0, 0x20
  call sub_0946F                               ; 09436  0xE8, 0x36, 0x00
  pop cx                                       ; 09439  0x59
  pop ax                                       ; 0943A  0x58
  sub cx, 0xc                                  ; 0943B  0x83, 0xE9, 0x0C
  jbe loc_09449                                ; 0943E  0x76, 0x09

loc_09440:                                     ; 09440
  mov al, [cs:0x28ce]                          ; 09440  0x2E, 0xA0, 0xCE, 0x28

loc_09444:                                     ; 09444
  call sub_0946F                               ; 09444  0xE8, 0x28, 0x00
  loop loc_09444                               ; 09447  0xE2, 0xFB

loc_09449:                                     ; 09449
  pop cx                                       ; 09449  0x59
  xchg al, ch                                  ; 0944A  86 C5
  cmp dl, 0x4f                                 ; 0944C  0x80, 0xFA, 0x4F
  je loc_09454                                 ; 0944F  0x74, 0x03
  call sub_0946F                               ; 09451  0xE8, 0x1B, 0x00

loc_09454:                                     ; 09454
  pop cx                                       ; 09454  0x59
  pop dx                                       ; 09455  0x5A
  ret                                          ; 09456  0xC3

sub_09457:                                     ; 09457
  push cx                                      ; 09457  0x51
  push ax                                      ; 09458  0x50
  call sub_092FE                               ; 09459  0xE8, 0xA2, 0xFE
  xchg si, ax                                  ; 0945C  0x96
  pop ax                                       ; 0945D  0x58
  mov ah, 8                                    ; 0945E  0xB4, 0x08

loc_09460:                                     ; 09460
  call sub_0946F                               ; 09460  0xE8, 0x0C, 0x00
  add di, 0x9e                                 ; 09463  0x81, 0xC7, 0x9E, 0x00
  add si, 0x4f                                 ; 09467  0x83, 0xC6, 0x4F
  loop loc_09460                               ; 0946A  0xE2, 0xF4
  pop cx                                       ; 0946C  0x59
  ret                                          ; 0946D  0xC3
  db 0x00                                      ; 0946E  .

sub_0946F:                                     ; 0946F
  ret                                          ; 0946F  0xC3
  inc di                                       ; 09470  0x47
  inc di                                       ; 09471  0x47
  ret                                          ; 09472  0xC3

sub_09473:                                     ; 09473
  mov es, [cs:0x2bf1]                          ; 09473  0x2E, 0x8E, 0x06, 0xF1, 0x2B
  mov si, [bx + 0x5c]                          ; 09478  0x8B, 0x77, 0x5C
  mov si, [si]                                 ; 0947B  0x8B, 0x34
  test si, si                                  ; 0947D  0x85, 0xF6
  je loc_0949F                                 ; 0947F  0x74, 0x1E
  lea bp, [si + 8]                             ; 09481  0x8D, 0x6C, 0x08
  mov si, [bx + 0x5a]                          ; 09484  0x8B, 0x77, 0x5A
  cmp si, -1                                   ; 09487  0x83, 0xFE, 0xFF
  je loc_0949F                                 ; 0948A  0x74, 0x13
  db 0x8B, 0xFE                                ; 0948C  mov di, si
  db 0x03, 0xFF                                ; 0948E  add di, di
  mov cx, 8                                    ; 09490  0xB9, 0x08, 0x00
  mov ah, 8                                    ; 09493  0xB4, 0x08

loc_09495:                                     ; 09495
  xchg si, bp                                  ; 09495  87 F5
  lodsb                                        ; 09497  0xAC
  xchg si, bp                                  ; 09498  87 F5
  call sub_0946F                               ; 0949A  0xE8, 0xD2, 0xFF
  loop loc_09495                               ; 0949D  0xE2, 0xF6

loc_0949F:                                     ; 0949F
  ret                                          ; 0949F  0xC3
xios_int28_fn_30_mouse:                      ; 094A0
  cmp cl, 4                                    ; 094A0  0x80, 0xF9, 0x04
  jb loc_094A8                                 ; 094A3  0x72, 0x03
  db 0x32, 0xC0                                ; 094A5  xor al, al
  ret                                          ; 094A7  0xC3

loc_094A8:                                     ; 094A8
  db 0x8A, 0xD9                                ; 094A8  mov bl, cl
  db 0x32, 0xFF                                ; 094AA  xor bh, bh
  shl bx, 1                                    ; 094AC  0xD1, 0xE3
  jmp word [cs:bx + 0x2913]                    ; 094AE  0x2E, 0xFF, 0xA7, 0x13, 0x29
  sub [bx + di], ch                            ; 094B3  0x28, 0x29
  sub al, 0x29                                 ; 094B5  0x2C, 0x29
  sub bp, [bx + di]                            ; 094B7  0x2B, 0x29
  xor ch, [bx + di]                            ; 094B9  0x32, 0x29
  add ax, strict word 0                        ; 094BB  05 00 00
  db 0x00, 0x00                                ; 094BE
  db 0x00, 0x00                                ; 094C0
  db 0x00, 0x00                                ; 094C2
  db 0x00, 0x00                                ; 094C4
  db 0x00, 0x00                                ; 094C6
  mov al, 0xff                                 ; 094C8  0xB0, 0xFF
  ret                                          ; 094CA  0xC3
  ret                                          ; 094CB  0xC3
  mov byte [cs:0x291b], 5                      ; 094CC  0x2E, 0xC6, 0x06, 0x1B, 0x29, 0x05
  pushf                                        ; 094D2  0x9C
  cli                                          ; 094D3  0xFA
  db 0x33, 0xC0                                ; 094D4  xor ax, ax
  db 0x33, 0xDB                                ; 094D6  xor bx, bx
  db 0x33, 0xC9                                ; 094D8  xor cx, cx
  xchg [cs:0x291c], ax                         ; 094DA  0x2E, 0x87, 0x06, 0x1C, 0x29
  xchg [cs:0x291e], bx                         ; 094DF  0x2E, 0x87, 0x1E, 0x1E, 0x29
  xchg [cs:0x2920], cx                         ; 094E4  0x2E, 0x87, 0x0E, 0x20, 0x29
  popf                                         ; 094E9  0x9D
  ret                                          ; 094EA  0xC3

sub_094EB:                                     ; 094EB
  db 0x8A, 0xE0                                ; 094EB  mov ah, al
  cmp byte [cs:0x291b], 5                      ; 094ED  0x2E, 0x80, 0x3E, 0x1B, 0x29, 0x05
  jne loc_0952E                                ; 094F3  0x75, 0x39
  and ah, 0xf8                                 ; 094F5  0x80, 0xE4, 0xF8
  cmp ah, 0x80                                 ; 094F8  0x80, 0xFC, 0x80
  jne loc_0952D                                ; 094FB  0x75, 0x30
  not al                                       ; 094FD  0xF6, 0xD0
  and al, 7                                    ; 094FF  0x24, 0x07
  jne loc_0950C                                ; 09501  0x75, 0x09
  db 0x2E, 0xC7, 0x06, 0x22, 0x29, 0x02, 0x00  ; 09503  mov word [cs:0x2922], 2
  jmp short loc_09528                          ; 0950A  0xEB, 0x1C

loc_0950C:                                     ; 0950C
  cmp word [cs:0x2922], 1                      ; 0950C  0x2E, 0x83, 0x3E, 0x22, 0x29, 0x01
  je loc_0952D                                 ; 09512  0x74, 0x19
  mov ah, 0x20                                 ; 09514  0xB4, 0x20
  test al, 4                                   ; 09516  0xA8, 0x04
  jne loc_09522                                ; 09518  0x75, 0x08
  inc ah                                       ; 0951A  0xFE, 0xC4
  test al, 2                                   ; 0951C  0xA8, 0x02
  jne loc_09522                                ; 0951E  0x75, 0x02
  inc ah                                       ; 09520  0xFE, 0xC4

loc_09522:                                     ; 09522
  mov al, 1                                    ; 09522  0xB0, 0x01
  mov [cs:0x2922], ax                          ; 09524  0x2E, 0xA3, 0x22, 0x29

loc_09528:                                     ; 09528
  dec byte [cs:0x291b]                         ; 09528  0x2E, 0xFE, 0x0E, 0x1B, 0x29

loc_0952D:                                     ; 0952D
  ret                                          ; 0952D  0xC3

loc_0952E:                                     ; 0952E
  db 0x8A, 0xE0                                ; 0952E  mov ah, al
  and ah, 0xf8                                 ; 09530  0x80, 0xE4, 0xF8
  cmp ah, 0x80                                 ; 09533  0x80, 0xFC, 0x80
  je loc_0957F                                 ; 09536  0x74, 0x47
  db 0x98                                      ; 09538  cwde
  mov bl, [cs:0x291b]                          ; 09539  0x2E, 0x8A, 0x1E, 0x1B, 0x29
  dec bl                                       ; 0953E  0xFE, 0xCB
  je loc_0955D                                 ; 09540  0x74, 0x1B
  dec bl                                       ; 09542  0xFE, 0xCB
  je loc_09556                                 ; 09544  0x74, 0x10
  dec bl                                       ; 09546  0xFE, 0xCB
  je loc_09550                                 ; 09548  0x74, 0x06
  mov [cs:0x2924], ax                          ; 0954A  0x2E, 0xA3, 0x24, 0x29
  jmp short loc_09528                          ; 0954E  0xEB, 0xD8

loc_09550:                                     ; 09550
  mov [cs:0x2926], ax                          ; 09550  0x2E, 0xA3, 0x26, 0x29
  jmp short loc_09528                          ; 09554  0xEB, 0xD2

loc_09556:                                     ; 09556
  add [cs:0x2924], ax                          ; 09556  0x2E, 0x01, 0x06, 0x24, 0x29
  jmp short loc_09528                          ; 0955B  0xEB, 0xCB

loc_0955D:                                     ; 0955D
  add ax, [cs:0x2926]                          ; 0955D  0x2E, 0x03, 0x06, 0x26, 0x29
  add [cs:0x2920], ax                          ; 09562  0x2E, 0x01, 0x06, 0x20, 0x29
  mov ax, [cs:0x2924]                          ; 09567  0x2E, 0xA1, 0x24, 0x29
  add [cs:0x291e], ax                          ; 0956B  0x2E, 0x01, 0x06, 0x1E, 0x29
  mov ax, [cs:0x2922]                          ; 09570  0x2E, 0xA1, 0x22, 0x29
  mov [cs:0x291c], ax                          ; 09574  0x2E, 0xA3, 0x1C, 0x29
  mov byte [cs:0x291b], 5                      ; 09578  0x2E, 0xC6, 0x06, 0x1B, 0x29, 0x05
  ret                                          ; 0957E  0xC3

loc_0957F:                                     ; 0957F
  mov byte [cs:0x291b], 5                      ; 0957F  0x2E, 0xC6, 0x06, 0x1B, 0x29, 0x05
  jmp near sub_094EB                           ; 09585  0xE9, 0x63, 0xFF

sub_09588:                                     ; 09588
  mov bx, [cs:0x2b58]                          ; 09588  0x2E, 0x8B, 0x1E, 0x58, 0x2B
  cmp byte [bx + 0x83], 0                      ; 0958D  0x80, 0xBF, 0x83, 0x00, 0x00
  je loc_095CA                                 ; 09592  0x74, 0x36
  test byte [bx + 0x6b], 4                     ; 09594  0xF6, 0x47, 0x6B, 0x04
  jne loc_095CA                                ; 09598  0x75, 0x30
  cmp byte [cs:0x2a60], 0xff                   ; 0959A  0x2E, 0x80, 0x3E, 0x60, 0x2A, 0xFF
  je loc_095CA                                 ; 095A0  0x74, 0x28
  dec word [cs:0x2a5e]                         ; 095A2  0x2E, 0xFF, 0x0E, 0x5E, 0x2A
  jne loc_095CA                                ; 095A7  0x75, 0x21
  mov byte [cs:0x2a60], 0xff                   ; 095A9  0x2E, 0xC6, 0x06, 0x60, 0x2A, 0xFF
  call sub_08972                               ; 095AF  0xE8, 0xC0, 0xF3
  mov ax, 0x61ec                               ; 095B2  0xB8, 0xEC, 0x61
  call sub_09621                               ; 095B5  0xE8, 0x69, 0x00
  xor byte [cs:0x5fa6], 0x80                   ; 095B8  0x2E, 0x80, 0x36, 0xA6, 0x5F, 0x80
  db 0x2E, 0xC7, 0x06, 0xBE, 0x5F, 0xFF, 0xFF  ; 095BE  mov word [cs:0x5fbe], 0xffff
  mov word [bx + 0x5e], 0x1560                 ; 095C5  0xC7, 0x47, 0x5E, 0x60, 0x15

loc_095CA:                                     ; 095CA
  ret                                          ; 095CA  0xC3

sub_095CB:                                     ; 095CB
  push bx                                      ; 095CB  0x53
  mov bx, [cs:0x2b58]                          ; 095CC  0x2E, 0x8B, 0x1E, 0x58, 0x2B
  cmp byte [bx + 0x83], 0                      ; 095D1  0x80, 0xBF, 0x83, 0x00, 0x00
  jne loc_095DA                                ; 095D6  0x75, 0x02
  pop bx                                       ; 095D8  0x5B
  ret                                          ; 095D9  0xC3

loc_095DA:                                     ; 095DA
  mov bx, [cs:0x2a5c]                          ; 095DA  0x2E, 0x8B, 0x1E, 0x5C, 0x2A
  mov [cs:0x2a5e], bx                          ; 095DF  0x2E, 0x89, 0x1E, 0x5E, 0x2A
  push dx                                      ; 095E4  0x52
  xor byte [cs:0x5fa6], 0x80                   ; 095E5  0x2E, 0x80, 0x36, 0xA6, 0x5F, 0x80
  mov bx, [cs:0x2b58]                          ; 095EB  0x2E, 0x8B, 0x1E, 0x58, 0x2B
  call sub_08625                               ; 095F0  0xE8, 0x32, 0xF0
  pop dx                                       ; 095F3  0x5A
  pop bx                                       ; 095F4  0x5B
  mov byte [cs:0x2a60], 0                      ; 095F5  0x2E, 0xC6, 0x06, 0x60, 0x2A, 0x00
  ret                                          ; 095FB  0xC3
  test [bp + di], al                           ; 095FC  0x84, 0x03
  test [bp + di], al                           ; 095FE  0x84, 0x03
  db 0x00                                      ; 09600  .

xios_crt_trigger_ca:                           ; 09601
  mov al, 1                                    ; 09601  0xB0, 0x01
  mov [cs:0x5fa4], ax                          ; 09603  0x2E, 0xA3, 0xA4, 0x5F

crt_post_cmd_wait:                             ; 09607
  mov dx, PORT_CRT_CA                          ; 09607  0xBA, 0x40, 0x02
  out dx, al                                   ; 0960A  0xEE

loc_0960B:                                     ; 0960B
  cmp [cs:0x5fa4], al                          ; 0960B  0x2E, 0x38, 0x06, 0xA4, 0x5F
  je loc_0960B                                 ; 09610  0x74, 0xF9
  db 0x2E, 0xC7, 0x06, 0xA4, 0x5F, 0x00, 0x09  ; 09612  mov word [cs:0x5fa4], 0x900
  ret                                          ; 09619  0xC3
  mov dx, [cs:0x2bf1]                          ; 0961A  0x2E, 0x8B, 0x16, 0xF1, 0x2B
  jmp short sub_09623                          ; 0961F  0xEB, 0x02

sub_09621:                                     ; 09621
  mov dx, cs                                   ; 09621  0x8C, 0xCA

sub_09623:                                     ; 09623
  cld                                          ; 09623  0xFC
  call sub_09630                               ; 09624  0xE8, 0x09, 0x00
  mov dx, cs                                   ; 09627  0x8C, 0xCA
  mov es, dx                                   ; 09629  0x8E, 0xC2
  stosw                                        ; 0962B  0xAB
  db 0x8B, 0xC1                                ; 0962C  mov ax, cx
  stosw                                        ; 0962E  0xAB
  ret                                          ; 0962F  0xC3

sub_09630:                                     ; 09630
  mov cl, 4                                    ; 09630  0xB1, 0x04
  rol dx, cl                                   ; 09632  0xD3, 0xC2
  db 0x8B, 0xCA                                ; 09634  mov cx, dx
  and cx, strict word 0xf                      ; 09636  81 E1 0F 00
  and dl, 0xf0                                 ; 0963A  0x80, 0xE2, 0xF0
  db 0x03, 0xC2                                ; 0963D  add ax, dx
  adc cx, 0                                    ; 0963F  0x83, 0xD1, 0x00
  ret                                          ; 09642  0xC3

sub_09643:                                     ; 09643
  cmp byte [cs:0x2bfb], 0xff                   ; 09643  0x2E, 0x80, 0x3E, 0xFB, 0x2B, 0xFF
  je loc_09660                                 ; 09649  0x74, 0x15
  push es                                      ; 0964B  0x06
  push ds                                      ; 0964C  0x1E
  pop es                                       ; 0964D  0x07
  lea di, [bx + 0x84]                          ; 0964E  0x8D, 0xBF, 0x84, 0x00
  mov si, 0x2ad4                               ; 09652  0xBE, 0xD4, 0x2A
  mov cx, 0x10                                 ; 09655  0xB9, 0x10, 0x00
  mov [bx + 0x81], cx                          ; 09658  0x89, 0x8F, 0x81, 0x00
  rep movsb                                    ; 0965C  0xF3, 0xA4
  pop es                                       ; 0965E  0x07
  ret                                          ; 0965F  0xC3

loc_09660:                                     ; 09660
  mov al, [cs:0x2bfe]                          ; 09660  0x2E, 0xA0, 0xFE, 0x2B
  mov ah, [cs:0x2bff]                          ; 09664  0x2E, 0x8A, 0x26, 0xFF, 0x2B
  mov [bx + 0x84], ax                          ; 09669  0x89, 0x87, 0x84, 0x00
  mov word [bx + 0x81], 2                      ; 0966D  0xC7, 0x87, 0x81, 0x00, 0x02, 0x00
  ret                                          ; 09673  0xC3
  dec ax                                       ; 09674  0x48
  inc ax                                       ; 09675  0x40
  add [si], al                                 ; 09676  0x00, 0x04
  or [si], cl                                  ; 09678  0x08, 0x0C
  inc sp                                       ; 0967A  0x44
  dec sp                                       ; 0967B  0x4C
  add byte [si - 0x7378], 0xc0                 ; 0967C  0x80, 0x84, 0x88, 0x8C, 0xC0
  db 0xC4                                      ; 09681  .
  db 0xC8, 0xCC, 0x0C, 0xC0                    ; 09682  enter 0xccc, -0x40
  add [si], cl                                 ; 09686  0x00, 0x0C
  or al, 0xc                                   ; 09688  0x0C, 0x0C
  db 0xCC                                      ; 0968A  int3
  or al, 0xc0                                  ; 0968B  0x0C, 0xC0
  ror ah, 0xc                                  ; 0968D  0xC0, 0xCC, 0x0C
  rol al, 0xc0                                 ; 09690  0xC0, 0xC0, 0xC0
  db 0xCC                                      ; 09693  int3

sub_09694:                                     ; 09694
  cmp byte [cs:0x2bfb], 0xff                   ; 09694  0x2E, 0x80, 0x3E, 0xFB, 0x2B, 0xFF
  je loc_096B7                                 ; 0969A  0x74, 0x1B
  test byte [bx + 0x6b], 4                     ; 0969C  0xF6, 0x47, 0x6B, 0x04
  jne loc_096B7                                ; 096A0  0x75, 0x15
  push es                                      ; 096A2  0x06
  push di                                      ; 096A3  0x57
  push cx                                      ; 096A4  0x51
  mov di, 0x2ad4                               ; 096A5  0xBF, 0xD4, 0x2A
  push cs                                      ; 096A8  0x0E
  pop es                                       ; 096A9  0x07
  mov cx, 0x10                                 ; 096AA  0xB9, 0x10, 0x00
  repne scasb                                  ; 096AD  0xF2, 0xAE
  add di, 0xf                                  ; 096AF  0x83, 0xC7, 0x0F
  mov al, [di]                                 ; 096B2  0x8A, 0x05
  pop cx                                       ; 096B4  0x59
  pop di                                       ; 096B5  0x5F
  pop es                                       ; 096B6  0x07

loc_096B7:                                     ; 096B7
  ret                                          ; 096B7  0xC3

sub_096B8:                                     ; 096B8
  lea si, [bx + 0x84]                          ; 096B8  0x8D, 0xB7, 0x84, 0x00
  mov dx, PORT_PALETTE_BASE                    ; 096BC  0xBA, 0x80, 0x01
  mov cx, 0x10                                 ; 096BF  0xB9, 0x10, 0x00

loc_096C2:                                     ; 096C2
  lodsb                                        ; 096C2  0xAC
  call sub_09694                               ; 096C3  0xE8, 0xCE, 0xFF
  out dx, al                                   ; 096C6  0xEE
  inc dx                                       ; 096C7  0x42
  inc dx                                       ; 096C8  0x42
  out dx, al                                   ; 096C9  0xEE
  inc dx                                       ; 096CA  0x42
  inc dx                                       ; 096CB  0x42
  loop loc_096C2                               ; 096CC  0xE2, 0xF4
  ret                                          ; 096CE  0xC3

sub_096CF:                                     ; 096CF
  test byte [bx + 0x6b], 2                     ; 096CF  0xF6, 0x47, 0x6B, 0x02
  jne loc_096F0                                ; 096D3  0x75, 0x1B
  mov al, [bx + 0x75]                          ; 096D5  0x8A, 0x47, 0x75
  mov [cs:0x5ff6], al                          ; 096D8  0x2E, 0xA2, 0xF6, 0x5F
  mov al, [bx + 0x74]                          ; 096DC  0x8A, 0x47, 0x74
  mov [cs:0x5ff2], al                          ; 096DF  0x2E, 0xA2, 0xF2, 0x5F
  mov cx, [bx + 0x72]                          ; 096E3  0x8B, 0x4F, 0x72
  mov [cs:0x5fdc], cx                          ; 096E6  0x2E, 0x89, 0x0E, 0xDC, 0x5F
  mov ah, 4                                    ; 096EB  0xB4, 0x04
  call xios_crt_trigger_ca                     ; 096ED  0xE8, 0x11, 0xFF

loc_096F0:                                     ; 096F0
  ret                                          ; 096F0  0xC3
  db 0x00                                      ; 096F1  .
  add [bp + di], ax                            ; 096F2  0x01, 0x03
  add al, [bx + di]                            ; 096F4  0x02, 0x01
  db 0x00, 0x00                                ; 096F6
  pop bp                                       ; 096F8  0x5D
  db 0x2B, 0xFF                                ; 096F9  sub di, di
  db 0x00, 0x00                                ; 096FB
  db 0x00, 0x00                                ; 096FD
  db 0x00, 0x00                                ; 096FF
  db 0x00, 0x00                                ; 09701
  db 0x00, 0x00                                ; 09703
  db 0x00, 0x00                                ; 09705
  db 0x00, 0x00                                ; 09707
  db 0x00, 0x00                                ; 09709
  db 0x00, 0x00                                ; 0970B
  db 0x00, 0x00                                ; 0970D
  db 0x00, 0x00                                ; 0970F
  db 0x00, 0x00                                ; 09711
  db 0x00, 0x00                                ; 09713
  db 0x00, 0x00                                ; 09715
  db 0x00, 0x00                                ; 09717
  db 0x00, 0x00                                ; 09719
  db 0x00, 0x00                                ; 0971B
  db 0x00, 0x00                                ; 0971D
  db 0x00, 0x00                                ; 0971F
  db 0x00, 0x00                                ; 09721
  db 0x00, 0x00                                ; 09723
  db 0x00, 0x00                                ; 09725
  db 0x00, 0x00                                ; 09727
  db 0x00, 0x00                                ; 09729
  db 0x00, 0x00                                ; 0972B
  db 0x00, 0x00                                ; 0972D
  db 0x00, 0x00                                ; 0972F
  db 0x00, 0x00                                ; 09731
  db 0x00, 0x00                                ; 09733
  dec di                                       ; 09735  0x4F
  pop ss                                       ; 09736  0x17
  db 0x00, 0x00                                ; 09737
  dec di                                       ; 09739  0x4F
  pop ss                                       ; 0973A  0x17
  push ax                                      ; 0973B  0x50
  sbb [bx + si], al                            ; 0973C  0x18, 0x00
  add [bx + si], bl                            ; 0973E  0x00, 0x18
  db 0x00, 0x50, 0x00                          ; 09740  add byte [bx + si], dl
  db 0x00, 0x00                                ; 09743
  sbb [bx + si], al                            ; 09745  0x18, 0x00
  db 0x00, 0x00                                ; 09747
  add [bx + si + 1], dl                        ; 09749  0x00, 0x50, 0x01
  db 0x00, 0x00                                ; 0974C
  db 0x00, 0x00                                ; 0974E
  db 0x00, 0x00                                ; 09750
  db 0x00, 0x00                                ; 09752
  db 0x00, 0x00                                ; 09754
  add bh, bh                                   ; 09756  0x00, 0xFF
  dec word [bx + di + 0xd]                     ; 09758  0xFF, 0x49, 0x0D
  dec di                                       ; 0975B  0x4F
  adc al, 0x4f                                 ; 0975C  0x14, 0x4F
  db 0x00, 0x00                                ; 0975E
  db 0x00, 0x00                                ; 09760
  db 0x00, 0x00                                ; 09762
  db 0x00, 0x00                                ; 09764
  add [bx + si], cl                            ; 09766  0x00, 0x08
  db 0x00, 0x00                                ; 09768
  db 0x00, 0x00                                ; 0976A
  add [di], cl                                 ; 0976C  0x00, 0x0D
  add [bp + si], cx                            ; 0976E  0x01, 0x0A
  add [bx + di], al                            ; 09770  0x00, 0x01
  clc                                          ; 09772  0xF8
  db 0x8C, 0x4D, 0x00                          ; 09773  mov word [di], cs
  db 0x00, 0x00                                ; 09776
  db 0x00, 0x00                                ; 09778
  db 0x00, 0x00                                ; 0977A
  db 0x00, 0x00                                ; 0977C
  db 0x02, 0x00                                ; 0977E  add al, byte [bx + si]
  db 0x0F, 0x00, 0x00                          ; 09780  sldt word [bx + si]
  db 0x00, 0x00                                ; 09783
  db 0x00, 0x00                                ; 09785
  db 0x00, 0x00                                ; 09787
  db 0x00, 0x00                                ; 09789
  db 0x00, 0x00                                ; 0978B
  db 0x00, 0x00                                ; 0978D
  db 0x00, 0x00                                ; 0978F
  db 0x00, 0x00                                ; 09791
  pop bp                                       ; 09793  0x5D
  sub bx, [di + 0x2b]                          ; 09794  0x2B, 0x5D, 0x2B
  pop bp                                       ; 09797  0x5D
  sub bx, [di + 0x2b]                          ; 09798  0x2B, 0x5D, 0x2B
  add [bx + di], cl                            ; 0979B  0x00, 0x09
  add ax, ax                                   ; 0979D  0x01, 0xC0
  rol byte [bx + si], 0                        ; 0979F  0xC0, 0x00, 0x00
  db 0x00, 0x00                                ; 097A2
  db 0x00, 0x00                                ; 097A4
  add bh, bh                                   ; 097A6  0x00, 0xFF
  add [bx + si], ax                            ; 097A8  0x01, 0x00
  db 0x00, 0x00                                ; 097AA
  db 0x00, 0x00                                ; 097AC
  db 0x00, 0x00                                ; 097AE
  db 0x00, 0x00                                ; 097B0
  db 0x00, 0x00                                ; 097B2
  db 0x00, 0x00                                ; 097B4
  db 0x00, 0x00                                ; 097B6
  db 0x00, 0x00                                ; 097B8
  db 0x00, 0x00                                ; 097BA
  db 0x00, 0x00                                ; 097BC
  db 0x00, 0x00                                ; 097BE
  db 0x00, 0x00                                ; 097C0
  db 0x00, 0x00                                ; 097C2
  db 0x00, 0x00                                ; 097C4
  db 0x00, 0x00                                ; 097C6
  db 0x00, 0x00                                ; 097C8
  db 0x00, 0x00                                ; 097CA
  db 0x00, 0x00                                ; 097CC
  db 0x00, 0x00                                ; 097CE
  db 0x00, 0x00                                ; 097D0
  db 0x00, 0x00                                ; 097D2
  db 0x00, 0x00                                ; 097D4
  db 0x00, 0x00                                ; 097D6
  db 0x00, 0x00                                ; 097D8
  db 0x00, 0x00                                ; 097DA
  db 0x00, 0x00                                ; 097DC
  db 0x00, 0x00                                ; 097DE
  db 0x00, 0x00                                ; 097E0
  db 0x00, 0x00                                ; 097E2
  db 0x00, 0x00                                ; 097E4
  rol byte [bx + si], 1                        ; 097E6  0xD0, 0x00
  db 0x00, 0x00                                ; 097E8
  db 0x00, 0x00                                ; 097EA
  db 0x00, 0x00                                ; 097EC
  add al, dl                                   ; 097EE  0x00, 0xD0
  db 0x00, 0x00                                ; 097F0
  dec word [bx + di]                           ; 097F2  0xFF, 0x09
  xor [bp + si], si                            ; 097F4  0x31, 0x32
  xor si, [si]                                 ; 097F6  0x33, 0x34
  xor ax, 0x3736                               ; 097F8  0x35, 0x36, 0x37
  cmp [bx + di], bh                            ; 097FB  0x38, 0x39
  xor [di], ch                                 ; 097FD  0x30, 0x2D
  db 0x60                                      ; 097FF  pusha
  or [bp + di], bl                             ; 09800  0x08, 0x1B
  jno loc_0987B                                ; 09802  0x71, 0x77
  db 0x65, 0x72, 0x74                          ; 09804  jb 0x987b
  jns loc_0987E                                ; 09807  0x79, 0x75
  db 0x69, 0x6F, 0x70, 0x7B, 0x7D              ; 09809  imul bp, word [bx + 0x70], 0x7d7b
  or ax, 0x61ff                                ; 0980E  0x0D, 0xFF, 0x61
  jae loc_09877                                ; 09811  0x73, 0x64
  db 0x66, 0x67, 0x68, 0x6A, 0x6B, 0x6C, 0x3B  ; 09813  push 0x3b6c6b6a
  db 0xFF                                      ; 0981A  .
  db 0x3A, 0xFF                                ; 0981B  cmp bh, bh
  jl loc_09899                                 ; 0981D  0x7C, 0x7A
  js loc_09884                                 ; 0981F  0x78, 0x63
  jbe loc_09885                                ; 09821  0x76, 0x62
  db 0x6E                                      ; 09823  outsb
  db 0x6D                                      ; 09824  insw
  sub al, 0x2e                                 ; 09825  0x2C, 0x2E
  db 0x2F                                      ; 09827  das
  db 0xFF, 0xFF                                ; 09828  ..
  db 0x7E, 0x20                                ; 0982A  jle 0x984c
  rol word [bx + si - 0x7d7f], 0x83            ; 0982C  0xC1, 0x80, 0x81, 0x82, 0x83
  test [di - 0x787a], al                       ; 09831  0x84, 0x85, 0x86, 0x87
  mov [bx + di - 0x7476], cl                   ; 09835  0x88, 0x89, 0x8A, 0x8B
  xchg di, ax                                  ; 09839  0x97
  mov cs, [bx - 0x6b6d]                        ; 0983A  0x8E, 0x8F, 0x93, 0x94
  call word [bx + si - 0x726e]                 ; 0983E  0xFF, 0x90, 0x92, 0x8D
  xchg bp, ax                                  ; 09842  0x95
  mov [bx + si + 0x3837], ds                   ; 09843  0x8C, 0x98, 0x37, 0x38
  cmp [di], bp                                 ; 09847  0x39, 0x2D
  sub si, [si]                                 ; 09849  0x2B, 0x34
  xor ax, 0x2c36                               ; 0984B  0x35, 0x36, 0x2C
  xchg si, ax                                  ; 0984E  0x96
  xor [bp + si], si                            ; 0984F  0x31, 0x32
  xor dx, [bx + di + 0x2e30]                   ; 09851  0x33, 0x91, 0x30, 0x2E
  dec word [si]                                ; 09855  0xFF, 0x0C
  and [bp + si], sp                            ; 09857  0x21, 0x22
  and sp, [si]                                 ; 09859  0x23, 0x24
  and ax, 0x2726                               ; 0985B  0x25, 0x26, 0x27
  sub [bx + di], ch                            ; 0985E  0x28, 0x29
  pop di                                       ; 09860  0x5F
  cmp ax, 0x840                                ; 09861  0x3D, 0x40, 0x08
  sbb dx, [bx + di + 0x57]                     ; 09864  0x1B, 0x51, 0x57
  inc bp                                       ; 09867  0x45
  push dx                                      ; 09868  0x52
  push sp                                      ; 09869  0x54
  pop cx                                       ; 0986A  0x59
  push bp                                      ; 0986B  0x55
  dec cx                                       ; 0986C  0x49
  dec di                                       ; 0986D  0x4F
  push ax                                      ; 0986E  0x50
  pop bx                                       ; 0986F  0x5B
  pop bp                                       ; 09870  0x5D
  or ax, 0x41ff                                ; 09871  0x0D, 0xFF, 0x41
  push bx                                      ; 09874  0x53
  inc sp                                       ; 09875  0x44
  inc si                                       ; 09876  0x46

loc_09877:                                     ; 09877
  inc di                                       ; 09877  0x47
  dec ax                                       ; 09878  0x48
  dec dx                                       ; 09879  0x4A
  dec bx                                       ; 0987A  0x4B

loc_0987B:                                     ; 0987B
  dec sp                                       ; 0987B  0x4C
  db 0x2B, 0xFF                                ; 0987C  sub di, di

loc_0987E:                                     ; 0987E
  db 0x2A, 0xFF                                ; 0987E  sub bh, bh
  pop sp                                       ; 09880  0x5C
  pop dx                                       ; 09881  0x5A
  pop ax                                       ; 09882  0x58
  inc bx                                       ; 09883  0x43

loc_09884:                                     ; 09884
  push si                                      ; 09884  0x56

loc_09885:                                     ; 09885
  inc dx                                       ; 09885  0x42
  dec si                                       ; 09886  0x4E
  dec bp                                       ; 09887  0x4D
  cmp al, 0x3e                                 ; 09888  0x3C, 0x3E
  db 0x3F                                      ; 0988A  aas
  db 0xFF                                      ; 0988B  .
  call far [bp + 0x20]                         ; 0988C  0xFF, 0x5E, 0x20
  shr word [di - 0x5052], 0xb0                 ; 0988F  0xC1, 0xAD, 0xAE, 0xAF, 0xB0
  mov cl, 0xb2                                 ; 09894  0xB1, 0xB2
  mov bl, 0xb4                                 ; 09896  0xB3, 0xB4
  db 0xB5                                      ; 09898  .

loc_09899:                                     ; 09899
  mov dh, 0x9f                                 ; 09899  0xB6, 0x9F
  mov al, [0x9997]                             ; 0989B  0xA0, 0x97, 0x99
  db 0x9A, 0x9B, 0x9C, 0xFF, 0x90              ; 0989E  call far 0x90ff, 0x9c9b
  xchg dx, ax                                  ; 098A3  0x92
  lea dx, [di - 0x6774]                        ; 098A4  0x8D, 0x95, 0x8C, 0x98
  db 0x37                                      ; 098A8  aaa
  cmp [bx + di], bh                            ; 098A9  0x38, 0x39
  sub ax, 0x342b                               ; 098AB  0x2D, 0x2B, 0x34
  xor ax, 0x2c36                               ; 098AE  0x35, 0x36, 0x2C
  xchg si, ax                                  ; 098B1  0x96
  xor [bp + si], si                            ; 098B2  0x31, 0x32
  xor dx, [bx + di + 0x2e30]                   ; 098B4  0x33, 0x91, 0x30, 0x2E
  dec word [bx + di]                           ; 098B8  0xFF, 0x09
  db 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF  ; 098BA  ........
  call far [bx]                                ; 098C2  0xFF, 0x1F
  inc word [bx + si]                           ; 098C4  0xFF, 0x00
  jg loc_098E3                                 ; 098C6  0x7F, 0x1B
  adc [bx], dx                                 ; 098C8  0x11, 0x17
  add ax, 0x1412                               ; 098CA  0x05, 0x12, 0x14
  sbb [di], dx                                 ; 098CD  0x19, 0x15
  or [bx], cx                                  ; 098CF  0x09, 0x0F
  adc [bp + di], bl                            ; 098D1  0x10, 0x1B
  sbb ax, 0xff0d                               ; 098D3  0x1D, 0x0D, 0xFF
  add [bp + di], dx                            ; 098D6  0x01, 0x13
  add al, 6                                    ; 098D8  0x04, 0x06
  pop es                                       ; 098DA  0x07
  or [bp + si], cl                             ; 098DB  0x08, 0x0A
  or cx, [si]                                  ; 098DD  0x0B, 0x0C
  db 0xFF, 0xFF, 0xFF, 0xFF                    ; 098DF  ....

loc_098E3:                                     ; 098E3
  sbb al, 0x1a                                 ; 098E3  0x1C, 0x1A
  sbb [bp + di], al                            ; 098E5  0x18, 0x03
  push ss                                      ; 098E7  0x16
  add cl, [0xff0d]                             ; 098E8  0x02, 0x0E, 0x0D, 0xFF
  db 0xFF, 0xFF, 0xFF                          ; 098EC  ...
  call far [0xfe20]                            ; 098EF  0xFF, 0x1E, 0x20, 0xFE
  mov bh, 0xb8                                 ; 098F3  0xB7, 0xB8
  mov cx, 0xbbba                               ; 098F5  0xB9, 0xBA, 0xBB
  mov sp, 0xbebd                               ; 098F8  0xBC, 0xBD, 0xBE
  mov di, 0xa1c0                               ; 098FB  0xBF, 0xC0, 0xA1
  mov [0xfd97], al                             ; 098FE  0xA2, 0x97, 0xFD
  db 0xFF                                      ; 09901  .
  sti                                          ; 09902  0xFB
  cli                                          ; 09903  0xFA
  call word [bx + si - 0x726e]                 ; 09904  0xFF, 0x90, 0x92, 0x8D
  xchg bp, ax                                  ; 09908  0x95
  db 0x8C, 0x98, 0xFF, 0xFF                    ; 09909  mov word [bx + si - 1], ds
  db 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x96, 0xF1, 0xF2, 0xF3, 0x91, 0xF0, 0xFF  ; 0990D  ..............

io_seldsk:
sub_0991B:                                     ; 0991B
  mov ax, 0                                    ; 0991B  0xB8, 0x00, 0x00
  db 0x8A, 0xC1                                ; 0991E  mov al, cl
  mov bx, 0x3932                               ; 09920  0xBB, 0x32, 0x39
  xlatb                                        ; 09923  0xD7
  cmp al, 0                                    ; 09924  0x3C, 0x00
  je loc_09976                                 ; 09926  0x74, 0x4E
  test dl, 1                                   ; 09928  0xF6, 0xC2, 0x01
  je loc_0993B                                 ; 0992B  0x74, 0x0E
  mov dx, 0xfffe                               ; 0992D  0xBA, 0xFE, 0xFF
  stc                                          ; 09930  0xF9
  rcl dx, cl                                   ; 09931  0xD3, 0xD2
  and [cs:0x377c], dx                          ; 09933  0x2E, 0x21, 0x16, 0x7C, 0x37
  jmp near loc_09945                           ; 09938  0xE9, 0x0A, 0x00

loc_0993B:                                     ; 0993B
  mov dx, 1                                    ; 0993B  0xBA, 0x01, 0x00
  shl dx, cl                                   ; 0993E  0xD3, 0xE2
  or [cs:0x377c], dx                           ; 09940  0x2E, 0x09, 0x16, 0x7C, 0x37

loc_09945:                                     ; 09945
  and al, 0xf7                                 ; 09945  0x24, 0xF7
  db 0x8A, 0xE0                                ; 09947  mov ah, al
  and al, 0xf0                                 ; 09949  0x24, 0xF0
  db 0x8A, 0xC4                                ; 0994B  mov al, ah
  mov bx, 0x3a82                               ; 0994D  0xBB, 0x82, 0x3A
  db 0x8A, 0xE9                                ; 09950  mov ch, cl
  je loc_0995B                                 ; 09952  0x74, 0x07
  mov cl, 4                                    ; 09954  0xB1, 0x04
  shr al, cl                                   ; 09956  0xD2, 0xE8
  mov bx, 0x3aa4                               ; 09958  0xBB, 0xA4, 0x3A

loc_0995B:                                     ; 0995B
  dec al                                       ; 0995B  0xFE, 0xC8
  mov cl, 0x11                                 ; 0995D  0xB1, 0x11
  db 0xF6, 0xE1                                ; 0995F  mul cl
  db 0x03, 0xC3                                ; 09961  add ax, bx
  push ax                                      ; 09963  0x50
  db 0x8A, 0xCD                                ; 09964  mov cl, ch
  mov bx, 0x3942                               ; 09966  0xBB, 0x42, 0x39
  mov al, 0x14                                 ; 09969  0xB0, 0x14
  db 0xF6, 0xE1                                ; 0996B  mul cl
  db 0x03, 0xD8                                ; 0996D  add bx, ax
  pop ax                                       ; 0996F  0x58
  mov [bx + 8], ax                             ; 09970  0x89, 0x47, 0x08
  db 0x8B, 0xC3                                ; 09973  mov ax, bx
  ret                                          ; 09975  0xC3

loc_09976:                                     ; 09976
  db 0x8B, 0xD8                                ; 09976  mov bx, ax
  ret                                          ; 09978  0xC3
io_read:
  db 0x8B, 0xEC                                ; 09979  mov bp, sp
  mov al, 1                                    ; 0997B  0xB0, 0x01
  cmp byte [bp + 0xf], 0                       ; 0997D  0x80, 0x7E, 0x0F, 0x00
  jne loc_09984                                ; 09981  0x75, 0x01
  ret                                          ; 09983  0xC3

loc_09984:                                     ; 09984
  mov al, [bp + 0xe]                           ; 09984  0x8A, 0x46, 0x0E
  mov bx, 0x3785                               ; 09987  0xBB, 0x85, 0x37
  call sub_09CD7                               ; 0998A  0xE8, 0x4A, 0x03
  mov al, [bp + 0xe]                           ; 0998D  0x8A, 0x46, 0x0E
  db 0x8A, 0xC8                                ; 09990  mov cl, al
  mov bx, 0x3932                               ; 09992  0xBB, 0x32, 0x39
  xlatb                                        ; 09995  0xD7
  cmp al, 0                                    ; 09996  0x3C, 0x00
  jne loc_0999F                                ; 09998  0x75, 0x05
  mov al, 1                                    ; 0999A  0xB0, 0x01
  db 0x8A, 0xD8                                ; 0999C  mov bl, al
  ret                                          ; 0999E  0xC3

loc_0999F:                                     ; 0999F
  cmp al, 0xc0                                 ; 0999F  0x3C, 0xC0
  je loc_099AA                                 ; 099A1  0x74, 0x07
  cmp al, 0xd0                                 ; 099A3  0x3C, 0xD0
  je loc_099AD                                 ; 099A5  0x74, 0x06
  jmp near loc_099B0                           ; 099A7  0xE9, 0x06, 0x00

loc_099AA:                                     ; 099AA
  jmp near loc_0A159                           ; 099AA  0xE9, 0xAC, 0x07

loc_099AD:                                     ; 099AD
  jmp near loc_0A1A4                           ; 099AD  0xE9, 0xF4, 0x07

loc_099B0:                                     ; 099B0
  mov byte [cs:0x3768], 8                      ; 099B0  0x2E, 0xC6, 0x06, 0x68, 0x37, 0x08
  and [cs:0x3768], al                          ; 099B6  0x2E, 0x20, 0x06, 0x68, 0x37
  and al, 0xf7                                 ; 099BB  0x24, 0xF7
  push ax                                      ; 099BD  0x50
  mov bx, 0x3942                               ; 099BE  0xBB, 0x42, 0x39
  mov al, 0x14                                 ; 099C1  0xB0, 0x14
  db 0xF6, 0xE1                                ; 099C3  mul cl
  db 0x03, 0xC3                                ; 099C5  add ax, bx
  mov [cs:0x3773], ax                          ; 099C7  0x2E, 0xA3, 0x73, 0x37
  db 0x8B, 0xF0                                ; 099CB  mov si, ax
  mov bx, [si + 8]                             ; 099CD  0x8B, 0x5C, 0x08
  mov ax, [bx]                                 ; 099D0  0x8B, 0x07
  mov [cs:0x3775], ax                          ; 099D2  0x2E, 0xA3, 0x75, 0x37
  mov al, [bx + 0xf]                           ; 099D6  0x8A, 0x47, 0x0F
  mov [cs:0x3777], al                          ; 099D9  0x2E, 0xA2, 0x77, 0x37
  mov ax, [bp + 8]                             ; 099DD  0x8B, 0x46, 0x08
  mov bx, [bp + 6]                             ; 099E0  0x8B, 0x5E, 0x06
  call sub_0A222                               ; 099E3  0xE8, 0x3C, 0x08
  db 0x2E, 0xC7, 0x06, 0x3B, 0x37, 0x66, 0xAE  ; 099E6  mov word [cs:0x373b], 0xae66
  pop ax                                       ; 099ED  0x58
  and al, 0xf0                                 ; 099EE  0x24, 0xF0
  mov bx, 0                                    ; 099F0  0xBB, 0x00, 0x00
  mov byte [cs:0x377e], 0                      ; 099F3  0x2E, 0xC6, 0x06, 0x7E, 0x37, 0x00
  je loc_09A04                                 ; 099F9  0x74, 0x09
  mov bx, 2                                    ; 099FB  0xBB, 0x02, 0x00
  mov byte [cs:0x377e], 0xa                    ; 099FE  0x2E, 0xC6, 0x06, 0x7E, 0x37, 0x0A

loc_09A04:                                     ; 09A04
  call word [cs:bx + 0x2f59]                   ; 09A04  0x2E, 0xFF, 0x97, 0x59, 0x2F
  cmp byte [cs:0x3756], 0                      ; 09A09  0x2E, 0x80, 0x3E, 0x56, 0x37, 0x00
  je loc_09A32                                 ; 09A0F  0x74, 0x21

loc_09A11:                                     ; 09A11
  cmp byte [cs:0x377e], 0xa                    ; 09A11  0x2E, 0x80, 0x3E, 0x7E, 0x37, 0x0A
  jae loc_09A29                                ; 09A17  0x73, 0x10
  mov al, [bp + 0xe]                           ; 09A19  0x8A, 0x46, 0x0E
  mov bx, 0x3805                               ; 09A1C  0xBB, 0x05, 0x38
  call sub_09CD7                               ; 09A1F  0xE8, 0xB5, 0x02
  inc byte [cs:0x377e]                         ; 09A22  0x2E, 0xFE, 0x06, 0x7E, 0x37
  jmp short loc_09A11                          ; 09A27  0xEB, 0xE8

loc_09A29:                                     ; 09A29
  mov al, [bp + 0xe]                           ; 09A29  0x8A, 0x46, 0x0E
  mov bx, 0x37c5                               ; 09A2C  0xBB, 0xC5, 0x37
  call sub_09CD7                               ; 09A2F  0xE8, 0xA5, 0x02

loc_09A32:                                     ; 09A32
  mov al, [cs:0x3756]                          ; 09A32  0x2E, 0xA0, 0x56, 0x37
  db 0x8A, 0xD8                                ; 09A36  mov bl, al
  ret                                          ; 09A38  0xC3
io_write:
  db 0x8B, 0xEC                                ; 09A39  mov bp, sp
  mov al, 1                                    ; 09A3B  0xB0, 0x01
  cmp byte [bp + 0xf], 0                       ; 09A3D  0x80, 0x7E, 0x0F, 0x00
  jne loc_09A44                                ; 09A41  0x75, 0x01
  ret                                          ; 09A43  0xC3

loc_09A44:                                     ; 09A44
  mov al, [bp + 0xe]                           ; 09A44  0x8A, 0x46, 0x0E
  mov bx, 0x37a5                               ; 09A47  0xBB, 0xA5, 0x37
  call sub_09CD7                               ; 09A4A  0xE8, 0x8A, 0x02
  mov al, [bp + 0xe]                           ; 09A4D  0x8A, 0x46, 0x0E
  db 0x8A, 0xC8                                ; 09A50  mov cl, al
  mov bx, 0x3932                               ; 09A52  0xBB, 0x32, 0x39
  xlatb                                        ; 09A55  0xD7
  cmp al, 0                                    ; 09A56  0x3C, 0x00
  jne loc_09A5F                                ; 09A58  0x75, 0x05
  mov al, 1                                    ; 09A5A  0xB0, 0x01
  db 0x8A, 0xD8                                ; 09A5C  mov bl, al
  ret                                          ; 09A5E  0xC3

loc_09A5F:                                     ; 09A5F
  cmp al, 0xc0                                 ; 09A5F  0x3C, 0xC0
  je loc_09A6A                                 ; 09A61  0x74, 0x07
  cmp al, 0xd0                                 ; 09A63  0x3C, 0xD0
  je loc_09A6D                                 ; 09A65  0x74, 0x06
  jmp near loc_09A70                           ; 09A67  0xE9, 0x06, 0x00

loc_09A6A:                                     ; 09A6A
  jmp near loc_0A16C                           ; 09A6A  0xE9, 0xFF, 0x06

loc_09A6D:                                     ; 09A6D
  jmp near loc_0A1BB                           ; 09A6D  0xE9, 0x4B, 0x07

loc_09A70:                                     ; 09A70
  mov byte [cs:0x3768], 8                      ; 09A70  0x2E, 0xC6, 0x06, 0x68, 0x37, 0x08
  and [cs:0x3768], al                          ; 09A76  0x2E, 0x20, 0x06, 0x68, 0x37
  and al, 0xf7                                 ; 09A7B  0x24, 0xF7
  push ax                                      ; 09A7D  0x50
  mov bx, 0x3942                               ; 09A7E  0xBB, 0x42, 0x39
  mov al, 0x14                                 ; 09A81  0xB0, 0x14
  db 0xF6, 0xE1                                ; 09A83  mul cl
  db 0x03, 0xC3                                ; 09A85  add ax, bx
  mov [cs:0x3773], ax                          ; 09A87  0x2E, 0xA3, 0x73, 0x37
  db 0x8B, 0xF0                                ; 09A8B  mov si, ax
  mov bx, [si + 8]                             ; 09A8D  0x8B, 0x5C, 0x08
  mov ax, [bx]                                 ; 09A90  0x8B, 0x07
  mov [cs:0x3775], ax                          ; 09A92  0x2E, 0xA3, 0x75, 0x37
  mov al, [bx + 0xf]                           ; 09A96  0x8A, 0x47, 0x0F
  mov [cs:0x3777], al                          ; 09A99  0x2E, 0xA2, 0x77, 0x37
  mov ax, [bp + 8]                             ; 09A9D  0x8B, 0x46, 0x08
  mov bx, [bp + 6]                             ; 09AA0  0x8B, 0x5E, 0x06
  call sub_0A222                               ; 09AA3  0xE8, 0x7C, 0x07
  db 0x2E, 0xC7, 0x06, 0x3B, 0x37, 0xA6, 0x76  ; 09AA6  mov word [cs:0x373b], 0x76a6
  pop ax                                       ; 09AAD  0x58
  and al, 0xf0                                 ; 09AAE  0x24, 0xF0
  mov bx, 0                                    ; 09AB0  0xBB, 0x00, 0x00
  mov byte [cs:0x377e], 0                      ; 09AB3  0x2E, 0xC6, 0x06, 0x7E, 0x37, 0x00
  je loc_09AC4                                 ; 09AB9  0x74, 0x09
  mov bx, 2                                    ; 09ABB  0xBB, 0x02, 0x00
  mov byte [cs:0x377e], 0xa                    ; 09ABE  0x2E, 0xC6, 0x06, 0x7E, 0x37, 0x0A

loc_09AC4:                                     ; 09AC4
  call word [cs:bx + 0x2f59]                   ; 09AC4  0x2E, 0xFF, 0x97, 0x59, 0x2F
  cmp byte [cs:0x3757], 0                      ; 09AC9  0x2E, 0x80, 0x3E, 0x57, 0x37, 0x00
  je loc_09AF2                                 ; 09ACF  0x74, 0x21

loc_09AD1:                                     ; 09AD1
  cmp byte [cs:0x377e], 0xa                    ; 09AD1  0x2E, 0x80, 0x3E, 0x7E, 0x37, 0x0A
  jae loc_09AE9                                ; 09AD7  0x73, 0x10
  mov al, [bp + 0xe]                           ; 09AD9  0x8A, 0x46, 0x0E
  mov bx, 0x3825                               ; 09ADC  0xBB, 0x25, 0x38
  call sub_09CD7                               ; 09ADF  0xE8, 0xF5, 0x01
  inc byte [cs:0x377e]                         ; 09AE2  0x2E, 0xFE, 0x06, 0x7E, 0x37
  jmp short loc_09AD1                          ; 09AE7  0xEB, 0xE8

loc_09AE9:                                     ; 09AE9
  mov al, [bp + 0xe]                           ; 09AE9  0x8A, 0x46, 0x0E
  mov bx, 0x37e5                               ; 09AEC  0xBB, 0xE5, 0x37
  call sub_09CD7                               ; 09AEF  0xE8, 0xE5, 0x01

loc_09AF2:                                     ; 09AF2
  mov al, [cs:0x3757]                          ; 09AF2  0x2E, 0xA0, 0x57, 0x37
  db 0x8A, 0xD8                                ; 09AF6  mov bl, al
  ret                                          ; 09AF8  0xC3
  pop si                                       ; 09AF9  0x5E
  db 0x2F                                      ; 09AFA  das
io_flushbuf:
  db 0x32, 0xC0                                ; 09AFB  xor al, al
  ret                                          ; 09AFD  0xC3
  inc word [bp + 0xa]                          ; 09AFE  0xFF, 0x46, 0x0A
  mov byte [cs:0x3781], 1                      ; 09B01  0x2E, 0xC6, 0x06, 0x81, 0x37, 0x01
  mov ah, [bp + 0xe]                           ; 09B07  0x8A, 0x66, 0x0E
  call sub_09D1B                               ; 09B0A  0xE8, 0x0E, 0x02
  mov byte [cs:0x3767], 0                      ; 09B0D  0x2E, 0xC6, 0x06, 0x67, 0x37, 0x00

loc_09B13:                                     ; 09B13
  mov ax, [cs:0x3775]                          ; 09B13  0x2E, 0xA1, 0x75, 0x37
  sub ax, [bp + 0xa]                           ; 09B17  0x2B, 0x46, 0x0A
  inc ax                                       ; 09B1A  0x40
  mov dl, [bp + 0xf]                           ; 09B1B  0x8A, 0x56, 0x0F
  db 0x32, 0xF6                                ; 09B1E  xor dh, dh
  db 0x3B, 0xC2                                ; 09B20  cmp ax, dx
  jae loc_09B44                                ; 09B22  0x73, 0x20
  mov [cs:0x3778], ax                          ; 09B24  0x2E, 0xA3, 0x78, 0x37
  db 0x2B, 0xD0                                ; 09B28  sub dx, ax
  push dx                                      ; 09B2A  0x52
  call sub_09B59                               ; 09B2B  0xE8, 0x2B, 0x00
  pop dx                                       ; 09B2E  0x5A
  jb loc_09B4C                                 ; 09B2F  0x72, 0x1B
  mov [bp + 0xf], dl                           ; 09B31  0x88, 0x56, 0x0F
  mov word [bp + 0xa], 1                       ; 09B34  0xC7, 0x46, 0x0A, 0x01, 0x00
  inc word [bp + 0xc]                          ; 09B39  0xFF, 0x46, 0x0C
  inc byte [cs:0x3767]                         ; 09B3C  0x2E, 0xFE, 0x06, 0x67, 0x37
  jmp near loc_09B13                           ; 09B41  0xE9, 0xCF, 0xFF

loc_09B44:                                     ; 09B44
  mov [cs:0x3778], dx                          ; 09B44  0x2E, 0x89, 0x16, 0x78, 0x37
  call sub_09B59                               ; 09B49  0xE8, 0x0D, 0x00

loc_09B4C:                                     ; 09B4C
  mov ah, [bp + 0xe]                           ; 09B4C  0x8A, 0x66, 0x0E
  call sub_09DBB                               ; 09B4F  0xE8, 0x69, 0x02
  mov byte [cs:0x3781], 0                      ; 09B52  0x2E, 0xC6, 0x06, 0x81, 0x37, 0x00
  ret                                          ; 09B58  0xC3

sub_09B59:                                     ; 09B59
  call xios_fdc_test_busy                      ; 09B59  0xE8, 0x39, 0x04
  jae loc_09B62                                ; 09B5C  0x73, 0x04
  call sub_09CC9                               ; 09B5E  0xE8, 0x68, 0x01
  ret                                          ; 09B61  0xC3

loc_09B62:                                     ; 09B62
  mov ax, 1                                    ; 09B62  0xB8, 0x01, 0x00
  mov cl, [bp + 0xe]                           ; 09B65  0x8A, 0x4E, 0x0E
  shl ax, cl                                   ; 09B68  0xD3, 0xE0
  and ax, [cs:0x377c]                          ; 09B6A  0x2E, 0x23, 0x06, 0x7C, 0x37
  jne loc_09B7E                                ; 09B6F  0x75, 0x0D
  mov bl, [bp + 0xe]                           ; 09B71  0x8A, 0x5E, 0x0E
  db 0x32, 0xFF                                ; 09B74  xor bh, bh
  cmp byte [cs:bx + 0x3771], 0xff              ; 09B76  0x2E, 0x80, 0xBF, 0x71, 0x37, 0xFF
  jne loc_09B8E                                ; 09B7C  0x75, 0x10

loc_09B7E:                                     ; 09B7E
  not ax                                       ; 09B7E  0xF7, 0xD0
  and [cs:0x377c], ax                          ; 09B80  0x2E, 0x21, 0x06, 0x7C, 0x37
  call xios_fdc_restore_track0                 ; 09B85  0xE8, 0xC0, 0x02
  jae loc_09B8E                                ; 09B88  0x73, 0x04
  call sub_09CC9                               ; 09B8A  0xE8, 0x3C, 0x01
  ret                                          ; 09B8D  0xC3

loc_09B8E:                                     ; 09B8E
  cmp byte [cs:0x3767], 0                      ; 09B8E  0x2E, 0x80, 0x3E, 0x67, 0x37, 0x00
  jne loc_09BB0                                ; 09B94  0x75, 0x1A
  mov ax, [cs:0x3778]                          ; 09B96  0x2E, 0xA1, 0x78, 0x37
  mov [cs:0x377a], ax                          ; 09B9A  0x2E, 0xA3, 0x7A, 0x37
  mov dx, PORT_FDC_DATA                        ; 09B9E  0xBA, 0x86, 0x02
  mov si, 0x375b                               ; 09BA1  0xBE, 0x5B, 0x37
  call sub_0A1E2                               ; 09BA4  0xE8, 0x3B, 0x06
  call sub_09E75                               ; 09BA7  0xE8, 0xCB, 0x02
  jae loc_09BF2                                ; 09BAA  0x73, 0x46
  call sub_09CC9                               ; 09BAC  0xE8, 0x1A, 0x01
  ret                                          ; 09BAF  0xC3

loc_09BB0:                                     ; 09BB0
  mov ax, [cs:0x377a]                          ; 09BB0  0x2E, 0xA1, 0x7A, 0x37
  mov cl, [cs:0x3777]                          ; 09BB4  0x2E, 0x8A, 0x0E, 0x77, 0x37
  add cl, 7                                    ; 09BB9  0x80, 0xC1, 0x07
  shl ax, cl                                   ; 09BBC  0xD3, 0xE0
  add [cs:0x3758], ax                          ; 09BBE  0x2E, 0x01, 0x06, 0x58, 0x37
  adc byte [cs:0x375a], 0                      ; 09BC3  0x2E, 0x80, 0x16, 0x5A, 0x37, 0x00
  mov ax, [cs:0x3778]                          ; 09BC9  0x2E, 0xA1, 0x78, 0x37
  mov [cs:0x377a], ax                          ; 09BCD  0x2E, 0xA3, 0x7A, 0x37
  mov dx, PORT_FDC_DATA                        ; 09BD1  0xBA, 0x86, 0x02
  mov si, 0x375b                               ; 09BD4  0xBE, 0x5B, 0x37
  call sub_0A1E2                               ; 09BD7  0xE8, 0x08, 0x06
  and byte [cs:0x3768], 8                      ; 09BDA  0x2E, 0x80, 0x26, 0x68, 0x37, 0x08
  jne loc_09BE9                                ; 09BE0  0x75, 0x07
  test word [bp + 0xc], 1                      ; 09BE2  0xF7, 0x46, 0x0C, 0x01, 0x00
  jne loc_09BF2                                ; 09BE7  0x75, 0x09

loc_09BE9:                                     ; 09BE9
  call xios_fdc_step_in                        ; 09BE9  0xE8, 0xDE, 0x02
  jae loc_09BF2                                ; 09BEC  0x73, 0x04
  call sub_09CC9                               ; 09BEE  0xE8, 0xD8, 0x00
  ret                                          ; 09BF1  0xC3

loc_09BF2:                                     ; 09BF2
  mov byte [cs:0x3769], 1                      ; 09BF2  0x2E, 0xC6, 0x06, 0x69, 0x37, 0x01
  mov byte [cs:0x376b], 0                      ; 09BF8  0x2E, 0xC6, 0x06, 0x6B, 0x37, 0x00
  mov bx, 0xfeff                               ; 09BFE  0xBB, 0xFF, 0xFE
  mov si, 0x375b                               ; 09C01  0xBE, 0x5B, 0x37
  and [si + 0xa], bx                           ; 09C04  0x21, 0x5C, 0x0A
  cmp byte [bp + 0xf], 1                       ; 09C07  0x80, 0x7E, 0x0F, 0x01
  je loc_09C34                                 ; 09C0B  0x74, 0x27
  mov byte [cs:0x376b], 0x10                   ; 09C0D  0x2E, 0xC6, 0x06, 0x6B, 0x37, 0x10
  inc byte [cs:0x3769]                         ; 09C13  0x2E, 0xFE, 0x06, 0x69, 0x37
  not bx                                       ; 09C18  0xF7, 0xD3
  mov si, 0x375b                               ; 09C1A  0xBE, 0x5B, 0x37
  or [si + 0xa], bx                            ; 09C1D  0x09, 0x5C, 0x0A
  mov ax, [cs:0x3775]                          ; 09C20  0x2E, 0xA1, 0x75, 0x37
  sub ax, [bp + 0xa]                           ; 09C24  0x2B, 0x46, 0x0A
  inc ax                                       ; 09C27  0x40
  cmp ax, [cs:0x3778]                          ; 09C28  0x2E, 0x3B, 0x06, 0x78, 0x37
  je loc_09C34                                 ; 09C2D  0x74, 0x05
  inc byte [cs:0x3769]                         ; 09C2F  0x2E, 0xFE, 0x06, 0x69, 0x37

loc_09C34:                                     ; 09C34
  mov byte [cs:0x376a], 0                      ; 09C34  0x2E, 0xC6, 0x06, 0x6A, 0x37, 0x00
  test word [bp + 0xc], 1                      ; 09C3A  0xF7, 0x46, 0x0C, 0x01, 0x00
  je loc_09C4F                                 ; 09C3F  0x74, 0x0E
  and byte [cs:0x3768], 8                      ; 09C41  0x2E, 0x80, 0x26, 0x68, 0x37, 0x08
  jne loc_09C4F                                ; 09C47  0x75, 0x06
  mov byte [cs:0x376a], 2                      ; 09C49  0x2E, 0xC6, 0x06, 0x6A, 0x37, 0x02

loc_09C4F:                                     ; 09C4F
  mov cx, 0xa                                  ; 09C4F  0xB9, 0x0A, 0x00

loc_09C52:                                     ; 09C52
  push cx                                      ; 09C52  0x51
  cmp cx, 5                                    ; 09C53  0x83, 0xF9, 0x05
  jne loc_09C65                                ; 09C56  0x75, 0x0D
  call sub_09E25                               ; 09C58  0xE8, 0xCA, 0x01
  call sub_09E75                               ; 09C5B  0xE8, 0x17, 0x02
  jae loc_09C65                                ; 09C5E  0x73, 0x05
  pop cx                                       ; 09C60  0x59
  call sub_09CC9                               ; 09C61  0xE8, 0x65, 0x00
  ret                                          ; 09C64  0xC3

loc_09C65:                                     ; 09C65
  cli                                          ; 09C65  0xFA
  call sub_09DD0                               ; 09C66  0xE8, 0x67, 0x01
  sti                                          ; 09C69  0xFB
  db 0x32, 0xC0                                ; 09C6A  xor al, al
  call sub_0A257                               ; 09C6C  0xE8, 0xE8, 0x05
  db 0x32, 0xC0                                ; 09C6F  xor al, al
  call xios_dma_chan_ctrl                      ; 09C71  0xE8, 0x21, 0x06
  mov ah, 4                                    ; 09C74  0xB4, 0x04
  db 0x32, 0xC0                                ; 09C76  xor al, al
  call xios_dma_mask_reg                       ; 09C78  0xE8, 0x1F, 0x06
  mov si, 0x375b                               ; 09C7B  0xBE, 0x5B, 0x37
  db 0x32, 0xC0                                ; 09C7E  xor al, al
  call sub_0A23C                               ; 09C80  0xE8, 0xB9, 0x05
  db 0x2E, 0x81, 0x3E, 0x3B, 0x37, 0x66, 0xAE  ; 09C83  cmp word [cs:0x373b], 0xae66
  jne loc_09C9F                                ; 09C8A  0x75, 0x13
  call xios_fdc_cmd_read_sector                ; 09C8C  0xE8, 0x64, 0x02
  mov al, 0                                    ; 09C8F  0xB0, 0x00
  call sub_0A276                               ; 09C91  0xE8, 0xE2, 0x05
  call sub_09FA0                               ; 09C94  0xE8, 0x09, 0x03
  mov bx, 0x3805                               ; 09C97  0xBB, 0x05, 0x38
  jb loc_09CB2                                 ; 09C9A  0x72, 0x16
  jmp near loc_09CC4                           ; 09C9C  0xE9, 0x25, 0x00

loc_09C9F:                                     ; 09C9F
  call xios_fdc_read_track_reg                 ; 09C9F  0xE8, 0x6C, 0x02
  mov al, 0                                    ; 09CA2  0xB0, 0x00
  call sub_0A276                               ; 09CA4  0xE8, 0xCF, 0x05
  call sub_09FC5                               ; 09CA7  0xE8, 0x1B, 0x03
  mov bx, 0x3825                               ; 09CAA  0xBB, 0x25, 0x38
  jb loc_09CB2                                 ; 09CAD  0x72, 0x03
  jmp near loc_09CC4                           ; 09CAF  0xE9, 0x12, 0x00

loc_09CB2:                                     ; 09CB2
  mov al, [bp + 0xe]                           ; 09CB2  0x8A, 0x46, 0x0E
  call sub_09CD7                               ; 09CB5  0xE8, 0x1F, 0x00
  inc byte [cs:0x377e]                         ; 09CB8  0x2E, 0xFE, 0x06, 0x7E, 0x37
  pop cx                                       ; 09CBD  0x59
  dec cx                                       ; 09CBE  0x49
  je loc_09CC7                                 ; 09CBF  0x74, 0x06
  jmp near loc_09C52                           ; 09CC1  0xE9, 0x8E, 0xFF

loc_09CC4:                                     ; 09CC4
  pop cx                                       ; 09CC4  0x59
  clc                                          ; 09CC5  0xF8
  ret                                          ; 09CC6  0xC3

loc_09CC7:                                     ; 09CC7
  stc                                          ; 09CC7  0xF9
  ret                                          ; 09CC8  0xC3

sub_09CC9:                                     ; 09CC9
  mov byte [cs:0x3756], 1                      ; 09CC9  0x2E, 0xC6, 0x06, 0x56, 0x37, 0x01
  mov byte [cs:0x3757], 1                      ; 09CCF  0x2E, 0xC6, 0x06, 0x57, 0x37, 0x01
  stc                                          ; 09CD5  0xF9
  ret                                          ; 09CD6  0xC3

sub_09CD7:                                     ; 09CD7
  db 0x8A, 0xC8                                ; 09CD7  mov cl, al
  mov ax, 1                                    ; 09CD9  0xB8, 0x01, 0x00
  shl ax, cl                                   ; 09CDC  0xD3, 0xE0
  test [cs:0x377f], ax                         ; 09CDE  0x2E, 0x85, 0x06, 0x7F, 0x37
  je loc_09CED                                 ; 09CE3  0x74, 0x08
  shl cl, 1                                    ; 09CE5  0xD0, 0xE1
  db 0x32, 0xED                                ; 09CE7  xor ch, ch
  db 0x8B, 0xF1                                ; 09CE9  mov si, cx
  inc word [bx + si]                           ; 09CEB  0xFF, 0x00

loc_09CED:                                     ; 09CED
  ret                                          ; 09CED  0xC3

sub_09CEE:                                     ; 09CEE
  mov cl, [bp + 0xe]                           ; 09CEE  0x8A, 0x4E, 0x0E
  db 0x8A, 0xC1                                ; 09CF1  mov al, cl
  mov ax, 1                                    ; 09CF3  0xB8, 0x01, 0x00
  shl ax, cl                                   ; 09CF6  0xD3, 0xE0
  test [cs:0x377f], ax                         ; 09CF8  0x2E, 0x85, 0x06, 0x7F, 0x37
  je loc_09D1A                                 ; 09CFD  0x74, 0x1B
  shl cl, 1                                    ; 09CFF  0xD0, 0xE1
  db 0x32, 0xED                                ; 09D01  xor ch, ch
  db 0x8B, 0xF1                                ; 09D03  mov si, cx
  mov cx, 8                                    ; 09D05  0xB9, 0x08, 0x00
  mov al, 1                                    ; 09D08  0xB0, 0x01

loc_09D0A:                                     ; 09D0A
  test [cs:0x3782], al                         ; 09D0A  0x2E, 0x84, 0x06, 0x82, 0x37
  je loc_09D13                                 ; 09D0F  0x74, 0x02
  inc word [bx + si]                           ; 09D11  0xFF, 0x00

loc_09D13:                                     ; 09D13
  add si, 4                                    ; 09D13  0x83, 0xC6, 0x04
  shl al, 1                                    ; 09D16  0xD0, 0xE0
  loop loc_09D0A                               ; 09D18  0xE2, 0xF0

loc_09D1A:                                     ; 09D1A
  ret                                          ; 09D1A  0xC3

sub_09D1B:                                     ; 09D1B
  cli                                          ; 09D1B  0xFA
  push ax                                      ; 09D1C  0x50
  call sub_0CAD1                               ; 09D1D  0xE8, 0xB1, 0x2D
  pop ax                                       ; 09D20  0x58
  sti                                          ; 09D21  0xFB
  db 0x8A, 0xCC                                ; 09D22  mov cl, ah
  mov ch, 2                                    ; 09D24  0xB5, 0x02
  shl ch, cl                                   ; 09D26  0xD2, 0xE5
  and ch, [cs:0x376c]                          ; 09D28  0x2E, 0x22, 0x2E, 0x6C, 0x37
  mov al, 2                                    ; 09D2D  0xB0, 0x02
  and ah, 1                                    ; 09D2F  0x80, 0xE4, 0x01
  je loc_09D36                                 ; 09D32  0x74, 0x02
  shl al, 1                                    ; 09D34  0xD0, 0xE0

loc_09D36:                                     ; 09D36
  cli                                          ; 09D36  0xFA
  mov byte [cs:0x376d], 0                      ; 09D37  0x2E, 0xC6, 0x06, 0x6D, 0x37, 0x00
  sti                                          ; 09D3D  0xFB
  db 0x0A, 0xC4                                ; 09D3E  or al, ah
  mov ah, [cs:0x376c]                          ; 09D40  0x2E, 0x8A, 0x26, 0x6C, 0x37
  and ah, 0xfe                                 ; 09D45  0x80, 0xE4, 0xFE
  db 0x0A, 0xC4                                ; 09D48  or al, ah
  mov [cs:0x376c], al                          ; 09D4A  0x2E, 0xA2, 0x6C, 0x37

fdc_fcr_setup:                                 ; 09D4E
  mov dx, PORT_FDC_CTRL                        ; 09D4E  0xBA, 0x88, 0x02
  out dx, al                                   ; 09D51  0xEE
  cmp ch, 0                                    ; 09D52  0x80, 0xFD, 0x00
  jne loc_09D61                                ; 09D55  0x75, 0x0A
  mov dx, 0x3c                                 ; 09D57  0xBA, 0x3C, 0x00
  mov cl, 0x8d                                 ; 09D5A  0xB1, 0x8D
  pusha                                        ; 09D5C  60
  call rtm_timer_wait2                         ; 09D5D  0xE8, 0x73, 0xDB
  popa                                         ; 09D60  61

loc_09D61:                                     ; 09D61
  ret                                          ; 09D61  0xC3

; -----------------------------------------------------------------------------
; Diskettedrev Motor Timeout Nedtælling (Kaldes hvert sekund af RTC-afbrydelsen)
; Tæller inaktivitetstimeren i cs:0x376D ned. Når timeren når 0, slukkes motoren
; for Drev A/B via PORT_FDC_CTRL (0x0288), jvf. NVRAM byte 20.
; -----------------------------------------------------------------------------
fdc_motor_timeout_tick:
sub_09D62:                                     ; 09D62
  cmp byte [cs:0x376d], 0                      ; 09D62  0x2E, 0x80, 0x3E, 0x6D, 0x37, 0x00
  je loc_09DA3                                 ; 09D68  0x74, 0x39
  dec byte [cs:0x376d]                         ; 09D6A  0x2E, 0xFE, 0x0E, 0x6D, 0x37
  jne loc_09DA3                                ; 09D6F  0x75, 0x32
  push bx                                      ; 09D71  0x53
  push ax                                      ; 09D72  0x50
  mov bx, 0x4256                               ; 09D73  0xBB, 0x56, 0x42
  mov al, [bx + 0x14]                          ; 09D76  0x8A, 0x47, 0x14
  cmp al, 5                                    ; 09D79  0x3C, 0x05
  pop ax                                       ; 09D7B  0x58
  pop bx                                       ; 09D7C  0x5B
  jb loc_09D89                                 ; 09D7D  0x72, 0x0A
  mov ah, 0                                    ; 09D7F  0xB4, 0x00
  call sub_09DA4                               ; 09D81  0xE8, 0x20, 0x00
  mov ah, 1                                    ; 09D84  0xB4, 0x01
  call sub_09DA4                               ; 09D86  0xE8, 0x1B, 0x00

loc_09D89:                                     ; 09D89
  mov byte [cs:0xc0e], 0xff                    ; 09D89  0x2E, 0xC6, 0x06, 0x0E, 0x0C, 0xFF
  mov di, 0x3942                               ; 09D8F  0xBF, 0x42, 0x39
  mov byte [di + 5], 0xff                      ; 09D92  0xC6, 0x45, 0x05, 0xFF
  mov di, 0x3956                               ; 09D96  0xBF, 0x56, 0x39
  mov byte [di + 5], 0xff                      ; 09D99  0xC6, 0x45, 0x05, 0xFF
  mov byte [cs:0x5e42], 0xff                   ; 09D9D  0x2E, 0xC6, 0x06, 0x42, 0x5E, 0xFF

loc_09DA3:                                     ; 09DA3
  ret                                          ; 09DA3  0xC3

sub_09DA4:                                     ; 09DA4
  mov al, 0xfd                                 ; 09DA4  0xB0, 0xFD
  and ah, 1                                    ; 09DA6  0x80, 0xE4, 0x01
  je loc_09DAD                                 ; 09DA9  0x74, 0x02
  mov al, 0xfb                                 ; 09DAB  0xB0, 0xFB

loc_09DAD:                                     ; 09DAD
  and al, [cs:0x376c]                          ; 09DAD  0x2E, 0x22, 0x06, 0x6C, 0x37
  mov [cs:0x376c], al                          ; 09DB2  0x2E, 0xA2, 0x6C, 0x37
  mov dx, PORT_FDC_CTRL                        ; 09DB6  0xBA, 0x88, 0x02
  out dx, al                                   ; 09DB9  0xEE
  ret                                          ; 09DBA  0xC3

sub_09DBB:                                     ; 09DBB
  cli                                          ; 09DBB  0xFA
  mov bx, 0x4256                               ; 09DBC  0xBB, 0x56, 0x42
  mov al, [bx + 0x14]                          ; 09DBF  0x8A, 0x47, 0x14
  mov [cs:0x376d], al                          ; 09DC2  0x2E, 0xA2, 0x6D, 0x37
  sti                                          ; 09DC6  0xFB
  ret                                          ; 09DC7  0xC3

sub_09DC8:                                     ; 09DC8
  cmp byte [cs:0x3781], 1                      ; 09DC8  0x2E, 0x80, 0x3E, 0x81, 0x37, 0x01
  je loc_09E04                                 ; 09DCE  0x74, 0x34

sub_09DD0:                                     ; 09DD0
  test byte [cs:0x3932], 0xf                   ; 09DD0  0x2E, 0xF6, 0x06, 0x32, 0x39, 0x0F
  je loc_09DE6                                 ; 09DD6  0x74, 0x0E
  mov di, 0x3942                               ; 09DD8  0xBF, 0x42, 0x39
  mov al, [cs:0x376c]                          ; 09DDB  0x2E, 0xA0, 0x6C, 0x37
  and al, 0xfe                                 ; 09DDF  0x24, 0xFE
  mov ah, 2                                    ; 09DE1  0xB4, 0x02
  call xios_fdc_select_drive                   ; 09DE3  0xE8, 0x1F, 0x00

loc_09DE6:                                     ; 09DE6
  test byte [cs:0x3933], 0xf                   ; 09DE6  0x2E, 0xF6, 0x06, 0x33, 0x39, 0x0F
  je loc_09DFC                                 ; 09DEC  0x74, 0x0E
  mov di, 0x3956                               ; 09DEE  0xBF, 0x56, 0x39
  mov al, [cs:0x376c]                          ; 09DF1  0x2E, 0xA0, 0x6C, 0x37
  or al, 1                                     ; 09DF5  0x0C, 0x01
  mov ah, 4                                    ; 09DF7  0xB4, 0x04
  call xios_fdc_select_drive                   ; 09DF9  0xE8, 0x09, 0x00

loc_09DFC:                                     ; 09DFC
  mov al, [cs:0x376c]                          ; 09DFC  0x2E, 0xA0, 0x6C, 0x37

fdc_fcr_write:                                 ; 09E00
  mov dx, PORT_FDC_CTRL                        ; 09E00  0xBA, 0x88, 0x02
  out dx, al                                   ; 09E03  0xEE

loc_09E04:                                     ; 09E04
  ret                                          ; 09E04  0xC3

xios_fdc_select_drive:                         ; 09E05
  test ah, al                                  ; 09E05  0x84, 0xC4
  je loc_09E24                                 ; 09E07  0x74, 0x1B
  mov dx, PORT_FDC_CTRL                        ; 09E09  0xBA, 0x88, 0x02
  out dx, al                                   ; 09E0C  0xEE
  mov dx, PORT_FDC_CMD                         ; 09E0D  0xBA, 0x80, 0x02
  in al, dx                                    ; 09E10  0xEC
  test al, 0x80                                ; 09E11  0xA8, 0x80
  je loc_09E24                                 ; 09E13  0x74, 0x0F
  mov byte [cs:0xc0e], 0xff                    ; 09E15  0x2E, 0xC6, 0x06, 0x0E, 0x0C, 0xFF
  mov byte [di + 5], 0xff                      ; 09E1B  0xC6, 0x45, 0x05, 0xFF
  xor [cs:0x376c], ah                          ; 09E1F  0x2E, 0x30, 0x26, 0x6C, 0x37

loc_09E24:                                     ; 09E24
  ret                                          ; 09E24  0xC3

sub_09E25:                                     ; 09E25
  mov ah, 0xfd                                 ; 09E25  0xB4, 0xFD
  cmp byte [bp + 0xe], 0                       ; 09E27  0x80, 0x7E, 0x0E, 0x00
  je loc_09E2F                                 ; 09E2B  0x74, 0x02
  mov ah, 0xfb                                 ; 09E2D  0xB4, 0xFB

loc_09E2F:                                     ; 09E2F
  mov al, [cs:0x376c]                          ; 09E2F  0x2E, 0xA0, 0x6C, 0x37
  mov dx, PORT_FDC_CTRL                        ; 09E33  0xBA, 0x88, 0x02
  db 0x22, 0xC4                                ; 09E36  and al, ah
  out dx, al                                   ; 09E38  0xEE
  not ah                                       ; 09E39  0xF6, 0xD4
  db 0x0A, 0xC4                                ; 09E3B  or al, ah
  out dx, al                                   ; 09E3D  0xEE
  mov dx, 0x3c                                 ; 09E3E  0xBA, 0x3C, 0x00
  mov cl, 0x8d                                 ; 09E41  0xB1, 0x8D
  pusha                                        ; 09E43  60
  call rtm_timer_wait2                         ; 09E44  0xE8, 0x8C, 0xDA
  popa                                         ; 09E47  61

xios_fdc_restore_track0:                       ; 09E48
  mov dx, PORT_FDC_CMD                         ; 09E48  0xBA, 0x80, 0x02
  mov al, 0xc                                  ; 09E4B  0xB0, 0x0C
  out dx, al                                   ; 09E4D  0xEE
  call fdc_wait                                ; 09E4E  0xE8, 0xFC, 0x00
  db 0x32, 0xFF                                ; 09E51  xor bh, bh
  test byte [cs:0x3782], 4                     ; 09E53  0x2E, 0xF6, 0x06, 0x82, 0x37, 0x04
  mov bl, [bp + 0xe]                           ; 09E59  0x8A, 0x5E, 0x0E
  mov byte [cs:bx + 0x3771], 0                 ; 09E5C  0x2E, 0xC6, 0x87, 0x71, 0x37, 0x00
  jne loc_09E6A                                ; 09E62  0x75, 0x06
  mov byte [cs:bx + 0x3771], 0xff              ; 09E64  0x2E, 0xC6, 0x87, 0x71, 0x37, 0xFF

loc_09E6A:                                     ; 09E6A
  clc                                          ; 09E6A  0xF8
  test byte [cs:0x3782], 0x10                  ; 09E6B  0x2E, 0xF6, 0x06, 0x82, 0x37, 0x10
  je loc_09E74                                 ; 09E71  0x74, 0x01
  stc                                          ; 09E73  0xF9

loc_09E74:                                     ; 09E74
  ret                                          ; 09E74  0xC3

; -----------------------------------------------------------------------------
; WD2797 Søg Spor (Seek Track med op til 3 retries)
; Skriver målspor til PORT_FDC_DATA (0x286) og sender Type I SEEK-kommando (0x1C)
; til PORT_FDC_CMD (0x280) med 6 ms steprate og verifikation.
; -----------------------------------------------------------------------------
fdc_seek_track:
sub_09E75:                                     ; 09E75
  mov cx, 3                                    ; 09E75  0xB9, 0x03, 0x00

loc_09E78:                                     ; 09E78
  push cx                                      ; 09E78  0x51
  mov bl, [bp + 0xe]                           ; 09E79  0x8A, 0x5E, 0x0E
  db 0x32, 0xFF                                ; 09E7C  xor bh, bh
  mov al, [cs:bx + 0x3771]                     ; 09E7E  0x2E, 0x8A, 0x87, 0x71, 0x37
  cmp al, 0xff                                 ; 09E83  0x3C, 0xFF
  je loc_09E8B                                 ; 09E85  0x74, 0x04
  mov dx, PORT_FDC_TRACK                       ; 09E87  0xBA, 0x82, 0x02
  out dx, al                                   ; 09E8A  0xEE

loc_09E8B:                                     ; 09E8B
  mov ax, [bp + 0xc]                           ; 09E8B  0x8B, 0x46, 0x0C
  and byte [cs:0x3768], 8                      ; 09E8E  0x2E, 0x80, 0x26, 0x68, 0x37, 0x08
  jne loc_09E98                                ; 09E94  0x75, 0x02
  shr ax, 1                                    ; 09E96  0xD1, 0xE8

loc_09E98:                                     ; 09E98
  mov dx, PORT_FDC_DATA                        ; 09E98  0xBA, 0x86, 0x02
  out dx, al                                   ; 09E9B  0xEE
  push ax                                      ; 09E9C  0x50
  mov al, 0x1c                                 ; 09E9D  0xB0, 0x1C
  mov dx, PORT_FDC_CMD                         ; 09E9F  0xBA, 0x80, 0x02
  out dx, al                                   ; 09EA2  0xEE
  call fdc_wait                                ; 09EA3  0xE8, 0xA7, 0x00
  db 0x32, 0xFF                                ; 09EA6  xor bh, bh
  pop ax                                       ; 09EA8  0x58
  mov bl, [bp + 0xe]                           ; 09EA9  0x8A, 0x5E, 0x0E
  mov [cs:bx + 0x3771], al                     ; 09EAC  0x2E, 0x88, 0x87, 0x71, 0x37
  test byte [cs:0x3782], 0x99                  ; 09EB1  0x2E, 0xF6, 0x06, 0x82, 0x37, 0x99
  clc                                          ; 09EB7  0xF8
  pop cx                                       ; 09EB8  0x59
  je loc_09EC9                                 ; 09EB9  0x74, 0x0E
  mov byte [cs:bx + 0x3771], 0xff              ; 09EBB  0x2E, 0xC6, 0x87, 0x71, 0x37, 0xFF
  push cx                                      ; 09EC1  0x51
  call sub_09E25                               ; 09EC2  0xE8, 0x60, 0xFF
  pop cx                                       ; 09EC5  0x59
  loop loc_09E78                               ; 09EC6  0xE2, 0xB0
  stc                                          ; 09EC8  0xF9

loc_09EC9:                                     ; 09EC9
  ret                                          ; 09EC9  0xC3

xios_fdc_step_in:                              ; 09ECA
  mov al, 0x5c                                 ; 09ECA  0xB0, 0x5C
  mov dx, PORT_FDC_CMD                         ; 09ECC  0xBA, 0x80, 0x02
  out dx, al                                   ; 09ECF  0xEE
  call fdc_wait                                ; 09ED0  0xE8, 0x7A, 0x00
  db 0x32, 0xFF                                ; 09ED3  xor bh, bh
  mov bl, [bp + 0xe]                           ; 09ED5  0x8A, 0x5E, 0x0E
  inc byte [cs:bx + 0x3771]                    ; 09ED8  0x2E, 0xFE, 0x87, 0x71, 0x37
  test byte [cs:0x3782], 0x99                  ; 09EDD  0x2E, 0xF6, 0x06, 0x82, 0x37, 0x99
  clc                                          ; 09EE3  0xF8
  je loc_09EF2                                 ; 09EE4  0x74, 0x0C
  mov byte [cs:bx + 0x3771], 0xff              ; 09EE6  0x2E, 0xC6, 0x87, 0x71, 0x37, 0xFF
  call xios_fdc_restore_track0                 ; 09EEC  0xE8, 0x59, 0xFF
  call sub_09E75                               ; 09EEF  0xE8, 0x83, 0xFF

loc_09EF2:                                     ; 09EF2
  ret                                          ; 09EF2  0xC3

xios_fdc_cmd_read_sector:                      ; 09EF3
  mov ax, [bp + 0xa]                           ; 09EF3  0x8B, 0x46, 0x0A
  mov dx, PORT_FDC_SECTOR                      ; 09EF6  0xBA, 0x84, 0x02
  out dx, al                                   ; 09EF9  0xEE
  mov al, 0x88                                 ; 09EFA  0xB0, 0x88
  or al, [cs:0x376a]                           ; 09EFC  0x2E, 0x0A, 0x06, 0x6A, 0x37
  or al, [cs:0x376b]                           ; 09F01  0x2E, 0x0A, 0x06, 0x6B, 0x37

fdc_send_cmd:                                  ; 09F06
  mov dx, PORT_FDC_CMD                         ; 09F06  0xBA, 0x80, 0x02
  out dx, al                                   ; 09F09  0xEE
  call fdc_wait                                ; 09F0A  0xE8, 0x40, 0x00
  ret                                          ; 09F0D  0xC3

xios_fdc_read_track_reg:                       ; 09F0E
  mov ah, [cs:0x376c]                          ; 09F0E  0x2E, 0x8A, 0x26, 0x6C, 0x37
  and ah, 0xef                                 ; 09F13  0x80, 0xE4, 0xEF
  mov dx, PORT_FDC_TRACK                       ; 09F16  0xBA, 0x82, 0x02
  in al, dx                                    ; 09F19  0xEC
  cmp al, 0x2a                                 ; 09F1A  0x3C, 0x2A
  jb loc_09F21                                 ; 09F1C  0x72, 0x03
  or ah, 0x10                                  ; 09F1E  0x80, 0xCC, 0x10

loc_09F21:                                     ; 09F21
  db 0x8A, 0xC4                                ; 09F21  mov al, ah
  mov [cs:0x376c], al                          ; 09F23  0x2E, 0xA2, 0x6C, 0x37
  mov dx, PORT_FDC_CTRL                        ; 09F27  0xBA, 0x88, 0x02
  out dx, al                                   ; 09F2A  0xEE
  mov ax, [bp + 0xa]                           ; 09F2B  0x8B, 0x46, 0x0A
  mov dx, PORT_FDC_SECTOR                      ; 09F2E  0xBA, 0x84, 0x02
  out dx, al                                   ; 09F31  0xEE
  mov al, 0xa8                                 ; 09F32  0xB0, 0xA8
  or al, [cs:0x376a]                           ; 09F34  0x2E, 0x0A, 0x06, 0x6A, 0x37
  or al, [cs:0x376b]                           ; 09F39  0x2E, 0x0A, 0x06, 0x6B, 0x37
  mov dx, PORT_FDC_CMD                         ; 09F3E  0xBA, 0x80, 0x02
  out dx, al                                   ; 09F41  0xEE
  call fdc_wait                                ; 09F42  0xE8, 0x08, 0x00
  ret                                          ; 09F45  0xC3
  mov al, 0xd8                                 ; 09F46  0xB0, 0xD8
  mov dx, PORT_FDC_CMD                         ; 09F48  0xBA, 0x80, 0x02
  out dx, al                                   ; 09F4B  0xEE
  ret                                          ; 09F4C  0xC3

fdc_wait:                                      ; 09F4D
  mov byte [cs:0x376e], 1                      ; 09F4D  0x2E, 0xC6, 0x06, 0x6E, 0x37, 0x01
  mov dx, 8                                    ; 09F53  0xBA, 0x08, 0x00
  call rtm_timer_wait                          ; 09F56  0xE8, 0x78, 0xD9
  ret                                          ; 09F59  0xC3

; -----------------------------------------------------------------------------
; WD2797 Diskettedrev Afbrydelsesrutine (Floppy ISR, IR0 / Vektor 0x80)
; 1. Læser FDC status fra PORT_FDC_CMD (0x280).
; 2. Sender Type IV FORCE INTERRUPT (0xD0) for at afslutte kommandoen.
; 3. Læser PORT_PCB_DMA0_CNT (0xFFC8) for at verificere fuldført DMA transfer.
; 4. Kvitterer med EOI via eoi_helper.
; 5. Vækker den ventende proces ved at signalere Flag 8 ("Floppy disk flag").
; -----------------------------------------------------------------------------
i_disk:
fdc_transfer_isr:
  call xios_switch_to_priv_stack               ; 09F5A  0xE8, 0xC0, 0x0F
  mov ds, [cs:0xc06]                           ; 09F5D  0x2E, 0x8E, 0x1E, 0x06, 0x0C
  mov dx, PORT_FDC_CMD                         ; 09F62  0xBA, 0x80, 0x02
  in al, dx                                    ; 09F65  0xEC
  mov [cs:0x3782], al                          ; 09F66  0x2E, 0xA2, 0x82, 0x37
  mov al, 0xd0                                 ; 09F6A  0xB0, 0xD0
  out dx, al                                   ; 09F6C  0xEE
  mov cx, 9                                    ; 09F6D  0xB9, 0x09, 0x00

loc_09F70:                                     ; 09F70
  loop loc_09F70                               ; 09F70  0xE2, 0xFE
  in al, dx                                    ; 09F72  0xEC
  mov dx, PORT_PCB_DMA0_CNT                    ; 09F73  0xBA, 0xC8, 0xFF
  in ax, dx                                    ; 09F76  0xED
  mov [cs:0x3783], ax                          ; 09F77  0x2E, 0xA3, 0x83, 0x37
  call eoi_helper                              ; 09F7B  0xE8, 0x93, 0x0F
  cmp byte [cs:0x376e], 1                      ; 09F7E  0x2E, 0x80, 0x3E, 0x6E, 0x37, 0x01
  jne loc_09F92                                ; 09F84  0x75, 0x0C
  mov byte [cs:0x376e], 0                      ; 09F86  0x2E, 0xC6, 0x06, 0x6E, 0x37, 0x00
  mov dx, 8                                    ; 09F8C  0xBA, 0x08, 0x00
  call rtm_call_helper                         ; 09F8F  0xE8, 0x2E, 0xD9

loc_09F92:                                     ; 09F92
  jmp near loc_0AF3E                           ; 09F92  0xE9, 0xA9, 0x0F

xios_fdc_test_busy:                            ; 09F95
  mov dx, PORT_FDC_CMD                         ; 09F95  0xBA, 0x80, 0x02
  in al, dx                                    ; 09F98  0xEC
  and al, 0x81                                 ; 09F99  0x24, 0x81
  clc                                          ; 09F9B  0xF8
  je loc_09F9F                                 ; 09F9C  0x74, 0x01
  stc                                          ; 09F9E  0xF9

loc_09F9F:                                     ; 09F9F
  ret                                          ; 09F9F  0xC3

sub_09FA0:                                     ; 09FA0
  mov byte [cs:0x3756], 0                      ; 09FA0  0x2E, 0xC6, 0x06, 0x56, 0x37, 0x00
  mov al, [cs:0x3782]                          ; 09FA6  0x2E, 0xA0, 0x82, 0x37
  test al, 0xbf                                ; 09FAA  0xA8, 0xBF
  jne loc_09FB8                                ; 09FAC  0x75, 0x0A
  cmp word [cs:0x3783], 0                      ; 09FAE  0x2E, 0x83, 0x3E, 0x83, 0x37, 0x00
  jne loc_09FB8                                ; 09FB4  0x75, 0x02
  clc                                          ; 09FB6  0xF8
  ret                                          ; 09FB7  0xC3

loc_09FB8:                                     ; 09FB8
  mov bx, 0x3845                               ; 09FB8  0xBB, 0x45, 0x38
  call sub_09CEE                               ; 09FBB  0xE8, 0x30, 0xFD
  inc byte [cs:0x3756]                         ; 09FBE  0x2E, 0xFE, 0x06, 0x56, 0x37
  stc                                          ; 09FC3  0xF9
  ret                                          ; 09FC4  0xC3

sub_09FC5:                                     ; 09FC5
  mov byte [cs:0x3757], 0                      ; 09FC5  0x2E, 0xC6, 0x06, 0x57, 0x37, 0x00
  mov al, [cs:0x3782]                          ; 09FCB  0x2E, 0xA0, 0x82, 0x37
  test al, 0xff                                ; 09FCF  0xA8, 0xFF
  jne loc_09FDD                                ; 09FD1  0x75, 0x0A
  cmp word [cs:0x3783], 0                      ; 09FD3  0x2E, 0x83, 0x3E, 0x83, 0x37, 0x00
  jne loc_09FDD                                ; 09FD9  0x75, 0x02
  clc                                          ; 09FDB  0xF8
  ret                                          ; 09FDC  0xC3

loc_09FDD:                                     ; 09FDD
  mov bx, 0x3865                               ; 09FDD  0xBB, 0x65, 0x38
  call sub_09CEE                               ; 09FE0  0xE8, 0x0B, 0xFD
  mov byte [cs:0x3757], 1                      ; 09FE3  0x2E, 0xC6, 0x06, 0x57, 0x37, 0x01
  mov al, [cs:0x3782]                          ; 09FE9  0x2E, 0xA0, 0x82, 0x37
  test al, 0x40                                ; 09FED  0xA8, 0x40
  je loc_09FF7                                 ; 09FEF  0x74, 0x06
  mov byte [cs:0x3757], 2                      ; 09FF1  0x2E, 0xC6, 0x06, 0x57, 0x37, 0x02

loc_09FF7:                                     ; 09FF7
  stc                                          ; 09FF7  0xF9
  ret                                          ; 09FF8  0xC3
xios_int28_fn_05_recalibrate:                ; 09FF9
  mov byte [cs:0x3781], 1                      ; 09FF9  0x2E, 0xC6, 0x06, 0x81, 0x37, 0x01
  db 0x8B, 0xEC                                ; 09FFF  mov bp, sp
  mov ah, [bp + 0x14]                          ; 0A001  0x8A, 0x66, 0x14
  call sub_09D1B                               ; 0A004  0xE8, 0x14, 0xFD
  mov al, 0xc                                  ; 0A007  0xB0, 0x0C
  and al, 0xfb                                 ; 0A009  0x24, 0xFB

fdc_read_path:                                 ; 0A00B
  mov dx, PORT_FDC_CMD                         ; 0A00B  0xBA, 0x80, 0x02
  out dx, al                                   ; 0A00E  0xEE
  call fdc_wait                                ; 0A00F  0xE8, 0x3B, 0xFF
  jmp near loc_0A13C                           ; 0A012  0xE9, 0x27, 0x01
xios_int28_fn_06_reserved:                   ; 0A015
  ret                                          ; 0A015  0xC3

xios_int28_fn_07_reserved:                   ; 0A016
  ret                                          ; 0A016  0xC3
xios_int28_fn_08_step_in:                    ; 0A017
  mov byte [cs:0x3781], 1                      ; 0A017  0x2E, 0xC6, 0x06, 0x81, 0x37, 0x01
  db 0x8B, 0xEC                                ; 0A01D  mov bp, sp
  mov ah, [bp + 0x14]                          ; 0A01F  0x8A, 0x66, 0x14
  call sub_09D1B                               ; 0A022  0xE8, 0xF6, 0xFC
  mov al, 0x5c                                 ; 0A025  0xB0, 0x5C
  and al, 0xfb                                 ; 0A027  0x24, 0xFB
  mov dx, PORT_FDC_CMD                         ; 0A029  0xBA, 0x80, 0x02
  out dx, al                                   ; 0A02C  0xEE
  call fdc_wait                                ; 0A02D  0xE8, 0x1D, 0xFF
  jmp near loc_0A13C                           ; 0A030  0xE9, 0x09, 0x01
xios_int28_fn_09_step_out:                   ; 0A033
  ret                                          ; 0A033  0xC3

xios_int28_fn_10_write_track:                ; 0A034
  mov byte [cs:0x3781], 1                      ; 0A034  0x2E, 0xC6, 0x06, 0x81, 0x37, 0x01
  db 0x8B, 0xEC                                ; 0A03A  mov bp, sp
  mov ax, [bp + 0xc]                           ; 0A03C  0x8B, 0x46, 0x0C
  mov bx, [bp + 0xa]                           ; 0A03F  0x8B, 0x5E, 0x0A
  call sub_0A222                               ; 0A042  0xE8, 0xDD, 0x01
  db 0x2E, 0xC7, 0x06, 0x3B, 0x37, 0xA6, 0x76  ; 0A045  mov word [cs:0x373b], 0x76a6
  db 0x32, 0xC0                                ; 0A04C  xor al, al
  call sub_0A257                               ; 0A04E  0xE8, 0x06, 0x02
  db 0x32, 0xC0                                ; 0A051  xor al, al
  call xios_dma_chan_ctrl                      ; 0A053  0xE8, 0x3F, 0x02
  mov ah, 4                                    ; 0A056  0xB4, 0x04
  db 0x32, 0xC0                                ; 0A058  xor al, al
  call xios_dma_mask_reg                       ; 0A05A  0xE8, 0x3D, 0x02
  mov ah, [bp + 0x14]                          ; 0A05D  0x8A, 0x66, 0x14
  call sub_09D1B                               ; 0A060  0xE8, 0xB8, 0xFC
  mov byte [cs:0x3757], 1                      ; 0A063  0x2E, 0xC6, 0x06, 0x57, 0x37, 0x01
  call xios_fdc_test_busy                      ; 0A069  0xE8, 0x29, 0xFF
  jae loc_0A071                                ; 0A06C  0x73, 0x03
  jmp near loc_0A0A8                           ; 0A06E  0xE9, 0x37, 0x00

loc_0A071:                                     ; 0A071
  mov ax, [bp + 0xe]                           ; 0A071  0x8B, 0x46, 0x0E
  mov dx, PORT_FDC_DATA                        ; 0A074  0xBA, 0x86, 0x02
  mov si, 0x375b                               ; 0A077  0xBE, 0x5B, 0x37
  call sub_0A1EC                               ; 0A07A  0xE8, 0x6F, 0x01
  mov byte [cs:0x376b], 0                      ; 0A07D  0x2E, 0xC6, 0x06, 0x6B, 0x37, 0x00
  mov byte [cs:0x3769], 0                      ; 0A083  0x2E, 0xC6, 0x06, 0x69, 0x37, 0x00
  mov byte [cs:0x376a], 0                      ; 0A089  0x2E, 0xC6, 0x06, 0x6A, 0x37, 0x00
  cmp byte [bp + 0x12], 0                      ; 0A08F  0x80, 0x7E, 0x12, 0x00
  je loc_0A09B                                 ; 0A093  0x74, 0x06
  mov byte [cs:0x376a], 2                      ; 0A095  0x2E, 0xC6, 0x06, 0x6A, 0x37, 0x02

loc_0A09B:                                     ; 0A09B
  mov si, 0x375b                               ; 0A09B  0xBE, 0x5B, 0x37
  db 0x32, 0xC0                                ; 0A09E  xor al, al
  call sub_0A23C                               ; 0A0A0  0xE8, 0x99, 0x01
  mov al, 0xf4                                 ; 0A0A3  0xB0, 0xF4
  call xios_fdc_send_cmd_wait                  ; 0A0A5  0xE8, 0x08, 0x00

loc_0A0A8:                                     ; 0A0A8
  db 0x32, 0xC0                                ; 0A0A8  xor al, al
  call sub_0A276                               ; 0A0AA  0xE8, 0xC9, 0x01
  jmp near loc_0A13C                           ; 0A0AD  0xE9, 0x8C, 0x00

xios_fdc_send_cmd_wait:                        ; 0A0B0
  mov dl, [bp + 0x12]                          ; 0A0B0  0x8A, 0x56, 0x12
  shl dl, 1                                    ; 0A0B3  0xD0, 0xE2
  db 0x0A, 0xC2                                ; 0A0B5  or al, dl
  mov dx, PORT_FDC_CMD                         ; 0A0B7  0xBA, 0x80, 0x02
  out dx, al                                   ; 0A0BA  0xEE
  call fdc_wait                                ; 0A0BB  0xE8, 0x8F, 0xFE
  ret                                          ; 0A0BE  0xC3
xios_int28_fn_11_read_track:                 ; 0A0BF
  mov byte [cs:0x3781], 1                      ; 0A0BF  0x2E, 0xC6, 0x06, 0x81, 0x37, 0x01
  db 0x8B, 0xEC                                ; 0A0C5  mov bp, sp
  mov ax, [bp + 0xc]                           ; 0A0C7  0x8B, 0x46, 0x0C
  mov bx, [bp + 0xa]                           ; 0A0CA  0x8B, 0x5E, 0x0A
  call sub_0A222                               ; 0A0CD  0xE8, 0x52, 0x01
  db 0x2E, 0xC7, 0x06, 0x3B, 0x37, 0x66, 0xAE  ; 0A0D0  mov word [cs:0x373b], 0xae66
  db 0x32, 0xC0                                ; 0A0D7  xor al, al
  call sub_0A257                               ; 0A0D9  0xE8, 0x7B, 0x01
  db 0x32, 0xC0                                ; 0A0DC  xor al, al
  call xios_dma_chan_ctrl                      ; 0A0DE  0xE8, 0xB4, 0x01
  mov ah, 4                                    ; 0A0E1  0xB4, 0x04
  db 0x32, 0xC0                                ; 0A0E3  xor al, al
  call xios_dma_mask_reg                       ; 0A0E5  0xE8, 0xB2, 0x01
  mov ah, [bp + 0x14]                          ; 0A0E8  0x8A, 0x66, 0x14
  call sub_09D1B                               ; 0A0EB  0xE8, 0x2D, 0xFC
  mov byte [cs:0x3757], 1                      ; 0A0EE  0x2E, 0xC6, 0x06, 0x57, 0x37, 0x01
  call xios_fdc_test_busy                      ; 0A0F4  0xE8, 0x9E, 0xFE
  jae loc_0A0FC                                ; 0A0F7  0x73, 0x03
  jmp near loc_0A133                           ; 0A0F9  0xE9, 0x37, 0x00

loc_0A0FC:                                     ; 0A0FC
  mov ax, [bp + 0xe]                           ; 0A0FC  0x8B, 0x46, 0x0E
  mov dx, PORT_FDC_DATA                        ; 0A0FF  0xBA, 0x86, 0x02
  mov si, 0x375b                               ; 0A102  0xBE, 0x5B, 0x37
  call sub_0A1EC                               ; 0A105  0xE8, 0xE4, 0x00
  mov byte [cs:0x376b], 0                      ; 0A108  0x2E, 0xC6, 0x06, 0x6B, 0x37, 0x00
  mov byte [cs:0x3769], 0                      ; 0A10E  0x2E, 0xC6, 0x06, 0x69, 0x37, 0x00
  mov byte [cs:0x376a], 0                      ; 0A114  0x2E, 0xC6, 0x06, 0x6A, 0x37, 0x00
  cmp byte [bp + 0x12], 0                      ; 0A11A  0x80, 0x7E, 0x12, 0x00
  je loc_0A126                                 ; 0A11E  0x74, 0x06
  mov byte [cs:0x376a], 2                      ; 0A120  0x2E, 0xC6, 0x06, 0x6A, 0x37, 0x02

loc_0A126:                                     ; 0A126
  mov si, 0x375b                               ; 0A126  0xBE, 0x5B, 0x37
  db 0x32, 0xC0                                ; 0A129  xor al, al
  call sub_0A23C                               ; 0A12B  0xE8, 0x0E, 0x01
  mov al, 0xe4                                 ; 0A12E  0xB0, 0xE4
  call xios_fdc_send_cmd_wait                  ; 0A130  0xE8, 0x7D, 0xFF

loc_0A133:                                     ; 0A133
  db 0x32, 0xC0                                ; 0A133  xor al, al
  call sub_0A276                               ; 0A135  0xE8, 0x3E, 0x01
  jmp near loc_0A13C                           ; 0A138  0xE9, 0x01, 0x00
  ret                                          ; 0A13B  0xC3

loc_0A13C:                                     ; 0A13C
  mov ah, [bp + 0x14]                          ; 0A13C  0x8A, 0x66, 0x14
  call sub_09DBB                               ; 0A13F  0xE8, 0x79, 0xFC
  mov al, [cs:0x3782]                          ; 0A142  0x2E, 0xA0, 0x82, 0x37
  mov byte [cs:0x3781], 0                      ; 0A146  0x2E, 0xC6, 0x06, 0x81, 0x37, 0x00
  ret                                          ; 0A14C  0xC3
xios_int28_fn_13_disk_stats:                 ; 0A14D
  mov es, [cs:0xc06]                           ; 0A14D  0x2E, 0x8E, 0x06, 0x06, 0x0C
  mov ax, 0x3785                               ; 0A152  0xB8, 0x85, 0x37
  ret                                          ; 0A155  0xC3
xios_int28_fn_14_reserved:                   ; 0A156
  ret                                          ; 0A156  0xC3
  db 0x00, 0x00                                ; 0A157  ..

loc_0A159:                                     ; 0A159
  call sub_0A17F                               ; 0A159  0xE8, 0x23, 0x00
  push es                                      ; 0A15C  0x06
  les di, [bp + 6]                             ; 0A15D  0xC4, 0x7E, 0x06
  db 0x33, 0xF6                                ; 0A160  xor si, si
  push ds                                      ; 0A162  0x1E
  mov ds, bx                                   ; 0A163  0x8E, 0xDB
  rep movsw                                    ; 0A165  0xF3, 0xA5
  pop ds                                       ; 0A167  0x1F
  pop es                                       ; 0A168  0x07
  db 0x33, 0xC0                                ; 0A169  xor ax, ax
  ret                                          ; 0A16B  0xC3

loc_0A16C:                                     ; 0A16C
  call sub_0A17F                               ; 0A16C  0xE8, 0x10, 0x00
  push es                                      ; 0A16F  0x06
  mov es, bx                                   ; 0A170  0x8E, 0xC3
  db 0x33, 0xFF                                ; 0A172  xor di, di
  push ds                                      ; 0A174  0x1E
  lds si, [bp + 6]                             ; 0A175  0xC5, 0x76, 0x06
  rep movsw                                    ; 0A178  0xF3, 0xA5
  pop ds                                       ; 0A17A  0x1F
  pop es                                       ; 0A17B  0x07
  db 0x33, 0xC0                                ; 0A17C  xor ax, ax
  ret                                          ; 0A17E  0xC3

sub_0A17F:                                     ; 0A17F
  mov bx, [bp + 0xc]                           ; 0A17F  0x8B, 0x5E, 0x0C
  mov cl, 3                                    ; 0A182  0xB1, 0x03
  shl bx, cl                                   ; 0A184  0xD3, 0xE3
  mov cx, [bp + 0xa]                           ; 0A186  0x8B, 0x4E, 0x0A
  db 0x03, 0xD9                                ; 0A189  add bx, cx
  mov cl, 3                                    ; 0A18B  0xB1, 0x03
  shl bx, cl                                   ; 0A18D  0xD3, 0xE3
  add bx, [cs:0x35b7]                          ; 0A18F  0x2E, 0x03, 0x1E, 0xB7, 0x35
  mov cx, 0x40                                 ; 0A194  0xB9, 0x40, 0x00
  mov al, [bp + 0xf]                           ; 0A197  0x8A, 0x46, 0x0F
  db 0x32, 0xE4                                ; 0A19A  xor ah, ah
  db 0xF7, 0xE1                                ; 0A19C  mul cx
  db 0x8B, 0xC8                                ; 0A19E  mov cx, ax
  cld                                          ; 0A1A0  0xFC
  ret                                          ; 0A1A1  0xC3
  db 0x00                                      ; 0A1A2  .
  inc ax                                       ; 0A1A3  0x40

loc_0A1A4:                                     ; 0A1A4
  call sub_0A1BF                               ; 0A1A4  0xE8, 0x18, 0x00
  push es                                      ; 0A1A7  0x06
  les di, [bp + 6]                             ; 0A1A8  0xC4, 0x7E, 0x06
  db 0x33, 0xF6                                ; 0A1AB  xor si, si
  push ds                                      ; 0A1AD  0x1E
  mov ds, bx                                   ; 0A1AE  0x8E, 0xDB

loc_0A1B0:                                     ; 0A1B0
  mov ax, [si]                                 ; 0A1B0  0x8B, 0x04
  lodsw                                        ; 0A1B2  0xAD
  stosw                                        ; 0A1B3  0xAB
  loop loc_0A1B0                               ; 0A1B4  0xE2, 0xFA
  pop ds                                       ; 0A1B6  0x1F
  pop es                                       ; 0A1B7  0x07
  db 0x33, 0xC0                                ; 0A1B8  xor ax, ax
  ret                                          ; 0A1BA  0xC3

loc_0A1BB:                                     ; 0A1BB
  mov ax, 1                                    ; 0A1BB  0xB8, 0x01, 0x00
  ret                                          ; 0A1BE  0xC3

sub_0A1BF:                                     ; 0A1BF
  mov bx, [bp + 0xc]                           ; 0A1BF  0x8B, 0x5E, 0x0C
  mov cl, 3                                    ; 0A1C2  0xB1, 0x03
  shl bx, cl                                   ; 0A1C4  0xD3, 0xE3
  mov cx, [bp + 0xa]                           ; 0A1C6  0x8B, 0x4E, 0x0A
  db 0x03, 0xD9                                ; 0A1C9  add bx, cx
  mov cl, 3                                    ; 0A1CB  0xB1, 0x03
  shl bx, cl                                   ; 0A1CD  0xD3, 0xE3
  add bx, [cs:0x3602]                          ; 0A1CF  0x2E, 0x03, 0x1E, 0x02, 0x36
  mov cx, 0x40                                 ; 0A1D4  0xB9, 0x40, 0x00
  mov al, [bp + 0xf]                           ; 0A1D7  0x8A, 0x46, 0x0F
  db 0x32, 0xE4                                ; 0A1DA  xor ah, ah
  db 0xF7, 0xE1                                ; 0A1DC  mul cx
  db 0x8B, 0xC8                                ; 0A1DE  mov cx, ax
  cld                                          ; 0A1E0  0xFC
  ret                                          ; 0A1E1  0xC3

sub_0A1E2:                                     ; 0A1E2
  mov cl, [cs:0x3777]                          ; 0A1E2  0x2E, 0x8A, 0x0E, 0x77, 0x37
  add cl, 7                                    ; 0A1E7  0x80, 0xC1, 0x07
  shl ax, cl                                   ; 0A1EA  0xD3, 0xE0

sub_0A1EC:                                     ; 0A1EC
  mov [si + 8], ax                             ; 0A1EC  0x89, 0x44, 0x08
  mov ax, [cs:0x373b]                          ; 0A1EF  0x2E, 0xA1, 0x3B, 0x37
  mov [si + 0xa], ax                           ; 0A1F3  0x89, 0x44, 0x0A
  mov bl, [cs:0x375a]                          ; 0A1F6  0x2E, 0x8A, 0x1E, 0x5A, 0x37
  db 0x32, 0xFF                                ; 0A1FB  xor bh, bh
  cmp ax, 0xae66                               ; 0A1FD  0x3D, 0x66, 0xAE
  mov ax, [cs:0x3758]                          ; 0A200  0x2E, 0xA1, 0x58, 0x37
  je loc_0A214                                 ; 0A204  0x74, 0x0E
  mov word [si], 0                             ; 0A206  0xC7, 0x04, 0x00, 0x00
  mov [si + 2], dx                             ; 0A20A  0x89, 0x54, 0x02
  mov [si + 4], bx                             ; 0A20D  0x89, 0x5C, 0x04
  mov [si + 6], ax                             ; 0A210  0x89, 0x44, 0x06
  ret                                          ; 0A213  0xC3

loc_0A214:                                     ; 0A214
  mov [si], bx                                 ; 0A214  0x89, 0x1C
  mov [si + 2], ax                             ; 0A216  0x89, 0x44, 0x02
  mov word [si + 4], 0                         ; 0A219  0xC7, 0x44, 0x04, 0x00, 0x00
  mov [si + 6], dx                             ; 0A21E  0x89, 0x54, 0x06
  ret                                          ; 0A221  0xC3

sub_0A222:                                     ; 0A222
  mov cl, 4                                    ; 0A222  0xB1, 0x04
  rol ax, cl                                   ; 0A224  0xD3, 0xC0
  db 0x8A, 0xE8                                ; 0A226  mov ch, al
  and al, 0xf0                                 ; 0A228  0x24, 0xF0
  db 0x03, 0xC3                                ; 0A22A  add ax, bx
  adc ch, 0                                    ; 0A22C  0x80, 0xD5, 0x00
  and ch, 0xf                                  ; 0A22F  0x80, 0xE5, 0x0F
  mov [cs:0x3758], ax                          ; 0A232  0x2E, 0xA3, 0x58, 0x37
  mov [cs:0x375a], ch                          ; 0A236  0x2E, 0x88, 0x2E, 0x5A, 0x37
  ret                                          ; 0A23B  0xC3

sub_0A23C:                                     ; 0A23C
  cli                                          ; 0A23C  0xFA
  mov di, 0x373d                               ; 0A23D  0xBF, 0x3D, 0x37
  test al, 1                                   ; 0A240  0xA8, 0x01
  je loc_0A247                                 ; 0A242  0x74, 0x03
  mov di, 0x3749                               ; 0A244  0xBF, 0x49, 0x37

loc_0A247:                                     ; 0A247
  mov cx, 6                                    ; 0A247  0xB9, 0x06, 0x00

loc_0A24A:                                     ; 0A24A
  mov dx, [di]                                 ; 0A24A  0x8B, 0x15
  mov ax, [si]                                 ; 0A24C  0x8B, 0x04
  out dx, ax                                   ; 0A24E  0xEF
  inc di                                       ; 0A24F  0x47
  inc di                                       ; 0A250  0x47
  inc si                                       ; 0A251  0x46
  inc si                                       ; 0A252  0x46
  loop loc_0A24A                               ; 0A253  0xE2, 0xF5
  sti                                          ; 0A255  0xFB
  ret                                          ; 0A256  0xC3

sub_0A257:                                     ; 0A257
  mov dx, 0x5999                               ; 0A257  0xBA, 0x99, 0x59
  db 0x0A, 0xC0                                ; 0A25A  or al, al
  je loc_0A261                                 ; 0A25C  0x74, 0x03
  mov dx, 0x59c5                               ; 0A25E  0xBA, 0xC5, 0x59

loc_0A261:                                     ; 0A261
  pusha                                        ; 0A261  60
  mov cl, 0x89                                 ; 0A262  0xB1, 0x89
  call rtm_timer_wait2                         ; 0A264  0xE8, 0x6C, 0xD6
  popa                                         ; 0A267  61
  cli                                          ; 0A268  0xFA
  mov ah, 1                                    ; 0A269  0xB4, 0x01
  db 0x8A, 0xC8                                ; 0A26B  mov cl, al
  shl ah, cl                                   ; 0A26D  0xD2, 0xE4
  xor [cs:0x3755], ah                          ; 0A26F  0x2E, 0x30, 0x26, 0x55, 0x37
  sti                                          ; 0A274  0xFB
  ret                                          ; 0A275  0xC3

sub_0A276:                                     ; 0A276
  cli                                          ; 0A276  0xFA
  mov ah, 1                                    ; 0A277  0xB4, 0x01
  db 0x8A, 0xC8                                ; 0A279  mov cl, al
  shl ah, cl                                   ; 0A27B  0xD2, 0xE4
  or [cs:0x3755], ah                           ; 0A27D  0x2E, 0x08, 0x26, 0x55, 0x37
  mov dx, 0x5999                               ; 0A282  0xBA, 0x99, 0x59
  db 0x0A, 0xC0                                ; 0A285  or al, al
  je loc_0A28C                                 ; 0A287  0x74, 0x03
  mov dx, 0x59c5                               ; 0A289  0xBA, 0xC5, 0x59

loc_0A28C:                                     ; 0A28C
  pusha                                        ; 0A28C  60
  mov cl, 0x8b                                 ; 0A28D  0xB1, 0x8B
  call rtm_timer_wait2                         ; 0A28F  0xE8, 0x41, 0xD6
  popa                                         ; 0A292  61
  sti                                          ; 0A293  0xFB
  ret                                          ; 0A294  0xC3

xios_dma_chan_ctrl:                            ; 0A295
  or al, 0xa                                   ; 0A295  0x0C, 0x0A
  out PORT_PPI_CTRL, al                        ; 0A297  0xE6, 0x76
  ret                                          ; 0A299  0xC3

xios_dma_mask_reg:                             ; 0A29A
  cli                                          ; 0A29A  0xFA
  mov ch, 0xf3                                 ; 0A29B  0xB5, 0xF3
  cmp al, 0                                    ; 0A29D  0x3C, 0x00
  je loc_0A2A7                                 ; 0A29F  0x74, 0x06
  mov ch, 0xc7                                 ; 0A2A1  0xB5, 0xC7
  mov cl, 3                                    ; 0A2A3  0xB1, 0x03
  shl ah, cl                                   ; 0A2A5  0xD2, 0xE4

loc_0A2A7:                                     ; 0A2A7
  in al, PORT_PPI_PORTC                        ; 0A2A7  0xE4, 0x74
  db 0x22, 0xC5                                ; 0A2A9  and al, ch
  db 0x0A, 0xC4                                ; 0A2AB  or al, ah
  out PORT_PPI_PORTC, al                       ; 0A2AD  0xE6, 0x74
  sti                                          ; 0A2AF  0xFB
  ret                                          ; 0A2B0  0xC3
  push dx                                      ; 0A2B1  0x52
  mov [cs:0x392f], ax                          ; 0A2B2  0x2E, 0xA3, 0x2F, 0x39
  cmp byte [cs:0x3781], 1                      ; 0A2B6  0x2E, 0x80, 0x3E, 0x81, 0x37, 0x01
  jne loc_0A2C4                                ; 0A2BC  0x75, 0x06

fdc_isr:                                       ; 0A2BE
  mov dx, PORT_FDC_CMD                         ; 0A2BE  0xBA, 0x80, 0x02
  mov al, 0xd8                                 ; 0A2C1  0xB0, 0xD8
  out dx, al                                   ; 0A2C3  0xEE

loc_0A2C4:                                     ; 0A2C4
  pop dx                                       ; 0A2C4  0x5A
  mov ax, [cs:0x392f]                          ; 0A2C5  0x2E, 0xA1, 0x2F, 0x39
  push dx                                      ; 0A2C9  0x52
  mov [cs:0x392f], ax                          ; 0A2CA  0x2E, 0xA3, 0x2F, 0x39
  mov dx, PORT_PCB_EOI                         ; 0A2CE  0xBA, 0x22, 0xFF
  mov ax, 0x8000                               ; 0A2D1  0xB8, 0x00, 0x80
  out dx, ax                                   ; 0A2D4  0xEF
  mov ax, [cs:0x392f]                          ; 0A2D5  0x2E, 0xA1, 0x2F, 0x39
  pop dx                                       ; 0A2D9  0x5A
  iret                                         ; 0A2DA  0xCF
  db 0x00, 0x00, 0xC6                          ; 0A2DB  ...
  db 0xFF, 0xC4                                ; 0A2DE  inc sp
  db 0xFF, 0xC2                                ; 0A2E0  inc dx
  db 0xFF, 0xC0                                ; 0A2E2  inc ax
  db 0xFF, 0xC8                                ; 0A2E4  dec ax
  db 0xFF, 0xCA                                ; 0A2E6  dec dx
  call si                                      ; 0A2E8  0xFF, 0xD6
  call sp                                      ; 0A2EA  0xFF, 0xD4
  call dx                                      ; 0A2EC  0xFF, 0xD2
  call ax                                      ; 0A2EE  0xFF, 0xD0
  db 0xFF, 0xD8, 0xFF, 0xDA                    ; 0A2F0  ....
  inc word [bp + di]                           ; 0A2F4  0xFF, 0x03
  db 0x00, 0x00                                ; 0A2F6
  db 0x00, 0x00                                ; 0A2F8
  db 0x00, 0x00                                ; 0A2FA
  db 0x00, 0x00                                ; 0A2FC
  db 0x00, 0x00                                ; 0A2FE
  db 0x00, 0x00                                ; 0A300
  db 0x00, 0x00                                ; 0A302
  db 0x00, 0x00                                ; 0A304
  db 0x00, 0x00                                ; 0A306
  or [bx + si], al                             ; 0A308  0x08, 0x00
  db 0x00, 0x00                                ; 0A30A
  dec ax                                       ; 0A30C  0x48
  db 0x00, 0x00                                ; 0A30D
  db 0x00, 0x00                                ; 0A30F
  db 0x00, 0x00                                ; 0A311
  db 0x00, 0x00                                ; 0A313
  db 0x00, 0x00                                ; 0A315
  db 0x00, 0x00                                ; 0A317
  db 0x00, 0x00                                ; 0A319
  db 0x00, 0x00                                ; 0A31B
  db 0x00, 0x00                                ; 0A31D
  inc word [bx + si]                           ; 0A31F  0xFF, 0x00
  db 0x00, 0x00                                ; 0A321
  db 0x00, 0x00                                ; 0A323
  db 0x00, 0x00                                ; 0A325
  db 0x00, 0x00                                ; 0A327
  db 0x00, 0x00                                ; 0A329
  db 0x00, 0x00                                ; 0A32B
  db 0x00, 0x00                                ; 0A32D
  db 0x00, 0x00                                ; 0A32F
  db 0x00, 0x00                                ; 0A331
  db 0x00, 0x00                                ; 0A333
  db 0x00, 0x00                                ; 0A335
  db 0x00, 0x00                                ; 0A337
  db 0x00, 0x00                                ; 0A339
  db 0x00, 0x00                                ; 0A33B
  db 0x00, 0x00                                ; 0A33D
  db 0x00, 0x00                                ; 0A33F
  db 0x00, 0x00                                ; 0A341
  db 0x00, 0x00                                ; 0A343
  db 0x00, 0x00                                ; 0A345
  db 0x00, 0x00                                ; 0A347
  db 0x00, 0x00                                ; 0A349
  db 0x00, 0x00                                ; 0A34B
  db 0x00, 0x00                                ; 0A34D
  db 0x00, 0x00                                ; 0A34F
  db 0x00, 0x00                                ; 0A351
  db 0x00, 0x00                                ; 0A353
  db 0x00, 0x00                                ; 0A355
  db 0x00, 0x00                                ; 0A357
  db 0x00, 0x00                                ; 0A359
  db 0x00, 0x00                                ; 0A35B
  db 0x00, 0x00                                ; 0A35D
  db 0x00, 0x00                                ; 0A35F
  db 0x00, 0x00                                ; 0A361
  db 0x00, 0x00                                ; 0A363
  db 0x00, 0x00                                ; 0A365
  db 0x00, 0x00                                ; 0A367
  db 0x00, 0x00                                ; 0A369
  db 0x00, 0x00                                ; 0A36B
  db 0x00, 0x00                                ; 0A36D
  db 0x00, 0x00                                ; 0A36F
  db 0x00, 0x00                                ; 0A371
  db 0x00, 0x00                                ; 0A373
  db 0x00, 0x00                                ; 0A375
  db 0x00, 0x00                                ; 0A377
  db 0x00, 0x00                                ; 0A379
  db 0x00, 0x00                                ; 0A37B
  db 0x00, 0x00                                ; 0A37D
  db 0x00, 0x00                                ; 0A37F
  db 0x00, 0x00                                ; 0A381
  db 0x00, 0x00                                ; 0A383
  db 0x00, 0x00                                ; 0A385
  db 0x00, 0x00                                ; 0A387
  db 0x00, 0x00                                ; 0A389
  db 0x00, 0x00                                ; 0A38B
  db 0x00, 0x00                                ; 0A38D
  db 0x00, 0x00                                ; 0A38F
  db 0x00, 0x00                                ; 0A391
  db 0x00, 0x00                                ; 0A393
  db 0x00, 0x00                                ; 0A395
  db 0x00, 0x00                                ; 0A397
  db 0x00, 0x00                                ; 0A399
  db 0x00, 0x00                                ; 0A39B
  db 0x00, 0x00                                ; 0A39D
  db 0x00, 0x00                                ; 0A39F
  db 0x00, 0x00                                ; 0A3A1
  db 0x00, 0x00                                ; 0A3A3
  db 0x00, 0x00                                ; 0A3A5
  db 0x00, 0x00                                ; 0A3A7
  db 0x00, 0x00                                ; 0A3A9
  db 0x00, 0x00                                ; 0A3AB
  db 0x00, 0x00                                ; 0A3AD
  db 0x00, 0x00                                ; 0A3AF
  db 0x00, 0x00                                ; 0A3B1
  db 0x00, 0x00                                ; 0A3B3
  db 0x00, 0x00                                ; 0A3B5
  db 0x00, 0x00                                ; 0A3B7
  db 0x00, 0x00                                ; 0A3B9
  db 0x00, 0x00                                ; 0A3BB
  db 0x00, 0x00                                ; 0A3BD
  db 0x00, 0x00                                ; 0A3BF
  db 0x00, 0x00                                ; 0A3C1
  db 0x00, 0x00                                ; 0A3C3
  db 0x00, 0x00                                ; 0A3C5
  db 0x00, 0x00                                ; 0A3C7
  db 0x00, 0x00                                ; 0A3C9
  db 0x00, 0x00                                ; 0A3CB
  db 0x00, 0x00                                ; 0A3CD
  db 0x00, 0x00                                ; 0A3CF
  db 0x00, 0x00                                ; 0A3D1
  db 0x00, 0x00                                ; 0A3D3
  db 0x00, 0x00                                ; 0A3D5
  db 0x00, 0x00                                ; 0A3D7
  db 0x00, 0x00                                ; 0A3D9
  db 0x00, 0x00                                ; 0A3DB
  db 0x00, 0x00                                ; 0A3DD
  db 0x00, 0x00                                ; 0A3DF
  db 0x00, 0x00                                ; 0A3E1
  db 0x00, 0x00                                ; 0A3E3
  db 0x00, 0x00                                ; 0A3E5
  db 0x00, 0x00                                ; 0A3E7
  db 0x00, 0x00                                ; 0A3E9
  db 0x00, 0x00                                ; 0A3EB
  db 0x00, 0x00                                ; 0A3ED
  db 0x00, 0x00                                ; 0A3EF
  db 0x00, 0x00                                ; 0A3F1
  db 0x00, 0x00                                ; 0A3F3
  db 0x00, 0x00                                ; 0A3F5
  db 0x00, 0x00                                ; 0A3F7
  db 0x00, 0x00                                ; 0A3F9
  db 0x00, 0x00                                ; 0A3FB
  db 0x00, 0x00                                ; 0A3FD
  db 0x00, 0x00                                ; 0A3FF
  db 0x00, 0x00                                ; 0A401
  db 0x00, 0x00                                ; 0A403
  db 0x00, 0x00                                ; 0A405
  db 0x00, 0x00                                ; 0A407
  db 0x00, 0x00                                ; 0A409
  db 0x00, 0x00                                ; 0A40B
  db 0x00, 0x00                                ; 0A40D
  db 0x00, 0x00                                ; 0A40F
  db 0x00, 0x00                                ; 0A411
  db 0x00, 0x00                                ; 0A413
  db 0x00, 0x00                                ; 0A415
  db 0x00, 0x00                                ; 0A417
  db 0x00, 0x00                                ; 0A419
  db 0x00, 0x00                                ; 0A41B
  db 0x00, 0x00                                ; 0A41D
  db 0x00, 0x00                                ; 0A41F
  db 0x00, 0x00                                ; 0A421
  db 0x00, 0x00                                ; 0A423
  db 0xCC                                      ; 0A425  int3
  db 0xCC                                      ; 0A426  int3
  db 0xCC                                      ; 0A427  int3
  db 0xCC                                      ; 0A428  int3
  db 0xCC                                      ; 0A429  int3
  db 0xCC                                      ; 0A42A  int3
  db 0xCC                                      ; 0A42B  int3
  db 0xCC                                      ; 0A42C  int3
  db 0xCC                                      ; 0A42D  int3
  db 0xCC                                      ; 0A42E  int3
  db 0xCC                                      ; 0A42F  int3
  db 0xCC                                      ; 0A430  int3
  db 0xCC                                      ; 0A431  int3
  db 0xCC                                      ; 0A432  int3
  db 0xCC                                      ; 0A433  int3
  db 0xCC                                      ; 0A434  int3
  db 0xCC                                      ; 0A435  int3
  db 0xCC                                      ; 0A436  int3
  db 0xCC                                      ; 0A437  int3
  db 0xCC                                      ; 0A438  int3
  db 0xCC                                      ; 0A439  int3
  db 0xCC                                      ; 0A43A  int3
  db 0xCC                                      ; 0A43B  int3
  db 0xCC                                      ; 0A43C  int3
  db 0xCC                                      ; 0A43D  int3
  db 0xCC                                      ; 0A43E  int3
  db 0xCC                                      ; 0A43F  int3
  db 0xCC                                      ; 0A440  int3
  db 0xCC                                      ; 0A441  int3
  db 0xCC                                      ; 0A442  int3
  db 0xCC                                      ; 0A443  int3
  db 0xCC                                      ; 0A444  int3
  db 0xCC                                      ; 0A445  int3
  db 0xCC                                      ; 0A446  int3
  db 0xCC                                      ; 0A447  int3
  db 0xCC                                      ; 0A448  int3
  db 0xCC                                      ; 0A449  int3
  db 0xCC                                      ; 0A44A  int3
  db 0xCC                                      ; 0A44B  int3
  db 0xCC                                      ; 0A44C  int3
  db 0xCC                                      ; 0A44D  int3
  db 0xCC                                      ; 0A44E  int3
  db 0xCC                                      ; 0A44F  int3
  db 0xCC                                      ; 0A450  int3
  db 0xCC                                      ; 0A451  int3
  db 0xCC                                      ; 0A452  int3
  db 0xCC                                      ; 0A453  int3
  db 0xCC                                      ; 0A454  int3
  db 0xCC                                      ; 0A455  int3
  db 0xCC                                      ; 0A456  int3
  db 0xCC                                      ; 0A457  int3
  db 0xCC                                      ; 0A458  int3
  db 0xCC                                      ; 0A459  int3
  db 0xCC                                      ; 0A45A  int3
  db 0xCC                                      ; 0A45B  int3
  db 0xCC                                      ; 0A45C  int3
  db 0xCC                                      ; 0A45D  int3
  db 0xCC                                      ; 0A45E  int3
  db 0xCC                                      ; 0A45F  int3
  db 0xCC                                      ; 0A460  int3
  db 0xCC                                      ; 0A461  int3
  db 0xCC                                      ; 0A462  int3
  db 0xCC                                      ; 0A463  int3
  db 0xCC                                      ; 0A464  int3
  db 0xCC                                      ; 0A465  int3
  db 0xCC                                      ; 0A466  int3
  db 0xCC                                      ; 0A467  int3
  db 0xCC                                      ; 0A468  int3
  db 0xCC                                      ; 0A469  int3
  db 0xCC                                      ; 0A46A  int3
  db 0xCC                                      ; 0A46B  int3
  db 0xCC                                      ; 0A46C  int3
  db 0xCC                                      ; 0A46D  int3
  db 0xCC                                      ; 0A46E  int3
  db 0xCC                                      ; 0A46F  int3
  db 0xCC                                      ; 0A470  int3
  db 0xCC                                      ; 0A471  int3
  db 0xCC                                      ; 0A472  int3
  db 0xCC                                      ; 0A473  int3
  db 0xCC                                      ; 0A474  int3
  db 0x00, 0x00                                ; 0A475
  db 0x00, 0x00                                ; 0A477
  db 0x00, 0x00                                ; 0A479
  db 0xCC                                      ; 0A47B  int3
  db 0xCC                                      ; 0A47C  int3
  db 0xCC                                      ; 0A47D  int3
  db 0xCC                                      ; 0A47E  int3
  db 0xCC                                      ; 0A47F  int3
  db 0xCC                                      ; 0A480  int3
  db 0xCC                                      ; 0A481  int3
  db 0xCC                                      ; 0A482  int3
  db 0xCC                                      ; 0A483  int3
  db 0xCC                                      ; 0A484  int3
  db 0xCC                                      ; 0A485  int3
  db 0xCC                                      ; 0A486  int3
  db 0xCC                                      ; 0A487  int3
  db 0xCC                                      ; 0A488  int3
  db 0xCC                                      ; 0A489  int3
  db 0xCC                                      ; 0A48A  int3
  db 0xCC                                      ; 0A48B  int3
  db 0xCC                                      ; 0A48C  int3
  db 0xCC                                      ; 0A48D  int3
  db 0xCC                                      ; 0A48E  int3
  db 0xCC                                      ; 0A48F  int3
  db 0xCC                                      ; 0A490  int3
  db 0xCC                                      ; 0A491  int3
  db 0xCC                                      ; 0A492  int3
  db 0xCC                                      ; 0A493  int3
  db 0xCC                                      ; 0A494  int3
  db 0xCC                                      ; 0A495  int3
  db 0xCC                                      ; 0A496  int3
  db 0xCC                                      ; 0A497  int3
  db 0xCC                                      ; 0A498  int3
  db 0xCC                                      ; 0A499  int3
  db 0xCC                                      ; 0A49A  int3
  db 0xCC                                      ; 0A49B  int3
  db 0xCC                                      ; 0A49C  int3
  db 0xCC                                      ; 0A49D  int3
  db 0xCC                                      ; 0A49E  int3
  db 0xCC                                      ; 0A49F  int3
  db 0xCC                                      ; 0A4A0  int3
  db 0xCC                                      ; 0A4A1  int3
  db 0xCC                                      ; 0A4A2  int3
  db 0xCC                                      ; 0A4A3  int3
  db 0xCC                                      ; 0A4A4  int3
  db 0xCC                                      ; 0A4A5  int3
  db 0xCC                                      ; 0A4A6  int3
  db 0xCC                                      ; 0A4A7  int3
  db 0xCC                                      ; 0A4A8  int3
  db 0xCC                                      ; 0A4A9  int3
  db 0xCC                                      ; 0A4AA  int3
  db 0xCC                                      ; 0A4AB  int3
  db 0xCC                                      ; 0A4AC  int3
  db 0xCC                                      ; 0A4AD  int3
  db 0xCC                                      ; 0A4AE  int3
  db 0xCC                                      ; 0A4AF  int3
  db 0xCC                                      ; 0A4B0  int3
  db 0xCC                                      ; 0A4B1  int3
  db 0xCC                                      ; 0A4B2  int3
  db 0xCC                                      ; 0A4B3  int3
  db 0xCC                                      ; 0A4B4  int3
  db 0xCC                                      ; 0A4B5  int3
  db 0xCC                                      ; 0A4B6  int3
  db 0xCC                                      ; 0A4B7  int3
  db 0xCC                                      ; 0A4B8  int3
  db 0xCC                                      ; 0A4B9  int3
  db 0xCC                                      ; 0A4BA  int3
  db 0xCC                                      ; 0A4BB  int3
  db 0xCC                                      ; 0A4BC  int3
  db 0xCC                                      ; 0A4BD  int3
  db 0xCC                                      ; 0A4BE  int3
  db 0xCC                                      ; 0A4BF  int3
  db 0xCC                                      ; 0A4C0  int3
  db 0xCC                                      ; 0A4C1  int3
  db 0xCC                                      ; 0A4C2  int3
  db 0xCC                                      ; 0A4C3  int3
  db 0xCC                                      ; 0A4C4  int3
  db 0xCC                                      ; 0A4C5  int3
  db 0xCC                                      ; 0A4C6  int3
  db 0xCC                                      ; 0A4C7  int3
  db 0xCC                                      ; 0A4C8  int3
  db 0xCC                                      ; 0A4C9  int3
  db 0xCC                                      ; 0A4CA  int3
  db 0x00, 0x00                                ; 0A4CB
  db 0x00, 0x00                                ; 0A4CD
  db 0x00, 0x00                                ; 0A4CF
  db 0x00, 0x00                                ; 0A4D1
  db 0x00, 0x00                                ; 0A4D3
  db 0x00, 0x00                                ; 0A4D5
  db 0x00, 0x00                                ; 0A4D7
  db 0x00, 0x00                                ; 0A4D9
  db 0x00, 0x00                                ; 0A4DB
  db 0x00, 0x00                                ; 0A4DD
  db 0x00, 0x00                                ; 0A4DF
  db 0x00, 0x00                                ; 0A4E1
  db 0x00, 0x00                                ; 0A4E3
  db 0x00, 0x00                                ; 0A4E5
  db 0x00, 0x00                                ; 0A4E7
  db 0x00, 0x82, 0x3A, 0x00                    ; 0A4E9  add byte [bp + si + 0x3a], al
  db 0x00, 0x00                                ; 0A4ED
  add [bp + di - 0x3dc5], dh                   ; 0A4EF  0x00, 0xB3, 0x3B, 0xC2
  cmp ax, [bx + si]                            ; 0A4F3  0x3B, 0x00
  db 0x00, 0x00                                ; 0A4F5
  db 0x00, 0x00                                ; 0A4F7
  db 0x00, 0x00                                ; 0A4F9
  db 0x00, 0x00                                ; 0A4FB
  db 0x00, 0x82, 0x3A, 0x00                    ; 0A4FD  add byte [bp + si + 0x3a], al
  db 0x00, 0x00                                ; 0A501
  add [bp + di - 0x3dc5], dh                   ; 0A503  0x00, 0xB3, 0x3B, 0xC2
  cmp ax, [bx + si]                            ; 0A507  0x3B, 0x00
  db 0x00, 0x00                                ; 0A509
  db 0x00, 0x00                                ; 0A50B
  db 0x00, 0x00                                ; 0A50D
  db 0x00, 0x00                                ; 0A50F
  db 0x00, 0x00                                ; 0A511
  db 0x00, 0x00                                ; 0A513
  db 0x00, 0x00                                ; 0A515
  db 0x00, 0x00                                ; 0A517
  db 0x00, 0x00                                ; 0A519
  db 0x00, 0x00                                ; 0A51B
  db 0x00, 0x00                                ; 0A51D
  db 0x00, 0x00                                ; 0A51F
  db 0x00, 0x00                                ; 0A521
  db 0x00, 0x00                                ; 0A523
  db 0x00, 0x00                                ; 0A525
  db 0x00, 0x00                                ; 0A527
  db 0x00, 0x00                                ; 0A529
  db 0x00, 0x00                                ; 0A52B
  db 0x00, 0x00                                ; 0A52D
  db 0x00, 0x00                                ; 0A52F
  db 0x00, 0x00                                ; 0A531
  db 0x00, 0x00                                ; 0A533
  db 0x00, 0x00                                ; 0A535
  db 0x00, 0x00                                ; 0A537
  db 0x00, 0x00                                ; 0A539
  db 0x00, 0x00                                ; 0A53B
  db 0x00, 0x00                                ; 0A53D
  db 0x00, 0x00                                ; 0A53F
  db 0x00, 0x00                                ; 0A541
  db 0x00, 0x00                                ; 0A543
  db 0x00, 0x00                                ; 0A545
  db 0x00, 0x00                                ; 0A547
  db 0x00, 0x00                                ; 0A549
  db 0x00, 0x00                                ; 0A54B
  db 0x00, 0x00                                ; 0A54D
  db 0x00, 0x00                                ; 0A54F
  db 0x00, 0x00                                ; 0A551
  db 0x00, 0x00                                ; 0A553
  db 0x00, 0x00                                ; 0A555
  db 0x00, 0x00                                ; 0A557
  db 0x00, 0x00                                ; 0A559
  db 0x00, 0x00                                ; 0A55B
  db 0x00, 0x00                                ; 0A55D
  db 0x00, 0x00                                ; 0A55F
  db 0x00, 0x00                                ; 0A561
  db 0x00, 0x00                                ; 0A563
  db 0x00, 0x00                                ; 0A565
  db 0x00, 0x00                                ; 0A567
  db 0x00, 0x00                                ; 0A569
  db 0x00, 0x00                                ; 0A56B
  db 0x00, 0x00                                ; 0A56D
  db 0x00, 0x00                                ; 0A56F
  db 0x00, 0x00                                ; 0A571
  db 0x00, 0x00                                ; 0A573
  db 0x00, 0x00                                ; 0A575
  db 0x00, 0x00                                ; 0A577
  db 0x00, 0x00                                ; 0A579
  db 0x00, 0x00                                ; 0A57B
  db 0x00, 0x00                                ; 0A57D
  db 0x00, 0x00                                ; 0A57F
  db 0x00, 0x00                                ; 0A581
  db 0x00, 0x00                                ; 0A583
  db 0x00, 0x00                                ; 0A585
  db 0x00, 0x00                                ; 0A587
  db 0x00, 0x00                                ; 0A589
  db 0x00, 0x00                                ; 0A58B
  db 0x00, 0x00                                ; 0A58D
  db 0x00, 0x00                                ; 0A58F
  db 0x00, 0x00                                ; 0A591
  db 0x00, 0x00                                ; 0A593
  db 0x00, 0x00                                ; 0A595
  db 0x00, 0x00                                ; 0A597
  db 0x00, 0x00                                ; 0A599
  db 0x00, 0x00                                ; 0A59B
  db 0x00, 0x00                                ; 0A59D
  db 0x00, 0x00                                ; 0A59F
  db 0x00, 0x00                                ; 0A5A1
  db 0x00, 0x00                                ; 0A5A3
  db 0x00, 0x00                                ; 0A5A5
  db 0x00, 0x00                                ; 0A5A7
  db 0x00, 0x00                                ; 0A5A9
  db 0x00, 0x00                                ; 0A5AB
  db 0x00, 0x00                                ; 0A5AD
  db 0x00, 0x00                                ; 0A5AF
  db 0x00, 0x00                                ; 0A5B1
  db 0x00, 0x00                                ; 0A5B3
  db 0x00, 0x00                                ; 0A5B5
  db 0x00, 0x00                                ; 0A5B7
  db 0x00, 0x00                                ; 0A5B9
  db 0x00, 0x00                                ; 0A5BB
  db 0x00, 0x00                                ; 0A5BD
  db 0x00, 0x00                                ; 0A5BF
  db 0x00, 0x00                                ; 0A5C1
  db 0x00, 0x00                                ; 0A5C3
  db 0x00, 0x00                                ; 0A5C5
  db 0x00, 0x00                                ; 0A5C7
  db 0x00, 0x00                                ; 0A5C9
  db 0x00, 0x00                                ; 0A5CB
  db 0x00, 0x00                                ; 0A5CD
  db 0x00, 0x00                                ; 0A5CF
  db 0x00, 0x00                                ; 0A5D1
  db 0x00, 0x00                                ; 0A5D3
  db 0x00, 0x00                                ; 0A5D5
  db 0x00, 0x00                                ; 0A5D7
  add [bx + 0x3b], bl                          ; 0A5D9  0x00, 0x5F, 0x3B
  db 0x00, 0x00                                ; 0A5DC
  db 0x00, 0x00                                ; 0A5DE
  mov bl, 0x3b                                 ; 0A5E0  0xB3, 0x3B
  ret 0x3b                                     ; 0A5E2  0xC2, 0x3B, 0x00
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00  ; 0A5E5  ................
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00  ; 0A5F5  ................
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00  ; 0A605  ................
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00  ; 0A615  .............
  or [bx + si], al                             ; 0A622  0x08, 0x00
  add al, 0xf                                  ; 0A624  0x04, 0x0F
  add [bx + 2], dl                             ; 0A626  0x00, 0x57, 0x02
  inc word [bx + di]                           ; 0A629  0xFF, 0x01
  inc word [bx + si]                           ; 0A62B  0xFF, 0x00
  db 0x80, 0x80, 0x04, 0x00, 0x03              ; 0A62D  add byte [bx + si + 4], 3
  pop es                                       ; 0A632  0x07
  or [bx + si], al                             ; 0A633  0x08, 0x00
  add al, 0xf                                  ; 0A635  0x04, 0x0F
  add [bx + 2], dl                             ; 0A637  0x00, 0x57, 0x02
  inc word [bx + di]                           ; 0A63A  0xFF, 0x01
  inc word [bx + si]                           ; 0A63C  0xFF, 0x00
  db 0x80, 0x80, 0x04, 0x00, 0x03              ; 0A63E  add byte [bx + si + 4], 3
  pop es                                       ; 0A643  0x07
  adc al, [bx + si]                            ; 0A644  0x12, 0x00
  add ax, 0x11f                                ; 0A646  0x05, 0x1F, 0x01
  mov al, 0xa                                  ; 0A649  0xB0, 0x0A
  inc word [si]                                ; 0A64B  0xFF, 0x04
  db 0xFF, 0xC0                                ; 0A64D  inc ax
  db 0x00, 0x80, 0x04, 0x00                    ; 0A64F  add byte [bx + si + 4], al
  add al, [bp + di]                            ; 0A653  0x02, 0x03
  adc al, [bx + si]                            ; 0A655  0x12, 0x00
  add ax, strict word 0x1f                     ; 0A657  05 1F 00
  mov al, 0xa                                  ; 0A65A  0xB0, 0x0A
  inc word [si]                                ; 0A65C  0xFF, 0x04
  db 0xFF, 0xC0                                ; 0A65E  inc ax
  db 0x00, 0x80, 0x04, 0x00                    ; 0A660  add byte [bx + si + 4], al
  add al, [bp + di]                            ; 0A664  0x02, 0x03
  db 0x00, 0x00                                ; 0A666
  db 0x00, 0x00                                ; 0A668
  db 0x00, 0x00                                ; 0A66A
  db 0x00, 0x00                                ; 0A66C
  db 0x00, 0x00                                ; 0A66E
  db 0x00, 0x00                                ; 0A670
  db 0x00, 0x00                                ; 0A672
  db 0x00, 0x00                                ; 0A674
  db 0x00, 0x00                                ; 0A676
  db 0x00, 0x00                                ; 0A678
  db 0x00, 0x00                                ; 0A67A
  db 0x00, 0x00                                ; 0A67C
  db 0x00, 0x00                                ; 0A67E
  db 0x00, 0x00                                ; 0A680
  db 0x00, 0x00                                ; 0A682
  db 0x00, 0x00                                ; 0A684
  db 0x00, 0x00                                ; 0A686
  db 0x00, 0x00                                ; 0A688
  db 0x00, 0x00                                ; 0A68A
  db 0x00, 0x00                                ; 0A68C
  db 0x00, 0x00                                ; 0A68E
  db 0x00, 0x00                                ; 0A690
  db 0x00, 0x00                                ; 0A692
  db 0x00, 0x00                                ; 0A694
  db 0x00, 0x00                                ; 0A696
  db 0x00, 0x00                                ; 0A698
  db 0x00, 0x00                                ; 0A69A
  db 0x00, 0x00                                ; 0A69C
  db 0x00, 0x00                                ; 0A69E
  db 0x00, 0x00                                ; 0A6A0
  db 0x00, 0x00                                ; 0A6A2
  db 0x00, 0x00                                ; 0A6A4
  db 0x00, 0x00                                ; 0A6A6
  db 0x00, 0x00                                ; 0A6A8
  db 0x00, 0x00                                ; 0A6AA
  db 0x00, 0x00                                ; 0A6AC
  db 0x00, 0x00                                ; 0A6AE
  db 0x00, 0x00                                ; 0A6B0
  db 0x00, 0x00                                ; 0A6B2
  db 0x00, 0x00                                ; 0A6B4
  db 0x00, 0x00                                ; 0A6B6
  db 0x00, 0x00                                ; 0A6B8
  db 0x00, 0x00                                ; 0A6BA
  db 0x00, 0x00                                ; 0A6BC
  db 0x00, 0x00                                ; 0A6BE
  db 0x00, 0x00                                ; 0A6C0
  db 0x00, 0x00                                ; 0A6C2
  db 0x00, 0x00                                ; 0A6C4
  db 0x00, 0x00                                ; 0A6C6
  db 0x00, 0x00                                ; 0A6C8
  db 0x00, 0x00                                ; 0A6CA
  db 0x00, 0x00                                ; 0A6CC
  db 0x00, 0x00                                ; 0A6CE
  db 0x00, 0x00                                ; 0A6D0
  db 0x00, 0x00                                ; 0A6D2
  db 0x00, 0x00                                ; 0A6D4
  db 0x00, 0x00                                ; 0A6D6
  db 0x00, 0x00                                ; 0A6D8
  db 0x00, 0x00                                ; 0A6DA
  db 0x00, 0x00                                ; 0A6DC
  db 0x00, 0x00                                ; 0A6DE
  db 0x00, 0x00                                ; 0A6E0
  db 0x00, 0x00                                ; 0A6E2
  db 0x00, 0x00                                ; 0A6E4
  db 0x00, 0x00                                ; 0A6E6
  db 0x00, 0x00                                ; 0A6E8
  db 0x00, 0x00                                ; 0A6EA
  db 0x00, 0x00                                ; 0A6EC
  db 0x00, 0x00                                ; 0A6EE
  db 0x00, 0x00                                ; 0A6F0
  db 0x00, 0x00                                ; 0A6F2
  db 0x00, 0x00                                ; 0A6F4
  db 0x00, 0x00                                ; 0A6F6
  db 0x00, 0x00                                ; 0A6F8
  db 0x00, 0x00                                ; 0A6FA
  db 0x00, 0x00                                ; 0A6FC
  add [bx + si], cl                            ; 0A6FE  0x00, 0x08
  add [bp + di], al                            ; 0A700  0x00, 0x03
  pop es                                       ; 0A702  0x07
  db 0x00, 0x00                                ; 0A703
  add [bx], bh                                 ; 0A705  0x00, 0x3F
  add al, al                                   ; 0A707  0x00, 0xC0
  db 0x00, 0x00                                ; 0A709
  db 0x00, 0x00                                ; 0A70B
  db 0x00, 0x00                                ; 0A70D
  db 0x00, 0x00                                ; 0A70F
  db 0x00, 0x00                                ; 0A711
  db 0x00, 0x00                                ; 0A713
  db 0x00, 0x00                                ; 0A715
  db 0x00, 0x00                                ; 0A717
  db 0x00, 0x00                                ; 0A719
  db 0x00, 0x00                                ; 0A71B
  db 0x00, 0x00                                ; 0A71D
  db 0x00, 0x00                                ; 0A71F
  db 0x00, 0x00                                ; 0A721
  db 0x00, 0x00                                ; 0A723
  db 0x00, 0x00                                ; 0A725
  db 0x00, 0x00                                ; 0A727
  db 0x00, 0x00                                ; 0A729
  db 0x00, 0x00                                ; 0A72B
  db 0x00, 0x00                                ; 0A72D
  db 0x00, 0x00                                ; 0A72F
  db 0x00, 0x00                                ; 0A731
  db 0x00, 0x00                                ; 0A733
  db 0x00, 0x00                                ; 0A735
  db 0x00, 0x00                                ; 0A737
  db 0x00, 0x00                                ; 0A739
  db 0x00, 0x00                                ; 0A73B
  db 0x00, 0x00                                ; 0A73D
  db 0x00, 0x00                                ; 0A73F
  db 0x00, 0x00                                ; 0A741
  db 0x00, 0x00                                ; 0A743
  db 0x00, 0x00                                ; 0A745
  db 0x00, 0x00                                ; 0A747
  db 0x00, 0x00                                ; 0A749
  db 0x00, 0x00                                ; 0A74B
  db 0x00, 0x00                                ; 0A74D
  db 0x00, 0x00                                ; 0A74F
  db 0x00, 0x00                                ; 0A751
  db 0x00, 0x00                                ; 0A753
  db 0x00, 0x00                                ; 0A755
  db 0x00, 0x00                                ; 0A757
  db 0x00, 0x00                                ; 0A759
  db 0x00, 0x00                                ; 0A75B
  db 0x00, 0x00                                ; 0A75D
  db 0x00, 0x00                                ; 0A75F
  db 0x00, 0x00                                ; 0A761
  db 0x00, 0x00                                ; 0A763
  db 0x00, 0x00                                ; 0A765
  db 0x00, 0x00                                ; 0A767
  db 0x00, 0x00                                ; 0A769
  db 0x00, 0x00                                ; 0A76B
  db 0x00, 0x00                                ; 0A76D
  db 0x00, 0x00                                ; 0A76F
  mov es, [cs:0x3c4a]                          ; 0A771  0x2E, 0x8E, 0x06, 0x4A, 0x3C
  db 0x26, 0xC7, 0x06, 0x08, 0x00, 0x4C, 0x3C  ; 0A776  mov word [es:8], 0x3c4c
  mov [cs:0x3c46], ds                          ; 0A77D  0x2E, 0x8C, 0x1E, 0x46, 0x3C
  mov [cs:0x3c48], bx                          ; 0A782  0x2E, 0x89, 0x1E, 0x48, 0x3C
  db 0x33, 0xDB                                ; 0A787  xor bx, bx
  mov ds, bx                                   ; 0A789  0x8E, 0xDB
  mov bx, 0x200                                ; 0A78B  0xBB, 0x00, 0x02
  mov [bx], ax                                 ; 0A78E  0x89, 0x07
  mov [bx + 2], dx                             ; 0A790  0x89, 0x57, 0x02
  mov [bx + 4], cx                             ; 0A793  0x89, 0x4F, 0x04
  mov cx, 0xa                                  ; 0A796  0xB9, 0x0A, 0x00

loc_0A799:                                     ; 0A799
  push cx                                      ; 0A799  0x51
  mov cx, 0xffff                               ; 0A79A  0xB9, 0xFF, 0xFF

loc_0A79D:                                     ; 0A79D
  loop loc_0A79D                               ; 0A79D  0xE2, 0xFE
  pop cx                                       ; 0A79F  0x59
  loop loc_0A799                               ; 0A7A0  0xE2, 0xF7
  mov ax, [cs:0x3c48]                          ; 0A7A2  0x2E, 0xA1, 0x48, 0x3C
  mov [bx + 6], ax                             ; 0A7A6  0x89, 0x47, 0x06
  mov [bx + 8], bp                             ; 0A7A9  0x89, 0x6F, 0x08
  mov [bx + 0xa], si                           ; 0A7AC  0x89, 0x77, 0x0A
  mov [bx + 0xc], di                           ; 0A7AF  0x89, 0x7F, 0x0C
  mov [bx + 0xe], sp                           ; 0A7B2  0x89, 0x67, 0x0E
  mov [bx + 0x10], cs                          ; 0A7B5  0x8C, 0x4F, 0x10
  mov ax, [cs:0x3c46]                          ; 0A7B8  0x2E, 0xA1, 0x46, 0x3C
  mov [bx + 0x12], ax                          ; 0A7BC  0x89, 0x47, 0x12
  mov [bx + 0x14], ss                          ; 0A7BF  0x8C, 0x57, 0x14
  mov [bx + 0x16], es                          ; 0A7C2  0x8C, 0x47, 0x16
  pop ax                                       ; 0A7C5  0x58
  mov [bx + 0x18], ax                          ; 0A7C6  0x89, 0x47, 0x18
  pop ax                                       ; 0A7C9  0x58
  mov [bx + 0x1A], ax                          ; 0A7CA  0x89, 0x47, 0x1A
  pop ax                                       ; 0A7CD  0x58
  mov [bx + 0x1C], ax                          ; 0A7CE  0x89, 0x47, 0x1C
  mov byte [0x67], 0x50                        ; 0A7D1  0xC6, 0x06, 0x67, 0x00, 0x50
  mov ds, [cs:0xc06]                           ; 0A7D6  0x2E, 0x8E, 0x1E, 0x06, 0x0C
  mov es, [cs:0xc06]                           ; 0A7DB  0x2E, 0x8E, 0x06, 0x06, 0x0C
  mov bx, 0x5fa4                               ; 0A7E0  0xBB, 0xA4, 0x5F
  jmp near loc_0B24F                           ; 0A7E3  0xE9, 0x69, 0x0A
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00        ; 0A7E6  ......
  iret                                         ; 0A7EC  0xCF
io_auxin:
  mov al, 0x1a                                 ; 0A7ED  0xB0, 0x1A
  ret                                          ; 0A7EF  0xC3
io_auxout:
  ret                                          ; 0A7F0  0xC3

loc_0A7F1:                                     ; 0A7F1
  cmp dl, [cs:0xc12]                           ; 0A7F1  0x2E, 0x3A, 0x16, 0x12, 0x0C
  jb loc_0A7FB                                 ; 0A7F6  0x72, 0x03
  mov al, 0x1a                                 ; 0A7F8  0xB0, 0x1A
  ret                                          ; 0A7FA  0xC3

loc_0A7FB:                                     ; 0A7FB
  db 0x8A, 0xDA                                ; 0A7FB  mov bl, dl
  sub bl, 4                                    ; 0A7FD  0x80, 0xEB, 0x04
  db 0x32, 0xFF                                ; 0A800  xor bh, bh
  shl bx, 1                                    ; 0A802  0xD1, 0xE3
  call word [cs:bx + 0x3c6a]                   ; 0A804  0x2E, 0xFF, 0x97, 0x6A, 0x3C
  ret                                          ; 0A809  0xC3
  mov si, 0xbe3c                               ; 0A80A  0xBE, 0x3C, 0xBE
  cmp al, 0xbd                                 ; 0A80D  0x3C, 0xBD
  cmp al, 0xbd                                 ; 0A80F  0x3C, 0xBD
  cmp al, 0x74                                 ; 0A811  0x3C, 0x74
  cmp al, 0x53                                 ; 0A813  0x3C, 0x53
  push cx                                      ; 0A815  0x51
  mov dx, 0x3cad                               ; 0A816  0xBA, 0xAD, 0x3C
  mov cl, 0x87                                 ; 0A819  0xB1, 0x87
  call rtm_timer_wait2                         ; 0A81B  0xE8, 0xB5, 0xD0
  pop cx                                       ; 0A81E  0x59
  pop bx                                       ; 0A81F  0x5B
  test ax, ax                                  ; 0A820  0x85, 0xC0
  je loc_0A82C                                 ; 0A822  0x74, 0x08
  db 0x2E, 0xC7, 0x06, 0x72, 0x3C, 0xBD, 0x3C  ; 0A824  mov word [cs:0x3c72], 0x3cbd
  ret                                          ; 0A82B  0xC3

loc_0A82C:                                     ; 0A82C
  db 0x2E, 0xC7, 0x06, 0x72, 0x3C, 0x93, 0x3C  ; 0A82C  mov word [cs:0x3c72], 0x3c93
  cmp byte [cs:0x3d92], 0                      ; 0A833  0x2E, 0x80, 0x3E, 0x92, 0x3D, 0x00
  je loc_0A83E                                 ; 0A839  0x74, 0x03
  call sub_0A923                               ; 0A83B  0xE8, 0xE5, 0x00

loc_0A83E:                                     ; 0A83E
  mov cl, 0x89                                 ; 0A83E  0xB1, 0x89
  mov dx, 0x3cad                               ; 0A840  0xBA, 0xAD, 0x3C
  call rtm_timer_wait2                         ; 0A843  0xE8, 0x8D, 0xD0
  mov al, [cs:0x3cab]                          ; 0A846  0x2E, 0xA0, 0xAB, 0x3C
  ret                                          ; 0A84A  0xC3
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00  ; 0A84B  ........
  stosw                                        ; 0A853  0xAB
  cmp al, 0x4e                                 ; 0A854  0x3C, 0x4E
  db 0x65, 0x74, 0x43                          ; 0A856  je 0xa89c
  db 0x6F                                      ; 0A859  outsw
  db 0x6E                                      ; 0A85A  outsb
  dec cx                                       ; 0A85B  0x49
  and bl, al                                   ; 0A85C  0x20, 0xC3
  cli                                          ; 0A85E  0xFA
  call sub_0A8A9                               ; 0A85F  0xE8, 0x47, 0x00
  jne loc_0A870                                ; 0A862  0x75, 0x0C
  push bx                                      ; 0A864  0x53
  or byte [bx + 0x1A], 4                       ; 0A865  0x80, 0x4F, 0x1A, 0x04
  mov dx, [bx + 0x14]                          ; 0A869  0x8B, 0x57, 0x14
  call rtm_timer_wait                          ; 0A86C  0xE8, 0x62, 0xD0
  pop bx                                       ; 0A86F  0x5B

loc_0A870:                                     ; 0A870
  mov ax, [bx + 2]                             ; 0A870  0x8B, 0x47, 0x02
  sub ax, strict word 0xa                      ; 0A873  2D 0A 00
  cmp [bx + 8], ax                             ; 0A876  0x39, 0x47, 0x08
  jne loc_0A88E                                ; 0A879  0x75, 0x13
  cmp byte [bx + 0x1d], 1                      ; 0A87B  0x80, 0x7F, 0x1D, 0x01
  jne loc_0A88E                                ; 0A87F  0x75, 0x0D
  or byte [bx + 0x1b], 0x20                    ; 0A881  0x80, 0x4F, 0x1B, 0x20
  test byte [bx + 0x1b], 1                     ; 0A885  0xF6, 0x47, 0x1B, 0x01
  je loc_0A88E                                 ; 0A889  0x74, 0x03
  call sub_0AA62                               ; 0A88B  0xE8, 0xD4, 0x01

loc_0A88E:                                     ; 0A88E
  mov si, [bx + 4]                             ; 0A88E  0x8B, 0x77, 0x04
  push es                                      ; 0A891  0x06
  mov es, [bx]                                 ; 0A892  0x8E, 0x07
  mov al, [es:si]                              ; 0A894  0x26, 0x8A, 0x04
  pop es                                       ; 0A897  0x07
  mov ah, 0                                    ; 0A898  0xB4, 0x00
  inc word [bx + 4]                            ; 0A89A  0xFF, 0x47, 0x04
  mov dx, [bx + 2]                             ; 0A89D  0x8B, 0x57, 0x02
  dec dx                                       ; 0A8A0  0x4A
  and [bx + 4], dx                             ; 0A8A1  0x21, 0x57, 0x04
  inc word [bx + 8]                            ; 0A8A4  0xFF, 0x47, 0x08
  sti                                          ; 0A8A7  0xFB
  ret                                          ; 0A8A8  0xC3

sub_0A8A9:                                     ; 0A8A9
  cmp dl, 8                                    ; 0A8A9  0x80, 0xFA, 0x08
  je loc_0A8C2                                 ; 0A8AC  0x74, 0x14
  call sub_0ABBD                               ; 0A8AE  0xE8, 0x0C, 0x03
  mov ax, [bx + 2]                             ; 0A8B1  0x8B, 0x47, 0x02
  cmp [bx + 8], ax                             ; 0A8B4  0x39, 0x47, 0x08
  mov ax, 0                                    ; 0A8B7  0xB8, 0x00, 0x00
  je loc_0A8BF                                 ; 0A8BA  0x74, 0x03
  mov ax, 0xff                                 ; 0A8BC  0xB8, 0xFF, 0x00

loc_0A8BF:                                     ; 0A8BF
  db 0x0B, 0xC0                                ; 0A8BF  or ax, ax
  ret                                          ; 0A8C1  0xC3

loc_0A8C2:                                     ; 0A8C2
  ret                                          ; 0A8C2  0xC3
  dec ax                                       ; 0A8C3  0x48
  ret                                          ; 0A8C4  0xC3

loc_0A8C5:                                     ; 0A8C5
  cmp dl, [cs:0xc12]                           ; 0A8C5  0x2E, 0x3A, 0x16, 0x12, 0x0C
  jb loc_0A8CD                                 ; 0A8CA  0x72, 0x01
  ret                                          ; 0A8CC  0xC3

loc_0A8CD:                                     ; 0A8CD
  db 0x8A, 0xDA                                ; 0A8CD  mov bl, dl
  sub bl, 4                                    ; 0A8CF  0x80, 0xEB, 0x04
  db 0x32, 0xFF                                ; 0A8D2  xor bh, bh
  shl bx, 1                                    ; 0A8D4  0xD1, 0xE3
  call word [cs:bx + 0x3d3c]                   ; 0A8D6  0x2E, 0xFF, 0x97, 0x3C, 0x3D
  ret                                          ; 0A8DB  0xC3
  and bh, [0x3e22]                             ; 0A8DC  0x22, 0x3E, 0x22, 0x3E
  inc si                                       ; 0A8E0  0x46
  cmp ax, 0x3d46                               ; 0A8E1  0x3D, 0x46, 0x3D
  inc di                                       ; 0A8E4  0x47
  cmp ax, 0x53c3                               ; 0A8E5  0x3D, 0xC3, 0x53
  push cx                                      ; 0A8E8  0x51
  mov dx, 0x3e12                               ; 0A8E9  0xBA, 0x12, 0x3E
  mov cl, 0x87                                 ; 0A8EC  0xB1, 0x87
  call rtm_timer_wait2                         ; 0A8EE  0xE8, 0xE2, 0xCF
  pop cx                                       ; 0A8F1  0x59
  pop bx                                       ; 0A8F2  0x5B
  test ax, ax                                  ; 0A8F3  0x85, 0xC0
  je loc_0A8FF                                 ; 0A8F5  0x74, 0x08
  db 0x2E, 0xC7, 0x06, 0x44, 0x3D, 0x46, 0x3D  ; 0A8F7  mov word [cs:0x3d44], 0x3d46
  ret                                          ; 0A8FE  0xC3

loc_0A8FF:                                     ; 0A8FF
  db 0x2E, 0xC7, 0x06, 0x44, 0x3D, 0x66, 0x3D  ; 0A8FF  mov word [cs:0x3d44], 0x3d66
  mov bl, [cs:0x3d92]                          ; 0A906  0x2E, 0x8A, 0x1E, 0x92, 0x3D
  db 0x32, 0xFF                                ; 0A90B  xor bh, bh
  mov [cs:bx + 0x3d93], cl                     ; 0A90D  0x2E, 0x88, 0x8F, 0x93, 0x3D
  inc bx                                       ; 0A912  0x43
  mov [cs:0x3d92], bl                          ; 0A913  0x2E, 0x88, 0x1E, 0x92, 0x3D
  cmp cl, 0xd                                  ; 0A918  0x80, 0xF9, 0x0D
  je sub_0A923                                 ; 0A91B  0x74, 0x06
  cmp bx, 0x7f                                 ; 0A91D  0x83, 0xFB, 0x7F
  je sub_0A923                                 ; 0A920  0x74, 0x01
  ret                                          ; 0A922  0xC3

sub_0A923:                                     ; 0A923
  mov dx, 0x3e12                               ; 0A923  0xBA, 0x12, 0x3E
  mov cl, 0x8b                                 ; 0A926  0xB1, 0x8B
  call rtm_timer_wait2                         ; 0A928  0xE8, 0xA8, 0xCF
  mov byte [cs:0x3d92], 0                      ; 0A92B  0x2E, 0xC6, 0x06, 0x92, 0x3D, 0x00
  ret                                          ; 0A931  0xC3
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00  ; 0A932  ................
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00  ; 0A942  ................
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00  ; 0A952  ................
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00  ; 0A962  ................
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00  ; 0A972  ................
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00  ; 0A982  ................
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00  ; 0A992  ................
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00  ; 0A9A2  ................
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00        ; 0A9B2  ......
  xchg dx, ax                                  ; 0A9B8  0x92
  cmp ax, 0x654e                               ; 0A9B9  0x3D, 0x4E, 0x65
  je loc_0AA01                                 ; 0A9BC  0x74, 0x43
  db 0x6F                                      ; 0A9BE  outsw
  db 0x6E                                      ; 0A9BF  outsb
  dec di                                       ; 0A9C0  0x4F
  db 0x20                                      ; 0A9C1

loc_0A9C2:                                     ; 0A9C2
  call sub_0ABBD                               ; 0A9C2  0xE8, 0xF8, 0x01
  pushf                                        ; 0A9C5  0x9C
  cli                                          ; 0A9C6  0xFA
  cmp word [bx + 0x12], 0                      ; 0A9C7  0x83, 0x7F, 0x12, 0x00
  jne loc_0A9DB                                ; 0A9CB  0x75, 0x0E
  push bx                                      ; 0A9CD  0x53
  push cx                                      ; 0A9CE  0x51
  or byte [bx + 0x1b], 4                       ; 0A9CF  0x80, 0x4F, 0x1B, 0x04
  mov dx, [bx + 0x16]                          ; 0A9D3  0x8B, 0x57, 0x16
  call rtm_timer_wait                          ; 0A9D6  0xE8, 0xF8, 0xCE
  pop cx                                       ; 0A9D9  0x59
  pop bx                                       ; 0A9DA  0x5B

loc_0A9DB:                                     ; 0A9DB
  mov si, [bx + 0x10]                          ; 0A9DB  0x8B, 0x77, 0x10
  push es                                      ; 0A9DE  0x06
  mov es, [bx + 0xa]                           ; 0A9DF  0x8E, 0x47, 0x0A
  mov [es:si], cl                              ; 0A9E2  0x26, 0x88, 0x0C
  pop es                                       ; 0A9E5  0x07
  inc word [bx + 0x10]                         ; 0A9E6  0xFF, 0x47, 0x10
  mov ax, [bx + 0xc]                           ; 0A9E9  0x8B, 0x47, 0x0C
  dec ax                                       ; 0A9EC  0x48
  and [bx + 0x10], ax                          ; 0A9ED  0x21, 0x47, 0x10
  dec word [bx + 0x12]                         ; 0A9F0  0xFF, 0x4F, 0x12
  test byte [bx + 0x1b], 1                     ; 0A9F3  0xF6, 0x47, 0x1B, 0x01
  je loc_0A9FC                                 ; 0A9F7  0x74, 0x03
  call sub_0AA62                               ; 0A9F9  0xE8, 0x66, 0x00

loc_0A9FC:                                     ; 0A9FC
  popf                                         ; 0A9FC  0x9D
  ret                                          ; 0A9FD  0xC3
xios_int28_fn_25_reserved:                   ; 0A9FE
  db 0x2E, 0x3A, 0x16                          ; 0A9FE  .:.

loc_0AA01:                                     ; 0AA01
  adc cl, [si]                                 ; 0AA01  0x12, 0x0C
  jae loc_0AA11                                ; 0AA03  0x73, 0x0C
  db 0x8A, 0xDA                                ; 0AA05  mov bl, dl
  sub bl, 4                                    ; 0AA07  0x80, 0xEB, 0x04
  db 0x32, 0xFF                                ; 0AA0A  xor bh, bh
  cmp bx, 2                                    ; 0AA0C  0x83, 0xFB, 0x02
  jb loc_0AA12                                 ; 0AA0F  0x72, 0x01

loc_0AA11:                                     ; 0AA11
  ret                                          ; 0AA11  0xC3

loc_0AA12:                                     ; 0AA12
  call sub_0ABBD                               ; 0AA12  0xE8, 0xA8, 0x01
  pushf                                        ; 0AA15  0x9C
  cli                                          ; 0AA16  0xFA
  mov [bx + 0x1C], cl                          ; 0AA17  0x88, 0x4F, 0x1C
  or byte [bx + 0x1b], 8                       ; 0AA1A  0x80, 0x4F, 0x1B, 0x08
  test byte [bx + 0x1b], 1                     ; 0AA1E  0xF6, 0x47, 0x1B, 0x01
  je loc_0AA27                                 ; 0AA22  0x74, 0x03
  call sub_0AA62                               ; 0AA24  0xE8, 0x3B, 0x00

loc_0AA27:                                     ; 0AA27
  mov dx, [bx + 0x18]                          ; 0AA27  0x8B, 0x57, 0x18
  call rtm_timer_wait                          ; 0AA2A  0xE8, 0xA4, 0xCE
  popf                                         ; 0AA2D  0x9D
  ret                                          ; 0AA2E  0xC3
  call xios_switch_to_priv_stack               ; 0AA2F  0xE8, 0xEB, 0x04
  mov bx, 0x402f                               ; 0AA32  0xBB, 0x2F, 0x40
  jmp short loc_0AA3D                          ; 0AA35  0xEB, 0x06
  call xios_switch_to_priv_stack               ; 0AA37  0xE8, 0xE3, 0x04
  mov bx, 0x4058                               ; 0AA3A  0xBB, 0x58, 0x40

loc_0AA3D:                                     ; 0AA3D
  mov dx, [bx + 0x25]                          ; 0AA3D  0x8B, 0x57, 0x25
  call sub_0ABB5                               ; 0AA40  0xE8, 0x72, 0x01
  call sub_0AA62                               ; 0AA43  0xE8, 0x1C, 0x00
  cmp word [bx + 0x12], 0                      ; 0AA46  0x83, 0x7F, 0x12, 0x00
  je loc_0AA5F                                 ; 0AA4A  0x74, 0x13
  test byte [bx + 0x1b], 4                     ; 0AA4C  0xF6, 0x47, 0x1B, 0x04
  je loc_0AA5F                                 ; 0AA50  0x74, 0x0D
  and byte [bx + 0x1b], 0xfb                   ; 0AA52  0x80, 0x67, 0x1B, 0xFB
  mov dx, [bx + 0x16]                          ; 0AA56  0x8B, 0x57, 0x16
  call rtm_call_helper                         ; 0AA59  0xE8, 0x64, 0xCE
  jmp near loc_0AF3E                           ; 0AA5C  0xE9, 0xDF, 0x04

loc_0AA5F:                                     ; 0AA5F
  jmp near loc_0AF50                           ; 0AA5F  0xE9, 0xEE, 0x04

sub_0AA62:                                     ; 0AA62
  test byte [bx + 0x1b], 8                     ; 0AA62  0xF6, 0x47, 0x1B, 0x08
  je loc_0AA7B                                 ; 0AA66  0x74, 0x13
  mov al, [bx + 0x1C]                          ; 0AA68  0x8A, 0x47, 0x1C
  call sub_0AACF                               ; 0AA6B  0xE8, 0x61, 0x00
  and byte [bx + 0x1b], 0xf7                   ; 0AA6E  0x80, 0x67, 0x1B, 0xF7
  push bx                                      ; 0AA72  0x53
  mov dx, [bx + 0x18]                          ; 0AA73  0x8B, 0x57, 0x18
  call rtm_call_helper                         ; 0AA76  0xE8, 0x47, 0xCE
  pop bx                                       ; 0AA79  0x5B
  ret                                          ; 0AA7A  0xC3

loc_0AA7B:                                     ; 0AA7B
  test byte [bx + 0x1b], 0x10                  ; 0AA7B  0xF6, 0x47, 0x1B, 0x10
  je loc_0AA8B                                 ; 0AA7F  0x74, 0x0A
  mov al, 0x13                                 ; 0AA81  0xB0, 0x13
  call sub_0AACF                               ; 0AA83  0xE8, 0x49, 0x00
  and byte [bx + 0x1b], 0xef                   ; 0AA86  0x80, 0x67, 0x1B, 0xEF
  ret                                          ; 0AA8A  0xC3

loc_0AA8B:                                     ; 0AA8B
  test byte [bx + 0x1b], 0x20                  ; 0AA8B  0xF6, 0x47, 0x1B, 0x20
  je loc_0AA9B                                 ; 0AA8F  0x74, 0x0A
  mov al, 0x11                                 ; 0AA91  0xB0, 0x11
  call sub_0AACF                               ; 0AA93  0xE8, 0x39, 0x00
  and byte [bx + 0x1b], 0xdf                   ; 0AA96  0x80, 0x67, 0x1B, 0xDF
  ret                                          ; 0AA9A  0xC3

loc_0AA9B:                                     ; 0AA9B
  test byte [bx + 0x1b], 2                     ; 0AA9B  0xF6, 0x47, 0x1B, 0x02
  je loc_0AAA6                                 ; 0AA9F  0x74, 0x05
  or byte [bx + 0x1b], 1                       ; 0AAA1  0x80, 0x4F, 0x1B, 0x01
  ret                                          ; 0AAA5  0xC3

loc_0AAA6:                                     ; 0AAA6
  mov ax, [bx + 0x12]                          ; 0AAA6  0x8B, 0x47, 0x12
  cmp ax, [bx + 0xc]                           ; 0AAA9  0x3B, 0x47, 0x0C
  jne loc_0AAB3                                ; 0AAAC  0x75, 0x05
  or byte [bx + 0x1b], 1                       ; 0AAAE  0x80, 0x4F, 0x1B, 0x01
  ret                                          ; 0AAB2  0xC3

loc_0AAB3:                                     ; 0AAB3
  mov si, [bx + 0xe]                           ; 0AAB3  0x8B, 0x77, 0x0E
  push es                                      ; 0AAB6  0x06
  mov es, [bx + 0xa]                           ; 0AAB7  0x8E, 0x47, 0x0A
  mov al, [es:si]                              ; 0AABA  0x26, 0x8A, 0x04
  pop es                                       ; 0AABD  0x07
  inc word [bx + 0xe]                          ; 0AABE  0xFF, 0x47, 0x0E
  mov dx, [bx + 0xc]                           ; 0AAC1  0x8B, 0x57, 0x0C
  dec dx                                       ; 0AAC4  0x4A
  and [bx + 0xe], dx                           ; 0AAC5  0x21, 0x57, 0x0E
  inc word [bx + 0x12]                         ; 0AAC8  0xFF, 0x47, 0x12
  call sub_0AACF                               ; 0AACB  0xE8, 0x01, 0x00
  ret                                          ; 0AACE  0xC3

sub_0AACF:                                     ; 0AACF
  mov dx, [bx + 0x23]                          ; 0AACF  0x8B, 0x57, 0x23
  out dx, al                                   ; 0AAD2  0xEE
  and byte [bx + 0x1b], 0xfe                   ; 0AAD3  0x80, 0x67, 0x1B, 0xFE
  ret                                          ; 0AAD7  0xC3
  call xios_switch_to_priv_stack               ; 0AAD8  0xE8, 0x42, 0x04
  mov bx, 0x402f                               ; 0AADB  0xBB, 0x2F, 0x40
  jmp near loc_0AAE7                           ; 0AADE  0xE9, 0x06, 0x00
  call xios_switch_to_priv_stack               ; 0AAE1  0xE8, 0x39, 0x04
  mov bx, 0x4058                               ; 0AAE4  0xBB, 0x58, 0x40

loc_0AAE7:                                     ; 0AAE7
  mov dx, [bx + 0x27]                          ; 0AAE7  0x8B, 0x57, 0x27
  in al, dx                                    ; 0AAEA  0xEC
  mov [bx + 0x1E], al                          ; 0AAEB  0x88, 0x47, 0x1E
  mov al, 0x10                                 ; 0AAEE  0xB0, 0x10
  out dx, al                                   ; 0AAF0  0xEE

loc_0AAF1:                                     ; 0AAF1
  call sub_0ABB5                               ; 0AAF1  0xE8, 0xC1, 0x00
  jmp near loc_0AF50                           ; 0AAF4  0xE9, 0x59, 0x04
  call xios_switch_to_priv_stack               ; 0AAF7  0xE8, 0x23, 0x04
  mov bx, 0x402f                               ; 0AAFA  0xBB, 0x2F, 0x40
  jmp near loc_0AB06                           ; 0AAFD  0xE9, 0x06, 0x00
  call xios_switch_to_priv_stack               ; 0AB00  0xE8, 0x1A, 0x04
  mov bx, 0x4058                               ; 0AB03  0xBB, 0x58, 0x40

loc_0AB06:                                     ; 0AB06
  mov dx, [bx + 0x23]                          ; 0AB06  0x8B, 0x57, 0x23
  in al, dx                                    ; 0AB09  0xEC
  push ax                                      ; 0AB0A  0x50
  call sub_0ABB5                               ; 0AB0B  0xE8, 0xA7, 0x00
  pop ax                                       ; 0AB0E  0x58
  cmp byte [bx + 0x1d], 1                      ; 0AB0F  0x80, 0x7F, 0x1D, 0x01
  jne loc_0AB5D                                ; 0AB13  0x75, 0x48
  push ax                                      ; 0AB15  0x50
  and ax, strict word 0x7f                     ; 0AB16  25 7F 00
  cmp al, 0x13                                 ; 0AB19  0x3C, 0x13
  pop ax                                       ; 0AB1B  0x58
  jne loc_0AB25                                ; 0AB1C  0x75, 0x07
  or byte [bx + 0x1b], 2                       ; 0AB1E  0x80, 0x4F, 0x1B, 0x02

loc_0AB22:                                     ; 0AB22
  jmp near loc_0AF50                           ; 0AB22  0xE9, 0x2B, 0x04

loc_0AB25:                                     ; 0AB25
  cmp al, 0x11                                 ; 0AB25  0x3C, 0x11
  jne loc_0AB3E                                ; 0AB27  0x75, 0x15
  test byte [bx + 0x1b], 2                     ; 0AB29  0xF6, 0x47, 0x1B, 0x02
  je loc_0AB22                                 ; 0AB2D  0x74, 0xF3
  and byte [bx + 0x1b], 0xfd                   ; 0AB2F  0x80, 0x67, 0x1B, 0xFD
  test byte [bx + 0x1b], 1                     ; 0AB33  0xF6, 0x47, 0x1B, 0x01
  je loc_0AB22                                 ; 0AB37  0x74, 0xE9
  call sub_0AA62                               ; 0AB39  0xE8, 0x26, 0xFF
  jmp short loc_0AB22                          ; 0AB3C  0xEB, 0xE4

loc_0AB3E:                                     ; 0AB3E
  cmp word [bx + 8], 0x21                      ; 0AB3E  0x83, 0x7F, 0x08, 0x21
  jne loc_0AB5D                                ; 0AB42  0x75, 0x19
  or byte [bx + 0x1b], 0x10                    ; 0AB44  0x80, 0x4F, 0x1B, 0x10
  test byte [bx + 0x1b], 1                     ; 0AB48  0xF6, 0x47, 0x1B, 0x01
  je loc_0AB5D                                 ; 0AB4C  0x74, 0x0F
  push ax                                      ; 0AB4E  0x50
  push dx                                      ; 0AB4F  0x52
  mov dx, PORT_ISBX_MCS0_02                    ; 0AB50  0xBA, 0x02, 0x03

loc_0AB53:                                     ; 0AB53
  in al, dx                                    ; 0AB53  0xEC
  and al, 1                                    ; 0AB54  0x24, 0x01
  je loc_0AB53                                 ; 0AB56  0x74, 0xFB
  pop dx                                       ; 0AB58  0x5A
  call sub_0AA62                               ; 0AB59  0xE8, 0x06, 0xFF
  pop ax                                       ; 0AB5C  0x58

loc_0AB5D:                                     ; 0AB5D
  cmp word [bx + 8], 0                         ; 0AB5D  0x83, 0x7F, 0x08, 0x00
  ja loc_0AB6A                                 ; 0AB61  0x77, 0x07
  inc byte [cs:0x10b1]                         ; 0AB63  0x2E, 0xFE, 0x06, 0xB1, 0x10
  jmp short loc_0AB22                          ; 0AB68  0xEB, 0xB8

loc_0AB6A:                                     ; 0AB6A
  mov si, [bx + 6]                             ; 0AB6A  0x8B, 0x77, 0x06
  push es                                      ; 0AB6D  0x06
  mov es, [bx]                                 ; 0AB6E  0x8E, 0x07
  mov [es:si], al                              ; 0AB70  0x26, 0x88, 0x04
  pop es                                       ; 0AB73  0x07
  inc word [bx + 6]                            ; 0AB74  0xFF, 0x47, 0x06
  mov ax, [bx + 2]                             ; 0AB77  0x8B, 0x47, 0x02
  dec ax                                       ; 0AB7A  0x48
  and [bx + 6], ax                             ; 0AB7B  0x21, 0x47, 0x06
  dec word [bx + 8]                            ; 0AB7E  0xFF, 0x4F, 0x08
  test byte [bx + 0x1A], 4                     ; 0AB81  0xF6, 0x47, 0x1A, 0x04
  je loc_0AB22                                 ; 0AB85  0x74, 0x9B
  mov dx, [bx + 0x14]                          ; 0AB87  0x8B, 0x57, 0x14
  push bx                                      ; 0AB8A  0x53
  call rtm_call_helper                         ; 0AB8B  0xE8, 0x32, 0xCD
  pop bx                                       ; 0AB8E  0x5B
  and byte [bx + 0x1A], 0xfb                   ; 0AB8F  0x80, 0x67, 0x1A, 0xFB
  jmp near loc_0AF3E                           ; 0AB93  0xE9, 0xA8, 0x03
  call xios_switch_to_priv_stack               ; 0AB96  0xE8, 0x84, 0x03
  mov bx, 0x402f                               ; 0AB99  0xBB, 0x2F, 0x40
  jmp near loc_0ABA5                           ; 0AB9C  0xE9, 0x06, 0x00
  call xios_switch_to_priv_stack               ; 0AB9F  0xE8, 0x7B, 0x03
  mov bx, 0x4058                               ; 0ABA2  0xBB, 0x58, 0x40

loc_0ABA5:                                     ; 0ABA5
  mov dx, [bx + 0x25]                          ; 0ABA5  0x8B, 0x57, 0x25
  mov al, 1                                    ; 0ABA8  0xB0, 0x01
  out dx, al                                   ; 0ABAA  0xEE
  in al, dx                                    ; 0ABAB  0xEC
  mov [bx + 0x1f], al                          ; 0ABAC  0x88, 0x47, 0x1F
  mov al, 0x30                                 ; 0ABAF  0xB0, 0x30
  out dx, al                                   ; 0ABB1  0xEE
  jmp near loc_0AAF1                           ; 0ABB2  0xE9, 0x3C, 0xFF

sub_0ABB5:                                     ; 0ABB5
  mov dx, PORT_PCB_EOI                         ; 0ABB5  0xBA, 0x22, 0xFF
  mov ax, 0x8000                               ; 0ABB8  0xB8, 0x00, 0x80
  out dx, ax                                   ; 0ABBB  0xEF
  ret                                          ; 0ABBC  0xC3

sub_0ABBD:                                     ; 0ABBD
  mov dx, 2                                    ; 0ABBD  0xBA, 0x02, 0x00
  mov bx, 0x4058                               ; 0ABC0  0xBB, 0x58, 0x40
  ret                                          ; 0ABC3  0xC3

xios_int28_fn_18_reserved:                   ; 0ABC4
sub_0ABC4:                                     ; 0ABC4
  mov bx, 0x4058                               ; 0ABC4  0xBB, 0x58, 0x40
  mov [bx + 0x1d], dl                          ; 0ABC7  0x88, 0x57, 0x1D
  ret                                          ; 0ABCA  0xC3
  db 0x2F                                      ; 0ABCB  das
  inc ax                                       ; 0ABCC  0x40
  pop ax                                       ; 0ABCD  0x58
  inc ax                                       ; 0ABCE  0x40
  db 0x00, 0x00                                ; 0ABCF
  db 0x00, 0x00                                ; 0ABD1
  db 0x00, 0x00                                ; 0ABD3
  db 0x00, 0x00                                ; 0ABD5
  db 0x00, 0x00                                ; 0ABD7
  db 0x00, 0x00                                ; 0ABD9
  db 0x00, 0x00                                ; 0ABDB
  db 0x00, 0x00                                ; 0ABDD
  db 0x00, 0x00                                ; 0ABDF
  db 0x00, 0x00                                ; 0ABE1
  or ax, 0xe00                                 ; 0ABE3  0x0D, 0x00, 0x0E
  add [bx + di], dl                            ; 0ABE6  0x00, 0x11
  add [bx + di], al                            ; 0ABE8  0x00, 0x01
  add [bx + si], ax                            ; 0ABEA  0x01, 0x00
  db 0x00, 0x00                                ; 0ABEC
  add [bx + 0x14], bh                          ; 0ABEE  0x00, 0x7F, 0x14
  add dh, bh                                   ; 0ABF1  0x00, 0xFE
  db 0x02, 0x00                                ; 0ABF3  add al, byte [bx + si]
  add ax, [bx + si]                            ; 0ABF5  0x03, 0x00
  add ax, [bx + si]                            ; 0ABF7  0x03, 0x00
  db 0x00, 0x00                                ; 0ABF9
  db 0x00, 0x00                                ; 0ABFB
  db 0x00, 0x00                                ; 0ABFD
  db 0x00, 0x00                                ; 0ABFF
  db 0x00, 0x00                                ; 0AC01
  db 0x00, 0x00                                ; 0AC03
  db 0x00, 0x00                                ; 0AC05
  db 0x00, 0x00                                ; 0AC07
  db 0x00, 0x00                                ; 0AC09
  add [di], cl                                 ; 0AC0B  0x00, 0x0D
  add [0x1100], cl                             ; 0AC0D  0x00, 0x0E, 0x00, 0x11
  add [bx + di], al                            ; 0AC11  0x00, 0x01
  add [bx + si], ax                            ; 0AC13  0x01, 0x00
  db 0x00, 0x00                                ; 0AC15
  add [bx + 0x14], bh                          ; 0AC17  0x00, 0x7F, 0x14
  db 0x00, 0x00                                ; 0AC1A
  add ax, [bp + si]                            ; 0AC1C  0x03, 0x02
  add ax, [bp + si]                            ; 0AC1E  0x03, 0x02
  db 0x03                                      ; 0AC20
io_poll:                                       ; 0AC21
  cmp dl, 2                                    ; 0AC21  0x80, 0xFA, 0x02
  jne loc_0AC41                                ; 0AC24  0x75, 0x1B
  push dx                                      ; 0AC26  0x52

floppy_ack:                                    ; 0AC27
  mov dx, PORT_PRN_RESERVE                     ; 0AC27  0xBA, 0x92, 0x02
  mov al, 0xff                                 ; 0AC2A  0xB0, 0xFF
  out dx, al                                   ; 0AC2C  0xEE
  in al, dx                                    ; 0AC2D  0xEC
  and al, 0x80                                 ; 0AC2E  0x24, 0x80
  pop dx                                       ; 0AC30  0x5A
  jne loc_0AC3A                                ; 0AC31  0x75, 0x07
  mov al, 0xff                                 ; 0AC33  0xB0, 0xFF
  db 0x8A, 0xD8                                ; 0AC35  mov bl, al
  jmp near loc_0AC5E                           ; 0AC37  0xE9, 0x24, 0x00

loc_0AC3A:                                     ; 0AC3A
  mov al, 0                                    ; 0AC3A  0xB0, 0x00
  db 0x8A, 0xD8                                ; 0AC3C  mov bl, al
  jmp near loc_0AC5E                           ; 0AC3E  0xE9, 0x1D, 0x00

loc_0AC41:                                     ; 0AC41
  cmp dl, 1                                    ; 0AC41  0x80, 0xFA, 0x01
  jne loc_0AC5E                                ; 0AC44  0x75, 0x18
  push dx                                      ; 0AC46  0x52
  mov dx, PORT_FDC_RESERVE                     ; 0AC47  0xBA, 0x8E, 0x02
  mov al, 0xff                                 ; 0AC4A  0xB0, 0xFF
  out dx, al                                   ; 0AC4C  0xEE
  in al, dx                                    ; 0AC4D  0xEC
  and al, 0x80                                 ; 0AC4E  0x24, 0x80
  pop dx                                       ; 0AC50  0x5A
  jne loc_0AC5A                                ; 0AC51  0x75, 0x07
  mov al, 0xff                                 ; 0AC53  0xB0, 0xFF
  db 0x8A, 0xD8                                ; 0AC55  mov bl, al
  jmp near loc_0AC5E                           ; 0AC57  0xE9, 0x04, 0x00

loc_0AC5A:                                     ; 0AC5A
  mov al, 0                                    ; 0AC5A  0xB0, 0x00
  db 0x8A, 0xD8                                ; 0AC5C  mov bl, al

loc_0AC5E:                                     ; 0AC5E
  ret                                          ; 0AC5E  0xC3

io_list:
sub_0AC5F:                                     ; 0AC5F
  push cx                                      ; 0AC5F  0x51
  push dx                                      ; 0AC60  0x52
  call sub_0AD30                               ; 0AC61  0xE8, 0xCC, 0x00
  pop dx                                       ; 0AC64  0x5A
  pop cx                                       ; 0AC65  0x59
  db 0x0B, 0xC0                                ; 0AC66  or ax, ax
  jne loc_0ACA4                                ; 0AC68  0x75, 0x3A
  push ds                                      ; 0AC6A  0x1E
  push es                                      ; 0AC6B  0x06
  push cx                                      ; 0AC6C  0x51
  push dx                                      ; 0AC6D  0x52
  push cs                                      ; 0AC6E  0x0E
  pop ds                                       ; 0AC6F  0x1F
  mov si, [cs:0x68]                            ; 0AC70  0x2E, 0x8B, 0x36, 0x68, 0x00
  mov es, [si + 0x10]                          ; 0AC75  0x8E, 0x44, 0x10
  mov si, 0x4a15                               ; 0AC78  0xBE, 0x15, 0x4A
  call sub_08DF1                               ; 0AC7B  0xE8, 0x73, 0xE1
  pop dx                                       ; 0AC7E  0x5A
  pop cx                                       ; 0AC7F  0x59
  pop es                                       ; 0AC80  0x07
  pop ds                                       ; 0AC81  0x1F
  cmp al, 0x31                                 ; 0AC82  0x3C, 0x31
  je sub_0AC5F                                 ; 0AC84  0x74, 0xD9
  cmp al, 0x32                                 ; 0AC86  0x3C, 0x32
  jne loc_0AC9F                                ; 0AC88  0x75, 0x15
  push ds                                      ; 0AC8A  0x1E
  push es                                      ; 0AC8B  0x06
  push cs                                      ; 0AC8C  0x0E
  pop ds                                       ; 0AC8D  0x1F
  mov bx, [cs:0x68]                            ; 0AC8E  0x2E, 0x8B, 0x1E, 0x68, 0x00
  mov es, [bx + 0x10]                          ; 0AC93  0x8E, 0x47, 0x10
  mov cx, 0x8f                                 ; 0AC96  0xB9, 0x8F, 0x00
  call rtm_timer_wait2                         ; 0AC99  0xE8, 0x37, 0xCC
  pop es                                       ; 0AC9C  0x07
  pop ds                                       ; 0AC9D  0x1F
  ret                                          ; 0AC9E  0xC3

loc_0AC9F:                                     ; 0AC9F
  cmp al, 0x33                                 ; 0AC9F  0x3C, 0x33
  jne sub_0AC5F                                ; 0ACA1  0x75, 0xBC
  ret                                          ; 0ACA3  0xC3

loc_0ACA4:                                     ; 0ACA4
  cmp dl, 0                                    ; 0ACA4  0x80, 0xFA, 0x00
  je loc_0AD12                                 ; 0ACA7  0x74, 0x69
  cmp dl, 2                                    ; 0ACA9  0x80, 0xFA, 0x02
  jne loc_0ACFC                                ; 0ACAC  0x75, 0x4E
  cli                                          ; 0ACAE  0xFA
  cmp byte [cs:0x5e40], 0xff                   ; 0ACAF  0x2E, 0x80, 0x3E, 0x40, 0x5E, 0xFF
  mov byte [cs:0x5e41], 0xa                    ; 0ACB5  0x2E, 0xC6, 0x06, 0x41, 0x5E, 0x0A
  sti                                          ; 0ACBB  0xFB
  je loc_0ACC3                                 ; 0ACBC  0x74, 0x05
  push cx                                      ; 0ACBE  0x51
  call sub_0CA1E                               ; 0ACBF  0xE8, 0x5C, 0x1D
  pop cx                                       ; 0ACC2  0x59

; -----------------------------------------------------------------------------
; Ekstern DPC Parallel Printer Output
; Skriver tegn i CL til PORT_DPC_PRN_DATA (0x28A) og pulser STROBE via PORT_DPC_PRN_CTRL.
; -----------------------------------------------------------------------------
prn_dpc_out:
loc_0ACC3:                                     ; 0ACC3
  mov dx, PORT_DPC_PRN_CTRL                    ; 0ACC3  0xBA, 0x8C, 0x02
  mov al, 8                                    ; 0ACC6  0xB0, 0x08
  out dx, al                                   ; 0ACC8  0xEE
  mov dx, 0x19                                 ; 0ACC9  0xBA, 0x19, 0x00
  push cx                                      ; 0ACCC  0x51
  call rtm_timer_wait                          ; 0ACCD  0xE8, 0x01, 0xCC
  pop cx                                       ; 0ACD0  0x59
  db 0x8A, 0xC1                                ; 0ACD1  mov al, cl
  mov dx, PORT_DPC_PRN_DATA                    ; 0ACD3  0xBA, 0x8A, 0x02
  out dx, al                                   ; 0ACD6  0xEE
  mov al, 0x89                                 ; 0ACD7  0xB0, 0x89
  mov dx, PORT_DPC_PRN_CTRL                    ; 0ACD9  0xBA, 0x8C, 0x02
  out dx, al                                   ; 0ACDC  0xEE
  mov al, 0x88                                 ; 0ACDD  0xB0, 0x88
  out dx, al                                   ; 0ACDF  0xEE
  cli                                          ; 0ACE0  0xFA
  push ds                                      ; 0ACE1  0x1E
  mov ds, [cs:0xc06]                           ; 0ACE2  0x2E, 0x8E, 0x1E, 0x06, 0x0C
  mov bx, 0x4256                               ; 0ACE7  0xBB, 0x56, 0x42
  mov al, [bx + 0x14]                          ; 0ACEA  0x8A, 0x47, 0x14
  cmp al, 5                                    ; 0ACED  0x3C, 0x05
  jae loc_0ACF3                                ; 0ACEF  0x73, 0x02
  mov al, 5                                    ; 0ACF1  0xB0, 0x05

loc_0ACF3:                                     ; 0ACF3
  mov [cs:0x5e41], al                          ; 0ACF3  0x2E, 0xA2, 0x41, 0x5E
  pop ds                                       ; 0ACF7  0x1F
  sti                                          ; 0ACF8  0xFB
  jmp near loc_0AD2F                           ; 0ACF9  0xE9, 0x33, 0x00

loc_0ACFC:                                     ; 0ACFC
  cmp dl, 1                                    ; 0ACFC  0x80, 0xFA, 0x01
  jne loc_0AD2F                                ; 0ACFF  0x75, 0x2E
  mov bx, 0x4256                               ; 0AD01  0xBB, 0x56, 0x42
  mov al, [bx + 0xd]                           ; 0AD04  0x8A, 0x47, 0x0D
  and al, 0xf                                  ; 0AD07  0x24, 0x0F
  cmp al, 1                                    ; 0AD09  0x3C, 0x01
  jne loc_0AD2F                                ; 0AD0B  0x75, 0x22
  mov dl, 5                                    ; 0AD0D  0xB2, 0x05
  jmp near loc_0A9C2                           ; 0AD0F  0xE9, 0xB0, 0xFC

; -----------------------------------------------------------------------------
; Lokal Centronics Parallel Printer Output
; Skriver tegn i CL til PORT_PRN_DATA (0x250) og pulser STROBE lav/høj via PORT_PRN_CTRL.
; -----------------------------------------------------------------------------
prn_centronics_out:
loc_0AD12:                                     ; 0AD12
  mov dx, PORT_PRN_CTRL                        ; 0AD12  0xBA, 0x60, 0x02
  mov al, 8                                    ; 0AD15  0xB0, 0x08
  out dx, al                                   ; 0AD17  0xEE
  mov dx, 0xc                                  ; 0AD18  0xBA, 0x0C, 0x00
  push cx                                      ; 0AD1B  0x51
  call rtm_timer_wait                          ; 0AD1C  0xE8, 0xB2, 0xCB
  pop cx                                       ; 0AD1F  0x59
  db 0x8A, 0xC1                                ; 0AD20  mov al, cl
  mov dx, PORT_PRN_DATA                        ; 0AD22  0xBA, 0x50, 0x02
  out dx, al                                   ; 0AD25  0xEE
  mov al, 0x89                                 ; 0AD26  0xB0, 0x89
  mov dx, PORT_PRN_CTRL                        ; 0AD28  0xBA, 0x60, 0x02
  out dx, al                                   ; 0AD2B  0xEE
  mov al, 0x88                                 ; 0AD2C  0xB0, 0x88
  out dx, al                                   ; 0AD2E  0xEE

loc_0AD2F:                                     ; 0AD2F
  ret                                          ; 0AD2F  0xC3

io_listst:
sub_0AD30:                                     ; 0AD30
  cmp dl, 0                                    ; 0AD30  0x80, 0xFA, 0x00
  je loc_0AD7B                                 ; 0AD33  0x74, 0x46
  cmp dl, 2                                    ; 0AD35  0x80, 0xFA, 0x02
  jne loc_0AD73                                ; 0AD38  0x75, 0x39
  cmp byte [cs:0x5e40], 0xff                   ; 0AD3A  0x2E, 0x80, 0x3E, 0x40, 0x5E, 0xFF
  je floppy_status_check                       ; 0AD40  0x74, 0x22
  mov byte [cs:0x5e45], 0xff                   ; 0AD42  0x2E, 0xC6, 0x06, 0x45, 0x5E, 0xFF
  call sub_0CA1E                               ; 0AD48  0xE8, 0xD3, 0x1C
  cli                                          ; 0AD4B  0xFA
  push ds                                      ; 0AD4C  0x1E
  mov ds, [cs:0xc06]                           ; 0AD4D  0x2E, 0x8E, 0x1E, 0x06, 0x0C
  mov bx, 0x4256                               ; 0AD52  0xBB, 0x56, 0x42
  mov al, [bx + 0x14]                          ; 0AD55  0x8A, 0x47, 0x14
  cmp al, 5                                    ; 0AD58  0x3C, 0x05
  jae loc_0AD5E                                ; 0AD5A  0x73, 0x02
  mov al, 5                                    ; 0AD5C  0xB0, 0x05

loc_0AD5E:                                     ; 0AD5E
  mov [cs:0x5e41], al                          ; 0AD5E  0x2E, 0xA2, 0x41, 0x5E
  pop ds                                       ; 0AD62  0x1F
  sti                                          ; 0AD63  0xFB

floppy_status_check:                           ; 0AD64
  mov dx, PORT_DPC_PRN_CTRL                    ; 0AD64  0xBA, 0x8C, 0x02
  in al, dx                                    ; 0AD67  0xEC
  test al, 0x10                                ; 0AD68  0xA8, 0x10
  jne loc_0AD8B                                ; 0AD6A  0x75, 0x1F
  test al, 8                                   ; 0AD6C  0xA8, 0x08
  je loc_0AD8B                                 ; 0AD6E  0x74, 0x1B
  jmp near loc_0AD87                           ; 0AD70  0xE9, 0x14, 0x00

loc_0AD73:                                     ; 0AD73
  cmp dl, 1                                    ; 0AD73  0x80, 0xFA, 0x01
  jne loc_0AD8B                                ; 0AD76  0x75, 0x13
  jmp near con_status_poll                     ; 0AD78  0xE9, 0x13, 0x00

loc_0AD7B:                                     ; 0AD7B
  mov dx, PORT_PRN_CTRL                        ; 0AD7B  0xBA, 0x60, 0x02
  in al, dx                                    ; 0AD7E  0xEC
  test al, 0x10                                ; 0AD7F  0xA8, 0x10
  jne loc_0AD8B                                ; 0AD81  0x75, 0x08
  test al, 8                                   ; 0AD83  0xA8, 0x08
  je loc_0AD8B                                 ; 0AD85  0x74, 0x04

loc_0AD87:                                     ; 0AD87
  mov ax, 0xffff                               ; 0AD87  0xB8, 0xFF, 0xFF
  ret                                          ; 0AD8A  0xC3

loc_0AD8B:                                     ; 0AD8B
  db 0x33, 0xC0                                ; 0AD8B  xor ax, ax
  ret                                          ; 0AD8D  0xC3

con_status_poll:                               ; 0AD8E
  mov dx, PORT_ISBX_MCS0_02                    ; 0AD8E  0xBA, 0x02, 0x03
  in al, dx                                    ; 0AD91  0xEC
  test al, 0x80                                ; 0AD92  0xA8, 0x80
  mov ax, 0xffff                               ; 0AD94  0xB8, 0xFF, 0xFF
  jne loc_0AD9A                                ; 0AD97  0x75, 0x01
  inc ax                                       ; 0AD99  0x40

loc_0AD9A:                                     ; 0AD9A
  ret                                          ; 0AD9A  0xC3
i_printer:
  call xios_switch_to_priv_stack               ; 0AD9B  0xE8, 0x7F, 0x01
  mov al, 0x80                                 ; 0AD9E  0xB0, 0x80
  mov dx, PORT_PRN_CTRL                        ; 0ADA0  0xBA, 0x60, 0x02
  out dx, al                                   ; 0ADA3  0xEE
  call eoi_helper                              ; 0ADA4  0xE8, 0x6A, 0x01
  mov dx, 0xc                                  ; 0ADA7  0xBA, 0x0C, 0x00
  call rtm_call_helper                         ; 0ADAA  0xE8, 0x13, 0xCB
  jmp near loc_0AF3E                           ; 0ADAD  0xE9, 0x8E, 0x01
  call xios_switch_to_priv_stack               ; 0ADB0  0xE8, 0x6A, 0x01
  mov al, 0x80                                 ; 0ADB3  0xB0, 0x80
  mov dx, PORT_DPC_PRN_CTRL                    ; 0ADB5  0xBA, 0x8C, 0x02
  out dx, al                                   ; 0ADB8  0xEE
  call eoi_helper                              ; 0ADB9  0xE8, 0x55, 0x01
  mov dx, 0x19                                 ; 0ADBC  0xBA, 0x19, 0x00
  call rtm_call_helper                         ; 0ADBF  0xE8, 0xFE, 0xCA
  jmp near loc_0AF3E                           ; 0ADC2  0xE9, 0x79, 0x01
  db 0x00, 0x00                                ; 0ADC5  ..
  add al, 0                                    ; 0ADC7  0x04, 0x00
  db 0x00, 0x80, 0x04, 0x00                    ; 0ADC9  add byte [bx + si + 4], al
  db 0x00, 0x00                                ; 0ADCD
  db 0x00, 0x00                                ; 0ADCF
  db 0x00, 0x00                                ; 0ADD1
  db 0x00, 0x00                                ; 0ADD3
  db 0x00, 0x00                                ; 0ADD5
  add [bx + di], al                            ; 0ADD7  0x00, 0x01
  add [bx + si], ax                            ; 0ADD9  0x01, 0x00
  db 0x00, 0x00                                ; 0ADDB
  db 0x00, 0x00                                ; 0ADDD
  db 0x00, 0x00                                ; 0ADDF
  db 0x00, 0x00                                ; 0ADE1
  db 0x00, 0x00                                ; 0ADE3
  db 0x00, 0x00                                ; 0ADE5
  db 0x00, 0x00                                ; 0ADE7
  db 0x00, 0x00                                ; 0ADE9
  db 0x00, 0x00                                ; 0ADEB
  db 0x00, 0x00                                ; 0ADED
  db 0x00, 0x00                                ; 0ADEF
  db 0x00, 0x00                                ; 0ADF1
  db 0x00, 0x00                                ; 0ADF3
  db 0x00, 0x00                                ; 0ADF5
  db 0x00, 0x00                                ; 0ADF7
  db 0x00, 0x00                                ; 0ADF9
  db 0x00, 0x00                                ; 0ADFB
  db 0x66, 0x00, 0x47, 0xAA                    ; 0ADFD  add byte [bx - 0x56], al
  pop ss                                       ; 0AE01  0x17
  db 0x61                                      ; 0AE02  popa
  db 0x60                                      ; 0AE03  pusha
  inc di                                       ; 0AE04  0x47
  stosb                                        ; 0AE05  0xAA
  pop ss                                       ; 0AE06  0x17
  db 0x61                                      ; 0AE07  popa
  db 0x10, 0xA1, 0x3C, 0x00                    ; 0AE08  adc byte [bx + di + 0x3c], ah
  db 0x00, 0x00                                ; 0AE0C
  db 0x00, 0x00                                ; 0AE0E
  db 0x02, 0x00                                ; 0AE10  add al, byte [bx + si]
  inc word [bx + si]                           ; 0AE12  0xFF, 0x00
  db 0x00, 0x00                                ; 0AE14
  db 0x00, 0x00                                ; 0AE16
  db 0x00, 0x00                                ; 0AE18
  db 0x00, 0x00                                ; 0AE1A
  db 0x00, 0x00                                ; 0AE1C
  db 0x00, 0x00                                ; 0AE1E
  db 0x00, 0x00                                ; 0AE20
  db 0x00, 0x00                                ; 0AE22
  db 0x00, 0x00                                ; 0AE24
  db 0x00, 0x00                                ; 0AE26
  db 0x00, 0x00                                ; 0AE28
  db 0x00, 0x00                                ; 0AE2A
  db 0x00, 0x00                                ; 0AE2C
  db 0x00, 0x00                                ; 0AE2E
  db 0x00, 0x00                                ; 0AE30
  db 0x00, 0x00                                ; 0AE32
  db 0x00, 0x00                                ; 0AE34
  db 0x00, 0x00                                ; 0AE36
  db 0x00, 0x00                                ; 0AE38
  db 0x00, 0x00                                ; 0AE3A
  db 0x00, 0x00                                ; 0AE3C
  db 0x00, 0x00                                ; 0AE3E
  db 0x00, 0x00                                ; 0AE40
  db 0x00, 0x00                                ; 0AE42
  db 0x00, 0x00                                ; 0AE44
  db 0x00, 0x00                                ; 0AE46
  db 0x00, 0x00                                ; 0AE48
  db 0x00, 0x00                                ; 0AE4A
  db 0x00, 0x00                                ; 0AE4C
  db 0x00, 0x00                                ; 0AE4E
  db 0x00, 0x00                                ; 0AE50
  db 0x00, 0x00                                ; 0AE52
  db 0x00, 0x00                                ; 0AE54
  db 0x00, 0x00                                ; 0AE56
  db 0x00, 0x00                                ; 0AE58
  db 0x00, 0x00                                ; 0AE5A
  db 0x00, 0x00                                ; 0AE5C
  db 0x00, 0x00                                ; 0AE5E
  db 0x00, 0x00                                ; 0AE60
  db 0x00, 0x00                                ; 0AE62
  db 0x00, 0x00                                ; 0AE64
  db 0x00, 0x00                                ; 0AE66
  db 0x00, 0x00                                ; 0AE68
  db 0x00, 0x00                                ; 0AE6A
  db 0x00, 0x00                                ; 0AE6C
  db 0x00, 0x00                                ; 0AE6E
  db 0x00, 0x00                                ; 0AE70
  db 0x00, 0x00                                ; 0AE72
  db 0x00, 0x00                                ; 0AE74
xios_int28_fn_03_get_nvram:                  ; 0AE76
  mov es, [cs:0xc06]                           ; 0AE76  0x2E, 0x8E, 0x06, 0x06, 0x0C
  mov si, 0x4256                               ; 0AE7B  0xBE, 0x56, 0x42
  ret                                          ; 0AE7E  0xC3

xios_int28_fn_04_get_autoconfig:             ; 0AE7F
sub_0AE7F:                                     ; 0AE7F
  mov es, [cs:0xc06]                           ; 0AE7F  0x2E, 0x8E, 0x06, 0x06, 0x0C
  mov si, 0x4225                               ; 0AE84  0xBE, 0x25, 0x42
  ret                                          ; 0AE87  0xC3
xios_int28_fn_32_reserved:                   ; 0AE88
  pushf                                        ; 0AE88  0x9C
  cli                                          ; 0AE89  0xFA
  mov [cs:0x4325], dx                          ; 0AE8A  0x2E, 0x89, 0x16, 0x25, 0x43
  mov [cs:0x4327], cx                          ; 0AE8F  0x2E, 0x89, 0x0E, 0x27, 0x43
  popf                                         ; 0AE94  0x9D
  ret                                          ; 0AE95  0xC3
xios_int28_fn_33_reserved:                   ; 0AE96
  pushf                                        ; 0AE96  0x9C
  cli                                          ; 0AE97  0xFA
  mov ax, 0x4324                               ; 0AE98  0xB8, 0x24, 0x43
  mov [cs:0x4325], ax                          ; 0AE9B  0x2E, 0xA3, 0x25, 0x43
  mov [cs:0x4327], cs                          ; 0AE9F  0x2E, 0x8C, 0x0E, 0x27, 0x43
  popf                                         ; 0AEA4  0x9D
  ret                                          ; 0AEA5  0xC3
xios_int28_fn_34_reserved:                   ; 0AEA6
  pushf                                        ; 0AEA6  0x9C
  cli                                          ; 0AEA7  0xFA
  mov [cs:0x4329], dx                          ; 0AEA8  0x2E, 0x89, 0x16, 0x29, 0x43
  mov [cs:0x432b], cx                          ; 0AEAD  0x2E, 0x89, 0x0E, 0x2B, 0x43
  popf                                         ; 0AEB2  0x9D
  ret                                          ; 0AEB3  0xC3
  pushf                                        ; 0AEB4  0x9C
  cli                                          ; 0AEB5  0xFA
  mov ax, 0x4324                               ; 0AEB6  0xB8, 0x24, 0x43
  mov [cs:0x4329], ax                          ; 0AEB9  0x2E, 0xA3, 0x29, 0x43
  mov [cs:0x432b], cs                          ; 0AEBD  0x2E, 0x8C, 0x0E, 0x2B, 0x43
  popf                                         ; 0AEC2  0x9D
  ret                                          ; 0AEC3  0xC3
  retf                                         ; 0AEC4  0xCB
  and al, 0x43                                 ; 0AEC5  0x24, 0x43
  db 0x00, 0x00                                ; 0AEC7
  and al, 0x43                                 ; 0AEC9  0x24, 0x43
  db 0x00, 0x00                                ; 0AECB
i_tick:
  call xios_switch_to_priv_stack               ; 0AECD  0xE8, 0x4D, 0x00
  inc word [cs:0x4426]                         ; 0AED0  0x2E, 0xFF, 0x06, 0x26, 0x44
  jne loc_0AEDC                                ; 0AED5  0x75, 0x05
  inc word [cs:0x4428]                         ; 0AED7  0x2E, 0xFF, 0x06, 0x28, 0x44

; -----------------------------------------------------------------------------
; Realtidsur (RTC) 1-Sekunds Afbrydelsesrutine (IR3 / Vektor 0x8C)
; Drevet af MM58167A:
; - Tæller floppy-motor timer ned (fdc_motor_timeout_tick / sub_09D62).
; - Sender EOI via eoi_helper.
; - Signalerer CCP/M-86 Flag 2 ("Second"), som opdaterer systemtid og tidsstyring.
; -----------------------------------------------------------------------------
rtc_1sec_isr:
loc_0AEDC:                                     ; 0AEDC
  mov byte [cs:0x10b3], 0                      ; 0AEDC  0x2E, 0xC6, 0x06, 0xB3, 0x10, 0x00
  call sub_09588                               ; 0AEE2  0xE8, 0xA3, 0xE6
  call sub_09D62                               ; 0AEE5  0xE8, 0x7A, 0xEE
  call sub_09DC8                               ; 0AEE8  0xE8, 0xDD, 0xEE
  call sub_0CB3C                               ; 0AEEB  0xE8, 0x4E, 0x1C
  mov bx, 0x4225                               ; 0AEEE  0xBB, 0x25, 0x42
  cmp byte [bx + 0xc], 0xff                    ; 0AEF1  0x80, 0x7F, 0x0C, 0xFF
  je loc_0AEFE                                 ; 0AEF5  0x74, 0x07
  mov al, 0x10                                 ; 0AEF7  0xB0, 0x10
  call sub_0AFE6                               ; 0AEF9  0xE8, 0xEA, 0x00
  jmp short loc_0AF05                          ; 0AEFC  0xEB, 0x07

loc_0AEFE:                                     ; 0AEFE
  mov al, 7                                    ; 0AEFE  0xB0, 0x07
  mov ah, 0xc4                                 ; 0AF00  0xB4, 0xC4
  call sub_0AFCA                               ; 0AF02  0xE8, 0xC5, 0x00

loc_0AF05:                                     ; 0AF05
  call eoi_helper                              ; 0AF05  0xE8, 0x09, 0x00
  mov dx, 2                                    ; 0AF08  0xBA, 0x02, 0x00
  call rtm_call_helper                         ; 0AF0B  0xE8, 0xB2, 0xC9
  jmp near loc_0AF50                           ; 0AF0E  0xE9, 0x3F, 0x00

; -----------------------------------------------------------------------------
; Fælles End-Of-Interrupt (EOI) Hjælperutine
; Sender non-specific EOI (0x20) til ekstern Intel 8259A PIC (PORT_PIC_CMD 0x0000)
; og non-specific EOI (0x8000) til 80186 intern ICU (PORT_PCB_EOI 0xFF22).
; -----------------------------------------------------------------------------
eoi_helper:                                    ; 0AF11
  mov al, 0x20                                 ; 0AF11  0xB0, 0x20
  out PORT_PIC_CMD, al                         ; 0AF13  0xE6, 0x00
  mov dx, PORT_PCB_EOI                         ; 0AF15  0xBA, 0x22, 0xFF
  mov ax, 0x8000                               ; 0AF18  0xB8, 0x00, 0x80
  out dx, ax                                   ; 0AF1B  0xEF
  ret                                          ; 0AF1C  0xC3

xios_switch_to_priv_stack:                     ; 0AF1D
  pop word [cs:0x4424]                         ; 0AF1D  0x2E, 0x8F, 0x06, 0x24, 0x44
  mov [cs:0x4420], ss                          ; 0AF22  0x2E, 0x8C, 0x16, 0x20, 0x44
  mov [cs:0x4422], sp                          ; 0AF27  0x2E, 0x89, 0x26, 0x22, 0x44
  push cs                                      ; 0AF2C  0x0E
  pop ss                                       ; 0AF2D  0x17
  mov sp, 0x441e                               ; 0AF2E  0xBC, 0x1E, 0x44
  push ds                                      ; 0AF31  0x1E
  push es                                      ; 0AF32  0x06
  pusha                                        ; 0AF33  60
  mov ds, [cs:0xc06]                           ; 0AF34  0x2E, 0x8E, 0x1E, 0x06, 0x0C
  jmp word [cs:0x4424]                         ; 0AF39  0x2E, 0xFF, 0x26, 0x24, 0x44

loc_0AF3E:                                     ; 0AF3E
  popa                                         ; 0AF3E  61
  pop es                                       ; 0AF3F  0x07
  pop ds                                       ; 0AF40  0x1F
  mov ss, [cs:0x4420]                          ; 0AF41  0x2E, 0x8E, 0x16, 0x20, 0x44
  mov sp, [cs:0x4422]                          ; 0AF46  0x2E, 0x8B, 0x26, 0x22, 0x44
  jmp far [cs:0x38]                            ; 0AF4B  0x2E, 0xFF, 0x2E, 0x38, 0x00

loc_0AF50:                                     ; 0AF50
  popa                                         ; 0AF50  61
  pop es                                       ; 0AF51  0x07
  pop ds                                       ; 0AF52  0x1F
  mov ss, [cs:0x4420]                          ; 0AF53  0x2E, 0x8E, 0x16, 0x20, 0x44
  mov sp, [cs:0x4422]                          ; 0AF58  0x2E, 0x8B, 0x26, 0x22, 0x44
  iret                                         ; 0AF5D  0xCF
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00  ; 0AF5E  ................
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00  ; 0AF6E  ................
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00  ; 0AF7E  ................
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00  ; 0AF8E  ................
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00  ; 0AF9E  ................
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00  ; 0AFAE  ................
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00  ; 0AFBE  ............

sub_0AFCA:                                     ; 0AFCA
  mov dx, PORT_RTC_ADDR                        ; 0AFCA  0xBA, 0x5C, 0x00
  and al, 0x1f                                 ; 0AFCD  0x24, 0x1F
  out dx, al                                   ; 0AFCF  0xEE
  sub dx, 2                                    ; 0AFD0  0x83, 0xEA, 0x02
  xchg ah, al                                  ; 0AFD3  86 E0
  out dx, al                                   ; 0AFD5  0xEE
  xchg ah, al                                  ; 0AFD6  86 E0
  add dx, 2                                    ; 0AFD8  0x83, 0xC2, 0x02
  or al, 0x40                                  ; 0AFDB  0x0C, 0x40
  out dx, al                                   ; 0AFDD  0xEE
  nop                                          ; 0AFDE  0x90
  nop                                          ; 0AFDF  0x90
  nop                                          ; 0AFE0  0x90
  nop                                          ; 0AFE1  0x90
  and al, 0x1f                                 ; 0AFE2  0x24, 0x1F
  out dx, al                                   ; 0AFE4  0xEE
  ret                                          ; 0AFE5  0xC3

sub_0AFE6:                                     ; 0AFE6
  mov dx, PORT_RTC_ADDR                        ; 0AFE6  0xBA, 0x5C, 0x00
  or al, 0x80                                  ; 0AFE9  0x0C, 0x80
  out dx, al                                   ; 0AFEB  0xEE
  or al, 0xa0                                  ; 0AFEC  0x0C, 0xA0
  out dx, al                                   ; 0AFEE  0xEE
  nop                                          ; 0AFEF  0x90
  nop                                          ; 0AFF0  0x90
  nop                                          ; 0AFF1  0x90
  nop                                          ; 0AFF2  0x90
  xchg ah, al                                  ; 0AFF3  86 E0
  in al, dx                                    ; 0AFF5  0xEC
  xchg ah, al                                  ; 0AFF6  86 E0
  and al, 0x9f                                 ; 0AFF8  0x24, 0x9F
  out dx, al                                   ; 0AFFA  0xEE
  xchg ah, al                                  ; 0AFFB  86 E0
  ret                                          ; 0AFFD  0xC3
xios_int28_fn_12_sound:                      ; 0AFFE
  db 0x8A, 0xE2                                ; 0AFFE  mov ah, dl
  in al, PORT_SOUND                            ; 0B000  0xE4, 0x56
  call sub_0B019                               ; 0B002  0xE8, 0x14, 0x00
  db 0x32, 0xC0                                ; 0B005  xor al, al
  out PORT_RTC_ADDR, al                        ; 0B007  0xE6, 0x5C
  call sub_0B019                               ; 0B009  0xE8, 0x0D, 0x00
  xchg ah, al                                  ; 0B00C  86 E0
  out PORT_RTC_DATA, al                        ; 0B00E  0xE6, 0x5A
  call sub_0B019                               ; 0B010  0xE8, 0x06, 0x00
  out PORT_SOUND, al                           ; 0B013  0xE6, 0x56
  call sub_0B019                               ; 0B015  0xE8, 0x01, 0x00
  ret                                          ; 0B018  0xC3

; -----------------------------------------------------------------------------
; Bus-Genopretningsforsinkelse for langsomme NMOS/CMOS periferikredsløb
; (MM58167A RTC og SN76494 lydgenerator kræver settling time mellem I/O-adgange).
; -----------------------------------------------------------------------------
bus_slow_delay:
sub_0B019:                                     ; 0B019
  mov cx, 0x1e                                 ; 0B019  0xB9, 0x1E, 0x00

loc_0B01C:                                     ; 0B01C
  loop loc_0B01C                               ; 0B01C  0xE2, 0xFE
  ret                                          ; 0B01E  0xC3
xios_int28_fn_19_timer:                      ; 0B01F
  mov dx, [cs:0x4428]                          ; 0B01F  0x2E, 0x8B, 0x16, 0x28, 0x44
  mov ax, [cs:0x4426]                          ; 0B024  0x2E, 0xA1, 0x26, 0x44
  mov cl, [cs:0x10b3]                          ; 0B028  0x2E, 0x8A, 0x0E, 0xB3, 0x10
  db 0x32, 0xED                                ; 0B02D  xor ch, ch
  db 0x8B, 0xD8                                ; 0B02F  mov bx, ax
  ret                                          ; 0B031  0xC3

xios_int28_fn_23_isbx_status:                ; 0B032
con_data_read:                                 ; 0B032
  mov dx, PORT_ISBX_MCS0_02                    ; 0B032  0xBA, 0x02, 0x03
  in al, dx                                    ; 0B035  0xEC
  db 0x8A, 0xD8                                ; 0B036  mov bl, al
  xchg al, ah                                  ; 0B038  86 C4
  db 0x32, 0xC0                                ; 0B03A  xor al, al
  shl ah, 1                                    ; 0B03C  0xD0, 0xE4
  and ah, 0x70                                 ; 0B03E  0x80, 0xE4, 0x70
  test bl, 1                                   ; 0B041  0xF6, 0xC3, 0x01
  je loc_0B048                                 ; 0B044  0x74, 0x02
  or al, 0x20                                  ; 0B046  0x0C, 0x20

loc_0B048:                                     ; 0B048
  test bl, 2                                   ; 0B048  0xF6, 0xC3, 0x02
  je loc_0B04F                                 ; 0B04B  0x74, 0x02
  or al, 1                                     ; 0B04D  0x0C, 0x01

loc_0B04F:                                     ; 0B04F
  test bl, 4                                   ; 0B04F  0xF6, 0xC3, 0x04
  je loc_0B056                                 ; 0B052  0x74, 0x02
  or al, 4                                     ; 0B054  0x0C, 0x04

loc_0B056:                                     ; 0B056
  test bl, 0x80                                ; 0B056  0xF6, 0xC3, 0x80
  je loc_0B05D                                 ; 0B059  0x74, 0x02
  or al, 8                                     ; 0B05B  0x0C, 0x08

loc_0B05D:                                     ; 0B05D
  ret                                          ; 0B05D  0xC3

xios_int28_fn_50_isbx_reset:                 ; 0B05E
sub_0B05E:                                     ; 0B05E
  mov al, 1                                    ; 0B05E  0xB0, 0x01
  call sub_0B06E                               ; 0B060  0xE8, 0x0B, 0x00
  push cs                                      ; 0B063  0x0E
  push di                                      ; 0B064  0x57
  mov ax, 0x18                                 ; 0B065  0xB8, 0x18, 0x00
  int 0x28                                     ; 0B068  0xCD, 0x28
  add sp, 4                                    ; 0B06A  0x83, 0xC4, 0x04
  ret                                          ; 0B06D  0xC3

sub_0B06E:                                     ; 0B06E
  mov di, 0x4573                               ; 0B06E  0xBF, 0x73, 0x45
  mov [di], al                                 ; 0B071  0x88, 0x05
  mov bx, 0x4256                               ; 0B073  0xBB, 0x56, 0x42
  db 0x0A, 0xC0                                ; 0B076  or al, al
  jne loc_0B0C3                                ; 0B078  0x75, 0x49
  mov byte [di + 1], 0                         ; 0B07A  0xC6, 0x45, 0x01, 0x00
  mov byte [di + 2], 0                         ; 0B07E  0xC6, 0x45, 0x02, 0x00
  mov al, [bx + 7]                             ; 0B082  0x8A, 0x47, 0x07
  db 0x8A, 0xE0                                ; 0B085  mov ah, al
  and al, 0xf0                                 ; 0B087  0x24, 0xF0
  mov cl, 4                                    ; 0B089  0xB1, 0x04
  shr al, cl                                   ; 0B08B  0xD2, 0xE8
  mov [di + 3], al                             ; 0B08D  0x88, 0x45, 0x03
  and ah, 0xf                                  ; 0B090  0x80, 0xE4, 0x0F
  mov [di + 4], ah                             ; 0B093  0x88, 0x65, 0x04
  mov byte [di + 5], 4                         ; 0B096  0xC6, 0x45, 0x05, 0x04
  mov byte [di + 6], 4                         ; 0B09A  0xC6, 0x45, 0x06, 0x04
  mov al, [bx + 9]                             ; 0B09E  0x8A, 0x47, 0x09
  mov [di + 7], al                             ; 0B0A1  0x88, 0x45, 0x07
  mov byte [di + 8], 5                         ; 0B0A4  0xC6, 0x45, 0x08, 0x05
  mov al, [bx + 0xa]                           ; 0B0A8  0x8A, 0x47, 0x0A
  mov [di + 9], al                             ; 0B0AB  0x88, 0x45, 0x09
  mov byte [di + 0xa], 1                       ; 0B0AE  0xC6, 0x45, 0x0A, 0x01
  mov al, [bx + 0xb]                           ; 0B0B2  0x8A, 0x47, 0x0B
  mov [di + 0xb], al                           ; 0B0B5  0x88, 0x45, 0x0B
  mov byte [di + 0xc], 3                       ; 0B0B8  0xC6, 0x45, 0x0C, 0x03
  mov al, [bx + 0xc]                           ; 0B0BC  0x8A, 0x47, 0x0C
  mov [di + 0xd], al                           ; 0B0BF  0x88, 0x45, 0x0D
  ret                                          ; 0B0C2  0xC3

loc_0B0C3:                                     ; 0B0C3
  mov al, [bx + 0xd]                           ; 0B0C3  0x8A, 0x47, 0x0D
  db 0x8A, 0xE0                                ; 0B0C6  mov ah, al
  and al, 0xf                                  ; 0B0C8  0x24, 0x0F
  mov [di + 1], al                             ; 0B0CA  0x88, 0x45, 0x01
  mov byte [di + 2], 0                         ; 0B0CD  0xC6, 0x45, 0x02, 0x00
  and ah, 0xf0                                 ; 0B0D1  0x80, 0xE4, 0xF0
  mov cl, 4                                    ; 0B0D4  0xB1, 0x04
  shr ah, cl                                   ; 0B0D6  0xD2, 0xEC
  mov [di + 3], ah                             ; 0B0D8  0x88, 0x65, 0x03
  mov [di + 4], ah                             ; 0B0DB  0x88, 0x65, 0x04
  mov byte [di + 5], 5                         ; 0B0DE  0xC6, 0x45, 0x05, 0x05
  mov byte [di + 6], 4                         ; 0B0E2  0xC6, 0x45, 0x06, 0x04
  mov al, [bx + 0xe]                           ; 0B0E6  0x8A, 0x47, 0x0E
  mov [di + 7], al                             ; 0B0E9  0x88, 0x45, 0x07
  mov byte [di + 8], 5                         ; 0B0EC  0xC6, 0x45, 0x08, 0x05
  mov al, [bx + 0xf]                           ; 0B0F0  0x8A, 0x47, 0x0F
  mov [di + 9], al                             ; 0B0F3  0x88, 0x45, 0x09
  mov byte [di + 0xa], 2                       ; 0B0F6  0xC6, 0x45, 0x0A, 0x02
  mov byte [di + 0xb], 0x40                    ; 0B0FA  0xC6, 0x45, 0x0B, 0x40
  mov byte [di + 0xc], 1                       ; 0B0FE  0xC6, 0x45, 0x0C, 0x01
  mov al, [bx + 0x10]                          ; 0B102  0x8A, 0x47, 0x10
  mov [di + 0xd], al                           ; 0B105  0x88, 0x45, 0x0D
  mov byte [di + 0xe], 3                       ; 0B108  0xC6, 0x45, 0x0E, 0x03
  mov al, [bx + 0x11]                          ; 0B10C  0x8A, 0x47, 0x11
  mov [di + 0xf], al                           ; 0B10F  0x88, 0x45, 0x0F
  ret                                          ; 0B112  0xC3
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00  ; 0B113  ................
xios_int28_fn_24_isbx_init:                  ; 0B123
  push bp                                      ; 0B123  0x55
  db 0x8B, 0xEC                                ; 0B124  mov bp, sp
  add bp, 2                                    ; 0B126  0x83, 0xC5, 0x02
  les di, [bp + 0xa]                           ; 0B129  0xC4, 0x7E, 0x0A
  mov cl, [es:di]                              ; 0B12C  0x26, 0x8A, 0x0D
  mov dl, [es:di + 2]                          ; 0B12F  0x26, 0x8A, 0x55, 0x02
  call sub_0ABC4                               ; 0B133  0xE8, 0x8E, 0xFA
  mov bl, [es:di + 3]                          ; 0B136  0x26, 0x8A, 0x5D, 0x03
  db 0x32, 0xFF                                ; 0B13A  xor bh, bh
  shl bx, 1                                    ; 0B13C  0xD1, 0xE3
  mov ax, [cs:bx + 0x4695]                     ; 0B13E  0x2E, 0x8B, 0x87, 0x95, 0x46
  push ax                                      ; 0B143  0x50
  mov dx, PORT_ISBX_MCS1_06                    ; 0B144  0xBA, 0x16, 0x03
  mov al, 0xb6                                 ; 0B147  0xB0, 0xB6
  out dx, al                                   ; 0B149  0xEE
  pop ax                                       ; 0B14A  0x58
  mov dx, PORT_ISBX_MCS1_04                    ; 0B14B  0xBA, 0x14, 0x03
  out dx, al                                   ; 0B14E  0xEE
  xchg ah, al                                  ; 0B14F  86 E0
  out dx, al                                   ; 0B151  0xEE
  mov cl, [es:di + 5]                          ; 0B152  0x26, 0x8A, 0x4D, 0x05
  db 0x32, 0xED                                ; 0B156  xor ch, ch
  add di, 6                                    ; 0B158  0x83, 0xC7, 0x06
  cmp cx, 0                                    ; 0B15B  0x83, 0xF9, 0x00
  je xios_jmp_entry                            ; 0B15E  0x74, 0x06
  mov bx, 0x4256                               ; 0B160  0xBB, 0x56, 0x42

xios_jmp_init:                                 ; 0B163
  jmp near xios_init                           ; 0B163  0xE9, 0x03, 0x00

xios_jmp_entry:                                ; 0B166
  jmp near xios_entry_0x8C                     ; 0B166  0xE9, 0x86, 0x00

xios_init:                                     ; 0B169
  mov al, [es:di]                              ; 0B169  0x26, 0x8A, 0x05
  inc di                                       ; 0B16C  0x47
  mov ah, [es:di]                              ; 0B16D  0x26, 0x8A, 0x25
  inc di                                       ; 0B170  0x47
  cmp al, 3                                    ; 0B171  0x3C, 0x03
  jne loc_0B17A                                ; 0B173  0x75, 0x05
  mov [bx + 0x11], ah                          ; 0B175  0x88, 0x67, 0x11
  jmp short loc_0B18A                          ; 0B178  0xEB, 0x10

loc_0B17A:                                     ; 0B17A
  cmp al, 4                                    ; 0B17A  0x3C, 0x04
  jne loc_0B183                                ; 0B17C  0x75, 0x05
  mov [bx + 0xe], ah                           ; 0B17E  0x88, 0x67, 0x0E
  jmp short loc_0B18A                          ; 0B181  0xEB, 0x07

loc_0B183:                                     ; 0B183
  cmp al, 5                                    ; 0B183  0x3C, 0x05
  jne loc_0B18A                                ; 0B185  0x75, 0x03
  mov [bx + 0xf], ah                           ; 0B187  0x88, 0x67, 0x0F

loc_0B18A:                                     ; 0B18A
  loop xios_init                               ; 0B18A  0xE2, 0xDD
  mov dx, PORT_ISBX_MCS0_02                    ; 0B18C  0xBA, 0x02, 0x03
  mov al, 2                                    ; 0B18F  0xB0, 0x02
  out dx, al                                   ; 0B191  0xEE
  nop                                          ; 0B192  0x90
  nop                                          ; 0B193  0x90
  nop                                          ; 0B194  0x90
  out dx, al                                   ; 0B195  0xEE
  nop                                          ; 0B196  0x90
  nop                                          ; 0B197  0x90
  nop                                          ; 0B198  0x90
  add al, 0x40                                 ; 0B199  0x04, 0x40
  out dx, al                                   ; 0B19B  0xEE
  push bx                                      ; 0B19C  0x53
  mov al, [bx + 0xe]                           ; 0B19D  0x8A, 0x47, 0x0E
  mov bl, [bx + 0x11]                          ; 0B1A0  0x8A, 0x5F, 0x11
  mov cl, 6                                    ; 0B1A3  0xB1, 0x06
  shr bl, cl                                   ; 0B1A5  0xD2, 0xEB
  cmp bl, 1                                    ; 0B1A7  0x80, 0xFB, 0x01
  je loc_0B1B5                                 ; 0B1AA  0x74, 0x09
  cmp bl, 2                                    ; 0B1AC  0x80, 0xFB, 0x02
  jne loc_0B1B7                                ; 0B1AF  0x75, 0x06
  mov bl, 1                                    ; 0B1B1  0xB3, 0x01
  jmp short loc_0B1B7                          ; 0B1B3  0xEB, 0x02

loc_0B1B5:                                     ; 0B1B5
  mov bl, 2                                    ; 0B1B5  0xB3, 0x02

loc_0B1B7:                                     ; 0B1B7
  mov cl, 2                                    ; 0B1B7  0xB1, 0x02
  shl bl, cl                                   ; 0B1B9  0xD2, 0xE3
  or bl, 2                                     ; 0B1BB  0x80, 0xCB, 0x02
  mov cl, 4                                    ; 0B1BE  0xB1, 0x04
  shl al, cl                                   ; 0B1C0  0xD2, 0xE0
  db 0x0A, 0xC3                                ; 0B1C2  or al, bl
  out dx, al                                   ; 0B1C4  0xEE
  pop bx                                       ; 0B1C5  0x5B
  mov al, [bx + 0x11]                          ; 0B1C6  0x8A, 0x47, 0x11
  mov cl, 2                                    ; 0B1C9  0xB1, 0x02
  shl al, cl                                   ; 0B1CB  0xD2, 0xE0
  mov bl, [bx + 0xf]                           ; 0B1CD  0x8A, 0x5F, 0x0F
  test bl, 0x80                                ; 0B1D0  0xF6, 0xC3, 0x80
  je loc_0B1D7                                 ; 0B1D3  0x74, 0x02
  or al, 2                                     ; 0B1D5  0x0C, 0x02

loc_0B1D7:                                     ; 0B1D7
  test bl, 0x10                                ; 0B1D7  0xF6, 0xC3, 0x10
  je loc_0B1DE                                 ; 0B1DA  0x74, 0x02
  or al, 8                                     ; 0B1DC  0x0C, 0x08

loc_0B1DE:                                     ; 0B1DE
  test bl, 8                                   ; 0B1DE  0xF6, 0xC3, 0x08
  je loc_0B1E5                                 ; 0B1E1  0x74, 0x02
  or al, 1                                     ; 0B1E3  0x0C, 0x01

loc_0B1E5:                                     ; 0B1E5
  test bl, 2                                   ; 0B1E5  0xF6, 0xC3, 0x02
  je loc_0B1EC                                 ; 0B1E8  0x74, 0x02
  or al, 0x20                                  ; 0B1EA  0x0C, 0x20

loc_0B1EC:                                     ; 0B1EC
  or al, 0x10                                  ; 0B1EC  0x0C, 0x10
  out dx, al                                   ; 0B1EE  0xEE

xios_entry_0x8C:                               ; 0B1EF
  pop bp                                       ; 0B1EF  0x5D
  ret                                          ; 0B1F0  0xC3
  test al, 3                                   ; 0B1F1  0xA8, 0x03
  db 0x70, 0x02                                ; 0B1F3  jo 0xb1f7
  stosb                                        ; 0B1F5  0xAA
  add [bx + si], di                            ; 0B1F6  0x01, 0x38
  add [si + 0x4e00], bx                        ; 0B1F8  0x01, 0x9C, 0x00, 0x4E
  add [bx], ah                                 ; 0B1FC  0x00, 0x27
  add [bp + di], dl                            ; 0B1FE  0x00, 0x13
  add [bp + si], cl                            ; 0B200  0x00, 0x0A
  add [di], al                                 ; 0B202  0x00, 0x05
  add [di], al                                 ; 0B204  0x00, 0x05
  add al, ah                                   ; 0B206  0x00, 0xE0
  add al, 0x40                                 ; 0B208  0x04, 0x40
  add di, [bx + si]                            ; 0B20A  0x03, 0x38
  add ah, [bx + si - 0x2fff]                   ; 0B20C  0x02, 0xA0, 0x01, 0xD0
  db 0x00, 0x68, 0x00                          ; 0B210  add byte [bx + si], ch
  xor al, 0                                    ; 0B213  0x34, 0x00
  sbb al, [bx + si]                            ; 0B215  0x1A, 0x00
  or ax, 0x600                                 ; 0B217  0x0D, 0x00, 0x06
  add [bp + di], al                            ; 0B21A  0x00, 0x03
  add [bx + di + 0x46], dl                     ; 0B21C  0x00, 0x51, 0x46
  mov [bp + di], dl                            ; 0B21F  0x88, 0x13
  add ax, 0xe10d                               ; 0B221  0x05, 0x0D, 0xE1
  or [bp + di + 0x4106], al                    ; 0B224  0x08, 0x83, 0x06, 0x41
  add sp, [bx + si - 0x2fff]                   ; 0B228  0x03, 0xA0, 0x01, 0xD0
  db 0x00, 0x68, 0x00                          ; 0B22C  add byte [bx + si], ch
  xor al, 0                                    ; 0B22F  0x34, 0x00
  sbb al, [bx + si]                            ; 0B231  0x1A, 0x00
  or ax, strict word 0                         ; 0B233  0D 00 00
  add al, 0                                    ; 0B236  0x04, 0x00
  add al, 0xba                                 ; 0B238  0x04, 0xBA
  db 0x02, 0x00                                ; 0B23A  add al, byte [bx + si]
  db 0x02, 0x00                                ; 0B23C  add al, byte [bx + si]
  add [bx + si + 0x4000], ax                   ; 0B23E  0x01, 0x80, 0x00, 0x40
  add [bx + si], ah                            ; 0B242  0x00, 0x20
  add [bx + si], dl                            ; 0B244  0x00, 0x10
  add [bx + si], cl                            ; 0B246  0x00, 0x08
  add bl, dh                                   ; 0B248  0x00, 0xF3
  movsb                                        ; 0B24A  0xA4
  iret                                         ; 0B24B  0xCF
  rep movsw                                    ; 0B24C  0xF3, 0xA5
  iret                                         ; 0B24E  0xCF

loc_0B24F:                                     ; 0B24F
  push bx                                      ; 0B24F  0x53
  call far [cs:0x4329]                         ; 0B250  0x2E, 0xFF, 0x1E, 0x29, 0x43
  pop bx                                       ; 0B255  0x5B
  stc                                          ; 0B256  0xF9
  jmp far [cs:0x46bc]                          ; 0B257  0x2E, 0xFF, 0x2E, 0xBC, 0x46
  db 0x00, 0x00, 0xFF                          ; 0B25C  ...
  call far [0x8e2e]                            ; 0B25F  0xFF, 0x1E, 0x2E, 0x8E
  push ds                                      ; 0B263  0x1E
  push es                                      ; 0B264  0x06
  or al, 0x2e                                  ; 0B265  0x0C, 0x2E
  mov [0x4420], ss                             ; 0B267  0x8C, 0x16, 0x20, 0x44
  mov [cs:0x4422], sp                          ; 0B26B  0x2E, 0x89, 0x26, 0x22, 0x44
  mov ss, [cs:0xc06]                           ; 0B270  0x2E, 0x8E, 0x16, 0x06, 0x0C
  mov sp, 0x441e                               ; 0B275  0xBC, 0x1E, 0x44
  push ax                                      ; 0B278  0x50
  push bx                                      ; 0B279  0x53
  push si                                      ; 0B27A  0x56
  db 0x33, 0xC0                                ; 0B27B  xor ax, ax
  call eoi_helper                              ; 0B27D  0xE8, 0x91, 0xFC
  mov bx, [cs:0x8c]                            ; 0B280  0x2E, 0x8B, 0x1E, 0x8C, 0x00
  test bx, bx                                  ; 0B285  0x85, 0xDB
  je loc_0B29D                                 ; 0B287  0x74, 0x14
  mov si, 0x4710                               ; 0B289  0xBE, 0x10, 0x47
  mov al, [si + 2]                             ; 0B28C  0x8A, 0x44, 0x02
  test al, 0x3a                                ; 0B28F  0xA8, 0x3A
  jne loc_0B29D                                ; 0B291  0x75, 0x0A
  and word [bx + 6], strict word 0xfffd        ; 0B293  81 67 06 FD FF
  or word [bx + 6], 0x80                       ; 0B298  0x81, 0x4F, 0x06, 0x80, 0x00

loc_0B29D:                                     ; 0B29D
  mov byte [si + 2], 0                         ; 0B29D  0xC6, 0x44, 0x02, 0x00
  pop si                                       ; 0B2A1  0x5E
  pop bx                                       ; 0B2A2  0x5B
  pop ax                                       ; 0B2A3  0x58
  mov ss, [cs:0x4420]                          ; 0B2A4  0x2E, 0x8E, 0x16, 0x20, 0x44
  mov sp, [cs:0x4422]                          ; 0B2A9  0x2E, 0x8B, 0x26, 0x22, 0x44
  pop ds                                       ; 0B2AE  0x1F
  iret                                         ; 0B2AF  0xCF
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00  ; 0B2B0  ..............
  cli                                          ; 0B2BE  0xFA
  mov ax, cs                                   ; 0B2BF  0x8C, 0xC8
  mov es, ax                                   ; 0B2C1  0x8E, 0xC0
  mov ds, ax                                   ; 0B2C3  0x8E, 0xD8
  mov si, [cs:0x68]                            ; 0B2C5  0x2E, 0x8B, 0x36, 0x68, 0x00
  mov bp, [si + 0x10]                          ; 0B2CA  0x8B, 0x6C, 0x10
  lea si, [si + 8]                             ; 0B2CD  0x8D, 0x74, 0x08
  mov di, 0x477e                               ; 0B2D0  0xBF, 0x7E, 0x47
  mov cx, 4                                    ; 0B2D3  0xB9, 0x04, 0x00
  rep movsw                                    ; 0B2D6  0xF3, 0xA5
  pop ax                                       ; 0B2D8  0x58
  sub ax, strict word 1                        ; 0B2D9  2D 01 00
  mov di, 0x4778                               ; 0B2DC  0xBF, 0x78, 0x47
  call sub_0B330                               ; 0B2DF  0xE8, 0x4E, 0x00
  pop ax                                       ; 0B2E2  0x58
  pop ax                                       ; 0B2E3  0x58
  pop ax                                       ; 0B2E4  0x58
  mov di, 0x478c                               ; 0B2E5  0xBF, 0x8C, 0x47
  call sub_0B330                               ; 0B2E8  0xE8, 0x45, 0x00
  pop ax                                       ; 0B2EB  0x58
  mov di, 0x4787                               ; 0B2EC  0xBF, 0x87, 0x47
  call sub_0B330                               ; 0B2EF  0xE8, 0x3E, 0x00
  mov si, 0x476d                               ; 0B2F2  0xBE, 0x6D, 0x47
  mov es, bp                                   ; 0B2F5  0x8E, 0xC5
  call sub_08DF1                               ; 0B2F7  0xE8, 0xF7, 0xDA
  mov bx, [cs:0x68]                            ; 0B2FA  0x2E, 0x8B, 0x1E, 0x68, 0x00
  and word [bx + 6], 0xfdfd                    ; 0B2FF  0x81, 0x67, 0x06, 0xFD, 0xFD
  mov cx, 0x8f                                 ; 0B304  0xB9, 0x8F, 0x00
  mov dx, 0xffff                               ; 0B307  0xBA, 0xFF, 0xFF
  jmp near rtm_timer_wait2                     ; 0B30A  0xE9, 0xC6, 0xC5
  db 0x22, "Interrupt=                   :    "  ; 0B30D

sub_0B330:                                     ; 0B330
  cld                                          ; 0B330  0xFC
  push ax                                      ; 0B331  0x50
  db 0x8A, 0xC4                                ; 0B332  mov al, ah
  call sub_0B338                               ; 0B334  0xE8, 0x01, 0x00
  pop ax                                       ; 0B337  0x58

sub_0B338:                                     ; 0B338
  push ax                                      ; 0B338  0x50
  mov cl, 4                                    ; 0B339  0xB1, 0x04
  shr al, cl                                   ; 0B33B  0xD2, 0xE8
  call sub_0B341                               ; 0B33D  0xE8, 0x01, 0x00
  pop ax                                       ; 0B340  0x58

sub_0B341:                                     ; 0B341
  and al, 0xf                                  ; 0B341  0x24, 0x0F
  add al, 0x90                                 ; 0B343  0x04, 0x90
  db 0x27                                      ; 0B345  daa
  adc al, 0x40                                 ; 0B346  0x14, 0x40
  db 0x27                                      ; 0B348  daa
  stosb                                        ; 0B349  0xAA
  ret                                          ; 0B34A  0xC3
; =============================================================================
; RC759 Piccoline Skærmtrimning & Diagnostic Menu (0x0B34B - 0x0B4FC)
; =============================================================================
  db 0x14, 0x20, 0xFF, "759 SK", Æ, "RMTRIMNING "  ; 0B34B
  db 0x0C, "Mark", ø, "r Blink"                ; 0B361
  db 0x0C, "Mark", ø, "r H", ø, "jde"          ; 0B36E
  db 0x0C, "Bl", ø, "d Rulning"                ; 0B37B
  db 0x0E, "Standard Farve"                    ; 0B388
  db 0x0E, "Sluk Sk", æ, "rm"                  ; 0B397
  db "    sort   bl", å, "    gr", ø, "n   cyan   r", ø, "d    magentagul    hvid   NEJ JA   Konsol=", 0  ; 0B3A6
  db " ", 0, 0, 0, 0, 0, 0, 0, 0, " ", 0, 0, 0, 0, 0, 0, 0, 0  ; 0B3F1
  db " ", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0  ; 0B403
  db " ", 0, 0, 0, 0, 0, 0, 0, 0, " Skriver=", 0, 0, " ", 0, 0, 0, 0, " 00:00:00 "  ; 0B415
  db "DynamiskBufferetBuffer  L", å, "st    L", Å, "S"  ; 0B434
  times 52 db " "                              ; 0B458
  db "- Tryk p", å, " en tast            "     ; 0B48C
  times 80 db 0                                ; 0B4A9
  db "$ **"                                    ; 0B4F9

; =============================================================================
; RC759 Piccoline XIOS Status- og Fejlbeskeder (0x0B4FD - 0x0B5E0)
; =============================================================================
  db " Venter p", å, " f", æ, "lles diskettestation"  ; 0B4FD
  db 0x1C, " ** Venter p", å, " f", æ, "lles skriver1"  ; 0B521
  db "** Kun 1 konsol - Vinduesstyring ikke installeret"  ; 0B53E
  db 0x15, " ** Skriver ikke klar"             ; 0B570
  db 0x16, " ** Skriver Reserveret"            ; 0B586
  db 0x1A, " ** Grafiksk", æ, "rm reserveret2" ; 0B59D
  db " ** Skriver ikke klar. 1=gentag,2=afbryd,3=ignorer"  ; 0B5B6

; =============================================================================
; RC759 Piccoline Boot Banner & Hardware Rapport (0x0B5E1 - 0x0B79D)
; =============================================================================
  db "PICCOLINE XIOS version 2.3 - Marts 1985 ", 0x0D, 0x0A, 0x0A  ; 0B5E1
  db "      K bytes hoved lager", 0x0D, 0x0A, 0  ; 0B613
  db "      K bytes bruger lager", 0x0D, 0x0A, 0  ; 0B62F
  db "      Diskette station(er)", 0x0D, 0x0A, 0  ; 0B64C
  db "      Winchester disk station(er)", 0x0D, 0x0A, 0  ; 0B669
  db "      Data buffer(e)", 0x0D, 0x0A, 0     ; 0B68D
  db "      Katalog buffer(e)", 0x0D, 0x0A, 0  ; 0B6A4
  db "      K bytes M-disk", 0x0D, 0x0A, 0     ; 0B6BE
  db "  *** For lidt lager til M-disk", 0x0D, 0x0A, 0  ; 0B6DA
  db 0x0D, 0x0A, "Lokalnet adaptor installeret", 0x0D, 0x0A, 0  ; 0B6F7
  db 0x0D, 0x0A, "Numerisk Regneenhed installeret", 0x0D, 0x0A, 0  ; 0B718
  db "Winchester disk  X er ikke initialiseret", 0x0D, 0x0A, 0  ; 0B73A
  db "Winchester disk  x har d", å, "rlig konfigurations sektor", 0x0D, 0x0A, 0  ; 0B765
loc_0B79D:                                     ; 0B79D
  db 0x00, 0x00                                ; 0B79D
  db 0x00, 0x00                                ; 0B79F
  db 0x00, 0x00                                ; 0B7A1
  db 0x00, 0x00                                ; 0B7A3
  db 0x00, 0x00                                ; 0B7A5
  db 0x00, 0x00                                ; 0B7A7
  db 0x00, 0x00                                ; 0B7A9
  db 0x00, 0x00                                ; 0B7AB
  db 0x00, 0x00                                ; 0B7AD
  db 0x00, 0x00                                ; 0B7AF
  db 0x00, 0x00                                ; 0B7B1
  db 0x00, 0x00                                ; 0B7B3
  db 0x00, 0x00                                ; 0B7B5
  db 0x00, 0x00                                ; 0B7B7
  db 0x00, 0x00                                ; 0B7B9
  db 0x00, 0x00                                ; 0B7BB
  db 0x00, 0x00                                ; 0B7BD
  db 0x00, 0x00                                ; 0B7BF
  db 0x00, 0x00                                ; 0B7C1
  db 0x00, 0x00                                ; 0B7C3
  db 0x00, 0x00                                ; 0B7C5
  db 0x00, 0x00                                ; 0B7C7
  db 0x00, 0x00                                ; 0B7C9
  db 0x00, 0x00                                ; 0B7CB
  db 0x00, 0x00                                ; 0B7CD
  db 0x00, 0x00                                ; 0B7CF
  db 0x00, 0x00                                ; 0B7D1
  db 0x00, 0x00                                ; 0B7D3
  db 0x00, 0x00                                ; 0B7D5
  db 0x00, 0x00                                ; 0B7D7
  db 0x00, 0x00                                ; 0B7D9
  db 0x00, 0x00                                ; 0B7DB
  db 0x00, 0x00                                ; 0B7DD
  db 0x00, 0x00                                ; 0B7DF
  db 0x00, 0x00                                ; 0B7E1

loc_0B7E3:                                     ; 0B7E3
  db 0x00, 0x00                                ; 0B7E3
  db 0x00, 0x00                                ; 0B7E5
  db 0x00, 0x00                                ; 0B7E7
  db 0x00, 0x00                                ; 0B7E9
  db 0x00, 0x00                                ; 0B7EB
  db 0x00, 0x00                                ; 0B7ED
  db 0x00, 0x00                                ; 0B7EF
  db 0x00, 0x00                                ; 0B7F1
  db 0x00, 0x00                                ; 0B7F3
  db 0x00, 0x00                                ; 0B7F5
  db 0x00, 0x00                                ; 0B7F7
  db 0x00, 0x00                                ; 0B7F9

loc_0B7FB:                                     ; 0B7FB
  db 0x00, 0x00                                ; 0B7FB
  db 0x00, 0x00                                ; 0B7FD
  db 0x00, 0x00                                ; 0B7FF
  db 0x00, 0x00                                ; 0B801
  db 0x00, 0x00                                ; 0B803
  db 0x00, 0x00                                ; 0B805
  db 0x00, 0x00                                ; 0B807
  db 0x00, 0x00                                ; 0B809
  db 0x00, 0x00                                ; 0B80B
  db 0x00, 0x00                                ; 0B80D
  db 0x00, 0x00                                ; 0B80F
  db 0x00, 0x00                                ; 0B811
  db 0x00, 0x00                                ; 0B813
  db 0x00, 0x00                                ; 0B815
  db 0x00, 0x00                                ; 0B817
  db 0x00, 0x00                                ; 0B819
  db 0x00, 0x00                                ; 0B81B
  db 0x00, 0x00                                ; 0B81D
  db 0x00, 0x00                                ; 0B81F
  db 0x00, 0x00                                ; 0B821
  db 0x00, 0x00                                ; 0B823
  db 0x00, 0x00                                ; 0B825
  db 0x00, 0x00                                ; 0B827
  db 0x00, 0x00                                ; 0B829
  db 0x00, 0x00                                ; 0B82B
  db 0x00, 0x00                                ; 0B82D
  db 0x00, 0x00                                ; 0B82F
  db 0x00, 0x00                                ; 0B831
  db 0x00, 0x00                                ; 0B833
  db 0x00, 0x00                                ; 0B835
  db 0x00, 0x00                                ; 0B837
  db 0x00, 0x00                                ; 0B839
  db 0x00, 0x00                                ; 0B83B
  db 0x00, 0x00                                ; 0B83D
  db 0x00, 0x00                                ; 0B83F
  db 0x00, 0x00                                ; 0B841
  db 0x00, 0x00                                ; 0B843
  db 0x00, 0x00                                ; 0B845
  db 0x00, 0x00                                ; 0B847
  db 0x00, 0x00                                ; 0B849
  db 0x00, 0x00                                ; 0B84B
  db 0x00, 0x00                                ; 0B84D
  db 0x00, 0x00                                ; 0B84F
  db 0x00, 0x00                                ; 0B851
  db 0x00, 0x00                                ; 0B853
  db 0x00, 0x00                                ; 0B855
  db 0x00, 0x00                                ; 0B857
  db 0x00, 0x00                                ; 0B859
  db 0x00, 0x00                                ; 0B85B
  db 0x00, 0x00                                ; 0B85D
  db 0x00, 0x00                                ; 0B85F
  db 0x00, 0x00                                ; 0B861
  db 0x00, 0x00                                ; 0B863
  db 0x00, 0x00                                ; 0B865
  db 0x00, 0x00                                ; 0B867
  db 0x00, 0x00                                ; 0B869
  db 0x00, 0x00                                ; 0B86B
  db 0x00, 0x00                                ; 0B86D
  db 0x00, 0x00                                ; 0B86F
  db 0x00, 0x00                                ; 0B871
  db 0x00, 0x00                                ; 0B873
  db 0x00, 0x00                                ; 0B875
  db 0x00, 0x00                                ; 0B877
  db 0x00, 0x00                                ; 0B879
  db 0x00, 0x00                                ; 0B87B
  db 0x00, 0x00                                ; 0B87D
  db 0x00, 0x00                                ; 0B87F
  db 0x00, 0x00                                ; 0B881
  db 0x00, 0x00                                ; 0B883
  db 0x00, 0x00                                ; 0B885
  db 0x00, 0x00                                ; 0B887
  db 0x00, 0x00                                ; 0B889
  db 0x00, 0x00                                ; 0B88B
  db 0x00, 0x00                                ; 0B88D
  db 0x00, 0x00                                ; 0B88F
  db 0x00, 0x00                                ; 0B891
  db 0x00, 0x00                                ; 0B893
  db 0x00, 0x00                                ; 0B895
  db 0x00, 0x00                                ; 0B897
  db 0x00, 0x00                                ; 0B899
  db 0x00, 0x00                                ; 0B89B
  db 0x00, 0x00                                ; 0B89D
  db 0x00, 0x00                                ; 0B89F
  db 0x00, 0x00                                ; 0B8A1
  db 0x00, 0x00                                ; 0B8A3
  db 0x00, 0x00                                ; 0B8A5
  db 0x00, 0x00                                ; 0B8A7
  db 0x00, 0x00                                ; 0B8A9
  db 0x00, 0x00                                ; 0B8AB
  db 0x00, 0x00                                ; 0B8AD
  db 0x00, 0x00                                ; 0B8AF
  db 0x00, 0x00                                ; 0B8B1
  db 0x00, 0x00                                ; 0B8B3
  db 0x00, 0x00                                ; 0B8B5
  db 0x00, 0x00                                ; 0B8B7
  db 0x00, 0x00                                ; 0B8B9
  db 0x00, 0x00                                ; 0B8BB
  db 0x00, 0x00                                ; 0B8BD
  db 0x00, 0x00                                ; 0B8BF
  db 0x00, 0x00                                ; 0B8C1
  db 0x00, 0x00                                ; 0B8C3
  db 0x00, 0x00                                ; 0B8C5
  db 0x00, 0x00                                ; 0B8C7
  db 0x00, 0x00                                ; 0B8C9
  db 0x00, 0x00                                ; 0B8CB
  db 0x00, 0x00                                ; 0B8CD
  db 0x00, 0x00                                ; 0B8CF
  db 0x00, 0x00                                ; 0B8D1
  db 0x00, 0x00                                ; 0B8D3
  db 0x00, 0x00                                ; 0B8D5
  db 0x00, 0x00                                ; 0B8D7
  db 0x00, 0x00                                ; 0B8D9
  db 0x00, 0x00                                ; 0B8DB
  db 0x00, 0x00                                ; 0B8DD
  db 0x00, 0x00                                ; 0B8DF
  db 0x00, 0x00                                ; 0B8E1
  db 0x00, 0x00                                ; 0B8E3
  db 0x00, 0x00                                ; 0B8E5
  db 0x00, 0x00                                ; 0B8E7
  db 0x00, 0x00                                ; 0B8E9
  db 0x00, 0x00                                ; 0B8EB
  db 0x00, 0x00                                ; 0B8ED
  db 0x00, 0x00                                ; 0B8EF
  db 0x00, 0x00                                ; 0B8F1
  db 0x00, 0x00                                ; 0B8F3
  db 0x00, 0x00                                ; 0B8F5
  db 0x00, 0x00                                ; 0B8F7
  db 0x00, 0x00                                ; 0B8F9
  db 0x00, 0x00                                ; 0B8FB
  db 0x00, 0x00                                ; 0B8FD
  db 0x00, 0x00                                ; 0B8FF
  db 0x00, 0x00                                ; 0B901
  db 0x00, 0x00                                ; 0B903
  db 0x00, 0x00                                ; 0B905
  db 0x00, 0x00                                ; 0B907
  db 0x00, 0x00                                ; 0B909
  db 0x00, 0x00                                ; 0B90B
  db 0x00, 0x00                                ; 0B90D
  db 0x00, 0x00                                ; 0B90F
  db 0x00, 0x00                                ; 0B911
  db 0x00, 0x00                                ; 0B913
  db 0x00, 0x00                                ; 0B915
  db 0x00, 0x00                                ; 0B917
  db 0x00, 0x00                                ; 0B919
  db 0x00, 0x00                                ; 0B91B
  db 0x00, 0x00                                ; 0B91D
  db 0x00, 0x00                                ; 0B91F
  db 0x00, 0x00                                ; 0B921
  db 0x00, 0x00                                ; 0B923
  db 0x00, 0x00                                ; 0B925
  db 0x00, 0x00                                ; 0B927
  db 0x00, 0x00                                ; 0B929
  db 0x00, 0x00                                ; 0B92B
  db 0x00, 0x00                                ; 0B92D
  db 0x00, 0x00                                ; 0B92F
  db 0x00, 0x00                                ; 0B931
  db 0x00, 0x00                                ; 0B933
  db 0x00, 0x00                                ; 0B935
  db 0x00, 0x00                                ; 0B937
  db 0x00, 0x00                                ; 0B939
  db 0x00, 0x00                                ; 0B93B
  db 0x00, 0x00                                ; 0B93D
  db 0x00, 0x00                                ; 0B93F
  db 0x00, 0x00                                ; 0B941
  db 0x00, 0x00                                ; 0B943
  db 0x00, 0x00                                ; 0B945
  db 0x00, 0x00                                ; 0B947
  db 0x00, 0x00                                ; 0B949
  db 0x00, 0x00                                ; 0B94B
  db 0x00, 0x00                                ; 0B94D
  db 0x00, 0x00                                ; 0B94F
  db 0x00, 0x00                                ; 0B951
  db 0x00, 0x00                                ; 0B953
  db 0x00, 0x00                                ; 0B955
  db 0x00, 0x00                                ; 0B957
  db 0x00, 0x00                                ; 0B959
  db 0x00, 0x00                                ; 0B95B
  db 0x00, 0x00                                ; 0B95D
  db 0x00, 0x00                                ; 0B95F
  db 0x00, 0x00                                ; 0B961
  db 0x00, 0x00                                ; 0B963
  db 0x00, 0x00                                ; 0B965
  db 0x00, 0x00                                ; 0B967
  db 0x00, 0x00                                ; 0B969
  db 0x00, 0x00                                ; 0B96B
  db 0x00, 0x00                                ; 0B96D
  db 0x00, 0x00                                ; 0B96F
  db 0x00, 0x00                                ; 0B971
  db 0x00, 0x00                                ; 0B973
  db 0x00, 0x00                                ; 0B975
  db 0x00, 0x00                                ; 0B977
  db 0x00, 0x00                                ; 0B979
  db 0x00, 0x00                                ; 0B97B
  db 0x00, 0x00                                ; 0B97D
  db 0x00, 0x00                                ; 0B97F
  db 0x00, 0x00                                ; 0B981
  db 0x00, 0x00                                ; 0B983
  db 0x00, 0x00                                ; 0B985
  db 0x00, 0x00                                ; 0B987
  db 0x00, 0x00                                ; 0B989
  db 0x00, 0x00                                ; 0B98B
  db 0x00, 0x00                                ; 0B98D
  db 0x00, 0x00                                ; 0B98F

sub_0B991:                                     ; 0B991
  push cs                                      ; 0B991  0x0E
  pop ds                                       ; 0B992  0x1F
  cld                                          ; 0B993  0xFC
  mov bx, 0x4225                               ; 0B994  0xBB, 0x25, 0x42
  mov dx, [bx + 0xa]                           ; 0B997  0x8B, 0x57, 0x0A
  mov cl, 0xc                                  ; 0B99A  0xB1, 0x0C
  shl dx, cl                                   ; 0B99C  0xD3, 0xE2
  mov es, dx                                   ; 0B99E  0x8E, 0xC2
  mov di, [bx + 8]                             ; 0B9A0  0x8B, 0x7F, 0x08
  mov byte [es:di + 1], 5                      ; 0B9A3  0x26, 0xC6, 0x45, 0x01, 0x05
  mov dx, cs                                   ; 0B9A8  0x8C, 0xCA
  mov ax, 0x5fa4                               ; 0B9AA  0xB8, 0xA4, 0x5F
  call sub_09630                               ; 0B9AD  0xE8, 0x80, 0xDC
  add di, 0xe                                  ; 0B9B0  0x83, 0xC7, 0x0E
  stosw                                        ; 0B9B3  0xAB
  db 0x8B, 0xC1                                ; 0B9B4  mov ax, cx
  stosw                                        ; 0B9B6  0xAB

crt_mode_switch:                               ; 0B9B7
  mov dx, PORT_CRT_CA                          ; 0B9B7  0xBA, 0x40, 0x02
  out dx, al                                   ; 0B9BA  0xEE
  push cs                                      ; 0B9BB  0x0E
  pop es                                       ; 0B9BC  0x07
  mov di, 0x5faa                               ; 0B9BD  0xBF, 0xAA, 0x5F
  mov ax, 0x6026                               ; 0B9C0  0xB8, 0x26, 0x60
  call sub_09621                               ; 0B9C3  0xE8, 0x5B, 0xDC
  mov ax, 0x60ae                               ; 0B9C6  0xB8, 0xAE, 0x60
  call sub_09621                               ; 0B9C9  0xE8, 0x55, 0xDC
  mov di, 0x5fc2                               ; 0B9CC  0xBF, 0xC2, 0x5F
  mov ax, 0x5fca                               ; 0B9CF  0xB8, 0xCA, 0x5F
  call sub_09621                               ; 0B9D2  0xE8, 0x4C, 0xDC
  mov ax, 0x6142                               ; 0B9D5  0xB8, 0x42, 0x61
  call sub_09621                               ; 0B9D8  0xE8, 0x46, 0xDC
  mov ax, 0x6136                               ; 0B9DB  0xB8, 0x36, 0x61
  push ax                                      ; 0B9DE  0x50
  mov di, 0x6026                               ; 0B9DF  0xBF, 0x26, 0x60
  call sub_09621                               ; 0B9E2  0xE8, 0x3C, 0xDC
  pop ax                                       ; 0B9E5  0x58
  mov di, 0x60ae                               ; 0B9E6  0xBF, 0xAE, 0x60
  call sub_09621                               ; 0B9E9  0xE8, 0x35, 0xDC
  mov ax, [cs:0x2c45]                          ; 0B9EC  0x2E, 0xA1, 0x45, 0x2C
  mov es, ax                                   ; 0B9F0  0x8E, 0xC0
  db 0x33, 0xFF                                ; 0B9F2  xor di, di
  mov cx, 0x4000                               ; 0B9F4  0xB9, 0x00, 0x40
  mov ax, 0xff                                 ; 0B9F7  0xB8, 0xFF, 0x00
  rep stosw                                    ; 0B9FA  0xF3, 0xAB
  push ds                                      ; 0B9FC  0x1E
  mov ax, [cs:0x2c45]                          ; 0B9FD  0x2E, 0xA1, 0x45, 0x2C
  mov es, ax                                   ; 0BA01  0x8E, 0xC0
  lds bx, [cs:0x6228]                          ; 0BA03  0x2E, 0xC5, 0x1E, 0x28, 0x62
  lds si, [bx]                                 ; 0BA08  0xC5, 0x37
  lodsb                                        ; 0BA0A  0xAC

loc_0BA0B:                                     ; 0BA0B
  mov cl, 5                                    ; 0BA0B  0xB1, 0x05
  db 0x32, 0xE4                                ; 0BA0D  xor ah, ah
  shl ax, cl                                   ; 0BA0F  0xD3, 0xE0
  db 0x8B, 0xF8                                ; 0BA11  mov di, ax
  mov cx, 0xa                                  ; 0BA13  0xB9, 0x0A, 0x00
  mov al, 0xff                                 ; 0BA16  0xB0, 0xFF

loc_0BA18:                                     ; 0BA18
  mov ah, [si]                                 ; 0BA18  0x8A, 0x24
  stosw                                        ; 0BA1A  0xAB
  inc si                                       ; 0BA1B  0x46
  loop loc_0BA18                               ; 0BA1C  0xE2, 0xFA
  lodsb                                        ; 0BA1E  0xAC
  db 0x0A, 0xC0                                ; 0BA1F  or al, al
  jne loc_0BA0B                                ; 0BA21  0x75, 0xE8
  push es                                      ; 0BA23  0x06
  push ds                                      ; 0BA24  0x1E
  push cs                                      ; 0BA25  0x0E
  pop ds                                       ; 0BA26  0x1F
  mov al, 0x33                                 ; 0BA27  0xB0, 0x33
  mov cx, 0x97                                 ; 0BA29  0xB9, 0x97, 0x00
  mov dx, 0x5024                               ; 0BA2C  0xBA, 0x24, 0x50
  int 0x28                                     ; 0BA2F  0xCD, 0x28
  mov cx, 0x98                                 ; 0BA31  0xB9, 0x98, 0x00
  mov al, 0x33                                 ; 0BA34  0xB0, 0x33
  mov dx, 0x5044                               ; 0BA36  0xBA, 0x44, 0x50
  int 0x28                                     ; 0BA39  0xCD, 0x28
  mov al, 0x34                                 ; 0BA3B  0xB0, 0x34
  mov cx, 0x97                                 ; 0BA3D  0xB9, 0x97, 0x00
  mov dx, 0x5044                               ; 0BA40  0xBA, 0x44, 0x50
  int 0x28                                     ; 0BA43  0xCD, 0x28
  mov al, 0x34                                 ; 0BA45  0xB0, 0x34
  mov cx, 0x98                                 ; 0BA47  0xB9, 0x98, 0x00
  mov dx, 0x5024                               ; 0BA4A  0xBA, 0x24, 0x50
  int 0x28                                     ; 0BA4D  0xCD, 0x28
  pop ds                                       ; 0BA4F  0x1F
  pop es                                       ; 0BA50  0x07
  mov ax, es                                   ; 0BA51  0x8C, 0xC0
  mov ds, ax                                   ; 0BA53  0x8E, 0xD8
  db 0x33, 0xF6                                ; 0BA55  xor si, si
  mov di, 0x2000                               ; 0BA57  0xBF, 0x00, 0x20
  mov cx, 0x3000                               ; 0BA5A  0xB9, 0x00, 0x30
  rep movsw                                    ; 0BA5D  0xF3, 0xA5
  pop ds                                       ; 0BA5F  0x1F
  mov bx, 0x4225                               ; 0BA60  0xBB, 0x25, 0x42
  test byte [bx + 0x12], 1                     ; 0BA63  0xF6, 0x47, 0x12, 0x01
  jne loc_0BA8B                                ; 0BA67  0x75, 0x22
  mov byte [cs:0x2bfb], 0xff                   ; 0BA69  0x2E, 0xC6, 0x06, 0xFB, 0x2B, 0xFF
  mov byte [cs:0x2bfe], 0x38                   ; 0BA6F  0x2E, 0xC6, 0x06, 0xFE, 0x2B, 0x38
  mov bx, 0x4256                               ; 0BA75  0xBB, 0x56, 0x42
  mov al, [bx + 0x16]                          ; 0BA78  0x8A, 0x47, 0x16
  mov cl, 4                                    ; 0BA7B  0xB1, 0x04
  rol al, cl                                   ; 0BA7D  0xD2, 0xC0
  and al, 0xf0                                 ; 0BA7F  0x24, 0xF0
  jne loc_0BA85                                ; 0BA81  0x75, 0x02
  mov al, 0x60                                 ; 0BA83  0xB0, 0x60

loc_0BA85:                                     ; 0BA85
  mov [cs:0x2bff], al                          ; 0BA85  0x2E, 0xA2, 0xFF, 0x2B
  jmp short loc_0BA92                          ; 0BA89  0xEB, 0x07

loc_0BA8B:                                     ; 0BA8B
  db 0x2E, 0xC7, 0x06, 0xAF, 0x12, 0x00, 0x00  ; 0BA8B  mov word [cs:0x12af], 0

loc_0BA92:                                     ; 0BA92
  mov bx, 0x4256                               ; 0BA92  0xBB, 0x56, 0x42
  mov al, [bx + 0x13]                          ; 0BA95  0x8A, 0x47, 0x13
  db 0x8A, 0xD0                                ; 0BA98  mov dl, al
  and al, 1                                    ; 0BA9A  0x24, 0x01
  mov [cs:0x2bfd], al                          ; 0BA9C  0x2E, 0xA2, 0xFD, 0x2B
  mov cl, 4                                    ; 0BAA0  0xB1, 0x04
  shr dl, cl                                   ; 0BAA2  0xD2, 0xEA
  dec dl                                       ; 0BAA4  0xFE, 0xCA
  cmp dl, 9                                    ; 0BAA6  0x80, 0xFA, 0x09
  jbe loc_0BAAD                                ; 0BAA9  0x76, 0x02
  mov dl, 9                                    ; 0BAAB  0xB2, 0x09

loc_0BAAD:                                     ; 0BAAD
  mov [cs:0x2bfc], dl                          ; 0BAAD  0x2E, 0x88, 0x16, 0xFC, 0x2B
  mov al, 0xa                                  ; 0BAB2  0xB0, 0x0A
  mov ah, 9                                    ; 0BAB4  0xB4, 0x09
  db 0x2A, 0xE2                                ; 0BAB6  sub ah, dl
  mov [cs:0x5fdc], ax                          ; 0BAB8  0x2E, 0xA3, 0xDC, 0x5F
  mov al, 0                                    ; 0BABC  0xB0, 0x00
  test byte [bx + 0x12], 0xf0                  ; 0BABE  0xF6, 0x47, 0x12, 0xF0
  je loc_0BAC6                                 ; 0BAC2  0x74, 0x02
  mov al, 1                                    ; 0BAC4  0xB0, 0x01

loc_0BAC6:                                     ; 0BAC6
  mov [cs:0x2c08], al                          ; 0BAC6  0x2E, 0xA2, 0x08, 0x2C
  mov dx, [cs:0xc38]                           ; 0BACA  0x2E, 0x8B, 0x16, 0x38, 0x0C
  mov [cs:0x2bf1], dx                          ; 0BACF  0x2E, 0x89, 0x16, 0xF1, 0x2B
  mov es, dx                                   ; 0BAD4  0x8E, 0xC2
  mov cx, 1                                    ; 0BAD6  0xB9, 0x01, 0x00
  mov bx, 0x2b5d                               ; 0BAD9  0xBB, 0x5D, 0x2B
  mov di, 0xf00                                ; 0BADC  0xBF, 0x00, 0x0F

loc_0BADF:                                     ; 0BADF
  db 0x33, 0xF6                                ; 0BADF  xor si, si
  push cx                                      ; 0BAE1  0x51
  mov cx, 0x1a                                 ; 0BAE2  0xB9, 0x1A, 0x00
  mov [bx + 0x62], di                          ; 0BAE5  0x89, 0x7F, 0x62

loc_0BAE8:                                     ; 0BAE8
  mov [bx + si], di                            ; 0BAE8  0x89, 0x38
  push cx                                      ; 0BAEA  0x51
  mov cx, 0x50                                 ; 0BAEB  0xB9, 0x50, 0x00
  mov ax, 0x820                                ; 0BAEE  0xB8, 0x20, 0x08
  cld                                          ; 0BAF1  0xFC
  rep stosw                                    ; 0BAF2  0xF3, 0xAB
  inc si                                       ; 0BAF4  0x46
  inc si                                       ; 0BAF5  0x46
  pop cx                                       ; 0BAF6  0x59
  loop loc_0BAE8                               ; 0BAF7  0xE2, 0xEF
  push di                                      ; 0BAF9  0x57
  call sub_09643                               ; 0BAFA  0xE8, 0x46, 0xDB
  mov al, [cs:0x2bff]                          ; 0BAFD  0x2E, 0xA0, 0xFF, 0x2B
  mov [bx + 0x80], al                          ; 0BB01  0x88, 0x87, 0x80, 0x00
  or byte [bx + 0x6b], 8                       ; 0BB05  0x80, 0x4F, 0x6B, 0x08
  shr al, 4                                    ; 0BB09  0xC0, 0xE8, 0x04
  mov [bx + 0x7f], al                          ; 0BB0C  0x88, 0x47, 0x7F
  mov al, [cs:0x2c08]                          ; 0BB0F  0x2E, 0xA0, 0x08, 0x2C
  mov [bx + 0x71], al                          ; 0BB13  0x88, 0x47, 0x71
  mov al, [cs:0x2bfd]                          ; 0BB16  0x2E, 0xA0, 0xFD, 0x2B
  mov [bx + 0x74], al                          ; 0BB1A  0x88, 0x47, 0x74
  mov ax, [cs:0x5fdc]                          ; 0BB1D  0x2E, 0xA1, 0xDC, 0x5F
  mov [bx + 0x72], ax                          ; 0BB21  0x89, 0x47, 0x72
  pop di                                       ; 0BB24  0x5F
  add bx, 0x94                                 ; 0BB25  0x81, 0xC3, 0x94, 0x00
  pop cx                                       ; 0BB29  0x59
  loop loc_0BADF                               ; 0BB2A  0xE2, 0xB3
  push ds                                      ; 0BB2C  0x1E
  pop es                                       ; 0BB2D  0x07
  mov di, 0x2b5b                               ; 0BB2E  0xBF, 0x5B, 0x2B
  mov cx, 2                                    ; 0BB31  0xB9, 0x02, 0x00
  db 0x32, 0xC0                                ; 0BB34  xor al, al
  rep stosb                                    ; 0BB36  0xF3, 0xAA
  mov di, 0x2b5b                               ; 0BB38  0xBF, 0x5B, 0x2B
  mov dx, 0                                    ; 0BB3B  0xBA, 0x00, 0x00

loc_0BB3E:                                     ; 0BB3E
  db 0x8B, 0xDA                                ; 0BB3E  mov bx, dx
  shl bx, 1                                    ; 0BB40  0xD1, 0xE3
  mov bx, [cs:bx + 0x2bf3]                     ; 0BB42  0x2E, 0x8B, 0x9F, 0xF3, 0x2B
  call sub_092A5                               ; 0BB47  0xE8, 0x5B, 0xD7
  dec dl                                       ; 0BB4A  0xFE, 0xCA
  jns loc_0BB3E                                ; 0BB4C  0x79, 0xF0
  mov di, 0x4bc4                               ; 0BB4E  0xBF, 0xC4, 0x4B
  push di                                      ; 0BB51  0x57
  db 0x33, 0xC0                                ; 0BB52  xor ax, ax
  mov cx, 0x1c8                                ; 0BB54  0xB9, 0xC8, 0x01
  rep stosw                                    ; 0BB57  0xF3, 0xAB
  pop di                                       ; 0BB59  0x5F
  add di, 0xf0                                 ; 0BB5A  0x81, 0xC7, 0xF0, 0x00
  mov si, 0x4ff0                               ; 0BB5E  0xBE, 0xF0, 0x4F
  mov cx, 0x34                                 ; 0BB61  0xB9, 0x34, 0x00
  rep movsb                                    ; 0BB64  0xF3, 0xA4

loc_0BB66:                                     ; 0BB66
  cmp byte [cs:0x5fa4], 1                      ; 0BB66  0x2E, 0x80, 0x3E, 0xA4, 0x5F, 0x01
  je loc_0BB66                                 ; 0BB6C  0x74, 0xF8
  mov ah, 4                                    ; 0BB6E  0xB4, 0x04
  call xios_crt_trigger_ca                     ; 0BB70  0xE8, 0x8E, 0xDA
  mov ah, 6                                    ; 0BB73  0xB4, 0x06
  call xios_crt_trigger_ca                     ; 0BB75  0xE8, 0x89, 0xDA
  mov bx, 0x2b5d                               ; 0BB78  0xBB, 0x5D, 0x2B
  call sub_08BFB                               ; 0BB7B  0xE8, 0x7D, 0xD0
  call sub_08C5F                               ; 0BB7E  0xE8, 0xDE, 0xD0
  mov dx, PORT_PCB_T1_CON                      ; 0BB81  0xBA, 0x5E, 0xFF
  mov ax, 0x200                                ; 0BB84  0xB8, 0x00, 0x02
  sub dx, 2                                    ; 0BB87  0x83, 0xEA, 0x02
  out dx, ax                                   ; 0BB8A  0xEF
  sub dx, 2                                    ; 0BB8B  0x83, 0xEA, 0x02
  out dx, ax                                   ; 0BB8E  0xEF
  ret                                          ; 0BB8F  0xC3
  db 0x1B, 0x48, 0x00                          ; 0BB90  sbb cx, word [bx + si]
  add [bp + di], bl                            ; 0BB93  0x00, 0x1B
  inc cx                                       ; 0BB95  0x41
  db 0x00, 0x00                                ; 0BB96
  db 0x00, 0x00                                ; 0BB98
  db 0x00, 0x00                                ; 0BB9A
  db 0x00, 0x00                                ; 0BB9C
  db 0x00, 0x00                                ; 0BB9E
  db 0x1B, 0x44, 0x00                          ; 0BBA0  sbb ax, word [si]
  add [di], cl                                 ; 0BBA3  0x00, 0x0D
  db 0x00, 0x00                                ; 0BBA5
  add [bp + di], bl                            ; 0BBA7  0x00, 0x1B
  inc bx                                       ; 0BBA9  0x43
  db 0x00, 0x00                                ; 0BBAA
  db 0x00, 0x00                                ; 0BBAC
  db 0x00, 0x00                                ; 0BBAE
  db 0x00, 0x00                                ; 0BBB0
  db 0x00, 0x00                                ; 0BBB2
  db 0x1B, 0x42, 0x00                          ; 0BBB4  sbb ax, word [bp + si]
  add [bx + di], cl                            ; 0BBB7  0x00, 0x09
  db 0x00, 0x00                                ; 0BBB9
  add [bx + 0x4c], bh                          ; 0BBBB  0x00, 0x7F, 0x4C
  db 0x00, 0x00                                ; 0BBBE
  jg loc_0BBC2                                 ; 0BBC0  0x7F, 0x00

loc_0BBC2:                                     ; 0BBC2
  db 0x00, 0x00                                ; 0BBC2
  db 0x00, 0x00                                ; 0BBC4
  db 0x00, 0x00                                ; 0BBC6
  db 0x00, 0x00                                ; 0BBC8
  db 0x00, 0x00                                ; 0BBCA
  db 0x00, 0x00                                ; 0BBCC
  db 0x00, 0x00                                ; 0BBCE
  db 0x00, 0x00                                ; 0BBD0
  db 0x00, 0x00                                ; 0BBD2
  db 0x00, 0x00                                ; 0BBD4
  db 0x00, 0x00                                ; 0BBD6
  db 0x00, 0x00                                ; 0BBD8
  db 0x00, 0x00                                ; 0BBDA
  db 0x00, 0x00                                ; 0BBDC
  db 0x00, 0x00                                ; 0BBDE
  db 0x00, 0x00                                ; 0BBE0
  db 0x00, 0x00                                ; 0BBE2
  db 0x00, 0x00                                ; 0BBE4
  db 0x00, 0x00                                ; 0BBE6
  db 0x00, 0x00                                ; 0BBE8
  db 0x00, 0x00                                ; 0BBEA
  db 0x00, 0x00                                ; 0BBEC
  db 0x00, 0x00                                ; 0BBEE
  db 0x00, 0x00                                ; 0BBF0
  db 0x00, 0x00                                ; 0BBF2
  db 0x00, 0x00                                ; 0BBF4
  db 0x00, 0x00                                ; 0BBF6
  db 0x00, 0x00                                ; 0BBF8
  db 0x00, 0x00                                ; 0BBFA
  db 0x00, 0x00                                ; 0BBFC
  db 0x00, 0x00                                ; 0BBFE
  db 0x00, 0x00                                ; 0BC00
  db 0x00, 0x00                                ; 0BC02
  db 0x00, 0x00                                ; 0BC04
  db 0x00, 0x00                                ; 0BC06
  db 0x00, 0x00                                ; 0BC08
  add [bx + di], ax                            ; 0BC0A  0x01, 0x01
  db 0x00, 0x00                                ; 0BC0C
  pop ds                                       ; 0BC0E  0x1F
  sbb al, 0x1f                                 ; 0BC0F  0x1C, 0x1F
  push ds                                      ; 0BC11  0x1E
  pop ds                                       ; 0BC12  0x1F
  push ds                                      ; 0BC13  0x1E
  pop ds                                       ; 0BC14  0x1F
  pop ds                                       ; 0BC15  0x1F
  push ds                                      ; 0BC16  0x1E
  pop ds                                       ; 0BC17  0x1F
  push ds                                      ; 0BC18  0x1E
  pop ds                                       ; 0BC19  0x1F
  add [bx], bl                                 ; 0BC1A  0x00, 0x1F
  sbb ax, 0x1e1f                               ; 0BC1C  0x1D, 0x1F, 0x1E
  pop ds                                       ; 0BC1F  0x1F
  push ds                                      ; 0BC20  0x1E
  pop ds                                       ; 0BC21  0x1F
  pop ds                                       ; 0BC22  0x1F
  push ds                                      ; 0BC23  0x1E
  pop ds                                       ; 0BC24  0x1F
  push ds                                      ; 0BC25  0x1E
  pop ds                                       ; 0BC26  0x1F
  db 0x00, 0x00                                ; 0BC27
  db 0x00, 0x00                                ; 0BC29
  db 0x00, 0x00                                ; 0BC2B
  db 0x00, 0x00                                ; 0BC2D
  db 0x00, 0x00                                ; 0BC2F
  db 0x00, 0x00                                ; 0BC31
  add al, 0                                    ; 0BC33  0x04, 0x00
  or al, 0                                     ; 0BC35  0x0C, 0x00
  test [bp + di], al                           ; 0BC37  0x84, 0x03

sub_0BC39:                                     ; 0BC39
  push es                                      ; 0BC39  0x06
  mov ax, [cs:0xc06]                           ; 0BC3A  0x2E, 0xA1, 0x06, 0x0C
  mov es, ax                                   ; 0BC3E  0x8E, 0xC0
  mov bx, 0                                    ; 0BC40  0xBB, 0x00, 0x00
  mov al, 2                                    ; 0BC43  0xB0, 0x02
  call sub_0AFE6                               ; 0BC45  0xE8, 0x9E, 0xF3
  mov [es:bx + 0x82], al                       ; 0BC48  0x26, 0x88, 0x87, 0x82, 0x00
  mov al, 3                                    ; 0BC4D  0xB0, 0x03
  call sub_0AFE6                               ; 0BC4F  0xE8, 0x94, 0xF3
  mov [es:bx + 0x81], al                       ; 0BC52  0x26, 0x88, 0x87, 0x81, 0x00
  mov al, 4                                    ; 0BC57  0xB0, 0x04
  call sub_0AFE6                               ; 0BC59  0xE8, 0x8A, 0xF3
  mov [es:bx + 0x80], al                       ; 0BC5C  0x26, 0x88, 0x87, 0x80, 0x00
  mov al, 7                                    ; 0BC61  0xB0, 0x07
  call sub_0AFE6                               ; 0BC63  0xE8, 0x80, 0xF3
  call sub_0BC7B                               ; 0BC66  0xE8, 0x12, 0x00
  mov [cs:0x506b], al                          ; 0BC69  0x2E, 0xA2, 0x6B, 0x50
  mov al, 6                                    ; 0BC6D  0xB0, 0x06
  call sub_0AFE6                               ; 0BC6F  0xE8, 0x74, 0xF3
  call sub_0BC7B                               ; 0BC72  0xE8, 0x06, 0x00
  mov [cs:0x506a], al                          ; 0BC75  0x2E, 0xA2, 0x6A, 0x50
  pop es                                       ; 0BC79  0x07
  ret                                          ; 0BC7A  0xC3

sub_0BC7B:                                     ; 0BC7B
  db 0x8A, 0xE0                                ; 0BC7B  mov ah, al
  and ah, 0xf0                                 ; 0BC7D  0x80, 0xE4, 0xF0
  mov cl, 4                                    ; 0BC80  0xB1, 0x04
  shr ah, cl                                   ; 0BC82  0xD2, 0xEC
  and al, 0xf                                  ; 0BC84  0x24, 0x0F
  db 0xD5, 0x0A                                ; 0BC86  aad 0xa
  ret                                          ; 0BC88  0xC3

sub_0BC89:                                     ; 0BC89
  push es                                      ; 0BC89  0x06
  mov ax, [cs:0xc06]                           ; 0BC8A  0x2E, 0xA1, 0x06, 0x0C
  mov es, ax                                   ; 0BC8E  0x8E, 0xC0
  mov bx, 0                                    ; 0BC90  0xBB, 0x00, 0x00
  mov al, 2                                    ; 0BC93  0xB0, 0x02
  call sub_0AFE6                               ; 0BC95  0xE8, 0x4E, 0xF3
  mov [es:bx + 0x82], al                       ; 0BC98  0x26, 0x88, 0x87, 0x82, 0x00
  mov al, 3                                    ; 0BC9D  0xB0, 0x03
  call sub_0AFE6                               ; 0BC9F  0xE8, 0x44, 0xF3
  mov [es:bx + 0x81], al                       ; 0BCA2  0x26, 0x88, 0x87, 0x81, 0x00
  mov al, 4                                    ; 0BCA7  0xB0, 0x04
  call sub_0AFE6                               ; 0BCA9  0xE8, 0x3A, 0xF3
  and al, 0x7f                                 ; 0BCAC  0x24, 0x7F
  mov [es:bx + 0x80], al                       ; 0BCAE  0x26, 0x88, 0x87, 0x80, 0x00
  mov al, 6                                    ; 0BCB3  0xB0, 0x06
  call sub_0AFE6                               ; 0BCB5  0xE8, 0x2E, 0xF3
  call sub_0BC7B                               ; 0BCB8  0xE8, 0xC0, 0xFF
  mov [cs:0x506b], al                          ; 0BCBB  0x2E, 0xA2, 0x6B, 0x50
  mov al, 5                                    ; 0BCBF  0xB0, 0x05
  call sub_0AFE6                               ; 0BCC1  0xE8, 0x22, 0xF3
  call sub_0BC7B                               ; 0BCC4  0xE8, 0xB4, 0xFF
  mov [cs:0x506a], al                          ; 0BCC7  0x2E, 0xA2, 0x6A, 0x50
  pop es                                       ; 0BCCB  0x07
  ret                                          ; 0BCCC  0xC3

sub_0BCCD:                                     ; 0BCCD
  push dx                                      ; 0BCCD  0x52
  push bx                                      ; 0BCCE  0x53
  push cx                                      ; 0BCCF  0x51
  push ax                                      ; 0BCD0  0x50
  call sub_0BD20                               ; 0BCD1  0xE8, 0x4C, 0x00
  db 0x8A, 0xD8                                ; 0BCD4  mov bl, al
  mov ah, 0                                    ; 0BCD6  0xB4, 0x00
  mov al, 0                                    ; 0BCD8  0xB0, 0x00
  call sub_0BD20                               ; 0BCDA  0xE8, 0x43, 0x00
  db 0x8A, 0xF8                                ; 0BCDD  mov bh, al
  pop ax                                       ; 0BCDF  0x58
  push ax                                      ; 0BCE0  0x50
  call sub_0BD44                               ; 0BCE1  0xE8, 0x60, 0x00
  pop ax                                       ; 0BCE4  0x58
  mov dx, PORT_NVRAM_BASE                      ; 0BCE5  0xBA, 0x80, 0x00
  shl al, 1                                    ; 0BCE8  0xD0, 0xE0
  shl al, 1                                    ; 0BCEA  0xD0, 0xE0
  db 0x32, 0xE4                                ; 0BCEC  xor ah, ah
  db 0x03, 0xD0                                ; 0BCEE  add dx, ax
  pop cx                                       ; 0BCF0  0x59
  push cx                                      ; 0BCF1  0x51
  db 0x8A, 0xC1                                ; 0BCF2  mov al, cl
  mov cl, 4                                    ; 0BCF4  0xB1, 0x04
  shr al, cl                                   ; 0BCF6  0xD2, 0xE8
  out dx, al                                   ; 0BCF8  0xEE
  pop cx                                       ; 0BCF9  0x59
  db 0x8A, 0xC1                                ; 0BCFA  mov al, cl
  and al, 0xf                                  ; 0BCFC  0x24, 0x0F
  add dx, 2                                    ; 0BCFE  0x83, 0xC2, 0x02
  out dx, al                                   ; 0BD01  0xEE
  db 0x2A, 0xD9                                ; 0BD02  sub bl, cl
  db 0x02, 0xFB                                ; 0BD04  add bh, bl
  mov ah, 0                                    ; 0BD06  0xB4, 0x00
  call sub_0BD44                               ; 0BD08  0xE8, 0x39, 0x00
  mov dx, PORT_NVRAM_BASE                      ; 0BD0B  0xBA, 0x80, 0x00
  db 0x8A, 0xC7                                ; 0BD0E  mov al, bh
  mov cl, 4                                    ; 0BD10  0xB1, 0x04
  shr al, cl                                   ; 0BD12  0xD2, 0xE8
  out dx, al                                   ; 0BD14  0xEE
  db 0x8A, 0xC7                                ; 0BD15  mov al, bh
  and al, 0xf                                  ; 0BD17  0x24, 0x0F
  add dx, 2                                    ; 0BD19  0x83, 0xC2, 0x02
  out dx, al                                   ; 0BD1C  0xEE
  pop bx                                       ; 0BD1D  0x5B
  pop dx                                       ; 0BD1E  0x5A
  ret                                          ; 0BD1F  0xC3

sub_0BD20:                                     ; 0BD20
  push dx                                      ; 0BD20  0x52
  push cx                                      ; 0BD21  0x51
  push ax                                      ; 0BD22  0x50
  call sub_0BD44                               ; 0BD23  0xE8, 0x1E, 0x00
  mov dx, PORT_NVRAM_BASE                      ; 0BD26  0xBA, 0x80, 0x00
  pop ax                                       ; 0BD29  0x58
  shl al, 1                                    ; 0BD2A  0xD0, 0xE0
  shl al, 1                                    ; 0BD2C  0xD0, 0xE0
  db 0x32, 0xE4                                ; 0BD2E  xor ah, ah
  db 0x03, 0xD0                                ; 0BD30  add dx, ax
  in al, dx                                    ; 0BD32  0xEC
  add dx, 2                                    ; 0BD33  0x83, 0xC2, 0x02
  xchg ah, al                                  ; 0BD36  86 E0
  in al, dx                                    ; 0BD38  0xEC
  mov cl, 4                                    ; 0BD39  0xB1, 0x04
  shl ah, cl                                   ; 0BD3B  0xD2, 0xE4
  and al, 0xf                                  ; 0BD3D  0x24, 0x0F
  db 0x0A, 0xC4                                ; 0BD3F  or al, ah
  pop cx                                       ; 0BD41  0x59
  pop dx                                       ; 0BD42  0x5A
  ret                                          ; 0BD43  0xC3

sub_0BD44:                                     ; 0BD44
  mov dx, PORT_PPI_PORTC                       ; 0BD44  0xBA, 0x74, 0x00
  in al, dx                                    ; 0BD47  0xEC
  and al, 0xcf                                 ; 0BD48  0x24, 0xCF
  mov cl, 4                                    ; 0BD4A  0xB1, 0x04
  shl ah, cl                                   ; 0BD4C  0xD2, 0xE4
  db 0x0A, 0xC4                                ; 0BD4E  or al, ah
  out dx, al                                   ; 0BD50  0xEE
  ret                                          ; 0BD51  0xC3

loc_0BD52:                                     ; 0BD52
  cli                                          ; 0BD52  0xFA
  cld                                          ; 0BD53  0xFC
  mov [cs:0x5064], es                          ; 0BD54  0x2E, 0x8C, 0x06, 0x64, 0x50
  mov si, 0x50                                 ; 0BD59  0xBE, 0x50, 0x00
  mov di, 0x4225                               ; 0BD5C  0xBF, 0x25, 0x42
  push ds                                      ; 0BD5F  0x1E
  pop es                                       ; 0BD60  0x07
  push ds                                      ; 0BD61  0x1E
  db 0x33, 0xC0                                ; 0BD62  xor ax, ax
  mov ds, ax                                   ; 0BD64  0x8E, 0xD8
  mov cx, 0x30                                 ; 0BD66  0xB9, 0x30, 0x00
  cld                                          ; 0BD69  0xFC
  rep movsb                                    ; 0BD6A  0xF3, 0xA4
  pop ds                                       ; 0BD6C  0x1F
  mov ax, 0                                    ; 0BD6D  0xB8, 0x00, 0x00
  mov bl, 0                                    ; 0BD70  0xB3, 0x00
  mov bh, 3                                    ; 0BD72  0xB7, 0x03
  mov cx, 0x20                                 ; 0BD74  0xB9, 0x20, 0x00

loc_0BD77:                                     ; 0BD77
  push ax                                      ; 0BD77  0x50
  call sub_0BD20                               ; 0BD78  0xE8, 0xA5, 0xFF
  db 0x02, 0xD8                                ; 0BD7B  add bl, al
  pop ax                                       ; 0BD7D  0x58
  inc al                                       ; 0BD7E  0xFE, 0xC0
  loop loc_0BD77                               ; 0BD80  0xE2, 0xF5
  inc ah                                       ; 0BD82  0xFE, 0xC4
  mov al, 0                                    ; 0BD84  0xB0, 0x00
  mov cx, 0x20                                 ; 0BD86  0xB9, 0x20, 0x00
  dec bh                                       ; 0BD89  0xFE, 0xCF
  jne loc_0BD77                                ; 0BD8B  0x75, 0xEA
  cmp bl, 0xaa                                 ; 0BD8D  0x80, 0xFB, 0xAA
  jne loc_0BDAF                                ; 0BD90  0x75, 0x1D
  mov bx, 0x4256                               ; 0BD92  0xBB, 0x56, 0x42
  mov ax, 0                                    ; 0BD95  0xB8, 0x00, 0x00

loc_0BD98:                                     ; 0BD98
  push ax                                      ; 0BD98  0x50
  call sub_0BD20                               ; 0BD99  0xE8, 0x84, 0xFF
  mov [bx], al                                 ; 0BD9C  0x88, 0x07
  inc bx                                       ; 0BD9E  0x43
  pop ax                                       ; 0BD9F  0x58
  inc al                                       ; 0BDA0  0xFE, 0xC0
  cmp al, 0x20                                 ; 0BDA2  0x3C, 0x20
  jne loc_0BD98                                ; 0BDA4  0x75, 0xF2
  mov al, 0                                    ; 0BDA6  0xB0, 0x00
  inc ah                                       ; 0BDA8  0xFE, 0xC4
  cmp ah, 4                                    ; 0BDAA  0x80, 0xFC, 0x04
  jne loc_0BD98                                ; 0BDAD  0x75, 0xE9

loc_0BDAF:                                     ; 0BDAF
  mov ah, 3                                    ; 0BDAF  0xB4, 0x03
  call sub_0BD44                               ; 0BDB1  0xE8, 0x90, 0xFF
  mov bx, 0x4225                               ; 0BDB4  0xBB, 0x25, 0x42
  and byte [bx + 0x17], 0xdf                   ; 0BDB7  0x80, 0x67, 0x17, 0xDF
  cmp byte [bx + 0x17], 0x50                   ; 0BDBB  0x80, 0x7F, 0x17, 0x50
  jne loc_0BDDA                                ; 0BDBF  0x75, 0x19
  db 0x33, 0xC0                                ; 0BDC1  xor ax, ax
  push ds                                      ; 0BDC3  0x1E
  pop es                                       ; 0BDC4  0x07
  mov di, 0x5087                               ; 0BDC5  0xBF, 0x87, 0x50
  mov cx, 3                                    ; 0BDC8  0xB9, 0x03, 0x00
  mov bx, 0x5093                               ; 0BDCB  0xBB, 0x93, 0x50

loc_0BDCE:                                     ; 0BDCE
  mov si, [bx]                                 ; 0BDCE  0x8B, 0x37
  push ds                                      ; 0BDD0  0x1E
  mov ds, ax                                   ; 0BDD1  0x8E, 0xD8
  movsw                                        ; 0BDD3  0xA5
  movsw                                        ; 0BDD4  0xA5
  pop ds                                       ; 0BDD5  0x1F
  inc bx                                       ; 0BDD6  0x43
  inc bx                                       ; 0BDD7  0x43
  loop loc_0BDCE                               ; 0BDD8  0xE2, 0xF4

loc_0BDDA:                                     ; 0BDDA
  db 0x33, 0xC0                                ; 0BDDA  xor ax, ax
  db 0x8B, 0xF8                                ; 0BDDC  mov di, ax
  mov es, ax                                   ; 0BDDE  0x8E, 0xC0
  mov bx, cs                                   ; 0BDE0  0x8C, 0xCB
  mov ax, 0x6230                               ; 0BDE2  0xB8, 0x30, 0x62
  mov cl, 4                                    ; 0BDE5  0xB1, 0x04
  shr ax, cl                                   ; 0BDE7  0xD3, 0xE8
  db 0x03, 0xD8                                ; 0BDE9  add bx, ax
  db 0x33, 0xC0                                ; 0BDEB  xor ax, ax
  mov cx, 0x100                                ; 0BDED  0xB9, 0x00, 0x01

loc_0BDF0:                                     ; 0BDF0
  stosw                                        ; 0BDF0  0xAB
  inc ax                                       ; 0BDF1  0x40
  xchg bx, ax                                  ; 0BDF2  0x93
  stosw                                        ; 0BDF3  0xAB
  xchg bx, ax                                  ; 0BDF4  0x93
  loop loc_0BDF0                               ; 0BDF5  0xE2, 0xF9
  mov bx, 0x4225                               ; 0BDF7  0xBB, 0x25, 0x42
  and byte [bx + 0x17], 0xdf                   ; 0BDFA  0x80, 0x67, 0x17, 0xDF
  cmp byte [bx + 0x17], 0x50                   ; 0BDFE  0x80, 0x7F, 0x17, 0x50
  jne loc_0BE16                                ; 0BE02  0x75, 0x12
  db 0x33, 0xC0                                ; 0BE04  xor ax, ax
  mov es, ax                                   ; 0BE06  0x8E, 0xC0
  mov cx, 3                                    ; 0BE08  0xB9, 0x03, 0x00
  mov bx, 0x5093                               ; 0BE0B  0xBB, 0x93, 0x50

loc_0BE0E:                                     ; 0BE0E
  mov di, [bx]                                 ; 0BE0E  0x8B, 0x3F
  movsw                                        ; 0BE10  0xA5
  movsw                                        ; 0BE11  0xA5
  inc bx                                       ; 0BE12  0x43
  inc bx                                       ; 0BE13  0x43
  loop loc_0BE0E                               ; 0BE14  0xE2, 0xF8

loc_0BE16:                                     ; 0BE16
  mov bx, 0x4225                               ; 0BE16  0xBB, 0x25, 0x42
  and byte [bx + 0x17], 0xdf                   ; 0BE19  0x80, 0x67, 0x17, 0xDF
  cmp byte [bx + 0x17], 0x50                   ; 0BE1D  0x80, 0x7F, 0x17, 0x50
  je loc_0BE2F                                 ; 0BE21  0x74, 0x0C
  mov bx, cs                                   ; 0BE23  0x8C, 0xCB
  mov di, 0xc                                  ; 0BE25  0xBF, 0x0C, 0x00
  mov ax, 0x471e                               ; 0BE28  0xB8, 0x1E, 0x47
  stosw                                        ; 0BE2B  0xAB
  db 0x8B, 0xC3                                ; 0BE2C  mov ax, bx
  stosw                                        ; 0BE2E  0xAB

loc_0BE2F:                                     ; 0BE2F
  mov bx, cs                                   ; 0BE2F  0x8C, 0xCB
  mov di, 8                                    ; 0BE31  0xBF, 0x08, 0x00
  mov ax, 0x3bd1                               ; 0BE34  0xB8, 0xD1, 0x3B
  stosw                                        ; 0BE37  0xAB
  db 0x8B, 0xC3                                ; 0BE38  mov ax, bx
  stosw                                        ; 0BE3A  0xAB
  mov di, 0x28                                 ; 0BE3B  0xBF, 0x28, 0x00
  mov ax, 0x3711                               ; 0BE3E  0xB8, 0x11, 0x37
  stosw                                        ; 0BE41  0xAB
  db 0x8B, 0xC3                                ; 0BE42  mov ax, bx
  stosw                                        ; 0BE44  0xAB
  mov di, 0x2c                                 ; 0BE45  0xBF, 0x2C, 0x00
  mov ax, 0x3729                               ; 0BE48  0xB8, 0x29, 0x37
  stosw                                        ; 0BE4B  0xAB
  db 0x8B, 0xC3                                ; 0BE4C  mov ax, bx
  stosw                                        ; 0BE4E  0xAB
  mov di, 0x34                                 ; 0BE4F  0xBF, 0x34, 0x00
  mov ax, 0x3f60                               ; 0BE52  0xB8, 0x60, 0x3F
  stosw                                        ; 0BE55  0xAB
  db 0x8B, 0xC3                                ; 0BE56  mov ax, bx
  stosw                                        ; 0BE58  0xAB
  mov di, 0x3c                                 ; 0BE59  0xBF, 0x3C, 0x00
  mov ax, 0x3e97                               ; 0BE5C  0xB8, 0x97, 0x3E
  stosw                                        ; 0BE5F  0xAB
  db 0x8B, 0xC3                                ; 0BE60  mov ax, bx
  stosw                                        ; 0BE62  0xAB
  mov di, 0x80                                 ; 0BE63  0xBF, 0x80, 0x00
  mov ax, 0x33ba                               ; 0BE66  0xB8, 0xBA, 0x33
  stosw                                        ; 0BE69  0xAB
  db 0x8B, 0xC3                                ; 0BE6A  mov ax, bx
  stosw                                        ; 0BE6C  0xAB
  mov di, 0x84                                 ; 0BE6D  0xBF, 0x84, 0x00
  mov ax, 0xef3                                ; 0BE70  0xB8, 0xF3, 0x0E
  stosw                                        ; 0BE73  0xAB
  db 0x8B, 0xC3                                ; 0BE74  mov ax, bx
  stosw                                        ; 0BE76  0xAB
  mov di, 0x8c                                 ; 0BE77  0xBF, 0x8C, 0x00
  mov ax, 0x432d                               ; 0BE7A  0xB8, 0x2D, 0x43
  stosw                                        ; 0BE7D  0xAB
  db 0x8B, 0xC3                                ; 0BE7E  mov ax, bx
  stosw                                        ; 0BE80  0xAB
  mov di, 0x88                                 ; 0BE81  0xBF, 0x88, 0x00
  mov ax, 0x4210                               ; 0BE84  0xB8, 0x10, 0x42
  stosw                                        ; 0BE87  0xAB
  db 0x8B, 0xC3                                ; 0BE88  mov ax, bx
  stosw                                        ; 0BE8A  0xAB
  mov di, 0x90                                 ; 0BE8B  0xBF, 0x90, 0x00
  mov ax, 0x105a                               ; 0BE8E  0xB8, 0x5A, 0x10
  stosw                                        ; 0BE91  0xAB
  db 0x8B, 0xC3                                ; 0BE92  mov ax, bx
  stosw                                        ; 0BE94  0xAB
  mov di, 0x98                                 ; 0BE95  0xBF, 0x98, 0x00
  mov ax, 0x41fb                               ; 0BE98  0xB8, 0xFB, 0x41
  stosw                                        ; 0BE9B  0xAB
  db 0x8B, 0xC3                                ; 0BE9C  mov ax, bx
  stosw                                        ; 0BE9E  0xAB
  mov di, 0x9c                                 ; 0BE9F  0xBF, 0x9C, 0x00
  mov ax, 0x41fb                               ; 0BEA2  0xB8, 0xFB, 0x41
  stosw                                        ; 0BEA5  0xAB
  db 0x8B, 0xC3                                ; 0BEA6  mov ax, bx
  stosw                                        ; 0BEA8  0xAB
  mov di, 0x388                                ; 0BEA9  0xBF, 0x88, 0x03
  mov ax, 0x46a9                               ; 0BEAC  0xB8, 0xA9, 0x46
  stosw                                        ; 0BEAF  0xAB
  db 0x8B, 0xC3                                ; 0BEB0  mov ax, bx
  stosw                                        ; 0BEB2  0xAB
  mov di, 0x38c                                ; 0BEB3  0xBF, 0x8C, 0x03
  mov ax, 0x46ac                               ; 0BEB6  0xB8, 0xAC, 0x46
  stosw                                        ; 0BEB9  0xAB
  db 0x8B, 0xC3                                ; 0BEBA  mov ax, bx
  stosw                                        ; 0BEBC  0xAB
  mov di, 0xa0                                 ; 0BEBD  0xBF, 0xA0, 0x00
  mov ax, 0xc91                                ; 0BEC0  0xB8, 0x91, 0x0C
  stosw                                        ; 0BEC3  0xAB
  db 0x8B, 0xC3                                ; 0BEC4  mov ax, bx
  stosw                                        ; 0BEC6  0xAB
  mov [cs:0x432b], cs                          ; 0BEC7  0x2E, 0x8C, 0x0E, 0x2B, 0x43
  mov [cs:0x4327], cs                          ; 0BECC  0x2E, 0x8C, 0x0E, 0x27, 0x43
  mov bx, 0x4225                               ; 0BED1  0xBB, 0x25, 0x42
  cmp byte [bx + 0xc], 0xff                    ; 0BED4  0x80, 0x7F, 0x0C, 0xFF
  je loc_0BEE6                                 ; 0BED8  0x74, 0x0C
  mov ah, 4                                    ; 0BEDA  0xB4, 0x04
  mov al, 0x11                                 ; 0BEDC  0xB0, 0x11
  call sub_0AFCA                               ; 0BEDE  0xE8, 0xE9, 0xF0
  call sub_0BC39                               ; 0BEE1  0xE8, 0x55, 0xFD
  jmp short loc_0BEF3                          ; 0BEE4  0xEB, 0x0D

loc_0BEE6:                                     ; 0BEE6
  mov dx, PORT_RTC_ADDR                        ; 0BEE6  0xBA, 0x5C, 0x00
  mov al, 7                                    ; 0BEE9  0xB0, 0x07
  mov ah, 0xc4                                 ; 0BEEB  0xB4, 0xC4
  call sub_0AFCA                               ; 0BEED  0xE8, 0xDA, 0xF0
  call sub_0BC89                               ; 0BEF0  0xE8, 0x96, 0xFD

loc_0BEF3:                                     ; 0BEF3
  db 0x2E, 0xC7, 0x06, 0x67, 0x50, 0x00, 0x00  ; 0BEF3  mov word [cs:0x5067], 0
  mov bx, 0x4256                               ; 0BEFA  0xBB, 0x56, 0x42
  mov al, [bx + 0x18]                          ; 0BEFD  0x8A, 0x47, 0x18
  call sub_0BC7B                               ; 0BF00  0xE8, 0x78, 0xFD
  mov [cs:0x506c], al                          ; 0BF03  0x2E, 0xA2, 0x6C, 0x50
  mov al, [bx + 0x17]                          ; 0BF07  0x8A, 0x47, 0x17
  call sub_0BC7B                               ; 0BF0A  0xE8, 0x6E, 0xFD
  cmp al, [cs:0x506b]                          ; 0BF0D  0x2E, 0x3A, 0x06, 0x6B, 0x50
  jb loc_0BF2E                                 ; 0BF12  0x72, 0x1A
  je loc_0BF3E                                 ; 0BF14  0x74, 0x28
  inc byte [cs:0x506c]                         ; 0BF16  0x2E, 0xFE, 0x06, 0x6C, 0x50
  mov al, [cs:0x506c]                          ; 0BF1B  0x2E, 0xA0, 0x6C, 0x50
  call sub_0C452                               ; 0BF1F  0xE8, 0x30, 0x05
  mov [bx + 0x18], al                          ; 0BF22  0x88, 0x47, 0x18
  db 0x8A, 0xC8                                ; 0BF25  mov cl, al
  mov ah, 0                                    ; 0BF27  0xB4, 0x00
  mov al, 0x18                                 ; 0BF29  0xB0, 0x18
  call sub_0BCCD                               ; 0BF2B  0xE8, 0x9F, 0xFD

loc_0BF2E:                                     ; 0BF2E
  mov al, [cs:0x506b]                          ; 0BF2E  0x2E, 0xA0, 0x6B, 0x50
  call sub_0C452                               ; 0BF32  0xE8, 0x1D, 0x05
  db 0x8A, 0xC8                                ; 0BF35  mov cl, al
  mov ah, 0                                    ; 0BF37  0xB4, 0x00
  mov al, 0x17                                 ; 0BF39  0xB0, 0x17
  call sub_0BCCD                               ; 0BF3B  0xE8, 0x8F, 0xFD

loc_0BF3E:                                     ; 0BF3E
  mov ax, 0x4e                                 ; 0BF3E  0xB8, 0x4E, 0x00

loc_0BF41:                                     ; 0BF41
  cmp al, [cs:0x506c]                          ; 0BF41  0x2E, 0x3A, 0x06, 0x6C, 0x50
  je loc_0BF60                                 ; 0BF46  0x74, 0x18
  test al, 3                                   ; 0BF48  0xA8, 0x03
  je loc_0BF56                                 ; 0BF4A  0x74, 0x0A
  db 0x2E, 0x81, 0x06, 0x67, 0x50, 0x6D, 0x01  ; 0BF4C  add word [cs:0x5067], 0x16d
  inc ax                                       ; 0BF53  0x40
  jmp short loc_0BF41                          ; 0BF54  0xEB, 0xEB

loc_0BF56:                                     ; 0BF56
  db 0x2E, 0x81, 0x06, 0x67, 0x50, 0x6E, 0x01  ; 0BF56  add word [cs:0x5067], 0x16e
  inc ax                                       ; 0BF5D  0x40
  jmp short loc_0BF41                          ; 0BF5E  0xEB, 0xE1

loc_0BF60:                                     ; 0BF60
  test byte [cs:0x506c], 3                     ; 0BF60  0x2E, 0xF6, 0x06, 0x6C, 0x50, 0x03
  je loc_0BF70                                 ; 0BF66  0x74, 0x08
  mov byte [cs:0x5069], 0                      ; 0BF68  0x2E, 0xC6, 0x06, 0x69, 0x50, 0x00
  jmp short loc_0BF76                          ; 0BF6E  0xEB, 0x06

loc_0BF70:                                     ; 0BF70
  mov byte [cs:0x5069], 0xff                   ; 0BF70  0x2E, 0xC6, 0x06, 0x69, 0x50, 0xFF

loc_0BF76:                                     ; 0BF76
  mov bx, 1                                    ; 0BF76  0xBB, 0x01, 0x00

loc_0BF79:                                     ; 0BF79
  cmp bl, [cs:0x506b]                          ; 0BF79  0x2E, 0x3A, 0x1E, 0x6B, 0x50
  je loc_0BF9E                                 ; 0BF7E  0x74, 0x1E
  cmp byte [cs:0x5069], 0xff                   ; 0BF80  0x2E, 0x80, 0x3E, 0x69, 0x50, 0xFF
  je loc_0BF8F                                 ; 0BF86  0x74, 0x07
  mov al, [cs:bx + 0x506d]                     ; 0BF88  0x2E, 0x8A, 0x87, 0x6D, 0x50
  jmp short loc_0BF94                          ; 0BF8D  0xEB, 0x05

loc_0BF8F:                                     ; 0BF8F
  mov al, [cs:bx + 0x507a]                     ; 0BF8F  0x2E, 0x8A, 0x87, 0x7A, 0x50

loc_0BF94:                                     ; 0BF94
  db 0x32, 0xE4                                ; 0BF94  xor ah, ah
  add [cs:0x5067], ax                          ; 0BF96  0x2E, 0x01, 0x06, 0x67, 0x50
  inc bx                                       ; 0BF9B  0x43
  jmp short loc_0BF79                          ; 0BF9C  0xEB, 0xDB

loc_0BF9E:                                     ; 0BF9E
  mov al, [cs:0x506a]                          ; 0BF9E  0x2E, 0xA0, 0x6A, 0x50
  db 0x32, 0xE4                                ; 0BFA2  xor ah, ah
  add ax, [cs:0x5067]                          ; 0BFA4  0x2E, 0x03, 0x06, 0x67, 0x50
  push es                                      ; 0BFA9  0x06
  mov es, [cs:0xc06]                           ; 0BFAA  0x2E, 0x8E, 0x06, 0x06, 0x0C
  mov [es:0x7e], ax                            ; 0BFAF  0x26, 0xA3, 0x7E, 0x00
  pop es                                       ; 0BFB3  0x07
  mov dx, PORT_PCB_T0_MAXA                     ; 0BFB4  0xBA, 0x52, 0xFF
  in ax, dx                                    ; 0BFB7  0xED
  mov si, 0x4667                               ; 0BFB8  0xBE, 0x67, 0x46
  cmp ax, strict word 0x1a                     ; 0BFBB  3D 1A 00
  je loc_0BFC3                                 ; 0BFBE  0x74, 0x03
  mov si, 0x4651                               ; 0BFC0  0xBE, 0x51, 0x46

loc_0BFC3:                                     ; 0BFC3
  mov [cs:0x467d], si                          ; 0BFC3  0x2E, 0x89, 0x36, 0x7D, 0x46
  call sub_0B991                               ; 0BFC8  0xE8, 0xC6, 0xF9
  mov bx, 0x4225                               ; 0BFCB  0xBB, 0x25, 0x42
  and byte [bx + 0x17], 0xdf                   ; 0BFCE  0x80, 0x67, 0x17, 0xDF
  cmp byte [bx + 0x17], 0x50                   ; 0BFD2  0x80, 0x7F, 0x17, 0x50
  jne loc_0BFE1                                ; 0BFD6  0x75, 0x09
  db 0x2E, 0xC7, 0x06, 0x3D, 0x59, 0x18, 0x00  ; 0BFD8  mov word [cs:0x593d], 0x18
  jmp short loc_0BFE1                          ; 0BFDF  0xEB, 0x00

loc_0BFE1:                                     ; 0BFE1
  mov bx, 0x4256                               ; 0BFE1  0xBB, 0x56, 0x42
  cmp byte [bx + 0x33], 1                      ; 0BFE4  0x80, 0x7F, 0x33, 0x01
  jne loc_0BFF9                                ; 0BFE8  0x75, 0x0F
  mov dl, 5                                    ; 0BFEA  0xB2, 0x05
  call sub_0B05E                               ; 0BFEC  0xE8, 0x6F, 0xF0
  mov bx, 0x4058                               ; 0BFEF  0xBB, 0x58, 0x40
  mov dx, PORT_ISBX_MCS0_02                    ; 0BFF2  0xBA, 0x02, 0x03
  in al, dx                                    ; 0BFF5  0xEC
  mov [bx + 0x1E], al                          ; 0BFF6  0x88, 0x47, 0x1E

loc_0BFF9:                                     ; 0BFF9
  mov es, [cs:0x5064]                          ; 0BFF9  0x2E, 0x8E, 0x06, 0x64, 0x50
  mov cl, 0x86                                 ; 0BFFE  0xB1, 0x86
  mov dx, 0x5951                               ; 0C000  0xBA, 0x51, 0x59
  call rtm_timer_wait2                         ; 0C003  0xE8, 0xCD, 0xB8
  mov cl, 0x87                                 ; 0C006  0xB1, 0x87
  mov dx, 0x596d                               ; 0C008  0xBA, 0x6D, 0x59
  call rtm_timer_wait2                         ; 0C00B  0xE8, 0xC5, 0xB8
  mov cl, 0x8b                                 ; 0C00E  0xB1, 0x8B
  mov dx, 0x596d                               ; 0C010  0xBA, 0x6D, 0x59
  call rtm_timer_wait2                         ; 0C013  0xE8, 0xBD, 0xB8
  mov cl, 0x86                                 ; 0C016  0xB1, 0x86
  mov dx, 0x597d                               ; 0C018  0xBA, 0x7D, 0x59
  call rtm_timer_wait2                         ; 0C01B  0xE8, 0xB5, 0xB8
  mov cl, 0x87                                 ; 0C01E  0xB1, 0x87
  mov dx, 0x5999                               ; 0C020  0xBA, 0x99, 0x59
  call rtm_timer_wait2                         ; 0C023  0xE8, 0xAD, 0xB8
  mov cl, 0x8b                                 ; 0C026  0xB1, 0x8B
  mov dx, 0x5999                               ; 0C028  0xBA, 0x99, 0x59
  call rtm_timer_wait2                         ; 0C02B  0xE8, 0xA5, 0xB8
  mov cl, 0x86                                 ; 0C02E  0xB1, 0x86
  mov dx, 0x59a9                               ; 0C030  0xBA, 0xA9, 0x59
  call rtm_timer_wait2                         ; 0C033  0xE8, 0x9D, 0xB8
  mov cl, 0x87                                 ; 0C036  0xB1, 0x87
  mov dx, 0x59c5                               ; 0C038  0xBA, 0xC5, 0x59
  call rtm_timer_wait2                         ; 0C03B  0xE8, 0x95, 0xB8
  mov cl, 0x8b                                 ; 0C03E  0xB1, 0x8B
  mov dx, 0x59c5                               ; 0C040  0xBA, 0xC5, 0x59
  call rtm_timer_wait2                         ; 0C043  0xE8, 0x8D, 0xB8
  mov cl, 0x86                                 ; 0C046  0xB1, 0x86
  mov dx, 0x5ade                               ; 0C048  0xBA, 0xDE, 0x5A
  call rtm_timer_wait2                         ; 0C04B  0xE8, 0x85, 0xB8
  mov cl, 0x87                                 ; 0C04E  0xB1, 0x87
  mov dx, 0x5afa                               ; 0C050  0xBA, 0xFA, 0x5A
  call rtm_timer_wait2                         ; 0C053  0xE8, 0x7D, 0xB8
  mov cl, 0x8b                                 ; 0C056  0xB1, 0x8B
  mov dx, 0x5afa                               ; 0C058  0xBA, 0xFA, 0x5A
  call rtm_timer_wait2                         ; 0C05B  0xE8, 0x75, 0xB8
  mov cl, 0x86                                 ; 0C05E  0xB1, 0x86
  mov dx, 0x59d5                               ; 0C060  0xBA, 0xD5, 0x59
  call rtm_timer_wait2                         ; 0C063  0xE8, 0x6D, 0xB8
  mov cl, 0x86                                 ; 0C066  0xB1, 0x86
  mov dx, 0x59f1                               ; 0C068  0xBA, 0xF1, 0x59
  call rtm_timer_wait2                         ; 0C06B  0xE8, 0x65, 0xB8
  mov cl, 0x86                                 ; 0C06E  0xB1, 0x86
  mov dx, 0x5ab2                               ; 0C070  0xBA, 0xB2, 0x5A
  call rtm_timer_wait2                         ; 0C073  0xE8, 0x5D, 0xB8
  mov cl, 0x87                                 ; 0C076  0xB1, 0x87
  mov dx, 0x5ace                               ; 0C078  0xBA, 0xCE, 0x5A
  call rtm_timer_wait2                         ; 0C07B  0xE8, 0x55, 0xB8
  mov cl, 0x8b                                 ; 0C07E  0xB1, 0x8B
  mov dx, 0x5ace                               ; 0C080  0xBA, 0xCE, 0x5A
  call rtm_timer_wait2                         ; 0C083  0xE8, 0x4D, 0xB8
  mov al, [cs:0x376c]                          ; 0C086  0x2E, 0xA0, 0x6C, 0x37

fdc_dma_scroll_cmd:                            ; 0C08A
  mov dx, PORT_FDC_CTRL                        ; 0C08A  0xBA, 0x88, 0x02
  out dx, al                                   ; 0C08D  0xEE
  mov dx, PORT_FDC_CMD                         ; 0C08E  0xBA, 0x80, 0x02
  in al, dx                                    ; 0C091  0xEC
  mov dx, PORT_PRN_RELEASE                     ; 0C092  0xBA, 0x94, 0x02
  out dx, al                                   ; 0C095  0xEE
  mov bx, 0x4225                               ; 0C096  0xBB, 0x25, 0x42
  mov cl, [bx + 0x13]                          ; 0C099  0x8A, 0x4F, 0x13
  mov bx, 0                                    ; 0C09C  0xBB, 0x00, 0x00

loc_0C09F:                                     ; 0C09F
  cmp cl, 0                                    ; 0C09F  0x80, 0xF9, 0x00
  je loc_0C0AF                                 ; 0C0A2  0x74, 0x0B
  mov byte [cs:bx + 0x3932], 1                 ; 0C0A4  0x2E, 0xC6, 0x87, 0x32, 0x39, 0x01
  inc bx                                       ; 0C0AA  0x43
  dec cl                                       ; 0C0AB  0xFE, 0xC9
  jmp short loc_0C09F                          ; 0C0AD  0xEB, 0xF0

loc_0C0AF:                                     ; 0C0AF
  mov bx, 0x4225                               ; 0C0AF  0xBB, 0x25, 0x42
  les di, [bx]                                 ; 0C0B2  0xC4, 0x3F
  mov ax, es                                   ; 0C0B4  0x8C, 0xC0
  mov cl, 6                                    ; 0C0B6  0xB1, 0x06
  shl ax, cl                                   ; 0C0B8  0xD3, 0xE0
  mov cl, 0xa                                  ; 0C0BA  0xB1, 0x0A
  shr di, cl                                   ; 0C0BC  0xD3, 0xEF
  db 0x03, 0xC7                                ; 0C0BE  add ax, di
  mov [cs:0x593f], ax                          ; 0C0C0  0x2E, 0xA3, 0x3F, 0x59
  mov bx, [cs:0x593d]                          ; 0C0C4  0x2E, 0x8B, 0x1E, 0x3D, 0x59
  sub [cs:0x593f], bx                          ; 0C0C9  0x2E, 0x29, 0x1E, 0x3F, 0x59
  mov di, 0x4a73                               ; 0C0CE  0xBF, 0x73, 0x4A
  call sub_0C468                               ; 0C0D1  0xE8, 0x94, 0x03
  mov si, 0x4a48                               ; 0C0D4  0xBE, 0x48, 0x4A
  call sub_0C43F                               ; 0C0D7  0xE8, 0x65, 0x03
  mov bx, 0x4225                               ; 0C0DA  0xBB, 0x25, 0x42
  mov al, [bx + 0x13]                          ; 0C0DD  0x8A, 0x47, 0x13
  db 0x32, 0xE4                                ; 0C0E0  xor ah, ah
  db 0x0A, 0xC0                                ; 0C0E2  or al, al
  je loc_0C0FD                                 ; 0C0E4  0x74, 0x17
  cmp al, 1                                    ; 0C0E6  0x3C, 0x01
  jne loc_0C0F1                                ; 0C0E8  0x75, 0x07
  mov bx, 0x3932                               ; 0C0EA  0xBB, 0x32, 0x39
  mov byte [bx + 1], 0                         ; 0C0ED  0xC6, 0x47, 0x01, 0x00

loc_0C0F1:                                     ; 0C0F1
  mov di, 0x4aac                               ; 0C0F1  0xBF, 0xAC, 0x4A
  call sub_0C468                               ; 0C0F4  0xE8, 0x71, 0x03
  mov si, 0x4aac                               ; 0C0F7  0xBE, 0xAC, 0x4A
  call sub_0C43F                               ; 0C0FA  0xE8, 0x42, 0x03

loc_0C0FD:                                     ; 0C0FD
  jmp near loc_0C11A                           ; 0C0FD  0xE9, 0x1A, 0x00
  mov bx, 0x4225                               ; 0C100  0xBB, 0x25, 0x42
  mov al, [cs:0x5066]                          ; 0C103  0x2E, 0xA0, 0x66, 0x50
  sub al, [bx + 0x13]                          ; 0C107  0x2A, 0x47, 0x13
  je loc_0C11A                                 ; 0C10A  0x74, 0x0E
  db 0x32, 0xE4                                ; 0C10C  xor ah, ah
  mov di, 0x4ac9                               ; 0C10E  0xBF, 0xC9, 0x4A
  call sub_0C468                               ; 0C111  0xE8, 0x54, 0x03
  mov si, 0x4ac9                               ; 0C114  0xBE, 0xC9, 0x4A
  call sub_0C43F                               ; 0C117  0xE8, 0x25, 0x03

loc_0C11A:                                     ; 0C11A
  mov bx, 0x4256                               ; 0C11A  0xBB, 0x56, 0x42
  mov al, [bx + 0x34]                          ; 0C11D  0x8A, 0x47, 0x34
  mov [cs:0x4b], al                            ; 0C120  0x2E, 0xA2, 0x4B, 0x00
  mov [cs:0x50], al                            ; 0C124  0x2E, 0xA2, 0x50, 0x00
  mov bx, 0x4256                               ; 0C128  0xBB, 0x56, 0x42
  mov ax, [cs:0x593f]                          ; 0C12B  0x2E, 0xA1, 0x3F, 0x59
  mov bl, [bx + 0x1b]                          ; 0C12F  0x8A, 0x5F, 0x1B
  mov bh, 0                                    ; 0C132  0xB7, 0x00
  mov cl, 6                                    ; 0C134  0xB1, 0x06
  shl bx, cl                                   ; 0C136  0xD3, 0xE3
  db 0x2B, 0xC3                                ; 0C138  sub ax, bx
  mov bx, [cs:0x44]                            ; 0C13A  0x2E, 0x8B, 0x1E, 0x44, 0x00
  mov cl, 6                                    ; 0C13F  0xB1, 0x06
  shr bx, cl                                   ; 0C141  0xD3, 0xEB
  add bx, 0x40                                 ; 0C143  0x83, 0xC3, 0x40
  db 0x3B, 0xC3                                ; 0C146  cmp ax, bx
  ja loc_0C153                                 ; 0C148  0x77, 0x09
  mov si, 0x4b35                               ; 0C14A  0xBE, 0x35, 0x4B
  call sub_0C43F                               ; 0C14D  0xE8, 0xEF, 0x02
  jmp near loc_0C1A5                           ; 0C150  0xE9, 0x52, 0x00

loc_0C153:                                     ; 0C153
  mov [cs:0x593f], ax                          ; 0C153  0x2E, 0xA3, 0x3F, 0x59
  push es                                      ; 0C157  0x06
  mov cl, 6                                    ; 0C158  0xB1, 0x06
  shl ax, cl                                   ; 0C15A  0xD3, 0xE0
  mov [cs:0x35b7], ax                          ; 0C15C  0x2E, 0xA3, 0xB7, 0x35
  mov bx, 0x4256                               ; 0C160  0xBB, 0x56, 0x42
  mov al, [bx + 0x1b]                          ; 0C163  0x8A, 0x47, 0x1B
  db 0x0A, 0xC0                                ; 0C166  or al, al
  je loc_0C1A4                                 ; 0C168  0x74, 0x3A
  db 0x32, 0xE4                                ; 0C16A  xor ah, ah
  mov cl, 6                                    ; 0C16C  0xB1, 0x06
  shl ax, cl                                   ; 0C16E  0xD3, 0xE0
  dec ax                                       ; 0C170  0x48
  mov [cs:0x3b64], ax                          ; 0C171  0x2E, 0xA3, 0x64, 0x3B
  inc ax                                       ; 0C175  0x40
  mov di, 0x4b1e                               ; 0C176  0xBF, 0x1E, 0x4B
  call sub_0C468                               ; 0C179  0xE8, 0xEC, 0x02
  mov si, 0x4b1e                               ; 0C17C  0xBE, 0x1E, 0x4B
  call sub_0C43F                               ; 0C17F  0xE8, 0xBD, 0x02
  mov byte [cs:0x50], 0xc                      ; 0C182  0x2E, 0xC6, 0x06, 0x50, 0x00, 0x0C
  mov bx, 0x3932                               ; 0C188  0xBB, 0x32, 0x39
  mov byte [bx + 0xc], 0xc0                    ; 0C18B  0xC6, 0x47, 0x0C, 0xC0
  mov ax, [cs:0x35b7]                          ; 0C18F  0x2E, 0xA1, 0xB7, 0x35
  mov es, ax                                   ; 0C193  0x8E, 0xC0
  db 0x33, 0xFF                                ; 0C195  xor di, di
  mov ax, 0xe5e5                               ; 0C197  0xB8, 0xE5, 0xE5
  cmp [es:di], ax                              ; 0C19A  0x26, 0x39, 0x05
  je loc_0C1A4                                 ; 0C19D  0x74, 0x05
  mov cx, 0x2000                               ; 0C19F  0xB9, 0x00, 0x20
  rep stosw                                    ; 0C1A2  0xF3, 0xAB

loc_0C1A4:                                     ; 0C1A4
  pop es                                       ; 0C1A4  0x07

loc_0C1A5:                                     ; 0C1A5
  mov cx, 0x10                                 ; 0C1A5  0xB9, 0x10, 0x00

loc_0C1A8:                                     ; 0C1A8
  push cx                                      ; 0C1A8  0x51
  dec cl                                       ; 0C1A9  0xFE, 0xC9
  mov dl, 0                                    ; 0C1AB  0xB2, 0x00
  call sub_0991B                               ; 0C1AD  0xE8, 0x6B, 0xD7
  db 0x0B, 0xDB                                ; 0C1B0  or bx, bx
  je loc_0C220                                 ; 0C1B2  0x74, 0x6C
  mov ax, [cs:0x5941]                          ; 0C1B4  0x2E, 0xA1, 0x41, 0x59
  mov [bx + 0xa], ax                           ; 0C1B8  0x89, 0x47, 0x0A
  push bx                                      ; 0C1BB  0x53
  mov bx, [bx + 8]                             ; 0C1BC  0x8B, 0x5F, 0x08
  mov ax, [bx + 0xb]                           ; 0C1BF  0x8B, 0x47, 0x0B
  and ax, 0x7fff                               ; 0C1C2  0x25, 0xFF, 0x7F
  pop bx                                       ; 0C1C5  0x5B
  jne loc_0C1CF                                ; 0C1C6  0x75, 0x07
  mov word [bx + 0xa], 0                       ; 0C1C8  0xC7, 0x47, 0x0A, 0x00, 0x00
  jmp short loc_0C1E1                          ; 0C1CD  0xEB, 0x12

loc_0C1CF:                                     ; 0C1CF
  push bx                                      ; 0C1CF  0x53
  mov bx, [bx + 8]                             ; 0C1D0  0x8B, 0x5F, 0x08
  mov ax, [bx + 7]                             ; 0C1D3  0x8B, 0x47, 0x07
  mov cl, 2                                    ; 0C1D6  0xB1, 0x02
  shr ax, cl                                   ; 0C1D8  0xD3, 0xE8
  inc ax                                       ; 0C1DA  0x40
  add [cs:0x5941], ax                          ; 0C1DB  0x2E, 0x01, 0x06, 0x41, 0x59
  pop bx                                       ; 0C1E0  0x5B

loc_0C1E1:                                     ; 0C1E1
  push bx                                      ; 0C1E1  0x53
  mov bx, [bx + 8]                             ; 0C1E2  0x8B, 0x5F, 0x08
  mov ax, [bx + 7]                             ; 0C1E5  0x8B, 0x47, 0x07
  inc ax                                       ; 0C1E8  0x40
  mov cl, 2                                    ; 0C1E9  0xB1, 0x02
  shl ax, cl                                   ; 0C1EB  0xD3, 0xE0
  add ax, 0x3ff                                ; 0C1ED  0x05, 0xFF, 0x03
  mov cl, 0xa                                  ; 0C1F0  0xB1, 0x0A
  shr ax, cl                                   ; 0C1F2  0xD3, 0xE8
  sub [cs:0x593f], ax                          ; 0C1F4  0x2E, 0x29, 0x06, 0x3F, 0x59
  pop bx                                       ; 0C1F9  0x5B
  mov ax, [cs:0x593f]                          ; 0C1FA  0x2E, 0xA1, 0x3F, 0x59
  mov cl, 6                                    ; 0C1FE  0xB1, 0x06
  shl ax, cl                                   ; 0C200  0xD3, 0xE0
  mov [bx + 0x12], ax                          ; 0C202  0x89, 0x47, 0x12
  mov ax, [cs:0x5941]                          ; 0C205  0x2E, 0xA1, 0x41, 0x59
  mov [bx + 0xc], ax                           ; 0C209  0x89, 0x47, 0x0C
  push bx                                      ; 0C20C  0x53
  mov bx, [bx + 8]                             ; 0C20D  0x8B, 0x5F, 0x08
  mov ax, [bx + 5]                             ; 0C210  0x8B, 0x47, 0x05
  pop bx                                       ; 0C213  0x5B
  mov cl, 3                                    ; 0C214  0xB1, 0x03
  shr ax, cl                                   ; 0C216  0xD3, 0xE8
  inc ax                                       ; 0C218  0x40
  shl ax, 1                                    ; 0C219  0xD1, 0xE0
  add [cs:0x5941], ax                          ; 0C21B  0x2E, 0x01, 0x06, 0x41, 0x59

loc_0C220:                                     ; 0C220
  pop cx                                       ; 0C220  0x59
  dec cx                                       ; 0C221  0x49
  je loc_0C227                                 ; 0C222  0x74, 0x03
  jmp near loc_0C1A8                           ; 0C224  0xE9, 0x81, 0xFF

loc_0C227:                                     ; 0C227
  mov bx, 0x4225                               ; 0C227  0xBB, 0x25, 0x42
  mov dl, [cs:0x5066]                          ; 0C22A  0x2E, 0x8A, 0x16, 0x66, 0x50
  db 0x2E, 0xC7, 0x06, 0x4F, 0x59, 0x20, 0x04  ; 0C22F  mov word [cs:0x594f], 0x420
  mov bx, 0x4256                               ; 0C236  0xBB, 0x56, 0x42
  mov cl, [bx + 0x1A]                          ; 0C239  0x8A, 0x4F, 0x1A
  mov ch, 0                                    ; 0C23C  0xB5, 0x00
  push cx                                      ; 0C23E  0x51
  mov bx, [cs:0x44]                            ; 0C23F  0x2E, 0x8B, 0x1E, 0x44, 0x00
  mov cl, 6                                    ; 0C244  0xB1, 0x06
  shr bx, cl                                   ; 0C246  0xD3, 0xEB
  pop cx                                       ; 0C248  0x59
  mov ax, [cs:0x593f]                          ; 0C249  0x2E, 0xA1, 0x3F, 0x59
  db 0x2B, 0xC3                                ; 0C24D  sub ax, bx
  sub ax, strict word 0x40                     ; 0C24F  2D 40 00

loc_0C252:                                     ; 0C252
  db 0x3B, 0xC8                                ; 0C252  cmp cx, ax
  jb loc_0C259                                 ; 0C254  0x72, 0x03
  dec cx                                       ; 0C256  0x49
  jmp short loc_0C252                          ; 0C257  0xEB, 0xF9

loc_0C259:                                     ; 0C259
  db 0x3A, 0xCA                                ; 0C259  cmp cl, dl
  jb loc_0C25F                                 ; 0C25B  0x72, 0x02
  jmp short loc_0C261                          ; 0C25D  0xEB, 0x02

loc_0C25F:                                     ; 0C25F
  db 0x8A, 0xCA                                ; 0C25F  mov cl, dl

loc_0C261:                                     ; 0C261
  sub [cs:0x593f], cx                          ; 0C261  0x2E, 0x29, 0x0E, 0x3F, 0x59
  mov ax, [cs:0x593f]                          ; 0C266  0x2E, 0xA1, 0x3F, 0x59
  push cx                                      ; 0C26A  0x51
  mov cl, 6                                    ; 0C26B  0xB1, 0x06
  shl ax, cl                                   ; 0C26D  0xD3, 0xE0
  mov [cs:0x593b], ax                          ; 0C26F  0x2E, 0xA3, 0x3B, 0x59
  pop cx                                       ; 0C273  0x59
  mov bx, 0x3bc2                               ; 0C274  0xBB, 0xC2, 0x3B
  mov ax, [cs:0x5941]                          ; 0C277  0x2E, 0xA1, 0x41, 0x59
  mov [bx], ax                                 ; 0C27B  0x89, 0x07
  mov [bx + 2], cl                             ; 0C27D  0x88, 0x4F, 0x02
  db 0x0A, 0xC9                                ; 0C280  or cl, cl
  je loc_0C2C9                                 ; 0C282  0x74, 0x45

loc_0C284:                                     ; 0C284
  push ax                                      ; 0C284  0x50
  mov ax, [cs:0x5943]                          ; 0C285  0x2E, 0xA1, 0x43, 0x59
  sub ax, [cs:0x5941]                          ; 0C289  0x2E, 0x2B, 0x06, 0x41, 0x59
  cmp ax, [cs:0x594f]                          ; 0C28E  0x2E, 0x3B, 0x06, 0x4F, 0x59
  pop ax                                       ; 0C293  0x58
  jb loc_0C2C4                                 ; 0C294  0x72, 0x2E
  add word [cs:0x5941], 0x10                   ; 0C296  0x2E, 0x83, 0x06, 0x41, 0x59, 0x10
  db 0x8B, 0xD8                                ; 0C29C  mov bx, ax
  db 0x8B, 0xFB                                ; 0C29E  mov di, bx
  push cx                                      ; 0C2A0  0x51
  mov cx, 8                                    ; 0C2A1  0xB9, 0x08, 0x00
  db 0x33, 0xC0                                ; 0C2A4  xor ax, ax
  push ds                                      ; 0C2A6  0x1E
  pop es                                       ; 0C2A7  0x07
  rep stosw                                    ; 0C2A8  0xF3, 0xAB
  pop cx                                       ; 0C2AA  0x59
  mov byte [bx], 0xff                          ; 0C2AB  0xC6, 0x07, 0xFF
  mov ax, [cs:0x593b]                          ; 0C2AE  0x2E, 0xA1, 0x3B, 0x59
  mov [bx + 0xa], ax                           ; 0C2B2  0x89, 0x47, 0x0A
  add word [cs:0x593b], 0x40                   ; 0C2B5  0x2E, 0x83, 0x06, 0x3B, 0x59, 0x40
  mov ax, [cs:0x5941]                          ; 0C2BB  0x2E, 0xA1, 0x41, 0x59
  mov [bx + 0xc], ax                           ; 0C2BF  0x89, 0x47, 0x0C
  loop loc_0C284                               ; 0C2C2  0xE2, 0xC0

loc_0C2C4:                                     ; 0C2C4
  mov word [bx + 0xc], 0                       ; 0C2C4  0xC7, 0x47, 0x0C, 0x00, 0x00

loc_0C2C9:                                     ; 0C2C9
  mov bx, 0x3bc2                               ; 0C2C9  0xBB, 0xC2, 0x3B
  sub [bx + 2], cl                             ; 0C2CC  0x28, 0x4F, 0x02
  mov al, [bx + 2]                             ; 0C2CF  0x8A, 0x47, 0x02
  db 0x32, 0xE4                                ; 0C2D2  xor ah, ah
  db 0x0B, 0xC0                                ; 0C2D4  or ax, ax
  je loc_0C33F                                 ; 0C2D6  0x74, 0x67
  mov di, 0x4aed                               ; 0C2D8  0xBF, 0xED, 0x4A
  call sub_0C468                               ; 0C2DB  0xE8, 0x8A, 0x01
  mov si, 0x4aed                               ; 0C2DE  0xBE, 0xED, 0x4A
  call sub_0C43F                               ; 0C2E1  0xE8, 0x5B, 0x01
  mov bx, 0x3bb3                               ; 0C2E4  0xBB, 0xB3, 0x3B
  mov ax, [cs:0x5941]                          ; 0C2E7  0x2E, 0xA1, 0x41, 0x59
  mov [bx], ax                                 ; 0C2EB  0x89, 0x07
  mov cl, 0                                    ; 0C2ED  0xB1, 0x00

loc_0C2EF:                                     ; 0C2EF
  mov ax, [cs:0x5941]                          ; 0C2EF  0x2E, 0xA1, 0x41, 0x59
  add ax, 0x410                                ; 0C2F3  0x05, 0x10, 0x04
  cmp ax, [cs:0x5943]                          ; 0C2F6  0x2E, 0x3B, 0x06, 0x43, 0x59
  ja loc_0C324                                 ; 0C2FB  0x77, 0x27
  mov bx, [cs:0x5941]                          ; 0C2FD  0x2E, 0x8B, 0x1E, 0x41, 0x59
  add word [cs:0x5941], 0x10                   ; 0C302  0x2E, 0x83, 0x06, 0x41, 0x59, 0x10
  mov byte [bx], 0xff                          ; 0C308  0xC6, 0x07, 0xFF
  mov ax, [cs:0x5941]                          ; 0C30B  0x2E, 0xA1, 0x41, 0x59
  mov [bx + 0xa], ax                           ; 0C30F  0x89, 0x47, 0x0A
  db 0x2E, 0x81, 0x06, 0x41, 0x59, 0x00, 0x04  ; 0C312  add word [cs:0x5941], 0x400
  mov ax, [cs:0x5941]                          ; 0C319  0x2E, 0xA1, 0x41, 0x59
  mov [bx + 0xc], ax                           ; 0C31D  0x89, 0x47, 0x0C
  inc cl                                       ; 0C320  0xFE, 0xC1
  jmp short loc_0C2EF                          ; 0C322  0xEB, 0xCB

loc_0C324:                                     ; 0C324
  mov word [bx + 0xc], 0                       ; 0C324  0xC7, 0x47, 0x0C, 0x00, 0x00
  mov bx, 0x3bb3                               ; 0C329  0xBB, 0xB3, 0x3B
  mov [bx + 2], cl                             ; 0C32C  0x88, 0x4F, 0x02
  db 0x8A, 0xC1                                ; 0C32F  mov al, cl
  db 0x32, 0xE4                                ; 0C331  xor ah, ah
  mov di, 0x4b04                               ; 0C333  0xBF, 0x04, 0x4B
  call sub_0C468                               ; 0C336  0xE8, 0x2F, 0x01
  mov si, 0x4b04                               ; 0C339  0xBE, 0x04, 0x4B
  call sub_0C43F                               ; 0C33C  0xE8, 0x00, 0x01

loc_0C33F:                                     ; 0C33F
  mov ax, [cs:0x593f]                          ; 0C33F  0x2E, 0xA1, 0x3F, 0x59
  mov cl, 6                                    ; 0C343  0xB1, 0x06
  shl ax, cl                                   ; 0C345  0xD3, 0xE0
  sub ax, strict word 0x10                     ; 0C347  2D 10 00
  mov [cs:0x4058], ax                          ; 0C34A  0x2E, 0xA3, 0x58, 0x40
  db 0x2E, 0xC7, 0x06, 0x5A, 0x40, 0x00, 0x01  ; 0C34E  mov word [cs:0x405a], 0x100
  db 0x2E, 0xC7, 0x06, 0x60, 0x40, 0x00, 0x01  ; 0C355  mov word [cs:0x4060], 0x100
  sub ax, strict word 1                        ; 0C35C  2D 01 00
  mov [cs:0x4062], ax                          ; 0C35F  0x2E, 0xA3, 0x62, 0x40
  db 0x2E, 0xC7, 0x06, 0x64, 0x40, 0x10, 0x00  ; 0C363  mov word [cs:0x4064], 0x10
  db 0x2E, 0xC7, 0x06, 0x6A, 0x40, 0x10, 0x00  ; 0C36A  mov word [cs:0x406a], 0x10
  push ax                                      ; 0C371  0x50
  mov cl, 6                                    ; 0C372  0xB1, 0x06
  shr ax, cl                                   ; 0C374  0xD3, 0xE8
  mov [cs:0x593f], ax                          ; 0C376  0x2E, 0xA3, 0x3F, 0x59
  pop cx                                       ; 0C37A  0x59
  mov bx, 0x5a                                 ; 0C37B  0xBB, 0x5A, 0x00

loc_0C37E:                                     ; 0C37E
  db 0x8B, 0xF3                                ; 0C37E  mov si, bx
  mov bx, [bx]                                 ; 0C380  0x8B, 0x1F
  test bx, bx                                  ; 0C382  0x85, 0xDB
  je loc_0C3C1                                 ; 0C384  0x74, 0x3B
  mov ax, [bx + 2]                             ; 0C386  0x8B, 0x47, 0x02
  add ax, [bx + 4]                             ; 0C389  0x03, 0x47, 0x04
  db 0x3B, 0xC1                                ; 0C38C  cmp ax, cx
  jbe loc_0C37E                                ; 0C38E  0x76, 0xEE
  mov ax, [bx + 2]                             ; 0C390  0x8B, 0x47, 0x02
  db 0x2B, 0xC8                                ; 0C393  sub cx, ax
  jbe loc_0C3A8                                ; 0C395  0x76, 0x11
  mov [bx + 4], cx                             ; 0C397  0x89, 0x4F, 0x04
  mov si, [bx]                                 ; 0C39A  0x8B, 0x37
  test si, si                                  ; 0C39C  0x85, 0xF6
  je loc_0C3C1                                 ; 0C39E  0x74, 0x21
  mov word [bx], 0                             ; 0C3A0  0xC7, 0x07, 0x00, 0x00
  db 0x8B, 0xDE                                ; 0C3A4  mov bx, si
  jmp short loc_0C3AE                          ; 0C3A6  0xEB, 0x06

loc_0C3A8:                                     ; 0C3A8
  mov word [si], 0                             ; 0C3A8  0xC7, 0x04, 0x00, 0x00
  db 0x8B, 0xF3                                ; 0C3AC  mov si, bx

loc_0C3AE:                                     ; 0C3AE
  db 0x8B, 0xFB                                ; 0C3AE  mov di, bx
  mov bx, [bx]                                 ; 0C3B0  0x8B, 0x1F
  test bx, bx                                  ; 0C3B2  0x85, 0xDB
  jne loc_0C3AE                                ; 0C3B4  0x75, 0xF8
  mov ax, [cs:0x58]                            ; 0C3B6  0x2E, 0xA1, 0x58, 0x00
  mov [cs:0x58], si                            ; 0C3BA  0x2E, 0x89, 0x36, 0x58, 0x00
  mov [di], ax                                 ; 0C3BF  0x89, 0x05

loc_0C3C1:                                     ; 0C3C1
  mov ax, [cs:0x593f]                          ; 0C3C1  0x2E, 0xA1, 0x3F, 0x59
  mov bx, [cs:0x44]                            ; 0C3C5  0x2E, 0x8B, 0x1E, 0x44, 0x00
  mov cl, 6                                    ; 0C3CA  0xB1, 0x06
  shr bx, cl                                   ; 0C3CC  0xD3, 0xEB
  db 0x2B, 0xC3                                ; 0C3CE  sub ax, bx
  mov di, 0x4a8f                               ; 0C3D0  0xBF, 0x8F, 0x4A
  call sub_0C468                               ; 0C3D3  0xE8, 0x92, 0x00
  mov si, 0x4a8f                               ; 0C3D6  0xBE, 0x8F, 0x4A
  call sub_0C43F                               ; 0C3D9  0xE8, 0x63, 0x00
  db 0x33, 0xC0                                ; 0C3DC  xor ax, ax
  or ax, [cs:0x589d]                           ; 0C3DE  0x2E, 0x0B, 0x06, 0x9D, 0x58
  mov ax, 0xa0                                 ; 0C3E3  0xB8, 0xA0, 0x00
  je loc_0C420                                 ; 0C3E6  0x74, 0x38
  db 0x33, 0xC0                                ; 0C3E8  xor ax, ax
  mov es, ax                                   ; 0C3EA  0x8E, 0xC0
  mov di, 0x94                                 ; 0C3EC  0xBF, 0x94, 0x00
  mov ax, 0x46c0                               ; 0C3EF  0xB8, 0xC0, 0x46
  stosw                                        ; 0C3F2  0xAB
  mov ax, cs                                   ; 0C3F3  0x8C, 0xC8
  stosw                                        ; 0C3F5  0xAB
  db 0x2E, 0xC7, 0x06, 0x8C, 0x00, 0x00, 0x00  ; 0C3F6  mov word [cs:0x8c], 0
  db 0x2E, 0xC7, 0x06, 0xA2, 0x00, 0x00, 0x00  ; 0C3FD  mov word [cs:0xa2], 0
  db 0x2E, 0xC7, 0x06, 0xA0, 0x00, 0x94, 0x00  ; 0C404  mov word [cs:0xa0], 0x94
  mov [cs:0xa6], cs                            ; 0C40B  0x2E, 0x8C, 0x0E, 0xA6, 0x00
  db 0x2E, 0xC7, 0x06, 0xA4, 0x00, 0xC0, 0x46  ; 0C410  mov word [cs:0xa4], 0x46c0
  mov si, 0x4b78                               ; 0C417  0xBE, 0x78, 0x4B
  call sub_0C43F                               ; 0C41A  0xE8, 0x22, 0x00
  mov ax, 0x80                                 ; 0C41D  0xB8, 0x80, 0x00

loc_0C420:                                     ; 0C420
  push ax                                      ; 0C420  0x50
  mov bx, 0x4225                               ; 0C421  0xBB, 0x25, 0x42
  cmp byte [bx + 0xd], 0xff                    ; 0C424  0x80, 0x7F, 0x0D, 0xFF
  jne loc_0C430                                ; 0C428  0x75, 0x06
  mov si, 0x4b57                               ; 0C42A  0xBE, 0x57, 0x4B
  call sub_0C43F                               ; 0C42D  0xE8, 0x0F, 0x00

loc_0C430:                                     ; 0C430
  mov dx, PORT_PCB_IMR                         ; 0C430  0xBA, 0x28, 0xFF
  mov ax, 0x41                                 ; 0C433  0xB8, 0x41, 0x00
  out dx, ax                                   ; 0C436  0xEF
  pop ax                                       ; 0C437  0x58
  mov dx, 2                                    ; 0C438  0xBA, 0x02, 0x00
  out dx, ax                                   ; 0C43B  0xEF
  retf                                         ; 0C43C  0xCB
  db 0x00, 0x00                                ; 0C43D  ..

sub_0C43F:                                     ; 0C43F
  db 0x32, 0xD2                                ; 0C43F  xor dl, dl

loc_0C441:                                     ; 0C441
  mov cl, [si]                                 ; 0C441  0x8A, 0x0C
  test cl, cl                                  ; 0C443  0x84, 0xC9
  je loc_0C451                                 ; 0C445  0x74, 0x0A
  push dx                                      ; 0C447  0x52
  push si                                      ; 0C448  0x56
  call sub_07FCC                               ; 0C449  0xE8, 0x80, 0xBB
  pop si                                       ; 0C44C  0x5E
  pop dx                                       ; 0C44D  0x5A
  inc si                                       ; 0C44E  0x46
  jmp short loc_0C441                          ; 0C44F  0xEB, 0xF0

loc_0C451:                                     ; 0C451
  ret                                          ; 0C451  0xC3

sub_0C452:                                     ; 0C452
  push dx                                      ; 0C452  0x52
  push bx                                      ; 0C453  0x53
  push cx                                      ; 0C454  0x51
  db 0x33, 0xD2                                ; 0C455  xor dx, dx
  db 0x32, 0xE4                                ; 0C457  xor ah, ah
  mov bx, 0xa                                  ; 0C459  0xBB, 0x0A, 0x00
  db 0xF7, 0xFB                                ; 0C45C  idiv bx
  mov cl, 4                                    ; 0C45E  0xB1, 0x04
  shl al, cl                                   ; 0C460  0xD2, 0xE0
  db 0x0A, 0xC2                                ; 0C462  or al, dl
  pop cx                                       ; 0C464  0x59
  pop bx                                       ; 0C465  0x5B
  pop dx                                       ; 0C466  0x5A
  ret                                          ; 0C467  0xC3

sub_0C468:                                     ; 0C468
  push cx                                      ; 0C468  0x51
  push bx                                      ; 0C469  0x53
  push dx                                      ; 0C46A  0x52
  push si                                      ; 0C46B  0x56
  push di                                      ; 0C46C  0x57
  mov si, 0                                    ; 0C46D  0xBE, 0x00, 0x00

loc_0C470:                                     ; 0C470
  db 0x2B, 0xD2                                ; 0C470  sub dx, dx
  db 0x2E, 0xF7, 0xBC, 0x45, 0x59              ; 0C472  idiv word [cs:si + 0x5945]
  mov bl, 0x30                                 ; 0C477  0xB3, 0x30
  db 0x02, 0xC3                                ; 0C479  add al, bl
  mov [di], al                                 ; 0C47B  0x88, 0x05
  inc si                                       ; 0C47D  0x46
  inc si                                       ; 0C47E  0x46
  inc di                                       ; 0C47F  0x47
  db 0x8B, 0xC2                                ; 0C480  mov ax, dx
  cmp si, 0xa                                  ; 0C482  0x83, 0xFE, 0x0A
  jne loc_0C470                                ; 0C485  0x75, 0xE9
  mov cx, 5                                    ; 0C487  0xB9, 0x05, 0x00
  pop di                                       ; 0C48A  0x5F

loc_0C48B:                                     ; 0C48B
  cmp byte [di], 0x30                          ; 0C48B  0x80, 0x3D, 0x30
  jne loc_0C496                                ; 0C48E  0x75, 0x06
  mov byte [di], 0x20                          ; 0C490  0xC6, 0x05, 0x20
  inc di                                       ; 0C493  0x47
  loop loc_0C48B                               ; 0C494  0xE2, 0xF5

loc_0C496:                                     ; 0C496
  pop si                                       ; 0C496  0x5E
  pop dx                                       ; 0C497  0x5A
  pop bx                                       ; 0C498  0x5B
  pop cx                                       ; 0C499  0x59
  ret                                          ; 0C49A  0xC3
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00  ; 0C49B  ................
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00  ; 0C4AB  ................
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00  ; 0C4BB  ................
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00  ; 0C4CB  ................
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00        ; 0C4DB  ......
  push sp                                      ; 0C4E1  0x54
  dec di                                       ; 0C4E2  0x4F
  cmp bx, [bx + di + 0x10]                     ; 0C4E3  0x3B, 0x59, 0x10
  db 0x27                                      ; 0C4E6  daa
  db 0xE8, 0x03, 0x64                          ; raw bytes in data struct
  add [bp + si], cl                            ; 0C4EA  0x00, 0x0A
  add [bx + di], al                            ; 0C4EC  0x00, 0x01
  db 0x00, 0x00                                ; 0C4EE
  db 0x00, 0x00                                ; 0C4F0
  db 0x00, 0x00                                ; 0C4F2
  add [bp + di], al                            ; 0C4F4  0x00, 0x03
  add [di + 0x58], cl                          ; 0C4F6  0x00, 0x4D, 0x58
  jae loc_0C56A                                ; 0C4F9  0x73, 0x6F
  db 0x75, 0x6E                                ; 0C4FB  jne 0xc56b
  and [fs:bx + si], al                         ; 0C4FD  0x64, 0x20, 0x00
  add [bx + di], al                            ; 0C500  0x00, 0x01
  db 0x00, 0x00                                ; 0C502
  db 0x00, 0x00                                ; 0C504
  db 0x00, 0x00                                ; 0C506
  db 0x00, 0x00                                ; 0C508
  db 0x00, 0x00                                ; 0C50A
  db 0x00, 0x00                                ; 0C50C
  db 0x00, 0x00                                ; 0C50E
  db 0x00, 0x00                                ; 0C510
  db 0x00, 0x00                                ; 0C512
  add [di + 0x58], cl                          ; 0C514  0x00, 0x4D, 0x58
  jae loc_0C588                                ; 0C517  0x73, 0x6F
  db 0x75, 0x6E                                ; 0C519  jne 0xc589
  and [fs:bx + si], al                         ; 0C51B  0x64, 0x20, 0x00
  db 0x00, 0x00                                ; 0C51E
  add [bp + di], al                            ; 0C520  0x00, 0x03
  add [di + 0x58], cl                          ; 0C522  0x00, 0x4D, 0x58
  db 0x64, 0x6D                                ; 0C525  insw
  db 0x61                                      ; 0C527  popa
  xor [bx + si], ah                            ; 0C528  0x30, 0x20
  and [bx + si], al                            ; 0C52A  0x20, 0x00
  add [bx + di], al                            ; 0C52C  0x00, 0x01
  db 0x00, 0x00                                ; 0C52E
  db 0x00, 0x00                                ; 0C530
  db 0x00, 0x00                                ; 0C532
  db 0x00, 0x00                                ; 0C534
  db 0x00, 0x00                                ; 0C536
  db 0x00, 0x00                                ; 0C538
  db 0x00, 0x00                                ; 0C53A
  db 0x00, 0x00                                ; 0C53C
  db 0x00, 0x00                                ; 0C53E
  add [di + 0x58], cl                          ; 0C540  0x00, 0x4D, 0x58
  db 0x64, 0x6D                                ; 0C543  insw
  db 0x61                                      ; 0C545  popa
  xor [bx + si], ah                            ; 0C546  0x30, 0x20
  and [bx + si], al                            ; 0C548  0x20, 0x00
  db 0x00, 0x00                                ; 0C54A
  add [bp + di], al                            ; 0C54C  0x00, 0x03
  add [di + 0x58], cl                          ; 0C54E  0x00, 0x4D, 0x58
  db 0x64, 0x6D                                ; 0C551  insw
  db 0x61                                      ; 0C553  popa
  xor [bx + si], sp                            ; 0C554  0x31, 0x20
  and [bx + si], al                            ; 0C556  0x20, 0x00
  add [bx + di], al                            ; 0C558  0x00, 0x01
  db 0x00, 0x00                                ; 0C55A
  db 0x00, 0x00                                ; 0C55C
  db 0x00, 0x00                                ; 0C55E
  db 0x00, 0x00                                ; 0C560
  db 0x00, 0x00                                ; 0C562
  db 0x00, 0x00                                ; 0C564
  db 0x00, 0x00                                ; 0C566
  db 0x00, 0x00                                ; 0C568

loc_0C56A:                                     ; 0C56A
  db 0x00, 0x00                                ; 0C56A
  add [di + 0x58], cl                          ; 0C56C  0x00, 0x4D, 0x58
  db 0x64, 0x6D                                ; 0C56F  insw
  db 0x61                                      ; 0C571  popa
  xor [bx + si], sp                            ; 0C572  0x31, 0x20
  and [bx + si], al                            ; 0C574  0x20, 0x00
  db 0x00, 0x00                                ; 0C576
  add [bp + si], al                            ; 0C578  0x00, 0x02
  add [si + 0x69], ch                          ; 0C57A  0x00, 0x6C, 0x69
  db 0x6E                                      ; 0C57D  outsb
  db 0x6B, 0x5F, 0x72, 0x65                    ; 0C57E  imul bx, word [bx + 0x72], 0x65
  jno loc_0C593                                ; 0C582  0x71, 0x0F
  add [bx + di], al                            ; 0C584  0x00, 0x01
  db 0x00, 0x00                                ; 0C586

loc_0C588:                                     ; 0C588
  db 0x00, 0x00                                ; 0C588
  db 0x00, 0x00                                ; 0C58A
  db 0x00, 0x00                                ; 0C58C
  add [di], cl                                 ; 0C58E  0x00, 0x0D
  pop dx                                       ; 0C590  0x5A
  db 0x00, 0x00                                ; 0C591

loc_0C593:                                     ; 0C593
  db 0x00, 0x00                                ; 0C593
  db 0x02, 0x00                                ; 0C595  add al, byte [bx + si]
  pop ax                                       ; 0C597  0x58
  dec bp                                       ; 0C598  0x4D
  dec cx                                       ; 0C599  0x49
  push sp                                      ; 0C59A  0x54
  pop di                                       ; 0C59B  0x5F
  push dx                                      ; 0C59C  0x52
  inc bp                                       ; 0C59D  0x45
  push cx                                      ; 0C59E  0x51
  db 0x0F, 0x00, 0x0A                          ; 0C59F  str word [bp + si]
  db 0x00, 0x00                                ; 0C5A2
  db 0x00, 0x00                                ; 0C5A4
  db 0x00, 0x00                                ; 0C5A6
  db 0x00, 0x00                                ; 0C5A8
  add [si], bl                                 ; 0C5AA  0x00, 0x1C
  pop dx                                       ; 0C5AC  0x5A
  db 0x00, 0x00                                ; 0C5AD
  db 0x00, 0x00                                ; 0C5AF
  db 0x00, 0x00                                ; 0C5B1
  db 0x00, 0x00                                ; 0C5B3
  db 0x00, 0x00                                ; 0C5B5
  db 0x00, 0x00                                ; 0C5B7
  db 0x00, 0x00                                ; 0C5B9
  db 0x00, 0x00                                ; 0C5BB
  db 0x00, 0x00                                ; 0C5BD
  db 0x00, 0x00                                ; 0C5BF
  db 0x00, 0x00                                ; 0C5C1
  db 0x00, 0x00                                ; 0C5C3
  db 0x00, 0x00                                ; 0C5C5
  db 0x00, 0x00                                ; 0C5C7
  db 0x00, 0x00                                ; 0C5C9
  db 0x00, 0x00                                ; 0C5CB
  db 0x00, 0x00                                ; 0C5CD
  db 0x00, 0x00                                ; 0C5CF
  db 0x00, 0x00                                ; 0C5D1
  db 0x00, 0x00                                ; 0C5D3
  db 0x00, 0x00                                ; 0C5D5
  db 0x00, 0x00                                ; 0C5D7
  db 0x00, 0x00                                ; 0C5D9
  db 0x00, 0x00                                ; 0C5DB
  db 0x00, 0x00                                ; 0C5DD
  db 0x00, 0x00                                ; 0C5DF
  db 0x00, 0x00                                ; 0C5E1
  db 0x00, 0x00                                ; 0C5E3
  db 0x00, 0x00                                ; 0C5E5
  db 0x00, 0x00                                ; 0C5E7
  db 0x00, 0x00                                ; 0C5E9
  db 0x00, 0x00                                ; 0C5EB
  db 0x00, 0x00                                ; 0C5ED
  db 0x00, 0x00                                ; 0C5EF
  db 0x00, 0x00                                ; 0C5F1
  db 0x00, 0x00                                ; 0C5F3
  db 0x00, 0x00                                ; 0C5F5
  db 0x00, 0x00                                ; 0C5F7
  db 0x00, 0x00                                ; 0C5F9
  db 0x00, 0x00                                ; 0C5FB
  db 0x00, 0x00                                ; 0C5FD
  db 0x00, 0x00                                ; 0C5FF
  db 0x00, 0x00                                ; 0C601
  db 0x00, 0x00                                ; 0C603
  db 0x00, 0x00                                ; 0C605
  db 0x00, 0x00                                ; 0C607
  db 0x00, 0x00                                ; 0C609
  db 0x00, 0x00                                ; 0C60B
  db 0x00, 0x00                                ; 0C60D
  db 0x00, 0x00                                ; 0C60F
  db 0x00, 0x00                                ; 0C611
  db 0x00, 0x00                                ; 0C613
  db 0x00, 0x00                                ; 0C615
  db 0x00, 0x00                                ; 0C617
  db 0x00, 0x00                                ; 0C619
  db 0x00, 0x00                                ; 0C61B
  db 0x00, 0x00                                ; 0C61D
  db 0x00, 0x00                                ; 0C61F
  db 0x00, 0x00                                ; 0C621
  db 0x00, 0x00                                ; 0C623
  db 0x00, 0x00                                ; 0C625
  db 0x00, 0x00                                ; 0C627
  db 0x00, 0x00                                ; 0C629
  db 0x00, 0x00                                ; 0C62B
  db 0x00, 0x00                                ; 0C62D
  db 0x00, 0x00                                ; 0C62F
  db 0x00, 0x00                                ; 0C631
  db 0x00, 0x00                                ; 0C633
  db 0x00, 0x00                                ; 0C635
  db 0x00, 0x00                                ; 0C637
  db 0x00, 0x00                                ; 0C639
  db 0x00, 0x00                                ; 0C63B
  db 0x00, 0x00                                ; 0C63D
  db 0x00, 0x00                                ; 0C63F
  db 0x00, 0x00                                ; 0C641
  db 0x00, 0x00                                ; 0C643
  db 0x00, 0x00                                ; 0C645
  db 0x00, 0x00                                ; 0C647
  db 0x00, 0x00                                ; 0C649
  db 0x00, 0x00                                ; 0C64B
  db 0x00, 0x00                                ; 0C64D
  db 0x00, 0x00                                ; 0C64F
  db 0x00, 0x00                                ; 0C651
  db 0x00, 0x00                                ; 0C653
  add [bp + di], al                            ; 0C655  0x00, 0x03
  add [di + 0x58], cl                          ; 0C657  0x00, 0x4D, 0x58
  db 0x61                                      ; 0C65A  popa
  db 0x6C                                      ; 0C65B  insb
  je loc_0C67E                                 ; 0C65C  0x74, 0x20
  and [bx + si], ah                            ; 0C65E  0x20, 0x20
  db 0x00, 0x00                                ; 0C660
  add [bx + si], ax                            ; 0C662  0x01, 0x00
  db 0x00, 0x00                                ; 0C664
  db 0x00, 0x00                                ; 0C666
  db 0x00, 0x00                                ; 0C668
  db 0x00, 0x00                                ; 0C66A
  db 0x00, 0x00                                ; 0C66C
  db 0x00, 0x00                                ; 0C66E
  db 0x00, 0x00                                ; 0C670
  db 0x00, 0x00                                ; 0C672
  db 0x00, 0x00                                ; 0C674
  dec bp                                       ; 0C676  0x4D
  pop ax                                       ; 0C677  0x58
  db 0x61                                      ; 0C678  popa
  db 0x6C                                      ; 0C679  insb
  db 0x74, 0x20                                ; 0C67A  je 0xc69c
  and [bx + si], ah                            ; 0C67C  0x20, 0x20

loc_0C67E:                                     ; 0C67E
  db 0x00, 0x00                                ; 0C67E
  db 0x00, 0x00                                ; 0C680
  add ax, [bx + si]                            ; 0C682  0x03, 0x00
  dec bp                                       ; 0C684  0x4D
  pop ax                                       ; 0C685  0x58
  db 0x63, 0x61, 0x73                          ; 0C686  arpl word [bx + di + 0x73], sp
  jae loc_0C6AB                                ; 0C689  0x73, 0x20
  and [bx + si], al                            ; 0C68B  0x20, 0x00
  add [bx + di], al                            ; 0C68D  0x00, 0x01
  db 0x00, 0x00                                ; 0C68F
  db 0x00, 0x00                                ; 0C691
  db 0x00, 0x00                                ; 0C693
  db 0x00, 0x00                                ; 0C695
  db 0x00, 0x00                                ; 0C697
  db 0x00, 0x00                                ; 0C699
  db 0x00, 0x00                                ; 0C69B
  db 0x00, 0x00                                ; 0C69D
  db 0x00, 0x00                                ; 0C69F
  add [di + 0x58], cl                          ; 0C6A1  0x00, 0x4D, 0x58
  db 0x63, 0x61, 0x73                          ; 0C6A4  arpl word [bx + di + 0x73], sp
  db 0x73, 0x20                                ; 0C6A7  jae 0xc6c9
  and bh, bh                                   ; 0C6A9  0x20, 0xFF

loc_0C6AB:                                     ; 0C6AB
  inc word [bx + si]                           ; 0C6AB  0xFF, 0x00
  db 0x00, 0x00                                ; 0C6AD
  db 0x00, 0x00                                ; 0C6AF
  db 0x00, 0x00                                ; 0C6B1
  db 0x00, 0x00                                ; 0C6B3
  db 0x01                                      ; 0C6B5
xios_int28_fn_26_cas_read_hdr:                 ; 0C6B6 (Båndoptager læs filhoved)
  call sub_0C9D9                               ; 0C6B6  0xE8, 0x20, 0x03
  db 0x8B, 0xDA                                ; 0C6B9  mov bx, dx (d=1)
  db 0x2E, 0xC7, 0x06, 0x13, 0x5B, 0x00, 0x00  ; 0C6BB  mov word [cs:0x5b13], 0
  mov byte [cs:0x5b15], 1                      ; 0C6C2  0x2E, 0xC6, 0x06, 0x15, 0x5B, 0x01
  mov [cs:0x5b11], cx                          ; 0C6C8  0x2E, 0x89, 0x0E, 0x11, 0x5B
  call sub_0C747                               ; 0C6CD  0xE8, 0x77, 0x00
  xchg bx, dx                                  ; 0C6D0  87 DA
  xchg bx, cx                                  ; 0C6D2  87 D9
  ret                                          ; 0C6D4  0xC3
xios_int28_fn_27_cas_write_hdr:                ; 0C6D5 (Båndoptager skriv filhoved)
  call sub_0C9D9                               ; 0C6D5  0xE8, 0x01, 0x03
  db 0x8B, 0xDA                                ; 0C6D8  mov bx, dx
  db 0x2E, 0xC7, 0x06, 0x13, 0x5B, 0x00, 0x00  ; 0C6DA  mov word [cs:0x5b13], 0
  mov [cs:0x5b11], cx                          ; 0C6E1  0x2E, 0x89, 0x0E, 0x11, 0x5B
  mov byte [cs:0x5b15], 1                      ; 0C6E6  0x2E, 0xC6, 0x06, 0x15, 0x5B, 0x01
  call sub_0C898                               ; 0C6EC  0xE8, 0xA9, 0x01
  db 0x8B, 0xD3                                ; 0C6EF  mov dx, bx
  ret                                          ; 0C6F1  0xC3
xios_int28_fn_28_cas_read_data:               ; 0C6F2 (Båndoptager læs datablok)
  call sub_0C9D9                               ; 0C6F2  0xE8, 0xE4, 0x02
  db 0x8B, 0xDA                                ; 0C6F5  mov bx, dx
  mov byte [cs:0x5b15], 2                      ; 0C6F7  0x2E, 0xC6, 0x06, 0x15, 0x5B, 0x02
  inc word [cs:0x5b13]                         ; 0C6FD  0x2E, 0xFF, 0x06, 0x13, 0x5B
  mov [cs:0x5b11], cx                          ; 0C702  0x2E, 0x89, 0x0E, 0x11, 0x5B
  call sub_0C747                               ; 0C707  0xE8, 0x3D, 0x00
  xchg bx, dx                                  ; 0C70A  87 DA
  xchg bx, cx                                  ; 0C70C  87 D9
  ret                                          ; 0C70E  0xC3
xios_int28_fn_29_cas_write_data:              ; 0C70F (Båndoptager skriv datablok)
  call sub_0C9D9                               ; 0C70F  0xE8, 0xC7, 0x02
  db 0x8B, 0xDA                                ; 0C712  mov bx, dx
  mov byte [cs:0x5b15], 2                      ; 0C714  0x2E, 0xC6, 0x06, 0x15, 0x5B, 0x02
  mov [cs:0x5b11], cx                          ; 0C71A  0x2E, 0x89, 0x0E, 0x11, 0x5B
  inc word [cs:0x5b13]                         ; 0C71F  0x2E, 0xFF, 0x06, 0x13, 0x5B
  call sub_0C898                               ; 0C724  0xE8, 0x71, 0x01
  db 0x8B, 0xD3                                ; 0C727  mov dx, bx
  ret                                          ; 0C729  0xC3
xios_int28_fn_40_cas_write_eof:               ; 0C72A (Båndoptager skriv EOF-blok)
  call sub_0C9D9                               ; 0C72A  0xE8, 0xAC, 0x02
  db 0x8B, 0xDA                                ; 0C72D  mov bx, dx
  mov byte [cs:0x5b15], 3                      ; 0C72F  0x2E, 0xC6, 0x06, 0x15, 0x5B, 0x03
  db 0x2E, 0xC7, 0x06, 0x11, 0x5B, 0x00, 0x00  ; 0C735  mov word [cs:0x5b11], 0
  inc word [cs:0x5b13]                         ; 0C73C  0x2E, 0xFF, 0x06, 0x13, 0x5B
  call sub_0C898                               ; 0C741  0xE8, 0x54, 0x01
  db 0x8B, 0xD3                                ; 0C744  mov dx, bx
  ret                                          ; 0C746  0xC3

sub_0C747:                                     ; 0C747
  cli                                          ; 0C747  0xFA
  push bx                                      ; 0C748  0x53
  push cx                                      ; 0C749  0x51
  push si                                      ; 0C74A  0x56
  mov si, 0xa                                  ; 0C74B  0xBE, 0x0A, 0x00
  call sub_0C998                               ; 0C74E  0xE8, 0x47, 0x02
  mov ax, 0xffff                               ; 0C751  0xB8, 0xFF, 0xFF
  mov dx, PORT_PCB_T0_MAXA                     ; 0C754  0xBA, 0x52, 0xFF
  out dx, ax                                   ; 0C757  0xEF
  mov dx, PORT_PCB_T0_MAXB                     ; 0C758  0xBA, 0x54, 0xFF
  out dx, ax                                   ; 0C75B  0xEF
  mov ax, 0xc013                               ; 0C75C  0xB8, 0x13, 0xC0
  mov dx, PORT_PCB_T0_CON                      ; 0C75F  0xBA, 0x56, 0xFF
  out dx, ax                                   ; 0C762  0xEF
  mov ax, 1                                    ; 0C763  0xB8, 0x01, 0x00
  out PORT_PPI_CTRL, ax                        ; 0C766  0xE7, 0x76

loc_0C768:                                     ; 0C768
  in al, PORT_PPI_PORTA                        ; 0C768  0xE4, 0x70
  and al, 1                                    ; 0C76A  0x24, 0x01
  mov [cs:0x5b0e], al                          ; 0C76C  0x2E, 0xA2, 0x0E, 0x5B
  mov dx, 0x3f7a                               ; 0C770  0xBA, 0x7A, 0x3F

loc_0C773:                                     ; 0C773
  dec dx                                       ; 0C773  0x4A
  jne loc_0C779                                ; 0C774  0x75, 0x03
  jmp near loc_0C81A                           ; 0C776  0xE9, 0xA1, 0x00

loc_0C779:                                     ; 0C779
  call sub_0C870                               ; 0C779  0xE8, 0xF4, 0x00
  jcxz loc_0C773                               ; 0C77C  0xE3, 0xF5
  mov cx, 0x512                                ; 0C77E  0xB9, 0x12, 0x05
  mov dx, 0x465                                ; 0C781  0xBA, 0x65, 0x04

loc_0C784:                                     ; 0C784
  push cx                                      ; 0C784  0x51
  call sub_0C870                               ; 0C785  0xE8, 0xE8, 0x00
  db 0x0B, 0xC9                                ; 0C788  or cx, cx
  pop cx                                       ; 0C78A  0x59
  je loc_0C768                                 ; 0C78B  0x74, 0xDB
  db 0x3B, 0xD3                                ; 0C78D  cmp dx, bx
  jcxz loc_0C795                               ; 0C78F  0xE3, 0x04
  jae loc_0C768                                ; 0C791  0x73, 0xD5
  loop loc_0C784                               ; 0C793  0xE2, 0xEF

loc_0C795:                                     ; 0C795
  jb loc_0C784                                 ; 0C795  0x72, 0xED
  call sub_0C870                               ; 0C797  0xE8, 0xD6, 0x00
  call sub_0C83E                               ; 0C79A  0xE8, 0xA1, 0x00
  cmp al, 3                                    ; 0C79D  0x3C, 0x03
  je loc_0C81F                                 ; 0C79F  0x74, 0x7E
  cmp al, [cs:0x5b15]                          ; 0C7A1  0x2E, 0x3A, 0x06, 0x15, 0x5B
  jne loc_0C814                                ; 0C7A6  0x75, 0x6C
  pop si                                       ; 0C7A8  0x5E
  pop cx                                       ; 0C7A9  0x59
  pop bx                                       ; 0C7AA  0x5B
  call sub_0C83E                               ; 0C7AB  0xE8, 0x90, 0x00
  db 0x8A, 0xE0                                ; 0C7AE  mov ah, al
  call sub_0C83E                               ; 0C7B0  0xE8, 0x8B, 0x00
  cmp ax, [cs:0x5b13]                          ; 0C7B3  0x2E, 0x3B, 0x06, 0x13, 0x5B
  mov al, 4                                    ; 0C7B8  0xB0, 0x04
  push ax                                      ; 0C7BA  0x50
  jne loc_0C82F                                ; 0C7BB  0x75, 0x72
  pop ax                                       ; 0C7BD  0x58
  call sub_0C83E                               ; 0C7BE  0xE8, 0x7D, 0x00
  db 0x8A, 0xE0                                ; 0C7C1  mov ah, al
  call sub_0C83E                               ; 0C7C3  0xE8, 0x78, 0x00
  db 0x3B, 0xC1                                ; 0C7C6  cmp ax, cx
  jae loc_0C7CC                                ; 0C7C8  0x73, 0x02
  db 0x8B, 0xC8                                ; 0C7CA  mov cx, ax

loc_0C7CC:                                     ; 0C7CC
  push cx                                      ; 0C7CC  0x51

loc_0C7CD:                                     ; 0C7CD
  mov ax, 0                                    ; 0C7CD  0xB8, 0x00, 0x00
  db 0x2E, 0xC7, 0x06, 0x0A, 0x5B, 0xFF, 0xFF  ; 0C7D0  mov word [cs:0x5b0a], 0xffff
  mov dx, PORT_NVRAM_BASE                      ; 0C7D7  0xBA, 0x80, 0x00

loc_0C7DA:                                     ; 0C7DA
  call sub_0C83E                               ; 0C7DA  0xE8, 0x61, 0x00
  jb loc_0C802                                 ; 0C7DD  0x72, 0x23
  jcxz loc_0C7E5                               ; 0C7DF  0xE3, 0x04
  mov [bx], al                                 ; 0C7E1  0x88, 0x07
  inc bx                                       ; 0C7E3  0x43
  dec cx                                       ; 0C7E4  0x49

loc_0C7E5:                                     ; 0C7E5
  dec dx                                       ; 0C7E5  0x4A
  jg loc_0C7DA                                 ; 0C7E6  0x7F, 0xF2
  call sub_0C83E                               ; 0C7E8  0xE8, 0x53, 0x00
  db 0x8A, 0xE0                                ; 0C7EB  mov ah, al
  call sub_0C83E                               ; 0C7ED  0xE8, 0x4E, 0x00
  not ax                                       ; 0C7F0  0xF7, 0xD0
  db 0x2E, 0x81, 0x3E, 0x0A, 0x5B, 0x0F, 0x1D  ; 0C7F2  cmp word [cs:0x5b0a], 0x1d0f
  mov al, 0                                    ; 0C7F9  0xB0, 0x00
  jne loc_0C804                                ; 0C7FB  0x75, 0x07
  jcxz loc_0C806                               ; 0C7FD  0xE3, 0x07
  jmp near loc_0C7CD                           ; 0C7FF  0xE9, 0xCB, 0xFF

loc_0C802:                                     ; 0C802
  mov al, 1                                    ; 0C802  0xB0, 0x01

loc_0C804:                                     ; 0C804
  inc al                                       ; 0C804  0xFE, 0xC0

loc_0C806:                                     ; 0C806
  pop dx                                       ; 0C806  0x5A
  db 0x2B, 0xD1                                ; 0C807  sub dx, cx
  push ax                                      ; 0C809  0x50
  test al, 3                                   ; 0C80A  0xA8, 0x03
  jne loc_0C82F                                ; 0C80C  0x75, 0x21
  call sub_0C83E                               ; 0C80E  0xE8, 0x2D, 0x00
  jmp near loc_0C82F                           ; 0C811  0xE9, 0x1B, 0x00

loc_0C814:                                     ; 0C814
  dec si                                       ; 0C814  0x4E
  je loc_0C81A                                 ; 0C815  0x74, 0x03
  jmp near loc_0C768                           ; 0C817  0xE9, 0x4E, 0xFF

loc_0C81A:                                     ; 0C81A
  mov al, 3                                    ; 0C81A  0xB0, 0x03
  jmp near loc_0C829                           ; 0C81C  0xE9, 0x0A, 0x00

loc_0C81F:                                     ; 0C81F
  cmp byte [cs:0x5b15], 1                      ; 0C81F  0x2E, 0x80, 0x3E, 0x15, 0x5B, 0x01
  je loc_0C814                                 ; 0C825  0x74, 0xED
  mov al, 5                                    ; 0C827  0xB0, 0x05

loc_0C829:                                     ; 0C829
  pop si                                       ; 0C829  0x5E
  pop cx                                       ; 0C82A  0x59
  pop bx                                       ; 0C82B  0x5B
  db 0x2B, 0xD2                                ; 0C82C  sub dx, dx
  push ax                                      ; 0C82E  0x50

loc_0C82F:                                     ; 0C82F
  mov ax, 3                                    ; 0C82F  0xB8, 0x03, 0x00
  out PORT_PPI_CTRL, ax                        ; 0C832  0xE7, 0x76
  pop ax                                       ; 0C834  0x58
  cmp ah, 1                                    ; 0C835  0x80, 0xFC, 0x01
  cmc                                          ; 0C838  0xF5
  call sub_0C9A9                               ; 0C839  0xE8, 0x6D, 0x01
  sti                                          ; 0C83C  0xFB
  ret                                          ; 0C83D  0xC3

sub_0C83E:                                     ; 0C83E
  push bx                                      ; 0C83E  0x53
  push cx                                      ; 0C83F  0x51
  push ax                                      ; 0C840  0x50
  mov cl, 8                                    ; 0C841  0xB1, 0x08

loc_0C843:                                     ; 0C843
  push cx                                      ; 0C843  0x51
  call sub_0C870                               ; 0C844  0xE8, 0x29, 0x00
  jcxz loc_0C86A                               ; 0C847  0xE3, 0x21
  push bx                                      ; 0C849  0x53
  call sub_0C870                               ; 0C84A  0xE8, 0x23, 0x00
  pop ax                                       ; 0C84D  0x58
  jcxz loc_0C86A                               ; 0C84E  0xE3, 0x1A
  db 0x03, 0xD8                                ; 0C850  add bx, ax
  cmp bx, 0x8ca                                ; 0C852  0x81, 0xFB, 0xCA, 0x08
  cmc                                          ; 0C856  0xF5
  lahf                                         ; 0C857  0x9F
  pop cx                                       ; 0C858  0x59
  rcl ch, 1                                    ; 0C859  0xD0, 0xD5
  sahf                                         ; 0C85B  0x9E
  call sub_0C982                               ; 0C85C  0xE8, 0x23, 0x01
  dec cl                                       ; 0C85F  0xFE, 0xC9
  jne loc_0C843                                ; 0C861  0x75, 0xE0
  pop ax                                       ; 0C863  0x58
  db 0x8A, 0xC5                                ; 0C864  mov al, ch
  clc                                          ; 0C866  0xF8

loc_0C867:                                     ; 0C867
  pop cx                                       ; 0C867  0x59
  pop bx                                       ; 0C868  0x5B
  ret                                          ; 0C869  0xC3

loc_0C86A:                                     ; 0C86A
  pop cx                                       ; 0C86A  0x59
  pop ax                                       ; 0C86B  0x58
  stc                                          ; 0C86C  0xF9
  jmp near loc_0C867                           ; 0C86D  0xE9, 0xF7, 0xFF

sub_0C870:                                     ; 0C870
  mov cx, 0x190                                ; 0C870  0xB9, 0x90, 0x01
  mov ah, [cs:0x5b0e]                          ; 0C873  0x2E, 0x8A, 0x26, 0x0E, 0x5B

loc_0C878:                                     ; 0C878
  in al, PORT_PPI_PORTA                        ; 0C878  0xE4, 0x70
  and al, 1                                    ; 0C87A  0x24, 0x01
  db 0x3A, 0xC4                                ; 0C87C  cmp al, ah
  loope loc_0C878                              ; 0C87E  0xE1, 0xF8
  mov [cs:0x5b0e], al                          ; 0C880  0x2E, 0xA2, 0x0E, 0x5B
  push dx                                      ; 0C884  0x52
  mov dx, PORT_PCB_T0_CNT                      ; 0C885  0xBA, 0x50, 0xFF
  in ax, dx                                    ; 0C888  0xED
  pop dx                                       ; 0C889  0x5A
  db 0x8B, 0xD8                                ; 0C88A  mov bx, ax
  mov ax, [cs:0x5b0c]                          ; 0C88C  0x2E, 0xA1, 0x0C, 0x5B
  mov [cs:0x5b0c], bx                          ; 0C890  0x2E, 0x89, 0x1E, 0x0C, 0x5B
  db 0x2B, 0xD8                                ; 0C895  sub bx, ax
  ret                                          ; 0C897  0xC3

sub_0C898:                                     ; 0C898
  cli                                          ; 0C898  0xFA
  push bx                                      ; 0C899  0x53
  push cx                                      ; 0C89A  0x51
  mov ax, 0xc013                               ; 0C89B  0xB8, 0x13, 0xC0
  mov dx, PORT_PCB_T0_CON                      ; 0C89E  0xBA, 0x56, 0xFF
  out dx, ax                                   ; 0C8A1  0xEF
  mov ax, 0x5dc                                ; 0C8A2  0xB8, 0xDC, 0x05
  mov dx, PORT_PCB_T0_MAXA                     ; 0C8A5  0xBA, 0x52, 0xFF
  out dx, ax                                   ; 0C8A8  0xEF
  mov dx, PORT_PCB_T0_MAXB                     ; 0C8A9  0xBA, 0x54, 0xFF
  out dx, ax                                   ; 0C8AC  0xEF
  call sub_0C998                               ; 0C8AD  0xE8, 0xE8, 0x00
  mov ax, 1                                    ; 0C8B0  0xB8, 0x01, 0x00
  out PORT_PPI_CTRL, ax                        ; 0C8B3  0xE7, 0x76
  mov cx, 0x7e8                                ; 0C8B5  0xB9, 0xE8, 0x07

loc_0C8B8:                                     ; 0C8B8
  stc                                          ; 0C8B8  0xF9
  call sub_0C94F                               ; 0C8B9  0xE8, 0x93, 0x00
  loop loc_0C8B8                               ; 0C8BC  0xE2, 0xFA
  clc                                          ; 0C8BE  0xF8
  call sub_0C94F                               ; 0C8BF  0xE8, 0x8D, 0x00
  mov al, [cs:0x5b15]                          ; 0C8C2  0x2E, 0xA0, 0x15, 0x5B
  push ax                                      ; 0C8C6  0x50
  call sub_0C938                               ; 0C8C7  0xE8, 0x6E, 0x00
  pop ax                                       ; 0C8CA  0x58
  cmp al, 3                                    ; 0C8CB  0x3C, 0x03
  je loc_0C925                                 ; 0C8CD  0x74, 0x56
  mov ax, [cs:0x5b13]                          ; 0C8CF  0x2E, 0xA1, 0x13, 0x5B
  push ax                                      ; 0C8D3  0x50
  xchg ah, al                                  ; 0C8D4  86 E0
  call sub_0C938                               ; 0C8D6  0xE8, 0x5F, 0x00
  pop ax                                       ; 0C8D9  0x58
  call sub_0C938                               ; 0C8DA  0xE8, 0x5B, 0x00
  mov ax, [cs:0x5b11]                          ; 0C8DD  0x2E, 0xA1, 0x11, 0x5B
  push ax                                      ; 0C8E1  0x50
  xchg ah, al                                  ; 0C8E2  86 E0
  call sub_0C938                               ; 0C8E4  0xE8, 0x51, 0x00
  pop ax                                       ; 0C8E7  0x58
  call sub_0C938                               ; 0C8E8  0xE8, 0x4D, 0x00
  pop cx                                       ; 0C8EB  0x59
  pop bx                                       ; 0C8EC  0x5B

loc_0C8ED:                                     ; 0C8ED
  db 0x2E, 0xC7, 0x06, 0x0A, 0x5B, 0xFF, 0xFF  ; 0C8ED  mov word [cs:0x5b0a], 0xffff
  mov dx, PORT_NVRAM_BASE                      ; 0C8F4  0xBA, 0x80, 0x00

loc_0C8F7:                                     ; 0C8F7
  mov al, [bx]                                 ; 0C8F7  0x8A, 0x07
  call sub_0C938                               ; 0C8F9  0xE8, 0x3C, 0x00
  jcxz loc_0C900                               ; 0C8FC  0xE3, 0x02
  inc bx                                       ; 0C8FE  0x43
  dec cx                                       ; 0C8FF  0x49

loc_0C900:                                     ; 0C900
  dec dx                                       ; 0C900  0x4A
  jg loc_0C8F7                                 ; 0C901  0x7F, 0xF4
  mov ax, [cs:0x5b0a]                          ; 0C903  0x2E, 0xA1, 0x0A, 0x5B
  not ax                                       ; 0C907  0xF7, 0xD0
  push ax                                      ; 0C909  0x50
  xchg ah, al                                  ; 0C90A  86 E0
  call sub_0C938                               ; 0C90C  0xE8, 0x29, 0x00
  pop ax                                       ; 0C90F  0x58
  call sub_0C938                               ; 0C910  0xE8, 0x25, 0x00
  db 0x0B, 0xC9                                ; 0C913  or cx, cx
  jne loc_0C8ED                                ; 0C915  0x75, 0xD6
  push cx                                      ; 0C917  0x51
  mov cx, 0x20                                 ; 0C918  0xB9, 0x20, 0x00

loc_0C91B:                                     ; 0C91B
  stc                                          ; 0C91B  0xF9
  call sub_0C94F                               ; 0C91C  0xE8, 0x30, 0x00
  loop loc_0C91B                               ; 0C91F  0xE2, 0xFA
  pop cx                                       ; 0C921  0x59
  jmp near loc_0C927                           ; 0C922  0xE9, 0x02, 0x00

loc_0C925:                                     ; 0C925
  pop cx                                       ; 0C925  0x59
  pop bx                                       ; 0C926  0x5B

loc_0C927:                                     ; 0C927
  mov ax, 0                                    ; 0C927  0xB8, 0x00, 0x00
  out PORT_PPI_CTRL, ax                        ; 0C92A  0xE7, 0x76
  mov ax, 3                                    ; 0C92C  0xB8, 0x03, 0x00
  out PORT_PPI_CTRL, ax                        ; 0C92F  0xE7, 0x76
  db 0x2B, 0xC0                                ; 0C931  sub ax, ax
  call sub_0C9A9                               ; 0C933  0xE8, 0x73, 0x00
  sti                                          ; 0C936  0xFB
  ret                                          ; 0C937  0xC3

sub_0C938:                                     ; 0C938
  push cx                                      ; 0C938  0x51
  push ax                                      ; 0C939  0x50
  db 0x8A, 0xE8                                ; 0C93A  mov ch, al
  mov cl, 8                                    ; 0C93C  0xB1, 0x08

loc_0C93E:                                     ; 0C93E
  rcl ch, 1                                    ; 0C93E  0xD0, 0xD5
  pushf                                        ; 0C940  0x9C
  call sub_0C94F                               ; 0C941  0xE8, 0x0B, 0x00
  popf                                         ; 0C944  0x9D
  call sub_0C982                               ; 0C945  0xE8, 0x3A, 0x00
  dec cl                                       ; 0C948  0xFE, 0xC9
  jne loc_0C93E                                ; 0C94A  0x75, 0xF2
  pop ax                                       ; 0C94C  0x58
  pop cx                                       ; 0C94D  0x59
  ret                                          ; 0C94E  0xC3

sub_0C94F:                                     ; 0C94F
  mov ax, 0x5dc                                ; 0C94F  0xB8, 0xDC, 0x05
  jb loc_0C957                                 ; 0C952  0x72, 0x03
  mov ax, 0x2ee                                ; 0C954  0xB8, 0xEE, 0x02

loc_0C957:                                     ; 0C957
  push dx                                      ; 0C957  0x52
  push ax                                      ; 0C958  0x50

loc_0C959:                                     ; 0C959
  mov dx, PORT_PCB_T0_CON                      ; 0C959  0xBA, 0x56, 0xFF
  in ax, dx                                    ; 0C95C  0xED
  and ax, strict word 0x20                     ; 0C95D  25 20 00
  je loc_0C959                                 ; 0C960  0x74, 0xF7
  in ax, dx                                    ; 0C962  0xED
  and ax, strict word 0xffdf                   ; 0C963  25 DF FF
  out dx, ax                                   ; 0C966  0xEF
  pop ax                                       ; 0C967  0x58
  push ax                                      ; 0C968  0x50
  mov dx, PORT_PCB_T0_MAXA                     ; 0C969  0xBA, 0x52, 0xFF
  out dx, ax                                   ; 0C96C  0xEF

loc_0C96D:                                     ; 0C96D
  mov dx, PORT_PCB_T0_CON                      ; 0C96D  0xBA, 0x56, 0xFF
  in ax, dx                                    ; 0C970  0xED
  and ax, strict word 0x20                     ; 0C971  25 20 00
  je loc_0C96D                                 ; 0C974  0x74, 0xF7
  in ax, dx                                    ; 0C976  0xED
  and ax, strict word 0xffdf                   ; 0C977  25 DF FF
  out dx, ax                                   ; 0C97A  0xEF
  pop ax                                       ; 0C97B  0x58
  mov dx, PORT_PCB_T0_MAXB                     ; 0C97C  0xBA, 0x54, 0xFF
  out dx, ax                                   ; 0C97F  0xEF
  pop dx                                       ; 0C980  0x5A
  ret                                          ; 0C981  0xC3

sub_0C982:                                     ; 0C982
  mov ax, [cs:0x5b0a]                          ; 0C982  0x2E, 0xA1, 0x0A, 0x5B
  rcr ax, 1                                    ; 0C986  0xD1, 0xD8
  rcl ax, 1                                    ; 0C988  0xD1, 0xD0
  clc                                          ; 0C98A  0xF8
  jno loc_0C991                                ; 0C98B  0x71, 0x04
  xor ax, 0x810                                ; 0C98D  0x35, 0x10, 0x08
  stc                                          ; 0C990  0xF9

loc_0C991:                                     ; 0C991
  rcl ax, 1                                    ; 0C991  0xD1, 0xD0
  mov [cs:0x5b0a], ax                          ; 0C993  0x2E, 0xA3, 0x0A, 0x5B
  ret                                          ; 0C997  0xC3

sub_0C998:                                     ; 0C998
  mov ax, 2                                    ; 0C998  0xB8, 0x02, 0x00
  out PORT_PPI_CTRL, ax                        ; 0C99B  0xE7, 0x76
  mov bl, 0x96                                 ; 0C99D  0xB3, 0x96

loc_0C99F:                                     ; 0C99F
  mov cx, 0xfa0                                ; 0C99F  0xB9, 0xA0, 0x0F

loc_0C9A2:                                     ; 0C9A2
  loop loc_0C9A2                               ; 0C9A2  0xE2, 0xFE
  dec bl                                       ; 0C9A4  0xFE, 0xCB
  jne loc_0C99F                                ; 0C9A6  0x75, 0xF7
  ret                                          ; 0C9A8  0xC3

sub_0C9A9:                                     ; 0C9A9
  push dx                                      ; 0C9A9  0x52
  push ax                                      ; 0C9AA  0x50
  push es                                      ; 0C9AB  0x06
  push bx                                      ; 0C9AC  0x53
  mov ax, [cs:0xc06]                           ; 0C9AD  0x2E, 0xA1, 0x06, 0x0C
  mov es, ax                                   ; 0C9B1  0x8E, 0xC0
  mov bx, 0                                    ; 0C9B3  0xBB, 0x00, 0x00
  mov al, 2                                    ; 0C9B6  0xB0, 0x02
  call sub_0AFE6                               ; 0C9B8  0xE8, 0x2B, 0xE6
  mov [es:bx + 0x82], al                       ; 0C9BB  0x26, 0x88, 0x87, 0x82, 0x00
  mov al, 3                                    ; 0C9C0  0xB0, 0x03
  call sub_0AFE6                               ; 0C9C2  0xE8, 0x21, 0xE6
  mov [es:bx + 0x81], al                       ; 0C9C5  0x26, 0x88, 0x87, 0x81, 0x00
  mov al, 4                                    ; 0C9CA  0xB0, 0x04
  call sub_0AFE6                               ; 0C9CC  0xE8, 0x17, 0xE6
  mov [es:bx + 0x80], al                       ; 0C9CF  0x26, 0x88, 0x87, 0x80, 0x00
  pop bx                                       ; 0C9D4  0x5B
  pop es                                       ; 0C9D5  0x07
  pop ax                                       ; 0C9D6  0x58
  pop dx                                       ; 0C9D7  0x5A
  ret                                          ; 0C9D8  0xC3

sub_0C9D9:                                     ; 0C9D9
  pop ax                                       ; 0C9D9  0x58
  pop bx                                       ; 0C9DA  0x5B
  pop ds                                       ; 0C9DB  0x1F
  push ds                                      ; 0C9DC  0x1E
  push bx                                      ; 0C9DD  0x53
  push ax                                      ; 0C9DE  0x50
  ret                                          ; 0C9DF  0xC3
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00        ; 0C9E0  ......

sub_0C9E6:                                     ; 0C9E6
  push es                                      ; 0C9E6  0x06
  mov di, 0x4909                               ; 0C9E7  0xBF, 0x09, 0x49
  push di                                      ; 0C9EA  0x57
  push di                                      ; 0C9EB  0x57
  push ds                                      ; 0C9EC  0x1E
  pop es                                       ; 0C9ED  0x07
  mov cx, 0x50                                 ; 0C9EE  0xB9, 0x50, 0x00
  mov al, 0x20                                 ; 0C9F1  0xB0, 0x20
  rep stosb                                    ; 0C9F3  0xF3, 0xAA
  lodsb                                        ; 0C9F5  0xAC
  db 0x8A, 0xC8                                ; 0C9F6  mov cl, al
  pop di                                       ; 0C9F8  0x5F
  rep movsb                                    ; 0C9F9  0xF3, 0xA4
  pop cx                                       ; 0C9FB  0x59
  mov dx, cs                                   ; 0C9FC  0x8C, 0xCA
  pop es                                       ; 0C9FE  0x07
  call sub_08C61                               ; 0C9FF  0xE8, 0x5F, 0xC2
  ret                                          ; 0CA02  0xC3
xios_int28_fn_41_dpc_parallel:               ; 0CA03 (Reserver/frigiv DPC interface)
  push ax                                      ; 0CA03  0x50
  push es                                      ; 0CA04  0x06
  call sub_0AE7F                               ; 0CA05  0xE8, 0x77, 0xE4
  add si, 0x13                                 ; 0CA08  0x83, 0xC6, 0x13
  mov al, [si]                                 ; 0CA0B  0x8A, 0x04
  cmp al, 0                                    ; 0CA0D  0x3C, 0x00
  pop es                                       ; 0CA0F  0x07
  pop ax                                       ; 0CA10  0x58
  je loc_0CA7E                                 ; 0CA11  0x74, 0x6B
  cmp ah, 1                                    ; 0CA13  0x80, 0xFC, 0x01
  jne loc_0CA72                                ; 0CA16  0x75, 0x5A
  mov byte [cs:0x5e43], 0xff                   ; 0CA18  0x2E, 0xC6, 0x06, 0x43, 0x5E, 0xFF

sub_0CA1E:                                     ; 0CA1E
  mov dx, PORT_PRN_RESERVE                     ; 0CA1E  0xBA, 0x92, 0x02
  mov al, 0xff                                 ; 0CA21  0xB0, 0xFF
  out dx, al                                   ; 0CA23  0xEE
  in al, dx                                    ; 0CA24  0xEC
  and al, 0x80                                 ; 0CA25  0x24, 0x80
  je loc_0CA54                                 ; 0CA27  0x74, 0x2B
  push ds                                      ; 0CA29  0x1E
  push es                                      ; 0CA2A  0x06
  push cx                                      ; 0CA2B  0x51
  push dx                                      ; 0CA2C  0x52
  push cs                                      ; 0CA2D  0x0E
  pop ds                                       ; 0CA2E  0x1F
  mov si, [cs:0x68]                            ; 0CA2F  0x2E, 0x8B, 0x36, 0x68, 0x00
  mov es, [si + 0x10]                          ; 0CA34  0x8E, 0x44, 0x10
  mov si, 0x497e                               ; 0CA37  0xBE, 0x7E, 0x49
  call sub_0C9E6                               ; 0CA3A  0xE8, 0xA9, 0xFF
  pop dx                                       ; 0CA3D  0x5A
  pop cx                                       ; 0CA3E  0x59
  pop es                                       ; 0CA3F  0x07
  pop ds                                       ; 0CA40  0x1F
  mov cl, 0x83                                 ; 0CA41  0xB1, 0x83
  mov dl, 2                                    ; 0CA43  0xB2, 0x02
  call rtm_timer_wait2                         ; 0CA45  0xE8, 0x8B, 0xAE
  mov byte [cs:0x5e40], 0xff                   ; 0CA48  0x2E, 0xC6, 0x06, 0x40, 0x5E, 0xFF
  mov cx, 0xffff                               ; 0CA4E  0xB9, 0xFF, 0xFF
  call sub_08C61                               ; 0CA51  0xE8, 0x0D, 0xC2

loc_0CA54:                                     ; 0CA54
  cmp byte [cs:0x5e45], 0xff                   ; 0CA54  0x2E, 0x80, 0x3E, 0x45, 0x5E, 0xFF
  mov byte [cs:0x5e45], 0                      ; 0CA5A  0x2E, 0xC6, 0x06, 0x45, 0x5E, 0x00
  mov byte [cs:0x5e40], 0xff                   ; 0CA60  0x2E, 0xC6, 0x06, 0x40, 0x5E, 0xFF
  mov byte [cs:0x5e41], 0xa                    ; 0CA66  0x2E, 0xC6, 0x06, 0x41, 0x5E, 0x0A
  jne loc_0CA6F                                ; 0CA6C  0x75, 0x01
  ret                                          ; 0CA6E  0xC3

loc_0CA6F:                                     ; 0CA6F
  db 0x33, 0xC0                                ; 0CA6F  xor ax, ax
  ret                                          ; 0CA71  0xC3

loc_0CA72:                                     ; 0CA72
  cmp ah, 2                                    ; 0CA72  0x80, 0xFC, 0x02
  jne loc_0CA7E                                ; 0CA75  0x75, 0x07
  mov byte [cs:0x5e43], 0                      ; 0CA77  0x2E, 0xC6, 0x06, 0x43, 0x5E, 0x00
  ret                                          ; 0CA7D  0xC3

loc_0CA7E:                                     ; 0CA7E
  mov ax, 0xffff                               ; 0CA7E  0xB8, 0xFF, 0xFF
  ret                                          ; 0CA81  0xC3

sub_0CA82:                                     ; 0CA82
  cmp byte [cs:0x5e40], 0xff                   ; 0CA82  0x2E, 0x80, 0x3E, 0x40, 0x5E, 0xFF
  jne loc_0CAB4                                ; 0CA88  0x75, 0x2A
  cmp byte [cs:0x5e41], 0                      ; 0CA8A  0x2E, 0x80, 0x3E, 0x41, 0x5E, 0x00
  je loc_0CA9A                                 ; 0CA90  0x74, 0x08
  dec byte [cs:0x5e41]                         ; 0CA92  0x2E, 0xFE, 0x0E, 0x41, 0x5E
  jmp near loc_0CAB4                           ; 0CA97  0xE9, 0x1A, 0x00

loc_0CA9A:                                     ; 0CA9A
  cmp byte [cs:0x5e43], 0xff                   ; 0CA9A  0x2E, 0x80, 0x3E, 0x43, 0x5E, 0xFF
  je loc_0CAB4                                 ; 0CAA0  0x74, 0x12
  mov dx, PORT_PRN_RELEASE                     ; 0CAA2  0xBA, 0x94, 0x02
  out dx, al                                   ; 0CAA5  0xEE
  db 0x33, 0xC0                                ; 0CAA6  xor ax, ax
  mov byte [cs:0x5e40], 0                      ; 0CAA8  0x2E, 0xC6, 0x06, 0x40, 0x5E, 0x00
  mov byte [cs:0x5e41], 0                      ; 0CAAE  0x2E, 0xC6, 0x06, 0x41, 0x5E, 0x00

loc_0CAB4:                                     ; 0CAB4
  ret                                          ; 0CAB4  0xC3
xios_int28_fn_42_shared_disk:                ; 0CAB5 (Reserver/frigiv delt disk)
  push ax                                      ; 0CAB5  0x50
  push es                                      ; 0CAB6  0x06
  call sub_0AE7F                               ; 0CAB7  0xE8, 0xC5, 0xE3
  add si, 0x13                                 ; 0CABA  0x83, 0xC6, 0x13
  mov al, [es:si]                              ; 0CABD  0x26, 0x8A, 0x04
  cmp al, 0                                    ; 0CAC0  0x3C, 0x00
  pop es                                       ; 0CAC2  0x07
  pop ax                                       ; 0CAC3  0x58
  je loc_0CB14                                 ; 0CAC4  0x74, 0x4E
  cmp ah, 1                                    ; 0CAC6  0x80, 0xFC, 0x01
  jne loc_0CB08                                ; 0CAC9  0x75, 0x3D
  mov byte [cs:0x5e44], 0xff                   ; 0CACB  0x2E, 0xC6, 0x06, 0x44, 0x5E, 0xFF

sub_0CAD1:                                     ; 0CAD1
  mov byte [cs:0x5e42], 0                      ; 0CAD1  0x2E, 0xC6, 0x06, 0x42, 0x5E, 0x00
  mov dx, PORT_FDC_RESERVE                     ; 0CAD7  0xBA, 0x8E, 0x02
  mov al, 0xff                                 ; 0CADA  0xB0, 0xFF
  out dx, al                                   ; 0CADC  0xEE
  in al, dx                                    ; 0CADD  0xEC
  and al, 0x80                                 ; 0CADE  0x24, 0x80
  je loc_0CB07                                 ; 0CAE0  0x74, 0x25
  push ds                                      ; 0CAE2  0x1E
  push es                                      ; 0CAE3  0x06
  push cx                                      ; 0CAE4  0x51
  push dx                                      ; 0CAE5  0x52
  push cs                                      ; 0CAE6  0x0E
  pop ds                                       ; 0CAE7  0x1F
  mov si, [cs:0x68]                            ; 0CAE8  0x2E, 0x8B, 0x36, 0x68, 0x00
  mov es, [si + 0x10]                          ; 0CAED  0x8E, 0x44, 0x10
  mov si, 0x4959                               ; 0CAF0  0xBE, 0x59, 0x49
  call sub_0C9E6                               ; 0CAF3  0xE8, 0xF0, 0xFE
  pop dx                                       ; 0CAF6  0x5A
  pop cx                                       ; 0CAF7  0x59
  pop es                                       ; 0CAF8  0x07
  pop ds                                       ; 0CAF9  0x1F
  mov dl, 1                                    ; 0CAFA  0xB2, 0x01
  mov cl, 0x83                                 ; 0CAFC  0xB1, 0x83
  call rtm_timer_wait2                         ; 0CAFE  0xE8, 0xD2, 0xAD
  mov cx, 0xffff                               ; 0CB01  0xB9, 0xFF, 0xFF
  call sub_08C61                               ; 0CB04  0xE8, 0x5A, 0xC1

loc_0CB07:                                     ; 0CB07
  ret                                          ; 0CB07  0xC3

loc_0CB08:                                     ; 0CB08
  cmp ah, 2                                    ; 0CB08  0x80, 0xFC, 0x02
  jne loc_0CB14                                ; 0CB0B  0x75, 0x07
  mov byte [cs:0x5e44], 0                      ; 0CB0D  0x2E, 0xC6, 0x06, 0x44, 0x5E, 0x00
  ret                                          ; 0CB13  0xC3

loc_0CB14:                                     ; 0CB14
  mov ax, 0xffff                               ; 0CB14  0xB8, 0xFF, 0xFF
  ret                                          ; 0CB17  0xC3

sub_0CB18:                                     ; 0CB18
  cmp byte [cs:0x5e42], 0xff                   ; 0CB18  0x2E, 0x80, 0x3E, 0x42, 0x5E, 0xFF
  jne loc_0CB3B                                ; 0CB1E  0x75, 0x1B
  cmp byte [cs:0x5e44], 0xff                   ; 0CB20  0x2E, 0x80, 0x3E, 0x44, 0x5E, 0xFF
  je loc_0CB3B                                 ; 0CB26  0x74, 0x13
  mov ax, [cs:0x88]                            ; 0CB28  0x2E, 0xA1, 0x88, 0x00
  and ax, 0xefff                               ; 0CB2C  0x25, 0xFF, 0xEF
  jne loc_0CB3B                                ; 0CB2F  0x75, 0x0A

fdc_release:                                   ; 0CB31
  mov dx, PORT_FDC_RELEASE                     ; 0CB31  0xBA, 0x90, 0x02
  out dx, al                                   ; 0CB34  0xEE
  mov byte [cs:0x5e42], 0                      ; 0CB35  0x2E, 0xC6, 0x06, 0x42, 0x5E, 0x00

loc_0CB3B:                                     ; 0CB3B
  ret                                          ; 0CB3B  0xC3

sub_0CB3C:                                     ; 0CB3C
  call sub_0CB18                               ; 0CB3C  0xE8, 0xD9, 0xFF
  call sub_0CA82                               ; 0CB3F  0xE8, 0x40, 0xFF
  ret                                          ; 0CB42  0xC3
  db 0x00                                      ; 0CB43  .
  add [bp + di], ax                            ; 0CB44  0x01, 0x03
  db 0x00, 0x00                                ; 0CB46
  push ax                                      ; 0CB48  0x50
  db 0x00, 0x00                                ; 0CB49
  db 0x00, 0x00                                ; 0CB4B
  db 0x00, 0x00                                ; 0CB4D
  db 0x00, 0x00                                ; 0CB4F
  db 0x00, 0x00                                ; 0CB51
  db 0x00, 0x00                                ; 0CB53
  db 0x00, 0x00                                ; 0CB55
  db 0x00, 0x00                                ; 0CB57
  add bh, dh                                   ; 0CB59  0x00, 0xF7
  inc word [bx + si]                           ; 0CB5B  0xFF, 0x00
  add bh, bh                                   ; 0CB5D  0x00, 0xFF
  db 0xFF, 0xFF                                ; 0CB5F  ..
  inc word [bx + si]                           ; 0CB61  0xFF, 0x00
  db 0x00, 0x00                                ; 0CB63
  db 0x00, 0x00                                ; 0CB65
  db 0x00, 0x00                                ; 0CB67
  db 0x00, 0x00                                ; 0CB69
  adc [bp + di], al                            ; 0CB6B  0x10, 0x03
  db 0x2F                                      ; 0CB6D  das
  sub [0x629], ax                              ; 0CB6E  0x29, 0x06, 0x29, 0x06
  db 0x00, 0x00                                ; 0CB72
  or [bx + si], ax                             ; 0CB74  0x09, 0x00
  or al, [bx + si]                             ; 0CB76  0x0A, 0x00
  add ax, 0x900                                ; 0CB78  0x05, 0x00, 0x09
  push es                                      ; 0CB7B  0x06
  or [bx + si], ax                             ; 0CB7C  0x09, 0x00
  or [bx + si], ax                             ; 0CB7E  0x09, 0x00
  or [bx + di], cx                             ; 0CB80  0x09, 0x09
  db 0x00, 0x00                                ; 0CB82
  cmp [bx + di], al                            ; 0CB84  0x38, 0x01
  add ax, 0x2400                               ; 0CB86  0x05, 0x00, 0x24
  add [1], bl                                  ; 0CB89  0x00, 0x1E, 0x01, 0x00
  db 0x00, 0x00                                ; 0CB8D
  add [bx + di], al                            ; 0CB8F  0x00, 0x01
  inc di                                       ; 0CB91  0x47
  add ax, [bx + 4]                             ; 0CB92  0x03, 0x47, 0x04
  cli                                          ; 0CB95  0xFA
  stc                                          ; 0CB96  0xF9
  inc word [bx + si]                           ; 0CB97  0xFF, 0x00
  adc [bp + di], al                            ; 0CB99  0x10, 0x03
  db 0x2F                                      ; 0CB9B  das
  sub [0x629], ax                              ; 0CB9C  0x29, 0x06, 0x29, 0x06
  db 0x00, 0x00                                ; 0CBA0
  db 0x0F, 0x00, 0x10                          ; 0CBA2  lldt word [bx + si]
  add [di], al                                 ; 0CBA5  0x00, 0x05
  add [bx + di], cl                            ; 0CBA7  0x00, 0x09
  push es                                      ; 0CBA9  0x06
  or [bx + si], cx                             ; 0CBAA  0x09, 0x08
  or [bx + si], ax                             ; 0CBAC  0x09, 0x00
  or [bx + di], cx                             ; 0CBAE  0x09, 0x09
  db 0x00, 0x00                                ; 0CBB0
  cmp [bx + di], al                            ; 0CBB2  0x38, 0x01
  add ax, 0x2000                               ; 0CBB4  0x05, 0x00, 0x20
  add [bx + si], ah                            ; 0CBB7  0x00, 0x20
  add [bx + si], ax                            ; 0CBB9  0x01, 0x00
  db 0x00, 0x00                                ; 0CBBB
  add [bx + di], al                            ; 0CBBD  0x00, 0x01
  inc di                                       ; 0CBBF  0x47
  db 0x03, 0x47, 0x00                          ; 0CBC0  add ax, word [bx]
  db 0xFF, 0xFF                                ; 0CBC3  ..
  inc word [bx + si]                           ; 0CBC5  0xFF, 0x00
  db 0x00, 0x00                                ; 0CBC7
  db 0x00, 0x00                                ; 0CBC9
  db 0x00, 0x00                                ; 0CBCB
  db 0x00, 0x00                                ; 0CBCD
  db 0x00, 0x00                                ; 0CBCF
  db 0x00, 0x00                                ; 0CBD1
  db 0x00, 0x00                                ; 0CBD3
  db 0x00, 0x00                                ; 0CBD5
  db 0x00, 0x00                                ; 0CBD7
  db 0x00, 0x00                                ; 0CBD9
  db 0x00, 0x00                                ; 0CBDB
  db 0x00, 0x00                                ; 0CBDD
  db 0x00, 0x00                                ; 0CBDF
  db 0x00, 0x00                                ; 0CBE1
  db 0x00, 0x00                                ; 0CBE3
  db 0x00, 0x00                                ; 0CBE5
  db 0x00, 0x00                                ; 0CBE7
  db 0x00, 0x00                                ; 0CBE9
  db 0x00, 0x00                                ; 0CBEB
  db 0x00, 0x00                                ; 0CBED
  db 0x00, 0x00                                ; 0CBEF
  db 0x00, 0x00                                ; 0CBF1
  db 0x00, 0x00                                ; 0CBF3
  db 0x00, 0x00                                ; 0CBF5
  db 0x00, 0x00                                ; 0CBF7
  db 0x00, 0x00                                ; 0CBF9
  db 0x00, 0x00                                ; 0CBFB
  db 0x00, 0x00                                ; 0CBFD
  db 0x00, 0x00                                ; 0CBFF
  db 0x00, 0x00                                ; 0CC01
  db 0x00, 0x00                                ; 0CC03
  db 0x00, 0x00                                ; 0CC05
  db 0x00, 0x00                                ; 0CC07
  db 0x00, 0x00                                ; 0CC09
  db 0x00, 0x00                                ; 0CC0B
  db 0x00, 0x00                                ; 0CC0D
  db 0x00, 0x00                                ; 0CC0F
  db 0x00, 0x00                                ; 0CC11
  db 0x00, 0x00                                ; 0CC13
  db 0x00, 0x00                                ; 0CC15
  db 0x00, 0x00                                ; 0CC17
  db 0x00, 0x00                                ; 0CC19
  db 0x00, 0x00                                ; 0CC1B
  db 0x00, 0x00                                ; 0CC1D
  db 0x00, 0x00                                ; 0CC1F
  db 0x00, 0x00                                ; 0CC21
  db 0x00, 0x00                                ; 0CC23
  db 0x00, 0x00                                ; 0CC25
  db 0x00, 0x00                                ; 0CC27
  db 0x00, 0x00                                ; 0CC29
  db 0x00, 0x00                                ; 0CC2B
  db 0x00, 0x00                                ; 0CC2D
  db 0x00, 0x00                                ; 0CC2F
  db 0x00, 0x00                                ; 0CC31
  db 0x00, 0x00                                ; 0CC33
  db 0x00, 0x00                                ; 0CC35
  db 0x00, 0x00                                ; 0CC37
  db 0x00, 0x00                                ; 0CC39
  db 0x00, 0x00                                ; 0CC3B
  db 0x00, 0x00                                ; 0CC3D
  db 0x00, 0x00                                ; 0CC3F
  db 0x00, 0x00                                ; 0CC41
  db 0x00, 0x00                                ; 0CC43
  db 0x00, 0x00                                ; 0CC45
  test [bx + si], al                           ; 0CC47  0x84, 0x00
  mov [bx + si], al                            ; 0CC49  0x88, 0x00
  test [bx + si], ax                           ; 0CC4B  0x85, 0x00
  mov [bx + si], al                            ; 0CC4D  0x88, 0x00
  db 0x00, 0x00                                ; 0CC4F
  db 0x00, 0x00                                ; 0CC51
  db 0x00, 0x00                                ; 0CC53
  db 0x00, 0x00                                ; 0CC55
  db 0x00, 0x00                                ; 0CC57
  db 0x00, 0x00                                ; 0CC59
  db 0x00, 0x00                                ; 0CC5B
  db 0x00, 0x00                                ; 0CC5D
  db 0x00, 0x00                                ; 0CC5F
  db 0x00, 0x00                                ; 0CC61
  db 0x00, 0x00                                ; 0CC63
  db 0x00, 0x00                                ; 0CC65
  db 0x00, 0x00                                ; 0CC67
  db 0x00, 0x00                                ; 0CC69
  db 0x00, 0x00                                ; 0CC6B
  db 0x00, 0x00                                ; 0CC6D
  db 0x00, 0x00                                ; 0CC6F
  db 0x00, 0x00                                ; 0CC71
  db 0x00, 0x00                                ; 0CC73
  db 0x00, 0x00                                ; 0CC75
  db 0x00, 0x00                                ; 0CC77
  db 0x00, 0x00                                ; 0CC79
  db 0x00, 0x00                                ; 0CC7B
  db 0x00, 0x00                                ; 0CC7D
  db 0x00, 0x00                                ; 0CC7F
  db 0x00, 0x00                                ; 0CC81
  db 0x00, 0x00                                ; 0CC83
  db 0x00, 0x00                                ; 0CC85
  db 0x00, 0x00                                ; 0CC87
  db 0x00, 0x00                                ; 0CC89
  db 0x00, 0x00                                ; 0CC8B
  db 0x00, 0x00                                ; 0CC8D
  db 0x00, 0x00                                ; 0CC8F
  db 0x00, 0x00                                ; 0CC91
  db 0x00, 0x00                                ; 0CC93
  db 0x00, 0x00                                ; 0CC95
  db 0x00, 0x00                                ; 0CC97
  db 0x00, 0x00                                ; 0CC99
  db 0x00, 0x00                                ; 0CC9B
  db 0x00, 0x00                                ; 0CC9D
  db 0x00, 0x00                                ; 0CC9F
  db 0x00, 0x00                                ; 0CCA1
  db 0x00, 0x00                                ; 0CCA3
  db 0x00, 0x00                                ; 0CCA5
  db 0x00, 0x00                                ; 0CCA7
  db 0x00, 0x00                                ; 0CCA9
  db 0x00, 0x00                                ; 0CCAB
  db 0x00, 0x00                                ; 0CCAD
  db 0x00, 0x00                                ; 0CCAF
  db 0x00, 0x00                                ; 0CCB1
  db 0x00, 0x00                                ; 0CCB3
  db 0x00, 0x00                                ; 0CCB5
  db 0x00, 0x00                                ; 0CCB7
  db 0x00, 0x00                                ; 0CCB9
  db 0x00, 0x00                                ; 0CCBB
  db 0x00, 0x00                                ; 0CCBD
  db 0x00, 0x00                                ; 0CCBF
  db 0x00, 0x00                                ; 0CCC1
  db 0x00, 0x00                                ; 0CCC3
  db 0x00, 0x00                                ; 0CCC5
  db 0x00, 0x00                                ; 0CCC7
  db 0x00, 0x00                                ; 0CCC9
  db 0x00, 0x00                                ; 0CCCB
  db 0x00, 0x00                                ; 0CCCD
  test [bx + si], al                           ; 0CCCF  0x84, 0x00
  mov [bx + si], al                            ; 0CCD1  0x88, 0x00
  test [bx + si], ax                           ; 0CCD3  0x85, 0x00
  mov [bx + si], al                            ; 0CCD5  0x88, 0x00
  mov es, [bx + si]                            ; 0CCD7  0x8E, 0x00
  add [bx + di], al                            ; 0CCD9  0x00, 0x01
  or word [bx + di], 0                         ; 0CCDB  0x83, 0x09, 0x00
  push ax                                      ; 0CCDE  0x50
  xchg [bx + si], ax                           ; 0CCDF  0x87, 0x00
  mov [bx + di], al                            ; 0CCE1  0x88, 0x01
  add word [bx + si], 4                        ; 0CCE3  0x83, 0x00, 0x04
  push ax                                      ; 0CCE6  0x50
  mov al, [bx + si]                            ; 0CCE7  0x8A, 0x00
  db 0x00, 0x00                                ; 0CCE9
  db 0x00, 0x00                                ; 0CCEB
  db 0x00, 0x00                                ; 0CCED
  db 0x00, 0x00                                ; 0CCEF
  db 0x00, 0x00                                ; 0CCF1
  db 0x00, 0x00                                ; 0CCF3
  db 0x00, 0x00                                ; 0CCF5
  db 0x00, 0x00                                ; 0CCF7
  db 0x00, 0x00                                ; 0CCF9
  db 0x00, 0x00                                ; 0CCFB
  db 0x00, 0x00                                ; 0CCFD
  db 0x00, 0x00                                ; 0CCFF
  db 0x00, 0x00                                ; 0CD01
  db 0x00, 0x00                                ; 0CD03
  db 0x00, 0x00                                ; 0CD05
  db 0x00, 0x00                                ; 0CD07
  db 0x00, 0x00                                ; 0CD09
  db 0x00, 0x00                                ; 0CD0B
  db 0x00, 0x00                                ; 0CD0D
  db 0x00, 0x00                                ; 0CD0F
  db 0x00, 0x00                                ; 0CD11
  db 0x00, 0x00                                ; 0CD13
  db 0x00, 0x00                                ; 0CD15
  db 0x00, 0x00                                ; 0CD17
  db 0x00, 0x00                                ; 0CD19
  db 0x00, 0x00                                ; 0CD1B
  db 0x00, 0x00                                ; 0CD1D
  db 0x00, 0x00                                ; 0CD1F
  db 0x00, 0x00                                ; 0CD21
  db 0x00, 0x00                                ; 0CD23
  db 0x00, 0x00                                ; 0CD25
  db 0x00, 0x00                                ; 0CD27
  db 0x00, 0x00                                ; 0CD29
  db 0x00, 0x00                                ; 0CD2B
  db 0x00, 0x00                                ; 0CD2D
  db 0x00, 0x00                                ; 0CD2F
  db 0x00, 0x00                                ; 0CD31
  db 0x00, 0x00                                ; 0CD33
  db 0x00, 0x00                                ; 0CD35
  db 0x00, 0x00                                ; 0CD37
  db 0x00, 0x00                                ; 0CD39
  db 0x00, 0x00                                ; 0CD3B
  db 0x00, 0x00                                ; 0CD3D
  db 0x00, 0x00                                ; 0CD3F
  db 0x00, 0x00                                ; 0CD41
  db 0x00, 0x00                                ; 0CD43
  db 0x00, 0x00                                ; 0CD45
  db 0x00, 0x00                                ; 0CD47
  db 0x00, 0x00                                ; 0CD49
  db 0x00, 0x00                                ; 0CD4B
  db 0x00, 0x00                                ; 0CD4D
  db 0x00, 0x00                                ; 0CD4F
  db 0x00, 0x00                                ; 0CD51
  db 0x00, 0x00                                ; 0CD53
  db 0x00, 0x00                                ; 0CD55
  db 0x00, 0x00                                ; 0CD57
  db 0x00, 0x00                                ; 0CD59
  db 0x00, 0x00                                ; 0CD5B
  db 0x00, 0x00                                ; 0CD5D
  db 0x00, 0x00                                ; 0CD5F
  db 0x00, 0x00                                ; 0CD61
  db 0x00, 0x00                                ; 0CD63
  db 0x00, 0x00                                ; 0CD65
  db 0x00, 0x00                                ; 0CD67
  db 0x00, 0x00                                ; 0CD69
  db 0x00, 0x00                                ; 0CD6B
  db 0x00, 0x00                                ; 0CD6D
  db 0x00, 0x00                                ; 0CD6F
  db 0x00, 0x00                                ; 0CD71
  db 0x00, 0x00                                ; 0CD73
  db 0x00, 0x00                                ; 0CD75
  db 0x00, 0x00                                ; 0CD77
  db 0x00, 0x00                                ; 0CD79
  db 0x00, 0x00                                ; 0CD7B
  db 0x00, 0x00                                ; 0CD7D
  db 0x00, 0x00                                ; 0CD7F
  db 0x00, 0x00                                ; 0CD81
  db 0x00, 0x00                                ; 0CD83
  db 0x00, 0x00                                ; 0CD85
  db 0x00, 0x00                                ; 0CD87
  db 0x00, 0x00                                ; 0CD89
  adc word [bp + si - 0x79], 0xcff             ; 0CD8B  0x81, 0x52, 0x87, 0xFF, 0x0C
  push ax                                      ; 0CD90  0x50
  mov ah, [bx + si]                            ; 0CD91  0x8A, 0x20
  or [bx + si], al                             ; 0CD93  0x08, 0x00
  add word [bx + si], 0xa000                   ; 0CD95  0x81, 0x00, 0x00, 0xA0
  add [bx + si + 1], al                        ; 0CD99  0x00, 0x40, 0x01
  db 0xE0, 0x01                                ; 0CD9C  loopne 0xcd9f
  add byte [bp + si], 0x20                     ; 0CD9E  0x80, 0x02, 0x20
  db 0x03, 0xC0                                ; 0CDA1  add ax, ax
  add sp, [bx + si + 4]                        ; 0CDA3  0x03, 0x60, 0x04
  add [di], al                                 ; 0CDA6  0x00, 0x05
  mov al, [0x4005]                             ; 0CDA8  0xA0, 0x05, 0x40
  push es                                      ; 0CDAB  0x06
  db 0xE0, 0x06                                ; 0CDAC  loopne 0xcdb4
  add byte [bx], 0x20                          ; 0CDAE  0x80, 0x07, 0x20
  or al, al                                    ; 0CDB1  0x08, 0xC0
  or [bx + si + 9], ah                         ; 0CDB3  0x08, 0x60, 0x09
  add [bp + si], cl                            ; 0CDB6  0x00, 0x0A
  mov al, [0x400a]                             ; 0CDB8  0xA0, 0x0A, 0x40
  db 0x0B, 0xE0                                ; 0CDBB  or sp, ax
  or ax, [bx + si + 0x200c]                    ; 0CDBD  0x0B, 0x80, 0x0C, 0x20
  or ax, 0xdc0                                 ; 0CDC1  0x0D, 0xC0, 0x0D
  pusha                                        ; 0CDC4  60
  push cs                                      ; 0CDC5  0x0E
  dec dx                                       ; 0CDC6  0x4A
  popa                                         ; 0CDC7  61
  db 0x00, 0x00                                ; 0CDC8
  clc                                          ; 0CDCA  0xF8
  inc word [bx + si]                           ; 0CDCB  0xFF, 0x00
  db 0x00, 0x00                                ; 0CDCD
  add ah, cl                                   ; 0CDCF  0x00, 0xCC
  db 0xCC                                      ; 0CDD1  int3
  db 0xCC                                      ; 0CDD2  int3
  db 0xCC                                      ; 0CDD3  int3
  db 0xCC                                      ; 0CDD4  int3
  db 0xCC                                      ; 0CDD5  int3
  db 0xCC                                      ; 0CDD6  int3
  db 0xCC                                      ; 0CDD7  int3
  db 0xCC                                      ; 0CDD8  int3
  db 0xCC                                      ; 0CDD9  int3
  db 0xCC                                      ; 0CDDA  int3
  db 0xCC                                      ; 0CDDB  int3
  db 0xCC                                      ; 0CDDC  int3
  db 0xCC                                      ; 0CDDD  int3
  db 0xCC                                      ; 0CDDE  int3
  db 0xCC                                      ; 0CDDF  int3
  db 0xCC                                      ; 0CDE0  int3
  db 0xCC                                      ; 0CDE1  int3
  db 0xCC                                      ; 0CDE2  int3
  db 0xCC                                      ; 0CDE3  int3
  db 0xCC                                      ; 0CDE4  int3
  db 0xCC                                      ; 0CDE5  int3
  db 0xCC                                      ; 0CDE6  int3
  db 0xCC                                      ; 0CDE7  int3
  db 0xCC                                      ; 0CDE8  int3
  db 0xCC                                      ; 0CDE9  int3
  db 0xCC                                      ; 0CDEA  int3
  db 0xCC                                      ; 0CDEB  int3
  db 0xCC                                      ; 0CDEC  int3
  db 0xCC                                      ; 0CDED  int3
  db 0xCC                                      ; 0CDEE  int3
  db 0xCC                                      ; 0CDEF  int3
  db 0xCC                                      ; 0CDF0  int3
  db 0xCC                                      ; 0CDF1  int3
  db 0xCC                                      ; 0CDF2  int3
  db 0xCC                                      ; 0CDF3  int3
  db 0xCC                                      ; 0CDF4  int3
  db 0xCC                                      ; 0CDF5  int3
  db 0xCC                                      ; 0CDF6  int3
  db 0xCC                                      ; 0CDF7  int3
  db 0xCC                                      ; 0CDF8  int3
  db 0xCC                                      ; 0CDF9  int3
  db 0xCC                                      ; 0CDFA  int3
  db 0xCC                                      ; 0CDFB  int3
  db 0xCC                                      ; 0CDFC  int3
  db 0xCC                                      ; 0CDFD  int3
  db 0xCC                                      ; 0CDFE  int3
  db 0xCC                                      ; 0CDFF  int3
  db 0xCC                                      ; 0CE00  int3
  db 0xCC                                      ; 0CE01  int3
  db 0xCC                                      ; 0CE02  int3
  db 0xCC                                      ; 0CE03  int3
  db 0xCC                                      ; 0CE04  int3
  db 0xCC                                      ; 0CE05  int3
  db 0xCC                                      ; 0CE06  int3
  db 0xCC                                      ; 0CE07  int3
  db 0xCC                                      ; 0CE08  int3
  db 0xCC                                      ; 0CE09  int3
  db 0xCC                                      ; 0CE0A  int3
  db 0xCC                                      ; 0CE0B  int3
  db 0xCC                                      ; 0CE0C  int3
  db 0xCC                                      ; 0CE0D  int3
  db 0xCC                                      ; 0CE0E  int3
  db 0xCC                                      ; 0CE0F  int3
  db 0xCC                                      ; 0CE10  int3
  db 0xCC                                      ; 0CE11  int3
  db 0xCC                                      ; 0CE12  int3
  db 0xCC                                      ; 0CE13  int3
  db 0xCC                                      ; 0CE14  int3
  db 0xCC                                      ; 0CE15  int3
  db 0xCC                                      ; 0CE16  int3
  db 0xCC                                      ; 0CE17  int3
  db 0xCC                                      ; 0CE18  int3
  db 0xCC                                      ; 0CE19  int3
  db 0xCC                                      ; 0CE1A  int3
  db 0xCC                                      ; 0CE1B  int3
  db 0xCC                                      ; 0CE1C  int3
  db 0xCC                                      ; 0CE1D  int3
  db 0xCC                                      ; 0CE1E  int3
  db 0xCC                                      ; 0CE1F  int3
  db 0xCC                                      ; 0CE20  int3
  db 0xCC                                      ; 0CE21  int3
  db 0xCC                                      ; 0CE22  int3
  db 0xCC                                      ; 0CE23  int3
  db 0xCC                                      ; 0CE24  int3
  db 0xCC                                      ; 0CE25  int3
  db 0xCC                                      ; 0CE26  int3
  db 0xCC                                      ; 0CE27  int3
  db 0xCC                                      ; 0CE28  int3
  db 0xCC                                      ; 0CE29  int3
  db 0xCC                                      ; 0CE2A  int3
  db 0xCC                                      ; 0CE2B  int3
  db 0xCC                                      ; 0CE2C  int3
  db 0xCC                                      ; 0CE2D  int3
  db 0xCC                                      ; 0CE2E  int3
  db 0xCC                                      ; 0CE2F  int3
  db 0xCC                                      ; 0CE30  int3
  db 0xCC                                      ; 0CE31  int3
  db 0xCC                                      ; 0CE32  int3
  db 0xCC                                      ; 0CE33  int3
  db 0xCC                                      ; 0CE34  int3
  db 0xCC                                      ; 0CE35  int3
  db 0xCC                                      ; 0CE36  int3
  db 0xCC                                      ; 0CE37  int3
  db 0xCC                                      ; 0CE38  int3
  db 0xCC                                      ; 0CE39  int3
  db 0xCC                                      ; 0CE3A  int3
  db 0xCC                                      ; 0CE3B  int3
  db 0xCC                                      ; 0CE3C  int3
  db 0xCC                                      ; 0CE3D  int3
  db 0xCC                                      ; 0CE3E  int3
  db 0xCC                                      ; 0CE3F  int3
  db 0xCC                                      ; 0CE40  int3
  db 0xCC                                      ; 0CE41  int3
  db 0xCC                                      ; 0CE42  int3
  db 0xCC                                      ; 0CE43  int3
  db 0xCC                                      ; 0CE44  int3
  db 0xCC                                      ; 0CE45  int3
  db 0xCC                                      ; 0CE46  int3
  db 0xCC                                      ; 0CE47  int3
  db 0xCC                                      ; 0CE48  int3
  db 0xCC                                      ; 0CE49  int3
  db 0xCC                                      ; 0CE4A  int3
  db 0xCC                                      ; 0CE4B  int3
  db 0xCC                                      ; 0CE4C  int3
  db 0xCC                                      ; 0CE4D  int3
  db 0xCC                                      ; 0CE4E  int3
  db 0xCC                                      ; 0CE4F  int3
  db 0xCC                                      ; 0CE50  int3
  db 0xCC                                      ; 0CE51  int3
  db 0xCC                                      ; 0CE52  int3
  db 0xCC                                      ; 0CE53  int3
  db 0xCC                                      ; 0CE54  int3
  db 0xCC                                      ; 0CE55  int3
  db 0xCC                                      ; 0CE56  int3
  db 0xCC                                      ; 0CE57  int3
  db 0xCC                                      ; 0CE58  int3
  db 0xCC                                      ; 0CE59  int3
  db 0xCC                                      ; 0CE5A  int3
  db 0xCC                                      ; 0CE5B  int3
  db 0xCC                                      ; 0CE5C  int3
  db 0xCC                                      ; 0CE5D  int3
  db 0xCC                                      ; 0CE5E  int3
  db 0xCC                                      ; 0CE5F  int3
  db 0xCC                                      ; 0CE60  int3
  db 0xCC                                      ; 0CE61  int3
  db 0xCC                                      ; 0CE62  int3
  db 0xCC                                      ; 0CE63  int3
  db 0xCC                                      ; 0CE64  int3
  db 0xCC                                      ; 0CE65  int3
  db 0xCC                                      ; 0CE66  int3
  db 0xCC                                      ; 0CE67  int3
  db 0xCC                                      ; 0CE68  int3
  db 0xCC                                      ; 0CE69  int3
  db 0xCC                                      ; 0CE6A  int3
  db 0xCC                                      ; 0CE6B  int3
  db 0xCC                                      ; 0CE6C  int3
  db 0xCC                                      ; 0CE6D  int3
  db 0xCC                                      ; 0CE6E  int3
  db 0xCC                                      ; 0CE6F  int3
  db 0xCC                                      ; 0CE70  int3
  db 0xCC                                      ; 0CE71  int3
  db 0xCC                                      ; 0CE72  int3
  db 0xCC                                      ; 0CE73  int3
  db 0xCC                                      ; 0CE74  int3
  db 0xCC                                      ; 0CE75  int3
  db 0xCC                                      ; 0CE76  int3
  db 0xCC                                      ; 0CE77  int3
  db 0xCC                                      ; 0CE78  int3
  db 0xCC                                      ; 0CE79  int3
  db 0xCC                                      ; 0CE7A  int3
  db 0xCC                                      ; 0CE7B  int3
  db 0xCC                                      ; 0CE7C  int3
  db 0xCC                                      ; 0CE7D  int3
  db 0xCC                                      ; 0CE7E  int3
  db 0xCC                                      ; 0CE7F  int3
  db 0xCC                                      ; 0CE80  int3
  db 0xCC                                      ; 0CE81  int3
  db 0xCC                                      ; 0CE82  int3
  db 0xCC                                      ; 0CE83  int3
  db 0xCC                                      ; 0CE84  int3
  db 0xCC                                      ; 0CE85  int3
  db 0xCC                                      ; 0CE86  int3
  db 0xCC                                      ; 0CE87  int3
  db 0xCC                                      ; 0CE88  int3
  db 0xCC                                      ; 0CE89  int3
  db 0xCC                                      ; 0CE8A  int3
  db 0xCC                                      ; 0CE8B  int3
  db 0xCC                                      ; 0CE8C  int3
  db 0xCC                                      ; 0CE8D  int3
  db 0xCC                                      ; 0CE8E  int3
  db 0xCC                                      ; 0CE8F  int3
  db 0xCC                                      ; 0CE90  int3
  db 0xCC                                      ; 0CE91  int3
  db 0xCC                                      ; 0CE92  int3
  db 0xCC                                      ; 0CE93  int3
  db 0xCC                                      ; 0CE94  int3
  db 0xCC                                      ; 0CE95  int3
  db 0xCC                                      ; 0CE96  int3
  db 0xCC                                      ; 0CE97  int3
  db 0xCC                                      ; 0CE98  int3
  db 0xCC                                      ; 0CE99  int3
  db 0xCC                                      ; 0CE9A  int3
  db 0xCC                                      ; 0CE9B  int3
  db 0xCC                                      ; 0CE9C  int3
  db 0xCC                                      ; 0CE9D  int3
  db 0xCC                                      ; 0CE9E  int3
  db 0xCC                                      ; 0CE9F  int3
  db 0xCC                                      ; 0CEA0  int3
  db 0xCC                                      ; 0CEA1  int3
  db 0xCC                                      ; 0CEA2  int3
  db 0xCC                                      ; 0CEA3  int3
  db 0xCC                                      ; 0CEA4  int3
  db 0xCC                                      ; 0CEA5  int3
  db 0xCC                                      ; 0CEA6  int3
  db 0xCC                                      ; 0CEA7  int3
  db 0xCC                                      ; 0CEA8  int3
  db 0xCC                                      ; 0CEA9  int3
  db 0xCC                                      ; 0CEAA  int3
  db 0xCC                                      ; 0CEAB  int3
  db 0xCC                                      ; 0CEAC  int3
  db 0xCC                                      ; 0CEAD  int3
  db 0xCC                                      ; 0CEAE  int3
  db 0xCC                                      ; 0CEAF  int3
  db 0xCC                                      ; 0CEB0  int3
  db 0xCC                                      ; 0CEB1  int3
  db 0xCC                                      ; 0CEB2  int3
  db 0xCC                                      ; 0CEB3  int3
  db 0xCC                                      ; 0CEB4  int3
  db 0xCC                                      ; 0CEB5  int3
  db 0xCC                                      ; 0CEB6  int3
  db 0xCC                                      ; 0CEB7  int3
  db 0xCC                                      ; 0CEB8  int3
  db 0xCC                                      ; 0CEB9  int3
  db 0xCC                                      ; 0CEBA  int3
  db 0xCC                                      ; 0CEBB  int3
  db 0xCC                                      ; 0CEBC  int3
  db 0xCC                                      ; 0CEBD  int3
  db 0xCC                                      ; 0CEBE  int3
  db 0xCC                                      ; 0CEBF  int3
  db 0xCC                                      ; 0CEC0  int3
  db 0xCC                                      ; 0CEC1  int3
  db 0xCC                                      ; 0CEC2  int3
  db 0xCC                                      ; 0CEC3  int3
  db 0xCC                                      ; 0CEC4  int3
  db 0xCC                                      ; 0CEC5  int3
  db 0xCC                                      ; 0CEC6  int3
  db 0xCC                                      ; 0CEC7  int3
  db 0xCC                                      ; 0CEC8  int3
  db 0xCC                                      ; 0CEC9  int3
  db 0xCC                                      ; 0CECA  int3
  db 0xCC                                      ; 0CECB  int3
  db 0xCC                                      ; 0CECC  int3
  db 0xCC                                      ; 0CECD  int3
  db 0xCC                                      ; 0CECE  int3
  db 0xCC                                      ; 0CECF  int3
