; =============================================================================
; ccpm.sys — Modul 1: BDOS File System
; Offset range: 0x01640 - 0x026C0
; =============================================================================

  db 0x48                                     ; 01641  dec ax
  db 0x00, 0xE9                               ; 01642  add cl, ch
  db 0x9A, 0x00, 0xFA, 0x06, 0x03             ; 01644  call far 0x306, 0xfa00
  db 0x00, 0x48, 0x00                         ; 01649  add byte [bx + si], cl
  db 0x06                                     ; 0164C  push es
  db 0x43                                     ; 0164D  inc bx
  db 0x4F                                     ; 0164E  dec di

loc_0164F:  ; 0164F
  db 0x50                                     ; 0164F  push ax
  db 0x59                                     ; 01650  pop cx
  db 0x52                                     ; 01651  push dx
  db 0x49                                     ; 01652  dec cx
  db 0x47                                     ; 01653  inc di
  db 0x48                                     ; 01654  dec ax
  db 0x54                                     ; 01655  push sp
  db 0x20, 0x28                               ; 01656  and byte [bx + si], ch
  db 0x43                                     ; 01658  inc bx
  db 0x29, 0x20                               ; 01659  sub word [bx + si], sp
  db 0x31, 0x39                               ; 0165B  xor word [bx + di], di
  db 0x38, 0x32                               ; 0165D  cmp byte [bp + si], dh
  db 0x2C, 0x31                               ; 0165F  sub al, 0x31
  db 0x39, 0x38                               ; 01661  cmp word [bx + si], di
  db 0x33, 0x2C                               ; 01663  xor bp, word [si]
  db 0x31, 0x39                               ; 01665  xor word [bx + di], di
  db 0x38, 0x34                               ; 01667  cmp byte [si], dh

loc_01669:  ; 01669
  db 0x20, 0x44, 0x49                         ; 01669  and byte [si + 0x49], al
  db 0x47                                     ; 0166C  inc di
  db 0x49                                     ; 0166D  dec cx
  db 0x54                                     ; 0166E  push sp
  db 0x41                                     ; 0166F  inc cx
  db 0x4C                                     ; 01670  dec sp
  db 0x20, 0x52, 0x45                         ; 01671  and byte [bp + si + 0x45], dl
  db 0x53                                     ; 01674  push bx
  db 0x45                                     ; 01675  inc bp
  db 0x41                                     ; 01676  inc cx

loc_01677:  ; 01677
  db 0x52                                     ; 01677  push dx
  db 0x43                                     ; 01678  inc bx
  db 0x48                                     ; 01679  dec ax
  db 0x20, 0x31                               ; 0167A  and byte [bx + di], dh
  db 0x30, 0x33                               ; 0167C  xor byte [bp + di], dh
  db 0x34, 0x2D                               ; 0167E  xor al, 0x2d

loc_01680:  ; 01680
  db 0x30, 0x32                               ; 01680  xor byte [bp + si], dh
  db 0x36, 0x31, 0x2D                         ; 01682  xor word [ss:di], bp
  db 0x30, 0x30                               ; 01685  xor byte [bx + si], dh
  db 0x37                                     ; 01687  aaa
  db 0x30, 0x34                               ; 01688  xor byte [si], dh

loc_0168A:  ; 0168A
  db 0x31                                                         ; 0168A  1

mod1_bdos1_init:  ; 0168B
  db 0xBB, 0x38, 0x00                         ; 0168B  mov bx, 0x38
  db 0xC7, 0x07, 0xE2, 0x03                   ; 0168E  mov word [bx], 0x3e2
  db 0x8C, 0x4F, 0x02                         ; 01692  mov word [bx + 2], cs
  db 0xBB, 0x3C, 0x00                         ; 01695  mov bx, 0x3c
  db 0xC7, 0x07, 0x62, 0x04                   ; 01698  mov word [bx], 0x462
  db 0x8C, 0x4F, 0x02                         ; 0169C  mov word [bx + 2], cs
  db 0x8B, 0x1E, 0x68, 0x00                   ; 0169F  mov bx, word [0x68]
  db 0xC7, 0x47, 0x28, 0x5B, 0x05             ; 016A3  mov word p_userdisp[bx], 0x55b
  db 0x8C, 0x4F, 0x2A                         ; 016A8  mov word [bx + 0x2a], cs
  db 0xCB                                     ; 016AB  retf

bdos1_dispatch_table:  ; 016AC
  db 0x5E                                     ; 016AC  pop si
  db 0x0D, 0xB9, 0x00                         ; 016AD  or ax, 0xb9
  db 0x01, 0x09                               ; 016B0  add word [bx + di], cx
  db 0x81, 0x08, 0x5C, 0x09                   ; 016B2  or word [bx + si], 0x95c
  db 0xB2, 0x09                               ; 016B6  mov dl, 9
  db 0x05, 0x0A, 0x6B                         ; 016B8  add ax, 0x6b0a
  db 0x0A, 0x6F, 0x0A                         ; 016BB  or ch, byte [bx + 0xa]
  db 0xFA                                     ; 016BE  cli
  db 0x0A, 0xFE                               ; 016BF  or bh, dh
  db 0x0A, 0xC9                               ; 016C1  or cl, cl
  db 0x00, 0xDB                               ; 016C3  add bl, bl
  db 0x00, 0x66, 0x0D                         ; 016C5  add byte [bp + 0xd], ah
  db 0xF6, 0x00, 0xE0                         ; 016C8  test byte [bx + si], 0xe0
  db 0x00, 0xEC                               ; 016CB  add ah, ch
  db 0x00, 0x15                               ; 016CD  add byte [di], dl
  db 0x0E                                     ; 016CF  push cs
  db 0xFC                                     ; 016D0  cld
  db 0x00, 0x13                               ; 016D1  add byte [bp + di], dl
  db 0x01, 0x28                               ; 016D3  add word [bx + si], bp
  db 0x0D, 0x3B, 0x01                         ; 016D5  or ax, 0x13b
  db 0x5A                                     ; 016D8  pop dx
  db 0x01, 0xB2, 0x01, 0xD5                   ; 016D9  add word [bp + si - 0x2aff], si
  db 0x01, 0xD1                               ; 016DD  add cx, dx
  db 0x01                                                         ; 016DF  .

mod1_bdos1_entry:  ; 016E0
  db 0x32, 0xED                               ; 016E0  xor ch, ch
  db 0xD1, 0xE1                               ; 016E2  shl cx, 1
  db 0x8B, 0xF1                               ; 016E4  mov si, cx
  db 0x2E, 0xFF, 0x94, 0x6C, 0x00             ; 016E6  call word [cs:si + 0x6c]
  db 0xCB                                     ; 016EB  retf

bdos1_far_call_user:  ; 016EC
  db 0x2E, 0xFF, 0x1E, 0x08, 0x00             ; 016EC  call far [cs:8]
  db 0xC3                                     ; 016F1  ret

bdos1_userdisp_call:  ; 016F2
  db 0xBE, 0x00, 0x00                         ; 016F2  mov si, 0
  db 0xFF, 0x5C, 0x28                         ; 016F5  call far p_userdisp[si]
  db 0xC3                                     ; 016F8  ret

bdos1_fn01_queue_read:  ; 016F9
  db 0xA1, 0x68, 0x00                         ; 016F9  mov ax, word [0x68]
  db 0x8B, 0xD8                               ; 016FC  mov bx, ax
  db 0x89, 0x57, 0x1A                         ; 016FE  mov word p_wait[bx], dx
  db 0xBA, 0x6E, 0x00                         ; 01701  mov dx, 0x6e
  db 0xB3, 0x01                               ; 01704  mov bl, 1
  jmp near bdos1_fn18_flag_wait                ; 01706  0xE9, 0x33, 0x00

bdos1_fn11_delay:  ; 01709
  db 0x8B, 0x1E, 0x68, 0x00                   ; 01709  mov bx, word [0x68]
  db 0xC6, 0x47, 0x04, 0x02                   ; 0170D  mov byte [bx + 4], 2
  db 0x26, 0x89, 0x16, 0x00, 0x00             ; 01711  mov word [es:0], dx
  db 0x33, 0xDB                               ; 01716  xor bx, bx
  jmp near bdos1_cli_chk_652                           ; 01718  0xE9, 0x95, 0x03

bdos1_fn12_nop:  ; 0171B
  db 0x33, 0xDB                               ; 0171B  xor bx, bx
  jmp near bdos1_set_p_ready                           ; 0171D  0xE9, 0x86, 0x03

bdos1_fn15_set_priority:  ; 01720
  db 0x8B, 0x1E, 0x68, 0x00                   ; 01720  mov bx, word [0x68]
  db 0x88, 0x57, 0x05                         ; 01724  mov byte [bx + 5], dl
  db 0x33, 0xDB                               ; 01727  xor bx, bx
  jmp near bdos1_set_p_ready                           ; 01729  0xE9, 0x7A, 0x03

bdos1_fn16_get_pd:  ; 0172C
  db 0x26, 0x8C, 0x1E, 0x30, 0x00             ; 0172C  mov word [es:0x30], ds

bdos1_func24_get_dlog:  ; 01731
  db 0x8B, 0x1E, 0x68, 0x00                   ; 01731  mov bx, word [0x68]
  db 0xC3                                     ; 01735  ret

bdos1_fn14_dispatch:  ; 01736
  call bdos1_check_dx                               ; 01736  0xE8, 0x37, 0x01
  jmp near bdos1_set_p_ready                           ; 01739  0xE9, 0x6A, 0x03

bdos1_fn18_flag_wait:  ; 0173C
  db 0xA1, 0x68, 0x00                         ; 0173C  mov ax, word [0x68]
  db 0x8B, 0xF0                               ; 0173F  mov si, ax
  db 0x8B, 0xC2                               ; 01741  mov ax, dx
  db 0x26, 0xA3, 0x00, 0x00                   ; 01743  mov word [es:0], ax
  db 0x88, 0x5C, 0x2E                         ; 01747  mov byte p_scratch[si], bl
  db 0xC6, 0x44, 0x04, 0x05                   ; 0174A  mov byte [si + 4], 5
  db 0x33, 0xDB                               ; 0174E  xor bx, bx
  jmp near bdos1_cli_chk_652                           ; 01750  0xE9, 0x5D, 0x03

bdos1_fn19_flag_set:  ; 01753
  db 0x9C                                     ; 01753  pushf
  db 0xFA                                     ; 01754  cli
  db 0x8B, 0xDA                               ; 01755  mov bx, dx
  db 0x8B, 0x37                               ; 01757  mov si, word [bx]
  db 0x85, 0xF6                               ; 01759  test si, si
  je loc_01779                                 ; 0175B  0x74, 0x1C
  db 0x8B, 0x04                               ; 0175D  mov ax, word [si]
  db 0x89, 0x07                               ; 0175F  mov word [bx], ax
  db 0xBF, 0x6C, 0x00                         ; 01761  mov di, 0x6c
  db 0x33, 0xC0                               ; 01764  xor ax, ax

loc_01766:  ; 01766
  db 0x39, 0x05                               ; 01766  cmp word [di], ax
  je loc_0176E                                 ; 01768  0x74, 0x04
  db 0x8B, 0x3D                               ; 0176A  mov di, word [di]
  jmp short loc_01766                          ; 0176C  0xEB, 0xF8

loc_0176E:  ; 0176E
  db 0x89, 0x35                               ; 0176E  mov word [di], si
  db 0x89, 0x04                               ; 01770  mov word [si], ax
  db 0xC6, 0x44, 0x04, 0x00                   ; 01772  mov byte [si + 4], 0
  call bdos1_set_p_ready                               ; 01776  0xE8, 0x2D, 0x03

loc_01779:  ; 01779
  db 0x9D                                     ; 01779  popf
  db 0xC3                                     ; 0177A  ret

bdos1_fn21_sync:  ; 0177B
  db 0xA1, 0x68, 0x00                         ; 0177B  mov ax, word [0x68]
  db 0x8B, 0xF0                               ; 0177E  mov si, ax
  db 0x9C                                     ; 01780  pushf
  db 0xFA                                     ; 01781  cli
  db 0x87, 0x47, 0x02                         ; 01782  xchg word [bx + 2], ax
  db 0x85, 0xC0                               ; 01785  test ax, ax
  je loc_01798                                 ; 01787  0x74, 0x0F
  db 0x3B, 0xC6                               ; 01789  cmp ax, si
  je loc_01798                                 ; 0178B  0x74, 0x0B
  db 0x89, 0x47, 0x02                         ; 0178D  mov word [bx + 2], ax
  db 0x8D, 0x57, 0x04                         ; 01790  lea dx, [bx + 4]
  db 0xB3, 0x0A                               ; 01793  mov bl, 0xa
  call bdos1_fn18_flag_wait                    ; 01795  0xE8, 0xA4, 0xFF

loc_01798:  ; 01798
  db 0x9D                                     ; 01798  popf
  db 0xC3                                     ; 01799  ret

bdos1_fn22_unsync:  ; 0179A
  db 0xA1, 0x68, 0x00                         ; 0179A  mov ax, word [0x68]
  db 0x3B, 0x47, 0x02                         ; 0179D  cmp ax, word [bx + 2]
  jne loc_017D2                                ; 017A0  0x75, 0x30
  db 0x33, 0xC0                               ; 017A2  xor ax, ax
  db 0x9C                                     ; 017A4  pushf
  db 0xFA                                     ; 017A5  cli
  db 0x87, 0x47, 0x06                         ; 017A6  xchg word [bx + 6], ax
  db 0x85, 0xC0                               ; 017A9  test ax, ax
  je loc_017B1                                 ; 017AB  0x74, 0x04
  db 0x8B, 0xF0                               ; 017AD  mov si, ax
  jmp short loc_017C1                          ; 017AF  0xEB, 0x10

loc_017B1:  ; 017B1
  db 0x8B, 0x77, 0x04                         ; 017B1  mov si, word [bx + 4]
  db 0x85, 0xF6                               ; 017B4  test si, si
  je loc_017CE                                 ; 017B6  0x74, 0x16
  db 0x8B, 0x04                               ; 017B8  mov ax, word [si]
  db 0x89, 0x47, 0x04                         ; 017BA  mov word [bx + 4], ax
  db 0xC7, 0x04, 0x00, 0x00                   ; 017BD  mov word [si], 0

loc_017C1:  ; 017C1
  db 0xC6, 0x44, 0x04, 0x00                   ; 017C1  mov byte [si + 4], 0
  db 0xA1, 0x6C, 0x00                         ; 017C5  mov ax, word [0x6c]
  db 0x89, 0x04                               ; 017C8  mov word [si], ax
  db 0x89, 0x36, 0x6C, 0x00                   ; 017CA  mov word [0x6c], si

loc_017CE:  ; 017CE
  db 0x89, 0x77, 0x02                         ; 017CE  mov word [bx + 2], si
  db 0x9D                                     ; 017D1  popf

loc_017D2:  ; 017D2
  db 0xC3                                     ; 017D2  ret

loc_017D3:  ; 017D3
  db 0xA1, 0x68, 0x00                         ; 017D3  mov ax, word [0x68]
  db 0x39, 0x47, 0x02                         ; 017D6  cmp word [bx + 2], ax
  jne loc_017F1                                ; 017D9  0x75, 0x16
  db 0x8B, 0xF2                               ; 017DB  mov si, dx
  db 0x9C                                     ; 017DD  pushf
  db 0xFA                                     ; 017DE  cli
  db 0x8B, 0x3C                               ; 017DF  mov di, word [si]
  db 0x85, 0xFF                               ; 017E1  test di, di
  je loc_017F0                                 ; 017E3  0x74, 0x0B
  db 0x8B, 0x05                               ; 017E5  mov ax, word [di]
  db 0x89, 0x04                               ; 017E7  mov word [si], ax
  db 0xC7, 0x05, 0x00, 0x00                   ; 017E9  mov word [di], 0
  db 0x89, 0x7F, 0x06                         ; 017ED  mov word [bx + 6], di

loc_017F0:  ; 017F0
  db 0x9D                                     ; 017F0  popf

loc_017F1:  ; 017F1
  db 0xC3                                     ; 017F1  ret

bdos1_fn23_poll_device:  ; 017F2
  db 0xA1, 0x68, 0x00                         ; 017F2  mov ax, word [0x68]
  db 0x8B, 0xF0                               ; 017F5  mov si, ax

loc_017F7:  ; 017F7
  db 0x80, 0x7C, 0x19, 0x00                   ; 017F7  cmp byte p_tkcnt[si], 0
  jne loc_01808                                ; 017FB  0x75, 0x0B
  db 0xF7, 0x44, 0x06, 0x00, 0x02             ; 017FD  test word [si + 6], 0x200
  je loc_01808                                 ; 01802  0x74, 0x04
  db 0x80, 0x4C, 0x19, 0x80                   ; 01804  or byte p_tkcnt[si], 0x80

loc_01808:  ; 01808
  db 0x81, 0x4C, 0x06, 0x00, 0x02             ; 01808  or word [si + 6], 0x200
  db 0xFE, 0x44, 0x19                         ; 0180D  inc byte p_tkcnt[si]
  db 0xC3                                     ; 01810  ret

bdos1_fn25_chain:  ; 01811
  db 0x8B, 0xF2                               ; 01811  mov si, dx
  jmp short loc_017F7                          ; 01813  0xEB, 0xE2

bdos1_fn24_test_device:  ; 01815
  db 0xA1, 0x68, 0x00                         ; 01815  mov ax, word [0x68]
  db 0x8B, 0xF0                               ; 01818  mov si, ax
  db 0x8A, 0x44, 0x19                         ; 0181A  mov al, byte p_tkcnt[si]
  db 0x24, 0x7F                               ; 0181D  and al, 0x7f
  db 0xFE, 0xC8                               ; 0181F  dec al
  je loc_01827                                 ; 01821  0x74, 0x04
  db 0xFE, 0x4C, 0x19                         ; 01823  dec byte p_tkcnt[si]
  db 0xC3                                     ; 01826  ret

loc_01827:  ; 01827
  db 0x80, 0x64, 0x19, 0x80                   ; 01827  and byte p_tkcnt[si], 0x80
  jne loc_01841                                ; 0182B  0x75, 0x14
  db 0x81, 0x64, 0x06, 0xFF, 0xFD             ; 0182D  and word [si + 6], 0xfdff
  db 0xF7, 0x44, 0x06, 0x80, 0x00             ; 01832  test word [si + 6], 0x80
  je loc_01841                                 ; 01837  0x74, 0x08
  db 0xBA, 0xFF, 0xFF                         ; 01839  mov dx, 0xffff
  db 0x56                                     ; 0183C  push si
  call bdos1_fn13_seldisk                      ; 0183D  0xE8, 0x66, 0x0B
  db 0x5E                                     ; 01840  pop si

