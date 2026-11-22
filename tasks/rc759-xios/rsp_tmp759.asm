; ===========================================================================
; RSP 1: TMP759 — Terminal Message Processor (Piccoline CLI / kommandofortolker)
; Offset range: 0x0FD40 - 0x1156F (6.192 bytes)
; ===========================================================================
  mov cl, 0x2d                                 ; 0FD40  0xB1, 0x2D
  mov dl, 0xff                                 ; 0FD42  0xB2, 0xFF

loc_0FD44:                                     ; 0FD44
  call sub_10C23                               ; 0FD44  0xE8, 0xDC, 0x0E
  mov dl, [4]                                  ; 0FD47  0x8A, 0x16, 0x04, 0x00
  call sub_10BDE                               ; 0FD4B  0xE8, 0x90, 0x0E
  call sub_10BF9                               ; 0FD4E  0xE8, 0xA8, 0x0E
  push ds                                      ; 0FD51  0x1E
  mov ds, [0]                                  ; 0FD52  0x8E, 0x1E, 0x00, 0x00
  mov dx, [0x78]                               ; 0FD56  0x8B, 0x16, 0x78, 0x00
  mov ds, [0x40]                               ; 0FD5A  0x8E, 0x1E, 0x40, 0x00
  call sub_10BB0                               ; 0FD5E  0xE8, 0x4F, 0x0E
  pop ds                                       ; 0FD61  0x1F
  call sub_10BFD                               ; 0FD62  0xE8, 0x98, 0x0E
  mov dl, 0                                    ; 0FD65  0xB2, 0x00
  mov cl, 0x6e                                 ; 0FD67  0xB1, 0x6E
  call sub_10C23                               ; 0FD69  0xE8, 0xB7, 0x0E
  mov cl, 0x6d                                 ; 0FD6C  0xB1, 0x6D
  mov dx, 4                                    ; 0FD6E  0xBA, 0x04, 0x00
  call sub_10C23                               ; 0FD71  0xE8, 0xAF, 0x0E
  mov al, [0x1b]                               ; 0FD74  0xA0, 0x1B, 0x00
  mov [0x293], al                              ; 0FD77  0xA2, 0x93, 0x02
  mov [0x35d], al                              ; 0FD7A  0xA2, 0x5D, 0x03
  mov [0x3eb], al                              ; 0FD7D  0xA2, 0xEB, 0x03
  mov ax, 4                                    ; 0FD80  0xB8, 0x04, 0x00
  int 0x28                                     ; 0FD83  0xCD, 0x28
  cmp byte [es:si + 0xd], 0xff                 ; 0FD85  0x26, 0x80, 0x7C, 0x0D, 0xFF
  mov ax, 3                                    ; 0FD8A  0xB8, 0x03, 0x00
  int 0x28                                     ; 0FD8D  0xCD, 0x28
  mov al, [es:si + 0x1e]                       ; 0FD8F  0x26, 0x8A, 0x44, 0x1E
  mov [0x413], al                              ; 0FD93  0xA2, 0x13, 0x04
  je loc_0FD9D                                 ; 0FD96  0x74, 0x05
  mov byte [0x413], 0xff                       ; 0FD98  0xC6, 0x06, 0x13, 0x04, 0xFF

loc_0FD9D:                                     ; 0FD9D
  mov al, [es:si + 0x1d]                       ; 0FD9D  0x26, 0x8A, 0x44, 0x1D
  mov [0x41e], al                              ; 0FDA1  0xA2, 0x1E, 0x04
  mov cl, [0x1b]                               ; 0FDA4  0x8A, 0x0E, 0x1B, 0x00
  sub cl, 0x30                                 ; 0FDA8  0x80, 0xE9, 0x30
  mov al, 1                                    ; 0FDAB  0xB0, 0x01
  shl al, cl                                   ; 0FDAD  0xD2, 0xE0
  test [es:si + 0x1f], al                      ; 0FDAF  0x26, 0x84, 0x44, 0x1F
  je loc_0FDED                                 ; 0FDB3  0x74, 0x38
  call sub_10560                               ; 0FDB5  0xE8, 0xA8, 0x07
  jb loc_0FDC2                                 ; 0FDB8  0x72, 0x08
  mov dx, 0x12a4                               ; 0FDBA  0xBA, 0xA4, 0x12
  call sub_10BA6                               ; 0FDBD  0xE8, 0xE6, 0x0D
  jmp short loc_0FDED                          ; 0FDC0  0xEB, 0x2B

loc_0FDC2:                                     ; 0FDC2
  call sub_10A2B                               ; 0FDC2  0xE8, 0x66, 0x0C
  mov al, [0x413]                              ; 0FDC5  0xA0, 0x13, 0x04
  mov [0x2af], al                              ; 0FDC8  0xA2, 0xAF, 0x02
  mov cx, 5                                    ; 0FDCB  0xB9, 0x05, 0x00

loc_0FDCE:                                     ; 0FDCE
  push cx                                      ; 0FDCE  0x51
  mov cl, 0x40                                 ; 0FDCF  0xB1, 0x40
  mov dx, 0x2af                                ; 0FDD1  0xBA, 0xAF, 0x02
  call sub_10C23                               ; 0FDD4  0xE8, 0x4C, 0x0E
  pop cx                                       ; 0FDD7  0x59
  db 0x0A, 0xC0                                ; 0FDD8  or al, al
  je loc_0FDED                                 ; 0FDDA  0x74, 0x11
  push cx                                      ; 0FDDC  0x51
  mov cl, 0x8d                                 ; 0FDDD  0xB1, 0x8D
  mov dx, 0xa                                  ; 0FDDF  0xBA, 0x0A, 0x00
  int 0xe0                                     ; 0FDE2  0xCD, 0xE0
  pop cx                                       ; 0FDE4  0x59
  loop loc_0FDCE                               ; 0FDE5  0xE2, 0xE7
  mov dx, 0x1376                               ; 0FDE7  0xBA, 0x76, 0x13
  call sub_10BA6                               ; 0FDEA  0xE8, 0xB9, 0x0D

loc_0FDED:                                     ; 0FDED
  push ds                                      ; 0FDED  0x1E
  mov ds, [0]                                  ; 0FDEE  0x8E, 0x1E, 0x00, 0x00
  mov dl, [0x4b]                               ; 0FDF2  0x8A, 0x16, 0x4B, 0x00
  pop ds                                       ; 0FDF6  0x1F
  call sub_10BE8                               ; 0FDF7  0xE8, 0xEE, 0x0D
  call sub_10BA3                               ; 0FDFA  0xE8, 0xA6, 0x0D
  cmp byte [0x412], 0xff                       ; 0FDFD  0x80, 0x3E, 0x12, 0x04, 0xFF
  jne loc_0FE11                                ; 0FE02  0x75, 0x0D
  call sub_10BED                               ; 0FE04  0xE8, 0xE6, 0x0D
  call sub_1035D                               ; 0FE07  0xE8, 0x53, 0x05
  jae loc_0FE11                                ; 0FE0A  0x73, 0x05
  jne loc_0FE11                                ; 0FE0C  0x75, 0x03
  call sub_10BA3                               ; 0FE0E  0xE8, 0x92, 0x0D

loc_0FE11:                                     ; 0FE11
  db 0x32, 0xD2                                ; 0FE11  xor dl, dl
  call sub_10B9E                               ; 0FE13  0xE8, 0x88, 0x0D
  mov cl, 0x86                                 ; 0FE16  0xB1, 0x86
  mov dx, 0x354                                ; 0FE18  0xBA, 0x54, 0x03
  int 0xe0                                     ; 0FE1B  0xCD, 0xE0
  db 0x0B, 0xC0                                ; 0FE1D  or ax, ax
  je loc_0FE29                                 ; 0FE1F  0x74, 0x08
  mov dx, 0x147c                               ; 0FE21  0xBA, 0x7C, 0x14
  call sub_10BA6                               ; 0FE24  0xE8, 0x7F, 0x0D
  jmp short loc_0FE3A                          ; 0FE27  0xEB, 0x11

loc_0FE29:                                     ; 0FE29
  mov cl, 0x87                                 ; 0FE29  0xB1, 0x87
  mov dx, 0x3e0                                ; 0FE2B  0xBA, 0xE0, 0x03
  int 0xe0                                     ; 0FE2E  0xCD, 0xE0
  db 0x0B, 0xC0                                ; 0FE30  or ax, ax
  je loc_0FE3A                                 ; 0FE32  0x74, 0x06
  mov dx, 0x149a                               ; 0FE34  0xBA, 0x9A, 0x14
  call sub_10BA6                               ; 0FE37  0xE8, 0x6C, 0x0D

loc_0FE3A:                                     ; 0FE3A
  call sub_10C16                               ; 0FE3A  0xE8, 0xD9, 0x0D
  mov dx, 0x14a                                ; 0FE3D  0xBA, 0x4A, 0x01
  mov cl, 0x1a                                 ; 0FE40  0xB1, 0x1A
  call sub_10C23                               ; 0FE42  0xE8, 0xDE, 0x0D
  mov bx, 0x266                                ; 0FE45  0xBB, 0x66, 0x02
  or byte [bx + 5], 0x80                       ; 0FE48  0x80, 0x4F, 0x05, 0x80
  db 0x8B, 0xD3                                ; 0FE4C  mov dx, bx
  mov cl, 0xf                                  ; 0FE4E  0xB1, 0x0F
  call sub_10C23                               ; 0FE50  0xE8, 0xD0, 0x0D
  cmp al, 0xff                                 ; 0FE53  0x3C, 0xFF
  je loc_0FE7F                                 ; 0FE55  0x74, 0x28

loc_0FE57:                                     ; 0FE57
  mov dx, 0x266                                ; 0FE57  0xBA, 0x66, 0x02
  mov cl, 0x14                                 ; 0FE5A  0xB1, 0x14
  call sub_10C23                               ; 0FE5C  0xE8, 0xC4, 0x0D
  test al, al                                  ; 0FE5F  0x84, 0xC0
  jne loc_0FE71                                ; 0FE61  0x75, 0x0E
  mov [0x262], ds                              ; 0FE63  0x8C, 0x1E, 0x62, 0x02
  mov dx, PORT_PRN_CTRL                        ; 0FE67  0xBA, 0x60, 0x02
  mov cl, 0x6f                                 ; 0FE6A  0xB1, 0x6F
  call sub_10C23                               ; 0FE6C  0xE8, 0xB4, 0x0D
  jmp short loc_0FE57                          ; 0FE6F  0xEB, 0xE6

loc_0FE71:                                     ; 0FE71
  mov dx, 0x15f0                               ; 0FE71  0xBA, 0xF0, 0x15
  call sub_10BB7                               ; 0FE74  0xE8, 0x40, 0x0D
  mov dx, 0x266                                ; 0FE77  0xBA, 0x66, 0x02
  mov cl, 0x10                                 ; 0FE7A  0xB1, 0x10
  call sub_10C23                               ; 0FE7C  0xE8, 0xA4, 0x0D

loc_0FE7F:                                     ; 0FE7F
  call sub_10AE2                               ; 0FE7F  0xE8, 0x60, 0x0C
  push bx                                      ; 0FE82  0x53
  mov bx, 0x28a                                ; 0FE83  0xBB, 0x8A, 0x02
  or byte [bx + 5], 0x80                       ; 0FE86  0x80, 0x4F, 0x05, 0x80
  db 0x8B, 0xD3                                ; 0FE8A  mov dx, bx
  pop bx                                       ; 0FE8C  0x5B
  mov cl, 0xf                                  ; 0FE8D  0xB1, 0x0F
  call sub_10C23                               ; 0FE8F  0xE8, 0x91, 0x0D
  cmp al, 0xff                                 ; 0FE92  0x3C, 0xFF
  je loc_0FED9                                 ; 0FE94  0x74, 0x43
  mov dx, PORT_DPC_PRN_DATA                    ; 0FE96  0xBA, 0x8A, 0x02
  mov cl, 0x14                                 ; 0FE99  0xB1, 0x14
  call sub_10C23                               ; 0FE9B  0xE8, 0x85, 0x0D
  push ax                                      ; 0FE9E  0x50
  mov dx, PORT_DPC_PRN_DATA                    ; 0FE9F  0xBA, 0x8A, 0x02
  mov cl, 0x10                                 ; 0FEA2  0xB1, 0x10
  call sub_10C23                               ; 0FEA4  0xE8, 0x7C, 0x0D
  pop ax                                       ; 0FEA7  0x58
  test al, al                                  ; 0FEA8  0x84, 0xC0
  jne loc_0FED9                                ; 0FEAA  0x75, 0x2D
  mov ax, ds                                   ; 0FEAC  0x8C, 0xD8
  mov es, ax                                   ; 0FEAE  0x8E, 0xC0
  mov al, 0xd                                  ; 0FEB0  0xB0, 0x0D
  mov cx, 0x80                                 ; 0FEB2  0xB9, 0x80, 0x00
  mov di, 0x14a                                ; 0FEB5  0xBF, 0x4A, 0x01
  repne scasb                                  ; 0FEB8  0xF2, 0xAE
  jne loc_0FED9                                ; 0FEBA  0x75, 0x1D
  mov byte [di], 0xa                           ; 0FEBC  0xC6, 0x05, 0x0A
  mov byte [di + 1], 0                         ; 0FEBF  0xC6, 0x45, 0x01, 0x00
  sub di, 0x14a                                ; 0FEC3  0x81, 0xEF, 0x4A, 0x01
  db 0x8B, 0xC7                                ; 0FEC7  mov ax, di
  dec ax                                       ; 0FEC9  0x48
  mov [0x149], al                              ; 0FECA  0xA2, 0x49, 0x01
  mov dx, 0x16d0                               ; 0FECD  0xBA, 0xD0, 0x16
  call sub_10BA6                               ; 0FED0  0xE8, 0xD3, 0x0C
  mov dx, 0x14a                                ; 0FED3  0xBA, 0x4A, 0x01
  call sub_10BB0                               ; 0FED6  0xE8, 0xD7, 0x0C

loc_0FED9:                                     ; 0FED9
  call sub_10BF9                               ; 0FED9  0xE8, 0x1D, 0x0D

loc_0FEDC:                                     ; 0FEDC
  mov dx, 0x15e7                               ; 0FEDC  0xBA, 0xE7, 0x15
  call sub_10BB7                               ; 0FEDF  0xE8, 0xD5, 0x0C
  mov al, 1                                    ; 0FEE2  0xB0, 0x01
  int 0x28                                     ; 0FEE4  0xCD, 0x28
  mov di, 0x1d6                                ; 0FEE6  0xBF, 0xD6, 0x01
  push di                                      ; 0FEE9  0x57
  push ds                                      ; 0FEEA  0x1E
  pop es                                       ; 0FEEB  0x07
  mov cx, 0x40                                 ; 0FEEC  0xB9, 0x40, 0x00
  mov ax, 0                                    ; 0FEEF  0xB8, 0x00, 0x00
  cld                                          ; 0FEF2  0xFC
  rep stosw                                    ; 0FEF3  0xF3, 0xAB
  pop di                                       ; 0FEF5  0x5F
  mov bx, 0x14a                                ; 0FEF6  0xBB, 0x4A, 0x01
  mov si, [0x1d0]                              ; 0FEF9  0x8B, 0x36, 0xD0, 0x01
  mov dl, [0x149]                              ; 0FEFD  0x8A, 0x16, 0x49, 0x01
  db 0x32, 0xF6                                ; 0FF01  xor dh, dh
  db 0x33, 0xC9                                ; 0FF03  xor cx, cx
  db 0x3B, 0xD6                                ; 0FF05  cmp dx, si
  jne loc_0FF13                                ; 0FF07  0x75, 0x0A
  mov byte [0x1d3], 0                          ; 0FF09  0xC6, 0x06, 0xD3, 0x01, 0x00
  call sub_10C26                               ; 0FF0E  0xE8, 0x15, 0x0D
  jmp short loc_0FEDC                          ; 0FF11  0xEB, 0xC9

loc_0FF13:                                     ; 0FF13
  db 0x3B, 0xD6                                ; 0FF13  cmp dx, si
  je loc_0FF3A                                 ; 0FF15  0x74, 0x23
  mov al, [bx + si]                            ; 0FF17  0x8A, 0x00
  inc si                                       ; 0FF19  0x46
  inc word [0x1d0]                             ; 0FF1A  0xFF, 0x06, 0xD0, 0x01
  cmp al, 0x2f                                 ; 0FF1E  0x3C, 0x2F
  jne loc_0FF36                                ; 0FF20  0x75, 0x14
  db 0x3B, 0xD6                                ; 0FF22  cmp dx, si
  je loc_0FF36                                 ; 0FF24  0x74, 0x10
  cmp byte [bx + si], 0x2f                     ; 0FF26  0x80, 0x38, 0x2F
  jne loc_0FF36                                ; 0FF29  0x75, 0x0B
  mov byte [0x1d3], 0xff                       ; 0FF2B  0xC6, 0x06, 0xD3, 0x01, 0xFF
  inc word [0x1d0]                             ; 0FF30  0xFF, 0x06, 0xD0, 0x01
  jmp short loc_0FF3A                          ; 0FF34  0xEB, 0x04

loc_0FF36:                                     ; 0FF36
  inc cx                                       ; 0FF36  0x41
  stosb                                        ; 0FF37  0xAA
  jmp short loc_0FF13                          ; 0FF38  0xEB, 0xD9

loc_0FF3A:                                     ; 0FF3A
  mov [0x1d5], cl                              ; 0FF3A  0x88, 0x0E, 0xD5, 0x01
  cmp byte [0x259], 0                          ; 0FF3E  0x80, 0x3E, 0x59, 0x02, 0x00
  je loc_0FF4D                                 ; 0FF43  0x74, 0x08
  mov byte [0x259], 0                          ; 0FF45  0xC6, 0x06, 0x59, 0x02, 0x00
  call sub_10BA3                               ; 0FF4A  0xE8, 0x56, 0x0C

loc_0FF4D:                                     ; 0FF4D
  lea bx, [0x1d6]                              ; 0FF4D  0x8D, 0x1E, 0xD6, 0x01

loc_0FF51:                                     ; 0FF51
  cmp byte [0x1d5], 0                          ; 0FF51  0x80, 0x3E, 0xD5, 0x01, 0x00
  je loc_0FFA9                                 ; 0FF56  0x74, 0x51
  cmp byte [bx], 0x20                          ; 0FF58  0x80, 0x3F, 0x20
  je loc_0FF62                                 ; 0FF5B  0x74, 0x05
  cmp byte [bx], 9                             ; 0FF5D  0x80, 0x3F, 0x09
  jne loc_0FF69                                ; 0FF60  0x75, 0x07

loc_0FF62:                                     ; 0FF62
  inc bx                                       ; 0FF62  0x43
  dec byte [0x1d5]                             ; 0FF63  0xFE, 0x0E, 0xD5, 0x01
  jmp short loc_0FF51                          ; 0FF67  0xEB, 0xE8

