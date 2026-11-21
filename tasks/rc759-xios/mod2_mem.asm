; =============================================================================
; ccpm.sys — Modul 2: Memory Manager (MEMIF.MEM)
; Offset range: 0x026C0 - 0x031E0
; =============================================================================

  jmp near mem_init                            ; 026C0  0xE9, 0x48, 0x00
  jmp near mem_entry                           ; 026C3  0xE9, 0x60, 0x00
  db 0xFA                                     ; 026C6  cli
  db 0x06                                     ; 026C7  push es
  db 0x03, 0x00                               ; 026C8  add ax, word [bx + si]
  db 0x48                                     ; 026CA  dec ax
  db 0x00, 0x06, 0x43, 0x4F                   ; 026CB  add byte [0x4f43], al
  db 0x50                                     ; 026CF  push ax
  db 0x59                                     ; 026D0  pop cx
  db 0x52                                     ; 026D1  push dx
  db 0x49                                     ; 026D2  dec cx
  db 0x47                                     ; 026D3  inc di
  db 0x48                                     ; 026D4  dec ax
  db 0x54                                     ; 026D5  push sp
  db 0x20, 0x28                               ; 026D6  and byte [bx + si], ch
  db 0x43                                     ; 026D8  inc bx
  db 0x29, 0x20                               ; 026D9  sub word [bx + si], sp
  db 0x31, 0x39                               ; 026DB  xor word [bx + di], di
  db 0x38, 0x32                               ; 026DD  cmp byte [bp + si], dh
  db 0x2C, 0x31                               ; 026DF  sub al, 0x31
  db 0x39, 0x38                               ; 026E1  cmp word [bx + si], di
  db 0x33, 0x2C                               ; 026E3  xor bp, word [si]
  db 0x31, 0x39                               ; 026E5  xor word [bx + di], di
  db 0x38, 0x34                               ; 026E7  cmp byte [si], dh
  db 0x20, 0x44, 0x49                         ; 026E9  and byte [si + 0x49], al
  db 0x47                                     ; 026EC  inc di
  db 0x49                                     ; 026ED  dec cx
  db 0x54                                     ; 026EE  push sp
  db 0x41                                     ; 026EF  inc cx
  db 0x4C                                     ; 026F0  dec sp
  db 0x20, 0x52, 0x45                         ; 026F1  and byte [bp + si + 0x45], dl
  db 0x53                                     ; 026F4  push bx
  db 0x45                                     ; 026F5  inc bp
  db 0x41                                     ; 026F6  inc cx
  db 0x52                                     ; 026F7  push dx
  db 0x43                                     ; 026F8  inc bx
  db 0x48                                     ; 026F9  dec ax
  db 0x20, 0x31                               ; 026FA  and byte [bx + di], dh
  db 0x30, 0x33                               ; 026FC  xor byte [bp + di], dh
  db 0x34, 0x2D                               ; 026FE  xor al, 0x2d
  db 0x30, 0x32                               ; 02700  xor byte [bp + si], dh
  db 0x36, 0x31, 0x2D                         ; 02702  xor word [ss:di], bp
  db 0x30, 0x30                               ; 02705  xor byte [bx + si], dh
  db 0x37                                     ; 02707  aaa
  db 0x30, 0x34                               ; 02708  xor byte [si], dh
  db 0x31                                                         ; 0270A  1

mem_init:  ; 0270B
  db 0xCB                                     ; 0270B  retf
  db 0xDE, 0x00                               ; 0270C  fiadd word [bx + si]
  db 0x0A, 0x01                               ; 0270E  or al, byte [bx + di]
  db 0x32, 0x01                               ; 02710  xor al, byte [bx + di]
  db 0x5A                                     ; 02712  pop dx
  db 0x01, 0xC0                               ; 02713  add ax, ax
  db 0x01, 0x0F                               ; 02715  add word [bx], cx
  db 0x02, 0x6B, 0x02                         ; 02717  add ch, byte [bp + di + 2]
  loope loc_02720                              ; 0271A  0xE1, 0x04
  db 0xD3, 0x05                               ; 0271C  rol word [di], cl
  jp mem_entry                                 ; 0271E  0x7A, 0x06

loc_02720:  ; 02720
  db 0x2B, 0x07                               ; 02720  sub ax, word [bx]
  db 0xA0, 0x08, 0x1E                         ; 02722  mov al, byte [0x1e08]
  db 0x0A                                                         ; 02725  .

mem_entry:  ; 02726
  db 0x53                                     ; 02726  push bx
  db 0x51                                     ; 02727  push cx
  db 0x52                                     ; 02728  push dx
  db 0xBB, 0xF5, 0x06                         ; 02729  mov bx, 0x6f5
  db 0xB9, 0x15, 0x02                         ; 0272C  mov cx, 0x215
  call rtm_call_0x80_entry                     ; 0272F  0xE8, 0x61, 0x00
  db 0xFE, 0x06, 0xF4, 0x06                   ; 02732  inc byte [0x6f4]
  db 0x80, 0x3E, 0xF4, 0x06, 0x01             ; 02736  cmp byte [0x6f4], 1
  jne loc_0275C                                ; 0273B  0x75, 0x1F
  db 0xB9, 0x17, 0x02                         ; 0273D  mov cx, 0x217
  call rtm_call_0x80_entry                     ; 02740  0xE8, 0x50, 0x00
  db 0x5A                                     ; 02743  pop dx
  db 0x59                                     ; 02744  pop cx
  db 0x5B                                     ; 02745  pop bx
  db 0x8C, 0x16, 0x72, 0x06                   ; 02746  mov word [0x672], ss

mem_switch_stack:  ; 0274A
  db 0x89, 0x26, 0x70, 0x06                   ; 0274A  mov word [0x670], sp
  db 0x8C, 0xD8                               ; 0274E  mov ax, ds
  db 0x9C                                     ; 02750  pushf
  db 0x5D                                     ; 02751  pop bp
  db 0xFA                                     ; 02752  cli
  db 0x8E, 0xD0                               ; 02753  mov ss, ax
  db 0xBC, 0xF4, 0x06                         ; 02755  mov sp, 0x6f4
  db 0x55                                     ; 02758  push bp
  db 0x9D                                     ; 02759  popf
  jmp short loc_0275F                          ; 0275A  0xEB, 0x03

loc_0275C:  ; 0275C
  db 0x5A                                     ; 0275C  pop dx
  db 0x59                                     ; 0275D  pop cx
  db 0x5B                                     ; 0275E  pop bx

loc_0275F:  ; 0275F
  db 0xB5, 0x00                               ; 0275F  mov ch, 0
  db 0xD1, 0xE1                               ; 02761  shl cx, 1
  db 0x8B, 0xF1                               ; 02763  mov si, cx
  db 0x2E, 0xFF, 0x94, 0x4C, 0x00             ; 02765  call word [cs:si + 0x4c]
  db 0xFE, 0x0E, 0xF4, 0x06                   ; 0276A  dec byte [0x6f4]
  jne mem_exit                                 ; 0276E  0x75, 0x20
  db 0x9C                                     ; 02770  pushf
  db 0x58                                     ; 02771  pop ax
  db 0xFA                                     ; 02772  cli

mem_restore_stack:  ; 02773
  db 0x8E, 0x16, 0x72, 0x06                   ; 02773  mov ss, word [0x672]
  db 0x8B, 0x26, 0x70, 0x06                   ; 02777  mov sp, word [0x670]
  db 0x50                                     ; 0277B  push ax
  db 0x9D                                     ; 0277C  popf
  db 0x53                                     ; 0277D  push bx
  db 0x51                                     ; 0277E  push cx
  db 0xBB, 0xF5, 0x06                         ; 0277F  mov bx, 0x6f5
  db 0xB9, 0x16, 0x02                         ; 02782  mov cx, 0x216
  call rtm_call_0x80_entry                     ; 02785  0xE8, 0x0B, 0x00
  db 0xB9, 0x18, 0x02                         ; 02788  mov cx, 0x218
  call rtm_call_0x80_entry                     ; 0278B  0xE8, 0x05, 0x00
  db 0x59                                     ; 0278E  pop cx
  db 0x5B                                     ; 0278F  pop bx

mem_exit:  ; 02790
  db 0x8B, 0xC3                               ; 02790  mov ax, bx
  db 0xCB                                     ; 02792  retf

rtm_call_0x80_entry:  ; 02793
  db 0x2E, 0xFF, 0x1E, 0x08, 0x00             ; 02793  call far [cs:8]
  db 0xC3                                     ; 02798  ret
  db 0xFF, 0x1E, 0x28, 0x00                   ; 02799  call far [0x28]
  db 0xC3                                     ; 0279D  ret

mem_fn00_maxmem:  ; 0279E
  db 0x8B, 0xF2                               ; 0279E  mov si, dx
  db 0x1E                                     ; 027A0  push ds
  db 0x26, 0x8E, 0x1E, 0x2E, 0x00             ; 027A1  mov ds, word [es:0x2e]
  db 0x8B, 0x54, 0x02                         ; 027A6  mov dx, word [si + 2]
  db 0x1F                                     ; 027A9  pop ds
  db 0x2B, 0xC0                               ; 027AA  sub ax, ax
  db 0x8B, 0xD8                               ; 027AC  mov bx, ax
  call io_const_rtm_helper                     ; 027AE  0xE8, 0xB2, 0x00
  jcxz loc_027B7                               ; 027B1  0xE3, 0x04
  db 0xBB, 0xFF, 0xFF                         ; 027B3  mov bx, 0xffff
  db 0xC3                                     ; 027B6  ret

loc_027B7:  ; 027B7
  db 0x1E                                     ; 027B7  push ds
  db 0x26, 0x8E, 0x1E, 0x2E, 0x00             ; 027B8  mov ds, word [es:0x2e]
  db 0x89, 0x54, 0x02                         ; 027BD  mov word [si + 2], dx
  db 0x89, 0x04                               ; 027C0  mov word [si], ax
  db 0xC6, 0x44, 0x04, 0x01                   ; 027C2  mov byte [si + 4], 1
  db 0x1F                                     ; 027C6  pop ds
  db 0x2B, 0xDB                               ; 027C7  sub bx, bx
  db 0xC3                                     ; 027C9  ret

mem_fn01_absmax:  ; 027CA
  db 0x8B, 0xF2                               ; 027CA  mov si, dx
  db 0x1E                                     ; 027CC  push ds
  db 0x26, 0x8E, 0x1E, 0x2E, 0x00             ; 027CD  mov ds, word [es:0x2e]
  db 0x8B, 0x04                               ; 027D2  mov ax, word [si]
  db 0x8B, 0x54, 0x02                         ; 027D4  mov dx, word [si + 2]
  db 0x1F                                     ; 027D7  pop ds
  db 0x2B, 0xDB                               ; 027D8  sub bx, bx
  call io_const_rtm_helper                     ; 027DA  0xE8, 0x86, 0x00
  jcxz loc_027E3                               ; 027DD  0xE3, 0x04
  db 0xBB, 0xFF, 0xFF                         ; 027DF  mov bx, 0xffff
  db 0xC3                                     ; 027E2  ret

loc_027E3:  ; 027E3
  db 0x1E                                     ; 027E3  push ds
  db 0x26, 0x8E, 0x1E, 0x2E, 0x00             ; 027E4  mov ds, word [es:0x2e]
  db 0x89, 0x54, 0x02                         ; 027E9  mov word [si + 2], dx
  db 0x89, 0x04                               ; 027EC  mov word [si], ax
  db 0x1F                                     ; 027EE  pop ds
  db 0x2B, 0xDB                               ; 027EF  sub bx, bx
  db 0xC3                                     ; 027F1  ret

mem_fn02_cpmalloc:  ; 027F2
  db 0x8B, 0xF2                               ; 027F2  mov si, dx
  db 0x1E                                     ; 027F4  push ds
  db 0x26, 0x8E, 0x1E, 0x2E, 0x00             ; 027F5  mov ds, word [es:0x2e]
  db 0x2B, 0xC0                               ; 027FA  sub ax, ax
  db 0x8B, 0x5C, 0x02                         ; 027FC  mov bx, word [si + 2]
  db 0x8B, 0xD3                               ; 027FF  mov dx, bx
  db 0x1F                                     ; 02801  pop ds
  call io_const_rtm_helper                     ; 02802  0xE8, 0x5E, 0x00
  jcxz loc_0280B                               ; 02805  0xE3, 0x04
  db 0xBB, 0xFF, 0xFF                         ; 02807  mov bx, 0xffff
  db 0xC3                                     ; 0280A  ret

loc_0280B:  ; 0280B
  db 0x1E                                     ; 0280B  push ds
  db 0x26, 0x8E, 0x1E, 0x2E, 0x00             ; 0280C  mov ds, word [es:0x2e]
  db 0x89, 0x54, 0x02                         ; 02811  mov word [si + 2], dx
  db 0x89, 0x04                               ; 02814  mov word [si], ax
  db 0x1F                                     ; 02816  pop ds
  db 0x2B, 0xDB                               ; 02817  sub bx, bx
  db 0xC3                                     ; 02819  ret