loc_01841:  ; 01841
  db 0xC6, 0x44, 0x19, 0x00                   ; 01841  mov byte p_tkcnt[si], 0
  db 0xC3                                     ; 01845  ret

bdos1_set_di_70:  ; 01846
  db 0xBF, 0x70, 0x00                         ; 01846  mov di, 0x70

loc_01849:  ; 01849
  db 0x8B, 0x5D, 0x02                         ; 01849  mov bx, word [di + 2]
  db 0x3B, 0xDE                               ; 0184C  cmp bx, si
  je loc_01854                                 ; 0184E  0x74, 0x04
  db 0x8B, 0xFB                               ; 01850  mov di, bx
  jmp short loc_01849                          ; 01852  0xEB, 0xF5

loc_01854:  ; 01854
  db 0x8B, 0x44, 0x02                         ; 01854  mov ax, word [si + 2]
  db 0x89, 0x45, 0x02                         ; 01857  mov word [di + 2], ax
  db 0x8B, 0x44, 0x06                         ; 0185A  mov ax, word [si + 6]
  db 0x25, 0x10, 0x00                         ; 0185D  and ax, 0x10
  db 0x3D, 0x00, 0x00                         ; 01860  cmp ax, 0
  je loc_0186F                                 ; 01863  0x74, 0x0A
  db 0x8B, 0x1E, 0x5C, 0x00                   ; 01865  mov bx, word [0x5c]
  db 0x89, 0x1C                               ; 01869  mov word [si], bx
  db 0x89, 0x36, 0x5C, 0x00                   ; 0186B  mov word [0x5c], si

loc_0186F:  ; 0186F
  db 0xC3                                     ; 0186F  ret

bdos1_check_dx:  ; 01870
  db 0x83, 0xFA, 0x00                         ; 01870  cmp dx, 0
  jne loc_01878                                ; 01873  0x75, 0x03
  db 0x2B, 0xDB                               ; 01875  sub bx, bx
  db 0xC3                                     ; 01877  ret

loc_01878:  ; 01878
  call bdos1_get_abs_para_30                               ; 01878  0xE8, 0x5D, 0x01
  jcxz loc_01881                               ; 0187B  0xE3, 0x04
  db 0xBB, 0xFF, 0xFF                         ; 0187D  mov bx, 0xffff
  db 0xC3                                     ; 01880  ret

loc_01881:  ; 01881
  db 0x8B, 0x14                               ; 01881  mov dx, word [si]
  db 0x52                                     ; 01883  push dx
  db 0x56                                     ; 01884  push si
  db 0x8B, 0x1E, 0x68, 0x00                   ; 01885  mov bx, word [0x68]
  db 0x89, 0x5C, 0x1E                         ; 01889  mov word p_parent[si], bx
  db 0xC7, 0x44, 0x22, 0x00, 0x00             ; 0188C  mov word p_conmode[si], 0
  db 0xC6, 0x44, 0x19, 0x00                   ; 01891  mov byte p_tkcnt[si], 0
  db 0x81, 0x67, 0x06, 0xDF, 0xF7             ; 01895  and word [bx + 6], 0xf7df
  db 0x8A, 0x44, 0x24                         ; 0189A  mov al, byte p_lst[si]
  db 0x88, 0x44, 0x24                         ; 0189D  mov byte p_lst[si], al
  db 0xC7, 0x44, 0x28, 0x5B, 0x05             ; 018A0  mov word p_userdisp[si], 0x55b
  db 0x8C, 0x4C, 0x2A                         ; 018A5  mov word [si + 0x2a], cs
  db 0x83, 0x7F, 0x16, 0x00                   ; 018A8  cmp word p_mem[bx], 0
  je loc_018D8                                 ; 018AC  0x74, 0x2A
  db 0x83, 0x7C, 0x16, 0x00                   ; 018AE  cmp word p_mem[si], 0
  jne loc_018D8                                ; 018B2  0x75, 0x24
  db 0x8D, 0x7F, 0x16                         ; 018B4  lea di, p_mem[bx]

loc_018B7:  ; 018B7
  db 0x8B, 0x3D                               ; 018B7  mov di, word [di]
  db 0x83, 0xFF, 0x00                         ; 018B9  cmp di, 0
  je loc_018D8                                 ; 018BC  0x74, 0x1A
  db 0x57                                     ; 018BE  push di
  db 0xFF, 0x75, 0x02                         ; 018BF  push word [di + 2]
  db 0x56                                     ; 018C2  push si
  db 0x53                                     ; 018C3  push bx
  db 0xB9, 0x08, 0x03                         ; 018C4  mov cx, 0x308
  db 0x8B, 0xD4                               ; 018C7  mov dx, sp
  db 0x1E                                     ; 018C9  push ds
  db 0x8C, 0xD0                               ; 018CA  mov ax, ss
  db 0x8E, 0xD8                               ; 018CC  mov ds, ax
  call bdos1_far_call_user                               ; 018CE  0xE8, 0x1B, 0xFE
  db 0x1F                                     ; 018D1  pop ds
  db 0x5B                                     ; 018D2  pop bx
  db 0x5E                                     ; 018D3  pop si
  db 0x58                                     ; 018D4  pop ax
  db 0x5F                                     ; 018D5  pop di
  jmp short loc_018B7                          ; 018D6  0xEB, 0xDF

loc_018D8:  ; 018D8
  db 0x26, 0xA1, 0x2E, 0x00                   ; 018D8  mov ax, word [es:0x2e]
  db 0x8B, 0x54, 0x10                         ; 018DC  mov dx, word p_uda[si]
  db 0x03, 0xD0                               ; 018DF  add dx, ax
  db 0x89, 0x54, 0x10                         ; 018E1  mov word p_uda[si], dx
  db 0x06                                     ; 018E4  push es
  db 0x1E                                     ; 018E5  push ds
  db 0x8C, 0xC1                               ; 018E6  mov cx, es
  db 0x8E, 0xC2                               ; 018E8  mov es, dx
  db 0x8E, 0xD9                               ; 018EA  mov ds, cx
  db 0xBE, 0x12, 0x00                         ; 018EC  mov si, 0x12
  db 0x8B, 0xFE                               ; 018EF  mov di, si
  db 0xB9, 0x04, 0x00                         ; 018F1  mov cx, 4
  db 0xF3, 0xA5                               ; 018F4  rep movsw
  db 0x8E, 0xDA                               ; 018F6  mov ds, dx
  db 0x33, 0xD2                               ; 018F8  xor dx, dx
  db 0x39, 0x16, 0x50, 0x00                   ; 018FA  cmp word [0x50], dx
  jne loc_01903                                ; 018FE  0x75, 0x03
  db 0xA3, 0x50, 0x00                         ; 01900  mov word [0x50], ax

loc_01903:  ; 01903
  db 0x39, 0x16, 0x52, 0x00                   ; 01903  cmp word [0x52], dx
  jne loc_0190C                                ; 01907  0x75, 0x03
  db 0xA3, 0x52, 0x00                         ; 01909  mov word [0x52], ax

loc_0190C:  ; 0190C
  db 0x39, 0x16, 0x56, 0x00                   ; 0190C  cmp word [0x56], dx
  jne loc_01915                                ; 01910  0x75, 0x03
  db 0xA3, 0x56, 0x00                         ; 01912  mov word [0x56], ax

loc_01915:  ; 01915
  db 0x39, 0x16, 0x54, 0x00                   ; 01915  cmp word [0x54], dx
  jne loc_0191E                                ; 01919  0x75, 0x03
  db 0xA3, 0x54, 0x00                         ; 0191B  mov word [0x54], ax

loc_0191E:  ; 0191E
  db 0x8E, 0xDA                               ; 0191E  mov ds, dx
  db 0x8B, 0xF2                               ; 01920  mov si, dx
  db 0xBF, 0x38, 0x00                         ; 01922  mov di, 0x38
  call bdos1_copy_fcb_words                               ; 01925  0xE8, 0x98, 0x00
  call bdos1_copy_fcb_words                               ; 01928  0xE8, 0x95, 0x00
  db 0x83, 0xC6, 0x04                         ; 0192B  add si, 4
  db 0x83, 0xC7, 0x04                         ; 0192E  add di, 4
  call bdos1_copy_fcb_words                               ; 01931  0xE8, 0x8C, 0x00
  call bdos1_copy_fcb_words                               ; 01934  0xE8, 0x89, 0x00
  db 0xBE, 0x80, 0x03                         ; 01937  mov si, 0x380
  db 0xBF, 0x58, 0x00                         ; 0193A  mov di, 0x58
  call bdos1_copy_fcb_words                               ; 0193D  0xE8, 0x80, 0x00
  call bdos1_copy_fcb_words                               ; 01940  0xE8, 0x7D, 0x00
  db 0x06                                     ; 01943  push es
  db 0x1F                                     ; 01944  pop ds
  db 0xA1, 0x56, 0x00                         ; 01945  mov ax, word [0x56]
  db 0xA3, 0x1E, 0x00                         ; 01948  mov word [0x1e], ax
  db 0xA1, 0x34, 0x00                         ; 0194B  mov ax, word [0x34]
  db 0xA3, 0x1C, 0x00                         ; 0194E  mov word [0x1c], ax
  db 0x33, 0xD2                               ; 01951  xor dx, dx
  db 0xC6, 0x06, 0x66, 0x00, 0x24             ; 01953  mov byte [0x66], 0x24
  db 0x88, 0x16, 0x10, 0x00                   ; 01958  mov byte [0x10], dl
  db 0x88, 0x16, 0x1A, 0x00                   ; 0195C  mov byte [0x1a], dl
  db 0xC6, 0x06, 0x11, 0x00, 0x01             ; 01960  mov byte [0x11], 1
  db 0xC6, 0x06, 0x1B, 0x00, 0xFF             ; 01965  mov byte [0x1b], 0xff
  db 0x8B, 0x1E, 0x52, 0x00                   ; 0196A  mov bx, word [0x52]
  db 0x89, 0x1E, 0x32, 0x00                   ; 0196E  mov word [0x32], bx
  db 0x89, 0x1E, 0x04, 0x00                   ; 01972  mov word [4], bx
  db 0xA1, 0x54, 0x00                         ; 01976  mov ax, word [0x54]
  db 0xA3, 0x4C, 0x00                         ; 01979  mov word [0x4c], ax
  db 0x89, 0x16, 0x00, 0x00                   ; 0197C  mov word [0], dx
  db 0x89, 0x16, 0x4E, 0x00                   ; 01980  mov word [0x4e], dx
  db 0x89, 0x16, 0x62, 0x00                   ; 01984  mov word [0x62], dx
  db 0x89, 0x16, 0x64, 0x00                   ; 01988  mov word [0x64], dx
  db 0x8E, 0x1E, 0x1E, 0x00                   ; 0198C  mov ds, word [0x1e]
  db 0x26, 0x8B, 0x3E, 0x1C, 0x00             ; 01990  mov di, word [es:0x1c]
  db 0x26, 0xA1, 0x50, 0x00                   ; 01995  mov ax, word [es:0x50]
  db 0x89, 0x45, 0x02                         ; 01999  mov word [di + 2], ax
  db 0xC7, 0x45, 0x04, 0x00, 0x02             ; 0199C  mov word [di + 4], 0x200
  db 0x1F                                     ; 019A1  pop ds
  db 0x07                                     ; 019A2  pop es
  db 0x5E                                     ; 019A3  pop si
  db 0x9C                                     ; 019A4  pushf
  db 0xFA                                     ; 019A5  cli
  db 0x8B, 0x16, 0x72, 0x00                   ; 019A6  mov dx, word [0x72]
  db 0x89, 0x54, 0x02                         ; 019AA  mov word [si + 2], dx
  db 0x89, 0x36, 0x72, 0x00                   ; 019AD  mov word [0x72], si
  db 0x8B, 0x16, 0x6C, 0x00                   ; 019B1  mov dx, word [0x6c]
  db 0x89, 0x14                               ; 019B5  mov word [si], dx
  db 0x89, 0x36, 0x6C, 0x00                   ; 019B7  mov word [0x6c], si
  db 0x9D                                     ; 019BB  popf
  db 0x5A                                     ; 019BC  pop dx
  jmp near bdos1_check_dx                           ; 019BD  0xE9, 0xB0, 0xFE

bdos1_copy_fcb_words:  ; 019C0
  db 0x26, 0x39, 0x15                         ; 019C0  cmp word [es:di], dx
  jne loc_019D1                                ; 019C3  0x75, 0x0C
  db 0x26, 0x39, 0x55, 0x02                   ; 019C5  cmp word [es:di + 2], dx
  jne loc_019D1                                ; 019C9  0x75, 0x06
  db 0xB9, 0x02, 0x00                         ; 019CB  mov cx, 2
  db 0xF3, 0xA5                               ; 019CE  rep movsw
  db 0xC3                                     ; 019D0  ret

loc_019D1:  ; 019D1
  db 0x83, 0xC6, 0x04                         ; 019D1  add si, 4
  db 0x83, 0xC7, 0x04                         ; 019D4  add di, 4
  db 0xC3                                     ; 019D7  ret

bdos1_get_abs_para_30:  ; 019D8
  db 0x52                                     ; 019D8  push dx
  db 0xBB, 0x30, 0x00                         ; 019D9  mov bx, 0x30
  call bdos1_calc_abs_para                               ; 019DC  0xE8, 0xF3, 0x08
  jcxz loc_019F2                               ; 019DF  0xE3, 0x11
  db 0x26, 0xA1, 0x2E, 0x00                   ; 019E1  mov ax, word [es:0x2e]
  db 0x8C, 0xDB                               ; 019E5  mov bx, ds
  db 0x2B, 0xC3                               ; 019E7  sub ax, bx
  db 0xB1, 0x04                               ; 019E9  mov cl, 4
  db 0xD3, 0xE0                               ; 019EB  shl ax, cl
  db 0x5E                                     ; 019ED  pop si
  db 0x03, 0xF0                               ; 019EE  add si, ax
  jmp short loc_01A1F                          ; 019F0  0xEB, 0x2D

loc_019F2:  ; 019F2
  db 0x5E                                     ; 019F2  pop si
  db 0x9C                                     ; 019F3  pushf
  db 0xFA                                     ; 019F4  cli
  db 0x8B, 0x3E, 0x5C, 0x00                   ; 019F5  mov di, word [0x5c]
  db 0x85, 0xFF                               ; 019F9  test di, di
  jne loc_01A02                                ; 019FB  0x75, 0x05
  db 0xB9, 0x0C, 0x00                         ; 019FD  mov cx, 0xc
  db 0x9D                                     ; 01A00  popf
  db 0xC3                                     ; 01A01  ret

loc_01A02:  ; 01A02
  db 0x8B, 0x05                               ; 01A02  mov ax, word [di]
  db 0xA3, 0x5C, 0x00                         ; 01A04  mov word [0x5c], ax
  db 0x9D                                     ; 01A07  popf
  db 0x57                                     ; 01A08  push di
  db 0x06                                     ; 01A09  push es
  db 0x1E                                     ; 01A0A  push ds
  db 0x26, 0x8E, 0x1E, 0x2E, 0x00             ; 01A0B  mov ds, word [es:0x2e]
  db 0x07                                     ; 01A10  pop es
  db 0xB9, 0x18, 0x00                         ; 01A11  mov cx, 0x18
  db 0xF3, 0xA5                               ; 01A14  rep movsw
  db 0x06                                     ; 01A16  push es
  db 0x1F                                     ; 01A17  pop ds
  db 0x07                                     ; 01A18  pop es
  db 0x5E                                     ; 01A19  pop si
  db 0x81, 0x4C, 0x06, 0x10, 0x00             ; 01A1A  or word [si + 6], 0x10

loc_01A1F:  ; 01A1F
  db 0x33, 0xC9                               ; 01A1F  xor cx, cx
  db 0xC3                                     ; 01A21  ret
  db 0xFA                                     ; 01A22  cli
  db 0x1E                                     ; 01A23  push ds
  db 0x2E, 0x8E, 0x1E, 0x06, 0x00             ; 01A24  mov ds, word [cs:6]
  db 0x80, 0x3E, 0x52, 0x06, 0xFF             ; 01A29  cmp byte [0x652], 0xff
  je loc_01AA0                                 ; 01A2E  0x74, 0x70
  db 0xA3, 0x58, 0x06                         ; 01A30  mov word [0x658], ax
  db 0xB0, 0xFF                               ; 01A33  mov al, 0xff
  db 0xA2, 0x52, 0x06                         ; 01A35  mov byte [0x652], al
  db 0x8C, 0xC0                               ; 01A38  mov ax, es
  db 0xA3, 0x54, 0x06                         ; 01A3A  mov word [0x654], ax
  db 0xA1, 0x68, 0x00                         ; 01A3D  mov ax, word [0x68]
  db 0x93                                     ; 01A40  xchg bx, ax
  db 0xA3, 0x56, 0x06                         ; 01A41  mov word [0x656], ax
  db 0x8E, 0x47, 0x10                         ; 01A44  mov es, word p_uda[bx]
  db 0xB0, 0xFF                               ; 01A47  mov al, 0xff
  db 0x26, 0xA2, 0x1B, 0x00                   ; 01A49  mov byte [es:0x1b], al
  db 0x58                                     ; 01A4D  pop ax
  db 0x26, 0xA3, 0x32, 0x00                   ; 01A4E  mov word [es:0x32], ax
  db 0x8A, 0x47, 0x04                         ; 01A52  mov al, byte [bx + 4]
  db 0x26, 0xA2, 0x61, 0x00                   ; 01A55  mov byte [es:0x61], al
  db 0xC6, 0x47, 0x04, 0x00                   ; 01A59  mov byte [bx + 4], 0
  db 0xA1, 0x54, 0x06                         ; 01A5D  mov ax, word [0x654]
  db 0x26, 0xA3, 0x4C, 0x00                   ; 01A60  mov word [es:0x4c], ax
  jmp near loc_01ACE                           ; 01A64  0xE9, 0x67, 0x00

