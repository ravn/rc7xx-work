; ===========================================================================
; RSP 1: TMP759 — Terminal Message Processor (Piccoline CLI / kommandofortolker)
; Offset range: 0x0FD40 - 0x1156F (6.192 bytes)
; ===========================================================================
%include "hardware.inc"

; ===========================================================================
; TMP759 Initialisering og Opstart
;
; WHAT:
;   Opstartsrutine for Piccoline Terminal Message Processor.
;   - Sætter BDOS fejlhåndteringstilstand (BDOS func 45: returner fejl).
;   - Tilknytter fysisk/virtuel konsol og liste-enhed til processen.
;   - Viser boot banner (hvis konfigureret i UDA).
;   - Specialiserer proces- og kønavne med det aktuelle konsolnummer ('0'..'3'):
;       * "STARTUP x  " -> "STARTUP 0  " .. "STARTUP 3  "
;       * "Tmp     p"   -> "Tmp 0   p" (input-/prompt-kø)
;       * "Tmp     d"   -> "Tmp 0   d" (display-/output-kø)
;   - Tjekker Piccoline skærm- og RC-Net tilstand via XIOS INT 28h.
;   - Vælger standard startdrev og brugernummer 0.
; ===========================================================================
rsp_tmp759_start:
  mov cl, 0x2d                                 ; 0FD40  BDOS func 45: Set Error Mode / Priority
  mov dl, 0xff                                 ; 0FD42  DL = 0xFF: Returner fejl til kalder

loc_0FD44:                                     ; 0FD44
  call bdos_call                               ; 0FD44  eksekver BDOS 45
  mov dl, [4]                                  ; 0FD47  hent konsolnummer fra procesheader
  call bdos_attach_console                     ; 0FD4B  BDOS 148: Tilknyt konsol
  call bdos_attach_list                        ; 0FD4E  BDOS 162: Tilknyt printer/liste
  push ds                                      ; 0FD51  0x1E
  mov ds, [0]                                  ; 0FD52  hent UDA segment
  mov dx, [0x78]                               ; 0FD56  boot banner offset
  mov ds, [0x40]                               ; 0FD5A  boot banner segment
  call print_string                            ; 0FD5E  udskriv startbanner
  pop ds                                       ; 0FD61  0x1F
  call bdos_detach_console                     ; 0FD62  BDOS 147: Frigiv konsol
  mov dl, 0                                    ; 0FD65  0xB2, 0x00
  mov cl, 0x6e                                 ; 0FD67  BDOS 110: Set Output Delimiter
  call bdos_call                               ; 0FD69  0xE8, 0xB7, 0x0E
  mov cl, 0x6d                                 ; 0FD6C  BDOS 109: Get/Set Console Mode
  mov dx, 4                                    ; 0FD6E  bit 2: rå konsoltilstand
  call bdos_call                               ; 0FD71  0xE8, 0xAF, 0x0E

  ; Tilpas skabeloner med konsolnummer ('0'..'3')
  mov al, [0x1b]                               ; 0FD74  konsol-id i PD ("Tmp 0" -> '0')
  mov [0x293], al                              ; 0FD77  indsæt i "STARTUP x  " -> "STARTUP 0  "
  mov [0x35d], al                              ; 0FD7A  indsæt i input-kø "Tmp     p"
  mov [0x3eb], al                              ; 0FD7D  indsæt i display-kø "Tmp     d"

  ; Forespørg hardware-konfiguration via XIOS INT 28h
  mov ax, 4                                    ; 0FD80  XIOS func 4: Hent skærmopsætning
  int 0x28                                     ; 0FD83  kald Piccoline BIOS
  cmp byte [es:si + 0xd], 0xff                 ; 0FD85  tjek skærmkonfiguration
  mov ax, 3                                    ; 0FD8A  XIOS func 3: Hent systemstatus
  int 0x28                                     ; 0FD8D  kald Piccoline BIOS
  mov al, [es:si + 0x1e]                       ; 0FD8F  hent netværksattribut
  mov [0x413], al                              ; 0FD93  gem netværkstilstand
  je loc_0FD9D                                 ; 0FD96  0x74, 0x05
  mov byte [0x413], 0xff                       ; 0FD98  marker netværk deaktiveret

loc_0FD9D:                                     ; 0FD9D
  mov al, [es:si + 0x1d]                       ; 0FD9D  0x26, 0x8A, 0x44, 0x1D
  mov [0x41e], al                              ; 0FDA1  0xA2, 0x1E, 0x04
  mov cl, [0x1b]                               ; 0FDA4  0x8A, 0x0E, 0x1B, 0x00
  sub cl, 0x30                                 ; 0FDA8  0x80, 0xE9, 0x30
  mov al, 1                                    ; 0FDAB  0xB0, 0x01
  shl al, cl                                   ; 0FDAD  0xD2, 0xE0
  test [es:si + 0x1f], al                      ; 0FDAF  0x26, 0x84, 0x44, 0x1F
  je loc_0FDED                                 ; 0FDB3  0x74, 0x38
  call rcnet_check_active                               ; 0FDB5  0xE8, 0xA8, 0x07
  jb loc_0FDC2                                 ; 0FDB8  0x72, 0x08
  mov dx, 0x12a4                               ; 0FDBA  0xBA, 0xA4, 0x12
  call print_cs_string                               ; 0FDBD  0xE8, 0xE6, 0x0D
  jmp short loc_0FDED                          ; 0FDC0  0xEB, 0x2B

loc_0FDC2:                                     ; 0FDC2
  call clear_fcb_name_buffer                               ; 0FDC2  0xE8, 0x66, 0x0C
  mov al, [0x413]                              ; 0FDC5  0xA0, 0x13, 0x04
  mov [0x2af], al                              ; 0FDC8  0xA2, 0xAF, 0x02
  mov cx, 5                                    ; 0FDCB  0xB9, 0x05, 0x00

loc_0FDCE:                                     ; 0FDCE
  push cx                                      ; 0FDCE  0x51
  mov cl, 0x40                                 ; 0FDCF  0xB1, 0x40
  mov dx, 0x2af                                ; 0FDD1  0xBA, 0xAF, 0x02
  call bdos_call                               ; 0FDD4  0xE8, 0x4C, 0x0E
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
  call print_cs_string                               ; 0FDEA  0xE8, 0xB9, 0x0D

loc_0FDED:                                     ; 0FDED
  push ds                                      ; 0FDED  0x1E
  mov ds, [0]                                  ; 0FDEE  0x8E, 0x1E, 0x00, 0x00
  mov dl, [0x4b]                               ; 0FDF2  0x8A, 0x16, 0x4B, 0x00
  pop ds                                       ; 0FDF6  0x1F
  call bdos_select_disk                               ; 0FDF7  0xE8, 0xEE, 0x0D
  call print_crlf                               ; 0FDFA  0xE8, 0xA6, 0x0D
  cmp byte [0x412], 0xff                       ; 0FDFD  0x80, 0x3E, 0x12, 0x04, 0xFF
  jne loc_0FE11                                ; 0FE02  0x75, 0x0D
  call bdos_get_disk                               ; 0FE04  0xE8, 0xE6, 0x0D
  call with_selected_disk                               ; 0FE07  0xE8, 0x53, 0x05
  jae loc_0FE11                                ; 0FE0A  0x73, 0x05
  jne loc_0FE11                                ; 0FE0C  0x75, 0x03
  call print_crlf                               ; 0FE0E  0xE8, 0x92, 0x0D

loc_0FE11:                                     ; 0FE11
  db 0x32, 0xD2                                ; 0FE11  xor dl, dl
  call bdos_set_user                               ; 0FE13  0xE8, 0x88, 0x0D
  mov cl, 0x86                                 ; 0FE16  0xB1, 0x86
  mov dx, 0x354                                ; 0FE18  0xBA, 0x54, 0x03
  int 0xe0                                     ; 0FE1B  0xCD, 0xE0
  db 0x0B, 0xC0                                ; 0FE1D  or ax, ax
  je loc_0FE29                                 ; 0FE1F  0x74, 0x08
  mov dx, 0x147c                               ; 0FE21  0xBA, 0x7C, 0x14
  call print_cs_string                               ; 0FE24  0xE8, 0x7F, 0x0D
  jmp short loc_0FE3A                          ; 0FE27  0xEB, 0x11

loc_0FE29:                                     ; 0FE29
  mov cl, 0x87                                 ; 0FE29  0xB1, 0x87
  mov dx, 0x3e0                                ; 0FE2B  0xBA, 0xE0, 0x03
  int 0xe0                                     ; 0FE2E  0xCD, 0xE0
  db 0x0B, 0xC0                                ; 0FE30  or ax, ax
  je loc_0FE3A                                 ; 0FE32  0x74, 0x06
  mov dx, 0x149a                               ; 0FE34  0xBA, 0x9A, 0x14
  call print_cs_string                               ; 0FE37  0xE8, 0x6C, 0x0D

loc_0FE3A:                                     ; 0FE3A
  call load_mem_limit                               ; 0FE3A  0xE8, 0xD9, 0x0D
  mov dx, 0x14a                                ; 0FE3D  0xBA, 0x4A, 0x01
  mov cl, 0x1a                                 ; 0FE40  0xB1, 0x1A
  call bdos_call                               ; 0FE42  0xE8, 0xDE, 0x0D
  mov bx, 0x266                                ; 0FE45  0xBB, 0x66, 0x02
  or byte [bx + 5], 0x80                       ; 0FE48  0x80, 0x4F, 0x05, 0x80
  db 0x8B, 0xD3                                ; 0FE4C  mov dx, bx
  mov cl, 0xf                                  ; 0FE4E  0xB1, 0x0F
  call bdos_call                               ; 0FE50  0xE8, 0xD0, 0x0D
  cmp al, 0xff                                 ; 0FE53  0x3C, 0xFF
  je loc_0FE7F                                 ; 0FE55  0x74, 0x28

loc_0FE57:                                     ; 0FE57
  mov dx, 0x266                                ; 0FE57  0xBA, 0x66, 0x02
  mov cl, 0x14                                 ; 0FE5A  0xB1, 0x14
  call bdos_call                               ; 0FE5C  0xE8, 0xC4, 0x0D
  test al, al                                  ; 0FE5F  0x84, 0xC0
  jne loc_0FE71                                ; 0FE61  0x75, 0x0E
  mov [0x262], ds                              ; 0FE63  0x8C, 0x1E, 0x62, 0x02
  mov dx, PORT_PRN_CTRL                        ; 0FE67  0xBA, 0x60, 0x02
  mov cl, 0x6f                                 ; 0FE6A  0xB1, 0x6F
  call bdos_call                               ; 0FE6C  0xE8, 0xB4, 0x0D
  jmp short loc_0FE57                          ; 0FE6F  0xEB, 0xE6

loc_0FE71:                                     ; 0FE71
  mov dx, 0x15f0                               ; 0FE71  0xBA, 0xF0, 0x15
  call print_raw_mode109                               ; 0FE74  0xE8, 0x40, 0x0D
  mov dx, 0x266                                ; 0FE77  0xBA, 0x66, 0x02
  mov cl, 0x10                                 ; 0FE7A  0xB1, 0x10
  call bdos_call                               ; 0FE7C  0xE8, 0xA4, 0x0D

loc_0FE7F:                                     ; 0FE7F
  call set_raw_console_mode                               ; 0FE7F  0xE8, 0x60, 0x0C
  push bx                                      ; 0FE82  0x53
  mov bx, 0x28a                                ; 0FE83  0xBB, 0x8A, 0x02
  or byte [bx + 5], 0x80                       ; 0FE86  0x80, 0x4F, 0x05, 0x80
  db 0x8B, 0xD3                                ; 0FE8A  mov dx, bx
  pop bx                                       ; 0FE8C  0x5B
  mov cl, 0xf                                  ; 0FE8D  0xB1, 0x0F
  call bdos_call                               ; 0FE8F  0xE8, 0x91, 0x0D
  cmp al, 0xff                                 ; 0FE92  0x3C, 0xFF
  je loc_0FED9                                 ; 0FE94  0x74, 0x43
  mov dx, PORT_DPC_PRN_DATA                    ; 0FE96  0xBA, 0x8A, 0x02
  mov cl, 0x14                                 ; 0FE99  0xB1, 0x14
  call bdos_call                               ; 0FE9B  0xE8, 0x85, 0x0D
  push ax                                      ; 0FE9E  0x50
  mov dx, PORT_DPC_PRN_DATA                    ; 0FE9F  0xBA, 0x8A, 0x02
  mov cl, 0x10                                 ; 0FEA2  0xB1, 0x10
  call bdos_call                               ; 0FEA4  0xE8, 0x7C, 0x0D
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
  call print_cs_string                               ; 0FED0  0xE8, 0xD3, 0x0C
  mov dx, 0x14a                                ; 0FED3  0xBA, 0x4A, 0x01
  call print_string                               ; 0FED6  0xE8, 0xD7, 0x0C

loc_0FED9:                                     ; 0FED9
  call bdos_attach_list                               ; 0FED9  0xE8, 0x1D, 0x0D

