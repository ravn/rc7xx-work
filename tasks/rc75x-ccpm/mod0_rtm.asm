; =============================================================================
; ccpm.sys — Modul 0: Supervisor & Real-Time Monitor (SUP+RTM)
; Offset range: 0x00000 - 0x01640
; =============================================================================

%include "license.inc"   ; LICENSE_NO + SERIAL til copyright-strenge


  db 0x01, 0xB2, 0x06, 0x48, 0x00, 0xB2, 0x06, 0x00, 0x00, 0x02, 0x33, 0x0C, 0xFA, 0x06, 0x33, 0x0C ; 00000  ...H......3...3.
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 ; 00010  ................
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 ; 00020  ................
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 ; 00030  ................
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 ; 00040  ............

loc_0004C:  ; 0004C
  db 0x00, 0x00                               ; 0004C
  db 0x00, 0x00                               ; 0004E
  db 0x00, 0x00                               ; 00050
  db 0x00, 0x00                               ; 00052
  db 0x00, 0x00                               ; 00054
  db 0x00, 0x00                               ; 00056
  db 0x00, 0x00                               ; 00058
  db 0x00, 0x00                               ; 0005A
  db 0x00, 0x00                               ; 0005C

loc_0005E:  ; 0005E
  db 0x00, 0x00                               ; 0005E
  db 0x00, 0x00                               ; 00060
  db 0x00, 0x00                               ; 00062
  db 0x00, 0x00                               ; 00064
  db 0x00, 0x00                               ; 00066
  db 0x00, 0x00                               ; 00068
  db 0x00, 0x00                               ; 0006A

loc_0006C:  ; 0006C
  db 0x00, 0x00                               ; 0006C
  db 0x00, 0x00                               ; 0006E
  db 0x00, 0x00                               ; 00070
  db 0x00, 0x00                               ; 00072
  db 0x00, 0x00                               ; 00074
  db 0x00, 0x00                               ; 00076
  db 0x00, 0x00                               ; 00078
  db 0x00, 0x00                               ; 0007A
  db 0x00, 0x00                               ; 0007C
  db 0x00, 0x00                               ; 0007E
  jmp near mod0_rtm_init                       ; 00080  0xE9, 0x7B, 0x00

loc_00083:  ; 00083
  jmp near mod0_rtm_entry                      ; 00083  0xE9, 0x74, 0x02
  cli                                          ; 00086
  push es                                      ; 00087
  dw 0x0003                                    ; 00088  MEMIF version
  dw 0x0048                                    ; 0008A  Segment
  db 0x06                                      ; 0008C
  db "COPYRIGHT (C) 1982,1983,1984 DIGITAL RESEARCH ", LICENSE_NO, SERIAL, " Modifyed by Flemming Kraglund Rc-Computer Denmark " ; 0008D

mod0_rtm_init:  ; 000FE
  cli                                          ; 000FE  0xFA
  cld                                          ; 000FF  0xFC
  mov ax, ds                                   ; 00100  0x8C, 0xD8
  mov ss, ax                                   ; 00102  0x8E, 0xD0
  mov sp, 0x5e0                                ; 00104  0xBC, 0xE0, 0x05
  mov bx, 0x4a1                                ; 00107  0xBB, 0xA1, 0x04
  mov ax, 0x4e0                                ; 0010A  0xB8, 0xE0, 0x04
  mov cl, 4                                    ; 0010D  0xB1, 0x04
  shr ax, cl                                   ; 0010F  0xD3, 0xE8
  add ax, [cs:6]                               ; 00111  0x2E, 0x03, 0x06, 0x06, 0x00
  mov [bx + 0x10], ax                          ; 00116  0x89, 0x47, 0x10
  mov es, ax                                   ; 00119  0x8E, 0xC0
  mov [es:0x2e], ds                            ; 0011B  0x26, 0x8C, 0x1E, 0x2E, 0x00
  push ds                                      ; 00120  0x1E
  xor_ax_ax                                    ; 00121  xor ax, ax
  mov ds, ax                                   ; 00123  0x8E, 0xD8
  mov word [0x380], 0x134                      ; 00125  0xC7, 0x06, 0x80, 0x03, 0x34, 0x01
  mov [0x382], cs                              ; 0012B  0x8C, 0x0E, 0x82, 0x03
  pop ds                                       ; 0012F  0x1F
  mov ax, 0xffff                               ; 00130  0xB8, 0xFF, 0xFF
  mov [0x8c], ax                               ; 00133  0xA3, 0x8C, 0x00
  mov bx, 4                                    ; 00136  0xBB, 0x04, 0x00
  push bx                                      ; 00139  0x53
  call far [bx + 8]                            ; 0013A  0xFF, 0x5F, 0x08
  pop bx                                       ; 0013D  0x5B
  push bx                                      ; 0013E  0x53
  call far [bx + 0x10]                         ; 0013F  0xFF, 0x5F, 0x10
  pop bx                                       ; 00142  0x5B
  test byte [0x46], 8                          ; 00143  0xF6, 0x06, 0x46, 0x00, 0x08
  je loc_0014F                                 ; 00148  0x74, 0x05
  push bx                                      ; 0014A  0x53
  call far [bx + 0x20]                         ; 0014B  0xFF, 0x5F, 0x20
  pop bx                                       ; 0014E  0x5B

loc_0014F:  ; 0014F
  test byte [0x46], 0x10                       ; 0014F  0xF6, 0x06, 0x46, 0x00, 0x10
  je loc_0015B                                 ; 00154  0x74, 0x05
  push bx                                      ; 00156  0x53
  call far [bx + 0x18]                         ; 00157  0xFF, 0x5F, 0x18
  pop bx                                       ; 0015A  0x5B

loc_0015B:  ; 0015B
  test byte [0x46], 0x20                       ; 0015B  0xF6, 0x06, 0x46, 0x00, 0x20
  je loc_00169                                 ; 00160  0x74, 0x07
  push ds                                      ; 00162  0x1E
  push es                                      ; 00163  0x06
  call far [bx + 0x28]                         ; 00164  0xFF, 0x5F, 0x28
  pop es                                       ; 00167  0x07
  pop ds                                       ; 00168  0x1F

loc_00169:  ; 00169
  mov ax, ds                                   ; 00169  0x8C, 0xD8
  sub_bx_bx                                    ; 0016B  sub bx, bx
  mov ds, bx                                   ; 0016D  0x8E, 0xDB
  mov word [0x380], 0x134                      ; 0016F  0xC7, 0x06, 0x80, 0x03, 0x34, 0x01
  mov [0x382], cs                              ; 00175  0x8C, 0x0E, 0x82, 0x03
  mov ds, ax                                   ; 00179  0x8E, 0xD8
  mov cl, 0x92                                 ; 0017B  0xB1, 0x92
  int 0xe0                                     ; 0017D  0xCD, 0xE0
  mov cl, 0x9e                                 ; 0017F  0xB1, 0x9E
  int 0xe0                                     ; 00181  0xCD, 0xE0

loc_00183:  ; 00183
  mov ds, [cs:6]                               ; 00183  0x2E, 0x8E, 0x1E, 0x06, 0x00
  mov cx, [0x42]                               ; 00188  0x8B, 0x0E, 0x42, 0x00
  jcxz loc_001AE                               ; 0018C  0xE3, 0x20
  mov es, cx                                   ; 0018E  0x8E, 0xC1
  mov ax, [es:0]                               ; 00190  0x26, 0xA1, 0x00, 0x00
  mov [0x42], ax                               ; 00194  0xA3, 0x42, 0x00
  mov [es:0], ds                               ; 00197  0x26, 0x8C, 0x1E, 0x00, 0x00
  mov si, 0x10                                 ; 0019C  0xBE, 0x10, 0x00
  mov ds, cx                                   ; 0019F  0x8E, 0xD9
  mov word [si + 0x16], 0                      ; 001A1  0xC7, 0x44, 0x16, 0x00, 0x00
  mov cl, 0x90                                 ; 001A6  0xB1, 0x90
  mov_dx_si                                    ; 001A8  mov dx, si
  int 0xe0                                     ; 001AA  0xCD, 0xE0
  jmp short loc_00183                          ; 001AC  0xEB, 0xD5

loc_001AE:  ; 001AE
  mov cl, 0x8f                                 ; 001AE  0xB1, 0x8F
  mov dl, 0xff                                 ; 001B0  0xB2, 0xFF
  int 0xe0                                     ; 001B2  0xCD, 0xE0
  cld                                          ; 001B4  0xFC
  mov ax, ds                                   ; 001B5  0x8C, 0xD8
  mov ds, [cs:6]                               ; 001B7  0x2E, 0x8E, 0x1E, 0x06, 0x00
  mov bx, [0x68]                               ; 001BC  0x8B, 0x1E, 0x68, 0x00
  mov ds, [bx + 0x10]                          ; 001C0  0x8E, 0x5F, 0x10
  mov [0x30], es                               ; 001C3  0x8C, 0x06, 0x30, 0x00
  cmp byte [0x60], 0                           ; 001C7  0x80, 0x3E, 0x60, 0x00, 0x00
  jne loc_001E2                                ; 001CC  0x75, 0x14
  mov [0x002e], ax                             ; 001CE  0xA3, 0x2E, 0x00
  mov [0x36], ss                               ; 001D1  0x8C, 0x16, 0x36, 0x00
  mov [0x34], sp                               ; 001D5  0x89, 0x26, 0x34, 0x00
  mov ax, ds                                   ; 001D9  0x8C, 0xD8
  mov ss, ax                                   ; 001DB  0x8E, 0xD0
  mov sp, 0x100                                ; 001DD  0xBC, 0x00, 0x01
  jmp short loc_001E9                          ; 001E0  0xEB, 0x07

loc_001E2:  ; 001E2
  push word [0x002e]                           ; 001E2  0xFF, 0x36, 0x2E, 0x00
  mov [0x002e], ax                             ; 001E6  0xA3, 0x2E, 0x00

loc_001E9:  ; 001E9
  sti                                          ; 001E9  0xFB
  inc byte [0x60]                              ; 001EA  0xFE, 0x06, 0x60, 0x00
  mov ax, ds                                   ; 001EE  0x8C, 0xD8
  mov es, ax                                   ; 001F0  0x8E, 0xC0
  mov ds, [cs:6]                               ; 001F2  0x2E, 0x8E, 0x1E, 0x06, 0x00
  push si                                      ; 001F7  0x56
  push di                                      ; 001F8  0x57
  push bp                                      ; 001F9  0x55
  mov [es:6], cl                               ; 001FA  0x26, 0x88, 0x0E, 0x06, 0x00
  xor_ch_ch                                    ; 001FF  xor ch, ch
  call rtm_func_check                               ; 00201  0xE8, 0x89, 0x00
  pop bp                                       ; 00204  0x5D
  pop di                                       ; 00205  0x5F
  pop si                                       ; 00206  0x5E
  mov ax, es                                   ; 00207  0x8C, 0xC0
  mov ds, ax                                   ; 00209  0x8E, 0xD8
  mov es, [0x30]                               ; 0020B  0x8E, 0x06, 0x30, 0x00
  mov ax, [0x002e]                             ; 0020F  0xA1, 0x2E, 0x00
  cli                                          ; 00212  0xFA
  dec byte [0x60]                              ; 00213  0xFE, 0x0E, 0x60, 0x00
  jne loc_00272                                ; 00217  0x75, 0x59
  push bx                                      ; 00219  0x53
  push ds                                      ; 0021A  0x1E
  push cx                                      ; 0021B  0x51
  mov ds, [cs:6]                               ; 0021C  0x2E, 0x8E, 0x1E, 0x06, 0x00
  mov bx, [0x68]                               ; 00221  0x8B, 0x1E, 0x68, 0x00
  mov ax, [bx + 0x26]                          ; 00225  0x8B, 0x47, 0x26
  test ax, 1                                   ; 00228  0xA9, 0x01, 0x00
  je loc_0025E                                 ; 0022B  0x74, 0x31
  mov es, [bx + 0x10]                          ; 0022D  0x8E, 0x47, 0x10
  mov al, [bx + 0x20]                          ; 00230  0x8A, 0x47, 0x20
  xor_ah_ah                                    ; 00233  xor ah, ah
  xor_bh_bh                                    ; 00235  xor bh, bh
  mov bx, 0x2c                                 ; 00237  0xBB, 0x2C, 0x00
  mul_bx                                       ; 0023A  mul bx
  mov bx, [0x54]                               ; 0023C  0x8B, 0x1E, 0x54, 0x00
  add_bx_ax                                    ; 00240  add bx, ax
  mov ax, [bx + 0xe]                           ; 00242  0x8B, 0x47, 0x0E
  test ax, 0x10                                ; 00245  0xA9, 0x10, 0x00
  je loc_0025E                                 ; 00248  0x74, 0x14
  push dx                                      ; 0024A  0x52
  mov dx, 0xa8                                 ; 0024B  0xBA, 0xA8, 0x00
  mov [es:0], dx                               ; 0024E  0x26, 0x89, 0x16, 0x00, 0x00
  mov cx, 0x212                                ; 00253  0xB9, 0x12, 0x02
  xor_bh_bh                                    ; 00256  xor bh, bh
  mov bl, 9                                    ; 00258  0xB3, 0x09
  call rtm_dispatcher                          ; 0025A  0xE8, 0xB6, 0x00
  pop dx                                       ; 0025D  0x5A

loc_0025E:  ; 0025E
  pop cx                                       ; 0025E  0x59
  pop ds                                       ; 0025F  0x1F
  pop bx                                       ; 00260  0x5B
  mov ax, [0x002e]                             ; 00261  0xA1, 0x2E, 0x00
  mov es, [0x30]                               ; 00264  0x8E, 0x06, 0x30, 0x00
  mov ss, [0x36]                               ; 00268  0x8E, 0x16, 0x36, 0x00
  mov sp, [0x34]                               ; 0026C  0x8B, 0x26, 0x34, 0x00
  jmp short loc_00277                          ; 00270  0xEB, 0x05

loc_00272:  ; 00272
  sti                                          ; 00272  0xFB
  pop word [0x002e]                            ; 00273  0x8F, 0x06, 0x2E, 0x00

loc_00277:  ; 00277
  mov ds, ax                                   ; 00277  0x8E, 0xD8
  mov_ax_bx                                    ; 00279  mov ax, bx
  inc ax                                       ; 0027B  0x40
  je loc_00280                                 ; 0027C  0x74, 0x02
  xor_cx_cx                                   ; 0027E  xor cx, cx

loc_00280:  ; 00280
  dec ax                                       ; 00280  0x48
  iret                                         ; 00281  0xCF

rtm_core:  ; 00282
  test ch, ch                                  ; 00282  0x84, 0xED
  je rtm_func_check                                 ; 00284  0x74, 0x07
  mov_ax_cx                                    ; 00286  mov ax, cx
  jmp short loc_002CD                          ; 00288  0xEB, 0x43

loc_0028A:  ; 0028A
  jmp near loc_00376                           ; 0028A  0xE9, 0xE9, 0x00

rtm_func_check:  ; 0028D
  mov_ax_cx                                    ; 0028D  mov ax, cx
  cmp al, 0x50                                 ; 0028F  0x3C, 0x50
  jbe loc_002A7                                ; 00291  0x76, 0x14
  sub al, 0x11                                 ; 00293  0x2C, 0x11
  cmp al, 0x51                                 ; 00295  0x3C, 0x51
  jb loc_0028A                                 ; 00297  0x72, 0xF1
  cmp al, 0x63                                 ; 00299  0x3C, 0x63
  jbe loc_002A7                                ; 0029B  0x76, 0x0A
  sub al, 0xb                                  ; 0029D  0x2C, 0x0B
  cmp al, 0x64                                 ; 0029F  0x3C, 0x64
  jb loc_0028A                                 ; 002A1  0x72, 0xE7
  cmp al, 0x88                                 ; 002A3  0x3C, 0x88
  ja loc_0028A                                 ; 002A5  0x77, 0xE3

loc_002A7:  ; 002A7
  shl ax, 1                                    ; 002A7  0xD1, 0xE0
  mov_si_ax                                    ; 002A9  mov si, ax
  mov ax, [si + 0xaa]                          ; 002AB  0x8B, 0x84, 0xAA, 0x00
  test ah, 0x80                                ; 002AF  0xF6, 0xC4, 0x80
  je loc_002CD                                 ; 002B2  0x74, 0x19
  and ah, 0x7f                                 ; 002B4  0x80, 0xE4, 0x7F
  mov bl, [0x46]                               ; 002B7  0x8A, 0x1E, 0x46, 0x00
  test bl, 0x40                                ; 002BB  0xF6, 0xC3, 0x40
  je loc_002CD                                 ; 002BE  0x74, 0x0D
  push ax                                      ; 002C0  0x50
  call far [0x30]                              ; 002C1  0xFF, 0x1E, 0x30, 0x00
  cmp al, 0xff                                 ; 002C5  0x3C, 0xFF
  pop ax                                       ; 002C7  0x58
  je loc_002CD                                 ; 002C8  0x74, 0x03
  mov_ax_bx                                    ; 002CA  mov ax, bx
  ret                                          ; 002CC  0xC3

loc_002CD:  ; 002CD
  cmp ah, 1                                    ; 002CD  0x80, 0xFC, 0x01
  je loc_002EF                                 ; 002D0  0x74, 0x1D
  mov_cl_ah                                    ; 002D2  mov cl, ah
  mov ch, [0x46]                               ; 002D4  0x8A, 0x2E, 0x46, 0x00
  shr ch, cl                                   ; 002D8  0xD2, 0xED
  jae loc_002EC                                ; 002DA  0x73, 0x10
  xor_ch_ch                                    ; 002DC  xor ch, ch
  dec cx                                       ; 002DE  0x49
  shl cx, 1                                    ; 002DF  0xD1, 0xE1
  shl cx, 1                                    ; 002E1  0xD1, 0xE1
  shl cx, 1                                    ; 002E3  0xD1, 0xE1
  mov_si_cx                                    ; 002E5  mov si, cx
  mov_cl_al                                    ; 002E7  mov cl, al
  call far [si]                                ; 002E9  0xFF, 0x1C
  ret                                          ; 002EB  0xC3

loc_002EC:  ; 002EC
  jmp near loc_0036F                           ; 002EC  0xE9, 0x80, 0x00

loc_002EF:  ; 002EF
  xor_ah_ah                                    ; 002EF  xor ah, ah
  shl ax, 1                                    ; 002F1  0xD1, 0xE0
  mov_si_ax                                    ; 002F3  mov si, ax
  jmp [cs:si + 0x2d1]                          ; 002F5  0x2E, 0xFF, 0xA4, 0xD1, 0x02

mod0_rtm_entry:  ; 002FA
  cmp cx, 0x85                                 ; 002FA  0x81, 0xF9, 0x85, 0x00
  jne loc_0030F                                ; 002FE  0x75, 0x0F
  mov cx, 0x203                                ; 00300  0xB9, 0x03, 0x02
  call rtm_core                                ; 00303  0xE8, 0x7C, 0xFF
  mov_ax_bx                                    ; 00306  mov ax, bx
  inc ax                                       ; 00308  0x40
  je loc_0030D                                 ; 00309  0x74, 0x02
  xor_cx_cx                                   ; 0030B  xor cx, cx

loc_0030D:  ; 0030D
  dec ax                                       ; 0030D  0x48
  retf                                         ; 0030E  0xCB

loc_0030F:  ; 0030F
  call rtm_dispatcher                          ; 0030F  0xE8, 0x01, 0x00
  retf                                         ; 00312  0xCB

rtm_dispatcher:  ; 00313
  push word [es:0x2e]                          ; 00313  0x26, 0xFF, 0x36, 0x2E, 0x00
  mov ax, ds                                   ; 00318  0x8C, 0xD8
  mov [es:0x2e], ax                            ; 0031A  0x26, 0xA3, 0x2E, 0x00
  mov ax, [cs:6]                               ; 0031E  0x2E, 0xA1, 0x06, 0x00
  mov ds, ax                                   ; 00322  0x8E, 0xD8
  call rtm_core                                ; 00324  0xE8, 0x5B, 0xFF
  mov ax, [es:0x2e]                            ; 00327  0x26, 0xA1, 0x2E, 0x00
  mov ds, ax                                   ; 0032B  0x8E, 0xD8
  pop word [es:0x2e]                           ; 0032D  0x26, 0x8F, 0x06, 0x2E, 0x00
  mov_ax_bx                                    ; 00332  mov ax, bx
  inc ax                                       ; 00334  0x40
  je loc_00339                                 ; 00335  0x74, 0x02
  xor_cx_cx                                   ; 00337  xor cx, cx

loc_00339:  ; 00339
  dec ax                                       ; 00339  0x48
  ret                                          ; 0033A  0xC3
  mov bx, [0x68]                               ; 0033B  0x8B, 0x1E, 0x68, 0x00
  and word [bx + 6], 0xfd7c                    ; 0033F  0x81, 0x67, 0x06, 0x7C, 0xFD
  mov cx, 0x8f                                 ; 00344  0xB9, 0x8F, 0x00
  xor_dx_dx                                    ; 00347  xor dx, dx
  int 0xe0                                     ; 00349  0xCD, 0xE0

