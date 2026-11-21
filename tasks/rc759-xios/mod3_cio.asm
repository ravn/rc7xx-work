; =============================================================================
; ccpm.sys — Modul 3: Character I/O (CIOIF.CIO)
; Offset range: 0x031E0 - 0x03AD0
; =============================================================================

  jmp near cio_init                            ; 031E0  0xE9, 0x48, 0x00
  jmp near cio_entry                           ; 031E3  0xE9, 0x80, 0x00
  db 0xFA                                     ; 031E6  cli
  db 0x06                                     ; 031E7  push es
  db 0x03, 0x00                               ; 031E8  add ax, word [bx + si]
  db 0x48                                     ; 031EA  dec ax
  db 0x00, 0x06, 0x43, 0x4F                   ; 031EB  add byte [0x4f43], al
  db 0x50                                     ; 031EF  push ax
  db 0x59                                     ; 031F0  pop cx
  db 0x52                                     ; 031F1  push dx
  db 0x49                                     ; 031F2  dec cx
  db 0x47                                     ; 031F3  inc di
  db 0x48                                     ; 031F4  dec ax
  db 0x54                                     ; 031F5  push sp
  db 0x20, 0x28                               ; 031F6  and byte [bx + si], ch
  db 0x43                                     ; 031F8  inc bx
  db 0x29, 0x20                               ; 031F9  sub word [bx + si], sp
  db 0x31, 0x39                               ; 031FB  xor word [bx + di], di
  db 0x38, 0x32                               ; 031FD  cmp byte [bp + si], dh
  db 0x2C, 0x31                               ; 031FF  sub al, 0x31
  db 0x39, 0x38                               ; 03201  cmp word [bx + si], di
  db 0x33, 0x2C                               ; 03203  xor bp, word [si]
  db 0x31, 0x39                               ; 03205  xor word [bx + di], di
  db 0x38, 0x34                               ; 03207  cmp byte [si], dh
  db 0x20, 0x44, 0x49                         ; 03209  and byte [si + 0x49], al
  db 0x47                                     ; 0320C  inc di
  db 0x49                                     ; 0320D  dec cx
  db 0x54                                     ; 0320E  push sp
  db 0x41                                     ; 0320F  inc cx
  db 0x4C                                     ; 03210  dec sp
  db 0x20, 0x52, 0x45                         ; 03211  and byte [bp + si + 0x45], dl
  db 0x53                                     ; 03214  push bx
  db 0x45                                     ; 03215  inc bp
  db 0x41                                     ; 03216  inc cx
  db 0x52                                     ; 03217  push dx
  db 0x43                                     ; 03218  inc bx
  db 0x48                                     ; 03219  dec ax
  db 0x20, 0x31                               ; 0321A  and byte [bx + di], dh
  db 0x30, 0x33                               ; 0321C  xor byte [bp + di], dh
  db 0x34, 0x2D                               ; 0321E  xor al, 0x2d
  db 0x30, 0x32                               ; 03220  xor byte [bp + si], dh
  db 0x36, 0x31, 0x2D                         ; 03222  xor word [ss:di], bp
  db 0x30, 0x30                               ; 03225  xor byte [bx + si], dh
  db 0x37                                     ; 03227  aaa
  db 0x30, 0x34                               ; 03228  xor byte [si], dh
  db 0x31                                                         ; 0322A  1

cio_init:  ; 0322B
  db 0xCB                                     ; 0322B  retf
  db 0x6B, 0x03, 0x7E                         ; 0322C  imul ax, word [bp + di], 0x7e
  db 0x03, 0x8E, 0x03, 0x94                   ; 0322F  add cx, word [bp - 0x6bfd]
  db 0x03, 0x9A, 0x03, 0xFB                   ; 03233  add bx, word [bp + si - 0x4fd]
  db 0x03, 0x18                               ; 03237  add bx, word [bx + si]
  db 0x04, 0xE6                               ; 03239  add al, 0xe6
  db 0x04, 0xAE                               ; 0323B  add al, 0xae
  db 0x03, 0xBB, 0x00, 0x33                   ; 0323D  add di, word [bp + di + 0x3300]
  db 0x01, 0x8B, 0x02, 0x64                   ; 03241  add word [bp + di + 0x6402], cx
  db 0x01, 0x77, 0x02                         ; 03245  add word [bx + 2], si
  db 0xB0, 0x04                               ; 03248  mov al, 4
  db 0x9F                                     ; 0324A  lahf
  db 0x00, 0x09                               ; 0324B  add byte [bx + di], cl
  db 0x01, 0xAA, 0x02, 0xA3                   ; 0324D  add word [bp + si - 0x5cfe], bp
  db 0x00, 0xBF, 0x00, 0x81                   ; 03251  add byte [bx - 0x7f00], bh
  db 0x02, 0x9B, 0x00, 0x9B                   ; 03255  add bl, byte [bp + di - 0x6500]
  db 0x00, 0x0C                               ; 03259  add byte [si], cl
  db 0x03, 0xD3                               ; 0325B  add dx, bx
  db 0x03, 0x59, 0x03                         ; 0325D  add bx, word [bx + di + 3]
  db 0x46                                     ; 03260  inc si
  db 0x04, 0x57                               ; 03261  add al, 0x57
  db 0x04, 0x63                               ; 03263  add al, 0x63
  db 0x04                                                         ; 03265  .

cio_entry:  ; 03266
  db 0xD1, 0xE1                               ; 03266  shl cx, 1
  db 0x8B, 0xF1                               ; 03268  mov si, cx
  db 0x2E, 0xFF, 0x94, 0x4C, 0x00             ; 0326A  call word [cs:si + 0x4c]
  db 0xCB                                     ; 0326F  retf

cio_xios_far_call:  ; 03270
  db 0x2E, 0xFF, 0x1E, 0x08, 0x00             ; 03270  call far [cs:8]
  db 0xC3                                     ; 03275  ret

cio_xios_call:  ; 03276
  db 0xFF, 0x1E, 0x28, 0x00                   ; 03276  call far [0x28]
  db 0xC3                                     ; 0327A  ret

cio_fn21_notimp:  ; 0327B
  db 0xBB, 0xFF, 0xFF                         ; 0327B  mov bx, 0xffff
  db 0xC3                                     ; 0327E  ret

cio_fn15_lstattach:  ; 0327F
  db 0x33, 0xC9                               ; 0327F  xor cx, cx
  jmp short cio_lcb_verify                          ; 03281  0xEB, 0x03

cio_fn18_clstattch:  ; 03283
  db 0xB9, 0xFF, 0xFF                         ; 03283  mov cx, 0xffff

cio_lcb_verify:  ; 03286
  db 0x51                                     ; 03286  push cx
  db 0x26, 0x8B, 0x36, 0x64, 0x00             ; 03287  mov si, word [es:0x64]
  db 0x85, 0xF6                               ; 0328C  test si, si
  jne loc_03298                                ; 0328E  0x75, 0x08
  call cio_getlcbadr                               ; 03290  0xE8, 0x34, 0x02
  db 0x26, 0x89, 0x36, 0x64, 0x00             ; 03293  mov word [es:0x64], si

loc_03298:  ; 03298
  db 0x59                                     ; 03298  pop cx
  jmp short loc_032B5                          ; 03299  0xEB, 0x1A

cio_fn09_conattach:  ; 0329B
  db 0x33, 0xC9                               ; 0329B  xor cx, cx
  jmp short cio_ccb_verify                          ; 0329D  0xEB, 0x03

cio_fn19_cconattch:  ; 0329F
  db 0xB9, 0xFF, 0xFF                         ; 0329F  mov cx, 0xffff

cio_ccb_verify:  ; 032A2
  db 0x51                                     ; 032A2  push cx
  db 0x26, 0x8B, 0x36, 0x62, 0x00             ; 032A3  mov si, word [es:0x62]
  db 0x85, 0xF6                               ; 032A8  test si, si
  jne loc_032B4                                ; 032AA  0x75, 0x08
  call cio_getccbadr                               ; 032AC  0xE8, 0xFA, 0x01
  db 0x26, 0x89, 0x36, 0x62, 0x00             ; 032AF  mov word [es:0x62], si

loc_032B4:  ; 032B4
  db 0x59                                     ; 032B4  pop cx

loc_032B5:  ; 032B5
  db 0xA1, 0x68, 0x00                         ; 032B5  mov ax, word [0x68]
  db 0x8B, 0xD8                               ; 032B8  mov bx, ax
  db 0x9C                                     ; 032BA  pushf
  db 0xFA                                     ; 032BB  cli
  db 0x3B, 0x1C                               ; 032BC  cmp bx, word [si]
  je loc_032E5                                 ; 032BE  0x74, 0x25
  db 0x83, 0x3C, 0x00                         ; 032C0  cmp word [si], 0
  je loc_032E3                                 ; 032C3  0x74, 0x1E
  jcxz loc_032CF                               ; 032C5  0xE3, 0x08
  db 0x9D                                     ; 032C7  popf
  db 0xBB, 0xFF, 0xFF                         ; 032C8  mov bx, 0xffff
  db 0xB9, 0x24, 0x00                         ; 032CB  mov cx, 0x24
  db 0xC3                                     ; 032CE  ret

loc_032CF:  ; 032CF
  db 0x52                                     ; 032CF  push dx
  db 0x8D, 0x54, 0x02                         ; 032D0  lea dx, [si + 2]
  db 0xB3, 0x09                               ; 032D3  mov bl, 9
  db 0x56                                     ; 032D5  push si
  db 0xB9, 0x12, 0x02                         ; 032D6  mov cx, 0x212
  call cio_xios_far_call                               ; 032D9  0xE8, 0x94, 0xFF
  db 0x5E                                     ; 032DC  pop si
  db 0x5A                                     ; 032DD  pop dx
  db 0x9D                                     ; 032DE  popf
  db 0x33, 0xC9                               ; 032DF  xor cx, cx
  jmp short loc_032B5                          ; 032E1  0xEB, 0xD2

loc_032E3:  ; 032E3
  db 0x89, 0x1C                               ; 032E3  mov word [si], bx

loc_032E5:  ; 032E5
  db 0x9D                                     ; 032E5  popf
  db 0x33, 0xDB                               ; 032E6  xor bx, bx
  db 0xC3                                     ; 032E8  ret

cio_fn16_lstdetach:  ; 032E9
  call cio_lcb_verify                               ; 032E9  0xE8, 0x9A, 0xFF