loc_0FEDC:                                     ; 0FEDC
  mov dx, 0x15e7                               ; 0FEDC  0xBA, 0xE7, 0x15
  call print_raw_mode109                               ; 0FEDF  0xE8, 0xD5, 0x0C
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
  call read_cmd_input                               ; 0FF0E  0xE8, 0x15, 0x0D
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
  call print_crlf                               ; 0FF4A  0xE8, 0x56, 0x0C

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
  call print_prompt                               ; 0FFC7  0xE8, 0x9D, 0x0D
  mov dx, 0x1d6                                ; 0FFCA  0xBA, 0xD6, 0x01
  call print_string                               ; 0FFCD  0xE8, 0xE0, 0x0B
  call print_crlf                               ; 0FFD0  0xE8, 0xD0, 0x0B

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
  call bdos_select_disk_checked                               ; 0FFF3  0xE8, 0xEC, 0x0B
  jae loc_1000C                                ; 0FFF6  0x73, 0x14
  cmp byte [0x412], 0xff                       ; 0FFF8  0x80, 0x3E, 0x12, 0x04, 0xFF
  jne loc_1000C                                ; 0FFFD  0x75, 0x0D
  call bdos_get_disk                               ; 0FFFF  0xE8, 0xEB, 0x0B
  call with_selected_disk                               ; 10002  0xE8, 0x58, 0x03
  jae loc_1000C                                ; 10005  0x73, 0x05
  jne loc_1000C                                ; 10007  0x75, 0x03
  call print_crlf                               ; 10009  0xE8, 0x97, 0x0B

loc_1000C:                                     ; 1000C
  jmp near loc_1001E                           ; 1000C  0xE9, 0x0F, 0x00

loc_1000F:                                     ; 1000F
  mov dx, 0x10b0                               ; 1000F  0xBA, 0xB0, 0x10
  call print_cs_string                               ; 10012  0xE8, 0x91, 0x0B
  mov dx, 0x118c                               ; 10015  0xBA, 0x8C, 0x11
  call print_cs_string                               ; 10018  0xE8, 0x8B, 0x0B
  call print_crlf                               ; 1001B  0xE8, 0x85, 0x0B

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
  call bdos_parse_filename                               ; 10034  0xE8, 0xBF, 0x0A
  mov [0x25a], ax                              ; 10037  0xA3, 0x5A, 0x02
  jcxz loc_1003F                               ; 1003A  0xE3, 0x03
  jmp near loc_1010C                           ; 1003C  0xE9, 0xCD, 0x00

; ===========================================================================
; Kommandotolkning og Opslag i Dispatch-Tabel
;
; WHAT:
;   Gennemsøger listen over indbyggede kommandoer (cmd_names_list) med
;   det indtastede kommandoord (8 tegn i DS:[0x02B0]).
;   - Ved match: Springer til den tilhørende rutine via cmd_dispatch_table.
;   - Ved ukendt kommando: Kalder BDOS funktion 150 (P_CLI) for at indlæse
;     og eksekvere en ekstern .CMD-fil fra disken.
;
; WHY:
;   Giver øjeblikkelig responstid for residente basiskommandoer (DIR, USER osv.)
;   samtidig med fuld transparens for eksterne programmer via CCP/M CLI.
;
; WORKED EXAMPLE:
;   Bruger indtaster: "DIR"
;   1. DS:[0x02B0..0x02B7] indeholder "DIR     ".
;   2. Løkken ved loc_10052 sammenligner med cmd_names_list:
;      - Indeks 0 ("?       "): ulighed.
;      - Indeks 1 ("ABORT   "): ulighed.
;      - ...
;      - Indeks 5 ("DIR     "): repe cmpsw matcher alle 4 ord!
;   3. AX = 5, shl ax, 1 -> BX = 10 (offset i dispatch-tabel).
;   4. jmp word [cs:bx + cmd_dispatch_table] -> springer direkte til cmd_dir!
; ===========================================================================
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

bdos_p_cli:                                     ; 1007A
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
  call save_mem_limit                               ; 10099  0xE8, 0x6D, 0x0B
  mov cl, 0x6d                                 ; 1009C  0xB1, 0x6D
  db 0x33, 0xD2                                ; 1009E  xor dx, dx
  call bdos_call                               ; 100A0  0xE8, 0x80, 0x0B
  call bdos_p_cli                               ; 100A3  0xE8, 0xD4, 0xFF
  cmp cx, 0x26                                 ; 100A6  0x83, 0xF9, 0x26
  jne loc_100FE                                ; 100A9  0x75, 0x53
  mov dx, 0x1406                               ; 100AB  0xBA, 0x06, 0x14
  call print_cs_string                               ; 100AE  0xE8, 0xF5, 0x0A
  call print_dir_stopped_by_user                               ; 100B1  0xE8, 0xE4, 0x0C
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
  call print_crlf                               ; 100F8  0xE8, 0xA8, 0x0A
  call bdos_p_cli                               ; 100FB  0xE8, 0x7C, 0xFF

loc_100FE:                                     ; 100FE
  push cx                                      ; 100FE  0x51
  push bx                                      ; 100FF  0x53
  push ax                                      ; 10100  0x50
  call set_raw_console_mode                               ; 10101  0xE8, 0xDE, 0x09
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
  call print_cs_string                               ; 10137  0xE8, 0x6C, 0x0A
  pop dx                                       ; 1013A  0x5A
  call print_cs_string                               ; 1013B  0xE8, 0x68, 0x0A
  mov dx, 0x1416                               ; 1013E  0xBA, 0x16, 0x14
  call print_cs_string                               ; 10141  0xE8, 0x62, 0x0A
  mov dx, 0x2d2                                ; 10144  0xBA, 0xD2, 0x02
  call print_string                               ; 10147  0xE8, 0x66, 0x0A
  call print_crlf                               ; 1014A  0xE8, 0x56, 0x0A

loc_1014D:                                     ; 1014D
  jmp near loc_0FED9                           ; 1014D  0xE9, 0x89, 0xFD

; ===========================================================================
; Kommando: USER / BRUGER [nr]
;
; WHAT:
;   Viser det aktuelle CCP/M-86 brugernummer hvis ingen parameter gives,
;   eller skifter til et nyt brugernummer (0..15) via BDOS funktion 32.
;
; WHY:
;   CCP/M-86 adskiller filer i filkataloget per brugernummer (0..15).
;   Piccoline understøtter både engelsk ("USER") og dansk ("BRUGER") syntaks.
;
; WORKED EXAMPLE:
;   Bruger indtaster: "BRUGER 3"
;   1. bdos_parse_filename parser parameter -> token fundet.
;   2. parse_decimal_2digit konverterer "3" -> BL = 0x03.
;   3. Guard: BL (3) <= 0x0F -> gyldigt brugernummer.
;   4. bdos_set_user: DL = 3, CL = 0x20 -> INT 0E0h sætter brugernummer til 3.
;   5. bdos_con_out / print_crlf viser bekræftelse: "Bruger nummer er 3\r\n".
; ===========================================================================
cmd_user:
  mov si, 0x2af                                ; 10150  0xBE, 0xAF, 0x02
  mov di, [0x25a]                              ; 10153  0x8B, 0x3E, 0x5A, 0x02
  cmp di, 0                                    ; 10157  0x83, 0xFF, 0x00
  je loc_10188                                 ; 1015A  ingen parameter: vis blot aktuelt nummer
  inc di                                       ; 1015C  0x47
  call bdos_parse_filename                     ; 1015D  parse parameter
  cmp cx, 0                                    ; 10160  0x83, 0xF9, 0x00
  jne loc_10188                                ; 10163  fejl i syntaks -> spring til visning
  mov si, 0x2af                                ; 10165  0xBE, 0xAF, 0x02
  inc si                                       ; 10168  0x46
  mov dx, [si]                                 ; 10169  0x8B, 0x14
  call parse_decimal_2digit                    ; 1016B  konverter 2 cifre decimalt
  cmp bl, 0xf                                  ; 1016E  0x80, 0xFB, 0x0F
  ja loc_1017B                                 ; 10171  hvis > 15 -> ulovligt brugernummer
  db 0x8A, 0xD3                                ; 10173  mov dl, bl
  call bdos_set_user                           ; 10175  sæt nyt brugernummer via BDOS 32
  jmp near loc_10188                           ; 10178  vis bekræftelse

loc_1017B:                                     ; 1017B: Fejl ved brugernummer
  cmp byte [0x1d2], 1                          ; 1017B  tjek menu/batch tilstand
  je loc_1019B                                 ; 10180  undertryk fejl hvis batch
  mov dx, 0x1424                               ; 10182  "Ulovligt bruger nummer\r\n"
  call print_cs_string                         ; 10185  udskriv fejlbesked

loc_10188:                                     ; 10188: Vis aktuelt brugernummer
  cmp byte [0x1d2], 1                          ; 10188  tjek menu/batch tilstand
  je loc_1019B                                 ; 1018D  0x74, 0x0C
  mov dx, 0x143d                               ; 1018F  "Bruger nummer er "
  call print_cs_string                         ; 10192  udskriv ledetekst
  call print_user_number                       ; 10195  udskriv ciffer
  call print_crlf                              ; 10198  udskriv ny linje

loc_1019B:                                     ; 1019B
  jmp near loc_0FED9                           ; 1019B  retur til kommandoløkke

; ---------------------------------------------------------------------------
; Hjælperutine: Udskriver det aktuelle brugernummer
; ---------------------------------------------------------------------------
print_user_number:
  call bdos_get_user                           ; 1019E  hent brugernummer fra BDOS (BL)
  db 0x8A, 0xD3                                ; 101A1  mov dl, bl
  jmp near print_decimal_byte                  ; 101A3  udskriv som 1-2 cifre

; ===========================================================================
; Kommando: PRINTER / SKRIVER [nr]
;
; WHAT:
;   Tildeler eller forespørger den aktive printer/liste-enhed for den
;   aktuelle virtuelle konsol.
;
; WHY:
;   Piccoline understøtter flere printere (Centronics parallel på port 0x0C
;   og serielle porte). BDOS funktion 160 (0xA0) tildeler printer, og
;   BDOS funktion 164 (0xA4) returnerer aktuelt printernummer.
;
; WORKED EXAMPLE:
;   Bruger indtaster: "SKRIVER 1"
;   1. Token "1" parses -> BL = 1.
;   2. Guard: BL != 0xFF -> gyldigt enhedsnummer.
;   3. bdos_set_list: DL = 1, CL = 0xA0 -> INT 0E0h sætter printer 1.
;   4. Viser bekræftelse: "Skriver nummer er 1\r\n".
; ===========================================================================
cmd_printer:
  mov si, 0x2af                                ; 101A6  0xBE, 0xAF, 0x02
  mov di, [0x25a]                              ; 101A9  0x8B, 0x3E, 0x5A, 0x02
  cmp di, 0                                    ; 101AD  0x83, 0xFF, 0x00
  je loc_101DD                                 ; 101B0  ingen parameter: vis blot aktuel
  inc di                                       ; 101B2  0x47
  call bdos_parse_filename                     ; 101B3  parse parameter
  cmp cx, 0                                    ; 101B6  0x83, 0xF9, 0x00
  jne loc_101DD                                ; 101B9  fejl i syntaks -> vis aktuel
  mov si, 0x2af                                ; 101BB  0xBE, 0xAF, 0x02
  inc si                                       ; 101BE  0x46
  mov dx, [si]                                 ; 101BF  0x8B, 0x14
  call parse_decimal_2digit                    ; 101C1  konverter enhedsnummer
  cmp bl, 0xff                                 ; 101C4  0x80, 0xFB, 0xFF
  je loc_101D0                                 ; 101C7  ugyldigt ciffer -> fejl
  db 0x8A, 0xD3                                ; 101C9  mov dl, bl
  call bdos_set_list                           ; 101CB  tildel printernummer via BDOS 160
  jcxz loc_101DD                               ; 101CE  hvis succes -> vis aktuel

loc_101D0:                                     ; 101D0: Fejl ved printernummer
  cmp byte [0x1d2], 1                          ; 101D0  tjek menu/batch tilstand
  je loc_101F5                                 ; 101D5  0x74, 0x1E
  mov dx, 0x144f                               ; 101D7  "Ulovligt skriver nummer\r\n"
  call print_cs_string                         ; 101DA  udskriv fejlbesked

loc_101DD:                                     ; 101DD: Vis aktuel printer
  cmp byte [0x1d2], 1                          ; 101DD  tjek menu/batch tilstand
  je loc_101F5                                 ; 101E2  0x74, 0x11
  mov dx, 0x1469                               ; 101E4  "Skriver nummer er "
  call print_cs_string                         ; 101E7  udskriv ledetekst
  call bdos_get_list                           ; 101EA  hent aktivt nummer via BDOS 164
  db 0x8A, 0xD3                                ; 101ED  mov dl, bl
  call print_decimal_byte                      ; 101EF  udskriv ciffer
  call print_crlf                              ; 101F2  udskriv ny linje

loc_101F5:                                     ; 101F5
  jmp near loc_0FED9                           ; 101F5  retur til kommandoløkke