loc_0034B:  ; 0034B
  call far [0x28]                              ; 0034B  0xFF, 0x1E, 0x28, 0x00
  ret                                          ; 0034F  0xC3
  db 0x00                                                         ; 00350  .
  out dx, ax                                   ; 00351  0xEF
  add_dh_dh                                    ; 00352  add dh, dh
  add_bh_ch                                    ; 00354  add bh, ch
  add cl, [bp + di]                            ; 00356  0x02, 0x0B
  add_cx_si                                    ; 00358  add cx, si
  or_al_dh                                     ; 0035A  or al, dh
  add_dx_bx                                    ; 0035C  add dx, bx
  adc al, 0x69                                 ; 0035E  0x14, 0x69
  adc cx, [bx + si - 0x6dfd]                   ; 00360  0x13, 0x88, 0x03, 0x92
  add_dx_ax                                    ; 00364  add dx, ax
  or al, [si]                                  ; 00366  0x0A, 0x04
  add_ax_sp                                    ; 00368  add ax, sp
  add bp, [bx + si - 0x37fd]                   ; 0036A  0x03, 0xA8, 0x03, 0xC8
  db 0x0A                                                         ; 0036E  .

loc_0036F:  ; 0036F
  mov cx, 1                                    ; 0036F  0xB9, 0x01, 0x00
  mov bx, 0xffff                               ; 00372  0xBB, 0xFF, 0xFF
  ret                                          ; 00375  0xC3

loc_00376:  ; 00376
  mov cx, 2                                    ; 00376  0xB9, 0x02, 0x00
  mov bx, 0xffff                               ; 00379  0xBB, 0xFF, 0xFF
  ret                                          ; 0037C  0xC3
  mov bx, [0x7a]                               ; 0037D  0x8B, 0x1E, 0x7A, 0x00
  xor_cx_cx                                   ; 00381  xor cx, cx
  ret                                          ; 00383  0xC3
  mov bx, [0x7c]                               ; 00384  0x8B, 0x1E, 0x7C, 0x00
  xor_cx_cx                                   ; 00388  xor cx, cx
  ret                                          ; 0038A  0xC3
  mov_si_dx                                    ; 0038B  mov si, dx
  mov bp, ds                                   ; 0038D  0x8C, 0xDD
  mov ds, [es:0x2e]                            ; 0038F  0x26, 0x8E, 0x1E, 0x2E, 0x00
  mov al, [si]                                 ; 00394  0x8A, 0x04
  mov cx, [si + 1]                             ; 00396  0x8B, 0x4C, 0x01
  mov dx, [si + 3]                             ; 00399  0x8B, 0x54, 0x03
  mov ds, bp                                   ; 0039C  0x8E, 0xDD
  cmp al, 2                                    ; 0039E  0x3C, 0x02
  jne loc_003B0                                ; 003A0  0x75, 0x0E
  mov cx, 0x418                                ; 003A2  0xB9, 0x18, 0x04
  call rtm_dispatcher                          ; 003A5  0xE8, 0x6B, 0xFF
  test bl, bl                                  ; 003A8  0x84, 0xDB
  je loc_003AF                                 ; 003AA  0x74, 0x03
  mov bx, 0xff                                 ; 003AC  0xBB, 0xFF, 0x00

loc_003AF:  ; 003AF
  ret                                          ; 003AF  0xC3

loc_003B0:  ; 003B0
  cmp al, 4                                    ; 003B0  0x3C, 0x04
  jne loc_003BC                                ; 003B2  0x75, 0x08
  mov_dl_cl                                    ; 003B4  mov dl, cl
  mov cx, 0x403                                ; 003B6  0xB9, 0x03, 0x04
  jmp near rtm_dispatcher                      ; 003B9  0xE9, 0x57, 0xFF

loc_003BC:  ; 003BC
  cmp al, 1                                    ; 003BC  0x3C, 0x01
  ja loc_003C9                                 ; 003BE  0x77, 0x09
  mov cx, 0x8f                                 ; 003C0  0xB9, 0x8F, 0x00
  mov dx, 0                                    ; 003C3  0xBA, 0x00, 0x00
  jmp near rtm_dispatcher                      ; 003C6  0xE9, 0x4A, 0xFF

loc_003C9:  ; 003C9
  cmp al, 7                                    ; 003C9  0x3C, 0x07
  jbe loc_003D8                                ; 003CB  0x76, 0x0B
  cmp al, 0xf                                  ; 003CD  0x3C, 0x0F
  je loc_003D8                                 ; 003CF  0x74, 0x07
  mov bx, 0xffff                               ; 003D1  0xBB, 0xFF, 0xFF
  mov cx, 2                                    ; 003D4  0xB9, 0x02, 0x00
  ret                                          ; 003D7  0xC3

loc_003D8:  ; 003D8
  cmp al, 3                                    ; 003D8  0x3C, 0x03
  jne loc_003E2                                ; 003DA  0x75, 0x06
  mov cx, 0x402                                ; 003DC  0xB9, 0x02, 0x04
  jmp near rtm_dispatcher                      ; 003DF  0xE9, 0x31, 0xFF

loc_003E2:  ; 003E2
  cmp al, 5                                    ; 003E2  0x3C, 0x05
  jne loc_003EE                                ; 003E4  0x75, 0x08
  mov_dl_cl                                    ; 003E6  mov dl, cl
  mov cx, 5                                    ; 003E8  0xB9, 0x05, 0x00
  jmp near rtm_dispatcher                      ; 003EB  0xE9, 0x25, 0xFF

loc_003EE:  ; 003EE
  cmp al, 6                                    ; 003EE  0x3C, 0x06
  jne loc_003F8                                ; 003F0  0x75, 0x06
  mov ax, 6                                    ; 003F2  0xB8, 0x06, 0x00
  jmp near loc_0034B                           ; 003F5  0xE9, 0x53, 0xFF

loc_003F8:  ; 003F8
  cmp al, 7                                    ; 003F8  0x3C, 0x07
  jne loc_00402                                ; 003FA  0x75, 0x06
  mov ax, 5                                    ; 003FC  0xB8, 0x05, 0x00
  jmp near loc_0034B                           ; 003FF  0xE9, 0x49, 0xFF

loc_00402:  ; 00402
  mov ax, 3                                    ; 00402  0xB8, 0x03, 0x00
  jmp near loc_0034B                           ; 00405  0xE9, 0x43, 0xFF
  mov [es:0x30], ds                            ; 00408  0x26, 0x8C, 0x1E, 0x30, 0x00
  xor_bx_bx                                    ; 0040D  xor bx, bx
  mov_cx_bx                                    ; 0040F  mov cx, bx
  ret                                          ; 00411  0xC3
  push es                                      ; 00412  0x06
  mov es, [es:0x2e]                            ; 00413  0x26, 0x8E, 0x06, 0x2E, 0x00
  mov_di_dx                                    ; 00418  mov di, dx
  mov si, 0x7e                                 ; 0041A  0xBE, 0x7E, 0x00
  mov cx, 5                                    ; 0041D  0xB9, 0x05, 0x00
  rep movsb                                    ; 00420  0xF3, 0xA4
  pop es                                       ; 00422  0x07
  xor_cx_cx                                   ; 00423  xor cx, cx
  mov_bx_cx                                    ; 00425  mov bx, cx
  ret                                          ; 00427  0xC3
  push es                                      ; 00428  0x06
  mov es, [es:0x2e]                            ; 00429  0x26, 0x8E, 0x06, 0x2E, 0x00
  mov_di_dx                                    ; 0042E  mov di, dx
  mov si, 0x45                                 ; 00430  0xBE, 0x45, 0x00
  push ds                                      ; 00433  0x1E
  mov ax, cs                                   ; 00434  0x8C, 0xC8
  mov ds, ax                                   ; 00436  0x8E, 0xD8
  mov cx, 3                                    ; 00438  0xB9, 0x03, 0x00
  rep movsw                                    ; 0043B  0xF3, 0xA5
  pop ds                                       ; 0043D  0x1F
  pop es                                       ; 0043E  0x07
  xor_cx_cx                                   ; 0043F  xor cx, cx
  mov_bx_cx                                    ; 00441  mov bx, cx
  ret                                          ; 00443  0xC3
  xor_dx_dx                                    ; 00444  xor dx, dx
  mov bx, [0x68]                               ; 00446  0x8B, 0x1E, 0x68, 0x00
  mov ax, [bx + 6]                             ; 0044A  0x8B, 0x47, 0x06
  push ax                                      ; 0044D  0x50
  or ax, 0x1000                                ; 0044E  0x0D, 0x00, 0x10
  mov [bx + 6], ax                             ; 00451  0x89, 0x47, 0x06
  mov cx, 0x217                                ; 00454  0xB9, 0x17, 0x02
  call rtm_dispatcher                          ; 00457  0xE8, 0xB9, 0xFE
  push dx                                      ; 0045A  0x52
  call cli_sync                               ; 0045B  0xE8, 0xB9, 0x06
  pop dx                                       ; 0045E  0x5A
  pop word [0x34b]                             ; 0045F  0x8F, 0x06, 0x4B, 0x03
  mov byte [0x34d], 0                          ; 00463  0xC6, 0x06, 0x4D, 0x03, 0x00
  cmp dx, 0                                    ; 00468  0x83, 0xFA, 0x00
  jne loc_00477                                ; 0046B  0x75, 0x0A
  mov byte [0x34d], 0xff                       ; 0046D  0xC6, 0x06, 0x4D, 0x03, 0xFF
  mov byte [0x34e], 0                          ; 00472  0xC6, 0x06, 0x4E, 0x03, 0x00

loc_00477:  ; 00477
  mov byte [0x4a0], 0                          ; 00477  0xC6, 0x06, 0xA0, 0x04, 0x00
  cmp byte [0x4f], 0xff                        ; 0047C  0x80, 0x3E, 0x4F, 0x00, 0xFF
  jne loc_0049A                                ; 00481  0x75, 0x17
  push dx                                      ; 00483  0x52
  mov cx, 0xa2                                 ; 00484  0xB9, 0xA2, 0x00
  call rtm_dispatcher                          ; 00487  0xE8, 0x89, 0xFE
  pop dx                                       ; 0048A  0x5A
  cmp cx, 0                                    ; 0048B  0x83, 0xF9, 0x00
  jne loc_0049A                                ; 0048E  0x75, 0x0A
  mov byte [0x4a0], 0xff                       ; 00490  0xC6, 0x06, 0xA0, 0x04, 0xFF
  push dx                                      ; 00495  0x52
  call cli_prtime                               ; 00496  0xE8, 0x74, 0x05
  pop dx                                       ; 00499  0x5A

loc_0049A:  ; 0049A
  mov bx, [0x68]                               ; 0049A  0x8B, 0x1E, 0x68, 0x00
  mov [0x3d0], bx                              ; 0049E  0x89, 0x1E, 0xD0, 0x03
  mov cl, [bx + 0x12]                          ; 004A2  0x8A, 0x4F, 0x12
  mov [0x49e], cl                              ; 004A5  0x88, 0x0E, 0x9E, 0x04
  mov cl, [bx + 0x13]                          ; 004A9  0x8A, 0x4F, 0x13
  mov [0x49d], cl                              ; 004AC  0x88, 0x0E, 0x9D, 0x04
  mov cl, [bx + 0x20]                          ; 004B0  0x8A, 0x4F, 0x20
  mov [0x49c], cl                              ; 004B3  0x88, 0x0E, 0x9C, 0x04
  mov cl, [es:0x10]                            ; 004B7  0x26, 0x8A, 0x0E, 0x10, 0x00
  mov [0x49f], cl                              ; 004BC  0x88, 0x0E, 0x9F, 0x04
  mov cx, [es:2]                               ; 004C0  0x26, 0x8B, 0x0E, 0x02, 0x00
  mov [0x347], cx                              ; 004C5  0x89, 0x0E, 0x47, 0x03
  mov cx, [es:4]                               ; 004C9  0x26, 0x8B, 0x0E, 0x04, 0x00
  mov [0x349], cx                              ; 004CE  0x89, 0x0E, 0x49, 0x03
  mov word [0x497], 0                          ; 004D2  0xC7, 0x06, 0x97, 0x04, 0x00, 0x00
  cmp byte [0x34d], 0xff                       ; 004D8  0x80, 0x3E, 0x4D, 0x03, 0xFF
  jne loc_004FB                                ; 004DD  0x75, 0x1C
  push es                                      ; 004DF  0x06
  push ds                                      ; 004E0  0x1E
  mov es, [cs:6]                               ; 004E1  0x2E, 0x8E, 0x06, 0x06, 0x00
  mov si, [0x347]                              ; 004E6  0x8B, 0x36, 0x47, 0x03
  mov di, 0x3d2                                ; 004EA  0xBF, 0xD2, 0x03
  mov ds, [0x349]                              ; 004ED  0x8E, 0x1E, 0x49, 0x03
  mov cx, 0x40                                 ; 004F1  0xB9, 0x40, 0x00
  rep movsw                                    ; 004F4  0xF3, 0xA5
  pop ds                                       ; 004F6  0x1F
  pop es                                       ; 004F7  0x07
  jmp near loc_00519                           ; 004F8  0xE9, 0x1E, 0x00

loc_004FB:  ; 004FB
  push es                                      ; 004FB  0x06
  push ds                                      ; 004FC  0x1E
  mov ds, [es:0x2e]                            ; 004FD  0x26, 0x8E, 0x1E, 0x2E, 0x00
  pop es                                       ; 00502  0x07
  mov_si_dx                                    ; 00503  mov si, dx
  mov di, 0x3cf                                ; 00505  0xBF, 0xCF, 0x03
  movsb                                        ; 00508  0xA4
  mov_si_dx                                    ; 00509  mov si, dx
  add si, 1                                    ; 0050B  0x83, 0xC6, 0x01
  mov di, 0x3d2                                ; 0050E  0xBF, 0xD2, 0x03
  mov cx, 0x81                                 ; 00511  0xB9, 0x81, 0x00
  rep movsb                                    ; 00514  0xF3, 0xA4
  push es                                      ; 00516  0x06
  pop ds                                       ; 00517  0x1F
  pop es                                       ; 00518  0x07

loc_00519:  ; 00519
  call cli_pfn                               ; 00519  0xE8, 0x09, 0x06
  jcxz loc_00525                               ; 0051C  0xE3, 0x07
  mov [0x497], cx                              ; 0051E  0x89, 0x0E, 0x97, 0x04
  jmp near loc_00932                           ; 00522  0xE9, 0x0D, 0x04

loc_00525:  ; 00525
  call cli_parse_tail                               ; 00525  0xE8, 0xA9, 0x04
  cmp byte [0x454], 0                          ; 00528  0x80, 0x3E, 0x54, 0x04, 0x00
  jne loc_0054C                                ; 0052D  0x75, 0x1D
  mov bx, 0x454                                ; 0052F  0xBB, 0x54, 0x04
  cmp byte [bx + 0x1A], 0                      ; 00532  0x80, 0x7F, 0x1A, 0x00
  jne loc_0054C                                ; 00536  0x75, 0x14
  call io_conin_rtm_helper                     ; 00538  0xE8, 0x1C, 0x00
  jne loc_0054C                                ; 0053B  0x75, 0x0F

loc_0053D:  ; 0053D
  cmp byte [0x34d], 0xff                       ; 0053D  0x80, 0x3E, 0x4D, 0x03, 0xFF
  jne loc_00549                                ; 00542  0x75, 0x05
  mov byte [0x34e], 0xff                       ; 00544  0xC6, 0x06, 0x4E, 0x03, 0xFF

loc_00549:  ; 00549
  jmp near loc_00932                           ; 00549  0xE9, 0xE6, 0x03

loc_0054C:  ; 0054C
  cmp cx, 0xf                                  ; 0054C  0x83, 0xF9, 0x0F
  jne loc_005C2                                ; 0054F  0x75, 0x71
  mov [0x497], cx                              ; 00551  0x89, 0x0E, 0x97, 0x04
  jmp short loc_0053D                          ; 00555  0xEB, 0xE6

io_conin_rtm_helper:  ; 00557
  mov si, 0x455                                ; 00557  0xBE, 0x55, 0x04
  mov di, 0x47d                                ; 0055A  0xBF, 0x7D, 0x04
  mov cx, 4                                    ; 0055D  0xB9, 0x04, 0x00
  push es                                      ; 00560  0x06

loc_00561:  ; 00561
  push ds                                      ; 00561  0x1E
  pop es                                       ; 00562  0x07
  push si                                      ; 00563  0x56
  rep movsw                                    ; 00564  0xF3, 0xA5
  pop si                                       ; 00566  0x5E
  mov cx, 4                                    ; 00567  0xB9, 0x04, 0x00
  mov di, 0x489                                ; 0056A  0xBF, 0x89, 0x04
  rep movsw                                    ; 0056D  0xF3, 0xA5
  pop es                                       ; 0056F  0x07
  mov cx, 0x87                                 ; 00570  0xB9, 0x87, 0x00
  mov dx, 0x475                                ; 00573  0xBA, 0x75, 0x04
  call rtm_dispatcher                          ; 00576  0xE8, 0x9A, 0xFD
  jcxz loc_0057F                               ; 00579  0xE3, 0x04

loc_0057B:  ; 0057B
  cmp cx, 0                                    ; 0057B  0x83, 0xF9, 0x00
  ret                                          ; 0057E  0xC3

loc_0057F:  ; 0057F
  mov bx, 0x475                                ; 0057F  0xBB, 0x75, 0x04
  mov bx, [bx + 2]                             ; 00582  0x8B, 0x5F, 0x02
  test word [bx + 4], 8                        ; 00585  0xF7, 0x47, 0x04, 0x08, 0x00
  jne loc_00591                                ; 0058A  0x75, 0x05
  mov cx, 9                                    ; 0058C  0xB9, 0x09, 0x00
  jmp short loc_0057B                          ; 0058F  0xEB, 0xEA

loc_00591:  ; 00591
  mov cx, 0x8c                                 ; 00591  0xB9, 0x8C, 0x00
  mov dx, 0x475                                ; 00594  0xBA, 0x75, 0x04
  call rtm_dispatcher                          ; 00597  0xE8, 0x79, 0xFD
  jcxz loc_005A1                               ; 0059A  0xE3, 0x05
  mov cx, 0xf                                  ; 0059C  0xB9, 0x0F, 0x00
  jmp short loc_0057B                          ; 0059F  0xEB, 0xDA

loc_005A1:  ; 005A1
  cmp byte [0x4a0], 0xff                       ; 005A1  0x80, 0x3E, 0xA0, 0x04, 0xFF
  jne loc_005AB                                ; 005A6  0x75, 0x03
  call cli_prcusp                               ; 005A8  0xE8, 0xF1, 0x04

loc_005AB:  ; 005AB
  mov bx, 0x485                                ; 005AB  0xBB, 0x85, 0x04
  mov al, [0x49c]                              ; 005AE  0xA0, 0x9C, 0x04
  mov [bx], al                                 ; 005B1  0x88, 0x07
  mov byte [bx + 1], 0                         ; 005B3  0xC6, 0x47, 0x01, 0x00
  mov word [bx + 2], 1                         ; 005B7  0xC7, 0x47, 0x02, 0x01, 0x00
  call cli_conasn                               ; 005BC  0xE8, 0x6E, 0x05
  xor_cx_cx                                   ; 005BF  xor cx, cx
  ret                                          ; 005C1  0xC3

loc_005C2:  ; 005C2
  pushf                                        ; 005C2  0x9C
  cli                                          ; 005C3  0xFA
  mov bx, [0x5c]                               ; 005C4  0x8B, 0x1E, 0x5C, 0x00
  cmp bx, 0                                    ; 005C8  0x83, 0xFB, 0x00
  jne loc_005D7                                ; 005CB  0x75, 0x0A
  popf                                         ; 005CD  0x9D
  mov word [0x497], 0xc                        ; 005CE  0xC7, 0x06, 0x97, 0x04, 0x0C, 0x00
  jmp near loc_00932                           ; 005D4  0xE9, 0x5B, 0x03