cio_ciodetach:  ; 032EC
  db 0x8B, 0x1E, 0x68, 0x00                   ; 032EC  mov bx, word [0x68]
  db 0x9C                                     ; 032F0  pushf
  db 0xFA                                     ; 032F1  cli
  db 0x83, 0x3C, 0x00                         ; 032F2  cmp word [si], 0
  je loc_03340                                 ; 032F5  0x74, 0x49
  db 0x39, 0x1C                               ; 032F7  cmp word [si], bx
  je loc_03303                                 ; 032F9  0x74, 0x08
  db 0x9D                                     ; 032FB  popf
  db 0xBB, 0xFF, 0xFF                         ; 032FC  mov bx, 0xffff
  db 0xB9, 0x20, 0x00                         ; 032FF  mov cx, 0x20
  db 0xC3                                     ; 03302  ret

loc_03303:  ; 03303
  db 0x8B, 0x44, 0x02                         ; 03303  mov ax, word [si + 2]
  db 0x89, 0x04                               ; 03306  mov word [si], ax
  db 0xB9, 0x13, 0x02                         ; 03308  mov cx, 0x213
  db 0x8D, 0x54, 0x02                         ; 0330B  lea dx, [si + 2]
  call cio_xios_far_call                               ; 0330E  0xE8, 0x5F, 0xFF
  jmp short loc_03340                          ; 03311  0xEB, 0x2D

cio_fn10_condetach:  ; 03313
  call cio_ccb_verify                               ; 03313  0xE8, 0x8C, 0xFF

cio_condetach_dev:  ; 03316
  db 0x8B, 0x1E, 0x68, 0x00                   ; 03316  mov bx, word [0x68]
  db 0x9C                                     ; 0331A  pushf
  db 0xFA                                     ; 0331B  cli
  db 0x83, 0x3C, 0x00                         ; 0331C  cmp word [si], 0
  je loc_03340                                 ; 0331F  0x74, 0x1F
  db 0x39, 0x1C                               ; 03321  cmp word [si], bx
  je loc_0332D                                 ; 03323  0x74, 0x08
  db 0x9D                                     ; 03325  popf
  db 0xBB, 0xFF, 0xFF                         ; 03326  mov bx, 0xffff
  db 0xB9, 0x20, 0x00                         ; 03329  mov cx, 0x20
  db 0xC3                                     ; 0332C  ret

loc_0332D:  ; 0332D
  db 0x81, 0x64, 0x0E, 0xEF, 0xFF             ; 0332D  and word [si + 0xe], 0xffef
  db 0x8B, 0x44, 0x02                         ; 03332  mov ax, word [si + 2]
  db 0x89, 0x04                               ; 03335  mov word [si], ax
  db 0xB9, 0x13, 0x02                         ; 03337  mov cx, 0x213
  db 0x8D, 0x54, 0x02                         ; 0333A  lea dx, [si + 2]
  call cio_xios_far_call                               ; 0333D  0xE8, 0x30, 0xFF

loc_03340:  ; 03340
  db 0x9D                                     ; 03340  popf
  db 0x33, 0xDB                               ; 03341  xor bx, bx
  db 0xC3                                     ; 03343  ret

cio_fn12_conassign:  ; 03344
  db 0x52                                     ; 03344  push dx
  db 0xBB, 0x0D, 0x07                         ; 03345  mov bx, 0x70d
  db 0xB9, 0x15, 0x02                         ; 03348  mov cx, 0x215
  call cio_xios_far_call                               ; 0334B  0xE8, 0x22, 0xFF
  db 0x5F                                     ; 0334E  pop di
  db 0xC6, 0x06, 0x52, 0x06, 0xFF             ; 0334F  mov byte [0x652], 0xff
  db 0x1E                                     ; 03354  push ds
  db 0x26, 0x8E, 0x1E, 0x2E, 0x00             ; 03355  mov ds, word [es:0x2e]
  db 0x83, 0x7D, 0x02, 0x01                   ; 0335A  cmp word [di + 2], 1
  jbe loc_0337B                                ; 0335E  0x76, 0x1B
  db 0x8B, 0x5D, 0x02                         ; 03360  mov bx, word [di + 2]
  db 0x1F                                     ; 03363  pop ds
  db 0xBE, 0x70, 0x00                         ; 03364  mov si, 0x70

loc_03367:  ; 03367
  db 0x8B, 0x74, 0x02                         ; 03367  mov si, word [si + 2]
  db 0x85, 0xF6                               ; 0336A  test si, si
  je loc_03396                                 ; 0336C  0x74, 0x28
  db 0x3B, 0xDE                               ; 0336E  cmp bx, si
  je loc_03374                                 ; 03370  0x74, 0x02
  jmp short loc_03367                          ; 03372  0xEB, 0xF3

loc_03374:  ; 03374
  call cio_conassign_match                               ; 03374  0xE8, 0xB3, 0x00
  jcxz loc_033A2                               ; 03377  0xE3, 0x29
  jmp short loc_03396                          ; 03379  0xEB, 0x1B

loc_0337B:  ; 0337B
  db 0x1F                                     ; 0337B  pop ds
  db 0xBB, 0x70, 0x00                         ; 0337C  mov bx, 0x70

loc_0337F:  ; 0337F
  db 0x57                                     ; 0337F  push di
  db 0x8D, 0x55, 0x04                         ; 03380  lea dx, [di + 4]
  db 0x26, 0x8E, 0x1E, 0x2E, 0x00             ; 03383  mov ds, word [es:0x2e]
  db 0xB9, 0x14, 0x02                         ; 03388  mov cx, 0x214
  call cio_xios_far_call                               ; 0338B  0xE8, 0xE2, 0xFE
  db 0x2E, 0x8E, 0x1E, 0x06, 0x00             ; 0338E  mov ds, word [cs:6]
  db 0x5F                                     ; 03393  pop di
  jcxz loc_0339B                               ; 03394  0xE3, 0x05

loc_03396:  ; 03396
  db 0xB9, 0x14, 0x00                         ; 03396  mov cx, 0x14
  jmp short loc_033D0                          ; 03399  0xEB, 0x35

loc_0339B:  ; 0339B
  call cio_conassign_match                               ; 0339B  0xE8, 0x8C, 0x00
  jcxz loc_033A2                               ; 0339E  0xE3, 0x02
  jmp short loc_0337F                          ; 033A0  0xEB, 0xDD

loc_033A2:  ; 033A2
  db 0x53                                     ; 033A2  push bx
  db 0x57                                     ; 033A3  push di
  db 0xBB, 0x0D, 0x07                         ; 033A4  mov bx, 0x70d
  db 0xB9, 0x16, 0x02                         ; 033A7  mov cx, 0x216
  call cio_xios_far_call                               ; 033AA  0xE8, 0xC3, 0xFE
  db 0x5F                                     ; 033AD  pop di
  db 0x58                                     ; 033AE  pop ax
  db 0x26, 0x8E, 0x1E, 0x2E, 0x00             ; 033AF  mov ds, word [es:0x2e]
  db 0x50                                     ; 033B4  push ax
  db 0x8A, 0x05                               ; 033B5  mov al, byte [di]
  db 0x2E, 0x8E, 0x1E, 0x06, 0x00             ; 033B7  mov ds, word [cs:6]
  call cio_getccbadr_spec                               ; 033BC  0xE8, 0xF1, 0x00
  db 0x8B, 0x1E, 0x68, 0x00                   ; 033BF  mov bx, word [0x68]
  db 0x58                                     ; 033C3  pop ax
  db 0x83, 0x3C, 0x00                         ; 033C4  cmp word [si], 0
  je loc_033E2                                 ; 033C7  0x74, 0x19
  db 0x39, 0x1C                               ; 033C9  cmp word [si], bx
  je loc_033E2                                 ; 033CB  0x74, 0x15
  db 0xB9, 0x20, 0x00                         ; 033CD  mov cx, 0x20

loc_033D0:  ; 033D0
  db 0x51                                     ; 033D0  push cx
  call cio_wake_disp                               ; 033D1  0xE8, 0x40, 0x00
  db 0xBB, 0x0D, 0x07                         ; 033D4  mov bx, 0x70d
  db 0xB9, 0x16, 0x02                         ; 033D7  mov cx, 0x216
  call cio_xios_far_call                               ; 033DA  0xE8, 0x93, 0xFE
  db 0x59                                     ; 033DD  pop cx
  db 0xBB, 0xFF, 0xFF                         ; 033DE  mov bx, 0xffff
  db 0xC3                                     ; 033E1  ret

loc_033E2:  ; 033E2
  db 0x89, 0x04                               ; 033E2  mov word [si], ax
  db 0x50                                     ; 033E4  push ax
  db 0x56                                     ; 033E5  push si
  call cio_wake_disp                               ; 033E6  0xE8, 0x2B, 0x00
  db 0x5E                                     ; 033E9  pop si
  db 0x58                                     ; 033EA  pop ax
  db 0x8B, 0xD8                               ; 033EB  mov bx, ax
  db 0x83, 0xC6, 0x02                         ; 033ED  add si, 2
  db 0x8B, 0xFE                               ; 033F0  mov di, si

loc_033F2:  ; 033F2
  db 0x83, 0x3C, 0x00                         ; 033F2  cmp word [si], 0
  je loc_03411                                 ; 033F5  0x74, 0x1A
  db 0x39, 0x1C                               ; 033F7  cmp word [si], bx
  je loc_033FF                                 ; 033F9  0x74, 0x04
  db 0x8B, 0x34                               ; 033FB  mov si, word [si]
  jmp short loc_033F2                          ; 033FD  0xEB, 0xF3

loc_033FF:  ; 033FF
  db 0x8B, 0x07                               ; 033FF  mov ax, word [bx]
  db 0x89, 0x04                               ; 03401  mov word [si], ax
  db 0x8B, 0x35                               ; 03403  mov si, word [di]
  db 0x89, 0x1D                               ; 03405  mov word [di], bx
  db 0x89, 0x37                               ; 03407  mov word [bx], si
  db 0x8B, 0xD7                               ; 03409  mov dx, di
  db 0xB9, 0x13, 0x02                         ; 0340B  mov cx, 0x213
  call cio_xios_far_call                               ; 0340E  0xE8, 0x5F, 0xFE

loc_03411:  ; 03411
  db 0x33, 0xDB                               ; 03411  xor bx, bx
  db 0xC3                                     ; 03413  ret

