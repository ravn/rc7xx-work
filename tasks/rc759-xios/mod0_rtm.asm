; =============================================================================
; ccpm.sys — Modul 0: Supervisor & Real-Time Monitor (SUP+RTM)
; Offset range: 0x00000 - 0x01640
; =============================================================================


  db 0x01, 0xB2, 0x06, 0x48, 0x00, 0xB2, 0x06, 0x00, 0x00, 0x02, 0x33, 0x0C, 0xFA, 0x06, 0x33, 0x0C ; 00000  ...H......3...3.
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 ; 00010  ................
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 ; 00020  ................
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 ; 00030  ................
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 ; 00040  ............

loc_0004C:  ; 0004C
  db 0x00, 0x00                               ; 0004C  add byte [bx + si], al
  db 0x00, 0x00                               ; 0004E  add byte [bx + si], al
  db 0x00, 0x00                               ; 00050  add byte [bx + si], al
  db 0x00, 0x00                               ; 00052  add byte [bx + si], al
  db 0x00, 0x00                               ; 00054  add byte [bx + si], al
  db 0x00, 0x00                               ; 00056  add byte [bx + si], al
  db 0x00, 0x00                               ; 00058  add byte [bx + si], al
  db 0x00, 0x00                               ; 0005A  add byte [bx + si], al
  db 0x00, 0x00                               ; 0005C  add byte [bx + si], al

loc_0005E:  ; 0005E
  db 0x00, 0x00                               ; 0005E  add byte [bx + si], al
  db 0x00, 0x00                               ; 00060  add byte [bx + si], al
  db 0x00, 0x00                               ; 00062  add byte [bx + si], al
  db 0x00, 0x00                               ; 00064  add byte [bx + si], al
  db 0x00, 0x00                               ; 00066  add byte [bx + si], al
  db 0x00, 0x00                               ; 00068  add byte [bx + si], al
  db 0x00, 0x00                               ; 0006A  add byte [bx + si], al

loc_0006C:  ; 0006C
  db 0x00, 0x00                               ; 0006C  add byte [bx + si], al
  db 0x00, 0x00                               ; 0006E  add byte [bx + si], al
  db 0x00, 0x00                               ; 00070  add byte [bx + si], al
  db 0x00, 0x00                               ; 00072  add byte [bx + si], al
  db 0x00, 0x00                               ; 00074  add byte [bx + si], al
  db 0x00, 0x00                               ; 00076  add byte [bx + si], al
  db 0x00, 0x00                               ; 00078  add byte [bx + si], al
  db 0x00, 0x00                               ; 0007A  add byte [bx + si], al
  db 0x00, 0x00                               ; 0007C  add byte [bx + si], al
  db 0x00, 0x00                               ; 0007E  add byte [bx + si], al
  jmp near mod0_rtm_init                       ; 00080  0xE9, 0x7B, 0x00

loc_00083:  ; 00083
  jmp near mod0_rtm_entry                      ; 00083  0xE9, 0x74, 0x02
  db 0xFA, 0x06, 0x03, 0x00, 0x48, 0x00, 0x06, 0x43, 0x4F, 0x50, 0x59, 0x52, 0x49, 0x47, 0x48, 0x54 ; 00086  ....H..COPYRIGHT
  db 0x20, 0x28, 0x43, 0x29, 0x20, 0x31, 0x39, 0x38, 0x32, 0x2C, 0x31, 0x39, 0x38, 0x33, 0x2C, 0x31 ; 00096   (C) 1982,1983,1
  db 0x39, 0x38, 0x34, 0x20, 0x44, 0x49, 0x47, 0x49, 0x54, 0x41, 0x4C, 0x20, 0x52, 0x45, 0x53, 0x45 ; 000A6  984 DIGITAL RESE
  db 0x41, 0x52, 0x43, 0x48, 0x20, 0x31, 0x30, 0x33, 0x34, 0x2D, 0x30, 0x32, 0x36, 0x31, 0x2D, 0x30 ; 000B6  ARCH 1034-0261-0
  db 0x30, 0x37, 0x30, 0x34, 0x31, 0x20, 0x4D, 0x6F, 0x64, 0x69, 0x66, 0x79, 0x65, 0x64, 0x20, 0x62 ; 000C6  07041 Modifyed b
  db 0x79, 0x20, 0x46, 0x6C, 0x65, 0x6D, 0x6D, 0x69, 0x6E, 0x67, 0x20, 0x4B, 0x72, 0x61, 0x67, 0x6C ; 000D6  y Flemming Kragl
  db 0x75, 0x6E, 0x64, 0x20, 0x52, 0x63, 0x2D, 0x43, 0x6F, 0x6D, 0x70, 0x75, 0x74, 0x65, 0x72, 0x20 ; 000E6  und Rc-Computer 
  db 0x44, 0x65, 0x6E, 0x6D, 0x61, 0x72, 0x6B, 0x20               ; 000F6  Denmark 

mod0_rtm_init:  ; 000FE
  db 0xFA                                     ; 000FE  cli
  db 0xFC                                     ; 000FF  cld
  db 0x8C, 0xD8                               ; 00100  mov ax, ds
  db 0x8E, 0xD0                               ; 00102  mov ss, ax
  db 0xBC, 0xE0, 0x05                         ; 00104  mov sp, 0x5e0
  db 0xBB, 0xA1, 0x04                         ; 00107  mov bx, 0x4a1
  db 0xB8, 0xE0, 0x04                         ; 0010A  mov ax, 0x4e0
  db 0xB1, 0x04                               ; 0010D  mov cl, 4
  db 0xD3, 0xE8                               ; 0010F  shr ax, cl
  db 0x2E, 0x03, 0x06, 0x06, 0x00             ; 00111  add ax, word [cs:6]
  db 0x89, 0x47, 0x10                         ; 00116  mov word p_uda[bx], ax
  db 0x8E, 0xC0                               ; 00119  mov es, ax
  db 0x26, 0x8C, 0x1E, 0x2E, 0x00             ; 0011B  mov word [es:0x2e], ds
  db 0x1E                                     ; 00120  push ds
  db 0x33, 0xC0                               ; 00121  xor ax, ax
  db 0x8E, 0xD8                               ; 00123  mov ds, ax
  db 0xC7, 0x06, 0x80, 0x03, 0x34, 0x01       ; 00125  mov word [0x380], 0x134
  db 0x8C, 0x0E, 0x82, 0x03                   ; 0012B  mov word [0x382], cs
  db 0x1F                                     ; 0012F  pop ds
  db 0xB8, 0xFF, 0xFF                         ; 00130  mov ax, 0xffff
  db 0xA3, 0x8C, 0x00                         ; 00133  mov word [0x8c], ax
  db 0xBB, 0x04, 0x00                         ; 00136  mov bx, 4
  db 0x53                                     ; 00139  push bx
  db 0xFF, 0x5F, 0x08                         ; 0013A  call far [bx + 8]
  db 0x5B                                     ; 0013D  pop bx
  db 0x53                                     ; 0013E  push bx
  db 0xFF, 0x5F, 0x10                         ; 0013F  call far p_uda[bx]
  db 0x5B                                     ; 00142  pop bx
  db 0xF6, 0x06, 0x46, 0x00, 0x08             ; 00143  test byte [0x46], 8
  je loc_0014F                                 ; 00148  0x74, 0x05
  db 0x53                                     ; 0014A  push bx
  db 0xFF, 0x5F, 0x20                         ; 0014B  call far p_cns[bx]
  db 0x5B                                     ; 0014E  pop bx

loc_0014F:  ; 0014F
  db 0xF6, 0x06, 0x46, 0x00, 0x10             ; 0014F  test byte [0x46], 0x10
  je loc_0015B                                 ; 00154  0x74, 0x05
  db 0x53                                     ; 00156  push bx
  db 0xFF, 0x5F, 0x18                         ; 00157  call far p_cmod[bx]
  db 0x5B                                     ; 0015A  pop bx

loc_0015B:  ; 0015B
  db 0xF6, 0x06, 0x46, 0x00, 0x20             ; 0015B  test byte [0x46], 0x20
  je loc_00169                                 ; 00160  0x74, 0x07
  db 0x1E                                     ; 00162  push ds
  db 0x06                                     ; 00163  push es
  db 0xFF, 0x5F, 0x28                         ; 00164  call far p_userdisp[bx]
  db 0x07                                     ; 00167  pop es
  db 0x1F                                     ; 00168  pop ds

loc_00169:  ; 00169
  db 0x8C, 0xD8                               ; 00169  mov ax, ds
  db 0x2B, 0xDB                               ; 0016B  sub bx, bx
  db 0x8E, 0xDB                               ; 0016D  mov ds, bx
  db 0xC7, 0x06, 0x80, 0x03, 0x34, 0x01       ; 0016F  mov word [0x380], 0x134
  db 0x8C, 0x0E, 0x82, 0x03                   ; 00175  mov word [0x382], cs
  db 0x8E, 0xD8                               ; 00179  mov ds, ax
  db 0xB1, 0x92                               ; 0017B  mov cl, 0x92
  db 0xCD, 0xE0                               ; 0017D  int 0xe0
  db 0xB1, 0x9E                               ; 0017F  mov cl, 0x9e
  db 0xCD, 0xE0                               ; 00181  int 0xe0

loc_00183:  ; 00183
  db 0x2E, 0x8E, 0x1E, 0x06, 0x00             ; 00183  mov ds, word [cs:6]
  db 0x8B, 0x0E, 0x42, 0x00                   ; 00188  mov cx, word [0x42]
  jcxz loc_001AE                               ; 0018C  0xE3, 0x20
  db 0x8E, 0xC1                               ; 0018E  mov es, cx
  db 0x26, 0xA1, 0x00, 0x00                   ; 00190  mov ax, word [es:0]
  db 0xA3, 0x42, 0x00                         ; 00194  mov word [0x42], ax
  db 0x26, 0x8C, 0x1E, 0x00, 0x00             ; 00197  mov word [es:0], ds
  db 0xBE, 0x10, 0x00                         ; 0019C  mov si, 0x10
  db 0x8E, 0xD9                               ; 0019F  mov ds, cx
  db 0xC7, 0x44, 0x16, 0x00, 0x00             ; 001A1  mov word p_mem[si], 0
  db 0xB1, 0x90                               ; 001A6  mov cl, 0x90
  db 0x8B, 0xD6                               ; 001A8  mov dx, si
  db 0xCD, 0xE0                               ; 001AA  int 0xe0
  jmp short loc_00183                          ; 001AC  0xEB, 0xD5

loc_001AE:  ; 001AE
  db 0xB1, 0x8F                               ; 001AE  mov cl, 0x8f
  db 0xB2, 0xFF                               ; 001B0  mov dl, 0xff
  db 0xCD, 0xE0                               ; 001B2  int 0xe0
  db 0xFC                                     ; 001B4  cld
  db 0x8C, 0xD8                               ; 001B5  mov ax, ds
  db 0x2E, 0x8E, 0x1E, 0x06, 0x00             ; 001B7  mov ds, word [cs:6]
  db 0x8B, 0x1E, 0x68, 0x00                   ; 001BC  mov bx, word [0x68]
  db 0x8E, 0x5F, 0x10                         ; 001C0  mov ds, word p_uda[bx]
  db 0x8C, 0x06, 0x30, 0x00                   ; 001C3  mov word [0x30], es
  db 0x80, 0x3E, 0x60, 0x00, 0x00             ; 001C7  cmp byte [0x60], 0
  jne loc_001E2                                ; 001CC  0x75, 0x14
  db 0xA3, 0x2E, 0x00                         ; 001CE  mov word [rlr], ax
  db 0x8C, 0x16, 0x36, 0x00                   ; 001D1  mov word [0x36], ss
  db 0x89, 0x26, 0x34, 0x00                   ; 001D5  mov word [0x34], sp
  db 0x8C, 0xD8                               ; 001D9  mov ax, ds
  db 0x8E, 0xD0                               ; 001DB  mov ss, ax
  db 0xBC, 0x00, 0x01                         ; 001DD  mov sp, 0x100
  jmp short loc_001E9                          ; 001E0  0xEB, 0x07

loc_001E2:  ; 001E2
  db 0xFF, 0x36, 0x2E, 0x00                   ; 001E2  push word [rlr]
  db 0xA3, 0x2E, 0x00                         ; 001E6  mov word [rlr], ax

loc_001E9:  ; 001E9
  db 0xFB                                     ; 001E9  sti
  db 0xFE, 0x06, 0x60, 0x00                   ; 001EA  inc byte [0x60]
  db 0x8C, 0xD8                               ; 001EE  mov ax, ds
  db 0x8E, 0xC0                               ; 001F0  mov es, ax
  db 0x2E, 0x8E, 0x1E, 0x06, 0x00             ; 001F2  mov ds, word [cs:6]
  db 0x56                                     ; 001F7  push si
  db 0x57                                     ; 001F8  push di
  db 0x55                                     ; 001F9  push bp
  db 0x26, 0x88, 0x0E, 0x06, 0x00             ; 001FA  mov byte [es:6], cl
  db 0x32, 0xED                               ; 001FF  xor ch, ch
  call rtm_func_check                               ; 00201  0xE8, 0x89, 0x00
  db 0x5D                                     ; 00204  pop bp
  db 0x5F                                     ; 00205  pop di
  db 0x5E                                     ; 00206  pop si
  db 0x8C, 0xC0                               ; 00207  mov ax, es
  db 0x8E, 0xD8                               ; 00209  mov ds, ax
  db 0x8E, 0x06, 0x30, 0x00                   ; 0020B  mov es, word [0x30]
  db 0xA1, 0x2E, 0x00                         ; 0020F  mov ax, word [rlr]
  db 0xFA                                     ; 00212  cli
  db 0xFE, 0x0E, 0x60, 0x00                   ; 00213  dec byte [0x60]
  jne loc_00272                                ; 00217  0x75, 0x59
  db 0x53                                     ; 00219  push bx
  db 0x1E                                     ; 0021A  push ds
  db 0x51                                     ; 0021B  push cx
  db 0x2E, 0x8E, 0x1E, 0x06, 0x00             ; 0021C  mov ds, word [cs:6]
  db 0x8B, 0x1E, 0x68, 0x00                   ; 00221  mov bx, word [0x68]
  db 0x8B, 0x47, 0x26                         ; 00225  mov ax, word p_sflag[bx]
  db 0xA9, 0x01, 0x00                         ; 00228  test ax, 1
  je loc_0025E                                 ; 0022B  0x74, 0x31
  db 0x8E, 0x47, 0x10                         ; 0022D  mov es, word p_uda[bx]
  db 0x8A, 0x47, 0x20                         ; 00230  mov al, byte p_cns[bx]
  db 0x32, 0xE4                               ; 00233  xor ah, ah
  db 0x32, 0xFF                               ; 00235  xor bh, bh
  db 0xBB, 0x2C, 0x00                         ; 00237  mov bx, 0x2c
  db 0xF7, 0xE3                               ; 0023A  mul bx
  db 0x8B, 0x1E, 0x54, 0x00                   ; 0023C  mov bx, word [0x54]
  db 0x03, 0xD8                               ; 00240  add bx, ax
  db 0x8B, 0x47, 0x0E                         ; 00242  mov ax, word [bx + 0xe]
  db 0xA9, 0x10, 0x00                         ; 00245  test ax, 0x10
  je loc_0025E                                 ; 00248  0x74, 0x14
  db 0x52                                     ; 0024A  push dx
  db 0xBA, 0xA8, 0x00                         ; 0024B  mov dx, 0xa8
  db 0x26, 0x89, 0x16, 0x00, 0x00             ; 0024E  mov word [es:0], dx
  db 0xB9, 0x12, 0x02                         ; 00253  mov cx, 0x212
  db 0x32, 0xFF                               ; 00256  xor bh, bh
  db 0xB3, 0x09                               ; 00258  mov bl, 9
  call rtm_dispatcher                          ; 0025A  0xE8, 0xB6, 0x00
  db 0x5A                                     ; 0025D  pop dx

loc_0025E:  ; 0025E
  db 0x59                                     ; 0025E  pop cx
  db 0x1F                                     ; 0025F  pop ds
  db 0x5B                                     ; 00260  pop bx
  db 0xA1, 0x2E, 0x00                         ; 00261  mov ax, word [rlr]
  db 0x8E, 0x06, 0x30, 0x00                   ; 00264  mov es, word [0x30]
  db 0x8E, 0x16, 0x36, 0x00                   ; 00268  mov ss, word [0x36]
  db 0x8B, 0x26, 0x34, 0x00                   ; 0026C  mov sp, word [0x34]
  jmp short loc_00277                          ; 00270  0xEB, 0x05

loc_00272:  ; 00272
  db 0xFB                                     ; 00272  sti
  db 0x8F, 0x06, 0x2E, 0x00                   ; 00273  pop word [rlr]

loc_00277:  ; 00277
  db 0x8E, 0xD8                               ; 00277  mov ds, ax
  db 0x8B, 0xC3                               ; 00279  mov ax, bx
  db 0x40                                     ; 0027B  inc ax
  je loc_00280                                 ; 0027C  0x74, 0x02
  db 0x33, 0xC9                               ; 0027E  xor cx, cx

loc_00280:  ; 00280
  db 0x48                                     ; 00280  dec ax
  db 0xCF                                     ; 00281  iret

rtm_core:  ; 00282
  db 0x84, 0xED                               ; 00282  test ch, ch
  je rtm_func_check                                 ; 00284  0x74, 0x07
  db 0x8B, 0xC1                               ; 00286  mov ax, cx
  jmp short loc_002CD                          ; 00288  0xEB, 0x43

loc_0028A:  ; 0028A
  jmp near loc_00376                           ; 0028A  0xE9, 0xE9, 0x00

rtm_func_check:  ; 0028D
  db 0x8B, 0xC1                               ; 0028D  mov ax, cx
  db 0x3C, 0x50                               ; 0028F  cmp al, 0x50
  jbe loc_002A7                                ; 00291  0x76, 0x14
  db 0x2C, 0x11                               ; 00293  sub al, 0x11
  db 0x3C, 0x51                               ; 00295  cmp al, 0x51
  jb loc_0028A                                 ; 00297  0x72, 0xF1
  db 0x3C, 0x63                               ; 00299  cmp al, 0x63
  jbe loc_002A7                                ; 0029B  0x76, 0x0A
  db 0x2C, 0x0B                               ; 0029D  sub al, 0xb
  db 0x3C, 0x64                               ; 0029F  cmp al, 0x64
  jb loc_0028A                                 ; 002A1  0x72, 0xE7
  db 0x3C, 0x88                               ; 002A3  cmp al, 0x88
  ja loc_0028A                                 ; 002A5  0x77, 0xE3

loc_002A7:  ; 002A7
  db 0xD1, 0xE0                               ; 002A7  shl ax, 1
  db 0x8B, 0xF0                               ; 002A9  mov si, ax
  db 0x8B, 0x84, 0xAA, 0x00                   ; 002AB  mov ax, word [si + 0xaa]
  db 0xF6, 0xC4, 0x80                         ; 002AF  test ah, 0x80
  je loc_002CD                                 ; 002B2  0x74, 0x19
  db 0x80, 0xE4, 0x7F                         ; 002B4  and ah, 0x7f
  db 0x8A, 0x1E, 0x46, 0x00                   ; 002B7  mov bl, byte [0x46]
  db 0xF6, 0xC3, 0x40                         ; 002BB  test bl, 0x40
  je loc_002CD                                 ; 002BE  0x74, 0x0D
  db 0x50                                     ; 002C0  push ax
  db 0xFF, 0x1E, 0x30, 0x00                   ; 002C1  call far [0x30]
  db 0x3C, 0xFF                               ; 002C5  cmp al, 0xff
  db 0x58                                     ; 002C7  pop ax
  je loc_002CD                                 ; 002C8  0x74, 0x03
  db 0x8B, 0xC3                               ; 002CA  mov ax, bx
  db 0xC3                                     ; 002CC  ret

loc_002CD:  ; 002CD
  db 0x80, 0xFC, 0x01                         ; 002CD  cmp ah, 1
  je loc_002EF                                 ; 002D0  0x74, 0x1D
  db 0x8A, 0xCC                               ; 002D2  mov cl, ah
  db 0x8A, 0x2E, 0x46, 0x00                   ; 002D4  mov ch, byte [0x46]
  db 0xD2, 0xED                               ; 002D8  shr ch, cl
  jae loc_002EC                                ; 002DA  0x73, 0x10
  db 0x32, 0xED                               ; 002DC  xor ch, ch
  db 0x49                                     ; 002DE  dec cx
  db 0xD1, 0xE1                               ; 002DF  shl cx, 1
  db 0xD1, 0xE1                               ; 002E1  shl cx, 1
  db 0xD1, 0xE1                               ; 002E3  shl cx, 1
  db 0x8B, 0xF1                               ; 002E5  mov si, cx
  db 0x8A, 0xC8                               ; 002E7  mov cl, al
  db 0xFF, 0x1C                               ; 002E9  call far [si]
  db 0xC3                                     ; 002EB  ret

loc_002EC:  ; 002EC
  jmp near loc_0036F                           ; 002EC  0xE9, 0x80, 0x00

loc_002EF:  ; 002EF
  db 0x32, 0xE4                               ; 002EF  xor ah, ah
  db 0xD1, 0xE0                               ; 002F1  shl ax, 1
  db 0x8B, 0xF0                               ; 002F3  mov si, ax
  db 0x2E, 0xFF, 0xA4, 0xD1, 0x02             ; 002F5  jmp word [cs:si + 0x2d1]

mod0_rtm_entry:  ; 002FA
  db 0x81, 0xF9, 0x85, 0x00                   ; 002FA  cmp cx, 0x85
  jne loc_0030F                                ; 002FE  0x75, 0x0F
  db 0xB9, 0x03, 0x02                         ; 00300  mov cx, 0x203
  call rtm_core                                ; 00303  0xE8, 0x7C, 0xFF
  db 0x8B, 0xC3                               ; 00306  mov ax, bx
  db 0x40                                     ; 00308  inc ax
  je loc_0030D                                 ; 00309  0x74, 0x02
  db 0x33, 0xC9                               ; 0030B  xor cx, cx

loc_0030D:  ; 0030D
  db 0x48                                     ; 0030D  dec ax
  db 0xCB                                     ; 0030E  retf

loc_0030F:  ; 0030F
  call rtm_dispatcher                          ; 0030F  0xE8, 0x01, 0x00
  db 0xCB                                     ; 00312  retf

rtm_dispatcher:  ; 00313
  db 0x26, 0xFF, 0x36, 0x2E, 0x00             ; 00313  push word [es:0x2e]
  db 0x8C, 0xD8                               ; 00318  mov ax, ds
  db 0x26, 0xA3, 0x2E, 0x00                   ; 0031A  mov word [es:0x2e], ax
  db 0x2E, 0xA1, 0x06, 0x00                   ; 0031E  mov ax, word [cs:6]
  db 0x8E, 0xD8                               ; 00322  mov ds, ax
  call rtm_core                                ; 00324  0xE8, 0x5B, 0xFF
  db 0x26, 0xA1, 0x2E, 0x00                   ; 00327  mov ax, word [es:0x2e]
  db 0x8E, 0xD8                               ; 0032B  mov ds, ax
  db 0x26, 0x8F, 0x06, 0x2E, 0x00             ; 0032D  pop word [es:0x2e]
  db 0x8B, 0xC3                               ; 00332  mov ax, bx
  db 0x40                                     ; 00334  inc ax
  je loc_00339                                 ; 00335  0x74, 0x02
  db 0x33, 0xC9                               ; 00337  xor cx, cx

