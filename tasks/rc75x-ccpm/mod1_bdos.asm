; =============================================================================
; ccpm.sys — Modul 1: BDOS File System
; Offset range: 0x01640 - 0x026C0
; =============================================================================

%include "license.inc"   ; LICENSE_NO + SERIAL til copyright-strenge

  jmp near mod1_bdos1_init                     ; 01640  0xE9, 0x48, 0x00
  jmp near mod1_bdos1_entry                    ; 01643  0xE9, 0x9A, 0x00
  cli                                          ; 01646  0xFA
  push es                                      ; 01647  0x06
  dw 0x0003                                    ; 01648  MEMIF version
  dw 0x0048                                    ; 0164A  Segment
  db 0x06                                      ; 0164C
  db "COPYRIGHT (C) 1982,1983,1984 DIGITAL RESEARCH ", LICENSE_NO, SERIAL ; 0164D

mod1_bdos1_init:  ; 0168B
  mov bx, 0x38                                 ; 0168B  0xBB, 0x38, 0x00
  mov word [bx], 0x3e2                         ; 0168E  0xC7, 0x07, 0xE2, 0x03
  mov [bx + 2], cs                             ; 01692  0x8C, 0x4F, 0x02
  mov bx, 0x3c                                 ; 01695  0xBB, 0x3C, 0x00
  mov word [bx], 0x462                         ; 01698  0xC7, 0x07, 0x62, 0x04
  mov [bx + 2], cs                             ; 0169C  0x8C, 0x4F, 0x02
  mov bx, [0x68]                               ; 0169F  0x8B, 0x1E, 0x68, 0x00
  mov word [bx + 0x28], 0x55b                  ; 016A3  0xC7, 0x47, 0x28, 0x5B, 0x05
  mov [bx + 0x2a], cs                          ; 016A8  0x8C, 0x4F, 0x2A
  retf                                         ; 016AB  0xCB

bdos1_dispatch_table:  ; 016AC
  pop si                                       ; 016AC  0x5E
  or ax, 0xb9                                  ; 016AD  0x0D, 0xB9, 0x00
  add [bx + di], cx                            ; 016B0  0x01, 0x09
  or word [bx + si], 0x95c                     ; 016B2  0x81, 0x08, 0x5C, 0x09
  mov dl, 9                                    ; 016B6  0xB2, 0x09
  add ax, 0x6b0a                               ; 016B8  0x05, 0x0A, 0x6B
  or ch, [bx + 0xa]                            ; 016BB  0x0A, 0x6F, 0x0A
  cli                                          ; 016BE  0xFA
  or_bh_dh                                     ; 016BF  or bh, dh
  or_cl_cl                                     ; 016C1  or cl, cl
  add bl, bl                                   ; 016C3  0x00, 0xDB
  add [bp + 0xd], ah                           ; 016C5  0x00, 0x66, 0x0D
  test byte [bx + si], 0xe0                    ; 016C8  0xF6, 0x00, 0xE0
  add ah, ch                                   ; 016CB  0x00, 0xEC
  add [di], dl                                 ; 016CD  0x00, 0x15
  push cs                                      ; 016CF  0x0E
  cld                                          ; 016D0  0xFC
  add [bp + di], dl                            ; 016D1  0x00, 0x13
  add [bx + si], bp                            ; 016D3  0x01, 0x28
  or ax, 0x13b                                 ; 016D5  0x0D, 0x3B, 0x01
  pop dx                                       ; 016D8  0x5A
  add [bp + si - 0x2aff], si                   ; 016D9  0x01, 0xB2, 0x01, 0xD5
  add cx, dx                                   ; 016DD  0x01, 0xD1
  db 0x01                                                         ; 016DF  .

mod1_bdos1_entry:  ; 016E0
  xor_ch_ch                                    ; 016E0  xor ch, ch
  shl cx, 1                                    ; 016E2  0xD1, 0xE1
  mov_si_cx                                    ; 016E4  mov si, cx
  call word [cs:word si + 0x6c]               ; 016E6
  retf                                         ; 016EB  0xCB

bdos1_far_call_user:  ; 016EC
  call far [cs:8]                              ; 016EC  0x2E, 0xFF, 0x1E, 0x08, 0x00
  ret                                          ; 016F1  0xC3

bdos1_userdisp_call:  ; 016F2
  mov si, 0                                    ; 016F2  0xBE, 0x00, 0x00
  call far [si + 0x28]                         ; 016F5  0xFF, 0x5C, 0x28
  ret                                          ; 016F8  0xC3

bdos1_fn01_queue_read:  ; 016F9
  mov ax, [0x68]                               ; 016F9  0xA1, 0x68, 0x00
  mov_bx_ax                                    ; 016FC  mov bx, ax
  mov [bx + 0x1A], dx                          ; 016FE  0x89, 0x57, 0x1A
  mov dx, 0x6e                                 ; 01701  0xBA, 0x6E, 0x00
  mov bl, 1                                    ; 01704  0xB3, 0x01
  jmp near bdos1_fn18_flag_wait                ; 01706  0xE9, 0x33, 0x00

bdos1_fn11_delay:  ; 01709
  mov bx, [0x68]                               ; 01709  0x8B, 0x1E, 0x68, 0x00
  mov byte [bx + 4], 2                         ; 0170D  0xC6, 0x47, 0x04, 0x02
  mov [es:0], dx                               ; 01711  0x26, 0x89, 0x16, 0x00, 0x00
  xor_bx_bx                                    ; 01716  xor bx, bx
  jmp near bdos1_cli_chk_652                           ; 01718  0xE9, 0x95, 0x03

bdos1_fn12_nop:  ; 0171B
  xor_bx_bx                                    ; 0171B  xor bx, bx
  jmp near bdos1_set_p_ready                           ; 0171D  0xE9, 0x86, 0x03

bdos1_fn15_set_priority:  ; 01720
  mov bx, [0x68]                               ; 01720  0x8B, 0x1E, 0x68, 0x00
  mov [bx + 5], dl                             ; 01724  0x88, 0x57, 0x05
  xor_bx_bx                                    ; 01727  xor bx, bx
  jmp near bdos1_set_p_ready                           ; 01729  0xE9, 0x7A, 0x03

bdos1_fn16_get_pd:  ; 0172C
  mov [es:0x30], ds                            ; 0172C  0x26, 0x8C, 0x1E, 0x30, 0x00

bdos1_func24_get_dlog:  ; 01731
  mov bx, [0x68]                               ; 01731  0x8B, 0x1E, 0x68, 0x00
  ret                                          ; 01735  0xC3

bdos1_fn14_dispatch:  ; 01736
  call bdos1_check_dx                               ; 01736  0xE8, 0x37, 0x01
  jmp near bdos1_set_p_ready                           ; 01739  0xE9, 0x6A, 0x03

bdos1_fn18_flag_wait:  ; 0173C
  mov ax, [0x68]                               ; 0173C  0xA1, 0x68, 0x00
  mov_si_ax                                    ; 0173F  mov si, ax
  mov_ax_dx                                    ; 01741  mov ax, dx
  mov [es:0], ax                               ; 01743  0x26, 0xA3, 0x00, 0x00
  mov [si + 0x2E], bl                          ; 01747  0x88, 0x5C, 0x2E
  mov byte [si + 4], 5                         ; 0174A  0xC6, 0x44, 0x04, 0x05
  xor_bx_bx                                    ; 0174E  xor bx, bx
  jmp near bdos1_cli_chk_652                           ; 01750  0xE9, 0x5D, 0x03

bdos1_fn19_flag_set:  ; 01753
  pushf                                        ; 01753  0x9C
  cli                                          ; 01754  0xFA
  mov_bx_dx                                    ; 01755  mov bx, dx
  mov si, [bx]                                 ; 01757  0x8B, 0x37
  test si, si                                  ; 01759  0x85, 0xF6
  je loc_01779                                 ; 0175B  0x74, 0x1C
  mov ax, [si]                                 ; 0175D  0x8B, 0x04
  mov [bx], ax                                 ; 0175F  0x89, 0x07
  mov di, 0x6c                                 ; 01761  0xBF, 0x6C, 0x00
  xor_ax_ax                                    ; 01764  xor ax, ax

loc_01766:  ; 01766
  cmp [di], ax                                 ; 01766  0x39, 0x05
  je loc_0176E                                 ; 01768  0x74, 0x04
  mov di, [di]                                 ; 0176A  0x8B, 0x3D
  jmp short loc_01766                          ; 0176C  0xEB, 0xF8

loc_0176E:  ; 0176E
  mov [di], si                                 ; 0176E  0x89, 0x35
  mov [si], ax                                 ; 01770  0x89, 0x04
  mov byte [si + 4], 0                         ; 01772  0xC6, 0x44, 0x04, 0x00
  call bdos1_set_p_ready                               ; 01776  0xE8, 0x2D, 0x03

loc_01779:  ; 01779
  popf                                         ; 01779  0x9D
  ret                                          ; 0177A  0xC3

bdos1_fn21_sync:  ; 0177B
  mov ax, [0x68]                               ; 0177B  0xA1, 0x68, 0x00
  mov_si_ax                                    ; 0177E  mov si, ax
  pushf                                        ; 01780  0x9C
  cli                                          ; 01781  0xFA
  xchg [bx + 2], ax                            ; 01782  0x87, 0x47, 0x02
  test ax, ax                                  ; 01785  0x85, 0xC0
  je loc_01798                                 ; 01787  0x74, 0x0F
  cmp_ax_si                                    ; 01789  cmp ax, si
  je loc_01798                                 ; 0178B  0x74, 0x0B
  mov [bx + 2], ax                             ; 0178D  0x89, 0x47, 0x02
  lea dx, [bx + 4]                             ; 01790  0x8D, 0x57, 0x04
  mov bl, 0xa                                  ; 01793  0xB3, 0x0A
  call bdos1_fn18_flag_wait                    ; 01795  0xE8, 0xA4, 0xFF

loc_01798:  ; 01798
  popf                                         ; 01798  0x9D
  ret                                          ; 01799  0xC3

bdos1_fn22_unsync:  ; 0179A
  mov ax, [0x68]                               ; 0179A  0xA1, 0x68, 0x00
  cmp ax, [bx + 2]                             ; 0179D  0x3B, 0x47, 0x02
  jne loc_017D2                                ; 017A0  0x75, 0x30
  xor_ax_ax                                    ; 017A2  xor ax, ax
  pushf                                        ; 017A4  0x9C
  cli                                          ; 017A5  0xFA
  xchg [bx + 6], ax                            ; 017A6  0x87, 0x47, 0x06
  test ax, ax                                  ; 017A9  0x85, 0xC0
  je loc_017B1                                 ; 017AB  0x74, 0x04
  mov_si_ax                                    ; 017AD  mov si, ax
  jmp short loc_017C1                          ; 017AF  0xEB, 0x10

loc_017B1:  ; 017B1
  mov si, [bx + 4]                             ; 017B1  0x8B, 0x77, 0x04
  test si, si                                  ; 017B4  0x85, 0xF6
  je loc_017CE                                 ; 017B6  0x74, 0x16
  mov ax, [si]                                 ; 017B8  0x8B, 0x04
  mov [bx + 4], ax                             ; 017BA  0x89, 0x47, 0x04
  mov word [si], 0                             ; 017BD  0xC7, 0x04, 0x00, 0x00

loc_017C1:  ; 017C1
  mov byte [si + 4], 0                         ; 017C1  0xC6, 0x44, 0x04, 0x00
  mov ax, [0x6c]                               ; 017C5  0xA1, 0x6C, 0x00
  mov [si], ax                                 ; 017C8  0x89, 0x04
  mov [0x6c], si                               ; 017CA  0x89, 0x36, 0x6C, 0x00

loc_017CE:  ; 017CE
  mov [bx + 2], si                             ; 017CE  0x89, 0x77, 0x02
  popf                                         ; 017D1  0x9D

loc_017D2:  ; 017D2
  ret                                          ; 017D2  0xC3

loc_017D3:  ; 017D3
  mov ax, [0x68]                               ; 017D3  0xA1, 0x68, 0x00
  cmp [bx + 2], ax                             ; 017D6  0x39, 0x47, 0x02
  jne loc_017F1                                ; 017D9  0x75, 0x16
  mov_si_dx                                    ; 017DB  mov si, dx
  pushf                                        ; 017DD  0x9C
  cli                                          ; 017DE  0xFA
  mov di, [si]                                 ; 017DF  0x8B, 0x3C
  test di, di                                  ; 017E1  0x85, 0xFF
  je loc_017F0                                 ; 017E3  0x74, 0x0B
  mov ax, [di]                                 ; 017E5  0x8B, 0x05
  mov [si], ax                                 ; 017E7  0x89, 0x04
  mov word [di], 0                             ; 017E9  0xC7, 0x05, 0x00, 0x00
  mov [bx + 6], di                             ; 017ED  0x89, 0x7F, 0x06

loc_017F0:  ; 017F0
  popf                                         ; 017F0  0x9D

loc_017F1:  ; 017F1
  ret                                          ; 017F1  0xC3

bdos1_fn23_poll_device:  ; 017F2
  mov ax, [0x68]                               ; 017F2  0xA1, 0x68, 0x00
  mov_si_ax                                    ; 017F5  mov si, ax

loc_017F7:  ; 017F7
  cmp byte [si + 0x19], 0                      ; 017F7  0x80, 0x7C, 0x19, 0x00
  jne loc_01808                                ; 017FB  0x75, 0x0B
  test word [si + 6], 0x200                    ; 017FD  0xF7, 0x44, 0x06, 0x00, 0x02
  je loc_01808                                 ; 01802  0x74, 0x04
  or byte [si + 0x19], 0x80                    ; 01804  0x80, 0x4C, 0x19, 0x80

loc_01808:  ; 01808
  or word [si + 6], 0x200                      ; 01808  0x81, 0x4C, 0x06, 0x00, 0x02
  inc byte [si + 0x19]                         ; 0180D  0xFE, 0x44, 0x19
  ret                                          ; 01810  0xC3

bdos1_fn25_chain:  ; 01811
  mov_si_dx                                    ; 01811  mov si, dx
  jmp short loc_017F7                          ; 01813  0xEB, 0xE2

bdos1_fn24_test_device:  ; 01815
  mov ax, [0x68]                               ; 01815  0xA1, 0x68, 0x00
  mov_si_ax                                    ; 01818  mov si, ax
  mov al, [si + 0x19]                          ; 0181A  0x8A, 0x44, 0x19
  and al, 0x7f                                 ; 0181D  0x24, 0x7F
  dec al                                       ; 0181F  0xFE, 0xC8
  je loc_01827                                 ; 01821  0x74, 0x04
  dec byte [si + 0x19]                         ; 01823  0xFE, 0x4C, 0x19
  ret                                          ; 01826  0xC3

loc_01827:  ; 01827
  and byte [si + 0x19], 0x80                   ; 01827  0x80, 0x64, 0x19, 0x80
  jne loc_01841                                ; 0182B  0x75, 0x14
  and word [si + 6], 0xfdff                    ; 0182D  0x81, 0x64, 0x06, 0xFF, 0xFD
  test word [si + 6], 0x80                     ; 01832  0xF7, 0x44, 0x06, 0x80, 0x00
  je loc_01841                                 ; 01837  0x74, 0x08
  mov dx, 0xffff                               ; 01839  0xBA, 0xFF, 0xFF
  push si                                      ; 0183C  0x56
  call bdos1_fn13_seldisk                      ; 0183D  0xE8, 0x66, 0x0B
  pop si                                       ; 01840  0x5E

loc_01841:  ; 01841
  mov byte [si + 0x19], 0                      ; 01841  0xC6, 0x44, 0x19, 0x00
  ret                                          ; 01845  0xC3

bdos1_set_di_70:  ; 01846
  mov di, 0x70                                 ; 01846  0xBF, 0x70, 0x00

loc_01849:  ; 01849
  mov bx, [di + 2]                             ; 01849  0x8B, 0x5D, 0x02
  cmp_bx_si                                    ; 0184C  cmp bx, si
  je loc_01854                                 ; 0184E  0x74, 0x04
  mov_di_bx                                    ; 01850  mov di, bx
  jmp short loc_01849                          ; 01852  0xEB, 0xF5

loc_01854:  ; 01854
  mov ax, [si + 2]                             ; 01854  0x8B, 0x44, 0x02
  mov [di + 2], ax                             ; 01857  0x89, 0x45, 0x02
  mov ax, [si + 6]                             ; 0185A  0x8B, 0x44, 0x06
  and ax, strict word 0x10                    ; 0185D  25 10 00
  cmp ax, strict word 0                       ; 01860  3D 00 00
  je loc_0186F                                 ; 01863  0x74, 0x0A
  mov bx, [0x5c]                               ; 01865  0x8B, 0x1E, 0x5C, 0x00
  mov [si], bx                                 ; 01869  0x89, 0x1C
  mov [0x5c], si                               ; 0186B  0x89, 0x36, 0x5C, 0x00

loc_0186F:  ; 0186F
  ret                                          ; 0186F  0xC3