loc_0FF69:                                     ; 0FF69
  lea ax, [0x1d6]                              ; 0FF69  0x8D, 0x06, 0xD6, 0x01
  db 0x3B, 0xC3                                ; 0FF6D  cmp ax, bx
  je loc_0FF82                                 ; 0FF6F  0x74, 0x11
  push ds                                      ; 0FF71  0x1E
  pop es                                       ; 0FF72  0x07
  db 0x32, 0xED                                ; 0FF73  xor ch, ch
  mov cl, [0x1d5]                              ; 0FF75  0x8A, 0x0E, 0xD5, 0x01
  db 0x8B, 0xF8                                ; 0FF79  mov di, ax
  db 0x8B, 0xF3                                ; 0FF7B  mov si, bx
  cld                                          ; 0FF7D  0xFC
  rep movsb                                    ; 0FF7E  0xF3, 0xA4
  db 0x8B, 0xD8                                ; 0FF80  mov bx, ax

loc_0FF82:                                     ; 0FF82
  mov al, [0x1d5]                              ; 0FF82  0xA0, 0xD5, 0x01
  db 0x32, 0xE4                                ; 0FF85  xor ah, ah
  db 0x03, 0xC3                                ; 0FF87  add ax, bx
  dec ax                                       ; 0FF89  0x48
  db 0x8B, 0xF8                                ; 0FF8A  mov di, ax

loc_0FF8C:                                     ; 0FF8C
  cmp byte [0x1d5], 0                          ; 0FF8C  0x80, 0x3E, 0xD5, 0x01, 0x00
  je loc_0FFA9                                 ; 0FF91  0x74, 0x16
  cmp byte [di], 0x20                          ; 0FF93  0x80, 0x3D, 0x20
  je loc_0FF9D                                 ; 0FF96  0x74, 0x05
  cmp byte [di], 9                             ; 0FF98  0x80, 0x3D, 0x09
  jne loc_0FFA4                                ; 0FF9B  0x75, 0x07

loc_0FF9D:                                     ; 0FF9D
  dec byte [0x1d5]                             ; 0FF9D  0xFE, 0x0E, 0xD5, 0x01
  dec di                                       ; 0FFA1  0x4F
  jmp short loc_0FF8C                          ; 0FFA2  0xEB, 0xE8

loc_0FFA4:                                     ; 0FFA4
  cmp byte [bx], 0x3b                          ; 0FFA4  0x80, 0x3F, 0x3B
  jne loc_0FFAC                                ; 0FFA7  0x75, 0x03

loc_0FFA9:                                     ; 0FFA9
  jmp near loc_0FED9                           ; 0FFA9  0xE9, 0x2D, 0xFF

loc_0FFAC:                                     ; 0FFAC
  mov bx, 0x1d6                                ; 0FFAC  0xBB, 0xD6, 0x01
  mov al, [0x1d5]                              ; 0FFAF  0xA0, 0xD5, 0x01
  mov ah, 0                                    ; 0FFB2  0xB4, 0x00
  db 0x03, 0xD8                                ; 0FFB4  add bx, ax
  mov byte [bx], 0                             ; 0FFB6  0xC6, 0x07, 0x00
  cmp byte [0x1d2], 1                          ; 0FFB9  0x80, 0x3E, 0xD2, 0x01, 0x01
  je loc_0FFD3                                 ; 0FFBE  0x74, 0x13
  cmp byte [0x1d3], 0xff                       ; 0FFC0  0x80, 0x3E, 0xD3, 0x01, 0xFF
  jne loc_0FFD3                                ; 0FFC5  0x75, 0x0C
  call sub_10D67                               ; 0FFC7  0xE8, 0x9D, 0x0D
  mov dx, 0x1d6                                ; 0FFCA  0xBA, 0xD6, 0x01
  call sub_10BB0                               ; 0FFCD  0xE8, 0xE0, 0x0B
  call sub_10BA3                               ; 0FFD0  0xE8, 0xD0, 0x0B

loc_0FFD3:                                     ; 0FFD3
  lea bx, [0x1d6]                              ; 0FFD3  0x8D, 0x1E, 0xD6, 0x01
  cmp byte [0x1d5], 2                          ; 0FFD7  0x80, 0x3E, 0xD5, 0x01, 0x02
  jne loc_10021                                ; 0FFDC  0x75, 0x43
  cmp byte [bx + 1], 0x3a                      ; 0FFDE  0x80, 0x7F, 0x01, 0x3A
  jne loc_10021                                ; 0FFE2  0x75, 0x3D
  mov dl, [bx]                                 ; 0FFE4  0x8A, 0x17
  and dl, 0x5f                                 ; 0FFE6  0x80, 0xE2, 0x5F
  sub dl, 0x41                                 ; 0FFE9  0x80, 0xEA, 0x41
  js loc_1000F                                 ; 0FFEC  0x78, 0x21
  cmp dl, 0xf                                  ; 0FFEE  0x80, 0xFA, 0x0F
  ja loc_1000F                                 ; 0FFF1  0x77, 0x1C
  call sub_10BE2                               ; 0FFF3  0xE8, 0xEC, 0x0B
  jae loc_1000C                                ; 0FFF6  0x73, 0x14
  cmp byte [0x412], 0xff                       ; 0FFF8  0x80, 0x3E, 0x12, 0x04, 0xFF
  jne loc_1000C                                ; 0FFFD  0x75, 0x0D
  call sub_10BED                               ; 0FFFF  0xE8, 0xEB, 0x0B
  call sub_1035D                               ; 10002  0xE8, 0x58, 0x03
  jae loc_1000C                                ; 10005  0x73, 0x05
  jne loc_1000C                                ; 10007  0x75, 0x03
  call sub_10BA3                               ; 10009  0xE8, 0x97, 0x0B

loc_1000C:                                     ; 1000C
  jmp near loc_1001E                           ; 1000C  0xE9, 0x0F, 0x00

loc_1000F:                                     ; 1000F
  mov dx, 0x10b0                               ; 1000F  0xBA, 0xB0, 0x10
  call sub_10BA6                               ; 10012  0xE8, 0x91, 0x0B
  mov dx, 0x118c                               ; 10015  0xBA, 0x8C, 0x11
  call sub_10BA6                               ; 10018  0xE8, 0x8B, 0x0B
  call sub_10BA3                               ; 1001B  0xE8, 0x85, 0x0B

loc_1001E:                                     ; 1001E
  jmp near loc_0FED9                           ; 1001E  0xE9, 0xB8, 0xFE

loc_10021:                                     ; 10021
  mov cx, 0x40                                 ; 10021  0xB9, 0x40, 0x00
  mov si, 0x1d6                                ; 10024  0xBE, 0xD6, 0x01
  mov di, 0x2d2                                ; 10027  0xBF, 0xD2, 0x02
  push ds                                      ; 1002A  0x1E
  pop es                                       ; 1002B  0x07
  rep movsw                                    ; 1002C  0xF3, 0xA5
  mov si, 0x2af                                ; 1002E  0xBE, 0xAF, 0x02
  mov di, 0x2d2                                ; 10031  0xBF, 0xD2, 0x02
  call sub_10AF6                               ; 10034  0xE8, 0xBF, 0x0A
  mov [0x25a], ax                              ; 10037  0xA3, 0x5A, 0x02
  jcxz loc_1003F                               ; 1003A  0xE3, 0x03
  jmp near loc_1010C                           ; 1003C  0xE9, 0xCD, 0x00

loc_1003F:                                     ; 1003F
  cmp byte [0x2af], 0                          ; 1003F  0x80, 0x3E, 0xAF, 0x02, 0x00
  je loc_10049                                 ; 10044  0x74, 0x03
  jmp near loc_10083                           ; 10046  0xE9, 0x3A, 0x00

loc_10049:                                     ; 10049
  mov ax, cs                                   ; 10049  0x8C, 0xC8
  mov es, ax                                   ; 1004B  0x8E, 0xC0
  db 0x33, 0xDB                                ; 1004D  xor bx, bx
  mov ax, 0xffff                               ; 1004F  0xB8, 0xFF, 0xFF

loc_10052:                                     ; 10052
  inc ax                                       ; 10052  0x40
  cmp byte [cs:bx + 0x15f3], 0                 ; 10053  0x2E, 0x80, 0xBF, 0xF3, 0x15, 0x00
  je loc_10083                                 ; 10059  0x74, 0x28
  mov si, 0x2b0                                ; 1005B  0xBE, 0xB0, 0x02
  lea di, [bx + 0x15f3]                        ; 1005E  0x8D, 0xBF, 0xF3, 0x15
  mov cx, 8                                    ; 10062  0xB9, 0x08, 0x00
  db 0x03, 0xD9                                ; 10065  add bx, cx
  shr cx, 1                                    ; 10067  0xD1, 0xE9
  repe cmpsw                                   ; 10069  0xF3, 0xA7
  jne loc_10052                                ; 1006B  0x75, 0xE5

xios_imod_dispatch_shl:                        ; 1006D
  shl ax, 1                                    ; 1006D  0xD1, 0xE0
  db 0x8B, 0xD8                                ; 1006F  mov bx, ax
  mov ax, ds                                   ; 10071  0x8C, 0xD8
  mov es, ax                                   ; 10073  0x8E, 0xC0

xios_imod_dispatch_jmp:                        ; 10075
  jmp word [cs:bx + 0x16a4]                    ; 10075  0x2E, 0xFF, 0xA7, 0xA4, 0x16

sub_1007A:                                     ; 1007A
  lea dx, [0x1d5]                              ; 1007A  0x8D, 0x16, 0xD5, 0x01
  mov cl, 0x96                                 ; 1007E  0xB1, 0x96
  int 0xe0                                     ; 10080  0xCD, 0xE0
  ret                                          ; 10082  0xC3

loc_10083:                                     ; 10083
  mov ax, ds                                   ; 10083  0x8C, 0xD8
  mov es, ax                                   ; 10085  0x8E, 0xC0
  mov byte [0x1d5], 0                          ; 10087  0xC6, 0x06, 0xD5, 0x01, 0x00
  mov byte [0x140], 0                          ; 1008C  0xC6, 0x06, 0x40, 0x01, 0x00
  mov byte [0x259], 0xff                       ; 10091  0xC6, 0x06, 0x59, 0x02, 0xFF
  mov ax, [0x410]                              ; 10096  0xA1, 0x10, 0x04
  call sub_10C09                               ; 10099  0xE8, 0x6D, 0x0B
  mov cl, 0x6d                                 ; 1009C  0xB1, 0x6D
  db 0x33, 0xD2                                ; 1009E  xor dx, dx
  call sub_10C23                               ; 100A0  0xE8, 0x80, 0x0B
  call sub_1007A                               ; 100A3  0xE8, 0xD4, 0xFF
  cmp cx, 0x26                                 ; 100A6  0x83, 0xF9, 0x26
  jne loc_100FE                                ; 100A9  0x75, 0x53
  mov dx, 0x1406                               ; 100AB  0xBA, 0x06, 0x14
  call sub_10BA6                               ; 100AE  0xE8, 0xF5, 0x0A
  call sub_10D98                               ; 100B1  0xE8, 0xE4, 0x0C
  mov ax, 0                                    ; 100B4  0xB8, 0x00, 0x00
  push ax                                      ; 100B7  0x50

loc_100B8:                                     ; 100B8
  mov cx, 8                                    ; 100B8  0xB9, 0x08, 0x00
  mov di, 0x140                                ; 100BB  0xBF, 0x40, 0x01
  push ds                                      ; 100BE  0x1E
  pop es                                       ; 100BF  0x07

loc_100C0:                                     ; 100C0
  push cx                                      ; 100C0  0x51
  push di                                      ; 100C1  0x57
  mov cl, 6                                    ; 100C2  0xB1, 0x06
  mov dl, 0xfd                                 ; 100C4  0xB2, 0xFD
  int 0xe0                                     ; 100C6  0xCD, 0xE0
  pop di                                       ; 100C8  0x5F
  pop cx                                       ; 100C9  0x59
  cmp al, 0xd                                  ; 100CA  0x3C, 0x0D
  je loc_100DC                                 ; 100CC  0x74, 0x0E
  cmp al, 0x3b                                 ; 100CE  0x3C, 0x3B
  jne loc_100D9                                ; 100D0  0x75, 0x07
  pop ax                                       ; 100D2  0x58
  mov ax, 0xff                                 ; 100D3  0xB8, 0xFF, 0x00
  push ax                                      ; 100D6  0x50
  jmp short loc_100B8                          ; 100D7  0xEB, 0xDF

loc_100D9:                                     ; 100D9
  stosb                                        ; 100D9  0xAA
  loop loc_100C0                               ; 100DA  0xE2, 0xE4

loc_100DC:                                     ; 100DC
  mov al, 0x20                                 ; 100DC  0xB0, 0x20
  rep stosb                                    ; 100DE  0xF3, 0xAA
  mov dx, 0x140                                ; 100E0  0xBA, 0x40, 0x01
  mov cl, 0x1a                                 ; 100E3  0xB1, 0x1A
  int 0xe0                                     ; 100E5  0xCD, 0xE0
  pop ax                                       ; 100E7  0x58
  cmp ax, 0xff                                 ; 100E8  0x3D, 0xFF, 0x00
  jne loc_100F8                                ; 100EB  0x75, 0x0B
  push ds                                      ; 100ED  0x1E
  push cs                                      ; 100EE  0x0E
  pop ds                                       ; 100EF  0x1F
  mov dx, 0x140                                ; 100F0  0xBA, 0x40, 0x01
  mov cl, 0x6a                                 ; 100F3  0xB1, 0x6A
  int 0xe0                                     ; 100F5  0xCD, 0xE0
  pop ds                                       ; 100F7  0x1F

loc_100F8:                                     ; 100F8
  call sub_10BA3                               ; 100F8  0xE8, 0xA8, 0x0A
  call sub_1007A                               ; 100FB  0xE8, 0x7C, 0xFF

loc_100FE:                                     ; 100FE
  push cx                                      ; 100FE  0x51
  push bx                                      ; 100FF  0x53
  push ax                                      ; 10100  0x50
  call sub_10AE2                               ; 10101  0xE8, 0xDE, 0x09
  pop ax                                       ; 10104  0x58
  pop bx                                       ; 10105  0x5B
  pop cx                                       ; 10106  0x59
  cmp bx, 0                                    ; 10107  0x83, 0xFB, 0x00
  je loc_1014D                                 ; 1010A  0x74, 0x41

loc_1010C:                                     ; 1010C
  mov si, 0x1075                               ; 1010C  0xBE, 0x75, 0x10

loc_1010F:                                     ; 1010F
  add si, 4                                    ; 1010F  0x83, 0xC6, 0x04
  db 0x2E, 0x83, 0xBC, 0x00, 0x00, 0xFF        ; 10112  cmp word [cs:si], -1
  je loc_10121                                 ; 10118  0x74, 0x07
  db 0x2E, 0x3B, 0x8C, 0x00, 0x00              ; 1011A  cmp cx, word [cs:si]
  jne loc_1010F                                ; 1011F  0x75, 0xEE

loc_10121:                                     ; 10121
  db 0x2E, 0x8B, 0x94, 0x02, 0x00              ; 10121  mov dx, word [cs:si + 2]
  cmp dx, 0                                    ; 10126  0x83, 0xFA, 0x00
  jne loc_10133                                ; 10129  0x75, 0x08
  mov byte [0x259], 0                          ; 1012B  0xC6, 0x06, 0x59, 0x02, 0x00
  jmp near loc_0FED9                           ; 10130  0xE9, 0xA6, 0xFD

loc_10133:                                     ; 10133
  push dx                                      ; 10133  0x52
  mov dx, 0x10b0                               ; 10134  0xBA, 0xB0, 0x10
  call sub_10BA6                               ; 10137  0xE8, 0x6C, 0x0A
  pop dx                                       ; 1013A  0x5A
  call sub_10BA6                               ; 1013B  0xE8, 0x68, 0x0A
  mov dx, 0x1416                               ; 1013E  0xBA, 0x16, 0x14
  call sub_10BA6                               ; 10141  0xE8, 0x62, 0x0A
  mov dx, 0x2d2                                ; 10144  0xBA, 0xD2, 0x02
  call sub_10BB0                               ; 10147  0xE8, 0x66, 0x0A
  call sub_10BA3                               ; 1014A  0xE8, 0x56, 0x0A

loc_1014D:                                     ; 1014D
  jmp near loc_0FED9                           ; 1014D  0xE9, 0x89, 0xFD
  mov si, 0x2af                                ; 10150  0xBE, 0xAF, 0x02
  mov di, [0x25a]                              ; 10153  0x8B, 0x3E, 0x5A, 0x02
  cmp di, 0                                    ; 10157  0x83, 0xFF, 0x00
  je loc_10188                                 ; 1015A  0x74, 0x2C
  inc di                                       ; 1015C  0x47
  call sub_10AF6                               ; 1015D  0xE8, 0x96, 0x09
  cmp cx, 0                                    ; 10160  0x83, 0xF9, 0x00
  jne loc_10188                                ; 10163  0x75, 0x23
  mov si, 0x2af                                ; 10165  0xBE, 0xAF, 0x02
  inc si                                       ; 10168  0x46
  mov dx, [si]                                 ; 10169  0x8B, 0x14
  call sub_10B06                               ; 1016B  0xE8, 0x98, 0x09
  cmp bl, 0xf                                  ; 1016E  0x80, 0xFB, 0x0F
  ja loc_1017B                                 ; 10171  0x77, 0x08
  db 0x8A, 0xD3                                ; 10173  mov dl, bl
  call sub_10B9E                               ; 10175  0xE8, 0x26, 0x0A
  jmp near loc_10188                           ; 10178  0xE9, 0x0D, 0x00

loc_1017B:                                     ; 1017B
  cmp byte [0x1d2], 1                          ; 1017B  0x80, 0x3E, 0xD2, 0x01, 0x01
  je loc_1019B                                 ; 10180  0x74, 0x19
  mov dx, 0x1424                               ; 10182  0xBA, 0x24, 0x14
  call sub_10BA6                               ; 10185  0xE8, 0x1E, 0x0A

loc_10188:                                     ; 10188
  cmp byte [0x1d2], 1                          ; 10188  0x80, 0x3E, 0xD2, 0x01, 0x01
  je loc_1019B                                 ; 1018D  0x74, 0x0C
  mov dx, 0x143d                               ; 1018F  0xBA, 0x3D, 0x14
  call sub_10BA6                               ; 10192  0xE8, 0x11, 0x0A
  call sub_1019E                               ; 10195  0xE8, 0x06, 0x00
  call sub_10BA3                               ; 10198  0xE8, 0x08, 0x0A