cio_wake_disp:  ; 03414
  db 0xC6, 0x06, 0x52, 0x06, 0x00             ; 03414  mov byte [0x652], 0
  db 0x9C                                     ; 03419  pushf
  db 0xFA                                     ; 0341A  cli
  db 0x83, 0x3E, 0x6C, 0x00, 0x00             ; 0341B  cmp word [0x6c], 0
  je loc_03428                                 ; 03420  0x74, 0x06
  db 0xB9, 0x8E, 0x00                         ; 03422  mov cx, 0x8e
  call cio_xios_far_call                               ; 03425  0xE8, 0x48, 0xFE

loc_03428:  ; 03428
  db 0x9D                                     ; 03428  popf
  db 0xC3                                     ; 03429  ret

cio_conassign_match:  ; 0342A
  db 0x33, 0xC9                               ; 0342A  xor cx, cx
  db 0x06                                     ; 0342C  push es
  db 0x26, 0x8E, 0x06, 0x2E, 0x00             ; 0342D  mov es, word [es:0x2e]
  db 0x26, 0x8B, 0x45, 0x02                   ; 03432  mov ax, word [es:di + 2]
  db 0x3D, 0x01, 0x00                         ; 03436  cmp ax, 1
  ja loc_03445                                 ; 03439  0x77, 0x0A
  db 0x48                                     ; 0343B  dec ax
  jne loc_03445                                ; 0343C  0x75, 0x07
  db 0xF7, 0x47, 0x06, 0x00, 0x20             ; 0343E  test word [bx + 6], 0x2000
  jne loc_03454                                ; 03443  0x75, 0x0F

loc_03445:  ; 03445
  db 0x26, 0x80, 0x7D, 0x01, 0x00             ; 03445  cmp byte [es:di + 1], 0
  je loc_03455                                 ; 0344A  0x74, 0x09
  db 0x26, 0x8A, 0x05                         ; 0344C  mov al, byte [es:di]
  db 0x3A, 0x47, 0x20                         ; 0344F  cmp al, byte p_cns[bx]
  je loc_03455                                 ; 03452  0x74, 0x01

loc_03454:  ; 03454
  db 0x41                                     ; 03454  inc cx

loc_03455:  ; 03455
  db 0x07                                     ; 03455  pop es
  db 0xC3                                     ; 03456  ret

cio_fn13_getdefcon:  ; 03457
  db 0x8B, 0x36, 0x68, 0x00                   ; 03457  mov si, word [0x68]
  db 0x32, 0xFF                               ; 0345B  xor bh, bh
  db 0x8A, 0x5C, 0x20                         ; 0345D  mov bl, byte p_cns[si]
  db 0xC3                                     ; 03460  ret

cio_fn20_getdeflst:  ; 03461
  db 0x8B, 0x36, 0x68, 0x00                   ; 03461  mov si, word [0x68]
  db 0x32, 0xFF                               ; 03465  xor bh, bh
  db 0x8A, 0x5C, 0x24                         ; 03467  mov bl, byte p_lst[si]
  db 0xC3                                     ; 0346A  ret

cio_fn11_setdefcon:  ; 0346B
  db 0x3A, 0x16, 0x83, 0x00                   ; 0346B  cmp dl, byte [0x83]
  jb loc_03478                                 ; 0346F  0x72, 0x07
  db 0xB9, 0x13, 0x00                         ; 03471  mov cx, 0x13
  db 0xBB, 0xFF, 0xFF                         ; 03474  mov bx, 0xffff
  db 0xC3                                     ; 03477  ret

loc_03478:  ; 03478
  db 0x8B, 0x36, 0x68, 0x00                   ; 03478  mov si, word [0x68]
  db 0x88, 0x54, 0x20                         ; 0347C  mov byte p_cns[si], dl
  call cio_getccbadr                               ; 0347F  0xE8, 0x27, 0x00
  db 0x26, 0x89, 0x36, 0x62, 0x00             ; 03482  mov word [es:0x62], si
  db 0x33, 0xDB                               ; 03487  xor bx, bx
  db 0xC3                                     ; 03489  ret

cio_fn17_setdeflst:  ; 0348A
  db 0x3A, 0x16, 0x84, 0x00                   ; 0348A  cmp dl, byte [0x84]
  jb loc_03497                                 ; 0348E  0x72, 0x07
  db 0xB9, 0x25, 0x00                         ; 03490  mov cx, 0x25
  db 0xBB, 0xFF, 0xFF                         ; 03493  mov bx, 0xffff
  db 0xC3                                     ; 03496  ret

loc_03497:  ; 03497
  db 0x8B, 0x36, 0x68, 0x00                   ; 03497  mov si, word [0x68]
  db 0x88, 0x54, 0x24                         ; 0349B  mov byte p_lst[si], dl
  call cio_getlcbadr                               ; 0349E  0xE8, 0x26, 0x00
  db 0x26, 0x89, 0x36, 0x64, 0x00             ; 034A1  mov word [es:0x64], si
  db 0x33, 0xDB                               ; 034A6  xor bx, bx
  db 0xC3                                     ; 034A8  ret

cio_getccbadr:  ; 034A9
  db 0x8B, 0x1E, 0x68, 0x00                   ; 034A9  mov bx, word [0x68]
  db 0x8A, 0x47, 0x20                         ; 034AD  mov al, byte p_cns[bx]

cio_getccbadr_spec:  ; 034B0
  db 0x32, 0xE4                               ; 034B0  xor ah, ah
  db 0x8B, 0x36, 0x54, 0x00                   ; 034B2  mov si, word [0x54]
  db 0xB1, 0x02                               ; 034B6  mov cl, 2
  db 0xD3, 0xE0                               ; 034B8  shl ax, cl
  db 0x03, 0xF0                               ; 034BA  add si, ax
  db 0x03, 0xF0                               ; 034BC  add si, ax
  db 0x03, 0xF0                               ; 034BE  add si, ax
  db 0xB1, 0x03                               ; 034C0  mov cl, 3
  db 0xD3, 0xE0                               ; 034C2  shl ax, cl
  db 0x03, 0xF0                               ; 034C4  add si, ax
  db 0xC3                                     ; 034C6  ret

cio_getlcbadr:  ; 034C7
  db 0x8B, 0x1E, 0x68, 0x00                   ; 034C7  mov bx, word [0x68]
  db 0x32, 0xE4                               ; 034CB  xor ah, ah
  db 0x8A, 0x47, 0x24                         ; 034CD  mov al, byte p_lst[bx]
  db 0x3A, 0x06, 0x48, 0x00                   ; 034D0  cmp al, byte [0x48]
  jbe loc_034DB                                ; 034D4  0x76, 0x05
  db 0xB0, 0x00                               ; 034D6  mov al, 0
  db 0x88, 0x47, 0x24                         ; 034D8  mov byte p_lst[bx], al

loc_034DB:  ; 034DB
  db 0x8B, 0x36, 0x86, 0x00                   ; 034DB  mov si, word [0x86]
  db 0x50                                     ; 034DF  push ax
  db 0xD1, 0xE0                               ; 034E0  shl ax, 1
  db 0x03, 0xF0                               ; 034E2  add si, ax
  db 0x58                                     ; 034E4  pop ax
  db 0xB1, 0x03                               ; 034E5  mov cl, 3
  db 0xD3, 0xE0                               ; 034E7  shl ax, cl
  db 0x03, 0xF0                               ; 034E9  add si, ax
  db 0xC3                                     ; 034EB  ret

cio_fn23_cioterm:  ; 034EC
  db 0xA0, 0x83, 0x00                         ; 034EC  mov al, byte [0x83]
  db 0x8B, 0x36, 0x54, 0x00                   ; 034EF  mov si, word [0x54]

loc_034F3:  ; 034F3
  db 0x3C, 0x00                               ; 034F3  cmp al, 0
  je loc_0351D                                 ; 034F5  0x74, 0x26
  db 0x26, 0x3B, 0x36, 0x62, 0x00             ; 034F7  cmp si, word [es:0x62]
  jne loc_0350F                                ; 034FC  0x75, 0x11
  db 0x80, 0x64, 0x04, 0xC7                   ; 034FE  and byte [si + 4], 0xc7
  db 0xB9, 0x13, 0x02                         ; 03502  mov cx, 0x213
  db 0x8D, 0x54, 0x22                         ; 03505  lea dx, p_conmode[si]
  db 0x50                                     ; 03508  push ax
  db 0x56                                     ; 03509  push si
  call cio_xios_far_call                               ; 0350A  0xE8, 0x63, 0xFD
  db 0x5E                                     ; 0350D  pop si
  db 0x58                                     ; 0350E  pop ax

loc_0350F:  ; 0350F
  db 0x50                                     ; 0350F  push ax
  db 0x56                                     ; 03510  push si
  call cio_condetach_dev                               ; 03511  0xE8, 0x02, 0xFE
  db 0x5E                                     ; 03514  pop si
  db 0x58                                     ; 03515  pop ax
  db 0xFE, 0xC8                               ; 03516  dec al
  db 0x83, 0xC6, 0x2C                         ; 03518  add si, 0x2c
  jmp short loc_034F3                          ; 0351B  0xEB, 0xD6

loc_0351D:  ; 0351D
  db 0xA0, 0x84, 0x00                         ; 0351D  mov al, byte [0x84]
  db 0x8B, 0x36, 0x86, 0x00                   ; 03520  mov si, word [0x86]

loc_03524:  ; 03524
  db 0x3C, 0x00                               ; 03524  cmp al, 0
  je loc_03536                                 ; 03526  0x74, 0x0E
  db 0x50                                     ; 03528  push ax
  db 0x56                                     ; 03529  push si
  call cio_ciodetach                               ; 0352A  0xE8, 0xBF, 0xFD
  db 0x5E                                     ; 0352D  pop si
  db 0x58                                     ; 0352E  pop ax
  db 0xFE, 0xC8                               ; 0352F  dec al
  db 0x83, 0xC6, 0x0A                         ; 03531  add si, 0xa
  jmp short loc_03524                          ; 03534  0xEB, 0xEE

loc_03536:  ; 03536
  db 0x33, 0xDB                               ; 03536  xor bx, bx
  db 0xC3                                     ; 03538  ret

cio_fn25_cmode:  ; 03539
  db 0x8B, 0x1E, 0x68, 0x00                   ; 03539  mov bx, word [0x68]
  db 0x42                                     ; 0353D  inc dx
  je loc_03547                                 ; 0353E  0x74, 0x07
  db 0x4A                                     ; 03540  dec dx
  db 0x89, 0x57, 0x22                         ; 03541  mov word p_conmode[bx], dx
  db 0x33, 0xDB                               ; 03544  xor bx, bx
  db 0xC3                                     ; 03546  ret

