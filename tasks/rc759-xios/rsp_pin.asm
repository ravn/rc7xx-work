; ===========================================================================
; RSP 3: PIN — Process INput (tastatur- og linjeeditering for Piccoline)
; Offset range: 0x115F0 - 0x125DF
;   - Del 1: Data Segment (0x115F0 - 0x117CF, 480 bytes: RSPHDR + PD + UDA)
;   - Del 2: Code Segment (0x117D0 - 0x125DF)
; ===========================================================================

; ===========================================================================
; DEL 1: PIN DATA SEGMENT (RSPHDR + PD + UDA) — 480 bytes (0x115F0 - 0x117CF)
; ===========================================================================
  adc word [bx + di], -0x61                    ; 115F0  0x83, 0x11, 0x9F
  db 0x00, 0x00                               ; 115F3
  db 0x00, 0x00                               ; 115F5
  db 0x00, 0x00                               ; 115F7
  db 0x00, 0x00                               ; 115F9
  db 0x00, 0x00                               ; 115FB
  db 0x00, 0x00                               ; 115FD
  db 0x00, 0x00                               ; 115FF
  db 0x00, 0x00                               ; 11601
  db 0x00, 0x00                               ; 11603
  mov cx, 3                                    ; 11605  0xB9, 0x03, 0x00
  push ax                                      ; 11608  0x50
  dec cx                                       ; 11609  0x49
  dec si                                       ; 1160A  0x4E
  xor [bx + si], ah                            ; 1160B  0x30, 0x20
  and [bx + si], ah                            ; 1160D  0x20, 0x20
  and [si], al                                 ; 1160F  0x20, 0x04
  db 0x00, 0x00                               ; 11611
  db 0x00, 0x00                               ; 11613
  add [bx + si], cl                            ; 11615  0x00, 0x08
  db 0x00, 0x00                               ; 11617
  db 0x00, 0x00                               ; 11619
  db 0x00, 0x00                               ; 1161B
  db 0x00, 0x00                               ; 1161D
  db 0x00, 0x00                               ; 1161F
  db 0x00, 0x00                               ; 11621
  db 0x00, 0x00                               ; 11623
  db 0x00, 0x00                               ; 11625
  db 0x00, 0x00                               ; 11627
  db 0x00, 0x00                               ; 11629
  db 0x00, 0x00                               ; 1162B
  db 0x00, 0x00                               ; 1162D
  db 0x00, 0x00                               ; 1162F
  db 0x00, 0x00                               ; 11631
  db 0x00, 0x00                               ; 11633
  db 0x00, 0x00                               ; 11635
  db 0x00, 0x00                               ; 11637
  db 0x00, 0x00                               ; 11639
  db 0x00, 0x00                               ; 1163B
  db 0x00, 0x00                               ; 1163D
  db 0x00, 0x00                               ; 1163F
  db 0x00, 0x00                               ; 11641
  db 0x00, 0x00                               ; 11643
  db 0x00, 0x00                               ; 11645
  db 0x00, 0x00                               ; 11647
  db 0x00, 0x00                               ; 11649
  db 0x00, 0x00                               ; 1164B
  db 0x00, 0x00                               ; 1164D
  db 0x00, 0x00                               ; 1164F
  db 0x00, 0x00                               ; 11651
  db 0x00, 0x00                               ; 11653
  db 0x00, 0x00                               ; 11655
  db 0x00, 0x00                               ; 11657
  db 0x00, 0x00                               ; 11659
  db 0x00, 0x00                               ; 1165B
  db 0x00, 0x00                               ; 1165D
  db 0x00, 0x00                               ; 1165F
  db 0x00, 0x00                               ; 11661
  add [bp + si], bh                            ; 11663  0x00, 0x3A
  add [bx + si], ax                            ; 11665  0x01, 0x00
  db 0x00, 0x00                               ; 11667
  db 0x00, 0x00                               ; 11669
  db 0x00, 0x00                               ; 1166B
  db 0x00, 0x00                               ; 1166D
  db 0x00, 0x00                               ; 1166F
  db 0x00, 0x00                               ; 11671
  db 0x00, 0x00                               ; 11673
  db 0x00, 0x00                               ; 11675
  db 0x00, 0x00                               ; 11677
  db 0x00, 0x00                               ; 11679
  db 0x00, 0x00                               ; 1167B
  db 0x00, 0x00                               ; 1167D
  add [di - 0x60ef], bh                        ; 1167F  0x00, 0xBD, 0x11, 0x9F
  adc [bx - 0x60ef], bx                        ; 11683  0x11, 0x9F, 0x11, 0x9F
  adc [bx + si], ax                            ; 11687  0x11, 0x00
  db 0x00, 0x00                               ; 11689
  db 0x00, 0x00                               ; 1168B
  db 0x00, 0x00                               ; 1168D
  add [bx + di], al                            ; 1168F  0x00, 0x01
  db 0x00, 0x00                               ; 11691
  db 0x00, 0x00                               ; 11693
  db 0x00, 0x00                               ; 11695
  db 0xCC                                     ; 11697  int3
  db 0xCC                                     ; 11698  int3
  db 0xCC                                     ; 11699  int3
  db 0xCC                                     ; 1169A  int3
  db 0xCC                                     ; 1169B  int3
  db 0xCC                                     ; 1169C  int3
  db 0xCC                                     ; 1169D  int3
  db 0xCC                                     ; 1169E  int3
  db 0xCC                                     ; 1169F  int3
  db 0xCC                                     ; 116A0  int3
  db 0xCC                                     ; 116A1  int3
  db 0xCC                                     ; 116A2  int3
  db 0xCC                                     ; 116A3  int3
  db 0xCC                                     ; 116A4  int3
  db 0xCC                                     ; 116A5  int3
  db 0xCC                                     ; 116A6  int3
  db 0xCC                                     ; 116A7  int3
  db 0xCC                                     ; 116A8  int3
  db 0xCC                                     ; 116A9  int3
  db 0xCC                                     ; 116AA  int3
  db 0xCC                                     ; 116AB  int3
  db 0xCC                                     ; 116AC  int3
  db 0xCC                                     ; 116AD  int3
  db 0xCC                                     ; 116AE  int3
  db 0xCC                                     ; 116AF  int3
  db 0xCC                                     ; 116B0  int3
  db 0xCC                                     ; 116B1  int3
  db 0xCC                                     ; 116B2  int3
  db 0xCC                                     ; 116B3  int3
  db 0xCC                                     ; 116B4  int3
  db 0xCC                                     ; 116B5  int3
  db 0xCC                                     ; 116B6  int3
  db 0xCC                                     ; 116B7  int3
  db 0xCC                                     ; 116B8  int3
  db 0xCC                                     ; 116B9  int3
  db 0xCC                                     ; 116BA  int3
  db 0xCC                                     ; 116BB  int3
  db 0xCC                                     ; 116BC  int3
  db 0xCC                                     ; 116BD  int3
  db 0xCC                                     ; 116BE  int3
  db 0xCC                                     ; 116BF  int3
  db 0xCC                                     ; 116C0  int3
  db 0xCC                                     ; 116C1  int3
  db 0xCC                                     ; 116C2  int3
  db 0xCC                                     ; 116C3  int3
  db 0xCC                                     ; 116C4  int3
  db 0xCC                                     ; 116C5  int3
  db 0xCC                                     ; 116C6  int3
  db 0xCC                                     ; 116C7  int3
  db 0xCC                                     ; 116C8  int3
  db 0xCC                                     ; 116C9  int3
  db 0xCC                                     ; 116CA  int3
  db 0xCC                                     ; 116CB  int3
  db 0xCC                                     ; 116CC  int3
  db 0xCC                                     ; 116CD  int3
  db 0xCC                                     ; 116CE  int3
  db 0xCC                                     ; 116CF  int3
  db 0xCC                                     ; 116D0  int3
  db 0xCC                                     ; 116D1  int3
  db 0xCC                                     ; 116D2  int3
  db 0xCC                                     ; 116D3  int3
  db 0xCC                                     ; 116D4  int3
  db 0xCC                                     ; 116D5  int3
  db 0xCC                                     ; 116D6  int3
  db 0xCC                                     ; 116D7  int3
  db 0xCC                                     ; 116D8  int3
  db 0xCC                                     ; 116D9  int3
  db 0xCC                                     ; 116DA  int3
  db 0xCC                                     ; 116DB  int3
  db 0xCC                                     ; 116DC  int3
  db 0xCC                                     ; 116DD  int3
  db 0xCC                                     ; 116DE  int3
  db 0xCC                                     ; 116DF  int3
  db 0xCC                                     ; 116E0  int3
  db 0xCC                                     ; 116E1  int3
  db 0xCC                                     ; 116E2  int3
  db 0xCC                                     ; 116E3  int3
  db 0xCC                                     ; 116E4  int3
  db 0xCC                                     ; 116E5  int3
  db 0xCC                                     ; 116E6  int3
  db 0xCC                                     ; 116E7  int3
  db 0xCC                                     ; 116E8  int3
  db 0xCC                                     ; 116E9  int3
  db 0xCC                                     ; 116EA  int3
  db 0xCC                                     ; 116EB  int3
  db 0xCC                                     ; 116EC  int3
  db 0xCC                                     ; 116ED  int3
  db 0xCC                                     ; 116EE  int3
  db 0xCC                                     ; 116EF  int3
  db 0xCC                                     ; 116F0  int3
  db 0xCC                                     ; 116F1  int3
  db 0xCC                                     ; 116F2  int3
  db 0xCC                                     ; 116F3  int3
  db 0xCC                                     ; 116F4  int3
  db 0xCC                                     ; 116F5  int3
  db 0xCC                                     ; 116F6  int3
  db 0xCC                                     ; 116F7  int3
  db 0xCC                                     ; 116F8  int3
  db 0xCC                                     ; 116F9  int3
  db 0xCC                                     ; 116FA  int3
  db 0xCC                                     ; 116FB  int3
  db 0xCC                                     ; 116FC  int3
  db 0xCC                                     ; 116FD  int3
  db 0xCC                                     ; 116FE  int3
  db 0xCC                                     ; 116FF  int3
  db 0xCC                                     ; 11700  int3
  db 0xCC                                     ; 11701  int3
  db 0xCC                                     ; 11702  int3
  db 0xCC                                     ; 11703  int3
  db 0xCC                                     ; 11704  int3
  db 0xCC                                     ; 11705  int3
  db 0xCC                                     ; 11706  int3
  db 0xCC                                     ; 11707  int3
  db 0xCC                                     ; 11708  int3
  db 0xCC                                     ; 11709  int3
  db 0xCC                                     ; 1170A  int3
  db 0xCC                                     ; 1170B  int3
  db 0xCC                                     ; 1170C  int3
  db 0xCC                                     ; 1170D  int3
  db 0xCC                                     ; 1170E  int3
  db 0xCC                                     ; 1170F  int3
  db 0xCC                                     ; 11710  int3
  db 0xCC                                     ; 11711  int3
  db 0xCC                                     ; 11712  int3
  db 0xCC                                     ; 11713  int3
  db 0xCC                                     ; 11714  int3
  db 0xCC                                     ; 11715  int3
  db 0xCC                                     ; 11716  int3
  db 0xCC                                     ; 11717  int3
  db 0xCC                                     ; 11718  int3
  db 0xCC                                     ; 11719  int3
  db 0xCC                                     ; 1171A  int3
  db 0xCC                                     ; 1171B  int3
  db 0xCC                                     ; 1171C  int3
  db 0xCC                                     ; 1171D  int3
  db 0xCC                                     ; 1171E  int3
  db 0xCC                                     ; 1171F  int3
  db 0xCC                                     ; 11720  int3
  db 0xCC                                     ; 11721  int3
  db 0xCC                                     ; 11722  int3
  db 0xCC                                     ; 11723  int3
  db 0xCC                                     ; 11724  int3
  db 0xCC                                     ; 11725  int3
  db 0xCC                                     ; 11726  int3
  db 0xCC                                     ; 11727  int3
  db 0xCC                                     ; 11728  int3
  db 0xCC                                     ; 11729  int3
  add [bx + di], cl                            ; 1172A  0x00, 0x09
  db 0x00, 0x00                               ; 1172C
  db 0x00, 0x00                               ; 1172E
  db 0x00, 0x00                               ; 11730
  db 0x00, 0x00                               ; 11732
  db 0x00, 0x00                               ; 11734
  db 0x00, 0x00                               ; 11736
  db 0x00, 0x00                               ; 11738
  db 0x00, 0x00                               ; 1173A
  db 0x00, 0x00                               ; 1173C
  db 0x00, 0x00                               ; 1173E
  db 0x00, 0x00                               ; 11740
  db 0x00, 0x00                               ; 11742
  db 0x00, 0x00                               ; 11744
  db 0x00, 0x00                               ; 11746
  db 0x00, 0x00                               ; 11748
  db 0x00, 0x00                               ; 1174A
  db 0x00, 0x00                               ; 1174C
  db 0x00, 0x00                               ; 1174E
  db 0x00, 0x00                               ; 11750
  db 0x00, 0x00                               ; 11752
  db 0x00, 0x00                               ; 11754
  db 0x00, 0x00                               ; 11756
  db 0x00, 0x00                               ; 11758
  db 0x00, 0x00                               ; 1175A
  db 0x00, 0x00                               ; 1175C
  db 0x00, 0x00                               ; 1175E
  db 0x00, 0x00                               ; 11760
  db 0x00, 0x00                               ; 11762
  db 0x00, 0x00                               ; 11764
  db 0x00, 0x00                               ; 11766
  db 0x00, 0x00                               ; 11768
  db 0x00, 0x00                               ; 1176A
  db 0x00, 0x00                               ; 1176C
  db 0x00, 0x00                               ; 1176E
  db 0x00, 0x00                               ; 11770
  db 0x00, 0x00                               ; 11772
  db 0x00, 0x00                               ; 11774
  db 0x00, 0x00                               ; 11776
  db 0x00, 0x00                               ; 11778
  db 0x00, 0x00                               ; 1177A
  db 0x00, 0x00                               ; 1177C
  db 0x00, 0x00                               ; 1177E
  db 0x00, 0x00                               ; 11780
  db 0x00, 0x00                               ; 11782
  inc cx                                       ; 11784  0x41
  inc dx                                       ; 11785  0x42
  inc bx                                       ; 11786  0x43
  inc sp                                       ; 11787  0x44
  inc bp                                       ; 11788  0x45
  inc si                                       ; 11789  0x46
  inc di                                       ; 1178A  0x47
  dec ax                                       ; 1178B  0x48
  dec cx                                       ; 1178C  0x49
  dec dx                                       ; 1178D  0x4A
  dec bx                                       ; 1178E  0x4B
  dec sp                                       ; 1178F  0x4C
  dec bp                                       ; 11790  0x4D
  dec si                                       ; 11791  0x4E
  dec di                                       ; 11792  0x4F
  push ax                                      ; 11793  0x50
  and [bx + si], al                            ; 11794  0x20, 0x00
  db 0xFF                                                         ; 11796  .
  dec word [di]                                ; 11797  0xFF, 0x0D
  or cl, [bx + 0x70]                           ; 11799  0x0A, 0x4F, 0x70
  db 0x65, 0x6E                               ; 1179C  outsb
  and [bp + 0x69], ah                          ; 1179E  0x20, 0x66, 0x69
  db 0x6C                                     ; 117A1  insb
  and [gs:bx + 0x6e], ch                       ; 117A2  0x65, 0x20, 0x6F, 0x6E
  and [si + 0x72], ah                          ; 117A6  0x20, 0x64, 0x72
  db 0x69, 0x76, 0x65, 0x28, 0x73             ; 117A9  imul si, word [bp + 0x65], 0x7328
  sub [bx + si], sp                            ; 117AE  0x29, 0x20
  add [si], ch                                 ; 117B0  0x00, 0x2C
  or ax, 0xd0a                                 ; 117B2  0x0D, 0x0A, 0x0D
  or dl, [bx + si + 0x72]                      ; 117B5  0x0A, 0x50, 0x72
  db 0x69, 0x6E, 0x74, 0x65, 0x72             ; 117B8  imul bp, word [bp + 0x74], 0x7265
  and [bp + si + 0x75], al                     ; 117BD  0x20, 0x42, 0x75
  jae loc_1183B                                ; 117C0  0x73, 0x79
  or ax, strict word 0xa                      ; 117C2  0D 0A 00
  db 0x00, 0x00                               ; 117C5
  db 0x00, 0x00                               ; 117C7
  db 0x00, 0x00                               ; 117C9
  db 0x00, 0x00                               ; 117CB
  db 0x00, 0x00                               ; 117CD
  db 0x00                                      ; 117CF

