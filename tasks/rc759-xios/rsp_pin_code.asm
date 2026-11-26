; ===========================================================================
; Regnecentralen RC759 Piccoline — PIN.RSP Code Segment
; Process INput (tastatur- og linjeeditering for Piccoline)
; 167 paragraphs = 2.672 bytes (0x117D0 - 0x1223F)
; ===========================================================================

; -----------------------------------------------------------------------------
; pin_xdos (mon1..4) — BDOS / XDOS system call entry
; Invokes INT 0xE0 with function in CX, parameter in DX.
; -----------------------------------------------------------------------------
pin_xdos:                                     ; 117D0
  push bp                                      ; 117D0  0x55
  db 0x8B, 0xEC                                ; 117D1  mov bp, sp (d=1)
  mov dx, [bp + 4]                             ; 117D3  0x8B, 0x56, 0x04
  mov cx, [bp + 6]                             ; 117D6  0x8B, 0x4E, 0x06
  int 0xe0                                     ; 117D9  0xCD, 0xE0
  pop bp                                       ; 117DB  0x5D
  ret 4                                        ; 117DC  0xC2, 0x04, 0x00

; -----------------------------------------------------------------------------
; pin_intsys — Calls CCP/M-86 supervisor functions directly
; Used for internal OS operations (sleep, wakeup) via SYSDAT:0x0000.
; -----------------------------------------------------------------------------
pin_intsys:                                     ; 117DF
  push bp                                      ; 117DF  0x55
  db 0x8B, 0xEC                                ; 117E0  mov bp, sp
  mov bx, [bp + 4]                             ; 117E2  0x8B, 0x5E, 0x04
  mov dx, [bp + 6]                             ; 117E5  0x8B, 0x56, 0x06
  mov cx, [bp + 8]                             ; 117E8  0x8B, 0x4E, 0x08
  push ds                                      ; 117EB  0x1E
  mov ds, [0]                                  ; 117EC  0x8E, 0x1E, 0x00, 0x00
  mov si, [0x68]                               ; 117F0  0x8B, 0x36, 0x68, 0x00
  mov es, [si + 0x10]                          ; 117F4  0x8E, 0x44, 0x10
  call far [0]                                 ; 117F7  0xFF, 0x1E, 0x00, 0x00
  pop ds                                       ; 117FB  0x1F
  pop bp                                       ; 117FC  0x5D
  ret 6                                        ; 117FD  0xC2, 0x06, 0x00

; -----------------------------------------------------------------------------
; pin_pxios1 — Physical XIOS call wrapper (CIO interface)
; Invokes XIOS far call via SYSDAT:0x0028 (xiosmod).
; -----------------------------------------------------------------------------
pin_pxios1:                                     ; 11800
  push bp                                      ; 11800  0x55
  db 0x8B, 0xEC                                ; 11801  mov bp, sp
  mov ax, [bp + 8]                             ; 11803  0x8B, 0x46, 0x08
  mov cx, [bp + 6]                             ; 11806  0x8B, 0x4E, 0x06
  mov dx, [bp + 4]                             ; 11809  0x8B, 0x56, 0x04
  push ds                                      ; 1180C  0x1E
  mov ds, [0]                                  ; 1180D  0x8E, 0x1E, 0x00, 0x00
  mov si, [0x68]                               ; 11811  0x8B, 0x36, 0x68, 0x00
  mov es, [si + 0x10]                          ; 11815  0x8E, 0x44, 0x10
  call far [0x28]                              ; 11818  0xFF, 0x1E, 0x28, 0x00
  pop ds                                       ; 1181C  0x1F
  pop bp                                       ; 1181D  0x5D
  ret 6                                        ; 1181E  0xC2, 0x06, 0x00
  db 0x00                                      ; 11821  .

; -----------------------------------------------------------------------------
; pin_conin — Reads console input character/word from XIOS
; Calls pxios3(mx, 0, ccb.pc). Result returned in cword.
; -----------------------------------------------------------------------------
pin_conin:                                     ; 11822
  push bp                                      ; 11822  0x55
  db 0x8B, 0xEC                                ; 11823  mov bp, sp
  mov ax, 1                                    ; 11825  0xB8, 0x01, 0x00
  push ax                                      ; 11828  0x50
  mov ax, 0                                    ; 11829  0xB8, 0x00, 0x00
  push ax                                      ; 1182C  0x50
  les bx, [pin_cur_ccb]                              ; 1182D  0xC4, 0x1E, 0x58, 0x01
  mov al, [es:bx + 0xa]                        ; 11831  0x26, 0x8A, 0x47, 0x0A
  mov ah, 0                                    ; 11835  0xB4, 0x00
  push ax                                      ; 11837  0x50
  call pin_pxios1                               ; 11838  0xE8, 0xC5, 0xFF

loc_1183B:                                     ; 1183B
  mov [pin_cword], ax                              ; 1183B  0xA3, 0x7E, 0x01
  pop bp                                       ; 1183E  0x5D
  ret                                          ; 1183F  0xC3

; -----------------------------------------------------------------------------
; pin_get_cons_mode — Reads console mode from XIOS
; Calls pxios3(mx, 0x100, ccb.vc). Result in cnmode.
; -----------------------------------------------------------------------------
pin_get_cons_mode:                                     ; 11840
  push bp                                      ; 11840  0x55
  db 0x8B, 0xEC                                ; 11841  mov bp, sp
  mov ax, 0x1e                                 ; 11843  0xB8, 0x1E, 0x00
  push ax                                      ; 11846  0x50
  mov ax, 0x100                                ; 11847  0xB8, 0x00, 0x01
  push ax                                      ; 1184A  0x50
  les bx, [pin_cur_ccb]                              ; 1184B  0xC4, 0x1E, 0x58, 0x01
  mov al, [es:bx + 0xb]                        ; 1184F  0x26, 0x8A, 0x47, 0x0B
  mov ah, 0                                    ; 11853  0xB4, 0x00
  push ax                                      ; 11855  0x50
  call pin_pxios1                               ; 11856  0xE8, 0xA7, 0xFF
  mov [pin_cnmode], ax                              ; 11859  0xA3, 0x66, 0x01
  pop bp                                       ; 1185C  0x5D
  ret                                          ; 1185D  0xC3

; -----------------------------------------------------------------------------
; pin_read_change_mxq — Locks CCB mutex queue (VCMXQ)
; Reads the mutex message from qaddr (BDOS 137: Q_READ).
; -----------------------------------------------------------------------------
pin_read_change_mxq:                                     ; 1185E
  push bp                                      ; 1185E  0x55
  db 0x8B, 0xEC                                ; 1185F  mov bp, sp
  mov byte [pin_mxq_count], 0                          ; 11861  0xC6, 0x06, 0x92, 0x01, 0x00

loc_11866:                                     ; 11866
  mov al, [pin_mxq_count]                              ; 11866  0xA0, 0x92, 0x01
  mov ah, 0                                    ; 11869  0xB4, 0x00
  mov si, ax                                   ; 1186B  0x89, 0xC6
  les bx, [bp + 4]                             ; 1186D  0xC4, 0x5E, 0x04
  mov cl, [es:bx + si]                         ; 11870  0x26, 0x8A, 0x08
  cmp cl, [bp + 8]                             ; 11873  0x3A, 0x4E, 0x08
  mov al, 0xff                                 ; 11876  0xB0, 0xFF
  jne loc_1187B                                ; 11878  0x75, 0x01
  inc ax                                       ; 1187A  0x40

loc_1187B:                                     ; 1187B
  mov dx, si                                   ; 1187B  0x89, 0xF2
  push ax                                      ; 1187D  0x50
  cmp dl, [bp + 0xa]                           ; 1187E  0x3A, 0x56, 0x0A
  mov al, 0xff                                 ; 11881  0xB0, 0xFF
  jb loc_11886                                 ; 11883  0x72, 0x01
  inc ax                                       ; 11885  0x40

loc_11886:                                     ; 11886
  pop cx                                       ; 11886  0x59
  db 0x22, 0xC1                                ; 11887  and al, cl
  rcr al, 1                                    ; 11889  0xD0, 0xD8
  jae loc_118AB                                ; 1188B  0x73, 0x1E
  mov ax, 2                                    ; 1188D  0xB8, 0x02, 0x00
  push ax                                      ; 11890  0x50
  mov al, [es:bx + si]                         ; 11891  0x26, 0x8A, 0x00
  mov ah, 0                                    ; 11894  0xB4, 0x00
  push ax                                      ; 11896  0x50
  les bx, [pin_cur_ccb]                              ; 11897  0xC4, 0x1E, 0x58, 0x01
  mov al, [es:bx + 0xb]                        ; 1189B  0x26, 0x8A, 0x47, 0x0B
  mov ah, 0                                    ; 1189F  0xB4, 0x00
  push ax                                      ; 118A1  0x50
  call pin_pxios1                               ; 118A2  0xE8, 0x5B, 0xFF
  inc byte [pin_mxq_count]                             ; 118A5  0xFE, 0x06, 0x92, 0x01
  jmp short loc_11866                          ; 118A9  0xEB, 0xBB

loc_118AB:                                     ; 118AB
  pop bp                                       ; 118AB  0x5D
  ret 8                                        ; 118AC  0xC2, 0x08, 0x00

; -----------------------------------------------------------------------------
; pin_write_change_mxq — Unlocks CCB mutex queue (VCMXQ)
; Writes the mutex message back to qaddr (BDOS 139: Q_WRITE).
; -----------------------------------------------------------------------------
pin_write_change_mxq:                                     ; 118AF
  push bp                                      ; 118AF  0x55
  db 0x8B, 0xEC                                ; 118B0  mov bp, sp
  mov ax, [bp + 4]                             ; 118B2  0x8B, 0x46, 0x04
  mov [pin_listroot], ax                              ; 118B5  0xA3, 0x6A, 0x01
  mov al, 0x89                                 ; 118B8  0xB0, 0x89
  push ax                                      ; 118BA  0x50
  mov ax, 0x168                                ; 118BB  0xB8, 0x68, 0x01
  push ax                                      ; 118BE  0x50
  db 0xE8, 0x0E, 0xFF                          ; 118BF  call 0x117d0
  pop bp                                       ; 118C2  0x5D
  ret 2                                        ; 118C3  0xC2, 0x02, 0x00

; -----------------------------------------------------------------------------
; pin_sleep — Puts process to sleep on list root
; Calls intsys(mi, list_root, 0x212).
; -----------------------------------------------------------------------------
pin_sleep:                                     ; 118C6
  push bp                                      ; 118C6  0x55
  db 0x8B, 0xEC                                ; 118C7  mov bp, sp
  mov ax, [bp + 4]                             ; 118C9  0x8B, 0x46, 0x04
  mov [pin_listroot], ax                              ; 118CC  0xA3, 0x6A, 0x01
  mov al, 0x8b                                 ; 118CF  0xB0, 0x8B
  push ax                                      ; 118D1  0x50
  mov ax, 0x168                                ; 118D2  0xB8, 0x68, 0x01
  push ax                                      ; 118D5  0x50
  db 0xE8, 0xF7, 0xFE                          ; 118D6  call 0x117d0
  pop bp                                       ; 118D9  0x5D
  ret 2                                        ; 118DA  0xC2, 0x02, 0x00