; ===========================================================================
; Kommando: SIZE [kb]
;
; WHAT:
;   Indstiller eller viser den maksimale tilladte hukommelsesstørrelse for
;   eksekverbare programmer (16..768 KB) i 16-byte paragraffer.
;
; WHY:
;   Piccoline kan have op til 768 KB RAM. For at forhindre at et program
;   allokerer alt frit lager og sulter andre processer i CCP/M multitasking,
;   kan brugeren sætte en øvre grænse via SIZE.
;
; WORKED EXAMPLE:
;   Bruger indtaster: "SIZE 128"
;   1. parse_ascii_uint konverterer "128" -> AX = 0x0080 (128 decimal).
;   2. Guard: 0x0010 <= AX <= 0x0300 (16 <= AX <= 768) -> OK.
;   3. shl ax, 6: 128 KB * 64 paragraffer/KB = 8.192 paragraffer (0x2000).
;   4. save_mem_limit gemmer 0x2000 i DS:[0x0410] og UDA:[0x004C].
;   5. Viser: "Size =  128 K bytes\r\n".
; ===========================================================================
cmd_size:
  mov si, 0x2af                                ; 101F8  0xBE, 0xAF, 0x02
  mov di, [0x25a]                              ; 101FB  0x8B, 0x3E, 0x5A, 0x02
  cmp di, 0                                    ; 101FF  0x83, 0xFF, 0x00
  je loc_10235                                 ; 10202  ingen parameter: vis blot aktuel
  inc di                                       ; 10204  0x47
  call bdos_parse_filename                     ; 10205  parse parameter
  cmp cx, 0                                    ; 10208  0x83, 0xF9, 0x00
  jne loc_10235                                ; 1020B  fejl -> vis aktuel
  mov si, 0x2af                                ; 1020D  0xBE, 0xAF, 0x02
  inc si                                       ; 10210  0x46
  call parse_ascii_uint                        ; 10211  konverter ASCII heltal til AX
  cmp ax, 0x300                                ; 10214  maks 768 KB
  ja loc_10228                                 ; 10217  hvis over 768 KB -> ulovlig
  cmp ax, strict word 0x10                     ; 10219  min 16 KB
  jb loc_10228                                 ; 1021C  hvis under 16 KB -> ulovlig
  mov cl, 6                                    ; 1021E  6 bit venstreskift (gange med 64)
  shl ax, cl                                   ; 10220  konverter KB til 16-byte paragraffer
  call save_mem_limit                          ; 10222  gem grænse i procesvariabler
  jmp near loc_10235                           ; 10225  vis bekræftelse

loc_10228:                                     ; 10228: Fejl ved hukommelsesgrænse
  cmp byte [0x1d2], 1                          ; 10228  tjek menu/batch tilstand
  je loc_1024F                                 ; 1022D  0x74, 0x20
  mov dx, 0x14b5                               ; 1022F  "Ulovlig lagergrænse, (16-768 K)\r\n"
  call print_cs_string                         ; 10232  udskriv fejlbesked

loc_10235:                                     ; 10235: Vis aktuel hukommelsesgrænse
  cmp byte [0x1d2], 1                          ; 10235  tjek menu/batch tilstand
  je loc_1024F                                 ; 1023A  0x74, 0x13
  mov ax, [0x410]                              ; 1023C  hent grænse i paragraffer
  mov cl, 6                                    ; 1023F  6 bit højreskift (divider med 64)
  shr ax, cl                                   ; 10241  konverter paragraffer til KB
  mov di, 0x402                                ; 10243  buffer i "Size =     K bytes"
  call format_uint_to_ascii                    ; 10246  formater som decimaltal
  mov dx, 0x3fb                                ; 10249  streng "Size = ..."
  call print_string                            ; 1024C  udskriv resultat

loc_1024F:                                     ; 1024F
  jmp near loc_0FED9                           ; 1024F  retur til kommandoløkke

; ===========================================================================
; Kommando: DIR [filespec]
;
; WHAT:
;   Viser filkatalog for det aktuelle eller angivne drev/brugernummer
;   i 4 kolonner. Filtrerer systemfiler fra medmindre eksplicit anmodet.
;
; WHY:
;   Erstatter DRI's primitive DIR med en formateret, pausesikret katalog-
;   visning med dansk brugernummer- og attributangivelse.
;
; WORKED EXAMPLE:
;   Bruger indtaster: "DIR B:*.CMD"
;   1. bdos_parse_filename klargør FCB med drev B: og maske "???????.CMD".
;   2. bdos_select_disk vælger drev B:.
;   3. Søgeløkke kalder BDOS 17 (Search First) og BDOS 18 (Search Next).
;   4. Filtrering: Guard tjekker bit 7 i filtypen (SYS attribut).
;   5. Formaterer 4 poster per linje med filnavn, punktum og type.
;   6. Bruger kan afbryde med tastaturtryk (viser "DIR Stoppet af brugeren").
; ===========================================================================
cmd_dir:
  call bdos_get_user                           ; 10252  hent aktuelt brugernummer
  mov [0x1cf], al                              ; 10255  gem brugernummer
  mov byte [0x1ce], 0                          ; 10258  nulstil attributfilter
  mov byte [0x1cd], 0xff                       ; 1025D  init kolonne-tæller
  mov si, 0x2af                                ; 10262  arbejds-FCB
  mov di, [0x25a]                              ; 10265  kommandolinjepointer
  cmp di, 0                                    ; 10269  tjek om parameter er givet
  je loc_1028D                                 ; 1026C  hvis tom -> standard maske *.*
  call dir_parse_options                               ; 1026E  tjek drevangivelse
  cmp byte [di], 0                             ; 10271  slut på linje?
  je loc_1028D                                 ; 10274  hvis ja -> standard maske
  call bdos_parse_filename                     ; 10276  parse filspecifikation til FCB
  mov [0x25a], ax                              ; 10279  gem opdateret pointer
  cmp ax, strict word 0                        ; 1027C  fejl i parsing?
  jns loc_10284                                ; 1027F  hvis >= 0 -> succes
  jmp near loc_10350                           ; 10281  syntaksfejl

loc_10284:                                     ; 10284
  je loc_102A7                                 ; 10284  hvis slut på linje -> start søgning
  db 0x8B, 0xF8                                ; 10286  mov di, ax
  call dir_parse_single_option                               ; 10288  parse eventuelle ekstra switches
  jmp short loc_102A7                          ; 1028B  0xEB, 0x1A

loc_1028D:                                     ; 1028D: Udfyld FCB med standardmaske (? ? ?)
  mov ax, ds                                   ; 1028D  0x8C, 0xD8
  mov es, ax                                   ; 1028F  0x8E, 0xC0
  mov byte [0x2af], 0                          ; 10291  standard drev (0 = aktuelt)

loc_10296:                                     ; 10296
  mov di, 0x2b0                                ; 10296  FCB filnavn
  mov cx, 0xb                                  ; 10299  11 tegn (8 navn + 3 type)
  mov al, 0x3f                                 ; 1029C  '?' masketegn
  rep stosb                                    ; 1029E  fyld med '?'
  mov cx, 0x15                                 ; 102A0  21 bytes
  db 0x32, 0xC0                                ; 102A3  xor al, al
  rep stosb                                    ; 102A5  nulstil resten af FCB

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
  call bdos_get_disk                               ; 102BE  0xE8, 0x2C, 0x09

loc_102C1:                                     ; 102C1
  inc al                                       ; 102C1  0xFE, 0xC0
  mov [0x2af], al                              ; 102C3  0xA2, 0xAF, 0x02
  mov dx, 0x1d6                                ; 102C6  0xBA, 0xD6, 0x01
  mov cl, 0x1a                                 ; 102C9  0xB1, 0x1A
  call bdos_call                               ; 102CB  0xE8, 0x55, 0x09
  mov dx, 0x2af                                ; 102CE  0xBA, 0xAF, 0x02
  mov cl, 0x11                                 ; 102D1  0xB1, 0x11
  call bdos_call                               ; 102D3  0xE8, 0x4D, 0x09
  db 0x0A, 0xC0                                ; 102D6  or al, al
  jns loc_102E5                                ; 102D8  0x79, 0x0B
  call rcnet_check_error                               ; 102DA  0xE8, 0xC2, 0x0A
  jae loc_10339                                ; 102DD  0x73, 0x5A
  mov dx, 0x1504                               ; 102DF  0xBA, 0x04, 0x15
  jmp near loc_10358                           ; 102E2  0xE9, 0x73, 0x00

loc_102E5:                                     ; 102E5
  mov dx, 0x1512                               ; 102E5  0xBA, 0x12, 0x15
  call print_cs_string                               ; 102E8  0xE8, 0xBB, 0x08
  mov al, [0x2af]                              ; 102EB  0xA0, 0xAF, 0x02
  dec al                                       ; 102EE  0xFE, 0xC8
  call with_selected_disk                               ; 102F0  0xE8, 0x6A, 0x00
  jae loc_10339                                ; 102F3  0x73, 0x44
  jne loc_102FC                                ; 102F5  0x75, 0x05
  mov dl, 0x20                                 ; 102F7  0xB2, 0x20
  call bdos_con_out                               ; 102F9  0xE8, 0x9B, 0x08

loc_102FC:                                     ; 102FC
  mov dx, 0x151f                               ; 102FC  0xBA, 0x1F, 0x15
  call print_cs_string                               ; 102FF  0xE8, 0xA4, 0x08
  call print_user_number                               ; 10302  0xE8, 0x99, 0xFE
  mov cl, 0x11                                 ; 10305  0xB1, 0x11
  jmp short loc_10317                          ; 10307  0xEB, 0x0E

loc_10309:                                     ; 10309
  call dir_print_entry                               ; 10309  0xE8, 0xC1, 0x00
  mov cl, 0xb                                  ; 1030C  0xB1, 0x0B
  call bdos_call                               ; 1030E  0xE8, 0x12, 0x09
  db 0x0A, 0xC0                                ; 10311  or al, al
  jne loc_10343                                ; 10313  0x75, 0x2E
  mov cl, 0x12                                 ; 10315  0xB1, 0x12

loc_10317:                                     ; 10317
  mov dx, 0x2af                                ; 10317  0xBA, 0xAF, 0x02
  call bdos_call                               ; 1031A  0xE8, 0x06, 0x09
  db 0x0A, 0xC0                                ; 1031D  or al, al
  jns loc_10309                                ; 1031F  0x79, 0xE8
  call rcnet_check_error                               ; 10321  0xE8, 0x7B, 0x0A
  jae loc_10339                                ; 10324  0x73, 0x13
  cmp byte [0x1ce], 0x80                       ; 10326  0x80, 0x3E, 0xCE, 0x01, 0x80
  jne loc_10336                                ; 1032B  0x75, 0x09
  call print_crlf                               ; 1032D  0xE8, 0x73, 0x08
  mov dx, 0x152b                               ; 10330  0xBA, 0x2B, 0x15
  call print_cs_string                               ; 10333  0xE8, 0x70, 0x08

loc_10336:                                     ; 10336
  call print_crlf                               ; 10336  0xE8, 0x6A, 0x08

loc_10339:                                     ; 10339
  mov dl, [0x1cf]                              ; 10339  0x8A, 0x16, 0xCF, 0x01
  call bdos_set_user                               ; 1033D  0xE8, 0x5E, 0x08
  jmp near loc_0FED9                           ; 10340  0xE9, 0x96, 0xFB

loc_10343:                                     ; 10343
  mov cl, 1                                    ; 10343  0xB1, 0x01
  call bdos_call                               ; 10345  0xE8, 0xDB, 0x08
  mov dx, 0x153f                               ; 10348  0xBA, 0x3F, 0x15
  call print_cs_string                               ; 1034B  0xE8, 0x58, 0x08
  jmp short loc_10336                          ; 1034E  0xEB, 0xE6

loc_10350:                                     ; 10350
  mov dx, 0x11e7                               ; 10350  0xBA, 0xE7, 0x11
  jmp short loc_10358                          ; 10353  0xEB, 0x03
  mov dx, 0x118c                               ; 10355  0xBA, 0x8C, 0x11

loc_10358:                                     ; 10358
  call print_cs_string                               ; 10358  0xE8, 0x4B, 0x08
  jmp short loc_10336                          ; 1035B  0xEB, 0xD9

with_selected_disk:                                     ; 1035D
  push ax                                      ; 1035D  0x50
  call bdos_get_disk                               ; 1035E  0xE8, 0x8C, 0x08
  pop dx                                       ; 10361  0x5A
  push ax                                      ; 10362  0x50
  call bdos_select_disk_checked                               ; 10363  0xE8, 0x7C, 0x08
  jae loc_103A9                                ; 10366  0x73, 0x41
  mov dx, 0x1d6                                ; 10368  0xBA, 0xD6, 0x01
  mov cl, 0x1a                                 ; 1036B  0xB1, 0x1A
  int 0xe0                                     ; 1036D  0xCD, 0xE0
  mov byte [0x2ae], 0x3f                       ; 1036F  0xC6, 0x06, 0xAE, 0x02, 0x3F
  mov cl, 0x11                                 ; 10374  0xB1, 0x11