mem_fn03_cpmabsa:  ; 0281A
  db 0x8B, 0xF2                               ; 0281A  mov si, dx
  db 0x1E                                     ; 0281C  push ds
  db 0x26, 0x8E, 0x1E, 0x2E, 0x00             ; 0281D  mov ds, word [es:0x2e]
  db 0x8B, 0x04                               ; 02822  mov ax, word [si]
  db 0x8B, 0x5C, 0x02                         ; 02824  mov bx, word [si + 2]
  db 0x8B, 0xD3                               ; 02827  mov dx, bx
  db 0x1F                                     ; 02829  pop ds
  db 0x33, 0xC9                               ; 0282A  xor cx, cx

io_const:  ; 0282C
  db 0x8B, 0x3E, 0x68, 0x00                   ; 0282C  mov di, word [0x68]
  db 0x83, 0xC7, 0x16                         ; 02830  add di, 0x16

loc_02833:  ; 02833
  db 0x8B, 0x3D                               ; 02833  mov di, word [di]
  db 0x83, 0xFF, 0x00                         ; 02835  cmp di, 0
  je loc_0284B                                 ; 02838  0x74, 0x11
  db 0x39, 0x45, 0x02                         ; 0283A  cmp word [di + 2], ax
  jne loc_02833                                ; 0283D  0x75, 0xF4
  db 0x39, 0x5D, 0x04                         ; 0283F  cmp word [di + 4], bx
  jbe loc_02854                                ; 02842  0x76, 0x10
  db 0xB9, 0x03, 0x00                         ; 02844  mov cx, 3
  db 0xBB, 0xFF, 0xFF                         ; 02847  mov bx, 0xffff
  db 0xC3                                     ; 0284A  ret

loc_0284B:  ; 0284B
  call io_const_rtm_helper                     ; 0284B  0xE8, 0x15, 0x00
  jcxz loc_02854                               ; 0284E  0xE3, 0x04
  db 0xBB, 0xFF, 0xFF                         ; 02850  mov bx, 0xffff
  db 0xC3                                     ; 02853  ret

loc_02854:  ; 02854
  db 0x1E                                     ; 02854  push ds
  db 0x26, 0x8E, 0x1E, 0x2E, 0x00             ; 02855  mov ds, word [es:0x2e]
  db 0x89, 0x54, 0x02                         ; 0285A  mov word [si + 2], dx
  db 0x89, 0x04                               ; 0285D  mov word [si], ax
  db 0x1F                                     ; 0285F  pop ds
  db 0x2B, 0xDB                               ; 02860  sub bx, bx
  db 0xC3                                     ; 02862  ret

io_const_rtm_helper:  ; 02863
  db 0x56                                     ; 02863  push si
  db 0x2B, 0xC9                               ; 02864  sub cx, cx
  db 0x51                                     ; 02866  push cx
  db 0x51                                     ; 02867  push cx
  db 0x52                                     ; 02868  push dx
  db 0x53                                     ; 02869  push bx
  db 0x50                                     ; 0286A  push ax
  db 0x8B, 0xD4                               ; 0286B  mov dx, sp
  db 0x1E                                     ; 0286D  push ds
  db 0x8C, 0xD1                               ; 0286E  mov cx, ss
  db 0x8E, 0xD9                               ; 02870  mov ds, cx
  db 0xB9, 0x80, 0x00                         ; 02872  mov cx, 0x80
  call rtm_call_0x80_entry                     ; 02875  0xE8, 0x1B, 0xFF
  db 0x1F                                     ; 02878  pop ds
  db 0x58                                     ; 02879  pop ax
  db 0x5A                                     ; 0287A  pop dx
  db 0x5B                                     ; 0287B  pop bx
  db 0x5B                                     ; 0287C  pop bx
  db 0x5B                                     ; 0287D  pop bx
  db 0x5E                                     ; 0287E  pop si
  db 0xC3                                     ; 0287F  ret

mem_fn04_cpmfree:  ; 02880
  db 0x1E                                     ; 02880  push ds
  db 0x26, 0x8E, 0x1E, 0x2E, 0x00             ; 02881  mov ds, word [es:0x2e]
  db 0x8B, 0xF2                               ; 02886  mov si, dx
  db 0x8A, 0x44, 0x04                         ; 02888  mov al, byte [si + 4]
  db 0x8B, 0x14                               ; 0288B  mov dx, word [si]
  db 0x1F                                     ; 0288D  pop ds
  db 0x3C, 0xFF                               ; 0288E  cmp al, 0xff
  jne mem_free_memory                                ; 02890  0x75, 0x2A

loc_02892:  ; 02892
  db 0x8B, 0x1E, 0x68, 0x00                   ; 02892  mov bx, word [0x68]
  db 0x83, 0xC3, 0x16                         ; 02896  add bx, 0x16

loc_02899:  ; 02899
  db 0x8B, 0x37                               ; 02899  mov si, word [bx]
  db 0x83, 0xFE, 0x00                         ; 0289B  cmp si, 0
  jne loc_028A5                                ; 0289E  0x75, 0x05
  db 0x2B, 0xDB                               ; 028A0  sub bx, bx
  db 0x8B, 0xCB                               ; 028A2  mov cx, bx
  db 0xC3                                     ; 028A4  ret

loc_028A5:  ; 028A5
  db 0xF7, 0x44, 0x06, 0x01, 0x00             ; 028A5  test word [si + 6], 1
  je loc_028B0                                 ; 028AA  0x74, 0x04
  db 0x8B, 0xDE                               ; 028AC  mov bx, si
  jmp short loc_02899                          ; 028AE  0xEB, 0xE9

loc_028B0:  ; 028B0
  db 0x8B, 0x54, 0x02                         ; 028B0  mov dx, word [si + 2]
  db 0x56                                     ; 028B3  push si
  call mem_free_memory                               ; 028B4  0xE8, 0x05, 0x00
  db 0x5E                                     ; 028B7  pop si
  jcxz loc_02892                               ; 028B8  0xE3, 0xD8
  jmp short loc_02899                          ; 028BA  0xEB, 0xDD

mem_free_memory:  ; 028BC
  db 0x1E                                     ; 028BC  push ds
  db 0x16                                     ; 028BD  push ss
  db 0x1F                                     ; 028BE  pop ds
  db 0x2B, 0xC9                               ; 028BF  sub cx, cx
  db 0x51                                     ; 028C1  push cx
  db 0x52                                     ; 028C2  push dx
  db 0x8B, 0xD4                               ; 028C3  mov dx, sp
  db 0xB9, 0x82, 0x00                         ; 028C5  mov cx, 0x82
  call rtm_call_0x80_entry                     ; 028C8  0xE8, 0xC8, 0xFE
  db 0x5A                                     ; 028CB  pop dx
  db 0x5A                                     ; 028CC  pop dx
  db 0x1F                                     ; 028CD  pop ds
  db 0xC3                                     ; 028CE  ret

mem_fn05_freeall:  ; 028CF
  db 0x8B, 0x36, 0x68, 0x00                   ; 028CF  mov si, word [0x68]
  db 0x8B, 0x44, 0x10                         ; 028D3  mov ax, word p_uda[si]
  db 0x83, 0xC6, 0x16                         ; 028D6  add si, 0x16

loc_028D9:  ; 028D9
  db 0x8B, 0x34                               ; 028D9  mov si, word [si]
  db 0x83, 0xFE, 0x00                         ; 028DB  cmp si, 0
  je loc_02926                                 ; 028DE  0x74, 0x46
  db 0x8B, 0x5C, 0x02                         ; 028E0  mov bx, word [si + 2]
  db 0x3B, 0xD8                               ; 028E3  cmp bx, ax
  ja loc_0291F                                 ; 028E5  0x77, 0x38
  db 0x8B, 0xCB                               ; 028E7  mov cx, bx
  db 0x03, 0x4C, 0x04                         ; 028E9  add cx, word [si + 4]
  db 0x3B, 0xC8                               ; 028EC  cmp cx, ax
  jb loc_0291F                                 ; 028EE  0x72, 0x2F
  db 0xF7, 0x44, 0x06, 0x40, 0x00             ; 028F0  test word [si + 6], 0x40
  jne loc_028D9                                ; 028F5  0x75, 0xE2
  db 0x81, 0x4C, 0x06, 0x40, 0x00             ; 028F7  or word [si + 6], 0x40
  db 0x8B, 0x1E, 0x68, 0x00                   ; 028FC  mov bx, word [0x68]
  db 0xF7, 0x47, 0x06, 0x00, 0x80             ; 02900  test word [bx + 6], 0x8000
  je loc_0290D                                 ; 02905  0x74, 0x06
  db 0x05, 0x1C, 0x00                         ; 02907  add ax, 0x1c
  jmp near loc_0291D                           ; 0290A  0xE9, 0x10, 0x00

loc_0290D:  ; 0290D
  db 0xF7, 0x47, 0x26, 0x02, 0x00             ; 0290D  test word p_sflag[bx], 2
  je loc_0291A                                 ; 02912  0x74, 0x06
  db 0x05, 0x1A, 0x00                         ; 02914  add ax, 0x1a
  jmp near loc_0291D                           ; 02917  0xE9, 0x03, 0x00

loc_0291A:  ; 0291A
  db 0x05, 0x16, 0x00                         ; 0291A  add ax, 0x16

loc_0291D:  ; 0291D
  db 0x8B, 0xD8                               ; 0291D  mov bx, ax

loc_0291F:  ; 0291F
  db 0x8B, 0xD3                               ; 0291F  mov dx, bx
  call mem_free_memory                               ; 02921  0xE8, 0x98, 0xFF
  jmp short mem_fn05_freeall                   ; 02924  0xEB, 0xA9

loc_02926:  ; 02926
  db 0x33, 0xDB                               ; 02926  xor bx, bx
  db 0x8B, 0xCB                               ; 02928  mov cx, bx
  db 0xC3                                     ; 0292A  ret

mem_fn06_malloc:  ; 0292B
  db 0x52                                     ; 0292B  push dx
  call mem_getmd                               ; 0292C  0xE8, 0xF6, 0x07
  db 0x5A                                     ; 0292F  pop dx
  jcxz loc_02936                               ; 02930  0xE3, 0x04
  db 0xBB, 0xFF, 0xFF                         ; 02932  mov bx, 0xffff
  db 0xC3                                     ; 02935  ret

loc_02936:  ; 02936
  db 0x06                                     ; 02936  push es
  db 0x26, 0x8E, 0x06, 0x2E, 0x00             ; 02937  mov es, word [es:0x2e]
  db 0x8B, 0xFA                               ; 0293C  mov di, dx
  db 0x26, 0x8B, 0x45, 0x06                   ; 0293E  mov ax, word [es:di + 6]
  db 0x3D, 0x00, 0x00                         ; 02942  cmp ax, 0
  jne loc_0294E                                ; 02945  0x75, 0x07
  db 0xA1, 0x68, 0x00                         ; 02947  mov ax, word [0x68]
  db 0x26, 0x89, 0x45, 0x06                   ; 0294A  mov word [es:di + 6], ax

loc_0294E:  ; 0294E
  db 0x07                                     ; 0294E  pop es
  db 0x3B, 0x06, 0x68, 0x00                   ; 0294F  cmp ax, word [0x68]
  je loc_0299D                                 ; 02953  0x74, 0x48
  db 0x50                                     ; 02955  push ax
  db 0x53                                     ; 02956  push bx
  db 0x52                                     ; 02957  push dx
  db 0x57                                     ; 02958  push di
  db 0xBB, 0x0D, 0x07                         ; 02959  mov bx, 0x70d
  db 0xB9, 0x15, 0x02                         ; 0295C  mov cx, 0x215
  call rtm_call_0x80_entry                     ; 0295F  0xE8, 0x31, 0xFE
  db 0x5F                                     ; 02962  pop di
  db 0x5A                                     ; 02963  pop dx
  db 0x5B                                     ; 02964  pop bx
  db 0x58                                     ; 02965  pop ax
  db 0xBE, 0x70, 0x00                         ; 02966  mov si, 0x70

loc_02969:  ; 02969
  db 0x8B, 0x74, 0x02                         ; 02969  mov si, word [si + 2]
  db 0x83, 0xFE, 0x00                         ; 0296C  cmp si, 0
  je loc_0298C                                 ; 0296F  0x74, 0x1B
  db 0x3B, 0xF0                               ; 02971  cmp si, ax
  jne loc_02969                                ; 02973  0x75, 0xF4
  db 0x3B, 0x36, 0x68, 0x00                   ; 02975  cmp si, word [0x68]
  je loc_0298C                                 ; 02979  0x74, 0x11
  db 0xB9, 0x22, 0x00                         ; 0297B  mov cx, 0x22
  db 0x53                                     ; 0297E  push bx
  db 0xBB, 0x0D, 0x07                         ; 0297F  mov bx, 0x70d
  db 0xB9, 0x16, 0x02                         ; 02982  mov cx, 0x216
  call rtm_call_0x80_entry                     ; 02985  0xE8, 0x0B, 0xFE
  db 0x5B                                     ; 02988  pop bx
  jmp near loc_029D4                           ; 02989  0xE9, 0x48, 0x00