; -----------------------------------------------------------------------------
; pin_wake_up — Wakes sleeping process on list root
; Calls intsys(mi, list_root, 0).
; -----------------------------------------------------------------------------
pin_wake_up:                                     ; 118DD
  push bp                                      ; 118DD  0x55
  db 0x8B, 0xEC                                ; 118DE  mov bp, sp
  mov ax, 0x212                                ; 118E0  0xB8, 0x12, 0x02
  push ax                                      ; 118E3  0x50
  push word [bp + 4]                           ; 118E4  0xFF, 0x76, 0x04
  mov ax, 9                                    ; 118E7  0xB8, 0x09, 0x00
  push ax                                      ; 118EA  0x50
  call pin_intsys                               ; 118EB  0xE8, 0xF1, 0xFE
  pop bp                                       ; 118EE  0x5D
  ret 2                                        ; 118EF  0xC2, 0x02, 0x00

; -----------------------------------------------------------------------------
; pin_set_conout_flag — Acquires console output flag (cf)
; Ensures exclusive access before calling XIOS console output routines.
; -----------------------------------------------------------------------------
pin_set_conout_flag:                                     ; 118F2
  push bp                                      ; 118F2  0x55
  db 0x8B, 0xEC                                ; 118F3  mov bp, sp
  mov ax, 0x213                                ; 118F5  0xB8, 0x13, 0x02
  push ax                                      ; 118F8  0x50
  push word [bp + 4]                           ; 118F9  0xFF, 0x76, 0x04
  mov ax, 0                                    ; 118FC  0xB8, 0x00, 0x00
  push ax                                      ; 118FF  0x50
  call pin_intsys                               ; 11900  0xE8, 0xDC, 0xFE
  pop bp                                       ; 11903  0x5D
  ret 2                                        ; 11904  0xC2, 0x02, 0x00

; -----------------------------------------------------------------------------
; pin_reset_conout_flag — Releases console output flag (cf)
; Clears flag and wakes any sleeping process on ccb.cosleep.
; -----------------------------------------------------------------------------
pin_reset_conout_flag:                                     ; 11907
  push bp                                      ; 11907  0x55
  db 0x8B, 0xEC                                ; 11908  mov bp, sp
  cli                                          ; 1190A  0xFA

loc_1190B:                                     ; 1190B
  les bx, [bp + 4]                             ; 1190B  0xC4, 0x5E, 0x04
  mov al, [es:bx + 4]                          ; 1190E  0x26, 0x8A, 0x47, 0x04
  and al, 8                                    ; 11912  0x24, 0x08
  cmp al, 0                                    ; 11914  0x3C, 0x00
  je loc_11921                                 ; 11916  0x74, 0x09
  lea ax, [bx + 0x22]                          ; 11918  0x8D, 0x47, 0x22
  push ax                                      ; 1191B  0x50
  call pin_wake_up                               ; 1191C  0xE8, 0xBE, 0xFF
  jmp short loc_1190B                          ; 1191F  0xEB, 0xEA

loc_11921:                                     ; 11921
  les bx, [bp + 4]                             ; 11921  0xC4, 0x5E, 0x04
  or byte [es:bx + 4], 8                       ; 11924  0x26, 0x80, 0x4F, 0x04, 0x08
  sti                                          ; 11929  0xFB
  pop bp                                       ; 1192A  0x5D
  ret 4                                        ; 1192B  0xC2, 0x04, 0x00

; -----------------------------------------------------------------------------
; pin_wake_vout — Wakes VOUT RSP by writing wake message to voutq
; -----------------------------------------------------------------------------
pin_wake_vout:                                     ; 1192E
  push bp                                      ; 1192E  0x55
  db 0x8B, 0xEC                                ; 1192F  mov bp, sp
  les bx, [bp + 4]                             ; 11931  0xC4, 0x5E, 0x04
  and byte [es:bx + 4], 0xf7                   ; 11934  0x26, 0x80, 0x67, 0x04, 0xF7
  lea ax, [bx + 0x22]                          ; 11939  0x8D, 0x47, 0x22
  push ax                                      ; 1193C  0x50
  call pin_set_conout_flag                               ; 1193D  0xE8, 0xB2, 0xFF
  pop bp                                       ; 11940  0x5D
  ret 4                                        ; 11941  0xC2, 0x04, 0x00

; -----------------------------------------------------------------------------
; pin_write_vinq — Writes character word to Virtual Input Queue (vinq)
; If queue is full, rings console bell via set_conout_flag + pxios1(conout, BELL).
; -----------------------------------------------------------------------------
pin_write_vinq:                                     ; 11944
  push bp                                      ; 11944  0x55
  db 0x8B, 0xEC                                ; 11945  mov bp, sp
  les bx, [bp + 4]                             ; 11947  0xC4, 0x5E, 0x04
  mov ax, [es:bx + 0xe]                        ; 1194A  0x26, 0x8B, 0x47, 0x0E
  and ax, strict word 1                        ; 1194E  25 01 00
  cmp ax, 0                                    ; 11951  0x83, 0xF8, 0x00
  je loc_11994                                 ; 11954  0x74, 0x3E
  les bx, [bp + 4]                             ; 11956  0xC4, 0x5E, 0x04
  mov ax, [es:bx + 0x14]                       ; 11959  0x26, 0x8B, 0x47, 0x14
  mov [pin_listroot], ax                              ; 1195D  0xA3, 0x6A, 0x01
  mov word [pin_drvmask_ptr], 0x1a6                      ; 11960  0xC7, 0x06, 0x6E, 0x01, 0xA6, 0x01
  mov al, 0x8c                                 ; 11966  0xB0, 0x8C
  push ax                                      ; 11968  0x50
  mov ax, 0x168                                ; 11969  0xB8, 0x68, 0x01
  push ax                                      ; 1196C  0x50
  db 0xE8, 0x60, 0xFE                          ; 1196D  call 0x117d0
  les bx, [bp + 4]                             ; 11970  0xC4, 0x5E, 0x04
  mov ax, [es:bx + 0x14]                       ; 11973  0x26, 0x8B, 0x47, 0x14
  mov [pin_listroot], ax                              ; 11977  0xA3, 0x6A, 0x01
  mov word [pin_drvmask_ptr], 0x1a6                      ; 1197A  0xC7, 0x06, 0x6E, 0x01, 0xA6, 0x01
  mov al, 0x8c                                 ; 11980  0xB0, 0x8C
  push ax                                      ; 11982  0x50
  mov ax, 0x168                                ; 11983  0xB8, 0x68, 0x01
  push ax                                      ; 11986  0x50
  db 0xE8, 0x46, 0xFE                          ; 11987  call 0x117d0
  les bx, [bp + 4]                             ; 1198A  0xC4, 0x5E, 0x04
  lea ax, [bx + 0x26]                          ; 1198D  0x8D, 0x47, 0x26
  push ax                                      ; 11990  0x50
  call pin_set_conout_flag                               ; 11991  0xE8, 0x5E, 0xFF

loc_11994:                                     ; 11994
  pop bp                                       ; 11994  0x5D
  ret 4                                        ; 11995  0xC2, 0x04, 0x00

; -----------------------------------------------------------------------------
; pin_set_ccb — Switches active CCB pointer to target virtual console
; Updates ccb to point to SYSDAT:ccb + vc * sizeof(ccb).
; -----------------------------------------------------------------------------
pin_set_ccb:                                     ; 11998
  push bp                                      ; 11998  0x55
  db 0x8B, 0xEC                                ; 11999  mov bp, sp
  les bx, [pin_cur_ccb]                              ; 1199B  0xC4, 0x1E, 0x58, 0x01
  mov ax, [es:bx + 0x12]                       ; 1199F  0x26, 0x8B, 0x47, 0x12
  mov [pin_listroot], ax                              ; 119A3  0xA3, 0x6A, 0x01
  lea ax, [bp + 4]                             ; 119A6  0x8D, 0x46, 0x04
  mov [pin_drvmask_ptr], ax                              ; 119A9  0xA3, 0x6E, 0x01
  mov al, 0x8c                                 ; 119AC  0xB0, 0x8C
  push ax                                      ; 119AE  0x50
  mov ax, 0x168                                ; 119AF  0xB8, 0x68, 0x01
  push ax                                      ; 119B2  0x50
  db 0xE8, 0x1A, 0xFE                          ; 119B3  call 0x117d0
  cmp ax, -1                                   ; 119B6  0x83, 0xF8, 0xFF
  jne loc_119E3                                ; 119B9  0x75, 0x28
  les bx, [pin_cur_ccb]                              ; 119BB  0xC4, 0x1E, 0x58, 0x01
  push es                                      ; 119BF  0x06
  push bx                                      ; 119C0  0x53
  call pin_reset_conout_flag                               ; 119C1  0xE8, 0x43, 0xFF
  mov ax, 2                                    ; 119C4  0xB8, 0x02, 0x00
  push ax                                      ; 119C7  0x50
  mov ax, 7                                    ; 119C8  0xB8, 0x07, 0x00
  push ax                                      ; 119CB  0x50
  les bx, [pin_cur_ccb]                              ; 119CC  0xC4, 0x1E, 0x58, 0x01
  mov al, [es:bx + 0xb]                        ; 119D0  0x26, 0x8A, 0x47, 0x0B
  mov ah, 0                                    ; 119D4  0xB4, 0x00
  push ax                                      ; 119D6  0x50
  call pin_pxios1                               ; 119D7  0xE8, 0x26, 0xFE
  les bx, [pin_cur_ccb]                              ; 119DA  0xC4, 0x1E, 0x58, 0x01
  push es                                      ; 119DE  0x06
  push bx                                      ; 119DF  0x53
  call pin_wake_vout                               ; 119E0  0xE8, 0x4B, 0xFF

loc_119E3:                                     ; 119E3
  pop bp                                       ; 119E3  0x5D
  ret 2                                        ; 119E4  0xC2, 0x02, 0x00

; -----------------------------------------------------------------------------
; pin_switch — Switches active virtual console
; Handles screen switch requests from XIOS.
; -----------------------------------------------------------------------------
pin_switch:                                     ; 119E7
  push bp                                      ; 119E7  0x55
  db 0x8B, 0xEC                                ; 119E8  mov bp, sp
  les ax, [pin_cur_ccb]                              ; 119EA  0xC4, 0x06, 0x58, 0x01
  mov [pin_prev_ccb], ax                              ; 119EE  0xA3, 0x5C, 0x01
  mov [pin_prev_ccb_seg], es                              ; 119F1  0x8C, 0x06, 0x5E, 0x01
  mov al, [bp + 4]                             ; 119F5  0x8A, 0x46, 0x04
  mov ah, 0                                    ; 119F8  0xB4, 0x00
  mov cx, 0x2c                                 ; 119FA  0xB9, 0x2C, 0x00
  db 0xF7, 0xE1                                ; 119FD  mul cx
  les bx, [pin_sysdat_ptr]                              ; 119FF  0xC4, 0x1E, 0x40, 0x01
  add ax, [es:bx + 0x54]                       ; 11A03  0x26, 0x03, 0x47, 0x54
  mov [pin_cur_ccb], ax                              ; 11A07  0xA3, 0x58, 0x01
  pop bp                                       ; 11A0A  0x5D
  ret 2                                        ; 11A0B  0xC2, 0x02, 0x00