bdos1_check_dx:  ; 01870
  cmp dx, 0                                    ; 01870  0x83, 0xFA, 0x00
  jne loc_01878                                ; 01873  0x75, 0x03
  sub_bx_bx                                    ; 01875  sub bx, bx
  ret                                          ; 01877  0xC3

loc_01878:  ; 01878
  call bdos1_get_abs_para_30                               ; 01878  0xE8, 0x5D, 0x01
  jcxz loc_01881                               ; 0187B  0xE3, 0x04
  mov bx, 0xffff                               ; 0187D  0xBB, 0xFF, 0xFF
  ret                                          ; 01880  0xC3

loc_01881:  ; 01881
  mov dx, [si]                                 ; 01881  0x8B, 0x14
  push dx                                      ; 01883  0x52
  push si                                      ; 01884  0x56
  mov bx, [0x68]                               ; 01885  0x8B, 0x1E, 0x68, 0x00
  mov [si + 0x1E], bx                          ; 01889  0x89, 0x5C, 0x1E
  mov word [si + 0x22], 0                      ; 0188C  0xC7, 0x44, 0x22, 0x00, 0x00
  mov byte [si + 0x19], 0                      ; 01891  0xC6, 0x44, 0x19, 0x00
  and word [bx + 6], 0xf7df                    ; 01895  0x81, 0x67, 0x06, 0xDF, 0xF7
  mov al, [si + 0x24]                          ; 0189A  0x8A, 0x44, 0x24
  mov [si + 0x24], al                          ; 0189D  0x88, 0x44, 0x24
  mov word [si + 0x28], 0x55b                  ; 018A0  0xC7, 0x44, 0x28, 0x5B, 0x05
  mov [si + 0x2a], cs                          ; 018A5  0x8C, 0x4C, 0x2A
  cmp word [bx + 0x16], 0                      ; 018A8  0x83, 0x7F, 0x16, 0x00
  je loc_018D8                                 ; 018AC  0x74, 0x2A
  cmp word [si + 0x16], 0                      ; 018AE  0x83, 0x7C, 0x16, 0x00
  jne loc_018D8                                ; 018B2  0x75, 0x24
  lea di, [bx + 0x16]                          ; 018B4  0x8D, 0x7F, 0x16

loc_018B7:  ; 018B7
  mov di, [di]                                 ; 018B7  0x8B, 0x3D
  cmp di, 0                                    ; 018B9  0x83, 0xFF, 0x00
  je loc_018D8                                 ; 018BC  0x74, 0x1A
  push di                                      ; 018BE  0x57
  push word [di + 2]                           ; 018BF  0xFF, 0x75, 0x02
  push si                                      ; 018C2  0x56
  push bx                                      ; 018C3  0x53
  mov cx, 0x308                                ; 018C4  0xB9, 0x08, 0x03
  mov_dx_sp                                    ; 018C7  mov dx, sp
  push ds                                      ; 018C9  0x1E
  mov ax, ss                                   ; 018CA  0x8C, 0xD0
  mov ds, ax                                   ; 018CC  0x8E, 0xD8
  call bdos1_far_call_user                               ; 018CE  0xE8, 0x1B, 0xFE
  pop ds                                       ; 018D1  0x1F
  pop bx                                       ; 018D2  0x5B
  pop si                                       ; 018D3  0x5E
  pop ax                                       ; 018D4  0x58
  pop di                                       ; 018D5  0x5F
  jmp short loc_018B7                          ; 018D6  0xEB, 0xDF

loc_018D8:  ; 018D8
  mov ax, [es:0x2e]                            ; 018D8  0x26, 0xA1, 0x2E, 0x00
  mov dx, [si + 0x10]                          ; 018DC  0x8B, 0x54, 0x10
  add_dx_ax                                    ; 018DF  add dx, ax
  mov [si + 0x10], dx                          ; 018E1  0x89, 0x54, 0x10
  push es                                      ; 018E4  0x06
  push ds                                      ; 018E5  0x1E
  mov cx, es                                   ; 018E6  0x8C, 0xC1
  mov es, dx                                   ; 018E8  0x8E, 0xC2
  mov ds, cx                                   ; 018EA  0x8E, 0xD9
  mov si, 0x12                                 ; 018EC  0xBE, 0x12, 0x00
  mov_di_si                                    ; 018EF  mov di, si
  mov cx, 4                                    ; 018F1  0xB9, 0x04, 0x00
  rep movsw                                    ; 018F4  0xF3, 0xA5
  mov ds, dx                                   ; 018F6  0x8E, 0xDA
  xor_dx_dx                                    ; 018F8  xor dx, dx
  cmp [0x50], dx                               ; 018FA  0x39, 0x16, 0x50, 0x00
  jne loc_01903                                ; 018FE  0x75, 0x03
  mov [0x50], ax                               ; 01900  0xA3, 0x50, 0x00

loc_01903:  ; 01903
  cmp [0x52], dx                               ; 01903  0x39, 0x16, 0x52, 0x00
  jne loc_0190C                                ; 01907  0x75, 0x03
  mov [0x52], ax                               ; 01909  0xA3, 0x52, 0x00

loc_0190C:  ; 0190C
  cmp [0x56], dx                               ; 0190C  0x39, 0x16, 0x56, 0x00
  jne loc_01915                                ; 01910  0x75, 0x03
  mov [0x56], ax                               ; 01912  0xA3, 0x56, 0x00

loc_01915:  ; 01915
  cmp [0x54], dx                               ; 01915  0x39, 0x16, 0x54, 0x00
  jne loc_0191E                                ; 01919  0x75, 0x03
  mov [0x54], ax                               ; 0191B  0xA3, 0x54, 0x00

loc_0191E:  ; 0191E
  mov ds, dx                                   ; 0191E  0x8E, 0xDA
  mov_si_dx                                    ; 01920  mov si, dx
  mov di, 0x38                                 ; 01922  0xBF, 0x38, 0x00
  call bdos1_copy_fcb_words                               ; 01925  0xE8, 0x98, 0x00
  call bdos1_copy_fcb_words                               ; 01928  0xE8, 0x95, 0x00
  add si, 4                                    ; 0192B  0x83, 0xC6, 0x04
  add di, 4                                    ; 0192E  0x83, 0xC7, 0x04
  call bdos1_copy_fcb_words                               ; 01931  0xE8, 0x8C, 0x00
  call bdos1_copy_fcb_words                               ; 01934  0xE8, 0x89, 0x00
  mov si, 0x380                                ; 01937  0xBE, 0x80, 0x03
  mov di, 0x58                                 ; 0193A  0xBF, 0x58, 0x00
  call bdos1_copy_fcb_words                               ; 0193D  0xE8, 0x80, 0x00
  call bdos1_copy_fcb_words                               ; 01940  0xE8, 0x7D, 0x00
  push es                                      ; 01943  0x06
  pop ds                                       ; 01944  0x1F
  mov ax, [0x56]                               ; 01945  0xA1, 0x56, 0x00
  mov [0x1e], ax                               ; 01948  0xA3, 0x1E, 0x00
  mov ax, [0x34]                               ; 0194B  0xA1, 0x34, 0x00
  mov [0x1c], ax                               ; 0194E  0xA3, 0x1C, 0x00
  xor_dx_dx                                    ; 01951  xor dx, dx
  mov byte [0x66], 0x24                        ; 01953  0xC6, 0x06, 0x66, 0x00, 0x24
  mov [0x10], dl                               ; 01958  0x88, 0x16, 0x10, 0x00
  mov [0x1a], dl                               ; 0195C  0x88, 0x16, 0x1A, 0x00
  mov byte [0x11], 1                           ; 01960  0xC6, 0x06, 0x11, 0x00, 0x01
  mov byte [0x1b], 0xff                        ; 01965  0xC6, 0x06, 0x1B, 0x00, 0xFF
  mov bx, [0x52]                               ; 0196A  0x8B, 0x1E, 0x52, 0x00
  mov [0x32], bx                               ; 0196E  0x89, 0x1E, 0x32, 0x00
  mov [4], bx                                  ; 01972  0x89, 0x1E, 0x04, 0x00
  mov ax, [0x54]                               ; 01976  0xA1, 0x54, 0x00
  mov [0x4c], ax                               ; 01979  0xA3, 0x4C, 0x00
  mov [0], dx                                  ; 0197C  0x89, 0x16, 0x00, 0x00
  mov [0x4e], dx                               ; 01980  0x89, 0x16, 0x4E, 0x00
  mov [0x62], dx                               ; 01984  0x89, 0x16, 0x62, 0x00
  mov [0x64], dx                               ; 01988  0x89, 0x16, 0x64, 0x00
  mov ds, [0x1e]                               ; 0198C  0x8E, 0x1E, 0x1E, 0x00
  mov di, [es:0x1c]                            ; 01990  0x26, 0x8B, 0x3E, 0x1C, 0x00
  mov ax, [es:0x50]                            ; 01995  0x26, 0xA1, 0x50, 0x00
  mov [di + 2], ax                             ; 01999  0x89, 0x45, 0x02
  mov word [di + 4], 0x200                     ; 0199C  0xC7, 0x45, 0x04, 0x00, 0x02
  pop ds                                       ; 019A1  0x1F
  pop es                                       ; 019A2  0x07
  pop si                                       ; 019A3  0x5E
  pushf                                        ; 019A4  0x9C
  cli                                          ; 019A5  0xFA
  mov dx, [0x72]                               ; 019A6  0x8B, 0x16, 0x72, 0x00
  mov [si + 2], dx                             ; 019AA  0x89, 0x54, 0x02
  mov [0x72], si                               ; 019AD  0x89, 0x36, 0x72, 0x00
  mov dx, [0x6c]                               ; 019B1  0x8B, 0x16, 0x6C, 0x00
  mov [si], dx                                 ; 019B5  0x89, 0x14
  mov [0x6c], si                               ; 019B7  0x89, 0x36, 0x6C, 0x00
  popf                                         ; 019BB  0x9D
  pop dx                                       ; 019BC  0x5A
  jmp near bdos1_check_dx                           ; 019BD  0xE9, 0xB0, 0xFE

bdos1_copy_fcb_words:  ; 019C0
  cmp [es:di], dx                              ; 019C0  0x26, 0x39, 0x15
  jne loc_019D1                                ; 019C3  0x75, 0x0C
  cmp [es:di + 2], dx                          ; 019C5  0x26, 0x39, 0x55, 0x02
  jne loc_019D1                                ; 019C9  0x75, 0x06
  mov cx, 2                                    ; 019CB  0xB9, 0x02, 0x00
  rep movsw                                    ; 019CE  0xF3, 0xA5
  ret                                          ; 019D0  0xC3

loc_019D1:  ; 019D1
  add si, 4                                    ; 019D1  0x83, 0xC6, 0x04
  add di, 4                                    ; 019D4  0x83, 0xC7, 0x04
  ret                                          ; 019D7  0xC3

bdos1_get_abs_para_30:  ; 019D8
  push dx                                      ; 019D8  0x52
  mov bx, 0x30                                 ; 019D9  0xBB, 0x30, 0x00
  call bdos1_calc_abs_para                               ; 019DC  0xE8, 0xF3, 0x08
  jcxz loc_019F2                               ; 019DF  0xE3, 0x11
  mov ax, [es:0x2e]                            ; 019E1  0x26, 0xA1, 0x2E, 0x00
  mov bx, ds                                   ; 019E5  0x8C, 0xDB
  sub_ax_bx                                    ; 019E7  sub ax, bx
  mov cl, 4                                    ; 019E9  0xB1, 0x04
  shl ax, cl                                   ; 019EB  0xD3, 0xE0
  pop si                                       ; 019ED  0x5E
  add_si_ax                                    ; 019EE  add si, ax
  jmp short loc_01A1F                          ; 019F0  0xEB, 0x2D

loc_019F2:  ; 019F2
  pop si                                       ; 019F2  0x5E
  pushf                                        ; 019F3  0x9C
  cli                                          ; 019F4  0xFA
  mov di, [0x5c]                               ; 019F5  0x8B, 0x3E, 0x5C, 0x00
  test di, di                                  ; 019F9  0x85, 0xFF
  jne loc_01A02                                ; 019FB  0x75, 0x05
  mov cx, 0xc                                  ; 019FD  0xB9, 0x0C, 0x00
  popf                                         ; 01A00  0x9D
  ret                                          ; 01A01  0xC3

loc_01A02:  ; 01A02
  mov ax, [di]                                 ; 01A02  0x8B, 0x05
  mov [0x5c], ax                               ; 01A04  0xA3, 0x5C, 0x00
  popf                                         ; 01A07  0x9D
  push di                                      ; 01A08  0x57
  push es                                      ; 01A09  0x06
  push ds                                      ; 01A0A  0x1E
  mov ds, [es:0x2e]                            ; 01A0B  0x26, 0x8E, 0x1E, 0x2E, 0x00
  pop es                                       ; 01A10  0x07
  mov cx, 0x18                                 ; 01A11  0xB9, 0x18, 0x00
  rep movsw                                    ; 01A14  0xF3, 0xA5
  push es                                      ; 01A16  0x06
  pop ds                                       ; 01A17  0x1F
  pop es                                       ; 01A18  0x07
  pop si                                       ; 01A19  0x5E
  or word [si + 6], strict word 0x10          ; 01A1A  81 4C 06 10 00

loc_01A1F:  ; 01A1F
  xor_cx_cx                                   ; 01A1F  xor cx, cx
  ret                                          ; 01A21  0xC3
  cli                                          ; 01A22  0xFA
  push ds                                      ; 01A23  0x1E
  mov ds, [cs:6]                               ; 01A24  0x2E, 0x8E, 0x1E, 0x06, 0x00
  cmp byte [0x652], 0xff                       ; 01A29  0x80, 0x3E, 0x52, 0x06, 0xFF
  je loc_01AA0                                 ; 01A2E  0x74, 0x70
  mov [0x658], ax                              ; 01A30  0xA3, 0x58, 0x06
  mov al, 0xff                                 ; 01A33  0xB0, 0xFF
  mov [0x652], al                              ; 01A35  0xA2, 0x52, 0x06
  mov ax, es                                   ; 01A38  0x8C, 0xC0
  mov [0x654], ax                              ; 01A3A  0xA3, 0x54, 0x06
  mov ax, [0x68]                               ; 01A3D  0xA1, 0x68, 0x00
  xchg bx, ax                                  ; 01A40  0x93
  mov [0x656], ax                              ; 01A41  0xA3, 0x56, 0x06
  mov es, [bx + 0x10]                          ; 01A44  0x8E, 0x47, 0x10
  mov al, 0xff                                 ; 01A47  0xB0, 0xFF
  mov [es:0x1b], al                            ; 01A49  0x26, 0xA2, 0x1B, 0x00
  pop ax                                       ; 01A4D  0x58
  mov [es:0x32], ax                            ; 01A4E  0x26, 0xA3, 0x32, 0x00
  mov al, [bx + 4]                             ; 01A52  0x8A, 0x47, 0x04
  mov [es:0x61], al                            ; 01A55  0x26, 0xA2, 0x61, 0x00
  mov byte [bx + 4], 0                         ; 01A59  0xC6, 0x47, 0x04, 0x00
  mov ax, [0x654]                              ; 01A5D  0xA1, 0x54, 0x06
  mov [es:0x4c], ax                            ; 01A60  0x26, 0xA3, 0x4C, 0x00
  jmp near loc_01ACE                           ; 01A64  0xE9, 0x67, 0x00

loc_01A67:  ; 01A67
  mov [0x658], ax                              ; 01A67  0xA3, 0x58, 0x06
  mov_ax_bx                                    ; 01A6A  mov ax, bx
  mov [0x656], ax                              ; 01A6C  0xA3, 0x56, 0x06
  cmp word [0x6c], 0                           ; 01A6F  0x83, 0x3E, 0x6C, 0x00, 0x00
  jne loc_01ACE                                ; 01A74  0x75, 0x58
  mov al, 0                                    ; 01A76  0xB0, 0x00
  mov [es:0x1b], al                            ; 01A78  0x26, 0xA2, 0x1B, 0x00
  mov ax, [0x68]                               ; 01A7C  0xA1, 0x68, 0x00
  mov_bx_ax                                    ; 01A7F  mov bx, ax
  mov al, [es:0x61]                            ; 01A81  0x26, 0xA0, 0x61, 0x00
  mov [bx + 4], al                             ; 01A85  0x88, 0x47, 0x04
  mov ax, [0x656]                              ; 01A88  0xA1, 0x56, 0x06
  mov_bx_ax                                    ; 01A8B  mov bx, ax
  mov ax, [0x658]                              ; 01A8D  0xA1, 0x58, 0x06
  mov byte [0x652], 0                          ; 01A90  0xC6, 0x06, 0x52, 0x06, 0x00
  mov ds, [es:0x32]                            ; 01A95  0x26, 0x8E, 0x1E, 0x32, 0x00
  mov es, [es:0x4c]                            ; 01A9A  0x26, 0x8E, 0x06, 0x4C, 0x00
  iret                                         ; 01A9F  0xCF

loc_01AA0:  ; 01AA0
  pop ds                                       ; 01AA0  0x1F
  iret                                         ; 01AA1  0xCF
  call bdos1_set_p_ready                               ; 01AA2  0xE8, 0x01, 0x00
  retf                                         ; 01AA5  0xCB