loc_01A67:  ; 01A67
  db 0xA3, 0x58, 0x06                         ; 01A67  mov word [0x658], ax
  db 0x8B, 0xC3                               ; 01A6A  mov ax, bx
  db 0xA3, 0x56, 0x06                         ; 01A6C  mov word [0x656], ax
  db 0x83, 0x3E, 0x6C, 0x00, 0x00             ; 01A6F  cmp word [0x6c], 0
  jne loc_01ACE                                ; 01A74  0x75, 0x58
  db 0xB0, 0x00                               ; 01A76  mov al, 0
  db 0x26, 0xA2, 0x1B, 0x00                   ; 01A78  mov byte [es:0x1b], al
  db 0xA1, 0x68, 0x00                         ; 01A7C  mov ax, word [0x68]
  db 0x8B, 0xD8                               ; 01A7F  mov bx, ax
  db 0x26, 0xA0, 0x61, 0x00                   ; 01A81  mov al, byte [es:0x61]
  db 0x88, 0x47, 0x04                         ; 01A85  mov byte [bx + 4], al
  db 0xA1, 0x56, 0x06                         ; 01A88  mov ax, word [0x656]
  db 0x8B, 0xD8                               ; 01A8B  mov bx, ax
  db 0xA1, 0x58, 0x06                         ; 01A8D  mov ax, word [0x658]
  db 0xC6, 0x06, 0x52, 0x06, 0x00             ; 01A90  mov byte [0x652], 0
  db 0x26, 0x8E, 0x1E, 0x32, 0x00             ; 01A95  mov ds, word [es:0x32]
  db 0x26, 0x8E, 0x06, 0x4C, 0x00             ; 01A9A  mov es, word [es:0x4c]
  db 0xCF                                     ; 01A9F  iret

loc_01AA0:  ; 01AA0
  db 0x1F                                     ; 01AA0  pop ds
  db 0xCF                                     ; 01AA1  iret
  call bdos1_set_p_ready                               ; 01AA2  0xE8, 0x01, 0x00
  db 0xCB                                     ; 01AA5  retf

bdos1_set_p_ready:  ; 01AA6
  db 0x53                                     ; 01AA6  push bx
  db 0x8B, 0x1E, 0x68, 0x00                   ; 01AA7  mov bx, word [0x68]
  db 0xC6, 0x47, 0x04, 0x00                   ; 01AAB  mov byte [bx + 4], 0
  db 0x5B                                     ; 01AAF  pop bx

bdos1_cli_chk_652:  ; 01AB0
  db 0x9C                                     ; 01AB0  pushf
  db 0xFA                                     ; 01AB1  cli
  db 0x80, 0x3E, 0x52, 0x06, 0xFF             ; 01AB2  cmp byte [0x652], 0xff
  jne loc_01ABB                                ; 01AB7  0x75, 0x02
  db 0x9D                                     ; 01AB9  popf
  db 0xC3                                     ; 01ABA  ret

loc_01ABB:  ; 01ABB
  db 0xC6, 0x06, 0x52, 0x06, 0xFF             ; 01ABB  mov byte [0x652], 0xff
  db 0x26, 0x8F, 0x06, 0x4E, 0x00             ; 01AC0  pop word [es:0x4e]
  db 0xA3, 0x58, 0x06                         ; 01AC5  mov word [0x658], ax
  db 0x8B, 0xC3                               ; 01AC8  mov ax, bx
  db 0x89, 0x1E, 0x56, 0x06                   ; 01ACA  mov word [0x656], bx

loc_01ACE:  ; 01ACE
  db 0x83, 0x3E, 0x6E, 0x00, 0x00             ; 01ACE  cmp word [0x6e], 0
  jne bdos1_switch_stack                       ; 01AD3  0x75, 0x2C
  db 0x83, 0x3E, 0x6C, 0x00, 0x00             ; 01AD5  cmp word [0x6c], 0
  jne bdos1_switch_stack                       ; 01ADA  0x75, 0x25
  db 0xA1, 0x68, 0x00                         ; 01ADC  mov ax, word [0x68]
  db 0x8B, 0xD8                               ; 01ADF  mov bx, ax
  db 0x80, 0x7F, 0x04, 0x00                   ; 01AE1  cmp byte [bx + 4], 0
  jne bdos1_switch_stack                       ; 01AE5  0x75, 0x1A
  db 0x83, 0x3F, 0x00                         ; 01AE7  cmp word [bx], 0
  je loc_01AF6                                 ; 01AEA  0x74, 0x0A
  db 0x8A, 0x47, 0x05                         ; 01AEC  mov al, byte [bx + 5]
  db 0x8B, 0x1F                               ; 01AEF  mov bx, word [bx]
  db 0x3A, 0x47, 0x05                         ; 01AF1  cmp al, byte [bx + 5]
  je bdos1_switch_stack                        ; 01AF4  0x74, 0x0B

loc_01AF6:  ; 01AF6
  db 0xA1, 0x56, 0x06                         ; 01AF6  mov ax, word [0x656]
  db 0x8B, 0xD8                               ; 01AF9  mov bx, ax
  db 0xA1, 0x58, 0x06                         ; 01AFB  mov ax, word [0x658]
  jmp near loc_01E9F                           ; 01AFE  0xE9, 0x9E, 0x03

bdos1_switch_stack:  ; 01B01
  db 0x26, 0x8C, 0x16, 0x1E, 0x00             ; 01B01  mov word [es:0x1e], ss
  db 0x26, 0x89, 0x26, 0x1C, 0x00             ; 01B06  mov word [es:0x1c], sp
  db 0x2E, 0x8E, 0x16, 0x06, 0x00             ; 01B0B  mov ss, word [cs:6]
  db 0xBC, 0x52, 0x06                         ; 01B10  mov sp, 0x652
  db 0xA1, 0x56, 0x06                         ; 01B13  mov ax, word [0x656]
  db 0x8B, 0xD8                               ; 01B16  mov bx, ax
  db 0xA1, 0x58, 0x06                         ; 01B18  mov ax, word [0x658]
  db 0xFB                                     ; 01B1B  sti
  db 0xFC                                     ; 01B1C  cld
  db 0x06                                     ; 01B1D  push es
  db 0x1F                                     ; 01B1E  pop ds
  db 0xA3, 0x20, 0x00                         ; 01B1F  mov word [0x20], ax
  db 0x8B, 0xC3                               ; 01B22  mov ax, bx
  db 0xA3, 0x22, 0x00                         ; 01B24  mov word [0x22], ax
  db 0x8B, 0xC1                               ; 01B27  mov ax, cx
  db 0xA3, 0x24, 0x00                         ; 01B29  mov word [0x24], ax
  db 0x8B, 0xC2                               ; 01B2C  mov ax, dx
  db 0xA3, 0x26, 0x00                         ; 01B2E  mov word [0x26], ax
  db 0x8B, 0xC7                               ; 01B31  mov ax, di
  db 0xA3, 0x28, 0x00                         ; 01B33  mov word [0x28], ax
  db 0x8B, 0xC6                               ; 01B36  mov ax, si
  db 0xA3, 0x2A, 0x00                         ; 01B38  mov word [0x2a], ax
  db 0x8B, 0xC5                               ; 01B3B  mov ax, bp
  db 0xA3, 0x2C, 0x00                         ; 01B3D  mov word [0x2c], ax
  db 0x33, 0xDB                               ; 01B40  xor bx, bx
  db 0x8E, 0xDB                               ; 01B42  mov ds, bx
  db 0x8B, 0xF3                               ; 01B44  mov si, bx
  db 0xBF, 0x38, 0x00                         ; 01B46  mov di, 0x38
  db 0xBA, 0x04, 0x00                         ; 01B49  mov dx, 4
  db 0x8B, 0xCA                               ; 01B4C  mov cx, dx
  db 0xF3, 0xA5                               ; 01B4E  rep movsw
  db 0x8B, 0xCA                               ; 01B50  mov cx, dx
  db 0x03, 0xF2                               ; 01B52  add si, dx
  db 0x03, 0xFA                               ; 01B54  add di, dx
  db 0xF3, 0xA5                               ; 01B56  rep movsw
  db 0xBE, 0x80, 0x03                         ; 01B58  mov si, 0x380
  db 0xBF, 0x58, 0x00                         ; 01B5B  mov di, 0x58
  db 0x8B, 0xCA                               ; 01B5E  mov cx, dx
  db 0xF3, 0xA5                               ; 01B60  rep movsw
  db 0x2E, 0x8E, 0x1E, 0x06, 0x00             ; 01B62  mov ds, word [cs:6]
  db 0x8B, 0x1E, 0x68, 0x00                   ; 01B67  mov bx, word [0x68]
  db 0xF7, 0x47, 0x26, 0x02, 0x00             ; 01B6B  test word p_sflag[bx], 2
  je loc_01B8F                                 ; 01B70  0x74, 0x1D
  db 0x06                                     ; 01B72  push es
  db 0x8C, 0xD8                               ; 01B73  mov ax, ds
  db 0x51                                     ; 01B75  push cx
  db 0x57                                     ; 01B76  push di
  db 0xB9, 0x00, 0x00                         ; 01B77  mov cx, 0
  db 0xBE, 0x00, 0x02                         ; 01B7A  mov si, 0x200
  db 0xBF, 0x00, 0x01                         ; 01B7D  mov di, 0x100
  db 0x8E, 0x47, 0x10                         ; 01B80  mov es, word p_uda[bx]
  db 0x8E, 0xD9                               ; 01B83  mov ds, cx
  db 0xB9, 0x1A, 0x00                         ; 01B85  mov cx, 0x1a
  db 0xF3, 0xA5                               ; 01B88  rep movsw
  db 0x5F                                     ; 01B8A  pop di
  db 0x59                                     ; 01B8B  pop cx
  db 0x07                                     ; 01B8C  pop es
  db 0x8E, 0xD8                               ; 01B8D  mov ds, ax

loc_01B8F:  ; 01B8F
  db 0x8B, 0x36, 0x68, 0x00                   ; 01B8F  mov si, word [0x68]
  db 0xB8, 0x00, 0x00                         ; 01B93  mov ax, 0
  db 0xFF, 0x5C, 0x28                         ; 01B96  call far p_userdisp[si]
  jmp short loc_01B9C                          ; 01B99  0xEB, 0x01
  db 0xCB                                     ; 01B9B  retf

loc_01B9C:  ; 01B9C
  db 0x90                                     ; 01B9C  nop
  db 0xA1, 0x68, 0x00                         ; 01B9D  mov ax, word [0x68]
  db 0x8B, 0xF0                               ; 01BA0  mov si, ax
  db 0x8B, 0x04                               ; 01BA2  mov ax, word [si]
  db 0xA3, 0x68, 0x00                         ; 01BA4  mov word [0x68], ax
  db 0xC7, 0x04, 0x00, 0x00                   ; 01BA7  mov word [si], 0
  db 0x32, 0xFF                               ; 01BAB  xor bh, bh
  db 0x8A, 0x5C, 0x04                         ; 01BAD  mov bl, byte [si + 4]
  db 0xD1, 0xE3                               ; 01BB0  shl bx, 1
  db 0x2E, 0xFF, 0xA7, 0x78, 0x05             ; 01BB2  jmp word [cs:bx + 0x578]
  db 0x00                                                         ; 01BB7  .
  db 0x65, 0x06                               ; 01BB8  push es
  db 0x65, 0x06                               ; 01BBA  push es
  db 0xA7                                     ; 01BBC  cmpsw
  db 0x05, 0x65, 0x06                         ; 01BBD  add ax, 0x665
  db 0xFE, 0x05                               ; 01BC0  inc byte [di]
  db 0x8E, 0x05                               ; 01BC2  mov es, word [di]
  db 0x65, 0x06                               ; 01BC4  push es
  db 0x65, 0x06                               ; 01BC6  push es
  db 0xE2, 0x05                               ; 01BC8  loop 0x1bcf
  db 0x65, 0x06                               ; 01BCA  push es
  db 0x65, 0x06                               ; 01BCC  push es
  db 0x26, 0xA1, 0x00, 0x00                   ; 01BCE  mov ax, word [es:0]
  db 0x8B, 0xD8                               ; 01BD2  mov bx, ax
  db 0x56                                     ; 01BD4  push si
  call bdos1_check_attr_20                               ; 01BD5  0xE8, 0xDA, 0x00
  db 0x5E                                     ; 01BD8  pop si
  db 0x81, 0x4C, 0x06, 0x20, 0x00             ; 01BD9  or word [si + 6], 0x20
  db 0x8A, 0x44, 0x2E                         ; 01BDE  mov al, byte p_scratch[si]
  db 0x88, 0x44, 0x04                         ; 01BE1  mov byte [si + 4], al
  jmp near loc_01CDE                           ; 01BE4  0xE9, 0xF7, 0x00
  db 0xFA                                     ; 01BE7  cli
  db 0xC6, 0x06, 0x0C, 0x0C, 0xFF             ; 01BE8  mov byte [0xc0c], 0xff
  db 0xBB, 0x6A, 0x00                         ; 01BED  mov bx, 0x6a
  db 0x26, 0x8B, 0x0E, 0x00, 0x00             ; 01BF0  mov cx, word [es:0]
  db 0x41                                     ; 01BF5  inc cx
  db 0x83, 0xF9, 0x00                         ; 01BF6  cmp cx, 0
  jne loc_01BFC                                ; 01BF9  0x75, 0x01
  db 0x49                                     ; 01BFB  dec cx

loc_01BFC:  ; 01BFC
  db 0x8B, 0x3F                               ; 01BFC  mov di, word [bx]
  db 0x83, 0xFF, 0x00                         ; 01BFE  cmp di, 0
  je loc_01C10                                 ; 01C01  0x74, 0x0D
  db 0x8B, 0x45, 0x1A                         ; 01C03  mov ax, word p_wait[di]
  db 0x3B, 0xC1                               ; 01C06  cmp ax, cx
  ja loc_01C10                                 ; 01C08  0x77, 0x06
  db 0x2B, 0xC8                               ; 01C0A  sub cx, ax
  db 0x8B, 0xDF                               ; 01C0C  mov bx, di
  jmp short loc_01BFC                          ; 01C0E  0xEB, 0xEC

loc_01C10:  ; 01C10
  db 0x89, 0x3C                               ; 01C10  mov word [si], di
  db 0x89, 0x37                               ; 01C12  mov word [bx], si
  db 0x89, 0x4C, 0x1A                         ; 01C14  mov word p_wait[si], cx
  db 0x83, 0xFF, 0x00                         ; 01C17  cmp di, 0
  je loc_01C1F                                 ; 01C1A  0x74, 0x03
  db 0x29, 0x4D, 0x1A                         ; 01C1C  sub word p_wait[di], cx

loc_01C1F:  ; 01C1F
  jmp near loc_01CDE                           ; 01C1F  0xE9, 0xBC, 0x00
  db 0x26, 0xA1, 0x00, 0x00                   ; 01C22  mov ax, word [es:0]
  db 0x8B, 0xD8                               ; 01C26  mov bx, ax
  db 0xFA                                     ; 01C28  cli
  db 0x83, 0x3F, 0xFE                         ; 01C29  cmp word [bx], -2
  je loc_01C37                                 ; 01C2C  0x74, 0x09
  db 0x89, 0x37                               ; 01C2E  mov word [bx], si
  db 0xC7, 0x04, 0x00, 0x00                   ; 01C30  mov word [si], 0
  jmp near loc_01CDE                           ; 01C34  0xE9, 0xA7, 0x00

loc_01C37:  ; 01C37
  db 0xC7, 0x07, 0xFF, 0xFF                   ; 01C37  mov word [bx], 0xffff
  db 0xFB                                     ; 01C3B  sti
  jmp short loc_01CA5                          ; 01C3C  0xEB, 0x67
  db 0xA1, 0x68, 0x00                         ; 01C3E  mov ax, word [0x68]
  db 0x89, 0x04                               ; 01C41  mov word [si], ax
  db 0x89, 0x36, 0x68, 0x00                   ; 01C43  mov word [0x68], si
  db 0xB9, 0x17, 0x04                         ; 01C47  mov cx, 0x417
  call bdos1_far_call_user                               ; 01C4A  0xE8, 0x9F, 0xFA

loc_01C4D:  ; 01C4D
  db 0xA1, 0x68, 0x00                         ; 01C4D  mov ax, word [0x68]
  db 0x8B, 0xF0                               ; 01C50  mov si, ax
  db 0x8B, 0x74, 0x16                         ; 01C52  mov si, word p_mem[si]
  db 0x85, 0xF6                               ; 01C55  test si, si
  je loc_01C71                                 ; 01C57  0x74, 0x18
  db 0x1E                                     ; 01C59  push ds
  db 0x33, 0xC9                               ; 01C5A  xor cx, cx
  db 0x51                                     ; 01C5C  push cx
  db 0xFF, 0x74, 0x02                         ; 01C5D  push word [si + 2]
  db 0x8C, 0xD0                               ; 01C60  mov ax, ss
  db 0x8E, 0xD8                               ; 01C62  mov ds, ax
  db 0x8B, 0xD4                               ; 01C64  mov dx, sp
  db 0xB9, 0x82, 0x00                         ; 01C66  mov cx, 0x82
  call bdos1_far_call_user                               ; 01C69  0xE8, 0x80, 0xFA
  db 0x5B                                     ; 01C6C  pop bx
  db 0x59                                     ; 01C6D  pop cx
  db 0x1F                                     ; 01C6E  pop ds
  jmp short loc_01C4D                          ; 01C6F  0xEB, 0xDC

loc_01C71:  ; 01C71
  db 0xC6, 0x06, 0xF4, 0x06, 0x00             ; 01C71  mov byte [0x6f4], 0
  db 0xBB, 0x96, 0x00                         ; 01C76  mov bx, 0x96

loc_01C79:  ; 01C79
  db 0x8B, 0x1F                               ; 01C79  mov bx, word [bx]
  db 0x85, 0xDB                               ; 01C7B  test bx, bx
  je loc_01C86                                 ; 01C7D  0x74, 0x07
  db 0x53                                     ; 01C7F  push bx
  call bdos1_fn22_unsync                       ; 01C80  0xE8, 0x17, 0xFB
  db 0x5B                                     ; 01C83  pop bx
  jmp short loc_01C79                          ; 01C84  0xEB, 0xF3