; ===========================================================================
; DEL 2: PIN CODE SEGMENT — starter ved 0x117D0
; ===========================================================================
sub_117D0:                                     ; 117D0
  push bp                                      ; 117D0  0x55
  db 0x8B, 0xEC                                ; 117D1  mov bp, sp (d=1)
  mov dx, [bp + 4]                             ; 117D3  0x8B, 0x56, 0x04
  mov cx, [bp + 6]                             ; 117D6  0x8B, 0x4E, 0x06
  int 0xe0                                     ; 117D9  0xCD, 0xE0
  pop bp                                       ; 117DB  0x5D
  ret 4                                        ; 117DC  0xC2, 0x04, 0x00

sub_117DF:                                     ; 117DF
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

sub_11800:                                     ; 11800
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

sub_11822:                                     ; 11822
  push bp                                      ; 11822  0x55
  db 0x8B, 0xEC                                ; 11823  mov bp, sp
  mov ax, 1                                    ; 11825  0xB8, 0x01, 0x00
  push ax                                      ; 11828  0x50
  mov ax, 0                                    ; 11829  0xB8, 0x00, 0x00
  push ax                                      ; 1182C  0x50
  les bx, [0x158]                              ; 1182D  0xC4, 0x1E, 0x58, 0x01
  mov al, [es:bx + 0xa]                        ; 11831  0x26, 0x8A, 0x47, 0x0A
  mov ah, 0                                    ; 11835  0xB4, 0x00
  push ax                                      ; 11837  0x50
  call sub_11800                               ; 11838  0xE8, 0xC5, 0xFF

loc_1183B:                                     ; 1183B
  mov [0x17e], ax                              ; 1183B  0xA3, 0x7E, 0x01
  pop bp                                       ; 1183E  0x5D
  ret                                          ; 1183F  0xC3

sub_11840:                                     ; 11840
  push bp                                      ; 11840  0x55
  db 0x8B, 0xEC                                ; 11841  mov bp, sp
  mov ax, 0x1e                                 ; 11843  0xB8, 0x1E, 0x00
  push ax                                      ; 11846  0x50
  mov ax, 0x100                                ; 11847  0xB8, 0x00, 0x01
  push ax                                      ; 1184A  0x50
  les bx, [0x158]                              ; 1184B  0xC4, 0x1E, 0x58, 0x01
  mov al, [es:bx + 0xb]                        ; 1184F  0x26, 0x8A, 0x47, 0x0B
  mov ah, 0                                    ; 11853  0xB4, 0x00
  push ax                                      ; 11855  0x50
  call sub_11800                               ; 11856  0xE8, 0xA7, 0xFF
  mov [0x166], ax                              ; 11859  0xA3, 0x66, 0x01
  pop bp                                       ; 1185C  0x5D
  ret                                          ; 1185D  0xC3

sub_1185E:                                     ; 1185E
  push bp                                      ; 1185E  0x55
  db 0x8B, 0xEC                                ; 1185F  mov bp, sp
  mov byte [0x192], 0                          ; 11861  0xC6, 0x06, 0x92, 0x01, 0x00

loc_11866:                                     ; 11866
  mov al, [0x192]                              ; 11866  0xA0, 0x92, 0x01
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
  les bx, [0x158]                              ; 11897  0xC4, 0x1E, 0x58, 0x01
  mov al, [es:bx + 0xb]                        ; 1189B  0x26, 0x8A, 0x47, 0x0B
  mov ah, 0                                    ; 1189F  0xB4, 0x00
  push ax                                      ; 118A1  0x50
  call sub_11800                               ; 118A2  0xE8, 0x5B, 0xFF
  inc byte [0x192]                             ; 118A5  0xFE, 0x06, 0x92, 0x01
  jmp short loc_11866                          ; 118A9  0xEB, 0xBB

loc_118AB:                                     ; 118AB
  pop bp                                       ; 118AB  0x5D
  ret 8                                        ; 118AC  0xC2, 0x08, 0x00

sub_118AF:                                     ; 118AF
  push bp                                      ; 118AF  0x55
  db 0x8B, 0xEC                                ; 118B0  mov bp, sp
  mov ax, [bp + 4]                             ; 118B2  0x8B, 0x46, 0x04
  mov [0x16a], ax                              ; 118B5  0xA3, 0x6A, 0x01
  mov al, 0x89                                 ; 118B8  0xB0, 0x89
  push ax                                      ; 118BA  0x50
  mov ax, 0x168                                ; 118BB  0xB8, 0x68, 0x01
  push ax                                      ; 118BE  0x50
  db 0xE8, 0x0E, 0xFF                          ; 118BF  call 0x117d0
  pop bp                                       ; 118C2  0x5D
  ret 2                                        ; 118C3  0xC2, 0x02, 0x00

sub_118C6:                                     ; 118C6
  push bp                                      ; 118C6  0x55
  db 0x8B, 0xEC                                ; 118C7  mov bp, sp
  mov ax, [bp + 4]                             ; 118C9  0x8B, 0x46, 0x04
  mov [0x16a], ax                              ; 118CC  0xA3, 0x6A, 0x01
  mov al, 0x8b                                 ; 118CF  0xB0, 0x8B
  push ax                                      ; 118D1  0x50
  mov ax, 0x168                                ; 118D2  0xB8, 0x68, 0x01
  push ax                                      ; 118D5  0x50
  db 0xE8, 0xF7, 0xFE                          ; 118D6  call 0x117d0
  pop bp                                       ; 118D9  0x5D
  ret 2                                        ; 118DA  0xC2, 0x02, 0x00

sub_118DD:                                     ; 118DD
  push bp                                      ; 118DD  0x55
  db 0x8B, 0xEC                                ; 118DE  mov bp, sp
  mov ax, 0x212                                ; 118E0  0xB8, 0x12, 0x02
  push ax                                      ; 118E3  0x50
  push word [bp + 4]                           ; 118E4  0xFF, 0x76, 0x04
  mov ax, 9                                    ; 118E7  0xB8, 0x09, 0x00
  push ax                                      ; 118EA  0x50
  call sub_117DF                               ; 118EB  0xE8, 0xF1, 0xFE
  pop bp                                       ; 118EE  0x5D
  ret 2                                        ; 118EF  0xC2, 0x02, 0x00

sub_118F2:                                     ; 118F2
  push bp                                      ; 118F2  0x55
  db 0x8B, 0xEC                                ; 118F3  mov bp, sp
  mov ax, 0x213                                ; 118F5  0xB8, 0x13, 0x02
  push ax                                      ; 118F8  0x50
  push word [bp + 4]                           ; 118F9  0xFF, 0x76, 0x04
  mov ax, 0                                    ; 118FC  0xB8, 0x00, 0x00
  push ax                                      ; 118FF  0x50
  call sub_117DF                               ; 11900  0xE8, 0xDC, 0xFE
  pop bp                                       ; 11903  0x5D
  ret 2                                        ; 11904  0xC2, 0x02, 0x00

sub_11907:                                     ; 11907
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
  call sub_118DD                               ; 1191C  0xE8, 0xBE, 0xFF
  jmp short loc_1190B                          ; 1191F  0xEB, 0xEA

loc_11921:                                     ; 11921
  les bx, [bp + 4]                             ; 11921  0xC4, 0x5E, 0x04
  or byte [es:bx + 4], 8                       ; 11924  0x26, 0x80, 0x4F, 0x04, 0x08
  sti                                          ; 11929  0xFB
  pop bp                                       ; 1192A  0x5D
  ret 4                                        ; 1192B  0xC2, 0x04, 0x00

sub_1192E:                                     ; 1192E
  push bp                                      ; 1192E  0x55
  db 0x8B, 0xEC                                ; 1192F  mov bp, sp
  les bx, [bp + 4]                             ; 11931  0xC4, 0x5E, 0x04
  and byte [es:bx + 4], 0xf7                   ; 11934  0x26, 0x80, 0x67, 0x04, 0xF7
  lea ax, [bx + 0x22]                          ; 11939  0x8D, 0x47, 0x22
  push ax                                      ; 1193C  0x50
  call sub_118F2                               ; 1193D  0xE8, 0xB2, 0xFF
  pop bp                                       ; 11940  0x5D
  ret 4                                        ; 11941  0xC2, 0x04, 0x00

sub_11944:                                     ; 11944
  push bp                                      ; 11944  0x55
  db 0x8B, 0xEC                                ; 11945  mov bp, sp
  les bx, [bp + 4]                             ; 11947  0xC4, 0x5E, 0x04
  mov ax, [es:bx + 0xe]                        ; 1194A  0x26, 0x8B, 0x47, 0x0E
  and ax, strict word 1                        ; 1194E  25 01 00
  cmp ax, 0                                    ; 11951  0x83, 0xF8, 0x00
  je loc_11994                                 ; 11954  0x74, 0x3E
  les bx, [bp + 4]                             ; 11956  0xC4, 0x5E, 0x04
  mov ax, [es:bx + 0x14]                       ; 11959  0x26, 0x8B, 0x47, 0x14
  mov [0x16a], ax                              ; 1195D  0xA3, 0x6A, 0x01
  mov word [0x16e], 0x1a6                      ; 11960  0xC7, 0x06, 0x6E, 0x01, 0xA6, 0x01
  mov al, 0x8c                                 ; 11966  0xB0, 0x8C
  push ax                                      ; 11968  0x50
  mov ax, 0x168                                ; 11969  0xB8, 0x68, 0x01
  push ax                                      ; 1196C  0x50
  db 0xE8, 0x60, 0xFE                          ; 1196D  call 0x117d0
  les bx, [bp + 4]                             ; 11970  0xC4, 0x5E, 0x04
  mov ax, [es:bx + 0x14]                       ; 11973  0x26, 0x8B, 0x47, 0x14
  mov [0x16a], ax                              ; 11977  0xA3, 0x6A, 0x01
  mov word [0x16e], 0x1a6                      ; 1197A  0xC7, 0x06, 0x6E, 0x01, 0xA6, 0x01
  mov al, 0x8c                                 ; 11980  0xB0, 0x8C
  push ax                                      ; 11982  0x50
  mov ax, 0x168                                ; 11983  0xB8, 0x68, 0x01
  push ax                                      ; 11986  0x50
  db 0xE8, 0x46, 0xFE                          ; 11987  call 0x117d0
  les bx, [bp + 4]                             ; 1198A  0xC4, 0x5E, 0x04
  lea ax, [bx + 0x26]                          ; 1198D  0x8D, 0x47, 0x26
  push ax                                      ; 11990  0x50
  call sub_118F2                               ; 11991  0xE8, 0x5E, 0xFF

loc_11994:                                     ; 11994
  pop bp                                       ; 11994  0x5D
  ret 4                                        ; 11995  0xC2, 0x04, 0x00

sub_11998:                                     ; 11998
  push bp                                      ; 11998  0x55
  db 0x8B, 0xEC                                ; 11999  mov bp, sp
  les bx, [0x158]                              ; 1199B  0xC4, 0x1E, 0x58, 0x01
  mov ax, [es:bx + 0x12]                       ; 1199F  0x26, 0x8B, 0x47, 0x12
  mov [0x16a], ax                              ; 119A3  0xA3, 0x6A, 0x01
  lea ax, [bp + 4]                             ; 119A6  0x8D, 0x46, 0x04
  mov [0x16e], ax                              ; 119A9  0xA3, 0x6E, 0x01
  mov al, 0x8c                                 ; 119AC  0xB0, 0x8C
  push ax                                      ; 119AE  0x50
  mov ax, 0x168                                ; 119AF  0xB8, 0x68, 0x01
  push ax                                      ; 119B2  0x50
  db 0xE8, 0x1A, 0xFE                          ; 119B3  call 0x117d0
  cmp ax, -1                                   ; 119B6  0x83, 0xF8, 0xFF
  jne loc_119E3                                ; 119B9  0x75, 0x28
  les bx, [0x158]                              ; 119BB  0xC4, 0x1E, 0x58, 0x01
  push es                                      ; 119BF  0x06
  push bx                                      ; 119C0  0x53
  call sub_11907                               ; 119C1  0xE8, 0x43, 0xFF
  mov ax, 2                                    ; 119C4  0xB8, 0x02, 0x00
  push ax                                      ; 119C7  0x50
  mov ax, 7                                    ; 119C8  0xB8, 0x07, 0x00
  push ax                                      ; 119CB  0x50
  les bx, [0x158]                              ; 119CC  0xC4, 0x1E, 0x58, 0x01
  mov al, [es:bx + 0xb]                        ; 119D0  0x26, 0x8A, 0x47, 0x0B
  mov ah, 0                                    ; 119D4  0xB4, 0x00
  push ax                                      ; 119D6  0x50
  call sub_11800                               ; 119D7  0xE8, 0x26, 0xFE
  les bx, [0x158]                              ; 119DA  0xC4, 0x1E, 0x58, 0x01
  push es                                      ; 119DE  0x06
  push bx                                      ; 119DF  0x53
  call sub_1192E                               ; 119E0  0xE8, 0x4B, 0xFF