loc_10376:                                     ; 10376
  mov dx, 0x2ae                                ; 10376  0xBA, 0xAE, 0x02
  int 0xe0                                     ; 10379  0xCD, 0xE0
  call rcnet_check_error                               ; 1037B  0xE8, 0x21, 0x0A
  jae loc_103A9                                ; 1037E  0x73, 0x29
  call dir_is_entry_valid                               ; 10380  0xE8, 0x2D, 0x00
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
  call print_string_si_len_cx                               ; 1039D  0xE8, 0xF1, 0x00
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
  call bdos_select_disk                               ; 103AB  0xE8, 0x3A, 0x08
  popf                                         ; 103AE  0x9D
  ret                                          ; 103AF  0xC3

dir_is_entry_valid:                                     ; 103B0
  cmp al, 0xff                                 ; 103B0  0x3C, 0xFF
  stc                                          ; 103B2  0xF9
  je loc_103BC                                 ; 103B3  0x74, 0x07
  call dir_get_entry_0                               ; 103B5  0xE8, 0x05, 0x00
  cmp byte [di], 0x20                          ; 103B8  0x80, 0x3D, 0x20
  clc                                          ; 103BB  0xF8

loc_103BC:                                     ; 103BC
  ret                                          ; 103BC  0xC3

dir_get_entry_0:                                     ; 103BD
  mov di, 0x1d6                                ; 103BD  0xBF, 0xD6, 0x01
  jmp short loc_103C5                          ; 103C0  0xEB, 0x03

dir_get_entry_di:                                     ; 103C2
  mov di, 0x1d6                                ; 103C2  0xBF, 0xD6, 0x01

loc_103C5:                                     ; 103C5
  db 0x98                                      ; 103C5  cwde
  mov cl, 5                                    ; 103C6  0xB1, 0x05
  shl ax, cl                                   ; 103C8  0xD3, 0xE0
  db 0x03, 0xF8                                ; 103CA  add di, ax
  ret                                          ; 103CC  0xC3

dir_print_entry:                                     ; 103CD
  call dir_get_entry_di                               ; 103CD  0xE8, 0xF2, 0xFF
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
  call dir_print_drive_user_header                               ; 103EB  0xE8, 0x1F, 0x00

loc_103EE:                                     ; 103EE
  mov dx, 0x14ee                               ; 103EE  0xBA, 0xEE, 0x14
  call print_cs_string                               ; 103F1  0xE8, 0xB2, 0x07
  pop si                                       ; 103F4  0x5E
  inc byte [0x1cd]                             ; 103F5  0xFE, 0x06, 0xCD, 0x01
  inc si                                       ; 103F9  0x46
  mov cx, 8                                    ; 103FA  0xB9, 0x08, 0x00
  call print_string_si_len_cx                               ; 103FD  0xE8, 0x91, 0x00
  push si                                      ; 10400  0x56
  mov al, 0x2e                                 ; 10401  0xB0, 0x2E
  call print_char_al                               ; 10403  0xE8, 0x98, 0x00
  pop si                                       ; 10406  0x5E
  mov cx, 3                                    ; 10407  0xB9, 0x03, 0x00
  jmp near print_string_si_len_cx                           ; 1040A  0xE9, 0x84, 0x00

dir_print_drive_user_header:                                     ; 1040D
  mov byte [0x1cd], 0                          ; 1040D  0xC6, 0x06, 0xCD, 0x01, 0x00
  call print_crlf                               ; 10412  0xE8, 0x8E, 0x07
  call bdos_get_user                               ; 10415  0xE8, 0x84, 0x07
  test bl, bl                                  ; 10418  0x84, 0xDB
  je loc_10421                                 ; 1041A  0x74, 0x05
  db 0x8A, 0xD3                                ; 1041C  mov dl, bl
  call print_decimal_byte                               ; 1041E  0xE8, 0x64, 0x07

loc_10421:                                     ; 10421
  mov bl, [0x2af]                              ; 10421  0x8A, 0x1E, 0xAF, 0x02
  dec bl                                       ; 10425  0xFE, 0xCB
  jns loc_1042C                                ; 10427  0x79, 0x03
  call bdos_get_disk                               ; 10429  0xE8, 0xC1, 0x07

loc_1042C:                                     ; 1042C
  mov dl, 0x41                                 ; 1042C  0xB2, 0x41
  db 0x02, 0xD3                                ; 1042E  add dl, bl
  call bdos_con_out                               ; 10430  0xE8, 0x64, 0x07
  mov dl, 0x3a                                 ; 10433  0xB2, 0x3A
  jmp near bdos_con_out                           ; 10435  0xE9, 0x5F, 0x07

loc_10438:                                     ; 10438
  mov dx, 0x14f2                               ; 10438  0xBA, 0xF2, 0x14
  jmp near loc_10358                           ; 1043B  0xE9, 0x1A, 0xFF

dir_parse_options:                                     ; 1043E
  call skip_spaces                               ; 1043E  0xE8, 0xAA, 0x06
  cmp byte [di], 0x5b                          ; 10441  0x80, 0x3D, 0x5B
  jne loc_10458                                ; 10444  0x75, 0x12

dir_parse_single_option:                                     ; 10446
  inc di                                       ; 10446  0x47
  call skip_spaces                               ; 10447  0xE8, 0xA1, 0x06
  mov al, [di]                                 ; 1044A  0x8A, 0x05
  cmp al, 0                                    ; 1044C  0x3C, 0x00
  je loc_10458                                 ; 1044E  0x74, 0x08
  cmp al, 0x5d                                 ; 10450  0x3C, 0x5D
  jne loc_10459                                ; 10452  0x75, 0x05
  inc di                                       ; 10454  0x47
  call skip_spaces                               ; 10455  0xE8, 0x93, 0x06

loc_10458:                                     ; 10458
  ret                                          ; 10458  0xC3

loc_10459:                                     ; 10459
  and al, 0x5f                                 ; 10459  0x24, 0x5F
  cmp al, 0x53                                 ; 1045B  0x3C, 0x53
  jne loc_10466                                ; 1045D  0x75, 0x07
  or byte [0x1ce], 1                           ; 1045F  0x80, 0x0E, 0xCE, 0x01, 0x01
  jmp short dir_parse_single_option                          ; 10464  0xEB, 0xE0

loc_10466:                                     ; 10466
  cmp al, 0x47                                 ; 10466  0x3C, 0x47
  jne loc_10438                                ; 10468  0x75, 0xCE
  inc di                                       ; 1046A  0x47
  call skip_spaces                               ; 1046B  0xE8, 0x7D, 0x06
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
  call parse_decimal_2digit                               ; 10480  0xE8, 0x83, 0x06
  cmp bl, 0xff                                 ; 10483  0x80, 0xFB, 0xFF
  je loc_10438                                 ; 10486  0x74, 0xB0
  db 0x8A, 0xD3                                ; 10488  mov dl, bl
  push di                                      ; 1048A  0x57
  call bdos_set_user                               ; 1048B  0xE8, 0x10, 0x07
  pop di                                       ; 1048E  0x5F
  jmp short dir_parse_single_option                          ; 1048F  0xEB, 0xB5

print_string_si_len_cx:                                     ; 10491
  lodsb                                        ; 10491  0xAC
  push si                                      ; 10492  0x56
  push cx                                      ; 10493  0x51
  and al, 0x7f                                 ; 10494  0x24, 0x7F
  call print_char_al                               ; 10496  0xE8, 0x05, 0x00
  pop cx                                       ; 10499  0x59
  pop si                                       ; 1049A  0x5E
  loop print_string_si_len_cx                               ; 1049B  0xE2, 0xF4
  ret                                          ; 1049D  0xC3

print_char_al:                                     ; 1049E
  db 0x8A, 0xD0                                ; 1049E  mov dl, al
  jmp near bdos_con_out                           ; 104A0  0xE9, 0xF4, 0x06

; ===========================================================================
; Kommando: ABORT [proces / konsol]
;
; WHAT:
;   Afbryder en kørende proces eller rydder en virtuel konsol via CCP/M-86
;   BDOS funktion 151 (0x97: P_ABORT).
;
; WHY:
;   I et multitasking-system skal brugeren kunne terminere frosne baggrunds-
;   processer uden at genstarte hele maskinen.
;
; WORKED EXAMPLE:
;   Bruger indtaster: "ABORT TEST"
;   1. Parser procesnavn "TEST" (polstret med mellemrum til 8 tegn).
;   2. Kalder BDOS 151 med DX pegende på procesnavnet.
;   3. Hvis fundet og termineret: viser "Aborteret\r\n".
;   4. Hvis proces ikke findes eller kan afbrydes: viser "Abort fejlet\r\n".
; ===========================================================================
cmd_abort:
  mov ax, ds                                   ; 104A3  0x8C, 0xD8
  mov es, ax                                   ; 104A5  0x8E, 0xC0
  mov si, 0x2af                                ; 104A7  0xBE, 0xAF, 0x02
  mov di, [0x25a]                              ; 104AA  0x8B, 0x3E, 0x5A, 0x02
  cmp di, 0                                    ; 104AE  0x83, 0xFF, 0x00
  je loc_104E9                                 ; 104B1  hvis ingen proces angivet -> tjek konsol
  call bdos_parse_filename                     ; 104B3  parse procesnavn til FCB
  mov [0x25a], ax                              ; 104B6  gem opdateret pointer
  cmp ax, strict word 0                        ; 104B9  fejl i parsing?
  js loc_104EC                                 ; 104BC  0x78, 0x2E
  je loc_104E4                                 ; 104BE  0x74, 0x24
  db 0x8B, 0xF8                                ; 104C0  mov di, ax
  call skip_spaces                               ; 104C2  0xE8, 0x26, 0x06
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
  call skip_spaces                               ; 104F3  0xE8, 0xF5, 0x05
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
  call bdos_call                               ; 10530  0xE8, 0xF0, 0x06
  jcxz loc_1053E                               ; 10533  0xE3, 0x09

loc_10535:                                     ; 10535
  mov dx, 0x1559                               ; 10535  0xBA, 0x59, 0x15
  call print_cs_string                               ; 10538  0xE8, 0x6B, 0x06
  jmp near loc_0FED9                           ; 1053B  0xE9, 0x9B, 0xF9

loc_1053E:                                     ; 1053E
  mov dx, 0x1568                               ; 1053E  0xBA, 0x68, 0x15

loc_10541:                                     ; 10541
  call print_cs_string                               ; 10541  0xE8, 0x62, 0x06
  jmp near loc_0FED9                           ; 10544  0xE9, 0x92, 0xF9

loc_10547:                                     ; 10547
  mov dx, 0x1574                               ; 10547  0xBA, 0x74, 0x15
  jmp near loc_10541                           ; 1054A  0xE9, 0xF4, 0xFF

; ===========================================================================
; Kommando: NETON / TILMELD
;
; WHAT:
;   Tilmelder Piccoline til RC-Net (Regnecentralens lokalnetværk).
;
; WHY:
;   Initialiserer netværksdriveren (NETDRV.RSP) og logger på nettet
;   via BDOS funktion 64 (0x40: Network Login).
;
; WORKED EXAMPLE:
;   Bruger indtaster: "TILMELD"
;   1. rcnet_check_active verificerer at Intel 82586 / RCLLC driver er indlæst.
;   2. Kalder BDOS funktion 64 (Network Login) op mod op til 5 forsøg.
;   3. Viser "Tilmeldt nettet\r\n" eller fejlmeddelelse ved timeout.
; ===========================================================================
cmd_neton:
  call rcnet_check_active                      ; 1054D  tjek om netværkshardware er aktiv
  jb loc_10557                                 ; 10550  hvis aktiv -> vis "Tilmeldt nettet"
  mov dx, 0x12a4                               ; 10552  "Ikke tilmeldt nettet\r\n"
  jmp short loc_1055A                          ; 10555  0xEB, 0x03

loc_10557:                                     ; 10557
  mov dx, 0x1265                               ; 10557  "Tilmeldt nettet\r\n"

loc_1055A:                                     ; 1055A
  call print_cs_string                         ; 1055A  udskriv netværksstatus
  jmp near loc_0FED9                           ; 1055D  retur til kommandoløkke

; ---------------------------------------------------------------------------
; Hjælperutine: Tjekker om RC-Net er aktivt på maskinen
; Returnerer: CF=1 hvis netværk er aktivt, CF=0 hvis inaktivt/fejl.
; ---------------------------------------------------------------------------
rcnet_check_active:
  cmp byte [0x413], 0xff                       ; 10560  tjek netværksaktiveringsflag
  je loc_10581                                 ; 10565  hvis deaktiveret -> CF=0 retur
  mov dx, 0                                    ; 10567  0xBA, 0x00, 0x00
  mov cl, 0x49                                 ; 1056A  BDOS 73: Get Network Status
  call bdos_call                               ; 1056C  kald netværksstatus
  db 0x0B, 0xC0                                ; 1056F  or ax, ax
  jne loc_10581                                ; 10571  hvis fejl -> inaktiv
  mov dx, 0xff                                 ; 10573  0xBA, 0xFF, 0x00
  mov cl, 0x48                                 ; 10576  BDOS 72: Return Network Configuration
  call bdos_call                               ; 10578  kald netværkskonfiguration
  db 0x0B, 0xC0                                ; 1057B  or ax, ax
  jne loc_10581                                ; 1057D  hvis fejl -> inaktiv
  stc                                          ; 1057F  CF=1 (netværk aktivt)
  ret                                          ; 10580  0xC3