loc_1019B:                                     ; 1019B
  jmp near loc_0FED9                           ; 1019B  0xE9, 0x3B, 0xFD

sub_1019E:                                     ; 1019E
  call sub_10B9C                               ; 1019E  0xE8, 0xFB, 0x09
  db 0x8A, 0xD3                                ; 101A1  mov dl, bl
  jmp near sub_10B85                           ; 101A3  0xE9, 0xDF, 0x09
  mov si, 0x2af                                ; 101A6  0xBE, 0xAF, 0x02
  mov di, [0x25a]                              ; 101A9  0x8B, 0x3E, 0x5A, 0x02
  cmp di, 0                                    ; 101AD  0x83, 0xFF, 0x00
  je loc_101DD                                 ; 101B0  0x74, 0x2B
  inc di                                       ; 101B2  0x47
  call sub_10AF6                               ; 101B3  0xE8, 0x40, 0x09
  cmp cx, 0                                    ; 101B6  0x83, 0xF9, 0x00
  jne loc_101DD                                ; 101B9  0x75, 0x22
  mov si, 0x2af                                ; 101BB  0xBE, 0xAF, 0x02
  inc si                                       ; 101BE  0x46
  mov dx, [si]                                 ; 101BF  0x8B, 0x14
  call sub_10B06                               ; 101C1  0xE8, 0x42, 0x09
  cmp bl, 0xff                                 ; 101C4  0x80, 0xFB, 0xFF
  je loc_101D0                                 ; 101C7  0x74, 0x07
  db 0x8A, 0xD3                                ; 101C9  mov dl, bl
  call sub_10BF1                               ; 101CB  0xE8, 0x23, 0x0A
  jcxz loc_101DD                               ; 101CE  0xE3, 0x0D

loc_101D0:                                     ; 101D0
  cmp byte [0x1d2], 1                          ; 101D0  0x80, 0x3E, 0xD2, 0x01, 0x01
  je loc_101F5                                 ; 101D5  0x74, 0x1E
  mov dx, 0x144f                               ; 101D7  0xBA, 0x4F, 0x14
  call sub_10BA6                               ; 101DA  0xE8, 0xC9, 0x09

loc_101DD:                                     ; 101DD
  cmp byte [0x1d2], 1                          ; 101DD  0x80, 0x3E, 0xD2, 0x01, 0x01
  je loc_101F5                                 ; 101E2  0x74, 0x11
  mov dx, 0x1469                               ; 101E4  0xBA, 0x69, 0x14
  call sub_10BA6                               ; 101E7  0xE8, 0xBC, 0x09
  call sub_10BF5                               ; 101EA  0xE8, 0x08, 0x0A
  db 0x8A, 0xD3                                ; 101ED  mov dl, bl
  call sub_10B85                               ; 101EF  0xE8, 0x93, 0x09
  call sub_10BA3                               ; 101F2  0xE8, 0xAE, 0x09

loc_101F5:                                     ; 101F5
  jmp near loc_0FED9                           ; 101F5  0xE9, 0xE1, 0xFC
  mov si, 0x2af                                ; 101F8  0xBE, 0xAF, 0x02
  mov di, [0x25a]                              ; 101FB  0x8B, 0x3E, 0x5A, 0x02
  cmp di, 0                                    ; 101FF  0x83, 0xFF, 0x00
  je loc_10235                                 ; 10202  0x74, 0x31
  inc di                                       ; 10204  0x47
  call sub_10AF6                               ; 10205  0xE8, 0xEE, 0x08
  cmp cx, 0                                    ; 10208  0x83, 0xF9, 0x00
  jne loc_10235                                ; 1020B  0x75, 0x28
  mov si, 0x2af                                ; 1020D  0xBE, 0xAF, 0x02
  inc si                                       ; 10210  0x46
  call sub_10B35                               ; 10211  0xE8, 0x21, 0x09
  cmp ax, 0x300                                ; 10214  0x3D, 0x00, 0x03
  ja loc_10228                                 ; 10217  0x77, 0x0F
  cmp ax, strict word 0x10                     ; 10219  3D 10 00
  jb loc_10228                                 ; 1021C  0x72, 0x0A
  mov cl, 6                                    ; 1021E  0xB1, 0x06
  shl ax, cl                                   ; 10220  0xD3, 0xE0
  call sub_10C09                               ; 10222  0xE8, 0xE4, 0x09
  jmp near loc_10235                           ; 10225  0xE9, 0x0D, 0x00

loc_10228:                                     ; 10228
  cmp byte [0x1d2], 1                          ; 10228  0x80, 0x3E, 0xD2, 0x01, 0x01
  je loc_1024F                                 ; 1022D  0x74, 0x20
  mov dx, 0x14b5                               ; 1022F  0xBA, 0xB5, 0x14
  call sub_10BA6                               ; 10232  0xE8, 0x71, 0x09

loc_10235:                                     ; 10235
  cmp byte [0x1d2], 1                          ; 10235  0x80, 0x3E, 0xD2, 0x01, 0x01
  je loc_1024F                                 ; 1023A  0x74, 0x13
  mov ax, [0x410]                              ; 1023C  0xA1, 0x10, 0x04
  mov cl, 6                                    ; 1023F  0xB1, 0x06
  shr ax, cl                                   ; 10241  0xD3, 0xE8
  mov di, 0x402                                ; 10243  0xBF, 0x02, 0x04
  call sub_10B53                               ; 10246  0xE8, 0x0A, 0x09
  mov dx, 0x3fb                                ; 10249  0xBA, 0xFB, 0x03
  call sub_10BB0                               ; 1024C  0xE8, 0x61, 0x09

loc_1024F:                                     ; 1024F
  jmp near loc_0FED9                           ; 1024F  0xE9, 0x87, 0xFC
  call sub_10B9C                               ; 10252  0xE8, 0x47, 0x09
  mov [0x1cf], al                              ; 10255  0xA2, 0xCF, 0x01
  mov byte [0x1ce], 0                          ; 10258  0xC6, 0x06, 0xCE, 0x01, 0x00
  mov byte [0x1cd], 0xff                       ; 1025D  0xC6, 0x06, 0xCD, 0x01, 0xFF
  mov si, 0x2af                                ; 10262  0xBE, 0xAF, 0x02
  mov di, [0x25a]                              ; 10265  0x8B, 0x3E, 0x5A, 0x02
  cmp di, 0                                    ; 10269  0x83, 0xFF, 0x00
  je loc_1028D                                 ; 1026C  0x74, 0x1F
  call sub_1043E                               ; 1026E  0xE8, 0xCD, 0x01
  cmp byte [di], 0                             ; 10271  0x80, 0x3D, 0x00
  je loc_1028D                                 ; 10274  0x74, 0x17
  call sub_10AF6                               ; 10276  0xE8, 0x7D, 0x08
  mov [0x25a], ax                              ; 10279  0xA3, 0x5A, 0x02
  cmp ax, strict word 0                        ; 1027C  3D 00 00
  jns loc_10284                                ; 1027F  0x79, 0x03
  jmp near loc_10350                           ; 10281  0xE9, 0xCC, 0x00

loc_10284:                                     ; 10284
  je loc_102A7                                 ; 10284  0x74, 0x21
  db 0x8B, 0xF8                                ; 10286  mov di, ax
  call sub_10446                               ; 10288  0xE8, 0xBB, 0x01
  jmp short loc_102A7                          ; 1028B  0xEB, 0x1A

loc_1028D:                                     ; 1028D
  mov ax, ds                                   ; 1028D  0x8C, 0xD8
  mov es, ax                                   ; 1028F  0x8E, 0xC0
  mov byte [0x2af], 0                          ; 10291  0xC6, 0x06, 0xAF, 0x02, 0x00

loc_10296:                                     ; 10296
  mov di, 0x2b0                                ; 10296  0xBF, 0xB0, 0x02
  mov cx, 0xb                                  ; 10299  0xB9, 0x0B, 0x00
  mov al, 0x3f                                 ; 1029C  0xB0, 0x3F
  rep stosb                                    ; 1029E  0xF3, 0xAA
  mov cx, 0x15                                 ; 102A0  0xB9, 0x15, 0x00
  db 0x32, 0xC0                                ; 102A3  xor al, al
  rep stosb                                    ; 102A5  0xF3, 0xAA

loc_102A7:                                     ; 102A7
  mov ax, ds                                   ; 102A7  0x8C, 0xD8
  mov es, ax                                   ; 102A9  0x8E, 0xC0
  mov di, 0x2b0                                ; 102AB  0xBF, 0xB0, 0x02
  mov al, 0x20                                 ; 102AE  0xB0, 0x20
  mov cx, 0xb                                  ; 102B0  0xB9, 0x0B, 0x00
  repe scasb                                   ; 102B3  0xF3, 0xAE
  je loc_10296                                 ; 102B5  0x74, 0xDF
  mov al, [0x2af]                              ; 102B7  0xA0, 0xAF, 0x02
  dec al                                       ; 102BA  0xFE, 0xC8
  jns loc_102C1                                ; 102BC  0x79, 0x03
  call sub_10BED                               ; 102BE  0xE8, 0x2C, 0x09

loc_102C1:                                     ; 102C1
  inc al                                       ; 102C1  0xFE, 0xC0
  mov [0x2af], al                              ; 102C3  0xA2, 0xAF, 0x02
  mov dx, 0x1d6                                ; 102C6  0xBA, 0xD6, 0x01
  mov cl, 0x1a                                 ; 102C9  0xB1, 0x1A
  call sub_10C23                               ; 102CB  0xE8, 0x55, 0x09
  mov dx, 0x2af                                ; 102CE  0xBA, 0xAF, 0x02
  mov cl, 0x11                                 ; 102D1  0xB1, 0x11
  call sub_10C23                               ; 102D3  0xE8, 0x4D, 0x09
  db 0x0A, 0xC0                                ; 102D6  or al, al
  jns loc_102E5                                ; 102D8  0x79, 0x0B
  call sub_10D9F                               ; 102DA  0xE8, 0xC2, 0x0A
  jae loc_10339                                ; 102DD  0x73, 0x5A
  mov dx, 0x1504                               ; 102DF  0xBA, 0x04, 0x15
  jmp near loc_10358                           ; 102E2  0xE9, 0x73, 0x00

loc_102E5:                                     ; 102E5
  mov dx, 0x1512                               ; 102E5  0xBA, 0x12, 0x15
  call sub_10BA6                               ; 102E8  0xE8, 0xBB, 0x08
  mov al, [0x2af]                              ; 102EB  0xA0, 0xAF, 0x02
  dec al                                       ; 102EE  0xFE, 0xC8
  call sub_1035D                               ; 102F0  0xE8, 0x6A, 0x00
  jae loc_10339                                ; 102F3  0x73, 0x44
  jne loc_102FC                                ; 102F5  0x75, 0x05
  mov dl, 0x20                                 ; 102F7  0xB2, 0x20
  call sub_10B97                               ; 102F9  0xE8, 0x9B, 0x08

loc_102FC:                                     ; 102FC
  mov dx, 0x151f                               ; 102FC  0xBA, 0x1F, 0x15
  call sub_10BA6                               ; 102FF  0xE8, 0xA4, 0x08
  call sub_1019E                               ; 10302  0xE8, 0x99, 0xFE
  mov cl, 0x11                                 ; 10305  0xB1, 0x11
  jmp short loc_10317                          ; 10307  0xEB, 0x0E

loc_10309:                                     ; 10309
  call sub_103CD                               ; 10309  0xE8, 0xC1, 0x00
  mov cl, 0xb                                  ; 1030C  0xB1, 0x0B
  call sub_10C23                               ; 1030E  0xE8, 0x12, 0x09
  db 0x0A, 0xC0                                ; 10311  or al, al
  jne loc_10343                                ; 10313  0x75, 0x2E
  mov cl, 0x12                                 ; 10315  0xB1, 0x12

loc_10317:                                     ; 10317
  mov dx, 0x2af                                ; 10317  0xBA, 0xAF, 0x02
  call sub_10C23                               ; 1031A  0xE8, 0x06, 0x09
  db 0x0A, 0xC0                                ; 1031D  or al, al
  jns loc_10309                                ; 1031F  0x79, 0xE8
  call sub_10D9F                               ; 10321  0xE8, 0x7B, 0x0A
  jae loc_10339                                ; 10324  0x73, 0x13
  cmp byte [0x1ce], 0x80                       ; 10326  0x80, 0x3E, 0xCE, 0x01, 0x80
  jne loc_10336                                ; 1032B  0x75, 0x09
  call sub_10BA3                               ; 1032D  0xE8, 0x73, 0x08
  mov dx, 0x152b                               ; 10330  0xBA, 0x2B, 0x15
  call sub_10BA6                               ; 10333  0xE8, 0x70, 0x08

loc_10336:                                     ; 10336
  call sub_10BA3                               ; 10336  0xE8, 0x6A, 0x08

loc_10339:                                     ; 10339
  mov dl, [0x1cf]                              ; 10339  0x8A, 0x16, 0xCF, 0x01
  call sub_10B9E                               ; 1033D  0xE8, 0x5E, 0x08
  jmp near loc_0FED9                           ; 10340  0xE9, 0x96, 0xFB

loc_10343:                                     ; 10343
  mov cl, 1                                    ; 10343  0xB1, 0x01
  call sub_10C23                               ; 10345  0xE8, 0xDB, 0x08
  mov dx, 0x153f                               ; 10348  0xBA, 0x3F, 0x15
  call sub_10BA6                               ; 1034B  0xE8, 0x58, 0x08
  jmp short loc_10336                          ; 1034E  0xEB, 0xE6

loc_10350:                                     ; 10350
  mov dx, 0x11e7                               ; 10350  0xBA, 0xE7, 0x11
  jmp short loc_10358                          ; 10353  0xEB, 0x03
  mov dx, 0x118c                               ; 10355  0xBA, 0x8C, 0x11

loc_10358:                                     ; 10358
  call sub_10BA6                               ; 10358  0xE8, 0x4B, 0x08
  jmp short loc_10336                          ; 1035B  0xEB, 0xD9

sub_1035D:                                     ; 1035D
  push ax                                      ; 1035D  0x50
  call sub_10BED                               ; 1035E  0xE8, 0x8C, 0x08
  pop dx                                       ; 10361  0x5A
  push ax                                      ; 10362  0x50
  call sub_10BE2                               ; 10363  0xE8, 0x7C, 0x08
  jae loc_103A9                                ; 10366  0x73, 0x41
  mov dx, 0x1d6                                ; 10368  0xBA, 0xD6, 0x01
  mov cl, 0x1a                                 ; 1036B  0xB1, 0x1A
  int 0xe0                                     ; 1036D  0xCD, 0xE0
  mov byte [0x2ae], 0x3f                       ; 1036F  0xC6, 0x06, 0xAE, 0x02, 0x3F
  mov cl, 0x11                                 ; 10374  0xB1, 0x11

loc_10376:                                     ; 10376
  mov dx, 0x2ae                                ; 10376  0xBA, 0xAE, 0x02
  int 0xe0                                     ; 10379  0xCD, 0xE0
  call sub_10D9F                               ; 1037B  0xE8, 0x21, 0x0A
  jae loc_103A9                                ; 1037E  0x73, 0x29
  call sub_103B0                               ; 10380  0xE8, 0x2D, 0x00
  jb loc_103A5                                 ; 10383  0x72, 0x20
  je loc_1038B                                 ; 10385  0x74, 0x04
  mov cl, 0x12                                 ; 10387  0xB1, 0x12
  jmp short loc_10376                          ; 10389  0xEB, 0xEB

loc_1038B:                                     ; 1038B
  db 0x8B, 0xF7                                ; 1038B  mov si, di
  lea di, [si + 0xb]                           ; 1038D  0x8D, 0x7C, 0x0B
  mov cx, 0xb                                  ; 10390  0xB9, 0x0B, 0x00
  std                                          ; 10393  0xFD
  mov al, 0x20                                 ; 10394  0xB0, 0x20
  repe scasb                                   ; 10396  0xF3, 0xAE
  cld                                          ; 10398  0xFC
  je loc_103A5                                 ; 10399  0x74, 0x0A
  inc cx                                       ; 1039B  0x41
  inc si                                       ; 1039C  0x46
  call sub_10491                               ; 1039D  0xE8, 0xF1, 0x00
  db 0x33, 0xC0                                ; 103A0  xor ax, ax
  stc                                          ; 103A2  0xF9
  jmp short loc_103A9                          ; 103A3  0xEB, 0x04

loc_103A5:                                     ; 103A5
  db 0x33, 0xC0                                ; 103A5  xor ax, ax
  inc ax                                       ; 103A7  0x40
  stc                                          ; 103A8  0xF9

loc_103A9:                                     ; 103A9
  pop dx                                       ; 103A9  0x5A
  pushf                                        ; 103AA  0x9C
  call sub_10BE8                               ; 103AB  0xE8, 0x3A, 0x08
  popf                                         ; 103AE  0x9D
  ret                                          ; 103AF  0xC3

sub_103B0:                                     ; 103B0
  cmp al, 0xff                                 ; 103B0  0x3C, 0xFF
  stc                                          ; 103B2  0xF9
  je loc_103BC                                 ; 103B3  0x74, 0x07
  call sub_103BD                               ; 103B5  0xE8, 0x05, 0x00
  cmp byte [di], 0x20                          ; 103B8  0x80, 0x3D, 0x20
  clc                                          ; 103BB  0xF8

loc_103BC:                                     ; 103BC
  ret                                          ; 103BC  0xC3

sub_103BD:                                     ; 103BD
  mov di, 0x1d6                                ; 103BD  0xBF, 0xD6, 0x01
  jmp short loc_103C5                          ; 103C0  0xEB, 0x03

sub_103C2:                                     ; 103C2
  mov di, 0x1d6                                ; 103C2  0xBF, 0xD6, 0x01

loc_103C5:                                     ; 103C5
  db 0x98                                      ; 103C5  cwde
  mov cl, 5                                    ; 103C6  0xB1, 0x05
  shl ax, cl                                   ; 103C8  0xD3, 0xE0
  db 0x03, 0xF8                                ; 103CA  add di, ax
  ret                                          ; 103CC  0xC3

sub_103CD:                                     ; 103CD
  call sub_103C2                               ; 103CD  0xE8, 0xF2, 0xFF
  test byte [0x1ce], 1                         ; 103D0  0xF6, 0x06, 0xCE, 0x01, 0x01
  jne loc_103E3                                ; 103D5  0x75, 0x0C
  test byte [di + 0xa], 0x80                   ; 103D7  0xF6, 0x45, 0x0A, 0x80
  je loc_103E3                                 ; 103DB  0x74, 0x06
  or byte [0x1ce], 0x80                        ; 103DD  0x80, 0x0E, 0xCE, 0x01, 0x80
  ret                                          ; 103E2  0xC3