loc_119E3:                                     ; 119E3
  pop bp                                       ; 119E3  0x5D
  ret 2                                        ; 119E4  0xC2, 0x02, 0x00

sub_119E7:                                     ; 119E7
  push bp                                      ; 119E7  0x55
  db 0x8B, 0xEC                                ; 119E8  mov bp, sp
  les ax, [0x158]                              ; 119EA  0xC4, 0x06, 0x58, 0x01
  mov [0x15c], ax                              ; 119EE  0xA3, 0x5C, 0x01
  mov [0x15e], es                              ; 119F1  0x8C, 0x06, 0x5E, 0x01
  mov al, [bp + 4]                             ; 119F5  0x8A, 0x46, 0x04
  mov ah, 0                                    ; 119F8  0xB4, 0x00
  mov cx, 0x2c                                 ; 119FA  0xB9, 0x2C, 0x00
  db 0xF7, 0xE1                                ; 119FD  mul cx
  les bx, [0x140]                              ; 119FF  0xC4, 0x1E, 0x40, 0x01
  add ax, [es:bx + 0x54]                       ; 11A03  0x26, 0x03, 0x47, 0x54
  mov [0x158], ax                              ; 11A07  0xA3, 0x58, 0x01
  pop bp                                       ; 11A0A  0x5D
  ret 2                                        ; 11A0B  0xC2, 0x02, 0x00

sub_11A0E:                                     ; 11A0E
  push bp                                      ; 11A0E  0x55
  db 0x8B, 0xEC                                ; 11A0F  mov bp, sp
  mov al, [0x17e]                              ; 11A11  0xA0, 0x7E, 0x01
  cmp al, [0x18e]                              ; 11A14  0x3A, 0x06, 0x8E, 0x01
  jb loc_11A1C                                 ; 11A18  0x72, 0x02
  pop bp                                       ; 11A1A  0x5D
  ret                                          ; 11A1B  0xC3

loc_11A1C:                                     ; 11A1C
  les bx, [0x158]                              ; 11A1C  0xC4, 0x1E, 0x58, 0x01
  mov ax, [es:bx + 0xe]                        ; 11A20  0x26, 0x8B, 0x47, 0x0E
  and ax, strict word 8                        ; 11A24  25 08 00
  cmp ax, 0                                    ; 11A27  0x83, 0xF8, 0x00
  je loc_11A2E                                 ; 11A2A  0x74, 0x02
  pop bp                                       ; 11A2C  0x5D
  ret                                          ; 11A2D  0xC3

loc_11A2E:                                     ; 11A2E
  call sub_11840                               ; 11A2E  0xE8, 0x0F, 0xFE
  mov ax, [0x166]                              ; 11A31  0xA1, 0x66, 0x01
  and ax, 0xff                                 ; 11A34  0x25, 0xFF, 0x00
  cmp ax, 0xf                                  ; 11A37  0x83, 0xF8, 0x0F
  jbe loc_11A3E                                ; 11A3A  0x76, 0x02
  pop bp                                       ; 11A3C  0x5D
  ret                                          ; 11A3D  0xC3

loc_11A3E:                                     ; 11A3E
  mov al, [0x18f]                              ; 11A3E  0xA0, 0x8F, 0x01
  add [0x17e], al                              ; 11A41  0x00, 0x06, 0x7E, 0x01
  mov al, [0x17e]                              ; 11A45  0xA0, 0x7E, 0x01
  les bx, [0x158]                              ; 11A48  0xC4, 0x1E, 0x58, 0x01
  cmp al, [es:bx + 0xb]                        ; 11A4C  0x26, 0x3A, 0x47, 0x0B
  jne loc_11A54                                ; 11A50  0x75, 0x02
  pop bp                                       ; 11A52  0x5D
  ret                                          ; 11A53  0xC3

loc_11A54:                                     ; 11A54
  mov al, [0x17e]                              ; 11A54  0xA0, 0x7E, 0x01
  mov [0x191], al                              ; 11A57  0xA2, 0x91, 0x01
  push word [0x17e]                            ; 11A5A  0xFF, 0x36, 0x7E, 0x01
  call sub_119E7                               ; 11A5E  0xE8, 0x86, 0xFF
  les bx, [0x15c]                              ; 11A61  0xC4, 0x1E, 0x5C, 0x01
  push word [es:bx + 0x16]                     ; 11A65  0x26, 0xFF, 0x77, 0x16
  call sub_118AF                               ; 11A69  0xE8, 0x43, 0xFE
  les bx, [0x15c]                              ; 11A6C  0xC4, 0x1E, 0x5C, 0x01
  push es                                      ; 11A70  0x06
  push bx                                      ; 11A71  0x53
  call sub_11907                               ; 11A72  0xE8, 0x92, 0xFE
  les bx, [0x15c]                              ; 11A75  0xC4, 0x1E, 0x5C, 0x01
  mov ax, [es:bx]                              ; 11A79  0x26, 0x8B, 0x07
  mov [0x144], ax                              ; 11A7C  0xA3, 0x44, 0x01
  les si, [0x144]                              ; 11A7F  0xC4, 0x36, 0x44, 0x01
  mov ax, [es:si + 0x10]                       ; 11A83  0x26, 0x8B, 0x44, 0x10
  mov [0x14a], ax                              ; 11A87  0xA3, 0x4A, 0x01
  mov word [0x148], 0                          ; 11A8A  0xC7, 0x06, 0x48, 0x01, 0x00, 0x00
  mov ax, [es:si + 0x26]                       ; 11A90  0x26, 0x8B, 0x44, 0x26
  and ax, strict word 1                        ; 11A94  25 01 00
  rcr al, 1                                    ; 11A97  0xD0, 0xD8
  jae loc_11AA5                                ; 11A99  0x73, 0x0A
  mov es, [0x15e]                              ; 11A9B  0x8E, 0x06, 0x5E, 0x01
  db 0x26, 0x81, 0x4F, 0x0E, 0x10, 0x00        ; 11A9F  or word [es:bx + 0xe], 0x10

loc_11AA5:                                     ; 11AA5
  mov al, 0x9c                                 ; 11AA5  0xB0, 0x9C
  push ax                                      ; 11AA7  0x50
  mov ax, 0                                    ; 11AA8  0xB8, 0x00, 0x00
  push ax                                      ; 11AAB  0x50
  db 0xE8, 0x21, 0xFD                          ; 11AAC  call 0x117d0
  mov [0x144], bx                              ; 11AAF  0x89, 0x1E, 0x44, 0x01
  mov [0x146], es                              ; 11AB3  0x8C, 0x06, 0x46, 0x01
  les bx, [0x15c]                              ; 11AB7  0xC4, 0x1E, 0x5C, 0x01
  mov ax, [es:bx + 0xe]                        ; 11ABB  0x26, 0x8B, 0x47, 0x0E
  or ax, strict word 2                         ; 11ABF  0D 02 00
  mov [es:bx + 0xe], ax                        ; 11AC2  0x26, 0x89, 0x47, 0x0E
  and ax, strict word 4                        ; 11AC6  25 04 00
  cmp ax, 0                                    ; 11AC9  0x83, 0xF8, 0x00
  je loc_11AD4                                 ; 11ACC  0x74, 0x06
  db 0x26, 0x81, 0x67, 0x0E, 0xFB, 0xFF        ; 11ACE  and word [es:bx + 0xe], 0xfffb

loc_11AD4:                                     ; 11AD4
  les bx, [0x158]                              ; 11AD4  0xC4, 0x1E, 0x58, 0x01
  push word [es:bx + 0x16]                     ; 11AD8  0x26, 0xFF, 0x77, 0x16
  call sub_118AF                               ; 11ADC  0xE8, 0xD0, 0xFD
  les bx, [0x158]                              ; 11ADF  0xC4, 0x1E, 0x58, 0x01
  push es                                      ; 11AE3  0x06
  push bx                                      ; 11AE4  0x53
  call sub_11907                               ; 11AE5  0xE8, 0x1F, 0xFE
  les bx, [0x158]                              ; 11AE8  0xC4, 0x1E, 0x58, 0x01
  mov al, [es:bx + 0xa]                        ; 11AEC  0x26, 0x8A, 0x47, 0x0A
  mov ah, 0                                    ; 11AF0  0xB4, 0x00
  mov [0x164], ax                              ; 11AF2  0xA3, 0x64, 0x01
  mov cl, 8                                    ; 11AF5  0xB1, 0x08
  shl ax, cl                                   ; 11AF7  0xD3, 0xE0
  mov cl, [es:bx + 0xb]                        ; 11AF9  0x26, 0x8A, 0x4F, 0x0B
  mov ch, 0                                    ; 11AFD  0xB5, 0x00
  db 0x03, 0xC1                                ; 11AFF  add ax, cx
  mov [0x164], ax                              ; 11B01  0xA3, 0x64, 0x01
  mov cx, 7                                    ; 11B04  0xB9, 0x07, 0x00
  push cx                                      ; 11B07  0x51
  mov cx, 0                                    ; 11B08  0xB9, 0x00, 0x00
  push cx                                      ; 11B0B  0x51
  push ax                                      ; 11B0C  0x50
  call sub_11800                               ; 11B0D  0xE8, 0xF0, 0xFC
  les ax, [0x15c]                              ; 11B10  0xC4, 0x06, 0x5C, 0x01
  push es                                      ; 11B14  0x06
  push ax                                      ; 11B15  0x50
  call sub_1192E                               ; 11B16  0xE8, 0x15, 0xFE
  les bx, [0x15c]                              ; 11B19  0xC4, 0x1E, 0x5C, 0x01
  push word [es:bx + 0x16]                     ; 11B1D  0x26, 0xFF, 0x77, 0x16
  call sub_118C6                               ; 11B21  0xE8, 0xA2, 0xFD
  les bx, [0x15c]                              ; 11B24  0xC4, 0x1E, 0x5C, 0x01
  mov ax, [es:bx + 0xe]                        ; 11B28  0x26, 0x8B, 0x47, 0x0E
  and ax, strict word 1                        ; 11B2C  25 01 00
  cmp ax, 0                                    ; 11B2F  0x83, 0xF8, 0x00
  je loc_11B39                                 ; 11B32  0x74, 0x05
  push es                                      ; 11B34  0x06
  push bx                                      ; 11B35  0x53
  call sub_11944                               ; 11B36  0xE8, 0x0B, 0xFE

loc_11B39:                                     ; 11B39
  les bx, [0x158]                              ; 11B39  0xC4, 0x1E, 0x58, 0x01
  mov ax, [es:bx + 0xe]                        ; 11B3D  0x26, 0x8B, 0x47, 0x0E
  and ax, strict word 0x10                     ; 11B41  25 10 00
  cmp ax, 0                                    ; 11B44  0x83, 0xF8, 0x00
  je loc_11BC1                                 ; 11B47  0x74, 0x78
  cli                                          ; 11B49  0xFA
  db 0x26, 0x81, 0x67, 0x0E, 0xEF, 0xFF        ; 11B4A  and word [es:bx + 0xe], 0xffef
  mov ax, [es:bx]                              ; 11B50  0x26, 0x8B, 0x07
  mov [0x144], ax                              ; 11B53  0xA3, 0x44, 0x01
  mov word [0x180], 0xa8                       ; 11B56  0xC7, 0x06, 0x80, 0x01, 0xA8, 0x00

loc_11B5C:                                     ; 11B5C
  les bx, [0x180]                              ; 11B5C  0xC4, 0x1E, 0x80, 0x01
  mov ax, [es:bx]                              ; 11B60  0x26, 0x8B, 0x07
  push ax                                      ; 11B63  0x50
  cmp ax, [0x144]                              ; 11B64  0x3B, 0x06, 0x44, 0x01
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
  mov [0x180], cx                              ; 11B7E  0x89, 0x0E, 0x80, 0x01
  jmp short loc_11B5C                          ; 11B82  0xEB, 0xD8

loc_11B84:                                     ; 11B84
  les bx, [0x180]                              ; 11B84  0xC4, 0x1E, 0x80, 0x01
  mov ax, [es:bx]                              ; 11B88  0x26, 0x8B, 0x07
  cmp ax, [0x144]                              ; 11B8B  0x3B, 0x06, 0x44, 0x01
  jne loc_11BC0                                ; 11B8F  0x75, 0x2F
  push es                                      ; 11B91  0x06
  les si, [0x144]                              ; 11B92  0xC4, 0x36, 0x44, 0x01
  mov ax, [es:si]                              ; 11B96  0x26, 0x8B, 0x04
  pop es                                       ; 11B99  0x07
  mov [es:bx], ax                              ; 11B9A  0x26, 0x89, 0x07
  mov word [0x184], 0x6c                       ; 11B9D  0xC7, 0x06, 0x84, 0x01, 0x6C, 0x00
  les bx, [0x184]                              ; 11BA3  0xC4, 0x1E, 0x84, 0x01
  mov ax, [es:bx]                              ; 11BA7  0x26, 0x8B, 0x07
  mov es, [0x146]                              ; 11BAA  0x8E, 0x06, 0x46, 0x01
  mov [es:si], ax                              ; 11BAE  0x26, 0x89, 0x04
  mov byte [es:si + 4], 0                      ; 11BB1  0x26, 0xC6, 0x44, 0x04, 0x00
  mov ax, [0x144]                              ; 11BB6  0xA1, 0x44, 0x01
  mov es, [0x186]                              ; 11BB9  0x8E, 0x06, 0x86, 0x01
  mov [es:bx], ax                              ; 11BBD  0x26, 0x89, 0x07

loc_11BC0:                                     ; 11BC0
  sti                                          ; 11BC0  0xFB

loc_11BC1:                                     ; 11BC1
  les bx, [0x158]                              ; 11BC1  0xC4, 0x1E, 0x58, 0x01
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
  call sub_11944                               ; 11BE8  0xE8, 0x59, 0xFD