loc_10581:                                     ; 10581
  clc                                          ; 10581  CF=0 (netværk inaktivt)
  ret                                          ; 10582  0xC3

; ===========================================================================
; Kommando: NETOFF / AFMELD
;
; WHAT:
;   Afmelder Piccoline fra RC-Net via BDOS funktion 65 (Network Logoff).
;
; WHY:
;   Frigiver alle netværksforbindelser og nulstiller netværksbufferen.
; ===========================================================================
cmd_netoff:
  call rcnet_check_logged_on                   ; 10583  tjek om vi er logget på
  jae loc_1059E                                ; 10586  hvis ikke logget på -> vis fejl
  mov dx, 0                                    ; 10588  0xBA, 0x00, 0x00
  mov cl, 0x4a                                 ; 1058B  BDOS 74: Network Logoff
  call bdos_call                               ; 1058D  udfør afmeldingskald
  db 0x0B, 0xC0                                ; 10590  or ax, ax
  jne loc_1059E                                ; 10592  hvis fejl -> vis fejlbesked
  call rcnet_check_logged_on                   ; 10594  verificer tilstand
  jb loc_105A4                                 ; 10597  hvis stadig forbundet -> fejl
  mov dx, 0x1293                               ; 10599  "Afmeldt nettet\r\n"
  jmp short loc_105A1                          ; 1059C  0xEB, 0x03

loc_1059E:                                     ; 1059E
  mov dx, 0x12a4                               ; 1059E  "Ikke tilmeldt nettet\r\n"

loc_105A1:                                     ; 105A1
  call print_cs_string                         ; 105A1  udskriv resultat

loc_105A4:                                     ; 105A4
  jmp near loc_0FED9                           ; 105A4  retur til kommandoløkke

rcnet_require_ready:                                     ; 105A7: Sikrer netværk er klar
  call rcnet_check_ready                       ; 105A7  tjek om netværkskort og driver er klar
  mov dx, 0x1277                               ; 105AA  "Kan ikke tilmeldes nettet\r\n"
  jmp short loc_105B5                          ; 105AD  0xEB, 0x06

rcnet_require_logged_on:                                     ; 105AF: Sikrer vi er logget på nettet
  call rcnet_check_logged_on                   ; 105AF  tjek logon-status
  mov dx, 0x12a4                               ; 105B2  "Ikke tilmeldt nettet\r\n"

loc_105B5:                                     ; 105B5
  jb loc_105BC                                 ; 105B5  hvis OK -> fortsæt (retur)
  inc sp                                       ; 105B7  fjern returadresse (afbryd kaldende rutine)
  inc sp                                       ; 105B8  0x44
  jmp near loc_10ADC                           ; 105B9  udskriv fejl i DX og retur til prompt

loc_105BC:                                     ; 105BC
  ret                                          ; 105BC  0xC3

; ===========================================================================
; Kommando: LOGON / OPRET [drev=server:sti]
;
; WHAT:
;   Opretter virtuel netværksforbindelse mellem et lokalt drevbogstav
;   (f.eks. M:) og et fjernt filkatalog på en RC-Net server.
;
; WHY:
;   Understøtter transparent deling af diske over RC-Net via DR-NET
;   protokollen og BDOS funktion 66 (Network Connect / Map Drive).
;
; WORKED EXAMPLE:
;   Bruger indtaster: "OPRET M:=SERVER1:DATA"
;   1. Parser lokalt drev 'M' -> drev 12.
;   2. Slår servernavn op i NAMSVR.DAT for at hente netværksadresse.
;   3. Etablerer sessionskanal via BDOS funktion 66.
;   4. Viser "Forbindelsen er oprettet\r\n".
; ===========================================================================
cmd_logon:
  cld                                          ; 105BD  0xFC
  call rcnet_require_ready                               ; 105BE  valider netværkstilstand
  mov di, [0x25a]                              ; 105C1  hent parameterpointer
  cmp di, 0                                    ; 105C5  tjek om parameter er givet
  jne loc_105CF                                ; 105C8  hvis ja -> parse parameter
  call rcnet_init_device_request                               ; 105CA  ellers brug standard server
  jmp short loc_105D2                          ; 105CD  0xEB, 0x03

loc_105CF:                                     ; 105CF
  call rcnet_parse_device_request                               ; 105CF  parse drev=server:sti

loc_105D2:                                     ; 105D2
  jb loc_10600                                 ; 105D2  hvis parse-fejl -> vis fejl
  mov al, [0x41e]                              ; 105D4  eget stationsnummer
  cmp al, [0x2af]                              ; 105D7  sammenlign med mål-stationsnummer
  jne loc_105E3                                ; 105DB  hvis forskellig -> fortsæt
  mov dx, 0x138b                               ; 105DD  "Kan ikke oprette til eget nummer\r\n"
  jmp near loc_10ADC                           ; 105E0  fejludgang

loc_105E3:                                     ; 105E3
  mov cl, 0x40                                 ; 105E3  BDOS 64: Network Connect
  call bdos_call                               ; 105E5  opret forbindelse
  mov dx, 0x12bb                               ; 105E8  "Forbindelsen er oprettet\r\n"
  db 0x0B, 0xC0                                ; 105EB  or ax, ax
  je loc_105FA                                 ; 105ED  hvis succes -> vis besked
  mov dx, 0x11c4                               ; 105EF  fejlmeddelelse
  cmp ah, 7                                    ; 105F2  fejlkode 7?
  je loc_105FA                                 ; 105F5  0x74, 0x03
  mov dx, 0x12d6                               ; 105F7  "Forbindelsen kan ikke oprettes\r\n"

loc_105FA:                                     ; 105FA
  call print_cs_string                         ; 105FA  udskriv statusbesked
  jmp near loc_0FED9                           ; 105FD  retur til kommandoløkke

loc_10600:                                     ; 10600: Slå fejltekst op i indekseret tabel
  db 0x98                                      ; 10600  cwde
  shl ax, 1                                    ; 10601  indeks til word-offset
  db 0x8B, 0xD8                                ; 10603  mov bx, ax
  mov dx, [cs:bx + 0x1333]                     ; 10605  hent pointer til fejlbesked
  jmp short loc_105FA                          ; 1060A  udskriv fejlbesked

; ===========================================================================
; Kommando: LOGOFF / AFBRYD [drev]
;
; WHAT:
;   Afbryder netværksforbindelse og frigiver det virtuelle drev via
;   BDOS funktion 67 (0x43: Network Disconnect).
; ===========================================================================
cmd_logoff:
  call rcnet_require_logged_on                               ; 1060C  sikrer vi er forbundet
  mov di, [0x25a]                              ; 1060F  hent parameter
  cmp di, 0                                    ; 10613  parameter givet?
  jne loc_1061D                                ; 10616  hvis ja -> parse drev
  call rcnet_init_device_request                               ; 10618  ellers standard drev
  jmp short loc_10620                          ; 1061B  0xEB, 0x03

loc_1061D:                                     ; 1061D
  call rcnet_parse_device_request                               ; 1061D  parse drevnavn

loc_10620:                                     ; 10620
  jb loc_10600                                 ; 10620  fejl ved parsing -> vis fejl
  mov al, [0x41e]                              ; 10622  eget stationsnummer
  cmp al, [0x2af]                              ; 10625  mål-stationsnummer
  jne loc_10631                                ; 10629  0x75, 0x06
  mov dx, 0x13ae                               ; 1062B  "Kan ikke afbryde fra eget nummer\r\n"
  jmp near loc_10ADC                           ; 1062E  fejludgang

loc_10631:                                     ; 10631
  mov cl, 0x41                                 ; 10631  BDOS 65: Network Disconnect
  call bdos_call                               ; 10633  afbryd forbindelse
  mov dx, 0x12f7                               ; 10636  "Forbindelsen er nedlagt\r\n"
  db 0x0B, 0xC0                                ; 10639  or ax, ax
  je loc_105FA                                 ; 1063B  hvis succes -> vis status
  mov dx, 0x1311                               ; 1063D  "Forbindelsen kan ikke nedlægges\r\n"
  jmp near loc_105FA                           ; 10640  udskriv fejl

; ===========================================================================
; Kommando: NAVNGIV / NET [navn]
;
; WHAT:
;   Konfigurerer eller viser Piccolines stationsnavn i RC-Net.
;
; WHY:
;   Hver maskine identificeres med et unikt navn i RC-Net NAMSVR.DAT databasen.
; ===========================================================================
cmd_navngiv:
  mov di, [0x25a]                              ; 10643  hent parameterpointer
  cmp di, 0                                    ; 10647  ingen parameter givet?
  jne loc_10658                                ; 1064A  hvis parameter -> fortsæt

loc_1064C:                                     ; 1064C
  mov dx, 0x13d1                               ; 1064C  "Mangler argument(er)\r\n"
  jmp near loc_10ADC                           ; 1064F  udskriv fejl

loc_10652:                                     ; 10652
  mov dx, 0x133b                               ; 10652  "Ulovligt argument\r\n"
  jmp near loc_10ADC                           ; 10655  udskriv fejl

loc_10658:                                     ; 10658
  call rcnet_require_ready                               ; 10658  valider netværk
  mov di, [0x25a]                              ; 1065B  0x8B, 0x3E, 0x5A, 0x02
  cmp di, 0                                    ; 1065F  0x83, 0xFF, 0x00
  je loc_1064C                                 ; 10662  0x74, 0xE8
  mov si, 0x444                                ; 10664  arbejdsbuffer
  call parse_device_spec                               ; 10667  parse navnestruktur
  cmp al, 0xff                                 ; 1066A  0x3C, 0xFF
  je loc_1064C                                 ; 1066C  0x74, 0xDE
  cmp al, 0xfe                                 ; 1066E  0x3C, 0xFE
  je loc_10652                                 ; 10670  0x74, 0xE0
  call skip_spaces                             ; 10672  spring over mellemrum
  cmp byte [di], 0x3d                          ; 10675  '=' skilletegn?
  jne loc_10652                                ; 10678  hvis ikke '=' -> ulovligt argument
  inc di                                       ; 1067A  spring '=' over
  mov si, 0x44d                                ; 1067B  buffer til tildelt værdi
  call parse_device_spec                               ; 1067E  parse værdi
  cmp al, [0x444]                              ; 10681  sammenlign typer
  jne loc_10652                                ; 10685  uoverensstemmelse -> fejl
  mov al, [0x413]                              ; 10687  hent netværksattribut
  mov [0x2af], al                              ; 1068A  gem i buffer
  call skip_spaces                             ; 1068D  0xE8, 0x5B, 0x04
  cmp byte [di], 0                             ; 10690  slut på linje?
  je loc_1069D                                 ; 10693  hvis ja -> udfør tildeling
  call rcnet_parse_device_request                               ; 10695  parse ekstra parametre
  jae loc_1069D                                ; 10698  hvis OK -> udfør
  jmp near loc_10600                           ; 1069A  ellers fejl

loc_1069D:                                     ; 1069D: Opbyg navnepakke og send
  mov di, 0x2af                                ; 1069D  destinationsbuffer
  push word [di]                               ; 106A0  gem initial word
  mov al, [0x444]                              ; 106A2  hent navnetype
  mov [di], al                                 ; 106A5  gem type
  cmp al, 3                                    ; 106A7  type 3 (stationsnavn)?
  je loc_106C0                                 ; 106A9  hvis ja -> kopier 8 tegn
  mov al, [0x445]                              ; 106AB  hent kildeenhed
  mov [di + 1], al                             ; 106AE  0x88, 0x45, 0x01
  mov al, [0x44e]                              ; 106B1  hent målenhed
  or al, 0x80                                  ; 106B4  sæt netværksflag
  mov [di + 2], al                             ; 106B6  0x88, 0x45, 0x02
  pop ax                                       ; 106B9  gendan word
  mov [di + 3], al                             ; 106BA  gem i buffer
  jmp near loc_106D7                           ; 106BD  udfør BDOS-kald

loc_106C0:                                     ; 106C0: Kopier 8-tegns stationsnavn
  pop ax                                       ; 106C0  0x58
  push di                                      ; 106C1  0x57
  inc di                                       ; 106C2  0x47
  cld                                          ; 106C3  0xFC
  mov si, 0x445                                ; 106C4  kildenavn
  mov cx, 4                                    ; 106C7  4 ord = 8 bytes
  rep movsw                                    ; 106CA  kopier kildenavn
  mov si, 0x44e                                ; 106CC  målnavn
  mov cx, 4                                    ; 106CF  4 ord = 8 bytes
  rep movsw                                    ; 106D2  kopier målnavn
  mov [di], al                                 ; 106D4  afslutningsattribut
  pop di                                       ; 106D6  0x5F

