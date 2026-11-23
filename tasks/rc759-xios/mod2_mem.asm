; =============================================================================
; ccpm.sys — Modul 2: Memory Manager (MEMIF.MEM)
; Offset range: 0x026C0 - 0x031E0
; =============================================================================

  jmp near mem_init                            ; 026C0  0xE9, 0x48, 0x00
  jmp near mem_entry                           ; 026C3  0xE9, 0x60, 0x00
  cli                                          ; 026C6  0xFA
  push es                                      ; 026C7  0x06
  dw 0x0003                                    ; 026C8  MEMIF version
  dw 0x0048                                    ; 026CA  Segment
  db 0x06                                      ; 026CC
  db "COPYRIGHT (C) 1982,1983,1984 DIGITAL RESEARCH 1034-0261-007041" ; 026CD

mem_init:  ; 0270B
  retf                                         ; 0270B  0xCB
  db 0xDE, 0x00                               ; 0270C  fiadd word [bx + si]
  or al, [bx + di]                             ; 0270E  0x0A, 0x01
  xor al, [bx + di]                            ; 02710  0x32, 0x01
  pop dx                                       ; 02712  0x5A
  add ax, ax                                   ; 02713  0x01, 0xC0
  add [bx], cx                                 ; 02715  0x01, 0x0F
  add ch, [bp + di + 2]                        ; 02717  0x02, 0x6B, 0x02
  loope loc_02720                              ; 0271A  0xE1, 0x04
  db 0xD3, 0x05                               ; 0271C  rol word [di], cl
  jp mem_entry                                 ; 0271E  0x7A, 0x06

loc_02720:  ; 02720
  sub ax, [bx]                                 ; 02720  0x2B, 0x07
  mov al, [0x1e08]                             ; 02722  0xA0, 0x08, 0x1E
  db 0x0A                                                         ; 02725  .

mem_entry:  ; 02726
  push bx                                      ; 02726  0x53
  push cx                                      ; 02727  0x51
  push dx                                      ; 02728  0x52
  mov bx, 0x6f5                                ; 02729  0xBB, 0xF5, 0x06
  mov cx, 0x215                                ; 0272C  0xB9, 0x15, 0x02
  call rtm_call_0x80_entry                     ; 0272F  0xE8, 0x61, 0x00
  inc byte [0x6f4]                             ; 02732  0xFE, 0x06, 0xF4, 0x06
  cmp byte [0x6f4], 1                          ; 02736  0x80, 0x3E, 0xF4, 0x06, 0x01
  jne loc_0275C                                ; 0273B  0x75, 0x1F
  mov cx, 0x217                                ; 0273D  0xB9, 0x17, 0x02
  call rtm_call_0x80_entry                     ; 02740  0xE8, 0x50, 0x00
  pop dx                                       ; 02743  0x5A
  pop cx                                       ; 02744  0x59
  pop bx                                       ; 02745  0x5B
  mov [0x672], ss                              ; 02746  0x8C, 0x16, 0x72, 0x06

mem_switch_stack:  ; 0274A
  mov [0x670], sp                              ; 0274A  0x89, 0x26, 0x70, 0x06
  mov ax, ds                                   ; 0274E  0x8C, 0xD8
  pushf                                        ; 02750  0x9C
  pop bp                                       ; 02751  0x5D
  cli                                          ; 02752  0xFA
  mov ss, ax                                   ; 02753  0x8E, 0xD0
  mov sp, 0x6f4                                ; 02755  0xBC, 0xF4, 0x06
  push bp                                      ; 02758  0x55
  popf                                         ; 02759  0x9D
  jmp short loc_0275F                          ; 0275A  0xEB, 0x03

loc_0275C:  ; 0275C
  pop dx                                       ; 0275C  0x5A
  pop cx                                       ; 0275D  0x59
  pop bx                                       ; 0275E  0x5B

loc_0275F:  ; 0275F
  mov ch, 0                                    ; 0275F  0xB5, 0x00
  shl cx, 1                                    ; 02761  0xD1, 0xE1
  db 0x8B, 0xF1                               ; 02763  mov si, cx
  db 0x2E, 0xFF, 0x94, 0x4C, 0x00             ; 02765  call word [cs:si + 0x4c]
  dec byte [0x6f4]                             ; 0276A  0xFE, 0x0E, 0xF4, 0x06
  jne mem_exit                                 ; 0276E  0x75, 0x20
  pushf                                        ; 02770  0x9C
  pop ax                                       ; 02771  0x58
  cli                                          ; 02772  0xFA

mem_restore_stack:  ; 02773
  mov ss, [0x672]                              ; 02773  0x8E, 0x16, 0x72, 0x06
  mov sp, [0x670]                              ; 02777  0x8B, 0x26, 0x70, 0x06
  push ax                                      ; 0277B  0x50
  popf                                         ; 0277C  0x9D
  push bx                                      ; 0277D  0x53
  push cx                                      ; 0277E  0x51
  mov bx, 0x6f5                                ; 0277F  0xBB, 0xF5, 0x06
  mov cx, 0x216                                ; 02782  0xB9, 0x16, 0x02
  call rtm_call_0x80_entry                     ; 02785  0xE8, 0x0B, 0x00
  mov cx, 0x218                                ; 02788  0xB9, 0x18, 0x02
  call rtm_call_0x80_entry                     ; 0278B  0xE8, 0x05, 0x00
  pop cx                                       ; 0278E  0x59
  pop bx                                       ; 0278F  0x5B

mem_exit:  ; 02790
  db 0x8B, 0xC3                               ; 02790  mov ax, bx
  retf                                         ; 02792  0xCB

rtm_call_0x80_entry:  ; 02793
  call far [cs:8]                              ; 02793  0x2E, 0xFF, 0x1E, 0x08, 0x00
  ret                                          ; 02798  0xC3
  call far [0x28]                              ; 02799  0xFF, 0x1E, 0x28, 0x00
  ret                                          ; 0279D  0xC3

mem_fn00_maxmem:  ; 0279E
  db 0x8B, 0xF2                               ; 0279E  mov si, dx
  push ds                                      ; 027A0  0x1E
  mov ds, [es:0x2e]                            ; 027A1  0x26, 0x8E, 0x1E, 0x2E, 0x00
  mov dx, [si + 2]                             ; 027A6  0x8B, 0x54, 0x02
  pop ds                                       ; 027A9  0x1F
  db 0x2B, 0xC0                               ; 027AA  sub ax, ax
  db 0x8B, 0xD8                               ; 027AC  mov bx, ax
  call io_const_rtm_helper                     ; 027AE  0xE8, 0xB2, 0x00
  jcxz loc_027B7                               ; 027B1  0xE3, 0x04
  mov bx, 0xffff                               ; 027B3  0xBB, 0xFF, 0xFF
  ret                                          ; 027B6  0xC3

loc_027B7:  ; 027B7
  push ds                                      ; 027B7  0x1E
  mov ds, [es:0x2e]                            ; 027B8  0x26, 0x8E, 0x1E, 0x2E, 0x00
  mov [si + 2], dx                             ; 027BD  0x89, 0x54, 0x02
  mov [si], ax                                 ; 027C0  0x89, 0x04
  mov byte [si + 4], 1                         ; 027C2  0xC6, 0x44, 0x04, 0x01
  pop ds                                       ; 027C6  0x1F
  db 0x2B, 0xDB                               ; 027C7  sub bx, bx
  ret                                          ; 027C9  0xC3

mem_fn01_absmax:  ; 027CA
  db 0x8B, 0xF2                               ; 027CA  mov si, dx
  push ds                                      ; 027CC  0x1E
  mov ds, [es:0x2e]                            ; 027CD  0x26, 0x8E, 0x1E, 0x2E, 0x00
  mov ax, [si]                                 ; 027D2  0x8B, 0x04
  mov dx, [si + 2]                             ; 027D4  0x8B, 0x54, 0x02
  pop ds                                       ; 027D7  0x1F
  db 0x2B, 0xDB                               ; 027D8  sub bx, bx
  call io_const_rtm_helper                     ; 027DA  0xE8, 0x86, 0x00
  jcxz loc_027E3                               ; 027DD  0xE3, 0x04
  mov bx, 0xffff                               ; 027DF  0xBB, 0xFF, 0xFF
  ret                                          ; 027E2  0xC3

loc_027E3:  ; 027E3
  push ds                                      ; 027E3  0x1E
  mov ds, [es:0x2e]                            ; 027E4  0x26, 0x8E, 0x1E, 0x2E, 0x00
  mov [si + 2], dx                             ; 027E9  0x89, 0x54, 0x02
  mov [si], ax                                 ; 027EC  0x89, 0x04
  pop ds                                       ; 027EE  0x1F
  db 0x2B, 0xDB                               ; 027EF  sub bx, bx
  ret                                          ; 027F1  0xC3

mem_fn02_cpmalloc:  ; 027F2
  db 0x8B, 0xF2                               ; 027F2  mov si, dx
  push ds                                      ; 027F4  0x1E
  mov ds, [es:0x2e]                            ; 027F5  0x26, 0x8E, 0x1E, 0x2E, 0x00
  db 0x2B, 0xC0                               ; 027FA  sub ax, ax
  mov bx, [si + 2]                             ; 027FC  0x8B, 0x5C, 0x02
  db 0x8B, 0xD3                               ; 027FF  mov dx, bx
  pop ds                                       ; 02801  0x1F
  call io_const_rtm_helper                     ; 02802  0xE8, 0x5E, 0x00
  jcxz loc_0280B                               ; 02805  0xE3, 0x04
  mov bx, 0xffff                               ; 02807  0xBB, 0xFF, 0xFF
  ret                                          ; 0280A  0xC3

loc_0280B:  ; 0280B
  push ds                                      ; 0280B  0x1E
  mov ds, [es:0x2e]                            ; 0280C  0x26, 0x8E, 0x1E, 0x2E, 0x00
  mov [si + 2], dx                             ; 02811  0x89, 0x54, 0x02
  mov [si], ax                                 ; 02814  0x89, 0x04
  pop ds                                       ; 02816  0x1F
  db 0x2B, 0xDB                               ; 02817  sub bx, bx
  ret                                          ; 02819  0xC3

mem_fn03_cpmabsa:  ; 0281A
  db 0x8B, 0xF2                               ; 0281A  mov si, dx
  push ds                                      ; 0281C  0x1E
  mov ds, [es:0x2e]                            ; 0281D  0x26, 0x8E, 0x1E, 0x2E, 0x00
  mov ax, [si]                                 ; 02822  0x8B, 0x04
  mov bx, [si + 2]                             ; 02824  0x8B, 0x5C, 0x02
  db 0x8B, 0xD3                               ; 02827  mov dx, bx
  pop ds                                       ; 02829  0x1F
  db 0x33, 0xC9                               ; 0282A  xor cx, cx

loc_0282C:  ; 0282C
  mov di, [0x68]                               ; 0282C  0x8B, 0x3E, 0x68, 0x00
  add di, 0x16                                 ; 02830  0x83, 0xC7, 0x16

loc_02833:  ; 02833
  mov di, [di]                                 ; 02833  0x8B, 0x3D
  cmp di, 0                                    ; 02835  0x83, 0xFF, 0x00
  je loc_0284B                                 ; 02838  0x74, 0x11
  cmp [di + 2], ax                             ; 0283A  0x39, 0x45, 0x02
  jne loc_02833                                ; 0283D  0x75, 0xF4
  cmp [di + 4], bx                             ; 0283F  0x39, 0x5D, 0x04
  jbe loc_02854                                ; 02842  0x76, 0x10
  mov cx, 3                                    ; 02844  0xB9, 0x03, 0x00
  mov bx, 0xffff                               ; 02847  0xBB, 0xFF, 0xFF
  ret                                          ; 0284A  0xC3

loc_0284B:  ; 0284B
  call io_const_rtm_helper                     ; 0284B  0xE8, 0x15, 0x00
  jcxz loc_02854                               ; 0284E  0xE3, 0x04
  mov bx, 0xffff                               ; 02850  0xBB, 0xFF, 0xFF
  ret                                          ; 02853  0xC3