loc_005D7:  ; 005D7
  mov si, [bx]                                 ; 005D7  0x8B, 0x37
  mov [0x5c], si                               ; 005D9  0x89, 0x36, 0x5C, 0x00
  popf                                         ; 005DD  0x9D
  mov [0x495], bx                              ; 005DE  0x89, 0x1E, 0x95, 0x04
  push es                                      ; 005E2  0x06
  push ds                                      ; 005E3  0x1E
  pop es                                       ; 005E4  0x07
  mov_di_bx                                    ; 005E5  mov di, bx
  mov cx, 0x18                                 ; 005E7  0xB9, 0x18, 0x00
  xor_ax_ax                                    ; 005EA  xor ax, ax
  rep stosw                                    ; 005EC  0xF3, 0xAB
  pop es                                       ; 005EE  0x07
  mov bx, [0x495]                              ; 005EF  0x8B, 0x1E, 0x95, 0x04
  mov word [bx + 6], 0x10                      ; 005F3  0xC7, 0x47, 0x06, 0x10, 0x00
  mov_di_bx                                    ; 005F8  mov di, bx
  add di, 8                                    ; 005FA  0x83, 0xC7, 0x08
  mov si, 0x454                                ; 005FD  0xBE, 0x54, 0x04
  add si, 1                                    ; 00600  0x83, 0xC6, 0x01
  push es                                      ; 00603  0x06
  mov ax, ds                                   ; 00604  0x8C, 0xD8
  mov es, ax                                   ; 00606  0x8E, 0xC0
  mov cx, 4                                    ; 00608  0xB9, 0x04, 0x00
  rep movsw                                    ; 0060B  0xF3, 0xA5
  pop es                                       ; 0060D  0x07
  mov si, [0x68]                               ; 0060E  0x8B, 0x36, 0x68, 0x00
  mov al, [0x49e]                              ; 00612  0xA0, 0x9E, 0x04
  mov [bx + 0x12], al                          ; 00615  0x88, 0x47, 0x12
  mov al, [0x49d]                              ; 00618  0xA0, 0x9D, 0x04
  mov [bx + 0x13], al                          ; 0061B  0x88, 0x47, 0x13
  mov al, [0x49c]                              ; 0061E  0xA0, 0x9C, 0x04
  mov [bx + 0x20], al                          ; 00621  0x88, 0x47, 0x20
  mov al, [si + 0x24]                          ; 00624  0x8A, 0x44, 0x24
  mov [bx + 0x24], al                          ; 00627  0x88, 0x47, 0x24
  mov si, 0x454                                ; 0062A  0xBE, 0x54, 0x04
  cmp byte [si + 0x1A], 0                      ; 0062D  0x80, 0x7C, 0x1A, 0x00
  je loc_00651                                 ; 00631  0x74, 0x1E
  mov si, 0x464                                ; 00633  0xBE, 0x64, 0x04
  mov di, 0x34f                                ; 00636  0xBF, 0x4F, 0x03
  push es                                      ; 00639  0x06
  mov es, [cs:6]                               ; 0063A  0x2E, 0x8E, 0x06, 0x06, 0x00
  mov cx, 4                                    ; 0063F  0xB9, 0x04, 0x00
  rep movsw                                    ; 00642  0xF3, 0xA5
  pop es                                       ; 00644  0x07
  mov word [es:2], 0x34f                      ; 00645
  mov [es:4], ds                               ; 0064C  0x26, 0x8C, 0x1E, 0x04, 0x00

loc_00651:  ; 00651
  mov si, 0x454                                ; 00651  0xBE, 0x54, 0x04
  mov byte [si + 9], 0x43                      ; 00654  0xC6, 0x44, 0x09, 0x43
  mov byte [si + 0xa], 0x4d                    ; 00658  0xC6, 0x44, 0x0A, 0x4D
  mov byte [si + 0xb], 0x44                    ; 0065C  0xC6, 0x44, 0x0B, 0x44
  call cli_open_wait                               ; 00660  0xE8, 0xA2, 0x04
  cmp bl, 0xff                                 ; 00663  0x80, 0xFB, 0xFF
  jne loc_006BC                                ; 00666  0x75, 0x54
  cmp bh, 0                                    ; 00668  0x80, 0xFF, 0x00
  jne loc_006BE                                ; 0066B  0x75, 0x51
  mov cl, [0x4b]                               ; 0066D  0x8A, 0x0E, 0x4B, 0x00
  cmp cl, [0x49e]                              ; 00671  0x3A, 0x0E, 0x9E, 0x04
  je loc_006BE                                 ; 00675  0x74, 0x47
  cmp byte [0x454], 0                          ; 00677  0x80, 0x3E, 0x54, 0x04, 0x00
  jne loc_006BE                                ; 0067C  0x75, 0x40
  inc cl                                       ; 0067E  0xFE, 0xC1
  mov [0x454], cl                              ; 00680  0x88, 0x0E, 0x54, 0x04
  call cli_open_wait                               ; 00684  0xE8, 0x7E, 0x04
  cmp bl, 0xff                                 ; 00687  0x80, 0xFB, 0xFF
  je loc_006BE                                 ; 0068A  0x74, 0x32
  mov bx, 0x454                                ; 0068C  0xBB, 0x54, 0x04
  test byte [bx + 0xa], 0x80                   ; 0068F  0xF6, 0x47, 0x0A, 0x80
  jne loc_006FC                                ; 00693  0x75, 0x67
  call cli_flopn                               ; 00695  0xE8, 0x46, 0x04
  mov bx, [0x68]                               ; 00698  0x8B, 0x1E, 0x68, 0x00
  cmp byte [bx + 0x13], 0                      ; 0069C  0x80, 0x7F, 0x13, 0x00
  je loc_006F3                                 ; 006A0  0x74, 0x51
  mov byte [bx + 0x13], 0                      ; 006A2  0xC6, 0x47, 0x13, 0x00
  call cli_open_wait                               ; 006A6  0xE8, 0x5C, 0x04
  cmp bl, 0xff                                 ; 006A9  0x80, 0xFB, 0xFF
  je loc_006BE                                 ; 006AC  0x74, 0x10
  mov bx, 0x454                                ; 006AE  0xBB, 0x54, 0x04
  test byte [bx + 0xa], 0x80                   ; 006B1  0xF6, 0x47, 0x0A, 0x80
  jne loc_006FC                                ; 006B5  0x75, 0x45
  call cli_flopn                               ; 006B7  0xE8, 0x24, 0x04
  jmp short loc_006F3                          ; 006BA  0xEB, 0x37

loc_006BC:  ; 006BC
  jmp short loc_006FC                          ; 006BC  0xEB, 0x3E

loc_006BE:  ; 006BE
  cmp bh, 0                                    ; 006BE  0x80, 0xFF, 0x00
  je loc_006F3                                 ; 006C1  0x74, 0x30
  mov cx, 0x17                                 ; 006C3  0xB9, 0x17, 0x00
  cmp bh, 4                                    ; 006C6  0x80, 0xFF, 0x04
  je loc_006ED                                 ; 006C9  0x74, 0x22
  mov cx, 0x26                                 ; 006CB  0xB9, 0x26, 0x00
  cmp bh, 7                                    ; 006CE  0x80, 0xFF, 0x07
  je loc_006ED                                 ; 006D1  0x74, 0x1A
  mov cx, 0x18                                 ; 006D3  0xB9, 0x18, 0x00
  cmp bh, 9                                    ; 006D6  0x80, 0xFF, 0x09
  je loc_006ED                                 ; 006D9  0x74, 0x12
  mov cx, 0x1d                                 ; 006DB  0xB9, 0x1D, 0x00
  cmp bh, 1                                    ; 006DE  0x80, 0xFF, 0x01
  je loc_006ED                                 ; 006E1  0x74, 0x0A
  mov cx, 0x28                                 ; 006E3  0xB9, 0x28, 0x00
  cmp bh, 0xff                                 ; 006E6  0x80, 0xFF, 0xFF
  je loc_006ED                                 ; 006E9  0x74, 0x02
  jmp short loc_006F3                          ; 006EB  0xEB, 0x06

loc_006ED:  ; 006ED
  mov [0x497], cx                              ; 006ED  0x89, 0x0E, 0x97, 0x04
  jmp short loc_006F9                          ; 006F1  0xEB, 0x06

loc_006F3:  ; 006F3
  mov word [0x497], 0x1e                       ; 006F3  0xC7, 0x06, 0x97, 0x04, 0x1E, 0x00

loc_006F9:  ; 006F9
  jmp near loc_00900                           ; 006F9  0xE9, 0x04, 0x02

loc_006FC:  ; 006FC
  mov bx, [0x68]                               ; 006FC  0x8B, 0x1E, 0x68, 0x00
  test word [bx + 6], 0x80                     ; 00700  0xF7, 0x47, 0x06, 0x80, 0x00
  je loc_00710                                 ; 00705  0x74, 0x09
  mov bx, 0xffff                               ; 00707  0xBB, 0xFF, 0xFF
  mov cx, 0x28                                 ; 0070A  0xB9, 0x28, 0x00
  jmp near loc_007BF                           ; 0070D  0xE9, 0xAF, 0x00

loc_00710:  ; 00710
  cmp byte [0x90], 0xff                        ; 00710  0x80, 0x3E, 0x90, 0x00, 0xFF
  jne loc_0074A                                ; 00715  0x75, 0x33
  mov bx, [0x495]                              ; 00717  0x8B, 0x1E, 0x95, 0x04
  mov si, 0x454                                ; 0071B  0xBE, 0x54, 0x04
  mov byte [bx + 0x18], 0                      ; 0071E  0xC6, 0x47, 0x18, 0x00
  test byte [si + 1], 0x80                     ; 00722  0xF6, 0x44, 0x01, 0x80
  je loc_0072C                                 ; 00726  0x74, 0x04
  or byte [bx + 0x18], 0x80                    ; 00728  0x80, 0x4F, 0x18, 0x80

loc_0072C:  ; 0072C
  test byte [si + 2], 0x80                     ; 0072C  0xF6, 0x44, 0x02, 0x80
  je loc_00736                                 ; 00730  0x74, 0x04
  or byte [bx + 0x18], 0x40                    ; 00732  0x80, 0x4F, 0x18, 0x40

loc_00736:  ; 00736
  test byte [si + 3], 0x80                     ; 00736  0xF6, 0x44, 0x03, 0x80
  je loc_00740                                 ; 0073A  0x74, 0x04
  or byte [bx + 0x18], 0x20                    ; 0073C  0x80, 0x4F, 0x18, 0x20

loc_00740:  ; 00740
  test byte [si + 4], 0x80                     ; 00740  0xF6, 0x44, 0x04, 0x80
  je loc_0074A                                 ; 00744  0x74, 0x04
  or byte [bx + 0x18], 0x70                    ; 00746  0x80, 0x4F, 0x18, 0x70

loc_0074A:  ; 0074A
  cmp byte [0x34d], 0xff                       ; 0074A  0x80, 0x3E, 0x4D, 0x03, 0xFF
  jne loc_00789                                ; 0074F  0x75, 0x38
  mov bx, [0x495]                              ; 00751  0x8B, 0x1E, 0x95, 0x04
  mov [bx + 0x10], es                          ; 00755  0x8C, 0x47, 0x10
  mov ax, 0x4e0                                ; 00758  0xB8, 0xE0, 0x04
  mov cl, 4                                    ; 0075B  0xB1, 0x04
  shr ax, cl                                   ; 0075D  0xD3, 0xE8
  add ax, [cs:6]                               ; 0075F  0x2E, 0x03, 0x06, 0x06, 0x00
  mov bx, es                                   ; 00764  0x8C, 0xC3
  mov es, ax                                   ; 00766  0x8E, 0xC0
  mov di, 0                                    ; 00768  0xBF, 0x00, 0x00
  mov ds, bx                                   ; 0076B  0x8E, 0xDB
  mov_si_di                                    ; 0076D  mov si, di
  mov cx, 0x80                                 ; 0076F  0xB9, 0x80, 0x00
  rep movsw                                    ; 00772  0xF3, 0xA5
  pushf                                        ; 00774  0x9C
  cli                                          ; 00775  0xFA
  pop dx                                       ; 00776  0x5A
  mov ax, es                                   ; 00777  0x8C, 0xC0
  mov ds, [cs:6]                               ; 00779  0x2E, 0x8E, 0x1E, 0x06, 0x00
  mov ss, ax                                   ; 0077E  0x8E, 0xD0
  mov bx, [0x68]                               ; 00780  0x8B, 0x1E, 0x68, 0x00
  mov [bx + 0x10], ax                          ; 00784  0x89, 0x47, 0x10
  push dx                                      ; 00787  0x52
  popf                                         ; 00788  0x9D

loc_00789:  ; 00789
  cmp byte [0x4a0], 0xff                       ; 00789  0x80, 0x3E, 0xA0, 0x04, 0xFF
  jne loc_00796                                ; 0078E  0x75, 0x06
  call cli_prfilnam                               ; 00790  0xE8, 0xB1, 0x02
  call cli_crlf                               ; 00793  0xE8, 0x5C, 0x02

loc_00796:  ; 00796
  mov bx, [0x495]                              ; 00796  0x8B, 0x1E, 0x95, 0x04
  mov dx, 0x454                                ; 0079A  0xBA, 0x54, 0x04
  mov cx, 0x10a                                ; 0079D  0xB9, 0x0A, 0x01
  cmp byte [0x34d], 0xff                       ; 007A0  0x80, 0x3E, 0x4D, 0x03, 0xFF
  jne loc_007BC                                ; 007A5  0x75, 0x15
  mov byte [0x34e], 0xff                       ; 007A7  0xC6, 0x06, 0x4E, 0x03, 0xFF
  mov cx, 0x10e                                ; 007AC  0xB9, 0x0E, 0x01
  call rtm_dispatcher                          ; 007AF  0xE8, 0x61, 0xFB
  jcxz loc_007BF                               ; 007B2  0xE3, 0x0B
  mov byte [0x34e], 0                          ; 007B4  0xC6, 0x06, 0x4E, 0x03, 0x00
  jmp near loc_007BF                           ; 007B9  0xE9, 0x03, 0x00

loc_007BC:  ; 007BC
  call rtm_dispatcher                          ; 007BC  0xE8, 0x54, 0xFB

loc_007BF:  ; 007BF
  push bx                                      ; 007BF  0x53
  push cx                                      ; 007C0  0x51
  call cli_flopn                               ; 007C1  0xE8, 0x1A, 0x03
  pop cx                                       ; 007C4  0x59
  pop bx                                       ; 007C5  0x5B
  jcxz loc_007CF                               ; 007C6  0xE3, 0x07
  mov [0x497], cx                              ; 007C8  0x89, 0x0E, 0x97, 0x04
  jmp near loc_00900                           ; 007CC  0xE9, 0x31, 0x01

loc_007CF:  ; 007CF
  mov [0x499], bx                              ; 007CF  0x89, 0x1E, 0x99, 0x04
  push es                                      ; 007D3  0x06
  mov es, [0x499]                              ; 007D4  0x8E, 0x06, 0x99, 0x04
  mov di, 0x81                                 ; 007D8  0xBF, 0x81, 0x00
  mov si, 0x3d2                                ; 007DB  0xBE, 0xD2, 0x03
  mov cx, 0x7f                                 ; 007DE  0xB9, 0x7F, 0x00
  rep movsb                                    ; 007E1  0xF3, 0xA4
  pop es                                       ; 007E3  0x07
  push ds                                      ; 007E4  0x1E
  mov ds, [0x499]                              ; 007E5  0x8E, 0x1E, 0x99, 0x04
  mov cl, 0                                    ; 007E9  0xB1, 0x00
  mov di, 0x81                                 ; 007EB  0xBF, 0x81, 0x00

loc_007EE:  ; 007EE
  cmp byte [di], 0                             ; 007EE  0x80, 0x3D, 0x00
  je loc_00805                                 ; 007F1  0x74, 0x12
  cmp byte [di], 0x61                          ; 007F3  0x80, 0x3D, 0x61
  jb loc_00800                                 ; 007F6  0x72, 0x08
  cmp byte [di], 0x7a                          ; 007F8  0x80, 0x3D, 0x7A
  ja loc_00800                                 ; 007FB  0x77, 0x03
  and byte [di], 0x5f                          ; 007FD  0x80, 0x25, 0x5F

loc_00800:  ; 00800
  inc di                                       ; 00800  0x47
  inc cl                                       ; 00801  0xFE, 0xC1
  jmp short loc_007EE                          ; 00803  0xEB, 0xE9

loc_00805:  ; 00805
  mov [0x80], cl                               ; 00805  0x88, 0x0E, 0x80, 0x00
  pop ds                                       ; 00809  0x1F
  push es                                      ; 0080A  0x06
  mov es, [0x499]                              ; 0080B  0x8E, 0x06, 0x99, 0x04
  mov di, 0x5c                                 ; 0080F  0xBF, 0x5C, 0x00
  xor_ax_ax                                    ; 00812  xor ax, ax
  stosb                                        ; 00814  0xAA
  mov al, 0x20                                 ; 00815  0xB0, 0x20
  mov cx, 0xb                                  ; 00817  0xB9, 0x0B, 0x00
  rep stosb                                    ; 0081A  0xF3, 0xAA
  xor_ax_ax                                    ; 0081C  xor ax, ax
  mov cx, 2                                    ; 0081E  0xB9, 0x02, 0x00
  rep stosw                                    ; 00821  0xF3, 0xAB
  push ds                                      ; 00823  0x1E
  push es                                      ; 00824  0x06
  pop ds                                       ; 00825  0x1F
  mov si, 0x5c                                 ; 00826  0xBE, 0x5C, 0x00
  mov cx, 8                                    ; 00829  0xB9, 0x08, 0x00
  rep movsw                                    ; 0082C  0xF3, 0xA5
  pop ds                                       ; 0082E  0x1F
  pop es                                       ; 0082F  0x07
  cmp byte [0x3d2], 0                          ; 00830  0x80, 0x3E, 0xD2, 0x03, 0x00
  je loc_008A3                                 ; 00835  0x74, 0x6C
  call cli_pfn                               ; 00837  0xE8, 0xEB, 0x02
  cmp bx, -1                                   ; 0083A  0x83, 0xFB, 0xFF
  je loc_008A3                                 ; 0083D  0x74, 0x64
  push es                                      ; 0083F  0x06
  mov es, [0x499]                              ; 00840  0x8E, 0x06, 0x99, 0x04
  mov di, 0x5c                                 ; 00844  0xBF, 0x5C, 0x00
  mov si, 0x454                                ; 00847  0xBE, 0x54, 0x04
  mov ax, [si + 0x18]                          ; 0084A  0x8B, 0x44, 0x18
  sub ax, 0x3d2                                ; 0084D  0x2D, 0xD2, 0x03
  add ax, 0x81                                 ; 00850  0x05, 0x81, 0x00
  mov [es:0x51], ax                            ; 00853  0x26, 0xA3, 0x51, 0x00
  mov al, [si + 0x1A]                          ; 00857  0x8A, 0x44, 0x1A
  mov [es:0x53], al                            ; 0085A  0x26, 0xA2, 0x53, 0x00
  mov cx, 8                                    ; 0085E  0xB9, 0x08, 0x00
  rep movsw                                    ; 00861  0xF3, 0xA5
  pop es                                       ; 00863  0x07
  cmp bx, 0                                    ; 00864  0x83, 0xFB, 0x00
  je loc_008A3                                 ; 00867  0x74, 0x3A
  push word [0x491]                            ; 00869  0xFF, 0x36, 0x91, 0x04
  inc bx                                       ; 0086D  0x43
  mov [0x491], bx                              ; 0086E  0x89, 0x1E, 0x91, 0x04
  call cli_pfn                               ; 00872  0xE8, 0xB0, 0x02
  pop word [0x491]                             ; 00875  0x8F, 0x06, 0x91, 0x04
  cmp bx, -1                                   ; 00879  0x83, 0xFB, 0xFF
  je loc_008A3                                 ; 0087C  0x74, 0x25
  push es                                      ; 0087E  0x06
  db 0x8E, 0x06                                                   ; 0087F  ..

loc_00881:  ; 00881
  db 0x99                                     ; 00881  cdq
  add al, 0xbf                                 ; 00882  0x04, 0xBF
  db 0x6C                                     ; 00884  insb
  add [bp + 0x454], bh                         ; 00885  0x00, 0xBE, 0x54, 0x04
  mov ax, [si + 0x18]                          ; 00889  0x8B, 0x44, 0x18
  sub ax, 0x3d2                                ; 0088C  0x2D, 0xD2, 0x03
  add ax, 0x81                                 ; 0088F  0x05, 0x81, 0x00
  mov [es:0x54], ax                            ; 00892  0x26, 0xA3, 0x54, 0x00
  mov al, [si + 0x1A]                          ; 00896  0x8A, 0x44, 0x1A
  mov [es:0x56], al                            ; 00899  0x26, 0xA2, 0x56, 0x00
  mov cx, 8                                    ; 0089D  0xB9, 0x08, 0x00
  rep movsw                                    ; 008A0  0xF3, 0xA5
  pop es                                       ; 008A2  0x07

loc_008A3:  ; 008A3
  cmp byte [0x34d], 0xff                       ; 008A3  0x80, 0x3E, 0x4D, 0x03, 0xFF
  jne loc_008B3                                ; 008A8  0x75, 0x09
  mov cx, 0x91                                 ; 008AA  0xB9, 0x91, 0x00
  mov dx, 1                                    ; 008AD  0xBA, 0x01, 0x00
  call rtm_dispatcher                          ; 008B0  0xE8, 0x60, 0xFA

loc_008B3:  ; 008B3
  mov si, [0x495]                              ; 008B3  0x8B, 0x36, 0x95, 0x04
  or word [si + 6], 0x2000                     ; 008B7  0x81, 0x4C, 0x06, 0x00, 0x20
  mov_dx_si                                    ; 008BC  mov dx, si
  mov cx, 0x90                                 ; 008BE  0xB9, 0x90, 0x00
  call rtm_dispatcher                          ; 008C1  0xE8, 0x4F, 0xFA
  mov bx, [0x68]                               ; 008C4  0x8B, 0x1E, 0x68, 0x00
  and word [bx + 6], 0xff7f                    ; 008C8  0x81, 0x67, 0x06, 0x7F, 0xFF
  test word [bx + 6], 0x400                    ; 008CD  0xF7, 0x47, 0x06, 0x00, 0x04
  je loc_008E5                                 ; 008D2  0x74, 0x11
  and word [bx + 6], 0xfbff                    ; 008D4  0x81, 0x67, 0x06, 0xFF, 0xFB
  mov bx, [0x495]                              ; 008D9  0x8B, 0x1E, 0x95, 0x04
  or word [bx + 6], 0x400                      ; 008DD  0x81, 0x4F, 0x06, 0x00, 0x04
  jmp near loc_00932                           ; 008E2  0xE9, 0x4D, 0x00