loc_01C86:  ; 01C86
  db 0x8B, 0x36, 0x68, 0x00                   ; 01C86  mov si, word [0x68]
  db 0x8B, 0x04                               ; 01C8A  mov ax, word [si]
  db 0xA3, 0x68, 0x00                         ; 01C8C  mov word [0x68], ax
  db 0xC7, 0x04, 0x00, 0x00                   ; 01C8F  mov word [si], 0
  db 0x3B, 0x36, 0x8C, 0x00                   ; 01C93  cmp si, word [0x8c]
  jne loc_01C9F                                ; 01C97  0x75, 0x06
  db 0xC7, 0x06, 0x8C, 0x00, 0x00, 0x00       ; 01C99  mov word [0x8c], 0

loc_01C9F:  ; 01C9F
  call bdos1_set_di_70                               ; 01C9F  0xE8, 0xA4, 0xFB
  jmp near loc_01CDE                           ; 01CA2  0xE9, 0x39, 0x00

loc_01CA5:  ; 01CA5
  db 0xC6, 0x44, 0x04, 0x00                   ; 01CA5  mov byte [si + 4], 0
  db 0xBB, 0x68, 0x00                         ; 01CA9  mov bx, 0x68
  call bdos1_check_attr_20                               ; 01CAC  0xE8, 0x03, 0x00
  jmp near loc_01CDE                           ; 01CAF  0xE9, 0x2C, 0x00

bdos1_check_attr_20:  ; 01CB2
  db 0x8B, 0x4C, 0x06                         ; 01CB2  mov cx, word [si + 6]
  db 0x81, 0xE1, 0x20, 0x00                   ; 01CB5  and cx, 0x20

loc_01CB9:  ; 01CB9
  db 0x8B, 0x3F                               ; 01CB9  mov di, word [bx]
  db 0x85, 0xFF                               ; 01CBB  test di, di
  je loc_01CD2                                 ; 01CBD  0x74, 0x13
  db 0x8A, 0x45, 0x05                         ; 01CBF  mov al, byte [di + 5]
  db 0x3A, 0x44, 0x05                         ; 01CC2  cmp al, byte [si + 5]
  ja loc_01CD2                                 ; 01CC5  0x77, 0x0B
  jb loc_01CCD                                 ; 01CC7  0x72, 0x04
  jcxz loc_01CCD                               ; 01CC9  0xE3, 0x02
  jmp short loc_01CD2                          ; 01CCB  0xEB, 0x05

loc_01CCD:  ; 01CCD
  db 0x8B, 0xDF                               ; 01CCD  mov bx, di
  jmp near loc_01CB9                           ; 01CCF  0xE9, 0xE7, 0xFF

loc_01CD2:  ; 01CD2
  jcxz loc_01CD9                               ; 01CD2  0xE3, 0x05
  db 0x81, 0x64, 0x06, 0xDF, 0xFF             ; 01CD4  and word [si + 6], 0xffdf

loc_01CD9:  ; 01CD9
  db 0x89, 0x3C                               ; 01CD9  mov word [si], di
  db 0x89, 0x37                               ; 01CDB  mov word [bx], si
  db 0xC3                                     ; 01CDD  ret

loc_01CDE:  ; 01CDE
  db 0xFB                                     ; 01CDE  sti
  db 0xBF, 0x6E, 0x00                         ; 01CDF  mov di, 0x6e

loc_01CE2:  ; 01CE2
  db 0x8B, 0x35                               ; 01CE2  mov si, word [di]
  db 0x85, 0xF6                               ; 01CE4  test si, si
  je loc_01D1E                                 ; 01CE6  0x74, 0x36
  db 0x8B, 0x1E, 0x68, 0x00                   ; 01CE8  mov bx, word [0x68]
  db 0x85, 0xDB                               ; 01CEC  test bx, bx
  je loc_01CFA                                 ; 01CEE  0x74, 0x0A
  db 0x8A, 0x44, 0x05                         ; 01CF0  mov al, byte [si + 5]
  db 0x3A, 0x47, 0x05                         ; 01CF3  cmp al, byte [bx + 5]
  jbe loc_01CFA                                ; 01CF6  0x76, 0x02
  jmp short loc_01D1E                          ; 01CF8  0xEB, 0x24

loc_01CFA:  ; 01CFA
  db 0x57                                     ; 01CFA  push di
  db 0x8B, 0x54, 0x1A                         ; 01CFB  mov dx, word p_wait[si]
  db 0xB0, 0x0D                               ; 01CFE  mov al, 0xd
  call bdos1_userdisp_call                               ; 01D00  0xE8, 0xEF, 0xF9
  db 0x5F                                     ; 01D03  pop di
  db 0x8B, 0x35                               ; 01D04  mov si, word [di]
  db 0x3C, 0x00                               ; 01D06  cmp al, 0
  je loc_01D1A                                 ; 01D08  0x74, 0x10
  db 0x8B, 0x04                               ; 01D0A  mov ax, word [si]
  db 0x89, 0x05                               ; 01D0C  mov word [di], ax
  db 0xBB, 0x68, 0x00                         ; 01D0E  mov bx, 0x68
  db 0xC6, 0x44, 0x04, 0x00                   ; 01D11  mov byte [si + 4], 0
  call bdos1_check_attr_20                               ; 01D15  0xE8, 0x9A, 0xFF
  jmp short loc_01D1E                          ; 01D18  0xEB, 0x04

loc_01D1A:  ; 01D1A
  db 0x8B, 0xFE                               ; 01D1A  mov di, si
  jmp short loc_01CE2                          ; 01D1C  0xEB, 0xC4

loc_01D1E:  ; 01D1E
  db 0xFA                                     ; 01D1E  cli
  db 0x8B, 0x36, 0x6C, 0x00                   ; 01D1F  mov si, word [0x6c]
  db 0x85, 0xF6                               ; 01D23  test si, si
  je loc_01D39                                 ; 01D25  0x74, 0x12
  db 0x8B, 0x04                               ; 01D27  mov ax, word [si]
  db 0xA3, 0x6C, 0x00                         ; 01D29  mov word [0x6c], ax
  db 0xFB                                     ; 01D2C  sti
  db 0xC6, 0x44, 0x04, 0x00                   ; 01D2D  mov byte [si + 4], 0
  db 0xBB, 0x68, 0x00                         ; 01D31  mov bx, 0x68
  call bdos1_check_attr_20                               ; 01D34  0xE8, 0x7B, 0xFF
  jmp short loc_01D1E                          ; 01D37  0xEB, 0xE5

loc_01D39:  ; 01D39
  db 0xFB                                     ; 01D39  sti
  db 0x8B, 0x1E, 0x68, 0x00                   ; 01D3A  mov bx, word [0x68]

loc_01D3E:  ; 01D3E
  db 0x85, 0xDB                               ; 01D3E  test bx, bx
  jne loc_01D45                                ; 01D40  0x75, 0x03
  jmp near loc_01CDE                           ; 01D42  0xE9, 0x99, 0xFF

loc_01D45:  ; 01D45
  db 0xFA                                     ; 01D45  cli
  db 0x8B, 0x47, 0x26                         ; 01D46  mov ax, word p_sflag[bx]
  db 0xA9, 0x01, 0x00                         ; 01D49  test ax, 1
  je loc_01DAF                                 ; 01D4C  0x74, 0x61
  db 0x8A, 0x47, 0x20                         ; 01D4E  mov al, byte p_cns[bx]
  db 0x32, 0xE4                               ; 01D51  xor ah, ah
  db 0x33, 0xFF                               ; 01D53  xor di, di
  db 0xBF, 0x2C, 0x00                         ; 01D55  mov di, 0x2c
  db 0xF7, 0xE7                               ; 01D58  mul di
  db 0x8B, 0x3E, 0x54, 0x00                   ; 01D5A  mov di, word [0x54]
  db 0x03, 0xF8                               ; 01D5E  add di, ax
  db 0x8B, 0x45, 0x0E                         ; 01D60  mov ax, word [di + 0xe]
  db 0xA9, 0x02, 0x00                         ; 01D63  test ax, 2
  je loc_01DAF                                 ; 01D66  0x74, 0x47
  db 0x06                                     ; 01D68  push es
  db 0x8E, 0x47, 0x10                         ; 01D69  mov es, word p_uda[bx]
  db 0x26, 0xA0, 0x60, 0x00                   ; 01D6C  mov al, byte [es:0x60]
  db 0x84, 0xC0                               ; 01D70  test al, al
  db 0x07                                     ; 01D72  pop es
  jne loc_01DAF                                ; 01D73  0x75, 0x3A
  db 0xF7, 0x47, 0x06, 0x80, 0x00             ; 01D75  test word [bx + 6], 0x80
  jne loc_01DAF                                ; 01D7A  0x75, 0x33
  db 0x8B, 0x07                               ; 01D7C  mov ax, word [bx]
  db 0xA3, 0x68, 0x00                         ; 01D7E  mov word [0x68], ax
  db 0xA1, 0xA8, 0x00                         ; 01D81  mov ax, word [0xa8]
  db 0x89, 0x07                               ; 01D84  mov word [bx], ax
  db 0x89, 0x1E, 0xA8, 0x00                   ; 01D86  mov word [0xa8], bx
  db 0xC6, 0x47, 0x04, 0x09                   ; 01D8A  mov byte [bx + 4], 9
  db 0x8B, 0x45, 0x0E                         ; 01D8E  mov ax, word [di + 0xe]
  db 0xA9, 0x10, 0x00                         ; 01D91  test ax, 0x10
  jne loc_01D9B                                ; 01D94  0x75, 0x05
  db 0x81, 0x4D, 0x0E, 0x10, 0x00             ; 01D96  or word [di + 0xe], 0x10

loc_01D9B:  ; 01D9B
  db 0x06                                     ; 01D9B  push es
  db 0x8E, 0x47, 0x10                         ; 01D9C  mov es, word p_uda[bx]
  db 0x26, 0xC7, 0x06, 0x00, 0x00, 0xA8, 0x00 ; 01D9F  mov word [es:0], 0xa8
  db 0x07                                     ; 01DA6  pop es
  db 0x8B, 0x1E, 0x68, 0x00                   ; 01DA7  mov bx, word [0x68]
  db 0xFB                                     ; 01DAB  sti
  jmp near loc_01D3E                           ; 01DAC  0xE9, 0x8F, 0xFF

loc_01DAF:  ; 01DAF
  db 0xFB                                     ; 01DAF  sti
  db 0xF7, 0x47, 0x06, 0x00, 0x80             ; 01DB0  test word [bx + 6], 0x8000
  je loc_01E16                                 ; 01DB5  0x74, 0x5F
  db 0x3B, 0x1E, 0x8C, 0x00                   ; 01DB7  cmp bx, word [0x8c]
  je loc_01E34                                 ; 01DBB  0x74, 0x77
  db 0x8C, 0xDA                               ; 01DBD  mov dx, ds
  db 0x9B                                     ; 01DBF  wait
  db 0x87, 0x1E, 0x8C, 0x00                   ; 01DC0  xchg word [0x8c], bx
  db 0x85, 0xDB                               ; 01DC4  test bx, bx
  je loc_01DF6                                 ; 01DC6  0x74, 0x2E
  db 0x8E, 0x5F, 0x10                         ; 01DC8  mov ds, word p_uda[bx]
  db 0x9B                                     ; 01DCB  wait
  db 0xD9, 0x3E, 0x00, 0x01                   ; 01DCC  fnstcw word [0x100]
  db 0x90                                     ; 01DD0  nop
  db 0x9B                                     ; 01DD1  wait
  db 0xDB, 0xE1                               ; 01DD2  fdisi8087_nop
  db 0xA1, 0x00, 0x01                         ; 01DD4  mov ax, word [0x100]
  db 0xDD, 0x36, 0x00, 0x01                   ; 01DD7  fnsave dword [0x100]
  db 0x9B                                     ; 01DDB  wait
  db 0xA3, 0x00, 0x01                         ; 01DDC  mov word [0x100], ax
  db 0x8E, 0xDA                               ; 01DDF  mov ds, dx
  db 0x8E, 0x47, 0x10                         ; 01DE1  mov es, word p_uda[bx]
  db 0xBF, 0x40, 0x00                         ; 01DE4  mov di, 0x40
  db 0x8B, 0x36, 0xA0, 0x00                   ; 01DE7  mov si, word [0xa0]
  db 0x8E, 0x1E, 0xA2, 0x00                   ; 01DEB  mov ds, word [0xa2]
  db 0xB9, 0x02, 0x00                         ; 01DEF  mov cx, 2
  db 0xF3, 0xA5                               ; 01DF2  rep movsw
  db 0x8E, 0xDA                               ; 01DF4  mov ds, dx

loc_01DF6:  ; 01DF6
  db 0x8B, 0x1E, 0x68, 0x00                   ; 01DF6  mov bx, word [0x68]
  db 0x8E, 0x5F, 0x10                         ; 01DFA  mov ds, word p_uda[bx]
  db 0x9B                                     ; 01DFD  wait
  db 0xDD, 0x26, 0x00, 0x01                   ; 01DFE  frstor dword [0x100]
  db 0x1E                                     ; 01E02  push ds
  db 0x8E, 0xDA                               ; 01E03  mov ds, dx
  db 0xC4, 0x3E, 0xA0, 0x00                   ; 01E05  les di, [0xa0]
  db 0x8E, 0x5F, 0x10                         ; 01E09  mov ds, word p_uda[bx]
  db 0xBE, 0x40, 0x00                         ; 01E0C  mov si, 0x40
  db 0xB9, 0x02, 0x00                         ; 01E0F  mov cx, 2
  db 0xF3, 0xA5                               ; 01E12  rep movsw
  jmp short loc_01E3A                          ; 01E14  0xEB, 0x24

loc_01E16:  ; 01E16
  db 0xF7, 0x47, 0x26, 0x02, 0x00             ; 01E16  test word p_sflag[bx], 2
  je loc_01E34                                 ; 01E1B  0x74, 0x17
  db 0x8C, 0xD8                               ; 01E1D  mov ax, ds
  db 0xB9, 0x00, 0x00                         ; 01E1F  mov cx, 0
  db 0xBF, 0x00, 0x02                         ; 01E22  mov di, 0x200
  db 0xBE, 0x00, 0x01                         ; 01E25  mov si, 0x100
  db 0x8E, 0x5F, 0x10                         ; 01E28  mov ds, word p_uda[bx]
  db 0x8E, 0xC1                               ; 01E2B  mov es, cx
  db 0xB9, 0x1A, 0x00                         ; 01E2D  mov cx, 0x1a
  db 0xF3, 0xA5                               ; 01E30  rep movsw
  db 0x8E, 0xD8                               ; 01E32  mov ds, ax

loc_01E34:  ; 01E34
  db 0x8B, 0x57, 0x10                         ; 01E34  mov dx, word p_uda[bx]
  db 0x8E, 0xDA                               ; 01E37  mov ds, dx
  db 0x52                                     ; 01E39  push dx

loc_01E3A:  ; 01E3A
  db 0x2E, 0x8E, 0x06, 0x06, 0x00             ; 01E3A  mov es, word [cs:6]
  db 0xB8, 0x01, 0x00                         ; 01E3F  mov ax, 1
  db 0x26, 0x8B, 0x36, 0x68, 0x00             ; 01E42  mov si, word [es:0x68]
  db 0x26, 0xFF, 0x5C, 0x28                   ; 01E47  call far [es:si + 0x28]
  db 0x33, 0xC0                               ; 01E4B  xor ax, ax
  db 0x8E, 0xC0                               ; 01E4D  mov es, ax
  db 0x8B, 0xF8                               ; 01E4F  mov di, ax
  db 0xBE, 0x38, 0x00                         ; 01E51  mov si, 0x38
  db 0xBA, 0x04, 0x00                         ; 01E54  mov dx, 4
  db 0x8B, 0xCA                               ; 01E57  mov cx, dx
  db 0xF3, 0xA5                               ; 01E59  rep movsw
  db 0x8B, 0xCA                               ; 01E5B  mov cx, dx
  db 0x03, 0xFA                               ; 01E5D  add di, dx
  db 0x03, 0xF2                               ; 01E5F  add si, dx
  db 0xF3, 0xA5                               ; 01E61  rep movsw
  db 0xBE, 0x58, 0x00                         ; 01E63  mov si, 0x58
  db 0xBF, 0x80, 0x03                         ; 01E66  mov di, 0x380
  db 0x8B, 0xCA                               ; 01E69  mov cx, dx
  db 0xF3, 0xA5                               ; 01E6B  rep movsw
  db 0xA1, 0x22, 0x00                         ; 01E6D  mov ax, word [0x22]
  db 0x8B, 0xD8                               ; 01E70  mov bx, ax
  db 0xA1, 0x24, 0x00                         ; 01E72  mov ax, word [0x24]
  db 0x8B, 0xC8                               ; 01E75  mov cx, ax
  db 0xA1, 0x26, 0x00                         ; 01E77  mov ax, word [0x26]
  db 0x8B, 0xD0                               ; 01E7A  mov dx, ax
  db 0xA1, 0x2A, 0x00                         ; 01E7C  mov ax, word [0x2a]
  db 0x8B, 0xF0                               ; 01E7F  mov si, ax
  db 0xA1, 0x28, 0x00                         ; 01E81  mov ax, word [0x28]
  db 0x8B, 0xF8                               ; 01E84  mov di, ax
  db 0xA1, 0x2C, 0x00                         ; 01E86  mov ax, word [0x2c]
  db 0x8B, 0xE8                               ; 01E89  mov bp, ax
  db 0xA1, 0x20, 0x00                         ; 01E8B  mov ax, word [0x20]
  db 0x07                                     ; 01E8E  pop es
  db 0xFA                                     ; 01E8F  cli
  db 0x26, 0x8E, 0x16, 0x1E, 0x00             ; 01E90  mov ss, word [es:0x1e]
  db 0x26, 0x8B, 0x26, 0x1C, 0x00             ; 01E95  mov sp, word [es:0x1c]
  db 0x2E, 0x8E, 0x1E, 0x06, 0x00             ; 01E9A  mov ds, word [cs:6]

loc_01E9F:  ; 01E9F
  db 0x26, 0x80, 0x3E, 0x1B, 0x00, 0xFF       ; 01E9F  cmp byte [es:0x1b], 0xff
  jne loc_01EAA                                ; 01EA5  0x75, 0x03
  jmp near loc_01A67                           ; 01EA7  0xE9, 0xBD, 0xFB