loc_03547:  ; 03547
  db 0x8B, 0x5F, 0x22                         ; 03547  mov bx, word p_conmode[bx]
  db 0xC3                                     ; 0354A  ret

cio_fn00_conin:  ; 0354B
  call cio_clr_raw_mode                               ; 0354B  0xE8, 0xBE, 0x02
  call cio_coninf                               ; 0354E  0xE8, 0xE7, 0x03
  db 0x8A, 0xD0                               ; 03551  mov dl, al
  call cio_chk_ctrlp                               ; 03553  0xE8, 0xD8, 0x02
  jb loc_0355B                                 ; 03556  0x72, 0x03
  call cio_tabout                               ; 03558  0xE8, 0x82, 0x03

loc_0355B:  ; 0355B
  db 0x8A, 0xDA                               ; 0355B  mov bl, dl
  db 0xC3                                     ; 0355D  ret

cio_fn01_conout:  ; 0355E
  call cio_clr_raw_mode                               ; 0355E  0xE8, 0xAB, 0x02
  db 0xF7, 0x47, 0x22, 0x04, 0x00             ; 03561  test word p_conmode[bx], 4
  je loc_0356B                                 ; 03566  0x74, 0x03
  jmp near cio_conoutf                           ; 03568  0xE9, 0x09, 0x04

loc_0356B:  ; 0356B
  jmp near cio_tabout                           ; 0356B  0xE9, 0x6F, 0x03

cio_fn02_rconin:  ; 0356E
  call cio_set_raw_mode                               ; 0356E  0xE8, 0x90, 0x02
  jmp near cio_coninf                           ; 03571  0xE9, 0xC4, 0x03

cio_fn03_rconout:  ; 03574
  call cio_set_raw_mode                               ; 03574  0xE8, 0x8A, 0x02

loc_03577:  ; 03577
  jmp near cio_conoutf                           ; 03577  0xE9, 0xFA, 0x03

cio_fn04_listout:  ; 0357A
  db 0x8B, 0x1E, 0x68, 0x00                   ; 0357A  mov bx, word [0x68]
  db 0x8A, 0x77, 0x24                         ; 0357E  mov dh, byte p_lst[bx]
  db 0x26, 0x8B, 0x36, 0x64, 0x00             ; 03581  mov si, word [es:0x64]
  db 0x52                                     ; 03586  push dx
  call cio_fn15_lstattach                      ; 03587  0xE8, 0xF5, 0xFC
  db 0x5A                                     ; 0358A  pop dx
  jmp near cio_listf                           ; 0358B  0xE9, 0xAE, 0x04

cio_fn08_constat:  ; 0358E
  call cio_clr_raw_mode                               ; 0358E  0xE8, 0x7B, 0x02
  call cio_dirio_status                               ; 03591  0xE8, 0x3B, 0x00
  db 0x84, 0xDB                               ; 03594  test bl, bl
  je loc_035AF                                 ; 03596  0x74, 0x17
  db 0x8B, 0x3E, 0x68, 0x00                   ; 03598  mov di, word [0x68]
  db 0xF7, 0x45, 0x22, 0x01, 0x00             ; 0359C  test word p_conmode[di], 1
  je loc_035AF                                 ; 035A1  0x74, 0x0C
  call cio_coninf                               ; 035A3  0xE8, 0x92, 0x03
  db 0x3C, 0x03                               ; 035A6  cmp al, 3
  jne loc_035B0                                ; 035A8  0x75, 0x06
  db 0x89, 0x5C, 0x2A                         ; 035AA  mov word [si + 0x2a], bx
  db 0xB3, 0x01                               ; 035AD  mov bl, 1

loc_035AF:  ; 035AF
  db 0xC3                                     ; 035AF  ret

loc_035B0:  ; 035B0
  db 0x32, 0xDB                               ; 035B0  xor bl, bl
  db 0xC3                                     ; 035B2  ret

cio_fn24_ciostat:  ; 035B3
  db 0x8B, 0x1E, 0x68, 0x00                   ; 035B3  mov bx, word [0x68]
  db 0x8A, 0x77, 0x20                         ; 035B7  mov dh, byte p_cns[bx]
  db 0x26, 0x8B, 0x36, 0x62, 0x00             ; 035BA  mov si, word [es:0x62]
  db 0x85, 0xF6                               ; 035BF  test si, si
  je loc_035C7                                 ; 035C1  0x74, 0x04
  db 0x3B, 0x1C                               ; 035C3  cmp bx, word [si]
  je cio_dirio_status                                 ; 035C5  0x74, 0x08

loc_035C7:  ; 035C7
  db 0xB1, 0x8E                               ; 035C7  mov cl, 0x8e
  call cio_xios_far_call                               ; 035C9  0xE8, 0xA4, 0xFC
  db 0xB3, 0x00                               ; 035CC  mov bl, 0
  db 0xC3                                     ; 035CE  ret

cio_dirio_status:  ; 035CF
  call cio_constf                               ; 035CF  0xE8, 0x47, 0x03
  db 0x84, 0xDB                               ; 035D2  test bl, bl
  je loc_035D8                                 ; 035D4  0x74, 0x02
  db 0xB3, 0x01                               ; 035D6  mov bl, 1

loc_035D8:  ; 035D8
  db 0x8A, 0xC3                               ; 035D8  mov al, bl
  db 0xC3                                     ; 035DA  ret

cio_fn05_dirio:  ; 035DB
  call cio_set_raw_mode                               ; 035DB  0xE8, 0x23, 0x02
  db 0x80, 0xFA, 0xFD                         ; 035DE  cmp dl, 0xfd
  jb loc_03577                                 ; 035E1  0x72, 0x94
  ja loc_035E8                                 ; 035E3  0x77, 0x03
  jmp near cio_coninf                           ; 035E5  0xE9, 0x50, 0x03

loc_035E8:  ; 035E8
  call cio_constf                               ; 035E8  0xE8, 0x2E, 0x03
  db 0x80, 0xFA, 0xFE                         ; 035EB  cmp dl, 0xfe
  jne loc_035F1                                ; 035EE  0x75, 0x01

loc_035F0:  ; 035F0
  db 0xC3                                     ; 035F0  ret

loc_035F1:  ; 035F1
  db 0x84, 0xDB                               ; 035F1  test bl, bl
  je loc_035F0                                 ; 035F3  0x74, 0xFB
  jmp near cio_coninf                           ; 035F5  0xE9, 0x40, 0x03

cio_fn06_conwrite:  ; 035F8
  db 0x52                                     ; 035F8  push dx
  call cio_clr_raw_mode                               ; 035F9  0xE8, 0x10, 0x02
  db 0x5B                                     ; 035FC  pop bx

loc_035FD:  ; 035FD
  db 0x1E                                     ; 035FD  push ds
  db 0x26, 0x8E, 0x1E, 0x2E, 0x00             ; 035FE  mov ds, word [es:0x2e]
  db 0x8A, 0x17                               ; 03603  mov dl, byte [bx]
  db 0x1F                                     ; 03605  pop ds
  db 0x26, 0x3A, 0x16, 0x66, 0x00             ; 03606  cmp dl, byte [es:0x66]
  je loc_03625                                 ; 0360B  0x74, 0x18
  db 0x53                                     ; 0360D  push bx
  db 0x8B, 0x1E, 0x68, 0x00                   ; 0360E  mov bx, word [0x68]
  db 0xF7, 0x47, 0x22, 0x04, 0x00             ; 03612  test word p_conmode[bx], 4
  je loc_0361E                                 ; 03617  0x74, 0x05
  call cio_conoutf                               ; 03619  0xE8, 0x58, 0x03
  jmp short loc_03621                          ; 0361C  0xEB, 0x03

loc_0361E:  ; 0361E
  call cio_tabout                               ; 0361E  0xE8, 0xBC, 0x02

loc_03621:  ; 03621
  db 0x5B                                     ; 03621  pop bx
  db 0x43                                     ; 03622  inc bx
  jmp short loc_035FD                          ; 03623  0xEB, 0xD8

loc_03625:  ; 03625
  db 0xC3                                     ; 03625  ret

cio_fn26_delim:  ; 03626
  db 0x83, 0xFA, 0xFF                         ; 03626  cmp dx, -1
  je loc_03631                                 ; 03629  0x74, 0x06
  db 0x26, 0x88, 0x16, 0x66, 0x00             ; 0362B  mov byte [es:0x66], dl
  db 0xC3                                     ; 03630  ret

loc_03631:  ; 03631
  db 0x26, 0x8A, 0x1E, 0x66, 0x00             ; 03631  mov bl, byte [es:0x66]
  db 0xC3                                     ; 03636  ret

cio_fn27_pblock:  ; 03637
  db 0x52                                     ; 03637  push dx
  call cio_clr_raw_mode                               ; 03638  0xE8, 0xD1, 0x01
  db 0x5F                                     ; 0363B  pop di
  db 0x33, 0xC0                               ; 0363C  xor ax, ax
  db 0x8B, 0x6F, 0x22                         ; 0363E  mov bp, word p_conmode[bx]
  jmp short loc_03652                          ; 03641  0xEB, 0x0F

cio_fn28_lblock:  ; 03643
  db 0x52                                     ; 03643  push dx
  call cio_fn15_lstattach                      ; 03644  0xE8, 0x38, 0xFC
  db 0x5F                                     ; 03647  pop di
  db 0x8B, 0x1E, 0x68, 0x00                   ; 03648  mov bx, word [0x68]
  db 0x8A, 0x77, 0x24                         ; 0364C  mov dh, byte p_lst[bx]
  db 0xB8, 0xFF, 0xFF                         ; 0364F  mov ax, 0xffff

loc_03652:  ; 03652
  db 0x1E                                     ; 03652  push ds
  db 0x26, 0x8E, 0x1E, 0x2E, 0x00             ; 03653  mov ds, word [es:0x2e]
  db 0x8B, 0x4D, 0x04                         ; 03658  mov cx, word [di + 4]
  db 0x8B, 0x5D, 0x02                         ; 0365B  mov bx, word [di + 2]
  db 0x8B, 0x3D                               ; 0365E  mov di, word [di]
  db 0x1F                                     ; 03660  pop ds
  db 0x85, 0xC9                               ; 03661  test cx, cx
  je loc_0368F                                 ; 03663  0x74, 0x2A

