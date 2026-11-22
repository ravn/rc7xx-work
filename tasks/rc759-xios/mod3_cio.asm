; =============================================================================
; ccpm.sys — Modul 3: Character I/O (CIOIF.CIO)
; Offset range: 0x031E0 - 0x03AD0
; =============================================================================

  jmp near cio_init                            ; 031E0  0xE9, 0x48, 0x00
  jmp near cio_entry                           ; 031E3  0xE9, 0x80, 0x00
  cli                                          ; 031E6  0xFA
  push es                                      ; 031E7  0x06
  dw 0x0003                                    ; 031E8  MEMIF version
  dw 0x0048                                    ; 031EA  Segment
  db 0x06                                      ; 031EC
  db "COPYRIGHT (C) 1982,1983,1984 DIGITAL RESEARCH 1034-0261-007041" ; 031ED

cio_init:  ; 0322B
  retf                                         ; 0322B  0xCB
  db 0x6B, 0x03, 0x7E                         ; 0322C  imul ax, word [bp + di], 0x7e
  add cx, [bp - 0x6bfd]                        ; 0322F  0x03, 0x8E, 0x03, 0x94
  add bx, [bp + si - 0x4fd]                    ; 03233  0x03, 0x9A, 0x03, 0xFB
  add bx, [bx + si]                            ; 03237  0x03, 0x18
  add al, 0xe6                                 ; 03239  0x04, 0xE6
  add al, 0xae                                 ; 0323B  0x04, 0xAE
  add di, [bp + di + 0x3300]                   ; 0323D  0x03, 0xBB, 0x00, 0x33
  add [bp + di + 0x6402], cx                   ; 03241  0x01, 0x8B, 0x02, 0x64
  add [bx + 2], si                             ; 03245  0x01, 0x77, 0x02
  mov al, 4                                    ; 03248  0xB0, 0x04
  lahf                                         ; 0324A  0x9F
  add [bx + di], cl                            ; 0324B  0x00, 0x09
  add [bp + si - 0x5cfe], bp                   ; 0324D  0x01, 0xAA, 0x02, 0xA3
  add [bx - 0x7f00], bh                        ; 03251  0x00, 0xBF, 0x00, 0x81
  add bl, [bp + di - 0x6500]                   ; 03255  0x02, 0x9B, 0x00, 0x9B
  add [si], cl                                 ; 03259  0x00, 0x0C
  db 0x03, 0xD3                               ; 0325B  add dx, bx
  add bx, [bx + di + 3]                        ; 0325D  0x03, 0x59, 0x03
  inc si                                       ; 03260  0x46
  add al, 0x57                                 ; 03261  0x04, 0x57
  add al, 0x63                                 ; 03263  0x04, 0x63
  db 0x04                                                         ; 03265  .

cio_entry:  ; 03266
  shl cx, 1                                    ; 03266  0xD1, 0xE1
  db 0x8B, 0xF1                               ; 03268  mov si, cx
  db 0x2E, 0xFF, 0x94, 0x4C, 0x00             ; 0326A  call word [cs:si + 0x4c]
  retf                                         ; 0326F  0xCB

cio_xios_far_call:  ; 03270
  call far [cs:8]                              ; 03270  0x2E, 0xFF, 0x1E, 0x08, 0x00
  ret                                          ; 03275  0xC3

cio_xios_call:  ; 03276
  call far [0x28]                              ; 03276  0xFF, 0x1E, 0x28, 0x00
  ret                                          ; 0327A  0xC3

cio_fn21_notimp:  ; 0327B
  mov bx, 0xffff                               ; 0327B  0xBB, 0xFF, 0xFF
  ret                                          ; 0327E  0xC3

cio_fn15_lstattach:  ; 0327F
  db 0x33, 0xC9                               ; 0327F  xor cx, cx
  jmp short cio_lcb_verify                          ; 03281  0xEB, 0x03

cio_fn18_clstattch:  ; 03283
  mov cx, 0xffff                               ; 03283  0xB9, 0xFF, 0xFF

cio_lcb_verify:  ; 03286
  push cx                                      ; 03286  0x51
  mov si, [es:0x64]                            ; 03287  0x26, 0x8B, 0x36, 0x64, 0x00
  test si, si                                  ; 0328C  0x85, 0xF6
  jne loc_03298                                ; 0328E  0x75, 0x08
  call cio_getlcbadr                               ; 03290  0xE8, 0x34, 0x02
  mov [es:0x64], si                            ; 03293  0x26, 0x89, 0x36, 0x64, 0x00

loc_03298:  ; 03298
  pop cx                                       ; 03298  0x59
  jmp short loc_032B5                          ; 03299  0xEB, 0x1A

cio_fn09_conattach:  ; 0329B
  db 0x33, 0xC9                               ; 0329B  xor cx, cx
  jmp short cio_ccb_verify                          ; 0329D  0xEB, 0x03

cio_fn19_cconattch:  ; 0329F
  mov cx, 0xffff                               ; 0329F  0xB9, 0xFF, 0xFF

cio_ccb_verify:  ; 032A2
  push cx                                      ; 032A2  0x51
  mov si, [es:0x62]                            ; 032A3  0x26, 0x8B, 0x36, 0x62, 0x00
  test si, si                                  ; 032A8  0x85, 0xF6
  jne loc_032B4                                ; 032AA  0x75, 0x08
  call cio_getccbadr                               ; 032AC  0xE8, 0xFA, 0x01
  mov [es:0x62], si                            ; 032AF  0x26, 0x89, 0x36, 0x62, 0x00

loc_032B4:  ; 032B4
  pop cx                                       ; 032B4  0x59

loc_032B5:  ; 032B5
  mov ax, [0x68]                               ; 032B5  0xA1, 0x68, 0x00
  db 0x8B, 0xD8                               ; 032B8  mov bx, ax
  pushf                                        ; 032BA  0x9C
  cli                                          ; 032BB  0xFA
  cmp bx, [si]                                 ; 032BC  0x3B, 0x1C
  je loc_032E5                                 ; 032BE  0x74, 0x25
  cmp word [si], 0                             ; 032C0  0x83, 0x3C, 0x00
  je loc_032E3                                 ; 032C3  0x74, 0x1E
  jcxz loc_032CF                               ; 032C5  0xE3, 0x08
  popf                                         ; 032C7  0x9D
  mov bx, 0xffff                               ; 032C8  0xBB, 0xFF, 0xFF
  mov cx, 0x24                                 ; 032CB  0xB9, 0x24, 0x00
  ret                                          ; 032CE  0xC3

loc_032CF:  ; 032CF
  push dx                                      ; 032CF  0x52
  lea dx, [si + 2]                             ; 032D0  0x8D, 0x54, 0x02
  mov bl, 9                                    ; 032D3  0xB3, 0x09
  push si                                      ; 032D5  0x56
  mov cx, 0x212                                ; 032D6  0xB9, 0x12, 0x02
  call cio_xios_far_call                               ; 032D9  0xE8, 0x94, 0xFF
  pop si                                       ; 032DC  0x5E
  pop dx                                       ; 032DD  0x5A
  popf                                         ; 032DE  0x9D
  db 0x33, 0xC9                               ; 032DF  xor cx, cx
  jmp short loc_032B5                          ; 032E1  0xEB, 0xD2

loc_032E3:  ; 032E3
  mov [si], bx                                 ; 032E3  0x89, 0x1C

loc_032E5:  ; 032E5
  popf                                         ; 032E5  0x9D
  db 0x33, 0xDB                               ; 032E6  xor bx, bx
  ret                                          ; 032E8  0xC3

cio_fn16_lstdetach:  ; 032E9
  call cio_lcb_verify                               ; 032E9  0xE8, 0x9A, 0xFF

cio_ciodetach:  ; 032EC
  mov bx, [0x68]                               ; 032EC  0x8B, 0x1E, 0x68, 0x00
  pushf                                        ; 032F0  0x9C
  cli                                          ; 032F1  0xFA
  cmp word [si], 0                             ; 032F2  0x83, 0x3C, 0x00
  je loc_03340                                 ; 032F5  0x74, 0x49
  cmp [si], bx                                 ; 032F7  0x39, 0x1C
  je loc_03303                                 ; 032F9  0x74, 0x08
  popf                                         ; 032FB  0x9D
  mov bx, 0xffff                               ; 032FC  0xBB, 0xFF, 0xFF
  mov cx, 0x20                                 ; 032FF  0xB9, 0x20, 0x00
  ret                                          ; 03302  0xC3

loc_03303:  ; 03303
  mov ax, [si + 2]                             ; 03303  0x8B, 0x44, 0x02
  mov [si], ax                                 ; 03306  0x89, 0x04
  mov cx, 0x213                                ; 03308  0xB9, 0x13, 0x02
  lea dx, [si + 2]                             ; 0330B  0x8D, 0x54, 0x02
  call cio_xios_far_call                               ; 0330E  0xE8, 0x5F, 0xFF
  jmp short loc_03340                          ; 03311  0xEB, 0x2D

cio_fn10_condetach:  ; 03313
  call cio_ccb_verify                               ; 03313  0xE8, 0x8C, 0xFF

cio_condetach_dev:  ; 03316
  mov bx, [0x68]                               ; 03316  0x8B, 0x1E, 0x68, 0x00
  pushf                                        ; 0331A  0x9C
  cli                                          ; 0331B  0xFA
  cmp word [si], 0                             ; 0331C  0x83, 0x3C, 0x00
  je loc_03340                                 ; 0331F  0x74, 0x1F
  cmp [si], bx                                 ; 03321  0x39, 0x1C
  je loc_0332D                                 ; 03323  0x74, 0x08
  popf                                         ; 03325  0x9D
  mov bx, 0xffff                               ; 03326  0xBB, 0xFF, 0xFF
  mov cx, 0x20                                 ; 03329  0xB9, 0x20, 0x00
  ret                                          ; 0332C  0xC3