loc_00339:  ; 00339
  db 0x48                                     ; 00339  dec ax
  db 0xC3                                     ; 0033A  ret
  db 0x8B, 0x1E, 0x68, 0x00                   ; 0033B  mov bx, word [0x68]
  db 0x81, 0x67, 0x06, 0x7C, 0xFD             ; 0033F  and word [bx + 6], 0xfd7c
  db 0xB9, 0x8F, 0x00                         ; 00344  mov cx, 0x8f
  db 0x33, 0xD2                               ; 00347  xor dx, dx
  db 0xCD, 0xE0                               ; 00349  int 0xe0

loc_0034B:  ; 0034B
  db 0xFF, 0x1E, 0x28, 0x00                   ; 0034B  call far [0x28]
  db 0xC3                                     ; 0034F  ret
  db 0x00                                                         ; 00350  .
  db 0xEF                                     ; 00351  out dx, ax
  db 0x02, 0xF6                               ; 00352  add dh, dh
  db 0x02, 0xFD                               ; 00354  add bh, ch
  db 0x02, 0x0B                               ; 00356  add cl, byte [bp + di]
  db 0x03, 0xCE                               ; 00358  add cx, si
  db 0x0A, 0xC6                               ; 0035A  or al, dh
  db 0x03, 0xD3                               ; 0035C  add dx, bx
  db 0x14, 0x69                               ; 0035E  adc al, 0x69
  db 0x13, 0x88, 0x03, 0x92                   ; 00360  adc cx, word [bx + si - 0x6dfd]
  db 0x03, 0xD0                               ; 00364  add dx, ax
  db 0x0A, 0x04                               ; 00366  or al, byte [si]
  db 0x03, 0xC4                               ; 00368  add ax, sp
  db 0x03, 0xA8, 0x03, 0xC8                   ; 0036A  add bp, word [bx + si - 0x37fd]
  db 0x0A                                                         ; 0036E  .

loc_0036F:  ; 0036F
  db 0xB9, 0x01, 0x00                         ; 0036F  mov cx, 1
  db 0xBB, 0xFF, 0xFF                         ; 00372  mov bx, 0xffff
  db 0xC3                                     ; 00375  ret

loc_00376:  ; 00376
  db 0xB9, 0x02, 0x00                         ; 00376  mov cx, 2
  db 0xBB, 0xFF, 0xFF                         ; 00379  mov bx, 0xffff
  db 0xC3                                     ; 0037C  ret
  db 0x8B, 0x1E, 0x7A, 0x00                   ; 0037D  mov bx, word [0x7a]
  db 0x33, 0xC9                               ; 00381  xor cx, cx
  db 0xC3                                     ; 00383  ret
  db 0x8B, 0x1E, 0x7C, 0x00                   ; 00384  mov bx, word [0x7c]
  db 0x33, 0xC9                               ; 00388  xor cx, cx
  db 0xC3                                     ; 0038A  ret
  db 0x8B, 0xF2                               ; 0038B  mov si, dx
  db 0x8C, 0xDD                               ; 0038D  mov bp, ds
  db 0x26, 0x8E, 0x1E, 0x2E, 0x00             ; 0038F  mov ds, word [es:0x2e]
  db 0x8A, 0x04                               ; 00394  mov al, byte [si]
  db 0x8B, 0x4C, 0x01                         ; 00396  mov cx, word [si + 1]
  db 0x8B, 0x54, 0x03                         ; 00399  mov dx, word [si + 3]
  db 0x8E, 0xDD                               ; 0039C  mov ds, bp
  db 0x3C, 0x02                               ; 0039E  cmp al, 2
  jne loc_003B0                                ; 003A0  0x75, 0x0E
  db 0xB9, 0x18, 0x04                         ; 003A2  mov cx, 0x418
  call rtm_dispatcher                          ; 003A5  0xE8, 0x6B, 0xFF
  db 0x84, 0xDB                               ; 003A8  test bl, bl
  je loc_003AF                                 ; 003AA  0x74, 0x03
  db 0xBB, 0xFF, 0x00                         ; 003AC  mov bx, 0xff

loc_003AF:  ; 003AF
  db 0xC3                                     ; 003AF  ret

loc_003B0:  ; 003B0
  db 0x3C, 0x04                               ; 003B0  cmp al, 4
  jne loc_003BC                                ; 003B2  0x75, 0x08
  db 0x8A, 0xD1                               ; 003B4  mov dl, cl
  db 0xB9, 0x03, 0x04                         ; 003B6  mov cx, 0x403
  jmp near rtm_dispatcher                      ; 003B9  0xE9, 0x57, 0xFF

loc_003BC:  ; 003BC
  db 0x3C, 0x01                               ; 003BC  cmp al, 1
  ja loc_003C9                                 ; 003BE  0x77, 0x09
  db 0xB9, 0x8F, 0x00                         ; 003C0  mov cx, 0x8f
  db 0xBA, 0x00, 0x00                         ; 003C3  mov dx, 0
  jmp near rtm_dispatcher                      ; 003C6  0xE9, 0x4A, 0xFF

loc_003C9:  ; 003C9
  db 0x3C, 0x07                               ; 003C9  cmp al, 7
  jbe loc_003D8                                ; 003CB  0x76, 0x0B
  db 0x3C, 0x0F                               ; 003CD  cmp al, 0xf
  je loc_003D8                                 ; 003CF  0x74, 0x07
  db 0xBB, 0xFF, 0xFF                         ; 003D1  mov bx, 0xffff
  db 0xB9, 0x02, 0x00                         ; 003D4  mov cx, 2
  db 0xC3                                     ; 003D7  ret

loc_003D8:  ; 003D8
  db 0x3C, 0x03                               ; 003D8  cmp al, 3
  jne loc_003E2                                ; 003DA  0x75, 0x06
  db 0xB9, 0x02, 0x04                         ; 003DC  mov cx, 0x402
  jmp near rtm_dispatcher                      ; 003DF  0xE9, 0x31, 0xFF

loc_003E2:  ; 003E2
  db 0x3C, 0x05                               ; 003E2  cmp al, 5
  jne loc_003EE                                ; 003E4  0x75, 0x08
  db 0x8A, 0xD1                               ; 003E6  mov dl, cl
  db 0xB9, 0x05, 0x00                         ; 003E8  mov cx, 5
  jmp near rtm_dispatcher                      ; 003EB  0xE9, 0x25, 0xFF

loc_003EE:  ; 003EE
  db 0x3C, 0x06                               ; 003EE  cmp al, 6
  jne loc_003F8                                ; 003F0  0x75, 0x06
  db 0xB8, 0x06, 0x00                         ; 003F2  mov ax, 6
  jmp near loc_0034B                           ; 003F5  0xE9, 0x53, 0xFF

loc_003F8:  ; 003F8
  db 0x3C, 0x07                               ; 003F8  cmp al, 7
  jne loc_00402                                ; 003FA  0x75, 0x06
  db 0xB8, 0x05, 0x00                         ; 003FC  mov ax, 5
  jmp near loc_0034B                           ; 003FF  0xE9, 0x49, 0xFF

loc_00402:  ; 00402
  db 0xB8, 0x03, 0x00                         ; 00402  mov ax, 3
  jmp near loc_0034B                           ; 00405  0xE9, 0x43, 0xFF
  db 0x26, 0x8C, 0x1E, 0x30, 0x00             ; 00408  mov word [es:0x30], ds
  db 0x33, 0xDB                               ; 0040D  xor bx, bx
  db 0x8B, 0xCB                               ; 0040F  mov cx, bx
  db 0xC3                                     ; 00411  ret
  db 0x06                                     ; 00412  push es
  db 0x26, 0x8E, 0x06, 0x2E, 0x00             ; 00413  mov es, word [es:0x2e]
  db 0x8B, 0xFA                               ; 00418  mov di, dx
  db 0xBE, 0x7E, 0x00                         ; 0041A  mov si, 0x7e
  db 0xB9, 0x05, 0x00                         ; 0041D  mov cx, 5
  db 0xF3, 0xA4                               ; 00420  rep movsb
  db 0x07                                     ; 00422  pop es
  db 0x33, 0xC9                               ; 00423  xor cx, cx
  db 0x8B, 0xD9                               ; 00425  mov bx, cx
  db 0xC3                                     ; 00427  ret
  db 0x06                                     ; 00428  push es
  db 0x26, 0x8E, 0x06, 0x2E, 0x00             ; 00429  mov es, word [es:0x2e]
  db 0x8B, 0xFA                               ; 0042E  mov di, dx
  db 0xBE, 0x45, 0x00                         ; 00430  mov si, 0x45
  db 0x1E                                     ; 00433  push ds
  db 0x8C, 0xC8                               ; 00434  mov ax, cs
  db 0x8E, 0xD8                               ; 00436  mov ds, ax
  db 0xB9, 0x03, 0x00                         ; 00438  mov cx, 3
  db 0xF3, 0xA5                               ; 0043B  rep movsw
  db 0x1F                                     ; 0043D  pop ds
  db 0x07                                     ; 0043E  pop es
  db 0x33, 0xC9                               ; 0043F  xor cx, cx
  db 0x8B, 0xD9                               ; 00441  mov bx, cx
  db 0xC3                                     ; 00443  ret
  db 0x33, 0xD2                               ; 00444  xor dx, dx
  db 0x8B, 0x1E, 0x68, 0x00                   ; 00446  mov bx, word [0x68]
  db 0x8B, 0x47, 0x06                         ; 0044A  mov ax, word [bx + 6]
  db 0x50                                     ; 0044D  push ax
  db 0x0D, 0x00, 0x10                         ; 0044E  or ax, 0x1000
  db 0x89, 0x47, 0x06                         ; 00451  mov word [bx + 6], ax
  db 0xB9, 0x17, 0x02                         ; 00454  mov cx, 0x217
  call rtm_dispatcher                          ; 00457  0xE8, 0xB9, 0xFE
  db 0x52                                     ; 0045A  push dx
  call cli_sync                               ; 0045B  0xE8, 0xB9, 0x06
  db 0x5A                                     ; 0045E  pop dx
  db 0x8F, 0x06, 0x4B, 0x03                   ; 0045F  pop word [0x34b]
  db 0xC6, 0x06, 0x4D, 0x03, 0x00             ; 00463  mov byte [0x34d], 0
  db 0x83, 0xFA, 0x00                         ; 00468  cmp dx, 0
  jne loc_00477                                ; 0046B  0x75, 0x0A
  db 0xC6, 0x06, 0x4D, 0x03, 0xFF             ; 0046D  mov byte [0x34d], 0xff
  db 0xC6, 0x06, 0x4E, 0x03, 0x00             ; 00472  mov byte [0x34e], 0

loc_00477:  ; 00477
  db 0xC6, 0x06, 0xA0, 0x04, 0x00             ; 00477  mov byte [0x4a0], 0
  db 0x80, 0x3E, 0x4F, 0x00, 0xFF             ; 0047C  cmp byte [0x4f], 0xff
  jne loc_0049A                                ; 00481  0x75, 0x17
  db 0x52                                     ; 00483  push dx
  db 0xB9, 0xA2, 0x00                         ; 00484  mov cx, 0xa2
  call rtm_dispatcher                          ; 00487  0xE8, 0x89, 0xFE
  db 0x5A                                     ; 0048A  pop dx
  db 0x83, 0xF9, 0x00                         ; 0048B  cmp cx, 0
  jne loc_0049A                                ; 0048E  0x75, 0x0A
  db 0xC6, 0x06, 0xA0, 0x04, 0xFF             ; 00490  mov byte [0x4a0], 0xff
  db 0x52                                     ; 00495  push dx
  call cli_prtime                               ; 00496  0xE8, 0x74, 0x05
  db 0x5A                                     ; 00499  pop dx

loc_0049A:  ; 0049A
  db 0x8B, 0x1E, 0x68, 0x00                   ; 0049A  mov bx, word [0x68]
  db 0x89, 0x1E, 0xD0, 0x03                   ; 0049E  mov word [0x3d0], bx
  db 0x8A, 0x4F, 0x12                         ; 004A2  mov cl, byte p_dsk[bx]
  db 0x88, 0x0E, 0x9E, 0x04                   ; 004A5  mov byte [0x49e], cl
  db 0x8A, 0x4F, 0x13                         ; 004A9  mov cl, byte p_user[bx]
  db 0x88, 0x0E, 0x9D, 0x04                   ; 004AC  mov byte [0x49d], cl
  db 0x8A, 0x4F, 0x20                         ; 004B0  mov cl, byte p_cns[bx]
  db 0x88, 0x0E, 0x9C, 0x04                   ; 004B3  mov byte [0x49c], cl
  db 0x26, 0x8A, 0x0E, 0x10, 0x00             ; 004B7  mov cl, byte [es:0x10]
  db 0x88, 0x0E, 0x9F, 0x04                   ; 004BC  mov byte [0x49f], cl
  db 0x26, 0x8B, 0x0E, 0x02, 0x00             ; 004C0  mov cx, word [es:2]
  db 0x89, 0x0E, 0x47, 0x03                   ; 004C5  mov word [0x347], cx
  db 0x26, 0x8B, 0x0E, 0x04, 0x00             ; 004C9  mov cx, word [es:4]
  db 0x89, 0x0E, 0x49, 0x03                   ; 004CE  mov word [0x349], cx
  db 0xC7, 0x06, 0x97, 0x04, 0x00, 0x00       ; 004D2  mov word [0x497], 0
  db 0x80, 0x3E, 0x4D, 0x03, 0xFF             ; 004D8  cmp byte [0x34d], 0xff
  jne loc_004FB                                ; 004DD  0x75, 0x1C
  db 0x06                                     ; 004DF  push es
  db 0x1E                                     ; 004E0  push ds
  db 0x2E, 0x8E, 0x06, 0x06, 0x00             ; 004E1  mov es, word [cs:6]
  db 0x8B, 0x36, 0x47, 0x03                   ; 004E6  mov si, word [0x347]
  db 0xBF, 0xD2, 0x03                         ; 004EA  mov di, 0x3d2
  db 0x8E, 0x1E, 0x49, 0x03                   ; 004ED  mov ds, word [0x349]
  db 0xB9, 0x40, 0x00                         ; 004F1  mov cx, 0x40
  db 0xF3, 0xA5                               ; 004F4  rep movsw
  db 0x1F                                     ; 004F6  pop ds
  db 0x07                                     ; 004F7  pop es
  jmp near loc_00519                           ; 004F8  0xE9, 0x1E, 0x00

loc_004FB:  ; 004FB
  db 0x06                                     ; 004FB  push es
  db 0x1E                                     ; 004FC  push ds
  db 0x26, 0x8E, 0x1E, 0x2E, 0x00             ; 004FD  mov ds, word [es:0x2e]
  db 0x07                                     ; 00502  pop es
  db 0x8B, 0xF2                               ; 00503  mov si, dx
  db 0xBF, 0xCF, 0x03                         ; 00505  mov di, 0x3cf
  db 0xA4                                     ; 00508  movsb
  db 0x8B, 0xF2                               ; 00509  mov si, dx
  db 0x83, 0xC6, 0x01                         ; 0050B  add si, 1
  db 0xBF, 0xD2, 0x03                         ; 0050E  mov di, 0x3d2
  db 0xB9, 0x81, 0x00                         ; 00511  mov cx, 0x81
  db 0xF3, 0xA4                               ; 00514  rep movsb
  db 0x06                                     ; 00516  push es
  db 0x1F                                     ; 00517  pop ds
  db 0x07                                     ; 00518  pop es

loc_00519:  ; 00519
  call cli_pfn                               ; 00519  0xE8, 0x09, 0x06
  jcxz loc_00525                               ; 0051C  0xE3, 0x07
  db 0x89, 0x0E, 0x97, 0x04                   ; 0051E  mov word [0x497], cx
  jmp near loc_00932                           ; 00522  0xE9, 0x0D, 0x04

loc_00525:  ; 00525
  call cli_parse_tail                               ; 00525  0xE8, 0xA9, 0x04
  db 0x80, 0x3E, 0x54, 0x04, 0x00             ; 00528  cmp byte [0x454], 0
  jne loc_0054C                                ; 0052D  0x75, 0x1D
  db 0xBB, 0x54, 0x04                         ; 0052F  mov bx, 0x454
  db 0x80, 0x7F, 0x1A, 0x00                   ; 00532  cmp byte p_wait[bx], 0
  jne loc_0054C                                ; 00536  0x75, 0x14
  call io_conin_rtm_helper                     ; 00538  0xE8, 0x1C, 0x00
  jne loc_0054C                                ; 0053B  0x75, 0x0F

loc_0053D:  ; 0053D
  db 0x80, 0x3E, 0x4D, 0x03, 0xFF             ; 0053D  cmp byte [0x34d], 0xff
  jne loc_00549                                ; 00542  0x75, 0x05
  db 0xC6, 0x06, 0x4E, 0x03, 0xFF             ; 00544  mov byte [0x34e], 0xff

loc_00549:  ; 00549
  jmp near loc_00932                           ; 00549  0xE9, 0xE6, 0x03

loc_0054C:  ; 0054C
  db 0x83, 0xF9, 0x0F                         ; 0054C  cmp cx, 0xf
  jne loc_005C2                                ; 0054F  0x75, 0x71
  db 0x89, 0x0E, 0x97, 0x04                   ; 00551  mov word [0x497], cx
  jmp short loc_0053D                          ; 00555  0xEB, 0xE6

io_conin_rtm_helper:  ; 00557
  db 0xBE, 0x55, 0x04                         ; 00557  mov si, 0x455
  db 0xBF, 0x7D, 0x04                         ; 0055A  mov di, 0x47d
  db 0xB9, 0x04, 0x00                         ; 0055D  mov cx, 4
  db 0x06                                     ; 00560  push es

loc_00561:  ; 00561
  db 0x1E                                     ; 00561  push ds
  db 0x07                                     ; 00562  pop es
  db 0x56                                     ; 00563  push si
  db 0xF3, 0xA5                               ; 00564  rep movsw
  db 0x5E                                     ; 00566  pop si
  db 0xB9, 0x04, 0x00                         ; 00567  mov cx, 4
  db 0xBF, 0x89, 0x04                         ; 0056A  mov di, 0x489
  db 0xF3, 0xA5                               ; 0056D  rep movsw
  db 0x07                                     ; 0056F  pop es
  db 0xB9, 0x87, 0x00                         ; 00570  mov cx, 0x87
  db 0xBA, 0x75, 0x04                         ; 00573  mov dx, 0x475
  call rtm_dispatcher                          ; 00576  0xE8, 0x9A, 0xFD
  jcxz loc_0057F                               ; 00579  0xE3, 0x04

loc_0057B:  ; 0057B
  db 0x83, 0xF9, 0x00                         ; 0057B  cmp cx, 0
  db 0xC3                                     ; 0057E  ret

loc_0057F:  ; 0057F
  db 0xBB, 0x75, 0x04                         ; 0057F  mov bx, 0x475
  db 0x8B, 0x5F, 0x02                         ; 00582  mov bx, word [bx + 2]
  db 0xF7, 0x47, 0x04, 0x08, 0x00             ; 00585  test word [bx + 4], 8
  jne loc_00591                                ; 0058A  0x75, 0x05
  db 0xB9, 0x09, 0x00                         ; 0058C  mov cx, 9
  jmp short loc_0057B                          ; 0058F  0xEB, 0xEA

loc_00591:  ; 00591
  db 0xB9, 0x8C, 0x00                         ; 00591  mov cx, 0x8c
  db 0xBA, 0x75, 0x04                         ; 00594  mov dx, 0x475
  call rtm_dispatcher                          ; 00597  0xE8, 0x79, 0xFD
  jcxz loc_005A1                               ; 0059A  0xE3, 0x05
  db 0xB9, 0x0F, 0x00                         ; 0059C  mov cx, 0xf
  jmp short loc_0057B                          ; 0059F  0xEB, 0xDA

loc_005A1:  ; 005A1
  db 0x80, 0x3E, 0xA0, 0x04, 0xFF             ; 005A1  cmp byte [0x4a0], 0xff
  jne loc_005AB                                ; 005A6  0x75, 0x03
  call cli_prcusp                               ; 005A8  0xE8, 0xF1, 0x04

loc_005AB:  ; 005AB
  db 0xBB, 0x85, 0x04                         ; 005AB  mov bx, 0x485
  db 0xA0, 0x9C, 0x04                         ; 005AE  mov al, byte [0x49c]
  db 0x88, 0x07                               ; 005B1  mov byte [bx], al
  db 0xC6, 0x47, 0x01, 0x00                   ; 005B3  mov byte [bx + 1], 0
  db 0xC7, 0x47, 0x02, 0x01, 0x00             ; 005B7  mov word [bx + 2], 1
  call cli_conasn                               ; 005BC  0xE8, 0x6E, 0x05
  db 0x33, 0xC9                               ; 005BF  xor cx, cx
  db 0xC3                                     ; 005C1  ret

loc_005C2:  ; 005C2
  db 0x9C                                     ; 005C2  pushf
  db 0xFA                                     ; 005C3  cli
  db 0x8B, 0x1E, 0x5C, 0x00                   ; 005C4  mov bx, word [0x5c]
  db 0x83, 0xFB, 0x00                         ; 005C8  cmp bx, 0
  jne loc_005D7                                ; 005CB  0x75, 0x0A
  db 0x9D                                     ; 005CD  popf
  db 0xC7, 0x06, 0x97, 0x04, 0x0C, 0x00       ; 005CE  mov word [0x497], 0xc
  jmp near loc_00932                           ; 005D4  0xE9, 0x5B, 0x03