loc_11BEB:                                     ; 11BEB
  les ax, [0x158]                              ; 11BEB  0xC4, 0x06, 0x58, 0x01
  push es                                      ; 11BEF  0x06
  push ax                                      ; 11BF0  0x50
  call sub_1192E                               ; 11BF1  0xE8, 0x3A, 0xFD
  les bx, [0x158]                              ; 11BF4  0xC4, 0x1E, 0x58, 0x01
  push word [es:bx + 0x16]                     ; 11BF8  0x26, 0xFF, 0x77, 0x16
  call sub_118C6                               ; 11BFC  0xE8, 0xC7, 0xFC
  les bx, [0x158]                              ; 11BFF  0xC4, 0x1E, 0x58, 0x01
  mov ax, [es:bx + 0xe]                        ; 11C03  0x26, 0x8B, 0x47, 0x0E
  and ax, 0x80                                 ; 11C07  0x25, 0x80, 0x00
  cmp ax, 0                                    ; 11C0A  0x83, 0xF8, 0x00
  je loc_11C16                                 ; 11C0D  0x74, 0x07
  mov byte [0x193], 0xff                       ; 11C0F  0xC6, 0x06, 0x93, 0x01, 0xFF
  jmp short loc_11C1B                          ; 11C14  0xEB, 0x05

loc_11C16:                                     ; 11C16
  mov byte [0x193], 0                          ; 11C16  0xC6, 0x06, 0x93, 0x01, 0x00

loc_11C1B:                                     ; 11C1B
  mov ax, 8                                    ; 11C1B  0xB8, 0x08, 0x00
  push ax                                      ; 11C1E  0x50
  mov ax, 0                                    ; 11C1F  0xB8, 0x00, 0x00
  push ax                                      ; 11C22  0x50
  les bx, [0x158]                              ; 11C23  0xC4, 0x1E, 0x58, 0x01
  mov al, [es:bx + 0xa]                        ; 11C27  0x26, 0x8A, 0x47, 0x0A
  mov ah, 0                                    ; 11C2B  0xB4, 0x00
  push ax                                      ; 11C2D  0x50
  call sub_11800                               ; 11C2E  0xE8, 0xCF, 0xFB
  pop bp                                       ; 11C31  0x5D
  ret                                          ; 11C32  0xC3

sub_11C33:                                     ; 11C33
  push bp                                      ; 11C33  0x55
  db 0x8B, 0xEC                                ; 11C34  mov bp, sp
  les bx, [0x144]                              ; 11C36  0xC4, 0x1E, 0x44, 0x01
  mov ax, [es:bx + 0x22]                       ; 11C3A  0x26, 0x8B, 0x47, 0x22
  and ax, strict word 8                        ; 11C3E  25 08 00
  cmp ax, 0                                    ; 11C41  0x83, 0xF8, 0x00
  je loc_11C4F                                 ; 11C44  0x74, 0x09
  push word [0x17e]                            ; 11C46  0xFF, 0x36, 0x7E, 0x01
  call sub_11998                               ; 11C4A  0xE8, 0x4B, 0xFD
  pop bp                                       ; 11C4D  0x5D
  ret                                          ; 11C4E  0xC3

loc_11C4F:                                     ; 11C4F
  les bx, [0x158]                              ; 11C4F  0xC4, 0x1E, 0x58, 0x01
  push word [es:bx + 0x16]                     ; 11C53  0x26, 0xFF, 0x77, 0x16
  call sub_118AF                               ; 11C57  0xE8, 0x55, 0xFC
  les bx, [0x158]                              ; 11C5A  0xC4, 0x1E, 0x58, 0x01
  mov ax, [es:bx + 0xe]                        ; 11C5E  0x26, 0x8B, 0x47, 0x0E
  and ax, 0xfe7f                               ; 11C62  0x25, 0x7F, 0xFE
  mov [es:bx + 0xe], ax                        ; 11C65  0x26, 0x89, 0x47, 0x0E
  mov byte [0x193], 0                          ; 11C69  0xC6, 0x06, 0x93, 0x01, 0x00
  and ax, strict word 4                        ; 11C6E  25 04 00
  cmp ax, 0                                    ; 11C71  0x83, 0xF8, 0x00
  je loc_11C84                                 ; 11C74  0x74, 0x0E
  mov ax, [es:bx + 0xe]                        ; 11C76  0x26, 0x8B, 0x47, 0x0E
  and ax, strict word 0xfffb                   ; 11C7A  25 FB FF
  or ax, strict word 0x20                      ; 11C7D  0D 20 00
  mov [es:bx + 0xe], ax                        ; 11C80  0x26, 0x89, 0x47, 0x0E

loc_11C84:                                     ; 11C84
  les bx, [0x158]                              ; 11C84  0xC4, 0x1E, 0x58, 0x01
  mov ax, [es:bx + 0x12]                       ; 11C88  0x26, 0x8B, 0x47, 0x12
  mov [0x16a], ax                              ; 11C8C  0xA3, 0x6A, 0x01
  mov word [0x16e], 0x188                      ; 11C8F  0xC7, 0x06, 0x6E, 0x01, 0x88, 0x01

loc_11C95:                                     ; 11C95
  mov al, 0x8a                                 ; 11C95  0xB0, 0x8A
  push ax                                      ; 11C97  0x50
  mov ax, 0x168                                ; 11C98  0xB8, 0x68, 0x01
  push ax                                      ; 11C9B  0x50
  db 0xE8, 0x31, 0xFB                          ; 11C9C  call 0x117d0
  cmp al, 0xff                                 ; 11C9F  0x3C, 0xFF
  jne loc_11C95                                ; 11CA1  0x75, 0xF2
  les bx, [0x158]                              ; 11CA3  0xC4, 0x1E, 0x58, 0x01
  mov byte [es:bx + 7], 0                      ; 11CA7  0x26, 0xC6, 0x47, 0x07, 0x00
  push word [es:bx + 0x16]                     ; 11CAC  0x26, 0xFF, 0x77, 0x16
  call sub_118C6                               ; 11CB0  0xE8, 0x13, 0xFC
  les bx, [0x158]                              ; 11CB3  0xC4, 0x1E, 0x58, 0x01
  push es                                      ; 11CB7  0x06
  push bx                                      ; 11CB8  0x53
  call sub_11944                               ; 11CB9  0xE8, 0x88, 0xFC
  les bx, [0x158]                              ; 11CBC  0xC4, 0x1E, 0x58, 0x01
  lea ax, [bx + 0x24]                          ; 11CC0  0x8D, 0x47, 0x24
  push ax                                      ; 11CC3  0x50
  call sub_118F2                               ; 11CC4  0xE8, 0x2B, 0xFC
  les bx, [0x158]                              ; 11CC7  0xC4, 0x1E, 0x58, 0x01
  mov ax, [es:bx]                              ; 11CCB  0x26, 0x8B, 0x07
  mov [0x178], ax                              ; 11CCE  0xA3, 0x78, 0x01
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
  mov [0x18c], ax                              ; 11CE5  0xA3, 0x8C, 0x01
  mov word [0x18a], 1                          ; 11CE8  0xC7, 0x06, 0x8A, 0x01, 0x01, 0x00
  mov byte [0x1a5], 0                          ; 11CEE  0xC6, 0x06, 0xA5, 0x01, 0x00
  mov word [0x188], 0                          ; 11CF3  0xC7, 0x06, 0x88, 0x01, 0x00, 0x00

loc_11CF9:                                     ; 11CF9
  cmp word [0x188], 0xf                        ; 11CF9  0x83, 0x3E, 0x88, 0x01, 0x0F
  ja loc_11D39                                 ; 11CFE  0x77, 0x39
  mov ax, [0x18c]                              ; 11D00  0xA1, 0x8C, 0x01
  and ax, [0x18a]                              ; 11D03  0x23, 0x06, 0x8A, 0x01
  cmp ax, 0                                    ; 11D07  0x83, 0xF8, 0x00
  je loc_11D2E                                 ; 11D0A  0x74, 0x22
  mov al, 0x25                                 ; 11D0C  0xB0, 0x25
  push ax                                      ; 11D0E  0x50
  push word [0x18a]                            ; 11D0F  0xFF, 0x36, 0x8A, 0x01
  db 0xE8, 0xBA, 0xFA                          ; 11D13  call 0x117d0
  cmp al, 0                                    ; 11D16  0x3C, 0x00
  je loc_11D2E                                 ; 11D18  0x74, 0x14
  mov ax, [0x188]                              ; 11D1A  0xA1, 0x88, 0x01
  add ax, 0x41                                 ; 11D1D  0x83, 0xC0, 0x41
  mov bl, [0x1a5]                              ; 11D20  0x8A, 0x1E, 0xA5, 0x01
  mov bh, 0                                    ; 11D24  0xB7, 0x00
  mov [bx + 0x194], al                         ; 11D26  0x88, 0x87, 0x94, 0x01
  inc byte [0x1a5]                             ; 11D2A  0xFE, 0x06, 0xA5, 0x01

loc_11D2E:                                     ; 11D2E
  shl word [0x18a], 1                          ; 11D2E  0xD1, 0x26, 0x8A, 0x01
  add word [0x188], 1                          ; 11D32  0x83, 0x06, 0x88, 0x01, 0x01
  jae loc_11CF9                                ; 11D37  0x73, 0xC0

loc_11D39:                                     ; 11D39
  cmp byte [0x1a5], 0                          ; 11D39  0x80, 0x3E, 0xA5, 0x01, 0x00
  ja loc_11D43                                 ; 11D3E  0x77, 0x03
  jmp near loc_11DC8                           ; 11D40  0xE9, 0x85, 0x00

loc_11D43:                                     ; 11D43
  les bx, [0x158]                              ; 11D43  0xC4, 0x1E, 0x58, 0x01
  push es                                      ; 11D47  0x06
  push bx                                      ; 11D48  0x53
  call sub_11907                               ; 11D49  0xE8, 0xBB, 0xFB
  mov al, 0xff                                 ; 11D4C  0xB0, 0xFF
  push ax                                      ; 11D4E  0x50
  mov al, 0                                    ; 11D4F  0xB0, 0x00
  push ax                                      ; 11D51  0x50
  lea ax, [0x1a8]                              ; 11D52  0x8D, 0x06, 0xA8, 0x01
  push ds                                      ; 11D56  0x1E
  push ax                                      ; 11D57  0x50
  call sub_1185E                               ; 11D58  0xE8, 0x03, 0xFB
  mov al, 1                                    ; 11D5B  0xB0, 0x01
  push ax                                      ; 11D5D  0x50
  mov al, 0                                    ; 11D5E  0xB0, 0x00
  push ax                                      ; 11D60  0x50
  lea ax, [0x194]                              ; 11D61  0x8D, 0x06, 0x94, 0x01
  push ds                                      ; 11D65  0x1E
  push ax                                      ; 11D66  0x50
  call sub_1185E                               ; 11D67  0xE8, 0xF4, 0xFA
  mov word [0x188], 1                          ; 11D6A  0xC7, 0x06, 0x88, 0x01, 0x01, 0x00

loc_11D70:                                     ; 11D70
  mov al, [0x1a5]                              ; 11D70  0xA0, 0xA5, 0x01
  dec al                                       ; 11D73  0xFE, 0xC8
  mov ah, 0                                    ; 11D75  0xB4, 0x00
  cmp [0x188], ax                              ; 11D77  0x39, 0x06, 0x88, 0x01
  ja loc_11DA6                                 ; 11D7B  0x77, 0x29
  mov al, 1                                    ; 11D7D  0xB0, 0x01
  push ax                                      ; 11D7F  0x50
  mov al, 0                                    ; 11D80  0xB0, 0x00
  push ax                                      ; 11D82  0x50
  lea ax, [0x1c1]                              ; 11D83  0x8D, 0x06, 0xC1, 0x01
  push ds                                      ; 11D87  0x1E
  push ax                                      ; 11D88  0x50
  call sub_1185E                               ; 11D89  0xE8, 0xD2, 0xFA
  mov al, 1                                    ; 11D8C  0xB0, 0x01
  push ax                                      ; 11D8E  0x50
  mov al, 0                                    ; 11D8F  0xB0, 0x00
  push ax                                      ; 11D91  0x50
  mov bx, [0x188]                              ; 11D92  0x8B, 0x1E, 0x88, 0x01
  lea ax, [bx + 0x194]                         ; 11D96  0x8D, 0x87, 0x94, 0x01
  push ds                                      ; 11D9A  0x1E
  push ax                                      ; 11D9B  0x50
  call sub_1185E                               ; 11D9C  0xE8, 0xBF, 0xFA
  add word [0x188], 1                          ; 11D9F  0x83, 0x06, 0x88, 0x01, 0x01
  jae loc_11D70                                ; 11DA4  0x73, 0xCA

loc_11DA6:                                     ; 11DA6
  mov al, 2                                    ; 11DA6  0xB0, 0x02
  push ax                                      ; 11DA8  0x50
  mov al, 0                                    ; 11DA9  0xB0, 0x00
  push ax                                      ; 11DAB  0x50
  lea ax, [0x1c2]                              ; 11DAC  0x8D, 0x06, 0xC2, 0x01
  push ds                                      ; 11DB0  0x1E
  push ax                                      ; 11DB1  0x50
  call sub_1185E                               ; 11DB2  0xE8, 0xA9, 0xFA
  les bx, [0x158]                              ; 11DB5  0xC4, 0x1E, 0x58, 0x01
  mov byte [es:bx + 5], 0                      ; 11DB9  0x26, 0xC6, 0x47, 0x05, 0x00
  mov byte [es:bx + 6], 0                      ; 11DBE  0x26, 0xC6, 0x47, 0x06, 0x00
  push es                                      ; 11DC3  0x06
  push bx                                      ; 11DC4  0x53
  call sub_1192E                               ; 11DC5  0xE8, 0x66, 0xFB

loc_11DC8:                                     ; 11DC8
  pop bp                                       ; 11DC8  0x5D
  ret                                          ; 11DC9  0xC3

sub_11DCA:                                     ; 11DCA
  push bp                                      ; 11DCA  0x55
  db 0x8B, 0xEC                                ; 11DCB  mov bp, sp
  les bx, [0x144]                              ; 11DCD  0xC4, 0x1E, 0x44, 0x01
  mov ax, [es:bx + 0x22]                       ; 11DD1  0x26, 0x8B, 0x47, 0x22
  and ax, 0x80                                 ; 11DD5  0x25, 0x80, 0x00
  cmp ax, 0                                    ; 11DD8  0x83, 0xF8, 0x00
  je loc_11DE6                                 ; 11DDB  0x74, 0x09
  push word [0x17e]                            ; 11DDD  0xFF, 0x36, 0x7E, 0x01
  call sub_11998                               ; 11DE1  0xE8, 0xB4, 0xFB
  pop bp                                       ; 11DE4  0x5D
  ret                                          ; 11DE5  0xC3