loc_0332D:  ; 0332D
  and word [si + 0xe], strict word 0xffef     ; 0332D  81 64 0E EF FF
  mov ax, [si + 2]                             ; 03332  0x8B, 0x44, 0x02
  mov [si], ax                                 ; 03335  0x89, 0x04
  mov cx, 0x213                                ; 03337  0xB9, 0x13, 0x02
  lea dx, [si + 2]                             ; 0333A  0x8D, 0x54, 0x02
  call cio_xios_far_call                               ; 0333D  0xE8, 0x30, 0xFF

loc_03340:  ; 03340
  popf                                         ; 03340  0x9D
  db 0x33, 0xDB                               ; 03341  xor bx, bx
  ret                                          ; 03343  0xC3

cio_fn12_conassign:  ; 03344
  push dx                                      ; 03344  0x52
  mov bx, 0x70d                                ; 03345  0xBB, 0x0D, 0x07
  mov cx, 0x215                                ; 03348  0xB9, 0x15, 0x02
  call cio_xios_far_call                               ; 0334B  0xE8, 0x22, 0xFF
  pop di                                       ; 0334E  0x5F
  mov byte [0x652], 0xff                       ; 0334F  0xC6, 0x06, 0x52, 0x06, 0xFF
  push ds                                      ; 03354  0x1E
  mov ds, [es:0x2e]                            ; 03355  0x26, 0x8E, 0x1E, 0x2E, 0x00
  cmp word [di + 2], 1                         ; 0335A  0x83, 0x7D, 0x02, 0x01
  jbe loc_0337B                                ; 0335E  0x76, 0x1B
  mov bx, [di + 2]                             ; 03360  0x8B, 0x5D, 0x02
  pop ds                                       ; 03363  0x1F
  mov si, 0x70                                 ; 03364  0xBE, 0x70, 0x00

loc_03367:  ; 03367
  mov si, [si + 2]                             ; 03367  0x8B, 0x74, 0x02
  test si, si                                  ; 0336A  0x85, 0xF6
  je loc_03396                                 ; 0336C  0x74, 0x28
  db 0x3B, 0xDE                               ; 0336E  cmp bx, si
  je loc_03374                                 ; 03370  0x74, 0x02
  jmp short loc_03367                          ; 03372  0xEB, 0xF3

loc_03374:  ; 03374
  call cio_conassign_match                               ; 03374  0xE8, 0xB3, 0x00
  jcxz loc_033A2                               ; 03377  0xE3, 0x29
  jmp short loc_03396                          ; 03379  0xEB, 0x1B

loc_0337B:  ; 0337B
  pop ds                                       ; 0337B  0x1F
  mov bx, 0x70                                 ; 0337C  0xBB, 0x70, 0x00

loc_0337F:  ; 0337F
  push di                                      ; 0337F  0x57
  lea dx, [di + 4]                             ; 03380  0x8D, 0x55, 0x04
  mov ds, [es:0x2e]                            ; 03383  0x26, 0x8E, 0x1E, 0x2E, 0x00
  mov cx, 0x214                                ; 03388  0xB9, 0x14, 0x02
  call cio_xios_far_call                               ; 0338B  0xE8, 0xE2, 0xFE
  mov ds, [cs:6]                               ; 0338E  0x2E, 0x8E, 0x1E, 0x06, 0x00
  pop di                                       ; 03393  0x5F
  jcxz loc_0339B                               ; 03394  0xE3, 0x05

loc_03396:  ; 03396
  mov cx, 0x14                                 ; 03396  0xB9, 0x14, 0x00
  jmp short loc_033D0                          ; 03399  0xEB, 0x35

loc_0339B:  ; 0339B
  call cio_conassign_match                               ; 0339B  0xE8, 0x8C, 0x00
  jcxz loc_033A2                               ; 0339E  0xE3, 0x02
  jmp short loc_0337F                          ; 033A0  0xEB, 0xDD

loc_033A2:  ; 033A2
  push bx                                      ; 033A2  0x53
  push di                                      ; 033A3  0x57
  mov bx, 0x70d                                ; 033A4  0xBB, 0x0D, 0x07
  mov cx, 0x216                                ; 033A7  0xB9, 0x16, 0x02
  call cio_xios_far_call                               ; 033AA  0xE8, 0xC3, 0xFE
  pop di                                       ; 033AD  0x5F
  pop ax                                       ; 033AE  0x58
  mov ds, [es:0x2e]                            ; 033AF  0x26, 0x8E, 0x1E, 0x2E, 0x00
  push ax                                      ; 033B4  0x50
  mov al, [di]                                 ; 033B5  0x8A, 0x05
  mov ds, [cs:6]                               ; 033B7  0x2E, 0x8E, 0x1E, 0x06, 0x00
  call cio_getccbadr_spec                               ; 033BC  0xE8, 0xF1, 0x00
  mov bx, [0x68]                               ; 033BF  0x8B, 0x1E, 0x68, 0x00
  pop ax                                       ; 033C3  0x58
  cmp word [si], 0                             ; 033C4  0x83, 0x3C, 0x00
  je loc_033E2                                 ; 033C7  0x74, 0x19
  cmp [si], bx                                 ; 033C9  0x39, 0x1C
  je loc_033E2                                 ; 033CB  0x74, 0x15
  mov cx, 0x20                                 ; 033CD  0xB9, 0x20, 0x00

loc_033D0:  ; 033D0
  push cx                                      ; 033D0  0x51
  call cio_wake_disp                               ; 033D1  0xE8, 0x40, 0x00
  mov bx, 0x70d                                ; 033D4  0xBB, 0x0D, 0x07
  mov cx, 0x216                                ; 033D7  0xB9, 0x16, 0x02
  call cio_xios_far_call                               ; 033DA  0xE8, 0x93, 0xFE
  pop cx                                       ; 033DD  0x59
  mov bx, 0xffff                               ; 033DE  0xBB, 0xFF, 0xFF
  ret                                          ; 033E1  0xC3

loc_033E2:  ; 033E2
  mov [si], ax                                 ; 033E2  0x89, 0x04
  push ax                                      ; 033E4  0x50
  push si                                      ; 033E5  0x56
  call cio_wake_disp                               ; 033E6  0xE8, 0x2B, 0x00
  pop si                                       ; 033E9  0x5E
  pop ax                                       ; 033EA  0x58
  db 0x8B, 0xD8                               ; 033EB  mov bx, ax
  add si, 2                                    ; 033ED  0x83, 0xC6, 0x02
  db 0x8B, 0xFE                               ; 033F0  mov di, si

loc_033F2:  ; 033F2
  cmp word [si], 0                             ; 033F2  0x83, 0x3C, 0x00
  je loc_03411                                 ; 033F5  0x74, 0x1A
  cmp [si], bx                                 ; 033F7  0x39, 0x1C
  je loc_033FF                                 ; 033F9  0x74, 0x04
  mov si, [si]                                 ; 033FB  0x8B, 0x34
  jmp short loc_033F2                          ; 033FD  0xEB, 0xF3

loc_033FF:  ; 033FF
  mov ax, [bx]                                 ; 033FF  0x8B, 0x07
  mov [si], ax                                 ; 03401  0x89, 0x04
  mov si, [di]                                 ; 03403  0x8B, 0x35
  mov [di], bx                                 ; 03405  0x89, 0x1D
  mov [bx], si                                 ; 03407  0x89, 0x37
  db 0x8B, 0xD7                               ; 03409  mov dx, di
  mov cx, 0x213                                ; 0340B  0xB9, 0x13, 0x02
  call cio_xios_far_call                               ; 0340E  0xE8, 0x5F, 0xFE

loc_03411:  ; 03411
  db 0x33, 0xDB                               ; 03411  xor bx, bx
  ret                                          ; 03413  0xC3

cio_wake_disp:  ; 03414
  mov byte [0x652], 0                          ; 03414  0xC6, 0x06, 0x52, 0x06, 0x00
  pushf                                        ; 03419  0x9C
  cli                                          ; 0341A  0xFA
  cmp word [0x6c], 0                           ; 0341B  0x83, 0x3E, 0x6C, 0x00, 0x00
  je loc_03428                                 ; 03420  0x74, 0x06
  mov cx, 0x8e                                 ; 03422  0xB9, 0x8E, 0x00
  call cio_xios_far_call                               ; 03425  0xE8, 0x48, 0xFE

loc_03428:  ; 03428
  popf                                         ; 03428  0x9D
  ret                                          ; 03429  0xC3

cio_conassign_match:  ; 0342A
  db 0x33, 0xC9                               ; 0342A  xor cx, cx
  push es                                      ; 0342C  0x06
  mov es, [es:0x2e]                            ; 0342D  0x26, 0x8E, 0x06, 0x2E, 0x00
  mov ax, [es:di + 2]                          ; 03432  0x26, 0x8B, 0x45, 0x02
  cmp ax, strict word 1                       ; 03436  3D 01 00
  ja loc_03445                                 ; 03439  0x77, 0x0A
  dec ax                                       ; 0343B  0x48
  jne loc_03445                                ; 0343C  0x75, 0x07
  test word [bx + 6], 0x2000                   ; 0343E  0xF7, 0x47, 0x06, 0x00, 0x20
  jne loc_03454                                ; 03443  0x75, 0x0F