loc_0298C:  ; 0298C
  db 0x50                                     ; 0298C  push ax
  db 0x53                                     ; 0298D  push bx
  db 0x52                                     ; 0298E  push dx
  db 0x57                                     ; 0298F  push di
  db 0xBB, 0x0D, 0x07                         ; 02990  mov bx, 0x70d
  db 0xB9, 0x16, 0x02                         ; 02993  mov cx, 0x216
  call rtm_call_0x80_entry                     ; 02996  0xE8, 0xFA, 0xFD
  db 0x5F                                     ; 02999  pop di
  db 0x5A                                     ; 0299A  pop dx
  db 0x5B                                     ; 0299B  pop bx
  db 0x58                                     ; 0299C  pop ax

loc_0299D:  ; 0299D
  db 0x06                                     ; 0299D  push es
  db 0x26, 0x8E, 0x06, 0x2E, 0x00             ; 0299E  mov es, word [es:0x2e]
  db 0x26, 0x8B, 0x4D, 0x02                   ; 029A3  mov cx, word [es:di + 2]
  db 0x26, 0x3B, 0x4D, 0x04                   ; 029A7  cmp cx, word [es:di + 4]
  jbe loc_029B1                                ; 029AB  0x76, 0x04
  db 0x26, 0x89, 0x4D, 0x04                   ; 029AD  mov word [es:di + 4], cx

loc_029B1:  ; 029B1
  db 0x8B, 0xF0                               ; 029B1  mov si, ax
  db 0x83, 0xC6, 0x16                         ; 029B3  add si, 0x16
  db 0x2B, 0xC9                               ; 029B6  sub cx, cx
  db 0x56                                     ; 029B8  push si

loc_029B9:  ; 029B9
  db 0x8B, 0x34                               ; 029B9  mov si, word [si]
  db 0x83, 0xFE, 0x00                         ; 029BB  cmp si, 0
  je loc_029C5                                 ; 029BE  0x74, 0x05
  db 0x03, 0x4C, 0x04                         ; 029C0  add cx, word [si + 4]
  jmp short loc_029B9                          ; 029C3  0xEB, 0xF4

loc_029C5:  ; 029C5
  db 0x5E                                     ; 029C5  pop si
  db 0xA1, 0x4C, 0x00                         ; 029C6  mov ax, word [0x4c]
  db 0x2B, 0xC1                               ; 029C9  sub ax, cx
  db 0x3D, 0x00, 0x00                         ; 029CB  cmp ax, 0
  jne loc_029DB                                ; 029CE  0x75, 0x0B

loc_029D0:  ; 029D0
  db 0x07                                     ; 029D0  pop es

loc_029D1:  ; 029D1
  db 0xB9, 0x03, 0x00                         ; 029D1  mov cx, 3

loc_029D4:  ; 029D4
  call mem_freemd                               ; 029D4  0xE8, 0x71, 0x07
  db 0xBB, 0xFF, 0xFF                         ; 029D7  mov bx, 0xffff
  db 0xC3                                     ; 029DA  ret

loc_029DB:  ; 029DB
  db 0x26, 0x3B, 0x45, 0x02                   ; 029DB  cmp ax, word [es:di + 2]
  jb loc_029D0                                 ; 029DF  0x72, 0xEF
  db 0x26, 0x3B, 0x45, 0x04                   ; 029E1  cmp ax, word [es:di + 4]
  jae loc_029EB                                ; 029E5  0x73, 0x04
  db 0x26, 0x89, 0x45, 0x04                   ; 029E7  mov word [es:di + 4], ax

loc_029EB:  ; 029EB
  db 0x57                                     ; 029EB  push di
  db 0xBF, 0x5A, 0x06                         ; 029EC  mov di, 0x65a
  db 0xB9, 0x0B, 0x00                         ; 029EF  mov cx, 0xb
  db 0x2B, 0xC0                               ; 029F2  sub ax, ax
  db 0x2E, 0x8E, 0x06, 0x06, 0x00             ; 029F4  mov es, word [cs:6]
  db 0xF3, 0xAB                               ; 029F9  rep stosw
  db 0x5F                                     ; 029FB  pop di
  db 0x2B, 0xC9                               ; 029FC  sub cx, cx
  db 0x07                                     ; 029FE  pop es

loc_029FF:  ; 029FF
  db 0x8B, 0x34                               ; 029FF  mov si, word [si]
  db 0x83, 0xFE, 0x00                         ; 02A01  cmp si, 0
  je loc_02A21                                 ; 02A04  0x74, 0x1B
  db 0x3B, 0x4C, 0x08                         ; 02A06  cmp cx, word [si + 8]
  je loc_029FF                                 ; 02A09  0x74, 0xF4
  db 0x51                                     ; 02A0B  push cx
  db 0x52                                     ; 02A0C  push dx
  db 0x53                                     ; 02A0D  push bx
  db 0x56                                     ; 02A0E  push si
  db 0x8B, 0x5C, 0x08                         ; 02A0F  mov bx, word [si + 8]
  call mem_try_mau                               ; 02A12  0xE8, 0xCB, 0x00
  db 0x5E                                     ; 02A15  pop si
  db 0x5B                                     ; 02A16  pop bx
  db 0x5A                                     ; 02A17  pop dx
  db 0x83, 0xF9, 0x00                         ; 02A18  cmp cx, 0
  db 0x59                                     ; 02A1B  pop cx
  jne loc_029FF                                ; 02A1C  0x75, 0xE1
  jmp near loc_02A50                           ; 02A1E  0xE9, 0x2F, 0x00

loc_02A21:  ; 02A21
  db 0x53                                     ; 02A21  push bx
  db 0x52                                     ; 02A22  push dx
  db 0x26, 0x8E, 0x1E, 0x2E, 0x00             ; 02A23  mov ds, word [es:0x2e]
  db 0xBB, 0x5A, 0x00                         ; 02A28  mov bx, 0x5a
  db 0xB9, 0x0B, 0x03                         ; 02A2B  mov cx, 0x30b
  call rtm_call_0x80_entry                     ; 02A2E  0xE8, 0x62, 0xFD
  db 0x2E, 0x8E, 0x1E, 0x06, 0x00             ; 02A31  mov ds, word [cs:6]
  jcxz loc_02A3D                               ; 02A36  0xE3, 0x05
  db 0x5A                                     ; 02A38  pop dx
  db 0x5B                                     ; 02A39  pop bx
  jmp near loc_02A50                           ; 02A3A  0xE9, 0x13, 0x00

loc_02A3D:  ; 02A3D
  db 0x8B, 0x36, 0x76, 0x00                   ; 02A3D  mov si, word [0x76]
  db 0x89, 0x37                               ; 02A41  mov word [bx], si
  db 0x89, 0x1E, 0x76, 0x00                   ; 02A43  mov word [0x76], bx
  db 0x5A                                     ; 02A47  pop dx
  db 0x52                                     ; 02A48  push dx
  db 0x2B, 0xF6                               ; 02A49  sub si, si
  call mem_try_mau                               ; 02A4B  0xE8, 0x92, 0x00
  db 0x5A                                     ; 02A4E  pop dx
  db 0x5B                                     ; 02A4F  pop bx

loc_02A50:  ; 02A50
  db 0x83, 0x3E, 0x5A, 0x06, 0x00             ; 02A50  cmp word [0x65a], 0
  jne loc_02A97                                ; 02A55  0x75, 0x40
  db 0x9C                                     ; 02A57  pushf
  db 0xFA                                     ; 02A58  cli
  db 0x8B, 0x3E, 0x70, 0x00                   ; 02A59  mov di, word [0x70]
  db 0x83, 0xFF, 0x00                         ; 02A5D  cmp di, 0
  jne loc_02A66                                ; 02A60  0x75, 0x04
  db 0x9D                                     ; 02A62  popf
  jmp near loc_029D1                           ; 02A63  0xE9, 0x6B, 0xFF

loc_02A66:  ; 02A66
  db 0x8B, 0x45, 0x02                         ; 02A66  mov ax, word [di + 2]
  db 0xA3, 0x70, 0x00                         ; 02A69  mov word [0x70], ax
  db 0x9D                                     ; 02A6C  popf
  db 0x53                                     ; 02A6D  push bx
  db 0x52                                     ; 02A6E  push dx
  db 0x8B, 0x5D, 0x16                         ; 02A6F  mov bx, word p_mem[di]
  db 0x57                                     ; 02A72  push di
  db 0x1E                                     ; 02A73  push ds
  db 0x57                                     ; 02A74  push di
  db 0xFF, 0x77, 0x02                         ; 02A75  push word [bx + 2]
  db 0x16                                     ; 02A78  push ss
  db 0x1F                                     ; 02A79  pop ds
  db 0x8B, 0xD4                               ; 02A7A  mov dx, sp
  db 0xB9, 0x82, 0x00                         ; 02A7C  mov cx, 0x82
  call rtm_call_0x80_entry                     ; 02A7F  0xE8, 0x11, 0xFD
  db 0x58                                     ; 02A82  pop ax
  db 0x58                                     ; 02A83  pop ax
  db 0x1F                                     ; 02A84  pop ds
  db 0x5F                                     ; 02A85  pop di
  db 0x9C                                     ; 02A86  pushf
  db 0xFA                                     ; 02A87  cli
  db 0xA1, 0x5C, 0x00                         ; 02A88  mov ax, word [0x5c]
  db 0x89, 0x05                               ; 02A8B  mov word [di], ax
  db 0x89, 0x3E, 0x5C, 0x00                   ; 02A8D  mov word [0x5c], di
  db 0x9D                                     ; 02A91  popf
  db 0x5A                                     ; 02A92  pop dx
  db 0x5B                                     ; 02A93  pop bx
  jmp near loc_02A21                           ; 02A94  0xE9, 0x8A, 0xFF

loc_02A97:  ; 02A97
  db 0x06                                     ; 02A97  push es
  db 0x26, 0x8E, 0x06, 0x2E, 0x00             ; 02A98  mov es, word [es:0x2e]
  db 0x8B, 0xFA                               ; 02A9D  mov di, dx
  db 0xA1, 0x5A, 0x06                         ; 02A9F  mov ax, word [0x65a]
  db 0x26, 0x89, 0x05                         ; 02AA2  mov word [es:di], ax
  db 0x89, 0x47, 0x02                         ; 02AA5  mov word [bx + 2], ax
  db 0xA1, 0x5C, 0x06                         ; 02AA8  mov ax, word [0x65c]
  db 0x26, 0x89, 0x45, 0x02                   ; 02AAB  mov word [es:di + 2], ax
  db 0x26, 0x89, 0x45, 0x04                   ; 02AAF  mov word [es:di + 4], ax
  db 0x89, 0x47, 0x04                         ; 02AB3  mov word [bx + 4], ax
  db 0x26, 0x8B, 0x45, 0x08                   ; 02AB6  mov ax, word [es:di + 8]
  db 0x89, 0x47, 0x06                         ; 02ABA  mov word [bx + 6], ax
  db 0x8B, 0x36, 0x5E, 0x06                   ; 02ABD  mov si, word [0x65e]
  db 0x83, 0xFE, 0x00                         ; 02AC1  cmp si, 0
  jne loc_02ACD                                ; 02AC4  0x75, 0x07
  db 0x26, 0x8B, 0x75, 0x06                   ; 02AC6  mov si, word [es:di + 6]
  db 0x83, 0xC6, 0x16                         ; 02ACA  add si, 0x16

loc_02ACD:  ; 02ACD
  db 0x8B, 0x04                               ; 02ACD  mov ax, word [si]
  db 0x89, 0x07                               ; 02ACF  mov word [bx], ax
  db 0x89, 0x1C                               ; 02AD1  mov word [si], bx
  db 0x8B, 0x3E, 0x60, 0x06                   ; 02AD3  mov di, word [0x660]
  db 0x89, 0x7F, 0x08                         ; 02AD7  mov word [bx + 8], di
  db 0x07                                     ; 02ADA  pop es
  db 0x2B, 0xC9                               ; 02ADB  sub cx, cx
  db 0x8B, 0xD9                               ; 02ADD  mov bx, cx
  db 0xC3                                     ; 02ADF  ret

mem_try_mau:  ; 02AE0
  db 0x89, 0x36, 0x64, 0x06                   ; 02AE0  mov word [0x664], si
  db 0x89, 0x1E, 0x62, 0x06                   ; 02AE4  mov word [0x662], bx
  db 0x52                                     ; 02AE8  push dx
  db 0x1E                                     ; 02AE9  push ds
  db 0x06                                     ; 02AEA  push es
  db 0x26, 0x8E, 0x1E, 0x2E, 0x00             ; 02AEB  mov ds, word [es:0x2e]
  db 0x2E, 0x8E, 0x06, 0x06, 0x00             ; 02AF0  mov es, word [cs:6]
  db 0x8B, 0xF2                               ; 02AF5  mov si, dx
  db 0xBF, 0x66, 0x06                         ; 02AF7  mov di, 0x666
  db 0xB9, 0x05, 0x00                         ; 02AFA  mov cx, 5
  db 0xF3, 0xA5                               ; 02AFD  rep movsw
  db 0x07                                     ; 02AFF  pop es
  db 0x1F                                     ; 02B00  pop ds
  db 0xBA, 0x66, 0x06                         ; 02B01  mov dx, 0x666
  db 0xB9, 0x09, 0x03                         ; 02B04  mov cx, 0x309
  call rtm_call_0x80_entry                     ; 02B07  0xE8, 0x89, 0xFC
  db 0x5F                                     ; 02B0A  pop di
  jcxz loc_02B0E                               ; 02B0B  0xE3, 0x01
  db 0xC3                                     ; 02B0D  ret