bdos1_set_p_ready:  ; 01AA6
  push bx                                      ; 01AA6  0x53
  mov bx, [0x68]                               ; 01AA7  0x8B, 0x1E, 0x68, 0x00
  mov byte [bx + 4], 0                         ; 01AAB  0xC6, 0x47, 0x04, 0x00
  pop bx                                       ; 01AAF  0x5B

bdos1_cli_chk_652:  ; 01AB0
  pushf                                        ; 01AB0  0x9C
  cli                                          ; 01AB1  0xFA
  cmp byte [0x652], 0xff                       ; 01AB2  0x80, 0x3E, 0x52, 0x06, 0xFF
  jne loc_01ABB                                ; 01AB7  0x75, 0x02
  popf                                         ; 01AB9  0x9D
  ret                                          ; 01ABA  0xC3

loc_01ABB:  ; 01ABB
  mov byte [0x652], 0xff                       ; 01ABB  0xC6, 0x06, 0x52, 0x06, 0xFF
  pop word [es:0x4e]                           ; 01AC0  0x26, 0x8F, 0x06, 0x4E, 0x00
  mov [0x658], ax                              ; 01AC5  0xA3, 0x58, 0x06
  mov_ax_bx                                    ; 01AC8  mov ax, bx
  mov [0x656], bx                              ; 01ACA  0x89, 0x1E, 0x56, 0x06

loc_01ACE:  ; 01ACE
  cmp word [0x6e], 0                           ; 01ACE  0x83, 0x3E, 0x6E, 0x00, 0x00
  jne bdos1_switch_stack                       ; 01AD3  0x75, 0x2C
  cmp word [0x6c], 0                           ; 01AD5  0x83, 0x3E, 0x6C, 0x00, 0x00
  jne bdos1_switch_stack                       ; 01ADA  0x75, 0x25
  mov ax, [0x68]                               ; 01ADC  0xA1, 0x68, 0x00
  mov_bx_ax                                    ; 01ADF  mov bx, ax
  cmp byte [bx + 4], 0                         ; 01AE1  0x80, 0x7F, 0x04, 0x00
  jne bdos1_switch_stack                       ; 01AE5  0x75, 0x1A
  cmp word [bx], 0                             ; 01AE7  0x83, 0x3F, 0x00
  je loc_01AF6                                 ; 01AEA  0x74, 0x0A
  mov al, [bx + 5]                             ; 01AEC  0x8A, 0x47, 0x05
  mov bx, [bx]                                 ; 01AEF  0x8B, 0x1F
  cmp al, [bx + 5]                             ; 01AF1  0x3A, 0x47, 0x05
  je bdos1_switch_stack                        ; 01AF4  0x74, 0x0B

loc_01AF6:  ; 01AF6
  mov ax, [0x656]                              ; 01AF6  0xA1, 0x56, 0x06
  mov_bx_ax                                    ; 01AF9  mov bx, ax
  mov ax, [0x658]                              ; 01AFB  0xA1, 0x58, 0x06
  jmp near loc_01E9F                           ; 01AFE  0xE9, 0x9E, 0x03

bdos1_switch_stack:  ; 01B01
  mov [es:0x1e], ss                            ; 01B01  0x26, 0x8C, 0x16, 0x1E, 0x00
  mov [es:0x1c], sp                            ; 01B06  0x26, 0x89, 0x26, 0x1C, 0x00
  mov ss, [cs:6]                               ; 01B0B  0x2E, 0x8E, 0x16, 0x06, 0x00
  mov sp, 0x652                                ; 01B10  0xBC, 0x52, 0x06
  mov ax, [0x656]                              ; 01B13  0xA1, 0x56, 0x06
  mov_bx_ax                                    ; 01B16  mov bx, ax
  mov ax, [0x658]                              ; 01B18  0xA1, 0x58, 0x06
  sti                                          ; 01B1B  0xFB
  cld                                          ; 01B1C  0xFC
  push es                                      ; 01B1D  0x06
  pop ds                                       ; 01B1E  0x1F
  mov [0x20], ax                               ; 01B1F  0xA3, 0x20, 0x00
  mov_ax_bx                                    ; 01B22  mov ax, bx
  mov [0x22], ax                               ; 01B24  0xA3, 0x22, 0x00
  mov_ax_cx                                    ; 01B27  mov ax, cx
  mov [0x24], ax                               ; 01B29  0xA3, 0x24, 0x00
  mov_ax_dx                                    ; 01B2C  mov ax, dx
  mov [0x26], ax                               ; 01B2E  0xA3, 0x26, 0x00
  mov_ax_di                                    ; 01B31  mov ax, di
  mov [0x28], ax                               ; 01B33  0xA3, 0x28, 0x00
  mov_ax_si                                    ; 01B36  mov ax, si
  mov [0x2a], ax                               ; 01B38  0xA3, 0x2A, 0x00
  mov_ax_bp                                    ; 01B3B  mov ax, bp
  mov [0x2c], ax                               ; 01B3D  0xA3, 0x2C, 0x00
  xor_bx_bx                                    ; 01B40  xor bx, bx
  mov ds, bx                                   ; 01B42  0x8E, 0xDB
  mov_si_bx                                    ; 01B44  mov si, bx
  mov di, 0x38                                 ; 01B46  0xBF, 0x38, 0x00
  mov dx, 4                                    ; 01B49  0xBA, 0x04, 0x00
  mov_cx_dx                                    ; 01B4C  mov cx, dx
  rep movsw                                    ; 01B4E  0xF3, 0xA5
  mov_cx_dx                                    ; 01B50  mov cx, dx
  add_si_dx                                    ; 01B52  add si, dx
  add_di_dx                                    ; 01B54  add di, dx
  rep movsw                                    ; 01B56  0xF3, 0xA5
  mov si, 0x380                                ; 01B58  0xBE, 0x80, 0x03
  mov di, 0x58                                 ; 01B5B  0xBF, 0x58, 0x00
  mov_cx_dx                                    ; 01B5E  mov cx, dx
  rep movsw                                    ; 01B60  0xF3, 0xA5
  mov ds, [cs:6]                               ; 01B62  0x2E, 0x8E, 0x1E, 0x06, 0x00
  mov bx, [0x68]                               ; 01B67  0x8B, 0x1E, 0x68, 0x00
  test word [bx + 0x26], 2                     ; 01B6B  0xF7, 0x47, 0x26, 0x02, 0x00
  je loc_01B8F                                 ; 01B70  0x74, 0x1D
  push es                                      ; 01B72  0x06
  mov ax, ds                                   ; 01B73  0x8C, 0xD8
  push cx                                      ; 01B75  0x51
  push di                                      ; 01B76  0x57
  mov cx, 0                                    ; 01B77  0xB9, 0x00, 0x00
  mov si, 0x200                                ; 01B7A  0xBE, 0x00, 0x02
  mov di, 0x100                                ; 01B7D  0xBF, 0x00, 0x01
  mov es, [bx + 0x10]                          ; 01B80  0x8E, 0x47, 0x10
  mov ds, cx                                   ; 01B83  0x8E, 0xD9
  mov cx, 0x1a                                 ; 01B85  0xB9, 0x1A, 0x00
  rep movsw                                    ; 01B88  0xF3, 0xA5
  pop di                                       ; 01B8A  0x5F
  pop cx                                       ; 01B8B  0x59
  pop es                                       ; 01B8C  0x07
  mov ds, ax                                   ; 01B8D  0x8E, 0xD8

loc_01B8F:  ; 01B8F
  mov si, [0x68]                               ; 01B8F  0x8B, 0x36, 0x68, 0x00
  mov ax, 0                                    ; 01B93  0xB8, 0x00, 0x00
  call far [si + 0x28]                         ; 01B96  0xFF, 0x5C, 0x28
  jmp short loc_01B9C                          ; 01B99  0xEB, 0x01
  retf                                         ; 01B9B  0xCB

loc_01B9C:  ; 01B9C
  nop                                          ; 01B9C  0x90
  mov ax, [0x68]                               ; 01B9D  0xA1, 0x68, 0x00
  mov_si_ax                                    ; 01BA0  mov si, ax
  mov ax, [si]                                 ; 01BA2  0x8B, 0x04
  mov [0x68], ax                               ; 01BA4  0xA3, 0x68, 0x00
  mov word [si], 0                             ; 01BA7  0xC7, 0x04, 0x00, 0x00
  xor_bh_bh                                    ; 01BAB  xor bh, bh
  mov bl, [si + 4]                             ; 01BAD  0x8A, 0x5C, 0x04
  shl bx, 1                                    ; 01BB0  0xD1, 0xE3
  jmp word [cs:bx + 0x578]                     ; 01BB2  0x2E, 0xFF, 0xA7, 0x78, 0x05
  db 0x00                                                         ; 01BB7  .
  push_es                                      ; 01BB8  push es
  push_es                                      ; 01BBA  push es
  cmpsw                                        ; 01BBC  0xA7
  add ax, 0x665                                ; 01BBD  0x05, 0x65, 0x06
  inc byte [di]                                ; 01BC0  0xFE, 0x05
  mov es, [di]                                 ; 01BC2  0x8E, 0x05
  push_es                                      ; 01BC4  push es
  push_es                                      ; 01BC6  push es
  loop $+7                                     ; 01BC8  loop 0x1bcf
  push_es                                      ; 01BCA  push es
  push_es                                      ; 01BCC  push es
  mov ax, [es:0]                               ; 01BCE  0x26, 0xA1, 0x00, 0x00
  mov_bx_ax                                    ; 01BD2  mov bx, ax
  push si                                      ; 01BD4  0x56
  call bdos1_check_attr_20                               ; 01BD5  0xE8, 0xDA, 0x00
  pop si                                       ; 01BD8  0x5E
  or word [si + 6], strict word 0x20          ; 01BD9  81 4C 06 20 00
  mov al, [si + 0x2E]                          ; 01BDE  0x8A, 0x44, 0x2E
  mov [si + 4], al                             ; 01BE1  0x88, 0x44, 0x04
  jmp near loc_01CDE                           ; 01BE4  0xE9, 0xF7, 0x00
  cli                                          ; 01BE7  0xFA
  mov byte [0xc0c], 0xff                       ; 01BE8  0xC6, 0x06, 0x0C, 0x0C, 0xFF
  mov bx, 0x6a                                 ; 01BED  0xBB, 0x6A, 0x00
  mov cx, [es:0]                               ; 01BF0  0x26, 0x8B, 0x0E, 0x00, 0x00
  inc cx                                       ; 01BF5  0x41
  cmp cx, 0                                    ; 01BF6  0x83, 0xF9, 0x00
  jne loc_01BFC                                ; 01BF9  0x75, 0x01
  dec cx                                       ; 01BFB  0x49

loc_01BFC:  ; 01BFC
  mov di, [bx]                                 ; 01BFC  0x8B, 0x3F
  cmp di, 0                                    ; 01BFE  0x83, 0xFF, 0x00
  je loc_01C10                                 ; 01C01  0x74, 0x0D
  mov ax, [di + 0x1A]                          ; 01C03  0x8B, 0x45, 0x1A
  cmp_ax_cx                                    ; 01C06  cmp ax, cx
  ja loc_01C10                                 ; 01C08  0x77, 0x06
  sub_cx_ax                                    ; 01C0A  sub cx, ax
  mov_bx_di                                    ; 01C0C  mov bx, di
  jmp short loc_01BFC                          ; 01C0E  0xEB, 0xEC

loc_01C10:  ; 01C10
  mov [si], di                                 ; 01C10  0x89, 0x3C
  mov [bx], si                                 ; 01C12  0x89, 0x37
  mov [si + 0x1A], cx                          ; 01C14  0x89, 0x4C, 0x1A
  cmp di, 0                                    ; 01C17  0x83, 0xFF, 0x00
  je loc_01C1F                                 ; 01C1A  0x74, 0x03
  sub [di + 0x1A], cx                          ; 01C1C  0x29, 0x4D, 0x1A

loc_01C1F:  ; 01C1F
  jmp near loc_01CDE                           ; 01C1F  0xE9, 0xBC, 0x00
  mov ax, [es:0]                               ; 01C22  0x26, 0xA1, 0x00, 0x00
  mov_bx_ax                                    ; 01C26  mov bx, ax
  cli                                          ; 01C28  0xFA
  cmp word [bx], -2                            ; 01C29  0x83, 0x3F, 0xFE
  je loc_01C37                                 ; 01C2C  0x74, 0x09
  mov [bx], si                                 ; 01C2E  0x89, 0x37
  mov word [si], 0                             ; 01C30  0xC7, 0x04, 0x00, 0x00
  jmp near loc_01CDE                           ; 01C34  0xE9, 0xA7, 0x00

loc_01C37:  ; 01C37
  mov word [bx], 0xffff                        ; 01C37  0xC7, 0x07, 0xFF, 0xFF
  sti                                          ; 01C3B  0xFB
  jmp short loc_01CA5                          ; 01C3C  0xEB, 0x67
  mov ax, [0x68]                               ; 01C3E  0xA1, 0x68, 0x00
  mov [si], ax                                 ; 01C41  0x89, 0x04
  mov [0x68], si                               ; 01C43  0x89, 0x36, 0x68, 0x00
  mov cx, 0x417                                ; 01C47  0xB9, 0x17, 0x04
  call bdos1_far_call_user                               ; 01C4A  0xE8, 0x9F, 0xFA

loc_01C4D:  ; 01C4D
  mov ax, [0x68]                               ; 01C4D  0xA1, 0x68, 0x00
  mov_si_ax                                    ; 01C50  mov si, ax
  mov si, [si + 0x16]                          ; 01C52  0x8B, 0x74, 0x16
  test si, si                                  ; 01C55  0x85, 0xF6
  je loc_01C71                                 ; 01C57  0x74, 0x18
  push ds                                      ; 01C59  0x1E
  xor_cx_cx                                   ; 01C5A  xor cx, cx
  push cx                                      ; 01C5C  0x51
  push word [si + 2]                           ; 01C5D  0xFF, 0x74, 0x02
  mov ax, ss                                   ; 01C60  0x8C, 0xD0
  mov ds, ax                                   ; 01C62  0x8E, 0xD8
  mov_dx_sp                                    ; 01C64  mov dx, sp
  mov cx, 0x82                                 ; 01C66  0xB9, 0x82, 0x00
  call bdos1_far_call_user                               ; 01C69  0xE8, 0x80, 0xFA
  pop bx                                       ; 01C6C  0x5B
  pop cx                                       ; 01C6D  0x59
  pop ds                                       ; 01C6E  0x1F
  jmp short loc_01C4D                          ; 01C6F  0xEB, 0xDC

loc_01C71:  ; 01C71
  mov byte [0x6f4], 0                          ; 01C71  0xC6, 0x06, 0xF4, 0x06, 0x00
  mov bx, 0x96                                 ; 01C76  0xBB, 0x96, 0x00

loc_01C79:  ; 01C79
  mov bx, [bx]                                 ; 01C79  0x8B, 0x1F
  test bx, bx                                  ; 01C7B  0x85, 0xDB
  je loc_01C86                                 ; 01C7D  0x74, 0x07
  push bx                                      ; 01C7F  0x53
  call bdos1_fn22_unsync                       ; 01C80  0xE8, 0x17, 0xFB
  pop bx                                       ; 01C83  0x5B
  jmp short loc_01C79                          ; 01C84  0xEB, 0xF3

loc_01C86:  ; 01C86
  mov si, [0x68]                               ; 01C86  0x8B, 0x36, 0x68, 0x00
  mov ax, [si]                                 ; 01C8A  0x8B, 0x04
  mov [0x68], ax                               ; 01C8C  0xA3, 0x68, 0x00
  mov word [si], 0                             ; 01C8F  0xC7, 0x04, 0x00, 0x00
  cmp si, [0x8c]                               ; 01C93  0x3B, 0x36, 0x8C, 0x00
  jne loc_01C9F                                ; 01C97  0x75, 0x06
  mov word [0x8c], 0                           ; 01C99  0xC7, 0x06, 0x8C, 0x00, 0x00, 0x00

loc_01C9F:  ; 01C9F
  call bdos1_set_di_70                               ; 01C9F  0xE8, 0xA4, 0xFB
  jmp near loc_01CDE                           ; 01CA2  0xE9, 0x39, 0x00

loc_01CA5:  ; 01CA5
  mov byte [si + 4], 0                         ; 01CA5  0xC6, 0x44, 0x04, 0x00
  mov bx, 0x68                                 ; 01CA9  0xBB, 0x68, 0x00
  call bdos1_check_attr_20                               ; 01CAC  0xE8, 0x03, 0x00
  jmp near loc_01CDE                           ; 01CAF  0xE9, 0x2C, 0x00

bdos1_check_attr_20:  ; 01CB2
  mov cx, [si + 6]                             ; 01CB2  0x8B, 0x4C, 0x06
  and cx, strict word 0x20                    ; 01CB5  81 E1 20 00