loc_03445:  ; 03445
  cmp byte [es:di + 1], 0                      ; 03445  0x26, 0x80, 0x7D, 0x01, 0x00
  je loc_03455                                 ; 0344A  0x74, 0x09
  mov al, [es:di]                              ; 0344C  0x26, 0x8A, 0x05
  cmp al, [bx + 0x20]                          ; 0344F  0x3A, 0x47, 0x20
  je loc_03455                                 ; 03452  0x74, 0x01

loc_03454:  ; 03454
  inc cx                                       ; 03454  0x41

loc_03455:  ; 03455
  pop es                                       ; 03455  0x07
  ret                                          ; 03456  0xC3

cio_fn13_getdefcon:  ; 03457
  mov si, [0x68]                               ; 03457  0x8B, 0x36, 0x68, 0x00
  db 0x32, 0xFF                               ; 0345B  xor bh, bh
  mov bl, [si + 0x20]                          ; 0345D  0x8A, 0x5C, 0x20
  ret                                          ; 03460  0xC3

cio_fn20_getdeflst:  ; 03461
  mov si, [0x68]                               ; 03461  0x8B, 0x36, 0x68, 0x00
  db 0x32, 0xFF                               ; 03465  xor bh, bh
  mov bl, [si + 0x24]                          ; 03467  0x8A, 0x5C, 0x24
  ret                                          ; 0346A  0xC3

cio_fn11_setdefcon:  ; 0346B
  cmp dl, [0x83]                               ; 0346B  0x3A, 0x16, 0x83, 0x00
  jb loc_03478                                 ; 0346F  0x72, 0x07
  mov cx, 0x13                                 ; 03471  0xB9, 0x13, 0x00
  mov bx, 0xffff                               ; 03474  0xBB, 0xFF, 0xFF
  ret                                          ; 03477  0xC3

loc_03478:  ; 03478
  mov si, [0x68]                               ; 03478  0x8B, 0x36, 0x68, 0x00
  mov [si + 0x20], dl                          ; 0347C  0x88, 0x54, 0x20
  call cio_getccbadr                               ; 0347F  0xE8, 0x27, 0x00
  mov [es:0x62], si                            ; 03482  0x26, 0x89, 0x36, 0x62, 0x00
  db 0x33, 0xDB                               ; 03487  xor bx, bx
  ret                                          ; 03489  0xC3

cio_fn17_setdeflst:  ; 0348A
  cmp dl, [0x84]                               ; 0348A  0x3A, 0x16, 0x84, 0x00
  jb loc_03497                                 ; 0348E  0x72, 0x07
  mov cx, 0x25                                 ; 03490  0xB9, 0x25, 0x00
  mov bx, 0xffff                               ; 03493  0xBB, 0xFF, 0xFF
  ret                                          ; 03496  0xC3

loc_03497:  ; 03497
  mov si, [0x68]                               ; 03497  0x8B, 0x36, 0x68, 0x00
  mov [si + 0x24], dl                          ; 0349B  0x88, 0x54, 0x24
  call cio_getlcbadr                               ; 0349E  0xE8, 0x26, 0x00
  mov [es:0x64], si                            ; 034A1  0x26, 0x89, 0x36, 0x64, 0x00
  db 0x33, 0xDB                               ; 034A6  xor bx, bx
  ret                                          ; 034A8  0xC3

cio_getccbadr:  ; 034A9
  mov bx, [0x68]                               ; 034A9  0x8B, 0x1E, 0x68, 0x00
  mov al, [bx + 0x20]                          ; 034AD  0x8A, 0x47, 0x20

cio_getccbadr_spec:  ; 034B0
  db 0x32, 0xE4                               ; 034B0  xor ah, ah
  mov si, [0x54]                               ; 034B2  0x8B, 0x36, 0x54, 0x00
  mov cl, 2                                    ; 034B6  0xB1, 0x02
  shl ax, cl                                   ; 034B8  0xD3, 0xE0
  db 0x03, 0xF0                               ; 034BA  add si, ax
  db 0x03, 0xF0                               ; 034BC  add si, ax
  db 0x03, 0xF0                               ; 034BE  add si, ax
  mov cl, 3                                    ; 034C0  0xB1, 0x03
  shl ax, cl                                   ; 034C2  0xD3, 0xE0
  db 0x03, 0xF0                               ; 034C4  add si, ax
  ret                                          ; 034C6  0xC3

cio_getlcbadr:  ; 034C7
  mov bx, [0x68]                               ; 034C7  0x8B, 0x1E, 0x68, 0x00
  db 0x32, 0xE4                               ; 034CB  xor ah, ah
  mov al, [bx + 0x24]                          ; 034CD  0x8A, 0x47, 0x24
  cmp al, [0x48]                               ; 034D0  0x3A, 0x06, 0x48, 0x00
  jbe loc_034DB                                ; 034D4  0x76, 0x05
  mov al, 0                                    ; 034D6  0xB0, 0x00
  mov [bx + 0x24], al                          ; 034D8  0x88, 0x47, 0x24

loc_034DB:  ; 034DB
  mov si, [0x86]                               ; 034DB  0x8B, 0x36, 0x86, 0x00
  push ax                                      ; 034DF  0x50
  shl ax, 1                                    ; 034E0  0xD1, 0xE0
  db 0x03, 0xF0                               ; 034E2  add si, ax
  pop ax                                       ; 034E4  0x58
  mov cl, 3                                    ; 034E5  0xB1, 0x03
  shl ax, cl                                   ; 034E7  0xD3, 0xE0
  db 0x03, 0xF0                               ; 034E9  add si, ax
  ret                                          ; 034EB  0xC3

cio_fn23_cioterm:  ; 034EC
  mov al, [0x83]                               ; 034EC  0xA0, 0x83, 0x00
  mov si, [0x54]                               ; 034EF  0x8B, 0x36, 0x54, 0x00

loc_034F3:  ; 034F3
  cmp al, 0                                    ; 034F3  0x3C, 0x00
  je loc_0351D                                 ; 034F5  0x74, 0x26
  cmp si, [es:0x62]                            ; 034F7  0x26, 0x3B, 0x36, 0x62, 0x00
  jne loc_0350F                                ; 034FC  0x75, 0x11
  and byte [si + 4], 0xc7                      ; 034FE  0x80, 0x64, 0x04, 0xC7
  mov cx, 0x213                                ; 03502  0xB9, 0x13, 0x02
  lea dx, [si + 0x22]                          ; 03505  0x8D, 0x54, 0x22
  push ax                                      ; 03508  0x50
  push si                                      ; 03509  0x56
  call cio_xios_far_call                               ; 0350A  0xE8, 0x63, 0xFD
  pop si                                       ; 0350D  0x5E
  pop ax                                       ; 0350E  0x58

loc_0350F:  ; 0350F
  push ax                                      ; 0350F  0x50
  push si                                      ; 03510  0x56
  call cio_condetach_dev                               ; 03511  0xE8, 0x02, 0xFE
  pop si                                       ; 03514  0x5E
  pop ax                                       ; 03515  0x58
  dec al                                       ; 03516  0xFE, 0xC8
  add si, 0x2c                                 ; 03518  0x83, 0xC6, 0x2C
  jmp short loc_034F3                          ; 0351B  0xEB, 0xD6

loc_0351D:  ; 0351D
  mov al, [0x84]                               ; 0351D  0xA0, 0x84, 0x00
  mov si, [0x86]                               ; 03520  0x8B, 0x36, 0x86, 0x00

loc_03524:  ; 03524
  cmp al, 0                                    ; 03524  0x3C, 0x00
  je loc_03536                                 ; 03526  0x74, 0x0E
  push ax                                      ; 03528  0x50
  push si                                      ; 03529  0x56
  call cio_ciodetach                               ; 0352A  0xE8, 0xBF, 0xFD
  pop si                                       ; 0352D  0x5E
  pop ax                                       ; 0352E  0x58
  dec al                                       ; 0352F  0xFE, 0xC8
  add si, 0xa                                  ; 03531  0x83, 0xC6, 0x0A
  jmp short loc_03524                          ; 03534  0xEB, 0xEE

loc_03536:  ; 03536
  db 0x33, 0xDB                               ; 03536  xor bx, bx
  ret                                          ; 03538  0xC3

cio_fn25_cmode:  ; 03539
  mov bx, [0x68]                               ; 03539  0x8B, 0x1E, 0x68, 0x00
  inc dx                                       ; 0353D  0x42
  je loc_03547                                 ; 0353E  0x74, 0x07
  dec dx                                       ; 03540  0x4A
  mov [bx + 0x22], dx                          ; 03541  0x89, 0x57, 0x22
  db 0x33, 0xDB                               ; 03544  xor bx, bx
  ret                                          ; 03546  0xC3

loc_03547:  ; 03547
  mov bx, [bx + 0x22]                          ; 03547  0x8B, 0x5F, 0x22
  ret                                          ; 0354A  0xC3

cio_fn00_conin:  ; 0354B
  call cio_clr_raw_mode                               ; 0354B  0xE8, 0xBE, 0x02
  call cio_coninf                               ; 0354E  0xE8, 0xE7, 0x03
  db 0x8A, 0xD0                               ; 03551  mov dl, al
  call cio_chk_ctrlp                               ; 03553  0xE8, 0xD8, 0x02
  jb loc_0355B                                 ; 03556  0x72, 0x03
  call cio_tabout                               ; 03558  0xE8, 0x82, 0x03

loc_0355B:  ; 0355B
  db 0x8A, 0xDA                               ; 0355B  mov bl, dl
  ret                                          ; 0355D  0xC3