loc_005D7:  ; 005D7
  db 0x8B, 0x37                               ; 005D7  mov si, word [bx]
  db 0x89, 0x36, 0x5C, 0x00                   ; 005D9  mov word [0x5c], si
  db 0x9D                                     ; 005DD  popf
  db 0x89, 0x1E, 0x95, 0x04                   ; 005DE  mov word [0x495], bx
  db 0x06                                     ; 005E2  push es
  db 0x1E                                     ; 005E3  push ds
  db 0x07                                     ; 005E4  pop es
  db 0x8B, 0xFB                               ; 005E5  mov di, bx
  db 0xB9, 0x18, 0x00                         ; 005E7  mov cx, 0x18
  db 0x33, 0xC0                               ; 005EA  xor ax, ax
  db 0xF3, 0xAB                               ; 005EC  rep stosw
  db 0x07                                     ; 005EE  pop es
  db 0x8B, 0x1E, 0x95, 0x04                   ; 005EF  mov bx, word [0x495]
  db 0xC7, 0x47, 0x06, 0x10, 0x00             ; 005F3  mov word [bx + 6], 0x10
  db 0x8B, 0xFB                               ; 005F8  mov di, bx
  db 0x83, 0xC7, 0x08                         ; 005FA  add di, 8
  db 0xBE, 0x54, 0x04                         ; 005FD  mov si, 0x454
  db 0x83, 0xC6, 0x01                         ; 00600  add si, 1
  db 0x06                                     ; 00603  push es
  db 0x8C, 0xD8                               ; 00604  mov ax, ds
  db 0x8E, 0xC0                               ; 00606  mov es, ax
  db 0xB9, 0x04, 0x00                         ; 00608  mov cx, 4
  db 0xF3, 0xA5                               ; 0060B  rep movsw
  db 0x07                                     ; 0060D  pop es
  db 0x8B, 0x36, 0x68, 0x00                   ; 0060E  mov si, word [0x68]
  db 0xA0, 0x9E, 0x04                         ; 00612  mov al, byte [0x49e]
  db 0x88, 0x47, 0x12                         ; 00615  mov byte p_dsk[bx], al
  db 0xA0, 0x9D, 0x04                         ; 00618  mov al, byte [0x49d]
  db 0x88, 0x47, 0x13                         ; 0061B  mov byte p_user[bx], al
  db 0xA0, 0x9C, 0x04                         ; 0061E  mov al, byte [0x49c]
  db 0x88, 0x47, 0x20                         ; 00621  mov byte p_cns[bx], al
  db 0x8A, 0x44, 0x24                         ; 00624  mov al, byte p_lst[si]
  db 0x88, 0x47, 0x24                         ; 00627  mov byte p_lst[bx], al
  db 0xBE, 0x54, 0x04                         ; 0062A  mov si, 0x454
  db 0x80, 0x7C, 0x1A, 0x00                   ; 0062D  cmp byte p_wait[si], 0
  je loc_00651                                 ; 00631  0x74, 0x1E
  db 0xBE, 0x64, 0x04                         ; 00633  mov si, 0x464
  db 0xBF, 0x4F, 0x03                         ; 00636  mov di, 0x34f
  db 0x06                                     ; 00639  push es
  db 0x2E, 0x8E, 0x06, 0x06, 0x00             ; 0063A  mov es, word [cs:6]
  db 0xB9, 0x04, 0x00                         ; 0063F  mov cx, 4
  db 0xF3, 0xA5                               ; 00642  rep movsw
  db 0x07                                     ; 00644  pop es
  db 0x26, 0xC7, 0x06, 0x02, 0x00, 0x4F, 0x03 ; 00645  mov word [es:2], 0x34f
  db 0x26, 0x8C, 0x1E, 0x04, 0x00             ; 0064C  mov word [es:4], ds

loc_00651:  ; 00651
  db 0xBE, 0x54, 0x04                         ; 00651  mov si, 0x454
  db 0xC6, 0x44, 0x09, 0x43                   ; 00654  mov byte [si + 9], 0x43
  db 0xC6, 0x44, 0x0A, 0x4D                   ; 00658  mov byte [si + 0xa], 0x4d
  db 0xC6, 0x44, 0x0B, 0x44                   ; 0065C  mov byte [si + 0xb], 0x44
  call cli_open_wait                               ; 00660  0xE8, 0xA2, 0x04
  db 0x80, 0xFB, 0xFF                         ; 00663  cmp bl, 0xff
  jne loc_006BC                                ; 00666  0x75, 0x54
  db 0x80, 0xFF, 0x00                         ; 00668  cmp bh, 0
  jne loc_006BE                                ; 0066B  0x75, 0x51
  db 0x8A, 0x0E, 0x4B, 0x00                   ; 0066D  mov cl, byte [0x4b]
  db 0x3A, 0x0E, 0x9E, 0x04                   ; 00671  cmp cl, byte [0x49e]
  je loc_006BE                                 ; 00675  0x74, 0x47
  db 0x80, 0x3E, 0x54, 0x04, 0x00             ; 00677  cmp byte [0x454], 0
  jne loc_006BE                                ; 0067C  0x75, 0x40
  db 0xFE, 0xC1                               ; 0067E  inc cl
  db 0x88, 0x0E, 0x54, 0x04                   ; 00680  mov byte [0x454], cl
  call cli_open_wait                               ; 00684  0xE8, 0x7E, 0x04
  db 0x80, 0xFB, 0xFF                         ; 00687  cmp bl, 0xff
  je loc_006BE                                 ; 0068A  0x74, 0x32
  db 0xBB, 0x54, 0x04                         ; 0068C  mov bx, 0x454
  db 0xF6, 0x47, 0x0A, 0x80                   ; 0068F  test byte [bx + 0xa], 0x80
  jne loc_006FC                                ; 00693  0x75, 0x67
  call cli_flopn                               ; 00695  0xE8, 0x46, 0x04
  db 0x8B, 0x1E, 0x68, 0x00                   ; 00698  mov bx, word [0x68]
  db 0x80, 0x7F, 0x13, 0x00                   ; 0069C  cmp byte p_user[bx], 0
  je loc_006F3                                 ; 006A0  0x74, 0x51
  db 0xC6, 0x47, 0x13, 0x00                   ; 006A2  mov byte p_user[bx], 0
  call cli_open_wait                               ; 006A6  0xE8, 0x5C, 0x04
  db 0x80, 0xFB, 0xFF                         ; 006A9  cmp bl, 0xff
  je loc_006BE                                 ; 006AC  0x74, 0x10
  db 0xBB, 0x54, 0x04                         ; 006AE  mov bx, 0x454
  db 0xF6, 0x47, 0x0A, 0x80                   ; 006B1  test byte [bx + 0xa], 0x80
  jne loc_006FC                                ; 006B5  0x75, 0x45
  call cli_flopn                               ; 006B7  0xE8, 0x24, 0x04
  jmp short loc_006F3                          ; 006BA  0xEB, 0x37

loc_006BC:  ; 006BC
  jmp short loc_006FC                          ; 006BC  0xEB, 0x3E

loc_006BE:  ; 006BE
  db 0x80, 0xFF, 0x00                         ; 006BE  cmp bh, 0
  je loc_006F3                                 ; 006C1  0x74, 0x30
  db 0xB9, 0x17, 0x00                         ; 006C3  mov cx, 0x17
  db 0x80, 0xFF, 0x04                         ; 006C6  cmp bh, 4
  je loc_006ED                                 ; 006C9  0x74, 0x22
  db 0xB9, 0x26, 0x00                         ; 006CB  mov cx, 0x26
  db 0x80, 0xFF, 0x07                         ; 006CE  cmp bh, 7
  je loc_006ED                                 ; 006D1  0x74, 0x1A
  db 0xB9, 0x18, 0x00                         ; 006D3  mov cx, 0x18
  db 0x80, 0xFF, 0x09                         ; 006D6  cmp bh, 9
  je loc_006ED                                 ; 006D9  0x74, 0x12
  db 0xB9, 0x1D, 0x00                         ; 006DB  mov cx, 0x1d
  db 0x80, 0xFF, 0x01                         ; 006DE  cmp bh, 1
  je loc_006ED                                 ; 006E1  0x74, 0x0A
  db 0xB9, 0x28, 0x00                         ; 006E3  mov cx, 0x28
  db 0x80, 0xFF, 0xFF                         ; 006E6  cmp bh, 0xff
  je loc_006ED                                 ; 006E9  0x74, 0x02
  jmp short loc_006F3                          ; 006EB  0xEB, 0x06

loc_006ED:  ; 006ED
  db 0x89, 0x0E, 0x97, 0x04                   ; 006ED  mov word [0x497], cx
  jmp short loc_006F9                          ; 006F1  0xEB, 0x06

loc_006F3:  ; 006F3
  db 0xC7, 0x06, 0x97, 0x04, 0x1E, 0x00       ; 006F3  mov word [0x497], 0x1e

loc_006F9:  ; 006F9
  jmp near loc_00900                           ; 006F9  0xE9, 0x04, 0x02

loc_006FC:  ; 006FC
  db 0x8B, 0x1E, 0x68, 0x00                   ; 006FC  mov bx, word [0x68]
  db 0xF7, 0x47, 0x06, 0x80, 0x00             ; 00700  test word [bx + 6], 0x80
  je loc_00710                                 ; 00705  0x74, 0x09
  db 0xBB, 0xFF, 0xFF                         ; 00707  mov bx, 0xffff
  db 0xB9, 0x28, 0x00                         ; 0070A  mov cx, 0x28
  jmp near loc_007BF                           ; 0070D  0xE9, 0xAF, 0x00

loc_00710:  ; 00710
  db 0x80, 0x3E, 0x90, 0x00, 0xFF             ; 00710  cmp byte [0x90], 0xff
  jne loc_0074A                                ; 00715  0x75, 0x33
  db 0x8B, 0x1E, 0x95, 0x04                   ; 00717  mov bx, word [0x495]
  db 0xBE, 0x54, 0x04                         ; 0071B  mov si, 0x454
  db 0xC6, 0x47, 0x18, 0x00                   ; 0071E  mov byte p_cmod[bx], 0
  db 0xF6, 0x44, 0x01, 0x80                   ; 00722  test byte [si + 1], 0x80
  je loc_0072C                                 ; 00726  0x74, 0x04
  db 0x80, 0x4F, 0x18, 0x80                   ; 00728  or byte p_cmod[bx], 0x80

loc_0072C:  ; 0072C
  db 0xF6, 0x44, 0x02, 0x80                   ; 0072C  test byte [si + 2], 0x80
  je loc_00736                                 ; 00730  0x74, 0x04
  db 0x80, 0x4F, 0x18, 0x40                   ; 00732  or byte p_cmod[bx], 0x40

loc_00736:  ; 00736
  db 0xF6, 0x44, 0x03, 0x80                   ; 00736  test byte [si + 3], 0x80
  je loc_00740                                 ; 0073A  0x74, 0x04
  db 0x80, 0x4F, 0x18, 0x20                   ; 0073C  or byte p_cmod[bx], 0x20

loc_00740:  ; 00740
  db 0xF6, 0x44, 0x04, 0x80                   ; 00740  test byte [si + 4], 0x80
  je loc_0074A                                 ; 00744  0x74, 0x04
  db 0x80, 0x4F, 0x18, 0x70                   ; 00746  or byte p_cmod[bx], 0x70

loc_0074A:  ; 0074A
  db 0x80, 0x3E, 0x4D, 0x03, 0xFF             ; 0074A  cmp byte [0x34d], 0xff
  jne loc_00789                                ; 0074F  0x75, 0x38
  db 0x8B, 0x1E, 0x95, 0x04                   ; 00751  mov bx, word [0x495]
  db 0x8C, 0x47, 0x10                         ; 00755  mov word p_uda[bx], es
  db 0xB8, 0xE0, 0x04                         ; 00758  mov ax, 0x4e0
  db 0xB1, 0x04                               ; 0075B  mov cl, 4
  db 0xD3, 0xE8                               ; 0075D  shr ax, cl
  db 0x2E, 0x03, 0x06, 0x06, 0x00             ; 0075F  add ax, word [cs:6]
  db 0x8C, 0xC3                               ; 00764  mov bx, es
  db 0x8E, 0xC0                               ; 00766  mov es, ax
  db 0xBF, 0x00, 0x00                         ; 00768  mov di, 0
  db 0x8E, 0xDB                               ; 0076B  mov ds, bx
  db 0x8B, 0xF7                               ; 0076D  mov si, di
  db 0xB9, 0x80, 0x00                         ; 0076F  mov cx, 0x80
  db 0xF3, 0xA5                               ; 00772  rep movsw
  db 0x9C                                     ; 00774  pushf
  db 0xFA                                     ; 00775  cli
  db 0x5A                                     ; 00776  pop dx
  db 0x8C, 0xC0                               ; 00777  mov ax, es
  db 0x2E, 0x8E, 0x1E, 0x06, 0x00             ; 00779  mov ds, word [cs:6]
  db 0x8E, 0xD0                               ; 0077E  mov ss, ax
  db 0x8B, 0x1E, 0x68, 0x00                   ; 00780  mov bx, word [0x68]
  db 0x89, 0x47, 0x10                         ; 00784  mov word p_uda[bx], ax
  db 0x52                                     ; 00787  push dx
  db 0x9D                                     ; 00788  popf

loc_00789:  ; 00789
  db 0x80, 0x3E, 0xA0, 0x04, 0xFF             ; 00789  cmp byte [0x4a0], 0xff
  jne loc_00796                                ; 0078E  0x75, 0x06
  call cli_prfilnam                               ; 00790  0xE8, 0xB1, 0x02
  call cli_crlf                               ; 00793  0xE8, 0x5C, 0x02

loc_00796:  ; 00796
  db 0x8B, 0x1E, 0x95, 0x04                   ; 00796  mov bx, word [0x495]
  db 0xBA, 0x54, 0x04                         ; 0079A  mov dx, 0x454
  db 0xB9, 0x0A, 0x01                         ; 0079D  mov cx, 0x10a
  db 0x80, 0x3E, 0x4D, 0x03, 0xFF             ; 007A0  cmp byte [0x34d], 0xff
  jne loc_007BC                                ; 007A5  0x75, 0x15
  db 0xC6, 0x06, 0x4E, 0x03, 0xFF             ; 007A7  mov byte [0x34e], 0xff
  db 0xB9, 0x0E, 0x01                         ; 007AC  mov cx, 0x10e
  call rtm_dispatcher                          ; 007AF  0xE8, 0x61, 0xFB
  jcxz loc_007BF                               ; 007B2  0xE3, 0x0B
  db 0xC6, 0x06, 0x4E, 0x03, 0x00             ; 007B4  mov byte [0x34e], 0
  jmp near loc_007BF                           ; 007B9  0xE9, 0x03, 0x00

loc_007BC:  ; 007BC
  call rtm_dispatcher                          ; 007BC  0xE8, 0x54, 0xFB

loc_007BF:  ; 007BF
  db 0x53                                     ; 007BF  push bx
  db 0x51                                     ; 007C0  push cx
  call cli_flopn                               ; 007C1  0xE8, 0x1A, 0x03
  db 0x59                                     ; 007C4  pop cx
  db 0x5B                                     ; 007C5  pop bx
  jcxz loc_007CF                               ; 007C6  0xE3, 0x07
  db 0x89, 0x0E, 0x97, 0x04                   ; 007C8  mov word [0x497], cx
  jmp near loc_00900                           ; 007CC  0xE9, 0x31, 0x01

loc_007CF:  ; 007CF
  db 0x89, 0x1E, 0x99, 0x04                   ; 007CF  mov word [0x499], bx
  db 0x06                                     ; 007D3  push es
  db 0x8E, 0x06, 0x99, 0x04                   ; 007D4  mov es, word [0x499]
  db 0xBF, 0x81, 0x00                         ; 007D8  mov di, 0x81
  db 0xBE, 0xD2, 0x03                         ; 007DB  mov si, 0x3d2
  db 0xB9, 0x7F, 0x00                         ; 007DE  mov cx, 0x7f
  db 0xF3, 0xA4                               ; 007E1  rep movsb
  db 0x07                                     ; 007E3  pop es
  db 0x1E                                     ; 007E4  push ds
  db 0x8E, 0x1E, 0x99, 0x04                   ; 007E5  mov ds, word [0x499]
  db 0xB1, 0x00                               ; 007E9  mov cl, 0
  db 0xBF, 0x81, 0x00                         ; 007EB  mov di, 0x81

loc_007EE:  ; 007EE
  db 0x80, 0x3D, 0x00                         ; 007EE  cmp byte [di], 0
  je loc_00805                                 ; 007F1  0x74, 0x12
  db 0x80, 0x3D, 0x61                         ; 007F3  cmp byte [di], 0x61
  jb loc_00800                                 ; 007F6  0x72, 0x08
  db 0x80, 0x3D, 0x7A                         ; 007F8  cmp byte [di], 0x7a
  ja loc_00800                                 ; 007FB  0x77, 0x03
  db 0x80, 0x25, 0x5F                         ; 007FD  and byte [di], 0x5f

loc_00800:  ; 00800
  db 0x47                                     ; 00800  inc di
  db 0xFE, 0xC1                               ; 00801  inc cl
  jmp short loc_007EE                          ; 00803  0xEB, 0xE9

loc_00805:  ; 00805
  db 0x88, 0x0E, 0x80, 0x00                   ; 00805  mov byte [0x80], cl
  db 0x1F                                     ; 00809  pop ds
  db 0x06                                     ; 0080A  push es
  db 0x8E, 0x06, 0x99, 0x04                   ; 0080B  mov es, word [0x499]
  db 0xBF, 0x5C, 0x00                         ; 0080F  mov di, 0x5c
  db 0x33, 0xC0                               ; 00812  xor ax, ax
  db 0xAA                                     ; 00814  stosb
  db 0xB0, 0x20                               ; 00815  mov al, 0x20
  db 0xB9, 0x0B, 0x00                         ; 00817  mov cx, 0xb
  db 0xF3, 0xAA                               ; 0081A  rep stosb
  db 0x33, 0xC0                               ; 0081C  xor ax, ax
  db 0xB9, 0x02, 0x00                         ; 0081E  mov cx, 2
  db 0xF3, 0xAB                               ; 00821  rep stosw
  db 0x1E                                     ; 00823  push ds
  db 0x06                                     ; 00824  push es
  db 0x1F                                     ; 00825  pop ds
  db 0xBE, 0x5C, 0x00                         ; 00826  mov si, 0x5c
  db 0xB9, 0x08, 0x00                         ; 00829  mov cx, 8
  db 0xF3, 0xA5                               ; 0082C  rep movsw
  db 0x1F                                     ; 0082E  pop ds
  db 0x07                                     ; 0082F  pop es
  db 0x80, 0x3E, 0xD2, 0x03, 0x00             ; 00830  cmp byte [0x3d2], 0
  je loc_008A3                                 ; 00835  0x74, 0x6C
  call cli_pfn                               ; 00837  0xE8, 0xEB, 0x02
  db 0x83, 0xFB, 0xFF                         ; 0083A  cmp bx, -1
  je loc_008A3                                 ; 0083D  0x74, 0x64
  db 0x06                                     ; 0083F  push es
  db 0x8E, 0x06, 0x99, 0x04                   ; 00840  mov es, word [0x499]
  db 0xBF, 0x5C, 0x00                         ; 00844  mov di, 0x5c
  db 0xBE, 0x54, 0x04                         ; 00847  mov si, 0x454
  db 0x8B, 0x44, 0x18                         ; 0084A  mov ax, word p_cmod[si]
  db 0x2D, 0xD2, 0x03                         ; 0084D  sub ax, 0x3d2
  db 0x05, 0x81, 0x00                         ; 00850  add ax, 0x81
  db 0x26, 0xA3, 0x51, 0x00                   ; 00853  mov word [es:0x51], ax
  db 0x8A, 0x44, 0x1A                         ; 00857  mov al, byte p_wait[si]
  db 0x26, 0xA2, 0x53, 0x00                   ; 0085A  mov byte [es:0x53], al
  db 0xB9, 0x08, 0x00                         ; 0085E  mov cx, 8
  db 0xF3, 0xA5                               ; 00861  rep movsw
  db 0x07                                     ; 00863  pop es
  db 0x83, 0xFB, 0x00                         ; 00864  cmp bx, 0
  je loc_008A3                                 ; 00867  0x74, 0x3A
  db 0xFF, 0x36, 0x91, 0x04                   ; 00869  push word [0x491]
  db 0x43                                     ; 0086D  inc bx
  db 0x89, 0x1E, 0x91, 0x04                   ; 0086E  mov word [0x491], bx
  call cli_pfn                               ; 00872  0xE8, 0xB0, 0x02
  db 0x8F, 0x06, 0x91, 0x04                   ; 00875  pop word [0x491]
  db 0x83, 0xFB, 0xFF                         ; 00879  cmp bx, -1
  je loc_008A3                                 ; 0087C  0x74, 0x25
  db 0x06                                     ; 0087E  push es
  db 0x8E, 0x06                                                   ; 0087F  ..

io_switch:  ; 00881
  db 0x99                                     ; 00881  cdq
  db 0x04, 0xBF                               ; 00882  add al, 0xbf
  db 0x6C                                     ; 00884  insb
  db 0x00, 0xBE, 0x54, 0x04                   ; 00885  add byte [bp + 0x454], bh
  db 0x8B, 0x44, 0x18                         ; 00889  mov ax, word p_cmod[si]
  db 0x2D, 0xD2, 0x03                         ; 0088C  sub ax, 0x3d2
  db 0x05, 0x81, 0x00                         ; 0088F  add ax, 0x81
  db 0x26, 0xA3, 0x54, 0x00                   ; 00892  mov word [es:0x54], ax
  db 0x8A, 0x44, 0x1A                         ; 00896  mov al, byte p_wait[si]
  db 0x26, 0xA2, 0x56, 0x00                   ; 00899  mov byte [es:0x56], al
  db 0xB9, 0x08, 0x00                         ; 0089D  mov cx, 8
  db 0xF3, 0xA5                               ; 008A0  rep movsw
  db 0x07                                     ; 008A2  pop es

loc_008A3:  ; 008A3
  db 0x80, 0x3E, 0x4D, 0x03, 0xFF             ; 008A3  cmp byte [0x34d], 0xff
  jne loc_008B3                                ; 008A8  0x75, 0x09
  db 0xB9, 0x91, 0x00                         ; 008AA  mov cx, 0x91
  db 0xBA, 0x01, 0x00                         ; 008AD  mov dx, 1
  call rtm_dispatcher                          ; 008B0  0xE8, 0x60, 0xFA

loc_008B3:  ; 008B3
  db 0x8B, 0x36, 0x95, 0x04                   ; 008B3  mov si, word [0x495]
  db 0x81, 0x4C, 0x06, 0x00, 0x20             ; 008B7  or word [si + 6], 0x2000
  db 0x8B, 0xD6                               ; 008BC  mov dx, si
  db 0xB9, 0x90, 0x00                         ; 008BE  mov cx, 0x90
  call rtm_dispatcher                          ; 008C1  0xE8, 0x4F, 0xFA
  db 0x8B, 0x1E, 0x68, 0x00                   ; 008C4  mov bx, word [0x68]
  db 0x81, 0x67, 0x06, 0x7F, 0xFF             ; 008C8  and word [bx + 6], 0xff7f
  db 0xF7, 0x47, 0x06, 0x00, 0x04             ; 008CD  test word [bx + 6], 0x400
  je loc_008E5                                 ; 008D2  0x74, 0x11
  db 0x81, 0x67, 0x06, 0xFF, 0xFB             ; 008D4  and word [bx + 6], 0xfbff
  db 0x8B, 0x1E, 0x95, 0x04                   ; 008D9  mov bx, word [0x495]
  db 0x81, 0x4F, 0x06, 0x00, 0x04             ; 008DD  or word [bx + 6], 0x400
  jmp near loc_00932                           ; 008E2  0xE9, 0x4D, 0x00