loc_01EAA:  ; 01EAA
  db 0x26, 0xFF, 0x36, 0x4E, 0x00             ; 01EAA  push word [es:0x4e]
  db 0xC6, 0x06, 0x52, 0x06, 0x00             ; 01EAF  mov byte [0x652], 0
  db 0x83, 0x3E, 0x6C, 0x00, 0x00             ; 01EB4  cmp word [0x6c], 0
  je loc_01EBF                                 ; 01EB9  0x74, 0x04
  db 0x9D                                     ; 01EBB  popf
  jmp near bdos1_set_p_ready                           ; 01EBC  0xE9, 0xE7, 0xFB

loc_01EBF:  ; 01EBF
  db 0x9D                                     ; 01EBF  popf
  db 0xC3                                     ; 01EC0  ret

bdos1_fn03_close_file:  ; 01EC1
  call bdos1_open_close_setup                               ; 01EC1  0xE8, 0xAA, 0x00
  db 0x80, 0xF9, 0x01                         ; 01EC4  cmp cl, 1
  jne loc_01F02                                ; 01EC7  0x75, 0x39
  db 0x8B, 0x1E, 0x6A, 0x00                   ; 01EC9  mov bx, word [0x6a]
  db 0x85, 0xDB                               ; 01ECD  test bx, bx
  je loc_01EFA                                 ; 01ECF  0x74, 0x29
  db 0xFF, 0x4F, 0x1A                         ; 01ED1  dec word p_wait[bx]
  jne loc_01EF7                                ; 01ED4  0x75, 0x21

loc_01ED6:  ; 01ED6
  db 0x8B, 0x37                               ; 01ED6  mov si, word [bx]
  db 0x89, 0x36, 0x6A, 0x00                   ; 01ED8  mov word [0x6a], si
  db 0xC6, 0x47, 0x04, 0x00                   ; 01EDC  mov byte [bx + 4], 0
  db 0xA1, 0x6C, 0x00                         ; 01EE0  mov ax, word [0x6c]
  db 0x89, 0x07                               ; 01EE3  mov word [bx], ax
  db 0x89, 0x1E, 0x6C, 0x00                   ; 01EE5  mov word [0x6c], bx
  db 0x85, 0xF6                               ; 01EE9  test si, si
  je loc_01EFA                                 ; 01EEB  0x74, 0x0D
  db 0x83, 0x7C, 0x1A, 0x00                   ; 01EED  cmp word p_wait[si], 0
  jne loc_01EF7                                ; 01EF1  0x75, 0x04
  db 0x8B, 0xDE                               ; 01EF3  mov bx, si
  jmp short loc_01ED6                          ; 01EF5  0xEB, 0xDF

loc_01EF7:  ; 01EF7
  jmp near loc_01F93                           ; 01EF7  0xE9, 0x99, 0x00

loc_01EFA:  ; 01EFA
  db 0xC6, 0x06, 0x0C, 0x0C, 0x00             ; 01EFA  mov byte [0xc0c], 0
  jmp near loc_01F93                           ; 01EFF  0xE9, 0x91, 0x00

loc_01F02:  ; 01F02
  db 0x80, 0x7C, 0x02, 0xFF                   ; 01F02  cmp byte [si + 2], 0xff
  je loc_01F11                                 ; 01F06  0x74, 0x09
  db 0xFE, 0x4C, 0x02                         ; 01F08  dec byte [si + 2]
  db 0xB9, 0x2A, 0x00                         ; 01F0B  mov cx, 0x2a
  jmp near loc_01F97                           ; 01F0E  0xE9, 0x86, 0x00

loc_01F11:  ; 01F11
  db 0x83, 0xFB, 0xFE                         ; 01F11  cmp bx, -2
  jne loc_01F1C                                ; 01F14  0x75, 0x06
  db 0xB9, 0x05, 0x00                         ; 01F16  mov cx, 5
  jmp near loc_01F97                           ; 01F19  0xE9, 0x7B, 0x00

loc_01F1C:  ; 01F1C
  db 0x83, 0xFB, 0xFF                         ; 01F1C  cmp bx, -1
  jne loc_01F28                                ; 01F1F  0x75, 0x07
  db 0xC7, 0x04, 0xFE, 0xFF                   ; 01F21  mov word [si], 0xfffe
  jmp near loc_01F93                           ; 01F25  0xE9, 0x6B, 0x00

loc_01F28:  ; 01F28
  db 0xA1, 0x6C, 0x00                         ; 01F28  mov ax, word [0x6c]
  db 0x89, 0x07                               ; 01F2B  mov word [bx], ax
  db 0x89, 0x1E, 0x6C, 0x00                   ; 01F2D  mov word [0x6c], bx
  db 0xC6, 0x47, 0x04, 0x00                   ; 01F31  mov byte [bx + 4], 0
  db 0x81, 0x4F, 0x06, 0x20, 0x00             ; 01F35  or word [bx + 6], 0x20
  db 0xC7, 0x04, 0xFF, 0xFF                   ; 01F3A  mov word [si], 0xffff
  jmp near loc_01F93                           ; 01F3E  0xE9, 0x52, 0x00

bdos1_fn02_open_file:  ; 01F41
  call bdos1_open_close_setup                               ; 01F41  0xE8, 0x2A, 0x00
  db 0x83, 0xFB, 0xFE                         ; 01F44  cmp bx, -2
  jne loc_01F50                                ; 01F47  0x75, 0x07
  db 0xC7, 0x04, 0xFF, 0xFF                   ; 01F49  mov word [si], 0xffff
  jmp near loc_01F93                           ; 01F4D  0xE9, 0x43, 0x00

loc_01F50:  ; 01F50
  db 0x83, 0xFB, 0xFF                         ; 01F50  cmp bx, -1
  jne loc_01F68                                ; 01F53  0x75, 0x13
  db 0x8B, 0x1E, 0x68, 0x00                   ; 01F55  mov bx, word [0x68]
  db 0xC6, 0x47, 0x04, 0x08                   ; 01F59  mov byte [bx + 4], 8
  db 0x26, 0x89, 0x36, 0x00, 0x00             ; 01F5D  mov word [es:0], si
  call bdos1_cli_chk_652                               ; 01F62  0xE8, 0x4B, 0xFB
  jmp near loc_01F93                           ; 01F65  0xE9, 0x2B, 0x00

loc_01F68:  ; 01F68
  db 0xB9, 0x06, 0x00                         ; 01F68  mov cx, 6
  jmp near loc_01F97                           ; 01F6B  0xE9, 0x29, 0x00

bdos1_open_close_setup:  ; 01F6E
  db 0x58                                     ; 01F6E  pop ax
  db 0x9C                                     ; 01F6F  pushf
  db 0x3A, 0x16, 0x4A, 0x00                   ; 01F70  cmp dl, byte [0x4a]
  jb loc_01F7C                                 ; 01F74  0x72, 0x06
  db 0xB9, 0x04, 0x00                         ; 01F76  mov cx, 4
  jmp near loc_01F97                           ; 01F79  0xE9, 0x1B, 0x00

loc_01F7C:  ; 01F7C
  db 0x8A, 0xCA                               ; 01F7C  mov cl, dl
  db 0x32, 0xF6                               ; 01F7E  xor dh, dh
  db 0x50                                     ; 01F80  push ax
  db 0xFA                                     ; 01F81  cli
  db 0x8B, 0xC2                               ; 01F82  mov ax, dx
  db 0x8B, 0xD8                               ; 01F84  mov bx, ax
  db 0x03, 0xC0                               ; 01F86  add ax, ax
  db 0x03, 0xC3                               ; 01F88  add ax, bx
  db 0x8B, 0x36, 0x56, 0x00                   ; 01F8A  mov si, word [0x56]
  db 0x03, 0xF0                               ; 01F8E  add si, ax
  db 0x8B, 0x1C                               ; 01F90  mov bx, word [si]
  db 0xC3                                     ; 01F92  ret

loc_01F93:  ; 01F93
  db 0x33, 0xDB                               ; 01F93  xor bx, bx
  db 0x9D                                     ; 01F95  popf
  db 0xC3                                     ; 01F96  ret

loc_01F97:  ; 01F97
  db 0x33, 0xDB                               ; 01F97  xor bx, bx
  db 0x4B                                     ; 01F99  dec bx
  db 0x9D                                     ; 01F9A  popf
  db 0xC3                                     ; 01F9B  ret

bdos1_fn04_search_first:  ; 01F9C
  call bdos1_mxdisk_sync                               ; 01F9C  0xE8, 0x3F, 0x02
  call bdos1_get_abs_para_1c                               ; 01F9F  0xE8, 0x92, 0x02
  jcxz loc_01FA7                               ; 01FA2  0xE3, 0x03
  jmp near loc_01FEC                           ; 01FA4  0xE9, 0x45, 0x00

loc_01FA7:  ; 01FA7
  db 0x06                                     ; 01FA7  push es
  db 0x2E, 0x8E, 0x06, 0x06, 0x00             ; 01FA8  mov es, word [cs:6]
  db 0xBE, 0x74, 0x00                         ; 01FAD  mov si, 0x74

loc_01FB0:  ; 01FB0
  db 0x8B, 0x34                               ; 01FB0  mov si, word [si]
  db 0x85, 0xF6                               ; 01FB2  test si, si
  je loc_01FD0                                 ; 01FB4  0x74, 0x1A
  db 0x57                                     ; 01FB6  push di
  db 0x56                                     ; 01FB7  push si
  db 0xB9, 0x04, 0x00                         ; 01FB8  mov cx, 4
  db 0x83, 0xC7, 0x06                         ; 01FBB  add di, 6
  db 0x83, 0xC6, 0x06                         ; 01FBE  add si, 6
  db 0xF3, 0xA7                               ; 01FC1  repe cmpsw
  db 0x5E                                     ; 01FC3  pop si
  db 0x5F                                     ; 01FC4  pop di
  jne loc_01FB0                                ; 01FC5  0x75, 0xE9
  db 0x07                                     ; 01FC7  pop es
  call bdos1_link_free_buffer                               ; 01FC8  0xE8, 0x6B, 0x03
  db 0xB9, 0x0A, 0x00                         ; 01FCB  mov cx, 0xa
  jmp short loc_01FEC                          ; 01FCE  0xEB, 0x1C

loc_01FD0:  ; 01FD0
  db 0x07                                     ; 01FD0  pop es
  db 0x33, 0xD2                               ; 01FD1  xor dx, dx
  db 0x89, 0x55, 0x12                         ; 01FD3  mov word p_dsk[di], dx
  db 0x89, 0x55, 0x14                         ; 01FD6  mov word p_ldsk[di], dx
  db 0x89, 0x55, 0x16                         ; 01FD9  mov word p_mem[di], dx
  db 0x89, 0x55, 0x18                         ; 01FDC  mov word p_cmod[di], dx
  db 0xA1, 0x74, 0x00                         ; 01FDF  mov ax, word [0x74]
  db 0x89, 0x05                               ; 01FE2  mov word [di], ax
  db 0x89, 0x3E, 0x74, 0x00                   ; 01FE4  mov word [0x74], di
  db 0x33, 0xDB                               ; 01FE8  xor bx, bx
  jmp short loc_01FEF                          ; 01FEA  0xEB, 0x03

loc_01FEC:  ; 01FEC
  db 0xBB, 0xFF, 0xFF                         ; 01FEC  mov bx, 0xffff

loc_01FEF:  ; 01FEF
  jmp near bdos1_mxdisk_unsync                           ; 01FEF  0xE9, 0xFA, 0x01

bdos1_fn05_search_next:  ; 01FF2
  call bdos1_mxdisk_sync                               ; 01FF2  0xE8, 0xE9, 0x01
  db 0x06                                     ; 01FF5  push es
  db 0x26, 0x8E, 0x06, 0x2E, 0x00             ; 01FF6  mov es, word [es:0x2e]
  db 0xBE, 0x74, 0x00                         ; 01FFB  mov si, 0x74
  db 0x8B, 0xFA                               ; 01FFE  mov di, dx

loc_02000:  ; 02000
  db 0x8B, 0x34                               ; 02000  mov si, word [si]
  db 0x85, 0xF6                               ; 02002  test si, si
  jne loc_0200C                                ; 02004  0x75, 0x06
  db 0x07                                     ; 02006  pop es
  db 0xB9, 0x09, 0x00                         ; 02007  mov cx, 9
  jmp short loc_0203E                          ; 0200A  0xEB, 0x32

loc_0200C:  ; 0200C
  db 0x57                                     ; 0200C  push di
  db 0x56                                     ; 0200D  push si
  db 0xB9, 0x04, 0x00                         ; 0200E  mov cx, 4
  db 0x83, 0xC6, 0x06                         ; 02011  add si, 6
  db 0x83, 0xC7, 0x08                         ; 02014  add di, 8
  db 0xF3, 0xA7                               ; 02017  repe cmpsw
  db 0x5E                                     ; 02019  pop si
  db 0x5F                                     ; 0201A  pop di
  jne loc_02000                                ; 0201B  0x75, 0xE3
  db 0xF7, 0x44, 0x04, 0x04, 0x00             ; 0201D  test word [si + 4], 4
  je loc_02035                                 ; 02022  0x74, 0x11
  db 0x8B, 0x1E, 0x68, 0x00                   ; 02024  mov bx, word [0x68]
  db 0xF7, 0x47, 0x06, 0x01, 0x00             ; 02028  test word [bx + 6], 1
  jne loc_02035                                ; 0202D  0x75, 0x06
  db 0x07                                     ; 0202F  pop es
  db 0xB9, 0x0D, 0x00                         ; 02030  mov cx, 0xd
  jmp short loc_0203E                          ; 02033  0xEB, 0x09

loc_02035:  ; 02035
  db 0x26, 0x89, 0x75, 0x02                   ; 02035  mov word [es:di + 2], si
  db 0x07                                     ; 02039  pop es
  db 0x33, 0xDB                               ; 0203A  xor bx, bx
  jmp short loc_02041                          ; 0203C  0xEB, 0x03

loc_0203E:  ; 0203E
  db 0xBB, 0xFF, 0xFF                         ; 0203E  mov bx, 0xffff

loc_02041:  ; 02041
  call bdos1_mxdisk_unsync                               ; 02041  0xE8, 0xA8, 0x01
  db 0xC3                                     ; 02044  ret

bdos1_fn06_delete_make:  ; 02045
  db 0x8C, 0xC0                               ; 02045  mov ax, es
  db 0x26, 0x8E, 0x06, 0x2E, 0x00             ; 02047  mov es, word [es:0x2e]
  db 0x8B, 0xFA                               ; 0204C  mov di, dx
  db 0x26, 0x8B, 0x7D, 0x02                   ; 0204E  mov di, word [es:di + 2]
  db 0x8E, 0xC0                               ; 02052  mov es, ax
  db 0xF7, 0x45, 0x04, 0x02, 0x00             ; 02054  test word [di + 4], 2
  jne loc_0206D                                ; 02059  0x75, 0x12
  db 0xF7, 0x45, 0x04, 0x04, 0x00             ; 0205B  test word [di + 4], 4
  je loc_02074                                 ; 02060  0x74, 0x12
  db 0x8B, 0x1E, 0x68, 0x00                   ; 02062  mov bx, word [0x68]
  db 0xF7, 0x47, 0x06, 0x01, 0x00             ; 02066  test word [bx + 6], 1
  jne loc_02074                                ; 0206B  0x75, 0x07

loc_0206D:  ; 0206D
  db 0xB9, 0x0D, 0x00                         ; 0206D  mov cx, 0xd
  db 0xBB, 0xFF, 0xFF                         ; 02070  mov bx, 0xffff
  db 0xC3                                     ; 02073  ret

loc_02074:  ; 02074
  db 0x57                                     ; 02074  push di
  call bdos1_mxdisk_sync                               ; 02075  0xE8, 0x66, 0x01
  db 0x5F                                     ; 02078  pop di
  db 0x8B, 0x45, 0x12                         ; 02079  mov ax, word p_dsk[di]
  db 0x8B, 0x55, 0x14                         ; 0207C  mov dx, word p_ldsk[di]
  db 0x0B, 0xD0                               ; 0207F  or dx, ax
  db 0xB9, 0x0A, 0x00                         ; 02081  mov cx, 0xa
  jne loc_020A5                                ; 02084  0x75, 0x1F
  db 0xBB, 0x74, 0x00                         ; 02086  mov bx, 0x74

loc_02089:  ; 02089
  db 0x8B, 0x37                               ; 02089  mov si, word [bx]
  db 0x85, 0xF6                               ; 0208B  test si, si
  je loc_020A2                                 ; 0208D  0x74, 0x13
  db 0x3B, 0xF7                               ; 0208F  cmp si, di
  je loc_02097                                 ; 02091  0x74, 0x04
  db 0x8B, 0xDE                               ; 02093  mov bx, si
  jmp short loc_02089                          ; 02095  0xEB, 0xF2

loc_02097:  ; 02097
  db 0x8B, 0x05                               ; 02097  mov ax, word [di]
  db 0x89, 0x07                               ; 02099  mov word [bx], ax
  call bdos1_link_free_buffer                               ; 0209B  0xE8, 0x98, 0x02
  db 0x33, 0xDB                               ; 0209E  xor bx, bx
  jmp short loc_020A8                          ; 020A0  0xEB, 0x06

loc_020A2:  ; 020A2
  db 0xB9, 0x09, 0x00                         ; 020A2  mov cx, 9

loc_020A5:  ; 020A5
  db 0xBB, 0xFF, 0xFF                         ; 020A5  mov bx, 0xffff

loc_020A8:  ; 020A8
  jmp near bdos1_mxdisk_unsync                           ; 020A8  0xE9, 0x41, 0x01

bdos1_fn07_read_seq:  ; 020AB
  db 0x32, 0xC0                               ; 020AB  xor al, al
  jmp short loc_020B1                          ; 020AD  0xEB, 0x02

bdos1_fn08_read_rand:  ; 020AF
  db 0xB0, 0xFF                               ; 020AF  mov al, 0xff

loc_020B1:  ; 020B1
  db 0x50                                     ; 020B1  push ax
  call bdos1_mxdisk_sync                               ; 020B2  0xE8, 0x29, 0x01
  call bdos1_load_u_wrkseg_fcb                               ; 020B5  0xE8, 0x5A, 0x01
  db 0x58                                     ; 020B8  pop ax
  db 0x8B, 0xF2                               ; 020B9  mov si, dx
  jcxz loc_020C0                               ; 020BB  0xE3, 0x03
  jmp near loc_02133                           ; 020BD  0xE9, 0x73, 0x00