loc_02854:  ; 02854
  push ds                                      ; 02854  0x1E
  mov ds, [es:0x2e]                            ; 02855  0x26, 0x8E, 0x1E, 0x2E, 0x00
  mov [si + 2], dx                             ; 0285A  0x89, 0x54, 0x02
  mov [si], ax                                 ; 0285D  0x89, 0x04
  pop ds                                       ; 0285F  0x1F
  db 0x2B, 0xDB                               ; 02860  sub bx, bx
  ret                                          ; 02862  0xC3

io_const_rtm_helper:  ; 02863
  push si                                      ; 02863  0x56
  db 0x2B, 0xC9                               ; 02864  sub cx, cx
  push cx                                      ; 02866  0x51
  push cx                                      ; 02867  0x51
  push dx                                      ; 02868  0x52
  push bx                                      ; 02869  0x53
  push ax                                      ; 0286A  0x50
  db 0x8B, 0xD4                               ; 0286B  mov dx, sp
  push ds                                      ; 0286D  0x1E
  mov cx, ss                                   ; 0286E  0x8C, 0xD1
  mov ds, cx                                   ; 02870  0x8E, 0xD9
  mov cx, 0x80                                 ; 02872  0xB9, 0x80, 0x00
  call rtm_call_0x80_entry                     ; 02875  0xE8, 0x1B, 0xFF
  pop ds                                       ; 02878  0x1F
  pop ax                                       ; 02879  0x58
  pop dx                                       ; 0287A  0x5A
  pop bx                                       ; 0287B  0x5B
  pop bx                                       ; 0287C  0x5B
  pop bx                                       ; 0287D  0x5B
  pop si                                       ; 0287E  0x5E
  ret                                          ; 0287F  0xC3

mem_fn04_cpmfree:  ; 02880
  push ds                                      ; 02880  0x1E
  mov ds, [es:0x2e]                            ; 02881  0x26, 0x8E, 0x1E, 0x2E, 0x00
  db 0x8B, 0xF2                               ; 02886  mov si, dx
  mov al, [si + 4]                             ; 02888  0x8A, 0x44, 0x04
  mov dx, [si]                                 ; 0288B  0x8B, 0x14
  pop ds                                       ; 0288D  0x1F
  cmp al, 0xff                                 ; 0288E  0x3C, 0xFF
  jne mem_free_memory                                ; 02890  0x75, 0x2A

loc_02892:  ; 02892
  mov bx, [0x68]                               ; 02892  0x8B, 0x1E, 0x68, 0x00
  add bx, 0x16                                 ; 02896  0x83, 0xC3, 0x16

loc_02899:  ; 02899
  mov si, [bx]                                 ; 02899  0x8B, 0x37
  cmp si, 0                                    ; 0289B  0x83, 0xFE, 0x00
  jne loc_028A5                                ; 0289E  0x75, 0x05
  db 0x2B, 0xDB                               ; 028A0  sub bx, bx
  db 0x8B, 0xCB                               ; 028A2  mov cx, bx
  ret                                          ; 028A4  0xC3

loc_028A5:  ; 028A5
  test word [si + 6], 1                        ; 028A5  0xF7, 0x44, 0x06, 0x01, 0x00
  je loc_028B0                                 ; 028AA  0x74, 0x04
  db 0x8B, 0xDE                               ; 028AC  mov bx, si
  jmp short loc_02899                          ; 028AE  0xEB, 0xE9

loc_028B0:  ; 028B0
  mov dx, [si + 2]                             ; 028B0  0x8B, 0x54, 0x02
  push si                                      ; 028B3  0x56
  call mem_free_memory                               ; 028B4  0xE8, 0x05, 0x00
  pop si                                       ; 028B7  0x5E
  jcxz loc_02892                               ; 028B8  0xE3, 0xD8
  jmp short loc_02899                          ; 028BA  0xEB, 0xDD

mem_free_memory:  ; 028BC
  push ds                                      ; 028BC  0x1E
  push ss                                      ; 028BD  0x16
  pop ds                                       ; 028BE  0x1F
  db 0x2B, 0xC9                               ; 028BF  sub cx, cx
  push cx                                      ; 028C1  0x51
  push dx                                      ; 028C2  0x52
  db 0x8B, 0xD4                               ; 028C3  mov dx, sp
  mov cx, 0x82                                 ; 028C5  0xB9, 0x82, 0x00
  call rtm_call_0x80_entry                     ; 028C8  0xE8, 0xC8, 0xFE
  pop dx                                       ; 028CB  0x5A
  pop dx                                       ; 028CC  0x5A
  pop ds                                       ; 028CD  0x1F
  ret                                          ; 028CE  0xC3

mem_fn05_freeall:  ; 028CF
  mov si, [0x68]                               ; 028CF  0x8B, 0x36, 0x68, 0x00
  mov ax, [si + 0x10]                          ; 028D3  0x8B, 0x44, 0x10
  add si, 0x16                                 ; 028D6  0x83, 0xC6, 0x16

loc_028D9:  ; 028D9
  mov si, [si]                                 ; 028D9  0x8B, 0x34
  cmp si, 0                                    ; 028DB  0x83, 0xFE, 0x00
  je loc_02926                                 ; 028DE  0x74, 0x46
  mov bx, [si + 2]                             ; 028E0  0x8B, 0x5C, 0x02
  db 0x3B, 0xD8                               ; 028E3  cmp bx, ax
  ja loc_0291F                                 ; 028E5  0x77, 0x38
  db 0x8B, 0xCB                               ; 028E7  mov cx, bx
  add cx, [si + 4]                             ; 028E9  0x03, 0x4C, 0x04
  db 0x3B, 0xC8                               ; 028EC  cmp cx, ax
  jb loc_0291F                                 ; 028EE  0x72, 0x2F
  test word [si + 6], 0x40                     ; 028F0  0xF7, 0x44, 0x06, 0x40, 0x00
  jne loc_028D9                                ; 028F5  0x75, 0xE2
  or word [si + 6], strict word 0x40          ; 028F7  81 4C 06 40 00
  mov bx, [0x68]                               ; 028FC  0x8B, 0x1E, 0x68, 0x00
  test word [bx + 6], 0x8000                   ; 02900  0xF7, 0x47, 0x06, 0x00, 0x80
  je loc_0290D                                 ; 02905  0x74, 0x06
  add ax, strict word 0x1c                    ; 02907  05 1C 00
  jmp near loc_0291D                           ; 0290A  0xE9, 0x10, 0x00

loc_0290D:  ; 0290D
  test word [bx + 0x26], 2                     ; 0290D  0xF7, 0x47, 0x26, 0x02, 0x00
  je loc_0291A                                 ; 02912  0x74, 0x06
  add ax, strict word 0x1a                    ; 02914  05 1A 00
  jmp near loc_0291D                           ; 02917  0xE9, 0x03, 0x00

loc_0291A:  ; 0291A
  add ax, strict word 0x16                    ; 0291A  05 16 00

loc_0291D:  ; 0291D
  db 0x8B, 0xD8                               ; 0291D  mov bx, ax

loc_0291F:  ; 0291F
  db 0x8B, 0xD3                               ; 0291F  mov dx, bx
  call mem_free_memory                               ; 02921  0xE8, 0x98, 0xFF
  jmp short mem_fn05_freeall                   ; 02924  0xEB, 0xA9

loc_02926:  ; 02926
  db 0x33, 0xDB                               ; 02926  xor bx, bx
  db 0x8B, 0xCB                               ; 02928  mov cx, bx
  ret                                          ; 0292A  0xC3

mem_fn06_malloc:  ; 0292B
  push dx                                      ; 0292B  0x52
  call mem_getmd                               ; 0292C  0xE8, 0xF6, 0x07
  pop dx                                       ; 0292F  0x5A
  jcxz loc_02936                               ; 02930  0xE3, 0x04
  mov bx, 0xffff                               ; 02932  0xBB, 0xFF, 0xFF
  ret                                          ; 02935  0xC3

loc_02936:  ; 02936
  push es                                      ; 02936  0x06
  mov es, [es:0x2e]                            ; 02937  0x26, 0x8E, 0x06, 0x2E, 0x00
  db 0x8B, 0xFA                               ; 0293C  mov di, dx
  mov ax, [es:di + 6]                          ; 0293E  0x26, 0x8B, 0x45, 0x06
  cmp ax, strict word 0                       ; 02942  3D 00 00
  jne loc_0294E                                ; 02945  0x75, 0x07
  mov ax, [0x68]                               ; 02947  0xA1, 0x68, 0x00
  mov [es:di + 6], ax                          ; 0294A  0x26, 0x89, 0x45, 0x06

loc_0294E:  ; 0294E
  pop es                                       ; 0294E  0x07
  cmp ax, [0x68]                               ; 0294F  0x3B, 0x06, 0x68, 0x00
  je loc_0299D                                 ; 02953  0x74, 0x48
  push ax                                      ; 02955  0x50
  push bx                                      ; 02956  0x53
  push dx                                      ; 02957  0x52
  push di                                      ; 02958  0x57
  mov bx, 0x70d                                ; 02959  0xBB, 0x0D, 0x07
  mov cx, 0x215                                ; 0295C  0xB9, 0x15, 0x02
  call rtm_call_0x80_entry                     ; 0295F  0xE8, 0x31, 0xFE
  pop di                                       ; 02962  0x5F
  pop dx                                       ; 02963  0x5A
  pop bx                                       ; 02964  0x5B
  pop ax                                       ; 02965  0x58
  mov si, 0x70                                 ; 02966  0xBE, 0x70, 0x00

loc_02969:  ; 02969
  mov si, [si + 2]                             ; 02969  0x8B, 0x74, 0x02
  cmp si, 0                                    ; 0296C  0x83, 0xFE, 0x00
  je loc_0298C                                 ; 0296F  0x74, 0x1B
  db 0x3B, 0xF0                               ; 02971  cmp si, ax
  jne loc_02969                                ; 02973  0x75, 0xF4
  cmp si, [0x68]                               ; 02975  0x3B, 0x36, 0x68, 0x00
  je loc_0298C                                 ; 02979  0x74, 0x11
  mov cx, 0x22                                 ; 0297B  0xB9, 0x22, 0x00
  push bx                                      ; 0297E  0x53
  mov bx, 0x70d                                ; 0297F  0xBB, 0x0D, 0x07
  mov cx, 0x216                                ; 02982  0xB9, 0x16, 0x02
  call rtm_call_0x80_entry                     ; 02985  0xE8, 0x0B, 0xFE
  pop bx                                       ; 02988  0x5B
  jmp near loc_029D4                           ; 02989  0xE9, 0x48, 0x00

loc_0298C:  ; 0298C
  push ax                                      ; 0298C  0x50
  push bx                                      ; 0298D  0x53
  push dx                                      ; 0298E  0x52
  push di                                      ; 0298F  0x57
  mov bx, 0x70d                                ; 02990  0xBB, 0x0D, 0x07
  mov cx, 0x216                                ; 02993  0xB9, 0x16, 0x02
  call rtm_call_0x80_entry                     ; 02996  0xE8, 0xFA, 0xFD
  pop di                                       ; 02999  0x5F
  pop dx                                       ; 0299A  0x5A
  pop bx                                       ; 0299B  0x5B
  pop ax                                       ; 0299C  0x58

loc_0299D:  ; 0299D
  push es                                      ; 0299D  0x06
  mov es, [es:0x2e]                            ; 0299E  0x26, 0x8E, 0x06, 0x2E, 0x00
  mov cx, [es:di + 2]                          ; 029A3  0x26, 0x8B, 0x4D, 0x02
  cmp cx, [es:di + 4]                          ; 029A7  0x26, 0x3B, 0x4D, 0x04
  jbe loc_029B1                                ; 029AB  0x76, 0x04
  mov [es:di + 4], cx                          ; 029AD  0x26, 0x89, 0x4D, 0x04

loc_029B1:  ; 029B1
  db 0x8B, 0xF0                               ; 029B1  mov si, ax
  add si, 0x16                                 ; 029B3  0x83, 0xC6, 0x16
  db 0x2B, 0xC9                               ; 029B6  sub cx, cx
  push si                                      ; 029B8  0x56