loc_008E5:  ; 008E5
  db 0xBB, 0x85, 0x04                         ; 008E5  mov bx, 0x485
  db 0xA0, 0x9C, 0x04                         ; 008E8  mov al, byte [0x49c]
  db 0x88, 0x07                               ; 008EB  mov byte [bx], al
  db 0xA1, 0x95, 0x04                         ; 008ED  mov ax, word [0x495]
  db 0x89, 0x47, 0x02                         ; 008F0  mov word [bx + 2], ax
  db 0xC6, 0x47, 0x01, 0xFF                   ; 008F3  mov byte [bx + 1], 0xff
  call cli_conasn                               ; 008F7  0xE8, 0x33, 0x02
  db 0x89, 0x0E, 0x97, 0x04                   ; 008FA  mov word [0x497], cx
  jmp short loc_00932                          ; 008FE  0xEB, 0x32

loc_00900:  ; 00900
  db 0x8B, 0x36, 0x95, 0x04                   ; 00900  mov si, word [0x495]
  db 0x83, 0x7C, 0x16, 0x00                   ; 00904  cmp word p_mem[si], 0
  je loc_00925                                 ; 00908  0x74, 0x1B
  db 0x1E                                     ; 0090A  push ds
  db 0x06                                     ; 0090B  push es
  db 0x56                                     ; 0090C  push si
  db 0x8B, 0x74, 0x16                         ; 0090D  mov si, word p_mem[si]
  db 0xFF, 0x74, 0x02                         ; 00910  push word [si + 2]
  db 0xB9, 0x82, 0x00                         ; 00913  mov cx, 0x82
  db 0x8B, 0xD4                               ; 00916  mov dx, sp
  db 0x8C, 0xD0                               ; 00918  mov ax, ss
  db 0x8E, 0xD8                               ; 0091A  mov ds, ax
  call rtm_dispatcher                          ; 0091C  0xE8, 0xF4, 0xF9
  db 0x58                                     ; 0091F  pop ax
  db 0x5E                                     ; 00920  pop si
  db 0x07                                     ; 00921  pop es
  db 0x1F                                     ; 00922  pop ds
  jmp short loc_00900                          ; 00923  0xEB, 0xDB

loc_00925:  ; 00925
  db 0x9C                                     ; 00925  pushf
  db 0xFA                                     ; 00926  cli
  db 0x8B, 0x1E, 0x5C, 0x00                   ; 00927  mov bx, word [0x5c]
  db 0x89, 0x1C                               ; 0092B  mov word [si], bx
  db 0x89, 0x36, 0x5C, 0x00                   ; 0092D  mov word [0x5c], si
  db 0x9D                                     ; 00931  popf

loc_00932:  ; 00932
  db 0x8B, 0x1E, 0x68, 0x00                   ; 00932  mov bx, word [0x68]
  db 0x8A, 0x0E, 0x9E, 0x04                   ; 00936  mov cl, byte [0x49e]
  db 0x88, 0x4F, 0x12                         ; 0093A  mov byte p_dsk[bx], cl
  db 0x8A, 0x0E, 0x9D, 0x04                   ; 0093D  mov cl, byte [0x49d]
  db 0x88, 0x4F, 0x13                         ; 00941  mov byte p_user[bx], cl
  db 0x8A, 0x0E, 0x9F, 0x04                   ; 00944  mov cl, byte [0x49f]
  db 0x26, 0x88, 0x0E, 0x10, 0x00             ; 00948  mov byte [es:0x10], cl
  db 0x8B, 0x0E, 0x47, 0x03                   ; 0094D  mov cx, word [0x347]
  db 0x26, 0x89, 0x0E, 0x02, 0x00             ; 00951  mov word [es:2], cx
  db 0x8B, 0x0E, 0x49, 0x03                   ; 00956  mov cx, word [0x349]
  db 0x26, 0x89, 0x0E, 0x04, 0x00             ; 0095A  mov word [es:4], cx
  db 0x80, 0x3E, 0x4D, 0x03, 0xFF             ; 0095F  cmp byte [0x34d], 0xff
  jne loc_0098A                                ; 00964  0x75, 0x24
  db 0x8B, 0x1E, 0x68, 0x00                   ; 00966  mov bx, word [0x68]
  db 0x8B, 0x36, 0x95, 0x04                   ; 0096A  mov si, word [0x495]
  db 0x8B, 0x47, 0x1E                         ; 0096E  mov ax, word p_parent[bx]
  db 0x89, 0x44, 0x1E                         ; 00971  mov word p_parent[si], ax
  db 0x80, 0x3E, 0x4E, 0x03, 0xFF             ; 00974  cmp byte [0x34e], 0xff
  jne loc_0098A                                ; 00979  0x75, 0x0F
  db 0x81, 0x67, 0x06, 0x7C, 0xFD             ; 0097B  and word [bx + 6], 0xfd7c
  db 0xC6, 0x47, 0x19, 0x00                   ; 00980  mov byte p_tkcnt[bx], 0
  db 0xB9, 0x8F, 0x00                         ; 00984  mov cx, 0x8f
  jmp near rtm_dispatcher                      ; 00987  0xE9, 0x89, 0xF9

loc_0098A:  ; 0098A
  db 0xFF, 0x36, 0x4B, 0x03                   ; 0098A  push word [0x34b]
  db 0xFF, 0x36, 0x97, 0x04                   ; 0098E  push word [0x497]
  call cli_unsync                               ; 00992  0xE8, 0x87, 0x01
  db 0xB9, 0x18, 0x02                         ; 00995  mov cx, 0x218
  call rtm_dispatcher                          ; 00998  0xE8, 0x78, 0xF9
  db 0x5A                                     ; 0099B  pop dx
  db 0x58                                     ; 0099C  pop ax
  db 0x25, 0x00, 0x10                         ; 0099D  and ax, 0x1000
  db 0x8B, 0x1E, 0x68, 0x00                   ; 009A0  mov bx, word [0x68]
  db 0x8B, 0x4F, 0x06                         ; 009A4  mov cx, word [bx + 6]
  db 0x81, 0xE1, 0xFF, 0xEF                   ; 009A7  and cx, 0xefff
  db 0x0B, 0xC8                               ; 009AB  or cx, ax
  db 0x89, 0x4F, 0x06                         ; 009AD  mov word [bx + 6], cx
  db 0xF7, 0x47, 0x06, 0x80, 0x00             ; 009B0  test word [bx + 6], 0x80
  je loc_009C7                                 ; 009B5  0x74, 0x10
  db 0xB9, 0x8F, 0x00                         ; 009B7  mov cx, 0x8f
  db 0x33, 0xD2                               ; 009BA  xor dx, dx
  call rtm_dispatcher                          ; 009BC  0xE8, 0x54, 0xF9
  db 0x81, 0x67, 0x06, 0x7F, 0xFF             ; 009BF  and word [bx + 6], 0xff7f
  db 0xBA, 0x28, 0x00                         ; 009C4  mov dx, 0x28

loc_009C7:  ; 009C7
  db 0x8B, 0xCA                               ; 009C7  mov cx, dx
  db 0x33, 0xDB                               ; 009C9  xor bx, bx
  jcxz loc_009D0                               ; 009CB  0xE3, 0x03
  db 0xBB, 0xFF, 0xFF                         ; 009CD  mov bx, 0xffff

loc_009D0:  ; 009D0
  db 0xC3                                     ; 009D0  ret

cli_parse_tail:  ; 009D1
  db 0x3D, 0x00, 0x00                         ; 009D1  cmp ax, 0
  je loc_009EC                                 ; 009D4  0x74, 0x16
  db 0x50                                     ; 009D6  push ax
  db 0x2D, 0xD2, 0x03                         ; 009D7  sub ax, 0x3d2
  db 0xB9, 0x80, 0x00                         ; 009DA  mov cx, 0x80
  db 0x2B, 0xC8                               ; 009DD  sub cx, ax
  db 0xD1, 0xE9                               ; 009DF  shr cx, 1
  db 0x5E                                     ; 009E1  pop si
  db 0xBF, 0xD2, 0x03                         ; 009E2  mov di, 0x3d2
  db 0x06                                     ; 009E5  push es
  db 0x1E                                     ; 009E6  push ds
  db 0x07                                     ; 009E7  pop es
  db 0xF3, 0xA5                               ; 009E8  rep movsw
  db 0x07                                     ; 009EA  pop es
  db 0xC3                                     ; 009EB  ret

loc_009EC:  ; 009EC
  db 0xC6, 0x06, 0xD2, 0x03, 0x00             ; 009EC  mov byte [0x3d2], 0
  db 0xC3                                     ; 009F1  ret

cli_crlf:  ; 009F2
  db 0xB2, 0x0D                               ; 009F2  mov dl, 0xd
  call cli_prchar                               ; 009F4  0xE8, 0x02, 0x00
  db 0xB2, 0x0A                               ; 009F7  mov dl, 0xa

cli_prchar:  ; 009F9
  db 0x26, 0x8B, 0x36, 0x62, 0x00             ; 009F9  mov si, word [es:0x62]
  db 0x8B, 0x3E, 0x68, 0x00                   ; 009FE  mov di, word [0x68]
  db 0x39, 0x3C                               ; 00A02  cmp word [si], di
  jne loc_00A0C                                ; 00A04  0x75, 0x06
  db 0xB9, 0x02, 0x00                         ; 00A06  mov cx, 2
  jmp near rtm_dispatcher                      ; 00A09  0xE9, 0x07, 0xF9

loc_00A0C:  ; 00A0C
  db 0xC3                                     ; 00A0C  ret

cli_prtime:  ; 00A0D
  db 0x8A, 0x16, 0x80, 0x00                   ; 00A0D  mov dl, byte [0x80]
  call cli_prnum                               ; 00A11  0xE8, 0x1C, 0x00
  db 0xB2, 0x3A                               ; 00A14  mov dl, 0x3a
  call cli_prchar                               ; 00A16  0xE8, 0xE0, 0xFF
  db 0x8A, 0x16, 0x81, 0x00                   ; 00A19  mov dl, byte [0x81]
  call cli_prnum                               ; 00A1D  0xE8, 0x10, 0x00
  db 0xB2, 0x3A                               ; 00A20  mov dl, 0x3a
  call cli_prchar                               ; 00A22  0xE8, 0xD4, 0xFF
  db 0x8A, 0x16, 0x82, 0x00                   ; 00A25  mov dl, byte [0x82]
  call cli_prnum                               ; 00A29  0xE8, 0x04, 0x00
  db 0xB2, 0x20                               ; 00A2C  mov dl, 0x20
  jmp short cli_prchar                          ; 00A2E  0xEB, 0xC9

cli_prnum:  ; 00A30
  db 0x52                                     ; 00A30  push dx
  db 0xB1, 0x04                               ; 00A31  mov cl, 4
  db 0xD2, 0xEA                               ; 00A33  shr dl, cl
  db 0x80, 0xC2, 0x30                         ; 00A35  add dl, 0x30
  call cli_prchar                               ; 00A38  0xE8, 0xBE, 0xFF
  db 0x5A                                     ; 00A3B  pop dx
  db 0x80, 0xE2, 0x0F                         ; 00A3C  and dl, 0xf
  db 0x80, 0xC2, 0x30                         ; 00A3F  add dl, 0x30
  jmp short cli_prchar                          ; 00A42  0xEB, 0xB5

cli_prfilnam:  ; 00A44
  call cli_prdisk                               ; 00A44  0xE8, 0x36, 0x00
  db 0xBA, 0x55, 0x04                         ; 00A47  mov dx, 0x455
  call cli_prnam                               ; 00A4A  0xE8, 0x7B, 0x00
  db 0xB2, 0x2E                               ; 00A4D  mov dl, 0x2e
  call cli_prchar                               ; 00A4F  0xE8, 0xA7, 0xFF
  db 0xBA, 0x5D, 0x04                         ; 00A52  mov dx, 0x45d
  call cli_prtyp                               ; 00A55  0xE8, 0x6C, 0x00
  db 0xB2, 0x20                               ; 00A58  mov dl, 0x20
  call cli_prchar                               ; 00A5A  0xE8, 0x9C, 0xFF
  db 0xBB, 0x54, 0x04                         ; 00A5D  mov bx, 0x454
  db 0xF6, 0x47, 0x08, 0x80                   ; 00A60  test byte [bx + 8], 0x80
  jne loc_00A78                                ; 00A64  0x75, 0x12
  db 0x80, 0x3E, 0x9D, 0x04, 0x00             ; 00A66  cmp byte [0x49d], 0

io_write:  ; 00A6B
  je loc_00A77                                 ; 00A6B  0x74, 0x0A
  db 0x8B, 0x1E, 0x68, 0x00                   ; 00A6D  mov bx, word [0x68]
  db 0x80, 0x7F, 0x13, 0x00                   ; 00A71  cmp byte p_user[bx], 0
  je loc_00A78                                 ; 00A75  0x74, 0x01

loc_00A77:  ; 00A77
  db 0xC3                                     ; 00A77  ret

loc_00A78:  ; 00A78
  db 0xBA, 0xBF, 0x0A                         ; 00A78  mov dx, 0xabf
  jmp short cli_prcsm                          ; 00A7B  0xEB, 0x2E

cli_prdisk:  ; 00A7D
  db 0x8A, 0x16, 0x54, 0x04                   ; 00A7D  mov dl, byte [0x454]
  db 0x80, 0xFA, 0x00                         ; 00A81  cmp dl, 0
  je loc_00A8A                                 ; 00A84  0x74, 0x04
  db 0xFE                                                         ; 00A86  .

loc_00A87:  ; 00A87
  db 0xCA, 0xEB, 0x07                         ; 00A87  retf 0x7eb

loc_00A8A:  ; 00A8A
  db 0x8B, 0x1E, 0x68, 0x00                   ; 00A8A  mov bx, word [0x68]
  db 0x8A, 0x57, 0x12                         ; 00A8E  mov dl, byte p_dsk[bx]
  db 0x80, 0xC2, 0x41                         ; 00A91  add dl, 0x41
  call cli_prchar                               ; 00A94  0xE8, 0x62, 0xFF
  db 0xB2, 0x3A                               ; 00A97  mov dl, 0x3a
  jmp near cli_prchar                           ; 00A99  0xE9, 0x5D, 0xFF

cli_prcusp:  ; 00A9C
  db 0xBA, 0x7D, 0x04                         ; 00A9C  mov dx, 0x47d
  call cli_prnam                               ; 00A9F  0xE8, 0x26, 0x00
  db 0xBA, 0xB5, 0x0A                         ; 00AA2  mov dx, 0xab5
  call cli_prcsm                               ; 00AA5  0xE8, 0x03, 0x00
  jmp near cli_crlf                           ; 00AA8  0xE9, 0x47, 0xFF

cli_prcsm:  ; 00AAB
  db 0x26, 0x8B, 0x36, 0x62, 0x00             ; 00AAB  mov si, word [es:0x62]
  db 0x8B, 0x3E, 0x68, 0x00                   ; 00AB0  mov di, word [0x68]
  db 0x39, 0x3C                               ; 00AB4  cmp word [si], di
  jne loc_00AC3                                ; 00AB6  0x75, 0x0B
  db 0x33, 0xDB                               ; 00AB8  xor bx, bx
  db 0x1E                                     ; 00ABA  push ds
  db 0x8C, 0xC8                               ; 00ABB  mov ax, cs
  db 0x8E, 0xD8                               ; 00ABD  mov ds, ax
  call cli_flclse                               ; 00ABF  0xE8, 0x17, 0x00
  db 0x1F                                     ; 00AC2  pop ds

loc_00AC3:  ; 00AC3
  db 0xC3                                     ; 00AC3  ret

cli_prtyp:  ; 00AC4
  db 0xB7, 0x03                               ; 00AC4  mov bh, 3
  jmp short loc_00ACA                          ; 00AC6  0xEB, 0x02

cli_prnam:  ; 00AC8
  db 0xB7, 0x08                               ; 00AC8  mov bh, 8

loc_00ACA:  ; 00ACA
  db 0xB3, 0x20                               ; 00ACA  mov bl, 0x20
  db 0x26, 0x8B, 0x36, 0x62, 0x00             ; 00ACC  mov si, word [es:0x62]
  db 0x8B, 0x3E, 0x68, 0x00                   ; 00AD1  mov di, word [0x68]
  db 0x39, 0x3C                               ; 00AD5  cmp word [si], di
  jne loc_00AC3                                ; 00AD7  0x75, 0xEA

cli_flclse:  ; 00AD9
  db 0xB9, 0x0E, 0x04                         ; 00AD9  mov cx, 0x40e
  jmp short loc_00B22                          ; 00ADC  0xEB, 0x44

cli_flopn:  ; 00ADE
  db 0x8B, 0x36, 0x68, 0x00                   ; 00ADE  mov si, word [0x68]
  db 0xFF, 0x74, 0x06                         ; 00AE2  push word [si + 6]
  db 0x81, 0x64, 0x06, 0x7F, 0xFF             ; 00AE5  and word [si + 6], 0xff7f
  db 0xB9, 0x10, 0x00                         ; 00AEA  mov cx, 0x10
  db 0xBA, 0x54, 0x04                         ; 00AED  mov dx, 0x454
  call cli_osif                               ; 00AF0  0xE8, 0x1E, 0x00
  db 0x58                                     ; 00AF3  pop ax
  db 0x25, 0x80, 0x00                         ; 00AF4  and ax, 0x80
  db 0x8B, 0x36, 0x68                                             ; 00AF7  .6h

io_polldev:  ; 00AFA
  db 0x00, 0x81, 0xE6, 0x7F                   ; 00AFA  add byte [bx + di + 0x7fe6], al
  db 0xFF, 0x09                               ; 00AFE  dec word [bx + di]
  db 0x44                                     ; 00B00  inc sp
  db 0x06                                     ; 00B01  push es
  db 0x8B, 0xC3                               ; 00B02  mov ax, bx
  db 0xC3                                     ; 00B04  ret

cli_open_wait:  ; 00B05
  db 0xB9, 0x0F, 0x00                         ; 00B05  mov cx, 0xf
  db 0xBE, 0x54, 0x04                         ; 00B08  mov si, 0x454
  db 0x80, 0x4C, 0x06, 0x80                   ; 00B0B  or byte [si + 6], 0x80
  db 0x8B, 0xD6                               ; 00B0F  mov dx, si

cli_osif:  ; 00B11
  db 0x06                                     ; 00B11  push es
  call rtm_dispatcher                          ; 00B12  0xE8, 0xFE, 0xF7
  db 0x07                                     ; 00B15  pop es
  db 0xC3                                     ; 00B16  ret

cli_sync:  ; 00B17
  db 0xB9, 0x15, 0x02                         ; 00B17  mov cx, 0x215
  jmp short loc_00B1F                          ; 00B1A  0xEB, 0x03

cli_unsync:  ; 00B1C
  db 0xB9, 0x16, 0x02                         ; 00B1C  mov cx, 0x216

loc_00B1F:  ; 00B1F
  db 0xBB, 0x05, 0x07                         ; 00B1F  mov bx, 0x705

loc_00B22:  ; 00B22
  jmp near rtm_dispatcher                      ; 00B22  0xE9, 0xEE, 0xF7

cli_pfn:  ; 00B25
  db 0xBA, 0x91, 0x04                         ; 00B25  mov dx, 0x491
  db 0xB9, 0x98, 0x00                         ; 00B28  mov cx, 0x98
  jmp short loc_00B22                          ; 00B2B  0xEB, 0xF5

cli_conasn:  ; 00B2D
  db 0xB9, 0x95, 0x00                         ; 00B2D  mov cx, 0x95
  db 0xBA, 0x85, 0x04                         ; 00B30  mov dx, 0x485
  jmp short loc_00B22                          ; 00B33  0xEB, 0xED
  db 0x20, 0x4D, 0x73                         ; 00B35  and byte [di + 0x73], cl
  db 0x67, 0x20, 0x51, 0x75                   ; 00B38  and byte [ecx + 0x75], dl
  db 0x65, 0x64, 0x00, 0x28                   ; 00B3C  add byte [fs:bx + si], ch
  db 0x55                                     ; 00B40  push bp
  db 0x73, 0x65                               ; 00B41  jae 0xba8
  jb loc_00B65                                 ; 00B43  0x72, 0x20
  db 0x30, 0x29                               ; 00B45  xor byte [bx + di], ch
  db 0x00, 0x53, 0xBB                         ; 00B47  add byte [bp + di - 0x45], dl
  db 0x01, 0x00                               ; 00B4A  add word [bx + si], ax
  jmp short loc_00B50                          ; 00B4C  0xEB, 0x02
  db 0x2B, 0xDB                               ; 00B4E  sub bx, bx

loc_00B50:  ; 00B50
  db 0x52                                     ; 00B50  push dx
  db 0x53                                     ; 00B51  push bx
  db 0xB9, 0x89, 0x00                         ; 00B52  mov cx, 0x89
  db 0xBA, 0xD8, 0x01                         ; 00B55  mov dx, 0x1d8
  call rtm_dispatcher                          ; 00B58  0xE8, 0xB8, 0xF7
  db 0xC6, 0x06, 0x11, 0x02, 0x00             ; 00B5B  mov byte [0x211], 0
  db 0x8F, 0x06, 0xE8, 0x01                   ; 00B60  pop word [0x1e8]
  db 0x5E                                     ; 00B64  pop si

loc_00B65:  ; 00B65
  db 0x83, 0x3E, 0xE8, 0x01, 0x01             ; 00B65  cmp word [0x1e8], 1
  jne loc_00B75                                ; 00B6A  0x75, 0x09
  db 0x8F, 0x06, 0xE8, 0x01                   ; 00B6C  pop word [0x1e8]
  db 0xC6, 0x06, 0x11, 0x02, 0xFF             ; 00B70  mov byte [0x211], 0xff

loc_00B75:  ; 00B75
  db 0xB9, 0x10, 0x00                         ; 00B75  mov cx, 0x10
  db 0xBF, 0xEA, 0x01                         ; 00B78  mov di, 0x1ea
  db 0x06                                     ; 00B7B  push es
  db 0x1E                                     ; 00B7C  push ds
  db 0x1E                                     ; 00B7D  push ds
  db 0x26, 0x8E, 0x1E, 0x2E, 0x00             ; 00B7E  mov ds, word [es:0x2e]
  db 0x07                                     ; 00B83  pop es
  db 0xF3, 0xA5                               ; 00B84  rep movsw
  db 0x1F                                     ; 00B86  pop ds
  db 0x07                                     ; 00B87  pop es
  db 0xBB, 0xEA, 0x01                         ; 00B88  mov bx, 0x1ea
  db 0xC6, 0x47, 0x23, 0x00                   ; 00B8B  mov byte [bx + 0x23], 0
  db 0xB8, 0x00, 0x00                         ; 00B8F  mov ax, 0
  db 0xBB, 0x01, 0x00                         ; 00B92  mov bx, 1
  db 0xBA, 0x1D, 0x02                         ; 00B95  mov dx, 0x21d
  db 0x2E, 0x8B, 0x0E, 0x06, 0x00             ; 00B98  mov cx, word [cs:6]
  call load_xfer                               ; 00B9D  0xE8, 0x90, 0x06
  db 0x83, 0xFF, 0x01                         ; 00BA0  cmp di, 1
  je loc_00BA7                                 ; 00BA3  0x74, 0x02
  jcxz loc_00BB0                               ; 00BA5  0xE3, 0x09

