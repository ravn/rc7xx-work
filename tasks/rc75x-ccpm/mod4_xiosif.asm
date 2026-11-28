; ===========================================================================
; Modul 4: RC759 Hardware XIOS & SYSDAT (Flemming Kraglund)
; Offset range: 0x03AD0 - 0x0FD3F (49.776 bytes)
; ===========================================================================

; ISO-646-DK (Dansk 7-bit tegnsæt til RC759 Piccoline)
%define æ 0x7B
%define ø 0x7C
%define å 0x7D
%define Æ 0x5B
%define Ø 0x5C
%define Å 0x5D

; RC759 Hardware I/O Ports and Definitions
%include "hardware.inc"
%include "license.inc"   ; LICENSE_NO + SERIAL til copyright-strenge


mod4_base:
  jmp near mod4_xios_init                      ; 03AD0  0xE9, 0x49, 0x00
  jmp near mod4_xios_entry                     ; 03AD3  0xE9, 0xD7, 0x00
  cli                                          ; 03AD6  0xFA
  push es                                      ; 03AD7  0x06
  dw 0x0003                                    ; 03AD8  MEMIF version
  dw 0x0048                                    ; 03ADA  Segment
  db 0x06, 0x00                                ; 03ADC
  db "COPYRIGHT(C)1983,84,DIGITAL RESEARCH(02/07/84)", LICENSE_NO, SERIAL  ; 03ADE

mod4_xios_init:                                ; 03B1C
  retf                                         ; 03B1C  0xCB
; =============================================================================
; XIOS Function Dispatch Table (48 Funktioner: 32 standard + 16 udvidede)
; Placering: CS:004Dh (filoffset 0x03B1D - 0x03BAD, 144 bytes)
; Format pr. post: dw routine_offset, db flags
;   - routine_offset: Forskydning i CS relativt til mod4_base
;   - flags bit 0:    1 = Kræver synkronisering/kø-lås via sub_03BEC
;                     0 = Direkte kald (call word [cs:si])
; =============================================================================
xios_jump_table:
  dw xios_fn_init - mod4_base
  db 0x01     ; Func  0: ?init (CS:2466h, file 0x05F36)
  dw xios_fn_wboot - mod4_base
  db 0x01     ; Func  1: ?wboot (CS:249Dh, file 0x05F6D)
  dw xios_fn_const - mod4_base
  db 0x15     ; Func  2: ?const (console status) (CS:24ABh, file 0x05F7B)
  dw xios_fn_conin - mod4_base
  db 0x15     ; Func  3: ?conin (console input) (CS:2723h, file 0x061F3)
  dw xios_fn_conout - mod4_base
  db 0x05     ; Func  4: ?conout (console output) (CS:27B7h, file 0x06287)
  dw xios_fn_list - mod4_base
  db 0x01     ; Func  5: ?list (printer output) (CS:2826h, file 0x062F6)
  dw xios_fn_auxout - mod4_base
  db 0x15     ; Func  6: ?auxout (serial output) (CS:2849h, file 0x06319)
  dw xios_fn_auxin - mod4_base
  db 0x17     ; Func  7: ?auxin (serial input) (CS:284Fh, file 0x0631F)
  dw xios_fn_home - mod4_base
  db 0x17     ; Func  8: ?home (disk home) (CS:2855h, file 0x06325)
  dw xios_fn_seldsk - mod4_base
  db 0x05     ; Func  9: ?seldsk (select disk) (CS:285Bh, file 0x0632B)
  dw xios_fn_settrk - mod4_base
  db 0x15     ; Func 10: ?settrk (set track) (CS:29BEh, file 0x0648E)
  dw xios_fn_setsec - mod4_base
  db 0x00     ; Func 11: ?setsec (set sector) (CS:2F75h, file 0x06A45)
  dw xios_fn_setdma - mod4_base
  db 0x00     ; Func 12: ?setdma (set DMA offset) (CS:2F7Ah, file 0x06A4A)
  dw xios_fn_read - mod4_base
  db 0x00     ; Func 13: ?read (read sector) (CS:2F82h, file 0x06A52)
  dw xios_fn_write - mod4_base
  db 0x01     ; Func 14: ?write (write sector) (CS:2A31h, file 0x06501)
  dw xios_fn_listst - mod4_base
  db 0x01     ; Func 15: ?listst (printer status) (CS:2A3Eh, file 0x0650E)
  dw xios_fn_sectrn - mod4_base
  db 0x00     ; Func 16: ?sectrn (sector translate) (CS:2F88h, file 0x06A58)
  dw xios_fn_setdmab - mod4_base
  db 0x05     ; Func 17: ?setdmab (set DMA base segment) (CS:2A65h, file 0x06535)
  dw xios_fn_getsegt - mod4_base
  db 0x01     ; Func 18: ?getsegt (get mem segment table) (CS:2AA3h, file 0x06573)
  dw xios_fn_alloc - mod4_base
  db 0x00     ; Func 19: ?alloc (allocate memory) (CS:2F8Dh, file 0x06A5D)
  dw xios_fn_dealloc - mod4_base
  db 0x1B     ; Func 20: ?dealloc (deallocate memory) (CS:2AB3h, file 0x06583)
  dw xios_fn_dskreset - mod4_base
  db 0x1B     ; Func 21: ?dskreset (disk reset) (CS:2AC0h, file 0x06590)
  dw xios_fn_select - mod4_base
  db 0x19     ; Func 22: ?select (select disk drive) (CS:2ACDh, file 0x0659D)
  dw xios_fn_conbrk - mod4_base
  db 0x09     ; Func 23: ?conbrk (console break test) (CS:2AFAh, file 0x065CA)
  dw xios_fn_poll - mod4_base
  db 0x01     ; Func 24: ?poll (device poll) (CS:2B0Ah, file 0x065DA)
  dw xios_fn_flag - mod4_base
  db 0x01     ; Func 25: ?flag (CCP/M flag handler) (CS:2B24h, file 0x065F4)
  dw xios_fn_tick - mod4_base
  db 0x01     ; Func 26: ?tick (system clock tick) (CS:2B83h, file 0x06653)
  dw xios_fn_timedate - mod4_base
  db 0x1B     ; Func 27: ?timedate (get/set time & date) (CS:2BD2h, file 0x066A2)
  dw xios_fn_delay - mod4_base
  db 0x19     ; Func 28: ?delay (system delay) (CS:2BE0h, file 0x066B0)
  dw xios_fn_stop - mod4_base
  db 0x19     ; Func 29: ?stop (stop process / wait) (CS:2BE8h, file 0x066B8)
  dw xios_fn_exit - mod4_base
  db 0x00     ; Func 30: ?exit (exit process) (CS:2FA1h, file 0x06A71)
  dw xios_fn_idle - mod4_base
  db 0x00     ; Func 31: ?idle (CPU idle) (CS:2FB4h, file 0x06A84)
  dw xios_fn_ext32 - mod4_base
  db 0x01     ; Func 32: extended function 32 (CS:2BF0h, file 0x066C0)
  dw xios_fn_ext33 - mod4_base
  db 0x01     ; Func 33: extended function 33 (CS:2C30h, file 0x06700)
  dw xios_fn_ext34 - mod4_base
  db 0x00     ; Func 34: extended function 34 (CS:2FBAh, file 0x06A8A)
  dw xios_fn_ext35 - mod4_base
  db 0x00     ; Func 35: extended function 35 (CS:2FC0h, file 0x06A90)
  dw xios_fn_ext36 - mod4_base
  db 0x01     ; Func 36: extended function 36 (CS:2C3Fh, file 0x0670F)
  dw xios_fn_ext37 - mod4_base
  db 0x09     ; Func 37: extended function 37 (CS:2CC5h, file 0x06795)
  dw xios_fn_ext38 - mod4_base
  db 0x05     ; Func 38: extended function 38 (CS:2DC6h, file 0x06896)
  dw xios_fn_ext39 - mod4_base
  db 0x01     ; Func 39: extended function 39 (CS:2E42h, file 0x06912)
  dw xios_fn_ext40 - mod4_base
  db 0x05     ; Func 40: extended function 40 (CS:2E4Bh, file 0x0691B)
  dw xios_fn_ext41 - mod4_base
  db 0x05     ; Func 41: extended function 41 (CS:2E84h, file 0x06954)
  dw xios_fn_ext42 - mod4_base
  db 0x00     ; Func 42: extended function 42 (CS:2FCEh, file 0x06A9E)
  dw xios_fn_ext43 - mod4_base
  db 0x00     ; Func 43: extended function 43 (CS:2FE9h, file 0x06AB9)
  dw xios_fn_ext44 - mod4_base
  db 0x01     ; Func 44: extended function 44 (CS:2F00h, file 0x069D0)
  dw xios_fn_ext45 - mod4_base
  db 0x15     ; Func 45: extended function 45 (CS:2F18h, file 0x069E8)
  dw xios_fn_ext46 - mod4_base
  db 0x01     ; Func 46: extended function 46 (CS:1EF7h, file 0x059C7)
  dw xios_fn_ext47 - mod4_base
  db 0x01     ; Func 47: extended function 47 (CS:2F74h, file 0x06A44)

mod4_xios_entry:                               ; 03BAD
  xor_ch_ch                                    ; 03BAD  xor ch, ch
  mov_si_cx                                    ; 03BAF  mov si, cx
  shl si, 1                                    ; 03BB1  0xD1, 0xE6
  add_si_cx                                    ; 03BB3  add si, cx
  add si, strict word 0x4d                     ; 03BB5  0x81, 0xC6, 0x4D, 0x00
  test byte [cs:si + 2], 1                     ; 03BB9  0x2E, 0xF6, 0x44, 0x02, 0x01
  je loc_03BC5                                 ; 03BBE  0x74, 0x05
  call sub_03BEC                               ; 03BC0  0xE8, 0x29, 0x00
  jmp short loc_03BCA                          ; 03BC3  0xEB, 0x05

loc_03BC5:                                     ; 03BC5
  xor_bx_bx                                    ; 03BC5  xor bx, bx
  call word [cs:si]                            ; 03BC7  0x2E, 0xFF, 0x14

loc_03BCA:                                     ; 03BCA
  mov_ax_bx                                    ; 03BCA  mov ax, bx
  retf                                         ; 03BCC  0xCB

loc_03BCD:                                     ; 03BCD
  mov cl, [0x85b]                              ; 03BCD  0x8A, 0x0E, 0x5B, 0x08
  xor_ch_ch                                    ; 03BD1  xor ch, ch
  mov_si_cx                                    ; 03BD3  mov si, cx
  shl si, 1                                    ; 03BD5  0xD1, 0xE6
  add_si_cx                                    ; 03BD7  add si, cx
  add si, strict word 0x4d                     ; 03BD9  0x81, 0xC6, 0x4D, 0x00
  mov bx, [0x68]                               ; 03BDD  0x8B, 0x1E, 0x68, 0x00
  mov dx, [0x862]                              ; 03BE1  0x8B, 0x16, 0x62, 0x08
  mov es, [0x907]                              ; 03BE5  0x8E, 0x06, 0x07, 0x09
  cli                                          ; 03BE9  0xFA
  jmp short loc_03C32                          ; 03BEA  0xEB, 0x46

sub_03BEC:                                     ; 03BEC
  mov bx, [0x68]                               ; 03BEC  0x8B, 0x1E, 0x68, 0x00
  mov ax, [bx + 6]                             ; 03BF0  0x8B, 0x47, 0x06
  and ax, 0x200                                ; 03BF3  0x25, 0x00, 0x02
  push ax                                      ; 03BF6  0x50
  or word [bx + 6], 0x200                      ; 03BF7  0x81, 0x4F, 0x06, 0x00, 0x02
  push si                                      ; 03BFC  0x56
  push dx                                      ; 03BFD  0x52
  push cx                                      ; 03BFE  0x51
  mov cx, 0x89                                 ; 03BFF  0xB9, 0x89, 0x00
  mov dx, 0xb54                                ; 03C02  0xBA, 0x54, 0x0B
  call sub_03F3A                               ; 03C05  0xE8, 0x32, 0x03
  pop cx                                       ; 03C08  0x59
  pop dx                                       ; 03C09  0x5A
  pop si                                       ; 03C0A  0x5E
  or_ax_ax                                     ; 03C0B  or ax, ax
  je loc_03C12                                 ; 03C0D  0x74, 0x03
  jmp near loc_03E05                           ; 03C0F  0xE9, 0xF3, 0x01

loc_03C12:                                     ; 03C12
  mov [0x85b], cl                              ; 03C12  0x88, 0x0E, 0x5B, 0x08
  mov bx, [0x68]                               ; 03C16  0x8B, 0x1E, 0x68, 0x00
  test word [bx + 6], 0x80                     ; 03C1A  0xF7, 0x47, 0x06, 0x80, 0x00
  je loc_03C29                                 ; 03C1F  0x74, 0x08
  xor_al_al                                    ; 03C21  xor al, al
  mov bx, 0xffff                               ; 03C23  0xBB, 0xFF, 0xFF
  jmp near loc_03D07                           ; 03C26  0xE9, 0xDE, 0x00

loc_03C29:                                     ; 03C29
  cli                                          ; 03C29  0xFA
  mov [0xafc], ss                              ; 03C2A  0x8C, 0x16, 0xFC, 0x0A
  mov [0xafe], sp                              ; 03C2E  0x89, 0x26, 0xFE, 0x0A

loc_03C32:                                     ; 03C32
  mov ss, [cs:6]                               ; 03C32  0x2E, 0x8E, 0x16, 0x06, 0x00
  mov sp, 0xafa                                ; 03C37  0xBC, 0xFA, 0x0A
  sti                                          ; 03C3A  0xFB
  mov [0x885], bx                              ; 03C3B  0x89, 0x1E, 0x85, 0x08
  mov ax, [bx + 0x12]                          ; 03C3F  0x8B, 0x47, 0x12
  mov [0x860], ax                              ; 03C42  0xA3, 0x60, 0x08
  mov ax, [es:0x2e]                            ; 03C45  0x26, 0xA1, 0x2E, 0x00
  mov [0x909], ax                              ; 03C49  0xA3, 0x09, 0x09
  mov ax, [es:0x30]                            ; 03C4C  0x26, 0xA1, 0x30, 0x00
  mov [0x90b], ax                              ; 03C50  0xA3, 0x0B, 0x09
  mov byte [es:0x67], 0xff                     ; 03C53  0x26, 0xC6, 0x06, 0x67, 0x00, 0xFF
  push es                                      ; 03C59  0x06
  mov [0x907], es                              ; 03C5A  0x8C, 0x06, 0x07, 0x09
  push si                                      ; 03C5E  0x56
  mov ax, ds                                   ; 03C5F  0x8C, 0xD8
  mov bx, es                                   ; 03C61  0x8C, 0xC3
  mov ds, bx                                   ; 03C63  0x8E, 0xDB
  mov es, ax                                   ; 03C65  0x8E, 0xC0
  mov si, 2                                    ; 03C67  0xBE, 0x02, 0x00
  mov di, 0x866                                ; 03C6A  0xBF, 0x66, 0x08
  mov cx, 0x19                                 ; 03C6D  0xB9, 0x19, 0x00
  rep movsb                                    ; 03C70  0xF3, 0xA4
  mov ds, ax                                   ; 03C72  0x8E, 0xD8
  mov ax, [0x866]                              ; 03C74  0xA1, 0x66, 0x08
  mov cl, 4                                    ; 03C77  0xB1, 0x04
  shr ax, cl                                   ; 03C79  0xD3, 0xE8
  add [0x868], ax                              ; 03C7B  0x01, 0x06, 0x68, 0x08
  and word [0x866], strict word 0xf            ; 03C7F  81 26 66 08 0F 00
  mov cx, 0x15                                 ; 03C85  0xB9, 0x15, 0x00
  xor_al_al                                    ; 03C88  xor al, al
  mov di, 0x80b                                ; 03C8A  0xBF, 0x0B, 0x08
  rep stosb                                    ; 03C8D  0xF3, 0xAA
  mov [0x862], dx                              ; 03C8F  0x89, 0x16, 0x62, 0x08
  mov [0x8ee], dl                              ; 03C93  0x88, 0x16, 0xEE, 0x08
  pop si                                       ; 03C97  0x5E
  push si                                      ; 03C98  0x56
  mov ah, [cs:si + 2]                          ; 03C99  0x2E, 0x8A, 0x64, 0x02
  test ah, 4                                   ; 03C9D  0xF6, 0xC4, 0x04
  je loc_03CA7                                 ; 03CA0  0x74, 0x05
  call sub_03F04                               ; 03CA2  0xE8, 0x5F, 0x02
  jmp short loc_03CB2                          ; 03CA5  0xEB, 0x0B

loc_03CA7:                                     ; 03CA7
  test ah, 8                                   ; 03CA7  0xF6, 0xC4, 0x08
  je loc_03CB2                                 ; 03CAA  0x74, 0x06
  call sub_03F08                               ; 03CAC  0xE8, 0x59, 0x02
  call sub_03EF3                               ; 03CAF  0xE8, 0x41, 0x02

loc_03CB2:                                     ; 03CB2
  pop si                                       ; 03CB2  0x5E
  cmp byte [0x875], 1                          ; 03CB3  0x80, 0x3E, 0x75, 0x08, 0x01
  je loc_03CC6                                 ; 03CB8  0x74, 0x0C
  test byte [cs:si + 2], 2                     ; 03CBA  0x2E, 0xF6, 0x44, 0x02, 0x02
  je loc_03CC6                                 ; 03CBF  0x74, 0x05
  call sub_03E6B                               ; 03CC1  0xE8, 0xA7, 0x01
  jmp short loc_03CC9                          ; 03CC4  0xEB, 0x03

loc_03CC6:                                     ; 03CC6
  call sub_03E22                               ; 03CC6  0xE8, 0x59, 0x01

loc_03CC9:                                     ; 03CC9
  mov cl, [0x80c]                              ; 03CC9  0x8A, 0x0E, 0x0C, 0x08
  or_cl_cl                                     ; 03CCD  or cl, cl
  je loc_03CE0                                 ; 03CCF  0x74, 0x0F
  xor_ch_ch                                    ; 03CD1  xor ch, ch
  mov si, 0xb00                                ; 03CD3  0xBE, 0x00, 0x0B
  mov di, [0x862]                              ; 03CD6  0x8B, 0x3E, 0x62, 0x08
  mov es, [0x909]                              ; 03CDA  0x8E, 0x06, 0x09, 0x09
  rep movsb                                    ; 03CDE  0xF3, 0xA4

loc_03CE0:                                     ; 03CE0
  pop es                                       ; 03CE0  0x07
  mov si, 0x86a                                ; 03CE1  0xBE, 0x6A, 0x08
  mov di, 6                                    ; 03CE4  0xBF, 0x06, 0x00
  mov cx, 0x15                                 ; 03CE7  0xB9, 0x15, 0x00
  rep movsb                                    ; 03CEA  0xF3, 0xA4
  mov ax, [0x90b]                              ; 03CEC  0xA1, 0x0B, 0x09
  mov [es:0x30], ax                            ; 03CEF  0x26, 0xA3, 0x30, 0x00
  mov bx, [0x80d]                              ; 03CF3  0x8B, 0x1E, 0x0D, 0x08
  pushf                                        ; 03CF7  0x9C
  pop ax                                       ; 03CF8  0x58
  cli                                          ; 03CF9  0xFA
  mov ss, [0xafc]                              ; 03CFA  0x8E, 0x16, 0xFC, 0x0A
  mov sp, [0xafe]                              ; 03CFE  0x8B, 0x26, 0xFE, 0x0A
  push ax                                      ; 03D02  0x50
  popf                                         ; 03D03  0x9D
  mov al, [0x81b]                              ; 03D04  0xA0, 0x1B, 0x08

loc_03D07:                                     ; 03D07
  push bx                                      ; 03D07  0x53
  test al, 0xff                                ; 03D08  0xA8, 0xFF
  je loc_03D2B                                 ; 03D0A  0x74, 0x1F
  js loc_03D23                                 ; 03D0C  0x78, 0x15
  push word [0x909]                            ; 03D0E  0xFF, 0x36, 0x09, 0x09
  mov bx, 0xffff                               ; 03D12  0xBB, 0xFF, 0xFF
  test byte [0x80f], 0xff                      ; 03D15  0xF6, 0x06, 0x0F, 0x08, 0xFF
  je loc_03D20                                 ; 03D1A  0x74, 0x04
  mov bx, [0x862]                              ; 03D1C  0x8B, 0x1E, 0x62, 0x08

loc_03D20:                                     ; 03D20
  push bx                                      ; 03D20  0x53
  jmp short loc_03D27                          ; 03D21  0xEB, 0x04

loc_03D23:                                     ; 03D23
  push word [0x90e]                            ; 03D23  0xFF, 0x36, 0x0E, 0x09

loc_03D27:                                     ; 03D27
  mov ah, [0x90d]                              ; 03D27  0x8A, 0x26, 0x0D, 0x09

loc_03D2B:                                     ; 03D2B
  push ax                                      ; 03D2B  0x50
  mov cx, 0x8b                                 ; 03D2C  0xB9, 0x8B, 0x00
  mov dx, 0xb54                                ; 03D2F  0xBA, 0x54, 0x0B
  call sub_03F3A                               ; 03D32  0xE8, 0x05, 0x02
  pop ax                                       ; 03D35  0x58
  test al, 0xff                                ; 03D36  0xA8, 0xFF
  jne loc_03D3D                                ; 03D38  0x75, 0x03
  jmp near loc_03E04                           ; 03D3A  0xE9, 0xC7, 0x00

loc_03D3D:                                     ; 03D3D
  push ax                                      ; 03D3D  0x50
  mov bx, 0xb64                                ; 03D3E  0xBB, 0x64, 0x0B
  mov cx, 0x215                                ; 03D41  0xB9, 0x15, 0x02
  call sub_03F3A                               ; 03D44  0xE8, 0xF3, 0x01
  cmp word [0x94], 0                           ; 03D47  0x83, 0x3E, 0x94, 0x00, 0x00
  je loc_03D55                                 ; 03D4C  0x74, 0x07
  call far [0x92]                              ; 03D4E  0xFF, 0x1E, 0x92, 0x00
  jmp near loc_03DF5                           ; 03D52  0xE9, 0xA0, 0x00

loc_03D55:                                     ; 03D55
  pop ax                                       ; 03D55  0x58
  add ah, 0x41                                 ; 03D56  0x80, 0xC4, 0x41
  test al, 0xff                                ; 03D59  0xA8, 0xFF
  jns loc_03D60                                ; 03D5B  0x79, 0x03
  jmp near loc_03DD3                           ; 03D5D  0xE9, 0x73, 0x00

loc_03D60:                                     ; 03D60
  push ax                                      ; 03D60  0x50
  mov [0x920], ah                              ; 03D61  0x88, 0x26, 0x20, 0x09
  mov dx, 0x910                                ; 03D65  0xBA, 0x10, 0x09
  call sub_03F2B                               ; 03D68  0xE8, 0xC0, 0x01
  pop ax                                       ; 03D6B  0x58
  mov_bl_al                                    ; 03D6C  mov bl, al
  xor_bh_bh                                    ; 03D6E  xor bh, bh
  shl bx, 1                                    ; 03D70  0xD1, 0xE3
  mov dx, [cs:bx + 0x2fff]                     ; 03D72  0x2E, 0x8B, 0x97, 0xFF, 0x2F
  call sub_03F2B                               ; 03D77  0xE8, 0xB1, 0x01
  mov al, [es:6]                               ; 03D7A  0x26, 0xA0, 0x06, 0x00
  mov ch, 0x30                                 ; 03D7E  0xB5, 0x30
  mov bx, 0xa1e                                ; 03D80  0xBB, 0x1E, 0x0A
  cmp al, 0x64                                 ; 03D83  0x3C, 0x64
  jb loc_03D8D                                 ; 03D85  0x72, 0x06
  mov byte [bx], 0x31                          ; 03D87  0xC6, 0x07, 0x31
  inc bx                                       ; 03D8A  0x43
  sub al, 0x64                                 ; 03D8B  0x2C, 0x64

loc_03D8D:                                     ; 03D8D
  sub al, 0xa                                  ; 03D8D  0x2C, 0x0A
  jb loc_03D95                                 ; 03D8F  0x72, 0x04
  inc ch                                       ; 03D91  0xFE, 0xC5
  jmp short loc_03D8D                          ; 03D93  0xEB, 0xF8

loc_03D95:                                     ; 03D95
  mov [bx], ch                                 ; 03D95  0x88, 0x2F
  inc bx                                       ; 03D97  0x43
  add al, 0x3a                                 ; 03D98  0x04, 0x3A
  mov [bx], al                                 ; 03D9A  0x88, 0x07
  inc bx                                       ; 03D9C  0x43
  mov byte [bx], 0x20                          ; 03D9D  0xC6, 0x07, 0x20
  mov bx, 0xa21                                ; 03DA0  0xBB, 0x21, 0x0A
  mov byte [bx], 0                             ; 03DA3  0xC6, 0x07, 0x00
  pop si                                       ; 03DA6  0x5E
  pop dx                                       ; 03DA7  0x5A
  inc si                                       ; 03DA8  0x46
  je loc_03DCB                                 ; 03DA9  0x74, 0x20
  mov byte [bx], 0x20                          ; 03DAB  0xC6, 0x07, 0x20
  mov di, 0xa29                                ; 03DAE  0xBF, 0x29, 0x0A
  mov ax, ds                                   ; 03DB1  0x8C, 0xD8
  mov bx, es                                   ; 03DB3  0x8C, 0xC3
  mov es, ax                                   ; 03DB5  0x8E, 0xC0
  mov ds, dx                                   ; 03DB7  0x8E, 0xDA
  mov cx, 4                                    ; 03DB9  0xB9, 0x04, 0x00
  rep movsw                                    ; 03DBC  0xF3, 0xA5
  mov byte [es:di], 0x2e                       ; 03DBE  0x26, 0xC6, 0x05, 0x2E
  inc di                                       ; 03DC2  0x47
  mov cl, 3                                    ; 03DC3  0xB1, 0x03
  rep movsb                                    ; 03DC5  0xF3, 0xA4
  mov ds, ax                                   ; 03DC7  0x8E, 0xD8
  mov es, bx                                   ; 03DC9  0x8E, 0xC3

loc_03DCB:                                     ; 03DCB
  mov dx, 0xa0c                                ; 03DCB  0xBA, 0x0C, 0x0A
  call sub_03F2B                               ; 03DCE  0xE8, 0x5A, 0x01
  jmp short loc_03DF5                          ; 03DD1  0xEB, 0x22

loc_03DD3:                                     ; 03DD3
  mov [0xa51], ah                              ; 03DD3  0x88, 0x26, 0x51, 0x0A
  pop si                                       ; 03DD7  0x5E
  mov al, [si + 0x20]                          ; 03DD8  0x8A, 0x44, 0x20
  add al, 0x30                                 ; 03DDB  0x04, 0x30
  mov [0xa5c], al                              ; 03DDD  0xA2, 0x5C, 0x0A
  add si, 8                                    ; 03DE0  0x83, 0xC6, 0x08
  mov di, 0xa66                                ; 03DE3  0xBF, 0x66, 0x0A
  push es                                      ; 03DE6  0x06
  push ds                                      ; 03DE7  0x1E
  pop es                                       ; 03DE8  0x07
  mov cx, 4                                    ; 03DE9  0xB9, 0x04, 0x00
  rep movsw                                    ; 03DEC  0xF3, 0xA5
  pop es                                       ; 03DEE  0x07
  mov dx, 0xa36                                ; 03DEF  0xBA, 0x36, 0x0A
  call sub_03F2B                               ; 03DF2  0xE8, 0x36, 0x01

loc_03DF5:                                     ; 03DF5
  mov dx, 0xa09                                ; 03DF5  0xBA, 0x09, 0x0A
  call sub_03F2B                               ; 03DF8  0xE8, 0x30, 0x01
  mov bx, 0xb64                                ; 03DFB  0xBB, 0x64, 0x0B
  mov cx, 0x216                                ; 03DFE  0xB9, 0x16, 0x02
  call sub_03F3A                               ; 03E01  0xE8, 0x36, 0x01

loc_03E04:                                     ; 03E04
  pop bx                                       ; 03E04  0x5B

loc_03E05:                                     ; 03E05
  mov si, [0x68]                               ; 03E05  0x8B, 0x36, 0x68, 0x00
  pop ax                                       ; 03E09  0x58
  or ax, 0xfdff                                ; 03E0A  0x0D, 0xFF, 0xFD
  and [si + 6], ax                             ; 03E0D  0x21, 0x44, 0x06
  test word [si + 6], 0x80                     ; 03E10  0xF7, 0x44, 0x06, 0x80, 0x00
  je loc_03E21                                 ; 03E15  0x74, 0x0A
  mov cx, 0x8f                                 ; 03E17  0xB9, 0x8F, 0x00
  xor_dx_dx                                    ; 03E1A  xor dx, dx
  push bx                                      ; 03E1C  0x53
  call sub_03F3A                               ; 03E1D  0xE8, 0x1A, 0x01
  pop bx                                       ; 03E20  0x5B

loc_03E21:                                     ; 03E21
  ret                                          ; 03E21  0xC3

sub_03E22:                                     ; 03E22
  mov [0xafa], sp                              ; 03E22  0x89, 0x26, 0xFA, 0x0A
  test byte [cs:si + 2], 0x10                  ; 03E26  0x2E, 0xF6, 0x44, 0x02, 0x10
  je loc_03E32                                 ; 03E2B  0x74, 0x05
  push si                                      ; 03E2D  0x56
  call sub_05561                               ; 03E2E  0xE8, 0x30, 0x17
  pop si                                       ; 03E31  0x5E

loc_03E32:                                     ; 03E32
  call word [cs:si]                            ; 03E32  0x2E, 0xFF, 0x14

loc_03E35:                                     ; 03E35
  cmp byte [0x80f], 0                          ; 03E35  0x80, 0x3E, 0x0F, 0x08, 0x00
  je loc_03E6A                                 ; 03E3A  0x74, 0x2E
  cmp byte [0x811], 0xff                       ; 03E3C  0x80, 0x3E, 0x11, 0x08, 0xFF
  jne loc_03E46                                ; 03E41  0x75, 0x03
  call sub_04215                               ; 03E43  0xE8, 0xCF, 0x03

loc_03E46:                                     ; 03E46
  mov al, [0x880]                              ; 03E46  0xA0, 0x80, 0x08
  mov bx, 0xb00                                ; 03E49  0xBB, 0x00, 0x0B
  or [bx + 7], al                              ; 03E4C  0x08, 0x47, 0x07
  mov al, [0x87f]                              ; 03E4F  0xA0, 0x7F, 0x08
  cmp al, 0x60                                 ; 03E52  0x3C, 0x60
  jne loc_03E5C                                ; 03E54  0x75, 0x06
  or byte [bx + 8], 0x80                       ; 03E56  0x80, 0x4F, 0x08, 0x80
  jmp short loc_03E5F                          ; 03E5A  0xEB, 0x03

loc_03E5C:                                     ; 03E5C
  or [bx + 0xc], al                            ; 03E5C  0x08, 0x47, 0x0C

loc_03E5F:                                     ; 03E5F
  mov al, [0x8c8]                              ; 03E5F  0xA0, 0xC8, 0x08
  or [bx + 0xf], al                            ; 03E62  0x08, 0x47, 0x0F
  mov al, [0x80b]                              ; 03E65  0xA0, 0x0B, 0x08
  mov [bx], al                                 ; 03E68  0x88, 0x07

loc_03E6A:                                     ; 03E6A
  ret                                          ; 03E6A  0xC3

sub_03E6B:                                     ; 03E6B
  mov [0x902], si                              ; 03E6B  0x89, 0x36, 0x02, 0x09
  mov ah, [cs:si + 2]                          ; 03E6F  0x2E, 0x8A, 0x64, 0x02
  mov al, [0x875]                              ; 03E73  0xA0, 0x75, 0x08

loc_03E76:                                     ; 03E76
  mov [0x818], al                              ; 03E76  0xA2, 0x18, 0x08
  push ax                                      ; 03E79  0x50
  mov si, [0x902]                              ; 03E7A  0x8B, 0x36, 0x02, 0x09
  mov dx, [0x862]                              ; 03E7E  0x8B, 0x16, 0x62, 0x08
  call sub_03E22                               ; 03E82  0xE8, 0x9D, 0xFF
  mov bl, [0x80d]                              ; 03E85  0x8A, 0x1E, 0x0D, 0x08
  or_bl_bl                                     ; 03E89  or bl, bl
  pop ax                                       ; 03E8B  0x58
  je loc_03E9B                                 ; 03E8C  0x74, 0x0D
  cmp bl, 0xff                                 ; 03E8E  0x80, 0xFB, 0xFF
  je loc_03EE9                                 ; 03E91  0x74, 0x56
  mov bh, [0x875]                              ; 03E93  0x8A, 0x3E, 0x75, 0x08
  sub_bh_al                                    ; 03E97  sub bh, al
  jmp short loc_03EAF                          ; 03E99  0xEB, 0x14

loc_03E9B:                                     ; 03E9B
  test ah, 8                                   ; 03E9B  0xF6, 0xC4, 0x08
  je loc_03EA3                                 ; 03E9E  0x74, 0x03
  call sub_03F20                               ; 03EA0  0xE8, 0x7D, 0x00

loc_03EA3:                                     ; 03EA3
  add word [0x866], 0x80                       ; 03EA3  0x81, 0x06, 0x66, 0x08, 0x80, 0x00
  dec al                                       ; 03EA9  0xFE, 0xC8
  jne loc_03E76                                ; 03EAB  0x75, 0xC9
  xor_bx_bx                                    ; 03EAD  xor bx, bx

loc_03EAF:                                     ; 03EAF
  mov [0x80d], bx                              ; 03EAF  0x89, 0x1E, 0x0D, 0x08
  test byte [0xb0e], 0x80                      ; 03EB3  0xF6, 0x06, 0x0E, 0x0B, 0x80
  jne loc_03EE9                                ; 03EB8  0x75, 0x2F
  test byte [0x87f], 0x80                      ; 03EBA  0xF6, 0x06, 0x7F, 0x08, 0x80
  je loc_03EE9                                 ; 03EBF  0x74, 0x28
  push ax                                      ; 03EC1  0x50
  push bx                                      ; 03EC2  0x53
  mov si, 0x56                                 ; 03EC3  0xBE, 0x56, 0x00
  or byte [0xb05], 0x80                        ; 03EC6  0x80, 0x0E, 0x05, 0x0B, 0x80
  mov word [0x80d], 0                          ; 03ECB  0xC7, 0x06, 0x0D, 0x08, 0x00, 0x00
  call sub_03E22                               ; 03ED1  0xE8, 0x4E, 0xFF
  pop ax                                       ; 03ED4  0x58
  cmp byte [0x80e], 0                          ; 03ED5  0x80, 0x3E, 0x0E, 0x08, 0x00
  jne loc_03EE8                                ; 03EDA  0x75, 0x0C
  cmp byte [0x80d], 0                          ; 03EDC  0x80, 0x3E, 0x0D, 0x08, 0x00
  je loc_03EE5                                 ; 03EE1  0x74, 0x02
  mov al, 0xb                                  ; 03EE3  0xB0, 0x0B

loc_03EE5:                                     ; 03EE5
  mov [0x80d], ax                              ; 03EE5  0xA3, 0x0D, 0x08

loc_03EE8:                                     ; 03EE8
  pop ax                                       ; 03EE8  0x58

loc_03EE9:                                     ; 03EE9
  test ah, 8                                   ; 03EE9  0xF6, 0xC4, 0x08
  je loc_03F1F                                 ; 03EEC  0x74, 0x31

sub_03EEE:                                     ; 03EEE
  call sub_03EFD                               ; 03EEE  0xE8, 0x0C, 0x00
  jmp short loc_03EF8                          ; 03EF1  0xEB, 0x05

sub_03EF3:                                     ; 03EF3
  call sub_03EFD                               ; 03EF3  0xE8, 0x07, 0x00
  xchg bx, dx                                  ; 03EF6  87 DA

loc_03EF8:                                     ; 03EF8
  mov cl, 3                                    ; 03EF8  0xB1, 0x03
  jmp near sub_04003                           ; 03EFA  0xE9, 0x06, 0x01

sub_03EFD:                                     ; 03EFD
  mov bx, 0xb21                                ; 03EFD  0xBB, 0x21, 0x0B
  mov dx, 0x904                                ; 03F00  0xBA, 0x04, 0x09
  ret                                          ; 03F03  0xC3

sub_03F04:                                     ; 03F04
  mov cl, 0x21                                 ; 03F04  0xB1, 0x21
  jmp short sub_03F0A                          ; 03F06  0xEB, 0x02

sub_03F08:                                     ; 03F08
  mov cl, 0x24                                 ; 03F08  0xB1, 0x24

sub_03F0A:                                     ; 03F0A
  mov [0x80c], cl                              ; 03F0A  0x88, 0x0E, 0x0C, 0x08
  xor_ch_ch                                    ; 03F0E  xor ch, ch
  mov si, [0x862]                              ; 03F10  0x8B, 0x36, 0x62, 0x08
  mov di, 0xb00                                ; 03F14  0xBF, 0x00, 0x0B
  push ds                                      ; 03F17  0x1E
  mov ds, [0x909]                              ; 03F18  0x8E, 0x1E, 0x09, 0x09
  rep movsb                                    ; 03F1C  0xF3, 0xA4
  pop ds                                       ; 03F1E  0x1F

loc_03F1F:                                     ; 03F1F
  ret                                          ; 03F1F  0xC3

sub_03F20:                                     ; 03F20
  mov bx, 0xb21                                ; 03F20  0xBB, 0x21, 0x0B
  inc word [bx]                                ; 03F23  0xFF, 0x07
  jne loc_03F2A                                ; 03F25  0x75, 0x03
  inc byte [bx + 2]                            ; 03F27  0xFE, 0x47, 0x02

loc_03F2A:                                     ; 03F2A
  ret                                          ; 03F2A  0xC3

sub_03F2B:                                     ; 03F2B
  push dx                                      ; 03F2B  0x52
  mov cx, 0xa2                                 ; 03F2C  0xB9, 0xA2, 0x00
  call sub_03F3A                               ; 03F2F  0xE8, 0x08, 0x00
  pop dx                                       ; 03F32  0x5A
  or_al_al                                     ; 03F33  or al, al
  jne loc_03F1F                                ; 03F35  0x75, 0xE8
  mov cx, 0x40e                                ; 03F37  0xB9, 0x0E, 0x04

sub_03F3A:                                     ; 03F3A
  mov si, [0x68]                               ; 03F3A  0x8B, 0x36, 0x68, 0x00
  push es                                      ; 03F3E  0x06
  mov es, [si + 0x10]                          ; 03F3F  0x8E, 0x44, 0x10
  call far [cs:8]                              ; 03F42  0x2E, 0xFF, 0x1E, 0x08, 0x00
  pop es                                       ; 03F47  0x07
  ret                                          ; 03F48  0xC3

sub_03F49:                                     ; 03F49
  push es                                      ; 03F49  0x06
  mov es, [0x907]                              ; 03F4A  0x8E, 0x06, 0x07, 0x09
  call far [0x28]                              ; 03F4E  0xFF, 0x1E, 0x28, 0x00
  cld                                          ; 03F52  0xFC
  pop es                                       ; 03F53  0x07
  ret                                          ; 03F54  0xC3

sub_03F55:                                     ; 03F55
  mov dx, [0x8f5]                              ; 03F55  0x8B, 0x16, 0xF5, 0x08
  mov ch, [0x8f7]                              ; 03F59  0x8A, 0x2E, 0xF7, 0x08
  mov bl, [0x881]                              ; 03F5D  0x8A, 0x1E, 0x81, 0x08
  mov bh, 1                                    ; 03F61  0xB7, 0x01
  xchg [0x820], bh                             ; 03F63  0x86, 0x3E, 0x20, 0x08
  push bx                                      ; 03F67  0x53
  push word [0x85c]                            ; 03F68  0xFF, 0x36, 0x5C, 0x08
  push word [0x85e]                            ; 03F6C  0xFF, 0x36, 0x5E, 0x08
  push word [0x8fc]                            ; 03F70  0xFF, 0x36, 0xFC, 0x08
  push word [0x8fe]                            ; 03F74  0xFF, 0x36, 0xFE, 0x08
  mov es, [0x907]                              ; 03F78  0x8E, 0x06, 0x07, 0x09
  call far [0x28]                              ; 03F7C  0xFF, 0x1E, 0x28, 0x00
  add sp, 0xa                                  ; 03F80  0x83, 0xC4, 0x0A
  cld                                          ; 03F83  0xFC
  push ds                                      ; 03F84  0x1E
  pop es                                       ; 03F85  0x07
  ret                                          ; 03F86  0xC3

loc_03F87:                                     ; 03F87
  mov ah, 1                                    ; 03F87  0xB4, 0x01
  jmp short loc_03F9D                          ; 03F89  0xEB, 0x12

loc_03F8B:                                     ; 03F8B
  call sub_0439C                               ; 03F8B  0xE8, 0x0E, 0x04
  mov ah, 2                                    ; 03F8E  0xB4, 0x02
  jmp short loc_03F9D                          ; 03F90  0xEB, 0x0B

loc_03F92:                                     ; 03F92
  mov ah, 3                                    ; 03F92  0xB4, 0x03
  jmp short loc_03F9D                          ; 03F94  0xEB, 0x07

loc_03F96:                                     ; 03F96
  mov byte [0x881], 0xff                       ; 03F96  0xC6, 0x06, 0x81, 0x08, 0xFF
  mov ah, 4                                    ; 03F9B  0xB4, 0x04

loc_03F9D:                                     ; 03F9D
  mov al, 0xff                                 ; 03F9D  0xB0, 0xFF
  mov [0x80d], ax                              ; 03F9F  0xA3, 0x0D, 0x08
  cmp [0x874], al                              ; 03FA2  0x38, 0x06, 0x74, 0x08
  jne loc_03FE7                                ; 03FA6  0x75, 0x3F

loc_03FA8:                                     ; 03FA8
  xor_al_al                                    ; 03FA8  xor al, al
  xchg [0x8d0], al                             ; 03FAA  0x86, 0x06, 0xD0, 0x08
  test al, al                                  ; 03FAE  0x84, 0xC0
  je loc_03FB7                                 ; 03FB0  0x74, 0x05
  mov sp, [0x8ce]                              ; 03FB2  0x8B, 0x26, 0xCE, 0x08
  ret                                          ; 03FB6  0xC3

loc_03FB7:                                     ; 03FB7
  mov al, [0x85b]                              ; 03FB7  0xA0, 0x5B, 0x08
  cmp al, 0xe                                  ; 03FBA  0x3C, 0x0E
  je loc_03FC2                                 ; 03FBC  0x74, 0x04
  cmp al, 0x12                                 ; 03FBE  0x3C, 0x12
  jne loc_03FC8                                ; 03FC0  0x75, 0x06

loc_03FC2:                                     ; 03FC2
  mov word [0x80d], 0xffff                     ; 03FC2  0xC7, 0x06, 0x0D, 0x08, 0xFF, 0xFF

loc_03FC8:                                     ; 03FC8
  mov sp, [0xafa]                              ; 03FC8  0x8B, 0x26, 0xFA, 0x0A
  jmp near loc_03E35                           ; 03FCC  0xE9, 0x66, 0xFE

loc_03FCF:                                     ; 03FCF
  mov al, 1                                    ; 03FCF  0xB0, 0x01

loc_03FD1:                                     ; 03FD1
  mov [0x80d], al                              ; 03FD1  0xA2, 0x0D, 0x08
  ret                                          ; 03FD4  0xC3

loc_03FD5:                                     ; 03FD5
  mov al, 0xff                                 ; 03FD5  0xB0, 0xFF
  mov [0x80d], ax                              ; 03FD7  0xA3, 0x0D, 0x08
  cmp ah, 3                                    ; 03FDA  0x80, 0xFC, 0x03
  jne loc_03FE1                                ; 03FDD  0x75, 0x02
  mov ah, 0xc                                  ; 03FDF  0xB4, 0x0C

loc_03FE1:                                     ; 03FE1
  cmp [0x874], al                              ; 03FE1  0x38, 0x06, 0x74, 0x08
  je loc_03FC8                                 ; 03FE5  0x74, 0xE1

loc_03FE7:                                     ; 03FE7
  mov [0x81b], ah                              ; 03FE7  0x88, 0x26, 0x1B, 0x08
  mov al, [0x860]                              ; 03FEB  0xA0, 0x60, 0x08
  mov [0x90d], al                              ; 03FEE  0xA2, 0x0D, 0x09
  cmp byte [0x874], 0xfe                       ; 03FF1  0x80, 0x3E, 0x74, 0x08, 0xFE
  je loc_03FA8                                 ; 03FF6  0x74, 0xB0
  mov si, [0x68]                               ; 03FF8  0x8B, 0x36, 0x68, 0x00
  or word [si + 6], 0x80                       ; 03FFC  0x81, 0x4C, 0x06, 0x80, 0x00
  jmp short loc_03FA8                          ; 04001  0xEB, 0xA5

sub_04003:                                     ; 04003
  xor_ch_ch                                    ; 04003  xor ch, ch
  mov_si_dx                                    ; 04005  mov si, dx
  mov_di_bx                                    ; 04007  mov di, bx
  rep movsb                                    ; 04009  0xF3, 0xA4
  ret                                          ; 0400B  0xC3

sub_0400C:                                     ; 0400C
  xor_ch_ch                                    ; 0400C  xor ch, ch
  mov_si_bx                                    ; 0400E  mov si, bx
  mov_di_dx                                    ; 04010  mov di, dx
  repe cmpsb                                   ; 04012  0xF3, 0xA6
  ret                                          ; 04014  0xC3

sub_04015:                                     ; 04015
  mov ax, [0x8f5]                              ; 04015  0xA1, 0xF5, 0x08
  xor_dx_dx                                    ; 04018  xor dx, dx
  mov dl, [0x8f7]                              ; 0401A  0x8A, 0x16, 0xF7, 0x08
  mov cl, [0x8b2]                              ; 0401E  0x8A, 0x0E, 0xB2, 0x08
  xor_ch_ch                                    ; 04022  xor ch, ch
  jcxz loc_0402C                               ; 04024  0xE3, 0x06

loc_04026:                                     ; 04026
  shr dx, 1                                    ; 04026  0xD1, 0xEA
  rcr ax, 1                                    ; 04028  0xD1, 0xD8
  loop loc_04026                               ; 0402A  0xE2, 0xFA

loc_0402C:                                     ; 0402C
  div word [0x8a3]                            ; 0402C
  add ax, [0x8b0]                              ; 04030  0x03, 0x06, 0xB0, 0x08
  mov [0x85c], ax                              ; 04034  0xA3, 0x5C, 0x08
  mov [0x85e], dx                              ; 04037  0x89, 0x16, 0x5E, 0x08
  ret                                          ; 0403B  0xC3

sub_0403C:                                     ; 0403C
  mov cl, [0x8a5]                              ; 0403C  0x8A, 0x0E, 0xA5, 0x08
  mov ax, [0x8f5]                              ; 04040  0xA1, 0xF5, 0x08
  mov [0x823], ax                              ; 04043  0xA3, 0x23, 0x08
  xor_bh_bh                                    ; 04046  xor bh, bh
  mov_bl_ah                                    ; 04048  mov bl, ah
  shl ax, cl                                   ; 0404A  0xD3, 0xE0
  shl bx, cl                                   ; 0404C  0xD3, 0xE3
  mov [0x8f8], ax                              ; 0404E  0xA3, 0xF8, 0x08
  xchg bx, ax                                  ; 04051  0x93
  mov al, [0x8f3]                              ; 04052  0xA0, 0xF3, 0x08
  and al, [0x8a6]                              ; 04055  0x22, 0x06, 0xA6, 0x08
  mov [0x822], al                              ; 04059  0xA2, 0x22, 0x08
  or_bl_al                                     ; 0405C  or bl, al
  mov [0x8f5], bx                              ; 0405E  0x89, 0x1E, 0xF5, 0x08
  mov [0x8f7], ah                              ; 04062  0x88, 0x26, 0xF7, 0x08
  ret                                          ; 04066  0xC3

sub_04067:                                     ; 04067
  mov cl, [0x8a5]                              ; 04067  0x8A, 0x0E, 0xA5, 0x08
  mov ch, [0x8f3]                              ; 0406B  0x8A, 0x2E, 0xF3, 0x08
  shr ch, cl                                   ; 0406F  0xD2, 0xED
  neg cl                                       ; 04071  0xF6, 0xD9
  add cl, 7                                    ; 04073  0x80, 0xC1, 0x07
  mov al, [0x8f2]                              ; 04076  0xA0, 0xF2, 0x08
  shl al, cl                                   ; 04079  0xD2, 0xE0
  add_al_ch                                    ; 0407B  add al, ch
  ret                                          ; 0407D  0xC3

sub_0407E:                                     ; 0407E
  mov bx, 0xb10                                ; 0407E  0xBB, 0x10, 0x0B
  add_bx_cx                                    ; 04081  add bx, cx
  cmp byte [0x8f0], 0                          ; 04083  0x80, 0x3E, 0xF0, 0x08, 0x00
  je loc_0408F                                 ; 04088  0x74, 0x05
  mov bl, [bx]                                 ; 0408A  0x8A, 0x1F
  xor_bh_bh                                    ; 0408C  xor bh, bh
  ret                                          ; 0408E  0xC3

loc_0408F:                                     ; 0408F
  add_bx_cx                                    ; 0408F  add bx, cx
  mov bx, [bx]                                 ; 04091  0x8B, 0x1F
  ret                                          ; 04093  0xC3

sub_04094:                                     ; 04094
  call sub_04067                               ; 04094  0xE8, 0xD0, 0xFF
  mov [0x8ef], al                              ; 04097  0xA2, 0xEF, 0x08
  mov_cl_al                                    ; 0409A  mov cl, al
  xor_ch_ch                                    ; 0409C  xor ch, ch
  call sub_0407E                               ; 0409E  0xE8, 0xDD, 0xFF
  mov [0x8f5], bx                              ; 040A1  0x89, 0x1E, 0xF5, 0x08
  or_bx_bx                                     ; 040A5  or bx, bx
  ret                                          ; 040A7  0xC3

sub_040A8:                                     ; 040A8
  mov di, 0xb08                                ; 040A8  0xBF, 0x08, 0x0B
  mov cx, 4                                    ; 040AB  0xB9, 0x04, 0x00
  xor_dl_dl                                    ; 040AE  xor dl, dl
  std                                          ; 040B0  0xFD

loc_040B1:                                     ; 040B1
  mov al, [di]                                 ; 040B1  0x8A, 0x05
  shl al, 1                                    ; 040B3  0xD0, 0xE0
  rcr dl, 1                                    ; 040B5  0xD0, 0xDA
  shr al, 1                                    ; 040B7  0xD0, 0xE8
  stosb                                        ; 040B9  0xAA
  loop loc_040B1                               ; 040BA  0xE2, 0xF5
  cld                                          ; 040BC  0xFC
  mov_al_dl                                    ; 040BD  mov al, dl
  mov [0x8cc], al                              ; 040BF  0xA2, 0xCC, 0x08
  ret                                          ; 040C2  0xC3

sub_040C3:                                     ; 040C3
  mov bx, 0xb20                                ; 040C3  0xBB, 0x20, 0x0B
  mov dx, 0x1001                               ; 040C6  0xBA, 0x01, 0x10

loc_040C9:                                     ; 040C9
  dec dh                                       ; 040C9  0xFE, 0xCE
  dec bx                                       ; 040CB  0x4B
  cmp byte [bx], 0                             ; 040CC  0x80, 0x3F, 0x00
  jne loc_040D7                                ; 040CF  0x75, 0x06
  or_dh_dh                                     ; 040D1  or dh, dh
  jne loc_040C9                                ; 040D3  0x75, 0xF4
  dec dl                                       ; 040D5  0xFE, 0xCA

loc_040D7:                                     ; 040D7
  mov [0x8ef], dl                              ; 040D7  0x88, 0x16, 0xEF, 0x08
  cmp byte [0x8f0], 0xff                       ; 040DB  0x80, 0x3E, 0xF0, 0x08, 0xFF
  mov_al_dh                                    ; 040E0  mov al, dh
  je loc_040E6                                 ; 040E2  0x74, 0x02
  shr al, 1                                    ; 040E4  0xD0, 0xE8

loc_040E6:                                     ; 040E6
  mov cl, 7                                    ; 040E6  0xB1, 0x07
  sub cl, [0x8a5]                              ; 040E8  0x2A, 0x0E, 0xA5, 0x08
  shr al, cl                                   ; 040EC  0xD2, 0xE8
  mov ah, [0x8a7]                              ; 040EE  0x8A, 0x26, 0xA7, 0x08
  cmp_ah_al                                    ; 040F2  cmp ah, al
  jb loc_040C9                                 ; 040F4  0x72, 0xD3
  mov bx, 0xb0c                                ; 040F6  0xBB, 0x0C, 0x0B
  mov cl, [bx]                                 ; 040F9  0x8A, 0x0F
  not ah                                       ; 040FB  0xF6, 0xD4
  and ah, 0x1f                                 ; 040FD  0x80, 0xE4, 0x1F
  and_ah_cl                                    ; 04100  and ah, cl
  or_al_ah                                     ; 04102  or al, ah
  ret                                          ; 04104  0xC3

sub_04105:                                     ; 04105
  push cx                                      ; 04105  0x51
  mov ch, [0x8a7]                              ; 04106  0x8A, 0x2E, 0xA7, 0x08
  not ch                                       ; 0410A  0xF6, 0xD5
  and_cl_ch                                    ; 0410C  and cl, ch
  and_al_ch                                    ; 0410E  and al, ch
  sub_al_cl                                    ; 04110  sub al, cl
  and al, 0x1f                                 ; 04112  0x24, 0x1F
  pop cx                                       ; 04114  0x59
  ret                                          ; 04115  0xC3

sub_04116:                                     ; 04116
  mov al, [0xb20]                              ; 04116  0xA0, 0x20, 0x0B
  mov [0x8f3], al                              ; 04119  0xA2, 0xF3, 0x08
  cmp byte [0xb0f], 0                          ; 0411C  0x80, 0x3E, 0x0F, 0x0B, 0x00
  jne loc_0412B                                ; 04121  0x75, 0x08
  call sub_040C3                               ; 04123  0xE8, 0x9D, 0xFF
  mov_cl_al                                    ; 04126  mov cl, al
  call sub_04DFD                               ; 04128  0xE8, 0xD2, 0x0C

loc_0412B:                                     ; 0412B
  mov al, [0xb0f]                              ; 0412B  0xA0, 0x0F, 0x0B
  cmp al, 0x81                                 ; 0412E  0x3C, 0x81
  jb loc_04134                                 ; 04130  0x72, 0x02
  mov al, 0x80                                 ; 04132  0xB0, 0x80

loc_04134:                                     ; 04134
  mov [0x8f1], al                              ; 04134  0xA2, 0xF1, 0x08
  mov al, [0x8a7]                              ; 04137  0xA0, 0xA7, 0x08
  and al, [0xb0c]                              ; 0413A  0x22, 0x06, 0x0C, 0x0B
  mov [0x8f2], al                              ; 0413E  0xA2, 0xF2, 0x08
  ret                                          ; 04141  0xC3

loc_04142:                                     ; 04142
  xor_al_al                                    ; 04142  xor al, al
  cmp byte [0x85b], 9                          ; 04144  0x80, 0x3E, 0x5B, 0x08, 0x09
  jae loc_0414D                                ; 04149  0x73, 0x02
  inc al                                       ; 0414B  0xFE, 0xC0

loc_0414D:                                     ; 0414D
  add al, [0x8f3]                              ; 0414D  0x02, 0x06, 0xF3, 0x08
  mov [0xb20], al                              ; 04151  0xA2, 0x20, 0x0B
  cmp byte [0xb0f], 0x80                       ; 04154  0x80, 0x3E, 0x0F, 0x0B, 0x80
  jae loc_04161                                ; 04159  0x73, 0x06
  mov al, [0x8f1]                              ; 0415B  0xA0, 0xF1, 0x08
  mov [0xb0f], al                              ; 0415E  0xA2, 0x0F, 0x0B

loc_04161:                                     ; 04161
  ret                                          ; 04161  0xC3

sub_04162:                                     ; 04162
  xor_ch_ch                                    ; 04162  xor ch, ch

loc_04164:                                     ; 04164
  add al, [bx]                                 ; 04164  0x02, 0x07
  inc bx                                       ; 04166  0x43
  loop loc_04164                               ; 04167  0xE2, 0xFB
  ret                                          ; 04169  0xC3

sub_0416A:                                     ; 0416A
  mov bx, [0x88b]                              ; 0416A  0x8B, 0x1E, 0x8B, 0x08
  mov cx, 4                                    ; 0416E  0xB9, 0x04, 0x00
  xor_ah_ah                                    ; 04171  xor ah, ah

loc_04173:                                     ; 04173
  push cx                                      ; 04173  0x51
  xor_al_al                                    ; 04174  xor al, al
  mov cl, 0x20                                 ; 04176  0xB1, 0x20
  call sub_04162                               ; 04178  0xE8, 0xE7, 0xFF
  xor_ah_al                                    ; 0417B  xor ah, al
  pop cx                                       ; 0417D  0x59
  loop loc_04173                               ; 0417E  0xE2, 0xF3
  xchg al, ah                                  ; 04180  86 C4
  ret                                          ; 04182  0xC3

sub_04183:                                     ; 04183
  cmp byte [0x87f], 0x60                       ; 04183  0x80, 0x3E, 0x7F, 0x08, 0x60
  jne sub_0418F                                ; 04188  0x75, 0x05
  xor_al_al                                    ; 0418A  xor al, al
  mov [0xb00], al                              ; 0418C  0xA2, 0x00, 0x0B

sub_0418F:                                     ; 0418F
  sub_al_al                                    ; 0418F  sub al, al
  mov bx, 0x87e                                ; 04191  0xBB, 0x7E, 0x08
  mov cl, 4                                    ; 04194  0xB1, 0x04
  call sub_04162                               ; 04196  0xE8, 0xC9, 0xFF
  add al, 0xbb                                 ; 04199  0x04, 0xBB
  mov bx, 0xb00                                ; 0419B  0xBB, 0x00, 0x0B
  mov cl, 0xc                                  ; 0419E  0xB1, 0x0C
  call sub_04162                               ; 041A0  0xE8, 0xBF, 0xFF
  inc bx                                       ; 041A3  0x43
  add al, [bx]                                 ; 041A4  0x02, 0x07
  add bx, 3                                    ; 041A6  0x83, 0xC3, 0x03
  mov cl, 0x10                                 ; 041A9  0xB1, 0x10
  call sub_04162                               ; 041AB  0xE8, 0xB4, 0xFF
  mov bx, [0x889]                              ; 041AE  0x8B, 0x1E, 0x89, 0x08
  add al, [bx + 2]                             ; 041B2  0x02, 0x47, 0x02
  or_al_al                                     ; 041B5  or al, al

loc_041B7:                                     ; 041B7
  ret                                          ; 041B7  0xC3

sub_041B8:                                     ; 041B8
  mov si, [0x885]                              ; 041B8  0x8B, 0x36, 0x85, 0x08
  mov al, [si + 0x18]                          ; 041BC  0x8A, 0x44, 0x18
  ret                                          ; 041BF  0xC3

sub_041C0:                                     ; 041C0
  call sub_041B8                               ; 041C0  0xE8, 0xF5, 0xFF
  and al, 0x10                                 ; 041C3  0x24, 0x10
  jne sub_04183                                ; 041C5  0x75, 0xBC

sub_041C7:                                     ; 041C7
  mov byte [0x8d1], 0                          ; 041C7  0xC6, 0x06, 0xD1, 0x08, 0x00

sub_041CC:                                     ; 041CC
  call sub_04183                               ; 041CC  0xE8, 0xB4, 0xFF
  je loc_041B7                                 ; 041CF  0x74, 0xE6
  and al, 0xf                                  ; 041D1  0x24, 0x0F
  jne loc_04208                                ; 041D3  0x75, 0x33
  cmp byte [0x87e], 0                          ; 041D5  0x80, 0x3E, 0x7E, 0x08, 0x00
  je loc_04208                                 ; 041DA  0x74, 0x2C
  mov byte [0x8e8], 0xff                       ; 041DC  0xC6, 0x06, 0xE8, 0x08, 0xFF
  call sub_0428E                               ; 041E1  0xE8, 0xAA, 0x00
  jne loc_041EB                                ; 041E4  0x75, 0x05
  call sub_04B95                               ; 041E6  0xE8, 0xAC, 0x09
  jmp short loc_041F3                          ; 041E9  0xEB, 0x08

loc_041EB:                                     ; 041EB
  mov byte [0x8d9], 0xff                       ; 041EB  0xC6, 0x06, 0xD9, 0x08, 0xFF
  call sub_04F0A                               ; 041F0  0xE8, 0x17, 0x0D

loc_041F3:                                     ; 041F3
  mov bx, 0x80d                                ; 041F3  0xBB, 0x0D, 0x08
  inc byte [bx]                                ; 041F6  0xFE, 0x07
  je loc_04208                                 ; 041F8  0x74, 0x0E
  mov byte [bx], 0                             ; 041FA  0xC6, 0x07, 0x00
  call sub_05860                               ; 041FD  0xE8, 0x60, 0x16
  mov ch, 5                                    ; 04200  0xB5, 0x05
  call sub_0586C                               ; 04202  0xE8, 0x67, 0x16
  jne loc_04208                                ; 04205  0x75, 0x01
  ret                                          ; 04207  0xC3

loc_04208:                                     ; 04208
  pop bx                                       ; 04208  0x5B
  test byte [0x8d1], 0xff                      ; 04209  0xF6, 0x06, 0xD1, 0x08, 0xFF
  jne loc_04223                                ; 0420E  0x75, 0x13

loc_04210:                                     ; 04210
  mov al, 0xa                                  ; 04210  0xB0, 0x0A
  jmp near loc_03FD1                           ; 04212  0xE9, 0xBC, 0xFD

sub_04215:                                     ; 04215
  call sub_0418F                               ; 04215  0xE8, 0x77, 0xFF
  je loc_04223                                 ; 04218  0x74, 0x09
  sub al, [0xb0d]                              ; 0421A  0x2A, 0x06, 0x0D, 0x0B
  neg al                                       ; 0421E  0xF6, 0xD8
  mov [0xb0d], al                              ; 04220  0xA2, 0x0D, 0x0B

loc_04223:                                     ; 04223
  ret                                          ; 04223  0xC3

sub_04224:                                     ; 04224
  mov byte [0x811], 0                          ; 04224  0xC6, 0x06, 0x11, 0x08, 0x00
  call sub_0418F                               ; 04229  0xE8, 0x63, 0xFF
  jne loc_04223                                ; 0422C  0x75, 0xF5
  inc byte [0xb0d]                             ; 0422E  0xFE, 0x06, 0x0D, 0x0B
  ret                                          ; 04232  0xC3

sub_04233:                                     ; 04233
  mov cl, [0x881]                              ; 04233  0x8A, 0x0E, 0x81, 0x08

sub_04237:                                     ; 04237
  mov ax, 1                                    ; 04237  0xB8, 0x01, 0x00
  shl ax, cl                                   ; 0423A  0xD3, 0xE0
  or [bx], ax                                  ; 0423C  0x09, 0x07
  ret                                          ; 0423E  0xC3

sub_0423F:                                     ; 0423F
  mov dx, [0x806]                              ; 0423F  0x8B, 0x16, 0x06, 0x08

sub_04243:                                     ; 04243
  mov cl, [0x881]                              ; 04243  0x8A, 0x0E, 0x81, 0x08

sub_04247:                                     ; 04247
  shr dx, cl                                   ; 04247  0xD3, 0xEA
  and dx, strict word 1                        ; 04249  81 E2 01 00
  ret                                          ; 0424D  0xC3

sub_0424E:                                     ; 0424E
  mov bl, [0x900]                              ; 0424E  0x8A, 0x1E, 0x00, 0x09
  xor_bh_bh                                    ; 04252  xor bh, bh
  add bx, [0x88b]                              ; 04254  0x03, 0x1E, 0x8B, 0x08
  ret                                          ; 04258  0xC3

sub_04259:                                     ; 04259
  add bx, 9                                    ; 04259  0x83, 0xC3, 0x09
  mov al, [bx]                                 ; 0425C  0x8A, 0x07
  rcl al, 1                                    ; 0425E  0xD0, 0xD0

loc_04260:                                     ; 04260
  ret                                          ; 04260  0xC3

sub_04261:                                     ; 04261
  call sub_0424E                               ; 04261  0xE8, 0xEA, 0xFF

sub_04264:                                     ; 04264
  call sub_04259                               ; 04264  0xE8, 0xF2, 0xFF
  jae loc_04260                                ; 04267  0x73, 0xF7
  jmp near loc_03F92                           ; 04269  0xE9, 0x26, 0xFD

sub_0426C:                                     ; 0426C
  call sub_0423F                               ; 0426C  0xE8, 0xD0, 0xFF
  je loc_04260                                 ; 0426F  0x74, 0xEF
  jmp near loc_03F8B                           ; 04271  0xE9, 0x17, 0xFD

sub_04274:                                     ; 04274
  mov bx, 0xb0e                                ; 04274  0xBB, 0x0E, 0x0B
  mov al, [bx]                                 ; 04277  0x8A, 0x07
  ret                                          ; 04279  0xC3

sub_0427A:                                     ; 0427A
  mov byte [0xb0e], 0                          ; 0427A  0xC6, 0x06, 0x0E, 0x0B, 0x00
  ret                                          ; 0427F  0xC3

sub_04280:                                     ; 04280
  and byte [0xb0c], 0x1f                       ; 04280  0x80, 0x26, 0x0C, 0x0B, 0x1F
  ret                                          ; 04285  0xC3

sub_04286:                                     ; 04286
  call sub_04274                               ; 04286  0xE8, 0xEB, 0xFF
  or al, 0x80                                  ; 04289  0x0C, 0x80
  mov [bx], al                                 ; 0428B  0x88, 0x07
  ret                                          ; 0428D  0xC3

sub_0428E:                                     ; 0428E
  mov bx, 0xb10                                ; 0428E  0xBB, 0x10, 0x0B
  jmp short loc_042A1                          ; 04291  0xEB, 0x0E

sub_04293:                                     ; 04293
  call sub_0428E                               ; 04293  0xE8, 0xF8, 0xFF
  jne loc_042A4                                ; 04296  0x75, 0x0C
  pop bx                                       ; 04298  0x5B
  mov al, 9                                    ; 04299  0xB0, 0x09
  jmp near loc_03FD1                           ; 0429B  0xE9, 0x33, 0xFD

sub_0429E:                                     ; 0429E
  mov bx, 0x870                                ; 0429E  0xBB, 0x70, 0x08

loc_042A1:                                     ; 042A1
  cmp word [bx], -1                            ; 042A1  0x83, 0x3F, 0xFF

loc_042A4:                                     ; 042A4
  ret                                          ; 042A4  0xC3

sub_042A5:                                     ; 042A5
  mov word [0x870], 0xffff                     ; 042A5  0xC7, 0x06, 0x70, 0x08, 0xFF, 0xFF
  ret                                          ; 042AB  0xC3

sub_042AC:                                     ; 042AC
  mov ax, [0x815]                              ; 042AC  0xA1, 0x15, 0x08
  and al, 0xfc                                 ; 042AF  0x24, 0xFC
  dec ax                                       ; 042B1  0x48
  mov [0x870], ax                              ; 042B2  0xA3, 0x70, 0x08
  ret                                          ; 042B5  0xC3

sub_042B6:                                     ; 042B6
  mov dx, [0x870]                              ; 042B6  0x8B, 0x16, 0x70, 0x08
  mov bx, [0x887]                              ; 042BA  0x8B, 0x1E, 0x87, 0x08
  cmp dx, [bx]                                 ; 042BE  0x3B, 0x17

loc_042C0:                                     ; 042C0
  ret                                          ; 042C0  0xC3

sub_042C1:                                     ; 042C1
  call sub_042B6                               ; 042C1  0xE8, 0xF2, 0xFF
  jb loc_042C0                                 ; 042C4  0x72, 0xFA
  inc dx                                       ; 042C6  0x42
  mov [bx], dx                                 ; 042C7  0x89, 0x17
  ret                                          ; 042C9  0xC3

sub_042CA:                                     ; 042CA
  test byte [0x8af], 0x80                      ; 042CA  0xF6, 0x06, 0xAF, 0x08, 0x80
  jne loc_042C0                                ; 042CF  0x75, 0xEF
  mov di, 0x3019                               ; 042D1  0xBF, 0x19, 0x30

sub_042D4:                                     ; 042D4
  mov cl, [cs:di]                              ; 042D4  0x2E, 0x8A, 0x0D
  inc di                                       ; 042D7  0x47
  xor_ch_ch                                    ; 042D8  xor ch, ch
  mov al, [0x85b]                              ; 042DA  0xA0, 0x5B, 0x08
  push cs                                      ; 042DD  0x0E
  pop es                                       ; 042DE  0x07
  repne scasb                                  ; 042DF  0xF2, 0xAE
  push ds                                      ; 042E1  0x1E
  pop es                                       ; 042E2  0x07
  ret                                          ; 042E3  0xC3

sub_042E4:                                     ; 042E4
  mov bx, 0x4f8                                ; 042E4  0xBB, 0xF8, 0x04
  push bx                                      ; 042E7  0x53
  mov di, 0x3029                               ; 042E8  0xBF, 0x29, 0x30
  call sub_042D4                               ; 042EB  0xE8, 0xE6, 0xFF
  jne loc_042F3                                ; 042EE  0x75, 0x03
  jmp near loc_04210                           ; 042F0  0xE9, 0x1D, 0xFF

loc_042F3:                                     ; 042F3
  mov di, 0x3033                               ; 042F3  0xBF, 0x33, 0x30
  call sub_042D4                               ; 042F6  0xE8, 0xDB, 0xFF
  jne loc_042FE                                ; 042F9  0x75, 0x03
  jmp near sub_04C05                           ; 042FB  0xE9, 0x07, 0x09

loc_042FE:                                     ; 042FE
  pop bx                                       ; 042FE  0x5B
  ret                                          ; 042FF  0xC3

sub_04300:                                     ; 04300
  xor_al_al                                    ; 04300  xor al, al
  xchg [0x81c], al                             ; 04302  0x86, 0x06, 0x1C, 0x08
  test al, al                                  ; 04306  0x84, 0xC0
  je loc_042C0                                 ; 04308  0x74, 0xB6
  call sub_05525                               ; 0430A  0xE8, 0x18, 0x12
  jmp near loc_03BCD                           ; 0430D  0xE9, 0xBD, 0xF8

sub_04310:                                     ; 04310
  call sub_05525                               ; 04310  0xE8, 0x12, 0x12
  xor_ax_ax                                    ; 04313  xor ax, ax
  mov [0x870], ax                              ; 04315  0xA3, 0x70, 0x08
  mov [0x900], al                              ; 04318  0xA2, 0x00, 0x09
  ret                                          ; 0431B  0xC3

sub_0431C:                                     ; 0431C
  mov al, 0xb                                  ; 0431C  0xB0, 0x0B
  call sub_03F55                               ; 0431E  0xE8, 0x34, 0xFC
  mov ah, 0xff                                 ; 04321  0xB4, 0xFF
  jmp short loc_0432C                          ; 04323  0xEB, 0x07

sub_04325:                                     ; 04325
  mov al, 0xa                                  ; 04325  0xB0, 0x0A
  call sub_03F55                               ; 04327  0xE8, 0x2B, 0xFC

sub_0432A:                                     ; 0432A
  mov ah, 0                                    ; 0432A  0xB4, 0x00

loc_0432C:                                     ; 0432C
  or_al_al                                     ; 0432C  or al, al
  jne loc_04336                                ; 0432E  0x75, 0x06
  mov byte [0x81a], 0xff                       ; 04330  0xC6, 0x06, 0x1A, 0x08, 0xFF
  ret                                          ; 04335  0xC3

loc_04336:                                     ; 04336
  push ax                                      ; 04336  0x50
  push bx                                      ; 04337  0x53
  cmp al, 0xff                                 ; 04338  0x3C, 0xFF
  je loc_04345                                 ; 0433A  0x74, 0x09
  mov al, [0x8f4]                              ; 0433C  0xA0, 0xF4, 0x08
  cmp al, [0x860]                              ; 0433F  0x3A, 0x06, 0x60, 0x08
  je loc_04388                                 ; 04343  0x74, 0x43

loc_04345:                                     ; 04345
  cmp word [0x8ae], 0x8000                     ; 04345  0x81, 0x3E, 0xAE, 0x08, 0x00, 0x80
  je loc_04388                                 ; 0434B  0x74, 0x3B
  mov dx, [0x808]                              ; 0434D  0x8B, 0x16, 0x08, 0x08
  call sub_04243                               ; 04351  0xE8, 0xEF, 0xFE
  je loc_04388                                 ; 04354  0x74, 0x32
  call sub_047C9                               ; 04356  0xE8, 0x70, 0x04
  cmp byte [0x85b], 0x21                       ; 04359  0x80, 0x3E, 0x5B, 0x08, 0x21
  je loc_0436E                                 ; 0435E  0x74, 0x0E
  mov al, [0x8f4]                              ; 04360  0xA0, 0xF4, 0x08
  cmp al, [0x860]                              ; 04363  0x3A, 0x06, 0x60, 0x08
  je loc_04371                                 ; 04367  0x74, 0x08
  mov byte [0x81c], 0                          ; 04369  0xC6, 0x06, 0x1C, 0x08, 0x00

loc_0436E:                                     ; 0436E
  pop bx                                       ; 0436E  0x5B
  pop ax                                       ; 0436F  0x58
  ret                                          ; 04370  0xC3

loc_04371:                                     ; 04371
  call sub_042E4                               ; 04371  0xE8, 0x70, 0xFF
  test byte [0x81a], 0xff                      ; 04374  0xF6, 0x06, 0x1A, 0x08, 0xFF
  je loc_04381                                 ; 04379  0x74, 0x06
  call sub_04C05                               ; 0437B  0xE8, 0x87, 0x08
  jmp near loc_03FC8                           ; 0437E  0xE9, 0x47, 0xFC

loc_04381:                                     ; 04381
  pop bx                                       ; 04381  0x5B
  pop ax                                       ; 04382  0x58
  or_ah_ah                                     ; 04383  or ah, ah
  jne loc_04391                                ; 04385  0x75, 0x0A
  ret                                          ; 04387  0xC3

loc_04388:                                     ; 04388
  pop bx                                       ; 04388  0x5B
  pop ax                                       ; 04389  0x58
  cmp al, 2                                    ; 0438A  0x3C, 0x02
  je loc_04391                                 ; 0438C  0x74, 0x03
  jmp near loc_03F87                           ; 0438E  0xE9, 0xF6, 0xFB

loc_04391:                                     ; 04391
  jmp near loc_03F8B                           ; 04391  0xE9, 0xF7, 0xFB

sub_04394:                                     ; 04394
  mov bx, [0x895]                              ; 04394  0x8B, 0x1E, 0x95, 0x08
  mov cl, 4                                    ; 04398  0xB1, 0x04
  jmp short loc_043A2                          ; 0439A  0xEB, 0x06

sub_0439C:                                     ; 0439C
  mov bx, [0x893]                              ; 0439C  0x8B, 0x1E, 0x93, 0x08

sub_043A0:                                     ; 043A0
  mov cl, 1                                    ; 043A0  0xB1, 0x01

loc_043A2:                                     ; 043A2
  or_bx_bx                                     ; 043A2  or bx, bx
  je loc_043BC                                 ; 043A4  0x74, 0x16
  mov bx, [bx]                                 ; 043A6  0x8B, 0x1F

loc_043A8:                                     ; 043A8
  push cx                                      ; 043A8  0x51
  mov dx, 0x8f4                                ; 043A9  0xBA, 0xF4, 0x08
  call sub_0400C                               ; 043AC  0xE8, 0x5D, 0xFC
  pop cx                                       ; 043AF  0x59
  jne loc_043B5                                ; 043B0  0x75, 0x03
  mov byte [bx], 0xff                          ; 043B2  0xC6, 0x07, 0xFF

loc_043B5:                                     ; 043B5
  mov bx, [bx + 0xc]                           ; 043B5  0x8B, 0x5F, 0x0C
  or_bx_bx                                     ; 043B8  or bx, bx
  jne loc_043A8                                ; 043BA  0x75, 0xEC

loc_043BC:                                     ; 043BC
  ret                                          ; 043BC  0xC3

sub_043BD:                                     ; 043BD
  or_bx_bx                                     ; 043BD  or bx, bx
  je loc_043BC                                 ; 043BF  0x74, 0xFB
  mov bx, [bx]                                 ; 043C1  0x8B, 0x1F

loc_043C3:                                     ; 043C3
  mov al, [bx]                                 ; 043C3  0x8A, 0x07
  cmp al, [0x8f4]                              ; 043C5  0x3A, 0x06, 0xF4, 0x08
  jne loc_043E7                                ; 043C9  0x75, 0x1C
  mov ax, [bx + 0xe]                           ; 043CB  0x8B, 0x47, 0x0E
  cmp ax, [0x68]                               ; 043CE  0x3B, 0x06, 0x68, 0x00
  jne loc_043E7                                ; 043D2  0x75, 0x13
  mov word [bx + 0xe], 0                       ; 043D4  0xC7, 0x47, 0x0E, 0x00, 0x00
  mov al, [0x85b]                              ; 043D9  0xA0, 0x5B, 0x08
  cmp al, 0x21                                 ; 043DC  0x3C, 0x21
  je loc_043E4                                 ; 043DE  0x74, 0x04
  cmp al, 0x1a                                 ; 043E0  0x3C, 0x1A
  jne loc_043E7                                ; 043E2  0x75, 0x03

loc_043E4:                                     ; 043E4
  mov byte [bx], 0xff                          ; 043E4  0xC6, 0x07, 0xFF

loc_043E7:                                     ; 043E7
  mov bx, [bx + 0xc]                           ; 043E7  0x8B, 0x5F, 0x0C
  or_bx_bx                                     ; 043EA  or bx, bx
  jne loc_043C3                                ; 043EC  0x75, 0xD5
  ret                                          ; 043EE  0xC3

sub_043EF:                                     ; 043EF
  mov [0x854], bx                              ; 043EF  0x89, 0x1E, 0x54, 0x08
  mov_di_bx                                    ; 043F3  mov di, bx
  sub di, 0xc                                  ; 043F5  0x83, 0xEF, 0x0C
  mov bx, [bx]                                 ; 043F8  0x8B, 0x1F
  cmp word [bx + 0xc], 0                       ; 043FA  0x83, 0x7F, 0x0C, 0x00
  jne loc_04403                                ; 043FE  0x75, 0x03
  jmp near loc_044F5                           ; 04400  0xE9, 0xF2, 0x00

loc_04403:                                     ; 04403
  xor_ax_ax                                    ; 04403  xor ax, ax
  mov [0x856], ax                              ; 04405  0xA3, 0x56, 0x08
  mov [0x858], ax                              ; 04408  0xA3, 0x58, 0x08
  mov [0x85a], al                              ; 0440B  0xA2, 0x5A, 0x08

loc_0440E:                                     ; 0440E
  cmp byte [bx], 0xff                          ; 0440E  0x80, 0x3F, 0xFF
  je loc_0442A                                 ; 04411  0x74, 0x17
  mov ax, [bx + 0xe]                           ; 04413  0x8B, 0x47, 0x0E
  or_ax_ax                                     ; 04416  or ax, ax
  jne loc_04434                                ; 04418  0x75, 0x1A
  mov si, [0x856]                              ; 0441A  0x8B, 0x36, 0x56, 0x08
  or_si_si                                     ; 0441E  or si, si
  je loc_0442A                                 ; 04420  0x74, 0x08
  mov si, [si + 0xc]                           ; 04422  0x8B, 0x74, 0x0C
  cmp byte [si], 0xff                          ; 04425  0x80, 0x3C, 0xFF
  je loc_04442                                 ; 04428  0x74, 0x18

loc_0442A:                                     ; 0442A
  mov [0x856], di                              ; 0442A  0x89, 0x3E, 0x56, 0x08
  mov byte [bx + 5], 0                         ; 0442E  0xC6, 0x47, 0x05, 0x00
  jmp short loc_04442                          ; 04432  0xEB, 0x0E

loc_04434:                                     ; 04434
  cmp ax, [0x68]                               ; 04434  0x3B, 0x06, 0x68, 0x00
  jne loc_04442                                ; 04438  0x75, 0x08
  inc byte [0x85a]                             ; 0443A  0xFE, 0x06, 0x5A, 0x08
  mov [0x858], di                              ; 0443E  0x89, 0x3E, 0x58, 0x08

loc_04442:                                     ; 04442
  mov [0x852], bx                              ; 04442  0x89, 0x1E, 0x52, 0x08
  push di                                      ; 04446  0x57
  call sub_04716                               ; 04447  0xE8, 0xCC, 0x02
  call sub_0400C                               ; 0444A  0xE8, 0xBF, 0xFB
  pop di                                       ; 0444D  0x5F
  mov bx, [0x852]                              ; 0444E  0x8B, 0x1E, 0x52, 0x08
  jne loc_04471                                ; 04452  0x75, 0x1D
  mov al, [bx + 5]                             ; 04454  0x8A, 0x47, 0x05
  cmp al, 0xff                                 ; 04457  0x3C, 0xFF
  je loc_0446E                                 ; 04459  0x74, 0x13
  mov ah, [0x851]                              ; 0445B  0x8A, 0x26, 0x51, 0x08
  cmp_al_ah                                    ; 0445F  cmp al, ah
  je loc_0446E                                 ; 04461  0x74, 0x0B
  inc al                                       ; 04463  0xFE, 0xC0
  cmp_al_ah                                    ; 04465  cmp al, ah
  je loc_0446B                                 ; 04467  0x74, 0x02
  mov al, 0xff                                 ; 04469  0xB0, 0xFF

loc_0446B:                                     ; 0446B
  mov [bx + 5], al                             ; 0446B  0x88, 0x47, 0x05

loc_0446E:                                     ; 0446E
  jmp near loc_044E3                           ; 0446E  0xE9, 0x72, 0x00

loc_04471:                                     ; 04471
  mov ax, [bx + 0xe]                           ; 04471  0x8B, 0x47, 0x0E
  cmp ax, [0x68]                               ; 04474  0x3B, 0x06, 0x68, 0x00
  jne loc_044B2                                ; 04478  0x75, 0x38
  mov al, [0x8f4]                              ; 0447A  0xA0, 0xF4, 0x08
  cmp al, [bx]                                 ; 0447D  0x3A, 0x07
  jne loc_044B2                                ; 0447F  0x75, 0x31
  mov al, [0x8b3]                              ; 04481  0xA0, 0xB3, 0x08
  or_al_al                                     ; 04484  or al, al
  je loc_044B2                                 ; 04486  0x74, 0x2A
  cmp al, [bx + 5]                             ; 04488  0x3A, 0x47, 0x05
  jne loc_044B2                                ; 0448B  0x75, 0x25
  mov byte [bx + 5], 0                         ; 0448D  0xC6, 0x47, 0x05, 0x00
  cmp word [bx + 0xc], 0                       ; 04491  0x83, 0x7F, 0x0C, 0x00
  je loc_044C0                                 ; 04495  0x74, 0x29
  dec byte [0x85a]                             ; 04497  0xFE, 0x0E, 0x5A, 0x08
  xor_ax_ax                                    ; 0449B  xor ax, ax
  xchg [bx + 0xc], ax                          ; 0449D  0x87, 0x47, 0x0C
  mov [di + 0xc], ax                           ; 044A0  0x89, 0x45, 0x0C
  xchg bx, ax                                  ; 044A3  0x93

loc_044A4:                                     ; 044A4
  mov_si_bx                                    ; 044A4  mov si, bx
  mov bx, [si + 0xc]                           ; 044A6  0x8B, 0x5C, 0x0C
  or_bx_bx                                     ; 044A9  or bx, bx
  jne loc_044A4                                ; 044AB  0x75, 0xF7
  mov [si + 0xc], ax                           ; 044AD  0x89, 0x44, 0x0C
  jmp short loc_044BA                          ; 044B0  0xEB, 0x08

loc_044B2:                                     ; 044B2
  cmp word [bx + 0xc], 0                       ; 044B2  0x83, 0x7F, 0x0C, 0x00
  je loc_044C0                                 ; 044B6  0x74, 0x08
  mov_di_bx                                    ; 044B8  mov di, bx

loc_044BA:                                     ; 044BA
  mov bx, [di + 0xc]                           ; 044BA  0x8B, 0x5D, 0x0C
  jmp near loc_0440E                           ; 044BD  0xE9, 0x4E, 0xFF

loc_044C0:                                     ; 044C0
  mov si, [0x856]                              ; 044C0  0x8B, 0x36, 0x56, 0x08
  or_si_si                                     ; 044C4  or si, si
  je loc_044CA                                 ; 044C6  0x74, 0x02
  mov_di_si                                    ; 044C8  mov di, si

loc_044CA:                                     ; 044CA
  mov si, [0x854]                              ; 044CA  0x8B, 0x36, 0x54, 0x08
  mov al, [0x85a]                              ; 044CE  0xA0, 0x5A, 0x08
  cmp al, [si + 2]                             ; 044D1  0x3A, 0x44, 0x02
  jb loc_044DA                                 ; 044D4  0x72, 0x04
  mov di, [0x858]                              ; 044D6  0x8B, 0x3E, 0x58, 0x08

loc_044DA:                                     ; 044DA
  mov bx, [di + 0xc]                           ; 044DA  0x8B, 0x5D, 0x0C
  mov al, [0x851]                              ; 044DD  0xA0, 0x51, 0x08
  mov [bx + 5], al                             ; 044E0  0x88, 0x47, 0x05

loc_044E3:                                     ; 044E3
  mov si, [0x854]                              ; 044E3  0x8B, 0x36, 0x54, 0x08
  mov ax, [si]                                 ; 044E7  0x8B, 0x04
  cmp_ax_bx                                    ; 044E9  cmp ax, bx
  je loc_044F5                                 ; 044EB  0x74, 0x08
  xchg [bx + 0xc], ax                          ; 044ED  0x87, 0x47, 0x0C
  mov [di + 0xc], ax                           ; 044F0  0x89, 0x45, 0x0C
  mov [si], bx                                 ; 044F3  0x89, 0x1C

loc_044F5:                                     ; 044F5
  mov ax, [0x68]                               ; 044F5  0xA1, 0x68, 0x00
  mov [bx + 0xe], ax                           ; 044F8  0x89, 0x47, 0x0E
  ret                                          ; 044FB  0xC3

sub_044FC:                                     ; 044FC
  mov bx, 0x825                                ; 044FC  0xBB, 0x25, 0x08

loc_044FF:                                     ; 044FF
  mov_di_bx                                    ; 044FF  mov di, bx
  mov bx, [bx]                                 ; 04501  0x8B, 0x1F
  cmp word [bx], 0                             ; 04503  0x83, 0x3F, 0x00
  jne loc_044FF                                ; 04506  0x75, 0xF7
  mov al, [0x8f4]                              ; 04508  0xA0, 0xF4, 0x08
  mov [bx + 4], al                             ; 0450B  0x88, 0x47, 0x04
  mov [bx + 2], dx                             ; 0450E  0x89, 0x57, 0x02
  xor_ax_ax                                    ; 04511  xor ax, ax
  mov [bx + 5], al                             ; 04513  0x88, 0x47, 0x05
  mov [di], ax                                 ; 04516  0x89, 0x05
  mov_ax_bx                                    ; 04518  mov ax, bx
  xchg [0x825], ax                             ; 0451A  0x87, 0x06, 0x25, 0x08
  mov [bx], ax                                 ; 0451E  0x89, 0x07
  ret                                          ; 04520  0xC3

sub_04521:                                     ; 04521
  mov al, [0x8f4]                              ; 04521  0xA0, 0xF4, 0x08
  mov bx, 0x825                                ; 04524  0xBB, 0x25, 0x08

loc_04527:                                     ; 04527
  mov bx, [bx]                                 ; 04527  0x8B, 0x1F
  cmp [bx + 4], al                             ; 04529  0x38, 0x47, 0x04
  jne loc_04532                                ; 0452C  0x75, 0x04
  mov byte [bx + 4], 0xff                      ; 0452E  0xC6, 0x47, 0x04, 0xFF

loc_04532:                                     ; 04532
  cmp word [bx], 0                             ; 04532  0x83, 0x3F, 0x00
  jne loc_04527                                ; 04535  0x75, 0xF0
  ret                                          ; 04537  0xC3

sub_04538:                                     ; 04538
  mov al, [0x8f4]                              ; 04538  0xA0, 0xF4, 0x08
  mov bx, 0x825                                ; 0453B  0xBB, 0x25, 0x08
  mov dx, [0x823]                              ; 0453E  0x8B, 0x16, 0x23, 0x08

loc_04542:                                     ; 04542
  mov bx, [bx]                                 ; 04542  0x8B, 0x1F
  cmp [bx + 4], al                             ; 04544  0x38, 0x47, 0x04
  jne loc_04564                                ; 04547  0x75, 0x1B
  cmp [bx + 2], dx                             ; 04549  0x39, 0x57, 0x02
  jne loc_04564                                ; 0454C  0x75, 0x16
  cmp cl, [bx + 5]                             ; 0454E  0x3A, 0x4F, 0x05
  jb loc_04563                                 ; 04551  0x72, 0x10
  mov al, [0x8b3]                              ; 04553  0xA0, 0xB3, 0x08
  mov_ah_al                                    ; 04556  mov ah, al
  not ah                                       ; 04558  0xF6, 0xD4
  and_cl_ah                                    ; 0455A  and cl, ah
  inc al                                       ; 0455C  0xFE, 0xC0
  add_al_cl                                    ; 0455E  add al, cl
  mov [bx + 5], al                             ; 04560  0x88, 0x47, 0x05

loc_04563:                                     ; 04563
  ret                                          ; 04563  0xC3

loc_04564:                                     ; 04564
  cmp word [bx], 0                             ; 04564  0x83, 0x3F, 0x00
  jne loc_04542                                ; 04567  0x75, 0xD9
  stc                                          ; 04569  0xF9
  ret                                          ; 0456A  0xC3

sub_0456B:                                     ; 0456B
  push ax                                      ; 0456B  0x50
  call sub_04015                               ; 0456C  0xE8, 0xA6, 0xFA
  pop ax                                       ; 0456F  0x58
  dec al                                       ; 04570  0xFE, 0xC8
  js loc_0457E                                 ; 04572  0x78, 0x0A
  jne loc_0457B                                ; 04574  0x75, 0x05
  mov cl, 1                                    ; 04576  0xB1, 0x01
  jmp near sub_0431C                           ; 04578  0xE9, 0xA1, 0xFD

loc_0457B:                                     ; 0457B
  call sub_04325                               ; 0457B  0xE8, 0xA7, 0xFD

loc_0457E:                                     ; 0457E
  mov si, 0x85c                                ; 0457E  0xBE, 0x5C, 0x08
  mov di, [0x852]                              ; 04581  0x8B, 0x3E, 0x52, 0x08
  add di, 6                                    ; 04585  0x83, 0xC7, 0x06
  mov cx, 2                                    ; 04588  0xB9, 0x02, 0x00
  rep movsw                                    ; 0458B  0xF3, 0xA5
  ret                                          ; 0458D  0xC3

loc_0458E:                                     ; 0458E
  mov ah, 1                                    ; 0458E  0xB4, 0x01
  call sub_045A9                               ; 04590  0xE8, 0x16, 0x00
  jmp near loc_04142                           ; 04593  0xE9, 0xAC, 0xFB

sub_04596:                                     ; 04596
  mov [0x8fc], ds                              ; 04596  0x8C, 0x1E, 0xFC, 0x08
  mov bx, [0x893]                              ; 0459A  0x8B, 0x1E, 0x93, 0x08
  cmp ah, 5                                    ; 0459E  0x80, 0xFC, 0x05
  jne sub_0460C                                ; 045A1  0x75, 0x69
  mov bx, [0x852]                              ; 045A3  0x8B, 0x1E, 0x52, 0x08
  jmp short sub_0460C                          ; 045A7  0xEB, 0x63

sub_045A9:                                     ; 045A9
  mov bx, [0x895]                              ; 045A9  0x8B, 0x1E, 0x95, 0x08
  mov word [0x8fc], 0                          ; 045AD  0xC7, 0x06, 0xFC, 0x08, 0x00, 0x00
  cmp ah, 4                                    ; 045B3  0x80, 0xFC, 0x04
  jne sub_0460C                                ; 045B6  0x75, 0x54

loc_045B8:                                     ; 045B8
  mov bx, [bx]                                 ; 045B8  0x8B, 0x1F
  mov word [0x85c], 0xffff                     ; 045BA  0xC7, 0x06, 0x5C, 0x08, 0xFF, 0xFF

loc_045C0:                                     ; 045C0
  mov al, [0x8f4]                              ; 045C0  0xA0, 0xF4, 0x08
  cmp al, [bx]                                 ; 045C3  0x3A, 0x07
  jne loc_045E6                                ; 045C5  0x75, 0x1F
  test byte [bx + 4], 0xff                     ; 045C7  0xF6, 0x47, 0x04, 0xFF
  je loc_045E6                                 ; 045CB  0x74, 0x19
  mov ax, [bx + 0xe]                           ; 045CD  0x8B, 0x47, 0x0E
  cmp ax, [0x68]                               ; 045D0  0x3B, 0x06, 0x68, 0x00
  jne loc_045E6                                ; 045D4  0x75, 0x10
  mov ax, [bx + 6]                             ; 045D6  0x8B, 0x47, 0x06
  cmp ax, [0x85c]                              ; 045D9  0x3B, 0x06, 0x5C, 0x08
  jae loc_045E6                                ; 045DD  0x73, 0x07
  mov [0x85c], ax                              ; 045DF  0xA3, 0x5C, 0x08
  mov [0x85e], bx                              ; 045E2  0x89, 0x1E, 0x5E, 0x08

loc_045E6:                                     ; 045E6
  mov bx, [bx + 0xc]                           ; 045E6  0x8B, 0x5F, 0x0C
  or_bx_bx                                     ; 045E9  or bx, bx
  jne loc_045C0                                ; 045EB  0x75, 0xD3
  cmp word [0x85c], -1                         ; 045ED  0x83, 0x3E, 0x5C, 0x08, 0xFF
  jne loc_045F5                                ; 045F2  0x75, 0x01
  ret                                          ; 045F4  0xC3

loc_045F5:                                     ; 045F5
  mov bx, [0x85e]                              ; 045F5  0x8B, 0x1E, 0x5E, 0x08
  xor_al_al                                    ; 045F9  xor al, al
  mov ah, 4                                    ; 045FB  0xB4, 0x04
  mov word [0x8fc], 0                          ; 045FD  0xC7, 0x06, 0xFC, 0x08, 0x00, 0x00
  call sub_0460C                               ; 04603  0xE8, 0x06, 0x00
  mov bx, [0x895]                              ; 04606  0x8B, 0x1E, 0x95, 0x08
  jmp short loc_045B8                          ; 0460A  0xEB, 0xAC

sub_0460C:                                     ; 0460C
  mov [0x850], ah                              ; 0460C  0x88, 0x26, 0x50, 0x08
  lahf                                         ; 04610  0x9F
  mov cl, [0x8b3]                              ; 04611  0x8A, 0x0E, 0xB3, 0x08
  mov al, [0x8f5]                              ; 04615  0xA0, 0xF5, 0x08
  and_al_cl                                    ; 04618  and al, cl
  mov [0x851], al                              ; 0461A  0xA2, 0x51, 0x08
  not cl                                       ; 0461D  0xF6, 0xD1
  and [0x8f5], cl                              ; 0461F  0x20, 0x0E, 0xF5, 0x08
  sahf                                         ; 04623  0x9E
  je loc_04629                                 ; 04624  0x74, 0x03
  call sub_043EF                               ; 04626  0xE8, 0xC6, 0xFD

loc_04629:                                     ; 04629
  mov [0x852], bx                              ; 04629  0x89, 0x1E, 0x52, 0x08
  mov ax, [bx + 0xa]                           ; 0462D  0x8B, 0x47, 0x0A
  cmp word [0x8fc], 0                          ; 04630  0x83, 0x3E, 0xFC, 0x08, 0x00
  jne loc_0463C                                ; 04635  0x75, 0x05
  mov [0x8fc], ax                              ; 04637  0xA3, 0xFC, 0x08
  xor_ax_ax                                    ; 0463A  xor ax, ax

loc_0463C:                                     ; 0463C
  mov [0x8fe], ax                              ; 0463C  0xA3, 0xFE, 0x08
  mov al, [0x850]                              ; 0463F  0xA0, 0x50, 0x08
  cmp al, 3                                    ; 04642  0x3C, 0x03
  jne loc_04651                                ; 04644  0x75, 0x0B
  xor_ah_ah                                    ; 04646  xor ah, ah
  xchg [0x810], ah                             ; 04648  0x86, 0x26, 0x10, 0x08
  test ah, 0xf0                                ; 0464C  0xF6, 0xC4, 0xF0
  jne loc_046C3                                ; 0464F  0x75, 0x72

loc_04651:                                     ; 04651
  call sub_04716                               ; 04651  0xE8, 0xC2, 0x00
  cmp byte [bx], 0xff                          ; 04654  0x80, 0x3F, 0xFF
  je loc_046A7                                 ; 04657  0x74, 0x4E
  cmp al, 4                                    ; 04659  0x3C, 0x04
  jae loc_04662                                ; 0465B  0x73, 0x05
  call sub_0400C                               ; 0465D  0xE8, 0xAC, 0xF9
  je loc_046D8                                 ; 04660  0x74, 0x76

loc_04662:                                     ; 04662
  cmp al, 5                                    ; 04662  0x3C, 0x05
  je loc_0466C                                 ; 04664  0x74, 0x06
  test byte [bx + 4], 0xff                     ; 04666  0xF6, 0x47, 0x04, 0xFF
  je loc_046A7                                 ; 0466A  0x74, 0x3B

loc_0466C:                                     ; 0466C
  mov byte [bx + 4], 0                         ; 0466C  0xC6, 0x47, 0x04, 0x00
  push word [0x8f4]                            ; 04670  0xFF, 0x36, 0xF4, 0x08
  push word [0x8f6]                            ; 04674  0xFF, 0x36, 0xF6, 0x08
  mov ax, [bx + 2]                             ; 04678  0x8B, 0x47, 0x02
  mov [0x8f6], ax                              ; 0467B  0xA3, 0xF6, 0x08
  mov ax, [bx]                                 ; 0467E  0x8B, 0x07
  mov [0x8f4], ax                              ; 04680  0xA3, 0xF4, 0x08
  mov byte [bx], 0xff                          ; 04683  0xC6, 0x07, 0xFF
  cmp [0x881], al                              ; 04686  0x38, 0x06, 0x81, 0x08
  je loc_0468F                                 ; 0468A  0x74, 0x03
  call sub_0550D                               ; 0468C  0xE8, 0x7E, 0x0E

loc_0468F:                                     ; 0468F
  mov al, 1                                    ; 0468F  0xB0, 0x01
  jne loc_04696                                ; 04691  0x75, 0x03
  call sub_0456B                               ; 04693  0xE8, 0xD5, 0xFE

loc_04696:                                     ; 04696
  call sub_04716                               ; 04696  0xE8, 0x7D, 0x00
  call sub_04003                               ; 04699  0xE8, 0x67, 0xF9
  pop word [0x8f6]                             ; 0469C  0x8F, 0x06, 0xF6, 0x08
  pop word [0x8f4]                             ; 046A0  0x8F, 0x06, 0xF4, 0x08
  call sub_05525                               ; 046A4  0xE8, 0x7E, 0x0E

loc_046A7:                                     ; 046A7
  mov al, [0x850]                              ; 046A7  0xA0, 0x50, 0x08
  cmp al, 4                                    ; 046AA  0x3C, 0x04
  jb loc_046AF                                 ; 046AC  0x72, 0x01
  ret                                          ; 046AE  0xC3

loc_046AF:                                     ; 046AF
  cmp al, 2                                    ; 046AF  0x3C, 0x02
  jne loc_046C3                                ; 046B1  0x75, 0x10
  mov cl, [0x822]                              ; 046B3  0x8A, 0x0E, 0x22, 0x08
  call sub_04538                               ; 046B7  0xE8, 0x7E, 0xFE
  jb loc_046C3                                 ; 046BA  0x72, 0x07
  xor_al_al                                    ; 046BC  xor al, al
  call sub_0456B                               ; 046BE  0xE8, 0xAA, 0xFE
  jmp short loc_046CF                          ; 046C1  0xEB, 0x0C

loc_046C3:                                     ; 046C3
  mov bx, [0x852]                              ; 046C3  0x8B, 0x1E, 0x52, 0x08
  mov byte [bx], 0xff                          ; 046C7  0xC6, 0x07, 0xFF
  mov al, 2                                    ; 046CA  0xB0, 0x02
  call sub_0456B                               ; 046CC  0xE8, 0x9C, 0xFE

loc_046CF:                                     ; 046CF
  call sub_04716                               ; 046CF  0xE8, 0x44, 0x00
  call sub_04003                               ; 046D2  0xE8, 0x2E, 0xF9
  mov byte [di], 0                             ; 046D5  0xC6, 0x05, 0x00

loc_046D8:                                     ; 046D8
  xor_al_al                                    ; 046D8  xor al, al
  mov ah, [0x851]                              ; 046DA  0x8A, 0x26, 0x51, 0x08
  shr ax, 1                                    ; 046DE  0xD1, 0xE8
  mov si, [0x8fe]                              ; 046E0  0x8B, 0x36, 0xFE, 0x08
  add_si_ax                                    ; 046E4  add si, ax
  mov al, [0x850]                              ; 046E6  0xA0, 0x50, 0x08
  cmp al, 3                                    ; 046E9  0x3C, 0x03
  jne loc_046F2                                ; 046EB  0x75, 0x05
  mov [0x88b], si                              ; 046ED  0x89, 0x36, 0x8B, 0x08
  ret                                          ; 046F1  0xC3

loc_046F2:                                     ; 046F2
  mov cx, 0x40                                 ; 046F2  0xB9, 0x40, 0x00
  mov di, [0x866]                              ; 046F5  0x8B, 0x3E, 0x66, 0x08
  cmp al, 1                                    ; 046F9  0x3C, 0x01
  mov ax, [0x868]                              ; 046FB  0xA1, 0x68, 0x08
  mov dx, [0x8fc]                              ; 046FE  0x8B, 0x16, 0xFC, 0x08
  push ds                                      ; 04702  0x1E
  push es                                      ; 04703  0x06
  je loc_0470D                                 ; 04704  0x74, 0x07
  mov byte [bx + 4], 0xff                      ; 04706  0xC6, 0x47, 0x04, 0xFF
  xchg di, si                                  ; 0470A  87 FE
  xchg dx, ax                                  ; 0470C  0x92

loc_0470D:                                     ; 0470D
  mov ds, dx                                   ; 0470D  0x8E, 0xDA
  mov es, ax                                   ; 0470F  0x8E, 0xC0
  rep movsw                                    ; 04711  0xF3, 0xA5
  pop es                                       ; 04713  0x07
  pop ds                                       ; 04714  0x1F
  ret                                          ; 04715  0xC3

sub_04716:                                     ; 04716
  mov bx, [0x852]                              ; 04716  0x8B, 0x1E, 0x52, 0x08
  mov dx, 0x8f4                                ; 0471A  0xBA, 0xF4, 0x08
  mov cl, 4                                    ; 0471D  0xB1, 0x04

loc_0471F:                                     ; 0471F
  ret                                          ; 0471F  0xC3

sub_04720:                                     ; 04720
  call sub_04763                               ; 04720  0xE8, 0x40, 0x00
  test byte [0x81c], 0xff                      ; 04723  0xF6, 0x06, 0x1C, 0x08, 0xFF
  je loc_0471F                                 ; 04728  0x74, 0xF5
  call sub_042E4                               ; 0472A  0xE8, 0xB7, 0xFB
  call sub_04300                               ; 0472D  0xE8, 0xD0, 0xFB

sub_04730:                                     ; 04730
  mov ax, [0x870]                              ; 04730  0xA1, 0x70, 0x08
  mov cl, 2                                    ; 04733  0xB1, 0x02
  shr ax, cl                                   ; 04735  0xD3, 0xE8
  mov [0x8fa], ax                              ; 04737  0xA3, 0xFA, 0x08
  mov [0x8f5], ax                              ; 0473A  0xA3, 0xF5, 0x08
  mov byte [0x8f7], 0                          ; 0473D  0xC6, 0x06, 0xF7, 0x08, 0x00
  mov ah, 3                                    ; 04742  0xB4, 0x03
  jmp short sub_04753                          ; 04744  0xEB, 0x0D

sub_04746:                                     ; 04746
  call sub_0426C                               ; 04746  0xE8, 0x23, 0xFB
  mov ah, 5                                    ; 04749  0xB4, 0x05
  call sub_04753                               ; 0474B  0xE8, 0x05, 0x00
  mov cl, 0xff                                 ; 0474E  0xB1, 0xFF
  jmp near loc_0479C                           ; 04750  0xE9, 0x49, 0x00

sub_04753:                                     ; 04753
  call sub_04596                               ; 04753  0xE8, 0x40, 0xFE

sub_04756:                                     ; 04756
  mov ax, [0x868]                              ; 04756  0xA1, 0x68, 0x08
  mov [0x8fc], ax                              ; 04759  0xA3, 0xFC, 0x08
  mov ax, [0x866]                              ; 0475C  0xA1, 0x66, 0x08
  mov [0x8fe], ax                              ; 0475F  0xA3, 0xFE, 0x08
  ret                                          ; 04762  0xC3

sub_04763:                                     ; 04763
  mov dx, [0x8aa]                              ; 04763  0x8B, 0x16, 0xAA, 0x08
  mov bx, [0x870]                              ; 04767  0x8B, 0x1E, 0x70, 0x08
  inc bx                                       ; 0476B  0x43
  mov [0x870], bx                              ; 0476C  0x89, 0x1E, 0x70, 0x08
  sub_dx_bx                                    ; 04770  sub dx, bx
  jae loc_04777                                ; 04772  0x73, 0x03
  jmp near sub_042A5                           ; 04774  0xE9, 0x2E, 0xFB

loc_04777:                                     ; 04777
  mov al, [0x870]                              ; 04777  0xA0, 0x70, 0x08
  and al, 3                                    ; 0477A  0x24, 0x03
  push cx                                      ; 0477C  0x51
  mov cl, 5                                    ; 0477D  0xB1, 0x05
  shl al, cl                                   ; 0477F  0xD2, 0xE0
  pop cx                                       ; 04781  0x59
  mov [0x900], al                              ; 04782  0xA2, 0x00, 0x09
  test byte [0x810], 0xff                      ; 04785  0xF6, 0x06, 0x10, 0x08, 0xFF
  jne loc_04790                                ; 0478A  0x75, 0x04
  or_al_al                                     ; 0478C  or al, al
  jne loc_04805                                ; 0478E  0x75, 0x75

loc_04790:                                     ; 04790
  push cx                                      ; 04790  0x51
  call sub_04730                               ; 04791  0xE8, 0x9C, 0xFF
  pop cx                                       ; 04794  0x59
  test byte [0x81c], 0xff                      ; 04795  0xF6, 0x06, 0x1C, 0x08, 0xFF
  jne loc_04805                                ; 0479A  0x75, 0x69

loc_0479C:                                     ; 0479C
  mov dx, [0x8fa]                              ; 0479C  0x8B, 0x16, 0xFA, 0x08
  mov bx, [0x8ae]                              ; 047A0  0x8B, 0x1E, 0xAE, 0x08
  and bh, 0x7f                                 ; 047A4  0x80, 0xE7, 0x7F
  sub_dx_bx                                    ; 047A7  sub dx, bx
  jae loc_047ED                                ; 047A9  0x73, 0x42
  push cx                                      ; 047AB  0x51
  call sub_0416A                               ; 047AC  0xE8, 0xBB, 0xF9
  mov bx, [0x8fa]                              ; 047AF  0x8B, 0x1E, 0xFA, 0x08
  add bx, [0x88f]                              ; 047B3  0x03, 0x1E, 0x8F, 0x08
  pop cx                                       ; 047B7  0x59
  inc cl                                       ; 047B8  0xFE, 0xC1
  je loc_047EB                                 ; 047BA  0x74, 0x2F
  inc cl                                       ; 047BC  0xFE, 0xC1
  je loc_047E4                                 ; 047BE  0x74, 0x24
  cmp al, [bx]                                 ; 047C0  0x3A, 0x07
  je loc_047ED                                 ; 047C2  0x74, 0x29
  call sub_0423F                               ; 047C4  0xE8, 0x78, 0xFA
  jne loc_047ED                                ; 047C7  0x75, 0x24

sub_047C9:                                     ; 047C9
  mov bx, [0x895]                              ; 047C9  0x8B, 0x1E, 0x95, 0x08
  call sub_043A0                               ; 047CD  0xE8, 0xD0, 0xFB
  call sub_059F2                               ; 047D0  0xE8, 0x1F, 0x12
  mov al, 0xff                                 ; 047D3  0xB0, 0xFF
  mov [0x81c], al                              ; 047D5  0xA2, 0x1C, 0x08
  mov [0x84f], al                              ; 047D8  0xA2, 0x4F, 0x08
  mov bx, 0x800                                ; 047DB  0xBB, 0x00, 0x08
  call sub_04233                               ; 047DE  0xE8, 0x52, 0xFA
  jmp near loc_065E0                           ; 047E1  0xE9, 0xFC, 0x1D

loc_047E4:                                     ; 047E4
  cmp al, [bx]                                 ; 047E4  0x3A, 0x07
  je loc_047ED                                 ; 047E6  0x74, 0x05
  jmp near loc_059E8                           ; 047E8  0xE9, 0xFD, 0x11

loc_047EB:                                     ; 047EB
  mov [bx], al                                 ; 047EB  0x88, 0x07

loc_047ED:                                     ; 047ED
  ret                                          ; 047ED  0xC3

sub_047EE:                                     ; 047EE
  mov_bx_cx                                    ; 047EE  mov bx, cx
  and cl, 7                                    ; 047F0  0x80, 0xE1, 0x07
  inc cl                                       ; 047F3  0xFE, 0xC1
  mov_ch_cl                                    ; 047F5  mov ch, cl
  mov cl, 3                                    ; 047F7  0xB1, 0x03
  shr bx, cl                                   ; 047F9  0xD3, 0xEB
  add bx, [0x891]                              ; 047FB  0x03, 0x1E, 0x91, 0x08
  mov al, [bx]                                 ; 047FF  0x8A, 0x07
  mov_cl_ch                                    ; 04801  mov cl, ch
  rol al, cl                                   ; 04803  0xD2, 0xC0

loc_04805:                                     ; 04805
  ret                                          ; 04805  0xC3

sub_04806:                                     ; 04806
  push dx                                      ; 04806  0x52
  call sub_047EE                               ; 04807  0xE8, 0xE4, 0xFF
  and al, 0xfe                                 ; 0480A  0x24, 0xFE
  pop dx                                       ; 0480C  0x5A
  or_al_dl                                     ; 0480D  or al, dl

sub_0480F:                                     ; 0480F
  ror al, cl                                   ; 0480F  0xD2, 0xC8
  mov [bx], al                                 ; 04811  0x88, 0x07
  ret                                          ; 04813  0xC3

sub_04814:                                     ; 04814
  mov bx, [0x8a8]                              ; 04814  0x8B, 0x1E, 0xA8, 0x08
  mov cl, 3                                    ; 04818  0xB1, 0x03
  shr bx, cl                                   ; 0481A  0xD3, 0xEB
  inc bx                                       ; 0481C  0x43
  ret                                          ; 0481D  0xC3

sub_0481E:                                     ; 0481E
  pushf                                        ; 0481E  0x9C
  call sub_04814                               ; 0481F  0xE8, 0xF2, 0xFF
  mov si, [0x891]                              ; 04822  0x8B, 0x36, 0x91, 0x08
  mov_di_si                                    ; 04826  mov di, si
  add_di_bx                                    ; 04828  add di, bx
  mov_cx_bx                                    ; 0482A  mov cx, bx
  popf                                         ; 0482C  0x9D
  je loc_04831                                 ; 0482D  0x74, 0x02
  xchg si, di                                  ; 0482F  87 F7

loc_04831:                                     ; 04831
  rep movsb                                    ; 04831  0xF3, 0xA4
  call sub_04521                               ; 04833  0xE8, 0xEB, 0xFC

loc_04836:                                     ; 04836
  ret                                          ; 04836  0xC3

sub_04837:                                     ; 04837
  call sub_0424E                               ; 04837  0xE8, 0x14, 0xFA
  add bx, 0x10                                 ; 0483A  0x83, 0xC3, 0x10
  push cx                                      ; 0483D  0x51
  mov cl, 0x11                                 ; 0483E  0xB1, 0x11

loc_04840:                                     ; 04840
  pop dx                                       ; 04840  0x5A
  dec cl                                       ; 04841  0xFE, 0xC9
  jne loc_04853                                ; 04843  0x75, 0x0E
  or_dl_dl                                     ; 04845  or dl, dl
  jne loc_04836                                ; 04847  0x75, 0xED
  mov bx, [0x891]                              ; 04849  0x8B, 0x1E, 0x91, 0x08
  mov ax, [0x8ac]                              ; 0484D  0xA1, 0xAC, 0x08
  or [bx], ax                                  ; 04850  0x09, 0x07
  ret                                          ; 04852  0xC3

loc_04853:                                     ; 04853
  push dx                                      ; 04853  0x52
  cmp byte [0x8f0], 0                          ; 04854  0x80, 0x3E, 0xF0, 0x08, 0x00
  je loc_04863                                 ; 04859  0x74, 0x08
  push cx                                      ; 0485B  0x51
  push bx                                      ; 0485C  0x53
  mov cl, [bx]                                 ; 0485D  0x8A, 0x0F
  mov ch, 0                                    ; 0485F  0xB5, 0x00
  jmp short loc_0486A                          ; 04861  0xEB, 0x07

loc_04863:                                     ; 04863
  dec cl                                       ; 04863  0xFE, 0xC9
  push cx                                      ; 04865  0x51
  mov cx, [bx]                                 ; 04866  0x8B, 0x0F
  inc bx                                       ; 04868  0x43
  push bx                                      ; 04869  0x53

loc_0486A:                                     ; 0486A
  or_cx_cx                                     ; 0486A  or cx, cx
  je loc_04879                                 ; 0486C  0x74, 0x0B
  mov bx, [0x8a8]                              ; 0486E  0x8B, 0x1E, 0xA8, 0x08
  cmp_bx_cx                                    ; 04872  cmp bx, cx
  jb loc_04879                                 ; 04874  0x72, 0x03
  call sub_04806                               ; 04876  0xE8, 0x8D, 0xFF

loc_04879:                                     ; 04879
  pop bx                                       ; 04879  0x5B
  inc bx                                       ; 0487A  0x43
  pop cx                                       ; 0487B  0x59
  jmp short loc_04840                          ; 0487C  0xEB, 0xC2

sub_0487E:                                     ; 0487E
  push cx                                      ; 0487E  0x51
  call sub_04837                               ; 0487F  0xE8, 0xB5, 0xFF
  pop cx                                       ; 04882  0x59

sub_04883:                                     ; 04883
  push cx                                      ; 04883  0x51
  call sub_04814                               ; 04884  0xE8, 0x8D, 0xFF
  pop cx                                       ; 04887  0x59
  mov ax, [0x891]                              ; 04888  0xA1, 0x91, 0x08
  push ax                                      ; 0488B  0x50
  add_ax_bx                                    ; 0488C  add ax, bx
  mov [0x891], ax                              ; 0488E  0xA3, 0x91, 0x08
  call sub_04837                               ; 04891  0xE8, 0xA3, 0xFF
  pop word [0x891]                             ; 04894  0x8F, 0x06, 0x91, 0x08
  ret                                          ; 04898  0xC3

sub_04899:                                     ; 04899
  mov dx, [0x802]                              ; 04899  0x8B, 0x16, 0x02, 0x08
  call sub_04243                               ; 0489D  0xE8, 0xA3, 0xF9
  je loc_048C9                                 ; 048A0  0x74, 0x27
  mov bx, 0x802                                ; 048A2  0xBB, 0x02, 0x08
  call sub_058F7                               ; 048A5  0xE8, 0x4F, 0x10
  mov byte [0x8e0], 0                          ; 048A8  0xC6, 0x06, 0xE0, 0x08, 0x00
  mov ch, 1                                    ; 048AD  0xB5, 0x01
  call sub_0586C                               ; 048AF  0xE8, 0xBA, 0x0F
  jne loc_048C9                                ; 048B2  0x75, 0x15
  call sub_042A5                               ; 048B4  0xE8, 0xEE, 0xF9

loc_048B7:                                     ; 048B7
  mov cl, 0xfe                                 ; 048B7  0xB1, 0xFE
  call sub_04720                               ; 048B9  0xE8, 0x64, 0xFE
  cmp byte [0x8e0], 0                          ; 048BC  0x80, 0x3E, 0xE0, 0x08, 0x00
  jne loc_048C9                                ; 048C1  0x75, 0x06
  call sub_0429E                               ; 048C3  0xE8, 0xD8, 0xF9
  jne loc_048B7                                ; 048C6  0x75, 0xEF
  ret                                          ; 048C8  0xC3

loc_048C9:                                     ; 048C9
  cmp word [0x8ae], 0x8000                     ; 048C9  0x81, 0x3E, 0xAE, 0x08, 0x00, 0x80
  jne loc_048DB                                ; 048CF  0x75, 0x0A
  mov bx, [0x889]                              ; 048D1  0x8B, 0x1E, 0x89, 0x08
  test byte [bx + 2], 0xff                     ; 048D5  0xF6, 0x47, 0x02, 0xFF
  jne loc_04922                                ; 048D9  0x75, 0x47

loc_048DB:                                     ; 048DB
  mov bx, [0x895]                              ; 048DB  0x8B, 0x1E, 0x95, 0x08
  call sub_043A0                               ; 048DF  0xE8, 0xBE, 0xFA
  call sub_0439C                               ; 048E2  0xE8, 0xB7, 0xFA
  call sub_04814                               ; 048E5  0xE8, 0x2C, 0xFF
  mov_cx_bx                                    ; 048E8  mov cx, bx
  mov di, [0x891]                              ; 048EA  0x8B, 0x3E, 0x91, 0x08
  mov ax, [0x8ac]                              ; 048EE  0xA1, 0xAC, 0x08
  stosw                                        ; 048F1  0xAB
  dec cx                                       ; 048F2  0x49
  dec cx                                       ; 048F3  0x49
  xor_ax_ax                                    ; 048F4  xor ax, ax
  rep stosb                                    ; 048F6  0xF3, 0xAA
  mov bx, [0x889]                              ; 048F8  0x8B, 0x1E, 0x89, 0x08
  mov [bx], al                                 ; 048FC  0x88, 0x07
  mov [bx + 1], al                             ; 048FE  0x88, 0x47, 0x01
  mov [0x8f8], ax                              ; 04901  0xA3, 0xF8, 0x08
  mov bx, [0x887]                              ; 04904  0x8B, 0x1E, 0x87, 0x08
  mov word [bx], 4                             ; 04908  0xC7, 0x07, 0x04, 0x00
  call sub_042A5                               ; 0490C  0xE8, 0x96, 0xF9

loc_0490F:                                     ; 0490F
  mov cl, 0xff                                 ; 0490F  0xB1, 0xFF
  call sub_04720                               ; 04911  0xE8, 0x0C, 0xFE
  call sub_0429E                               ; 04914  0xE8, 0x87, 0xF9
  jne loc_04925                                ; 04917  0x75, 0x0C
  mov bx, [0x889]                              ; 04919  0x8B, 0x1E, 0x89, 0x08
  inc byte [bx + 2]                            ; 0491D  0xFE, 0x47, 0x02
  xor_al_al                                    ; 04920  xor al, al

loc_04922:                                     ; 04922
  jmp near sub_0481E                           ; 04922  0xE9, 0xF9, 0xFE

loc_04925:                                     ; 04925
  call sub_04B29                               ; 04925  0xE8, 0x01, 0x02
  call sub_0424E                               ; 04928  0xE8, 0x23, 0xF9
  mov al, [bx]                                 ; 0492B  0x8A, 0x07
  cmp al, 0x21                                 ; 0492D  0x3C, 0x21
  je loc_0490F                                 ; 0492F  0x74, 0xDE
  cmp al, 0xe5                                 ; 04931  0x3C, 0xE5
  je loc_0490F                                 ; 04933  0x74, 0xDA
  cmp al, 0x20                                 ; 04935  0x3C, 0x20
  je loc_04947                                 ; 04937  0x74, 0x0E
  test al, 0x10                                ; 04939  0xA8, 0x10
  jne loc_04942                                ; 0493B  0x75, 0x05
  mov cl, 1                                    ; 0493D  0xB1, 0x01
  call sub_04837                               ; 0493F  0xE8, 0xF5, 0xFE

loc_04942:                                     ; 04942
  call sub_042C1                               ; 04942  0xE8, 0x7C, 0xF9
  jmp short loc_0490F                          ; 04945  0xEB, 0xC8

loc_04947:                                     ; 04947
  mov al, [bx + 0xc]                           ; 04947  0x8A, 0x47, 0x0C
  mov bx, [0x889]                              ; 0494A  0x8B, 0x1E, 0x89, 0x08
  mov [bx], al                                 ; 0494E  0x88, 0x07
  jmp short loc_04942                          ; 04950  0xEB, 0xF0

loc_04952:                                     ; 04952
  mov al, [0x8ed]                              ; 04952  0xA0, 0xED, 0x08
  jmp near loc_03FD1                           ; 04955  0xE9, 0x79, 0xF6

sub_04958:                                     ; 04958
  xor_dl_dl                                    ; 04958  xor dl, dl

sub_0495A:                                     ; 0495A
  mov cx, 0xb                                  ; 0495A  0xB9, 0x0B, 0x00
  mov_si_bx                                    ; 0495D  mov si, bx
  inc si                                       ; 0495F  0x46

loc_04960:                                     ; 04960
  lodsb                                        ; 04960  0xAC
  and al, 0x7f                                 ; 04961  0x24, 0x7F
  cmp al, 0x3f                                 ; 04963  0x3C, 0x3F
  je loc_04977                                 ; 04965  0x74, 0x10
  or_dl_dl                                     ; 04967  or dl, dl
  je loc_04973                                 ; 04969  0x74, 0x08
  cmp al, 0x5b                                 ; 0496B  0x3C, 0x5B
  je loc_04977                                 ; 0496D  0x74, 0x08
  cmp al, 0x5d                                 ; 0496F  0x3C, 0x5D
  je loc_04977                                 ; 04971  0x74, 0x04

loc_04973:                                     ; 04973
  loop loc_04960                               ; 04973  0xE2, 0xEB
  or al, 1                                     ; 04975  0x0C, 0x01

loc_04977:                                     ; 04977
  ret                                          ; 04977  0xC3

sub_04978:                                     ; 04978
  xor_dl_dl                                    ; 04978  xor dl, dl

sub_0497A:                                     ; 0497A
  mov bx, 0xb00                                ; 0497A  0xBB, 0x00, 0x0B
  call sub_0495A                               ; 0497D  0xE8, 0xDA, 0xFF
  jne loc_04977                                ; 04980  0x75, 0xF5
  mov ah, 9                                    ; 04982  0xB4, 0x09
  jmp near loc_03FD5                           ; 04984  0xE9, 0x4E, 0xF6

sub_04987:                                     ; 04987
  cmp word [0x897], 0                          ; 04987  0x83, 0x3E, 0x97, 0x08, 0x00
  je loc_04977                                 ; 0498C  0x74, 0xE9
  or_cl_cl                                     ; 0498E  or cl, cl
  je loc_04977                                 ; 04990  0x74, 0xE5
  cmp cl, 0xc                                  ; 04992  0x80, 0xF9, 0x0C
  jb loc_049BC                                 ; 04995  0x72, 0x25
  mov al, 2                                    ; 04997  0xB0, 0x02
  je loc_0499D                                 ; 04999  0x74, 0x02
  mov al, 3                                    ; 0499B  0xB0, 0x03

loc_0499D:                                     ; 0499D
  mov [0x84f], al                              ; 0499D  0xA2, 0x4F, 0x08
  mov al, [0x85b]                              ; 049A0  0xA0, 0x5B, 0x08
  cmp byte [0x8e8], 0xff                       ; 049A3  0x80, 0x3E, 0xE8, 0x08, 0xFF
  je loc_049B2                                 ; 049A8  0x74, 0x08
  cmp al, 0x16                                 ; 049AA  0x3C, 0x16
  je loc_049B2                                 ; 049AC  0x74, 0x04
  cmp al, 7                                    ; 049AE  0x3C, 0x07
  jae sub_049C1                                ; 049B0  0x73, 0x0F

loc_049B2:                                     ; 049B2
  mov byte [0x84f], 2                          ; 049B2  0xC6, 0x06, 0x4F, 0x08, 0x02
  call sub_04958                               ; 049B7  0xE8, 0x9E, 0xFF
  jne sub_049C1                                ; 049BA  0x75, 0x05

loc_049BC:                                     ; 049BC
  mov byte [0x84f], 0                          ; 049BC  0xC6, 0x06, 0x4F, 0x08, 0x00

sub_049C1:                                     ; 049C1
  mov_si_bx                                    ; 049C1  mov si, bx
  lodsb                                        ; 049C3  0xAC
  mov [0x84b], al                              ; 049C4  0xA2, 0x4B, 0x08
  xor_bx_bx                                    ; 049C7  xor bx, bx
  and al, 0x20                                 ; 049C9  0x24, 0x20
  je loc_049D3                                 ; 049CB  0x74, 0x06
  or byte [0x84b], 0x10                        ; 049CD  0x80, 0x0E, 0x4B, 0x08, 0x10
  ret                                          ; 049D2  0xC3

loc_049D3:                                     ; 049D3
  mov_dl_al                                    ; 049D3  mov dl, al
  mov cx, 0xb                                  ; 049D5  0xB9, 0x0B, 0x00

loc_049D8:                                     ; 049D8
  cmp cl, 6                                    ; 049D8  0x80, 0xF9, 0x06
  je loc_049EF                                 ; 049DB  0x74, 0x12
  cmp cl, 4                                    ; 049DD  0x80, 0xF9, 0x04
  je loc_049EF                                 ; 049E0  0x74, 0x0D
  shl bx, 1                                    ; 049E2  0xD1, 0xE3
  rcl dl, 1                                    ; 049E4  0xD0, 0xD2
  test cl, 1                                   ; 049E6  0xF6, 0xC1, 0x01
  jne loc_049EF                                ; 049E9  0x75, 0x04
  shl bx, 1                                    ; 049EB  0xD1, 0xE3
  rcl dl, 1                                    ; 049ED  0xD0, 0xD2

loc_049EF:                                     ; 049EF
  lodsb                                        ; 049EF  0xAC
  and al, 0x7f                                 ; 049F0  0x24, 0x7F
  sub al, 0x20                                 ; 049F2  0x2C, 0x20
  ror al, 1                                    ; 049F4  0xD0, 0xC8
  jae loc_049FA                                ; 049F6  0x73, 0x02
  rol al, 1                                    ; 049F8  0xD0, 0xC0

loc_049FA:                                     ; 049FA
  xor_ah_ah                                    ; 049FA  xor ah, ah
  add_bx_ax                                    ; 049FC  add bx, ax
  adc dl, 0                                    ; 049FE  0x80, 0xD2, 0x00
  loop loc_049D8                               ; 04A01  0xE2, 0xD5
  mov [0x84c], bx                              ; 04A03  0x89, 0x1E, 0x4C, 0x08
  mov bx, 0x84b                                ; 04A07  0xBB, 0x4B, 0x08
  and dl, 3                                    ; 04A0A  0x80, 0xE2, 0x03
  ror dl, 1                                    ; 04A0D  0xD0, 0xCA
  ror dl, 1                                    ; 04A0F  0xD0, 0xCA
  or [bx], dl                                  ; 04A11  0x08, 0x17
  lodsb                                        ; 04A13  0xAC
  and al, 0x1f                                 ; 04A14  0x24, 0x1F
  inc si                                       ; 04A16  0x46
  mov ah, [si]                                 ; 04A17  0x8A, 0x24
  and ah, 0x3f                                 ; 04A19  0x80, 0xE4, 0x3F
  mov cl, 3                                    ; 04A1C  0xB1, 0x03
  shl al, cl                                   ; 04A1E  0xD2, 0xE0
  shr ax, cl                                   ; 04A20  0xD3, 0xE8
  mov dl, [0x8a7]                              ; 04A22  0x8A, 0x16, 0xA7, 0x08
  shl ax, 1                                    ; 04A26  0xD1, 0xE0

loc_04A28:                                     ; 04A28
  shr ax, 1                                    ; 04A28  0xD1, 0xE8
  shr dl, 1                                    ; 04A2A  0xD0, 0xEA
  jb loc_04A28                                 ; 04A2C  0x72, 0xFA
  and ah, 1                                    ; 04A2E  0x80, 0xE4, 0x01
  ror ah, cl                                   ; 04A31  0xD2, 0xCC
  or [bx], ah                                  ; 04A33  0x08, 0x27
  mov [bx + 3], al                             ; 04A35  0x88, 0x47, 0x03

loc_04A38:                                     ; 04A38
  ret                                          ; 04A38  0xC3

sub_04A39:                                     ; 04A39
  cmp word [0x897], 0                          ; 04A39  0x83, 0x3E, 0x97, 0x08, 0x00
  je loc_04A38                                 ; 04A3E  0x74, 0xF8
  mov al, [0x86b]                              ; 04A40  0xA0, 0x6B, 0x08
  or_al_al                                     ; 04A43  or al, al
  je loc_04A38                                 ; 04A45  0x74, 0xF1
  cmp byte [0x84f], 0xff                       ; 04A47  0x80, 0x3E, 0x4F, 0x08, 0xFF
  je loc_04A38                                 ; 04A4C  0x74, 0xEA
  mov bx, [0x887]                              ; 04A4E  0x8B, 0x1E, 0x87, 0x08
  mov cx, [bx]                                 ; 04A52  0x8B, 0x0F
  dec al                                       ; 04A54  0xFE, 0xC8
  jne loc_04A5C                                ; 04A56  0x75, 0x04
  mov cx, [0x8aa]                              ; 04A58  0x8B, 0x0E, 0xAA, 0x08

loc_04A5C:                                     ; 04A5C
  mov bx, [0x870]                              ; 04A5C  0x8B, 0x1E, 0x70, 0x08
  sub_cx_bx                                    ; 04A60  sub cx, bx
  je loc_04A38                                 ; 04A62  0x74, 0xD4
  mov es, [0x897]                              ; 04A64  0x8E, 0x06, 0x97, 0x08
  inc bx                                       ; 04A68  0x43
  mov_di_bx                                    ; 04A69  mov di, bx
  shl di, 1                                    ; 04A6B  0xD1, 0xE7
  shl di, 1                                    ; 04A6D  0xD1, 0xE7
  sub di, 4                                    ; 04A6F  0x83, 0xEF, 0x04
  call sub_04A7A                               ; 04A72  0xE8, 0x05, 0x00
  mov ax, ds                                   ; 04A75  0x8C, 0xD8
  mov es, ax                                   ; 04A77  0x8E, 0xC0
  ret                                          ; 04A79  0xC3

sub_04A7A:                                     ; 04A7A
  add di, 4                                    ; 04A7A  0x83, 0xC7, 0x04
  mov si, 0x84b                                ; 04A7D  0xBE, 0x4B, 0x08
  lodsb                                        ; 04A80  0xAC
  xor al, [es:di]                              ; 04A81  0x26, 0x32, 0x05
  mov_dl_al                                    ; 04A84  mov dl, al
  and al, 0x1f                                 ; 04A86  0x24, 0x1F
  jne loc_04AA8                                ; 04A88  0x75, 0x1E
  call sub_04B0C                               ; 04A8A  0xE8, 0x7F, 0x00
  je loc_04AE9                                 ; 04A8D  0x74, 0x5A

loc_04A8F:                                     ; 04A8F
  inc bx                                       ; 04A8F  0x43
  loop sub_04A7A                               ; 04A90  0xE2, 0xE8
  cmp word [0x870], -1                         ; 04A92  0x83, 0x3E, 0x70, 0x08, 0xFF
  jne loc_04AA7                                ; 04A97  0x75, 0x0E
  mov ax, ds                                   ; 04A99  0x8C, 0xD8
  mov es, ax                                   ; 04A9B  0x8E, 0xC0
  call sub_042CA                               ; 04A9D  0xE8, 0x2A, 0xF8
  jne loc_04AA7                                ; 04AA0  0x75, 0x05
  mov byte [0x84f], 0xff                       ; 04AA2  0xC6, 0x06, 0x4F, 0x08, 0xFF

loc_04AA7:                                     ; 04AA7
  ret                                          ; 04AA7  0xC3

loc_04AA8:                                     ; 04AA8
  mov al, [0x816]                              ; 04AA8  0xA0, 0x16, 0x08
  inc al                                       ; 04AAB  0xFE, 0xC0
  jne loc_04AB7                                ; 04AAD  0x75, 0x08
  cmp byte [es:di], 0xf5                       ; 04AAF  0x26, 0x80, 0x3D, 0xF5
  jne loc_04A8F                                ; 04AB3  0x75, 0xDA
  jmp short loc_04AD2                          ; 04AB5  0xEB, 0x1B

loc_04AB7:                                     ; 04AB7
  inc al                                       ; 04AB7  0xFE, 0xC0
  jne loc_04A8F                                ; 04AB9  0x75, 0xD4
  call sub_04B0C                               ; 04ABB  0xE8, 0x4E, 0x00
  jne loc_04A8F                                ; 04ABE  0x75, 0xCF
  mov al, [0x814]                              ; 04AC0  0xA0, 0x14, 0x08
  inc al                                       ; 04AC3  0xFE, 0xC0
  jne loc_04AD8                                ; 04AC5  0x75, 0x11
  test byte [es:di], 0x10                      ; 04AC7  0x26, 0xF6, 0x05, 0x10
  je loc_04A8F                                 ; 04ACB  0x74, 0xC2
  test dl, 0xf                                 ; 04ACD  0xF6, 0xC2, 0x0F
  jne loc_04A8F                                ; 04AD0  0x75, 0xBD

loc_04AD2:                                     ; 04AD2
  mov [0x815], bx                              ; 04AD2  0x89, 0x1E, 0x15, 0x08
  jmp short loc_04A8F                          ; 04AD6  0xEB, 0xB7

loc_04AD8:                                     ; 04AD8
  inc al                                       ; 04AD8  0xFE, 0xC0
  jne loc_04AE3                                ; 04ADA  0x75, 0x07
  test dl, 0xf                                 ; 04ADC  0xF6, 0xC2, 0x0F
  jne loc_04A8F                                ; 04ADF  0x75, 0xAE
  jmp short loc_04AE9                          ; 04AE1  0xEB, 0x06

loc_04AE3:                                     ; 04AE3
  test byte [es:di], 0x1f                      ; 04AE3  0x26, 0xF6, 0x05, 0x1F
  jne loc_04A8F                                ; 04AE7  0x75, 0xA6

loc_04AE9:                                     ; 04AE9
  mov dx, [0x870]                              ; 04AE9  0x8B, 0x16, 0x70, 0x08
  dec bx                                       ; 04AED  0x4B
  mov [0x870], bx                              ; 04AEE  0x89, 0x1E, 0x70, 0x08
  mov_al_bl                                    ; 04AF2  mov al, bl
  and al, 3                                    ; 04AF4  0x24, 0x03
  cmp al, 3                                    ; 04AF6  0x3C, 0x03
  je loc_04B28                                 ; 04AF8  0x74, 0x2E
  and bl, 0xfc                                 ; 04AFA  0x80, 0xE3, 0xFC
  and dl, 0xfc                                 ; 04AFD  0x80, 0xE2, 0xFC
  cmp_bx_dx                                    ; 04B00  cmp bx, dx
  je loc_04B28                                 ; 04B02  0x74, 0x24
  or byte [0x810], 0xf                         ; 04B04  0x80, 0x0E, 0x10, 0x08, 0x0F
  xor_al_al                                    ; 04B09  xor al, al
  ret                                          ; 04B0B  0xC3

sub_04B0C:                                     ; 04B0C
  mov al, [0x84f]                              ; 04B0C  0xA0, 0x4F, 0x08
  or_al_al                                     ; 04B0F  or al, al
  je loc_04B28                                 ; 04B11  0x74, 0x15
  mov ah, 0xe0                                 ; 04B13  0xB4, 0xE0
  cmp al, 3                                    ; 04B15  0x3C, 0x03
  je loc_04B1B                                 ; 04B17  0x74, 0x02
  mov ah, 0xc0                                 ; 04B19  0xB4, 0xC0

loc_04B1B:                                     ; 04B1B
  test ah, dl                                  ; 04B1B  0x84, 0xD4
  jne loc_04B28                                ; 04B1D  0x75, 0x09
  xor_ah_ah                                    ; 04B1F  xor ah, ah
  xchg cx, ax                                  ; 04B21  0x91
  push di                                      ; 04B22  0x57
  inc di                                       ; 04B23  0x47
  repe cmpsb                                   ; 04B24  0xF3, 0xA6
  xchg cx, ax                                  ; 04B26  0x91
  pop di                                       ; 04B27  0x5F

loc_04B28:                                     ; 04B28
  ret                                          ; 04B28  0xC3

sub_04B29:                                     ; 04B29
  cmp word [0x897], 0                          ; 04B29  0x83, 0x3E, 0x97, 0x08, 0x00
  je loc_04B28                                 ; 04B2E  0x74, 0xF8
  push word [0x84b]                            ; 04B30  0xFF, 0x36, 0x4B, 0x08
  push word [0x84d]                            ; 04B34  0xFF, 0x36, 0x4D, 0x08
  call sub_0424E                               ; 04B38  0xE8, 0x13, 0xF7
  call sub_049C1                               ; 04B3B  0xE8, 0x83, 0xFE
  mov ax, [0x870]                              ; 04B3E  0xA1, 0x70, 0x08
  shl ax, 1                                    ; 04B41  0xD1, 0xE0
  shl ax, 1                                    ; 04B43  0xD1, 0xE0
  mov_di_ax                                    ; 04B45  mov di, ax
  mov es, [0x897]                              ; 04B47  0x8E, 0x06, 0x97, 0x08
  mov si, 0x84b                                ; 04B4B  0xBE, 0x4B, 0x08
  mov cx, 2                                    ; 04B4E  0xB9, 0x02, 0x00
  rep movsw                                    ; 04B51  0xF3, 0xA5
  mov ax, ds                                   ; 04B53  0x8C, 0xD8
  mov es, ax                                   ; 04B55  0x8E, 0xC0
  pop word [0x84d]                             ; 04B57  0x8F, 0x06, 0x4D, 0x08
  pop word [0x84b]                             ; 04B5B  0x8F, 0x06, 0x4B, 0x08
  ret                                          ; 04B5F  0xC3

sub_04B60:                                     ; 04B60
  mov ax, [0x8e7]                              ; 04B60  0xA1, 0xE7, 0x08
  xchg [0x8e9], ax                             ; 04B63  0x87, 0x06, 0xE9, 0x08
  mov [0x8e7], ax                              ; 04B67  0xA3, 0xE7, 0x08
  ret                                          ; 04B6A  0xC3

sub_04B6B:                                     ; 04B6B
  cmp byte [0x816], 0xff                       ; 04B6B  0x80, 0x3E, 0x16, 0x08, 0xFF
  jne loc_04B28                                ; 04B70  0x75, 0xB6

sub_04B72:                                     ; 04B72
  mov ax, [0x870]                              ; 04B72  0xA1, 0x70, 0x08
  mov [0x815], ax                              ; 04B75  0xA3, 0x15, 0x08
  ret                                          ; 04B78  0xC3

sub_04B79:                                     ; 04B79
  mov bx, 0xb00                                ; 04B79  0xBB, 0x00, 0x0B
  mov [0x864], bx                              ; 04B7C  0x89, 0x1E, 0x64, 0x08

sub_04B80:                                     ; 04B80
  mov byte [0x8ed], 0xff                       ; 04B80  0xC6, 0x06, 0xED, 0x08, 0xFF
  mov [0x86b], cl                              ; 04B85  0x88, 0x0E, 0x6B, 0x08
  call sub_04987                               ; 04B89  0xE8, 0xFB, 0xFD
  ret                                          ; 04B8C  0xC3

sub_04B8D:                                     ; 04B8D
  xor_ax_ax                                    ; 04B8D  xor ax, ax
  mov [0xb0c], al                              ; 04B8F  0xA2, 0x0C, 0x0B
  mov [0xb0e], al                              ; 04B92  0xA2, 0x0E, 0x0B

sub_04B95:                                     ; 04B95
  mov cl, 0xf                                  ; 04B95  0xB1, 0x0F
  jmp short sub_04B9B                          ; 04B97  0xEB, 0x02

sub_04B99:                                     ; 04B99
  mov cl, 0xc                                  ; 04B99  0xB1, 0x0C

sub_04B9B:                                     ; 04B9B
  call sub_04B79                               ; 04B9B  0xE8, 0xDB, 0xFF

sub_04B9E:                                     ; 04B9E
  call sub_042A5                               ; 04B9E  0xE8, 0x04, 0xF7

sub_04BA1:                                     ; 04BA1
  xor_al_al                                    ; 04BA1  xor al, al
  xchg [0x901], al                             ; 04BA3  0x86, 0x06, 0x01, 0x09
  test al, al                                  ; 04BA7  0x84, 0xC0
  je loc_04BAE                                 ; 04BA9  0x74, 0x03
  call sub_04B60                               ; 04BAB  0xE8, 0xB2, 0xFF

loc_04BAE:                                     ; 04BAE
  call sub_04A39                               ; 04BAE  0xE8, 0x88, 0xFE
  jne loc_04BFF                                ; 04BB1  0x75, 0x4C
  mov cl, 0                                    ; 04BB3  0xB1, 0x00
  call sub_04720                               ; 04BB5  0xE8, 0x68, 0xFB
  call sub_0429E                               ; 04BB8  0xE8, 0xE3, 0xF6
  je loc_04BFF                                 ; 04BBB  0x74, 0x42
  mov dx, [0x864]                              ; 04BBD  0x8B, 0x16, 0x64, 0x08
  mov_si_dx                                    ; 04BC1  mov si, dx
  lodsb                                        ; 04BC3  0xAC
  cmp al, 0xe5                                 ; 04BC4  0x3C, 0xE5
  je loc_04BCF                                 ; 04BC6  0x74, 0x07
  push dx                                      ; 04BC8  0x52
  call sub_042B6                               ; 04BC9  0xE8, 0xEA, 0xF6
  pop dx                                       ; 04BCC  0x5A
  jae loc_04BFF                                ; 04BCD  0x73, 0x30

loc_04BCF:                                     ; 04BCF
  call sub_0424E                               ; 04BCF  0xE8, 0x7C, 0xF6
  mov cl, [0x86b]                              ; 04BD2  0x8A, 0x0E, 0x6B, 0x08
  xor_ch_ch                                    ; 04BD6  xor ch, ch
  cmp byte [bx], 0xe5                          ; 04BD8  0x80, 0x3F, 0xE5
  jne loc_04BE0                                ; 04BDB  0x75, 0x03
  call sub_04B6B                               ; 04BDD  0xE8, 0x8B, 0xFF

loc_04BE0:                                     ; 04BE0
  mov byte [0x8c9], 0                          ; 04BE0  0xC6, 0x06, 0xC9, 0x08, 0x00
  mov al, [bx]                                 ; 04BE5  0x8A, 0x07
  and al, 0xef                                 ; 04BE7  0x24, 0xEF
  cmp al, [bx]                                 ; 04BE9  0x3A, 0x07
  je loc_04C0E                                 ; 04BEB  0x74, 0x21
  mov_si_dx                                    ; 04BED  mov si, dx
  cmp al, [si]                                 ; 04BEF  0x3A, 0x04
  jne loc_04C0E                                ; 04BF1  0x75, 0x1B
  mov al, [0x814]                              ; 04BF3  0xA0, 0x14, 0x08
  or_al_al                                     ; 04BF6  or al, al
  je sub_04BA1                                 ; 04BF8  0x74, 0xA7
  mov [0x8c9], al                              ; 04BFA  0xA2, 0xC9, 0x08
  jmp short loc_04C67                          ; 04BFD  0xEB, 0x68

loc_04BFF:                                     ; 04BFF
  call sub_04B6B                               ; 04BFF  0xE8, 0x69, 0xFF
  call sub_042A5                               ; 04C02  0xE8, 0xA0, 0xF6

sub_04C05:                                     ; 04C05
  mov al, 0xff                                 ; 04C05  0xB0, 0xFF
  mov_ch_al                                    ; 04C07  mov ch, al
  inc ch                                       ; 04C09  0xFE, 0xC5
  jmp near loc_03FD1                           ; 04C0B  0xE9, 0xC3, 0xF3

loc_04C0E:                                     ; 04C0E
  or_cl_cl                                     ; 04C0E  or cl, cl
  je loc_04C6F                                 ; 04C10  0x74, 0x5D
  mov_si_dx                                    ; 04C12  mov si, dx
  lodsb                                        ; 04C14  0xAC
  cmp ch, 0xe                                  ; 04C15  0x80, 0xFD, 0x0E
  jne loc_04C1E                                ; 04C18  0x75, 0x04
  and al, 0x3f                                 ; 04C1A  0x24, 0x3F
  jmp short loc_04C2E                          ; 04C1C  0xEB, 0x10

loc_04C1E:                                     ; 04C1E
  and al, 0x7f                                 ; 04C1E  0x24, 0x7F
  cmp al, 0x3f                                 ; 04C20  0x3C, 0x3F
  je loc_04C67                                 ; 04C22  0x74, 0x43
  cmp ch, 0xd                                  ; 04C24  0x80, 0xFD, 0x0D
  je loc_04C67                                 ; 04C27  0x74, 0x3E
  cmp ch, 0xc                                  ; 04C29  0x80, 0xFD, 0x0C
  je loc_04C36                                 ; 04C2C  0x74, 0x08

loc_04C2E:                                     ; 04C2E
  sub al, [bx]                                 ; 04C2E  0x2A, 0x07
  and al, 0x7f                                 ; 04C30  0x24, 0x7F
  jne loc_04C90                                ; 04C32  0x75, 0x5C
  jmp short loc_04C67                          ; 04C34  0xEB, 0x31

loc_04C36:                                     ; 04C36
  cmp byte [0x8e8], 0xff                       ; 04C36  0x80, 0x3E, 0xE8, 0x08, 0xFF
  jne loc_04C45                                ; 04C3B  0x75, 0x08
  mov si, [0x870]                              ; 04C3D  0x8B, 0x36, 0x70, 0x08
  mov [0x8e7], si                              ; 04C41  0x89, 0x36, 0xE7, 0x08

loc_04C45:                                     ; 04C45
  push cx                                      ; 04C45  0x51
  mov cl, [bx]                                 ; 04C46  0x8A, 0x0F
  call sub_04105                               ; 04C48  0xE8, 0xBA, 0xF4
  pop cx                                       ; 04C4B  0x59
  jne loc_04C80                                ; 04C4C  0x75, 0x32
  test byte [0x901], 0xff                      ; 04C4E  0xF6, 0x06, 0x01, 0x09, 0xFF
  je loc_04C62                                 ; 04C53  0x74, 0x0D
  inc bx                                       ; 04C55  0x43
  inc bx                                       ; 04C56  0x43
  cmp byte [bx], 0                             ; 04C57  0x80, 0x3F, 0x00
  jne loc_04C80                                ; 04C5A  0x75, 0x24
  call sub_04B72                               ; 04C5C  0xE8, 0x13, 0xFF
  jmp near sub_04BA1                           ; 04C5F  0xE9, 0x3F, 0xFF

loc_04C62:                                     ; 04C62
  mov byte [0x812], 0                          ; 04C62  0xC6, 0x06, 0x12, 0x08, 0x00

loc_04C67:                                     ; 04C67
  inc dx                                       ; 04C67  0x42
  inc bx                                       ; 04C68  0x43
  inc ch                                       ; 04C69  0xFE, 0xC5
  dec cl                                       ; 04C6B  0xFE, 0xC9
  jmp short loc_04C0E                          ; 04C6D  0xEB, 0x9F

loc_04C6F:                                     ; 04C6F
  cmp byte [0x8c9], 0xff                       ; 04C6F  0x80, 0x3E, 0xC9, 0x08, 0xFF
  jne loc_04C83                                ; 04C74  0x75, 0x0D
  cmp byte [0x816], 0xfe                       ; 04C76  0x80, 0x3E, 0x16, 0x08, 0xFE
  jne loc_04C80                                ; 04C7B  0x75, 0x03
  call sub_04B72                               ; 04C7D  0xE8, 0xF2, 0xFE

loc_04C80:                                     ; 04C80
  jmp near sub_04BA1                           ; 04C80  0xE9, 0x1E, 0xFF

loc_04C83:                                     ; 04C83
  xor_al_al                                    ; 04C83  xor al, al
  mov [0x8ed], al                              ; 04C85  0xA2, 0xED, 0x08
  mov [0x80d], al                              ; 04C88  0xA2, 0x0D, 0x08
  mov_ch_al                                    ; 04C8B  mov ch, al
  inc ch                                       ; 04C8D  0xFE, 0xC5

loc_04C8F:                                     ; 04C8F
  ret                                          ; 04C8F  0xC3

loc_04C90:                                     ; 04C90
  or ch, [bx]                                  ; 04C90  0x0A, 0x2F
  jne loc_04C80                                ; 04C92  0x75, 0xEC
  test byte [0x812], 0xff                      ; 04C94  0xF6, 0x06, 0x12, 0x08, 0xFF
  je loc_04C80                                 ; 04C99  0x74, 0xE5
  mov byte [0x901], 0xff                       ; 04C9B  0xC6, 0x06, 0x01, 0x09, 0xFF
  call sub_04B60                               ; 04CA0  0xE8, 0xBD, 0xFE
  jmp short loc_04C67                          ; 04CA3  0xEB, 0xC2

sub_04CA5:                                     ; 04CA5
  mov al, 0xff                                 ; 04CA5  0xB0, 0xFF

sub_04CA7:                                     ; 04CA7
  mov [0x814], al                              ; 04CA7  0xA2, 0x14, 0x08
  mov al, 0xfe                                 ; 04CAA  0xB0, 0xFE
  mov [0x816], al                              ; 04CAC  0xA2, 0x16, 0x08

loc_04CAF:                                     ; 04CAF
  ret                                          ; 04CAF  0xC3

sub_04CB0:                                     ; 04CB0
  cmp byte [0x816], 0xfe                       ; 04CB0  0x80, 0x3E, 0x16, 0x08, 0xFE
  je loc_04C8F                                 ; 04CB5  0x74, 0xD8
  call sub_042AC                               ; 04CB7  0xE8, 0xF2, 0xF5
  xor_al_al                                    ; 04CBA  xor al, al
  call sub_04CA7                               ; 04CBC  0xE8, 0xE8, 0xFF
  mov bx, [0x864]                              ; 04CBF  0x8B, 0x1E, 0x64, 0x08
  or byte [bx], 0x10                           ; 04CC3  0x80, 0x0F, 0x10
  mov cl, 0xc                                  ; 04CC6  0xB1, 0x0C
  call sub_04B80                               ; 04CC8  0xE8, 0xB5, 0xFE
  jmp near sub_04BA1                           ; 04CCB  0xE9, 0xD3, 0xFE

sub_04CCE:                                     ; 04CCE
  mov ax, [0x870]                              ; 04CCE  0xA1, 0x70, 0x08
  mov [0x815], ax                              ; 04CD1  0xA3, 0x15, 0x08
  ret                                          ; 04CD4  0xC3

sub_04CD5:                                     ; 04CD5
  call sub_042AC                               ; 04CD5  0xE8, 0xD4, 0xF5
  mov cl, 0xf                                  ; 04CD8  0xB1, 0x0F
  call sub_04B79                               ; 04CDA  0xE8, 0x9C, 0xFE
  jmp near sub_04BA1                           ; 04CDD  0xE9, 0xC1, 0xFE

loc_04CE0:                                     ; 04CE0
  call sub_040A8                               ; 04CE0  0xE8, 0xC5, 0xF3

loc_04CE3:                                     ; 04CE3
  mov al, 0xfe                                 ; 04CE3  0xB0, 0xFE
  call sub_04CA7                               ; 04CE5  0xE8, 0xBF, 0xFF
  call sub_04B99                               ; 04CE8  0xE8, 0xAE, 0xFE
  je loc_04CAF                                 ; 04CEB  0x74, 0xC2

loc_04CED:                                     ; 04CED
  call sub_0424E                               ; 04CED  0xE8, 0x5E, 0xF5
  mov al, [bx]                                 ; 04CF0  0x8A, 0x07
  and al, 0x10                                 ; 04CF2  0x24, 0x10
  jne loc_04D14                                ; 04CF4  0x75, 0x1E
  call sub_05957                               ; 04CF6  0xE8, 0x5E, 0x0C
  test byte [0x8cc], 0x80                      ; 04CF9  0xF6, 0x06, 0xCC, 0x08, 0x80
  jne loc_04D03                                ; 04CFE  0x75, 0x03
  call sub_04261                               ; 04D00  0xE8, 0x5E, 0xF5

loc_04D03:                                     ; 04D03
  call sub_0564E                               ; 04D03  0xE8, 0x48, 0x09
  rol al, 1                                    ; 04D06  0xD0, 0xC0
  jb loc_04D25                                 ; 04D08  0x72, 0x1B
  mov bx, 0xb00                                ; 04D0A  0xBB, 0x00, 0x0B
  call sub_04958                               ; 04D0D  0xE8, 0x48, 0xFC
  je loc_04D25                                 ; 04D10  0x74, 0x13
  jmp short sub_04D32                          ; 04D12  0xEB, 0x1E

loc_04D14:                                     ; 04D14
  call sub_0564E                               ; 04D14  0xE8, 0x37, 0x09
  rol al, 1                                    ; 04D17  0xD0, 0xC0
  jae loc_04D25                                ; 04D19  0x73, 0x0A
  call sub_0577A                               ; 04D1B  0xE8, 0x5C, 0x0A
  je loc_04D25                                 ; 04D1E  0x74, 0x05
  call sub_056A2                               ; 04D20  0xE8, 0x7F, 0x09
  jmp short loc_04CE3                          ; 04D23  0xEB, 0xBE

loc_04D25:                                     ; 04D25
  call sub_04BA1                               ; 04D25  0xE8, 0x79, 0xFE
  jne loc_04CED                                ; 04D28  0x75, 0xC3
  call sub_04B99                               ; 04D2A  0xE8, 0x6C, 0xFE

sub_04D2D:                                     ; 04D2D
  jne sub_04D32                                ; 04D2D  0x75, 0x03
  jmp near loc_04952                           ; 04D2F  0xE9, 0x20, 0xFC

sub_04D32:                                     ; 04D32
  call sub_0424E                               ; 04D32  0xE8, 0x19, 0xF5
  mov al, [bx]                                 ; 04D35  0x8A, 0x07
  and al, 0x10                                 ; 04D37  0x24, 0x10
  jne loc_04D47                                ; 04D39  0x75, 0x0C
  push bx                                      ; 04D3B  0x53
  call sub_0595E                               ; 04D3C  0xE8, 0x1F, 0x0C
  pop bx                                       ; 04D3F  0x5B
  test byte [0x8cc], 0x80                      ; 04D40  0xF6, 0x06, 0xCC, 0x08, 0x80
  jne loc_04D4A                                ; 04D45  0x75, 0x03

loc_04D47:                                     ; 04D47
  mov byte [bx], 0xe5                          ; 04D47  0xC6, 0x07, 0xE5

loc_04D4A:                                     ; 04D4A
  pushf                                        ; 04D4A  0x9C
  call sub_057B3                               ; 04D4B  0xE8, 0x65, 0x0A
  or_al_al                                     ; 04D4E  or al, al
  jne loc_04D54                                ; 04D50  0x75, 0x02
  mov [bx], al                                 ; 04D52  0x88, 0x07

loc_04D54:                                     ; 04D54
  call sub_04746                               ; 04D54  0xE8, 0xEF, 0xF9
  popf                                         ; 04D57  0x9D
  jne loc_04D5F                                ; 04D58  0x75, 0x05
  mov cl, 0                                    ; 04D5A  0xB1, 0x00
  call sub_0487E                               ; 04D5C  0xE8, 0x1F, 0xFB

loc_04D5F:                                     ; 04D5F
  call sub_04B29                               ; 04D5F  0xE8, 0xC7, 0xFD
  call sub_04BA1                               ; 04D62  0xE8, 0x3C, 0xFE
  jmp short sub_04D2D                          ; 04D65  0xEB, 0xC6

sub_04D67:                                     ; 04D67
  mov_dx_cx                                    ; 04D67  mov dx, cx

loc_04D69:                                     ; 04D69
  cmp dx, [0x8a8]                              ; 04D69  0x3B, 0x16, 0xA8, 0x08
  jae loc_04D99                                ; 04D6D  0x73, 0x2A
  inc dx                                       ; 04D6F  0x42
  push cx                                      ; 04D70  0x51
  push dx                                      ; 04D71  0x52
  mov_cx_dx                                    ; 04D72  mov cx, dx
  call sub_047EE                               ; 04D74  0xE8, 0x77, 0xFA
  rcr al, 1                                    ; 04D77  0xD0, 0xD8
  jae loc_04D8F                                ; 04D79  0x73, 0x14
  pop dx                                       ; 04D7B  0x5A
  pop cx                                       ; 04D7C  0x59

loc_04D7D:                                     ; 04D7D
  or_cx_cx                                     ; 04D7D  or cx, cx
  je loc_04D69                                 ; 04D7F  0x74, 0xE8
  dec cx                                       ; 04D81  0x49
  push dx                                      ; 04D82  0x52
  push cx                                      ; 04D83  0x51
  call sub_047EE                               ; 04D84  0xE8, 0x67, 0xFA
  rcr al, 1                                    ; 04D87  0xD0, 0xD8
  jae loc_04D8F                                ; 04D89  0x73, 0x04
  pop cx                                       ; 04D8B  0x59
  pop dx                                       ; 04D8C  0x5A
  jmp short loc_04D69                          ; 04D8D  0xEB, 0xDA

loc_04D8F:                                     ; 04D8F
  rcl al, 1                                    ; 04D8F  0xD0, 0xD0
  inc al                                       ; 04D91  0xFE, 0xC0
  call sub_0480F                               ; 04D93  0xE8, 0x79, 0xFA
  pop bx                                       ; 04D96  0x5B
  pop dx                                       ; 04D97  0x5A
  ret                                          ; 04D98  0xC3

loc_04D99:                                     ; 04D99
  or_cx_cx                                     ; 04D99  or cx, cx
  jne loc_04D7D                                ; 04D9B  0x75, 0xE0
  mov_bx_cx                                    ; 04D9D  mov bx, cx
  ret                                          ; 04D9F  0xC3

sub_04DA0:                                     ; 04DA0
  push dx                                      ; 04DA0  0x52
  mov ch, 0                                    ; 04DA1  0xB5, 0x00
  mov dx, 0xb00                                ; 04DA3  0xBA, 0x00, 0x0B
  add_dx_cx                                    ; 04DA6  add dx, cx
  call sub_0424E                               ; 04DA8  0xE8, 0xA3, 0xF4
  pop cx                                       ; 04DAB  0x59
  ret                                          ; 04DAC  0xC3

sub_04DAD:                                     ; 04DAD
  mov dh, 0x80                                 ; 04DAD  0xB6, 0x80

sub_04DAF:                                     ; 04DAF
  call sub_04DA0                               ; 04DAF  0xE8, 0xEE, 0xFF
  inc cl                                       ; 04DB2  0xFE, 0xC1

loc_04DB4:                                     ; 04DB4
  dec cl                                       ; 04DB4  0xFE, 0xC9
  jne loc_04DBB                                ; 04DB6  0x75, 0x03
  jmp near sub_04746                           ; 04DB8  0xE9, 0x8B, 0xF9

loc_04DBB:                                     ; 04DBB
  mov ah, [bx]                                 ; 04DBB  0x8A, 0x27
  and_ah_ch                                    ; 04DBD  and ah, ch
  mov_si_dx                                    ; 04DBF  mov si, dx
  lodsb                                        ; 04DC1  0xAC
  and al, 0x7f                                 ; 04DC2  0x24, 0x7F
  or_al_ah                                     ; 04DC4  or al, ah
  mov [bx], al                                 ; 04DC6  0x88, 0x07
  inc bx                                       ; 04DC8  0x43
  inc dx                                       ; 04DC9  0x42
  jmp short loc_04DB4                          ; 04DCA  0xEB, 0xE8

sub_04DCC:                                     ; 04DCC
  mov al, [0xb00]                              ; 04DCC  0xA0, 0x00, 0x0B
  mov bx, 0xb10                                ; 04DCF  0xBB, 0x10, 0x0B
  mov [bx], al                                 ; 04DD2  0x88, 0x07
  ret                                          ; 04DD4  0xC3

sub_04DD5:                                     ; 04DD5
  call sub_04B95                               ; 04DD5  0xE8, 0xBD, 0xFD

sub_04DD8:                                     ; 04DD8
  je loc_04E12                                 ; 04DD8  0x74, 0x38

sub_04DDA:                                     ; 04DDA
  call sub_04286                               ; 04DDA  0xE8, 0xA9, 0xF4
  push bx                                      ; 04DDD  0x53
  dec bx                                       ; 04DDE  0x4B
  dec bx                                       ; 04DDF  0x4B
  mov ah, [bx]                                 ; 04DE0  0x8A, 0x27
  push ax                                      ; 04DE2  0x50
  call sub_0424E                               ; 04DE3  0xE8, 0x68, 0xF4
  mov_dx_bx                                    ; 04DE6  mov dx, bx
  mov bx, 0xb00                                ; 04DE8  0xBB, 0x00, 0x0B
  mov cl, 0x20                                 ; 04DEB  0xB1, 0x20
  call sub_04003                               ; 04DED  0xE8, 0x13, 0xF2
  call sub_040C3                               ; 04DF0  0xE8, 0xD0, 0xF2
  mov_cl_al                                    ; 04DF3  mov cl, al
  pop ax                                       ; 04DF5  0x58
  pop bx                                       ; 04DF6  0x5B
  mov [bx], al                                 ; 04DF7  0x88, 0x07
  dec bx                                       ; 04DF9  0x4B
  dec bx                                       ; 04DFA  0x4B
  mov [bx], ah                                 ; 04DFB  0x88, 0x27

sub_04DFD:                                     ; 04DFD
  xor_ch_ch                                    ; 04DFD  xor ch, ch
  mov si, 0xb0f                                ; 04DFF  0xBE, 0x0F, 0x0B
  mov al, [bx]                                 ; 04E02  0x8A, 0x07
  sub_al_cl                                    ; 04E04  sub al, cl
  je loc_04E13                                 ; 04E06  0x74, 0x0B
  mov_al_ch                                    ; 04E08  mov al, ch
  jae loc_04E10                                ; 04E0A  0x73, 0x04
  mov al, 0x80                                 ; 04E0C  0xB0, 0x80
  or al, [si]                                  ; 04E0E  0x0A, 0x04

loc_04E10:                                     ; 04E10
  mov [si], al                                 ; 04E10  0x88, 0x04

loc_04E12:                                     ; 04E12
  ret                                          ; 04E12  0xC3

loc_04E13:                                     ; 04E13
  cmp [si], al                                 ; 04E13  0x38, 0x04
  jne loc_04E12                                ; 04E15  0x75, 0xFB

sub_04E17:                                     ; 04E17
  xor_al_al                                    ; 04E17  xor al, al
  mov [si], al                                 ; 04E19  0x88, 0x04
  cmp [0x8ef], al                              ; 04E1B  0x38, 0x06, 0xEF, 0x08
  je loc_04E12                                 ; 04E1F  0x74, 0xF1
  mov byte [si], 0x80                          ; 04E21  0xC6, 0x04, 0x80
  ret                                          ; 04E24  0xC3

sub_04E25:                                     ; 04E25
  mov al, [0xb0f]                              ; 04E25  0xA0, 0x0F, 0x0B
  cmp al, 0x81                                 ; 04E28  0x3C, 0x81
  jb loc_04E31                                 ; 04E2A  0x72, 0x05
  and al, 0x7f                                 ; 04E2C  0x24, 0x7F
  mov [0xb0f], al                              ; 04E2E  0xA2, 0x0F, 0x0B

loc_04E31:                                     ; 04E31
  ret                                          ; 04E31  0xC3

sub_04E32:                                     ; 04E32
  cmp word [bx], 0                             ; 04E32  0x83, 0x3F, 0x00
  jne loc_04E3C                                ; 04E35  0x75, 0x05
  mov_si_dx                                    ; 04E37  mov si, dx
  lodsw                                        ; 04E39  0xAD
  mov [bx], ax                                 ; 04E3A  0x89, 0x07

loc_04E3C:                                     ; 04E3C
  ret                                          ; 04E3C  0xC3

sub_04E3D:                                     ; 04E3D
  test byte [0x8af], 0x80                      ; 04E3D  0xF6, 0x06, 0xAF, 0x08, 0x80
  jne loc_04E49                                ; 04E42  0x75, 0x05
  mov byte [0x810], 0xf0                       ; 04E44  0xC6, 0x06, 0x10, 0x08, 0xF0

loc_04E49:                                     ; 04E49
  call sub_04B95                               ; 04E49  0xE8, 0x49, 0xFD
  je loc_04E3C                                 ; 04E4C  0x74, 0xEE
  call sub_0424E                               ; 04E4E  0xE8, 0xFD, 0xF3
  add bx, 0x10                                 ; 04E51  0x83, 0xC3, 0x10
  mov_dx_bx                                    ; 04E54  mov dx, bx
  mov bx, 0xb10                                ; 04E56  0xBB, 0x10, 0x0B
  mov cl, 0x10                                 ; 04E59  0xB1, 0x10

loc_04E5B:                                     ; 04E5B
  cmp byte [0x8f0], 0                          ; 04E5B  0x80, 0x3E, 0xF0, 0x08, 0x00
  je loc_04E7D                                 ; 04E60  0x74, 0x1B
  mov al, [bx]                                 ; 04E62  0x8A, 0x07
  or_al_al                                     ; 04E64  or al, al
  mov_si_dx                                    ; 04E66  mov si, dx
  lodsb                                        ; 04E68  0xAC
  jne loc_04E6D                                ; 04E69  0x75, 0x02
  mov [bx], al                                 ; 04E6B  0x88, 0x07

loc_04E6D:                                     ; 04E6D
  or_al_al                                     ; 04E6D  or al, al
  jne loc_04E77                                ; 04E6F  0x75, 0x06
  mov al, [bx]                                 ; 04E71  0x8A, 0x07
  mov_di_dx                                    ; 04E73  mov di, dx
  cld                                          ; 04E75  0xFC
  stosb                                        ; 04E76  0xAA

loc_04E77:                                     ; 04E77
  cmp al, [bx]                                 ; 04E77  0x3A, 0x07
  je loc_04E93                                 ; 04E79  0x74, 0x18
  jmp short loc_04EEB                          ; 04E7B  0xEB, 0x6E

loc_04E7D:                                     ; 04E7D
  call sub_04E32                               ; 04E7D  0xE8, 0xB2, 0xFF
  xchg bx, dx                                  ; 04E80  87 DA
  call sub_04E32                               ; 04E82  0xE8, 0xAD, 0xFF
  xchg bx, dx                                  ; 04E85  87 DA
  mov_si_dx                                    ; 04E87  mov si, dx
  mov ax, [si]                                 ; 04E89  0x8B, 0x04
  cmp ax, [bx]                                 ; 04E8B  0x3B, 0x07
  jne loc_04EEB                                ; 04E8D  0x75, 0x5C
  inc dx                                       ; 04E8F  0x42
  inc bx                                       ; 04E90  0x43
  dec cl                                       ; 04E91  0xFE, 0xC9

loc_04E93:                                     ; 04E93
  inc dx                                       ; 04E93  0x42
  inc bx                                       ; 04E94  0x43
  dec cl                                       ; 04E95  0xFE, 0xC9
  jne loc_04E5B                                ; 04E97  0x75, 0xC2
  mov_bx_dx                                    ; 04E99  mov bx, dx
  sub bx, 0x14                                 ; 04E9B  0x83, 0xEB, 0x14
  push bx                                      ; 04E9E  0x53
  call sub_040C3                               ; 04E9F  0xE8, 0x21, 0xF2
  pop si                                       ; 04EA2  0x5E
  mov cl, [si]                                 ; 04EA3  0x8A, 0x0C
  mov ch, [bx]                                 ; 04EA5  0x8A, 0x2F
  mov [si], al                                 ; 04EA7  0x88, 0x04
  mov [bx], al                                 ; 04EA9  0x88, 0x07
  add si, 3                                    ; 04EAB  0x83, 0xC6, 0x03
  add bx, 3                                    ; 04EAE  0x83, 0xC3, 0x03
  cmp_al_cl                                    ; 04EB1  cmp al, cl
  jne loc_04EC6                                ; 04EB3  0x75, 0x11
  cmp_al_ch                                    ; 04EB5  cmp al, ch
  jne loc_04EC8                                ; 04EB7  0x75, 0x0F
  mov al, [si]                                 ; 04EB9  0x8A, 0x04
  cmp al, [bx]                                 ; 04EBB  0x3A, 0x07
  jb loc_04EC6                                 ; 04EBD  0x72, 0x07
  or_al_al                                     ; 04EBF  or al, al
  jne loc_04EC8                                ; 04EC1  0x75, 0x05
  call sub_04E17                               ; 04EC3  0xE8, 0x51, 0xFF

loc_04EC6:                                     ; 04EC6
  xchg bx, si                                  ; 04EC6  87 DE

loc_04EC8:                                     ; 04EC8
  mov al, [si]                                 ; 04EC8  0x8A, 0x04
  mov [bx], al                                 ; 04ECA  0x88, 0x07
  test byte [0x8d9], 0xff                      ; 04ECC  0xF6, 0x06, 0xD9, 0x08, 0xFF
  je loc_04ED4                                 ; 04ED1  0x74, 0x01
  ret                                          ; 04ED3  0xC3

loc_04ED4:                                     ; 04ED4
  call sub_0424E                               ; 04ED4  0xE8, 0x77, 0xF3
  add bx, 0xb                                  ; 04ED7  0x83, 0xC3, 0x0B
  mov al, [bx]                                 ; 04EDA  0x8A, 0x07
  and al, 0x7f                                 ; 04EDC  0x24, 0x7F
  mov [bx], al                                 ; 04EDE  0x88, 0x07
  call sub_04286                               ; 04EE0  0xE8, 0xA3, 0xF3
  mov cl, 1                                    ; 04EE3  0xB1, 0x01
  call sub_04883                               ; 04EE5  0xE8, 0x9B, 0xF9
  jmp near sub_04746                           ; 04EE8  0xE9, 0x5B, 0xF8

loc_04EEB:                                     ; 04EEB
  call sub_04286                               ; 04EEB  0xE8, 0x98, 0xF3
  mov word [bx + 2], 0xffff                    ; 04EEE  0xC7, 0x47, 0x02, 0xFF, 0xFF
  jmp near sub_04C05                           ; 04EF3  0xE9, 0x0F, 0xFD

sub_04EF6:                                     ; 04EF6
  xor_ax_ax                                    ; 04EF6  xor ax, ax
  mov [0x80d], al                              ; 04EF8  0xA2, 0x0D, 0x08
  mov [0x8d9], al                              ; 04EFB  0xA2, 0xD9, 0x08
  call sub_0423F                               ; 04EFE  0xE8, 0x3E, 0xF3
  jne loc_04F57                                ; 04F01  0x75, 0x54
  mov al, [0xb0e]                              ; 04F03  0xA0, 0x0E, 0x0B
  and al, 0x80                                 ; 04F06  0x24, 0x80
  jne loc_04F57                                ; 04F08  0x75, 0x4D

sub_04F0A:                                     ; 04F0A
  call sub_0428E                               ; 04F0A  0xE8, 0x81, 0xF3
  je loc_04EEB                                 ; 04F0D  0x74, 0xDC
  mov byte [0x811], 0xff                       ; 04F0F  0xC6, 0x06, 0x11, 0x08, 0xFF
  call sub_040C3                               ; 04F14  0xE8, 0xAC, 0xF1
  mov_cl_al                                    ; 04F17  mov cl, al
  mov ch, [bx]                                 ; 04F19  0x8A, 0x2F
  push cx                                      ; 04F1B  0x51
  mov [bx], al                                 ; 04F1C  0x88, 0x07
  call sub_04E25                               ; 04F1E  0xE8, 0x04, 0xFF
  cmp_cl_ch                                    ; 04F21  cmp cl, ch
  jae loc_04F28                                ; 04F23  0x73, 0x03
  call sub_04DFD                               ; 04F25  0xE8, 0xD5, 0xFE

loc_04F28:                                     ; 04F28
  call sub_04E3D                               ; 04F28  0xE8, 0x12, 0xFF
  mov bx, 0xb0c                                ; 04F2B  0xBB, 0x0C, 0x0B
  pop cx                                       ; 04F2E  0x59
  mov cl, [bx]                                 ; 04F2F  0x8A, 0x0F
  mov [bx], ch                                 ; 04F31  0x88, 0x2F
  jmp near sub_04DFD                           ; 04F33  0xE9, 0xC7, 0xFE

sub_04F36:                                     ; 04F36
  cmp word [0x815], -1                         ; 04F36  0x83, 0x3E, 0x15, 0x08, 0xFF
  je loc_04F40                                 ; 04F3B  0x74, 0x03
  call sub_042AC                               ; 04F3D  0xE8, 0x6C, 0xF3

loc_04F40:                                     ; 04F40
  push word [0xb00]                            ; 04F40  0xFF, 0x36, 0x00, 0x0B
  mov byte [0xb00], 0xe5                       ; 04F44  0xC6, 0x06, 0x00, 0x0B, 0xE5
  mov cl, 1                                    ; 04F49  0xB1, 0x01
  call sub_04B79                               ; 04F4B  0xE8, 0x2B, 0xFC
  call sub_04BA1                               ; 04F4E  0xE8, 0x50, 0xFC
  pop word [0xb00]                             ; 04F51  0x8F, 0x06, 0x00, 0x0B
  jne loc_04F58                                ; 04F55  0x75, 0x01

loc_04F57:                                     ; 04F57
  ret                                          ; 04F57  0xC3

loc_04F58:                                     ; 04F58
  test byte [0x813], 0xff                      ; 04F58  0xF6, 0x06, 0x13, 0x08, 0xFF
  jne loc_04F57                                ; 04F5D  0x75, 0xF8
  mov bx, 0xb0d                                ; 04F5F  0xBB, 0x0D, 0x0B
  mov byte [bx], 0                             ; 04F62  0xC6, 0x07, 0x00
  inc bx                                       ; 04F65  0x43
  mov al, [bx]                                 ; 04F66  0x8A, 0x07
  push ax                                      ; 04F68  0x50
  push bx                                      ; 04F69  0x53
  and byte [bx], 0x3f                          ; 04F6A  0x80, 0x27, 0x3F
  inc bx                                       ; 04F6D  0x43
  mov cx, 0x11                                 ; 04F6E  0xB9, 0x11, 0x00
  mov al, 1                                    ; 04F71  0xB0, 0x01

loc_04F73:                                     ; 04F73
  mov byte [bx], 0                             ; 04F73  0xC6, 0x07, 0x00
  inc bx                                       ; 04F76  0x43
  loop loc_04F73                               ; 04F77  0xE2, 0xFA
  dec al                                       ; 04F79  0xFE, 0xC8
  jne loc_04F87                                ; 04F7B  0x75, 0x0A
  call sub_057B5                               ; 04F7D  0xE8, 0x35, 0x08
  or_al_al                                     ; 04F80  or al, al
  mov cx, 0xa                                  ; 04F82  0xB9, 0x0A, 0x00
  je loc_04F73                                 ; 04F85  0x74, 0xEC

loc_04F87:                                     ; 04F87
  call sub_042C1                               ; 04F87  0xE8, 0x37, 0xF3
  mov cl, 0                                    ; 04F8A  0xB1, 0x00

loc_04F8C:                                     ; 04F8C
  mov dx, 0x20                                 ; 04F8C  0xBA, 0x20, 0x00
  call sub_04DAF                               ; 04F8F  0xE8, 0x1D, 0xFE
  pop bx                                       ; 04F92  0x5B
  pop ax                                       ; 04F93  0x58
  mov [bx], al                                 ; 04F94  0x88, 0x07
  mov byte [0x8c8], 0                          ; 04F96  0xC6, 0x06, 0xC8, 0x08, 0x00
  call sub_04B29                               ; 04F9B  0xE8, 0x8B, 0xFB
  jmp near sub_04286                           ; 04F9E  0xE9, 0xE5, 0xF2

sub_04FA1:                                     ; 04FA1
  mov al, [0xb0e]                              ; 04FA1  0xA0, 0x0E, 0x0B
  mov [0x8ca], al                              ; 04FA4  0xA2, 0xCA, 0x08
  mov bx, 0xb0c                                ; 04FA7  0xBB, 0x0C, 0x0B
  mov al, [bx]                                 ; 04FAA  0x8A, 0x07
  mov_cl_al                                    ; 04FAC  mov cl, al
  inc cl                                       ; 04FAE  0xFE, 0xC1
  call sub_04105                               ; 04FB0  0xE8, 0x52, 0xF1
  jne loc_04FB8                                ; 04FB3  0x75, 0x03
  jmp near loc_05027                           ; 04FB5  0xE9, 0x6F, 0x00

loc_04FB8:                                     ; 04FB8
  push bx                                      ; 04FB8  0x53
  push cx                                      ; 04FB9  0x51
  call sub_04EF6                               ; 04FBA  0xE8, 0x39, 0xFF
  pop cx                                       ; 04FBD  0x59
  pop bx                                       ; 04FBE  0x5B
  cmp byte [0x80d], 0xff                       ; 04FBF  0x80, 0x3E, 0x0D, 0x08, 0xFF
  jne loc_04FC7                                ; 04FC4  0x75, 0x01
  ret                                          ; 04FC6  0xC3

loc_04FC7:                                     ; 04FC7
  mov al, 0x1f                                 ; 04FC7  0xB0, 0x1F
  and_al_cl                                    ; 04FC9  and al, cl
  mov [bx], al                                 ; 04FCB  0x88, 0x07
  jne loc_04FDA                                ; 04FCD  0x75, 0x0B
  add bx, 2                                    ; 04FCF  0x83, 0xC3, 0x02
  inc byte [bx]                                ; 04FD2  0xFE, 0x07
  mov al, [bx]                                 ; 04FD4  0x8A, 0x07
  and al, 0x3f                                 ; 04FD6  0x24, 0x3F
  je loc_0500E                                 ; 04FD8  0x74, 0x34

loc_04FDA:                                     ; 04FDA
  mov word [0x815], 0xffff                     ; 04FDA  0xC7, 0x06, 0x15, 0x08, 0xFF, 0xFF
  mov byte [0x8e8], 0xff                       ; 04FE0  0xC6, 0x06, 0xE8, 0x08, 0xFF
  call sub_04B95                               ; 04FE5  0xE8, 0xAD, 0xFB
  jne loc_04FFB                                ; 04FE8  0x75, 0x11
  mov al, [0x8eb]                              ; 04FEA  0xA0, 0xEB, 0x08
  inc al                                       ; 04FED  0xFE, 0xC0
  je loc_0500E                                 ; 04FEF  0x74, 0x1D
  call sub_04F36                               ; 04FF1  0xE8, 0x42, 0xFF
  je loc_0500E                                 ; 04FF4  0x74, 0x18
  call sub_05E40                               ; 04FF6  0xE8, 0x47, 0x0E
  jmp short loc_04FFE                          ; 04FF9  0xEB, 0x03

loc_04FFB:                                     ; 04FFB
  call sub_04DDA                               ; 04FFB  0xE8, 0xDC, 0xFD

loc_04FFE:                                     ; 04FFE
  mov byte [0x811], 0xff                       ; 04FFE  0xC6, 0x06, 0x11, 0x08, 0xFF

loc_05003:                                     ; 05003
  call sub_04116                               ; 05003  0xE8, 0x10, 0xF1
  xor_al_al                                    ; 05006  xor al, al
  mov [0x8f3], al                              ; 05008  0xA2, 0xF3, 0x08
  jmp near loc_03FD1                           ; 0500B  0xE9, 0xC3, 0xEF

loc_0500E:                                     ; 0500E
  mov bx, 0xb0c                                ; 0500E  0xBB, 0x0C, 0x0B
  mov al, [0x8ca]                              ; 05011  0xA0, 0xCA, 0x08
  mov [bx + 2], al                             ; 05014  0x88, 0x47, 0x02
  mov al, [bx]                                 ; 05017  0x8A, 0x07
  dec al                                       ; 05019  0xFE, 0xC8
  and al, 0x1f                                 ; 0501B  0x24, 0x1F
  mov [bx], al                                 ; 0501D  0x88, 0x07
  mov byte [0x811], 0xff                       ; 0501F  0xC6, 0x06, 0x11, 0x08, 0xFF
  jmp near loc_03FCF                           ; 05024  0xE9, 0xA8, 0xEF

loc_05027:                                     ; 05027
  mov [bx], cl                                 ; 05027  0x88, 0x0F
  call sub_040C3                               ; 05029  0xE8, 0x97, 0xF0
  mov_cl_al                                    ; 0502C  mov cl, al
  test byte [0x87f], 0x80                      ; 0502E  0xF6, 0x06, 0x7F, 0x08, 0x80
  jne loc_05047                                ; 05033  0x75, 0x12
  cmp al, [bx]                                 ; 05035  0x3A, 0x07
  jae loc_05047                                ; 05037  0x73, 0x0E
  dec byte [bx]                                ; 05039  0xFE, 0x0F
  cmp byte [0x8eb], 0xff                       ; 0503B  0x80, 0x3E, 0xEB, 0x08, 0xFF
  jne loc_05045                                ; 05040  0x75, 0x03
  jmp near loc_03FCF                           ; 05042  0xE9, 0x8A, 0xEF

loc_05045:                                     ; 05045
  inc byte [bx]                                ; 05045  0xFE, 0x07

loc_05047:                                     ; 05047
  call sub_04E25                               ; 05047  0xE8, 0xDB, 0xFD
  call sub_04DFD                               ; 0504A  0xE8, 0xB0, 0xFD
  jmp short loc_05003                          ; 0504D  0xEB, 0xB4

sub_0504F:                                     ; 0504F
  mov al, [0xb21]                              ; 0504F  0xA0, 0x21, 0x0B
  mov_dl_al                                    ; 05052  mov dl, al
  and dl, 0x7f                                 ; 05054  0x80, 0xE2, 0x7F
  rcl al, 1                                    ; 05057  0xD0, 0xD0
  mov al, [0xb22]                              ; 05059  0xA0, 0x22, 0x0B
  mov_ch_al                                    ; 0505C  mov ch, al
  rcl ch, 1                                    ; 0505E  0xD0, 0xD5
  and ch, 0x1f                                 ; 05060  0x80, 0xE5, 0x1F
  and al, 0xf0                                 ; 05063  0x24, 0xF0
  or al, [0xb23]                               ; 05065  0x0A, 0x06, 0x23, 0x0B
  mov cl, 4                                    ; 05069  0xB1, 0x04
  rol al, cl                                   ; 0506B  0xD2, 0xC0
  mov_cl_ch                                    ; 0506D  mov cl, ch
  mov_ch_al                                    ; 0506F  mov ch, al
  ret                                          ; 05071  0xC3

sub_05072:                                     ; 05072
  push cx                                      ; 05072  0x51
  call sub_0504F                               ; 05073  0xE8, 0xD9, 0xFF
  cmp byte [0xb23], 3                          ; 05076  0x80, 0x3E, 0x23, 0x0B, 0x03
  mov bl, 6                                    ; 0507B  0xB3, 0x06
  jbe loc_05082                                ; 0507D  0x76, 0x03
  jmp near loc_05138                           ; 0507F  0xE9, 0xB6, 0x00

loc_05082:                                     ; 05082
  mov [0xb20], dl                              ; 05082  0x88, 0x16, 0x20, 0x0B
  cmp byte [0x85b], 0x25                       ; 05086  0x80, 0x3E, 0x5B, 0x08, 0x25
  je loc_050E3                                 ; 0508B  0x74, 0x56
  call sub_0428E                               ; 0508D  0xE8, 0xFE, 0xF1
  je loc_050E3                                 ; 05090  0x74, 0x51
  mov_al_ch                                    ; 05092  mov al, ch
  sub al, [0xb0e]                              ; 05094  0x2A, 0x06, 0x0E, 0x0B
  and al, 0x3f                                 ; 05098  0x24, 0x3F
  jne loc_050D5                                ; 0509A  0x75, 0x39
  mov al, [0xb0c]                              ; 0509C  0xA0, 0x0C, 0x0B
  cmp_al_cl                                    ; 0509F  cmp al, cl
  jne loc_050A6                                ; 050A1  0x75, 0x03
  jmp near loc_0512A                           ; 050A3  0xE9, 0x84, 0x00

loc_050A6:                                     ; 050A6
  call sub_04105                               ; 050A6  0xE8, 0x5C, 0xF0
  jne loc_050D5                                ; 050A9  0x75, 0x2A
  push cx                                      ; 050AB  0x51
  call sub_040C3                               ; 050AC  0xE8, 0x14, 0xF0
  pop cx                                       ; 050AF  0x59
  cmp_al_cl                                    ; 050B0  cmp al, cl
  jae loc_050C7                                ; 050B2  0x73, 0x13
  test byte [0x87f], 0x80                      ; 050B4  0xF6, 0x06, 0x7F, 0x08, 0x80
  jne loc_050C7                                ; 050B9  0x75, 0x0C
  pop dx                                       ; 050BB  0x5A
  push dx                                      ; 050BC  0x52
  inc dl                                       ; 050BD  0xFE, 0xC2
  jne loc_050C7                                ; 050BF  0x75, 0x06
  inc dl                                       ; 050C1  0xFE, 0xC2
  pop dx                                       ; 050C3  0x5A
  jmp near loc_03FCF                           ; 050C4  0xE9, 0x08, 0xEF

loc_050C7:                                     ; 050C7
  mov [0xb0c], cl                              ; 050C7  0x88, 0x0E, 0x0C, 0x0B
  mov_cl_al                                    ; 050CB  mov cl, al
  call sub_04E25                               ; 050CD  0xE8, 0x55, 0xFD
  call sub_04DFD                               ; 050D0  0xE8, 0x2A, 0xFD
  jmp short loc_0512A                          ; 050D3  0xEB, 0x55

loc_050D5:                                     ; 050D5
  push cx                                      ; 050D5  0x51
  call sub_04EF6                               ; 050D6  0xE8, 0x1D, 0xFE
  pop cx                                       ; 050D9  0x59
  mov bl, 3                                    ; 050DA  0xB3, 0x03
  mov al, [0x80d]                              ; 050DC  0xA0, 0x0D, 0x08
  inc al                                       ; 050DF  0xFE, 0xC0
  je loc_05138                                 ; 050E1  0x74, 0x55

loc_050E3:                                     ; 050E3
  mov word [0x815], 0xffff                     ; 050E3  0xC7, 0x06, 0x15, 0x08, 0xFF, 0xFF
  mov byte [0x8e8], 0xff                       ; 050E9  0xC6, 0x06, 0xE8, 0x08, 0xFF
  xchg [0xb0c], cl                             ; 050EE  0x86, 0x0E, 0x0C, 0x0B
  mov al, [0xb0e]                              ; 050F2  0xA0, 0x0E, 0x0B
  xchg ch, al                                  ; 050F5  86 E8
  push cx                                      ; 050F7  0x51
  and ch, 0x40                                 ; 050F8  0x80, 0xE5, 0x40
  or_al_ch                                     ; 050FB  or al, ch
  mov [0xb0e], al                              ; 050FD  0xA2, 0x0E, 0x0B
  call sub_04DD5                               ; 05100  0xE8, 0xD2, 0xFC
  mov al, [0x80d]                              ; 05103  0xA0, 0x0D, 0x08
  inc al                                       ; 05106  0xFE, 0xC0
  jne loc_05124                                ; 05108  0x75, 0x1A
  mov_bp_sp                                    ; 0510A  mov bp, sp
  mov cx, [bp + 2]                             ; 0510C  0x8B, 0x4E, 0x02
  mov bl, 4                                    ; 0510F  0xB3, 0x04
  inc cl                                       ; 05111  0xFE, 0xC1
  je loc_05130                                 ; 05113  0x74, 0x1B
  call sub_04F36                               ; 05115  0xE8, 0x1E, 0xFE
  mov bl, 5                                    ; 05118  0xB3, 0x05
  mov al, [0x80d]                              ; 0511A  0xA0, 0x0D, 0x08
  inc al                                       ; 0511D  0xFE, 0xC0
  je loc_05130                                 ; 0511F  0x74, 0x0F
  call sub_05E40                               ; 05121  0xE8, 0x1C, 0x0D

loc_05124:                                     ; 05124
  pop cx                                       ; 05124  0x59
  mov byte [0x811], 0xff                       ; 05125  0xC6, 0x06, 0x11, 0x08, 0xFF

loc_0512A:                                     ; 0512A
  pop cx                                       ; 0512A  0x59
  xor_al_al                                    ; 0512B  xor al, al
  jmp near loc_03FD1                           ; 0512D  0xE9, 0xA1, 0xEE

loc_05130:                                     ; 05130
  pop ax                                       ; 05130  0x58
  mov [0xb0c], al                              ; 05131  0xA2, 0x0C, 0x0B
  mov [0xb0e], ah                              ; 05134  0x88, 0x26, 0x0E, 0x0B

loc_05138:                                     ; 05138
  pop cx                                       ; 05138  0x59
  mov [0x80d], bl                              ; 05139  0x88, 0x1E, 0x0D, 0x08
  or_bl_bl                                     ; 0513D  or bl, bl
  ret                                          ; 0513F  0xC3

sub_05140:                                     ; 05140
  test byte [0x87f], 0x80                      ; 05140  0xF6, 0x06, 0x7F, 0x08, 0x80
  je loc_05174                                 ; 05145  0x74, 0x2D
  test byte [0x8d9], 0xff                      ; 05147  0xF6, 0x06, 0xD9, 0x08, 0xFF
  je loc_05174                                 ; 0514C  0x74, 0x26
  call sub_04F0A                               ; 0514E  0xE8, 0xB9, 0xFD

sub_05151:                                     ; 05151
  mov bx, 0x80d                                ; 05151  0xBB, 0x0D, 0x08
  cmp byte [bx], 0xff                          ; 05154  0x80, 0x3F, 0xFF
  jne loc_05164                                ; 05157  0x75, 0x0B
  pop si                                       ; 05159  0x5E
  mov al, 0xb                                  ; 0515A  0xB0, 0x0B
  mov byte [0x8d0], 0                          ; 0515C  0xC6, 0x06, 0xD0, 0x08, 0x00
  jmp near loc_03FD1                           ; 05161  0xE9, 0x6D, 0xEE

loc_05164:                                     ; 05164
  mov byte [bx], 0                             ; 05164  0xC6, 0x07, 0x00
  mov al, [0xb0f]                              ; 05167  0xA0, 0x0F, 0x0B
  mov [0x8f1], al                              ; 0516A  0xA2, 0xF1, 0x08
  xor_al_al                                    ; 0516D  xor al, al
  mov [0x8d9], al                              ; 0516F  0xA2, 0xD9, 0x08
  inc al                                       ; 05172  0xFE, 0xC0

loc_05174:                                     ; 05174
  ret                                          ; 05174  0xC3

sub_05175:                                     ; 05175
  mov ch, [0x822]                              ; 05175  0x8A, 0x2E, 0x22, 0x08
  mov al, [0x817]                              ; 05179  0xA0, 0x17, 0x08
  cmp al, 2                                    ; 0517C  0x3C, 0x02
  jb loc_05187                                 ; 0517E  0x72, 0x07
  dec al                                       ; 05180  0xFE, 0xC8
  mov [0x817], al                              ; 05182  0xA2, 0x17, 0x08
  stc                                          ; 05185  0xF9
  ret                                          ; 05186  0xC3

loc_05187:                                     ; 05187
  mov al, [0x8b3]                              ; 05187  0xA0, 0xB3, 0x08
  mov_cl_al                                    ; 0518A  mov cl, al
  and_al_ch                                    ; 0518C  and al, ch
  je loc_0519A                                 ; 0518E  0x74, 0x0A

loc_05190:                                     ; 05190
  or_cl_cl                                     ; 05190  or cl, cl
  je loc_05197                                 ; 05192  0x74, 0x03
  xor_al_al                                    ; 05194  xor al, al
  ret                                          ; 05196  0xC3

loc_05197:                                     ; 05197
  or al, 1                                     ; 05197  0x0C, 0x01
  ret                                          ; 05199  0xC3

loc_0519A:                                     ; 0519A
  mov_dh_cl                                    ; 0519A  mov dh, cl
  not dh                                       ; 0519C  0xF6, 0xD6
  mov al, [0x818]                              ; 0519E  0xA0, 0x18, 0x08
  cmp al, 2                                    ; 051A1  0x3C, 0x02
  jb loc_05190                                 ; 051A3  0x72, 0xEB
  test byte [0x87f], 0x80                      ; 051A5  0xF6, 0x06, 0x7F, 0x08, 0x80
  jne loc_05190                                ; 051AA  0x75, 0xE4
  cmp byte [0x85b], 0x1b                       ; 051AC  0x80, 0x3E, 0x5B, 0x08, 0x1B
  je loc_05190                                 ; 051B1  0x74, 0xDD
  mov bx, 0x8f3                                ; 051B3  0xBB, 0xF3, 0x08
  mov ah, [bx]                                 ; 051B6  0x8A, 0x27
  add_al_ah                                    ; 051B8  add al, ah
  cmp al, 0x80                                 ; 051BA  0x3C, 0x80
  jb loc_051C0                                 ; 051BC  0x72, 0x02
  mov al, 0x80                                 ; 051BE  0xB0, 0x80

loc_051C0:                                     ; 051C0
  push cx                                      ; 051C0  0x51
  mov byte [bx], 0x7f                          ; 051C1  0xC6, 0x07, 0x7F
  push bx                                      ; 051C4  0x53
  push ax                                      ; 051C5  0x50
  mov_bl_al                                    ; 051C6  mov bl, al
  mov al, [0x8a6]                              ; 051C8  0xA0, 0xA6, 0x08
  mov_dl_al                                    ; 051CB  mov dl, al
  inc dl                                       ; 051CD  0xFE, 0xC2
  not al                                       ; 051CF  0xF6, 0xD0
  and_ah_al                                    ; 051D1  and ah, al
  test byte [0x8eb], 0xff                      ; 051D3  0xF6, 0x06, 0xEB, 0x08, 0xFF
  je loc_051E3                                 ; 051D8  0x74, 0x09
  mov al, [0x8f1]                              ; 051DA  0xA0, 0xF1, 0x08
  and_al_dh                                    ; 051DD  and al, dh
  cmp_al_bl                                    ; 051DF  cmp al, bl
  jb loc_051E5                                 ; 051E1  0x72, 0x02

loc_051E3:                                     ; 051E3
  mov_al_bl                                    ; 051E3  mov al, bl

loc_051E5:                                     ; 051E5
  sub_al_ah                                    ; 051E5  sub al, ah
  cmp_al_dl                                    ; 051E7  cmp al, dl
  jb loc_05253                                 ; 051E9  0x72, 0x68
  push ax                                      ; 051EB  0x50
  call sub_04067                               ; 051EC  0xE8, 0x78, 0xEE
  mov_ch_al                                    ; 051EF  mov ch, al
  mov al, [0x8ef]                              ; 051F1  0xA0, 0xEF, 0x08
  cmp_al_ch                                    ; 051F4  cmp al, ch
  mov_dl_al                                    ; 051F6  mov dl, al
  je loc_05236                                 ; 051F8  0x74, 0x3C
  mov_cl_al                                    ; 051FA  mov cl, al
  push cx                                      ; 051FC  0x51
  mov ch, 0                                    ; 051FD  0xB5, 0x00
  call sub_0407E                               ; 051FF  0xE8, 0x7C, 0xEE

loc_05202:                                     ; 05202
  push bx                                      ; 05202  0x53
  inc cx                                       ; 05203  0x41
  call sub_0407E                               ; 05204  0xE8, 0x77, 0xEE
  pop dx                                       ; 05207  0x5A
  inc dx                                       ; 05208  0x42
  cmp_bx_dx                                    ; 05209  cmp bx, dx
  je loc_05202                                 ; 0520B  0x74, 0xF5
  test byte [0x8eb], 0xff                      ; 0520D  0xF6, 0x06, 0xEB, 0x08, 0xFF
  jne loc_0522B                                ; 05212  0x75, 0x17
  or_bx_bx                                     ; 05214  or bx, bx
  jne loc_0522B                                ; 05216  0x75, 0x13
  cmp dx, [0x8a8]                              ; 05218  0x3B, 0x16, 0xA8, 0x08
  jae loc_0522B                                ; 0521C  0x73, 0x0D
  push cx                                      ; 0521E  0x51
  push dx                                      ; 0521F  0x52
  mov_cx_dx                                    ; 05220  mov cx, dx
  call sub_047EE                               ; 05222  0xE8, 0xC9, 0xF5
  pop bx                                       ; 05225  0x5B
  pop cx                                       ; 05226  0x59
  shr al, 1                                    ; 05227  0xD0, 0xE8
  jae loc_05202                                ; 05229  0x73, 0xD7

loc_0522B:                                     ; 0522B
  dec cl                                       ; 0522B  0xFE, 0xC9
  pop dx                                       ; 0522D  0x5A
  mov_al_dh                                    ; 0522E  mov al, dh
  cmp_al_cl                                    ; 05230  cmp al, cl
  jb loc_05236                                 ; 05232  0x72, 0x02
  mov_al_cl                                    ; 05234  mov al, cl

loc_05236:                                     ; 05236
  sub_al_dl                                    ; 05236  sub al, dl
  mov_ch_al                                    ; 05238  mov ch, al
  inc ch                                       ; 0523A  0xFE, 0xC5
  mov al, [0x8a6]                              ; 0523C  0xA0, 0xA6, 0x08
  inc al                                       ; 0523F  0xFE, 0xC0
  mul_ch                                       ; 05241  mul ch
  pop cx                                       ; 05243  0x59
  xchg al, cl                                  ; 05244  86 C1
  test byte [0x8eb], 0xff                      ; 05246  0xF6, 0x06, 0xEB, 0x08, 0xFF
  je loc_05251                                 ; 0524B  0x74, 0x04
  cmp_al_cl                                    ; 0524D  cmp al, cl
  jb loc_05253                                 ; 0524F  0x72, 0x02

loc_05251:                                     ; 05251
  mov_al_cl                                    ; 05251  mov al, cl

loc_05253:                                     ; 05253
  pop cx                                       ; 05253  0x59
  pop bx                                       ; 05254  0x5B
  mov [bx], ch                                 ; 05255  0x88, 0x2F
  pop cx                                       ; 05257  0x59
  mov dh, [0x818]                              ; 05258  0x8A, 0x36, 0x18, 0x08
  sub_al_ch                                    ; 0525C  sub al, ch
  cmp_al_dh                                    ; 0525E  cmp al, dh
  jb loc_05264                                 ; 05260  0x72, 0x02
  mov_al_dh                                    ; 05262  mov al, dh

loc_05264:                                     ; 05264
  not cl                                       ; 05264  0xF6, 0xD1
  and_al_cl                                    ; 05266  and al, cl
  je loc_05284                                 ; 05268  0x74, 0x1A
  mov [0x817], al                              ; 0526A  0xA2, 0x17, 0x08
  test byte [0x8eb], 0xff                      ; 0526D  0xF6, 0x06, 0xEB, 0x08, 0xFF
  je loc_05279                                 ; 05272  0x74, 0x05
  push ax                                      ; 05274  0x50
  call sub_0677E                               ; 05275  0xE8, 0x06, 0x15
  pop ax                                       ; 05278  0x58

loc_05279:                                     ; 05279
  mov cl, [0x8b2]                              ; 05279  0x8A, 0x0E, 0xB2, 0x08
  shr al, cl                                   ; 0527D  0xD2, 0xE8
  mov [0x820], al                              ; 0527F  0xA2, 0x20, 0x08
  or al, 1                                     ; 05282  0x0C, 0x01

loc_05284:                                     ; 05284
  ret                                          ; 05284  0xC3

loc_05285:                                     ; 05285
  call sub_04293                               ; 05285  0xE8, 0x0B, 0xF0
  mov al, 0xff                                 ; 05288  0xB0, 0xFF
  mov [0x8eb], al                              ; 0528A  0xA2, 0xEB, 0x08
  mov [0x8d9], al                              ; 0528D  0xA2, 0xD9, 0x08
  call sub_04116                               ; 05290  0xE8, 0x83, 0xEE

loc_05293:                                     ; 05293
  mov al, [0x8f3]                              ; 05293  0xA0, 0xF3, 0x08
  cmp al, [0x8f1]                              ; 05296  0x3A, 0x06, 0xF1, 0x08
  jb loc_052B2                                 ; 0529A  0x72, 0x16
  call sub_05140                               ; 0529C  0xE8, 0xA1, 0xFE
  jne loc_05293                                ; 0529F  0x75, 0xF2
  mov al, [0x8f3]                              ; 052A1  0xA0, 0xF3, 0x08
  cmp al, 0x80                                 ; 052A4  0x3C, 0x80
  jne loc_052DA                                ; 052A6  0x75, 0x32
  call sub_04FA1                               ; 052A8  0xE8, 0xF6, 0xFC
  cmp byte [0x80d], 0                          ; 052AB  0x80, 0x3E, 0x0D, 0x08, 0x00
  jne loc_052DA                                ; 052B0  0x75, 0x28

loc_052B2:                                     ; 052B2
  call sub_04094                               ; 052B2  0xE8, 0xDF, 0xED
  jne loc_052BE                                ; 052B5  0x75, 0x07
  call sub_05140                               ; 052B7  0xE8, 0x86, 0xFE
  jne loc_05293                                ; 052BA  0x75, 0xD7
  je loc_052DA                                 ; 052BC  0x74, 0x1C

loc_052BE:                                     ; 052BE
  call sub_05C18                               ; 052BE  0xE8, 0x57, 0x09
  call sub_0403C                               ; 052C1  0xE8, 0x78, 0xED
  call sub_05175                               ; 052C4  0xE8, 0xAE, 0xFE
  jb loc_052D7                                 ; 052C7  0x72, 0x0E
  jne loc_052CE                                ; 052C9  0x75, 0x03
  jmp near loc_0458E                           ; 052CB  0xE9, 0xC0, 0xF2

loc_052CE:                                     ; 052CE
  call sub_04756                               ; 052CE  0xE8, 0x85, 0xF4
  call sub_04015                               ; 052D1  0xE8, 0x41, 0xED
  call sub_04325                               ; 052D4  0xE8, 0x4E, 0xF0

loc_052D7:                                     ; 052D7
  jmp near loc_04142                           ; 052D7  0xE9, 0x68, 0xEE

loc_052DA:                                     ; 052DA
  jmp near loc_03FCF                           ; 052DA  0xE9, 0xF2, 0xEC

sub_052DD:                                     ; 052DD
  mov al, [0x8b3]                              ; 052DD  0xA0, 0xB3, 0x08
  inc al                                       ; 052E0  0xFE, 0xC0
  xor_ah_ah                                    ; 052E2  xor ah, ah
  push ax                                      ; 052E4  0x50
  xchg al, ah                                  ; 052E5  86 C4
  shr ax, 1                                    ; 052E7  0xD1, 0xE8
  mov_cx_ax                                    ; 052E9  mov cx, ax
  mov di, [0x893]                              ; 052EB  0x8B, 0x3E, 0x93, 0x08
  sub di, 0xc                                  ; 052EF  0x83, 0xEF, 0x0C

loc_052F2:                                     ; 052F2
  mov di, [di + 0xc]                           ; 052F2  0x8B, 0x7D, 0x0C
  cmp word [di + 0xc], 0                       ; 052F5  0x83, 0x7D, 0x0C, 0x00
  jne loc_052F2                                ; 052F9  0x75, 0xF7
  mov byte [di], 0xff                          ; 052FB  0xC6, 0x05, 0xFF
  mov di, [di + 0xa]                           ; 052FE  0x8B, 0x7D, 0x0A
  mov [0x8fe], di                              ; 05301  0x89, 0x3E, 0xFE, 0x08
  mov [0x8fc], ds                              ; 05305  0x8C, 0x1E, 0xFC, 0x08
  xor_al_al                                    ; 05309  xor al, al
  rep stosb                                    ; 0530B  0xF3, 0xAA
  pop ax                                       ; 0530D  0x58
  ret                                          ; 0530E  0xC3

loc_0530F:                                     ; 0530F
  mov byte [0x8eb], 0                          ; 0530F  0xC6, 0x06, 0xEB, 0x08, 0x00
  call sub_0426C                               ; 05314  0xE8, 0x55, 0xEF
  mov al, [0xb0e]                              ; 05317  0xA0, 0x0E, 0x0B
  rcl al, 1                                    ; 0531A  0xD0, 0xD0
  not al                                       ; 0531C  0xF6, 0xD0
  test [0x880], al                             ; 0531E  0x84, 0x06, 0x80, 0x08
  mov ah, 3                                    ; 05322  0xB4, 0x03
  je loc_05329                                 ; 05324  0x74, 0x03

loc_05326:                                     ; 05326
  jmp near loc_03FD5                           ; 05326  0xE9, 0xAC, 0xEC

loc_05329:                                     ; 05329
  test byte [0x87f], 0x40                      ; 05329  0xF6, 0x06, 0x7F, 0x08, 0x40
  jne loc_05326                                ; 0532E  0x75, 0xF6
  mov bx, 0xb00                                ; 05330  0xBB, 0x00, 0x0B
  call sub_04264                               ; 05333  0xE8, 0x2E, 0xEF
  call sub_04293                               ; 05336  0xE8, 0x5A, 0xEF
  call sub_05834                               ; 05339  0xE8, 0xF8, 0x04
  call sub_04116                               ; 0533C  0xE8, 0xD7, 0xED
  mov al, [0x8f3]                              ; 0533F  0xA0, 0xF3, 0x08
  cmp al, 0x80                                 ; 05342  0x3C, 0x80
  jb loc_05351                                 ; 05344  0x72, 0x0B
  call sub_04FA1                               ; 05346  0xE8, 0x58, 0xFC
  test byte [0x80d], 0xff                      ; 05349  0xF6, 0x06, 0x0D, 0x08, 0xFF
  je loc_05351                                 ; 0534E  0x74, 0x01
  ret                                          ; 05350  0xC3

loc_05351:                                     ; 05351
  mov byte [0x8d9], 0xff                       ; 05351  0xC6, 0x06, 0xD9, 0x08, 0xFF
  call sub_05C18                               ; 05356  0xE8, 0xBF, 0x08

loc_05359:                                     ; 05359
  call sub_04094                               ; 05359  0xE8, 0x38, 0xED
  je loc_05362                                 ; 0535C  0x74, 0x04
  mov cl, 0                                    ; 0535E  0xB1, 0x00
  jmp short loc_053B3                          ; 05360  0xEB, 0x51

loc_05362:                                     ; 05362
  call sub_05140                               ; 05362  0xE8, 0xDB, 0xFD
  jne loc_05359                                ; 05365  0x75, 0xF2
  call sub_04067                               ; 05367  0xE8, 0xFD, 0xEC
  mov [0x8ef], al                              ; 0536A  0xA2, 0xEF, 0x08
  xor_cx_cx                                    ; 0536D  xor cx, cx
  or_al_al                                     ; 0536F  or al, al
  je loc_0537B                                 ; 05371  0x74, 0x08
  mov_cl_al                                    ; 05373  mov cl, al
  dec cx                                       ; 05375  0x49
  call sub_0407E                               ; 05376  0xE8, 0x05, 0xED
  mov_cx_bx                                    ; 05379  mov cx, bx

loc_0537B:                                     ; 0537B
  call sub_04D67                               ; 0537B  0xE8, 0xE9, 0xF9
  or_bx_bx                                     ; 0537E  or bx, bx
  jne loc_05387                                ; 05380  0x75, 0x05
  mov al, 2                                    ; 05382  0xB0, 0x02
  jmp near loc_03FD1                           ; 05384  0xE9, 0x4A, 0xEC

loc_05387:                                     ; 05387
  mov byte [0x811], 0xff                       ; 05387  0xC6, 0x06, 0x11, 0x08, 0xFF
  mov [0x8f5], bx                              ; 0538C  0x89, 0x1E, 0xF5, 0x08
  mov_dx_bx                                    ; 05390  mov dx, bx
  call sub_044FC                               ; 05392  0xE8, 0x67, 0xF1
  mov bx, 0xb10                                ; 05395  0xBB, 0x10, 0x0B
  cmp byte [0x8f0], 0                          ; 05398  0x80, 0x3E, 0xF0, 0x08, 0x00
  mov al, [0x8ef]                              ; 0539D  0xA0, 0xEF, 0x08
  mov ah, 0                                    ; 053A0  0xB4, 0x00
  je loc_053AA                                 ; 053A2  0x74, 0x06
  add_bx_ax                                    ; 053A4  add bx, ax
  mov [bx], dl                                 ; 053A6  0x88, 0x17
  jmp short loc_053B1                          ; 053A8  0xEB, 0x07

loc_053AA:                                     ; 053AA
  add_bx_ax                                    ; 053AA  add bx, ax
  add_bx_ax                                    ; 053AC  add bx, ax
  mov [bx], dx                                 ; 053AE  0x89, 0x17
  inc bx                                       ; 053B0  0x43

loc_053B1:                                     ; 053B1
  mov cl, 2                                    ; 053B1  0xB1, 0x02

loc_053B3:                                     ; 053B3
  mov [0x8ec], cl                              ; 053B3  0x88, 0x0E, 0xEC, 0x08
  call sub_0403C                               ; 053B7  0xE8, 0x82, 0xEC
  cmp byte [0x85b], 0x1b                       ; 053BA  0x80, 0x3E, 0x5B, 0x08, 0x1B
  jne loc_05405                                ; 053BF  0x75, 0x44
  cmp byte [0x8ec], 2                          ; 053C1  0x80, 0x3E, 0xEC, 0x08, 0x02
  jne loc_05405                                ; 053C6  0x75, 0x3D
  mov byte [0x8ec], 0                          ; 053C8  0xC6, 0x06, 0xEC, 0x08, 0x00
  push word [0x8f5]                            ; 053CD  0xFF, 0x36, 0xF5, 0x08
  call sub_052DD                               ; 053D1  0xE8, 0x09, 0xFF
  push ax                                      ; 053D4  0x50
  mov cl, [0x8a6]                              ; 053D5  0x8A, 0x0E, 0xA6, 0x08
  call sub_04538                               ; 053D9  0xE8, 0x5C, 0xF1
  mov ax, [0x8f8]                              ; 053DC  0xA1, 0xF8, 0x08
  mov cl, 2                                    ; 053DF  0xB1, 0x02

loc_053E1:                                     ; 053E1
  mov [0x8f5], ax                              ; 053E1  0xA3, 0xF5, 0x08
  push cx                                      ; 053E4  0x51
  call sub_04394                               ; 053E5  0xE8, 0xAC, 0xEF
  call sub_04015                               ; 053E8  0xE8, 0x2A, 0xEC
  pop cx                                       ; 053EB  0x59
  call sub_0431C                               ; 053EC  0xE8, 0x2D, 0xEF
  mov ax, [0x8f5]                              ; 053EF  0xA1, 0xF5, 0x08
  pop bx                                       ; 053F2  0x5B
  push bx                                      ; 053F3  0x53
  add_ax_bx                                    ; 053F4  add ax, bx
  mov bl, [0x8a6]                              ; 053F6  0x8A, 0x1E, 0xA6, 0x08
  and_bl_al                                    ; 053FA  and bl, al
  mov cl, 0                                    ; 053FC  0xB1, 0x00
  jne loc_053E1                                ; 053FE  0x75, 0xE1
  pop bx                                       ; 05400  0x5B
  pop word [0x8f5]                             ; 05401  0x8F, 0x06, 0xF5, 0x08

loc_05405:                                     ; 05405
  call sub_05175                               ; 05405  0xE8, 0x6D, 0xFD
  jb loc_05435                                 ; 05408  0x72, 0x2B
  jne loc_05413                                ; 0540A  0x75, 0x07
  mov ah, 2                                    ; 0540C  0xB4, 0x02
  call sub_045A9                               ; 0540E  0xE8, 0x98, 0xF1
  jmp short loc_05438                          ; 05411  0xEB, 0x25

loc_05413:                                     ; 05413
  call sub_04756                               ; 05413  0xE8, 0x40, 0xF3
  call sub_04015                               ; 05416  0xE8, 0xFC, 0xEB
  call sub_04394                               ; 05419  0xE8, 0x78, 0xEF
  mov cl, [0x822]                              ; 0541C  0x8A, 0x0E, 0x22, 0x08
  call sub_04538                               ; 05420  0xE8, 0x15, 0xF1
  mov cl, [0x8ec]                              ; 05423  0x8A, 0x0E, 0xEC, 0x08
  cmp byte [0x822], 0                          ; 05427  0x80, 0x3E, 0x22, 0x08, 0x00
  je loc_05430                                 ; 0542C  0x74, 0x02
  mov cl, 0                                    ; 0542E  0xB1, 0x00

loc_05430:                                     ; 05430
  call sub_0431C                               ; 05430  0xE8, 0xE9, 0xEE
  jmp short loc_05438                          ; 05433  0xEB, 0x03

loc_05435:                                     ; 05435
  call sub_04394                               ; 05435  0xE8, 0x5C, 0xEF

loc_05438:                                     ; 05438
  mov al, [0x8f3]                              ; 05438  0xA0, 0xF3, 0x08
  mov bx, 0x8f1                                ; 0543B  0xBB, 0xF1, 0x08
  cmp al, [bx]                                 ; 0543E  0x3A, 0x07
  jb loc_05462                                 ; 05440  0x72, 0x20
  mov [bx], al                                 ; 05442  0x88, 0x07
  inc byte [bx]                                ; 05444  0xFE, 0x07
  test byte [0x87f], 0                         ; 05446  0xF6, 0x06, 0x7F, 0x08, 0x00
  je loc_0545D                                 ; 0544B  0x74, 0x10
  mov ch, [0x8a6]                              ; 0544D  0x8A, 0x2E, 0xA6, 0x08
  mov_cl_ch                                    ; 05451  mov cl, ch
  not cl                                       ; 05453  0xF6, 0xD1
  inc ch                                       ; 05455  0xFE, 0xC5
  and_al_cl                                    ; 05457  and al, cl
  add_al_ch                                    ; 05459  add al, ch
  mov [bx], al                                 ; 0545B  0x88, 0x07

loc_0545D:                                     ; 0545D
  mov byte [0x8ec], 2                          ; 0545D  0xC6, 0x06, 0xEC, 0x08, 0x02

loc_05462:                                     ; 05462
  cmp byte [0x8ec], 2                          ; 05462  0x80, 0x3E, 0xEC, 0x08, 0x02
  jne loc_05487                                ; 05467  0x75, 0x1E
  and byte [0xb0e], 0x7f                       ; 05469  0x80, 0x26, 0x0E, 0x0B, 0x7F
  test byte [0x87f], 0x80                      ; 0546E  0xF6, 0x06, 0x7F, 0x08, 0x80
  je loc_05487                                 ; 05473  0x74, 0x12
  mov al, [bx]                                 ; 05475  0x8A, 0x07
  mov [0xb0f], al                              ; 05477  0xA2, 0x0F, 0x0B
  cmp byte [0x875], 1                          ; 0547A  0x80, 0x3E, 0x75, 0x08, 0x01
  jne loc_05487                                ; 0547F  0x75, 0x06
  call sub_04EF6                               ; 05481  0xE8, 0x72, 0xFA
  call sub_05151                               ; 05484  0xE8, 0xCA, 0xFC

loc_05487:                                     ; 05487
  call sub_04274                               ; 05487  0xE8, 0xEA, 0xED
  and al, 0x40                                 ; 0548A  0x24, 0x40
  jne loc_05496                                ; 0548C  0x75, 0x08
  or byte [bx], 0x40                           ; 0548E  0x80, 0x0F, 0x40
  and byte [0xb0e], 0x7f                       ; 05491  0x80, 0x26, 0x0E, 0x0B, 0x7F

loc_05496:                                     ; 05496
  jmp near loc_04142                           ; 05496  0xE9, 0xA9, 0xEC

sub_05499:                                     ; 05499
  xchg bx, dx                                  ; 05499  87 DA
  add_bx_dx                                    ; 0549B  add bx, dx
  mov cl, [bx]                                 ; 0549D  0x8A, 0x0F
  xor_ch_ch                                    ; 0549F  xor ch, ch
  db 0x8B                                      ; 054A1  .

sub_054A2:                                     ; 054A2
  fimul dword [bp + si + 0xc67]                ; 054A2
  shr ax, 1                                    ; 054A6  0xD1, 0xE8
  and ax, 0xf80                                ; 054A8  0x25, 0x80, 0x0F
  add_cx_ax                                    ; 054AB  add cx, ax
  mov al, [bx + 0xe]                           ; 054AD  0x8A, 0x47, 0x0E
  and al, 0x3f                                 ; 054B0  0x24, 0x3F
  mov ah, 0x10                                 ; 054B2  0xB4, 0x10
  mul_ah                                       ; 054B4  mul ah
  add_ch_al                                    ; 054B6  add ch, al
  mov al, 0                                    ; 054B8  0xB0, 0x00
  adc_al_ah                                    ; 054BA  adc al, ah

loc_054BC:                                     ; 054BC
  ret                                          ; 054BC  0xC3

sub_054BD:                                     ; 054BD
  mov bx, 0xb21                                ; 054BD  0xBB, 0x21, 0x0B
  cmp al, [bx + 2]                             ; 054C0  0x3A, 0x47, 0x02
  jne loc_054BC                                ; 054C3  0x75, 0xF7
  cmp cx, [bx]                                 ; 054C5  0x3B, 0x0F
  ret                                          ; 054C7  0xC3

sub_054C8:                                     ; 054C8
  push dx                                      ; 054C8  0x52
  mov_cl_al                                    ; 054C9  mov cl, al
  mov al, 9                                    ; 054CB  0xB0, 0x09
  call sub_03F49                               ; 054CD  0xE8, 0x79, 0xEA
  pop dx                                       ; 054D0  0x5A
  or_bx_bx                                     ; 054D1  or bx, bx
  je loc_054BC                                 ; 054D3  0x74, 0xE7
  inc bx                                       ; 054D5  0x43
  inc bx                                       ; 054D6  0x43
  mov [0x887], bx                              ; 054D7  0x89, 0x1E, 0x87, 0x08
  inc bx                                       ; 054DB  0x43
  inc bx                                       ; 054DC  0x43
  mov [0x889], bx                              ; 054DD  0x89, 0x1E, 0x89, 0x08
  add bx, 4                                    ; 054E1  0x83, 0xC3, 0x04
  mov_si_bx                                    ; 054E4  mov si, bx
  mov di, 0x88d                                ; 054E6  0xBF, 0x8D, 0x08
  mov cx, 0xc                                  ; 054E9  0xB9, 0x0C, 0x00
  rep movsb                                    ; 054EC  0xF3, 0xA4
  mov si, [0x88d]                              ; 054EE  0x8B, 0x36, 0x8D, 0x08
  mov di, 0x8a3                                ; 054F2  0xBF, 0xA3, 0x08
  mov cx, 0x11                                 ; 054F5  0xB9, 0x11, 0x00
  rep movsb                                    ; 054F8  0xF3, 0xA4
  mov al, [0x8a9]                              ; 054FA  0xA0, 0xA9, 0x08
  or_al_al                                     ; 054FD  or al, al
  je loc_05503                                 ; 054FF  0x74, 0x02
  mov al, 1                                    ; 05501  0xB0, 0x01

loc_05503:                                     ; 05503
  dec al                                       ; 05503  0xFE, 0xC8
  mov [0x8f0], al                              ; 05505  0xA2, 0xF0, 0x08
  stc                                          ; 05508  0xF9
  ret                                          ; 05509  0xC3

sub_0550A:                                     ; 0550A
  mov [0x8f4], al                              ; 0550A  0xA2, 0xF4, 0x08

sub_0550D:                                     ; 0550D
  mov [0x881], al                              ; 0550D  0xA2, 0x81, 0x08
  mov dx, [0x808]                              ; 05510  0x8B, 0x16, 0x08, 0x08
  call sub_04243                               ; 05514  0xE8, 0x2C, 0xED
  push dx                                      ; 05517  0x52
  call sub_054C8                               ; 05518  0xE8, 0xAD, 0xFF
  pop bx                                       ; 0551B  0x5B
  jae loc_05537                                ; 0551C  0x73, 0x19
  dec bl                                       ; 0551E  0xFE, 0xCB
  ret                                          ; 05520  0xC3

sub_05521:                                     ; 05521
  mov [0x860], dl                              ; 05521  0x88, 0x16, 0x60, 0x08

sub_05525:                                     ; 05525
  mov al, [0x860]                              ; 05525  0xA0, 0x60, 0x08
  cmp al, [0x881]                              ; 05528  0x3A, 0x06, 0x81, 0x08
  jne loc_05533                                ; 0552C  0x75, 0x05
  inc al                                       ; 0552E  0xFE, 0xC0
  je loc_05537                                 ; 05530  0x74, 0x05

loc_05532:                                     ; 05532
  ret                                          ; 05532  0xC3

loc_05533:                                     ; 05533
  cmp al, 0x10                                 ; 05533  0x3C, 0x10
  jb loc_0553A                                 ; 05535  0x72, 0x03

loc_05537:                                     ; 05537
  jmp near loc_03F96                           ; 05537  0xE9, 0x5C, 0xEA

loc_0553A:                                     ; 0553A
  call sub_0550A                               ; 0553A  0xE8, 0xCD, 0xFF
  je loc_05532                                 ; 0553D  0x74, 0xF3
  call sub_04899                               ; 0553F  0xE8, 0x57, 0xF3
  mov bx, 0x808                                ; 05542  0xBB, 0x08, 0x08
  call sub_04233                               ; 05545  0xE8, 0xEB, 0xEC
  cmp word [0x8ae], 0x8000                     ; 05548  0x81, 0x3E, 0xAE, 0x08, 0x00, 0x80
  je loc_05556                                 ; 0554E  0x74, 0x06
  mov bx, 0x800                                ; 05550  0xBB, 0x00, 0x08
  call sub_04233                               ; 05553  0xE8, 0xDD, 0xEC

loc_05556:                                     ; 05556
  ret                                          ; 05556  0xC3

sub_05557:                                     ; 05557
  xor_al_al                                    ; 05557  xor al, al
  mov [0x87f], al                              ; 05559  0xA2, 0x7F, 0x08
  mov [0x880], al                              ; 0555C  0xA2, 0x80, 0x08
  jmp short loc_05588                          ; 0555F  0xEB, 0x27

sub_05561:                                     ; 05561
  mov cx, 0x807f                               ; 05561  0xB9, 0x7F, 0x80
  mov bx, 0xb07                                ; 05564  0xBB, 0x07, 0x0B
  mov al, [bx]                                 ; 05567  0x8A, 0x07
  and_al_ch                                    ; 05569  and al, ch
  mov [0x880], al                              ; 0556B  0xA2, 0x80, 0x08
  and [bx], cl                                 ; 0556E  0x20, 0x0F
  inc bx                                       ; 05570  0x43
  mov al, [bx]                                 ; 05571  0x8A, 0x07
  and_al_cl                                    ; 05573  and al, cl
  cmp al, [bx]                                 ; 05575  0x3A, 0x07
  mov [bx], al                                 ; 05577  0x88, 0x07
  mov al, 0x60                                 ; 05579  0xB0, 0x60
  jne loc_05582                                ; 0557B  0x75, 0x05
  mov al, [bx + 4]                             ; 0557D  0x8A, 0x47, 0x04
  and al, 0xe0                                 ; 05580  0x24, 0xE0

loc_05582:                                     ; 05582
  mov [0x87f], al                              ; 05582  0xA2, 0x7F, 0x08
  call sub_04280                               ; 05585  0xE8, 0xF8, 0xEC

loc_05588:                                     ; 05588
  mov byte [0x80f], 0xff                       ; 05588  0xC6, 0x06, 0x0F, 0x08, 0xFF
  mov al, [0xb00]                              ; 0558D  0xA0, 0x00, 0x0B
  mov [0x80b], al                              ; 05590  0xA2, 0x0B, 0x08
  and al, 0x1f                                 ; 05593  0x24, 0x1F
  dec al                                       ; 05595  0xFE, 0xC8
  cmp al, 0xff                                 ; 05597  0x3C, 0xFF
  je loc_0559E                                 ; 05599  0x74, 0x03
  mov [0x860], al                              ; 0559B  0xA2, 0x60, 0x08

loc_0559E:                                     ; 0559E
  call sub_05525                               ; 0559E  0xE8, 0x84, 0xFF
  mov al, [0x861]                              ; 055A1  0xA0, 0x61, 0x08
  mov [0xb00], al                              ; 055A4  0xA2, 0x00, 0x0B

sub_055A7:                                     ; 055A7
  call sub_042CA                               ; 055A7  0xE8, 0x20, 0xED
  jne loc_055B1                                ; 055AA  0x75, 0x05
  mov byte [0x810], 0xf0                       ; 055AC  0xC6, 0x06, 0x10, 0x08, 0xF0

loc_055B1:                                     ; 055B1
  call sub_055F0                               ; 055B1  0xE8, 0x3C, 0x00
  xor_al_al                                    ; 055B4  xor al, al
  xchg [0xc0e], al                             ; 055B6  0x86, 0x06, 0x0E, 0x0C
  test al, al                                  ; 055BA  0x84, 0xC0
  je loc_05639                                 ; 055BC  0x74, 0x7B
  mov bx, [0x808]                              ; 055BE  0x8B, 0x1E, 0x08, 0x08
  mov al, 0x10                                 ; 055C2  0xB0, 0x10

loc_055C4:                                     ; 055C4
  dec al                                       ; 055C4  0xFE, 0xC8
  shl bx, 1                                    ; 055C6  0xD1, 0xE3
  jae loc_055E9                                ; 055C8  0x73, 0x1F
  push ax                                      ; 055CA  0x50
  push bx                                      ; 055CB  0x53
  call sub_0550A                               ; 055CC  0xE8, 0x3B, 0xFF
  mov bx, [0x895]                              ; 055CF  0x8B, 0x1E, 0x95, 0x08
  mov bx, [bx]                                 ; 055D3  0x8B, 0x1F

loc_055D5:                                     ; 055D5
  or_bx_bx                                     ; 055D5  or bx, bx
  je loc_055E7                                 ; 055D7  0x74, 0x0E
  test byte [bx + 4], 0xff                     ; 055D9  0xF6, 0x47, 0x04, 0xFF
  jne loc_055E4                                ; 055DD  0x75, 0x05
  mov bx, [bx + 0xc]                           ; 055DF  0x8B, 0x5F, 0x0C
  jmp short loc_055D5                          ; 055E2  0xEB, 0xF1

loc_055E4:                                     ; 055E4
  call sub_055F0                               ; 055E4  0xE8, 0x09, 0x00

loc_055E7:                                     ; 055E7
  pop bx                                       ; 055E7  0x5B
  pop ax                                       ; 055E8  0x58

loc_055E9:                                     ; 055E9
  or_al_al                                     ; 055E9  or al, al
  jne loc_055C4                                ; 055EB  0x75, 0xD7
  jmp near sub_05525                           ; 055ED  0xE9, 0x35, 0xFF

sub_055F0:                                     ; 055F0
  mov bx, [0x889]                              ; 055F0  0x8B, 0x1E, 0x89, 0x08
  xor_al_al                                    ; 055F4  xor al, al
  xchg [bx + 1], al                            ; 055F6  0x86, 0x47, 0x01
  or_al_al                                     ; 055F9  or al, al
  je loc_05639                                 ; 055FB  0x74, 0x3C
  call sub_0439C                               ; 055FD  0xE8, 0x9C, 0xED
  call sub_042A5                               ; 05600  0xE8, 0xA2, 0xEC
  push word [0x870]                            ; 05603  0xFF, 0x36, 0x70, 0x08

loc_05607:                                     ; 05607
  mov cl, 0                                    ; 05607  0xB1, 0x00
  call sub_04763                               ; 05609  0xE8, 0x57, 0xF1
  xor_al_al                                    ; 0560C  xor al, al
  xchg [0x81c], al                             ; 0560E  0x86, 0x06, 0x1C, 0x08
  test al, al                                  ; 05612  0x84, 0xC0
  je loc_05630                                 ; 05614  0x74, 0x1A
  cmp byte [0x85b], 0x21                       ; 05616  0x80, 0x3E, 0x5B, 0x08, 0x21
  je loc_05635                                 ; 0561B  0x74, 0x18
  mov al, [0x8f4]                              ; 0561D  0xA0, 0xF4, 0x08
  cmp al, [0x860]                              ; 05620  0x3A, 0x06, 0x60, 0x08
  jne loc_05635                                ; 05624  0x75, 0x0F
  pop word [0x870]                             ; 05626  0x8F, 0x06, 0x70, 0x08
  call sub_04310                               ; 0562A  0xE8, 0xE3, 0xEC
  jmp near sub_042E4                           ; 0562D  0xE9, 0xB4, 0xEC

loc_05630:                                     ; 05630
  call sub_042B6                               ; 05630  0xE8, 0x83, 0xEC
  jb loc_05607                                 ; 05633  0x72, 0xD2

loc_05635:                                     ; 05635
  pop word [0x870]                             ; 05635  0x8F, 0x06, 0x70, 0x08

loc_05639:                                     ; 05639
  ret                                          ; 05639  0xC3

sub_0563A:                                     ; 0563A
  mov cl, 8                                    ; 0563A  0xB1, 0x08

sub_0563C:                                     ; 0563C
  mov si, [0x866]                              ; 0563C  0x8B, 0x36, 0x66, 0x08
  mov di, 0x8b7                                ; 05640  0xBF, 0xB7, 0x08
  push ds                                      ; 05643  0x1E
  mov ds, [0x868]                              ; 05644  0x8E, 0x1E, 0x68, 0x08
  xor_ch_ch                                    ; 05648  xor ch, ch
  rep movsb                                    ; 0564A  0xF3, 0xA4
  pop ds                                       ; 0564C  0x1F
  ret                                          ; 0564D  0xC3

sub_0564E:                                     ; 0564E
  mov bx, [0x889]                              ; 0564E  0x8B, 0x1E, 0x89, 0x08
  mov al, [bx]                                 ; 05652  0x8A, 0x07
  ret                                          ; 05654  0xC3

sub_05655:                                     ; 05655
  mov bx, 0xb00                                ; 05655  0xBB, 0x00, 0x0B
  mov al, [bx]                                 ; 05658  0x8A, 0x07
  push ax                                      ; 0565A  0x50
  or byte [bx], 0x10                           ; 0565B  0x80, 0x0F, 0x10
  call sub_04B99                               ; 0565E  0xE8, 0x38, 0xF5
  pop ax                                       ; 05661  0x58
  mov [0xb00], al                              ; 05662  0xA2, 0x00, 0x0B
  mov byte [0x80d], 0                          ; 05665  0xC6, 0x06, 0x0D, 0x08, 0x00
  jne sub_0566D                                ; 0566A  0x75, 0x01
  ret                                          ; 0566C  0xC3

sub_0566D:                                     ; 0566D
  call sub_0424E                               ; 0566D  0xE8, 0xDE, 0xEB
  mov_dx_bx                                    ; 05670  mov dx, bx
  add bx, 0xc                                  ; 05672  0x83, 0xC3, 0x0C
  mov al, [bx]                                 ; 05675  0x8A, 0x07
  and al, 0xe0                                 ; 05677  0x24, 0xE0
  or al, 1                                     ; 05679  0x0C, 0x01
  ret                                          ; 0567B  0xC3

sub_0567C:                                     ; 0567C
  call sub_042C1                               ; 0567C  0xE8, 0x42, 0xEC
  mov cx, 0x1014                               ; 0567F  0xB9, 0x14, 0x10

sub_05682:                                     ; 05682
  push cx                                      ; 05682  0x51
  call sub_0424E                               ; 05683  0xE8, 0xC8, 0xEB
  mov si, 0xb00                                ; 05686  0xBE, 0x00, 0x0B
  lodsb                                        ; 05689  0xAC
  or_al_ch                                     ; 0568A  or al, ch
  mov [bx], al                                 ; 0568C  0x88, 0x07
  inc bx                                       ; 0568E  0x43
  mov cl, 0xb                                  ; 0568F  0xB1, 0x0B
  mov_dx_si                                    ; 05691  mov dx, si
  call sub_04003                               ; 05693  0xE8, 0x6D, 0xE9
  mov_dx_si                                    ; 05696  mov dx, si
  mov_bx_di                                    ; 05698  mov bx, di
  pop cx                                       ; 0569A  0x59
  sub_ch_ch                                    ; 0569B  sub ch, ch
  xor_al_al                                    ; 0569D  xor al, al
  rep stosb                                    ; 0569F  0xF3, 0xAA
  ret                                          ; 056A1  0xC3

sub_056A2:                                     ; 056A2
  mov byte [0x816], 0                          ; 056A2  0xC6, 0x06, 0x16, 0x08, 0x00
  mov si, 0xb00                                ; 056A7  0xBE, 0x00, 0x0B
  mov di, 0xb28                                ; 056AA  0xBF, 0x28, 0x0B
  mov cx, 0x10                                 ; 056AD  0xB9, 0x10, 0x00
  rep movsb                                    ; 056B0  0xF3, 0xA4
  call sub_0424E                               ; 056B2  0xE8, 0x99, 0xEB
  mov_si_bx                                    ; 056B5  mov si, bx
  inc si                                       ; 056B7  0x46
  mov di, 0xb01                                ; 056B8  0xBF, 0x01, 0x0B
  mov cx, 0xb                                  ; 056BB  0xB9, 0x0B, 0x00
  rep movsb                                    ; 056BE  0xF3, 0xA4
  xor_al_al                                    ; 056C0  xor al, al
  stosb                                        ; 056C2  0xAA
  inc di                                       ; 056C3  0x47
  stosb                                        ; 056C4  0xAA
  lodsb                                        ; 056C5  0xAC
  mov [0x8cb], al                              ; 056C6  0xA2, 0xCB, 0x08
  call sub_04B95                               ; 056C9  0xE8, 0xC9, 0xF4
  je loc_0570D                                 ; 056CC  0x74, 0x3F
  call sub_057B3                               ; 056CE  0xE8, 0xE2, 0x00
  or_al_al                                     ; 056D1  or al, al
  jne loc_056FA                                ; 056D3  0x75, 0x25
  mov si, 0x8cb                                ; 056D5  0xBE, 0xCB, 0x08
  mov ch, [si]                                 ; 056D8  0x8A, 0x2C
  mov al, [bx]                                 ; 056DA  0x8A, 0x07
  mov [si], al                                 ; 056DC  0x88, 0x04
  or_al_al                                     ; 056DE  or al, al
  je loc_0570D                                 ; 056E0  0x74, 0x2B
  xor_al_ch                                    ; 056E2  xor al, ch
  and al, 0xe0                                 ; 056E4  0x24, 0xE0
  je loc_056FA                                 ; 056E6  0x74, 0x12
  call sub_05655                               ; 056E8  0xE8, 0x6A, 0xFF
  je loc_056FA                                 ; 056EB  0x74, 0x0D
  mov al, [0x8cb]                              ; 056ED  0xA0, 0xCB, 0x08
  mov [bx], al                                 ; 056F0  0x88, 0x07
  call sub_0423F                               ; 056F2  0xE8, 0x4A, 0xEB
  jne loc_056FA                                ; 056F5  0x75, 0x03
  call sub_04746                               ; 056F7  0xE8, 0x4C, 0xF0

loc_056FA:                                     ; 056FA
  call sub_05724                               ; 056FA  0xE8, 0x27, 0x00
  mov al, [0x85b]                              ; 056FD  0xA0, 0x5B, 0x08
  cmp al, 2                                    ; 05700  0x3C, 0x02
  je loc_0572F                                 ; 05702  0x74, 0x2B
  cmp al, 9                                    ; 05704  0x3C, 0x09
  je loc_0572F                                 ; 05706  0x74, 0x27

loc_05708:                                     ; 05708
  mov ah, 7                                    ; 05708  0xB4, 0x07
  jmp near loc_03FD5                           ; 0570A  0xE9, 0xC8, 0xE8

loc_0570D:                                     ; 0570D
  mov byte [0x8cb], 0                          ; 0570D  0xC6, 0x06, 0xCB, 0x08, 0x00
  call sub_0423F                               ; 05712  0xE8, 0x2A, 0xEB
  jne sub_05724                                ; 05715  0x75, 0x0D
  call sub_05655                               ; 05717  0xE8, 0x3B, 0xFF
  je sub_05724                                 ; 0571A  0x74, 0x08
  or byte [0xb00], 0x10                        ; 0571C  0x80, 0x0E, 0x00, 0x0B, 0x10
  call sub_04D32                               ; 05721  0xE8, 0x0E, 0xF6

sub_05724:                                     ; 05724
  mov si, 0xb28                                ; 05724  0xBE, 0x28, 0x0B
  mov di, 0xb00                                ; 05727  0xBF, 0x00, 0x0B
  mov cx, 0x10                                 ; 0572A  0xB9, 0x10, 0x00
  rep movsb                                    ; 0572D  0xF3, 0xA4

loc_0572F:                                     ; 0572F
  ret                                          ; 0572F  0xC3

sub_05730:                                     ; 05730
  call sub_0564E                               ; 05730  0xE8, 0x1B, 0xFF
  and al, 0x80                                 ; 05733  0x24, 0x80
  je loc_0572F                                 ; 05735  0x74, 0xF8
  call sub_05655                               ; 05737  0xE8, 0x1B, 0xFF
  je loc_0572F                                 ; 0573A  0x74, 0xF3

sub_0573C:                                     ; 0573C
  inc bx                                       ; 0573C  0x43
  mov ch, [bx]                                 ; 0573D  0x8A, 0x2F
  or_ch_ch                                     ; 0573F  or ch, ch
  jne loc_05757                                ; 05741  0x75, 0x14
  mov_si_bx                                    ; 05743  mov si, bx
  add si, 3                                    ; 05745  0x83, 0xC6, 0x03
  mov cl, 9                                    ; 05748  0xB1, 0x09

loc_0574A:                                     ; 0574A
  lodsb                                        ; 0574A  0xAC
  dec cl                                       ; 0574B  0xFE, 0xC9
  je loc_0572F                                 ; 0574D  0x74, 0xE0
  or_al_al                                     ; 0574F  or al, al
  je loc_0574A                                 ; 05751  0x74, 0xF7
  cmp al, 0x20                                 ; 05753  0x3C, 0x20
  je loc_0574A                                 ; 05755  0x74, 0xF3

loc_05757:                                     ; 05757
  lea si, [bx + 0xa]                           ; 05757  0x8D, 0x77, 0x0A
  lea dx, [bx + 3]                             ; 0575A  0x8D, 0x57, 0x03
  mov bx, 0x8b7                                ; 0575D  0xBB, 0xB7, 0x08
  mov cl, 8                                    ; 05760  0xB1, 0x08
  std                                          ; 05762  0xFD

loc_05763:                                     ; 05763
  lodsb                                        ; 05763  0xAC
  xor_al_ch                                    ; 05764  xor al, ch
  cmp al, [bx]                                 ; 05766  0x3A, 0x07
  jne loc_05771                                ; 05768  0x75, 0x07
  inc bx                                       ; 0576A  0x43
  dec cl                                       ; 0576B  0xFE, 0xC9
  jne loc_05763                                ; 0576D  0x75, 0xF4
  cld                                          ; 0576F  0xFC
  ret                                          ; 05770  0xC3

loc_05771:                                     ; 05771
  cld                                          ; 05771  0xFC
  mov bx, 0x876                                ; 05772  0xBB, 0x76, 0x08
  mov cl, 8                                    ; 05775  0xB1, 0x08
  jmp near sub_0400C                           ; 05777  0xE9, 0x92, 0xE8

sub_0577A:                                     ; 0577A
  call sub_0566D                               ; 0577A  0xE8, 0xF0, 0xFE

sub_0577D:                                     ; 0577D
  push bx                                      ; 0577D  0x53
  call sub_0573C                               ; 0577E  0xE8, 0xBB, 0xFF
  pop bx                                       ; 05781  0x5B
  ret                                          ; 05782  0xC3

sub_05783:                                     ; 05783
  mov cx, 8                                    ; 05783  0xB9, 0x08, 0x00
  lea di, [bx + 0xb]                           ; 05786  0x8D, 0x7F, 0x0B

loc_05789:                                     ; 05789
  sub_ah_ah                                    ; 05789  sub ah, ah

loc_0578B:                                     ; 0578B
  lodsb                                        ; 0578B  0xAC
  mov [di], al                                 ; 0578C  0x88, 0x05
  or_al_al                                     ; 0578E  or al, al
  je loc_05798                                 ; 05790  0x74, 0x06
  cmp al, 0x20                                 ; 05792  0x3C, 0x20
  je loc_05798                                 ; 05794  0x74, 0x02
  inc ah                                       ; 05796  0xFE, 0xC4

loc_05798:                                     ; 05798
  add_ch_al                                    ; 05798  add ch, al
  dec di                                       ; 0579A  0x4F
  dec cl                                       ; 0579B  0xFE, 0xC9
  jne loc_0578B                                ; 0579D  0x75, 0xEC
  or_ah_ch                                     ; 0579F  or ah, ch
  jne loc_057A5                                ; 057A1  0x75, 0x02
  mov [bx], ah                                 ; 057A3  0x88, 0x27

loc_057A5:                                     ; 057A5
  inc di                                       ; 057A5  0x47
  mov cl, 8                                    ; 057A6  0xB1, 0x08

loc_057A8:                                     ; 057A8
  xor [di], ch                                 ; 057A8  0x30, 0x2D
  inc di                                       ; 057AA  0x47
  dec cl                                       ; 057AB  0xFE, 0xC9
  jne loc_057A8                                ; 057AD  0x75, 0xF9
  mov [bx + 1], ch                             ; 057AF  0x88, 0x6F, 0x01
  ret                                          ; 057B2  0xC3

sub_057B3:                                     ; 057B3
  mov ch, 8                                    ; 057B3  0xB5, 0x08

sub_057B5:                                     ; 057B5
  mov al, 3                                    ; 057B5  0xB0, 0x03
  mov ah, [0x870]                              ; 057B7  0x8A, 0x26, 0x70, 0x08
  and ah, 3                                    ; 057BB  0x80, 0xE4, 0x03
  cmp_al_ah                                    ; 057BE  cmp al, ah
  je loc_057DD                                 ; 057C0  0x74, 0x1B
  mov bx, [0x88b]                              ; 057C2  0x8B, 0x1E, 0x8B, 0x08
  add bx, 0x60                                 ; 057C6  0x83, 0xC3, 0x60
  mov al, [bx]                                 ; 057C9  0x8A, 0x07
  sub al, 0x21                                 ; 057CB  0x2C, 0x21
  jne loc_057DD                                ; 057CD  0x75, 0x0E
  mov_al_ah                                    ; 057CF  mov al, ah
  mov cl, 0xa                                  ; 057D1  0xB1, 0x0A
  mul_cl                                       ; 057D3  mul cl
  inc al                                       ; 057D5  0xFE, 0xC0
  add_al_ch                                    ; 057D7  add al, ch
  add_bx_ax                                    ; 057D9  add bx, ax
  xor_al_al                                    ; 057DB  xor al, al

loc_057DD:                                     ; 057DD
  ret                                          ; 057DD  0xC3

sub_057DE:                                     ; 057DE
  mov bx, 0xb0c                                ; 057DE  0xBB, 0x0C, 0x0B
  mov al, [bx]                                 ; 057E1  0x8A, 0x07
  mov ah, [0x8a7]                              ; 057E3  0x8A, 0x26, 0xA7, 0x08
  not ah                                       ; 057E7  0xF6, 0xD4
  and_al_ah                                    ; 057E9  and al, ah
  and al, 0x1f                                 ; 057EB  0x24, 0x1F
  jne loc_057DD                                ; 057ED  0x75, 0xEE
  test byte [bx + 2], 0x3f                     ; 057EF  0xF6, 0x47, 0x02, 0x3F
  ret                                          ; 057F3  0xC3

sub_057F4:                                     ; 057F4
  call sub_057DE                               ; 057F4  0xE8, 0xE7, 0xFF
  jne loc_057DD                                ; 057F7  0x75, 0xE4

sub_057F9:                                     ; 057F9
  call sub_0564E                               ; 057F9  0xE8, 0x52, 0xFE
  and_al_cl                                    ; 057FC  and al, cl
  je loc_05803                                 ; 057FE  0x74, 0x03
  jmp near sub_0423F                           ; 05800  0xE9, 0x3C, 0xEA

loc_05803:                                     ; 05803
  inc al                                       ; 05803  0xFE, 0xC0
  ret                                          ; 05805  0xC3

sub_05806:                                     ; 05806
  mov ch, 0                                    ; 05806  0xB5, 0x00
  jmp short loc_0580C                          ; 05808  0xEB, 0x02

sub_0580A:                                     ; 0580A
  mov ch, 4                                    ; 0580A  0xB5, 0x04

loc_0580C:                                     ; 0580C
  call sub_057B5                               ; 0580C  0xE8, 0xA6, 0xFF
  or_al_al                                     ; 0580F  or al, al
  jne loc_057DD                                ; 05811  0x75, 0xCA

loc_05813:                                     ; 05813
  mov dx, 0x7e                                 ; 05813  0xBA, 0x7E, 0x00

sub_05816:                                     ; 05816
  mov cl, 4                                    ; 05816  0xB1, 0x04
  push bx                                      ; 05818  0x53
  push dx                                      ; 05819  0x52
  call sub_0400C                               ; 0581A  0xE8, 0xEF, 0xE7
  pop dx                                       ; 0581D  0x5A
  pop bx                                       ; 0581E  0x5B
  je loc_057DD                                 ; 0581F  0x74, 0xBC
  mov cl, 4                                    ; 05821  0xB1, 0x04
  call sub_04003                               ; 05823  0xE8, 0xDD, 0xE7
  jmp near sub_04746                           ; 05826  0xE9, 0x1D, 0xEF

sub_05829:                                     ; 05829
  call sub_0424E                               ; 05829  0xE8, 0x22, 0xEA
  add_bx_cx                                    ; 0582C  add bx, cx
  mov ax, 0x504                                ; 0582E  0xB8, 0x04, 0x05
  push ax                                      ; 05831  0x50
  jmp short loc_05813                          ; 05832  0xEB, 0xDF

sub_05834:                                     ; 05834
  mov cl, 0x20                                 ; 05834  0xB1, 0x20
  call sub_057F9                               ; 05836  0xE8, 0xC0, 0xFF
  jne loc_057DD                                ; 05839  0x75, 0xA2
  test byte [0xb0e], 0x40                      ; 0583B  0xF6, 0x06, 0x0E, 0x0B, 0x40
  jne loc_057DD                                ; 05840  0x75, 0x9B
  mov ah, [0xb0c]                              ; 05842  0x8A, 0x26, 0x0C, 0x0B
  mov al, [0xb0e]                              ; 05846  0xA0, 0x0E, 0x0B
  push ax                                      ; 05849  0x50
  call sub_04B8D                               ; 0584A  0xE8, 0x40, 0xF3
  je loc_05852                                 ; 0584D  0x74, 0x03
  call sub_0580A                               ; 0584F  0xE8, 0xB8, 0xFF

loc_05852:                                     ; 05852
  mov byte [0x80d], 0                          ; 05852  0xC6, 0x06, 0x0D, 0x08, 0x00
  pop ax                                       ; 05857  0x58
  mov [0xb0c], ah                              ; 05858  0x88, 0x26, 0x0C, 0x0B
  mov [0xb0e], al                              ; 0585C  0xA2, 0x0E, 0x0B
  ret                                          ; 0585F  0xC3

sub_05860:                                     ; 05860
  mov ax, [0x8e7]                              ; 05860  0xA1, 0xE7, 0x08
  mov [0x882], ax                              ; 05863  0xA3, 0x82, 0x08
  mov byte [0x884], 0                          ; 05866  0xC6, 0x06, 0x84, 0x08, 0x00
  ret                                          ; 0586B  0xC3

sub_0586C:                                     ; 0586C
  mov bx, 0x8e3                                ; 0586C  0xBB, 0xE3, 0x08
  jmp short loc_0587A                          ; 0586F  0xEB, 0x09

sub_05871:                                     ; 05871
  mov bx, 0x8e5                                ; 05871  0xBB, 0xE5, 0x08
  jmp short loc_0587A                          ; 05874  0xEB, 0x04

sub_05876:                                     ; 05876
  mov bx, [0x8d5]                              ; 05876  0x8B, 0x1E, 0xD5, 0x08

loc_0587A:                                     ; 0587A
  mov [0x8d7], bx                              ; 0587A  0x89, 0x1E, 0xD7, 0x08

loc_0587E:                                     ; 0587E
  mov bx, [bx]                                 ; 0587E  0x8B, 0x1F
  or_bx_bx                                     ; 05880  or bx, bx
  jne loc_05887                                ; 05882  0x75, 0x03
  or al, 1                                     ; 05884  0x0C, 0x01
  ret                                          ; 05886  0xC3

loc_05887:                                     ; 05887
  or_ch_ch                                     ; 05887  or ch, ch
  je loc_058BB                                 ; 05889  0x74, 0x30
  mov cl, [bx + 2]                             ; 0588B  0x8A, 0x4F, 0x02
  and cl, 0xf                                  ; 0588E  0x80, 0xE1, 0x0F
  mov si, 0x881                                ; 05891  0xBE, 0x81, 0x08
  lodsb                                        ; 05894  0xAC
  cmp_al_cl                                    ; 05895  cmp al, cl
  jne loc_058B9                                ; 05897  0x75, 0x20
  cmp ch, 1                                    ; 05899  0x80, 0xFD, 0x01
  je loc_058BB                                 ; 0589C  0x74, 0x1D
  mov_cl_ch                                    ; 0589E  mov cl, ch
  push cx                                      ; 058A0  0x51
  xor_al_al                                    ; 058A1  xor al, al
  xchg [bx + 5], al                            ; 058A3  0x86, 0x47, 0x05
  xor_ch_ch                                    ; 058A6  xor ch, ch
  lea di, [bx + 3]                             ; 058A8  0x8D, 0x7F, 0x03
  repe cmpsb                                   ; 058AB  0xF3, 0xA6
  mov [bx + 5], al                             ; 058AD  0x88, 0x47, 0x05
  pop cx                                       ; 058B0  0x59
  je loc_058BB                                 ; 058B1  0x74, 0x08

loc_058B3:                                     ; 058B3
  mov [0x8d7], bx                              ; 058B3  0x89, 0x1E, 0xD7, 0x08
  jmp short loc_0587E                          ; 058B7  0xEB, 0xC5

loc_058B9:                                     ; 058B9
  jae loc_058B3                                ; 058B9  0x73, 0xF8

loc_058BB:                                     ; 058BB
  mov [0x8d5], bx                              ; 058BB  0x89, 0x1E, 0xD5, 0x08
  ret                                          ; 058BF  0xC3

sub_058C0:                                     ; 058C0
  pushf                                        ; 058C0  0x9C
  cli                                          ; 058C1  0xFA
  mov si, [bx]                                 ; 058C2  0x8B, 0x37
  mov di, [0x8d7]                              ; 058C4  0x8B, 0x3E, 0xD7, 0x08
  mov [0x8d5], di                              ; 058C8  0x89, 0x3E, 0xD5, 0x08
  mov [di], si                                 ; 058CC  0x89, 0x35
  mov si, [0x52]                               ; 058CE  0x8B, 0x36, 0x52, 0x00
  mov [0x52], bx                               ; 058D2  0x89, 0x1E, 0x52, 0x00
  mov [bx], si                                 ; 058D6  0x89, 0x37
  popf                                         ; 058D8  0x9D
  mov cl, [bx + 2]                             ; 058D9  0x8A, 0x4F, 0x02
  and cl, 0xf                                  ; 058DC  0x80, 0xE1, 0x0F
  mov bx, 0x8e3                                ; 058DF  0xBB, 0xE3, 0x08

loc_058E2:                                     ; 058E2
  mov bx, [bx]                                 ; 058E2  0x8B, 0x1F
  or_bx_bx                                     ; 058E4  or bx, bx
  je loc_058F2                                 ; 058E6  0x74, 0x0A
  mov al, [bx + 2]                             ; 058E8  0x8A, 0x47, 0x02
  and al, 0xf                                  ; 058EB  0x24, 0x0F
  cmp_al_cl                                    ; 058ED  cmp al, cl
  jne loc_058E2                                ; 058EF  0x75, 0xF1
  ret                                          ; 058F1  0xC3

loc_058F2:                                     ; 058F2
  mov bx, 0x88                                 ; 058F2  0xBB, 0x88, 0x00
  jmp short loc_058FB                          ; 058F5  0xEB, 0x04

sub_058F7:                                     ; 058F7
  mov cl, [0x881]                              ; 058F7  0x8A, 0x0E, 0x81, 0x08

loc_058FB:                                     ; 058FB
  mov ax, 1                                    ; 058FB  0xB8, 0x01, 0x00
  shl ax, cl                                   ; 058FE  0xD3, 0xE0
  not ax                                       ; 05900  0xF7, 0xD0
  and [bx], ax                                 ; 05902  0x21, 0x07
  ret                                          ; 05904  0xC3

sub_05905:                                     ; 05905
  test byte [bx + 2], 0x40                     ; 05905  0xF6, 0x47, 0x02, 0x40
  je loc_0594F                                 ; 05909  0x74, 0x44
  push word [0x8d7]                            ; 0590B  0xFF, 0x36, 0xD7, 0x08
  push bx                                      ; 0590F  0x53
  mov ax, 0x8e5                                ; 05910  0xB8, 0xE5, 0x08
  mov [0x8d5], ax                              ; 05913  0xA3, 0xD5, 0x08

loc_05916:                                     ; 05916
  mov ch, 0                                    ; 05916  0xB5, 0x00
  call sub_05876                               ; 05918  0xE8, 0x5B, 0xFF
  jne loc_05929                                ; 0591B  0x75, 0x0C
  pop dx                                       ; 0591D  0x5A
  push dx                                      ; 0591E  0x52
  cmp [bx + 8], dx                             ; 0591F  0x39, 0x57, 0x08
  jne loc_05916                                ; 05922  0x75, 0xF2
  call sub_058C0                               ; 05924  0xE8, 0x99, 0xFF
  jmp short loc_05916                          ; 05927  0xEB, 0xED

loc_05929:                                     ; 05929
  pop ax                                       ; 05929  0x58
  push ax                                      ; 0592A  0x50
  mov bx, 0x8dc                                ; 0592B  0xBB, 0xDC, 0x08

loc_0592E:                                     ; 0592E
  mov si, [bx]                                 ; 0592E  0x8B, 0x37
  cmp [si + 2], ax                             ; 05930  0x39, 0x44, 0x02
  jne loc_05946                                ; 05933  0x75, 0x11
  mov di, [si]                                 ; 05935  0x8B, 0x3C
  mov ax, [di]                                 ; 05937  0x8B, 0x05
  mov [bx], ax                                 ; 05939  0x89, 0x07
  mov ax, [0x52]                               ; 0593B  0xA1, 0x52, 0x00
  mov [di], ax                                 ; 0593E  0x89, 0x05
  mov [0x52], si                               ; 05940  0x89, 0x36, 0x52, 0x00
  jmp short loc_0594A                          ; 05944  0xEB, 0x04

loc_05946:                                     ; 05946
  mov bx, [si]                                 ; 05946  0x8B, 0x1C
  jmp short loc_0592E                          ; 05948  0xEB, 0xE4

loc_0594A:                                     ; 0594A
  pop bx                                       ; 0594A  0x5B
  pop word [0x8d7]                             ; 0594B  0x8F, 0x06, 0xD7, 0x08

loc_0594F:                                     ; 0594F
  ret                                          ; 0594F  0xC3

sub_05950:                                     ; 05950
  mov ax, [0x885]                              ; 05950  0xA1, 0x85, 0x08
  cmp [bx + 6], ax                             ; 05953  0x39, 0x47, 0x06
  ret                                          ; 05956  0xC3

sub_05957:                                     ; 05957
  mov byte [0x8cd], 0                          ; 05957  0xC6, 0x06, 0xCD, 0x08, 0x00
  jmp short loc_05963                          ; 0595C  0xEB, 0x05

sub_0595E:                                     ; 0595E
  mov byte [0x8cd], 0xff                       ; 0595E  0xC6, 0x06, 0xCD, 0x08, 0xFF

loc_05963:                                     ; 05963
  mov ax, [0x870]                              ; 05963  0xA1, 0x70, 0x08
  mov [0x8e7], ax                              ; 05966  0xA3, 0xE7, 0x08
  call sub_05860                               ; 05969  0xE8, 0xF4, 0xFE
  mov ch, 3                                    ; 0596C  0xB5, 0x03
  call sub_0586C                               ; 0596E  0xE8, 0xFB, 0xFE
  jne loc_0594F                                ; 05971  0x75, 0xDC
  call sub_041B8                               ; 05973  0xE8, 0x42, 0xE8
  rol al, 1                                    ; 05976  0xD0, 0xC0
  mov al, [bx + 2]                             ; 05978  0x8A, 0x47, 0x02
  jae loc_05981                                ; 0597B  0x73, 0x04
  rol al, 1                                    ; 0597D  0xD0, 0xC0
  rol al, 1                                    ; 0597F  0xD0, 0xC0

loc_05981:                                     ; 05981
  rol al, 1                                    ; 05981  0xD0, 0xC0
  jae loc_059B4                                ; 05983  0x73, 0x2F
  call sub_05950                               ; 05985  0xE8, 0xC8, 0xFF
  jne loc_059B4                                ; 05988  0x75, 0x2A
  call sub_041B8                               ; 0598A  0xE8, 0x2B, 0xE8
  rol al, 1                                    ; 0598D  0xD0, 0xC0
  jae loc_0599D                                ; 0598F  0x73, 0x0C
  mov ch, 3                                    ; 05991  0xB5, 0x03
  call sub_05876                               ; 05993  0xE8, 0xE0, 0xFE
  je loc_059B4                                 ; 05996  0x74, 0x1C
  mov ch, 3                                    ; 05998  0xB5, 0x03
  call sub_0586C                               ; 0599A  0xE8, 0xCF, 0xFE

loc_0599D:                                     ; 0599D
  test byte [0x8cd], 0xff                      ; 0599D  0xF6, 0x06, 0xCD, 0x08, 0xFF
  je loc_059C6                                 ; 059A2  0x74, 0x22
  cmp byte [bx + 9], 0xff                      ; 059A4  0x80, 0x7F, 0x09, 0xFF
  jne loc_059B7                                ; 059A8  0x75, 0x0D
  test byte [0x8cc], 0x80                      ; 059AA  0xF6, 0x06, 0xCC, 0x08, 0x80
  js loc_059C6                                 ; 059AF  0x78, 0x15
  jmp near sub_058C0                           ; 059B1  0xE9, 0x0C, 0xFF

loc_059B4:                                     ; 059B4
  jmp near loc_06154                           ; 059B4  0xE9, 0x9D, 0x07

loc_059B7:                                     ; 059B7
  call sub_058C0                               ; 059B7  0xE8, 0x06, 0xFF

sub_059BA:                                     ; 059BA
  mov al, [0x87e]                              ; 059BA  0xA0, 0x7E, 0x08
  and al, 0xf0                                 ; 059BD  0x24, 0xF0

loc_059BF:                                     ; 059BF
  add al, 0x10                                 ; 059BF  0x04, 0x10
  je loc_059BF                                 ; 059C1  0x74, 0xFC
  mov [0x87e], al                              ; 059C3  0xA2, 0x7E, 0x08

loc_059C6:                                     ; 059C6
  ret                                          ; 059C6  0xC3
xios_fn_ext46:
  mov ax, 0x8e3                                ; 059C7  0xB8, 0xE3, 0x08
  mov [0x8d5], ax                              ; 059CA  0xA3, 0xD5, 0x08

loc_059CD:                                     ; 059CD
  mov ch, 0                                    ; 059CD  0xB5, 0x00
  call sub_05876                               ; 059CF  0xE8, 0xA4, 0xFE
  jne loc_059E4                                ; 059D2  0x75, 0x10
  mov ax, [0x885]                              ; 059D4  0xA1, 0x85, 0x08
  cmp [bx + 6], ax                             ; 059D7  0x39, 0x47, 0x06
  jne loc_059CD                                ; 059DA  0x75, 0xF1
  call sub_05905                               ; 059DC  0xE8, 0x26, 0xFF
  call sub_058C0                               ; 059DF  0xE8, 0xDE, 0xFE
  jmp short loc_059CD                          ; 059E2  0xEB, 0xE9

loc_059E4:                                     ; 059E4
  call sub_0670F                               ; 059E4  0xE8, 0x28, 0x0D

loc_059E7:                                     ; 059E7
  ret                                          ; 059E7  0xC3

loc_059E8:                                     ; 059E8
  mov al, 0xff                                 ; 059E8  0xB0, 0xFF
  xchg [0x8e0], al                             ; 059EA  0x86, 0x06, 0xE0, 0x08
  test al, al                                  ; 059EE  0x84, 0xC0
  jne loc_059E7                                ; 059F0  0x75, 0xF5

sub_059F2:                                     ; 059F2
  mov ax, 0x8e3                                ; 059F2  0xB8, 0xE3, 0x08
  mov [0x8d5], ax                              ; 059F5  0xA3, 0xD5, 0x08

loc_059F8:                                     ; 059F8
  mov ch, 1                                    ; 059F8  0xB5, 0x01
  call sub_05876                               ; 059FA  0xE8, 0x79, 0xFE
  jne loc_059E7                                ; 059FD  0x75, 0xE8
  call sub_05905                               ; 059FF  0xE8, 0x03, 0xFF
  call sub_058C0                               ; 05A02  0xE8, 0xBB, 0xFE
  jmp short loc_059F8                          ; 05A05  0xEB, 0xF1

sub_05A07:                                     ; 05A07
  mov ax, 0x8e3                                ; 05A07  0xB8, 0xE3, 0x08
  mov [0x8d5], ax                              ; 05A0A  0xA3, 0xD5, 0x08

loc_05A0D:                                     ; 05A0D
  mov ch, [0x8d4]                              ; 05A0D  0x8A, 0x2E, 0xD4, 0x08
  call sub_05876                               ; 05A11  0xE8, 0x62, 0xFE
  jne loc_059E7                                ; 05A14  0x75, 0xD1
  mov ax, [0x885]                              ; 05A16  0xA1, 0x85, 0x08
  cmp [bx + 6], ax                             ; 05A19  0x39, 0x47, 0x06
  jne loc_05A0D                                ; 05A1C  0x75, 0xEF
  cmp word [bx + 3], -1                        ; 05A1E  0x83, 0x7F, 0x03, 0xFF
  jne loc_05A2A                                ; 05A22  0x75, 0x06
  cmp byte [bx + 5], 0xff                      ; 05A24  0x80, 0x7F, 0x05, 0xFF
  je loc_05A2F                                 ; 05A28  0x74, 0x05

loc_05A2A:                                     ; 05A2A
  mov byte [0x8d3], 0xff                       ; 05A2A  0xC6, 0x06, 0xD3, 0x08, 0xFF

loc_05A2F:                                     ; 05A2F
  call sub_05905                               ; 05A2F  0xE8, 0xD3, 0xFE
  call sub_058C0                               ; 05A32  0xE8, 0x8B, 0xFE
  jmp short loc_05A0D                          ; 05A35  0xEB, 0xD6

sub_05A37:                                     ; 05A37
  mov bx, [0x52]                               ; 05A37  0x8B, 0x1E, 0x52, 0x00
  or_bx_bx                                     ; 05A3B  or bx, bx
  je loc_059E7                                 ; 05A3D  0x74, 0xA8
  mov [0x8d5], bx                              ; 05A3F  0x89, 0x1E, 0xD5, 0x08
  mov si, [bx]                                 ; 05A43  0x8B, 0x37
  mov [0x52], si                               ; 05A45  0x89, 0x36, 0x52, 0x00
  mov si, [0x8d7]                              ; 05A49  0x8B, 0x36, 0xD7, 0x08
  mov di, [si]                                 ; 05A4D  0x8B, 0x3C
  mov [bx], di                                 ; 05A4F  0x89, 0x3F
  mov [si], bx                                 ; 05A51  0x89, 0x1C
  ret                                          ; 05A53  0xC3

sub_05A54:                                     ; 05A54
  mov ch, 1                                    ; 05A54  0xB5, 0x01
  call sub_0586C                               ; 05A56  0xE8, 0x13, 0xFE
  call sub_05A37                               ; 05A59  0xE8, 0xDB, 0xFF

sub_05A5C:                                     ; 05A5C
  mov al, [0x881]                              ; 05A5C  0xA0, 0x81, 0x08
  or al, [0x8cc]                               ; 05A5F  0x0A, 0x06, 0xCC, 0x08
  mov [bx + 2], al                             ; 05A63  0x88, 0x47, 0x02
  mov si, 0x882                                ; 05A66  0xBE, 0x82, 0x08
  lea di, [bx + 3]                             ; 05A69  0x8D, 0x7F, 0x03
  mov cx, 5                                    ; 05A6C  0xB9, 0x05, 0x00
  rep movsb                                    ; 05A6F  0xF3, 0xA4
  xor_ax_ax                                    ; 05A71  xor ax, ax
  stosw                                        ; 05A73  0xAB
  mov cl, [0x881]                              ; 05A74  0x8A, 0x0E, 0x81, 0x08
  inc ax                                       ; 05A78  0x40
  shl ax, cl                                   ; 05A79  0xD3, 0xE0
  or [0x88], ax                                ; 05A7B  0x09, 0x06, 0x88, 0x00
  ret                                          ; 05A7F  0xC3

sub_05A80:                                     ; 05A80
  mov ch, 1                                    ; 05A80  0xB5, 0x01
  call sub_05871                               ; 05A82  0xE8, 0xEC, 0xFD
  call sub_05A37                               ; 05A85  0xE8, 0xAF, 0xFF
  lea di, [bx + 3]                             ; 05A88  0x8D, 0x7F, 0x03
  mov ax, [0x81e]                              ; 05A8B  0xA1, 0x1E, 0x08
  mov [bx + 8], ax                             ; 05A8E  0x89, 0x47, 0x08
  ret                                          ; 05A91  0xC3

sub_05A92:                                     ; 05A92
  mov byte [0x8da], 0                          ; 05A92  0xC6, 0x06, 0xDA, 0x08, 0x00
  mov ax, 0x8e3                                ; 05A97  0xB8, 0xE3, 0x08
  mov [0x8d5], ax                              ; 05A9A  0xA3, 0xD5, 0x08

loc_05A9D:                                     ; 05A9D
  mov ch, 0                                    ; 05A9D  0xB5, 0x00
  call sub_05876                               ; 05A9F  0xE8, 0xD4, 0xFD
  jne loc_05AB2                                ; 05AA2  0x75, 0x0E
  mov ax, [0x885]                              ; 05AA4  0xA1, 0x85, 0x08
  cmp [bx + 6], ax                             ; 05AA7  0x39, 0x47, 0x06
  jne loc_05A9D                                ; 05AAA  0x75, 0xF1
  inc byte [0x8da]                             ; 05AAC  0xFE, 0x06, 0xDA, 0x08
  jmp short loc_05A9D                          ; 05AB0  0xEB, 0xEB

loc_05AB2:                                     ; 05AB2
  mov al, [0x8da]                              ; 05AB2  0xA0, 0xDA, 0x08
  sub al, [0x8b]                               ; 05AB5  0x2A, 0x06, 0x8B, 0x00
  ret                                          ; 05AB9  0xC3

sub_05ABA:                                     ; 05ABA
  mov bx, 0x52                                 ; 05ABA  0xBB, 0x52, 0x00
  xor_dh_dh                                    ; 05ABD  xor dh, dh

loc_05ABF:                                     ; 05ABF
  mov bx, [bx]                                 ; 05ABF  0x8B, 0x1F
  or_bx_bx                                     ; 05AC1  or bx, bx
  je loc_05ACC                                 ; 05AC3  0x74, 0x07
  inc dh                                       ; 05AC5  0xFE, 0xC6
  cmp_dh_dl                                    ; 05AC7  cmp dh, dl
  jb loc_05ABF                                 ; 05AC9  0x72, 0xF4
  ret                                          ; 05ACB  0xC3

loc_05ACC:                                     ; 05ACC
  pop bx                                       ; 05ACC  0x5B
  mov al, 0xe                                  ; 05ACD  0xB0, 0x0E
  jmp near loc_03FD1                           ; 05ACF  0xE9, 0xFF, 0xE4
  mov dx, 0x8f5                                ; 05AD2  0xBA, 0xF5, 0x08
  mov bx, 0x882                                ; 05AD5  0xBB, 0x82, 0x08
  mov cl, 3                                    ; 05AD8  0xB1, 0x03
  jmp near sub_04003                           ; 05ADA  0xE9, 0x26, 0xE5

sub_05ADD:                                     ; 05ADD
  call sub_04094                               ; 05ADD  0xE8, 0xB4, 0xE5
  je loc_05AEE                                 ; 05AE0  0x74, 0x0C
  mov al, [0x8f3]                              ; 05AE2  0xA0, 0xF3, 0x08
  cmp al, [0x8f1]                              ; 05AE5  0x3A, 0x06, 0xF1, 0x08
  jae loc_05AEE                                ; 05AE9  0x73, 0x03
  xor_al_al                                    ; 05AEB  xor al, al
  ret                                          ; 05AED  0xC3

loc_05AEE:                                     ; 05AEE
  or al, 1                                     ; 05AEE  0x0C, 0x01
  ret                                          ; 05AF0  0xC3

sub_05AF1:                                     ; 05AF1
  mov [0x8ce], sp                              ; 05AF1  0x89, 0x26, 0xCE, 0x08
  mov byte [0x8d0], 0xff                       ; 05AF5  0xC6, 0x06, 0xD0, 0x08, 0xFF
  mov cl, 0xff                                 ; 05AFA  0xB1, 0xFF
  call sub_05072                               ; 05AFC  0xE8, 0x73, 0xF5
  mov byte [0x8d0], 0                          ; 05AFF  0xC6, 0x06, 0xD0, 0x08, 0x00
  call sub_04116                               ; 05B04  0xE8, 0x0F, 0xE6
  test byte [0x80d], 0xff                      ; 05B07  0xF6, 0x06, 0x0D, 0x08, 0xFF
  jne loc_05B2C                                ; 05B0C  0x75, 0x1E
  call sub_05ADD                               ; 05B0E  0xE8, 0xCC, 0xFF
  je loc_05B2C                                 ; 05B11  0x74, 0x19
  mov byte [0x8d9], 0xff                       ; 05B13  0xC6, 0x06, 0xD9, 0x08, 0xFF
  mov byte [0x8d0], 0xff                       ; 05B18  0xC6, 0x06, 0xD0, 0x08, 0xFF
  call sub_05140                               ; 05B1D  0xE8, 0x20, 0xF6
  mov byte [0x8d0], 0                          ; 05B20  0xC6, 0x06, 0xD0, 0x08, 0x00
  je loc_05B2D                                 ; 05B25  0x74, 0x06
  call sub_05ADD                               ; 05B27  0xE8, 0xB3, 0xFF
  jne loc_05B2D                                ; 05B2A  0x75, 0x01

loc_05B2C:                                     ; 05B2C
  ret                                          ; 05B2C  0xC3

loc_05B2D:                                     ; 05B2D
  jmp near loc_03FCF                           ; 05B2D  0xE9, 0x9F, 0xE4

sub_05B30:                                     ; 05B30
  mov bl, [si]                                 ; 05B30  0x8A, 0x1C
  mov ax, [si + 1]                             ; 05B32  0x8B, 0x44, 0x01
  mov bh, [di]                                 ; 05B35  0x8A, 0x3D
  mov dx, [di + 1]                             ; 05B37  0x8B, 0x55, 0x01
  test cl, 2                                   ; 05B3A  0xF6, 0xC1, 0x02
  je loc_05B45                                 ; 05B3D  0x74, 0x06
  add bl, [si + 3]                             ; 05B3F  0x02, 0x5C, 0x03
  adc ax, strict word 0                        ; 05B42  15 00 00

loc_05B45:                                     ; 05B45
  test cl, 1                                   ; 05B45  0xF6, 0xC1, 0x01
  je loc_05B51                                 ; 05B48  0x74, 0x07
  add bh, [0x875]                              ; 05B4A  0x02, 0x3E, 0x75, 0x08
  adc dx, 0                                    ; 05B4E  0x83, 0xD2, 0x00

loc_05B51:                                     ; 05B51
  cmp_ax_dx                                    ; 05B51  cmp ax, dx
  jne loc_05B57                                ; 05B53  0x75, 0x02
  cmp_bl_bh                                    ; 05B55  cmp bl, bh

loc_05B57:                                     ; 05B57
  ret                                          ; 05B57  0xC3

sub_05B58:                                     ; 05B58
  mov ch, 1                                    ; 05B58  0xB5, 0x01
  call sub_05876                               ; 05B5A  0xE8, 0x19, 0xFD
  je loc_05B62                                 ; 05B5D  0x74, 0x03
  mov al, 0xff                                 ; 05B5F  0xB0, 0xFF
  ret                                          ; 05B61  0xC3

loc_05B62:                                     ; 05B62
  mov di, [0x81e]                              ; 05B62  0x8B, 0x3E, 0x1E, 0x08
  mov cx, 3                                    ; 05B66  0xB9, 0x03, 0x00
  mov si, [bx + 8]                             ; 05B69  0x8B, 0x77, 0x08
  add_si_cx                                    ; 05B6C  add si, cx
  add_di_cx                                    ; 05B6E  add di, cx
  repe cmpsb                                   ; 05B70  0xF3, 0xA6
  jne sub_05B58                                ; 05B72  0x75, 0xE4
  lea si, [bx + 3]                             ; 05B74  0x8D, 0x77, 0x03
  mov di, 0xb21                                ; 05B77  0xBF, 0x21, 0x0B
  mov cl, 1                                    ; 05B7A  0xB1, 0x01
  call sub_05B30                               ; 05B7C  0xE8, 0xB1, 0xFF
  jae sub_05B58                                ; 05B7F  0x73, 0xD7
  mov cl, 2                                    ; 05B81  0xB1, 0x02
  call sub_05B30                               ; 05B83  0xE8, 0xAA, 0xFF
  jbe sub_05B58                                ; 05B86  0x76, 0xD0
  mov cl, 0                                    ; 05B88  0xB1, 0x00
  call sub_05B30                               ; 05B8A  0xE8, 0xA3, 0xFF
  jb loc_05B9E                                 ; 05B8D  0x72, 0x0F
  mov cl, 3                                    ; 05B8F  0xB1, 0x03
  call sub_05B30                               ; 05B91  0xE8, 0x9C, 0xFF
  ja loc_05B9A                                 ; 05B94  0x77, 0x04
  mov al, 1                                    ; 05B96  0xB0, 0x01
  jmp short loc_05BAB                          ; 05B98  0xEB, 0x11

loc_05B9A:                                     ; 05B9A
  mov al, 4                                    ; 05B9A  0xB0, 0x04
  jmp short loc_05BAB                          ; 05B9C  0xEB, 0x0D

loc_05B9E:                                     ; 05B9E
  mov cl, 3                                    ; 05B9E  0xB1, 0x03
  call sub_05B30                               ; 05BA0  0xE8, 0x8D, 0xFF
  jbe loc_05BA9                                ; 05BA3  0x76, 0x04
  mov al, 2                                    ; 05BA5  0xB0, 0x02
  jmp short loc_05BAB                          ; 05BA7  0xEB, 0x02

loc_05BA9:                                     ; 05BA9
  mov al, 8                                    ; 05BA9  0xB0, 0x08

loc_05BAB:                                     ; 05BAB
  mov bx, [0x8d5]                              ; 05BAB  0x8B, 0x1E, 0xD5, 0x08
  mov si, [bx + 8]                             ; 05BAF  0x8B, 0x77, 0x08
  mov di, [si + 6]                             ; 05BB2  0x8B, 0x7C, 0x06
  cmp [0x885], di                              ; 05BB5  0x39, 0x3E, 0x85, 0x08
  je loc_05BCA                                 ; 05BB9  0x74, 0x0F
  test byte [0x8cc], 0x80                      ; 05BBB  0xF6, 0x06, 0xCC, 0x08, 0x80
  je loc_05BC8                                 ; 05BC0  0x74, 0x06
  test byte [bx + 2], 0x80                     ; 05BC2  0xF6, 0x47, 0x02, 0x80
  jne loc_05BCA                                ; 05BC6  0x75, 0x02

loc_05BC8:                                     ; 05BC8
  mov al, 0xfe                                 ; 05BC8  0xB0, 0xFE

loc_05BCA:                                     ; 05BCA
  ret                                          ; 05BCA  0xC3

sub_05BCB:                                     ; 05BCB
  mov al, [si + 6]                             ; 05BCB  0x8A, 0x44, 0x06
  cmp al, [0x881]                              ; 05BCE  0x3A, 0x06, 0x81, 0x08
  jne loc_05C05                                ; 05BD2  0x75, 0x31
  lea di, [si + 7]                             ; 05BD4  0x8D, 0x7C, 0x07
  mov bx, 0xb01                                ; 05BD7  0xBB, 0x01, 0x0B
  mov cx, 3                                    ; 05BDA  0xB9, 0x03, 0x00
  call sub_05C0D                               ; 05BDD  0xE8, 0x2D, 0x00
  jne loc_05C05                                ; 05BE0  0x75, 0x23
  mov cx, 8                                    ; 05BE2  0xB9, 0x08, 0x00
  mov_dx_si                                    ; 05BE5  mov dx, si
  mov si, [si]                                 ; 05BE7  0x8B, 0x34
  lea di, [si + 2]                             ; 05BE9  0x8D, 0x7C, 0x02
  call sub_05C0D                               ; 05BEC  0xE8, 0x1E, 0x00
  jne loc_05C07                                ; 05BEF  0x75, 0x16
  mov_bx_dx                                    ; 05BF1  mov bx, dx
  mov ax, [bx + 2]                             ; 05BF3  0x8B, 0x47, 0x02
  mov [0x81e], ax                              ; 05BF6  0xA3, 0x1E, 0x08
  mov es, [0x907]                              ; 05BF9  0x8E, 0x06, 0x07, 0x09
  mov [es:0x54], bx                            ; 05BFD  0x26, 0x89, 0x1E, 0x54, 0x00
  push ds                                      ; 05C02  0x1E
  pop es                                       ; 05C03  0x07
  ret                                          ; 05C04  0xC3

loc_05C05:                                     ; 05C05
  mov si, [si]                                 ; 05C05  0x8B, 0x34

loc_05C07:                                     ; 05C07
  mov si, [si]                                 ; 05C07  0x8B, 0x34
  ret                                          ; 05C09  0xC3
  mov_bx_dx                                    ; 05C0A  mov bx, dx
  ret                                          ; 05C0C  0xC3

sub_05C0D:                                     ; 05C0D
  mov al, [di]                                 ; 05C0D  0x8A, 0x05
  xor al, [bx]                                 ; 05C0F  0x32, 0x07
  inc bx                                       ; 05C11  0x43
  inc di                                       ; 05C12  0x47
  and al, 0x7f                                 ; 05C13  0x24, 0x7F
  loope sub_05C0D                              ; 05C15  0xE1, 0xF6
  ret                                          ; 05C17  0xC3

sub_05C18:                                     ; 05C18
  test byte [0x87f], 0x80                      ; 05C18  0xF6, 0x06, 0x7F, 0x08, 0x80
  je loc_05C73                                 ; 05C1D  0x74, 0x54
  cmp word [0x81e], 0                          ; 05C1F  0x83, 0x3E, 0x1E, 0x08, 0x00
  jne loc_05C4F                                ; 05C24  0x75, 0x29
  mov es, [0x907]                              ; 05C26  0x8E, 0x06, 0x07, 0x09
  mov si, [es:0x54]                            ; 05C2A  0x26, 0x8B, 0x36, 0x54, 0x00
  push ds                                      ; 05C2F  0x1E
  pop es                                       ; 05C30  0x07
  or_si_si                                     ; 05C31  or si, si
  je loc_05C3A                                 ; 05C33  0x74, 0x05
  call sub_05BCB                               ; 05C35  0xE8, 0x93, 0xFF
  je loc_05C4F                                 ; 05C38  0x74, 0x15

loc_05C3A:                                     ; 05C3A
  mov si, [0x8dc]                              ; 05C3A  0x8B, 0x36, 0xDC, 0x08

loc_05C3E:                                     ; 05C3E
  or_si_si                                     ; 05C3E  or si, si
  jne loc_05C48                                ; 05C40  0x75, 0x06
  pop bx                                       ; 05C42  0x5B
  mov al, 0xb                                  ; 05C43  0xB0, 0x0B
  jmp near loc_03FD1                           ; 05C45  0xE9, 0x89, 0xE3

loc_05C48:                                     ; 05C48
  call sub_05BCB                               ; 05C48  0xE8, 0x80, 0xFF
  je loc_05C4F                                 ; 05C4B  0x74, 0x02
  jmp short loc_05C3E                          ; 05C4D  0xEB, 0xEF

loc_05C4F:                                     ; 05C4F
  cmp byte [0x85b], 9                          ; 05C4F  0x80, 0x3E, 0x5B, 0x08, 0x09
  jae loc_05C59                                ; 05C54  0x73, 0x03
  call sub_065CA                               ; 05C56  0xE8, 0x71, 0x09

loc_05C59:                                     ; 05C59
  mov ax, 0x8e5                                ; 05C59  0xB8, 0xE5, 0x08
  mov [0x8d5], ax                              ; 05C5C  0xA3, 0xD5, 0x08

loc_05C5F:                                     ; 05C5F
  push word [0x875]                            ; 05C5F  0xFF, 0x36, 0x75, 0x08
  mov byte [0x875], 1                          ; 05C63  0xC6, 0x06, 0x75, 0x08, 0x01
  call sub_05B58                               ; 05C68  0xE8, 0xED, 0xFE
  pop word [0x875]                             ; 05C6B  0x8F, 0x06, 0x75, 0x08
  cmp al, 0xff                                 ; 05C6F  0x3C, 0xFF
  jne loc_05C74                                ; 05C71  0x75, 0x01

loc_05C73:                                     ; 05C73
  ret                                          ; 05C73  0xC3

loc_05C74:                                     ; 05C74
  cmp al, 0xfe                                 ; 05C74  0x3C, 0xFE
  je loc_05C89                                 ; 05C76  0x74, 0x11
  test byte [0x8eb], 0xff                      ; 05C78  0xF6, 0x06, 0xEB, 0x08, 0xFF
  jne loc_05C5F                                ; 05C7D  0x75, 0xE0
  mov bx, [0x8d5]                              ; 05C7F  0x8B, 0x1E, 0xD5, 0x08
  test byte [bx + 2], 0x80                     ; 05C83  0xF6, 0x47, 0x02, 0x80
  je loc_05C5F                                 ; 05C87  0x74, 0xD6

loc_05C89:                                     ; 05C89
  pop bx                                       ; 05C89  0x5B
  mov al, 8                                    ; 05C8A  0xB0, 0x08
  jmp near loc_03FD1                           ; 05C8C  0xE9, 0x42, 0xE3

loc_05C8F:                                     ; 05C8F
  mov cl, 2                                    ; 05C8F  0xB1, 0x02
  call sub_0563C                               ; 05C91  0xE8, 0xA8, 0xF9
  call sub_040A8                               ; 05C94  0xE8, 0x11, 0xE4
  call sub_041C7                               ; 05C97  0xE8, 0x2D, 0xE5
  test byte [0x87f], 0x80                      ; 05C9A  0xF6, 0x06, 0x7F, 0x08, 0x80
  je loc_05C73                                 ; 05C9F  0x74, 0xD2
  mov bx, [0x8b7]                              ; 05CA1  0x8B, 0x1E, 0xB7, 0x08
  mov ax, [0x885]                              ; 05CA5  0xA1, 0x85, 0x08
  cmp [bx + 6], ax                             ; 05CA8  0x39, 0x47, 0x06
  je loc_05CB2                                 ; 05CAB  0x74, 0x05
  mov al, 0xd                                  ; 05CAD  0xB0, 0x0D
  jmp near loc_03FD1                           ; 05CAF  0xE9, 0x1F, 0xE3

loc_05CB2:                                     ; 05CB2
  mov [0x81e], bx                              ; 05CB2  0x89, 0x1E, 0x1E, 0x08
  test byte [0x8d2], 0xff                      ; 05CB6  0xF6, 0x06, 0xD2, 0x08, 0xFF
  jne loc_05CC7                                ; 05CBB  0x75, 0x0A
  test byte [0x8cc], 0x80                      ; 05CBD  0xF6, 0x06, 0xCC, 0x08, 0x80
  je loc_05CC7                                 ; 05CC2  0x74, 0x03
  jmp near sub_05905                           ; 05CC4  0xE9, 0x3E, 0xFC

loc_05CC7:                                     ; 05CC7
  mov al, [0xb21]                              ; 05CC7  0xA0, 0x21, 0x0B
  mov bx, [0xb22]                              ; 05CCA  0x8B, 0x1E, 0x22, 0x0B
  cmp bh, 4                                    ; 05CCE  0x80, 0xFF, 0x04
  jae loc_05CE3                                ; 05CD1  0x73, 0x10
  mov ah, [0x875]                              ; 05CD3  0x8A, 0x26, 0x75, 0x08
  dec ah                                       ; 05CD7  0xFE, 0xCC
  add_al_ah                                    ; 05CD9  add al, ah
  adc bx, 0                                    ; 05CDB  0x83, 0xD3, 0x00
  cmp bh, 4                                    ; 05CDE  0x80, 0xFF, 0x04
  jb loc_05CE9                                 ; 05CE1  0x72, 0x06

loc_05CE3:                                     ; 05CE3
  mov byte [0x80d], 6                          ; 05CE3  0xC6, 0x06, 0x0D, 0x08, 0x06
  ret                                          ; 05CE8  0xC3

loc_05CE9:                                     ; 05CE9
  mov ax, 0x8e5                                ; 05CE9  0xB8, 0xE5, 0x08
  mov [0x8d5], ax                              ; 05CEC  0xA3, 0xD5, 0x08

loc_05CEF:                                     ; 05CEF
  call sub_05B58                               ; 05CEF  0xE8, 0x66, 0xFE
  cmp al, 0xff                                 ; 05CF2  0x3C, 0xFF
  je loc_05D12                                 ; 05CF4  0x74, 0x1C
  cmp al, 0xfe                                 ; 05CF6  0x3C, 0xFE
  jne loc_05D06                                ; 05CF8  0x75, 0x0C
  test byte [0x8d2], 0xff                      ; 05CFA  0xF6, 0x06, 0xD2, 0x08, 0xFF
  je loc_05CEF                                 ; 05CFF  0x74, 0xEE
  mov al, 8                                    ; 05D01  0xB0, 0x08
  jmp near loc_03FD1                           ; 05D03  0xE9, 0xCB, 0xE2

loc_05D06:                                     ; 05D06
  cmp [0x885], di                              ; 05D06  0x39, 0x3E, 0x85, 0x08
  jne loc_05CEF                                ; 05D0A  0x75, 0xE3
  or [0x819], al                               ; 05D0C  0x08, 0x06, 0x19, 0x08
  jmp short loc_05CEF                          ; 05D10  0xEB, 0xDD

loc_05D12:                                     ; 05D12
  mov bx, 0x3038                               ; 05D12  0xBB, 0x38, 0x30
  mov al, [0x819]                              ; 05D15  0xA0, 0x19, 0x08
  cs xlatb                                    ; 05D18
  test byte [0x8d2], 0xff                      ; 05D1A  0xF6, 0x06, 0xD2, 0x08, 0xFF
  jne loc_05D27                                ; 05D1F  0x75, 0x06
  or_al_al                                     ; 05D21  or al, al
  je loc_05D27                                 ; 05D23  0x74, 0x02
  dec al                                       ; 05D25  0xFE, 0xC8

loc_05D27:                                     ; 05D27
  mov dx, [0x81e]                              ; 05D27  0x8B, 0x16, 0x1E, 0x08
  mov word [0x8d5], 0x8e5                      ; 05D2B  0xC7, 0x06, 0xD5, 0x08, 0xE5, 0x08
  xor_ah_ah                                    ; 05D31  xor ah, ah

loc_05D33:                                     ; 05D33
  mov ch, 0                                    ; 05D33  0xB5, 0x00
  push ax                                      ; 05D35  0x50
  push dx                                      ; 05D36  0x52
  call sub_05876                               ; 05D37  0xE8, 0x3C, 0xFB
  pop dx                                       ; 05D3A  0x5A
  pop ax                                       ; 05D3B  0x58
  jne loc_05D47                                ; 05D3C  0x75, 0x09
  cmp [bx + 8], dx                             ; 05D3E  0x39, 0x57, 0x08
  jne loc_05D33                                ; 05D41  0x75, 0xF0
  inc ah                                       ; 05D43  0xFE, 0xC4
  jmp short loc_05D33                          ; 05D45  0xEB, 0xEC

loc_05D47:                                     ; 05D47
  mov_dl_al                                    ; 05D47  mov dl, al
  add_al_ah                                    ; 05D49  add al, ah
  jb loc_05D53                                 ; 05D4B  0x72, 0x06
  cmp [0x8a], al                               ; 05D4D  0x38, 0x06, 0x8A, 0x00
  jae loc_05D58                                ; 05D51  0x73, 0x05

loc_05D53:                                     ; 05D53
  mov al, 0xc                                  ; 05D53  0xB0, 0x0C
  jmp near loc_03FD1                           ; 05D55  0xE9, 0x79, 0xE2

loc_05D58:                                     ; 05D58
  test byte [0x8d2], 0xff                      ; 05D58  0xF6, 0x06, 0xD2, 0x08, 0xFF
  je loc_05D85                                 ; 05D5D  0x74, 0x26
  call sub_05ABA                               ; 05D5F  0xE8, 0x58, 0xFD
  test byte [0x8cc], 0x40                      ; 05D62  0xF6, 0x06, 0xCC, 0x08, 0x40
  jne loc_05D85                                ; 05D67  0x75, 0x1C
  mov ah, [0x875]                              ; 05D69  0x8A, 0x26, 0x75, 0x08

loc_05D6D:                                     ; 05D6D
  push ax                                      ; 05D6D  0x50
  call sub_05AF1                               ; 05D6E  0xE8, 0x80, 0xFD
  pop ax                                       ; 05D71  0x58
  test byte [0x80d], 0xff                      ; 05D72  0xF6, 0x06, 0x0D, 0x08, 0xFF
  je loc_05D7C                                 ; 05D77  0x74, 0x03
  jmp near sub_03EEE                           ; 05D79  0xE9, 0x72, 0xE1

loc_05D7C:                                     ; 05D7C
  dec ah                                       ; 05D7C  0xFE, 0xCC
  je loc_05D85                                 ; 05D7E  0x74, 0x05
  call sub_03F20                               ; 05D80  0xE8, 0x9D, 0xE1
  jmp short loc_05D6D                          ; 05D83  0xEB, 0xE8

loc_05D85:                                     ; 05D85
  call sub_03EEE                               ; 05D85  0xE8, 0x66, 0xE1
  test byte [0x819], 0xf                       ; 05D88  0xF6, 0x06, 0x19, 0x08, 0x0F
  jne loc_05D92                                ; 05D8D  0x75, 0x03
  jmp near loc_05E1D                           ; 05D8F  0xE9, 0x8B, 0x00

loc_05D92:                                     ; 05D92
  mov ax, 0x8e5                                ; 05D92  0xB8, 0xE5, 0x08
  mov [0x8d5], ax                              ; 05D95  0xA3, 0xD5, 0x08

loc_05D98:                                     ; 05D98
  call sub_05B58                               ; 05D98  0xE8, 0xBD, 0xFD
  cmp al, 0xff                                 ; 05D9B  0x3C, 0xFF
  jne loc_05DA2                                ; 05D9D  0x75, 0x03
  jmp near loc_05E1D                           ; 05D9F  0xE9, 0x7B, 0x00

loc_05DA2:                                     ; 05DA2
  cmp [0x885], di                              ; 05DA2  0x39, 0x3E, 0x85, 0x08
  jne loc_05D98                                ; 05DA6  0x75, 0xF0
  test al, 1                                   ; 05DA8  0xA8, 0x01
  je loc_05DB1                                 ; 05DAA  0x74, 0x05
  call sub_058C0                               ; 05DAC  0xE8, 0x11, 0xFB
  jmp short loc_05D98                          ; 05DAF  0xEB, 0xE7

loc_05DB1:                                     ; 05DB1
  test al, 4                                   ; 05DB1  0xA8, 0x04
  je loc_05DD6                                 ; 05DB3  0x74, 0x21
  mov ch, [bx + 3]                             ; 05DB5  0x8A, 0x6F, 0x03
  add ch, [bx + 6]                             ; 05DB8  0x02, 0x6F, 0x06
  mov cl, [0xb21]                              ; 05DBB  0x8A, 0x0E, 0x21, 0x0B
  mov ax, [0xb22]                              ; 05DBF  0xA1, 0x22, 0x0B
  add cl, [0x875]                              ; 05DC2  0x02, 0x0E, 0x75, 0x08
  adc ax, strict word 0                        ; 05DC6  15 00 00
  sub_ch_cl                                    ; 05DC9  sub ch, cl
  mov [bx + 6], ch                             ; 05DCB  0x88, 0x6F, 0x06
  mov [bx + 3], cl                             ; 05DCE  0x88, 0x4F, 0x03
  mov [bx + 4], ax                             ; 05DD1  0x89, 0x47, 0x04
  jmp short loc_05D98                          ; 05DD4  0xEB, 0xC2

loc_05DD6:                                     ; 05DD6
  test al, 8                                   ; 05DD6  0xA8, 0x08
  je loc_05DE6                                 ; 05DD8  0x74, 0x0C
  mov cl, [0xb21]                              ; 05DDA  0x8A, 0x0E, 0x21, 0x0B
  sub cl, [bx + 3]                             ; 05DDE  0x2A, 0x4F, 0x03
  mov [bx + 6], cl                             ; 05DE1  0x88, 0x4F, 0x06
  jmp short loc_05D98                          ; 05DE4  0xEB, 0xB2

loc_05DE6:                                     ; 05DE6
  push bx                                      ; 05DE6  0x53
  call sub_05A80                               ; 05DE7  0xE8, 0x96, 0xFC
  pop si                                       ; 05DEA  0x5E
  mov al, [si + 2]                             ; 05DEB  0x8A, 0x44, 0x02
  mov [bx + 2], al                             ; 05DEE  0x88, 0x47, 0x02
  mov cl, [0xb21]                              ; 05DF1  0x8A, 0x0E, 0x21, 0x0B
  mov ax, [0xb22]                              ; 05DF5  0xA1, 0x22, 0x0B
  add cl, [0x875]                              ; 05DF8  0x02, 0x0E, 0x75, 0x08
  adc ax, strict word 0                        ; 05DFC  15 00 00
  mov [bx + 3], cl                             ; 05DFF  0x88, 0x4F, 0x03
  mov [bx + 4], ax                             ; 05E02  0x89, 0x47, 0x04
  mov ch, [si + 3]                             ; 05E05  0x8A, 0x6C, 0x03
  add ch, [si + 6]                             ; 05E08  0x02, 0x6C, 0x06
  sub_ch_cl                                    ; 05E0B  sub ch, cl
  mov [bx + 6], ch                             ; 05E0D  0x88, 0x6F, 0x06
  mov cl, [0xb21]                              ; 05E10  0x8A, 0x0E, 0x21, 0x0B
  sub cl, [si + 3]                             ; 05E14  0x2A, 0x4C, 0x03
  mov [si + 6], cl                             ; 05E17  0x88, 0x4C, 0x06
  jmp near loc_05D98                           ; 05E1A  0xE9, 0x7B, 0xFF

loc_05E1D:                                     ; 05E1D
  test byte [0x8d2], 0xff                      ; 05E1D  0xF6, 0x06, 0xD2, 0x08, 0xFF
  je loc_05E3F                                 ; 05E22  0x74, 0x1B
  call sub_05A80                               ; 05E24  0xE8, 0x59, 0xFC
  mov al, [0x881]                              ; 05E27  0xA0, 0x81, 0x08
  or al, [0x8cc]                               ; 05E2A  0x0A, 0x06, 0xCC, 0x08
  mov [bx + 2], al                             ; 05E2E  0x88, 0x47, 0x02
  mov si, 0xb21                                ; 05E31  0xBE, 0x21, 0x0B
  mov cx, 3                                    ; 05E34  0xB9, 0x03, 0x00
  rep movsb                                    ; 05E37  0xF3, 0xA4
  mov al, [0x875]                              ; 05E39  0xA0, 0x75, 0x08
  mov [bx + 6], al                             ; 05E3C  0x88, 0x47, 0x06

loc_05E3F:                                     ; 05E3F
  ret                                          ; 05E3F  0xC3

sub_05E40:                                     ; 05E40
  mov ax, [0x815]                              ; 05E40  0xA1, 0x15, 0x08
  cmp ax, [0x8e7]                              ; 05E43  0x3B, 0x06, 0xE7, 0x08
  jae loc_05EAC                                ; 05E47  0x73, 0x63
  call sub_04B60                               ; 05E49  0xE8, 0x14, 0xED
  mov ax, [0x815]                              ; 05E4C  0xA1, 0x15, 0x08
  mov [0x8e7], ax                              ; 05E4F  0xA3, 0xE7, 0x08
  mov ax, 0x8e3                                ; 05E52  0xB8, 0xE3, 0x08
  mov [0x8d5], ax                              ; 05E55  0xA3, 0xD5, 0x08

loc_05E58:                                     ; 05E58
  call sub_04B60                               ; 05E58  0xE8, 0x05, 0xED
  call sub_05860                               ; 05E5B  0xE8, 0x02, 0xFA
  call sub_04B60                               ; 05E5E  0xE8, 0xFF, 0xEC
  mov ch, 3                                    ; 05E61  0xB5, 0x03
  call sub_05876                               ; 05E63  0xE8, 0x10, 0xFA
  jne loc_05EAC                                ; 05E66  0x75, 0x44
  push bx                                      ; 05E68  0x53
  call sub_05860                               ; 05E69  0xE8, 0xF4, 0xF9
  pop bx                                       ; 05E6C  0x5B
  add bx, 3                                    ; 05E6D  0x83, 0xC3, 0x03
  mov dx, 0x882                                ; 05E70  0xBA, 0x82, 0x08
  mov cl, 3                                    ; 05E73  0xB1, 0x03
  call sub_04003                               ; 05E75  0xE8, 0x8B, 0xE1
  jmp short loc_05E58                          ; 05E78  0xEB, 0xDE

sub_05E7A:                                     ; 05E7A
  xor_ax_ax                                    ; 05E7A  xor ax, ax
  mov [0x804], ax                              ; 05E7C  0xA3, 0x04, 0x08
  mov [0x8de], al                              ; 05E7F  0xA2, 0xDE, 0x08
  mov bx, [0x862]                              ; 05E82  0x8B, 0x1E, 0x62, 0x08

sub_05E86:                                     ; 05E86
  cmp word [0x8e3], 0                          ; 05E86  0x83, 0x3E, 0xE3, 0x08, 0x00
  je loc_05EAC                                 ; 05E8B  0x74, 0x1F
  mov al, [0x881]                              ; 05E8D  0xA0, 0x81, 0x08
  push ax                                      ; 05E90  0x50
  mov ch, 0                                    ; 05E91  0xB5, 0x00

loc_05E93:                                     ; 05E93
  shr bx, 1                                    ; 05E93  0xD1, 0xEB
  jb loc_05EAD                                 ; 05E95  0x72, 0x16

loc_05E97:                                     ; 05E97
  inc ch                                       ; 05E97  0xFE, 0xC5
  cmp bx, 0                                    ; 05E99  0x83, 0xFB, 0x00
  jne loc_05E93                                ; 05E9C  0x75, 0xF5
  pop ax                                       ; 05E9E  0x58
  mov [0x881], al                              ; 05E9F  0xA2, 0x81, 0x08
  mov bx, [0x804]                              ; 05EA2  0x8B, 0x1E, 0x04, 0x08
  or [0x802], bx                               ; 05EA6  0x09, 0x1E, 0x02, 0x08
  inc al                                       ; 05EAA  0xFE, 0xC0

loc_05EAC:                                     ; 05EAC
  ret                                          ; 05EAC  0xC3

loc_05EAD:                                     ; 05EAD
  push cx                                      ; 05EAD  0x51
  push bx                                      ; 05EAE  0x53
  mov [0x881], ch                              ; 05EAF  0x88, 0x2E, 0x81, 0x08
  mov_cl_ch                                    ; 05EB3  mov cl, ch
  mov dx, [0x802]                              ; 05EB5  0x8B, 0x16, 0x02, 0x08
  call sub_04247                               ; 05EB9  0xE8, 0x8B, 0xE3
  push dx                                      ; 05EBC  0x52
  mov dx, [0x800]                              ; 05EBD  0x8B, 0x16, 0x00, 0x08
  call sub_04247                               ; 05EC1  0xE8, 0x83, 0xE3
  push dx                                      ; 05EC4  0x52
  mov dx, [0x806]                              ; 05EC5  0x8B, 0x16, 0x06, 0x08
  call sub_04247                               ; 05EC9  0xE8, 0x7B, 0xE3
  pop bx                                       ; 05ECC  0x5B
  or bl, [0x8de]                               ; 05ECD  0x0A, 0x1E, 0xDE, 0x08
  or_bl_dl                                     ; 05ED1  or bl, dl
  pop dx                                       ; 05ED3  0x5A
  or_bl_dl                                     ; 05ED4  or bl, dl
  mov [0x8df], bl                              ; 05ED6  0x88, 0x1E, 0xDF, 0x08
  mov bx, 0x8e3                                ; 05EDA  0xBB, 0xE3, 0x08
  mov [0x8d5], bx                              ; 05EDD  0x89, 0x1E, 0xD5, 0x08

loc_05EE1:                                     ; 05EE1
  mov ch, 1                                    ; 05EE1  0xB5, 0x01
  call sub_05876                               ; 05EE3  0xE8, 0x90, 0xF9
  jne loc_05F0B                                ; 05EE6  0x75, 0x23
  test byte [0x8df], 0xff                      ; 05EE8  0xF6, 0x06, 0xDF, 0x08, 0xFF
  je loc_05F03                                 ; 05EED  0x74, 0x14
  push bx                                      ; 05EEF  0x53
  call sub_05950                               ; 05EF0  0xE8, 0x5D, 0xFA
  je loc_05EFA                                 ; 05EF3  0x74, 0x05
  pop dx                                       ; 05EF5  0x5A
  xor_al_al                                    ; 05EF6  xor al, al
  jmp short loc_05F0B                          ; 05EF8  0xEB, 0x11

loc_05EFA:                                     ; 05EFA
  mov bx, 0x804                                ; 05EFA  0xBB, 0x04, 0x08
  call sub_04233                               ; 05EFD  0xE8, 0x33, 0xE3
  pop bx                                       ; 05F00  0x5B
  jmp short loc_05EE1                          ; 05F01  0xEB, 0xDE

loc_05F03:                                     ; 05F03
  mov bx, 0x862                                ; 05F03  0xBB, 0x62, 0x08
  call sub_058F7                               ; 05F06  0xE8, 0xEE, 0xF9
  or al, 1                                     ; 05F09  0x0C, 0x01

loc_05F0B:                                     ; 05F0B
  pop bx                                       ; 05F0B  0x5B
  pop cx                                       ; 05F0C  0x59
  je loc_05F12                                 ; 05F0D  0x74, 0x03
  jmp near loc_05E97                           ; 05F0F  0xE9, 0x85, 0xFF

loc_05F12:                                     ; 05F12
  pop ax                                       ; 05F12  0x58
  mov [0x881], al                              ; 05F13  0xA2, 0x81, 0x08
  cmp byte [0x874], 0xff                       ; 05F16  0x80, 0x3E, 0x74, 0x08, 0xFF
  je loc_05F2E                                 ; 05F1B  0x74, 0x11
  mov [0x90d], ch                              ; 05F1D  0x88, 0x2E, 0x0D, 0x09
  mov_bx_dx                                    ; 05F21  mov bx, dx
  mov ax, [bx + 6]                             ; 05F23  0x8B, 0x47, 0x06
  mov [0x90e], ax                              ; 05F26  0xA3, 0x0E, 0x09
  mov byte [0x81b], 0xff                       ; 05F29  0xC6, 0x06, 0x1B, 0x08, 0xFF

loc_05F2E:                                     ; 05F2E
  pop bx                                       ; 05F2E  0x5B
  mov word [0x80d], 0xffff                     ; 05F2F  0xC7, 0x06, 0x0D, 0x08, 0xFF, 0xFF
  ret                                          ; 05F35  0xC3
xios_fn_init:
  mov ax, 0xffff                               ; 05F36  0xB8, 0xFF, 0xFF
  mov [0x862], ax                              ; 05F39  0xA3, 0x62, 0x08
  call sub_05E7A                               ; 05F3C  0xE8, 0x3B, 0xFF
  je loc_05F46                                 ; 05F3F  0x74, 0x05
  call sub_065DD                               ; 05F41  0xE8, 0x99, 0x06
  jmp short loc_05F54                          ; 05F44  0xEB, 0x0E

loc_05F46:                                     ; 05F46
  xor_ax_ax                                    ; 05F46  xor ax, ax
  mov [0x806], ax                              ; 05F48  0xA3, 0x06, 0x08
  mov [0x808], ax                              ; 05F4B  0xA3, 0x08, 0x08
  mov [0x800], ax                              ; 05F4E  0xA3, 0x00, 0x08
  mov [0x802], ax                              ; 05F51  0xA3, 0x02, 0x08

loc_05F54:                                     ; 05F54
  xor_al_al                                    ; 05F54  xor al, al
  call sub_05F73                               ; 05F56  0xE8, 0x1A, 0x00
  dec al                                       ; 05F59  0xFE, 0xC8
  mov [0x881], al                              ; 05F5B  0xA2, 0x81, 0x08
  push ds                                      ; 05F5E  0x1E
  mov ds, [0x907]                              ; 05F5F  0x8E, 0x1E, 0x07, 0x09
  mov word [2], 0x80                           ; 05F63  0xC7, 0x06, 0x02, 0x00, 0x80, 0x00
  pop ds                                       ; 05F69  0x1F
  jmp near loc_06700                           ; 05F6A  0xE9, 0x93, 0x07
xios_fn_wboot:
  call sub_05521                               ; 05F6D  0xE8, 0xB1, 0xF5
  mov al, [0x860]                              ; 05F70  0xA0, 0x60, 0x08

sub_05F73:                                     ; 05F73
  mov bx, [0x68]                               ; 05F73  0x8B, 0x1E, 0x68, 0x00
  mov [bx + 0x12], al                          ; 05F77  0x88, 0x47, 0x12
  ret                                          ; 05F7A  0xC3
xios_fn_const:
  call sub_0563A                               ; 05F7B  0xE8, 0xBC, 0xF6
  call sub_0427A                               ; 05F7E  0xE8, 0xF9, 0xE2
  mov byte [0x8c7], 0                          ; 05F81  0xC6, 0x06, 0xC7, 0x08, 0x00
  mov byte [0x8e8], 0xff                       ; 05F86  0xC6, 0x06, 0xE8, 0x08, 0xFF
  mov bx, 0x24d4                               ; 05F8B  0xBB, 0xD4, 0x24
  push bx                                      ; 05F8E  0x53
  mov byte [0x8d1], 0xff                       ; 05F8F  0xC6, 0x06, 0xD1, 0x08, 0xFF
  call sub_041CC                               ; 05F94  0xE8, 0x35, 0xE2
  pop bx                                       ; 05F97  0x5B
  cmp byte [0x87f], 0x60                       ; 05F98  0x80, 0x3E, 0x7F, 0x08, 0x60
  jne loc_05FA4                                ; 05F9D  0x75, 0x05
  call sub_042A5                               ; 05F9F  0xE8, 0x03, 0xE3
  jmp short loc_0600F                          ; 05FA2  0xEB, 0x6B

loc_05FA4:                                     ; 05FA4
  mov al, [0x861]                              ; 05FA4  0xA0, 0x61, 0x08
  mov [0xb00], al                              ; 05FA7  0xA2, 0x00, 0x0B
  mov byte [0x880], 0                          ; 05FAA  0xC6, 0x06, 0x80, 0x08, 0x00
  mov byte [0x8e8], 0xff                       ; 05FAF  0xC6, 0x06, 0xE8, 0x08, 0xFF
  call sub_04224                               ; 05FB4  0xE8, 0x6D, 0xE2
  call sub_04978                               ; 05FB7  0xE8, 0xBE, 0xE9
  call sub_040A8                               ; 05FBA  0xE8, 0xEB, 0xE0
  and al, 0xc0                                 ; 05FBD  0x24, 0xC0
  cmp al, 0xc0                                 ; 05FBF  0x3C, 0xC0
  jne loc_05FC5                                ; 05FC1  0x75, 0x02
  and al, 0x40                                 ; 05FC3  0x24, 0x40

loc_05FC5:                                     ; 05FC5
  mov [0x87f], al                              ; 05FC5  0xA2, 0x7F, 0x08
  mov_ah_al                                    ; 05FC8  mov ah, al
  shr ah, 1                                    ; 05FCA  0xD0, 0xEC
  jne loc_05FD0                                ; 05FCC  0x75, 0x02
  mov ah, 0x80                                 ; 05FCE  0xB4, 0x80

loc_05FD0:                                     ; 05FD0
  mov [0x8cc], ah                              ; 05FD0  0x88, 0x26, 0xCC, 0x08
  and al, 0x80                                 ; 05FD4  0x24, 0x80
  jne loc_05FEC                                ; 05FD6  0x75, 0x14
  cmp byte [0x861], 0                          ; 05FD8  0x80, 0x3E, 0x61, 0x08, 0x00
  je loc_05FEC                                 ; 05FDD  0x74, 0x0D
  mov al, 0xfe                                 ; 05FDF  0xB0, 0xFE
  mov [0x816], al                              ; 05FE1  0xA2, 0x16, 0x08
  inc al                                       ; 05FE4  0xFE, 0xC0
  mov [0x812], al                              ; 05FE6  0xA2, 0x12, 0x08
  mov [0x8ea], al                              ; 05FE9  0xA2, 0xEA, 0x08

loc_05FEC:                                     ; 05FEC
  call sub_04DD5                               ; 05FEC  0xE8, 0xE6, 0xED
  call sub_06023                               ; 05FEF  0xE8, 0x31, 0x00
  xor_al_al                                    ; 05FF2  xor al, al
  xchg [0x812], al                             ; 05FF4  0x86, 0x06, 0x12, 0x08
  test al, al                                  ; 05FF8  0x84, 0xC0
  jne loc_05FFD                                ; 05FFA  0x75, 0x01

loc_05FFC:                                     ; 05FFC
  ret                                          ; 05FFC  0xC3

loc_05FFD:                                     ; 05FFD
  cmp byte [0x816], 0xfe                       ; 05FFD  0x80, 0x3E, 0x16, 0x08, 0xFE
  je loc_05FFC                                 ; 06002  0x74, 0xF8
  call sub_04B60                               ; 06004  0xE8, 0x59, 0xEB
  call sub_042AC                               ; 06007  0xE8, 0xA2, 0xE2
  mov byte [0x87f], 0x60                       ; 0600A  0xC6, 0x06, 0x7F, 0x08, 0x60

loc_0600F:                                     ; 0600F
  xor_al_al                                    ; 0600F  xor al, al
  mov [0xb00], al                              ; 06011  0xA2, 0x00, 0x0B
  mov cl, 0xf                                  ; 06014  0xB1, 0x0F
  call sub_04B79                               ; 06016  0xE8, 0x60, 0xEB
  call sub_04BA1                               ; 06019  0xE8, 0x85, 0xEB
  call sub_04DD8                               ; 0601C  0xE8, 0xB9, 0xED
  call sub_06023                               ; 0601F  0xE8, 0x01, 0x00
  ret                                          ; 06022  0xC3

sub_06023:                                     ; 06023
  call sub_0429E                               ; 06023  0xE8, 0x78, 0xE2
  je loc_05FFC                                 ; 06026  0x74, 0xD4
  mov bx, 0xb20                                ; 06028  0xBB, 0x20, 0x0B
  cmp byte [bx], 0xff                          ; 0602B  0x80, 0x3F, 0xFF
  jne loc_06035                                ; 0602E  0x75, 0x05
  mov al, [0xb0d]                              ; 06030  0xA0, 0x0D, 0x0B
  mov [bx], al                                 ; 06033  0x88, 0x07

loc_06035:                                     ; 06035
  pop bx                                       ; 06035  0x5B
  mov al, [0x87f]                              ; 06036  0xA0, 0x7F, 0x08
  cmp al, 0x60                                 ; 06039  0x3C, 0x60
  je loc_06050                                 ; 0603B  0x74, 0x13
  or_al_al                                     ; 0603D  or al, al
  jne loc_06062                                ; 0603F  0x75, 0x21
  mov bx, 0xb00                                ; 06041  0xBB, 0x00, 0x0B
  call sub_04259                               ; 06044  0xE8, 0x12, 0xE2
  jae loc_06062                                ; 06047  0x73, 0x19
  mov byte [0x8cc], 0x20                       ; 06049  0xC6, 0x06, 0xCC, 0x08, 0x20
  jmp short loc_06062                          ; 0604E  0xEB, 0x12

loc_06050:                                     ; 06050
  mov byte [0x8cc], 0x20                       ; 06050  0xC6, 0x06, 0xCC, 0x08, 0x20
  mov al, [0xb0a]                              ; 06055  0xA0, 0x0A, 0x0B
  and al, 0x80                                 ; 06058  0x24, 0x80
  jne loc_06062                                ; 0605A  0x75, 0x06
  mov [0x87f], al                              ; 0605C  0xA2, 0x7F, 0x08
  jmp near sub_04C05                           ; 0605F  0xE9, 0xA3, 0xEB

loc_06062:                                     ; 06062
  call sub_04224                               ; 06062  0xE8, 0xBF, 0xE1
  call sub_0564E                               ; 06065  0xE8, 0xE6, 0xF5
  test al, 0x80                                ; 06068  0xA8, 0x80
  je loc_060C8                                 ; 0606A  0x74, 0x5C
  call sub_057DE                               ; 0606C  0xE8, 0x6F, 0xF7
  jne loc_0609D                                ; 0606F  0x75, 0x2C
  call sub_057B3                               ; 06071  0xE8, 0x3F, 0xF7
  or_al_al                                     ; 06074  or al, al
  jne loc_0609D                                ; 06076  0x75, 0x25
  test byte [bx], 0xc0                         ; 06078  0xF6, 0x07, 0xC0
  je loc_060C8                                 ; 0607B  0x74, 0x4B
  call sub_04CCE                               ; 0607D  0xE8, 0x4E, 0xEC
  call sub_05655                               ; 06080  0xE8, 0xD2, 0xF5
  jne loc_060A7                                ; 06083  0x75, 0x22
  call sub_04CD5                               ; 06085  0xE8, 0x4D, 0xEC
  je loc_060C7                                 ; 06088  0x74, 0x3D
  call sub_057B5                               ; 0608A  0xE8, 0x28, 0xF7
  or_al_al                                     ; 0608D  or al, al
  jne loc_060C8                                ; 0608F  0x75, 0x37
  mov [bx], al                                 ; 06091  0x88, 0x07
  call sub_0423F                               ; 06093  0xE8, 0xA9, 0xE1
  jne loc_060C8                                ; 06096  0x75, 0x30
  call sub_04746                               ; 06098  0xE8, 0xAB, 0xE6
  jmp short loc_060C8                          ; 0609B  0xEB, 0x2B

loc_0609D:                                     ; 0609D
  call sub_04CCE                               ; 0609D  0xE8, 0x2E, 0xEC
  call sub_05655                               ; 060A0  0xE8, 0xB2, 0xF5
  and al, 0xc0                                 ; 060A3  0x24, 0xC0
  je loc_060C2                                 ; 060A5  0x74, 0x1B

loc_060A7:                                     ; 060A7
  call sub_0573C                               ; 060A7  0xE8, 0x92, 0xF6
  je loc_060C2                                 ; 060AA  0x74, 0x16
  call sub_056A2                               ; 060AC  0xE8, 0xF3, 0xF5
  mov al, [0x8cb]                              ; 060AF  0xA0, 0xCB, 0x08
  and al, 0xc0                                 ; 060B2  0x24, 0xC0
  je loc_060C2                                 ; 060B4  0x74, 0x0C
  test al, 0x80                                ; 060B6  0xA8, 0x80
  je loc_060BD                                 ; 060B8  0x74, 0x03
  jmp near loc_05708                           ; 060BA  0xE9, 0x4B, 0xF6

loc_060BD:                                     ; 060BD
  mov byte [0x880], 0x80                       ; 060BD  0xC6, 0x06, 0x80, 0x08, 0x80

loc_060C2:                                     ; 060C2
  call sub_04CD5                               ; 060C2  0xE8, 0x10, 0xEC
  jne loc_060C8                                ; 060C5  0x75, 0x01

loc_060C7:                                     ; 060C7
  ret                                          ; 060C7  0xC3

loc_060C8:                                     ; 060C8
  call sub_05860                               ; 060C8  0xE8, 0x95, 0xF7
  test byte [0x8cc], 0xa0                      ; 060CB  0xF6, 0x06, 0xCC, 0x08, 0xA0
  je loc_060E3                                 ; 060D0  0x74, 0x11
  call sub_041B8                               ; 060D2  0xE8, 0xE3, 0xE0
  rol al, 1                                    ; 060D5  0xD0, 0xC0
  jae loc_060E3                                ; 060D7  0x73, 0x0A
  mov byte [0x819], 0x80                       ; 060D9  0xC6, 0x06, 0x19, 0x08, 0x80
  mov byte [0x8cc], 0x20                       ; 060DE  0xC6, 0x06, 0xCC, 0x08, 0x20

loc_060E3:                                     ; 060E3
  mov ch, 3                                    ; 060E3  0xB5, 0x03
  call sub_0586C                               ; 060E5  0xE8, 0x84, 0xF7
  je loc_06105                                 ; 060E8  0x74, 0x1B

loc_060EA:                                     ; 060EA
  cmp word [0x52], 0                           ; 060EA  0x83, 0x3E, 0x52, 0x00, 0x00
  jne loc_060F6                                ; 060EF  0x75, 0x05

loc_060F1:                                     ; 060F1
  mov ah, 0xb                                  ; 060F1  0xB4, 0x0B
  jmp near loc_03FD5                           ; 060F3  0xE9, 0xDF, 0xDE

loc_060F6:                                     ; 060F6
  call sub_05A92                               ; 060F6  0xE8, 0x99, 0xF9
  jb loc_06100                                 ; 060F9  0x72, 0x05

loc_060FB:                                     ; 060FB
  mov ah, 0xa                                  ; 060FB  0xB4, 0x0A
  jmp near loc_03FD5                           ; 060FD  0xE9, 0xD5, 0xDE

loc_06100:                                     ; 06100
  call sub_05A54                               ; 06100  0xE8, 0x51, 0xF9
  jmp short loc_06160                          ; 06103  0xEB, 0x5B

loc_06105:                                     ; 06105
  cmp word [bx + 8], -1                        ; 06105  0x83, 0x7F, 0x08, 0xFF
  jne loc_06115                                ; 06109  0x75, 0x0A
  call sub_05950                               ; 0610B  0xE8, 0x42, 0xF8
  jne loc_06154                                ; 0610E  0x75, 0x44
  call sub_05A5C                               ; 06110  0xE8, 0x49, 0xF9
  jmp short loc_06160                          ; 06113  0xEB, 0x4B

loc_06115:                                     ; 06115
  test byte [0x8cc], 0x80                      ; 06115  0xF6, 0x06, 0xCC, 0x08, 0x80
  je loc_06131                                 ; 0611A  0x74, 0x15
  test byte [bx + 5], 0x80                     ; 0611C  0xF6, 0x47, 0x05, 0x80
  je loc_06131                                 ; 06120  0x74, 0x0F
  mov byte [0x880], 0x80                       ; 06122  0xC6, 0x06, 0x80, 0x08, 0x80
  mov byte [0x8cc], 0x20                       ; 06127  0xC6, 0x06, 0xCC, 0x08, 0x20
  mov byte [0x819], 0x80                       ; 0612C  0xC6, 0x06, 0x19, 0x08, 0x80

loc_06131:                                     ; 06131
  mov al, [0x8cc]                              ; 06131  0xA0, 0xCC, 0x08
  or al, [bx + 2]                              ; 06134  0x0A, 0x47, 0x02
  cmp al, [bx + 2]                             ; 06137  0x3A, 0x47, 0x02
  jne loc_06154                                ; 0613A  0x75, 0x18
  and al, 0x80                                 ; 0613C  0x24, 0x80
  jne loc_06159                                ; 0613E  0x75, 0x19
  mov bx, [0x8d7]                              ; 06140  0x8B, 0x1E, 0xD7, 0x08
  mov [0x8d5], bx                              ; 06144  0x89, 0x1E, 0xD5, 0x08
  mov ch, 5                                    ; 06148  0xB5, 0x05
  call sub_05876                               ; 0614A  0xE8, 0x29, 0xF7
  jne loc_060EA                                ; 0614D  0x75, 0x9B

loc_0614F:                                     ; 0614F
  inc word [bx + 8]                            ; 0614F  0xFF, 0x47, 0x08
  jmp short loc_06160                          ; 06152  0xEB, 0x0C

loc_06154:                                     ; 06154
  mov ah, 5                                    ; 06154  0xB4, 0x05
  jmp near loc_03FD5                           ; 06156  0xE9, 0x7C, 0xDE

loc_06159:                                     ; 06159
  call sub_05950                               ; 06159  0xE8, 0xF4, 0xF7
  jne loc_06154                                ; 0615C  0x75, 0xF6
  jmp short loc_0614F                          ; 0615E  0xEB, 0xEF

loc_06160:                                     ; 06160
  test byte [0x8cc], 0x40                      ; 06160  0xF6, 0x06, 0xCC, 0x08, 0x40
  je loc_061BB                                 ; 06165  0x74, 0x54
  mov bx, [0x8d5]                              ; 06167  0x8B, 0x1E, 0xD5, 0x08
  cmp word [bx + 8], 0                         ; 0616B  0x83, 0x7F, 0x08, 0x00
  jne loc_061B0                                ; 0616F  0x75, 0x3F
  mov di, [0x52]                               ; 06171  0x8B, 0x3E, 0x52, 0x00
  or_di_di                                     ; 06175  or di, di
  jne loc_0617C                                ; 06177  0x75, 0x03
  jmp near loc_060F1                           ; 06179  0xE9, 0x75, 0xFF

loc_0617C:                                     ; 0617C
  mov si, [di]                                 ; 0617C  0x8B, 0x35
  or_si_si                                     ; 0617E  or si, si
  jne loc_06185                                ; 06180  0x75, 0x03
  jmp near loc_060F1                           ; 06182  0xE9, 0x6C, 0xFF

loc_06185:                                     ; 06185
  mov ax, [si]                                 ; 06185  0x8B, 0x04
  mov [0x52], ax                               ; 06187  0xA3, 0x52, 0x00
  mov [di + 2], bx                             ; 0618A  0x89, 0x5D, 0x02
  mov al, [0x881]                              ; 0618D  0xA0, 0x81, 0x08
  mov [di + 6], al                             ; 06190  0x88, 0x45, 0x06
  push si                                      ; 06193  0x56
  mov ax, [0x8dc]                              ; 06194  0xA1, 0xDC, 0x08
  mov [0x8dc], di                              ; 06197  0x89, 0x3E, 0xDC, 0x08
  mov cx, 3                                    ; 0619B  0xB9, 0x03, 0x00
  lea di, [di + 7]                             ; 0619E  0x8D, 0x7D, 0x07
  mov si, 0xb01                                ; 061A1  0xBE, 0x01, 0x0B
  rep movsb                                    ; 061A4  0xF3, 0xA4
  pop di                                       ; 061A6  0x5F
  stosw                                        ; 061A7  0xAB
  mov cx, 4                                    ; 061A8  0xB9, 0x04, 0x00
  mov si, 0xb04                                ; 061AB  0xBE, 0x04, 0x0B
  rep movsw                                    ; 061AE  0xF3, 0xA5

loc_061B0:                                     ; 061B0
  mov ax, [0x8d5]                              ; 061B0  0xA1, 0xD5, 0x08
  mov [0xb21], ax                              ; 061B3  0xA3, 0x21, 0x0B
  mov byte [0x80c], 0x23                       ; 061B6  0xC6, 0x06, 0x0C, 0x08, 0x23

loc_061BB:                                     ; 061BB
  test byte [0x8cc], 0x20                      ; 061BB  0xF6, 0x06, 0xCC, 0x08, 0x20
  je loc_061DD                                 ; 061C0  0x74, 0x1B
  test byte [0x819], 0x80                      ; 061C2  0xF6, 0x06, 0x19, 0x08, 0x80
  je loc_061DD                                 ; 061C7  0x74, 0x14
  mov ax, 0x8e3                                ; 061C9  0xB8, 0xE3, 0x08
  mov [0x8d5], ax                              ; 061CC  0xA3, 0xD5, 0x08

loc_061CF:                                     ; 061CF
  mov ch, 3                                    ; 061CF  0xB5, 0x03
  call sub_05876                               ; 061D1  0xE8, 0xA2, 0xF6
  jne loc_061DD                                ; 061D4  0x75, 0x07
  or byte [bx + 5], 0x80                       ; 061D6  0x80, 0x4F, 0x05, 0x80
  jmp near loc_061CF                           ; 061DA  0xE9, 0xF2, 0xFF

loc_061DD:                                     ; 061DD
  mov byte [0x811], 0xff                       ; 061DD  0xC6, 0x06, 0x11, 0x08, 0xFF
  test byte [0x8c7], 0xff                      ; 061E2  0xF6, 0x06, 0xC7, 0x08, 0xFF
  jne loc_0622F                                ; 061E7  0x75, 0x46
  mov cl, 0x40                                 ; 061E9  0xB1, 0x40

sub_061EB:                                     ; 061EB
  call sub_057F4                               ; 061EB  0xE8, 0x06, 0xF6
  jne loc_0622F                                ; 061EE  0x75, 0x3F
  jmp near sub_05806                           ; 061F0  0xE9, 0x13, 0xF6
xios_fn_conin:
  call sub_040A8                               ; 061F3  0xE8, 0xB2, 0xDE
  mov bx, 0x2744                               ; 061F6  0xBB, 0x44, 0x27
  push bx                                      ; 061F9  0x53
  mov byte [0x8d1], 0xff                       ; 061FA  0xC6, 0x06, 0xD1, 0x08, 0xFF
  call sub_041CC                               ; 061FF  0xE8, 0xCA, 0xDF
  pop bx                                       ; 06202  0x5B

loc_06203:                                     ; 06203
  mov byte [0x8e8], 0xff                       ; 06203  0xC6, 0x06, 0xE8, 0x08, 0xFF
  mov al, [0xb0e]                              ; 06208  0xA0, 0x0E, 0x0B
  and al, 0x80                                 ; 0620B  0x24, 0x80
  jne loc_06220                                ; 0620D  0x75, 0x11
  call sub_04EF6                               ; 0620F  0xE8, 0xE4, 0xEC
  jmp short loc_06228                          ; 06212  0xEB, 0x14
  call sub_041B8                               ; 06214  0xE8, 0xA1, 0xDF
  and al, 0x20                                 ; 06217  0x24, 0x20
  jne loc_06203                                ; 06219  0x75, 0xE8
  mov ah, 6                                    ; 0621B  0xB4, 0x06
  jmp near loc_03FD5                           ; 0621D  0xE9, 0xB5, 0xDD

loc_06220:                                     ; 06220
  mov byte [0x8d9], 0xff                       ; 06220  0xC6, 0x06, 0xD9, 0x08, 0xFF
  call sub_04F0A                               ; 06225  0xE8, 0xE2, 0xEC

loc_06228:                                     ; 06228
  cmp byte [0x80d], 0xff                       ; 06228  0x80, 0x3E, 0x0D, 0x08, 0xFF
  jne loc_06230                                ; 0622D  0x75, 0x01

loc_0622F:                                     ; 0622F
  ret                                          ; 0622F  0xC3

loc_06230:                                     ; 06230
  call sub_06776                               ; 06230  0xE8, 0x43, 0x05
  test byte [0x8cc], 0x80                      ; 06233  0xF6, 0x06, 0xCC, 0x08, 0x80
  jne loc_0622F                                ; 06238  0x75, 0xF5
  call sub_05860                               ; 0623A  0xE8, 0x23, 0xF6
  mov ch, 5                                    ; 0623D  0xB5, 0x05
  call sub_0586C                               ; 0623F  0xE8, 0x2A, 0xF6
  jne loc_06286                                ; 06242  0x75, 0x42
  call sub_041B8                               ; 06244  0xE8, 0x71, 0xDF
  and al, 0x40                                 ; 06247  0x24, 0x40
  jne loc_06286                                ; 06249  0x75, 0x3B
  dec word [bx + 8]                            ; 0624B  0xFF, 0x4F, 0x08
  cmp byte [bx + 9], 0xff                      ; 0624E  0x80, 0x7F, 0x09, 0xFF
  jne loc_06286                                ; 06252  0x75, 0x32
  mov byte [bx + 8], 0xff                      ; 06254  0xC6, 0x47, 0x08, 0xFF
  push bx                                      ; 06258  0x53
  call sub_04224                               ; 06259  0xE8, 0xC8, 0xDF
  pop bx                                       ; 0625C  0x5B
  mov [0x81e], bx                              ; 0625D  0x89, 0x1E, 0x1E, 0x08
  mov al, [0x87f]                              ; 06261  0xA0, 0x7F, 0x08
  or_al_al                                     ; 06264  or al, al
  jne loc_06275                                ; 06266  0x75, 0x0D
  test byte [bx + 5], 0x80                     ; 06268  0xF6, 0x47, 0x05, 0x80
  jne loc_06275                                ; 0626C  0x75, 0x07
  mov al, [0x8cc]                              ; 0626E  0xA0, 0xCC, 0x08
  and al, 0x40                                 ; 06271  0x24, 0x40
  jne loc_06286                                ; 06273  0x75, 0x11

loc_06275:                                     ; 06275
  call sub_058C0                               ; 06275  0xE8, 0x48, 0xF6
  test byte [0x87f], 0x80                      ; 06278  0xF6, 0x06, 0x7F, 0x08, 0x80
  je loc_06286                                 ; 0627D  0x74, 0x07
  mov bx, [0x81e]                              ; 0627F  0x8B, 0x1E, 0x1E, 0x08
  call sub_05905                               ; 06283  0xE8, 0x7F, 0xF6

loc_06286:                                     ; 06286
  ret                                          ; 06286  0xC3
xios_fn_conout:
  mov ax, [0x909]                              ; 06287  0xA1, 0x09, 0x09
  mov [0x86e], ax                              ; 0628A  0xA3, 0x6E, 0x08
  mov ax, [0x862]                              ; 0628D  0xA1, 0x62, 0x08
  mov [0x86c], ax                              ; 06290  0xA3, 0x6C, 0x08
  xor_al_al                                    ; 06293  xor al, al

loc_06295:                                     ; 06295
  pushf                                        ; 06295  0x9C
  cmp byte [0xb00], 0x3f                       ; 06296  0x80, 0x3E, 0x00, 0x0B, 0x3F
  jne loc_062A7                                ; 0629B  0x75, 0x0A
  call sub_05525                               ; 0629D  0xE8, 0x85, 0xF2
  call sub_055A7                               ; 062A0  0xE8, 0x04, 0xF3
  xor_cl_cl                                    ; 062A3  xor cl, cl
  jmp short loc_062BC                          ; 062A5  0xEB, 0x15

loc_062A7:                                     ; 062A7
  call sub_05557                               ; 062A7  0xE8, 0xAD, 0xF2
  mov cl, 0xc                                  ; 062AA  0xB1, 0x0C
  mov bx, 0xb0c                                ; 062AC  0xBB, 0x0C, 0x0B
  cmp byte [bx], 0x3f                          ; 062AF  0x80, 0x3F, 0x3F
  je loc_062BC                                 ; 062B2  0x74, 0x08
  call sub_04280                               ; 062B4  0xE8, 0xC9, 0xDF
  call sub_0427A                               ; 062B7  0xE8, 0xC0, 0xDF
  mov cl, 0xf                                  ; 062BA  0xB1, 0x0F

loc_062BC:                                     ; 062BC
  or byte [0x810], 0xf                         ; 062BC  0x80, 0x0E, 0x10, 0x08, 0x0F
  popf                                         ; 062C1  0x9D
  jne loc_062C9                                ; 062C2  0x75, 0x05
  call sub_04B9B                               ; 062C4  0xE8, 0xD4, 0xE8
  jmp short loc_062D3                          ; 062C7  0xEB, 0x0A

loc_062C9:                                     ; 062C9
  mov cl, [0x86b]                              ; 062C9  0x8A, 0x0E, 0x6B, 0x08
  call sub_04B79                               ; 062CD  0xE8, 0xA9, 0xE8
  call sub_04BA1                               ; 062D0  0xE8, 0xCE, 0xE8

loc_062D3:                                     ; 062D3
  cmp byte [0x80d], 0xff                       ; 062D3  0x80, 0x3E, 0x0D, 0x08, 0xFF
  je loc_062F5                                 ; 062D8  0x74, 0x1B
  mov ax, [0x870]                              ; 062DA  0xA1, 0x70, 0x08
  and al, 3                                    ; 062DD  0x24, 0x03
  mov [0x80d], al                              ; 062DF  0xA2, 0x0D, 0x08
  mov dx, [0x88b]                              ; 062E2  0x8B, 0x16, 0x8B, 0x08
  mov bx, [0x866]                              ; 062E6  0x8B, 0x1E, 0x66, 0x08
  mov cl, 0x80                                 ; 062EA  0xB1, 0x80
  push es                                      ; 062EC  0x06
  mov es, [0x868]                              ; 062ED  0x8E, 0x06, 0x68, 0x08
  call sub_04003                               ; 062F1  0xE8, 0x0F, 0xDD
  pop es                                       ; 062F4  0x07

loc_062F5:                                     ; 062F5
  ret                                          ; 062F5  0xC3
xios_fn_list:
  mov ax, [0x86e]                              ; 062F6  0xA1, 0x6E, 0x08
  or ax, [0x86c]                               ; 062F9  0x0B, 0x06, 0x6C, 0x08
  je loc_062F5                                 ; 062FD  0x74, 0xF6
  mov ax, [0x86e]                              ; 062FF  0xA1, 0x6E, 0x08
  mov [0x909], ax                              ; 06302  0xA3, 0x09, 0x09
  mov ax, [0x86c]                              ; 06305  0xA1, 0x6C, 0x08
  mov [0x862], ax                              ; 06308  0xA3, 0x62, 0x08
  call sub_03F04                               ; 0630B  0xE8, 0xF6, 0xDB
  mov word [0x864], 0xb00                      ; 0630E  0xC7, 0x06, 0x64, 0x08, 0x00, 0x0B
  or al, 1                                     ; 06314  0x0C, 0x01
  jmp near loc_06295                           ; 06316  0xE9, 0x7C, 0xFF
xios_fn_auxout:
  call sub_0563A                               ; 06319  0xE8, 0x1E, 0xF3
  jmp near loc_04CE0                           ; 0631C  0xE9, 0xC1, 0xE9
xios_fn_auxin:
  call sub_041C0                               ; 0631F  0xE8, 0x9E, 0xDE
  jmp near loc_05285                           ; 06322  0xE9, 0x60, 0xEF
xios_fn_home:
  call sub_041C0                               ; 06325  0xE8, 0x98, 0xDE
  jmp near loc_0530F                           ; 06328  0xE9, 0xE4, 0xEF
xios_fn_seldsk:
  mov cl, 9                                    ; 0632B  0xB1, 0x09
  call sub_0563C                               ; 0632D  0xE8, 0x0C, 0xF3
  call sub_04280                               ; 06330  0xE8, 0x4D, 0xDF
  call sub_0427A                               ; 06333  0xE8, 0x44, 0xDF
  call sub_05557                               ; 06336  0xE8, 0x1E, 0xF2
  call sub_04224                               ; 06339  0xE8, 0xE8, 0xDE
  mov dl, 1                                    ; 0633C  0xB2, 0x01
  call sub_0497A                               ; 0633E  0xE8, 0x39, 0xE6
  mov word [0x815], 0xffff                     ; 06341  0xC7, 0x06, 0x15, 0x08, 0xFF, 0xFF
  mov byte [0x8e8], 0xff                       ; 06347  0xC6, 0x06, 0xE8, 0x08, 0xFF
  call sub_040A8                               ; 0634C  0xE8, 0x59, 0xDD
  call sub_04DD5                               ; 0634F  0xE8, 0x83, 0xEA
  call sub_04224                               ; 06352  0xE8, 0xCF, 0xDE
  call sub_0429E                               ; 06355  0xE8, 0x46, 0xDF
  je loc_06366                                 ; 06358  0x74, 0x0C
  call sub_040C3                               ; 0635A  0xE8, 0x66, 0xDD
  cmp al, [bx]                                 ; 0635D  0x3A, 0x07
  jb loc_06366                                 ; 0635F  0x72, 0x05
  mov ah, 8                                    ; 06361  0xB4, 0x08
  jmp near loc_03FD5                           ; 06363  0xE9, 0x6F, 0xDC

loc_06366:                                     ; 06366
  pushf                                        ; 06366  0x9C
  call sub_0643D                               ; 06367  0xE8, 0xD3, 0x00
  call sub_057DE                               ; 0636A  0xE8, 0x71, 0xF4
  je loc_0638F                                 ; 0636D  0x74, 0x20
  call sub_0564E                               ; 0636F  0xE8, 0xDC, 0xF2
  and al, 0x80                                 ; 06372  0x24, 0x80
  je loc_0638F                                 ; 06374  0x74, 0x19
  call sub_05655                               ; 06376  0xE8, 0xDC, 0xF2
  and al, 0xc0                                 ; 06379  0x24, 0xC0
  je loc_0638F                                 ; 0637B  0x74, 0x12
  call sub_0577D                               ; 0637D  0xE8, 0xFD, 0xF3
  je loc_0638F                                 ; 06380  0x74, 0x0D
  call sub_056A2                               ; 06382  0xE8, 0x1D, 0xF3
  test byte [0x8cb], 0xc0                      ; 06385  0xF6, 0x06, 0xCB, 0x08, 0xC0
  je loc_0638F                                 ; 0638A  0x74, 0x03
  jmp near loc_05708                           ; 0638C  0xE9, 0x79, 0xF3

loc_0638F:                                     ; 0638F
  popf                                         ; 0638F  0x9D
  jb loc_06395                                 ; 06390  0x72, 0x03
  call sub_04F36                               ; 06392  0xE8, 0xA1, 0xEB

loc_06395:                                     ; 06395
  call sub_04224                               ; 06395  0xE8, 0x8C, 0xDE
  call sub_0429E                               ; 06398  0xE8, 0x03, 0xDF
  jne loc_0639E                                ; 0639B  0x75, 0x01

loc_0639D:                                     ; 0639D
  ret                                          ; 0639D  0xC3

loc_0639E:                                     ; 0639E
  call sub_0564E                               ; 0639E  0xE8, 0xAD, 0xF2
  test al, 0x80                                ; 063A1  0xA8, 0x80
  je loc_06403                                 ; 063A3  0x74, 0x5E
  test byte [0x8cc], 0x40                      ; 063A5  0xF6, 0x06, 0xCC, 0x08, 0x40
  je loc_06403                                 ; 063AA  0x74, 0x57
  call sub_057DE                               ; 063AC  0xE8, 0x2F, 0xF4
  jne loc_06403                                ; 063AF  0x75, 0x52
  call sub_04CCE                               ; 063B1  0xE8, 0x1A, 0xE9
  call sub_05655                               ; 063B4  0xE8, 0x9E, 0xF2
  jne loc_063CC                                ; 063B7  0x75, 0x13
  mov byte [0x813], 0xff                       ; 063B9  0xC6, 0x06, 0x13, 0x08, 0xFF
  call sub_04F36                               ; 063BE  0xE8, 0x75, 0xEB
  jne loc_063CC                                ; 063C1  0x75, 0x09
  call sub_04B95                               ; 063C3  0xE8, 0xCF, 0xE7
  call sub_04D2D                               ; 063C6  0xE8, 0x64, 0xE9
  jmp near sub_04C05                           ; 063C9  0xE9, 0x39, 0xE8

loc_063CC:                                     ; 063CC
  call sub_0567C                               ; 063CC  0xE8, 0xAD, 0xF2
  mov si, 0x8b7                                ; 063CF  0xBE, 0xB7, 0x08
  add si, 8                                    ; 063D2  0x83, 0xC6, 0x08
  lodsb                                        ; 063D5  0xAC
  and al, 0xe0                                 ; 063D6  0x24, 0xE0
  jne loc_063DC                                ; 063D8  0x75, 0x02
  mov al, 0x80                                 ; 063DA  0xB0, 0x80

loc_063DC:                                     ; 063DC
  mov [0x8cb], al                              ; 063DC  0xA2, 0xCB, 0x08
  push ax                                      ; 063DF  0x50
  call sub_0566D                               ; 063E0  0xE8, 0x8A, 0xF2
  pop ax                                       ; 063E3  0x58
  mov [bx], al                                 ; 063E4  0x88, 0x07
  mov si, 0x8b7                                ; 063E6  0xBE, 0xB7, 0x08
  call sub_05783                               ; 063E9  0xE8, 0x97, 0xF3
  call sub_0690C                               ; 063EC  0xE8, 0x1D, 0x05
  call sub_04CD5                               ; 063EF  0xE8, 0xE3, 0xE8
  je loc_0639D                                 ; 063F2  0x74, 0xA9
  call sub_057B3                               ; 063F4  0xE8, 0xBC, 0xF3
  or_al_al                                     ; 063F7  or al, al
  jne loc_06403                                ; 063F9  0x75, 0x08
  mov al, [0x8cb]                              ; 063FB  0xA0, 0xCB, 0x08
  mov [bx], al                                 ; 063FE  0x88, 0x07
  call sub_04746                               ; 06400  0xE8, 0x43, 0xE3

loc_06403:                                     ; 06403
  mov cl, 0x50                                 ; 06403  0xB1, 0x50
  call sub_061EB                               ; 06405  0xE8, 0xE3, 0xFD
  mov cl, 0x20                                 ; 06408  0xB1, 0x20
  call sub_057F4                               ; 0640A  0xE8, 0xE7, 0xF3
  jne loc_06417                                ; 0640D  0x75, 0x08
  call sub_0580A                               ; 0640F  0xE8, 0xF8, 0xF3
  or byte [0xb0e], 0x40                        ; 06412  0x80, 0x0E, 0x0E, 0x0B, 0x40

loc_06417:                                     ; 06417
  mov al, [0x8c7]                              ; 06417  0xA0, 0xC7, 0x08
  mov [0x8cc], al                              ; 0641A  0xA2, 0xCC, 0x08
  and al, 0x40                                 ; 0641D  0x24, 0x40
  shl al, 1                                    ; 0641F  0xD0, 0xE0
  mov [0x87f], al                              ; 06421  0xA2, 0x7F, 0x08
  cmp byte [0x8e8], 0xff                       ; 06424  0x80, 0x3E, 0xE8, 0x08, 0xFF
  jne loc_06437                                ; 06429  0x75, 0x0C
  mov ax, [0x870]                              ; 0642B  0xA1, 0x70, 0x08
  mov [0x8e7], ax                              ; 0642E  0xA3, 0xE7, 0x08
  call sub_05860                               ; 06431  0xE8, 0x2C, 0xF4
  jmp near loc_060F6                           ; 06434  0xE9, 0xBF, 0xFC

loc_06437:                                     ; 06437
  call sub_05E40                               ; 06437  0xE8, 0x06, 0xFA
  jmp near loc_060C8                           ; 0643A  0xE9, 0x8B, 0xFC

sub_0643D:                                     ; 0643D
  mov al, [0x8cc]                              ; 0643D  0xA0, 0xCC, 0x08
  and al, 0x80                                 ; 06440  0x24, 0x80
  shr al, 1                                    ; 06442  0xD0, 0xE8
  jne loc_06448                                ; 06444  0x75, 0x02
  mov al, 0x80                                 ; 06446  0xB0, 0x80

loc_06448:                                     ; 06448
  mov_ch_al                                    ; 06448  mov ch, al
  rol al, 1                                    ; 0644A  0xD0, 0xC0
  jae loc_06457                                ; 0644C  0x73, 0x09
  call sub_041B8                               ; 0644E  0xE8, 0x67, 0xDD
  rol al, 1                                    ; 06451  0xD0, 0xC0
  jae loc_06457                                ; 06453  0x73, 0x02
  mov ch, 0x20                                 ; 06455  0xB5, 0x20

loc_06457:                                     ; 06457
  mov [0x8c7], ch                              ; 06457  0x88, 0x2E, 0xC7, 0x08
  cmp byte [0x8e8], 0xff                       ; 0645B  0x80, 0x3E, 0xE8, 0x08, 0xFF
  je loc_0646C                                 ; 06460  0x74, 0x0A
  call sub_05860                               ; 06462  0xE8, 0xFB, 0xF3
  mov ch, 3                                    ; 06465  0xB5, 0x03
  call sub_0586C                               ; 06467  0xE8, 0x02, 0xF4
  je loc_06476                                 ; 0646A  0x74, 0x0A

loc_0646C:                                     ; 0646C
  cmp word [0x52], 0                           ; 0646C  0x83, 0x3E, 0x52, 0x00, 0x00
  jne loc_0648D                                ; 06471  0x75, 0x1A
  jmp near loc_060F1                           ; 06473  0xE9, 0x7B, 0xFC

loc_06476:                                     ; 06476
  mov al, [0x8c7]                              ; 06476  0xA0, 0xC7, 0x08
  and al, [bx + 2]                             ; 06479  0x22, 0x47, 0x02
  jne loc_06481                                ; 0647C  0x75, 0x03

loc_0647E:                                     ; 0647E
  jmp near loc_06154                           ; 0647E  0xE9, 0xD3, 0xFC

loc_06481:                                     ; 06481
  call sub_05950                               ; 06481  0xE8, 0xCC, 0xF4
  je loc_0648D                                 ; 06484  0x74, 0x07
  test byte [0x8c7], 0x80                      ; 06486  0xF6, 0x06, 0xC7, 0x08, 0x80
  jne loc_0647E                                ; 0648B  0x75, 0xF1

loc_0648D:                                     ; 0648D
  ret                                          ; 0648D  0xC3
xios_fn_settrk:
  call sub_0563A                               ; 0648E  0xE8, 0xA9, 0xF1
  call sub_040A8                               ; 06491  0xE8, 0x14, 0xDC
  call sub_04978                               ; 06494  0xE8, 0xE1, 0xE4
  call sub_05730                               ; 06497  0xE8, 0x96, 0xF2
  je loc_0649F                                 ; 0649A  0x74, 0x03
  call sub_056A2                               ; 0649C  0xE8, 0x03, 0xF2

loc_0649F:                                     ; 0649F
  call sub_04CA5                               ; 0649F  0xE8, 0x03, 0xE8
  call sub_04DCC                               ; 064A2  0xE8, 0x27, 0xE9
  mov [0x864], bx                              ; 064A5  0x89, 0x1E, 0x64, 0x08
  mov dl, 1                                    ; 064A9  0xB2, 0x01
  call sub_0495A                               ; 064AB  0xE8, 0xAC, 0xE4
  mov ah, 9                                    ; 064AE  0xB4, 0x09
  je loc_064BE                                 ; 064B0  0x74, 0x0C
  mov cl, 0xc                                  ; 064B2  0xB1, 0x0C
  call sub_04B80                               ; 064B4  0xE8, 0xC9, 0xE6
  call sub_04B9E                               ; 064B7  0xE8, 0xE4, 0xE6
  je loc_064CB                                 ; 064BA  0x74, 0x0F
  mov ah, 8                                    ; 064BC  0xB4, 0x08

loc_064BE:                                     ; 064BE
  mov byte [0x80c], 0                          ; 064BE  0xC6, 0x06, 0x0C, 0x08, 0x00
  add word [0x862], 0x10                       ; 064C3  0x83, 0x06, 0x62, 0x08, 0x10
  jmp near loc_03FD5                           ; 064C8  0xE9, 0x0A, 0xDB

loc_064CB:                                     ; 064CB
  call sub_04CB0                               ; 064CB  0xE8, 0xE2, 0xE7
  je loc_064D3                                 ; 064CE  0x74, 0x03
  call sub_04D32                               ; 064D0  0xE8, 0x5F, 0xE8

loc_064D3:                                     ; 064D3
  call sub_04DCC                               ; 064D3  0xE8, 0xF6, 0xE8
  call sub_04CA5                               ; 064D6  0xE8, 0xCC, 0xE7
  call sub_04B99                               ; 064D9  0xE8, 0xBD, 0xE6
  jne loc_064DF                                ; 064DC  0x75, 0x01
  ret                                          ; 064DE  0xC3

loc_064DF:                                     ; 064DF
  call sub_04261                               ; 064DF  0xE8, 0x7F, 0xDD
  call sub_0595E                               ; 064E2  0xE8, 0x79, 0xF4

loc_064E5:                                     ; 064E5
  mov cl, 0x10                                 ; 064E5  0xB1, 0x10
  mov dl, 0xc                                  ; 064E7  0xB2, 0x0C
  call sub_04DAD                               ; 064E9  0xE8, 0xC1, 0xE8
  call sub_04B29                               ; 064EC  0xE8, 0x3A, 0xE6
  call sub_04BA1                               ; 064EF  0xE8, 0xAF, 0xE6
  jne loc_064E5                                ; 064F2  0x75, 0xF1
  call sub_04CB0                               ; 064F4  0xE8, 0xB9, 0xE7
  jne loc_064FC                                ; 064F7  0x75, 0x03
  jmp near loc_04952                           ; 064F9  0xE9, 0x56, 0xE4

loc_064FC:                                     ; 064FC
  call sub_04DCC                               ; 064FC  0xE8, 0xCD, 0xE8
  jmp short loc_064E5                          ; 064FF  0xEB, 0xE4
xios_fn_write:
  call sub_05525                               ; 06501  0xE8, 0x21, 0xF0
  mov [0x90b], ds                              ; 06504  0x8C, 0x1E, 0x0B, 0x09
  mov bx, [0x891]                              ; 06508  0x8B, 0x1E, 0x91, 0x08
  jmp short loc_0657E                          ; 0650C  0xEB, 0x70
xios_fn_listst:
  mov byte [0x8de], 1                          ; 0650E  0xC6, 0x06, 0xDE, 0x08, 0x01
  mov cl, [0x860]                              ; 06513  0x8A, 0x0E, 0x60, 0x08
  mov bx, 1                                    ; 06517  0xBB, 0x01, 0x00
  shl bx, cl                                   ; 0651A  0xD3, 0xE3
  call sub_05E86                               ; 0651C  0xE8, 0x67, 0xF9
  mov bx, 0x806                                ; 0651F  0xBB, 0x06, 0x08
  mov cl, [0x860]                              ; 06522  0x8A, 0x0E, 0x60, 0x08
  call sub_04237                               ; 06526  0xE8, 0x0E, 0xDD
  mov dx, [0x8aa]                              ; 06529  0x8B, 0x16, 0xAA, 0x08
  inc dx                                       ; 0652D  0x42
  mov bx, [0x887]                              ; 0652E  0x8B, 0x1E, 0x87, 0x08
  mov [bx], dx                                 ; 06532  0x89, 0x17
  ret                                          ; 06534  0xC3
xios_fn_setdmab:
  call sub_0563A                               ; 06535  0xE8, 0x02, 0xF1
  call sub_04978                               ; 06538  0xE8, 0x3D, 0xE4
  call sub_05557                               ; 0653B  0xE8, 0x19, 0xF0
  call sub_05730                               ; 0653E  0xE8, 0xEF, 0xF1
  je loc_06546                                 ; 06541  0x74, 0x03
  call sub_056A2                               ; 06543  0xE8, 0x5C, 0xF1

loc_06546:                                     ; 06546
  call sub_040A8                               ; 06546  0xE8, 0x5F, 0xDB
  call sub_04B99                               ; 06549  0xE8, 0x4D, 0xE6
  je loc_06582                                 ; 0654C  0x74, 0x34
  call sub_0595E                               ; 0654E  0xE8, 0x0D, 0xF4

loc_06551:                                     ; 06551
  mov cl, 0                                    ; 06551  0xB1, 0x00
  mov dl, 0xc                                  ; 06553  0xB2, 0x0C
  call sub_04DA0                               ; 06555  0xE8, 0x48, 0xE8
  call sub_04003                               ; 06558  0xE8, 0xA8, 0xDA
  test byte [0x8cc], 0x40                      ; 0655B  0xF6, 0x06, 0xCC, 0x08, 0x40
  je loc_06568                                 ; 06560  0x74, 0x06
  mov al, [0xb20]                              ; 06562  0xA0, 0x20, 0x0B
  mov [bx + 0xd], al                           ; 06565  0x88, 0x47, 0x0D

loc_06568:                                     ; 06568
  call sub_04746                               ; 06568  0xE8, 0xDB, 0xE1
  call sub_04BA1                               ; 0656B  0xE8, 0x33, 0xE6
  jne loc_06551                                ; 0656E  0x75, 0xE1
  jmp near loc_04952                           ; 06570  0xE9, 0xDF, 0xE3
xios_fn_getsegt:
  call sub_05525                               ; 06573  0xE8, 0xAF, 0xEF
  mov [0x90b], ds                              ; 06576  0x8C, 0x1E, 0x0B, 0x09
  mov bx, [0x88d]                              ; 0657A  0x8B, 0x1E, 0x8D, 0x08

loc_0657E:                                     ; 0657E
  mov [0x80d], bx                              ; 0657E  0x89, 0x1E, 0x0D, 0x08

loc_06582:                                     ; 06582
  ret                                          ; 06582  0xC3
xios_fn_dealloc:
  call sub_041C0                               ; 06583  0xE8, 0x3A, 0xDC
  mov cl, 0xff                                 ; 06586  0xB1, 0xFF
  call sub_05072                               ; 06588  0xE8, 0xE7, 0xEA
  jne loc_06582                                ; 0658B  0x75, 0xF5
  jmp near loc_05285                           ; 0658D  0xE9, 0xF5, 0xEC
xios_fn_dskreset:
  call sub_041C0                               ; 06590  0xE8, 0x2D, 0xDC
  mov cl, 0                                    ; 06593  0xB1, 0x00
  call sub_05072                               ; 06595  0xE8, 0xDA, 0xEA
  jne loc_06582                                ; 06598  0x75, 0xE8
  jmp near loc_0530F                           ; 0659A  0xE9, 0x72, 0xED
xios_fn_select:
  mov bx, 0xb21                                ; 0659D  0xBB, 0x21, 0x0B
  xor_ax_ax                                    ; 065A0  xor ax, ax
  mov [bx], ax                                 ; 065A2  0x89, 0x07
  mov [bx + 2], al                             ; 065A4  0x88, 0x47, 0x02
  call sub_04B99                               ; 065A7  0xE8, 0xEF, 0xE5
  je loc_065C9                                 ; 065AA  0x74, 0x1D

loc_065AC:                                     ; 065AC
  call sub_0424E                               ; 065AC  0xE8, 0x9F, 0xDC
  mov dx, 0xf                                  ; 065AF  0xBA, 0x0F, 0x00
  call sub_05499                               ; 065B2  0xE8, 0xE4, 0xEE
  call sub_054BD                               ; 065B5  0xE8, 0x05, 0xEF
  jb loc_065BF                                 ; 065B8  0x72, 0x05
  mov [bx + 2], al                             ; 065BA  0x88, 0x47, 0x02
  mov [bx], cx                                 ; 065BD  0x89, 0x0F

loc_065BF:                                     ; 065BF
  call sub_04BA1                               ; 065BF  0xE8, 0xDF, 0xE5
  mov byte [0x80d], 0                          ; 065C2  0xC6, 0x06, 0x0D, 0x08, 0x00
  jne loc_065AC                                ; 065C7  0x75, 0xE3

loc_065C9:                                     ; 065C9
  ret                                          ; 065C9  0xC3

xios_fn_conbrk:
sub_065CA:                                     ; 065CA
  mov bx, 0xb00                                ; 065CA  0xBB, 0x00, 0x0B
  mov dx, 0x20                                 ; 065CD  0xBA, 0x20, 0x00
  call sub_05499                               ; 065D0  0xE8, 0xC6, 0xEE
  mov [bx + 0x21], cx                          ; 065D3  0x89, 0x4F, 0x21
  mov [bx + 0x23], al                          ; 065D6  0x88, 0x47, 0x23
  ret                                          ; 065D9  0xC3
xios_fn_poll:
  call sub_05E7A                               ; 065DA  0xE8, 0x9D, 0xF8

sub_065DD:                                     ; 065DD
  mov ax, [0x862]                              ; 065DD  0xA1, 0x62, 0x08

loc_065E0:                                     ; 065E0
  not ax                                       ; 065E0  0xF7, 0xD0
  and [0x808], ax                              ; 065E2  0x21, 0x06, 0x08, 0x08
  and [0x806], ax                              ; 065E6  0x21, 0x06, 0x06, 0x08
  and [0x800], ax                              ; 065EA  0x21, 0x06, 0x00, 0x08
  mov byte [0x881], 0xff                       ; 065EE  0xC6, 0x06, 0x81, 0x08, 0xFF

loc_065F3:                                     ; 065F3
  ret                                          ; 065F3  0xC3
xios_fn_flag:
  mov word [0x882], 0xffff                     ; 065F4  0xC7, 0x06, 0x82, 0x08, 0xFF, 0xFF
  mov byte [0x884], 0                          ; 065FA  0xC6, 0x06, 0x84, 0x08, 0x00
  xor_al_al                                    ; 065FF  xor al, al

loc_06601:                                     ; 06601
  shl dx, 1                                    ; 06601  0xD1, 0xE2
  adc al, 0                                    ; 06603  0x14, 0x00
  or_dx_dx                                     ; 06605  or dx, dx
  jne loc_06601                                ; 06607  0x75, 0xF8
  or_al_al                                     ; 06609  or al, al
  je loc_065F3                                 ; 0660B  0x74, 0xE6
  mov_dl_al                                    ; 0660D  mov dl, al
  dec al                                       ; 0660F  0xFE, 0xC8
  push ax                                      ; 06611  0x50
  call sub_06619                               ; 06612  0xE8, 0x04, 0x00
  pop ax                                       ; 06615  0x58
  jmp near loc_060F1                           ; 06616  0xE9, 0xD8, 0xFA

sub_06619:                                     ; 06619
  call sub_05ABA                               ; 06619  0xE8, 0x9E, 0xF4
  pop bx                                       ; 0661C  0x5B
  call sub_05A92                               ; 0661D  0xE8, 0x72, 0xF4
  pop bx                                       ; 06620  0x5B
  add bl, [0x8da]                              ; 06621  0x02, 0x1E, 0xDA, 0x08
  jb loc_06650                                 ; 06625  0x72, 0x29
  sub bl, [0x8b]                               ; 06627  0x2A, 0x1E, 0x8B, 0x00
  jae loc_06650                                ; 0662B  0x73, 0x23
  mov bx, [0x862]                              ; 0662D  0x8B, 0x1E, 0x62, 0x08
  mov al, [0x881]                              ; 06631  0xA0, 0x81, 0x08
  push ax                                      ; 06634  0x50
  mov al, 0x10                                 ; 06635  0xB0, 0x10

loc_06637:                                     ; 06637
  dec al                                       ; 06637  0xFE, 0xC8
  shl bx, 1                                    ; 06639  0xD1, 0xE3
  jae loc_06647                                ; 0663B  0x73, 0x0A
  push ax                                      ; 0663D  0x50
  push bx                                      ; 0663E  0x53
  mov [0x881], al                              ; 0663F  0xA2, 0x81, 0x08
  call sub_05A54                               ; 06642  0xE8, 0x0F, 0xF4
  pop bx                                       ; 06645  0x5B
  pop ax                                       ; 06646  0x58

loc_06647:                                     ; 06647
  or_al_al                                     ; 06647  or al, al
  jne loc_06637                                ; 06649  0x75, 0xEC
  pop ax                                       ; 0664B  0x58
  mov [0x881], al                              ; 0664C  0xA2, 0x81, 0x08
  ret                                          ; 0664F  0xC3

loc_06650:                                     ; 06650
  jmp near loc_060FB                           ; 06650  0xE9, 0xA8, 0xFA
xios_fn_tick:
  test word [0x8e3], 0xffff                    ; 06653  0xF7, 0x06, 0xE3, 0x08, 0xFF, 0xFF
  je loc_066A0                                 ; 06659  0x74, 0x45
  mov byte [0x8d3], 0                          ; 0665B  0xC6, 0x06, 0xD3, 0x08, 0x00
  mov bx, [0x862]                              ; 06660  0x8B, 0x1E, 0x62, 0x08
  cmp bx, -1                                   ; 06664  0x83, 0xFB, 0xFF
  jne loc_06673                                ; 06667  0x75, 0x0A
  mov byte [0x8d4], 0                          ; 06669  0xC6, 0x06, 0xD4, 0x08, 0x00
  call sub_05A07                               ; 0666E  0xE8, 0x96, 0xF3
  jmp short loc_06696                          ; 06671  0xEB, 0x23

loc_06673:                                     ; 06673
  mov byte [0x8d4], 1                          ; 06673  0xC6, 0x06, 0xD4, 0x08, 0x01
  mov al, [0x881]                              ; 06678  0xA0, 0x81, 0x08
  push ax                                      ; 0667B  0x50
  mov al, 0x10                                 ; 0667C  0xB0, 0x10

loc_0667E:                                     ; 0667E
  dec al                                       ; 0667E  0xFE, 0xC8
  shl bx, 1                                    ; 06680  0xD1, 0xE3
  jae loc_0668E                                ; 06682  0x73, 0x0A
  push ax                                      ; 06684  0x50
  push bx                                      ; 06685  0x53
  mov [0x881], al                              ; 06686  0xA2, 0x81, 0x08
  call sub_05A07                               ; 06689  0xE8, 0x7B, 0xF3
  pop bx                                       ; 0668C  0x5B
  pop ax                                       ; 0668D  0x58

loc_0668E:                                     ; 0668E
  or_al_al                                     ; 0668E  or al, al
  jne loc_0667E                                ; 06690  0x75, 0xEC
  pop ax                                       ; 06692  0x58
  mov [0x881], al                              ; 06693  0xA2, 0x81, 0x08

loc_06696:                                     ; 06696
  cmp byte [0x8d3], 0xff                       ; 06696  0x80, 0x3E, 0xD3, 0x08, 0xFF
  jne loc_066A0                                ; 0669B  0x75, 0x03
  call sub_059BA                               ; 0669D  0xE8, 0x1A, 0xF3

loc_066A0:                                     ; 066A0
  jmp short loc_06700                          ; 066A0  0xEB, 0x5E
xios_fn_timedate:
  call sub_041C0                               ; 066A2  0xE8, 0x1B, 0xDB
  mov cl, 0                                    ; 066A5  0xB1, 0x00
  call sub_05072                               ; 066A7  0xE8, 0xC8, 0xE9
  je loc_066AD                                 ; 066AA  0x74, 0x01
  ret                                          ; 066AC  0xC3

loc_066AD:                                     ; 066AD
  jmp near loc_0530F                           ; 066AD  0xE9, 0x5F, 0xEC
xios_fn_delay:
  mov byte [0x8d2], 0xff                       ; 066B0  0xC6, 0x06, 0xD2, 0x08, 0xFF
  jmp near loc_05C8F                           ; 066B5  0xE9, 0xD7, 0xF5
xios_fn_stop:
  mov byte [0x8d2], 0                          ; 066B8  0xC6, 0x06, 0xD2, 0x08, 0x00
  jmp near loc_05C8F                           ; 066BD  0xE9, 0xCF, 0xF5
xios_fn_ext32:
  call sub_05521                               ; 066C0  0xE8, 0x5E, 0xEE
  mov si, [0x891]                              ; 066C3  0x8B, 0x36, 0x91, 0x08
  call sub_04814                               ; 066C7  0xE8, 0x4A, 0xE1
  xor_cx_cx                                    ; 066CA  xor cx, cx

loc_066CC:                                     ; 066CC
  lodsb                                        ; 066CC  0xAC

loc_066CD:                                     ; 066CD
  or_al_al                                     ; 066CD  or al, al
  je loc_066D8                                 ; 066CF  0x74, 0x07

loc_066D1:                                     ; 066D1
  shr al, 1                                    ; 066D1  0xD0, 0xE8
  jae loc_066D1                                ; 066D3  0x73, 0xFC
  inc cx                                       ; 066D5  0x41
  jmp short loc_066CD                          ; 066D6  0xEB, 0xF5

loc_066D8:                                     ; 066D8
  dec bx                                       ; 066D8  0x4B
  jne loc_066CC                                ; 066D9  0x75, 0xF1
  mov bx, [0x8a8]                              ; 066DB  0x8B, 0x1E, 0xA8, 0x08
  inc bx                                       ; 066DF  0x43
  sub_bx_cx                                    ; 066E0  sub bx, cx
  mov cl, [0x8a5]                              ; 066E2  0x8A, 0x0E, 0xA5, 0x08
  xor_ch_ch                                    ; 066E6  xor ch, ch
  mov_al_bh                                    ; 066E8  mov al, bh
  xor_ah_ah                                    ; 066EA  xor ah, ah
  shl bx, cl                                   ; 066EC  0xD3, 0xE3
  shl ax, cl                                   ; 066EE  0xD3, 0xE0
  mov di, [0x866]                              ; 066F0  0x8B, 0x3E, 0x66, 0x08
  push ds                                      ; 066F4  0x1E
  mov ds, [0x868]                              ; 066F5  0x8E, 0x1E, 0x68, 0x08
  mov [di], bx                                 ; 066F9  0x89, 0x1D
  mov [di + 2], ah                             ; 066FB  0x88, 0x65, 0x02
  pop ds                                       ; 066FE  0x1F
  ret                                          ; 066FF  0xC3

xios_fn_ext33:
loc_06700:                                     ; 06700
  cmp byte [0x85b], 0x1a                       ; 06700  0x80, 0x3E, 0x5B, 0x08, 0x1A
  je sub_0670F                                 ; 06705  0x74, 0x08
  mov al, 0xc                                  ; 06707  0xB0, 0x0C
  call sub_03F49                               ; 06709  0xE8, 0x3D, 0xD8
  call sub_0432A                               ; 0670C  0xE8, 0x1B, 0xDC

xios_fn_ext36:
sub_0670F:                                     ; 0670F
  mov bx, [0x808]                              ; 0670F  0x8B, 0x1E, 0x08, 0x08
  mov dl, 0x10                                 ; 06713  0xB2, 0x10

loc_06715:                                     ; 06715
  dec dl                                       ; 06715  0xFE, 0xCA
  shl bx, 1                                    ; 06717  0xD1, 0xE3
  jb loc_06720                                 ; 06719  0x72, 0x05

loc_0671B:                                     ; 0671B
  or_bx_bx                                     ; 0671B  or bx, bx
  jne loc_06715                                ; 0671D  0x75, 0xF6
  ret                                          ; 0671F  0xC3

loc_06720:                                     ; 06720
  push bx                                      ; 06720  0x53
  push dx                                      ; 06721  0x52
  call sub_05521                               ; 06722  0xE8, 0xFC, 0xED
  cmp byte [0x85b], 0x24                       ; 06725  0x80, 0x3E, 0x5B, 0x08, 0x24
  jne loc_0673F                                ; 0672A  0x75, 0x13
  mov ch, 1                                    ; 0672C  0xB5, 0x01
  call sub_0586C                               ; 0672E  0xE8, 0x3B, 0xF1
  je loc_06738                                 ; 06731  0x74, 0x05
  call sub_0481E                               ; 06733  0xE8, 0xE8, 0xE0
  jmp short loc_06771                          ; 06736  0xEB, 0x39

loc_06738:                                     ; 06738
  mov byte [0x80d], 0xff                       ; 06738  0xC6, 0x06, 0x0D, 0x08, 0xFF
  jmp short loc_06771                          ; 0673D  0xEB, 0x32

loc_0673F:                                     ; 0673F
  cmp byte [0x85b], 0x1a                       ; 0673F  0x80, 0x3E, 0x5B, 0x08, 0x1A
  je loc_06763                                 ; 06744  0x74, 0x1D
  cmp byte [0x85b], 0x2e                       ; 06746  0x80, 0x3E, 0x5B, 0x08, 0x2E
  je loc_06759                                 ; 0674B  0x74, 0x0C
  call sub_0677E                               ; 0674D  0xE8, 0x2E, 0x00
  cmp byte [0x8ee], 0xff                       ; 06750  0x80, 0x3E, 0xEE, 0x08, 0xFF
  jne loc_06771                                ; 06755  0x75, 0x1A
  jmp short loc_0676A                          ; 06757  0xEB, 0x11

loc_06759:                                     ; 06759
  mov ch, 1                                    ; 06759  0xB5, 0x01
  call sub_0586C                               ; 0675B  0xE8, 0x0E, 0xF1
  je loc_06763                                 ; 0675E  0x74, 0x03
  call sub_0481E                               ; 06760  0xE8, 0xBB, 0xE0

loc_06763:                                     ; 06763
  mov bx, [0x893]                              ; 06763  0x8B, 0x1E, 0x93, 0x08
  call sub_043BD                               ; 06767  0xE8, 0x53, 0xDC

loc_0676A:                                     ; 0676A
  mov bx, [0x895]                              ; 0676A  0x8B, 0x1E, 0x95, 0x08
  call sub_043BD                               ; 0676E  0xE8, 0x4C, 0xDC

loc_06771:                                     ; 06771
  pop dx                                       ; 06771  0x5A
  pop bx                                       ; 06772  0x5B
  jmp near loc_0671B                           ; 06773  0xE9, 0xA5, 0xFF

sub_06776:                                     ; 06776
  mov al, 0xc                                  ; 06776  0xB0, 0x0C
  call sub_03F49                               ; 06778  0xE8, 0xCE, 0xD7
  call sub_0432A                               ; 0677B  0xE8, 0xAC, 0xDB

sub_0677E:                                     ; 0677E
  test byte [0x8b3], 0xff                      ; 0677E  0xF6, 0x06, 0xB3, 0x08, 0xFF
  jne loc_06786                                ; 06783  0x75, 0x01

loc_06785:                                     ; 06785
  ret                                          ; 06785  0xC3

loc_06786:                                     ; 06786
  mov ah, 4                                    ; 06786  0xB4, 0x04
  jmp near sub_045A9                           ; 06788  0xE9, 0x1E, 0xDE

sub_0678B:                                     ; 0678B
  cmp byte [0x816], 0xfd                       ; 0678B  0x80, 0x3E, 0x16, 0x08, 0xFD
  jne loc_06785                                ; 06790  0x75, 0xF3
  jmp near sub_04B72                           ; 06792  0xE9, 0xDD, 0xE3
xios_fn_ext37:
  call sub_0563A                               ; 06795  0xE8, 0xA2, 0xEE
  call sub_05557                               ; 06798  0xE8, 0xBC, 0xED
  call sub_04978                               ; 0679B  0xE8, 0xDA, 0xE1
  call sub_05730                               ; 0679E  0xE8, 0x8F, 0xEF
  je loc_067A6                                 ; 067A1  0x74, 0x03
  call sub_056A2                               ; 067A3  0xE8, 0xFC, 0xEE

loc_067A6:                                     ; 067A6
  call sub_040A8                               ; 067A6  0xE8, 0xFF, 0xD8
  mov cl, 0xff                                 ; 067A9  0xB1, 0xFF
  call sub_05072                               ; 067AB  0xE8, 0xC4, 0xE8
  je loc_067B3                                 ; 067AE  0x74, 0x03

loc_067B0:                                     ; 067B0
  jmp near sub_04C05                           ; 067B0  0xE9, 0x52, 0xE4

loc_067B3:                                     ; 067B3
  call sub_04746                               ; 067B3  0xE8, 0x90, 0xDF
  call sub_0424E                               ; 067B6  0xE8, 0x95, 0xDA
  mov dx, 0xf                                  ; 067B9  0xBA, 0x0F, 0x00
  call sub_05499                               ; 067BC  0xE8, 0xDA, 0xEC
  call sub_054BD                               ; 067BF  0xE8, 0xFB, 0xEC
  jbe loc_067B0                                ; 067C2  0x76, 0xEC
  call sub_04B99                               ; 067C4  0xE8, 0xD2, 0xE3
  je loc_067B0                                 ; 067C7  0x74, 0xE7
  call sub_04261                               ; 067C9  0xE8, 0x95, 0xDA
  call sub_0595E                               ; 067CC  0xE8, 0x8F, 0xF1
  mov byte [0x816], 0xfd                       ; 067CF  0xC6, 0x06, 0x16, 0x08, 0xFD

loc_067D4:                                     ; 067D4
  call sub_0424E                               ; 067D4  0xE8, 0x77, 0xDA
  add bx, 0xc                                  ; 067D7  0x83, 0xC3, 0x0C
  mov si, 0xb0c                                ; 067DA  0xBE, 0x0C, 0x0B
  mov al, [si + 2]                             ; 067DD  0x8A, 0x44, 0x02
  and al, 0x3f                                 ; 067E0  0x24, 0x3F
  cmp [bx + 2], al                             ; 067E2  0x38, 0x47, 0x02
  jne loc_067F4                                ; 067E5  0x75, 0x0D
  mov al, [bx]                                 ; 067E7  0x8A, 0x07
  mov cl, [si]                                 ; 067E9  0x8A, 0x0C
  call sub_04105                               ; 067EB  0xE8, 0x17, 0xD9
  je loc_067F4                                 ; 067EE  0x74, 0x04
  mov al, [bx]                                 ; 067F0  0x8A, 0x07
  cmp_al_cl                                    ; 067F2  cmp al, cl

loc_067F4:                                     ; 067F4
  jae loc_067FB                                ; 067F4  0x73, 0x05
  call sub_0678B                               ; 067F6  0xE8, 0x92, 0xFF
  jmp short loc_06810                          ; 067F9  0xEB, 0x15

loc_067FB:                                     ; 067FB
  pushf                                        ; 067FB  0x9C
  mov cl, 0                                    ; 067FC  0xB1, 0x00
  call sub_0487E                               ; 067FE  0xE8, 0x7D, 0xE0
  popf                                         ; 06801  0x9D
  je loc_06828                                 ; 06802  0x74, 0x24
  call sub_0424E                               ; 06804  0xE8, 0x47, 0xDA
  mov byte [bx], 0xe5                          ; 06807  0xC6, 0x07, 0xE5
  call sub_04746                               ; 0680A  0xE8, 0x39, 0xDF
  call sub_04B29                               ; 0680D  0xE8, 0x19, 0xE3

loc_06810:                                     ; 06810
  call sub_04BA1                               ; 06810  0xE8, 0x8E, 0xE3
  jne loc_067D4                                ; 06813  0x75, 0xBF
  call sub_05834                               ; 06815  0xE8, 0x1C, 0xF0
  mov ch, 5                                    ; 06818  0xB5, 0x05
  call sub_0586C                               ; 0681A  0xE8, 0x4F, 0xF0
  jne loc_06825                                ; 0681D  0x75, 0x06
  mov ax, [0x815]                              ; 0681F  0xA1, 0x15, 0x08
  mov [bx + 3], ax                             ; 06822  0x89, 0x47, 0x03

loc_06825:                                     ; 06825
  jmp near loc_04952                           ; 06825  0xE9, 0x2A, 0xE1

loc_06828:                                     ; 06828
  call sub_0678B                               ; 06828  0xE8, 0x60, 0xFF
  call sub_04116                               ; 0682B  0xE8, 0xE8, 0xD8
  call sub_04067                               ; 0682E  0xE8, 0x36, 0xD8
  inc al                                       ; 06831  0xFE, 0xC0
  test byte [0x8f0], 0xff                      ; 06833  0xF6, 0x06, 0xF0, 0x08, 0xFF
  jne loc_0683C                                ; 06838  0x75, 0x02
  shl al, 1                                    ; 0683A  0xD0, 0xE0

loc_0683C:                                     ; 0683C
  mov di, 0xb10                                ; 0683C  0xBF, 0x10, 0x0B
  xor_ah_ah                                    ; 0683F  xor ah, ah
  add_di_ax                                    ; 06841  add di, ax
  mov cl, 0x10                                 ; 06843  0xB1, 0x10
  sub_cl_al                                    ; 06845  sub cl, al
  mov_ch_ah                                    ; 06847  mov ch, ah
  mov_al_ah                                    ; 06849  mov al, ah
  rep stosb                                    ; 0684B  0xF3, 0xAA
  call sub_040C3                               ; 0684D  0xE8, 0x73, 0xD8
  cmp al, [bx]                                 ; 06850  0x3A, 0x07
  mov [bx], al                                 ; 06852  0x88, 0x07
  pushf                                        ; 06854  0x9C
  mov al, [0xb20]                              ; 06855  0xA0, 0x20, 0x0B
  inc al                                       ; 06858  0xFE, 0xC0
  mov si, 0xb0f                                ; 0685A  0xBE, 0x0F, 0x0B
  mov [si], al                                 ; 0685D  0x88, 0x04
  popf                                         ; 0685F  0x9D
  je loc_06865                                 ; 06860  0x74, 0x03
  call sub_04E17                               ; 06862  0xE8, 0xB2, 0xE5

loc_06865:                                     ; 06865
  test byte [0x8ef], 0xff                      ; 06865  0xF6, 0x06, 0xEF, 0x08, 0xFF
  jne loc_0686F                                ; 0686A  0x75, 0x03
  call sub_04E17                               ; 0686C  0xE8, 0xA8, 0xE5

loc_0686F:                                     ; 0686F
  call sub_0424E                               ; 0686F  0xE8, 0xDC, 0xD9
  add bx, 0xb                                  ; 06872  0x83, 0xC3, 0x0B
  and byte [bx], 0x7f                          ; 06875  0x80, 0x27, 0x7F
  mov al, [0xb0c]                              ; 06878  0xA0, 0x0C, 0x0B
  mov [bx + 1], al                             ; 0687B  0x88, 0x47, 0x01
  add bx, 4                                    ; 0687E  0x83, 0xC3, 0x04
  mov si, 0xb0f                                ; 06881  0xBE, 0x0F, 0x0B
  mov_di_bx                                    ; 06884  mov di, bx
  mov cx, 0x11                                 ; 06886  0xB9, 0x11, 0x00
  rep movsb                                    ; 06889  0xF3, 0xA4
  mov cl, 1                                    ; 0688B  0xB1, 0x01
  call sub_0487E                               ; 0688D  0xE8, 0xEE, 0xDF
  call sub_04746                               ; 06890  0xE8, 0xB3, 0xDE
  jmp near loc_06810                           ; 06893  0xE9, 0x7A, 0xFF
xios_fn_ext38:
  mov cl, 0x10                                 ; 06896  0xB1, 0x10
  call sub_0563C                               ; 06898  0xE8, 0xA1, 0xED
  call sub_05557                               ; 0689B  0xE8, 0xB9, 0xEC
  mov byte [0xb00], 0x21                       ; 0689E  0xC6, 0x06, 0x00, 0x0B, 0x21
  mov cl, 1                                    ; 068A3  0xB1, 0x01
  call sub_04B9B                               ; 068A5  0xE8, 0xF3, 0xE2
  jne loc_068B5                                ; 068A8  0x75, 0x0B
  mov bx, 0xb0c                                ; 068AA  0xBB, 0x0C, 0x0B
  test byte [bx], 0x70                         ; 068AD  0xF6, 0x07, 0x70
  je loc_068B5                                 ; 068B0  0x74, 0x03
  jmp near sub_04C05                           ; 068B2  0xE9, 0x50, 0xE3

loc_068B5:                                     ; 068B5
  mov byte [0xb00], 0x20                       ; 068B5  0xC6, 0x06, 0x00, 0x0B, 0x20
  mov cl, 1                                    ; 068BA  0xB1, 0x01
  mov word [0x815], 0xffff                     ; 068BC  0xC7, 0x06, 0x15, 0x08, 0xFF, 0xFF
  call sub_04B9B                               ; 068C2  0xE8, 0xD6, 0xE2
  jne loc_068DE                                ; 068C5  0x75, 0x17
  mov byte [0x813], 0xff                       ; 068C7  0xC6, 0x06, 0x13, 0x08, 0xFF
  call sub_04F36                               ; 068CC  0xE8, 0x67, 0xE6
  jne loc_068D2                                ; 068CF  0x75, 0x01
  ret                                          ; 068D1  0xC3

loc_068D2:                                     ; 068D2
  call sub_0567C                               ; 068D2  0xE8, 0xA7, 0xED
  mov cx, 0x18                                 ; 068D5  0xB9, 0x18, 0x00
  call sub_05829                               ; 068D8  0xE8, 0x4E, 0xEF
  call sub_05806                               ; 068DB  0xE8, 0x28, 0xEF

loc_068DE:                                     ; 068DE
  mov cx, 0x1c                                 ; 068DE  0xB9, 0x1C, 0x00
  call sub_05829                               ; 068E1  0xE8, 0x45, 0xEF
  call sub_0580A                               ; 068E4  0xE8, 0x23, 0xEF
  call sub_0577A                               ; 068E7  0xE8, 0x90, 0xEE
  je loc_068EF                                 ; 068EA  0x74, 0x03
  jmp near loc_05708                           ; 068EC  0xE9, 0x19, 0xEE

loc_068EF:                                     ; 068EF
  xor_cx_cx                                    ; 068EF  xor cx, cx
  call sub_05682                               ; 068F1  0xE8, 0x8E, 0xED
  mov_si_dx                                    ; 068F4  mov si, dx
  lodsb                                        ; 068F6  0xAC
  or al, 1                                     ; 068F7  0x0C, 0x01
  mov [bx], al                                 ; 068F9  0x88, 0x07
  mov di, [0x889]                              ; 068FB  0x8B, 0x3E, 0x89, 0x08
  stosb                                        ; 068FF  0xAA

sub_06900:                                     ; 06900
  dec si                                       ; 06900  0x4E
  lodsb                                        ; 06901  0xAC
  and al, 1                                    ; 06902  0x24, 0x01
  je sub_0690C                                 ; 06904  0x74, 0x06
  mov si, 0x8bf                                ; 06906  0xBE, 0xBF, 0x08
  call sub_05783                               ; 06909  0xE8, 0x77, 0xEE

sub_0690C:                                     ; 0690C
  call sub_04746                               ; 0690C  0xE8, 0x37, 0xDE
  jmp near sub_04B29                           ; 0690F  0xE9, 0x17, 0xE2
xios_fn_ext39:
  call sub_05521                               ; 06912  0xE8, 0x0C, 0xEC
  call sub_0564E                               ; 06915  0xE8, 0x36, 0xED
  jmp near loc_03FD1                           ; 06918  0xE9, 0xB6, 0xD6
xios_fn_ext40:
  call sub_05557                               ; 0691B  0xE8, 0x39, 0xEC
  call sub_04978                               ; 0691E  0xE8, 0x57, 0xE0
  call sub_04B8D                               ; 06921  0xE8, 0x69, 0xE2
  je loc_06974                                 ; 06924  0x74, 0x4E
  mov ch, 0                                    ; 06926  0xB5, 0x00
  call sub_057B5                               ; 06928  0xE8, 0x8A, 0xEE
  or_al_al                                     ; 0692B  or al, al
  jne loc_06942                                ; 0692D  0x75, 0x13
  push bx                                      ; 0692F  0x53
  mov di, 0xb10                                ; 06930  0xBF, 0x10, 0x0B
  mov cx, 8                                    ; 06933  0xB9, 0x08, 0x00
  rep stosb                                    ; 06936  0xF3, 0xAA
  pop si                                       ; 06938  0x5E
  mov cl, 4                                    ; 06939  0xB1, 0x04
  rep movsw                                    ; 0693B  0xF3, 0xA5
  lodsb                                        ; 0693D  0xAC
  mov [0xb0c], al                              ; 0693E  0xA2, 0x0C, 0x0B
  ret                                          ; 06941  0xC3

loc_06942:                                     ; 06942
  call sub_05655                               ; 06942  0xE8, 0x10, 0xED
  mov al, 0xff                                 ; 06945  0xB0, 0xFF
  jne loc_0694C                                ; 06947  0x75, 0x03
  jmp near loc_03FD1                           ; 06949  0xE9, 0x85, 0xD6

loc_0694C:                                     ; 0694C
  mov bx, 0xb00                                ; 0694C  0xBB, 0x00, 0x0B
  mov cl, 0x20                                 ; 0694F  0xB1, 0x20
  jmp near sub_04003                           ; 06951  0xE9, 0xAF, 0xD6
xios_fn_ext41:
  mov cl, 0x10                                 ; 06954  0xB1, 0x10
  call sub_0563C                               ; 06956  0xE8, 0xE3, 0xEC
  call sub_05557                               ; 06959  0xE8, 0xFB, 0xEB
  call sub_0564E                               ; 0695C  0xE8, 0xEF, 0xEC
  and al, 0x80                                 ; 0695F  0x24, 0x80
  jne loc_06966                                ; 06961  0x75, 0x03
  jmp near sub_04C05                           ; 06963  0xE9, 0x9F, 0xE2

loc_06966:                                     ; 06966
  call sub_04978                               ; 06966  0xE8, 0x0F, 0xE0
  mov word [0x815], 0xffff                     ; 06969  0xC7, 0x06, 0x15, 0x08, 0xFF, 0xFF
  call sub_04B99                               ; 0696F  0xE8, 0x27, 0xE2
  jne loc_06975                                ; 06972  0x75, 0x01

loc_06974:                                     ; 06974
  ret                                          ; 06974  0xC3

loc_06975:                                     ; 06975
  call sub_05957                               ; 06975  0xE8, 0xDF, 0xEF
  call sub_05655                               ; 06978  0xE8, 0xDA, 0xEC
  jne loc_06988                                ; 0697B  0x75, 0x0B
  mov [0x813], al                              ; 0697D  0xA2, 0x13, 0x08
  call sub_04F36                               ; 06980  0xE8, 0xB3, 0xE5
  je loc_06974                                 ; 06983  0x74, 0xEF
  call sub_0567C                               ; 06985  0xE8, 0xF4, 0xEC

loc_06988:                                     ; 06988
  call sub_0577A                               ; 06988  0xE8, 0xEF, 0xED
  je loc_06990                                 ; 0698B  0x74, 0x03
  jmp near loc_05708                           ; 0698D  0xE9, 0x78, 0xED

loc_06990:                                     ; 06990
  mov si, 0xb0c                                ; 06990  0xBE, 0x0C, 0x0B
  test byte [bx], 0xff                         ; 06993  0xF6, 0x07, 0xFF
  jne loc_069A3                                ; 06996  0x75, 0x0B
  lodsb                                        ; 06998  0xAC
  dec si                                       ; 06999  0x4E
  and al, 1                                    ; 0699A  0x24, 0x01
  jne loc_069A3                                ; 0699C  0x75, 0x05
  call sub_0690C                               ; 0699E  0xE8, 0x6B, 0xFF
  jmp short loc_069AF                          ; 069A1  0xEB, 0x0C

loc_069A3:                                     ; 069A3
  lodsb                                        ; 069A3  0xAC
  and al, 0xe0                                 ; 069A4  0x24, 0xE0
  jne loc_069AA                                ; 069A6  0x75, 0x02
  mov al, 0x80                                 ; 069A8  0xB0, 0x80

loc_069AA:                                     ; 069AA
  mov [bx], al                                 ; 069AA  0x88, 0x07
  call sub_06900                               ; 069AC  0xE8, 0x51, 0xFF

loc_069AF:                                     ; 069AF
  call sub_0566D                               ; 069AF  0xE8, 0xBB, 0xEC
  and al, 0xe0                                 ; 069B2  0x24, 0xE0
  mov [0x8cb], al                              ; 069B4  0xA2, 0xCB, 0x08
  push ax                                      ; 069B7  0x50
  call sub_04B8D                               ; 069B8  0xE8, 0xD2, 0xE1
  pop ax                                       ; 069BB  0x58
  mov [0xb0c], al                              ; 069BC  0xA2, 0x0C, 0x0B
  je loc_06974                                 ; 069BF  0x74, 0xB3
  call sub_057B3                               ; 069C1  0xE8, 0xEF, 0xED
  or_al_al                                     ; 069C4  or al, al
  jne loc_06974                                ; 069C6  0x75, 0xAC
  mov al, [0x8cb]                              ; 069C8  0xA0, 0xCB, 0x08
  mov [bx], al                                 ; 069CB  0x88, 0x07
  jmp near sub_04746                           ; 069CD  0xE9, 0x76, 0xDD
xios_fn_ext44:
  mov cl, 8                                    ; 069D0  0xB1, 0x08
  call sub_03F0A                               ; 069D2  0xE8, 0x35, 0xD5
  mov byte [0x80c], 0                          ; 069D5  0xC6, 0x06, 0x0C, 0x08, 0x00
  mov si, 0xb00                                ; 069DA  0xBE, 0x00, 0x0B
  mov_bx_si                                    ; 069DD  mov bx, si
  mov di, 0x87d                                ; 069DF  0xBF, 0x7D, 0x08
  mov cx, 8                                    ; 069E2  0xB9, 0x08, 0x00
  jmp near loc_05789                           ; 069E5  0xE9, 0xA1, 0xED
xios_fn_ext45:
  call sub_041C0                               ; 069E8  0xE8, 0xD5, 0xD7
  call sub_0563A                               ; 069EB  0xE8, 0x4C, 0xEC
  call sub_0426C                               ; 069EE  0xE8, 0x7B, 0xD8
  cmp byte [0x87f], 0                          ; 069F1  0x80, 0x3E, 0x7F, 0x08, 0x00
  je loc_069FD                                 ; 069F6  0x74, 0x05
  mov ah, 0xa                                  ; 069F8  0xB4, 0x0A
  jmp near loc_03FD5                           ; 069FA  0xE9, 0xD8, 0xD5

loc_069FD:                                     ; 069FD
  mov ah, [0xb0c]                              ; 069FD  0x8A, 0x26, 0x0C, 0x0B
  mov al, [0xb0e]                              ; 06A01  0xA0, 0x0E, 0x0B
  push ax                                      ; 06A04  0x50
  call sub_04B8D                               ; 06A05  0xE8, 0x85, 0xE1
  pop ax                                       ; 06A08  0x58
  mov [0xb0c], ah                              ; 06A09  0x88, 0x26, 0x0C, 0x0B
  mov [0xb0e], al                              ; 06A0D  0xA2, 0x0E, 0x0B
  je loc_06A43                                 ; 06A10  0x74, 0x31
  mov cl, 0x50                                 ; 06A12  0xB1, 0x50
  call sub_057F4                               ; 06A14  0xE8, 0xDD, 0xED
  jne loc_06A28                                ; 06A17  0x75, 0x0F
  mov ch, 0                                    ; 06A19  0xB5, 0x00
  call sub_057B5                               ; 06A1B  0xE8, 0x97, 0xED
  or_al_al                                     ; 06A1E  or al, al
  jne loc_06A28                                ; 06A20  0x75, 0x06
  mov dx, 0x8b7                                ; 06A22  0xBA, 0xB7, 0x08
  call sub_05816                               ; 06A25  0xE8, 0xEE, 0xED

loc_06A28:                                     ; 06A28
  mov cl, 0x20                                 ; 06A28  0xB1, 0x20
  call sub_057F4                               ; 06A2A  0xE8, 0xC7, 0xED
  jne loc_06A43                                ; 06A2D  0x75, 0x14
  mov ch, 4                                    ; 06A2F  0xB5, 0x04
  call sub_057B5                               ; 06A31  0xE8, 0x81, 0xED
  or_al_al                                     ; 06A34  or al, al
  jne loc_06A43                                ; 06A36  0x75, 0x0B
  mov dx, 0x8bb                                ; 06A38  0xBA, 0xBB, 0x08
  call sub_05816                               ; 06A3B  0xE8, 0xD8, 0xED
  or byte [0xb0e], 0x40                        ; 06A3E  0x80, 0x0E, 0x0E, 0x0B, 0x40

loc_06A43:                                     ; 06A43
  ret                                          ; 06A43  0xC3
xios_fn_ext47:
  ret                                          ; 06A44  0xC3
xios_fn_setsec:
  mov bx, [0x808]                              ; 06A45  0x8B, 0x1E, 0x08, 0x08
  ret                                          ; 06A49  0xC3
xios_fn_setdma:
  mov si, [0x68]                               ; 06A4A  0x8B, 0x36, 0x68, 0x00
  mov bl, [si + 0x12]                          ; 06A4E  0x8A, 0x5C, 0x12
  ret                                          ; 06A51  0xC3
xios_fn_read:
  mov [es:2], dx                               ; 06A52  0x26, 0x89, 0x16, 0x02, 0x00
  ret                                          ; 06A57  0xC3
xios_fn_sectrn:
  mov bx, [0x806]                              ; 06A58  0x8B, 0x1E, 0x06, 0x08
  ret                                          ; 06A5C  0xC3
xios_fn_alloc:
  mov si, [0x68]                               ; 06A5D  0x8B, 0x36, 0x68, 0x00
  cmp dl, 0xff                                 ; 06A61  0x80, 0xFA, 0xFF
  jne loc_06A6A                                ; 06A64  0x75, 0x04
  mov bl, [si + 0x13]                          ; 06A66  0x8A, 0x5C, 0x13
  ret                                          ; 06A69  0xC3

loc_06A6A:                                     ; 06A6A
  and dl, 0xf                                  ; 06A6A  0x80, 0xE2, 0x0F
  mov [si + 0x13], dl                          ; 06A6D  0x88, 0x54, 0x13
  ret                                          ; 06A70  0xC3
xios_fn_exit:
  xor_bx_bx                                    ; 06A71  xor bx, bx
  or_dl_dl                                     ; 06A73  or dl, dl
  je loc_06A82                                 ; 06A75  0x74, 0x0B
  cmp dl, 0x81                                 ; 06A77  0x80, 0xFA, 0x81
  jae loc_06A82                                ; 06A7A  0x73, 0x06
  mov [es:0x11], dl                            ; 06A7C  0x26, 0x88, 0x16, 0x11, 0x00
  ret                                          ; 06A81  0xC3

loc_06A82:                                     ; 06A82
  dec bx                                       ; 06A82  0x4B
  ret                                          ; 06A83  0xC3
xios_fn_idle:
  mov [es:0x10], dl                            ; 06A84  0x26, 0x88, 0x16, 0x10, 0x00
  ret                                          ; 06A89  0xC3
xios_fn_ext34:
  mov [es:4], dx                               ; 06A8A  0x26, 0x89, 0x16, 0x04, 0x00
  ret                                          ; 06A8F  0xC3
xios_fn_ext35:
  mov ax, [es:4]                               ; 06A90  0x26, 0xA1, 0x04, 0x00
  mov [es:0x30], ax                            ; 06A94  0x26, 0xA3, 0x30, 0x00
  mov bx, [es:2]                               ; 06A98  0x26, 0x8B, 0x1E, 0x02, 0x00
  ret                                          ; 06A9D  0xC3
xios_fn_ext42:
  mov_si_dx                                    ; 06A9E  mov si, dx
  mov di, 0x7e                                 ; 06AA0  0xBF, 0x7E, 0x00
  pushf                                        ; 06AA3  0x9C
  cli                                          ; 06AA4  0xFA
  push es                                      ; 06AA5  0x06
  push ds                                      ; 06AA6  0x1E
  mov ds, [es:0x2e]                            ; 06AA7  0x26, 0x8E, 0x1E, 0x2E, 0x00
  pop es                                       ; 06AAC  0x07
  movsw                                        ; 06AAD  0xA5
  movsw                                        ; 06AAE  0xA5
  push es                                      ; 06AAF  0x06
  pop ds                                       ; 06AB0  0x1F
  pop es                                       ; 06AB1  0x07
  mov byte [0x82], 0                           ; 06AB2  0xC6, 0x06, 0x82, 0x00, 0x00
  popf                                         ; 06AB7  0x9D
  ret                                          ; 06AB8  0xC3
xios_fn_ext43:
  mov_di_dx                                    ; 06AB9  mov di, dx
  mov si, 0x7e                                 ; 06ABB  0xBE, 0x7E, 0x00
  push es                                      ; 06ABE  0x06
  mov es, [es:0x2e]                            ; 06ABF  0x26, 0x8E, 0x06, 0x2E, 0x00
  pushf                                        ; 06AC4  0x9C
  cli                                          ; 06AC5  0xFA
  movsw                                        ; 06AC6  0xA5
  movsw                                        ; 06AC7  0xA5
  mov bl, [0x82]                               ; 06AC8  0x8A, 0x1E, 0x82, 0x00
  popf                                         ; 06ACC  0x9D
  pop es                                       ; 06ACD  0x07
  ret                                          ; 06ACE  0xC3
  db 0x00, 0x00                                ; 06ACF  ..
  and al, 9                                    ; 06AD1  0x24, 0x09
  sub ax, 0x3c09                               ; 06AD3  0x2D, 0x09, 0x3C
  or [bp + di + 9], cx                         ; 06AD6  0x09, 0x4B, 0x09
  ja loc_06AE4                                 ; 06AD9  0x77, 0x09
  mov cx, [bx + di]                            ; 06ADB  0x8B, 0x09
  mov al, [0xaf09]                             ; 06ADD  0xA0, 0x09, 0xAF
  or bx, ax                                    ; 06AE0  0x09, 0xC3
  or sp, dx                                    ; 06AE2  0x09, 0xD4

loc_06AE4:                                     ; 06AE4
  or bp, bp                                    ; 06AE4  0x09, 0xED
  or [bx + di + 9], bx                         ; 06AE6  0x09, 0x59, 0x09
  or ax, [bp + si]                             ; 06AE9  0x0B, 0x02
  add al, 6                                    ; 06AEB  0x04, 0x06
  or [bp + si], cx                             ; 06AED  0x09, 0x0A
  adc [0x2625], dx                             ; 06AEF  0x11, 0x16, 0x25, 0x26
  sub [bx + di], ch                            ; 06AF3  0x28, 0x29
  db 0x00, 0x00                                ; 06AF5
  db 0x00, 0x00                                ; 06AF7
  pop es                                       ; 06AF9  0x07
  pop es                                       ; 06AFA  0x07
  or [si], dl                                  ; 06AFB  0x08, 0x14
  adc ax, 0x1c1b                               ; 06AFD  0x15, 0x1B, 0x1C
  sbb ax, strict word 0                        ; 06B00  1D 00 00
  add al, [bp + di]                            ; 06B03  0x02, 0x03
  add ax, strict word 0                        ; 06B05  05 00 00
  add [bx + si], ax                            ; 06B08  0x01, 0x00
  add al, [bp + si]                            ; 06B0A  0x02, 0x02
  add [bx + di], ax                            ; 06B0C  0x01, 0x01
  add al, [bp + si]                            ; 06B0E  0x02, 0x02
  add [bx + di], ax                            ; 06B10  0x01, 0x01
  add al, [bp + si]                            ; 06B12  0x02, 0x02
  add [bx + di], ax                            ; 06B14  0x01, 0x01
  add al, [bp + si]                            ; 06B16  0x02, 0x02
  nop                                          ; 06B18  0x90
  nop                                          ; 06B19  0x90
  nop                                          ; 06B1A  0x90
  nop                                          ; 06B1B  0x90
  nop                                          ; 06B1C  0x90
  nop                                          ; 06B1D  0x90
  nop                                          ; 06B1E  0x90
  nop                                          ; 06B1F  0x90
  nop                                          ; 06B20  0x90
  nop                                          ; 06B21  0x90
  nop                                          ; 06B22  0x90
  nop                                          ; 06B23  0x90
  nop                                          ; 06B24  0x90
  nop                                          ; 06B25  0x90
  nop                                          ; 06B26  0x90
  nop                                          ; 06B27  0x90
  nop                                          ; 06B28  0x90
  nop                                          ; 06B29  0x90
  nop                                          ; 06B2A  0x90
  nop                                          ; 06B2B  0x90
  nop                                          ; 06B2C  0x90
  nop                                          ; 06B2D  0x90
  nop                                          ; 06B2E  0x90
  nop                                          ; 06B2F  0x90
  nop                                          ; 06B30  0x90
  nop                                          ; 06B31  0x90
  nop                                          ; 06B32  0x90
  nop                                          ; 06B33  0x90
  nop                                          ; 06B34  0x90
  nop                                          ; 06B35  0x90
  nop                                          ; 06B36  0x90
  nop                                          ; 06B37  0x90
  nop                                          ; 06B38  0x90
  nop                                          ; 06B39  0x90
  nop                                          ; 06B3A  0x90
  nop                                          ; 06B3B  0x90
  nop                                          ; 06B3C  0x90
  nop                                          ; 06B3D  0x90
  nop                                          ; 06B3E  0x90
  nop                                          ; 06B3F  0x90
  nop                                          ; 06B40  0x90
  nop                                          ; 06B41  0x90
  nop                                          ; 06B42  0x90
  nop                                          ; 06B43  0x90
  nop                                          ; 06B44  0x90
  nop                                          ; 06B45  0x90
  nop                                          ; 06B46  0x90
  nop                                          ; 06B47  0x90
  nop                                          ; 06B48  0x90
  nop                                          ; 06B49  0x90
  nop                                          ; 06B4A  0x90
  nop                                          ; 06B4B  0x90
  nop                                          ; 06B4C  0x90
  nop                                          ; 06B4D  0x90
  nop                                          ; 06B4E  0x90
  nop                                          ; 06B4F  0x90
  nop                                          ; 06B50  0x90
  nop                                          ; 06B51  0x90
  nop                                          ; 06B52  0x90
  nop                                          ; 06B53  0x90
  nop                                          ; 06B54  0x90
  nop                                          ; 06B55  0x90
  nop                                          ; 06B56  0x90
  nop                                          ; 06B57  0x90
  nop                                          ; 06B58  0x90
  nop                                          ; 06B59  0x90
  nop                                          ; 06B5A  0x90
  nop                                          ; 06B5B  0x90
  nop                                          ; 06B5C  0x90
  nop                                          ; 06B5D  0x90
  nop                                          ; 06B5E  0x90
  nop                                          ; 06B5F  0x90
  nop                                          ; 06B60  0x90
  nop                                          ; 06B61  0x90
  nop                                          ; 06B62  0x90
  nop                                          ; 06B63  0x90
  nop                                          ; 06B64  0x90
  nop                                          ; 06B65  0x90
  nop                                          ; 06B66  0x90
  nop                                          ; 06B67  0x90
  nop                                          ; 06B68  0x90
  nop                                          ; 06B69  0x90
  nop                                          ; 06B6A  0x90
  nop                                          ; 06B6B  0x90
  nop                                          ; 06B6C  0x90
  nop                                          ; 06B6D  0x90
  nop                                          ; 06B6E  0x90
  nop                                          ; 06B6F  0x90
  nop                                          ; 06B70  0x90
  nop                                          ; 06B71  0x90
  nop                                          ; 06B72  0x90
  nop                                          ; 06B73  0x90
  nop                                          ; 06B74  0x90
  nop                                          ; 06B75  0x90
  nop                                          ; 06B76  0x90
  nop                                          ; 06B77  0x90
  nop                                          ; 06B78  0x90
  nop                                          ; 06B79  0x90
  nop                                          ; 06B7A  0x90
  nop                                          ; 06B7B  0x90
  nop                                          ; 06B7C  0x90
  nop                                          ; 06B7D  0x90
  nop                                          ; 06B7E  0x90
  nop                                          ; 06B7F  0x90
  nop                                          ; 06B80  0x90
  nop                                          ; 06B81  0x90
  nop                                          ; 06B82  0x90
  nop                                          ; 06B83  0x90
  nop                                          ; 06B84  0x90
  nop                                          ; 06B85  0x90
  nop                                          ; 06B86  0x90
  nop                                          ; 06B87  0x90
  nop                                          ; 06B88  0x90
  nop                                          ; 06B89  0x90
  nop                                          ; 06B8A  0x90
  nop                                          ; 06B8B  0x90
  nop                                          ; 06B8C  0x90
  nop                                          ; 06B8D  0x90
  nop                                          ; 06B8E  0x90
  nop                                          ; 06B8F  0x90
  nop                                          ; 06B90  0x90
  nop                                          ; 06B91  0x90
  nop                                          ; 06B92  0x90
  nop                                          ; 06B93  0x90
  nop                                          ; 06B94  0x90
  nop                                          ; 06B95  0x90
  nop                                          ; 06B96  0x90
  nop                                          ; 06B97  0x90
  db 0x00, 0x00                                ; 06B98
  db 0x00, 0x00                                ; 06B9A
  db 0x00, 0x00                                ; 06B9C
  db 0x00, 0x00                                ; 06B9E
xios_code_base:                             ; 06BA0 (XIOS Code Segment Base for INT 28h)
  add ax, [bx + si]                            ; 06BA0  0x03, 0x00
  dec ax                                       ; 06BA2  0x48
  db 0x00, 0x00                                ; 06BA3
  db 0x00, 0x48, 0x00                          ; 06BA5  (SYSDAT data)
  add ax, [bx + si]                            ; 06BA8  0x03, 0x00
  movsb                                        ; 06BAA  0xA4
  add [bx + si], ax                            ; 06BAB  0x01, 0x00

loc_06BAD:                                     ; 06BAD
  add [si + 0x301], ah                         ; 06BAD  0x00, 0xA4, 0x01, 0x03
  db 0x00, 0xAC, 0x02, 0x00                    ; 06BB1  (SYSDAT data)
  add [si + 0x302], ch                         ; 06BB5  0x00, 0xAC, 0x02, 0x03
  add [bp + 3], bl                             ; 06BB9  0x00, 0x5E, 0x03
  db 0x00, 0x00                                ; 06BBC
  pop si                                       ; 06BBE  0x5E
  add ax, [bp + di]                            ; 06BBF  0x03, 0x03
  add ch, ch                                   ; 06BC1  0x00, 0xED
  add ax, [bx + si]                            ; 06BC3  0x03, 0x00
  add ch, ch                                   ; 06BC5  0x00, 0xED
  add ax, [bp + di]                            ; 06BC7  0x03, 0x03
  or al, 0xfa                                  ; 06BC9  0x0C, 0xFA
  push es                                      ; 06BCB  0x06
  add [si], cl                                 ; 06BCC  0x00, 0x0C
  cli                                          ; 06BCE  0xFA
  push es                                      ; 06BCF  0x06
  add ax, [bx + si]                            ; 06BD0  0x03, 0x00
  db 0x00, 0x00                                ; 06BD2
  db 0x00, 0x00                                ; 06BD4
  db 0x00, 0x00                                ; 06BD6
  db 0x00, 0x00                                ; 06BD8
  db 0x00, 0x00                                ; 06BDA
  db 0x00, 0x00                                ; 06BDC
  db 0x00, 0x00                                ; 06BDE
  dec ax                                       ; 06BE0  0x48
  add [bp + si], dl                            ; 06BE1  0x00, 0x12
  adc sp, [bx + di]                            ; 06BE3  0x13, 0x21
  adc ax, 0x13f                                ; 06BE5  0x15, 0x3F, 0x01
  add ax, [di]                                 ; 06BE8  0x03, 0x05
  inc word [bx + si]                           ; 06BEA  0xFF, 0x00
  add [bx + si], dh                            ; 06BEC  0x00, 0x30
  db 0x00, 0x00                                ; 06BEE
  add [si], bh                                 ; 06BF0  0x00, 0x3C
  inc ax                                       ; 06BF2  0x40
  or byte [bx + di + 0xd], 0x4a                ; 06BF3  0x80, 0x49, 0x0D, 0x4A
  db 0x80, 0xE0, 0x6C                          ; 06BF7  (SYSDAT data)
  xor [bp + di + 0x5a], ah                     ; 06BFA  0x30, 0x63, 0x5A
  js loc_06BAD                                 ; 06BFD  0x78, 0xAE
  jge loc_06C01                                ; 06BFF  0x7D, 0x00

loc_06C01:                                     ; 06C01
  add [bx], ch                                 ; 06C01  0x00, 0x2F
  db 0x0F, 0x80, 0x00, 0x00                    ; 06C03  (SYSDAT data)

loc_06C07:                                     ; 06C07
  db 0x00, 0xA1, 0x04, 0x00                    ; 06C07  (SYSDAT data)
  db 0x00, 0x00                                ; 06C0B
  db 0x00, 0x00                                ; 06C0D
  db 0x00, 0x00                                ; 06C0F
  add [bx + di - 0x43fc], ah                   ; 06C11  0x00, 0xA1, 0x04, 0xBC
  add [bx + si], ax                            ; 06C15  0x01, 0x00
  add [bx + si + 0x15], ah                     ; 06C17  0x00, 0x60, 0x15
  xor [si], dx                                 ; 06C1A  0x31, 0x14
  xor [si], dx                                 ; 06C1C  0x31, 0x14
  jle loc_06C26                                ; 06C1E  0x7E, 0x06
  adc al, [bx + si]                            ; 06C20  0x12, 0x00
  add [bx + di], cl                            ; 06C22  0x00, 0x09
  add cx, [si]                                 ; 06C24  0x03, 0x0C

loc_06C26:                                     ; 06C26
  db 0xD5, 0x0E                                ; 06C26  (SYSDAT data)
  db 0x00, 0x00                                ; 06C28
  and [bx + si], ah                            ; 06C2A  0x20, 0x20
  db 0x00, 0x00                                ; 06C2C
  db 0x00, 0x00                                ; 06C2E
  inc word [bx + si]                           ; 06C30  0xFF, 0x00
  db 0x00, 0x00                                ; 06C32
  db 0x00, 0x00                                ; 06C34
  cmc                                          ; 06C36  0xF5
  push es                                      ; 06C37  0x06
  db 0x00, 0x00                                ; 06C38
  db 0x00, 0x00                                ; 06C3A
  db 0x00, 0x00                                ; 06C3C
  add [bx + di], al                            ; 06C3E  0x00, 0x01
  db 0x00, 0x00                                ; 06C40
  db 0x00, 0x00                                ; 06C42
  db 0x00, 0x00                                ; 06C44
  db 0x00, 0x00                                ; 06C46
  db 0x00, 0x00                                ; 06C48
  add [bp + si], al                            ; 06C4A  0x00, 0x02
  add [si], al                                 ; 06C4C  0x00, 0x04
  add [si], ax                                 ; 06C4E  0x01, 0x04
  add [bx + di], al                            ; 06C50  0x00, 0x01
  add [bx + di], al                            ; 06C52  0x00, 0x01
  add al, 0x84                                 ; 06C54  0x04, 0x84
  add ax, strict word 4                        ; 06C56  05 04 00
  add [bx + si], ax                            ; 06C59  0x01, 0x00
  add [0x704], ax                              ; 06C5B  0x01, 0x06, 0x04, 0x07
  add al, 8                                    ; 06C5F  0x04, 0x08
  add al, 2                                    ; 06C61  0x04, 0x02
  add word [bx + si], 0x185                    ; 06C63  0x81, 0x00, 0x85, 0x01
  test [bp + si], ax                           ; 06C67  0x85, 0x02
  test [bp + di], ax                           ; 06C69  0x85, 0x03
  test [si], ax                                ; 06C6B  0x85, 0x04
  test [di], ax                                ; 06C6D  0x85, 0x05
  test [0x785], ax                             ; 06C6F  0x85, 0x06, 0x85, 0x07
  test [bx + si], cx                           ; 06C73  0x85, 0x08
  test [bx + di], cx                           ; 06C75  0x85, 0x09
  test [bp + si], cx                           ; 06C77  0x85, 0x0A
  test [bp + di], cx                           ; 06C79  0x85, 0x0B
  test [si], cx                                ; 06C7B  0x85, 0x0C
  add ax, 0x50d                                ; 06C7D  0x05, 0x0D, 0x05
  push cs                                      ; 06C80  0x0E
  test [bx], cx                                ; 06C81  0x85, 0x0F
  test [bx + si], dx                           ; 06C83  0x85, 0x10
  test [bx + di], dx                           ; 06C85  0x85, 0x11
  test [bp + si], dx                           ; 06C87  0x85, 0x12
  test [bp + di], dx                           ; 06C89  0x85, 0x13
  add ax, 0x8514                               ; 06C8B  0x05, 0x14, 0x85
  adc ax, 0x1685                               ; 06C8E  0x15, 0x85, 0x16
  test [bx], dx                                ; 06C91  0x85, 0x17
  test [bx + si], bx                           ; 06C93  0x85, 0x18
  test [bx + di], bx                           ; 06C95  0x85, 0x19
  test [bp + si], bx                           ; 06C97  0x85, 0x1A
  test [bp + di], bx                           ; 06C99  0x85, 0x1B
  test [bx + si], ax                           ; 06C9B  0x85, 0x00
  add [si], bx                                 ; 06C9D  0x01, 0x1C
  test [di], bx                                ; 06C9F  0x85, 0x1D
  test [0x1f05], bx                            ; 06CA1  0x85, 0x1E, 0x05, 0x1F
  test [bx + si], sp                           ; 06CA5  0x85, 0x20
  test [si], cx                                ; 06CA7  0x85, 0x0C
  and word [bx + di], 0x105                    ; 06CA9  0x81, 0x21, 0x05, 0x01
  add [bp + di], ax                            ; 06CAD  0x01, 0x03
  add [bp + si], sp                            ; 06CAF  0x01, 0x22
  add ax, 0x523                                ; 06CB1  0x05, 0x23, 0x05
  add [bp + di], al                            ; 06CB4  0x00, 0x03
  add [bp + di], ax                            ; 06CB6  0x01, 0x03
  add al, [bp + di]                            ; 06CB8  0x02, 0x03
  add ax, [bp + di]                            ; 06CBA  0x03, 0x03
  add al, 3                                    ; 06CBC  0x04, 0x03
  add ax, 0x403                                ; 06CBE  0x05, 0x03, 0x04
  add word [bx + di], 0x101                    ; 06CC1  0x81, 0x01, 0x01, 0x01
  add [bx + di], ax                            ; 06CC5  0x01, 0x01
  add [bx + di], ax                            ; 06CC7  0x01, 0x01
  add [bx + si - 0x79], ax                     ; 06CC9  0x01, 0x40, 0x87
  inc cx                                       ; 06CCC  0x41
  xchg [bp + si - 0x79], ax                    ; 06CCD  0x87, 0x42, 0x87
  inc bx                                       ; 06CD0  0x43
  xchg [si - 0x79], ax                         ; 06CD1  0x87, 0x44, 0x87
  inc bp                                       ; 06CD4  0x45
  xchg [bp - 0x79], ax                         ; 06CD5  0x87, 0x46, 0x87
  inc di                                       ; 06CD8  0x47
  xchg [bx + si - 0x79], cx                    ; 06CD9  0x87, 0x48, 0x87
  dec cx                                       ; 06CDC  0x49
  xchg [bp + si - 0x79], cx                    ; 06CDD  0x87, 0x4A, 0x87
  dec bx                                       ; 06CE0  0x4B
  xchg [si - 0x79], cx                         ; 06CE1  0x87, 0x4C, 0x87
  dec bp                                       ; 06CE4  0x4D
  xchg [bx + di], ax                           ; 06CE5  0x87, 0x01
  add [bx + di], ax                            ; 06CE7  0x01, 0x01
  add [bx + di], ax                            ; 06CE9  0x01, 0x01
  add [si], sp                                 ; 06CEB  0x01, 0x24
  test [di], sp                                ; 06CED  0x85, 0x25
  test [0x2785], sp                            ; 06CEF  0x85, 0x26, 0x85, 0x27
  test [bx + si], bp                           ; 06CF3  0x85, 0x28
  test [bx + di], bp                           ; 06CF5  0x85, 0x29
  test [bp + si], bp                           ; 06CF7  0x85, 0x2A
  add ax, 0x52b                                ; 06CF9  0x05, 0x2B, 0x05
  sub al, 0x85                                 ; 06CFC  0x2C, 0x85
  or ax, strict word 1                         ; 06CFE  0D 01 00
  add [bx + di], bx                            ; 06D01  0x01, 0x19
  add al, 0x1a                                 ; 06D03  0x04, 0x1A
  add al, 0x1b                                 ; 06D05  0x04, 0x1B
  add al, 0x1c                                 ; 06D07  0x04, 0x1C
  test [bx + di], al                           ; 06D09  0x84, 0x01
  add [bx + di], ax                            ; 06D0B  0x01, 0x01
  add [bx + di], ax                            ; 06D0D  0x01, 0x01
  add [di], bp                                 ; 06D0F  0x01, 0x2D
  add ax, 0x306                                ; 06D11  0x05, 0x06, 0x03
  push es                                      ; 06D14  0x06
  add ax, [bx]                                 ; 06D15  0x03, 0x07
  add ax, [bx + di]                            ; 06D17  0x03, 0x01
  add al, [bp + si]                            ; 06D19  0x02, 0x02
  add al, [bp + di]                            ; 06D1B  0x02, 0x03
  add al, [si]                                 ; 06D1D  0x02, 0x04
  db 0x82, 0x05, 0x82                          ; 06D1F  (SYSDAT offset table)
  push es                                      ; 06D22  0x06
  db 0x82, 0x07, 0x82                          ; 06D23  (SYSDAT offset table)
  or [bp + si - 0x7df7], al                    ; 06D26  0x08, 0x82, 0x09, 0x82
  or al, [bp + si + 0x20b]                     ; 06D2A  0x0A, 0x82, 0x0B, 0x02
  or al, 2                                     ; 06D2E  0x0C, 0x02
  or ax, 0xe02                                 ; 06D30  0x0D, 0x02, 0x0E
  db 0x82, 0x0F, 0x02                          ; 06D33  (SYSDAT offset table)
  or [si], ax                                  ; 06D36  0x09, 0x04
  or al, [si]                                  ; 06D38  0x0A, 0x04
  or ax, [si]                                  ; 06D3A  0x0B, 0x04
  or al, 4                                     ; 06D3C  0x0C, 0x04
  add ax, 0x601                                ; 06D3E  0x05, 0x01, 0x06
  add [bx], ax                                 ; 06D41  0x01, 0x07
  add [di], cx                                 ; 06D43  0x01, 0x0D
  add al, 8                                    ; 06D45  0x04, 0x08
  add [bx + di], cx                            ; 06D47  0x01, 0x09
  add [bx + si], dx                            ; 06D49  0x01, 0x10
  add dl, [bx + di]                            ; 06D4B  0x02, 0x11
  add cl, [bx]                                 ; 06D4D  0x02, 0x0F
  test [bx + si], dl                           ; 06D4F  0x84, 0x10
  test [bx + di], dl                           ; 06D51  0x84, 0x11
  test [bp + si], dl                           ; 06D53  0x84, 0x12
  test [bp + di], dl                           ; 06D55  0x84, 0x13
  add al, 0xb                                  ; 06D57  0x04, 0x0B
  adc word [si], 0x3884                        ; 06D59  0x81, 0x14, 0x84, 0x38
  or ax, [bx + si]                             ; 06D5D  0x0B, 0x00
  add [bp + di], al                            ; 06D5F  0x00, 0x03
  add [di + 0x58], cl                          ; 06D61  0x00, 0x4D, 0x58
  dec sp                                       ; 06D64  0x4C
  db 0x6F                                      ; 06D65  outsw
  db 0x61                                      ; 06D66  popa
  and [fs:bx + si], ah                         ; 06D67  0x64, 0x20, 0x20
  db 0x00, 0x00                                ; 06D6A
  add [bx + si], ax                            ; 06D6C  0x01, 0x00
  db 0x00, 0x00                                ; 06D6E
  db 0x00, 0x00                                ; 06D70
  add [bx + si], ax                            ; 06D72  0x01, 0x00
  db 0x00, 0x00                                ; 06D74
  db 0x00, 0x00                                ; 06D76
  db 0x00, 0x00                                ; 06D78
  mov sp, 0x101                                ; 06D7A  0xBC, 0x01, 0x01
  db 0x00, 0x00                                ; 06D7D
  db 0x00, 0x00                                ; 06D7F
  db 0x00, 0x00                                ; 06D81
  db 0x00, 0x00                                ; 06D83
  db 0x00, 0x00                                ; 06D85
  db 0x00, 0x00                                ; 06D87
  db 0x00, 0x00                                ; 06D89
  db 0x00, 0x00                                ; 06D8B
  db 0x00, 0x00                                ; 06D8D
  db 0x00, 0x00                                ; 06D8F
  db 0x00, 0x00                                ; 06D91
  db 0x00, 0x00                                ; 06D93
  db 0x00, 0x00                                ; 06D95
  db 0x00, 0x00                                ; 06D97
  db 0x00, 0x00                                ; 06D99
  db 0x00, 0x00                                ; 06D9B
  db 0x00, 0x00                                ; 06D9D
  db 0x00, 0x00                                ; 06D9F
  db 0x00, 0x00                                ; 06DA1
  db 0x00, 0x00                                ; 06DA3
  db 0x00, 0x00                                ; 06DA5
  db 0x00, 0x00                                ; 06DA7
  db 0x00, 0x00                                ; 06DA9
  db 0x00, 0x00                                ; 06DAB
  db 0x00, 0x00                                ; 06DAD
  db 0x00, 0x00                                ; 06DAF
  db 0x00, 0x00                                ; 06DB1
  db 0x00, 0x00                                ; 06DB3
  db 0x00, 0x00                                ; 06DB5
  db 0x00, 0x00                                ; 06DB7
  db 0x00, 0x00                                ; 06DB9
  db 0x00, 0x00                                ; 06DBB
  db 0x00, 0x00                                ; 06DBD
  db 0x00, 0x00                                ; 06DBF
  db 0x00, 0x00                                ; 06DC1
  db 0x00, 0x00                                ; 06DC3
  db 0x00, 0x00                                ; 06DC5
  db 0x00, 0x00                                ; 06DC7
  db 0x00, 0x00                                ; 06DC9
  db 0x00, 0x00                                ; 06DCB
  db 0x00, 0x00                                ; 06DCD
  db 0x00, 0x00                                ; 06DCF
  db 0x00, 0x00                                ; 06DD1
  db 0x00, 0x00                                ; 06DD3
  db 0x00, 0x00                                ; 06DD5
  db 0x00, 0x00                                ; 06DD7
  db 0x00, 0x00                                ; 06DD9
  db 0x00, 0x00                                ; 06DDB
  db 0x00, 0x00                                ; 06DDD
  db 0x00, 0x00                                ; 06DDF
  db 0x00, 0x00                                ; 06DE1
  db 0x00, 0x00                                ; 06DE3
  db 0x00, 0x00                                ; 06DE5
  db 0x00, 0x00                                ; 06DE7
  db 0x00, 0x00                                ; 06DE9
  db 0x00, 0x00                                ; 06DEB
  db 0x00, 0x00                                ; 06DED
  db 0x00, 0x00                                ; 06DEF
  db 0x00, 0x00                                ; 06DF1
  db 0x00, 0x00                                ; 06DF3
  db 0x00, 0x00                                ; 06DF5
  db 0x00, 0x00                                ; 06DF7
  db 0x00, 0x00                                ; 06DF9
  db 0x00, 0x00                                ; 06DFB
  db 0x00, 0x00                                ; 06DFD
  db 0x00, 0x00                                ; 06DFF
  db 0x00, 0x00                                ; 06E01
  db 0x00, 0x00                                ; 06E03
  db 0x00, 0x00                                ; 06E05
  db 0x00, 0x00                                ; 06E07
  db 0x00, 0x00                                ; 06E09
  db 0x00, 0x00                                ; 06E0B
  db 0x00, 0x00                                ; 06E0D
  db 0x00, 0x00                                ; 06E0F
  db 0x00, 0x00                                ; 06E11
  db 0x00, 0x00                                ; 06E13
  db 0x00, 0x00                                ; 06E15
  db 0x00, 0x00                                ; 06E17
  db 0x00, 0x00                                ; 06E19
  db 0x00, 0x00                                ; 06E1B
  db 0x00, 0x00                                ; 06E1D
  db 0x00, 0x00                                ; 06E1F
  db 0x00, 0x00                                ; 06E21
  db 0x00, 0x00                                ; 06E23
  db 0x00, 0x00                                ; 06E25
  db 0x00, 0x00                                ; 06E27
  db 0x00, 0x00                                ; 06E29
  db 0x00, 0x00                                ; 06E2B
  db 0x00, 0x00                                ; 06E2D
  db 0x00, 0x00                                ; 06E2F
  db 0x00, 0x00                                ; 06E31
  db 0x00, 0x00                                ; 06E33
  db 0x00, 0x00                                ; 06E35
  db 0x00, 0x00                                ; 06E37
  db 0x00, 0x00                                ; 06E39
  db 0x00, 0x00                                ; 06E3B
  db 0x00, 0x00                                ; 06E3D
  db 0x00, 0x00                                ; 06E3F
  db 0x00, 0x00                                ; 06E41
  db 0x00, 0x00                                ; 06E43
  db 0x00, 0x00                                ; 06E45
  db 0x00, 0x00                                ; 06E47
  db 0x00, 0x00                                ; 06E49
  db 0x00, 0x00                                ; 06E4B
  db 0x00, 0x00                                ; 06E4D
  db 0x00, 0x00                                ; 06E4F
  db 0x00, 0x00                                ; 06E51
  db 0x00, 0x00                                ; 06E53
  db 0x00, 0x00                                ; 06E55
  db 0x00, 0x00                                ; 06E57
  db 0x00, 0x00                                ; 06E59
  db 0x00, 0x00                                ; 06E5B
  db 0x00, 0x00                                ; 06E5D
  db 0x00, 0x00                                ; 06E5F
  db 0x00, 0x00                                ; 06E61
  db 0x00, 0x00                                ; 06E63
  db 0x00, 0x00                                ; 06E65
  db 0x00, 0x00                                ; 06E67
  db 0x00, 0x00                                ; 06E69
  db 0x00, 0x00                                ; 06E6B
  db 0x00, 0x00                                ; 06E6D
  db 0x00, 0x00                                ; 06E6F
  db 0x00, 0x00                                ; 06E71
  db 0x00, 0x00                                ; 06E73
  db 0x00, 0x00                                ; 06E75
  db 0x00, 0x00                                ; 06E77
  db 0x00, 0x00                                ; 06E79
  db 0x00, 0x00                                ; 06E7B
  db 0x00, 0x00                                ; 06E7D
  db 0x00, 0x00                                ; 06E7F
  db 0x00, 0x00                                ; 06E81
  db 0x00, 0x00                                ; 06E83
  db 0x00, 0x00                                ; 06E85
  db 0x00, 0x00                                ; 06E87
  db 0x00, 0x00                                ; 06E89
  db 0x00, 0x00                                ; 06E8B
  db 0x00, 0x00                                ; 06E8D
  db 0x00, 0x00                                ; 06E8F
  db 0x00, 0x00                                ; 06E91
  db 0x00, 0x00                                ; 06E93
  db 0x00, 0x00                                ; 06E95
  db 0x00, 0x00                                ; 06E97
  db 0x00, 0x00                                ; 06E99
  db 0x00, 0x00                                ; 06E9B
  db 0x00, 0x00                                ; 06E9D
  db 0x00, 0x00                                ; 06E9F
  db 0x00, 0x00                                ; 06EA1
  db 0x00, 0x00                                ; 06EA3
  db 0x00, 0x00                                ; 06EA5
  db 0x00, 0x00                                ; 06EA7
  db 0x00, 0x00                                ; 06EA9
  db 0x00, 0x00                                ; 06EAB
  db 0x00, 0x00                                ; 06EAD
  db 0x00, 0x00                                ; 06EAF
  db 0x00, 0x00                                ; 06EB1
  db 0x00, 0x00                                ; 06EB3
  db 0x00, 0x00                                ; 06EB5
  db 0x00, 0x00                                ; 06EB7
  db 0x00, 0x00                                ; 06EB9
  db 0x00, 0x00                                ; 06EBB
  db 0x00, 0x00                                ; 06EBD
  db 0x00, 0x00                                ; 06EBF
  db 0x00, 0x00                                ; 06EC1
  db 0x00, 0x00                                ; 06EC3
  db 0x00, 0x00                                ; 06EC5
  db 0x00, 0x00                                ; 06EC7
  db 0x00, 0x00                                ; 06EC9
  db 0x00, 0x00                                ; 06ECB
  db 0x00, 0x00                                ; 06ECD
  db 0x00, 0x00                                ; 06ECF

sub_06ED1:                                     ; 06ED1
  db 0x00, 0x00                                ; 06ED1
  db 0x00, 0x00                                ; 06ED3
  db 0x00, 0x00                                ; 06ED5
  db 0x00, 0x00                                ; 06ED7
  db 0x00, 0x00                                ; 06ED9
  db 0x00, 0x00                                ; 06EDB
  db 0x00, 0x00                                ; 06EDD
  db 0x00, 0x00                                ; 06EDF
  db 0x00, 0x00                                ; 06EE1
  db 0x00, 0x00                                ; 06EE3
  db 0x00, 0x00                                ; 06EE5
  db 0x00, 0x00                                ; 06EE7
  db 0x00, 0x00                                ; 06EE9
  db 0x00, 0x00                                ; 06EEB
  db 0x00, 0x00                                ; 06EED
  db 0x00, 0x00                                ; 06EEF
  db 0x00, 0x00                                ; 06EF1
  db 0x00, 0x00                                ; 06EF3
  db 0x00, 0x00                                ; 06EF5
  db 0x00, 0x00                                ; 06EF7
  db 0x00, 0x00                                ; 06EF9
  db 0x00, 0x00                                ; 06EFB
  db 0x00, 0x00                                ; 06EFD
  db 0x00, 0x00                                ; 06EFF
  db 0x00, 0x00                                ; 06F01
  db 0x00, 0x00                                ; 06F03
  db 0x00, 0x00                                ; 06F05
  db 0x00, 0x00                                ; 06F07
  db 0x00, 0x00                                ; 06F09
  db 0x00, 0x00                                ; 06F0B
  db 0x00, 0x00                                ; 06F0D
  db 0x00, 0x00                                ; 06F0F
  db 0x00, 0x00                                ; 06F11
  db 0x00, 0x00                                ; 06F13
  db 0x00, 0x00                                ; 06F15
  db 0x00, 0x00                                ; 06F17
  db 0x00, 0x00                                ; 06F19
  db 0x00, 0x00                                ; 06F1B
  db 0x00, 0x00                                ; 06F1D
  db 0x00, 0x00                                ; 06F1F
  db 0x00, 0x00                                ; 06F21
  db 0x00, 0x00                                ; 06F23
  db 0x00, 0x00                                ; 06F25
  db 0x00, 0x00                                ; 06F27
  db 0x00, 0x00                                ; 06F29
  db 0x00, 0x00                                ; 06F2B
  db 0x00, 0x00                                ; 06F2D
  db 0x00, 0x00                                ; 06F2F
  db 0x00, 0x00                                ; 06F31
  db 0x00, 0x00                                ; 06F33
  db 0x00, 0x00                                ; 06F35
  db 0x00, 0x00                                ; 06F37
  db 0x00, 0x00                                ; 06F39
  db 0x00, 0x00                                ; 06F3B
  db 0x00, 0x00                                ; 06F3D
  db 0x00, 0x00                                ; 06F3F
  db 0x00, 0x00                                ; 06F41
  db 0x00, 0x00                                ; 06F43
  db 0x00, 0x00                                ; 06F45
  db 0x00, 0x00                                ; 06F47
  db 0x00, 0x00                                ; 06F49
  db 0x00, 0x00                                ; 06F4B
  db 0x00, 0x00                                ; 06F4D
  db 0x00, 0x00                                ; 06F4F
  db 0x00, 0x00                                ; 06F51
  db 0x00, 0x00                                ; 06F53
  db 0x00, 0x00                                ; 06F55
  db 0x00, 0x00                                ; 06F57
  db 0x00, 0x00                                ; 06F59
  db 0x00, 0x00                                ; 06F5B
  db 0x00, 0x00                                ; 06F5D
  db 0x00, 0x00                                ; 06F5F
  db 0x00, 0x00                                ; 06F61
  db 0x00, 0x00                                ; 06F63
  db 0x00, 0x00                                ; 06F65
  db 0x00, 0x00                                ; 06F67
  db 0x00, 0x00                                ; 06F69
  db 0x00, 0x00                                ; 06F6B
  db 0x00, 0x00                                ; 06F6D
  db 0x00, 0x00                                ; 06F6F
  db 0x00, 0x00                                ; 06F71
  db 0x00, 0x00                                ; 06F73
  db 0x00, 0x00                                ; 06F75
  db 0x00, 0x00                                ; 06F77
  db 0x00, 0x00                                ; 06F79
  db 0x00, 0x00                                ; 06F7B
  db 0x00, 0x00                                ; 06F7D
  db 0x00, 0x00                                ; 06F7F
  db 0x00, 0x00                                ; 06F81
  db 0x00, 0x00                                ; 06F83
  db 0x00, 0x00                                ; 06F85
  db 0x00, 0x00                                ; 06F87
  db 0x00, 0x00                                ; 06F89
  db 0x00, 0x00                                ; 06F8B
  db 0x00, 0x00                                ; 06F8D
  db 0x00, 0x00                                ; 06F8F
  db 0x00, 0x00                                ; 06F91
  db 0x00, 0x00                                ; 06F93
  db 0x00, 0x00                                ; 06F95
  db 0x00, 0x00                                ; 06F97
  db 0x00, 0x00                                ; 06F99
  db 0x00, 0x00                                ; 06F9B
  db 0x00, 0x00                                ; 06F9D
  db 0x00, 0x00                                ; 06F9F
  db 0x00, 0x00                                ; 06FA1
  db 0x00, 0x00                                ; 06FA3
  db 0x00, 0x00                                ; 06FA5
  db 0x00, 0x00                                ; 06FA7
  db 0x00, 0x00                                ; 06FA9
  db 0x00, 0x00                                ; 06FAB
  db 0x00, 0x00                                ; 06FAD
  db 0x00, 0x00                                ; 06FAF
  db 0x00, 0x00                                ; 06FB1
  db 0x00, 0x00                                ; 06FB3
  db 0x00, 0x00                                ; 06FB5
  db 0x00, 0x00                                ; 06FB7
  db 0x00, 0x00                                ; 06FB9
  db 0x00, 0x00                                ; 06FBB
  db 0x00, 0x00                                ; 06FBD
  db 0x00, 0x00                                ; 06FBF
  db 0x00, 0x00                                ; 06FC1
  db 0x00, 0x00                                ; 06FC3
  db 0x00, 0x00                                ; 06FC5
  db 0x00, 0x00                                ; 06FC7
  db 0x00, 0x00                                ; 06FC9
  db 0x00, 0x00                                ; 06FCB
  db 0x00, 0x00                                ; 06FCD
  db 0x00, 0x00                                ; 06FCF
  db 0x00, 0x00                                ; 06FD1
  db 0x00, 0x00                                ; 06FD3
  db 0x00, 0x00                                ; 06FD5
  db 0x00, 0x00                                ; 06FD7
  db 0x00, 0x00                                ; 06FD9
  db 0x00, 0x00                                ; 06FDB
  db 0x00, 0x00                                ; 06FDD
  db 0x00, 0x00                                ; 06FDF
  db 0x00, 0x00                                ; 06FE1
  db 0x00, 0x00                                ; 06FE3
  db 0x00, 0x00                                ; 06FE5
  db 0x00, 0x00                                ; 06FE7
  db 0x00, 0x00                                ; 06FE9
  db 0x00, 0x00                                ; 06FEB
  db 0x00, 0x00                                ; 06FED
  db 0x00, 0x00                                ; 06FEF
  db 0x00, 0x00                                ; 06FF1
  db 0x00, 0x00                                ; 06FF3
  db 0x00, 0x00                                ; 06FF5
  db 0x00, 0x00                                ; 06FF7
  db 0x00, 0x00                                ; 06FF9
  db 0x00, 0x00                                ; 06FFB
  db 0x00, 0x00                                ; 06FFD
  db 0x00, 0x00                                ; 06FFF
  db 0x00, 0x00                                ; 07001
  db 0x00, 0x00                                ; 07003
  db 0x00, 0x00                                ; 07005
  db 0x00, 0x00                                ; 07007
  db 0x00, 0x00                                ; 07009
  db 0x00, 0x00                                ; 0700B
  db 0x00, 0x00                                ; 0700D
  db 0x00, 0x00                                ; 0700F
  db 0x00, 0x00                                ; 07011
  db 0x00, 0x00                                ; 07013
  db 0x00, 0x00                                ; 07015
  db 0x00, 0x00                                ; 07017
  db 0x00, 0x00                                ; 07019
  rol byte [bp + di], 1                        ; 0701B  0xD0, 0x03
  and al, 0x24                                 ; 0701D  0x24, 0x24
  and al, 0x24                                 ; 0701F  0x24, 0x24
  and al, 0x24                                 ; 07021  0x24, 0x24
  and al, 0x24                                 ; 07023  0x24, 0x24
  db 0x00, 0x00                                ; 07025
  db 0x00, 0x00                                ; 07027
  and al, 0x24                                 ; 07029  0x24, 0x24
  and al, 0x24                                 ; 0702B  0x24, 0x24
  and al, 0x24                                 ; 0702D  0x24, 0x24
  and al, 0x24                                 ; 0702F  0x24, 0x24
  rol byte [bp + di], cl                      ; 07031
  push sp                                      ; 07033  0x54
  add al, 0                                    ; 07034  0x04, 0x00
  db 0x00, 0x00                                ; 07036
  db 0x00, 0x00                                ; 07038
  add [bx + di], al                            ; 0703A  0x00, 0x01
  db 0x00, 0x00                                ; 0703C
  db 0x00, 0x00                                ; 0703E
  db 0x00, 0x00                                ; 07040
  db 0x00, 0x00                                ; 07042
  db 0x00, 0x00                                ; 07044
  add [di], ax                                 ; 07046  0x01, 0x05
  db 0x00                                      ; 07048
  db "Init    ", 0                             ; 07049  process/queue name "Init    " 
  db 0x00, 0x00                                ; 07052
  db 0x00, 0x00                                ; 07054
  db 0x00, 0x00                                ; 07056
  db 0x00, 0x00                                ; 07058
  db 0x00, 0x00                                ; 0705A
  db 0x00, 0x00                                ; 0705C
  db 0x00, 0x00                                ; 0705E
  db 0x00, 0x00                                ; 07060
  db 0x00, 0x00                                ; 07062
  db 0x00, 0x00                                ; 07064
  db 0x00, 0x00                                ; 07066
  db 0x00, 0x00                                ; 07068
  db 0x00, 0x00                                ; 0706A
  db 0x00, 0x00                                ; 0706C
  db 0x00, 0x00                                ; 0706E
  db 0x00, 0x00                                ; 07070
  db 0x00, 0x00                                ; 07072
  db 0x00, 0x00                                ; 07074
  db 0x00, 0x00                                ; 07076
  db 0x00, 0x00                                ; 07078
  db 0x00, 0x00                                ; 0707A
  db 0x00, 0x00                                ; 0707C
  db 0x00, 0x00                                ; 0707E
  db 0x00, 0x00                                ; 07080
  db 0x00, 0x00                                ; 07082
  db 0x00, 0x00                                ; 07084
  db 0x00, 0x00                                ; 07086
  db 0x00, 0x00                                ; 07088
  db 0x00, 0x00                                ; 0708A
  db 0x00, 0x00                                ; 0708C
  db 0x00, 0x00                                ; 0708E
  db 0x00, 0x00                                ; 07090
  db 0x00, 0x00                                ; 07092
  db 0x00, 0x00                                ; 07094
  db 0x00, 0x00                                ; 07096
  db 0x00, 0x00                                ; 07098
  db 0x00, 0x00                                ; 0709A
  db 0x00, 0x00                                ; 0709C
  db 0x00, 0x00                                ; 0709E
  db 0x00, 0x00                                ; 070A0
  db 0x00, 0x00                                ; 070A2
  db 0x00, 0x00                                ; 070A4
  db 0x00, 0x00                                ; 070A6
  db 0x00, 0x00                                ; 070A8
  db 0x00, 0x00                                ; 070AA
  db 0x00, 0x00                                ; 070AC
  db 0x00, 0x00                                ; 070AE
  db 0x00, 0x00                                ; 070B0
  db 0x00, 0x00                                ; 070B2
  db 0x00, 0x00                                ; 070B4
  db 0x00, 0x00                                ; 070B6
  db 0x00, 0x00                                ; 070B8
  db 0x00, 0x00                                ; 070BA
  db 0x00, 0x00                                ; 070BC
  db 0x00, 0x00                                ; 070BE
  db 0x00, 0x00                                ; 070C0
  db 0x00, 0x00                                ; 070C2
  db 0x00, 0x00                                ; 070C4
  db 0x00, 0x00                                ; 070C6
  db 0x00, 0x00                                ; 070C8
  db 0x00, 0x00                                ; 070CA
  db 0x00, 0x00                                ; 070CC
  db 0x00, 0x00                                ; 070CE
  db 0x00, 0x00                                ; 070D0
  db 0x00, 0x00                                ; 070D2
  db 0x00, 0x00                                ; 070D4
  db 0x00, 0x00                                ; 070D6
  db 0x00, 0x00                                ; 070D8
  db 0x00, 0x00                                ; 070DA
  db 0x00, 0x00                                ; 070DC
  db 0x00, 0x00                                ; 070DE
  add [bx + si], ax                            ; 070E0  0x01, 0x00
  db 0x00, 0x00                                ; 070E2
  db 0x00, 0x00                                ; 070E4
  db 0x00, 0x00                                ; 070E6
  db 0x00, 0x00                                ; 070E8
  db 0x00, 0x00                                ; 070EA
  db 0x00, 0x00                                ; 070EC
  db 0x00, 0x00                                ; 070EE
  db 0x00, 0x00                                ; 070F0
  db 0x00, 0x00                                ; 070F2
  db 0x00, 0x00                                ; 070F4
  db 0x00, 0x00                                ; 070F6
  db 0x00, 0x00                                ; 070F8
  db 0x00, 0x00                                ; 070FA
  db 0x00, 0x00                                ; 070FC
  db 0x00, 0x00                                ; 070FE
  db 0x00, 0x00                                ; 07100
  db 0x00, 0x00                                ; 07102
  db 0x00, 0x00                                ; 07104
  db 0x00, 0x00                                ; 07106
  db 0x00, 0x00                                ; 07108
  db 0x00, 0x00                                ; 0710A
  db 0x00, 0x00                                ; 0710C
  db 0x00, 0x00                                ; 0710E
  db 0x00, 0x00                                ; 07110
  db 0x00, 0x00                                ; 07112
  db 0x00, 0x00                                ; 07114
  db 0x00, 0x00                                ; 07116
  db 0x00, 0x00                                ; 07118
  db 0x00, 0x00                                ; 0711A
  db 0x00, 0x00                                ; 0711C
  db 0x00, 0x00                                ; 0711E
  db 0x00, 0x00                                ; 07120
  db 0x00, 0x00                                ; 07122
  db 0x00, 0x00                                ; 07124
  db 0x00, 0x00                                ; 07126
  db 0x00, 0x00                                ; 07128
  db 0x00, 0x00                                ; 0712A
  db 0x00, 0x00                                ; 0712C
  db 0x00, 0x00                                ; 0712E
  db 0x00, 0x00                                ; 07130
  db 0x00, 0x00                                ; 07132
  db 0x00, 0x00                                ; 07134
  db 0x00, 0x00                                ; 07136
  db 0x00, 0x00                                ; 07138
  db 0x00, 0x00                                ; 0713A
  db 0x00, 0x00                                ; 0713C
  db 0x00, 0x00                                ; 0713E
  db 0x00, 0x00                                ; 07140
  db 0x00, 0x00                                ; 07142
  db 0x00, 0x00                                ; 07144
  db 0x00, 0x00                                ; 07146
  db 0x00, 0x00                                ; 07148
  db 0x00, 0x00                                ; 0714A
  db 0x00, 0x00                                ; 0714C
  db 0x00, 0x00                                ; 0714E
  db 0x00, 0x00                                ; 07150
  db 0x00, 0x00                                ; 07152
  db 0x00, 0x00                                ; 07154
  db 0x00, 0x00                                ; 07156
  db 0x00, 0x00                                ; 07158
  db 0x00, 0x00                                ; 0715A
  db 0x00, 0x00                                ; 0715C
  db 0x00, 0x00                                ; 0715E
  db 0x00, 0x00                                ; 07160
  db 0x00, 0x00                                ; 07162
  db 0x00, 0x00                                ; 07164
  db 0x00, 0x00                                ; 07166
  db 0x00, 0x00                                ; 07168
  db 0x00, 0x00                                ; 0716A
  db 0x00, 0x00                                ; 0716C
  db 0x00, 0x00                                ; 0716E
  db 0x00, 0x00                                ; 07170
  db 0x00, 0x00                                ; 07172
  db 0x00, 0x00                                ; 07174
  db 0x00, 0x00                                ; 07176
  db 0x00, 0x00                                ; 07178
  db 0x00, 0x00                                ; 0717A
  db 0x00, 0x00                                ; 0717C
  db 0x00, 0x00                                ; 0717E
  db 0xCC                                      ; 07180  int3
  db 0xCC                                      ; 07181  int3
  db 0xCC                                      ; 07182  int3
  db 0xCC                                      ; 07183  int3
  db 0xCC                                      ; 07184  int3
  db 0xCC                                      ; 07185  int3
  db 0xCC                                      ; 07186  int3
  db 0xCC                                      ; 07187  int3
  db 0xCC                                      ; 07188  int3
  db 0xCC                                      ; 07189  int3
  db 0xCC                                      ; 0718A  int3
  db 0xCC                                      ; 0718B  int3
  db 0xCC                                      ; 0718C  int3
  db 0xCC                                      ; 0718D  int3
  db 0xCC                                      ; 0718E  int3
  db 0xCC                                      ; 0718F  int3
  db 0xCC                                      ; 07190  int3
  db 0xCC                                      ; 07191  int3
  db 0xCC                                      ; 07192  int3
  db 0xCC                                      ; 07193  int3
  db 0xCC                                      ; 07194  int3
  db 0xCC                                      ; 07195  int3
  db 0xCC                                      ; 07196  int3
  db 0xCC                                      ; 07197  int3
  db 0xCC                                      ; 07198  int3
  db 0xCC                                      ; 07199  int3
  db 0xCC                                      ; 0719A  int3
  db 0xCC                                      ; 0719B  int3
  db 0xCC                                      ; 0719C  int3
  db 0xCC                                      ; 0719D  int3
  db 0xCC                                      ; 0719E  int3
  db 0xCC                                      ; 0719F  int3
  db 0xCC                                      ; 071A0  int3
  db 0xCC                                      ; 071A1  int3
  db 0xCC                                      ; 071A2  int3
  db 0xCC                                      ; 071A3  int3
  db 0xCC                                      ; 071A4  int3
  db 0xCC                                      ; 071A5  int3
  db 0xCC                                      ; 071A6  int3
  db 0xCC                                      ; 071A7  int3
  db 0xCC                                      ; 071A8  int3
  db 0xCC                                      ; 071A9  int3
  db 0xCC                                      ; 071AA  int3
  db 0xCC                                      ; 071AB  int3
  db 0xCC                                      ; 071AC  int3
  db 0xCC                                      ; 071AD  int3
  db 0xCC                                      ; 071AE  int3
  db 0xCC                                      ; 071AF  int3
  db 0xCC                                      ; 071B0  int3
  db 0xCC                                      ; 071B1  int3
  db 0xCC                                      ; 071B2  int3
  db 0xCC                                      ; 071B3  int3
  db 0xCC                                      ; 071B4  int3
  db 0xCC                                      ; 071B5  int3
  db 0xCC                                      ; 071B6  int3
  db 0xCC                                      ; 071B7  int3
  db 0xCC                                      ; 071B8  int3
  db 0xCC                                      ; 071B9  int3
  db 0xCC                                      ; 071BA  int3
  db 0xCC                                      ; 071BB  int3
  db 0xCC                                      ; 071BC  int3
  db 0xCC                                      ; 071BD  int3
  db 0xCC                                      ; 071BE  int3
  db 0xCC                                      ; 071BF  int3
  db 0xCC                                      ; 071C0  int3
  db 0xCC                                      ; 071C1  int3
  db 0xCC                                      ; 071C2  int3
  db 0xCC                                      ; 071C3  int3
  db 0xCC                                      ; 071C4  int3
  db 0xCC                                      ; 071C5  int3
  db 0xCC                                      ; 071C6  int3
  db 0xCC                                      ; 071C7  int3
  db 0xCC                                      ; 071C8  int3
  db 0xCC                                      ; 071C9  int3
  db 0xCC                                      ; 071CA  int3
  db 0xCC                                      ; 071CB  int3
  db 0xCC                                      ; 071CC  int3
  db 0xCC                                      ; 071CD  int3
  db 0xCC                                      ; 071CE  int3
  db 0xCC                                      ; 071CF  int3
  db 0xCC                                      ; 071D0  int3
  db 0xCC                                      ; 071D1  int3
  db 0xCC                                      ; 071D2  int3
  db 0xCC                                      ; 071D3  int3
  db 0xCC                                      ; 071D4  int3
  db 0xCC                                      ; 071D5  int3
  db 0xCC                                      ; 071D6  int3
  db 0xCC                                      ; 071D7  int3
  db 0xCC                                      ; 071D8  int3
  db 0xCC                                      ; 071D9  int3
  db 0xCC                                      ; 071DA  int3
  db 0xCC                                      ; 071DB  int3
  db 0xCC                                      ; 071DC  int3
  db 0xCC                                      ; 071DD  int3
  db 0xCC                                      ; 071DE  int3
  db 0xCC                                      ; 071DF  int3
  db 0xCC                                      ; 071E0  int3
  db 0xCC                                      ; 071E1  int3
  db 0xCC                                      ; 071E2  int3
  db 0xCC                                      ; 071E3  int3
  db 0xCC                                      ; 071E4  int3
  db 0xCC                                      ; 071E5  int3
  db 0xCC                                      ; 071E6  int3
  db 0xCC                                      ; 071E7  int3
  db 0xCC                                      ; 071E8  int3
  db 0xCC                                      ; 071E9  int3
  db 0xCC                                      ; 071EA  int3
  db 0xCC                                      ; 071EB  int3
  db 0xCC                                      ; 071EC  int3
  db 0xCC                                      ; 071ED  int3
  db 0xCC                                      ; 071EE  int3
  db 0xCC                                      ; 071EF  int3
  db 0xCC                                      ; 071F0  int3
  db 0xCC                                      ; 071F1  int3
  db 0x00, 0x00                                ; 071F2
  db 0x00, 0x00                                ; 071F4
  db 0x00, 0x00                                ; 071F6
  db 0x00, 0x00                                ; 071F8
  db 0x00, 0x00                                ; 071FA
  db 0x00, 0x00                                ; 071FC
  db 0x00, 0x00                                ; 071FE
  db 0x00, 0x00                                ; 07200
  db 0x00, 0x00                                ; 07202
  db 0x00, 0x00                                ; 07204
  db 0x00, 0x00                                ; 07206
  db 0x00, 0x00                                ; 07208
  db 0x00, 0x00                                ; 0720A
  db 0x00, 0x00                                ; 0720C
  db 0x00, 0x00                                ; 0720E
  db 0x00, 0x00                                ; 07210
  db 0x00, 0x00                                ; 07212
  db 0xCC                                      ; 07214  int3
  db 0xCC                                      ; 07215  int3
  db 0xCC                                      ; 07216  int3
  db 0xCC                                      ; 07217  int3
  db 0xCC                                      ; 07218  int3
  db 0xCC                                      ; 07219  int3
  db 0xCC                                      ; 0721A  int3
  db 0xCC                                      ; 0721B  int3
  db 0xCC                                      ; 0721C  int3
  db 0xCC                                      ; 0721D  int3
  db 0xCC                                      ; 0721E  int3
  db 0xCC                                      ; 0721F  int3
  db 0xCC                                      ; 07220  int3
  db 0xCC                                      ; 07221  int3
  db 0xCC                                      ; 07222  int3
  db 0xCC                                      ; 07223  int3
  db 0xCC                                      ; 07224  int3
  db 0xCC                                      ; 07225  int3
  db 0xCC                                      ; 07226  int3
  db 0xCC                                      ; 07227  int3
  db 0xCC                                      ; 07228  int3
  db 0xCC                                      ; 07229  int3
  db 0xCC                                      ; 0722A  int3
  db 0xCC                                      ; 0722B  int3
  db 0xCC                                      ; 0722C  int3
  db 0xCC                                      ; 0722D  int3
  db 0xCC                                      ; 0722E  int3
  db 0xCC                                      ; 0722F  int3
  db 0xCC                                      ; 07230  int3
  db 0xCC                                      ; 07231  int3
  db 0xCC                                      ; 07232  int3
  db 0xCC                                      ; 07233  int3
  db 0xCC                                      ; 07234  int3
  db 0xCC                                      ; 07235  int3
  db 0xCC                                      ; 07236  int3
  db 0xCC                                      ; 07237  int3
  db 0xCC                                      ; 07238  int3
  db 0xCC                                      ; 07239  int3
  db 0xCC                                      ; 0723A  int3
  db 0xCC                                      ; 0723B  int3
  db 0xCC                                      ; 0723C  int3
  db 0xCC                                      ; 0723D  int3
  db 0xCC                                      ; 0723E  int3
  db 0xCC                                      ; 0723F  int3
  db 0xCC                                      ; 07240  int3
  db 0xCC                                      ; 07241  int3
  db 0xCC                                      ; 07242  int3
  db 0xCC                                      ; 07243  int3
  db 0xCC                                      ; 07244  int3
  db 0xCC                                      ; 07245  int3
  db 0xCC                                      ; 07246  int3
  db 0xCC                                      ; 07247  int3
  db 0xCC                                      ; 07248  int3
  db 0xCC                                      ; 07249  int3
  db 0xCC                                      ; 0724A  int3
  db 0xCC                                      ; 0724B  int3
  db 0xCC                                      ; 0724C  int3
  db 0xCC                                      ; 0724D  int3
  db 0xCC                                      ; 0724E  int3
  db 0xCC                                      ; 0724F  int3
  db 0xCC                                      ; 07250  int3
  db 0xCC                                      ; 07251  int3
  db 0xCC                                      ; 07252  int3
  db 0xCC                                      ; 07253  int3
  db 0xCC                                      ; 07254  int3
  db 0xCC                                      ; 07255  int3
  db 0xCC                                      ; 07256  int3
  db 0xCC                                      ; 07257  int3
  db 0xCC                                      ; 07258  int3
  db 0xCC                                      ; 07259  int3
  db 0xCC                                      ; 0725A  int3
  db 0xCC                                      ; 0725B  int3
  db 0xCC                                      ; 0725C  int3
  db 0xCC                                      ; 0725D  int3
  db 0xCC                                      ; 0725E  int3
  db 0xCC                                      ; 0725F  int3
  db 0xCC                                      ; 07260  int3
  db 0xCC                                      ; 07261  int3
  db 0xCC                                      ; 07262  int3
  db 0xCC                                      ; 07263  int3
  db 0xCC                                      ; 07264  int3
  db 0xCC                                      ; 07265  int3
  db 0xCC                                      ; 07266  int3
  db 0xCC                                      ; 07267  int3
  db 0xCC                                      ; 07268  int3
  db 0xCC                                      ; 07269  int3
  db 0xCC                                      ; 0726A  int3
  db 0xCC                                      ; 0726B  int3
  db 0xCC                                      ; 0726C  int3
  db 0xCC                                      ; 0726D  int3
  db 0xCC                                      ; 0726E  int3
  db 0xCC                                      ; 0726F  int3
  db 0xCC                                      ; 07270  int3
  db 0xCC                                      ; 07271  int3
  db 0xCC                                      ; 07272  int3
  db 0xCC                                      ; 07273  int3
  db 0xCC                                      ; 07274  int3
  db 0xCC                                      ; 07275  int3
  db 0xCC                                      ; 07276  int3
  db 0xCC                                      ; 07277  int3
  db 0xCC                                      ; 07278  int3
  db 0xCC                                      ; 07279  int3
  db 0xCC                                      ; 0727A  int3
  db 0xCC                                      ; 0727B  int3
  db 0xCC                                      ; 0727C  int3
  db 0xCC                                      ; 0727D  int3
  db 0xCC                                      ; 0727E  int3
  db 0xCC                                      ; 0727F  int3
  db 0xCC                                      ; 07280  int3
  db 0xCC                                      ; 07281  int3
  db 0xCC                                      ; 07282  int3
  db 0xCC                                      ; 07283  int3
  db 0xCC                                      ; 07284  int3
  db 0xCC                                      ; 07285  int3
  db 0xCC                                      ; 07286  int3
  db 0xCC                                      ; 07287  int3
  db 0xCC                                      ; 07288  int3
  db 0xCC                                      ; 07289  int3
  db 0xCC                                      ; 0728A  int3
  db 0xCC                                      ; 0728B  int3
  db 0xCC                                      ; 0728C  int3
  db 0xCC                                      ; 0728D  int3
  db 0xCC                                      ; 0728E  int3
  db 0xCC                                      ; 0728F  int3
  db 0xCC                                      ; 07290  int3
  db 0xCC                                      ; 07291  int3
  db 0xCC                                      ; 07292  int3
  db 0xCC                                      ; 07293  int3
  add ch, bh                                   ; 07294  0x00, 0xFD
  push es                                      ; 07296  0x06
  db 0x00, 0x00                                ; 07297
  db 0x00, 0x00                                ; 07299
  db 0x00, 0x00                                ; 0729B
  add ax, strict word 7                        ; 0729D  05 07 00
  db 0x00, 0x00                                ; 072A0
  db 0x00, 0x00                                ; 072A2
  add [di], cl                                 ; 072A4  0x00, 0x0D
  pop es                                       ; 072A6  0x07
  db 0x00, 0x00                                ; 072A7
  db 0x00, 0x00                                ; 072A9
  db 0x00, 0x00                                ; 072AB
  or ax, [fs:bx + si]                          ; 072AD  0x64, 0x0B, 0x00
  db 0x00, 0x00                                ; 072B0
  db 0x00, 0x00                                ; 072B2
  db 0x00, 0x00                                ; 072B4
  db 0x00, 0x00                                ; 072B6
  db 0x00, 0x00                                ; 072B8
  db 0x00, 0x00                                ; 072BA
  db 0x00, 0x00                                ; 072BC
  db 0x00, 0x00                                ; 072BE
  db 0x00, 0x00                                ; 072C0
  db 0x00, 0x00                                ; 072C2
  db 0x00, 0x00                                ; 072C4
  db 0x00, 0x00                                ; 072C6
  db 0x00, 0x00                                ; 072C8
  db 0x00, 0x00                                ; 072CA
  db 0x00, 0x00                                ; 072CC
  db 0x00, 0x00                                ; 072CE
  db 0x00, 0x00                                ; 072D0
  db 0x00, 0x00                                ; 072D2
  db 0x00, 0x00                                ; 072D4
  db 0x00, 0x00                                ; 072D6
  db 0x00, 0x00                                ; 072D8
  db 0x00, 0x00                                ; 072DA
  db 0x00, 0x00                                ; 072DC
  db 0x00, 0x00                                ; 072DE
  db 0x00, 0x00                                ; 072E0
  db 0x00, 0x00                                ; 072E2
  db 0x00, 0x00                                ; 072E4
  db 0x00, 0x00                                ; 072E6
  db 0x00, 0x00                                ; 072E8
  db 0x00, 0x00                                ; 072EA
  db 0x00, 0x00                                ; 072EC
  db 0x00, 0x00                                ; 072EE
  db 0x00, 0x00                                ; 072F0
  db 0x00, 0x00                                ; 072F2
  db 0x00, 0x00                                ; 072F4
  db 0x00, 0x00                                ; 072F6
  db 0x00, 0x00                                ; 072F8
  db 0x00, 0x00                                ; 072FA
  db 0x00, 0x00                                ; 072FC
  db 0x00, 0x00                                ; 072FE
  db 0x00, 0x00                                ; 07300
  db 0x00, 0x00                                ; 07302
  db 0x00, 0x00                                ; 07304
  db 0x00, 0x00                                ; 07306
  db 0x00, 0x00                                ; 07308
  db 0x00, 0x00                                ; 0730A
  db 0x00, 0x00                                ; 0730C
  db 0x00, 0x00                                ; 0730E
  db 0x00, 0x00                                ; 07310
  db 0x00, 0x00                                ; 07312
  db 0x00, 0x00                                ; 07314
  db 0x00, 0x00                                ; 07316
  db 0x00, 0x00                                ; 07318
  db 0x00, 0x00                                ; 0731A
  db 0x00, 0x00                                ; 0731C
  db 0x00, 0x00                                ; 0731E
  db 0x00, 0x00                                ; 07320
  db 0x00, 0x00                                ; 07322
  db 0x00, 0x00                                ; 07324
  db 0x00, 0x00                                ; 07326
  db 0x00, 0x00                                ; 07328
  db 0x00, 0x00                                ; 0732A
  db 0x00, 0x00                                ; 0732C
  db 0x00, 0x00                                ; 0732E
  db 0x00, 0x00                                ; 07330
  db 0x00, 0x00                                ; 07332
  db 0x00, 0x00                                ; 07334
  db 0x00, 0x00                                ; 07336
  db 0x00, 0x00                                ; 07338
  db 0x00, 0x00                                ; 0733A
  db 0x00, 0x00                                ; 0733C
  db 0x00, 0x00                                ; 0733E
  db 0x00, 0x00                                ; 07340
  db 0x00, 0x00                                ; 07342
  db 0x00, 0x00                                ; 07344
  db 0x00, 0x00                                ; 07346
  db 0x00, 0x00                                ; 07348
  db 0x00, 0x00                                ; 0734A
  db 0x00, 0x00                                ; 0734C
  db 0x00, 0x00                                ; 0734E
  db 0x00, 0x00                                ; 07350
  db 0x00, 0x00                                ; 07352
  db 0x00, 0x00                                ; 07354
  db 0x00, 0x00                                ; 07356
  db 0x00, 0x00                                ; 07358
  db 0x00, 0x00                                ; 0735A
  db 0x00, 0x00                                ; 0735C
  db 0x00, 0x00                                ; 0735E
  db 0x00, 0x00                                ; 07360
  db 0x00, 0x00                                ; 07362
  db 0x00, 0x00                                ; 07364
  db 0x00, 0x00                                ; 07366
  db 0x00, 0x00                                ; 07368
  db 0x00, 0x00                                ; 0736A
  db 0x00, 0x00                                ; 0736C
  db 0x00, 0x00                                ; 0736E
  db 0x00, 0x00                                ; 07370
  db 0x00, 0x00                                ; 07372
  db 0x00, 0x00                                ; 07374
  db 0x00, 0x00                                ; 07376
  db 0x00, 0x00                                ; 07378
  db 0x00, 0x00                                ; 0737A
  db 0x00, 0x00                                ; 0737C
  db 0x00, 0x00                                ; 0737E
  db 0x00, 0x00                                ; 07380
  db 0x00, 0x00                                ; 07382
  db 0x00, 0x00                                ; 07384
  db 0x00, 0x00                                ; 07386
  db 0x00, 0x00                                ; 07388
  db 0x00, 0x00                                ; 0738A
  db 0x00, 0x00                                ; 0738C
  db 0x00, 0x00                                ; 0738E
  db 0x00, 0x00                                ; 07390
  db 0x00, 0x00                                ; 07392
  db 0x00, 0x00                                ; 07394
  db 0x00, 0x00                                ; 07396
  db 0x00, 0x00                                ; 07398
  db 0x00, 0x00                                ; 0739A
  db 0x00, 0x00                                ; 0739C
  db 0x00, 0x00                                ; 0739E
  db 0x00, 0x00                                ; 073A0
  db 0x00, 0x00                                ; 073A2
  db 0x00, 0x00                                ; 073A4
  db 0x00, 0x00                                ; 073A6
  db 0x00, 0x00                                ; 073A8
  db 0x00, 0x00                                ; 073AA
  db 0x00, 0x00                                ; 073AC
  db 0x00, 0x00                                ; 073AE
  db 0x00, 0x00                                ; 073B0
  db 0x00, 0x00                                ; 073B2
  db 0x00, 0x00                                ; 073B4
  db 0x00, 0x00                                ; 073B6
  db 0x00, 0x00                                ; 073B8
  db 0x00, 0x00                                ; 073BA
  db 0x00, 0x00                                ; 073BC
  db 0x00, 0x00                                ; 073BE
  add [bx + si], ax                            ; 073C0  0x01, 0x00
  db 0x00, 0x00                                ; 073C2
  add [bx], ah                                 ; 073C4  0x00, 0x27
  or [di], ch                                  ; 073C6  0x08, 0x2D
  or [bx + si], al                             ; 073C8  0x08, 0x00
  add bh, bh                                   ; 073CA  0x00, 0xFF
  add [bp + di], dh                            ; 073CC  0x00, 0x33
  or [bx + si], al                             ; 073CE  0x08, 0x00
  add bh, bh                                   ; 073D0  0x00, 0xFF
  add [bx + di], bh                            ; 073D2  0x00, 0x39
  or [bx + si], al                             ; 073D4  0x08, 0x00
  add bh, bh                                   ; 073D6  0x00, 0xFF
  add [bx], bh                                 ; 073D8  0x00, 0x3F
  or [bx + si], al                             ; 073DA  0x08, 0x00
  add bh, bh                                   ; 073DC  0x00, 0xFF
  add [di + 8], al                             ; 073DE  0x00, 0x45, 0x08
  db 0x00, 0x00                                ; 073E1
  inc word [bx + si]                           ; 073E3  0xFF, 0x00
  db 0x00, 0x00                                ; 073E5
  db 0x00, 0x00                                ; 073E7
  inc word [bx + si]                           ; 073E9  0xFF, 0x00
  db 0x00, 0x00                                ; 073EB
  db 0x00, 0x00                                ; 073ED
  db 0x00, 0x00                                ; 073EF
  db 0x00, 0x00                                ; 073F1
  db 0x00, 0x00                                ; 073F3
  db 0x00, 0x00                                ; 073F5
  db 0x00, 0x00                                ; 073F7
  db 0x00, 0x00                                ; 073F9
  db 0x00, 0x00                                ; 073FB
  db 0x00, 0x00                                ; 073FD
  db 0x00, 0x00                                ; 073FF
  db 0x00, 0x00                                ; 07401
  db 0x00, 0x00                                ; 07403
  db 0x00, 0x00                                ; 07405
  db 0x00, 0x00                                ; 07407
  db 0x00, 0x00                                ; 07409
  db 0x00, 0x00                                ; 0740B
  db 0x00, 0x00                                ; 0740D
  db 0x00, 0x00                                ; 0740F
  db 0x00, 0x00                                ; 07411
  db 0x00, 0x00                                ; 07413
  db 0x00, 0x00                                ; 07415
  db 0x00, 0x00                                ; 07417
  db 0x00, 0x00                                ; 07419
  db 0x00, 0x00                                ; 0741B
  db 0x00, 0x00                                ; 0741D
  db 0x00, 0x00                                ; 0741F
  inc word [bx + si]                           ; 07421  0xFF, 0x00
  db 0x00, 0x00                                ; 07423
  db 0x00, 0x00                                ; 07425
  db 0x00, 0x00                                ; 07427
  db 0x00, 0x00                                ; 07429
  db 0x00, 0x00                                ; 0742B
  db 0x00, 0x00                                ; 0742D
  db 0x00, 0x00                                ; 0742F
  db 0x00, 0x00                                ; 07431
  db 0x00, 0x00                                ; 07433
  db 0x00, 0x00                                ; 07435
  db 0x00, 0x00                                ; 07437
  db 0x00, 0x00                                ; 07439
  db 0x00, 0x00                                ; 0743B
  db 0x00, 0x00                                ; 0743D
  db 0x00, 0x00                                ; 0743F
  db 0x00, 0x00                                ; 07441
  db 0x00, 0x00                                ; 07443
  db 0x00, 0x00                                ; 07445
  db 0x00, 0x00                                ; 07447
  db 0x00, 0x00                                ; 07449
  db 0x00, 0x00                                ; 0744B
  db 0x00, 0x00                                ; 0744D
  db 0x00, 0x00                                ; 0744F
  db 0x00, 0x00                                ; 07451
  db 0x00, 0x00                                ; 07453
  db 0x00, 0x00                                ; 07455
  db 0x00, 0x00                                ; 07457
  db 0x00, 0x00                                ; 07459
  db 0x00, 0x00                                ; 0745B
  db 0x00, 0x00                                ; 0745D
  db 0x00, 0x00                                ; 0745F
  db 0x00, 0x00                                ; 07461
  db 0x00, 0x00                                ; 07463
  db 0x00, 0x00                                ; 07465
  db 0x00, 0x00                                ; 07467
  db 0x00, 0x00                                ; 07469
  db 0x00, 0x00                                ; 0746B
  db 0x00, 0x00                                ; 0746D
  db 0x00, 0x00                                ; 0746F
  db 0x00, 0x00                                ; 07471
  db 0x00, 0x00                                ; 07473
  db 0x00, 0x00                                ; 07475
  db 0x00, 0x00                                ; 07477
  db 0x00, 0x00                                ; 07479
  db 0x00, 0x00                                ; 0747B
  db 0x00, 0x00                                ; 0747D
  db 0x00, 0x00                                ; 0747F
  push dx                                      ; 07481  0x52
  db 0x00, 0x00                                ; 07482
  db 0x00, 0x00                                ; 07484
  db 0x00, 0x00                                ; 07486
  db 0x00, 0x00                                ; 07488
  db 0x00, 0x00                                ; 0748A
  db 0x00, 0x00                                ; 0748C
  db 0x00, 0x00                                ; 0748E
  db 0x00, 0x00                                ; 07490
  db 0x00, 0x00                                ; 07492
  db 0x00, 0x00                                ; 07494
  db 0x00, 0x00                                ; 07496
  db 0x00, 0x00                                ; 07498
  db 0x00, 0x00                                ; 0749A
  db 0x00, 0x00                                ; 0749C
  db 0x00, 0x00                                ; 0749E
  db 0x00, 0x00                                ; 074A0
  db 0x00, 0x00                                ; 074A2
  db 0x00, 0x00                                ; 074A4
  db 0x00, 0x00                                ; 074A6
  db 0x00, 0x00                                ; 074A8
  db 0x00, 0x00                                ; 074AA
  db 0x00, 0x00                                ; 074AC
  db 0x00, 0x00                                ; 074AE
; -----------------------------------------------------------------------------
; SYSDAT BDOS / XIOS Error and Status Message Strings (0x074B0 - 0x07699)
; -----------------------------------------------------------------------------
sysdat_err_messages:
  db 0x0D, 0x0A, "CP/M Error On  : ", 0
  db "Disk I/O", 0
  db "Read/Only Disk", 0
  db "Read/Only File", 0
  db "Invalid Drive", 0
  db "File Opened in Read/Only Mode", 0
  db "File Currently Open", 0
  db "Close Checksum Error", 0
  db "Password Error", 0
  db "File Already Exists", 0
  db "Illegal ? in FCB", 0
  db "Open File Limit Exceeded", 0
  db "No Room in System Lock List", 0
  db 0x0D, 0x0A, 0
  db 0x0D, 0x0A, "Bdos Function =     File = ", 0
  times 12 db 0
  db 0x0D, 0x0A, "Disk reset denied, Drive ", 0
  db ": Console ", 0
  db " Program 12345678", 0
  db 0
  times 138 db 0xCC

  db 0x00, 0x00                                ; 0769A
  db 0x00, 0x00                                ; 0769C
  db 0x00, 0x00                                ; 0769E
  db 0x00, 0x00                                ; 076A0
  db 0x00, 0x00                                ; 076A2
  db 0x00, 0x00                                ; 076A4
  db 0x00, 0x00                                ; 076A6
  db 0x00, 0x00                                ; 076A8
  db 0x00, 0x00                                ; 076AA
  db 0x00, 0x00                                ; 076AC
  db 0x00, 0x00                                ; 076AE
  db 0x00, 0x00                                ; 076B0
  db 0x00, 0x00                                ; 076B2
  db 0x00, 0x00                                ; 076B4
  db 0x00, 0x00                                ; 076B6
  db 0x00, 0x00                                ; 076B8
  db 0x00, 0x00                                ; 076BA
  db 0x00, 0x00                                ; 076BC
  db 0x00, 0x00                                ; 076BE
  db 0x00, 0x00                                ; 076C0
  db 0x00, 0x00                                ; 076C2
  db 0x00, 0x00                                ; 076C4
  db 0x00, 0x00                                ; 076C6
  db 0x00, 0x00                                ; 076C8
  db 0x00, 0x00                                ; 076CA
  db 0x00, 0x00                                ; 076CC
  db 0x00, 0x00                                ; 076CE
  db 0x00, 0x00                                ; 076D0
  db 0x00, 0x00                                ; 076D2
  db 0x00, 0x00                                ; 076D4
  db 0x00, 0x00                                ; 076D6
  db 0x00, 0x00                                ; 076D8
  db 0x00, 0x00                                ; 076DA
  add ax, [bx + si]                            ; 076DC  0x03, 0x00
  db "MXdisk  "                                ; 076DE  Mutual Exclusion Queue name "MXdisk  " 
  db 0x00, 0x00                                ; 076E6
  add [bx + si], ax                            ; 076E8  0x01, 0x00
  db 0x00, 0x00                                ; 076EA
  db 0x00, 0x00                                ; 076EC
  add [bx + si], ax                            ; 076EE  0x01, 0x00
  db 0x00, 0x00                                ; 076F0
  db 0x00, 0x00                                ; 076F2
  db 0x00, 0x00                                ; 076F4
  cmp [bp + di], cl                            ; 076F6  0x38, 0x0B
  add [bx + si], ax                            ; 076F8  0x01, 0x00
  db 0x00, 0x00                                ; 076FA
  db "MXdisk  "                                ; 076FC  Mutual Exclusion Queue name "MXdisk  " 
  db 0x00, 0x00                                ; 07704
  db 0x00, 0x00                                ; 07706
  db 0x00, 0x00                                ; 07708
  db 0x00, 0x00                                ; 0770A
  db 0x00, 0x00                                ; 0770C
  db 0x00, 0x00                                ; 0770E
  db 0x00, 0x00                                ; 07710
  db 0x00, 0x00                                ; 07712
  db 0x00, 0x00                                ; 07714
  db 0x00, 0x00                                ; 07716
  db 0x00, 0x00                                ; 07718
  db 0x00, 0x00                                ; 0771A
  db 0x00, 0x00                                ; 0771C
  db 0x00, 0x00                                ; 0771E
  pop ds                                       ; 07720  0x1F
  add [bp + di], bh                            ; 07721  0x00, 0x3B
  db 0x00, 0x5A, 0x00                          ; 07723  (SYSDAT data)
  js loc_07728                                 ; 07726  0x78, 0x00

loc_07728:                                     ; 07728
  xchg di, ax                                  ; 07728  0x97
  add [di - 0x2c00], dh                        ; 07729  0x00, 0xB5, 0x00, 0xD4
  add bl, dh                                   ; 0772D  0x00, 0xF3
  add [bx + di], dl                            ; 0772F  0x00, 0x11
  add [bx + si], si                            ; 07731  0x01, 0x30
  add [bp + 1], cx                             ; 07733  0x01, 0x4E, 0x01
  db 0x00, 0x00                                ; 07736
  db 0x00, 0x00                                ; 07738
  db 0x00, 0x00                                ; 0773A
  db 0x00, 0x00                                ; 0773C
  db 0x00, 0x00                                ; 0773E
  db 0x00, 0x00                                ; 07740
  db 0x00, 0x00                                ; 07742
  db 0x00, 0x00                                ; 07744
  db 0x00, 0x00                                ; 07746
  db 0x00, 0x00                                ; 07748
  db 0x00, 0x00                                ; 0774A
  db 0x00, 0x00                                ; 0774C
  db 0x00, 0x00                                ; 0774E
  db 0x00, 0x00                                ; 07750
  db 0x00, 0x00                                ; 07752
  db 0x00, 0x00                                ; 07754
  db 0x00, 0x00                                ; 07756
  db 0x00, 0x00                                ; 07758
  db 0x00, 0x00                                ; 0775A
  db 0x00, 0x00                                ; 0775C
  db 0x00, 0x00                                ; 0775E
  db 0x00, 0x00                                ; 07760
  db 0x00, 0x00                                ; 07762
  db 0x00, 0x00                                ; 07764
  db 0x00, 0x00                                ; 07766
  db 0x00, 0x00                                ; 07768
  db 0x00, 0x00                                ; 0776A
  db 0x00, 0x00                                ; 0776C
  db 0x00, 0x00                                ; 0776E
  db 0x00, 0x00                                ; 07770
  db 0x00, 0x00                                ; 07772
  db 0x00, 0x00                                ; 07774
  db 0x00, 0x00                                ; 07776
  db 0x00, 0x00                                ; 07778
  db 0x00, 0x00                                ; 0777A
  db 0x00, 0x00                                ; 0777C
  db 0x00, 0x00                                ; 0777E
  db 0x00, 0x00                                ; 07780
  db 0x00, 0x00                                ; 07782
  db 0x00, 0x00                                ; 07784
  db 0x00, 0x00                                ; 07786
  db 0x00, 0x00                                ; 07788
  db 0x00, 0x00                                ; 0778A
  db 0x00, 0x00                                ; 0778C
  db 0x00, 0x00                                ; 0778E
  db 0x00, 0x00                                ; 07790
  db 0x00, 0x00                                ; 07792
  db 0x00, 0x00                                ; 07794
  db 0x00, 0x00                                ; 07796
  db 0x00, 0x00                                ; 07798
  db 0x00, 0x00                                ; 0779A
  db 0x00, 0x00                                ; 0779C
  db 0x00, 0x00                                ; 0779E