loc_020C0:  ; 020C0
  db 0x06                                     ; 020C0  push es
  db 0x26, 0x8E, 0x06, 0x2E, 0x00             ; 020C1  mov es, word [es:0x2e]
  db 0x26, 0x8B, 0x5C, 0x02                   ; 020C6  mov bx, word [es:si + 2]
  db 0x83, 0x7F, 0x16, 0x00                   ; 020CA  cmp word p_mem[bx], 0
  jne loc_020EC                                ; 020CE  0x75, 0x1C
  db 0x07                                     ; 020D0  pop es
  db 0x84, 0xC0                               ; 020D1  test al, al
  je loc_020DA                                 ; 020D3  0x74, 0x05
  db 0xB9, 0x0E, 0x00                         ; 020D5  mov cx, 0xe
  jmp short loc_02133                          ; 020D8  0xEB, 0x59

loc_020DA:  ; 020DA
  db 0x53                                     ; 020DA  push bx
  db 0x56                                     ; 020DB  push si
  db 0x8D, 0x57, 0x12                         ; 020DC  lea dx, p_dsk[bx]
  db 0xB3, 0x06                               ; 020DF  mov bl, 6
  call bdos1_lock_disk_cli                               ; 020E1  0xE8, 0xEC, 0x00
  db 0x5E                                     ; 020E4  pop si
  db 0x5B                                     ; 020E5  pop bx
  db 0x06                                     ; 020E6  push es
  db 0x26, 0x8E, 0x06, 0x2E, 0x00             ; 020E7  mov es, word [es:0x2e]

loc_020EC:  ; 020EC
  db 0x26, 0x8B, 0x7C, 0x06                   ; 020EC  mov di, word [es:si + 6]
  db 0x8B, 0x4F, 0x0E                         ; 020F0  mov cx, word [bx + 0xe]
  db 0x85, 0xC9                               ; 020F3  test cx, cx
  jne loc_0210A                                ; 020F5  0x75, 0x13
  db 0x33, 0xC0                               ; 020F7  xor ax, ax
  db 0xF7, 0x47, 0x04, 0x01, 0x00             ; 020F9  test word [bx + 4], 1
  je loc_02120                                 ; 020FE  0x74, 0x20
  db 0xA1, 0x68, 0x00                         ; 02100  mov ax, word [0x68]
  db 0x89, 0x47, 0x1A                         ; 02103  mov word p_wait[bx], ax
  db 0x33, 0xC0                               ; 02106  xor ax, ax
  jmp short loc_02120                          ; 02108  0xEB, 0x16

loc_0210A:  ; 0210A
  db 0x8B, 0x47, 0x18                         ; 0210A  mov ax, word p_cmod[bx]
  db 0x50                                     ; 0210D  push ax
  db 0xF7, 0xE1                               ; 0210E  mul cx
  db 0x03, 0x47, 0x1A                         ; 02110  add ax, word p_wait[bx]
  db 0x8B, 0xF0                               ; 02113  mov si, ax
  db 0xF3, 0xA4                               ; 02115  rep movsb
  db 0x58                                     ; 02117  pop ax
  db 0x40                                     ; 02118  inc ax
  db 0x3B, 0x47, 0x10                         ; 02119  cmp ax, word p_uda[bx]
  jne loc_02120                                ; 0211C  0x75, 0x02
  db 0x33, 0xC0                               ; 0211E  xor ax, ax

loc_02120:  ; 02120
  db 0x07                                     ; 02120  pop es
  db 0x89, 0x47, 0x18                         ; 02121  mov word p_cmod[bx], ax
  db 0xFF, 0x4F, 0x16                         ; 02124  dec word p_mem[bx]
  db 0x8D, 0x57, 0x14                         ; 02127  lea dx, p_ldsk[bx]
  call bdos1_test_chain_head                               ; 0212A  0xE8, 0xCD, 0x00
  call bdos1_mxdisk_unsync                               ; 0212D  0xE8, 0xBC, 0x00
  db 0x33, 0xDB                               ; 02130  xor bx, bx
  db 0xC3                                     ; 02132  ret

loc_02133:  ; 02133
  call bdos1_mxdisk_unsync                               ; 02133  0xE8, 0xB6, 0x00
  db 0xBB, 0xFF, 0xFF                         ; 02136  mov bx, 0xffff
  db 0xC3                                     ; 02139  ret

bdos1_fn09_write_seq:  ; 0213A
  db 0x32, 0xC0                               ; 0213A  xor al, al
  jmp short loc_02140                          ; 0213C  0xEB, 0x02

bdos1_fn10_write_rand:  ; 0213E
  db 0xB0, 0xFF                               ; 0213E  mov al, 0xff

loc_02140:  ; 02140
  db 0x50                                     ; 02140  push ax
  call bdos1_mxdisk_sync                               ; 02141  0xE8, 0x9A, 0x00
  call bdos1_load_u_wrkseg_fcb                               ; 02144  0xE8, 0xCB, 0x00
  db 0x58                                     ; 02147  pop ax
  db 0x8B, 0xFA                               ; 02148  mov di, dx
  jcxz loc_0214F                               ; 0214A  0xE3, 0x03
  jmp near loc_021C9                           ; 0214C  0xE9, 0x7A, 0x00

loc_0214F:  ; 0214F
  db 0x06                                     ; 0214F  push es
  db 0x26, 0x8E, 0x06, 0x2E, 0x00             ; 02150  mov es, word [es:0x2e]
  db 0x26, 0x8B, 0x5D, 0x02                   ; 02155  mov bx, word [es:di + 2]
  db 0x8B, 0x4F, 0x16                         ; 02159  mov cx, word p_mem[bx]
  db 0x3B, 0x4F, 0x10                         ; 0215C  cmp cx, word p_uda[bx]
  jne loc_0217D                                ; 0215F  0x75, 0x1C
  db 0x07                                     ; 02161  pop es
  db 0x84, 0xC0                               ; 02162  test al, al
  je loc_0216B                                 ; 02164  0x74, 0x05
  db 0xB9, 0x0F, 0x00                         ; 02166  mov cx, 0xf
  jmp short loc_021C9                          ; 02169  0xEB, 0x5E

loc_0216B:  ; 0216B
  db 0x53                                     ; 0216B  push bx
  db 0x57                                     ; 0216C  push di
  db 0x8D, 0x57, 0x14                         ; 0216D  lea dx, p_ldsk[bx]
  db 0xB3, 0x07                               ; 02170  mov bl, 7
  call bdos1_lock_disk_cli                               ; 02172  0xE8, 0x5B, 0x00
  db 0x5F                                     ; 02175  pop di
  db 0x5B                                     ; 02176  pop bx
  db 0x06                                     ; 02177  push es
  db 0x26, 0x8E, 0x06, 0x2E, 0x00             ; 02178  mov es, word [es:0x2e]

loc_0217D:  ; 0217D
  db 0x26, 0x8B, 0x75, 0x06                   ; 0217D  mov si, word [es:di + 6]
  db 0x8B, 0x4F, 0x0E                         ; 02181  mov cx, word [bx + 0xe]
  db 0x85, 0xC9                               ; 02184  test cx, cx
  jne loc_02196                                ; 02186  0x75, 0x0E
  db 0xF7, 0x47, 0x04, 0x01, 0x00             ; 02188  test word [bx + 4], 1
  je loc_021B9                                 ; 0218D  0x74, 0x2A
  db 0x33, 0xC0                               ; 0218F  xor ax, ax
  db 0x89, 0x47, 0x1A                         ; 02191  mov word p_wait[bx], ax
  jmp short loc_021B9                          ; 02194  0xEB, 0x23

loc_02196:  ; 02196
  db 0x8B, 0x47, 0x18                         ; 02196  mov ax, word p_cmod[bx]
  db 0x03, 0x47, 0x16                         ; 02199  add ax, word p_mem[bx]
  db 0x3B, 0x47, 0x10                         ; 0219C  cmp ax, word p_uda[bx]
  jb loc_021A4                                 ; 0219F  0x72, 0x03
  db 0x2B, 0x47, 0x10                         ; 021A1  sub ax, word p_uda[bx]

loc_021A4:  ; 021A4
  db 0xF7, 0xE1                               ; 021A4  mul cx
  db 0x03, 0x47, 0x1A                         ; 021A6  add ax, word p_wait[bx]
  db 0x8B, 0xF8                               ; 021A9  mov di, ax
  db 0x8C, 0xD8                               ; 021AB  mov ax, ds
  db 0x8C, 0xC2                               ; 021AD  mov dx, es
  db 0x8E, 0xC0                               ; 021AF  mov es, ax
  db 0x8E, 0xDA                               ; 021B1  mov ds, dx
  db 0xF3, 0xA4                               ; 021B3  rep movsb
  db 0x8C, 0xC0                               ; 021B5  mov ax, es
  db 0x8E, 0xD8                               ; 021B7  mov ds, ax

loc_021B9:  ; 021B9
  db 0x07                                     ; 021B9  pop es
  db 0xFF, 0x47, 0x16                         ; 021BA  inc word p_mem[bx]
  db 0x8D, 0x57, 0x12                         ; 021BD  lea dx, p_dsk[bx]
  call bdos1_test_chain_head                               ; 021C0  0xE8, 0x37, 0x00
  call bdos1_mxdisk_unsync                               ; 021C3  0xE8, 0x26, 0x00
  db 0x33, 0xDB                               ; 021C6  xor bx, bx
  db 0xC3                                     ; 021C8  ret

loc_021C9:  ; 021C9
  call bdos1_mxdisk_unsync                               ; 021C9  0xE8, 0x20, 0x00
  db 0xBB, 0xFF, 0xFF                         ; 021CC  mov bx, 0xffff
  db 0xC3                                     ; 021CF  ret

bdos1_lock_disk_cli:  ; 021D0
  db 0x9C                                     ; 021D0  pushf
  db 0xFA                                     ; 021D1  cli
  db 0x53                                     ; 021D2  push bx
  db 0x52                                     ; 021D3  push dx
  call bdos1_mxdisk_unsync                               ; 021D4  0xE8, 0x15, 0x00
  db 0x5A                                     ; 021D7  pop dx
  db 0x5B                                     ; 021D8  pop bx
  call bdos1_fn18_flag_wait                    ; 021D9  0xE8, 0x60, 0xF5
  db 0x9D                                     ; 021DC  popf
  db 0xC3                                     ; 021DD  ret

bdos1_mxdisk_sync:  ; 021DE
  db 0x53                                     ; 021DE  push bx
  db 0x52                                     ; 021DF  push dx
  call bdos1_fn23_poll_device                  ; 021E0  0xE8, 0x0F, 0xF6
  db 0xBB, 0xFD, 0x06                         ; 021E3  mov bx, 0x6fd
  call bdos1_fn21_sync                         ; 021E6  0xE8, 0x92, 0xF5
  db 0x5A                                     ; 021E9  pop dx
  db 0x5B                                     ; 021EA  pop bx
  db 0xC3                                     ; 021EB  ret

bdos1_mxdisk_unsync:  ; 021EC
  db 0x53                                     ; 021EC  push bx
  db 0x51                                     ; 021ED  push cx
  db 0xBB, 0xFD, 0x06                         ; 021EE  mov bx, 0x6fd
  call bdos1_fn22_unsync                       ; 021F1  0xE8, 0xA6, 0xF5
  call bdos1_fn24_test_device                  ; 021F4  0xE8, 0x1E, 0xF6
  db 0x59                                     ; 021F7  pop cx
  db 0x5B                                     ; 021F8  pop bx
  db 0xC3                                     ; 021F9  ret

bdos1_test_chain_head:  ; 021FA
  db 0x9C                                     ; 021FA  pushf
  db 0xFA                                     ; 021FB  cli
  db 0x8B, 0xDA                               ; 021FC  mov bx, dx
  db 0x8B, 0x17                               ; 021FE  mov dx, word [bx]
  db 0x85, 0xD2                               ; 02200  test dx, dx
  je loc_02210                                 ; 02202  0x74, 0x0C
  db 0x53                                     ; 02204  push bx
  call bdos1_fn25_chain                        ; 02205  0xE8, 0x09, 0xF6
  db 0x5A                                     ; 02208  pop dx
  db 0x9D                                     ; 02209  popf
  db 0xBB, 0xFD, 0x06                         ; 0220A  mov bx, 0x6fd
  jmp near loc_017D3                           ; 0220D  0xE9, 0xC3, 0xF5

loc_02210:  ; 02210
  db 0x9D                                     ; 02210  popf
  db 0xC3                                     ; 02211  ret

bdos1_load_u_wrkseg_fcb:  ; 02212
  db 0x06                                     ; 02212  push es
  db 0x26, 0x8E, 0x06, 0x2E, 0x00             ; 02213  mov es, word [es:0x2e]
  db 0x8B, 0xDA                               ; 02218  mov bx, dx
  db 0x26, 0x8B, 0x5F, 0x02                   ; 0221A  mov bx, word [es:bx + 2]
  db 0x07                                     ; 0221E  pop es
  db 0x8D, 0x36, 0x74, 0x00                   ; 0221F  lea si, [0x74]

loc_02223:  ; 02223
  db 0x8B, 0x34                               ; 02223  mov si, word [si]
  db 0x85, 0xF6                               ; 02225  test si, si
  je loc_02230                                 ; 02227  0x74, 0x07
  db 0x3B, 0xDE                               ; 02229  cmp bx, si
  jne loc_02223                                ; 0222B  0x75, 0xF6
  db 0x33, 0xC9                               ; 0222D  xor cx, cx
  db 0xC3                                     ; 0222F  ret

loc_02230:  ; 02230
  db 0xB9, 0x09, 0x00                         ; 02230  mov cx, 9
  db 0xC3                                     ; 02233  ret

bdos1_get_abs_para_1c:  ; 02234
  db 0x52                                     ; 02234  push dx
  db 0xBB, 0x1C, 0x00                         ; 02235  mov bx, 0x1c
  call bdos1_calc_abs_para                               ; 02238  0xE8, 0x97, 0x00
  jcxz loc_0224E                               ; 0223B  0xE3, 0x11
  db 0x26, 0xA1, 0x2E, 0x00                   ; 0223D  mov ax, word [es:0x2e]
  db 0x8C, 0xDB                               ; 02241  mov bx, ds
  db 0x2B, 0xC3                               ; 02243  sub ax, bx
  db 0xB1, 0x04                               ; 02245  mov cl, 4
  db 0xD3, 0xE0                               ; 02247  shl ax, cl
  db 0x5F                                     ; 02249  pop di
  db 0x03, 0xF8                               ; 0224A  add di, ax
  jmp short loc_0227C                          ; 0224C  0xEB, 0x2E

loc_0224E:  ; 0224E
  db 0x8B, 0x3E, 0x5E, 0x00                   ; 0224E  mov di, word [0x5e]
  db 0x85, 0xFF                               ; 02252  test di, di
  jne loc_0225B                                ; 02254  0x75, 0x05
  db 0x5A                                     ; 02256  pop dx
  db 0xB9, 0x07, 0x00                         ; 02257  mov cx, 7
  db 0xC3                                     ; 0225A  ret

loc_0225B:  ; 0225B
  db 0x8B, 0x05                               ; 0225B  mov ax, word [di]
  db 0xA3, 0x5E, 0x00                         ; 0225D  mov word [0x5e], ax
  db 0x5E                                     ; 02260  pop si
  db 0x57                                     ; 02261  push di
  db 0xB9, 0x0E, 0x00                         ; 02262  mov cx, 0xe
  db 0x8C, 0xD8                               ; 02265  mov ax, ds
  db 0x26, 0x8E, 0x1E, 0x2E, 0x00             ; 02267  mov ds, word [es:0x2e]
  db 0x06                                     ; 0226C  push es
  db 0x8E, 0xC0                               ; 0226D  mov es, ax
  db 0xF3, 0xA5                               ; 0226F  rep movsw
  db 0x8C, 0xC0                               ; 02271  mov ax, es
  db 0x8E, 0xD8                               ; 02273  mov ds, ax
  db 0x07                                     ; 02275  pop es
  db 0x5F                                     ; 02276  pop di
  db 0x81, 0x4D, 0x04, 0x10, 0x00             ; 02277  or word [di + 4], 0x10

loc_0227C:  ; 0227C
  db 0x33, 0xC9                               ; 0227C  xor cx, cx
  db 0x39, 0x4D, 0x10                         ; 0227E  cmp word p_uda[di], cx
  jne loc_02288                                ; 02281  0x75, 0x05
  db 0xB9, 0x08, 0x00                         ; 02283  mov cx, 8
  jmp short loc_022C8                          ; 02286  0xEB, 0x40

loc_02288:  ; 02288
  db 0xF7, 0x45, 0x04, 0x01, 0x00             ; 02288  test word [di + 4], 1
  jne loc_02294                                ; 0228D  0x75, 0x05
  db 0x39, 0x4D, 0x0E                         ; 0228F  cmp word [di + 0xe], cx
  jne loc_02298                                ; 02292  0x75, 0x04

loc_02294:  ; 02294
  db 0x89, 0x4D, 0x1A                         ; 02294  mov word p_wait[di], cx
  db 0xC3                                     ; 02297  ret

loc_02298:  ; 02298
  db 0x83, 0x7D, 0x1A, 0x00                   ; 02298  cmp word p_wait[di], 0
  je loc_022C0                                 ; 0229C  0x74, 0x22
  db 0x8B, 0x45, 0x0E                         ; 0229E  mov ax, word [di + 0xe]
  db 0xF7, 0x65, 0x10                         ; 022A1  mul word p_uda[di]
  db 0x8B, 0xD8                               ; 022A4  mov bx, ax
  db 0x8B, 0x55, 0x1A                         ; 022A6  mov dx, word p_wait[di]
  call bdos1_calc_abs_para                               ; 022A9  0xE8, 0x26, 0x00
  jcxz loc_022C0                               ; 022AC  0xE3, 0x12
  db 0x26, 0xA1, 0x2E, 0x00                   ; 022AE  mov ax, word [es:0x2e]
  db 0x8C, 0xDB                               ; 022B2  mov bx, ds
  db 0x2B, 0xC3                               ; 022B4  sub ax, bx
  db 0xB1, 0x04                               ; 022B6  mov cl, 4
  db 0xD3, 0xE0                               ; 022B8  shl ax, cl
  db 0x01, 0x45, 0x1A                         ; 022BA  add word p_wait[di], ax
  db 0x33, 0xC9                               ; 022BD  xor cx, cx
  db 0xC3                                     ; 022BF  ret