loc_029B9:  ; 029B9
  mov si, [si]                                 ; 029B9  0x8B, 0x34
  cmp si, 0                                    ; 029BB  0x83, 0xFE, 0x00
  je loc_029C5                                 ; 029BE  0x74, 0x05
  add cx, [si + 4]                             ; 029C0  0x03, 0x4C, 0x04
  jmp short loc_029B9                          ; 029C3  0xEB, 0xF4

loc_029C5:  ; 029C5
  pop si                                       ; 029C5  0x5E
  mov ax, [0x4c]                               ; 029C6  0xA1, 0x4C, 0x00
  db 0x2B, 0xC1                               ; 029C9  sub ax, cx
  cmp ax, strict word 0                       ; 029CB  3D 00 00
  jne loc_029DB                                ; 029CE  0x75, 0x0B

loc_029D0:  ; 029D0
  pop es                                       ; 029D0  0x07

loc_029D1:  ; 029D1
  mov cx, 3                                    ; 029D1  0xB9, 0x03, 0x00

loc_029D4:  ; 029D4
  call mem_freemd                               ; 029D4  0xE8, 0x71, 0x07
  mov bx, 0xffff                               ; 029D7  0xBB, 0xFF, 0xFF
  ret                                          ; 029DA  0xC3

loc_029DB:  ; 029DB
  cmp ax, [es:di + 2]                          ; 029DB  0x26, 0x3B, 0x45, 0x02
  jb loc_029D0                                 ; 029DF  0x72, 0xEF
  cmp ax, [es:di + 4]                          ; 029E1  0x26, 0x3B, 0x45, 0x04
  jae loc_029EB                                ; 029E5  0x73, 0x04
  mov [es:di + 4], ax                          ; 029E7  0x26, 0x89, 0x45, 0x04

loc_029EB:  ; 029EB
  push di                                      ; 029EB  0x57
  mov di, 0x65a                                ; 029EC  0xBF, 0x5A, 0x06
  mov cx, 0xb                                  ; 029EF  0xB9, 0x0B, 0x00
  db 0x2B, 0xC0                               ; 029F2  sub ax, ax
  mov es, [cs:6]                               ; 029F4  0x2E, 0x8E, 0x06, 0x06, 0x00
  rep stosw                                    ; 029F9  0xF3, 0xAB
  pop di                                       ; 029FB  0x5F
  db 0x2B, 0xC9                               ; 029FC  sub cx, cx
  pop es                                       ; 029FE  0x07

loc_029FF:  ; 029FF
  mov si, [si]                                 ; 029FF  0x8B, 0x34
  cmp si, 0                                    ; 02A01  0x83, 0xFE, 0x00
  je loc_02A21                                 ; 02A04  0x74, 0x1B
  cmp cx, [si + 8]                             ; 02A06  0x3B, 0x4C, 0x08
  je loc_029FF                                 ; 02A09  0x74, 0xF4
  push cx                                      ; 02A0B  0x51
  push dx                                      ; 02A0C  0x52
  push bx                                      ; 02A0D  0x53
  push si                                      ; 02A0E  0x56
  mov bx, [si + 8]                             ; 02A0F  0x8B, 0x5C, 0x08
  call mem_try_mau                               ; 02A12  0xE8, 0xCB, 0x00
  pop si                                       ; 02A15  0x5E
  pop bx                                       ; 02A16  0x5B
  pop dx                                       ; 02A17  0x5A
  cmp cx, 0                                    ; 02A18  0x83, 0xF9, 0x00
  pop cx                                       ; 02A1B  0x59
  jne loc_029FF                                ; 02A1C  0x75, 0xE1
  jmp near loc_02A50                           ; 02A1E  0xE9, 0x2F, 0x00

loc_02A21:  ; 02A21
  push bx                                      ; 02A21  0x53
  push dx                                      ; 02A22  0x52
  mov ds, [es:0x2e]                            ; 02A23  0x26, 0x8E, 0x1E, 0x2E, 0x00
  mov bx, 0x5a                                 ; 02A28  0xBB, 0x5A, 0x00
  mov cx, 0x30b                                ; 02A2B  0xB9, 0x0B, 0x03
  call rtm_call_0x80_entry                     ; 02A2E  0xE8, 0x62, 0xFD
  mov ds, [cs:6]                               ; 02A31  0x2E, 0x8E, 0x1E, 0x06, 0x00
  jcxz loc_02A3D                               ; 02A36  0xE3, 0x05
  pop dx                                       ; 02A38  0x5A
  pop bx                                       ; 02A39  0x5B
  jmp near loc_02A50                           ; 02A3A  0xE9, 0x13, 0x00

loc_02A3D:  ; 02A3D
  mov si, [0x76]                               ; 02A3D  0x8B, 0x36, 0x76, 0x00
  mov [bx], si                                 ; 02A41  0x89, 0x37
  mov [0x76], bx                               ; 02A43  0x89, 0x1E, 0x76, 0x00
  pop dx                                       ; 02A47  0x5A
  push dx                                      ; 02A48  0x52
  db 0x2B, 0xF6                               ; 02A49  sub si, si
  call mem_try_mau                               ; 02A4B  0xE8, 0x92, 0x00
  pop dx                                       ; 02A4E  0x5A
  pop bx                                       ; 02A4F  0x5B

loc_02A50:  ; 02A50
  cmp word [0x65a], 0                          ; 02A50  0x83, 0x3E, 0x5A, 0x06, 0x00
  jne loc_02A97                                ; 02A55  0x75, 0x40
  pushf                                        ; 02A57  0x9C
  cli                                          ; 02A58  0xFA
  mov di, [0x70]                               ; 02A59  0x8B, 0x3E, 0x70, 0x00
  cmp di, 0                                    ; 02A5D  0x83, 0xFF, 0x00
  jne loc_02A66                                ; 02A60  0x75, 0x04
  popf                                         ; 02A62  0x9D
  jmp near loc_029D1                           ; 02A63  0xE9, 0x6B, 0xFF

loc_02A66:  ; 02A66
  mov ax, [di + 2]                             ; 02A66  0x8B, 0x45, 0x02
  mov [0x70], ax                               ; 02A69  0xA3, 0x70, 0x00
  popf                                         ; 02A6C  0x9D
  push bx                                      ; 02A6D  0x53
  push dx                                      ; 02A6E  0x52
  mov bx, [di + 0x16]                          ; 02A6F  0x8B, 0x5D, 0x16
  push di                                      ; 02A72  0x57
  push ds                                      ; 02A73  0x1E
  push di                                      ; 02A74  0x57
  push word [bx + 2]                           ; 02A75  0xFF, 0x77, 0x02
  push ss                                      ; 02A78  0x16
  pop ds                                       ; 02A79  0x1F
  db 0x8B, 0xD4                               ; 02A7A  mov dx, sp
  mov cx, 0x82                                 ; 02A7C  0xB9, 0x82, 0x00
  call rtm_call_0x80_entry                     ; 02A7F  0xE8, 0x11, 0xFD
  pop ax                                       ; 02A82  0x58
  pop ax                                       ; 02A83  0x58
  pop ds                                       ; 02A84  0x1F
  pop di                                       ; 02A85  0x5F
  pushf                                        ; 02A86  0x9C
  cli                                          ; 02A87  0xFA
  mov ax, [0x5c]                               ; 02A88  0xA1, 0x5C, 0x00
  mov [di], ax                                 ; 02A8B  0x89, 0x05
  mov [0x5c], di                               ; 02A8D  0x89, 0x3E, 0x5C, 0x00
  popf                                         ; 02A91  0x9D
  pop dx                                       ; 02A92  0x5A
  pop bx                                       ; 02A93  0x5B
  jmp near loc_02A21                           ; 02A94  0xE9, 0x8A, 0xFF

loc_02A97:  ; 02A97
  push es                                      ; 02A97  0x06
  mov es, [es:0x2e]                            ; 02A98  0x26, 0x8E, 0x06, 0x2E, 0x00
  db 0x8B, 0xFA                               ; 02A9D  mov di, dx
  mov ax, [0x65a]                              ; 02A9F  0xA1, 0x5A, 0x06
  mov [es:di], ax                              ; 02AA2  0x26, 0x89, 0x05
  mov [bx + 2], ax                             ; 02AA5  0x89, 0x47, 0x02
  mov ax, [0x65c]                              ; 02AA8  0xA1, 0x5C, 0x06
  mov [es:di + 2], ax                          ; 02AAB  0x26, 0x89, 0x45, 0x02
  mov [es:di + 4], ax                          ; 02AAF  0x26, 0x89, 0x45, 0x04
  mov [bx + 4], ax                             ; 02AB3  0x89, 0x47, 0x04
  mov ax, [es:di + 8]                          ; 02AB6  0x26, 0x8B, 0x45, 0x08
  mov [bx + 6], ax                             ; 02ABA  0x89, 0x47, 0x06
  mov si, [0x65e]                              ; 02ABD  0x8B, 0x36, 0x5E, 0x06
  cmp si, 0                                    ; 02AC1  0x83, 0xFE, 0x00
  jne loc_02ACD                                ; 02AC4  0x75, 0x07
  mov si, [es:di + 6]                          ; 02AC6  0x26, 0x8B, 0x75, 0x06
  add si, 0x16                                 ; 02ACA  0x83, 0xC6, 0x16

loc_02ACD:  ; 02ACD
  mov ax, [si]                                 ; 02ACD  0x8B, 0x04
  mov [bx], ax                                 ; 02ACF  0x89, 0x07
  mov [si], bx                                 ; 02AD1  0x89, 0x1C
  mov di, [0x660]                              ; 02AD3  0x8B, 0x3E, 0x60, 0x06
  mov [bx + 8], di                             ; 02AD7  0x89, 0x7F, 0x08
  pop es                                       ; 02ADA  0x07
  db 0x2B, 0xC9                               ; 02ADB  sub cx, cx
  db 0x8B, 0xD9                               ; 02ADD  mov bx, cx
  ret                                          ; 02ADF  0xC3

mem_try_mau:  ; 02AE0
  mov [0x664], si                              ; 02AE0  0x89, 0x36, 0x64, 0x06
  mov [0x662], bx                              ; 02AE4  0x89, 0x1E, 0x62, 0x06
  push dx                                      ; 02AE8  0x52
  push ds                                      ; 02AE9  0x1E
  push es                                      ; 02AEA  0x06
  mov ds, [es:0x2e]                            ; 02AEB  0x26, 0x8E, 0x1E, 0x2E, 0x00
  mov es, [cs:6]                               ; 02AF0  0x2E, 0x8E, 0x06, 0x06, 0x00
  db 0x8B, 0xF2                               ; 02AF5  mov si, dx
  mov di, 0x666                                ; 02AF7  0xBF, 0x66, 0x06
  mov cx, 5                                    ; 02AFA  0xB9, 0x05, 0x00
  rep movsw                                    ; 02AFD  0xF3, 0xA5
  pop es                                       ; 02AFF  0x07
  pop ds                                       ; 02B00  0x1F
  mov dx, 0x666                                ; 02B01  0xBA, 0x66, 0x06
  mov cx, 0x309                                ; 02B04  0xB9, 0x09, 0x03
  call rtm_call_0x80_entry                     ; 02B07  0xE8, 0x89, 0xFC
  pop di                                       ; 02B0A  0x5F
  jcxz loc_02B0E                               ; 02B0B  0xE3, 0x01
  ret                                          ; 02B0D  0xC3