loc_02B0E:  ; 02B0E
  db 0x06                                     ; 02B0E  push es
  db 0x26, 0x8E, 0x06, 0x2E, 0x00             ; 02B0F  mov es, word [es:0x2e]
  db 0xBE, 0x66, 0x06                         ; 02B14  mov si, 0x666
  db 0x8B, 0x44, 0x04                         ; 02B17  mov ax, word [si + 4]
  db 0x2B, 0xC9                               ; 02B1A  sub cx, cx
  db 0x26, 0x3B, 0x45, 0x04                   ; 02B1C  cmp ax, word [es:di + 4]
  db 0x07                                     ; 02B20  pop es
  je loc_02B32                                 ; 02B21  0x74, 0x0F
  db 0xB9, 0x03, 0x00                         ; 02B23  mov cx, 3
  db 0x8B, 0x1E, 0x62, 0x06                   ; 02B26  mov bx, word [0x662]
  db 0x8B, 0xFE                               ; 02B2A  mov di, si
  db 0x3B, 0x06, 0x5C, 0x06                   ; 02B2C  cmp ax, word [0x65c]
  jbe mem_take_scl                                ; 02B30  0x76, 0x25

loc_02B32:  ; 02B32
  db 0xBF, 0x5A, 0x06                         ; 02B32  mov di, 0x65a
  db 0x8B, 0x1E, 0x60, 0x06                   ; 02B35  mov bx, word [0x660]
  call mem_take_scl                               ; 02B39  0xE8, 0x1B, 0x00
  db 0xBE, 0x66, 0x06                         ; 02B3C  mov si, 0x666
  db 0x8B, 0x04                               ; 02B3F  mov ax, word [si]
  db 0xA3, 0x5A, 0x06                         ; 02B41  mov word [0x65a], ax
  db 0x8B, 0x44, 0x04                         ; 02B44  mov ax, word [si + 4]
  db 0xA3, 0x5C, 0x06                         ; 02B47  mov word [0x65c], ax
  db 0xA1, 0x62, 0x06                         ; 02B4A  mov ax, word [0x662]
  db 0xA3, 0x60, 0x06                         ; 02B4D  mov word [0x660], ax
  db 0xA1, 0x64, 0x06                         ; 02B50  mov ax, word [0x664]
  db 0xA3, 0x5E, 0x06                         ; 02B53  mov word [0x65e], ax

loc_02B56:  ; 02B56
  db 0xC3                                     ; 02B56  ret

mem_take_scl:  ; 02B57
  db 0x83, 0x3D, 0x00                         ; 02B57  cmp word [di], 0
  je loc_02B56                                 ; 02B5A  0x74, 0xFA
  db 0x51                                     ; 02B5C  push cx
  db 0x1E                                     ; 02B5D  push ds
  db 0xFF, 0x35                               ; 02B5E  push word [di]
  db 0xFF, 0x35                               ; 02B60  push word [di]
  db 0x53                                     ; 02B62  push bx
  db 0x16                                     ; 02B63  push ss
  db 0x1F                                     ; 02B64  pop ds
  db 0x8B, 0xD4                               ; 02B65  mov dx, sp
  db 0xB9, 0x0A, 0x03                         ; 02B67  mov cx, 0x30a
  call rtm_call_0x80_entry                     ; 02B6A  0xE8, 0x26, 0xFC
  db 0x83, 0xF9, 0x00                         ; 02B6D  cmp cx, 0
  jne loc_02B9B                                ; 02B70  0x75, 0x29
  db 0x83, 0xFB, 0xFF                         ; 02B72  cmp bx, -1
  jne loc_02B9B                                ; 02B75  0x75, 0x24
  db 0x5B                                     ; 02B77  pop bx
  db 0x58                                     ; 02B78  pop ax
  db 0x58                                     ; 02B79  pop ax
  db 0x1F                                     ; 02B7A  pop ds
  db 0x8B, 0xC3                               ; 02B7B  mov ax, bx
  db 0xBB, 0x76, 0x00                         ; 02B7D  mov bx, 0x76

loc_02B80:  ; 02B80
  db 0x8B, 0xF3                               ; 02B80  mov si, bx
  db 0x8B, 0x1C                               ; 02B82  mov bx, word [si]
  db 0x3B, 0xD8                               ; 02B84  cmp bx, ax
  jne loc_02B80                                ; 02B86  0x75, 0xF8
  db 0x50                                     ; 02B88  push ax
  db 0x8B, 0x07                               ; 02B89  mov ax, word [bx]
  db 0x89, 0x04                               ; 02B8B  mov word [si], ax
  db 0x5B                                     ; 02B8D  pop bx
  db 0xB9, 0x0C, 0x03                         ; 02B8E  mov cx, 0x30c
  db 0x8B, 0xD3                               ; 02B91  mov dx, bx
  db 0xBB, 0x5A, 0x00                         ; 02B93  mov bx, 0x5a
  call rtm_call_0x80_entry                     ; 02B96  0xE8, 0xFA, 0xFB
  db 0x59                                     ; 02B99  pop cx
  db 0xC3                                     ; 02B9A  ret

loc_02B9B:  ; 02B9B
  db 0x5B                                     ; 02B9B  pop bx
  db 0x58                                     ; 02B9C  pop ax
  db 0x58                                     ; 02B9D  pop ax
  db 0x1F                                     ; 02B9E  pop ds
  db 0x59                                     ; 02B9F  pop cx
  db 0xC3                                     ; 02BA0  ret

mem_fn07_mfree:  ; 02BA1
  db 0x06                                     ; 02BA1  push es
  db 0x26, 0x8E, 0x06, 0x2E, 0x00             ; 02BA2  mov es, word [es:0x2e]
  db 0x8B, 0xF2                               ; 02BA7  mov si, dx
  db 0x26, 0x8B, 0x5C, 0x02                   ; 02BA9  mov bx, word [es:si + 2]
  db 0x26, 0x8B, 0x14                         ; 02BAD  mov dx, word [es:si]
  db 0x07                                     ; 02BB0  pop es
  db 0x83, 0xFB, 0x00                         ; 02BB1  cmp bx, 0
  jne loc_02BBC                                ; 02BB4  0x75, 0x06
  db 0x8B, 0x1E, 0x68, 0x00                   ; 02BB6  mov bx, word [0x68]
  jmp short loc_02BFB                          ; 02BBA  0xEB, 0x3F

loc_02BBC:  ; 02BBC
  db 0x53                                     ; 02BBC  push bx
  db 0x52                                     ; 02BBD  push dx
  db 0xBB, 0x0D, 0x07                         ; 02BBE  mov bx, 0x70d
  db 0xB9, 0x15, 0x02                         ; 02BC1  mov cx, 0x215
  call rtm_call_0x80_entry                     ; 02BC4  0xE8, 0xCC, 0xFB
  db 0x5A                                     ; 02BC7  pop dx
  db 0x5B                                     ; 02BC8  pop bx
  db 0xBE, 0x70, 0x00                         ; 02BC9  mov si, 0x70

loc_02BCC:  ; 02BCC
  db 0x8B, 0x74, 0x02                         ; 02BCC  mov si, word [si + 2]
  db 0x83, 0xFE, 0x00                         ; 02BCF  cmp si, 0
  je loc_02BEE                                 ; 02BD2  0x74, 0x1A
  db 0x3B, 0xF3                               ; 02BD4  cmp si, bx
  jne loc_02BCC                                ; 02BD6  0x75, 0xF4
  db 0x3B, 0x36, 0x68, 0x00                   ; 02BD8  cmp si, word [0x68]
  je loc_02BEE                                 ; 02BDC  0x74, 0x10
  db 0xBB, 0x0D, 0x07                         ; 02BDE  mov bx, 0x70d
  db 0xB9, 0x16, 0x02                         ; 02BE1  mov cx, 0x216
  call rtm_call_0x80_entry                     ; 02BE4  0xE8, 0xAC, 0xFB
  db 0xBB, 0xFF, 0xFF                         ; 02BE7  mov bx, 0xffff
  db 0xB9, 0x22, 0x00                         ; 02BEA  mov cx, 0x22
  db 0xC3                                     ; 02BED  ret

loc_02BEE:  ; 02BEE
  db 0x53                                     ; 02BEE  push bx
  db 0x52                                     ; 02BEF  push dx
  db 0xBB, 0x0D, 0x07                         ; 02BF0  mov bx, 0x70d
  db 0xB9, 0x16, 0x02                         ; 02BF3  mov cx, 0x216
  call rtm_call_0x80_entry                     ; 02BF6  0xE8, 0x9A, 0xFB
  db 0x5A                                     ; 02BF9  pop dx
  db 0x5B                                     ; 02BFA  pop bx

loc_02BFB:  ; 02BFB
  db 0x8D, 0x77, 0x16                         ; 02BFB  lea si, p_mem[bx]

loc_02BFE:  ; 02BFE
  db 0x8B, 0xDE                               ; 02BFE  mov bx, si
  db 0x8B, 0x37                               ; 02C00  mov si, word [bx]
  db 0x83, 0xFE, 0x00                         ; 02C02  cmp si, 0
  je loc_02C29                                 ; 02C05  0x74, 0x22
  db 0x39, 0x54, 0x02                         ; 02C07  cmp word [si + 2], dx
  je mem_free_mau_call                                 ; 02C0A  0x74, 0x24
  ja loc_02BFE                                 ; 02C0C  0x77, 0xF0
  db 0x8B, 0x44, 0x02                         ; 02C0E  mov ax, word [si + 2]
  db 0x03, 0x44, 0x04                         ; 02C11  add ax, word [si + 4]
  db 0x3B, 0xC2                               ; 02C14  cmp ax, dx
  jbe loc_02BFE                                ; 02C16  0x76, 0xE6
  db 0x52                                     ; 02C18  push dx
  db 0x56                                     ; 02C19  push si
  call mem_free_mau_call                               ; 02C1A  0xE8, 0x13, 0x00
  db 0x5E                                     ; 02C1D  pop si
  db 0x5A                                     ; 02C1E  pop dx
  db 0x83, 0xF9, 0x00                         ; 02C1F  cmp cx, 0
  jne loc_02BFE                                ; 02C22  0x75, 0xDA

loc_02C24:  ; 02C24
  db 0x2B, 0xDB                               ; 02C24  sub bx, bx
  db 0x8B, 0xCB                               ; 02C26  mov cx, bx
  db 0xC3                                     ; 02C28  ret

loc_02C29:  ; 02C29
  db 0xBB, 0xFF, 0xFF                         ; 02C29  mov bx, 0xffff
  db 0xB9, 0x03, 0x00                         ; 02C2C  mov cx, 3
  db 0xC3                                     ; 02C2F  ret

mem_free_mau_call:  ; 02C30
  db 0x53                                     ; 02C30  push bx
  db 0x56                                     ; 02C31  push si
  db 0x52                                     ; 02C32  push dx
  db 0x52                                     ; 02C33  push dx
  db 0xFF, 0x74, 0x02                         ; 02C34  push word [si + 2]
  db 0xFF, 0x74, 0x08                         ; 02C37  push word [si + 8]
  db 0x8B, 0xD4                               ; 02C3A  mov dx, sp
  db 0x16                                     ; 02C3C  push ss
  db 0x1F                                     ; 02C3D  pop ds
  db 0xB9, 0x0A, 0x03                         ; 02C3E  mov cx, 0x30a
  call rtm_call_0x80_entry                     ; 02C41  0xE8, 0x4F, 0xFB
  db 0x8B, 0xEB                               ; 02C44  mov bp, bx
  db 0x2E, 0x8E, 0x1E, 0x06, 0x00             ; 02C46  mov ds, word [cs:6]
  db 0x58                                     ; 02C4B  pop ax
  db 0x58                                     ; 02C4C  pop ax
  db 0x58                                     ; 02C4D  pop ax
  db 0x5A                                     ; 02C4E  pop dx
  db 0x5E                                     ; 02C4F  pop si
  db 0x5B                                     ; 02C50  pop bx
  db 0x83, 0xF9, 0x00                         ; 02C51  cmp cx, 0
  jne loc_02C29                                ; 02C54  0x75, 0xD3
  db 0x3B, 0x54, 0x02                         ; 02C56  cmp dx, word [si + 2]
  je loc_02C63                                 ; 02C59  0x74, 0x08
  db 0x2B, 0x54, 0x02                         ; 02C5B  sub dx, word [si + 2]
  db 0x89, 0x54, 0x04                         ; 02C5E  mov word [si + 4], dx
  jmp short loc_02C24                          ; 02C61  0xEB, 0xC1