loc_11DE6:                                     ; 11DE6
  les bx, [0x158]                              ; 11DE6  0xC4, 0x1E, 0x58, 0x01
  push word [es:bx + 0x16]                     ; 11DEA  0x26, 0xFF, 0x77, 0x16
  call sub_118AF                               ; 11DEE  0xE8, 0xBE, 0xFA
  les bx, [0x158]                              ; 11DF1  0xC4, 0x1E, 0x58, 0x01
  xor word [es:bx + 0xe], 0x100                ; 11DF5  0x26, 0x81, 0x77, 0x0E, 0x00, 0x01
  push word [es:bx + 0x16]                     ; 11DFB  0x26, 0xFF, 0x77, 0x16
  call sub_118C6                               ; 11DFF  0xE8, 0xC4, 0xFA
  les bx, [0x158]                              ; 11E02  0xC4, 0x1E, 0x58, 0x01
  push es                                      ; 11E06  0x06
  push bx                                      ; 11E07  0x53
  call sub_11944                               ; 11E08  0xE8, 0x39, 0xFB
  mov ax, 8                                    ; 11E0B  0xB8, 0x08, 0x00
  push ax                                      ; 11E0E  0x50
  mov ax, 0                                    ; 11E0F  0xB8, 0x00, 0x00
  push ax                                      ; 11E12  0x50
  les bx, [0x158]                              ; 11E13  0xC4, 0x1E, 0x58, 0x01
  mov al, [es:bx + 0xa]                        ; 11E17  0x26, 0x8A, 0x47, 0x0A
  mov ah, 0                                    ; 11E1B  0xB4, 0x00
  push ax                                      ; 11E1D  0x50
  call sub_11800                               ; 11E1E  0xE8, 0xDF, 0xF9
  pop bp                                       ; 11E21  0x5D
  ret                                          ; 11E22  0xC3

sub_11E23:                                     ; 11E23
  push bp                                      ; 11E23  0x55
  db 0x8B, 0xEC                                ; 11E24  mov bp, sp
  les bx, [0x158]                              ; 11E26  0xC4, 0x1E, 0x58, 0x01
  push word [es:bx + 0x16]                     ; 11E2A  0x26, 0xFF, 0x77, 0x16
  call sub_118AF                               ; 11E2E  0xE8, 0x7E, 0xFA
  les bx, [0x158]                              ; 11E31  0xC4, 0x1E, 0x58, 0x01
  and word [es:bx + 0xe], 0xfeff               ; 11E35  0x26, 0x81, 0x67, 0x0E, 0xFF, 0xFE
  push word [es:bx + 0x16]                     ; 11E3B  0x26, 0xFF, 0x77, 0x16
  call sub_118C6                               ; 11E3F  0xE8, 0x84, 0xFA
  les bx, [0x158]                              ; 11E42  0xC4, 0x1E, 0x58, 0x01
  push es                                      ; 11E46  0x06
  push bx                                      ; 11E47  0x53
  call sub_11944                               ; 11E48  0xE8, 0xF9, 0xFA
  mov ax, 8                                    ; 11E4B  0xB8, 0x08, 0x00
  push ax                                      ; 11E4E  0x50
  mov ax, 0                                    ; 11E4F  0xB8, 0x00, 0x00
  push ax                                      ; 11E52  0x50
  les bx, [0x158]                              ; 11E53  0xC4, 0x1E, 0x58, 0x01
  mov al, [es:bx + 0xa]                        ; 11E57  0x26, 0x8A, 0x47, 0x0A
  mov ah, 0                                    ; 11E5B  0xB4, 0x00
  push ax                                      ; 11E5D  0x50
  call sub_11800                               ; 11E5E  0xE8, 0x9F, 0xF9
  pop bp                                       ; 11E61  0x5D
  ret                                          ; 11E62  0xC3

sub_11E63:                                     ; 11E63
  push bp                                      ; 11E63  0x55
  db 0x8B, 0xEC                                ; 11E64  mov bp, sp
  les bx, [0x144]                              ; 11E66  0xC4, 0x1E, 0x44, 0x01
  mov ax, [es:bx + 6]                          ; 11E6A  0x26, 0x8B, 0x47, 0x06
  and ax, 0x1000                               ; 11E6E  0x25, 0x00, 0x10
  cmp ax, 0                                    ; 11E71  0x83, 0xF8, 0x00
  je loc_11E78                                 ; 11E74  0x74, 0x02
  pop bp                                       ; 11E76  0x5D
  ret                                          ; 11E77  0xC3

loc_11E78:                                     ; 11E78
  les bx, [0x144]                              ; 11E78  0xC4, 0x1E, 0x44, 0x01
  mov ax, [es:bx + 0x22]                       ; 11E7C  0x26, 0x8B, 0x47, 0x22
  and ax, strict word 2                        ; 11E80  25 02 00
  cmp ax, 0                                    ; 11E83  0x83, 0xF8, 0x00
  je loc_11E91                                 ; 11E86  0x74, 0x09
  push word [0x17e]                            ; 11E88  0xFF, 0x36, 0x7E, 0x01
  call sub_11998                               ; 11E8C  0xE8, 0x09, 0xFB
  pop bp                                       ; 11E8F  0x5D
  ret                                          ; 11E90  0xC3

loc_11E91:                                     ; 11E91
  les bx, [0x158]                              ; 11E91  0xC4, 0x1E, 0x58, 0x01
  push word [es:bx + 0x16]                     ; 11E95  0x26, 0xFF, 0x77, 0x16
  call sub_118AF                               ; 11E99  0xE8, 0x13, 0xFA
  les bx, [0x158]                              ; 11E9C  0xC4, 0x1E, 0x58, 0x01
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
  call sub_11800                               ; 11EBD  0xE8, 0x40, 0xF9
  les bx, [0x158]                              ; 11EC0  0xC4, 0x1E, 0x58, 0x01
  push word [es:bx + 0x16]                     ; 11EC4  0x26, 0xFF, 0x77, 0x16
  call sub_118C6                               ; 11EC8  0xE8, 0xFB, 0xF9
  mov byte [0x193], 0xff                       ; 11ECB  0xC6, 0x06, 0x93, 0x01, 0xFF
  pop bp                                       ; 11ED0  0x5D
  ret                                          ; 11ED1  0xC3

sub_11ED2:                                     ; 11ED2
  push bp                                      ; 11ED2  0x55
  db 0x8B, 0xEC                                ; 11ED3  mov bp, sp
  les bx, [0x158]                              ; 11ED5  0xC4, 0x1E, 0x58, 0x01
  push word [es:bx + 0x16]                     ; 11ED9  0x26, 0xFF, 0x77, 0x16
  call sub_118AF                               ; 11EDD  0xE8, 0xCF, 0xF9
  les bx, [0x158]                              ; 11EE0  0xC4, 0x1E, 0x58, 0x01
  and word [es:bx + 0xe], 0xff7f               ; 11EE4  0x26, 0x81, 0x67, 0x0E, 0x7F, 0xFF
  push word [es:bx + 0x16]                     ; 11EEA  0x26, 0xFF, 0x77, 0x16
  call sub_118C6                               ; 11EEE  0xE8, 0xD5, 0xF9
  les bx, [0x158]                              ; 11EF1  0xC4, 0x1E, 0x58, 0x01
  push es                                      ; 11EF5  0x06
  push bx                                      ; 11EF6  0x53
  call sub_11944                               ; 11EF7  0xE8, 0x4A, 0xFA
  les bx, [0x158]                              ; 11EFA  0xC4, 0x1E, 0x58, 0x01
  lea ax, [bx + 0x24]                          ; 11EFE  0x8D, 0x47, 0x24
  push ax                                      ; 11F01  0x50
  call sub_118F2                               ; 11F02  0xE8, 0xED, 0xF9
  mov ax, 8                                    ; 11F05  0xB8, 0x08, 0x00
  push ax                                      ; 11F08  0x50
  mov ax, 0                                    ; 11F09  0xB8, 0x00, 0x00
  push ax                                      ; 11F0C  0x50
  les bx, [0x158]                              ; 11F0D  0xC4, 0x1E, 0x58, 0x01
  mov al, [es:bx + 0xa]                        ; 11F11  0x26, 0x8A, 0x47, 0x0A
  mov ah, 0                                    ; 11F15  0xB4, 0x00
  push ax                                      ; 11F17  0x50
  call sub_11800                               ; 11F18  0xE8, 0xE5, 0xF8
  mov byte [0x193], 0                          ; 11F1B  0xC6, 0x06, 0x93, 0x01, 0x00
  pop bp                                       ; 11F20  0x5D
  ret                                          ; 11F21  0xC3

sub_11F22:                                     ; 11F22
  push bp                                      ; 11F22  0x55
  db 0x8B, 0xEC                                ; 11F23  mov bp, sp
  les bx, [0x144]                              ; 11F25  0xC4, 0x1E, 0x44, 0x01
  mov ax, [es:bx + 0x22]                       ; 11F29  0x26, 0x8B, 0x47, 0x22
  and ax, strict word 4                        ; 11F2D  25 04 00
  cmp ax, 0                                    ; 11F30  0x83, 0xF8, 0x00
  je loc_11F3E                                 ; 11F33  0x74, 0x09
  push word [0x17e]                            ; 11F35  0xFF, 0x36, 0x7E, 0x01
  call sub_11998                               ; 11F39  0xE8, 0x5C, 0xFA
  pop bp                                       ; 11F3C  0x5D
  ret                                          ; 11F3D  0xC3

loc_11F3E:                                     ; 11F3E
  call sub_11E23                               ; 11F3E  0xE8, 0xE2, 0xFE
  les bx, [0x158]                              ; 11F41  0xC4, 0x1E, 0x58, 0x01
  push word [es:bx + 0x16]                     ; 11F45  0x26, 0xFF, 0x77, 0x16
  call sub_118AF                               ; 11F49  0xE8, 0x63, 0xF9
  les bx, [0x158]                              ; 11F4C  0xC4, 0x1E, 0x58, 0x01
  mov ax, [es:bx + 0xe]                        ; 11F50  0x26, 0x8B, 0x47, 0x0E
  and ax, 0x200                                ; 11F54  0x25, 0x00, 0x02
  mov cx, 0                                    ; 11F57  0xB9, 0x00, 0x00
  db 0x3B, 0xC1                                ; 11F5A  cmp ax, cx
  je loc_11F61                                 ; 11F5C  0x74, 0x03
  jmp near loc_12036                           ; 11F5E  0xE9, 0xD5, 0x00

loc_11F61:                                     ; 11F61
  les bx, [0x144]                              ; 11F61  0xC4, 0x1E, 0x44, 0x01
  mov al, [es:bx + 0x24]                       ; 11F65  0x26, 0x8A, 0x47, 0x24
  mov ah, 0                                    ; 11F69  0xB4, 0x00
  mov dx, 0xa                                  ; 11F6B  0xBA, 0x0A, 0x00
  db 0xF7, 0xE2                                ; 11F6E  mul dx
  les si, [0x140]                              ; 11F70  0xC4, 0x36, 0x40, 0x01
  add ax, [es:si + 0x86]                       ; 11F74  0x26, 0x03, 0x84, 0x86, 0x00
  mov [0x160], ax                              ; 11F79  0xA3, 0x60, 0x01
  cli                                          ; 11F7C  0xFA
  mov byte [0x190], 0xff                       ; 11F7D  0xC6, 0x06, 0x90, 0x01, 0xFF
  mov al, [es:si + 0x46]                       ; 11F82  0x26, 0x8A, 0x44, 0x46
  and al, 0x40                                 ; 11F86  0x24, 0x40
  db 0x3A, 0xC1                                ; 11F88  cmp al, cl
  je loc_11FD3                                 ; 11F8A  0x74, 0x47
  mov es, [0x146]                              ; 11F8C  0x8E, 0x06, 0x46, 0x01
  cmp [es:bx + 0x1c], cx                       ; 11F90  0x26, 0x39, 0x4F, 0x1C
  je loc_11FD3                                 ; 11F94  0x74, 0x3D
  mov ax, [es:bx + 0x1c]                       ; 11F96  0x26, 0x8B, 0x47, 0x1C
  mov [0x14e], ax                              ; 11F9A  0xA3, 0x4E, 0x01
  mov [0x14c], cx                              ; 11F9D  0x89, 0x0E, 0x4C, 0x01
  les si, [0x14c]                              ; 11FA1  0xC4, 0x36, 0x4C, 0x01
  les ax, [es:si + 4]                          ; 11FA5  0x26, 0xC4, 0x44, 0x04
  mov [0x150], ax                              ; 11FA9  0xA3, 0x50, 0x01
  mov [0x152], es                              ; 11FAC  0x8C, 0x06, 0x52, 0x01
  mov es, [0x146]                              ; 11FB0  0x8E, 0x06, 0x46, 0x01
  mov dl, [es:bx + 0x24]                       ; 11FB4  0x26, 0x8A, 0x57, 0x24
  mov dh, 0                                    ; 11FB8  0xB6, 0x00
  shl dx, 1                                    ; 11FBA  0xD1, 0xE2
  mov bx, ax                                   ; 11FBC  0x89, 0xC3
  mov si, dx                                   ; 11FBE  0x89, 0xD6
  mov es, [0x152]                              ; 11FC0  0x8E, 0x06, 0x52, 0x01
  mov ax, [es:bx + si + 0x42]                  ; 11FC4  0x26, 0x8B, 0x40, 0x42
  and ax, 0x80                                 ; 11FC8  0x25, 0x80, 0x00
  db 0x3B, 0xC1                                ; 11FCB  cmp ax, cx
  je loc_11FD3                                 ; 11FCD  0x74, 0x04
  mov [0x190], cl                              ; 11FCF  0x88, 0x0E, 0x90, 0x01

loc_11FD3:                                     ; 11FD3
  les bx, [0x160]                              ; 11FD3  0xC4, 0x1E, 0x60, 0x01
  cmp word [es:bx], 0                          ; 11FD7  0x26, 0x83, 0x3F, 0x00
  jne loc_12008                                ; 11FDB  0x75, 0x2B
  mov al, [0x190]                              ; 11FDD  0xA0, 0x90, 0x01
  rcr al, 1                                    ; 11FE0  0xD0, 0xD8
  jae loc_12008                                ; 11FE2  0x73, 0x24
  mov word [es:bx], 0xffff                     ; 11FE4  0x26, 0xC7, 0x07, 0xFF, 0xFF
  mov al, [0x191]                              ; 11FE9  0xA0, 0x91, 0x01
  mov [es:bx + 9], al                          ; 11FEC  0x26, 0x88, 0x47, 0x09
  les bx, [0x144]                              ; 11FF0  0xC4, 0x1E, 0x44, 0x01
  mov al, [es:bx + 0x24]                       ; 11FF4  0x26, 0x8A, 0x47, 0x24
  les bx, [0x158]                              ; 11FF8  0xC4, 0x1E, 0x58, 0x01
  mov [es:bx + 8], al                          ; 11FFC  0x26, 0x88, 0x47, 0x08
  or word [es:bx + 0xe], 0x200                 ; 12000  0x26, 0x81, 0x4F, 0x0E, 0x00, 0x02
  jmp short loc_1207F                          ; 12006  0xEB, 0x77