; -----------------------------------------------------------------------------
; pin_controlC — Processes Ctrl-C keyboard interrupt
; If process has pcm set, passes through to vinq; otherwise aborts process.
; -----------------------------------------------------------------------------
pin_controlC:                                     ; 11A0E
  push bp                                      ; 11A0E  0x55
  db 0x8B, 0xEC                                ; 11A0F  mov bp, sp
  mov al, [pin_cword]                              ; 11A11  0xA0, 0x7E, 0x01
  cmp al, [pin_scan_max]                              ; 11A14  0x3A, 0x06, 0x8E, 0x01
  jb loc_11A1C                                 ; 11A18  0x72, 0x02
  pop bp                                       ; 11A1A  0x5D
  ret                                          ; 11A1B  0xC3

loc_11A1C:                                     ; 11A1C
  les bx, [pin_cur_ccb]                              ; 11A1C  0xC4, 0x1E, 0x58, 0x01
  mov ax, [es:bx + 0xe]                        ; 11A20  0x26, 0x8B, 0x47, 0x0E
  and ax, strict word 8                        ; 11A24  25 08 00
  cmp ax, 0                                    ; 11A27  0x83, 0xF8, 0x00
  je loc_11A2E                                 ; 11A2A  0x74, 0x02
  pop bp                                       ; 11A2C  0x5D
  ret                                          ; 11A2D  0xC3

loc_11A2E:                                     ; 11A2E
  call pin_get_cons_mode                               ; 11A2E  0xE8, 0x0F, 0xFE
  mov ax, [pin_cnmode]                              ; 11A31  0xA1, 0x66, 0x01
  and ax, 0xff                                 ; 11A34  0x25, 0xFF, 0x00
  cmp ax, 0xf                                  ; 11A37  0x83, 0xF8, 0x0F
  jbe loc_11A3E                                ; 11A3A  0x76, 0x02
  pop bp                                       ; 11A3C  0x5D
  ret                                          ; 11A3D  0xC3

loc_11A3E:                                     ; 11A3E
  mov al, [pin_scan_step]                              ; 11A3E  0xA0, 0x8F, 0x01
  add [pin_cword], al                              ; 11A41  0x00, 0x06, 0x7E, 0x01
  mov al, [pin_cword]                              ; 11A45  0xA0, 0x7E, 0x01
  les bx, [pin_cur_ccb]                              ; 11A48  0xC4, 0x1E, 0x58, 0x01
  cmp al, [es:bx + 0xb]                        ; 11A4C  0x26, 0x3A, 0x47, 0x0B
  jne loc_11A54                                ; 11A50  0x75, 0x02
  pop bp                                       ; 11A52  0x5D
  ret                                          ; 11A53  0xC3

loc_11A54:                                     ; 11A54
  mov al, [pin_cword]                              ; 11A54  0xA0, 0x7E, 0x01
  mov [pin_scan_state], al                              ; 11A57  0xA2, 0x91, 0x01
  push word [pin_cword]                            ; 11A5A  0xFF, 0x36, 0x7E, 0x01
  call pin_switch                               ; 11A5E  0xE8, 0x86, 0xFF
  les bx, [pin_prev_ccb]                              ; 11A61  0xC4, 0x1E, 0x5C, 0x01
  push word [es:bx + 0x16]                     ; 11A65  0x26, 0xFF, 0x77, 0x16
  call pin_write_change_mxq                               ; 11A69  0xE8, 0x43, 0xFE
  les bx, [pin_prev_ccb]                              ; 11A6C  0xC4, 0x1E, 0x5C, 0x01
  push es                                      ; 11A70  0x06
  push bx                                      ; 11A71  0x53
  call pin_reset_conout_flag                               ; 11A72  0xE8, 0x92, 0xFE
  les bx, [pin_prev_ccb]                              ; 11A75  0xC4, 0x1E, 0x5C, 0x01
  mov ax, [es:bx]                              ; 11A79  0x26, 0x8B, 0x07
  mov [pin_pd_ptr], ax                              ; 11A7C  0xA3, 0x44, 0x01
  les si, [pin_pd_ptr]                              ; 11A7F  0xC4, 0x36, 0x44, 0x01
  mov ax, [es:si + 0x10]                       ; 11A83  0x26, 0x8B, 0x44, 0x10
  mov [pin_uda_seg], ax                              ; 11A87  0xA3, 0x4A, 0x01
  mov word [pin_flags], 0                          ; 11A8A  0xC7, 0x06, 0x48, 0x01, 0x00, 0x00
  mov ax, [es:si + 0x26]                       ; 11A90  0x26, 0x8B, 0x44, 0x26
  and ax, strict word 1                        ; 11A94  25 01 00
  rcr al, 1                                    ; 11A97  0xD0, 0xD8
  jae loc_11AA5                                ; 11A99  0x73, 0x0A
  mov es, [pin_prev_ccb_seg]                              ; 11A9B  0x8E, 0x06, 0x5E, 0x01
  db 0x26, 0x81, 0x4F, 0x0E, 0x10, 0x00        ; 11A9F  or word [es:bx + 0xe], 0x10

loc_11AA5:                                     ; 11AA5
  mov al, 0x9c                                 ; 11AA5  0xB0, 0x9C
  push ax                                      ; 11AA7  0x50
  mov ax, 0                                    ; 11AA8  0xB8, 0x00, 0x00
  push ax                                      ; 11AAB  0x50
  db 0xE8, 0x21, 0xFD                          ; 11AAC  call 0x117d0
  mov [pin_pd_ptr], bx                              ; 11AAF  0x89, 0x1E, 0x44, 0x01
  mov [pin_pd_seg], es                              ; 11AB3  0x8C, 0x06, 0x46, 0x01
  les bx, [pin_prev_ccb]                              ; 11AB7  0xC4, 0x1E, 0x5C, 0x01
  mov ax, [es:bx + 0xe]                        ; 11ABB  0x26, 0x8B, 0x47, 0x0E
  or ax, strict word 2                         ; 11ABF  0D 02 00
  mov [es:bx + 0xe], ax                        ; 11AC2  0x26, 0x89, 0x47, 0x0E
  and ax, strict word 4                        ; 11AC6  25 04 00
  cmp ax, 0                                    ; 11AC9  0x83, 0xF8, 0x00
  je loc_11AD4                                 ; 11ACC  0x74, 0x06
  db 0x26, 0x81, 0x67, 0x0E, 0xFB, 0xFF        ; 11ACE  and word [es:bx + 0xe], 0xfffb

loc_11AD4:                                     ; 11AD4
  les bx, [pin_cur_ccb]                              ; 11AD4  0xC4, 0x1E, 0x58, 0x01
  push word [es:bx + 0x16]                     ; 11AD8  0x26, 0xFF, 0x77, 0x16
  call pin_write_change_mxq                               ; 11ADC  0xE8, 0xD0, 0xFD
  les bx, [pin_cur_ccb]                              ; 11ADF  0xC4, 0x1E, 0x58, 0x01
  push es                                      ; 11AE3  0x06
  push bx                                      ; 11AE4  0x53
  call pin_reset_conout_flag                               ; 11AE5  0xE8, 0x1F, 0xFE
  les bx, [pin_cur_ccb]                              ; 11AE8  0xC4, 0x1E, 0x58, 0x01
  mov al, [es:bx + 0xa]                        ; 11AEC  0x26, 0x8A, 0x47, 0x0A
  mov ah, 0                                    ; 11AF0  0xB4, 0x00
  mov [pin_saved_wrd], ax                              ; 11AF2  0xA3, 0x64, 0x01
  mov cl, 8                                    ; 11AF5  0xB1, 0x08
  shl ax, cl                                   ; 11AF7  0xD3, 0xE0
  mov cl, [es:bx + 0xb]                        ; 11AF9  0x26, 0x8A, 0x4F, 0x0B
  mov ch, 0                                    ; 11AFD  0xB5, 0x00
  db 0x03, 0xC1                                ; 11AFF  add ax, cx
  mov [pin_saved_wrd], ax                              ; 11B01  0xA3, 0x64, 0x01
  mov cx, 7                                    ; 11B04  0xB9, 0x07, 0x00
  push cx                                      ; 11B07  0x51
  mov cx, 0                                    ; 11B08  0xB9, 0x00, 0x00
  push cx                                      ; 11B0B  0x51
  push ax                                      ; 11B0C  0x50
  call pin_pxios1                               ; 11B0D  0xE8, 0xF0, 0xFC
  les ax, [pin_prev_ccb]                              ; 11B10  0xC4, 0x06, 0x5C, 0x01
  push es                                      ; 11B14  0x06
  push ax                                      ; 11B15  0x50
  call pin_wake_vout                               ; 11B16  0xE8, 0x15, 0xFE
  les bx, [pin_prev_ccb]                              ; 11B19  0xC4, 0x1E, 0x5C, 0x01
  push word [es:bx + 0x16]                     ; 11B1D  0x26, 0xFF, 0x77, 0x16
  call pin_sleep                               ; 11B21  0xE8, 0xA2, 0xFD
  les bx, [pin_prev_ccb]                              ; 11B24  0xC4, 0x1E, 0x5C, 0x01
  mov ax, [es:bx + 0xe]                        ; 11B28  0x26, 0x8B, 0x47, 0x0E
  and ax, strict word 1                        ; 11B2C  25 01 00
  cmp ax, 0                                    ; 11B2F  0x83, 0xF8, 0x00
  je loc_11B39                                 ; 11B32  0x74, 0x05
  push es                                      ; 11B34  0x06
  push bx                                      ; 11B35  0x53
  call pin_write_vinq                               ; 11B36  0xE8, 0x0B, 0xFE

loc_11B39:                                     ; 11B39
  les bx, [pin_cur_ccb]                              ; 11B39  0xC4, 0x1E, 0x58, 0x01
  mov ax, [es:bx + 0xe]                        ; 11B3D  0x26, 0x8B, 0x47, 0x0E
  and ax, strict word 0x10                     ; 11B41  25 10 00
  cmp ax, 0                                    ; 11B44  0x83, 0xF8, 0x00
  je loc_11BC1                                 ; 11B47  0x74, 0x78
  cli                                          ; 11B49  0xFA
  db 0x26, 0x81, 0x67, 0x0E, 0xEF, 0xFF        ; 11B4A  and word [es:bx + 0xe], 0xffef
  mov ax, [es:bx]                              ; 11B50  0x26, 0x8B, 0x07
  mov [pin_pd_ptr], ax                              ; 11B53  0xA3, 0x44, 0x01
  mov word [pin_pd_scan], 0xa8                       ; 11B56  0xC7, 0x06, 0x80, 0x01, 0xA8, 0x00

loc_11B5C:                                     ; 11B5C
  les bx, [pin_pd_scan]                              ; 11B5C  0xC4, 0x1E, 0x80, 0x01
  mov ax, [es:bx]                              ; 11B60  0x26, 0x8B, 0x07
  push ax                                      ; 11B63  0x50
  cmp ax, [pin_pd_ptr]                              ; 11B64  0x3B, 0x06, 0x44, 0x01
  mov al, 0xff                                 ; 11B68  0xB0, 0xFF
  jne loc_11B6D                                ; 11B6A  0x75, 0x01
  inc ax                                       ; 11B6C  0x40