loc_00BA7:  ; 00BA7
  db 0xB9, 0x1C, 0x00                         ; 00BA7  mov cx, 0x1c
  db 0xBB, 0xFF, 0xFF                         ; 00BAA  mov bx, 0xffff
  jmp near loc_0115D                           ; 00BAD  0xE9, 0xAD, 0x05

loc_00BB0:  ; 00BB0
  db 0xC6, 0x06, 0x19, 0x02, 0x00             ; 00BB0  mov byte [indisp], 0
  db 0xBB, 0x1D, 0x02                         ; 00BB5  mov bx, 0x21d
  db 0xF6, 0x47, 0x7F, 0x20                   ; 00BB8  test byte [bx + 0x7f], 0x20
  je loc_00BCE                                 ; 00BBC  0x74, 0x10
  db 0x83, 0x3E, 0x8C, 0x00, 0xFF             ; 00BBE  cmp word [0x8c], -1
  jne loc_00BE3                                ; 00BC3  0x75, 0x1E
  db 0xB9, 0x11, 0x00                         ; 00BC5  mov cx, 0x11
  db 0xBB, 0xFF, 0xFF                         ; 00BC8  mov bx, 0xffff
  jmp near loc_0115D                           ; 00BCB  0xE9, 0x8F, 0x05

loc_00BCE:  ; 00BCE
  db 0xF6, 0x47, 0x7F, 0x40                   ; 00BCE  test byte [bx + 0x7f], 0x40
  je loc_00BE8                                 ; 00BD2  0x74, 0x14
  db 0x83, 0x3E, 0x8C, 0x00, 0xFF             ; 00BD4  cmp word [0x8c], -1
  jne loc_00BE3                                ; 00BD9  0x75, 0x08
  db 0xC6, 0x06, 0x19, 0x02, 0x01             ; 00BDB  mov byte [indisp], 1
  jmp near loc_00BE8                           ; 00BE0  0xE9, 0x05, 0x00

loc_00BE3:  ; 00BE3
  db 0xC6, 0x06, 0x19, 0x02, 0xFF             ; 00BE3  mov byte [indisp], 0xff

loc_00BE8:  ; 00BE8
  db 0xC6, 0x06, 0x1A, 0x02, 0x00             ; 00BE8  mov byte [0x21a], 0
  db 0xF6, 0x47, 0x7F, 0x08                   ; 00BED  test byte [bx + 0x7f], 8
  je loc_00BF8                                 ; 00BF1  0x74, 0x05
  db 0xC6, 0x06, 0x1A, 0x02, 0xFF             ; 00BF3  mov byte [0x21a], 0xff

loc_00BF8:  ; 00BF8
  db 0xC7, 0x06, 0x0E, 0x02, 0x00, 0x00       ; 00BF8  mov word [0x20e], 0
  db 0x8B, 0x1E, 0x68, 0x00                   ; 00BFE  mov bx, word [0x68]
  db 0x8A, 0x47, 0x13                         ; 00C02  mov al, byte p_user[bx]
  db 0xA2, 0x12, 0x02                         ; 00C05  mov byte [0x212], al
  db 0x8A, 0x47, 0x12                         ; 00C08  mov al, byte p_dsk[bx]
  db 0xA2, 0x13, 0x02                         ; 00C0B  mov byte [0x213], al
  db 0xBB, 0xEA, 0x01                         ; 00C0E  mov bx, 0x1ea
  db 0x8A, 0x07                               ; 00C11  mov al, byte [bx]
  db 0xA2, 0x14, 0x02                         ; 00C13  mov byte [0x214], al
  db 0x84, 0xC0                               ; 00C16  test al, al
  je loc_00C1F                                 ; 00C18  0x74, 0x05
  db 0xFE, 0xC8                               ; 00C1A  dec al
  db 0xA2, 0x13, 0x02                         ; 00C1C  mov byte [0x213], al

loc_00C1F:  ; 00C1F
  db 0xF6, 0x47, 0x08, 0x80                   ; 00C1F  test byte [bx + 8], 0x80
  je loc_00C2A                                 ; 00C23  0x74, 0x05
  db 0xC6, 0x06, 0x12, 0x02, 0x00             ; 00C25  mov byte [0x212], 0

loc_00C2A:  ; 00C2A
  db 0xB9, 0x55, 0x00                         ; 00C2A  mov cx, 0x55
  db 0x2B, 0xC0                               ; 00C2D  sub ax, ax
  db 0xBF, 0x9D, 0x02                         ; 00C2F  mov di, 0x29d
  db 0x06                                     ; 00C32  push es
  db 0x2E, 0x8E, 0x06, 0x06, 0x00             ; 00C33  mov es, word [cs:6]
  db 0xF3, 0xAB                               ; 00C38  rep stosw
  db 0x07                                     ; 00C3A  pop es
  db 0xC7, 0x06, 0xE6, 0x01, 0x00, 0x00       ; 00C3B  mov word [0x1e6], 0
  db 0xBE, 0x9D, 0x02                         ; 00C41  mov si, 0x29d
  db 0x83, 0x3E, 0xE8, 0x01, 0x00             ; 00C44  cmp word [0x1e8], 0
  jne loc_00C4E                                ; 00C49  0x75, 0x03
  jmp near loc_00CB4                           ; 00C4B  0xE9, 0x66, 0x00

loc_00C4E:  ; 00C4E
  db 0x80, 0x3E, 0x19, 0x02, 0x00             ; 00C4E  cmp byte [indisp], 0
  je loc_00C76                                 ; 00C53  0x74, 0x21
  db 0x80, 0x3E, 0x19, 0x02, 0xFF             ; 00C55  cmp byte [indisp], 0xff
  je loc_00C69                                 ; 00C5A  0x74, 0x0D
  db 0xC7, 0x44, 0x02, 0x1A, 0x00             ; 00C5C  mov word [si + 2], 0x1a
  db 0xC7, 0x44, 0x04, 0x1A, 0x00             ; 00C61  mov word [si + 4], 0x1a
  jmp near loc_00C80                           ; 00C66  0xE9, 0x17, 0x00

loc_00C69:  ; 00C69
  db 0xC7, 0x44, 0x02, 0x1C, 0x00             ; 00C69  mov word [si + 2], 0x1c
  db 0xC7, 0x44, 0x04, 0x1C, 0x00             ; 00C6E  mov word [si + 4], 0x1c
  jmp near loc_00C80                           ; 00C73  0xE9, 0x0A, 0x00

loc_00C76:  ; 00C76
  db 0xC7, 0x44, 0x02, 0x16, 0x00             ; 00C76  mov word [si + 2], 0x16
  db 0xC7, 0x44, 0x04, 0x16, 0x00             ; 00C7B  mov word [si + 4], 0x16

loc_00C80:  ; 00C80
  db 0xA1, 0xE8, 0x01                         ; 00C80  mov ax, word [0x1e8]
  db 0x89, 0x44, 0x06                         ; 00C83  mov word [si + 6], ax
  db 0xC7, 0x44, 0x08, 0x01, 0x00             ; 00C86  mov word [si + 8], 1
  db 0x83, 0xC6, 0x11                         ; 00C8B  add si, 0x11
  db 0xFF, 0x06, 0xE6, 0x01                   ; 00C8E  inc word [0x1e6]
  db 0x80, 0x3E, 0x11, 0x02, 0xFF             ; 00C92  cmp byte [0x211], 0xff
  jne loc_00CB4                                ; 00C97  0x75, 0x1B
  db 0x56                                     ; 00C99  push si
  db 0xB9, 0x3A, 0x00                         ; 00C9A  mov cx, 0x3a
  call rtm_dispatcher                          ; 00C9D  0xE8, 0x73, 0xF6
  db 0x8B, 0x1E, 0x68, 0x00                   ; 00CA0  mov bx, word [0x68]
  db 0x8B, 0x47, 0x16                         ; 00CA4  mov ax, word p_mem[bx]
  db 0xC7, 0x47, 0x16, 0x00, 0x00             ; 00CA7  mov word p_mem[bx], 0
  db 0x8B, 0x1E, 0xE8, 0x01                   ; 00CAC  mov bx, word [0x1e8]
  db 0x89, 0x47, 0x16                         ; 00CB0  mov word p_mem[bx], ax
  db 0x5E                                     ; 00CB3  pop si

loc_00CB4:  ; 00CB4
  db 0xBB, 0x1D, 0x02                         ; 00CB4  mov bx, 0x21d
  db 0x8A, 0x47, 0x7F                         ; 00CB7  mov al, byte [bx + 0x7f]
  db 0xA2, 0x16, 0x02                         ; 00CBA  mov byte [0x216], al
  db 0x8B, 0x47, 0x7D                         ; 00CBD  mov ax, word [bx + 0x7d]
  db 0xA3, 0x17, 0x02                         ; 00CC0  mov word [0x217], ax
  db 0xA3, 0x1B, 0x02                         ; 00CC3  mov word [0x21b], ax
  db 0xB9, 0x08, 0x00                         ; 00CC6  mov cx, 8
  db 0xBA, 0x08, 0x00                         ; 00CC9  mov dx, 8

loc_00CCC:  ; 00CCC
  db 0x80, 0x3F, 0x00                         ; 00CCC  cmp byte [bx], 0
  jne loc_00CD4                                ; 00CCF  0x75, 0x03
  jmp near loc_00D6C                           ; 00CD1  0xE9, 0x98, 0x00

loc_00CD4:  ; 00CD4
  db 0x8A, 0x07                               ; 00CD4  mov al, byte [bx]
  db 0x88, 0x44, 0x0E                         ; 00CD6  mov byte [si + 0xe], al
  db 0x8B, 0x47, 0x01                         ; 00CD9  mov ax, word [bx + 1]
  db 0x89, 0x44, 0x0C                         ; 00CDC  mov word [si + 0xc], ax
  db 0x89, 0x54, 0x0A                         ; 00CDF  mov word [si + 0xa], dx
  db 0x03, 0xD0                               ; 00CE2  add dx, ax
  db 0x8B, 0x47, 0x03                         ; 00CE4  mov ax, word [bx + 3]
  db 0x89, 0x04                               ; 00CE7  mov word [si], ax
  db 0x8B, 0x47, 0x05                         ; 00CE9  mov ax, word [bx + 5]
  db 0x89, 0x44, 0x02                         ; 00CEC  mov word [si + 2], ax
  db 0x8B, 0x47, 0x07                         ; 00CEF  mov ax, word [bx + 7]
  db 0x3D, 0x00, 0x00                         ; 00CF2  cmp ax, 0
  jne loc_00CFA                                ; 00CF5  0x75, 0x03
  db 0x8B, 0x47, 0x05                         ; 00CF7  mov ax, word [bx + 5]

loc_00CFA:  ; 00CFA
  db 0x89, 0x44, 0x04                         ; 00CFA  mov word [si + 4], ax
  db 0xA1, 0xE8, 0x01                         ; 00CFD  mov ax, word [0x1e8]
  db 0x89, 0x44, 0x06                         ; 00D00  mov word [si + 6], ax
  db 0x3D, 0x00, 0x00                         ; 00D03  cmp ax, 0
  je loc_00D0F                                 ; 00D06  0x74, 0x07
  db 0xB8, 0x01, 0x00                         ; 00D08  mov ax, 1
  jmp short loc_00D0F                          ; 00D0B  0xEB, 0x02

loc_00D0D:  ; 00D0D
  jmp short loc_00CCC                          ; 00D0D  0xEB, 0xBD

loc_00D0F:  ; 00D0F
  db 0x80, 0x3F, 0x01                         ; 00D0F  cmp byte [bx], 1
  jne loc_00D19                                ; 00D12  0x75, 0x05
  db 0x05, 0x04, 0x00                         ; 00D14  add ax, 4
  jmp short loc_00D21                          ; 00D17  0xEB, 0x08

loc_00D19:  ; 00D19
  db 0x80, 0x3F, 0x09                         ; 00D19  cmp byte [bx], 9
  jne loc_00D21                                ; 00D1C  0x75, 0x03
  db 0x05, 0x06, 0x00                         ; 00D1E  add ax, 6

loc_00D21:  ; 00D21
  db 0x89, 0x44, 0x08                         ; 00D21  mov word [si + 8], ax
  db 0x83, 0x3C, 0x00                         ; 00D24  cmp word [si], 0
  je loc_00D2B                                 ; 00D27  0x74, 0x02
  jmp short loc_00D42                          ; 00D29  0xEB, 0x17

loc_00D2B:  ; 00D2B
  db 0x80, 0x7C, 0x0E, 0x09                   ; 00D2B  cmp byte [si + 0xe], 9
  jne loc_00D65                                ; 00D2F  0x75, 0x34
  db 0x51                                     ; 00D31  push cx
  db 0x53                                     ; 00D32  push bx
  db 0x52                                     ; 00D33  push dx
  call rtm_put_drl                               ; 00D34  0xE8, 0x8A, 0x05
  db 0x5A                                     ; 00D37  pop dx
  db 0x5B                                     ; 00D38  pop bx
  db 0x83, 0xF9, 0x00                         ; 00D39  cmp cx, 0
  db 0x59                                     ; 00D3C  pop cx
  je loc_00D65                                 ; 00D3D  0x74, 0x26
  jmp near loc_00DDB                           ; 00D3F  0xE9, 0x99, 0x00

loc_00D42:  ; 00D42
  db 0x53                                     ; 00D42  push bx
  db 0x52                                     ; 00D43  push dx
  db 0x51                                     ; 00D44  push cx
  db 0x56                                     ; 00D45  push si
  db 0xB9, 0x80, 0x00                         ; 00D46  mov cx, 0x80
  db 0x8B, 0xD6                               ; 00D49  mov dx, si
  call rtm_dispatcher                          ; 00D4B  0xE8, 0xC5, 0xF5
  db 0x5E                                     ; 00D4E  pop si
  db 0x8B, 0x04                               ; 00D4F  mov ax, word [si]
  db 0x89, 0x44, 0x0F                         ; 00D51  mov word [si + 0xf], ax
  db 0x83, 0xF9, 0x00                         ; 00D54  cmp cx, 0
  db 0x59                                     ; 00D57  pop cx
  db 0x5A                                     ; 00D58  pop dx
  db 0x5B                                     ; 00D59  pop bx
  je loc_00D65                                 ; 00D5A  0x74, 0x09
  db 0xBB, 0xFF, 0xFF                         ; 00D5C  mov bx, 0xffff
  db 0xB9, 0x03, 0x00                         ; 00D5F  mov cx, 3
  jmp near loc_00DDB                           ; 00D62  0xE9, 0x76, 0x00

loc_00D65:  ; 00D65
  db 0x83, 0xC6, 0x11                         ; 00D65  add si, 0x11
  db 0xFF, 0x06, 0xE6, 0x01                   ; 00D68  inc word [0x1e6]

loc_00D6C:  ; 00D6C
  db 0x83, 0xC3, 0x09                         ; 00D6C  add bx, 9
  loop loc_00D0D                               ; 00D6F  0xE2, 0x9C
  db 0xBB, 0x9D, 0x02                         ; 00D71  mov bx, 0x29d
  db 0x8B, 0x0E, 0xE6, 0x01                   ; 00D74  mov cx, word [0x1e6]
  db 0xC6, 0x06, 0x10, 0x02, 0x00             ; 00D78  mov byte [0x210], 0

loc_00D7D:  ; 00D7D
  db 0x83, 0x7F, 0x02, 0x00                   ; 00D7D  cmp word [bx + 2], 0
  je loc_00DB0                                 ; 00D81  0x74, 0x2D
  db 0x83, 0x3F, 0x00                         ; 00D83  cmp word [bx], 0
  jne loc_00DB0                                ; 00D86  0x75, 0x28
  db 0x8B, 0x47, 0x02                         ; 00D88  mov ax, word [bx + 2]
  db 0x8B, 0xD0                               ; 00D8B  mov dx, ax
  db 0x01, 0x44, 0x02                         ; 00D8D  add word [si + 2], ax
  db 0x3B, 0x54, 0x02                         ; 00D90  cmp dx, word [si + 2]
  jbe loc_00D9A                                ; 00D93  0x76, 0x05
  db 0xC7, 0x44, 0x02, 0xFF, 0xFF             ; 00D95  mov word [si + 2], 0xffff

loc_00D9A:  ; 00D9A
  db 0x8B, 0x47, 0x04                         ; 00D9A  mov ax, word [bx + 4]
  db 0x8B, 0xD0                               ; 00D9D  mov dx, ax
  db 0x01, 0x44, 0x04                         ; 00D9F  add word [si + 4], ax
  db 0x3B, 0x54, 0x04                         ; 00DA2  cmp dx, word [si + 4]
  jbe loc_00DAC                                ; 00DA5  0x76, 0x05
  db 0xC7, 0x44, 0x04, 0xFF, 0xFF             ; 00DA7  mov word [si + 4], 0xffff

loc_00DAC:  ; 00DAC
  db 0xFE, 0x06, 0x10, 0x02                   ; 00DAC  inc byte [0x210]

loc_00DB0:  ; 00DB0
  db 0x83, 0xC3, 0x11                         ; 00DB0  add bx, 0x11
  loop loc_00D7D                               ; 00DB3  0xE2, 0xC8
  db 0x83, 0x3E, 0xE8, 0x01, 0x00             ; 00DB5  cmp word [0x1e8], 0
  je loc_00DC1                                 ; 00DBA  0x74, 0x05
  db 0xC7, 0x44, 0x08, 0x01, 0x00             ; 00DBC  mov word [si + 8], 1

loc_00DC1:  ; 00DC1
  db 0xA1, 0xE8, 0x01                         ; 00DC1  mov ax, word [0x1e8]
  db 0x89, 0x44, 0x06                         ; 00DC4  mov word [si + 6], ax
  db 0x56                                     ; 00DC7  push si
  db 0x8B, 0xD6                               ; 00DC8  mov dx, si
  db 0xB9, 0x80, 0x00                         ; 00DCA  mov cx, 0x80
  call rtm_dispatcher                          ; 00DCD  0xE8, 0x43, 0xF5
  db 0x5E                                     ; 00DD0  pop si
  db 0x8B, 0x04                               ; 00DD1  mov ax, word [si]
  db 0x89, 0x44, 0x0F                         ; 00DD3  mov word [si + 0xf], ax
  db 0x83, 0xFB, 0xFF                         ; 00DD6  cmp bx, -1
  jne loc_00E0E                                ; 00DD9  0x75, 0x33

loc_00DDB:  ; 00DDB
  db 0x51                                     ; 00DDB  push cx
  db 0xBB, 0x9D, 0x02                         ; 00DDC  mov bx, 0x29d
  db 0x8B, 0x0E, 0xE6, 0x01                   ; 00DDF  mov cx, word [0x1e6]
  db 0x41                                     ; 00DE3  inc cx

loc_00DE4:  ; 00DE4
  db 0x83, 0x7F, 0x0F, 0x00                   ; 00DE4  cmp word [bx + 0xf], 0
  je loc_00E02                                 ; 00DE8  0x74, 0x18
  db 0x51                                     ; 00DEA  push cx
  db 0x53                                     ; 00DEB  push bx
  db 0x1E                                     ; 00DEC  push ds
  db 0xFF, 0x77, 0x06                         ; 00DED  push word [bx + 6]
  db 0xFF, 0x77, 0x0F                         ; 00DF0  push word [bx + 0xf]
  db 0x8B, 0xD4                               ; 00DF3  mov dx, sp
  db 0x16                                     ; 00DF5  push ss
  db 0x1F                                     ; 00DF6  pop ds
  db 0xB9, 0x82, 0x00                         ; 00DF7  mov cx, 0x82
  call rtm_dispatcher                          ; 00DFA  0xE8, 0x16, 0xF5
  db 0x59                                     ; 00DFD  pop cx
  db 0x59                                     ; 00DFE  pop cx
  db 0x1F                                     ; 00DFF  pop ds
  db 0x5B                                     ; 00E00  pop bx
  db 0x59                                     ; 00E01  pop cx

loc_00E02:  ; 00E02
  db 0x83, 0xC3, 0x11                         ; 00E02  add bx, 0x11
  loop loc_00DE4                               ; 00E05  0xE2, 0xDD
  db 0xBB, 0xFF, 0xFF                         ; 00E07  mov bx, 0xffff
  db 0x59                                     ; 00E0A  pop cx
  jmp near loc_0115D                           ; 00E0B  0xE9, 0x4F, 0x03

loc_00E0E:  ; 00E0E
  db 0xBB, 0x9D, 0x02                         ; 00E0E  mov bx, 0x29d
  db 0x8B, 0x0E, 0xE6, 0x01                   ; 00E11  mov cx, word [0x1e6]

loc_00E15:  ; 00E15
  db 0x83, 0x3F, 0x00                         ; 00E15  cmp word [bx], 0
  jne loc_00E2F                                ; 00E18  0x75, 0x15
  db 0x8B, 0x47, 0x02                         ; 00E1A  mov ax, word [bx + 2]
  db 0x29, 0x44, 0x02                         ; 00E1D  sub word [si + 2], ax
  db 0x3B, 0x47, 0x04                         ; 00E20  cmp ax, word [bx + 4]
  jne loc_00E2F                                ; 00E23  0x75, 0x0A
  db 0x8B, 0x14                               ; 00E25  mov dx, word [si]
  db 0x89, 0x17                               ; 00E27  mov word [bx], dx
  db 0x01, 0x04                               ; 00E29  add word [si], ax
  db 0xFE, 0x0E, 0x10, 0x02                   ; 00E2B  dec byte [0x210]

loc_00E2F:  ; 00E2F
  db 0x83, 0xC3, 0x11                         ; 00E2F  add bx, 0x11
  loop loc_00E15                               ; 00E32  0xE2, 0xE1
  db 0xBB, 0x9D, 0x02                         ; 00E34  mov bx, 0x29d
  db 0x8B, 0x0E, 0xE6, 0x01                   ; 00E37  mov cx, word [0x1e6]

loc_00E3B:  ; 00E3B
  db 0x83, 0x3F, 0x00                         ; 00E3B  cmp word [bx], 0
  jne loc_00E79                                ; 00E3E  0x75, 0x39
  db 0x8B, 0x04                               ; 00E40  mov ax, word [si]
  db 0x89, 0x07                               ; 00E42  mov word [bx], ax
  db 0x8B, 0x44, 0x02                         ; 00E44  mov ax, word [si + 2]
  db 0x3D, 0x00, 0x00                         ; 00E47  cmp ax, 0
  je loc_00E70                                 ; 00E4A  0x74, 0x24
  db 0x51                                     ; 00E4C  push cx
  db 0x2B, 0xC9                               ; 00E4D  sub cx, cx
  db 0x8B, 0xD1                               ; 00E4F  mov dx, cx
  db 0x8A, 0x0E, 0x10, 0x02                   ; 00E51  mov cl, byte [0x210]
  db 0xF7, 0xF1                               ; 00E55  div cx
  db 0x59                                     ; 00E57  pop cx
  db 0x83, 0xFA, 0x00                         ; 00E58  cmp dx, 0
  je loc_00E5E                                 ; 00E5B  0x74, 0x01
  db 0x40                                     ; 00E5D  inc ax