loc_008E5:  ; 008E5
  mov bx, 0x485                                ; 008E5  0xBB, 0x85, 0x04
  mov al, [0x49c]                              ; 008E8  0xA0, 0x9C, 0x04
  mov [bx], al                                 ; 008EB  0x88, 0x07
  mov ax, [0x495]                              ; 008ED  0xA1, 0x95, 0x04
  mov [bx + 2], ax                             ; 008F0  0x89, 0x47, 0x02
  mov byte [bx + 1], 0xff                      ; 008F3  0xC6, 0x47, 0x01, 0xFF
  call cli_conasn                               ; 008F7  0xE8, 0x33, 0x02
  mov [0x497], cx                              ; 008FA  0x89, 0x0E, 0x97, 0x04
  jmp short loc_00932                          ; 008FE  0xEB, 0x32

loc_00900:  ; 00900
  mov si, [0x495]                              ; 00900  0x8B, 0x36, 0x95, 0x04
  cmp word [si + 0x16], 0                      ; 00904  0x83, 0x7C, 0x16, 0x00
  je loc_00925                                 ; 00908  0x74, 0x1B
  push ds                                      ; 0090A  0x1E
  push es                                      ; 0090B  0x06
  push si                                      ; 0090C  0x56
  mov si, [si + 0x16]                          ; 0090D  0x8B, 0x74, 0x16
  push word [si + 2]                           ; 00910  0xFF, 0x74, 0x02
  mov cx, 0x82                                 ; 00913  0xB9, 0x82, 0x00
  mov_dx_sp                                    ; 00916  mov dx, sp
  mov ax, ss                                   ; 00918  0x8C, 0xD0
  mov ds, ax                                   ; 0091A  0x8E, 0xD8
  call rtm_dispatcher                          ; 0091C  0xE8, 0xF4, 0xF9
  pop ax                                       ; 0091F  0x58
  pop si                                       ; 00920  0x5E
  pop es                                       ; 00921  0x07
  pop ds                                       ; 00922  0x1F
  jmp short loc_00900                          ; 00923  0xEB, 0xDB

loc_00925:  ; 00925
  pushf                                        ; 00925  0x9C
  cli                                          ; 00926  0xFA
  mov bx, [0x5c]                               ; 00927  0x8B, 0x1E, 0x5C, 0x00
  mov [si], bx                                 ; 0092B  0x89, 0x1C
  mov [0x5c], si                               ; 0092D  0x89, 0x36, 0x5C, 0x00
  popf                                         ; 00931  0x9D

loc_00932:  ; 00932
  mov bx, [0x68]                               ; 00932  0x8B, 0x1E, 0x68, 0x00
  mov cl, [0x49e]                              ; 00936  0x8A, 0x0E, 0x9E, 0x04
  mov [bx + 0x12], cl                          ; 0093A  0x88, 0x4F, 0x12
  mov cl, [0x49d]                              ; 0093D  0x8A, 0x0E, 0x9D, 0x04
  mov [bx + 0x13], cl                          ; 00941  0x88, 0x4F, 0x13
  mov cl, [0x49f]                              ; 00944  0x8A, 0x0E, 0x9F, 0x04
  mov [es:0x10], cl                            ; 00948  0x26, 0x88, 0x0E, 0x10, 0x00
  mov cx, [0x347]                              ; 0094D  0x8B, 0x0E, 0x47, 0x03
  mov [es:2], cx                               ; 00951  0x26, 0x89, 0x0E, 0x02, 0x00
  mov cx, [0x349]                              ; 00956  0x8B, 0x0E, 0x49, 0x03
  mov [es:4], cx                               ; 0095A  0x26, 0x89, 0x0E, 0x04, 0x00
  cmp byte [0x34d], 0xff                       ; 0095F  0x80, 0x3E, 0x4D, 0x03, 0xFF
  jne loc_0098A                                ; 00964  0x75, 0x24
  mov bx, [0x68]                               ; 00966  0x8B, 0x1E, 0x68, 0x00
  mov si, [0x495]                              ; 0096A  0x8B, 0x36, 0x95, 0x04
  mov ax, [bx + 0x1E]                          ; 0096E  0x8B, 0x47, 0x1E
  mov [si + 0x1E], ax                          ; 00971  0x89, 0x44, 0x1E
  cmp byte [0x34e], 0xff                       ; 00974  0x80, 0x3E, 0x4E, 0x03, 0xFF
  jne loc_0098A                                ; 00979  0x75, 0x0F
  and word [bx + 6], 0xfd7c                    ; 0097B  0x81, 0x67, 0x06, 0x7C, 0xFD
  mov byte [bx + 0x19], 0                      ; 00980  0xC6, 0x47, 0x19, 0x00
  mov cx, 0x8f                                 ; 00984  0xB9, 0x8F, 0x00
  jmp near rtm_dispatcher                      ; 00987  0xE9, 0x89, 0xF9

loc_0098A:  ; 0098A
  push word [0x34b]                            ; 0098A  0xFF, 0x36, 0x4B, 0x03
  push word [0x497]                            ; 0098E  0xFF, 0x36, 0x97, 0x04
  call cli_unsync                               ; 00992  0xE8, 0x87, 0x01
  mov cx, 0x218                                ; 00995  0xB9, 0x18, 0x02
  call rtm_dispatcher                          ; 00998  0xE8, 0x78, 0xF9
  pop dx                                       ; 0099B  0x5A
  pop ax                                       ; 0099C  0x58
  and ax, 0x1000                               ; 0099D  0x25, 0x00, 0x10
  mov bx, [0x68]                               ; 009A0  0x8B, 0x1E, 0x68, 0x00
  mov cx, [bx + 6]                             ; 009A4  0x8B, 0x4F, 0x06
  and cx, 0xefff                               ; 009A7  0x81, 0xE1, 0xFF, 0xEF
  or_cx_ax                                     ; 009AB  or cx, ax
  mov [bx + 6], cx                             ; 009AD  0x89, 0x4F, 0x06
  test word [bx + 6], 0x80                     ; 009B0  0xF7, 0x47, 0x06, 0x80, 0x00
  je loc_009C7                                 ; 009B5  0x74, 0x10
  mov cx, 0x8f                                 ; 009B7  0xB9, 0x8F, 0x00
  xor_dx_dx                                    ; 009BA  xor dx, dx
  call rtm_dispatcher                          ; 009BC  0xE8, 0x54, 0xF9
  and word [bx + 6], 0xff7f                    ; 009BF  0x81, 0x67, 0x06, 0x7F, 0xFF
  mov dx, 0x28                                 ; 009C4  0xBA, 0x28, 0x00

loc_009C7:  ; 009C7
  mov_cx_dx                                    ; 009C7  mov cx, dx
  xor_bx_bx                                    ; 009C9  xor bx, bx
  jcxz loc_009D0                               ; 009CB  0xE3, 0x03
  mov bx, 0xffff                               ; 009CD  0xBB, 0xFF, 0xFF

loc_009D0:  ; 009D0
  ret                                          ; 009D0  0xC3

cli_parse_tail:  ; 009D1
  cmp ax, strict word 0                       ; 009D1  3D 00 00
  je loc_009EC                                 ; 009D4  0x74, 0x16
  push ax                                      ; 009D6  0x50
  sub ax, 0x3d2                                ; 009D7  0x2D, 0xD2, 0x03
  mov cx, 0x80                                 ; 009DA  0xB9, 0x80, 0x00
  sub_cx_ax                                    ; 009DD  sub cx, ax
  shr cx, 1                                    ; 009DF  0xD1, 0xE9
  pop si                                       ; 009E1  0x5E
  mov di, 0x3d2                                ; 009E2  0xBF, 0xD2, 0x03
  push es                                      ; 009E5  0x06
  push ds                                      ; 009E6  0x1E
  pop es                                       ; 009E7  0x07
  rep movsw                                    ; 009E8  0xF3, 0xA5
  pop es                                       ; 009EA  0x07
  ret                                          ; 009EB  0xC3

loc_009EC:  ; 009EC
  mov byte [0x3d2], 0                          ; 009EC  0xC6, 0x06, 0xD2, 0x03, 0x00
  ret                                          ; 009F1  0xC3

cli_crlf:  ; 009F2
  mov dl, 0xd                                  ; 009F2  0xB2, 0x0D
  call cli_prchar                               ; 009F4  0xE8, 0x02, 0x00
  mov dl, 0xa                                  ; 009F7  0xB2, 0x0A

cli_prchar:  ; 009F9
  mov si, [es:0x62]                            ; 009F9  0x26, 0x8B, 0x36, 0x62, 0x00
  mov di, [0x68]                               ; 009FE  0x8B, 0x3E, 0x68, 0x00
  cmp [si], di                                 ; 00A02  0x39, 0x3C
  jne loc_00A0C                                ; 00A04  0x75, 0x06
  mov cx, 2                                    ; 00A06  0xB9, 0x02, 0x00
  jmp near rtm_dispatcher                      ; 00A09  0xE9, 0x07, 0xF9

loc_00A0C:  ; 00A0C
  ret                                          ; 00A0C  0xC3

cli_prtime:  ; 00A0D
  mov dl, [0x80]                               ; 00A0D  0x8A, 0x16, 0x80, 0x00
  call cli_prnum                               ; 00A11  0xE8, 0x1C, 0x00
  mov dl, 0x3a                                 ; 00A14  0xB2, 0x3A
  call cli_prchar                               ; 00A16  0xE8, 0xE0, 0xFF
  mov dl, [0x81]                               ; 00A19  0x8A, 0x16, 0x81, 0x00
  call cli_prnum                               ; 00A1D  0xE8, 0x10, 0x00
  mov dl, 0x3a                                 ; 00A20  0xB2, 0x3A
  call cli_prchar                               ; 00A22  0xE8, 0xD4, 0xFF
  mov dl, [0x82]                               ; 00A25  0x8A, 0x16, 0x82, 0x00
  call cli_prnum                               ; 00A29  0xE8, 0x04, 0x00
  mov dl, 0x20                                 ; 00A2C  0xB2, 0x20
  jmp short cli_prchar                          ; 00A2E  0xEB, 0xC9

cli_prnum:  ; 00A30
  push dx                                      ; 00A30  0x52
  mov cl, 4                                    ; 00A31  0xB1, 0x04
  shr dl, cl                                   ; 00A33  0xD2, 0xEA
  add dl, 0x30                                 ; 00A35  0x80, 0xC2, 0x30
  call cli_prchar                               ; 00A38  0xE8, 0xBE, 0xFF
  pop dx                                       ; 00A3B  0x5A
  and dl, 0xf                                  ; 00A3C  0x80, 0xE2, 0x0F
  add dl, 0x30                                 ; 00A3F  0x80, 0xC2, 0x30
  jmp short cli_prchar                          ; 00A42  0xEB, 0xB5

cli_prfilnam:  ; 00A44
  call cli_prdisk                               ; 00A44  0xE8, 0x36, 0x00
  mov dx, 0x455                                ; 00A47  0xBA, 0x55, 0x04
  call cli_prnam                               ; 00A4A  0xE8, 0x7B, 0x00
  mov dl, 0x2e                                 ; 00A4D  0xB2, 0x2E
  call cli_prchar                               ; 00A4F  0xE8, 0xA7, 0xFF
  mov dx, 0x45d                                ; 00A52  0xBA, 0x5D, 0x04
  call cli_prtyp                               ; 00A55  0xE8, 0x6C, 0x00
  mov dl, 0x20                                 ; 00A58  0xB2, 0x20
  call cli_prchar                               ; 00A5A  0xE8, 0x9C, 0xFF
  mov bx, 0x454                                ; 00A5D  0xBB, 0x54, 0x04
  test byte [bx + 8], 0x80                     ; 00A60  0xF6, 0x47, 0x08, 0x80
  jne loc_00A78                                ; 00A64  0x75, 0x12
  cmp byte [0x49d], 0                          ; 00A66  0x80, 0x3E, 0x9D, 0x04, 0x00

loc_00A6B:  ; 00A6B
  je loc_00A77                                 ; 00A6B  0x74, 0x0A
  mov bx, [0x68]                               ; 00A6D  0x8B, 0x1E, 0x68, 0x00
  cmp byte [bx + 0x13], 0                      ; 00A71  0x80, 0x7F, 0x13, 0x00
  je loc_00A78                                 ; 00A75  0x74, 0x01

loc_00A77:  ; 00A77
  ret                                          ; 00A77  0xC3

loc_00A78:  ; 00A78
  mov dx, 0xabf                                ; 00A78  0xBA, 0xBF, 0x0A
  jmp short cli_prcsm                          ; 00A7B  0xEB, 0x2E

cli_prdisk:  ; 00A7D
  mov dl, [0x454]                              ; 00A7D  0x8A, 0x16, 0x54, 0x04
  cmp dl, 0                                    ; 00A81  0x80, 0xFA, 0x00
  je loc_00A8A                                 ; 00A84  0x74, 0x04
  db 0xFE                                                         ; 00A86  .

loc_00A87:  ; 00A87
  retf 0x7eb                                   ; 00A87  0xCA, 0xEB, 0x07

loc_00A8A:  ; 00A8A
  mov bx, [0x68]                               ; 00A8A  0x8B, 0x1E, 0x68, 0x00
  mov dl, [bx + 0x12]                          ; 00A8E  0x8A, 0x57, 0x12
  add dl, 0x41                                 ; 00A91  0x80, 0xC2, 0x41
  call cli_prchar                               ; 00A94  0xE8, 0x62, 0xFF
  mov dl, 0x3a                                 ; 00A97  0xB2, 0x3A
  jmp near cli_prchar                           ; 00A99  0xE9, 0x5D, 0xFF

cli_prcusp:  ; 00A9C
  mov dx, 0x47d                                ; 00A9C  0xBA, 0x7D, 0x04
  call cli_prnam                               ; 00A9F  0xE8, 0x26, 0x00
  mov dx, 0xab5                                ; 00AA2  0xBA, 0xB5, 0x0A
  call cli_prcsm                               ; 00AA5  0xE8, 0x03, 0x00
  jmp near cli_crlf                           ; 00AA8  0xE9, 0x47, 0xFF

cli_prcsm:  ; 00AAB
  mov si, [es:0x62]                            ; 00AAB  0x26, 0x8B, 0x36, 0x62, 0x00
  mov di, [0x68]                               ; 00AB0  0x8B, 0x3E, 0x68, 0x00
  cmp [si], di                                 ; 00AB4  0x39, 0x3C
  jne loc_00AC3                                ; 00AB6  0x75, 0x0B
  xor_bx_bx                                    ; 00AB8  xor bx, bx
  push ds                                      ; 00ABA  0x1E
  mov ax, cs                                   ; 00ABB  0x8C, 0xC8
  mov ds, ax                                   ; 00ABD  0x8E, 0xD8
  call cli_flclse                               ; 00ABF  0xE8, 0x17, 0x00
  pop ds                                       ; 00AC2  0x1F

loc_00AC3:  ; 00AC3
  ret                                          ; 00AC3  0xC3

cli_prtyp:  ; 00AC4
  mov bh, 3                                    ; 00AC4  0xB7, 0x03
  jmp short loc_00ACA                          ; 00AC6  0xEB, 0x02

cli_prnam:  ; 00AC8
  mov bh, 8                                    ; 00AC8  0xB7, 0x08

loc_00ACA:  ; 00ACA
  mov bl, 0x20                                 ; 00ACA  0xB3, 0x20
  mov si, [es:0x62]                            ; 00ACC  0x26, 0x8B, 0x36, 0x62, 0x00
  mov di, [0x68]                               ; 00AD1  0x8B, 0x3E, 0x68, 0x00
  cmp [si], di                                 ; 00AD5  0x39, 0x3C
  jne loc_00AC3                                ; 00AD7  0x75, 0xEA

cli_flclse:  ; 00AD9
  mov cx, 0x40e                                ; 00AD9  0xB9, 0x0E, 0x04
  jmp short loc_00B22                          ; 00ADC  0xEB, 0x44

cli_flopn:  ; 00ADE
  mov si, [0x68]                               ; 00ADE  0x8B, 0x36, 0x68, 0x00
  push word [si + 6]                           ; 00AE2  0xFF, 0x74, 0x06
  and word [si + 6], 0xff7f                    ; 00AE5  0x81, 0x64, 0x06, 0x7F, 0xFF
  mov cx, 0x10                                 ; 00AEA  0xB9, 0x10, 0x00
  mov dx, 0x454                                ; 00AED  0xBA, 0x54, 0x04
  call cli_osif                               ; 00AF0  0xE8, 0x1E, 0x00
  pop ax                                       ; 00AF3  0x58
  and ax, 0x80                                 ; 00AF4  0x25, 0x80, 0x00
  db 0x8B, 0x36, 0x68                                             ; 00AF7  .6h

io_polldev:  ; 00AFA
  add [bx + di + 0x7fe6], al                   ; 00AFA  0x00, 0x81, 0xE6, 0x7F
  dec word [bx + di]                           ; 00AFE  0xFF, 0x09
  inc sp                                       ; 00B00  0x44
  push es                                      ; 00B01  0x06
  mov_ax_bx                                    ; 00B02  mov ax, bx
  ret                                          ; 00B04  0xC3

cli_open_wait:  ; 00B05
  mov cx, 0xf                                  ; 00B05  0xB9, 0x0F, 0x00
  mov si, 0x454                                ; 00B08  0xBE, 0x54, 0x04
  or byte [si + 6], 0x80                       ; 00B0B  0x80, 0x4C, 0x06, 0x80
  mov_dx_si                                    ; 00B0F  mov dx, si

cli_osif:  ; 00B11
  push es                                      ; 00B11  0x06
  call rtm_dispatcher                          ; 00B12  0xE8, 0xFE, 0xF7
  pop es                                       ; 00B15  0x07
  ret                                          ; 00B16  0xC3

cli_sync:  ; 00B17
  mov cx, 0x215                                ; 00B17  0xB9, 0x15, 0x02
  jmp short loc_00B1F                          ; 00B1A  0xEB, 0x03

cli_unsync:  ; 00B1C
  mov cx, 0x216                                ; 00B1C  0xB9, 0x16, 0x02

loc_00B1F:  ; 00B1F
  mov bx, 0x705                                ; 00B1F  0xBB, 0x05, 0x07

loc_00B22:  ; 00B22
  jmp near rtm_dispatcher                      ; 00B22  0xE9, 0xEE, 0xF7

cli_pfn:  ; 00B25
  mov dx, 0x491                                ; 00B25  0xBA, 0x91, 0x04
  mov cx, 0x98                                 ; 00B28  0xB9, 0x98, 0x00
  jmp short loc_00B22                          ; 00B2B  0xEB, 0xF5

cli_conasn:  ; 00B2D
  mov cx, 0x95                                 ; 00B2D  0xB9, 0x95, 0x00
  mov dx, 0x485                                ; 00B30  0xBA, 0x85, 0x04
  jmp short loc_00B22                          ; 00B33  0xEB, 0xED
  db " Msg Qued", 0, "(User 0)"                ; 00B35  ASCII status string
  add [bp + di - 0x45], dl                     ; 00B47  0x00, 0x53, 0xBB
  add [bx + si], ax                            ; 00B4A  0x01, 0x00
  jmp short loc_00B50                          ; 00B4C  0xEB, 0x02
  sub_bx_bx                                    ; 00B4E  sub bx, bx

loc_00B50:  ; 00B50
  push dx                                      ; 00B50  0x52
  push bx                                      ; 00B51  0x53
  mov cx, 0x89                                 ; 00B52  0xB9, 0x89, 0x00
  mov dx, 0x1d8                                ; 00B55  0xBA, 0xD8, 0x01
  call rtm_dispatcher                          ; 00B58  0xE8, 0xB8, 0xF7
  mov byte [0x211], 0                          ; 00B5B  0xC6, 0x06, 0x11, 0x02, 0x00
  pop word [0x1e8]                             ; 00B60  0x8F, 0x06, 0xE8, 0x01
  pop si                                       ; 00B64  0x5E

loc_00B65:  ; 00B65
  cmp word [0x1e8], 1                          ; 00B65  0x83, 0x3E, 0xE8, 0x01, 0x01
  jne loc_00B75                                ; 00B6A  0x75, 0x09
  pop word [0x1e8]                             ; 00B6C  0x8F, 0x06, 0xE8, 0x01
  mov byte [0x211], 0xff                       ; 00B70  0xC6, 0x06, 0x11, 0x02, 0xFF