loc_02C63:  ; 02C63
  db 0x8B, 0x04                               ; 02C63  mov ax, word [si]
  db 0x89, 0x07                               ; 02C65  mov word [bx], ax
  db 0xFF, 0x74, 0x08                         ; 02C67  push word [si + 8]
  db 0x55                                     ; 02C6A  push bp
  db 0x8B, 0xDE                               ; 02C6B  mov bx, si
  call mem_freemd                               ; 02C6D  0xE8, 0xD8, 0x04
  db 0x5D                                     ; 02C70  pop bp
  db 0x5A                                     ; 02C71  pop dx
  db 0x83, 0xFD, 0x00                         ; 02C72  cmp bp, 0
  je loc_02C24                                 ; 02C75  0x74, 0xAD
  db 0xBF, 0x76, 0x00                         ; 02C77  mov di, 0x76

loc_02C7A:  ; 02C7A
  db 0x8B, 0xF7                               ; 02C7A  mov si, di
  db 0x8B, 0x3C                               ; 02C7C  mov di, word [si]
  db 0x3B, 0xFA                               ; 02C7E  cmp di, dx
  jne loc_02C7A                                ; 02C80  0x75, 0xF8
  db 0x8B, 0x05                               ; 02C82  mov ax, word [di]
  db 0x89, 0x04                               ; 02C84  mov word [si], ax
  db 0xC7, 0x05, 0x00, 0x00                   ; 02C86  mov word [di], 0
  db 0xBB, 0x5A, 0x00                         ; 02C8A  mov bx, 0x5a
  db 0xB9, 0x0C, 0x03                         ; 02C8D  mov cx, 0x30c
  jmp near rtm_call_0x80_entry                 ; 02C90  0xE9, 0x00, 0xFB

mem_fn08_share:  ; 02C93
  db 0x52                                     ; 02C93  push dx
  call mem_getmd                               ; 02C94  0xE8, 0x8E, 0x04
  db 0x5A                                     ; 02C97  pop dx
  jcxz loc_02C9D                               ; 02C98  0xE3, 0x03
  jmp near loc_02D31                           ; 02C9A  0xE9, 0x94, 0x00

loc_02C9D:  ; 02C9D
  db 0x8B, 0xEB                               ; 02C9D  mov bp, bx
  db 0x1E                                     ; 02C9F  push ds
  db 0x26, 0x8E, 0x1E, 0x2E, 0x00             ; 02CA0  mov ds, word [es:0x2e]
  db 0x8B, 0xFA                               ; 02CA5  mov di, dx
  db 0x8B, 0x1D                               ; 02CA7  mov bx, word [di]
  db 0x8B, 0x75, 0x02                         ; 02CA9  mov si, word [di + 2]
  db 0x8B, 0x55, 0x04                         ; 02CAC  mov dx, word [di + 4]
  db 0x1F                                     ; 02CAF  pop ds
  db 0x83, 0xFB, 0x00                         ; 02CB0  cmp bx, 0
  jne loc_02CB9                                ; 02CB3  0x75, 0x04
  db 0x8B, 0x1E, 0x68, 0x00                   ; 02CB5  mov bx, word [0x68]

loc_02CB9:  ; 02CB9
  db 0x83, 0xFE, 0x00                         ; 02CB9  cmp si, 0
  jne loc_02CC2                                ; 02CBC  0x75, 0x04
  db 0x8B, 0x36, 0x68, 0x00                   ; 02CBE  mov si, word [0x68]

loc_02CC2:  ; 02CC2
  db 0x3B, 0xF3                               ; 02CC2  cmp si, bx
  je loc_02D35                                 ; 02CC4  0x74, 0x6F
  db 0x8D, 0x7F, 0x16                         ; 02CC6  lea di, p_mem[bx]

loc_02CC9:  ; 02CC9
  db 0x8B, 0x3D                               ; 02CC9  mov di, word [di]
  db 0x83, 0xFF, 0x00                         ; 02CCB  cmp di, 0
  je loc_02D2E                                 ; 02CCE  0x74, 0x5E
  db 0x39, 0x55, 0x02                         ; 02CD0  cmp word [di + 2], dx
  jne loc_02CC9                                ; 02CD3  0x75, 0xF4
  db 0x8B, 0xDD                               ; 02CD5  mov bx, bp
  db 0x89, 0x57, 0x02                         ; 02CD7  mov word [bx + 2], dx
  db 0x8B, 0x45, 0x04                         ; 02CDA  mov ax, word [di + 4]
  db 0x89, 0x47, 0x04                         ; 02CDD  mov word [bx + 4], ax
  db 0x8B, 0x45, 0x06                         ; 02CE0  mov ax, word [di + 6]
  db 0x89, 0x47, 0x06                         ; 02CE3  mov word [bx + 6], ax
  db 0x8B, 0x45, 0x08                         ; 02CE6  mov ax, word [di + 8]
  db 0x89, 0x47, 0x08                         ; 02CE9  mov word [bx + 8], ax
  db 0x8B, 0xFB                               ; 02CEC  mov di, bx
  db 0x8B, 0xD8                               ; 02CEE  mov bx, ax
  db 0x1E                                     ; 02CF0  push ds
  db 0x8E, 0x5F, 0x02                         ; 02CF1  mov ds, word [bx + 2]
  db 0x2B, 0xDB                               ; 02CF4  sub bx, bx
  db 0x8A, 0x0E, 0x00, 0x00                   ; 02CF6  mov cl, byte [0]

loc_02CFA:  ; 02CFA
  db 0x80, 0xF9, 0x00                         ; 02CFA  cmp cl, 0
  je loc_02D28                                 ; 02CFD  0x74, 0x29
  db 0x83, 0xC3, 0x05                         ; 02CFF  add bx, 5
  db 0xFE, 0xC9                               ; 02D02  dec cl
  db 0x39, 0x17                               ; 02D04  cmp word [bx], dx
  jne loc_02CFA                                ; 02D06  0x75, 0xF2
  db 0xFE, 0x47, 0x04                         ; 02D08  inc byte [bx + 4]
  db 0x1F                                     ; 02D0B  pop ds
  db 0x8D, 0x5C, 0x16                         ; 02D0C  lea bx, p_mem[si]
  db 0x8B, 0x55, 0x08                         ; 02D0F  mov dx, word [di + 8]

loc_02D12:  ; 02D12
  db 0x8B, 0x37                               ; 02D12  mov si, word [bx]
  db 0x83, 0xFE, 0x00                         ; 02D14  cmp si, 0
  je loc_02D22                                 ; 02D17  0x74, 0x09
  db 0x3B, 0x54, 0x08                         ; 02D19  cmp dx, word [si + 8]
  je loc_02D22                                 ; 02D1C  0x74, 0x04
  db 0x8B, 0xDE                               ; 02D1E  mov bx, si
  jmp short loc_02D12                          ; 02D20  0xEB, 0xF0

loc_02D22:  ; 02D22
  db 0x89, 0x35                               ; 02D22  mov word [di], si
  db 0x89, 0x3F                               ; 02D24  mov word [bx], di
  jmp short loc_02D35                          ; 02D26  0xEB, 0x0D

loc_02D28:  ; 02D28
  db 0x1F                                     ; 02D28  pop ds
  db 0x8B, 0xDD                               ; 02D29  mov bx, bp
  call mem_freemd                               ; 02D2B  0xE8, 0x1A, 0x04

loc_02D2E:  ; 02D2E
  db 0xB9, 0x03, 0x00                         ; 02D2E  mov cx, 3

loc_02D31:  ; 02D31
  db 0xBB, 0xFF, 0xFF                         ; 02D31  mov bx, 0xffff
  db 0xC3                                     ; 02D34  ret

loc_02D35:  ; 02D35
  db 0x2B, 0xDB                               ; 02D35  sub bx, bx
  db 0x8B, 0xCB                               ; 02D37  mov cx, bx
  db 0xC3                                     ; 02D39  ret

mem_fn09_maualloc:  ; 02D3A
  db 0x06                                     ; 02D3A  push es
  db 0x26, 0x8E, 0x06, 0x2E, 0x00             ; 02D3B  mov es, word [es:0x2e]
  db 0x8B, 0xF2                               ; 02D40  mov si, dx
  db 0x26, 0x8B, 0x0C                         ; 02D42  mov cx, word [es:si]
  db 0x83, 0xF9, 0x00                         ; 02D45  cmp cx, 0
  je loc_02D58                                 ; 02D48  0x74, 0x0E
  db 0x8B, 0x47, 0x02                         ; 02D4A  mov ax, word [bx + 2]
  db 0x3B, 0xC8                               ; 02D4D  cmp cx, ax
  jb loc_02D97                                 ; 02D4F  0x72, 0x46
  db 0x03, 0x47, 0x04                         ; 02D51  add ax, word [bx + 4]
  db 0x3B, 0xC8                               ; 02D54  cmp cx, ax
  jae loc_02D97                                ; 02D56  0x73, 0x3F

loc_02D58:  ; 02D58
  db 0x8E, 0x5F, 0x02                         ; 02D58  mov ds, word [bx + 2]

loc_02D5B:  ; 02D5B
  db 0x2B, 0xDB                               ; 02D5B  sub bx, bx
  db 0x8A, 0xD3                               ; 02D5D  mov dl, bl

loc_02D5F:  ; 02D5F
  db 0xFE, 0xC2                               ; 02D5F  inc dl
  db 0x83, 0xC3, 0x05                         ; 02D61  add bx, 5
  db 0x3A, 0x16, 0x00, 0x00                   ; 02D64  cmp dl, byte [0]
  ja loc_02D97                                 ; 02D68  0x77, 0x2D
  db 0x83, 0x3F, 0x00                         ; 02D6A  cmp word [bx], 0
  je loc_02D97                                 ; 02D6D  0x74, 0x28
  db 0x80, 0x7F, 0x04, 0x00                   ; 02D6F  cmp byte [bx + 4], 0
  jne loc_02D5F                                ; 02D73  0x75, 0xEA
  db 0x26, 0x8B, 0x0C                         ; 02D75  mov cx, word [es:si]
  db 0x83, 0xF9, 0x00                         ; 02D78  cmp cx, 0
  je loc_02D9F                                 ; 02D7B  0x74, 0x22
  db 0x8B, 0x07                               ; 02D7D  mov ax, word [bx]
  db 0x3B, 0xC8                               ; 02D7F  cmp cx, ax
  jb loc_02D5F                                 ; 02D81  0x72, 0xDC
  db 0x03, 0x47, 0x02                         ; 02D83  add ax, word [bx + 2]
  db 0x3B, 0xC8                               ; 02D86  cmp cx, ax
  jae loc_02D5F                                ; 02D88  0x73, 0xD5
  db 0x3B, 0x0F                               ; 02D8A  cmp cx, word [bx]
  je loc_02D9F                                 ; 02D8C  0x74, 0x11
  db 0x2B, 0x0F                               ; 02D8E  sub cx, word [bx]
  db 0x56                                     ; 02D90  push si
  call mem_mau_split                               ; 02D91  0xE8, 0xB6, 0x00
  db 0x5E                                     ; 02D94  pop si
  jmp short loc_02D5B                          ; 02D95  0xEB, 0xC4

loc_02D97:  ; 02D97
  db 0xBB, 0xFF, 0xFF                         ; 02D97  mov bx, 0xffff
  db 0xB9, 0x03, 0x00                         ; 02D9A  mov cx, 3
  jmp short loc_02DE4                          ; 02D9D  0xEB, 0x45

loc_02D9F:  ; 02D9F
  db 0x26, 0x8B, 0x4C, 0x02                   ; 02D9F  mov cx, word [es:si + 2]
  db 0x8B, 0x47, 0x02                         ; 02DA3  mov ax, word [bx + 2]
  db 0x3B, 0xC8                               ; 02DA6  cmp cx, ax
  ja loc_02D5F                                 ; 02DA8  0x77, 0xB5
  db 0x26, 0x8B, 0x4C, 0x04                   ; 02DAA  mov cx, word [es:si + 4]
  db 0x3B, 0xC8                               ; 02DAE  cmp cx, ax
  jae loc_02DC8                                ; 02DB0  0x73, 0x16
  db 0x80, 0x7F, 0x04, 0x00                   ; 02DB2  cmp byte [bx + 4], 0
  je loc_02DC3                                 ; 02DB6  0x74, 0x0B
  db 0x26, 0x8B, 0x44, 0x08                   ; 02DB8  mov ax, word [es:si + 8]
  db 0x25, 0x02, 0x00                         ; 02DBC  and ax, 2
  je loc_02D5F                                 ; 02DBF  0x74, 0x9E
  jmp short loc_02DC8                          ; 02DC1  0xEB, 0x05

loc_02DC3:  ; 02DC3
  db 0x56                                     ; 02DC3  push si
  call mem_mau_split                               ; 02DC4  0xE8, 0x83, 0x00
  db 0x5E                                     ; 02DC7  pop si