loc_02B0E:  ; 02B0E
  push es                                      ; 02B0E  0x06
  mov es, [es:0x2e]                            ; 02B0F  0x26, 0x8E, 0x06, 0x2E, 0x00
  mov si, 0x666                                ; 02B14  0xBE, 0x66, 0x06
  mov ax, [si + 4]                             ; 02B17  0x8B, 0x44, 0x04
  db 0x2B, 0xC9                               ; 02B1A  sub cx, cx
  cmp ax, [es:di + 4]                          ; 02B1C  0x26, 0x3B, 0x45, 0x04
  pop es                                       ; 02B20  0x07
  je loc_02B32                                 ; 02B21  0x74, 0x0F
  mov cx, 3                                    ; 02B23  0xB9, 0x03, 0x00
  mov bx, [0x662]                              ; 02B26  0x8B, 0x1E, 0x62, 0x06
  db 0x8B, 0xFE                               ; 02B2A  mov di, si
  cmp ax, [0x65c]                              ; 02B2C  0x3B, 0x06, 0x5C, 0x06
  jbe mem_take_scl                                ; 02B30  0x76, 0x25

loc_02B32:  ; 02B32
  mov di, 0x65a                                ; 02B32  0xBF, 0x5A, 0x06
  mov bx, [0x660]                              ; 02B35  0x8B, 0x1E, 0x60, 0x06
  call mem_take_scl                               ; 02B39  0xE8, 0x1B, 0x00
  mov si, 0x666                                ; 02B3C  0xBE, 0x66, 0x06
  mov ax, [si]                                 ; 02B3F  0x8B, 0x04
  mov [0x65a], ax                              ; 02B41  0xA3, 0x5A, 0x06
  mov ax, [si + 4]                             ; 02B44  0x8B, 0x44, 0x04
  mov [0x65c], ax                              ; 02B47  0xA3, 0x5C, 0x06
  mov ax, [0x662]                              ; 02B4A  0xA1, 0x62, 0x06
  mov [0x660], ax                              ; 02B4D  0xA3, 0x60, 0x06
  mov ax, [0x664]                              ; 02B50  0xA1, 0x64, 0x06
  mov [0x65e], ax                              ; 02B53  0xA3, 0x5E, 0x06

loc_02B56:  ; 02B56
  ret                                          ; 02B56  0xC3

mem_take_scl:  ; 02B57
  cmp word [di], 0                             ; 02B57  0x83, 0x3D, 0x00
  je loc_02B56                                 ; 02B5A  0x74, 0xFA
  push cx                                      ; 02B5C  0x51
  push ds                                      ; 02B5D  0x1E
  push word [di]                               ; 02B5E  0xFF, 0x35
  push word [di]                               ; 02B60  0xFF, 0x35
  push bx                                      ; 02B62  0x53
  push ss                                      ; 02B63  0x16
  pop ds                                       ; 02B64  0x1F
  db 0x8B, 0xD4                               ; 02B65  mov dx, sp
  mov cx, 0x30a                                ; 02B67  0xB9, 0x0A, 0x03
  call rtm_call_0x80_entry                     ; 02B6A  0xE8, 0x26, 0xFC
  cmp cx, 0                                    ; 02B6D  0x83, 0xF9, 0x00
  jne loc_02B9B                                ; 02B70  0x75, 0x29
  cmp bx, -1                                   ; 02B72  0x83, 0xFB, 0xFF
  jne loc_02B9B                                ; 02B75  0x75, 0x24
  pop bx                                       ; 02B77  0x5B
  pop ax                                       ; 02B78  0x58
  pop ax                                       ; 02B79  0x58
  pop ds                                       ; 02B7A  0x1F
  db 0x8B, 0xC3                               ; 02B7B  mov ax, bx
  mov bx, 0x76                                 ; 02B7D  0xBB, 0x76, 0x00

loc_02B80:  ; 02B80
  db 0x8B, 0xF3                               ; 02B80  mov si, bx
  mov bx, [si]                                 ; 02B82  0x8B, 0x1C
  db 0x3B, 0xD8                               ; 02B84  cmp bx, ax
  jne loc_02B80                                ; 02B86  0x75, 0xF8
  push ax                                      ; 02B88  0x50
  mov ax, [bx]                                 ; 02B89  0x8B, 0x07
  mov [si], ax                                 ; 02B8B  0x89, 0x04
  pop bx                                       ; 02B8D  0x5B
  mov cx, 0x30c                                ; 02B8E  0xB9, 0x0C, 0x03
  db 0x8B, 0xD3                               ; 02B91  mov dx, bx
  mov bx, 0x5a                                 ; 02B93  0xBB, 0x5A, 0x00
  call rtm_call_0x80_entry                     ; 02B96  0xE8, 0xFA, 0xFB
  pop cx                                       ; 02B99  0x59
  ret                                          ; 02B9A  0xC3

loc_02B9B:  ; 02B9B
  pop bx                                       ; 02B9B  0x5B
  pop ax                                       ; 02B9C  0x58
  pop ax                                       ; 02B9D  0x58
  pop ds                                       ; 02B9E  0x1F
  pop cx                                       ; 02B9F  0x59
  ret                                          ; 02BA0  0xC3

mem_fn07_mfree:  ; 02BA1
  push es                                      ; 02BA1  0x06
  mov es, [es:0x2e]                            ; 02BA2  0x26, 0x8E, 0x06, 0x2E, 0x00
  db 0x8B, 0xF2                               ; 02BA7  mov si, dx
  mov bx, [es:si + 2]                          ; 02BA9  0x26, 0x8B, 0x5C, 0x02
  mov dx, [es:si]                              ; 02BAD  0x26, 0x8B, 0x14
  pop es                                       ; 02BB0  0x07
  cmp bx, 0                                    ; 02BB1  0x83, 0xFB, 0x00
  jne loc_02BBC                                ; 02BB4  0x75, 0x06
  mov bx, [0x68]                               ; 02BB6  0x8B, 0x1E, 0x68, 0x00
  jmp short loc_02BFB                          ; 02BBA  0xEB, 0x3F

loc_02BBC:  ; 02BBC
  push bx                                      ; 02BBC  0x53
  push dx                                      ; 02BBD  0x52
  mov bx, 0x70d                                ; 02BBE  0xBB, 0x0D, 0x07
  mov cx, 0x215                                ; 02BC1  0xB9, 0x15, 0x02
  call rtm_call_0x80_entry                     ; 02BC4  0xE8, 0xCC, 0xFB
  pop dx                                       ; 02BC7  0x5A
  pop bx                                       ; 02BC8  0x5B
  mov si, 0x70                                 ; 02BC9  0xBE, 0x70, 0x00

loc_02BCC:  ; 02BCC
  mov si, [si + 2]                             ; 02BCC  0x8B, 0x74, 0x02
  cmp si, 0                                    ; 02BCF  0x83, 0xFE, 0x00
  je loc_02BEE                                 ; 02BD2  0x74, 0x1A
  db 0x3B, 0xF3                               ; 02BD4  cmp si, bx
  jne loc_02BCC                                ; 02BD6  0x75, 0xF4
  cmp si, [0x68]                               ; 02BD8  0x3B, 0x36, 0x68, 0x00
  je loc_02BEE                                 ; 02BDC  0x74, 0x10
  mov bx, 0x70d                                ; 02BDE  0xBB, 0x0D, 0x07
  mov cx, 0x216                                ; 02BE1  0xB9, 0x16, 0x02
  call rtm_call_0x80_entry                     ; 02BE4  0xE8, 0xAC, 0xFB
  mov bx, 0xffff                               ; 02BE7  0xBB, 0xFF, 0xFF
  mov cx, 0x22                                 ; 02BEA  0xB9, 0x22, 0x00
  ret                                          ; 02BED  0xC3

loc_02BEE:  ; 02BEE
  push bx                                      ; 02BEE  0x53
  push dx                                      ; 02BEF  0x52
  mov bx, 0x70d                                ; 02BF0  0xBB, 0x0D, 0x07
  mov cx, 0x216                                ; 02BF3  0xB9, 0x16, 0x02
  call rtm_call_0x80_entry                     ; 02BF6  0xE8, 0x9A, 0xFB
  pop dx                                       ; 02BF9  0x5A
  pop bx                                       ; 02BFA  0x5B

loc_02BFB:  ; 02BFB
  lea si, [bx + 0x16]                          ; 02BFB  0x8D, 0x77, 0x16

loc_02BFE:  ; 02BFE
  db 0x8B, 0xDE                               ; 02BFE  mov bx, si
  mov si, [bx]                                 ; 02C00  0x8B, 0x37
  cmp si, 0                                    ; 02C02  0x83, 0xFE, 0x00
  je loc_02C29                                 ; 02C05  0x74, 0x22
  cmp [si + 2], dx                             ; 02C07  0x39, 0x54, 0x02
  je mem_free_mau_call                                 ; 02C0A  0x74, 0x24
  ja loc_02BFE                                 ; 02C0C  0x77, 0xF0
  mov ax, [si + 2]                             ; 02C0E  0x8B, 0x44, 0x02
  add ax, [si + 4]                             ; 02C11  0x03, 0x44, 0x04
  db 0x3B, 0xC2                               ; 02C14  cmp ax, dx
  jbe loc_02BFE                                ; 02C16  0x76, 0xE6
  push dx                                      ; 02C18  0x52
  push si                                      ; 02C19  0x56
  call mem_free_mau_call                               ; 02C1A  0xE8, 0x13, 0x00
  pop si                                       ; 02C1D  0x5E
  pop dx                                       ; 02C1E  0x5A
  cmp cx, 0                                    ; 02C1F  0x83, 0xF9, 0x00
  jne loc_02BFE                                ; 02C22  0x75, 0xDA

loc_02C24:  ; 02C24
  db 0x2B, 0xDB                               ; 02C24  sub bx, bx
  db 0x8B, 0xCB                               ; 02C26  mov cx, bx
  ret                                          ; 02C28  0xC3

loc_02C29:  ; 02C29
  mov bx, 0xffff                               ; 02C29  0xBB, 0xFF, 0xFF
  mov cx, 3                                    ; 02C2C  0xB9, 0x03, 0x00
  ret                                          ; 02C2F  0xC3

mem_free_mau_call:  ; 02C30
  push bx                                      ; 02C30  0x53
  push si                                      ; 02C31  0x56
  push dx                                      ; 02C32  0x52
  push dx                                      ; 02C33  0x52
  push word [si + 2]                           ; 02C34  0xFF, 0x74, 0x02
  push word [si + 8]                           ; 02C37  0xFF, 0x74, 0x08
  db 0x8B, 0xD4                               ; 02C3A  mov dx, sp
  push ss                                      ; 02C3C  0x16
  pop ds                                       ; 02C3D  0x1F
  mov cx, 0x30a                                ; 02C3E  0xB9, 0x0A, 0x03
  call rtm_call_0x80_entry                     ; 02C41  0xE8, 0x4F, 0xFB
  db 0x8B, 0xEB                               ; 02C44  mov bp, bx
  mov ds, [cs:6]                               ; 02C46  0x2E, 0x8E, 0x1E, 0x06, 0x00
  pop ax                                       ; 02C4B  0x58
  pop ax                                       ; 02C4C  0x58
  pop ax                                       ; 02C4D  0x58
  pop dx                                       ; 02C4E  0x5A
  pop si                                       ; 02C4F  0x5E
  pop bx                                       ; 02C50  0x5B
  cmp cx, 0                                    ; 02C51  0x83, 0xF9, 0x00
  jne loc_02C29                                ; 02C54  0x75, 0xD3
  cmp dx, [si + 2]                             ; 02C56  0x3B, 0x54, 0x02
  je loc_02C63                                 ; 02C59  0x74, 0x08
  sub dx, [si + 2]                             ; 02C5B  0x2B, 0x54, 0x02
  mov [si + 4], dx                             ; 02C5E  0x89, 0x54, 0x04
  jmp short loc_02C24                          ; 02C61  0xEB, 0xC1

loc_02C63:  ; 02C63
  mov ax, [si]                                 ; 02C63  0x8B, 0x04
  mov [bx], ax                                 ; 02C65  0x89, 0x07
  push word [si + 8]                           ; 02C67  0xFF, 0x74, 0x08
  push bp                                      ; 02C6A  0x55
  db 0x8B, 0xDE                               ; 02C6B  mov bx, si
  call mem_freemd                               ; 02C6D  0xE8, 0xD8, 0x04
  pop bp                                       ; 02C70  0x5D
  pop dx                                       ; 02C71  0x5A
  cmp bp, 0                                    ; 02C72  0x83, 0xFD, 0x00
  je loc_02C24                                 ; 02C75  0x74, 0xAD
  mov di, 0x76                                 ; 02C77  0xBF, 0x76, 0x00