loc_022C0:  ; 022C0
  call bdos1_calc_record_offset                               ; 022C0  0xE8, 0x3F, 0x00
  jcxz loc_022D1                               ; 022C3  0xE3, 0x0C
  db 0xB9, 0x08, 0x00                         ; 022C5  mov cx, 8

loc_022C8:  ; 022C8
  db 0xA1, 0x5E, 0x00                         ; 022C8  mov ax, word [0x5e]
  db 0x89, 0x05                               ; 022CB  mov word [di], ax
  db 0x89, 0x3E, 0x5E, 0x00                   ; 022CD  mov word [0x5e], di

loc_022D1:  ; 022D1
  db 0xC3                                     ; 022D1  ret

bdos1_calc_abs_para:  ; 022D2
  db 0x03, 0xD3                               ; 022D2  add dx, bx
  jb loc_022FF                                 ; 022D4  0x72, 0x29
  db 0x83, 0xC2, 0x0F                         ; 022D6  add dx, 0xf
  db 0xB1, 0x04                               ; 022D9  mov cl, 4
  db 0xD3, 0xEA                               ; 022DB  shr dx, cl
  db 0x26, 0x03, 0x16, 0x2E, 0x00             ; 022DD  add dx, word [es:0x2e]
  jb loc_022FF                                 ; 022E2  0x72, 0x1B
  db 0x2E, 0xA1, 0x06, 0x00                   ; 022E4  mov ax, word [cs:6]
  db 0x3B, 0xD0                               ; 022E8  cmp dx, ax
  jb loc_022FF                                 ; 022EA  0x72, 0x13
  db 0x05, 0x00, 0x10                         ; 022EC  add ax, 0x1000
  db 0x3B, 0x06, 0x44, 0x00                   ; 022EF  cmp ax, word [0x44]
  jb loc_022F8                                 ; 022F3  0x72, 0x03
  db 0xA1, 0x44, 0x00                         ; 022F5  mov ax, word [0x44]

loc_022F8:  ; 022F8
  db 0x3B, 0xD0                               ; 022F8  cmp dx, ax
  ja loc_022FF                                 ; 022FA  0x77, 0x03
  db 0xB1, 0x01                               ; 022FC  mov cl, 1
  db 0xC3                                     ; 022FE  ret

loc_022FF:  ; 022FF
  db 0x33, 0xC9                               ; 022FF  xor cx, cx
  db 0xC3                                     ; 02301  ret

bdos1_calc_record_offset:  ; 02302
  db 0x8B, 0x45, 0x0E                         ; 02302  mov ax, word [di + 0xe]
  db 0xF7, 0x65, 0x10                         ; 02305  mul word p_uda[di]
  db 0x33, 0xC9                               ; 02308  xor cx, cx
  db 0x51                                     ; 0230A  push cx
  db 0x51                                     ; 0230B  push cx
  db 0x50                                     ; 0230C  push ax
  db 0x50                                     ; 0230D  push ax
  db 0x51                                     ; 0230E  push cx
  db 0x8B, 0xD4                               ; 0230F  mov dx, sp
  db 0x8C, 0xD0                               ; 02311  mov ax, ss
  db 0x8E, 0xD8                               ; 02313  mov ds, ax
  db 0xBB, 0x60, 0x00                         ; 02315  mov bx, 0x60
  db 0x57                                     ; 02318  push di
  db 0xB9, 0x09, 0x03                         ; 02319  mov cx, 0x309
  call bdos1_far_call_user                               ; 0231C  0xE8, 0xCD, 0xF3
  db 0x5F                                     ; 0231F  pop di
  db 0x2E, 0x8E, 0x1E, 0x06, 0x00             ; 02320  mov ds, word [cs:6]
  db 0x83, 0xF9, 0x00                         ; 02325  cmp cx, 0
  jne loc_02332                                ; 02328  0x75, 0x08
  db 0x8B, 0xEC                               ; 0232A  mov bp, sp
  db 0x8B, 0x46, 0x00                         ; 0232C  mov ax, word [bp]
  db 0x89, 0x45, 0x1A                         ; 0232F  mov word p_wait[di], ax

loc_02332:  ; 02332
  db 0x83, 0xC4, 0x0A                         ; 02332  add sp, 0xa
  db 0xC3                                     ; 02335  ret

bdos1_link_free_buffer:  ; 02336
  db 0x8B, 0x45, 0x04                         ; 02336  mov ax, word [di + 4]
  db 0x25, 0x10, 0x00                         ; 02339  and ax, 0x10
  je loc_02349                                 ; 0233C  0x74, 0x0B
  db 0xA1, 0x5E, 0x00                         ; 0233E  mov ax, word [0x5e]
  db 0x89, 0x05                               ; 02341  mov word [di], ax
  db 0x89, 0x3E, 0x5E, 0x00                   ; 02343  mov word [0x5e], di
  jmp short loc_0234A                          ; 02347  0xEB, 0x01

loc_02349:  ; 02349
  db 0xC3                                     ; 02349  ret

loc_0234A:  ; 0234A
  db 0x8B, 0x45, 0x1A                         ; 0234A  mov ax, word p_wait[di]
  db 0xB9, 0x60, 0x00                         ; 0234D  mov cx, 0x60
  db 0x50                                     ; 02350  push ax
  db 0x50                                     ; 02351  push ax
  db 0x51                                     ; 02352  push cx
  db 0xB9, 0x0A, 0x03                         ; 02353  mov cx, 0x30a
  db 0x8B, 0xD4                               ; 02356  mov dx, sp
  db 0x8C, 0xD0                               ; 02358  mov ax, ss
  db 0x8E, 0xD8                               ; 0235A  mov ds, ax
  call bdos1_far_call_user                               ; 0235C  0xE8, 0x8D, 0xF3
  db 0x83, 0xC4, 0x06                         ; 0235F  add sp, 6
  db 0x2E, 0x8E, 0x1E, 0x06, 0x00             ; 02362  mov ds, word [cs:6]
  db 0xC3                                     ; 02367  ret

bdos1_fn20_flush_buffers:  ; 02368
  db 0x06                                     ; 02368  push es
  db 0x26, 0x8E, 0x06, 0x2E, 0x00             ; 02369  mov es, word [es:0x2e]

loc_0236E:  ; 0236E
  db 0x8B, 0xF2                               ; 0236E  mov si, dx
  db 0x8B, 0x5F, 0x02                         ; 02370  mov bx, word [bx + 2]
  db 0x83, 0xFB, 0x00                         ; 02373  cmp bx, 0
  je loc_02396                                 ; 02376  0x74, 0x1E
  db 0xB1, 0x00                               ; 02378  mov cl, 0
  db 0x8D, 0x7F, 0x08                         ; 0237A  lea di, [bx + 8]

loc_0237D:  ; 0237D
  db 0x80, 0xF9, 0x08                         ; 0237D  cmp cl, 8
  je loc_02391                                 ; 02380  0x74, 0x0F
  db 0x26, 0x8A, 0x04                         ; 02382  mov al, byte [es:si]
  db 0x2A, 0x05                               ; 02385  sub al, byte [di]
  db 0xD0, 0xE0                               ; 02387  shl al, 1
  jne loc_0236E                                ; 02389  0x75, 0xE3
  db 0xFE, 0xC1                               ; 0238B  inc cl
  db 0x46                                     ; 0238D  inc si
  db 0x47                                     ; 0238E  inc di
  jmp short loc_0237D                          ; 0238F  0xEB, 0xEC

loc_02391:  ; 02391
  db 0xB9, 0x00, 0x00                         ; 02391  mov cx, 0
  jmp short loc_0239C                          ; 02394  0xEB, 0x06

loc_02396:  ; 02396
  db 0xB9, 0x14, 0x00                         ; 02396  mov cx, 0x14
  db 0xBB, 0xFF, 0xFF                         ; 02399  mov bx, 0xffff

loc_0239C:  ; 0239C
  db 0x07                                     ; 0239C  pop es
  db 0xC3                                     ; 0239D  ret

bdos1_fn00_disk_reset:  ; 0239E
  db 0x33, 0xD2                               ; 0239E  xor dx, dx
  db 0xB9, 0x8F, 0x00                         ; 023A0  mov cx, 0x8f
  jmp near bdos1_far_call_user                           ; 023A3  0xE9, 0x46, 0xF3

bdos1_fn13_seldisk:  ; 023A6
  db 0x8B, 0x1E, 0x68, 0x00                   ; 023A6  mov bx, word [0x68]
  call bdos1_check_disk_flags                               ; 023AA  0xE8, 0x37, 0x02
  jcxz loc_023B2                               ; 023AD  0xE3, 0x03
  jmp near loc_02446                           ; 023AF  0xE9, 0x94, 0x00

loc_023B2:  ; 023B2
  db 0x8B, 0x1E, 0x68, 0x00                   ; 023B2  mov bx, word [0x68]
  db 0xFA                                     ; 023B6  cli
  db 0x8E, 0x57, 0x10                         ; 023B7  mov ss, word p_uda[bx]
  db 0xBC, 0x00, 0x01                         ; 023BA  mov sp, 0x100
  db 0xFB                                     ; 023BD  sti
  db 0xC6, 0x47, 0x05, 0x20                   ; 023BE  mov byte [bx + 5], 0x20
  db 0xBB, 0x0D, 0x07                         ; 023C2  mov bx, 0x70d
  call bdos1_fn21_sync                         ; 023C5  0xE8, 0xB3, 0xF3
  db 0x33, 0xD2                               ; 023C8  xor dx, dx
  db 0xBB, 0x70, 0x00                         ; 023CA  mov bx, 0x70
  db 0xA1, 0x68, 0x00                         ; 023CD  mov ax, word [0x68]

loc_023D0:  ; 023D0
  db 0x8B, 0x5F, 0x02                         ; 023D0  mov bx, word [bx + 2]
  db 0x85, 0xDB                               ; 023D3  test bx, bx
  je loc_023E1                                 ; 023D5  0x74, 0x0A
  db 0x39, 0x47, 0x1E                         ; 023D7  cmp word p_parent[bx], ax
  jne loc_023D0                                ; 023DA  0x75, 0xF4
  db 0x89, 0x57, 0x1E                         ; 023DC  mov word p_parent[bx], dx
  jmp short loc_023D0                          ; 023DF  0xEB, 0xEF

loc_023E1:  ; 023E1
  db 0xBB, 0x0D, 0x07                         ; 023E1  mov bx, 0x70d
  call bdos1_fn22_unsync                       ; 023E4  0xE8, 0xB3, 0xF3
  db 0x8B, 0x1E, 0x68, 0x00                   ; 023E7  mov bx, word [0x68]
  db 0xF7, 0x47, 0x06, 0x80, 0x00             ; 023EB  test word [bx + 6], 0x80
  je loc_02403                                 ; 023F0  0x74, 0x11
  db 0x81, 0x67, 0x06, 0x7F, 0xFF             ; 023F2  and word [bx + 6], 0xff7f
  db 0x8B, 0x5F, 0x1E                         ; 023F7  mov bx, word p_parent[bx]
  db 0x85, 0xDB                               ; 023FA  test bx, bx
  je loc_02403                                 ; 023FC  0x74, 0x05
  db 0x81, 0x4F, 0x06, 0x00, 0x08             ; 023FE  or word [bx + 6], 0x800

loc_02403:  ; 02403
  db 0x26, 0xC6, 0x06, 0x10, 0x00, 0xFE       ; 02403  mov byte [es:0x10], 0xfe
  db 0xB9, 0x8F, 0x07                         ; 02409  mov cx, 0x78f
  call bdos1_far_call_user                               ; 0240C  0xE8, 0xDD, 0xF2
  db 0xB9, 0x2E, 0x05                         ; 0240F  mov cx, 0x52e
  call bdos1_far_call_user                               ; 02412  0xE8, 0xD7, 0xF2
  db 0xBB, 0xFD, 0x06                         ; 02415  mov bx, 0x6fd
  call bdos1_fn21_sync                         ; 02418  0xE8, 0x60, 0xF3
  call bdos1_load_rlr_si_74                               ; 0241B  0xE8, 0xEC, 0x01
  db 0xBB, 0xFD, 0x06                         ; 0241E  mov bx, 0x6fd
  call bdos1_fn22_unsync                       ; 02421  0xE8, 0x76, 0xF3
  db 0xBB, 0xF5, 0x06                         ; 02424  mov bx, 0x6f5
  call bdos1_fn21_sync                         ; 02427  0xE8, 0x51, 0xF3
  db 0xC6, 0x06, 0xF4, 0x06, 0x01             ; 0242A  mov byte [0x6f4], 1
  db 0xBB, 0x0D, 0x07                         ; 0242F  mov bx, 0x70d
  call bdos1_fn21_sync                         ; 02432  0xE8, 0x46, 0xF3
  db 0xB9, 0x3A, 0x00                         ; 02435  mov cx, 0x3a
  call bdos1_far_call_user                               ; 02438  0xE8, 0xB1, 0xF2
  db 0x8B, 0x1E, 0x68, 0x00                   ; 0243B  mov bx, word [0x68]
  db 0xC6, 0x47, 0x04, 0x04                   ; 0243F  mov byte [bx + 4], 4
  jmp near bdos1_cli_chk_652                           ; 02443  0xE9, 0x6A, 0xF6

loc_02446:  ; 02446
  db 0x49                                     ; 02446  dec cx
  je loc_0244E                                 ; 02447  0x74, 0x05
  db 0x33, 0xDB                               ; 02449  xor bx, bx
  db 0x8B, 0xCB                               ; 0244B  mov cx, bx
  db 0xC3                                     ; 0244D  ret

loc_0244E:  ; 0244E
  db 0xB9, 0x23, 0x00                         ; 0244E  mov cx, 0x23
  db 0xBB, 0xFF, 0xFF                         ; 02451  mov bx, 0xffff
  db 0xC3                                     ; 02454  ret

bdos1_fn17_time_of_day:  ; 02455
  db 0x52                                     ; 02455  push dx
  db 0xBB, 0x0D, 0x07                         ; 02456  mov bx, 0x70d
  call bdos1_fn21_sync                         ; 02459  0xE8, 0x1F, 0xF3
  db 0x5E                                     ; 0245C  pop si
  db 0x1E                                     ; 0245D  push ds
  db 0x26, 0x8E, 0x1E, 0x2E, 0x00             ; 0245E  mov ds, word [es:0x2e]
  db 0x8B, 0x1C                               ; 02463  mov bx, word [si]
  db 0x8B, 0x4C, 0x02                         ; 02465  mov cx, word [si + 2]
  db 0x8A, 0x64, 0x04                         ; 02468  mov ah, byte [si + 4]
  db 0x1F                                     ; 0246B  pop ds
  db 0x51                                     ; 0246C  push cx
  db 0x85, 0xDB                               ; 0246D  test bx, bx
  je loc_02477                                 ; 0246F  0x74, 0x06
  call bdos1_init_di_70                               ; 02471  0xE8, 0x26, 0x01
  db 0x51                                     ; 02474  push cx
  jmp short loc_02481                          ; 02475  0xEB, 0x0A

loc_02477:  ; 02477
  db 0x83, 0xC2, 0x06                         ; 02477  add dx, 6
  db 0xBB, 0x70, 0x00                         ; 0247A  mov bx, 0x70
  call bdos1_zero_cx                               ; 0247D  0xE8, 0x07, 0x01
  db 0x51                                     ; 02480  push cx

loc_02481:  ; 02481
  db 0x53                                     ; 02481  push bx
  db 0xBB, 0x0D, 0x07                         ; 02482  mov bx, 0x70d
  call bdos1_fn22_unsync                       ; 02485  0xE8, 0x12, 0xF3
  db 0x5B                                     ; 02488  pop bx
  db 0x59                                     ; 02489  pop cx
  jcxz loc_024F7                               ; 0248A  0xE3, 0x6B
  db 0x5A                                     ; 0248C  pop dx
  db 0xA1, 0x68, 0x00                         ; 0248D  mov ax, word [0x68]
  db 0x3B, 0xC3                               ; 02490  cmp ax, bx
  jne loc_02497                                ; 02492  0x75, 0x03
  jmp near bdos1_fn13_seldisk                  ; 02494  0xE9, 0x0F, 0xFF

loc_02497:  ; 02497
  db 0xC6, 0x06, 0x52, 0x06, 0xFF             ; 02497  mov byte [0x652], 0xff
  db 0x81, 0x4F, 0x06, 0x80, 0x00             ; 0249C  or word [bx + 6], 0x80
  call bdos1_check_disk_flags                               ; 024A1  0xE8, 0x40, 0x01
  jcxz loc_024AB                               ; 024A4  0xE3, 0x05
  call bdos1_wake_next_process                               ; 024A6  0xE8, 0x2B, 0x01
  jmp short loc_02446                          ; 024A9  0xEB, 0x9B

loc_024AB:  ; 024AB
  db 0x8A, 0x57, 0x04                         ; 024AB  mov dl, byte [bx + 4]
  db 0xB6, 0x00                               ; 024AE  mov dh, 0
  db 0x8B, 0xFA                               ; 024B0  mov di, dx
  db 0x03, 0xFF                               ; 024B2  add di, di
  db 0x2E, 0xFF, 0x95, 0xBF, 0x0E             ; 024B4  call word [cs:di + 0xebf]
  call bdos1_wake_next_process                               ; 024B9  0xE8, 0x18, 0x01
  jcxz loc_024F8                               ; 024BC  0xE3, 0x3A
  db 0xC6, 0x06, 0x52, 0x06, 0x00             ; 024BE  mov byte [0x652], 0
  db 0xC6, 0x47, 0x05, 0x20                   ; 024C3  mov byte [bx + 5], 0x20
  db 0x06                                     ; 024C7  push es
  db 0x8E, 0x47, 0x10                         ; 024C8  mov es, word p_uda[bx]
  db 0xBE, 0xFE, 0x00                         ; 024CB  mov si, 0xfe
  db 0x26, 0x89, 0x36, 0x1C, 0x00             ; 024CE  mov word [es:0x1c], si
  db 0x26, 0x8C, 0x06, 0x1E, 0x00             ; 024D3  mov word [es:0x1e], es
  db 0x26, 0xC7, 0x04, 0x72, 0x0D             ; 024D8  mov word [es:si], 0xd72
  db 0x33, 0xC0                               ; 024DD  xor ax, ax
  db 0x26, 0xA3, 0x4E, 0x00                   ; 024DF  mov word [es:0x4e], ax
  db 0x26, 0xC6, 0x06, 0x1B, 0x00, 0x00       ; 024E3  mov byte [es:0x1b], 0
  db 0x26, 0xFE, 0x06, 0x60, 0x00             ; 024E9  inc byte [es:0x60]
  db 0x07                                     ; 024EE  pop es
  call bdos1_enqueue_head                               ; 024EF  0xE8, 0x87, 0x00
  db 0x33, 0xDB                               ; 024F2  xor bx, bx
  jmp near bdos1_set_p_ready                           ; 024F4  0xE9, 0xAF, 0xF5