loc_00E5E:  ; 00E5E
  db 0x8B, 0x57, 0x04                         ; 00E5E  mov dx, word [bx + 4]
  db 0x2B, 0x57, 0x02                         ; 00E61  sub dx, word [bx + 2]
  db 0x3B, 0xC2                               ; 00E64  cmp ax, dx
  jbe loc_00E6A                                ; 00E66  0x76, 0x02
  db 0x8B, 0xC2                               ; 00E68  mov ax, dx

loc_00E6A:  ; 00E6A
  db 0x01, 0x47, 0x02                         ; 00E6A  add word [bx + 2], ax
  db 0x29, 0x44, 0x02                         ; 00E6D  sub word [si + 2], ax

loc_00E70:  ; 00E70
  db 0x8B, 0x47, 0x02                         ; 00E70  mov ax, word [bx + 2]
  db 0x01, 0x04                               ; 00E73  add word [si], ax
  db 0xFE, 0x0E, 0x10, 0x02                   ; 00E75  dec byte [0x210]

loc_00E79:  ; 00E79
  db 0x83, 0xC3, 0x11                         ; 00E79  add bx, 0x11
  loop loc_00E3B                               ; 00E7C  0xE2, 0xBD
  db 0xBE, 0x9D, 0x02                         ; 00E7E  mov si, 0x29d
  db 0x8B, 0x0E, 0xE6, 0x01                   ; 00E81  mov cx, word [0x1e6]

loc_00E85:  ; 00E85
  db 0x83, 0x7C, 0x0C, 0x00                   ; 00E85  cmp word [si + 0xc], 0
  je loc_00ED9                                 ; 00E89  0x74, 0x4E
  db 0x51                                     ; 00E8B  push cx
  db 0xFF, 0x34                               ; 00E8C  push word [si]
  db 0x56                                     ; 00E8E  push si
  call load_group                               ; 00E8F  0xE8, 0xD9, 0x02
  db 0x5E                                     ; 00E92  pop si
  db 0x8F, 0x04                               ; 00E93  pop word [si]
  db 0x83, 0xF9, 0x00                         ; 00E95  cmp cx, 0
  db 0x59                                     ; 00E98  pop cx
  je loc_00ED9                                 ; 00E99  0x74, 0x3E
  db 0x83, 0x7C, 0x08, 0x07                   ; 00E9B  cmp word [si + 8], 7
  je loc_00EA4                                 ; 00E9F  0x74, 0x03
  jmp near loc_00DDB                           ; 00EA1  0xE9, 0x37, 0xFF

loc_00EA4:  ; 00EA4
  db 0x51                                     ; 00EA4  push cx
  db 0x9C                                     ; 00EA5  pushf
  db 0xFA                                     ; 00EA6  cli
  db 0x8B, 0x1E, 0x70, 0x00                   ; 00EA7  mov bx, word [0x70]
  db 0x8B, 0x47, 0x02                         ; 00EAB  mov ax, word [bx + 2]
  db 0xA3, 0x70, 0x00                         ; 00EAE  mov word [0x70], ax
  db 0x9D                                     ; 00EB1  popf
  db 0x1E                                     ; 00EB2  push ds
  db 0x53                                     ; 00EB3  push bx
  db 0x8B, 0x5F, 0x16                         ; 00EB4  mov bx, word p_mem[bx]
  db 0xFF, 0x77, 0x02                         ; 00EB7  push word [bx + 2]
  db 0x8C, 0xD0                               ; 00EBA  mov ax, ss
  db 0x8E, 0xD8                               ; 00EBC  mov ds, ax
  db 0x8B, 0xD4                               ; 00EBE  mov dx, sp
  db 0xB9, 0x82, 0x00                         ; 00EC0  mov cx, 0x82
  call rtm_dispatcher                          ; 00EC3  0xE8, 0x4D, 0xF4
  db 0x58                                     ; 00EC6  pop ax
  db 0x5B                                     ; 00EC7  pop bx
  db 0x1F                                     ; 00EC8  pop ds
  db 0x9C                                     ; 00EC9  pushf
  db 0xFA                                     ; 00ECA  cli
  db 0xA1, 0x5C, 0x00                         ; 00ECB  mov ax, word [0x5c]
  db 0x89, 0x1E, 0x5C, 0x00                   ; 00ECE  mov word [0x5c], bx
  db 0x89, 0x07                               ; 00ED2  mov word [bx], ax
  db 0x9D                                     ; 00ED4  popf
  db 0x59                                     ; 00ED5  pop cx
  jmp near loc_00DDB                           ; 00ED6  0xE9, 0x02, 0xFF

loc_00ED9:  ; 00ED9
  db 0x83, 0xC6, 0x11                         ; 00ED9  add si, 0x11
  loop loc_00E85                               ; 00EDC  0xE2, 0xA7
  db 0xF6, 0x06, 0x16, 0x02, 0x80             ; 00EDE  test byte [0x216], 0x80
  je loc_00F5A                                 ; 00EE3  0x74, 0x75

loc_00EE5:  ; 00EE5
  db 0xA1, 0x17, 0x02                         ; 00EE5  mov ax, word [0x217]
  db 0xBB, 0x01, 0x00                         ; 00EE8  mov bx, 1
  db 0x8C, 0xD9                               ; 00EEB  mov cx, ds
  db 0xBA, 0x1D, 0x02                         ; 00EED  mov dx, 0x21d
  call load_xfer                               ; 00EF0  0xE8, 0x3D, 0x03
  jcxz loc_00F04                               ; 00EF3  0xE3, 0x0F
  db 0xFE, 0xC1                               ; 00EF5  inc cl
  jne loc_00F54                                ; 00EF7  0x75, 0x5B
  db 0xA1, 0x1B, 0x02                         ; 00EF9  mov ax, word [0x21b]
  db 0x3B, 0x06, 0x17, 0x02                   ; 00EFC  cmp ax, word [0x217]
  je loc_00F54                                 ; 00F00  0x74, 0x52
  jmp short loc_00F5A                          ; 00F02  0xEB, 0x56

loc_00F04:  ; 00F04
  db 0xBB, 0x1D, 0x02                         ; 00F04  mov bx, 0x21d

loc_00F07:  ; 00F07
  db 0x8A, 0x07                               ; 00F07  mov al, byte [bx]
  db 0x84, 0xC0                               ; 00F09  test al, al
  je loc_00F5A                                 ; 00F0B  0x74, 0x4D
  db 0x24, 0x0F                               ; 00F0D  and al, 0xf
  call load_tblsrch                               ; 00F0F  0xE8, 0x2D, 0x00
  db 0x8B, 0x15                               ; 00F12  mov dx, word [di]
  db 0x8A, 0x07                               ; 00F14  mov al, byte [bx]
  db 0xB1, 0x04                               ; 00F16  mov cl, 4
  db 0xD2, 0xE8                               ; 00F18  shr al, cl
  call load_tblsrch                               ; 00F1A  0xE8, 0x22, 0x00
  db 0x8B, 0x05                               ; 00F1D  mov ax, word [di]
  db 0x03, 0x47, 0x01                         ; 00F1F  add ax, word [bx + 1]
  db 0x06                                     ; 00F22  push es
  db 0x8E, 0xC0                               ; 00F23  mov es, ax
  db 0x33, 0xC0                               ; 00F25  xor ax, ax
  db 0x8A, 0x47, 0x03                         ; 00F27  mov al, byte [bx + 3]
  db 0x8B, 0xF8                               ; 00F2A  mov di, ax
  db 0x26, 0x01, 0x15                         ; 00F2C  add word [es:di], dx
  db 0x07                                     ; 00F2F  pop es
  db 0x83, 0xC3, 0x04                         ; 00F30  add bx, 4
  db 0x81, 0xFB, 0x9D, 0x02                   ; 00F33  cmp bx, 0x29d
  jne loc_00F07                                ; 00F37  0x75, 0xCE
  db 0xFF, 0x06, 0x17, 0x02                   ; 00F39  inc word [0x217]
  jmp short loc_00EE5                          ; 00F3D  0xEB, 0xA6

load_tblsrch:  ; 00F3F
  db 0x8B, 0x0E, 0xE6, 0x01                   ; 00F3F  mov cx, word [0x1e6]
  db 0xBF, 0x9D, 0x02                         ; 00F43  mov di, 0x29d

loc_00F46:  ; 00F46
  db 0x3A, 0x45, 0x0E                         ; 00F46  cmp al, byte [di + 0xe]
  je loc_00F53                                 ; 00F49  0x74, 0x08
  db 0x83, 0xC7, 0x11                         ; 00F4B  add di, 0x11
  loop loc_00F46                               ; 00F4E  0xE2, 0xF6
  db 0x58                                     ; 00F50  pop ax
  jmp short loc_00F54                          ; 00F51  0xEB, 0x01

loc_00F53:  ; 00F53
  db 0xC3                                     ; 00F53  ret

loc_00F54:  ; 00F54
  db 0xB9, 0x29, 0x00                         ; 00F54  mov cx, 0x29
  jmp near loc_00DDB                           ; 00F57  0xE9, 0x81, 0xFE

loc_00F5A:  ; 00F5A
  db 0xC6, 0x06, 0x15, 0x02, 0x00             ; 00F5A  mov byte [0x215], 0
  db 0xBE, 0x9D, 0x02                         ; 00F5F  mov si, 0x29d
  db 0x8B, 0x0E, 0xE6, 0x01                   ; 00F62  mov cx, word [0x1e6]

loc_00F66:  ; 00F66
  db 0x80, 0x7C, 0x0E, 0x02                   ; 00F66  cmp byte [si + 0xe], 2
  je loc_00F8E                                 ; 00F6A  0x74, 0x22
  db 0x83, 0xC6, 0x11                         ; 00F6C  add si, 0x11
  loop loc_00F66                               ; 00F6F  0xE2, 0xF5
  db 0xBE, 0x9D, 0x02                         ; 00F71  mov si, 0x29d
  db 0x8B, 0x0E, 0xE6, 0x01                   ; 00F74  mov cx, word [0x1e6]

loc_00F78:  ; 00F78
  db 0x80, 0x7C, 0x0E, 0x01                   ; 00F78  cmp byte [si + 0xe], 1
  je loc_00F89                                 ; 00F7C  0x74, 0x0B
  db 0x83, 0xC6, 0x11                         ; 00F7E  add si, 0x11
  loop loc_00F78                               ; 00F81  0xE2, 0xF5
  db 0xB9, 0x21, 0x00                         ; 00F83  mov cx, 0x21
  jmp near loc_00DDB                           ; 00F86  0xE9, 0x52, 0xFE

loc_00F89:  ; 00F89
  db 0xC6, 0x06, 0x15, 0x02, 0x01             ; 00F89  mov byte [0x215], 1

loc_00F8E:  ; 00F8E
  db 0x06                                     ; 00F8E  push es
  db 0x8E, 0x04                               ; 00F8F  mov es, word [si]
  db 0x8C, 0x06, 0xE4, 0x01                   ; 00F91  mov word [0x1e4], es
  db 0x2B, 0xC0                               ; 00F95  sub ax, ax
  db 0x8B, 0xF8                               ; 00F97  mov di, ax
  db 0xB9, 0x2D, 0x00                         ; 00F99  mov cx, 0x2d
  db 0xF3, 0xAB                               ; 00F9C  rep stosw
  db 0xA0, 0x15, 0x02                         ; 00F9E  mov al, byte [0x215]
  db 0x26, 0xA2, 0x05, 0x00                   ; 00FA1  mov byte [es:5], al
  db 0xBE, 0x9D, 0x02                         ; 00FA5  mov si, 0x29d
  db 0x8B, 0x0E, 0xE6, 0x01                   ; 00FA8  mov cx, word [0x1e6]

loc_00FAC:  ; 00FAC
  db 0x80, 0x7C, 0x0E, 0x00                   ; 00FAC  cmp byte [si + 0xe], 0
  je loc_00FF9                                 ; 00FB0  0x74, 0x47
  db 0xB8, 0x06, 0x00                         ; 00FB2  mov ax, 6
  db 0x8A, 0x5C, 0x0E                         ; 00FB5  mov bl, byte [si + 0xe]
  db 0x80, 0xFB, 0x09                         ; 00FB8  cmp bl, 9
  jne loc_00FBF                                ; 00FBB  0x75, 0x02
  db 0xB3, 0x01                               ; 00FBD  mov bl, 1

loc_00FBF:  ; 00FBF
  db 0xFE, 0xCB                               ; 00FBF  dec bl
  db 0xF6, 0xE3                               ; 00FC1  mul bl
  db 0x8B, 0xD8                               ; 00FC3  mov bx, ax
  db 0x51                                     ; 00FC5  push cx
  db 0x8B, 0x54, 0x02                         ; 00FC6  mov dx, word [si + 2]
  db 0x52                                     ; 00FC9  push dx
  db 0xB1, 0x04                               ; 00FCA  mov cl, 4
  db 0xD3, 0xE2                               ; 00FCC  shl dx, cl
  db 0x52                                     ; 00FCE  push dx
  db 0x4A                                     ; 00FCF  dec dx
  db 0x26, 0x89, 0x17                         ; 00FD0  mov word [es:bx], dx
  db 0x59                                     ; 00FD3  pop cx
  db 0x5A                                     ; 00FD4  pop dx
  db 0x51                                     ; 00FD5  push cx
  db 0xB1, 0x0C                               ; 00FD6  mov cl, 0xc
  db 0xD3, 0xEA                               ; 00FD8  shr dx, cl
  db 0x59                                     ; 00FDA  pop cx
  db 0x83, 0xF9, 0x00                         ; 00FDB  cmp cx, 0
  jne loc_00FEE                                ; 00FDE  0x75, 0x0E
  db 0x83, 0xFA, 0x00                         ; 00FE0  cmp dx, 0
  je loc_00FE9                                 ; 00FE3  0x74, 0x04
  db 0xFE, 0xCA                               ; 00FE5  dec dl
  jmp short loc_00FEE                          ; 00FE7  0xEB, 0x05

loc_00FE9:  ; 00FE9
  db 0x26, 0xC7, 0x07, 0x00, 0x00             ; 00FE9  mov word [es:bx], 0

loc_00FEE:  ; 00FEE
  db 0x26, 0x88, 0x57, 0x02                   ; 00FEE  mov byte [es:bx + 2], dl
  db 0x59                                     ; 00FF2  pop cx
  db 0x8B, 0x04                               ; 00FF3  mov ax, word [si]
  db 0x26, 0x89, 0x47, 0x03                   ; 00FF5  mov word [es:bx + 3], ax

loc_00FF9:  ; 00FF9
  db 0x83, 0xC6, 0x11                         ; 00FF9  add si, 0x11
  loop loc_00FAC                               ; 00FFC  0xE2, 0xAE
  db 0x80, 0x3E, 0x15, 0x02, 0x01             ; 00FFE  cmp byte [0x215], 1
  jne loc_01014                                ; 01003  0x75, 0x0F
  db 0x1E                                     ; 01005  push ds
  db 0x06                                     ; 01006  push es
  db 0x1F                                     ; 01007  pop ds
  db 0xBE, 0x00, 0x00                         ; 01008  mov si, 0
  db 0xBF, 0x06, 0x00                         ; 0100B  mov di, 6
  db 0xB9, 0x03, 0x00                         ; 0100E  mov cx, 3
  db 0xF3, 0xA5                               ; 01011  rep movsw
  db 0x1F                                     ; 01013  pop ds

loc_01014:  ; 01014
  db 0xA0, 0x14, 0x02                         ; 01014  mov al, byte [0x214]
  db 0x26, 0xA2, 0x50, 0x00                   ; 01017  mov byte [es:0x50], al
  db 0x07                                     ; 0101B  pop es
  db 0x8B, 0x1E, 0xE4, 0x01                   ; 0101C  mov bx, word [0x1e4]
  db 0x83, 0x3E, 0xE8, 0x01, 0x00             ; 01020  cmp word [0x1e8], 0
  jne loc_0102A                                ; 01025  0x75, 0x03
  jmp near loc_0115D                           ; 01027  0xE9, 0x33, 0x01

loc_0102A:  ; 0102A
  db 0xBE, 0x9D, 0x02                         ; 0102A  mov si, 0x29d
  db 0x8B, 0x1E, 0xE8, 0x01                   ; 0102D  mov bx, word [0x1e8]
  db 0x80, 0x3E, 0x19, 0x02, 0x00             ; 01031  cmp byte [indisp], 0
  je loc_0104C                                 ; 01036  0x74, 0x14
  db 0x80, 0x3E, 0x19, 0x02, 0x01             ; 01038  cmp byte [indisp], 1
  jne loc_01047                                ; 0103D  0x75, 0x08
  db 0x81, 0x4F, 0x26, 0x02, 0x00             ; 0103F  or word p_sflag[bx], 2
  jmp near loc_0104C                           ; 01044  0xE9, 0x05, 0x00

loc_01047:  ; 01047
  db 0x81, 0x4F, 0x06, 0x00, 0x80             ; 01047  or word [bx + 6], 0x8000

loc_0104C:  ; 0104C
  db 0x80, 0x3E, 0x1A, 0x02, 0xFF             ; 0104C  cmp byte [0x21a], 0xff
  jne loc_01058                                ; 01051  0x75, 0x05
  db 0x81, 0x4F, 0x26, 0x01, 0x00             ; 01053  or word p_sflag[bx], 1

loc_01058:  ; 01058
  db 0x8B, 0x04                               ; 01058  mov ax, word [si]
  db 0x89, 0x47, 0x10                         ; 0105A  mov word p_uda[bx], ax
  db 0xA3, 0xE0, 0x01                         ; 0105D  mov word [0x1e0], ax
  db 0x06                                     ; 01060  push es
  db 0x8E, 0xC0                               ; 01061  mov es, ax
  db 0x80, 0x3E, 0x19, 0x02, 0x00             ; 01063  cmp byte [indisp], 0
  je loc_0107D                                 ; 01068  0x74, 0x13
  db 0x80, 0x3E, 0x19, 0x02, 0x01             ; 0106A  cmp byte [indisp], 1
  je loc_01077                                 ; 0106F  0x74, 0x06
  db 0x05, 0x16, 0x00                         ; 01071  add ax, 0x16
  jmp near loc_01080                           ; 01074  0xE9, 0x09, 0x00

loc_01077:  ; 01077
  db 0x05, 0x14, 0x00                         ; 01077  add ax, 0x14
  jmp near loc_01080                           ; 0107A  0xE9, 0x03, 0x00

loc_0107D:  ; 0107D
  db 0x05, 0x10, 0x00                         ; 0107D  add ax, 0x10

loc_01080:  ; 01080
  db 0xA3, 0xE2, 0x01                         ; 01080  mov word [0x1e2], ax
  db 0x33, 0xFF                               ; 01083  xor di, di
  db 0x8B, 0xC7                               ; 01085  mov ax, di
  db 0x80, 0x3E, 0x19, 0x02, 0x00             ; 01087  cmp byte [indisp], 0
  je loc_010A1                                 ; 0108C  0x74, 0x13
  db 0x80, 0x3E, 0x19, 0x02, 0x01             ; 0108E  cmp byte [indisp], 1
  jne loc_0109B                                ; 01093  0x75, 0x06
  db 0xB9, 0xD0, 0x00                         ; 01095  mov cx, 0xd0
  jmp near loc_010A4                           ; 01098  0xE9, 0x09, 0x00

loc_0109B:  ; 0109B
  db 0xB9, 0xE0, 0x00                         ; 0109B  mov cx, 0xe0
  jmp near loc_010A4                           ; 0109E  0xE9, 0x03, 0x00

loc_010A1:  ; 010A1
  db 0xB9, 0xB0, 0x00                         ; 010A1  mov cx, 0xb0

loc_010A4:  ; 010A4
  db 0xF3, 0xAB                               ; 010A4  rep stosw
  db 0x07                                     ; 010A6  pop es
  db 0x2E, 0xA1, 0x06, 0x00                   ; 010A7  mov ax, word [cs:6]
  db 0x29, 0x47, 0x10                         ; 010AB  sub word p_uda[bx], ax
  db 0xC6, 0x47, 0x04, 0x00                   ; 010AE  mov byte [bx + 4], 0
  db 0xC6, 0x47, 0x05, 0xC8                   ; 010B2  mov byte [bx + 5], 0xc8
  db 0xA0, 0x12, 0x02                         ; 010B6  mov al, byte [0x212]
  db 0x88, 0x47, 0x15                         ; 010B9  mov byte p_luser[bx], al
  db 0xA0, 0x13, 0x02                         ; 010BC  mov al, byte [0x213]
  db 0x88, 0x47, 0x14                         ; 010BF  mov byte p_ldsk[bx], al
  db 0x06                                     ; 010C2  push es
  db 0x8E, 0x06, 0xE0, 0x01                   ; 010C3  mov es, word [0x1e0]
  db 0x26, 0xC7, 0x06, 0x02, 0x00, 0x80, 0x00 ; 010C7  mov word [es:2], 0x80
  db 0x8B, 0x1E, 0xE4, 0x01                   ; 010CE  mov bx, word [0x1e4]
  db 0x26, 0x89, 0x1E, 0x04, 0x00             ; 010D2  mov word [es:4], bx
  db 0xA1, 0xE2, 0x01                         ; 010D7  mov ax, word [0x1e2]
  db 0x80, 0x3E, 0x19, 0x02, 0xFF             ; 010DA  cmp byte [indisp], 0xff
  jne loc_010F8                                ; 010DF  0x75, 0x17
  db 0x26, 0xC7, 0x06, 0x00, 0x01, 0xFF, 0x03 ; 010E1  mov word [es:0x100], 0x3ff
  db 0x50                                     ; 010E8  push ax
  db 0xA1, 0xA4, 0x00                         ; 010E9  mov ax, word [0xa4]
  db 0x26, 0xA3, 0x40, 0x00                   ; 010EC  mov word [es:0x40], ax
  db 0xA1, 0xA6, 0x00                         ; 010F0  mov ax, word [0xa6]
  db 0x26, 0xA3, 0x42, 0x00                   ; 010F3  mov word [es:0x42], ax
  db 0x58                                     ; 010F7  pop ax