loc_02C7A:  ; 02C7A
  db 0x8B, 0xF7                               ; 02C7A  mov si, di
  mov di, [si]                                 ; 02C7C  0x8B, 0x3C
  db 0x3B, 0xFA                               ; 02C7E  cmp di, dx
  jne loc_02C7A                                ; 02C80  0x75, 0xF8
  mov ax, [di]                                 ; 02C82  0x8B, 0x05
  mov [si], ax                                 ; 02C84  0x89, 0x04
  mov word [di], 0                             ; 02C86  0xC7, 0x05, 0x00, 0x00
  mov bx, 0x5a                                 ; 02C8A  0xBB, 0x5A, 0x00
  mov cx, 0x30c                                ; 02C8D  0xB9, 0x0C, 0x03
  jmp near rtm_call_0x80_entry                 ; 02C90  0xE9, 0x00, 0xFB

mem_fn08_share:  ; 02C93
  push dx                                      ; 02C93  0x52
  call mem_getmd                               ; 02C94  0xE8, 0x8E, 0x04
  pop dx                                       ; 02C97  0x5A
  jcxz loc_02C9D                               ; 02C98  0xE3, 0x03
  jmp near loc_02D31                           ; 02C9A  0xE9, 0x94, 0x00

loc_02C9D:  ; 02C9D
  db 0x8B, 0xEB                               ; 02C9D  mov bp, bx
  push ds                                      ; 02C9F  0x1E
  mov ds, [es:0x2e]                            ; 02CA0  0x26, 0x8E, 0x1E, 0x2E, 0x00
  db 0x8B, 0xFA                               ; 02CA5  mov di, dx
  mov bx, [di]                                 ; 02CA7  0x8B, 0x1D
  mov si, [di + 2]                             ; 02CA9  0x8B, 0x75, 0x02
  mov dx, [di + 4]                             ; 02CAC  0x8B, 0x55, 0x04
  pop ds                                       ; 02CAF  0x1F
  cmp bx, 0                                    ; 02CB0  0x83, 0xFB, 0x00
  jne loc_02CB9                                ; 02CB3  0x75, 0x04
  mov bx, [0x68]                               ; 02CB5  0x8B, 0x1E, 0x68, 0x00

loc_02CB9:  ; 02CB9
  cmp si, 0                                    ; 02CB9  0x83, 0xFE, 0x00
  jne loc_02CC2                                ; 02CBC  0x75, 0x04
  mov si, [0x68]                               ; 02CBE  0x8B, 0x36, 0x68, 0x00

loc_02CC2:  ; 02CC2
  db 0x3B, 0xF3                               ; 02CC2  cmp si, bx
  je loc_02D35                                 ; 02CC4  0x74, 0x6F
  lea di, [bx + 0x16]                          ; 02CC6  0x8D, 0x7F, 0x16

loc_02CC9:  ; 02CC9
  mov di, [di]                                 ; 02CC9  0x8B, 0x3D
  cmp di, 0                                    ; 02CCB  0x83, 0xFF, 0x00
  je loc_02D2E                                 ; 02CCE  0x74, 0x5E
  cmp [di + 2], dx                             ; 02CD0  0x39, 0x55, 0x02
  jne loc_02CC9                                ; 02CD3  0x75, 0xF4
  db 0x8B, 0xDD                               ; 02CD5  mov bx, bp
  mov [bx + 2], dx                             ; 02CD7  0x89, 0x57, 0x02
  mov ax, [di + 4]                             ; 02CDA  0x8B, 0x45, 0x04
  mov [bx + 4], ax                             ; 02CDD  0x89, 0x47, 0x04
  mov ax, [di + 6]                             ; 02CE0  0x8B, 0x45, 0x06
  mov [bx + 6], ax                             ; 02CE3  0x89, 0x47, 0x06
  mov ax, [di + 8]                             ; 02CE6  0x8B, 0x45, 0x08
  mov [bx + 8], ax                             ; 02CE9  0x89, 0x47, 0x08
  db 0x8B, 0xFB                               ; 02CEC  mov di, bx
  db 0x8B, 0xD8                               ; 02CEE  mov bx, ax
  push ds                                      ; 02CF0  0x1E
  mov ds, [bx + 2]                             ; 02CF1  0x8E, 0x5F, 0x02
  db 0x2B, 0xDB                               ; 02CF4  sub bx, bx
  mov cl, [0]                                  ; 02CF6  0x8A, 0x0E, 0x00, 0x00

loc_02CFA:  ; 02CFA
  cmp cl, 0                                    ; 02CFA  0x80, 0xF9, 0x00
  je loc_02D28                                 ; 02CFD  0x74, 0x29
  add bx, 5                                    ; 02CFF  0x83, 0xC3, 0x05
  dec cl                                       ; 02D02  0xFE, 0xC9
  cmp [bx], dx                                 ; 02D04  0x39, 0x17
  jne loc_02CFA                                ; 02D06  0x75, 0xF2
  inc byte [bx + 4]                            ; 02D08  0xFE, 0x47, 0x04
  pop ds                                       ; 02D0B  0x1F
  lea bx, [si + 0x16]                          ; 02D0C  0x8D, 0x5C, 0x16
  mov dx, [di + 8]                             ; 02D0F  0x8B, 0x55, 0x08

loc_02D12:  ; 02D12
  mov si, [bx]                                 ; 02D12  0x8B, 0x37
  cmp si, 0                                    ; 02D14  0x83, 0xFE, 0x00
  je loc_02D22                                 ; 02D17  0x74, 0x09
  cmp dx, [si + 8]                             ; 02D19  0x3B, 0x54, 0x08
  je loc_02D22                                 ; 02D1C  0x74, 0x04
  db 0x8B, 0xDE                               ; 02D1E  mov bx, si
  jmp short loc_02D12                          ; 02D20  0xEB, 0xF0

loc_02D22:  ; 02D22
  mov [di], si                                 ; 02D22  0x89, 0x35
  mov [bx], di                                 ; 02D24  0x89, 0x3F
  jmp short loc_02D35                          ; 02D26  0xEB, 0x0D

loc_02D28:  ; 02D28
  pop ds                                       ; 02D28  0x1F
  db 0x8B, 0xDD                               ; 02D29  mov bx, bp
  call mem_freemd                               ; 02D2B  0xE8, 0x1A, 0x04

loc_02D2E:  ; 02D2E
  mov cx, 3                                    ; 02D2E  0xB9, 0x03, 0x00

loc_02D31:  ; 02D31
  mov bx, 0xffff                               ; 02D31  0xBB, 0xFF, 0xFF
  ret                                          ; 02D34  0xC3

loc_02D35:  ; 02D35
  db 0x2B, 0xDB                               ; 02D35  sub bx, bx
  db 0x8B, 0xCB                               ; 02D37  mov cx, bx
  ret                                          ; 02D39  0xC3

mem_fn09_maualloc:  ; 02D3A
  push es                                      ; 02D3A  0x06
  mov es, [es:0x2e]                            ; 02D3B  0x26, 0x8E, 0x06, 0x2E, 0x00
  db 0x8B, 0xF2                               ; 02D40  mov si, dx
  mov cx, [es:si]                              ; 02D42  0x26, 0x8B, 0x0C
  cmp cx, 0                                    ; 02D45  0x83, 0xF9, 0x00
  je loc_02D58                                 ; 02D48  0x74, 0x0E
  mov ax, [bx + 2]                             ; 02D4A  0x8B, 0x47, 0x02
  db 0x3B, 0xC8                               ; 02D4D  cmp cx, ax
  jb loc_02D97                                 ; 02D4F  0x72, 0x46
  add ax, [bx + 4]                             ; 02D51  0x03, 0x47, 0x04
  db 0x3B, 0xC8                               ; 02D54  cmp cx, ax
  jae loc_02D97                                ; 02D56  0x73, 0x3F

loc_02D58:  ; 02D58
  mov ds, [bx + 2]                             ; 02D58  0x8E, 0x5F, 0x02

loc_02D5B:  ; 02D5B
  db 0x2B, 0xDB                               ; 02D5B  sub bx, bx
  db 0x8A, 0xD3                               ; 02D5D  mov dl, bl

loc_02D5F:  ; 02D5F
  inc dl                                       ; 02D5F  0xFE, 0xC2
  add bx, 5                                    ; 02D61  0x83, 0xC3, 0x05
  cmp dl, [0]                                  ; 02D64  0x3A, 0x16, 0x00, 0x00
  ja loc_02D97                                 ; 02D68  0x77, 0x2D
  cmp word [bx], 0                             ; 02D6A  0x83, 0x3F, 0x00
  je loc_02D97                                 ; 02D6D  0x74, 0x28
  cmp byte [bx + 4], 0                         ; 02D6F  0x80, 0x7F, 0x04, 0x00
  jne loc_02D5F                                ; 02D73  0x75, 0xEA
  mov cx, [es:si]                              ; 02D75  0x26, 0x8B, 0x0C
  cmp cx, 0                                    ; 02D78  0x83, 0xF9, 0x00
  je loc_02D9F                                 ; 02D7B  0x74, 0x22
  mov ax, [bx]                                 ; 02D7D  0x8B, 0x07
  db 0x3B, 0xC8                               ; 02D7F  cmp cx, ax
  jb loc_02D5F                                 ; 02D81  0x72, 0xDC
  add ax, [bx + 2]                             ; 02D83  0x03, 0x47, 0x02
  db 0x3B, 0xC8                               ; 02D86  cmp cx, ax
  jae loc_02D5F                                ; 02D88  0x73, 0xD5
  cmp cx, [bx]                                 ; 02D8A  0x3B, 0x0F
  je loc_02D9F                                 ; 02D8C  0x74, 0x11
  sub cx, [bx]                                 ; 02D8E  0x2B, 0x0F
  push si                                      ; 02D90  0x56
  call mem_mau_split                               ; 02D91  0xE8, 0xB6, 0x00
  pop si                                       ; 02D94  0x5E
  jmp short loc_02D5B                          ; 02D95  0xEB, 0xC4

loc_02D97:  ; 02D97
  mov bx, 0xffff                               ; 02D97  0xBB, 0xFF, 0xFF
  mov cx, 3                                    ; 02D9A  0xB9, 0x03, 0x00
  jmp short loc_02DE4                          ; 02D9D  0xEB, 0x45

loc_02D9F:  ; 02D9F
  mov cx, [es:si + 2]                          ; 02D9F  0x26, 0x8B, 0x4C, 0x02
  mov ax, [bx + 2]                             ; 02DA3  0x8B, 0x47, 0x02
  db 0x3B, 0xC8                               ; 02DA6  cmp cx, ax
  ja loc_02D5F                                 ; 02DA8  0x77, 0xB5
  mov cx, [es:si + 4]                          ; 02DAA  0x26, 0x8B, 0x4C, 0x04
  db 0x3B, 0xC8                               ; 02DAE  cmp cx, ax
  jae loc_02DC8                                ; 02DB0  0x73, 0x16
  cmp byte [bx + 4], 0                         ; 02DB2  0x80, 0x7F, 0x04, 0x00
  je loc_02DC3                                 ; 02DB6  0x74, 0x0B
  mov ax, [es:si + 8]                          ; 02DB8  0x26, 0x8B, 0x44, 0x08
  and ax, strict word 2                       ; 02DBC  25 02 00
  je loc_02D5F                                 ; 02DBF  0x74, 0x9E
  jmp short loc_02DC8                          ; 02DC1  0xEB, 0x05

loc_02DC3:  ; 02DC3
  push si                                      ; 02DC3  0x56
  call mem_mau_split                               ; 02DC4  0xE8, 0x83, 0x00
  pop si                                       ; 02DC7  0x5E