loc_024F7:  ; 024F7
  db 0x5A                                     ; 024F7  pop dx

loc_024F8:  ; 024F8
  db 0xB9, 0x14, 0x00                         ; 024F8  mov cx, 0x14
  db 0xBB, 0xFF, 0xFF                         ; 024FB  mov bx, 0xffff
  db 0xC3                                     ; 024FE  ret
  db 0xD5, 0x0E, 0xE4, 0x0E, 0xF0                                 ; 024FF  .....
  db 0x0E                                     ; 02504  push cs
  db 0xE4, 0x0E                               ; 02505  in al, 0xe
  db 0x09, 0x0F                               ; 02507  or word [bx], cx
  db 0xD5, 0x0E                               ; 02509  aad 0xe
  db 0xE4, 0x0E                               ; 0250B  in al, 0xe
  db 0xE4, 0x0E                               ; 0250D  in al, 0xe
  db 0x15, 0x0F, 0xE4                         ; 0250F  adc ax, 0xe40f
  db 0x0E                                     ; 02512  push cs
  db 0xE4, 0x0E                               ; 02513  in al, 0xe
  db 0xBF, 0x68, 0x00                         ; 02515  mov di, 0x68
  call bdos1_load_si_di                               ; 02518  0xE8, 0x91, 0x00
  jcxz loc_0251F                               ; 0251B  0xE3, 0x02
  jmp short loc_02573                          ; 0251D  0xEB, 0x54

loc_0251F:  ; 0251F
  db 0xBF, 0x6C, 0x00                         ; 0251F  mov di, 0x6c
  jmp short loc_0256E                          ; 02522  0xEB, 0x4A
  db 0x06                                     ; 02524  push es
  db 0x8E, 0x47, 0x10                         ; 02525  mov es, word p_uda[bx]
  db 0x26, 0x8B, 0x3E, 0x00, 0x00             ; 02528  mov di, word [es:0]
  db 0x07                                     ; 0252D  pop es
  jmp short loc_0256E                          ; 0252E  0xEB, 0x3E
  db 0xBF, 0x6A, 0x00                         ; 02530  mov di, 0x6a
  call bdos1_load_si_di                               ; 02533  0xE8, 0x76, 0x00
  jcxz loc_02578                               ; 02536  0xE3, 0x40
  db 0x8B, 0x34                               ; 02538  mov si, word [si]
  db 0x85, 0xF6                               ; 0253A  test si, si
  je loc_02547                                 ; 0253C  0x74, 0x09
  db 0x8B, 0x54, 0x1A                         ; 0253E  mov dx, word p_wait[si]
  db 0x03, 0x57, 0x1A                         ; 02541  add dx, word p_wait[bx]
  db 0x89, 0x54, 0x1A                         ; 02544  mov word p_wait[si], dx

loc_02547:  ; 02547
  jmp short loc_02573                          ; 02547  0xEB, 0x2A
  db 0xC6, 0x06, 0x52, 0x06, 0x00             ; 02549  mov byte [0x652], 0
  call bdos1_set_p_ready                               ; 0254E  0xE8, 0x55, 0xF5
  db 0x33, 0xC9                               ; 02551  xor cx, cx
  jmp short loc_02578                          ; 02553  0xEB, 0x23
  db 0x33, 0xC9                               ; 02555  xor cx, cx
  db 0x06                                     ; 02557  push es
  db 0x8E, 0x47, 0x10                         ; 02558  mov es, word p_uda[bx]
  db 0x26, 0x8B, 0x3E, 0x00, 0x00             ; 0255B  mov di, word [es:0]
  db 0x07                                     ; 02560  pop es
  db 0x3B, 0x1D                               ; 02561  cmp bx, word [di]
  jne loc_0256D                                ; 02563  0x75, 0x08
  db 0xFE, 0x45, 0x02                         ; 02565  inc byte [di + 2]
  db 0xC7, 0x05, 0xFF, 0xFF                   ; 02568  mov word [di], 0xffff
  db 0x41                                     ; 0256C  inc cx

loc_0256D:  ; 0256D
  db 0xC3                                     ; 0256D  ret

loc_0256E:  ; 0256E
  call bdos1_load_si_di                               ; 0256E  0xE8, 0x3B, 0x00
  jcxz loc_02578                               ; 02571  0xE3, 0x05

loc_02573:  ; 02573
  db 0x8B, 0x17                               ; 02573  mov dx, word [bx]
  db 0x89, 0x15                               ; 02575  mov word [di], dx
  db 0xC3                                     ; 02577  ret

loc_02578:  ; 02578
  db 0xC3                                     ; 02578  ret

bdos1_enqueue_head:  ; 02579
  db 0x9C                                     ; 02579  pushf
  db 0xFA                                     ; 0257A  cli
  db 0x8B, 0x16, 0x6C, 0x00                   ; 0257B  mov dx, word [0x6c]
  db 0x89, 0x17                               ; 0257F  mov word [bx], dx
  db 0x89, 0x1E, 0x6C, 0x00                   ; 02581  mov word [0x6c], bx
  db 0x9D                                     ; 02585  popf
  db 0xC3                                     ; 02586  ret

bdos1_zero_cx:  ; 02587
  db 0x33, 0xC9                               ; 02587  xor cx, cx

loc_02589:  ; 02589
  db 0x50                                     ; 02589  push ax
  call bdos1_fn20_flush_buffers                ; 0258A  0xE8, 0xDB, 0xFD
  db 0x58                                     ; 0258D  pop ax
  jcxz loc_02593                               ; 0258E  0xE3, 0x03
  db 0x33, 0xC9                               ; 02590  xor cx, cx
  db 0xC3                                     ; 02592  ret

loc_02593:  ; 02593
  db 0x38, 0x67, 0x20                         ; 02593  cmp byte p_cns[bx], ah
  jne loc_02589                                ; 02596  0x75, 0xF1
  db 0x41                                     ; 02598  inc cx
  db 0xC3                                     ; 02599  ret

bdos1_init_di_70:  ; 0259A
  db 0x33, 0xC9                               ; 0259A  xor cx, cx
  db 0xBF, 0x70, 0x00                         ; 0259C  mov di, 0x70

loc_0259F:  ; 0259F
  db 0x8B, 0x7D, 0x02                         ; 0259F  mov di, word [di + 2]
  db 0x85, 0xFF                               ; 025A2  test di, di
  je loc_025AB                                 ; 025A4  0x74, 0x05
  db 0x3B, 0xDF                               ; 025A6  cmp bx, di
  jne loc_0259F                                ; 025A8  0x75, 0xF5
  db 0x41                                     ; 025AA  inc cx

loc_025AB:  ; 025AB
  db 0xC3                                     ; 025AB  ret

bdos1_load_si_di:  ; 025AC
  db 0x8B, 0x35                               ; 025AC  mov si, word [di]
  db 0x33, 0xC9                               ; 025AE  xor cx, cx

loc_025B0:  ; 025B0
  db 0x85, 0xF6                               ; 025B0  test si, si
  je loc_025BF                                 ; 025B2  0x74, 0x0B
  db 0x3B, 0xF3                               ; 025B4  cmp si, bx
  je loc_025BE                                 ; 025B6  0x74, 0x06
  db 0x8B, 0xFE                               ; 025B8  mov di, si
  db 0x8B, 0x34                               ; 025BA  mov si, word [si]
  jmp short loc_025B0                          ; 025BC  0xEB, 0xF2

loc_025BE:  ; 025BE
  db 0x41                                     ; 025BE  inc cx

loc_025BF:  ; 025BF
  db 0xC3                                     ; 025BF  ret
  db 0x8A, 0x0E, 0x4A, 0x00                   ; 025C0  mov cl, byte [0x4a]
  db 0x32, 0xED                               ; 025C4  xor ch, ch
  db 0x8B, 0x3E, 0x56, 0x00                   ; 025C6  mov di, word [0x56]

loc_025CA:  ; 025CA
  db 0x3B, 0x1D                               ; 025CA  cmp bx, word [di]
  je loc_025D3                                 ; 025CC  0x74, 0x05
  db 0x83, 0xC7, 0x03                         ; 025CE  add di, 3
  loop loc_025CA                               ; 025D1  0xE2, 0xF7

loc_025D3:  ; 025D3
  db 0xC3                                     ; 025D3  ret

bdos1_wake_next_process:  ; 025D4
  db 0xC6, 0x06, 0x52, 0x06, 0x00             ; 025D4  mov byte [0x652], 0
  db 0x83, 0x3E, 0x6C, 0x00, 0x00             ; 025D9  cmp word [0x6c], 0
  je loc_025E3                                 ; 025DE  0x74, 0x03
  call bdos1_set_p_ready                               ; 025E0  0xE8, 0xC3, 0xF4

loc_025E3:  ; 025E3
  db 0xC3                                     ; 025E3  ret

bdos1_check_disk_flags:  ; 025E4
  db 0x33, 0xC9                               ; 025E4  xor cx, cx
  db 0x8B, 0x47, 0x06                         ; 025E6  mov ax, word [bx + 6]
  db 0xA9, 0x00, 0x02                         ; 025E9  test ax, 0x200
  je loc_025F4                                 ; 025EC  0x74, 0x06
  db 0x0D, 0x80, 0x00                         ; 025EE  or ax, 0x80
  db 0x49                                     ; 025F1  dec cx
  jmp short loc_02606                          ; 025F2  0xEB, 0x12

loc_025F4:  ; 025F4
  db 0xA9, 0x02, 0x00                         ; 025F4  test ax, 2
  jne loc_02602                                ; 025F7  0x75, 0x09
  db 0xFE, 0xC2                               ; 025F9  inc dl
  je loc_02609                                 ; 025FB  0x74, 0x0C
  db 0xA9, 0x01, 0x00                         ; 025FD  test ax, 1
  je loc_02609                                 ; 02600  0x74, 0x07

loc_02602:  ; 02602
  db 0x25, 0x7F, 0xFF                         ; 02602  and ax, 0xff7f
  db 0x41                                     ; 02605  inc cx

loc_02606:  ; 02606
  db 0x89, 0x47, 0x06                         ; 02606  mov word [bx + 6], ax

loc_02609:  ; 02609
  db 0xC3                                     ; 02609  ret

bdos1_load_rlr_si_74:  ; 0260A
  db 0x8B, 0x1E, 0x68, 0x00                   ; 0260A  mov bx, word [0x68]
  db 0xBE, 0x74, 0x00                         ; 0260E  mov si, 0x74

loc_02611:  ; 02611
  db 0x8B, 0x34                               ; 02611  mov si, word [si]
  db 0x85, 0xF6                               ; 02613  test si, si
  je loc_02637                                 ; 02615  0x74, 0x20
  db 0xF7, 0x44, 0x04, 0x01, 0x00             ; 02617  test word [si + 4], 1
  je loc_02611                                 ; 0261C  0x74, 0xF3
  db 0x3B, 0x5C, 0x1A                         ; 0261E  cmp bx, word p_wait[si]
  jne loc_02611                                ; 02621  0x75, 0xEE
  db 0x56                                     ; 02623  push si
  db 0x33, 0xC0                               ; 02624  xor ax, ax
  db 0x50                                     ; 02626  push ax
  db 0x8B, 0xD4                               ; 02627  mov dx, sp
  db 0xB9, 0x8B, 0x00                         ; 02629  mov cx, 0x8b
  db 0x1E                                     ; 0262C  push ds
  db 0x16                                     ; 0262D  push ss
  db 0x1F                                     ; 0262E  pop ds
  call bdos1_far_call_user                               ; 0262F  0xE8, 0xBA, 0xF0
  db 0x1F                                     ; 02632  pop ds
  db 0x58                                     ; 02633  pop ax
  db 0x58                                     ; 02634  pop ax
  jmp short bdos1_load_rlr_si_74                          ; 02635  0xEB, 0xD3

loc_02637:  ; 02637
  db 0xC3                                     ; 02637  ret
  db 0x90                                     ; 02638  nop
  db 0x90                                     ; 02639  nop
  db 0x90                                     ; 0263A  nop
  db 0x90                                     ; 0263B  nop
  db 0x90                                     ; 0263C  nop
  db 0x90                                     ; 0263D  nop
  db 0x90                                     ; 0263E  nop
  db 0x90                                     ; 0263F  nop
  db 0x90                                     ; 02640  nop
  db 0x90                                     ; 02641  nop
  db 0x90                                     ; 02642  nop
  db 0x90                                     ; 02643  nop
  db 0x90                                     ; 02644  nop
  db 0x90                                     ; 02645  nop
  db 0x90                                     ; 02646  nop
  db 0x90                                     ; 02647  nop
  db 0x90                                     ; 02648  nop
  db 0x90                                     ; 02649  nop
  db 0x90                                     ; 0264A  nop
  db 0x90                                     ; 0264B  nop
  db 0x90                                     ; 0264C  nop
  db 0x90                                     ; 0264D  nop
  db 0x90                                     ; 0264E  nop
  db 0x90                                     ; 0264F  nop
  db 0x90                                     ; 02650  nop
  db 0x90                                     ; 02651  nop
  db 0x90                                     ; 02652  nop
  db 0x90                                     ; 02653  nop
  db 0x90                                     ; 02654  nop
  db 0x90                                     ; 02655  nop
  db 0x90                                     ; 02656  nop
  db 0x90                                     ; 02657  nop
  db 0x90                                     ; 02658  nop
  db 0x90                                     ; 02659  nop
  db 0x90                                     ; 0265A  nop
  db 0x90                                     ; 0265B  nop
  db 0x90                                     ; 0265C  nop
  db 0x90                                     ; 0265D  nop
  db 0x90                                     ; 0265E  nop
  db 0x90                                     ; 0265F  nop
  db 0x90                                     ; 02660  nop
  db 0x90                                     ; 02661  nop
  db 0x90                                     ; 02662  nop
  db 0x90                                     ; 02663  nop
  db 0x90                                     ; 02664  nop
  db 0x90                                     ; 02665  nop
  db 0x90                                     ; 02666  nop
  db 0x90                                     ; 02667  nop
  db 0x90                                     ; 02668  nop
  db 0x90                                     ; 02669  nop
  db 0x90                                     ; 0266A  nop
  db 0x90                                     ; 0266B  nop
  db 0x90                                     ; 0266C  nop
  db 0x90                                     ; 0266D  nop
  db 0x90                                     ; 0266E  nop
  db 0x90                                     ; 0266F  nop
  db 0x90                                     ; 02670  nop
  db 0x90                                     ; 02671  nop
  db 0x90                                     ; 02672  nop
  db 0x90                                     ; 02673  nop
  db 0x90                                     ; 02674  nop
  db 0x90                                     ; 02675  nop
  db 0x90                                     ; 02676  nop
  db 0x90                                     ; 02677  nop
  db 0x90                                     ; 02678  nop
  db 0x90                                     ; 02679  nop
  db 0x90                                     ; 0267A  nop
  db 0x90                                     ; 0267B  nop
  db 0x90                                     ; 0267C  nop
  db 0x90                                     ; 0267D  nop
  db 0x90                                     ; 0267E  nop
  db 0x90                                     ; 0267F  nop
  db 0x90                                     ; 02680  nop
  db 0x90                                     ; 02681  nop
  db 0x90                                     ; 02682  nop
  db 0x90                                     ; 02683  nop
  db 0x90                                     ; 02684  nop
  db 0x90                                     ; 02685  nop
  db 0x90                                     ; 02686  nop
  db 0x90                                     ; 02687  nop
  db 0x90                                     ; 02688  nop
  db 0x90                                     ; 02689  nop
  db 0x90                                     ; 0268A  nop
  db 0x90                                     ; 0268B  nop
  db 0x90                                     ; 0268C  nop
  db 0x90                                     ; 0268D  nop
  db 0x90                                     ; 0268E  nop
  db 0x90                                     ; 0268F  nop
  db 0x90                                     ; 02690  nop
  db 0x90                                     ; 02691  nop
  db 0x90                                     ; 02692  nop
  db 0x90                                     ; 02693  nop
  db 0x90                                     ; 02694  nop
  db 0x90                                     ; 02695  nop
  db 0x90                                     ; 02696  nop
  db 0x90                                     ; 02697  nop
  db 0x90                                     ; 02698  nop
  db 0x90                                     ; 02699  nop
  db 0x90                                     ; 0269A  nop
  db 0x90                                     ; 0269B  nop
  db 0x90                                     ; 0269C  nop
  db 0x90                                     ; 0269D  nop
  db 0x90                                     ; 0269E  nop
  db 0x90                                     ; 0269F  nop
  db 0x90                                     ; 026A0  nop
  db 0x90                                     ; 026A1  nop
  db 0x90                                     ; 026A2  nop
  db 0x90                                     ; 026A3  nop
  db 0x90                                     ; 026A4  nop
  db 0x90                                     ; 026A5  nop
  db 0x90                                     ; 026A6  nop
  db 0x90                                     ; 026A7  nop
  db 0x90                                     ; 026A8  nop
  db 0x90                                     ; 026A9  nop
  db 0x90                                     ; 026AA  nop
  db 0x90                                     ; 026AB  nop
  db 0x90                                     ; 026AC  nop
  db 0x90                                     ; 026AD  nop
  db 0x90                                     ; 026AE  nop
  db 0x90                                     ; 026AF  nop
  db 0x90                                     ; 026B0  nop
  db 0x90                                     ; 026B1  nop
  db 0x90                                     ; 026B2  nop
  db 0x90                                     ; 026B3  nop
  db 0x90                                     ; 026B4  nop
  db 0x90                                     ; 026B5  nop
  db 0x90                                     ; 026B6  nop
  db 0x90                                     ; 026B7  nop
  db 0x00, 0x00                               ; 026B8  add byte [bx + si], al
  db 0x00, 0x00                               ; 026BA  add byte [bx + si], al
  db 0x00, 0x00                               ; 026BC  add byte [bx + si], al
  db 0x00, 0x00                               ; 026BE  add byte [bx + si], al