loc_106D7:                                     ; 106D7: Kald BDOS funktion 69 (Set Station Name)
  db 0x8B, 0xD7                                ; 106D7  mov dx, di
  mov cl, 0x45                                 ; 106D9  BDOS 69: Network Station Name
  call bdos_call                               ; 106DB  udfør kald
  cmp ax, strict word 0                        ; 106DE  fejl?
  je loc_106E9                                 ; 106E1  hvis succes -> afslut
  mov dx, 0x13e8                               ; 106E3  "Navngivning fejlet\r\n"
  jmp near loc_10ADC                           ; 106E6  fejludgang

loc_106E9:                                     ; 106E9
  jmp near loc_0FED9                           ; 106E9  retur til kommandoløkke

loc_106EC:                                     ; 106EC
  mov dx, 0x13d1                               ; 106EC  "Mangler argument(er)\r\n"
  jmp near loc_10ADC                           ; 106EF  0xE9, 0xEA, 0x03

loc_106F2:                                     ; 106F2
  mov dx, 0x133b                               ; 106F2  "Ulovligt argument\r\n"
  jmp near loc_10ADC                           ; 106F5  0xE9, 0xE4, 0x03

; ===========================================================================
; Kommando: LOCAL / LOKAL
;
; WHAT:
;   Nulstiller netværksomdirigering og genetablerer lokale drevforbindelser.
; ===========================================================================
cmd_local:
  call rcnet_require_logged_on                               ; 106F8  sikrer netværksforbindelse
  mov di, [0x25a]                              ; 106FB  hent parameter
  cmp di, 0                                    ; 106FF  parameter givet?
  je loc_106EC                                 ; 10702  mangler parameter -> fejl
  mov si, 0x444                                ; 10704  arbejdsbuffer
  call parse_device_spec                               ; 10707  parse enhed
  cmp al, 0xff                                 ; 1070A  0x3C, 0xFF
  je loc_106EC                                 ; 1070C  0x74, 0xDE
  cmp al, 0xfe                                 ; 1070E  0x3C, 0xFE
  je loc_106F2                                 ; 10710  0x74, 0xE0
  cmp al, 3                                    ; 10712  type 3?
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
  mov cl, 0x45                                 ; 10739  BDOS 69: Network Reset
  call bdos_call                               ; 1073B  udfør lokal gendannelse
  db 0x0B, 0xC0                                ; 1073E  or ax, ax
  jns loc_10748                                ; 10740  hvis ikke negativ -> OK
  mov dx, 0x13fd                               ; 10742  "Fejlet\r\n"
  jmp near loc_10ADC                           ; 10745  udskriv fejl

loc_10748:                                     ; 10748
  jmp near loc_0FED9                           ; 10748  retur til kommandoløkke

; ===========================================================================
; Kommando: SCREEN
;
; WHAT:
;   Sætter TMP759 i skærmtilstand (formatflag 0x412 = 0xFF).
;
; WHY:
;   Aktiverer cursor-positionering, statuslinje og fuldskærms linjeeditor.
; ===========================================================================
cmd_screen:
  mov byte [0x412], 0xff                       ; 1074B  aktiver skærmtilstand
  jmp near loc_0FED9                           ; 10750  retur til kommandoløkke

; ===========================================================================
; Kommando: LINE
;
; WHAT:
;   Sætter TMP759 i ren linjetilstand (formatflag 0x412 = 0x00).
;
; WHY:
;   Deaktiverer escape-koder og cursor-styring; velegnet til seriel terminal
;   eller linjeprinter-output.
; ===========================================================================
cmd_line:
  mov byte [0x412], 0                          ; 10753  aktiver linjetilstand
  jmp near loc_0FED9                           ; 10758  retur til kommandoløkke

; ===========================================================================
; Kommando: ? (Hjælp / Oversigt over indbyggede kommandoer)
;
; WHAT:
;   Viser listen over alle 22 indbyggede kommandoer i 8-kolonne format.
;
; WHY:
;   Giver brugeren et hurtigt overblik over residente ordrer uden at skulle
;   læse eksterne manualer.
; ===========================================================================
cmd_help:
  mov dx, 0x14d7                               ; 1075B  "Indbyggede kommandoer:\r\n"
  call print_cs_string                         ; 1075E  udskriv overskrift
  mov byte [0x1cd], 0xff                       ; 10761  nulstil kolonne-tæller
  mov si, 0x15f3                               ; 10766  pointer til cmd_names_list

loc_10769:                                     ; 10769: Løkke over kommandoer
  db 0x2E, 0x80, 0xBC, 0x00, 0x00, 0x00        ; 10769  cmp byte [cs:si], 0 (nul-terminering)
  je loc_10796                                 ; 1076F  hvis slut på liste -> afslut
  cmp byte [0x1cd], 7                          ; 10771  8 kommandoer per linje?
  jb loc_10782                                 ; 10776  hvis under 8 -> udskriv på samme linje
  push si                                      ; 10778  0x56
  call print_crlf                              ; 10779  linjeskift efter 8 kolonner
  pop si                                       ; 1077C  0x5E
  mov byte [0x1cd], 0                          ; 1077D  nulstil tæller

loc_10782:                                     ; 10782: Udskriv ét kommandoord
  push si                                      ; 10782  0x56
  call print_cmd_name_entry                    ; 10783  udskriv 8 tegn
  mov dx, 0x14ee                               ; 10786  "   " (3 mellemrum mellem kolonner)
  call print_cs_string                         ; 10789  udskriv mellemrum
  inc byte [0x1cd]                             ; 1078C  tæl kolonne op
  pop si                                       ; 10790  0x5E
  add si, 8                                    ; 10791  næste kommando i listen
  jmp short loc_10769                          ; 10794  gentag for alle 22 ord

loc_10796:                                     ; 10796: Afslutning på hjælp
  call print_crlf                              ; 10796  afsluttende linjeskift
  jmp near loc_0FED9                           ; 10799  retur til kommandoløkke

print_cmd_name_entry:                                     ; 1079C
  push si                                      ; 1079C  0x56
  db 0x2E, 0x8A, 0x94, 0x00, 0x00              ; 1079D  mov dl, byte [cs:si]
  call bdos_con_out                               ; 107A2  0xE8, 0xF2, 0x03
  pop si                                       ; 107A5  0x5E
  inc si                                       ; 107A6  0x46
  mov cx, 7                                    ; 107A7  0xB9, 0x07, 0x00

loc_107AA:                                     ; 107AA
  db 0x2E, 0xAC                                ; 107AA  lodsb
  push si                                      ; 107AC  0x56
  push cx                                      ; 107AD  0x51
  call char_to_lower                               ; 107AE  0xE8, 0xC9, 0x03
  db 0x8A, 0xD0                                ; 107B1  mov dl, al
  call bdos_con_out                               ; 107B3  0xE8, 0xE1, 0x03
  pop cx                                       ; 107B6  0x59
  pop si                                       ; 107B7  0x5E
  loop loc_107AA                               ; 107B8  0xE2, 0xF0
  ret                                          ; 107BA  0xC3

parse_device_spec:                                     ; 107BB
  call skip_spaces                               ; 107BB  0xE8, 0x2D, 0x03
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

rcnet_check_ready:                                     ; 10842
  call rcnet_check_logged_on                               ; 10842  0xE8, 0x09, 0x00
  jb loc_10866                                 ; 10845  0x72, 0x1F
  call rcnet_check_active                               ; 10847  0xE8, 0x16, 0xFD
  jb loc_10866                                 ; 1084A  0x72, 0x1A
  jmp short loc_10864                          ; 1084C  0xEB, 0x16

rcnet_check_logged_on:                                     ; 1084E
  cmp byte [0x413], 0xff                       ; 1084E  0x80, 0x3E, 0x13, 0x04, 0xFF
  je loc_10864                                 ; 10853  0x74, 0x0F
  mov cl, 0x44                                 ; 10855  0xB1, 0x44
  call bdos_call                               ; 10857  0xE8, 0xC9, 0x03
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

rcnet_init_device_request:                                     ; 10868
  call clear_fcb_name_buffer                               ; 10868  0xE8, 0xC0, 0x01
  mov al, [0x413]                              ; 1086B  0xA0, 0x13, 0x04
  mov [0x2af], al                              ; 1086E  0xA2, 0xAF, 0x02
  mov dx, 0x2af                                ; 10871  0xBA, 0xAF, 0x02
  clc                                          ; 10874  0xF8
  ret                                          ; 10875  0xC3

rcnet_parse_device_request:                                     ; 10876
  push di                                      ; 10876  0x57
  call clear_fcb_name_buffer                               ; 10877  0xE8, 0xB1, 0x01
  pop di                                       ; 1087A  0x5F
  call skip_spaces                               ; 1087B  0xE8, 0x6D, 0x02
  push di                                      ; 1087E  0x57
  call parse_hex_digit                               ; 1087F  0xE8, 0x3A, 0x02
  jb loc_108C4                                 ; 10882  0x72, 0x40
  inc di                                       ; 10884  0x47
  cmp byte [di + 1], 0                         ; 10885  0x80, 0x7D, 0x01, 0x00
  je loc_108C4                                 ; 10889  0x74, 0x39
  call parse_hex_digit                               ; 1088B  0xE8, 0x2E, 0x02
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
  call skip_spaces                               ; 108BB  0xE8, 0x2D, 0x02
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
  call parse_filename_anycase                               ; 108CD  0xE8, 0x82, 0x01

loc_108D0:                                     ; 108D0
  call skip_spaces                               ; 108D0  0xE8, 0x18, 0x02
  cmp byte [di], 0                             ; 108D3  0x80, 0x3D, 0x00
  je loc_108EC                                 ; 108D6  0x74, 0x14
  cmp byte [di], 0x3b                          ; 108D8  0x80, 0x3D, 0x3B
  jne loc_108C0                                ; 108DB  0x75, 0xE3
  inc di                                       ; 108DD  0x47
  mov si, 0x2b0                                ; 108DE  0xBE, 0xB0, 0x02
  call parse_filename_upper                               ; 108E1  0xE8, 0x6A, 0x01
  call skip_spaces                               ; 108E4  0xE8, 0x04, 0x02
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
  call rcnet_reset_request_fcb                               ; 10923  0xE8, 0xE2, 0x00
  je loc_1092A                                 ; 10926  0x74, 0x02
  jmp short loc_10933                          ; 10928  0xEB, 0x09

loc_1092A:                                     ; 1092A
  call bdos_network_func_73                               ; 1092A  0xE8, 0x86, 0x00
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

bdos_network_func_73:                                     ; 109B3
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
  je rcnet_reset_request_fcb                                 ; 10A03  0x74, 0x03

loc_10A05:                                     ; 10A05
  db 0x33, 0xC0                                ; 10A05  xor ax, ax
  ret                                          ; 10A07  0xC3

rcnet_reset_request_fcb:                                     ; 10A08
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

clear_fcb_name_buffer:                                     ; 10A2B
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

parse_filename_upper:                                     ; 10A4E
  mov ah, 0                                    ; 10A4E  0xB4, 0x00
  jmp short loc_10A54                          ; 10A50  0xEB, 0x02

parse_filename_anycase:                                     ; 10A52
  mov ah, 0xff                                 ; 10A52  0xB4, 0xFF

loc_10A54:                                     ; 10A54
  call skip_spaces                               ; 10A54  0xE8, 0x94, 0x00
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

print_hex_byte:                                     ; 10A94
  push ax                                      ; 10A94  0x50
  mov cl, 4                                    ; 10A95  0xB1, 0x04
  shr al, cl                                   ; 10A97  0xD2, 0xE8
  call print_hex_nibble                               ; 10A99  0xE8, 0x01, 0x00
  pop ax                                       ; 10A9C  0x58

print_hex_nibble:                                     ; 10A9D
  and al, 0xf                                  ; 10A9D  0x24, 0x0F
  add al, 0x90                                 ; 10A9F  0x04, 0x90
  db 0x27                                      ; 10AA1  daa
  adc al, 0x40                                 ; 10AA2  0x14, 0x40
  db 0x27                                      ; 10AA4  daa
  db 0x8A, 0xD0                                ; 10AA5  mov dl, al
  jmp near bdos_con_out                           ; 10AA7  0xE9, 0xED, 0x00
  push ax                                      ; 10AAA  0x50
  db 0x8A, 0xC4                                ; 10AAB  mov al, ah
  call print_hex_byte                               ; 10AAD  0xE8, 0xE4, 0xFF
  pop ax                                       ; 10AB0  0x58
  jmp short print_hex_byte                          ; 10AB1  0xEB, 0xE1

loc_10AB3:                                     ; 10AB3
  mov byte [bx + 8], 0                         ; 10AB3  0xC6, 0x47, 0x08, 0x00
  db 0x8B, 0xD3                                ; 10AB7  mov dx, bx
  jmp near print_string                           ; 10AB9  0xE9, 0xF4, 0x00

parse_hex_digit:                                     ; 10ABC
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
  call print_cs_string                               ; 10ADC  0xE8, 0xC7, 0x00
  jmp near loc_0FED9                           ; 10ADF  0xE9, 0xF7, 0xF3