loc_03665:  ; 03665
  db 0x1E                                     ; 03665  push ds
  db 0x8E, 0xDB                               ; 03666  mov ds, bx
  db 0x8A, 0x15                               ; 03668  mov dl, byte [di]
  db 0x1F                                     ; 0366A  pop ds
  db 0x55                                     ; 0366B  push bp
  db 0x57                                     ; 0366C  push di
  db 0x51                                     ; 0366D  push cx
  db 0x53                                     ; 0366E  push bx
  db 0x50                                     ; 0366F  push ax
  db 0x85, 0xC0                               ; 03670  test ax, ax
  je loc_03679                                 ; 03672  0x74, 0x05
  call cio_listf                               ; 03674  0xE8, 0xC5, 0x03
  jmp short loc_03687                          ; 03677  0xEB, 0x0E

loc_03679:  ; 03679
  db 0xF7, 0xC5, 0x04, 0x00                   ; 03679  test bp, 4
  jne loc_03684                                ; 0367D  0x75, 0x05
  call cio_tabout                               ; 0367F  0xE8, 0x5B, 0x02
  jmp short loc_03687                          ; 03682  0xEB, 0x03

loc_03684:  ; 03684
  call cio_conoutf                               ; 03684  0xE8, 0xED, 0x02

loc_03687:  ; 03687
  db 0x58                                     ; 03687  pop ax
  db 0x5B                                     ; 03688  pop bx
  db 0x59                                     ; 03689  pop cx
  db 0x5F                                     ; 0368A  pop di
  db 0x5D                                     ; 0368B  pop bp
  db 0x47                                     ; 0368C  inc di
  loop loc_03665                               ; 0368D  0xE2, 0xD6

loc_0368F:  ; 0368F
  db 0xC3                                     ; 0368F  ret

cio_fn14_conprint:  ; 03690
  db 0x53                                     ; 03690  push bx
  db 0x52                                     ; 03691  push dx
  call cio_clr_raw_mode                               ; 03692  0xE8, 0x77, 0x01
  db 0x5B                                     ; 03695  pop bx
  db 0x58                                     ; 03696  pop ax
  db 0x33, 0xC9                               ; 03697  xor cx, cx
  db 0x24, 0x7F                               ; 03699  and al, 0x7f

loc_0369B:  ; 0369B
  db 0x80, 0xFC, 0x00                         ; 0369B  cmp ah, 0
  je loc_036A4                                 ; 0369E  0x74, 0x04
  db 0x3A, 0xE1                               ; 036A0  cmp ah, cl
  je loc_036C5                                 ; 036A2  0x74, 0x21

loc_036A4:  ; 036A4
  db 0x1E                                     ; 036A4  push ds
  db 0x26, 0x8E, 0x1E, 0x2E, 0x00             ; 036A5  mov ds, word [es:0x2e]
  db 0x8A, 0x17                               ; 036AA  mov dl, byte [bx]
  db 0x1F                                     ; 036AC  pop ds
  db 0x80, 0xE2, 0x7F                         ; 036AD  and dl, 0x7f
  db 0x3A, 0xD0                               ; 036B0  cmp dl, al
  je loc_036C5                                 ; 036B2  0x74, 0x11
  db 0x50                                     ; 036B4  push ax
  db 0x51                                     ; 036B5  push cx
  db 0x53                                     ; 036B6  push bx
  call cio_conoutf                               ; 036B7  0xE8, 0xBA, 0x02
  call cio_chk_cmode                               ; 036BA  0xE8, 0xE7, 0x01
  db 0x5B                                     ; 036BD  pop bx
  db 0x59                                     ; 036BE  pop cx
  db 0x58                                     ; 036BF  pop ax
  db 0xFE, 0xC1                               ; 036C0  inc cl
  db 0x43                                     ; 036C2  inc bx
  jmp short loc_0369B                          ; 036C3  0xEB, 0xD6

loc_036C5:  ; 036C5
  db 0xC3                                     ; 036C5  ret

cio_fn07_conread:  ; 036C6
  db 0x52                                     ; 036C6  push dx
  call cio_clr_raw_mode                               ; 036C7  0xE8, 0x42, 0x01
  db 0x5B                                     ; 036CA  pop bx

loc_036CB:  ; 036CB
  db 0x53                                     ; 036CB  push bx
  db 0x8A, 0x44, 0x06                         ; 036CC  mov al, byte [si + 6]
  db 0x88, 0x44, 0x05                         ; 036CF  mov byte [si + 5], al
  db 0x33, 0xDB                               ; 036D2  xor bx, bx

loc_036D4:  ; 036D4
  db 0x53                                     ; 036D4  push bx

loc_036D5:  ; 036D5
  call cio_coninf                               ; 036D5  0xE8, 0x60, 0x02
  db 0x8A, 0xD0                               ; 036D8  mov dl, al
  db 0x5B                                     ; 036DA  pop bx
  db 0x80, 0xFA, 0x0D                         ; 036DB  cmp dl, 0xd
  jne loc_036E3                                ; 036DE  0x75, 0x03

loc_036E0:  ; 036E0
  jmp near loc_037EC                           ; 036E0  0xE9, 0x09, 0x01

loc_036E3:  ; 036E3
  db 0x80, 0xFA, 0x0A                         ; 036E3  cmp dl, 0xa
  je loc_036E0                                 ; 036E6  0x74, 0xF8
  db 0x80, 0xFA, 0x08                         ; 036E8  cmp dl, 8
  jne loc_03700                                ; 036EB  0x75, 0x13
  db 0x0A, 0xDB                               ; 036ED  or bl, bl
  je loc_036D4                                 ; 036EF  0x74, 0xE3
  db 0xFE, 0xCB                               ; 036F1  dec bl
  db 0x8A, 0x44, 0x06                         ; 036F3  mov al, byte [si + 6]
  db 0x88, 0x44, 0x0C                         ; 036F6  mov byte [si + 0xc], al
  db 0x80, 0x4C, 0x04, 0x02                   ; 036F9  or byte [si + 4], 2
  jmp near loc_0376D                           ; 036FD  0xE9, 0x6D, 0x00

loc_03700:  ; 03700
  db 0x80, 0xFA, 0x7F                         ; 03700  cmp dl, 0x7f
  jne loc_0371C                                ; 03703  0x75, 0x17
  db 0x0A, 0xDB                               ; 03705  or bl, bl
  je loc_03719                                 ; 03707  0x74, 0x10
  db 0x5F                                     ; 03709  pop di
  db 0x57                                     ; 0370A  push di
  db 0x1E                                     ; 0370B  push ds
  db 0x26, 0x8E, 0x1E, 0x2E, 0x00             ; 0370C  mov ds, word [es:0x2e]
  db 0x8A, 0x51, 0x01                         ; 03711  mov dl, byte [bx + di + 1]
  db 0x1F                                     ; 03714  pop ds
  db 0x4B                                     ; 03715  dec bx
  jmp near loc_037D7                           ; 03716  0xE9, 0xBE, 0x00

loc_03719:  ; 03719
  jmp near loc_036D4                           ; 03719  0xE9, 0xB8, 0xFF

loc_0371C:  ; 0371C
  db 0x80, 0xFA, 0x05                         ; 0371C  cmp dl, 5
  jne loc_03737                                ; 0371F  0x75, 0x16
  db 0x53                                     ; 03721  push bx
  db 0xB2, 0x0D                               ; 03722  mov dl, 0xd
  call cio_conoutf                               ; 03724  0xE8, 0x4D, 0x02
  db 0xB2, 0x0A                               ; 03727  mov dl, 0xa
  call cio_conoutf                               ; 03729  0xE8, 0x48, 0x02
  db 0xC6, 0x44, 0x06, 0x00                   ; 0372C  mov byte [si + 6], 0
  db 0xC6, 0x44, 0x05, 0x00                   ; 03730  mov byte [si + 5], 0
  jmp near loc_036D5                           ; 03734  0xE9, 0x9E, 0xFF

loc_03737:  ; 03737
  db 0x80, 0xFA, 0x18                         ; 03737  cmp dl, 0x18
  jne loc_0375C                                ; 0373A  0x75, 0x20

loc_0373C:  ; 0373C
  db 0x8A, 0x44, 0x05                         ; 0373C  mov al, byte [si + 5]
  db 0x3A, 0x44, 0x06                         ; 0373F  cmp al, byte [si + 6]
  jb loc_03748                                 ; 03742  0x72, 0x04
  db 0x33, 0xDB                               ; 03744  xor bx, bx
  jmp short loc_03719                          ; 03746  0xEB, 0xD1

loc_03748:  ; 03748
  db 0xB2, 0x08                               ; 03748  mov dl, 8
  call cio_conoutf                               ; 0374A  0xE8, 0x27, 0x02
  db 0xB2, 0x20                               ; 0374D  mov dl, 0x20
  call cio_conoutf                               ; 0374F  0xE8, 0x22, 0x02
  db 0xB2, 0x08                               ; 03752  mov dl, 8
  call cio_conoutf                               ; 03754  0xE8, 0x1D, 0x02
  db 0xFE, 0x4C, 0x06                         ; 03757  dec byte [si + 6]
  jmp short loc_0373C                          ; 0375A  0xEB, 0xE0

loc_0375C:  ; 0375C
  db 0x80, 0xFA, 0x15                         ; 0375C  cmp dl, 0x15
  jne loc_03768                                ; 0375F  0x75, 0x07
  call cio_prcsmsg                               ; 03761  0xE8, 0x9D, 0x01
  db 0x5B                                     ; 03764  pop bx
  jmp near loc_036CB                           ; 03765  0xE9, 0x63, 0xFF

loc_03768:  ; 03768
  db 0x80, 0xFA, 0x12                         ; 03768  cmp dl, 0x12
  jne loc_037CA                                ; 0376B  0x75, 0x5D

loc_0376D:  ; 0376D
  db 0x53                                     ; 0376D  push bx
  call cio_prcsmsg                               ; 0376E  0xE8, 0x90, 0x01
  db 0x59                                     ; 03771  pop cx
  db 0x33, 0xDB                               ; 03772  xor bx, bx

loc_03774:  ; 03774
  db 0x0A, 0xC9                               ; 03774  or cl, cl
  je loc_03794                                 ; 03776  0x74, 0x1C
  db 0x5F                                     ; 03778  pop di
  db 0x57                                     ; 03779  push di
  db 0x1E                                     ; 0377A  push ds
  db 0x26, 0x8E, 0x1E, 0x2E, 0x00             ; 0377B  mov ds, word [es:0x2e]
  db 0x43                                     ; 03780  inc bx
  db 0xFE, 0xC9                               ; 03781  dec cl
  db 0x8A, 0x51, 0x01                         ; 03783  mov dl, byte [bx + di + 1]
  db 0x1F                                     ; 03786  pop ds
  db 0x8A, 0xEB                               ; 03787  mov ch, bl
  db 0x51                                     ; 03789  push cx
  call cio_ctlout                               ; 0378A  0xE8, 0x41, 0x01
  db 0x59                                     ; 0378D  pop cx
  db 0xB7, 0x00                               ; 0378E  mov bh, 0
  db 0x8A, 0xDD                               ; 03790  mov bl, ch
  jmp short loc_03774                          ; 03792  0xEB, 0xE0