loc_00B75:  ; 00B75
  mov cx, 0x10                                 ; 00B75  0xB9, 0x10, 0x00
  mov di, 0x1ea                                ; 00B78  0xBF, 0xEA, 0x01
  push es                                      ; 00B7B  0x06
  push ds                                      ; 00B7C  0x1E
  push ds                                      ; 00B7D  0x1E
  mov ds, [es:0x2e]                            ; 00B7E  0x26, 0x8E, 0x1E, 0x2E, 0x00
  pop es                                       ; 00B83  0x07
  rep movsw                                    ; 00B84  0xF3, 0xA5
  pop ds                                       ; 00B86  0x1F
  pop es                                       ; 00B87  0x07
  mov bx, 0x1ea                                ; 00B88  0xBB, 0xEA, 0x01
  mov byte [bx + 0x23], 0                      ; 00B8B  0xC6, 0x47, 0x23, 0x00
  mov ax, 0                                    ; 00B8F  0xB8, 0x00, 0x00
  mov bx, 1                                    ; 00B92  0xBB, 0x01, 0x00
  mov dx, 0x21d                                ; 00B95  0xBA, 0x1D, 0x02
  mov cx, [cs:6]                               ; 00B98  0x2E, 0x8B, 0x0E, 0x06, 0x00
  call load_xfer                               ; 00B9D  0xE8, 0x90, 0x06
  cmp di, 1                                    ; 00BA0  0x83, 0xFF, 0x01
  je loc_00BA7                                 ; 00BA3  0x74, 0x02
  jcxz loc_00BB0                               ; 00BA5  0xE3, 0x09

loc_00BA7:  ; 00BA7
  mov cx, 0x1c                                 ; 00BA7  0xB9, 0x1C, 0x00
  mov bx, 0xffff                               ; 00BAA  0xBB, 0xFF, 0xFF
  jmp near loc_0115D                           ; 00BAD  0xE9, 0xAD, 0x05

loc_00BB0:  ; 00BB0
  mov byte [0x0219], 0                         ; 00BB0  0xC6, 0x06, 0x19, 0x02, 0x00
  mov bx, 0x21d                                ; 00BB5  0xBB, 0x1D, 0x02
  test byte [bx + 0x7f], 0x20                  ; 00BB8  0xF6, 0x47, 0x7F, 0x20
  je loc_00BCE                                 ; 00BBC  0x74, 0x10
  cmp word [0x8c], -1                          ; 00BBE  0x83, 0x3E, 0x8C, 0x00, 0xFF
  jne loc_00BE3                                ; 00BC3  0x75, 0x1E
  mov cx, 0x11                                 ; 00BC5  0xB9, 0x11, 0x00
  mov bx, 0xffff                               ; 00BC8  0xBB, 0xFF, 0xFF
  jmp near loc_0115D                           ; 00BCB  0xE9, 0x8F, 0x05

loc_00BCE:  ; 00BCE
  test byte [bx + 0x7f], 0x40                  ; 00BCE  0xF6, 0x47, 0x7F, 0x40
  je loc_00BE8                                 ; 00BD2  0x74, 0x14
  cmp word [0x8c], -1                          ; 00BD4  0x83, 0x3E, 0x8C, 0x00, 0xFF
  jne loc_00BE3                                ; 00BD9  0x75, 0x08
  mov byte [0x0219], 1                         ; 00BDB  0xC6, 0x06, 0x19, 0x02, 0x01
  jmp near loc_00BE8                           ; 00BE0  0xE9, 0x05, 0x00

loc_00BE3:  ; 00BE3
  mov byte [0x0219], 0xff                      ; 00BE3  0xC6, 0x06, 0x19, 0x02, 0xFF

loc_00BE8:  ; 00BE8
  mov byte [0x21a], 0                          ; 00BE8  0xC6, 0x06, 0x1A, 0x02, 0x00
  test byte [bx + 0x7f], 8                     ; 00BED  0xF6, 0x47, 0x7F, 0x08
  je loc_00BF8                                 ; 00BF1  0x74, 0x05
  mov byte [0x21a], 0xff                       ; 00BF3  0xC6, 0x06, 0x1A, 0x02, 0xFF

loc_00BF8:  ; 00BF8
  mov word [0x20e], 0                          ; 00BF8  0xC7, 0x06, 0x0E, 0x02, 0x00, 0x00
  mov bx, [0x68]                               ; 00BFE  0x8B, 0x1E, 0x68, 0x00
  mov al, [bx + 0x13]                          ; 00C02  0x8A, 0x47, 0x13
  mov [0x212], al                              ; 00C05  0xA2, 0x12, 0x02
  mov al, [bx + 0x12]                          ; 00C08  0x8A, 0x47, 0x12
  mov [0x213], al                              ; 00C0B  0xA2, 0x13, 0x02
  mov bx, 0x1ea                                ; 00C0E  0xBB, 0xEA, 0x01
  mov al, [bx]                                 ; 00C11  0x8A, 0x07
  mov [0x214], al                              ; 00C13  0xA2, 0x14, 0x02
  test al, al                                  ; 00C16  0x84, 0xC0
  je loc_00C1F                                 ; 00C18  0x74, 0x05
  dec al                                       ; 00C1A  0xFE, 0xC8
  mov [0x213], al                              ; 00C1C  0xA2, 0x13, 0x02

loc_00C1F:  ; 00C1F
  test byte [bx + 8], 0x80                     ; 00C1F  0xF6, 0x47, 0x08, 0x80
  je loc_00C2A                                 ; 00C23  0x74, 0x05
  mov byte [0x212], 0                          ; 00C25  0xC6, 0x06, 0x12, 0x02, 0x00

loc_00C2A:  ; 00C2A
  mov cx, 0x55                                 ; 00C2A  0xB9, 0x55, 0x00
  sub_ax_ax                                    ; 00C2D  sub ax, ax
  mov di, 0x29d                                ; 00C2F  0xBF, 0x9D, 0x02
  push es                                      ; 00C32  0x06
  mov es, [cs:6]                               ; 00C33  0x2E, 0x8E, 0x06, 0x06, 0x00
  rep stosw                                    ; 00C38  0xF3, 0xAB
  pop es                                       ; 00C3A  0x07
  mov word [0x1e6], 0                          ; 00C3B  0xC7, 0x06, 0xE6, 0x01, 0x00, 0x00
  mov si, 0x29d                                ; 00C41  0xBE, 0x9D, 0x02
  cmp word [0x1e8], 0                          ; 00C44  0x83, 0x3E, 0xE8, 0x01, 0x00
  jne loc_00C4E                                ; 00C49  0x75, 0x03
  jmp near loc_00CB4                           ; 00C4B  0xE9, 0x66, 0x00

loc_00C4E:  ; 00C4E
  cmp byte [0x0219], 0                         ; 00C4E  0x80, 0x3E, 0x19, 0x02, 0x00
  je loc_00C76                                 ; 00C53  0x74, 0x21
  cmp byte [0x0219], 0xff                      ; 00C55  0x80, 0x3E, 0x19, 0x02, 0xFF
  je loc_00C69                                 ; 00C5A  0x74, 0x0D
  mov word [si + 2], 0x1a                      ; 00C5C  0xC7, 0x44, 0x02, 0x1A, 0x00
  mov word [si + 4], 0x1a                      ; 00C61  0xC7, 0x44, 0x04, 0x1A, 0x00
  jmp near loc_00C80                           ; 00C66  0xE9, 0x17, 0x00

loc_00C69:  ; 00C69
  mov word [si + 2], 0x1c                      ; 00C69  0xC7, 0x44, 0x02, 0x1C, 0x00
  mov word [si + 4], 0x1c                      ; 00C6E  0xC7, 0x44, 0x04, 0x1C, 0x00
  jmp near loc_00C80                           ; 00C73  0xE9, 0x0A, 0x00

loc_00C76:  ; 00C76
  mov word [si + 2], 0x16                      ; 00C76  0xC7, 0x44, 0x02, 0x16, 0x00
  mov word [si + 4], 0x16                      ; 00C7B  0xC7, 0x44, 0x04, 0x16, 0x00

loc_00C80:  ; 00C80
  mov ax, [0x1e8]                              ; 00C80  0xA1, 0xE8, 0x01
  mov [si + 6], ax                             ; 00C83  0x89, 0x44, 0x06
  mov word [si + 8], 1                         ; 00C86  0xC7, 0x44, 0x08, 0x01, 0x00
  add si, 0x11                                 ; 00C8B  0x83, 0xC6, 0x11
  inc word [0x1e6]                             ; 00C8E  0xFF, 0x06, 0xE6, 0x01
  cmp byte [0x211], 0xff                       ; 00C92  0x80, 0x3E, 0x11, 0x02, 0xFF
  jne loc_00CB4                                ; 00C97  0x75, 0x1B
  push si                                      ; 00C99  0x56
  mov cx, 0x3a                                 ; 00C9A  0xB9, 0x3A, 0x00
  call rtm_dispatcher                          ; 00C9D  0xE8, 0x73, 0xF6
  mov bx, [0x68]                               ; 00CA0  0x8B, 0x1E, 0x68, 0x00
  mov ax, [bx + 0x16]                          ; 00CA4  0x8B, 0x47, 0x16
  mov word [bx + 0x16], 0                      ; 00CA7  0xC7, 0x47, 0x16, 0x00, 0x00
  mov bx, [0x1e8]                              ; 00CAC  0x8B, 0x1E, 0xE8, 0x01
  mov [bx + 0x16], ax                          ; 00CB0  0x89, 0x47, 0x16
  pop si                                       ; 00CB3  0x5E

loc_00CB4:  ; 00CB4
  mov bx, 0x21d                                ; 00CB4  0xBB, 0x1D, 0x02
  mov al, [bx + 0x7f]                          ; 00CB7  0x8A, 0x47, 0x7F
  mov [0x216], al                              ; 00CBA  0xA2, 0x16, 0x02
  mov ax, [bx + 0x7d]                          ; 00CBD  0x8B, 0x47, 0x7D
  mov [0x217], ax                              ; 00CC0  0xA3, 0x17, 0x02
  mov [0x21b], ax                              ; 00CC3  0xA3, 0x1B, 0x02
  mov cx, 8                                    ; 00CC6  0xB9, 0x08, 0x00
  mov dx, 8                                    ; 00CC9  0xBA, 0x08, 0x00

loc_00CCC:  ; 00CCC
  cmp byte [bx], 0                             ; 00CCC  0x80, 0x3F, 0x00
  jne loc_00CD4                                ; 00CCF  0x75, 0x03
  jmp near loc_00D6C                           ; 00CD1  0xE9, 0x98, 0x00

loc_00CD4:  ; 00CD4
  mov al, [bx]                                 ; 00CD4  0x8A, 0x07
  mov [si + 0xe], al                           ; 00CD6  0x88, 0x44, 0x0E
  mov ax, [bx + 1]                             ; 00CD9  0x8B, 0x47, 0x01
  mov [si + 0xc], ax                           ; 00CDC  0x89, 0x44, 0x0C
  mov [si + 0xa], dx                           ; 00CDF  0x89, 0x54, 0x0A
  add_dx_ax                                    ; 00CE2  add dx, ax
  mov ax, [bx + 3]                             ; 00CE4  0x8B, 0x47, 0x03
  mov [si], ax                                 ; 00CE7  0x89, 0x04
  mov ax, [bx + 5]                             ; 00CE9  0x8B, 0x47, 0x05
  mov [si + 2], ax                             ; 00CEC  0x89, 0x44, 0x02
  mov ax, [bx + 7]                             ; 00CEF  0x8B, 0x47, 0x07
  cmp ax, strict word 0                       ; 00CF2  3D 00 00
  jne loc_00CFA                                ; 00CF5  0x75, 0x03
  mov ax, [bx + 5]                             ; 00CF7  0x8B, 0x47, 0x05

loc_00CFA:  ; 00CFA
  mov [si + 4], ax                             ; 00CFA  0x89, 0x44, 0x04
  mov ax, [0x1e8]                              ; 00CFD  0xA1, 0xE8, 0x01
  mov [si + 6], ax                             ; 00D00  0x89, 0x44, 0x06
  cmp ax, strict word 0                       ; 00D03  3D 00 00
  je loc_00D0F                                 ; 00D06  0x74, 0x07
  mov ax, 1                                    ; 00D08  0xB8, 0x01, 0x00
  jmp short loc_00D0F                          ; 00D0B  0xEB, 0x02

loc_00D0D:  ; 00D0D
  jmp short loc_00CCC                          ; 00D0D  0xEB, 0xBD

loc_00D0F:  ; 00D0F
  cmp byte [bx], 1                             ; 00D0F  0x80, 0x3F, 0x01
  jne loc_00D19                                ; 00D12  0x75, 0x05
  add ax, strict word 4                       ; 00D14  05 04 00
  jmp short loc_00D21                          ; 00D17  0xEB, 0x08

loc_00D19:  ; 00D19
  cmp byte [bx], 9                             ; 00D19  0x80, 0x3F, 0x09
  jne loc_00D21                                ; 00D1C  0x75, 0x03
  add ax, strict word 6                       ; 00D1E  05 06 00

loc_00D21:  ; 00D21
  mov [si + 8], ax                             ; 00D21  0x89, 0x44, 0x08
  cmp word [si], 0                             ; 00D24  0x83, 0x3C, 0x00
  je loc_00D2B                                 ; 00D27  0x74, 0x02
  jmp short loc_00D42                          ; 00D29  0xEB, 0x17

loc_00D2B:  ; 00D2B
  cmp byte [si + 0xe], 9                       ; 00D2B  0x80, 0x7C, 0x0E, 0x09
  jne loc_00D65                                ; 00D2F  0x75, 0x34
  push cx                                      ; 00D31  0x51
  push bx                                      ; 00D32  0x53
  push dx                                      ; 00D33  0x52
  call rtm_put_drl                               ; 00D34  0xE8, 0x8A, 0x05
  pop dx                                       ; 00D37  0x5A
  pop bx                                       ; 00D38  0x5B
  cmp cx, 0                                    ; 00D39  0x83, 0xF9, 0x00
  pop cx                                       ; 00D3C  0x59
  je loc_00D65                                 ; 00D3D  0x74, 0x26
  jmp near loc_00DDB                           ; 00D3F  0xE9, 0x99, 0x00

loc_00D42:  ; 00D42
  push bx                                      ; 00D42  0x53
  push dx                                      ; 00D43  0x52
  push cx                                      ; 00D44  0x51
  push si                                      ; 00D45  0x56
  mov cx, 0x80                                 ; 00D46  0xB9, 0x80, 0x00
  mov_dx_si                                    ; 00D49  mov dx, si
  call rtm_dispatcher                          ; 00D4B  0xE8, 0xC5, 0xF5
  pop si                                       ; 00D4E  0x5E
  mov ax, [si]                                 ; 00D4F  0x8B, 0x04
  mov [si + 0xf], ax                           ; 00D51  0x89, 0x44, 0x0F
  cmp cx, 0                                    ; 00D54  0x83, 0xF9, 0x00
  pop cx                                       ; 00D57  0x59
  pop dx                                       ; 00D58  0x5A
  pop bx                                       ; 00D59  0x5B
  je loc_00D65                                 ; 00D5A  0x74, 0x09
  mov bx, 0xffff                               ; 00D5C  0xBB, 0xFF, 0xFF
  mov cx, 3                                    ; 00D5F  0xB9, 0x03, 0x00
  jmp near loc_00DDB                           ; 00D62  0xE9, 0x76, 0x00

loc_00D65:  ; 00D65
  add si, 0x11                                 ; 00D65  0x83, 0xC6, 0x11
  inc word [0x1e6]                             ; 00D68  0xFF, 0x06, 0xE6, 0x01

loc_00D6C:  ; 00D6C
  add bx, 9                                    ; 00D6C  0x83, 0xC3, 0x09
  loop loc_00D0D                               ; 00D6F  0xE2, 0x9C
  mov bx, 0x29d                                ; 00D71  0xBB, 0x9D, 0x02
  mov cx, [0x1e6]                              ; 00D74  0x8B, 0x0E, 0xE6, 0x01
  mov byte [0x210], 0                          ; 00D78  0xC6, 0x06, 0x10, 0x02, 0x00

loc_00D7D:  ; 00D7D
  cmp word [bx + 2], 0                         ; 00D7D  0x83, 0x7F, 0x02, 0x00
  je loc_00DB0                                 ; 00D81  0x74, 0x2D
  cmp word [bx], 0                             ; 00D83  0x83, 0x3F, 0x00
  jne loc_00DB0                                ; 00D86  0x75, 0x28
  mov ax, [bx + 2]                             ; 00D88  0x8B, 0x47, 0x02
  mov_dx_ax                                    ; 00D8B  mov dx, ax
  add [si + 2], ax                             ; 00D8D  0x01, 0x44, 0x02
  cmp dx, [si + 2]                             ; 00D90  0x3B, 0x54, 0x02
  jbe loc_00D9A                                ; 00D93  0x76, 0x05
  mov word [si + 2], 0xffff                    ; 00D95  0xC7, 0x44, 0x02, 0xFF, 0xFF

loc_00D9A:  ; 00D9A
  mov ax, [bx + 4]                             ; 00D9A  0x8B, 0x47, 0x04
  mov_dx_ax                                    ; 00D9D  mov dx, ax
  add [si + 4], ax                             ; 00D9F  0x01, 0x44, 0x04
  cmp dx, [si + 4]                             ; 00DA2  0x3B, 0x54, 0x04
  jbe loc_00DAC                                ; 00DA5  0x76, 0x05
  mov word [si + 4], 0xffff                    ; 00DA7  0xC7, 0x44, 0x04, 0xFF, 0xFF

loc_00DAC:  ; 00DAC
  inc byte [0x210]                             ; 00DAC  0xFE, 0x06, 0x10, 0x02

loc_00DB0:  ; 00DB0
  add bx, 0x11                                 ; 00DB0  0x83, 0xC3, 0x11
  loop loc_00D7D                               ; 00DB3  0xE2, 0xC8
  cmp word [0x1e8], 0                          ; 00DB5  0x83, 0x3E, 0xE8, 0x01, 0x00
  je loc_00DC1                                 ; 00DBA  0x74, 0x05
  mov word [si + 8], 1                         ; 00DBC  0xC7, 0x44, 0x08, 0x01, 0x00

loc_00DC1:  ; 00DC1
  mov ax, [0x1e8]                              ; 00DC1  0xA1, 0xE8, 0x01
  mov [si + 6], ax                             ; 00DC4  0x89, 0x44, 0x06
  push si                                      ; 00DC7  0x56
  mov_dx_si                                    ; 00DC8  mov dx, si
  mov cx, 0x80                                 ; 00DCA  0xB9, 0x80, 0x00
  call rtm_dispatcher                          ; 00DCD  0xE8, 0x43, 0xF5
  pop si                                       ; 00DD0  0x5E
  mov ax, [si]                                 ; 00DD1  0x8B, 0x04
  mov [si + 0xf], ax                           ; 00DD3  0x89, 0x44, 0x0F
  cmp bx, -1                                   ; 00DD6  0x83, 0xFB, 0xFF
  jne loc_00E0E                                ; 00DD9  0x75, 0x33

loc_00DDB:  ; 00DDB
  push cx                                      ; 00DDB  0x51
  mov bx, 0x29d                                ; 00DDC  0xBB, 0x9D, 0x02
  mov cx, [0x1e6]                              ; 00DDF  0x8B, 0x0E, 0xE6, 0x01
  inc cx                                       ; 00DE3  0x41

loc_00DE4:  ; 00DE4
  cmp word [bx + 0xf], 0                       ; 00DE4  0x83, 0x7F, 0x0F, 0x00
  je loc_00E02                                 ; 00DE8  0x74, 0x18
  push cx                                      ; 00DEA  0x51
  push bx                                      ; 00DEB  0x53
  push ds                                      ; 00DEC  0x1E
  push word [bx + 6]                           ; 00DED  0xFF, 0x77, 0x06
  push word [bx + 0xf]                         ; 00DF0  0xFF, 0x77, 0x0F
  mov_dx_sp                                    ; 00DF3  mov dx, sp
  push ss                                      ; 00DF5  0x16
  pop ds                                       ; 00DF6  0x1F
  mov cx, 0x82                                 ; 00DF7  0xB9, 0x82, 0x00
  call rtm_dispatcher                          ; 00DFA  0xE8, 0x16, 0xF5
  pop cx                                       ; 00DFD  0x59
  pop cx                                       ; 00DFE  0x59
  pop ds                                       ; 00DFF  0x1F
  pop bx                                       ; 00E00  0x5B
  pop cx                                       ; 00E01  0x59

loc_00E02:  ; 00E02
  add bx, 0x11                                 ; 00E02  0x83, 0xC3, 0x11
  loop loc_00DE4                               ; 00E05  0xE2, 0xDD
  mov bx, 0xffff                               ; 00E07  0xBB, 0xFF, 0xFF
  pop cx                                       ; 00E0A  0x59
  jmp near loc_0115D                           ; 00E0B  0xE9, 0x4F, 0x03

loc_00E0E:  ; 00E0E
  mov bx, 0x29d                                ; 00E0E  0xBB, 0x9D, 0x02
  mov cx, [0x1e6]                              ; 00E11  0x8B, 0x0E, 0xE6, 0x01

loc_00E15:  ; 00E15
  cmp word [bx], 0                             ; 00E15  0x83, 0x3F, 0x00
  jne loc_00E2F                                ; 00E18  0x75, 0x15
  mov ax, [bx + 2]                             ; 00E1A  0x8B, 0x47, 0x02
  sub [si + 2], ax                             ; 00E1D  0x29, 0x44, 0x02
  cmp ax, [bx + 4]                             ; 00E20  0x3B, 0x47, 0x04
  jne loc_00E2F                                ; 00E23  0x75, 0x0A
  mov dx, [si]                                 ; 00E25  0x8B, 0x14
  mov [bx], dx                                 ; 00E27  0x89, 0x17
  add [si], ax                                 ; 00E29  0x01, 0x04
  dec byte [0x210]                             ; 00E2B  0xFE, 0x0E, 0x10, 0x02