cio_fn01_conout:  ; 0355E
  call cio_clr_raw_mode                               ; 0355E  0xE8, 0xAB, 0x02
  test word [bx + 0x22], 4                     ; 03561  0xF7, 0x47, 0x22, 0x04, 0x00
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
  mov bx, [0x68]                               ; 0357A  0x8B, 0x1E, 0x68, 0x00
  mov dh, [bx + 0x24]                          ; 0357E  0x8A, 0x77, 0x24
  mov si, [es:0x64]                            ; 03581  0x26, 0x8B, 0x36, 0x64, 0x00
  push dx                                      ; 03586  0x52
  call cio_fn15_lstattach                      ; 03587  0xE8, 0xF5, 0xFC
  pop dx                                       ; 0358A  0x5A
  jmp near cio_listf                           ; 0358B  0xE9, 0xAE, 0x04

cio_fn08_constat:  ; 0358E
  call cio_clr_raw_mode                               ; 0358E  0xE8, 0x7B, 0x02
  call cio_dirio_status                               ; 03591  0xE8, 0x3B, 0x00
  test bl, bl                                  ; 03594  0x84, 0xDB
  je loc_035AF                                 ; 03596  0x74, 0x17
  mov di, [0x68]                               ; 03598  0x8B, 0x3E, 0x68, 0x00
  test word [di + 0x22], 1                     ; 0359C  0xF7, 0x45, 0x22, 0x01, 0x00
  je loc_035AF                                 ; 035A1  0x74, 0x0C
  call cio_coninf                               ; 035A3  0xE8, 0x92, 0x03
  cmp al, 3                                    ; 035A6  0x3C, 0x03
  jne loc_035B0                                ; 035A8  0x75, 0x06
  mov [si + 0x2a], bx                          ; 035AA  0x89, 0x5C, 0x2A
  mov bl, 1                                    ; 035AD  0xB3, 0x01

loc_035AF:  ; 035AF
  ret                                          ; 035AF  0xC3

loc_035B0:  ; 035B0
  db 0x32, 0xDB                               ; 035B0  xor bl, bl
  ret                                          ; 035B2  0xC3

cio_fn24_ciostat:  ; 035B3
  mov bx, [0x68]                               ; 035B3  0x8B, 0x1E, 0x68, 0x00
  mov dh, [bx + 0x20]                          ; 035B7  0x8A, 0x77, 0x20
  mov si, [es:0x62]                            ; 035BA  0x26, 0x8B, 0x36, 0x62, 0x00
  test si, si                                  ; 035BF  0x85, 0xF6
  je loc_035C7                                 ; 035C1  0x74, 0x04
  cmp bx, [si]                                 ; 035C3  0x3B, 0x1C
  je cio_dirio_status                                 ; 035C5  0x74, 0x08

loc_035C7:  ; 035C7
  mov cl, 0x8e                                 ; 035C7  0xB1, 0x8E
  call cio_xios_far_call                               ; 035C9  0xE8, 0xA4, 0xFC
  mov bl, 0                                    ; 035CC  0xB3, 0x00
  ret                                          ; 035CE  0xC3

cio_dirio_status:  ; 035CF
  call cio_constf                               ; 035CF  0xE8, 0x47, 0x03
  test bl, bl                                  ; 035D2  0x84, 0xDB
  je loc_035D8                                 ; 035D4  0x74, 0x02
  mov bl, 1                                    ; 035D6  0xB3, 0x01

loc_035D8:  ; 035D8
  db 0x8A, 0xC3                               ; 035D8  mov al, bl
  ret                                          ; 035DA  0xC3

cio_fn05_dirio:  ; 035DB
  call cio_set_raw_mode                               ; 035DB  0xE8, 0x23, 0x02
  cmp dl, 0xfd                                 ; 035DE  0x80, 0xFA, 0xFD
  jb loc_03577                                 ; 035E1  0x72, 0x94
  ja loc_035E8                                 ; 035E3  0x77, 0x03
  jmp near cio_coninf                           ; 035E5  0xE9, 0x50, 0x03

loc_035E8:  ; 035E8
  call cio_constf                               ; 035E8  0xE8, 0x2E, 0x03
  cmp dl, 0xfe                                 ; 035EB  0x80, 0xFA, 0xFE
  jne loc_035F1                                ; 035EE  0x75, 0x01

loc_035F0:  ; 035F0
  ret                                          ; 035F0  0xC3

loc_035F1:  ; 035F1
  test bl, bl                                  ; 035F1  0x84, 0xDB
  je loc_035F0                                 ; 035F3  0x74, 0xFB
  jmp near cio_coninf                           ; 035F5  0xE9, 0x40, 0x03

cio_fn06_conwrite:  ; 035F8
  push dx                                      ; 035F8  0x52
  call cio_clr_raw_mode                               ; 035F9  0xE8, 0x10, 0x02
  pop bx                                       ; 035FC  0x5B

loc_035FD:  ; 035FD
  push ds                                      ; 035FD  0x1E
  mov ds, [es:0x2e]                            ; 035FE  0x26, 0x8E, 0x1E, 0x2E, 0x00
  mov dl, [bx]                                 ; 03603  0x8A, 0x17
  pop ds                                       ; 03605  0x1F
  cmp dl, [es:0x66]                            ; 03606  0x26, 0x3A, 0x16, 0x66, 0x00
  je loc_03625                                 ; 0360B  0x74, 0x18
  push bx                                      ; 0360D  0x53
  mov bx, [0x68]                               ; 0360E  0x8B, 0x1E, 0x68, 0x00
  test word [bx + 0x22], 4                     ; 03612  0xF7, 0x47, 0x22, 0x04, 0x00
  je loc_0361E                                 ; 03617  0x74, 0x05
  call cio_conoutf                               ; 03619  0xE8, 0x58, 0x03
  jmp short loc_03621                          ; 0361C  0xEB, 0x03

loc_0361E:  ; 0361E
  call cio_tabout                               ; 0361E  0xE8, 0xBC, 0x02

loc_03621:  ; 03621
  pop bx                                       ; 03621  0x5B
  inc bx                                       ; 03622  0x43
  jmp short loc_035FD                          ; 03623  0xEB, 0xD8

loc_03625:  ; 03625
  ret                                          ; 03625  0xC3

cio_fn26_delim:  ; 03626
  cmp dx, -1                                   ; 03626  0x83, 0xFA, 0xFF
  je loc_03631                                 ; 03629  0x74, 0x06
  mov [es:0x66], dl                            ; 0362B  0x26, 0x88, 0x16, 0x66, 0x00
  ret                                          ; 03630  0xC3

loc_03631:  ; 03631
  mov bl, [es:0x66]                            ; 03631  0x26, 0x8A, 0x1E, 0x66, 0x00
  ret                                          ; 03636  0xC3

cio_fn27_pblock:  ; 03637
  push dx                                      ; 03637  0x52
  call cio_clr_raw_mode                               ; 03638  0xE8, 0xD1, 0x01
  pop di                                       ; 0363B  0x5F
  db 0x33, 0xC0                               ; 0363C  xor ax, ax
  mov bp, [bx + 0x22]                          ; 0363E  0x8B, 0x6F, 0x22
  jmp short loc_03652                          ; 03641  0xEB, 0x0F

cio_fn28_lblock:  ; 03643
  push dx                                      ; 03643  0x52
  call cio_fn15_lstattach                      ; 03644  0xE8, 0x38, 0xFC
  pop di                                       ; 03647  0x5F
  mov bx, [0x68]                               ; 03648  0x8B, 0x1E, 0x68, 0x00
  mov dh, [bx + 0x24]                          ; 0364C  0x8A, 0x77, 0x24
  mov ax, 0xffff                               ; 0364F  0xB8, 0xFF, 0xFF

loc_03652:  ; 03652
  push ds                                      ; 03652  0x1E
  mov ds, [es:0x2e]                            ; 03653  0x26, 0x8E, 0x1E, 0x2E, 0x00
  mov cx, [di + 4]                             ; 03658  0x8B, 0x4D, 0x04
  mov bx, [di + 2]                             ; 0365B  0x8B, 0x5D, 0x02
  mov di, [di]                                 ; 0365E  0x8B, 0x3D
  pop ds                                       ; 03660  0x1F
  test cx, cx                                  ; 03661  0x85, 0xC9
  je loc_0368F                                 ; 03663  0x74, 0x2A

loc_03665:  ; 03665
  push ds                                      ; 03665  0x1E
  mov ds, bx                                   ; 03666  0x8E, 0xDB
  mov dl, [di]                                 ; 03668  0x8A, 0x15
  pop ds                                       ; 0366A  0x1F
  push bp                                      ; 0366B  0x55
  push di                                      ; 0366C  0x57
  push cx                                      ; 0366D  0x51
  push bx                                      ; 0366E  0x53
  push ax                                      ; 0366F  0x50
  test ax, ax                                  ; 03670  0x85, 0xC0
  je loc_03679                                 ; 03672  0x74, 0x05
  call cio_listf                               ; 03674  0xE8, 0xC5, 0x03
  jmp short loc_03687                          ; 03677  0xEB, 0x0E

loc_03679:  ; 03679
  test bp, 4                                   ; 03679  0xF7, 0xC5, 0x04, 0x00
  jne loc_03684                                ; 0367D  0x75, 0x05
  call cio_tabout                               ; 0367F  0xE8, 0x5B, 0x02
  jmp short loc_03687                          ; 03682  0xEB, 0x03

loc_03684:  ; 03684
  call cio_conoutf                               ; 03684  0xE8, 0xED, 0x02

loc_03687:  ; 03687
  pop ax                                       ; 03687  0x58
  pop bx                                       ; 03688  0x5B
  pop cx                                       ; 03689  0x59
  pop di                                       ; 0368A  0x5F
  pop bp                                       ; 0368B  0x5D
  inc di                                       ; 0368C  0x47
  loop loc_03665                               ; 0368D  0xE2, 0xD6