loc_010F8:  ; 010F8
  db 0x1E                                     ; 010F8  push ds
  db 0x8E, 0xDB                               ; 010F9  mov ds, bx
  db 0x26, 0x89, 0x1E, 0x52, 0x00             ; 010FB  mov word [es:0x52], bx
  db 0x26, 0x89, 0x1E, 0x54, 0x00             ; 01100  mov word [es:0x54], bx
  db 0x26, 0xA3, 0x56, 0x00                   ; 01105  mov word [es:0x56], ax
  db 0xA1, 0x03, 0x00                         ; 01109  mov ax, word [3]
  db 0x3D, 0x00, 0x00                         ; 0110C  cmp ax, 0
  jne loc_01119                                ; 0110F  0x75, 0x08
  db 0x1F                                     ; 01111  pop ds
  db 0x07                                     ; 01112  pop es
  db 0xB9, 0x21, 0x00                         ; 01113  mov cx, 0x21
  jmp near loc_00DDB                           ; 01116  0xE9, 0xC2, 0xFC

loc_01119:  ; 01119
  db 0x26, 0xA3, 0x50, 0x00                   ; 01119  mov word [es:0x50], ax
  db 0xA1, 0x0F, 0x00                         ; 0111D  mov ax, word [0xf]
  db 0x3D, 0x00, 0x00                         ; 01120  cmp ax, 0
  je loc_01129                                 ; 01123  0x74, 0x04
  db 0x26, 0xA3, 0x54, 0x00                   ; 01125  mov word [es:0x54], ax

loc_01129:  ; 01129
  db 0x26, 0xC7, 0x06, 0x34, 0x00, 0x56, 0x00 ; 01129  mov word [es:0x34], 0x56
  db 0x2B, 0xD2                               ; 01130  sub dx, dx
  db 0xA0, 0x05, 0x00                         ; 01132  mov al, byte [5]
  db 0x3C, 0x00                               ; 01135  cmp al, 0
  je loc_0113C                                 ; 01137  0x74, 0x03
  db 0xBA, 0x00, 0x01                         ; 01139  mov dx, 0x100

loc_0113C:  ; 0113C
  db 0x26, 0x8E, 0x1E, 0x56, 0x00             ; 0113C  mov ds, word [es:0x56]
  db 0x89, 0x16, 0x56, 0x00                   ; 01141  mov word [0x56], dx
  db 0xC7, 0x06, 0x5A, 0x00, 0x00, 0x02       ; 01145  mov word [0x5a], 0x200
  db 0xC7, 0x06, 0x5C, 0x00, 0xBB, 0x02       ; 0114B  mov word [0x5c], 0x2bb
  db 0x8C, 0x0E, 0x5E, 0x00                   ; 01151  mov word [0x5e], cs
  db 0x1F                                     ; 01155  pop ds
  db 0x07                                     ; 01156  pop es
  db 0x8B, 0x1E, 0xE4, 0x01                   ; 01157  mov bx, word [0x1e4]
  db 0x2B, 0xC9                               ; 0115B  sub cx, cx

loc_0115D:  ; 0115D
  db 0x51                                     ; 0115D  push cx
  db 0x53                                     ; 0115E  push bx
  db 0xB9, 0x8B, 0x00                         ; 0115F  mov cx, 0x8b
  db 0xBA, 0xD8, 0x01                         ; 01162  mov dx, 0x1d8
  call rtm_dispatcher                          ; 01165  0xE8, 0xAB, 0xF1
  db 0x5B                                     ; 01168  pop bx
  db 0x59                                     ; 01169  pop cx
  db 0xC3                                     ; 0116A  ret

load_group:  ; 0116B
  db 0x8B, 0xDE                               ; 0116B  mov bx, si
  db 0xA1, 0x0E, 0x02                         ; 0116D  mov ax, word [0x20e]
  db 0x8B, 0x4F, 0x0A                         ; 01170  mov cx, word [bx + 0xa]
  db 0x3B, 0xC8                               ; 01173  cmp cx, ax
  jb loc_011AE                                 ; 01175  0x72, 0x37
  db 0x2B, 0xC8                               ; 01177  sub cx, ax
  db 0x83, 0xF9, 0x08                         ; 01179  cmp cx, 8
  jae loc_011AE                                ; 0117C  0x73, 0x30
  db 0xBA, 0x08, 0x00                         ; 0117E  mov dx, 8
  db 0x2B, 0xD1                               ; 01181  sub dx, cx
  db 0x3B, 0x57, 0x0C                         ; 01183  cmp dx, word [bx + 0xc]
  jbe loc_0118B                                ; 01186  0x76, 0x03
  db 0x8B, 0x57, 0x0C                         ; 01188  mov dx, word [bx + 0xc]

loc_0118B:  ; 0118B
  db 0xBE, 0x1D, 0x02                         ; 0118B  mov si, 0x21d
  db 0x8B, 0xC1                               ; 0118E  mov ax, cx
  db 0xB1, 0x04                               ; 01190  mov cl, 4
  db 0xD3, 0xE0                               ; 01192  shl ax, cl
  db 0x03, 0xF0                               ; 01194  add si, ax
  db 0x8B, 0xC2                               ; 01196  mov ax, dx
  db 0xB1, 0x03                               ; 01198  mov cl, 3
  db 0xD3, 0xE0                               ; 0119A  shl ax, cl
  db 0x8B, 0xC8                               ; 0119C  mov cx, ax
  db 0x33, 0xFF                               ; 0119E  xor di, di
  db 0x06                                     ; 011A0  push es
  db 0x8E, 0x07                               ; 011A1  mov es, word [bx]
  db 0xF3, 0xA5                               ; 011A3  rep movsw
  db 0x07                                     ; 011A5  pop es
  db 0x01, 0x17                               ; 011A6  add word [bx], dx
  db 0x29, 0x57, 0x0C                         ; 011A8  sub word [bx + 0xc], dx
  db 0x01, 0x57, 0x0A                         ; 011AB  add word [bx + 0xa], dx

loc_011AE:  ; 011AE
  db 0x83, 0x7F, 0x0C, 0x00                   ; 011AE  cmp word [bx + 0xc], 0
  jne loc_011B7                                ; 011B2  0x75, 0x03
  db 0x2B, 0xC9                               ; 011B4  sub cx, cx
  db 0xC3                                     ; 011B6  ret

loc_011B7:  ; 011B7
  db 0xF7, 0x47, 0x0A, 0x07, 0x00             ; 011B7  test word [bx + 0xa], 7
  jne loc_011C4                                ; 011BC  0x75, 0x06
  db 0x83, 0x7F, 0x0C, 0x08                   ; 011BE  cmp word [bx + 0xc], 8
  jae loc_011F7                                ; 011C2  0x73, 0x33

loc_011C4:  ; 011C4
  db 0x53                                     ; 011C4  push bx
  db 0x8B, 0x47, 0x0A                         ; 011C5  mov ax, word [bx + 0xa]
  db 0xD1, 0xE8                               ; 011C8  shr ax, 1
  db 0xD1, 0xE8                               ; 011CA  shr ax, 1
  db 0xD1, 0xE8                               ; 011CC  shr ax, 1
  db 0xBB, 0x01, 0x00                         ; 011CE  mov bx, 1
  db 0xBA, 0x1D, 0x02                         ; 011D1  mov dx, 0x21d
  db 0x2E, 0x8B, 0x0E, 0x06, 0x00             ; 011D4  mov cx, word [cs:6]
  call load_xfer                               ; 011D9  0xE8, 0x54, 0x00
  db 0x5B                                     ; 011DC  pop bx
  jcxz loc_011E9                               ; 011DD  0xE3, 0x0A
  db 0x81, 0xF9, 0xFF, 0x00                   ; 011DF  cmp cx, 0xff
  jne loc_011E8                                ; 011E3  0x75, 0x03
  db 0xB9, 0x00, 0x00                         ; 011E5  mov cx, 0

loc_011E8:  ; 011E8
  db 0xC3                                     ; 011E8  ret

loc_011E9:  ; 011E9
  db 0x8B, 0x47, 0x0A                         ; 011E9  mov ax, word [bx + 0xa]
  db 0x25, 0xF8, 0xFF                         ; 011EC  and ax, 0xfff8
  db 0xA3, 0x0E, 0x02                         ; 011EF  mov word [0x20e], ax
  db 0x8B, 0xF3                               ; 011F2  mov si, bx
  jmp near load_group                           ; 011F4  0xE9, 0x74, 0xFF

loc_011F7:  ; 011F7
  db 0x53                                     ; 011F7  push bx
  db 0x2B, 0xD2                               ; 011F8  sub dx, dx
  db 0x8B, 0x0F                               ; 011FA  mov cx, word [bx]
  db 0x8B, 0x47, 0x0A                         ; 011FC  mov ax, word [bx + 0xa]
  db 0xD1, 0xE8                               ; 011FF  shr ax, 1
  db 0xD1, 0xE8                               ; 01201  shr ax, 1
  db 0xD1, 0xE8                               ; 01203  shr ax, 1
  db 0x8B, 0x5F, 0x0C                         ; 01205  mov bx, word [bx + 0xc]
  db 0xD1, 0xEB                               ; 01208  shr bx, 1
  db 0xD1, 0xEB                               ; 0120A  shr bx, 1
  db 0xD1, 0xEB                               ; 0120C  shr bx, 1
  db 0x53                                     ; 0120E  push bx
  call load_xfer                               ; 0120F  0xE8, 0x1E, 0x00
  db 0x58                                     ; 01212  pop ax
  db 0x5B                                     ; 01213  pop bx
  jcxz loc_0121F                               ; 01214  0xE3, 0x09
  db 0x81, 0xF9, 0xFF, 0x00                   ; 01216  cmp cx, 0xff
  jne loc_0121E                                ; 0121A  0x75, 0x02
  db 0x33, 0xC9                               ; 0121C  xor cx, cx

loc_0121E:  ; 0121E
  db 0xC3                                     ; 0121E  ret

loc_0121F:  ; 0121F
  db 0xD1, 0xE0                               ; 0121F  shl ax, 1
  db 0xD1, 0xE0                               ; 01221  shl ax, 1
  db 0xD1, 0xE0                               ; 01223  shl ax, 1
  db 0x01, 0x07                               ; 01225  add word [bx], ax
  db 0x01, 0x47, 0x0A                         ; 01227  add word [bx + 0xa], ax
  db 0x29, 0x47, 0x0C                         ; 0122A  sub word [bx + 0xc], ax
  jmp near loc_011AE                           ; 0122D  0xE9, 0x7E, 0xFF

load_xfer:  ; 01230
  db 0x26, 0x89, 0x16, 0x02, 0x00             ; 01230  mov word [es:2], dx
  db 0x26, 0x89, 0x0E, 0x04, 0x00             ; 01235  mov word [es:4], cx

loc_0123A:  ; 0123A
  db 0x53                                     ; 0123A  push bx
  db 0x50                                     ; 0123B  push ax
  db 0x81, 0xFB, 0x80, 0x00                   ; 0123C  cmp bx, 0x80
  jbe loc_01245                                ; 01240  0x76, 0x03
  db 0xBB, 0x80, 0x00                         ; 01242  mov bx, 0x80

loc_01245:  ; 01245
  db 0x26, 0x8A, 0x0E, 0x11, 0x00             ; 01245  mov cl, byte [es:0x11]
  db 0x51                                     ; 0124A  push cx
  db 0x26, 0x88, 0x1E, 0x11, 0x00             ; 0124B  mov byte [es:0x11], bl
  db 0x53                                     ; 01250  push bx
  db 0xBE, 0xEA, 0x01                         ; 01251  mov si, 0x1ea
  db 0x89, 0x44, 0x21                         ; 01254  mov word p_abort[si], ax
  db 0xB9, 0x21, 0x00                         ; 01257  mov cx, 0x21
  db 0x8B, 0xD6                               ; 0125A  mov dx, si
  db 0x06                                     ; 0125C  push es
  call rtm_dispatcher                          ; 0125D  0xE8, 0xB3, 0xF0
  db 0x07                                     ; 01260  pop es
  db 0x5A                                     ; 01261  pop dx
  db 0x59                                     ; 01262  pop cx
  db 0x26, 0x88, 0x0E, 0x11, 0x00             ; 01263  mov byte [es:0x11], cl
  db 0x80, 0xFB, 0x01                         ; 01268  cmp bl, 1
  jbe loc_01276                                ; 0126B  0x76, 0x09
  db 0xB9, 0x1D, 0x00                         ; 0126D  mov cx, 0x1d
  db 0xBB, 0xFF, 0xFF                         ; 01270  mov bx, 0xffff
  db 0x58                                     ; 01273  pop ax
  db 0x58                                     ; 01274  pop ax
  db 0xC3                                     ; 01275  ret

loc_01276:  ; 01276
  db 0x8A, 0xCB                               ; 01276  mov cl, bl
  db 0x32, 0xFF                               ; 01278  xor bh, bh
  db 0x8B, 0xFB                               ; 0127A  mov di, bx
  db 0x58                                     ; 0127C  pop ax
  db 0x03, 0xC2                               ; 0127D  add ax, dx
  db 0x5B                                     ; 0127F  pop bx
  db 0x2B, 0xDA                               ; 01280  sub bx, dx
  db 0xD1, 0xE2                               ; 01282  shl dx, 1
  db 0xD1, 0xE2                               ; 01284  shl dx, 1
  db 0xD1, 0xE2                               ; 01286  shl dx, 1
  db 0x26, 0x01, 0x16, 0x04, 0x00             ; 01288  add word [es:4], dx
  db 0x51                                     ; 0128D  push cx
  db 0x50                                     ; 0128E  push ax
  db 0x53                                     ; 0128F  push bx
  db 0x57                                     ; 01290  push di
  db 0xB9, 0x18, 0x04                         ; 01291  mov cx, 0x418
  call rtm_dispatcher                          ; 01294  0xE8, 0x7C, 0xF0
  db 0x5F                                     ; 01297  pop di
  db 0x5B                                     ; 01298  pop bx
  db 0x58                                     ; 01299  pop ax
  db 0x59                                     ; 0129A  pop cx
  db 0x8B, 0x36, 0x68, 0x00                   ; 0129B  mov si, word [0x68]
  db 0xF7, 0x44, 0x06, 0x80, 0x00             ; 0129F  test word [si + 6], 0x80
  je loc_012AD                                 ; 012A4  0x74, 0x07
  db 0xB9, 0x28, 0x00                         ; 012A6  mov cx, 0x28
  db 0xBB, 0xFF, 0xFF                         ; 012A9  mov bx, 0xffff
  db 0xC3                                     ; 012AC  ret

loc_012AD:  ; 012AD
  db 0x80, 0xF9, 0x00                         ; 012AD  cmp cl, 0
  je loc_012B6                                 ; 012B0  0x74, 0x04
  db 0xB9, 0xFF, 0x00                         ; 012B2  mov cx, 0xff
  db 0xC3                                     ; 012B5  ret

loc_012B6:  ; 012B6
  db 0x83, 0xFB, 0x00                         ; 012B6  cmp bx, 0
  jne loc_012BE                                ; 012B9  0x75, 0x03
  db 0x33, 0xC9                               ; 012BB  xor cx, cx
  db 0xC3                                     ; 012BD  ret

loc_012BE:  ; 012BE
  jmp near loc_0123A                           ; 012BE  0xE9, 0x79, 0xFF

rtm_put_drl:  ; 012C1
  db 0xBB, 0x6E, 0x00                         ; 012C1  mov bx, 0x6e

loc_012C4:  ; 012C4
  db 0x56                                     ; 012C4  push si
  db 0xBA, 0xEA, 0x01                         ; 012C5  mov dx, 0x1ea
  db 0x83, 0xC2, 0x01                         ; 012C8  add dx, 1
  db 0xB9, 0x14, 0x02                         ; 012CB  mov cx, 0x214
  call rtm_dispatcher                          ; 012CE  0xE8, 0x42, 0xF0
  db 0x5E                                     ; 012D1  pop si
  db 0x83, 0xFB, 0xFF                         ; 012D2  cmp bx, -1
  je loc_01322                                 ; 012D5  0x74, 0x4B
  db 0xA0, 0x13, 0x02                         ; 012D7  mov al, byte [0x213]
  db 0x38, 0x47, 0x14                         ; 012DA  cmp byte p_ldsk[bx], al
  jne loc_012C4                                ; 012DD  0x75, 0xE5
  db 0xA0, 0x12, 0x02                         ; 012DF  mov al, byte [0x212]
  db 0x38, 0x47, 0x15                         ; 012E2  cmp byte p_luser[bx], al
  jne loc_012C4                                ; 012E5  0x75, 0xDD
  db 0x53                                     ; 012E7  push bx
  db 0x56                                     ; 012E8  push si
  call rtm_get_pmem                               ; 012E9  0xE8, 0xC2, 0x00
  db 0x5E                                     ; 012EC  pop si
  db 0x5B                                     ; 012ED  pop bx
  db 0x83, 0xF9, 0xFF                         ; 012EE  cmp cx, -1
  je loc_01322                                 ; 012F1  0x74, 0x2F
  db 0xC7, 0x44, 0x0C, 0x00, 0x00             ; 012F3  mov word [si + 0xc], 0
  db 0x9C                                     ; 012F8  pushf
  db 0xFA                                     ; 012F9  cli
  db 0xBF, 0x6E, 0x00                         ; 012FA  mov di, 0x6e

loc_012FD:  ; 012FD
  db 0x39, 0x5D, 0x02                         ; 012FD  cmp word [di + 2], bx
  je loc_01307                                 ; 01300  0x74, 0x05
  db 0x8B, 0x7D, 0x02                         ; 01302  mov di, word [di + 2]
  jmp short loc_012FD                          ; 01305  0xEB, 0xF6

loc_01307:  ; 01307
  db 0x8B, 0x47, 0x02                         ; 01307  mov ax, word [bx + 2]
  db 0x89, 0x45, 0x02                         ; 0130A  mov word [di + 2], ax

loc_0130D:  ; 0130D
  db 0x83, 0x7D, 0x02, 0x00                   ; 0130D  cmp word [di + 2], 0
  je loc_01318                                 ; 01311  0x74, 0x05
  db 0x8B, 0x7D, 0x02                         ; 01313  mov di, word [di + 2]
  jmp short loc_0130D                          ; 01316  0xEB, 0xF5

loc_01318:  ; 01318
  db 0x89, 0x5D, 0x02                         ; 01318  mov word [di + 2], bx
  db 0x33, 0xC9                               ; 0131B  xor cx, cx
  db 0x89, 0x4F, 0x02                         ; 0131D  mov word [bx + 2], cx
  db 0x9D                                     ; 01320  popf
  db 0xC3                                     ; 01321  ret

loc_01322:  ; 01322
  db 0x9C                                     ; 01322  pushf
  db 0xFA                                     ; 01323  cli
  db 0x8B, 0x1E, 0x5C, 0x00                   ; 01324  mov bx, word [0x5c]
  db 0x83, 0xFB, 0x00                         ; 01328  cmp bx, 0
  je loc_013A9                                 ; 0132B  0x74, 0x7C
  db 0x8B, 0x07                               ; 0132D  mov ax, word [bx]
  db 0xA3, 0x5C, 0x00                         ; 0132F  mov word [0x5c], ax
  db 0x9D                                     ; 01332  popf
  db 0x53                                     ; 01333  push bx
  db 0x56                                     ; 01334  push si
  db 0xB9, 0x80, 0x00                         ; 01335  mov cx, 0x80
  db 0x8B, 0xD6                               ; 01338  mov dx, si
  call rtm_dispatcher                          ; 0133A  0xE8, 0xD6, 0xEF
  db 0x5E                                     ; 0133D  pop si
  db 0x5B                                     ; 0133E  pop bx
  db 0x83, 0xF9, 0x00                         ; 0133F  cmp cx, 0
  jne loc_0139E                                ; 01342  0x75, 0x5A
  db 0x56                                     ; 01344  push si
  db 0x8B, 0x74, 0x06                         ; 01345  mov si, word [si + 6]
  db 0x56                                     ; 01348  push si
  db 0x8B, 0xFB                               ; 01349  mov di, bx
  db 0x83, 0xC6, 0x08                         ; 0134B  add si, 8
  db 0x83, 0xC7, 0x08                         ; 0134E  add di, 8
  db 0xB9, 0x04, 0x00                         ; 01351  mov cx, 4
  db 0x06                                     ; 01354  push es
  db 0x8C, 0xD8                               ; 01355  mov ax, ds
  db 0x8E, 0xC0                               ; 01357  mov es, ax
  db 0xF3, 0xA5                               ; 01359  rep movsw
  db 0x07                                     ; 0135B  pop es
  db 0x5F                                     ; 0135C  pop di
  db 0x5E                                     ; 0135D  pop si
  db 0xA0, 0x12, 0x02                         ; 0135E  mov al, byte [0x212]
  db 0x88, 0x47, 0x15                         ; 01361  mov byte p_luser[bx], al
  db 0xA0, 0x13, 0x02                         ; 01364  mov al, byte [0x213]
  db 0x88, 0x47, 0x14                         ; 01367  mov byte p_ldsk[bx], al
  db 0x8B, 0x04                               ; 0136A  mov ax, word [si]
  db 0x53                                     ; 0136C  push bx
  db 0x56                                     ; 0136D  push si
  db 0x1E                                     ; 0136E  push ds
  db 0x50                                     ; 0136F  push ax
  db 0x53                                     ; 01370  push bx
  db 0x57                                     ; 01371  push di
  db 0x8C, 0xD0                               ; 01372  mov ax, ss
  db 0x8E, 0xD8                               ; 01374  mov ds, ax
  db 0x8B, 0xD4                               ; 01376  mov dx, sp
  db 0xB9, 0x08, 0x03                         ; 01378  mov cx, 0x308
  call rtm_dispatcher                          ; 0137B  0xE8, 0x95, 0xEF
  db 0x83, 0xC4, 0x06                         ; 0137E  add sp, 6
  db 0x1F                                     ; 01381  pop ds
  db 0x5E                                     ; 01382  pop si
  db 0x5B                                     ; 01383  pop bx
  db 0x9C                                     ; 01384  pushf
  db 0xFA                                     ; 01385  cli
  db 0xBF, 0x6E, 0x00                         ; 01386  mov di, 0x6e

loc_01389:  ; 01389
  db 0x83, 0x7D, 0x02, 0x00                   ; 01389  cmp word [di + 2], 0
  je loc_01394                                 ; 0138D  0x74, 0x05
  db 0x8B, 0x7D, 0x02                         ; 0138F  mov di, word [di + 2]
  jmp short loc_01389                          ; 01392  0xEB, 0xF5

loc_01394:  ; 01394
  db 0x89, 0x5D, 0x02                         ; 01394  mov word [di + 2], bx
  db 0x33, 0xC9                               ; 01397  xor cx, cx
  db 0x89, 0x4F, 0x02                         ; 01399  mov word [bx + 2], cx
  db 0x9D                                     ; 0139C  popf
  db 0xC3                                     ; 0139D  ret

loc_0139E:  ; 0139E
  db 0x9C                                     ; 0139E  pushf
  db 0xFA                                     ; 0139F  cli
  db 0xA1, 0x5C, 0x00                         ; 013A0  mov ax, word [0x5c]
  db 0x89, 0x07                               ; 013A3  mov word [bx], ax
  db 0x89, 0x1E, 0x5C, 0x00                   ; 013A5  mov word [0x5c], bx