loc_00E2F:  ; 00E2F
  add bx, 0x11                                 ; 00E2F  0x83, 0xC3, 0x11
  loop loc_00E15                               ; 00E32  0xE2, 0xE1
  mov bx, 0x29d                                ; 00E34  0xBB, 0x9D, 0x02
  mov cx, [0x1e6]                              ; 00E37  0x8B, 0x0E, 0xE6, 0x01

loc_00E3B:  ; 00E3B
  cmp word [bx], 0                             ; 00E3B  0x83, 0x3F, 0x00
  jne loc_00E79                                ; 00E3E  0x75, 0x39
  mov ax, [si]                                 ; 00E40  0x8B, 0x04
  mov [bx], ax                                 ; 00E42  0x89, 0x07
  mov ax, [si + 2]                             ; 00E44  0x8B, 0x44, 0x02
  cmp ax, strict word 0                       ; 00E47  3D 00 00
  je loc_00E70                                 ; 00E4A  0x74, 0x24
  push cx                                      ; 00E4C  0x51
  sub_cx_cx                                    ; 00E4D  sub cx, cx
  mov_dx_cx                                    ; 00E4F  mov dx, cx
  mov cl, [0x210]                              ; 00E51  0x8A, 0x0E, 0x10, 0x02
  div_cx                                       ; 00E55  div cx
  pop cx                                       ; 00E57  0x59
  cmp dx, 0                                    ; 00E58  0x83, 0xFA, 0x00
  je loc_00E5E                                 ; 00E5B  0x74, 0x01
  inc ax                                       ; 00E5D  0x40

loc_00E5E:  ; 00E5E
  mov dx, [bx + 4]                             ; 00E5E  0x8B, 0x57, 0x04
  sub dx, [bx + 2]                             ; 00E61  0x2B, 0x57, 0x02
  cmp_ax_dx                                    ; 00E64  cmp ax, dx
  jbe loc_00E6A                                ; 00E66  0x76, 0x02
  mov_ax_dx                                    ; 00E68  mov ax, dx

loc_00E6A:  ; 00E6A
  add [bx + 2], ax                             ; 00E6A  0x01, 0x47, 0x02
  sub [si + 2], ax                             ; 00E6D  0x29, 0x44, 0x02

loc_00E70:  ; 00E70
  mov ax, [bx + 2]                             ; 00E70  0x8B, 0x47, 0x02
  add [si], ax                                 ; 00E73  0x01, 0x04
  dec byte [0x210]                             ; 00E75  0xFE, 0x0E, 0x10, 0x02

loc_00E79:  ; 00E79
  add bx, 0x11                                 ; 00E79  0x83, 0xC3, 0x11
  loop loc_00E3B                               ; 00E7C  0xE2, 0xBD
  mov si, 0x29d                                ; 00E7E  0xBE, 0x9D, 0x02
  mov cx, [0x1e6]                              ; 00E81  0x8B, 0x0E, 0xE6, 0x01

loc_00E85:  ; 00E85
  cmp word [si + 0xc], 0                       ; 00E85  0x83, 0x7C, 0x0C, 0x00
  je loc_00ED9                                 ; 00E89  0x74, 0x4E
  push cx                                      ; 00E8B  0x51
  push word [si]                               ; 00E8C  0xFF, 0x34
  push si                                      ; 00E8E  0x56
  call load_group                               ; 00E8F  0xE8, 0xD9, 0x02
  pop si                                       ; 00E92  0x5E
  pop word [si]                                ; 00E93  0x8F, 0x04
  cmp cx, 0                                    ; 00E95  0x83, 0xF9, 0x00
  pop cx                                       ; 00E98  0x59
  je loc_00ED9                                 ; 00E99  0x74, 0x3E
  cmp word [si + 8], 7                         ; 00E9B  0x83, 0x7C, 0x08, 0x07
  je loc_00EA4                                 ; 00E9F  0x74, 0x03
  jmp near loc_00DDB                           ; 00EA1  0xE9, 0x37, 0xFF

loc_00EA4:  ; 00EA4
  push cx                                      ; 00EA4  0x51
  pushf                                        ; 00EA5  0x9C
  cli                                          ; 00EA6  0xFA
  mov bx, [0x70]                               ; 00EA7  0x8B, 0x1E, 0x70, 0x00
  mov ax, [bx + 2]                             ; 00EAB  0x8B, 0x47, 0x02
  mov [0x70], ax                               ; 00EAE  0xA3, 0x70, 0x00
  popf                                         ; 00EB1  0x9D
  push ds                                      ; 00EB2  0x1E
  push bx                                      ; 00EB3  0x53
  mov bx, [bx + 0x16]                          ; 00EB4  0x8B, 0x5F, 0x16
  push word [bx + 2]                           ; 00EB7  0xFF, 0x77, 0x02
  mov ax, ss                                   ; 00EBA  0x8C, 0xD0
  mov ds, ax                                   ; 00EBC  0x8E, 0xD8
  mov_dx_sp                                    ; 00EBE  mov dx, sp
  mov cx, 0x82                                 ; 00EC0  0xB9, 0x82, 0x00
  call rtm_dispatcher                          ; 00EC3  0xE8, 0x4D, 0xF4
  pop ax                                       ; 00EC6  0x58
  pop bx                                       ; 00EC7  0x5B
  pop ds                                       ; 00EC8  0x1F
  pushf                                        ; 00EC9  0x9C
  cli                                          ; 00ECA  0xFA
  mov ax, [0x5c]                               ; 00ECB  0xA1, 0x5C, 0x00
  mov [0x5c], bx                               ; 00ECE  0x89, 0x1E, 0x5C, 0x00
  mov [bx], ax                                 ; 00ED2  0x89, 0x07
  popf                                         ; 00ED4  0x9D
  pop cx                                       ; 00ED5  0x59
  jmp near loc_00DDB                           ; 00ED6  0xE9, 0x02, 0xFF

loc_00ED9:  ; 00ED9
  add si, 0x11                                 ; 00ED9  0x83, 0xC6, 0x11
  loop loc_00E85                               ; 00EDC  0xE2, 0xA7
  test byte [0x216], 0x80                      ; 00EDE  0xF6, 0x06, 0x16, 0x02, 0x80
  je loc_00F5A                                 ; 00EE3  0x74, 0x75

loc_00EE5:  ; 00EE5
  mov ax, [0x217]                              ; 00EE5  0xA1, 0x17, 0x02
  mov bx, 1                                    ; 00EE8  0xBB, 0x01, 0x00
  mov cx, ds                                   ; 00EEB  0x8C, 0xD9
  mov dx, 0x21d                                ; 00EED  0xBA, 0x1D, 0x02
  call load_xfer                               ; 00EF0  0xE8, 0x3D, 0x03
  jcxz loc_00F04                               ; 00EF3  0xE3, 0x0F
  inc cl                                       ; 00EF5  0xFE, 0xC1
  jne loc_00F54                                ; 00EF7  0x75, 0x5B
  mov ax, [0x21b]                              ; 00EF9  0xA1, 0x1B, 0x02
  cmp ax, [0x217]                              ; 00EFC  0x3B, 0x06, 0x17, 0x02
  je loc_00F54                                 ; 00F00  0x74, 0x52
  jmp short loc_00F5A                          ; 00F02  0xEB, 0x56

loc_00F04:  ; 00F04
  mov bx, 0x21d                                ; 00F04  0xBB, 0x1D, 0x02

loc_00F07:  ; 00F07
  mov al, [bx]                                 ; 00F07  0x8A, 0x07
  test al, al                                  ; 00F09  0x84, 0xC0
  je loc_00F5A                                 ; 00F0B  0x74, 0x4D
  and al, 0xf                                  ; 00F0D  0x24, 0x0F
  call load_tblsrch                               ; 00F0F  0xE8, 0x2D, 0x00
  mov dx, [di]                                 ; 00F12  0x8B, 0x15
  mov al, [bx]                                 ; 00F14  0x8A, 0x07
  mov cl, 4                                    ; 00F16  0xB1, 0x04
  shr al, cl                                   ; 00F18  0xD2, 0xE8
  call load_tblsrch                               ; 00F1A  0xE8, 0x22, 0x00
  mov ax, [di]                                 ; 00F1D  0x8B, 0x05
  add ax, [bx + 1]                             ; 00F1F  0x03, 0x47, 0x01
  push es                                      ; 00F22  0x06
  mov es, ax                                   ; 00F23  0x8E, 0xC0
  xor_ax_ax                                    ; 00F25  xor ax, ax
  mov al, [bx + 3]                             ; 00F27  0x8A, 0x47, 0x03
  mov_di_ax                                    ; 00F2A  mov di, ax
  add [es:di], dx                              ; 00F2C  0x26, 0x01, 0x15
  pop es                                       ; 00F2F  0x07
  add bx, 4                                    ; 00F30  0x83, 0xC3, 0x04
  cmp bx, 0x29d                                ; 00F33  0x81, 0xFB, 0x9D, 0x02
  jne loc_00F07                                ; 00F37  0x75, 0xCE
  inc word [0x217]                             ; 00F39  0xFF, 0x06, 0x17, 0x02
  jmp short loc_00EE5                          ; 00F3D  0xEB, 0xA6

load_tblsrch:  ; 00F3F
  mov cx, [0x1e6]                              ; 00F3F  0x8B, 0x0E, 0xE6, 0x01
  mov di, 0x29d                                ; 00F43  0xBF, 0x9D, 0x02

loc_00F46:  ; 00F46
  cmp al, [di + 0xe]                           ; 00F46  0x3A, 0x45, 0x0E
  je loc_00F53                                 ; 00F49  0x74, 0x08
  add di, 0x11                                 ; 00F4B  0x83, 0xC7, 0x11
  loop loc_00F46                               ; 00F4E  0xE2, 0xF6
  pop ax                                       ; 00F50  0x58
  jmp short loc_00F54                          ; 00F51  0xEB, 0x01

loc_00F53:  ; 00F53
  ret                                          ; 00F53  0xC3

loc_00F54:  ; 00F54
  mov cx, 0x29                                 ; 00F54  0xB9, 0x29, 0x00
  jmp near loc_00DDB                           ; 00F57  0xE9, 0x81, 0xFE

loc_00F5A:  ; 00F5A
  mov byte [0x215], 0                          ; 00F5A  0xC6, 0x06, 0x15, 0x02, 0x00
  mov si, 0x29d                                ; 00F5F  0xBE, 0x9D, 0x02
  mov cx, [0x1e6]                              ; 00F62  0x8B, 0x0E, 0xE6, 0x01

loc_00F66:  ; 00F66
  cmp byte [si + 0xe], 2                       ; 00F66  0x80, 0x7C, 0x0E, 0x02
  je loc_00F8E                                 ; 00F6A  0x74, 0x22
  add si, 0x11                                 ; 00F6C  0x83, 0xC6, 0x11
  loop loc_00F66                               ; 00F6F  0xE2, 0xF5
  mov si, 0x29d                                ; 00F71  0xBE, 0x9D, 0x02
  mov cx, [0x1e6]                              ; 00F74  0x8B, 0x0E, 0xE6, 0x01

loc_00F78:  ; 00F78
  cmp byte [si + 0xe], 1                       ; 00F78  0x80, 0x7C, 0x0E, 0x01
  je loc_00F89                                 ; 00F7C  0x74, 0x0B
  add si, 0x11                                 ; 00F7E  0x83, 0xC6, 0x11
  loop loc_00F78                               ; 00F81  0xE2, 0xF5
  mov cx, 0x21                                 ; 00F83  0xB9, 0x21, 0x00
  jmp near loc_00DDB                           ; 00F86  0xE9, 0x52, 0xFE

loc_00F89:  ; 00F89
  mov byte [0x215], 1                          ; 00F89  0xC6, 0x06, 0x15, 0x02, 0x01

loc_00F8E:  ; 00F8E
  push es                                      ; 00F8E  0x06
  mov es, [si]                                 ; 00F8F  0x8E, 0x04
  mov [0x1e4], es                              ; 00F91  0x8C, 0x06, 0xE4, 0x01
  sub_ax_ax                                    ; 00F95  sub ax, ax
  mov_di_ax                                    ; 00F97  mov di, ax
  mov cx, 0x2d                                 ; 00F99  0xB9, 0x2D, 0x00
  rep stosw                                    ; 00F9C  0xF3, 0xAB
  mov al, [0x215]                              ; 00F9E  0xA0, 0x15, 0x02
  mov [es:5], al                               ; 00FA1  0x26, 0xA2, 0x05, 0x00
  mov si, 0x29d                                ; 00FA5  0xBE, 0x9D, 0x02
  mov cx, [0x1e6]                              ; 00FA8  0x8B, 0x0E, 0xE6, 0x01

loc_00FAC:  ; 00FAC
  cmp byte [si + 0xe], 0                       ; 00FAC  0x80, 0x7C, 0x0E, 0x00
  je loc_00FF9                                 ; 00FB0  0x74, 0x47
  mov ax, 6                                    ; 00FB2  0xB8, 0x06, 0x00
  mov bl, [si + 0xe]                           ; 00FB5  0x8A, 0x5C, 0x0E
  cmp bl, 9                                    ; 00FB8  0x80, 0xFB, 0x09
  jne loc_00FBF                                ; 00FBB  0x75, 0x02
  mov bl, 1                                    ; 00FBD  0xB3, 0x01

loc_00FBF:  ; 00FBF
  dec bl                                       ; 00FBF  0xFE, 0xCB
  mul_bl                                       ; 00FC1  mul bl
  mov_bx_ax                                    ; 00FC3  mov bx, ax
  push cx                                      ; 00FC5  0x51
  mov dx, [si + 2]                             ; 00FC6  0x8B, 0x54, 0x02
  push dx                                      ; 00FC9  0x52
  mov cl, 4                                    ; 00FCA  0xB1, 0x04
  shl dx, cl                                   ; 00FCC  0xD3, 0xE2
  push dx                                      ; 00FCE  0x52
  dec dx                                       ; 00FCF  0x4A
  mov [es:bx], dx                              ; 00FD0  0x26, 0x89, 0x17
  pop cx                                       ; 00FD3  0x59
  pop dx                                       ; 00FD4  0x5A
  push cx                                      ; 00FD5  0x51
  mov cl, 0xc                                  ; 00FD6  0xB1, 0x0C
  shr dx, cl                                   ; 00FD8  0xD3, 0xEA
  pop cx                                       ; 00FDA  0x59
  cmp cx, 0                                    ; 00FDB  0x83, 0xF9, 0x00
  jne loc_00FEE                                ; 00FDE  0x75, 0x0E
  cmp dx, 0                                    ; 00FE0  0x83, 0xFA, 0x00
  je loc_00FE9                                 ; 00FE3  0x74, 0x04
  dec dl                                       ; 00FE5  0xFE, 0xCA
  jmp short loc_00FEE                          ; 00FE7  0xEB, 0x05

loc_00FE9:  ; 00FE9
  mov word [es:bx], 0                          ; 00FE9  0x26, 0xC7, 0x07, 0x00, 0x00

loc_00FEE:  ; 00FEE
  mov [es:bx + 2], dl                          ; 00FEE  0x26, 0x88, 0x57, 0x02
  pop cx                                       ; 00FF2  0x59
  mov ax, [si]                                 ; 00FF3  0x8B, 0x04
  mov [es:bx + 3], ax                          ; 00FF5  0x26, 0x89, 0x47, 0x03

loc_00FF9:  ; 00FF9
  add si, 0x11                                 ; 00FF9  0x83, 0xC6, 0x11
  loop loc_00FAC                               ; 00FFC  0xE2, 0xAE
  cmp byte [0x215], 1                          ; 00FFE  0x80, 0x3E, 0x15, 0x02, 0x01
  jne loc_01014                                ; 01003  0x75, 0x0F
  push ds                                      ; 01005  0x1E
  push es                                      ; 01006  0x06
  pop ds                                       ; 01007  0x1F
  mov si, 0                                    ; 01008  0xBE, 0x00, 0x00
  mov di, 6                                    ; 0100B  0xBF, 0x06, 0x00
  mov cx, 3                                    ; 0100E  0xB9, 0x03, 0x00
  rep movsw                                    ; 01011  0xF3, 0xA5
  pop ds                                       ; 01013  0x1F

loc_01014:  ; 01014
  mov al, [0x214]                              ; 01014  0xA0, 0x14, 0x02
  mov [es:0x50], al                            ; 01017  0x26, 0xA2, 0x50, 0x00
  pop es                                       ; 0101B  0x07
  mov bx, [0x1e4]                              ; 0101C  0x8B, 0x1E, 0xE4, 0x01
  cmp word [0x1e8], 0                          ; 01020  0x83, 0x3E, 0xE8, 0x01, 0x00
  jne loc_0102A                                ; 01025  0x75, 0x03
  jmp near loc_0115D                           ; 01027  0xE9, 0x33, 0x01

loc_0102A:  ; 0102A
  mov si, 0x29d                                ; 0102A  0xBE, 0x9D, 0x02
  mov bx, [0x1e8]                              ; 0102D  0x8B, 0x1E, 0xE8, 0x01
  cmp byte [0x0219], 0                         ; 01031  0x80, 0x3E, 0x19, 0x02, 0x00
  je loc_0104C                                 ; 01036  0x74, 0x14
  cmp byte [0x0219], 1                         ; 01038  0x80, 0x3E, 0x19, 0x02, 0x01
  jne loc_01047                                ; 0103D  0x75, 0x08
  or word [bx + 0x26], strict word 2          ; 0103F  81 4F 26 02 00 (p_sflag[bx])
  jmp near loc_0104C                           ; 01044  0xE9, 0x05, 0x00

loc_01047:  ; 01047
  or word [bx + 6], 0x8000                     ; 01047  0x81, 0x4F, 0x06, 0x00, 0x80

loc_0104C:  ; 0104C
  cmp byte [0x21a], 0xff                       ; 0104C  0x80, 0x3E, 0x1A, 0x02, 0xFF
  jne loc_01058                                ; 01051  0x75, 0x05
  or word [bx + 0x26], strict word 1          ; 01053  81 4F 26 01 00 (p_sflag[bx])

loc_01058:  ; 01058
  mov ax, [si]                                 ; 01058  0x8B, 0x04
  mov [bx + 0x10], ax                          ; 0105A  0x89, 0x47, 0x10
  mov [0x1e0], ax                              ; 0105D  0xA3, 0xE0, 0x01
  push es                                      ; 01060  0x06
  mov es, ax                                   ; 01061  0x8E, 0xC0
  cmp byte [0x0219], 0                         ; 01063  0x80, 0x3E, 0x19, 0x02, 0x00
  je loc_0107D                                 ; 01068  0x74, 0x13
  cmp byte [0x0219], 1                         ; 0106A  0x80, 0x3E, 0x19, 0x02, 0x01
  je loc_01077                                 ; 0106F  0x74, 0x06
  add ax, strict word 0x16                    ; 01071  05 16 00
  jmp near loc_01080                           ; 01074  0xE9, 0x09, 0x00

loc_01077:  ; 01077
  add ax, strict word 0x14                    ; 01077  05 14 00
  jmp near loc_01080                           ; 0107A  0xE9, 0x03, 0x00

loc_0107D:  ; 0107D
  add ax, strict word 0x10                    ; 0107D  05 10 00

loc_01080:  ; 01080
  mov [0x1e2], ax                              ; 01080  0xA3, 0xE2, 0x01
  xor_di_di                                    ; 01083  xor di, di
  mov_ax_di                                    ; 01085  mov ax, di
  cmp byte [0x0219], 0                         ; 01087  0x80, 0x3E, 0x19, 0x02, 0x00
  je loc_010A1                                 ; 0108C  0x74, 0x13
  cmp byte [0x0219], 1                         ; 0108E  0x80, 0x3E, 0x19, 0x02, 0x01
  jne loc_0109B                                ; 01093  0x75, 0x06
  mov cx, 0xd0                                 ; 01095  0xB9, 0xD0, 0x00
  jmp near loc_010A4                           ; 01098  0xE9, 0x09, 0x00

loc_0109B:  ; 0109B
  mov cx, 0xe0                                 ; 0109B  0xB9, 0xE0, 0x00
  jmp near loc_010A4                           ; 0109E  0xE9, 0x03, 0x00

loc_010A1:  ; 010A1
  mov cx, 0xb0                                 ; 010A1  0xB9, 0xB0, 0x00