loc_12008:                                     ; 12008
  sti                                          ; 12008  0xFB
  les bx, [0x158]                              ; 12009  0xC4, 0x1E, 0x58, 0x01
  push es                                      ; 1200D  0x06
  push bx                                      ; 1200E  0x53
  call sub_11907                               ; 1200F  0xE8, 0xF5, 0xF8
  mov al, 0xff                                 ; 12012  0xB0, 0xFF
  push ax                                      ; 12014  0x50
  mov al, 0                                    ; 12015  0xB0, 0x00
  push ax                                      ; 12017  0x50
  lea ax, [0x1c4]                              ; 12018  0x8D, 0x06, 0xC4, 0x01
  push ds                                      ; 1201C  0x1E
  push ax                                      ; 1201D  0x50
  call sub_1185E                               ; 1201E  0xE8, 0x3D, 0xF8
  les bx, [0x158]                              ; 12021  0xC4, 0x1E, 0x58, 0x01
  mov byte [es:bx + 6], 0                      ; 12025  0x26, 0xC6, 0x47, 0x06, 0x00
  mov byte [es:bx + 5], 0                      ; 1202A  0x26, 0xC6, 0x47, 0x05, 0x00
  push es                                      ; 1202F  0x06
  push bx                                      ; 12030  0x53
  call sub_1192E                               ; 12031  0xE8, 0xFA, 0xF8
  jmp short loc_12080                          ; 12034  0xEB, 0x4A

loc_12036:                                     ; 12036
  cli                                          ; 12036  0xFA
  les bx, [0x158]                              ; 12037  0xC4, 0x1E, 0x58, 0x01
  mov al, [es:bx + 8]                          ; 1203B  0x26, 0x8A, 0x47, 0x08
  mov ah, 0                                    ; 1203F  0xB4, 0x00
  mov cx, 0xa                                  ; 12041  0xB9, 0x0A, 0x00
  db 0xF7, 0xE1                                ; 12044  mul cx
  les si, [0x140]                              ; 12046  0xC4, 0x36, 0x40, 0x01
  add ax, [es:si + 0x86]                       ; 1204A  0x26, 0x03, 0x84, 0x86, 0x00
  mov [0x160], ax                              ; 1204F  0xA3, 0x60, 0x01
  les si, [0x160]                              ; 12052  0xC4, 0x36, 0x60, 0x01
  mov word [es:si], 0                          ; 12056  0x26, 0xC7, 0x04, 0x00, 0x00
  mov byte [es:si + 9], 0xff                   ; 1205B  0x26, 0xC6, 0x44, 0x09, 0xFF
  mov es, [0x15a]                              ; 12060  0x8E, 0x06, 0x5A, 0x01
  mov byte [es:bx + 8], 0xff                   ; 12064  0x26, 0xC6, 0x47, 0x08, 0xFF
  and word [es:bx + 0xe], 0xfdff               ; 12069  0x26, 0x81, 0x67, 0x0E, 0xFF, 0xFD
  and byte [es:bx + 4], 0xdf                   ; 1206F  0x26, 0x80, 0x67, 0x04, 0xDF
  mov es, [0x162]                              ; 12074  0x8E, 0x06, 0x62, 0x01
  lea ax, [si + 2]                             ; 12078  0x8D, 0x44, 0x02
  push ax                                      ; 1207B  0x50
  call sub_118F2                               ; 1207C  0xE8, 0x73, 0xF8

loc_1207F:                                     ; 1207F
  sti                                          ; 1207F  0xFB

loc_12080:                                     ; 12080
  les bx, [0x158]                              ; 12080  0xC4, 0x1E, 0x58, 0x01
  push word [es:bx + 0x16]                     ; 12084  0x26, 0xFF, 0x77, 0x16
  call sub_118C6                               ; 12088  0xE8, 0x3B, 0xF8
  mov ax, 8                                    ; 1208B  0xB8, 0x08, 0x00
  push ax                                      ; 1208E  0x50
  mov ax, 0                                    ; 1208F  0xB8, 0x00, 0x00
  push ax                                      ; 12092  0x50
  les bx, [0x158]                              ; 12093  0xC4, 0x1E, 0x58, 0x01
  mov al, [es:bx + 0xa]                        ; 12097  0x26, 0x8A, 0x47, 0x0A
  mov ah, 0                                    ; 1209B  0xB4, 0x00
  push ax                                      ; 1209D  0x50
  call sub_11800                               ; 1209E  0xE8, 0x5F, 0xF7
  pop bp                                       ; 120A1  0x5D
  ret                                          ; 120A2  0xC3

sub_120A3:                                     ; 120A3
  push bp                                      ; 120A3  0x55
  db 0x8B, 0xEC                                ; 120A4  mov bp, sp
  les bx, [0x158]                              ; 120A6  0xC4, 0x1E, 0x58, 0x01
  mov ax, [es:bx]                              ; 120AA  0x26, 0x8B, 0x07
  mov [0x144], ax                              ; 120AD  0xA3, 0x44, 0x01
  cmp ax, 0                                    ; 120B0  0x83, 0xF8, 0x00
  je loc_120CC                                 ; 120B3  0x74, 0x17
  les bx, [0x144]                              ; 120B5  0xC4, 0x1E, 0x44, 0x01
  mov ax, [es:bx + 6]                          ; 120B9  0x26, 0x8B, 0x47, 0x06
  and ax, strict word 0x40                     ; 120BD  25 40 00
  cmp ax, 0                                    ; 120C0  0x83, 0xF8, 0x00
  jne loc_120C9                                ; 120C3  0x75, 0x04
  mov al, 0                                    ; 120C5  0xB0, 0x00
  pop bp                                       ; 120C7  0x5D
  ret                                          ; 120C8  0xC3

loc_120C9:                                     ; 120C9
  call sub_11ED2                               ; 120C9  0xE8, 0x06, 0xFE

loc_120CC:                                     ; 120CC
  mov al, 0xff                                 ; 120CC  0xB0, 0xFF
  pop bp                                       ; 120CE  0x5D
  ret                                          ; 120CF  0xC3
  push bp                                      ; 120D0  0x55
  db 0x8B, 0xEC                                ; 120D1  mov bp, sp
  mov ax, [0]                                  ; 120D3  0xA1, 0x00, 0x00
  mov [0x142], ax                              ; 120D6  0xA3, 0x42, 0x01
  mov [0x162], ax                              ; 120D9  0xA3, 0x62, 0x01
  mov [0x15a], ax                              ; 120DC  0xA3, 0x5A, 0x01
  mov [0x182], ax                              ; 120DF  0xA3, 0x82, 0x01
  mov [0x186], ax                              ; 120E2  0xA3, 0x86, 0x01
  les bx, [0x140]                              ; 120E5  0xC4, 0x1E, 0x40, 0x01
  mov ax, [es:bx + 0x54]                       ; 120E9  0x26, 0x8B, 0x47, 0x54
  mov [0x158], ax                              ; 120ED  0xA3, 0x58, 0x01
  mov byte [0x18f], 0                          ; 120F0  0xC6, 0x06, 0x8F, 0x01, 0x00

loc_120F5:                                     ; 120F5
  les bx, [0x158]                              ; 120F5  0xC4, 0x1E, 0x58, 0x01
  mov al, [es:bx + 0xa]                        ; 120F9  0x26, 0x8A, 0x47, 0x0A
  cmp al, [4]                                  ; 120FD  0x3A, 0x06, 0x04, 0x00
  je loc_1210A                                 ; 12101  0x74, 0x07
  add word [0x158], 0x2c                       ; 12103  0x83, 0x06, 0x58, 0x01, 0x2C
  jmp short loc_120F5                          ; 12108  0xEB, 0xEB

loc_1210A:                                     ; 1210A
  les bx, [0x158]                              ; 1210A  0xC4, 0x1E, 0x58, 0x01
  mov al, [es:bx + 0xb]                        ; 1210E  0x26, 0x8A, 0x47, 0x0B
  mov [0x18f], al                              ; 12112  0xA2, 0x8F, 0x01
  mov byte [0x18e], 1                          ; 12115  0xC6, 0x06, 0x8E, 0x01, 0x01

loc_1211A:                                     ; 1211A
  les bx, [0x158]                              ; 1211A  0xC4, 0x1E, 0x58, 0x01
  cmp word [es:bx + 0x28], 0                   ; 1211E  0x26, 0x83, 0x7F, 0x28, 0x00
  je loc_12132                                 ; 12123  0x74, 0x0D
  inc byte [0x18e]                             ; 12125  0xFE, 0x06, 0x8E, 0x01
  mov ax, [es:bx + 0x28]                       ; 12129  0x26, 0x8B, 0x47, 0x28
  mov [0x158], ax                              ; 1212D  0xA3, 0x58, 0x01
  jmp short loc_1211A                          ; 12130  0xEB, 0xE8

loc_12132:                                     ; 12132
  mov al, [0x18f]                              ; 12132  0xA0, 0x8F, 0x01
  mov ah, 0                                    ; 12135  0xB4, 0x00
  mov cx, 0x2c                                 ; 12137  0xB9, 0x2C, 0x00
  db 0xF7, 0xE1                                ; 1213A  mul cx
  les bx, [0x140]                              ; 1213C  0xC4, 0x1E, 0x40, 0x01
  add ax, [es:bx + 0x54]                       ; 12140  0x26, 0x03, 0x47, 0x54
  mov [0x158], ax                              ; 12144  0xA3, 0x58, 0x01
  mov al, 0x9c                                 ; 12147  0xB0, 0x9C
  push ax                                      ; 12149  0x50
  mov ax, 0                                    ; 1214A  0xB8, 0x00, 0x00
  push ax                                      ; 1214D  0x50
  db 0xE8, 0x7F, 0xF6                          ; 1214E  call 0x117d0
  mov [0x144], bx                              ; 12151  0x89, 0x1E, 0x44, 0x01
  mov [0x146], es                              ; 12155  0x8C, 0x06, 0x46, 0x01
  mov al, [0x18f]                              ; 12159  0xA0, 0x8F, 0x01
  mov [0x191], al                              ; 1215C  0xA2, 0x91, 0x01
  les bx, [0x158]                              ; 1215F  0xC4, 0x1E, 0x58, 0x01
  mov al, [es:bx + 0xa]                        ; 12163  0x26, 0x8A, 0x47, 0x0A
  mov ah, 0                                    ; 12167  0xB4, 0x00
  mov [0x164], ax                              ; 12169  0xA3, 0x64, 0x01
  mov cl, 8                                    ; 1216C  0xB1, 0x08
  shl ax, cl                                   ; 1216E  0xD3, 0xE0
  mov cl, [es:bx + 0xb]                        ; 12170  0x26, 0x8A, 0x4F, 0x0B
  mov ch, 0                                    ; 12174  0xB5, 0x00
  db 0x03, 0xC1                                ; 12176  add ax, cx
  mov [0x164], ax                              ; 12178  0xA3, 0x64, 0x01

loc_1217B:                                     ; 1217B
  call sub_11822                               ; 1217B  0xE8, 0xA4, 0xF6
  cmp byte [0x17f], 0xff                       ; 1217E  0x80, 0x3E, 0x7F, 0x01, 0xFF
  jne loc_1218A                                ; 12183  0x75, 0x05
  call sub_11A0E                               ; 12185  0xE8, 0x86, 0xF8
  jmp short loc_1217B                          ; 12188  0xEB, 0xF1

loc_1218A:                                     ; 1218A
  mov al, [0x17f]                              ; 1218A  0xA0, 0x7F, 0x01
  and al, 1                                    ; 1218D  0x24, 0x01
  cmp al, 0                                    ; 1218F  0x3C, 0x00
  jne loc_1219A                                ; 12191  0x75, 0x07
  call sub_120A3                               ; 12193  0xE8, 0x0D, 0xFF
  rcr al, 1                                    ; 12196  0xD0, 0xD8
  jae loc_121A3                                ; 12198  0x73, 0x09

loc_1219A:                                     ; 1219A
  push word [0x17e]                            ; 1219A  0xFF, 0x36, 0x7E, 0x01
  call sub_11998                               ; 1219E  0xE8, 0xF7, 0xF7
  jmp short loc_1217B                          ; 121A1  0xEB, 0xD8

loc_121A3:                                     ; 121A3
  mov al, [0x193]                              ; 121A3  0xA0, 0x93, 0x01
  rcr al, 1                                    ; 121A6  0xD0, 0xD8
  jae loc_121EE                                ; 121A8  0x73, 0x44
  cmp byte [0x17e], 3                          ; 121AA  0x80, 0x3E, 0x7E, 0x01, 0x03
  je loc_121F5                                 ; 121AF  0x74, 0x44
  cmp byte [0x17e], 0x11                       ; 121B1  0x80, 0x3E, 0x7E, 0x01, 0x11
  jne loc_121BD                                ; 121B6  0x75, 0x05
  call sub_11ED2                               ; 121B8  0xE8, 0x17, 0xFD
  jmp short loc_1217B                          ; 121BB  0xEB, 0xBE

loc_121BD:                                     ; 121BD
  cmp byte [0x17e], 0x10                       ; 121BD  0x80, 0x3E, 0x7E, 0x01, 0x10
  je loc_12219                                 ; 121C2  0x74, 0x55
  les ax, [0x158]                              ; 121C4  0xC4, 0x06, 0x58, 0x01
  push es                                      ; 121C8  0x06
  push ax                                      ; 121C9  0x50
  call sub_11907                               ; 121CA  0xE8, 0x3A, 0xF7
  mov ax, 2                                    ; 121CD  0xB8, 0x02, 0x00
  push ax                                      ; 121D0  0x50
  mov ax, 7                                    ; 121D1  0xB8, 0x07, 0x00
  push ax                                      ; 121D4  0x50
  les bx, [0x158]                              ; 121D5  0xC4, 0x1E, 0x58, 0x01
  mov al, [es:bx + 0xb]                        ; 121D9  0x26, 0x8A, 0x47, 0x0B
  mov ah, 0                                    ; 121DD  0xB4, 0x00
  push ax                                      ; 121DF  0x50
  call sub_11800                               ; 121E0  0xE8, 0x1D, 0xF6
  les ax, [0x158]                              ; 121E3  0xC4, 0x06, 0x58, 0x01
  push es                                      ; 121E7  0x06
  push ax                                      ; 121E8  0x50
  call sub_1192E                               ; 121E9  0xE8, 0x42, 0xF7
  jmp short loc_1217B                          ; 121EC  0xEB, 0x8D