loc_11B6D:                                     ; 11B6D
  pop cx                                       ; 11B6D  0x59
  push ax                                      ; 11B6E  0x50
  cmp cx, 0                                    ; 11B6F  0x83, 0xF9, 0x00
  mov al, 0xff                                 ; 11B72  0xB0, 0xFF
  jne loc_11B77                                ; 11B74  0x75, 0x01
  inc ax                                       ; 11B76  0x40

loc_11B77:                                     ; 11B77
  pop dx                                       ; 11B77  0x5A
  db 0x22, 0xC2                                ; 11B78  and al, dl
  rcr al, 1                                    ; 11B7A  0xD0, 0xD8
  jae loc_11B84                                ; 11B7C  0x73, 0x06
  mov [pin_pd_scan], cx                              ; 11B7E  0x89, 0x0E, 0x80, 0x01
  jmp short loc_11B5C                          ; 11B82  0xEB, 0xD8

loc_11B84:                                     ; 11B84
  les bx, [pin_pd_scan]                              ; 11B84  0xC4, 0x1E, 0x80, 0x01
  mov ax, [es:bx]                              ; 11B88  0x26, 0x8B, 0x07
  cmp ax, [pin_pd_ptr]                              ; 11B8B  0x3B, 0x06, 0x44, 0x01
  jne loc_11BC0                                ; 11B8F  0x75, 0x2F
  push es                                      ; 11B91  0x06
  les si, [pin_pd_ptr]                              ; 11B92  0xC4, 0x36, 0x44, 0x01
  mov ax, [es:si]                              ; 11B96  0x26, 0x8B, 0x04
  pop es                                       ; 11B99  0x07
  mov [es:bx], ax                              ; 11B9A  0x26, 0x89, 0x07
  mov word [pin_pd_link], 0x6c                       ; 11B9D  0xC7, 0x06, 0x84, 0x01, 0x6C, 0x00
  les bx, [pin_pd_link]                              ; 11BA3  0xC4, 0x1E, 0x84, 0x01
  mov ax, [es:bx]                              ; 11BA7  0x26, 0x8B, 0x07
  mov es, [pin_pd_seg]                              ; 11BAA  0x8E, 0x06, 0x46, 0x01
  mov [es:si], ax                              ; 11BAE  0x26, 0x89, 0x04
  mov byte [es:si + 4], 0                      ; 11BB1  0x26, 0xC6, 0x44, 0x04, 0x00
  mov ax, [pin_pd_ptr]                              ; 11BB6  0xA1, 0x44, 0x01
  mov es, [pin_pd_link_seg]                              ; 11BB9  0x8E, 0x06, 0x86, 0x01
  mov [es:bx], ax                              ; 11BBD  0x26, 0x89, 0x07

loc_11BC0:                                     ; 11BC0
  sti                                          ; 11BC0  0xFB

loc_11BC1:                                     ; 11BC1
  les bx, [pin_cur_ccb]                              ; 11BC1  0xC4, 0x1E, 0x58, 0x01
  mov ax, [es:bx + 0xe]                        ; 11BC5  0x26, 0x8B, 0x47, 0x0E
  and ax, strict word 0xfffd                   ; 11BC9  25 FD FF
  mov [es:bx + 0xe], ax                        ; 11BCC  0x26, 0x89, 0x47, 0x0E
  and ax, strict word 1                        ; 11BD0  25 01 00
  cmp ax, 0                                    ; 11BD3  0x83, 0xF8, 0x00
  je loc_11BEB                                 ; 11BD6  0x74, 0x13
  mov ax, [es:bx + 0xe]                        ; 11BD8  0x26, 0x8B, 0x47, 0x0E
  or ax, strict word 4                         ; 11BDC  0D 04 00
  and ax, strict word 0xffbf                   ; 11BDF  25 BF FF
  mov [es:bx + 0xe], ax                        ; 11BE2  0x26, 0x89, 0x47, 0x0E
  push es                                      ; 11BE6  0x06
  push bx                                      ; 11BE7  0x53
  call pin_write_vinq                               ; 11BE8  0xE8, 0x59, 0xFD

loc_11BEB:                                     ; 11BEB
  les ax, [pin_cur_ccb]                              ; 11BEB  0xC4, 0x06, 0x58, 0x01
  push es                                      ; 11BEF  0x06
  push ax                                      ; 11BF0  0x50
  call pin_wake_vout                               ; 11BF1  0xE8, 0x3A, 0xFD
  les bx, [pin_cur_ccb]                              ; 11BF4  0xC4, 0x1E, 0x58, 0x01
  push word [es:bx + 0x16]                     ; 11BF8  0x26, 0xFF, 0x77, 0x16
  call pin_sleep                               ; 11BFC  0xE8, 0xC7, 0xFC
  les bx, [pin_cur_ccb]                              ; 11BFF  0xC4, 0x1E, 0x58, 0x01
  mov ax, [es:bx + 0xe]                        ; 11C03  0x26, 0x8B, 0x47, 0x0E
  and ax, 0x80                                 ; 11C07  0x25, 0x80, 0x00
  cmp ax, 0                                    ; 11C0A  0x83, 0xF8, 0x00
  je loc_11C16                                 ; 11C0D  0x74, 0x07
  mov byte [pin_suspend_flag], 0xff                       ; 11C0F  0xC6, 0x06, 0x93, 0x01, 0xFF
  jmp short loc_11C1B                          ; 11C14  0xEB, 0x05

loc_11C16:                                     ; 11C16
  mov byte [pin_suspend_flag], 0                          ; 11C16  0xC6, 0x06, 0x93, 0x01, 0x00

loc_11C1B:                                     ; 11C1B
  mov ax, 8                                    ; 11C1B  0xB8, 0x08, 0x00
  push ax                                      ; 11C1E  0x50
  mov ax, 0                                    ; 11C1F  0xB8, 0x00, 0x00
  push ax                                      ; 11C22  0x50
  les bx, [pin_cur_ccb]                              ; 11C23  0xC4, 0x1E, 0x58, 0x01
  mov al, [es:bx + 0xa]                        ; 11C27  0x26, 0x8A, 0x47, 0x0A
  mov ah, 0                                    ; 11C2B  0xB4, 0x00
  push ax                                      ; 11C2D  0x50
  call pin_pxios1                               ; 11C2E  0xE8, 0xCF, 0xFB
  pop bp                                       ; 11C31  0x5D
  ret                                          ; 11C32  0xC3

; -----------------------------------------------------------------------------
; pin_controlO — Toggles Ctrl-O console output suppression
; -----------------------------------------------------------------------------
pin_controlO:                                     ; 11C33
  push bp                                      ; 11C33  0x55
  db 0x8B, 0xEC                                ; 11C34  mov bp, sp
  les bx, [pin_pd_ptr]                              ; 11C36  0xC4, 0x1E, 0x44, 0x01
  mov ax, [es:bx + 0x22]                       ; 11C3A  0x26, 0x8B, 0x47, 0x22
  and ax, strict word 8                        ; 11C3E  25 08 00
  cmp ax, 0                                    ; 11C41  0x83, 0xF8, 0x00
  je loc_11C4F                                 ; 11C44  0x74, 0x09
  push word [pin_cword]                            ; 11C46  0xFF, 0x36, 0x7E, 0x01
  call pin_set_ccb                               ; 11C4A  0xE8, 0x4B, 0xFD
  pop bp                                       ; 11C4D  0x5D
  ret                                          ; 11C4E  0xC3

loc_11C4F:                                     ; 11C4F
  les bx, [pin_cur_ccb]                              ; 11C4F  0xC4, 0x1E, 0x58, 0x01
  push word [es:bx + 0x16]                     ; 11C53  0x26, 0xFF, 0x77, 0x16
  call pin_write_change_mxq                               ; 11C57  0xE8, 0x55, 0xFC
  les bx, [pin_cur_ccb]                              ; 11C5A  0xC4, 0x1E, 0x58, 0x01
  mov ax, [es:bx + 0xe]                        ; 11C5E  0x26, 0x8B, 0x47, 0x0E
  and ax, 0xfe7f                               ; 11C62  0x25, 0x7F, 0xFE
  mov [es:bx + 0xe], ax                        ; 11C65  0x26, 0x89, 0x47, 0x0E
  mov byte [pin_suspend_flag], 0                          ; 11C69  0xC6, 0x06, 0x93, 0x01, 0x00
  and ax, strict word 4                        ; 11C6E  25 04 00
  cmp ax, 0                                    ; 11C71  0x83, 0xF8, 0x00
  je loc_11C84                                 ; 11C74  0x74, 0x0E
  mov ax, [es:bx + 0xe]                        ; 11C76  0x26, 0x8B, 0x47, 0x0E
  and ax, strict word 0xfffb                   ; 11C7A  25 FB FF
  or ax, strict word 0x20                      ; 11C7D  0D 20 00
  mov [es:bx + 0xe], ax                        ; 11C80  0x26, 0x89, 0x47, 0x0E

loc_11C84:                                     ; 11C84
  les bx, [pin_cur_ccb]                              ; 11C84  0xC4, 0x1E, 0x58, 0x01
  mov ax, [es:bx + 0x12]                       ; 11C88  0x26, 0x8B, 0x47, 0x12
  mov [pin_listroot], ax                              ; 11C8C  0xA3, 0x6A, 0x01
  mov word [pin_drvmask_ptr], 0x188                      ; 11C8F  0xC7, 0x06, 0x6E, 0x01, 0x88, 0x01

loc_11C95:                                     ; 11C95
  mov al, 0x8a                                 ; 11C95  0xB0, 0x8A
  push ax                                      ; 11C97  0x50
  mov ax, 0x168                                ; 11C98  0xB8, 0x68, 0x01
  push ax                                      ; 11C9B  0x50
  db 0xE8, 0x31, 0xFB                          ; 11C9C  call 0x117d0
  cmp al, 0xff                                 ; 11C9F  0x3C, 0xFF
  jne loc_11C95                                ; 11CA1  0x75, 0xF2
  les bx, [pin_cur_ccb]                              ; 11CA3  0xC4, 0x1E, 0x58, 0x01
  mov byte [es:bx + 7], 0                      ; 11CA7  0x26, 0xC6, 0x47, 0x07, 0x00
  push word [es:bx + 0x16]                     ; 11CAC  0x26, 0xFF, 0x77, 0x16
  call pin_sleep                               ; 11CB0  0xE8, 0x13, 0xFC
  les bx, [pin_cur_ccb]                              ; 11CB3  0xC4, 0x1E, 0x58, 0x01
  push es                                      ; 11CB7  0x06
  push bx                                      ; 11CB8  0x53
  call pin_write_vinq                               ; 11CB9  0xE8, 0x88, 0xFC
  les bx, [pin_cur_ccb]                              ; 11CBC  0xC4, 0x1E, 0x58, 0x01
  lea ax, [bx + 0x24]                          ; 11CC0  0x8D, 0x47, 0x24
  push ax                                      ; 11CC3  0x50
  call pin_set_conout_flag                               ; 11CC4  0xE8, 0x2B, 0xFC
  les bx, [pin_cur_ccb]                              ; 11CC7  0xC4, 0x1E, 0x58, 0x01
  mov ax, [es:bx]                              ; 11CCB  0x26, 0x8B, 0x07
  mov [pin_vinq_msg], ax                              ; 11CCE  0xA3, 0x78, 0x01
  mov al, 0x9d                                 ; 11CD1  0xB0, 0x9D
  push ax                                      ; 11CD3  0x50
  mov ax, 0x178                                ; 11CD4  0xB8, 0x78, 0x01
  push ax                                      ; 11CD7  0x50
  db 0xE8, 0xF5, 0xFA                          ; 11CD8  call 0x117d0
  mov al, 0x18                                 ; 11CDB  0xB0, 0x18
  push ax                                      ; 11CDD  0x50
  mov ax, 0                                    ; 11CDE  0xB8, 0x00, 0x00
  push ax                                      ; 11CE1  0x50
  db 0xE8, 0xEB, 0xFA                          ; 11CE2  call 0x117d0
  mov [pin_drive_avail], ax                              ; 11CE5  0xA3, 0x8C, 0x01
  mov word [pin_drive_mask], 1                          ; 11CE8  0xC7, 0x06, 0x8A, 0x01, 0x01, 0x00
  mov byte [pin_drive_count], 0                          ; 11CEE  0xC6, 0x06, 0xA5, 0x01, 0x00
  mov word [pin_drive_idx], 0                          ; 11CF3  0xC7, 0x06, 0x88, 0x01, 0x00, 0x00