set_raw_console_mode:                                     ; 10AE2
  mov cl, 0x6d                                 ; 10AE2  0xB1, 0x6D
  mov dx, 9                                    ; 10AE4  0xBA, 0x09, 0x00
  jmp near bdos_call                           ; 10AE7  0xE9, 0x39, 0x01

loc_10AEA:                                     ; 10AEA
  inc di                                       ; 10AEA  0x47

skip_spaces:                                     ; 10AEB
  cmp byte [di], 0x20                          ; 10AEB  0x80, 0x3D, 0x20
  je loc_10AEA                                 ; 10AEE  0x74, 0xFA
  cmp byte [di], 9                             ; 10AF0  0x80, 0x3D, 0x09
  je loc_10AEA                                 ; 10AF3  0x74, 0xF5
  ret                                          ; 10AF5  0xC3

bdos_parse_filename:                                     ; 10AF6
  mov cx, 0x98                                 ; 10AF6  0xB9, 0x98, 0x00
  mov bx, 0x25c                                ; 10AF9  0xBB, 0x5C, 0x02
  mov [bx], di                                 ; 10AFC  0x89, 0x3F
  mov [bx + 2], si                             ; 10AFE  0x89, 0x77, 0x02
  db 0x8B, 0xD3                                ; 10B01  mov dx, bx
  jmp near bdos_call                           ; 10B03  0xE9, 0x1D, 0x01

parse_decimal_2digit:                                     ; 10B06
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

parse_ascii_uint:                                     ; 10B35
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

format_uint_to_ascii:                                     ; 10B53
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

char_to_lower:                                     ; 10B7A
  cmp al, 0x41                                 ; 10B7A  0x3C, 0x41
  jb loc_10B84                                 ; 10B7C  0x72, 0x06
  cmp al, 0x5a                                 ; 10B7E  0x3C, 0x5A
  ja loc_10B84                                 ; 10B80  0x77, 0x02
  add al, 0x20                                 ; 10B82  0x04, 0x20

loc_10B84:                                     ; 10B84
  ret                                          ; 10B84  0xC3

print_decimal_byte:                                     ; 10B85
  cmp dl, 0xa                                  ; 10B85  0x80, 0xFA, 0x0A
  jb loc_10B94                                 ; 10B88  0x72, 0x0A
  push dx                                      ; 10B8A  0x52
  mov dl, 0x31                                 ; 10B8B  0xB2, 0x31
  call bdos_con_out                               ; 10B8D  0xE8, 0x07, 0x00
  pop dx                                       ; 10B90  0x5A
  sub dl, 0xa                                  ; 10B91  0x80, 0xEA, 0x0A

loc_10B94:                                     ; 10B94
  add dl, 0x30                                 ; 10B94  0x80, 0xC2, 0x30

bdos_con_out:                                     ; 10B97
  mov cl, 2                                    ; 10B97  0xB1, 0x02
  jmp near bdos_call                           ; 10B99  0xE9, 0x87, 0x00

bdos_get_user:                                     ; 10B9C
  mov dl, 0xff                                 ; 10B9C  0xB2, 0xFF

bdos_set_user:                                     ; 10B9E
  mov cl, 0x20                                 ; 10B9E  0xB1, 0x20
  jmp near bdos_call                           ; 10BA0  0xE9, 0x80, 0x00

print_crlf:                                     ; 10BA3
  mov dx, 0x10ad                               ; 10BA3  0xBA, 0xAD, 0x10

print_cs_string:                                     ; 10BA6
  push ds                                      ; 10BA6  0x1E
  mov ax, cs                                   ; 10BA7  0x8C, 0xC8
  mov ds, ax                                   ; 10BA9  0x8E, 0xD8
  call print_string                               ; 10BAB  0xE8, 0x02, 0x00
  pop ds                                       ; 10BAE  0x1F
  ret                                          ; 10BAF  0xC3

print_string:                                     ; 10BB0
  mov cl, 9                                    ; 10BB0  0xB1, 0x09
  jmp short bdos_call                          ; 10BB2  0xEB, 0x6F

print_cs_string_mode109:                                     ; 10BB4
  push ds                                      ; 10BB4  0x1E
  jmp short loc_10BB8                          ; 10BB5  0xEB, 0x01

print_raw_mode109:                                     ; 10BB7
  push cs                                      ; 10BB7  0x0E

loc_10BB8:                                     ; 10BB8
  push dx                                      ; 10BB8  0x52
  mov dx, 0xffff                               ; 10BB9  0xBA, 0xFF, 0xFF
  mov cl, 0x6d                                 ; 10BBC  0xB1, 0x6D
  call bdos_call                               ; 10BBE  0xE8, 0x62, 0x00
  pop dx                                       ; 10BC1  0x5A
  pop bx                                       ; 10BC2  0x5B
  push ds                                      ; 10BC3  0x1E
  push ax                                      ; 10BC4  0x50
  push dx                                      ; 10BC5  0x52
  push bx                                      ; 10BC6  0x53
  or ax, strict word 4                         ; 10BC7  0D 04 00
  db 0x8B, 0xD0                                ; 10BCA  mov dx, ax
  mov cl, 0x6d                                 ; 10BCC  0xB1, 0x6D
  call bdos_call                               ; 10BCE  0xE8, 0x52, 0x00
  pop ds                                       ; 10BD1  0x1F
  pop dx                                       ; 10BD2  0x5A
  call print_string                               ; 10BD3  0xE8, 0xDA, 0xFF
  pop dx                                       ; 10BD6  0x5A
  mov cl, 0x6d                                 ; 10BD7  0xB1, 0x6D
  call bdos_call                               ; 10BD9  0xE8, 0x47, 0x00
  pop ds                                       ; 10BDC  0x1F
  ret                                          ; 10BDD  0xC3

bdos_attach_console:                                     ; 10BDE
  mov cl, 0x94                                 ; 10BDE  0xB1, 0x94
  jmp short bdos_call                          ; 10BE0  0xEB, 0x41

bdos_select_disk_checked:                                     ; 10BE2
  call bdos_select_disk                               ; 10BE2  0xE8, 0x03, 0x00
  jmp near rcnet_check_error                           ; 10BE5  0xE9, 0xB7, 0x01

bdos_select_disk:                                     ; 10BE8
  mov cl, 0xe                                  ; 10BE8  0xB1, 0x0E
  jmp near bdos_call                           ; 10BEA  0xE9, 0x36, 0x00

bdos_get_disk:                                     ; 10BED
  mov cl, 0x19                                 ; 10BED  0xB1, 0x19
  jmp short bdos_call                          ; 10BEF  0xEB, 0x32

bdos_set_list:                                     ; 10BF1
  mov cl, 0xa0                                 ; 10BF1  0xB1, 0xA0
  jmp short bdos_call                          ; 10BF3  0xEB, 0x2E

bdos_get_list:                                     ; 10BF5
  mov cl, 0xa4                                 ; 10BF5  0xB1, 0xA4
  jmp short bdos_call                          ; 10BF7  0xEB, 0x2A

bdos_attach_list:                                     ; 10BF9
  mov cl, 0xa2                                 ; 10BF9  0xB1, 0xA2
  jmp short bdos_call                          ; 10BFB  0xEB, 0x26

bdos_detach_console:                                     ; 10BFD
  mov cl, 0x93                                 ; 10BFD  0xB1, 0x93
  jmp short bdos_call                          ; 10BFF  0xEB, 0x22

bdos_read_console:                                     ; 10C01
  mov cl, 0xa                                  ; 10C01  0xB1, 0x0A
  jmp short bdos_call                          ; 10C03  0xEB, 0x1E
  mov cl, 0x27                                 ; 10C05  0xB1, 0x27
  jmp short bdos_call                          ; 10C07  0xEB, 0x1A

save_mem_limit:                                     ; 10C09
  mov [0x410], ax                              ; 10C09  0xA3, 0x10, 0x04
  push ds                                      ; 10C0C  0x1E
  mov ds, [0]                                  ; 10C0D  0x8E, 0x1E, 0x00, 0x00
  mov [0x4c], ax                               ; 10C11  0xA3, 0x4C, 0x00
  pop ds                                       ; 10C14  0x1F
  ret                                          ; 10C15  0xC3

load_mem_limit:                                     ; 10C16
  push ds                                      ; 10C16  0x1E
  mov ds, [0]                                  ; 10C17  0x8E, 0x1E, 0x00, 0x00
  mov ax, [0x4c]                               ; 10C1B  0xA1, 0x4C, 0x00
  pop ds                                       ; 10C1E  0x1F
  mov [0x410], ax                              ; 10C1F  0xA3, 0x10, 0x04
  ret                                          ; 10C22  0xC3

bdos_call:                                     ; 10C23
  int 0xe0                                     ; 10C23  0xCD, 0xE0
  ret                                          ; 10C25  0xC3

read_cmd_input:                                     ; 10C26
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
  call print_string                               ; 10C49  0xE8, 0x64, 0xFF
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
  call print_cs_string_mode109                               ; 10C73  0xE8, 0x3E, 0xFF
  mov dx, 0x1593                               ; 10C76  0xBA, 0x93, 0x15
  call print_raw_mode109                               ; 10C79  0xE8, 0x3B, 0xFF
  mov byte [0x259], 0xff                       ; 10C7C  0xC6, 0x06, 0x59, 0x02, 0xFF

loc_10C81:                                     ; 10C81
  mov byte [0x1d2], 0                          ; 10C81  0xC6, 0x06, 0xD2, 0x01, 0x00
  cmp byte [0x259], 0                          ; 10C86  0x80, 0x3E, 0x59, 0x02, 0x00
  je loc_10C95                                 ; 10C8B  0x74, 0x08
  mov byte [0x259], 0                          ; 10C8D  0xC6, 0x06, 0x59, 0x02, 0x00
  call print_crlf                               ; 10C92  0xE8, 0x0E, 0xFF

loc_10C95:                                     ; 10C95
  call print_prompt                               ; 10C95  0xE8, 0xCF, 0x00
  cmp byte [0x412], 0xff                       ; 10C98  0x80, 0x3E, 0x12, 0x04, 0xFF
  je loc_10CA7                                 ; 10C9D  0x74, 0x08
  mov dx, 0x148                                ; 10C9F  0xBA, 0x48, 0x01
  call bdos_read_console                               ; 10CA2  0xE8, 0x5C, 0xFF
  jmp short loc_10CAA                          ; 10CA5  0xEB, 0x03

loc_10CA7:                                     ; 10CA7
  call read_console_screen_line                               ; 10CA7  0xE8, 0x06, 0x00

loc_10CAA:                                     ; 10CAA
  mov dl, 0xa                                  ; 10CAA  0xB2, 0x0A
  call bdos_con_out                               ; 10CAC  0xE8, 0xE8, 0xFE

loc_10CAF:                                     ; 10CAF
  ret                                          ; 10CAF  0xC3

read_console_screen_line:                                     ; 10CB0
  mov dl, 1                                    ; 10CB0  0xB2, 0x01
  mov cl, 0x6e                                 ; 10CB2  0xB1, 0x6E
  call bdos_call                               ; 10CB4  0xE8, 0x6C, 0xFF
  mov dx, 0x1596                               ; 10CB7  0xBA, 0x96, 0x15
  call print_raw_mode109                               ; 10CBA  0xE8, 0xFA, 0xFE
  mov dl, 0                                    ; 10CBD  0xB2, 0x00
  mov cl, 0x6e                                 ; 10CBF  0xB1, 0x6E
  call bdos_call                               ; 10CC1  0xE8, 0x5F, 0xFF
  call read_keys_interactive                               ; 10CC4  0xE8, 0x4D, 0x00
  call xios_get_cursor_pos                               ; 10CC7  0xE8, 0x95, 0x00
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

read_keys_interactive:                                     ; 10D14
  mov cl, 6                                    ; 10D14  0xB1, 0x06
  mov dl, 0xfd                                 ; 10D16  0xB2, 0xFD
  call bdos_call                               ; 10D18  0xE8, 0x08, 0xFF
  cmp al, 9                                    ; 10D1B  0x3C, 0x09
  je loc_10D35                                 ; 10D1D  0x74, 0x16
  cmp al, 0xc                                  ; 10D1F  0x3C, 0x0C
  je loc_10D48                                 ; 10D21  0x74, 0x25
  cmp al, 0x7f                                 ; 10D23  0x3C, 0x7F
  je loc_10D57                                 ; 10D25  0x74, 0x30
  push ax                                      ; 10D27  0x50
  db 0x8A, 0xD0                                ; 10D28  mov dl, al
  mov cl, 2                                    ; 10D2A  0xB1, 0x02
  call bdos_call                               ; 10D2C  0xE8, 0xF4, 0xFE
  pop ax                                       ; 10D2F  0x58
  cmp al, 0xd                                  ; 10D30  0x3C, 0x0D
  jne read_keys_interactive                                ; 10D32  0x75, 0xE0
  ret                                          ; 10D34  0xC3