loc_103E3:                                     ; 103E3
  push di                                      ; 103E3  0x57
  cmp byte [0x1cd], 5                          ; 103E4  0x80, 0x3E, 0xCD, 0x01, 0x05
  jb loc_103EE                                 ; 103E9  0x72, 0x03
  call sub_1040D                               ; 103EB  0xE8, 0x1F, 0x00

loc_103EE:                                     ; 103EE
  mov dx, 0x14ee                               ; 103EE  0xBA, 0xEE, 0x14
  call sub_10BA6                               ; 103F1  0xE8, 0xB2, 0x07
  pop si                                       ; 103F4  0x5E
  inc byte [0x1cd]                             ; 103F5  0xFE, 0x06, 0xCD, 0x01
  inc si                                       ; 103F9  0x46
  mov cx, 8                                    ; 103FA  0xB9, 0x08, 0x00
  call sub_10491                               ; 103FD  0xE8, 0x91, 0x00
  push si                                      ; 10400  0x56
  mov al, 0x2e                                 ; 10401  0xB0, 0x2E
  call sub_1049E                               ; 10403  0xE8, 0x98, 0x00
  pop si                                       ; 10406  0x5E
  mov cx, 3                                    ; 10407  0xB9, 0x03, 0x00
  jmp near sub_10491                           ; 1040A  0xE9, 0x84, 0x00

sub_1040D:                                     ; 1040D
  mov byte [0x1cd], 0                          ; 1040D  0xC6, 0x06, 0xCD, 0x01, 0x00
  call sub_10BA3                               ; 10412  0xE8, 0x8E, 0x07
  call sub_10B9C                               ; 10415  0xE8, 0x84, 0x07
  test bl, bl                                  ; 10418  0x84, 0xDB
  je loc_10421                                 ; 1041A  0x74, 0x05
  db 0x8A, 0xD3                                ; 1041C  mov dl, bl
  call sub_10B85                               ; 1041E  0xE8, 0x64, 0x07

loc_10421:                                     ; 10421
  mov bl, [0x2af]                              ; 10421  0x8A, 0x1E, 0xAF, 0x02
  dec bl                                       ; 10425  0xFE, 0xCB
  jns loc_1042C                                ; 10427  0x79, 0x03
  call sub_10BED                               ; 10429  0xE8, 0xC1, 0x07

loc_1042C:                                     ; 1042C
  mov dl, 0x41                                 ; 1042C  0xB2, 0x41
  db 0x02, 0xD3                                ; 1042E  add dl, bl
  call sub_10B97                               ; 10430  0xE8, 0x64, 0x07
  mov dl, 0x3a                                 ; 10433  0xB2, 0x3A
  jmp near sub_10B97                           ; 10435  0xE9, 0x5F, 0x07

loc_10438:                                     ; 10438
  mov dx, 0x14f2                               ; 10438  0xBA, 0xF2, 0x14
  jmp near loc_10358                           ; 1043B  0xE9, 0x1A, 0xFF

sub_1043E:                                     ; 1043E
  call sub_10AEB                               ; 1043E  0xE8, 0xAA, 0x06
  cmp byte [di], 0x5b                          ; 10441  0x80, 0x3D, 0x5B
  jne loc_10458                                ; 10444  0x75, 0x12

sub_10446:                                     ; 10446
  inc di                                       ; 10446  0x47
  call sub_10AEB                               ; 10447  0xE8, 0xA1, 0x06
  mov al, [di]                                 ; 1044A  0x8A, 0x05
  cmp al, 0                                    ; 1044C  0x3C, 0x00
  je loc_10458                                 ; 1044E  0x74, 0x08
  cmp al, 0x5d                                 ; 10450  0x3C, 0x5D
  jne loc_10459                                ; 10452  0x75, 0x05
  inc di                                       ; 10454  0x47
  call sub_10AEB                               ; 10455  0xE8, 0x93, 0x06

loc_10458:                                     ; 10458
  ret                                          ; 10458  0xC3

loc_10459:                                     ; 10459
  and al, 0x5f                                 ; 10459  0x24, 0x5F
  cmp al, 0x53                                 ; 1045B  0x3C, 0x53
  jne loc_10466                                ; 1045D  0x75, 0x07
  or byte [0x1ce], 1                           ; 1045F  0x80, 0x0E, 0xCE, 0x01, 0x01
  jmp short sub_10446                          ; 10464  0xEB, 0xE0

loc_10466:                                     ; 10466
  cmp al, 0x47                                 ; 10466  0x3C, 0x47
  jne loc_10438                                ; 10468  0x75, 0xCE
  inc di                                       ; 1046A  0x47
  call sub_10AEB                               ; 1046B  0xE8, 0x7D, 0x06
  mov dl, [di]                                 ; 1046E  0x8A, 0x15
  mov dh, 0x20                                 ; 10470  0xB6, 0x20
  mov al, [di + 1]                             ; 10472  0x8A, 0x45, 0x01
  cmp al, 0x30                                 ; 10475  0x3C, 0x30
  jb loc_10480                                 ; 10477  0x72, 0x07
  cmp al, 0x39                                 ; 10479  0x3C, 0x39
  ja loc_10480                                 ; 1047B  0x77, 0x03
  db 0x8A, 0xF0                                ; 1047D  mov dh, al
  inc di                                       ; 1047F  0x47

loc_10480:                                     ; 10480
  call sub_10B06                               ; 10480  0xE8, 0x83, 0x06
  cmp bl, 0xff                                 ; 10483  0x80, 0xFB, 0xFF
  je loc_10438                                 ; 10486  0x74, 0xB0
  db 0x8A, 0xD3                                ; 10488  mov dl, bl
  push di                                      ; 1048A  0x57
  call sub_10B9E                               ; 1048B  0xE8, 0x10, 0x07
  pop di                                       ; 1048E  0x5F
  jmp short sub_10446                          ; 1048F  0xEB, 0xB5

sub_10491:                                     ; 10491
  lodsb                                        ; 10491  0xAC
  push si                                      ; 10492  0x56
  push cx                                      ; 10493  0x51
  and al, 0x7f                                 ; 10494  0x24, 0x7F
  call sub_1049E                               ; 10496  0xE8, 0x05, 0x00
  pop cx                                       ; 10499  0x59
  pop si                                       ; 1049A  0x5E
  loop sub_10491                               ; 1049B  0xE2, 0xF4
  ret                                          ; 1049D  0xC3

sub_1049E:                                     ; 1049E
  db 0x8A, 0xD0                                ; 1049E  mov dl, al
  jmp near sub_10B97                           ; 104A0  0xE9, 0xF4, 0x06
  mov ax, ds                                   ; 104A3  0x8C, 0xD8
  mov es, ax                                   ; 104A5  0x8E, 0xC0
  mov si, 0x2af                                ; 104A7  0xBE, 0xAF, 0x02
  mov di, [0x25a]                              ; 104AA  0x8B, 0x3E, 0x5A, 0x02
  cmp di, 0                                    ; 104AE  0x83, 0xFF, 0x00
  je loc_104E9                                 ; 104B1  0x74, 0x36
  call sub_10AF6                               ; 104B3  0xE8, 0x40, 0x06
  mov [0x25a], ax                              ; 104B6  0xA3, 0x5A, 0x02
  cmp ax, strict word 0                        ; 104B9  3D 00 00
  js loc_104EC                                 ; 104BC  0x78, 0x2E
  je loc_104E4                                 ; 104BE  0x74, 0x24
  db 0x8B, 0xF8                                ; 104C0  mov di, ax
  call sub_10AEB                               ; 104C2  0xE8, 0x26, 0x06
  mov ah, 0                                    ; 104C5  0xB4, 0x00
  mov al, [di]                                 ; 104C7  0x8A, 0x05
  cmp al, 0                                    ; 104C9  0x3C, 0x00
  je loc_104E4                                 ; 104CB  0x74, 0x17
  and al, 0x5f                                 ; 104CD  0x24, 0x5F
  sub al, 0x10                                 ; 104CF  0x2C, 0x10
  js loc_10547                                 ; 104D1  0x78, 0x74
  mov es, [0]                                  ; 104D3  0x8E, 0x06, 0x00, 0x00
  cmp al, [es:0x83]                            ; 104D7  0x26, 0x3A, 0x06, 0x83, 0x00
  jbe loc_104F1                                ; 104DC  0x76, 0x13
  mov ah, 0xff                                 ; 104DE  0xB4, 0xFF
  cmp al, 0x43                                 ; 104E0  0x3C, 0x43
  jne loc_10547                                ; 104E2  0x75, 0x63

loc_104E4:                                     ; 104E4
  mov al, [4]                                  ; 104E4  0xA0, 0x04, 0x00
  jmp short loc_10508                          ; 104E7  0xEB, 0x1F

loc_104E9:                                     ; 104E9
  jmp near loc_10535                           ; 104E9  0xE9, 0x49, 0x00

loc_104EC:                                     ; 104EC
  mov dx, 0x11e7                               ; 104EC  0xBA, 0xE7, 0x11
  jmp short loc_10541                          ; 104EF  0xEB, 0x50

loc_104F1:                                     ; 104F1
  push ax                                      ; 104F1  0x50
  inc di                                       ; 104F2  0x47
  call sub_10AEB                               ; 104F3  0xE8, 0xF5, 0x05
  mov al, [di]                                 ; 104F6  0x8A, 0x05
  cmp al, 0                                    ; 104F8  0x3C, 0x00
  je loc_10507                                 ; 104FA  0x74, 0x0B
  and al, 0x5f                                 ; 104FC  0x24, 0x5F
  cmp al, 0x53                                 ; 104FE  0x3C, 0x53
  jne loc_10507                                ; 10500  0x75, 0x05
  pop ax                                       ; 10502  0x58
  mov ah, 0xff                                 ; 10503  0xB4, 0xFF
  jmp short loc_10508                          ; 10505  0xEB, 0x01

loc_10507:                                     ; 10507
  pop ax                                       ; 10507  0x58

loc_10508:                                     ; 10508
  mov dx, ds                                   ; 10508  0x8C, 0xDA
  mov es, dx                                   ; 1050A  0x8E, 0xC2
  mov si, 0x2b0                                ; 1050C  0xBE, 0xB0, 0x02
  mov di, 0x2bf                                ; 1050F  0xBF, 0xBF, 0x02
  mov cx, 8                                    ; 10512  0xB9, 0x08, 0x00
  rep movsw                                    ; 10515  0xF3, 0xA5
  mov di, 0x2b9                                ; 10517  0xBF, 0xB9, 0x02
  mov word [di], 0                             ; 1051A  0xC7, 0x05, 0x00, 0x00
  mov [di + 2], ah                             ; 1051E  0x88, 0x65, 0x02
  mov byte [di + 3], 0                         ; 10521  0xC6, 0x45, 0x03, 0x00
  mov [di + 4], al                             ; 10525  0x88, 0x45, 0x04
  mov byte [di + 5], 0                         ; 10528  0xC6, 0x45, 0x05, 0x00
  db 0x8B, 0xD7                                ; 1052C  mov dx, di
  mov cl, 0x9d                                 ; 1052E  0xB1, 0x9D
  call sub_10C23                               ; 10530  0xE8, 0xF0, 0x06
  jcxz loc_1053E                               ; 10533  0xE3, 0x09

loc_10535:                                     ; 10535
  mov dx, 0x1559                               ; 10535  0xBA, 0x59, 0x15
  call sub_10BA6                               ; 10538  0xE8, 0x6B, 0x06
  jmp near loc_0FED9                           ; 1053B  0xE9, 0x9B, 0xF9

loc_1053E:                                     ; 1053E
  mov dx, 0x1568                               ; 1053E  0xBA, 0x68, 0x15

loc_10541:                                     ; 10541
  call sub_10BA6                               ; 10541  0xE8, 0x62, 0x06
  jmp near loc_0FED9                           ; 10544  0xE9, 0x92, 0xF9

loc_10547:                                     ; 10547
  mov dx, 0x1574                               ; 10547  0xBA, 0x74, 0x15
  jmp near loc_10541                           ; 1054A  0xE9, 0xF4, 0xFF
  call sub_10560                               ; 1054D  0xE8, 0x10, 0x00
  jb loc_10557                                 ; 10550  0x72, 0x05
  mov dx, 0x12a4                               ; 10552  0xBA, 0xA4, 0x12
  jmp short loc_1055A                          ; 10555  0xEB, 0x03

loc_10557:                                     ; 10557
  mov dx, 0x1265                               ; 10557  0xBA, 0x65, 0x12

loc_1055A:                                     ; 1055A
  call sub_10BA6                               ; 1055A  0xE8, 0x49, 0x06
  jmp near loc_0FED9                           ; 1055D  0xE9, 0x79, 0xF9

sub_10560:                                     ; 10560
  cmp byte [0x413], 0xff                       ; 10560  0x80, 0x3E, 0x13, 0x04, 0xFF
  je loc_10581                                 ; 10565  0x74, 0x1A
  mov dx, 0                                    ; 10567  0xBA, 0x00, 0x00
  mov cl, 0x49                                 ; 1056A  0xB1, 0x49
  call sub_10C23                               ; 1056C  0xE8, 0xB4, 0x06
  db 0x0B, 0xC0                                ; 1056F  or ax, ax
  jne loc_10581                                ; 10571  0x75, 0x0E
  mov dx, 0xff                                 ; 10573  0xBA, 0xFF, 0x00
  mov cl, 0x48                                 ; 10576  0xB1, 0x48
  call sub_10C23                               ; 10578  0xE8, 0xA8, 0x06
  db 0x0B, 0xC0                                ; 1057B  or ax, ax
  jne loc_10581                                ; 1057D  0x75, 0x02
  stc                                          ; 1057F  0xF9
  ret                                          ; 10580  0xC3

loc_10581:                                     ; 10581
  clc                                          ; 10581  0xF8
  ret                                          ; 10582  0xC3
  call sub_1084E                               ; 10583  0xE8, 0xC8, 0x02
  jae loc_1059E                                ; 10586  0x73, 0x16
  mov dx, 0                                    ; 10588  0xBA, 0x00, 0x00
  mov cl, 0x4a                                 ; 1058B  0xB1, 0x4A
  call sub_10C23                               ; 1058D  0xE8, 0x93, 0x06
  db 0x0B, 0xC0                                ; 10590  or ax, ax
  jne loc_1059E                                ; 10592  0x75, 0x0A
  call sub_1084E                               ; 10594  0xE8, 0xB7, 0x02
  jb loc_105A4                                 ; 10597  0x72, 0x0B
  mov dx, 0x1293                               ; 10599  0xBA, 0x93, 0x12
  jmp short loc_105A1                          ; 1059C  0xEB, 0x03

loc_1059E:                                     ; 1059E
  mov dx, 0x12a4                               ; 1059E  0xBA, 0xA4, 0x12

loc_105A1:                                     ; 105A1
  call sub_10BA6                               ; 105A1  0xE8, 0x02, 0x06

loc_105A4:                                     ; 105A4
  jmp near loc_0FED9                           ; 105A4  0xE9, 0x32, 0xF9

sub_105A7:                                     ; 105A7
  call sub_10842                               ; 105A7  0xE8, 0x98, 0x02
  mov dx, 0x1277                               ; 105AA  0xBA, 0x77, 0x12
  jmp short loc_105B5                          ; 105AD  0xEB, 0x06

sub_105AF:                                     ; 105AF
  call sub_1084E                               ; 105AF  0xE8, 0x9C, 0x02
  mov dx, 0x12a4                               ; 105B2  0xBA, 0xA4, 0x12

loc_105B5:                                     ; 105B5
  jb loc_105BC                                 ; 105B5  0x72, 0x05
  inc sp                                       ; 105B7  0x44
  inc sp                                       ; 105B8  0x44
  jmp near loc_10ADC                           ; 105B9  0xE9, 0x20, 0x05

loc_105BC:                                     ; 105BC
  ret                                          ; 105BC  0xC3
  cld                                          ; 105BD  0xFC
  call sub_105A7                               ; 105BE  0xE8, 0xE6, 0xFF
  mov di, [0x25a]                              ; 105C1  0x8B, 0x3E, 0x5A, 0x02
  cmp di, 0                                    ; 105C5  0x83, 0xFF, 0x00
  jne loc_105CF                                ; 105C8  0x75, 0x05
  call sub_10868                               ; 105CA  0xE8, 0x9B, 0x02
  jmp short loc_105D2                          ; 105CD  0xEB, 0x03

loc_105CF:                                     ; 105CF
  call sub_10876                               ; 105CF  0xE8, 0xA4, 0x02

loc_105D2:                                     ; 105D2
  jb loc_10600                                 ; 105D2  0x72, 0x2C
  mov al, [0x41e]                              ; 105D4  0xA0, 0x1E, 0x04
  cmp al, [0x2af]                              ; 105D7  0x3A, 0x06, 0xAF, 0x02
  jne loc_105E3                                ; 105DB  0x75, 0x06
  mov dx, 0x138b                               ; 105DD  0xBA, 0x8B, 0x13
  jmp near loc_10ADC                           ; 105E0  0xE9, 0xF9, 0x04

loc_105E3:                                     ; 105E3
  mov cl, 0x40                                 ; 105E3  0xB1, 0x40
  call sub_10C23                               ; 105E5  0xE8, 0x3B, 0x06
  mov dx, 0x12bb                               ; 105E8  0xBA, 0xBB, 0x12
  db 0x0B, 0xC0                                ; 105EB  or ax, ax
  je loc_105FA                                 ; 105ED  0x74, 0x0B
  mov dx, 0x11c4                               ; 105EF  0xBA, 0xC4, 0x11
  cmp ah, 7                                    ; 105F2  0x80, 0xFC, 0x07
  je loc_105FA                                 ; 105F5  0x74, 0x03
  mov dx, 0x12d6                               ; 105F7  0xBA, 0xD6, 0x12

loc_105FA:                                     ; 105FA
  call sub_10BA6                               ; 105FA  0xE8, 0xA9, 0x05
  jmp near loc_0FED9                           ; 105FD  0xE9, 0xD9, 0xF8

loc_10600:                                     ; 10600
  db 0x98                                      ; 10600  cwde
  shl ax, 1                                    ; 10601  0xD1, 0xE0
  db 0x8B, 0xD8                                ; 10603  mov bx, ax
  mov dx, [cs:bx + 0x1333]                     ; 10605  0x2E, 0x8B, 0x97, 0x33, 0x13
  jmp short loc_105FA                          ; 1060A  0xEB, 0xEE
  call sub_105AF                               ; 1060C  0xE8, 0xA0, 0xFF
  mov di, [0x25a]                              ; 1060F  0x8B, 0x3E, 0x5A, 0x02
  cmp di, 0                                    ; 10613  0x83, 0xFF, 0x00
  jne loc_1061D                                ; 10616  0x75, 0x05
  call sub_10868                               ; 10618  0xE8, 0x4D, 0x02
  jmp short loc_10620                          ; 1061B  0xEB, 0x03