loc_02DC8:  ; 02DC8
  db 0x8B, 0x47, 0x02                         ; 02DC8  mov ax, word [bx + 2]
  db 0x26, 0x89, 0x44, 0x02                   ; 02DCB  mov word [es:si + 2], ax
  db 0x26, 0x89, 0x44, 0x04                   ; 02DCF  mov word [es:si + 4], ax
  db 0x8B, 0x07                               ; 02DD3  mov ax, word [bx]
  db 0x26, 0x89, 0x04                         ; 02DD5  mov word [es:si], ax
  db 0xFE, 0x47, 0x04                         ; 02DD8  inc byte [bx + 4]
  call mem_mau_collapse                               ; 02DDB  0xE8, 0x94, 0x00
  db 0x2B, 0xDB                               ; 02DDE  sub bx, bx
  db 0x8B, 0xCB                               ; 02DE0  mov cx, bx
  jmp short loc_02DE4                          ; 02DE2  0xEB, 0x00

loc_02DE4:  ; 02DE4
  db 0x2E, 0x8E, 0x1E, 0x06, 0x00             ; 02DE4  mov ds, word [cs:6]
  db 0x07                                     ; 02DE9  pop es
  db 0xC3                                     ; 02DEA  ret

mem_fn10_maufree:  ; 02DEB
  db 0x06                                     ; 02DEB  push es
  db 0x26, 0x8E, 0x06, 0x2E, 0x00             ; 02DEC  mov es, word [es:0x2e]
  db 0x8B, 0xF2                               ; 02DF1  mov si, dx
  db 0x26, 0x8B, 0x1C                         ; 02DF3  mov bx, word [es:si]
  db 0x8E, 0x5F, 0x02                         ; 02DF6  mov ds, word [bx + 2]
  db 0x2B, 0xDB                               ; 02DF9  sub bx, bx
  db 0x8B, 0xCB                               ; 02DFB  mov cx, bx
  db 0x26, 0x8B, 0x54, 0x02                   ; 02DFD  mov dx, word [es:si + 2]

loc_02E01:  ; 02E01
  db 0x83, 0xC3, 0x05                         ; 02E01  add bx, 5
  db 0x41                                     ; 02E04  inc cx
  db 0x3B, 0x0E, 0x00, 0x00                   ; 02E05  cmp cx, word [0]
  ja loc_02E3D                                 ; 02E09  0x77, 0x32
  db 0x3B, 0x17                               ; 02E0B  cmp dx, word [bx]
  jne loc_02E01                                ; 02E0D  0x75, 0xF2
  db 0x26, 0x3B, 0x54, 0x04                   ; 02E0F  cmp dx, word [es:si + 4]
  je loc_02E35                                 ; 02E13  0x74, 0x20
  db 0x80, 0x7F, 0x04, 0x01                   ; 02E15  cmp byte [bx + 4], 1
  je loc_02E1D                                 ; 02E19  0x74, 0x02
  jmp short loc_02E43                          ; 02E1B  0xEB, 0x26

loc_02E1D:  ; 02E1D
  db 0x26, 0x8B, 0x4C, 0x04                   ; 02E1D  mov cx, word [es:si + 4]
  db 0x8B, 0x07                               ; 02E21  mov ax, word [bx]
  db 0x03, 0x47, 0x02                         ; 02E23  add ax, word [bx + 2]
  db 0x3B, 0xC1                               ; 02E26  cmp ax, cx
  jb loc_02E3D                                 ; 02E28  0x72, 0x13
  db 0x2B, 0xCA                               ; 02E2A  sub cx, dx
  call mem_mau_split                               ; 02E2C  0xE8, 0x1B, 0x00
  db 0x2B, 0xC9                               ; 02E2F  sub cx, cx
  db 0x8B, 0xD9                               ; 02E31  mov bx, cx
  jmp short loc_02E38                          ; 02E33  0xEB, 0x03

loc_02E35:  ; 02E35
  db 0xFE, 0x4F, 0x04                         ; 02E35  dec byte [bx + 4]

loc_02E38:  ; 02E38
  call mem_mau_collapse                               ; 02E38  0xE8, 0x37, 0x00
  jmp short loc_02E43                          ; 02E3B  0xEB, 0x06

loc_02E3D:  ; 02E3D
  db 0xBB, 0xFF, 0xFF                         ; 02E3D  mov bx, 0xffff
  db 0xB9, 0x03, 0x00                         ; 02E40  mov cx, 3

loc_02E43:  ; 02E43
  db 0x07                                     ; 02E43  pop es
  db 0x2E, 0x8E, 0x1E, 0x06, 0x00             ; 02E44  mov ds, word [cs:6]
  db 0xC3                                     ; 02E49  ret

mem_mau_split:  ; 02E4A
  db 0x53                                     ; 02E4A  push bx
  db 0x51                                     ; 02E4B  push cx
  db 0x83, 0xC3, 0x05                         ; 02E4C  add bx, 5
  call mem_mau_insert                               ; 02E4F  0xE8, 0xE2, 0x00
  db 0x83, 0xF9, 0x00                         ; 02E52  cmp cx, 0
  db 0x59                                     ; 02E55  pop cx
  db 0x5B                                     ; 02E56  pop bx
  jne loc_02E6E                                ; 02E57  0x75, 0x15
  db 0x8D, 0x7F, 0x05                         ; 02E59  lea di, [bx + 5]
  db 0x8B, 0x57, 0x02                         ; 02E5C  mov dx, word [bx + 2]
  db 0x2B, 0xD1                               ; 02E5F  sub dx, cx
  db 0x89, 0x55, 0x02                         ; 02E61  mov word [di + 2], dx
  db 0x8B, 0xD1                               ; 02E64  mov dx, cx
  db 0x03, 0x17                               ; 02E66  add dx, word [bx]
  db 0x89, 0x15                               ; 02E68  mov word [di], dx
  db 0xC6, 0x45, 0x04, 0x00                   ; 02E6A  mov byte [di + 4], 0

loc_02E6E:  ; 02E6E
  db 0x89, 0x4F, 0x02                         ; 02E6E  mov word [bx + 2], cx
  db 0xC3                                     ; 02E71  ret

mem_mau_collapse:  ; 02E72
  db 0x2B, 0xDB                               ; 02E72  sub bx, bx
  db 0x8B, 0xCB                               ; 02E74  mov cx, bx

loc_02E76:  ; 02E76
  db 0x41                                     ; 02E76  inc cx
  db 0x3B, 0x0E, 0x00, 0x00                   ; 02E77  cmp cx, word [0]
  je loc_02EE6                                 ; 02E7B  0x74, 0x69
  db 0x83, 0xC3, 0x05                         ; 02E7D  add bx, 5
  db 0x8D, 0x7F, 0x05                         ; 02E80  lea di, [bx + 5]
  db 0x83, 0x3F, 0x00                         ; 02E83  cmp word [bx], 0
  je loc_02EE6                                 ; 02E86  0x74, 0x5E
  db 0x83, 0x3D, 0x00                         ; 02E88  cmp word [di], 0
  je loc_02EE6                                 ; 02E8B  0x74, 0x59
  db 0x80, 0x7F, 0x04, 0x00                   ; 02E8D  cmp byte [bx + 4], 0
  jne loc_02EBF                                ; 02E91  0x75, 0x2C
  db 0x8B, 0x07                               ; 02E93  mov ax, word [bx]
  db 0x03, 0x47, 0x02                         ; 02E95  add ax, word [bx + 2]
  db 0x3B, 0x05                               ; 02E98  cmp ax, word [di]
  je loc_02EA3                                 ; 02E9A  0x74, 0x07
  db 0x8B, 0x05                               ; 02E9C  mov ax, word [di]
  db 0x2B, 0x07                               ; 02E9E  sub ax, word [bx]
  db 0x89, 0x47, 0x02                         ; 02EA0  mov word [bx + 2], ax

loc_02EA3:  ; 02EA3
  db 0x80, 0x7D, 0x04, 0x00                   ; 02EA3  cmp byte [di + 4], 0
  jne loc_02E76                                ; 02EA7  0x75, 0xCD
  db 0x8B, 0x45, 0x02                         ; 02EA9  mov ax, word [di + 2]
  db 0x01, 0x47, 0x02                         ; 02EAC  add word [bx + 2], ax
  db 0x53                                     ; 02EAF  push bx
  db 0x51                                     ; 02EB0  push cx
  db 0x8B, 0xDF                               ; 02EB1  mov bx, di
  call mem_mau_release                               ; 02EB3  0xE8, 0x54, 0x00
  db 0x59                                     ; 02EB6  pop cx
  db 0x5B                                     ; 02EB7  pop bx
  db 0x83, 0xEB, 0x05                         ; 02EB8  sub bx, 5
  db 0x49                                     ; 02EBB  dec cx
  jmp near loc_02E76                           ; 02EBC  0xE9, 0xB7, 0xFF

loc_02EBF:  ; 02EBF
  db 0x8B, 0x07                               ; 02EBF  mov ax, word [bx]
  db 0x03, 0x47, 0x02                         ; 02EC1  add ax, word [bx + 2]
  db 0x3B, 0x05                               ; 02EC4  cmp ax, word [di]
  je loc_02E76                                 ; 02EC6  0x74, 0xAE
  db 0x80, 0x7D, 0x04, 0x00                   ; 02EC8  cmp byte [di + 4], 0
  je loc_02EDA                                 ; 02ECC  0x74, 0x0C
  db 0x53                                     ; 02ECE  push bx
  db 0x51                                     ; 02ECF  push cx
  db 0x8B, 0xFB                               ; 02ED0  mov di, bx
  call mem_mau_insert                               ; 02ED2  0xE8, 0x5F, 0x00
  db 0x59                                     ; 02ED5  pop cx
  db 0x5B                                     ; 02ED6  pop bx
  jmp near loc_02E76                           ; 02ED7  0xE9, 0x9C, 0xFF

loc_02EDA:  ; 02EDA
  db 0x8B, 0x05                               ; 02EDA  mov ax, word [di]
  db 0x2B, 0x07                               ; 02EDC  sub ax, word [bx]
  db 0x29, 0x05                               ; 02EDE  sub word [di], ax
  db 0x01, 0x45, 0x02                         ; 02EE0  add word [di + 2], ax
  jmp near loc_02E76                           ; 02EE3  0xE9, 0x90, 0xFF

loc_02EE6:  ; 02EE6
  db 0xBD, 0xFF, 0xFF                         ; 02EE6  mov bp, 0xffff
  db 0x33, 0xC9                               ; 02EE9  xor cx, cx
  db 0x33, 0xDB                               ; 02EEB  xor bx, bx

loc_02EED:  ; 02EED
  db 0x41                                     ; 02EED  inc cx
  db 0x3B, 0x0E, 0x00, 0x00                   ; 02EEE  cmp cx, word [0]
  je loc_02F05                                 ; 02EF2  0x74, 0x11
  db 0x83, 0xC3, 0x05                         ; 02EF4  add bx, 5
  db 0x83, 0x3F, 0x00                         ; 02EF7  cmp word [bx], 0
  je loc_02F05                                 ; 02EFA  0x74, 0x09
  db 0x80, 0x7F, 0x04, 0x00                   ; 02EFC  cmp byte [bx + 4], 0
  je loc_02EED                                 ; 02F00  0x74, 0xEB
  db 0xBD, 0x00, 0x00                         ; 02F02  mov bp, 0

loc_02F05:  ; 02F05
  db 0x8B, 0xDD                               ; 02F05  mov bx, bp
  db 0x33, 0xC9                               ; 02F07  xor cx, cx
  db 0xC3                                     ; 02F09  ret

mem_mau_release:  ; 02F0A
  db 0x06                                     ; 02F0A  push es
  db 0x8C, 0xD8                               ; 02F0B  mov ax, ds
  db 0x8E, 0xC0                               ; 02F0D  mov es, ax
  db 0xB8, 0x05, 0x00                         ; 02F0F  mov ax, 5
  db 0xF6, 0x26, 0x00, 0x00                   ; 02F12  mul byte [0]
  db 0x50                                     ; 02F16  push ax
  db 0x8B, 0xC8                               ; 02F17  mov cx, ax
  db 0x2B, 0xCB                               ; 02F19  sub cx, bx
  db 0x8B, 0xFB                               ; 02F1B  mov di, bx
  db 0x83, 0xC3, 0x05                         ; 02F1D  add bx, 5
  db 0x8B, 0xF3                               ; 02F20  mov si, bx
  db 0xF3, 0xA4                               ; 02F22  rep movsb
  db 0x5B                                     ; 02F24  pop bx
  db 0xC7, 0x47, 0x02, 0x00, 0x00             ; 02F25  mov word [bx + 2], 0
  db 0xC7, 0x07, 0x00, 0x00                   ; 02F2A  mov word [bx], 0
  db 0xC6, 0x47, 0x04, 0x00                   ; 02F2E  mov byte [bx + 4], 0
  db 0x07                                     ; 02F32  pop es
  db 0xC3                                     ; 02F33  ret