loc_01CB9:  ; 01CB9
  mov di, [bx]                                 ; 01CB9  0x8B, 0x3F
  test di, di                                  ; 01CBB  0x85, 0xFF
  je loc_01CD2                                 ; 01CBD  0x74, 0x13
  mov al, [di + 5]                             ; 01CBF  0x8A, 0x45, 0x05
  cmp al, [si + 5]                             ; 01CC2  0x3A, 0x44, 0x05
  ja loc_01CD2                                 ; 01CC5  0x77, 0x0B
  jb loc_01CCD                                 ; 01CC7  0x72, 0x04
  jcxz loc_01CCD                               ; 01CC9  0xE3, 0x02
  jmp short loc_01CD2                          ; 01CCB  0xEB, 0x05

loc_01CCD:  ; 01CCD
  mov_bx_di                                    ; 01CCD  mov bx, di
  jmp near loc_01CB9                           ; 01CCF  0xE9, 0xE7, 0xFF

loc_01CD2:  ; 01CD2
  jcxz loc_01CD9                               ; 01CD2  0xE3, 0x05
  and word [si + 6], strict word 0xffdf       ; 01CD4  81 64 06 DF FF

loc_01CD9:  ; 01CD9
  mov [si], di                                 ; 01CD9  0x89, 0x3C
  mov [bx], si                                 ; 01CDB  0x89, 0x37
  ret                                          ; 01CDD  0xC3

loc_01CDE:  ; 01CDE
  sti                                          ; 01CDE  0xFB
  mov di, 0x6e                                 ; 01CDF  0xBF, 0x6E, 0x00

loc_01CE2:  ; 01CE2
  mov si, [di]                                 ; 01CE2  0x8B, 0x35
  test si, si                                  ; 01CE4  0x85, 0xF6
  je loc_01D1E                                 ; 01CE6  0x74, 0x36
  mov bx, [0x68]                               ; 01CE8  0x8B, 0x1E, 0x68, 0x00
  test bx, bx                                  ; 01CEC  0x85, 0xDB
  je loc_01CFA                                 ; 01CEE  0x74, 0x0A
  mov al, [si + 5]                             ; 01CF0  0x8A, 0x44, 0x05
  cmp al, [bx + 5]                             ; 01CF3  0x3A, 0x47, 0x05
  jbe loc_01CFA                                ; 01CF6  0x76, 0x02
  jmp short loc_01D1E                          ; 01CF8  0xEB, 0x24

loc_01CFA:  ; 01CFA
  push di                                      ; 01CFA  0x57
  mov dx, [si + 0x1A]                          ; 01CFB  0x8B, 0x54, 0x1A
  mov al, 0xd                                  ; 01CFE  0xB0, 0x0D
  call bdos1_userdisp_call                               ; 01D00  0xE8, 0xEF, 0xF9
  pop di                                       ; 01D03  0x5F
  mov si, [di]                                 ; 01D04  0x8B, 0x35
  cmp al, 0                                    ; 01D06  0x3C, 0x00
  je loc_01D1A                                 ; 01D08  0x74, 0x10
  mov ax, [si]                                 ; 01D0A  0x8B, 0x04
  mov [di], ax                                 ; 01D0C  0x89, 0x05
  mov bx, 0x68                                 ; 01D0E  0xBB, 0x68, 0x00
  mov byte [si + 4], 0                         ; 01D11  0xC6, 0x44, 0x04, 0x00
  call bdos1_check_attr_20                               ; 01D15  0xE8, 0x9A, 0xFF
  jmp short loc_01D1E                          ; 01D18  0xEB, 0x04

loc_01D1A:  ; 01D1A
  mov_di_si                                    ; 01D1A  mov di, si
  jmp short loc_01CE2                          ; 01D1C  0xEB, 0xC4

loc_01D1E:  ; 01D1E
  cli                                          ; 01D1E  0xFA
  mov si, [0x6c]                               ; 01D1F  0x8B, 0x36, 0x6C, 0x00
  test si, si                                  ; 01D23  0x85, 0xF6
  je loc_01D39                                 ; 01D25  0x74, 0x12
  mov ax, [si]                                 ; 01D27  0x8B, 0x04
  mov [0x6c], ax                               ; 01D29  0xA3, 0x6C, 0x00
  sti                                          ; 01D2C  0xFB
  mov byte [si + 4], 0                         ; 01D2D  0xC6, 0x44, 0x04, 0x00
  mov bx, 0x68                                 ; 01D31  0xBB, 0x68, 0x00
  call bdos1_check_attr_20                               ; 01D34  0xE8, 0x7B, 0xFF
  jmp short loc_01D1E                          ; 01D37  0xEB, 0xE5

loc_01D39:  ; 01D39
  sti                                          ; 01D39  0xFB
  mov bx, [0x68]                               ; 01D3A  0x8B, 0x1E, 0x68, 0x00

loc_01D3E:  ; 01D3E
  test bx, bx                                  ; 01D3E  0x85, 0xDB
  jne loc_01D45                                ; 01D40  0x75, 0x03
  jmp near loc_01CDE                           ; 01D42  0xE9, 0x99, 0xFF

loc_01D45:  ; 01D45
  cli                                          ; 01D45  0xFA
  mov ax, [bx + 0x26]                          ; 01D46  0x8B, 0x47, 0x26
  test ax, 1                                   ; 01D49  0xA9, 0x01, 0x00
  je loc_01DAF                                 ; 01D4C  0x74, 0x61
  mov al, [bx + 0x20]                          ; 01D4E  0x8A, 0x47, 0x20
  xor_ah_ah                                    ; 01D51  xor ah, ah
  xor_di_di                                    ; 01D53  xor di, di
  mov di, 0x2c                                 ; 01D55  0xBF, 0x2C, 0x00
  mul_di                                       ; 01D58  mul di
  mov di, [0x54]                               ; 01D5A  0x8B, 0x3E, 0x54, 0x00
  add_di_ax                                    ; 01D5E  add di, ax
  mov ax, [di + 0xe]                           ; 01D60  0x8B, 0x45, 0x0E
  test ax, 2                                   ; 01D63  0xA9, 0x02, 0x00
  je loc_01DAF                                 ; 01D66  0x74, 0x47
  push es                                      ; 01D68  0x06
  mov es, [bx + 0x10]                          ; 01D69  0x8E, 0x47, 0x10
  mov al, [es:0x60]                            ; 01D6C  0x26, 0xA0, 0x60, 0x00
  test al, al                                  ; 01D70  0x84, 0xC0
  pop es                                       ; 01D72  0x07
  jne loc_01DAF                                ; 01D73  0x75, 0x3A
  test word [bx + 6], 0x80                     ; 01D75  0xF7, 0x47, 0x06, 0x80, 0x00
  jne loc_01DAF                                ; 01D7A  0x75, 0x33
  mov ax, [bx]                                 ; 01D7C  0x8B, 0x07
  mov [0x68], ax                               ; 01D7E  0xA3, 0x68, 0x00
  mov ax, [0xa8]                               ; 01D81  0xA1, 0xA8, 0x00
  mov [bx], ax                                 ; 01D84  0x89, 0x07
  mov [0xa8], bx                               ; 01D86  0x89, 0x1E, 0xA8, 0x00
  mov byte [bx + 4], 9                         ; 01D8A  0xC6, 0x47, 0x04, 0x09
  mov ax, [di + 0xe]                           ; 01D8E  0x8B, 0x45, 0x0E
  test ax, 0x10                                ; 01D91  0xA9, 0x10, 0x00
  jne loc_01D9B                                ; 01D94  0x75, 0x05
  or word [di + 0xe], strict word 0x10        ; 01D96  81 4D 0E 10 00

loc_01D9B:  ; 01D9B
  push es                                      ; 01D9B  0x06
  mov es, [bx + 0x10]                          ; 01D9C  0x8E, 0x47, 0x10
  mov word [es:0], 0xa8                       ; 01D9F
  pop es                                       ; 01DA6  0x07
  mov bx, [0x68]                               ; 01DA7  0x8B, 0x1E, 0x68, 0x00
  sti                                          ; 01DAB  0xFB
  jmp near loc_01D3E                           ; 01DAC  0xE9, 0x8F, 0xFF

loc_01DAF:  ; 01DAF
  sti                                          ; 01DAF  0xFB
  test word [bx + 6], 0x8000                   ; 01DB0  0xF7, 0x47, 0x06, 0x00, 0x80
  je loc_01E16                                 ; 01DB5  0x74, 0x5F
  cmp bx, [0x8c]                               ; 01DB7  0x3B, 0x1E, 0x8C, 0x00
  je loc_01E34                                 ; 01DBB  0x74, 0x77
  mov dx, ds                                   ; 01DBD  0x8C, 0xDA
  wait                                         ; 01DBF  0x9B
  xchg [0x8c], bx                              ; 01DC0  0x87, 0x1E, 0x8C, 0x00
  test bx, bx                                  ; 01DC4  0x85, 0xDB
  je loc_01DF6                                 ; 01DC6  0x74, 0x2E
  mov ds, [bx + 0x10]                          ; 01DC8  0x8E, 0x5F, 0x10
  wait                                         ; 01DCB  0x9B
  fnstcw word [0x100]                         ; 01DCC
  nop                                          ; 01DD0  0x90
  wait                                         ; 01DD1  0x9B
  db 0xDB, 0xE1                               ; 01DD2  fdisi8087_nop
  mov ax, [0x100]                              ; 01DD4  0xA1, 0x00, 0x01
  fnsave [0x100]                              ; 01DD7
  wait                                         ; 01DDB  0x9B
  mov [0x100], ax                              ; 01DDC  0xA3, 0x00, 0x01
  mov ds, dx                                   ; 01DDF  0x8E, 0xDA
  mov es, [bx + 0x10]                          ; 01DE1  0x8E, 0x47, 0x10
  mov di, 0x40                                 ; 01DE4  0xBF, 0x40, 0x00
  mov si, [0xa0]                               ; 01DE7  0x8B, 0x36, 0xA0, 0x00
  mov ds, [0xa2]                               ; 01DEB  0x8E, 0x1E, 0xA2, 0x00
  mov cx, 2                                    ; 01DEF  0xB9, 0x02, 0x00
  rep movsw                                    ; 01DF2  0xF3, 0xA5
  mov ds, dx                                   ; 01DF4  0x8E, 0xDA

loc_01DF6:  ; 01DF6
  mov bx, [0x68]                               ; 01DF6  0x8B, 0x1E, 0x68, 0x00
  mov ds, [bx + 0x10]                          ; 01DFA  0x8E, 0x5F, 0x10
  wait                                         ; 01DFD  0x9B
  frstor [0x100]                              ; 01DFE
  push ds                                      ; 01E02  0x1E
  mov ds, dx                                   ; 01E03  0x8E, 0xDA
  les di, [0xa0]                               ; 01E05  0xC4, 0x3E, 0xA0, 0x00
  mov ds, [bx + 0x10]                          ; 01E09  0x8E, 0x5F, 0x10
  mov si, 0x40                                 ; 01E0C  0xBE, 0x40, 0x00
  mov cx, 2                                    ; 01E0F  0xB9, 0x02, 0x00
  rep movsw                                    ; 01E12  0xF3, 0xA5
  jmp short loc_01E3A                          ; 01E14  0xEB, 0x24

loc_01E16:  ; 01E16
  test word [bx + 0x26], 2                     ; 01E16  0xF7, 0x47, 0x26, 0x02, 0x00
  je loc_01E34                                 ; 01E1B  0x74, 0x17
  mov ax, ds                                   ; 01E1D  0x8C, 0xD8
  mov cx, 0                                    ; 01E1F  0xB9, 0x00, 0x00
  mov di, 0x200                                ; 01E22  0xBF, 0x00, 0x02
  mov si, 0x100                                ; 01E25  0xBE, 0x00, 0x01
  mov ds, [bx + 0x10]                          ; 01E28  0x8E, 0x5F, 0x10
  mov es, cx                                   ; 01E2B  0x8E, 0xC1
  mov cx, 0x1a                                 ; 01E2D  0xB9, 0x1A, 0x00
  rep movsw                                    ; 01E30  0xF3, 0xA5
  mov ds, ax                                   ; 01E32  0x8E, 0xD8

loc_01E34:  ; 01E34
  mov dx, [bx + 0x10]                          ; 01E34  0x8B, 0x57, 0x10
  mov ds, dx                                   ; 01E37  0x8E, 0xDA
  push dx                                      ; 01E39  0x52

loc_01E3A:  ; 01E3A
  mov es, [cs:6]                               ; 01E3A  0x2E, 0x8E, 0x06, 0x06, 0x00
  mov ax, 1                                    ; 01E3F  0xB8, 0x01, 0x00
  mov si, [es:0x68]                            ; 01E42  0x26, 0x8B, 0x36, 0x68, 0x00
  call far [es:si + 0x28]                      ; 01E47  0x26, 0xFF, 0x5C, 0x28
  xor_ax_ax                                    ; 01E4B  xor ax, ax
  mov es, ax                                   ; 01E4D  0x8E, 0xC0
  mov_di_ax                                    ; 01E4F  mov di, ax
  mov si, 0x38                                 ; 01E51  0xBE, 0x38, 0x00
  mov dx, 4                                    ; 01E54  0xBA, 0x04, 0x00
  mov_cx_dx                                    ; 01E57  mov cx, dx
  rep movsw                                    ; 01E59  0xF3, 0xA5
  mov_cx_dx                                    ; 01E5B  mov cx, dx
  add_di_dx                                    ; 01E5D  add di, dx
  add_si_dx                                    ; 01E5F  add si, dx
  rep movsw                                    ; 01E61  0xF3, 0xA5
  mov si, 0x58                                 ; 01E63  0xBE, 0x58, 0x00
  mov di, 0x380                                ; 01E66  0xBF, 0x80, 0x03
  mov_cx_dx                                    ; 01E69  mov cx, dx
  rep movsw                                    ; 01E6B  0xF3, 0xA5
  mov ax, [0x22]                               ; 01E6D  0xA1, 0x22, 0x00
  mov_bx_ax                                    ; 01E70  mov bx, ax
  mov ax, [0x24]                               ; 01E72  0xA1, 0x24, 0x00
  mov_cx_ax                                    ; 01E75  mov cx, ax
  mov ax, [0x26]                               ; 01E77  0xA1, 0x26, 0x00
  mov_dx_ax                                    ; 01E7A  mov dx, ax
  mov ax, [0x2a]                               ; 01E7C  0xA1, 0x2A, 0x00
  mov_si_ax                                    ; 01E7F  mov si, ax
  mov ax, [0x28]                               ; 01E81  0xA1, 0x28, 0x00
  mov_di_ax                                    ; 01E84  mov di, ax
  mov ax, [0x2c]                               ; 01E86  0xA1, 0x2C, 0x00
  mov_bp_ax                                    ; 01E89  mov bp, ax
  mov ax, [0x20]                               ; 01E8B  0xA1, 0x20, 0x00
  pop es                                       ; 01E8E  0x07
  cli                                          ; 01E8F  0xFA
  mov ss, [es:0x1e]                            ; 01E90  0x26, 0x8E, 0x16, 0x1E, 0x00
  mov sp, [es:0x1c]                            ; 01E95  0x26, 0x8B, 0x26, 0x1C, 0x00
  mov ds, [cs:6]                               ; 01E9A  0x2E, 0x8E, 0x1E, 0x06, 0x00

loc_01E9F:  ; 01E9F
  cmp byte [es:0x1b], 0xff                     ; 01E9F  0x26, 0x80, 0x3E, 0x1B, 0x00, 0xFF
  jne loc_01EAA                                ; 01EA5  0x75, 0x03
  jmp near loc_01A67                           ; 01EA7  0xE9, 0xBD, 0xFB

loc_01EAA:  ; 01EAA
  push word [es:0x4e]                          ; 01EAA  0x26, 0xFF, 0x36, 0x4E, 0x00
  mov byte [0x652], 0                          ; 01EAF  0xC6, 0x06, 0x52, 0x06, 0x00
  cmp word [0x6c], 0                           ; 01EB4  0x83, 0x3E, 0x6C, 0x00, 0x00
  je loc_01EBF                                 ; 01EB9  0x74, 0x04
  popf                                         ; 01EBB  0x9D
  jmp near bdos1_set_p_ready                           ; 01EBC  0xE9, 0xE7, 0xFB

loc_01EBF:  ; 01EBF
  popf                                         ; 01EBF  0x9D
  ret                                          ; 01EC0  0xC3

bdos1_fn03_close_file:  ; 01EC1
  call bdos1_open_close_setup                               ; 01EC1  0xE8, 0xAA, 0x00
  cmp cl, 1                                    ; 01EC4  0x80, 0xF9, 0x01
  jne loc_01F02                                ; 01EC7  0x75, 0x39
  mov bx, [0x6a]                               ; 01EC9  0x8B, 0x1E, 0x6A, 0x00
  test bx, bx                                  ; 01ECD  0x85, 0xDB
  je loc_01EFA                                 ; 01ECF  0x74, 0x29
  dec word [bx + 0x1A]                         ; 01ED1  0xFF, 0x4F, 0x1A
  jne loc_01EF7                                ; 01ED4  0x75, 0x21