loc_121EE:                                     ; 121EE
  cmp byte [0x17e], 3                          ; 121EE  0x80, 0x3E, 0x7E, 0x01, 0x03
  jne loc_121FA                                ; 121F3  0x75, 0x05

loc_121F5:                                     ; 121F5
  call sub_11C33                               ; 121F5  0xE8, 0x3B, 0xFA

loc_121F8:                                     ; 121F8
  jmp short loc_1217B                          ; 121F8  0xEB, 0x81

loc_121FA:                                     ; 121FA
  cmp byte [0x17e], 0x13                       ; 121FA  0x80, 0x3E, 0x7E, 0x01, 0x13
  jne loc_12206                                ; 121FF  0x75, 0x05
  call sub_11E63                               ; 12201  0xE8, 0x5F, 0xFC
  jmp short loc_121F8                          ; 12204  0xEB, 0xF2

loc_12206:                                     ; 12206
  cmp byte [0x17e], 0xf                        ; 12206  0x80, 0x3E, 0x7E, 0x01, 0x0F
  jne loc_12212                                ; 1220B  0x75, 0x05
  call sub_11DCA                               ; 1220D  0xE8, 0xBA, 0xFB
  jmp short loc_121F8                          ; 12210  0xEB, 0xE6

loc_12212:                                     ; 12212
  cmp byte [0x17e], 0x10                       ; 12212  0x80, 0x3E, 0x7E, 0x01, 0x10
  jne loc_1221E                                ; 12217  0x75, 0x05

loc_12219:                                     ; 12219
  call sub_11F22                               ; 12219  0xE8, 0x06, 0xFD
  jmp short loc_121F8                          ; 1221C  0xEB, 0xDA

loc_1221E:                                     ; 1221E
  les bx, [0x158]                              ; 1221E  0xC4, 0x1E, 0x58, 0x01
  mov ax, [es:bx + 0xe]                        ; 12222  0x26, 0x8B, 0x47, 0x0E
  and ax, 0x100                                ; 12226  0x25, 0x00, 0x01
  cmp ax, 0                                    ; 12229  0x83, 0xF8, 0x00
  je loc_12231                                 ; 1222C  0x74, 0x03
  call sub_11E23                               ; 1222E  0xE8, 0xF2, 0xFB