mem_mau_insert:  ; 02F34
  db 0xB8, 0x05, 0x00                         ; 02F34  mov ax, 5
  db 0xF6, 0x26, 0x00, 0x00                   ; 02F37  mul byte [0]
  db 0x8B, 0xF0                               ; 02F3B  mov si, ax
  db 0xB9, 0xFF, 0xFF                         ; 02F3D  mov cx, 0xffff
  db 0x83, 0x3C, 0x00                         ; 02F40  cmp word [si], 0
  jne loc_02F5F                                ; 02F43  0x75, 0x1A
  db 0x8B, 0xCE                               ; 02F45  mov cx, si
  db 0x2B, 0xCB                               ; 02F47  sub cx, bx
  db 0x4E                                     ; 02F49  dec si
  db 0x8D, 0x7C, 0x05                         ; 02F4A  lea di, [si + 5]
  db 0x06                                     ; 02F4D  push es
  db 0x1E                                     ; 02F4E  push ds
  db 0x07                                     ; 02F4F  pop es
  db 0xFD                                     ; 02F50  std
  db 0xF3, 0xA4                               ; 02F51  rep movsb
  db 0xFC                                     ; 02F53  cld
  db 0x07                                     ; 02F54  pop es
  db 0x2B, 0xC9                               ; 02F55  sub cx, cx
  db 0x89, 0x0F                               ; 02F57  mov word [bx], cx
  db 0x89, 0x4F, 0x02                         ; 02F59  mov word [bx + 2], cx
  db 0x88, 0x4F, 0x04                         ; 02F5C  mov byte [bx + 4], cl

loc_02F5F:  ; 02F5F
  db 0xC3                                     ; 02F5F  ret

mem_fn11_mlalloc:  ; 02F60
  db 0x8B, 0xF2                               ; 02F60  mov si, dx
  db 0x2B, 0xC0                               ; 02F62  sub ax, ax
  db 0x8B, 0xC8                               ; 02F64  mov cx, ax
  db 0xBA, 0xFF, 0xFF                         ; 02F66  mov dx, 0xffff
  db 0x50                                     ; 02F69  push ax
  db 0x51                                     ; 02F6A  push cx

loc_02F6B:  ; 02F6B
  db 0x83, 0x3F, 0x00                         ; 02F6B  cmp word [bx], 0
  je loc_02F90                                 ; 02F6E  0x74, 0x20
  db 0x53                                     ; 02F70  push bx
  db 0x52                                     ; 02F71  push dx
  db 0x56                                     ; 02F72  push si
  call mem_mla_value                               ; 02F73  0xE8, 0x2F, 0x00
  db 0x5E                                     ; 02F76  pop si
  db 0x5A                                     ; 02F77  pop dx
  db 0x5B                                     ; 02F78  pop bx
  db 0x3B, 0xCA                               ; 02F79  cmp cx, dx
  jae loc_02F8C                                ; 02F7B  0x73, 0x0F
  db 0x8B, 0xD1                               ; 02F7D  mov dx, cx
  db 0x59                                     ; 02F7F  pop cx
  db 0x8B, 0xC8                               ; 02F80  mov cx, ax
  db 0x58                                     ; 02F82  pop ax
  db 0x8B, 0xC3                               ; 02F83  mov ax, bx
  db 0x50                                     ; 02F85  push ax
  db 0x51                                     ; 02F86  push cx
  db 0x83, 0xFA, 0x00                         ; 02F87  cmp dx, 0
  je loc_02F90                                 ; 02F8A  0x74, 0x04

loc_02F8C:  ; 02F8C
  db 0x8B, 0x1F                               ; 02F8C  mov bx, word [bx]
  jmp short loc_02F6B                          ; 02F8E  0xEB, 0xDB

loc_02F90:  ; 02F90
  db 0x59                                     ; 02F90  pop cx
  db 0x58                                     ; 02F91  pop ax
  db 0x3D, 0x00, 0x00                         ; 02F92  cmp ax, 0
  je loc_02F9E                                 ; 02F95  0x74, 0x07
  db 0x8B, 0xD8                               ; 02F97  mov bx, ax
  db 0x8B, 0xC1                               ; 02F99  mov ax, cx
  jmp near loc_03051                           ; 02F9B  0xE9, 0xB3, 0x00

loc_02F9E:  ; 02F9E
  db 0xBB, 0xFF, 0xFF                         ; 02F9E  mov bx, 0xffff
  db 0xB9, 0x03, 0x00                         ; 02FA1  mov cx, 3
  db 0xC3                                     ; 02FA4  ret

mem_mla_value:  ; 02FA5
  db 0x33, 0xED                               ; 02FA5  xor bp, bp
  db 0x06                                     ; 02FA7  push es
  db 0x26, 0x8E, 0x06, 0x2E, 0x00             ; 02FA8  mov es, word [es:0x2e]
  db 0x2B, 0xC0                               ; 02FAD  sub ax, ax
  db 0xBA, 0x00, 0x00                         ; 02FAF  mov dx, 0
  db 0x8B, 0x3F                               ; 02FB2  mov di, word [bx]
  db 0x83, 0xFF, 0x00                         ; 02FB4  cmp di, 0
  je loc_03016                                 ; 02FB7  0x74, 0x5D
  db 0x26, 0x83, 0x3C, 0x00                   ; 02FB9  cmp word [es:si], 0
  je loc_02FE2                                 ; 02FBD  0x74, 0x23
  db 0x8B, 0x4D, 0x02                         ; 02FBF  mov cx, word [di + 2]
  db 0x83, 0xC1, 0x0A                         ; 02FC2  add cx, 0xa
  db 0x26, 0x39, 0x0C                         ; 02FC5  cmp word [es:si], cx
  jb loc_03016                                 ; 02FC8  0x72, 0x4C
  db 0x03, 0x4D, 0x04                         ; 02FCA  add cx, word [di + 4]
  db 0x83, 0xE9, 0x0A                         ; 02FCD  sub cx, 0xa
  db 0x26, 0x39, 0x0C                         ; 02FD0  cmp word [es:si], cx
  jae loc_03016                                ; 02FD3  0x73, 0x41
  db 0xBD, 0x01, 0x00                         ; 02FD5  mov bp, 1
  db 0x40                                     ; 02FD8  inc ax
  db 0x8B, 0xD1                               ; 02FD9  mov dx, cx
  db 0x26, 0x2B, 0x14                         ; 02FDB  sub dx, word [es:si]
  db 0x8B, 0xDF                               ; 02FDE  mov bx, di
  db 0x8B, 0x3F                               ; 02FE0  mov di, word [bx]

loc_02FE2:  ; 02FE2
  db 0x26, 0x8B, 0x4C, 0x04                   ; 02FE2  mov cx, word [es:si + 4]
  db 0x3B, 0xCA                               ; 02FE6  cmp cx, dx
  jb loc_0301D                                 ; 02FE8  0x72, 0x33

loc_02FEA:  ; 02FEA
  db 0x3D, 0x00, 0x00                         ; 02FEA  cmp ax, 0
  je loc_02FFE                                 ; 02FED  0x74, 0x0F
  db 0x50                                     ; 02FEF  push ax
  db 0x8B, 0x47, 0x02                         ; 02FF0  mov ax, word [bx + 2]
  db 0x03, 0x47, 0x04                         ; 02FF3  add ax, word [bx + 4]
  db 0x3B, 0x45, 0x02                         ; 02FF6  cmp ax, word [di + 2]
  db 0x58                                     ; 02FF9  pop ax
  je loc_02FFE                                 ; 02FFA  0x74, 0x02
  jmp short loc_0300B                          ; 02FFC  0xEB, 0x0D

loc_02FFE:  ; 02FFE
  db 0x40                                     ; 02FFE  inc ax
  db 0x03, 0x55, 0x04                         ; 02FFF  add dx, word [di + 4]
  db 0x8B, 0xDF                               ; 03002  mov bx, di
  db 0x8B, 0x3F                               ; 03004  mov di, word [bx]
  db 0x83, 0xFF, 0x00                         ; 03006  cmp di, 0
  jne loc_02FE2                                ; 03009  0x75, 0xD7

loc_0300B:  ; 0300B
  db 0x26, 0x8B, 0x4C, 0x02                   ; 0300B  mov cx, word [es:si + 2]
  db 0x83, 0xC1, 0x0A                         ; 0300F  add cx, 0xa
  db 0x3B, 0xCA                               ; 03012  cmp cx, dx
  jbe loc_03029                                ; 03014  0x76, 0x13

loc_03016:  ; 03016
  db 0xB9, 0xFF, 0xFF                         ; 03016  mov cx, 0xffff
  db 0x2B, 0xC0                               ; 03019  sub ax, ax
  db 0x07                                     ; 0301B  pop es
  db 0xC3                                     ; 0301C  ret

loc_0301D:  ; 0301D
  db 0x83, 0xFD, 0x01                         ; 0301D  cmp bp, 1
  je loc_03029                                 ; 03020  0x74, 0x07
  db 0x83, 0xC1, 0x0A                         ; 03022  add cx, 0xa
  db 0x3B, 0xCA                               ; 03025  cmp cx, dx
  ja loc_02FEA                                 ; 03027  0x77, 0xC1

loc_03029:  ; 03029
  db 0x50                                     ; 03029  push ax
  db 0x48                                     ; 0302A  dec ax
  db 0xB1, 0x02                               ; 0302B  mov cl, 2
  db 0xD3, 0xE0                               ; 0302D  shl ax, cl
  db 0x26, 0x8B, 0x4C, 0x04                   ; 0302F  mov cx, word [es:si + 4]
  db 0x83, 0xC1, 0x0A                         ; 03033  add cx, 0xa
  db 0x83, 0xF9, 0x0A                         ; 03036  cmp cx, 0xa
  jae loc_0303E                                ; 03039  0x73, 0x03
  db 0xB9, 0xFF, 0xFF                         ; 0303B  mov cx, 0xffff

loc_0303E:  ; 0303E
  db 0x3B, 0xCA                               ; 0303E  cmp cx, dx
  jbe loc_03044                                ; 03040  0x76, 0x02
  db 0x87, 0xD1                               ; 03042  xchg cx, dx

loc_03044:  ; 03044
  db 0x2B, 0xD1                               ; 03044  sub dx, cx
  db 0xB1, 0x04                               ; 03046  mov cl, 4
  db 0xD3, 0xEA                               ; 03048  shr dx, cl
  db 0x03, 0xD0                               ; 0304A  add dx, ax
  db 0x8B, 0xCA                               ; 0304C  mov cx, dx
  db 0x58                                     ; 0304E  pop ax
  db 0x07                                     ; 0304F  pop es
  db 0xC3                                     ; 03050  ret

loc_03051:  ; 03051
  db 0x3D, 0x01, 0x00                         ; 03051  cmp ax, 1
  jg loc_03068                                 ; 03054  0x7F, 0x12
  db 0x8B, 0x37                               ; 03056  mov si, word [bx]
  db 0x8B, 0x0C                               ; 03058  mov cx, word [si]
  db 0x89, 0x0F                               ; 0305A  mov word [bx], cx
  db 0x8B, 0xDE                               ; 0305C  mov bx, si
  db 0x2B, 0xC9                               ; 0305E  sub cx, cx
  db 0x89, 0x4F, 0x06                         ; 03060  mov word [bx + 6], cx
  db 0x89, 0x0F                               ; 03063  mov word [bx], cx
  jmp near loc_030A8                           ; 03065  0xE9, 0x40, 0x00

loc_03068:  ; 03068
  db 0x50                                     ; 03068  push ax
  db 0x53                                     ; 03069  push bx
  call mem_getmd                               ; 0306A  0xE8, 0xB8, 0x00
  db 0x8B, 0xFB                               ; 0306D  mov di, bx
  db 0x5B                                     ; 0306F  pop bx
  db 0x58                                     ; 03070  pop ax
  jcxz loc_03076                               ; 03071  0xE3, 0x03
  db 0x2B, 0xDB                               ; 03073  sub bx, bx
  db 0xC3                                     ; 03075  ret

loc_03076:  ; 03076
  db 0xC7, 0x05, 0x00, 0x00                   ; 03076  mov word [di], 0
  db 0xC7, 0x45, 0x04, 0x00, 0x00             ; 0307A  mov word [di + 4], 0
  db 0x8B, 0x37                               ; 0307F  mov si, word [bx]
  db 0x89, 0x75, 0x06                         ; 03081  mov word [di + 6], si
  db 0x8B, 0x4C, 0x02                         ; 03084  mov cx, word [si + 2]
  db 0x89, 0x4D, 0x02                         ; 03087  mov word [di + 2], cx

loc_0308A:  ; 0308A
  db 0x8B, 0x4C, 0x04                         ; 0308A  mov cx, word [si + 4]
  db 0x01, 0x4D, 0x04                         ; 0308D  add word [di + 4], cx
  db 0x48                                     ; 03090  dec ax
  db 0x3D, 0x00, 0x00                         ; 03091  cmp ax, 0
  je loc_0309A                                 ; 03094  0x74, 0x04
  db 0x8B, 0x34                               ; 03096  mov si, word [si]
  jmp short loc_0308A                          ; 03098  0xEB, 0xF0