loc_013A9:  ; 013A9
  db 0x9D                                     ; 013A9  popf
  db 0xB9, 0xFF, 0xFF                         ; 013AA  mov cx, 0xffff
  db 0xC3                                     ; 013AD  ret

rtm_get_pmem:  ; 013AE
  db 0x8D, 0x7F, 0x16                         ; 013AE  lea di, p_mem[bx]

loc_013B1:  ; 013B1
  db 0x8B, 0x3D                               ; 013B1  mov di, word [di]
  db 0x83, 0xFF, 0x00                         ; 013B3  cmp di, 0
  je loc_013E5                                 ; 013B6  0x74, 0x2D
  db 0x8B, 0x45, 0x06                         ; 013B8  mov ax, word [di + 6]
  db 0x25, 0x07, 0x00                         ; 013BB  and ax, 7
  db 0x3D, 0x07, 0x00                         ; 013BE  cmp ax, 7
  jne loc_013B1                                ; 013C1  0x75, 0xEE
  db 0x56                                     ; 013C3  push si
  db 0x1E                                     ; 013C4  push ds
  db 0xFF, 0x75, 0x02                         ; 013C5  push word [di + 2]
  db 0xFF, 0x75, 0x02                         ; 013C8  push word [di + 2]
  db 0xFF, 0x36, 0xE8, 0x01                   ; 013CB  push word [0x1e8]
  db 0x53                                     ; 013CF  push bx
  db 0x8C, 0xD0                               ; 013D0  mov ax, ss
  db 0x8E, 0xD8                               ; 013D2  mov ds, ax
  db 0x8B, 0xD4                               ; 013D4  mov dx, sp
  db 0xB9, 0x08, 0x03                         ; 013D6  mov cx, 0x308
  call rtm_dispatcher                          ; 013D9  0xE8, 0x37, 0xEF
  db 0x58                                     ; 013DC  pop ax
  db 0x58                                     ; 013DD  pop ax
  db 0x58                                     ; 013DE  pop ax
  db 0x5A                                     ; 013DF  pop dx
  db 0x1F                                     ; 013E0  pop ds
  db 0x5E                                     ; 013E1  pop si
  db 0x89, 0x14                               ; 013E2  mov word [si], dx
  db 0xC3                                     ; 013E4  ret

loc_013E5:  ; 013E5
  db 0xB9, 0xFF, 0xFF                         ; 013E5  mov cx, 0xffff
  db 0xC3                                     ; 013E8  ret
  db 0x26, 0xA1, 0x2E, 0x00                   ; 013E9  mov ax, word [es:0x2e]
  db 0x1E                                     ; 013ED  push ds
  db 0x8E, 0xD8                               ; 013EE  mov ds, ax
  db 0x06                                     ; 013F0  push es
  db 0x8E, 0xC0                               ; 013F1  mov es, ax
  db 0x8B, 0xDA                               ; 013F3  mov bx, dx
  db 0x8B, 0x37                               ; 013F5  mov si, word [bx]
  db 0x8B, 0x5F, 0x02                         ; 013F7  mov bx, word [bx + 2]
  call parse_fcbi                               ; 013FA  0xE8, 0x36, 0x01
  call parse_debl                               ; 013FD  0xE8, 0x25, 0x01
  db 0xBD, 0x18, 0x00                         ; 01400  mov bp, 0x18
  call parse_delim                               ; 01403  0xE8, 0xE0, 0x00
  jne loc_0140B                                ; 01406  0x75, 0x03
  jmp near loc_014BC                           ; 01408  0xE9, 0xB1, 0x00

loc_0140B:  ; 0140B
  db 0x8A, 0xE8                               ; 0140B  mov ch, al
  db 0x46                                     ; 0140D  inc si
  db 0x8A, 0x04                               ; 0140E  mov al, byte [si]
  db 0x3C, 0x3A                               ; 01410  cmp al, 0x3a
  jne loc_0143D                                ; 01412  0x75, 0x29
  db 0xBD, 0x17, 0x00                         ; 01414  mov bp, 0x17
  db 0x8A, 0xC5                               ; 01417  mov al, ch
  db 0x2C, 0x41                               ; 01419  sub al, 0x41
  jb loc_01452                                 ; 0141B  0x72, 0x35
  db 0x3C, 0x10                               ; 0141D  cmp al, 0x10
  jge loc_01452                                ; 0141F  0x7D, 0x31
  db 0xFE, 0xC0                               ; 01421  inc al
  db 0x88, 0x07                               ; 01423  mov byte [bx], al
  db 0xBD, 0x18, 0x00                         ; 01425  mov bp, 0x18
  db 0x46                                     ; 01428  inc si
  call parse_delim                               ; 01429  0xE8, 0xBA, 0x00
  jne loc_0143E                                ; 0142C  0x75, 0x10
  db 0x3C, 0x2E                               ; 0142E  cmp al, 0x2e
  je loc_01452                                 ; 01430  0x74, 0x20
  db 0x3C, 0x3A                               ; 01432  cmp al, 0x3a
  je loc_01452                                 ; 01434  0x74, 0x1C
  db 0x3C, 0x3B                               ; 01436  cmp al, 0x3b
  je loc_01452                                 ; 01438  0x74, 0x18
  jmp near loc_0143E                           ; 0143A  0xE9, 0x01, 0x00

loc_0143D:  ; 0143D
  db 0x4E                                     ; 0143D  dec si

loc_0143E:  ; 0143E
  db 0x8B, 0xFB                               ; 0143E  mov di, bx
  db 0x8D, 0x5D, 0x01                         ; 01440  lea bx, [di + 1]
  db 0xB5, 0x08                               ; 01443  mov ch, 8
  call parse_setfld                               ; 01445  0xE8, 0x7C, 0x00
  db 0x80, 0xFD, 0x00                         ; 01448  cmp ch, 0
  jne loc_0145A                                ; 0144B  0x75, 0x0D
  call parse_delim                               ; 0144D  0xE8, 0x96, 0x00
  je loc_0145A                                 ; 01450  0x74, 0x08

loc_01452:  ; 01452
  db 0x8B, 0xCD                               ; 01452  mov cx, bp
  db 0xBB, 0xFF, 0xFF                         ; 01454  mov bx, 0xffff
  db 0x07                                     ; 01457  pop es
  db 0x1F                                     ; 01458  pop ds
  db 0xC3                                     ; 01459  ret

loc_0145A:  ; 0145A
  db 0x3C, 0x2E                               ; 0145A  cmp al, 0x2e
  jne loc_01477                                ; 0145C  0x75, 0x19
  db 0xBD, 0x19, 0x00                         ; 0145E  mov bp, 0x19
  db 0xB5, 0x03                               ; 01461  mov ch, 3
  db 0x8D, 0x5D, 0x09                         ; 01463  lea bx, [di + 9]
  db 0x46                                     ; 01466  inc si
  call parse_setfld                               ; 01467  0xE8, 0x5A, 0x00
  db 0x80, 0xFD, 0x00                         ; 0146A  cmp ch, 0
  jne loc_01477                                ; 0146D  0x75, 0x08
  call parse_delim                               ; 0146F  0xE8, 0x74, 0x00
  je loc_01477                                 ; 01472  0x74, 0x03
  jmp near loc_01452                           ; 01474  0xE9, 0xDB, 0xFF

loc_01477:  ; 01477
  db 0x3C, 0x3B                               ; 01477  cmp al, 0x3b
  jne loc_014A8                                ; 01479  0x75, 0x2D
  db 0xBD, 0x26, 0x00                         ; 0147B  mov bp, 0x26
  db 0xB5, 0x08                               ; 0147E  mov ch, 8
  db 0x8D, 0x5D, 0x10                         ; 01480  lea bx, p_uda[di]
  db 0x46                                     ; 01483  inc si
  db 0x89, 0x75, 0x18                         ; 01484  mov word p_cmod[di], si
  call parse_setfld                               ; 01487  0xE8, 0x3A, 0x00
  db 0xB1, 0x08                               ; 0148A  mov cl, 8
  db 0x2A, 0xCD                               ; 0148C  sub cl, ch
  db 0x88, 0x4D, 0x1A                         ; 0148E  mov byte p_wait[di], cl
  db 0x80, 0xF9, 0x00                         ; 01491  cmp cl, 0
  jne loc_0149B                                ; 01494  0x75, 0x05
  db 0xC7, 0x45, 0x18, 0x00, 0x00             ; 01496  mov word p_cmod[di], 0

loc_0149B:  ; 0149B
  db 0x80, 0xFD, 0x00                         ; 0149B  cmp ch, 0
  jne loc_014A8                                ; 0149E  0x75, 0x08
  call parse_delim                               ; 014A0  0xE8, 0x43, 0x00
  je loc_014A8                                 ; 014A3  0x74, 0x03
  jmp near loc_01452                           ; 014A5  0xE9, 0xAA, 0xFF

loc_014A8:  ; 014A8
  db 0x8B, 0xDE                               ; 014A8  mov bx, si
  call parse_debl                               ; 014AA  0xE8, 0x78, 0x00
  call parse_delim                               ; 014AD  0xE8, 0x36, 0x00
  jne loc_014BF                                ; 014B0  0x75, 0x0D
  db 0x8B, 0xDE                               ; 014B2  mov bx, si
  db 0x3C, 0x00                               ; 014B4  cmp al, 0
  je loc_014BC                                 ; 014B6  0x74, 0x04
  db 0x3C, 0x0D                               ; 014B8  cmp al, 0xd
  jne loc_014BF                                ; 014BA  0x75, 0x03

loc_014BC:  ; 014BC
  db 0xBB, 0x00, 0x00                         ; 014BC  mov bx, 0

loc_014BF:  ; 014BF
  db 0x2B, 0xC9                               ; 014BF  sub cx, cx
  db 0x07                                     ; 014C1  pop es
  db 0x1F                                     ; 014C2  pop ds
  db 0xC3                                     ; 014C3  ret

parse_setfld:  ; 014C4
  db 0x5A                                     ; 014C4  pop dx
  call parse_delim                               ; 014C5  0xE8, 0x1E, 0x00
  db 0x52                                     ; 014C8  push dx
  je loc_014E5                                 ; 014C9  0x74, 0x1A
  db 0x3C, 0x2A                               ; 014CB  cmp al, 0x2a
  jne loc_014DA                                ; 014CD  0x75, 0x0B
  db 0xC6, 0x07, 0x3F                         ; 014CF  mov byte [bx], 0x3f
  db 0x43                                     ; 014D2  inc bx
  db 0xFE, 0xCD                               ; 014D3  dec ch
  jne parse_setfld                                ; 014D5  0x75, 0xED
  jmp near loc_014DF                           ; 014D7  0xE9, 0x05, 0x00

loc_014DA:  ; 014DA
  db 0x88, 0x07                               ; 014DA  mov byte [bx], al
  db 0x43                                     ; 014DC  inc bx
  db 0xFE, 0xCD                               ; 014DD  dec ch

loc_014DF:  ; 014DF
  db 0x46                                     ; 014DF  inc si
  db 0x80, 0xFD, 0x00                         ; 014E0  cmp ch, 0
  jne parse_setfld                                ; 014E3  0x75, 0xDF

loc_014E5:  ; 014E5
  db 0xC3                                     ; 014E5  ret

parse_delim:  ; 014E6
  db 0xB1, 0x0E                               ; 014E6  mov cl, 0xe
  db 0x8A, 0x04                               ; 014E8  mov al, byte [si]
  db 0x57                                     ; 014EA  push di
  db 0xBF, 0x97, 0x14                         ; 014EB  mov di, 0x1497

loc_014EE:  ; 014EE
  db 0x80, 0xF9, 0x00                         ; 014EE  cmp cl, 0
  je loc_014FD                                 ; 014F1  0x74, 0x0A
  db 0x2E, 0x38, 0x05                         ; 014F3  cmp byte [cs:di], al
  je loc_01515                                 ; 014F6  0x74, 0x1D
  db 0xFE, 0xC9                               ; 014F8  dec cl
  db 0x47                                     ; 014FA  inc di
  jmp short loc_014EE                          ; 014FB  0xEB, 0xF1

loc_014FD:  ; 014FD
  db 0x3C, 0x20                               ; 014FD  cmp al, 0x20
  ja loc_01509                                 ; 014FF  0x77, 0x08
  db 0x5F                                     ; 01501  pop di
  db 0x5B                                     ; 01502  pop bx
  db 0xB9, 0x18, 0x00                         ; 01503  mov cx, 0x18
  jmp near loc_01452                           ; 01506  0xE9, 0x49, 0xFF

loc_01509:  ; 01509
  db 0x3C, 0x61                               ; 01509  cmp al, 0x61
  jb loc_01515                                 ; 0150B  0x72, 0x08
  db 0x3C, 0x7A                               ; 0150D  cmp al, 0x7a
  ja loc_01513                                 ; 0150F  0x77, 0x02
  db 0x24, 0x5F                               ; 01511  and al, 0x5f

loc_01513:  ; 01513
  db 0x24, 0x7F                               ; 01513  and al, 0x7f

loc_01515:  ; 01515
  db 0x5F                                     ; 01515  pop di
  db 0xC3                                     ; 01516  ret
  db 0x00                                                         ; 01517  .
  db 0x09, 0x0D                               ; 01518  or word [di], cx
  db 0x2E, 0x3A, 0x3B                         ; 0151A  cmp bh, byte [cs:bp + di]
  db 0x3D, 0x2C, 0x2F                         ; 0151D  cmp ax, 0x2f2c
  db 0x5B                                     ; 01520  pop bx
  db 0x5D                                     ; 01521  pop bp
  db 0x3C, 0x3E                               ; 01522  cmp al, 0x3e
  db 0x20                                                         ; 01524   

parse_debl:  ; 01525
  db 0x80, 0x3C, 0x20                         ; 01525  cmp byte [si], 0x20
  je loc_01530                                 ; 01528  0x74, 0x06
  db 0x80, 0x3C, 0x09                         ; 0152A  cmp byte [si], 9
  je loc_01530                                 ; 0152D  0x74, 0x01
  db 0xC3                                     ; 0152F  ret

loc_01530:  ; 01530
  db 0x46                                     ; 01530  inc si
  jmp short parse_debl                          ; 01531  0xEB, 0xF2

parse_fcbi:  ; 01533
  db 0x8B, 0xFB                               ; 01533  mov di, bx
  db 0x2B, 0xC0                               ; 01535  sub ax, ax
  db 0x2B, 0xC9                               ; 01537  sub cx, cx
  db 0xAA                                     ; 01539  stosb
  db 0xB0, 0x20                               ; 0153A  mov al, 0x20
  db 0xB1, 0x0B                               ; 0153C  mov cl, 0xb
  db 0xF3, 0xAA                               ; 0153E  rep stosb
  db 0xB0, 0x00                               ; 01540  mov al, 0
  db 0xB1, 0x02                               ; 01542  mov cl, 2
  db 0xF3, 0xAB                               ; 01544  rep stosw
  db 0xB0, 0x20                               ; 01546  mov al, 0x20
  db 0xB1, 0x08                               ; 01548  mov cl, 8
  db 0xF3, 0xAA                               ; 0154A  rep stosb
  db 0xB0, 0x00                               ; 0154C  mov al, 0
  db 0xB1, 0x03                               ; 0154E  mov cl, 3
  db 0xF3, 0xAA                               ; 01550  rep stosb
  db 0xC3                                     ; 01552  ret
  db 0x1E                                     ; 01553  push ds
  db 0x06                                     ; 01554  push es
  db 0x26, 0x8E, 0x1E, 0x2E, 0x00             ; 01555  mov ds, word [es:0x2e]
  db 0x8B, 0xF2                               ; 0155A  mov si, dx
  db 0x0E                                     ; 0155C  push cs
  db 0xB8, 0x42, 0x15                         ; 0155D  mov ax, 0x1542
  db 0x50                                     ; 01560  push ax
  db 0x2B, 0xC0                               ; 01561  sub ax, ax
  db 0x50                                     ; 01563  push ax
  db 0x50                                     ; 01564  push ax
  db 0x8B, 0xFC                               ; 01565  mov di, sp
  db 0xFF, 0x74, 0x06                         ; 01567  push word [si + 6]
  db 0xFF, 0x74, 0x04                         ; 0156A  push word [si + 4]
  db 0xFF, 0x74, 0x02                         ; 0156D  push word [si + 2]
  db 0xFF, 0x34                               ; 01570  push word [si]
  db 0x8B, 0x74, 0x08                         ; 01572  mov si, word [si + 8]
  db 0x57                                     ; 01575  push di
  db 0x40                                     ; 01576  inc ax
  db 0x50                                     ; 01577  push ax
  db 0x48                                     ; 01578  dec ax
  db 0x50                                     ; 01579  push ax
  db 0x50                                     ; 0157A  push ax
  db 0x8B, 0xD4                               ; 0157B  mov dx, sp
  db 0x8B, 0xFA                               ; 0157D  mov di, dx
  db 0x8C, 0xD0                               ; 0157F  mov ax, ss
  db 0x8E, 0xD8                               ; 01581  mov ds, ax
  db 0xB9, 0x87, 0x00                         ; 01583  mov cx, 0x87
  db 0x56                                     ; 01586  push si
  db 0x57                                     ; 01587  push di
  call rtm_dispatcher                          ; 01588  0xE8, 0x88, 0xED
  db 0x5F                                     ; 0158B  pop di
  db 0x5E                                     ; 0158C  pop si
  db 0x83, 0xF9, 0x00                         ; 0158D  cmp cx, 0
  jne loc_015CB                                ; 01590  0x75, 0x39
  db 0x8B, 0x5D, 0x02                         ; 01592  mov bx, word [di + 2]
  db 0x1E                                     ; 01595  push ds
  db 0x2E, 0x8E, 0x1E, 0x06, 0x00             ; 01596  mov ds, word [cs:6]
  db 0xF7, 0x47, 0x04, 0x20, 0x00             ; 0159B  test word [bx + 4], 0x20
  db 0x1F                                     ; 015A0  pop ds
  je loc_015CB                                 ; 015A1  0x74, 0x28
  db 0xB9, 0x89, 0x00                         ; 015A3  mov cx, 0x89
  db 0x8B, 0xD7                               ; 015A6  mov dx, di
  db 0x56                                     ; 015A8  push si
  call rtm_dispatcher                          ; 015A9  0xE8, 0x67, 0xED
  db 0x5E                                     ; 015AC  pop si
  db 0x83, 0xF9, 0x00                         ; 015AD  cmp cx, 0
  jne loc_015CB                                ; 015B0  0x75, 0x19
  db 0x83, 0xC4, 0x10                         ; 015B2  add sp, 0x10
  db 0x8B, 0xD6                               ; 015B5  mov dx, si
  db 0x26, 0x8E, 0x1E, 0x2E, 0x00             ; 015B7  mov ds, word [es:0x2e]
  db 0x26, 0x8E, 0x06, 0x30, 0x00             ; 015BC  mov es, word [es:0x30]
  db 0xCB                                     ; 015C1  retf
  db 0x8C, 0xC0                               ; 015C2  mov ax, es
  db 0x07                                     ; 015C4  pop es
  db 0x1F                                     ; 015C5  pop ds
  db 0x26, 0xA3, 0x30, 0x00                   ; 015C6  mov word [es:0x30], ax
  db 0xC3                                     ; 015CA  ret

loc_015CB:  ; 015CB
  db 0x83, 0xC4, 0x18                         ; 015CB  add sp, 0x18
  db 0x07                                     ; 015CE  pop es
  db 0x1F                                     ; 015CF  pop ds
  db 0xBB, 0x01, 0x00                         ; 015D0  mov bx, 1
  db 0xB9, 0x09, 0x00                         ; 015D3  mov cx, 9
  db 0xC3                                     ; 015D6  ret
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00         ; 015D7  .........
  db 0x0D, 0x0A, 0x43                         ; 015E0  or ax, 0x430a
  db 0x6F                                     ; 015E3  outsw
  db 0x6E                                     ; 015E4  outsb
  db 0x63, 0x75, 0x72                         ; 015E5  arpl word [di + 0x72], si
  jb loc_0164F                                 ; 015E8  0x72, 0x65
  db 0x6E                                     ; 015EA  outsb
  je loc_0160D                                 ; 015EB  0x74, 0x20
  db 0x43                                     ; 015ED  inc bx
  db 0x50                                     ; 015EE  push ax
  db 0x2F                                     ; 015EF  das
  db 0x4D                                     ; 015F0  dec bp
  db 0x2D, 0x38, 0x36                         ; 015F1  sub ax, 0x3638
  db 0x20, 0x33                               ; 015F4  and byte [bp + di], dh
  db 0x2E, 0x31, 0x0D                         ; 015F6  xor word [cs:di], cx
  db 0x0A, 0x43, 0x6F                         ; 015F9  or al, byte [bp + di + 0x6f]
  jo loc_01677                                 ; 015FC  0x70, 0x79
  jb loc_01669                                 ; 015FE  0x72, 0x69
  db 0x67, 0x68, 0x74, 0x20                   ; 01600  push 0x2074
  db 0x28, 0x43, 0x29                         ; 01604  sub byte [bp + di + 0x29], al
  db 0x20, 0x31                               ; 01607  and byte [bx + di], dh
  db 0x39, 0x38                               ; 01609  cmp word [bx + si], di
  db 0x33, 0x2C                               ; 0160B  xor bp, word [si]

loc_0160D:  ; 0160D
  db 0x20, 0x44, 0x69                         ; 0160D  and byte [si + 0x69], al
  db 0x67, 0x69, 0x74, 0x61, 0x6C, 0x20, 0x52 ; 01610  imul si, word [ecx + 0x6c], 0x5220
  db 0x65, 0x73, 0x65                         ; 01617  jae 0x167f
  db 0x61                                     ; 0161A  popa
  jb loc_01680                                 ; 0161B  0x72, 0x63
  db 0x68, 0x0D, 0x0A                         ; 0161D  push 0xa0d
  db 0x53                                     ; 01620  push bx
  db 0x79, 0x73                               ; 01621  jns 0x1696
  je loc_0168A                                 ; 01623  0x74, 0x65
  db 0x6D                                     ; 01625  insw
  db 0x20, 0x6D, 0x65                         ; 01626  and byte [di + 0x65], ch
  db 0x64, 0x20, 0x31                         ; 01629  and byte [fs:bx + di], dh
  db 0x20, 0x6B, 0x6F                         ; 0162C  and byte [bp + di + 0x6f], ch
  db 0x6E                                     ; 0162F  outsb
  db 0x73, 0x6F                               ; 01630  jae 0x16a1
  db 0x6C                                     ; 01632  insb
  db 0x0D, 0x0A, 0x24                         ; 01633  or ax, 0x240a
  db 0x0D, 0x0A, 0x00                         ; 01636  or ax, 0xa
  db 0x00, 0x00                               ; 01639  add byte [bx + si], al
  db 0x00, 0x00                               ; 0163B  add byte [bx + si], al
  db 0x00, 0x00                               ; 0163D  add byte [bx + si], al
  db 0x00, 0xE9                               ; 0163F  add cl, ch