loc_12231:                                     ; 12231
  jmp near loc_1219A                           ; 12231  0xE9, 0x66, 0xFF
  pop bp                                       ; 12234  0x5D
  ret                                          ; 12235  0xC3
  db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00  ; 12236  ..........
  lahf                                         ; 12240  0x9F
  db 0x11, 0x47, 0x00                          ; 12241  adc word [bx], ax
  db 0x00, 0x00                                ; 12244
  db 0x00, 0x00                                ; 12246
  db 0x00, 0x00                                ; 12248
  db 0x00, 0x00                                ; 1224A
  db 0x00, 0x00                                ; 1224C
  db 0x00, 0x00                                ; 1224E
  db 0x00, 0x00                                ; 12250
  db 0x00, 0x00                                ; 12252
  db 0x00, 0xB4, 0x03, 0x00                    ; 12254  add byte [si + 3], dh
  push si                                      ; 12258  0x56
  dec di                                       ; 12259  0x4F
  push bp                                      ; 1225A  0x55
  push sp                                      ; 1225B  0x54
  xor [bx + si], ah                            ; 1225C  0x30, 0x20
  and [bx + si], ah                            ; 1225E  0x20, 0x20
  add al, 0                                    ; 12260  0x04, 0x00
  db 0x00, 0x00                                ; 12262
  db 0x00, 0x00                                ; 12264
  or [bx + si], al                             ; 12266  0x08, 0x00
  db 0x00, 0x00                                ; 12268
  db 0x00, 0x00                                ; 1226A
  db 0x00, 0x00                                ; 1226C
  db 0x00, 0x00                                ; 1226E
  db 0x00, 0x00                                ; 12270
  db 0x00, 0x00                                ; 12272
  db 0x00, 0x00                                ; 12274
  db 0x00, 0x00                                ; 12276
  db 0x00, 0x00                                ; 12278
  db 0x00, 0x00                                ; 1227A
  db 0x00, 0x00                                ; 1227C
  db 0x00, 0x00                                ; 1227E
  db 0x00, 0x00                                ; 12280
  db 0x00, 0x00                                ; 12282
  db 0x00, 0x00                                ; 12284
  db 0x00, 0x00                                ; 12286
  db 0x00, 0x00                                ; 12288
  db 0x00, 0x00                                ; 1228A
  db 0x00, 0x00                                ; 1228C
  db 0x00, 0x00                                ; 1228E
  db 0x00, 0x00                                ; 12290
  db 0x00, 0x00                                ; 12292
  db 0x00, 0x00                                ; 12294
  db 0x00, 0x00                                ; 12296
  db 0x00, 0x00                                ; 12298
  db 0x00, 0x00                                ; 1229A
  db 0x00, 0x00                                ; 1229C
  db 0x00, 0x00                                ; 1229E
  db 0x00, 0x00                                ; 122A0
  db 0x00, 0x00                                ; 122A2
  db 0x00, 0x00                                ; 122A4
  db 0x00, 0x00                                ; 122A6
  db 0x00, 0x00                                ; 122A8
  db 0x00, 0x00                                ; 122AA
  db 0x00, 0x00                                ; 122AC
  db 0x00, 0x00                                ; 122AE
  db 0x00, 0x00                                ; 122B0
  db 0x00, 0x00                                ; 122B2
  cmp al, [bx + di]                            ; 122B4  0x3A, 0x01
  db 0x00, 0x00                                ; 122B6
  db 0x00, 0x00                                ; 122B8
  db 0x00, 0x00                                ; 122BA
  db 0x00, 0x00                                ; 122BC
  db 0x00, 0x00                                ; 122BE
  db 0x00, 0x00                                ; 122C0
  db 0x00, 0x00                                ; 122C2
  db 0x00, 0x00                                ; 122C4
  db 0x00, 0x00                                ; 122C6
  db 0x00, 0x00                                ; 122C8
  db 0x00, 0x00                                ; 122CA
  db 0x00, 0x00                                ; 122CC
  db 0x00, 0x00                                ; 122CE
  sahf                                         ; 122D0  0x9E
  adc ah, [si + 0x12]                          ; 122D1  0x12, 0x64, 0x12
  adc ah, [fs:si + 0x12]                       ; 122D4  0x64, 0x12, 0x64, 0x12
  db 0x00, 0x00                                ; 122D8
  db 0x00, 0x00                                ; 122DA
  db 0x00, 0x00                                ; 122DC
  db 0x00, 0x00                                ; 122DE
  add [bx + si], ax                            ; 122E0  0x01, 0x00
  db 0x00, 0x00                                ; 122E2
  db 0x00, 0x00                                ; 122E4
  add ah, cl                                   ; 122E6  0x00, 0xCC
  db 0xCC                                      ; 122E8  int3
  db 0xCC                                      ; 122E9  int3
  db 0xCC                                      ; 122EA  int3
  db 0xCC                                      ; 122EB  int3
  db 0xCC                                      ; 122EC  int3
  db 0xCC                                      ; 122ED  int3
  db 0xCC                                      ; 122EE  int3
  db 0xCC                                      ; 122EF  int3
  db 0xCC                                      ; 122F0  int3
  db 0xCC                                      ; 122F1  int3
  db 0xCC                                      ; 122F2  int3
  db 0xCC                                      ; 122F3  int3
  db 0xCC                                      ; 122F4  int3
  db 0xCC                                      ; 122F5  int3
  db 0xCC                                      ; 122F6  int3
  db 0xCC                                      ; 122F7  int3
  db 0xCC                                      ; 122F8  int3
  db 0xCC                                      ; 122F9  int3
  db 0xCC                                      ; 122FA  int3
  db 0xCC                                      ; 122FB  int3
  db 0xCC                                      ; 122FC  int3
  db 0xCC                                      ; 122FD  int3
  db 0xCC                                      ; 122FE  int3
  db 0xCC                                      ; 122FF  int3
  db 0xCC                                      ; 12300  int3
  db 0xCC                                      ; 12301  int3
  db 0xCC                                      ; 12302  int3
  db 0xCC                                      ; 12303  int3
  db 0xCC                                      ; 12304  int3
  db 0xCC                                      ; 12305  int3
  db 0xCC                                      ; 12306  int3
  db 0xCC                                      ; 12307  int3
  db 0xCC                                      ; 12308  int3
  db 0xCC                                      ; 12309  int3
  db 0xCC                                      ; 1230A  int3
  db 0xCC                                      ; 1230B  int3
  db 0xCC                                      ; 1230C  int3
  db 0xCC                                      ; 1230D  int3
  db 0xCC                                      ; 1230E  int3
  db 0xCC                                      ; 1230F  int3
  db 0xCC                                      ; 12310  int3
  db 0xCC                                      ; 12311  int3
  db 0xCC                                      ; 12312  int3
  db 0xCC                                      ; 12313  int3
  db 0xCC                                      ; 12314  int3
  db 0xCC                                      ; 12315  int3
  db 0xCC                                      ; 12316  int3
  db 0xCC                                      ; 12317  int3
  db 0xCC                                      ; 12318  int3
  db 0xCC                                      ; 12319  int3
  db 0xCC                                      ; 1231A  int3
  db 0xCC                                      ; 1231B  int3
  db 0xCC                                      ; 1231C  int3
  db 0xCC                                      ; 1231D  int3
  db 0xCC                                      ; 1231E  int3
  db 0xCC                                      ; 1231F  int3
  db 0xCC                                      ; 12320  int3
  db 0xCC                                      ; 12321  int3
  db 0xCC                                      ; 12322  int3
  db 0xCC                                      ; 12323  int3
  db 0xCC                                      ; 12324  int3
  db 0xCC                                      ; 12325  int3
  db 0xCC                                      ; 12326  int3
  db 0xCC                                      ; 12327  int3
  db 0xCC                                      ; 12328  int3
  db 0xCC                                      ; 12329  int3
  db 0xCC                                      ; 1232A  int3
  db 0xCC                                      ; 1232B  int3
  db 0xCC                                      ; 1232C  int3
  db 0xCC                                      ; 1232D  int3
  db 0xCC                                      ; 1232E  int3
  db 0xCC                                      ; 1232F  int3
  db 0xCC                                      ; 12330  int3
  db 0xCC                                      ; 12331  int3
  db 0xCC                                      ; 12332  int3
  db 0xCC                                      ; 12333  int3
  db 0xCC                                      ; 12334  int3
  db 0xCC                                      ; 12335  int3
  db 0xCC                                      ; 12336  int3
  db 0xCC                                      ; 12337  int3
  db 0xCC                                      ; 12338  int3
  db 0xCC                                      ; 12339  int3
  db 0xCC                                      ; 1233A  int3
  db 0xCC                                      ; 1233B  int3
  db 0xCC                                      ; 1233C  int3
  db 0xCC                                      ; 1233D  int3
  db 0xCC                                      ; 1233E  int3
  db 0xCC                                      ; 1233F  int3
  db 0xCC                                      ; 12340  int3
  db 0xCC                                      ; 12341  int3
  db 0xCC                                      ; 12342  int3
  db 0xCC                                      ; 12343  int3
  db 0xCC                                      ; 12344  int3
  db 0xCC                                      ; 12345  int3
  db 0xCC                                      ; 12346  int3
  db 0xCC                                      ; 12347  int3
  db 0xCC                                      ; 12348  int3
  db 0xCC                                      ; 12349  int3
  db 0xCC                                      ; 1234A  int3
  db 0xCC                                      ; 1234B  int3
  db 0xCC                                      ; 1234C  int3
  db 0xCC                                      ; 1234D  int3
  db 0xCC                                      ; 1234E  int3
  db 0xCC                                      ; 1234F  int3
  db 0xCC                                      ; 12350  int3
  db 0xCC                                      ; 12351  int3
  db 0xCC                                      ; 12352  int3
  db 0xCC                                      ; 12353  int3
  db 0xCC                                      ; 12354  int3
  db 0xCC                                      ; 12355  int3
  db 0xCC                                      ; 12356  int3
  db 0xCC                                      ; 12357  int3
  db 0xCC                                      ; 12358  int3
  db 0xCC                                      ; 12359  int3
  db 0xCC                                      ; 1235A  int3
  db 0xCC                                      ; 1235B  int3
  db 0xCC                                      ; 1235C  int3
  db 0xCC                                      ; 1235D  int3
  db 0xCC                                      ; 1235E  int3
  db 0xCC                                      ; 1235F  int3
  db 0xCC                                      ; 12360  int3
  db 0xCC                                      ; 12361  int3
  db 0xCC                                      ; 12362  int3
  db 0xCC                                      ; 12363  int3
  db 0xCC                                      ; 12364  int3
  db 0xCC                                      ; 12365  int3
  db 0xCC                                      ; 12366  int3
  db 0xCC                                      ; 12367  int3
  db 0xCC                                      ; 12368  int3
  db 0xCC                                      ; 12369  int3
  db 0xCC                                      ; 1236A  int3
  db 0xCC                                      ; 1236B  int3
  db 0xCC                                      ; 1236C  int3
  db 0xCC                                      ; 1236D  int3
  db 0xCC                                      ; 1236E  int3
  db 0xCC                                      ; 1236F  int3
  db 0xCC                                      ; 12370  int3
  db 0xCC                                      ; 12371  int3
  db 0xCC                                      ; 12372  int3
  db 0xCC                                      ; 12373  int3
  db 0xCC                                      ; 12374  int3
  db 0xCC                                      ; 12375  int3
  db 0xCC                                      ; 12376  int3
  db 0xCC                                      ; 12377  int3
  db 0xCC                                      ; 12378  int3
  db 0xCC                                      ; 12379  int3
  add ax, [0]                                  ; 1237A  0x03, 0x06, 0x00, 0x00
  db 0x00, 0x00                                ; 1237E
  db 0x00, 0x00                                ; 12380
  db 0x00, 0x00                                ; 12382
  db 0x00, 0x00                                ; 12384
  db 0x00, 0x00                                ; 12386
  db 0x00, 0x00                                ; 12388
  db 0x00, 0x00                                ; 1238A
  db 0x00, 0x00                                ; 1238C
  db 0x00, 0x00                                ; 1238E
  db 0x00, 0x00                                ; 12390
  db 0xFF, 0xFF, 0xFF                          ; 12392  ...
  inc word [bx + si]                           ; 12395  0xFF, 0x00
  db 0x00, 0x00                                ; 12397
  db 0x00, 0x00                                ; 12399
  db 0x00, 0x00                                ; 1239B
  db 0x00, 0x00                                ; 1239D
  db 0x00, 0x00                                ; 1239F
  add [0x5600], al                             ; 123A1  0x00, 0x06, 0x00, 0x56
  dec di                                       ; 123A5  0x4F
  push bp                                      ; 123A6  0x55
  push sp                                      ; 123A7  0x54
  push cx                                      ; 123A8  0x51
  and [bx + si], ah                            ; 123A9  0x20, 0x20
  and [bp + si], al                            ; 123AB  0x20, 0x02
  add [bx + si], dl                            ; 123AD  0x00, 0x10
  db 0x00, 0x00                                ; 123AF
  db 0x00, 0x00                                ; 123B1
  db 0x00, 0x00                                ; 123B3
  db 0x00, 0x00                                ; 123B5
  add [bp + si + 3], dl                        ; 123B7  0x00, 0x52, 0x03
  db 0x00, 0x00                                ; 123BA
  db 0x00, 0x00                                ; 123BC
  db 0x00, 0x00                                ; 123BE
  db 0x00, 0x00                                ; 123C0
  db 0x00, 0x00                                ; 123C2
  db 0x00, 0x00                                ; 123C4
  db 0x00, 0x00                                ; 123C6
  db 0x00, 0x00                                ; 123C8
  db 0x00, 0x00                                ; 123CA
  db 0x00, 0x00                                ; 123CC
  db 0x00, 0x00                                ; 123CE
  db 0x00, 0x00                                ; 123D0
  db 0x00, 0x00                                ; 123D2
  db 0x00, 0x00                                ; 123D4
  db 0x00, 0x00                                ; 123D6
  db 0x00, 0x00                                ; 123D8
  db 0x00, 0x00                                ; 123DA
  db 0x00, 0x00                                ; 123DC
  db 0x00, 0x00                                ; 123DE
  db 0x00, 0x00                                ; 123E0
  db 0x00, 0x00                                ; 123E2
  db 0x00, 0x00                                ; 123E4
  db 0x00, 0x00                                ; 123E6
  db 0x00, 0x00                                ; 123E8
  db 0x00, 0x00                                ; 123EA
  db 0x00, 0x00                                ; 123EC
  db 0x00, 0x00                                ; 123EE
  db 0x00, 0x00                                ; 123F0
  db 0x00, 0x00                                ; 123F2
  db 0x00, 0x00                                ; 123F4
  db 0x00, 0x00                                ; 123F6
  db 0x00, 0x00                                ; 123F8
  db 0x00, 0x00                                ; 123FA
  db 0x00, 0x00                                ; 123FC
  db 0x00, 0x00                                ; 123FE
  db 0x00, 0x00                                ; 12400
  db 0x00, 0x00                                ; 12402
  db 0x00, 0x00                                ; 12404
  db 0x00, 0x00                                ; 12406
  db 0x00, 0x00                                ; 12408
  db 0x00, 0x00                                ; 1240A
  db 0x00, 0x00                                ; 1240C
  db 0x00, 0x00                                ; 1240E
  db 0x00, 0x00                                ; 12410
  db 0x00, 0x00                                ; 12412
  db 0x00, 0x00                                ; 12414
  db 0x00, 0x00                                ; 12416
  db 0x00, 0x00                                ; 12418
  db 0x00, 0x00                                ; 1241A
  db 0x00, 0x00                                ; 1241C
  db 0x00, 0x00                                ; 1241E
  db 0x00, 0x00                                ; 12420
  db 0x00, 0x00                                ; 12422
  db 0x00, 0x00                                ; 12424
  db 0x00, 0x00                                ; 12426
  db 0x00, 0x00                                ; 12428
  db 0x00, 0x00                                ; 1242A
  db 0x00, 0x00                                ; 1242C
  db 0x00, 0x00                                ; 1242E
  db 0x00, 0x00                                ; 12430
  db 0x00, 0x00                                ; 12432
  db 0x00, 0x00                                ; 12434
  db 0x00, 0x00                                ; 12436
  db 0x00, 0x00                                ; 12438
  db 0x00, 0x00                                ; 1243A
  db 0x00, 0x00                                ; 1243C
  push es                                      ; 1243E  0x06
  add [bp + 0x49], dl                          ; 1243F  0x00, 0x56, 0x49
  dec si                                       ; 12442  0x4E
  push cx                                      ; 12443  0x51
  and [bx + si], ah                            ; 12444  0x20, 0x20
  and [bx + si], ah                            ; 12446  0x20, 0x20
  db 0x02, 0x00                                ; 12448  add al, byte [bx + si]
  inc ax                                       ; 1244A  0x40
  db 0x00, 0x00                                ; 1244B
  db 0x00, 0x00                                ; 1244D
  db 0x00, 0x00                                ; 1244F
  db 0x00, 0x00                                ; 12451
  add [bp + si + 1], bh                        ; 12453  0x00, 0x7A, 0x01
  db 0x00, 0x00                                ; 12456
  db 0x00, 0x00                                ; 12458
  pop es                                       ; 1245A  0x07
  add [bp + 0x43], dl                          ; 1245B  0x00, 0x56, 0x43
  dec bp                                       ; 1245E  0x4D
  pop ax                                       ; 1245F  0x58
  push cx                                      ; 12460  0x51
  and [bx + si], ah                            ; 12461  0x20, 0x20
  and [bx + si], al                            ; 12463  0x20, 0x00
  add [bx + di], al                            ; 12465  0x00, 0x01
  db 0x00, 0x00                                ; 12467
  db 0x00, 0x00                                ; 12469
  db 0x00, 0x00                                ; 1246B
  db 0x00, 0x00                                ; 1246D
  db 0x00, 0x00                                ; 1246F
  db 0x00, 0x00                                ; 12471
  db 0x00, 0x00                                ; 12473
  db 0x00, 0x00                                ; 12475
  db 0x00, 0x00                                ; 12477
  db 0x00, 0x00                                ; 12479
  db 0x00, 0x00                                ; 1247B
  db 0x00, 0x00                                ; 1247D
  db 0x00, 0x00                                ; 1247F
  db 0x00, 0x00                                ; 12481
  db 0x00, 0x00                                ; 12483
  db 0xFF, 0xFF                                ; 12485  ..
  inc word [bx + si]                           ; 12487  0xFF, 0x00
  db 0x00, 0x00                                ; 12489
  db 0x00, 0x00                                ; 1248B
  db 0x00, 0x00                                ; 1248D
  db 0x00, 0x00                                ; 1248F
  db 0x00, 0x00                                ; 12491
  db 0x00, 0x00                                ; 12493
  db 0x00, 0x00                                ; 12495
  db 0x00, 0x00                                ; 12497
  db 0x00, 0x00                                ; 12499
  db 0x00, 0x00                                ; 1249B
  db 0x00, 0x00                                ; 1249D
  db 0x00, 0x00                                ; 1249F
  db 0x00, 0x00                                ; 124A1
  db 0x00, 0x00                                ; 124A3
  db 0x00, 0x00                                ; 124A5
  db 0x00, 0x00                                ; 124A7
  db 0x00, 0x00                                ; 124A9
  db 0x00, 0x00                                ; 124AB
  db 0x00, 0x00                                ; 124AD
  db 0x00, 0x00                                ; 124AF
  db 0x00, 0x00                                ; 124B1
  db 0x00, 0x00                                ; 124B3
  db 0x00, 0x00                                ; 124B5
  db 0x00, 0x00                                ; 124B7
  db 0x00, 0x00                                ; 124B9
  db 0x00, 0x00                                ; 124BB
  db 0x00, 0x00                                ; 124BD
  db 0x00, 0x00                                ; 124BF
  db 0x00, 0x00                                ; 124C1
  db 0x00, 0x00                                ; 124C3
  db 0x00, 0x00                                ; 124C5
  db 0x00, 0x00                                ; 124C7
  db 0x00, 0x00                                ; 124C9
  db 0x00, 0x00                                ; 124CB
  db 0x00, 0x00                                ; 124CD
  db 0x00, 0x00                                ; 124CF
  db 0x00, 0x00                                ; 124D1
  db 0x00, 0x00                                ; 124D3
  db 0x00, 0x00                                ; 124D5
  db 0x00, 0x00                                ; 124D7
  db 0x00, 0x00                                ; 124D9
  db 0x00, 0x00                                ; 124DB
  db 0x00, 0x00                                ; 124DD
  db 0x00, 0x00                                ; 124DF
  db 0x00, 0x00                                ; 124E1
  db 0x00, 0x00                                ; 124E3
  db 0x00, 0x00                                ; 124E5
  db 0x00, 0x00                                ; 124E7
  db 0x00, 0x00                                ; 124E9
  db 0x00, 0x00                                ; 124EB
  db 0x00, 0x00                                ; 124ED
  db 0x00, 0x00                                ; 124EF
  db 0x00, 0x00                                ; 124F1
  db 0x00, 0x00                                ; 124F3
  db 0x00, 0x00                                ; 124F5
  db 0x00, 0x00                                ; 124F7
  db 0x00, 0x00                                ; 124F9
  db 0x00, 0x00                                ; 124FB
  db 0x00, 0x00                                ; 124FD
  db 0x00, 0x00                                ; 124FF
  db 0x00, 0x00                                ; 12501
  db 0x00, 0x00                                ; 12503
  db 0x00, 0x00                                ; 12505
  db 0x00, 0x00                                ; 12507
  db 0x00, 0x00                                ; 12509
  db 0x00, 0x00                                ; 1250B
  db 0x00, 0x00                                ; 1250D
  db 0x00, 0x00                                ; 1250F
  db 0x00, 0x00                                ; 12511
  db 0x00, 0x00                                ; 12513
  db 0x00, 0x00                                ; 12515
  db 0x00, 0x00                                ; 12517
  db 0x00, 0x00                                ; 12519
  db 0x00, 0x00                                ; 1251B
  db 0x00, 0x00                                ; 1251D
  db 0x00, 0x00                                ; 1251F
  db 0x00, 0x00                                ; 12521
  db 0x00, 0x00                                ; 12523
  db 0x00, 0x00                                ; 12525
  db 0x00, 0x00                                ; 12527
  db 0x00, 0x00                                ; 12529
  db 0x00, 0x00                                ; 1252B
  db 0x00, 0x00                                ; 1252D
  db 0x00, 0x00                                ; 1252F
  db 0x00, 0x00                                ; 12531
  db 0x00, 0x00                                ; 12533
  db 0x00, 0x00                                ; 12535
  db 0x00, 0x00                                ; 12537
  db 0x00, 0x00                                ; 12539
  db 0x00, 0x00                                ; 1253B
  db 0x00, 0x00                                ; 1253D
  db 0x00, 0x00                                ; 1253F
  db 0x00, 0x00                                ; 12541
  db 0x00, 0x00                                ; 12543
  db 0x00, 0x00                                ; 12545
  db 0x00, 0x00                                ; 12547
  db 0x00, 0x00                                ; 12549
  db 0x00, 0x00                                ; 1254B
  db 0x00, 0x00                                ; 1254D
  db 0x00, 0x00                                ; 1254F
  db 0x00, 0x00                                ; 12551
  db 0x00, 0x00                                ; 12553
  db 0x00, 0x00                                ; 12555
  db 0x00, 0x00                                ; 12557
  db 0x00, 0x00                                ; 12559
  db 0x00, 0x00                                ; 1255B
  db 0x00, 0x00                                ; 1255D
  db 0x00, 0x00                                ; 1255F
  db 0x00, 0x00                                ; 12561
  db 0x00, 0x00                                ; 12563
  db 0x00, 0x00                                ; 12565
  db 0x00, 0x00                                ; 12567
  db 0x00, 0x00                                ; 12569
  db 0x00, 0x00                                ; 1256B
  db 0x00, 0x00                                ; 1256D
  db 0x00, 0x00                                ; 1256F
  db 0x00, 0x00                                ; 12571
  db 0x00, 0x00                                ; 12573
  db 0x00, 0x00                                ; 12575
  db 0x00, 0x00                                ; 12577
  db 0x00, 0x00                                ; 12579
  db 0x00, 0x00                                ; 1257B
  db 0x00, 0x00                                ; 1257D
  db 0x00, 0x00                                ; 1257F
  db 0x00, 0x00                                ; 12581
  db 0x00, 0x00                                ; 12583
  db 0x00, 0x00                                ; 12585
  db 0x00, 0x00                                ; 12587
  db 0x00, 0x00                                ; 12589
  db 0x00, 0x00                                ; 1258B
  db 0x00, 0x00                                ; 1258D
  db 0x00, 0x00                                ; 1258F
  db 0x00, 0x00                                ; 12591
  db 0x00, 0x00                                ; 12593
  db 0x00, 0x00                                ; 12595
  db 0x00, 0x00                                ; 12597
  db 0x00, 0x00                                ; 12599
  db 0x00, 0x00                                ; 1259B
  db 0x00, 0x00                                ; 1259D
  db 0x00, 0x00                                ; 1259F
  db 0x00, 0x00                                ; 125A1
  db 0x00, 0x00                                ; 125A3
  db 0x00, 0x00                                ; 125A5
  db 0x00, 0x00                                ; 125A7
  db 0x00, 0x00                                ; 125A9
  db 0x00, 0x00                                ; 125AB
  db 0x00, 0x00                                ; 125AD
  db 0x00, 0x00                                ; 125AF
  db 0x00, 0x00                                ; 125B1
  and [bx + si], ah                            ; 125B3  0x20, 0x20
  and [bx + si], ah                            ; 125B5  0x20, 0x20
  and [bx + si], ah                            ; 125B7  0x20, 0x20
  and [bx + si], ah                            ; 125B9  0x20, 0x20
  and al, 0x24                                 ; 125BB  0x24, 0x24
  and al, 0                                    ; 125BD  0x24, 0x00
  db 0x00, 0x00                                ; 125BF
  db 0x00, 0x00                                ; 125C1
  db 0x00, 0x00                                ; 125C3
  db 0x00, 0x00                                ; 125C5
  db 0x00, 0x00                                ; 125C7
  db 0x00, 0x00                                ; 125C9
  db 0x00, 0x00                                ; 125CB
  db 0x00, 0x00                                ; 125CD
  db 0x00, 0x00                                ; 125CF
  db 0x00, 0x00                                ; 125D1
  db 0x00, 0x00                                ; 125D3
  db 0x00, 0x5A, 0x00                          ; 125D5  add byte [bp + si], bl
  db 0x00, 0x00                                ; 125D8
  db 0x00, 0x00                                ; 125DA
  db 0x00, 0x00                                ; 125DC
  db 0x00, 0x00                                ; 125DE