loc_11CF9:                                     ; 11CF9
  cmp word [pin_drive_idx], 0xf                        ; 11CF9  0x83, 0x3E, 0x88, 0x01, 0x0F
  ja loc_11D39                                 ; 11CFE  0x77, 0x39
  mov ax, [pin_drive_avail]                              ; 11D00  0xA1, 0x8C, 0x01
  and ax, [pin_drive_mask]                              ; 11D03  0x23, 0x06, 0x8A, 0x01
  cmp ax, 0                                    ; 11D07  0x83, 0xF8, 0x00
  je loc_11D2E                                 ; 11D0A  0x74, 0x22
  mov al, 0x25                                 ; 11D0C  0xB0, 0x25
  push ax                                      ; 11D0E  0x50
  push word [pin_drive_mask]                            ; 11D0F  0xFF, 0x36, 0x8A, 0x01
  db 0xE8, 0xBA, 0xFA                          ; 11D13  call 0x117d0
  cmp al, 0                                    ; 11D16  0x3C, 0x00
  je loc_11D2E                                 ; 11D18  0x74, 0x14
  mov ax, [pin_drive_idx]                              ; 11D1A  0xA1, 0x88, 0x01
  add ax, 0x41                                 ; 11D1D  0x83, 0xC0, 0x41
  mov bl, [pin_drive_count]                              ; 11D20  0x8A, 0x1E, 0xA5, 0x01
  mov bh, 0                                    ; 11D24  0xB7, 0x00
  mov [bx + 0x194], al                         ; 11D26  0x88, 0x87, 0x94, 0x01
  inc byte [pin_drive_count]                             ; 11D2A  0xFE, 0x06, 0xA5, 0x01

loc_11D2E:                                     ; 11D2E
  shl word [pin_drive_mask], 1                          ; 11D2E  0xD1, 0x26, 0x8A, 0x01
  add word [pin_drive_idx], 1                          ; 11D32  0x83, 0x06, 0x88, 0x01, 0x01
  jae loc_11CF9                                ; 11D37  0x73, 0xC0

loc_11D39:                                     ; 11D39
  cmp byte [pin_drive_count], 0                          ; 11D39  0x80, 0x3E, 0xA5, 0x01, 0x00
  ja loc_11D43                                 ; 11D3E  0x77, 0x03
  jmp near loc_11DC8                           ; 11D40  0xE9, 0x85, 0x00

loc_11D43:                                     ; 11D43
  les bx, [pin_cur_ccb]                              ; 11D43  0xC4, 0x1E, 0x58, 0x01
  push es                                      ; 11D47  0x06
  push bx                                      ; 11D48  0x53
  call pin_reset_conout_flag                               ; 11D49  0xE8, 0xBB, 0xFB
  mov al, 0xff                                 ; 11D4C  0xB0, 0xFF
  push ax                                      ; 11D4E  0x50
  mov al, 0                                    ; 11D4F  0xB0, 0x00
  push ax                                      ; 11D51  0x50
  lea ax, [pin_msg_drive_err]                              ; 11D52  0x8D, 0x06, 0xA8, 0x01
  push ds                                      ; 11D56  0x1E
  push ax                                      ; 11D57  0x50
  call pin_read_change_mxq                               ; 11D58  0xE8, 0x03, 0xFB
  mov al, 1                                    ; 11D5B  0xB0, 0x01
  push ax                                      ; 11D5D  0x50
  mov al, 0                                    ; 11D5E  0xB0, 0x00
  push ax                                      ; 11D60  0x50
  lea ax, [pin_drive_list]                              ; 11D61  0x8D, 0x06, 0x94, 0x01
  push ds                                      ; 11D65  0x1E
  push ax                                      ; 11D66  0x50
  call pin_read_change_mxq                               ; 11D67  0xE8, 0xF4, 0xFA
  mov word [pin_drive_idx], 1                          ; 11D6A  0xC7, 0x06, 0x88, 0x01, 0x01, 0x00

loc_11D70:                                     ; 11D70
  mov al, [pin_drive_count]                              ; 11D70  0xA0, 0xA5, 0x01
  dec al                                       ; 11D73  0xFE, 0xC8
  mov ah, 0                                    ; 11D75  0xB4, 0x00
  cmp [pin_drive_idx], ax                              ; 11D77  0x39, 0x06, 0x88, 0x01
  ja loc_11DA6                                 ; 11D7B  0x77, 0x29
  mov al, 1                                    ; 11D7D  0xB0, 0x01
  push ax                                      ; 11D7F  0x50
  mov al, 0                                    ; 11D80  0xB0, 0x00
  push ax                                      ; 11D82  0x50
  lea ax, [pin_msg_comma]                              ; 11D83  0x8D, 0x06, 0xC1, 0x01
  push ds                                      ; 11D87  0x1E
  push ax                                      ; 11D88  0x50
  call pin_read_change_mxq                               ; 11D89  0xE8, 0xD2, 0xFA
  mov al, 1                                    ; 11D8C  0xB0, 0x01
  push ax                                      ; 11D8E  0x50
  mov al, 0                                    ; 11D8F  0xB0, 0x00
  push ax                                      ; 11D91  0x50
  mov bx, [pin_drive_idx]                              ; 11D92  0x8B, 0x1E, 0x88, 0x01
  lea ax, [bx + 0x194]                         ; 11D96  0x8D, 0x87, 0x94, 0x01
  push ds                                      ; 11D9A  0x1E
  push ax                                      ; 11D9B  0x50
  call pin_read_change_mxq                               ; 11D9C  0xE8, 0xBF, 0xFA
  add word [pin_drive_idx], 1                          ; 11D9F  0x83, 0x06, 0x88, 0x01, 0x01
  jae loc_11D70                                ; 11DA4  0x73, 0xCA

loc_11DA6:                                     ; 11DA6
  mov al, 2                                    ; 11DA6  0xB0, 0x02
  push ax                                      ; 11DA8  0x50
  mov al, 0                                    ; 11DA9  0xB0, 0x00
  push ax                                      ; 11DAB  0x50
  lea ax, [pin_msg_comma_crlf]                              ; 11DAC  0x8D, 0x06, 0xC2, 0x01
  push ds                                      ; 11DB0  0x1E
  push ax                                      ; 11DB1  0x50
  call pin_read_change_mxq                               ; 11DB2  0xE8, 0xA9, 0xFA
  les bx, [pin_cur_ccb]                              ; 11DB5  0xC4, 0x1E, 0x58, 0x01
  mov byte [es:bx + 5], 0                      ; 11DB9  0x26, 0xC6, 0x47, 0x05, 0x00
  mov byte [es:bx + 6], 0                      ; 11DBE  0x26, 0xC6, 0x47, 0x06, 0x00
  push es                                      ; 11DC3  0x06
  push bx                                      ; 11DC4  0x53
  call pin_wake_vout                               ; 11DC5  0xE8, 0x66, 0xFB

loc_11DC8:                                     ; 11DC8
  pop bp                                       ; 11DC8  0x5D
  ret                                          ; 11DC9  0xC3

; -----------------------------------------------------------------------------
; pin_turn_off_ctrlO — Turns off Ctrl-O output suppression on any keystroke
; -----------------------------------------------------------------------------
pin_turn_off_ctrlO:                                     ; 11DCA
  push bp                                      ; 11DCA  0x55
  db 0x8B, 0xEC                                ; 11DCB  mov bp, sp
  les bx, [pin_pd_ptr]                              ; 11DCD  0xC4, 0x1E, 0x44, 0x01
  mov ax, [es:bx + 0x22]                       ; 11DD1  0x26, 0x8B, 0x47, 0x22
  and ax, 0x80                                 ; 11DD5  0x25, 0x80, 0x00
  cmp ax, 0                                    ; 11DD8  0x83, 0xF8, 0x00
  je loc_11DE6                                 ; 11DDB  0x74, 0x09
  push word [pin_cword]                            ; 11DDD  0xFF, 0x36, 0x7E, 0x01
  call pin_set_ccb                               ; 11DE1  0xE8, 0xB4, 0xFB
  pop bp                                       ; 11DE4  0x5D
  ret                                          ; 11DE5  0xC3

loc_11DE6:                                     ; 11DE6
  les bx, [pin_cur_ccb]                              ; 11DE6  0xC4, 0x1E, 0x58, 0x01
  push word [es:bx + 0x16]                     ; 11DEA  0x26, 0xFF, 0x77, 0x16
  call pin_write_change_mxq                               ; 11DEE  0xE8, 0xBE, 0xFA
  les bx, [pin_cur_ccb]                              ; 11DF1  0xC4, 0x1E, 0x58, 0x01
  xor word [es:bx + 0xe], 0x100                ; 11DF5  0x26, 0x81, 0x77, 0x0E, 0x00, 0x01
  push word [es:bx + 0x16]                     ; 11DFB  0x26, 0xFF, 0x77, 0x16
  call pin_sleep                               ; 11DFF  0xE8, 0xC4, 0xFA
  les bx, [pin_cur_ccb]                              ; 11E02  0xC4, 0x1E, 0x58, 0x01
  push es                                      ; 11E06  0x06
  push bx                                      ; 11E07  0x53
  call pin_write_vinq                               ; 11E08  0xE8, 0x39, 0xFB
  mov ax, 8                                    ; 11E0B  0xB8, 0x08, 0x00
  push ax                                      ; 11E0E  0x50
  mov ax, 0                                    ; 11E0F  0xB8, 0x00, 0x00
  push ax                                      ; 11E12  0x50
  les bx, [pin_cur_ccb]                              ; 11E13  0xC4, 0x1E, 0x58, 0x01
  mov al, [es:bx + 0xa]                        ; 11E17  0x26, 0x8A, 0x47, 0x0A
  mov ah, 0                                    ; 11E1B  0xB4, 0x00
  push ax                                      ; 11E1D  0x50
  call pin_pxios1                               ; 11E1E  0xE8, 0xDF, 0xF9
  pop bp                                       ; 11E21  0x5D
  ret                                          ; 11E22  0xC3