loc_010A4:  ; 010A4
  rep stosw                                    ; 010A4  0xF3, 0xAB
  pop es                                       ; 010A6  0x07
  mov ax, [cs:6]                               ; 010A7  0x2E, 0xA1, 0x06, 0x00
  sub [bx + 0x10], ax                          ; 010AB  0x29, 0x47, 0x10
  mov byte [bx + 4], 0                         ; 010AE  0xC6, 0x47, 0x04, 0x00
  mov byte [bx + 5], 0xc8                      ; 010B2  0xC6, 0x47, 0x05, 0xC8
  mov al, [0x212]                              ; 010B6  0xA0, 0x12, 0x02
  mov [bx + 0x15], al                          ; 010B9  0x88, 0x47, 0x15
  mov al, [0x213]                              ; 010BC  0xA0, 0x13, 0x02
  mov [bx + 0x14], al                          ; 010BF  0x88, 0x47, 0x14
  push es                                      ; 010C2  0x06
  mov es, [0x1e0]                              ; 010C3  0x8E, 0x06, 0xE0, 0x01
  mov word [es:2], 0x80                       ; 010C7
  mov bx, [0x1e4]                              ; 010CE  0x8B, 0x1E, 0xE4, 0x01
  mov [es:4], bx                               ; 010D2  0x26, 0x89, 0x1E, 0x04, 0x00
  mov ax, [0x1e2]                              ; 010D7  0xA1, 0xE2, 0x01
  cmp byte [0x0219], 0xff                      ; 010DA  0x80, 0x3E, 0x19, 0x02, 0xFF
  jne loc_010F8                                ; 010DF  0x75, 0x17
  mov word [es:0x100], 0x3ff                  ; 010E1
  push ax                                      ; 010E8  0x50
  mov ax, [0xa4]                               ; 010E9  0xA1, 0xA4, 0x00
  mov [es:0x40], ax                            ; 010EC  0x26, 0xA3, 0x40, 0x00
  mov ax, [0xa6]                               ; 010F0  0xA1, 0xA6, 0x00
  mov [es:0x42], ax                            ; 010F3  0x26, 0xA3, 0x42, 0x00
  pop ax                                       ; 010F7  0x58

loc_010F8:  ; 010F8
  push ds                                      ; 010F8  0x1E
  mov ds, bx                                   ; 010F9  0x8E, 0xDB
  mov [es:0x52], bx                            ; 010FB  0x26, 0x89, 0x1E, 0x52, 0x00
  mov [es:0x54], bx                            ; 01100  0x26, 0x89, 0x1E, 0x54, 0x00
  mov [es:0x56], ax                            ; 01105  0x26, 0xA3, 0x56, 0x00
  mov ax, [3]                                  ; 01109  0xA1, 0x03, 0x00
  cmp ax, strict word 0                       ; 0110C  3D 00 00
  jne loc_01119                                ; 0110F  0x75, 0x08
  pop ds                                       ; 01111  0x1F
  pop es                                       ; 01112  0x07
  mov cx, 0x21                                 ; 01113  0xB9, 0x21, 0x00
  jmp near loc_00DDB                           ; 01116  0xE9, 0xC2, 0xFC

loc_01119:  ; 01119
  mov [es:0x50], ax                            ; 01119  0x26, 0xA3, 0x50, 0x00
  mov ax, [0xf]                                ; 0111D  0xA1, 0x0F, 0x00
  cmp ax, strict word 0                       ; 01120  3D 00 00
  je loc_01129                                 ; 01123  0x74, 0x04
  mov [es:0x54], ax                            ; 01125  0x26, 0xA3, 0x54, 0x00

loc_01129:  ; 01129
  mov word [es:0x34], 0x56                    ; 01129
  sub_dx_dx                                    ; 01130  sub dx, dx
  mov al, [5]                                  ; 01132  0xA0, 0x05, 0x00
  cmp al, 0                                    ; 01135  0x3C, 0x00
  je loc_0113C                                 ; 01137  0x74, 0x03
  mov dx, 0x100                                ; 01139  0xBA, 0x00, 0x01

loc_0113C:  ; 0113C
  mov ds, [es:0x56]                            ; 0113C  0x26, 0x8E, 0x1E, 0x56, 0x00
  mov [0x56], dx                               ; 01141  0x89, 0x16, 0x56, 0x00
  mov word [0x5a], 0x200                       ; 01145  0xC7, 0x06, 0x5A, 0x00, 0x00, 0x02
  mov word [0x5c], 0x2bb                       ; 0114B  0xC7, 0x06, 0x5C, 0x00, 0xBB, 0x02
  mov [0x5e], cs                               ; 01151  0x8C, 0x0E, 0x5E, 0x00
  pop ds                                       ; 01155  0x1F
  pop es                                       ; 01156  0x07
  mov bx, [0x1e4]                              ; 01157  0x8B, 0x1E, 0xE4, 0x01
  sub_cx_cx                                    ; 0115B  sub cx, cx

loc_0115D:  ; 0115D
  push cx                                      ; 0115D  0x51
  push bx                                      ; 0115E  0x53
  mov cx, 0x8b                                 ; 0115F  0xB9, 0x8B, 0x00
  mov dx, 0x1d8                                ; 01162  0xBA, 0xD8, 0x01
  call rtm_dispatcher                          ; 01165  0xE8, 0xAB, 0xF1
  pop bx                                       ; 01168  0x5B
  pop cx                                       ; 01169  0x59
  ret                                          ; 0116A  0xC3

load_group:  ; 0116B
  mov_bx_si                                    ; 0116B  mov bx, si
  mov ax, [0x20e]                              ; 0116D  0xA1, 0x0E, 0x02
  mov cx, [bx + 0xa]                           ; 01170  0x8B, 0x4F, 0x0A
  cmp_cx_ax                                    ; 01173  cmp cx, ax
  jb loc_011AE                                 ; 01175  0x72, 0x37
  sub_cx_ax                                    ; 01177  sub cx, ax
  cmp cx, 8                                    ; 01179  0x83, 0xF9, 0x08
  jae loc_011AE                                ; 0117C  0x73, 0x30
  mov dx, 8                                    ; 0117E  0xBA, 0x08, 0x00
  sub_dx_cx                                    ; 01181  sub dx, cx
  cmp dx, [bx + 0xc]                           ; 01183  0x3B, 0x57, 0x0C
  jbe loc_0118B                                ; 01186  0x76, 0x03
  mov dx, [bx + 0xc]                           ; 01188  0x8B, 0x57, 0x0C

loc_0118B:  ; 0118B
  mov si, 0x21d                                ; 0118B  0xBE, 0x1D, 0x02
  mov_ax_cx                                    ; 0118E  mov ax, cx
  mov cl, 4                                    ; 01190  0xB1, 0x04
  shl ax, cl                                   ; 01192  0xD3, 0xE0
  add_si_ax                                    ; 01194  add si, ax
  mov_ax_dx                                    ; 01196  mov ax, dx
  mov cl, 3                                    ; 01198  0xB1, 0x03
  shl ax, cl                                   ; 0119A  0xD3, 0xE0
  mov_cx_ax                                    ; 0119C  mov cx, ax
  xor_di_di                                    ; 0119E  xor di, di
  push es                                      ; 011A0  0x06
  mov es, [bx]                                 ; 011A1  0x8E, 0x07
  rep movsw                                    ; 011A3  0xF3, 0xA5
  pop es                                       ; 011A5  0x07
  add [bx], dx                                 ; 011A6  0x01, 0x17
  sub [bx + 0xc], dx                           ; 011A8  0x29, 0x57, 0x0C
  add [bx + 0xa], dx                           ; 011AB  0x01, 0x57, 0x0A

loc_011AE:  ; 011AE
  cmp word [bx + 0xc], 0                       ; 011AE  0x83, 0x7F, 0x0C, 0x00
  jne loc_011B7                                ; 011B2  0x75, 0x03
  sub_cx_cx                                    ; 011B4  sub cx, cx
  ret                                          ; 011B6  0xC3

loc_011B7:  ; 011B7
  test word [bx + 0xa], 7                      ; 011B7  0xF7, 0x47, 0x0A, 0x07, 0x00
  jne loc_011C4                                ; 011BC  0x75, 0x06
  cmp word [bx + 0xc], 8                       ; 011BE  0x83, 0x7F, 0x0C, 0x08
  jae loc_011F7                                ; 011C2  0x73, 0x33

loc_011C4:  ; 011C4
  push bx                                      ; 011C4  0x53
  mov ax, [bx + 0xa]                           ; 011C5  0x8B, 0x47, 0x0A
  shr ax, 1                                    ; 011C8  0xD1, 0xE8
  shr ax, 1                                    ; 011CA  0xD1, 0xE8
  shr ax, 1                                    ; 011CC  0xD1, 0xE8
  mov bx, 1                                    ; 011CE  0xBB, 0x01, 0x00
  mov dx, 0x21d                                ; 011D1  0xBA, 0x1D, 0x02
  mov cx, [cs:6]                               ; 011D4  0x2E, 0x8B, 0x0E, 0x06, 0x00
  call load_xfer                               ; 011D9  0xE8, 0x54, 0x00
  pop bx                                       ; 011DC  0x5B
  jcxz loc_011E9                               ; 011DD  0xE3, 0x0A
  cmp cx, 0xff                                 ; 011DF  0x81, 0xF9, 0xFF, 0x00
  jne loc_011E8                                ; 011E3  0x75, 0x03
  mov cx, 0                                    ; 011E5  0xB9, 0x00, 0x00

loc_011E8:  ; 011E8
  ret                                          ; 011E8  0xC3

loc_011E9:  ; 011E9
  mov ax, [bx + 0xa]                           ; 011E9  0x8B, 0x47, 0x0A
  and ax, strict word 0xfff8                  ; 011EC  25 F8 FF
  mov [0x20e], ax                              ; 011EF  0xA3, 0x0E, 0x02
  mov_si_bx                                    ; 011F2  mov si, bx
  jmp near load_group                           ; 011F4  0xE9, 0x74, 0xFF

loc_011F7:  ; 011F7
  push bx                                      ; 011F7  0x53
  sub_dx_dx                                    ; 011F8  sub dx, dx
  mov cx, [bx]                                 ; 011FA  0x8B, 0x0F
  mov ax, [bx + 0xa]                           ; 011FC  0x8B, 0x47, 0x0A
  shr ax, 1                                    ; 011FF  0xD1, 0xE8
  shr ax, 1                                    ; 01201  0xD1, 0xE8
  shr ax, 1                                    ; 01203  0xD1, 0xE8
  mov bx, [bx + 0xc]                           ; 01205  0x8B, 0x5F, 0x0C
  shr bx, 1                                    ; 01208  0xD1, 0xEB
  shr bx, 1                                    ; 0120A  0xD1, 0xEB
  shr bx, 1                                    ; 0120C  0xD1, 0xEB
  push bx                                      ; 0120E  0x53
  call load_xfer                               ; 0120F  0xE8, 0x1E, 0x00
  pop ax                                       ; 01212  0x58
  pop bx                                       ; 01213  0x5B
  jcxz loc_0121F                               ; 01214  0xE3, 0x09
  cmp cx, 0xff                                 ; 01216  0x81, 0xF9, 0xFF, 0x00
  jne loc_0121E                                ; 0121A  0x75, 0x02
  xor_cx_cx                                   ; 0121C  xor cx, cx

loc_0121E:  ; 0121E
  ret                                          ; 0121E  0xC3

loc_0121F:  ; 0121F
  shl ax, 1                                    ; 0121F  0xD1, 0xE0
  shl ax, 1                                    ; 01221  0xD1, 0xE0
  shl ax, 1                                    ; 01223  0xD1, 0xE0
  add [bx], ax                                 ; 01225  0x01, 0x07
  add [bx + 0xa], ax                           ; 01227  0x01, 0x47, 0x0A
  sub [bx + 0xc], ax                           ; 0122A  0x29, 0x47, 0x0C
  jmp near loc_011AE                           ; 0122D  0xE9, 0x7E, 0xFF

load_xfer:  ; 01230
  mov [es:2], dx                               ; 01230  0x26, 0x89, 0x16, 0x02, 0x00
  mov [es:4], cx                               ; 01235  0x26, 0x89, 0x0E, 0x04, 0x00

loc_0123A:  ; 0123A
  push bx                                      ; 0123A  0x53
  push ax                                      ; 0123B  0x50
  cmp bx, 0x80                                 ; 0123C  0x81, 0xFB, 0x80, 0x00
  jbe loc_01245                                ; 01240  0x76, 0x03
  mov bx, 0x80                                 ; 01242  0xBB, 0x80, 0x00

loc_01245:  ; 01245
  mov cl, [es:0x11]                            ; 01245  0x26, 0x8A, 0x0E, 0x11, 0x00
  push cx                                      ; 0124A  0x51
  mov [es:0x11], bl                            ; 0124B  0x26, 0x88, 0x1E, 0x11, 0x00
  push bx                                      ; 01250  0x53
  mov si, 0x1ea                                ; 01251  0xBE, 0xEA, 0x01
  mov [si + 0x21], ax                          ; 01254  0x89, 0x44, 0x21
  mov cx, 0x21                                 ; 01257  0xB9, 0x21, 0x00
  mov_dx_si                                    ; 0125A  mov dx, si
  push es                                      ; 0125C  0x06
  call rtm_dispatcher                          ; 0125D  0xE8, 0xB3, 0xF0
  pop es                                       ; 01260  0x07
  pop dx                                       ; 01261  0x5A
  pop cx                                       ; 01262  0x59
  mov [es:0x11], cl                            ; 01263  0x26, 0x88, 0x0E, 0x11, 0x00
  cmp bl, 1                                    ; 01268  0x80, 0xFB, 0x01
  jbe loc_01276                                ; 0126B  0x76, 0x09
  mov cx, 0x1d                                 ; 0126D  0xB9, 0x1D, 0x00
  mov bx, 0xffff                               ; 01270  0xBB, 0xFF, 0xFF
  pop ax                                       ; 01273  0x58
  pop ax                                       ; 01274  0x58
  ret                                          ; 01275  0xC3

loc_01276:  ; 01276
  mov_cl_bl                                    ; 01276  mov cl, bl
  xor_bh_bh                                    ; 01278  xor bh, bh
  mov_di_bx                                    ; 0127A  mov di, bx
  pop ax                                       ; 0127C  0x58
  add_ax_dx                                    ; 0127D  add ax, dx
  pop bx                                       ; 0127F  0x5B
  sub_bx_dx                                    ; 01280  sub bx, dx
  shl dx, 1                                    ; 01282  0xD1, 0xE2
  shl dx, 1                                    ; 01284  0xD1, 0xE2
  shl dx, 1                                    ; 01286  0xD1, 0xE2
  add [es:4], dx                               ; 01288  0x26, 0x01, 0x16, 0x04, 0x00
  push cx                                      ; 0128D  0x51
  push ax                                      ; 0128E  0x50
  push bx                                      ; 0128F  0x53
  push di                                      ; 01290  0x57
  mov cx, 0x418                                ; 01291  0xB9, 0x18, 0x04
  call rtm_dispatcher                          ; 01294  0xE8, 0x7C, 0xF0
  pop di                                       ; 01297  0x5F
  pop bx                                       ; 01298  0x5B
  pop ax                                       ; 01299  0x58
  pop cx                                       ; 0129A  0x59
  mov si, [0x68]                               ; 0129B  0x8B, 0x36, 0x68, 0x00
  test word [si + 6], 0x80                     ; 0129F  0xF7, 0x44, 0x06, 0x80, 0x00
  je loc_012AD                                 ; 012A4  0x74, 0x07
  mov cx, 0x28                                 ; 012A6  0xB9, 0x28, 0x00
  mov bx, 0xffff                               ; 012A9  0xBB, 0xFF, 0xFF
  ret                                          ; 012AC  0xC3

loc_012AD:  ; 012AD
  cmp cl, 0                                    ; 012AD  0x80, 0xF9, 0x00
  je loc_012B6                                 ; 012B0  0x74, 0x04
  mov cx, 0xff                                 ; 012B2  0xB9, 0xFF, 0x00
  ret                                          ; 012B5  0xC3

loc_012B6:  ; 012B6
  cmp bx, 0                                    ; 012B6  0x83, 0xFB, 0x00
  jne loc_012BE                                ; 012B9  0x75, 0x03
  xor_cx_cx                                   ; 012BB  xor cx, cx
  ret                                          ; 012BD  0xC3

loc_012BE:  ; 012BE
  jmp near loc_0123A                           ; 012BE  0xE9, 0x79, 0xFF

rtm_put_drl:  ; 012C1
  mov bx, 0x6e                                 ; 012C1  0xBB, 0x6E, 0x00

loc_012C4:  ; 012C4
  push si                                      ; 012C4  0x56
  mov dx, 0x1ea                                ; 012C5  0xBA, 0xEA, 0x01
  add dx, 1                                    ; 012C8  0x83, 0xC2, 0x01
  mov cx, 0x214                                ; 012CB  0xB9, 0x14, 0x02
  call rtm_dispatcher                          ; 012CE  0xE8, 0x42, 0xF0
  pop si                                       ; 012D1  0x5E
  cmp bx, -1                                   ; 012D2  0x83, 0xFB, 0xFF
  je loc_01322                                 ; 012D5  0x74, 0x4B
  mov al, [0x213]                              ; 012D7  0xA0, 0x13, 0x02
  cmp [bx + 0x14], al                          ; 012DA  0x38, 0x47, 0x14
  jne loc_012C4                                ; 012DD  0x75, 0xE5
  mov al, [0x212]                              ; 012DF  0xA0, 0x12, 0x02
  cmp [bx + 0x15], al                          ; 012E2  0x38, 0x47, 0x15
  jne loc_012C4                                ; 012E5  0x75, 0xDD
  push bx                                      ; 012E7  0x53
  push si                                      ; 012E8  0x56
  call rtm_get_pmem                               ; 012E9  0xE8, 0xC2, 0x00
  pop si                                       ; 012EC  0x5E
  pop bx                                       ; 012ED  0x5B
  cmp cx, -1                                   ; 012EE  0x83, 0xF9, 0xFF
  je loc_01322                                 ; 012F1  0x74, 0x2F
  mov word [si + 0xc], 0                       ; 012F3  0xC7, 0x44, 0x0C, 0x00, 0x00
  pushf                                        ; 012F8  0x9C
  cli                                          ; 012F9  0xFA
  mov di, 0x6e                                 ; 012FA  0xBF, 0x6E, 0x00

loc_012FD:  ; 012FD
  cmp [di + 2], bx                             ; 012FD  0x39, 0x5D, 0x02
  je loc_01307                                 ; 01300  0x74, 0x05
  mov di, [di + 2]                             ; 01302  0x8B, 0x7D, 0x02
  jmp short loc_012FD                          ; 01305  0xEB, 0xF6

loc_01307:  ; 01307
  mov ax, [bx + 2]                             ; 01307  0x8B, 0x47, 0x02
  mov [di + 2], ax                             ; 0130A  0x89, 0x45, 0x02

loc_0130D:  ; 0130D
  cmp word [di + 2], 0                         ; 0130D  0x83, 0x7D, 0x02, 0x00
  je loc_01318                                 ; 01311  0x74, 0x05
  mov di, [di + 2]                             ; 01313  0x8B, 0x7D, 0x02
  jmp short loc_0130D                          ; 01316  0xEB, 0xF5

loc_01318:  ; 01318
  mov [di + 2], bx                             ; 01318  0x89, 0x5D, 0x02
  xor_cx_cx                                   ; 0131B  xor cx, cx
  mov [bx + 2], cx                             ; 0131D  0x89, 0x4F, 0x02
  popf                                         ; 01320  0x9D
  ret                                          ; 01321  0xC3

loc_01322:  ; 01322
  pushf                                        ; 01322  0x9C
  cli                                          ; 01323  0xFA
  mov bx, [0x5c]                               ; 01324  0x8B, 0x1E, 0x5C, 0x00
  cmp bx, 0                                    ; 01328  0x83, 0xFB, 0x00
  je loc_013A9                                 ; 0132B  0x74, 0x7C
  mov ax, [bx]                                 ; 0132D  0x8B, 0x07
  mov [0x5c], ax                               ; 0132F  0xA3, 0x5C, 0x00
  popf                                         ; 01332  0x9D
  push bx                                      ; 01333  0x53
  push si                                      ; 01334  0x56
  mov cx, 0x80                                 ; 01335  0xB9, 0x80, 0x00
  mov_dx_si                                    ; 01338  mov dx, si
  call rtm_dispatcher                          ; 0133A  0xE8, 0xD6, 0xEF
  pop si                                       ; 0133D  0x5E
  pop bx                                       ; 0133E  0x5B
  cmp cx, 0                                    ; 0133F  0x83, 0xF9, 0x00
  jne loc_0139E                                ; 01342  0x75, 0x5A
  push si                                      ; 01344  0x56
  mov si, [si + 6]                             ; 01345  0x8B, 0x74, 0x06
  push si                                      ; 01348  0x56
  mov_di_bx                                    ; 01349  mov di, bx
  add si, 8                                    ; 0134B  0x83, 0xC6, 0x08
  add di, 8                                    ; 0134E  0x83, 0xC7, 0x08
  mov cx, 4                                    ; 01351  0xB9, 0x04, 0x00
  push es                                      ; 01354  0x06
  mov ax, ds                                   ; 01355  0x8C, 0xD8
  mov es, ax                                   ; 01357  0x8E, 0xC0
  rep movsw                                    ; 01359  0xF3, 0xA5
  pop es                                       ; 0135B  0x07
  pop di                                       ; 0135C  0x5F
  pop si                                       ; 0135D  0x5E
  mov al, [0x212]                              ; 0135E  0xA0, 0x12, 0x02
  mov [bx + 0x15], al                          ; 01361  0x88, 0x47, 0x15
  mov al, [0x213]                              ; 01364  0xA0, 0x13, 0x02
  mov [bx + 0x14], al                          ; 01367  0x88, 0x47, 0x14
  mov ax, [si]                                 ; 0136A  0x8B, 0x04
  push bx                                      ; 0136C  0x53
  push si                                      ; 0136D  0x56
  push ds                                      ; 0136E  0x1E
  push ax                                      ; 0136F  0x50
  push bx                                      ; 01370  0x53
  push di                                      ; 01371  0x57
  mov ax, ss                                   ; 01372  0x8C, 0xD0
  mov ds, ax                                   ; 01374  0x8E, 0xD8
  mov_dx_sp                                    ; 01376  mov dx, sp
  mov cx, 0x308                                ; 01378  0xB9, 0x08, 0x03
  call rtm_dispatcher                          ; 0137B  0xE8, 0x95, 0xEF
  add sp, 6                                    ; 0137E  0x83, 0xC4, 0x06
  pop ds                                       ; 01381  0x1F
  pop si                                       ; 01382  0x5E
  pop bx                                       ; 01383  0x5B
  pushf                                        ; 01384  0x9C
  cli                                          ; 01385  0xFA
  mov di, 0x6e                                 ; 01386  0xBF, 0x6E, 0x00