loc_1061D:                                     ; 1061D
  call sub_10876                               ; 1061D  0xE8, 0x56, 0x02

loc_10620:                                     ; 10620
  jb loc_10600                                 ; 10620  0x72, 0xDE
  mov al, [0x41e]                              ; 10622  0xA0, 0x1E, 0x04
  cmp al, [0x2af]                              ; 10625  0x3A, 0x06, 0xAF, 0x02
  jne loc_10631                                ; 10629  0x75, 0x06
  mov dx, 0x13ae                               ; 1062B  0xBA, 0xAE, 0x13
  jmp near loc_10ADC                           ; 1062E  0xE9, 0xAB, 0x04

loc_10631:                                     ; 10631
  mov cl, 0x41                                 ; 10631  0xB1, 0x41
  call sub_10C23                               ; 10633  0xE8, 0xED, 0x05
  mov dx, 0x12f7                               ; 10636  0xBA, 0xF7, 0x12
  db 0x0B, 0xC0                                ; 10639  or ax, ax
  je loc_105FA                                 ; 1063B  0x74, 0xBD
  mov dx, 0x1311                               ; 1063D  0xBA, 0x11, 0x13
  jmp near loc_105FA                           ; 10640  0xE9, 0xB7, 0xFF
  mov di, [0x25a]                              ; 10643  0x8B, 0x3E, 0x5A, 0x02
  cmp di, 0                                    ; 10647  0x83, 0xFF, 0x00
  jne loc_10658                                ; 1064A  0x75, 0x0C

loc_1064C:                                     ; 1064C
  mov dx, 0x13d1                               ; 1064C  0xBA, 0xD1, 0x13
  jmp near loc_10ADC                           ; 1064F  0xE9, 0x8A, 0x04

loc_10652:                                     ; 10652
  mov dx, 0x133b                               ; 10652  0xBA, 0x3B, 0x13
  jmp near loc_10ADC                           ; 10655  0xE9, 0x84, 0x04

loc_10658:                                     ; 10658
  call sub_105A7                               ; 10658  0xE8, 0x4C, 0xFF
  mov di, [0x25a]                              ; 1065B  0x8B, 0x3E, 0x5A, 0x02
  cmp di, 0                                    ; 1065F  0x83, 0xFF, 0x00
  je loc_1064C                                 ; 10662  0x74, 0xE8
  mov si, 0x444                                ; 10664  0xBE, 0x44, 0x04
  call sub_107BB                               ; 10667  0xE8, 0x51, 0x01
  cmp al, 0xff                                 ; 1066A  0x3C, 0xFF
  je loc_1064C                                 ; 1066C  0x74, 0xDE
  cmp al, 0xfe                                 ; 1066E  0x3C, 0xFE
  je loc_10652                                 ; 10670  0x74, 0xE0
  call sub_10AEB                               ; 10672  0xE8, 0x76, 0x04
  cmp byte [di], 0x3d                          ; 10675  0x80, 0x3D, 0x3D
  jne loc_10652                                ; 10678  0x75, 0xD8
  inc di                                       ; 1067A  0x47
  mov si, 0x44d                                ; 1067B  0xBE, 0x4D, 0x04
  call sub_107BB                               ; 1067E  0xE8, 0x3A, 0x01
  cmp al, [0x444]                              ; 10681  0x3A, 0x06, 0x44, 0x04
  jne loc_10652                                ; 10685  0x75, 0xCB
  mov al, [0x413]                              ; 10687  0xA0, 0x13, 0x04
  mov [0x2af], al                              ; 1068A  0xA2, 0xAF, 0x02
  call sub_10AEB                               ; 1068D  0xE8, 0x5B, 0x04
  cmp byte [di], 0                             ; 10690  0x80, 0x3D, 0x00
  je loc_1069D                                 ; 10693  0x74, 0x08
  call sub_10876                               ; 10695  0xE8, 0xDE, 0x01
  jae loc_1069D                                ; 10698  0x73, 0x03
  jmp near loc_10600                           ; 1069A  0xE9, 0x63, 0xFF

loc_1069D:                                     ; 1069D
  mov di, 0x2af                                ; 1069D  0xBF, 0xAF, 0x02
  push word [di]                               ; 106A0  0xFF, 0x35
  mov al, [0x444]                              ; 106A2  0xA0, 0x44, 0x04
  mov [di], al                                 ; 106A5  0x88, 0x05
  cmp al, 3                                    ; 106A7  0x3C, 0x03
  je loc_106C0                                 ; 106A9  0x74, 0x15
  mov al, [0x445]                              ; 106AB  0xA0, 0x45, 0x04
  mov [di + 1], al                             ; 106AE  0x88, 0x45, 0x01
  mov al, [0x44e]                              ; 106B1  0xA0, 0x4E, 0x04
  or al, 0x80                                  ; 106B4  0x0C, 0x80
  mov [di + 2], al                             ; 106B6  0x88, 0x45, 0x02
  pop ax                                       ; 106B9  0x58
  mov [di + 3], al                             ; 106BA  0x88, 0x45, 0x03
  jmp near loc_106D7                           ; 106BD  0xE9, 0x17, 0x00

loc_106C0:                                     ; 106C0
  pop ax                                       ; 106C0  0x58
  push di                                      ; 106C1  0x57
  inc di                                       ; 106C2  0x47
  cld                                          ; 106C3  0xFC
  mov si, 0x445                                ; 106C4  0xBE, 0x45, 0x04
  mov cx, 4                                    ; 106C7  0xB9, 0x04, 0x00
  rep movsw                                    ; 106CA  0xF3, 0xA5
  mov si, 0x44e                                ; 106CC  0xBE, 0x4E, 0x04
  mov cx, 4                                    ; 106CF  0xB9, 0x04, 0x00
  rep movsw                                    ; 106D2  0xF3, 0xA5
  mov [di], al                                 ; 106D4  0x88, 0x05
  pop di                                       ; 106D6  0x5F

loc_106D7:                                     ; 106D7
  db 0x8B, 0xD7                                ; 106D7  mov dx, di
  mov cl, 0x45                                 ; 106D9  0xB1, 0x45
  call sub_10C23                               ; 106DB  0xE8, 0x45, 0x05
  cmp ax, strict word 0                        ; 106DE  3D 00 00
  je loc_106E9                                 ; 106E1  0x74, 0x06
  mov dx, 0x13e8                               ; 106E3  0xBA, 0xE8, 0x13
  jmp near loc_10ADC                           ; 106E6  0xE9, 0xF3, 0x03

loc_106E9:                                     ; 106E9
  jmp near loc_0FED9                           ; 106E9  0xE9, 0xED, 0xF7

loc_106EC:                                     ; 106EC
  mov dx, 0x13d1                               ; 106EC  0xBA, 0xD1, 0x13
  jmp near loc_10ADC                           ; 106EF  0xE9, 0xEA, 0x03

loc_106F2:                                     ; 106F2
  mov dx, 0x133b                               ; 106F2  0xBA, 0x3B, 0x13
  jmp near loc_10ADC                           ; 106F5  0xE9, 0xE4, 0x03
  call sub_105AF                               ; 106F8  0xE8, 0xB4, 0xFE
  mov di, [0x25a]                              ; 106FB  0x8B, 0x3E, 0x5A, 0x02
  cmp di, 0                                    ; 106FF  0x83, 0xFF, 0x00
  je loc_106EC                                 ; 10702  0x74, 0xE8
  mov si, 0x444                                ; 10704  0xBE, 0x44, 0x04
  call sub_107BB                               ; 10707  0xE8, 0xB1, 0x00
  cmp al, 0xff                                 ; 1070A  0x3C, 0xFF
  je loc_106EC                                 ; 1070C  0x74, 0xDE
  cmp al, 0xfe                                 ; 1070E  0x3C, 0xFE
  je loc_106F2                                 ; 10710  0x74, 0xE0
  cmp al, 3                                    ; 10712  0x3C, 0x03
  jne loc_10728                                ; 10714  0x75, 0x12
  inc al                                       ; 10716  0xFE, 0xC0
  mov [0x2af], al                              ; 10718  0xA2, 0xAF, 0x02
  mov di, 0x2b0                                ; 1071B  0xBF, 0xB0, 0x02
  mov si, 0x445                                ; 1071E  0xBE, 0x45, 0x04
  mov cx, 4                                    ; 10721  0xB9, 0x04, 0x00
  rep movsw                                    ; 10724  0xF3, 0xA5
  jmp short loc_10736                          ; 10726  0xEB, 0x0E

loc_10728:                                     ; 10728
  mov [0x2af], al                              ; 10728  0xA2, 0xAF, 0x02
  mov al, [0x445]                              ; 1072B  0xA0, 0x45, 0x04
  mov [0x2b0], al                              ; 1072E  0xA2, 0xB0, 0x02
  mov byte [0x2b1], 0                          ; 10731  0xC6, 0x06, 0xB1, 0x02, 0x00

loc_10736:                                     ; 10736
  mov dx, 0x2af                                ; 10736  0xBA, 0xAF, 0x02
  mov cl, 0x45                                 ; 10739  0xB1, 0x45
  call sub_10C23                               ; 1073B  0xE8, 0xE5, 0x04
  db 0x0B, 0xC0                                ; 1073E  or ax, ax
  jns loc_10748                                ; 10740  0x79, 0x06
  mov dx, 0x13fd                               ; 10742  0xBA, 0xFD, 0x13
  jmp near loc_10ADC                           ; 10745  0xE9, 0x94, 0x03

loc_10748:                                     ; 10748
  jmp near loc_0FED9                           ; 10748  0xE9, 0x8E, 0xF7
  mov byte [0x412], 0xff                       ; 1074B  0xC6, 0x06, 0x12, 0x04, 0xFF
  jmp near loc_0FED9                           ; 10750  0xE9, 0x86, 0xF7
  mov byte [0x412], 0                          ; 10753  0xC6, 0x06, 0x12, 0x04, 0x00
  jmp near loc_0FED9                           ; 10758  0xE9, 0x7E, 0xF7
  mov dx, 0x14d7                               ; 1075B  0xBA, 0xD7, 0x14
  call sub_10BA6                               ; 1075E  0xE8, 0x45, 0x04
  mov byte [0x1cd], 0xff                       ; 10761  0xC6, 0x06, 0xCD, 0x01, 0xFF
  mov si, 0x15f3                               ; 10766  0xBE, 0xF3, 0x15

loc_10769:                                     ; 10769
  db 0x2E, 0x80, 0xBC, 0x00, 0x00, 0x00        ; 10769  cmp byte [cs:si], 0
  je loc_10796                                 ; 1076F  0x74, 0x25
  cmp byte [0x1cd], 7                          ; 10771  0x80, 0x3E, 0xCD, 0x01, 0x07
  jb loc_10782                                 ; 10776  0x72, 0x0A
  push si                                      ; 10778  0x56
  call sub_10BA3                               ; 10779  0xE8, 0x27, 0x04
  pop si                                       ; 1077C  0x5E
  mov byte [0x1cd], 0                          ; 1077D  0xC6, 0x06, 0xCD, 0x01, 0x00

loc_10782:                                     ; 10782
  push si                                      ; 10782  0x56
  call sub_1079C                               ; 10783  0xE8, 0x16, 0x00
  mov dx, 0x14ee                               ; 10786  0xBA, 0xEE, 0x14
  call sub_10BA6                               ; 10789  0xE8, 0x1A, 0x04
  inc byte [0x1cd]                             ; 1078C  0xFE, 0x06, 0xCD, 0x01
  pop si                                       ; 10790  0x5E
  add si, 8                                    ; 10791  0x83, 0xC6, 0x08
  jmp short loc_10769                          ; 10794  0xEB, 0xD3

loc_10796:                                     ; 10796
  call sub_10BA3                               ; 10796  0xE8, 0x0A, 0x04
  jmp near loc_0FED9                           ; 10799  0xE9, 0x3D, 0xF7

sub_1079C:                                     ; 1079C
  push si                                      ; 1079C  0x56
  db 0x2E, 0x8A, 0x94, 0x00, 0x00              ; 1079D  mov dl, byte [cs:si]
  call sub_10B97                               ; 107A2  0xE8, 0xF2, 0x03
  pop si                                       ; 107A5  0x5E
  inc si                                       ; 107A6  0x46
  mov cx, 7                                    ; 107A7  0xB9, 0x07, 0x00

loc_107AA:                                     ; 107AA
  db 0x2E, 0xAC                                ; 107AA  lodsb
  push si                                      ; 107AC  0x56
  push cx                                      ; 107AD  0x51
  call sub_10B7A                               ; 107AE  0xE8, 0xC9, 0x03
  db 0x8A, 0xD0                                ; 107B1  mov dl, al
  call sub_10B97                               ; 107B3  0xE8, 0xE1, 0x03
  pop cx                                       ; 107B6  0x59
  pop si                                       ; 107B7  0x5E
  loop loc_107AA                               ; 107B8  0xE2, 0xF0
  ret                                          ; 107BA  0xC3

sub_107BB:                                     ; 107BB
  call sub_10AEB                               ; 107BB  0xE8, 0x2D, 0x03
  mov al, [di]                                 ; 107BE  0x8A, 0x05
  cmp al, 0                                    ; 107C0  0x3C, 0x00
  jne loc_107C7                                ; 107C2  0x75, 0x03
  mov al, 0xff                                 ; 107C4  0xB0, 0xFF
  ret                                          ; 107C6  0xC3

loc_107C7:                                     ; 107C7
  inc di                                       ; 107C7  0x47
  cmp al, 0x22                                 ; 107C8  0x3C, 0x22
  je loc_107EA                                 ; 107CA  0x74, 0x1E
  and al, 0x5f                                 ; 107CC  0x24, 0x5F
  cmp byte [di], 0x3a                          ; 107CE  0x80, 0x3D, 0x3A
  je loc_107DA                                 ; 107D1  0x74, 0x07
  cmp al, 0x4c                                 ; 107D3  0x3C, 0x4C
  je loc_10813                                 ; 107D5  0x74, 0x3C

loc_107D7:                                     ; 107D7
  mov al, 0xfe                                 ; 107D7  0xB0, 0xFE
  ret                                          ; 107D9  0xC3

loc_107DA:                                     ; 107DA
  sub al, 0x41                                 ; 107DA  0x2C, 0x41
  cmp al, 0xf                                  ; 107DC  0x3C, 0x0F
  ja loc_107D7                                 ; 107DE  0x77, 0xF7
  inc di                                       ; 107E0  0x47
  mov byte [si], 0                             ; 107E1  0xC6, 0x04, 0x00
  mov [si + 1], al                             ; 107E4  0x88, 0x44, 0x01
  mov al, [si]                                 ; 107E7  0x8A, 0x04
  ret                                          ; 107E9  0xC3

loc_107EA:                                     ; 107EA
  mov byte [si], 3                             ; 107EA  0xC6, 0x04, 0x03
  inc si                                       ; 107ED  0x46
  mov cx, 8                                    ; 107EE  0xB9, 0x08, 0x00

loc_107F1:                                     ; 107F1
  mov al, [di]                                 ; 107F1  0x8A, 0x05
  cmp al, 0                                    ; 107F3  0x3C, 0x00
  je loc_107D7                                 ; 107F5  0x74, 0xE0
  cmp al, 0x22                                 ; 107F7  0x3C, 0x22
  je loc_10806                                 ; 107F9  0x74, 0x0B
  mov [si], al                                 ; 107FB  0x88, 0x04
  inc si                                       ; 107FD  0x46
  inc di                                       ; 107FE  0x47
  loop loc_107F1                               ; 107FF  0xE2, 0xF0
  cmp byte [di], 0x22                          ; 10801  0x80, 0x3D, 0x22
  jne loc_107D7                                ; 10804  0x75, 0xD1

loc_10806:                                     ; 10806
  xchg si, di                                  ; 10806  87 F7
  mov al, 0x20                                 ; 10808  0xB0, 0x20
  cld                                          ; 1080A  0xFC
  rep stosb                                    ; 1080B  0xF3, 0xAA
  xchg si, di                                  ; 1080D  87 F7
  inc di                                       ; 1080F  0x47
  mov al, 3                                    ; 10810  0xB0, 0x03
  ret                                          ; 10812  0xC3

loc_10813:                                     ; 10813
  and word [di], 0x5f5f                        ; 10813  0x81, 0x25, 0x5F, 0x5F
  cmp word [di], 0x5453                        ; 10817  0x81, 0x3D, 0x53, 0x54
  jne loc_107D7                                ; 1081B  0x75, 0xBA
  inc di                                       ; 1081D  0x47
  inc di                                       ; 1081E  0x47
  db 0x32, 0xDB                                ; 1081F  xor bl, bl

loc_10821:                                     ; 10821
  mov al, [di]                                 ; 10821  0x8A, 0x05
  sub al, 0x30                                 ; 10823  0x2C, 0x30
  js loc_107D7                                 ; 10825  0x78, 0xB0
  cmp al, 9                                    ; 10827  0x3C, 0x09
  ja loc_107D7                                 ; 10829  0x77, 0xAC
  xchg al, bl                                  ; 1082B  86 C3
  mov ah, 0xa                                  ; 1082D  0xB4, 0x0A
  db 0xF6, 0xE4                                ; 1082F  mul ah
  db 0x02, 0xD8                                ; 10831  add bl, al
  inc di                                       ; 10833  0x47
  cmp byte [di], 0x3a                          ; 10834  0x80, 0x3D, 0x3A
  jne loc_10821                                ; 10837  0x75, 0xE8
  mov al, 2                                    ; 10839  0xB0, 0x02
  mov [si], al                                 ; 1083B  0x88, 0x04
  mov [si + 1], bl                             ; 1083D  0x88, 0x5C, 0x01
  inc di                                       ; 10840  0x47
  ret                                          ; 10841  0xC3

sub_10842:                                     ; 10842
  call sub_1084E                               ; 10842  0xE8, 0x09, 0x00
  jb loc_10866                                 ; 10845  0x72, 0x1F
  call sub_10560                               ; 10847  0xE8, 0x16, 0xFD
  jb loc_10866                                 ; 1084A  0x72, 0x1A
  jmp short loc_10864                          ; 1084C  0xEB, 0x16

sub_1084E:                                     ; 1084E
  cmp byte [0x413], 0xff                       ; 1084E  0x80, 0x3E, 0x13, 0x04, 0xFF
  je loc_10864                                 ; 10853  0x74, 0x0F
  mov cl, 0x44                                 ; 10855  0xB1, 0x44
  call sub_10C23                               ; 10857  0xE8, 0xC9, 0x03
  cmp ax, strict word 0xffff                   ; 1085A  3D FF FF
  je loc_10864                                 ; 1085D  0x74, 0x05
  test ah, 1                                   ; 1085F  0xF6, 0xC4, 0x01
  jne loc_10866                                ; 10862  0x75, 0x02