loc_02DC8:  ; 02DC8
  mov ax, [bx + 2]                             ; 02DC8  0x8B, 0x47, 0x02
  mov [es:si + 2], ax                          ; 02DCB  0x26, 0x89, 0x44, 0x02
  mov [es:si + 4], ax                          ; 02DCF  0x26, 0x89, 0x44, 0x04
  mov ax, [bx]                                 ; 02DD3  0x8B, 0x07
  mov [es:si], ax                              ; 02DD5  0x26, 0x89, 0x04
  inc byte [bx + 4]                            ; 02DD8  0xFE, 0x47, 0x04
  call mem_mau_collapse                               ; 02DDB  0xE8, 0x94, 0x00
  db 0x2B, 0xDB                               ; 02DDE  sub bx, bx
  db 0x8B, 0xCB                               ; 02DE0  mov cx, bx
  jmp short loc_02DE4                          ; 02DE2  0xEB, 0x00

loc_02DE4:  ; 02DE4
  mov ds, [cs:6]                               ; 02DE4  0x2E, 0x8E, 0x1E, 0x06, 0x00
  pop es                                       ; 02DE9  0x07
  ret                                          ; 02DEA  0xC3

mem_fn10_maufree:  ; 02DEB
  push es                                      ; 02DEB  0x06
  mov es, [es:0x2e]                            ; 02DEC  0x26, 0x8E, 0x06, 0x2E, 0x00
  db 0x8B, 0xF2                               ; 02DF1  mov si, dx
  mov bx, [es:si]                              ; 02DF3  0x26, 0x8B, 0x1C
  mov ds, [bx + 2]                             ; 02DF6  0x8E, 0x5F, 0x02
  db 0x2B, 0xDB                               ; 02DF9  sub bx, bx
  db 0x8B, 0xCB                               ; 02DFB  mov cx, bx
  mov dx, [es:si + 2]                          ; 02DFD  0x26, 0x8B, 0x54, 0x02

loc_02E01:  ; 02E01
  add bx, 5                                    ; 02E01  0x83, 0xC3, 0x05
  inc cx                                       ; 02E04  0x41
  cmp cx, [0]                                  ; 02E05  0x3B, 0x0E, 0x00, 0x00
  ja loc_02E3D                                 ; 02E09  0x77, 0x32
  cmp dx, [bx]                                 ; 02E0B  0x3B, 0x17
  jne loc_02E01                                ; 02E0D  0x75, 0xF2
  cmp dx, [es:si + 4]                          ; 02E0F  0x26, 0x3B, 0x54, 0x04
  je loc_02E35                                 ; 02E13  0x74, 0x20
  cmp byte [bx + 4], 1                         ; 02E15  0x80, 0x7F, 0x04, 0x01
  je loc_02E1D                                 ; 02E19  0x74, 0x02
  jmp short loc_02E43                          ; 02E1B  0xEB, 0x26

loc_02E1D:  ; 02E1D
  mov cx, [es:si + 4]                          ; 02E1D  0x26, 0x8B, 0x4C, 0x04
  mov ax, [bx]                                 ; 02E21  0x8B, 0x07
  add ax, [bx + 2]                             ; 02E23  0x03, 0x47, 0x02
  db 0x3B, 0xC1                               ; 02E26  cmp ax, cx
  jb loc_02E3D                                 ; 02E28  0x72, 0x13
  db 0x2B, 0xCA                               ; 02E2A  sub cx, dx
  call mem_mau_split                               ; 02E2C  0xE8, 0x1B, 0x00
  db 0x2B, 0xC9                               ; 02E2F  sub cx, cx
  db 0x8B, 0xD9                               ; 02E31  mov bx, cx
  jmp short loc_02E38                          ; 02E33  0xEB, 0x03

loc_02E35:  ; 02E35
  dec byte [bx + 4]                            ; 02E35  0xFE, 0x4F, 0x04

loc_02E38:  ; 02E38
  call mem_mau_collapse                               ; 02E38  0xE8, 0x37, 0x00
  jmp short loc_02E43                          ; 02E3B  0xEB, 0x06

loc_02E3D:  ; 02E3D
  mov bx, 0xffff                               ; 02E3D  0xBB, 0xFF, 0xFF
  mov cx, 3                                    ; 02E40  0xB9, 0x03, 0x00

loc_02E43:  ; 02E43
  pop es                                       ; 02E43  0x07
  mov ds, [cs:6]                               ; 02E44  0x2E, 0x8E, 0x1E, 0x06, 0x00
  ret                                          ; 02E49  0xC3

mem_mau_split:  ; 02E4A
  push bx                                      ; 02E4A  0x53
  push cx                                      ; 02E4B  0x51
  add bx, 5                                    ; 02E4C  0x83, 0xC3, 0x05
  call mem_mau_insert                               ; 02E4F  0xE8, 0xE2, 0x00
  cmp cx, 0                                    ; 02E52  0x83, 0xF9, 0x00
  pop cx                                       ; 02E55  0x59
  pop bx                                       ; 02E56  0x5B
  jne loc_02E6E                                ; 02E57  0x75, 0x15
  lea di, [bx + 5]                             ; 02E59  0x8D, 0x7F, 0x05
  mov dx, [bx + 2]                             ; 02E5C  0x8B, 0x57, 0x02
  db 0x2B, 0xD1                               ; 02E5F  sub dx, cx
  mov [di + 2], dx                             ; 02E61  0x89, 0x55, 0x02
  db 0x8B, 0xD1                               ; 02E64  mov dx, cx
  add dx, [bx]                                 ; 02E66  0x03, 0x17
  mov [di], dx                                 ; 02E68  0x89, 0x15
  mov byte [di + 4], 0                         ; 02E6A  0xC6, 0x45, 0x04, 0x00

loc_02E6E:  ; 02E6E
  mov [bx + 2], cx                             ; 02E6E  0x89, 0x4F, 0x02
  ret                                          ; 02E71  0xC3

mem_mau_collapse:  ; 02E72
  db 0x2B, 0xDB                               ; 02E72  sub bx, bx
  db 0x8B, 0xCB                               ; 02E74  mov cx, bx

loc_02E76:  ; 02E76
  inc cx                                       ; 02E76  0x41
  cmp cx, [0]                                  ; 02E77  0x3B, 0x0E, 0x00, 0x00
  je loc_02EE6                                 ; 02E7B  0x74, 0x69
  add bx, 5                                    ; 02E7D  0x83, 0xC3, 0x05
  lea di, [bx + 5]                             ; 02E80  0x8D, 0x7F, 0x05
  cmp word [bx], 0                             ; 02E83  0x83, 0x3F, 0x00
  je loc_02EE6                                 ; 02E86  0x74, 0x5E
  cmp word [di], 0                             ; 02E88  0x83, 0x3D, 0x00
  je loc_02EE6                                 ; 02E8B  0x74, 0x59
  cmp byte [bx + 4], 0                         ; 02E8D  0x80, 0x7F, 0x04, 0x00
  jne loc_02EBF                                ; 02E91  0x75, 0x2C
  mov ax, [bx]                                 ; 02E93  0x8B, 0x07
  add ax, [bx + 2]                             ; 02E95  0x03, 0x47, 0x02
  cmp ax, [di]                                 ; 02E98  0x3B, 0x05
  je loc_02EA3                                 ; 02E9A  0x74, 0x07
  mov ax, [di]                                 ; 02E9C  0x8B, 0x05
  sub ax, [bx]                                 ; 02E9E  0x2B, 0x07
  mov [bx + 2], ax                             ; 02EA0  0x89, 0x47, 0x02

loc_02EA3:  ; 02EA3
  cmp byte [di + 4], 0                         ; 02EA3  0x80, 0x7D, 0x04, 0x00
  jne loc_02E76                                ; 02EA7  0x75, 0xCD
  mov ax, [di + 2]                             ; 02EA9  0x8B, 0x45, 0x02
  add [bx + 2], ax                             ; 02EAC  0x01, 0x47, 0x02
  push bx                                      ; 02EAF  0x53
  push cx                                      ; 02EB0  0x51
  db 0x8B, 0xDF                               ; 02EB1  mov bx, di
  call mem_mau_release                               ; 02EB3  0xE8, 0x54, 0x00
  pop cx                                       ; 02EB6  0x59
  pop bx                                       ; 02EB7  0x5B
  sub bx, 5                                    ; 02EB8  0x83, 0xEB, 0x05
  dec cx                                       ; 02EBB  0x49
  jmp near loc_02E76                           ; 02EBC  0xE9, 0xB7, 0xFF

loc_02EBF:  ; 02EBF
  mov ax, [bx]                                 ; 02EBF  0x8B, 0x07
  add ax, [bx + 2]                             ; 02EC1  0x03, 0x47, 0x02
  cmp ax, [di]                                 ; 02EC4  0x3B, 0x05
  je loc_02E76                                 ; 02EC6  0x74, 0xAE
  cmp byte [di + 4], 0                         ; 02EC8  0x80, 0x7D, 0x04, 0x00
  je loc_02EDA                                 ; 02ECC  0x74, 0x0C
  push bx                                      ; 02ECE  0x53
  push cx                                      ; 02ECF  0x51
  db 0x8B, 0xFB                               ; 02ED0  mov di, bx
  call mem_mau_insert                               ; 02ED2  0xE8, 0x5F, 0x00
  pop cx                                       ; 02ED5  0x59
  pop bx                                       ; 02ED6  0x5B
  jmp near loc_02E76                           ; 02ED7  0xE9, 0x9C, 0xFF

loc_02EDA:  ; 02EDA
  mov ax, [di]                                 ; 02EDA  0x8B, 0x05
  sub ax, [bx]                                 ; 02EDC  0x2B, 0x07
  sub [di], ax                                 ; 02EDE  0x29, 0x05
  add [di + 2], ax                             ; 02EE0  0x01, 0x45, 0x02
  jmp near loc_02E76                           ; 02EE3  0xE9, 0x90, 0xFF

loc_02EE6:  ; 02EE6
  mov bp, 0xffff                               ; 02EE6  0xBD, 0xFF, 0xFF
  db 0x33, 0xC9                               ; 02EE9  xor cx, cx
  db 0x33, 0xDB                               ; 02EEB  xor bx, bx

loc_02EED:  ; 02EED
  inc cx                                       ; 02EED  0x41
  cmp cx, [0]                                  ; 02EEE  0x3B, 0x0E, 0x00, 0x00
  je loc_02F05                                 ; 02EF2  0x74, 0x11
  add bx, 5                                    ; 02EF4  0x83, 0xC3, 0x05
  cmp word [bx], 0                             ; 02EF7  0x83, 0x3F, 0x00
  je loc_02F05                                 ; 02EFA  0x74, 0x09
  cmp byte [bx + 4], 0                         ; 02EFC  0x80, 0x7F, 0x04, 0x00
  je loc_02EED                                 ; 02F00  0x74, 0xEB
  mov bp, 0                                    ; 02F02  0xBD, 0x00, 0x00

loc_02F05:  ; 02F05
  db 0x8B, 0xDD                               ; 02F05  mov bx, bp
  db 0x33, 0xC9                               ; 02F07  xor cx, cx
  ret                                          ; 02F09  0xC3

mem_mau_release:  ; 02F0A
  push es                                      ; 02F0A  0x06
  mov ax, ds                                   ; 02F0B  0x8C, 0xD8
  mov es, ax                                   ; 02F0D  0x8E, 0xC0
  mov ax, 5                                    ; 02F0F  0xB8, 0x05, 0x00
  db 0xF6, 0x26, 0x00, 0x00                   ; 02F12  mul byte [0]
  push ax                                      ; 02F16  0x50
  db 0x8B, 0xC8                               ; 02F17  mov cx, ax
  db 0x2B, 0xCB                               ; 02F19  sub cx, bx
  db 0x8B, 0xFB                               ; 02F1B  mov di, bx
  add bx, 5                                    ; 02F1D  0x83, 0xC3, 0x05
  db 0x8B, 0xF3                               ; 02F20  mov si, bx
  rep movsb                                    ; 02F22  0xF3, 0xA4
  pop bx                                       ; 02F24  0x5B
  mov word [bx + 2], 0                         ; 02F25  0xC7, 0x47, 0x02, 0x00, 0x00
  mov word [bx], 0                             ; 02F2A  0xC7, 0x07, 0x00, 0x00
  mov byte [bx + 4], 0                         ; 02F2E  0xC6, 0x47, 0x04, 0x00
  pop es                                       ; 02F32  0x07
  ret                                          ; 02F33  0xC3