loc_01389:  ; 01389
  cmp word [di + 2], 0                         ; 01389  0x83, 0x7D, 0x02, 0x00
  je loc_01394                                 ; 0138D  0x74, 0x05
  mov di, [di + 2]                             ; 0138F  0x8B, 0x7D, 0x02
  jmp short loc_01389                          ; 01392  0xEB, 0xF5

loc_01394:  ; 01394
  mov [di + 2], bx                             ; 01394  0x89, 0x5D, 0x02
  xor_cx_cx                                   ; 01397  xor cx, cx
  mov [bx + 2], cx                             ; 01399  0x89, 0x4F, 0x02
  popf                                         ; 0139C  0x9D
  ret                                          ; 0139D  0xC3

loc_0139E:  ; 0139E
  pushf                                        ; 0139E  0x9C
  cli                                          ; 0139F  0xFA
  mov ax, [0x5c]                               ; 013A0  0xA1, 0x5C, 0x00
  mov [bx], ax                                 ; 013A3  0x89, 0x07
  mov [0x5c], bx                               ; 013A5  0x89, 0x1E, 0x5C, 0x00

loc_013A9:  ; 013A9
  popf                                         ; 013A9  0x9D
  mov cx, 0xffff                               ; 013AA  0xB9, 0xFF, 0xFF
  ret                                          ; 013AD  0xC3

rtm_get_pmem:  ; 013AE
  lea di, [bx + 0x16]                          ; 013AE  0x8D, 0x7F, 0x16

loc_013B1:  ; 013B1
  mov di, [di]                                 ; 013B1  0x8B, 0x3D
  cmp di, 0                                    ; 013B3  0x83, 0xFF, 0x00
  je loc_013E5                                 ; 013B6  0x74, 0x2D
  mov ax, [di + 6]                             ; 013B8  0x8B, 0x45, 0x06
  and ax, strict word 7                       ; 013BB  25 07 00
  cmp ax, strict word 7                       ; 013BE  3D 07 00
  jne loc_013B1                                ; 013C1  0x75, 0xEE
  push si                                      ; 013C3  0x56
  push ds                                      ; 013C4  0x1E
  push word [di + 2]                           ; 013C5  0xFF, 0x75, 0x02
  push word [di + 2]                           ; 013C8  0xFF, 0x75, 0x02
  push word [0x1e8]                            ; 013CB  0xFF, 0x36, 0xE8, 0x01
  push bx                                      ; 013CF  0x53
  mov ax, ss                                   ; 013D0  0x8C, 0xD0
  mov ds, ax                                   ; 013D2  0x8E, 0xD8
  mov_dx_sp                                    ; 013D4  mov dx, sp
  mov cx, 0x308                                ; 013D6  0xB9, 0x08, 0x03
  call rtm_dispatcher                          ; 013D9  0xE8, 0x37, 0xEF
  pop ax                                       ; 013DC  0x58
  pop ax                                       ; 013DD  0x58
  pop ax                                       ; 013DE  0x58
  pop dx                                       ; 013DF  0x5A
  pop ds                                       ; 013E0  0x1F
  pop si                                       ; 013E1  0x5E
  mov [si], dx                                 ; 013E2  0x89, 0x14
  ret                                          ; 013E4  0xC3

loc_013E5:  ; 013E5
  mov cx, 0xffff                               ; 013E5  0xB9, 0xFF, 0xFF
  ret                                          ; 013E8  0xC3
  mov ax, [es:0x2e]                            ; 013E9  0x26, 0xA1, 0x2E, 0x00
  push ds                                      ; 013ED  0x1E
  mov ds, ax                                   ; 013EE  0x8E, 0xD8
  push es                                      ; 013F0  0x06
  mov es, ax                                   ; 013F1  0x8E, 0xC0
  mov_bx_dx                                    ; 013F3  mov bx, dx
  mov si, [bx]                                 ; 013F5  0x8B, 0x37
  mov bx, [bx + 2]                             ; 013F7  0x8B, 0x5F, 0x02
  call parse_fcbi                               ; 013FA  0xE8, 0x36, 0x01
  call parse_debl                               ; 013FD  0xE8, 0x25, 0x01
  mov bp, 0x18                                 ; 01400  0xBD, 0x18, 0x00
  call parse_delim                               ; 01403  0xE8, 0xE0, 0x00
  jne loc_0140B                                ; 01406  0x75, 0x03
  jmp near loc_014BC                           ; 01408  0xE9, 0xB1, 0x00

loc_0140B:  ; 0140B
  mov_ch_al                                    ; 0140B  mov ch, al
  inc si                                       ; 0140D  0x46
  mov al, [si]                                 ; 0140E  0x8A, 0x04
  cmp al, 0x3a                                 ; 01410  0x3C, 0x3A
  jne loc_0143D                                ; 01412  0x75, 0x29
  mov bp, 0x17                                 ; 01414  0xBD, 0x17, 0x00
  mov_al_ch                                    ; 01417  mov al, ch
  sub al, 0x41                                 ; 01419  0x2C, 0x41
  jb loc_01452                                 ; 0141B  0x72, 0x35
  cmp al, 0x10                                 ; 0141D  0x3C, 0x10
  jge loc_01452                                ; 0141F  0x7D, 0x31
  inc al                                       ; 01421  0xFE, 0xC0
  mov [bx], al                                 ; 01423  0x88, 0x07
  mov bp, 0x18                                 ; 01425  0xBD, 0x18, 0x00
  inc si                                       ; 01428  0x46
  call parse_delim                               ; 01429  0xE8, 0xBA, 0x00
  jne loc_0143E                                ; 0142C  0x75, 0x10
  cmp al, 0x2e                                 ; 0142E  0x3C, 0x2E
  je loc_01452                                 ; 01430  0x74, 0x20
  cmp al, 0x3a                                 ; 01432  0x3C, 0x3A
  je loc_01452                                 ; 01434  0x74, 0x1C
  cmp al, 0x3b                                 ; 01436  0x3C, 0x3B
  je loc_01452                                 ; 01438  0x74, 0x18
  jmp near loc_0143E                           ; 0143A  0xE9, 0x01, 0x00

loc_0143D:  ; 0143D
  dec si                                       ; 0143D  0x4E

loc_0143E:  ; 0143E
  mov_di_bx                                    ; 0143E  mov di, bx
  lea bx, [di + 1]                             ; 01440  0x8D, 0x5D, 0x01
  mov ch, 8                                    ; 01443  0xB5, 0x08
  call parse_setfld                               ; 01445  0xE8, 0x7C, 0x00
  cmp ch, 0                                    ; 01448  0x80, 0xFD, 0x00
  jne loc_0145A                                ; 0144B  0x75, 0x0D
  call parse_delim                               ; 0144D  0xE8, 0x96, 0x00
  je loc_0145A                                 ; 01450  0x74, 0x08

loc_01452:  ; 01452
  mov_cx_bp                                    ; 01452  mov cx, bp
  mov bx, 0xffff                               ; 01454  0xBB, 0xFF, 0xFF
  pop es                                       ; 01457  0x07
  pop ds                                       ; 01458  0x1F
  ret                                          ; 01459  0xC3

loc_0145A:  ; 0145A
  cmp al, 0x2e                                 ; 0145A  0x3C, 0x2E
  jne loc_01477                                ; 0145C  0x75, 0x19
  mov bp, 0x19                                 ; 0145E  0xBD, 0x19, 0x00
  mov ch, 3                                    ; 01461  0xB5, 0x03
  lea bx, [di + 9]                             ; 01463  0x8D, 0x5D, 0x09
  inc si                                       ; 01466  0x46
  call parse_setfld                               ; 01467  0xE8, 0x5A, 0x00
  cmp ch, 0                                    ; 0146A  0x80, 0xFD, 0x00
  jne loc_01477                                ; 0146D  0x75, 0x08
  call parse_delim                               ; 0146F  0xE8, 0x74, 0x00
  je loc_01477                                 ; 01472  0x74, 0x03
  jmp near loc_01452                           ; 01474  0xE9, 0xDB, 0xFF

loc_01477:  ; 01477
  cmp al, 0x3b                                 ; 01477  0x3C, 0x3B
  jne loc_014A8                                ; 01479  0x75, 0x2D
  mov bp, 0x26                                 ; 0147B  0xBD, 0x26, 0x00
  mov ch, 8                                    ; 0147E  0xB5, 0x08
  lea bx, [di + 0x10]                          ; 01480  0x8D, 0x5D, 0x10
  inc si                                       ; 01483  0x46
  mov [di + 0x18], si                          ; 01484  0x89, 0x75, 0x18
  call parse_setfld                               ; 01487  0xE8, 0x3A, 0x00
  mov cl, 8                                    ; 0148A  0xB1, 0x08
  sub_cl_ch                                    ; 0148C  sub cl, ch
  mov [di + 0x1A], cl                          ; 0148E  0x88, 0x4D, 0x1A
  cmp cl, 0                                    ; 01491  0x80, 0xF9, 0x00
  jne loc_0149B                                ; 01494  0x75, 0x05
  mov word [di + 0x18], 0                      ; 01496  0xC7, 0x45, 0x18, 0x00, 0x00

loc_0149B:  ; 0149B
  cmp ch, 0                                    ; 0149B  0x80, 0xFD, 0x00
  jne loc_014A8                                ; 0149E  0x75, 0x08
  call parse_delim                               ; 014A0  0xE8, 0x43, 0x00
  je loc_014A8                                 ; 014A3  0x74, 0x03
  jmp near loc_01452                           ; 014A5  0xE9, 0xAA, 0xFF

loc_014A8:  ; 014A8
  mov_bx_si                                    ; 014A8  mov bx, si
  call parse_debl                               ; 014AA  0xE8, 0x78, 0x00
  call parse_delim                               ; 014AD  0xE8, 0x36, 0x00
  jne loc_014BF                                ; 014B0  0x75, 0x0D
  mov_bx_si                                    ; 014B2  mov bx, si
  cmp al, 0                                    ; 014B4  0x3C, 0x00
  je loc_014BC                                 ; 014B6  0x74, 0x04
  cmp al, 0xd                                  ; 014B8  0x3C, 0x0D
  jne loc_014BF                                ; 014BA  0x75, 0x03

loc_014BC:  ; 014BC
  mov bx, 0                                    ; 014BC  0xBB, 0x00, 0x00

loc_014BF:  ; 014BF
  sub_cx_cx                                    ; 014BF  sub cx, cx
  pop es                                       ; 014C1  0x07
  pop ds                                       ; 014C2  0x1F
  ret                                          ; 014C3  0xC3

parse_setfld:  ; 014C4
  pop dx                                       ; 014C4  0x5A
  call parse_delim                               ; 014C5  0xE8, 0x1E, 0x00
  push dx                                      ; 014C8  0x52
  je loc_014E5                                 ; 014C9  0x74, 0x1A
  cmp al, 0x2a                                 ; 014CB  0x3C, 0x2A
  jne loc_014DA                                ; 014CD  0x75, 0x0B
  mov byte [bx], 0x3f                          ; 014CF  0xC6, 0x07, 0x3F
  inc bx                                       ; 014D2  0x43
  dec ch                                       ; 014D3  0xFE, 0xCD
  jne parse_setfld                                ; 014D5  0x75, 0xED
  jmp near loc_014DF                           ; 014D7  0xE9, 0x05, 0x00

loc_014DA:  ; 014DA
  mov [bx], al                                 ; 014DA  0x88, 0x07
  inc bx                                       ; 014DC  0x43
  dec ch                                       ; 014DD  0xFE, 0xCD

loc_014DF:  ; 014DF
  inc si                                       ; 014DF  0x46
  cmp ch, 0                                    ; 014E0  0x80, 0xFD, 0x00
  jne parse_setfld                                ; 014E3  0x75, 0xDF

loc_014E5:  ; 014E5
  ret                                          ; 014E5  0xC3

parse_delim:  ; 014E6
  mov cl, 0xe                                  ; 014E6  0xB1, 0x0E
  mov al, [si]                                 ; 014E8  0x8A, 0x04
  push di                                      ; 014EA  0x57
  mov di, 0x1497                               ; 014EB  0xBF, 0x97, 0x14

loc_014EE:  ; 014EE
  cmp cl, 0                                    ; 014EE  0x80, 0xF9, 0x00
  je loc_014FD                                 ; 014F1  0x74, 0x0A
  cmp [cs:di], al                              ; 014F3  0x2E, 0x38, 0x05
  je loc_01515                                 ; 014F6  0x74, 0x1D
  dec cl                                       ; 014F8  0xFE, 0xC9
  inc di                                       ; 014FA  0x47
  jmp short loc_014EE                          ; 014FB  0xEB, 0xF1

loc_014FD:  ; 014FD
  cmp al, 0x20                                 ; 014FD  0x3C, 0x20
  ja loc_01509                                 ; 014FF  0x77, 0x08
  pop di                                       ; 01501  0x5F
  pop bx                                       ; 01502  0x5B
  mov cx, 0x18                                 ; 01503  0xB9, 0x18, 0x00
  jmp near loc_01452                           ; 01506  0xE9, 0x49, 0xFF

loc_01509:  ; 01509
  cmp al, 0x61                                 ; 01509  0x3C, 0x61
  jb loc_01515                                 ; 0150B  0x72, 0x08
  cmp al, 0x7a                                 ; 0150D  0x3C, 0x7A
  ja loc_01513                                 ; 0150F  0x77, 0x02
  and al, 0x5f                                 ; 01511  0x24, 0x5F

loc_01513:  ; 01513
  and al, 0x7f                                 ; 01513  0x24, 0x7F

loc_01515:  ; 01515
  pop di                                       ; 01515  0x5F
  ret                                          ; 01516  0xC3
  db 0x00                                                         ; 01517  .
  or [di], cx                                  ; 01518  0x09, 0x0D
  cmp bh, [cs:bp + di]                         ; 0151A  0x2E, 0x3A, 0x3B
  cmp ax, 0x2f2c                               ; 0151D  0x3D, 0x2C, 0x2F
  pop bx                                       ; 01520  0x5B
  pop bp                                       ; 01521  0x5D
  cmp al, 0x3e                                 ; 01522  0x3C, 0x3E
  db 0x20                                                         ; 01524   

parse_debl:  ; 01525
  cmp byte [si], 0x20                          ; 01525  0x80, 0x3C, 0x20
  je loc_01530                                 ; 01528  0x74, 0x06
  cmp byte [si], 9                             ; 0152A  0x80, 0x3C, 0x09
  je loc_01530                                 ; 0152D  0x74, 0x01
  ret                                          ; 0152F  0xC3

loc_01530:  ; 01530
  inc si                                       ; 01530  0x46
  jmp short parse_debl                          ; 01531  0xEB, 0xF2

parse_fcbi:  ; 01533
  mov_di_bx                                    ; 01533  mov di, bx
  sub_ax_ax                                    ; 01535  sub ax, ax
  sub_cx_cx                                    ; 01537  sub cx, cx
  stosb                                        ; 01539  0xAA
  mov al, 0x20                                 ; 0153A  0xB0, 0x20
  mov cl, 0xb                                  ; 0153C  0xB1, 0x0B
  rep stosb                                    ; 0153E  0xF3, 0xAA
  mov al, 0                                    ; 01540  0xB0, 0x00
  mov cl, 2                                    ; 01542  0xB1, 0x02
  rep stosw                                    ; 01544  0xF3, 0xAB
  mov al, 0x20                                 ; 01546  0xB0, 0x20
  mov cl, 8                                    ; 01548  0xB1, 0x08
  rep stosb                                    ; 0154A  0xF3, 0xAA
  mov al, 0                                    ; 0154C  0xB0, 0x00
  mov cl, 3                                    ; 0154E  0xB1, 0x03
  rep stosb                                    ; 01550  0xF3, 0xAA
  ret                                          ; 01552  0xC3
  push ds                                      ; 01553  0x1E
  push es                                      ; 01554  0x06
  mov ds, [es:0x2e]                            ; 01555  0x26, 0x8E, 0x1E, 0x2E, 0x00
  mov_si_dx                                    ; 0155A  mov si, dx
  push cs                                      ; 0155C  0x0E
  mov ax, 0x1542                               ; 0155D  0xB8, 0x42, 0x15
  push ax                                      ; 01560  0x50
  sub_ax_ax                                    ; 01561  sub ax, ax
  push ax                                      ; 01563  0x50
  push ax                                      ; 01564  0x50
  mov_di_sp                                    ; 01565  mov di, sp
  push word [si + 6]                           ; 01567  0xFF, 0x74, 0x06
  push word [si + 4]                           ; 0156A  0xFF, 0x74, 0x04
  push word [si + 2]                           ; 0156D  0xFF, 0x74, 0x02
  push word [si]                               ; 01570  0xFF, 0x34
  mov si, [si + 8]                             ; 01572  0x8B, 0x74, 0x08
  push di                                      ; 01575  0x57
  inc ax                                       ; 01576  0x40
  push ax                                      ; 01577  0x50
  dec ax                                       ; 01578  0x48
  push ax                                      ; 01579  0x50
  push ax                                      ; 0157A  0x50
  mov_dx_sp                                    ; 0157B  mov dx, sp
  mov_di_dx                                    ; 0157D  mov di, dx
  mov ax, ss                                   ; 0157F  0x8C, 0xD0
  mov ds, ax                                   ; 01581  0x8E, 0xD8
  mov cx, 0x87                                 ; 01583  0xB9, 0x87, 0x00
  push si                                      ; 01586  0x56
  push di                                      ; 01587  0x57
  call rtm_dispatcher                          ; 01588  0xE8, 0x88, 0xED
  pop di                                       ; 0158B  0x5F
  pop si                                       ; 0158C  0x5E
  cmp cx, 0                                    ; 0158D  0x83, 0xF9, 0x00
  jne loc_015CB                                ; 01590  0x75, 0x39
  mov bx, [di + 2]                             ; 01592  0x8B, 0x5D, 0x02
  push ds                                      ; 01595  0x1E
  mov ds, [cs:6]                               ; 01596  0x2E, 0x8E, 0x1E, 0x06, 0x00
  test word [bx + 4], 0x20                     ; 0159B  0xF7, 0x47, 0x04, 0x20, 0x00
  pop ds                                       ; 015A0  0x1F
  je loc_015CB                                 ; 015A1  0x74, 0x28
  mov cx, 0x89                                 ; 015A3  0xB9, 0x89, 0x00
  mov_dx_di                                    ; 015A6  mov dx, di
  push si                                      ; 015A8  0x56
  call rtm_dispatcher                          ; 015A9  0xE8, 0x67, 0xED
  pop si                                       ; 015AC  0x5E
  cmp cx, 0                                    ; 015AD  0x83, 0xF9, 0x00
  jne loc_015CB                                ; 015B0  0x75, 0x19
  add sp, 0x10                                 ; 015B2  0x83, 0xC4, 0x10
  mov_dx_si                                    ; 015B5  mov dx, si
  mov ds, [es:0x2e]                            ; 015B7  0x26, 0x8E, 0x1E, 0x2E, 0x00
  mov es, [es:0x30]                            ; 015BC  0x26, 0x8E, 0x06, 0x30, 0x00
  retf                                         ; 015C1  0xCB
  mov ax, es                                   ; 015C2  0x8C, 0xC0
  pop es                                       ; 015C4  0x07
  pop ds                                       ; 015C5  0x1F
  mov [es:0x30], ax                            ; 015C6  0x26, 0xA3, 0x30, 0x00
  ret                                          ; 015CA  0xC3

loc_015CB:  ; 015CB
  add sp, 0x18                                 ; 015CB  0x83, 0xC4, 0x18
  pop es                                       ; 015CE  0x07
  pop ds                                       ; 015CF  0x1F
  mov bx, 1                                    ; 015D0  0xBB, 0x01, 0x00
  mov cx, 9                                    ; 015D3  0xB9, 0x09, 0x00
  ret                                          ; 015D6  0xC3
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 ; 015D7
  db 0x0D, 0x0A, "Concurrent CP/M-86 3.1", 0x0D, 0x0A ; 015E0
  db "Copyright (C) 1983, Digital Research", 0x0D, 0x0A ; 015F9
  db "System med 1 konsol", 0x0D, 0x0A, "$", 0x0D, 0x0A ; 01620
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00         ; 01638