loc_10864:                                     ; 10864
  clc                                          ; 10864  0xF8
  ret                                          ; 10865  0xC3

loc_10866:                                     ; 10866
  stc                                          ; 10866  0xF9
  ret                                          ; 10867  0xC3

sub_10868:                                     ; 10868
  call sub_10A2B                               ; 10868  0xE8, 0xC0, 0x01
  mov al, [0x413]                              ; 1086B  0xA0, 0x13, 0x04
  mov [0x2af], al                              ; 1086E  0xA2, 0xAF, 0x02
  mov dx, 0x2af                                ; 10871  0xBA, 0xAF, 0x02
  clc                                          ; 10874  0xF8
  ret                                          ; 10875  0xC3

sub_10876:                                     ; 10876
  push di                                      ; 10876  0x57
  call sub_10A2B                               ; 10877  0xE8, 0xB1, 0x01
  pop di                                       ; 1087A  0x5F
  call sub_10AEB                               ; 1087B  0xE8, 0x6D, 0x02
  push di                                      ; 1087E  0x57
  call sub_10ABC                               ; 1087F  0xE8, 0x3A, 0x02
  jb loc_108C4                                 ; 10882  0x72, 0x40
  inc di                                       ; 10884  0x47
  cmp byte [di + 1], 0                         ; 10885  0x80, 0x7D, 0x01, 0x00
  je loc_108C4                                 ; 10889  0x74, 0x39
  call sub_10ABC                               ; 1088B  0xE8, 0x2E, 0x02
  jb loc_10891                                 ; 1088E  0x72, 0x01
  inc di                                       ; 10890  0x47

loc_10891:                                     ; 10891
  cmp word [di], 0x3a3a                        ; 10891  0x81, 0x3D, 0x3A, 0x3A
  jne loc_108C4                                ; 10895  0x75, 0x2D
  pop si                                       ; 10897  0x5E
  db 0x33, 0xDB                                ; 10898  xor bx, bx

loc_1089A:                                     ; 1089A
  db 0x3B, 0xF7                                ; 1089A  cmp si, di
  je loc_108B5                                 ; 1089C  0x74, 0x17
  lodsb                                        ; 1089E  0xAC
  sub al, 0x30                                 ; 1089F  0x2C, 0x30
  cmp al, 9                                    ; 108A1  0x3C, 0x09
  jbe loc_108AD                                ; 108A3  0x76, 0x08
  sub al, 7                                    ; 108A5  0x2C, 0x07
  cmp al, 0xf                                  ; 108A7  0x3C, 0x0F
  jbe loc_108AD                                ; 108A9  0x76, 0x02
  sub al, 0x20                                 ; 108AB  0x2C, 0x20

loc_108AD:                                     ; 108AD
  mov cl, 4                                    ; 108AD  0xB1, 0x04
  shl bl, cl                                   ; 108AF  0xD2, 0xE3
  db 0x02, 0xD8                                ; 108B1  add bl, al
  jmp short loc_1089A                          ; 108B3  0xEB, 0xE5

loc_108B5:                                     ; 108B5
  mov [0x2af], bl                              ; 108B5  0x88, 0x1E, 0xAF, 0x02
  inc di                                       ; 108B9  0x47
  inc di                                       ; 108BA  0x47
  call sub_10AEB                               ; 108BB  0xE8, 0x2D, 0x02
  jmp short loc_108D0                          ; 108BE  0xEB, 0x10

loc_108C0:                                     ; 108C0
  stc                                          ; 108C0  0xF9
  mov al, 0                                    ; 108C1  0xB0, 0x00
  ret                                          ; 108C3  0xC3

loc_108C4:                                     ; 108C4
  pop di                                       ; 108C4  0x5F
  cmp byte [di], 0x3b                          ; 108C5  0x80, 0x3D, 0x3B
  je loc_108D0                                 ; 108C8  0x74, 0x06
  mov si, 0x2bf                                ; 108CA  0xBE, 0xBF, 0x02
  call sub_10A52                               ; 108CD  0xE8, 0x82, 0x01

loc_108D0:                                     ; 108D0
  call sub_10AEB                               ; 108D0  0xE8, 0x18, 0x02
  cmp byte [di], 0                             ; 108D3  0x80, 0x3D, 0x00
  je loc_108EC                                 ; 108D6  0x74, 0x14
  cmp byte [di], 0x3b                          ; 108D8  0x80, 0x3D, 0x3B
  jne loc_108C0                                ; 108DB  0x75, 0xE3
  inc di                                       ; 108DD  0x47
  mov si, 0x2b0                                ; 108DE  0xBE, 0xB0, 0x02
  call sub_10A4E                               ; 108E1  0xE8, 0x6A, 0x01
  call sub_10AEB                               ; 108E4  0xE8, 0x04, 0x02
  cmp byte [di], 0                             ; 108E7  0x80, 0x3D, 0x00
  jne loc_108C0                                ; 108EA  0x75, 0xD4

loc_108EC:                                     ; 108EC
  cmp byte [0x2af], 0xff                       ; 108EC  0x80, 0x3E, 0xAF, 0x02, 0xFF
  je loc_1090C                                 ; 108F1  0x74, 0x19
  mov dx, 0x2af                                ; 108F3  0xBA, 0xAF, 0x02
  clc                                          ; 108F6  0xF8
  ret                                          ; 108F7  0xC3
  pushf                                        ; 108F8  0x9C
  push ax                                      ; 108F9  0x50
  push dx                                      ; 108FA  0x52
  cmp byte [0x41f], 0                          ; 108FB  0x80, 0x3E, 0x1F, 0x04, 0x00
  je loc_10908                                 ; 10900  0x74, 0x06
  mov cl, 0x4a                                 ; 10902  0xB1, 0x4A
  db 0x33, 0xD2                                ; 10904  xor dx, dx
  int 0xe0                                     ; 10906  0xCD, 0xE0

loc_10908:                                     ; 10908
  pop dx                                       ; 10908  0x5A
  pop ax                                       ; 10909  0x58
  popf                                         ; 1090A  0x9D
  ret                                          ; 1090B  0xC3

loc_1090C:                                     ; 1090C
  mov byte [0x41f], 0                          ; 1090C  0xC6, 0x06, 0x1F, 0x04, 0x00
  mov ax, 0xbb8                                ; 10911  0xB8, 0xB8, 0x0B
  push ax                                      ; 10914  0x50
  push ds                                      ; 10915  0x1E
  mov ds, [0]                                  ; 10916  0x8E, 0x1E, 0x00, 0x00
  mov al, [0x4b]                               ; 1091A  0xA0, 0x4B, 0x00
  pop ds                                       ; 1091D  0x1F
  inc al                                       ; 1091E  0xFE, 0xC0
  mov [0x420], al                              ; 10920  0xA2, 0x20, 0x04
  call sub_10A08                               ; 10923  0xE8, 0xE2, 0x00
  je loc_1092A                                 ; 10926  0x74, 0x02
  jmp short loc_10933                          ; 10928  0xEB, 0x09

loc_1092A:                                     ; 1092A
  call sub_109B3                               ; 1092A  0xE8, 0x86, 0x00
  jne loc_10933                                ; 1092D  0x75, 0x04

loc_1092F:                                     ; 1092F
  mov al, 1                                    ; 1092F  0xB0, 0x01
  stc                                          ; 10931  0xF9
  ret                                          ; 10932  0xC3

loc_10933:                                     ; 10933
  mov dx, 0x1d6                                ; 10933  0xBA, 0xD6, 0x01
  mov cl, 0x1a                                 ; 10936  0xB1, 0x1A
  int 0xe0                                     ; 10938  0xCD, 0xE0

loc_1093A:                                     ; 1093A
  mov dx, 0x420                                ; 1093A  0xBA, 0x20, 0x04
  mov cl, 0x14                                 ; 1093D  0xB1, 0x14
  int 0xe0                                     ; 1093F  0xCD, 0xE0
  db 0x0A, 0xC0                                ; 10941  or al, al
  jne loc_1097B                                ; 10943  0x75, 0x36
  mov di, 0x1d6                                ; 10945  0xBF, 0xD6, 0x01
  mov al, [0x2af]                              ; 10948  0xA0, 0xAF, 0x02
  mov cx, 8                                    ; 1094B  0xB9, 0x08, 0x00

loc_1094E:                                     ; 1094E
  cmp byte [di + 8], 0xf                       ; 1094E  0x80, 0x7D, 0x08, 0x0F
  je loc_1097B                                 ; 10952  0x74, 0x27
  cmp byte [di + 8], 1                         ; 10954  0x80, 0x7D, 0x08, 0x01
  jne loc_10973                                ; 10958  0x75, 0x19
  cmp al, 0xff                                 ; 1095A  0x3C, 0xFF
  je loc_10965                                 ; 1095C  0x74, 0x07
  cmp al, [di + 0xa]                           ; 1095E  0x3A, 0x45, 0x0A
  je loc_1098F                                 ; 10961  0x74, 0x2C
  jmp short loc_10973                          ; 10963  0xEB, 0x0E

loc_10965:                                     ; 10965
  push di                                      ; 10965  0x57
  push cx                                      ; 10966  0x51
  mov cx, 4                                    ; 10967  0xB9, 0x04, 0x00
  mov si, 0x2bf                                ; 1096A  0xBE, 0xBF, 0x02
  repe cmpsw                                   ; 1096D  0xF3, 0xA7
  pop cx                                       ; 1096F  0x59
  pop di                                       ; 10970  0x5F
  je loc_1098F                                 ; 10971  0x74, 0x1C

loc_10973:                                     ; 10973
  add di, 0x10                                 ; 10973  0x83, 0xC7, 0x10
  loop loc_1094E                               ; 10976  0xE2, 0xD6
  jmp near loc_1093A                           ; 10978  0xE9, 0xBF, 0xFF

loc_1097B:                                     ; 1097B
  cmp byte [0x2af], 0xff                       ; 1097B  0x80, 0x3E, 0xAF, 0x02, 0xFF
  jne loc_10987                                ; 10980  0x75, 0x05
  mov al, 2                                    ; 10982  0xB0, 0x02
  stc                                          ; 10984  0xF9
  jmp short loc_109A5                          ; 10985  0xEB, 0x1E

loc_10987:                                     ; 10987
  mov byte [0x2bf], 0                          ; 10987  0xC6, 0x06, 0xBF, 0x02, 0x00
  clc                                          ; 1098C  0xF8
  jmp short loc_109A5                          ; 1098D  0xEB, 0x16

loc_1098F:                                     ; 1098F
  mov si, 0x2bf                                ; 1098F  0xBE, 0xBF, 0x02
  xchg si, di                                  ; 10992  87 F7
  mov cx, 4                                    ; 10994  0xB9, 0x04, 0x00
  rep movsw                                    ; 10997  0xF3, 0xA5
  xchg si, di                                  ; 10999  87 F7
  mov al, [di + 2]                             ; 1099B  0x8A, 0x45, 0x02
  mov [0x2af], al                              ; 1099E  0xA2, 0xAF, 0x02
  mov dx, 0x2af                                ; 109A1  0xBA, 0xAF, 0x02
  clc                                          ; 109A4  0xF8

loc_109A5:                                     ; 109A5
  pushf                                        ; 109A5  0x9C
  push ax                                      ; 109A6  0x50
  push dx                                      ; 109A7  0x52
  mov dx, 0x420                                ; 109A8  0xBA, 0x20, 0x04
  mov cl, 0x10                                 ; 109AB  0xB1, 0x10
  int 0xe0                                     ; 109AD  0xCD, 0xE0
  pop dx                                       ; 109AF  0x5A
  pop ax                                       ; 109B0  0x58
  popf                                         ; 109B1  0x9D
  ret                                          ; 109B2  0xC3

sub_109B3:                                     ; 109B3
  mov cl, 0x49                                 ; 109B3  0xB1, 0x49
  db 0x33, 0xD2                                ; 109B5  xor dx, dx
  int 0xe0                                     ; 109B7  0xCD, 0xE0
  db 0x0B, 0xC0                                ; 109B9  or ax, ax
  jne loc_10A05                                ; 109BB  0x75, 0x48
  mov byte [0x41f], 0xff                       ; 109BD  0xC6, 0x06, 0x1F, 0x04, 0xFF
  mov cl, 0x40                                 ; 109C2  0xB1, 0x40
  mov dx, 0x413                                ; 109C4  0xBA, 0x13, 0x04
  int 0xe0                                     ; 109C7  0xCD, 0xE0
  mov di, 0x1d6                                ; 109C9  0xBF, 0xD6, 0x01
  mov al, [0x413]                              ; 109CC  0xA0, 0x13, 0x04
  mov [di], al                                 ; 109CF  0x88, 0x05
  db 0x8B, 0xD7                                ; 109D1  mov dx, di
  mov cl, 0x47                                 ; 109D3  0xB1, 0x47
  int 0xe0                                     ; 109D5  0xCD, 0xE0
  db 0x0B, 0xC0                                ; 109D7  or ax, ax
  je loc_109DE                                 ; 109D9  0x74, 0x03
  jmp near loc_1092F                           ; 109DB  0xE9, 0x51, 0xFF

loc_109DE:                                     ; 109DE
  mov al, [0x1d6]                              ; 109DE  0xA0, 0xD6, 0x01
  mov di, 0x1d6                                ; 109E1  0xBF, 0xD6, 0x01
  mov byte [di], 0                             ; 109E4  0xC6, 0x05, 0x00
  mov byte [di + 1], 0xd                       ; 109E7  0xC6, 0x45, 0x01, 0x0D
  mov byte [0x420], 0xe                        ; 109EB  0xC6, 0x06, 0x20, 0x04, 0x0E
  or al, 0x80                                  ; 109F0  0x0C, 0x80
  mov [di + 2], al                             ; 109F2  0x88, 0x45, 0x02
  mov al, [0x413]                              ; 109F5  0xA0, 0x13, 0x04
  mov [di + 3], al                             ; 109F8  0x88, 0x45, 0x03
  db 0x8B, 0xD7                                ; 109FB  mov dx, di
  mov cl, 0x45                                 ; 109FD  0xB1, 0x45
  int 0xe0                                     ; 109FF  0xCD, 0xE0
  db 0x0B, 0xC0                                ; 10A01  or ax, ax
  je sub_10A08                                 ; 10A03  0x74, 0x03

loc_10A05:                                     ; 10A05
  db 0x33, 0xC0                                ; 10A05  xor ax, ax
  ret                                          ; 10A07  0xC3

sub_10A08:                                     ; 10A08
  mov bx, 0x420                                ; 10A08  0xBB, 0x20, 0x04
  or byte [bx + 6], 0x80                       ; 10A0B  0x80, 0x4F, 0x06, 0x80
  mov word [bx + 0xc], 0                       ; 10A0F  0xC7, 0x47, 0x0C, 0x00, 0x00
  mov word [bx + 0xe], 0                       ; 10A14  0xC7, 0x47, 0x0E, 0x00, 0x00
  mov word [bx + 0x20], 0                      ; 10A19  0xC7, 0x47, 0x20, 0x00, 0x00
  mov byte [bx + 0x22], 0                      ; 10A1E  0xC6, 0x47, 0x22, 0x00
  db 0x8B, 0xD3                                ; 10A22  mov dx, bx
  mov cl, 0xf                                  ; 10A24  0xB1, 0x0F
  int 0xe0                                     ; 10A26  0xCD, 0xE0
  inc al                                       ; 10A28  0xFE, 0xC0
  ret                                          ; 10A2A  0xC3

sub_10A2B:                                     ; 10A2B
  mov di, 0x2af                                ; 10A2B  0xBF, 0xAF, 0x02
  push di                                      ; 10A2E  0x57
  mov ax, ds                                   ; 10A2F  0x8C, 0xD8
  mov es, ax                                   ; 10A31  0x8E, 0xC0
  mov ax, 0x2020                               ; 10A33  0xB8, 0x20, 0x20
  mov cx, 0x10                                 ; 10A36  0xB9, 0x10, 0x00
  rep stosw                                    ; 10A39  0xF3, 0xAB
  mov byte [0x2af], 0xff                       ; 10A3B  0xC6, 0x06, 0xAF, 0x02, 0xFF
  pop di                                       ; 10A40  0x5F
  inc di                                       ; 10A41  0x47
  mov si, 0x414                                ; 10A42  0xBE, 0x14, 0x04
  mov cx, 4                                    ; 10A45  0xB9, 0x04, 0x00
  rep movsw                                    ; 10A48  0xF3, 0xA5
  db 0x33, 0xC0                                ; 10A4A  xor ax, ax
  stosw                                        ; 10A4C  0xAB
  ret                                          ; 10A4D  0xC3

sub_10A4E:                                     ; 10A4E
  mov ah, 0                                    ; 10A4E  0xB4, 0x00
  jmp short loc_10A54                          ; 10A50  0xEB, 0x02

sub_10A52:                                     ; 10A52
  mov ah, 0xff                                 ; 10A52  0xB4, 0xFF

loc_10A54:                                     ; 10A54
  call sub_10AEB                               ; 10A54  0xE8, 0x94, 0x00
  xchg si, di                                  ; 10A57  87 F7
  mov cx, 8                                    ; 10A59  0xB9, 0x08, 0x00

loc_10A5C:                                     ; 10A5C
  lodsb                                        ; 10A5C  0xAC
  cmp al, 0                                    ; 10A5D  0x3C, 0x00
  je loc_10A82                                 ; 10A5F  0x74, 0x21
  cmp al, 0x3b                                 ; 10A61  0x3C, 0x3B
  je loc_10A82                                 ; 10A63  0x74, 0x1D
  cmp al, 0x20                                 ; 10A65  0x3C, 0x20
  je loc_10A82                                 ; 10A67  0x74, 0x19
  cmp al, 9                                    ; 10A69  0x3C, 0x09
  je loc_10A82                                 ; 10A6B  0x74, 0x15
  cmp ah, 0                                    ; 10A6D  0x80, 0xFC, 0x00
  je loc_10A7C                                 ; 10A70  0x74, 0x0A
  cmp al, 0x61                                 ; 10A72  0x3C, 0x61
  jb loc_10A7C                                 ; 10A74  0x72, 0x06
  cmp al, 0x7d                                 ; 10A76  0x3C, 0x7D
  ja loc_10A7C                                 ; 10A78  0x77, 0x02
  sub al, 0x20                                 ; 10A7A  0x2C, 0x20

loc_10A7C:                                     ; 10A7C
  stosb                                        ; 10A7C  0xAA
  loop loc_10A5C                               ; 10A7D  0xE2, 0xDD

loc_10A7F:                                     ; 10A7F
  xchg si, di                                  ; 10A7F  87 F7
  ret                                          ; 10A81  0xC3