; -----------------------------------------------------------------------------
; pin_controlS — Handles Ctrl-S screen freeze / pause
; Suspends console output until Ctrl-Q or other resumption.
; -----------------------------------------------------------------------------
pin_controlS:                                     ; 11E23
  push bp                                      ; 11E23  0x55
  db 0x8B, 0xEC                                ; 11E24  mov bp, sp
  les bx, [pin_cur_ccb]                              ; 11E26  0xC4, 0x1E, 0x58, 0x01
  push word [es:bx + 0x16]                     ; 11E2A  0x26, 0xFF, 0x77, 0x16
  call pin_write_change_mxq                               ; 11E2E  0xE8, 0x7E, 0xFA
  les bx, [pin_cur_ccb]                              ; 11E31  0xC4, 0x1E, 0x58, 0x01
  and word [es:bx + 0xe], 0xfeff               ; 11E35  0x26, 0x81, 0x67, 0x0E, 0xFF, 0xFE
  push word [es:bx + 0x16]                     ; 11E3B  0x26, 0xFF, 0x77, 0x16
  call pin_sleep                               ; 11E3F  0xE8, 0x84, 0xFA
  les bx, [pin_cur_ccb]                              ; 11E42  0xC4, 0x1E, 0x58, 0x01
  push es                                      ; 11E46  0x06
  push bx                                      ; 11E47  0x53
  call pin_write_vinq                               ; 11E48  0xE8, 0xF9, 0xFA
  mov ax, 8                                    ; 11E4B  0xB8, 0x08, 0x00
  push ax                                      ; 11E4E  0x50
  mov ax, 0                                    ; 11E4F  0xB8, 0x00, 0x00
  push ax                                      ; 11E52  0x50
  les bx, [pin_cur_ccb]                              ; 11E53  0xC4, 0x1E, 0x58, 0x01
  mov al, [es:bx + 0xa]                        ; 11E57  0x26, 0x8A, 0x47, 0x0A
  mov ah, 0                                    ; 11E5B  0xB4, 0x00
  push ax                                      ; 11E5D  0x50
  call pin_pxios1                               ; 11E5E  0xE8, 0x9F, 0xF9
  pop bp                                       ; 11E61  0x5D
  ret                                          ; 11E62  0xC3

; -----------------------------------------------------------------------------
; pin_controlQ — Handles Ctrl-Q resume screen output
; Clears csm and wakes VOUT and user processes.
; -----------------------------------------------------------------------------
pin_controlQ:                                     ; 11E63
  push bp                                      ; 11E63  0x55
  db 0x8B, 0xEC                                ; 11E64  mov bp, sp
  les bx, [pin_pd_ptr]                              ; 11E66  0xC4, 0x1E, 0x44, 0x01
  mov ax, [es:bx + 6]                          ; 11E6A  0x26, 0x8B, 0x47, 0x06
  and ax, 0x1000                               ; 11E6E  0x25, 0x00, 0x10
  cmp ax, 0                                    ; 11E71  0x83, 0xF8, 0x00
  je loc_11E78                                 ; 11E74  0x74, 0x02
  pop bp                                       ; 11E76  0x5D
  ret                                          ; 11E77  0xC3

loc_11E78:                                     ; 11E78
  les bx, [pin_pd_ptr]                              ; 11E78  0xC4, 0x1E, 0x44, 0x01
  mov ax, [es:bx + 0x22]                       ; 11E7C  0x26, 0x8B, 0x47, 0x22
  and ax, strict word 2                        ; 11E80  25 02 00
  cmp ax, 0                                    ; 11E83  0x83, 0xF8, 0x00
  je loc_11E91                                 ; 11E86  0x74, 0x09
  push word [pin_cword]                            ; 11E88  0xFF, 0x36, 0x7E, 0x01
  call pin_set_ccb                               ; 11E8C  0xE8, 0x09, 0xFB
  pop bp                                       ; 11E8F  0x5D
  ret                                          ; 11E90  0xC3

loc_11E91:                                     ; 11E91
  les bx, [pin_cur_ccb]                              ; 11E91  0xC4, 0x1E, 0x58, 0x01
  push word [es:bx + 0x16]                     ; 11E95  0x26, 0xFF, 0x77, 0x16
  call pin_write_change_mxq                               ; 11E99  0xE8, 0x13, 0xFA
  les bx, [pin_cur_ccb]                              ; 11E9C  0xC4, 0x1E, 0x58, 0x01
  mov ax, [es:bx + 0xe]                        ; 11EA0  0x26, 0x8B, 0x47, 0x0E
  and ax, 0xfeff                               ; 11EA4  0x25, 0xFF, 0xFE
  or ax, 0x80                                  ; 11EA7  0x0D, 0x80, 0x00
  mov [es:bx + 0xe], ax                        ; 11EAA  0x26, 0x89, 0x47, 0x0E
  mov ax, 8                                    ; 11EAE  0xB8, 0x08, 0x00
  push ax                                      ; 11EB1  0x50
  mov ax, 0                                    ; 11EB2  0xB8, 0x00, 0x00
  push ax                                      ; 11EB5  0x50
  mov al, [es:bx + 0xa]                        ; 11EB6  0x26, 0x8A, 0x47, 0x0A
  mov ah, 0                                    ; 11EBA  0xB4, 0x00
  push ax                                      ; 11EBC  0x50
  call pin_pxios1                               ; 11EBD  0xE8, 0x40, 0xF9
  les bx, [pin_cur_ccb]                              ; 11EC0  0xC4, 0x1E, 0x58, 0x01
  push word [es:bx + 0x16]                     ; 11EC4  0x26, 0xFF, 0x77, 0x16
  call pin_sleep                               ; 11EC8  0xE8, 0xFB, 0xF9
  mov byte [pin_suspend_flag], 0xff                       ; 11ECB  0xC6, 0x06, 0x93, 0x01, 0xFF
  pop bp                                       ; 11ED0  0x5D
  ret                                          ; 11ED1  0xC3

; -----------------------------------------------------------------------------
; pin_controlP — Toggles Ctrl-P printer echoing / mimic mode
; -----------------------------------------------------------------------------
pin_controlP:                                     ; 11ED2
  push bp                                      ; 11ED2  0x55
  db 0x8B, 0xEC                                ; 11ED3  mov bp, sp
  les bx, [pin_cur_ccb]                              ; 11ED5  0xC4, 0x1E, 0x58, 0x01
  push word [es:bx + 0x16]                     ; 11ED9  0x26, 0xFF, 0x77, 0x16
  call pin_write_change_mxq                               ; 11EDD  0xE8, 0xCF, 0xF9
  les bx, [pin_cur_ccb]                              ; 11EE0  0xC4, 0x1E, 0x58, 0x01
  and word [es:bx + 0xe], 0xff7f               ; 11EE4  0x26, 0x81, 0x67, 0x0E, 0x7F, 0xFF
  push word [es:bx + 0x16]                     ; 11EEA  0x26, 0xFF, 0x77, 0x16
  call pin_sleep                               ; 11EEE  0xE8, 0xD5, 0xF9
  les bx, [pin_cur_ccb]                              ; 11EF1  0xC4, 0x1E, 0x58, 0x01
  push es                                      ; 11EF5  0x06
  push bx                                      ; 11EF6  0x53
  call pin_write_vinq                               ; 11EF7  0xE8, 0x4A, 0xFA
  les bx, [pin_cur_ccb]                              ; 11EFA  0xC4, 0x1E, 0x58, 0x01
  lea ax, [bx + 0x24]                          ; 11EFE  0x8D, 0x47, 0x24
  push ax                                      ; 11F01  0x50
  call pin_set_conout_flag                               ; 11F02  0xE8, 0xED, 0xF9
  mov ax, 8                                    ; 11F05  0xB8, 0x08, 0x00
  push ax                                      ; 11F08  0x50
  mov ax, 0                                    ; 11F09  0xB8, 0x00, 0x00
  push ax                                      ; 11F0C  0x50
  les bx, [pin_cur_ccb]                              ; 11F0D  0xC4, 0x1E, 0x58, 0x01
  mov al, [es:bx + 0xa]                        ; 11F11  0x26, 0x8A, 0x47, 0x0A
  mov ah, 0                                    ; 11F15  0xB4, 0x00
  push ax                                      ; 11F17  0x50
  call pin_pxios1                               ; 11F18  0xE8, 0xE5, 0xF8
  mov byte [pin_suspend_flag], 0                          ; 11F1B  0xC6, 0x06, 0x93, 0x01, 0x00
  pop bp                                       ; 11F20  0x5D
  ret                                          ; 11F21  0xC3

; -----------------------------------------------------------------------------
; pin_raw — Checks if attached process has raw mode enabled (pf)
; -----------------------------------------------------------------------------
pin_raw:                                     ; 11F22
  push bp                                      ; 11F22  0x55
  db 0x8B, 0xEC                                ; 11F23  mov bp, sp
  les bx, [pin_pd_ptr]                              ; 11F25  0xC4, 0x1E, 0x44, 0x01
  mov ax, [es:bx + 0x22]                       ; 11F29  0x26, 0x8B, 0x47, 0x22
  and ax, strict word 4                        ; 11F2D  25 04 00
  cmp ax, 0                                    ; 11F30  0x83, 0xF8, 0x00
  je loc_11F3E                                 ; 11F33  0x74, 0x09
  push word [pin_cword]                            ; 11F35  0xFF, 0x36, 0x7E, 0x01
  call pin_set_ccb                               ; 11F39  0xE8, 0x5C, 0xFA
  pop bp                                       ; 11F3C  0x5D
  ret                                          ; 11F3D  0xC3

loc_11F3E:                                     ; 11F3E
  call pin_controlS                               ; 11F3E  0xE8, 0xE2, 0xFE
  les bx, [pin_cur_ccb]                              ; 11F41  0xC4, 0x1E, 0x58, 0x01
  push word [es:bx + 0x16]                     ; 11F45  0x26, 0xFF, 0x77, 0x16
  call pin_write_change_mxq                               ; 11F49  0xE8, 0x63, 0xF9
  les bx, [pin_cur_ccb]                              ; 11F4C  0xC4, 0x1E, 0x58, 0x01
  mov ax, [es:bx + 0xe]                        ; 11F50  0x26, 0x8B, 0x47, 0x0E
  and ax, 0x200                                ; 11F54  0x25, 0x00, 0x02
  mov cx, 0                                    ; 11F57  0xB9, 0x00, 0x00
  db 0x3B, 0xC1                                ; 11F5A  cmp ax, cx
  je loc_11F61                                 ; 11F5C  0x74, 0x03
  jmp near loc_12036                           ; 11F5E  0xE9, 0xD5, 0x00