loc_03794:  ; 03794
  db 0xF6, 0x44, 0x04, 0x02                   ; 03794  test byte [si + 4], 2
  db 0x53                                     ; 03798  push bx
  je loc_037C7                                 ; 03799  0x74, 0x2C
  db 0x80, 0x64, 0x04, 0xFD                   ; 0379B  and byte [si + 4], 0xfd
  db 0x8A, 0x64, 0x0C                         ; 0379F  mov ah, byte [si + 0xc]
  db 0x8A, 0xC4                               ; 037A2  mov al, ah

loc_037A4:  ; 037A4
  db 0x3A, 0x44, 0x06                         ; 037A4  cmp al, byte [si + 6]
  jb loc_037C7                                 ; 037A7  0x72, 0x1E
  db 0x2A, 0x44, 0x06                         ; 037A9  sub al, byte [si + 6]
  db 0x0A, 0xC0                               ; 037AC  or al, al
  je loc_037C7                                 ; 037AE  0x74, 0x17
  db 0x50                                     ; 037B0  push ax
  db 0xB2, 0x08                               ; 037B1  mov dl, 8
  call cio_conoutf                               ; 037B3  0xE8, 0xBE, 0x01
  db 0xB2, 0x20                               ; 037B6  mov dl, 0x20
  call cio_conoutf                               ; 037B8  0xE8, 0xB9, 0x01
  db 0xB2, 0x08                               ; 037BB  mov dl, 8
  call cio_conoutf                               ; 037BD  0xE8, 0xB4, 0x01
  db 0x58                                     ; 037C0  pop ax
  db 0xFE, 0xCC                               ; 037C1  dec ah
  db 0x8A, 0xC4                               ; 037C3  mov al, ah
  jmp short loc_037A4                          ; 037C5  0xEB, 0xDD

loc_037C7:  ; 037C7
  jmp near loc_036D5                           ; 037C7  0xE9, 0x0B, 0xFF

loc_037CA:  ; 037CA
  db 0x43                                     ; 037CA  inc bx
  db 0x5F                                     ; 037CB  pop di
  db 0x57                                     ; 037CC  push di
  db 0x1E                                     ; 037CD  push ds
  db 0x26, 0x8E, 0x1E, 0x2E, 0x00             ; 037CE  mov ds, word [es:0x2e]
  db 0x88, 0x51, 0x01                         ; 037D3  mov byte [bx + di + 1], dl
  db 0x1F                                     ; 037D6  pop ds

loc_037D7:  ; 037D7
  db 0x53                                     ; 037D7  push bx
  call cio_ctlout                               ; 037D8  0xE8, 0xF3, 0x00
  db 0x5B                                     ; 037DB  pop bx
  db 0x5F                                     ; 037DC  pop di
  db 0x57                                     ; 037DD  push di
  db 0x1E                                     ; 037DE  push ds
  db 0x26, 0x8E, 0x1E, 0x2E, 0x00             ; 037DF  mov ds, word [es:0x2e]
  db 0x3A, 0x1D                               ; 037E4  cmp bl, byte [di]
  db 0x1F                                     ; 037E6  pop ds
  jae loc_037EC                                ; 037E7  0x73, 0x03
  db 0x53                                     ; 037E9  push bx
  jmp short loc_037C7                          ; 037EA  0xEB, 0xDB

loc_037EC:  ; 037EC
  db 0x5F                                     ; 037EC  pop di
  db 0x1E                                     ; 037ED  push ds
  db 0x26, 0x8E, 0x1E, 0x2E, 0x00             ; 037EE  mov ds, word [es:0x2e]
  db 0x88, 0x5D, 0x01                         ; 037F3  mov byte [di + 1], bl
  db 0x1F                                     ; 037F6  pop ds
  db 0xB2, 0x0D                               ; 037F7  mov dl, 0xd
  call cio_conoutf                               ; 037F9  0xE8, 0x78, 0x01
  db 0xC6, 0x44, 0x06, 0x00                   ; 037FC  mov byte [si + 6], 0
  db 0xC3                                     ; 03800  ret

cio_set_raw_mode:  ; 03801
  db 0x8B, 0x1E, 0x68, 0x00                   ; 03801  mov bx, word [0x68]
  db 0x81, 0x4F, 0x06, 0x40, 0x00             ; 03805  or word [bx + 6], 0x40
  jmp short loc_03815                          ; 0380A  0xEB, 0x09

cio_clr_raw_mode:  ; 0380C
  db 0x8B, 0x1E, 0x68, 0x00                   ; 0380C  mov bx, word [0x68]
  db 0x81, 0x67, 0x06, 0xBF, 0xFF             ; 03810  and word [bx + 6], 0xffbf

loc_03815:  ; 03815
  db 0x8A, 0x77, 0x20                         ; 03815  mov dh, byte p_cns[bx]
  db 0x26, 0x8B, 0x36, 0x62, 0x00             ; 03818  mov si, word [es:0x62]
  db 0x85, 0xF6                               ; 0381D  test si, si
  je loc_03826                                 ; 0381F  0x74, 0x05
  db 0x39, 0x1C                               ; 03821  cmp word [si], bx
  jne loc_03826                                ; 03823  0x75, 0x01
  db 0xC3                                     ; 03825  ret

loc_03826:  ; 03826
  db 0x53                                     ; 03826  push bx
  db 0x52                                     ; 03827  push dx
  call cio_fn09_conattach                      ; 03828  0xE8, 0x70, 0xFA
  db 0x5A                                     ; 0382B  pop dx
  db 0x5B                                     ; 0382C  pop bx
  db 0xC3                                     ; 0382D  ret

cio_chk_ctrlp:  ; 0382E
  db 0x80, 0xFA, 0x0D                         ; 0382E  cmp dl, 0xd
  je loc_03845                                 ; 03831  0x74, 0x12
  db 0x80, 0xFA, 0x0A                         ; 03833  cmp dl, 0xa
  je loc_03845                                 ; 03836  0x74, 0x0D
  db 0x80, 0xFA, 0x09                         ; 03838  cmp dl, 9
  je loc_03845                                 ; 0383B  0x74, 0x08
  db 0x80, 0xFA, 0x08                         ; 0383D  cmp dl, 8
  je loc_03845                                 ; 03840  0x74, 0x03
  db 0x80, 0xFA, 0x20                         ; 03842  cmp dl, 0x20

loc_03845:  ; 03845
  db 0xC3                                     ; 03845  ret
  db 0x33, 0xDB                               ; 03846  xor bx, bx
  db 0x8C, 0xC8                               ; 03848  mov ax, cs

loc_0384A:  ; 0384A
  db 0x26, 0xFF, 0x36, 0x2E, 0x00             ; 0384A  push word [es:0x2e]
  db 0x26, 0xA3, 0x2E, 0x00                   ; 0384F  mov word [es:0x2e], ax
  call cio_fn14_conprint                       ; 03853  0xE8, 0x3A, 0xFE
  db 0x26, 0x8F, 0x06, 0x2E, 0x00             ; 03856  pop word [es:0x2e]
  db 0xC3                                     ; 0385B  ret
  db 0xB7, 0x08                               ; 0385C  mov bh, 8
  db 0xB3, 0x20                               ; 0385E  mov bl, 0x20
  db 0x8C, 0xD8                               ; 03860  mov ax, ds
  jmp short loc_0384A                          ; 03862  0xEB, 0xE6

cio_conout:  ; 03864
  db 0xF6, 0x44, 0x04, 0x02                   ; 03864  test byte [si + 4], 2
  jne loc_0387B                                ; 03868  0x75, 0x11
  call cio_conoutf                               ; 0386A  0xE8, 0x07, 0x01
  db 0x8B, 0x1E, 0x68, 0x00                   ; 0386D  mov bx, word [0x68]
  db 0xF7, 0x47, 0x22, 0x04, 0x00             ; 03871  test word p_conmode[bx], 4
  jne loc_0387B                                ; 03876  0x75, 0x03
  call cio_chk_cmode                               ; 03878  0xE8, 0x29, 0x00

loc_0387B:  ; 0387B
  db 0x8A, 0x44, 0x06                         ; 0387B  mov al, byte [si + 6]
  db 0x80, 0xFA, 0x7F                         ; 0387E  cmp dl, 0x7f
  je loc_038A0                                 ; 03881  0x74, 0x1D
  db 0xFE, 0xC0                               ; 03883  inc al
  db 0x80, 0xFA, 0x20                         ; 03885  cmp dl, 0x20
  jae loc_038A0                                ; 03888  0x73, 0x16
  db 0xFE, 0xC8                               ; 0388A  dec al
  db 0x0A, 0xC0                               ; 0388C  or al, al
  je loc_038A0                                 ; 0388E  0x74, 0x10
  db 0x80, 0xFA, 0x08                         ; 03890  cmp dl, 8
  jne loc_03899                                ; 03893  0x75, 0x04
  db 0xFE, 0xC8                               ; 03895  dec al
  jmp short loc_038A0                          ; 03897  0xEB, 0x07

loc_03899:  ; 03899
  db 0x80, 0xFA, 0x0D                         ; 03899  cmp dl, 0xd
  jne loc_038A0                                ; 0389C  0x75, 0x02
  db 0xB0, 0x00                               ; 0389E  mov al, 0

loc_038A0:  ; 038A0
  db 0x88, 0x44, 0x06                         ; 038A0  mov byte [si + 6], al
  db 0xC3                                     ; 038A3  ret

cio_chk_cmode:  ; 038A4
  db 0x8B, 0x44, 0x0E                         ; 038A4  mov ax, word [si + 0xe]
  db 0xA9, 0x00, 0x02                         ; 038A7  test ax, 0x200
  je loc_038CD                                 ; 038AA  0x74, 0x21
  db 0xA9, 0x00, 0x01                         ; 038AC  test ax, 0x100
  jne loc_038CD                                ; 038AF  0x75, 0x1C
  db 0x8A, 0x44, 0x04                         ; 038B1  mov al, byte [si + 4]
  db 0xA8, 0x20                               ; 038B4  test al, 0x20
  je loc_038BE                                 ; 038B6  0x74, 0x06
  db 0x80, 0x64, 0x04, 0xDF                   ; 038B8  and byte [si + 4], 0xdf
  jmp short loc_038CD                          ; 038BC  0xEB, 0x0F