loc_10A82:                                     ; 10A82
  mov al, 0x20                                 ; 10A82  0xB0, 0x20
  rep stosb                                    ; 10A84  0xF3, 0xAA
  dec si                                       ; 10A86  0x4E
  jmp short loc_10A7F                          ; 10A87  0xEB, 0xF6
  mov bx, 0x2bf                                ; 10A89  0xBB, 0xBF, 0x02
  cmp byte [bx], 0                             ; 10A8C  0x80, 0x3F, 0x00
  jne loc_10AB3                                ; 10A8F  0x75, 0x22
  mov al, [0x2af]                              ; 10A91  0xA0, 0xAF, 0x02

sub_10A94:                                     ; 10A94
  push ax                                      ; 10A94  0x50
  mov cl, 4                                    ; 10A95  0xB1, 0x04
  shr al, cl                                   ; 10A97  0xD2, 0xE8
  call sub_10A9D                               ; 10A99  0xE8, 0x01, 0x00
  pop ax                                       ; 10A9C  0x58

sub_10A9D:                                     ; 10A9D
  and al, 0xf                                  ; 10A9D  0x24, 0x0F
  add al, 0x90                                 ; 10A9F  0x04, 0x90
  db 0x27                                      ; 10AA1  daa
  adc al, 0x40                                 ; 10AA2  0x14, 0x40
  db 0x27                                      ; 10AA4  daa
  db 0x8A, 0xD0                                ; 10AA5  mov dl, al
  jmp near sub_10B97                           ; 10AA7  0xE9, 0xED, 0x00
  push ax                                      ; 10AAA  0x50
  db 0x8A, 0xC4                                ; 10AAB  mov al, ah
  call sub_10A94                               ; 10AAD  0xE8, 0xE4, 0xFF
  pop ax                                       ; 10AB0  0x58
  jmp short sub_10A94                          ; 10AB1  0xEB, 0xE1

loc_10AB3:                                     ; 10AB3
  mov byte [bx + 8], 0                         ; 10AB3  0xC6, 0x47, 0x08, 0x00
  db 0x8B, 0xD3                                ; 10AB7  mov dx, bx
  jmp near sub_10BB0                           ; 10AB9  0xE9, 0xF4, 0x00

sub_10ABC:                                     ; 10ABC
  mov al, [di]                                 ; 10ABC  0x8A, 0x05
  cmp al, 0x30                                 ; 10ABE  0x3C, 0x30
  jb loc_10AD8                                 ; 10AC0  0x72, 0x16
  cmp al, 0x39                                 ; 10AC2  0x3C, 0x39
  jbe loc_10ADA                                ; 10AC4  0x76, 0x14
  cmp al, 0x41                                 ; 10AC6  0x3C, 0x41
  jb loc_10AD8                                 ; 10AC8  0x72, 0x0E
  cmp al, 0x46                                 ; 10ACA  0x3C, 0x46
  jbe loc_10ADA                                ; 10ACC  0x76, 0x0C
  and al, 0x5f                                 ; 10ACE  0x24, 0x5F
  cmp al, 0x41                                 ; 10AD0  0x3C, 0x41
  jb loc_10AD8                                 ; 10AD2  0x72, 0x04
  cmp al, 0x46                                 ; 10AD4  0x3C, 0x46
  jbe loc_10ADA                                ; 10AD6  0x76, 0x02

loc_10AD8:                                     ; 10AD8
  stc                                          ; 10AD8  0xF9
  ret                                          ; 10AD9  0xC3

loc_10ADA:                                     ; 10ADA
  clc                                          ; 10ADA  0xF8
  ret                                          ; 10ADB  0xC3

loc_10ADC:                                     ; 10ADC
  call sub_10BA6                               ; 10ADC  0xE8, 0xC7, 0x00
  jmp near loc_0FED9                           ; 10ADF  0xE9, 0xF7, 0xF3

sub_10AE2:                                     ; 10AE2
  mov cl, 0x6d                                 ; 10AE2  0xB1, 0x6D
  mov dx, 9                                    ; 10AE4  0xBA, 0x09, 0x00
  jmp near sub_10C23                           ; 10AE7  0xE9, 0x39, 0x01

loc_10AEA:                                     ; 10AEA
  inc di                                       ; 10AEA  0x47

sub_10AEB:                                     ; 10AEB
  cmp byte [di], 0x20                          ; 10AEB  0x80, 0x3D, 0x20
  je loc_10AEA                                 ; 10AEE  0x74, 0xFA
  cmp byte [di], 9                             ; 10AF0  0x80, 0x3D, 0x09
  je loc_10AEA                                 ; 10AF3  0x74, 0xF5
  ret                                          ; 10AF5  0xC3

sub_10AF6:                                     ; 10AF6
  mov cx, 0x98                                 ; 10AF6  0xB9, 0x98, 0x00
  mov bx, 0x25c                                ; 10AF9  0xBB, 0x5C, 0x02
  mov [bx], di                                 ; 10AFC  0x89, 0x3F
  mov [bx + 2], si                             ; 10AFE  0x89, 0x77, 0x02
  db 0x8B, 0xD3                                ; 10B01  mov dx, bx
  jmp near sub_10C23                           ; 10B03  0xE9, 0x1D, 0x01

sub_10B06:                                     ; 10B06
  cmp dh, 0x20                                 ; 10B06  0x80, 0xFE, 0x20
  jne loc_10B0F                                ; 10B09  0x75, 0x04
  db 0x8A, 0xF2                                ; 10B0B  mov dh, dl
  mov dl, 0x30                                 ; 10B0D  0xB2, 0x30

loc_10B0F:                                     ; 10B0F
  sub dh, 0x30                                 ; 10B0F  0x80, 0xEE, 0x30
  js loc_10B32                                 ; 10B12  0x78, 0x1E
  cmp dh, 9                                    ; 10B14  0x80, 0xFE, 0x09
  ja loc_10B32                                 ; 10B17  0x77, 0x19
  sub dl, 0x30                                 ; 10B19  0x80, 0xEA, 0x30
  js loc_10B32                                 ; 10B1C  0x78, 0x14
  cmp dl, 9                                    ; 10B1E  0x80, 0xFA, 0x09
  ja loc_10B32                                 ; 10B21  0x77, 0x0F
  db 0x8A, 0xC2                                ; 10B23  mov al, dl
  mov cl, 0xa                                  ; 10B25  0xB1, 0x0A
  db 0xF6, 0xE1                                ; 10B27  mul cl
  db 0x8A, 0xD6                                ; 10B29  mov dl, dh
  db 0x32, 0xF6                                ; 10B2B  xor dh, dh
  db 0x03, 0xC2                                ; 10B2D  add ax, dx
  db 0x8B, 0xD8                                ; 10B2F  mov bx, ax
  ret                                          ; 10B31  0xC3

loc_10B32:                                     ; 10B32
  mov bl, 0xff                                 ; 10B32  0xB3, 0xFF
  ret                                          ; 10B34  0xC3

sub_10B35:                                     ; 10B35
  cld                                          ; 10B35  0xFC
  mov cx, 0xa                                  ; 10B36  0xB9, 0x0A, 0x00
  db 0x33, 0xDB                                ; 10B39  xor bx, bx
  db 0x32, 0xE4                                ; 10B3B  xor ah, ah

loc_10B3D:                                     ; 10B3D
  lodsb                                        ; 10B3D  0xAC
  cmp al, 0x30                                 ; 10B3E  0x3C, 0x30
  jb loc_10B50                                 ; 10B40  0x72, 0x0E
  cmp al, 0x39                                 ; 10B42  0x3C, 0x39
  ja loc_10B50                                 ; 10B44  0x77, 0x0A
  sub al, 0x30                                 ; 10B46  0x2C, 0x30
  xchg bx, ax                                  ; 10B48  0x93
  db 0xF7, 0xE1                                ; 10B49  mul cx
  xchg bx, ax                                  ; 10B4B  0x93
  db 0x03, 0xD8                                ; 10B4C  add bx, ax
  jmp short loc_10B3D                          ; 10B4E  0xEB, 0xED

loc_10B50:                                     ; 10B50
  db 0x8B, 0xC3                                ; 10B50  mov ax, bx
  ret                                          ; 10B52  0xC3

sub_10B53:                                     ; 10B53
  push di                                      ; 10B53  0x57
  db 0x33, 0xF6                                ; 10B54  xor si, si

loc_10B56:                                     ; 10B56
  db 0x2B, 0xD2                                ; 10B56  sub dx, dx
  db 0xF7, 0xBC, 0xF0, 0x03                    ; 10B58  idiv word [si + 0x3f0]
  add al, 0x30                                 ; 10B5C  0x04, 0x30
  mov [di], al                                 ; 10B5E  0x88, 0x05
  inc si                                       ; 10B60  0x46
  inc si                                       ; 10B61  0x46
  inc di                                       ; 10B62  0x47
  db 0x8B, 0xC2                                ; 10B63  mov ax, dx
  cmp si, 6                                    ; 10B65  0x83, 0xFE, 0x06
  jne loc_10B56                                ; 10B68  0x75, 0xEC
  mov cx, 2                                    ; 10B6A  0xB9, 0x02, 0x00
  pop di                                       ; 10B6D  0x5F

loc_10B6E:                                     ; 10B6E
  cmp byte [di], 0x30                          ; 10B6E  0x80, 0x3D, 0x30
  jne loc_10B79                                ; 10B71  0x75, 0x06
  mov byte [di], 0x20                          ; 10B73  0xC6, 0x05, 0x20
  inc di                                       ; 10B76  0x47
  loop loc_10B6E                               ; 10B77  0xE2, 0xF5

loc_10B79:                                     ; 10B79
  ret                                          ; 10B79  0xC3

sub_10B7A:                                     ; 10B7A
  cmp al, 0x41                                 ; 10B7A  0x3C, 0x41
  jb loc_10B84                                 ; 10B7C  0x72, 0x06
  cmp al, 0x5a                                 ; 10B7E  0x3C, 0x5A
  ja loc_10B84                                 ; 10B80  0x77, 0x02
  add al, 0x20                                 ; 10B82  0x04, 0x20

loc_10B84:                                     ; 10B84
  ret                                          ; 10B84  0xC3

sub_10B85:                                     ; 10B85
  cmp dl, 0xa                                  ; 10B85  0x80, 0xFA, 0x0A
  jb loc_10B94                                 ; 10B88  0x72, 0x0A
  push dx                                      ; 10B8A  0x52
  mov dl, 0x31                                 ; 10B8B  0xB2, 0x31
  call sub_10B97                               ; 10B8D  0xE8, 0x07, 0x00
  pop dx                                       ; 10B90  0x5A
  sub dl, 0xa                                  ; 10B91  0x80, 0xEA, 0x0A

loc_10B94:                                     ; 10B94
  add dl, 0x30                                 ; 10B94  0x80, 0xC2, 0x30

sub_10B97:                                     ; 10B97
  mov cl, 2                                    ; 10B97  0xB1, 0x02
  jmp near sub_10C23                           ; 10B99  0xE9, 0x87, 0x00

sub_10B9C:                                     ; 10B9C
  mov dl, 0xff                                 ; 10B9C  0xB2, 0xFF

sub_10B9E:                                     ; 10B9E
  mov cl, 0x20                                 ; 10B9E  0xB1, 0x20
  jmp near sub_10C23                           ; 10BA0  0xE9, 0x80, 0x00

sub_10BA3:                                     ; 10BA3
  mov dx, 0x10ad                               ; 10BA3  0xBA, 0xAD, 0x10

sub_10BA6:                                     ; 10BA6
  push ds                                      ; 10BA6  0x1E
  mov ax, cs                                   ; 10BA7  0x8C, 0xC8
  mov ds, ax                                   ; 10BA9  0x8E, 0xD8
  call sub_10BB0                               ; 10BAB  0xE8, 0x02, 0x00
  pop ds                                       ; 10BAE  0x1F
  ret                                          ; 10BAF  0xC3

sub_10BB0:                                     ; 10BB0
  mov cl, 9                                    ; 10BB0  0xB1, 0x09
  jmp short sub_10C23                          ; 10BB2  0xEB, 0x6F

sub_10BB4:                                     ; 10BB4
  push ds                                      ; 10BB4  0x1E
  jmp short loc_10BB8                          ; 10BB5  0xEB, 0x01

sub_10BB7:                                     ; 10BB7
  push cs                                      ; 10BB7  0x0E

loc_10BB8:                                     ; 10BB8
  push dx                                      ; 10BB8  0x52
  mov dx, 0xffff                               ; 10BB9  0xBA, 0xFF, 0xFF
  mov cl, 0x6d                                 ; 10BBC  0xB1, 0x6D
  call sub_10C23                               ; 10BBE  0xE8, 0x62, 0x00
  pop dx                                       ; 10BC1  0x5A
  pop bx                                       ; 10BC2  0x5B
  push ds                                      ; 10BC3  0x1E
  push ax                                      ; 10BC4  0x50
  push dx                                      ; 10BC5  0x52
  push bx                                      ; 10BC6  0x53
  or ax, strict word 4                         ; 10BC7  0D 04 00
  db 0x8B, 0xD0                                ; 10BCA  mov dx, ax
  mov cl, 0x6d                                 ; 10BCC  0xB1, 0x6D
  call sub_10C23                               ; 10BCE  0xE8, 0x52, 0x00
  pop ds                                       ; 10BD1  0x1F
  pop dx                                       ; 10BD2  0x5A
  call sub_10BB0                               ; 10BD3  0xE8, 0xDA, 0xFF
  pop dx                                       ; 10BD6  0x5A
  mov cl, 0x6d                                 ; 10BD7  0xB1, 0x6D
  call sub_10C23                               ; 10BD9  0xE8, 0x47, 0x00
  pop ds                                       ; 10BDC  0x1F
  ret                                          ; 10BDD  0xC3

sub_10BDE:                                     ; 10BDE
  mov cl, 0x94                                 ; 10BDE  0xB1, 0x94
  jmp short sub_10C23                          ; 10BE0  0xEB, 0x41

sub_10BE2:                                     ; 10BE2
  call sub_10BE8                               ; 10BE2  0xE8, 0x03, 0x00
  jmp near sub_10D9F                           ; 10BE5  0xE9, 0xB7, 0x01

sub_10BE8:                                     ; 10BE8
  mov cl, 0xe                                  ; 10BE8  0xB1, 0x0E
  jmp near sub_10C23                           ; 10BEA  0xE9, 0x36, 0x00

sub_10BED:                                     ; 10BED
  mov cl, 0x19                                 ; 10BED  0xB1, 0x19
  jmp short sub_10C23                          ; 10BEF  0xEB, 0x32

sub_10BF1:                                     ; 10BF1
  mov cl, 0xa0                                 ; 10BF1  0xB1, 0xA0
  jmp short sub_10C23                          ; 10BF3  0xEB, 0x2E

sub_10BF5:                                     ; 10BF5
  mov cl, 0xa4                                 ; 10BF5  0xB1, 0xA4
  jmp short sub_10C23                          ; 10BF7  0xEB, 0x2A

sub_10BF9:                                     ; 10BF9
  mov cl, 0xa2                                 ; 10BF9  0xB1, 0xA2
  jmp short sub_10C23                          ; 10BFB  0xEB, 0x26

sub_10BFD:                                     ; 10BFD
  mov cl, 0x93                                 ; 10BFD  0xB1, 0x93
  jmp short sub_10C23                          ; 10BFF  0xEB, 0x22

sub_10C01:                                     ; 10C01
  mov cl, 0xa                                  ; 10C01  0xB1, 0x0A
  jmp short sub_10C23                          ; 10C03  0xEB, 0x1E
  mov cl, 0x27                                 ; 10C05  0xB1, 0x27
  jmp short sub_10C23                          ; 10C07  0xEB, 0x1A

sub_10C09:                                     ; 10C09
  mov [0x410], ax                              ; 10C09  0xA3, 0x10, 0x04
  push ds                                      ; 10C0C  0x1E
  mov ds, [0]                                  ; 10C0D  0x8E, 0x1E, 0x00, 0x00
  mov [0x4c], ax                               ; 10C11  0xA3, 0x4C, 0x00
  pop ds                                       ; 10C14  0x1F
  ret                                          ; 10C15  0xC3

sub_10C16:                                     ; 10C16
  push ds                                      ; 10C16  0x1E
  mov ds, [0]                                  ; 10C17  0x8E, 0x1E, 0x00, 0x00
  mov ax, [0x4c]                               ; 10C1B  0xA1, 0x4C, 0x00
  pop ds                                       ; 10C1E  0x1F
  mov [0x410], ax                              ; 10C1F  0xA3, 0x10, 0x04
  ret                                          ; 10C22  0xC3

sub_10C23:                                     ; 10C23
  int 0xe0                                     ; 10C23  0xCD, 0xE0
  ret                                          ; 10C25  0xC3

sub_10C26:                                     ; 10C26
  mov word [0x1d0], 0                          ; 10C26  0xC7, 0x06, 0xD0, 0x01, 0x00, 0x00
  mov cl, 0x8a                                 ; 10C2C  0xB1, 0x8A
  mov dx, 0x3e0                                ; 10C2E  0xBA, 0xE0, 0x03
  int 0xe0                                     ; 10C31  0xCD, 0xE0
  db 0x0B, 0xC0                                ; 10C33  or ax, ax
  jne loc_10C81                                ; 10C35  0x75, 0x4A
  mov byte [0x259], 0                          ; 10C37  0xC6, 0x06, 0x59, 0x02, 0x00
  mov byte [0x3f9], 0x20                       ; 10C3C  0xC6, 0x06, 0xF9, 0x03, 0x20
  mov byte [0x3f8], 0x37                       ; 10C41  0xC6, 0x06, 0xF8, 0x03, 0x37
  mov dx, 0x3f6                                ; 10C46  0xBA, 0xF6, 0x03
  call sub_10BB0                               ; 10C49  0xE8, 0x64, 0xFF
  push es                                      ; 10C4C  0x06
  mov ax, cs                                   ; 10C4D  0x8C, 0xC8
  mov es, ax                                   ; 10C4F  0x8E, 0xC0
  mov di, 0x158a                               ; 10C51  0xBF, 0x8A, 0x15
  mov si, 0x148                                ; 10C54  0xBE, 0x48, 0x01
  mov cx, 9                                    ; 10C57  0xB9, 0x09, 0x00
  repe cmpsb                                   ; 10C5A  0xF3, 0xA6
  pop es                                       ; 10C5C  0x07
  je loc_10C66                                 ; 10C5D  0x74, 0x07
  mov byte [0x1d2], 1                          ; 10C5F  0xC6, 0x06, 0xD2, 0x01, 0x01
  jmp short loc_10CAF                          ; 10C64  0xEB, 0x49