loc_01ED6:  ; 01ED6
  mov si, [bx]                                 ; 01ED6  0x8B, 0x37
  mov [0x6a], si                               ; 01ED8  0x89, 0x36, 0x6A, 0x00
  mov byte [bx + 4], 0                         ; 01EDC  0xC6, 0x47, 0x04, 0x00
  mov ax, [0x6c]                               ; 01EE0  0xA1, 0x6C, 0x00
  mov [bx], ax                                 ; 01EE3  0x89, 0x07
  mov [0x6c], bx                               ; 01EE5  0x89, 0x1E, 0x6C, 0x00
  test si, si                                  ; 01EE9  0x85, 0xF6
  je loc_01EFA                                 ; 01EEB  0x74, 0x0D
  cmp word [si + 0x1A], 0                      ; 01EED  0x83, 0x7C, 0x1A, 0x00
  jne loc_01EF7                                ; 01EF1  0x75, 0x04
  mov_bx_si                                    ; 01EF3  mov bx, si
  jmp short loc_01ED6                          ; 01EF5  0xEB, 0xDF

loc_01EF7:  ; 01EF7
  jmp near loc_01F93                           ; 01EF7  0xE9, 0x99, 0x00

loc_01EFA:  ; 01EFA
  mov byte [0xc0c], 0                          ; 01EFA  0xC6, 0x06, 0x0C, 0x0C, 0x00
  jmp near loc_01F93                           ; 01EFF  0xE9, 0x91, 0x00

loc_01F02:  ; 01F02
  cmp byte [si + 2], 0xff                      ; 01F02  0x80, 0x7C, 0x02, 0xFF
  je loc_01F11                                 ; 01F06  0x74, 0x09
  dec byte [si + 2]                            ; 01F08  0xFE, 0x4C, 0x02
  mov cx, 0x2a                                 ; 01F0B  0xB9, 0x2A, 0x00
  jmp near loc_01F97                           ; 01F0E  0xE9, 0x86, 0x00

loc_01F11:  ; 01F11
  cmp bx, -2                                   ; 01F11  0x83, 0xFB, 0xFE
  jne loc_01F1C                                ; 01F14  0x75, 0x06
  mov cx, 5                                    ; 01F16  0xB9, 0x05, 0x00
  jmp near loc_01F97                           ; 01F19  0xE9, 0x7B, 0x00

loc_01F1C:  ; 01F1C
  cmp bx, -1                                   ; 01F1C  0x83, 0xFB, 0xFF
  jne loc_01F28                                ; 01F1F  0x75, 0x07
  mov word [si], 0xfffe                        ; 01F21  0xC7, 0x04, 0xFE, 0xFF
  jmp near loc_01F93                           ; 01F25  0xE9, 0x6B, 0x00

loc_01F28:  ; 01F28
  mov ax, [0x6c]                               ; 01F28  0xA1, 0x6C, 0x00
  mov [bx], ax                                 ; 01F2B  0x89, 0x07
  mov [0x6c], bx                               ; 01F2D  0x89, 0x1E, 0x6C, 0x00
  mov byte [bx + 4], 0                         ; 01F31  0xC6, 0x47, 0x04, 0x00
  or word [bx + 6], strict word 0x20          ; 01F35  81 4F 06 20 00
  mov word [si], 0xffff                        ; 01F3A  0xC7, 0x04, 0xFF, 0xFF
  jmp near loc_01F93                           ; 01F3E  0xE9, 0x52, 0x00

bdos1_fn02_open_file:  ; 01F41
  call bdos1_open_close_setup                               ; 01F41  0xE8, 0x2A, 0x00
  cmp bx, -2                                   ; 01F44  0x83, 0xFB, 0xFE
  jne loc_01F50                                ; 01F47  0x75, 0x07
  mov word [si], 0xffff                        ; 01F49  0xC7, 0x04, 0xFF, 0xFF
  jmp near loc_01F93                           ; 01F4D  0xE9, 0x43, 0x00

loc_01F50:  ; 01F50
  cmp bx, -1                                   ; 01F50  0x83, 0xFB, 0xFF
  jne loc_01F68                                ; 01F53  0x75, 0x13
  mov bx, [0x68]                               ; 01F55  0x8B, 0x1E, 0x68, 0x00
  mov byte [bx + 4], 8                         ; 01F59  0xC6, 0x47, 0x04, 0x08
  mov [es:0], si                               ; 01F5D  0x26, 0x89, 0x36, 0x00, 0x00
  call bdos1_cli_chk_652                               ; 01F62  0xE8, 0x4B, 0xFB
  jmp near loc_01F93                           ; 01F65  0xE9, 0x2B, 0x00

loc_01F68:  ; 01F68
  mov cx, 6                                    ; 01F68  0xB9, 0x06, 0x00
  jmp near loc_01F97                           ; 01F6B  0xE9, 0x29, 0x00

bdos1_open_close_setup:  ; 01F6E
  pop ax                                       ; 01F6E  0x58
  pushf                                        ; 01F6F  0x9C
  cmp dl, [0x4a]                               ; 01F70  0x3A, 0x16, 0x4A, 0x00
  jb loc_01F7C                                 ; 01F74  0x72, 0x06
  mov cx, 4                                    ; 01F76  0xB9, 0x04, 0x00
  jmp near loc_01F97                           ; 01F79  0xE9, 0x1B, 0x00

loc_01F7C:  ; 01F7C
  mov_cl_dl                                    ; 01F7C  mov cl, dl
  xor_dh_dh                                    ; 01F7E  xor dh, dh
  push ax                                      ; 01F80  0x50
  cli                                          ; 01F81  0xFA
  mov_ax_dx                                    ; 01F82  mov ax, dx
  mov_bx_ax                                    ; 01F84  mov bx, ax
  add_ax_ax                                    ; 01F86  add ax, ax
  add_ax_bx                                    ; 01F88  add ax, bx
  mov si, [0x56]                               ; 01F8A  0x8B, 0x36, 0x56, 0x00
  add_si_ax                                    ; 01F8E  add si, ax
  mov bx, [si]                                 ; 01F90  0x8B, 0x1C
  ret                                          ; 01F92  0xC3

loc_01F93:  ; 01F93
  xor_bx_bx                                    ; 01F93  xor bx, bx
  popf                                         ; 01F95  0x9D
  ret                                          ; 01F96  0xC3

loc_01F97:  ; 01F97
  xor_bx_bx                                    ; 01F97  xor bx, bx
  dec bx                                       ; 01F99  0x4B
  popf                                         ; 01F9A  0x9D
  ret                                          ; 01F9B  0xC3

bdos1_fn04_search_first:  ; 01F9C
  call bdos1_mxdisk_sync                               ; 01F9C  0xE8, 0x3F, 0x02
  call bdos1_get_abs_para_1c                               ; 01F9F  0xE8, 0x92, 0x02
  jcxz loc_01FA7                               ; 01FA2  0xE3, 0x03
  jmp near loc_01FEC                           ; 01FA4  0xE9, 0x45, 0x00

loc_01FA7:  ; 01FA7
  push es                                      ; 01FA7  0x06
  mov es, [cs:6]                               ; 01FA8  0x2E, 0x8E, 0x06, 0x06, 0x00
  mov si, 0x74                                 ; 01FAD  0xBE, 0x74, 0x00

loc_01FB0:  ; 01FB0
  mov si, [si]                                 ; 01FB0  0x8B, 0x34
  test si, si                                  ; 01FB2  0x85, 0xF6
  je loc_01FD0                                 ; 01FB4  0x74, 0x1A
  push di                                      ; 01FB6  0x57
  push si                                      ; 01FB7  0x56
  mov cx, 4                                    ; 01FB8  0xB9, 0x04, 0x00
  add di, 6                                    ; 01FBB  0x83, 0xC7, 0x06
  add si, 6                                    ; 01FBE  0x83, 0xC6, 0x06
  repe cmpsw                                   ; 01FC1  0xF3, 0xA7
  pop si                                       ; 01FC3  0x5E
  pop di                                       ; 01FC4  0x5F
  jne loc_01FB0                                ; 01FC5  0x75, 0xE9
  pop es                                       ; 01FC7  0x07
  call bdos1_link_free_buffer                               ; 01FC8  0xE8, 0x6B, 0x03
  mov cx, 0xa                                  ; 01FCB  0xB9, 0x0A, 0x00
  jmp short loc_01FEC                          ; 01FCE  0xEB, 0x1C

loc_01FD0:  ; 01FD0
  pop es                                       ; 01FD0  0x07
  xor_dx_dx                                    ; 01FD1  xor dx, dx
  mov [di + 0x12], dx                          ; 01FD3  0x89, 0x55, 0x12
  mov [di + 0x14], dx                          ; 01FD6  0x89, 0x55, 0x14
  mov [di + 0x16], dx                          ; 01FD9  0x89, 0x55, 0x16
  mov [di + 0x18], dx                          ; 01FDC  0x89, 0x55, 0x18
  mov ax, [0x74]                               ; 01FDF  0xA1, 0x74, 0x00
  mov [di], ax                                 ; 01FE2  0x89, 0x05
  mov [0x74], di                               ; 01FE4  0x89, 0x3E, 0x74, 0x00
  xor_bx_bx                                    ; 01FE8  xor bx, bx
  jmp short loc_01FEF                          ; 01FEA  0xEB, 0x03

loc_01FEC:  ; 01FEC
  mov bx, 0xffff                               ; 01FEC  0xBB, 0xFF, 0xFF

loc_01FEF:  ; 01FEF
  jmp near bdos1_mxdisk_unsync                           ; 01FEF  0xE9, 0xFA, 0x01

bdos1_fn05_search_next:  ; 01FF2
  call bdos1_mxdisk_sync                               ; 01FF2  0xE8, 0xE9, 0x01
  push es                                      ; 01FF5  0x06
  mov es, [es:0x2e]                            ; 01FF6  0x26, 0x8E, 0x06, 0x2E, 0x00
  mov si, 0x74                                 ; 01FFB  0xBE, 0x74, 0x00
  mov_di_dx                                    ; 01FFE  mov di, dx

loc_02000:  ; 02000
  mov si, [si]                                 ; 02000  0x8B, 0x34
  test si, si                                  ; 02002  0x85, 0xF6
  jne loc_0200C                                ; 02004  0x75, 0x06
  pop es                                       ; 02006  0x07
  mov cx, 9                                    ; 02007  0xB9, 0x09, 0x00
  jmp short loc_0203E                          ; 0200A  0xEB, 0x32

loc_0200C:  ; 0200C
  push di                                      ; 0200C  0x57
  push si                                      ; 0200D  0x56
  mov cx, 4                                    ; 0200E  0xB9, 0x04, 0x00
  add si, 6                                    ; 02011  0x83, 0xC6, 0x06
  add di, 8                                    ; 02014  0x83, 0xC7, 0x08
  repe cmpsw                                   ; 02017  0xF3, 0xA7
  pop si                                       ; 02019  0x5E
  pop di                                       ; 0201A  0x5F
  jne loc_02000                                ; 0201B  0x75, 0xE3
  test word [si + 4], 4                        ; 0201D  0xF7, 0x44, 0x04, 0x04, 0x00
  je loc_02035                                 ; 02022  0x74, 0x11
  mov bx, [0x68]                               ; 02024  0x8B, 0x1E, 0x68, 0x00
  test word [bx + 6], 1                        ; 02028  0xF7, 0x47, 0x06, 0x01, 0x00
  jne loc_02035                                ; 0202D  0x75, 0x06
  pop es                                       ; 0202F  0x07
  mov cx, 0xd                                  ; 02030  0xB9, 0x0D, 0x00
  jmp short loc_0203E                          ; 02033  0xEB, 0x09

loc_02035:  ; 02035
  mov [es:di + 2], si                          ; 02035  0x26, 0x89, 0x75, 0x02
  pop es                                       ; 02039  0x07
  xor_bx_bx                                    ; 0203A  xor bx, bx
  jmp short loc_02041                          ; 0203C  0xEB, 0x03

loc_0203E:  ; 0203E
  mov bx, 0xffff                               ; 0203E  0xBB, 0xFF, 0xFF

loc_02041:  ; 02041
  call bdos1_mxdisk_unsync                               ; 02041  0xE8, 0xA8, 0x01
  ret                                          ; 02044  0xC3

bdos1_fn06_delete_make:  ; 02045
  mov ax, es                                   ; 02045  0x8C, 0xC0
  mov es, [es:0x2e]                            ; 02047  0x26, 0x8E, 0x06, 0x2E, 0x00
  mov_di_dx                                    ; 0204C  mov di, dx
  mov di, [es:di + 2]                          ; 0204E  0x26, 0x8B, 0x7D, 0x02
  mov es, ax                                   ; 02052  0x8E, 0xC0
  test word [di + 4], 2                        ; 02054  0xF7, 0x45, 0x04, 0x02, 0x00
  jne loc_0206D                                ; 02059  0x75, 0x12
  test word [di + 4], 4                        ; 0205B  0xF7, 0x45, 0x04, 0x04, 0x00
  je loc_02074                                 ; 02060  0x74, 0x12
  mov bx, [0x68]                               ; 02062  0x8B, 0x1E, 0x68, 0x00
  test word [bx + 6], 1                        ; 02066  0xF7, 0x47, 0x06, 0x01, 0x00
  jne loc_02074                                ; 0206B  0x75, 0x07

loc_0206D:  ; 0206D
  mov cx, 0xd                                  ; 0206D  0xB9, 0x0D, 0x00
  mov bx, 0xffff                               ; 02070  0xBB, 0xFF, 0xFF
  ret                                          ; 02073  0xC3

loc_02074:  ; 02074
  push di                                      ; 02074  0x57
  call bdos1_mxdisk_sync                               ; 02075  0xE8, 0x66, 0x01
  pop di                                       ; 02078  0x5F
  mov ax, [di + 0x12]                          ; 02079  0x8B, 0x45, 0x12
  mov dx, [di + 0x14]                          ; 0207C  0x8B, 0x55, 0x14
  or_dx_ax                                     ; 0207F  or dx, ax
  mov cx, 0xa                                  ; 02081  0xB9, 0x0A, 0x00
  jne loc_020A5                                ; 02084  0x75, 0x1F
  mov bx, 0x74                                 ; 02086  0xBB, 0x74, 0x00

loc_02089:  ; 02089
  mov si, [bx]                                 ; 02089  0x8B, 0x37
  test si, si                                  ; 0208B  0x85, 0xF6
  je loc_020A2                                 ; 0208D  0x74, 0x13
  cmp_si_di                                    ; 0208F  cmp si, di
  je loc_02097                                 ; 02091  0x74, 0x04
  mov_bx_si                                    ; 02093  mov bx, si
  jmp short loc_02089                          ; 02095  0xEB, 0xF2

loc_02097:  ; 02097
  mov ax, [di]                                 ; 02097  0x8B, 0x05
  mov [bx], ax                                 ; 02099  0x89, 0x07
  call bdos1_link_free_buffer                               ; 0209B  0xE8, 0x98, 0x02
  xor_bx_bx                                    ; 0209E  xor bx, bx
  jmp short loc_020A8                          ; 020A0  0xEB, 0x06

loc_020A2:  ; 020A2
  mov cx, 9                                    ; 020A2  0xB9, 0x09, 0x00

loc_020A5:  ; 020A5
  mov bx, 0xffff                               ; 020A5  0xBB, 0xFF, 0xFF

loc_020A8:  ; 020A8
  jmp near bdos1_mxdisk_unsync                           ; 020A8  0xE9, 0x41, 0x01

bdos1_fn07_read_seq:  ; 020AB
  xor_al_al                                    ; 020AB  xor al, al
  jmp short loc_020B1                          ; 020AD  0xEB, 0x02

bdos1_fn08_read_rand:  ; 020AF
  mov al, 0xff                                 ; 020AF  0xB0, 0xFF

loc_020B1:  ; 020B1
  push ax                                      ; 020B1  0x50
  call bdos1_mxdisk_sync                               ; 020B2  0xE8, 0x29, 0x01
  call bdos1_load_u_wrkseg_fcb                               ; 020B5  0xE8, 0x5A, 0x01
  pop ax                                       ; 020B8  0x58
  mov_si_dx                                    ; 020B9  mov si, dx
  jcxz loc_020C0                               ; 020BB  0xE3, 0x03
  jmp near loc_02133                           ; 020BD  0xE9, 0x73, 0x00

loc_020C0:  ; 020C0
  push es                                      ; 020C0  0x06
  mov es, [es:0x2e]                            ; 020C1  0x26, 0x8E, 0x06, 0x2E, 0x00
  mov bx, [es:si + 2]                          ; 020C6  0x26, 0x8B, 0x5C, 0x02
  cmp word [bx + 0x16], 0                      ; 020CA  0x83, 0x7F, 0x16, 0x00
  jne loc_020EC                                ; 020CE  0x75, 0x1C
  pop es                                       ; 020D0  0x07
  test al, al                                  ; 020D1  0x84, 0xC0
  je loc_020DA                                 ; 020D3  0x74, 0x05
  mov cx, 0xe                                  ; 020D5  0xB9, 0x0E, 0x00
  jmp short loc_02133                          ; 020D8  0xEB, 0x59