loc_10D35:                                     ; 10D35
  mov dx, 0x15a5                               ; 10D35  0xBA, 0xA5, 0x15
  call print_raw_mode109                               ; 10D38  0xE8, 0x7C, 0xFE
  call xios_get_cursor_pos                               ; 10D3B  0xE8, 0x21, 0x00
  cmp al, 0x4f                                 ; 10D3E  0x3C, 0x4F
  je read_keys_interactive                                 ; 10D40  0x74, 0xD2
  and al, 7                                    ; 10D42  0x24, 0x07
  je read_keys_interactive                                 ; 10D44  0x74, 0xCE
  jmp short loc_10D35                          ; 10D46  0xEB, 0xED

loc_10D48:                                     ; 10D48
  mov dx, 0x15ab                               ; 10D48  0xBA, 0xAB, 0x15
  call print_raw_mode109                               ; 10D4B  0xE8, 0x69, 0xFE
  call xios_get_cursor_pos                               ; 10D4E  0xE8, 0x0E, 0x00
  and al, 7                                    ; 10D51  0x24, 0x07
  je read_keys_interactive                                 ; 10D53  0x74, 0xBF
  jmp short loc_10D48                          ; 10D55  0xEB, 0xF1

loc_10D57:                                     ; 10D57
  mov dx, 0x15df                               ; 10D57  0xBA, 0xDF, 0x15
  call print_raw_mode109                               ; 10D5A  0xE8, 0x5A, 0xFE
  jmp short read_keys_interactive                          ; 10D5D  0xEB, 0xB5

xios_get_cursor_pos:                                     ; 10D5F
  mov ax, 0x16                                 ; 10D5F  0xB8, 0x16, 0x00
  int 0x28                                     ; 10D62  0xCD, 0x28
  db 0x8B, 0xC3                                ; 10D64  mov ax, bx
  ret                                          ; 10D66  0xC3

print_prompt:                                     ; 10D67
  mov dl, 0xd                                  ; 10D67  0xB2, 0x0D
  call bdos_con_out                               ; 10D69  0xE8, 0x2B, 0xFE
  call bdos_get_user                               ; 10D6C  0xE8, 0x2D, 0xFE
  test bl, bl                                  ; 10D6F  0x84, 0xDB
  je loc_10D78                                 ; 10D71  0x74, 0x05
  db 0x8A, 0xD3                                ; 10D73  mov dl, bl
  call print_decimal_byte                               ; 10D75  0xE8, 0x0D, 0xFE

loc_10D78:                                     ; 10D78
  call bdos_get_disk                               ; 10D78  0xE8, 0x72, 0xFE
  mov dl, 0x61                                 ; 10D7B  0xB2, 0x61
  cmp byte [0x412], 0xff                       ; 10D7D  0x80, 0x3E, 0x12, 0x04, 0xFF
  je loc_10D86                                 ; 10D82  0x74, 0x02
  mov dl, 0x41                                 ; 10D84  0xB2, 0x41

loc_10D86:                                     ; 10D86
  db 0x02, 0xD3                                ; 10D86  add dl, bl
  call bdos_con_out                               ; 10D88  0xE8, 0x0C, 0xFE
  mov dx, 0x15e5                               ; 10D8B  0xBA, 0xE5, 0x15
  call print_cs_string                               ; 10D8E  0xE8, 0x15, 0xFE
  cmp byte [0x412], 0xff                       ; 10D91  0x80, 0x3E, 0x12, 0x04, 0xFF
  je loc_10D9E                                 ; 10D96  0x74, 0x06

print_dir_stopped_by_user:                                     ; 10D98
  mov dx, 0x15cf                               ; 10D98  0xBA, 0xCF, 0x15
  call print_raw_mode109                               ; 10D9B  0xE8, 0x19, 0xFE

loc_10D9E:                                     ; 10D9E
  ret                                          ; 10D9E  0xC3

rcnet_check_error:                                     ; 10D9F
  cmp al, 0xff                                 ; 10D9F  0x3C, 0xFF
  stc                                          ; 10DA1  0xF9
  jne loc_10DB8                                ; 10DA2  0x75, 0x14
  cmp ah, 1                                    ; 10DA4  0x80, 0xFC, 0x01
  jb loc_10DB8                                 ; 10DA7  0x72, 0x0F
  db 0x8A, 0xDC                                ; 10DA9  mov bl, ah
  db 0x32, 0xFF                                ; 10DAB  xor bh, bh
  shl bx, 1                                    ; 10DAD  0xD1, 0xE3
  mov dx, [cs:bx + 0x1247]                     ; 10DAF  0x2E, 0x8B, 0x97, 0x47, 0x12
  call print_cs_string                               ; 10DB4  0xE8, 0xEF, 0xFD
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
  db_dk "  CCP/M fejl: "
  db 0
  db_dk "For lidt lager"
  db 0x0D, 0x0A, 0
  db_dk "PD tabel fuld"
  db 0x0D, 0x0A, 0
  db_dk "Program indlæsning"
  db 0x0D, 0x0A, 0
  db_dk "Kommando findes ikke"
  db 0x0D, 0x0A, 0
  db_dk "RSP kommando kø fuld"
  db 0x0D, 0x0A, 0
  db_dk "Kommando fortolkning afbrudt"
  db 0x0D, 0x0A, 0
  db 0
  db_dk "Diskette fejl"
  db 0x0D, 0x0A, 0
  db_dk "Disketten skrive beskyttet"
  db 0x0D, 0x0A, 0
  db_dk "Filen er skrive beskyttet"
  db 0x0D, 0x0A, 0
  db_dk "Ulovlig diskbetegnelse"
  db 0x0D, 0x0A, 0
  db_dk "Filen er i brug"
  db 0x0D, 0x0A, 0
  db_dk "Lukke fejl"
  db 0x0D, 0x0A, 0
  db_dk "Løsen passer ikke"
  db 0x0D, 0x0A, 0
  db_dk "Filen findes"
  db 0x0D, 0x0A, 0
  db_dk "Ulovligt filnavn"
  db 0x0D, 0x0A, 0
  db_dk "Ingen plads i system listen"
  db 0x0D, 0x0A, 0
  db_dk "Vært fejl"
  db 0x0D, 0x0A, 0
  db_dk "Netbruger fejl"
  db 0x0D, 0x0A, 0
  db_dk "Fysisk net fejl"
  db 0x0D, 0x0A, 0

; --- RC-Net Statusbesked Pointer-Tabel (0x10F87) ---
  dw 0x1142, 0x1143, 0x1153, 0x1170, 0x118C, 0x11A5, 0x11B7, 0x11C4
  dw 0x11D8, 0x11E7, 0x11FA, 0x11FA, 0x1218, 0x1224, 0x1235

; --- RC-Net Statusbeskeder & Terminalsekvenser (0x10FA5) ---
  db_dk "Tilmeldt nettet"
  db 0x0D, 0x0A, 0
  db_dk "Kan ikke tilmeldes nettet"
  db 0x0D, 0x0A, 0
  db_dk "Afmeldt nettet"
  db 0x0D, 0x0A, 0
  db_dk "Ikke tilmeldt nettet"
  db 0x0D, 0x0A, 0
  db_dk "Forbindelsen er oprettet"
  db 0x0D, 0x0A, 0
  db_dk "Forbindelsen kan ikke oprettes"
  db 0x0D, 0x0A, 0
  db_dk "Forbindelsen er nedlagt"
  db 0x0D, 0x0A, 0
  db_dk "Forbindelsen kan ikke nedlægges"
  db 0x0D, 0x0A, 0
  db ";", 0x13
  db_dk "Å"
  db 0x13, "O", 0x13, "v", 0x13
  db_dk "Ulovligt argument"
  db 0x0D, 0x0A, 0
  db_dk "Navn ukendt"
  db 0x0D, 0x0A, 0
  db_dk "Navnetabel findes ikke"
  db 0x0D, 0x0A, 0
  db_dk "Værten svarer ikke"
  db 0x0D, 0x0A, 0
  db_dk "Kan ikke oprette til eget nummer"
  db 0x0D, 0x0A, 0
  db_dk "Kan ikke afbryde fra eget nummer"
  db 0x0D, 0x0A, 0
  db_dk "Mangler argument(er)"
  db 0x0D, 0x0A, 0
  db_dk "Navngivning fejlet"
  db 0x0D, 0x0A, 0
  db_dk "Fejlet"
  db 0x0D, 0x0A, 0
  db_dk "Program løsen: "
  db 0
  db_dk "  Kommando = "
  db 0
  db_dk "Ulovligt bruger nummer"
  db 0x0D, 0x0A, 0
  db_dk "Bruger nummer er "
  db 0
  db_dk "Ulovligt skriver nummer"
  db 0x0D, 0x0A, 0
  db_dk "Skriver nummer er "
  db 0
  db 0x0D, 0x0A
  db_dk "Menu kø kan ikke oprettes"
  db 0x0D, 0x0A, 0
  db 0x0D, 0x0A
  db_dk "Menu kø kan ikke åbnes"
  db 0x0D, 0x0A, 0
  db_dk "Ulovlig lagergrænse, (16-768 K)"
  db 0x0D, 0x0A, 0
  db_dk "Indbyggede kommandoer:"
  db 0
  db "   ", 0
  db_dk "Ulovlig parameter"
  db 0
  db_dk "Ingen fil(er)"
  db 0
  db_dk "Katalog for "
  db 0
  db_dk "bruger nr. "
  db 0
  db_dk "System filer findes"
  db 0
  db 0x0D, 0x0A
  db_dk "DIR Stoppet af brugeren"
  db 0
  db_dk "Abort fejlet"
  db 0x0D, 0x0A, 0
  db_dk "Aborteret"
  db 0x0D, 0x0A, 0
  db_dk "Ulovligt konsol nr."
  db 0x0D, 0x0A, 0
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

; ---------------------------------------------------------------------------
; Liste over indbyggede kommandoer (22 ord à 8 tegn, mellemrumspolstret)
; Udskrives af '?' kommandoen og gennemsøges ved kommandotolkning.
; Hvert opslag svarer til et indeks i cmd_dispatch_table nedenfor.
; ---------------------------------------------------------------------------
  db 0x1B, 0xFD, 0
cmd_names_list:
  db "?       ABORT   AFBRYD  AFMELD  BRUGER  DIR     LINE    LOCAL   LOKAL   LOGOFF  LOGON   "
  db "NAVNGIV NET     NETOFF  NETON   OPRET   PRINTER SCREEN  SIZE    SKRIVER TILMELD USER    ", 0

; ---------------------------------------------------------------------------
; Dispatch-tabel for indbyggede ordrer (22 16-bit word offsets i kodesegmentet)
; Matcher 1:1 rækkefølgen i cmd_names_list ovenfor.
; ---------------------------------------------------------------------------
cmd_dispatch_table:
  dw cmd_help - rsp_tmp759_start               ; ?       -> cmd_help (0x0a1b)
  dw cmd_abort - rsp_tmp759_start              ; ABORT   -> cmd_abort (0x0763)
  dw cmd_logoff - rsp_tmp759_start             ; AFBRYD  -> cmd_logoff (0x08cc)
  dw cmd_netoff - rsp_tmp759_start             ; AFMELD  -> cmd_netoff (0x0843)
  dw cmd_user - rsp_tmp759_start               ; BRUGER  -> cmd_user (0x0410)
  dw cmd_dir - rsp_tmp759_start                ; DIR     -> cmd_dir (0x0512)
  dw cmd_line - rsp_tmp759_start               ; LINE    -> cmd_line (0x0a13)
  dw cmd_local - rsp_tmp759_start              ; LOCAL   -> cmd_local (0x09b8)
  dw cmd_local - rsp_tmp759_start              ; LOKAL   -> cmd_local (0x09b8)
  dw cmd_logoff - rsp_tmp759_start             ; LOGOFF  -> cmd_logoff (0x08cc)
  dw cmd_logon - rsp_tmp759_start              ; LOGON   -> cmd_logon (0x087d)
  dw cmd_navngiv - rsp_tmp759_start            ; NAVNGIV -> cmd_navngiv (0x0903)
  dw cmd_navngiv - rsp_tmp759_start            ; NET     -> cmd_navngiv (0x0903)
  dw cmd_netoff - rsp_tmp759_start             ; NETOFF  -> cmd_netoff (0x0843)
  dw cmd_neton - rsp_tmp759_start              ; NETON   -> cmd_neton (0x080d)
  dw cmd_logon - rsp_tmp759_start              ; OPRET   -> cmd_logon (0x087d)
  dw cmd_printer - rsp_tmp759_start            ; PRINTER -> cmd_printer (0x0466)
  dw cmd_screen - rsp_tmp759_start             ; SCREEN  -> cmd_screen (0x0a0b)
  dw cmd_size - rsp_tmp759_start               ; SIZE    -> cmd_size (0x04b8)
  dw cmd_printer - rsp_tmp759_start            ; SKRIVER -> cmd_printer (0x0466)
  dw cmd_neton - rsp_tmp759_start              ; TILMELD -> cmd_neton (0x080d)
  dw cmd_user - rsp_tmp759_start               ; USER    -> cmd_user (0x0410)

; ---------------------------------------------------------------------------
; Start Kommando Prompt
; ---------------------------------------------------------------------------
prompt_startup_cmd:
  db "Start Kommando: ", 0
  times 15 db 0                                ; Nul-pad til paragrafgrænse (0x16F0 = 5.872 bytes)