loc_11F61:                                     ; 11F61
  les bx, [pin_pd_ptr]                              ; 11F61  0xC4, 0x1E, 0x44, 0x01
  mov al, [es:bx + 0x24]                       ; 11F65  0x26, 0x8A, 0x47, 0x24
  mov ah, 0                                    ; 11F69  0xB4, 0x00
  mov dx, 0xa                                  ; 11F6B  0xBA, 0x0A, 0x00
  db 0xF7, 0xE2                                ; 11F6E  mul dx
  les si, [pin_sysdat_ptr]                              ; 11F70  0xC4, 0x36, 0x40, 0x01
  add ax, [es:si + 0x86]                       ; 11F74  0x26, 0x03, 0x84, 0x86, 0x00
  mov [pin_wakeup_ptr], ax                              ; 11F79  0xA3, 0x60, 0x01
  cli                                          ; 11F7C  0xFA
  mov byte [pin_scan_char], 0xff                       ; 11F7D  0xC6, 0x06, 0x90, 0x01, 0xFF
  mov al, [es:si + 0x46]                       ; 11F82  0x26, 0x8A, 0x44, 0x46
  and al, 0x40                                 ; 11F86  0x24, 0x40
  db 0x3A, 0xC1                                ; 11F88  cmp al, cl
  je loc_11FD3                                 ; 11F8A  0x74, 0x47
  mov es, [pin_pd_seg]                              ; 11F8C  0x8E, 0x06, 0x46, 0x01
  cmp [es:bx + 0x1c], cx                       ; 11F90  0x26, 0x39, 0x4F, 0x1C
  je loc_11FD3                                 ; 11F94  0x74, 0x3D
  mov ax, [es:bx + 0x1c]                       ; 11F96  0x26, 0x8B, 0x47, 0x1C
  mov [pin_ext_seg], ax                              ; 11F9A  0xA3, 0x4E, 0x01
  mov [pin_ext_ptr], cx                              ; 11F9D  0x89, 0x0E, 0x4C, 0x01
  les si, [pin_ext_ptr]                              ; 11FA1  0xC4, 0x36, 0x4C, 0x01
  les ax, [es:si + 4]                          ; 11FA5  0x26, 0xC4, 0x44, 0x04
  mov [pin_ext2], ax                              ; 11FA9  0xA3, 0x50, 0x01
  mov [pin_ext2_seg], es                              ; 11FAC  0x8C, 0x06, 0x52, 0x01
  mov es, [pin_pd_seg]                              ; 11FB0  0x8E, 0x06, 0x46, 0x01
  mov dl, [es:bx + 0x24]                       ; 11FB4  0x26, 0x8A, 0x57, 0x24
  mov dh, 0                                    ; 11FB8  0xB6, 0x00
  shl dx, 1                                    ; 11FBA  0xD1, 0xE2
  mov bx, ax                                   ; 11FBC  0x89, 0xC3
  mov si, dx                                   ; 11FBE  0x89, 0xD6
  mov es, [pin_ext2_seg]                              ; 11FC0  0x8E, 0x06, 0x52, 0x01
  mov ax, [es:bx + si + 0x42]                  ; 11FC4  0x26, 0x8B, 0x40, 0x42
  and ax, 0x80                                 ; 11FC8  0x25, 0x80, 0x00
  db 0x3B, 0xC1                                ; 11FCB  cmp ax, cx
  je loc_11FD3                                 ; 11FCD  0x74, 0x04
  mov [pin_scan_char], cl                              ; 11FCF  0x88, 0x0E, 0x90, 0x01

loc_11FD3:                                     ; 11FD3
  les bx, [pin_wakeup_ptr]                              ; 11FD3  0xC4, 0x1E, 0x60, 0x01
  cmp word [es:bx], 0                          ; 11FD7  0x26, 0x83, 0x3F, 0x00
  jne loc_12008                                ; 11FDB  0x75, 0x2B
  mov al, [pin_scan_char]                              ; 11FDD  0xA0, 0x90, 0x01
  rcr al, 1                                    ; 11FE0  0xD0, 0xD8
  jae loc_12008                                ; 11FE2  0x73, 0x24
  mov word [es:bx], 0xffff                     ; 11FE4  0x26, 0xC7, 0x07, 0xFF, 0xFF
  mov al, [pin_scan_state]                              ; 11FE9  0xA0, 0x91, 0x01
  mov [es:bx + 9], al                          ; 11FEC  0x26, 0x88, 0x47, 0x09
  les bx, [pin_pd_ptr]                              ; 11FF0  0xC4, 0x1E, 0x44, 0x01
  mov al, [es:bx + 0x24]                       ; 11FF4  0x26, 0x8A, 0x47, 0x24
  les bx, [pin_cur_ccb]                              ; 11FF8  0xC4, 0x1E, 0x58, 0x01
  mov [es:bx + 8], al                          ; 11FFC  0x26, 0x88, 0x47, 0x08
  or word [es:bx + 0xe], 0x200                 ; 12000  0x26, 0x81, 0x4F, 0x0E, 0x00, 0x02
  jmp short loc_1207F                          ; 12006  0xEB, 0x77

loc_12008:                                     ; 12008
  sti                                          ; 12008  0xFB
  les bx, [pin_cur_ccb]                              ; 12009  0xC4, 0x1E, 0x58, 0x01
  push es                                      ; 1200D  0x06
  push bx                                      ; 1200E  0x53
  call pin_reset_conout_flag                               ; 1200F  0xE8, 0xF5, 0xF8
  mov al, 0xff                                 ; 12012  0xB0, 0xFF
  push ax                                      ; 12014  0x50
  mov al, 0                                    ; 12015  0xB0, 0x00
  push ax                                      ; 12017  0x50
  lea ax, [pin_msg_prn_busy]                              ; 12018  0x8D, 0x06, 0xC4, 0x01
  push ds                                      ; 1201C  0x1E
  push ax                                      ; 1201D  0x50
  call pin_read_change_mxq                               ; 1201E  0xE8, 0x3D, 0xF8
  les bx, [pin_cur_ccb]                              ; 12021  0xC4, 0x1E, 0x58, 0x01
  mov byte [es:bx + 6], 0                      ; 12025  0x26, 0xC6, 0x47, 0x06, 0x00
  mov byte [es:bx + 5], 0                      ; 1202A  0x26, 0xC6, 0x47, 0x05, 0x00
  push es                                      ; 1202F  0x06
  push bx                                      ; 12030  0x53
  call pin_wake_vout                               ; 12031  0xE8, 0xFA, 0xF8
  jmp short loc_12080                          ; 12034  0xEB, 0x4A

loc_12036:                                     ; 12036
  cli                                          ; 12036  0xFA
  les bx, [pin_cur_ccb]                              ; 12037  0xC4, 0x1E, 0x58, 0x01
  mov al, [es:bx + 8]                          ; 1203B  0x26, 0x8A, 0x47, 0x08
  mov ah, 0                                    ; 1203F  0xB4, 0x00
  mov cx, 0xa                                  ; 12041  0xB9, 0x0A, 0x00
  db 0xF7, 0xE1                                ; 12044  mul cx
  les si, [pin_sysdat_ptr]                              ; 12046  0xC4, 0x36, 0x40, 0x01
  add ax, [es:si + 0x86]                       ; 1204A  0x26, 0x03, 0x84, 0x86, 0x00
  mov [pin_wakeup_ptr], ax                              ; 1204F  0xA3, 0x60, 0x01
  les si, [pin_wakeup_ptr]                              ; 12052  0xC4, 0x36, 0x60, 0x01
  mov word [es:si], 0                          ; 12056  0x26, 0xC7, 0x04, 0x00, 0x00
  mov byte [es:si + 9], 0xff                   ; 1205B  0x26, 0xC6, 0x44, 0x09, 0xFF
  mov es, [pin_ext3_seg]                              ; 12060  0x8E, 0x06, 0x5A, 0x01
  mov byte [es:bx + 8], 0xff                   ; 12064  0x26, 0xC6, 0x47, 0x08, 0xFF
  and word [es:bx + 0xe], 0xfdff               ; 12069  0x26, 0x81, 0x67, 0x0E, 0xFF, 0xFD
  and byte [es:bx + 4], 0xdf                   ; 1206F  0x26, 0x80, 0x67, 0x04, 0xDF
  mov es, [pin_wakeup_seg]                              ; 12074  0x8E, 0x06, 0x62, 0x01
  lea ax, [si + 2]                             ; 12078  0x8D, 0x44, 0x02
  push ax                                      ; 1207B  0x50
  call pin_set_conout_flag                               ; 1207C  0xE8, 0x73, 0xF8

loc_1207F:                                     ; 1207F
  sti                                          ; 1207F  0xFB

loc_12080:                                     ; 12080
  les bx, [pin_cur_ccb]                              ; 12080  0xC4, 0x1E, 0x58, 0x01
  push word [es:bx + 0x16]                     ; 12084  0x26, 0xFF, 0x77, 0x16
  call pin_sleep                               ; 12088  0xE8, 0x3B, 0xF8
  mov ax, 8                                    ; 1208B  0xB8, 0x08, 0x00
  push ax                                      ; 1208E  0x50
  mov ax, 0                                    ; 1208F  0xB8, 0x00, 0x00
  push ax                                      ; 12092  0x50
  les bx, [pin_cur_ccb]                              ; 12093  0xC4, 0x1E, 0x58, 0x01
  mov al, [es:bx + 0xa]                        ; 12097  0x26, 0x8A, 0x47, 0x0A
  mov ah, 0                                    ; 1209B  0xB4, 0x00
  push ax                                      ; 1209D  0x50
  call pin_pxios1                               ; 1209E  0xE8, 0x5F, 0xF7
  pop bp                                       ; 120A1  0x5D
  ret                                          ; 120A2  0xC3

; -----------------------------------------------------------------------------
; pin_plmstart — Main initialization and event loop for PIN RSP
; Loops continuously reading keystrokes via pin_conin and routing them.
; -----------------------------------------------------------------------------
pin_plmstart:                                     ; 120A3
  push bp                                      ; 120A3  0x55
  db 0x8B, 0xEC                                ; 120A4  mov bp, sp
  les bx, [pin_cur_ccb]                              ; 120A6  0xC4, 0x1E, 0x58, 0x01
  mov ax, [es:bx]                              ; 120AA  0x26, 0x8B, 0x07
  mov [pin_pd_ptr], ax                              ; 120AD  0xA3, 0x44, 0x01
  cmp ax, 0                                    ; 120B0  0x83, 0xF8, 0x00
  je loc_120CC                                 ; 120B3  0x74, 0x17
  les bx, [pin_pd_ptr]                              ; 120B5  0xC4, 0x1E, 0x44, 0x01
  mov ax, [es:bx + 6]                          ; 120B9  0x26, 0x8B, 0x47, 0x06
  and ax, strict word 0x40                     ; 120BD  25 40 00
  cmp ax, 0                                    ; 120C0  0x83, 0xF8, 0x00
  jne loc_120C9                                ; 120C3  0x75, 0x04
  mov al, 0                                    ; 120C5  0xB0, 0x00
  pop bp                                       ; 120C7  0x5D
  ret                                          ; 120C8  0xC3

loc_120C9:                                     ; 120C9
  call pin_controlP                               ; 120C9  0xE8, 0x06, 0xFE