loc_020DA:  ; 020DA
  push bx                                      ; 020DA  0x53
  push si                                      ; 020DB  0x56
  lea dx, [bx + 0x12]                          ; 020DC  0x8D, 0x57, 0x12
  mov bl, 6                                    ; 020DF  0xB3, 0x06
  call bdos1_lock_disk_cli                               ; 020E1  0xE8, 0xEC, 0x00
  pop si                                       ; 020E4  0x5E
  pop bx                                       ; 020E5  0x5B
  push es                                      ; 020E6  0x06
  mov es, [es:0x2e]                            ; 020E7  0x26, 0x8E, 0x06, 0x2E, 0x00

loc_020EC:  ; 020EC
  mov di, [es:si + 6]                          ; 020EC  0x26, 0x8B, 0x7C, 0x06
  mov cx, [bx + 0xe]                           ; 020F0  0x8B, 0x4F, 0x0E
  test cx, cx                                  ; 020F3  0x85, 0xC9
  jne loc_0210A                                ; 020F5  0x75, 0x13
  xor_ax_ax                                    ; 020F7  xor ax, ax
  test word [bx + 4], 1                        ; 020F9  0xF7, 0x47, 0x04, 0x01, 0x00
  je loc_02120                                 ; 020FE  0x74, 0x20
  mov ax, [0x68]                               ; 02100  0xA1, 0x68, 0x00
  mov [bx + 0x1A], ax                          ; 02103  0x89, 0x47, 0x1A
  xor_ax_ax                                    ; 02106  xor ax, ax
  jmp short loc_02120                          ; 02108  0xEB, 0x16

loc_0210A:  ; 0210A
  mov ax, [bx + 0x18]                          ; 0210A  0x8B, 0x47, 0x18
  push ax                                      ; 0210D  0x50
  mul_cx                                       ; 0210E  mul cx
  add ax, [bx + 0x1A]                          ; 02110  0x03, 0x47, 0x1A
  mov_si_ax                                    ; 02113  mov si, ax
  rep movsb                                    ; 02115  0xF3, 0xA4
  pop ax                                       ; 02117  0x58
  inc ax                                       ; 02118  0x40
  cmp ax, [bx + 0x10]                          ; 02119  0x3B, 0x47, 0x10
  jne loc_02120                                ; 0211C  0x75, 0x02
  xor_ax_ax                                    ; 0211E  xor ax, ax

loc_02120:  ; 02120
  pop es                                       ; 02120  0x07
  mov [bx + 0x18], ax                          ; 02121  0x89, 0x47, 0x18
  dec word [bx + 0x16]                         ; 02124  0xFF, 0x4F, 0x16
  lea dx, [bx + 0x14]                          ; 02127  0x8D, 0x57, 0x14
  call bdos1_test_chain_head                               ; 0212A  0xE8, 0xCD, 0x00
  call bdos1_mxdisk_unsync                               ; 0212D  0xE8, 0xBC, 0x00
  xor_bx_bx                                    ; 02130  xor bx, bx
  ret                                          ; 02132  0xC3

loc_02133:  ; 02133
  call bdos1_mxdisk_unsync                               ; 02133  0xE8, 0xB6, 0x00
  mov bx, 0xffff                               ; 02136  0xBB, 0xFF, 0xFF
  ret                                          ; 02139  0xC3

bdos1_fn09_write_seq:  ; 0213A
  xor_al_al                                    ; 0213A  xor al, al
  jmp short loc_02140                          ; 0213C  0xEB, 0x02

bdos1_fn10_write_rand:  ; 0213E
  mov al, 0xff                                 ; 0213E  0xB0, 0xFF

loc_02140:  ; 02140
  push ax                                      ; 02140  0x50
  call bdos1_mxdisk_sync                               ; 02141  0xE8, 0x9A, 0x00
  call bdos1_load_u_wrkseg_fcb                               ; 02144  0xE8, 0xCB, 0x00
  pop ax                                       ; 02147  0x58
  mov_di_dx                                    ; 02148  mov di, dx
  jcxz loc_0214F                               ; 0214A  0xE3, 0x03
  jmp near loc_021C9                           ; 0214C  0xE9, 0x7A, 0x00

loc_0214F:  ; 0214F
  push es                                      ; 0214F  0x06
  mov es, [es:0x2e]                            ; 02150  0x26, 0x8E, 0x06, 0x2E, 0x00
  mov bx, [es:di + 2]                          ; 02155  0x26, 0x8B, 0x5D, 0x02
  mov cx, [bx + 0x16]                          ; 02159  0x8B, 0x4F, 0x16
  cmp cx, [bx + 0x10]                          ; 0215C  0x3B, 0x4F, 0x10
  jne loc_0217D                                ; 0215F  0x75, 0x1C
  pop es                                       ; 02161  0x07
  test al, al                                  ; 02162  0x84, 0xC0
  je loc_0216B                                 ; 02164  0x74, 0x05
  mov cx, 0xf                                  ; 02166  0xB9, 0x0F, 0x00
  jmp short loc_021C9                          ; 02169  0xEB, 0x5E

loc_0216B:  ; 0216B
  push bx                                      ; 0216B  0x53
  push di                                      ; 0216C  0x57
  lea dx, [bx + 0x14]                          ; 0216D  0x8D, 0x57, 0x14
  mov bl, 7                                    ; 02170  0xB3, 0x07
  call bdos1_lock_disk_cli                               ; 02172  0xE8, 0x5B, 0x00
  pop di                                       ; 02175  0x5F
  pop bx                                       ; 02176  0x5B
  push es                                      ; 02177  0x06
  mov es, [es:0x2e]                            ; 02178  0x26, 0x8E, 0x06, 0x2E, 0x00

loc_0217D:  ; 0217D
  mov si, [es:di + 6]                          ; 0217D  0x26, 0x8B, 0x75, 0x06
  mov cx, [bx + 0xe]                           ; 02181  0x8B, 0x4F, 0x0E
  test cx, cx                                  ; 02184  0x85, 0xC9
  jne loc_02196                                ; 02186  0x75, 0x0E
  test word [bx + 4], 1                        ; 02188  0xF7, 0x47, 0x04, 0x01, 0x00
  je loc_021B9                                 ; 0218D  0x74, 0x2A
  xor_ax_ax                                    ; 0218F  xor ax, ax
  mov [bx + 0x1A], ax                          ; 02191  0x89, 0x47, 0x1A
  jmp short loc_021B9                          ; 02194  0xEB, 0x23

loc_02196:  ; 02196
  mov ax, [bx + 0x18]                          ; 02196  0x8B, 0x47, 0x18
  add ax, [bx + 0x16]                          ; 02199  0x03, 0x47, 0x16
  cmp ax, [bx + 0x10]                          ; 0219C  0x3B, 0x47, 0x10
  jb loc_021A4                                 ; 0219F  0x72, 0x03
  sub ax, [bx + 0x10]                          ; 021A1  0x2B, 0x47, 0x10

loc_021A4:  ; 021A4
  mul_cx                                       ; 021A4  mul cx
  add ax, [bx + 0x1A]                          ; 021A6  0x03, 0x47, 0x1A
  mov_di_ax                                    ; 021A9  mov di, ax
  mov ax, ds                                   ; 021AB  0x8C, 0xD8
  mov dx, es                                   ; 021AD  0x8C, 0xC2
  mov es, ax                                   ; 021AF  0x8E, 0xC0
  mov ds, dx                                   ; 021B1  0x8E, 0xDA
  rep movsb                                    ; 021B3  0xF3, 0xA4
  mov ax, es                                   ; 021B5  0x8C, 0xC0
  mov ds, ax                                   ; 021B7  0x8E, 0xD8

loc_021B9:  ; 021B9
  pop es                                       ; 021B9  0x07
  inc word [bx + 0x16]                         ; 021BA  0xFF, 0x47, 0x16
  lea dx, [bx + 0x12]                          ; 021BD  0x8D, 0x57, 0x12
  call bdos1_test_chain_head                               ; 021C0  0xE8, 0x37, 0x00
  call bdos1_mxdisk_unsync                               ; 021C3  0xE8, 0x26, 0x00
  xor_bx_bx                                    ; 021C6  xor bx, bx
  ret                                          ; 021C8  0xC3

loc_021C9:  ; 021C9
  call bdos1_mxdisk_unsync                               ; 021C9  0xE8, 0x20, 0x00
  mov bx, 0xffff                               ; 021CC  0xBB, 0xFF, 0xFF
  ret                                          ; 021CF  0xC3

bdos1_lock_disk_cli:  ; 021D0
  pushf                                        ; 021D0  0x9C
  cli                                          ; 021D1  0xFA
  push bx                                      ; 021D2  0x53
  push dx                                      ; 021D3  0x52
  call bdos1_mxdisk_unsync                               ; 021D4  0xE8, 0x15, 0x00
  pop dx                                       ; 021D7  0x5A
  pop bx                                       ; 021D8  0x5B
  call bdos1_fn18_flag_wait                    ; 021D9  0xE8, 0x60, 0xF5
  popf                                         ; 021DC  0x9D
  ret                                          ; 021DD  0xC3

bdos1_mxdisk_sync:  ; 021DE
  push bx                                      ; 021DE  0x53
  push dx                                      ; 021DF  0x52
  call bdos1_fn23_poll_device                  ; 021E0  0xE8, 0x0F, 0xF6
  mov bx, 0x6fd                                ; 021E3  0xBB, 0xFD, 0x06
  call bdos1_fn21_sync                         ; 021E6  0xE8, 0x92, 0xF5
  pop dx                                       ; 021E9  0x5A
  pop bx                                       ; 021EA  0x5B
  ret                                          ; 021EB  0xC3

bdos1_mxdisk_unsync:  ; 021EC
  push bx                                      ; 021EC  0x53
  push cx                                      ; 021ED  0x51
  mov bx, 0x6fd                                ; 021EE  0xBB, 0xFD, 0x06
  call bdos1_fn22_unsync                       ; 021F1  0xE8, 0xA6, 0xF5
  call bdos1_fn24_test_device                  ; 021F4  0xE8, 0x1E, 0xF6
  pop cx                                       ; 021F7  0x59
  pop bx                                       ; 021F8  0x5B
  ret                                          ; 021F9  0xC3

bdos1_test_chain_head:  ; 021FA
  pushf                                        ; 021FA  0x9C
  cli                                          ; 021FB  0xFA
  mov_bx_dx                                    ; 021FC  mov bx, dx
  mov dx, [bx]                                 ; 021FE  0x8B, 0x17
  test dx, dx                                  ; 02200  0x85, 0xD2
  je loc_02210                                 ; 02202  0x74, 0x0C
  push bx                                      ; 02204  0x53
  call bdos1_fn25_chain                        ; 02205  0xE8, 0x09, 0xF6
  pop dx                                       ; 02208  0x5A
  popf                                         ; 02209  0x9D
  mov bx, 0x6fd                                ; 0220A  0xBB, 0xFD, 0x06
  jmp near loc_017D3                           ; 0220D  0xE9, 0xC3, 0xF5

loc_02210:  ; 02210
  popf                                         ; 02210  0x9D
  ret                                          ; 02211  0xC3

bdos1_load_u_wrkseg_fcb:  ; 02212
  push es                                      ; 02212  0x06
  mov es, [es:0x2e]                            ; 02213  0x26, 0x8E, 0x06, 0x2E, 0x00
  mov_bx_dx                                    ; 02218  mov bx, dx
  mov bx, [es:bx + 2]                          ; 0221A  0x26, 0x8B, 0x5F, 0x02
  pop es                                       ; 0221E  0x07
  lea si, [0x74]                               ; 0221F  0x8D, 0x36, 0x74, 0x00

loc_02223:  ; 02223
  mov si, [si]                                 ; 02223  0x8B, 0x34
  test si, si                                  ; 02225  0x85, 0xF6
  je loc_02230                                 ; 02227  0x74, 0x07
  cmp_bx_si                                    ; 02229  cmp bx, si
  jne loc_02223                                ; 0222B  0x75, 0xF6
  xor_cx_cx                                   ; 0222D  xor cx, cx
  ret                                          ; 0222F  0xC3

loc_02230:  ; 02230
  mov cx, 9                                    ; 02230  0xB9, 0x09, 0x00
  ret                                          ; 02233  0xC3

bdos1_get_abs_para_1c:  ; 02234
  push dx                                      ; 02234  0x52
  mov bx, 0x1c                                 ; 02235  0xBB, 0x1C, 0x00
  call bdos1_calc_abs_para                               ; 02238  0xE8, 0x97, 0x00
  jcxz loc_0224E                               ; 0223B  0xE3, 0x11
  mov ax, [es:0x2e]                            ; 0223D  0x26, 0xA1, 0x2E, 0x00
  mov bx, ds                                   ; 02241  0x8C, 0xDB
  sub_ax_bx                                    ; 02243  sub ax, bx
  mov cl, 4                                    ; 02245  0xB1, 0x04
  shl ax, cl                                   ; 02247  0xD3, 0xE0
  pop di                                       ; 02249  0x5F
  add_di_ax                                    ; 0224A  add di, ax
  jmp short loc_0227C                          ; 0224C  0xEB, 0x2E

loc_0224E:  ; 0224E
  mov di, [0x5e]                               ; 0224E  0x8B, 0x3E, 0x5E, 0x00
  test di, di                                  ; 02252  0x85, 0xFF
  jne loc_0225B                                ; 02254  0x75, 0x05
  pop dx                                       ; 02256  0x5A
  mov cx, 7                                    ; 02257  0xB9, 0x07, 0x00
  ret                                          ; 0225A  0xC3

loc_0225B:  ; 0225B
  mov ax, [di]                                 ; 0225B  0x8B, 0x05
  mov [0x5e], ax                               ; 0225D  0xA3, 0x5E, 0x00
  pop si                                       ; 02260  0x5E
  push di                                      ; 02261  0x57
  mov cx, 0xe                                  ; 02262  0xB9, 0x0E, 0x00
  mov ax, ds                                   ; 02265  0x8C, 0xD8
  mov ds, [es:0x2e]                            ; 02267  0x26, 0x8E, 0x1E, 0x2E, 0x00
  push es                                      ; 0226C  0x06
  mov es, ax                                   ; 0226D  0x8E, 0xC0
  rep movsw                                    ; 0226F  0xF3, 0xA5
  mov ax, es                                   ; 02271  0x8C, 0xC0
  mov ds, ax                                   ; 02273  0x8E, 0xD8
  pop es                                       ; 02275  0x07
  pop di                                       ; 02276  0x5F
  or word [di + 4], strict word 0x10          ; 02277  81 4D 04 10 00

loc_0227C:  ; 0227C
  xor_cx_cx                                   ; 0227C  xor cx, cx
  cmp [di + 0x10], cx                          ; 0227E  0x39, 0x4D, 0x10
  jne loc_02288                                ; 02281  0x75, 0x05
  mov cx, 8                                    ; 02283  0xB9, 0x08, 0x00
  jmp short loc_022C8                          ; 02286  0xEB, 0x40

loc_02288:  ; 02288
  test word [di + 4], 1                        ; 02288  0xF7, 0x45, 0x04, 0x01, 0x00
  jne loc_02294                                ; 0228D  0x75, 0x05
  cmp [di + 0xe], cx                           ; 0228F  0x39, 0x4D, 0x0E
  jne loc_02298                                ; 02292  0x75, 0x04

loc_02294:  ; 02294
  mov [di + 0x1A], cx                          ; 02294  0x89, 0x4D, 0x1A
  ret                                          ; 02297  0xC3

loc_02298:  ; 02298
  cmp word [di + 0x1A], 0                      ; 02298  0x83, 0x7D, 0x1A, 0x00
  je loc_022C0                                 ; 0229C  0x74, 0x22
  mov ax, [di + 0xe]                           ; 0229E  0x8B, 0x45, 0x0E
  mul word [byte di + 0x10]                   ; 022A1  mul word p_uda[di]
  mov_bx_ax                                    ; 022A4  mov bx, ax
  mov dx, [di + 0x1A]                          ; 022A6  0x8B, 0x55, 0x1A
  call bdos1_calc_abs_para                               ; 022A9  0xE8, 0x26, 0x00
  jcxz loc_022C0                               ; 022AC  0xE3, 0x12
  mov ax, [es:0x2e]                            ; 022AE  0x26, 0xA1, 0x2E, 0x00
  mov bx, ds                                   ; 022B2  0x8C, 0xDB
  sub_ax_bx                                    ; 022B4  sub ax, bx
  mov cl, 4                                    ; 022B6  0xB1, 0x04
  shl ax, cl                                   ; 022B8  0xD3, 0xE0
  add [di + 0x1A], ax                          ; 022BA  0x01, 0x45, 0x1A
  xor_cx_cx                                   ; 022BD  xor cx, cx
  ret                                          ; 022BF  0xC3

loc_022C0:  ; 022C0
  call bdos1_calc_record_offset                               ; 022C0  0xE8, 0x3F, 0x00
  jcxz loc_022D1                               ; 022C3  0xE3, 0x0C
  mov cx, 8                                    ; 022C5  0xB9, 0x08, 0x00

loc_022C8:  ; 022C8
  mov ax, [0x5e]                               ; 022C8  0xA1, 0x5E, 0x00
  mov [di], ax                                 ; 022CB  0x89, 0x05
  mov [0x5e], di                               ; 022CD  0x89, 0x3E, 0x5E, 0x00