loc_10C66:                                     ; 10C66
  mov byte [0x3f9], 0x20                       ; 10C66  0xC6, 0x06, 0xF9, 0x03, 0x20
  mov byte [0x3f8], 0x36                       ; 10C6B  0xC6, 0x06, 0xF8, 0x03, 0x36
  mov dx, 0x3f6                                ; 10C70  0xBA, 0xF6, 0x03
  call sub_10BB4                               ; 10C73  0xE8, 0x3E, 0xFF
  mov dx, 0x1593                               ; 10C76  0xBA, 0x93, 0x15
  call sub_10BB7                               ; 10C79  0xE8, 0x3B, 0xFF
  mov byte [0x259], 0xff                       ; 10C7C  0xC6, 0x06, 0x59, 0x02, 0xFF

loc_10C81:                                     ; 10C81
  mov byte [0x1d2], 0                          ; 10C81  0xC6, 0x06, 0xD2, 0x01, 0x00
  cmp byte [0x259], 0                          ; 10C86  0x80, 0x3E, 0x59, 0x02, 0x00
  je loc_10C95                                 ; 10C8B  0x74, 0x08
  mov byte [0x259], 0                          ; 10C8D  0xC6, 0x06, 0x59, 0x02, 0x00
  call sub_10BA3                               ; 10C92  0xE8, 0x0E, 0xFF

loc_10C95:                                     ; 10C95
  call sub_10D67                               ; 10C95  0xE8, 0xCF, 0x00
  cmp byte [0x412], 0xff                       ; 10C98  0x80, 0x3E, 0x12, 0x04, 0xFF
  je loc_10CA7                                 ; 10C9D  0x74, 0x08
  mov dx, 0x148                                ; 10C9F  0xBA, 0x48, 0x01
  call sub_10C01                               ; 10CA2  0xE8, 0x5C, 0xFF
  jmp short loc_10CAA                          ; 10CA5  0xEB, 0x03

loc_10CA7:                                     ; 10CA7
  call sub_10CB0                               ; 10CA7  0xE8, 0x06, 0x00

loc_10CAA:                                     ; 10CAA
  mov dl, 0xa                                  ; 10CAA  0xB2, 0x0A
  call sub_10B97                               ; 10CAC  0xE8, 0xE8, 0xFE

loc_10CAF:                                     ; 10CAF
  ret                                          ; 10CAF  0xC3

sub_10CB0:                                     ; 10CB0
  mov dl, 1                                    ; 10CB0  0xB2, 0x01
  mov cl, 0x6e                                 ; 10CB2  0xB1, 0x6E
  call sub_10C23                               ; 10CB4  0xE8, 0x6C, 0xFF
  mov dx, 0x1596                               ; 10CB7  0xBA, 0x96, 0x15
  call sub_10BB7                               ; 10CBA  0xE8, 0xFA, 0xFE
  mov dl, 0                                    ; 10CBD  0xB2, 0x00
  mov cl, 0x6e                                 ; 10CBF  0xB1, 0x6E
  call sub_10C23                               ; 10CC1  0xE8, 0x5F, 0xFF
  call sub_10D14                               ; 10CC4  0xE8, 0x4D, 0x00
  call sub_10D5F                               ; 10CC7  0xE8, 0x95, 0x00
  push bx                                      ; 10CCA  0x53
  mov ax, 0x15                                 ; 10CCB  0xB8, 0x15, 0x00
  int 0x28                                     ; 10CCE  0xCD, 0x28
  pop ax                                       ; 10CD0  0x58
  db 0x8A, 0xC4                                ; 10CD1  mov al, ah
  db 0x98                                      ; 10CD3  cwde
  shl ax, 1                                    ; 10CD4  0xD1, 0xE0
  db 0x03, 0xD8                                ; 10CD6  add bx, ax
  mov si, [es:bx]                              ; 10CD8  0x26, 0x8B, 0x37
  mov bx, ds                                   ; 10CDB  0x8C, 0xDB
  mov ds, dx                                   ; 10CDD  0x8E, 0xDA
  mov es, bx                                   ; 10CDF  0x8E, 0xC3
  mov di, 0x14a                                ; 10CE1  0xBF, 0x4A, 0x01
  mov cx, 0x50                                 ; 10CE4  0xB9, 0x50, 0x00
  cld                                          ; 10CE7  0xFC

loc_10CE8:                                     ; 10CE8
  lodsw                                        ; 10CE8  0xAD
  stosb                                        ; 10CE9  0xAA
  loop loc_10CE8                               ; 10CEA  0xE2, 0xFC
  mov ds, bx                                   ; 10CEC  0x8E, 0xDB
  mov byte [0x149], 0x50                       ; 10CEE  0xC6, 0x06, 0x49, 0x01, 0x50
  mov di, 0x14a                                ; 10CF3  0xBF, 0x4A, 0x01
  mov cx, 4                                    ; 10CF6  0xB9, 0x04, 0x00
  mov al, [cs:0x15e5]                          ; 10CF9  0x2E, 0xA0, 0xE5, 0x15
  repne scasb                                  ; 10CFD  0xF2, 0xAE
  jne loc_10D13                                ; 10CFF  0x75, 0x12
  db 0x8B, 0xF7                                ; 10D01  mov si, di
  mov di, 0x14a                                ; 10D03  0xBF, 0x4A, 0x01
  sub cl, 4                                    ; 10D06  0x80, 0xE9, 0x04
  add cl, [0x149]                              ; 10D09  0x02, 0x0E, 0x49, 0x01
  mov [0x149], cl                              ; 10D0D  0x88, 0x0E, 0x49, 0x01
  rep movsb                                    ; 10D11  0xF3, 0xA4

loc_10D13:                                     ; 10D13
  ret                                          ; 10D13  0xC3

sub_10D14:                                     ; 10D14
  mov cl, 6                                    ; 10D14  0xB1, 0x06
  mov dl, 0xfd                                 ; 10D16  0xB2, 0xFD
  call sub_10C23                               ; 10D18  0xE8, 0x08, 0xFF
  cmp al, 9                                    ; 10D1B  0x3C, 0x09
  je loc_10D35                                 ; 10D1D  0x74, 0x16
  cmp al, 0xc                                  ; 10D1F  0x3C, 0x0C
  je loc_10D48                                 ; 10D21  0x74, 0x25
  cmp al, 0x7f                                 ; 10D23  0x3C, 0x7F
  je loc_10D57                                 ; 10D25  0x74, 0x30
  push ax                                      ; 10D27  0x50
  db 0x8A, 0xD0                                ; 10D28  mov dl, al
  mov cl, 2                                    ; 10D2A  0xB1, 0x02
  call sub_10C23                               ; 10D2C  0xE8, 0xF4, 0xFE
  pop ax                                       ; 10D2F  0x58
  cmp al, 0xd                                  ; 10D30  0x3C, 0x0D
  jne sub_10D14                                ; 10D32  0x75, 0xE0
  ret                                          ; 10D34  0xC3

loc_10D35:                                     ; 10D35
  mov dx, 0x15a5                               ; 10D35  0xBA, 0xA5, 0x15
  call sub_10BB7                               ; 10D38  0xE8, 0x7C, 0xFE
  call sub_10D5F                               ; 10D3B  0xE8, 0x21, 0x00
  cmp al, 0x4f                                 ; 10D3E  0x3C, 0x4F
  je sub_10D14                                 ; 10D40  0x74, 0xD2
  and al, 7                                    ; 10D42  0x24, 0x07
  je sub_10D14                                 ; 10D44  0x74, 0xCE
  jmp short loc_10D35                          ; 10D46  0xEB, 0xED

loc_10D48:                                     ; 10D48
  mov dx, 0x15ab                               ; 10D48  0xBA, 0xAB, 0x15
  call sub_10BB7                               ; 10D4B  0xE8, 0x69, 0xFE
  call sub_10D5F                               ; 10D4E  0xE8, 0x0E, 0x00
  and al, 7                                    ; 10D51  0x24, 0x07
  je sub_10D14                                 ; 10D53  0x74, 0xBF
  jmp short loc_10D48                          ; 10D55  0xEB, 0xF1

loc_10D57:                                     ; 10D57
  mov dx, 0x15df                               ; 10D57  0xBA, 0xDF, 0x15
  call sub_10BB7                               ; 10D5A  0xE8, 0x5A, 0xFE
  jmp short sub_10D14                          ; 10D5D  0xEB, 0xB5

sub_10D5F:                                     ; 10D5F
  mov ax, 0x16                                 ; 10D5F  0xB8, 0x16, 0x00
  int 0x28                                     ; 10D62  0xCD, 0x28
  db 0x8B, 0xC3                                ; 10D64  mov ax, bx
  ret                                          ; 10D66  0xC3

sub_10D67:                                     ; 10D67
  mov dl, 0xd                                  ; 10D67  0xB2, 0x0D
  call sub_10B97                               ; 10D69  0xE8, 0x2B, 0xFE
  call sub_10B9C                               ; 10D6C  0xE8, 0x2D, 0xFE
  test bl, bl                                  ; 10D6F  0x84, 0xDB
  je loc_10D78                                 ; 10D71  0x74, 0x05
  db 0x8A, 0xD3                                ; 10D73  mov dl, bl
  call sub_10B85                               ; 10D75  0xE8, 0x0D, 0xFE

loc_10D78:                                     ; 10D78
  call sub_10BED                               ; 10D78  0xE8, 0x72, 0xFE
  mov dl, 0x61                                 ; 10D7B  0xB2, 0x61
  cmp byte [0x412], 0xff                       ; 10D7D  0x80, 0x3E, 0x12, 0x04, 0xFF
  je loc_10D86                                 ; 10D82  0x74, 0x02
  mov dl, 0x41                                 ; 10D84  0xB2, 0x41

loc_10D86:                                     ; 10D86
  db 0x02, 0xD3                                ; 10D86  add dl, bl
  call sub_10B97                               ; 10D88  0xE8, 0x0C, 0xFE
  mov dx, 0x15e5                               ; 10D8B  0xBA, 0xE5, 0x15
  call sub_10BA6                               ; 10D8E  0xE8, 0x15, 0xFE
  cmp byte [0x412], 0xff                       ; 10D91  0x80, 0x3E, 0x12, 0x04, 0xFF
  je loc_10D9E                                 ; 10D96  0x74, 0x06

sub_10D98:                                     ; 10D98
  mov dx, 0x15cf                               ; 10D98  0xBA, 0xCF, 0x15
  call sub_10BB7                               ; 10D9B  0xE8, 0x19, 0xFE

loc_10D9E:                                     ; 10D9E
  ret                                          ; 10D9E  0xC3

sub_10D9F:                                     ; 10D9F
  cmp al, 0xff                                 ; 10D9F  0x3C, 0xFF
  stc                                          ; 10DA1  0xF9
  jne loc_10DB8                                ; 10DA2  0x75, 0x14
  cmp ah, 1                                    ; 10DA4  0x80, 0xFC, 0x01
  jb loc_10DB8                                 ; 10DA7  0x72, 0x0F
  db 0x8A, 0xDC                                ; 10DA9  mov bl, ah
  db 0x32, 0xFF                                ; 10DAB  xor bh, bh
  shl bx, 1                                    ; 10DAD  0xD1, 0xE3
  mov dx, [cs:bx + 0x1247]                     ; 10DAF  0x2E, 0x8B, 0x97, 0x47, 0x12
  call sub_10BA6                               ; 10DB4  0xE8, 0xEF, 0xFD
  clc                                          ; 10DB7  0xF8

loc_10DB8:                                     ; 10DB8
  ret                                          ; 10DB8  0xC3
; --- CCP/M Fejlbesked Pointer-Tabel (0x10DB9) ---
  dw 0x001F, 0x0000, 0x0003, 0x10BF, 0x000C, 0x10D0, 0x0018, 0x11E7
  dw 0x0017, 0x118C, 0x0026, 0x11C4, 0x0019, 0x11E7, 0x001C, 0x10E0
  dw 0x001D, 0x10E0, 0x001E, 0x10F5, 0x000F, 0x110C, 0x0028, 0x1123
  dw 0xFFFF, 0x10E0, 0x0A0D
  db 0x00

; --- CCP/M Fejlbeskeder (0x10DF0) ---
  db "  CCP/M fejl: ", 0
  db "For lidt lager", 0x0D, 0x0A, 0
  db "PD tabel fuld", 0x0D, 0x0A, 0
  db "Program indl", æ, "sning", 0x0D, 0x0A, 0
  db "Kommando findes ikke", 0x0D, 0x0A, 0
  db "RSP kommando k", ø, " fuld", 0x0D, 0x0A, 0
  db "Kommando fortolkning afbrudt", 0x0D, 0x0A, 0
  db 0
  db "Diskette fejl", 0x0D, 0x0A, 0
  db "Disketten skrive beskyttet", 0x0D, 0x0A, 0
  db "Filen er skrive beskyttet", 0x0D, 0x0A, 0
  db "Ulovlig diskbetegnelse", 0x0D, 0x0A, 0
  db "Filen er i brug", 0x0D, 0x0A, 0
  db "Lukke fejl", 0x0D, 0x0A, 0
  db "L", ø, "sen passer ikke", 0x0D, 0x0A, 0
  db "Filen findes", 0x0D, 0x0A, 0
  db "Ulovligt filnavn", 0x0D, 0x0A, 0
  db "Ingen plads i system listen", 0x0D, 0x0A, 0
  db "V", æ, "rt fejl", 0x0D, 0x0A, 0
  db "Netbruger fejl", 0x0D, 0x0A, 0
  db "Fysisk net fejl", 0x0D, 0x0A, 0

; --- RC-Net Statusbesked Pointer-Tabel (0x10F87) ---
  dw 0x1142, 0x1143, 0x1153, 0x1170, 0x118C, 0x11A5, 0x11B7, 0x11C4
  dw 0x11D8, 0x11E7, 0x11FA, 0x11FA, 0x1218, 0x1224, 0x1235

; --- RC-Net Statusbeskeder & Terminalsekvenser (0x10FA5) ---
  db "Tilmeldt nettet", 0x0D, 0x0A, 0
  db "Kan ikke tilmeldes nettet", 0x0D, 0x0A, 0
  db "Afmeldt nettet", 0x0D, 0x0A, 0
  db "Ikke tilmeldt nettet", 0x0D, 0x0A, 0
  db "Forbindelsen er oprettet", 0x0D, 0x0A, 0
  db "Forbindelsen kan ikke oprettes", 0x0D, 0x0A, 0
  db "Forbindelsen er nedlagt", 0x0D, 0x0A, 0
  db "Forbindelsen kan ikke nedl", æ, "gges", 0x0D, 0x0A, 0
  db ";", 0x13, Å, 0x13, "O", 0x13, "v", 0x13, "Ulovligt argument", 0x0D, 0x0A, 0
  db "Navn ukendt", 0x0D, 0x0A, 0
  db "Navnetabel findes ikke", 0x0D, 0x0A, 0
  db "V", æ, "rten svarer ikke", 0x0D, 0x0A, 0
  db "Kan ikke oprette til eget nummer", 0x0D, 0x0A, 0
  db "Kan ikke afbryde fra eget nummer", 0x0D, 0x0A, 0
  db "Mangler argument(er)", 0x0D, 0x0A, 0
  db "Navngivning fejlet", 0x0D, 0x0A, 0
  db "Fejlet", 0x0D, 0x0A, 0
  db "Program l", ø, "sen: ", 0
  db "  Kommando = ", 0
  db "Ulovligt bruger nummer", 0x0D, 0x0A, 0
  db "Bruger nummer er ", 0
  db "Ulovligt skriver nummer", 0x0D, 0x0A, 0
  db "Skriver nummer er ", 0
  db 0x0D, 0x0A, "Menu k", ø, " kan ikke oprettes", 0x0D, 0x0A, 0
  db 0x0D, 0x0A, "Menu k", ø, " kan ikke ", å, "bnes", 0x0D, 0x0A, 0
  db "Ulovlig lagergr", æ, "nse, (16-768 K)", 0x0D, 0x0A, 0
  db "Indbyggede kommandoer:", 0
  db "   ", 0
  db "Ulovlig parameter", 0
  db "Ingen fil(er)", 0
  db "Katalog for ", 0
  db "bruger nr. ", 0
  db "System filer findes", 0
  db 0x0D, 0x0A, "DIR Stoppet af brugeren", 0
  db "Abort fejlet", 0x0D, 0x0A, 0
  db "Aborteret", 0x0D, 0x0A, 0
  db "Ulovligt konsol nr.", 0x0D, 0x0A, 0
  db 0x80, 0
  db 0
  db "Scroll", 0x1B, "M", 0
  db 0x1B, ":H", 0x1B, "A", 0
  db 0x1B, ":P", 0x1B, "B", 0
  db 0x1B, ":M", 0x1B, "C", 0
  db 0x1B, ":K", 0x1B, "D", 0
  db 0x1B, ":G", 0x1B, "H", 0
  db 0x1B, ":S", 0x1B, "N", 0
  db 0x1B, ":R", 0x1B, "O", 0
  db 0x1B, ":I", 0x1B, "E", 0
  db 0x1B, ":J", 0x1B, "J", 0
  db 0x1B, ":N", 0x1B, "K", 0
  db 0x1B, ":V", 0x1B, "d", 0
  db 0x1B, ":W", 0x1B, "o", 0
  db 0x01, 0x1B, "D ", 0x1B, "D", 0
  db ">", 0
  db 0x1B, "z", 0x1B, "1", 0x1B, 0xF7, 0x1B, 0xFE, 0

; --- Piccoline Netværkskommandoer (0x11330) ---
  db 0x1B, 0xFD, 0
  db "?       ABORT   AFBRYD  AFMELD  BRUGER  DIR     LINE    LOCAL   LOKAL   LOGOFF  LOGON   NAVNGIV NET     NETOFF  NETON   OPRET   PRINTER SC"

; --- Kommando Dispatch Tabel (0x113BD) ---
  db 0x52, 0x45, 0x45, 0x4E, 0x20, 0x20, 0x53, 0x49, 0x5A, 0x45, 0x20, 0x20, 0x20, 0x20, 0x53, 0x4B
  db 0x52, 0x49, 0x56, 0x45, 0x52, 0x20, 0x54, 0x49, 0x4C, 0x4D, 0x45, 0x4C, 0x44, 0x20, 0x55, 0x53
  db 0x45, 0x52, 0x20, 0x20, 0x20, 0x20, 0x00

; --- Start Kommando Prompt (0x113E4) ---
  db 0x1B, 0x0A, "c", 0x07, 0xCC, 0x08, "C", 0x08, 0x10, 0x04, 0x12, 0x05, 0x13, 0x0A, 0xB8, 0x09, 0xB8, 0x09, 0xCC, 0x08, å, 0x08, 0x03, 0x09, 0x03, 0x09, "C", 0x08, 0x0D, 0x08, å, 0x08, "f", 0x04, 0x0B, 0x0A, 0xB8, 0x04, "f", 0x04, 0x0D, 0x08, 0x10, 0x04
  db "Start Kommando: ", 0
  times 15 db 0