loc_038BE:  ; 038BE
  db 0x52                                     ; 038BE  push dx
  db 0x56                                     ; 038BF  push si
  db 0x8A, 0x74, 0x08                         ; 038C0  mov dh, byte [si + 8]
  db 0x80, 0xFE, 0xFF                         ; 038C3  cmp dh, 0xff
  je loc_038CB                                 ; 038C6  0x74, 0x03
  call cio_listf                               ; 038C8  0xE8, 0x71, 0x01

loc_038CB:  ; 038CB
  db 0x5E                                     ; 038CB  pop si
  db 0x5A                                     ; 038CC  pop dx

loc_038CD:  ; 038CD
  db 0xC3                                     ; 038CD  ret

cio_ctlout:  ; 038CE
  call cio_chk_ctrlp                               ; 038CE  0xE8, 0x5D, 0xFF
  jae cio_tabout                                ; 038D1  0x73, 0x0A
  db 0x52                                     ; 038D3  push dx
  db 0xB2, 0x5E                               ; 038D4  mov dl, 0x5e
  call cio_conout                               ; 038D6  0xE8, 0x8B, 0xFF
  db 0x5A                                     ; 038D9  pop dx
  db 0x80, 0xCA, 0x40                         ; 038DA  or dl, 0x40

cio_tabout:  ; 038DD
  db 0x80, 0xFA, 0x09                         ; 038DD  cmp dl, 9
  je loc_038E5                                 ; 038E0  0x74, 0x03
  jmp near cio_conout                           ; 038E2  0xE9, 0x7F, 0xFF

loc_038E5:  ; 038E5
  db 0xB2, 0x20                               ; 038E5  mov dl, 0x20

loc_038E7:  ; 038E7
  call cio_conout                               ; 038E7  0xE8, 0x7A, 0xFF
  db 0x8A, 0x44, 0x06                         ; 038EA  mov al, byte [si + 6]
  db 0x24, 0x07                               ; 038ED  and al, 7
  jne loc_038E7                                ; 038EF  0x75, 0xF6
  db 0xB2, 0x09                               ; 038F1  mov dl, 9
  db 0xC3                                     ; 038F3  ret

cio_crlf:  ; 038F4
  db 0x52                                     ; 038F4  push dx
  db 0xB2, 0x0D                               ; 038F5  mov dl, 0xd
  call cio_conout                               ; 038F7  0xE8, 0x6A, 0xFF
  db 0xB2, 0x0A                               ; 038FA  mov dl, 0xa
  call cio_conout                               ; 038FC  0xE8, 0x65, 0xFF
  db 0x5A                                     ; 038FF  pop dx
  db 0xC3                                     ; 03900  ret

cio_prcsmsg:  ; 03901
  db 0xB2, 0x23                               ; 03901  mov dl, 0x23
  call cio_conout                               ; 03903  0xE8, 0x5E, 0xFF
  call cio_crlf                               ; 03906  0xE8, 0xEB, 0xFF
  db 0xB2, 0x20                               ; 03909  mov dl, 0x20

loc_0390B:  ; 0390B
  db 0x8A, 0x44, 0x06                         ; 0390B  mov al, byte [si + 6]
  db 0x3A, 0x44, 0x05                         ; 0390E  cmp al, byte [si + 5]
  jae loc_03918                                ; 03911  0x73, 0x05
  call cio_conout                               ; 03913  0xE8, 0x4E, 0xFF
  jmp short loc_0390B                          ; 03916  0xEB, 0xF3

loc_03918:  ; 03918
  db 0xC3                                     ; 03918  ret

cio_constf:  ; 03919
  db 0x3A, 0x36, 0x47, 0x00                   ; 03919  cmp dh, byte [0x47]
  jb loc_03924                                 ; 0391D  0x72, 0x05
  db 0xB0, 0x00                               ; 0391F  mov al, 0
  jmp near cio_goxios                           ; 03921  0xE9, 0x1B, 0x01

loc_03924:  ; 03924
  db 0x33, 0xDB                               ; 03924  xor bx, bx
  db 0x39, 0x5C, 0x2A                         ; 03926  cmp word [si + 0x2a], bx
  jne loc_03933                                ; 03929  0x75, 0x08
  db 0x8B, 0x7C, 0x12                         ; 0392B  mov di, word p_dsk[si]
  db 0x39, 0x5D, 0x16                         ; 0392E  cmp word p_mem[di], bx
  je loc_03935                                 ; 03931  0x74, 0x02

loc_03933:  ; 03933
  db 0xB3, 0xFF                               ; 03933  mov bl, 0xff

loc_03935:  ; 03935
  db 0x8A, 0xC3                               ; 03935  mov al, bl
  db 0xC3                                     ; 03937  ret

cio_coninf:  ; 03938
  db 0x3A, 0x36, 0x47, 0x00                   ; 03938  cmp dh, byte [0x47]
  jb loc_03946                                 ; 0393C  0x72, 0x08
  db 0x8A, 0x54, 0x0A                         ; 0393E  mov dl, byte [si + 0xa]
  db 0xB0, 0x01                               ; 03941  mov al, 1
  jmp near cio_goxios                           ; 03943  0xE9, 0xF9, 0x00

loc_03946:  ; 03946
  db 0x83, 0x7C, 0x2A, 0x00                   ; 03946  cmp word [si + 0x2a], 0
  jne loc_03952                                ; 0394A  0x75, 0x06
  db 0xB9, 0x89, 0x00                         ; 0394C  mov cx, 0x89
  call cio_conout_sleep                               ; 0394F  0xE8, 0x0B, 0x00

loc_03952:  ; 03952
  db 0x8B, 0x5C, 0x2A                         ; 03952  mov bx, word [si + 0x2a]
  db 0x8B, 0xC3                               ; 03955  mov ax, bx
  db 0xC7, 0x44, 0x2A, 0x00, 0x00             ; 03957  mov word [si + 0x2a], 0
  db 0xC3                                     ; 0395C  ret

cio_conout_sleep:  ; 0395D
  db 0x52                                     ; 0395D  push dx
  db 0x56                                     ; 0395E  push si
  db 0x8B, 0x44, 0x12                         ; 0395F  mov ax, word p_dsk[si]
  db 0x89, 0x44, 0x1A                         ; 03962  mov word p_wait[si], ax
  db 0x8D, 0x44, 0x2A                         ; 03965  lea ax, [si + 0x2a]
  db 0x89, 0x44, 0x1E                         ; 03968  mov word p_parent[si], ax
  db 0x8D, 0x54, 0x18                         ; 0396B  lea dx, p_cmod[si]
  call cio_xios_far_call                               ; 0396E  0xE8, 0xFF, 0xF8
  db 0x5E                                     ; 03971  pop si
  db 0x5A                                     ; 03972  pop dx
  db 0xC3                                     ; 03973  ret

cio_conoutf:  ; 03974
  db 0x3A, 0x36, 0x47, 0x00                   ; 03974  cmp dh, byte [0x47]
  jb loc_0397F                                 ; 03978  0x72, 0x05
  db 0xB0, 0x02                               ; 0397A  mov al, 2
  jmp near cio_goxios                           ; 0397C  0xE9, 0xC0, 0x00

loc_0397F:  ; 0397F
  db 0x9C                                     ; 0397F  pushf
  db 0xFA                                     ; 03980  cli
  db 0x8B, 0x44, 0x0E                         ; 03981  mov ax, word [si + 0xe]
  db 0x8B, 0xD8                               ; 03984  mov bx, ax
  db 0x25, 0xE7, 0xFC                         ; 03986  and ax, 0xfce7
  db 0x3D, 0x02, 0x00                         ; 03989  cmp ax, 2
  jbe loc_039CD                                ; 0398C  0x76, 0x3F
  db 0x3D, 0x03, 0x00                         ; 0398E  cmp ax, 3
  je loc_039A5                                 ; 03991  0x74, 0x12
  db 0x52                                     ; 03993  push dx
  db 0x56                                     ; 03994  push si
  db 0x8D, 0x54, 0x24                         ; 03995  lea dx, p_lst[si]
  db 0xB3, 0x09                               ; 03998  mov bl, 9
  db 0xB9, 0x12, 0x02                         ; 0399A  mov cx, 0x212
  call cio_xios_far_call                               ; 0399D  0xE8, 0xD0, 0xF8
  db 0x5E                                     ; 039A0  pop si
  db 0x5A                                     ; 039A1  pop dx
  db 0x9D                                     ; 039A2  popf
  jmp short loc_0397F                          ; 039A3  0xEB, 0xDA

loc_039A5:  ; 039A5
  db 0x9D                                     ; 039A5  popf
  db 0x80, 0x4C, 0x04, 0x30                   ; 039A6  or byte [si + 4], 0x30
  db 0x8B, 0x44, 0x14                         ; 039AA  mov ax, word p_ldsk[si]
  db 0x89, 0x44, 0x1A                         ; 039AD  mov word p_wait[si], ax
  db 0x8D, 0x44, 0x20                         ; 039B0  lea ax, p_cns[si]
  db 0x89, 0x44, 0x1E                         ; 039B3  mov word p_parent[si], ax
  db 0x52                                     ; 039B6  push dx
  db 0x56                                     ; 039B7  push si
  db 0x32, 0xF6                               ; 039B8  xor dh, dh
  db 0x89, 0x54, 0x20                         ; 039BA  mov word p_cns[si], dx
  db 0x8D, 0x54, 0x18                         ; 039BD  lea dx, p_cmod[si]
  db 0xB9, 0x8B, 0x00                         ; 039C0  mov cx, 0x8b
  call cio_xios_far_call                               ; 039C3  0xE8, 0xAA, 0xF8
  db 0x5E                                     ; 039C6  pop si
  db 0x5A                                     ; 039C7  pop dx
  db 0x80, 0x64, 0x04, 0xEF                   ; 039C8  and byte [si + 4], 0xef
  db 0xC3                                     ; 039CC  ret

loc_039CD:  ; 039CD
  db 0xF7, 0xC3, 0x00, 0x01                   ; 039CD  test bx, 0x100
  je loc_039D5                                 ; 039D1  0x74, 0x02
  db 0x9D                                     ; 039D3  popf
  db 0xC3                                     ; 039D4  ret