loc_022D1:  ; 022D1
  ret                                          ; 022D1  0xC3

bdos1_calc_abs_para:  ; 022D2
  add_dx_bx                                    ; 022D2  add dx, bx
  jb loc_022FF                                 ; 022D4  0x72, 0x29
  add dx, 0xf                                  ; 022D6  0x83, 0xC2, 0x0F
  mov cl, 4                                    ; 022D9  0xB1, 0x04
  shr dx, cl                                   ; 022DB  0xD3, 0xEA
  add dx, [es:0x2e]                            ; 022DD  0x26, 0x03, 0x16, 0x2E, 0x00
  jb loc_022FF                                 ; 022E2  0x72, 0x1B
  mov ax, [cs:6]                               ; 022E4  0x2E, 0xA1, 0x06, 0x00
  cmp_dx_ax                                    ; 022E8  cmp dx, ax
  jb loc_022FF                                 ; 022EA  0x72, 0x13
  add ax, 0x1000                               ; 022EC  0x05, 0x00, 0x10
  cmp ax, [0x44]                               ; 022EF  0x3B, 0x06, 0x44, 0x00
  jb loc_022F8                                 ; 022F3  0x72, 0x03
  mov ax, [0x44]                               ; 022F5  0xA1, 0x44, 0x00

loc_022F8:  ; 022F8
  cmp_dx_ax                                    ; 022F8  cmp dx, ax
  ja loc_022FF                                 ; 022FA  0x77, 0x03
  mov cl, 1                                    ; 022FC  0xB1, 0x01
  ret                                          ; 022FE  0xC3

loc_022FF:  ; 022FF
  xor_cx_cx                                   ; 022FF  xor cx, cx
  ret                                          ; 02301  0xC3

bdos1_calc_record_offset:  ; 02302
  mov ax, [di + 0xe]                           ; 02302  0x8B, 0x45, 0x0E
  mul word [byte di + 0x10]                   ; 02305  mul word p_uda[di]
  xor_cx_cx                                   ; 02308  xor cx, cx
  push cx                                      ; 0230A  0x51
  push cx                                      ; 0230B  0x51
  push ax                                      ; 0230C  0x50
  push ax                                      ; 0230D  0x50
  push cx                                      ; 0230E  0x51
  mov_dx_sp                                    ; 0230F  mov dx, sp
  mov ax, ss                                   ; 02311  0x8C, 0xD0
  mov ds, ax                                   ; 02313  0x8E, 0xD8
  mov bx, 0x60                                 ; 02315  0xBB, 0x60, 0x00
  push di                                      ; 02318  0x57
  mov cx, 0x309                                ; 02319  0xB9, 0x09, 0x03
  call bdos1_far_call_user                               ; 0231C  0xE8, 0xCD, 0xF3
  pop di                                       ; 0231F  0x5F
  mov ds, [cs:6]                               ; 02320  0x2E, 0x8E, 0x1E, 0x06, 0x00
  cmp cx, 0                                    ; 02325  0x83, 0xF9, 0x00
  jne loc_02332                                ; 02328  0x75, 0x08
  mov_bp_sp                                    ; 0232A  mov bp, sp
  mov ax, [bp]                                 ; 0232C  0x8B, 0x46, 0x00
  mov [di + 0x1A], ax                          ; 0232F  0x89, 0x45, 0x1A

loc_02332:  ; 02332
  add sp, 0xa                                  ; 02332  0x83, 0xC4, 0x0A
  ret                                          ; 02335  0xC3

bdos1_link_free_buffer:  ; 02336
  mov ax, [di + 4]                             ; 02336  0x8B, 0x45, 0x04
  and ax, strict word 0x10                    ; 02339  25 10 00
  je loc_02349                                 ; 0233C  0x74, 0x0B
  mov ax, [0x5e]                               ; 0233E  0xA1, 0x5E, 0x00
  mov [di], ax                                 ; 02341  0x89, 0x05
  mov [0x5e], di                               ; 02343  0x89, 0x3E, 0x5E, 0x00
  jmp short loc_0234A                          ; 02347  0xEB, 0x01

loc_02349:  ; 02349
  ret                                          ; 02349  0xC3

loc_0234A:  ; 0234A
  mov ax, [di + 0x1A]                          ; 0234A  0x8B, 0x45, 0x1A
  mov cx, 0x60                                 ; 0234D  0xB9, 0x60, 0x00
  push ax                                      ; 02350  0x50
  push ax                                      ; 02351  0x50
  push cx                                      ; 02352  0x51
  mov cx, 0x30a                                ; 02353  0xB9, 0x0A, 0x03
  mov_dx_sp                                    ; 02356  mov dx, sp
  mov ax, ss                                   ; 02358  0x8C, 0xD0
  mov ds, ax                                   ; 0235A  0x8E, 0xD8
  call bdos1_far_call_user                               ; 0235C  0xE8, 0x8D, 0xF3
  add sp, 6                                    ; 0235F  0x83, 0xC4, 0x06
  mov ds, [cs:6]                               ; 02362  0x2E, 0x8E, 0x1E, 0x06, 0x00
  ret                                          ; 02367  0xC3

bdos1_fn20_flush_buffers:  ; 02368
  push es                                      ; 02368  0x06
  mov es, [es:0x2e]                            ; 02369  0x26, 0x8E, 0x06, 0x2E, 0x00

loc_0236E:  ; 0236E
  mov_si_dx                                    ; 0236E  mov si, dx
  mov bx, [bx + 2]                             ; 02370  0x8B, 0x5F, 0x02
  cmp bx, 0                                    ; 02373  0x83, 0xFB, 0x00
  je loc_02396                                 ; 02376  0x74, 0x1E
  mov cl, 0                                    ; 02378  0xB1, 0x00
  lea di, [bx + 8]                             ; 0237A  0x8D, 0x7F, 0x08

loc_0237D:  ; 0237D
  cmp cl, 8                                    ; 0237D  0x80, 0xF9, 0x08
  je loc_02391                                 ; 02380  0x74, 0x0F
  mov al, [es:si]                              ; 02382  0x26, 0x8A, 0x04
  sub al, [di]                                 ; 02385  0x2A, 0x05
  shl al, 1                                    ; 02387  0xD0, 0xE0
  jne loc_0236E                                ; 02389  0x75, 0xE3
  inc cl                                       ; 0238B  0xFE, 0xC1
  inc si                                       ; 0238D  0x46
  inc di                                       ; 0238E  0x47
  jmp short loc_0237D                          ; 0238F  0xEB, 0xEC

loc_02391:  ; 02391
  mov cx, 0                                    ; 02391  0xB9, 0x00, 0x00
  jmp short loc_0239C                          ; 02394  0xEB, 0x06

loc_02396:  ; 02396
  mov cx, 0x14                                 ; 02396  0xB9, 0x14, 0x00
  mov bx, 0xffff                               ; 02399  0xBB, 0xFF, 0xFF

loc_0239C:  ; 0239C
  pop es                                       ; 0239C  0x07
  ret                                          ; 0239D  0xC3

bdos1_fn00_disk_reset:  ; 0239E
  xor_dx_dx                                    ; 0239E  xor dx, dx
  mov cx, 0x8f                                 ; 023A0  0xB9, 0x8F, 0x00
  jmp near bdos1_far_call_user                           ; 023A3  0xE9, 0x46, 0xF3

bdos1_fn13_seldisk:  ; 023A6
  mov bx, [0x68]                               ; 023A6  0x8B, 0x1E, 0x68, 0x00
  call bdos1_check_disk_flags                               ; 023AA  0xE8, 0x37, 0x02
  jcxz loc_023B2                               ; 023AD  0xE3, 0x03
  jmp near loc_02446                           ; 023AF  0xE9, 0x94, 0x00

loc_023B2:  ; 023B2
  mov bx, [0x68]                               ; 023B2  0x8B, 0x1E, 0x68, 0x00
  cli                                          ; 023B6  0xFA
  mov ss, [bx + 0x10]                          ; 023B7  0x8E, 0x57, 0x10
  mov sp, 0x100                                ; 023BA  0xBC, 0x00, 0x01
  sti                                          ; 023BD  0xFB
  mov byte [bx + 5], 0x20                      ; 023BE  0xC6, 0x47, 0x05, 0x20
  mov bx, 0x70d                                ; 023C2  0xBB, 0x0D, 0x07
  call bdos1_fn21_sync                         ; 023C5  0xE8, 0xB3, 0xF3
  xor_dx_dx                                    ; 023C8  xor dx, dx
  mov bx, 0x70                                 ; 023CA  0xBB, 0x70, 0x00
  mov ax, [0x68]                               ; 023CD  0xA1, 0x68, 0x00

loc_023D0:  ; 023D0
  mov bx, [bx + 2]                             ; 023D0  0x8B, 0x5F, 0x02
  test bx, bx                                  ; 023D3  0x85, 0xDB
  je loc_023E1                                 ; 023D5  0x74, 0x0A
  cmp [bx + 0x1E], ax                          ; 023D7  0x39, 0x47, 0x1E
  jne loc_023D0                                ; 023DA  0x75, 0xF4
  mov [bx + 0x1E], dx                          ; 023DC  0x89, 0x57, 0x1E
  jmp short loc_023D0                          ; 023DF  0xEB, 0xEF

loc_023E1:  ; 023E1
  mov bx, 0x70d                                ; 023E1  0xBB, 0x0D, 0x07
  call bdos1_fn22_unsync                       ; 023E4  0xE8, 0xB3, 0xF3
  mov bx, [0x68]                               ; 023E7  0x8B, 0x1E, 0x68, 0x00
  test word [bx + 6], 0x80                     ; 023EB  0xF7, 0x47, 0x06, 0x80, 0x00
  je loc_02403                                 ; 023F0  0x74, 0x11
  and word [bx + 6], 0xff7f                    ; 023F2  0x81, 0x67, 0x06, 0x7F, 0xFF
  mov bx, [bx + 0x1E]                          ; 023F7  0x8B, 0x5F, 0x1E
  test bx, bx                                  ; 023FA  0x85, 0xDB
  je loc_02403                                 ; 023FC  0x74, 0x05
  or word [bx + 6], 0x800                      ; 023FE  0x81, 0x4F, 0x06, 0x00, 0x08

loc_02403:  ; 02403
  mov byte [es:0x10], 0xfe                     ; 02403  0x26, 0xC6, 0x06, 0x10, 0x00, 0xFE
  mov cx, 0x78f                                ; 02409  0xB9, 0x8F, 0x07
  call bdos1_far_call_user                               ; 0240C  0xE8, 0xDD, 0xF2
  mov cx, 0x52e                                ; 0240F  0xB9, 0x2E, 0x05
  call bdos1_far_call_user                               ; 02412  0xE8, 0xD7, 0xF2
  mov bx, 0x6fd                                ; 02415  0xBB, 0xFD, 0x06
  call bdos1_fn21_sync                         ; 02418  0xE8, 0x60, 0xF3
  call bdos1_load_rlr_si_74                               ; 0241B  0xE8, 0xEC, 0x01
  mov bx, 0x6fd                                ; 0241E  0xBB, 0xFD, 0x06
  call bdos1_fn22_unsync                       ; 02421  0xE8, 0x76, 0xF3
  mov bx, 0x6f5                                ; 02424  0xBB, 0xF5, 0x06
  call bdos1_fn21_sync                         ; 02427  0xE8, 0x51, 0xF3
  mov byte [0x6f4], 1                          ; 0242A  0xC6, 0x06, 0xF4, 0x06, 0x01
  mov bx, 0x70d                                ; 0242F  0xBB, 0x0D, 0x07
  call bdos1_fn21_sync                         ; 02432  0xE8, 0x46, 0xF3
  mov cx, 0x3a                                 ; 02435  0xB9, 0x3A, 0x00
  call bdos1_far_call_user                               ; 02438  0xE8, 0xB1, 0xF2
  mov bx, [0x68]                               ; 0243B  0x8B, 0x1E, 0x68, 0x00
  mov byte [bx + 4], 4                         ; 0243F  0xC6, 0x47, 0x04, 0x04
  jmp near bdos1_cli_chk_652                           ; 02443  0xE9, 0x6A, 0xF6

loc_02446:  ; 02446
  dec cx                                       ; 02446  0x49
  je loc_0244E                                 ; 02447  0x74, 0x05
  xor_bx_bx                                    ; 02449  xor bx, bx
  mov_cx_bx                                    ; 0244B  mov cx, bx
  ret                                          ; 0244D  0xC3

loc_0244E:  ; 0244E
  mov cx, 0x23                                 ; 0244E  0xB9, 0x23, 0x00
  mov bx, 0xffff                               ; 02451  0xBB, 0xFF, 0xFF
  ret                                          ; 02454  0xC3

bdos1_fn17_time_of_day:  ; 02455
  push dx                                      ; 02455  0x52
  mov bx, 0x70d                                ; 02456  0xBB, 0x0D, 0x07
  call bdos1_fn21_sync                         ; 02459  0xE8, 0x1F, 0xF3
  pop si                                       ; 0245C  0x5E
  push ds                                      ; 0245D  0x1E
  mov ds, [es:0x2e]                            ; 0245E  0x26, 0x8E, 0x1E, 0x2E, 0x00
  mov bx, [si]                                 ; 02463  0x8B, 0x1C
  mov cx, [si + 2]                             ; 02465  0x8B, 0x4C, 0x02
  mov ah, [si + 4]                             ; 02468  0x8A, 0x64, 0x04
  pop ds                                       ; 0246B  0x1F
  push cx                                      ; 0246C  0x51
  test bx, bx                                  ; 0246D  0x85, 0xDB
  je loc_02477                                 ; 0246F  0x74, 0x06
  call bdos1_init_di_70                               ; 02471  0xE8, 0x26, 0x01
  push cx                                      ; 02474  0x51
  jmp short loc_02481                          ; 02475  0xEB, 0x0A

loc_02477:  ; 02477
  add dx, 6                                    ; 02477  0x83, 0xC2, 0x06
  mov bx, 0x70                                 ; 0247A  0xBB, 0x70, 0x00
  call bdos1_zero_cx                               ; 0247D  0xE8, 0x07, 0x01
  push cx                                      ; 02480  0x51

loc_02481:  ; 02481
  push bx                                      ; 02481  0x53
  mov bx, 0x70d                                ; 02482  0xBB, 0x0D, 0x07
  call bdos1_fn22_unsync                       ; 02485  0xE8, 0x12, 0xF3
  pop bx                                       ; 02488  0x5B
  pop cx                                       ; 02489  0x59
  jcxz loc_024F7                               ; 0248A  0xE3, 0x6B
  pop dx                                       ; 0248C  0x5A
  mov ax, [0x68]                               ; 0248D  0xA1, 0x68, 0x00
  cmp_ax_bx                                    ; 02490  cmp ax, bx
  jne loc_02497                                ; 02492  0x75, 0x03
  jmp near bdos1_fn13_seldisk                  ; 02494  0xE9, 0x0F, 0xFF

loc_02497:  ; 02497
  mov byte [0x652], 0xff                       ; 02497  0xC6, 0x06, 0x52, 0x06, 0xFF
  or word [bx + 6], 0x80                       ; 0249C  0x81, 0x4F, 0x06, 0x80, 0x00
  call bdos1_check_disk_flags                               ; 024A1  0xE8, 0x40, 0x01
  jcxz loc_024AB                               ; 024A4  0xE3, 0x05
  call bdos1_wake_next_process                               ; 024A6  0xE8, 0x2B, 0x01
  jmp short loc_02446                          ; 024A9  0xEB, 0x9B

loc_024AB:  ; 024AB
  mov dl, [bx + 4]                             ; 024AB  0x8A, 0x57, 0x04
  mov dh, 0                                    ; 024AE  0xB6, 0x00
  mov_di_dx                                    ; 024B0  mov di, dx
  add_di_di                                    ; 024B2  add di, di
  call word [cs:di + 0xebf]                    ; 024B4  0x2E, 0xFF, 0x95, 0xBF, 0x0E
  call bdos1_wake_next_process                               ; 024B9  0xE8, 0x18, 0x01
  jcxz loc_024F8                               ; 024BC  0xE3, 0x3A
  mov byte [0x652], 0                          ; 024BE  0xC6, 0x06, 0x52, 0x06, 0x00
  mov byte [bx + 5], 0x20                      ; 024C3  0xC6, 0x47, 0x05, 0x20
  push es                                      ; 024C7  0x06
  mov es, [bx + 0x10]                          ; 024C8  0x8E, 0x47, 0x10
  mov si, 0xfe                                 ; 024CB  0xBE, 0xFE, 0x00
  mov [es:0x1c], si                            ; 024CE  0x26, 0x89, 0x36, 0x1C, 0x00
  mov [es:0x1e], es                            ; 024D3  0x26, 0x8C, 0x06, 0x1E, 0x00
  mov word [es:si], 0xd72                      ; 024D8  0x26, 0xC7, 0x04, 0x72, 0x0D
  xor_ax_ax                                    ; 024DD  xor ax, ax
  mov [es:0x4e], ax                            ; 024DF  0x26, 0xA3, 0x4E, 0x00
  mov byte [es:0x1b], 0                        ; 024E3  0x26, 0xC6, 0x06, 0x1B, 0x00, 0x00
  inc byte [es:0x60]                           ; 024E9  0x26, 0xFE, 0x06, 0x60, 0x00
  pop es                                       ; 024EE  0x07
  call bdos1_enqueue_head                               ; 024EF  0xE8, 0x87, 0x00
  xor_bx_bx                                    ; 024F2  xor bx, bx
  jmp near bdos1_set_p_ready                           ; 024F4  0xE9, 0xAF, 0xF5