loc_120CC:                                     ; 120CC
  mov al, 0xff                                 ; 120CC  0xB0, 0xFF
  pop bp                                       ; 120CE  0x5D
  ret                                          ; 120CF  0xC3
  push bp                                      ; 120D0  0x55
  db 0x8B, 0xEC                                ; 120D1  mov bp, sp
  mov ax, [0]                                  ; 120D3  0xA1, 0x00, 0x00
  mov [pin_sysdat_seg], ax                              ; 120D6  0xA3, 0x42, 0x01
  mov [pin_wakeup_seg], ax                              ; 120D9  0xA3, 0x62, 0x01
  mov [pin_ext3_seg], ax                              ; 120DC  0xA3, 0x5A, 0x01
  mov [pin_pd_scan_seg], ax                              ; 120DF  0xA3, 0x82, 0x01
  mov [pin_pd_link_seg], ax                              ; 120E2  0xA3, 0x86, 0x01
  les bx, [pin_sysdat_ptr]                              ; 120E5  0xC4, 0x1E, 0x40, 0x01
  mov ax, [es:bx + 0x54]                       ; 120E9  0x26, 0x8B, 0x47, 0x54
  mov [pin_cur_ccb], ax                              ; 120ED  0xA3, 0x58, 0x01
  mov byte [pin_scan_step], 0                          ; 120F0  0xC6, 0x06, 0x8F, 0x01, 0x00

loc_120F5:                                     ; 120F5
  les bx, [pin_cur_ccb]                              ; 120F5  0xC4, 0x1E, 0x58, 0x01
  mov al, [es:bx + 0xa]                        ; 120F9  0x26, 0x8A, 0x47, 0x0A
  cmp al, [4]                                  ; 120FD  0x3A, 0x06, 0x04, 0x00
  je loc_1210A                                 ; 12101  0x74, 0x07
  add word [pin_cur_ccb], 0x2c                       ; 12103  0x83, 0x06, 0x58, 0x01, 0x2C
  jmp short loc_120F5                          ; 12108  0xEB, 0xEB

loc_1210A:                                     ; 1210A
  les bx, [pin_cur_ccb]                              ; 1210A  0xC4, 0x1E, 0x58, 0x01
  mov al, [es:bx + 0xb]                        ; 1210E  0x26, 0x8A, 0x47, 0x0B
  mov [pin_scan_step], al                              ; 12112  0xA2, 0x8F, 0x01
  mov byte [pin_scan_max], 1                          ; 12115  0xC6, 0x06, 0x8E, 0x01, 0x01

loc_1211A:                                     ; 1211A
  les bx, [pin_cur_ccb]                              ; 1211A  0xC4, 0x1E, 0x58, 0x01
  cmp word [es:bx + 0x28], 0                   ; 1211E  0x26, 0x83, 0x7F, 0x28, 0x00
  je loc_12132                                 ; 12123  0x74, 0x0D
  inc byte [pin_scan_max]                             ; 12125  0xFE, 0x06, 0x8E, 0x01
  mov ax, [es:bx + 0x28]                       ; 12129  0x26, 0x8B, 0x47, 0x28
  mov [pin_cur_ccb], ax                              ; 1212D  0xA3, 0x58, 0x01
  jmp short loc_1211A                          ; 12130  0xEB, 0xE8

loc_12132:                                     ; 12132
  mov al, [pin_scan_step]                              ; 12132  0xA0, 0x8F, 0x01
  mov ah, 0                                    ; 12135  0xB4, 0x00
  mov cx, 0x2c                                 ; 12137  0xB9, 0x2C, 0x00
  db 0xF7, 0xE1                                ; 1213A  mul cx
  les bx, [pin_sysdat_ptr]                              ; 1213C  0xC4, 0x1E, 0x40, 0x01
  add ax, [es:bx + 0x54]                       ; 12140  0x26, 0x03, 0x47, 0x54
  mov [pin_cur_ccb], ax                              ; 12144  0xA3, 0x58, 0x01
  mov al, 0x9c                                 ; 12147  0xB0, 0x9C
  push ax                                      ; 12149  0x50
  mov ax, 0                                    ; 1214A  0xB8, 0x00, 0x00
  push ax                                      ; 1214D  0x50
  db 0xE8, 0x7F, 0xF6                          ; 1214E  call 0x117d0
  mov [pin_pd_ptr], bx                              ; 12151  0x89, 0x1E, 0x44, 0x01
  mov [pin_pd_seg], es                              ; 12155  0x8C, 0x06, 0x46, 0x01
  mov al, [pin_scan_step]                              ; 12159  0xA0, 0x8F, 0x01
  mov [pin_scan_state], al                              ; 1215C  0xA2, 0x91, 0x01
  les bx, [pin_cur_ccb]                              ; 1215F  0xC4, 0x1E, 0x58, 0x01
  mov al, [es:bx + 0xa]                        ; 12163  0x26, 0x8A, 0x47, 0x0A
  mov ah, 0                                    ; 12167  0xB4, 0x00
  mov [pin_saved_wrd], ax                              ; 12169  0xA3, 0x64, 0x01
  mov cl, 8                                    ; 1216C  0xB1, 0x08
  shl ax, cl                                   ; 1216E  0xD3, 0xE0
  mov cl, [es:bx + 0xb]                        ; 12170  0x26, 0x8A, 0x4F, 0x0B
  mov ch, 0                                    ; 12174  0xB5, 0x00
  db 0x03, 0xC1                                ; 12176  add ax, cx
  mov [pin_saved_wrd], ax                              ; 12178  0xA3, 0x64, 0x01

loc_1217B:                                     ; 1217B
  call pin_conin                               ; 1217B  0xE8, 0xA4, 0xF6
  cmp byte [pin_cword_hi], 0xff                       ; 1217E  0x80, 0x3E, 0x7F, 0x01, 0xFF
  jne loc_1218A                                ; 12183  0x75, 0x05
  call pin_controlC                               ; 12185  0xE8, 0x86, 0xF8
  jmp short loc_1217B                          ; 12188  0xEB, 0xF1

loc_1218A:                                     ; 1218A
  mov al, [pin_cword_hi]                              ; 1218A  0xA0, 0x7F, 0x01
  and al, 1                                    ; 1218D  0x24, 0x01
  cmp al, 0                                    ; 1218F  0x3C, 0x00
  jne loc_1219A                                ; 12191  0x75, 0x07
  call pin_plmstart                               ; 12193  0xE8, 0x0D, 0xFF
  rcr al, 1                                    ; 12196  0xD0, 0xD8
  jae loc_121A3                                ; 12198  0x73, 0x09

loc_1219A:                                     ; 1219A
  push word [pin_cword]                            ; 1219A  0xFF, 0x36, 0x7E, 0x01
  call pin_set_ccb                               ; 1219E  0xE8, 0xF7, 0xF7
  jmp short loc_1217B                          ; 121A1  0xEB, 0xD8

loc_121A3:                                     ; 121A3
  mov al, [pin_suspend_flag]                              ; 121A3  0xA0, 0x93, 0x01
  rcr al, 1                                    ; 121A6  0xD0, 0xD8
  jae loc_121EE                                ; 121A8  0x73, 0x44
  cmp byte [pin_cword], 3                          ; 121AA  0x80, 0x3E, 0x7E, 0x01, 0x03
  je loc_121F5                                 ; 121AF  0x74, 0x44
  cmp byte [pin_cword], 0x11                       ; 121B1  0x80, 0x3E, 0x7E, 0x01, 0x11
  jne loc_121BD                                ; 121B6  0x75, 0x05
  call pin_controlP                               ; 121B8  0xE8, 0x17, 0xFD
  jmp short loc_1217B                          ; 121BB  0xEB, 0xBE

loc_121BD:                                     ; 121BD
  cmp byte [pin_cword], 0x10                       ; 121BD  0x80, 0x3E, 0x7E, 0x01, 0x10
  je loc_12219                                 ; 121C2  0x74, 0x55
  les ax, [pin_cur_ccb]                              ; 121C4  0xC4, 0x06, 0x58, 0x01
  push es                                      ; 121C8  0x06
  push ax                                      ; 121C9  0x50
  call pin_reset_conout_flag                               ; 121CA  0xE8, 0x3A, 0xF7
  mov ax, 2                                    ; 121CD  0xB8, 0x02, 0x00
  push ax                                      ; 121D0  0x50
  mov ax, 7                                    ; 121D1  0xB8, 0x07, 0x00
  push ax                                      ; 121D4  0x50
  les bx, [pin_cur_ccb]                              ; 121D5  0xC4, 0x1E, 0x58, 0x01
  mov al, [es:bx + 0xb]                        ; 121D9  0x26, 0x8A, 0x47, 0x0B
  mov ah, 0                                    ; 121DD  0xB4, 0x00
  push ax                                      ; 121DF  0x50
  call pin_pxios1                               ; 121E0  0xE8, 0x1D, 0xF6
  les ax, [pin_cur_ccb]                              ; 121E3  0xC4, 0x06, 0x58, 0x01
  push es                                      ; 121E7  0x06
  push ax                                      ; 121E8  0x50
  call pin_wake_vout                               ; 121E9  0xE8, 0x42, 0xF7
  jmp short loc_1217B                          ; 121EC  0xEB, 0x8D

loc_121EE:                                     ; 121EE
  cmp byte [pin_cword], 3                          ; 121EE  0x80, 0x3E, 0x7E, 0x01, 0x03
  jne loc_121FA                                ; 121F3  0x75, 0x05

loc_121F5:                                     ; 121F5
  call pin_controlO                               ; 121F5  0xE8, 0x3B, 0xFA

loc_121F8:                                     ; 121F8
  jmp short loc_1217B                          ; 121F8  0xEB, 0x81

loc_121FA:                                     ; 121FA
  cmp byte [pin_cword], 0x13                       ; 121FA  0x80, 0x3E, 0x7E, 0x01, 0x13
  jne loc_12206                                ; 121FF  0x75, 0x05
  call pin_controlQ                               ; 12201  0xE8, 0x5F, 0xFC
  jmp short loc_121F8                          ; 12204  0xEB, 0xF2

loc_12206:                                     ; 12206
  cmp byte [pin_cword], 0xf                        ; 12206  0x80, 0x3E, 0x7E, 0x01, 0x0F
  jne loc_12212                                ; 1220B  0x75, 0x05
  call pin_turn_off_ctrlO                               ; 1220D  0xE8, 0xBA, 0xFB
  jmp short loc_121F8                          ; 12210  0xEB, 0xE6

loc_12212:                                     ; 12212
  cmp byte [pin_cword], 0x10                       ; 12212  0x80, 0x3E, 0x7E, 0x01, 0x10
  jne loc_1221E                                ; 12217  0x75, 0x05

loc_12219:                                     ; 12219
  call pin_raw                               ; 12219  0xE8, 0x06, 0xFD
  jmp short loc_121F8                          ; 1221C  0xEB, 0xDA

loc_1221E:                                     ; 1221E
  les bx, [pin_cur_ccb]                              ; 1221E  0xC4, 0x1E, 0x58, 0x01
  mov ax, [es:bx + 0xe]                        ; 12222  0x26, 0x8B, 0x47, 0x0E
  and ax, 0x100                                ; 12226  0x25, 0x00, 0x01
  cmp ax, 0                                    ; 12229  0x83, 0xF8, 0x00
  je loc_12231                                 ; 1222C  0x74, 0x03
  call pin_controlS                               ; 1222E  0xE8, 0xF2, 0xFB

loc_12231:                                     ; 12231
  jmp near loc_1219A                           ; 12231  0xE9, 0x66, 0xFF
  pop bp                                       ; 12234  0x5D
  ret                                          ; 12235  0xC3
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00  ; 12236  ..........