loc_0368F:  ; 0368F
  ret                                          ; 0368F  0xC3

cio_fn14_conprint:  ; 03690
  push bx                                      ; 03690  0x53
  push dx                                      ; 03691  0x52
  call cio_clr_raw_mode                               ; 03692  0xE8, 0x77, 0x01
  pop bx                                       ; 03695  0x5B
  pop ax                                       ; 03696  0x58
  db 0x33, 0xC9                               ; 03697  xor cx, cx
  and al, 0x7f                                 ; 03699  0x24, 0x7F

loc_0369B:  ; 0369B
  cmp ah, 0                                    ; 0369B  0x80, 0xFC, 0x00
  je loc_036A4                                 ; 0369E  0x74, 0x04
  db 0x3A, 0xE1                               ; 036A0  cmp ah, cl
  je loc_036C5                                 ; 036A2  0x74, 0x21

loc_036A4:  ; 036A4
  push ds                                      ; 036A4  0x1E
  mov ds, [es:0x2e]                            ; 036A5  0x26, 0x8E, 0x1E, 0x2E, 0x00
  mov dl, [bx]                                 ; 036AA  0x8A, 0x17
  pop ds                                       ; 036AC  0x1F
  and dl, 0x7f                                 ; 036AD  0x80, 0xE2, 0x7F
  db 0x3A, 0xD0                               ; 036B0  cmp dl, al
  je loc_036C5                                 ; 036B2  0x74, 0x11
  push ax                                      ; 036B4  0x50
  push cx                                      ; 036B5  0x51
  push bx                                      ; 036B6  0x53
  call cio_conoutf                               ; 036B7  0xE8, 0xBA, 0x02
  call cio_chk_cmode                               ; 036BA  0xE8, 0xE7, 0x01
  pop bx                                       ; 036BD  0x5B
  pop cx                                       ; 036BE  0x59
  pop ax                                       ; 036BF  0x58
  inc cl                                       ; 036C0  0xFE, 0xC1
  inc bx                                       ; 036C2  0x43
  jmp short loc_0369B                          ; 036C3  0xEB, 0xD6

loc_036C5:  ; 036C5
  ret                                          ; 036C5  0xC3

cio_fn07_conread:  ; 036C6
  push dx                                      ; 036C6  0x52
  call cio_clr_raw_mode                               ; 036C7  0xE8, 0x42, 0x01
  pop bx                                       ; 036CA  0x5B

loc_036CB:  ; 036CB
  push bx                                      ; 036CB  0x53
  mov al, [si + 6]                             ; 036CC  0x8A, 0x44, 0x06
  mov [si + 5], al                             ; 036CF  0x88, 0x44, 0x05
  db 0x33, 0xDB                               ; 036D2  xor bx, bx

loc_036D4:  ; 036D4
  push bx                                      ; 036D4  0x53

loc_036D5:  ; 036D5
  call cio_coninf                               ; 036D5  0xE8, 0x60, 0x02
  db 0x8A, 0xD0                               ; 036D8  mov dl, al
  pop bx                                       ; 036DA  0x5B
  cmp dl, 0xd                                  ; 036DB  0x80, 0xFA, 0x0D
  jne loc_036E3                                ; 036DE  0x75, 0x03

loc_036E0:  ; 036E0
  jmp near loc_037EC                           ; 036E0  0xE9, 0x09, 0x01

loc_036E3:  ; 036E3
  cmp dl, 0xa                                  ; 036E3  0x80, 0xFA, 0x0A
  je loc_036E0                                 ; 036E6  0x74, 0xF8
  cmp dl, 8                                    ; 036E8  0x80, 0xFA, 0x08
  jne loc_03700                                ; 036EB  0x75, 0x13
  db 0x0A, 0xDB                               ; 036ED  or bl, bl
  je loc_036D4                                 ; 036EF  0x74, 0xE3
  dec bl                                       ; 036F1  0xFE, 0xCB
  mov al, [si + 6]                             ; 036F3  0x8A, 0x44, 0x06
  mov [si + 0xc], al                           ; 036F6  0x88, 0x44, 0x0C
  or byte [si + 4], 2                          ; 036F9  0x80, 0x4C, 0x04, 0x02
  jmp near loc_0376D                           ; 036FD  0xE9, 0x6D, 0x00

loc_03700:  ; 03700
  cmp dl, 0x7f                                 ; 03700  0x80, 0xFA, 0x7F
  jne loc_0371C                                ; 03703  0x75, 0x17
  db 0x0A, 0xDB                               ; 03705  or bl, bl
  je loc_03719                                 ; 03707  0x74, 0x10
  pop di                                       ; 03709  0x5F
  push di                                      ; 0370A  0x57
  push ds                                      ; 0370B  0x1E
  mov ds, [es:0x2e]                            ; 0370C  0x26, 0x8E, 0x1E, 0x2E, 0x00
  mov dl, [bx + di + 1]                        ; 03711  0x8A, 0x51, 0x01
  pop ds                                       ; 03714  0x1F
  dec bx                                       ; 03715  0x4B
  jmp near loc_037D7                           ; 03716  0xE9, 0xBE, 0x00

loc_03719:  ; 03719
  jmp near loc_036D4                           ; 03719  0xE9, 0xB8, 0xFF

loc_0371C:  ; 0371C
  cmp dl, 5                                    ; 0371C  0x80, 0xFA, 0x05
  jne loc_03737                                ; 0371F  0x75, 0x16
  push bx                                      ; 03721  0x53
  mov dl, 0xd                                  ; 03722  0xB2, 0x0D
  call cio_conoutf                               ; 03724  0xE8, 0x4D, 0x02
  mov dl, 0xa                                  ; 03727  0xB2, 0x0A
  call cio_conoutf                               ; 03729  0xE8, 0x48, 0x02
  mov byte [si + 6], 0                         ; 0372C  0xC6, 0x44, 0x06, 0x00
  mov byte [si + 5], 0                         ; 03730  0xC6, 0x44, 0x05, 0x00
  jmp near loc_036D5                           ; 03734  0xE9, 0x9E, 0xFF

loc_03737:  ; 03737
  cmp dl, 0x18                                 ; 03737  0x80, 0xFA, 0x18
  jne loc_0375C                                ; 0373A  0x75, 0x20

loc_0373C:  ; 0373C
  mov al, [si + 5]                             ; 0373C  0x8A, 0x44, 0x05
  cmp al, [si + 6]                             ; 0373F  0x3A, 0x44, 0x06
  jb loc_03748                                 ; 03742  0x72, 0x04
  db 0x33, 0xDB                               ; 03744  xor bx, bx
  jmp short loc_03719                          ; 03746  0xEB, 0xD1

loc_03748:  ; 03748
  mov dl, 8                                    ; 03748  0xB2, 0x08
  call cio_conoutf                               ; 0374A  0xE8, 0x27, 0x02
  mov dl, 0x20                                 ; 0374D  0xB2, 0x20
  call cio_conoutf                               ; 0374F  0xE8, 0x22, 0x02
  mov dl, 8                                    ; 03752  0xB2, 0x08
  call cio_conoutf                               ; 03754  0xE8, 0x1D, 0x02
  dec byte [si + 6]                            ; 03757  0xFE, 0x4C, 0x06
  jmp short loc_0373C                          ; 0375A  0xEB, 0xE0

loc_0375C:  ; 0375C
  cmp dl, 0x15                                 ; 0375C  0x80, 0xFA, 0x15
  jne loc_03768                                ; 0375F  0x75, 0x07
  call cio_prcsmsg                               ; 03761  0xE8, 0x9D, 0x01
  pop bx                                       ; 03764  0x5B
  jmp near loc_036CB                           ; 03765  0xE9, 0x63, 0xFF

loc_03768:  ; 03768
  cmp dl, 0x12                                 ; 03768  0x80, 0xFA, 0x12
  jne loc_037CA                                ; 0376B  0x75, 0x5D

loc_0376D:  ; 0376D
  push bx                                      ; 0376D  0x53
  call cio_prcsmsg                               ; 0376E  0xE8, 0x90, 0x01
  pop cx                                       ; 03771  0x59
  db 0x33, 0xDB                               ; 03772  xor bx, bx

loc_03774:  ; 03774
  db 0x0A, 0xC9                               ; 03774  or cl, cl
  je loc_03794                                 ; 03776  0x74, 0x1C
  pop di                                       ; 03778  0x5F
  push di                                      ; 03779  0x57
  push ds                                      ; 0377A  0x1E
  mov ds, [es:0x2e]                            ; 0377B  0x26, 0x8E, 0x1E, 0x2E, 0x00
  inc bx                                       ; 03780  0x43
  dec cl                                       ; 03781  0xFE, 0xC9
  mov dl, [bx + di + 1]                        ; 03783  0x8A, 0x51, 0x01
  pop ds                                       ; 03786  0x1F
  db 0x8A, 0xEB                               ; 03787  mov ch, bl
  push cx                                      ; 03789  0x51
  call cio_ctlout                               ; 0378A  0xE8, 0x41, 0x01
  pop cx                                       ; 0378D  0x59
  mov bh, 0                                    ; 0378E  0xB7, 0x00
  db 0x8A, 0xDD                               ; 03790  mov bl, ch
  jmp short loc_03774                          ; 03792  0xEB, 0xE0

loc_03794:  ; 03794
  test byte [si + 4], 2                        ; 03794  0xF6, 0x44, 0x04, 0x02
  push bx                                      ; 03798  0x53
  je loc_037C7                                 ; 03799  0x74, 0x2C
  and byte [si + 4], 0xfd                      ; 0379B  0x80, 0x64, 0x04, 0xFD
  mov ah, [si + 0xc]                           ; 0379F  0x8A, 0x64, 0x0C
  db 0x8A, 0xC4                               ; 037A2  mov al, ah