loc_024F7:  ; 024F7
  pop dx                                       ; 024F7  0x5A

loc_024F8:  ; 024F8
  mov cx, 0x14                                 ; 024F8  0xB9, 0x14, 0x00
  mov bx, 0xffff                               ; 024FB  0xBB, 0xFF, 0xFF
  ret                                          ; 024FE  0xC3
  db 0xD5, 0x0E, 0xE4, 0x0E, 0xF0                                 ; 024FF  .....
  push cs                                      ; 02504  0x0E
  in al, 0xe                                   ; 02505  0xE4, 0x0E
  or [bx], cx                                  ; 02507  0x09, 0x0F
  aad 0x0e                                    ; 02509
  in al, 0xe                                   ; 0250B  0xE4, 0x0E
  in al, 0xe                                   ; 0250D  0xE4, 0x0E
  adc ax, 0xe40f                               ; 0250F  0x15, 0x0F, 0xE4
  push cs                                      ; 02512  0x0E
  in al, 0xe                                   ; 02513  0xE4, 0x0E
  mov di, 0x68                                 ; 02515  0xBF, 0x68, 0x00
  call bdos1_load_si_di                               ; 02518  0xE8, 0x91, 0x00
  jcxz loc_0251F                               ; 0251B  0xE3, 0x02
  jmp short loc_02573                          ; 0251D  0xEB, 0x54

loc_0251F:  ; 0251F
  mov di, 0x6c                                 ; 0251F  0xBF, 0x6C, 0x00
  jmp short loc_0256E                          ; 02522  0xEB, 0x4A
  push es                                      ; 02524  0x06
  mov es, [bx + 0x10]                          ; 02525  0x8E, 0x47, 0x10
  mov di, [es:0]                               ; 02528  0x26, 0x8B, 0x3E, 0x00, 0x00
  pop es                                       ; 0252D  0x07
  jmp short loc_0256E                          ; 0252E  0xEB, 0x3E
  mov di, 0x6a                                 ; 02530  0xBF, 0x6A, 0x00
  call bdos1_load_si_di                               ; 02533  0xE8, 0x76, 0x00
  jcxz loc_02578                               ; 02536  0xE3, 0x40
  mov si, [si]                                 ; 02538  0x8B, 0x34
  test si, si                                  ; 0253A  0x85, 0xF6
  je loc_02547                                 ; 0253C  0x74, 0x09
  mov dx, [si + 0x1A]                          ; 0253E  0x8B, 0x54, 0x1A
  add dx, [bx + 0x1A]                          ; 02541  0x03, 0x57, 0x1A
  mov [si + 0x1A], dx                          ; 02544  0x89, 0x54, 0x1A

loc_02547:  ; 02547
  jmp short loc_02573                          ; 02547  0xEB, 0x2A
  mov byte [0x652], 0                          ; 02549  0xC6, 0x06, 0x52, 0x06, 0x00
  call bdos1_set_p_ready                               ; 0254E  0xE8, 0x55, 0xF5
  xor_cx_cx                                   ; 02551  xor cx, cx
  jmp short loc_02578                          ; 02553  0xEB, 0x23
  xor_cx_cx                                   ; 02555  xor cx, cx
  push es                                      ; 02557  0x06
  mov es, [bx + 0x10]                          ; 02558  0x8E, 0x47, 0x10
  mov di, [es:0]                               ; 0255B  0x26, 0x8B, 0x3E, 0x00, 0x00
  pop es                                       ; 02560  0x07
  cmp bx, [di]                                 ; 02561  0x3B, 0x1D
  jne loc_0256D                                ; 02563  0x75, 0x08
  inc byte [di + 2]                            ; 02565  0xFE, 0x45, 0x02
  mov word [di], 0xffff                        ; 02568  0xC7, 0x05, 0xFF, 0xFF
  inc cx                                       ; 0256C  0x41

loc_0256D:  ; 0256D
  ret                                          ; 0256D  0xC3

loc_0256E:  ; 0256E
  call bdos1_load_si_di                               ; 0256E  0xE8, 0x3B, 0x00
  jcxz loc_02578                               ; 02571  0xE3, 0x05

loc_02573:  ; 02573
  mov dx, [bx]                                 ; 02573  0x8B, 0x17
  mov [di], dx                                 ; 02575  0x89, 0x15
  ret                                          ; 02577  0xC3

loc_02578:  ; 02578
  ret                                          ; 02578  0xC3

bdos1_enqueue_head:  ; 02579
  pushf                                        ; 02579  0x9C
  cli                                          ; 0257A  0xFA
  mov dx, [0x6c]                               ; 0257B  0x8B, 0x16, 0x6C, 0x00
  mov [bx], dx                                 ; 0257F  0x89, 0x17
  mov [0x6c], bx                               ; 02581  0x89, 0x1E, 0x6C, 0x00
  popf                                         ; 02585  0x9D
  ret                                          ; 02586  0xC3

bdos1_zero_cx:  ; 02587
  xor_cx_cx                                   ; 02587  xor cx, cx

loc_02589:  ; 02589
  push ax                                      ; 02589  0x50
  call bdos1_fn20_flush_buffers                ; 0258A  0xE8, 0xDB, 0xFD
  pop ax                                       ; 0258D  0x58
  jcxz loc_02593                               ; 0258E  0xE3, 0x03
  xor_cx_cx                                   ; 02590  xor cx, cx
  ret                                          ; 02592  0xC3

loc_02593:  ; 02593
  cmp [bx + 0x20], ah                          ; 02593  0x38, 0x67, 0x20
  jne loc_02589                                ; 02596  0x75, 0xF1
  inc cx                                       ; 02598  0x41
  ret                                          ; 02599  0xC3

bdos1_init_di_70:  ; 0259A
  xor_cx_cx                                   ; 0259A  xor cx, cx
  mov di, 0x70                                 ; 0259C  0xBF, 0x70, 0x00

loc_0259F:  ; 0259F
  mov di, [di + 2]                             ; 0259F  0x8B, 0x7D, 0x02
  test di, di                                  ; 025A2  0x85, 0xFF
  je loc_025AB                                 ; 025A4  0x74, 0x05
  cmp_bx_di                                    ; 025A6  cmp bx, di
  jne loc_0259F                                ; 025A8  0x75, 0xF5
  inc cx                                       ; 025AA  0x41

loc_025AB:  ; 025AB
  ret                                          ; 025AB  0xC3

bdos1_load_si_di:  ; 025AC
  mov si, [di]                                 ; 025AC  0x8B, 0x35
  xor_cx_cx                                   ; 025AE  xor cx, cx

loc_025B0:  ; 025B0
  test si, si                                  ; 025B0  0x85, 0xF6
  je loc_025BF                                 ; 025B2  0x74, 0x0B
  cmp_si_bx                                    ; 025B4  cmp si, bx
  je loc_025BE                                 ; 025B6  0x74, 0x06
  mov_di_si                                    ; 025B8  mov di, si
  mov si, [si]                                 ; 025BA  0x8B, 0x34
  jmp short loc_025B0                          ; 025BC  0xEB, 0xF2

loc_025BE:  ; 025BE
  inc cx                                       ; 025BE  0x41

loc_025BF:  ; 025BF
  ret                                          ; 025BF  0xC3
  mov cl, [0x4a]                               ; 025C0  0x8A, 0x0E, 0x4A, 0x00
  xor_ch_ch                                    ; 025C4  xor ch, ch
  mov di, [0x56]                               ; 025C6  0x8B, 0x3E, 0x56, 0x00

loc_025CA:  ; 025CA
  cmp bx, [di]                                 ; 025CA  0x3B, 0x1D
  je loc_025D3                                 ; 025CC  0x74, 0x05
  add di, 3                                    ; 025CE  0x83, 0xC7, 0x03
  loop loc_025CA                               ; 025D1  0xE2, 0xF7

loc_025D3:  ; 025D3
  ret                                          ; 025D3  0xC3

bdos1_wake_next_process:  ; 025D4
  mov byte [0x652], 0                          ; 025D4  0xC6, 0x06, 0x52, 0x06, 0x00
  cmp word [0x6c], 0                           ; 025D9  0x83, 0x3E, 0x6C, 0x00, 0x00
  je loc_025E3                                 ; 025DE  0x74, 0x03
  call bdos1_set_p_ready                               ; 025E0  0xE8, 0xC3, 0xF4

loc_025E3:  ; 025E3
  ret                                          ; 025E3  0xC3

bdos1_check_disk_flags:  ; 025E4
  xor_cx_cx                                   ; 025E4  xor cx, cx
  mov ax, [bx + 6]                             ; 025E6  0x8B, 0x47, 0x06
  test ax, 0x200                               ; 025E9  0xA9, 0x00, 0x02
  je loc_025F4                                 ; 025EC  0x74, 0x06
  or ax, 0x80                                  ; 025EE  0x0D, 0x80, 0x00
  dec cx                                       ; 025F1  0x49
  jmp short loc_02606                          ; 025F2  0xEB, 0x12

loc_025F4:  ; 025F4
  test ax, 2                                   ; 025F4  0xA9, 0x02, 0x00
  jne loc_02602                                ; 025F7  0x75, 0x09
  inc dl                                       ; 025F9  0xFE, 0xC2
  je loc_02609                                 ; 025FB  0x74, 0x0C
  test ax, 1                                   ; 025FD  0xA9, 0x01, 0x00
  je loc_02609                                 ; 02600  0x74, 0x07

loc_02602:  ; 02602
  and ax, 0xff7f                               ; 02602  0x25, 0x7F, 0xFF
  inc cx                                       ; 02605  0x41

loc_02606:  ; 02606
  mov [bx + 6], ax                             ; 02606  0x89, 0x47, 0x06

loc_02609:  ; 02609
  ret                                          ; 02609  0xC3

bdos1_load_rlr_si_74:  ; 0260A
  mov bx, [0x68]                               ; 0260A  0x8B, 0x1E, 0x68, 0x00
  mov si, 0x74                                 ; 0260E  0xBE, 0x74, 0x00

loc_02611:  ; 02611
  mov si, [si]                                 ; 02611  0x8B, 0x34
  test si, si                                  ; 02613  0x85, 0xF6
  je loc_02637                                 ; 02615  0x74, 0x20
  test word [si + 4], 1                        ; 02617  0xF7, 0x44, 0x04, 0x01, 0x00
  je loc_02611                                 ; 0261C  0x74, 0xF3
  cmp bx, [si + 0x1A]                          ; 0261E  0x3B, 0x5C, 0x1A
  jne loc_02611                                ; 02621  0x75, 0xEE
  push si                                      ; 02623  0x56
  xor_ax_ax                                    ; 02624  xor ax, ax
  push ax                                      ; 02626  0x50
  mov_dx_sp                                    ; 02627  mov dx, sp
  mov cx, 0x8b                                 ; 02629  0xB9, 0x8B, 0x00
  push ds                                      ; 0262C  0x1E
  push ss                                      ; 0262D  0x16
  pop ds                                       ; 0262E  0x1F
  call bdos1_far_call_user                               ; 0262F  0xE8, 0xBA, 0xF0
  pop ds                                       ; 02632  0x1F
  pop ax                                       ; 02633  0x58
  pop ax                                       ; 02634  0x58
  jmp short bdos1_load_rlr_si_74                          ; 02635  0xEB, 0xD3

loc_02637:  ; 02637
  ret                                          ; 02637  0xC3
  nop                                          ; 02638  0x90
  nop                                          ; 02639  0x90
  nop                                          ; 0263A  0x90
  nop                                          ; 0263B  0x90
  nop                                          ; 0263C  0x90
  nop                                          ; 0263D  0x90
  nop                                          ; 0263E  0x90
  nop                                          ; 0263F  0x90
  nop                                          ; 02640  0x90
  nop                                          ; 02641  0x90
  nop                                          ; 02642  0x90
  nop                                          ; 02643  0x90
  nop                                          ; 02644  0x90
  nop                                          ; 02645  0x90
  nop                                          ; 02646  0x90
  nop                                          ; 02647  0x90
  nop                                          ; 02648  0x90
  nop                                          ; 02649  0x90
  nop                                          ; 0264A  0x90
  nop                                          ; 0264B  0x90
  nop                                          ; 0264C  0x90
  nop                                          ; 0264D  0x90
  nop                                          ; 0264E  0x90
  nop                                          ; 0264F  0x90
  nop                                          ; 02650  0x90
  nop                                          ; 02651  0x90
  nop                                          ; 02652  0x90
  nop                                          ; 02653  0x90
  nop                                          ; 02654  0x90
  nop                                          ; 02655  0x90
  nop                                          ; 02656  0x90
  nop                                          ; 02657  0x90
  nop                                          ; 02658  0x90
  nop                                          ; 02659  0x90
  nop                                          ; 0265A  0x90
  nop                                          ; 0265B  0x90
  nop                                          ; 0265C  0x90
  nop                                          ; 0265D  0x90
  nop                                          ; 0265E  0x90
  nop                                          ; 0265F  0x90
  nop                                          ; 02660  0x90
  nop                                          ; 02661  0x90
  nop                                          ; 02662  0x90
  nop                                          ; 02663  0x90
  nop                                          ; 02664  0x90
  nop                                          ; 02665  0x90
  nop                                          ; 02666  0x90
  nop                                          ; 02667  0x90
  nop                                          ; 02668  0x90
  nop                                          ; 02669  0x90
  nop                                          ; 0266A  0x90
  nop                                          ; 0266B  0x90
  nop                                          ; 0266C  0x90
  nop                                          ; 0266D  0x90
  nop                                          ; 0266E  0x90
  nop                                          ; 0266F  0x90
  nop                                          ; 02670  0x90
  nop                                          ; 02671  0x90
  nop                                          ; 02672  0x90
  nop                                          ; 02673  0x90
  nop                                          ; 02674  0x90
  nop                                          ; 02675  0x90
  nop                                          ; 02676  0x90
  nop                                          ; 02677  0x90
  nop                                          ; 02678  0x90
  nop                                          ; 02679  0x90
  nop                                          ; 0267A  0x90
  nop                                          ; 0267B  0x90
  nop                                          ; 0267C  0x90
  nop                                          ; 0267D  0x90
  nop                                          ; 0267E  0x90
  nop                                          ; 0267F  0x90
  nop                                          ; 02680  0x90
  nop                                          ; 02681  0x90
  nop                                          ; 02682  0x90
  nop                                          ; 02683  0x90
  nop                                          ; 02684  0x90
  nop                                          ; 02685  0x90
  nop                                          ; 02686  0x90
  nop                                          ; 02687  0x90
  nop                                          ; 02688  0x90
  nop                                          ; 02689  0x90
  nop                                          ; 0268A  0x90
  nop                                          ; 0268B  0x90
  nop                                          ; 0268C  0x90
  nop                                          ; 0268D  0x90
  nop                                          ; 0268E  0x90
  nop                                          ; 0268F  0x90
  nop                                          ; 02690  0x90
  nop                                          ; 02691  0x90
  nop                                          ; 02692  0x90
  nop                                          ; 02693  0x90
  nop                                          ; 02694  0x90
  nop                                          ; 02695  0x90
  nop                                          ; 02696  0x90
  nop                                          ; 02697  0x90
  nop                                          ; 02698  0x90
  nop                                          ; 02699  0x90
  nop                                          ; 0269A  0x90
  nop                                          ; 0269B  0x90
  nop                                          ; 0269C  0x90
  nop                                          ; 0269D  0x90
  nop                                          ; 0269E  0x90
  nop                                          ; 0269F  0x90
  nop                                          ; 026A0  0x90
  nop                                          ; 026A1  0x90
  nop                                          ; 026A2  0x90
  nop                                          ; 026A3  0x90
  nop                                          ; 026A4  0x90
  nop                                          ; 026A5  0x90
  nop                                          ; 026A6  0x90
  nop                                          ; 026A7  0x90
  nop                                          ; 026A8  0x90
  nop                                          ; 026A9  0x90
  nop                                          ; 026AA  0x90
  nop                                          ; 026AB  0x90
  nop                                          ; 026AC  0x90
  nop                                          ; 026AD  0x90
  nop                                          ; 026AE  0x90
  nop                                          ; 026AF  0x90
  nop                                          ; 026B0  0x90
  nop                                          ; 026B1  0x90
  nop                                          ; 026B2  0x90
  nop                                          ; 026B3  0x90
  nop                                          ; 026B4  0x90
  nop                                          ; 026B5  0x90
  nop                                          ; 026B6  0x90
  nop                                          ; 026B7  0x90
  db 0x00, 0x00                               ; 026B8
  db 0x00, 0x00                               ; 026BA
  db 0x00, 0x00                               ; 026BC
  db 0x00, 0x00                               ; 026BE