loc_0309A:  ; 0309A
  db 0x53                                     ; 0309A  push bx
  db 0x8B, 0x1C                               ; 0309B  mov bx, word [si]
  db 0xC7, 0x04, 0x00, 0x00                   ; 0309D  mov word [si], 0
  db 0x5E                                     ; 030A1  pop si
  db 0x89, 0x1C                               ; 030A2  mov word [si], bx
  db 0x8B, 0xDF                               ; 030A4  mov bx, di
  db 0x2B, 0xC9                               ; 030A6  sub cx, cx

loc_030A8:  ; 030A8
  db 0x8B, 0x57, 0x02                         ; 030A8  mov dx, word [bx + 2]
  db 0x8B, 0x4F, 0x04                         ; 030AB  mov cx, word [bx + 4]
  db 0x51                                     ; 030AE  push cx
  db 0x06                                     ; 030AF  push es
  db 0x8E, 0xC2                               ; 030B0  mov es, dx
  db 0x2B, 0xC0                               ; 030B2  sub ax, ax
  db 0x8B, 0xF8                               ; 030B4  mov di, ax
  db 0xB9, 0x50, 0x00                         ; 030B6  mov cx, 0x50
  db 0xF3, 0xAB                               ; 030B9  rep stosw
  db 0x07                                     ; 030BB  pop es
  db 0x59                                     ; 030BC  pop cx
  db 0x8E, 0xDA                               ; 030BD  mov ds, dx
  db 0xC6, 0x06, 0x00, 0x00, 0x1F             ; 030BF  mov byte [0], 0x1f
  db 0x83, 0xE9, 0x0A                         ; 030C4  sub cx, 0xa
  db 0x83, 0xC2, 0x0A                         ; 030C7  add dx, 0xa
  db 0xBE, 0x05, 0x00                         ; 030CA  mov si, 5
  db 0x89, 0x14                               ; 030CD  mov word [si], dx
  db 0x89, 0x4C, 0x02                         ; 030CF  mov word [si + 2], cx
  db 0xC6, 0x44, 0x04, 0x00                   ; 030D2  mov byte [si + 4], 0
  db 0x2E, 0x8E, 0x1E, 0x06, 0x00             ; 030D6  mov ds, word [cs:6]
  db 0x2B, 0xC9                               ; 030DB  sub cx, cx
  db 0xC3                                     ; 030DD  ret

mem_fn12_mlfree:  ; 030DE
  db 0x8B, 0xF2                               ; 030DE  mov si, dx
  db 0x83, 0x7C, 0x06, 0x00                   ; 030E0  cmp word [si + 6], 0
  je loc_03103                                 ; 030E4  0x74, 0x1D
  db 0x8B, 0xFE                               ; 030E6  mov di, si
  db 0x8B, 0x74, 0x06                         ; 030E8  mov si, word [si + 6]

loc_030EB:  ; 030EB
  db 0x83, 0xFE, 0x00                         ; 030EB  cmp si, 0
  je loc_030FC                                 ; 030EE  0x74, 0x0C
  db 0xFF, 0x34                               ; 030F0  push word [si]
  db 0x53                                     ; 030F2  push bx
  db 0x57                                     ; 030F3  push di
  call mem_ml_insert                               ; 030F4  0xE8, 0x14, 0x00
  db 0x5F                                     ; 030F7  pop di
  db 0x5B                                     ; 030F8  pop bx
  db 0x5E                                     ; 030F9  pop si
  jmp short loc_030EB                          ; 030FA  0xEB, 0xEF

loc_030FC:  ; 030FC
  db 0x8B, 0xDF                               ; 030FC  mov bx, di
  call mem_freemd                               ; 030FE  0xE8, 0x47, 0x00
  jmp short loc_03106                          ; 03101  0xEB, 0x03

loc_03103:  ; 03103
  call mem_ml_insert                               ; 03103  0xE8, 0x05, 0x00

loc_03106:  ; 03106
  db 0x2B, 0xDB                               ; 03106  sub bx, bx
  db 0x8B, 0xCB                               ; 03108  mov cx, bx
  db 0xC3                                     ; 0310A  ret

mem_ml_insert:  ; 0310B
  db 0x8B, 0x3F                               ; 0310B  mov di, word [bx]
  db 0x83, 0xFF, 0x00                         ; 0310D  cmp di, 0
  je loc_0311E                                 ; 03110  0x74, 0x0C
  db 0x8B, 0x45, 0x02                         ; 03112  mov ax, word [di + 2]
  db 0x3B, 0x44, 0x02                         ; 03115  cmp ax, word [si + 2]
  ja loc_0311E                                 ; 03118  0x77, 0x04
  db 0x8B, 0xDF                               ; 0311A  mov bx, di
  jmp short mem_ml_insert                          ; 0311C  0xEB, 0xED

loc_0311E:  ; 0311E
  db 0x8B, 0x07                               ; 0311E  mov ax, word [bx]
  db 0x89, 0x37                               ; 03120  mov word [bx], si
  db 0x89, 0x04                               ; 03122  mov word [si], ax
  db 0xC3                                     ; 03124  ret

mem_getmd:  ; 03125
  db 0x9C                                     ; 03125  pushf
  db 0xFA                                     ; 03126  cli
  db 0xB9, 0x12, 0x00                         ; 03127  mov cx, 0x12
  db 0x8B, 0x1E, 0x58, 0x00                   ; 0312A  mov bx, word [0x58]
  db 0x83, 0xFB, 0x00                         ; 0312E  cmp bx, 0
  je loc_03146                                 ; 03131  0x74, 0x13
  db 0x33, 0xC9                               ; 03133  xor cx, cx
  db 0x8B, 0x37                               ; 03135  mov si, word [bx]
  db 0x89, 0x36, 0x58, 0x00                   ; 03137  mov word [0x58], si
  db 0x89, 0x0F                               ; 0313B  mov word [bx], cx
  db 0x89, 0x4F, 0x02                         ; 0313D  mov word [bx + 2], cx
  db 0x89, 0x4F, 0x04                         ; 03140  mov word [bx + 4], cx
  db 0x89, 0x4F, 0x06                         ; 03143  mov word [bx + 6], cx

loc_03146:  ; 03146
  db 0x9D                                     ; 03146  popf
  db 0xC3                                     ; 03147  ret

mem_freemd:  ; 03148
  db 0x9C                                     ; 03148  pushf
  db 0xFA                                     ; 03149  cli
  db 0x8B, 0x36, 0x58, 0x00                   ; 0314A  mov si, word [0x58]
  db 0x89, 0x1E, 0x58, 0x00                   ; 0314E  mov word [0x58], bx
  db 0x89, 0x37                               ; 03152  mov word [bx], si
  db 0x9D                                     ; 03154  popf
  db 0xC3                                     ; 03155  ret
  db 0x90                                     ; 03156  nop
  db 0x90                                     ; 03157  nop
  db 0x90                                     ; 03158  nop
  db 0x90                                     ; 03159  nop
  db 0x90                                     ; 0315A  nop
  db 0x90                                     ; 0315B  nop
  db 0x90                                     ; 0315C  nop
  db 0x90                                     ; 0315D  nop
  db 0x90                                     ; 0315E  nop
  db 0x90                                     ; 0315F  nop
  db 0x90                                     ; 03160  nop
  db 0x90                                     ; 03161  nop
  db 0x90                                     ; 03162  nop
  db 0x90                                     ; 03163  nop
  db 0x90                                     ; 03164  nop
  db 0x90                                     ; 03165  nop
  db 0x90                                     ; 03166  nop
  db 0x90                                     ; 03167  nop
  db 0x90                                     ; 03168  nop
  db 0x90                                     ; 03169  nop
  db 0x90                                     ; 0316A  nop
  db 0x90                                     ; 0316B  nop
  db 0x90                                     ; 0316C  nop
  db 0x90                                     ; 0316D  nop
  db 0x90                                     ; 0316E  nop
  db 0x90                                     ; 0316F  nop
  db 0x90                                     ; 03170  nop
  db 0x90                                     ; 03171  nop
  db 0x90                                     ; 03172  nop
  db 0x90                                     ; 03173  nop
  db 0x90                                     ; 03174  nop
  db 0x90                                     ; 03175  nop
  db 0x90                                     ; 03176  nop
  db 0x90                                     ; 03177  nop
  db 0x90                                     ; 03178  nop
  db 0x90                                     ; 03179  nop
  db 0x90                                     ; 0317A  nop
  db 0x90                                     ; 0317B  nop
  db 0x90                                     ; 0317C  nop
  db 0x90                                     ; 0317D  nop
  db 0x90                                     ; 0317E  nop
  db 0x90                                     ; 0317F  nop
  db 0x90                                     ; 03180  nop
  db 0x90                                     ; 03181  nop
  db 0x90                                     ; 03182  nop
  db 0x90                                     ; 03183  nop
  db 0x90                                     ; 03184  nop
  db 0x90                                     ; 03185  nop
  db 0x90                                     ; 03186  nop
  db 0x90                                     ; 03187  nop
  db 0x90                                     ; 03188  nop
  db 0x90                                     ; 03189  nop
  db 0x90                                     ; 0318A  nop
  db 0x90                                     ; 0318B  nop
  db 0x90                                     ; 0318C  nop
  db 0x90                                     ; 0318D  nop
  db 0x90                                     ; 0318E  nop
  db 0x90                                     ; 0318F  nop
  db 0x90                                     ; 03190  nop
  db 0x90                                     ; 03191  nop
  db 0x90                                     ; 03192  nop
  db 0x90                                     ; 03193  nop
  db 0x90                                     ; 03194  nop
  db 0x90                                     ; 03195  nop
  db 0x90                                     ; 03196  nop
  db 0x90                                     ; 03197  nop
  db 0x90                                     ; 03198  nop
  db 0x90                                     ; 03199  nop
  db 0x90                                     ; 0319A  nop
  db 0x90                                     ; 0319B  nop
  db 0x90                                     ; 0319C  nop
  db 0x90                                     ; 0319D  nop
  db 0x90                                     ; 0319E  nop
  db 0x90                                     ; 0319F  nop
  db 0x90                                     ; 031A0  nop
  db 0x90                                     ; 031A1  nop
  db 0x90                                     ; 031A2  nop
  db 0x90                                     ; 031A3  nop
  db 0x90                                     ; 031A4  nop
  db 0x90                                     ; 031A5  nop
  db 0x90                                     ; 031A6  nop
  db 0x90                                     ; 031A7  nop
  db 0x90                                     ; 031A8  nop
  db 0x90                                     ; 031A9  nop
  db 0x90                                     ; 031AA  nop
  db 0x90                                     ; 031AB  nop
  db 0x90                                     ; 031AC  nop
  db 0x90                                     ; 031AD  nop
  db 0x90                                     ; 031AE  nop
  db 0x90                                     ; 031AF  nop
  db 0x90                                     ; 031B0  nop
  db 0x90                                     ; 031B1  nop
  db 0x90                                     ; 031B2  nop
  db 0x90                                     ; 031B3  nop
  db 0x90                                     ; 031B4  nop
  db 0x90                                     ; 031B5  nop
  db 0x90                                     ; 031B6  nop
  db 0x90                                     ; 031B7  nop
  db 0x90                                     ; 031B8  nop
  db 0x90                                     ; 031B9  nop
  db 0x90                                     ; 031BA  nop
  db 0x90                                     ; 031BB  nop
  db 0x90                                     ; 031BC  nop
  db 0x90                                     ; 031BD  nop
  db 0x90                                     ; 031BE  nop
  db 0x90                                     ; 031BF  nop
  db 0x90                                     ; 031C0  nop
  db 0x90                                     ; 031C1  nop
  db 0x90                                     ; 031C2  nop
  db 0x90                                     ; 031C3  nop
  db 0x90                                     ; 031C4  nop
  db 0x90                                     ; 031C5  nop
  db 0x90                                     ; 031C6  nop
  db 0x90                                     ; 031C7  nop
  db 0x90                                     ; 031C8  nop
  db 0x90                                     ; 031C9  nop
  db 0x90                                     ; 031CA  nop
  db 0x90                                     ; 031CB  nop
  db 0x90                                     ; 031CC  nop
  db 0x90                                     ; 031CD  nop
  db 0x90                                     ; 031CE  nop
  db 0x90                                     ; 031CF  nop
  db 0x90                                     ; 031D0  nop
  db 0x90                                     ; 031D1  nop
  db 0x90                                     ; 031D2  nop
  db 0x90                                     ; 031D3  nop
  db 0x90                                     ; 031D4  nop
  db 0x90                                     ; 031D5  nop
  db 0x00, 0x00                               ; 031D6  add byte [bx + si], al
  db 0x00, 0x00                               ; 031D8  add byte [bx + si], al
  db 0x00, 0x00                               ; 031DA  add byte [bx + si], al
  db 0x00, 0x00                               ; 031DC  add byte [bx + si], al
  db 0x00, 0x00                               ; 031DE  add byte [bx + si], al