loc_037A4:  ; 037A4
  cmp al, [si + 6]                             ; 037A4  0x3A, 0x44, 0x06
  jb loc_037C7                                 ; 037A7  0x72, 0x1E
  sub al, [si + 6]                             ; 037A9  0x2A, 0x44, 0x06
  db 0x0A, 0xC0                               ; 037AC  or al, al
  je loc_037C7                                 ; 037AE  0x74, 0x17
  push ax                                      ; 037B0  0x50
  mov dl, 8                                    ; 037B1  0xB2, 0x08
  call cio_conoutf                               ; 037B3  0xE8, 0xBE, 0x01
  mov dl, 0x20                                 ; 037B6  0xB2, 0x20
  call cio_conoutf                               ; 037B8  0xE8, 0xB9, 0x01
  mov dl, 8                                    ; 037BB  0xB2, 0x08
  call cio_conoutf                               ; 037BD  0xE8, 0xB4, 0x01
  pop ax                                       ; 037C0  0x58
  dec ah                                       ; 037C1  0xFE, 0xCC
  db 0x8A, 0xC4                               ; 037C3  mov al, ah
  jmp short loc_037A4                          ; 037C5  0xEB, 0xDD

loc_037C7:  ; 037C7
  jmp near loc_036D5                           ; 037C7  0xE9, 0x0B, 0xFF

loc_037CA:  ; 037CA
  inc bx                                       ; 037CA  0x43
  pop di                                       ; 037CB  0x5F
  push di                                      ; 037CC  0x57
  push ds                                      ; 037CD  0x1E
  mov ds, [es:0x2e]                            ; 037CE  0x26, 0x8E, 0x1E, 0x2E, 0x00
  mov [bx + di + 1], dl                        ; 037D3  0x88, 0x51, 0x01
  pop ds                                       ; 037D6  0x1F

loc_037D7:  ; 037D7
  push bx                                      ; 037D7  0x53
  call cio_ctlout                               ; 037D8  0xE8, 0xF3, 0x00
  pop bx                                       ; 037DB  0x5B
  pop di                                       ; 037DC  0x5F
  push di                                      ; 037DD  0x57
  push ds                                      ; 037DE  0x1E
  mov ds, [es:0x2e]                            ; 037DF  0x26, 0x8E, 0x1E, 0x2E, 0x00
  cmp bl, [di]                                 ; 037E4  0x3A, 0x1D
  pop ds                                       ; 037E6  0x1F
  jae loc_037EC                                ; 037E7  0x73, 0x03
  push bx                                      ; 037E9  0x53
  jmp short loc_037C7                          ; 037EA  0xEB, 0xDB

loc_037EC:  ; 037EC
  pop di                                       ; 037EC  0x5F
  push ds                                      ; 037ED  0x1E
  mov ds, [es:0x2e]                            ; 037EE  0x26, 0x8E, 0x1E, 0x2E, 0x00
  mov [di + 1], bl                             ; 037F3  0x88, 0x5D, 0x01
  pop ds                                       ; 037F6  0x1F
  mov dl, 0xd                                  ; 037F7  0xB2, 0x0D
  call cio_conoutf                               ; 037F9  0xE8, 0x78, 0x01
  mov byte [si + 6], 0                         ; 037FC  0xC6, 0x44, 0x06, 0x00
  ret                                          ; 03800  0xC3

cio_set_raw_mode:  ; 03801
  mov bx, [0x68]                               ; 03801  0x8B, 0x1E, 0x68, 0x00
  or word [bx + 6], strict word 0x40          ; 03805  81 4F 06 40 00
  jmp short loc_03815                          ; 0380A  0xEB, 0x09

cio_clr_raw_mode:  ; 0380C
  mov bx, [0x68]                               ; 0380C  0x8B, 0x1E, 0x68, 0x00
  and word [bx + 6], strict word 0xffbf       ; 03810  81 67 06 BF FF

loc_03815:  ; 03815
  mov dh, [bx + 0x20]                          ; 03815  0x8A, 0x77, 0x20
  mov si, [es:0x62]                            ; 03818  0x26, 0x8B, 0x36, 0x62, 0x00
  test si, si                                  ; 0381D  0x85, 0xF6
  je loc_03826                                 ; 0381F  0x74, 0x05
  cmp [si], bx                                 ; 03821  0x39, 0x1C
  jne loc_03826                                ; 03823  0x75, 0x01
  ret                                          ; 03825  0xC3

loc_03826:  ; 03826
  push bx                                      ; 03826  0x53
  push dx                                      ; 03827  0x52
  call cio_fn09_conattach                      ; 03828  0xE8, 0x70, 0xFA
  pop dx                                       ; 0382B  0x5A
  pop bx                                       ; 0382C  0x5B
  ret                                          ; 0382D  0xC3

cio_chk_ctrlp:  ; 0382E
  cmp dl, 0xd                                  ; 0382E  0x80, 0xFA, 0x0D
  je loc_03845                                 ; 03831  0x74, 0x12
  cmp dl, 0xa                                  ; 03833  0x80, 0xFA, 0x0A
  je loc_03845                                 ; 03836  0x74, 0x0D
  cmp dl, 9                                    ; 03838  0x80, 0xFA, 0x09
  je loc_03845                                 ; 0383B  0x74, 0x08
  cmp dl, 8                                    ; 0383D  0x80, 0xFA, 0x08
  je loc_03845                                 ; 03840  0x74, 0x03
  cmp dl, 0x20                                 ; 03842  0x80, 0xFA, 0x20

loc_03845:  ; 03845
  ret                                          ; 03845  0xC3
  db 0x33, 0xDB                               ; 03846  xor bx, bx
  mov ax, cs                                   ; 03848  0x8C, 0xC8

loc_0384A:  ; 0384A
  push word [es:0x2e]                          ; 0384A  0x26, 0xFF, 0x36, 0x2E, 0x00
  mov [es:0x2e], ax                            ; 0384F  0x26, 0xA3, 0x2E, 0x00
  call cio_fn14_conprint                       ; 03853  0xE8, 0x3A, 0xFE
  pop word [es:0x2e]                           ; 03856  0x26, 0x8F, 0x06, 0x2E, 0x00
  ret                                          ; 0385B  0xC3
  mov bh, 8                                    ; 0385C  0xB7, 0x08
  mov bl, 0x20                                 ; 0385E  0xB3, 0x20
  mov ax, ds                                   ; 03860  0x8C, 0xD8
  jmp short loc_0384A                          ; 03862  0xEB, 0xE6

cio_conout:  ; 03864
  test byte [si + 4], 2                        ; 03864  0xF6, 0x44, 0x04, 0x02
  jne loc_0387B                                ; 03868  0x75, 0x11
  call cio_conoutf                               ; 0386A  0xE8, 0x07, 0x01
  mov bx, [0x68]                               ; 0386D  0x8B, 0x1E, 0x68, 0x00
  test word [bx + 0x22], 4                     ; 03871  0xF7, 0x47, 0x22, 0x04, 0x00
  jne loc_0387B                                ; 03876  0x75, 0x03
  call cio_chk_cmode                               ; 03878  0xE8, 0x29, 0x00

loc_0387B:  ; 0387B
  mov al, [si + 6]                             ; 0387B  0x8A, 0x44, 0x06
  cmp dl, 0x7f                                 ; 0387E  0x80, 0xFA, 0x7F
  je loc_038A0                                 ; 03881  0x74, 0x1D
  inc al                                       ; 03883  0xFE, 0xC0
  cmp dl, 0x20                                 ; 03885  0x80, 0xFA, 0x20
  jae loc_038A0                                ; 03888  0x73, 0x16
  dec al                                       ; 0388A  0xFE, 0xC8
  db 0x0A, 0xC0                               ; 0388C  or al, al
  je loc_038A0                                 ; 0388E  0x74, 0x10
  cmp dl, 8                                    ; 03890  0x80, 0xFA, 0x08
  jne loc_03899                                ; 03893  0x75, 0x04
  dec al                                       ; 03895  0xFE, 0xC8
  jmp short loc_038A0                          ; 03897  0xEB, 0x07

loc_03899:  ; 03899
  cmp dl, 0xd                                  ; 03899  0x80, 0xFA, 0x0D
  jne loc_038A0                                ; 0389C  0x75, 0x02
  mov al, 0                                    ; 0389E  0xB0, 0x00

loc_038A0:  ; 038A0
  mov [si + 6], al                             ; 038A0  0x88, 0x44, 0x06
  ret                                          ; 038A3  0xC3

cio_chk_cmode:  ; 038A4
  mov ax, [si + 0xe]                           ; 038A4  0x8B, 0x44, 0x0E
  test ax, 0x200                               ; 038A7  0xA9, 0x00, 0x02
  je loc_038CD                                 ; 038AA  0x74, 0x21
  test ax, 0x100                               ; 038AC  0xA9, 0x00, 0x01
  jne loc_038CD                                ; 038AF  0x75, 0x1C
  mov al, [si + 4]                             ; 038B1  0x8A, 0x44, 0x04
  test al, 0x20                                ; 038B4  0xA8, 0x20
  je loc_038BE                                 ; 038B6  0x74, 0x06
  and byte [si + 4], 0xdf                      ; 038B8  0x80, 0x64, 0x04, 0xDF
  jmp short loc_038CD                          ; 038BC  0xEB, 0x0F