loc_039D5:  ; 039D5
  db 0xF6, 0x44, 0x04, 0x08                   ; 039D5  test byte [si + 4], 8
  je loc_039EE                                 ; 039D9  0x74, 0x13
  db 0x52                                     ; 039DB  push dx
  db 0x56                                     ; 039DC  push si
  db 0x8D, 0x54, 0x22                         ; 039DD  lea dx, p_conmode[si]
  db 0xB3, 0x09                               ; 039E0  mov bl, 9
  db 0xB9, 0x12, 0x02                         ; 039E2  mov cx, 0x212
  call cio_xios_far_call                               ; 039E5  0xE8, 0x88, 0xF8
  db 0x5E                                     ; 039E8  pop si
  db 0x5A                                     ; 039E9  pop dx
  db 0x9D                                     ; 039EA  popf
  jmp near loc_0397F                           ; 039EB  0xE9, 0x91, 0xFF

loc_039EE:  ; 039EE
  db 0x80, 0x4C, 0x04, 0x08                   ; 039EE  or byte [si + 4], 8
  db 0x9D                                     ; 039F2  popf
  db 0x8B, 0x1E, 0x68, 0x00                   ; 039F3  mov bx, word [0x68]
  db 0xFF, 0x77, 0x06                         ; 039F7  push word [bx + 6]
  db 0x81, 0x4F, 0x06, 0x00, 0x02             ; 039FA  or word [bx + 6], 0x200
  db 0x53                                     ; 039FF  push bx
  db 0xB8, 0x02, 0x00                         ; 03A00  mov ax, 2
  call cio_goxios                               ; 03A03  0xE8, 0x39, 0x00
  db 0x80, 0x64, 0x04, 0xF7                   ; 03A06  and byte [si + 4], 0xf7
  db 0x83, 0x7C, 0x22, 0x00                   ; 03A0A  cmp word p_conmode[si], 0
  je loc_03A1F                                 ; 03A0E  0x74, 0x0F
  db 0x52                                     ; 03A10  push dx
  db 0x56                                     ; 03A11  push si
  db 0xB9, 0x13, 0x02                         ; 03A12  mov cx, 0x213
  db 0xB3, 0x09                               ; 03A15  mov bl, 9
  db 0x8D, 0x54, 0x22                         ; 03A17  lea dx, p_conmode[si]
  call cio_xios_far_call                               ; 03A1A  0xE8, 0x53, 0xF8
  db 0x5E                                     ; 03A1D  pop si
  db 0x5A                                     ; 03A1E  pop dx

loc_03A1F:  ; 03A1F
  db 0x5B                                     ; 03A1F  pop bx
  db 0xF7, 0x47, 0x06, 0x80, 0x00             ; 03A20  test word [bx + 6], 0x80
  db 0x8F, 0x47, 0x06                         ; 03A25  pop word [bx + 6]
  je loc_03A3B                                 ; 03A28  0x74, 0x11
  db 0x81, 0x4F, 0x06, 0x80, 0x00             ; 03A2A  or word [bx + 6], 0x80
  db 0x52                                     ; 03A2F  push dx
  db 0x56                                     ; 03A30  push si
  db 0x33, 0xD2                               ; 03A31  xor dx, dx
  db 0xB9, 0x8F, 0x00                         ; 03A33  mov cx, 0x8f
  call cio_xios_far_call                               ; 03A36  0xE8, 0x37, 0xF8
  db 0x5E                                     ; 03A39  pop si
  db 0x5A                                     ; 03A3A  pop dx

loc_03A3B:  ; 03A3B
  db 0xC3                                     ; 03A3B  ret

cio_listf:  ; 03A3C
  db 0xB8, 0x04, 0x00                         ; 03A3C  mov ax, 4

cio_goxios:  ; 03A3F
  db 0x52                                     ; 03A3F  push dx
  db 0x56                                     ; 03A40  push si
  db 0x8A, 0xCA                               ; 03A41  mov cl, dl
  db 0x8A, 0xD6                               ; 03A43  mov dl, dh
  call cio_xios_call                               ; 03A45  0xE8, 0x2E, 0xF8
  db 0x5E                                     ; 03A48  pop si
  db 0x5A                                     ; 03A49  pop dx
  db 0xC3                                     ; 03A4A  ret
  db 0x90                                     ; 03A4B  nop
  db 0x90                                     ; 03A4C  nop
  db 0x90                                     ; 03A4D  nop
  db 0x90                                     ; 03A4E  nop
  db 0x90                                     ; 03A4F  nop
  db 0x90                                     ; 03A50  nop
  db 0x90                                     ; 03A51  nop
  db 0x90                                     ; 03A52  nop
  db 0x90                                     ; 03A53  nop
  db 0x90                                     ; 03A54  nop
  db 0x90                                     ; 03A55  nop
  db 0x90                                     ; 03A56  nop
  db 0x90                                     ; 03A57  nop
  db 0x90                                     ; 03A58  nop
  db 0x90                                     ; 03A59  nop
  db 0x90                                     ; 03A5A  nop
  db 0x90                                     ; 03A5B  nop
  db 0x90                                     ; 03A5C  nop
  db 0x90                                     ; 03A5D  nop
  db 0x90                                     ; 03A5E  nop
  db 0x90                                     ; 03A5F  nop
  db 0x90                                     ; 03A60  nop
  db 0x90                                     ; 03A61  nop
  db 0x90                                     ; 03A62  nop
  db 0x90                                     ; 03A63  nop
  db 0x90                                     ; 03A64  nop
  db 0x90                                     ; 03A65  nop
  db 0x90                                     ; 03A66  nop
  db 0x90                                     ; 03A67  nop
  db 0x90                                     ; 03A68  nop
  db 0x90                                     ; 03A69  nop
  db 0x90                                     ; 03A6A  nop
  db 0x90                                     ; 03A6B  nop
  db 0x90                                     ; 03A6C  nop
  db 0x90                                     ; 03A6D  nop
  db 0x90                                     ; 03A6E  nop
  db 0x90                                     ; 03A6F  nop
  db 0x90                                     ; 03A70  nop
  db 0x90                                     ; 03A71  nop
  db 0x90                                     ; 03A72  nop
  db 0x90                                     ; 03A73  nop
  db 0x90                                     ; 03A74  nop
  db 0x90                                     ; 03A75  nop
  db 0x90                                     ; 03A76  nop
  db 0x90                                     ; 03A77  nop
  db 0x90                                     ; 03A78  nop
  db 0x90                                     ; 03A79  nop
  db 0x90                                     ; 03A7A  nop
  db 0x90                                     ; 03A7B  nop
  db 0x90                                     ; 03A7C  nop
  db 0x90                                     ; 03A7D  nop
  db 0x90                                     ; 03A7E  nop
  db 0x90                                     ; 03A7F  nop
  db 0x90                                     ; 03A80  nop
  db 0x90                                     ; 03A81  nop
  db 0x90                                     ; 03A82  nop
  db 0x90                                     ; 03A83  nop
  db 0x90                                     ; 03A84  nop
  db 0x90                                     ; 03A85  nop
  db 0x90                                     ; 03A86  nop
  db 0x90                                     ; 03A87  nop
  db 0x90                                     ; 03A88  nop
  db 0x90                                     ; 03A89  nop
  db 0x90                                     ; 03A8A  nop
  db 0x90                                     ; 03A8B  nop
  db 0x90                                     ; 03A8C  nop
  db 0x90                                     ; 03A8D  nop
  db 0x90                                     ; 03A8E  nop
  db 0x90                                     ; 03A8F  nop
  db 0x90                                     ; 03A90  nop
  db 0x90                                     ; 03A91  nop
  db 0x90                                     ; 03A92  nop
  db 0x90                                     ; 03A93  nop
  db 0x90                                     ; 03A94  nop
  db 0x90                                     ; 03A95  nop
  db 0x90                                     ; 03A96  nop
  db 0x90                                     ; 03A97  nop
  db 0x90                                     ; 03A98  nop
  db 0x90                                     ; 03A99  nop
  db 0x90                                     ; 03A9A  nop
  db 0x90                                     ; 03A9B  nop
  db 0x90                                     ; 03A9C  nop
  db 0x90                                     ; 03A9D  nop
  db 0x90                                     ; 03A9E  nop
  db 0x90                                     ; 03A9F  nop
  db 0x90                                     ; 03AA0  nop
  db 0x90                                     ; 03AA1  nop
  db 0x90                                     ; 03AA2  nop
  db 0x90                                     ; 03AA3  nop
  db 0x90                                     ; 03AA4  nop
  db 0x90                                     ; 03AA5  nop
  db 0x90                                     ; 03AA6  nop
  db 0x90                                     ; 03AA7  nop
  db 0x90                                     ; 03AA8  nop
  db 0x90                                     ; 03AA9  nop
  db 0x90                                     ; 03AAA  nop
  db 0x90                                     ; 03AAB  nop
  db 0x90                                     ; 03AAC  nop
  db 0x90                                     ; 03AAD  nop
  db 0x90                                     ; 03AAE  nop
  db 0x90                                     ; 03AAF  nop
  db 0x90                                     ; 03AB0  nop
  db 0x90                                     ; 03AB1  nop
  db 0x90                                     ; 03AB2  nop
  db 0x90                                     ; 03AB3  nop
  db 0x90                                     ; 03AB4  nop
  db 0x90                                     ; 03AB5  nop
  db 0x90                                     ; 03AB6  nop
  db 0x90                                     ; 03AB7  nop
  db 0x90                                     ; 03AB8  nop
  db 0x90                                     ; 03AB9  nop
  db 0x90                                     ; 03ABA  nop
  db 0x90                                     ; 03ABB  nop
  db 0x90                                     ; 03ABC  nop
  db 0x90                                     ; 03ABD  nop
  db 0x90                                     ; 03ABE  nop
  db 0x90                                     ; 03ABF  nop
  db 0x90                                     ; 03AC0  nop
  db 0x90                                     ; 03AC1  nop
  db 0x90                                     ; 03AC2  nop
  db 0x90                                     ; 03AC3  nop
  db 0x90                                     ; 03AC4  nop
  db 0x90                                     ; 03AC5  nop
  db 0x90                                     ; 03AC6  nop
  db 0x90                                     ; 03AC7  nop
  db 0x90                                     ; 03AC8  nop
  db 0x90                                     ; 03AC9  nop
  db 0x90                                     ; 03ACA  nop
  db 0x00, 0x00                               ; 03ACB  add byte [bx + si], al
  db 0x00, 0x00                               ; 03ACD  add byte [bx + si], al
  db 0x00, 0xE9                               ; 03ACF  add cl, ch