mem_mau_insert:  ; 02F34
  mov ax, 5                                    ; 02F34  0xB8, 0x05, 0x00
  db 0xF6, 0x26, 0x00, 0x00                   ; 02F37  mul byte [0]
  db 0x8B, 0xF0                               ; 02F3B  mov si, ax
  mov cx, 0xffff                               ; 02F3D  0xB9, 0xFF, 0xFF
  cmp word [si], 0                             ; 02F40  0x83, 0x3C, 0x00
  jne loc_02F5F                                ; 02F43  0x75, 0x1A
  db 0x8B, 0xCE                               ; 02F45  mov cx, si
  db 0x2B, 0xCB                               ; 02F47  sub cx, bx
  dec si                                       ; 02F49  0x4E
  lea di, [si + 5]                             ; 02F4A  0x8D, 0x7C, 0x05
  push es                                      ; 02F4D  0x06
  push ds                                      ; 02F4E  0x1E
  pop es                                       ; 02F4F  0x07
  std                                          ; 02F50  0xFD
  rep movsb                                    ; 02F51  0xF3, 0xA4
  cld                                          ; 02F53  0xFC
  pop es                                       ; 02F54  0x07
  db 0x2B, 0xC9                               ; 02F55  sub cx, cx
  mov [bx], cx                                 ; 02F57  0x89, 0x0F
  mov [bx + 2], cx                             ; 02F59  0x89, 0x4F, 0x02
  mov [bx + 4], cl                             ; 02F5C  0x88, 0x4F, 0x04

loc_02F5F:  ; 02F5F
  ret                                          ; 02F5F  0xC3

mem_fn11_mlalloc:  ; 02F60
  db 0x8B, 0xF2                               ; 02F60  mov si, dx
  db 0x2B, 0xC0                               ; 02F62  sub ax, ax
  db 0x8B, 0xC8                               ; 02F64  mov cx, ax
  mov dx, 0xffff                               ; 02F66  0xBA, 0xFF, 0xFF
  push ax                                      ; 02F69  0x50
  push cx                                      ; 02F6A  0x51

loc_02F6B:  ; 02F6B
  cmp word [bx], 0                             ; 02F6B  0x83, 0x3F, 0x00
  je loc_02F90                                 ; 02F6E  0x74, 0x20
  push bx                                      ; 02F70  0x53
  push dx                                      ; 02F71  0x52
  push si                                      ; 02F72  0x56
  call mem_mla_value                               ; 02F73  0xE8, 0x2F, 0x00
  pop si                                       ; 02F76  0x5E
  pop dx                                       ; 02F77  0x5A
  pop bx                                       ; 02F78  0x5B
  db 0x3B, 0xCA                               ; 02F79  cmp cx, dx
  jae loc_02F8C                                ; 02F7B  0x73, 0x0F
  db 0x8B, 0xD1                               ; 02F7D  mov dx, cx
  pop cx                                       ; 02F7F  0x59
  db 0x8B, 0xC8                               ; 02F80  mov cx, ax
  pop ax                                       ; 02F82  0x58
  db 0x8B, 0xC3                               ; 02F83  mov ax, bx
  push ax                                      ; 02F85  0x50
  push cx                                      ; 02F86  0x51
  cmp dx, 0                                    ; 02F87  0x83, 0xFA, 0x00
  je loc_02F90                                 ; 02F8A  0x74, 0x04

loc_02F8C:  ; 02F8C
  mov bx, [bx]                                 ; 02F8C  0x8B, 0x1F
  jmp short loc_02F6B                          ; 02F8E  0xEB, 0xDB

loc_02F90:  ; 02F90
  pop cx                                       ; 02F90  0x59
  pop ax                                       ; 02F91  0x58
  cmp ax, strict word 0                       ; 02F92  3D 00 00
  je loc_02F9E                                 ; 02F95  0x74, 0x07
  db 0x8B, 0xD8                               ; 02F97  mov bx, ax
  db 0x8B, 0xC1                               ; 02F99  mov ax, cx
  jmp near loc_03051                           ; 02F9B  0xE9, 0xB3, 0x00

loc_02F9E:  ; 02F9E
  mov bx, 0xffff                               ; 02F9E  0xBB, 0xFF, 0xFF
  mov cx, 3                                    ; 02FA1  0xB9, 0x03, 0x00
  ret                                          ; 02FA4  0xC3

mem_mla_value:  ; 02FA5
  db 0x33, 0xED                               ; 02FA5  xor bp, bp
  push es                                      ; 02FA7  0x06
  mov es, [es:0x2e]                            ; 02FA8  0x26, 0x8E, 0x06, 0x2E, 0x00
  db 0x2B, 0xC0                               ; 02FAD  sub ax, ax
  mov dx, 0                                    ; 02FAF  0xBA, 0x00, 0x00
  mov di, [bx]                                 ; 02FB2  0x8B, 0x3F
  cmp di, 0                                    ; 02FB4  0x83, 0xFF, 0x00
  je loc_03016                                 ; 02FB7  0x74, 0x5D
  cmp word [es:si], 0                          ; 02FB9  0x26, 0x83, 0x3C, 0x00
  je loc_02FE2                                 ; 02FBD  0x74, 0x23
  mov cx, [di + 2]                             ; 02FBF  0x8B, 0x4D, 0x02
  add cx, 0xa                                  ; 02FC2  0x83, 0xC1, 0x0A
  cmp [es:si], cx                              ; 02FC5  0x26, 0x39, 0x0C
  jb loc_03016                                 ; 02FC8  0x72, 0x4C
  add cx, [di + 4]                             ; 02FCA  0x03, 0x4D, 0x04
  sub cx, 0xa                                  ; 02FCD  0x83, 0xE9, 0x0A
  cmp [es:si], cx                              ; 02FD0  0x26, 0x39, 0x0C
  jae loc_03016                                ; 02FD3  0x73, 0x41
  mov bp, 1                                    ; 02FD5  0xBD, 0x01, 0x00
  inc ax                                       ; 02FD8  0x40
  db 0x8B, 0xD1                               ; 02FD9  mov dx, cx
  sub dx, [es:si]                              ; 02FDB  0x26, 0x2B, 0x14
  db 0x8B, 0xDF                               ; 02FDE  mov bx, di
  mov di, [bx]                                 ; 02FE0  0x8B, 0x3F

loc_02FE2:  ; 02FE2
  mov cx, [es:si + 4]                          ; 02FE2  0x26, 0x8B, 0x4C, 0x04
  db 0x3B, 0xCA                               ; 02FE6  cmp cx, dx
  jb loc_0301D                                 ; 02FE8  0x72, 0x33

loc_02FEA:  ; 02FEA
  cmp ax, strict word 0                       ; 02FEA  3D 00 00
  je loc_02FFE                                 ; 02FED  0x74, 0x0F
  push ax                                      ; 02FEF  0x50
  mov ax, [bx + 2]                             ; 02FF0  0x8B, 0x47, 0x02
  add ax, [bx + 4]                             ; 02FF3  0x03, 0x47, 0x04
  cmp ax, [di + 2]                             ; 02FF6  0x3B, 0x45, 0x02
  pop ax                                       ; 02FF9  0x58
  je loc_02FFE                                 ; 02FFA  0x74, 0x02
  jmp short loc_0300B                          ; 02FFC  0xEB, 0x0D

loc_02FFE:  ; 02FFE
  inc ax                                       ; 02FFE  0x40
  add dx, [di + 4]                             ; 02FFF  0x03, 0x55, 0x04
  db 0x8B, 0xDF                               ; 03002  mov bx, di
  mov di, [bx]                                 ; 03004  0x8B, 0x3F
  cmp di, 0                                    ; 03006  0x83, 0xFF, 0x00
  jne loc_02FE2                                ; 03009  0x75, 0xD7

loc_0300B:  ; 0300B
  mov cx, [es:si + 2]                          ; 0300B  0x26, 0x8B, 0x4C, 0x02
  add cx, 0xa                                  ; 0300F  0x83, 0xC1, 0x0A
  db 0x3B, 0xCA                               ; 03012  cmp cx, dx
  jbe loc_03029                                ; 03014  0x76, 0x13

loc_03016:  ; 03016
  mov cx, 0xffff                               ; 03016  0xB9, 0xFF, 0xFF
  db 0x2B, 0xC0                               ; 03019  sub ax, ax
  pop es                                       ; 0301B  0x07
  ret                                          ; 0301C  0xC3

loc_0301D:  ; 0301D
  cmp bp, 1                                    ; 0301D  0x83, 0xFD, 0x01
  je loc_03029                                 ; 03020  0x74, 0x07
  add cx, 0xa                                  ; 03022  0x83, 0xC1, 0x0A
  db 0x3B, 0xCA                               ; 03025  cmp cx, dx
  ja loc_02FEA                                 ; 03027  0x77, 0xC1

loc_03029:  ; 03029
  push ax                                      ; 03029  0x50
  dec ax                                       ; 0302A  0x48
  mov cl, 2                                    ; 0302B  0xB1, 0x02
  shl ax, cl                                   ; 0302D  0xD3, 0xE0
  mov cx, [es:si + 4]                          ; 0302F  0x26, 0x8B, 0x4C, 0x04
  add cx, 0xa                                  ; 03033  0x83, 0xC1, 0x0A
  cmp cx, 0xa                                  ; 03036  0x83, 0xF9, 0x0A
  jae loc_0303E                                ; 03039  0x73, 0x03
  mov cx, 0xffff                               ; 0303B  0xB9, 0xFF, 0xFF

loc_0303E:  ; 0303E
  db 0x3B, 0xCA                               ; 0303E  cmp cx, dx
  jbe loc_03044                                ; 03040  0x76, 0x02
  xchg dx, cx                                 ; 03042  87 D1

loc_03044:  ; 03044
  db 0x2B, 0xD1                               ; 03044  sub dx, cx
  mov cl, 4                                    ; 03046  0xB1, 0x04
  shr dx, cl                                   ; 03048  0xD3, 0xEA
  db 0x03, 0xD0                               ; 0304A  add dx, ax
  db 0x8B, 0xCA                               ; 0304C  mov cx, dx
  pop ax                                       ; 0304E  0x58
  pop es                                       ; 0304F  0x07
  ret                                          ; 03050  0xC3

loc_03051:  ; 03051
  cmp ax, strict word 1                       ; 03051  3D 01 00
  jg loc_03068                                 ; 03054  0x7F, 0x12
  mov si, [bx]                                 ; 03056  0x8B, 0x37
  mov cx, [si]                                 ; 03058  0x8B, 0x0C
  mov [bx], cx                                 ; 0305A  0x89, 0x0F
  db 0x8B, 0xDE                               ; 0305C  mov bx, si
  db 0x2B, 0xC9                               ; 0305E  sub cx, cx
  mov [bx + 6], cx                             ; 03060  0x89, 0x4F, 0x06
  mov [bx], cx                                 ; 03063  0x89, 0x0F
  jmp near loc_030A8                           ; 03065  0xE9, 0x40, 0x00

loc_03068:  ; 03068
  push ax                                      ; 03068  0x50
  push bx                                      ; 03069  0x53
  call mem_getmd                               ; 0306A  0xE8, 0xB8, 0x00
  db 0x8B, 0xFB                               ; 0306D  mov di, bx
  pop bx                                       ; 0306F  0x5B
  pop ax                                       ; 03070  0x58
  jcxz loc_03076                               ; 03071  0xE3, 0x03
  db 0x2B, 0xDB                               ; 03073  sub bx, bx
  ret                                          ; 03075  0xC3

loc_03076:  ; 03076
  mov word [di], 0                             ; 03076  0xC7, 0x05, 0x00, 0x00
  mov word [di + 4], 0                         ; 0307A  0xC7, 0x45, 0x04, 0x00, 0x00
  mov si, [bx]                                 ; 0307F  0x8B, 0x37
  mov [di + 6], si                             ; 03081  0x89, 0x75, 0x06
  mov cx, [si + 2]                             ; 03084  0x8B, 0x4C, 0x02
  mov [di + 2], cx                             ; 03087  0x89, 0x4D, 0x02