loc_038BE:  ; 038BE
  push dx                                      ; 038BE  0x52
  push si                                      ; 038BF  0x56
  mov dh, [si + 8]                             ; 038C0  0x8A, 0x74, 0x08
  cmp dh, 0xff                                 ; 038C3  0x80, 0xFE, 0xFF
  je loc_038CB                                 ; 038C6  0x74, 0x03
  call cio_listf                               ; 038C8  0xE8, 0x71, 0x01

loc_038CB:  ; 038CB
  pop si                                       ; 038CB  0x5E
  pop dx                                       ; 038CC  0x5A

loc_038CD:  ; 038CD
  ret                                          ; 038CD  0xC3

cio_ctlout:  ; 038CE
  call cio_chk_ctrlp                               ; 038CE  0xE8, 0x5D, 0xFF
  jae cio_tabout                                ; 038D1  0x73, 0x0A
  push dx                                      ; 038D3  0x52
  mov dl, 0x5e                                 ; 038D4  0xB2, 0x5E
  call cio_conout                               ; 038D6  0xE8, 0x8B, 0xFF
  pop dx                                       ; 038D9  0x5A
  or dl, 0x40                                  ; 038DA  0x80, 0xCA, 0x40

cio_tabout:  ; 038DD
  cmp dl, 9                                    ; 038DD  0x80, 0xFA, 0x09
  je loc_038E5                                 ; 038E0  0x74, 0x03
  jmp near cio_conout                           ; 038E2  0xE9, 0x7F, 0xFF

loc_038E5:  ; 038E5
  mov dl, 0x20                                 ; 038E5  0xB2, 0x20

loc_038E7:  ; 038E7
  call cio_conout                               ; 038E7  0xE8, 0x7A, 0xFF
  mov al, [si + 6]                             ; 038EA  0x8A, 0x44, 0x06
  and al, 7                                    ; 038ED  0x24, 0x07
  jne loc_038E7                                ; 038EF  0x75, 0xF6
  mov dl, 9                                    ; 038F1  0xB2, 0x09
  ret                                          ; 038F3  0xC3

cio_crlf:  ; 038F4
  push dx                                      ; 038F4  0x52
  mov dl, 0xd                                  ; 038F5  0xB2, 0x0D
  call cio_conout                               ; 038F7  0xE8, 0x6A, 0xFF
  mov dl, 0xa                                  ; 038FA  0xB2, 0x0A
  call cio_conout                               ; 038FC  0xE8, 0x65, 0xFF
  pop dx                                       ; 038FF  0x5A
  ret                                          ; 03900  0xC3

cio_prcsmsg:  ; 03901
  mov dl, 0x23                                 ; 03901  0xB2, 0x23
  call cio_conout                               ; 03903  0xE8, 0x5E, 0xFF
  call cio_crlf                               ; 03906  0xE8, 0xEB, 0xFF
  mov dl, 0x20                                 ; 03909  0xB2, 0x20

loc_0390B:  ; 0390B
  mov al, [si + 6]                             ; 0390B  0x8A, 0x44, 0x06
  cmp al, [si + 5]                             ; 0390E  0x3A, 0x44, 0x05
  jae loc_03918                                ; 03911  0x73, 0x05
  call cio_conout                               ; 03913  0xE8, 0x4E, 0xFF
  jmp short loc_0390B                          ; 03916  0xEB, 0xF3

loc_03918:  ; 03918
  ret                                          ; 03918  0xC3

cio_constf:  ; 03919
  cmp dh, [0x47]                               ; 03919  0x3A, 0x36, 0x47, 0x00
  jb loc_03924                                 ; 0391D  0x72, 0x05
  mov al, 0                                    ; 0391F  0xB0, 0x00
  jmp near cio_goxios                           ; 03921  0xE9, 0x1B, 0x01

loc_03924:  ; 03924
  db 0x33, 0xDB                               ; 03924  xor bx, bx
  cmp [si + 0x2a], bx                          ; 03926  0x39, 0x5C, 0x2A
  jne loc_03933                                ; 03929  0x75, 0x08
  mov di, [si + 0x12]                          ; 0392B  0x8B, 0x7C, 0x12
  cmp [di + 0x16], bx                          ; 0392E  0x39, 0x5D, 0x16
  je loc_03935                                 ; 03931  0x74, 0x02

loc_03933:  ; 03933
  mov bl, 0xff                                 ; 03933  0xB3, 0xFF

loc_03935:  ; 03935
  db 0x8A, 0xC3                               ; 03935  mov al, bl
  ret                                          ; 03937  0xC3

cio_coninf:  ; 03938
  cmp dh, [0x47]                               ; 03938  0x3A, 0x36, 0x47, 0x00
  jb loc_03946                                 ; 0393C  0x72, 0x08
  mov dl, [si + 0xa]                           ; 0393E  0x8A, 0x54, 0x0A
  mov al, 1                                    ; 03941  0xB0, 0x01
  jmp near cio_goxios                           ; 03943  0xE9, 0xF9, 0x00

loc_03946:  ; 03946
  cmp word [si + 0x2a], 0                      ; 03946  0x83, 0x7C, 0x2A, 0x00
  jne loc_03952                                ; 0394A  0x75, 0x06
  mov cx, 0x89                                 ; 0394C  0xB9, 0x89, 0x00
  call cio_conout_sleep                               ; 0394F  0xE8, 0x0B, 0x00

loc_03952:  ; 03952
  mov bx, [si + 0x2a]                          ; 03952  0x8B, 0x5C, 0x2A
  db 0x8B, 0xC3                               ; 03955  mov ax, bx
  mov word [si + 0x2a], 0                      ; 03957  0xC7, 0x44, 0x2A, 0x00, 0x00
  ret                                          ; 0395C  0xC3

cio_conout_sleep:  ; 0395D
  push dx                                      ; 0395D  0x52
  push si                                      ; 0395E  0x56
  mov ax, [si + 0x12]                          ; 0395F  0x8B, 0x44, 0x12
  mov [si + 0x1A], ax                          ; 03962  0x89, 0x44, 0x1A
  lea ax, [si + 0x2a]                          ; 03965  0x8D, 0x44, 0x2A
  mov [si + 0x1E], ax                          ; 03968  0x89, 0x44, 0x1E
  lea dx, [si + 0x18]                          ; 0396B  0x8D, 0x54, 0x18
  call cio_xios_far_call                               ; 0396E  0xE8, 0xFF, 0xF8
  pop si                                       ; 03971  0x5E
  pop dx                                       ; 03972  0x5A
  ret                                          ; 03973  0xC3

cio_conoutf:  ; 03974
  cmp dh, [0x47]                               ; 03974  0x3A, 0x36, 0x47, 0x00
  jb loc_0397F                                 ; 03978  0x72, 0x05
  mov al, 2                                    ; 0397A  0xB0, 0x02
  jmp near cio_goxios                           ; 0397C  0xE9, 0xC0, 0x00

loc_0397F:  ; 0397F
  pushf                                        ; 0397F  0x9C
  cli                                          ; 03980  0xFA
  mov ax, [si + 0xe]                           ; 03981  0x8B, 0x44, 0x0E
  db 0x8B, 0xD8                               ; 03984  mov bx, ax
  and ax, 0xfce7                               ; 03986  0x25, 0xE7, 0xFC
  cmp ax, strict word 2                       ; 03989  3D 02 00
  jbe loc_039CD                                ; 0398C  0x76, 0x3F
  cmp ax, strict word 3                       ; 0398E  3D 03 00
  je loc_039A5                                 ; 03991  0x74, 0x12
  push dx                                      ; 03993  0x52
  push si                                      ; 03994  0x56
  lea dx, [si + 0x24]                          ; 03995  0x8D, 0x54, 0x24
  mov bl, 9                                    ; 03998  0xB3, 0x09
  mov cx, 0x212                                ; 0399A  0xB9, 0x12, 0x02
  call cio_xios_far_call                               ; 0399D  0xE8, 0xD0, 0xF8
  pop si                                       ; 039A0  0x5E
  pop dx                                       ; 039A1  0x5A
  popf                                         ; 039A2  0x9D
  jmp short loc_0397F                          ; 039A3  0xEB, 0xDA

loc_039A5:  ; 039A5
  popf                                         ; 039A5  0x9D
  or byte [si + 4], 0x30                       ; 039A6  0x80, 0x4C, 0x04, 0x30
  mov ax, [si + 0x14]                          ; 039AA  0x8B, 0x44, 0x14
  mov [si + 0x1A], ax                          ; 039AD  0x89, 0x44, 0x1A
  lea ax, [si + 0x20]                          ; 039B0  0x8D, 0x44, 0x20
  mov [si + 0x1E], ax                          ; 039B3  0x89, 0x44, 0x1E
  push dx                                      ; 039B6  0x52
  push si                                      ; 039B7  0x56
  db 0x32, 0xF6                               ; 039B8  xor dh, dh
  mov [si + 0x20], dx                          ; 039BA  0x89, 0x54, 0x20
  lea dx, [si + 0x18]                          ; 039BD  0x8D, 0x54, 0x18
  mov cx, 0x8b                                 ; 039C0  0xB9, 0x8B, 0x00
  call cio_xios_far_call                               ; 039C3  0xE8, 0xAA, 0xF8
  pop si                                       ; 039C6  0x5E
  pop dx                                       ; 039C7  0x5A
  and byte [si + 4], 0xef                      ; 039C8  0x80, 0x64, 0x04, 0xEF
  ret                                          ; 039CC  0xC3

loc_039CD:  ; 039CD
  test bx, 0x100                               ; 039CD  0xF7, 0xC3, 0x00, 0x01
  je loc_039D5                                 ; 039D1  0x74, 0x02
  popf                                         ; 039D3  0x9D
  ret                                          ; 039D4  0xC3

loc_039D5:  ; 039D5
  test byte [si + 4], 8                        ; 039D5  0xF6, 0x44, 0x04, 0x08
  je loc_039EE                                 ; 039D9  0x74, 0x13
  push dx                                      ; 039DB  0x52
  push si                                      ; 039DC  0x56
  lea dx, [si + 0x22]                          ; 039DD  0x8D, 0x54, 0x22
  mov bl, 9                                    ; 039E0  0xB3, 0x09
  mov cx, 0x212                                ; 039E2  0xB9, 0x12, 0x02
  call cio_xios_far_call                               ; 039E5  0xE8, 0x88, 0xF8
  pop si                                       ; 039E8  0x5E
  pop dx                                       ; 039E9  0x5A
  popf                                         ; 039EA  0x9D
  jmp near loc_0397F                           ; 039EB  0xE9, 0x91, 0xFF

loc_039EE:  ; 039EE
  or byte [si + 4], 8                          ; 039EE  0x80, 0x4C, 0x04, 0x08
  popf                                         ; 039F2  0x9D
  mov bx, [0x68]                               ; 039F3  0x8B, 0x1E, 0x68, 0x00
  push word [bx + 6]                           ; 039F7  0xFF, 0x77, 0x06
  or word [bx + 6], 0x200                      ; 039FA  0x81, 0x4F, 0x06, 0x00, 0x02
  push bx                                      ; 039FF  0x53
  mov ax, 2                                    ; 03A00  0xB8, 0x02, 0x00
  call cio_goxios                               ; 03A03  0xE8, 0x39, 0x00
  and byte [si + 4], 0xf7                      ; 03A06  0x80, 0x64, 0x04, 0xF7
  cmp word [si + 0x22], 0                      ; 03A0A  0x83, 0x7C, 0x22, 0x00
  je loc_03A1F                                 ; 03A0E  0x74, 0x0F
  push dx                                      ; 03A10  0x52
  push si                                      ; 03A11  0x56
  mov cx, 0x213                                ; 03A12  0xB9, 0x13, 0x02
  mov bl, 9                                    ; 03A15  0xB3, 0x09
  lea dx, [si + 0x22]                          ; 03A17  0x8D, 0x54, 0x22
  call cio_xios_far_call                               ; 03A1A  0xE8, 0x53, 0xF8
  pop si                                       ; 03A1D  0x5E
  pop dx                                       ; 03A1E  0x5A

loc_03A1F:  ; 03A1F
  pop bx                                       ; 03A1F  0x5B
  test word [bx + 6], 0x80                     ; 03A20  0xF7, 0x47, 0x06, 0x80, 0x00
  pop word [bx + 6]                            ; 03A25  0x8F, 0x47, 0x06
  je loc_03A3B                                 ; 03A28  0x74, 0x11
  or word [bx + 6], 0x80                       ; 03A2A  0x81, 0x4F, 0x06, 0x80, 0x00
  push dx                                      ; 03A2F  0x52
  push si                                      ; 03A30  0x56
  db 0x33, 0xD2                               ; 03A31  xor dx, dx
  mov cx, 0x8f                                 ; 03A33  0xB9, 0x8F, 0x00
  call cio_xios_far_call                               ; 03A36  0xE8, 0x37, 0xF8
  pop si                                       ; 03A39  0x5E
  pop dx                                       ; 03A3A  0x5A

loc_03A3B:  ; 03A3B
  ret                                          ; 03A3B  0xC3

cio_listf:  ; 03A3C
  mov ax, 4                                    ; 03A3C  0xB8, 0x04, 0x00

cio_goxios:  ; 03A3F
  push dx                                      ; 03A3F  0x52
  push si                                      ; 03A40  0x56
  db 0x8A, 0xCA                               ; 03A41  mov cl, dl
  db 0x8A, 0xD6                               ; 03A43  mov dl, dh
  call cio_xios_call                               ; 03A45  0xE8, 0x2E, 0xF8
  pop si                                       ; 03A48  0x5E
  pop dx                                       ; 03A49  0x5A
  ret                                          ; 03A4A  0xC3
  nop                                          ; 03A4B  0x90
  nop                                          ; 03A4C  0x90
  nop                                          ; 03A4D  0x90
  nop                                          ; 03A4E  0x90
  nop                                          ; 03A4F  0x90
  nop                                          ; 03A50  0x90
  nop                                          ; 03A51  0x90
  nop                                          ; 03A52  0x90
  nop                                          ; 03A53  0x90
  nop                                          ; 03A54  0x90
  nop                                          ; 03A55  0x90
  nop                                          ; 03A56  0x90
  nop                                          ; 03A57  0x90
  nop                                          ; 03A58  0x90
  nop                                          ; 03A59  0x90
  nop                                          ; 03A5A  0x90
  nop                                          ; 03A5B  0x90
  nop                                          ; 03A5C  0x90
  nop                                          ; 03A5D  0x90
  nop                                          ; 03A5E  0x90
  nop                                          ; 03A5F  0x90
  nop                                          ; 03A60  0x90
  nop                                          ; 03A61  0x90
  nop                                          ; 03A62  0x90
  nop                                          ; 03A63  0x90
  nop                                          ; 03A64  0x90
  nop                                          ; 03A65  0x90
  nop                                          ; 03A66  0x90
  nop                                          ; 03A67  0x90
  nop                                          ; 03A68  0x90
  nop                                          ; 03A69  0x90
  nop                                          ; 03A6A  0x90
  nop                                          ; 03A6B  0x90
  nop                                          ; 03A6C  0x90
  nop                                          ; 03A6D  0x90
  nop                                          ; 03A6E  0x90
  nop                                          ; 03A6F  0x90
  nop                                          ; 03A70  0x90
  nop                                          ; 03A71  0x90
  nop                                          ; 03A72  0x90
  nop                                          ; 03A73  0x90
  nop                                          ; 03A74  0x90
  nop                                          ; 03A75  0x90
  nop                                          ; 03A76  0x90
  nop                                          ; 03A77  0x90
  nop                                          ; 03A78  0x90
  nop                                          ; 03A79  0x90
  nop                                          ; 03A7A  0x90
  nop                                          ; 03A7B  0x90
  nop                                          ; 03A7C  0x90
  nop                                          ; 03A7D  0x90
  nop                                          ; 03A7E  0x90
  nop                                          ; 03A7F  0x90
  nop                                          ; 03A80  0x90
  nop                                          ; 03A81  0x90
  nop                                          ; 03A82  0x90
  nop                                          ; 03A83  0x90
  nop                                          ; 03A84  0x90
  nop                                          ; 03A85  0x90
  nop                                          ; 03A86  0x90
  nop                                          ; 03A87  0x90
  nop                                          ; 03A88  0x90
  nop                                          ; 03A89  0x90
  nop                                          ; 03A8A  0x90
  nop                                          ; 03A8B  0x90
  nop                                          ; 03A8C  0x90
  nop                                          ; 03A8D  0x90
  nop                                          ; 03A8E  0x90
  nop                                          ; 03A8F  0x90
  nop                                          ; 03A90  0x90
  nop                                          ; 03A91  0x90
  nop                                          ; 03A92  0x90
  nop                                          ; 03A93  0x90
  nop                                          ; 03A94  0x90
  nop                                          ; 03A95  0x90
  nop                                          ; 03A96  0x90
  nop                                          ; 03A97  0x90
  nop                                          ; 03A98  0x90
  nop                                          ; 03A99  0x90
  nop                                          ; 03A9A  0x90
  nop                                          ; 03A9B  0x90
  nop                                          ; 03A9C  0x90
  nop                                          ; 03A9D  0x90
  nop                                          ; 03A9E  0x90
  nop                                          ; 03A9F  0x90
  nop                                          ; 03AA0  0x90
  nop                                          ; 03AA1  0x90
  nop                                          ; 03AA2  0x90
  nop                                          ; 03AA3  0x90
  nop                                          ; 03AA4  0x90
  nop                                          ; 03AA5  0x90
  nop                                          ; 03AA6  0x90
  nop                                          ; 03AA7  0x90
  nop                                          ; 03AA8  0x90
  nop                                          ; 03AA9  0x90
  nop                                          ; 03AAA  0x90
  nop                                          ; 03AAB  0x90
  nop                                          ; 03AAC  0x90
  nop                                          ; 03AAD  0x90
  nop                                          ; 03AAE  0x90
  nop                                          ; 03AAF  0x90
  nop                                          ; 03AB0  0x90
  nop                                          ; 03AB1  0x90
  nop                                          ; 03AB2  0x90
  nop                                          ; 03AB3  0x90
  nop                                          ; 03AB4  0x90
  nop                                          ; 03AB5  0x90
  nop                                          ; 03AB6  0x90
  nop                                          ; 03AB7  0x90
  nop                                          ; 03AB8  0x90
  nop                                          ; 03AB9  0x90
  nop                                          ; 03ABA  0x90
  nop                                          ; 03ABB  0x90
  nop                                          ; 03ABC  0x90
  nop                                          ; 03ABD  0x90
  nop                                          ; 03ABE  0x90
  nop                                          ; 03ABF  0x90
  nop                                          ; 03AC0  0x90
  nop                                          ; 03AC1  0x90
  nop                                          ; 03AC2  0x90
  nop                                          ; 03AC3  0x90
  nop                                          ; 03AC4  0x90
  nop                                          ; 03AC5  0x90
  nop                                          ; 03AC6  0x90
  nop                                          ; 03AC7  0x90
  nop                                          ; 03AC8  0x90
  nop                                          ; 03AC9  0x90
  nop                                          ; 03ACA  0x90
  db 0x00, 0x00                               ; 03ACB
  db 0x00, 0x00                               ; 03ACD
  db 0x00                                     ; 03ACF