loc_0308A:  ; 0308A
  mov cx, [si + 4]                             ; 0308A  0x8B, 0x4C, 0x04
  add [di + 4], cx                             ; 0308D  0x01, 0x4D, 0x04
  dec ax                                       ; 03090  0x48
  cmp ax, strict word 0                       ; 03091  3D 00 00
  je loc_0309A                                 ; 03094  0x74, 0x04
  mov si, [si]                                 ; 03096  0x8B, 0x34
  jmp short loc_0308A                          ; 03098  0xEB, 0xF0

loc_0309A:  ; 0309A
  push bx                                      ; 0309A  0x53
  mov bx, [si]                                 ; 0309B  0x8B, 0x1C
  mov word [si], 0                             ; 0309D  0xC7, 0x04, 0x00, 0x00
  pop si                                       ; 030A1  0x5E
  mov [si], bx                                 ; 030A2  0x89, 0x1C
  db 0x8B, 0xDF                               ; 030A4  mov bx, di
  db 0x2B, 0xC9                               ; 030A6  sub cx, cx

loc_030A8:  ; 030A8
  mov dx, [bx + 2]                             ; 030A8  0x8B, 0x57, 0x02
  mov cx, [bx + 4]                             ; 030AB  0x8B, 0x4F, 0x04
  push cx                                      ; 030AE  0x51
  push es                                      ; 030AF  0x06
  mov es, dx                                   ; 030B0  0x8E, 0xC2
  db 0x2B, 0xC0                               ; 030B2  sub ax, ax
  db 0x8B, 0xF8                               ; 030B4  mov di, ax
  mov cx, 0x50                                 ; 030B6  0xB9, 0x50, 0x00
  rep stosw                                    ; 030B9  0xF3, 0xAB
  pop es                                       ; 030BB  0x07
  pop cx                                       ; 030BC  0x59
  mov ds, dx                                   ; 030BD  0x8E, 0xDA
  mov byte [0], 0x1f                           ; 030BF  0xC6, 0x06, 0x00, 0x00, 0x1F
  sub cx, 0xa                                  ; 030C4  0x83, 0xE9, 0x0A
  add dx, 0xa                                  ; 030C7  0x83, 0xC2, 0x0A
  mov si, 5                                    ; 030CA  0xBE, 0x05, 0x00
  mov [si], dx                                 ; 030CD  0x89, 0x14
  mov [si + 2], cx                             ; 030CF  0x89, 0x4C, 0x02
  mov byte [si + 4], 0                         ; 030D2  0xC6, 0x44, 0x04, 0x00
  mov ds, [cs:6]                               ; 030D6  0x2E, 0x8E, 0x1E, 0x06, 0x00
  db 0x2B, 0xC9                               ; 030DB  sub cx, cx
  ret                                          ; 030DD  0xC3

mem_fn12_mlfree:  ; 030DE
  db 0x8B, 0xF2                               ; 030DE  mov si, dx
  cmp word [si + 6], 0                         ; 030E0  0x83, 0x7C, 0x06, 0x00
  je loc_03103                                 ; 030E4  0x74, 0x1D
  db 0x8B, 0xFE                               ; 030E6  mov di, si
  mov si, [si + 6]                             ; 030E8  0x8B, 0x74, 0x06

loc_030EB:  ; 030EB
  cmp si, 0                                    ; 030EB  0x83, 0xFE, 0x00
  je loc_030FC                                 ; 030EE  0x74, 0x0C
  push word [si]                               ; 030F0  0xFF, 0x34
  push bx                                      ; 030F2  0x53
  push di                                      ; 030F3  0x57
  call mem_ml_insert                               ; 030F4  0xE8, 0x14, 0x00
  pop di                                       ; 030F7  0x5F
  pop bx                                       ; 030F8  0x5B
  pop si                                       ; 030F9  0x5E
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
  ret                                          ; 0310A  0xC3

mem_ml_insert:  ; 0310B
  mov di, [bx]                                 ; 0310B  0x8B, 0x3F
  cmp di, 0                                    ; 0310D  0x83, 0xFF, 0x00
  je loc_0311E                                 ; 03110  0x74, 0x0C
  mov ax, [di + 2]                             ; 03112  0x8B, 0x45, 0x02
  cmp ax, [si + 2]                             ; 03115  0x3B, 0x44, 0x02
  ja loc_0311E                                 ; 03118  0x77, 0x04
  db 0x8B, 0xDF                               ; 0311A  mov bx, di
  jmp short mem_ml_insert                          ; 0311C  0xEB, 0xED

loc_0311E:  ; 0311E
  mov ax, [bx]                                 ; 0311E  0x8B, 0x07
  mov [bx], si                                 ; 03120  0x89, 0x37
  mov [si], ax                                 ; 03122  0x89, 0x04
  ret                                          ; 03124  0xC3

mem_getmd:  ; 03125
  pushf                                        ; 03125  0x9C
  cli                                          ; 03126  0xFA
  mov cx, 0x12                                 ; 03127  0xB9, 0x12, 0x00
  mov bx, [0x58]                               ; 0312A  0x8B, 0x1E, 0x58, 0x00
  cmp bx, 0                                    ; 0312E  0x83, 0xFB, 0x00
  je loc_03146                                 ; 03131  0x74, 0x13
  db 0x33, 0xC9                               ; 03133  xor cx, cx
  mov si, [bx]                                 ; 03135  0x8B, 0x37
  mov [0x58], si                               ; 03137  0x89, 0x36, 0x58, 0x00
  mov [bx], cx                                 ; 0313B  0x89, 0x0F
  mov [bx + 2], cx                             ; 0313D  0x89, 0x4F, 0x02
  mov [bx + 4], cx                             ; 03140  0x89, 0x4F, 0x04
  mov [bx + 6], cx                             ; 03143  0x89, 0x4F, 0x06

loc_03146:  ; 03146
  popf                                         ; 03146  0x9D
  ret                                          ; 03147  0xC3

mem_freemd:  ; 03148
  pushf                                        ; 03148  0x9C
  cli                                          ; 03149  0xFA
  mov si, [0x58]                               ; 0314A  0x8B, 0x36, 0x58, 0x00
  mov [0x58], bx                               ; 0314E  0x89, 0x1E, 0x58, 0x00
  mov [bx], si                                 ; 03152  0x89, 0x37
  popf                                         ; 03154  0x9D
  ret                                          ; 03155  0xC3
  nop                                          ; 03156  0x90
  nop                                          ; 03157  0x90
  nop                                          ; 03158  0x90
  nop                                          ; 03159  0x90
  nop                                          ; 0315A  0x90
  nop                                          ; 0315B  0x90
  nop                                          ; 0315C  0x90
  nop                                          ; 0315D  0x90
  nop                                          ; 0315E  0x90
  nop                                          ; 0315F  0x90
  nop                                          ; 03160  0x90
  nop                                          ; 03161  0x90
  nop                                          ; 03162  0x90
  nop                                          ; 03163  0x90
  nop                                          ; 03164  0x90
  nop                                          ; 03165  0x90
  nop                                          ; 03166  0x90
  nop                                          ; 03167  0x90
  nop                                          ; 03168  0x90
  nop                                          ; 03169  0x90
  nop                                          ; 0316A  0x90
  nop                                          ; 0316B  0x90
  nop                                          ; 0316C  0x90
  nop                                          ; 0316D  0x90
  nop                                          ; 0316E  0x90
  nop                                          ; 0316F  0x90
  nop                                          ; 03170  0x90
  nop                                          ; 03171  0x90
  nop                                          ; 03172  0x90
  nop                                          ; 03173  0x90
  nop                                          ; 03174  0x90
  nop                                          ; 03175  0x90
  nop                                          ; 03176  0x90
  nop                                          ; 03177  0x90
  nop                                          ; 03178  0x90
  nop                                          ; 03179  0x90
  nop                                          ; 0317A  0x90
  nop                                          ; 0317B  0x90
  nop                                          ; 0317C  0x90
  nop                                          ; 0317D  0x90
  nop                                          ; 0317E  0x90
  nop                                          ; 0317F  0x90
  nop                                          ; 03180  0x90
  nop                                          ; 03181  0x90
  nop                                          ; 03182  0x90
  nop                                          ; 03183  0x90
  nop                                          ; 03184  0x90
  nop                                          ; 03185  0x90
  nop                                          ; 03186  0x90
  nop                                          ; 03187  0x90
  nop                                          ; 03188  0x90
  nop                                          ; 03189  0x90
  nop                                          ; 0318A  0x90
  nop                                          ; 0318B  0x90
  nop                                          ; 0318C  0x90
  nop                                          ; 0318D  0x90
  nop                                          ; 0318E  0x90
  nop                                          ; 0318F  0x90
  nop                                          ; 03190  0x90
  nop                                          ; 03191  0x90
  nop                                          ; 03192  0x90
  nop                                          ; 03193  0x90
  nop                                          ; 03194  0x90
  nop                                          ; 03195  0x90
  nop                                          ; 03196  0x90
  nop                                          ; 03197  0x90
  nop                                          ; 03198  0x90
  nop                                          ; 03199  0x90
  nop                                          ; 0319A  0x90
  nop                                          ; 0319B  0x90
  nop                                          ; 0319C  0x90
  nop                                          ; 0319D  0x90
  nop                                          ; 0319E  0x90
  nop                                          ; 0319F  0x90
  nop                                          ; 031A0  0x90
  nop                                          ; 031A1  0x90
  nop                                          ; 031A2  0x90
  nop                                          ; 031A3  0x90
  nop                                          ; 031A4  0x90
  nop                                          ; 031A5  0x90
  nop                                          ; 031A6  0x90
  nop                                          ; 031A7  0x90
  nop                                          ; 031A8  0x90
  nop                                          ; 031A9  0x90
  nop                                          ; 031AA  0x90
  nop                                          ; 031AB  0x90
  nop                                          ; 031AC  0x90
  nop                                          ; 031AD  0x90
  nop                                          ; 031AE  0x90
  nop                                          ; 031AF  0x90
  nop                                          ; 031B0  0x90
  nop                                          ; 031B1  0x90
  nop                                          ; 031B2  0x90
  nop                                          ; 031B3  0x90
  nop                                          ; 031B4  0x90
  nop                                          ; 031B5  0x90
  nop                                          ; 031B6  0x90
  nop                                          ; 031B7  0x90
  nop                                          ; 031B8  0x90
  nop                                          ; 031B9  0x90
  nop                                          ; 031BA  0x90
  nop                                          ; 031BB  0x90
  nop                                          ; 031BC  0x90
  nop                                          ; 031BD  0x90
  nop                                          ; 031BE  0x90
  nop                                          ; 031BF  0x90
  nop                                          ; 031C0  0x90
  nop                                          ; 031C1  0x90
  nop                                          ; 031C2  0x90
  nop                                          ; 031C3  0x90
  nop                                          ; 031C4  0x90
  nop                                          ; 031C5  0x90
  nop                                          ; 031C6  0x90
  nop                                          ; 031C7  0x90
  nop                                          ; 031C8  0x90
  nop                                          ; 031C9  0x90
  nop                                          ; 031CA  0x90
  nop                                          ; 031CB  0x90
  nop                                          ; 031CC  0x90
  nop                                          ; 031CD  0x90
  nop                                          ; 031CE  0x90
  nop                                          ; 031CF  0x90
  nop                                          ; 031D0  0x90
  nop                                          ; 031D1  0x90
  nop                                          ; 031D2  0x90
  nop                                          ; 031D3  0x90
  nop                                          ; 031D4  0x90
  nop                                          ; 031D5  0x90
  db 0x00, 0x00                               ; 031D6
  db 0x00, 0x00                               ; 031D8
  db 0x00, 0x00                               ; 031DA
  db 0x00, 0x00                               ; 031DC
  db 0x00, 0x00                               ; 031DE
